local assets = 
{
    Asset("ANIM", "anim/soultide_dgs.zip"),  --地上的动画
    Asset("ANIM", "anim/swap_soultide_dgs.zip"),
     --手里的动画
    
	Asset("ATLAS", "images/inventoryimages/soultide_dgs.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/soultide_dgs.tex"),

}

--更新函数
local function update_weapon(inst)

    --if inst.scale  < TUNING.SOULTIDE.DGS.MAX_SCALE and inst.gemE >= 50 * inst.scale  and inst.shadowE >= 50 * inst.scale then
    --     inst.scale = inst.scale + 1
    -- end
    ----------攻击力与速度
    inst.components.planardamage:SetBaseDamage(
        TUNING.SOULTIDE.EXTRA + 
       math.floor(6 *( math.log(inst.scale,4) + (inst.scale - 1)))    -- lv 1 - 0 , lv 4 = 24 , lv 8 = 52  ,lv 16 = 102 , lv 64 = 402
    )
    inst.components.weapon:SetDamage(
        36 + TUNING.SOULTIDE.EXTRA +
        12 * (inst.scale  - 1)
    )
    inst.components.equippable.walkspeedmult = 1 + (inst.scale* 0.05 )
    ----------暗影武器，对月亮增伤
    inst.components.damagetypebonus:AddBonus("lunar_aligned", inst, 0.95+(inst.scale * 0.1))
    -------- 更新网络变量
    inst.net_scale :set(inst.scale)
    inst.net_gemE :set(inst.gemE)
    inst.net_shadowE :set(inst.shadowE)  --注意复制粘贴时候把 net 删掉
    print("update_weapon")
end
--存储
local function onsave(inst,data)
    data.gemE = inst.gemE
    data.shadowE = inst.shadowE
    data.scale = inst.scale
end

local function onload(inst,data)
    if data ~= nil then
    inst.gemE = data.gemE
    inst.shadowE = data.shadowE
    inst.scale = data.scale
    end
    update_weapon(inst)
end
--发光
local function lighton(inst, owner)
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("dgs_light")
    end
    if owner ~= nil  then
        inst._light.entity:SetParent(owner.entity)
    end
	
end

--关灯
local function lightoff(inst)
    if inst._light ~= nil then
            if inst._light:IsValid() then
                inst._light:Remove()
            end
            inst._light = nil
        end
end  

