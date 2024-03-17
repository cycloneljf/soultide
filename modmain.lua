--[=[前言 学习lua语言而做的
警钟长鸣，一开始学习的时候，因为贴图错误排查了一天，检查贴图和代码逻辑，最后删了重写发现是ATLAS 写成了 ALTAS 导致不能识别贴图路径
包括filter 错拼写成 fliter --tuning（调音，定弦） 拼成turning  -- elseif 拼成 else if 
更多bug - 不先声明SOULTIDE，TUNING值的名字写法前后不一致
函数（组件）认识不全 不判空值 错误的名字前缀

大小写不区分导致路径识别异常 lua 语言是对大小写敏感的
一个上午研究了一个lootdroper
AD.S ~= AD["s"] 哎  lua 语言是对大小写敏感的
prefab 写成 prefeb 完蛋
true 写成 了 ture 一般人早放弃了，但我不是一般人
ListenForEvent 写成 了 ListenforEvent 一般人早放弃了，但我不是一般人
改完之后没有ctrl + s 保存导致没改上 二般人早放弃了，但我不是二般人
各种写错名字和路径
好消息 是能修的bug 坏消息 图片路径多打了一个空格导致游戏崩溃
坏消息*2 图片路径其实多打了两个空格导致游戏崩溃，只删了前面一个
坏消息*3 修改后又不保存 ,你知不知道道我打开一次游戏加载存档要5分钟吗？
各种写错函数名字
学习了许多的优秀mod结构 感谢这个开放平台
多判空（nil） 官方的Coldness组件那里都有判断冷冻值小于0的，一定是代码太神奇了
按 ctrl + s 的时候先按到了s，导致代码里面多打了一个s而报错 。。 
复制粘贴写重复代码的时候没改干净
无所谓 代码水平在肉眼可见的增长 如果你也能和我一样一天花12个小时（早8点到晚12点，减去吃饭休息时间）写代码（包括查资料，做动画） 那可太酷了
怎么动画这么难做啊
手写技能图标的xml文件真酷吧
绘画水平在稳步提升,进步空间很大
要吐了，脑袋好疼,先睡会儿,自从不玩原神后一天能写12个小时，现在头疼，一定是原神干的
经典这也忘了，那也忘了 ，不注册 不return 不写路径 不判空直接添加组件 你又不知道游戏加载顺序

技能树一个bug已经烦我两天了，前面两个都能修，这个不知道问题在哪里,panel为空值，路径是通的，也没有写错
三天时间 为空是因为你的skill和order的panel种类不匹配，有的order没有节点 也就是技能数目没写完导致的
注意代码文件的先后引用顺序
科雷论坛 ~启动！ 考英语6级最有用的一集
]=]
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end}) --局部环境找不到东西会去全局里找--继承/lua元方法

