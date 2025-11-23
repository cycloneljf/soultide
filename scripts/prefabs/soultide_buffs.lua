
---首先来看 官方的buff 彩虹糖豆的效果
---看完了 改了封装 总结 buff是跟在prefab的子prefab 可以渲染或隐藏 具有几个触发函数
---
---------buff1 生命值恢复 每次1点 100秒 每秒1次
local function healthdelta_OnTick(amount) --工厂函数
    return function (inst, target)
        if target.components.health ~= nil and
            not target.components.health:IsDead() and
            not target:HasTag("playerghost") then  --有生命值 没死 没变鬼
            target.components.health:DoDelta(1, nil, "soultide_buff_healthrecover") --生命值恢复 每次1点
        else
            inst.components.debuff:Stop() --停止
        end
    end
end

local function sanitydelta_OnTick(amount)
    return function (inst, target)
        if target.components.sanity ~= nil and
            not target:HasTag("playerghost") then  -- 有理智组件、不是鬼
            target.components.sanity:DoDelta(amount, nil, "soultide_buff_sanityrecover")  -- 每次恢复1点理智
        else
            inst.components.debuff:Stop() -- 停止buff
        end
    end
end
local function spdelta_OnTick(amount)
    return function (inst, target)
        if target.components.soultide_sp ~= nil and
            not target:HasTag("playerghost") then  -- 有sp组件、不是鬼
            target.components.soultide_sp:DoDelta(amount, nil, "soultide_buff_sanityrecover")  -- 每次恢复1点理智
        else
            inst.components.debuff:Stop() -- 停止buff
        end
    end
end

local function damageboost_OnApply(multiplier,key)
    -- 返回一个闭包函数（与原本结构一致）
    return function(inst, target)
        if target.components.combat ~= nil then
            -- 添加外部伤害加成
            target.components.combat.externaldamagemultipliers:SetModifier(inst, multiplier, key) -- 实体（谁加入的） 数值 标签
        end
    end
end
local function damageboost_OffApply(key)
    -- 返回一个闭包函数（与原本结构一致）
    return function(inst, target)
        if target.components.combat ~= nil then
            -- 删掉外部伤害加成
            target.components.combat.externaldamagemultipliers:RemoveModifier(inst, key)
        end
    end
end
------------ 
-----lua  只支持尾部参数省略 否则就要填nil
local function buffmake_sustain(ontick ,timer_name, duration,frequency ,onattached , onextended, onremoved , ontimerdone)
    --工厂模式这一块 工厂函数 没白学 返回一个匿名函数
    return function ()
        local inst = CreateEntity()
        if not TheWorld.ismastersim then
            --Not meant for client! --只有主机才计算buff
            inst:DoTaskInTime(0, inst.Remove)

            return inst
        end

        local onTick = ontick or nil
        local timer_Name = timer_name
        local duRation = duration or 30 --30秒 (游戏一天默认480s)
        local freQuency = frequency or 1 --30秒

        local onAttached = onattached or function (inst3, target) --不渲染实体的  --剩下的参数 followsymbol, followoffset 是图标,  data, buffer --可以从Adddebuff中传过来而已的两个变量)
            inst3.entity:SetParent(target.entity) --设置父节点
            inst3.Transform:SetPosition(0, 0, 0) --in case of loading 为了加载 因为是prefab嘛 相对于父节点 000 就是原点
            inst3.task = inst3:DoPeriodicTask(freQuency, onTick, nil, target) --每周期做 第三个参数是首次触发的延迟时间
            inst3:ListenForEvent("death", function()
                inst3.components.debuff:Stop()
            end, target)
        end
        local onRemoved = onremoved or inst.Remove
        local onTimerDone_usual = nil   --注意加上local 防止strict 模式报错
        local onExtended_refresh = nil
        if timer_Name ~= nil then
            onTimerDone_usual = function (inst1, data) --结束时间  -没返回值
                if data.name == timer_Name then --计时器名字 收到对应计时器就停止
                    inst1.components.debuff:Stop()
                end
            end

            onExtended_refresh  = function(inst2, target)
                inst2.components.timer:StopTimer(timer_Name)
                inst2.components.timer:StartTimer(timer_Name, duRation)
                inst2.task:Cancel()
                inst2.task = inst:DoPeriodicTask(freQuency, onTick, nil, target) --刷新持续时间
            end

        end

        local onTimerdone = ontimerdone or onTimerDone_usual

        local onExtended = onextended or  onExtended_refresh

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED") --不渲染实体的prefab 的标签

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(onAttached)
        inst.components.debuff:SetDetachedFn(onRemoved) --默认函数 清除自己
        inst.components.debuff:SetExtendedFn(onExtended)
        inst.components.debuff.keepondespawn = true --离开视野 buff不会自动删除

        --没有计时器 没有duration 和timerdone
        if timer_Name ~= nil then
            inst:AddComponent("timer")
            inst.components.timer:StartTimer(timer_Name, duRation)
            inst:ListenForEvent("timerdone", onTimerdone) --默认函数 结束停止buff 移除
        end
        return inst
    end
