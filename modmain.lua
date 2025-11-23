<<<<<<< HEAD
--前言 本来是为了学习lua语言的，就想尝试
--警钟长鸣，一开始学习的时候，因为贴图错误排查了一天，检查贴图和代码逻辑，最后删了重写发现是ATLAS 写成了 ALTAS 导致不能识别贴图路径
-- 包括filter 错拼写成 fliter --tuning（调音，定弦） 拼成turning  -- elseif 拼成 else if 
-- 更多bug - 不先声明SOULTIDE，TUNING值的名字写法前后不一致
--函数（组件）认识不全 不判空值 错误的名字前缀

--大小写不区分导致路径识别异常 lua 语言是对大小写敏感的
--AD.S ~= AD["s"] 哎
--学习了许多的优秀mod结构 感谢这个开放平台
=======
>>>>>>> 00b334b (v9.8.1)

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end}) --局部环境找不到东西会去全局里找--继承/lua元方法

Assets = {
	Asset("ATLAS","images/soultide_makeicon.xml"), --制作栏贴图
<<<<<<< HEAD
	Asset("IMAGE","images/soultide_makeicon.tex")
=======
	Asset("IMAGE","images/soultide_makeicon.tex"),
	Asset("ATLAS","images/soultide_candyicon.xml"), --制作栏糖果贴图
	Asset("IMAGE","images/soultide_candyicon.tex")
>>>>>>> 00b334b (v9.8.1)
}
local assets = {
	Asset("ANIM", "anim/soultide_candy.zip"),
	Asset("ANIM", "anim/soultide_candybag.zip"),
<<<<<<< HEAD
	Asset("ANIM", "anim/soultide_dgs.zip"),
	Asset("ANIM", "anim/swap_soultide_dgs.zip"),
	Asset("ANIM", "anim/soultide_upnecessity.zip"),
	
	
	
	
	Asset("ATLAS","images/inventoryimages/soultide_greencandy.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_bluecandy.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_purplecandy.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_goldencandy.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_redcandy.xml"),  --不要拼成ALTAS --不注册就没有贴图
	Asset("ATLAS", "images/inventoryimages/soultide_dgs.xml"), --加载武器物品栏贴图

	Asset("ATLAS","images/inventoryimages/soultide_candybag_blue.xml"), -- 糖果袋的贴图 --糖有五种，袋子有三类
	Asset("ATLAS","images/inventoryimages/soultide_candybag_purple.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_candybag_golden.xml"),
	
	Asset("ATLAS","images/inventoryimages/soultide_core_blue.xml"), -- 核心的贴图
	Asset("ATLAS","images/inventoryimages/soultide_core_purple.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_core_golden.xml"),
=======
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
	Asset("ANIM","anim/soultide_myfoods.zip"), --食物动画 记得登记

	---人物动画
	Asset("ANIM","anim/frisia.zip"),
	Asset("ANIM","anim/ghost_frisia_build.zip"),
	--存档图片
    Asset( "ATLAS", "images/saveslot_portraits/frisia.xml" ),
	 --单机选人界面
    Asset( "ATLAS", "images/selectscreen_portraits/soultide_frisia.xml" ),
	--单机未解锁界面
    Asset( "ATLAS", "images/selectscreen_portraits/soultide_frisia_silho.xml" ),
   --人物大图（方形的那个）
    Asset( "ATLAS", "bigportraits/frisia.xml" ),
  --人物大图（椭圆的那个）
    Asset( "ATLAS", "bigportraits/frisia_none.xml" ),
	 --小地图
	Asset( "ATLAS", "images/map_icons/frisia.xml" ),
	 --tab键人物列表显示的头像
    Asset( "ATLAS", "images/avatars/avatar_frisia.xml" ),
	--tab键人物列表显示的头像（死亡）
    Asset( "ATLAS", "images/avatars/avatar_ghost_frisia.xml" ),
	--人物检查按钮的图片
    Asset( "ATLAS", "images/avatars/self_inspect_frisia.xml" ),
	  --人物名字 有字比较好
    Asset( "ATLAS", "images/names_frisia.xml" ),
	----技能树（原版）
    Asset( "ATLAS", "images/frisia_skill_background.xml" ),
    Asset( "ATLAS", "images/frisia_skilltree.xml" ),
	Asset( "IMAGE", "images/frisia_skill_background.tex" ),
    Asset( "IMAGE", "images/frisia_skilltree.tex" ),

	--[专属技能界面Hub

	Asset( "ATLAS", "images/skillicon/background_skill_001.xml" ),
	Asset( "IMAGE", "images/skillicon/background_skill_001.tex" ),

	Asset( "ATLAS", "images/skillicon/icon_skill_active_001.xml" ),
	Asset( "IMAGE", "images/skillicon/icon_skill_active_001.tex" ),
	Asset( "ATLAS", "images/skillicon/icon_skill_active_002.xml" ),
	Asset( "IMAGE", "images/skillicon/icon_skill_active_002.tex" ),
	Asset( "ATLAS", "images/skillicon/icon_skill_buff_001.xml" ),
	Asset( "IMAGE", "images/skillicon/icon_skill_buff_001.tex" ),
	Asset( "ATLAS", "images/skillicon/icon_skill_buff_002.xml" ),
	Asset( "IMAGE", "images/skillicon/icon_skill_buff_002.tex" ),
	Asset( "ATLAS", "images/skillicon/icon_skill_mask.xml" ),
	Asset( "IMAGE", "images/skillicon/icon_skill_mask.tex" ),
	--技能信息面板
	Asset( "ATLAS", "images/skillicon/icon_info_button_001.xml" ),
	Asset( "IMAGE", "images/skillicon/icon_info_button_001.tex" ),

	--]]

	--[物品栏贴图
	Asset("ATLAS","images/inventoryimages/soultide_candy_green.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_candy_blue.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_candy_purple.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_candy_golden.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_candy_red.xml"),  --不要拼成ALTAS --不注册就没有贴图

	Asset("ATLAS", "images/inventoryimages/soultide_dgs.xml"), --加载武器物品栏贴图

	Asset("ATLAS","images/inventoryimages/soultide_candybag_blue.xml"), -- 糖果袋的贴图 --糖有五种，袋子有三类
	Asset("ATLAS","images/inventoryimages/soultide_candybag_purple.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_candybag_golden.xml"),

	Asset("ATLAS","images/inventoryimages/soultide_candybox.xml"), --糖果盒贴图
	
	Asset("ATLAS","images/inventoryimages/soultide_core_green.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_core_blue.xml"), -- 核心的贴图
	Asset("ATLAS","images/inventoryimages/soultide_core_purple.xml"), 
	Asset("ATLAS","images/inventoryimages/soultide_core_golden.xml"),
	Asset("ATLAS","images/inventoryimages/soultide_core_red.xml"),
>>>>>>> 00b334b (v9.8.1)
	Asset("ATLAS","images/inventoryimages/soultide_core_season.xml"),

	Asset("ATLAS","images/inventoryimages/soultide_moonsoul_blue.xml"),  --升级材料
	Asset("ATLAS","images/inventoryimages/soultide_moonspringcrystal_purple.xml"),

<<<<<<< HEAD


=======
	Asset("ATLAS","images/inventoryimages/soultide_brooch_su.xml"), --饰品
	Asset("ATLAS","images/inventoryimages/soultide_corolla_bt.xml"), --头饰（头盔）
	Asset("ATLAS","images/inventoryimages/soultide_crystaltower.xml"), --水晶塔
	Asset("ATLAS","images/inventoryimages/soultide_crystaltower_item.xml"), --水晶塔

	Asset("ATLAS", "images/inventoryimages/soultide_myfoods_gemcake.xml"),--食物
	Asset("ATLAS", "images/inventoryimages/soultide_myfoods_fruitcandy.xml"),
	Asset("ATLAS", "images/inventoryimages/soultide_myfoods_weirdcandy.xml"),
	Asset("ATLAS", "images/inventoryimages/soultide_myfoods_meatjelly.xml"),
	Asset("ATLAS", "images/inventoryimages/soultide_myfoods_moshcreamcube.xml"),

	Asset("ATLAS", "images/inventoryimages/soultide_myfoods_sourfishball.xml"),
	Asset("ATLAS", "images/inventoryimages/soultide_myfoods_spicykelp.xml"),
	Asset("ATLAS", "images/inventoryimages/soultide_myfoods_pectincube.xml"),
	Asset("ATLAS", "images/inventoryimages/soultide_myfoods_honeyveggie.xml"),
	--]]
