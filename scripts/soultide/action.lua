
local SOULTIDE_CANDYBAG = GLOBAL.Action() --打开糖果袋 编写为动作

SOULTIDE_CANDYBAG.id = "SOULTIDE_CANDYBAG"
SOULTIDE_CANDYBAG.str = "打开糖果袋"
SOULTIDE_CANDYBAG.fn = function(act)
    local pre --prefabs
    local baglevel = act.invobject.bagscale or 1.5
    local amount
    local stacksize
    
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
    if act.doer and act.doer.components and act.doer.components.soultide_sp then
        local sp = act.doer.components.soultide_sp:GetNow()
        act.doer.components.talker:Say(string.format("检查sp，现在能量是%d",sp) )
    else
        act.doer.components.talker:Say(string.format("会获得什么呢"))
    end

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


----------------增加能量
--[=[

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
