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
local _oneaten =  function ( inst ,eater )
	if eater.components and  eater.components.soultide_sp then
		eater.components.soultide_sp:DoDelta( TUNING.SOULTIDE.BASE_SP * factor(inst.prefab) ) --记得测完删掉
	end
end


local function candymake(mc2) --main c name c
	local mc = "soultide_"..mc2
	STRINGS.NAMES[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE[string.upper(mc2).."_NAME"]
	STRINGS.RECIPE_DESC[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.CANDY_RECIPE_DESC
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.CANDY_CHAG_DESC
	return Prefab(mc, function()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst:AddTag("soultide_candy")

		inst.AnimState:SetBank("soultide_candy")
		inst.AnimState:SetBuild("soultide_candy")
		inst.AnimState:PlayAnimation(mc)   --注意与动画中的名字对应

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end


		inst:AddTag(mc)

		inst:AddComponent("stackable")
		
		inst.components.stackable.maxsize = depositnum

		inst:AddComponent("tradable")

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = string.lower("images/inventoryimages/" .. mc .. ".xml")

        inst:AddComponent("edible")
		inst.components.edible.foodtype = "GOODIES"
        inst.components.edible.healthvalue = TUNING.SOULTIDE.BASE_HEALTH * factor(mc2) --根据品质赋予不同的回复量
        inst.components.edible.hungervalue = TUNING.SOULTIDE.BASE_HUNGER  * factor(mc2)
        inst.components.edible.sanityvalue = TUNING.SOULTIDE.BASE_SANITY * factor(mc2)
		inst.components.edible.oneaten = _oneaten

		return inst
	end,
	{
		Asset("ANIM", "anim/soultide_candy.zip"),
	})
end

return  --不能漏掉
candymake("bluecandy"),
candymake("greencandy"),
candymake("purplecandy"),
candymake("goldencandy"),
candymake("redcandy")