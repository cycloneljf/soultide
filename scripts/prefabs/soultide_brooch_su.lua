--require "scripts.prefabs.hats"

assets ={
    Asset("ANIM", "anim/soultide_brooch_su.zip"),
    --Asset("ANIM", "anim/swap_soultide_brooch_su.zip"),

    Asset("ATLAS", "images/inventoryimages/soultide_brooch_su.xml"),

}
local function HeatFn(inst, observer)
    if inst and inst.owner then --加空值判断 
        local situ =  TheWorld.state.temperature
        local pt = inst.owner.components.temperature:GetCurrent()
        local i = 2
        if situ >= 20  and pt >= 20 then
            inst.components.heater:SetThermics(false, true) --吸热
            i = 1
        elseif situ <= 10  and pt <= 10 then
            inst.components.heater:SetThermics(true, false) --放热
            i = 3
        else
            inst.components.heater:SetThermics(false, false) --不变
            i = 2
        end
        local emitted_temperatures = {-15,15,45}
        --print("cannoheat")
        return emitted_temperatures[i]
    end
    --print("canheat")
end



local  function update_seaurchin (inst)
    if inst and inst.components then
        local scale = inst.scale
        local lostE = inst.lostE
        local gemE = inst.gemE
        local a = math.ceil(2*scale - math.log(scale,2))
        local b = math.floor(scale + math.log(scale,2))
        ------更新防寒
        if inst.components.insulator then
            inst.components.insulator:SetInsulation(30 + a + b)
        end
        ------更新隔水
        if inst.components.waterproofer then
            inst.components.waterproofer:SetEffectiveness(0.18 + 0.01*a)
        end
        -----更新位面防御
        if inst.components.planardefense then
            inst.components.planardefense:SetBaseDefense(5 + a)
        end
        ----更新对史诗生物减伤
        if inst.components.damagetyperesist then
            inst.components.damagetyperesist:AddResist("epic", inst, math.max(0.96 - a * 0.03 , 0.5 ))
        end
        ---加速
        if inst.components.equippable then
            inst.components.equippable.walkspeedmult = 0.96 + 0.04 * a
        end
        --更新标签和功能
        -- 默认 寒冰弹反 和 温度控制 
        if scale > TUNING.SOULTIDE.T.T1 then  --启动护目镜 ----现在携带在身上也可以控温了
            if not inst:HasTag("goggles") then inst:AddTag("goggles") end
            if inst.components.heater then
                inst.components.heater.carriedheatfn = HeatFn
            end
        end
        if scale > TUNING.SOULTIDE.T.T2 then   --启动冰抗削减 固定减去1 --开启建造护符模式（耗能）--热交换效率提高
            inst.components.heater.carriedheatmultiplier = 2.1 
        end
        if  scale > TUNING.SOULTIDE.T.T3  then  -- --寒冰弹反控制加强 --红冰 --增加20%对可冰冻物体易伤
            
        end
        if  scale > TUNING.SOULTIDE.T.T4  then   --建造护符无耗能 --催眠护盾 --懒人护符一次拾取多个
        
        end
        if  scale > TUNING.SOULTIDE.T.T5  then   --各级属性上限提升
        
        end
        inst.net_scale :set(inst.scale)
        inst.net_lostE :set(inst.lostE)
        inst.net_gemE :set(inst.gemE)
    end
end

--来自懒人护符
local function pickup(inst, owner)
    local item = FindPickupableItem(owner, TUNING.ORANGEAMULET_RANGE, false) --半径为4
    if item == nil then
        return
    end

    local didpickup = false     --检测到陷阱时候 直接收获而不是获得陷阱
    if item.components.trap ~= nil then
        item.components.trap:Harvest(owner)
        didpickup = true
    end

    --检测和猪王玩捡金子小游戏的作弊器
    if inst and inst.scale <= TUNING.SOULTIDE.T.T1 then
        if owner.components.minigame_participator ~= nil then
            local minigame = owner.components.minigame_participator:GetMinigame()
            if minigame ~= nil then
                minigame:PushEvent("pickupcheat", { cheater = owner, item = item })
            end
        end
    end
    
    --Amulet will only ever pick up items one at a time. Even from stacks. 特效
    SpawnPrefab("shadow_puff").Transform:SetPosition(item.Transform:GetWorldPosition())
    --只捡可堆叠的
    if not didpickup then
        local item_pos = item:GetPosition()
        if item.components.stackable ~= nil then
            local num = 1
            if inst and inst.scale >= TUNING.SOULTIDE.T.T2 then
                num = math.min(1 + inst.scale , item.components.stackable:StackSize())
            end
            item = item.components.stackable:Get(num) --这里添加数量
        end

        owner.components.inventory:GiveItem(item, nil, item_pos)
    end
