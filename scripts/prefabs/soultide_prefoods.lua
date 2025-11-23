local myfoods  = require("soultide.foods")


local function MakePreparedFood(data)  --官方源码这一块
    local foodassets = {
        --Asset("ATLAS", "images/inventoryimages/soultide_myfoods_"..data.name..".xml"),--物品栏贴图
        Asset("ANIM", "anim/soultide_myfoods.zip") --总集
    }


    STRINGS.NAMES[string.upper(data.name)] = TUNING.SOULTIDE.LANGUAGE[string.upper(data.name)] --注意名字要保持一致 否则物品贴图可能不加载

    local function fn()
        --实体
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        --动画
        -- inst.AnimState:SetBank(data.name)  --Sprite里面右下角第一层的entity name   
        -- inst.AnimState:SetBuild("soultide_myfoods")  --scml文件名
        -- inst.AnimState:PlayAnimation("idle")  --Sprite里面右下角第二层的animation name
        --官方做法
        inst.AnimState:SetBuild("soultide_myfoods")
        inst.AnimState:SetBank("soultide_myfoods")
        inst.AnimState:PlayAnimation("idle") ------这里是swap_food 的图像
        -- local newstr2 = string.gsub(data.name, "soultide_myfoods_", "") --凑合一下 不可以 烹饪锅调用的是全名
        -- print("[TEST] ".. newstr2)
        inst.AnimState:OverrideSymbol("swap_food", "soultide_myfoods", data.name) --替换你文件中的图像 --这里不是调锅的地方 是修改你动画包的
        --调锅 去看官方源码 cookpot.lua

        --物理
        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)
        --标签信息
        inst:AddTag("preparedfood")
        if data.tags ~= nil then
            for i,v in pairs(data.tags) do
                inst:AddTag(v)
            end
        end
        --图鉴信息
        if data.scrapbook and data.scrapbook.specialinfo then
            inst.scrapbook_specialinfo = data.scrapbook.specialinfo
        end
        --主客机分界
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        --吃
        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.health
        inst.components.edible.hungervalue = data.hunger
        inst.components.edible.sanityvalue = data.sanity or 0
        inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
        inst.components.edible.secondaryfoodtype = data.secondaryfoodtype or nil
        inst.components.edible.temperaturedelta = data.temperature or 0
        inst.components.edible.temperatureduration = data.temperatureduration or 0
        inst.components.edible.nochill = data.nochill or nil
        inst.components.edible.spice = data.spice
        inst.components.edible:SetOnEatenFn(data.oneatenfn)
        --检视
        inst:AddComponent("inspectable")

        --物品栏 触发函数
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = string.lower("images/inventoryimages/"..data.name..".xml")
		if data.OnPutInInventory then
			inst:ListenForEvent("onputininventory", data.OnPutInInventory)
		end
        --堆叠
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
        --添加变质功能 如果可能的话
        if data.perishtime ~= nil and data.perishtime > 0 then
            inst:AddComponent("perishable")
            inst.components.perishable:SetPerishTime(data.perishtime)
            inst.components.perishable:StartPerishing()
            inst.components.perishable.onperishreplacement = "spoiled_food"
        end
        --可燃
        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        --可以做诱饵
        inst:AddComponent("bait")
        --可交易
        inst:AddComponent("tradable")
        --不加作祟 不要改湿润前缀

        return inst
    end

    return Prefab(data.name, fn, foodassets)
end

local prefs = {}

for k, v in pairs (myfoods) do
    table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs) --DST 用的不是新版lua