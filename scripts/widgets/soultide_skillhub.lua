local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"


local ActiveSkillHud = Class(Widget, function(self, owner)
    Widget._ctor(self, "ActiveSkillHud", owner)
    self.owner = owner  --注意初始化 和 传参
    local skillicon_alpha  = TUNING.SOULTIDE.SKILLICON_TRANS
    -- 技能1图标
    self.skill1 = self:AddChild(Image("images/skillicon/icon_skill_active_001.xml", "icon_skill_active_001.tex"))
    self.skill1:SetPosition(-60, 0)  --相对于父节点
    self.skill1:SetTint(1, 1, 1, skillicon_alpha)
    self.skill1:SetScale(0.33)

    -- 技能1 遮罩（矩形）
    self.skill1_mask = self.skill1:AddChild(Image("images/skillicon/icon_skill_mask.xml", "icon_skill_mask.tex"))
    self.skill1_mask:SetTint(0, 0, 0, 0)  -- 半透明黑色  --欸 SetTint可以直接作用于原图片啊
    --self.skill1_mask:SetScale(0.4)    --相对于父节点
    self.skill1_mask:SetPosition(0, 0)  --相对于父节点
    self.skill1_mask:MoveToFront()

    -- 技能1 倒计时文字
    self.skill1_text = self.skill1:AddChild(Text(TALKINGFONT, 60))
    self.skill1_text:SetPosition(0, 0)
    self.skill1_text:SetString("")

    -- 技能2图标
    self.skill2 = self:AddChild(Image("images/skillicon/icon_skill_active_002.xml", "icon_skill_active_002.tex"))
    self.skill2:SetPosition(0, 60)
    self.skill2:SetTint(1, 1, 1, skillicon_alpha)
    self.skill2:SetScale(0.36)

    -- 技能2 遮罩
    self.skill2_mask = self.skill2:AddChild(Image("images/skillicon/icon_skill_mask.xml", "icon_skill_mask.tex"))
    self.skill2_mask:SetTint(0, 0, 0, 0)
    self.skill2_mask:SetPosition(0, 0)
    self.skill2_mask:MoveToFront()

    -- 技能2 倒计时文字
    self.skill2_text = self.skill2:AddChild(Text(TALKINGFONT, 60))
    self.skill2_text:SetPosition(0, 0)
    self.skill2_text:SetString("")

    -- 被动技能3图标 水晶之泪
    self.skill3 = self:AddChild(Image("images/skillicon/icon_skill_buff_001.xml", "icon_skill_buff_001.tex"))
    self.skill3:SetPosition(85, 60)
    self.skill3:SetTint(1, 1, 1, skillicon_alpha)
    self.skill3:SetScale(0.3)

    -- 被动技能4图标 狂气
    self.skill4 = self:AddChild(Image("images/skillicon/icon_skill_buff_002.xml", "icon_skill_buff_002.tex"))
    self.skill4:SetPosition(-60, -85)
    self.skill4:SetTint(1, 1, 1, skillicon_alpha)
    self.skill4:SetScale(0.3)
    -- 技能3 计数
    self.skill3_text = self.skill3:AddChild(Text(TALKINGFONT, 100))
    self.skill3_text:SetPosition(0, 0)
    self.skill3_text:SetString("")
    -- 技能4 计数
    self.skill4_text = self.skill4:AddChild(Text(TALKINGFONT, 100))
    self.skill4_text:SetPosition(0, 0)
    self.skill4_text:SetString("")

    -- 初始化冷却和数值
    self.skill1_cd = 0
    self.skill1_cd_max = TUNING.SOULTIDE.FRISIA.SKILLFIGURES.E_CD_1
    self.skill2_cd = 0
    self.skill2_cd_max = TUNING.SOULTIDE.FRISIA.SKILLFIGURES.Q_CD_1

    self.skill3_num = 0
    self.skill4_num = 0


end)


