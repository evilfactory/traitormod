__**Prison RP Traitors**__

> Television's Prison RP Traitor Mod is a fork of Evil Factory's traitormod that keeps in mind the custom roles and objectives that the RP mode offers.
> The high-ranking members are always loyal to the coalition and need to work together to find and restrain all traitors so the crew can complete their mission.

__**The Points System**__

> Whenever a player gains a skill point, he also gains an amount of points. Traitors gain additional points by completing their objectives. Non-Traitor crew gains points by completing their missions and reaching the end of the level. 
> Points will be persistently stored on the server and accumulate over rounds. If a player dies a number of times the amount of points will be reduced. Players can gain lives back by completing their missions.
> On every round half of a player's points will be given the character as experience and can be used to pick talents.

__**Pointshop**__
> All crewmates have access to the pointshop where they can buy basic resources and other things. Traitors get access to a special menu in the pointshop where they can buy things to assist in their mission. Spectators have access to the death spawn menu in the pointshop, where they can spawn as monsters.
It's also possible to buy new ships in the pointshop, but that requires you to have OverrideRespawnSub set to true in config.lua.

__**Ghost Roles**__
> Ghost Roles allows dead spectators to take control of things like pirates, and some monsters, like the watcher and the mudraptor pet.

__**Traitor Types**__

## Normal Traitor

> **Main objectives** - one of these will always be chosen
> 
> • *Assassination*
> Traitors will receive a target crew member to kill. Once the target is killed a new victim will be selected from all alive crew members. Every crew member can only be targeted once. If there are no new targets left, the traitor wins.

> **Sub objectives** - up to three of these may be chosen and can be done optionally to gain more points 
> 
> • *Kidnapping*
> Put a selected crewmate in handcuffs for a given time.
> 
> • *Poison Warden*
> Inject the warden with poison. This is only available for medic traitors
> 
> • *Steal Captain ID*
> Take the ID card from your acting captain and put it in your inventory.
> 
> • *Survive*
> Finish at least one main objective and be alive at the end of the round. Can be set to be always active.
>
> • *Deconstruct weapons*
> Deconstruct 2 weapons to prevent the coalition from fighting back.

## Medic Traitor
>Medic traitors are a variant of the normal traitor that are medics. They have access to a special pointshop and objectives.

## Husk Cultist

> **Main objectives** - one of these will always be chosen
> 
> • *Husk*
> Traitors will receive a target crew member to turn into husk. Once the target is husked a new victim will be selected from all alive crew members. Every crew member can only be targeted once. If there are no new targets left, the traitor wins.

> **Sub objectives** - up to three of these may be chosen and can be done optionally to gain more points 
> 
> • *Kidnapping*
> Put a selected crewmate in handcuffs for a given time.
> 
> • *Turn Yourself Into Husk*
> Turn yourself into a husk to gain a live.
>
> • *Assassinate*
> Assasinate a randomly selected crewmate.
> 
> • *Deconstruct Calyxanide*
> Deconstruct an amount of Calyxanide.

__**Events**__

There is a chance that a random event fires some time during the round.

> • *Super Ballast Flora*
> Several ballast tanks will be infested with alien plants.

> • *Communications Offline*
> Will drastically reduce the range of all remote communication for the whole round.

> • *Lights Off*
> Will turn off all lights in the main submarine for a limited amount of time.

> • *Hidden Pirate*
> A weak pirate will spawn in a random pump.
> • *Beacon Pirate*

> A dangerous pirate will spawn in a beacon station and the crew will be tasked to kill it for a reward in points.

> • *Wreck Pirate*
> A dangerous pirate will spawn in a random wreck and the crew will be tasked to kill it for a reward in points.

> • *Abyss Help*
> Incoming Distress Call... H---! -e-----uck i- --e abys-- W- n--d -e-- A l--her dr---e- us d--- her-. ---se -e a-e of--ring ----thing w- -ave, inclu--- our ---0 -o------

> • *Medical Delivery*
> A delivery of medical resources will be spawned in medbay to assist the crew.

> • *Maintenance Tools Delivery*
> A delivery of maintenance tools will be spawned in cargo to assist the crew.

> • *Ammo Delivery*
> A delivery of coilgun ammo boxes and railgun shells will be made into armoury to assist the crew.

> • *Emergency Team*
> A group of 4 bots consisting of mechanics and engineers will come to the submarine to help fix things.
