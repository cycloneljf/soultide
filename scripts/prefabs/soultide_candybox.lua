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

local function onopen()
	print(" open candybox")
end


local function onclose()
	print(" close candybox")
end


local function update_candybox(inst)
	local scale = inst.scale
	--新鲜度
	if inst.components.preserver then
		inst.components.preserver:SetPerishRateMultiplier(math.min(0.9 - 0.15 * scale),-10) -- 6级永久保鲜
	end
	--容量
	--更新网络变量
	inst.net_scale :set(inst.scale)
    inst.net_gemE :set(inst.gemE)
    inst.net_moonE :set(inst.moonE)  --注意复制粘贴时候把 net 删掉
end

local function onsave()
	data.scale = inst.scale
	data.gemE =  inst.gemE
	data.moonE = inst.moonE
end

local function onload()
	if data ~= nil then
		inst.scale = data.scale
		inst.gemE = data.gemE
		inst.moonE = data.moonE
	end
	update_candybox(inst)
	print("update_candybox")
end
-- local function OnEnterProximity(inst)
--     inst.AnimState:PlayAnimation("idle_1r", true)
-- end

local function candyboxmake(mc2) --main c name c
	local mc = "soultide_"..mc2
	STRINGS.NAMES[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.CANDYBOX_NAME
	STRINGS.RECIPE_DESC[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.CANDYBOX_RECIPE_DESC
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.CANDYBOX_CHAG_DESC
	return Prefab(mc, function()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst.AnimState:SetBank("soultide_candybox")
		inst.AnimState:SetBuild("soultide_candybox")
		inst.AnimState:PlayAnimation("idle_1r",true)   --注意与动画中的名字对应 还有idle 2 和 3 

		inst.entity:SetPristine()

		inst:AddTag("fridge")
		inst:AddTag("nocool") --保存冰块？
		inst:AddTag("icebox_valid")
		inst:AddTag("soultide_candybox")
		inst:AddTag("soultide_E")

		inst.scale = 1
		inst.gemE = 0
		inst.moonE = 0
		--网络变量
		inst.net_scale  = net_ushortint(inst.GUID, "net_scale")
		inst.net_moonE = net_ushortint(inst.GUID, "net_moonE")
		inst.net_gemE = net_ushortint(inst.GUID, "net_gemE")	

		inst.net_scale :set(inst.scale) --要写的

		if not TheWorld.ismastersim then
			return inst
		end


		--这就够了
		inst:AddComponent("trader")
		
		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = string.lower("images/inventoryimages/" .. mc .. ".xml")

		inst:AddComponent("container")
		inst.components.container:WidgetSetup("terrariumchest")
		inst.components.container.onopenfn = onopen
		inst.components.container.onclosefn = onclose
		inst.components.container.skipclosesnd = true
		inst.components.container.skipopensnd = true


		inst:AddComponent("preserver")
		inst.components.preserver:SetPerishRateMultiplier(0.75) -- 初始具有+25%保鲜时长

		--inst:ListenForEvent(("upgrade_Etrade_" .. inst.prefab),update_candybox) --监听事件 现在没什么问题，以后物品多了会同时更新不过来 所以加入物品名字
		--这里是个匿名函数没有传递参数，读不到inst.prefab 得用闭包的mc2，看上面inventoryitem
		inst:ListenForEvent(("upgrade_Etrade_" .. mc ),update_candybox)

		inst.OnSave = onsave
		inst.OnLoad = onload
		-- --靠近动画 --GPT 给了一个不存在的组件（估计是学别人的代码，但是把别人自定义的组件当成原装的了）
		-- inst:AddComponent("proximity")
		-- inst.components.proximity.onenterproximity = OnEnterProximity
		-- inst.components.proximity:SetProximity(2.5)

		return inst
	end,
	{
		Asset("ANIM", "anim/soultide_candybox.zip"),
	})
end

return candyboxmake("candybox")