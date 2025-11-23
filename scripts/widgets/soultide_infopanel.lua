local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local easing = require "easing" --淡入淡出效果

local InfoPanel = Class(Widget, function(self, owner)
    Widget._ctor(self, "InfoPanel")
    self.owner = owner

    -----------------------------------------------------
    -- 背景改为自定义图
    -----------------------------------------------------
    self.bg = self:AddChild(Image("images/skillicon/background_skill_001.xml", "background_skill_001.tex"))
    self.bg:SetSize(900, 550)
    self.bg:SetPosition(0, 0)
    self.bg:SetTint(1, 1, 1, TUNING.SOULTIDE.BACKGROUND_TRANSPARENCY)

    self:SetClickable(true)
    self:Hide()
    self.alpha = 0
    self.updating = false

    -----------------------------------------------------
    -- 标题
    -----------------------------------------------------
    self.title = self:AddChild(Text(TALKINGFONT, 44, "角色信息面板"))
    self.title:SetPosition(0, 230)

    -----------------------------------------------------
    -- 左侧：基本信息
    -----------------------------------------------------
    self.level = self:AddChild(Text(TALKINGFONT, 34, "等级"))
    self.level:SetPosition(-280, 150)

    self.exp = self:AddChild(Text(TALKINGFONT, 30, "经验"))
    self.exp:SetPosition(-280, 110)

    self.attr = self:AddChild(Text(TALKINGFONT, 28, ""))
    self.attr:SetPosition(-280, -50)
    self.attr:SetHAlign(ANCHOR_LEFT)

    -----------------------------------------------------
    -- 技能部分
    -----------------------------------------------------
    self.skill_title = self:AddChild(Text(TALKINGFONT, 34, "技能列表"))
    self.skill_title:SetPosition(200, 150)

        -- 技能1图标
    self.skill1 = self:AddChild(ImageButton("images/skillicon/icon_skill_active_001.xml", "icon_skill_active_001.tex"))
    self.skill1:SetPosition(110, 100)  --相对于父节点
    self.skill1:SetScale(0.3)

    self.skill2 = self:AddChild(ImageButton("images/skillicon/icon_skill_active_002.xml", "icon_skill_active_002.tex"))
    self.skill2:SetPosition(180, 100)
    self.skill2:SetScale(0.3)

    self.skill3 = self:AddChild(ImageButton("images/skillicon/icon_skill_buff_001.xml", "icon_skill_buff_001.tex"))
    self.skill3:SetPosition(250, 100)
    self.skill3:SetScale(0.3)

    self.skill4 = self:AddChild(ImageButton("images/skillicon/icon_skill_buff_002.xml", "icon_skill_buff_002.tex"))
    self.skill4:SetPosition(320, 100)
    self.skill4:SetScale(0.3)


    self.desc_panel = self:AddChild(Image("images/ui.xml", "blank.tex")) --默认的
    self.desc_panel:SetPosition(50, -80)
    self.desc_panel:SetSize(300, 120)
    self.desc_panel:SetTint(0,0,0,0.9)   -- 半透明背景
    self.desc_panel:Hide()
    self.desc_panel_show = false
    self.desc_panel_id = 0

    self.desc_text = self.desc_panel:AddChild(Text(TALKINGFONT, 28))
    self.desc_text:SetPosition(0, 0)
    self.desc_text:SetColour(1,1,1,1)

    self.skill1:SetOnClick(function()
        self:Toggle_Desc(TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_SKILL1_DESC,1)
    end)

    self.skill2:SetOnClick(function()
        self:Toggle_Desc(TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_SKILL2_DESC,2)
    end)

    self.skill3:SetOnClick(function()
        self:Toggle_Desc(TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_SKILL3_DESC ,3)
    end)

    self.skill4:SetOnClick(function()
        self:Toggle_Desc(TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_SKILL4_DESC,4)
    end)

end)

-----------------------------------------------------
-- 显示/隐藏切换
-----------------------------------------------------
function InfoPanel:Toggle()
    if self.shown then
        self:FadeOut()
    else
        self:FadeIn()
    end
end

-----------------------------------------------------
-- 淡入动画
-----------------------------------------------------
function InfoPanel:FadeIn()
    self:Show()
    self.alpha = 0
    self:SetScale(0.8)
    self.updating = true
    self:StartUpdating()
end

