<<<<<<< HEAD
--也是hook
=======
--也是hook 
--配方表加入可交易组件
>>>>>>> 00b334b (v9.8.1)
local function AddTradableComponent(inst)
    if inst and inst.components and inst.components.tradable == nil then
        inst:AddComponent("tradable")
    end
end

local moretrade = TUNING.SOULTIDE.ENERGY_LIST
for key , _ in pairs(moretrade) do
    AddPrefabPostInit( key, AddTradableComponent)
end



<<<<<<< HEAD
=======
-- ----  -- Test -- 给角色的自定义组件
-- local function AddSpComponent(inst)

--     if inst and inst.components  and inst.components.soultide_sp == nil then
-- 		inst:AddComponent("soultide_sp") --注意Add函数作用于本体

-- 		print("is true")
-- 		if inst.components.soultide_sp ~= nil then
-- 			inst.components.soultide_sp:SetNow(64)
-- 		end
-- 		inst:StartUpdatingComponent(inst.components.soultide_sp)
-- 		--------手动更新啊
-- 		local function onbecamehuman(inst)
-- 			inst:StartUpdatingComponent(inst.components.soultide_sp)
-- 		end
-- 		inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
-- 	end
-- end

-- local charac = {
-- 	"wilson",
--     "willow",
-- }
-- for _, value in ipairs(charac) do
-- 	AddPrefabPostInit( value ,AddSpComponent) --允许判断一定要写在这个前 执行的时候分两步，预加载这个，进去游戏之后才调用后面的
-- 	print("setting sp for" .. value )
-- end




-- 给玩家头上挂一个文本
AddPlayerPostInit(function (player)
		-- 必须是服务端创建网络变量
    -- if TheWorld.ismastersim then
	-- 	local inst = player --传入的inst
	-- 	if inst.prefab == "frisia" then
    --     inst.skill_i_cd = net_float(inst.GUID, "skill_i_cd", "skill_i_cd_dirty")
    --     inst.skill_ii_cd = net_float(inst.GUID, "skill_ii_cd", "skillii_cd_dirty")
    -- 	end
    -- end

	if  TUNING.SOULTIDE.SHOW_TXT_OVERHEAD == false then
		return
	end
    -- 在主机上为玩家添加组件
    if GLOBAL.TheWorld.ismastersim and player.components and not player.components.soultide_sp then
        player:AddComponent("soultide_sp")		
    end


    -- 只有你的角色才加变量

	---更新你的组件
	if player and player.components and player.components.soultide_sp then
		player:StartUpdatingComponent(player.components.soultide_sp)
	end
    player:DoTaskInTime(1,function (player)
        local FollowText = GLOBAL.require "widgets/followtext"
        -- 仅在玩家有HUD时处理这个
        if player and player.HUD then
            player.headwidget = player.HUD:AddChild(FollowText(GLOBAL.TALKINGFONT, 32))
            player.headwidget:SetHUD(player.HUD.inst)
            player.headwidget:SetOffset(GLOBAL.Vector3(0, -600, 0))
            player.headwidget:SetTarget(player)
            player.headwidget.text:SetColour(255/255, 192/255, 203/255, 0.6)
            player.headwidget.text:SetString("sp: 没有数据")
            player.headwidget:Show()

            local OldOnUpdate = player.headwidget.OnUpdate
            -- OnUpdate会持续更新UI组件的状态，可以不断读取属性值来修改文本显示
            player.headwidget.OnUpdate = function (self, dt)
                OldOnUpdate(self, dt)
                -- 用replica的GetCurrent来获取数据，如果要移植到单机，此处只需替换replica为components
				-- 这里应该是主机获得客机的角色数据
				if  player.replica.soultide_sp then
					local current = player.replica.soultide_sp:GetNow()
					local speed = player.replica.soultide_sp:GetChangeSpeed()
					--apis先于角色加载 所以一定要判空
					local exp = (player.net_scale_exp and player.net_scale_exp:value()) or player.scale_exp or -1
					local scale =  (player.net_scale and player.net_scale:value()) or player.scale  or -1
					local c_s =  (player.net_crazy_spirit and player.net_crazy_spirit:value() ) or player.crazy_spirit  or -1
					local c_t =  ( player.net_crystal_tear and  player.net_crystal_tear:value()) or player.crystal_tear or  -1
					player.headwidget.text:SetString(string.format(
					[[sp:+%.2f lv %d-%d
				狂气 %d 水晶之泪 %d]],
					speed,scale,exp,c_s,c_t))
				end
            end
        end
    end)
end)

