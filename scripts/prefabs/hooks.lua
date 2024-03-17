--require("soultide/tuning") --for test but its ok -- 不注册的话only能这样 注意路径 没用的 应该还是要使用指定接口apis 寄了
--整理“初学的时候的编写的代码（le se）”的成果
--一动全是报错 我太难了
--品质因子
-- AddComponentPostInit AddPrefabPostInit
--实际上是魔改trader组件里的交易回调函数，算hook


local factor = function(name)
    local t = TUNING.SOULTIDE.FACTOR
    local result = TUNING.SOULTIDE.FACTOR.GREY
    local count = 0
    for key, value in pairs(t) do
        if string.match(string.upper(name), key) -- 从name的头部开始匹配,比小写
        then
            if value > result then
                result = value --显然，要遍历整个表，表中越后的词缀优先级越大n,但是pairs遍历的是随机的,所以取最大
            end
        end
    end
    return result -- 收不到就是 0.8
end
--等级决定的品质--用的武器的 灰 白 绿 蓝 紫 金 红 水晶 不朽
local function _findquality(inst)
    if inst and inst.scale and inst.net_scale then
        local level = inst.scale
        if level < 0 then
            return "grey"
        elseif level <= TUNING.SOULTIDE.T.T1 and level >= 0 then
            return "green"
        elseif level <= TUNING.SOULTIDE.T.T2 and level > TUNING.SOULTIDE.T.T1 then
            return "blue"
        elseif level <= TUNING.SOULTIDE.T.T3 and level > TUNING.SOULTIDE.T.T2 then
            return "purple"
        elseif level <= TUNING.SOULTIDE.T.T4 and level > TUNING.SOULTIDE.T.T3 then
            return "golden"
        elseif level <= TUNING.SOULTIDE.T.T5 and level > TUNING.SOULTIDE.T.T4 then
            return "red"
        elseif level <= TUNING.SOULTIDE.T.T6 and level > TUNING.SOULTIDE.T.T5 then
            return "crystal"
        elseif level <= TUNING.SOULTIDE.T.T7 and level > TUNING.SOULTIDE.T.T6 then
            return "eternal"
        else
            return "white" -- 其他就是white
        end
    end
    return "white"                           -- 其他就是white
end
local function _get_energy_scale_table(inst) -- 等级 , 宝石，暗影，远古，月亮，生命  能量 -1 代表没有
    local tableE = { 1, -1, -1, -1, -1, -1 }
    if inst.scale and inst.net_scale then
        tableE[1] = inst.net_scale:value() or inst.scale or 1
    end
    if inst.gemE and inst.net_gemE then
        tableE[2] = inst.net_gemE:value() or inst.gemE or -1
    end
    if inst.shadowE and inst.net_shadowE then
        tableE[3] = inst.net_shadowE:value() or inst.shadowE or -1
    end
    if inst.lostE and inst.net_lostE then
        tableE[4] = inst.net_lostE:value() or inst.lostE or -1
    end
    if inst.moonE and inst.net_moonE then
        tableE[5] = inst.net_moonE:value() or inst.moonE or -1
    end
    if inst.fleshE and inst.net_fleshE then
        tableE[6] = inst.net_fleshE:value() or inst.fleshE or -1
    end
    return tableE
end

local function _isfull(a, t)
    local notfull = 0
    for index, value in ipairs(t) do
        if index >= 2 then -- 从能量开始
            if t[index] ~= -1 and a ~= t[index] then --存在且不等于E上限
                notfull = notfull + 1
            end
        end
    end
    if notfull ~= 0 then
        return false , notfull--没满
    else
        return true , notfull
    end
end
local function _islock(inst)
    local t = TUNING.SOULTIDE.T
    local count = 0
    if inst.scale then
        for key, value in pairs(t) do
            if inst.scale == value then
                count = count + 1
            end
        end
        if count > 0  then
            print("islocked")   --注意boolean值
            return true
        else
            print("unlocked")
            return false
        end
    end
end



