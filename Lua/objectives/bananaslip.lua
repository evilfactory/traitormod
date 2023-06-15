local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "BananaSlip"
objective.AmountPoints = 850
objective.Times = 3
objective.RoleFilter = {
    ["he-chef"] = true,
    ["staff"] = true,
    ["janitor"] = true,
    ["prisondoctor"] = true,
    ["guard"] = true,
    ["warden"] = true,
    ["headguard"] = true,
}

objective.Static = function ()
    local replacement = [[
        <overwrite>
        <StatusEffect type="OnUse" target="This" Condition="-100.0" disabledeltatime="true" conditionalcomparison="And">
            <Conditional Speed="lt 0.1" />
            <Conditional IsContained="false" />
        </StatusEffect>
        <StatusEffect type="OnBroken" target="This">
            <ParticleEmitter particle="whitegoosplash" anglemin="0" anglemax="360" particleamount="2" velocitymin="0" velocitymax="0" scalemin="1" scalemax="1" colormultiplier="255,150,0" />
            <ParticleEmitter particle="fruitchunks" anglemin="0" anglemax="360" particleamount="3" velocitymin="200" velocitymax="300" scalemin="0.4" scalemax="0.5" colormultiplier="200,255,0" />
            <Explosion range="20" force="-10.0" shockwave="false" smoke="false" flames="false" flash="false" sparks="false" underwaterbubble="false">
            <StatusEffect type="OnUse" target="Character" Condition="-100.0" disabledeltatime="true" conditionalcomparison="And">
                <sound file="Content/Items/Jobgear/Clown/ITEM_bananaSlip1.ogg" />
                <sound file="Content/Items/Jobgear/Clown/ITEM_bananaSlip2.ogg" />
                <sound file="Content/Items/Jobgear/Clown/ITEM_bananaSlip3.ogg" />
                <sound file="Content/Items/Jobgear/Clown/ITEM_bananaSlip4.ogg" />
                <Conditional HasStatusTag="!equals clown" />
                <Conditional mass="lt 200"/>
                <Conditional stun="lte 0"/>
                <Affliction identifier="stun" strength="4" />
                <TriggerEvent identifier="clownhaven_progress" />
                <LuaHook name="bananaslip" />
            </StatusEffect>
            </Explosion>
            <RemoveItem />
        </StatusEffect>
        </overwrite>
    ]]

    local bananaPeel = ItemPrefab.GetItemPrefab("bananapeel")
    local element = bananaPeel.ConfigElement.Element.Element("MotionSensor")
    Traitormod.Patching.RemoveAll(element, "StatusEffect")
    Traitormod.Patching.Add(element, replacement)

    Hook.Add("bananaslip", "test", function(effect, deltaTime, item, targets, worldPosition)
        Traitormod.RoleManager.CallObjectiveFunction("BananaSlip", targets[1])
    end)
end

function objective:Start(target)
    self.Target = target
    self.Progress = 0

    if self.Target == nil then return false end

    self.Text = string.format(Traitormod.Language.ObjectiveBananaSlip, self.Target.Name, self.Progress, self.Times)

    return true
end

function objective:BananaSlip(character)
    if character == self.Target then
        self.Progress = self.Progress + 1
        self.Text = string.format(Traitormod.Language.ObjectiveBananaSlip, self.Target.Name, self.Progress, self.Times)
    end
end

function objective:IsCompleted()
    return self.Progress >= self.Times
end

function objective:IsFailed()
    return self.Target.IsDead
end

return objective
