--也是hook 
--配方表加入可交易组件
local function AddTradableComponent(inst)
    if inst and inst.components and inst.components.tradable == nil then
        inst:AddComponent("tradable")
    end
end

local moretrade = TUNING.SOULTIDE.ENERGY_LIST
for key , _ in pairs(moretrade) do
    AddPrefabPostInit( key, AddTradableComponent)
end



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


------------test
AddReplicableComponent("soultide_sp") --读取组件自动读了

-- 给玩家头上挂一个文本
AddPlayerPostInit(function (player)
	if true then
		return
	end
    -- 在主机上为玩家添加组件
    if GLOBAL.TheWorld.ismastersim and player.components and not player.components.soultide_sp then
        player:AddComponent("soultide_sp")
    end
	---更新你的组件
	if player and player.components and player.components.soultide_sp then
		player:StartUpdatingComponent(player.components.soultide_sp)
	end
    player:DoTaskInTime(1,function (player)
        local FollowText = GLOBAL.require "widgets/followtext"
        -- 仅在玩家有HUD时处理这个
        if player and player.HUD then
            player.headwidget = player.HUD:AddChild(FollowText(GLOBAL.TALKINGFONT, 35))
            player.headwidget:SetHUD(player.HUD.inst)
            player.headwidget:SetOffset(GLOBAL.Vector3(0, -500, 0))
            player.headwidget:SetTarget(player)
            player.headwidget.text:SetColour(0.1, 0.1, 0.9, 1)
            player.headwidget.text:SetString("sp: 没有数据")
            player.headwidget:Show()

            local OldOnUpdate = player.headwidget.OnUpdate
            -- OnUpdate会持续更新UI组件的状态，可以不断读取属性值来修改文本显示
            player.headwidget.OnUpdate = function (self, dt)
                OldOnUpdate(self, dt)
                -- 用replica的GetCurrent来获取数据，如果要移植到单机，此处只需替换replica为components
				if  player.replica.soultide_sp then
					local current = player.replica.soultide_sp:GetNow()
					local speed = player.replica.soultide_sp:GetChangeSpeed()

					local exp = player.scale_exp or -1
					local scale = player.scale or -1
					local c_s = player.crazy_spirit or -1
					player.headwidget.text:SetString(string.format("sp: %.2f + %.2f// %d -- %d//狂气 %d", current, speed,exp,scale,c_s))
				end
            end
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
    	if not harvester or not harvester.prefab == "frisia" then
			return old_harvest(self, harvester)
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


