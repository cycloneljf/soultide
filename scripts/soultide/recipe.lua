<<<<<<< HEAD
=======
--关于洞穴的问题
    --不给改 ShouldHintRecipe 这个时候不存在 要等系统自己的函数
	-- local old_shouldhint = GLOBAL.ShouldHintRecipe
	-- GLOBAL.ShouldHintRecipe = function(recipetree, buildertree,...) --recipe.level, tech_trees
	-- for k, v in pairs(recipetree) do
	-- 	if k and string.match(string.lower(tostring(k)),"soultide") then
	-- 		--print(tostring(k)) 这里的输出是 SOULTIDE_SCIENCE
	-- 		return true
	-- 	end
    -- end
	-- old_shouldhint(recipetree, buildertree,...)
    -- end


--修改配方显示函数




>>>>>>> 00b334b (v9.8.1)
local function Ig(ingre,num,ismoditem)	--材料名，材料数量，是否为mod物品（是否需要图标的路径	方便路径用的,
	local lujing = "images/inventoryimages/"..ingre..".xml"
	local num = num or 1
	return ismoditem and Ingredient(ingre,num,lujing) or Ingredient(ingre,num) --就是一个三目运算
end

AddRecipeFilter({	--添加新的制作栏
	name = "SOULTIDE",
	atlas = "images/soultide_makeicon.xml", image = "soultide_makeicon.tex",
	-- custom_pos = true	--true:不加一个新的制作栏,不显示网格而是在mod物品里
})

<<<<<<< HEAD