end
-------------buff toggle开关型/switch
local function buffmake_toggle(ontick ,offtick ,timer_name, duration, delaytime ,onattached , onextended, onremoved , ontimerdone)
    --工厂模式这一块 工厂函数 没白学 返回一个匿名函数
    return function ()
        local inst = CreateEntity()
        if not TheWorld.ismastersim then
            --Not meant for client! --只有主机才计算buff
            inst:DoTaskInTime(0, inst.Remove)

            return inst
        end


        local onTick = ontick or nil
        local offTick  = offtick or nil
        local timer_Name = timer_name
        local duRation = duration or 30 --30秒 (游戏一天默认480s)
        local deLaytime = delaytime or 0.5 --30秒

        local onAttached = onattached or function (inst3, target) --不渲染实体的  --剩下的参数 followsymbol, followoffset 是图标,  data, buffer --可以从Adddebuff中传过来而已的两个变量)
            inst3.entity:SetParent(target.entity) --设置父节点
            inst3.Transform:SetPosition(0, 0, 0) --in case of loading 为了加载 因为是prefab嘛 相对于父节点 000 就是原点
            inst3.task = inst3:DoTaskInTime(deLaytime, onTick, target) --做一次 第一个参数是首次触发的延迟时间
            inst3:ListenForEvent("death", function() --死亡移除
                --inst3.task = inst3:DoTaskInTime(deLaytime, offTick, target)
                inst3.components.debuff:Stop() --调用debuff的stop--然后 debuffable 的 removestop 然后触发debuff ondetachedd 的 self.ondetachedfn(self.inst, target)
            end, target)
        end


        local onRemoved = onremoved or  --移除buff前 先移除效果 移除任务加在这里就行了
        function (inst4,target)
            inst4.task = inst4:DoTaskInTime(delaytime, offTick, target)
            inst4.Remove(inst4)
        end

         --只是用来移除buff实体的prefab
        local onTimerDone_usual = nil
        local onExtended_refresh = nil
        if timer_Name ~= nil then
            onTimerDone_usual = function (inst1, data) --结束时间  -没返回值
                if data.name == timer_Name then --计时器名字 收到对应计时器就停止
                    --inst1.task = inst1:DoTaskInTime(deLaytime, offTick, target)
                    inst1.components.debuff:Stop()
                end
            end

            onExtended_refresh  = function(inst2, target)
                inst2.components.timer:StopTimer(timer_Name) -- 只要重置计时器
                inst2.components.timer:StartTimer(timer_Name, duRation)
            end
        end

        local onTimerdone = ontimerdone or onTimerDone_usual

        local onExtended = onextended or onExtended_refresh

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED") --不渲染实体的prefab 的标签

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(onAttached)
        inst.components.debuff:SetDetachedFn(onRemoved) --默认函数 清除自己
        inst.components.debuff:SetExtendedFn(onExtended)
        inst.components.debuff.keepondespawn = true --离开视野 buff不会自动删除

        --没有计时器 没有duration 和timerdone
        if timer_Name ~= nil then
            inst:AddComponent("timer")
            inst.components.timer:StartTimer(timer_Name, duRation)
            inst:ListenForEvent("timerdone", onTimerdone) --默认函数 结束停止buff 移除
        end
        return inst
    end
end
--------buff 集合返回
return  Prefab("soultide_buff_healthrecover", buffmake_sustain(healthdelta_OnTick(1),"soultide_buff_healthrecover",100,1)),
        Prefab("soultide_buff_healthrecover_small", buffmake_sustain(healthdelta_OnTick(1),"soultide_buff_healthrecover_small",50,1)),
        Prefab("soultide_buff_healthrecover_tiny", buffmake_sustain(healthdelta_OnTick(1),"soultide_buff_healthrecover_tiny",30,1)),
        Prefab("soultide_buff_healthrecover_fast", buffmake_sustain(healthdelta_OnTick(4),"soultide_buff_healthrecover_small",30,1)),
        Prefab("soultide_buff_sanityrecover", buffmake_sustain(sanitydelta_OnTick(1),"soultide_buff_sanityrecover",100,1)),
        Prefab("soultide_buff_sprecover_slow", buffmake_sustain(spdelta_OnTick(1),"soultide_buff_sprecover_slow",100,1)),
        Prefab("soultide_buff_sprecover_mid", buffmake_sustain(spdelta_OnTick(2),"soultide_buff_sprecover_mid",50,1)),
        Prefab("soultide_buff_sprecover_fast", buffmake_sustain(spdelta_OnTick(4),"soultide_buff_sprecover_fast",30,1)),
        Prefab("soultide_buff_monsterbonus", buffmake_toggle(damageboost_OnApply(1.25,"soultide_buff_monsterbonus"), damageboost_OffApply("soultide_buff_monsterbonus"),"soultide_buff_monsterbonus",100,0.5))

--又看了一些代码 很多的oneaten 都没用这套buff组件  从这个stop（）可见一斑
--但是我整了一下 差不多能用了
--除非是你要挂载特效比较好 符合其本质是个有父节点的prefab