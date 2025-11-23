<<<<<<< HEAD
=======


>>>>>>> 00b334b (v9.8.1)
local assets = 
{
    Asset("ANIM", "anim/soultide_dgs.zip"),  --地上的动画
    Asset("ANIM", "anim/swap_soultide_dgs.zip"),
     --手里的动画
    
	Asset("ATLAS", "images/inventoryimages/soultide_dgs.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/soultide_dgs.tex"),

}

--更新函数
local function update_weapon(inst)
<<<<<<< HEAD

    --if inst.scale  < TUNING.SOULTIDE.DGS.MAX_SCALE and inst.gemE >= 50 * inst.scale  and inst.shadowE >= 50 * inst.scale then
    --     inst.scale = inst.scale + 1
    -- end
    ----------攻击力与速度
    inst.components.planardamage:SetBaseDamage(
        TUNING.SOULTIDE.EXTRA + 
       math.floor(6 *( math.log(inst.scale,4) + (inst.scale - 1)))    -- lv 1 - 0 , lv 4 = 24 , lv 8 = 52  ,lv 16 = 102 , lv 64 = 402
    )
    inst.components.weapon:SetDamage(
        36 + TUNING.SOULTIDE.EXTRA +
        12 * (inst.scale  - 1)
    )
    inst.components.equippable.walkspeedmult = 1 + (inst.scale* 0.05 )
    ----------暗影武器，对月亮增伤
    inst.components.damagetypebonus:AddBonus("lunar_aligned", inst, 0.95+(inst.scale * 0.1))
=======
    local scale = inst.scale
    local a = math.ceil(2*scale - math.log(scale,2)) -- lv1 = 2  lv2 = 3  lv4 = 6 lv8 = 13
    local b = math.floor(scale + math.log(scale,2))  -- lv1 = 1  lv2 = 3  lv4 = 6 lv8 = 11
    inst.components.planardamage:SetBaseDamage(
        TUNING.SOULTIDE.EXTRA +
        b * 6
    )
    inst.components.weapon:SetDamage(
        TUNING.SOULTIDE.DGS.BASEDAMAGE + TUNING.SOULTIDE.EXTRA +
        a * 6
    )
    inst.components.equippable.walkspeedmult =math.max(1 + (b * 0.04 ), TUNING.SOULTIDE.EXTRASPEED_LIMIT)
    ----------暗影武器，对月亮增伤
    inst.components.damagetypebonus:AddBonus("lunar_aligned", inst, 1 +  b * 0.05)

    
>>>>>>> 00b334b (v9.8.1)
    -------- 更新网络变量
    inst.net_scale :set(inst.scale)
    inst.net_gemE :set(inst.gemE)
    inst.net_shadowE :set(inst.shadowE)  --注意复制粘贴时候把 net 删掉
    print("update_weapon")
end
<<<<<<< HEAD
=======

>>>>>>> 00b334b (v9.8.1)
--存储
local function onsave(inst,data)
    data.gemE = inst.gemE
    data.shadowE = inst.shadowE
    data.scale = inst.scale
end

local function onload(inst,data)
    if data ~= nil then
    inst.gemE = data.gemE
    inst.shadowE = data.shadowE
    inst.scale = data.scale
<<<<<<< HEAD
=======
    inst.net_scale :set(inst.scale)
    inst.net_gemE :set(inst.gemE)
    inst.net_shadowE :set(inst.shadowE)
>>>>>>> 00b334b (v9.8.1)
    end
    update_weapon(inst)
end
--发光
<<<<<<< HEAD
local function lighton(inst, owner)
=======
local function lighton(inst, owner) --owner是玩家 父节点
>>>>>>> 00b334b (v9.8.1)
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("dgs_light")
    end
    if owner ~= nil  then
<<<<<<< HEAD
        inst._light.entity:SetParent(owner.entity)
    end
	
=======
        inst._light.entity:SetParent(owner.entity) --绑定角色/父节点
        inst._light.entity:AddFollower()

        inst._light.Follower:FollowSymbol(  ---武器尖端
            owner.GUID,
            "swap_object",
            0.5,
            4.6,
            0)
    end
end