local soultide ={
    {
    name = "soultide_greencandy",
    ingredients = {Ig("honey",1),Ig("petals",2)},
    level = TECH.SCIENCE_ONE,
    filters = {"SOULTIDE"},  -- filter 不能拼成fliter
    },

    {
    name = "soultide_greencandy_b",
    ingredients = {Ig("honey",8),Ig("petals",16)},
    level = TECH.SCIENCE_TWO,
    filters = {"SOULTIDE"},
    product = "soultide_greencandy",
    numtogive = 10,
    },
    
    {
    name = "soultide_bluecandy",
    ingredients = {Ig("soultide_greencandy",3,true)},
    level = TECH.SOULTIDE_SCIENCE_BLUE,
    filters = {"SOULTIDE"},

    },

    {
    name = "soultide_purplecandy",
    ingredients = {Ig("soultide_bluecandy",3,true)},
    level = TECH.SOULTIDE_SCIENCE_PURPLE,
    nounlock = false,
    filters = {"SOULTIDE"},
    },
    
    {
    name = "soultide_goldencandy",
    ingredients = {Ig("soultide_purplecandy",3,true)},
    level = TECH.SOULTIDE_SCIENCE_GOLDEN,
    filters = {"SOULTIDE"},
    },

    {
    name = "soultide_redcandy",
    ingredients = {Ig("soultide_goldencandy",3,true)},
    level = TECH.SOULTIDE_SCIENCE_RED,
    filters = {"SOULTIDE"},
    },

    {
    name = "soultide_dgs",
    ingredients = {Ig("soultide_bluecandy",1,true),Ig("transistor",2),Ig("nightmarefuel",1)},
=======
AddRecipeFilter({	--添加新的制作栏
	name = "SOUL_CANDY",
	atlas = "images/soultide_candyicon.xml", image = "soultide_candyicon.tex",
	-- custom_pos = true	--true:不加一个新的制作栏,不显示网格而是在mod物品里
})

local soultide ={
    {
    name = "soultide_candy_green",
    ingredients = {Ig("honey",1),Ig("petals",2),Ig("berries",1)},
    level = TECH.NONE,
    filters = {"SOUL_CANDY"},  -- filter 不能拼成fliter
    },

    {
    name = "soultide_candy_green_b",
    ingredients = {Ig("honey",8),Ig("petals",16),Ig("berries",8)},
    level = TECH.SCIENCE_ONE,
    filters = {"SOUL_CANDY"},
    product = "soultide_candy_green",
    numtogive = 10,
    },

    {
    name = "soultide_candy_blue",
    ingredients = {Ig("soultide_candy_green",3,true)},
    level = TECH.SCIENCE_TWO,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candy_blue_b",
    ingredients = {Ig("soultide_candy_green",30,true)},
    level = TECH.MAGIC_TWO,
    product = "soultide_candy_blue",
    numtogive = 10,
    filters = {"SOUL_CANDY"},
    },
    
    {
    name = "soultide_candy_purple",
    ingredients = {Ig("soultide_candy_blue",3,true)},
    level = TECH.MAGIC_TWO,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candy_purple_b",
    ingredients = {Ig("soultide_candy_blue",30,true)},
    level = TECH.MAGIC_THREE,
    filters = {"SOUL_CANDY"},
    product = "soultide_candy_purple",
    numtogive = 10,
    },
    {
    name = "soultide_candy_golden",
    ingredients = {Ig("soultide_candy_purple",3,true)},
    level = TECH.MAGIC_THREE,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candy_golden_b",
    ingredients = {Ig("soultide_candy_purple",15,true)},
    level = TECH.MAGIC_THREE,
    product = "soultide_candy_golden",
    numtogive = 5,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candy_red",
    ingredients = {Ig("soultide_candy_golden",3,true)},
    level = TECH.CELESTIAL_ONE,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candy_red_b",
    ingredients = {Ig("soultide_candy_golden",15,true)},
    level = TECH.CELESTIAL_THREE,
    filters = {"SOUL_CANDY"},
    product = "soultide_candy_red",
    numtogive = 5,
    },
    {
    name = "soultide_dgs",
    ingredients = {Ig("soultide_candy_blue",1,true),Ig("transistor",2),Ig("nightmarefuel",1)},
>>>>>>> 00b334b (v9.8.1)
    level = TECH.NONE,
    filters = {"SOULTIDE"},
    },

    {
    name = "soultide_candybag_blue",
    ingredients = {Ig("goldnugget",5),Ig("papyrus",1)},
    level = TECH.NONE,
<<<<<<< HEAD
    filters = {"SOULTIDE"},
    },
    {
        name = "soultide_core_blue",
        ingredients = {Ig("soultide_bluecandy",5,true),Ig("transistor",2),Ig("bluemooneye",1)},
        level = TECH.NONE,
=======
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candybag_blue_b",
    ingredients = {Ig("goldnugget",20),Ig("papyrus",4)},
    level = TECH.SCIENCE_ONE,
    filters = {"SOUL_CANDY"},
    product = "soultide_candybag_blue",
    numtogive = 5
    },
    {
    name = "soultide_candybag_purple",
    ingredients = {Ig("soultide_candybag_blue",3,true),Ig("gears",1)},
    level = TECH.SCIENCE_TWO,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candybag_purple_b",
    ingredients = {Ig("soultide_candybag_blue",12,true),Ig("gears",4)},
    level = TECH.SCIENCE_TWO,
    filters = {"SOUL_CANDY"},
    product = "soultide_candybag_purple",
    numtogive = 5
    },
    {
    name = "soultide_candybag_golden",
    ingredients = {Ig("soultide_candybag_purple",3,true),Ig("moonglass",1)},
    level = TECH.MAGIC_TWO,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candybag_golden_b",
    ingredients = {Ig("soultide_candybag_purple",12,true),Ig("moonglass",4)},
    level = TECH.MAGIC_TWO,
    filters = {"SOUL_CANDY"},
    product = "soultide_candybag_golden",
    numtogive = 5
    },
    {
        name = "soultide_core_green",
        ingredients = {Ig("soultide_candy_green",5,true),Ig("transistor",2),Ig("moonrocknugget",3)},
        level = TECH.SCIENCE_ONE,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_core_blue",
        ingredients = {Ig("soultide_candy_blue",5,true),Ig("transistor",2),Ig("gears",2),Ig("bluemooneye",1)},
        level = TECH.SCIENCE_ONE,
>>>>>>> 00b334b (v9.8.1)
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_core_purple",
<<<<<<< HEAD
        ingredients = {Ig("soultide_purplecandy",5,true),Ig("gears",2),Ig("purplemooneye",1)},
        level = TECH.NONE,
=======
        ingredients = {Ig("soultide_candy_purple",5,true),Ig("gears",2),Ig("transistor",2),Ig("trinket_6",2),Ig("purplemooneye",1)},
        level = TECH.SCIENCE_TWO,
>>>>>>> 00b334b (v9.8.1)
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_core_golden",
<<<<<<< HEAD
        ingredients = {Ig("soultide_goldencandy",4,true),Ig("trinket_6",2),Ig("yellowmooneye",1)},
        level = TECH.NONE,
=======
        ingredients = {Ig("soultide_candy_golden",4,true),Ig("gears",2),Ig("transistor",2),Ig("trinket_6",2),Ig("wagpunk_bits",2),Ig("yellowmooneye",1)},
        level = TECH.ANCIENT_TWO,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_core_red",
        ingredients = {Ig("soultide_candy_red",4,true),Ig("wagpunk_bits",5),Ig("redmooneye",1)},
        level = TECH.ANCIENT_FOUR,
>>>>>>> 00b334b (v9.8.1)
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_core_season",
<<<<<<< HEAD
        ingredients = {Ig("soultide_redcandy",2,true),Ig("thulecite",5),Ig("opalpreciousgem",1),
        Ig("goose_feather",5),Ig("deerclops_eyeball",1),Ig("bearger_fur",1),Ig("dragon_scales",1)},
        level = TECH.SOULTIDE_SCIENCE_CRYSTAL,
=======
        ingredients = {Ig("soultide_candy_red",2,true),Ig("thulecite",5),Ig("opalpreciousgem",1),
        Ig("goose_feather",5),Ig("deerclops_eyeball",1),Ig("bearger_fur",1),Ig("dragon_scales",1)},
        level = TECH.ANCIENT_FOUR,
>>>>>>> 00b334b (v9.8.1)
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_moonsoul_blue",
<<<<<<< HEAD
        ingredients = {Ig("soultide_bluecandy",1,true),Ig("moonglass",2)},
        level = TECH.NONE,
=======
        ingredients = {Ig("soultide_candy_blue",1,true),Ig("moonglass",2)},
        level = TECH.CELESTIAL_ONE,
>>>>>>> 00b334b (v9.8.1)
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_moonsoul_blue_b",
<<<<<<< HEAD
        ingredients = {Ig("soultide_bluecandy",8,true),Ig("moonglass",16)},
        level = TECH.NONE,
=======
        ingredients = {Ig("soultide_candy_blue",8,true),Ig("moonglass",16)},
        level = TECH.CELESTIAL_THREE,
>>>>>>> 00b334b (v9.8.1)
        product = "soultide_moonsoul_blue",
        --description = "8折！", 写在STRING里了
        numtogive = 10,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_moonspringcrystal_purple",
<<<<<<< HEAD
        ingredients = {Ig("soultide_purplecandy",1,true),Ig("moonglass",2),Ig("glommerfuel",1)},
        level = TECH.NONE,
        filters = {"SOULTIDE"},
    },
=======
        ingredients = {Ig("soultide_candy_purple",1,true),Ig("moonglass",2),Ig("glommerfuel",1)},
        level = TECH.CELESTIAL_THREE,
        filters = {"SOULTIDE"},
    },
    -- {
    --     name = "soultide_crystaltower_item",
    --     ingredients = {Ig("soultide_candy_purple",2,true),Ig("moonglass",10),Ig("thulecite",5)},
    --     level = TECH.NONE,
    --     filters = {"SOULTIDE"},
    -- },
    {
        name = "soultide_corolla_bt",
        ingredients = {Ig("soultide_candy_purple",2,true),Ig("moonglass",10),Ig("thulecite",5)},
        level = TECH.NONE,
        filters = {"SOULTIDE"},
    },
    {
    name = "soultide_brooch_su",
    ingredients = {Ig("soultide_candy_purple",2,true),Ig("moonglass",8),Ig("opalpreciousgem",1),Ig("thulecite",5)},
    level = TECH.NONE,
    filters = {"SOULTIDE"},
    },
>>>>>>> 00b334b (v9.8.1)
}


--合并配方
local recipes = {}

for k,v in ipairs(soultide) do
<<<<<<< HEAD
=======
    v.hint_msg = "NEEDSSOULTIDE_SCIENCE"
>>>>>>> 00b334b (v9.8.1)
	table.insert(recipes,v)
end

for _,data in ipairs(recipes) do
	-- if data.product and not data.recipe_name_cheshire then
	-- 	STRINGS.NAMES[data.name:upper()] = STRINGS.NAMES[data.product:upper()]
	-- end
	if data.description ~= nil then
		--STRINGS.RECIPE_DESC.data.name:upper() = data.description --有就改
		--data.description = data.name
	end

	AddRecipe2(data.name, data.ingredients,data.level,
		{
			min_spacing = data.min_spacing ,
			nounlock = data.nounlock,
			numtogive = data.numtogive,
			testfn = data.testfn,
			product = data.product, --data里不写就是nil，就是默认的name
			build_mode = data.build_mode,
			build_distance = data.build_distance,
			builder_tag = data.builder_tag ,
			atlas = data.atlas or data.noatlas ~= true and ("images/inventoryimages/"..(data.product or data.name)..".xml"), --自动路径 注意保持贴图名字和物品一致
			image = data.image or data.noimage ~= true and ((data.product or data.name)..".tex"),

			placer=data.placer,
<<<<<<< HEAD
=======
            hint_msg = data.hint_msg,
>>>>>>> 00b334b (v9.8.1)
			filter=data.filter,
			--description=data.description,
			canbuild=data.canbuild,
			sg_state=data.sg_state,
			no_deconstruction=data.no_deconstruction,
			require_special_event=data.require_special_event,
			dropitem=data.dropitem,
			actionstr=data.actionstr,
			manufactured=data.manufactured,
		}
		,
        data.filters or {"CHARACTER"}) 
		-- data.filters and (type(data.filters) == "table" and data.filters or {data.filters}) or {"CHARACTER"} -- 怕你不加括号 先中间and 在 or 再外面and。。
end