-----------------------------------------------------
-- 淡出动画
-----------------------------------------------------
function InfoPanel:FadeOut()
    self.updating = false
    self.inst:DoTaskInTime(0, function()
        local t = 0
        local interval = 0.033  -- 每帧大约 1/30 秒
        local task
        task = self.inst:DoPeriodicTask(interval, function(inst)
            t = t + interval
            self.alpha = math.max(0,TUNING.SOULTIDE.BACKGROUND_TRANSPARENCY - t * 2)
            self:SetFadeAlpha(self.alpha)
            if self.alpha <= 0 then
                self:Hide()
                task:Cancel()
            end
        end)
    end)
end
-----------------------------------------------------
-- 更新循环：从网络变量读取数据
-----------------------------------------------------
function InfoPanel:OnUpdate(dt)
    if self.updating then
        -- 动画淡入
        self.alpha = math.min(self.alpha + dt * 2, 1)
        local scale = easing.outBack(self.alpha,0.8, 0.2, 1)
        self:SetScale(scale)
        self:SetFadeAlpha(self.alpha)
        if self.alpha >= TUNING.SOULTIDE.BACKGROUND_TRANSPARENCY then
            self.updating = false
        end
    end

    if not self.shown or not self.owner then return end

    -------------------------------------------------
    -- 从玩家读取网络变量
    -------------------------------------------------
    local scale = self.owner.net_scale and self.owner.net_scale:value() or 1
    local scale_exp = self.owner.net_scale_exp and self.owner.net_scale_exp:value() or 1
    local crit_rate = self.owner.net_critical_rate and self.owner.net_critical_rate:value() or 0
    local crit_dmg = self.owner.net_critical_damage and self.owner.net_critical_damage:value() or 0
    --sp值相关
    local current = 0
    local speed = 0
    if  self.owner.replica.soultide_sp then
    current = self.owner.replica.soultide_sp:GetNow()
    speed = self.owner.replica.soultide_sp:GetChangeSpeed()
    end
    --移速
    local locomotor = self.owner.replica.locomotor or self.owner.components.locomotor --说明有replica.locomotor
    local speed_mult = 1
    if locomotor then
        -- print("[Test]has replica/component locomotor")
    speed_mult = locomotor:GetSpeedMultiplier() or 1
    else
        -- print("[Test]has no replica/component locomotor")
    end
    -- 位面攻击/防御
    local planar_attack  = 0
    local planar_defense = 0
    local planar_atk = self.owner.replica.planardamage or self.owner.components.planardamage
    if planar_atk then
        planar_attack = planar_atk:GetDamage() or 0
    end
    local planar_def = self.owner.replica.planardefense or self.owner.components.planardefense
    if planar_def then
        planar_defense = planar_def:GetDefense() or 0
    end

    -- 攻击力（取武器伤害，否则角色空手伤害）/护甲防御/额外防御
    local atk = 0
    local def = 0
    local absorbed_percent = 0
    local total_absorption = 0
    local combat1 = nil
    local weapon = nil
    if self.owner.components.combat then
        combat1 = self.owner.components.combat
        --print("[InfoPanel] has combat")
    elseif  self.owner.replica.combat then
        combat1 = self.owner.replica.combat
        --print("[InfoPanel] has replica.combat")
    end
    if combat1 then
        weapon = combat1:GetWeapon()
    else
        --print("[InfoPanel] has no weapon")
    end
    if weapon and weapon.components.weapon then
        atk = weapon.components.weapon.damage or 0
    else
        if combat1 and combat1.defaultdamage then
            atk = combat1.defaultdamage
        else
            atk = 0
             --print("[InfoPanel] has no defaultdamage")
        end
    end
    -- --战斗易伤
    -- local multiplier = combat1.externaldamagetakenmultipliers:Get()
    -- if multiplier then
    --     def = multiplier
    -- end
    --计算护甲
    local absorbers = {}
    local inventory_e = {}
    if  self.owner.components and self.owner.components.inventory and self.owner.components.inventory.equipslots then
        inventory_e = self.owner.components.inventory.equipslots 
    elseif self.owner.replica.inventory.equipslots then
        inventory_e = self.owner.replica.inventory.equipslots
    end

    for k, v in pairs(inventory_e) do
        -- --check resistance 伤害免疫
        -- if v.components.resistance ~= nil and
        -- 	v.components.resistance:HasResistance(attacker, weapon) and
        -- 	v.components.resistance:ShouldResistDamage() then
        -- 	v.components.resistance:ResistDamage(damage)
        -- 	return 0, nil
        if v.components.armor ~= nil then
            absorbers[v.components.armor] = v.components.armor.absorb_percent            --:GetAbsorption(attacker, weapon)
        end
        -- if v.components.damagetyperesist ~= nil 根据伤害来源的标签来抵抗
        --     damagetypemult = damagetypemult * v.components.damagetyperesist:GetResist(attacker, weapon)
        -- end
        for armor, amt in pairs(absorbers) do
            --print("\t", armor.inst, "absorbs", amt)
            absorbed_percent = math.max(amt, absorbed_percent)
        end
        total_absorption = absorbed_percent --遍历之后找到最大的防御值就是的了
    end

    -- -- 防御值
    -- local absorb = 0 
    -- local player_absorb = 0 上面这两个在官方源码中被废弃了 不再使用 但是保留
    -- local other_absorb = 0 都是0 说明护甲减伤没绑在health上
    -- local total_absorb = 0
    -- local health = self.owner.components.health  or self.owner.replica.health
    -- if health then
    --     --print("[test] h exist ")
    --     --print ("[DEBUG] is IsEmpty " , health.externalabsorbmodifiers:IsEmpty())
    --     -- absorb = health.absorb 
    --     -- player_absorb = health.playerabsorb
    --     other_absorb =health.externalabsorbmodifiers:Get()
    --     total_absorb = 1 - ((1 - absorb) * (1 - other_absorb))
    --     --print(string.format("[test] h exist %.2f %.2f %.2f ",absorb, other_absorb , total_absorb)) 
    -- end
    -- SOULTIDE_INFOPANEL_EXTRA = "extra figures",
    -- SOULTIDE_INFOPANEL_CRIT_RATE = "critical_rate",
    -- SOULTIDE_INFOPANEL_CRIT_DMG = "critical_damage",
    -- SOULTIDE_INFOPANEL_WALKINGSPEED = "walkingspeed",
    -- SOULTIDE_INFOPANEL_CURRENTSP = "sp",
    -- SOULTIDE_INFOPANEL_RECOVEERSP = "sp recover"
    -------------------------------------------------
    -- 更新文本
    -------------------------------------------------
    local exp_percent = (scale_exp/(scale*TUNING.SOULTIDE.FRISIA.EXPPERSCALE))*100
    self.level:SetString(string.format("等级/lv：%d 是否主机" .. tostring(TheWorld.ismastersim), scale))
    self.exp:SetString(string.format("当前经验/exp：%d (%.f %%)", scale_exp,exp_percent))
    self.attr:SetString(string.format(
        TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_EXTRA .."\n".. TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_CRIT_RATE..": %.1f%%\n" .. TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_CRIT_DMG .. ": %.1f%%\n" .. TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_CURRENTSP.." :%d\n" .. TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_RECOVEERSP.. ": %.2f\n" .. TUNING.SOULTIDE.LANGUAGE.SOULTIDE_INFOPANEL_WALKINGSPEED .. ": %d %%" ,
        crit_rate, crit_dmg ,current,speed,speed_mult*100
    ))
