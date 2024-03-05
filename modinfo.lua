name  = "灵魂潮汐"

description = [[ 你说的对，但是灵魂潮汐是一款。。]]
author = "Twilstar"
version = "0.5"
forumthread = ""
api_version = 10



dst_compatible = true--兼容联机
dont_starve_compatible = false--不兼容原版
reign_of_giants_compatible = false--不兼容巨人DLC
all_clients_require_mod = true--所有人mod

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {  --服务器标签
'character',
'soultide'
}

configuration_options =
{
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
    },
    default = 1,
},

{
    name = "soultide_scale",
    label = "武器等级额外上限（基础10级）",
    options =
    {
        {description = "0",hover="等级额外+0",data = 0},
        {description = "10",hover="等级额外+10",data = 10},
        {description = "20",hover="等级额外+20",data = 20},
        {description = "30",hover="等级额外+30",data = 30},
        {description = "50",hover="等级额外+50",data = 50},
        {description = "90",hover="等级额外+90(也就是100级)",data = 90},
    },
    default = 1,
},

}