local function lighton2(inst, owner) --owner是武器 父节点
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("dgs_light") --生成光源
    end
    if owner ~= nil  then
        inst._light.entity:SetParent(owner.entity) --绑定角色/父节点
        inst._light.entity:AddFollower()

        inst._light.Follower:FollowSymbol(  ---武器尖端
            owner.GUID,
            "swap_object",
            0.5,
            4.6,
            0)
    end
>>>>>>> 00b334b (v9.8.1)
end

--关灯
local function lightoff(inst)
    if inst._light ~= nil then
            if inst._light:IsValid() then
                inst._light:Remove()
            end
            inst._light = nil
        end
<<<<<<< HEAD
end  
=======
end
>>>>>>> 00b334b (v9.8.1)

--光源产生
local function dgs_lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

<<<<<<< HEAD
	inst.Light:SetIntensity(0.5)
	inst.Light:SetRadius(10)
	inst.Light:Enable(true)
	inst.Light:SetFalloff(1)
	inst.Light:SetColour(64/255, 64/255, 208/255)
=======
	inst.Light:SetIntensity(0.6)
	inst.Light:SetRadius(6)
	inst.Light:Enable(true)
	inst.Light:SetFalloff(1)
	inst.Light:SetColour(1.0, 0.4, 0.4)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end
--暂时用不上
local function dgs_light2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetRadius(1.5)         -- 光范围
    inst.Light:SetIntensity(0.75)     -- 光亮度
    inst.Light:SetFalloff(0.9)        -- 光衰减
    inst.Light:SetColour(1, 0.84, 0)  -- 颜色（金色）
    inst.Light:Enable(false)          -- 先关掉，等掉地上再开