--技能要触发收割效果，暴击，并且具有目标越少伤害越高(对单5倍伤害) ,触发被动的特性

---贪婪之镰
--range 8/9/10/11/12 前方180度
--sp consume 24/24/20/18/16
--health heal 2/3/4/5/6%
--dmg 75/88/100/110/120% 倍率 当然无视防御
--cd 9/8/7/6/5 second
--RADIANS  = 180/pi(constants.lua) 除以RADIANS 就是角度制化为弧度制 
local function IsEntityInFront(inst, entity, doer_rotation, doer_pos)
    local facing = Vector3(math.cos(-doer_rotation / RADIANS), 0 , math.sin(-doer_rotation / RADIANS))

    return IsWithinAngle(doer_pos, facing, 180/RADIANS, entity:GetPosition()) --范围
end

local _MUSTTAGS  = {"_combat"}
local _CANTTAGS  = {"INLIMBO", "FX","companion","friend"}


local frisia_skill_i = function (inst , rate)
    if inst and inst.prefab == "frisia" then
		print("[SERVER] frisia_skill_i RPC RECEIVED")

        -------判断技能等级
        local skill_lv = 0
		local sp = 24
        rate =  rate or 0.75
        inst.IsEntityInFront = IsEntityInFront
        if inst.components.skilltreeupdater:IsActivated("frisia_skillup_iv") then  skill_lv =4 rate = 1.20 sp = 16
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_iii")  then skill_lv =3 rate = 1.10 sp = 18
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_ii")  then skill_lv =2 rate = 1.00 sp = 20
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_i")  then  skill_lv =1 rate = 0.88 sp = 24
        end
        
        local cd = 8 - skill_lv
		if inst.skill_i_cd then
			print("set skill cd_1")
			inst.skill_i_cd = cd
			if inst.net_skill_i_cd then
				print("set net skill cd_1")
				inst.net_skill_i_cd:set(cd)
			end
		end
        local r = 8 + skill_lv
        --判断CD sp
        if inst.components.soultide_sp:GetNow() <= sp or inst.components.timer:TimerExists("frisia_skill_i") then
            return
        else
            inst.components.soultide_sp:DoDelta( -sp ) --是消耗
            inst.components.timer:StartTimer("frisia_skill_i",cd)
			-- inst:PushEvent("frisia_skill_i_start", { cd = cd }) --推送cd事件和数据到hud 主客机 事件不同步
			-- 
			-- if inst.skill_i_cd  then --网络变量
			-- 	inst.skill_i_cd = cd
			-- 	print("发送e cd")
			-- else
			-- 	print("没这个i变量")
			-- end
        end
        ------检测目标
        local doer_pos = inst:GetPosition()
        local x, y, z = doer_pos:Get()

        local doer_rotation = inst.Transform:GetRotation()
		--print(tostring( doer_rotation))
        local ents = TheSim:FindEntities(x, y, z, r , _MUSTTAGS, _CANTTAGS) --range
        
		local dmg,pdmg = 10,0
        ---检测武器
        local weapon = inst.components.combat:GetWeapon()
		if weapon ~= nil then  --记得判空 
			dmg = weapon.damage or 10
			---算自身伤害加成的位面伤害
			pdmg = weapon.components.planardamage:GetDamage() or 0
		end
		--过滤实体
		local entities = {}
		for _, ent in pairs(ents) do
			
			if inst:IsEntityInFront(ent, doer_rotation, doer_pos) then
				table.insert(entities,ent)
			end
		end
		local num = #entities

        for _, ent in pairs(entities) do --对其中的每一个实体
            if ent:IsValid() and ent.components.health ~= nil then
				--触发frisia增益
				inst:PushEvent("onhitother",{target = ent})
				--buff增伤(当然包括暴击buff) 
				local buff = inst.components.combat.externaldamagemultipliers:Get() or 1
				--阵营增伤
				local bonus = inst.components.damagetypebonus:GetBonus(ent) or 1
				local mount = (dmg + pdmg) * bonus * buff * (math.max(5/num , 1)) * rate
				inst.components.health:DoDelta(mount * (2 + skill_lv) * 0.01) --生命汲取 可以考虑放入onhitother当被动 算了
				local maxhealth = ent.components.health.maxhealth --一定要打对啊
				ent.components.health:DoDelta( - mount, nil, inst.prefab, true, inst, true) -- 无视无敌 无视防御 但是不会无视锁血
								----death
				if ent.components.health:IsDead() then
					inst:PushEvent("killed", { victim = ent })
						--------收割 额外掉落一次
					if  ent and inst and ent.components.lootdropper -- and target.components.lootdropper.loot这个没有，只有掉落的时候才生成的
					then
						ent.components.lootdropper:DropLoot(doer_pos) --需要vector(x,y,z)
					end
					local fx = SpawnPrefab("shadow_puff")
					fx.Transform:SetPosition(doer_pos:Get()) --需要x,y,z
					---fx 以后再说吧

				end
				--local fxx = SpawnPrefab("willow_shadow_fire_explode")
				local fxx = SpawnPrefab("shadow_glob_fx")
				if maxhealth <= 1000 then
					fxx.Transform:SetScale(4, 4, 4)
				elseif maxhealth <= 10000 and maxhealth > 1000 then
					fxx.Transform:SetScale(6, 6, 6)
				elseif maxhealth >= 10000 then
					fxx.Transform:SetScale(8, 8, 8)
				end
				
				fxx.Transform:SetPosition(ent:GetPosition():Get())
            end
        end
    end
