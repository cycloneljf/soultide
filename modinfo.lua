<<<<<<< HEAD
name  = "灵魂潮汐"

description = [[ 你说的对，但是灵魂潮汐是一款。。]]
author = "Twilstar"
version = "0.5"
forumthread = ""
api_version = 10


=======
name  = "[灵魂潮汐]芙丽希娅[SoulTide]frisia"


author = "Twilstar"
version = "0.9.8.1"
forumthread = ""
api_version = 10

description = [[ 你说的对，但是灵魂潮汐是一款。。
故事发生在一个叫。。后面忘了

 author/作者: Twilstar 
 version/版本:0.9.8.1
 language/语言支持: ch en jp

 技能特效完善
 增加了更多批量的配方
 各个等级核心现在可以充能
 现在经验不会溢出了，能够一次性升级
 现在击杀怪物会获得其最大生命值*0.1的经验值
 战斗ui得到了修复

 news:
 全新的战斗ui已经完全超越了老旧的头顶文本
 可以实时查看大部分战斗数据
 新增了9种烹饪锅食物,可在烹饪指南查看效果,能提供各种回复效果
 高级糖果现在能持续的回复sp,增加战斗续航
 重置了大量老旧的贴图和一些动画，现在专武放在地上也能发光了
 完善了升阶系统,可以达到永恒品质了
 修复了一些bug比如小地图现在能显示头像了
 新增了一些mod设置
 更多内容请自行体验
]]
--优先级默认是 0 写个-66吧
priority = -66
>>>>>>> 00b334b (v9.8.1)

dst_compatible = true--兼容联机
dont_starve_compatible = false--不兼容原版
reign_of_giants_compatible = false--不兼容巨人DLC
all_clients_require_mod = true--所有人mod

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {  --服务器标签
'character',
<<<<<<< HEAD
'soultide'
=======
'soultide',
'frisia'
>>>>>>> 00b334b (v9.8.1)
}