>>>>>>> 00b334b (v9.8.1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function onattack(inst, attacker, target)
    local gemE =  inst.gemE
    local shadowE = inst.shadowE
    local scale = inst.scale
<<<<<<< HEAD
    local wdamage = 36 + TUNING.SOULTIDE.EXTRA +
    12 * (inst.scale  - 1) --武器基础攻击力
    local pdamage = TUNING.SOULTIDE.EXTRA + math.floor(6 *( math.log(inst.scale,4) + (inst.scale - 1)))  --武器位面攻击力

    --寒冷恐惧
    if target and target.components and target.components.freezable then
        target.components.freezable:AddColdness(0.5 + shadowE * 0.02)  
=======
    local a = math.ceil(2*scale - math.log(scale,2)) -- lv1 = 2  lv2 = 3  lv4 = 6 lv8 = 13
    local b = math.floor(scale + math.log(scale,2))  -- lv1 = 1  lv2 = 3  lv4 = 6 lv8 = 11
    local wdamage =   TUNING.SOULTIDE.DGS.BASEDAMAGE + TUNING.SOULTIDE.EXTRA +
    a * 6 --武器基础攻击力
    local pdamage = TUNING.SOULTIDE.EXTRA +
    b * 6  --武器位面攻击力
    local line = ( 50 * TUNING.SOULTIDE.WORLDLEVEL - 50 + wdamage + pdamage ) --斩杀线  -- 对于低生命物体 -- 无视防御
    local mount = target.components.health.maxhealth
    local percent = shadowE /(shadowE + 100)  -- 0 到 1  斩杀线   --10级能量加满是0.83
    local killrate = 0.8 * gemE / (gemE + 50)  --0 - 0.8 斩杀率 --10级能量加满是0.72必杀
    --寒冷恐惧
    if target and target.components and target.components.freezable then
        target.components.freezable:AddColdness(0.5 + percent + killrate )
    end
    --特判--对于1下就死 的怪物, 最大血量满足我们的要求
    if target and target.components and attacker and target.components.lootdropper and  mount < line then
        local pt = attacker:GetPosition() --获得vector(x,y,z)
                
        target.components.lootdropper:DropLoot(pt) --需要vector(x,y,z)
        print("收割1！")
    --触发特效
        local fx = SpawnPrefab("shadow_puff")
        fx.Transform:SetPosition(pt:Get()) --需要x,y,z
>>>>>>> 00b334b (v9.8.1)
    end
    --概率秒杀
    if target and target.components and not target.components.health:IsDead() then
        local now = target.components.health:GetPercent()
<<<<<<< HEAD
        local percent = shadowE /(shadowE + 100)  -- 0 到 1  斩杀线   --10级能量加满是83.3%
        local line = ( 50 * TUNING.SOULTIDE.WORLDLEVEL - 50 + wdamage + pdamage ) --斩杀线  -- 对于低生命物体 -- 无视防御
        local killrate = (0.05 + scale * 0.05 + gemE * 0.001 )  -- 斩杀率 --10级能量加满是1.05必杀
        local mount = target.components.health.currenthealth
        local ram = math.random()

        if (now < percent and ram < killrate ) or  mount < line then --初始10%概率秒杀 最高100%
            --print("秒杀！")
=======
        local ram = math.random()
        --print("秒杀？" .. mount " <" .. line  )数字上面要写string.format aaa 
        if (now < percent and ram < killrate ) or  mount < line then --初始10%概率秒杀 最高100%
            print("秒杀！")
>>>>>>> 00b334b (v9.8.1)
        --收割1--触发秒杀额外一次战利品--生成在脚下
            if  target and attacker and target.components.lootdropper -- and target.components.lootdropper.loot这个没有，只有掉落的时候才生成的
            then
                local pt = attacker:GetPosition() --获得vector(x,y,z)
                
                target.components.lootdropper:DropLoot(pt) --需要vector(x,y,z)
<<<<<<< HEAD
                --print("收割1！")
=======
                print("收割1！")
>>>>>>> 00b334b (v9.8.1)
            --触发特效
                local fx = SpawnPrefab("shadow_puff")
                fx.Transform:SetPosition(pt:Get()) --需要x,y,z
                
            end
        
            -- local fx2 = "shock_fx" --太吵了，白写了
            -- if target ~= nil and target:IsValid() then
            --     print("秒杀特效！")
            --     -- SpawnPrefab(fx2):Setup(attacker, target) 不同的特效有不同的方法 一次记得改完ok？
            --     local pt = attacker:GetPosition() --返回(x,y,z) 能一次改完吗 不是 attacker.transport:GetPosition()
            --     SpawnPrefab(fx2).Transform:SetPosition(pt.x,pt.y + 1 ,pt.z)
            -- end

        target.components.health:DoDelta(-mount,nil,(inst.nameoverride or inst.prefab), true, attacker, true)
        end
        if target.components.health:IsDead() then
            attacker:PushEvent("killed", { victim = target })
        end
    end
    --生命汲取
    if  target and attacker then
        local percent2 =  (4  - math.exp( -gemE*0.01 + 1 )) - (4  - math.exp( -gemE*0.01 + 1 ))%0.01  --约为 1.3 - 3.4 (%)
<<<<<<< HEAD
        local tim = math.max(TUNING.SOULTIDE.DGS.CD, 1 - ((scale -1) * 0.1) )   --冷却时间 0.2 - 1
        if not inst.components.timer:TimerExists("health_cd1") then
            inst.components.timer:StartTimer("health_cd1",tim)
            attacker.components.sanity:DoDelta(percent2)
            attacker.components.health:DoDelta(percent2 * wdamage *0.03 )
=======
        local tim = math.max(TUNING.SOULTIDE.DGS.CD, 1.1 - b * 0.1)   --冷却时间 0.2 - 1
        --专武加成
        local c = 0.01
        if not inst.components.timer:TimerExists("health_cd1") then
            inst.components.timer:StartTimer("health_cd1",tim)
            if attacker.prefab == "frisia" then
                --print("yes master")
                c = 0.03
            end
            attacker.components.sanity:DoDelta(percent2)
            attacker.components.health:DoDelta( c * percent2 * wdamage )
>>>>>>> 00b334b (v9.8.1)
        end 
    end
    --收割2--攻击时概率额外一个战利品--生成在脚下--与1独立
    if  target and attacker and target.components.lootdropper  --target.components.lootdropper.loot 
    then
        local ram2 = math.random()
<<<<<<< HEAD
        local percent2 =  (0.5 * gemE + 2) / (gemE + 50)  --(4% - 50%)
=======
        local percent2 =  killrate + 0.1  --(10% - 90%)
>>>>>>> 00b334b (v9.8.1)
        if ram2 <= percent2 then
            local loots = target.components.lootdropper:GenerateLoot()
            local pt = attacker:GetPosition()
            --print("收割2-1！")
            if not inst.components.timer:TimerExists("loot_cd1") then
<<<<<<< HEAD
                inst.components.timer:StartTimer("loot_cd1",math.max(3,24 - (scale + math.log(scale,2) ))) --最低三秒,默认CD24s --17级升满 -- 10
                --print("收割2！")
            local fx = SpawnPrefab("shadow_puff")
            fx.Transform:SetPosition(pt:Get())

            local loot = loots[math.random(1,#loots)]  --获得随机战利品
            -- SpawnLootPrefab(loot,pt) --纯笨比，一个bug就要修一次,和SpawnPrefab不一样
            target.components.lootdropper:SpawnLootPrefab(loot,pt)
            end
        end
    end
    --攻击后加速
    if attacker.components.combat then
        attacker.components.combat:SetAttackPeriod(  math.min(0.2 ,0.4 - ((inst.scale -1) * 0.02)) )
        --print (" period" ..  1 + ((inst.scale -1) * 0.1)) 
    end



    if scale >= TUNING.SOULTIDE.DGS.T1 then
        --攻击特效
        local fx = "hitsparks_fx"
        if target ~= nil and target:IsValid() then
            SpawnPrefab(fx):Setup(attacker, target)
        end
    end
end
--检查是否在交易单里
local function check(obj,t)  --物体 表
    local t =  t or TUNING.SOULTIDE.ENERGY_LIST
    local count = 0
    local val = 0
    print("check the prefab is " .. obj.prefab)
    for key, value in pairs(t) do
        if string.match( obj.prefab, key) then
            print("check the prefab match  " .. key)
            count = count + 1
            val = value
        end
    end
    if count ~= 0 then
        return true , val --是一个表
    else
        return false , -1
    end
end
--是否锁住
local function islock(obj)
    if obj.scale == TUNING.SOULTIDE.DGS.T1 or  obj.scale == TUNING.SOULTIDE.DGS.T3  or  obj.scale == TUNING.SOULTIDE.DGS.T2  then
        print("islocked")
        return false
        
    else
        print("onlocked")
        return true
    end
end
--等级更新
local function upscale_weapon(obj)
    local inst = obj
    if inst.scale  < TUNING.SOULTIDE.DGS.MAX_SCALE and inst.gemE >= 50 * inst.scale  and inst.shadowE >= 50 * inst.scale then
        inst.scale = inst.scale + 1
    end
    print("upscale_weapon")
end

--交易函数(升级)
local function OnGetItemFromPlayer(inst, giver, item)
    local limit = 50 * inst.scale
   print("ongetitemfp 1")
    local ac , tab = check(item)
    local ac2 , num = check(item,TUNING.SOULTIDE.UP)
    -- 能量增加，未达到上限时
    if (inst.gemE < limit or inst.shadowE < limit) and ac and tab then --合并if不改判定条件 笨比
        inst.gemE  = math.min(inst.gemE + tab[1] ,limit)
        inst.shadowE = math.min(inst.shadowE + tab[2] ,limit)

        print("ongetitemfp 2")
        print("item prefab is ".. item.prefab .." /".. inst.scale .." /".. inst.gemE .. " /".. inst.shadowE .." /".. tab[1] .." /".. tab[2])
        
        --没限制时自动升级
        if islock(inst) then --锁住是false
            upscale_weapon(inst)
        end
        update_weapon(inst)  --放后面要更新网络变量的
    end
    --达到上限时候
    if  inst.shadowE == limit and inst.gemE == limit and ac2 and inst.scale == num - 1 then
        print("ongetitemfp 3")
        upscale_weapon(inst)
        update_weapon(inst)
    end
end

local function onequip(inst, owner) --装备
                           --替换的动画部件	    使用的动画	         替换的文件夹贴图名字（注意这里也是文件夹的名字）
        owner.AnimState:OverrideSymbol("swap_object","swap_soultide_dgs","swap_soultide_dgs")
       
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        lighton(inst, owner)
        
	-- end
=======
                inst.components.timer:StartTimer("loot_cd1",math.max(3,24 - b )) --最低三秒,默认CD24s --17级升满 -- 10
                print("收割2！")
            local fx = SpawnPrefab("shadow_puff")
            fx.Transform:SetPosition(pt:Get())
            if loots and #loots ~= nil and #loots >= 1 then  --打岩浆虫的问题
                local loot = loots[math.random(1,#loots)]  --获得随机战利品 注意局部变量
                target.components.lootdropper:SpawnLootPrefab(loot,pt)
            end
            -- SpawnLootPrefab(loot,pt) --纯笨比，一个bug就要修一次,和SpawnPrefab不一样
            end
        end
    end
    --攻速
    if attacker.components.combat then
        attacker.components.combat:SetAttackPeriod( math.min(0.2 ,0.4 - a * 0.02) )
        --print (" period" ..  1 + ((inst.scale -1) * 0.1)) 
    end

    if scale > TUNING.SOULTIDE.T.T1 then
        --T1攻击特效 + 范围攻击
        local fx = "hitsparks_fx"
        if target ~= nil and target:IsValid() then
            SpawnPrefab(fx):Setup(attacker, target)
        end   
        attacker.components.combat:SetAreaDamage( a, percent , function (ent , inst)
            for _, value in ipairs(TUNING.SOULTIDE.AOE_CANT_TAGS) do
                    if ent:HasTag(value) then
                        return false
                    end
                end
                return true
        end)
    end
    --T2 解锁传送法杖
    
    --T3 解锁收割加强
end
-----------暗影镰刀的收割
local HARVEST_MUSTTAGS  = {"pickable"}
local HARVEST_CANTTAGS  = {"INLIMBO", "FX"}
local HARVEST_ONEOFTAGS = {"plant", "lichen", "oceanvine", "kelp"}
local function HarvestPickable(inst, ent, doer)
    if ent.components.pickable.picksound ~= nil then
        doer.SoundEmitter:PlaySound(ent.components.pickable.picksound)
    end

    local success, loot = ent.components.pickable:Pick(TheWorld)

    if loot ~= nil then
        for i, item in ipairs(loot) do
            Launch(item, doer, 1.5)
        end
    end
end
local function IsEntityInFront(inst, entity, doer_rotation, doer_pos)
    local facing = Vector3(math.cos(-doer_rotation / RADIANS), 0 , math.sin(-doer_rotation / RADIANS))

    return IsWithinAngle(doer_pos, facing, TUNING.VOIDCLOTH_SCYTHE_HARVEST_ANGLE_WIDTH, entity:GetPosition())
end
local function DoScythe(inst, target, doer)
    --inst:SayRandomLine(STRINGS.VOIDCLOTH_SCYTHE_TALK.onharvest, doer)
    if target.components.pickable ~= nil then
        local doer_pos = doer:GetPosition()
        local x, y, z = doer_pos:Get()

        local doer_rotation = doer.Transform:GetRotation()

        local ents = TheSim:FindEntities(x, y, z, TUNING.VOIDCLOTH_SCYTHE_HARVEST_RADIUS, HARVEST_MUSTTAGS, HARVEST_CANTTAGS, HARVEST_ONEOFTAGS)
        for _, ent in pairs(ents) do
            if ent:IsValid() and ent.components.pickable ~= nil then
                if inst:IsEntityInFront(ent, doer_rotation, doer_pos) then
                    inst:HarvestPickable(ent, doer)
                end
            end
        end
    end
end
-------瞬移功能 来自懒人魔杖 系统的组件自带网络编程 就不用麻烦我了
local function blinkstaff_reticuletargetfn() --这个东西是防止你传入虚空的或者和其他实体卡在一起
    local player = ThePlayer
    local rotation = player.Transform:GetRotation()
    local pos = player:GetPosition()
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING.CONTROLLER_BLINKFOCUS_DISTANCE, BLINKFOCUS_MUST_TAGS)
    for _, v in ipairs(ents) do
        local epos = v:GetPosition()
        if distsq(pos, epos) > TUNING.CONTROLLER_BLINKFOCUS_DISTANCESQ_MIN then 
            local angletoepos = player:GetAngleToPoint(epos)
            local angleto = math.abs(anglediff(rotation, angletoepos))
            if angleto < TUNING.CONTROLLER_BLINKFOCUS_ANGLE then
                return epos
            end
        end
    end
    rotation = rotation * DEGREES
    for r = 13, 1, -1 do
        local numtries = 2 * PI * r
        local offset = FindWalkableOffset(pos, rotation, r, numtries, false, true, NoHoles, false, true)
        if offset ~= nil then
            pos.x = pos.x + offset.x
            pos.y = 0
            pos.z = pos.z + offset.z
            return pos
        end
    end
end

local function onblink(staff, pos, caster)--瞬移消耗sp
    local p = staff.components.rechargeable:GetPercent()
    local inst = staff
    local uses = (inst.scale > TUNING.SOULTIDE.T.T3 and 4) or (inst.scale > TUNING.SOULTIDE.T.T2 and 3) or (inst.scale > TUNING.SOULTIDE.T.T1 and 2) or 1
    staff.components.rechargeable:SetPercent( math.max(p - 1/uses , 0) )
    if caster.components.soultide_sp ~= nil then
        caster.components.soultide_sp:DoDelta(- math.max(8 - staff.scale , 2 )) -- sp消耗2 - 8
    end
    print("test re")
    if caster.prefab ~= nil and caster.prefab == "frisia" then
        print("restore transport")
        if caster.components.drownable~=nil then
			caster.components.drownable.enabled = false
			caster.Physics:ClearCollisionMask()		--移除碰撞，但和下列碰撞
			caster.Physics:CollidesWith(COLLISION.GROUND)	--地面
            caster.Physics:CollidesWith(COLLISION.OBSTACLES)	--障碍
			caster.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)--小障碍
            caster.Physics:CollidesWith(COLLISION.CHARACTERS)	--角色
			caster.Physics:CollidesWith(COLLISION.GIANTS)	--巨人
	    end
        print("restore transport222")
    else
        print(caster.prefab)
    end
end
local function onchargedfn(inst) -- 冷却不够不允许使用
    local uses = (inst.scale > TUNING.SOULTIDE.T.T3 and 4) or (inst.scale > TUNING.SOULTIDE.T.T2 and 3) or (inst.scale > TUNING.SOULTIDE.T.T1 and 2) or 1
    if inst.components.rechargeable:GetPercent() < 1/uses then
        inst:RemoveComponent("blinkstaff")
    else
        if not inst.components.blinkstaff then --inst.components.blinkstaff == nil 会报错
            inst:AddComponent("blinkstaff")--瞬移杖效果
            inst.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")
            inst.components.blinkstaff.onblinkfn = onblink
        end
    end
end
-------
local function onequip(inst, owner) --装备
    if not owner:HasTag("player") and owner:HasTag("soultide_sp") then
        owner:DoTaskInTime(0, function()
			local inventory = owner.components.inventory
			if inventory then
				inventory:DropItem(inst)
				if owner.components.talker then owner.components.talker:Say("这不是你能够承受的") end
			end
		end)
    end
                           --替换的动画部件	    使用的动画	         替换的文件夹贴图名字（注意这里也是文件夹的名字）
        owner.AnimState:OverrideSymbol("swap_object","swap_soultide_dgs","swap_soultide_dgs")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
        lighton(inst, owner)
        --owner.DynamicShadow:SetSize(1.7, 1)
>>>>>>> 00b334b (v9.8.1)
end

local function onunequip(inst, owner) --解除装备
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    lightoff(inst)

end

<<<<<<< HEAD
local function fn()
    local inst = CreateEntity()
=======

local function dgsmake(mc2) --main c name c
	local mc = "soultide_"..mc2
    STRINGS.NAMES[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.DGS_NAME
	STRINGS.RECIPE_DESC[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.DGS_RECIPE_DESC
	STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(mc)] = TUNING.SOULTIDE.LANGUAGE.DGS_CHAG_DESC
    
    return Prefab(mc,function ()
        local inst = CreateEntity()
>>>>>>> 00b334b (v9.8.1)

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

<<<<<<< HEAD
    inst.AnimState:SetBank("soultide_dgs")  --地上动画
    inst.AnimState:SetBuild("soultide_dgs")
=======
    inst.AnimState:SetBank(mc)  --地上动画
    inst.AnimState:SetBuild(mc)
>>>>>>> 00b334b (v9.8.1)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关
    inst:AddTag("pointy")
    inst:AddTag("weapon")
<<<<<<< HEAD
    inst:AddTag("soultide_weapon")
=======
    inst:AddTag("soultide_E")
>>>>>>> 00b334b (v9.8.1)

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.scale = 1
    inst.shadowE = 0
    inst.gemE = 0
    --网络变量
    inst.net_scale  = net_ushortint(inst.GUID, "net_scale")
    inst.net_shadowE = net_ushortint(inst.GUID, "net_shadowE")
    inst.net_gemE = net_ushortint(inst.GUID, "net_gemE")

<<<<<<< HEAD
    inst.entity:SetPristine()

    local old_GetDisplayName = inst.GetDisplayName --重定义
    inst.GetDisplayName = function(self,...)
        local str = ""
        local level = inst.net_scale:value()
        local se = inst.net_shadowE:value()
        local ge = inst.net_gemE:value()
        local elimit = level * 50
        local function findquality (inst)
            if inst and inst.scale and inst.net_scale then
                if   level <=  TUNING.SOULTIDE.DGS.T2  and level > TUNING.SOULTIDE.DGS.T1 then
                return "blue"
                elseif level <=  TUNING.SOULTIDE.DGS.T3  and level > TUNING.SOULTIDE.DGS.T2 then
                return "purple"
                elseif level <=  TUNING.SOULTIDE.DGS.T4  and level > TUNING.SOULTIDE.DGS.T3 then
                return "golden"
                elseif level <=  TUNING.SOULTIDE.DGS.T5  and level > TUNING.SOULTIDE.DGS.T4 then
                return "red"
                elseif level <=  TUNING.SOULTIDE.DGS.T6  and level > TUNING.SOULTIDE.DGS.T5 then
                return "crystal"
                else
                    return "green"
                end
            end
        end
        if level == TUNING.SOULTIDE.DGS.T1 and elimit == se and elimit == ge   then
            str = "\r\n等阶["..level .. "] 可突破精良"
            str = str .. "\r\n暗影能量："..se.."/".. elimit
            str = str .. "\r\n宝石能量："..ge.."/".. elimit
        elseif level == TUNING.SOULTIDE.DGS.T2 and elimit == se and elimit == ge   then
                str = "\r\n等阶["..level .. "] 可突破史诗"
                str = str .. "\r\n暗影能量："..se.."/".. elimit
                str = str .. "\r\n宝石能量："..ge.."/".. elimit
        elseif level == TUNING.SOULTIDE.DGS.T3 and elimit == se and elimit == ge   then
                    str = "\r\n等阶["..level .. "] 可突破传说"
                    str = str .. "\r\n暗影能量："..se.."/".. elimit
                    str = str .. "\r\n宝石能量："..ge.."/".. elimit
        else
            str = "_" .. findquality(inst).."\r\n等阶["..level .. "]"
            str = str .. "\r\n暗影能量："..se.."/".. elimit
            str = str .. "\r\n宝石能量："..ge.."/".. elimit
        end
        return old_GetDisplayName(self,...)
        ..str 
    end


=======
    inst.net_scale :set(inst.scale) --要写的
    --- 原来自己就有发光属性 那为啥还要再能个prefab
    --额外加入组件
    -- inst.Light:SetRadius(1.5)         -- 光范围
    -- inst.Light:SetIntensity(0.75)     -- 光亮度
    -- inst.Light:SetFalloff(0.9)        -- 光衰减
    -- inst.Light:SetColour(1, 0.84, 0)  -- 颜色（金色）

    -- inst.Light:Enable(false)          -- 先关掉，等掉地上再开

    -------瞬移功能指标 
    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = blinkstaff_reticuletargetfn
    inst.components.reticule.ease = true

    inst.entity:SetPristine()

>>>>>>> 00b334b (v9.8.1)
    if not TheWorld.ismastersim then
        return inst
    end

<<<<<<< HEAD
    -- inst:AddComponent("AbsorbEnergy") --充能组件，感觉不如Trader
=======
    -- inst:AddComponent("AbsorbEnergy") --充能组件，感觉不如Trader，后来还魔改了
>>>>>>> 00b334b (v9.8.1)
    -- inst.components.AbsorbEnergy.E.g = 10
    -- inst.components.AbsorbEnergy.E.s = 10

    -------交易 模拟升级---
    inst:AddComponent("trader")
<<<<<<< HEAD
    inst.components.trader:SetAcceptTest(
        function(inst, item, giver)	
            print("setacceptright")
            local limit = 50 * inst.scale
            local ac = check(item)
            local ac2 , num = check(item,TUNING.SOULTIDE.UP)
            --能量不足可加能
            if inst.gemE < limit  and  ac then
                return true
            end
            if inst.shadowE < limit and ac then
                return true
            end
            --能量满了才能放进阶
            if inst.gemE == limit and inst.shadowE == limit and ac2 and  inst.scale == num - 1 then
                return true
            end
            --return item and (item.prefab == "opalpreciousgem") 超限以后再说
        end
    )
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader:Enable()

    inst:AddComponent("weapon") -- 武器组件
    inst.components.weapon:SetDamage(36 + TUNING.SOULTIDE.EXTRA)
    inst.components.weapon:SetOnAttack(onattack)
=======

    --武器属性
    inst:AddComponent("weapon") -- 武器组件
    inst.components.weapon:SetDamage(36 + TUNING.SOULTIDE.EXTRA)
    inst.components.weapon:SetOnAttack(onattack) --攻击回调
>>>>>>> 00b334b (v9.8.1)
    inst.components.weapon:SetRange(2.4)

    inst:AddComponent("planardamage") --位面伤害
    inst.components.planardamage:SetBaseDamage(TUNING.SOULTIDE.EXTRA)

    inst:AddComponent("damagetypebonus") --阵营伤害
	inst.components.damagetypebonus:AddBonus("shadow_aligned", inst,1)
	inst.components.damagetypebonus:AddBonus("lunar_aligned", inst,1.05)
<<<<<<< HEAD

=======
>>>>>>> 00b334b (v9.8.1)
    inst:AddComponent("timer")

    inst:AddComponent("inspectable") --可检查组件

    inst:AddComponent("inventoryitem") --物品组件
	inst.components.inventoryitem.atlasname = "images/inventoryimages/soultide_dgs.xml" --物品贴图
<<<<<<< HEAD
=======
    --可作为镰刀
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.SCYTHE, 5)


    inst.castsound = "dontstarve/common/staffteleport"
    inst:AddComponent("rechargeable")
    inst.components.rechargeable.chargetime = 8 --8s充满
    inst:ListenForEvent("rechargechange",onchargedfn, inst)

    inst:AddComponent("blinkstaff")--瞬移杖效果
    inst.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")
    inst.components.blinkstaff.onblinkfn = onblink
>>>>>>> 00b334b (v9.8.1)

    inst:AddComponent("equippable") --可装备组件
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
<<<<<<< HEAD
    inst.components.equippable.walkspeedmult = 1.05
=======
    inst.components.equippable.walkspeedmult = 1.04 -- 加速 --不要乱动顺序啊，放前面组件都没有，写昏头了 
    inst:ListenForEvent(("upgrade_Etrade_" .. mc ), update_weapon)
>>>>>>> 00b334b (v9.8.1)

    inst.OnSave = onsave
    inst.OnLoad = onload

<<<<<<< HEAD
    return inst --有笨比不返回
end

return Prefab("soultide_dgs",fn,assets),
        Prefab("dgs_light",dgs_lightfn)
=======
    inst.DoScythe = DoScythe
    inst.IsEntityInFront = IsEntityInFront
    inst.HarvestPickable = HarvestPickable
----光源监听
    inst:ListenForEvent("onputininventory", function()
        lightoff(inst)      -- 在背包里关光
    end)

    inst:ListenForEvent("ondropped", function()
        lighton2(inst,inst)       -- 掉地上开光
    end)

    return inst --有笨比不返回
    end,
    assets
)

end



return dgsmake("dgs"),
        Prefab("dgs_light",dgs_lightfn),
        Prefab("dgs_light2",dgs_light2fn)
>>>>>>> 00b334b (v9.8.1)
