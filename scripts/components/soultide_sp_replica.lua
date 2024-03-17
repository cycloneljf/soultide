local soultide_SP = Class(function (self,inst)
    self.inst = inst
    self.sp_now = net_float(inst.GUID,"net_sp_now")
    self.sp_max = net_float(inst.GUID,"net_sp_max")
    self.sp_changespeed = net_float(inst.GUID,"net_sp_changespeed")
    self.turn = net_ushortint(inst.GUID, "net_turn")
end)

function soultide_SP:GetNow()
    return self.sp_now:value()
end

function soultide_SP:GetMax()
    return self.sp_max:value()
end

function soultide_SP:GetChangeSpeed()
    return self.sp_changespeed:value()
end

function soultide_SP:GetTurn()
    return self.turn:value()
end

return soultide_SP