configuration_options =
{
<<<<<<< HEAD
{
    name = "soultide_mode",
    label = "模式玩法",
    options =
    {
        {description = "养老模式",hover="在哪里跌倒，就在哪里睡觉--每日补给翻倍,其他不变",data = 1},
        {description = "正常模式",hover="这就是O神，后面忘了",data = 2},
        {description = "快餐模式",hover="饥荒领域大神！--每日补给翻倍，升级速度翻倍",data = 3},
    },
    default = 2,
},
{
    name = "soultide_num",
    label = "武器强度",
    options =
    {
        {description = "0",hover="双攻不提升",data = 0},
        {description = "10",hover="双攻额外提升10",data = 10},
        {description = "20",hover="这就是O神，额外提升20",data = 20},
        {description = "30",hover="饥荒领域大神！-额外提升30",data = 30},
=======
    {name = "Title", label = "全局设置/config", options = {{description = "", data = ""}}, default = ""},
    {
        name = "language_mode",
        label = "语言/Language/言語（げんご）",
        options =
        {
            {description = "中文",hover="当然是全中文",data = 1},
            {description = "English",hover="English txt provided by the author(almost covered)",data = 2},
            {description = "日本語",hover="君の日本語わ本当に上手です",data = 3},
        },
        default = 1, --这里是data的默认值吧
    },

{
    name = "soultide_mode",
    label = "游戏模式/gamemode",                        --TUNING.SOULTIDE.LANGUAGE.CONFIG.LABEL_1,这是不可以的，TUNING此时还没有生成
    options =
    {
        {description = "养老模式",hover="you sleep where you fall down",data = 1},
        {description = "休闲模式",hover="sp makes you full of sanity ",data = 2},
        {description = "正常模式",hover="recommend",data = 3},
        {description = "困难模式",hover="with no sp supplies and sp sanity bonus",data = 4},
        {description = "挑战模式",hover="sanity decreases while your sp is high",data = 5},
    },
    default = 3,
},

{
    name = "soultide_mode_turn",
    label = "sp补给频率/sp supply frequency",                        --TUNING.SOULTIDE.LANGUAGE.CONFIG.LABEL_1,这是不可以的，TUNING此时还没有生成
    options =
    {
        {description = "很快",hover="per 5 s",data = 9},
        {description = "快",hover="per 8 s",data = 15},
        {description = "正常",hover="per 12 s",data = 23},
        {description = "慢",hover="per 20 s",data = 39},
        {description = "很慢",hover="per 30 s",data = 59},
    },
    default = 23,
},


{name = "Title", label = "武器/weapon", options = {{description = "", data = ""}}, default = ""},
{
    name = "soultide_num",
    label = "武器强度/damage bonus",
    options =
    {
        {description = "0",hover="dmg & planerdmg no increase",data = 0},
        {description = "10",hover="dmg & planerdmg increase by 10",data = 10},
        {description = "20",hover="Canadian Genshin impact!,dmg & planerdmg increase by 20",data = 20},
        {description = "30",hover="Dominate!,dmg & planerdmg increase by 30",data = 30},
    },
    default = 0,
},

{
    name = "addenergy_mode",
    label = "能量添加方式/addenergy_mode",
    options =
    {
        {description = "允许溢出",hover="admit energy overflow",data = 1},
        {description = "不允许溢出（不推荐）",hover="not admit energy overflow,some items have various energy that will prevent you to add ",data = 2},
>>>>>>> 00b334b (v9.8.1)
    },
    default = 1,
},

{
    name = "soultide_scale",
<<<<<<< HEAD
    label = "武器等级额外上限（基础10级）",
    options =
    {
        {description = "0",hover="等级额外+0",data = 0},
        {description = "10",hover="等级额外+10",data = 10},
        {description = "20",hover="等级额外+20",data = 20},
        {description = "30",hover="等级额外+30",data = 30},
        {description = "50",hover="等级额外+50",data = 50},
        {description = "90",hover="等级额外+90(也就是100级)",data = 90},
=======
    label = "武器等级上限/extra lv limit",
    options =
    {
        {description = "10",hover="extra lv limit + 0(default base lv limit is 10)",data = 0},
        {description = "20",hover="extra lv limit + 10",data = 10},
        {description = "30",hover="extra lv limit + 20",data = 20},
        {description = "40(其实10级装备随便通关原版)",hover="extra lv limit + 30",data = 30},
        {description = "50(待补充)",hover="extra lv limit + 40",data = 40},
        {description = "100(待补充)",hover="extra lv limit + 90(total limit is 100lv)",data = 90},
    },
    default =30,
},
{name = "Title", label = "装备/equipments", options = {{description = "", data = ""}}, default = ""},
{
    name = "extraspeed_limit",
    label = "装备最大速度倍率/bonus_speed_limit",
    options =
    {
        {description = "1.25",hover="125%",data = 1.25},
        {description = "1.3",hover="130%",data = 1.3},
        {description = "1.4(default)",hover="140%",data = 1.4},
        {description = "1.6",hover="160%",data =1.6},
        {description = "1.8",hover="180%",data =1.8},
        {description = "2.0",hover="200%",data =2.0},
        {description = "3.0",hover="300%",data =3.0},
        {description = "5.0",hover="500%",data =5.0},
    },
    default = 1.4,
},
{
    name = "close_autopickup",
    label = "关闭护符自动拾取功能/close_autopickup",
    options =
    {
        {description = "是",hover="yes",data = true},
        {description = "否",hover="no",data = false},
    },
    default = false,
},

{name = "Title", label = "显示/hud", options = {{description = "", data = ""}}, default = ""},
{
    name = "show_txt_overhead",
    label = "头上显示信息字体/show_txt_overhead",
    options =
    {
        {description = "显示",hover="show", data = true},
        {description = "不显示 它的使命结束了",hover="not show ,it is over", data = false},

    },
    default = false,
},
{
    name = "sp_left",
    label = "技能亮起余量阈值sp/sp_left",
    options =
    {
        {description = "0",hover="ohh",data = 0},
        {description = "16(推荐)",hover="recommend",data = 16},
        {description = "64(高手)",hover="",data = 16},
        {description = "96(高手)",hover="",data = 16},
        {description = "120(关掉这个特效)",hover="not show",data = 16},

    },
    default = 16,
},
{
    name = "background_trans",
    label = "信息面板背景透明度/background_trans",
    options =
    {
        {description = "0%",hover="0%",data = 0},
        {description = "30%(不太妙)",hover="30% not so good",data = 0.30},
        {description = "50%",hover="50%",data = 0.5},
        {description = "60%",hover="60%",data = 0.6},
        {description = "70%",hover="70%",data = 0.7},
        {description = "80%(默认)",hover="default",data = 0.8},
        {description = "90%",hover="",data = 0.9},
        {description = "100%",hover="not show",data = 1},

    },
    default = 0.8,
},
{
    name = "skillicon_trans",
    label = "技能图标透明度/skillicon_trans",
    options =
    {
        {description = "0%",hover="0%",data = 0},
        {description = "很淡",hover="30% not so good",data = 0.30},
        {description = "半透明",hover="50%",data = 0.5},
        {description = "略透明",hover="80%",data = 0.8},
        {description = "100%(默认)",hover="default",data = 1},

>>>>>>> 00b334b (v9.8.1)
    },
    default = 1,
},

}