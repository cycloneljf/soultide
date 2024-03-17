name  = "[灵魂潮汐]芙丽希娅[SoulTide]frisia"


author = "Twilstar"
version = "0.9"
forumthread = ""
api_version = 10

description = [[ 你说的对，但是灵魂潮汐是一款。。
故事发生在一个叫。。后面忘了

 author/作者: Twilstar 
 version/版本:0.9
 language/语言支持: ch en jp
]]
--优先级默认是 0

dst_compatible = true--兼容联机
dont_starve_compatible = false--不兼容原版
reign_of_giants_compatible = false--不兼容巨人DLC
all_clients_require_mod = true--所有人mod

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {  --服务器标签
'character',
'soultide',
'frisia'
}

configuration_options =
{
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
    },
    default = 1,
},

{
    name = "soultide_scale",
    label = "武器等级额外上限/extra lv limit",
    options =
    {
        {description = "0",hover="extra lv limit + 0(default base lv limit is 10)",data = 0},
        {description = "10",hover="extra lv limit + 10",data = 10},
        {description = "20",hover="extra lv limit + 20",data = 20},
        {description = "30",hover="extra lv limit + 30",data = 30},
        {description = "50",hover="extra lv limit + 50",data = 50},
        {description = "90",hover="extra lv limit + 90(total limit is 100lv)",data = 90},
    },
    default = 0,
},

}