--require "scripts.prefabs.hats" --用不了 都被封在函数里面

assets ={
    Asset("ANIM", "anim/soultide_corolla_bt.zip"),
    Asset("ANIM", "anim/swap_soultide_corolla_bt.zip"),

    Asset("ATLAS", "images/inventoryimages/soultide_corolla_bt.xml"),

}


local  function update_blackthorn (inst)
    if inst and inst.components then
        local scale = inst.scale
        local fleshE = inst.fleshE
        local shadowE = inst.shadowE
        local a = math.ceil(2*scale - math.log(scale,2))
        local b = math.floor(scale + math.log(scale,2))
        -------更新防御
        if inst.components.armor then
            inst.components.armor:InitIndestructible(math.min((0.54 + 0.03 * a ),0.99))
        end
        ------更新防热
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
        ----更新暗影减伤
        if inst.components.damagetyperesist then
            inst.components.damagetyperesist:AddResist("shadow_aligned", inst, math.max(0.96 - a * 0.03 , 0.5 ))
        end
        ---加速
        if inst.components.equippable then
            inst.components.equippable.walkspeedmult = 0.96 + 0.04 * a
        end
        ---降低san值光环
        if inst.components.sanityaura then
            inst.components.sanityaura.aura = - 0.36 - 0.01 * a
        end
        --更新标签
        if scale > TUNING.SOULTIDE.T.T1 then
            inst.components.shadowlevel:SetDefaultLevel(2)
            if not inst:HasTag("goggles") then inst:AddTag("goggles") end
        end
        if scale > TUNING.SOULTIDE.T.T2 then
            inst.components.shadowlevel:SetDefaultLevel(3)
        end
        if  scale > TUNING.SOULTIDE.T.T3  then
            if  not  inst:HasTag("shadowdominance") then
                inst:AddTag("shadowdominance")
            end
            inst.components.shadowlevel:SetDefaultLevel(4)
        end
        inst.net_scale :set(inst.scale)
        inst.net_fleshE :set(inst.fleshE)
        inst.net_shadowE :set(inst.shadowE)
    end
end

local function blackthorn_spawngestalt_fn(inst, owner, data)  --摘自启迪之冠
    if  inst.scale  ~= nil  and inst.scale <= TUNING.SOULTIDE.T.T2  then
        return
    end

    if owner ~= nil and (owner.components.health == nil or not owner.components.health:IsDead()) then
        local target = data.target
        if target and target ~= owner and target:IsValid() and (target.components.health == nil or not target.components.health:IsDead() and not target:HasTag("structure") and not target:HasTag("wall")) then

            -- In combat, this is when we're just launching a projectile, so don't spawn a gestalt yet
            -- if data.weapon ~= nil and data.projectile == nil   删掉 远程武器也生效
            --         and (data.weapon.components.projectile ~= nil
            --             or data.weapon.components.complexprojectile ~= nil
            --             or data.weapon.components.weapon:CanRangedAttack()) then
            --     return
            -- end

            local x, y, z = target.Transform:GetWorldPosition()

            local gestalt = SpawnPrefab("alterguardianhat_projectile")
            local r = GetRandomMinMax(3, 5)
            local delta_angle = GetRandomMinMax(-90, 90)
            local angle = (owner:GetAngleToPoint(x, y, z) + delta_angle) * DEGREES -- 
            gestalt.Transform:SetPosition(x + r * math.cos(angle), y, z + r * -math.sin(angle))
            gestalt:ForceFacePoint(x, y, z)
            gestalt:SetTargetPosition(Vector3(x, y, z))
            gestalt.components.follower:SetLeader(owner)

            if owner.components.sanity ~= nil then  --消耗一点精神值
                owner.components.sanity:DoDelta(-1, false) -- using overtime so it doesnt make the sanity sfx every time you attack
                if owner.components.soultide_sp ~= nil  then
                    owner.components.sanity:DoDelta(-1)
                end
            end
        end
    end
end
--来自骨头盔甲

local function onequip(inst, owner) --装备
    ---------------
    if not owner:HasTag("player") and owner:HasTag("soultide_sp") then
        owner:DoTaskInTime(0, function()
			local inventory = owner.components.inventory
			if inventory then
				inventory:DropItem(inst)
				if owner.components.talker then owner.components.talker:Say("欲带王冠，必承其重") end
			end
		end)
    end

    owner.AnimState:OverrideSymbol("swap_hat","swap_soultide_corolla_bt","swap_soultide_corolla_bt")
    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
        owner.AnimState:Show("HEAD_HAT_NOHELM")
        owner.AnimState:Hide("HEAD_HAT_HELM")
    end
    ---------------
    if owner and owner.components and owner.components.soultide_sp then
        local sp = owner.components.soultide_sp:GetNow()
        owner.components.talker:Say(string.format("你的 sp，现在是%d",sp) )
    else
        owner.components.talker:Say(string.format("感觉有活的东西在头顶上"))
    end
    --免疫疯狂光环
    if owner ~= nil and owner.components.sanity ~= nil then
        owner.components.sanity.neg_aura_absorb = 0.66 + (inst.fleshE - inst.shadowE + 2 * inst.scale )*0.01 --前期不配平的化精神会失衡
    end
    --召唤虚影
    inst.blackthorn_spawngestalt_fn = function(_owner, _data) blackthorn_spawngestalt_fn(inst, _owner, _data) end
    inst:ListenForEvent("onattackother", inst.blackthorn_spawngestalt_fn, owner)

