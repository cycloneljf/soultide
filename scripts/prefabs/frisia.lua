--先写基础版的 看看动画 

local MakePlayerCharacter = require "prefabs/player_common"

--官方的角色创建函数
local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset( "ANIM", "anim/frisia.zip" ),
	Asset("ANIM","anim/ghost_frisia_build.zip"),
}

local prefabs = {}
local factor_exp = function(name)
    local t = TUNING.SOULTIDE.FACTOR_EXP
    local result = TUNING.SOULTIDE.FACTOR.GREY
    local count = 0
    for key, value in pairs(t) do
        if string.match(string.upper(name), key) -- 从name的头部开始匹配,比小写
        then
            if value > result then
                result = value --显然，要遍历整个表，表中越后的词缀优先级越大n,但是pairs遍历的是随机的,所以取最大
            end
        end
    end
    return result -- 收不到就是 0.8
end
local function getfromscale(b)
    local c = 0
    while b > 0 do
        local a = math.ceil(b/10)
        if b < 10 then
            c =  c + b * a
        elseif b >= 10 then
            c =  c + 10 * a
        end
        b = b - 10
    end
    return c
end
local function getworldlevel()
    if TheWorld.components.soultide_worldlevel then
        return TheWorld.components.soultide_worldlevel:GetLevel()
    end
end
local function void_make(inst) -- 异世之人--   虚化状态
	if inst.components.drownable~=nil then
			inst.components.drownable.enabled = false
			inst.Physics:ClearCollisionMask()		--移除碰撞，但和下列碰撞
			inst.Physics:CollidesWith(COLLISION.GROUND)	--地面
            inst.Physics:CollidesWith(COLLISION.OBSTACLES)	--障碍
			inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)--小障碍
            inst.Physics:CollidesWith(COLLISION.CHARACTERS)	--角色
			inst.Physics:CollidesWith(COLLISION.GIANTS)	--巨人
	end
end


local function update_frisia(inst) -----注意人物死了就不更新了
    if inst and inst.components and inst.scale and inst.scale_exp then
        local scale = inst.scale
        local exp = inst.scale_exp
    ------------等级结算
        while exp >= scale * TUNING.SOULTIDE.FRISIA.EXPPERSCALE do
            -- 扣除当前等级升级所需经验
            exp = exp - scale * TUNING.SOULTIDE.FRISIA.EXPPERSCALE
            -- 增加等级，但不超过最大等级
            if scale < TUNING.SOULTIDE.FRISIA.MAX_SCALE then
                scale = scale + 1
            else
                break  -- 已到达最大等级，停止循环
            end
        end
        inst.scale = scale
        inst.scale_exp = exp --刷新
    -----------三维
        local a = inst.components.hunger:GetPercent()
        local b = inst.components.health:GetPercent()
        local c = inst.components.sanity:GetPercent()
        if b <= 0 then
            return
        end
        inst.components.hunger:SetMax(TUNING.SOULTIDE.FRISIA.HUNGER + getfromscale(scale) )
        inst.components.sanity:SetMax(TUNING.SOULTIDE.FRISIA.SANITY + getfromscale(scale) )
        inst.components.health:SetMaxHealth(TUNING.SOULTIDE.FRISIA.HEALTH + getfromscale(scale) )

        inst.components.hunger:SetPercent(a)
        inst.components.health:SetPercent(b)
        inst.components.sanity:SetPercent(c)
    -----------战斗
        local planar = math.ceil(scale/10)
        inst.components.planardefense:SetBaseDefense(planar * TUNING.SOULTIDE.FRISIA.PLANAR)
        inst.components.planardamage:SetBaseDamage(planar * TUNING.SOULTIDE.FRISIA.PLANAR)
        -- inst.components.combat.damagemultiplier = 0.9 + planar * 0.1 --基础人物倍率区域-from_scale --查阅combat.lua 这两已经没有了
        -- inst.components.combat.damagetakenmultiplier = 1.05 - planar * 0.05 --基础人物倍率区域-from_scale
        local c_s = inst.crazy_spirit
        local c_t = inst.crystal_tear
        --等级结算 （不同标签来源默认都为乘算）
        inst.components.combat.externaldamagemultipliers:SetModifier(inst, 0.9 + planar * 0.1, "frisia_scale")
        inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst,1.05 - planar * 0.05,"frisia_scale")
        ----物理伤害乘区--狂气结算--
        -----技能树判定/技能cd结算
        local ad = 0.03
        local def = 0.02
        local cd1 =  8
        local cd2 = 20
        if inst.components.skilltreeupdater:IsActivated("frisia_skillup_iv") then  ad = 0.08 def = 0.04 cd1 = 4 cd2 =12
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_iii")  then ad = 0.06 def = 0.035  cd1 = 5 cd2 =14
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_ii")  then ad = 0.05 def = 0.03 cd1 = 6 cd2 =16
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_i")  then  ad = 0.04 def = 0.025 cd1 = 7 cd2 =18
        end
        inst.components.combat.externaldamagemultipliers:SetModifier(inst, 1 + c_s * ad, "frisia_physics")
        ----水晶之泪结算
        inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst,1 - c_t * def,"frisia_crystal_tear")
    ---------工作效率结算
        if inst.components.skilltreeupdater:IsActivated("frisia_live_workeffi_ii") then
            inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 2.1, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE, 2.1, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.SCYTHE, 3.5, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.DIG, 1.75, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1.75, inst)
            inst.components.workmultiplier:AddMultiplier(ACTIONS.NET, 1.75, inst)
        end
        ------
        inst.skill_i_cd = cd1
        inst.skill_ii_cd = cd2

        --设置网络变量
        print("[frisia]set net val")
        inst.net_scale:set(inst.scale)
        inst.net_scale_exp :set(inst.scale_exp)
        inst.net_crazy_spirit:set(inst.crazy_spirit)
        inst.net_crystal_tear:set(inst.crystal_tear)
        inst.net_critical_rate:set(inst.critical_rate *100)
        inst.net_critical_damage:set(inst.critical_damage *100)
        inst.net_soul_core:set(inst.soul_core)
        inst.net_soul_core_potential:set(inst.soul_core_potential)
        --
        if inst.skill_i_cd  then
            inst.net_skill_i_cd:set(inst.skill_i_cd)
        end
        if inst.skill_ii_cd then
            inst.net_skill_ii_cd:set(inst.skill_ii_cd)
        end

    end
