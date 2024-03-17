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
-----------------------------------

local candies                          = {
    ["blue"] = { soultide_greencandy = 2, soultide_bluecandy = 1, honey = 5, petals = 10 },
    ["purple"] = { soultide_greencandy = 5, soultide_bluecandy = 2, soultide_purplecandy = 1, honey = 10, petals = 20 },
    ["golden"] = { soultide_bluecandy = 5, soultide_purplecandy = 2, soultide_goldencandy = 1, honey = 20, petals = 40 }
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
    ["slurper_pelt"] = {0,1,2,0,1}

}
TUNING.SOULTIDE.T                      = {
    T1 = 2,
    T2 = 5,
    T3 = 9,
    T4 = 19,
    T5 = 39,
    T6 = 79,
    T7 = 100,
}

local dgs                              = { --武器相关
    BASEDAMAGE = 36,
    CD = 0.2,

}
local ups                              = {
    ["soultide_core_blue"] = 3,
    ["soultide_core_purple"] = 6,
    ["soultide_core_golden"] = 10,
    ["soultide_core_season"] = 20,

}
local prefabs                          = {
    "soultide_greencandy",
    "soultide_bluecandy",
    "soultide_purplecandy",
    "soultide_goldencandy",
    "soultide_redcandy",
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
    GREEN = 1.6,
    BLUE = 2.4,
    PURPLE = 3.6,
    GOLDEN = 6,
    ORANGE = 6,
    RED = 10,
    CRYSTAL = 18,
    RANBOW = 18,
    EXCEED = 18,
    ETERNAL = 25
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
    BLUECANDY_NAME = "Blue Candy",
    GREENCANDY_NAME = "Green Candy",
    PURPLECANDY_NAME = "Purple Candyblock",
    GOLDENCANDY_NAME = "Golden Candyblock",
    REDCANDY_NAME = "Red CandyElf",
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
    CORE_BLUE_NAME = "Fine Upgrade Core",
    CORE_BLUE_RECIPE_DESC = "Condensed upgrade power",
    CORE_BLUE_CHAG_DESC = "Used to upgrade some items",
    CORE_PURPLE_NAME = "Epic Upgrade Core",
    CORE_PURPLE_RECIPE_DESC = "Condensed stronger upgrade power",
    CORE_PURPLE_CHAG_DESC = "Used to upgrade some advanced items",
    CORE_GOLDEN_NAME = "Legendary Upgrade Core",
    CORE_GOLDEN_RECIPE_DESC = "Condensed stronger upgrade power",
    CORE_GOLDEN_CHAG_DESC = "Used to upgrade some higher-level items",
    CORE_SEASON_NAME = "Trail of Hearts",
    CORE_SEASON_RECIPE_DESC = "Condensed natural upgrade power",
    CORE_SEASON_CHAG_DESC = "Used to upgrade some special items",
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
    BLUECANDY_NAME = "蓝色糖丸",
    GREENCANDY_NAME = "绿色糖丸",
    PURPLECANDY_NAME = "紫色糖块",
    GOLDENCANDY_NAME = "金色糖块",
    REDCANDY_NAME = "红色糖灵",
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
    CORE_BLUE_NAME = "精良升级核心",
    CORE_BLUE_RECIPE_DESC = "凝聚升级之力",
    CORE_BLUE_CHAG_DESC = "用于给一些物品升级",
    CORE_PURPLE_NAME = "史诗升级核心",
    CORE_PURPLE_RECIPE_DESC = "凝聚更强的升级之力",
    CORE_PURPLE_CHAG_DESC = "用于给一些高级的物品升级",
    CORE_GOLDEN_NAME = "传说升级核心",
    CORE_GOLDEN_RECIPE_DESC = "凝聚更强的升级之力",
    CORE_GOLDEN_CHAG_DESC = "用于给一些更高级的物品升级",
    CORE_SEASON_NAME = "行迹之心",
    CORE_SEASON_RECIPE_DESC = "凝聚自然的升级之力",
    CORE_SEASON_CHAG_DESC = "用于给一些物品升级",
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
    BLUECANDY_NAME = "青いキャンディ",
    GREENCANDY_NAME = "緑のキャンディ",
    PURPLECANDY_NAME = "紫のキャンディ",
    GOLDENCANDY_NAME = "金色のキャンディ",
    REDCANDY_NAME = "赤いキャンディ",
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
    CORE_BLUE_NAME = "優れたアップグレードコア",
    CORE_BLUE_RECIPE_DESC = "アップグレードの力を凝縮する",
    CORE_BLUE_CHAG_DESC = "アイテムのアップグレードに使用されます",
    CORE_PURPLE_NAME = "エピックアップグレードコア",
    CORE_PURPLE_RECIPE_DESC = "より強力なアップグレードの力を凝縮する",
    CORE_PURPLE_CHAG_DESC = "高レベルのアイテムのアップグレードに使用されます",
    CORE_GOLDEN_NAME = "レジェンドアップグレードコア",
    CORE_GOLDEN_RECIPE_DESC = "より強力なアップグレードの力を凝縮する",
    CORE_GOLDEN_CHAG_DESC = "さらに高レベルのアイテムのアップグレードに使用されます",
    CORE_SEASON_NAME = "トレイルオブハート",
    CORE_SEASON_RECIPE_DESC = "自然のアップグレードの力を凝縮する",
    CORE_SEASON_CHAG_DESC = "アイテムのアップグレードに使用されます",
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
}

TUNING.SOULTIDE.UP                     = ups
TUNING.SOULTIDE.CANDYBAG_CONTAIN       = candies --先声明再加入
TUNING.SOULTIDE.ENERGY_LIST            = energies
TUNING.SOULTIDE.DGS                    = dgs     -- 就不能直接等了，会覆盖原有的 找不到插入非数字键值的方法

TUNING.SOULTIDE.FACTOR                 = factors
TUNING.SOULTIDE.FACTOR_EXP             = factors_exp
TUNING.SOULTIDE.PREFABS                = prefabs
TUNING.SOULTIDE.PREFABS_E              = prefabs_e
TUNING.SOULTIDE.FRISIA                 = frisia

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
setlanguage(TUNING.SOULTIDE.LANGUAGE_MODE) --真能当变量？，顺序执行对吗