--更新函数
function ActiveSkillHud:OnUpdate(dt) --1/30秒一帧  给一个值，让它冷却的冷却功能
    -- 技能1倒计时 --cd不更新
    if TheNet:IsServerPaused() then
    else
        if self.skill1_cd > 0 then
            self.skill1_mask:Show()
            self.skill1_text:Show()
            self.skill1_cd = self.skill1_cd - dt
            self.skill1_text:SetString(string.format("%.1f", self.skill1_cd))
            local percent = math.max(self.skill1_cd /self.skill1_cd_max, 0)
            self.skill1_mask:SetTint(0, 0, 0, 0.8*(2-2^(1-percent)))
            if self.skill1_cd <= 0 then
                self.skill1_mask:Hide() --隐藏并且复位
                self.skill1_mask:SetTint(0, 0, 0, 0.6)
                self.skill1_text:Hide()
            end
        end
    -- 技能2倒计时
        if self.skill2_cd > 0 then
            self.skill2_mask:Show()
            self.skill2_text:Show()
            self.skill2_cd = self.skill2_cd - dt
            self.skill2_text:SetString(string.format("%.1f", self.skill2_cd))
            local percent = math.max(self.skill2_cd /self.skill2_cd_max, 0)
            self.skill2_mask:SetTint(0, 0, 0, 0.8*(2-2^(1-percent)))
            if self.skill2_cd <= 0 then
                self.skill2_mask:Hide()
                self.skill2_mask:SetTint(0, 0, 0, 0.6)
                self.skill2_text:Hide()
            end
        end
    end

    --检测能量 充足时为蓝色 不足为红色
    local current = 0
    local speed = 0
    if  self.owner.replica.soultide_sp then
    current = self.owner.replica.soultide_sp:GetNow()
    speed = self.owner.replica.soultide_sp:GetChangeSpeed()
    end
    local sp1 = 72
    if self.owner.components.skilltreeupdater:IsActivated("frisia_skillup_iv") then   sp1 = 64
    elseif self.owner.components.skilltreeupdater:IsActivated("frisia_skillup_iii")  then sp1 = 68
    elseif self.owner.components.skilltreeupdater:IsActivated("frisia_skillup_ii")  then   sp1 = 72
    elseif self.owner.components.skilltreeupdater:IsActivated("frisia_skillup_i")  then    sp1 = 72
    end
    local sp2 = 24
    if self.owner.components.skilltreeupdater:IsActivated("frisia_skillup_iv") then  sp2 = 16
    elseif self.owner.components.skilltreeupdater:IsActivated("frisia_skillup_iii")  then  sp2 = 18
    elseif self.owner.components.skilltreeupdater:IsActivated("frisia_skillup_ii")  then  sp2 = 20
    elseif self.owner.components.skilltreeupdater:IsActivated("frisia_skillup_i")  then   sp2 = 24
    end
    if current >= sp1 + TUNING.SOULTIDE.SP_LEFT  then --奥义
        self.skill2:SetTint(0.8, 0.8, 1, 1)
    else
        self.skill2:SetTint(1, 1, 1, 1)
    end
    if current >= sp2 + TUNING.SOULTIDE.SP_LEFT  then --小技能
        self.skill1:SetTint(0.8, 0.8, 1, 1)
    else
        self.skill1:SetTint(1, 1, 1, 1)
    end
    --buff层数显示
    --水晶之泪
    if  self.skill3_num <= 0 then
        self.skill3_text:Hide()
    else
        self.skill3_text:SetString(string.format("%d", self.skill3_num))
        self.skill3_text:Show()
    end

    if self.skill3_num == 10 then
        self.skill3_text:SetColour(0.9, 0.6, 0.6, 1)      -- 红色
    elseif self.skill3_num >= 5 then
        self.skill3_text:SetColour(0.7, 0.9, 0, 1)      -- 黄色
    else
        self.skill3_text:SetColour(1, 1, 1, 1)      -- 白色
    end

    --狂气
    if  self.skill4_num <= 0 then
        self.skill4_text:Hide()
    else
        self.skill4_text:SetString(string.format("%d", self.skill4_num))
        self.skill4_text:Show()
    end

    if self.skill4_num == 5 then
        self.skill4_text:SetColour(0.9, 0.6, 0.6, 1)      -- 红色
    elseif self.skill4_num >= 3 then
        self.skill4_text:SetColour(0.7, 0.9, 0, 1)      -- 黄色
    else
        self.skill4_text:SetColour(1, 1, 1, 1)      -- 白色
    end
end
-- 外部触发技能 CD
function ActiveSkillHud:StartSkill1CD(cdtime)
    self.skill1_cd = cdtime
end

function ActiveSkillHud:StartSkill2CD(cdtime)
    self.skill2_cd = cdtime
end
-- 设置技能冷却时间上限
function ActiveSkillHud:StartSkill1CDMax(cdtime)
    self.skill1_cd_max = cdtime
end

function ActiveSkillHud:StartSkill2CDMax(cdtime)
    self.skill2_cd_max = cdtime
end
--更新buff层数 不用每帧更新 节省性能
--还是每帧更新好 buff来源多种多样啊
-- 设置技能buff层数
function ActiveSkillHud:StartSkill3NUM(num)
    self.skill3_num = num
end
function ActiveSkillHud:StartSkill4NUM(num)
    self.skill4_num = num
end

return ActiveSkillHud

