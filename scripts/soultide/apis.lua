--也是hook
local function AddTradableComponent(inst)
    if inst and inst.components and inst.components.tradable == nil then
        inst:AddComponent("tradable")
    end
end

local moretrade = TUNING.SOULTIDE.ENERGY_LIST
for key , _ in pairs(moretrade) do
    AddPrefabPostInit( key, AddTradableComponent)
end



