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

AddRecipeFilter({	--添加新的制作栏
	name = "SOUL_CANDY",
	atlas = "images/soultide_candyicon.xml", image = "soultide_candyicon.tex",
	-- custom_pos = true	--true:不加一个新的制作栏,不显示网格而是在mod物品里
})

local soultide ={
    {
    name = "soultide_greencandy",
    ingredients = {Ig("honey",1),Ig("petals",2),Ig("berries",1)},
    level = TECH.NONE,
    filters = {"SOUL_CANDY"},  -- filter 不能拼成fliter
    },

    {
    name = "soultide_greencandy_b",
    ingredients = {Ig("honey",8),Ig("petals",16),Ig("berries",8)},
    level = TECH.SCIENCE_ONE,
    filters = {"SOUL_CANDY"},
    product = "soultide_greencandy",
    numtogive = 10,
    },

    {
    name = "soultide_bluecandy",
    ingredients = {Ig("soultide_greencandy",3,true)},
    level = TECH.SOULTIDE_SCIENCE_BLUE,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_purplecandy",
    ingredients = {Ig("soultide_bluecandy",3,true)},
    level = TECH.SOULTIDE_SCIENCE_PURPLE,
    filters = {"SOUL_CANDY"},
    },
    
    {
    name = "soultide_goldencandy",
    ingredients = {Ig("soultide_purplecandy",3,true)},
    level = TECH.SOULTIDE_SCIENCE_GOLDEN,
    filters = {"SOUL_CANDY"},
    },

    {
    name = "soultide_redcandy",
    ingredients = {Ig("soultide_goldencandy",3,true)},
    level = TECH.SOULTIDE_SCIENCE_RED,
    filters = {"SOUL_CANDY"},
    },

    {
    name = "soultide_dgs",
    ingredients = {Ig("soultide_bluecandy",1,true),Ig("transistor",2),Ig("nightmarefuel",1)},
    level = TECH.NONE,
    filters = {"SOULTIDE"},
    },

    {
    name = "soultide_candybag_blue",
    ingredients = {Ig("goldnugget",5),Ig("papyrus",1)},
    level = TECH.NONE,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candybag_blue_b",
    ingredients = {Ig("goldnugget",20),Ig("papyrus",4)},
    level = TECH.SOULTIDE_SCIENCE_BLUE,
    filters = {"SOUL_CANDY"},
    product = "soultide_candybag_blue",
    numtogive = 5
    },
    {
    name = "soultide_candybag_purple",
    ingredients = {Ig("soultide_candybag_blue",3,true),Ig("gears",1)},
    level = TECH.SCIENCE_ONE,
    filters = {"SOUL_CANDY"},
    },
    {
    name = "soultide_candybag_purple_b",
    ingredients = {Ig("soultide_candybag_blue",12,true),Ig("gears",4)},
    level = TECH.SOULTIDE_SCIENCE_PURPLE,
    filters = {"SOUL_CANDY"},
    product = "soultide_candybag_purple",
    numtogive = 5
    },
    {
    name = "soultide_candybag_golden",
    ingredients = {Ig("soultide_candybag_purple",3,true),Ig("moonglass",1)},
    level = TECH.SCIENCE_TWO,
    filters = {"SOUL_CANDY"},
    },
    {
        name = "soultide_core_blue",
        ingredients = {Ig("soultide_bluecandy",5,true),Ig("transistor",2),Ig("bluemooneye",1)},
        level = TECH.SOULTIDE_SCIENCE_BLUE,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_core_purple",
        ingredients = {Ig("soultide_purplecandy",5,true),Ig("gears",2),Ig("purplemooneye",1)},
        level = TECH.SOULTIDE_SCIENCE_PURPLE,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_core_golden",
        ingredients = {Ig("soultide_goldencandy",4,true),Ig("trinket_6",2),Ig("yellowmooneye",1)},
        level = TECH.SOULTIDE_SCIENCE_GOLDEN,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_core_season",
        ingredients = {Ig("soultide_redcandy",2,true),Ig("thulecite",5),Ig("opalpreciousgem",1),
        Ig("goose_feather",5),Ig("deerclops_eyeball",1),Ig("bearger_fur",1),Ig("dragon_scales",1)},
        level = TECH.SOULTIDE_SCIENCE_CRYSTAL,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_moonsoul_blue",
        ingredients = {Ig("soultide_bluecandy",1,true),Ig("moonglass",2)},
        level = TECH.NONE,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_moonsoul_blue_b",
        ingredients = {Ig("soultide_bluecandy",8,true),Ig("moonglass",16)},
        level = TECH.NONE,
        product = "soultide_moonsoul_blue",
        --description = "8折！", 写在STRING里了
        numtogive = 10,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_moonspringcrystal_purple",
        ingredients = {Ig("soultide_purplecandy",1,true),Ig("moonglass",2),Ig("glommerfuel",1)},
        level = TECH.NONE,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_crystaltower_item",
        ingredients = {Ig("soultide_purplecandy",2,true),Ig("moonglass",10),Ig("thulecite",5)},
        level = TECH.NONE,
        filters = {"SOULTIDE"},
    },
    {
        name = "soultide_corolla_bt",
        ingredients = {Ig("soultide_purplecandy",2,true),Ig("moonglass",10),Ig("thulecite",5)},
        level = TECH.NONE,
        filters = {"SOULTIDE"},
    },
    {
    name = "soultide_brooch_su",
    ingredients = {Ig("soultide_purplecandy",2,true),Ig("moonglass",8),Ig("opalpreciousgem",1),Ig("thulecite",5)},
    level = TECH.NONE,
    filters = {"SOULTIDE"},
    },
}


--合并配方
local recipes = {}

for k,v in ipairs(soultide) do
    v.hint_msg = "NEEDSSOULTIDE_SCIENCE"
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
            hint_msg = data.hint_msg,
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