end

--破灭的欲望
--range 8/9/10/11/12 前方180度
--sp consume 80/72/72/68/64
--dmg 120/135/150/165/180% 倍率 当然无视防御 对单最高八倍
--cd 20/18/16/14/12 second
--RADIANS  = 180/pi(constants.lua) 除以RADIANS 就是角度制化为弧度制 
local frisia_skill_ii = function (inst ,rate)
    if inst and inst.prefab == "frisia" then

        print("[SERVER] frisia_skill_ii RPC RECEIVED")
        -------判断技能等级
        local skill_lv = 0
		local sp = 80
        
        inst.IsEntityInFront = IsEntityInFront
        if inst.components.skilltreeupdater:IsActivated("frisia_skillup_iv") then  skill_lv =4  sp = 64
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_iii")  then skill_lv =3  sp = 68
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_ii")  then skill_lv =2  sp = 72
        elseif inst.components.skilltreeupdater:IsActivated("frisia_skillup_i")  then  skill_lv =1  sp = 72
        end
    	rate = rate or (1.20 + 0.15 * skill_lv)
        local cd = 20 - skill_lv * 2
		if inst.skill_ii_cd then
			inst.skill_ii_cd = cd
			print("set skill cd 2")
			if inst.net_skill_ii_cd then
				inst.net_skill_ii_cd:set(cd)
				print("set net skill cd 2")
			end
		end
        local r = 8 + skill_lv
        --判断CD sp
        if inst.components.soultide_sp:GetNow() <= sp or inst.components.timer:TimerExists("frisia_skill_ii") then
            return
        else
            inst.components.soultide_sp:DoDelta( -sp)
            inst.components.timer:StartTimer("frisia_skill_ii",cd)
			-- if inst.skill_ii_cd  then --网络变量
			-- 	inst.skill_ii_cd = cd
			-- 	print("设置了q cd")
			-- else
			-- 	print("没这个ii变量")
			-- end
        end
        ------检测目标
        local doer_pos = inst:GetPosition()
        local x, y, z = doer_pos:Get()
        local doer_rotation = inst.Transform:GetRotation()
        local ents = TheSim:FindEntities(x, y, z, r , _MUSTTAGS, _CANTTAGS) --range
        local num = #ents
		
		local dmg,pdmg = 10,0
        ---检测武器
        local weapon = inst.components.combat:GetWeapon()
		if weapon ~= nil then  --记得判空 
			dmg = weapon.damage or 10
			---算自身伤害加成的位面伤害
			pdmg = weapon.components.planardamage:GetDamage() or 0
		end
		--过滤实体
		local entities = {}
		for _, ent in pairs(ents) do
			
			if inst:IsEntityInFront(ent, doer_rotation, doer_pos) then
				table.insert(entities,ent)
			end
		end
		local num = #entities
		
        for _, ent in pairs(entities) do --对其中的每一个实体
            if ent:IsValid() and ent.components.health ~= nil then             
				--触发frisia增益
				inst:PushEvent("onhitother",{target = ent})
				--五层狂气时候 必定暴击并且额外触发一次倍率为30%的贪婪之镰
				if inst.crazy_spirit == 5 then
					local c_d = inst.critical_damage
					inst.components.combat.externaldamagemultipliers:SetModifier(inst, 1 + c_d, "frisia_critical")
					inst:DoTaskInTime(0.5,frisia_skill_i(inst,0.3))
					--?会卡吗
				end

				--buff增伤(当然包括暴击buff)
				local buff = inst.components.combat.externaldamagemultipliers:Get() or 1
				--阵营增伤
				local bonus = inst.components.damagetypebonus:GetBonus(ent) or 1

				local mount = (dmg + pdmg) * bonus * buff * (math.max(8/num , 1)) * rate
				--inst.components.health:DoDelta(mount * (2 + skill_lv) * 0.01) --生命汲取 可以考虑放入onhitother当被动 算了
				ent.components.health:DoDelta( - mount, nil, inst.prefab, true, inst, true) -- 无视无敌 无视防御 但是不会无视锁血

				----death
				if ent.components.health:IsDead() then
					inst:PushEvent("killed", { victim = ent })
						--------收割 额外掉落一次
					if  ent and inst and ent.components.lootdropper -- and target.components.lootdropper.loot这个没有，只有掉落的时候才生成的
					then
						ent.components.lootdropper:DropLoot(doer_pos) --需要vector(x,y,z)
					end
					local fx = SpawnPrefab("shadow_puff")
					fx.Transform:SetPosition(doer_pos:Get()) --需要x,y,z
				end
				---fx 以后再说吧
				local fxx = SpawnPrefab("willow_shadow_fire_explode")
				fxx.Transform:SetPosition(ent:GetPosition():Get())
            end
        end
    end
