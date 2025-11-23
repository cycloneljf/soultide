<<<<<<< HEAD

TUNING.SOULTIDE = {}

local candies = {
    ["blue"] = {soultide_greencandy = 2 , soultide_bluecandy = 1 , honey = 5 , petals = 10},
    ["purple"] = {soultide_greencandy = 5, soultide_bluecandy = 2, soultide_purplecandy = 1 , honey = 10 , petals = 20},
    ["golden"] = { soultide_bluecandy = 4, soultide_purplecandy = 2 ,  soultide_goldencandy = 1 ,honey = 20 , petals = 40}
}

local energies = { -- 宝石能量，暗影，远古，月亮，生命 越靠后的优先级越高

    ["monstermeat"] =  {0,1,0,0,1},
    ["honey"] = {0,0,0,0,1}, ["petals"] = {0,0,0,0,0.5} , 
    ["night"] = {0,2,0,0,0.5} ,["shadow"] = {0,3,0,0,0.5} ,["horror"] = {0,5,0,0,1}, --兼容


    ["bluegem"] = {3,0,0,3,0}, ["redgem"] = {3,0,0,0,3},  ["purplegem"] = {5,2,0,0,0}, ["yellowgem"] = {8,0,8,0,1},
    ["greengem"] = {8,0,8,0,8},["orangegem"] = {8,0,8,0,0}, ["opalpreciousgem"] = {35,0,24,0,24},
    ["monstermeat_dried"] =  {0,2,0,0,0}, ["petals_evil"] = {0,5,0,0,2},["nightmarefuel"] = {0,2,0,0,1}, ["horrorfuel"] = {0,5,0,0,2},
    ["voidcloth"] = {0,5,4,0,0},["dreadstone"] = {0,8,8,0,0},["shadowheart"] = {0,35,24,0,24},["fossil_piece"] = { 0,5,2,0,2},


}
local dgs = { --武器相关
    CD  =  0.2 ,
    T1 = 2,
    T2 = 5,
    T3 = 9,
    T4 = 19,
    T5 = 49,
    T6 = 99,

    -- ["max_scale"] = 10 + config 在modmain里
}
local ups = {
    ["soultide_core_blue"] = 3,
    ["soultide_core_purple"] = 6,
    ["soultide_core_golden"] = 10,
    ["soultide_core_season"] = 20,
=======
--TUNING = {} -- for test
TUNING.SOULTIDE = {}

--自上而下的加载顺序 要先初始化
--设置数据 应该写在这里
TUNING.SOULTIDE.MODE                   = GetModConfigData("soultide_mode") or 3
TUNING.SOULTIDE.MODE_TURN              = GetModConfigData("soultide_mode_turn") or 23
TUNING.SOULTIDE.EXTRA                  = GetModConfigData("soultide_num") or 0
TUNING.SOULTIDE.DGS_MAX_SCALE          = GetModConfigData("soultide_scale") + 10 or 10
TUNING.SOULTIDE.LANGUAGE_MODE          = GetModConfigData("language_mode") or 1
TUNING.SOULTIDE.ENERGY_ADDMIT_OVERFLOW = GetModConfigData("addenergy_mode") or 1
TUNING.SOULTIDE.SHOW_TXT_OVERHEAD      = GetModConfigData("show_txt_overhead") or false
TUNING.SOULTIDE.BACKGROUND_TRANSPARENCY = GetModConfigData("background_trans") or 0.8
TUNING.SOULTIDE.EXTRASPEED_LIMIT       = GetModConfigData("extraspeed_limit") or 1.6
TUNING.SOULTIDE.SP_LEFT = GetModConfigData("sp_left") or 16
TUNING.SOULTIDE.SKILLICON_TRANS = GetModConfigData("skillicon_trans") or 1
TUNING.SOULTIDE.CLOSE_AUTOPICKUP = GetModConfigData("close_autopickup") or false
-----------------------------------
local candies                          = {
    ["blue"] = { soultide_candy_green = 2, soultide_candy_blue = 1, honey = 5, petals = 10 },
    ["purple"] = { soultide_candy_blue = 2, soultide_candy_purple = 1, honey = 10, petals = 20 },
    ["golden"] = { soultide_candy_purple = 2, soultide_candy_golden = 1, honey = 20, petals = 40 }
}

local energies                         = { -- 宝石能量，暗影，远古，月亮，生命 越大的优先级越高

    ["monster"] = { 0, 1, 0, 0, 1 },
    ["honey"] = { 0, 0, 0, 0, 1 },
    ["petals"] = { 0, 0, 0, 0, 0.5 },
    ["night"] = { 0, 2, 0, 0, 0.5 },
    ["shadow"] = { 0, 3, 0, 0, 0.5 },
    ["horror"] = { 0, 5, 0, 0, 1 }, --兼容
    ["moon"] = { 0, 0, 0, 2, 0 },
    ["lunar"] = { 0, 0, 0, 3, 0 },
    ["spider"] = { 0, 1, 0, 0, 1 },
    --兼容的

    ["bluegem"] = { 3, 0, 0, 3, 0 },
    ["redgem"] = { 3, 0, 0, 0, 3 },
    ["purplegem"] = { 5, 2, 0, 0, 0 },
    ["yellowgem"] = { 8, 0, 8, 0, 1 },
    ["greengem"] = { 8, 0, 8, 0, 8 },
    ["orangegem"] = { 8, 0, 8, 0, 0 },
    ["opalpreciousgem"] = { 35, 0, 24, 0, 24 },

    ["monstermeat_dried"] = { 0, 2, 0, 0, 0 },
    ["petals_evil"] = { 0, 5, 0, 0, 2 },
    ["nightmarefuel"] = { 0, 2, 0, 0, 1 },
    ["horrorfuel"] = { 0, 5, 0, 0, 2 },
    ["voidcloth"] = { 0, 5, 4, 0, 0 },
    ["dreadstone"] = { 0, 8, 8, 0, 0 },
    ["shadowheart"] = { 0, 35, 24, 0, 24 },
    ["fossil_piece"] = { 0, 5, 2, 0, 2 },

    ["moonglass"] = { 1, 0, 0, 2, 0 },
    ["moonglass_charged "] = { 1, 0, 0, 4, 2 },
    ["purebrilliance"] = { 2, 0, 0, 8, 0 },
    ["lunarplant_husk"] = { 1, 0, 0, 5, 2 },
    ["moonbutter"] = { 0, 0, 0, 3, 1 },
    ["moon_cap"] = { 0, 0, 1, 2, 1 },

    ["meat"] = {0,0,0,0,1.5},
    ["smallmeat"] = {0,0,0,0,1},
    ["bird_egg"] = {0,0,0,0,1},
    ["froglegs"] = {0,0,0,0,1},
    ["batwing"] = {0,0,0,0,1},
    ["fishmeat"] = {0,0,0,0,2},
    ["fishmeat_small"] = {0,0,0,0,1},
    ["tallbirdegg"] = {0,0,0,0,4},
    ["livinglog"] = {0,0,0,0,4},

    ["thulecite"] = {0,0,6,0,0},
    ["thulecite_pieces"] = {0,0,1,0,0},
    ["slurtleslime"] = {0,0,1.5,0,0.5},
    ["slurper_pelt"] = {0,1,2,0,1},
    ---拿表去匹配字符串 当然可以不加前缀
    ["moonsoul_blue"] = {2,2,2,8,8},
    ["moonspringcrystal_purple"] = {4,4,4,16,16},
    ["core_green"] = {10,10,10,10,10},
    ["core_blue"] = {20,20,20,20,20},
    ["core_purple"] = {30,30,30,30,30},
    ["core_golden"] = {40,40,40,40,40},
    ["core_red"] = {50,50,50,50,50},
    ["core_season"] = {100,100,100,100,100}, --kai fa zhe wuping
}
TUNING.SOULTIDE.T                      = {
    T1 = 2,             ---绿 升 蓝 
    T2 = 5,             -- to 紫
    T3 = 9,             -- to 金
    T4 = 14,            -- to 红
    T5 = 20,            -- to 水晶
    T6 = 30,            -- to 永恒
    T7 = 40,            ------目前做到了40级
    T8 = 50,
    T9 = 60,
    T10 = 100,
    
}
local ups                              = { --next lv  T+1
    ["soultide_core_green"] = 3,
    ["soultide_core_blue"] = 6,
    ["soultide_core_purple"] = 10,
    ["soultide_core_golden"] = 15,
    ["soultide_core_red"] = 21,
    ["soultide_core_season"] = 31,

}
--技能等级数据 规范到这里
--[[战技 默认z键
贪婪之镰 E战技
CD:8/7/6/5
伤害：80/80/88/95 %物理伤害
范围：8/9/10/12
sp消耗：30/26/26/24

提供：3/3/6/6%的生命汲取
]]

--[[奥义 默认x键
破灭的欲望 Q元素爆发
CD:16/15/14/12
伤害:135/135/148/160 % 物理伤害
范围：8/9/10/12
sp消耗：80/72/72/64

释放前根据狂气层数增加暴击伤害 --后续实装

当狂气达到5层时候，本技能必定暴击
且追加一次贪婪之镰 --二命座效果

]]
local myfoods = {
    GEMCAKE_HEALING = 30,
    GEMCAKE_SANITY = 30,
    GEMCAKE_CALORIES = 25,

    HONEYVEGGIE_HEALING = 25,
    HONEYVEGGIE_SANITY = 15,
    HONEYVEGGIE_CALORIES = 25,

    --略降温
    MOSHCREAMCUBE_HEALING = 20,
    MOSHCREAMCUBE_SANITY = 20,
    MOSHCREAMCUBE_CALORIES = 37.5,

    WEIRDCANDY_HEALING = 1,
    WEIRDCANDY_SANITY = -1,
    WEIRDCANDY_CALORIES = 12.5,

    FRUITCANDY_HEALING = 8,
    FRUITCANDY_SANITY = 10,
    FRUITCANDY_CALORIES = 12.5,

    PECTINCUBE_HEALING = 10,
    PECTINCUBE_SANITY = 5,
    PECTINCUBE_CALORIES = 37.5,

    MEATJELLY_HEALING = 25,
    MEATJELLY_SANITY = 0,
    MEATJELLY_CALORIES = 62.5,
    
    --略升温
    SPICYKELP_HEALING = 10,
    SPICYKELP_SANITY = 5,
    SPICYKELP_CALORIES = 25,

    SOURFISH_HEALING = 30,
    SOURFISH_SANITY = 5,
    SOURFISH_CALORIES = 62.5,

}

local skillfigures                     = {
    DESC ="都是很强力的技能呢",
    LEFT  =  16,

    E_CD_1 = 8,
    E_CD_2 = 7,
    E_CD_3 = 6,
    E_CD_4 = 5,
    E_CD_5 = 4,
    E_CD_6 = 3,
    E_CD_7 = 3,
    E_CD_8 = 3,
    E_CD_9 = 3,
    E_CD_10 = 3,

    E_DAMAGERATE_1 = 0.8,
    E_DAMAGERATE_2 = 0.85,
    E_DAMAGERATE_3 = 0.9,
    E_DAMAGERATE_4 = 0.95,
    E_DAMAGERATE_5 = 1.0,
    E_DAMAGERATE_6 = 1.05,
    E_DAMAGERATE_7 = 1.10,
    E_DAMAGERATE_8 = 1.15,
    E_DAMAGERATE_9 = 1.20,
    E_DAMAGERATE_10 = 1.25,

    E_CONSUME_SP_1 = 80,
    E_CONSUME_SP_2 = 72,
    E_CONSUME_SP_3 = 68,
    E_CONSUME_SP_4 = 64,

    Q_CD_1 = 20,
    Q_CD_2 = 18,
    Q_CD_3 = 16,
    Q_CD_4 = 14,
    Q_CD_5 = 13,
    Q_CD_6 = 12,
    Q_CD_7 = 11,
    Q_CD_8 = 10,
    Q_CD_9 = 9,
    Q_CD_10 = 8,

    Q_DAMAGERATE_1 = 1.35,
    Q_DAMAGERATE_2 = 1.5,
    Q_DAMAGERATE_3 = 1.65,
    Q_DAMAGERATE_4 = 1.8,
    Q_DAMAGERATE_5 = 2.0,
    Q_DAMAGERATE_6 = 2.1,
    Q_DAMAGERATE_7 = 2.2,
    Q_DAMAGERATE_8 = 2.3,
    Q_DAMAGERATE_9 = 2.5,
    Q_DAMAGERATE_10 = 2.8,

    Q_CONSUME_SP_1 = 24,
    Q_CONSUME_SP_2 = 20,
    Q_CONSUME_SP_3 = 18,
    Q_CONSUME_SP_4 = 26,
>>>>>>> 00b334b (v9.8.1)

}


<<<<<<< HEAD
TUNING.SOULTIDE.UP = ups
TUNING.SOULTIDE.CANDYBAG_CONTAIN = candies --先声明再加入
TUNING.SOULTIDE.ENERGY_LIST = energies
TUNING.SOULTIDE.DGS = dgs

----常数(初始化)
TUNING.SOULTIDE.ENERGYLIMIT_LOW = 50
TUNING.SOULTIDE.ENERGYLIMIT_MED = 100
TUNING.SOULTIDE.ENERGYLIMIT_BIG = 150
TUNING.SOULTIDE.ENERGYLIMIT_HUG = 200
TUNING.SOULTIDE.WORLDLEVEL = 1
=======
local dgs                              = { --武器相关
    BASEDAMAGE = 36,
    CD = 0.2,

}

--检视描述
local prefabs                          = {
    "soultide_candy_green",
    "soultide_candy_blue",
    "soultide_candy_purple",
    "soultide_candy_golden",
    "soultide_candy_red",
    "soultide_dgs",
    "soultide_candybag_blue",
    "soultide_candybag_purple",
    "soultide_candybag_golden",
    "soultide_candybox",
    "soultide_core_blue",
    "soultide_core_purple",
    "soultide_core_golden",
    "soultide_core_season",
    "soultide_moonsoul_blue",
    "soultide_moonspringcrystal_purple"
}
local prefabs_e                        = {
    "soultide_brooch_su",
    "soultide_dgs",
    "soultide_corolla_bt",
}
--品质因子
local factors                          = {
    GREY = 0.8,
    WHITE = 1.0,
    GREEN = 1.2,
    BLUE = 1.5,
    PURPLE = 1.8,
    GOLDEN = 2.4,
    ORANGE = 2.4,
    RED = 3,
    CRYSTAL = 3.6,
    RANBOW = 3.6,
    EXCEED = 3.6,
    ETERNAL = 4.5
}
--经验品质因子
local factors_exp                         = {
    GREY = 0.8,
    WHITE = 1,
    GREEN = 2,
    BLUE = 4,
    PURPLE = 8,
    GOLDEN = 15,
    ORANGE = 15,
    RED = 30,
    CRYSTAL = 60,
    RANBOW = 60,
    EXCEED = 60,
    ETERNAL = 60
}
---frisia 芙丽希娅 フリシヤ
local frisia = {
    --角色三维(不是身体数据)
    HUNGER = 120,  --比两麦少一点
    HEALTH = 120,
    SANITY = 120,
    CRAZY_SPIRIT_MAX = 5,
    CRYSTAL_TEAR_MAX = 10,
    CRAZY_SPIRIT_TIME = 30,
    CRYSTAL_TEAR_TIME = 30,
    PLANAR = 5,
    EXPPERSCALE = 90,
    MAX_SCALE = 60,
    MAX_SOULCORE = 50,
    MAX_SOULCORE_POTENTIAL = 50,
}

--感谢CHATGPT 3.5 在这一部分的付出 q(≧▽≦q)
local english_config                   = {
    TOSCALE_1 = " can upgrade to blue quality ",
    TOSCALE_2 = " can upgrade to purple quality ",
    TOSCALE_3 = " can upgrade to golden quality ",
    TOSCALE_4 = "can upgrade to red quality",
    TOSCALE_5 = "can upgrade to ranbow quality",
    TOSCALE_6 = "can upgrade to eternal quality",
    GEM_E = " Gem Energy",
    SHADOW_E = " Shadow Energy",
    LOST_E = " Ancient Energy",
    MOON_E = " Moon Energy",
    FLESH_E = " Life Energy",
    ------------
    CANDYBOX_NAME = "Candy Box",
    CANDYBOX_RECIPE_DESC = "High-tech candy box",
    CANDYBOX_CHAG_DESC = "The candy box is not just for storing candies",
    DGS_NAME = "Scythe of the Desolate Garden",
    DGS_RECIPE_DESC = "It emits a terrifying aura",
    DGS_CHAG_DESC = "It's someone's favorite garden tool",
    -----------
    CANDY_BLUE_NAME = "Blue Candy",
    CANDY_GREEN_NAME = "Green Candy",
    CANDY_PURPLE_NAME = "Purple Candyblock",
    CANDY_GOLDEN_NAME = "Golden Candyblock",
    CANDY_RED_NAME = "Red CandyElf",
    CANDY_RECIPE_DESC = "Rare candy that gives SP when consumed",
    CANDY_CHAG_DESC = "Sweet and delicious",
    CANDYBAG_BLUE_NAME = "Fine Candy Bag",
    CANDYBAG_PURPLE_NAME = "Epic Candy Bag",
    CANDYBAG_GOLDEN_NAME = "Legendary Candy Bag",
    CANDYBAG_BLUE_RECIPE_DESC = "A bag filled with candies, can be opened in bulk",
    CANDYBAG_PURPLE_RECIPE_DESC = "A bag filled with better candies, can be opened in bulk",
    CANDYBAG_GOLDEN_RECIPE_DESC = "A bag filled with more and better candies, can be opened in bulk",
    CANDYBAG_BLUE_CHAG_DESC = "What's inside?",
    CANDYBAG_PURPLE_CHAG_DESC = "What's inside?",
    CANDYBAG_GOLDEN_CHAG_DESC = "What's inside?",
    ---------
    MOONSOUL_BLUE_NAME = "Moon Soul",
    MOONSOUL_BLUE_RECIPE_DESC = "Condensed moonlight power",
    MOONSOUL_BLUE_CHAG_DESC = "A collection of small moonlight energy",
    MOONSPRINGCRYSTAL_PURPLE_NAME = "Moon Spring Crystal",
    MOONSPRINGCRYSTAL_PURPLE_RECIPE_DESC = "Condensed stronger moonlight power",
    MOONSPRINGCRYSTAL_PURPLE_CHAG_DESC = "A collection of large moonlight energy",


    CORE_GREEN_NAME = "Excellent Upgrade Core",
    CORE_GREEN_RECIPE_DESC = "Condenses the power of enhancement.",
    CORE_GREEN_CHAG_DESC = "The most basic core from a world beyond, used to upgrade certain items.",
    CORE_BLUE_NAME = "Rare Upgrade Core",
    CORE_BLUE_RECIPE_DESC = "Condenses the power of enhancement.",
    CORE_BLUE_CHAG_DESC = "Its energy deepens into blue, used to upgrade certain items.",
    CORE_PURPLE_NAME = "Epic Upgrade Core",
    CORE_PURPLE_RECIPE_DESC = "Condenses a stronger power of enhancement.",
    CORE_PURPLE_CHAG_DESC = "The energy gradually turns purple, used to upgrade advanced items.",
    CORE_GOLDEN_NAME = "Legendary Upgrade Core",
    CORE_GOLDEN_RECIPE_DESC = "Condenses even stronger power of enhancement.",
    CORE_GOLDEN_CHAG_DESC = "Golden energy surges within, used to upgrade higher-level items.",
    CORE_RED_NAME = "Transcendent Upgrade Core",
    CORE_RED_RECIPE_DESC = "Condenses the ultimate power of enhancement.",
    CORE_RED_CHAG_DESC = "Crimson energy rages within, crystallized by sheer power.",
    CORE_SEASON_NAME = "Trail of Hearts",
    CORE_SEASON_RECIPE_DESC = "Formed from the native powers of the Eternal Continent.",
    CORE_SEASON_CHAG_DESC = "The powers of all four seasons converge, crystallizing into the shape of a heart.",
    ------
    BROOCH_SU_NAME = "Sea Urchin Brooch",
    BROOCH_SU_RECIPE_DESC = "Filled with sharp aura",
    BROOCH_SU_CHAG_DESC = "Someone's exclusive brooch",
    COROLLA_BT_NAME = "Black Thorn Corolla",
    COROLLA_BT_RECIPE_DESC = "Crown adorned with shadows and thorns from the Eternal Realm",
    COROLLA_BT_CHAG_DESC = "Someone's exclusive corolla",
    CRYSTALTOWER_NAME = "Crystal Tower",
    CRYSTALTOWER_RECIPE_DESC = "Tower made of crystals from the Eternal Realm",
    CRYSTALTOWER_CHAG_DESC = "Defend the territory!",
    CRYSTALTOWER_ITEM_NAME = "Crystal Tower",
    CRYSTALTOWER_ITEM_RECIPE_DESC = "Tower made of crystals from the Eternal Realm",
    CRYSTALTOWER_ITEM_CHAG_DESC = "Defend the territory!",
    -----------
    ON_CURSE = "Looks like I'm more than a match for the curse",
    ----------
    FRISIA_SKILLUP_I_DESC = "Frisia's overall skill level +1",
    FRISIA_SKILLUP_I_TITLE = "Skill Boost I",
    FRISIA_SKILLUP_II_DESC = "Frisia's overall skill level +2",
    FRISIA_SKILLUP_II_TITLE = "Skill Boost II",
    FRISIA_SKILLUP_III_DESC = "Frisia's overall skill level +3",
    FRISIA_SKILLUP_III_TITLE = "Skill Boost III",
    FRISIA_SKILLUP_IV_DESC = "Frisia's overall skill level +4",
    FRISIA_SKILLUP_IV_TITLE = "Skill Boost IV",
    FRISIA_SOULCORE_I_DESC = "Frisia's soul core level +1",
    FRISIA_SOULCORE_I_TITLE = "Soul Core Boost I",
    FRISIA_SOULCORE_II_DESC = "Frisia's soul core level +2",
    FRISIA_SOULCORE_II_TITLE = "Soul Core Boost II",
    FRISIA_SOULCORE_III_DESC = "Frisia's soul core level +3",
    FRISIA_SOULCORE_III_TITLE = "Soul Core Boost III",
    FRISIA_SOULCORE_IV_DESC = "Frisia's soul core level +4",
    FRISIA_SOULCORE_IV_TITLE = "Soul Core Boost IV",
    FRISIA_SOULCORE_V_DESC = "Frisia's soul core level +5",
    FRISIA_SOULCORE_V_TITLE = "Soul Core Boost V",
    FRISIA_SOULCORE_POTENTIAL_I_DESC = "Frishia's Soulcore potential level +1",
    FRISIA_SOULCORE_POTENTIAL_I_TITLE = "Soulcore Enhancement I",
    FRISIA_SOULCORE_POTENTIAL_II_DESC = "Frishia's Soulcore potential level +2",
    FRISIA_SOULCORE_POTENTIAL_II_TITLE = "Soulcore Enhancement II",
    FRISIA_SOULCORE_POTENTIAL_III_DESC = "Frishia's Soulcore potential level +3",
    FRISIA_SOULCORE_POTENTIAL_III_TITLE = "Soulcore Enhancement III",
    FRISIA_SOULCORE_POTENTIAL_IV_DESC = "Frishia's Soulcore potential level +4",
    FRISIA_SOULCORE_POTENTIAL_IV_TITLE = "Soulcore Enhancement IV",
    FRISIA_SOULCORE_POTENTIAL_V_DESC = "Frishia's Soulcore potential level +5",
    FRISIA_SOULCORE_POTENTIAL_V_TITLE = "Soulcore Enhancement V",
    FRISIA_LIVE_WORKEFFI_I_DESC = "Frishia receives double cooking products while cooking by herself",
    FRISIA_LIVE_WORKEFFI_I_TITLE = "Frugality I",
    FRISIA_LIVE_WORKEFFI_II_DESC = "Frishia's tool efficiency is further increased by 75%",
    FRISIA_LIVE_WORKEFFI_II_TITLE = "Frugality II",
    FRISIA_SOULTIDE_SP_I_DESC = "Frishia's SP recovers naturally at 60% increased speed, and supply quantity is doubled per round",
    FRISIA_SOULTIDE_SP_I_TITLE = "SP I",
    FRISIA_SOULTIDE_SP_II_DESC = "When equipped with a specialized weapon, Frishia's SP attack recovery is increased by 60%",
    FRISIA_SOULTIDE_SP_II_TITLE = "SP II",
    FRISIA_SOULTIDE_SP_III_DESC = "When equipped with a specialized weapon, Frishia's SP attribute bonus is increased by 60%",
    FRISIA_SOULTIDE_SP_III_TITLE = "SP III",
    FRISIA_EXCEED_I_DESC = "Temporarily unavailable",
    FRISIA_EXCEED_I_TITLE = "Exceed Break I",
    FRISIA_EXCEED_II_DESC = "Temporarily unavailable",
    FRISIA_EXCEED_II_TITLE = "Exceed Break II",
    FRISIA_SCALE_LOCK_I_DESC = "Level restriction: Frisia's level needs to be at least 10",
    FRISIA_SCALE_LOCK_II_DESC = "Level restriction: Frisia's level needs to be at least 20",
    FRISIA_SCALE_LOCK_III_DESC = "Level restriction: Frisia's level needs to be at least 30",
    FRISIA_SCALE_LOCK_IV_DESC = "Level restriction: Frisia's level needs to be at least 40",
    FRISIA_SCALE_LOCK_V_DESC = "Level restriction: Frisia's level needs to be at least 50",
    FRISIA_SOULCORE_LOCK_I_DESC = "Soul Core restriction: Frisia needs at least 10 Lumina Souls as food",
    FRISIA_SOULCORE_LOCK_II_DESC = "Soul Core restriction: Frisia needs at least 20 Lumina Souls as food",
    FRISIA_SOULCORE_LOCK_III_DESC = "Soul Core restriction: Frisia needs at least 30 Lumina Souls as food",
    FRISIA_SOULCORE_LOCK_IV_DESC = "Soul Core restriction: Frisia needs at least 40 Lumina Souls as food",
    FRISIA_SOULCORE_LOCK_V_DESC = "Soul Core restriction: Frisia needs at least 50 Lumina Souls as food",
    FRISIA_SOULCOR_POTENTIAL_LOCK_I_DESC = "Soul Core restriction: Frisia needs at least 10 Moon Spring Crystals as food",
    FRISIA_SOULCORE_POTENTIAL_LOCK_II_DESC = "Soul Core restriction: Frisia needs at least 20 Moon Spring Crystals as food",
    FRISIA_SOULCORE_POTENTIAL_LOCK_III_DESC = "Soul Core restriction: Frisia needs at least 30 Moon Spring Crystals as food",
    FRISIA_SOULCORE_POTENTIAL_LOCK_IV_DESC = "Soul Core restriction: Frisia needs at least 40 Moon Spring Crystals as food",
    FRISIA_SOULCORE_POTENTIAL_LOCK_V_DESC = "Soul Core restriction: Frisia needs at least 50 Moon Spring Crystals as food",
    -------------
    CHARACTER_DESCRIPTIONS_FRISIA = "*Cute little gardener \n*Starts with a individual weapon(the Scythe of the Desolate Garden)\n*Enjoys eating candies, especially those given by puppeteers\n*Possesses an SP combat system",
    CHARACTER_QUOTES_FRISIA = "\"Of course I'm font of lovely flowers ~  \"",
    CHARACTER_SURVIVABILITY_FRISIA = "easy",
    -----------
    CRAFTING_FILTERS_SOULTIDE ="soultide_base" ,
    CRAFTING_FILTERS_SOUL_CANDY ="candymake" ,
    OPEN_CRAFTING_CRYSTAL = "projection" ,
    -----------actions'
    SOULTIDE_CANDYBAG_STR = "open candybag",
    -- Food Names
    SOULTIDE_MYFOODS_GEMCAKE = "Gem Cake",
    SOULTIDE_MYFOODS_HONEYVEGGIE = "Honey Roasted Vegetables",
    SOULTIDE_MYFOODS_WEIRDCANDY = "Weird Candy",
    SOULTIDE_MYFOODS_FRUITCANDY = "Fruit Hard Candy",
    SOULTIDE_MYFOODS_PECTINCUBE = "Pectin Cube",
    SOULTIDE_MYFOODS_MEATJELLY = "Meat Jelly",
    SOULTIDE_MYFOODS_SOURFISHBALL = "Pickled Fish Ball",
    SOULTIDE_MYFOODS_SPICYKELP = "Spicy Kelp",
    SOULTIDE_MYFOODS_MOSHCREAMCUBE = "Creamy Mushroom Cube",

    -- Food Descriptions
    SOULTIDE_MYFOODS_WEIRDCANDY_DESC = "Increases damage to monsters by 25% for 1 min.\nEffect duration refreshes if applied again.",
    SOULTIDE_MYFOODS_GEMCAKE_DESC = "Gradually restores HP and SP, total 100.\nEffect duration refreshes if applied again.",
    SOULTIDE_MYFOODS_FRUITCANDY_DESC = "Gradually restores sanity, total 100.\nEffect duration refreshes if applied again.",
    SOULTIDE_MYFOODS_MOSHCREAMCUBE_DESC = "Chilled and refreshing.",
    SOULTIDE_MYFOODS_SPICYKELP_DESC = "Hot and spicy.",
    SOULTIDE_MYFOODS_HONEYVEGGIE_DESC = "Gradually restores HP, total 30.\nEffect duration refreshes if applied again.",

    SOULTIDE_INFOPANEL_SKILL1_DESC = [[
    Skill: Greedy Scythe
    Deals damage in a fan-shaped area in front.
    Restores 2~6% of the damage dealt as HP.
    Cooldown: 8~4 seconds
    SP cost: 24~16
    ]],

    SOULTIDE_INFOPANEL_SKILL2_DESC = [[
    Ultimate: Desire of Ruin
    Deals massive damage in a fan-shaped area in front.
    Guaranteed critical hit at 5 stacks of Madness.
    Automatically triggers Greedy Scythe once (consumes SP).
    Cooldown: 20~12 seconds
    SP cost: 80~64
    Restores HP
    ]],

    SOULTIDE_INFOPANEL_SKILL3_DESC = [[
    Passive Talent 1: Crystal Tear
    Stacks up to 10 layers, each providing 2.5~4% additional defense.
    Gain one stack each time you are attacked, lasting 30s.
    ]],

    SOULTIDE_INFOPANEL_SKILL4_DESC = [[
    Passive Talent 2: Madness
    Stacks up to 5 layers, each providing 4~8% additional damage.
    Gain one stack each time you are attacked or hit a target.
    Duration: 30s
    At maximum stacks, gain Super Armor, immune to stagger and weapon drop.
    ]],
    SOULTIDE_INFOPANEL_EXTRA = "extra figures",
    SOULTIDE_INFOPANEL_CRIT_RATE = "critical_rate",
    SOULTIDE_INFOPANEL_CRIT_DMG = "critical_damage",
    SOULTIDE_INFOPANEL_WALKINGSPEED = "walkingspeed",
    SOULTIDE_INFOPANEL_CURRENTSP = "sp",
    SOULTIDE_INFOPANEL_RECOVEERSP = "sp recover"

    
}

local chinese_config                   = {
    TOSCALE_1 = "可以进阶为蓝色品质",
    TOSCALE_2 = "可以进阶为紫色品质",
    TOSCALE_3 = "可以进阶为金色品质",
    TOSCALE_4 = "可以进阶为红色品质",
    TOSCALE_5 = "可以进阶为彩虹品质",
    TOSCALE_6 = "可以进阶为永恒品质",
    GEM_E = " 宝石能量",
    SHADOW_E = " 暗影能量",
    LOST_E = " 远古能量",
    MOON_E = " 月亮能量",
    FLESH_E = " 生命能量",
    ------
    CANDYBOX_NAME = "糖果盒",
    CANDYBOX_RECIPE_DESC = " 高科技糖果盒",
    CANDYBOX_CHAG_DESC = "糖果盒不止用来装糖果",
    DGS_NAME = "绝园之镰",
    DGS_RECIPE_DESC = " 上面充满了令人恐惧的气息",
    DGS_CHAG_DESC = "是某个人最喜欢的花园整理工具呢",
    -------------
    CANDY_BLUE_NAME = "蓝色糖丸",
    CANDY_GREEN_NAME = "绿色糖丸",
    CANDY_PURPLE_NAME = "紫色糖块",
    CANDY_GOLDEN_NAME = "金色糖块",
    CANDY_RED_NAME = "红色糖灵",
    CANDY_RECIPE_DESC = "稀有的糖果，可以从中获得sp",
    CANDY_CHAG_DESC = "甜甜的 很好吃",
    CANDYBAG_BLUE_NAME = "精良糖果袋",
    CANDYBAG_PURPLE_NAME = "史诗糖果袋",
    CANDYBAG_GOLDEN_NAME = "传说糖果袋",
    CANDYBAG_BLUE_RECIPE_DESCE = "装满糖果的袋子，可以批量打开",
    CANDYBAG_PURPLE_RECIPE_DESCE = "装满更好的糖果的袋子，可以批量打开",
    CANDYBAG_GOLDEN_RECIPE_DESCE = "装满更多更好的糖果的袋子，可以批量打开",
    CANDYBAG_BLUE_CHAG_DESC = "里面装有什么呢",
    CANDYBAG_PURPLE_CHAG_DESC = "里面装有什么呢",
    CANDYBAG_GOLDEN_CHAG_DESC = "里面装有什么呢",
    --------------
    MOONSOUL_BLUE_NAME = "荧魄",
    MOONSOUL_BLUE_RECIPE_DESC = "凝聚月光之力",
    MOONSOUL_BLUE_CHAG_DESC = "是小型的月光的能量集合",
    MOONSPRINGCRYSTAL_PURPLE_NAME = "月泉结晶",
    MOONSPRINGCRYSTAL_PURPLE_RECIPE_DESC = "凝聚更强的月光之力",
    MOONSPRINGCRYSTAL_PURPLE_CHAG_DESC = "是大型的月光的能量集合",
    CORE_GREEN_NAME = "优秀升级核心",
    CORE_GREEN_RECIPE_DESC = "凝聚升级之力",
    CORE_GREEN_CHAG_DESC = "最初级的核心，从天外世界而来，用于给一些物品升级",
    CORE_BLUE_NAME = "精良升级核心",
    CORE_BLUE_RECIPE_DESC = "凝聚升级之力",
    CORE_BLUE_CHAG_DESC = "能量逐渐加深变成蓝色，用于给一些物品升级",
    CORE_PURPLE_NAME = "史诗升级核心",
    CORE_PURPLE_RECIPE_DESC = "凝聚更强的升级之力",
    CORE_PURPLE_CHAG_DESC = "能量逐渐加深变成紫色，用于给一些高级的物品升级",
    CORE_GOLDEN_NAME = "传说升级核心",
    CORE_GOLDEN_RECIPE_DESC = "凝聚更强的升级之力",
    CORE_GOLDEN_CHAG_DESC = "金色的能量在其中涌动，用于给一些更高级的物品升级",
    CORE_RED_NAME = "超越级升级核心",
    CORE_RED_RECIPE_DESC = "凝聚更强的升级之力",
    CORE_RED_CHAG_DESC = "红色的能量在其中汹涌，能量已经具现成晶体化态",
    CORE_SEASON_NAME = "行迹之心",
    CORE_SEASON_RECIPE_DESC = "由永恒大陆本土的力量汇集而成",
    CORE_SEASON_CHAG_DESC = "四季的力量聚合在了一起，凝聚成心的形状",
    -------------
    BROOCH_SU_NAME = "海胆胸针",
    BROOCH_SU_RECIPE_DESC = " 上面充满了锋锐的气息",
    BROOCH_SU_CHAG_DESC = " 某人的专属胸针" ,
    COROLLA_BT_NAME = "黑棘花冠",
    COROLLA_BT_RECIPE_DESC = "被来自永恒领域的暗影荆棘缠绕的花冠",
    COROLLA_BT_CHAG_DESC = "某人的专属花冠",
    CRYSTALTOWER_NAME = "水晶塔",
    CRYSTALTOWER_RECIPE_DESC = "取自永恒领域的水晶构成的塔楼",
    CRYSTALTOWER_CHAG_DESC = "保卫领土！",
    CRYSTALTOWER_ITEM_NAME = "水晶塔",
    CRYSTALTOWER_ITEM_RECIPE_DESC = "取自永恒领域的水晶构成的塔楼",
    CRYSTALTOWER_ITEM_CHAG_DESC = "保卫领土！",
    --------------
    ON_CURSE = "看来我比诅咒更胜一筹",
    -----------skill
    FRISIA_SKILLUP_I_DESC  = "芙丽希娅的全技能等级+1",
    FRISIA_SKILLUP_I_TITLE = "技力提升 I",
    FRISIA_SKILLUP_II_DESC  = "芙丽希娅的全技能等级+2",
    FRISIA_SKILLUP_II_TITLE = "技力提升 II",
    FRISIA_SKILLUP_III_DESC  = "芙丽希娅的全技能等级+3",
    FRISIA_SKILLUP_III_TITLE = "技力提升 III",
    FRISIA_SKILLUP_IV_DESC  = "芙丽希娅的全技能等级+4",
    FRISIA_SKILLUP_IV_TITLE = "技力提升 IV",
    FRISIA_SOULCORE_I_DESC = "芙丽希娅的魂芯等级+1",
    FRISIA_SOULCORE_I_TITLE = "魂芯提升 I",
    FRISIA_SOULCORE_II_DESC = "芙丽希娅的魂芯等级+2",
    FRISIA_SOULCORE_II_TITLE = "魂芯提升 II",
    FRISIA_SOULCORE_III_DESC = "芙丽希娅的魂芯等级+3",
    FRISIA_SOULCORE_III_TITLE = "魂芯提升 III",
    FRISIA_SOULCORE_IV_DESC = "芙丽希娅的魂芯等级+4",
    FRISIA_SOULCORE_IV_TITLE = "魂芯提升 IV",
    FRISIA_SOULCORE_V_DESC = "芙丽希娅的魂芯等级+5",
    FRISIA_SOULCORE_V_TITLE = "魂芯提升 V",
    FRISIA_SOULCORE_POTENTIAL_I_DESC = "芙丽希娅的芯源潜质等级+1",
    FRISIA_SOULCORE_POTENTIAL_I_TITLE = "芯源提升 I",
    FRISIA_SOULCORE_POTENTIAL_II_DESC = "芙丽希娅的芯源潜质等级+2",
    FRISIA_SOULCORE_POTENTIAL_II_TITLE = "芯源提升 II",
    FRISIA_SOULCORE_POTENTIAL_III_DESC = "芙丽希娅的芯源潜质等级+3",
    FRISIA_SOULCORE_POTENTIAL_III_TITLE = "芯源提升 III",
    FRISIA_SOULCORE_POTENTIAL_IV_DESC = "芙丽希娅的芯源潜质等级+4",
    FRISIA_SOULCORE_POTENTIAL_IV_TITLE = "芯源提升 IV",
    FRISIA_SOULCORE_POTENTIAL_V_DESC = "芙丽希娅的芯源潜质等级+5",
    FRISIA_SOULCORE_POTENTIAL_V_TITLE = "芯源提升 V",
    FRISIA_LIVE_WORKEFFI_I_DESC = "芙丽希娅烹饪时获得双倍烹饪产物",
    FRISIA_LIVE_WORKEFFI_I_TITLE = "勤俭持家 I",
    FRISIA_LIVE_WORKEFFI_II_DESC = "芙丽希娅的工具效率额外提升75%",
    FRISIA_LIVE_WORKEFFI_II_TITLE = "勤俭持家 II",
    FRISIA_SOULTIDE_SP_I_DESC = "芙丽希娅SP自然恢复速度+60%，每轮补给量翻倍",
    FRISIA_SOULTIDE_SP_I_TITLE = "SP I",
    FRISIA_SOULTIDE_SP_II_DESC = "装备专武时,芙丽希娅SP攻击恢复+60% ",
    FRISIA_SOULTIDE_SP_II_TITLE = "SP II",
    FRISIA_SOULTIDE_SP_III_DESC = "装备专武时,芙丽希娅SP属性加成+60% ",
    FRISIA_SOULTIDE_SP_III_TITLE = "SP III",
    FRISIA_EXCEED_I_DESC = "暂时无",
    FRISIA_EXCEED_I_TITLE = "超限突破 I",
    FRISIA_EXCEED_II_DESC = "暂时无",
    FRISIA_EXCEED_II_TITLE ="超限突破 II",
    FRISIA_SCALE_LOCK_I_DESC = "等级限制:芙丽希娅的等级需要至少10级",
    FRISIA_SCALE_LOCK_II_DESC = "等级限制:芙丽希娅的等级需要至少20级",
    FRISIA_SCALE_LOCK_III_DESC = "等级限制:芙丽希娅的等级需要至少30级",
    FRISIA_SCALE_LOCK_IV_DESC = "等级限制:芙丽希娅的等级需要至少40级",
    FRISIA_SCALE_LOCK_V_DESC =" 等级限制:芙丽希娅的等级需要至少50级",
    FRISIA_SOULCORE_LOCK_I_DESC = "魂芯限制:芙丽希娅的食用的荧魄数量需要至少10个",
    FRISIA_SOULCORE_LOCK_II_DESC = "魂芯限制:芙丽希娅的食用的荧魄数量需要至少20个",
    FRISIA_SOULCORE_LOCK_III_DESC = "魂芯限制:芙丽希娅的食用的荧魄数量需要至少30个",
    FRISIA_SOULCORE_LOCK_IV_DESC = "魂芯限制:芙丽希娅的食用的荧魄数量需要至少40个",
    FRISIA_SOULCORE_LOCK_V_DESC = "魂芯限制:芙丽希娅的食用的荧魄数量需要至少50个",
    FRISIA_SOULCOR_POTENTIAL_LOCK_I_DESC = "魂芯限制:芙丽希娅的食用的月泉结晶数量需要至少10个",
    FRISIA_SOULCORE_POTENTIAL_LOCK_II_DESC = "魂芯限制:芙丽希娅的食用的月泉结晶数量需要至少20个",
    FRISIA_SOULCORE_POTENTIAL_LOCK_III_DESC = "魂芯限制:芙丽希娅的食用的月泉结晶数量需要至少30个",
    FRISIA_SOULCORE_POTENTIAL_LOCK_IV_DESC = "魂芯限制:芙丽希娅的食用的月泉结晶数量需要至少40个",
    FRISIA_SOULCORE_POTENTIAL_LOCK_V_DESC = "魂芯限制:芙丽希娅的食用的月泉结晶数量需要至少50个",
    ----------
    CHARACTER_DESCRIPTIONS_FRISIA = "*可爱的小花匠\n*开局拥有专属武器\n*喜欢吃糖果，尤其是人偶师给的\n*具有sp战斗系统",
    CHARACTER_QUOTES_FRISIA = "\"喜欢的东西，当然是可爱的花花~  \"",
    CHARACTER_SURVIVABILITY_FRISIA = "简单",
    -----------
    CRAFTING_FILTERS_SOULTIDE ="灵魂潮汐-基础" ,
    CRAFTING_FILTERS_SOUL_CANDY ="糖果制作" ,
    OPEN_CRAFTING_CRYSTAL = "投影" ,
    ------------actions
    SOULTIDE_CANDYBAG_STR = "打开糖果袋",
    SOULTIDE_FRISIA_SKILL_I = "贪婪之镰",
    --------------foood
    SOULTIDE_MYFOODS_GEMCAKE = "宝石蛋糕",
    SOULTIDE_MYFOODS_HONEYVEGGIE = "蜂蜜烤菜",
    SOULTIDE_MYFOODS_WEIRDCANDY = "怪味糖果",
    SOULTIDE_MYFOODS_FRUITCANDY = "水果硬糖",
    SOULTIDE_MYFOODS_PECTINCUBE = "果胶立方",
    SOULTIDE_MYFOODS_MEATJELLY = "肉冻罐头",
    SOULTIDE_MYFOODS_SOURFISHBALL = "酸菜鱼丸",
    SOULTIDE_MYFOODS_SPICYKELP = "卤辣海带",
    SOULTIDE_MYFOODS_MOSHCREAMCUBE = "奶油蘑菇块",
    --------food description
    SOULTIDE_MYFOODS_WEIRDCANDY_DESC = "获得对怪物增伤提升25%持续1min,\n重复获得相同来源效果时刷新时间",
    SOULTIDE_MYFOODS_GEMCAKE_DESC = "获得缓慢的生命和sp恢复，总计100\n重复获得相同来源效果时刷新时间",
    SOULTIDE_MYFOODS_FRUITCANDY_DESC = "获得缓慢的精神恢复，总计100\n重复获得相同来源效果时刷新时间",
    SOULTIDE_MYFOODS_MOSHCREAMCUBE_DESC = "凉凉的",
    SOULTIDE_MYFOODS_SPICYKELP_DESC = "热热辣辣的",
    SOULTIDE_MYFOODS_HONEYVEGGIE_DESC = "获得缓慢的生命恢复，总计30\n重复获得相同来源效果时刷新时间",
    ---------info panel
    SOULTIDE_INFOPANEL_SKILL1_DESC = [[
    战技：贪婪之镰
    对前方扇形区域造成一定伤害 
    回复本次造成伤害的2~6%的hp
    cd 8~4秒
    spcost 24~16
        ]],
    SOULTIDE_INFOPANEL_SKILL2_DESC = [[
    奥义：破灭的欲望
    对前方扇形区域造成大量伤害
    拥有5层狂气时候必定暴击
    并且自动触发一次战技(消耗sp)
    cd 20~12秒
    spcost 80~64
    回复血量
        ]],
    SOULTIDE_INFOPANEL_SKILL3_DESC =[[
    被动天赋1:水晶之泪
    上限可叠加10层 每层提供2.5~4%的额外防御力
    每次受到攻击会增加一层,持续时间30s
        ]] ,
    SOULTIDE_INFOPANEL_SKILL4_DESC = [[
    被动天赋2:狂气
    上限可叠加5层 每层提供4~8%的额外伤害加成
    每次受到攻击会增加一层 攻击命中目标增加一层
    持续时间30s
    达到上限后,获得霸体,免疫硬直和武器脱手
        ]],
    SOULTIDE_INFOPANEL_EXTRA = "额外信息",
    SOULTIDE_INFOPANEL_CRIT_RATE = "暴击率",
    SOULTIDE_INFOPANEL_CRIT_DMG = "暴击伤害",
    SOULTIDE_INFOPANEL_WALKINGSPEED = "移动速度",
    SOULTIDE_INFOPANEL_CURRENTSP = "sp值",
    SOULTIDE_INFOPANEL_RECOVEERSP = "sp回复速率"
}

local japanese_config                  = {
    TOSCALE_1 = "青品質にアップグレードできます",
    TOSCALE_2 = "紫品質にアップグレードできます",
    TOSCALE_3 = "金品質にアップグレードできます",
    TOSCALE_4 = "赤品質にアップグレードできます",
    TOSCALE_5 = "レインボー品質に進化できます",
    TOSCALE_6 = "エターナル品質にアップグレードできます",
    GEM_E = "宝石エネルギー",
    SHADOW_E = "シャドウエネルギー",
    LOST_E = "古代エネルギー",
    MOON_E = "月のエネルギー",
    FLESH_E = "生命エネルギー",
    ------
    CANDYBOX_NAME = "キャンディボックス",
    CANDYBOX_RECIPE_DESC = "ハイテクなキャンディボックス",
    CANDYBOX_CHAG_DESC = "キャンディボックスはキャンディを入れるだけではありません",
    DGS_NAME = "絶園の鎌",
    DGS_RECIPE_DESC = "恐怖に満ちた雰囲気が漂っています",
    DGS_CHAG_DESC = "ある人のお気に入りの庭の手入れ道具ですね",
    ------------
    CANDY_BLUE_NAME = "青いキャンディ",
    CANDY_GREEN_NAME = "緑のキャンディ",
    CANDY_PURPLE_NAME = "紫のキャンディ",
    CANDY_GOLDEN_NAME = "金色のキャンディ",
    CANDY_RED_NAME = "赤いキャンディ",
    CANDY_RECIPE_DESC = "レアなキャンディ、SPを獲得できます",
    CANDY_CHAG_DESC = "甘くて、おいしいです",
    CANDYBAG_BLUE_NAME = "ハイクオリティなキャンディバッグ",
    CANDYBAG_PURPLE_NAME = "エピックなキャンディバッグ",
    CANDYBAG_GOLDEN_NAME = "レジェンドなキャンディバッグ",
    CANDYBAG_BLUE_RECIPE_DESC = "たくさんのキャンディが詰まったバッグで、一括で開ける",
    CANDYBAG_PURPLE_RECIPE_DESC = "より良いキャンディが詰まったバッグで、一括で開ける",
    CANDYBAG_GOLDEN_RECIPE_DESC = "より多くのより良いキャンディが詰まったバッグで、一括で開ける",
    CANDYBAG_BLUE_CHAG_DESC = "中には何が入っているのでしょうか",
    CANDYBAG_PURPLE_CHAG_DESC = "中には何が入っているのでしょうか",
    CANDYBAG_GOLDEN_CHAG_DESC = "中には何が入っているのでしょうか",
    ------------
    MOONSOUL_BLUE_NAME = "蛍の魂",
    MOONSOUL_BLUE_RECIPE_DESC = "月光の力を凝縮する",
    MOONSOUL_BLUE_CHAG_DESC = "小さな月光のエネルギーの集まりです",
    MOONSPRINGCRYSTAL_PURPLE_NAME = "月泉結晶",
    MOONSPRINGCRYSTAL_PURPLE_RECIPE_DESC = "より強力な月光の力を凝縮する",
    MOONSPRINGCRYSTAL_PURPLE_CHAG_DESC = "大きな月光のエネルギーの集まりです",
    CORE_GREEN_NAME = "優秀な強化コア",
    CORE_GREEN_RECIPE_DESC = "強化の力を凝縮した結晶。",
    CORE_GREEN_CHAG_DESC = "異世界から来た最も基本的なコアで、一部のアイテムの強化に使われる。",
    CORE_BLUE_NAME = "良質な強化コア",
    CORE_BLUE_RECIPE_DESC = "強化の力を凝縮した結晶。",
    CORE_BLUE_CHAG_DESC = "エネルギーが青く深まり、一部のアイテムの強化に使われる。",
    CORE_PURPLE_NAME = "エピック強化コア",
    CORE_PURPLE_RECIPE_DESC = "より強力な強化の力を凝縮した結晶。",
    CORE_PURPLE_CHAG_DESC = "エネルギーが紫に染まり、高級なアイテムの強化に使われる。",
    CORE_GOLDEN_NAME = "伝説の強化コア",
    CORE_GOLDEN_RECIPE_DESC = "さらに強力な強化の力を凝縮した結晶。",
    CORE_GOLDEN_CHAG_DESC = "黄金のエネルギーが内部で渦巻き、上位アイテムの強化に使われる。",
    CORE_RED_NAME = "超越の強化コア",
    CORE_RED_RECIPE_DESC = "究極の強化の力を凝縮した結晶。",
    CORE_RED_CHAG_DESC = "赤いエネルギーが激しく渦巻き、力によって結晶化した状態となっている。",
    CORE_SEASON_NAME = "軌跡の心",
    CORE_SEASON_RECIPE_DESC =  "永遠の大陸の力が集まり、形を成した結晶。",
    CORE_SEASON_CHAG_DESC = "四季の力が一つに融合し、心の形をした結晶となった。",
    ----------
    BROOCH_SU_NAME = "ウニの胸飾り",
    BROOCH_SU_RECIPE_DESC = "鋭いオーラで満たされています",
    BROOCH_SU_CHAG_DESC = "誰かの専用の胸飾り",
    COROLLA_BT_NAME = "黒い棘の花冠",
    COROLLA_BT_RECIPE_DESC = "エターナルレルムからの影と棘で飾られた冠",
    COROLLA_BT_CHAG_DESC = "誰かの専用の花冠",
    CRYSTALTOWER_NAME = "クリスタルの塔",
    CRYSTALTOWER_RECIPE_DESC = "エターナルレルムからのクリスタルで作られた塔",
    CRYSTALTOWER_CHAG_DESC = "領土を守れ！",
    CRYSTALTOWER_ITEM_NAME = "クリスタルの塔",
    CRYSTALTOWER_ITEM_RECIPE_DESC = "エターナルレルムからのクリスタルで作られた塔",
    CRYSTALTOWER_ITEM_CHAG_DESC = "領土を守れ！",
    ----------
    ON_CURSE = "呪いには私の方が勝っているようです。",
    ---------
    FRISIA_SKILLUP_I_DESC = "フリシアのスキルレベルが +1 上昇",
    FRISIA_SKILLUP_I_TITLE = "スキルブースト I",
    FRISIA_SKILLUP_II_DESC = "フリシアのスキルレベルが +2 上昇",
    FRISIA_SKILLUP_II_TITLE = "スキルブースト II",
    FRISIA_SKILLUP_III_DESC = "フリシアのスキルレベルが +3 上昇",
    FRISIA_SKILLUP_III_TITLE = "スキルブースト III",
    FRISIA_SKILLUP_IV_DESC = "フリシアのスキルレベルが +4 上昇",
    FRISIA_SKILLUP_IV_TITLE = "スキルブースト IV",
    FRISIA_SOULCORE_I_DESC = "フリシアのソウルコアレベルが +1 上昇",
    FRISIA_SOULCORE_I_TITLE = "ソウルコア「魂コア」ブースト「boost」 I",
    FRISIA_SOULCORE_II_DESC = "フリシアのソウルコアレベルが +2 上昇",
    FRISIA_SOULCORE_II_TITLE = "ソウルコアブースト II",
    FRISIA_SOULCORE_III_DESC = "フリシアのソウルコアレベルが +3 上昇",
    FRISIA_SOULCORE_III_TITLE = "ソウルコアブースト III",
    FRISIA_SOULCORE_IV_DESC = "フリシアのソウルコアレベルが +4 上昇",
    FRISIA_SOULCORE_IV_TITLE = "ソウルコアブースト IV",
    FRISIA_SOULCORE_V_DESC = "フリシアのソウルコアレベルが +5 上昇",
    FRISIA_SOULCORE_V_TITLE = "ソウルコアブースト V",
    FRISIA_SOULCORE_POTENTIAL_I_DESC = "フリシアのソウルコアのポテンシャルレベル +1",
    FRISIA_SOULCORE_POTENTIAL_I_TITLE = "ソウルコア強化 I",
    FRISIA_SOULCORE_POTENTIAL_II_DESC = "フリシアのソウルコアのポテンシャルレベル +2",
    FRISIA_SOULCORE_POTENTIAL_II_TITLE = "ソウルコア強化 II",
    FRISIA_SOULCORE_POTENTIAL_III_DESC = "フリシアのソウルコアのポテンシャルレベル +3",
    FRISIA_SOULCORE_POTENTIAL_III_TITLE = "ソウルコア強化 III",
    FRISIA_SOULCORE_POTENTIAL_IV_DESC = "フリシアのソウルコアのポテンシャルレベル +4",
    FRISIA_SOULCORE_POTENTIAL_IV_TITLE = "ソウルコア強化 IV",
    FRISIA_SOULCORE_POTENTIAL_V_DESC = "フリシアのソウルコアのポテンシャルレベル +5",
    FRISIA_SOULCORE_POTENTIAL_V_TITLE = "ソウルコア強化 V",
    FRISIA_LIVE_WORKEFFI_I_DESC = "フリシアが料理すると、料理の産物が2倍になります",
    FRISIA_LIVE_WORKEFFI_I_TITLE = "倹約 I",
    FRISIA_LIVE_WORKEFFI_II_DESC = "フリシアの道具の効率がさらに75%増加します",
    FRISIA_LIVE_WORKEFFI_II_TITLE = "倹約 II",
    FRISIA_SOULTIDE_SP_I_DESC = "フリシアのSP回復速度が60%増加し、1ラウンドごとの供給量が2倍になります",
    FRISIA_SOULTIDE_SP_I_TITLE = "SP I",
    FRISIA_SOULTIDE_SP_II_DESC = "専用の武器を装備している場合、フリシアのSP攻撃回復速度が60%増加します",
    FRISIA_SOULTIDE_SP_II_TITLE = "SP II",
    FRISIA_SOULTIDE_SP_III_DESC = "専用の武器を装備している場合、フリシアのSP属性ボーナスが60%増加します",
    FRISIA_SOULTIDE_SP_III_TITLE = "SP III",
    FRISIA_EXCEED_I_DESC = "一時的になし",
    FRISIA_EXCEED_I_TITLE = "超限突破 I",
    FRISIA_EXCEED_II_DESC = "一時的になし",
    FRISIA_EXCEED_II_TITLE = "超限突破 II",
    FRISIA_SCALE_LOCK_I_DESC = "レベル制限:フリシアのレベルは少なくとも10である必要があります",
    FRISIA_SCALE_LOCK_II_DESC = "レベル制限:フリシアのレベルは少なくとも20である必要があります",
    FRISIA_SCALE_LOCK_III_DESC = "レベル制限:フリシアのレベルは少なくとも30である必要があります",
    FRISIA_SCALE_LOCK_IV_DESC = "レベル制限:フリシアのレベルは少なくとも40である必要があります",
    FRISIA_SCALE_LOCK_V_DESC = "レベル制限:フリシアのレベルは少なくとも50である必要があります",
    FRISIA_SOULCORE_LOCK_I_DESC = "魂コア制限:フリシアの食べ物としての蛍の魂の数は少なくとも10個必要です",
    FRISIA_SOULCORE_LOCK_II_DESC = "魂コア制限:フリシアの食べ物としての蛍の魂の数は少なくとも20個必要です",
    FRISIA_SOULCORE_LOCK_III_DESC = "魂コア制限:フリシアの食べ物としての蛍の魂の数は少なくとも30個必要です",
    FRISIA_SOULCORE_LOCK_IV_DESC = "魂コア制限:フリシアの食べ物としての蛍の魂の数は少なくとも40個必要です",
    FRISIA_SOULCORE_LOCK_V_DESC = "魂コア制限:フリシアの食べ物としての蛍の魂の数は少なくとも50個必要です",
    FRISIA_SOULCOR_POTENTIAL_LOCK_I_DESC = "魂コア制限:フリシアの食べ物としての月泉結晶の数は少なくとも10個必要です",
    FRISIA_SOULCORE_POTENTIAL_LOCK_II_DESC = "魂コア制限:フリシアの食べ物としての月泉結晶の数は少なくとも20個必要です",
    FRISIA_SOULCORE_POTENTIAL_LOCK_III_DESC = "魂コア制限:フリシアの食べ物としての月泉結晶の数は少なくとも30個必要です",
    FRISIA_SOULCORE_POTENTIAL_LOCK_IV_DESC = "魂コア制限:フリシアの食べ物としての月泉結晶の数は少なくとも40個必要です",
    FRISIA_SOULCORE_POTENTIAL_LOCK_V_DESC = "魂コア制限:フリシアの食べ物としての月泉結晶の数は少なくとも50個必要です",
    ---------
    CHARACTER_DESCRIPTIONS_FRISIA = "*可愛な小さな園芸家\n*専用の武器を持ってスタート\n*キャンディが好きで特にパペッティアからもらうのが好き\n*SP戦闘システムを持つ",
    CHARACTER_QUOTES_FRISIA = "\"好きなものは可愛いお花です〜\"",
    CHARACTER_SURVIVABILITY_FRISIA = "簡単",
    --------
    CRAFTING_FILTERS_SOULTIDE = "ソウルタイド-ベース",
    CRAFTING_FILTERS_SOUL_CANDY = "キャンディ製作",
    OPEN_CRAFTING_CRYSTAL = "プロジェクション",
    --------
    SOULTIDE_CANDYBAG_STR = "キャンディー袋を開けてください",

    -- 食べ物の名前
    SOULTIDE_MYFOODS_GEMCAKE = "ジェムケーキ",
    SOULTIDE_MYFOODS_HONEYVEGGIE = "ハニーロースト野菜",
    SOULTIDE_MYFOODS_WEIRDCANDY = "不思議キャンディ",
    SOULTIDE_MYFOODS_FRUITCANDY = "フルーツハードキャンディ",
    SOULTIDE_MYFOODS_PECTINCUBE = "ペクチンキューブ",
    SOULTIDE_MYFOODS_MEATJELLY = "ミートゼリー",
    SOULTIDE_MYFOODS_SOURFISHBALL = "酸っぱい魚団子",
    SOULTIDE_MYFOODS_SPICYKELP = "スパイシー昆布",
    SOULTIDE_MYFOODS_MOSHCREAMCUBE = "クリーミーマッシュルームキューブ",

    -- 食べ物の説明
    SOULTIDE_MYFOODS_WEIRDCANDY_DESC = "モンスターへのダメージが25%増加、持続時間1分。\n同じ効果を再度得ると時間がリフレッシュされる。",
    SOULTIDE_MYFOODS_GEMCAKE_DESC = "HPとSPをゆっくり回復、合計100。\n同じ効果を再度得ると時間がリフレッシュされる。",
    SOULTIDE_MYFOODS_FRUITCANDY_DESC = "サニティをゆっくり回復、合計100。\n同じ効果を再度得ると時間がリフレッシュされる。",
    SOULTIDE_MYFOODS_MOSHCREAMCUBE_DESC = "ひんやり冷たい。",
    SOULTIDE_MYFOODS_SPICYKELP_DESC = "熱くてスパイシー。",
    SOULTIDE_MYFOODS_HONEYVEGGIE_DESC = "HPをゆっくり回復、合計30。\n同じ効果を再度得ると時間がリフレッシュされる。",

    SOULTIDE_INFOPANEL_SKILL1_DESC = [[
    スキル：貪欲の大鎌
    前方の扇形範囲にダメージを与える。
    与えたダメージの2~6%をHPとして回復。
    クールダウン：8~4秒
    SP消費：24~16
    ]],

    SOULTIDE_INFOPANEL_SKILL2_DESC = [[
    奥義：破滅の欲望
    前方の扇形範囲に大ダメージを与える。
    狂気5層時は必ずクリティカル。
    さらに貪欲の大鎌を1回自動発動（SP消費）。
    クールダウン：20~12秒
    SP消費：80~64
    HPを回復
    ]],

    SOULTIDE_INFOPANEL_SKILL3_DESC = [[
    パッシブ才能1：クリスタルの涙
    最大10層まで重ねられ、各層ごとに2.5~4%の追加防御力を提供。
    攻撃を受けるたびに1層増加、持続時間30秒。
    ]],

    SOULTIDE_INFOPANEL_SKILL4_DESC = [[
    パッシブ才能2：狂気
    最大5層まで重ねられ、各層ごとに4~8%の追加ダメージを提供。
    攻撃を受けるたび、または対象に命中するたびに1層増加。
    持続時間：30秒
    最大層に達すると、スーパーアーマーを得て、硬直と武器落下が無効化される。
    ]],
    SOULTIDE_INFOPANEL_EXTRA = "extra figures",
    SOULTIDE_INFOPANEL_CRIT_RATE = "critical_rate",
    SOULTIDE_INFOPANEL_CRIT_DMG = "critical_damage",
    SOULTIDE_INFOPANEL_WALKINGSPEED = "walkingspeed",
    SOULTIDE_INFOPANEL_CURRENTSP = "sp",
    SOULTIDE_INFOPANEL_RECOVEERSP = "sp recover"


}

--------------------------------总结----------------------------------
TUNING.SOULTIDE.UP                     = ups
TUNING.SOULTIDE.CANDYBAG_CONTAIN       = candies --先声明再加入
TUNING.SOULTIDE.ENERGY_LIST            = energies
TUNING.SOULTIDE.DGS                    = dgs     -- 就不能直接等了，会覆盖原有的 找不到插入非数字键值的方法

TUNING.SOULTIDE.FACTOR                 = factors
TUNING.SOULTIDE.FACTOR_EXP             = factors_exp
TUNING.SOULTIDE.PREFABS                = prefabs
TUNING.SOULTIDE.PREFABS_E              = prefabs_e
TUNING.SOULTIDE.FRISIA                 = frisia

TUNING.SOULTIDE.FRISIA.SKILLFIGURES    = skillfigures
TUNING.SOULTIDE.MYFOODS                = myfoods

----常数(初始化)
TUNING.SOULTIDE.ENERGY_ADDMIT_OVERFLOW = 1
TUNING.SOULTIDE.ENERGYLIMIT_LOW        = 50
TUNING.SOULTIDE.ENERGYLIMIT_MED        = 100
TUNING.SOULTIDE.ENERGYLIMIT_BIG        = 150
TUNING.SOULTIDE.ENERGYLIMIT_HUG        = 200
TUNING.SOULTIDE.WORLDLEVEL             = 1

TUNING.SOULTIDE.BASE_SP = 16
TUNING.SOULTIDE.BASE_EXP = 100
TUNING.SOULTIDE.BASE_HEALTH = 10
TUNING.SOULTIDE.BASE_HUNGER = 5
TUNING.SOULTIDE.BASE_SANITY = 30

TUNING.SOULTIDE.CRYSTALTOWER_RANGE = 16
TUNING.SOULTIDE.CRYSTALTOWER_DAMAGE = 60
TUNING.SOULTIDE.CRYSTALTOWER_ATTACK_PERIOD = 2.5  --24DPS
TUNING.SOULTIDE.AOE_CANT_TAGS = {"INLIMBO", "player", "eyeturret", "engineering","soultide_crystaltower"}


--语言选择
TUNING.SOULTIDE.LANGUAGE               = {}

local function setlanguage(i)
    if i == 1 then
        print("language_mode 1")
        TUNING.SOULTIDE.LANGUAGE = chinese_config
    elseif i == 2 then
        print("language_mode 2")
        TUNING.SOULTIDE.LANGUAGE = english_config
    elseif i == 3 then
        print("language_mode 3")
        TUNING.SOULTIDE.LANGUAGE = japanese_config
    end
end
setlanguage(TUNING.SOULTIDE.LANGUAGE_MODE) --真能当变量？，顺序执行对吗 函数执行后这个language才会确定
>>>>>>> 00b334b (v9.8.1)