end

local function onequip(inst, owner) --装备
    local scale = inst.scale
    local lostE = inst.lostE
    local gemE = inst.gemE
    local a = math.ceil(2*scale - math.log(scale,2))
    ---------------
    if not (owner:HasTag("player") and owner:HasTag("soultide_sp") ) then
        owner:DoTaskInTime(0, function()
			local inventory = owner.components.inventory
			if inventory then
				inventory:DropItem(inst)
				if owner.components.talker then owner.components.talker:Say("欲带勋章，必承其责") end
			end
		end)
    end

    owner.AnimState:OverrideSymbol("swap_body","swap_soultide_brooch_su","swap_soultide_brooch_su")

    ---------------
    if owner and owner.components and owner.components.soultide_sp then
        local sp = owner.components.soultide_sp:GetNow()
        owner.components.talker:Say(string.format("你的 sp，现在是%d",sp) )
    else
        owner.components.talker:Say(string.format("这是古老的力量找到了新的归宿"))
    end
    ------------ 反击冰冻
    inst.freezefn = function(attacked, data)
        if data and data.attacker and data.attacker.components.freezable then
            data.attacker.components.freezable:AddColdness(0.67)
            data.attacker.components.freezable:SpawnShatterFX()
            ---削减冰冻抗性
            if scale > TUNING.SOULTIDE.T.T2 then
                local resist =  data.attacker.components.freezable.resistance
                data.attacker.components.freezable:SetResistance(resist - 1)
            end
            ---大量冰冻 CD
            if scale > TUNING.SOULTIDE.T.T3 then
                if not inst.components.timer:TimerExists("cold_cd1") then
                    inst.components.timer:StartTimer("cold_cd1",math.max(6,30 - a ))
                    data.attacker.components.freezable:AddColdness(10 + 0.5 * a, 5 + 0.2 * a)
                    --data.attacker.components.freezable:PushColour(1, 1/256, 5/256, 0.6) 再看一眼原来是freezable的局部函数 没接口算了

                    if attacked:IsValid()  and attacked.components then
                        attacked.components.damagetypebonus:AddBonus("freezable", inst, 0.95+(inst.scale * 0.1))
                    end
                end
                
            end
        end
    end
    
    inst:ListenForEvent("attacked", inst.freezefn, owner)
    ----------------建造护符
    if scale > TUNING.SOULTIDE.T.T2 then
    local  minpersent = 0.75
    if scale > TUNING.SOULTIDE.T.T3 then
        minpersent = 0.5
    end
    if scale > TUNING.SOULTIDE.T.T4 then
        minpersent = 0.25
    end
    if owner.components.builder ~= nil then
        owner.components.builder.ingredientmod = minpersent
    end
   end

    -----------懒人护符
    local period = math.max(0.5, 6/a)
    if scale > TUNING.SOULTIDE.T.T4 then
        period = math.max(0.33, 20/a)
    end
    if scale > TUNING.SOULTIDE.T.T5 then
        period = math.max(0.25, 40/a)
    end
    inst.task = inst:DoPeriodicTask(period, pickup, nil, owner)
end


local function onunequip(inst, owner) --解除装备
    ------------
    owner.AnimState:ClearOverrideSymbol("swap_body")
    ---------   反击冰冻和易伤取消
    inst:RemoveEventCallback("attacked", inst.freezefn, owner)
    --inst.components.DamageTypeBonus:RemoveBonus("freezable") 不判空就会因为 没受到攻击没有易伤 而删到空值
    if inst.components.DamageTypeBonus then
        inst.components.DamageTypeBonus:RemoveBonus("freezable")
    end

    --------------建造护符取消
    if owner.components.builder ~= nil then
        owner.components.builder.ingredientmod = 1
    end
    ------------懒人护符取消
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    ---------
end