--光源产生
local function dgs_lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

	inst.Light:SetIntensity(0.5)
	inst.Light:SetRadius(10)
	inst.Light:Enable(true)
	inst.Light:SetFalloff(1)
	inst.Light:SetColour(64/255, 64/255, 208/255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function onattack(inst, attacker, target)
    local gemE =  inst.gemE
    local shadowE = inst.shadowE
    local scale = inst.scale
    local wdamage = 36 + TUNING.SOULTIDE.EXTRA +
    12 * (inst.scale  - 1) --武器基础攻击力
    local pdamage = TUNING.SOULTIDE.EXTRA + math.floor(6 *( math.log(inst.scale,4) + (inst.scale - 1)))  --武器位面攻击力

    --寒冷恐惧
    if target and target.components and target.components.freezable then
        target.components.freezable:AddColdness(0.5 + shadowE * 0.02)  
    end
    --概率秒杀
    if target and target.components and not target.components.health:IsDead() then
        local now = target.components.health:GetPercent()
        local percent = shadowE /(shadowE + 100)  -- 0 到 1  斩杀线   --10级能量加满是83.3%
        local line = ( 50 * TUNING.SOULTIDE.WORLDLEVEL - 50 + wdamage + pdamage ) --斩杀线  -- 对于低生命物体 -- 无视防御
        local killrate = (0.05 + scale * 0.05 + gemE * 0.001 )  -- 斩杀率 --10级能量加满是1.05必杀
        local mount = target.components.health.currenthealth
        local ram = math.random()

        if (now < percent and ram < killrate ) or  mount < line then --初始10%概率秒杀 最高100%
            --print("秒杀！")
        --收割1--触发秒杀额外一次战利品--生成在脚下
            if  target and attacker and target.components.lootdropper -- and target.components.lootdropper.loot这个没有，只有掉落的时候才生成的
            then
                local pt = attacker:GetPosition() --获得vector(x,y,z)
                
                target.components.lootdropper:DropLoot(pt) --需要vector(x,y,z)
                --print("收割1！")
            --触发特效
                local fx = SpawnPrefab("shadow_puff")
                fx.Transform:SetPosition(pt:Get()) --需要x,y,z
                
            end
        
            -- local fx2 = "shock_fx" --太吵了，白写了
            -- if target ~= nil and target:IsValid() then
            --     print("秒杀特效！")
            --     -- SpawnPrefab(fx2):Setup(attacker, target) 不同的特效有不同的方法 一次记得改完ok？
            --     local pt = attacker:GetPosition() --返回(x,y,z) 能一次改完吗 不是 attacker.transport:GetPosition()
            --     SpawnPrefab(fx2).Transform:SetPosition(pt.x,pt.y + 1 ,pt.z)
            -- end

        target.components.health:DoDelta(-mount,nil,(inst.nameoverride or inst.prefab), true, attacker, true)
        end
        if target.components.health:IsDead() then
            attacker:PushEvent("killed", { victim = target })
        end
    end
    --生命汲取
    if  target and attacker then
        local percent2 =  (4  - math.exp( -gemE*0.01 + 1 )) - (4  - math.exp( -gemE*0.01 + 1 ))%0.01  --约为 1.3 - 3.4 (%)
        local tim = math.max(TUNING.SOULTIDE.DGS.CD, 1 - ((scale -1) * 0.1) )   --冷却时间 0.2 - 1
        if not inst.components.timer:TimerExists("health_cd1") then
            inst.components.timer:StartTimer("health_cd1",tim)
            attacker.components.sanity:DoDelta(percent2)
            attacker.components.health:DoDelta(percent2 * wdamage *0.03 )
        end 
    end
    --收割2--攻击时概率额外一个战利品--生成在脚下--与1独立
    if  target and attacker and target.components.lootdropper  --target.components.lootdropper.loot 
    then
        local ram2 = math.random()
        local percent2 =  (0.5 * gemE + 2) / (gemE + 50)  --(4% - 50%)
        if ram2 <= percent2 then
            local loots = target.components.lootdropper:GenerateLoot()
            local pt = attacker:GetPosition()
            --print("收割2-1！")
            if not inst.components.timer:TimerExists("loot_cd1") then
                inst.components.timer:StartTimer("loot_cd1",math.max(3,24 - (scale + math.log(scale,2) ))) --最低三秒,默认CD24s --17级升满 -- 10
                --print("收割2！")
            local fx = SpawnPrefab("shadow_puff")
            fx.Transform:SetPosition(pt:Get())

            local loot = loots[math.random(1,#loots)]  --获得随机战利品
            -- SpawnLootPrefab(loot,pt) --纯笨比，一个bug就要修一次,和SpawnPrefab不一样
            target.components.lootdropper:SpawnLootPrefab(loot,pt)
            end
        end
    end
    --攻击后加速
    if attacker.components.combat then
        attacker.components.combat:SetAttackPeriod(  math.min(0.2 ,0.4 - ((inst.scale -1) * 0.02)) )
        --print (" period" ..  1 + ((inst.scale -1) * 0.1)) 
    end



    if scale >= TUNING.SOULTIDE.DGS.T1 then
        --攻击特效
        local fx = "hitsparks_fx"
        if target ~= nil and target:IsValid() then
            SpawnPrefab(fx):Setup(attacker, target)
        end
    end
end
--检查是否在交易单里
local function check(obj,t)  --物体 表
    local t =  t or TUNING.SOULTIDE.ENERGY_LIST
    local count = 0
    local val = 0
    print("check the prefab is " .. obj.prefab)
    for key, value in pairs(t) do
        if string.match( obj.prefab, key) then
            print("check the prefab match  " .. key)
            count = count + 1
            val = value
        end
    end
    if count ~= 0 then
        return true , val --是一个表
    else
        return false , -1
    end
end
--是否锁住
local function islock(obj)
    if obj.scale == TUNING.SOULTIDE.DGS.T1 or  obj.scale == TUNING.SOULTIDE.DGS.T3  or  obj.scale == TUNING.SOULTIDE.DGS.T2  then
        print("islocked")
        return false
        
    else
        print("onlocked")
        return true
    end
end
--等级更新
local function upscale_weapon(obj)
    local inst = obj
    if inst.scale  < TUNING.SOULTIDE.DGS.MAX_SCALE and inst.gemE >= 50 * inst.scale  and inst.shadowE >= 50 * inst.scale then
        inst.scale = inst.scale + 1
    end
    print("upscale_weapon")
end

--交易函数(升级)
local function OnGetItemFromPlayer(inst, giver, item)
    local limit = 50 * inst.scale
   print("ongetitemfp 1")
    local ac , tab = check(item)
    local ac2 , num = check(item,TUNING.SOULTIDE.UP)
    -- 能量增加，未达到上限时
    if (inst.gemE < limit or inst.shadowE < limit) and ac and tab then --合并if不改判定条件 笨比
        inst.gemE  = math.min(inst.gemE + tab[1] ,limit)
        inst.shadowE = math.min(inst.shadowE + tab[2] ,limit)

        print("ongetitemfp 2")
        print("item prefab is ".. item.prefab .." /".. inst.scale .." /".. inst.gemE .. " /".. inst.shadowE .." /".. tab[1] .." /".. tab[2])
        
        --没限制时自动升级
        if islock(inst) then --锁住是false
            upscale_weapon(inst)
        end
        update_weapon(inst)  --放后面要更新网络变量的
    end
    --达到上限时候
    if  inst.shadowE == limit and inst.gemE == limit and ac2 and inst.scale == num - 1 then
        print("ongetitemfp 3")
        upscale_weapon(inst)
        update_weapon(inst)
    end
end

local function onequip(inst, owner) --装备
                           --替换的动画部件	    使用的动画	         替换的文件夹贴图名字（注意这里也是文件夹的名字）
        owner.AnimState:OverrideSymbol("swap_object","swap_soultide_dgs","swap_soultide_dgs")
       
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        lighton(inst, owner)
        
	-- end
end

local function onunequip(inst, owner) --解除装备
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    lightoff(inst)

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("soultide_dgs")  --地上动画
    inst.AnimState:SetBuild("soultide_dgs")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关
    inst:AddTag("pointy")
    inst:AddTag("weapon")
    inst:AddTag("soultide_weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.scale = 1
    inst.shadowE = 0
    inst.gemE = 0
    --网络变量
    inst.net_scale  = net_ushortint(inst.GUID, "net_scale")
    inst.net_shadowE = net_ushortint(inst.GUID, "net_shadowE")
    inst.net_gemE = net_ushortint(inst.GUID, "net_gemE")

    inst.entity:SetPristine()

    local old_GetDisplayName = inst.GetDisplayName --重定义
    inst.GetDisplayName = function(self,...)
        local str = ""
        local level = inst.net_scale:value()
        local se = inst.net_shadowE:value()
        local ge = inst.net_gemE:value()
        local elimit = level * 50
        local function findquality (inst)
            if inst and inst.scale and inst.net_scale then
                if   level <=  TUNING.SOULTIDE.DGS.T2  and level > TUNING.SOULTIDE.DGS.T1 then
                return "blue"
                elseif level <=  TUNING.SOULTIDE.DGS.T3  and level > TUNING.SOULTIDE.DGS.T2 then
                return "purple"
                elseif level <=  TUNING.SOULTIDE.DGS.T4  and level > TUNING.SOULTIDE.DGS.T3 then
                return "golden"
                elseif level <=  TUNING.SOULTIDE.DGS.T5  and level > TUNING.SOULTIDE.DGS.T4 then
                return "red"
                elseif level <=  TUNING.SOULTIDE.DGS.T6  and level > TUNING.SOULTIDE.DGS.T5 then
                return "crystal"
                else
                    return "green"
                end
            end
        end
        if level == TUNING.SOULTIDE.DGS.T1 and elimit == se and elimit == ge   then
            str = "\r\n等阶["..level .. "] 可突破精良"
            str = str .. "\r\n暗影能量："..se.."/".. elimit
            str = str .. "\r\n宝石能量："..ge.."/".. elimit
        elseif level == TUNING.SOULTIDE.DGS.T2 and elimit == se and elimit == ge   then
                str = "\r\n等阶["..level .. "] 可突破史诗"
                str = str .. "\r\n暗影能量："..se.."/".. elimit
                str = str .. "\r\n宝石能量："..ge.."/".. elimit
        elseif level == TUNING.SOULTIDE.DGS.T3 and elimit == se and elimit == ge   then
                    str = "\r\n等阶["..level .. "] 可突破传说"
                    str = str .. "\r\n暗影能量："..se.."/".. elimit
                    str = str .. "\r\n宝石能量："..ge.."/".. elimit
        else
            str = "_" .. findquality(inst).."\r\n等阶["..level .. "]"
            str = str .. "\r\n暗影能量："..se.."/".. elimit
            str = str .. "\r\n宝石能量："..ge.."/".. elimit
        end
        return old_GetDisplayName(self,...)
        ..str 
    end


    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("AbsorbEnergy") --充能组件，感觉不如Trader
    -- inst.components.AbsorbEnergy.E.g = 10
    -- inst.components.AbsorbEnergy.E.s = 10

    -------交易 模拟升级---
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(
        function(inst, item, giver)	
            print("setacceptright")
            local limit = 50 * inst.scale
            local ac = check(item)
            local ac2 , num = check(item,TUNING.SOULTIDE.UP)
            --能量不足可加能
            if inst.gemE < limit  and  ac then
                return true
            end
            if inst.shadowE < limit and ac then
                return true
            end
            --能量满了才能放进阶
            if inst.gemE == limit and inst.shadowE == limit and ac2 and  inst.scale == num - 1 then
                return true
            end
            --return item and (item.prefab == "opalpreciousgem") 超限以后再说
        end
    )
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader:Enable()

    inst:AddComponent("weapon") -- 武器组件
    inst.components.weapon:SetDamage(36 + TUNING.SOULTIDE.EXTRA)
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetRange(2.4)

    inst:AddComponent("planardamage") --位面伤害
    inst.components.planardamage:SetBaseDamage(TUNING.SOULTIDE.EXTRA)

    inst:AddComponent("damagetypebonus") --阵营伤害
	inst.components.damagetypebonus:AddBonus("shadow_aligned", inst,1)
	inst.components.damagetypebonus:AddBonus("lunar_aligned", inst,1.05)

    inst:AddComponent("timer")

    inst:AddComponent("inspectable") --可检查组件

    inst:AddComponent("inventoryitem") --物品组件
	inst.components.inventoryitem.atlasname = "images/inventoryimages/soultide_dgs.xml" --物品贴图

    inst:AddComponent("equippable") --可装备组件
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.05

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst --有笨比不返回
end

return Prefab("soultide_dgs",fn,assets),
        Prefab("dgs_light",dgs_lightfn)