>>>>>>> 00b334b (v9.8.1)
}
for k,v in pairs(assets) do --泛型for,使用无状态迭代器
	table.insert(Assets,v)
end

PrefabFiles = {
    "soultide_candy",
	"soultide_dgs", --soultide_DesolateGardenScythe
	"soultide_candybag",
<<<<<<< HEAD
	"soultide_upnecessity"
}

modimport("scripts/soultide/recipe")       --配方
modimport("scripts/soultide/string")       --字符串
modimport("scripts/soultide/action")       --动作
modimport("scripts/soultide/tuning")  		--常量
modimport("scripts/soultide/apis")         --初始化 or hook
modimport("scripts/soultide/newtech")         --科技

--设置数据
TUNING.SOULTIDE.EXTRA =  GetModConfigData("soultide_num")
TUNING.SOULTIDE.DGS.MAX_SCALE =  GetModConfigData("soultide_scale") + 10 or 10

=======
	"soultide_upnecessity",
	"soultide_candybox",
	"soultide_corolla_bt",
	"soultide_crystaltower",
	"soultide_brooch_su",
	"soultide_prefoods", --做的食物
	-----人物技能 技能树 芙丽希娅
	"frisia",
	-- "soultide_frisia_skilltree" 这个是import的 么有prefab结构 注意
	"soultide_buffs" --buff 也是实体
}

