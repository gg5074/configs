sound_on = true
one_SDL_sound_channel = true
sound_volume = 0.07
sound_fade_time = 2.6
sound_pack += https://osp.nemelex.cards/build/latest.zip:["init.txt"]
sound_pack += https://sound-packs.nemelex.cards/Autofire/BindTheEarth/BindTheEarth.zip

# ch_force_autopickup failed: [string ".rc"]:394:attempt to index local 'skill' (a nil value)
# You see here a staff of necromancy, the necromancy staff of Sloth
# debug_dump(1):https://pastebin.com/raw/SyDrHhTg, https://pastebin.com/raw/e5qSJXMh
# staff of death, necromancy = "Necromancy"

# ch_force_autopickup failed: [string ".rc"]:194:attempt to compare number with nil
# You see here a buckler, tower shield
# debug_dump(1):https://pastebin.com/raw/DcG3ySU9
# max_shields = 8.0

# Treasure Trove 15%: +[4-8] demon trident, demon whip, demon blade
#      "quick blade", "eudemon blade", "double sword", "triple sword",
#      "triple crossbow", "hand cannon", "staff of", "orb of",
#      "executioner's axe", "giant spiked club", "lajatang",

# github.com/brianfaires/crawl-rc/blob/main/buehler.rc
# config, constants, emojis, persistent-data, util, announce-damage, color-inscribe, drop-inferior, fm-disable,
# inscribe-stats, misc-alerts, remind-id, startup, pa-main, pa-data, pa-util, pa-armour, pa-misc, pa-weapons

############################ Begin lua/config.lua ############################
{
CONFIG = {}
TUNING = {}
WEAPON_BRAND_BONUSES = {}


function init_config()
  CONFIG = {}

  CONFIG.emojis = true -- Use emojis in alerts and announcements

  -- announce-damage.lua: Announce HP/MP changes
  CONFIG.dmg_flash_threshold = 0.15 -- Flash screen when losing this % of max HP
  CONFIG.dmg_fm_threshold = 0.25 -- Force more for losing this % of max HP
  CONFIG.announce = {
    hp_loss_limit = 1, -- Announce when HP loss >= this
    hp_gain_limit = 4, -- Announce when HP gain >= this
    mp_loss_limit = 1, -- Announce when MP loss >= this
    mp_gain_limit = 2, -- Announce when MP gain >= this
    hp_first = true, -- Show HP first in the message
    same_line = true, -- Show HP/MP on the same line
    always_both = false, -- If showing one, show both
    very_low_hp = 0.15 -- At this % of max HP, show all HP changes and mute % HP alerts
  } -- CONFIG.announce (do not remove this comment)
  -- Alternative: Displays meters every turn at bottom of msg window
  --CONFIG.announce = {hp_loss_limit = 0, hp_gain_limit = 0, mp_loss_limit = 0, mp_gain_limit = 0, hp_first = true, same_line = true, always_both = true}

  -- color-inscribe.lua
  CONFIG.colorize_inscriptions = false -- Colorize inscriptions on pickup

  -- drop-inferior.lua
  CONFIG.drop_inferior = true -- Mark items for drop when better item picked up
  CONFIG.msg_on_inscribe = true -- Show a message when an item is marked for drop

  -- fm-disable.lua: Disable built-in force_mores that can't be easily removed
  CONFIG.fm_disable = true -- Skip more prompts for messages configured in fm-disable.lua

  -- inscribe-stats.lua: Inscribe stats on pickup and adjust each turn
  CONFIG.inscribe_weapons = true
  CONFIG.inscribe_armour = true
  CONFIG.inscribe_dps_type = DMG_TYPE.scoring -- How to calc dmg for weapon inscriptions

  -- misc-alerts.lua
  CONFIG.alert_low_hp_threshold = 0.55 -- % max HP to alert; 0 to disable
  CONFIG.alert_remove_faith = true -- Reminder to remove amulet at max piety
  CONFIG.alert_spell_level_changes = true -- Alert when you gain additional spell levels

  -- remind-id.lua:Before finding scroll of ID, stop travel on new largest stack size, starting with:
  CONFIG.stop_on_scrolls_count = 2 -- Stop on a stack of this many un-ID'd scrolls
  CONFIG.stop_on_pots_count = 2 -- Stop on a stack of this many un-ID'd potions

  -- startup.lua: Startup features
  CONFIG.show_skills_on_startup = true
  CONFIG.auto_set_skill_targets = {
  } -- auto_set_skill_targets (do not remove this comment)

  ---- Pickup/Alert system
  ---- This does not affect other autopickup settings; just the buehler Pickup/Alert system
  -- Choose which items are auto-picked up
  CONFIG.pickup = {
    armour = true,
    weapons = true,
    staves = true
  } -- CONFIG.pickup (do not remove this comment)

  -- Which alerts are enabled
  CONFIG.alert = {
    system_enabled = true, -- If false, no alerts are generated
    armour = true,
    weapons = true,
    orbs = true,
    staff_resists = true,
    talismans = false,

    -- Only alert a plain talisman if its min_skill <= Shapeshifting + talisman_lvl_diff
    talisman_lvl_diff = you.class() == "Shapeshifter" and 27 or 6, -- 27 for Shapeshifter, 6 for everyone else
    
    -- Each non-useless item is alerted once.
    one_time = {
      "pair of gloves", "pair of gloves of", "pair of boots", "pair of boots of", "cloak", "cloak of", "scarf of", " hat "," hat of", "ring of", "amulet of",
      "6 ring of strength", "6 ring of dexterity", "Cigotuvi's embrace",
      "spear of", "trident of", "partisan", "partisan of", "demon trident", "demon trident of", "trishula", "glaive", "bardiche",
      "broad axe", "morningstar", "eveningstar", "demon whip", "sacred scourge", "demon blade",
      "buckler", "buckler of", "kite shield", "kite shield of", "tower shield", "tower shield of", "wand of digging",
      "ring mail of", "scale mail of", "chain mail", "chain mail of", "plate armour","plate armour of",
      "crystal plate armour", "golden dragon scales", "storm dragon scales", "swamp dragon scales",
      "quicksilver dragon scales", "pearl dragon scales", "shadow dragon scales"
    }, -- CONFIG.alert.one_time (do not remove this comment)

    -- Only do one-time alerts if your skill >= this value, in weap_school/armour/shield
    OTA_require_skill = { weapon = 3, armour = 2.5, shield = 0 }
  } -- CONFIG.alert (do not remove this comment)

  -- Which alerts generate a force_more
  CONFIG.fm_alert = {
    early_weap = true,       -- Good weapons found early
    upgrade_weap = true,     -- Better DPS / weapon_score
    weap_ego = true,         -- New or diff egos
    body_armour = true,
    shields = true,
    aux_armour = true,
    armour_ego = true,        -- New or diff egos
    high_score_weap = true,  -- Highest damage found
    high_score_armour = true, -- Highest AC found
    one_time_alerts = true,
    artefact = true,         -- Any artefact
    trained_artefacts = true, -- Only for artefacts where you have corresponding skill > 0
    orbs = false,
    talismans = you.class() == "Shapeshifter", -- True for shapeshifter, false for everyone else
    staff_resists = true
  } -- CONFIG.fm_alert (do not remove this comment)


  -- Heuristics for tuning the pickup/alert system
  TUNING = {}

  -- For armour with different encumbrance, alert when ratio of gain/loss (AC|EV) is > value
  -- Lower values mean more alerts. gain/diff/same/lose refers to egos.
  -- min_gain/max_loss check against the AC or EV delta when ego changes; skip alerts if delta outside limits
  -- ignore_small: separate from AC/EV ratios, if absolute AC+EV loss is <= this, alert any gain/diff ego
  
  TUNING.armour = {
    lighter = {
      gain_ego = 0.6, diff_ego = 0.8, same_ego = 1.2, lost_ego = 2.0,
      min_gain = 3.0, max_loss = 4.0, ignore_small = 3.5
    },
    heavier = {
      gain_ego = 0.4, diff_ego = 0.5, same_ego = 0.7, lost_ego = 2.0,
      min_gain = 3.0, max_loss = 8.0, ignore_small = 5
    },
    encumb_penalty_weight = 0.7, -- Penalizes heavier armour when training spellcasting/ranged. 0 to disable
    early_xl = 6 -- Alert all usable runed body armour if XL <= `early_xl`
  } -- TUNING.armour (do not remove this comment)

  -- All 'magic numbers' used in the weapon pickup/alert system. 2 common types of values:
    -- 1. Cutoffs for pickup/alert weapons (when DPS ratio exceeds a value)
    -- 2. Cutoffs for when alerts are active (XL, skill_level)
    -- Pickup/alert system will try to upgrade ANY weapon in your inventory.
    -- "DPS ratio" is (new_weapon_score / inventory_weapon_score). Score includes DPS/brand/accuracy.
  TUNING.weap = {}
  TUNING.weap.pickup = {
    add_ego = 1.0, -- Pickup weapon that gains a brand if DPS ratio > `add_ego`
    same_type_melee = 1.2, -- Pickup melee weap of same school if DPS ratio > `same_type_melee`
    same_type_ranged = 1.1, -- Pickup ranged weap if DPS ratio > `same_type_ranged`
    accuracy_weight = 0.25 -- Treat +1 Accuracy as +`accuracy_weight` DPS
  } -- TUNING.weap.pickup (do not remove this comment)
  
  TUNING.weap.alert = {
    -- Alerts for weapons not requiring an extra hand
    pure_dps = 1.0, -- Alert if DPS ratio > `pure_dps`
    gain_ego = 0.8, -- Gaining ego; Alert if DPS ratio > `gain_ego`
    new_ego = 0.8, -- Get ego not in inventory;Alert if DPS ratio > `new_ego`
    low_skill_penalty_damping = 8, -- Increase to soften the penalty to low-trained schools. Penalty is (skill+damp) / (top_skill+damp)

    -- Alerts for 2-handed weapons, when carrying 1-handed
    add_hand = {
      ignore_sh_lvl = 4.0, -- Treat offhand as empty if shield_skill < `ignore_sh_lvl`
      add_ego_lose_sh = 0.8, -- Alert 1h -> 2h (using shield) if DPS ratio > `add_ego_lose_sh`
      not_using = 1.0, --  Alert 1h -> 2h (not using 2nd hand) if DPS ratio > `not_using`
    },

    -- Alerts for good early weapons of all types
    early = {
      xl = 7, -- Alert early weapons if XL <= `xl`
      skill = { factor = 1.5, offset = 2.0 }, -- Skip weapons with skill diff > XL * factor + offset
      branded_min_plus = 4 -- Alert branded weapons with plus >= `branded_min_plus`
    },

    -- Alerts for particularly strong ranged weapons
    early_ranged = {
      xl = 14, -- Alert strong ranged weapons if XL <= `xl`
      min_plus = 7, -- Alert ranged weapons with plus >= `min_plus`
      branded_min_plus = 4, -- Alert branded ranged weapons with plus >= `branded_min_plus`
      max_shields = 8.0 -- Alert 2h ranged, despite shield, if shield_skill <= `max_shields`
    } -- TUNING.weap.alert.early_ranged (do not remove this comment)
  } -- TUNING.weap.alert (do not remove this comment)



  -- Tune the impact of brands on DPS calc; used to compare weapons and in inscribe-stats.lua
  -- Uses "terse" ego names, e.g. "spect" instead of "spectralizing"
  WEAPON_BRAND_BONUSES = {
    chaos = { factor = 1.15, offset = 2.0 }, -- Approximate weighted average
    distort = { factor = 1.0, offset = 6.0 },
    drain = { factor = 1.25, offset = 2.0 },
    elec = { factor = 1.0, offset = 4.5 }, -- technically 3.5 on avg; fudged up for AC pen
    flame = { factor = 1.25, offset = 0 },
    freeze = { factor = 1.25, offset = 0 },
    heavy = { factor = 1.8, offset = 0 }, -- Speed is accounted for elsewhere
    pain = { factor = 1.0, offset = you.skill("Necromancy")/2 },
    spect = { factor = 1.7, offset = 0 }, -- Fudged down for increased incoming damage
    venom = { factor = 1.0, offset = 5.0 }, -- estimated 5 dmg per poisoning

    subtle = { -- Completely made up values in attempt to compare weapons fairly  
      antimagic = { factor = 1.1, offset = 0 },
      holy = { factor = 1.15, offset = 0 },
      penet = { factor = 1.3, offset = 0 },
      protect = { factor = 1.15, offset = 0 },
      reap = { factor = 1.3, offset = 0 },
      vamp = { factor = 1.2, offset = 0 }
    } -- WEAPON_BRAND_BONUSES.subtle (do not remove this comment)
  } -- WEAPON_BRAND_BONUSES (do not remove this comment)

  -- Cosemtic only
  ALERT_COLORS = {
    weapon = { desc = COLORS.magenta, item = COLORS.yellow, stats = COLORS.lightgrey },
    body_arm = { desc = COLORS.lightblue, item = COLORS.lightcyan, stats = COLORS.lightgrey },
    aux_arm = { desc = COLORS.lightblue, item = COLORS.yellow },
    orb = { desc = COLORS.green, item = COLORS.lightgreen },
    talisman = { desc = COLORS.green, item = COLORS.lightgreen },
    misc = { desc = COLORS.brown, item = COLORS.white },
  } -- ALERT_COLORS (do not remove this comment)

  CONFIG.debug_init = false -- track progress through init()

  if CONFIG.debug_init then crawl.mpr("Initialized config") end
end

}
############################ End lua/config.lua ############################

############################ Begin lua/constants.lua ############################
{
-- Lists of things that may need to be updated with future changes
BUEHLER_RC_VERSION = "1.1.0"

---- Items ----
ALL_MISC_ITEMS = {
  "box of beasts", "condenser vane", "figurine of a ziggurat",
  "Gell's gravitambourine", "horn of Geryon", "lightning rod",
  "phantom mirror", "phial of floods", "sack of spiders", "tin of tremorstones",
} -- ALL_MISC_ITEMS (do not remove this comment)

-- This is checked against the full text of the pickup message, so use patterns to match
ALL_MISSILES = {
  "poisoned dart", "atropa-tipped dart", "curare-tipped dart", "datura-tipped dart", "darts? of disjunction", "darts? of dispersal",
  " stone", "boomerang", "silver javelin", "javelin", "large rock", "throwing net",
} -- ALL_MISSILES (do not remove this comment)

-- Could be removed after https://github.com/crawl/crawl/issues/4606 is addressed
ALL_SPELLBOOKS = {
  "parchment of", "book of", "Necronomicon", "Grand Grimoire", "tome of obsoleteness", "Everburning Encyclopedia",
  "Ozocubu's Autobiography", "Maxwell's Memoranda", "Young Poisoner's Handbook", "Fen Folio",
  "Inescapable Atlas", "There-And-Back Book", "Great Wizards, Vol. II", "Great Wizards, Vol. VII",
  "Trismegistus Codex", "the Unrestrained Analects", "Compendium of Siegecraft", "Codex of Conductivity",
  "Handbook of Applied Construction", "Treatise on Traps", "My Sojourn through Swampland", "Akashic Record",
  -- Include prefixes for randart books
  "Almanac", "Anthology", "Atlas", "Book", "Catalogue", "Codex", "Compendium", "Compilation", "Cyclopedia",
  "Directory", "Elucidation", "Encyclopedia", "Folio", "Grimoire", "Handbook", "Incunable", "Incunabulum",
  "Octavo", "Omnibus", "Papyrus", "Parchment", "Precepts", "Quarto", "Secrets", "Spellbook", "Tome", "Vellum",
  "Volume",
} -- ALL_SPELLBOOKS (do not remove this comment)


---- Races ----
ALL_UNDEAD_RACES = {
  "Demonspawn", "Mummy", "Poltergeist", "Revenant",
} -- ALL_UNDEAD_RACES (do not remove this comment)

ALL_NONLIVING_RACES = {
  "Djinni", "Gargoyle"
} -- ALL_UNDEAD_RACES (do not remove this comment)

ALL_POIS_RES_RACES = {
  "Djinni", "Gargoyle", "Mummy", "Naga", "Poltergeist", "Revenant",
} -- ALL_POIS_RES_RACES (do not remove this comment)

ALL_LITTLE_RACES = {
  "Spriggan",
} -- ALL_LITTLE_RACES (do not remove this comment)

ALL_SMALL_RACES = {
  "Kobold",
} -- ALL_SMALL_RACES (do not remove this comment)

ALL_LARGE_RACES = {
  "Armataur", "Naga", "Oni", "Troll",
} -- ALL_LARGE_RACES (do not remove this comment)


---- Skills ----
ALL_STAFF_SCHOOLS = {
  air = "Air Magic", alchemy = "Alchemy", cold = "Ice Magic", necromancy = "Necromancy",
  earth = "Earth Magic", fire = "Fire Magic",  conjuration = "Conjurations",
} -- ALL_STAFF_SCHOOLS (do not remove this comment)

ALL_TRAINING_SKILLS = {
  "Air Magic", "Alchemy", "Armour", "Axes", "Conjurations", "Dodging",
  "Earth Magic", "Evocations", "Fighting", "Fire Magic", "Forgecraft", "Hexes",
  "Ice Magic", "Invocations", "Long Blades", "Maces & Flails", "Necromancy",
  "Polearms", "Ranged Weapons", "Shapeshifting", "Shields", "Short Blades", "Spellcasting",
  "Staves", "Stealth", "Summonings", "Translocations", "Unarmed Combat", "Throwing",
} -- ALL_TRAINING_SKILLS (do not remove this comment)

ALL_WEAP_SCHOOLS = {
  "axes", "maces & flails", "polearms", "long blades",
  "short blades", "staves", "unarmed combat", "ranged weapons",
} -- ALL_WEAP_SCHOOLS (do not remove this comment)


---- Other ----
ALL_PORTAL_NAMES = {
  "Bailey", "Bazaar", "Desolation", "Gauntlet", "Ice Cave", "Necropolis",
  "Ossuary", "Sewer", "Trove", "Volcano", "Wizlab", "Zig",
} -- ALL_PORTAL_NAMES (do not remove this comment)

ALL_HELL_BRANCHES = {
  "Coc", "Dis", "Geh", "Hell", "Tar"
} -- ALL_HELL_BRANCHES (do not remove this comment)

-- Would prefer to use integer values, but they don't work in all menus
COLORS = {
  blue = "blue", green = "green", cyan = "cyan", red = "red", magenta = "magenta",
  brown = "brown", lightgrey = "lightgrey", darkgrey = "darkgrey", lightblue = "lightblue",
  lightgreen = "lightgreen", lightcyan = "lightcyan", lightred = "lightred",
  lightmagenta = "lightmagenta", yellow = "yellow", white = "w",
  black = "black",
} -- COLORS (do not remove this comment)

RISKY_EGOS = {
  "chaos", "distortion", "harm", "heavy", "infusion", "ponderous"
} -- RISKY_EGOS (do not remove this comment)

KEYS = {
  LF = string.char(10),
  CR = string.char(13),
  explore = crawl.get_command("CMD_EXPLORE") or "o",
  save_game = crawl.get_command("CMD_SAVE_GAME") or "S",
  go_upstairs = crawl.get_command("CMD_GO_UPSTAIRS") or "<",
  go_downstairs = crawl.get_command("CMD_GO_DOWNSTAIRS") or ">"
} -- KEYS (do not remove this comment)

MUTS = {
  antennae = "antennae", augmentation = "augmentation", beak = "beak", claws = "claws",
  deformed = "deformed body", demonic_touch = "demonic touch", hooves = "hooves",
  horns = "horns", missing_hand = "missing a hand", pseudopods = "pseudopods",
  sharp_scales = "sharp scales", sturdy_frame = "sturdy frame", talons = "talons"
} -- MUTS (do not remove this comment)

SIZE_PENALTY = {
  LITTLE = -2, SMALL = -1, NORMAL = 0, LARGE = 1, GIANT = 2
} -- SIZE_PENALTY (do not remove this comment)

DMG_TYPE = {
  unbranded = 1, -- No brand
  plain = 2, -- Include brand dmg with no associated damage type
  branded = 3, -- Include full brand dmg
  scoring = 4 -- Include boosts for non-damaging brands
} -- DMG_TYPE (do not remove this comment)

PLAIN_DMG_EGOS = { -- Cause extra damage without a damage type
  "distortion", "heavy", "spectralizing"
} -- PLAIN_DMG_EGOS (do not remove this comment)

}
############################ End lua/constants.lua ############################

############################ Begin lua/core/emojis.lua ############################
{
EMOJI = {}

function init_emojis()
  if CONFIG.debug_init then crawl.mpr("Initializing emojis") end

  if CONFIG.emojis then
    EMOJI.RARE_ITEM = "💎"
    EMOJI.ORB = "🔮"
    EMOJI.TALISMAN = "🧬"

    EMOJI.WEAPON = "⚔️"
    EMOJI.RANGED = "🏹"
    EMOJI.POLEARM = "🔱"
    EMOJI.TWO_HANDED = "✋🤚"
    EMOJI.CAUTION = "⚠️"

    EMOJI.STAFF_RESISTANCE = "🔥"

    EMOJI.ACCURACY = "🎯"
    EMOJI.STRONGER = "💪"
    EMOJI.STRONGEST = "💪💪"
    EMOJI.EGO = "✨"
    EMOJI.LIGHTER = "⏬"
    EMOJI.HEAVIER = "⏫"
    EMOJI.ARTEFACT = "💠"

    EMOJI.REMIND_IDENTIFY = "🎁"
    EMOJI.EXCLAMATION = "❗"
    EMOJI.EXCLAMATION_2 = "‼️"

    EMOJI.HP_FULL_PIP = "❤️"
    EMOJI.HP_PART_PIP = "❤️‍🩹"
    EMOJI.HP_EMPTY_PIP = "🤍"

    EMOJI.MP_FULL_PIP = "🟦"
    EMOJI.MP_PART_PIP = "🔹"
    EMOJI.MP_EMPTY_PIP = "➖"

    EMOJI.SUCCESS = "✅"

  else
    EMOJI.REMIND_IDENTIFY = with_color(COLORS.magenta, "?")
    EMOJI.EXCLAMATION = with_color(COLORS.magenta, "!")
    EMOJI.EXCLAMATION_2 = with_color(COLORS.lightmagenta, "!!")

    EMOJI.HP_BORDER = with_color(COLORS.white, "|")
    EMOJI.HP_FULL_PIP = with_color(COLORS.green, "+")
    EMOJI.HP_PART_PIP = with_color(COLORS.lightgrey, "+")
    EMOJI.HP_EMPTY_PIP = with_color(COLORS.darkgrey, "-")

    EMOJI.MP_BORDER = with_color(COLORS.white, "|")
    EMOJI.MP_FULL_PIP = with_color(COLORS.lightblue, "+")
    EMOJI.MP_PART_PIP = with_color(COLORS.lightgrey, "+")
    EMOJI.MP_EMPTY_PIP = with_color(COLORS.darkgrey, "-")
  end
end

}
############################ End lua/core/emojis.lua ############################