end
-- 不可以
-- AddModRPC("soultide_frisia", "frisia_skill_i")
-- AddModRPC("soultide_frisia", "frisia_skill_ii")


AddModRPCHandler("soultide_frisia", "frisia_skill_i", frisia_skill_i)
AddModRPCHandler("soultide_frisia", "frisia_skill_ii", frisia_skill_ii)
--添加技能
--客机的数据也要给主机进行处理
--这里在客户端
AddPlayerPostInit(function (player)
	if player and player.prefab ~= "frisia" then
		return
	end
	local inst = player
	if inst.components.timer == nil  then
		-- inst.components:AddComponent("timer") 呃呃 怎么说
		inst:AddComponent("timer")
	end
	
	TheInput:AddKeyDownHandler(KEY_Z,function()
		print("贪婪之镰 按键")
		if inst.components.timer:TimerExists("frisia_skill_i") then
			return
		else
			SendModRPCToServer(GetModRPC("soultide_frisia", "frisia_skill_i"))
			print("贪婪之镰 发送RPC")
			inst:DoTaskInTime(0.1, function()
				inst:PushEvent("frisia_skill_i_cd")
				print("贪婪之镰 发送cd")
			end)
		end

	end)

	TheInput:AddKeyDownHandler(KEY_X,function()
		print(" 破灭的欲望 按键")

		if inst.components.timer:TimerExists("frisia_skill_ii") then
			return
		else
			SendModRPCToServer(GetModRPC("soultide_frisia", "frisia_skill_ii"))
			print("破灭的欲望 发送RPC")
			-------手动调整 不写两个的顺序会随机运行 游戏底层这一块
			inst:DoTaskInTime(0.1, function()
				inst:PushEvent("frisia_skill_ii_cd")
				print("贪婪之镰 发送cd")
			end)
		end
	end)
end)


-- -- RPC的注册-使用例
-- AddModRPCHandler("Lesson Network","RandomPho", function(player, num)
--     -- 在RPC函数中，默认是主机环境，直接引用components
--     player.components.pho.current = num
-- end)

-- -- 按下R键随机更新光合度
-- GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_R, function()
--     local num = GLOBAL.math.random()*100
--     SendModRPCToServer(GetModRPC("Lesson Network","RandomPho"), num)
-- end)

-- 引入技能HUD
local SkillHUD = require("widgets/soultide_skillhub")

