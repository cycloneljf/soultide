--看的官方的便携烹饪锅--掌握了一些组件
--当然没有添加被锤击，点燃的组件

--本实体的相关数据存储,data是游戏自带的一张表
local function onsave(inst, data)
    data.crysm_scale =  inst.crysm_scale
end

local function onload(inst, data)
    if data ~= nil then
        inst.crysm_scale = data.crysm_scale
    end
end

--建筑容器打开关闭
local function onopen(inst)
    if not inst:HasTag("burnt") then --这就不删了,保证代码强健性，不会真有人闲的给所有建筑加可燃烧组件吧
        inst.AnimState:PlayAnimation("idle_open")
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle_empty")
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end
--后面再添加--高阶锤击获得新材料
local function onhammered(inst)--, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end

    if inst:HasTag("burnt") then
        inst.components.lootdropper:SpawnLootPrefab("ash")
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("metal")
    else
        ChangeToItem(inst)
    end

    inst:Remove()
end
local function ChangeToItem(inst)
    --收起来掉落所有物品
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end

    local item = SpawnPrefab("soultide_crystalsmelter_item", inst.linked_skinname, inst.skin_id)
    item.Transform:SetPosition(inst.Transform:GetWorldPosition())

    item.AnimState:PlayAnimation("collapse")
    --就沿用它的锅的声音了
    item.SoundEmitter:PlaySound("dontstarve/common/together/portable/cookpot/collapse")
end

--拆解的回调函数(收起来)
local function OnDismantle(inst)--, doer)
    ChangeToItem(inst)
    inst:Remove()
end

local function port_buildingmake(mc2, nc , str , desc ) --main c name c
	local mc = "soultide_"..mc2
	STRINGS.NAMES[string.upper(mc)] = nc
	STRINGS.RECIPE_DESC[string.upper(mc)] = str
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] =  desc
	return Prefab(mc, function()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()  -- 声音
        inst.entity:AddMiniMapEntity() -- 地图实体
        inst.entity:AddLight()
        inst.entity:AddDynamicShadow()
		inst.entity:AddNetwork()

        --物理半径
        inst:SetPhysicsRadiusOverride(.6)
        MakeObstaclePhysics(inst, inst.physicsradiusoverride)
        --地图图表
        --inst.MiniMapEntity:SetIcon("images/map_icons/"..mc..".png")  
        --光半径
        inst.Light:Enable(true)
        inst.Light:SetRadius(3)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.5)
        inst.Light:SetColour(81/255,138/255,193/255) -- 一种蓝光 (RGB)
        --动态阴影
        inst.DynamicShadow:SetSize(2.4, 1.2)
    
        inst:AddTag("structure")
        inst:AddTag("soultide_building")
		inst:AddTag(mc)
        --科技等级
        inst.crysm_scale = 1
		-- MakeInventoryPhysics(inst)
		-- MakeInventoryFloatable(inst)

		inst.AnimState:SetBank(mc)
		inst.AnimState:SetBuild(mc)
		inst.AnimState:PlayAnimation(idle_empty)   --注意与动画中的名字对应

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

        --便携建筑
        inst:AddComponent("portablestructure")
        inst.components.portablestructure:SetOnDismantleFn(OnDismantle)
        --容器
        inst:AddComponent("container")
        inst.components.container:WidgetSetup("portablecookpot")
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

		inst:AddComponent("inspectable")

        --可作祟 
        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

		-- inst:AddComponent("inventoryitem")
		-- inst.components.inventoryitem.atlasname = string.lower("images/inventoryimages/" .. mc .. ".xml")
        inst.OnSave = onsave
        inst.OnLoad = onload

		return inst
	end,
	{
		Asset("ANIM", "anim/"..mc.. ".zip"),
	})
end

---------------------------------------------------------------
---------------- Inventory Portable CrystalSmelter ------------
---------------------------------------------------------------

local function ondeploy(inst, pt, deployer)
    local smelter = SpawnPrefab("crystalsmelter", inst.linked_skinname, inst.skin_id )
    if smelter ~= nil then
        smelter.Physics:SetCollides(false)
        smelter.Physics:Teleport(pt.x, 0, pt.z)
        smelter.Physics:SetCollides(true)
        smelter.AnimState:PlayAnimation("place")
        smelter.AnimState:PushAnimation("idle_empty", false)
        smelter.SoundEmitter:PlaySound("dontstarve/common/together/portable/cooksmelter/place")
        inst:Remove()
        PreventCharacterCollisionsWithPlacedObjects(smelter) --真的吗
    end
end

local function port_building_item_make (mc2, nc , str , desc ) --main c name c
	local mc = "soultide_"..mc2
    local mc_father =  string.sub(mc, 1, -6) --截掉_item
	STRINGS.NAMES[string.upper(mc)] = nc
	STRINGS.RECIPE_DESC[string.upper(mc)] = str
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] =  desc

    return Prefab(mc ,function()
        local inst = CreateEntity()
    
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddLight()
        inst.entity:AddNetwork()
    
        MakeInventoryPhysics(inst)
    
        inst.AnimState:SetBank(mc_father)  --spriter里动画的集合名字
        inst.AnimState:SetBuild(mc_father) --动画的工程文件名
        inst.AnimState:PlayAnimation("idle_ground")
        inst.scrapbook_anim = "idle_ground"
    
        inst:AddTag("portableitem")
        inst:AddTag("soultide_building")
		inst:AddTag(mc)
    
        MakeInventoryFloatable(inst, "med", 0.1, 0.8)
        -- 光源
        inst.Light:Enable(true)
        inst.Light:SetRadius(2)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.5)
        inst.Light:SetColour(81/255,138/255,193/255) -- 一种蓝光 (RGB)
        --科技等级
        inst.crysm_scale = 1

        inst.entity:SetPristine()
    
        if not TheWorld.ismastersim then
            return inst
        end
    
        inst:AddComponent("inspectable")
    
        inst:AddComponent("inventoryitem")
    
        inst:AddComponent("deployable")
        --inst.components.deployable.restrictedtag = "masterchef"
        inst.components.deployable.ondeploy = ondeploy
        --inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        --inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    
        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
        --存储科技等级 是data表里的同一个值
        inst.OnSave = onsave
        inst.OnLoad = onload
        return inst
    end,{
		Asset("ANIM", "anim/".. mc_father .. ".zip"), 
	}
    )
end
 



return port_buildingmake("crystalsmelter","水晶熔炉","召唤——水晶熔炉"," 水晶熔炉是某些科技的必需建筑"),
<<<<<<< HEAD
    port_building_item_make("crystalsmelter_item",,"水晶熔炉","召唤——水晶熔炉"," 水晶熔炉是某些科技的必需建筑"),
=======
    port_building_item_make("crystalsmelter_item","水晶熔炉","召唤——水晶熔炉"," 水晶熔炉是某些科技的必需建筑"),
>>>>>>> 00b334b (v9.8.1)
    MakePlacer("soultide_crystalsmelter_item_placer", "soultide_crystalsmelter", "soultide_crystalsmelter", "idle_empty")