local _redisplayname = function(inst, num)
    local num = num or 50
    if inst.GetDisplayName then
        local old_GetDisplayName = inst.GetDisplayName --重定义
        inst.GetDisplayName = function(self, ...)
            local str = ""
            local tab = _get_energy_scale_table(inst)
            local level = tab[1]
            local elimit = level * num

            str = "_" .. _findquality(inst) .. "\r\nlv[" .. level .. "] "

            if level == TUNING.SOULTIDE.T.T1 and _isfull(elimit, tab) then
                str = str .. TUNING.SOULTIDE.LANGUAGE.TOSCALE_1
            elseif level == TUNING.SOULTIDE.T.T2 and _isfull(elimit, tab) then
                str = str .. TUNING.SOULTIDE.LANGUAGE.TOSCALE_2
            elseif level == TUNING.SOULTIDE.T.T3 and _isfull(elimit, tab) then
                str = str .. TUNING.SOULTIDE.LANGUAGE.TOSCALE_3
            elseif level == TUNING.SOULTIDE.T.T4 and _isfull(elimit, tab) then
                str = str .. TUNING.SOULTIDE.LANGUAGE.TOSCALE_4
            elseif level == TUNING.SOULTIDE.T.T5 and _isfull(elimit, tab) then
                str = str .. TUNING.SOULTIDE.LANGUAGE.TOSCALE_5
            elseif level == TUNING.SOULTIDE.T.T6 and _isfull(elimit, tab) then
                str = str .. TUNING.SOULTIDE.LANGUAGE.TOSCALE_6
            end

            if tab[2] ~= -1 then
                str = str .. "\r\n" .. TUNING.SOULTIDE.LANGUAGE.GEM_E .. ": " .. string.format( "%.1f",tab[2]) .. "/" .. elimit
            end
            if tab[3] ~= -1 then
                str = str .. "\r\n" .. TUNING.SOULTIDE.LANGUAGE.SHADOW_E .. ": " .. string.format( "%.1f",tab[3]) .. "/" .. elimit
            end
            if tab[4] ~= -1 then
                str = str .. "\r\n" .. TUNING.SOULTIDE.LANGUAGE.LOST_E .. ": " .. string.format( "%.1f",tab[4]) .. "/" .. elimit
            end
            if tab[5] ~= -1 then
                str = str .. "\r\n" .. TUNING.SOULTIDE.LANGUAGE.MOON_E .. ": " .. string.format( "%.1f",tab[5]) .. "/" .. elimit
            end
            if tab[6] ~= -1 then
                str = str .. "\r\n" .. TUNING.SOULTIDE.LANGUAGE.FLESH_E .. ": " .. string.format( "%.1f",tab[6]) .. "/" .. elimit
            end
            return old_GetDisplayName(self, ...)
                .. str
        end
    end
end
--检测交易物品的能量(默认检查能量)
local function _check(obj, t) --物体 表
    local t = t or TUNING.SOULTIDE.ENERGY_LIST
    local count = 0
    local count2 = 0
    local val = {0,0,0,0,0} --注意我们是value返回的表，这里初始化不是val = 0
    local k = " "
    for key, value in pairs(t) do
        if string.match(obj.prefab, key) then
            --print("check the prefab match  " .. key)
            count = count + 1
            -- --无序遍历 要保证最大 表的比较 if value > val then 是错误的
            --应该是保证匹配正确度最高，即为key键长度
            if count == 1 then
                 k = key
                 val = value
            elseif count > 1 then
                if #key > #k then --匹配到了更长的字串
                    val = value
                end
            end
        end
    end
    if count ~= 0 then
        print("check the prefab is " .. obj.prefab .. " in it " )
        return true, val  --返回bool 和 有5个值的表 或者一个数字
    else
        print("check the prefab is " .. obj.prefab  .. " not in it ")
        return false, nil
    end
end

--交易时候计算能量
local function _calculateE(inst, giver ,item, num)
    local num = num or 50
    local insttab = _get_energy_scale_table(inst)
    local ac, tab = _check(item)
    local ac2, nextlv = _check(item, TUNING.SOULTIDE.UP)
    local elimit = insttab[1] * num
    -- 能量增加，未达到上限时
    if _isfull(elimit, insttab) == false then
        if insttab[2] ~= -1 then
            inst.gemE = math.min(inst.gemE + tab[1], elimit)
            insttab[2] =  inst.gemE
        end
        if insttab[3] ~= -1 then
            inst.shadowE = math.min(inst.shadowE + tab[2], elimit)
            insttab[3] =  inst.shadowE
        end
        if insttab[4] ~= -1 then
            inst.lostE = math.min(inst.lostE + tab[3], elimit)
            insttab[4] =  inst.lostE
        end
        if insttab[5] ~= -1 then
            inst.moonE = math.min(inst.moonE + tab[4], elimit)
            insttab[5] =  inst.moonE
        end
        if insttab[6] ~= -1 then
            inst.fleshE = math.min(inst.fleshE + tab[5], elimit)
            insttab[6] =  inst.fleshE
        --可以push 溢出事件但是没有
        print("finish cal E ")
        end
        --加完后满没满
        --local insttab2 =   _isfull(elimit, insttab2) insttab2 =  _get_energy_scale_table(inst) ，此时先获得网路变量，但是还没更新，没有用
        --加完之后满了
        if    _isfull(elimit, insttab) and  inst.scale < TUNING.SOULTIDE.DGS_MAX_SCALE then
            ----1.锁住是true
            if  _islock(inst)  == false and  inst.scale < TUNING.SOULTIDE.DGS_MAX_SCALE then 
                inst.scale = insttab[1] + 1
                print("finish up scale ")
            elseif _islock(inst)  ==  true  and  inst.scale < TUNING.SOULTIDE.DGS_MAX_SCALE and ac2 and  insttab[1] ==  nextlv - 1 then
                inst.scale = insttab[1] + 1
                print("finish up scale and quality ")
            end
        end
    else-- 能量增加，达到上限时 
        if _islock(inst)  == false   and  inst.scale < TUNING.SOULTIDE.DGS_MAX_SCALE then
            inst.scale = insttab[1] + 1
            print("finish up scale ")
        elseif _islock(inst) == true and  inst.scale < TUNING.SOULTIDE.DGS_MAX_SCALE and ac2 and  insttab[1] ==  nextlv - 1 then
            inst.scale = insttab[1] + 1
            print("finish up scale and quality ")
        end
    end