-- 给HUD注入技能面板
local function addskillhud(self)
	if self.owner and self.owner.prefab == "frisia" then --给本mod的角色加入
		local function AddSkillHud(hud)--这里的hud其实就是self
        if hud.owner then
            -- 添加自定义技能HUD
            hud.activeskill = hud:AddChild(SkillHUD(hud.owner))
            -- 设置在屏幕底部中间偏下位置
            hud.activeskill:SetPosition(-50, -550)
            print("[SkillHUD] Active Skill HUD Loaded for:", hud.owner.prefab)

			--在这里重载Onupdate 使得层数变量能够传入
			local OldOnUpdate = hud.activeskill.OnUpdate
			-- OnUpdate会持续更新UI组件的状态，可以不断读取属性值来修改文本显示
			hud.activeskill.OnUpdate = function(self,dt)
				local buff_4 =  (hud.owner.net_crazy_spirit and hud.owner.net_crazy_spirit:value() ) or hud.owner.crazy_spirit  or -1
				local buff_3 =  (hud.owner.net_crystal_tear and  hud.owner.net_crystal_tear:value()) or hud.owner.crystal_tear or  -1
				hud.activeskill:StartSkill3NUM(buff_3)
				hud.activeskill:StartSkill4NUM(buff_4)
				OldOnUpdate(self,dt)
			end

			hud.activeskill:StartUpdating() --开启更新
			--监听cd
			--print(" [skillhub] jian ting jineng  cd")
			-- hud.owner:ListenForEvent("skill_i_cd_dirty", function() -- 不开洞穴不设置网络变量
			-- 	local cd = hud.owner.skill_i_cd:value()
			-- 	hud.activeskill:StartSkill1CD(cd)
			-- 	print("shou dao e cd")
			-- end)
			-- hud.owner:ListenForEvent("skill_ii_cd_dirty", function()
			-- 	local cd =  hud.owner.skill_ii_cd:value()
			-- 	hud.activeskill:StartSkill2CD(cd)
			-- 	print("shou dao q cd")
			-- end)
			hud.owner:ListenForEvent("frisia_skill_i_cd",function ()
				local cd = (hud.owner.net_skill_i_cd and hud.owner.net_skill_i_cd:value()) or hud.owner.skill_i_cd or 15
				print("the e cd is" .. cd)
				hud.activeskill:StartSkill1CD(cd)
			end)
			hud.owner:ListenForEvent("frisia_skill_ii_cd",function ()
				local cd = (hud.owner.net_skill_ii_cd and hud.owner.net_skill_ii_cd:value()) or hud.owner.skill_ii_cd or 15
				print("the q cd is" .. cd)
				hud.activeskill:StartSkill2CD(cd)
			end)

        else
            print("[SkillHUD] No owner yet.")
        end
    end
    -- 延迟执行确保HUD加载完成
    self.inst:DoTaskInTime(1, function() AddSkillHud(self) end)
	end
end

AddClassPostConstruct("widgets/statusdisplays",addskillhud)

----注入信息面板
local InfoPanel = require("widgets/soultide_infopanel")
local ImageButton = require "widgets/imagebutton"

local function AddInfoButton(hud)
    if hud.owner and hud.owner.prefab == "frisia" then
        -- 创建按钮
        hud.info_button = hud:AddChild(ImageButton(
            "images/skillicon/icon_info_button_001.xml",
            "icon_info_button_001.tex"
        ))
        -- 设置位置（屏幕右上角偏下，距离中心偏右）--中心点 -50, -550
        hud.info_button:SetPosition(-30, -570)
        hud.info_button:SetScale(0.8)
        hud.info_button.image:SetTint(1, 1, 1, TUNING.SOULTIDE.BACKGROUND_TRANSPARENCY)  -- 半透明


        -- 创建信息面板
        hud.infopanel = hud:AddChild(InfoPanel(hud.owner))
        hud.infopanel:SetPosition(-750, -250)  -- 面板居中

        -- 点击按钮切换面板显示
        hud.info_button:SetOnClick(function()
            hud.infopanel:Toggle()
        end)
    end
end

AddClassPostConstruct("widgets/statusdisplays", AddInfoButton)