Assets = {
	Asset("ATLAS","images/soultide_makeicon.xml"), --制作栏贴图
	Asset("IMAGE","images/soultide_makeicon.tex"),
	Asset("ATLAS","images/soultide_candyicon.xml"), --制作栏糖果贴图
	Asset("IMAGE","images/soultide_candyicon.tex")


}
local assets = {
	Asset("ANIM", "anim/soultide_candy.zip"),
	Asset("ANIM", "anim/soultide_candybag.zip"),
	Asset("ANIM", "anim/soultide_candybox.zip"),
	Asset("ANIM", "anim/soultide_dgs.zip"),
	Asset("ANIM", "anim/swap_soultide_dgs.zip"),
	Asset("ANIM", "anim/soultide_upnecessity.zip"),
	Asset("ANIM", "anim/soultide_sp.zip"),
	Asset("ANIM", "anim/soultide_crystaltower.zip"),
	Asset("ANIM", "anim/soultide_corolla_bt.zip"),	---饰品
    Asset("ANIM", "anim/swap_soultide_corolla_bt.zip"),
	Asset("ANIM","anim/soultide_brooch_su.zip"),
	Asset("ANIM","anim/swap_soultide_brooch_su.zip"),
	---人物动画
	Asset("ANIM","anim/frisia.zip"),
	Asset("ANIM","anim/ghost_frisia_build.zip"),
	--存档图片
    Asset( "ATLAS", "images/saveslot_portraits/soultide_frisia_savelot.xml" ),
	 --单机选人界面
    Asset( "ATLAS", "images/selectscreen_portraits/soultide_frisia.xml" ),
	--单机未解锁界面
    Asset( "ATLAS", "images/selectscreen_portraits/soultide_frisia_silho.xml" ),
   --人物大图（方形的那个）
    Asset( "ATLAS", "bigportraits/frisia.xml" ),
  --人物大图（椭圆的那个）
    Asset( "ATLAS", "bigportraits/frisia_none.xml" ),
	 --小地图
	Asset( "ATLAS", "images/map_icons/soultide_frisia_mapicon.xml" ),
	 --tab键人物列表显示的头像
    Asset( "ATLAS", "images/avatars/avatar_frisia.xml" ),
	--tab键人物列表显示的头像（死亡）
    Asset( "ATLAS", "images/avatars/avatar_ghost_frisia.xml" ),
	--人物检查按钮的图片
    Asset( "ATLAS", "images/avatars/self_inspect_frisia.xml" ),
	  --人物名字 有字比较好
    Asset( "ATLAS", "images/names_frisia.xml" ),
	----技能树
    Asset( "ATLAS", "images/frisia_skill_background.xml" ),
    Asset( "ATLAS", "images/frisia_skilltree.xml" ),
	Asset( "IMAGE", "images/frisia_skill_background.tex" ),
    Asset( "IMAGE", "images/frisia_skilltree.tex" ),


	
	Asset("ATLAS","images/inventoryimages/soultide_greencandy.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_bluecandy.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_purplecandy.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_goldencandy.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_redcandy.xml"),  --不要拼成ALTAS --不注册就没有贴图
	Asset("ATLAS", "images/inventoryimages/soultide_dgs.xml"), --加载武器物品栏贴图

	Asset("ATLAS","images/inventoryimages/soultide_candybag_blue.xml"), -- 糖果袋的贴图 --糖有五种，袋子有三类
	Asset("ATLAS","images/inventoryimages/soultide_candybag_purple.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_candybag_golden.xml"),

	Asset("ATLAS","images/inventoryimages/soultide_candybox.xml"), --糖果盒贴图
	
	Asset("ATLAS","images/inventoryimages/soultide_core_blue.xml"), -- 核心的贴图
	Asset("ATLAS","images/inventoryimages/soultide_core_purple.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_core_golden.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_core_season.xml"),

	Asset("ATLAS","images/inventoryimages/soultide_moonsoul_blue.xml"),  --升级材料
	Asset("ATLAS","images/inventoryimages/soultide_moonspringcrystal_purple.xml"),

	Asset("ATLAS","images/inventoryimages/soultide_brooch_su.xml"), --饰品
	Asset("ATLAS","images/inventoryimages/soultide_corolla_bt.xml"), --头饰（头盔）
	Asset("ATLAS","images/inventoryimages/soultide_crystaltower.xml"), --水晶塔
	Asset("ATLAS","images/inventoryimages/soultide_crystaltower_item.xml"), --水晶塔
}
for k,v in pairs(assets) do --泛型for,使用无状态迭代器
	table.insert(Assets,v)
end

PrefabFiles = {
    "soultide_candy",
	"soultide_dgs", --soultide_DesolateGardenScythe
	"soultide_candybag",
	"soultide_upnecessity",
	"soultide_candybox",
	"soultide_corolla_bt",
	"soultide_crystaltower",
	"soultide_brooch_su",
	-----人物技能 技能树 芙丽希娅
	"frisia",
	-- "soultide_frisia_skilltree" 这个是import的 么有prefab结构 注意
}

modimport("scripts/soultide/tuning")  		--常量（猜猜为什么放上面） 
modimport("scripts/soultide/string")       --字符串 （猜猜为什么放上面）
modimport("scripts/soultide/newtech")         --科技 （猜猜为什么放上面）
modimport("scripts/soultide/recipe")       --配方
modimport("scripts/skill_trees/string_skilltree_frisia") --技能树的描述
--modimport("scripts/prefabs/soultide_frisia_skilltree")  --技能树
modimport("scripts/soultide/action")       --动作
modimport("scripts/soultide/apis")         --其他初始化 官方的模组接口
modimport("scripts/prefabs/hooks")          --prefabs初始化 or hook 不是prefab 又写错了 还改了两边


--------frisia人物注册
AddModCharacter("frisia", "FEMALE")

