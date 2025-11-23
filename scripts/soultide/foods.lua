--[[为了兼容性 把官方的常数作为单位量
HEALING_TINY = 1
SANITY_SUPERTINY = 1
CALORIES_HUGE = calories_per_day == 75 默认,
PERISH_ONE_DAY = 1*total_day_time*perish_warp（1/200） , total_day_time = 16 * 30（segtime）
]]
local perishday = TUNING.PERISH_ONE_DAY

local foods =
{
    gemcake = {
        test = function(cooker, names, tags)
            return tags.egg and tags.egg >= 1
                and tags.dairy
                and tags.sweetener
                and not tags.meat
                and not tags.veggie
                and not tags.inedible
                and not tags.monster
        end,
        priority = 66,
        weight = 2,
        foodtype = FOODTYPE.GOODIES,     -- 好东西类
        health = TUNING.SOULTIDE.MYFOODS.GEMCAKE_HEALING,
        hunger = TUNING.SOULTIDE.MYFOODS.GEMCAKE_CALORIES,
        sanity = TUNING.SOULTIDE.MYFOODS.GEMCAKE_SANITY,
        perishtime = perishday * 60, -- 长(60天)
        cooktime = 1, --(就是20秒)
        oneat_desc = TUNING.SOULTIDE.LANGUAGE.SOULTIDE_MYFOODS_GEMCAKE_DESC,
        oneatenfn = function(inst, eater)
			eater:AddDebuff("soultide_buff_healthrecover", "soultide_buff_healthrecover")
            eater:AddDebuff("soultide_buff_sprecover_slow", "soultide_buff_sprecover_slow")
        end,
        card_def = {ingredients = {{"honey", 1}, {"bird_egg", 2}, {"butter", 1}} },
        
    },

    weirdcandy = {
        test = function(cooker, names, tags)
            return tags.monster and tags.monster >= 2
                and tags.sweetener
        end,
        priority = 25,
        potlevel = "low",
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.SOULTIDE.MYFOODS.WEIRDCANDY_HEALING,
        hunger = TUNING.SOULTIDE.MYFOODS.WEIRDCANDY_CALORIES,
        sanity = TUNING.SOULTIDE.MYFOODS.WEIRDCANDY_SANITY,
        cooktime = 0.6,
        perishtime = perishday * 15,
        oneat_desc = TUNING.SOULTIDE.LANGUAGE.SOULTIDE_MYFOODS_WEIRDCANDY_DESC, --图鉴里的
        oneatenfn = function(inst, eater) --进食效果
           eater:AddDebuff("soultide_buff_monsterbonus", "soultide_buff_monsterbonus")
        end,
    },

    fruitcandy = {
        test = function(cooker, names, tags)
            return tags.fruit and tags.fruit > 1
                and tags.sweetener
                and not tags.veggie
                and not tags.meat
                and not tags.monster
        end,
        priority = 50,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.SOULTIDE.MYFOODS.FRUITCANDY_HEALING,
        hunger = TUNING.SOULTIDE.MYFOODS.FRUITCANDY_CALORIES,
        sanity = TUNING.SOULTIDE.MYFOODS.FRUITCANDY_SANITY,

        oneat_desc = TUNING.SOULTIDE.LANGUAGE.SOULTIDE_MYFOODS_FRUITCANDY_DESC,
        oneatenfn = function(inst, eater)
			eater:AddDebuff("soultide_buff_sanityrecover", "soultide_buff_sanityrecover")
        end,

        cooktime = 0.6,
        perishtime = perishday * 15,
    },

    pectincube = {
        test = function(cooker, names, tags)
            return tags.veggie and tags.veggie > 1
                and tags.sweetener
                and not tags.monster
                and not tags.meat
        end,
        priority = 20,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.SOULTIDE.MYFOODS.PECTINCUBE_HEALING,
        hunger = TUNING.SOULTIDE.MYFOODS.PECTINCUBE_CALORIES,
        sanity = TUNING.SOULTIDE.MYFOODS.PECTINCUBE_SANITY,
        
        cooktime = 1,
        perishtime = perishday * 30,

    },

    meatjelly = {
        test = function(cooker, names, tags)
            local meatfish = (tags.meat or 0) + (tags.fish or 0)
            return meatfish > 1.5
                and tags.frozen
                and (tags.monster or 0) < 2
        end,
        priority = 25,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.SOULTIDE.MYFOODS.MEATJELLY_HEALING,
        hunger = TUNING.SOULTIDE.MYFOODS.MEATJELLY_CALORIES,
        sanity = TUNING.SOULTIDE.MYFOODS.MEATJELLY_SANITY,
        cooktime = 1,
        perishtime =perishday * 40,

    },

    spicykelp = {
        test = function(cooker, names, tags)
            return (names.pepper or names.pepper_cooked)
                and tags.kelp and tags.kelp >= 1
                and not tags.sweetener
                and tags.veggie
        end,
        priority = 25,
        foodtype = FOODTYPE.VEGGIE,
        health = TUNING.SOULTIDE.MYFOODS.SPICYKELP_HEALING,
        hunger = TUNING.SOULTIDE.MYFOODS.SPICYKELP_CALORIES,
        sanity = TUNING.SOULTIDE.MYFOODS.SPICYKELP_SANITY,
        temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_LONG,
        oneat_desc = TUNING.SOULTIDE.LANGUAGE.SOULTIDE_MYFOODS_SPICYKELP_DESC,
        cooktime = 1,
        perishtime = perishday * 30,

    },
    --sauerkrautfish
    sourfishball = {
        test = function(cooker, names, tags)
            return tags.kelp and tags.kelp >= 1
                and tags.fish and tags.fish > 1
                and not tags.inedible
                and tags.meat
        end,
        priority = 25,
        foodtype = FOODTYPE.MEAT,
        health = TUNING.SOULTIDE.MYFOODS.SOURFISH_HEALING,
        hunger = TUNING.SOULTIDE.MYFOODS.SOURFISH_CALORIES,
        sanity = TUNING.SOULTIDE.MYFOODS.SOURFISH_SANITY,
        cooktime = 1,
        perishtime = perishday * 30,


    },
     honeyveggie = {
        test = function(cooker, names, tags)
            return names.honey
                and tags.veggie and tags.veggie >= 1
                and not tags.meat
                and not tags.inedible
                and not tags.monster
        end,
        priority = 25,
        weight = 0.6,
        foodtype = FOODTYPE.VEGGIE,      -- 素食类
        health = TUNING.SOULTIDE.MYFOODS.HONEYVEGGIE_HEALING,
        hunger = TUNING.SOULTIDE.MYFOODS.HONEYVEGGIE_CALORIES,
        sanity = TUNING.SOULTIDE.MYFOODS.HONEYVEGGIE_SANITY,

        oneat_desc = TUNING.SOULTIDE.LANGUAGE.SOULTIDE_MYFOODS_HONEYVEGGIE_DESC,
        oneatenfn = function(inst, eater)
			eater:AddDebuff("soultide_buff_healthrecover_tiny", "soultide_buff_healthrecover_tiny")
        end,
        
        perishtime = perishday * 30,  -- 中
        cooktime = 1,
        
    },

    moshcreamcube = {
        test = function(cooker, names, tags)
            return tags.dairy
                and tags.sweetener
                and tags.frozen
                and tags.mushroom
                and not tags.inedible
                and not tags.monster
        end,
        priority = 20,
        weight = 1,
        foodtype = FOODTYPE.GOODIES,     -- 甜品类
        health = TUNING.SOULTIDE.MYFOODS.MOSHCREAMCUBE_HEALING,
        hunger = TUNING.SOULTIDE.MYFOODS.MOSHCREAMCUBE_CALORIES,
        sanity = TUNING.SOULTIDE.MYFOODS.MOSHCREAMCUBE_SANITY,
        perishtime = perishday * 30, -- 中等保质期
        temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
        oneat_desc = TUNING.SOULTIDE.LANGUAGE.SOULTIDE_MYFOODS_MOSHCREAMCUBE_DESC,
        cooktime = 0.5,
    },
}

for k, v in pairs(foods) do
    v.name = "soultide_myfoods_" .. k --保持全部一致前缀
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    --找了半天原来是在这里啊
    v.overridebuild = "soultide_myfoods" --scml文件
    --pot level 锅中的位置 默认为high  其他会是 low
    v.cookbook_atlas = "images/inventoryimages/"..v.name..".xml"
end

return foods