end



--交易能量限制
local function _strictE(inst, item, giver,num)
    num = num or 50
    --print("setacceptright")
    local insttab = _get_energy_scale_table(inst)
    local ac ,tab = _check(item)
    local ac2 , nextlv = _check(item,TUNING.SOULTIDE.UP)
    local elimit = insttab[1] * num
  
    if TUNING.SOULTIDE.ENERGY_ADDMIT_OVERFLOW == 1 then
        --能量不足物品符合可加能
        if _isfull(elimit, insttab) == false and ac then
            print("true 1 ")
            return true
        end
    else
        --能量不足物品能量不溢出可加能
        if _isfull(elimit, insttab) == false and ac then
            for i = 2 , #insttab do
                if tab[i - 1] > 0 and (insttab[i] == -1 or  insttab[i] == elimit ) then
                    print("false 1" )
                    return false
                else
                    print("true 2 ")
                    return true
                end
            end
        end
    end
    --能量满了达到要求才能放进阶
    if _isfull(elimit, insttab) == true and ac2 and  insttab[1] == nextlv - 1 then
        print("true 3 ")
        return true
    end
    --return item and (item.prefab == "opalpreciousgem") 超限以后再说
end


-- return
-- {--测试私有函数的
-- 	_findquality = _findquality,
--     _get_energy_scale_table = _get_energy_scale_table,
--     _redisplayname =_redisplayname,
--     _calculateE = _calculateE,
--     _strictE = _strictE
-- }

---[[

-- a = {scale = 5 , gemE = -1 ,shadowE = 32 ,moonE = 108, GetDisplayName = "123"}
-- -- _redisplayname(a)
-- print(a.GetDisplayName)

-- print(findquality(a))


--]]

local function AddEnergyTradePrefab(inst)

    --修改显示函数，也就是所谓的闭包
    if inst.GetDisplayName then
        -- inst.GetDisplayName = function (inst)
        --     _redisplayname(inst, 50） --这个里面自动重写？ 不对，你没保存旧的，导致显示错误
        -- end 
        _redisplayname(inst, 50)
    end
    if not TheWorld.ismastersim then
        return inst
    end
    if inst and inst:HasTag("soultide_E") and inst.components then ---标记可以添加的物体
        print("success add " .. inst.prefab .."with Etrade")
        if inst.components.trader == nil then
            inst:AddComponent("trader")
        end
            inst.components.trader:SetAcceptTest(function (inst,item,giver)
                 --_strictE(inst,item,giver,50) 没有返回值 
                local acc =_strictE(inst,item,giver,50)
                print("check   done ")
                return  acc --返回 true or false
            end) --hook组件
            
            inst.components.trader.onaccept = function (inst, giver, item)  --闭包
                _calculateE(inst, giver, item,50)
                print(("upgrade_Etrade_" .. inst.prefab))
                inst:PushEvent(("upgrade_Etrade_" .. inst.prefab)) --重写或者加入事件，为了性能我们重写onaccept，但是水平不够
            end 
            inst.components.trader:Enable()
    end
end

local prefabs = TUNING.SOULTIDE.PREFABS_E    -- 也就是直接改表 
for _ ,value in pairs(prefabs) do
    AddPrefabPostInit( value , AddEnergyTradePrefab) --分清楚键和值啊，没写键的默认都是1，2，3
    print("now adding " .. value .." with Etrade")  --允许判断一定要写在这个前 执行的时候分两步，预加载这个，进去游戏之后才调用后面的
end



