 local depositnum = math.max(TUNING.STACK_SIZE_SMALLITEM,TUNING.STACK_SIZE_TINYITEM,TUNING.STACK_SIZE_MEDITEM,TUNING.STACK_SIZE_LARGEITEM)

local factor = function (a) --品质因子
    if string.match(a,"green") then
        return 1.2
    elseif string.match(a,"blue") then
        return 1.5
    elseif string.match(a,"purple") then
        return 1.8
    elseif string.match(a,"golden") then
        return 2.4
	elseif string.match(a,"orange") then
        return 2.4
    elseif string.match(a,"red") then
        return 3
	elseif string.match(a,"grey") then
        return 0.8
    else 
        return 1
    end
end
local function candymake(mc2, nc) --main c name c
	local mc = "soultide_"..mc2
	STRINGS.NAMES[string.upper(mc)] = nc
	STRINGS.RECIPE_DESC[string.upper(mc)] = "稀有的糖果，可以从中获得经验"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] = "甜甜的 很好吃"
	return Prefab(mc, function()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst.AnimState:SetBank("soultide_candy")
		inst.AnimState:SetBuild("soultide_candy")
		inst.AnimState:PlayAnimation(mc)   --注意与动画中的名字对应

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddTag("soultide_candy")
		inst:AddTag(mc)

		inst:AddComponent("stackable")
		
		inst.components.stackable.maxsize = depositnum

		inst:AddComponent("tradable")

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = string.lower("images/inventoryimages/" .. mc .. ".xml")

        inst:AddComponent("edible")
		inst.components.edible.foodtype = "GOODIES"
        inst.components.edible.healthvalue = 10 * factor(mc2) --根据品质赋予不同的回复量
        inst.components.edible.hungervalue = 5  * factor(mc2)
        inst.components.edible.sanityvalue = 30 * factor(mc2)

		return inst
	end,
	{
		Asset("ANIM", "anim/soultide_candy.zip"),
	})
end

return  --不能漏掉
candymake("bluecandy","蓝色糖丸"),
candymake("greencandy","绿色糖丸"),
candymake("purplecandy","紫色糖块"),
candymake("goldencandy","金色糖块"),
candymake("redcandy","红色糖灵")