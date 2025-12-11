# Turn 0, Skills
{
local need_skills_opened = true
function ready()
if you.turns() == 0 and you.race() ~= "Gnoll" and need_skills_opened then
need_skills_opened = false
crawl.sendkeys("!d10" .. string.char(13) .. "Lair D11-12 Orc D13-15 S-Runes V1-4" .. string.char(13))
you.set_training_target("Maces & Flails",12)
you.set_training_target("Axes",16)
you.set_training_target("Polearms",14)
you.set_training_target("Staves",12)
you.set_training_target("Throwing",9)
you.set_training_target("Short Blades",14)
you.set_training_target("Long Blades",12)
you.set_training_target("Ranged Weapons",18)
you.set_training_target("Armour",9)
you.set_training_target("Dodging",4)
you.set_training_target("Shields",9)
you.set_training_target("Stealth",3.5)
you.set_training_target("Hexes",6)
you.set_training_target("Summonings",6)
you.set_training_target("Necromancy",6)
you.set_training_target("Forgecraft",6)
you.set_training_target("Translocations",9)
you.set_training_target("Alchemy",3)
you.set_training_target("Fire Magic",18)
you.set_training_target("Air Magic",6)
you.set_training_target("Ice Magic",18)
you.set_training_target("Earth Magic",18)
you.set_training_target("Invocations",6)
you.set_training_target("Evocations",3)
you.set_training_target("Shapeshifting",7)
crawl.sendkeys("m","C","c","a")
end
end
}