end
local function ondeath(inst,data)
    if inst and inst.components and inst.components.soultide_sp then
        inst.components.soultide_sp:DoDelta(-20)
        inst:StopUpdatingComponent(inst.components.soultide_sp)
    end
end
-- 当人物复活的时候
local function onbecamehuman(inst)
	update_frisia(inst)
    void_make(inst)
	inst:StartUpdatingComponent(inst.components.soultide_sp)
end
--当人物变成鬼魂的时候
local function onbecameghost(inst)
end
---击杀恢复sp 0 ~ 56(112) 同时给经验
local function onkill(inst,data)
	if data and data.victim and data.victim.components and data.victim.components.health and data.victim.components.health.maxhealth then
		if inst and inst.components and inst.components.soultide_sp then
            local skill_buf = 1
            if inst.components.skilltreeupdater:IsActivated("frisia_soultide_sp_ii") then
                skill_buf = 1.6
            end
			local maxhel = data.victim.components.health.maxhealth
			local spnow = inst.components.soultide_sp.sp_now
            local spincrease = math.ceil(0.02 * maxhel)
            --exp
            local expgain = math.ceil(0.1*maxhel)
            if maxhel < 20 then
                spincrease = 0
                expgain = 0
            elseif maxhel >= 1000 and maxhel < 10000 then
                spincrease = 20 + math.ceil(0.004 * (maxhel-1000) )
            elseif maxhel >= 10000 then
                spincrease = 56
            end
            if data.victim:HasTag("epic") then
                spincrease = 2 * spincrease
                expgain = 2 * expgain
            end
            if inst.scale_exp then
                inst.scale_exp = inst.scale_exp + expgain
                update_frisia(inst)
            end
			inst.components.soultide_sp:DoDelta(spincrease * skill_buf)
		end
	end
end

-- 初始物品
local start_inv = {}
local prefabsinit = {
	["soultide_candybag_blue"] = 5,
	["soultide_corolla_bt"] = 1,
	["soultide_dgs"] = 1,
}
for k,v in pairs(prefabsinit) do
	for i = 1, v, 1 do  --每次只能插入一个,v是插入数量
		table.insert(start_inv,k)
	end
end