--sp显示位置初始化
local sp = require("widgets/soultide_sp_badge")
local function sppoint(self) --你没有给
	if self.owner and self.owner.prefab == "frisia" then --.prefab == "fulixia" 给全角色增加
		print("owner exist")
		self.soultide_sp = self:AddChild(sp(self.owner)) -- widget 绑定角色
		print("is true")
		self.owner:DoTaskInTime(0.5, function()
			local x1 ,y1,z1 = self.stomach:GetPosition():Get() -- -40 20 0
			local x2 ,y2,z2 = self.brain:GetPosition():Get()  --0 40 0
			local x3 ,y3,z3 = self.heart:GetPosition():Get()  -- 40 20 0
			if y2 == y1 or  y2 == y3 then --开了三维mod
				self.soultide_sp:SetPosition(self.stomach:GetPosition() + Vector3(x1-x2, 0, 0))
				--self.soultide_sp.num:SetPosition(self.stomach:GetPosition() + Vector3(x1-x2, 0, 0)) --向量Vertor不能直接乘2
			else
				self.soultide_sp:SetPosition(self.stomach:GetPosition() + Vector3(x1-x3, 0, 0))
				print(string.format("heart x y x are %d %d %d",x1 , y1 ,z1))
				-- self.soultide_sp.num:SetPosition(self.stomach:GetPosition() +  Vector3((x1-x3), 0, 0))
				if self.soultide_sp.num then
					self.soultide_sp.num:Hide()
				end
				print("set num")
			end
			--刷新 一定要写
			self.soultide_sp:StartUpdating()
		end)

		-- local old_Onupdate = self.OnUpdate
		-- self.OnUpdate = function (self ,dt)
		-- 	old_Onupdate(self,dt)
		-- 	self.soultide_sp:OnUpdate(dt)
		-- end
		--死亡的时候隐藏
		local old_SetGhostMode = self.SetGhostMode
		function self:SetGhostMode(ghostmode,...)
			old_SetGhostMode(self,ghostmode,...)
			if ghostmode then
				if self.soultide_sp ~= nil then
					self.soultide_sp:Hide()
					if self.soultide_sp.num ~= nil then
						self.soultide_sp.num:Hide() --写的时候和上面一样要判空啊 -又一次崩溃
					end
					
				end
			else
				if self.soultide_sp ~= nil then
					self.soultide_sp:Show()
					if self.soultide_sp.num ~= nil then
						self.soultide_sp.num:Show()
					end
					
				end
		    end
	    end
	end
end
AddClassPostConstruct("widgets/statusdisplays",sppoint)

---双倍收取锅
local cooking = require("cooking")
AddComponentPostInit("stewer", function(self)
    local old_harvest = self.Harvest
    function self:Harvest(harvester)
    	if not harvester or harvester.prefab ~= "frisia" then
			return old_harvest(self, harvester)
		elseif harvester.prefab == "frisia" and harvester.components.skilltreeupdater:IsActivated("frisia_live_workeffi_i") == false then
			return old_harvest(self, harvester)  --技能树判定
        else
			if self.done then
				if self.onharvest ~= nil then
					self.onharvest(self.inst)
				end
				if self.product ~= nil then
					local loot = GLOBAL.SpawnPrefab(self.product)
					if loot ~= nil then
						if harvester ~= nil and self.chef_id == harvester.userid then  --自己做的
							harvester:PushEvent("learncookbookrecipe", {product = self.product, ingredients = self.ingredient_prefabs})
						end
	
						local recipe = cooking.GetRecipe(self.inst.prefab, self.product)
						local stacksize = recipe and recipe.stacksize or 1
						if stacksize >= 1 and loot.components.stackable then
							loot.components.stackable:SetStackSize( stacksize * 2 )
						end
					
						if self.spoiltime ~= nil and loot.components.perishable ~= nil then
							local spoilpercent = self:GetTimeToSpoil() / self.spoiltime
							loot.components.perishable:SetPercent(self.product_spoilage * spoilpercent)
							loot.components.perishable:StartPerishing()
						end
						if harvester ~= nil and harvester.components.inventory ~= nil then
							harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
						else
							LaunchAt(loot, self.inst, nil, 1, 1)
						end
					end
					self.product = nil
				end
				if self.task ~= nil then
					self.task:Cancel()
					self.task = nil
				end
				self.targettime = nil
				self.done = nil
				self.spoiltime = nil
				self.product_spoilage = nil
				if self.inst.components.container ~= nil then   
					self.inst.components.container.canbeopened = true
				end
				return true
			end
		end
    end
end)

