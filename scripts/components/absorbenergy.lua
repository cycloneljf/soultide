--储存能量
local AbsorbEnergy = Class(function(self, inst)
    self.inst = inst

    self.E = {
        ["g"] =  0 ,--self.gemE ,    --宝石能量
        ["s"] =  0 ,--self.shadowE , --暗影能量
        ["l"] =  0 ,--self.lostE ,   --远古能量
        ["m"] =  0 ,--self.moonE ,   --月亮能量
        ["f"] =  0 ,--self.fleshE ,  --生命能量
    }

    self.Elimit ={
        ["gl"] =  TUNING.SOULTIDE.ENERGYLIMIT_LOW ,--self.gemElimit ,    --宝石能量
        ["sl"] =  TUNING.SOULTIDE.ENERGYLIMIT_LOW ,-- self.shadowElimit , --暗影能量
        ["ll"] =  TUNING.SOULTIDE.ENERGYLIMIT_LOW ,-- self.lostElimit ,   --远古能量
        ["ml"] =  TUNING.SOULTIDE.ENERGYLIMIT_LOW ,--self.moonElimit ,   --月亮能量
        ["fl"] =  TUNING.SOULTIDE.ENERGYLIMIT_LOW ,--self.fleshElimit ,  --生命能量
    }
    -- 能量为 - 1时默认不存在
    self.inst:AddTag ("soultide_ae")  --增加标签

end,
nil,
nil
)
--加法表
local function addTables(table1, table2)
    local result = {}
    for i, v in pairs(table1) do --注意是pairs
        result[i] = v + (table2[i] or 0)
    end
    return result
end


function AbsorbEnergy:ShowEnergy()
    return self.E
end

-- function AbsorbEnergy:SetEnergy(energylist)
--     local list = energylist or {0,0,0,0,0}
--     self.E = list

-- end


function AbsorbEnergy:DoDeltaEnergy(fuel,aim) --两个obj
    local t = TUNING.SOULTIDE.ENERGY_LIST
    local result
    local success = 0
    if  t  then
        for key, value in pairs(t) do
            if string.match( fuel.prefab , key ) and aim.component.AbsorbEnergy then
                local table = value or {0,0,0,0,0}
                result = addTables(aim.component.AbsorbEnergy.E,table)  
                success = success + 1
            end
        end
        if success ~= 0 then --匹配到了
            for i, _ in pairs(result) do --注意是pairs
                result[i] = math.max(result[i],self.Elimit[i .. "l"])
            end
            return true
        else return false --匹配不到
        end
    end
end

return AbsorbEnergy