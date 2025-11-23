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

<<<<<<< HEAD
local function makecandybag(mc,nc,zz,suiji)
	local mc2 = "soultide_"..mc
	STRINGS.NAMES[string.upper(mc2)] = nc
	STRINGS.RECIPE_DESC[string.upper(mc2)] = zz
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc2)] = "会开出什么呢？"
=======
local function makecandybag(mc,suiji)
	local mc2 = "soultide_"..mc
	STRINGS.NAMES[string.upper(mc2)] = TUNING.SOULTIDE.LANGUAGE[string.upper(mc).."_NAME"]
	STRINGS.RECIPE_DESC[string.upper(mc2)] =  TUNING.SOULTIDE.LANGUAGE[string.upper(mc).."_RECIPE_DESC"]
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc2)] =  TUNING.SOULTIDE.LANGUAGE[string.upper(mc).."_CHAG_DESC"]
>>>>>>> 00b334b (v9.8.1)
	local function onsave(inst,data)
		data.bagscale = inst.bagscale
	end
	local function onload(inst,data)
		if data then
			inst.bagscale = data.bagscale
		end
	end
	return Prefab(mc2, function()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst.AnimState:SetBank("soultide_candybag")
		inst.AnimState:SetBuild("soultide_candybag")
		inst.AnimState:PlayAnimation(mc2) --全名
<<<<<<< HEAD
=======
		inst:AddTag("soultide_candybag")
>>>>>>> 00b334b (v9.8.1)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

        inst.bagscale = factor (mc)
<<<<<<< HEAD
        inst:AddTag("soultide_candybag")
=======

>>>>>>> 00b334b (v9.8.1)

		inst:AddComponent("inspectable")

		inst:AddComponent("stackable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = string.lower("images/inventoryimages/" .. mc2 .. ".xml")
	

		inst.OnSave = onsave
		inst.OnLoad = onload

		return inst
	end,
	{
		Asset("ANIM","anim/soultide_candybag.zip"),
		-- Asset("ATLAS", string.lower("images/inventoryimages/" .. mc2 .. ".xml")),
	})
end

return 
<<<<<<< HEAD
makecandybag("candybag_blue","精良糖果袋","最高包含蓝色糖果"),
makecandybag("candybag_purple","史诗糖果袋","最高包含紫色糖果"),
makecandybag("candybag_golden","传说糖果袋","最高包含金色糖果")
=======
makecandybag("candybag_blue"),
makecandybag("candybag_purple"),
makecandybag("candybag_golden")
>>>>>>> 00b334b (v9.8.1)