local function onsave(inst,data)
    if data ~= nil then
        local a = inst.components.hunger:GetPercent()
        local b = inst.components.health:GetPercent()
        local c = inst.components.sanity:GetPercent()
        data._frisia_attribute = {
            ["hunger"] = a,
            ["health"] = b,
            ["sanity"] = c,
        }
        data.scale = inst.scale
        data.scale_exp = inst.scale_exp
        data.critical_rate = inst.critical_rate
        data.critical_damage = inst.critical_damage
        data.crazy_spirit = inst.crazy_spirit or 0
        data.crystal_tear = inst.crystal_tear or 0
        data.soul_core = inst.soul_core
        data.soul_core_potential = inst.soul_core_potential
        -- new
        if inst.skill_i_cd then
            data.skill_i_cd = inst.skill_i_cd
        end
        if inst.skill_i_cd then
            data.skill_ii_cd = inst.skill_ii_cd
        end
    end
end
local function onload(inst,data)
    ----状态与组件
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

	if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end



    if data ~= nil then
        if not inst.components.health:IsDead() and data._frisia_attribute then
            for k,v in pairs(data._frisia_attribute) do
                inst.components[k]:SetPercent(v)
            end
        end
    inst.scale = data.scale
    inst.scale_exp = data.scale_exp
    inst.critical_rate = data.critical_rate
    inst.critical_damage = data.critical_damage
    inst.crazy_spirit = data.crazy_spirit or 0
    inst.crystal_tear = data.crystal_tear or 0
    inst.soul_core = data.soul_core
    inst.soul_core_potential = data.soul_core_potential
    ---new
    if data.skill_i_cd then
        inst.skill_i_cd = data.skill_i_cd
    end
    if data.skill_i_cd then
        inst.skill_ii_cd = data.skill_ii_cd
    end
    inst.net_scale:set(inst.scale)
    inst.net_scale_exp :set(inst.scale_exp)
    inst.net_crazy_spirit:set(inst.crazy_spirit)
    inst.net_crystal_tear:set(inst.crystal_tear)
    inst.net_critical_rate:set(inst.critical_rate *100)
    inst.net_critical_damage:set(inst.critical_damage*100)
    inst.net_soul_core:set(inst.soul_core)
    inst.net_soul_core_potential:set(inst.soul_core_potential)
    inst.net_skill_i_cd:set(inst.skill_i_cd)
    inst.net_skill_ii_cd:set(inst.skill_ii_cd)
    end
----------加载完成后更新属性
    update_frisia(inst)
end

------新生成的时候
local function onnewspawn(inst,data)
	onload(inst,data)
end

--[[
特质:花园天使
暴击时+5/5/8/8/10%防御
特质：祛（qu 一声）除虫害 
目标每失去5%生命值
攻击力+0.5%/0.5%/0.75%/0.75%/1%



暴击率：5%
暴击伤害：50%
]]



--能力解放
--攻击后积累狂气被动 --上限五层 --持续时间30s 重复触发刷新时间
--每层增加4%的物理伤害

--这个东西发生在hit伤害结算后，这么写的话第一下永远不会暴击喵,不过没事，概率不会骗人，总体是对的
local function onhitother(inst, data)--(attacker, target, damage, stimuli, weapon, damageresolved)
   
    if data and data.target then
        --------技能树判定
        local atk = 0.005
        local def = 0.05
        if inst.components.skilltreeupdater:IsActivated("frisia_skillup_iv") then atk = 0.01 def = 0.1
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_iii")  then atk = 0.0075 def = 0.08
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_ii")  then atk = 0.0075 def = 0.07
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_i")  then  atk = 0.005 def = 0.06
        end
        ---- inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst,"frisia_garden_angle") 没有提供exist方法 所以选择直接刷新 当然也可以调用组件属性
        ---- inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "frisia_critical")
        inst.components.combat.externaldamagemultipliers:SetModifier(inst, 1 , "frisia_critical")
        inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 1 ,"frisia_garden_angle") ----- 新的因子2
        local target =data.target
        -------------
        if inst and inst.crazy_spirit < TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_MAX then
            inst.crazy_spirit = inst.crazy_spirit + 1
        elseif inst and inst.crazy_spirit >= TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_MAX then
            inst.crazy_spirit =  TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_MAX --维持最大
        end
        if not inst.components.timer:TimerExists("crazy_spirit_maintain") then
            inst.components.timer:StartTimer("crazy_spirit_maintain",TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_TIME + 1)
        elseif inst.components.timer:TimerExists("crazy_spirit_maintain") then --刷新计时
            inst.components.timer:SetTimeLeft("crazy_spirit_maintain",TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_TIME + 1)
        end
        -----------祛除虫害---重复设置会刷新的

        local percent = data.target.components.health:GetPercent()
        inst.components.combat.externaldamagemultipliers:SetModifier(inst,1 +  atk *(1 - percent)/0.05 , "frisia_talent1") --------新的因子 不要漏掉1 + 这是乘算
        if target.components.health:IsDead() then
            inst.components.combat.externaldamagemultipliers:RemoveModifier(inst,"frisia_talent1")
        end
        ------------暴击结算+花园天使-持续到下一次攻击后
        local c_d = inst.critical_damage
        local c_r = inst.critical_rate
        if math.random() <= c_r then
            inst.components.combat.externaldamagemultipliers:SetModifier(inst, 1 + c_d, "frisia_critical")
            inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst,1 - def,"frisia_garden_angle") --减伤，不再加算，官方的代码是pairs遍历所有key，随机的，会有概率减少成0 免疫物理伤害 寄了
        end
        ------------
        update_frisia(inst)
    end