end

-----------------------------------------------------
-- 技能描述
-----------------------------------------------------
function InfoPanel:ShowSkillDesc(text)
    self.desc_text:SetString(text)
    self.desc_panel:Show()
    self.desc_panel_show = true
end

function InfoPanel:HideSkillDesc()
    self.desc_panel:Hide()
    self.desc_panel_show = false
end

function InfoPanel:Toggle_Desc(text,id)

    if self.desc_panel_id == id then --同一个技能按钮
        if self.desc_panel_show == false then
            self:ShowSkillDesc(text)
        else
            self:HideSkillDesc()
        end
    elseif self.desc_panel_id ~= id then --不同
        self:ShowSkillDesc(text)
    end
    self.desc_panel_id = id  --记得赋值

end

-----------------------------------------------------
-- 设置透明度
-----------------------------------------------------
function InfoPanel:SetFadeAlpha(a)
    self.bg:SetTint(1, 1, 1, a)
    self.title:SetAlpha(a)
    self.level:SetAlpha(a)
    self.exp:SetAlpha(a)
    self.attr:SetAlpha(a)
    self.skill_title:SetAlpha(a)
    
    self.skill1.image:SetTint(1, 1, 1, a)--SetAlpha(a) 图片只用settint
    self.skill2.image:SetTint(1, 1, 1, a)
    self.skill3.image:SetTint(1, 1, 1, a)
    self.skill4.image:SetTint(1, 1, 1, a)
    self.desc_panel:SetTint(1, 1, 1, a)
    self.desc_text:SetAlpha(a)

end

return InfoPanel
