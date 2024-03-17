local assets = {
    Asset("ANIM", "anim/soultide_crystaltower.zip"),


    Asset("ATLAS","images/inventoryimages/soultide_crystaltower_item.xml"),
} 
local prefabs = {
    "eye_charge",
}

local brain = require "brains/eyeturretbrain"

SetSharedLootTable("soultide_crystaltower",
{
    {"opalpreciousgem",   1.00},
    {"opalpreciousgem",   0.5},
    {'thulecite',  0.5},
    {'thulecite',  0.25},
    {'thulecite_pieces',  1},
    {'thulecite_pieces',  0.75},
})


------眼球塔的动态光源
local MAX_LIGHT_FRAME = 24
local function OnUpdateLight(inst, dframes)     ---dframe 光源的动画的第几帧数
    local frame = inst._lightframe:value() + dframes
    if frame >= MAX_LIGHT_FRAME then
        inst._lightframe:set_local(MAX_LIGHT_FRAME)
        inst._lighttask:Cancel()
        inst._lighttask = nil
    else
        inst._lightframe:set_local(frame)
    end

    if frame <= 20 then
        local k = frame / 20
        --radius:    2   -> 3.5
        --intensity: .65 -> .9
        --falloff:   .7  -> .9
        inst.Light:SetRadius(1.5 * k + 2)
        inst.Light:SetIntensity(.9 * k + .65 * (1 - k))
        inst.Light:SetFalloff(.9 * k + .7 * (1 - k))
    else
        local k = (frame - 20) / (MAX_LIGHT_FRAME - 20)
        --radius:    3.5 -> 0
        --intensity: .9  -> .65
        --falloff:   .9  -> .7
        inst.Light:SetRadius(1.5 * (1 - k) + 2 )
        inst.Light:SetIntensity(.65 * k + .9 * (1 - k))
        inst.Light:SetFalloff(.7 * k + .9 * (1 - k))
    end

    if TheWorld.ismastersim then
        inst.Light:Enable(frame < MAX_LIGHT_FRAME)
    end
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    OnUpdateLight(inst, 0)
end

local function triggerlight(inst)
    inst._lightframe:set(0)
    OnLightDirty(inst)
end
--更新制作等级
local function update_tower(inst)
    if inst then
        local scale = inst.scale
        if scale >= TUNING.SOULTIDE.T.T1 then
            inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_PURPLE
        elseif scale >= TUNING.SOULTIDE.T.T2 then
            inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_GOLDEN
        elseif scale >= TUNING.SOULTIDE.T.T2 then
            inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_RED
        end
    end
end
-----放置时候
local function ondeploy(inst, pt, deployer)
    local soultide_crystaltower = SpawnPrefab("soultide_crystaltower") ---注意名字
    if soultide_crystaltower ~= nil then
        soultide_crystaltower.Physics:SetCollides(false)
        soultide_crystaltower.Physics:Teleport(pt.x, 0, pt.z)
        soultide_crystaltower.Physics:SetCollides(true)
        soultide_crystaltower.AnimState:PlayAnimation("place")
        soultide_crystaltower.AnimState:PushAnimation("idle_loop")
        soultide_crystaltower.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
        inst:Remove()
    end
end

--存储
local function onsave(inst,data)
    data.scale = inst.scale
    data.gemE = inst.gemE
end

local function onload(inst,data)
    if data ~= nil then

    inst.scale = data.scale
    inst.gemE = data.gemE
    inst.net_scale :set(inst.scale)
    inst.net_gemE :set( inst.gemE)
    end
    update_tower(inst)
end
-----简单动画控制
local function onturnon(inst)
    inst.AnimState:PlayAnimation("idle_loop",true)
end
local function onturnoff(inst)
    inst.AnimState:PlayAnimation("idle_loop",false)
end
local function onactivate(inst)
    inst.AnimState:PlayAnimation("busy",false)
    inst.AnimState:PushAnimation("idle_loop", false)
    inst:PushEvent("lightdirty")
