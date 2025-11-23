<<<<<<< HEAD
=======
--modutil.lua & componentactions.lua 源码 谢谢论坛 commonstates.lua 自己找到的
>>>>>>> 00b334b (v9.8.1)

local SOULTIDE_CANDYBAG = GLOBAL.Action() --打开糖果袋 编写为动作

SOULTIDE_CANDYBAG.id = "SOULTIDE_CANDYBAG"
<<<<<<< HEAD
SOULTIDE_CANDYBAG.str = "打开糖果袋"
=======
SOULTIDE_CANDYBAG.str = TUNING.SOULTIDE.LANGUAGE.SOULTIDE_CANDYBAG_STR
>>>>>>> 00b334b (v9.8.1)
SOULTIDE_CANDYBAG.fn = function(act)
    local pre --prefabs
    local baglevel = act.invobject.bagscale or 1.5
    local amount
    local stacksize
<<<<<<< HEAD
    
=======
>>>>>>> 00b334b (v9.8.1)
    if baglevel == 1.5  then
        local item,num = GetRandomItemWithIndex(TUNING.SOULTIDE.CANDYBAG_CONTAIN["blue"])
        pre = SpawnPrefab(item)
        amount = num
    elseif baglevel == 1.8 then
        local item,num = GetRandomItemWithIndex(TUNING.SOULTIDE.CANDYBAG_CONTAIN["purple"])
        pre = SpawnPrefab(item)
        amount = num
    elseif baglevel == 2.4 then
        local item,num = GetRandomItemWithIndex(TUNING.SOULTIDE.CANDYBAG_CONTAIN["golden"])
        pre = SpawnPrefab(item)
        amount = num
    end

    --注意局部变量的作用域
    if pre.components.stackable then
        stacksize = act.invobject.components.stackable:StackSize() or 1 -- 获得糖果袋子的堆叠数目
        pre.components.stackable:SetStackSize(amount * stacksize) -- 确保物体有stackble
    end

    act.invobject:Remove() --消耗糖果袋
    act.doer.components.inventory:GiveItem(pre, nil , act.doer:GetPosition()) --添加物品
<<<<<<< HEAD
=======
    if act.doer and act.doer.components and act.doer.components.soultide_sp then
        local sp = act.doer.components.soultide_sp:GetNow()
        act.doer.components.talker:Say(string.format("检查sp，现在能量是%d",sp) )
    else
        act.doer.components.talker:Say(string.format("会获得什么呢"))
    end

>>>>>>> 00b334b (v9.8.1)
    return true
end

