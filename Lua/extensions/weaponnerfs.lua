local extension = {}

extension.Identifier = "weaponnerfs"

extension.Init = function ()
    do -- Ceremonial Sword. Vanilla ones shred anyone. These ones instead cause massive bleeding.
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

    do -- Hardened Crowbar. No longer capable of killing everyone. Gives more radiation sickness.
        local replacement = [[
        <overwrite>
            <Attack targetimpulse="13" penetration="0.25">
                <Affliction identifier="blunttrauma" strength="15" />
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

    do -- Dementonite Crowbar. Slightly stronger than hardened crowbar since it can't be crafted. Also gives brain damage.
        local replacement = [[
        <overwrite>
            <Attack targetimpulse="13" penetration="0.25">
                <Affliction identifier="blunttrauma" strength="16" /> 
                <Affliction identifier="psychosis" strength="15" />
                <Affliction identifier="stun" strength="0.1" />
            </Attack>
        </overwrite>
        ]]
        local itemPrefab = ItemPrefab.GetItemPrefab("crowbardementonite")
        local element = itemPrefab.ConfigElement.Element.Element("MeleeWeapon")
        Traitormod.Patching.RemoveAll(element, "Attack")
        Traitormod.Patching.Add(element, replacement)
    end
end

return extension