end


--受到攻击也积累狂气, 
--积累水晶之泪--上限10层 -- 每层增加2%的伤害减免 

local function onattacked(inst,data)
    if data and data.attacker then
        if inst and inst.crystal_tear < TUNING.SOULTIDE.FRISIA.CRYSTAL_TEAR_MAX then
            inst.crystal_tear = inst.crystal_tear + 1
        elseif inst and inst.crystal_tear >= TUNING.SOULTIDE.FRISIA.CRYSTAL_TEAR_MAX  then
            inst.crystal_tear =  TUNING.SOULTIDE.FRISIA.CRYSTAL_TEAR_MAX  --维持最大
        end
        if not inst.components.timer:TimerExists("crystal_tear_maintain") then
            inst.components.timer:StartTimer("crystal_tear_maintain",TUNING.SOULTIDE.FRISIA.CRYSTAL_TEAR_TIME  + 1)
        elseif inst.components.timer:TimerExists("crystal_tear_maintain") then
            inst.components.timer:SetTimeLeft("crystal_tear_maintain",TUNING.SOULTIDE.FRISIA.CRYSTAL_TEAR_TIME  + 1)
        end
    end
    if data and data.target then
        local target =data.target
        if inst and inst.crazy_spirit < TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_MAX then
            inst.crazy_spirit = inst.crazy_spirit + 1
        elseif inst and inst.crazy_spirit >= TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_MAX then
            inst.crazy_spirit =  TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_MAX --维持最大
        end
        if not inst.components.timer:TimerExists("crazy_spirit_maintain") then
            inst.components.timer:StartTimer("crazy_spirit_maintain",TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_TIME + 1)
        elseif inst.components.timer:TimerExists("crazy_spirit_maintain") then --刷新计时
            inst.components.timer:SetTimeLeft("crazy_spirit_maintain",TUNING.SOULTIDE.FRISIA.CRAZY_SPIRIT_TIME + 1)
        end
        ------------
    end
    update_frisia(inst)
end
local function buff_ctrl(inst , data)
    if inst and inst.components and inst.components.timer then
        if data.name == "crazy_spirit_maintain" then
            inst.crazy_spirit = 0
        end
        if data.name == "crystal_tear_maintain" then
            inst.crystal_tear = 0
        end
    end
end

--[[战技 默认z键
贪婪之镰
CD:8/7/6/5
伤害：80/80/88/95 %物理伤害
范围：8/9/10/12
sp消耗：30/26/26/24

提供：3/3/6/6%的生命汲取
]]



--[[奥义 默认x键
破灭的欲望
CD:16/15/14/12
伤害:135/135/148/160 % 物理伤害
范围：8/9/10/12
sp消耗：80/72/72/64

释放前根据狂气层数增加暴击伤害 --后续实装

当狂气达到5层时候，本技能必定暴击
且追加一次贪婪之镰

]]

