local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
--因为一开始把widgets文件放在上一层又报一次错误 哎 VScode
local Soultide_Sp = Class(Badge, function(self, owner, art) --非透明的 art形参 = {r,b,g,a}
    Badge._ctor(self, "soultide_sp", owner) -- 构造函数 看官方badge.lua  这里是动画文件名 动画为“anim“也就是说你可以看badge.lua 来编译动画
	--还是要先学lua语言掌握class概念
	--也就是继承了owner,Setscale(),percent,num,underNumber

	--这个是系统的动画箭头
	self.sparrow = self.underNumber:AddChild(UIAnim())
    self.sparrow:GetAnimState():SetBank("sanity_arrow")
    self.sparrow:GetAnimState():SetBuild("sanity_arrow")
    self.sparrow:GetAnimState():PlayAnimation("neutral")

	--self:StartUpdating()  --不写 不执行更新函数
end)

function Soultide_Sp:SetPercent(val, max)
    Badge.SetPercent(self, val, max)--设置动画的百分比 -这里的动画就是你的动画 也就是说你可以看badge.lua 来编译动画 去掉self就算加冒号 语法糖
end

function Soultide_Sp:OnGainFocus()
	Badge.OnGainFocus(self)
end

function Soultide_Sp:OnLoseFocus()
	Badge.OnLoseFocus(self)
end


function Soultide_Sp:OnUpdate(dt)

	--print("IsServerPaused")
	if TheNet:IsServerPaused() then return end --暂停时停止更新
	--print("self.owner.replica.soultide_sp is not exist")
	local soultide_sp = self.owner.replica.soultide_sp  or self.owner.components.soultide_sp--绑定非UI实体组件
	if soultide_sp then
		local sp_max = math.floor(soultide_sp:GetMax())
		local sp_now = math.floor(soultide_sp:GetNow())
		local a = soultide_sp:GetChangeSpeed()
		local t = soultide_sp:GetTurn()
		local anim = "neutral" --每帧刷新，初始值必为neutual
		--自己的百分比动画
		self:SetPercent(sp_now/sp_max, sp_max)
		--print("update the widget ".. string.format("%.2f",sp_now/sp_max))
		--系统的箭头动画
		if a ~= nil and sp_now < sp_max then
			if a >= 1/20 then
				anim = "arrow_loop_increase"
				if a >= 5/20 then
					anim = "arrow_loop_increase_more"
					if a >= 1/2 then
						anim = "arrow_loop_increase_most"
					end
				end
			end
			if a <= -1/20 and sp_now > 0 then
				anim = "arrow_loop_decrease"
				if a <= -5/20 then
					anim = "arrow_loop_decrease_more"
					if a <= -10/20 then
						anim = "arrow_loop_decrease_most"
					end
				end
			end
		end
		if self.owner:HasTag("sleeping") then
			anim = "arrow_loop_increase_more"
		end
		if self.arrowdir ~= anim then
			self.arrowdir = anim
			self.sparrow:GetAnimState():PlayAnimation(anim, true)
			--print(anim)
	    end
		------ pulse动画 继承至类
		
		if t >= 23 then
			self.pulse:GetAnimState():SetMultColour(0, 1, 1, 1) --绿蓝色
					self.pulse:GetAnimState():PlayAnimation("pulse")
					print( " pulse the sp+")
		end
			-- self.pulse:GetAnimState():SetMultColour(1, 1, 0, 1) --红黄色
			-- self.pulse:GetAnimState():PlayAnimation("pulse")
			-- print("pulse the sp-")
		---显示数字 这是继承的 然后找到text.lua看方法 然后继承两个onfocus函数
		-- self.num = self:AddChild(Text(BODYTEXTFONT, 33))
		-- self.num:SetHAlign(ANCHOR_MIDDLE)
		-- self.num:SetPosition(3, 0, 0)
		-- self.num:Hide()
		self.num:SetString(string.format("%d",sp_now))
		--self.num:Show() --for test
	end
end
return Soultide_Sp