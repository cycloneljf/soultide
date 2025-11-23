local SoulTide_SpHealer = Class(function(self, inst)
    self.inst = inst
    self.sp = 1
end)

function SoulTide_SpHealer:SetSpAmount(sp)
    self.sp = sp
end

function SoulTide_SpHealer:SpHeal(target)
    if target.components.soultide_sp ~= nil then
        target.components.soultide_sp:DoDelta(self.sp)
        ---------自定义恢复
		if self.onsphealfn ~= nil then
			self.onsphealfn(self.inst, target)
		end
        ---------移除一个或者全部-----然后注册进action/不如借用eator/edible组件的动作 那这个组件...
        if self.inst.components.stackable ~= nil and self.inst.components.stackable:IsStack() then
            self.inst.components.stackable:Get():Remove()
        else
            self.inst:Remove()
        end
        return true
    end
end

return SoulTide_SpHealer