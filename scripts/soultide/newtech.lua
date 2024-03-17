local TechTree = require("techtree")

AddPrototyperDef("soultide_crystaltower", {
	icon_atlas = "images/soultide_makeicon.xml", icon_image = "soultide_makeicon.tex",
	action_str = "CRYSTAL",	-- 在string里有写
	is_crafting_station = false,
	filter_text = STRINGS.UI.CRAFTING_FILTERS.SOULTIDE,
})

TechTree.Create = function(t)
	t = t or {}
	for i, v in ipairs(TechTree.AVAILABLE_TECH) do
	    t[v] = t[v] or 0
	end
	return t
end
--学习的科技栏
--[[ 修改默认的科技树生成方式 ]]
table.insert(TechTree.AVAILABLE_TECH,"SOULTIDE_SCIENCE")
--[[ 制作等级中加入自己的部分 ]]
TECH.NONE.SOULTIDE_SCIENCE = 0
TECH.SOULTIDE_SCIENCE_BLUE = { SOULTIDE_SCIENCE = 2} --区别在于hint不了下一级
TECH.SOULTIDE_SCIENCE_PURPLE = { SOULTIDE_SCIENCE = 4}
TECH.SOULTIDE_SCIENCE_GOLDEN = { SOULTIDE_SCIENCE = 6}
TECH.SOULTIDE_SCIENCE_RED = { SOULTIDE_SCIENCE = 8}
TECH.SOULTIDE_SCIENCE_CRYSTAL = { SOULTIDE_SCIENCE = 10}

--[[ 原型科技树中加入自己的部分 ]]
for k,v in pairs(TUNING.PROTOTYPER_TREES) do --系统的科技树变量
    v.SOULTIDE_SCIENCE = 0
end
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_BLUE = TechTree.Create({SOULTIDE_SCIENCE = 2})
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_PURPLE = TechTree.Create({SOULTIDE_SCIENCE = 4})
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_GOLDEN = TechTree.Create({SOULTIDE_SCIENCE = 6})
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_RED = TechTree.Create({SOULTIDE_SCIENCE = 8})
TUNING.PROTOTYPER_TREES.SOULTIDE_SCIENCE_CRYSTAL = TechTree.Create({SOULTIDE_SCIENCE = 10})

--[[ 修改全部制作配方，对缺失的值进行补0 ]]
for i, v in pairs(AllRecipes) do
	v.level.SOULTIDE_SCIENCE = v.level.SOULTIDE_SCIENCE or 0
end