GLOBAL.PREFAB_SKINS["frisia"] = {   --修复人物大图显示
	"frisia_none",
}
---初始界面三维展示 放在指定TUNING路径 
TUNING.FRISIA_HEALTH = TUNING.SOULTIDE.FRISIA.HEALTH
TUNING.FRISIA_HUNGER = TUNING.SOULTIDE.FRISIA.HUNGER
TUNING.FRISIA_SANITY = TUNING.SOULTIDE.FRISIA.SANITY
---携带物品展示
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.FRISIA = {"soultide_dgs","soultide_corolla_bt","soultide_candybag_blue"}
local c_startitem = {
	soultide_dgs = {
		atlas = "images/inventoryimages/soultide_dgs.xml",
		image = "soultide_dgs.tex",
	},
    soultide_corolla_bt = {
		atlas = "images/inventoryimages/soultide_corolla_bt.xml",
		image = "soultide_corolla_bt.tex",
	},
    soultide_candybag_blue = {
		atlas = "images/inventoryimages/soultide_candybag_blue.xml",
		image = "soultide_candybag_blue.tex",
	},
}
for k,v in pairs(c_startitem) do
	TUNING.STARTING_ITEM_IMAGE_OVERRIDE[k] = v
end



-- Skilltree
local SkillTreeDefs = require("prefabs/skilltree_defs")

local CreateSkillTree = function()
	print("Creating a skilltree for frisia")
	local BuildSkillsData = require("prefabs/skilltree_frisia") -- Load in the skilltree

    if BuildSkillsData then
        local data = BuildSkillsData(SkillTreeDefs.FN)

        if data then
            SkillTreeDefs.CreateSkillTreeFor("frisia", data.SKILLS)
            SkillTreeDefs.SKILLTREE_ORDERS["frisia"] = data.ORDERS
			print("Created frisia skilltree")
        end
    end
end
CreateSkillTree();

--把skilltreewidget.lua:28--image.lua:8里面的GetskilltreeBG函数找遍了都找不到 不在mainfunction global constant..
--估计在内核里, 就是这个破函数找不到背景路径,只会返回atlas = nil 只能重写一个了
local OldGetSkilltreeBG = GLOBAL.GetSkilltreeBG
GLOBAL.GetSkilltreeBG = function(imagename,...)
	if imagename == "frisia_background.tex" then
		return  "images/frisia_skill_background.xml"
	else
		return OldGetSkilltreeBG(imagename, ...)
	end
end
--你说的对 但是这个也要改 不然找不到图标路径 重写 GetSkilltreeIconAtlas
local old_get_icon = GLOBAL.GetSkilltreeIconAtlas
GLOBAL.GetSkilltreeIconAtlas = function(imagename, ...)
    if imagename ~= nil and imagename:find('frisia') then
        -- if imagename == 'skilltree_ningen_icons.tex' then
        return 'images/frisia_skilltree.xml'
    else
        return old_get_icon(imagename, ...)
    end
end
--修改配方显示函数
local old_shouldhint = GLOBAL.ShouldHintRecipe
GLOBAL.ShouldHintRecipe = function(recipetree, buildertree,...) --recipe.level, tech_trees
	for k, v in pairs(recipetree) do
		if k and string.match(string.lower(tostring(k)),"soultide") then
			--print(tostring(k)) 这里的输出是 SOULTIDE_SCIENCE
			return true
		end
    end
	old_shouldhint(recipetree, buildertree,...)
end

--[=[ --for test
local SkillTreeBuilder  = require("widgets/redux/skilltreebuilder")
local skilltreedefs = require "prefabs/skilltree_defs"
local function createtreetable(skilltreedef)
	local tree = {}

	for i,node in pairs(skilltreedef) do
		if not tree[node.group] then
			tree[node.group] = {}
		end

		tree[node.group][i] = node
	end

	return tree
end
local TILESIZE = 32
local old = SkillTreeBuilder.CreateTree
function SkillTreeBuilder:CreateTree(prefabname, targetdata, readonly)
	self.skilltreedef = skilltreedefs.SKILLTREE_DEFS[prefabname]
	self.target = prefabname
	self.targetdata = targetdata
	self.readonly = readonly

	local treedata = createtreetable(self.skilltreedef)

	for panel,subdata in pairs (treedata) do
		self:CreatePanel({name=panel,data=subdata}, -30)
	end

	local current_x = -260
	local last_width = 0

	--for i,panel in ipairs(self.root.panels)do
	for i,paneldata in ipairs(skilltreedefs.SKILLTREE_ORDERS[self.target]) do
		if self.root.panels then
			print(paneldata[1])
		end
		local panel = self.root.panels[paneldata[1]]	--为空是因为你的skill和order的panel种类不匹配，有的order没有节点 也就是技能数没写完导致的
		if panel then
			print("2")
		end
		current_x = current_x + last_width + TILESIZE
		last_width = panel.c_width
		panel:SetPosition(current_x , 170 )
	end

	self:RefreshTree()
end]=]