--状态机修改 
AddStategraphPostInit("wilson", function(sg)
	--5层狂气潮湿不脱手
	if sg.events and sg.events.unequip then --脱手事件
		local old_unequip = sg.events.unequip.fn --重写
		sg.events.unequip.fn = function(inst, data)--不进入脱手的sg就不会脱手)
			if inst:HasTag("frisia") and (inst.sg:HasStateTag("idle") or inst.sg:HasStateTag("channeling")) and data.item ~= nil and data.item:IsValid() then
				if inst.crazy_spirit == 5 then
					return
				end		
			end
			return old_unequip and old_unequip(inst, data) --与门 为真返回old_unequip 为假的 返回false `and` 操作符在遇到假值时会立即停止计算并返回假值
        end
	end
    --5层狂气时被攻击不会僵直  
	if sg.events and sg.events.attacked then
		local oldattackedfn = sg.events.attacked.fn
		sg.events.attacked.fn = function(inst, data)--{ attacker = attacker, damage = damage, damageresolved = damageresolved, original_damage = original_damage, weapon = weapon, stimuli = stimuli, spdamage = spdamage, redirected = damageredirecttarget, noimpactsound = self.noimpactsound }
			if inst.crazy_spirit == 5 or inst:HasTag("playerghost")  then-- 5层狂气免疫僵直 变鬼也免疫吧
				return
			end
			return oldattackedfn and oldattackedfn(inst, data)
        end
	end
	--搬运大理石雕像不减速	参考的代码作者：恒子 感谢大佬
	if sg.states.run_start then
		local oldonenter = sg.states.run_start.onenter
		sg.states.run_start.onenter = function(inst)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("frisia") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pre")
				inst.sg.mem.footsteps = 0--(inst.sg.statemem.goose or inst.sg.statemem.goosegroggy) and 4 or 0
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
	if sg.states.run then
		local oldonenter = sg.states.run.onenter
		sg.states.run.onenter = function(inst)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("frisia") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				if not inst.AnimState:IsCurrentAnimation("heavy_walk_fast") then
					inst.AnimState:PlayAnimation("heavy_walk_fast", true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
	if sg.states.run_stop then
		local oldonenter = sg.states.run_stop.onenter
		sg.states.run_stop.onenter = function(inst)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("frisia") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pst")
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
end)
--客户端
AddStategraphPostInit("wilson_client", function(sg)
	-- --5层狂气潮湿不脱手
	-- if sg.events and sg.events.unequip then --脱手事件
	-- 	local old_unequip = sg.events.unequip.fn --重写
	-- 	sg.events.unequip.fn = function(inst, data)--不进入脱手的sg就不会脱手)
	-- 		if inst:HasTag("frisia") and (inst.sg:HasStateTag("idle") or inst.sg:HasStateTag("channeling")) and data.item ~= nil and data.item:IsValid() then
	-- 			if inst.crazy_spirit == 5 then
	-- 				return
	-- 			end		
	-- 		end
	-- 		return old_unequip and old_unequip(inst, data) --与门 为真返回old_unequip 为假的 返回false `and` 操作符在遇到假值时会立即停止计算并返回假值
    --     end
	-- end
    -- --5层狂气时被攻击不会僵直  
	-- if sg.events and sg.events.attacked then
	-- 	local oldattackedfn = sg.events.attacked.fn
	-- 	sg.events.attacked.fn = function(inst, data)--{ attacker = attacker, damage = damage, damageresolved = damageresolved, original_damage = original_damage, weapon = weapon, stimuli = stimuli, spdamage = spdamage, redirected = damageredirecttarget, noimpactsound = self.noimpactsound }
	-- 		if inst.crazy_spirit == 5 or inst:HasTag("playerghost")  then-- 5层狂气免疫僵直 变鬼也免疫吧
	-- 			return
	-- 		end
	-- 		return oldattackedfn and oldattackedfn(inst, data)
    --     end
	-- end

    --背东西速度增快
	if sg.states.run_start then
		local oldonenter = sg.states.run_start.onenter
		sg.states.run_start.onenter = function(inst)
			if inst.replica.inventory:IsHeavyLifting() and inst:HasTag("frisia") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pre")
				inst.sg.mem.footsteps = 0
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
	if sg.states.run then
		local oldonenter = sg.states.run.onenter
		sg.states.run.onenter = function(inst)
			if inst.replica.inventory:IsHeavyLifting() and inst:HasTag("frisia") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				if not inst.AnimState:IsCurrentAnimation("heavy_walk_fast") then
					inst.AnimState:PlayAnimation("heavy_walk_fast", true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
	if sg.states.run_stop then
		local oldonenter = sg.states.run_stop.onenter
		sg.states.run_stop.onenter = function(inst)
			if inst.replica.inventory:IsHeavyLifting() and inst:HasTag("frisia") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pst")
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
end)
>>>>>>> 00b334b (v9.8.1)
