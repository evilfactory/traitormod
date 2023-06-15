local extension = {}

extension.Identifier = "weaponnerfs"

extension.Init = function ()
    do -- Ceremonial Sword
        local replacement = [[
        <overwrite>
            <Attack targetimpulse="2" severlimbsprobability="0.55" itemdamage="10" structuredamage="1" structuresoundtype="StructureSlash">
                <Affliction identifier="lacerations" strength="5" />
                <Affliction identifier="bleeding" strength="25" />
                <Affliction identifier="stun" strength="0.01" />
            </Attack>
        </overwrite>
        ]]

        local itemPrefab = ItemPrefab.GetItemPrefab("ceremonialsword")
        local element = itemPrefab.ConfigElement.Element.Element("MeleeWeapon")
        Traitormod.Patching.RemoveAll(element, "Attack")
        Traitormod.Patching.Add(element, replacement)
    end

    do -- Hardened Crowbar
        local replacement = [[
        <overwrite>
            <Attack targetimpulse="13" penetration="0.25">
                <Affliction identifier="blunttrauma" strength="14" />
                <Affliction identifier="radiationsickness" strength="5" />
                <Affliction identifier="stun" strength="0.1" />
            </Attack>
        </overwrite>
        ]]

        local itemPrefab = ItemPrefab.GetItemPrefab("crowbarhardened")
        local element = itemPrefab.ConfigElement.Element.Element("MeleeWeapon")
        Traitormod.Patching.RemoveAll(element, "Attack")
        Traitormod.Patching.Add(element, replacement)
    end

     do -- Heavy Wrench
        local replacement = [[
        <overwrite>
            <Attack targetimpulse="15" structuredamage="7" itemdamage="9">
                 <Affliction identifier="blunttrauma" strength="17" />
                 <Affliction identifier="stun" strength="0.8" />
                 <StatusEffect type="OnUse" target="UseTarget">
                    <Conditional entitytype="eq Character"/>
                    <Sound file="Content/Items/Weapons/Smack1.ogg" selectionmode="random" range="500"/>
                    <Sound file="Content/Items/Weapons/Smack2.ogg" range="500" />
                </StatusEffect>
                <StatusEffect type="OnUse" target="This" >
                   <Conditional skillrequirement="true" mechanical="lt 75" />
                   <Affliction identifier="stun" strength="0.3" />
                </StatusEffect>
            </Attack>
        </overwrite>
        ]]
    
        local itemPrefab = ItemPrefab.GetItemPrefab("heavywrench")
        local element = itemPrefab.ConfigElement.Element.Element("MeleeWeapon")
        Traitormod.Patching.RemoveAll(element, "Attack")
        Traitormod.Patching.Add(element, replacement)
    end
end

return extension