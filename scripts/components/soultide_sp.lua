local SourceModifierList = require("util/sourcemodifierlist")
--本地变化函数
local function onnow(self,sp_now)
	if self.inst.replica.soultide_sp then
		self.inst.replica.soultide_sp.sp_now:set(sp_now)
	end
end
local function onmax(self,sp_max)
	if self.inst.replica.soultide_sp then
		self.inst.replica.soultide_sp.sp_max:set(sp_max)
	end
end
local function onchangespeed(self,sp_changespeed)
	if self.inst.replica.soultide_sp then
		self.inst.replica.soultide_sp.sp_changespeed:set(sp_changespeed)
	end
end
--turn 是全局还是个体，应该是个体,给网络变量赋值
local function onturn(self,turn)
	if self.inst.replica.soultide_sp then
		self.inst.replica.soultide_sp.turn:set(turn)
	end
end

local soultide_SP = Class(function (self,inst)
    self.inst = inst
    self.sp_now = 64
    self.sp_max = 120
    self.sp_changespeed = 0
    self.sp_effect = 0
    self.turn = 0
	self.externalmodifiers = SourceModifierList(self.inst, 0, SourceModifierList.additive)  --加成方式：加算
    self.inst:AddTag("soultide_sp")
end,
nil,
{
    sp_now = onnow, --变量回调
    sp_max = onmax,
    sp_changespeed = onchangespeed,
    turn = onturn
})

function soultide_SP:GetNow()
    return self.inst.replica.soultide_sp and self.inst.replica.soultide_sp.sp_now:value() or self.sp_now
end

function soultide_SP:GetMax()
    return self.inst.replica.soultide_sp and self.inst.replica.soultide_sp.sp_max:value() or self.sp_max
end

function soultide_SP:GetChangeSpeed() --下降速度
    return self.inst.replica.soultide_sp and self.inst.replica.soultide_sp.sp_changespeed:value() or self.sp_changespeed
end
function soultide_SP:GetTurn() --周期速度
    return self.inst.replica.soultide_sp and self.inst.replica.soultide_sp.turn:value() or self.turn
end


function soultide_SP:SetNow(num)
    if 0 < num and num < self.sp_max then   -- 0 < num < self.sp_max 错误的 第一个< 会返回 boolean 与第二个 num 比较 初学者就是我 容易犯
        self.sp_now = num
    elseif num >= self.sp_max then
        self.sp_now = self.sp_max
    else
        self.sp_now = 0
    end
end

function soultide_SP:DoDelta(num)
    if 0 < self.sp_now + num  and   self.sp_now + num < self.sp_max then
        self.sp_now = self.sp_now + num
    elseif self.sp_now + num  >= self.sp_max then
        self.sp_now = self.sp_max
    else
        self.sp_now = 0
    end
    local data = {num , self.sp_now}
    -- if num > 6 then
    --     self.inst:PushEvent("sp_dodelta",data) --组件不能pushevent --每次都推送真卡吧 十二秒卡一次也不行吧
    -- end
end

function soultide_SP:GetPercent()
    return self.sp_now / self.sp_max
end
--自然回复
--每12秒为1t 回复16点sp
--受到精神值和饱食度影响