end


-----
local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("eyeball_turret_object")
    inst.AnimState:SetBuild("eyeball_turret_object")
    inst.AnimState:PlayAnimation("idle_loop")

    inst:AddTag("soultide_crystaltower")

    inst.scale = 1

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem") --物品组件
    inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/soultide_crystaltower_item.xml" --物品贴图

    MakeHauntableLaunch(inst)

    --Tag to make proper sound effects play on hit.
    inst:AddTag("largecreature")

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    ---建造模式
    --inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
    --inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    

    return inst
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.Transform:SetFourFaced()  --六面朝向

    --inst.MiniMapEntity:SetIcon("eyeball_turret.png") --一定是png吗 暂时不要

    inst:AddTag("soultide_crystaltower")
    inst:AddTag("soultide_E")
    inst:AddTag("structure")
    inst:AddTag("prototyper")

    inst.AnimState:SetBank("soultide_crystaltower")
    inst.AnimState:SetBuild("soultide_crystaltower")
    inst.AnimState:PlayAnimation("idle_loop")

    inst.Light:SetRadius(2)
    inst.Light:SetIntensity(.65)
    inst.Light:SetFalloff(.7)
    inst.Light:SetColour(185/255, 180/255, 242/255) --violet色
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

    inst._lightframe = net_smallbyte(inst.GUID, "soultide_crystaltower_lightframe", "lightdirty")
    inst._lighttask = nil

    inst.scale = 1
    inst.gemE = 0

    inst.net_scale = net_ushortint(inst.GUID, "net_scale")
    inst.net_gemE = net_ushortint(inst.GUID, "net_gemE")

    inst.net_scale : set(inst.scale)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty) --非主机也要更新光源

        return inst
    end

    -- 图鉴动画
    -- inst.scrapbook_anim = "scrapbook"
    -- inst.scrapbook_overridedata = {"horn", "eyeball_turret_base", "horn"}



    local scale = inst.scale

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.onactivate = onactivate
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_RED




    inst.triggerlight = triggerlight

    MakeLargeFreezableCharacter(inst)

    MakeHauntableFreeze(inst)

    ---武器装备

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = 0.5  -- + 30/min

    inst:AddComponent("inspectable")

    inst:AddComponent("timer")

    --inst:ListenForEvent("upgrade_Etrade_soultide_crystaltower",update_tower) 写在下面了
    -- inst:ListenForEvent("healthdelta",update_tower)  --找到了,无限回调地狱    
    return inst
end


local function crystaltowermake(mc2) --main c name c
	local mc = "soultide_"..mc2
    STRINGS.NAMES[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE[string.upper(mc2) .. "_NAME"]
	STRINGS.RECIPE_DESC[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE[string.upper(mc2) .. "_RECIPE_DESC"]
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE[string.upper(mc2) .. "_CHAG_DESC"]
    return Prefab(mc,  function ()
        local inst = fn()
        inst:ListenForEvent(("upgrade_Etrade_" .. mc ), update_tower)
        inst.OnLoad = onload
        inst.OnSave = onsave

        return inst
    end,
    assets,
    prefabs
)
end

local function crystaltowermake_item(mc2) --main c name c
	local mc = "soultide_"..mc2
    STRINGS.NAMES[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE[string.upper(mc2) .. "_NAME"]
	STRINGS.RECIPE_DESC[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE[string.upper(mc2) .. "_RECIPE_DESC"]
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE[string.upper(mc2) .. "_CHAG_DESC"]
    return Prefab(mc,  itemfn,
    assets,
    prefabs
)
end

local function PlacerPostInit(inst)
    inst.AnimState:OverrideSymbol("horn", "soultide_crystaltower", "horn")
end

return crystaltowermake("crystaltower"), crystaltowermake_item("crystaltower_item"),
MakePlacer("soultide_crystaltower_item_placer", "soultide_crystaltower", "soultide_crystaltower", "idle_place", nil, nil, nil, nil, nil, nil, PlacerPostInit)