--存储
local function onsave(inst,data)
    data.lostE = inst.lostE
    data.gemE = inst.gemE
    data.scale = inst.scale
end

local function onload(inst,data)
    if data ~= nil then
    inst.lostE = data.lostE
    inst.gemE = data.gemE
    inst.scale = data.scale
    inst.net_scale :set(inst.scale)
    inst.net_lostE :set(inst.lostE)
    inst.net_gemE :set(inst.gemE)
    end
    update_seaurchin(inst) --注意从自己的构造函数复制时候改完名字啊
end
local function seaurchinmake(mc2) -- main c
local mc = "soultide_"..mc2
STRINGS.NAMES[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE[string.upper(mc2).."_NAME"]
STRINGS.RECIPE_DESC[string.upper(mc)] =  TUNING.SOULTIDE.LANGUAGE[string.upper(mc2).."_RECIPE_DESC"]
STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] =  TUNING.SOULTIDE.LANGUAGE[string.upper(mc2).."_CHAG_DESC"]

return Prefab(mc,function ()
local inst = CreateEntity()

inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()

MakeInventoryPhysics(inst)

inst.AnimState:SetBank(mc)  --地上动画
inst.AnimState:SetBuild(mc)
inst.AnimState:PlayAnimation("idle")

inst:AddTag("HASHEATER")
inst:AddTag("soultide_E")
inst:AddTag("waterproofer")


MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

inst.scale = 1
inst.gemE = 0
inst.lostE = 0
--网络变量
inst.net_scale  = net_ushortint(inst.GUID, "net_scale")
inst.net_gemE = net_ushortint(inst.GUID, "net_gemE")
inst.net_lostE = net_ushortint(inst.GUID, "net_lostE")

inst.net_scale :set(inst.scale) --要写的

inst.entity:SetPristine()

if not TheWorld.ismastersim then
return inst
end

inst.components.floater:SetSize("med")
inst.components.floater:SetVerticalOffset(0.3)


-------交易 模拟升级---
inst:AddComponent("trader")

--生活属性
inst:AddComponent("waterproofer")
inst.components.waterproofer:SetEffectiveness(0.2) -- 20%防水(去官方TUNING.LUA看)

inst:AddComponent("insulator")
inst.components.insulator:SetInsulation(30) --30s防寒抵抗

inst:AddComponent("heater")
inst.components.heater:SetThermics(false, false) ---不进行热交换
inst.components.heater.heatfn = HeatFn
inst.components.heater.equippedheatfn = HeatFn
--inst.components.heater.carriedheatfn = HeatFn
inst.components.heater.carriedheatmultiplier = 1.2 --暖石是2.1

inst:AddComponent("equippable") --可装备组件
inst.components.equippable.equipslot = EQUIPSLOTS.BODY
inst.components.equippable:SetOnEquip(onequip)
inst.components.equippable:SetOnUnequip(onunequip)
inst.components.equippable.walkspeedmult = 1.04 -- 加速 --不要乱动顺序啊，放前面组件都没有，写昏头了
inst.components.equippable.dapperness = 0.03 --DAPPERNESS_SMALL
inst.components.equippable.is_magic_dapperness = true
--战斗属性
inst:AddComponent("planardefense")
inst.components.planardefense:SetBaseDefense(5) --五点位面抵抗

inst:AddComponent("damagetyperesist")
inst.components.damagetyperesist:AddResist("epic", inst, 0.9) --10%史诗生物减伤
--------
inst:AddComponent("timer")

inst:AddComponent("inspectable") --可检查组件

inst:AddComponent("inventoryitem") --物品组件
inst.components.inventoryitem.atlasname = "images/inventoryimages/".. mc ..".xml" --物品贴图

MakeHauntableLaunch(inst)

inst:ListenForEvent(("upgrade_Etrade_" .. mc ), update_seaurchin)

inst.OnSave = onsave
inst.OnLoad = onload

return inst --有笨比不返回
end,
assets
)
end

return seaurchinmake("brooch_su")