--攻击恢复4点sp
--释放技能消耗指定sp
function soultide_SP:OnUpdate(dt)
    --print("是帧还是秒：",dt) --是帧， dt = 1 /60 ，一秒60帧,onupdate是刷帧的 -- 注意不同电脑帧数不一样 我的dt = 1/33 主机和客机的频率还不一样 30帧数 
    if not self.inst.components.health:IsDead() then
        local num = 0 --变化速度
        local san = self.inst.components.sanity:GetPercent() >= 0.8 and 1 or self.inst.components.sanity:GetPercent()
        local hunger = self.inst.components.hunger:GetPercent() >= 0.8 and 1 or self.inst.components.hunger:GetPercent()
        local sp_per = self:GetPercent()
        --新定义的
        if self.custom_rate_fn ~= nil then
            num = num + self.custom_rate_fn(self.inst)
        end
        --接口
        num = num + self.externalmodifiers:Get()

        
        num = math.max((num + (san + hunger) * 0.7 - sp_per), 0.2 )   --* TUNING.SOULTIDE_MODE --san的百分比+饱食度百分比-自带的sp减益
        
        --每秒sp值变化 = 额外加成 + san值影响 + 饱食度影响 - 心情百分比影响 - 难度影响
        --最高0.4 - 1.4最低0.2
        ------------------------skill
        local skill = 1
        local skill_buf = 1
        if self.inst.components.skilltreeupdater then
            if self.inst.components.skilltreeupdater:IsActivated("frisia_soultide_sp_i") then
                skill = 1.6
            end
            if self.inst.components.skilltreeupdater:IsActivated("frisia_soultide_sp_iii") then
                skill_buf = 1.6
            end
        end
        ------------------------
        self.sp_changespeed = self.inst.sg:HasStateTag("sleeping") and 2 * skill  or num * 1.2 * skill   --1.2倍变化速度，睡觉时固定为2  最高2.4
        self:DoDelta(self.sp_changespeed * dt )

        self.buff_count = self.buff_count or 0    --计数用的
        if self.buff_count%60 == 0 then   --每1s设置一次  --按逻辑帧应该是2s了？
            -- sp 影响san值 0.5 - -0.1
            local xq =  sp_per >0.8 and 0.5 or (sp_per * 0.5 - 0.1)
            self.sp_effect = xq  * (4 - TUNING.SOULTIDE.MODE )
            self.inst.components.sanity.externalmodifiers:SetModifier("soultide_sp",self.sp_effect)
        end
        if self.buff_count >= 60 then   --每1s设置一次  --按逻辑帧应该是2s了？
            --加成
            local spd = sp_per >= 0.8 and 1.2 or sp_per >= 0.53 and 1.1 or sp_per >= 0.13 and 1 or 0.6  --移速加成  小于16sp会虚弱
            local zdjc =sp_per >= 0.8 and 0.2 or sp_per >= 0.53 and 0.1 or sp_per >= 0.13 and 0 or -0.2--战斗攻击防御加成 大于80%攻击1.2受伤0.8大于53%攻击1.1受伤0.9，小于13%攻击0.8受伤1.2
            local wmjc =sp_per >= 0.8 and 1.2 or sp_per >= 0.53 and 1.1 or sp_per >= 0.13 and 1 or 0.8    --位面伤害防御加成 大于80%加20%（96），大于53%加10% （64）
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "soultide_sp", spd * skill_buf)
            self.inst.components.combat.externaldamagetakenmultipliers:SetModifier("soultide_sp",1-zdjc * skill_buf )
            self.inst.components.combat.externaldamagemultipliers:SetModifier("soultide_sp", 1+zdjc * skill_buf)
            self.inst.components.planardefense:AddMultiplier(self.inst, wmjc * skill_buf, "soultide_sp")
            self.inst.components.planardamage:AddMultiplier(self.inst, wmjc * skill_buf, "soultide_sp")
            self.buff_count = 0
            -- print("1 second ")
            -- print(string.format("%.2f %.2f %.2f %.2f ",num ,san ,hunger , sp_per))
            self.turn = self.turn + 2
            if self.turn >= TUNING.SOULTIDE.MODE_TURN then
                if TUNING.SOULTIDE.MODE <= 3
                then
                    print(" + sp supply ")
                    self:DoDelta(16 * skill )
                end
                self.turn = 0
            end
        else
            self.buff_count = self.buff_count + 1
        end

--[[
        if bfb >= 0.75 then
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "cheshire_xinqin", 1.2)
            self.inst.components.combat.externaldamagetakenmultipliers:SetModifier("cheshire_xinqin",0.9)
            self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, 1.1, "cheshire_xinqin")
            self.inst.components.planardefense:AddBonus(self.inst, 5, "cheshire_xinqin")
            self.inst.components.planardamage:AddBonus(self.inst, 5, "cheshire_xinqin")
        elseif bfb>= 0.5 then
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "cheshire_xinqin", 1.1)
            self.inst.components.planardefense:AddBonus(self.inst, 5, "cheshire_xinqin")
            self.inst.components.planardamage:AddBonus(self.inst, 5, "cheshire_xinqin")
        elseif bfb>=0.25 then
            self.inst.components.combat.externaldamagetakenmultipliers:SetModifier("cheshire_xinqin",1.1)
            self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, 0.9, "cheshire_xinqin")
        else

        end

        if xq > 120 then
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "cheshire_xinqin", 1.2)
            self.inst.components.combat.externaldamagetakenmultipliers:SetModifier("cheshire_xinqin",0.9)
            self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, 1.1, "cheshire_xinqin")
            self.inst.components.planardefense:AddBonus(self.inst, 5, "cheshire_xinqin")
            self.inst.components.planardamage:AddBonus(self.inst, 5, "cheshire_xinqin")
            self.xq_effect = 4 / 60 --心情高时的心情增益
        elseif xq > 80 then
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "cheshire_xinqin", 1.1)
            self.inst.components.planardefense:AddBonus(self.inst, 5, "cheshire_xinqin")
            self.inst.components.planardamage:AddBonus(self.inst, 5, "cheshire_xinqin")
            self.xq_effect = 2 / 60
        elseif xq > 40 then
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "cheshire_xinqin", 0.9)
            self.xq_effect = - 3 / 60
        elseif xq > 0 then
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "cheshire_xinqin", 0.8)
            self.xq_effect = - 6 / 60
        end
]]

    end
end

function soultide_SP:OnSave()
    local data = {}
    data.sp_now = self.sp_now

    return data
end

function soultide_SP:OnLoad(data)
    if data then
        self.sp_now = data.sp_now
    end
end

return soultide_SP