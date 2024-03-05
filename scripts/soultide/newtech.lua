local TechTree = require("techtree")

--[=[特定实体添加科技站↓	--不然不显示图标
AddPrototyperDef("soultide_crystalsmelter", {
	icon_atlas = "",	--256*256的大图
	icon_image = "",
	action_str = "",	-- 在string里有写
	is_crafting_station = true,
	filter_text = "水晶熔炉",
})

AddPrototyperDef("soultide_portableshop", {
	icon_atlas = "",	--256*256的大图
	icon_image = "",
	action_str = "CHESHIRE_LIULAN",	-- 在string里有写
	is_crafting_station = true,
	filter_text = "便携商店",
})
]=]
--学习的科技栏
--[[ 修改默认的科技树生成方式 ]]
table.insert(TechTree.AVAILABLE_TECH,"SOULTIDE_SCIENCE")
--[[ 制作等级中加入自己的部分 ]]
TECH.NONE.SOULTIDE_SCIENCE = 0
TECH.SOULTIDE_SCIENCE_BLUE = { SOULTIDE_SCIENCE = 2}
TECH.SOULTIDE_SCIENCE_PURPLE = { SOULTIDE_SCIENCE = 4}
TECH.SOULTIDE_SCIENCE_GOLDEN = { SOULTIDE_SCIENCE = 6}
TECH.SOULTIDE_SCIENCE_RED = { SOULTIDE_SCIENCE = 8}
TECH.SOULTIDE_SCIENCE_CRYSTAL = { SOULTIDE_SCIENCE = 10}

--[[ 解锁等级中加入自己的部分 ]]
for k,v in pairs(TUNING.PROTOTYPER_TREES) do --系统的科技树变量
    v.SOULTIDE_SCIENCE = 0
end
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_BLUE = TechTree.Create({SOULTIDE_SCIENCE = 2})
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_PURPLE = TechTree.Create({SOULTIDE_SCIENCE = 4})
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_GOLDEN = TechTree.Create({SOULTIDE_SCIENCE = 6})
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_RED = TechTree.Create({SOULTIDE_SCIENCE = 8})
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_CRYSTAL = TechTree.Create({SOULTIDE_SCIENCE = 10})

--[[ 修改全部制作配方，对缺失的值进行补充 ]]
for i, v in pairs(AllRecipes) do
	v.level.SOULTIDE_SCIENCE = v.level.SOULTIDE_SCIENCE or 0
end