############################ Begin lua/core/persistent-data.lua ############################
{
-- Manages persistent data across games and saves --

local persistent_var_names
local persistent_table_names
local GET_VAL_STRING = {}
GET_VAL_STRING = {
  str = function(value)
      return "\"" .. value .. "\""
  end,
  int = function(value)
      return value
  end,
  bool = function(value)
      return value and "true" or "false"
  end,
  list = function(value)
      local tokens = {}
      for _,v in ipairs(value) do
          tokens[#tokens+1] = GET_VAL_STRING[get_var_type(v)](v)
      end
      return "{" .. table.concat(tokens, ", ") .. "}"
  end,
  dict = function(value)
      local tokens = {}
      for k,v in pairs(value) do
        tokens[#tokens+1] = string.format("[\"%s\"]=%s", k, GET_VAL_STRING[get_var_type(v)](v))
      end
      return "{" .. table.concat(tokens, ", ") .. "}"
  end
} -- GET_VAL_STRING (do not remove this comment)

-- Creates a persistent global variable or table, initialized to the default value
-- Once initialized, the variable is persisted across saves without re-init
function create_persistent_data(name, default_value)
  if _G[name] == nil then
      _G[name] = default_value
  end

  table.insert(chk_lua_save,
      function()
          local type = get_var_type(_G[name])
          if not GET_VAL_STRING[type] then
              crawl.mpr("Unknown persistence type: " .. type)
              return
          end
          return name .. " = " ..GET_VAL_STRING[type](_G[name]) .. KEYS.LF
      end)

  local var_type = get_var_type(_G[name])
  if var_type == "list" or var_type == "dict" then
    persistent_table_names[#persistent_table_names+1] = name
  else
    persistent_var_names[#persistent_var_names+1] = name
  end
end

function dump_persistent_data(char_dump)
  dump_text(serialize_persistent_data(), char_dump)
end

function serialize_persistent_data()
  local tokens = { "\n---PERSISTENT TABLES---\n" }
  for _,name in ipairs(persistent_table_names) do
    tokens[#tokens+1] = name
    tokens[#tokens+1] = ":\n"
    if get_var_type(_G[name]) == "list" then
      for _,item in ipairs(_G[name]) do
        tokens[#tokens+1] = "  "
        tokens[#tokens+1] = item
        tokens[#tokens+1] = "\n"
      end
    else
      for k,v in pairs(_G[name]) do
        tokens[#tokens+1] = "  "
        tokens[#tokens+1] = k
        tokens[#tokens+1] = " = "
        tokens[#tokens+1] = tostring(v)
        tokens[#tokens+1] = "\n"
      end
    end
  end

  tokens[#tokens+1] = "\n---PERSISTENT VARIABLES---\n"
  for _,name in ipairs(persistent_var_names) do
    tokens[#tokens+1] = name
    tokens[#tokens+1] = " = "
    tokens[#tokens+1] = tostring(_G[name])
    tokens[#tokens+1] = "\n"
  end

  return table.concat(tokens)
end

function get_var_type(value)
  local t = type(value)
  if t == "string" then return "str"
  elseif t == "number" then return "int"
  elseif t == "boolean" then return "bool"
  elseif t == "table" then
      if #value > 0 then return "list"
      else return "dict"
      end
  else
    return "unknown"
  end
end

function init_persistent_data(full_reset)
  if CONFIG.debug_init then crawl.mpr("Initializing persistent-data") end

  -- Clear persistent data (data is created via create_persistent_data)
  if full_reset then
    if persistent_var_names then
      for _,name in ipairs(persistent_var_names) do
        _G[name] = nil
      end
    end
  
    if persistent_table_names then
      for _,name in ipairs(persistent_table_names) do
        _G[name] = nil
      end
    end
  end

  persistent_var_names = {}
  persistent_table_names = {}
end

-- Verify 1. data is from same game, 2. all persistent data was reloaded
-- This should be called after all features have run init(), to declare their data
function verify_data_reinit()
  local failed_reinit = false
  local GAME_CHANGE_MONITORS = {
    buehler_rc_version = BUEHLER_RC_VERSION,
    buehler_name = you.name(),
    buehler_race = you.race(), -- this breaks RC parser without 'buehler_' prefix
    buehler_class = you.class(), -- this breaks RC parser without 'buehler_' prefix
    turn = you.turns() -- this doesn't break it, and relies on ready's `prev_turn` variable
  } -- GAME_CHANGE_MONITORS (do not remove this comment)

  -- Track values that shouldn't change, the turn, and a flag to confirm all data reloaded
  -- Default successful_data_reload to false, to confirm the data reload set it to true
  for k, v in pairs(GAME_CHANGE_MONITORS) do
    create_persistent_data("prev_" .. k, v)
  end
  create_persistent_data("successful_data_reload", false)

  if you.turns() > 0 then
    for k, v in pairs(GAME_CHANGE_MONITORS) do
      local prev = _G["prev_" .. k]
      if prev ~= v then
        failed_reinit = true
        local msg = string.format("Unexpected change to %s: %s -> %s", k, prev, v)
        crawl.mpr(with_color(COLORS.lightred, msg))
      end
    end

    if not successful_data_reload then
      failed_reinit = true
      local fail_message = string.format("Failed to load persistent data for buehler.rc v%s!", BUEHLER_RC_VERSION)
      crawl.mpr(with_color(COLORS.lightred, "\n" .. fail_message))
      crawl.mpr(with_color(COLORS.darkgrey, "Try restarting, or enable CONFIG.debug_init for more info."))
    end

    if failed_reinit and mpr_yesno(with_color(COLORS.yellow, "Deactivate buehler.rc?")) then return false end
  end

  for k, v in pairs(GAME_CHANGE_MONITORS) do
    _G["prev_" .. k] = v
  end
  successful_data_reload = true

  return true
end

}
############################ End lua/core/persistent-data.lua ############################

############################ Begin lua/util.lua ############################
{
local delayed_mpr_queue

function init_util()
  if CONFIG.debug_init then crawl.mpr("Initializing util") end

  delayed_mpr_queue = {}
end


---- Text Formatting ----
-- Removes tags from text, and optionally escapes special characters --
local CLEANUP_TEXT_CHARS = "([%^%$%(%)%%%.%[%]%*%+%-%?])"
function cleanup_text(text, escape_chars)
  -- Fast path: if no tags, just handle newlines and escaping
  if not text:find("<", 1, true) then
    local one_line = text:gsub("\n", "")
    if escape_chars then return one_line:gsub(CLEANUP_TEXT_CHARS, "%%%1") end
    return one_line
  end

  local tokens = {}
  local pos = 1
  local len = #text

  while pos <= len do
      local tag_start = text:find("<", pos, true)
      if not tag_start then
          -- No more tags, append remaining text
          tokens[#tokens+1] = text:sub(pos)
          break
      end

      -- Append text before tag
      if tag_start > pos then
          tokens[#tokens+1] = text:sub(pos, tag_start - 1)
      end

      -- Find end of tag
      local tag_end = text:find(">", tag_start, true)
      if not tag_end then
          -- Malformed tag, append remaining text
          tokens[#tokens+1] = text:sub(pos)
          break
      end

      pos = tag_end + 1
  end

  -- Join all parts and remove newlines
  local cleaned = table.concat(tokens):gsub("\n", "")

  -- Handle escaping if needed
  if escape_chars then
      return cleaned:gsub(CLEANUP_TEXT_CHARS, "%%%1")
  end

  return cleaned
end

function with_color(color, text)
  return string.format("<%s>%s</%s>", color, text, color)
end


--- Key modifiers ---
function control_key(c)
  return string.char(string.byte(c) - string.byte('a') + 1)
end


--- crawl.mpr enhancements ---
function mpr_yesno(text, capital_only)
  local suffix = capital_only and " (Y/n)" or " (y/n)"
  crawl.formatted_mpr(text .. suffix, "prompt")
  local res = crawl.getch()
  if string.char(res) == "Y" or string.char(res) == "y" and not capital_only then
    return true
  end
  crawl.mpr("Okay, then.")
  return false
end

-- Sends a message that is displayed at end of turn
function enqueue_mpr(text, channel)
  for _, msg in ipairs(delayed_mpr_queue) do
    if msg.text == text and msg.channel == channel then
      return
    end
  end
  delayed_mpr_queue[#delayed_mpr_queue+1] = { text = text, channel = channel, show_more = false }
end

function enqueue_mpr_opt_more(show_more, text, channel)
  for _, msg in ipairs(delayed_mpr_queue) do
    if msg.text == text and msg.channel == channel and msg.show_more == show_more then
      return
    end
  end
  delayed_mpr_queue[#delayed_mpr_queue+1] = { text = text, channel = channel, show_more = show_more }
end

function mpr_consume_queue()
  do_more = false
  for _, msg in ipairs(delayed_mpr_queue) do
    crawl.mpr(msg.text, msg.channel)
    if msg.show_more then do_more = true end
  end

  if do_more then
    you.stop_activity()
    crawl.redraw_screen()
    crawl.more()
    crawl.redraw_screen()
  end

  delayed_mpr_queue = {}
end

function mpr_opt_more(show_more, text, channel)
  if show_more then
    mpr_with_more(text, channel)
  else
    crawl.mpr(text, channel)
  end
end

function mpr_with_more(text, channel)
  crawl.mpr(text, channel)
  you.stop_activity()
  crawl.more()
  crawl.redraw_screen()
end

function mpr_with_stop(text, channel)
  crawl.mpr(text, channel)
  you.stop_activity()
end


--- Utility ---
function get_equipped_aux(aux_type)
  local all_aux = {}
  local num_slots = you.race() == "Poltergeist" and 6 or 1
  for i = 1, num_slots do
    local it = items.equipped_at(aux_type, i)
    all_aux[#all_aux+1] = it
  end
  return all_aux, num_slots
end

function get_mut(mutation, include_all)
  return you.get_base_mutation_level(mutation, true, include_all, include_all)
end

function get_skill_with_item(it)
  if is_magic_staff(it) then
    return math.max(get_skill(get_staff_school(it)), get_skill("Staves"))
  end
  if it.is_weapon then return get_skill(it.weap_skill) end
  if is_body_armour(it) then return get_skill("Armour") end
  if is_shield(it) then return get_skill("Shields") end
  if is_talisman(it) then return get_skill("Shapeshifting") end

  return 1 -- Fallback to 1
end

function get_staff_school(it)
  for k,v in pairs(ALL_STAFF_SCHOOLS) do
    if it.subtype() == k then return v end
	end
end

function get_talisman_min_level(it)
  local tokens = crawl.split(it.description, "\n")
  for _,v in ipairs(tokens) do
    if v:sub(1, 4) == "Min " then
      local start_pos = v:find("%d", 4)
      if start_pos then
        local end_pos = v:find("[^%d]", start_pos)
        return tonumber(v:sub(start_pos, end_pos - 1))
      end
    end
  end

  return 0 -- Fallback to 0, to surface any errors. Applies to Protean Talisman.
end

function has_risky_ego(it)
  local text = it.artefact and it.name() or get_ego(it)
  if not text then return false end
  for _, v in ipairs(RISKY_EGOS) do
    if text:find(v) then return true end
  end
  return false
end

function has_usable_ego(it)
  if not it.branded then return false end
  local ego = get_var_type(it.ego) == "str" and it.ego or it.ego(true)
  if ego == "holy" and util.contains(ALL_POIS_RES_RACES, you.race()) then return false end
  if ego == "rPois" and util.contains(ALL_POIS_RES_RACES, you.race()) then return false end
  return true
end

function have_shield()
  return is_shield(items.equipped_at("offhand"))
end

function have_weapon()
  return items.equipped_at("weapon") ~= nil
end

function have_zero_stat()
  return you.strength() <= 0 or you.dexterity() <= 0 or you.intelligence() <= 0
end

function in_hell()
  return util.contains(ALL_HELL_BRANCHES, you.branch())
end

function is_amulet(it)
  return it and it.name("base") == "amulet"
end

function is_armour(it, include_orbs)
  -- exclude orbs by default
  if not it or it.class(true) ~= "armour" then return false end
  if not include_orbs and is_orb(it) then return false end
  return true
end

function is_aux_armour(it)
  return is_armour(it) and not (is_body_armour(it) or is_shield(it))
end

function is_body_armour(it)
  return it and it.subtype() == "body"
end

function is_jewellery(it)
  return it and it.class(true) == "jewellery"
end

function is_magic_staff(it)
  return it and it.class and it.class(true) == "magical staff"
end

function is_miasma_immune()
  if util.contains(ALL_UNDEAD_RACES, you.race()) then return true end
  if util.contains(ALL_NONLIVING_RACES, you.race()) then return true end
  return false
end

function is_mutation_immune()
  return util.contains(ALL_UNDEAD_RACES, you.race())
end

function is_ring(it)
  return it and it.name("base") == "ring"
end

function is_scarf(it)
  return it and it.class(true) == "armour" and it.subtype() == "scarf"
end

function is_shield(it)
  return it and it.is_shield()
end

function is_talisman(it)
  if not it then return false end
  local c = it.class(true)
  return c and (c == "talisman" or c == "bauble")
end

function is_orb(it)
  return it and it.class(true) == "armour" and it.subtype() == "offhand" and not it.is_shield()
end

function is_polearm(it)
  return it and it.weap_skill:find("Polearms", 1, true)
end

function offhand_is_free()
  if get_mut(MUTS.missing_hand, true) > 0 then return true end
  return not items.equipped_at("offhand")
end

function next_to_slimy_wall()
  for x = -1, 1 do
    for y = -1, 1 do
      if view.feature_at(x, y) == "slimy_wall" then return true end
    end
  end
  return false
end


--- Debugging utils for in-game lua interpreter ---
function debug_dump(verbose, skip_char_dump)
  local char_dump = not skip_char_dump
  if dump_persistent_data then dump_persistent_data(char_dump) end
  if verbose then
    dump_inventory(char_dump)
    dump_text(WEAP_CACHE.serialize(), char_dump)
    dump_chk_lua_save(char_dump)
  end
end

function dump_chk_lua_save(char_dump)
  dump_text(serialize_chk_lua_save(), char_dump)
end

function dump_inventory(char_dump, include_item_info)
  dump_text(serialize_inventory(include_item_info), char_dump)
end

function dump_text(msg, char_dump)
  crawl.mpr(with_color("white", msg))

  if char_dump then
    crawl.take_note(msg)
    crawl.dump_char()
  end
end

function serialize_chk_lua_save()
  local tokens = { "\n---CHK_LUA_SAVE---" }
  for _, func in ipairs(chk_lua_save) do
    tokens[#tokens+1] = util.trim(func())
  end
  return table.concat(tokens, "\n")
end

function serialize_inventory(include_item_info)
  local tokens = { "\n---INVENTORY---\n" }
  for inv in iter.invent_iterator:new(items.inventory()) do
    tokens[#tokens+1] = string.format("%s: (%s) Qual: %s", inv.slot, inv.quantity, inv.name("qual"))
    if include_item_info then
      local base = inv.name("base") or "N/A"
      local cls = inv.class(true) or "N/A"
      local st = inv.subtype() or "N/A"
      tokens[#tokens+1] = string.format("    Base: %s Class: %s, Subtype: %s", base, cls, st)
    end
    tokens[#tokens+1] = "\n"
  end
  return table.concat(tokens, "")
end

}
############################ End lua/util.lua ############################

############################ Begin lua/features/announce-damage.lua ############################
{
----- Announce changes in HP/MP; modified from github.com/magus/dcss -----
local prev -- contains all previous hp/mp values

local function create_meter(perc, full, part, empty, border)
  local decade = math.floor(perc / 10)
  local full_count = math.floor(decade / 2)
  local part_count = decade % 2
  local empty_count = 5 - full_count - part_count

  local tokens = {}
  if border then tokens[1] = border end
  for i = 1, full_count do tokens[#tokens + 1] = full end
  for i = 1, part_count do tokens[#tokens + 1] = part end
  for i = 1, empty_count do tokens[#tokens + 1] = empty end
  if border then tokens[#tokens + 1] = border end
  return table.concat(tokens)
end

local function format_delta(delta)
  if delta > 0 then
    return with_color(COLORS.green, "+"..delta)
  elseif delta < 0 then
    return with_color(COLORS.lightred, delta)
  else
    return with_color(COLORS.darkgrey, "+0")
  end
end

local function format_ratio(cur, max)
  local color
  if cur <= (max * 0.25) then
    color = COLORS.red
  elseif cur <= (max * 0.50) then
    color = COLORS.lightred
  elseif cur <= (max *  0.75) then
    color = COLORS.yellow
  elseif cur < max then
    color = COLORS.lightgrey
  else
    color = COLORS.green
  end
  return with_color(color, string.format(" -> %s/%s", cur, max))
end



function init_announce_damage()
  if CONFIG.debug_init then crawl.mpr("Initializing announce-damage") end
  prev = {}
  prev.hp = 0
  prev.mhp = 0
  prev.mp = 0
  prev.mmp = 0
  prev.turn = you.turns()

  if CONFIG.dmg_fm_threshold > 0 and CONFIG.dmg_fm_threshold <= 0.5 then
    crawl.setopt("message_colour ^= mute:Ouch! That really hurt!")
  end
end

local function get_hp_message(hp_delta, mhp_delta)
  local hp, mhp = you.hp()

  local msg_tokens = {}
  msg_tokens[#msg_tokens + 1] = create_meter(
    hp / mhp * 100, EMOJI.HP_FULL_PIP, EMOJI.HP_PART_PIP, EMOJI.HP_EMPTY_PIP, EMOJI.HP_BORDER
  )
  msg_tokens[#msg_tokens + 1] = with_color(COLORS.white, string.format(" HP[%s]", format_delta(hp_delta)))
  msg_tokens[#msg_tokens + 1] = format_ratio(hp, mhp)
  if mhp_delta ~= 0 then
    msg_tokens[#msg_tokens + 1] = with_color(COLORS.lightgrey, string.format(" (%s max HP)", format_delta(mhp_delta)))
  end

  if not CONFIG.announce.same_line and hp == mhp then
    msg_tokens[#msg_tokens + 1] = with_color(COLORS.white, " (Full HP)")
  end
  return table.concat(msg_tokens)
end

local function get_mp_message(mp_delta, mmp_delta)
  local mp, mmp = you.mp()
  local msg_tokens = {}
  msg_tokens[#msg_tokens + 1] = create_meter(
    mp / mmp * 100, EMOJI.MP_FULL_PIP, EMOJI.MP_PART_PIP, EMOJI.MP_EMPTY_PIP, EMOJI.MP_BORDER
  )
  msg_tokens[#msg_tokens + 1] = with_color(COLORS.lightcyan, string.format(" MP[%s]", format_delta(mp_delta)))
  msg_tokens[#msg_tokens + 1] = format_ratio(mp, mmp)
  if mmp_delta ~= 0 then
    msg_tokens[#msg_tokens + 1] = with_color(COLORS.cyan, string.format(" (%s max MP)", format_delta(mmp_delta)))
  end
  if not CONFIG.announce.same_line and mp == mmp then
    msg_tokens[#msg_tokens + 1] = with_color(COLORS.lightcyan, " (Full MP)")
  end
  return table.concat(msg_tokens)
end

local METER_LENGTH = 7 + 2 * (EMOJI.HP_BORDER and #EMOJI.HP_BORDER or 0)
local function last_msg_is_meter()
  local last_msg = crawl.messages(1)
  local check = last_msg and #last_msg > METER_LENGTH+4 and last_msg:sub(METER_LENGTH+1,METER_LENGTH+4)
  return check and (check == " HP[" or check == " MP[")
end

------------------- Hooks -------------------
function ready_announce_damage()
  -- Process `prev` early, so we can use returns over nested ifs
  local hp, mhp = you.hp()
  local mp, mmp = you.mp()
  local is_startup = prev.hp == 0
  local hp_delta = hp - prev.hp
  local mp_delta = mp - prev.mp
  local mhp_delta = mhp - prev.mhp
  local mmp_delta = mmp - prev.mmp
  local damage_taken = mhp_delta - hp_delta
  prev.hp = hp
  prev.mhp = mhp
  prev.mp = mp
  prev.mmp = mmp

  if is_startup then return end
  if hp_delta == 0 and mp_delta == 0 and last_msg_is_meter() then return end
  local is_very_low_hp = hp <= CONFIG.announce.very_low_hp * mhp


  -- Determine which messages to show
  local do_hp = true
  local do_mp = true
  if hp_delta <= 0 and hp_delta > -CONFIG.announce.hp_loss_limit then do_hp = false end
  if hp_delta >= 0 and hp_delta <  CONFIG.announce.hp_gain_limit then do_hp = false end
  if mp_delta <= 0 and mp_delta > -CONFIG.announce.mp_loss_limit then do_mp = false end
  if mp_delta >= 0 and mp_delta <  CONFIG.announce.mp_gain_limit then do_mp = false end

  if not do_hp and is_very_low_hp and hp_delta ~= 0 then do_hp = true end
  if not do_hp and not do_mp then return end
  if CONFIG.announce.always_both then
    do_hp = true
    do_mp = true
  end
  
  -- Put messages together
  local hp_msg = get_hp_message(hp_delta, mhp_delta)
  local mp_msg = get_mp_message(mp_delta, mmp_delta)
  local msg_tokens = {}
  msg_tokens[1] = (CONFIG.announce.hp_first and do_hp) and hp_msg or mp_msg
  if do_mp and do_hp then
    msg_tokens[2] = CONFIG.announce.same_line and "       " or "\n"
    msg_tokens[3] = CONFIG.announce.hp_first and mp_msg or hp_msg
  end
  if #msg_tokens > 0 then enqueue_mpr(table.concat(msg_tokens)) end
  

  -- Add Damage-related warnings, when damage >= threshold
  if (damage_taken >= mhp * CONFIG.dmg_flash_threshold) then
    if is_very_low_hp then return end -- mute % HP alerts
    local summary_tokens = {}
    local is_force_more_msg = damage_taken >= (mhp * CONFIG.dmg_fm_threshold)
    if is_force_more_msg then
      summary_tokens[#summary_tokens + 1] = EMOJI.EXCLAMATION_2
      summary_tokens[#summary_tokens + 1] = with_color(COLORS.lightmagenta, " MASSIVE DAMAGE ")
      summary_tokens[#summary_tokens + 1] = EMOJI.EXCLAMATION_2
    else
      summary_tokens[#summary_tokens + 1] = EMOJI.EXCLAMATION
      summary_tokens[#summary_tokens + 1] = with_color(COLORS.magenta, " BIG DAMAGE ")
      summary_tokens[#summary_tokens + 1] = EMOJI.EXCLAMATION
    end
    enqueue_mpr_opt_more(is_force_more_msg, table.concat(summary_tokens))
  end
end

}
############################ End lua/features/announce-damage.lua ############################

############################ Begin lua/features/color-inscribe.lua ############################
{
-- Colorize inscriptions --
-- Long inscriptions can break certain menus. In-game inscriptions seem limited to 78 chars.
-- If INSCRIPTION_MAX_LENGTH is exceeded, ending tags are removed. A final tag is added to resume writing in lightgrey.

local MULTI_PLUS = "%++"
local MULTI_MINUS = "%-+"
local NEG_NUM = "%-%d+%.?%d*"
local POS_NUM = "%+%d+%.?%d*"
local COLORIZE_TAGS = {
  { "rF" .. MULTI_PLUS, COLORS.lightred },
  { "rF" .. MULTI_MINUS, COLORS.red },
  { "rC" .. MULTI_PLUS, COLORS.lightblue },
  { "rC" .. MULTI_MINUS, COLORS.blue },
  { "rN" .. MULTI_PLUS, COLORS.lightmagenta },
  { "rN" .. MULTI_MINUS, COLORS.magenta },
  { "rPois", COLORS.lightgreen },
  { "rElec", COLORS.lightcyan },
  { "rCorr", COLORS.yellow },
  { "rMut", COLORS.brown },
  { "sInv", COLORS.white },
  { "MRegen" .. MULTI_PLUS, COLORS.cyan },
  { "Regen" .. MULTI_PLUS, COLORS.green },
  { "Stlth" .. MULTI_PLUS, COLORS.white },
  { "Will" .. MULTI_PLUS, COLORS.brown },
  { "Will" .. MULTI_MINUS, COLORS.darkgrey },
  { "Wiz" .. MULTI_PLUS, COLORS.white },
  { "Wiz" .. MULTI_MINUS, COLORS.darkgrey },
  { "Slay" .. POS_NUM, COLORS.white},
  { "Slay" .. NEG_NUM, COLORS.darkgrey },
  {  "Str" .. POS_NUM, COLORS.white },
  {  "Str" .. NEG_NUM, COLORS.darkgrey },
  {  "Dex" .. POS_NUM, COLORS.white },
  {  "Dex" .. NEG_NUM, COLORS.darkgrey },
  {  "Int" .. POS_NUM, COLORS.white },
  {  "Int" .. NEG_NUM, COLORS.darkgrey },
  {   "AC" .. POS_NUM, COLORS.white },
  {   "AC" .. NEG_NUM, COLORS.darkgrey },
  {   "EV" .. POS_NUM, COLORS.white },
  {   "EV" .. NEG_NUM, COLORS.darkgrey },
  {   "SH" .. POS_NUM, COLORS.white },
  {   "SH" .. NEG_NUM, COLORS.darkgrey },
  {   "HP" .. POS_NUM, COLORS.white },
  {   "HP" .. NEG_NUM, COLORS.darkgrey },
  {   "MP" .. POS_NUM, COLORS.white },
  {   "MP" .. NEG_NUM, COLORS.darkgrey },
} --COLORIZE_TAGS (do not remove this comment)


local function colorize_subtext(text, s, tag)
  local idx = text:find(s)
  if not idx then return text end
  if idx > 1 then
    -- Avoid '!r' or an existing color tag
    local prev = text:sub(idx-1, idx-1)
    if prev == "!" or prev == ">" then return text end
  end

  local retval = text:gsub("(" .. s .. ")", "<" .. tag .. ">%1</" .. tag .. ">")
  return retval
end


------------------- Hooks -------------------
function c_assign_invletter_color_inscribe(it)
  if not CONFIG.colorize_inscriptions then return end
  if it.artefact then return end
  -- If enabled, call out to inscribe stats before coloring
  if do_stat_inscription then do_stat_inscription(it) end

  local text = it.inscription
  for _, tag in ipairs(COLORIZE_TAGS) do
    text = colorize_subtext(text, tag[1], tag[2])
  end

  it.inscribe(text, false)
end

-- To colorize more, need a way to:
  -- intercept messages before they're displayed (or delete and re-insert)
  -- insert tags that affect menus
  -- colorize artefact text
-- function c_message_color_inscribe(text, _)
--   local orig_text = text
--   text = colorize_subtext(text)
--   if text == orig_text then return end

--   local cleaned = cleanup_text(text)
--   if cleaned:sub(2, 4) == " - " then
--     text = " " .. text
--   end

--   crawl.mpr(text)
-- end

}
############################ End lua/features/color-inscribe.lua ############################

############################ Begin lua/drop-inferior.lua ############################
{
------- Auto-tag inferior items and add to drop list -----
local DROP_KEY = "~~DROP_ME"

local function inscribe_drop(it)
  local new_inscr = it.inscription:gsub(DROP_KEY, "") .. DROP_KEY
  it.inscribe(new_inscr, false)
  if CONFIG.msg_on_inscribe then
    msg = "(You can drop " .. it.slot .. " - " ..it.name() .. ")"
    crawl.mpr(with_color(COLORS.cyan, msg))
  end
end


function init_drop_inferior()
  if not CONFIG.drop_inferior then return end
  if CONFIG.debug_init then crawl.mpr("Initializing drop-inferior") end
  crawl.setopt("drop_filter += " .. DROP_KEY)
end


------------------ Hooks ------------------
function c_assign_invletter_drop_inferior(it)
  if not CONFIG.drop_inferior then return end
  -- Remove any previous DROP_KEY inscriptions
  it.inscribe(it.inscription:gsub(DROP_KEY, ""), false)

  if not (it.is_weapon or is_armour(it)) then return end
  if has_risky_ego(it) then return end

  for inv in iter.invent_iterator:new(items.inventory()) do
    if not inv.artefact and inv.subtype() == it.subtype() and
      (not has_ego(inv) or get_ego(inv) == get_ego(it)) then
        if it.is_weapon then
          if you.race() == "Coglin" then return end -- More trouble than it's worth
          if inv.plus <= it.plus then inscribe_drop(inv) end
        else
          if get_armour_ac(inv) <= get_armour_ac(it) and inv.encumbrance >= it.encumbrance then
            if you.race() == "Poltergeist" then return end -- More trouble than it's worth 
            inscribe_drop(inv)
          end
        end
    end
  end
end

}
############################ End lua/drop-inferior.lua ############################

############################ Begin lua/features/fm-disable.lua ############################
{
local FM_DISABLES = {
  "need to enable at least one skill for training",
  "Okawaru grants you throwing weapons",
  "Okawaru offers you a choice",
  "You can now deal lightning-fast blows",
  "The lock glows eerily",
  "Heavy smoke blows from the lock",
  "The gate opens wide",
  "With a soft hiss the gate opens wide",
} -- FM_DISABLES (do not remove this comment)

function c_message_fm_disable(text, _)
  if not CONFIG.fm_disable then return end
  for _,v in ipairs(FM_DISABLES) do
    if text:find(v) then
      crawl.enable_more(false)
      return
    end
  end

  crawl.enable_more(true)
end

}
############################ End lua/features/fm-disable.lua ############################

############################ Begin lua/inscribe-stats.lua ############################
{
----- Inscribe stats on items -----
-- Weapon inscriptions rely on get_weapon_info_string() from pa-util.lua
local NUM_PATTERN = "[%+%-:]%d+%.%d*"

local function inscribe_armour_stats(it)
  -- Will add to the beginning of inscriptions, or replace it's own values
  -- This gsub's stats individually to avoid overwriting <color> tags
  -- NUM_PATTERN searches for numbers w/ decimal, to avoid artefact inscriptions
  local abbr = is_shield(it) and "SH" or "AC"
  local primary, ev = get_armour_info_strings(it)

  local new_insc
  if it.inscription:find(abbr .. NUM_PATTERN) then
    new_insc = it.inscription:gsub(abbr .. NUM_PATTERN, primary)
    if ev and ev ~= "" then
      new_insc = new_insc:gsub("EV" .. NUM_PATTERN, ev)
    end
  else
    new_insc = primary
    if ev and ev ~= "" then
      new_insc = new_insc .. ", " .. ev
    end
    if it.inscription and it.inscription ~= "" then
      new_insc = new_insc .. "; " .. it.inscription
    end
  end

  it.inscribe(new_insc, false)
end

local function inscribe_weapon_stats(it)
  local orig_inscr = it.inscription
  local dps_inscr = get_weapon_info_string(it, CONFIG.inscribe_dps_type)
  local prefix, suffix = "", ""

  local idx = orig_inscr:find("DPS:", 1, true)
  if idx then
    if idx > 1 then prefix = orig_inscr:sub(1, idx-1) .. "; " end
    if idx + #dps_inscr - 1 < #orig_inscr then
      suffix = orig_inscr:sub(idx + #dps_inscr, #orig_inscr)
    end
  elseif #orig_inscr > 0 then
    suffix = "; " .. orig_inscr
  end

  it.inscribe(table.concat({ prefix, dps_inscr, suffix }), false)
end

function do_stat_inscription(it)
  if CONFIG.inscribe_weapons and it.is_weapon then
    inscribe_weapon_stats(it)
  elseif CONFIG.inscribe_armour and is_armour(it) and not is_scarf(it) then
    inscribe_armour_stats(it)
  end
end

------------------ Hooks ------------------
function ready_inscribe_stats()
  for inv in iter.invent_iterator:new(items.inventory()) do
    do_stat_inscription(inv)
  end
end

}
############################ End lua/inscribe-stats.lua ############################

############################ Begin lua/misc-alerts.lua ############################
{
local REMOVE_FAITH_MSG = "6 star piety! Maybe ditch that amulet soon."
local below_hp_threshold
local prev_available_spell_levels = 0


local function alert_low_hp()
  local hp, mhp = you.hp()
  if below_hp_threshold then
    below_hp_threshold = hp ~= mhp
  elseif hp <= CONFIG.alert_low_hp_threshold * mhp then
    below_hp_threshold = true
    local low_hp_msg = "Dropped below " .. (100*CONFIG.alert_low_hp_threshold) .. "% HP"
    enqueue_mpr_opt_more(true, table.concat({
      EMOJI.EXCLAMATION, " ", with_color(COLORS.magenta, low_hp_msg), " ", EMOJI.EXCLAMATION
    }))
  end
end

local function alert_remove_faith()
  if not alerted_max_piety and you.piety_rank() == 6 then
    local am = items.equipped_at("amulet")
    if am and am.subtype() == "amulet of faith" and not am.artefact then
      if you.god() == "Uskayaw" then return end
      mpr_with_more(with_color(COLORS.lightcyan, REMOVE_FAITH_MSG))
      alerted_max_piety = true
    end
  end
end

local function alert_spell_level_changes()
  local new_spell_levels = you.spell_levels()
  if new_spell_levels > prev_available_spell_levels then
    local delta = new_spell_levels - prev_available_spell_levels
    local msg = "Gained " .. delta .. " spell level" .. (delta > 1 and "s" or "")
    local avail = " (" .. new_spell_levels .. " available)"
    crawl.mpr(with_color(COLORS.lightcyan, msg) .. with_color(COLORS.cyan, avail))
  elseif new_spell_levels < prev_available_spell_levels then
    crawl.mpr(with_color(COLORS.magenta, new_spell_levels .. " spell levels remaining"))
  end


  prev_available_spell_levels = new_spell_levels
end

function init_misc_alerts()
  if CONFIG.debug_init then crawl.mpr("Initializing misc-alerts") end

  prev_available_spell_levels = you.spell_levels()
  below_hp_threshold = false
  create_persistent_data("alerted_max_piety", false)
end


------------------ Hooks ------------------
function ready_misc_alerts()
  if CONFIG.alert_remove_faith then alert_remove_faith() end
  if CONFIG.alert_low_hp_threshold > 0 then alert_low_hp() end
  if CONFIG.alert_spell_level_changes then alert_spell_level_changes() end
end

}
############################ End lua/misc-alerts.lua ############################

############################ Begin lua/remind-id.lua ############################
{
---- Remind to identify items when you have scroll of ID + unidentified item ----
---- Before finding scroll of ID, stops on increases to largest stack size ----
local do_remind_id_check

local function alert_remind_identify()
  crawl.mpr(
    EMOJI.REMIND_IDENTIFY ..
    with_color(COLORS.magenta, " You have something to identify. ") ..
    EMOJI.REMIND_IDENTIFY
  )
end

local function get_max_stack_size(class, skip_slot)
  local max_stack_size = 0
  for inv in iter.invent_iterator:new(items.inventory()) do
    if inv.quantity > max_stack_size and inv.class(true) == class and inv.slot ~= skip_slot and not inv.is_identified then
      max_stack_size = inv.quantity
    end
  end
  return max_stack_size
end

local function have_scroll_of_id()
  for inv in iter.invent_iterator:new(items.inventory()) do
    if inv.name("qual") == "scroll of identify" then
      return true
    end
  end
  return false
end

local function have_unid_item()
  for inv in iter.invent_iterator:new(items.inventory()) do
    if not inv.is_identified then
      return true
    end
  end
  return false
end

function init_remind_id()
  if CONFIG.debug_init then crawl.mpr("Initializing remind-id") end

  do_remind_id_check = true
  create_persistent_data("found_scroll_of_id", false)
end

------------------- Hooks -------------------
function c_assign_invletter_remind_identify(it)
  if not it.is_identified then
    if have_scroll_of_id() then
      you.stop_activity()
      do_remind_id_check = true
      return
    end
  elseif it.name("qual") == "scroll of identify" then
    if have_unid_item() then
      you.stop_activity()
      do_remind_id_check = true
      return
    end
  end
end

function c_message_remind_identify(text, channel)
  if channel ~= "plain" then return end

  if text:find("scrolls? of identify") then
    found_scroll_of_id = true
    if not text:find("ou drop ", 1, true) and have_unid_item() then
      you.stop_activity()
      do_remind_id_check = true
    end
  elseif not found_scroll_of_id then
    -- Pre-ID: Stop when largest stack of pots/scrolls increases
    local idx = text:find(" %- ")
    if not idx then return end

    local slot = items.letter_to_index(text:sub(idx - 1, idx - 1))
    local it = items.inslot(slot)

    if it.is_identified then return end
    -- Picking up known items still returns identified == false
    -- Doing some hacky checks below instead

    local it_class = it.class(true)
    if it_class == "scroll" then
      if it.quantity > math.max(CONFIG.stop_on_scrolls_count-1, get_max_stack_size("scroll", slot)) then
        you.stop_activity()
      end
    elseif it_class == "potion" then
      if it.quantity > math.max(CONFIG.stop_on_pots_count-1, get_max_stack_size("potion", slot)) then
        you.stop_activity()
      end
    end
  end
end

function ready_remind_identify()
  if do_remind_id_check then
    do_remind_id_check = false
    if have_unid_item() and have_scroll_of_id() then
      alert_remind_identify()
      you.stop_activity()
    end
  end
end

}
############################ End lua/remind-id.lua ############################

############################ Begin lua/features/startup.lua ############################
{
function init_startup()
  if CONFIG.debug_init then crawl.mpr("Initializing startup") end

  if you.turns() == 0 then
    ---- Skill menu on startup (by rwbarton, edits by buehler) ----
    if CONFIG.show_skills_on_startup then
      local show_skills_on_startup = (you.race() ~= "Gnoll")
      if show_skills_on_startup then
        crawl.sendkeys("!d10" .. string.char(13) .. "Lair D11-12 Orc D13-15 S-Runes V1-4" .. string.char(13))
        you.set_training_target("Maces & Flails",12)
        you.set_training_target("Axes",16)
        you.set_training_target("Polearms",14)
        you.set_training_target("Staves",12)
        you.set_training_target("Unarmed Combat",26)
        you.set_training_target("Throwing",9)
        you.set_training_target("Short Blades",14)
        you.set_training_target("Long Blades",12)
        you.set_training_target("Ranged Weapons",18)
        you.set_training_target("Armour",9)
        you.set_training_target("Dodging",4)
        you.set_training_target("Shields",9)
        you.set_training_target("Stealth",3.5)
        you.set_training_target("Spellcasting",26)
        you.set_training_target("Conjurations",26)
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
        crawl.sendkeys("m")
        crawl.sendkeys("C")
        crawl.sendkeys("c")
        crawl.sendkeys("a")
      end
    end
  
    ---- Auto-set default skill targets ----
    if CONFIG.auto_set_skill_targets then
      for _, skill_target in ipairs(CONFIG.auto_set_skill_targets) do
        local skill, target = unpack(skill_target)
        if you.skill(skill) < target then
          for _, s in ipairs(ALL_TRAINING_SKILLS) do
            you.train_skill (s, 0)
          end
          you.set_training_target (skill, target)
          you.train_skill (skill, 2)
          break
        end
      end
    end
  end
end

}
############################ End lua/features/startup.lua ############################

############################ Begin lua/pickup-alert/pa-main.lua ############################
{
local loaded_pa_armour, loaded_pa_misc, loaded_pa_weapons
pause_pa_system = nil

function has_configured_force_more(it)
  if it.artefact then
    if CONFIG.fm_alert.artefact then return true end
    if CONFIG.fm_alert.trained_artefacts and get_skill_with_item(it) > 0 then return true end
  end
  if CONFIG.fm_alert.armour_ego and is_armour(it) and has_ego(it) then return true end
  return false
end

function init_pa_main()
  pause_pa_system = false
  init_pa_data()

  if CONFIG.debug_init then crawl.mpr("Initializing pa-main") end

  loaded_pa_misc = pa_alert_orb and true or false
  if pa_alert_armour then
    loaded_pa_armour = true
    init_pa_armour()
  end
  if pa_alert_weapon then
    loaded_pa_weapons = true
    init_pa_weapons()
  end
  
  if CONFIG.debug_init then
    if loaded_pa_armour then crawl.mpr("pa-armour loaded") end
    if loaded_pa_misc then crawl.mpr("pa-misc loaded") end
    if loaded_pa_weapons then crawl.mpr("pa-weapons loaded") end
  end

  -- Check for duplicate autopickup creation (affects local only)
  create_persistent_data("num_autopickup_funcs", #chk_force_autopickup + 1)
  if num_autopickup_funcs < #chk_force_autopickup then
    crawl.mpr("Warning: Duplicate autopickup funcs loaded. (Commonly from reloading a local game.)")
    crawl.mpr("Expected: " .. num_autopickup_funcs .. " but got: " .. #chk_force_autopickup)
    crawl.mpr("Will skip reloading buehler autopickup. Reload the game to fix crawl's memory usage.")
    return
  end

  ---- Autopickup main ----
  add_autopickup_func(function (it, _)
    if pause_pa_system then return end
    if you.have_orb() then return end
    if has_ego(it) and not it.is_identified then return false end
    if not it.is_useless then
      if loaded_pa_armour and CONFIG.pickup.armour and is_armour(it) then
        if pa_pickup_armour(it) then return true end
      elseif loaded_pa_misc and CONFIG.pickup.staves and is_magic_staff(it) then
        if pa_pickup_staff(it) then return true end
      elseif loaded_pa_weapons and CONFIG.pickup.weapons and it.is_weapon then
        if pa_pickup_weapon(it) then return true end
      elseif loaded_pa_misc and is_unneeded_ring(it) then
        return false
      end
    else
      -- Useless item; allow alerts for aux armour if you're carrying one (implies a temporary mutation)
      if is_aux_armour(it) then return end
      
      local unworn_aux_item = nil
      local st = it.subtype()
      for inv in iter.invent_iterator:new(items.inventory()) do
        local inv_st = inv.subtype()
        if inv_st and inv_st == st then
          unworn_aux_item = inv
          break
        end
      end
      if not unworn_aux_item then return end
    end

    -- Not picking up this item. Now check for alerts.
    if not CONFIG.alert.system_enabled or already_contains(pa_items_alerted, it) then return end

    if loaded_pa_misc and CONFIG.alert.one_time and #CONFIG.alert.one_time > 0 then
      if pa_alert_OTA(it) then return end
    end

    if loaded_pa_misc and CONFIG.alert.staff_resists and is_magic_staff(it) then
      if pa_alert_staff(it) then return end
    elseif loaded_pa_misc and CONFIG.alert.orbs and is_orb(it) then
      if pa_alert_orb(it) then return end
    elseif loaded_pa_misc and CONFIG.alert.talismans and is_talisman(it) then
      if pa_alert_talisman(it) then return end
    elseif loaded_pa_armour and CONFIG.alert.armour and is_armour(it) then
      if pa_alert_armour(it, unworn_aux_item) then return end
    else
      if loaded_pa_weapons and CONFIG.alert.weapons and it.is_weapon then
        if pa_alert_weapon(it) then return end
      end
    end
  end)
end

function pa_alert_item(it, alert_type, emoji, force_more)
  local item_desc = get_plussed_name(it, "plain")
  local alert_colors
  if it.is_weapon then
    alert_colors = ALERT_COLORS.weapon
    update_high_scores(it)
    item_desc = item_desc .. with_color(ALERT_COLORS.weapon.stats, " (" .. get_weapon_info_string(it) .. ")")
  elseif is_body_armour(it) then
    alert_colors = ALERT_COLORS.body_arm
    update_high_scores(it)
    local ac, ev = get_armour_info_strings(it)
    item_desc = item_desc .. with_color(ALERT_COLORS.body_arm.stats, " {" .. ac .. ", " .. ev .. "}")
  elseif is_armour(it) then
    alert_colors = ALERT_COLORS.aux_arm
  elseif is_orb(it) then
    alert_colors = ALERT_COLORS.orb
  elseif is_talisman(it) then
    alert_colors = ALERT_COLORS.talisman
  else 
    alert_colors = ALERT_COLORS.misc
  end
  local tokens = {}
  tokens[1] = emoji and emoji or with_color(COLORS.cyan, "----")
  tokens[#tokens+1] = with_color(alert_colors.desc, " " .. alert_type .. ": ")
  tokens[#tokens+1] = with_color(alert_colors.item, item_desc .. " ")
  tokens[#tokens+1] = tokens[1]

  enqueue_mpr_opt_more(force_more or has_configured_force_more(it), table.concat(tokens))

  pa_recent_alerts[#pa_recent_alerts+1] = get_plussed_name(it)
  add_to_pa_table(pa_items_alerted, it)
  you.stop_activity()
  return true
end

------------------- Hooks -------------------
function c_assign_invletter_item_alerts(it)
  pa_alert_OTA(it)

  util.remove(pa_recent_alerts, get_plussed_name(it))  
  if it.is_weapon and you.race() == "Coglin" then
    -- Allow 1 more alert for an identical weapon, if dual-wielding possible.
    -- ie, Reset the alert the first time you pick up.
    local name, _ = get_pa_keys(it)
    if pa_items_picked[name] == nil then pa_items_alerted[name] = nil end
  end

  add_to_pa_table(pa_items_picked, it)

  if it.is_weapon or is_armour(it) then
    update_high_scores(it)
    you.stop_activity() -- crawl misses this sometimes
  end
end

function c_message_item_alerts(text, channel)
  if channel == "multiturn" then
    if not pause_pa_system and text:find("ou start ", 1, true) then
      pause_pa_system = true
    end
  elseif channel == "plain" then
    if pause_pa_system and (text:find("ou stop ", 1, true) or text:find("ou finish ", 1, true)) then
      pause_pa_system = false
    elseif text:find("one exploring", 1, true) or text:find("artly explored", 1, true) then
      local tokens = {}
      for _,v in ipairs(pa_recent_alerts) do
        tokens[#tokens+1] = "\n  " .. v
      end
      if #tokens > 0 then
        enqueue_mpr(with_color(COLORS.magenta, "Recent alerts:" .. table.concat(tokens)))
      end
      pa_recent_alerts = {}
    end
  end
end

function ready_item_alerts()
  if pause_pa_system then return end
  ready_pa_weapons()
  update_high_scores(items.equipped_at("armour"))
end

}
############################ End lua/pickup-alert/pa-main.lua ############################

############################ Begin lua/pickup-alert/pa-data.lua ############################
{
---- Helpers for using persistent tables in pickup-alert system----
function add_to_pa_table(table_ref, it)
  if it.is_weapon or is_armour(it, true) or is_talisman(it) then
    local name, value = get_pa_keys(it)
    local cur_val = tonumber(table_ref[name])
    if not cur_val or value > cur_val then
      table_ref[name] = value
    end
  end
end

function already_contains(table_ref, it)
  local name, value = get_pa_keys(it)
  return table_ref[name] ~= nil and tonumber(table_ref[name]) >= value
end

function init_pa_data()
  if CONFIG.debug_init then crawl.mpr("Initializing pa-data") end

  create_persistent_data("pa_OTA_items", CONFIG.alert.one_time)
  create_persistent_data("pa_recent_alerts", {})
  create_persistent_data("pa_items_picked", {})
  create_persistent_data("pa_items_alerted", {})
  create_persistent_data("alerted_first_ranged", false)
  create_persistent_data("alerted_first_ranged_1h", false)
  create_persistent_data("alerted_first_polearm", false)
  create_persistent_data("alerted_first_polearm_1h", false)
  create_persistent_data("ac_high_score", 0)
  create_persistent_data("weapon_high_score", 0)
  create_persistent_data("plain_dmg_high_score", 0)

  -- Update alerts & tables for starting items
  for inv in iter.invent_iterator:new(items.inventory()) do
    remove_from_OTA(inv)
    add_to_pa_table(pa_items_picked, inv)

    if inv.is_weapon then
      if is_polearm(inv) then
        alerted_first_polearm = true
        if get_hands(inv) == 1 then
          alerted_first_polearm_1h = true
        end
      elseif inv.is_ranged then
        alerted_first_ranged = true
        if get_hands(inv) == 1 then
          alerted_first_ranged_1h = true
        end
      end
    end
  end
end

function get_OTA_index(it)
  local qualname = it.name("qual")
  for i,v in ipairs(pa_OTA_items) do
    if v ~= "" and qualname:find(v) then return i end
  end
  return -1
end

function remove_from_OTA(it)
  local found = false
  local idx
  repeat
    idx = get_OTA_index(it)
    if idx ~= -1 then
      util.remove(pa_OTA_items, pa_OTA_items[idx])
      found = true
    end
  until idx == -1

  return found
end

--- Set all single high scores ---
-- Returns a string if item is a new high score, else nil
function update_high_scores(it)
  if not it then return end
  local ret_val = nil

  if is_armour(it) then
    local ac = get_armour_ac(it)
    if ac > ac_high_score then
      ac_high_score = ac
      if not ret_val then ret_val = "Highest AC" end
    end
  elseif it.is_weapon then
    -- Don't alert for unusable weapons
    if get_hands(it) == 2 and not offhand_is_free() then return end

    local dmg = get_weap_damage(it, DMG_TYPE.branded)
    if dmg > weapon_high_score then
      weapon_high_score = dmg
      if not ret_val then ret_val = "Highest damage" end
    end

    dmg = get_weap_damage(it, DMG_TYPE.plain)
    if dmg > plain_dmg_high_score then
      plain_dmg_high_score = dmg
      if not ret_val then ret_val = "Highest plain damage" end
    end
  end

  return ret_val
end

}
############################ End lua/pickup-alert/pa-data.lua ############################

############################ Begin lua/pickup-alert/pa-util.lua ############################
{
---- Utility functions specific to pickup-alert system ----
-- Functions often duplicate dcss calculations and need to be updated when those change
-- Many functions are specific to buehler.rc, and not necessarily applicable to all RCs

--------- Stat string formatting ---------
local function format_stat(abbr, val, is_worn)
  local stat_str = string.format("%.1f", val)
  if val < 0 then
    return abbr .. stat_str
  elseif is_worn then
    return abbr .. ':' .. stat_str
  else
    return abbr .. '+' .. stat_str
  end
end

function get_armour_info_strings(it)
  if not is_armour(it) then return "", "" end

  -- Compare against last slot if poltergeist
  local slot_num = you.race() == "Poltergeist" and 6 or 1
  local cur = items.equipped_at(it.equip_type, slot_num)
  local cur_ac = 0
  local cur_sh = 0
  local cur_ev = 0
  local is_worn = it.equipped or (it.ininventory and cur and cur.slot == it.slot)
  if cur and not is_worn then
    -- Only show deltas if not same item
    if is_shield(cur) then
      cur_sh = get_shield_sh(cur)
      cur_ev = -get_shield_penalty(cur)
    else
      cur_ac = get_armour_ac(cur)
      cur_ev = get_armour_ev(cur)
    end
  end

  if is_shield(it) then
    local sh_str = format_stat("SH", get_shield_sh(it) - cur_sh, is_worn)
    local ev_str = format_stat("EV", -get_shield_penalty(it) - cur_ev, is_worn)
    return sh_str, ev_str
  else
    local ac_str = format_stat("AC", get_armour_ac(it) - cur_ac, is_worn)
    if not is_body_armour(it) then return ac_str end
    local ev_str = format_stat("EV", get_armour_ev(it) - cur_ev, is_worn)
    return ac_str, ev_str
  end
end

function get_weapon_info_string(it, dmg_type)
  if not it.is_weapon then return end
  local dmg = get_weap_damage(it, dmg_type or CONFIG.inscribe_dps_type or DMG_TYPE.plain)
  local dmg_str = string.format("%.1f", dmg)
  if dmg < 10 then dmg_str = string.format("%.2f", dmg) end
  if dmg > 99.9 then dmg_str = ">100" end

  local delay = get_weap_delay(it)
  local delay_str = string.format("%.1f", delay)
  if delay < 1 then
    delay_str = string.format("%.2f", delay)
    delay_str = delay_str:sub(2, #delay_str)
  end

  local dps = dmg / delay
  local dps_str = string.format("%.1f", dps)
  if dps < 10 then dps_str = string.format("%.2f", dps) end
  if dps > 99.9 then dps_str = ">100" end

  local it_plus = it.plus or 0
  local acc = it.accuracy + it_plus
  if acc >= 0 then acc = "+" .. acc end

  --This would be nice if it worked in all UIs
  --dps_str = "DPS:<w>" .. dps_str .. "</w> "
  --return dps_str .. "(<red>" .. dmg_str .. "</red>/<blue>" .. delay_str .. "</blue>), Acc<w>" .. acc .. "</w>"
  return table.concat({ "DPS:", dps_str, " (", dmg_str, "/", delay_str, "), Acc", acc })
end


--------- Functions for armour and weapons ---------
function get_ego(it)
  if has_usable_ego(it) then return it.ego(true) end
  if is_body_armour(it) then
    local qualname = it.name("qual")
    if qualname:find("dragon scales") or qualname:find("troll leather", 1, true) then return qualname end
  end
end

-- Used for data tables
function get_pa_keys(it, name_type)
  if it.class(true) == "bauble" then
    return it.name("qual"):gsub("\"", ""), 0
  elseif is_talisman(it) or is_orb(it) then
    return it.name():gsub("\"", ""), 0
  elseif is_magic_staff(it) then
    return it.name("base"):gsub("\"", ""), 0
  else
    local name = it.name(name_type or "base"):gsub("\"", "")
    local value = tonumber(name:sub(1, 3))
    if not value then return name, 0 end
    return util.trim(name:sub(4)), value
  end
end

function get_plussed_name(it, name_type)
  local name, value = get_pa_keys(it, name_type)
  if is_talisman(it) or is_orb(it) or is_magic_staff(it) then return name end
  if value >= 0 then value = "+" .. value end
  return value .. " " .. name
end

-- Custom def of ego/branded
function has_ego(it, exclude_stat_only_egos)
  if not it then return false end
  if it.is_weapon then
    if exclude_stat_only_egos then
      local ego = get_ego(it)
      if ego and (ego == "speed" or ego == "heavy") then return false end
    end
    return it.artefact or has_usable_ego(it) or is_magic_staff(it)
  end

  if it.artefact or has_usable_ego(it) then return true end
  local basename = it.name("base")
  if basename:find("troll leather", 1, true) then return true end
  if basename:find("dragon scales", 1, true) and not basename:find("steam", 1, true) then return true end
  return false
end

--------- Armour (Shadowing crawl calcs) ---------
function get_unadjusted_armour_pen(encumb)
  -- dcss v0.33.1
  local pen = encumb - 2 * get_mut(MUTS.sturdy_frame, true)
  if pen > 0 then return pen end
  return 0
end

function get_adjusted_armour_pen(encumb, str)
  -- dcss v0.33.1
  local base_pen = get_unadjusted_armour_pen(encumb)
  return 2 * base_pen * base_pen * (45 - you.skill("Armour")) / 45 / (5 * (str + 3))
end

function get_adjusted_dodge_bonus(encumb, str, dex)
  -- dcss v0.33.1
  local size_factor = -2 * get_size_penalty()
  local dodge_bonus = 8*(10 + you.skill("Dodging") * dex) / (20 - size_factor) / 10
  local armour_dodge_penalty = get_unadjusted_armour_pen(encumb) - 3
  if armour_dodge_penalty <= 0 then return dodge_bonus end

  if armour_dodge_penalty >= str then
    return dodge_bonus * str / (armour_dodge_penalty * 2)
  end
  return dodge_bonus - dodge_bonus * armour_dodge_penalty / (str * 2)
end

function get_armour_ac(it)
  -- dcss v0.33.1
  local it_plus = it.plus or 0

  if it.artefact and it.is_identified then
    local art_ac = it.artprops["AC"]
    if art_ac then it_plus = it_plus + art_ac end
  end

  local ac = it.ac * (1 + you.skill("Armour") / 22) + it_plus
  if not is_body_armour(it) then return ac end

  local deformed = get_mut(MUTS.deformed, true) > 0
  local pseudopods = get_mut(MUTS.pseudopods, true) > 0
  if pseudopods or deformed then
    return ac * 6/10
  end

  return ac
end

function get_armour_ev(it)
  -- dcss v0.33.1
  -- This function computes the armour-based component to standard EV (not paralysed, etc)
  -- Factors in stat changes from this armour and removing current one
  local str = you.strength()
  local dex = you.dexterity()
  local no_art_str = str
  local no_art_dex = dex
  local art_ev = 0

  -- Adjust str/dex/EV for artefact stat changes
  local worn = items.equipped_at("armour")
  if worn and worn.artefact then
    if worn.artprops["Str"] then str = str - worn.artprops["Str"] end
    if worn.artprops["Dex"] then dex = dex - worn.artprops["Dex"] end
    if worn.artprops["EV"] then art_ev = art_ev - worn.artprops["EV"] end
  end

  if it.artefact then
    if it.artprops["Str"] then str = str + it.artprops["Str"] end
    if it.artprops["Dex"] then dex = dex + it.artprops["Dex"] end
    if it.artprops["EV"] then art_ev = art_ev + it.artprops["EV"] end
  end

  if str <= 0 then str = 1 end

  local dodge_bonus = get_adjusted_dodge_bonus(it.encumbrance, str, dex)
  local naked_dodge_bonus = get_adjusted_dodge_bonus(0, no_art_str, no_art_dex)
  return (dodge_bonus - naked_dodge_bonus) + art_ev - get_adjusted_armour_pen(it.encumbrance, str)
end

function get_shield_penalty(sh)
  -- dcss v0.33.1
  return 2 * sh.encumbrance * sh.encumbrance
        * (27 - you.skill("Shields")) / 27
        / (25 + 5 * you.strength())
end

function get_shield_sh(it)
  -- dcss v0.33.1
  local dex = you.dexterity()
  if it.artefact and it.is_identified then
    local art_dex = it.artprops["Dex"]
    if art_dex then dex = dex + art_dex end
  end

  local cur = items.equipped_at("offhand")
  if is_shield(cur) and cur.artefact and cur.slot ~= it.slot then
    local art_dex = cur.artprops["Dex"]
    if art_dex then dex = dex - art_dex end
  end

  local it_plus = it.plus or 0

  local base_sh = it.ac * 2
  local shield = base_sh * (50 + you.skill("Shields")*5/2)
  shield = shield + 200 * it_plus
  shield = shield + 38 * (you.skill("Shields") + 3 + dex * (base_sh + 13) / 26)
  return shield / 200
end

function get_size_penalty()
  if util.contains(ALL_LITTLE_RACES, you.race()) then return SIZE_PENALTY.LITTLE
  elseif util.contains(ALL_SMALL_RACES, you.race()) then return SIZE_PENALTY.SMALL
  elseif util.contains(ALL_LARGE_RACES, you.race()) then return SIZE_PENALTY.LARGE
  end
  return SIZE_PENALTY.NORMAL
end

--------- Weapon stats (Shadowing crawl calcs) ---------
function adjust_delay_for_ego(delay, ego)
  if not ego then return delay end
  if ego == "speed" then return delay * 2 / 3
  elseif ego == "heavy" then return delay * 1.5
  end
  return delay
end

function get_weap_delay(it)
  -- dcss v0.33.1
  local delay = it.delay - get_skill(it.weap_skill)/2
  delay = math.max(delay, get_weap_min_delay(it))
  delay = adjust_delay_for_ego(delay, get_ego(it))
  delay = math.max(delay, 3)

  local sh = items.equipped_at("offhand")
  if is_shield(sh) then delay = delay + get_shield_penalty(sh) end

  if it.is_ranged then
    local worn = items.equipped_at("armour")
    if worn then
      local str = you.strength()

      local cur = items.equipped_at("weapon")
      if cur and cur ~= it and cur.artefact then
        if it.artefact and it.artprops["Str"] then
          str = str + it.artprops["Str"]
        end
        if cur.artefact and cur.artprops["Str"] then
          str = str - cur.artprops["Str"]
        end
      end

      delay = delay + get_adjusted_armour_pen(worn.encumbrance, str)
    end
  end

  return delay / 10
end

function get_weap_min_delay(it)
  -- dcss v0.33.1
  -- This is an abbreviated version of the actual calculation.
  -- Skips brand and >=3 checks, which are covered in get_weap_delay()
  if it.artefact and it.name("qual"):find("woodcutter's axe", 1, true) then return it.delay end

  local min_delay = math.floor(it.delay / 2)
  if it.weap_skill == "Short Blades" then return 5 end
  if it.is_ranged then
    local basename = it.name("base")
    local is_2h_ranged = basename:find("crossbow", 1, true) or basename:find("arbalest", 1, true)
    if is_2h_ranged then return math.max(min_delay, 10) end
  end

  return math.min(min_delay, 7)
end

function get_weap_dps(it, dmg_type)
  if not dmg_type then dmg_type = DMG_TYPE.scoring end
  return get_weap_damage(it, dmg_type) / get_weap_delay(it)
end

function get_weap_damage(it, dmg_type)
  -- Returns an adjusted weapon damage = damage * speed
  -- Includes stat/slay changes between weapon and the one currently wielded
  -- Aux attacks not included
  if not dmg_type then dmg_type = DMG_TYPE.scoring end
  local it_plus = it.plus or 0
  -- Adjust str/dex/slay from artefacts
  local str = you.strength()
  local dex = you.dexterity()

  -- Adjust str/dex/EV for artefact stat changes
  if not it.equipped then
    local wielded = items.equipped_at("weapon")
    if wielded and wielded.artefact then
      if wielded.artprops["Str"] then str = str - wielded.artprops["Str"] end
      if wielded.artprops["Dex"] then dex = dex - wielded.artprops["Dex"] end
      if wielded.artprops["Slay"] then it_plus = it_plus - wielded.artprops["Slay"] end
    end

    if it.artefact and it.is_identified then
      if it.artprops["Str"] then str = str + it.artprops["Str"] end
      if it.artprops["Dex"] then dex = dex + it.artprops["Dex"] end
      if it.artprops["Slay"] then it_plus = it_plus + it.artprops["Slay"] end
    end
  end

  local stat = str
  if it.is_ranged or it.weap_skill:find("Blades", 1, true) then stat = dex end

  local stat_mod = 0.75 + 0.025 * stat
  local skill_mod = (1 + get_skill(it.weap_skill)/25/2) * (1 + you.skill("Fighting")/30/2)

  it_plus = it_plus + get_slay_bonuses()

  local pre_brand_dmg_no_plus = it.damage * stat_mod * skill_mod
  local pre_brand_dmg = pre_brand_dmg_no_plus + it_plus

  if is_magic_staff(it) then
    return (pre_brand_dmg + get_staff_bonus_dmg(it, dmg_type))
  end

  if dmg_type == DMG_TYPE.plain then
    local ego = get_ego(it)
    if ego and util.contains(PLAIN_DMG_EGOS, ego) then
      local brand_bonus = WEAPON_BRAND_BONUSES[ego] or WEAPON_BRAND_BONUSES.subtle[ego]
      return brand_bonus.factor * pre_brand_dmg_no_plus + it_plus + brand_bonus.offset
    end
  elseif dmg_type >= DMG_TYPE.branded then
    local ego = get_ego(it)
    if ego then
      local brand_bonus = WEAPON_BRAND_BONUSES[ego]
      if not brand_bonus and dmg_type == DMG_TYPE.scoring then
        brand_bonus = WEAPON_BRAND_BONUSES.subtle[ego]
      end
      if brand_bonus then
        return brand_bonus.factor * pre_brand_dmg_no_plus + it_plus + brand_bonus.offset
      end
    end
  end

  return pre_brand_dmg
end

function get_weap_score(it, no_brand_bonus)
  if it.dps and it.acc then
    -- Handle cached /  high-score tuples in WEAP_CACHE
    return it.dps + it.acc * TUNING.weap.pickup.accuracy_weight
  end
  local it_plus = it.plus or 0
  local dmg_type = no_brand_bonus and DMG_TYPE.unbranded or DMG_TYPE.scoring
  return get_weap_dps(it, dmg_type) + (it.accuracy + it_plus) * TUNING.weap.pickup.accuracy_weight
end


--------- Weap stat helpers ---------
function get_hands(it)
  if you.race() ~= "Formicid" then return it.hands end
  local st = it.subtype()
  if st == "giant club" or st == "giant spiked club" then return 2 end
  return 1
end

-- Get skill level, or average for artefacts w/ multiple skills
function get_skill(skill)
  if not skill:find(",", 1, true) then
    return you.skill(skill)
  end

  local skills = crawl.split(skill, ",")
  local sum = 0
  local count = 0
  for _, s in ipairs(skills) do
    sum = sum + you.skill(s)
    count = count + 1
  end
  return sum/count
end

-- Count all slay bonuses from weapons/armour/jewellery
function get_slay_bonuses()
  local sum = 0

  -- Slots can go as high as 18 afaict
  for i = 0,20 do
    local it = items.equipped_at(i)
    if it then
      if is_ring(it) then
        if it.artefact then
          local name = it.name()
          local idx = name:find("Slay", 1, true)
          if idx then
            local slay = tonumber(name:sub(idx+5, idx+5))
            if slay == 1 then
              local next_digit = tonumber(name:sub(idx+6, idx+6))
              if next_digit then slay = 10 + next_digit end
            end

            if name:sub(idx+4, idx+4) == "+" then sum = sum + slay
            else sum = sum - slay end
          end
        elseif get_ego(it) == "Slay" then
          sum = sum + it.plus
        end
      elseif it.artefact and (is_armour(it, true) or is_amulet(it)) then
          local slay = it.artprops["Slay"]
          if slay then sum = sum + slay end
      end
    end
  end

  if you.race() == "Demonspawn" then
    sum = sum + 3 * get_mut(MUTS.augmentation, true)
    sum = sum + get_mut(MUTS.sharp_scales, true)
  end

  return sum
end

function get_staff_bonus_dmg(it, dmg_type)
  -- dcss v0.33.1
  if dmg_type == DMG_TYPE.unbranded then return 0 end
  if dmg_type == DMG_TYPE.plain then
    local basename = it.name("base")
    if basename ~= "staff of earth" and basename ~= "staff of conjuration" then
      return 0
    end
  end

  local spell_skill = get_skill(get_staff_school(it))
  local evo_skill = you.skill("Evocations")

  local chance = (2*evo_skill + spell_skill) / 30
  if chance > 1 then chance = 1 end
  -- 0.75 is an acceptable approximation; most commonly 63/80
  -- Varies by staff type in sometimes complex ways
  local avg_dmg = 3/4 * (evo_skill/2 + spell_skill)
  return avg_dmg*chance
end

}
############################ End lua/pickup-alert/pa-util.lua ############################

############################ Begin lua/pickup-alert/pa-armour.lua ############################
{
---- Pickup and Alert features for armour ----
ARMOUR_ALERT = {}

function init_pa_armour()
  ARMOUR_ALERT = {
    artefact = { msg = "Artefact armour", emoji = EMOJI.ARTEFACT },
    gain_ego = { msg = "Gain ego", emoji = EMOJI.EGO },
    diff_ego = { msg = "Diff ego", emoji = EMOJI.EGO },

    lighter = {
      gain_ego = { msg = "Gain ego (Lighter armour)", emoji = EMOJI.EGO },
      diff_ego = { msg = "Diff ego (Lighter armour)", emoji = EMOJI.EGO },
      same_ego = { msg = "Lighter armour", emoji = EMOJI.LIGHTER },
      lost_ego = { msg = "Lighter armour (Lost ego)", emoji = EMOJI.LIGHTER }
    },
    heavier = {
      gain_ego = { msg = "Gain ego (Heavier armour)", emoji = EMOJI.EGO },
      diff_ego = { msg = "Diff ego (Heavier armour)", emoji = EMOJI.EGO },
      same_ego = { msg = "Heavier Armour", emoji = EMOJI.HEAVIER },
      lost_ego = { msg = "Heavier Armour (Lost ego)", emoji = EMOJI.HEAVIER }
    } -- ARMOUR_ALERT.heavier (do not remove this comment)
  } -- ARMOUR_ALERT (do not remove this comment)
end

local SAME = "same_ego"
local LOST = "lost_ego"
local GAIN = "gain_ego"
local DIFF = "diff_ego"

local is_new_ego = function(ego_change_type)
  return ego_change_type == GAIN or ego_change_type == DIFF
end

local function send_armour_alert(it, alert_type)
  return pa_alert_item(it, alert_type.msg, alert_type.emoji, CONFIG.fm_alert.body_armour)
end

-- If training armour in early/mid game, alert user to any armour that is the strongest found so far
local function alert_ac_high_score(it)
  if not is_body_armour(it) then return false end
  if you.skill("Armour") == 0 then return false end
  if you.xl() > 12 then return false end

  if ac_high_score == 0 then
    local worn = items.equipped_at("armour")
    if not worn then return false end
    ac_high_score = get_armour_ac(worn)
  else
    local itAC = get_armour_ac(it)
    if itAC > ac_high_score then
      ac_high_score = itAC
      return pa_alert_item(it, "Highest AC", EMOJI.STRONGEST, CONFIG.fm_alert.high_score_armour)
    end
  end

  return false
end


-- Alerts armour items that didn't autopickup, but are worth consideration
-- The function assumes pickup occurred; so it doesn't alert things like pure upgrades
-- Takes `unworn_inv_item`, which is an unworn aux armour item in inventory
function pa_alert_armour(it, unworn_inv_item)
  if is_body_armour(it) then
    if it.artefact then
      return it.is_identified and send_armour_alert(it, ARMOUR_ALERT.artefact)
    end
  
    local cur = items.equipped_at("armour")
    if not cur then return false end

    local encumb_delta = it.encumbrance - cur.encumbrance
    local ac_delta = get_armour_ac(it) - get_armour_ac(cur)
    local ev_delta = get_armour_ev(it) - get_armour_ev(cur)

    local it_ego = get_ego(it)
    local cur_ego = get_ego(cur)
    local ego_change_type
    if it_ego == cur_ego then ego_change_type = SAME
    elseif not it_ego then ego_change_type = LOST
    elseif not cur_ego then ego_change_type = GAIN
    else ego_change_type = DIFF
    end

    if encumb_delta == 0 then
      if is_new_ego(ego_change_type) then
        return send_armour_alert(it, ARMOUR_ALERT[ego_change_type])
      end
    elseif encumb_delta < 0 then
      if is_new_ego(ego_change_type) then
        if math.abs(ac_delta + ev_delta) <= TUNING.armour.lighter.ignore_small then
          return send_armour_alert(it, ARMOUR_ALERT.lighter[ego_change_type])
        end
      end

      if (ac_delta > 0) or (ev_delta / -ac_delta > TUNING.armour.lighter[ego_change_type]) then
        -- Alert for AC/EV changes as configured
        if ego_change_type == LOST and ev_delta < TUNING.armour.lighter.min_gain then return false end
        if ego_change_type ~= SAME and -ac_delta > TUNING.armour.lighter.max_loss then return false end
        return send_armour_alert(it, ARMOUR_ALERT.lighter[ego_change_type])
      end
    else -- Heavier armour
      if is_new_ego(ego_change_type) then
        if math.abs(ac_delta + ev_delta) <= TUNING.armour.heavier.ignore_small then
          return send_armour_alert(it, ARMOUR_ALERT.heavier[ego_change_type])
        end 
      end

      local encumb_skills = you.skill("Spellcasting") + you.skill("Ranged Weapons") - you.skill("Armour") / 2
      if encumb_skills < 0 then encumb_skills = 0 end
      local encumb_impact = math.min(1, encumb_skills / you.xl())
      local total_loss = TUNING.armour.encumb_penalty_weight * encumb_impact * encumb_delta - ev_delta
      if (total_loss < 0) or (ac_delta / total_loss > TUNING.armour.heavier[ego_change_type]) then
        -- Alert for AC/EV changes as configured
        if ego_change_type == LOST and ac_delta < TUNING.armour.heavier.min_gain then return false end
        if ego_change_type ~= SAME and total_loss > TUNING.armour.heavier.max_loss then return false end
        return send_armour_alert(it, ARMOUR_ALERT.heavier[ego_change_type])
      end
    end

    if alert_ac_high_score(it) then return true end
    if has_ego(it) and you.xl() <= TUNING.armour.early_xl then
      return pa_alert_item(it, "Early armour", EMOJI.EGO)
    end
  elseif is_shield(it) then
    if it.artefact then
      return it.is_identified and pa_alert_item(it, "Artefact shield", EMOJI.ARTEFACT, CONFIG.fm_alert.shields)
    end
  
    local sh = items.equipped_at("offhand")
    if not is_shield(sh) then return false end
    if is_new_ego(ego_change_type) then
      local alert_msg = ego_change_type == DIFF and "Diff ego" or "Gain ego"
      return pa_alert_item(it, alert_msg, EMOJI.EGO, CONFIG.fm_alert.shields)
    elseif get_shield_sh(it) > get_shield_sh(sh) then
      return pa_alert_item(it, "Higher SH", EMOJI.STRONGER, CONFIG.fm_alert.shields)
    end
  else
    -- Aux armour
    if it.artefact then
      return it.is_identified and pa_alert_item(it, "Artefact aux armour", EMOJI.ARTEFACT, CONFIG.fm_alert.aux_armour)
    end
  
    local all_equipped, num_slots = get_equipped_aux(it.subtype())
    if #all_equipped < num_slots then
      if unworn_inv_item then
        all_equipped[#all_equipped+1] = unworn_inv_item
      else
        -- Fires on dangerous brands or items blocked by non-innate mutations
        return pa_alert_item(it, "Aux armour", EMOJI.EXCLAMATION, CONFIG.fm_alert.aux_armour)
      end
    end

    for _, cur in ipairs(all_equipped) do
      if is_new_ego(ego_change_type) then
        local alert_msg = ego_change_type == DIFF and "Diff ego" or "Gain ego"
        return pa_alert_item(it, alert_msg, EMOJI.EGO, CONFIG.fm_alert.aux_armour)
      elseif get_armour_ac(it) > get_armour_ac(cur) then
        return pa_alert_item(it, "Higher AC", EMOJI.STRONGER, CONFIG.fm_alert.aux_armour)
      end
    end
  end
end

-- Equipment autopickup (by Medar, gammafunk, buehler, and various others)
function pa_pickup_armour(it)
  if has_risky_ego(it) then return false end

  if is_body_armour(it) then
    -- Pick up AC upgrades, and new egos that don't lose AC
    local cur = items.equipped_at("armour")
    if not cur then return false end
    if it.encumbrance > cur.encumbrance then return false end
    if cur.artefact or it.artefact then return false end

    local ac_delta = get_armour_ac(it) - get_armour_ac(cur)
    if get_ego(it) == get_ego(cur) then
      return ac_delta > 0 or ac_delta == 0 and it.encumbrance < cur.encumbrance 
    elseif not has_ego(cur) then
      if has_ego(it) then return ac_delta >= 0 end
      return ac_delta > 0
    end
  elseif is_shield(it) then
    -- Pick up SH upgrades, artefacts, and added egos
    local cur = items.equipped_at("offhand")
    if not is_shield(cur) then return false end
    if cur.encumbrance ~= it.encumbrance then return false end

    if cur.artefact then return false end
    if it.artefact then return true end
    if has_ego(cur) then
      return get_ego(cur) == get_ego(it) and it.plus > cur.plus
    end
    return has_ego(it) or it.plus > cur.plus
  else
    -- Aux armour: Pickup artefacts, AC upgrades, and new egos
    if is_orb(it) then return false end
    local st = it.subtype()

    -- Skip boots/gloves/helmet if wearing Lear's hauberk
    local worn = items.equipped_at("armour")
    if worn and worn.name("qual") == "Lear's hauberk" and st ~= "cloak" then return false end

    -- No autopickup if mutation interference
    if st == "gloves" then
      -- Ignore demonic touch if you're using offhand
      if get_mut(MUTS.demonic_touch, true) >= 3 and not offhand_is_free() then return false end
      -- Ignore claws if you're wielding a weapon
      if get_mut(MUTS.claws, true) > 0 and not have_weapon() then return false end
    elseif st == "boots" then
      if get_mut(MUTS.hooves, true) + get_mut(MUTS.talons, true) > 0 then return false end
    elseif it.name("base"):find("helmet", 1, true) then
      if get_mut(MUTS.horns, true) + get_mut(MUTS.beak, true) + get_mut(MUTS.antennae, true) > 0 then return false end
    end

    local all_equipped, num_slots = get_equipped_aux(it.subtype())
    if num_slots == 1 and #all_equipped == 0 then
      -- For non-poltergeist, check if we're carrying one already; implying we have a temporary form
      for inv in iter.invent_iterator:new(items.inventory()) do
        if inv.subtype() == st then return false end
      end
    end
    if #all_equipped < num_slots then return true end    

    -- Already have something in slot; it must be glowing to pick up
    if not it.is_identified then return false end

    for i, cur in ipairs(all_equipped) do
      if not cur.artefact then break end
      if i == num_slots then return false end
    end

    if it.artefact then return true end

    for _, cur in ipairs(all_equipped) do
      if has_ego(cur) then
        if get_ego(cur) == get_ego(it) and it.plus > cur.plus then return true end
      elseif has_ego(it) then
        if get_armour_ac(it) >= get_armour_ac(cur) then return true end
      else
        if get_armour_ac(it) > get_armour_ac(cur) then return true end
      end
    end
  end

  return false
end

}
############################ End lua/pickup-alert/pa-armour.lua ############################

############################ Begin lua/pickup-alert/pa-misc.lua ############################
{
function pa_alert_orb(it)
  if not it.is_identified then return false end
  return pa_alert_item(it, "New orb", EMOJI.ORB, CONFIG.fm_alert.orbs)
end

function pa_alert_OTA(it)
  local index = get_OTA_index(it)
  if index == -1 then return end

  local do_alert = true

  if is_shield(it) then
    if you.skill("Shields") < CONFIG.alert.OTA_require_skill.shield then return end

    -- Don't alert if already wearing a larger shield
    if pa_OTA_items[index] == "buckler" then
      if have_shield() then do_alert = false end
    elseif pa_OTA_items[index] == "kite shield" then
      local sh = items.equipped_at("offhand")
      if sh and sh.name("qual") == "tower shield" then do_alert = false end
    end
  elseif is_armour(it) then
    if you.skill("Armour") < CONFIG.alert.OTA_require_skill.armour then return end
  elseif it.is_weapon then
    if you.skill(it.weap_skill) < CONFIG.alert.OTA_require_skill.weapon then return end
  end

  remove_from_OTA(it)
  if not do_alert then return false end
  return pa_alert_item(it, "Rare item", EMOJI.RARE_ITEM, CONFIG.fm_alert.one_time_alerts)
end

---- Alert for needed resists ----
function pa_alert_staff(it)
  if not it.is_identified then return false end
  local needRes = false
  local basename = it.name("base")

  if basename == "staff of fire" then needRes = you.res_fire() == 0
  elseif basename == "staff of cold" then needRes = you.res_cold() == 0
  elseif basename == "staff of air" then needRes = you.res_shock() == 0
  elseif basename == "staff of poison" then needRes = you.res_poison() == 0
  elseif basename == "staff of death" then needRes = you.res_draining() == 0
  end

  if not needRes then return false end
  return pa_alert_item(it, "Staff resistance", EMOJI.STAFF_RESISTANCE, CONFIG.fm_alert.staff_resists)
end

function pa_alert_talisman(it)
  if it.artefact then
    if not it.is_identified then return false end
    return pa_alert_item(it, "Artefact talisman", EMOJI.TALISMAN, CONFIG.fm_alert.talismans)
  end
  if get_talisman_min_level(it) > you.skill("Shapeshifting") + CONFIG.alert.talisman_lvl_diff then return false end
  return pa_alert_item(it, "New talisman", EMOJI.TALISMAN, CONFIG.fm_alert.talismans)
end

---- Smart staff pickup ----
function pa_pickup_staff(it)
  if not it.is_identified then return false end
  if get_skill(get_staff_school(it)) == 0 then return false end
  return not already_contains(pa_items_picked, it)
end

---- Exclude superfluous rings ----
function is_unneeded_ring(it)
  if not is_ring(it) or it.artefact or you.race() == "Octopode" then return false end
  local missing_hand = get_mut(MUTS.missing_hand, true)
  local st = it.subtype()
  local found_first = false
  for inv in iter.invent_iterator:new(items.inventory()) do
    if is_ring(inv) and inv.subtype() == st then
      if found_first or missing_hand then return true end
      found_first = true
    end
  end
  return false
end

}
############################# End lua/pickup-alert/pa-misc.lua ############################

############################ Begin lua/pickup-alert/pa-weapons.lua ############################
{
---- Cache weapons in inventory ----
WEAP_CACHE = {}
local top_attack_skill

function WEAP_CACHE.get_key(it)
  local ret_val = it.is_ranged and "range_" or "melee_"
  ret_val = ret_val .. get_hands(it)
  if has_ego(it) then ret_val = ret_val .. "b" end
  return ret_val
end

function WEAP_CACHE.add_weapon(it)
  local weap_data = {}
  weap_data.is_weapon = it.is_weapon
  weap_data.ego = get_ego(it)
  weap_data.branded = weap_data.ego ~= nil
  weap_data.plus = it.plus or 0
  weap_data.acc = it.accuracy + weap_data.plus
  weap_data.damage = it.damage
  weap_data.dps = get_weap_dps(it)
  weap_data.score = get_weap_score(it)
  weap_data.unbranded_score = get_weap_score(it, true)

  weap_data.basename = it.name("base")
  weap_data.subtype = it.subtype()
  weap_data.is_ranged = it.is_ranged
  weap_data.hands = get_hands(it)
  weap_data.artefact = it.artefact
  weap_data.weap_skill = it.weap_skill
  weap_data.skill_lvl = get_skill(it.weap_skill)
 
  -- Track unique egos
  if weap_data.branded and not util.contains(WEAP_CACHE.egos, weap_data.ego) then
    WEAP_CACHE.egos[#WEAP_CACHE.egos+1] = weap_data.ego
  end

  -- Track max damage weapons of each type
  local keys = { WEAP_CACHE.get_key(it) }
  -- Also track less-restrictive versions of the key
  if weap_data.is_ranged then keys[#keys+1] = keys[1]:gsub("range", "melee") end
  if weap_data.branded then
    local len = #keys
    for i = 1, len do
      keys[len+i] = keys[i]:sub(1, -2)
    end
  end
  if weap_data.hands == 1 then
    local len = #keys
    for i = 1, len do
      keys[len+i] = keys[i]:gsub("1", "2")
    end
  end
  -- Update the max DPS for each category
  for _, key in ipairs(keys) do
    if weap_data.dps > WEAP_CACHE.max_dps[key].dps then
      WEAP_CACHE.max_dps[key].dps = weap_data.dps
      WEAP_CACHE.max_dps[key].acc = weap_data.acc
    end
  end

  WEAP_CACHE.weapons[#WEAP_CACHE.weapons+1] = weap_data
  return weap_data
end

function WEAP_CACHE.is_empty()
  return WEAP_CACHE.max_dps["melee_2"].dps == 0
end

function WEAP_CACHE.serialize()
  local tokens = { "\n---INVENTORY WEAPONS---" }
  for _, weap in ipairs(WEAP_CACHE.weapons) do
    tokens[#tokens+1] = string.format("\n%s\n", weap.basename)
    for k,v in pairs(weap) do
      if k ~= "basename" then
        tokens[#tokens+1] = string.format("  %s: %s\n", k, tostring(v))
      end
    end
  end
  return table.concat(tokens, "")
end

---- Weapon pickup ----
local function is_weapon_upgrade(it, cur)
  -- `cur` comes from WEAP_CACHE
  if it.subtype() == cur.subtype then
    -- Exact weapon type match
    if it.artefact then return true end
    if cur.artefact then return false end
    if has_ego(cur) and not has_ego(it) then return false end
    if has_ego(it) and it.is_identified and not has_ego(cur) then
      return get_weap_score(it) / cur.score > TUNING.weap.pickup.add_ego
    end
    return get_ego(it) == cur.ego and get_weap_score(it) > cur.score
  elseif it.weap_skill == cur.weap_skill or you.race() == "Gnoll" then
    -- Return false if no clear upgrade possible
    if get_hands(it) > cur.hands then return false end
    if cur.is_ranged ~= it.is_ranged then return false end
    if is_polearm(cur) ~= is_polearm(it) then return false end

    if it.artefact then return true end
    if cur.artefact then return false end
    
    local min_ratio = it.is_ranged and TUNING.weap.pickup.same_type_ranged or TUNING.weap.pickup.same_type_melee
    return get_weap_score(it) / cur.score > min_ratio
  end

  return false
end

function pa_pickup_weapon(it)
  -- Check if we need the first weapon of the game
  if you.xl() < 5 and WEAP_CACHE.is_empty() and you.skill("Unarmed Combat") + get_mut(MUTS.claws, true) == 0 then
    -- Staves don't go into WEAP_CACHE; check if we're carrying just a staff
    for inv in iter.invent_iterator:new(items.inventory()) do
      if inv.is_weapon then return false end -- fastest way to check if it's a staff
    end
    return true
  end

  if has_risky_ego(it) then return false end
  if already_contains(pa_items_picked, it) then return false end
  for _,inv in ipairs(WEAP_CACHE.weapons) do
    if is_weapon_upgrade(it, inv) then return true end
  end
end


---- Alert types ----
local function alert_first_ranged(it)
  if alerted_first_ranged_1h then return false end
  if not it.is_ranged then return false end

  if get_hands(it) == 1 then
    alerted_first_ranged = true
    alerted_first_ranged_1h = true
    return pa_alert_item(it, "First ranged weapon (1-handed)", EMOJI.RANGED, CONFIG.fm_alert.early_weap)
  else
    if alerted_first_ranged then return false end
    if have_shield() then return false end
    alerted_first_ranged = true
    return pa_alert_item(it, "First ranged weapon", EMOJI.RANGED, CONFIG.fm_alert.early_weap)
  end
end

local function alert_first_polearm(it)
  if alerted_first_polearm_1h then return false end
  if not is_polearm(it) then return false end
  if you.skill("Ranged Weapons") > 2 then return false end -- Don't bother if learning ranged

  if get_hands(it) == 1 then
    alerted_first_polearm = true
    alerted_first_polearm_1h = true
    return pa_alert_item(it, "First polearm (1-handed)", EMOJI.POLEARM, CONFIG.fm_alert.early_weap)
  else
    if alerted_first_polearm then return false end
    if have_shield() then return false end
    alerted_first_polearm = true
    return pa_alert_item(it, "First polearm", EMOJI.POLEARM, CONFIG.fm_alert.early_weap)
  end
end

local function alert_early_weapons(it)
  -- Alert really good usable ranged weapons
  if you.xl() <= TUNING.weap.alert.early_ranged.xl then
    if it.is_identified and it.is_ranged then
      if it.plus >= TUNING.weap.alert.early_ranged.min_plus and has_ego(it) or
         it.plus >= TUNING.weap.alert.early_ranged.branded_min_plus then
          if get_hands(it) == 1 or not have_shield() or
            you.skill("Shields") <= TUNING.weap.alert.early_ranged.max_shields then
              return pa_alert_item(it, "Ranged weapon", EMOJI.RANGED, CONFIG.fm_alert.early_weap)
          end
      end
    end
  end

  if you.xl() <= TUNING.weap.alert.early.xl then
    -- Skip items if we're clearly going another route
    local skill_diff = get_skill(top_attack_skill) - get_skill(it.weap_skill)
    local max_skill_diff = you.xl() * TUNING.weap.alert.early.skill.factor + TUNING.weap.alert.early.skill.offset
    if skill_diff > max_skill_diff then return false end

    if has_ego(it) or it.plus and it.plus >= TUNING.weap.alert.early.branded_min_plus then
      return pa_alert_item(it, "Early weapon", EMOJI.WEAPON, CONFIG.fm_alert.early_weap)
    end
  end

  return false
end

-- Check if weapon is worth alerting for, informed by a weapon currently in inventory
-- `cur` comes from WEAP_CACHE
local function alert_interesting_weapon(it, cur)
  if it.artefact and it.is_identified then
    return pa_alert_item(it, "Artefact weapon", EMOJI.ARTEFACT)
  end

  local inv_best = WEAP_CACHE.max_dps[WEAP_CACHE.get_key(it)]
  local best_dps = math.max(cur.dps, inv_best and inv_best.dps or 0)
  local best_score = math.max(cur.score, inv_best and get_weap_score(inv_best) or 0)

  if cur.subtype == it.subtype() then
    -- Exact weapon type match; alert new egos or higher DPS/weap_score
    if not cur.artefact and has_ego(it, true) and get_ego(it) ~= cur.ego then
      return pa_alert_item(it, "Diff ego", EMOJI.EGO, CONFIG.fm_alert.weap_ego)
    elseif get_weap_score(it) > best_score or get_weap_dps(it) > best_dps then
      return pa_alert_item(it, "Weapon upgrade", EMOJI.WEAPON, CONFIG.fm_alert.upgrade_weap)
    end
    return false
  end
  
  if cur.is_ranged ~= it.is_ranged then return false end
  if is_polearm(cur) ~= is_polearm(it) then return false end
  if 2 * get_skill(it.weap_skill) < get_skill(cur.weap_skill) then return false end
  
  -- Penalize lower-trained skills
  local damp = TUNING.weap.alert.low_skill_penalty_damping
  local penalty = (get_skill(it.weap_skill) + damp) / (get_skill(top_attack_skill) + damp)
  local score_ratio = penalty * get_weap_score(it) / best_score

  if get_hands(it) > cur.hands then
    if offhand_is_free() or (you.skill("Shields") < TUNING.weap.alert.add_hand.ignore_sh_lvl) then
      if has_ego(it) and not util.contains(WEAP_CACHE.egos, get_ego(it)) and score_ratio > TUNING.weap.alert.new_ego then
        return pa_alert_item(it, "New ego (2-handed)", EMOJI.EGO, CONFIG.fm_alert.weap_ego)
      elseif score_ratio > TUNING.weap.alert.add_hand.not_using then
        return pa_alert_item(it, "2-handed weapon", EMOJI.TWO_HANDED, CONFIG.fm_alert.upgrade_weap)
      end
    elseif has_ego(it) and not has_ego(cur) and score_ratio > TUNING.weap.alert.add_hand.add_ego_lose_sh then
      return pa_alert_item(it, "2-handed weapon (Gain ego)", EMOJI.TWO_HANDED, CONFIG.fm_alert.weap_ego)
    end
  else -- No extra hand required
    if cur.artefact then return false end
    if has_ego(it, true) then
      local it_ego = get_ego(it)
      if not has_ego(cur) then
        if score_ratio > TUNING.weap.alert.gain_ego then
          return pa_alert_item(it, "Gain ego", EMOJI.EGO, CONFIG.fm_alert.weap_ego)
        end
      elseif not util.contains(WEAP_CACHE.egos, it_ego) and score_ratio > TUNING.weap.alert.new_ego then
        return pa_alert_item(it, "New ego", EMOJI.EGO, CONFIG.fm_alert.weap_ego)
      end
    end
    if score_ratio > TUNING.weap.alert.pure_dps then
      return pa_alert_item(it, "Weapon upgrade", EMOJI.WEAPON, CONFIG.fm_alert.upgrade_weap)
    end
  end
  
  return false
end

local function alert_interesting_weapons(it)
  for _,inv in ipairs(WEAP_CACHE.weapons) do
    if alert_interesting_weapon(it, inv) then return true end
  end
  return false
end

local function alert_weap_high_scores(it)
  local category = update_high_scores(it)
  if not category then return false end
  return pa_alert_item(it, category, EMOJI.WEAPON, CONFIG.fm_alert.high_score_weap)
end

function pa_alert_weapon(it)
  if alert_interesting_weapons(it) then return true end
  if alert_first_ranged(it) then return true end
  if alert_first_polearm(it) then return true end
  if alert_early_weapons(it) then return true end

  -- Skip high score alerts if not using weapons
  if WEAP_CACHE.is_empty() then return false end
  return alert_weap_high_scores(it)
end


function init_pa_weapons()
  WEAP_CACHE.weapons = {}
  WEAP_CACHE.egos = {}
  
  -- Track max DPS by weapon category
  WEAP_CACHE.max_dps = {}
  local keys = {
    "melee_1", "melee_1b", "melee_2", "melee_2b",
    "range_1", "range_1b", "range_2", "range_2b"
  } -- WEAP_CACHE.max_dps (do not remove this comment)
  for _, key in ipairs(keys) do
    WEAP_CACHE.max_dps[key] = { dps = 0, acc = 0 }
  end

  -- Set top weapon skill
  top_attack_skill = "Unarmed Combat"
  local max_weap_skill = get_skill(top_attack_skill)
  for _,v in ipairs(ALL_WEAP_SCHOOLS) do
    if get_skill(v) > max_weap_skill then
      max_weap_skill = get_skill(v)
      top_attack_skill = v
    end
  end
end


-------- Hooks --------
function ready_pa_weapons()
  init_pa_weapons()
  for inv in iter.invent_iterator:new(items.inventory()) do
    if inv.is_weapon and not is_magic_staff(inv) then
      WEAP_CACHE.add_weapon(inv)
      update_high_scores(inv)
    end
  end
end

}
############################ End lua/pickup-alert/pa-weapons.lua ############################

############## Lua Hook Functions ##############
{
local buehler_rc_active

function c_assign_invletter(it)
  if not buehler_rc_active then return end
  -- Calls with no return values; just triggering on new item pickup
  if c_assign_invletter_item_alerts then c_assign_invletter_item_alerts(it) end
  if c_assign_invletter_remind_identify then c_assign_invletter_remind_identify(it) end
  if c_assign_invletter_drop_inferior then c_assign_invletter_drop_inferior(it) end
  if c_assign_invletter_color_inscribe then c_assign_invletter_color_inscribe(it) end

  -- Calls with possible return values
  local ret_val = nil
  if c_assign_invletter_weapon_slots then ret_val = c_assign_invletter_weapon_slots(it) end
  if ret_val then return ret_val end
end

function c_message(text, channel)
  if not buehler_rc_active then return end
  if c_message_remind_identify then c_message_remind_identify(text, channel) end
  if c_message_item_alerts then c_message_item_alerts(text, channel) end
  if c_message_fm_disable then c_message_fm_disable(text, channel) end
end

function c_answer_prompt(prompt)
  if not buehler_rc_active then return end
  if prompt:find("cheaper one?", 1, true) and you.branch() ~= "Bazaar" then
    crawl.mpr("Replacing shopping list items")
    return true end
  if prompt == "Die?" then
    return false
  end  
end

function ready()
  if not buehler_rc_active then return end
  crawl.redraw_screen()
  if you.turns() == prev_turn then return end

  prev_turn = you.turns() -- prev_turn is also used by persistent-data.lua

  -- Features (may not be included)
  if ready_inscribe_stats then ready_inscribe_stats() end

  -- Features with text
  if ready_remind_identify then ready_remind_identify() end
  if ready_announce_damage then ready_announce_damage() end
  if ready_item_alerts then ready_item_alerts() end
  if ready_misc_alerts then ready_misc_alerts() end

  -- Delayed messages
  mpr_consume_queue()
end

function init_buehler(reset_persistent_data)
  buehler_rc_active = false

  -- Init core modules
  init_config()
  init_emojis()
  init_util()
  init_persistent_data(reset_persistent_data)

  -- Init optional features
  if init_announce_damage then init_announce_damage() end
  if init_drop_inferior then init_drop_inferior() end
  if init_misc_alerts then init_misc_alerts() end
  if init_pa_main then init_pa_main() end
  if init_remind_id then init_remind_id() end
  if init_startup then init_startup() end

  if not verify_data_reinit() then
    crawl.mpr(with_color(COLORS.lightred, "Failed initialization. buehler.rc is inactive."))
    return
  else
    buehler_rc_active = true
    local success_emoji = CONFIG.emojis and EMOJI.SUCCESS or ""
    local success_text = string.format(" Successfully initialized buehler.rc v%s! ", prev_buehler_rc_version)
    crawl.mpr("\n" .. success_emoji .. with_color(COLORS.lightgreen, success_text) .. success_emoji)
  end

   -- Force a full ready() cycle
  prev_turn = you.turns() - 1
  ready()
end

-- This is the only line of top-level code, aside from declaring variables (without values)
-- Done to give confidence in simple re-inits
init_buehler(you.turns() == 0)
}
############## github.com/brianfaires/crawl-rc ##############

#######################
### Mini Map Colors ###
#######################
# tile_portal_col = #ff4f1a
# tile_downstairs_col = red
tile_downstairs_col = #ff1a1a
tile_branchstairs_col = yellow
# tile_branchstairs_col = #ff006a
tile_upstairs_col = green
# tile_upstairs_col = #99ff33
tile_explore_horizon_col = #bfbfbf
tile_floor_col = #262626
tile_water_col = #0086b3
tile_deep_water_col = #1f1fed
tile_lava_col = #6f0b00
tile_wall_col = #595959
tile_door_col = #cb7d4d
# tile_feature_col = #d4be21
tile_plant_col = #5c8745
tile_transporter_col = #ff80bf
tile_transporter_landing_col = #59ff89
tile_trap_col = #d24dff

###############
### Display ###
###############
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/defaults/menu_colours.txt
tile_font_crt_size = 21
tile_font_stat_size = 21
tile_font_msg_size = 21
tile_font_tip_size = 21
tile_font_lbl_size = 21
tile_font_ft_light = false
tile_cell_pixels = 38
tile_viewport_scale = 1.5
tile_font_crt_family = UD デジタル 教科書体 N-B
tile_font_stat_family = UD デジタル 教科書体 N-B
tile_font_msg_family = UD デジタル 教科書体 N-B
tile_font_lbl_family = UD デジタル 教科書体 N-B
tile_realtime_anim = true

: if you.race() ~= "Felid" then
tile_show_player_species = true
: end

tile_player_status_icons = slow, constr, fragile, petr, mark, will/2, haste, weak, corr, might, brill, -move

# cloud_status = true

action_panel_font_size = 19
action_panel_font_family = UD デジタル 教科書体 N-B
action_panel_orientation = vertical
action_panel_show = false

menu := menu_colour
# menu ^= lightgrey:potions? of (attraction|lignification|mutation)
# menu ^= lightgrey:scrolls? of (poison|torment|immolation|vulnerability|noise)

msc := message_colour
msc ^= lightgrey:( miss | misses |no damage|fail to reach past|returns to the grave|disappears in a puff of smoke)
msc ^= yellow:(You feel a bit more experienced)

msc += mute:Search for what.*(<<|@|in_shop)
msc += mute:There is an open door here
msc += mute:You swap places with your
msc += mute:(Your.*zombie|The butterfly) leaves your sight

: if you.god() == "Yredelemnul" and you.branch() == "Lair" then
msc += mute:Your.*(something|the (plant|bush|fungus))
msc += mute:Something.*the (plant|bush|fungus)
msc += mute:(The|A nearby) (plant|bush|fungus).*die
: end

# github.com/crawl/crawl/commit/03cf731cd7f90669eb5f4fdd65f006c47cf609cc
# msc += mute:Maggie comes into view

hp_colour = 100:green, 99:lightgray, 75:yellow, 50:lightred, 25:red
mp_colour = 100:green, 99:lightgray, 75:yellow, 50:lightred, 25:red
hp_warning = 50
mp_warning = 30

tile_show_threat_levels = trivial, easy, tough, nasty, unusual
tile_show_demon_tier = true
always_show_zot = true
# always_show_gems = true
more_gem_info = true

# monster_item_view_coordinates = true

#############
# Interface #
#############
autofight_nomove_fires = false
autofight_fire_stop = true
autofight_caught = true
autofight_wait = true
autofight_stop = 55
rest_wait_both = true
rest_wait_ancestor = true
fire_order  = spell, throwing, evokable
fire_order_ability -= all
fail_severity_to_quiver = 3
fail_severity_to_confirm = -1
spell_menu = true
warn_contam_cost = true

show_more = false
easy_confirm = safe
equip_unequip = true
sort_menus = true:equipped,charged,art,ego,glowing,identified,basename
stat_colour = 3:red, 7:lightred
default_manual_training = true

: if you.xl() <= 3 then
skill_focus = true
: end

: if you.xl() >= 4 then
skill_focus = false
: end

explore_delay = 15
view_delay = 550
level_map_cursor_step = 8
warn_hatches = true
explore_stop = greedy_pickup_smart
explore_stop += stairs,shops,altars,portals,branches,runed_doors,glowing_items,artefacts,runes

combo += MiFi . trident
# combo += DECj

############
# Messages #
############
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/defaults/messages.txt
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/defaults/runrest_messages.txt
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/defaults/misc.txt

ignore := runrest_ignore_message
stop := runrest_stop_message
more := force_more_message
flash := flash_screen_message

# stop += duration:
ignore += recovery:
ignore += contamination has completely
ignore += your breath back
ignore += engulfed in a cloud of smoke
ignore += engulfed in white fluffiness
ignore += safely over a trap
interrupt_travel -= sense_monster

# crawl.chaosforge.org/Portal
# github.com/crawl/crawl/tree/master/crawl-ref/source/dat/des/portals
# very nearby: 7–13, nearby: 14–20, distant: 21–27, very distant: 28+
flash += timed_portal:
stop += timed_portal:
flash += You hear.*very (nearby|distant)
more += You hear.*(quick|urgent|loud (creaking of a portcullis|crackling of a melting archway)|rising multitudes|rapid|thunderous|frantic|ear-piercing|full choir)
flash += You hear.*(quick|urgent|loud (creaking of a portcullis|crackling of a melting archway)|rising multitudes|rapid|thunderous|frantic|ear-piercing|full choir)
more += Found.*(bazaar|trove|phantasmal|sand-covered|glowing drain|flagged portal|gauntlet|frozen archway|dark tunnel|crumbling gateway|ruined gateway|magical portal|ziggurat)
more += You enter a wizard's laboratory
flash += Hurry and find it
more += The walls and floor vibrate strangely for a moment
flash += The walls and floor vibrate strangely for a moment

# Expiring effects
stop += You feel a little less mighty now
more += Your transformation is almost over
more += back to life
more += You feel yourself slow down
flash += You feel yourself slow down
more += less insulated
more += You are starting to lose your buoyancy
more += You lose control over your flight
more += Your hearing returns
more += You have a feeling this form
more += You feel yourself come back to life
more += uncertain
more += time is quickly running out
more += life is in your own hands
more += shroud falls apart
more += You start to feel a little slower
more += You flicker
more += You feel less protected from missiles
more += Your reaping aura expires
more += You finish channelling your searing ray
more += Your rain of reagents ends

# Interrupts
more += You don't.*that spell
more += You fail to use your ability
more += You miscast.*(Blink|Borgnjor|Door|Invisibility)
flash += You miscast
more += You can't (read|drink|do)
more += You cannot.*while unable to breathe
more += You cannot.*in your current state
more += when.*silenced
more += too confused
more += There's something in the way
# more += There's nothing to (close|open) nearby
more += not good enough to have a special ability
more += You are too berserk
more += no means to grasp
more += That item cannot be evoked
more += You are held in a net
more += You don't have any such object
more += You can't unwield
more += enough magic points
more += You don't have the energy to cast that spell
more += You are unable to access your magic
more += You assume a fearsome visage
flash += is a mimic
# more += You kill.*(entropy weaver|orb of (fire|winter|entropy))
more += You kill.*(Bai Suzhen)
more += (?<!(into|through)) a shaft
more += You blink
more += (?<!raiju) bursts into living lightning
more += blinks into view
more += (?!(draconian|shifter|annihilator) blinks!
flash += (draconian|shifter|annihilator) blinks!
more += is devoured by a tear in reality

: if you.xl() <= 14 then
more += You feel a bit more experienced
: end

confirm_action += Potion Petition, Call Merchant, Blink, Silence, Maxwell's Capacitive Coupling, Sublimation of Blood, Borgnjor's Revivification, Death's Door
force_spell_targeter += Silence

: if you.res_shock() <= 0 then
confirm_action += Conjure Ball Lightning, Chain Lightning
: end

# Bad things
# github.com/crawl/crawl/blob/master/crawl-ref/source/mutation-data.h
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/database/monspell.txt
# github.com/crawl/crawl/blob/master/crawl-ref/source/beam.cc
flash += mutation:
more += The horns on your head grow some more
more += The horns on your head shrink a bit
more += You feel vulnerable to
flash += You feel vulnerable to
more += You feel yourself grow more vulnerable to poison
flash += You feel yourself grow more vulnerable to poison
flash += Cherry-coloured flames burn away your fire resistance
more += The klown pie hits you! (?!but)
flash += The klown pie hits you! (?!but)
more += hell_effect:
more += Doom befalls (?!your)you
more += You feel an ill-omen
more += You feel a malign power afflict you
more += shimmers and splits apart
flash += You are too injured to fight recklessly
flash += MASSIVE DAMAGE
flash += BIG DAMAGE
flash += LOW HITPOINT WARNING

: if not (you.race() == "Minotaur" or you.race() == "Troll") then
flash += LOW MAGIC WARNING
: end

more += You don't have enough magic to cast this spell
more += You stop ascending the stairs
flash += You stop ascending the stairs
more += surroundings become eerily quiet
flash += surroundings become eerily quiet
flash += You hear a loud "Zot"
more += A malevolent force fills
more += An alarm trap emits a blaring wail
more += A sentinel's mark forms upon you
more += invokes.*trap
more += Your surroundings flicker
more += You cannot teleport right now
more += A huge blade swings out and slices into you
more += (blundered into a|invokes the power of) Zot
more += That really hurt
more += You convulse
more += Your body is wracked with pain
more += offers itself to Yredelemnul
flash += smites (?!your)you
more += You are (blasted|electrocuted)
more += You are.*confused
more += You are blinded
flash += Something hits (?!your)you
flash += You stumble backwards
flash += You are shoved backwards
flash += drags you backwards
flash += You are knocked back
more += floods into your lungs!
more += grabs (?!your)you
flash += grabs (?!your)you
more += roots grab (?!your)you
flash += roots grab (?!your)you
flash += constricts (?!your)you
more += wrath finds you
more += god:(sends|finds|silent|anger)
more += You feel a surge of divine spite
more += disloyal to dabble
more += lose consciousness
more += You are too injured to fight blindly
more += You feel your attacks grow feeble
more += The blast of calcifying dust hits (?!your|(?-i:[A-Z])|the)you
flash += The blast of calcifying dust hits (?!your|(?-i:[A-Z])|the)you
more += Space warps horribly.*around (?!your)you
more += Space bends around (?!your)you
more += Your limbs have turned to stone
more += Your body becomes as fragile as glass
flash += You feel extremely sick
more += lethally poison
flash += The acid corrodes (?!your)you
more += You are covered in intense liquid fire
flash += You feel drained

: if you.res_shock() <= 0 then
more += You are engulfed in a thunderstorm
: end

: if you.res_poison() <= 0 then
more += You are engulfed in excruciating misery
: end

more += Strange energies course through your body
more += You feel strangely unstable
more += (?<!Your (shadowghast|vampire)) flickers and vanishes
flash += (?<!Your).*flickers and vanishes
more += is no longer charmed
more += You have lost all your
flash += volcano erupts with a roar
more += Chaos surges forth from piles of flesh
flash += You feel the power of Zot begin to focus
# more += You hear a sizzling splash
more += heals the

: if you.xl() < 24 then
more += flies into a frenzy
flash += flies into a frenzy
: end

: if you.xl() < 16 then
more += You .*seems to speed up
: end

: if you.xl() < 10 then
more += seems to grow stronger
: end

# more += suddenly seems more resistant

# crawl.chaosforge.org/Chaos_Knight_of_Xom_Guide#Xom_rc_file
more += .* erupts in a glittering mayhem of colour
more += .* evaporates and reforms as
more += "Time to have some fun!"
more += "Fight to survive, mortal."
more += "Let's see if it's strong enough to survive yet."
more += You hear Xom's maniacal laughter.
more += Xom feels like there should be more of you to share with the Dungeon.
more += Xom gently smashes a mirror over your
more += Xom displaces most of your magic for a moment.
more += Xom reveals to you one of the great and terrible secrets of magic.
more += Xom curiously channels energy out of your body.
more += Xom picks up your mind and accidentally drops it.
more += Xom gives you a terrible headache.
more += "You don't need this, do you?"
more += Your magic slithers out of your reeling mind!
more += Your power and thoughts are overwhelmed by magic-eaters manifest!
more += Your magic wrenches itself out of your
more += Your magic flows out through your
more += Your magic rips itself out through your
more += "Heh heh heh..."
more += Xom's power touches on your mind for a moment.
more += Xom titters.
more += "Stumble well, my pet!"
more += Xom's power touches upon your body and mind for a moment.
more += Xom decides to rearrange the pieces.
more += "First here, now there."
more += "This might be better!"
more += "This is how I like it!"
more += "The weather's been a little too boring around here."
more += Xom asks Qazlal to spice things up a little.
more += mostly cloudy.
more += (The|Your).*falls away!

# Others
# github.com/crawl/crawl/blob/master/crawl-ref/source/god-abil.cc
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/descript/features.txt
more += Found a faded altar of an unknown god
more += Found a staircase to the Ecumenical Temple
stop += There is a portal to a secret trove of treasure here
stop += Found a runed translucent door
flash += There is a (staircase to the (?!(Ecumenical))|gate to|hole to|gate leading to|gateway (?!(back|out)))
more += Found a gateway leading.*Abyss
more += and a gateway leading out appears
more += The mighty Pandemonium lord.*resides here
more += The tension of great conflict fills the air
more += You have reached level
more += You (can|may) now (?!(stomp|pass|merge))
more += protects you from harm
stop += You feel like a meek peon again
more += Trog grants you a weapon
more += You feel your soul grow
more += Makhleb will allow you to brand your body
more += Your infernal gateway subsides
more += You are dragged down into the Crucible of Flesh
more += Ru believes you are ready to make a new sacrifice
flash += You offer up the Black Torch's flame
more += Your bound.*is destroyed!
more += The heavenly storm settles
more += Beogh will now send orc apostles to challenge you
flash += Beogh will now send orc apostles to challenge you
more += the orc apostle comes into view
more += You encounter.*the orc apostle
more += falls to his knees and submits

: if you.god() == "Beogh" then
more += (?-i:[A-Z])(?!(xecutioner|rb guardian)).*(dies!|is blown up!)
: end

more += has fought their way back out of the Abyss!
more += Your prayer is nearing its end
stop += Your prayer is nearing its end
more += You reach the end of your prayer and your brethren are recalled
stop += You reach the end of your prayer and your brethren are recalled
stop += You now have enough gold to
more += Your bribe of.*has been exhausted
more += Ashenzari invites you to partake
more += you knowledge of
more += Vehumet is now
more += You hear a faint sloshing
more += seems mollified
more += You rejoin the land of the living
more += You add the spells?.*(Apportation|Blink)

: if you.xl() >= 27 and you.class() ~= "Conjurer" then
more += You add the spells?.*(Beckoning|Golubria|Vhi's Electric|Manifold Assault|Fugue of the|Animate Dead|Death Channel|Awaken Armour)
: end

# Contam: 2x(SpellLv)^2xFailure+250, 5000:Yellow, 15000:LightRed
# Miscast:Nameless Horror:HD(2*Int/3) HD15 MaxHP160 Speed10 AC8 Attack30(Antimagic)
# : if you.xl() >= 16 and you.intelligence() <= 25 then
# more += You add the spells?.*(Summon Cactus Giant|Summon Hydra|Summon Horrible Things|Dragon's Call)
# : end

# Miscast:-Move -Tele
# reddit.com/r/dcss/comments/1m4xpsr/a_compendium_of_strange_and_unusual_techniques/
# : if you.xl() >= 20 then
# more += You add the spells?.*(Dispersal|Gell's Gavotte|Manifold Assault|Translocation)
# : end

# interrupt_travel += <activity_interrupt_type>
stop ^= Your.*disappears in a puff of smoke,Your spellspark servitor fades away,Your battlesphere wavers and loses cohesion

{
function c_answer_prompt(prompt)
if prompt:find("Really fire") and prompt:find("your spellforged") then
return true
elseif prompt:find("Really refrigerate") and prompt:find("your spellforged") then
return true
elseif prompt:find("Permafrost Eruption might hit") and prompt:find("servitor") then
return true
elseif prompt:find("Plasma Beam") and prompt:find("might") then
return true
elseif prompt:find("Plasma Beam") and prompt:find("your spellforged") then
return true
elseif prompt:find("Really") and prompt:find("fire vort") then
return true
elseif prompt:find("Really") and prompt:find("battle") then
return true
elseif prompt:find("Really hurl") and prompt:find("your spellforged") then
return true
elseif prompt:find("Really attack your") and prompt:find("rat") then
return true
elseif prompt:find("into that cloud of flame") and you.res_fire() == 3 then
return true
elseif prompt:find("into that cloud of freezing vapour") and you.res_cold() == 3 then
return true
elseif prompt:find("into a travel-excluded") or prompt:find("icy armour will break") then
return true
end
end
}

# Skills
: if you.race() ~= "Gnoll" then
stop += skill increases to level (9|18|26)
more += Your Fighting skill increases to level (18|26)
stop += Your Shields skill increases to level (4|6|9|15|21|25)
stop += Your Short Blades skill increases to level (10|12|14)
stop += Your Long Blades skill increases to level (14|16|18|24)
stop += Your Maces & Flails skill increases to level (12|16|20|22)
stop += Your Axes skill increases to level (16|18|20|26)
more += Your Polearms skill increases to level (14|16|20|26)
stop += Your Staves skill increases to level (12|14)
stop += Your Throwing skill increases to level (6|10|16)
more += Your Evocations skill increases to level (2.5|6|10|11|13|15|18|21)
more += Your Invocations skill increases to level (6|8|10|11|12|13|14|15|16|17)
more += Your Shapeshifting skill increases to level (7|14|19|23|26)
flash += Training target.*reached
: end

more += You have finished (your manual|forgetting about)
more += You pick up a manual of

stop += You see here the
more += You see here.*(of experience|of acquirement)
stop += - [7-9] potions of mutation
stop += - [2-4] scrolls labelled
stop += - [2-4] .* potions

: if you.xl() >= 20 then
stop += You see here.*scrolls? of enchant armour
: end

: if you.xl() >= 12 then
stop += scroll labelled,potion labelled
: end

: if you.xl() >= 10 then
stop += You see here.*scrolls? of (enchant weapon|brand weapon)
: end

: if you.xl() <= 16 then
stop += You see here.*(scrolls? of identify|\+6 ring of)
: end

: if you.xl() <= 14 then
stop += You see here.*(ring of|the ring|amulet)
: end

: if you.xl() <= 12 and you.race() ~= "Mummy" and you.race() ~= "Demonspawn" and you.race() ~= "Revenant" and you.race() ~= "Poltergeist" and you.transform() ~= "death" and you.transform() ~= "vampire" then
flash += Found.*(Elyvilon|The Shining One|Zin)
: end

: if you.xl() <= 12 and not (you.race() == "Minotaur" or you.race() == "Troll") then
flash += Found.*(Vehumet|Sif Muna)
: end

: if you.xl() <= 10 then
flash += Found.*(Ashenzari|Beogh|Cheibriados|Fedhas|Gozag|Hepliaklqana|Ignis|Jiyva|Makhleb|Nemelex|Okawaru|Qazlal|Ru|Trog|Uskayaw|Wu Jian|Yredelemnul)
: end

: if you.xl() > 18 and you.race() ~= "Mummy" and you.race() ~= "Demonspawn" and you.race() ~= "Revenant" and you.race() ~= "Poltergeist" and you.transform() ~= "death" and you.transform() ~= "vampire" then
flash += Found.*(The Shining One|Zin)
: end

# Uniques and baddies
# github.com/crawl/crawl/blob/master/crawl-ref/source/mon-gear.cc
unusual_monster_items += ( the |distortion|chaos|silver)
more += You encounter.*(undying armoury|antique champion|torpor snail|nekomata|oblivion hound|acid blob|entropy weaver|ghost moth|death knight|eye of devastation) (?!zombie|draugr|simulacrum)
more += 's illusion shouts
flash += 's illusion shouts
more += Bai Suzhen roars in fury and transforms into a fierce dragon
flash += Bai Suzhen roars in fury and transforms into a fierce dragon
more += Xak'krixis conjures a prism
more += Nobody ignites a memory of
more += BOSS
flash += BOSS
flash += changes into,Something shouts
monster_alert += pandemonium lord, nasty

# Dissolution (Slime:2-5)
# github.com/crawl/crawl/blob/master/crawl-ref/source/mon-act.cc
: if you.branch() == "Slime" then
flash += You hear a (sizzling sound|grinding noise)
: end

# more += You encounter.*(?!orb guardian|executioner)(?-i:[A-Z])
flash += You encounter.*(?!orb guardian|executioner)(?-i:[A-Z])

more += You encounter.*(lernaean hydra|boundless tesseract|wretched star|neqoxec|shining eye|cacodemon|zykzyl|orb of (fire|winter|entropy))
flash += You encounter.*(lernaean hydra|boundless tesseract|wretched star|neqoxec|shining eye|cacodemon|zykzyl|orb of (fire|winter|entropy))

more += the reach of Zot diminish
more += The shining eye gazes at you
flash += You encounter.*(death scarab)

# Damnation/Flay
more += You encounter.*((brimstone|ice) fiend|deep elf (sorcerer|high priest))
flash += You encounter.*((brimstone|ice) fiend|deep elf (sorcerer|high priest))
more += You encounter.*(hell sentinel|hellion|draconian scorcher|flayed ghost)
flash += You encounter.*(hell sentinel|hellion|draconian scorcher|flayed ghost)

# Torment/Drain Life/Siphon Essence
: if not (you.race() == "Mummy" or you.race() == "Revenant" or you.race() == "Poltergeist" or you.transform() == "death") then
more += You encounter.*(royal mummy|mummy priest|tzitzimitl)
flash += You encounter.*(royal mummy|mummy priest|tzitzimitl)
more += You encounter.*(tormentor|curse toe|curse skull)
flash += You encounter.*(tormentor|curse toe|curse skull)
more += You encounter.*(deathcap|soul eater|vampire bloodprince|alderking)
flash += You encounter.*(deathcap|soul eater|vampire bloodprince|alderking)
more += The curse toe gestures
: end

# Holy/Dispel Undead
: if you.race() == "Mummy" or you.race() == "Demonspawn" or you.race() == "Revenant" or you.race() == "Poltergeist" or you.transform() == "death" or you.transform() == "vampire" then
flash += You encounter.*(?<!(angel|daeva|fravashi)) is wielding.*of holy
more += You encounter.*(demonspawn black sun|revenant|ushabti|alderking|burial acolyte)
: end

: if you.branch() ~= "Pandemonium" and you.race() == "Mummy" or you.race() == "Demonspawn" or you.race() == "Revenant" or you.race() == "Poltergeist" or you.transform() == "death" or you.transform() == "vampire" then
more += You encounter.*(angel|daeva|fravashi)
flash += You encounter.*(angel|daeva|fravashi)
: end

# Lee's Rapid Deconstruction
: if you.race() == "Gargoyle" or you.race() == "Revenant" or you.transform() == "statue" then
more += You encounter.*(kobold geomancer|deep elf elementalist|deep troll earth mage)
: end

# crawl.chaosforge.org/Reaching
# orange demon, snapping turtle, alligator snapping turtle, Cigotuvi's Monster, Geryon, Serpent of Hell (Dis)

: if you.xl() <= 26 then
more += You encounter.*((ancient|dread) lich|demonspawn warmonger|oni incarcerator|draconian stormcaller)
: end

: if you.xl() <= 24 then
unusual_monster_items += of (acid)
more += (hits|warns) (?!your)you.*of (distortion|chaos)
more += You encounter.*((deep elf|draconian) annihilator|tengu reaver|air elemental|void ooze|orb guardian) (?!zombie|draugr|simulacrum)
more += You encounter.*((?<!(ancient|dread)) lich|shadow dragon|juggernaut|caustic shrike|wyrmhole|spriggan berserker) (?!zombie|draugr|simulacrum)
more += The spriggan berserker utters an invocation to Trog
# Agony
more += You encounter.*(imperial myrmidons|necromancer) (?!zombie|draugr|simulacrum)
flash += You encounter.*(imperial myrmidons|necromancer) (?!zombie|draugr|simulacrum)
: end

: if you.xl() <= 22 then
more += You encounter.*(glass eye|death drake|war gargoyle|crystal guardian)
more += You encounter.*(vault (warden|sentinel)|merfolk (avatar|siren)) (?!zombie|draugr|simulacrum)
more += You encounter.*(executioner|guardian serpent|draconian shifter|ironbound convoker|deep troll shaman|death cob) (?!zombie|draugr|simulacrum)
more += You encounter.*(kobold fleshcrafter|phantasmal warrior|iron giant) (?!zombie|draugr|simulacrum)
more += You encounter.*(halazid warlock|glowing orange brain|apocalypse crab|moth of wrath) (?!zombie|draugr|simulacrum)
flash += You encounter.*(halazid warlock) (?!zombie|draugr|simulacrum)
more += You encounter.*(player|('s|s')) ghost
more += guardian serpent coils itself and waves its upper body at you, guardian serpent weaves intricate patterns
more += ironbound convoker begins to recite a word of recall
more += kobold fleshcrafter chants and writhes
more += halazid warlock gestures
more += ironbound mechanist forges a skittering defender to stand by its side
more += slime creatures merge to form a (very large|enormous|titanic)
: end

# github.com/crawl/crawl/commit/e02c2b2bd47e38273f95c7b2855e43783a19ae70
# unusual_monster_"teism" += vulnerable:holy_wrath
unusual_monster_items += vulnerable:acid:24
unusual_monster_items += vulnerable:(electrocution|draining|vampiric|pain):20
unusual_monster_items += vulnerable:(flaming|freezing):18
unusual_monster_items += vulnerable:(venom):16
unusual_monster_items += vulnerable:holy_wrath

: if you.xl() <= 20 then
unusual_monster_items += of (electrocution|draining|vampiric|pain)
unusual_monster_items += of (spectral|heavy|\+[5-9])
unusual_monster_items += wand of (paralysis|roots|light)
more += You encounter.*(deep elf master archer|boggart|bunyips|stone giant|ironbound beastmaster) (?!zombie|draugr|simulacrum)
more += You encounter.*(formless jellyfish|broodmother|spark wasp|orb spider|nagaraja|merfolk (javelineer|impaler)) (?!zombie|draugr|simulacrum)
# Paralysis/Petrify/Banish
more += You encounter.*(fenstrider witch|orc sorcerer|ogre mage|occultist|great orb of eyes|sphinx (?!zombie|draugr|simulacrum))
more += You encounter.*(?<!spectral) (jorogumo|vampire knight|basilisk|catoblepas|deep elf (sorcerer|demonologist)) (?!zombie|draugr|simulacrum)
flash += The boggart gestures wildly while chanting
: end

: if you.xl() <= 18 then
unusual_monster_items += of (flaming|freezing)
more += You encounter.*(water nymph|anaconda|ironbound thunderhulk) (?!zombie|draugr|simulacrum)
flash += The water rises up and strikes you
: end

: if you.xl() <= 16 then
unusual_monster_items += of (venom)
unusual_monster_items += wand of (charming|polymorph)
more += You encounter.*(raven|fire dragon|centaur warrior|yaktaurs?|cyclops|hydra|orc (warlord|high priest)|salamander (mystic|tyrant)|naga ritualist|spriggan druid|eleionoma|tengu) (?!zombie|draugr|simulacrum)
more += You encounter.*(deep elf|kobold blastminer|gargoyle|ghoul|dire elephant|skyshark|freezing wraith|shock serpent|arcanist|radroach|tarantella|pharaoh ant|wolf spider) (?!zombie|draugr|simulacrum)
flash += You encounter.*(raiju|cyan ugly|radroach|meliai) (?!zombie|draugr|simulacrum)
: end

: if you.xl() <= 13 then
unusual_monster_items += triple sword,executioner's axe,halberd,glaive,bardiche,arbalest,hand cannon,triple crossbow
more += You encounter.*(?<!spectral) (two-headed ogre|kobold geomancer|orange demon|rust devil|lindwurm|ice devil|hornet|cane toad|komodo dragon) (?!zombie|draugr|simulacrum)
# monster_alert += tough
: end

: if you.xl() <= 10 then
unusual_monster_items += great sword,demon trident,partisan,trishula,longbow
more += You encounter.*(wyvern|brain worm|queen bee|gnoll bouda|centaurs?|komodo dragon) (?!zombie|draugr|simulacrum)
flash += You encounter.*(yak)
: end

: if you.xl() <= 7 then
# unusual_monster_items += spear,(?<!demon) trident,sling,shortbow,orcbow
more += You encounter.*(bombardier beetle|ice beast|sky beast|electric eel|sleepcap) (?!zombie|draugr|simulacrum)
flash += You encounter.*killer bees? (?!zombie|draugr|simulacrum)
more += You encounter.*orc (wizard|priest|warrior) (?!zombie|draugr|simulacrum)
flash += You encounter.*orc (wizard|priest|warrior) (?!zombie|draugr|simulacrum)
more += You encounter.*(ogre|gnoll) (?!zombie|draugr|simulacrum)
flash += You encounter.*(ogre|gnoll) (?!zombie|draugr|simulacrum)
: end

: if you.xl() <= 4 and you.race() ~= "Gargoyle" and you.race() ~= "Revenant" and you.race() ~= "Poltergeist" and you.race() ~= "Mummy" and you.race() ~= "Djinni" then
more += You encounter.*adder (?!zombie|draugr|simulacrum)
: end

##############
### Morgue ###
##############
dump_on_save = true
dump_message_count = 200
note_hp_percent = 20
user_note_prefix = 

note_items += of experience,of resistance,archmagi,crystal plate armour,pearl dragon scales
note_messages += You pass through the gate
note_messages += cast.*Abyss
note_messages += BOSS
note_messages += Yredelemnul refuses to let your conquest be stopped by a trick of the earth!, 's soul is now yours, Your bound.*is destroyed!

dump_order  = header,hiscore,stats,misc,apostles,mutations,overview,inventory,skills,spells
dump_order += messages,screenshot,monlist,kills
dump_order += notes,vaults,skill_gains,action_counts,turns_by_place

##############
# Autopickup #
##############
# github.com/crawl/crawl/blob/master/crawl-ref/settings/advanced_optioneering.txt
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/defaults/autopickup_exceptions.txt

drop_disables_autopickup = true

autopickup = $?!+:"/}(
ae := autopickup_exceptions
ae += <gem, rune of zot

ae = <of noise

: if not (you.race() == "Mummy" or you.race() == "Revenant" or you.race() == "Poltergeist") then
ae = <of mutation, of lignification, granite talisman, talisman of death
: end

: if you.god() == "Trog" then
ae = <of amnesia, of brilliance
: end

: if you.xl() <= 26 and you.god() == "Okawaru" then
ae = <butterflies, summoning, phantom mirror, horn of Geryon, box of beasts, sack of spiders
: end

: if you.race() ~= "Djinni" and (you.god() == "Okawaru" or you.god() == "Trog" or you.god() == "The Shining One" or you.god() == "Elyvilon" or you.god() == "Zin") then
ae = <book of, parchment of
: end

ae += moonshine

: if you.race() ~= "Troll" and you.race() ~= "Oni" then
ae += large rock
: end

: if you.xl() > 4 then
ae +=  (?<!tremor)stone
: end

: if you.xl() > 12 and you.race() == "Deep Elf" then
ae = <boomerang, javelin, tipped dart, throwing net
: end

: if you.xl() > 18 then
ae += (datura|atropa)-tipped dart
: end

: if you.xl() > 22 then
ae += of identify, poisoned dart, amulet of (acrobat|faith|guardian spirit|reflection), ring of (evasion|strength|intelligence|dexterity|slaying|wizardry|magical power)
: end

##################
### Item Slots ###
##################
# crawl.chaosforge.org/Inscriptions
ai := autoinscribe

# ai += magical staff:!a
ai += (large rock|silver javelin|throwing net|(curare|datura|atropa)-tipped dart|of disjunction):=f

ai += potions? of heal wounds:@q1, 10-37HP
ai += potions? of curing:@q2, 5-11HP
ai += potions? of cancellation:@q3
ai += potions? of haste:@q4
ai += potions? of magic:@q5, 10-37MP
ai += potions? of mutation:@q6
ai += potions? of ambrosia:3-5HPMP/T
ai += potions? of lignification:1.5xHP (20+XL/2)AC rPo Torm0 Ev0 -MoBlTe GearWeapShie
# ai += potions? of invisibility:!q
ai += scrolls? of identify:@r1
ai += scrolls? of teleportation:@r2, 3-5T, Zot8-14T
ai += scrolls? of blinking:@r3
ai += enchant armour:@r4
ai += enchant weapon:@r5
ai += scrolls? of fear:Q*f, 40Will90% 60Will73% ++41-80, !r
ai += scrolls? of silence:30Turns
ai += scrolls? of noise:25 Alarm40 FireStor25 FulmPris20 Qaz16 Shout12 IMB10
# ai += scrolls? of revelation:!r
# ai += scrolls? of fog:!r
# ai += scrolls? of summoning:!r
# ai += scrolls? of butterflies:!r
ai += wand of (roots|warping):@v1, \<
ai += wand of iceblast:@v1, \<, 3d(7.66+3.5*Evo/5)
ai += wand of (acid|light):@v2, \>
ai += wand of quicksilver:@v2, \>, 6d(4.16+3.5*Evo/9)
ai += wand of digging:@v3
ai += poisoned dart:@f1@Q1, F1
ai += boomerang:@f2@Q2, F2, 5%
ai += (?<!silver) javelin:@f3@Q3, H, 5%
ai += wand of flame:@v4@Q4, \), 2d(5.5+0.35*Evo), MaxEvo10
ai += wand of mindburst:@v5@Q5, \(, 3d(8.75+3.5*Evo/4)
ai += silver javelin:@f6@Q6, 5%
ai += throwing net:@f7
ai += curare-tipped dart:@f8, 16.7%
ai += phial of floods:(2.1+2*Evo/5)Turns x1 x1.5
ai += sack of spiders:Evo 6 13 18 21
ai += box of beasts:HD 3 9 15 21 27(Evo+1d7-1d7)
ai += condenser vane:(65+3.5*Evo)/1.6%
ai += tin of tremorstones:Evo 2.5 6 11 18, 5x5 6d6 40%
ai += lightning rod:(2+PreUses)d(0.75*Evo+46.25)/3, 2d16(Evo1)
ai += Gell's gravitambourine:Evo 9.5 23.2

ai += ring of magical power:MP+9
ai += quicksilver dragon scales (?!("|of)):Will+
ai += golden dragon scales (?!("|of)):rF+, rC+, rPois
ai += fire dragon scales (?!("|of)):rF++, rC-
ai += ice dragon scales (?!("|of)):rC++, rF-
ai += swamp dragon scales (?!("|of)):rPois
ai += storm dragon scales (?!("|of)):rElec
ai += pearl dragon scales (?!("|of)):rN+
ai += shadow dragon scales (?!("|of)):Stlth+
ai += staff of conjuration:IrresistibleDmg-20%
ai += staff of earth:PhysicalDmg-5%
ai += staff of fire:rF+
ai += staff of cold:rC+
ai += staff of poison:rPois
ai += staff of air:rElec
ai += staff of death:rN+

: if you.xl() > 4 then
ai += (?<!the) \+0 (dagger|short sword|club|whip|giant club|giant spiked|hand axe|spear|sling|shortbow|(?<!tremor)stone|animal skin|robe|leather armour) (?!("|of)):~~DROP_ME
: end

: if you.xl() > 8 then
ai += (?<!the) \+0 (falchion|long sword|quarterstaff|troll leather armour|ring mail|scale mail) (?!("|of)):~~DROP_ME
: end

: if you.xl() > 12 then
ai += (?<!the) \+[1-3] (dagger|short sword|club|whip|hand axe|spear|sling|shortbow|animal skin|robe|leather armour) (?!("|of)):~~DROP_ME
: end

: if you.xl() > 14 then
ai += (?<!the) \+[1-3] (falchion|long sword|quarterstaff|troll leather armour|ring mail|scale mail) (?!("|of)):~~DROP_ME
: end

: if you.xl() > 16 then
ai += (?<!the) \+0 (mace|flail|dire flail|war axe|trident|halberd|chain mail|plate armour|steam dragon scales|helmet) (?!("|of)):~~DROP_ME
: end

: if you.xl() > 20 then
ai += (?<!the) \+0 (great mace|battleaxe|executioner's axe|scythe|glaive|bardiche|buckler|pair of boots|cloak|pair of gloves|acid dragon scales|swamp dragon scales) (?!("|of)):~~DROP_ME
: end

: if you.xl() > 22 then
ai += (?<!the) \+0 (kite shield|fire dragon scales|ice dragon scales) (?!("|of)):~~DROP_ME
ai += of identify:~~DROP_ME
: end

: if you.xl() > 24 then
ai += (?<!the) \+0 (morningstar|broad axe|partisan|tower shield) (?!("|of)):~~DROP_ME
: end

gear_slot ^= (war axe|broad axe|whip|mace|flail|ningstar|scourge|spear|trident|trishula|partisan|halberd|glaive|bardiche|staff) : abW
gear_slot ^= (ring of protection (?!from)|the ring .* AC\+) : ptcmPTCM
gear_slot ^= (ring of evasion|the ring .* EV\+) : evdgEVDG
gear_slot ^= (ring of strength|the ring .* Str\+) : strhSTRH
gear_slot ^= (ring of intelligence|the ring .* Int\+) : intlINTL
gear_slot ^= (ring of dexterity|the ring .* Dex\+) : dxeyDXEY
gear_slot ^= (ring of slaying|the ring .* Slay\+) : yksxYKSX
gear_slot ^= (ring of wizardry|the ring .* Wiz ) : zwysZWYS
gear_slot ^= (ring of magical power|the ring .* MP\+) : mpgqMPGQ
gear_slot ^= (ring of protection from fire|the ring .* rF\+) : fireFIRE
gear_slot ^= (ring of protection from cold|the ring .* rC\+) : cieoCIEO
gear_slot ^= (ring of positive energy|the ring .* rN\+) : nuveNUVE
gear_slot ^= (ring of poison resistance|the ring .* rPois) : pvxtPVXT
gear_slot ^= (lightning rod|the ring .* rElec) : qzlrQZLR
gear_slot ^= (ring of resist corrosion|the ring .* rCorr) : jrocJROC
gear_slot ^= (ring of see invisible|the ring .* SInv) : vighVIGH
gear_slot ^= (ring of willpower|the ring .* Will\+) : wmlhWMlH
gear_slot ^= (ring of flight|the ring .* Fly) : lhfyLHFY

gear_slot ^= armour:ABCDEFGHIJKLMNOPQRSTUVWXYZ
gear_slot ^= shield:ABCDEFGHIJKLMNOPQRSTUVWXYZ
gear_slot ^= ( hat |cloak|scarf|pair of gloves|pair of boots):ABCDEFGHIJKLMNOPQRSTUVWXYZ
gear_slot ^= orb:ABCDEFGHIJKLMNOPQRSTUVWXYZ
gear_slot ^= amulet:ABCDEFGHIJKLMNOPQRSTUVWXYZ
gear_slot ^= talisman:ABCDEFGHIJKLMNOPQRSTUVWXYZ
consumable_shortcut += javelin:abcdefghijklmnopqrstuwxyz
consumable_shortcut += boomerang:abcdefghijklmnopqrstuwxyz
consumable_shortcut += throwing net:abcdefghijklmnopqrstuwxyz
consumable_shortcut += dart:abcdefghijklmnopqrstuwxyz
consumable_shortcut += potion of mutation:t
consumable_shortcut += scroll of noise:n
consumable_shortcut += scroll of revelation:R

##############
### Macros ###
##############
# github.com/crawl/crawl/blob/master/crawl-ref/docs/macros_guide.txt
{
function explore_approach()
     crawl.setopt("travel_open_doors = approach")
     crawl.do_commands({"CMD_EXPLORE"})
end
}
macros += M o ===explore_approach

# Press "Tab" when enemies are visible and "o" when they are not
{
function explore_attack()
    crawl.setopt("travel_open_doors = approach")
    if you.feel_safe() then
        crawl.sendkeys("o")
    else
        crawl.sendkeys({9})
    end
end
}
macros += M b ===explore_attack

{
function explore_fire()
    crawl.setopt("travel_open_doors = approach")
    if you.feel_safe() then
        crawl.sendkeys("o")
    else
        crawl.do_commands({"CMD_AUTOFIRE"})
    end
end
}
macros += M h ===explore_fire

{
function doors_open()
     crawl.setopt("travel_open_doors = open")
     crawl.sendkeys("o")
end
}
macros += M j ===doors_open

{
function doors_avoid()
     crawl.setopt("travel_open_doors = avoid")
     crawl.sendkeys("o")
end
}
macros += M J ===doors_avoid

{
function godown_open()
     crawl.setopt("travel_open_doors = open")
     crawl.sendkeys("X",">")
end
}
macros += M \{NP+} ===godown_open

{
function goup_open()
     crawl.setopt("travel_open_doors = open")
     crawl.sendkeys("X","<")
end
}
macros += M \{NP-} ===goup_open

{
function travel_open()
     crawl.setopt("travel_open_doors = open")
     crawl.sendkeys("G",{9})
end
}
macros += M T ===travel_open

# reddit.com/r/dcss/comments/1ngwfhl/the_most_useful_dcss_command/ne77ryd/
{
function smart_stairs()
    local feat = view.feature_at(0, 0)
    if feat:find("stairs_down") or feat:find("hatch_down") or feat:find("enter") then
        crawl.sendkeys(">")
    elseif feat:find("stairs_up") or feat:find("hatch_up") or feat:find("exit") or feat:find("return") then
        crawl.sendkeys("<")
    elseif feat:find("portal") or feat:find("transporter") or feat:find("shop") or feat:find("transit") or feat:find("altar") then
        crawl.sendkeys(">")
    else
        crawl.mpr("No stairs here.")
        crawl.mpr("Standing on: " .. feat)
    end
end
}
macros += M \{NP.} ===smart_stairs

# Tab:\{9}, Enter:\{13}, Esc:\{27}, Space:\{32}, Ctrl:*, Shift:/
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/descript/features.txt

# Ctrl-L: List of Banes
# macros += M \{12} ?/n\{32}\{13}

# Ctrl-L: Help, Monster 
macros += M \{12} ?/m

macros += M . *f<<case\{32}to\{32}th\{32}||\{32}gate\{32}to\{32}||\{32}hole\{32}to\{32}||\{32}gate\{32}lead>>\{32}&&\{32}!!one-\{13}
macros += M n x+
macros += M N x-
macros += M l x+v
macros += M L x-v
macros += M C X*e
macros += M Y tt
macros += M I II
macros += M R \\-
macros += M y ff
macros += M \{NP0} vf
macros += M O aa
macros += M K ab

: if you.xl() <= 9 and (you.race() == "Minotaur" or you.race() == "Troll") then
macros += M , *f@\{32}&&\{32}!!transp\{32}&&\{32}!!stair\{32}&&\{32}!!hatc\{32}&&\{32}!!trap\{32}&&\{32}!!gate\{32}&&\{32}!!door\{32}&&\{32}!!skin\{32}&&\{32}!!0\{32}robe\{32}&&\{32}!!0\{32}leat\{32}&&\{32}!!0\{32}ring\{32}mail\{32}&&\{32}!!0\{32}scale\{32}&&\{32}!!0\{32}chain\{32}&&\{32}!!0\{32}plate\{32}&&\{32}!!0\{32}buck\{32}&&\{32}!!0\{32}cloa\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}tride\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battlea\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!ranged\{32}&&\{32}!!blades\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

: if you.xl() >= 10 and you.xl() <= 16 and (you.race() == "Minotaur" or you.race() == "Troll") then
macros += M , *f@\{32}&&\{32}!!transp\{32}&&\{32}!!stair\{32}&&\{32}!!hatc\{32}&&\{32}!!trap\{32}&&\{32}!!gate\{32}&&\{32}!!door\{32}&&\{32}!!quart\{32}&&\{32}!!ranged\{32}&&\{32}!!blades\{32}&&\{32}!!club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!nd\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!spea\{32}&&\{32}!!0\{32}tride\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battlea\{32}&&\{32}!!skin\{32}&&\{32}!!robe\{32}&&\{32}!!leat\{32}&&\{32}!!0\{32}ring\{32}mail\{32}&&\{32}!!0\{32}scale\{32}&&\{32}!!0\{32}chain\{32}&&\{32}!!0\{32}plate\{32}&&\{32}!!0\{32}buck\{32}&&\{32}!!0\{32}cloa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

: if you.xl() >= 17 and (you.race() == "Minotaur" or you.race() == "Troll") then
macros += M , *f@\{32}&&\{32}!!transp\{32}&&\{32}!!stair\{32}&&\{32}!!hatc\{32}&&\{32}!!trap\{32}&&\{32}!!gate\{32}&&\{32}!!door\{32}&&\{32}!!quart\{32}&&\{32}!!ranged\{32}&&\{32}!!blades\{32}&&\{32}!!club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!r\{32}ax\{32}&&\{32}!!mace\{32}&&\{32}!!flail\{32}&&\{32}!!nd\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!spea\{32}&&\{32}!!0\{32}tride\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battlea\{32}&&\{32}!!mail\{32}&&\{32}!!0\{32}chain\{32}&&\{32}!!0\{32}plate\{32}&&\{32}!!0\{32}buck\{32}&&\{32}!!0\{32}cloa\{32}&&\{32}!!skin\{32}&&\{32}!!robe\{32}&&\{32}!!leat\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

: if you.race() ~= "Minotaur" and you.race() ~= "Troll" then
macros += M , *f@\{32}&&\{32}!!transp\{32}&&\{32}!!stair\{32}&&\{32}!!hatc\{32}&&\{32}!!trap\{32}&&\{32}!!gate\{32}&&\{32}!!doorr\{32}&&\{32}!!skin\{32}&&\{32}!!0\{32}robe\{32}&&\{32}!!0\{32}leat\{32}&&\{32}!!0\{32}ring\{32}mail\{32}&&\{32}!!0\{32}scale\{32}&&\{32}!!0\{32}chain\{32}&&\{32}!!0\{32}plate\{32}&&\{32}!!0\{32}buck\{32}&&\{32}!!0\{32}cloa\{32}&&\{32}!!0\{32}dagg\{32}&&\{32}!!0\{32}shor\{32}&&\{32}!!0\{32}rapie\{32}&&\{32}!!0\{32}falc\{32}&&\{32}!!0\{32}long\{32}\{32}&&\{32}!!0\{32}grea\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}tride\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battlea\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

: if you.race() == "Minotaur" or you.race() == "Troll" then
macros += M P *fin_shop\{32}&&\{32}!!ranged\{32}&&\{32}!!blades\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}tride\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battlea\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!skin\{32}&&\{32}!!0\{32}robe\{32}&&\{32}!!0\{32}leat\{32}&&\{32}!!0\{32}ring\{32}mail\{32}&&\{32}!!0\{32}scale\{32}&&\{32}!!0\{32}chain\{32}&&\{32}!!0\{32}plate\{32}&&\{32}!!0\{32}buck\{32}&&\{32}!!0\{32}cloa\{32}&&\{32}!!book\{32}&&\{32}!!parchm\{32}&&\{32}!!carri\{13}
: end

: if you.race() ~= "Minotaur" and you.race() ~= "Troll" then
macros += M P *fin_shop\{32}&&\{32}!!0\{32}dagg\{32}&&\{32}!!0\{32}shor\{32}&&\{32}!!0\{32}rapie\{32}&&\{32}!!0\{32}falc\{32}&&\{32}!!0\{32}long\{32}\{32}&&\{32}!!0\{32}grea\{32}&&\{32}!!0\{32}sling\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}tride\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battlea\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!skin\{32}&&\{32}!!0\{32}robe\{32}&&\{32}!!0\{32}leat\{32}&&\{32}!!0\{32}ring\{32}mail\{32}&&\{32}!!0\{32}scale\{32}&&\{32}!!0\{32}chain\{32}&&\{32}!!0\{32}plate\{32}&&\{32}!!0\{32}buck\{32}&&\{32}!!0\{32}cloa\{32}&&\{32}!!carri\{13}
: end

macros += M S *f<<scrol\{32}||\{32}potio>>\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
macros += M % *f<<misc\{32}||\{32}wand\{32}||\{32}throwin>>\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
macros += M " *f<<jewell\{32}||\{32}orb>>\{32}&&\{32}!!statu\{32}&&\{32}!!carri\{13}
macros += M [ *f<<body\{32}||\{32}aux>>\{32}&&\{32}!!orb\{32}&&\{32}!!skin\{32}&&\{32}!!0\{32}robe\{32}&&\{32}!!0\{32}leat\{32}&&\{32}!!0\{32}ring\{32}mail\{32}&&\{32}!!0\{32}scale\{32}&&\{32}!!0\{32}chain\{32}&&\{32}!!0\{32}plate\{32}&&\{32}!!0\{32}buck\{32}&&\{32}!!0\{32}cloa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
macros += M ` *f<<ranged\{32}||\{32}blades\{32}||\{32}magica>>\{32}&&\{32}!!jewell\{32}&&\{32}!!0\{32}dagg\{32}&&\{32}!!0\{32}shor\{32}&&\{32}!!0\{32}rapie\{32}&&\{32}!!0\{32}falc\{32}&&\{32}!!0\{32}long\{32}\{32}&&\{32}!!0\{32}grea\{32}&&\{32}!!0\{32}sling\{32}&&\{32}!!body\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}

macros += M & *f<<axe\{32}||\{32}polea\{32}||\{32}mace>>\{32}&&\{32}!!magica\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}tride\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battlea\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
macros += M _ *f<<mace\{32}||\{32}axe\{32}||\{32}stav>>\{32}&&\{32}!!magica\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}

: if you.xl() <= 16  then
macros += M : *f<<polea\{32}||\{32}axe\{32}||\{32}stav>>\{32}&&\{32}!!magica\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}tride\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battlea\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

: if you.xl() >= 17  then
macros += M : *f<<mon\{32}tri\{32}||\{32}parti\{32}||\{32}trish\{32}||\{32}bardic>>\{32}&&\{32}!!magica\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

# F1:\{-265}:poisoned dart, F2:\{-266}:boomerang, H:javelin, ")":wand of flame, "(":mindburst, "<":iceblast|roots|warping, ">":acid|light|quicksilver
macros += M \{-265} F15
macros += M \{-266} F25
macros += M H F3
macros += M ) V45
macros += M ( V55
macros += M < V15
macros += M > V25
macros += M E zaf
macros += M U zbf
macros += M 1 za
macros += M 2 zb
macros += M 3 zc
macros += M 4 zd
macros += M 5 ze
macros += M 6 zf
macros += M 7 zg
macros += M 8 zh
macros += M 9 zi
macros += M 0 zj

# github.com/brianfaires/crawl-rc/blob/main/rc/macros.rc
# Confirm targeting with same keys as spellcasting
macros += K2 1 \{13}
macros += K2 2 \{13}
macros += K2 4 \{13}
macros += K2 6 \{13}
macros += K2 7 \{13}
macros += K2 8 \{13}
macros += K2 9 \{13}
macros += K2 0 \{13}

###############
# Keybindings #
###############
# github.com/crawl/crawl/blob/master/crawl-ref/docs/keybind.txt
bindkey = [NP5] CMD_WAIT
bindkey = [NP5] CMD_TARGET_SELECT_ENDPOINT
bindkey = [B] CMD_EXPLORE_NO_REST
bindkey = [s] CMD_REST
bindkey = [c] CMD_CLOSE_DOOR
bindkey = [C] CMD_MAP_CLEAR_EXCLUDES
bindkey = [W] CMD_WIELD_WEAPON
bindkey = [w] CMD_WEAR_ARMOUR
bindkey = [p] CMD_WEAR_JEWELLERY
bindkey = [Tab] CMD_AUTOFIGHT_NOMOVE
bindkey = [k] CMD_AUTOFIRE
bindkey = [u] CMD_PREV_CMD_AGAIN
bindkey = [i] CMD_RESISTS_SCREEN
bindkey = [e] CMD_FULL_VIEW
bindkey = [e] CMD_TARGET_FULL_DESCRIBE
bindkey = [e] CMD_MAP_EXIT_MAP
bindkey = [k] CMD_TARGET_EXCLUDE
bindkey = [k] CMD_MAP_EXCLUDE_AREA
bindkey = [\{13}] CMD_DISPLAY_INVENTORY
bindkey = [NPenter] CMD_DISPLAY_INVENTORY
bindkey = [\{NP+}] CMD_MAP_FIND_DOWNSTAIR
bindkey = [\{NP-}] CMD_MAP_FIND_UPSTAIR
bindkey = [\{NP*}] CMD_CYCLE_QUIVER_FORWARD
bindkey = [\{NP/}] CMD_CYCLE_QUIVER_BACKWARD
bindkey = [ ] CMD_TARGET_CANCEL
bindkey = [ ] CMD_MAP_EXIT_MAP
bindkey = [b] CMD_TARGET_CANCEL
bindkey = [h] CMD_TARGET_CANCEL
bindkey = [j] CMD_TARGET_CANCEL
bindkey = [l] CMD_TARGET_CANCEL
bindkey = [n] CMD_TARGET_CANCEL
bindkey = [u] CMD_TARGET_CANCEL
bindkey = [y] CMD_TARGET_CANCEL
bindkey = [B] CMD_TARGET_CANCEL
bindkey = [H] CMD_TARGET_CANCEL
bindkey = [J] CMD_TARGET_CANCEL
bindkey = [K] CMD_TARGET_CANCEL
bindkey = [L] CMD_TARGET_CANCEL
bindkey = [N] CMD_TARGET_CANCEL
bindkey = [U] CMD_TARGET_CANCEL
bindkey = [Y] CMD_TARGET_CANCEL
bindkey = [b] CMD_MAP_EXIT_MAP
bindkey = [h] CMD_MAP_EXIT_MAP
bindkey = [j] CMD_MAP_EXIT_MAP
bindkey = [l] CMD_MAP_EXIT_MAP
bindkey = [n] CMD_MAP_EXIT_MAP
bindkey = [u] CMD_MAP_EXIT_MAP
bindkey = [y] CMD_MAP_EXIT_MAP
bindkey = [B] CMD_MAP_EXIT_MAP
bindkey = [H] CMD_MAP_EXIT_MAP
bindkey = [J] CMD_MAP_EXIT_MAP
bindkey = [K] CMD_MAP_EXIT_MAP
bindkey = [L] CMD_MAP_EXIT_MAP
bindkey = [N] CMD_MAP_EXIT_MAP
bindkey = [U] CMD_MAP_EXIT_MAP
bindkey = [Y] CMD_MAP_EXIT_MAP

# debug_dump(1), init_buehler():reinitialize, init_buehler(1):reset all persistent data, buehler_rc_active = false
bindkey = [~] CMD_LUA_CONSOLE