------------test
AddReplicableComponent("soultide_sp") --读取组件自动读了 （猜猜为什么放上面）

modimport("scripts/soultide/tuning")  		--常量（猜猜为什么放上面） 
modimport("scripts/soultide/string")       --字符串 （猜猜为什么放上面）
modimport("scripts/soultide/newtech")         --科技 （猜猜为什么放上面）
modimport("scripts/soultide/recipe")       --配方
modimport("scripts/skill_trees/string_skilltree_frisia") --技能树的描述
--modimport("scripts/prefabs/soultide_frisia_skilltree")  --技能树 直接在modmain中写
modimport("scripts/soultide/action")       --动作
modimport("scripts/soultide/apis")         --其他初始化 官方的模组接口
modimport("scripts/prefabs/hooks")          --prefabs初始化 or hook 不是prefab 又写错了 还改了两边
modimport("scripts/soultide/foodsrecipe")   --添加食谱

--------frisia人物注册
AddModCharacter("frisia", "FEMALE")

GLOBAL.PREFAB_SKINS["frisia"] = {   --修复人物大图显示
	"frisia_none",
}
--小地图注册
AddMinimapAtlas("images/map_icons/frisia.xml")

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
	print("[frisia]Creating a skilltree for frisia")
	local BuildSkillsData = require("prefabs/skilltree_frisia") -- Load in the skilltree

    if BuildSkillsData then
        local data = BuildSkillsData(SkillTreeDefs.FN)

        if data then
            SkillTreeDefs.CreateSkillTreeFor("frisia", data.SKILLS)
            SkillTreeDefs.SKILLTREE_ORDERS["frisia"] = data.ORDERS
			print("[frisia]Created frisia skilltree")
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
>>>>>>> 00b334b (v9.8.1)