--添加动作
AddAction(SOULTIDE_CANDYBAG)
--                     类型         组件                检测函数
AddComponentAction("INVENTORY", "inventoryitem", function(inst, doer, actions, right)
	if doer then
		if inst:HasTag("soultide_candybag") then --糖果袋子添加动作
			table.insert(actions, ACTIONS.SOULTIDE_CANDYBAG)
		end
	end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(SOULTIDE_CANDYBAG, "domediumaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(SOULTIDE_CANDYBAG, "domediumaction"))


<<<<<<< HEAD
----------------增加能量
--[=[
=======



----------------增加能量 改写为了hooks
--[=[
    --不如改为事件
local function IsEntityInFront(inst, entity, doer_rotation, doer_pos)
    local facing = Vector3(math.cos(-doer_rotation / RADIANS), 0 , math.sin(-doer_rotation / RADIANS))

    return IsWithinAngle(doer_pos, facing, 180/RADIANS, entity:GetPosition()) --范围
end

local _MUSTTAGS  = {"_combat"}
local _CANTTAGS  = {"INLIMBO", "FX"}


local SOULTIDE_FRISIA_SKILL_I = GLOBAL.Action()

SOULTIDE_FRISIA_SKILL_I.id = "SOULTIDE_FRISIA_SKILL_I"
SOULTIDE_FRISIA_SKILL_I.str = TUNING.SOULTIDE.LANGUAGE.SOULTIDE_FRISIA_SKILL_I
SOULTIDE_FRISIA_SKILL_I.fn = function (act)
    if act.doer and act.doer.prefab == "frisia" then

        print("贪婪之镰")
        local inst = act.doer

        -------判断技能等级
        local skill_lv = 0
        local rate = 0.75
        inst.IsEntityInFront = IsEntityInFront
        if inst.components.skilltreeupdater:IsActivated("frisia_skillup_iv") then  skill_lv =4 rate = 1.20 sp = 16
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_iii")  then skill_lv =3 rate = 1.10 sp = 18
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_ii")  then skill_lv =2 rate = 1.00 sp = 20
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_i")  then  skill_lv =1 rate = 0.88 sp = 24
        end
        local sp = 24
        local cd = 9 - skill_lv
        local r = 8 + skill_lv
        --判断CD sp
        if inst.components.soultide_sp:GetNow() <= sp or inst.components.timer:TimerExists("frisia_skill_i") then
            return
        else
            inst.components.soultide_sp:DoDelta(sp)
            inst.components.timer:StartTimer("frisia_skill_i",cd)
        end
        ------检测目标
        local doer_pos = inst:GetPosition()
        local x, y, z = doer_pos:Get()
        local doer_rotation = inst.Transform:GetRotation()
        local ents = TheSim:FindEntities(x, y, z, r , _MUSTTAGS, _CANTTAGS) --range
        local num = #ents
        ---检测武器
        local weapon = inst.components.combat:GetWeapon()
        local dmg = weapon.damage
        
        ---算自身伤害加成的位面伤害
        local pdmg = weapon.components.planardamage:GetDamage()

        for _, ent in pairs(ents) do --对其中的每一个实体
            if ent:IsValid() and ent.components.health ~= nil then
                if inst:IsEntityInFront(ent, doer_rotation, doer_pos) then
                    --触发frisia增益
                    inst:PushEvent("onhitother",{target = ent})
                    --buff增伤(当然包括暴击buff)
                    local buff = inst.components.combat.externaldamagemultipliers:Get()
                    --阵营增伤
                    local bonus = inst.components.DamageTypeBonus:GetBonus(ent)

                    local mount = (dmg + pdmg) * bonus * buff * (5/num) * rate
                    inst.components.health:DoDelta(mount * (2 + skill_lv) * 0.01) --生命汲取 可以考虑放入onhitother当被动 算了
                    ent.components.health:DoDelta( - mount, nil,(weapon.nameoverride or weapon.prefab), true, inst, true) -- 无视无敌 无视防御 但是不会无视锁血
                end
               
                ----death
                if ent.components.health:IsDead() then
                    inst:PushEvent("killed", { victim = ent })
                     --------收割 额外掉落一次
                    if  ent and inst and ent.components.lootdropper -- and target.components.lootdropper.loot这个没有，只有掉落的时候才生成的
                    then
                        ent.components.lootdropper:DropLoot(doer_pos) --需要vector(x,y,z)
                    end
                    local fx = SpawnPrefab("shadow_puff")
                    fx.Transform:SetPosition(doer_pos:Get()) --需要x,y,z
                end
                ---fx 以后再说吧
                local fxx = SpawnPrefab("willow_shadow_fire_explode")
                fxx.Transform:SetPosition(ent:GetPosition():Get())
            end
        end
    end
end

AddAction(SOULTIDE_FRISIA_SKILL_I)
----------------------------全新的POINT类组件
AddComponentAction("POINT", "frisia_skill_i", function(inst, doer, target, actions, right)
	if doer then
		if inst.prefab == "soultide_dgs" then --要求专武
            if doer.components.timer:TimerExists("frisia_skill_i") then
                return
            end
            TheInput:AddKeyDownHandler(KEY_Z,function()
                print("贪婪之镰1")
                table.insert(actions, ACTIONS.SOULTIDE_FRISIA_SKILL_I)
            end)
		end
	end
end)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(SOULTIDE_CANDYBAG, "dolongaction")) --怎么作一个自己的state呢
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(SOULTIDE_CANDYBAG, "dolongaction"))


>>>>>>> 00b334b (v9.8.1)

local SOULTIDE_DOENERGY = GLOBAL.Action() 

SOULTIDE_DOENERGY.id = "SOULTIDE_DOENERGY"
SOULTIDE_DOENERGY.str = "充能检验"
SOULTIDE_DOENERGY.fn = function (act)
    local energy
    local fuel = act.doer.components.inventory:GetActiveItem()
    local aim = act.invobject

    if fuel and aim and aim.components.AbsorbEnergy ~= nil  then
        -- fuel = act.doer.components.inventory:RemoveItem(act.invobject)
        -- if fuel then 
            aim.components.AbsorbEnergy:DoDeltaEnergy(fuel,aim)
        --         aim = act.target
        --         energy = aim.components.AbsorbEnergy:ShowEnergy()
        --         act.doer.components.talker:Say(string.format("现在能量是%0.1f & %0.1f ", energy["g"], energy["s"]))
        --         return true
        --     else
        --         --print("False")
        --         act.doer.components.talker:Say(string.format("进不去 怎么想都进不去吧！"))
        --         act.doer.components.inventory:GiveItem(fuel)
        --     end
        -- end

        energy = aim.components.AbsorbEnergy:ShowEnergy()
        act.doer.components.talker:Say(string.format("现在能量是%0.1f & %0.1f ", energy["g"], energy["s"]))
        
    else 
        energy = aim.components.AbsorbEnergy:ShowEnergy()
        act.doer.components.talker:Say(string.format("检查能量，现在能量是%0.1f & %0.1f ", energy["g"], energy["s"]))
        
    end
    return true
end

--添加动作
AddAction(SOULTIDE_DOENERGY)
--                     类型         组件                检测函数
AddComponentAction("INVENTORY", "inventoryitem", function(inst, doer, actions, right)
	if doer then
		if inst:HasTag("soultide_ae") and inst.components.AbsorbEnergy ~= nil then -- 给物品栏中的可执行物体添加动作
			table.insert(actions, ACTIONS.SOULTIDE_DOENERGY)
		end
	end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(SOULTIDE_DOENERGY, "doshortaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(SOULTIDE_DOENERGY, "doshortaction"))
]=]
