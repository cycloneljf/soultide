--前言 本来是为了学习lua语言的，就想尝试
--警钟长鸣，一开始学习的时候，因为贴图错误排查了一天，检查贴图和代码逻辑，最后删了重写发现是ATLAS 写成了 ALTAS 导致不能识别贴图路径
-- 包括filter 错拼写成 fliter --tuning（调音，定弦） 拼成turning  -- elseif 拼成 else if 
-- 更多bug - 不先声明SOULTIDE，TUNING值的名字写法前后不一致
--函数（组件）认识不全 不判空值 错误的名字前缀

--大小写不区分导致路径识别异常 lua 语言是对大小写敏感的
--AD.S ~= AD["s"] 哎
--学习了许多的优秀mod结构 感谢这个开放平台

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end}) --局部环境找不到东西会去全局里找--继承/lua元方法

Assets = {
	Asset("ATLAS","images/soultide_makeicon.xml"), --制作栏贴图
	Asset("IMAGE","images/soultide_makeicon.tex")
}
local assets = {
	Asset("ANIM", "anim/soultide_candy.zip"),
	Asset("ANIM", "anim/soultide_candybag.zip"),
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
	Asset("ATLAS","images/inventoryimages/soultide_core_season.xml"),

	Asset("ATLAS","images/inventoryimages/soultide_moonsoul_blue.xml"),  --升级材料
	Asset("ATLAS","images/inventoryimages/soultide_moonspringcrystal_purple.xml"),



}
for k,v in pairs(assets) do --泛型for,使用无状态迭代器
	table.insert(Assets,v)
end

PrefabFiles = {
    "soultide_candy",
	"soultide_dgs", --soultide_DesolateGardenScythe
	"soultide_candybag",
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

