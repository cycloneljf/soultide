
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

}


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