local common_postinit = function(inst)
	-- Minimap icon
	inst.MiniMapEntity:SetIcon("frisia.tex")
    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetDrawOverFogOfWar(true)

	inst:AddTag("frisia")
	inst:AddTag("masterchef")
	inst:AddTag("professionalchef")
	inst:AddTag("fastpicker")	--蜘蛛快采
	inst:AddTag("fastpick")		--成就快采
	inst:AddTag("fastbuilder")	--薇诺娜快速制作 --花园能手
	-- inst:AddTag("expertchef")
    inst.scale = 1
    inst.scale_exp = 0
    inst.crazy_spirit =  0
    inst.crystal_tear =  0
    inst.critical_rate = 0.25
    inst.critical_damage = 0.5
    inst.soul_core = 0
    inst.soul_core_potential = 0
    inst.skill_i_cd = 8 -- test
    inst.skill_ii_cd = 20 -- test
    --网络变量初始化
    inst.net_scale  = net_ushortint(inst.GUID, "net_scale")
    inst.net_scale_exp = net_ushortint(inst.GUID, "net_scale_exp")
    inst.net_crazy_spirit = net_ushortint(inst.GUID, "net_crazy_spirit")
    inst.net_crystal_tear  = net_ushortint(inst.GUID, "net_crystal_tear")
    inst.net_critical_rate = net_ushortint(inst.GUID, "net_critical_rate")
    inst.net_critical_damage = net_ushortint(inst.GUID, "net_critical_damage")
    inst.net_soul_core = net_ushortint(inst.GUID, "net_soul_core")
    inst.net_soul_core_potential = net_ushortint(inst.GUID, "net_soul_core_potential")
    inst.net_skill_i_cd =  net_ushortint(inst.GUID, "net_skill_i_cd","net_skill_i_cd_dirty")
    inst.net_skill_ii_cd =  net_ushortint(inst.GUID, "net_skill_ii_cd","net_skill_ii_cd_dirty")

    --设置网络变量
    inst.net_scale:set(inst.scale)
    inst.net_scale_exp :set(inst.scale_exp)
    inst.net_crazy_spirit:set(inst.crazy_spirit)
    inst.net_crystal_tear:set(inst.crystal_tear)
    inst.net_critical_rate:set(inst.critical_rate * 100)
    inst.net_critical_damage:set(inst.critical_damage *100)
    inst.net_soul_core:set(inst.soul_core)
    inst.net_soul_core_potential:set(inst.soul_core_potential)
    inst.net_skill_i_cd:set(inst.skill_i_cd)
    inst.net_skill_ii_cd:set(inst.skill_ii_cd)

end
---部分升级系统--修改进食
local function oneat(inst,food)
    local scale = inst.scale
    local  spf =  factor_exp(food.prefab)
	if food and string.match(food.prefab,"candy") then ---并没有限制是本模组的糖果
        if inst and inst.scale and inst.scale_exp then
            if scale <= 9  then
                inst.scale_exp = inst.scale_exp + TUNING.SOULTIDE.BASE_EXP * spf
            elseif scale > 9 and scale <=19 then
                if spf >= TUNING.SOULTIDE.FACTOR_EXP.GREEN then
                    inst.scale_exp = inst.scale_exp + TUNING.SOULTIDE.BASE_EXP * spf
                end
            elseif scale > 19 and scale <=29 then
                if spf >= TUNING.SOULTIDE.FACTOR_EXP.BLUE then
                    inst.scale_exp = inst.scale_exp + TUNING.SOULTIDE.BASE_EXP * spf
                end
            elseif scale > 29 and scale <=39 then
                if spf >= TUNING.SOULTIDE.FACTOR_EXP.PURPLE then
                    inst.scale_exp = inst.scale_exp + TUNING.SOULTIDE.BASE_EXP * spf
                end
            end
        end
	end
    if food and string.match(food.prefab,"soultide_moonsoul") then
        inst.soul_core = inst.soul_core + 1
        inst.scale_exp = inst.scale_exp + TUNING.SOULTIDE.BASE_EXP * spf
    end
    if food and string.match(food.prefab,"soultide_moonspringcrystal") then
        inst.soul_core_potential = inst.soul_core_potential + 1
        inst.scale_exp = inst.scale_exp + TUNING.SOULTIDE.BASE_EXP * spf
    end
    update_frisia(inst)
end


local master_postinit = function(inst)

	

    local scale = inst.scale or 1 --不写or也可以 毕竟common和master会组装

	inst.soundsname = "wendy"
	inst.customidleanim = "idle_wendy"



-----------三维
	inst.components.hunger:SetMax(TUNING.SOULTIDE.FRISIA.HUNGER + getfromscale(scale) )
	inst.components.sanity:SetMax(TUNING.SOULTIDE.FRISIA.SANITY + getfromscale(scale) )
	inst.components.health:SetMaxHealth(TUNING.SOULTIDE.FRISIA.HEALTH + getfromscale(scale) )
	inst.components.sanity.no_moisture_penalty = true --精神不受潮湿影响 --园丁
    inst.components.hunger.hungerrate = 1.2 * TUNING.WILSON_HUNGER_RATE
