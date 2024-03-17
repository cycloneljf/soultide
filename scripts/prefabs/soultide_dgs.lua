

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
    local scale = inst.scale
    local a = math.ceil(2*scale - math.log(scale,2)) -- lv1 = 2  lv2 = 3  lv4 = 6 lv8 = 13
    local b = math.floor(scale + math.log(scale,2))  -- lv1 = 1  lv2 = 3  lv4 = 6 lv8 = 11
    inst.components.planardamage:SetBaseDamage(
        TUNING.SOULTIDE.EXTRA +
        b * 6
    )
    inst.components.weapon:SetDamage(
        TUNING.SOULTIDE.DGS.BASEDAMAGE + TUNING.SOULTIDE.EXTRA +
        a * 6
    )
    inst.components.equippable.walkspeedmult = 1 + (b * 0.04 )
    ----------暗影武器，对月亮增伤
    inst.components.damagetypebonus:AddBonus("lunar_aligned", inst, 1 +  b * 0.05)
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
    inst.net_scale :set(inst.scale)
    inst.net_gemE :set(inst.gemE)
    inst.net_shadowE :set(inst.shadowE)
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
    local a = math.ceil(2*scale - math.log(scale,2)) -- lv1 = 2  lv2 = 3  lv4 = 6 lv8 = 13
    local b = math.floor(scale + math.log(scale,2))  -- lv1 = 1  lv2 = 3  lv4 = 6 lv8 = 11
    local wdamage =   TUNING.SOULTIDE.DGS.BASEDAMAGE + TUNING.SOULTIDE.EXTRA +
    a * 6 --武器基础攻击力
    local pdamage = TUNING.SOULTIDE.EXTRA +
    b * 6  --武器位面攻击力
    local line = ( 50 * TUNING.SOULTIDE.WORLDLEVEL - 50 + wdamage + pdamage ) --斩杀线  -- 对于低生命物体 -- 无视防御
    local mount = target.components.health.maxhealth
    local percent = shadowE /(shadowE + 100)  -- 0 到 1  斩杀线   --10级能量加满是0.83
    local killrate = 0.8 * gemE / (gemE + 50)  --0 - 0.8 斩杀率 --10级能量加满是0.72必杀
    --寒冷恐惧
    if target and target.components and target.components.freezable then
        target.components.freezable:AddColdness(0.5 + percent + killrate )
    end
    --特判--对于1下就死 的怪物, 最大血量满足我们的要求
    if target and target.components and attacker and target.components.lootdropper and  mount < line then
        local pt = attacker:GetPosition() --获得vector(x,y,z)
                
        target.components.lootdropper:DropLoot(pt) --需要vector(x,y,z)
        print("收割1！")
    --触发特效
        local fx = SpawnPrefab("shadow_puff")
        fx.Transform:SetPosition(pt:Get()) --需要x,y,z
    end
    --概率秒杀
    if target and target.components and not target.components.health:IsDead() then
        local now = target.components.health:GetPercent()
        local ram = math.random()
        --print("秒杀？" .. mount " <" .. line  )数字上面要写string.format aaa 
        if (now < percent and ram < killrate ) or  mount < line then --初始10%概率秒杀 最高100%
            print("秒杀！")
        --收割1--触发秒杀额外一次战利品--生成在脚下
            if  target and attacker and target.components.lootdropper -- and target.components.lootdropper.loot这个没有，只有掉落的时候才生成的
            then
                local pt = attacker:GetPosition() --获得vector(x,y,z)
                
                target.components.lootdropper:DropLoot(pt) --需要vector(x,y,z)
                print("收割1！")
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
        local tim = math.max(TUNING.SOULTIDE.DGS.CD, 1.1 - b * 0.1)   --冷却时间 0.2 - 1
        --专武加成
        local c = 0.01
        if not inst.components.timer:TimerExists("health_cd1") then
            inst.components.timer:StartTimer("health_cd1",tim)
            if attacker.prefab == "frisia" then
                --print("yes master")
                c = 0.03
            end
            attacker.components.sanity:DoDelta(percent2)
            attacker.components.health:DoDelta( c * percent2 * wdamage )
        end 
    end
    --收割2--攻击时概率额外一个战利品--生成在脚下--与1独立
    if  target and attacker and target.components.lootdropper  --target.components.lootdropper.loot 
    then
        local ram2 = math.random()
        local percent2 =  killrate + 0.1  --(10% - 90%)
        if ram2 <= percent2 then
            local loots = target.components.lootdropper:GenerateLoot()
            local pt = attacker:GetPosition()
            --print("收割2-1！")
            if not inst.components.timer:TimerExists("loot_cd1") then
                inst.components.timer:StartTimer("loot_cd1",math.max(3,24 - b )) --最低三秒,默认CD24s --17级升满 -- 10
                print("收割2！")
            local fx = SpawnPrefab("shadow_puff")
            fx.Transform:SetPosition(pt:Get())
            if loots and #loots ~= nil and #loots >= 1 then  --打岩浆虫的问题
                local loot = loots[math.random(1,#loots)]  --获得随机战利品 注意局部变量
                target.components.lootdropper:SpawnLootPrefab(loot,pt)
            end
            -- SpawnLootPrefab(loot,pt) --纯笨比，一个bug就要修一次,和SpawnPrefab不一样
            end
        end
    end
    --攻速
    if attacker.components.combat then
        attacker.components.combat:SetAttackPeriod( math.min(0.2 ,0.4 - a * 0.02) )
        --print (" period" ..  1 + ((inst.scale -1) * 0.1)) 
    end

    if scale >= TUNING.SOULTIDE.T.T1 then
        --T1攻击特效 + 范围攻击
        local fx = "hitsparks_fx"
        if target ~= nil and target:IsValid() then
            SpawnPrefab(fx):Setup(attacker, target)
        end   
        attacker.components.combat:SetAreaDamage( a, percent , function (ent , inst)
            for _, value in ipairs(TUNING.SOULTIDE.AOE_CANT_TAGS) do
                    if ent:HasTag(value) then
                        return false
                    end
                end
                return true
        end)
    end
    --T2 解锁传送法杖
    --T3 解锁收割加强
end
-----------暗影镰刀的收割
local HARVEST_MUSTTAGS  = {"pickable"}
local HARVEST_CANTTAGS  = {"INLIMBO", "FX"}
local HARVEST_ONEOFTAGS = {"plant", "lichen", "oceanvine", "kelp"}
local function HarvestPickable(inst, ent, doer)
    if ent.components.pickable.picksound ~= nil then
        doer.SoundEmitter:PlaySound(ent.components.pickable.picksound)
    end

    local success, loot = ent.components.pickable:Pick(TheWorld)

    if loot ~= nil then
        for i, item in ipairs(loot) do
            Launch(item, doer, 1.5)
        end
    end
end
local function IsEntityInFront(inst, entity, doer_rotation, doer_pos)
    local facing = Vector3(math.cos(-doer_rotation / RADIANS), 0 , math.sin(-doer_rotation / RADIANS))

    return IsWithinAngle(doer_pos, facing, TUNING.VOIDCLOTH_SCYTHE_HARVEST_ANGLE_WIDTH, entity:GetPosition())
end
local function DoScythe(inst, target, doer)
    --inst:SayRandomLine(STRINGS.VOIDCLOTH_SCYTHE_TALK.onharvest, doer)
    if target.components.pickable ~= nil then
        local doer_pos = doer:GetPosition()
        local x, y, z = doer_pos:Get()

        local doer_rotation = doer.Transform:GetRotation()

        local ents = TheSim:FindEntities(x, y, z, TUNING.VOIDCLOTH_SCYTHE_HARVEST_RADIUS, HARVEST_MUSTTAGS, HARVEST_CANTTAGS, HARVEST_ONEOFTAGS)
        for _, ent in pairs(ents) do
            if ent:IsValid() and ent.components.pickable ~= nil then
                if inst:IsEntityInFront(ent, doer_rotation, doer_pos) then
                    inst:HarvestPickable(ent, doer)
                end
            end
        end
    end
end
-------
local function onequip(inst, owner) --装备
    if not owner:HasTag("player") and owner:HasTag("soultide_sp") then
        owner:DoTaskInTime(0, function()
			local inventory = owner.components.inventory
			if inventory then
				inventory:DropItem(inst)
				if owner.components.talker then owner.components.talker:Say("这不是你能够承受的") end
			end
		end)
    end
                           --替换的动画部件	    使用的动画	         替换的文件夹贴图名字（注意这里也是文件夹的名字）
        owner.AnimState:OverrideSymbol("swap_object","swap_soultide_dgs","swap_soultide_dgs")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
        lighton(inst, owner)
        --owner.DynamicShadow:SetSize(1.7, 1)
end

local function onunequip(inst, owner) --解除装备
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    lightoff(inst)

end


local function dgsmake(mc2) --main c name c
	local mc = "soultide_"..mc2
    STRINGS.NAMES[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.DGS_NAME
	STRINGS.RECIPE_DESC[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.DGS_RECIPE_DESC
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.DGS_CHAG_DESC
    return Prefab(mc,function ()
        local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(mc)  --地上动画
    inst.AnimState:SetBuild(mc)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关
    inst:AddTag("pointy")
    inst:AddTag("weapon")
    inst:AddTag("soultide_E")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.scale = 1
    inst.shadowE = 0
    inst.gemE = 0
    --网络变量
    inst.net_scale  = net_ushortint(inst.GUID, "net_scale")
    inst.net_shadowE = net_ushortint(inst.GUID, "net_shadowE")
    inst.net_gemE = net_ushortint(inst.GUID, "net_gemE")

    inst.net_scale :set(inst.scale) --要写的

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("AbsorbEnergy") --充能组件，感觉不如Trader，后来还魔改了
    -- inst.components.AbsorbEnergy.E.g = 10
    -- inst.components.AbsorbEnergy.E.s = 10

    -------交易 模拟升级---
    inst:AddComponent("trader")

    --武器属性
    inst:AddComponent("weapon") -- 武器组件
    inst.components.weapon:SetDamage(36 + TUNING.SOULTIDE.EXTRA)
    inst.components.weapon:SetOnAttack(onattack) --攻击回调
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
    --可作为镰刀
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.SCYTHE, 5)

    inst:AddComponent("equippable") --可装备组件
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.05 -- 加速 --不要乱动顺序啊，放前面组件都没有，写昏头了
    
    inst:ListenForEvent(("upgrade_Etrade_" .. mc ), update_weapon)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst.DoScythe = DoScythe
    inst.IsEntityInFront = IsEntityInFront
    inst.HarvestPickable = HarvestPickable

    return inst --有笨比不返回
    end,
    assets
)

end

    

return dgsmake("dgs"),
        Prefab("dgs_light",dgs_lightfn)