end

local function onunequip(inst, owner) --解除装备
    ------------
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
        owner.AnimState:Hide("HEAD_HAT_NOHELM")
        owner.AnimState:Hide("HEAD_HAT_HELM")
    end
    --反转疯狂光环
    if owner ~= nil and owner.components.sanity ~= nil then
        owner.components.sanity.neg_aura_absorb = 0
    end
    --解除 --注意局部变量
    inst.blackthorn_spawngestalt_fn = function(_owner, _data) blackthorn_spawngestalt_fn(inst, _owner, _data) end
    inst:RemoveEventCallback("onattackother", inst.blackthorn_spawngestalt_fn , owner)
end
--存储
local function onsave(inst,data)
    data.fleshE = inst.fleshE
    data.shadowE = inst.shadowE
    data.scale = inst.scale
end

local function onload(inst,data)
    if data ~= nil then
    inst.fleshE = data.fleshE
    inst.shadowE = data.shadowE
    inst.scale = data.scale
    inst.net_scale :set(inst.scale)
    inst.net_fleshE :set(inst.fleshE)
    inst.net_shadowE :set(inst.shadowE)
    end
    update_blackthorn(inst)
end
local function blackthornmake(mc2) -- main c
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

inst:AddTag("hat")
inst:AddTag("shadowlevel")
inst:AddTag("soultide_E")
inst:AddTag("waterproofer")
inst:AddTag("shadowdominance")
inst:AddTag("gestaltprotection")

MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

inst.scale = 1
inst.shadowE = 0
inst.fleshE = 0
--网络变量
inst.net_scale  = net_ushortint(inst.GUID, "net_scale")
inst.net_shadowE = net_ushortint(inst.GUID, "net_shadowE")
inst.net_fleshE = net_ushortint(inst.GUID, "net_fleshE")

inst.net_scale :set(inst.scale) --要写的

inst.entity:SetPristine()

if not TheWorld.ismastersim then
return inst
end

inst.components.floater:SetSize("med")
inst.components.floater:SetVerticalOffset(0.5)


-------交易 模拟升级---
inst:AddComponent("trader")

--防具生活属性
inst:AddComponent("waterproofer")
inst.components.waterproofer:SetEffectiveness(0.2) -- 20%防水(去官方TUNING.LUA看)

inst:AddComponent("insulator")
inst.components.insulator:SetSummer()
inst.components.insulator:SetInsulation(30) --30s过热抵抗


inst:AddComponent("sanityaura")
inst.components.sanityaura.aura = -0.36 --per sencond
inst:AddComponent("armor")
inst.components.armor:InitIndestructible(0.54) --怎么设置无限？--初始54%护甲 任意充能后激活等级

-- inst:AddComponent("resistance") --伤害免疫
-- inst.components.resistance:AddResistance("quakedebris")
-- inst.components.resistance:AddResistance("lunarhaildebris")

inst:AddComponent("planardefense")
inst.components.planardefense:SetBaseDefense(5) --五点位面抵抗

inst:AddComponent("damagetyperesist")
inst.components.damagetyperesist:AddResist("shadow_aligned", inst, 0.9) --10%暗影减伤

inst:AddComponent("shadowlevel")
inst.components.shadowlevel:SetDefaultLevel(1) --初始一级 最高4级
--

inst:AddComponent("timer")

inst:AddComponent("inspectable") --可检查组件

inst:AddComponent("inventoryitem") --物品组件
inst.components.inventoryitem.atlasname = "images/inventoryimages/".. mc ..".xml" --物品贴图

inst:AddComponent("equippable") --可装备组件
inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
inst.components.equippable:SetOnEquip(onequip)
inst.components.equippable:SetOnUnequip(onunequip)
inst.components.equippable.walkspeedmult = 1.04 -- 加速 --不要乱动顺序啊，放前面组件都没有，写昏头了
inst.components.equippable.dapperness = 0.03 --DAPPERNESS_SMALL
inst.components.equippable.is_magic_dapperness = true
-- --
-- inst:AddComponent("container")
-- inst.components.container:WidgetSetup("alterguardianhat")
-- inst.components.container.acceptsstacks = false
MakeHauntableLaunch(inst)

inst:ListenForEvent(("upgrade_Etrade_" .. mc ), update_blackthorn)

inst.OnSave = onsave
inst.OnLoad = onload

return inst --有笨比不返回
end,
assets
)

end

return blackthornmake("corolla_bt")