--------正常战斗
    -- inst.components.combat.damagemultiplier = 1   --这个没有了
    -- inst.components.health.absorb = 0               --这个强烈反对使用 

	inst:AddComponent("reader") --可以读书
	inst:AddComponent("soultide_sp")
    --inst:AddComponent("timer")  already exist?
---------
	inst.components.eater.ignoresspoilage = true --无视腐烂惩罚
	inst.components.eater:SetOnEatFn(oneat)

	inst.components.temperature.inherentinsulation = 12         --冷热抗性
	inst.components.temperature.inherentsummerinsulation = 12

	--inst:AddComponent("planarentity") --异界来客 位面实体 对物理伤害有抵抗 原伤害与减免后的伤害的一阶导数是 1 > 4/(x + 16)^0.5 物理伤害越高减少的越多 比如 84 -> 48 ,384 -> 128
	--inst:AddComponent("planardefense")
	--inst:AddComponent("planardamage")
    inst.components.planardefense:SetBaseDefense(5)
    inst.components.planardamage:SetBaseDamage(5)
	--inst:AddComponent("damagetypebonus")
	inst.components.damagetypebonus:AddBonus("lunar_aligned",inst,1.1)	--对月亮单位额外10%伤害

    --不会淹死--虚化
	if inst.components.drownable then
		inst.components.drownable.TakeDrowningDamage = function() return end
	end

	--免疫诅咒
	inst.components.cursable.ApplyCurse = function(self,item,curse,...)
		if self.inst and self.inst.components.soultide_sp then
			self.inst.components.soultide_sp:DoDelta(-5)
		end

		self.inst.components.talker:Say(TUNING.SOULTIDE.LANGUAGE.ON_CURSE)
		item:DoTaskInTime(1,item.Remove)
	end
    --清空月亮猴王的清除诅咒函数
	inst.components.cursable.RemoveCurse = function() end
	inst.components.cursable.IsCursable = function()  return false end

    void_make(inst)
-----------------------

	inst:ListenForEvent("onhitother", onhitother)
    inst:ListenForEvent("attacked",onattacked)
	inst:ListenForEvent("death", ondeath)
	inst:ListenForEvent("killed", onkill)
-- -------传送后重新获得自己独有的物理效果 不如用手持武器刷新
--     inst:ListenForEvent("ms_playerdespawnandmigrate",aftertele_void_make,TheWorld)
    ------------buff 
    inst:ListenForEvent("timerdone", buff_ctrl)
-----------------
    ---园艺能手
	inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 1.2, inst)
    inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE, 1.2, inst)
    inst.components.workmultiplier:AddMultiplier(ACTIONS.SCYTHE, 2, inst)

	--睡眠相关 --睡觉时候 sp恢复速度的平时的两倍，并且享受睡眠用具对精神加成的一半增量
	if inst.components.sleepingbaguser then	
		local old_sleeptick = inst.components.sleepingbaguser.SleepTick
		function inst.components.sleepingbaguser:SleepTick()
			local goodsleeperequipped = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD):HasTag("good_sleep_aid")
			local sp_tick = self.bed.components.sleepingbag.sanity_tick * self.sanity_bonus_mult * (goodsleeperequipped and TUNING.GOODSLEEP_SANITY or 1)
			inst.components.soultide:DoDelta(sp_tick*0.5)
			if old_sleeptick then
				old_sleeptick(self)
			end
		end
	end

	inst.OnSave = onsave
	inst.OnLoad = onload
    inst.OnNewSpawn = onnewspawn

end
--common_postinit 是主客机都有的 master是主机独占的 而网络变量要求主客机都有
return MakePlayerCharacter("frisia", prefabs, assets, common_postinit, master_postinit, start_inv),
CreatePrefabSkin("frisia_none",
{
	base_prefab = "frisia",
	skins =
	{
		normal_skin = "frisia",
		ghost_skin = "ghost_frisia_build",
	}, 
	assets = 
	{
		Asset( "ANIM", "anim/frisia.zip" ),
		Asset( "ANIM", "anim/ghost_frisia_build.zip" ),
	},
	skin_tags = {"BASE" ,"FRISIA", "CHARACTER"},

	build_name_override = "frisia",
	rarity = "Character",
})
