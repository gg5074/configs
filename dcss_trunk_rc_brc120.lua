# buehler.rc v1.2.0
################################### Begin lua/core/_header.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
BRC = {}

--- All other configs start with these values
-- These are loaded on startup. Changing them requires a restart.
BRC.Config = {
  emojis = true, -- Include emojis in alerts

  --- Specify which config (defined below) to use, or how to choose one.
  --   "<config name>": Use the named config
  --   "ask": Prompt at start of each new game
  --   "previous": Keep using the last config
  use_config = "Explicit",

  --- For local games, use store_config to use different configs across multiple characters.
  --   "none": Normal behavior: Read use_config, and load it from the RC.
  --   "name": Remember the config name and reload it from the RC. Ignore new values of use_config.
  --   "full": Remember the config and all of its values. Ignore RC changes.
  store_config = "none",
} -- BRC.Config (do not remove this comment)

}
############################### End lua/core/_header.lua ###############################
##########################################################################################

################################### Begin lua/config/explicit.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
--- Explicit config: All config values from all features listed explicitly, set to defaults
-- Large feature config sections are at the end
-- @warning Since this lives at the top of the RC, it can't reference constants.lua or util/*.lua
--   So it must hardcode values like keycodes, where feature configs get to use BRC.KEYS, etc

brc_config_explicit = {
  BRC_CONFIG_NAME = "Explicit",

  ---- BRC Core values ----
  mpr = {
    show_debug_messages = false,
    logs_to_stderr = false,
  },

  dump = {
    max_lines_per_table = 200, -- Avoid huge tables (alert_monsters.Config.Alerts) in debug dumps
    omit_pointers = true, -- Don't dump functions and userdata (they only show a hex address)
  },

  unskilled_egos_usable = false, -- Does "Armour of <MagicSkill>" have an ego when skill is 0?

  --- How weapon damage is calculated for inscriptions+pickup/alert: (factor * DMG + offset)
  BrandBonus = {
    chaos = { factor = 1.2, offset = 2.0 }, -- Approximate weighted average
    distort = { factor = 1.0, offset = 6.0 },
    drain = { factor = 1.25, offset = 2.0 },
    elec = { factor = 1.0, offset = 4.5 },   -- 3.5 on avg; fudged up for AC pen
    flame = { factor = 1.25, offset = 0 },
    freeze = { factor = 1.25, offset = 0 },
    heavy = { factor = 1.8, offset = 0 },    -- Speed is accounted for elsewhere
    pain = { factor = 1.0, offset = you.skill("Necromancy") / 2 },
    spect = { factor = 1.35, offset = 0 },    -- Fudged down for increased incoming damage
    venom = { factor = 1.0, offset = 5.0 },  -- 5 dmg per poisoning

    subtle = { -- Values to use for weapon "scores" (not damage)
      antimagic = { factor = 1.15, offset = 0 },
      holy = { factor = 1.15, offset = 0 },
      penet = { factor = 1.3, offset = 0 },
      protect = { factor = 1.1, offset = 0 },
      reap = { factor = 1.3, offset = 0 },
      vamp = { factor = 1.2, offset = 0 },
      devious = { factor = 1.1, offset = 0 },
      valour = { factor = 1.15, offset = 0 },
      rebuke = { factor = 1.1, offset = 0 },
      concuss = { factor = 1.1, offset = 0 },
      sunder = { factor = 1.2, offset = 0 },
      entangle = { factor = 1.1, offset = 1.5 },
      slay = { factor = 1.15, offset = 0 },
    },
  },

  hotkey = {
    key = { keycode = -1010, name = "[NPenter]" },
    skip_keycode = 27, -- ESC keycode
    equip_hotkey = true, -- Offer to equip after picking up equipment
    wait_for_safety = true, -- Don't expire the hotkey with monsters in view
    explore_clears_queue = false, -- Clear the hotkey queue on explore
  },

  ---- Feature configs ----
  ["my-feature"] = {
    disabled = false,
  },

  ["announce-hp-mp"] = {
    disabled = false,
    dmg_flash_threshold = 0.15, -- Flash screen when losing this % of max HP
    dmg_fm_threshold = 0.25, -- Force more for losing this % of max HP
    always_on_bottom = false, -- Rewrite HP/MP meters after each turn with messages
    meter_length = 6, -- Number of pips in each meter

    Announce = {
      hp_loss_limit = 1, -- Announce when HP loss >= this
      hp_gain_limit = 4, -- Announce when HP gain >= this
      mp_loss_limit = 2, -- Announce when MP loss >= this
      mp_gain_limit = 3, -- Announce when MP gain >= this
      hp_first = true, -- Show HP first in the message
      same_line = true, -- Show HP/MP on the same line
      always_both = false, -- If showing one, show both
      very_low_hp = 0.25, -- At this % of max HP, show all HP changes and mute % HP alerts
    },

    HP_METER = BRC.Config.emojis and { FULL = "❤️", PART = "🩹", EMPTY = "🤍" } or {
      BORDER = "<white>|</white>",
      FULL = "<lightgreen>+</lightgreen>",
      PART = "<lightgrey>+</lightgrey>",
      EMPTY = "<darkgrey>-</darkgrey>",
    },

    MP_METER = BRC.Config.emojis and { FULL = "🟦", PART = "🔹", EMPTY = "➖" } or {
      BORDER = "<white>|</white>",
      FULL = "<lightblue>+</lightblue>",
      PART = "<lightgrey>+</lightgrey>",
      EMPTY = "<darkgrey>-</darkgrey>",
    },
  },

  ["answer-prompts"] = {
    disabled = false,
    -- No config; See answer-prompts.lua for Questions/Answers
  },

  ["announce-items"] = {
    disabled = true, -- Disabled by default. Intended only for turncount runs.
    announced_classes = { "book", "gold", "jewellery", "misc", "potion", "scroll", "wand" }
  },

  ["color-inscribe"] = {
    disabled = true,
    -- No config; See color-inscribe.lua for COLORIZE_TAGS
  },

  ["drop-inferior"] = {
    disabled = false,
    msg_on_inscribe = true, -- Show a message when an item is marked for drop
    hotkey_drop = true, -- BRC hotkey drops all items on the drop list
  },

  ["exclude-dropped"] = {
    disabled = false,
    not_weapon_scrolls = true, -- Don't exclude enchant/brand scrolls if holding enchantable weapon
  },

  ["fully-recover"] = {
    disabled = false,
    rest_off_statuses = { -- Keep resting until these statuses are gone
      "berserk", "confused", "corroded", "diminished spells", "marked", "short of breath",
      "slowed", "sluggish", "tree%-form", "vulnerable", "weakened",
    },
  },

  ["inscribe-stats"] = {
    disabled = false,
    inscribe_weapons = true, -- Inscribe weapon stats on pickup
    inscribe_armour = true, -- Inscribe armour stats on pickup
    dmg_type = 4, -- unbranded, plain, branded, scoring
  },

  ["misc-alerts"] = {
    disabled = false,
    save_with_msg = true, -- Shift-S to save and leave yourself a message
    alert_low_hp_threshold = 0.55, -- % max HP to alert; 0 to disable
    alert_spell_level_changes = true, -- Alert when you gain additional spell levels
    alert_remove_faith = true, -- Reminder to remove amulet at max piety
    remove_faith_hotkey = true, -- Hotkey remove amulet
  },

  ["go-up-macro"] = {
    disabled = false,
    go_up_macro_key = 5, -- (Cntl-E) Key for "go up closest stairs" macro
    ignore_mon_on_orb_run = false, -- Ignore monsters on orb run
    orb_ignore_hp_min = 0.80, -- HP percent to stop ignoring monsters
    orb_ignore_hp_max = 0.90, -- HP percent to ignore monsters at min distance away (2 tiles)
  },

  ["quiver-reminders"] = {
    disabled = true,
    confirm_consumables = true,
    warn_diff_missile_turns = 10,
  },

  ["remind-id"] = {
    disabled = false,
    stop_on_scrolls_count = 2, -- Stop when largest un-ID'd scroll stack increases and is >= this
    stop_on_pots_count = 2, -- Stop when largest un-ID'd potion stack increases and is >= this
    emoji = BRC.Config.emojis and "🎁" or "<magenta>?</magenta>",
    read_id_hotkey = true, -- Put read ID on hotkey
  },

  ---- Large config sections ----
  ["dynamic-options"] = {
    disabled = true,
    -- XL-based force more messages: active when XL <= specified level
    xl_force_mores = {
      { pattern = "monster_warning:wielding.*of electrocution", xl = 10 },
      { pattern = "You.*re more poisoned", xl = 10 },
      { pattern = "^(?!.*Your?).*speeds? up", xl = 10 },
      { pattern = "danger:goes berserk", xl = 18 },
      { pattern = "monster_warning:carrying a wand of", xl = 15 },
    },

    race_options = {
      Gnoll = function()
        BRC.opt.message_mute("intrinsic_gain:skill increases to level", true)
      end,
    },

    class_options = {
      Hunter = function()
        crawl.setopt("view_delay = 30")
      end,
      Shapeshifter = function()
        BRC.opt.autopickup_exceptions("<flux bauble", true)
      end,
    },

    god_options = {
      ["No God"] = function(joined)
        BRC.opt.force_more_message("Found.*the Ecumenical Temple", not joined)
        BRC.opt.flash_screen_message("Found.*the Ecumenical Temple", joined)
        BRC.opt.runrest_stop_message("Found.*the Ecumenical Temple", joined)
      end,
      Beogh = function(joined)
        BRC.opt.runrest_ignore_message("no longer looks.*", joined)
        BRC.opt.force_more_message("Your orc.*dies", joined)
      end,
      Cheibriados = function(joined)
        BRC.util.add_or_remove(BRC.RISKY_EGOS, "Ponderous", not joined)
      end,
      Jiyva = function(joined)
        BRC.opt.flash_screen_message("god:splits in two", joined)
        BRC.opt.message_mute("You hear a.*(slurping|squelching) noise", joined)
      end,
      Lugonu = function(joined)
        BRC.util.add_or_remove(BRC.RISKY_EGOS, "distort", not joined)
      end,
      Trog = function(joined)
        BRC.util.add_or_remove(BRC.ARTPROPS_BAD, "-Cast", not joined)
        BRC.util.add_or_remove(BRC.RISKY_EGOS, "antimagic", not joined)
      end,
      Xom = function(joined)
        BRC.opt.flash_screen_message("god:", joined)
      end,
    },
  },

  ["mute-messages"] = {
    disabled = true,
    mute_level = 1,
    messages = {
      -- Light reduction; unnecessary messages
      [1] = {

        -- Unnecessary
        "You now have .* runes",
        "to see all the runes you have collected",
        "A chill wind blows around you",
        "An electric hum fills the air",
        "You reach to attack",

        -- Interface
        "for a list of commands and other information",
        "Marking area around",
        "(Reduced|Removed|Placed new) exclusion",
        "You can access your shopping list by pressing '\\$'",

        -- Wielding weapons
        "Your .* exudes an aura of protection",
        "Your .* glows with a cold blue light",

        -- Monsters /Allies / Neutrals
        "dissolves into shadows",
        "You swap places",
        "Your spectral weapon disappears",

        -- Spells
        "Your foxfire dissipates",

        -- Religion
        "accepts your kill",
        "is honoured by your kill",
      },

      -- Moderate reduction; potentially confusing but no info lost
      [2] = {
        -- Allies / monsters
        "Ancestor HP restored",
        "The (bush|fungus|plant) (looks sick|begins to die|is engulfed|is struck)",
        "evades? a web",
        "is (lightly|moderately|heavily|severely) (damaged|wounded)",
        "is almost (dead|destroyed)",

        -- Interface
        "Use which ability\\?",
        "Evoke which item\\?$",
        "Shift\\-Dir \\- straight line",

        -- Books
        "You pick up (?!a manual).*and begin reading",
        "Unfortunately\\, you learn nothing new",

        -- Ground items / features
        "There is a.*(door|gate|staircase|web).*here",
        "You see here .*(corpse|skeleton)",
        "You now have \\d+ gold piece",
        "You enter the shallow water",
        "Moving in this stuff is going to be slow",

        -- Religion
        "Your shadow attacks",
      },

      -- Heavily reduced messages for speed runs
      [3] = {
        "No target in view",
        "You (headbutt|bite|kick)",
        "You block",
        "but do(es)? no damage",
        "misses you",
      },
    },
  }, -- mute-messages

  ["pickup-alert"] = {
    disabled = false,
    Pickup = {
      armour = true,
      weapons = true,
      weapons_pure_upgrades_only = true, -- Only pick up better versions of same exact weapon
      staves = true,
    },

    Alert = {
      armour_sensitivity = 1.0, -- Adjust all armour alerts; 0 to disable all (range 0.5-2.0)
      weapon_sensitivity = 1.0, -- Adjust all weapon alerts; 0 to disable all (range 0.5-2.0)
      orbs = true,
      staff_resists = true,
      talismans = true,
      first_ranged = true,
      first_polearm = true,
      autopickup_disabled = true, -- If autopickup off, alert for items that would be autopicked up

      -- Alert the first time each item is found. Can require training with OTA_require_skill.
      one_time = {
        "of gloves", "of gloves of", "of boots", "of boots of", "cloak", "cloak of", "scarf of", " hat ", " hat of",
        "ring of", "amulet of", "6 ring of strength", "6 ring of dexterity", "dragonskin cloak", "moon troll leather armour", "Cigotuvi's embrace",
        "spear of", "trident of", "partisan", "partisan of", "demon trident", "demon trident of", "trishula", "glaive", "bardiche",
        "broad axe", "morningstar", "eveningstar", "demon whip", "sacred scourge", "demon blade",
        "buckler", "buckler of", "kite shield", "kite shield of", "tower shield", "tower shield of", "wand of digging", "quill talisman", "medusa talisman",
        "ring mail of", "scale mail of", "chain mail", "chain mail of", "plate armour", "plate armour of",
        "crystal plate armour", "golden dragon scales", "storm dragon scales", "swamp dragon scales",
        "quicksilver dragon scales", "pearl dragon scales", "shadow dragon scales"
      },
      OTA_require_skill = { weapon = 2, armour = 2.5, shield = 0 }, -- No alert if skill < this

      hotkey_travel = true,
      hotkey_pickup = true,

      allow_arte_weap_upgrades = true, -- If false, won't alert weapons as upgrades to an artefact

      -- Only alert a plain talisman if its min_skill <= Shapeshifting + talisman_lvl_diff
      talisman_lvl_diff = you.class() == "Shapeshifter" and 27 or 6,

      -- Which alerts generate a force_more
      More = {
        early_weap = true,       -- Good weapons found early
        upgrade_weap = true,     -- Better DPS / weapon_score
        weap_ego = true,         -- New or diff egos
        body_armour = true,
        shields = true,
        aux_armour = true,
        armour_ego = true,       -- New or diff egos
        high_score_weap = true,  -- Highest damage found
        high_score_armour = true, -- Highest AC found
        one_time_alerts = true,
        artefact = true,         -- Any artefact
        trained_artefacts = true, -- Artefacts where you have corresponding skill > 0
        orbs = false,
        talismans = you.class() == "Shapeshifter", -- True for shapeshifter, false for everyone else
        staff_resists = true,    -- When a staff gives a missing resistance
        autopickup_disabled = true, -- Alerts for autopickup items, when autopickup is disabled
      }, -- Alert.More
    }, -- Alert

    ---- Heuristics for tuning the pickup/alert system. Advanced behavior customization.
    Tuning = {
      --[[
        Tuning.Armour: Magic numbers for the armour pickup/alert system.
        For armour with different encumbrance, alert when ratio of gain/loss (AC|EV) is > value
        Lower values mean more alerts. gain/diff/same/lose refers to egos.
        min_gain/max_loss block alerts for new egos, when AC or EV delta is outside limits
        ignore_small: if abs(AC+EV) <= this, ignore ratios and alert any gain/diff ego
      --]]
      Armour = {
        Lighter = {
          gain_ego = 0.6,
          new_ego = 0.7,
          diff_ego = 0.9,
          same_ego = 1.2,
          lost_ego = 2.0,
          min_gain = 3.0,
          max_loss = 4.0,
          ignore_small = 3.5,
        }, -- Tuning.Armour.Lighter

        Heavier = {
          gain_ego = 0.4,
          new_ego = 0.5,
          diff_ego = 0.6,
          same_ego = 0.7,
          lost_ego = 2.0,
          min_gain = 3.0,
          max_loss = 8.0,
          ignore_small = 5,
        }, -- Tuning.Armour.Heavier

        encumb_penalty_weight = 0.7, -- [0-2.0] Penalty to heavy armour when training magic/ranged
        early_xl = 6, -- Alert all usable runed body armour if XL <= early_xl
        diff_body_ego_is_good = false, -- More alerts for diff armour ego (skips min_gain check)
      }, -- Tuning.Armour

      --[[
        Tuning.Weap: Magic numbers for the weapon pickup/alert system, namely:
          1. Cutoffs for pickup/alert weapons (when DPS ratio exceeds a value)
          2. Cutoffs for when alerts are active (XL, skill_level)
        Pickup/alert system will try to upgrade ANY weapon in your inventory.
        "DPS ratio" is (new_weap_score / inventory_weap_score). Score considers DPS/brand/accuracy.
      --]]
      Weap = {
        Pickup = {
          add_ego = 1.0, -- Pickup weapon that gains a brand if DPS ratio > add_ego
          same_type_melee = 1.2, -- Pickup melee weap of same school if DPS ratio > same_type_melee
          same_type_ranged = 1.1, -- Pickup ranged weap if DPS ratio > same_type_ranged
          accuracy_weight = 0.25, -- Treat +1 Accuracy as +accuracy_weight DPS
        }, -- Tuning.Weap.Pickup

        Alert = {
          -- Alerts for weapons not requiring an extra hand
          pure_dps = 1.0, -- Alert if DPS ratio > pure_dps
          gain_ego = 0.8, -- Gaining ego; Alert if DPS ratio > gain_ego
          new_ego = 0.8, -- Get ego not in inventory; Alert if DPS ratio > new_ego
          low_skill_penalty_damping = 8, -- [0-20] Reduce penalty to weap of lower-trained schools

          -- Alerts for 2-handed weapons, when carrying 1-handed
          AddHand = {
            ignore_sh_lvl = 4.0, -- Treat offhand as empty if shield_skill < ignore_sh_lvl
            add_ego_lose_sh = 0.8, -- Alert 1h -> 2h (using shield) if DPS ratio > add_ego_lose_sh
            not_using = 1.0, --  Alert 1h -> 2h (not using 2nd hand) if DPS ratio > not_using
          },

          -- Alerts for good early weapons of all types
          Early = {
            xl = 7, -- Alert early weapons if XL <= xl
            skill = { factor = 1.5, offset = 2.0 }, -- Ignore weap w skill_diff > XL*factor+offset
            branded_min_plus = 4, -- Alert branded weapons with plus >= branded_min_plus
          },

          -- Alerts for particularly strong ranged weapons
          EarlyRanged = {
            xl = 14, -- Alert strong ranged weapons if XL <= xl
            min_plus = 7, -- Alert ranged weapons with plus >= min_plus
            branded_min_plus = 4, -- Alert branded ranged weapons with plus >= branded_min_plus
            max_shields = 8.0, -- Alert 2h ranged despite  shield, if shield_skill <= max_shields
          },
        }, -- Tuning.Weap.Alert
      }, -- Tuning.Weap
    }, -- Tuning

    AlertColor = {
      weapon = { desc = "magenta", item = "yellow", stats = "lightgrey" },
      body_arm = { desc = "lightblue", item = "lightcyan", stats = "lightgrey" },
      aux_arm = { desc = "lightblue", item = "yellow" },
      orb = { desc = "green", item = "lightgreen" },
      talisman = { desc = "green", item = "lightgreen" },
      misc = { desc = "brown", item = "white" },
    }, -- AlertColor

    Emoji = not BRC.Config.emojis and {} or {
      RARE_ITEM = "💎",
      ARTEFACT = "💠",
      ORB = "🔮",
      TALISMAN = "🧬",
      STAFF_RES = "🔥",

      WEAPON = "⚔️",
      RANGED = "🏹",
      POLEARM = "🔱",
      TWO_HAND = "✋🤚",

      EGO = "✨",
      ACCURACY = "🎯",
      STRONGER = "💪",
      STRONGEST = "💪💪",
      LIGHTER = "⏬",
      HEAVIER = "⏫",
    }, -- Emoji
  }, -- pickup-alert

} -- brc_config_explicit (do not remove this comment)

}
############################### End lua/config/explicit.lua ###############################
##########################################################################################

################################### Begin rc/main.rc ###################################

sound_on = true
one_SDL_sound_channel = true
sound_volume = 0.07
sound_fade_time = 2.6
# sound_pack += https://sound-packs.nemelex.cards/sdlaonline/sdlaonline.zip
sound_pack += https://osp.nemelex.cards/build/latest.zip:["init.txt"]
sound_pack += https://sound-packs.nemelex.cards/Autofire/BindTheEarth/BindTheEarth.zip

#######################
### Mini Map Colors ###
#######################
# https://pbs.twimg.com/media/G5DZ7Xka0AAer59?format=jpg&name=large
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

: if you.race() ~= "Felid" and you.race() ~= "Gargoyle" then
tile_show_player_species = true
: end

tile_player_status_icons = slow, constr, fragile, petr, mark, will/2, haste, weak, corr, might, brill, -move

cloud_status = true

action_panel_font_size = 19
action_panel_font_family = UD デジタル 教科書体 N-B
action_panel_orientation = vertical
action_panel_show = false

menu := menu_colour
# menu ^= lightgrey:potions? of (attraction|lignification|mutation)
# menu ^= lightgrey:scrolls? of (poison|torment|immolation|vulnerability|noise)

: if you.race() == "Minotaur" then
# menu ^= lightgrey:helmet
# menu ^= lightgrey: hat of
: end

msc := message_colour
msc ^= lightgrey:( miss | misses |no damage|fail to reach past|returns to the grave|disappears in a puff of smoke|putting on your|removing your)
msc ^= yellow:(You feel a bit more experienced|Something appears at your feet)

msc += mute:Search for what.*(~D|in_shop|transp)
msc += mute:There is an open door here
msc += mute:You swap places with (your|(?-i:[A-Z]))
msc += mute:(Your.*|The butterfly) leaves your sight
msc += mute:Your.*is recalled

: if you.god() == "Yredelemnul" then
msc += mute:Your.*(something|the (plant|bush|fungus|withered plant))
msc += mute:Something.*the (plant|bush|fungus|withered plant)
msc += mute:(The|A nearby) (plant|bush|fungus|withered plant).*die
msc += mute:Your.*web
msc += mute:The confined air twists around weakly and strikes your
: end

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

: if you.class() ~= "Hunter" and you.class() ~= "Hexslinger" then
autofight_fire_stop = true
: end

: if you.class() == "Hunter" or you.class() == "Hexslinger" then
autofight_fire_stop = false
: end

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

show_paged_inventory = false
item_stack_summary_minimum = 8

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

force_spell_targeter += Silence

: if you.res_shock() <= 0 then
confirm_action += Conjure Ball Lightning, Chain Lightning
: end

confirm_action += Potion Petition, Call Merchant, Blink[^bolt], Silence, Maxwell's Capacitive Coupling, Sublimation of Blood, Borgnjor's Revivification, Death's Door

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

stop ^= Your.*disappears in a puff of smoke,Your spellspark servitor fades away,Your battlesphere wavers and loses cohesion

stop += You see here the
more += You see here.*(of experience|of acquirement)
stop += - (a|[2-6]) scrolls? of brand weapon
stop += - (a|[2-7]) scrolls? of enchant weapon
stop += - (a|[2-8]) scrolls? of revelation
stop += - [2-9] scrolls labelled
stop += - [7-9] potions of mutation
stop += - [2-9] scrolls labelled
stop += - [2-9] .* potions

: if you.xl() <= 14 then
stop += You see here.*(ring of|the ring|amulet)
: end

: if you.xl() <= 16 then
stop += You see here.*(scrolls? of identify|\+6 ring of)
: end

: if you.xl() >= 12 then
stop += scroll labelled, - (a|[2-6]) .* potion
: end

: if you.xl() >= 18 then
stop += You see here.*scrolls? of enchant armour
: end

# github.com/crawl/crawl/blob/master/crawl-ref/source/god-abil.cc
more += You have reached level
more += press f on the ability menu to create your gizmo
flash += press f on the ability menu to create your gizmo
more += You (can|may) now (?!stomp|pass|merge)
more += protects you from harm
stop += You feel like a meek peon again
more += Trog grants you a weapon
more += You feel your soul grow
more += Makhleb will allow you to brand your body
flash += Makhleb will allow you to brand your body
more += dares provoke your wrath
more += Your infernal gateway subsides
more += You are dragged down into the Crucible of Flesh
more += Ru believes you are ready to make a new sacrifice
flash += Ru believes you are ready to make a new sacrifice
flash += You offer up the Black Torch's flame
more += Your bound.*is destroyed!
more += The heavenly storm settles
flash += You may now remember your ancestor's life
more += You now drain nearby creatures when transferring your ancestor

: if you.god() == "Hepliaklqana" then
more += (?-i:[A-Z])(?!xecutioner|rb guardian).*is destroyed!
: end

more += Beogh will now send orc apostles to challenge you
flash += Beogh will now send orc apostles to challenge you
more += the orc apostle comes into view
more += encounter.*the orc apostle
more += falls to his knees and submits

: if you.god() == "Beogh" then
more += (?-i:[A-Z])(?!xecutioner|rb guardian).*(dies!|is blown up!)
: end

more += has fought their way back out of the Abyss!
more += Your prayer is nearing its end
stop += Your prayer is nearing its end
more += You reach the end of your prayer and your brethren are recalled
stop += You reach the end of your prayer and your brethren are recalled
stop += You now have enough gold to
more += Your bribe of.*has been exhausted
more += Ashenzari invites you to partake
more += offers you knowledge of
flash += offers you knowledge of
more += Vehumet is now
more += You hear a faint sloshing
more += seems mollified
more += You rejoin the land of the living

# crawl.chaosforge.org/Chaos_Knight_of_Xom_Guide#Xom_rc_file
more += .* erupts in a glittering mayhem of colour
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

####################
# Dungeon Features #
####################
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/descript/features.txt

# github.com/crawl/crawl/tree/master/crawl-ref/source/dat/des/portals
# crawl.chaosforge.org/Portal
# very nearby: 7–13, nearby: 14–20, distant: 21–27, very distant: 28+
flash += timed_portal:
stop += timed_portal:
flash += You hear.*very (nearby|distant)
more += You hear.*(quick|urgent|loud (creaking of a portcullis|crackling of a melting archway)|rising multitudes|rapid|thunderous|frantic|ear-piercing|full choir)
flash += You hear.*(quick|urgent|loud (creaking of a portcullis|crackling of a melting archway)|rising multitudes|rapid|thunderous|frantic|ear-piercing|full choir)
more += Found.*(bazaar|trove|phantasmal|sand-covered|glowing drain|flagged portal|gauntlet|frozen archway|dark tunnel|crumbling gateway|ruined gateway|magical portal|ziggurat)
flash += volcano erupts with a roar
more += You enter a wizard's laboratory
more += The walls (briefly|violently) shake
more += The walls fall away. The entombed are set free!
flash += Hurry and find it
more += The walls and floor vibrate strangely for a moment
flash += The walls and floor vibrate strangely for a moment

more += Found a faded altar of an unknown god
more += Found a staircase to the Ecumenical Temple

: if you.xl() <= 10 then
flash += Found.*(Ashenzari|Beogh|Cheibriados|Fedhas|Gozag|Hepliaklqana|Ignis|Jiyva|Makhleb|Nemelex|Okawaru|Qazlal|Ru|Trog|Uskayaw|Wu Jian|Yredelemnul)
: end

: if you.xl() <= 12 and you.race() ~= "Mummy" and you.race() ~= "Demonspawn" and you.race() ~= "Revenant" and you.race() ~= "Poltergeist" and you.transform() ~= "death" and you.transform() ~= "vampire" then
flash += Found.*(Elyvilon|The Shining One|Zin)
: end

: if you.xl() <= 12 and not (you.race() == "Minotaur" or you.race() == "Troll") then
flash += Found.*(Vehumet|Sif Muna)
: end

: if you.xl() > 18 and you.race() ~= "Mummy" and you.race() ~= "Demonspawn" and you.race() ~= "Revenant" and you.race() ~= "Poltergeist" and you.transform() ~= "death" and you.transform() ~= "vampire" then
flash += Found.*(The Shining One|Zin)
: end

stop += There is a portal to a secret trove of treasure here
stop += Found a runed translucent door
flash += There is a (staircase to the (?!Ecumenical)|gate to|hole to|gate leading to|gateway (?!back|out))
more += Found a gateway leading.*Abyss
more += and a gateway leading out appears
more += The mighty Pandemonium lord.*resides here
more += The tension of great conflict fills the air

####################
# Expiring Effects #
####################
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

#############################
# Bad and Unexpected Things #
#############################
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
more += Doom befalls you[^r]
more += You feel an ill-omen
more += You feel a malign power afflict you
more += shimmers and splits apart
flash += You are too injured to fight recklessly
flash += MASSIVE DAMAGE
flash += ❗ BIG DAMAGE ❗
flash += LOW HITPOINT WARNING

: if not (you.race() == "Minotaur" or you.race() == "Troll") then
flash += LOW MAGIC WARNING
: end

more += You don't have enough magic to cast this spell
more += You fail to use your ability
more += You stop (a|de)scending the stairs
flash += You stop (a|de)scending the stairs
more += surroundings become eerily quiet
flash += surroundings become eerily quiet
flash += You hear a loud "Zot"
more += A malevolent force fills
more += An alarm trap emits a blaring wail
more += A sentinel's mark forms upon you
more += invokes.*trap
flash += invokes.*trap
more += Your surroundings flicker
more += You cannot teleport right now
more += A huge blade swings out and slices into you
more += (blundered into a|invokes the power of) Zot
more += That really hurt
more += You convulse
more += Your body is wracked with pain
flash += smites you[^r]
more += You are (blasted|electrocuted)
more += You are.*confused
more += You are blinded
flash += Something hits you[^r]
flash += You stumble backwards
flash += You are shoved backwards
flash += drags you backwards
flash += You are knocked back
# more += grabs you[^r]
flash += grabs you[^r]
# more += roots grab you[^r]
flash += roots grab you[^r]
flash += constricts you[^r]
more += You are skewered in place
flash += You are skewered in place
more += wrath finds you
more += god:(sends|finds|silent|anger)
more += You feel a surge of divine spite
more += disloyal to dabble
more += lose consciousness
more += You are too injured to fight blindly
more += You feel your attacks grow feeble
more += The blast of calcifying dust hits you[^r]
flash += The blast of calcifying dust hits you[^r]
more += Space warps horribly.*around you[^r]
more += Space bends around you[^r]
more += Your limbs are stiffening
flash += Your limbs are stiffening
more += Your body becomes as fragile as glass
more += Water floods into your lungs
flash += Water floods into your lungs
more += (?<!Your).*conjures an orb of pure magic
more += (?<!Your).*conjures a glowing orb

# Sap Magic: demonspawn warmonger
: if you.skill("Spellcasting") >= 15 then
more += Your magic feels tainted
flash += Your magic feels tainted
: end

# Malign Gateway: oklob plant annihilator, Fedhas' Mad Dash
: if you.skill("Summonings") < 15 then
more += otherworldly place is opened
: end

more += An eldritch tentacle comes into view
flash += You feel extremely sick
more += lethally poison
flash += The acid corrodes you[^r]
more += You are covered in intense liquid fire

: if you.res_draining() <= 0 then
flash += You feel drained
: end

: if you.res_shock() <= 0 then
more += You are engulfed in a thunderstorm
: end

more += You are engulfed in excruciating misery
flash += You are engulfed in dark miasma
more += You are engulfed in seething chaos
flash += You are engulfed in seething chaos
more += zaps a wand. You turn into
flash += zaps a wand. You turn into
more += You turn into a filthy swine
flash += You turn into a filthy swine
more += You feel strangely unstable
more += (?<!Your (shadowghast|vampire)) flickers and vanishes
flash += (?<!Your (shadowghast|vampire)) flickers and vanishes
more += is no longer charmed
flash += is no longer charmed
stop += is no longer charmed
more += You have lost all your
more += Chaos surges forth from piles of flesh
flash += You feel the power of Zot begin to focus
# more += You hear a sizzling splash
more += heals the

: if you.god() ~= "Nemelex Xobeh" then
more += evaporates and reforms as
: end

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

# Interrupts
more += Lucky!
more += You don't.*that spell
more += You fail to use your ability
more += You miscast.*(Blink|Borgnjor|Door|Invisibility)
flash += You miscast
more += You can't (read|drink|do)
more += You cannot.*while unable to breathe
more += You cannot.*in your current state
more += when.*silenced
more += too confused
# more += There's something in the way
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
stop += (?<!into|through) a shaft

: if you.transform() ~= "storm" then
more += You blink
: end

more += (?<!raiju) bursts into living lightning
more += blinks into view
flash += (?<!Your )draconian.*blinks!
more += is devoured by a tear in reality
more += You feel a genetic drift
# flash += You can drop.*~~DROP_ME

: if you.xl() <= 14 then
more += You feel a bit more experienced
: end

: if you.skill("Spellcasting") < 3 then
# Contam: 5000:Yellow, 15000:LightRed
more += You add the spells?.*(Summon Small Mammal|Call Imp|Call Canine Familiar|Eringya's Surprising Crocodile)

# Miscast:-Move -Tele
# reddit.com/r/dcss/comments/1m4xpsr/a_compendium_of_strange_and_unusual_techniques/
more += You add the spells?.*(Apportation|Blink|Lesser Beckoning|Maxwell's Portable Piledriver|Teleport Other|Passage of Golubria)
: end

: if you.xl() >= 27 and you.class() ~= "Conjurer" then
more += You add the spells?.*(Vhi's Electric|Manifold Assault|Fugue of the|Animate Dead|Death Channel|Awaken Armour)
: end

##########
# Skills #
##########
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
flash += You have finished (your manual|forgetting about)
more += You pick up a manual of
flash += You pick up a manual of

############
# Monsters #
############
# Uniques and baddies
# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/des/builder/uniques.des
# github.com/crawl/crawl/blob/master/crawl-ref/source/mon-gear.cc
unusual_monster_items += ( the |distortion|chaos|silver)
more += encounter.*(undying armour(y|ies)|wendigo|antique champion|torpor snail|nekomata|oblivion hound|protean progenitor|acid blob|entropy weaver|ghost moth|death knight|apocalypse crab|eyes? of devastation)(?! (zombie|draugr|simulacr))
more += The undying armouty arms its allies with

more += Xak'krixis conjures a prism
more += Nobody ignites a memory of
more += (Rupert|Snorg) goes berserk
flash += (Rupert|Snorg) goes berserk
more += BOSS
flash += BOSS
flash += changes into,Something shouts
stop += encounter Crazy Yiuf
monster_alert += pandemonium lord

# Cloud of Thunder: 60 Damage
more += Bai Suzhen roars in fury and transforms into a fierce dragon
flash += Bai Suzhen roars in fury and transforms into a fierce dragon
more += You kill.*(Bai Suzhen)
flash += You kill.*(Bai Suzhen)

# Dissolution (Slime:2-5)
# github.com/crawl/crawl/blob/master/crawl-ref/source/mon-act.cc
: if you.branch() == "Slime" then
flash += You hear a (sizzling sound|grinding noise)
: end

# Mara (S-B3-4 V2-5 Elf3 Depths)
more += Suddenly you stand beside yourself
flash += Suddenly you stand beside yourself
more += sudden wrenching feeling in your soul
flash += sudden wrenching feeling in your soul
more += 's illusion shouts
flash += 's illusion shouts

# Kirke (Lair3-5 D12-15 S-B1 Elf1), Butcher's Vault
# : if you.xl() <= 16 then
# flash += encounter.* hog
# : end

# Amaemon (Lair Orc1 D8-12)
: if you.xl() <= 16 then
more += encounter.*orange demon
flash += encounter.*orange demon
: end

# Pikel (D4-9)
: if you.xl() <= 13 then
flash += encounter.*lemure
: end

# more += encounter (?!orb guardian|executioner)(?-i:[A-Z])
flash += encounter (?!orb guardian|executioner)(?-i:[A-Z])
flash += encounter.* and (?!orb guardian|executioner)(?-i:[A-Z])

more += encounter.*(cloud mage|lernaean hydra|seraph|boundless tesseract|wretched star|neqoxec|shining eye|cacodemon|zykzyl|orb of (fire|winter|entropy))
flash += encounter.*(lernaean hydra|seraph|boundless tesseract|wretched star|neqoxec|shining eye|cacodemon|zykzyl|orbs? of (fire|winter|entropy))

# Paralysis: 5+ 33% 1T, 7+ 50% 2T
flash += encounter.*(starcursed mass)

more += the reach of Zot diminish
more += The shining eye gazes at you
flash += encounter.*(death scarab)

# Damnation/Flay
more += encounter.*(deep elf (sorcerer|high priest)|(brimstone|ice) fiend)(?! (zombie|draugr|simulacr))
flash += encounter.*(deep elf (sorcerer|high priest)|(brimstone|ice) fiend)(?! (zombie|draugr|simulacr))
more += encounter.*(hell sentinel|hellion|draconian scorcher|flayed ghost)
flash += encounter.*(hell sentinel|hellion|draconian scorcher|flayed ghost)

# Torment/Drain Life/Siphon Essence
: if not (you.race() == "Mummy" or you.race() == "Revenant" or you.race() == "Poltergeist" or you.transform() == "death") then
more += encounter.*(royal mumm|mummy priest|tzitzimitl)
flash += encounter.*(royal mumm|mummy priest|tzitzimitl)
more += encounter.*(tormentor|curse toe|curse skull)
flash += encounter.*(tormentor|curse toe|curse skull)
more += encounter.*(deathcap|soul eater|vampire bloodprince|alderking)
flash += encounter.*(deathcap|soul eater|vampire bloodprince|alderking)
more += The curse toe gestures
: end

# Holy/Dispel Undead
: if you.race() == "Mummy" or you.race() == "Demonspawn" or you.race() == "Revenant" or you.race() == "Poltergeist" or you.transform() == "death" or you.transform() == "vampire" then
flash += encounter.*(?<!angel|daeva|fravashi) is wielding.*of holy
more += encounter.*(demonspawn black sun|revenant soulmonger|ushabti|alderking|burial acolyte)
: end

: if you.branch() ~= "Pandemonium" and you.race() == "Mummy" or you.race() == "Demonspawn" or you.race() == "Revenant" or you.race() == "Poltergeist" or you.transform() == "death" or you.transform() == "vampire" then
more += encounter.*(angel|daeva|fravashi)
flash += encounter.*(angel|daeva|fravashi)
: end

# Lee's Rapid Deconstruction
: if you.race() == "Gargoyle" or you.race() == "Revenant" or you.transform() == "statue" then
more += encounter.*(kobold geomancer|deep elf elementalist|deep troll earth mage)
: end

# crawl.chaosforge.org/Reaching
# orange demon, goliath frog, snapping turtle, alligator snapping turtle, crawling flesh cage, Cigotuvi's Monster, Geryon, Serpent of Hell (Dis)

: if you.xl() <= 26 then
more += encounter.*(chonchon|oni incarcerator|undertaker|demonspawn warmonger|draconian stormcaller|(ancient|dread) lich)
# New Slime Monsters
more += encounter.*(morphogenic ooze|slymdra|colossal amoeba|creeping plasmodi(um|a)|star jell(y|ies)|eyes? of draining)
more += The.*headed slymdra grows
flash += The.*headed slymdra grows
more += A flurry of magic pours from the star jelly's injured body!
flash += A flurry of magic pours from the star jelly's injured body!
: end

: if you.xl() <= 24 then
more += (hits|warns) you[^r].*of (distortion|chaos)
more += encounter.*(air elemental|tengu reaver|(deep elf|draconian) annihilator|void ooze|orb guardian)(?! (zombie|draugr|simulacr))
more += encounter.*(?<!spectral) (lich|shadow dragon|walking.*tome|juggernaut|caustic shrike|wyrmhole|spriggan berserker)(?! (zombie|draugr|simulacr))
flash += encounter.*(spriggan berserker)(?! (zombie|draugr|simulacr))
more += The spriggan berserker utters an invocation to Trog
more += The spriggan roars madly and goes into a rage
# Agony
more += encounter.*(imperial myrmidons|necromancer)(?! (zombie|draugr|simulacr))
flash += encounter.*(imperial myrmidons|necromancer)(?! (zombie|draugr|simulacr))
: end

: if you.xl() <= 22 then
more += encounter.*(glass eye|death drake|war gargoyle|crystal guardian)
more += encounter.*(deep elf master archer|vault (warden|sentinel)|merfolk (avatar|siren))(?! (zombie|draugr|simulacr))
more += encounter.*(executioner|guardian serpent|draconian shifter|ironbound (convoker|preserver)|deep troll shaman|death cob)(?! (zombie|draugr|simulacr))
more += encounter.*(bone dragon|kobold fleshcrafter|phantasmal warrior|iron giant)(?! (zombie|draugr|simulacr))
more += encounter.*(ragged hierophant|halazid warlock|glowing orange brain|moths? of wrath)(?! (zombie|draugr|simulacr))
flash += encounter.*(halazid warlock)(?! (zombie|draugr|simulacr))
more += encounter.*(player|('s|s')) ghost
stop += encounter.*(player|('s|s')) ghost
more += guardian serpent weaves intricate patterns
more += ironbound convoker begins to recite a word of recall
more += kobold fleshcrafter chants and writhes
more += halazid warlock gestures
more += ironbound mechanist forges a skittering defender to stand by its side
# more += slime creatures merge to form a (very large|enormous|titanic)
more += slime creatures merge to form a (normous|titanic)
flash += slime creatures merge to form a (very large|enormous|titanic)
: end

: if you.xl() <= 20 then
more += encounter.*(boggart|bunyips|deep elf elementalist|balrug|stone giant|ironbound beastmaster)(?! (zombie|draugr|simulacr))
more += encounter.*(formless jellyfish|broodmother|spark wasp|orb spider|merfolk (aquamancer|javelineer|impaler)|nagaraja)(?! (zombie|draugr|simulacr))
# Paralysis/Petrify/Banish
more += encounter.*(fenstrider witch|orc sorcerer|ogre mage|occultist|great orbs? of eyes|sphinx)(?! (zombie|draugr|simulacr))
more += encounter.*(?<!spectral) (jorogumo|basilisk|catoblepa(s|e)|deep elf (sorcerer|demonologist)|vampire knight)(?! (zombie|draugr|simulacr))
flash += The boggart gestures wildly while chanting
: end

: if you.xl() <= 18 then
more += encounter.*(water nymph|azure jell|anaconda|shambling mangrove|thorn hunter|bloated husk|ghost crab|ironbound thunderhulk|polterguardian)(?! (zombie|draugr|simulacr))
flash += The water rises up and strikes you
more += Thorny briars emerge from the ground
: end


# github.com/crawl/crawl/commit/e02c2b2bd47e38273f95c7b2855e43783a19ae70
unusual_monster_items += vulnerable:acid:26
unusual_monster_items += vulnerable:(draining|vampiric):24
unusual_monster_items += vulnerable:(electrocution|flaming|freezing|pain):22
unusual_monster_items += vulnerable:(venom):20

: if you.xl() <= 16 then
unusual_monster_items += of (acid)
more += encounter.*(raven|smoke demon|water elemental|(fire|ice) dragon|centaur warrior|yaktaur|cyclope?s|hydra|orc (warlord|high priest)|salamander (mystic|tyrant)|naga ritualist|spriggan druid|eleionomae?|rakshasa)(?! (zombie|draugr|simulacr))
more += The.*headed hydra grows
flash += The.*headed hydra grows

more += encounter.*(vault guard|deep elf|kobold blastminer|gargoyle|ghoul|hell hog|dire elephant|skyshark|freezing wraith|shock serpent|arcanist|radroach|tarantella|pharaoh ant|wolf spider|tentacled starspawn)(?! (zombie|draugr|simulacr))
flash += encounter.*(raiju|(cyan|brown) ugly thing|radroach|meliai)(?! (zombie|draugr|simulacr))
: end
: if you.xl() <= 13 then
unusual_monster_items += of (paralysis|roots|light)
unusual_monster_items += of (draining|vampiric|spectral|\+[5-9]), heavy
more += encounter.*(?<!spectral) (manticore|two-headed ogre|kobold geomancer|tengu|lindwurm|(ice|rust) devil|(fire|earth) elemental|lava snake|efreet|boulder beetle|hornet|black mamba|cane toad|komodo dragon|skyshark)(?! (zombie|draugr|simulacr))
flash += encounter.*(skeletal warrior|death yak|elephant)(?! (zombie|draugr|simulacr))
: end

: if you.xl() <= 10 then
unusual_monster_items += (devious|valour|concussion|sundering|rebuke)
unusual_monster_items += of (electrocution|flaming|freezing|pain)
unusual_monster_items += of (venom|charming|polymorph)
unusual_monster_items += triple sword,executioner's axe,halberd,glaive,bardiche,arbalest,hand cannon,triple crossbow
unusual_monster_items += great sword,demon trident,partisan,trishula,longbow
more += encounter.*(weeping skull|drude|water moccasin|rime drake|(steam|acid) dragon|wyvern|polar bear|brain worm|queen bee|wraith|gnoll bouda|centaur)(?! (zombie|draugr|simulacr))
more += The polar bear roars madly and goes into a rage
flash += encounter.*(wight|yak|vampire mosquito)(?! (zombie|draugr|simulacr))
: end

: if you.xl() <= 7 then
# unusual_monster_items += spear,(?<!demon) trident,sling,shortbow,orcbow
more += encounter.*(?<!spectral) (marrowcuda|phantom|bombardier beetle|ice beast|jell(y|ies)|iguana|hound|black bear|sky beast|electric eel|sleepcap)(?! (zombie|draugr|simulacr))
more += The black bear roars madly and goes into a rage
more += encounter.*(ogre|gnoll|orc (wizard|priest|warrior))(?! (zombie|draugr|simulacr))
flash += encounter.*(ogre|gnoll|orc (wizard|priest|warrior))(?! (zombie|draugr|simulacr))
flash += encounter.*(killer bee)(?! (zombie|draugr|simulacr))
: end

: if you.xl() <= 4 and you.race() ~= "Gargoyle" and you.race() ~= "Revenant" and you.race() ~= "Poltergeist" and you.race() ~= "Mummy" and you.race() ~= "Djinni" then
more += encounter.*(adder)(?! (zombie|draugr|simulacr))
: end

: if you.xl() <= 4 then
more += encounter.*(orc)(?! (zombie|draugr|simulacr))
monster_alert += tough
: end

# : if you.xl() <= 1 then
# more += encounter.*(goblin|kobold|ball python|ribbon worm|dart slug)(?! (zombie|draugr|simulacr))
# flash += encounter.*(jackal)(?! (zombie|draugr|simulacr))
# : end

##############
### Morgue ###
##############
dump_on_save = true
dump_message_count = 1000
note_hp_percent = 20
user_note_prefix = 

note_items += of experience,(?<!potions?) of resistance,archmagi,crystal plate armour,pearl dragon scales
note_messages += You pass through the gate
note_messages += cast.*Abyss
note_messages += BOSS, Dungeon Descent, Dungeon Sprint
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

autopickup = $?!+:"/}(♦
ae := autopickup_exceptions
ae += <rune of

ae = <of noise

# : if not (you.race() == "Mummy" or you.race() == "Revenant" or you.race() == "Poltergeist") then
# ae = <of mutation, of lignification, granite talisman, talisman of death
# : end

# : if you.god() == "Trog" then
# ae = <of amnesia, of brilliance
# : end

# : if you.xl() <= 26 and you.god() == "Okawaru" then
# ae = <butterflies, summoning, phantom mirror, horn of Geryon, box of beasts, sack of spiders
# : end

: if you.xl() <= 13 and (you.god() == "The Shining One" or you.god() == "Elyvilon" or you.god() == "Zin") then
stop += You see here.*of (necromancy|pain|reaping|draining|distortion|vampiric)
stop += You see here.*demon
: end

: if you.xl() <= 13 and you.race() ~= "Djinni" and (you.god() == "The Shining One" or you.god() == "Elyvilon" or you.god() == "Zin") then
ae = <Necromancy, Call Imp, Sculpt Simulacrum, Malign Gateway, Summon Horrible Things
: end

# : if you.race() ~= "Djinni" and (you.god() == "Okawaru" or you.god() == "Trog") then
# ae = <book of, parchment of
# : end

# ae += moonshine

: if you.race() ~= "Troll" and you.race() ~= "Oni" then
ae += large rock
: end

: if you.race() == "Coglin" then
ae += amulet, ring of
: end

: if you.race() == "Djinni" then
ae += book of, parchment of
: end

: if you.race() == "Minotaur" then
stop += You see here.* hat of
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
ae += of identify, poisoned dart, amulet of (acrobat|faith|guardian spirit|reflection|alchemy|dissipation|wildshape), ring of (evasion|strength|intelligence|dexterity|slaying|wizardry|magical power)
: end

################
# Inscriptions #
################
# crawl.chaosforge.org/Inscriptions
ai := autoinscribe

# ai += magical staff:!a
ai += (throwing net|(curare|datura|atropa)-tipped dart|of disjunction):=f

ai += potions? of heal wounds:@q1, 10-37HP
ai += potions? of curing:@q2, 5-11HP
ai += potions? of cancellation:@q3, UnaffectDrainBarbPoisBerserkDDoorExhGodEffects
ai += potions? of might:34-74T 1d10
ai += potions? of haste:@q4, 40-79T
ai += potions? of magic:@q5, 10-37MP
ai += potions? of mutation:@q6, Remove2-3 Add1-3, 60%Good, 50%AddOneGood
ai += potions? of ambrosia:3-5HPMP/T
ai += potions? of lignification:1.5xHP (20+XL/2)AC rPo Torm0 Ev0 -MoBlTe GearWeapShie
ai += potions? of enlightenment:25-64T
ai += potions? of invisibility:15-54T, MonsSH/3, HuInt+8%Pos, -6EV -6ToHit Block/3
ai += potions? of resistance:10-29T, rFirColPoiCorEle
ai += potions? of berserk rage:10-19T, ImmuneSleep

ai += scrolls? of identify:@r1, 26%Iden 13%Common 4.7%Uncom, 18.4%Curi 10%Common 6.4%Uncom
ai += scrolls? of teleportation:@r2, 3-5T, Zot8-14T
ai += scrolls? of blinking:@r3, UnableTreeMesm-Tele
ai += scrolls? of acquirement:200-1400Gold
ai += scrolls? of enchant armour:@r4, GDR AC6Scale25% 10Plate28.5% 32+10PlateAux38%
ai += scrolls? of enchant weapon:@r5, ToHit Dex/2+1d(FighS+1)+1d(WeaS+1)

# Allow brand weapon scrolls (and randarts) to produce the new brands
# github.com/crawl/crawl/commit/092f012dacd1664b29e7f4c764571602c4b3ef34
ai += scrolls? of brand weapon:13.3% FlmFrzHvVnPro, 6.6% DrnElcSpcVmpChaos

ai += scrolls? of fear:Q*f, 40Will90% 60Will73% ++41-80
ai += scrolls? of silence:30Turns
ai += scrolls? of noise:25 Alarm40 FireStor25 FulmPris20 Qaz16 Shout12 IMB10
ai += scrolls? of immolation:Tiny3d15 Little-Large3d20 Giant3d25, 25-35T
ai += scrolls? of torment:-10%N+
ai += scrolls? of summoning:Mons2d2, NamelessH HD(2*MiscastIntensity/3) Spd10 AC8 Ak30
ai += scrolls? of butterflies:12-28, Immo3d15, NamelessH HD(2*MiscastIntensity/3) Spd10 AC8 Atk30
ai += scrolls? of revelation:Necropolis900, Gauntlet400, Others600
ai += scrolls? of fog:AtkOut ExploIceblaTremor AlliNeuCharmBribFrenMons TukimPoisSticF
ai += scrolls? of amnesia:Intensity (SpellLv)d(SpellLv+Failure)/9, Contam 2x(SpellLv)^2xFailure+250

ai += wand of roots:@v1, \<, 2d(5.7+Evo/2)DmgT 3((15+3.5Evo)/22 To 4+((15+3.5Evo)/16)T
ai += wand of warping:@v1, \<, 50+3.5Evo% MaxEvo12
ai += wand of iceblast:@v1, \<, 3d(7.66+3.5*Evo/5)
ai += wand of acid:@v2, \>, 4d(5.5+10.5xEvo/20)
ai += wand of light:@v2, \>, -35%ToHit
ai += wand of quicksilver:@v2, \>, 6d(4.16+3.5*Evo/9)
ai += wand of digging:@v3

# Enemy AC 2 (gnoll), Dizzy's DCSS Doodad, Mulch%
# https://pastebin.com/raw/2DKqrVha
ai += (?<!tremor)stone:Dmg/T 0.4 1 3 Thr 0 3 6
ai += boomerang:@f2@Q2, F2, 5%
ai += (?<!silver) javelin:@f3@Q3, H, 5%
ai += silver javelin:@f6@Q6, 5%
ai += throwing net:@f7, MonsEV/(2+Size), Mulch (1d4)/9% 8Dmg (1d4)/T 
ai += poisoned dart:@f1@Q1, F1
ai += curare-tipped dart:@f8, 16.7%
ai += darts? of disjunction:, Dmg2d2

ai += wand of flame:@v4@Q4, \), 2d(5.5+0.35*Evo), MaxEvo10
ai += wand of mindburst:@v5@Q5, \(, 3d(8.75+3.5*Evo/4)
ai += phial of floods:(2.1+2*Evo/5)Turns x1 x1.5
ai += sack of spiders:Evo 6 13 18 21
ai += box of beasts:HD 3 9 15 21 27(Evo+1d7-1d7)
ai += condenser vane:(65+3.5*Evo)/1.6%
ai += tin of tremorstones:Evo 2.5 6 11 18, 5x5 6d6 40%
ai += lightning rod:(2+PreUses)d(0.75*Evo+46.25)/3, 2d16(Evo1)
ai += Gell's gravitambourine:Evo 9.5 23.2
ai += flux bauble:5-14 -WeapShieBodyGlov, !v

ai += of fire resistance:rF+
ai += of cold resistance:rC+
ai += (?<!potions?) of resistance:rF+, rC+
ai += of poison resistance:rPois
ai += of corrosion resistance:rCorr
ai += of positive energy:rN+
ai += of willpower:Will+
ai += of invulnerability:rInv
ai += of regeneration:Regen+
ai += of magic regeneration:MRegen+

ai += fire dragon scales (?!"|of):rF++, rC-
ai += ice dragon scales (?!"|of):rC++, rF-
ai += swamp dragon scales (?!"|of):rPois
ai += gold dragon scales (?!"|of):rC+, rF+, rPois
ai += acid dragon scales (?!"|of):rCorr
ai += storm dragon scales (?!"|of):rElec
ai += pearl dragon scales (?!"|of):rN+
ai += quicksilver dragon scales (?!"|of):Will+
ai += shadow dragon scales (?!"|of):Stlth+
ai += (?<!moon) troll leather (?!"|of):Regen+
ai += \+(Inv|Blink) :17% 12% 4% Evo 3 5 9

ai += ring of flight:+Fly
ai += ring of protection from fire:rF+
ai += ring of protection from cold:rC+
ai += ring of resist corrosion:rCorr
ai += ring of see invisible:sInv
ai += ring of wizardry:Wiz+
ai += ring of magical power:MP+9

# github.com/crawl/crawl/tree/master/crawl-ref/source/dat/forms
ai += protean talisman:Shp 6 ScarabRimehornSporeMedusa
ai += inkwell talisman:0-7 -WeapShieAllArmo, !P
ai += quill talisman:0-7 -Aux, !P
ai += scarab talisman:8-14 -WeapShieAllArmo, !P
ai += rimehorn talisman:8-14 -WeapShieAllArmo, !P
ai += spore talisman:8-14 -OffhanBoot, !P
ai += medusa talisman:8-14 -HelmCloa, !P
ai += spider talisman:12-20 -WeapShieAllArmo, !P
ai += serpent talisman:12-20 -WeapOffhanBodyGlovBootCloaBard, !P
ai += lupine talisman:12-20 -GlovBootBard, !P
ai += eel talisman:12-20 -WeapShieGlov, !P
ai += wellspring talisman:12-20 -Body, !P
ai += fortress talisman:12-20 -OffhanAux, !P
ai += maw talisman:12-20 -BodyAC, !P
ai += dragon-coil talisman:17-25 -WeapShieAllArmo, !P
ai += granite talisman:17-25 -BodyGlovBootBard, !P
ai += riddle talisman:17-25 -WeapOffhanBodyHelmGlovBoot, !P
ai += hive talisman:17-25 -BodyHelm, !P
ai += sanguine talisman:17-25, !P
ai += blade talisman:17-25 -BodyAC, !P
ai += storm talisman:23-27 -WeapShieAllArmo, !P
ai += talisman of death:26-27, !P

ai += staff of conjuration:IrresistibleDmg-20%
ai += staff of earth:PhysicalDmg-5%
ai += staff of fire:rF+
ai += staff of cold:rC+
ai += staff of alchemy:rPois
ai += staff of air:rElec
ai += staff of necromancy:rN+

: if you.xl() > 4 then
ai += (?<!the) \+0 (dagger|short sword|club|whip|giant club|giant spiked|hand axe|spear|sling|shortbow|(?<!tremor)stone|animal skin|robe|leather armour) (?!"|of):~~DROP_ME
: end

: if you.xl() > 8 then
ai += (?<!the) \+0 (falchion|long sword|quarterstaff|troll leather armour|ring mail|scale mail) (?!"|of):~~DROP_ME
: end

: if you.xl() > 12 then
ai += (?<!the) \+[1-3] (dagger|short sword|club|whip|hand axe|spear|sling|shortbow|animal skin|robe|leather armour) (?!"|of):~~DROP_ME
: end

: if you.xl() > 14 then
ai += (?<!the) \+[1-3] (falchion|long sword|quarterstaff|troll leather armour|ring mail|scale mail) (?!"|of):~~DROP_ME
: end

: if you.xl() > 16 then
ai += (?<!the) \+0 (mace|hammer|flail|dire flail|war axe|trident|halberd|chain mail|plate armour|steam dragon scales|helmet) (?!"|of):~~DROP_ME
: end

: if you.xl() > 20 then
ai += (?<!the) \+0 (great mace|battleaxe|executioner's axe|scythe|glaive|bardiche|buckler|pair of boots|cloak|pair of gloves|acid dragon scales|swamp dragon scales) (?!"|of):~~DROP_ME
: end

: if you.xl() > 22 then
ai += (?<!the) \+0 (kite shield|fire dragon scales|ice dragon scales) (?!"|of):~~DROP_ME
ai += of identify:~~DROP_ME
: end

: if you.xl() > 24 then
ai += (?<!the) \+0 (morningstar|broad axe|partisan|tower shield) (?!"|of):~~DROP_ME
: end

##################
### Item Slots ###
##################
gear_slot ^= (war axe|broad axe|whip|mace|flail|ningstar|scourge|spear|trident|trishula|partisan|halberd|glaive|bardiche) : abW
gear_slot ^= (ring of protection (?!from)|the ring .* AC\+) : ptcmPTCM
gear_slot ^= (ring of evasion|the ring .* EV\+) : edgvEDGV
gear_slot ^= (ring of strength|the ring .* Str\+) : strhSTRH
gear_slot ^= (ring of intelligence|the ring .* Int\+) : intlINTL
gear_slot ^= (ring of dexterity|the ring .* Dex\+) : dxeyDXEY
gear_slot ^= (ring of slaying|the ring .* Slay\+) : yksxYKSX
gear_slot ^= (ring of wizardry|the ring .* Wiz ) : zwysZWYS
gear_slot ^= (ring of magical power|the ring .* MP\+) : mpgqMPGQ
gear_slot ^= (ring of protection from fire|the ring .* rF\+) : fireFIRE
gear_slot ^= (ring of protection from cold|the ring .* rC\+) : cieoCIEO
gear_slot ^= (ring of positive energy|the ring .* rN\+) : nuveNUVE
gear_slot ^= (ring of poison resistance|the ring .* rPois) : pxtvPXTV
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
gear_slot ^= flux bauble:ABCDEFGHIJKLMNOPQRSTUVWXYZ

# github.com/crawl/crawl/blob/master/crawl-ref/source/dat/defaults/consumable_shortcuts.txt
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
# feat:find("transporter")
# [NP.]: one key macro for going both up and down stairs
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

# Tab:\{9}, Enter:\{13}, Esc:\{27}, Space:\{32}, Ctrl:*, Shift:/, Backspace:\{8}

# List of Banes
# macros += M \ ?/n\{32}\{13}

# Ctrl-L: Help, Monster 
macros += M \{12} ?/m

# [.]: Branches
macros += M . *f<<case\{32}to\{32}th\{32}||\{32}gate\{32}to\{32}||\{32}hole\{32}to\{32}||\{32}gate\{32}lead>>\{32}&&\{32}!!one-\{13}

# Ctrl-D (Go down closest stairs w/ {Cntl-G, '>'})
macros += M \{4} \{7}>

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

# [,]: @<query>, Stash-Tracker, Search Character Limit:835
# !!:Negate, &&:AND, ||:OR, <<>>:Grouping
: if you.xl() <= 9 and (you.race() == "Minotaur" or you.race() == "Troll" or you.class() == "Fighter" or you.class() == "Berserker") then
macros += M , *f@\{32}&&\{32}!!transp\{32}&&\{32}!!stair\{32}&&\{32}!!hatc\{32}&&\{32}!!trap\{32}&&\{32}!!gate\{32}&&\{32}!!door\{32}&&\{32}!!anim\{32}&&\{32}!!0\{32}robe\{32}&&\{32}!!a\{32}leat\{32}&&\{32}!!a\{32}ring\{32}ma\{32}&&\{32}!!a\{32}scal\{32}&&\{32}!!a\{32}chai\{32}&&\{32}!!a\{32}plat\{32}&&\{32}!!a\{32}buck\{32}&&\{32}!!a\{32}cloa\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}ham\{32}&&\{32}!!grea\{32}&&\{32}!!gian\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}trid\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battl\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!rang\{32}&&\{32}!!blad\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

: if you.xl() >= 10 and you.xl() <= 16 and (you.race() == "Minotaur" or you.race() == "Troll" or you.class() == "Fighter" or you.class() == "Berserker") then
macros += M , *f@\{32}&&\{32}!!transp\{32}&&\{32}!!stair\{32}&&\{32}!!hatc\{32}&&\{32}!!trap\{32}&&\{32}!!gate\{32}&&\{32}!!door\{32}&&\{32}!!quart\{32}&&\{32}!!rang\{32}&&\{32}!!blad\{32}&&\{32}!!club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}ham\{32}&&\{32}!!grea\{32}&&\{32}!!gian\{32}&&\{32}!!nd\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!spea\{32}&&\{32}!!0\{32}trid\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battl\{32}&&\{32}!!anim\{32}&&\{32}!!robe\{32}&&\{32}!!leat\{32}&&\{32}!!a\{32}ring\{32}ma\{32}&&\{32}!!a\{32}scal\{32}&&\{32}!!a\{32}chai\{32}&&\{32}!!a\{32}plat\{32}&&\{32}!!a\{32}buck\{32}&&\{32}!!a\{32}cloa\{32}&&\{32}!!orb\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

: if you.xl() >= 17 and (you.race() == "Minotaur" or you.race() == "Troll" or you.class() == "Fighter" or you.class() == "Berserker") then
macros += M , *f@\{32}&&\{32}!!transp\{32}&&\{32}!!stair\{32}&&\{32}!!hatc\{32}&&\{32}!!trap\{32}&&\{32}!!gate\{32}&&\{32}!!door\{32}&&\{32}!!quart\{32}&&\{32}!!rang\{32}&&\{32}!!blad\{32}&&\{32}!!club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!r\{32}ax\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!ham\{32}&&\{32}!!0\{32}flai\{32}&&\{32}!!grea\{32}&&\{32}!!gian\{32}&&\{32}!!dire\{32}&&\{32}!!nd\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!spea\{32}&&\{32}!!0\{32}trid\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battl\{32}&&\{32}!!mail\{32}&&\{32}!!0\{32}chai\{32}&&\{32}!!0\{32}plat\{32}&&\{32}!!0\{32}buck\{32}&&\{32}!!a\{32}cloa\{32}&&\{32}!!anim\{32}&&\{32}!!robe\{32}&&\{32}!!leat\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

: if you.race() ~= "Minotaur" and you.race() ~= "Troll" and you.class() ~= "Fighter" and you.class() ~= "Berserker" then
macros += M , *f@\{32}&&\{32}!!transp\{32}&&\{32}!!stair\{32}&&\{32}!!hatc\{32}&&\{32}!!trap\{32}&&\{32}!!gate\{32}&&\{32}!!door\{32}&&\{32}!!anim\{32}&&\{32}!!a\{32}robe\{32}&&\{32}!!a\{32}leat\{32}&&\{32}!!a\{32}ring\{32}ma\{32}&&\{32}!!a\{32}scal\{32}&&\{32}!!a\{32}chai\{32}&&\{32}!!a\{32}plat\{32}&&\{32}!!a\{32}buck\{32}&&\{32}!!a\{32}cloa\{32}&&\{32}!!0\{32}dagg\{32}&&\{32}!!0\{32}shor\{32}&&\{32}!!0\{32}rapie\{32}&&\{32}!!0\{32}falc\{32}&&\{32}!!0\{32}long\{32}\{32}&&\{32}!!0\{32}grea\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}ham\{32}&&\{32}!!gian\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}trid\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battl\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
: end

# [P]: Shop Items
: if you.race() == "Minotaur" or you.race() == "Troll" or you.class() == "Fighter" or you.class() == "Berserker" then
macros += M P *fin_shop\{32}&&\{32}!!rang\{32}&&\{32}!!blad\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}ham\{32}&&\{32}!!gian\{32}&&\{32}!!dire\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}trid\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battl\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!anim\{32}&&\{32}!!0\{32}robe\{32}&&\{32}!!0\{32}leat\{32}&&\{32}!!0\{32}ring\{32}ma\{32}&&\{32}!!0\{32}scal\{32}&&\{32}!!a\{32}chai\{32}&&\{32}!!a\{32}plat\{32}&&\{32}!!0\{32}buck\{32}&&\{32}!!a\{32}cloa\{32}&&\{32}!!book\{32}&&\{32}!!parchm\{32}&&\{32}!!carri\{13}
: end

: if you.race() ~= "Minotaur" and you.race() ~= "Troll" and you.class() ~= "Fighter" and you.class() ~= "Berserker" then
macros += M P *fin_shop\{32}&&\{32}!!0\{32}dagg\{32}&&\{32}!!0\{32}shor\{32}&&\{32}!!0\{32}rapie\{32}&&\{32}!!0\{32}falc\{32}&&\{32}!!0\{32}long\{32}\{32}&&\{32}!!0\{32}grea\{32}&&\{32}!!0\{32}sling\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}ham\{32}&&\{32}!!gian\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}trid\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battl\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!anim\{32}&&\{32}!!0\{32}robe\{32}&&\{32}!!a\{32}leat\{32}&&\{32}!!a\{32}ring\{32}ma\{32}&&\{32}!!a\{32}scal\{32}&&\{32}!!a\{32}chai\{32}&&\{32}!!a\{32}plat\{32}&&\{32}!!a\{32}buck\{32}&&\{32}!!a\{32}cloa\{32}&&\{32}!!carri\{13}
: end

macros += M S *f<<scrol\{32}||\{32}potio>>\{32}&&\{32}!!iden\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
macros += M % *f<<misc\{32}||\{32}wand\{32}||\{32}throwin>>\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
macros += M " *f<<jewell\{32}||\{32}orb>>\{32}&&\{32}!!statu\{32}&&\{32}!!carri\{13}

# "[": Body, Aux
macros += M [ *f<<body\{32}||\{32}aux>>\{32}&&\{32}!!orb\{32}&&\{32}!!anim\{32}&&\{32}!!a\{32}robe\{32}&&\{32}!!a\{32}leat\{32}&&\{32}!!a\{32}ring\{32}ma\{32}&&\{32}!!a\{32}scal\{32}&&\{32}!!a\{32}chai\{32}&&\{32}!!a\{32}plat\{32}&&\{32}!!a\{32}buck\{32}&&\{32}!!a\{32}cloa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}

# [`]: Dexterity Weapons, Magical Staves
macros += M ` *f<<ranged\{32}||\{32}blades\{32}||\{32}magica>>\{32}&&\{32}!!jewell\{32}&&\{32}!!0\{32}dagg\{32}&&\{32}!!0\{32}shor\{32}&&\{32}!!0\{32}rapie\{32}&&\{32}!!0\{32}falc\{32}&&\{32}!!0\{32}long\{32}\{32}&&\{32}!!0\{32}grea\{32}&&\{32}!!0\{32}sling\{32}&&\{32}!!body\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}

# [&]: Axes, Cross-Trained Weapons
macros += M & *f<<axe\{32}||\{32}polea\{32}||\{32}mace>>\{32}&&\{32}!!magica\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}ham\{32}&&\{32}!!gian\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}trid\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battl\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}

# [_]: Maces & Flails, Cross-Trained Weapons
macros += M _ *f<<mace\{32}||\{32}axe\{32}||\{32}stav>>\{32}&&\{32}!!magica\{32}&&\{32}!!0\{32}club\{32}&&\{32}!!0\{32}whip\{32}&&\{32}!!0\{32}mace\{32}&&\{32}!!0\{32}ham\{32}&&\{32}!!gian\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}

# [:]: Polearms, Cross-Trained Weapons
: if you.xl() <= 16  then
macros += M : *f<<polea\{32}||\{32}axe\{32}||\{32}stav>>\{32}&&\{32}!!magica\{32}&&\{32}!!0\{32}spea\{32}&&\{32}!!0\{32}trid\{32}&&\{32}!!0\{32}halb\{32}&&\{32}!!0\{32}glai\{32}&&\{32}!!0\{32}battl\{32}&&\{32}!!0\{32}hand\{32}ax\{32}&&\{32}!!0\{32}war\{32}&&\{32}!!0\{32}broa\{32}&&\{32}!!~D\{32}&&\{32}!!carri\{13}
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

# : if you.class() == "Conjurer" or you.class() == "Fire Elementalist" or you.class() == "Air Elementalist" or you.class() == "Earth Elementalist" then
# macros += M \{9} zaf
# : end

macros += M E zbf
macros += M U zcf
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
# "K2" targeting context keymap (during targeting and `x` view)
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
bindkey = [-] CMD_GAME_MENU
bindkey = [NP5] CMD_WAIT
bindkey = [NP5] CMD_TARGET_SELECT_ENDPOINT
bindkey = [B] CMD_EXPLORE_NO_REST
bindkey = [s] CMD_REST
bindkey = [c] CMD_CLOSE_DOOR
bindkey = [C] CMD_MAP_CLEAR_EXCLUDES
bindkey = [W] CMD_WIELD_WEAPON
bindkey = [w] CMD_WEAR_ARMOUR
bindkey = [p] CMD_WEAR_JEWELLERY

: if you.class() ~= "Conjurer" and  you.class() ~= "Fire Elementalist" and you.class() ~= "Air Elementalist" and you.class() ~= "Earth Elementalist" then
bindkey = [Tab] CMD_AUTOFIGHT_NOMOVE
: end

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
bindkey = [\{NP-}] CMD_MAP_FIND_UPSTAIR
bindkey = [\{NP+}] CMD_MAP_FIND_DOWNSTAIR
bindkey = [\{NP/}] CMD_MAP_PREV_LEVEL
bindkey = [\{NP*}] CMD_MAP_NEXT_LEVEL
bindkey = [\{NP/}] CMD_CYCLE_QUIVER_BACKWARD
bindkey = [\{NP*}] CMD_CYCLE_QUIVER_FORWARD
bindkey = [\{8}] CMD_SWAP_QUIVER_RECENT
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

# github.com/brianfaires/crawl-rc?tab=readme-ov-file#in-game-commands
bindkey = [~] CMD_LUA_CONSOLE

############################### End rc/main.rc ###############################

############################ Begin lua/my-feature.lua ############################
{
my_feature = {}
my_feature.BRC_FEATURE_NAME = "my-feature" -- This registers my_feature with BRC

my_feature.Config = {
} -- always put a comment after a lone '}' (or else crawl's RC parser breaks)

local need_skills_opened = true
function my_feature.ready()
if you.turns() == 0 and you.race() ~= "Gnoll" and you.race() ~= "Djinni" and need_skills_opened then
need_skills_opened = false
crawl.sendkeys("!d4" .. string.char(13) .. "T:D4-7" .. string.char(13))
crawl.sendkeys("!d10" .. string.char(13) .. "L D11-12 O D13- S V4 E U/V5/C M Z4 Zig7" .. string.char(13))
crawl.sendkeys("!d11" .. string.char(13) .. "Ice:L D11-13 O, Vol:L O, Gau:L D11- O" .. string.char(13))
crawl.sendkeys("!d12" .. string.char(13) .. "Rup:D12- L3- O P1 N1, Tro:D12- S" .. string.char(13))
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
############################ End lua/my-feature.lua ############################

################################### Begin rc/fm-messages.rc ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
more := force_more_message
flash := flash_screen_message

# Almost worth removing
#force_more_message -= You bow before the missionary of Beogh
#force_more_message -= You .* the altar of

# Remove annoying defaults
# more -= You have reached level
more -= Marking area around .* as unsafe
more -= welcomes you( back)?!
more -= upon you is lifted
# more -= You pick up the .* gem and feel its .* weight
# more -= You pick up the .* rune and feel its power
more -= need to enable at least one skill for training
more -= Okawaru grants you throwing weapons
more -= Okawaru offers you a choice
more -= You can now deal lightning-fast blows
more -= The lock glows eerily
more -= Heavy smoke blows from the lock
more -= The gate opens wide
more -= With a soft hiss the gate opens wide
more -= You finish merging with the rock

# Significant spells/effects ending
flash += You feel stable
# Death's Door
more += time is.*running out
more += life is in your own
# Death channel
more += unholy channel is weakening

# Monsters doing things
more += monster_warning:wielding.*of distortion
more += There is.*feeling in your soul
more += wretched star pulses
more += Strange energies course through your body

flash += doors? slams? shut
flash += blows.*on a signal horn
flash += Deactivating autopickup
flash += Its appearance distorts for a moment
flash += The.*offers itself to Yredelemnul
flash += The forest starts to sway and rumble
flash += Your?.*suddenly stops? moving

# Crowd control
more += You[^r].*(?<! too|less) confused
more += You[^r] .*(slow.*down|lose consciousness)
more += infuriates you

flash += You .* (blown|knocked back|mesmerised|trampled|stumble backwards|encased)
flash += Your magical (effects|defenses) are (unraveling|stripped away)
flash += The pull of.*song draws you forward
flash += engulfs you in water

# Clouds
more += danger:(calcify|mutagenic)
more += You.*re engulfed in.*miasma
flash += Miasma billows from the

# You Screwed Up
more += is no longer ready
more += You really shouldn't be using
more += You don't have enough magic to cast this spell
flash += Your body shudders with the violent release
flash += power of Zot

# Found something important
flash += You pick up the .* (gem|rune) and feel its 
more += Found.*the Ecumenical Temple
more += Found.*(treasure|bazaar|ziggurat)
more += You have a vision of.*gates?
more += Press the corresponding letter to learn more about a god
flash += timed_portal:.*

# Translocations
more += danger:sense of stasis
more += Your surroundings.*(different|flicker)
more += You.*re suddenly pulled into a different region
flash += You blink
flash += danger:You feel strangely .*stable
flash += delaying your translocation

# Big damage
more += The poison in your body grows stronger
more += You.*re lethally poisoned
more += danger:You convulse
more += You feel a (horrible|terrible) chill
more += Your.*terribly
more += You are.*terribly

# Hit by something
more += Terrible wounds open
more += The air around.*erupts in flames
more += The air twists around and violently strikes you in flight
more += You shudder from the earth-shattering force
more += You feel.*(?<!less)( haunted| rot| vulnerable)
flash += danger:corrodes you
flash += Your damage is reflected back at you
flash += ^(?!Your? ).*reflects

# FYI
more += seems mollified
more += You have finished your manual

# Unexpected monsters
more += appears in a (shower|flash)
more += appears out of thin air
more += You sense the presence of something unfriendly
more += Wisps of shadow swirl around

# Misc
more += hell effect:.*
more += god:wrath finds you
more += The walls disappear

# Ashenzari
more += god:Ashenzari invites you to partake
# Dithmenos
more += god:You are shrouded in an aura of darkness
more += god:You.*bleed smoke
more += god:Your shadow.*tangibly mimics your actions
# Fedhas
more += god:Fedhas invokes the elements against you
# Jivya
more += god:will now unseal the treasures of the Slime Pits
more += god:Jiyva alters your body
# Kikubaaqudgha
more += god:Kikubaaqudgha will grant you
# Lugonu
more += god:Lugonu will now corrupt your weapon
more += god:Lugonu sends minions to punish you
# Okawaru
more += god:Okawaru sends forces against you
# Qazlal
flash += god:resistances upon receiving elemental damage
flash += god:You are surrounded by a storm which can block enemy attacks
# The Shining One
more += god:Your divine shield starts to fade
more += god:Your divine shield fades away
# Trog
more += god:You feel the effects of Trog's Hand fading
more += god:You feel less resistant to hostile enchantments
# Xom
more += staircase.*moves
more += Some monsters swap places
# Yredelemnul
more += god:soul is no.* ripe for the taking
more += god:dark mirror aura disappears
# Zin
more += god:will now cure all your mutations

############################### End rc/fm-messages.rc ###############################
##########################################################################################

################################### Begin rc/runrest.rc ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
# Aliases
stop := runrest_stop_message
ignore := runrest_ignore_message

# Ignore these stops
interrupt_travel -= sense_monster
interrupt_travel -= mimic
ignore ^= "sense a monster nearby"
ignore ^= recovery:.*
ignore ^= duration:.*

# Monsters to ignore at a distance
runrest_ignore_monster += fire vortex:1

# Stop for consumables you want to use immediately
stop += potions? of experience
stop += scrolls? of acquirement

# Don't stop for noisy doors unless someone shouts back
stop -= it creaks loudly
stop -= flies open with a bang
stop -= The hatch slams shut behind you
stop += You hear

# Ignore some stops for ally actions, then stop on the rest
ignore -= friend_action:
ignore -= friend_spell:
ignore -= friend_enchant:
ignore ^= butterfly disappears
ignore ^= friend_action:(a|the) web
ignore ^= friend_action:(seems|blinks)
ignore ^= clockwork bee (falls|winds down)
stop += friend_action:
stop += friend_spell:
stop += friend_enchant:
stop += appears from out of your range of vision
stop += hits your
stop += our.*is destroyed

# Expiring effects; Turn on transmutation|flight|swiftness ending and ignore the rest
ignore -= transformation is almost over\.
ignore -= transformation has ended\.
ignore -= revert to.*form\.
ignore -= You feel yourself come back to life
ignore ^= unholy channel is weakening
ignore ^= magical contamination.*faded
ignore ^= our foxfire dissipates
stop ^= unholy channel expires
stop ^= are starting to lose your buoyancy
stop ^= You feel.*sluggish
# Expiring effects for friends too
stop ^= no longer petrified
ignore ^= no longer.*(covered in acid|unusually strong)
ignore ^= looks more healthy

# Misc
stop -= You now have enough gold to
stop ^= timed_portal:.*
ignore ^= nearby plant withers and dies
ignore ^= disentangle yourself
ignore ^= You swap places.

# Summonings
ignore ^= our.*crimson imp blinks
ignore ^= our.*simulacrum vaporises
ignore ^= our.*returns to the shadows of the Dungeon
ignore ^= our.*skeleton crumbles into dust
ignore ^= our.*fades into mist
ignore ^= our.*looks more healthy
ignore ^= our.*is no longer (corroded|moving slowly)
ignore ^= our.*dissolves into a puddle of slime

# Ashenzari
stop += god:Ashenzari invites you to partake
# Ru
stop += god:Ru believes you are ready to make a new sacrifice
# Hepliaklqana
ignore ^= emerges from the mists of memory
# Wu Jian Council
# ignore += heavenly storm settles
# Yredelemnul
ignore += offer up the Black Torch's flame
ignore += mindless puppets stay behind to rot

############################### End rc/runrest.rc ###############################
##########################################################################################

################################### Begin lua/core/constants.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC core module
-- @module BRC
-- Constants and definitions used throughout BRC.
---------------------------------------------------------------------------------------------------

---- Cosmetic settings
BRC.EMOJI = {
  CAUTION = BRC.Config.emojis and "⚠️" or "<yellow>!</yellow>",
  EXCLAMATION = BRC.Config.emojis and "❗" or "<magenta>!</magenta>",
  EXCLAMATION_2 = BRC.Config.emojis and "‼️" or "<lightmagenta>!!</lightmagenta>",
  SUCCESS = BRC.Config.emojis and "✅" or nil,
} -- BRC.EMOJI (do not remove this comment)

---- Items ----
BRC.MISC_ITEMS = {
  "box of beasts", "condenser vane", "figurine of a ziggurat", "Gell's gravitambourine",
  "horn of Geryon", "lightning rod", "phantom mirror", "phial of floods", "sack of spiders",
  "tin of tremorstones",
} -- BRC.MISC_ITEMS (do not remove this comment)

-- This is checked against the full text of the pickup message, so use patterns to match
BRC.MISSILES = {
  "poisoned dart", "atropa-tipped dart", "curare-tipped dart", "datura-tipped dart",
  "darts? of disjunction", "darts? of dispersal", " stone", "boomerang",
  "silver javelin", "javelin", "large rock", "throwing net",
} -- BRC.MISSILES (do not remove this comment)

-- Could be removed after https://github.com/crawl/crawl/issues/4606 is addressed
BRC.SPELLBOOKS = {
  "parchment of", "book of", "Necronomicon", "Grand Grimoire", "tome of obsoleteness",
  "Everburning Encyclopedia", "Ozocubu's Autobiography", "Maxwell's Memoranda",
  "Young Poisoner's Handbook", "Fen Folio", "Inescapable Atlas", "There-And-Back Book",
  "Great Wizards, Vol. II", "Great Wizards, Vol. VII", "Trismegistus Codex",
  "the Unrestrained Analects", "Compendium of Siegecraft", "Codex of Conductivity",
  "Handbook of Applied Construction", "Treatise on Traps", "My Sojourn through Swampland",
  "Akashic Record",
  -- Include prefixes for randart books
  "Almanac", "Anthology", "Atlas", "Book", "Catalogue", "Codex", "Compendium",
  "Compilation", "Cyclopedia", "Directory", "Elucidation", "Encyclopedia", "Folio",
  "Grimoire", "Handbook", "Incunable", "Incunabulum", "Octavo", "Omnibus", "Papyrus",
  "Parchment", "Precepts", "Quarto", "Secrets", "Spellbook", "Tome", "Vellum", "Volume",
} -- BRC.SPELLBOOKS (do not remove this comment)

---- Races ----
BRC.UNDEAD_RACES = { "Demonspawn", "Mummy", "Poltergeist", "Revenant" }
BRC.NONLIVING_RACES = { "Djinni", "Gargoyle" }
BRC.POIS_RES_RACES = { "Djinni", "Gargoyle", "Mummy", "Naga", "Poltergeist", "Revenant" }
BRC.LITTLE_RACES = { "Spriggan" }
BRC.SMALL_RACES = { "Kobold" }
BRC.LARGE_RACES = { "Armataur", "Naga", "Oni", "Troll" }

---- Skills ----
BRC.MAGIC_SCHOOLS = {
  air = "Air Magic", alchemy = "Alchemy", cold = "Ice Magic", conjuration = "Conjurations",
  death = "Necromancy", earth = "Earth Magic", fire = "Fire Magic", necromancy = "Necromancy",
} -- BRC.MAGIC_SCHOOLS (do not remove this comment)

BRC.TRAINING_SKILLS = {
  "Air Magic", "Alchemy", "Armour", "Axes", "Conjurations", "Dodging", "Earth Magic",
  "Evocations", "Fighting", "Fire Magic", "Forgecraft", "Hexes", "Ice Magic",
  "Invocations", "Long Blades", "Maces & Flails", "Necromancy", "Polearms",
  "Ranged Weapons", "Shapeshifting", "Shields", "Short Blades", "Spellcasting", "Staves",
  "Stealth", "Summonings", "Translocations", "Unarmed Combat", "Throwing",
} -- BRC.TRAINING_SKILLS (do not remove this comment)

BRC.WEAP_SCHOOLS = {
  "axes", "maces & flails", "polearms", "long blades", "short blades",
  "staves", "unarmed combat", "ranged weapons",
} -- BRC.WEAP_SCHOOLS (do not remove this comment)

---- Branches ----
BRC.HELL_BRANCHES = { "Coc", "Dis", "Geh", "Hell", "Tar" }
BRC.PORTAL_FEATURE_NAMES = {
  "Bailey", "Bazaar", "Desolation", "Gauntlet", "IceCv", "Necropolis", "Ossuary",
  "Sewer", "Trove", "Volcano", "Wizlab", "Zig",
} -- BRC.PORTAL_FEATURE_NAMES (do not remove this comment)

---- Egos ----
BRC.RISKY_EGOS = { "antimagic", "chaos", "distort", "harm", "heavy", "Infuse", "Ponderous" }
BRC.NON_ELEMENTAL_DMG_EGOS = { "distort", "heavy", "spect" }
BRC.ADJECTIVE_EGOS = { -- Egos whose English modifier comes before item name
  antimagic = "antimagic", heavy = "heavy", spectralising = "spectral", vampirism = "vampiric"
} -- BRC.ADJECTIVE_EGOS (do not remove this comment)

---- Artefact properties ----
BRC.ARTPROPS_BAD = {
  "Bane", "-Cast", "-Move", "-Tele",
  "*Corrode", "*Noise", "*Rage", "*Silence", "*Slow", "*Tele",
} -- BRC.ARTPROPS_BAD (do not remove this comment)

BRC.ARTPROPS_EGO = { -- Corresponding ego
  rF = "fire resistance", rC = "cold resistance", rPois = "poison resistance",
  rN = "positive energy", rCorr = "corrosion resistance",
  Archmagi = "the Archmagi", Rampage = "rampaging", Will = "willpower",
  Air = "air", Earth = "earth", Fire = "fire", Ice = "ice", Necro = "death", Summ = "command",
} -- BRC.ARTPROPS_EGO (do not remove this comment)

---- Other ----
BRC.KEYS = { NPenter = -1010, ESC = 27, ["Cntl-S"] = 20, ["Cntl-E"] = 5 }

BRC.COL = {
  black = "0", blue = "1", green = "2", cyan = "3", red = "4", magenta = "5", brown = "6",
  lightgrey = "7", darkgrey = "8", lightblue = "9", lightgreen = "10",
  lightcyan = "11", lightred = "12", lightmagenta = "13", yellow = "14", white = "15",
} -- BRC.COL (do not remove this comment)

BRC.DMG_TYPE = {
  unbranded = 1, -- No brand
  plain = 2, -- Include brand dmg for non-elemental brands
  branded = 3, -- Include full brand dmg
  scoring = 4, -- Include boosts for non-damaging brands
} -- BRC.DMG_TYPE (do not remove this comment)

BRC.SIZE_PENALTY = { LITTLE = -2, SMALL = -1, NORMAL = 0, LARGE = 1, GIANT = 2 }

}
############################### End lua/core/constants.lua ###############################
##########################################################################################

################################### Begin lua/util/util.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC utility module
-- @module BRC.util
-- General utility functions.
---------------------------------------------------------------------------------------------------

BRC.util = {}

--- Get the keycode for Cntl+char
function BRC.util.cntl(c)
  return string.byte(c:upper()) - 64
end

--- Get key assigned to a crawl command (e.g. "CMD_EXPLORE")
function BRC.util.get_cmd_key(cmd)
  local key = crawl.get_command(cmd)
  if not key or key == "NULL" then return nil end
  -- get_command returns things like "Uppercase Ctrl-S"; we just want 'S'
  local char_key = key:sub(-1)
  return key:contains("Ctrl") and BRC.util.cntl(char_key) or char_key
end

--- Tries sendkeys() first, fallback to do_commands() (which isn't always immediate)
-- @param cmd (string) The command to execute like "CMD_EXPLORE"
function BRC.util.do_cmd(cmd)
  local key = BRC.util.get_cmd_key(cmd)
  if key then
    crawl.sendkeys({ key })
    crawl.flush_input()
  else
    crawl.do_commands({ cmd })
  end
end

---- Lua table helpers ----
--- Add or remove an item from a list
function BRC.util.add_or_remove(list, item, add)
  if add then
    list[#list + 1] = item
  else
    util.remove(list, item)
  end
end

--- Sorts the keys of a dictionary/map: vars before tables, then alphabetically by key
-- If a list is passed, will assume it's a list of global variable names
function BRC.util.get_sorted_keys(map_or_list)
  local keys_vars = {}
  local keys_tables = {}

  if BRC.util.is_map(map_or_list) then
    for key, v in pairs(map_or_list) do
      table.insert(type(v) == "table" and keys_tables or keys_vars, key)
    end
  else
    for _, key in ipairs(map_or_list) do
      table.insert(type(_G[key]) == "table" and keys_tables or keys_vars, key)
    end
  end

  util.sort(keys_vars)
  util.sort(keys_tables)
  util.append(keys_vars, keys_tables)
  return keys_vars
end

function BRC.util.is_list(value)
  return value and type(value) == "table" and #value > 0
end

function BRC.util.is_map(value)
  return value and type(value) == "table" and next(value) ~= nil and #value == 0
end

--- Compare version (x.y) to crawl version. Return true if v1 <= crawl version.
function BRC.util.version_is_valid(v1)
  local crawl_v = crawl.version("major")
  local cv_parts = { string.match(crawl_v, "([0-9]+)%.([0-9]+)" ) }
  local v1_parts = { string.match(v1, "([0-9]+)%.([0-9]+)" ) }
  return v1_parts[1] < cv_parts[1]
    or (v1_parts[1] == cv_parts[1] and v1_parts[2] <= cv_parts[2])
end

}
############################### End lua/util/util.lua ###############################
##########################################################################################

################################### Begin lua/util/text.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC utility module
-- @module BRC.txt
-- Text and string functions.
-- Creates string:contains() for all strings
---------------------------------------------------------------------------------------------------

BRC.txt = {}

---- Text parsing ----
--- Search for text within a string, without Lua pattern matching.
-- @return (bool) True if text is found, false otherwise.
function BRC.txt.contains(self, text)
  return self:find(text, 1, true) ~= nil
end
--- Connect string:contains() to BRC.txt.contains()
getmetatable("").__index.contains = BRC.txt.contains

--- Parse the slot and item name from an item pickup message (e.g. "w - a +0 short sword")
-- @return (string, int) The item name and slot index
function BRC.txt.get_pickup_info(text)
  local cleaned = BRC.txt.clean(text)
  if cleaned:sub(2, 4) ~= " - " then return nil end
  return cleaned:sub(5, #cleaned), items.letter_to_index(cleaned:sub(1, 1))
end


---- Color functions - Usage: BRC.txt.white("Hello"), or BRC.txt["15"]("Hello") ----
for k, color in pairs(BRC.COL) do
  BRC.txt[k] = function(text)
    return string.format("<%s>%s</%s>", color, tostring(text), color)
  end
  BRC.txt[color] = BRC.txt[k]
end


---- String manipulation ----
function BRC.txt.capitalize(s)
  if not s or s == "" then return s end
  return string.upper(string.sub(s, 1, 1)) .. string.lower(string.sub(s, 2))
end

--- Remove newlines and tags from text
function BRC.txt.clean(text)
  if type(text) ~= "string" then return text end
  return text:gsub("\n", ""):gsub("<[^>]*>", "")
end

function BRC.txt.wrap(text, wrapper, no_space)
  if not wrapper then return text end
  return table.concat({ wrapper, text, wrapper }, no_space and "" or " ")
end


---- Conversion to string ----
function BRC.txt.int2char(num)
  return string.char(string.byte("a") + num)
end

function BRC.txt.serialize_chk_lua_save()
  local tokens = { BRC.txt.lightblue("\n---CHK_LUA_SAVE---") }
  for _, func in ipairs(chk_lua_save) do
    local result = func()
    if result and #result > 0 then tokens[#tokens + 1] = util.trim(result) end
  end

  return table.concat(tokens, "\n")
end

function BRC.txt.serialize_inventory()
  local tokens = { BRC.txt.lightcyan("\n---INVENTORY---\n") }
  for _, inv in ipairs(items.inventory()) do
    local base = inv.name("base") or "N/A"
    local cls = inv.class(true) or "N/A"
    local st = inv.subtype() or "N/A"
    tokens[#tokens + 1] = string.format("%s: (%s) Qual: %s", inv.slot, inv.quantity, inv.name())
    tokens[#tokens + 1] = string.format("  Base: %s Class: %s, Subtype: %s\n", base, cls, st)
  end

  return table.concat(tokens)
end

---- BRC.txt.tostr() local helper functions ----
local function limit_lines(str)
  if not str or str == "" then return str end
  if BRC.Config.dump.max_lines_per_table and BRC.Config.dump.max_lines_per_table > 0 then
    local lines = 1
    str:gsub("\n", function() lines = lines + 1 end)
    if lines > BRC.Config.dump.max_lines_per_table then
      return string.format("{ %s lines... }", lines)
    end
  end

  return str
end

local function tostr_string(var, pretty)
  local s
  if var:contains("\n") then
    s = string.format("[[\n%s]]", var)
  else
    s = '"' .. var:gsub('"', "") .. '"'
  end

  if not pretty then return s end
  -- Replace > and < to display the color tags instead of colored text
  return s:gsub(">", "TempGT"):gsub("<", "TempLT"):gsub("TempGT", "<gt>"):gsub("TempLT", "<lt>")
end

local function tostr_list(var, pretty, indents)
  local tokens = {}
  for _, v in ipairs(var) do
    tokens[#tokens + 1] = limit_lines(BRC.txt.tostr(v, pretty, indents + 1))
  end
  if #tokens < 4 and not util.exists(var, function(t) return type(t) == "table" end) then
    return "{ " .. table.concat(tokens, ", ") .. " }"
  else
    local INDENT = string.rep("  ", indents)
    local CHILD_INDENT = string.rep("  ", indents + 1)
    local LIST_SEP = ",\n" .. CHILD_INDENT
    return "{\n" .. CHILD_INDENT .. table.concat(tokens, LIST_SEP) .. "\n" .. INDENT .. "}"
  end
end

local function tostr_map(var, pretty, indents)
  local tokens = {}

  if pretty then
    local keys = BRC.util.get_sorted_keys(var)
    local contains_table = false
    for i = 1, #keys do
      local v = limit_lines(BRC.txt.tostr(var[keys[i]], true, indents + 1))
      if v then
        if type(var[keys[i]]) == "table" then
          contains_table = true
          tokens[#tokens + 1] = string.format('["%s"] = %s', keys[i], v)
        else
          tokens[#tokens + 1] = string.format("%s = %s", keys[i], v)
        end
      end
    end
    if #tokens <= 2 and not contains_table then
      return "{ " .. table.concat(tokens, ", ") .. " }"
    end
  else
    for k, v in pairs(var) do
      local val_str = BRC.txt.tostr(v, pretty, indents + 1)
      if val_str then
        tokens[#tokens + 1] = '["' .. k .. '"] = ' .. val_str
      end
    end
  end

  local INDENT = string.rep("  ", indents)
  local CHILD_INDENT = string.rep("  ", indents + 1)
  local LIST_SEP = ",\n" .. CHILD_INDENT
  return "{\n" .. CHILD_INDENT .. table.concat(tokens, LIST_SEP) .. "\n" .. INDENT .. "}"
end

--- Serializes a variable to a string, for chk_lua_save or data dumps.
-- @param pretty (optional bool) format for human readability
-- @param _indents (optional int) Used internally to format multi-line tables
function BRC.txt.tostr(var, pretty, _indents)
  local var_type = type(var)
  if var_type == "string" then
    return tostr_string(var, pretty)
  elseif var_type == "table" then
    _indents = _indents or 0
    if BRC.util.is_list(var) then
      return tostr_list(var, pretty, _indents)
    elseif BRC.util.is_map(var) then
      return tostr_map(var, pretty, _indents)
    else
      return "{}"
    end
  end

  if BRC.Config.dump.omit_pointers and (var_type == "function" or var_type == "userdata") then
    return nil
  end

  return tostring(var) -- fallback to tostring()
end

}
############################### End lua/util/text.lua ###############################
##########################################################################################

################################### Begin lua/util/mpr.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC utility module
-- @module BRC.mpr
-- Wrappers around crawl.mpr for message printing : Colors, formatted messages, message queue, etc.
---------------------------------------------------------------------------------------------------

BRC.mpr = {}

---- mpr queue (displayed after all other messages for the turn) ----
local _mpr_queue = {}

--- Queue a message to dispay at the end of ready()
function BRC.mpr.que(msg, color, channel)
  BRC.mpr.que_optmore(false, msg, color, channel)
end

--- Queue msg w/ conditional force_more_message
function BRC.mpr.que_optmore(show_more, msg, color, channel)
  for _, q in ipairs(_mpr_queue) do
    if q.m == msg and q.ch == channel and q.more == show_more then return end
  end
  color = color or BRC.COL.lightgrey
  _mpr_queue[#_mpr_queue + 1] = { m = BRC.txt[color](msg), ch = channel, more = show_more }
end

--- Display queued messages and clear the queue
function BRC.mpr.consume_queue()
  local do_more = util.exists(_mpr_queue, function(q) return q.more end)
  -- stop_activity() can generate more autopickups, and thus more queue'd messages
  if do_more then
    you.stop_activity()
    crawl.redraw_screen()
  end

  for _, msg in ipairs(_mpr_queue) do
    crawl.mpr(tostring(msg.m), msg.ch)
    crawl.flush_prev_message()
  end
  _mpr_queue = {}

  if do_more then
    crawl.more()
    crawl.redraw_screen()
  end
end


---- Color functions - Usage: BRC.mpr.white("Hello"), or BRC.mpr["15"]("Hello") ----
for k, color in pairs(BRC.COL) do
  BRC.mpr[k] = function(msg, channel)
    crawl.mpr(BRC.txt[color](msg), channel)
    crawl.flush_prev_message()
  end
  BRC.mpr[color] = BRC.mpr[k]
end


---- Pre-formatted logging functions ----
local function log_message(message, context, color)
  -- Avoid referencing BRC, to stay robust during startup
  color = color or "lightgrey"
  local msg = "[BRC] " .. tostring(message)
  if context then msg = string.format("%s (%s)", msg, tostring(context)) end
  crawl.mpr(string.format("<%s>%s</%s>", color, msg, color))
  crawl.flush_prev_message()
end

--- Primary function for displaying errors. Includes a force_more_message by default.
-- @param context (optional) Additional context. No context if params are (string, bool).
function BRC.mpr.error(message, context, skip_more)
  if type(context) == "boolean" and skip_more == nil then
    skip_more = context
    context = nil
  end

  log_message("(Error) " .. message, context, BRC.COL.lightred)
  you.stop_activity()
  crawl.redraw_screen()

  if not skip_more then
    crawl.more()
    crawl.redraw_screen()
  end

  if BRC.Config.mpr.logs_to_stderr then
    crawl.stderr("[BRC] (Error) " .. message)
  end
end

function BRC.mpr.warning(message, context)
  log_message(message, context, BRC.COL.yellow)
  you.stop_activity()
  if BRC.Config.mpr.logs_to_stderr then
    crawl.stderr("[BRC] (Warning) " .. message)
  end
end

function BRC.mpr.info(message, context)
  log_message(message, context, BRC.COL.darkgrey)
end

function BRC.mpr.debug(message, context)
  if BRC.Config.mpr.show_debug_messages then
    log_message(message, context, BRC.COL.lightblue)
  end
  if BRC.Config.mpr.logs_to_stderr then
    crawl.stderr("[BRC] (Debug) " .. message)
  end
end

function BRC.mpr.okay(suffix)
  BRC.mpr.darkgrey("Okay, then." .. (suffix and " " .. suffix or ""))
end

--- Print a variable's stringified value
function BRC.mpr.tostr(v)
  crawl.mpr(BRC.txt.tostr(v, true))
end

---- Messages with stop or force_more ----
--- Message plus stop travel/activity
function BRC.mpr.stop(msg, color, channel)
  BRC.mpr[color or BRC.COL.lightgrey](msg, channel)
  you.stop_activity()
end

--- Message as a force_more_message
function BRC.mpr.more(msg, color, channel)
  BRC.mpr[color or BRC.COL.lightgrey](msg, channel)
  you.stop_activity()
  crawl.redraw_screen()
  crawl.more()
  crawl.redraw_screen()
end

--- Conditional force_more_message
function BRC.mpr.optmore(show_more, msg, color, channel)
  if show_more then
    BRC.mpr.more(msg, color, channel)
  else
    BRC.mpr[color or BRC.COL.lightgrey](msg, channel)
  end
end


---- Prompts for user input ----
--- Get a selection from the user, from a list of options
function BRC.mpr.select(msg, options, color)
  if not (type(options) == "table" and #options > 0) then
    BRC.mpr.error("No options provided for BRC.mpr.select")
    return false
  end

  msg = msg .. ":\n"
  for i, option in ipairs(options) do
    msg = msg .. string.format("%s: %s\n", i, BRC.txt.white(option))
  end
  BRC.mpr[color or BRC.COL.lightcyan](msg, "prompt")
  for _ = 1, 10 do
    local res = crawl.getch()
    if res then
      local num = res - string.byte("0")
      if num > 0 and num <= #options then return options[num] end
    end
    BRC.mpr.magenta("Invalid option, try again.")
  end

  BRC.mpr.lightmagenta("Fine then. Using option 1: " .. options[1])
  return options[1]
end

--- Get a yes/no response
function BRC.mpr.yesno(msg, color, capital_only)
  msg = string.format("%s (%s)", msg, capital_only and "Y/N" or "y/n")

  for i = 1, 10 do
    BRC.mpr[color or BRC.COL.lightgrey](msg, "prompt")
    local res = crawl.getch()
    if res and res >= 0 and res <= 255 then
      local c = string.char(res)
      if c == "Y" or c == "y" and not capital_only then return true end
      if c == "N" or c == "n" and not capital_only then return false end
    end
    if i == 1 and capital_only then msg = "[CAPS ONLY] " .. msg end
  end

  BRC.mpr.lightmagenta("Feels like a no.")
  return false
end


}
############################### End lua/util/mpr.lua ###############################
##########################################################################################

################################### Begin lua/util/item.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC utility module
-- @module BRC.it
-- Utilities for checking item types/attributes, and retrieving item-related information.
---------------------------------------------------------------------------------------------------

BRC.it = {}

function BRC.it.get_xy(name, radius)
  local r = radius or you.los()
  for dx = -r, r do
    for dy = -r, r do
      for _, fl in ipairs(items.get_items_at(dx, dy) or {}) do
        if fl.name() == name then
          return dx, dy
        end
      end
    end
  end
end

function BRC.it.get_staff_school(it)
  for k, v in pairs(BRC.MAGIC_SCHOOLS) do
    if it.subtype() == k then return v end
  end
end

function BRC.it.get_talisman_min_level(it)
  if it.name() == "protean talisman" then return 6 end

  -- Parse the item description
  local tokens = crawl.split(it.description, "\n")
  for _, v in ipairs(tokens) do
    if v:sub(1, 4) == "Min " then
      local start_pos = v:find("%d", 4)
      if start_pos then
        local end_pos = v:find("[^%d]", start_pos)
        return tonumber(v:sub(start_pos, end_pos - 1))
      end
    end
  end

  BRC.mpr.error("Failed to find skill required for: " .. it.name())
  return -1
end

--- @return table All items whose slot is idx
function BRC.it.all_inslot(idx)
  return util.filter(function(i) return i.slot == idx end, items.inventory())
end

---- Simple boolean checks ----
function BRC.it.is_amulet(it)
  return it and it.name("base") == "amulet"
end

function BRC.it.is_armour(it, include_orbs)
  return it and it.class(true) == "armour" and (include_orbs or not BRC.it.is_orb(it))
end

function BRC.it.is_aux_armour(it)
  return BRC.it.is_armour(it) and not (BRC.it.is_body_armour(it) or BRC.it.is_shield(it))
end

function BRC.it.is_body_armour(it)
  return it and it.subtype() == "body"
end

function BRC.it.is_jewellery(it)
  return it and it.class(true) == "jewellery"
end

function BRC.it.is_magic_staff(it)
  return it and it.class and it.class(true) == "magical staff"
end

function BRC.it.is_ring(it)
  return it and it.name("base") == "ring"
end

function BRC.it.is_scarf(it)
  return BRC.it.is_armour(it) and it.subtype() == "cloak" and it.name():contains("scarf")
end

function BRC.it.is_shield(it)
  return it and it.is_shield()
end

function BRC.it.is_talisman(it)
  return it and it.class(true) == "talisman"
end

function BRC.it.is_orb(it)
  return it and it.subtype() == "offhand" and not it.is_shield()
end

function BRC.it.is_polearm(it)
  return it and it.weap_skill:contains("Polearms")
end

}
############################### End lua/util/item.lua ###############################
##########################################################################################

################################### Begin lua/util/you.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC utility module
-- @module BRC.you
-- Utilities for checking character attributes and state
---------------------------------------------------------------------------------------------------

BRC.you = {}

--- Get mutation level, explicitly specifying crawl's optional params.
-- @param innate_only boolean (optional) True to count only innate mutations, else count all.
function BRC.you.mut_lvl(mutation, innate_only)
  return you.get_base_mutation_level(mutation, true, not innate_only, not innate_only)
end


---- Boolean attributes ----
function BRC.you.by_slimy_wall()
  for x = -1, 1 do
    for y = -1, 1 do
      if view.feature_at(x, y) == "slimy_wall" then return true end
    end
  end
  return false
end

function BRC.you.free_offhand()
  if BRC.you.mut_lvl("missing a hand") > 0 then return true end
  return not items.equipped_at("offhand")
end

function BRC.you.have_shield()
  return BRC.it.is_shield(items.equipped_at("offhand"))
end

function BRC.you.in_hell(exclude_vestibule)
  local branch = you.branch()
  if exclude_vestibule and branch == "Hell" then return false end
  return util.contains(BRC.HELL_BRANCHES, branch)
end

function BRC.you.miasma_immune()
  if util.contains(BRC.UNDEAD_RACES, you.race()) then return true end
  if util.contains(BRC.NONLIVING_RACES, you.race()) then return true end
  return false
end

function BRC.you.mutation_immune()
  return util.contains(BRC.UNDEAD_RACES, you.race())
end

function BRC.you.shapeshifting_skill()
  local skill = you.skill("Shapeshifting")
  local AMU = "amulet of wildshape"
  if util.exists(items.inventory(), function(i) return i.name("qual") == AMU end) then
    return skill + 5
  end
  return skill
end

function BRC.you.size_penalty()
  if util.contains(BRC.LITTLE_RACES, you.race()) then
    return BRC.SIZE_PENALTY.LITTLE
  elseif util.contains(BRC.SMALL_RACES, you.race()) then
    return BRC.SIZE_PENALTY.SMALL
  elseif util.contains(BRC.LARGE_RACES, you.race()) then
    return BRC.SIZE_PENALTY.LARGE
  else
    return BRC.SIZE_PENALTY.NORMAL
  end
end

function BRC.you.zero_stat()
  return you.strength() <= 0 or you.dexterity() <= 0 or you.intelligence() <= 0
end


---- Equipment slot functions ----
--- The number of equipment slots available for the item (usually 1)
function BRC.you.num_eq_slots(it)
  local player_race = you.race()
  if it.is_weapon then return player_race == "Coglin" and 2 or 1 end
  if BRC.it.is_aux_armour(it) then
    if player_race == "Formicid" then return it.subtype() == "gloves" and 2 or 1 end
    return player_race == "Poltergeist" and 6 or 1
  end

  return 1
end

--- Get all equipped items in the slot type for the item
-- @return (table, int) - items, and num_slots (max size the list can be)
-- This is usually a list of length 1, with num_slots==1
function BRC.you.equipped_at(it)
  local all_aux = {}
  local num_slots = BRC.you.num_eq_slots(it)
  local slot_name = it.is_weapon and "weapon"
    or BRC.it.is_body_armour(it) and "armour"
    or it.subtype()

  for i = 1, num_slots do
    local eq = items.equipped_at(slot_name, i)
    all_aux[#all_aux + 1] = eq
  end

  return all_aux, num_slots
end

---- Skill attributes ----
function BRC.you.top_wpn_skill()
  local max_weap_skill = 0
  local pref = nil
  for _, v in ipairs(BRC.WEAP_SCHOOLS) do
    if BRC.you.skill(v) > max_weap_skill then
      max_weap_skill = BRC.you.skill(v)
      pref = v
    end
  end
  return pref
end

--- Get the max skill for a comma-separated list of skills
function BRC.you.skill(skill)
  if skill and not skill:contains(",") then return you.skill(skill) end

  local skills = crawl.split(skill, ",")
  local max = 0
  for _, s in ipairs(skills) do
    if you.skill(s) > max then max = you.skill(s) end
  end

  return max
end

function BRC.you.skill_with(it)
  if BRC.it.is_magic_staff(it) then
    return math.max(BRC.you.skill(BRC.it.get_staff_school(it)), BRC.you.skill("Staves"))
  end
  if it.is_weapon then return BRC.you.skill(it.weap_skill) end
  if BRC.it.is_body_armour(it) then return BRC.you.skill("Armour") end
  if BRC.it.is_shield(it) then return BRC.you.skill("Shields") end
  if BRC.it.is_talisman(it) then return BRC.you.shapeshifting_skill() end

  return nil
end

}
############################### End lua/util/you.lua ###############################
##########################################################################################

################################### Begin lua/util/equipment.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC utility module
-- @module BRC.eq
-- This module contains 2 main types of functions:
--   1. Mirroring crawl calculations, like weapon damage, armour penalty, etc.
--   2. Design choices that aren't as generalizable as other util functions.
--     Ex: Dragon scales are always considered branded, DPS calculation is an approximation, etc.
--     Ex: is_risky(), is_useless_ego(), get_ego(), get_hands(), etc.
---------------------------------------------------------------------------------------------------

BRC.eq = {}

---- Local functions (Mostly mirroring crawl calculations) ----
-- Last verified against: current crawl master branch (0.34-a0-786-ge5b59a6c5f)

local function get_unadjusted_armour_pen(encumb)
  local pen = encumb - 2 * BRC.you.mut_lvl("sturdy frame")
  if pen > 0 then return pen end
  return 0
end

local function get_adjusted_armour_pen(encumb, str)
  local base_pen = get_unadjusted_armour_pen(encumb)
  return 2 * base_pen * base_pen * (45 - you.skill("Armour")) / 45 / (5 * (str + 3))
end

local function get_adjusted_dodge_bonus(encumb, str, dex)
  local size_factor = -2 * BRC.you.size_penalty()
  local dodge_bonus = 8 * (10 + you.skill("Dodging") * dex) / (20 - size_factor) / 10
  local armour_dodge_penalty = get_unadjusted_armour_pen(encumb) - 3
  if armour_dodge_penalty <= 0 then return dodge_bonus end

  if armour_dodge_penalty >= str then return dodge_bonus * str / (armour_dodge_penalty * 2) end
  return dodge_bonus - dodge_bonus * armour_dodge_penalty / (str * 2)
end

local function get_shield_penalty(sh)
  return 2 * sh.encumbrance * sh.encumbrance
    * (27 - you.skill("Shields")) / 27
    / (25 + 5 * you.strength())
end

local function get_branded_delay(delay, ego)
  if not ego then return delay end
  if ego == "speed" then
    return delay * 2 / 3
  elseif ego == "heavy" then
    return delay * 1.5
  end
  return delay
end

local function get_weap_min_delay(it)
  -- This is an abbreviated version of the actual calculation.
  -- Doesn't check brand or delay >=3, which are covered in get_weap_delay()
  if it.artefact and it.name("qual"):contains("woodcutter's axe") then return it.delay end

  local min_delay = math.floor(it.delay / 2)
  if it.weap_skill == "Short Blades" then return 5 end
  if it.is_ranged then
    local basename = it.name("base")
    local is_2h_ranged = basename:contains("crossbow") or basename:contains("arbalest")
    if is_2h_ranged then return math.max(min_delay, 10) end
  end

  return math.min(min_delay, 7)
end

local function get_slay_bonuses()
  local sum = 0

  -- Slots can go as high as 18 afaict
  for i = 0, 20 do
    local inv = items.equipped_at(i)
    if inv then
      if BRC.it.is_ring(inv) then
        if inv.artefact then
          local name = inv.name()
          local idx = name:find("Slay", 1, true)
          if idx then
            local slay = tonumber(name:sub(idx + 5, idx + 5))
            if slay == 1 then
              local next_digit = tonumber(name:sub(idx + 6, idx + 6))
              if next_digit then slay = 10 + next_digit end
            end

            if name:sub(idx + 4, idx + 4) == "+" then
              sum = sum + slay
            else
              sum = sum - slay
            end
          end
        elseif BRC.eq.get_ego(inv) == "Slay" then
          sum = sum + inv.plus
        end
      elseif inv.artefact and (BRC.it.is_armour(inv, true) or BRC.it.is_amulet(inv)) then
        local slay = inv.artprops["Slay"]
        if slay then sum = sum + slay end
      end
    end
  end

  if you.race() == "Demonspawn" then
    sum = sum + 3 * BRC.you.mut_lvl("augmentation")
    sum = sum + BRC.you.mut_lvl("sharp scales")
  end

  return sum
end

local function get_staff_bonus_dmg(it, dmg_type)
  if dmg_type == BRC.DMG_TYPE.unbranded then return 0 end
  if dmg_type == BRC.DMG_TYPE.plain then
    local basename = it.name("base")
    if basename ~= "staff of earth" and basename ~= "staff of conjuration" then return 0 end
  end

  local spell_skill = BRC.you.skill(BRC.it.get_staff_school(it))
  local evo_skill = you.skill("Evocations")

  local chance = (2 * evo_skill + spell_skill) / 30
  if chance > 1 then chance = 1 end
  -- 0.75 is an acceptable approximation; most commonly 63/80
  -- Varies by staff type in sometimes complex ways
  local avg_dmg = 3 / 4 * (evo_skill / 2 + spell_skill)
  return avg_dmg * chance
end


--- Gets the updated stats after equipping an item
-- @param stats (table) Keys are artefact properties, values are the current values
-- If multiple equip slots available, assumes no item is removed.
-- @return (table) New stats table with updated values (original table is not modified)
local function get_stats_with_item(it, stats)
  local new_stats = util.copy_table(stats)
  local cur = items.equipped_at(it.equip_type)
  if not cur or it.equipped then return new_stats end

  if cur.artefact and BRC.you.num_eq_slots(it) == 1 then
    for k, _ in pairs(new_stats) do
      new_stats[k] = new_stats[k] - (cur.artprops[k] or 0)
    end
  end

  if it.artefact then
    for k, _ in pairs(new_stats) do
      new_stats[k] = new_stats[k] + (it.artprops[k] or 0)
    end
  end

  return new_stats
end

--- Get change in SH and EV when switching to shield
local function get_delta_sh_ev(it)
  local it_sh = BRC.eq.get_sh(it)
  local it_ev = -get_shield_penalty(it)
  local cur = items.equipped_at(it.equip_type)
  if not cur or it.equipped then
    return it_sh, it_ev
  else
    return it_sh - BRC.eq.get_sh(cur), it_ev + get_shield_penalty(cur)
  end
end

--- Get change in AC and EV when switching to armour
local function get_delta_ac_ev(it)
  local it_ac = BRC.eq.get_ac(it)
  local it_ev = BRC.eq.get_armour_ev(it)
  local cur = items.equipped_at(it.equip_type)
  if not cur or it.equipped or BRC.you.num_eq_slots(it) > 1 then
    return it_ac, it_ev
  else
    return it_ac - BRC.eq.get_ac(cur), it_ev - BRC.eq.get_armour_ev(cur)
  end
end

--- Calculate weapon damage using the brand bonuses in BRC.Config.BrandBonus
-- @param dmg_type int Matches a damage type defined in BRC.DMG_TYPE:
--   (1) unbranded: Only "heavy" is included
--   (2) plain: Include non-elemental damaging brands
--   (3) branded: Include all damaging brands
--   (4) scoring: Include heuristics from 'subtle' brands
local function get_dmg_with_brand_bonus(ego, base_dmg, it_plus, dmg_type)
  if not ego then return base_dmg + it_plus end

  -- Check if brand should apply based on damage type
  local should_apply = (
    dmg_type == BRC.DMG_TYPE.unbranded and ego == "heavy"
    or dmg_type == BRC.DMG_TYPE.plain and util.contains(BRC.NON_ELEMENTAL_DMG_EGOS, ego)
    or dmg_type >= BRC.DMG_TYPE.branded and BRC.Config.BrandBonus[ego]
    or dmg_type == BRC.DMG_TYPE.scoring and BRC.Config.BrandBonus.subtle[ego]
  )

  if should_apply then
    local bonus = BRC.Config.BrandBonus[ego] or BRC.Config.BrandBonus.subtle[ego]
    return bonus.factor * base_dmg + it_plus + bonus.offset
  else
    return base_dmg + it_plus
  end
end

---- Stat formatting functions ----
--- Format damage values for consistent display width (4 characters)
local function format_dmg(dmg)
  if dmg < 10 then return string.format("%.2f", dmg) end
  if dmg > 99.9 then return ">100" end
  return string.format("%.1f", dmg)
end

--- Format stat string for display or inscription
local function format_stat(abbr, val, is_worn)
  local stat_str = string.format("%.1f", val)
  if val < 0 then
    return string.format("%s%s", abbr, stat_str)
  elseif is_worn then
    return string.format("%s:%s", abbr, stat_str)
  else
    return string.format("%s+%s", abbr, stat_str)
  end
end

--- Get armour stats as strings
-- @return (string, string) AC or SH, and EV.  If not worn, returns deltas from the worn item stats
function BRC.eq.arm_stats(it)
  if not BRC.it.is_armour(it) then return "", "" end

  if BRC.it.is_shield(it) then
    local sh_delta, ev_delta = get_delta_sh_ev(it)
    local sh_str = format_stat("SH", sh_delta, it.equipped)
    local ev_str = format_stat("EV", ev_delta, it.equipped)
    return sh_str, ev_str
  else
    local ac_delta, ev_delta = get_delta_ac_ev(it)
    local ac_str = format_stat("AC", ac_delta, it.equipped)
    if not BRC.it.is_body_armour(it) then return ac_str end
    local ev_str = format_stat("EV", ev_delta, it.equipped)
    return ac_str, ev_str
  end
end

--- Get weapon stats as a string
-- @return (string) DPS, damage, delay, and accuracy
function BRC.eq.wpn_stats(it, dmg_type)
  if not it.is_weapon then return end
  if not dmg_type then
    if f_inscribe_stats and f_inscribe_stats.Config and f_inscribe_stats.Config.dmg_type then
      dmg_type = BRC.DMG_TYPE[f_inscribe_stats.Config.dmg_type]
    else
      dmg_type = BRC.DMG_TYPE.plain
    end
  end

  local dmg = format_dmg(BRC.eq.get_avg_dmg(it, dmg_type))
  local delay = BRC.eq.get_weap_delay(it)
  local delay_str = string.format("%.1f", delay)
  if delay < 1 then
    delay_str = string.format("%.2f", delay)
    delay_str = delay_str:sub(2, #delay_str)
  end

  local dps = format_dmg(dmg / delay)
  local acc = it.accuracy + (it.plus or 0)
  if acc >= 0 then acc = "+" .. acc end

  --TODO: This would be nice if it worked in all UIs
  --return string.format("DPS:<w>%s</w> (%s/%s), Acc<w>%s</w>", dps, dmg, delay_str, acc)
  return string.format("DPS: %s (%s/%s), Acc%s", dps, dmg, delay_str, acc)
end


---- Armour stats ----
function BRC.eq.get_ac(it)
  local it_plus = it.plus or 0

  if it.artefact then
    local art_ac = it.artprops["AC"]
    if art_ac then it_plus = it_plus + art_ac end
  end

  local ac = it.ac * (1 + you.skill("Armour") / 22) + it_plus
  if not BRC.it.is_body_armour(it) then return ac end

  if BRC.you.mut_lvl("deformed body") + BRC.you.mut_lvl("pseudopods") > 0 then ac = ac * 0.6 end

  return ac
end

--- Compute an armour's impact on EV, including stat changes from wearing/removing artefacts
function BRC.eq.get_armour_ev(it)
  local cur = { Str = you.strength(), Dex = you.dexterity(), EV = 0 }
  local worn = get_stats_with_item(it, cur)

  if worn.Str <= 0 then worn.Str = 1 end
  local bonus = get_adjusted_dodge_bonus(it.encumbrance, worn.Str, worn.Dex)

  if cur.Str <= 0 then cur.Str = 1 end
  local naked_bonus = get_adjusted_dodge_bonus(0, cur.Str, cur.Dex)

  return bonus - naked_bonus + worn.EV - get_adjusted_armour_pen(it.encumbrance, worn.Str)
end

function BRC.eq.get_sh(it)
  local stats = get_stats_with_item(it, { Dex = you.dexterity() })
  local it_plus = it.plus or 0
  local sh_skill = you.skill("Shields")

  local base_sh = it.ac * 2
  local shield = base_sh * (50 + sh_skill * 5 / 2)
  shield = shield + 200 * it_plus
  shield = shield + 38 * (sh_skill + 3 + stats.Dex * (base_sh + 13) / 26)
  return shield / 200
end


---- Weapon stats ----
function BRC.eq.get_weap_delay(it)
  local delay = it.delay - BRC.you.skill(it.weap_skill) / 2
  delay = math.max(delay, get_weap_min_delay(it))
  delay = get_branded_delay(delay, BRC.eq.get_ego(it))
  delay = math.max(delay, 3)

  local sh = items.equipped_at("offhand")
  if BRC.it.is_shield(sh) then delay = delay + get_shield_penalty(sh) end

  if it.is_ranged then
    local worn = items.equipped_at("armour")
    if worn then
      local str = you.strength()

      local cur = items.equipped_at("weapon")
      if cur and cur ~= it and cur.artefact then
        if it.artefact and it.artprops["Str"] then str = str + it.artprops["Str"] end
        if cur.artefact and cur.artprops["Str"] then str = str - cur.artprops["Str"] end
      end

      delay = delay + get_adjusted_armour_pen(worn.encumbrance, str)
    end
  end

  return delay / 10
end
--- Get weapon damage (average), including stat/slay changes when swapping from current weapon.
-- Aux attacks not included
function BRC.eq.get_avg_dmg(it, dmg_type)
  dmg_type = dmg_type or BRC.DMG_TYPE.scoring

  local it_plus = (it.plus or 0) + get_slay_bonuses()
  local stats = { Str = you.strength(), Dex = you.dexterity(), Slay = it_plus }
  stats = get_stats_with_item(it, stats)

  local stat = (it.is_ranged or it.weap_skill:contains("Blades")) and stats.Dex or stats.Str
  local stat_mod = 0.75 + 0.025 * stat
  local skill_mod = (1 + BRC.you.skill(it.weap_skill) / 50) * (1 + you.skill("Fighting") / 60)
  local base_dmg = it.damage * stat_mod * skill_mod

  if BRC.it.is_magic_staff(it) then
    return base_dmg + stats.Slay + get_staff_bonus_dmg(it, dmg_type)
  else
    return get_dmg_with_brand_bonus(BRC.eq.get_ego(it), base_dmg, stats.Slay, dmg_type)
  end
end

function BRC.eq.get_dps(it, dmg_type)
  if not dmg_type then dmg_type = BRC.DMG_TYPE.scoring end
  return BRC.eq.get_avg_dmg(it, dmg_type) / BRC.eq.get_weap_delay(it)
end


---- Item properties ----
--- Get the ego of an item, with custom logic:
-- Treat unusable egos as no ego. Always lowercase ego in return value.
-- Include armours with innate effects (except steam dragon scales)
-- Artefacts return their normal ego if they have one, else their name
-- @param no_stat_only_egos (optional bool) Exclude egos that only affect speed/damage
function BRC.eq.get_ego(it, no_stat_only_egos)
  local ego = it.ego(true)
  if ego then
    ego = ego:lower()
    if BRC.eq.is_useless_ego(ego) or (no_stat_only_egos and (ego == "speed" or ego == "heavy")) then
      return it.artefact and it.name() or nil
    end
    return ego
  end

  if BRC.it.is_body_armour(it) then
    local name = it.name("qual")
    local good_scales = name:contains("dragon scales") and not name:contains("steam")
    if name:contains("troll leather") or good_scales then return name end
  end

  return it.artefact and it.name() or nil
end

function BRC.eq.get_hands(it)
  if you.race() ~= "Formicid" then return it.hands end
  local st = it.subtype()
  if st == "giant club" or st == "giant spiked club" then return 2 end
  return 1
end

function BRC.eq.is_risky(it)
  if it.artefact then
    for k, v in pairs(it.artprops) do
      if util.contains(BRC.ARTPROPS_BAD, k) or v < 0 then return true end
    end
  end

  local ego_name = BRC.eq.get_ego(it)
  return ego_name and util.contains(BRC.RISKY_EGOS, ego_name)
end

function BRC.eq.is_useless_ego(ego)
  if BRC.MAGIC_SCHOOLS[ego] then
    return BRC.Config.unskilled_egos_usable or you.skill(BRC.MAGIC_SCHOOLS[ego]) > 0
  end

  local race = you.race()
  return ego == "holy" and util.contains(BRC.UNDEAD_RACES, race)
    or ego == "rPois" and util.contains(BRC.POIS_RES_RACES, race)
    or ego == "pain" and you.skill("Necromancy") == 0
end

}
############################### End lua/util/equipment.lua ###############################
##########################################################################################

################################### Begin lua/util/options.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC utility module
-- @module BRC.opt
-- Functions for setting crawl options and macros.
---------------------------------------------------------------------------------------------------

BRC.opt = {}

---- Single turn mutes: Mute a message for the current turn only ----
local _single_turn_mutes = {}

function BRC.opt.single_turn_mute(pattern)
  BRC.opt.message_mute(pattern, true)
  _single_turn_mutes[#_single_turn_mutes + 1] = pattern
end

function BRC.opt.clear_single_turn_mutes()
  util.foreach(_single_turn_mutes, function(m) BRC.opt.message_mute(m, false) end)
  _single_turn_mutes = {}
end

---- crawl.setopt() wrappers ----
function BRC.opt.autopickup_exceptions(pattern, create)
  local op = create and "^=" or "-="
  crawl.setopt(string.format("autopickup_exceptions %s %s", op, pattern))
end

function BRC.opt.explore_stop(pattern, create)
  local op = create and "+=" or "-="
  crawl.setopt(string.format("explore_stop %s %s", op, pattern))
end

function BRC.opt.explore_stop_pickup_ignore(pattern, create)
  local op = create and "+=" or "-="
  crawl.setopt(string.format("explore_stop_pickup_ignore %s %s", op, pattern))
end

function BRC.opt.flash_screen_message(pattern, create)
  local op = create and "+=" or "-="
  crawl.setopt(string.format("flash_screen_message %s %s", op, pattern))
end

function BRC.opt.force_more_message(pattern, create)
  local op = create and "+=" or "-="
  crawl.setopt(string.format("force_more_message %s %s", op, pattern))
end

--- Bind a macro to a key. Function must be global and not a member of a module.
-- If key is a number, it is converted to a keycode string.
function BRC.opt.macro(key, function_name)
  if type(_G[function_name]) ~= "function" then
    BRC.mpr.error("Function %s is not a global function", function_name)
    return
  end

  -- Format msg for debugging and keycode for crawl.setopt()
  local key_str = nil
  if type(key) == "number" then
    -- Try to convert to key name for better debug msg
    for k, v in pairs(BRC.KEYS) do
      if v == key then
        key_str = "<<< " .. k .. " >>"
        break
      end
    end
    -- Format keycode string for crawl.setopt()
    key = "\\{" .. key .. "}"
    if key_str == nil then key_str = "<<< \\" .. key .. " >>" end
  end

  -- The << >> formatting protects against crawl thinking '<' is a tag
  if key_str == nil then key_str = "<<< '" .. key .. "' >>" end

  crawl.setopt(string.format("macros += M %s ===%s", key, function_name))

  BRC.mpr.debug(
    string.format(
      "Assigned macro: %s to key: %s",
      BRC.txt.magenta(function_name .. "()"),
      BRC.txt.lightred(key_str)
    )
  )
end

function BRC.opt.message_mute(pattern, create)
  local op = create and "^=" or "-="
  crawl.setopt(string.format("message_colour %s mute:%s", op, pattern))
end

function BRC.opt.runrest_ignore_message(pattern, create)
  local op = create and "+=" or "-="
  crawl.setopt(string.format("runrest_ignore_message %s %s", op, pattern))
end

function BRC.opt.runrest_ignore_monster(pattern, create)
  local op = create and "+=" or "-="
  crawl.setopt(string.format("runrest_ignore_monster %s %s", op, pattern))
end

function BRC.opt.runrest_stop_message(pattern, create)
  local op = create and "+=" or "-="
  crawl.setopt(string.format("runrest_stop_message %s %s", op, pattern))
end

}
############################### End lua/util/options.lua ###############################
##########################################################################################

################################### Begin lua/core/data.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC core feature: data-manager
-- @module BRC.Data
-- Provides functions and maintenance for persistent variables that survive game restarts.
-- Handles backup/restore functionality and error handling.
---------------------------------------------------------------------------------------------------

BRC.Data = {}
BRC.Data.BRC_FEATURE_NAME = "data-manager" -- Included as a feature for Config override

---- Local constants ----
local RESTORE_TABLE = "_brc_persist_restore_table"
local MAX_RESTORE_RETRIES = 5  -- Maximum number of retry prompts for data restoration

---- Local variables ----
-- Init tables in declaration, so persist() can be called before init()
local _failures = {}
local _persist_names = {}
local _default_values = {}
local pushed_restore_table_creation = false -- Set this on file load, not on init()
local cur_location

---- Initialization ----
function BRC.Data.init()
  cur_location = you.where()
  if type(c_persist.BRC) ~= "table" then c_persist.BRC = {} end
end

---- Local functions ----
local function is_usable_backup()
  if
    type(c_persist.BRC) ~= "table"
    or type(c_persist.BRC.Backup) ~= "table"
    or c_persist.BRC.Backup.backup_name ~= you.name()
    or c_persist.BRC.Backup.backup_race ~= you.race()
    or c_persist.BRC.Backup.backup_class ~= you.class()
  then
    return false
  end

  local turn_diff = you.turns() - c_persist.BRC.Backup.backup_turn
  if turn_diff == 0 then return true end
  for _ = 1, MAX_RESTORE_RETRIES do
    if BRC.mpr.yesno("Use backup from " .. turn_diff .. " turns ago?") then return true end
    if BRC.mpr.yesno("Are you sure? Data will reset to defaults.") then return false end
  end
  return true
end

local function try_restore(failed_vars)
  if not is_usable_backup() then
    BRC.mpr.error("Unable to restore from backup. Persistent data reset to defaults.", true)
    BRC.mpr.info("For detailed startup info, set BRC.Config.mpr.show_debug_messages=True.")
    return false
  end

  for _, name in ipairs(failed_vars) do
    _default_values[name] = nil -- Avoid re-init warnings
    _G[name] = BRC.Data.persist(name, c_persist.BRC.Backup[name])
  end
  BRC.mpr.green("[BRC] Restored data from backup.")
  return true
end

---- Public API ----

--- Creates a persistent global variable or table, that retains its value through restarts.
-- @usage `var = BRC.Data.persist("var", value)`
-- @warning After restarting, the variable/table will not exist until this is called.
-- @return any The current value (whether default or persisted)
function BRC.Data.persist(name, default_value)
  local t = type(default_value)
  if not util.contains({ "table", "string", "number", "boolean", "nil" }, t) then
    BRC.mpr.error(string.format("Cannot persist %s. Default value is of type %s", name, t))
    return default_value
  end

  -- Keep default value for re-init
  if _default_values[name] then
    BRC.mpr.warning("Multiple calls to BRC.Data.persist(" .. name .. ", ...)")
  end
  if type(default_value) == "table" then
    -- Preserve the user's original table (may be in a config, etc)
    default_value = util.copy_table(default_value)
    _default_values[name] = util.copy_table(default_value)
  else
    _default_values[name] = default_value
  end

  -- Try to restore from persistent restore table
  if you.turns() == 0 then
    _G[name] = default_value
  elseif _G[RESTORE_TABLE] and _G[RESTORE_TABLE][name] ~= nil then
    _G[name] = _G[RESTORE_TABLE][name]
    _G[RESTORE_TABLE][name] = nil
  elseif default_value ~= nil and not util.contains(_failures, name) then -- avoid inf loop
    _G[name] = default_value
    _failures[#_failures + 1] = name
    BRC.mpr.debug(BRC.txt.red(name .. " failed to restore from chk_lua_save."))
  end

  -- Create persistent restore table on next startup
  if not pushed_restore_table_creation then
    table.insert(chk_lua_save, function()
      return RESTORE_TABLE .. " = {}\n"
    end)
    pushed_restore_table_creation = true
  end

  -- Set up persist on next startup
  if not util.contains(_persist_names, name) then
    _persist_names[#_persist_names + 1] = name
    table.insert(chk_lua_save, function()
      if _G[name] == nil then return "" end
      return RESTORE_TABLE .. "." .. name .. " = " .. BRC.txt.tostr(_G[name]) .. "\n"
    end)
  end

  return _G[name]
end

function BRC.Data.serialize()
  local tokens = { BRC.txt.lightmagenta("\n---PERSISTENT VARIABLES---\n") }
  local sorted_keys = BRC.util.get_sorted_keys(_persist_names)
  for _, key in ipairs(sorted_keys) do
    tokens[#tokens + 1] = string.format("%s = %s\n", key, BRC.txt.tostr(_G[key], true))
  end
  return table.concat(tokens)
end

function BRC.Data.reset()
  if _persist_names then
    for _, name in ipairs(_persist_names) do
      if type(_default_values[name]) == "table" then
        _G[name] = util.copy_table(_default_values[name])
      else
        _G[name] = _default_values[name]
      end
    end
  end

  BRC.mpr.warning("Reset all persistent data to default values.")
end

--- @return boolean|nil true if no persist errors, false if failed restore, nil if handled errors
function BRC.Data.handle_persist_errors()
  if #_failures == 0 then return true end
  local msg = "%s persistent variables did not restore: (%s)"
  BRC.mpr.error(msg:format(#_failures, table.concat(_failures, ", ")), true)

  for _ = 1, MAX_RESTORE_RETRIES do
    if BRC.mpr.yesno("Try restoring from backup?") then break end
    if BRC.mpr.yesno("Are you sure? Data will reset to defaults.") then return nil end
  end

  -- Whether restore works or not, we should reset _failures
  local failed_vars = _failures
  _failures = {}
  if try_restore(failed_vars) then return nil end
  return false
end

-- Backup and Restore from c_persist.BRC.Backup
function BRC.Data.backup()
  if type(c_persist.BRC) ~= "table" then c_persist.BRC = {} end
  c_persist.BRC.Backup = {}
  c_persist.BRC.Backup.backup_name = you.name()
  c_persist.BRC.Backup.backup_race = you.race()
  c_persist.BRC.Backup.backup_class = you.class()
  c_persist.BRC.Backup.backup_turn = you.turns()
  for _, name in ipairs(_persist_names) do
    c_persist.BRC.Backup[name] = _G[name]
  end
end

---- Crawl hook functions ----
function BRC.Data.ready()
  if you.where() ~= cur_location and not you.have_orb() then
    cur_location = you.where()
    BRC.Data.backup()
  end
end

}
############################### End lua/core/data.lua ###############################
##########################################################################################

################################### Begin lua/core/config.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC core module
-- @module BRC.Configs
-- Manages user-defined configs and feature config overrides.
--
-- TL;DR: Each feature has its own config, with default values for every field.
--   To change those values, define the same fields in a user-defined config.
--
-- When a user-defined config is loaded, it inherits values from BRC.Configs.Default.
-- If a user-defined config defines a field, that value is used.
--   If not defined in the config, the value in BRC.Configs.Default is used.
--   If not defined in either, the default value in the feature config is used.
-- @warning BRC.Configs.Default defines all fields not in a feature config. Do not remove them.
---------------------------------------------------------------------------------------------------

BRC.Configs = {}

---- Persistent variables ----
brc_full_persistant_config = BRC.Data.persist("brc_full_persistant_config", nil)
brc_config_name = BRC.Data.persist("brc_config_name", nil)

---- BRC Default Config - Every user-defined config inherits these
-- Define config fields that aren't feature-specific, and set their default values

BRC.Configs.Default = util.copy_table(BRC.Config) -- Include values from BRC.Config in _header.lua
BRC.Configs.Default.BRC_CONFIG_NAME = "Default"

-- Does "Armour of <MagicSkill>" have an ego when skill is 0?
BRC.Configs.Default.unskilled_egos_usable = false

BRC.Configs.Default.mpr = {
  show_debug_messages = false,
  logs_to_stderr = false,
} -- BRC.Configs.Default.mpr (do not remove this comment)

BRC.Configs.Default.dump = {
    max_lines_per_table = 200, -- Avoid huge tables (alert_monsters.Config.Alerts) in debug dumps
    omit_pointers = true, -- Don't dump functions and userdata (they only show a hex address)
} -- BRC.Configs.Default.dump (do not remove this comment)

--- How weapon damage is calculated for inscriptions+pickup/alert: (factor * DMG + offset)
BRC.Configs.Default.BrandBonus = {
    chaos = { factor = 1.2, offset = 2.0 }, -- Approximate weighted average
    distort = { factor = 1.0, offset = 6.0 },
    drain = { factor = 1.25, offset = 2.0 },
    elec = { factor = 1.0, offset = 4.5 },   -- 3.5 on avg; fudged up for AC pen
    flame = { factor = 1.25, offset = 0 },
    freeze = { factor = 1.25, offset = 0 },
    heavy = { factor = 1.8, offset = 0 },    -- Speed is accounted for elsewhere
    pain = { factor = 1.0, offset = you.skill("Necromancy") / 2 },
    spect = { factor = 1.35, offset = 0 },    -- Fudged down for increased incoming damage
    venom = { factor = 1.0, offset = 5.0 },  -- 5 dmg per poisoning

    subtle = { -- Values to use for weapon "scores" (not damage)
      antimagic = { factor = 1.15, offset = 0 },
      holy = { factor = 1.15, offset = 0 },
      penet = { factor = 1.3, offset = 0 },
      protect = { factor = 1.1, offset = 0 },
      reap = { factor = 1.3, offset = 0 },
      vamp = { factor = 1.2, offset = 0 },
      devious = { factor = 1.1, offset = 0 },
      valour = { factor = 1.15, offset = 0 },
      rebuke = { factor = 1.1, offset = 0 },
      concuss = { factor = 1.1, offset = 0 },
      sunder = { factor = 1.2, offset = 0 },
      entangle = { factor = 1.1, offset = 1.5 },
      slay = { factor = 1.15, offset = 0 },
  },
} -- BRC.Configs.Default.BrandBonus (do not remove this comment)

---- Local functions ----
local function is_config_module(p)
  return p
    and type(p) == "table"
    and p.BRC_CONFIG_NAME
    and type(p.BRC_CONFIG_NAME) == "string"
    and #p.BRC_CONFIG_NAME > 0
end

local function find_config_modules()
  for _, c in pairs(_G) do
    if is_config_module(c) then BRC.Configs[c.BRC_CONFIG_NAME] = c end
  end
end

--- @param input_name string "ask" or "previous" or a config name
-- @return string The valid name of a config
local function get_valid_config_name(input_name)
  if #BRC.Configs == 1 then return util.keys(BRC.Configs)[1] end

  if type(input_name) ~= "string" then
    BRC.mpr.warning("Non-string config name: " .. tostring(input_name))
  else
    local config_name = input_name:lower()
    if config_name == "ask" then
      -- If game has started, restore from the previously saved config name
      if you.turns() > 0 and brc_config_name then
        return get_valid_config_name(brc_config_name)
      end
    elseif config_name == "previous" then
      -- Restore from the config name in c_persist (cross-game persistence), or display warning
      if c_persist.BRC and c_persist.BRC.current_config then
        return get_valid_config_name(c_persist.BRC.current_config)
      else
        BRC.mpr.warning("No previous config found.")
      end
    else
      -- Find by name in BRC.Configs, or display warning
      for k, _ in pairs(BRC.Configs) do
        if config_name == k:lower() then return k end
      end
      BRC.mpr.warning("Could not load config: " .. tostring(input_name))
    end
  end

  return BRC.mpr.select("Select a config", util.keys(BRC.Configs))
end

local function safe_call_string(str, module_name)
  local chunk, err = loadstring(str)
  if not chunk then
    BRC.mpr.error("Error loading " .. module_name .. ".Config.init string: ", err)
  else
    local success, result = pcall(chunk)
    if not success then
      BRC.mpr.error("Error executing " .. module_name .. ".Config.init string: ", result)
    end
  end
end

local function execute_config_init(config, module_name)
  if type(config) ~= "table" then return end
  if type(config.init) == "function" then
    config.init()
  elseif type(config.init) == "string" then
    safe_call_string(config.init, module_name)
  end
end

--- Override values in dest, with values from source. Take care not to clear existing tables.
-- Does not override "init"
local function override_table(dest, source)
  if type(source) ~= "table" then return end

  for key, value in pairs(source) do
    if BRC.util.is_map(value) then
      if not dest[key] then dest[key] = {} end
      override_table(dest[key], value)
    elseif key ~= "init" then
      dest[key] = value
    end
  end
end

--- Load a config, either from a table or from a name.
-- @param config table of config values, or string name of a config
local function load_specific_config(config)
  BRC.Config = util.copy_table(BRC.Configs.Default)
  if type(config) == "table" then
    override_table(BRC.Config, config)
  else
    local name = get_valid_config_name(config)
    override_table(BRC.Config, BRC.Configs[name])
    execute_config_init(BRC.Config, "BRC")
    execute_config_init(BRC.Configs[name], "BRC.Configs." ..name)
  end

  -- Store persistent config info
  brc_config_name = BRC.Config.BRC_CONFIG_NAME
  if BRC.Config.store_config and BRC.Config.store_config:lower() == "full" then
    brc_full_persistant_config = BRC.Config
  end

  -- Init all features and apply any overrides from the loaded config
  for _ , value in pairs(BRC.get_registered_features()) do
    BRC.process_feature_config(value)
  end

  BRC.mpr.white("[BRC] Using config: " .. BRC.txt.lightcyan(BRC.Config.BRC_CONFIG_NAME))
end

---- Public API ----
--- Main config loading entry point
-- @param config table of config values, or string name of a config
function BRC.init_config(config)
  find_config_modules()

  if config then
    load_specific_config(config)
  else
    local store_mode = BRC.Config.store_config and BRC.Config.store_config:lower() or nil
    if store_mode == "full" then
      load_specific_config(brc_full_persistant_config or brc_config_name or BRC.Config.use_config)
    elseif store_mode == "name" then
      load_specific_config(brc_config_name or BRC.Config.use_config)
    else
      load_specific_config(BRC.Config.use_config)
    end
  end
end

--- Process a feature config: Ensure default values, init(), then override with BRC.Config values
function BRC.process_feature_config(feature)
  if type(feature.ConfigDefaults) == "table" then
    feature.Config = util.copy_table(feature.ConfigDefaults)
  else
    feature.Config = feature.Config or {}
    execute_config_init(feature.Config, feature.BRC_FEATURE_NAME)
    feature.ConfigDefaults = util.copy_table(feature.Config)
  end

  override_table(feature.Config, BRC.Config[feature.BRC_FEATURE_NAME])
end

--- Stringify BRC.Config and each feature config, with headers
-- @return table of strings, one for each config section (1 big string will overflow crawl.mpr())
function BRC.serialize_config()
  local tokens = {}
  tokens[#tokens + 1] = BRC.txt.lightcyan("\n---BRC Config---\n") .. BRC.txt.tostr(BRC.Config, true)

  local all_features = BRC.get_registered_features()
  local keys = util.keys(all_features)
  util.sort(keys)

  for i = 1, #keys do
    local name = keys[i]
    local feature = all_features[name]
    if feature.Config then
      local header = BRC.txt.cyan("\n\n---Feature Config: " .. name .. "---\n")
      tokens[#tokens + 1] = header .. BRC.txt.tostr(feature.Config, true)
    end
  end

  return tokens
end

---- Initialize BRC.Config for debugging during startup + data.persist() calls ----
override_table(BRC.Config, BRC.Configs.Default)

}
############################### End lua/core/config.lua ###############################
##########################################################################################

################################### Begin lua/core/hotkey.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC core feature: hotkey
-- @module BRC.Hotkey
-- Manages the BRC hotkey, and provides functions to add actions to it.
---------------------------------------------------------------------------------------------------

BRC.Hotkey = {}
BRC.Hotkey.BRC_FEATURE_NAME = "hotkey"
BRC.Hotkey.Config = {
  key = { keycode = BRC.KEYS.NPenter, name = "[NPenter]" },
  skip_keycode = BRC.KEYS.ESC,
  equip_hotkey = true, -- Offer to equip after picking up equipment
  wait_for_safety = true, -- Don't expire the hotkey with monsters in view
  explore_clears_queue = true, -- Clear the hotkey queue on explore
  move_to_feature = {
    -- Hotkey move to, for these features. Also includes all portal entrances if table is not nil.
    enter_temple = "Temple", enter_lair = "Lair", altar_ecumenical = "faded altar",
    enter_bailey = "flagged portal", enter_bazaar = "bazaar",
    enter_desolation = "crumbling gateway", enter_gauntlet = "gauntlet",
    enter_ice_cave = "frozen archway", enter_necropolis = "phantasmal passage",
    enter_ossuary = "sand-covered staircase", enter_sewer = "glowing drain",
    enter_trove = "trove of treasure", enter_volcano = "dark tunnel",
    enter_wizlab = "magical portal", enter_ziggurat = "ziggurat",
  },
} -- BRC.Hotkey.Config (do not remove this comment)

---- Local constants ----
local WAYPOINT_MUTES = {
  "Assign waypoint to what number",
  "Existing waypoints",
  "Delete which waypoint",
  "\\(\\d\\) ",
  "All waypoints deleted",
  "You're already here!",
  "Okay\\, then\\.",
  "Unknown command",
  "Waypoint \\d (re-)?assigned",
  "Waypoints will disappear",
} -- WAYPOINT_MUTES (do not remove this comment)

---- Local variables ----
local action_queue
local cur_action
local delay_expire

---- Initialization ----
function BRC.Hotkey.init()
  action_queue = {}
  cur_action = nil
  delay_expire = false

  BRC.opt.macro(BRC.Hotkey.Config.key.keycode, "macro_brc_hotkey")
  BRC.opt.macro(BRC.Hotkey.Config.skip_keycode, "macro_brc_skip_hotkey")
end

---- Local functions ----
local function display_cur_message()
  local msg = string.format("[BRC] Press %s to %s.", BRC.Hotkey.Config.key.name, cur_action.msg)
  BRC.mpr.que(msg, BRC.COL.magenta)
end

local function load_next_action()
  if #action_queue == 0 then return end
  cur_action = table.remove(action_queue, 1)
  if cur_action.condition() then
    cur_action.turn = you.turns() + 1
    display_cur_message()
    delay_expire = false
  else
    cur_action = nil
    load_next_action()
  end
end

local function expire_cur_action()
  if cur_action then cur_action.cleanup() end
  cur_action = nil
  load_next_action()
end

--- Get the highest available waypoint slot
local function get_avail_waypoint()
  for i = 9, 0, -1 do
    if not travel.waypoint_delta(i) then return i end
  end

  BRC.mpr.debug("No available waypoint slots. Clearing them all.")
  util.foreach(WAYPOINT_MUTES, function(m) BRC.opt.single_turn_mute(m) end)
  crawl.sendkeys({ BRC.util.cntl("w"), "d", "*" })
  crawl.flush_input()
end

---- Macro function: On BRC hotkey press ----
function macro_brc_hotkey()
  if cur_action then
    cur_action.action()
  else
    BRC.mpr.info("Unknown command (no action assigned to hotkey).")
  end
end

function macro_brc_skip_hotkey()
  if cur_action and (you.feel_safe() or not BRC.Hotkey.Config.wait_for_safety) then
    expire_cur_action()
    if not cur_action then BRC.mpr.info("Hotkey cleared.") end
  else
    crawl.sendkeys({ BRC.Hotkey.Config.skip_keycode })
    crawl.flush_input()
  end
end

---- Public API ----
--- Assign an action to the BRC hotkey
-- @param prefix string - The action (equip/pickup/read/etc)
-- @param suffix string - Printed after the action. Usually an item name
-- @param push_front boolean - Push the action to the front of the queue
-- @param f_action function - The function to call when the hotkey is pressed
-- @param f_condition optional function (return bool) - If the action is still valid
-- @param f_cleanup optional function - Function to call after hotkey pressed or skipped
-- @return nil
function BRC.Hotkey.set(prefix, suffix, push_front, f_action, f_condition, f_cleanup)
  local act = {
    msg = BRC.txt.lightgreen(prefix) .. (suffix and (" " .. BRC.txt.white(suffix)) or ""),
    action = f_action,
    condition = f_condition or function() return true end,
    cleanup = f_cleanup or function() end,
  } -- act (do not remove this comment)

  if push_front then
    table.insert(action_queue, 1, act)
  else
    table.insert(action_queue, act)
  end
end

function BRC.Hotkey.equip(it, push_front)
  if not (it.is_weapon or BRC.it.is_armour(it, true) or BRC.it.is_jewellery(it)) then return end
  local name = it.name():gsub(" {.*}", "")

  local condition = function()
    local inv_items = util.filter(function(i)
      return i.name():gsub(" {.*}", "") == name
    end, items.inventory())
    return util.exists(inv_items, function(i) return not i.equipped end)
  end

  local do_equip = function()
    local inv_items = util.filter(function(i)
      return i.name():gsub(" {.*}", "") == name
    end, items.inventory())

    local already_eq = false
    for i = 1, #inv_items do
      if inv_items[i].equipped then
        already_eq = true
      else
        inv_items[i]:equip()
        return
      end
    end

    if already_eq then
      BRC.mpr.info("Already equipped.")
    else
      BRC.mpr.error("Could not find unequipped item '" .. name .. "' in inventory.")
    end
  end

  BRC.Hotkey.set("equip", it.name(), push_front, do_equip, condition)
end

--- Pick up an item by name (Must use name, since item goes stale when called from equip hotkey)
function BRC.Hotkey.pickup(name, push_front)
  local condition = function()
    return util.exists(you.floor_items(), function(fl) return fl.name():contains(name) end)
  end

  local do_pickup = function()
    for _, fl in ipairs(you.floor_items()) do
      -- Check with contains() in case ID'ing it appends to the name
      if fl.name():contains(name) then
        items.pickup(fl)
        return
      end
    end
    BRC.mpr.info(name .. " isn't here!")
  end

  BRC.Hotkey.set("pickup", name, push_front, do_pickup, condition)
end

--- Set hotkey as 'move to <name>', if it's in LOS
-- If feature_name provided, moves to that feature, otherwise searches for the item by name
function BRC.Hotkey.waypoint(name, push_front, feature_name)
  if util.contains(BRC.PORTAL_FEATURE_NAMES, you.branch()) then
    return -- Can't auto-travel
  end

  local x, y
  if feature_name ~= nil then
    local r = you.los()
    for dx = -r, r do
      for dy = -r, r do
        if view.feature_at(dx, dy) == feature_name then
          x, y = dx, dy
          break
        end
      end
    end
  else
    x, y = BRC.it.get_xy(name)
  end
  if x == nil then return BRC.mpr.debug(name .. " not found in LOS") end

  local waynum = get_avail_waypoint()
  if not waynum then return end
  util.foreach(WAYPOINT_MUTES, function(m) BRC.opt.single_turn_mute(m) end)
  travel.set_waypoint(waynum, x, y)

  local is_valid = function()
    local dx, dy = travel.waypoint_delta(waynum)
    return dx and not(dx == 0 and dy == 0)
  end

  local move_to_waypoint = function()
    f_pickup_alert.pause_alerts() -- Don't interrupt hotkey travel with new alerts
    crawl.sendkeys({ BRC.util.get_cmd_key("CMD_INTERLEVEL_TRAVEL"), tostring(waynum) })
    crawl.flush_input()
  end

  local clear_waypoint = function()
    local keys = { BRC.util.cntl("w"), "d", tostring(waynum) }
    -- If other waypoints exist, need to send ESC to exit the prompt
    for i = 0, 9 do
      if i ~= waynum and travel.waypoint_delta(i) then
        keys[#keys + 1] = BRC.KEYS.ESC
      end
    end

    util.foreach(WAYPOINT_MUTES, function(m) BRC.opt.single_turn_mute(m) end)
    crawl.sendkeys(keys)
    crawl.flush_input()

    if not feature_name then
      BRC.Hotkey.pickup(name, true)
    end
  end

  BRC.Hotkey.set("move to", name, push_front, move_to_waypoint, is_valid, clear_waypoint)
end

---- Crawl hook functions ----
function BRC.Hotkey.c_assign_invletter(it)
  if BRC.Hotkey.Config.equip_hotkey then BRC.Hotkey.equip(it, true) end
end

function BRC.Hotkey.ch_start_running(kind)
  if BRC.Hotkey.Config.explore_clears_queue and kind:contains("explore") then
    action_queue = {}
    cur_action = nil
  end
end

function BRC.Hotkey.c_message(text, channel)
  if channel ~= "plain" then return end
  if BRC.Hotkey.Config.move_to_feature == nil then return end
  if not text:contains("Found") then return end

  for k, v in pairs(BRC.Hotkey.Config.move_to_feature) do
    if text:contains(v) then
      BRC.Hotkey.waypoint(v, true, k)
    end
  end
  for k, v in pairs(BRC.PORTAL_FEATURE_NAMES) do
    if text:contains(v) then
      BRC.Hotkey.waypoint(v, true, k)
    end
  end
end

function BRC.Hotkey.ready()
  if cur_action == nil then
    load_next_action()
  elseif cur_action.turn > you.turns() then
    return
  elseif BRC.Hotkey.Config.wait_for_safety and not you.feel_safe() and cur_action.condition() then
    delay_expire = true
  elseif delay_expire and you.feel_safe() then
    delay_expire = false
    display_cur_message()
  else
    expire_cur_action()
  end
end

}
############################### End lua/core/hotkey.lua ###############################
##########################################################################################

################################### Begin lua/core/brc.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC core module
-- @module BRC
-- @author buehler
-- Serves as the central coordinator for all feature modules.
-- Automatically loads any global module/table that defines `BRC_FEATURE_NAME`
-- and manages the feature's lifecycle and hook dispatching.
---------------------------------------------------------------------------------------------------

---- Local constants ----
BRC.VERSION = "1.2.0"
BRC.MIN_CRAWL_VERSION = "0.34"

local HOOK_FUNCTIONS = {
  autopickup = "autopickup",
  c_answer_prompt = "c_answer_prompt",
  c_assign_invletter = "c_assign_invletter",
  c_message = "c_message",
  ch_start_running = "ch_start_running",
  init = "init",
  ready = "ready",
} -- HOOK_FUNCTIONS (do not remove this comment)

---- Local variables ----
local _features
local _hooks
local turn_count = -1 -- Do not reset this in init()

---- Local functions ----
local function char_dump(add_debug_info)
  if add_debug_info then
    crawl.take_note(BRC.dump(true, true))
    BRC.mpr.info("Debug info added to character dump.")
  else
    BRC.mpr.info("No debug info added.")
  end

  BRC.util.do_cmd("CMD_CHARACTER_DUMP")
end

local function feature_is_disabled(f)
  local main = BRC.Config[f.BRC_FEATURE_NAME]
  if main and main.disabled == false then return false end -- catch override not yet applied
  return (f.Config and f.Config.disabled) or (main and main.disabled)
end

local function handle_feature_error(feature_name, hook_name, result)
  BRC.mpr.error(string.format("Failure in %s.%s", feature_name, hook_name), result, true)
  if BRC.mpr.yesno(string.format("Deactivate %s?", feature_name), BRC.COL.yellow) then
    BRC.unregister(feature_name)
  else
    BRC.mpr.okay()
  end
end

local function handle_core_error(hook_name, result, ...)
  local params = { hook_name }
  for i = 1, select("#", ...) do
    local param = select(i, ...)
    if param and type(param.name) == "function" then
      params[#params + 1] = "[" .. param.name() .. "]"
    else
      params[#params + 1] = BRC.txt.tostr(param, true)
    end
  end

  local msg = "BRC failure in safe_call_all_hooks(" .. table.concat(params, ", ") .. ")"
  BRC.mpr.error(msg, result, true)
  if BRC.mpr.yesno("Deactivate BRC." .. hook_name .. "?", BRC.COL.yellow) then
    _hooks[hook_name] = nil
    BRC.mpr.brown("Unregistered hook: " .. tostring(hook_name))
  else
    BRC.mpr.okay("Returning nil to " .. hook_name .. ".")
  end
end

-- Hook management
local function call_all_hooks(hook_name, ...)
  local last_return_value = nil
  local returning_feature = nil

  for i = #_hooks[hook_name], 1, -1 do
    local hook_info = _hooks[hook_name][i]
    if not feature_is_disabled(_features[hook_info.feature_name]) then
      if hook_name == HOOK_FUNCTIONS.init then
        BRC.mpr.debug(string.format("Initialize %s...", BRC.txt.lightcyan(hook_info.feature_name)))
      end
      local success, result = pcall(hook_info.func, ...)
      if not success then
        handle_feature_error(hook_info.feature_name, hook_name, result)
      elseif result ~= nil and last_return_value ~= result then
        -- Only track non-nil return values. This actually matters for autopickup
        if hook_name == HOOK_FUNCTIONS.autopickup then
          -- Unique case. One false will block autopickup.
          if result == false or last_return_value == nil then
            last_return_value = result
            returning_feature = hook_info.feature_name
          end
        else
          if last_return_value ~= nil then
            BRC.mpr.warning(
              string.format(
                "Return value mismatch in %s:\n  (first) %s -> %s\n  (final) %s -> %s",
                hook_name,
                returning_feature,
                BRC.txt.tostr(last_return_value, true),
                hook_info.feature_name,
                BRC.txt.tostr(result, true)
              )
            )
          end
          last_return_value = result
          returning_feature = hook_info.feature_name
        end
      end
    end
  end
  return last_return_value
end

--- Errors in this function won't show up in crawl, so it's kept simple and safe.
local function safe_call_all_hooks(hook_name, ...)
  if not (_hooks and _hooks[hook_name] and #_hooks[hook_name] > 0) then return end

  local success, result = pcall(call_all_hooks, hook_name, ...)
  if success then return result end

  success, result = pcall(handle_core_error, hook_name, result, ...)
  if success then return end

  -- This is a serious error. Failed in the hook, and when we tried to report it.
  BRC.mpr.error("Failed to handle BRC core error!", result, true)
  if BRC.mpr.yesno("Dump char and deactivate BRC?", BRC.COL.yellow) then
    BRC.active = false
    BRC.mpr.brown("BRC deactivated.", "Error in hook: " .. tostring(hook_name))
    pcall(char_dump, true)
  else
    BRC.mpr.okay()
  end
end

-- Register all features in the global namespace
local function register_all_features()
  -- Find all feature modules
  local feature_names = {}
  for name, value in pairs(_G) do
    if BRC.is_feature_module(value) then feature_names[#feature_names + 1] = name end
  end

  -- Sort alphabetically (for reproducable behavior)
  util.sort(feature_names)

  -- Register features
  local loaded_count = 0
  for _, name in ipairs(feature_names) do
    local success = BRC.register(_G[name])
    if success then
      loaded_count = loaded_count + 1
    elseif success == false then
      BRC.mpr.error("Failed to register feature: " .. name .. ". Aborting bulk registration.")
      return loaded_count
    end
  end

  return loaded_count
end


---- Public API ----
function BRC.get_registered_features()
  return _features
end

function BRC.is_feature_module(f)
  return f
    and type(f) == "table"
    and f.BRC_FEATURE_NAME
    and type(f.BRC_FEATURE_NAME) == "string"
    and #f.BRC_FEATURE_NAME > 0
end

-- BRC.register(): Return true if success, false if error, nil if feature is disabled
function BRC.register(f)
  if not BRC.is_feature_module(f) then
    BRC.mpr.error("Tried to register a non-feature module! Module contents:\n" .. BRC.txt.tostr(f))
    return false
  elseif _features[f.BRC_FEATURE_NAME] then
    BRC.mpr.warning(BRC.txt.lightcyan(f.BRC_FEATURE_NAME) .. " already registered! Repeating...")
    BRC.unregister(f.BRC_FEATURE_NAME)
  end

  if feature_is_disabled(f) then
    BRC.mpr.debug(BRC.txt.lightcyan(f.BRC_FEATURE_NAME) .. " is disabled. Skipped registration.")
    return nil
  else
    if not BRC.Config[f.BRC_FEATURE_NAME] then BRC.Config[f.BRC_FEATURE_NAME] = {} end
    if not f.Config then f.Config = {} end
  end

  BRC.mpr.debug(string.format("Registering %s...", BRC.txt.lightcyan(f.BRC_FEATURE_NAME)))
  _features[f.BRC_FEATURE_NAME] = f

  -- Register hooks
  for _, hook_name in pairs(HOOK_FUNCTIONS) do
    if f[hook_name] then
      if not _hooks[hook_name] then _hooks[hook_name] = {} end
      table.insert(_hooks[hook_name], {
        feature_name = f.BRC_FEATURE_NAME,
        hook_name = hook_name,
        func = f[hook_name],
      })
    end
  end

  BRC.process_feature_config(f)

  return true
end

function BRC.unregister(name)
  if not _features[name] then
    BRC.mpr.error(BRC.txt.yellow(name) .. " is not registered. Cannot unregister.")
    return false
  end

  _features[name] = nil
  local removed = {}
  for hook_name, hooks in pairs(_hooks) do
    for i = #hooks, 1, -1 do
      if hooks[i].feature_name == name then
        table.remove(hooks, i)
        removed[#removed + 1] = hook_name
      end
    end
  end

  BRC.mpr.info(string.format("Unregistered %s.", name))
  BRC.mpr.debug(string.format("Unregistered %s hooks: (%s)", name, table.concat(removed, ", ")))
  return true
end

-- @param config table of config values, or string name of a config
function BRC.reset(config)
  BRC.active = false
  BRC.Data.reset()
  BRC.init(config)
end

-- @param config table of config values, or string name of a config
function BRC.init(config)
  BRC.active = false
  _features = {}
  _hooks = {}

  if not BRC.util.version_is_valid(BRC.MIN_CRAWL_VERSION) then
    BRC.mpr.error(string.format(
      "BRC v%s requires crawl v%s or higher. You are running %s.",
      BRC.VERSION,
      BRC.txt.yellow(BRC.MIN_CRAWL_VERSION),
      BRC.txt.yellow(crawl.version("major"))
    ))
    if not BRC.mpr.yesno("Continue loading BRC anyway?", BRC.COL.yellow) then
      BRC.mpr.brown("BRC deactivated.")
      return false
    end
  end

  BRC.init_config(config)
  BRC.mpr.debug("Config loaded.")

  BRC.mpr.debug("Register core features...")
  BRC.register(BRC.Data)
  BRC.register(BRC.Hotkey)

  BRC.mpr.debug("Register features...")
  register_all_features()

  BRC.mpr.debug("Initialize features...")
  safe_call_all_hooks(HOOK_FUNCTIONS.init)
  local suffix = BRC.txt.blue(string.format(" (%s features)", #util.keys(_features)))

  BRC.mpr.debug("Add non-feature hooks...")
  add_autopickup_func(BRC.autopickup)
  BRC.opt.macro(BRC.util.get_cmd_key("CMD_CHARACTER_DUMP") or "#", "macro_brc_dump_character")

  BRC.mpr.debug("Verify persistent data reload...")
  local success = BRC.Data.handle_persist_errors()
  if success then
    BRC.Data.backup() -- Only backup after a clean startup
    local msg = string.format("Successfully initialized BRC v%s!%s", BRC.VERSION, suffix)
    BRC.mpr.lightgreen("\n" .. BRC.txt.wrap(msg, BRC.EMOJI.SUCCESS) .. "\n")
  else
    -- success == nil if errors were resolved, false if tried restore but failed
    if success == false and BRC.mpr.yesno("Deactivate BRC?" .. suffix, BRC.COL.yellow) then
      BRC.active = false
      BRC.mpr.lightred("\nBRC is off.\n")
      return false
    end
    BRC.mpr.magenta(string.format("\nInitialized BRC v%s with warnings!%s\n", BRC.VERSION, suffix))
  end

  -- Avoid weird effects from autopickup before first turn
  BRC.active = you.turns() > 0
  return true
end

--- Pull debug info. Print to mpr() and return as string
-- @param skip_mpr (optional bool) Used in char_dump to just return the string
function BRC.dump(verbose, skip_mpr)
  local tokens = {}
  tokens[#tokens + 1] = BRC.Data.serialize()
  if verbose then
    tokens[#tokens + 1] = BRC.txt.serialize_chk_lua_save()
    tokens[#tokens + 1] = BRC.txt.serialize_inventory()
    util.append(tokens, BRC.serialize_config())
  end

  if not skip_mpr then
    for _, token in ipairs(tokens) do
      BRC.mpr.white(token)
    end
  end

  return table.concat(tokens, "\n")
end

---- Macros ----
function macro_brc_dump_character()
  if not BRC.active then BRC.util.do_cmd("CMD_CHARACTER_DUMP") end
  char_dump(BRC.mpr.yesno("Add BRC debug info to character dump?", BRC.COL.lightcyan))
end

---- Crawl hooks ----
function BRC.autopickup(it, _)
  return safe_call_all_hooks(HOOK_FUNCTIONS.autopickup, it)
end

function BRC.c_answer_prompt(prompt)
  if not BRC.active then return end
  if not prompt then return end -- This fires from crawl, e.g. Shop purchase confirmation
  return safe_call_all_hooks(HOOK_FUNCTIONS.c_answer_prompt, prompt)
end

function BRC.c_assign_invletter(it)
  if not BRC.active then return end
  return safe_call_all_hooks(HOOK_FUNCTIONS.c_assign_invletter, it)
end

function BRC.c_message(text, channel)
  if not BRC.active then return end
  safe_call_all_hooks(HOOK_FUNCTIONS.c_message, text, channel)
end

function BRC.ch_start_running(kind)
  if not BRC.active then return end
  safe_call_all_hooks(HOOK_FUNCTIONS.ch_start_running, kind)
end

function BRC.ready()
  if you.turns() == 0 then BRC.active = true end
  if not BRC.active then return end
  crawl.redraw_screen()
  BRC.opt.clear_single_turn_mutes()

  if you.turns() > turn_count then
    turn_count = you.turns()
    safe_call_all_hooks(HOOK_FUNCTIONS.ready)
  end

  -- Always display messages, even if same turn
  BRC.mpr.consume_queue()
end

}
############################### End lua/core/brc.lua ###############################
##########################################################################################

################################### Begin lua/features/announce-hp-mp.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: announce-hp-mp
-- @module f_announce_hp_mp
-- @author magus, buehler
-- Announce changes in HP/MP, with visual meters and additional warnings for severe damage.
---------------------------------------------------------------------------------------------------

f_announce_hp_mp = {}
f_announce_hp_mp.BRC_FEATURE_NAME = "announce-hp-mp"
f_announce_hp_mp.Config = {
  dmg_flash_threshold = 0.20, -- Flash screen when losing this % of max HP
  dmg_fm_threshold = 0.30, -- Force more for losing this % of max HP
  always_on_bottom = false, -- Rewrite HP/MP meters after each turn with messages
  meter_length = 5, -- Number of pips in each meter

  Announce = {
    hp_loss_limit = 1, -- Announce when HP loss >= this
    hp_gain_limit = 4, -- Announce when HP gain >= this
    mp_loss_limit = 1, -- Announce when MP loss >= this
    mp_gain_limit = 2, -- Announce when MP gain >= this
    hp_first = true, -- Show HP first in the message
    same_line = true, -- Show HP/MP on the same line
    always_both = true, -- If showing one, show both
    very_low_hp = 0.10, -- At this % of max HP, show all HP changes and mute % HP alerts
  },

  HP_METER = BRC.Config.emojis and { FULL = "❤️", PART = "❤️‍🩹", EMPTY = "🤍" } or {
    BORDER = BRC.txt.white("|"),
    FULL = BRC.txt.lightgreen("+"),
    PART = BRC.txt.lightgrey("+"),
    EMPTY = BRC.txt.darkgrey("-"),
  },

  MP_METER = BRC.Config.emojis and { FULL = "🟦", PART = "🔹", EMPTY = "➖" } or {
    BORDER = BRC.txt.white("|"),
    FULL = BRC.txt.lightblue("+"),
    PART = BRC.txt.lightgrey("+"),
    EMPTY = BRC.txt.darkgrey("-"),
  },
} -- f_announce_hp_mp.Config (do not remove this comment)

---- Persistent variables ----
ad_prev = BRC.Data.persist("ad_prev", { hp = 0, mhp = 0, mp = 0, mmp = 0 })

---- Local constants ----
local ALWAYS_BOTTOM_SETTINGS = {
  hp_loss_limit = 0, hp_gain_limit = 0, mp_loss_limit = 0, mp_gain_limit = 0,
  hp_first = true, same_line = true, always_both = true, very_low_hp = 0,
} -- ALWAYS_BOTTOM_SETTINGS (do not remove this comment)

---- Local variables ----
local C -- config alias

---- Initialization ----
function f_announce_hp_mp.init()
  C = f_announce_hp_mp.Config

  ad_prev.hp = 0
  ad_prev.mhp = 0
  ad_prev.mp = 0
  ad_prev.mmp = 0

  if C.always_on_bottom then C.Announce = ALWAYS_BOTTOM_SETTINGS end

  if C.dmg_fm_threshold > 0 and C.dmg_fm_threshold <= 0.5 then
      BRC.opt.message_mute("Ouch! That really hurt!", true)
  end
end

---- Local functions ----
local function create_meter(perc, emojis)
  perc = math.max(0, math.min(1, perc)) -- Clamp between 0 and 1

  local num_halfpips = math.floor(perc * C.meter_length * 2)
  local num_full_emojis = math.floor(num_halfpips / 2)
  local num_part_emojis = num_halfpips % 2
  local num_empty_emojis = C.meter_length - num_full_emojis - num_part_emojis

  return table.concat({
    emojis.BORDER or "",
    string.rep(emojis.FULL, num_full_emojis),
    string.rep(emojis.PART, num_part_emojis),
    string.rep(emojis.EMPTY, num_empty_emojis),
    emojis.BORDER or "",
  })
end

local function format_delta(delta)
  if delta > 0 then
    return BRC.txt.green("+" .. delta)
  elseif delta < 0 then
    return BRC.txt.lightred(delta)
  else
    return BRC.txt.darkgrey("+0")
  end
end

local function format_ratio(cur, max)
  local color
  if cur <= (max * 0.25) then
    color = BRC.COL.red
  elseif cur <= (max * 0.50) then
    color = BRC.COL.lightred
  elseif cur <= (max * 0.75) then
    color = BRC.COL.yellow
  elseif cur < max then
    color = BRC.COL.lightgrey
  else
    color = BRC.COL.green
  end

  return BRC.txt[color](string.format(" -> %s/%s", cur, max))
end

local function get_hp_message(hp_delta, mhp_delta)
  local hp, mhp = you.hp()
  local msg_tokens = {}
  msg_tokens[#msg_tokens + 1] = create_meter(hp / mhp, C.HP_METER)
  msg_tokens[#msg_tokens + 1] = BRC.txt.white(string.format(" HP[%s]", format_delta(hp_delta)))
  msg_tokens[#msg_tokens + 1] = format_ratio(hp, mhp)

  if mhp_delta ~= 0 then
    local text = string.format(" (%s max HP)", format_delta(mhp_delta))
    msg_tokens[#msg_tokens + 1] = BRC.txt.lightgrey(text)
  end

  if not C.Announce.same_line and hp == mhp then
    msg_tokens[#msg_tokens + 1] = BRC.txt.white(" (Full HP)")
  end

  return table.concat(msg_tokens)
end

local function get_mp_message(mp_delta, mmp_delta)
  local mp, mmp = you.mp()
  local msg_tokens = {}
  msg_tokens[#msg_tokens + 1] = create_meter(mp / mmp, C.MP_METER)
  msg_tokens[#msg_tokens + 1] = BRC.txt.lightcyan(string.format(" MP[%s]", format_delta(mp_delta)))
  msg_tokens[#msg_tokens + 1] = format_ratio(mp, mmp)

  if mmp_delta ~= 0 then
    local tok = string.format(" (%s max MP)", format_delta(mmp_delta))
    msg_tokens[#msg_tokens + 1] = BRC.txt.cyan(tok)
  end

  if not C.Announce.same_line and mp == mmp then
    msg_tokens[#msg_tokens + 1] = BRC.txt.lightcyan(" (Full MP)")
  end

  return table.concat(msg_tokens)
end

local function last_msg_is_meter()
  local meter_chars = C.meter_length + 2 * #(BRC.txt.clean(C.HP_METER.BORDER) or "")
  local last_msg = crawl.messages(1)
  if not (last_msg and #last_msg > meter_chars + 4) then return false end

  local s = last_msg:sub(meter_chars + 1, meter_chars + 4)
  return s == " HP[" or s == " MP["
end

---- Crawl hook functions ----
function f_announce_hp_mp.ready()
  -- Update prev state first, so we can safely return early below
  local hp, mhp = you.hp()
  local mp, mmp = you.mp()
  local is_startup = ad_prev.hp == 0
  local hp_delta = hp - ad_prev.hp
  local mp_delta = mp - ad_prev.mp
  local mhp_delta = mhp - ad_prev.mhp
  local mmp_delta = mmp - ad_prev.mmp
  local damage_taken = mhp_delta - hp_delta
  ad_prev.hp = hp
  ad_prev.mhp = mhp
  ad_prev.mp = mp
  ad_prev.mmp = mmp

  if is_startup then return end
  if hp_delta == 0 and mp_delta == 0 and last_msg_is_meter() then return end
  local is_very_low_hp = hp <= C.Announce.very_low_hp * mhp

  -- Determine which messages to show
  local do_hp = true
  local do_mp = true
  if hp_delta <= 0 and hp_delta > -C.Announce.hp_loss_limit then do_hp = false end
  if hp_delta >= 0 and hp_delta < C.Announce.hp_gain_limit then do_hp = false end
  if mp_delta <= 0 and mp_delta > -C.Announce.mp_loss_limit then do_mp = false end
  if mp_delta >= 0 and mp_delta < C.Announce.mp_gain_limit then do_mp = false end

  if not do_hp and is_very_low_hp and hp_delta ~= 0 then do_hp = true end
  if not do_hp and not do_mp then return end
  if C.Announce.always_both then
    do_hp = true
    do_mp = true
  end

  -- Put messages together
  local hp_msg = get_hp_message(hp_delta, mhp_delta)
  local mp_msg = get_mp_message(mp_delta, mmp_delta)
  local msg_tokens = {}
  msg_tokens[1] = (C.Announce.hp_first and do_hp) and hp_msg or mp_msg
  if do_mp and do_hp then
    msg_tokens[2] = C.Announce.same_line and string.rep(" ", 7) or "\n"
    msg_tokens[3] = C.Announce.hp_first and mp_msg or hp_msg
  end
  if #msg_tokens > 0 then BRC.mpr.que(table.concat(msg_tokens)) end

  -- Add Damage-related warnings, when damage >= threshold
  if damage_taken >= mhp * C.dmg_flash_threshold then
    if is_very_low_hp then return end -- mute % HP alerts
    if damage_taken >= (mhp * C.dmg_fm_threshold) then
      local msg = BRC.txt.lightmagenta("MASSIVE DAMAGE")
      BRC.mpr.que_optmore(true, BRC.txt.wrap(msg, BRC.EMOJI.EXCLAMATION_2))
    else
      local msg = BRC.txt.magenta("BIG DAMAGE")
      BRC.mpr.que_optmore(false, BRC.txt.wrap(msg, BRC.EMOJI.EXCLAMATION))
    end
  end
end

}
############################### End lua/features/announce-hp-mp.lua ###############################
##########################################################################################

################################### Begin lua/features/announce-items.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: announce-items
-- @module f_announce_items
-- Announce when items of certain classes come into view. Off by default.
-- Intended and configured for turncount runs, to avoid having to manually check floor items.
---------------------------------------------------------------------------------------------------
f_announce_items = {}
f_announce_items.BRC_FEATURE_NAME = "announce-items"
f_announce_items.Config = {
  disabled = true, -- Disabled by default. Intended only for turncount runs.
  announced_classes = { "book", "gold", "jewellery", "misc", "potion", "scroll", "wand" }
} -- f_announce_items.Config (do not remove this comment)

---- Local variables ----
local los_items
local prev_item_names

---- Initialization ----
function f_announce_items.init()
  los_items = {}
  prev_item_names = {}
end

---- Local functions ----
local function announce_item(it)
  local class = it.class(true):lower()
  if util.contains(f_announce_items.Config.announced_classes, class) then
    crawl.mpr(BRC.txt.white("You see: ") .. it.name())
  end
end

---- Crawl hook functions ----
function f_announce_items.ready()
  los_items = {}
  local r = you.los()
  for x = -r, r do
    for y = -r, r do
      if you.see_cell(x, y) then
        local items_xy = items.get_items_at(x, y)
        if items_xy and #items_xy > 0 then
          for _, it in ipairs(items_xy) do
            los_items[#los_items+1] = it
          end
        end
      end
    end
  end

  for _, it in ipairs(los_items) do
    if not util.contains(prev_item_names, it.name()) then
      announce_item(it)
    end
  end

  -- Save names for comparison
  prev_item_names = {}
  for _, it in ipairs(los_items) do
    prev_item_names[#prev_item_names+1] = it.name()
  end
end

}
############################### End lua/features/announce-items.lua ###############################
##########################################################################################

################################### Begin lua/features/answer-prompts.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: answer-prompts
-- @module f_answer_prompts
-- Automatically answer crawl prompts.
---------------------------------------------------------------------------------------------------

f_answer_prompts = {}
f_answer_prompts.BRC_FEATURE_NAME = "answer-prompts"

---- Crawl hook functions ----
function f_answer_prompts.c_answer_prompt(prompt)
  if prompt == "Die?" then return false end
  if prompt:contains("Really fire") and prompt:contains("your spellforged") then return true end
  if prompt:contains("Really refrigerate") and prompt:contains("your spellforged") then return true end
  if prompt:contains("Permafrost Eruption might hit") and prompt:contains("servitor") then return true end
  if prompt:contains("Plasma Beam") and prompt:contains("might") then return true end
  if prompt:contains("Plasma Beam") and prompt:contains("your spellforged") then return true end
  if prompt:contains("Really") and prompt:contains("fire vort") then return true end
  if prompt:contains("Really") and prompt:contains("battle") then return true end
  if prompt:contains("Really hurl") and prompt:contains("your spellforged") then return true end
  if prompt:contains("Really attack your") and prompt:contains("rat") then return true end
  if prompt:contains("into that cloud of flame") and you.res_fire() == 3 then return true end
  if prompt:contains("into that cloud of freezing vapour") and you.res_cold() == 3 then return true end
  if prompt:contains("into a travel-excluded") then return true end
  if prompt:contains("icy armour will break") then return true end
  if prompt:contains("cheaper one?") and you.branch() ~= "Bazaar" then
    BRC.mpr.yellow("Replacing shopping list items")
    return true
  end
end

}
############################### End lua/features/answer-prompts.lua ###############################
##########################################################################################

################################### Begin lua/features/color-inscribe.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: color-inscribe
-- @module f_color_inscribe
-- Adds color to key terms in inscriptions (resistances, stats, etc).
---------------------------------------------------------------------------------------------------

f_color_inscribe = {}
f_color_inscribe.BRC_FEATURE_NAME = "color-inscribe"

---- Local constants ----
local LOSS_COLOR = BRC.COL.brown
local GAIN_COLOR = BRC.COL.white
local MULTI_PLUS = "%++"
local MULTI_MINUS = "%-+"
local NEG_NUM = "%-%d+%.?%d*"
local POS_NUM = "%+%d+%.?%d*"
local POS_WORN = ":%d+%.?%d*"
local COLORIZE_TAGS = {
  { "rF" .. MULTI_PLUS, BRC.COL.lightred },
  { "rF" .. MULTI_MINUS, LOSS_COLOR },
  { "rC" .. MULTI_PLUS, BRC.COL.lightblue },
  { "rC" .. MULTI_MINUS, LOSS_COLOR },
  { "rN" .. MULTI_PLUS, BRC.COL.lightmagenta },
  { "rN" .. MULTI_MINUS, LOSS_COLOR },
  { "rPois", BRC.COL.lightgreen },
  { "rElec", BRC.COL.lightcyan },
  { "rCorr", BRC.COL.yellow },
  { "rMut", BRC.COL.yellow },
  { "sInv", BRC.COL.magenta },
  { "MRegen" .. MULTI_PLUS, BRC.COL.cyan },
  { "^Regen" .. MULTI_PLUS, BRC.COL.green }, -- Avoiding "MRegen"
  { " Regen" .. MULTI_PLUS, BRC.COL.green }, -- Avoiding "MRegen"
  { "Stlth" .. MULTI_PLUS, GAIN_COLOR },
  { "%+Fly", GAIN_COLOR },
  { "RMsl", BRC.COL.yellow },
  { "Will" .. MULTI_PLUS, BRC.COL.blue },
  { "Will" .. MULTI_MINUS, LOSS_COLOR },
  { "Wiz" .. MULTI_PLUS, BRC.COL.cyan },
  { "Wiz" .. MULTI_MINUS, LOSS_COLOR },
  { "Slay" .. POS_NUM, GAIN_COLOR },
  { "Slay" .. NEG_NUM, LOSS_COLOR },
  { "Str" .. POS_NUM, GAIN_COLOR },
  { "Str" .. NEG_NUM, LOSS_COLOR },
  { "Dex" .. POS_NUM, GAIN_COLOR },
  { "Dex" .. NEG_NUM, LOSS_COLOR },
  { "Int" .. POS_NUM, GAIN_COLOR },
  { "Int" .. NEG_NUM, LOSS_COLOR },
  { "AC" .. POS_NUM, GAIN_COLOR },
  { "AC" .. POS_WORN, GAIN_COLOR },
  { "AC" .. NEG_NUM, LOSS_COLOR },
  { "EV" .. POS_NUM, GAIN_COLOR },
  { "EV" .. POS_WORN, GAIN_COLOR },
  { "EV" .. NEG_NUM, LOSS_COLOR },
  { "SH" .. POS_NUM, GAIN_COLOR },
  { "SH" .. POS_WORN, GAIN_COLOR },
  { "SH" .. NEG_NUM, LOSS_COLOR },
  { "HP" .. POS_NUM, GAIN_COLOR },
  { "HP" .. NEG_NUM, LOSS_COLOR },
  { "MP" .. POS_NUM, GAIN_COLOR },
  { "MP" .. NEG_NUM, LOSS_COLOR },
} -- COLORIZE_TAGS (do not remove this comment)

---- Local functions ----
local function colorize_subtext(text, subtext, tag)
  if not text:find(subtext) then return text end
  -- Remove current color tag if it exists
  text = text:gsub("<(%d%d?)>(" .. subtext .. ")</%1>", "%2")
  return text:gsub(subtext, string.format("<%s>%%1</%s>", tag, tag))
end

---- Public API ----
function f_color_inscribe.colorize(it)
  local text = it.inscription
  for _, tag in ipairs(COLORIZE_TAGS) do
    text = colorize_subtext(text, tag[1], tag[2])
  end

  -- Limit length for % menu: = total width, minus other text, minus length of item name
  it.inscribe("", false)
  local max_length = 80 - 3 - (it.is_melded and 32 or 25) - #it.name("plain", true)
  if max_length < 0 then return end
  -- Try removing brown, then white, then just remove all
  if #text > max_length then text = text:gsub("</?" .. BRC.COL.brown .. ">", "") end
  if #text > max_length then text = text:gsub("</?" .. BRC.COL.white .. ">", "") end
  if #text > max_length then text = text:gsub("<.->", "") end

  it.inscribe(text, false)
end

---- Crawl hook functions ----
function f_color_inscribe.c_assign_invletter(it)
  if it.artefact then return end
  -- If enabled, call inscribe stats before colorizing
  if
    f_inscribe_stats
    and f_inscribe_stats.Config
    and not f_inscribe_stats.Config.disabled
    and f_inscribe_stats.do_stat_inscription
    and (
      it.is_weapon and f_inscribe_stats.Config.inscribe_weapons
      or BRC.it.is_armour(it) and f_inscribe_stats.Config.inscribe_armour
    )
  then
    f_inscribe_stats.do_stat_inscription(it)
  end

  f_color_inscribe.colorize(it)
end

--[[
TODO: To colorize more, need a way to:
  intercept messages before they're displayed (or delete and re-insert)
  insert tags that affect menus
  colorize artefact text
function f_color_inscribe.c_message(text, _)
  local orig_text = text
  text = colorize_subtext(text)
  if text == orig_text then return end

  local cleaned = BRC.txt.clean(text)
  if cleaned:sub(2, 4) == " - " then
    text = " " .. text
  end

  crawl.mpr(text)
end
--]]

}
############################### End lua/features/color-inscribe.lua ###############################
##########################################################################################

################################### Begin lua/features/drop-inferior.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: drop-inferior
-- @module f_drop_inferior
-- When picking up an item, inscribes inferior items with "~~DROP_ME" and alerts you.
-- Items with "~~DROP_ME" are added to the drop list, and can be quickly selected with `,`
---------------------------------------------------------------------------------------------------

f_drop_inferior = {}
f_drop_inferior.BRC_FEATURE_NAME = "drop-inferior"
f_drop_inferior.Config = {
  msg_on_inscribe = true, -- Show a message when an item is marked for drop
  hotkey_drop = true, -- BRC hotkey drops all items on the drop list
} -- f_drop_inferior.Config (do not remove this comment)

---- Local constants ----
local DROP_KEY = "~~DROP_ME"

---- Initialization ----
function f_drop_inferior.init()
  crawl.setopt("drop_filter += " .. DROP_KEY)
end

---- Local functions ----
local function inscribe_drop(it)
  local new_inscr = it.inscription:gsub(DROP_KEY, "") .. DROP_KEY
  it.inscribe(new_inscr, false)
  if f_drop_inferior.Config.msg_on_inscribe then
    local item_name = BRC.txt.yellow(BRC.txt.int2char(it.slot) .. " - " .. it.name())
    BRC.mpr.cyan(BRC.txt.wrap("You can drop: " .. item_name, BRC.EMOJI.CAUTION))
  end
end

---- Crawl hook functions ----
function f_drop_inferior.c_assign_invletter(it)
  -- Remove any previous DROP_KEY inscriptions
  it.inscribe(it.inscription:gsub(DROP_KEY, ""), false)

  if
    not (it.is_weapon or BRC.it.is_armour(it))
    or BRC.eq.is_risky(it)
    or BRC.you.num_eq_slots(it) > 1
  then
    return
  end

  local it_ego = BRC.eq.get_ego(it)
  local marked_something = false
  for _, inv in ipairs(items.inventory()) do
    -- To be a clear upgrade: Not artefact, same subtype, and ego is same or a clear upgrade
    local inv_ego = BRC.eq.get_ego(inv)
    local not_worse = inv_ego == it_ego or not inv_ego or BRC.eq.is_risky(inv)
    if not_worse and not inv.artefact and inv.subtype() == it.subtype() then
      if it.is_weapon then
        if inv.plus <= (it.plus or 0) then
          inscribe_drop(inv)
          marked_something = true
        end
      else
        local not_more_ac = BRC.eq.get_ac(inv) <= BRC.eq.get_ac(it)
        if not_more_ac and inv.encumbrance >= it.encumbrance then
          inscribe_drop(inv)
          marked_something = true
        end
      end
    end
  end

  if marked_something and f_drop_inferior.Config.hotkey_drop and BRC.Hotkey then
    local condition = function()
      return util.exists(items.inventory(), function(i)
        return i.inscription:contains(DROP_KEY) end)
    end

    local do_drop = function()
      crawl.sendkeys(BRC.util.get_cmd_key("CMD_DROP") .. ",\r")
      crawl.flush_input()
    end

    BRC.Hotkey.set("drop", "your useless items", false, do_drop, condition)
  end
end

}
############################### End lua/features/drop-inferior.lua ###############################
##########################################################################################

################################### Begin lua/features/dynamic-options.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: dynamic-options
-- @module f_dynamic_options
-- Contains options that change based on game state: xl, class, race, god, skills.
---------------------------------------------------------------------------------------------------

f_dynamic_options = {}
f_dynamic_options.BRC_FEATURE_NAME = "dynamic-options"
f_dynamic_options.Config = {
  --- XL-based force more messages: patterns active when XL <= specified level
  xl_force_mores = {
    { pattern = "monster_warning:wielding.*of electrocution", xl = 5 },
    { pattern = "You.*re more poisoned", xl = 7 },
    { pattern = "^(?!.*Your?).*speeds? up", xl = 10 },
    { pattern = "danger:goes berserk", xl = 18 },
    { pattern = "monster_warning:carrying a wand of", xl = 15 },
  },

  --- Call each function for the corresponding race
  race_options = {
    Gnoll = function()
      BRC.opt.message_mute("intrinsic_gain:skill increases to level", true)
    end,
  },

  --- Call each function for the corresponding class
  class_options = {
    Hunter = function()
      crawl.setopt("view_delay = 30")
    end,
    Shapeshifter = function()
      BRC.opt.autopickup_exceptions("<flux bauble", true)
    end,
  },

  --- Call each function when joining/leaving a god
  god_options = {
    ["No God"] = function(joined)
      BRC.opt.force_more_message("Found.*the Ecumenical Temple", not joined)
      BRC.opt.flash_screen_message("Found.*the Ecumenical Temple", joined)
      BRC.opt.runrest_stop_message("Found.*the Ecumenical Temple", joined)
    end,
    Beogh = function(joined)
      BRC.opt.runrest_ignore_message("no longer looks.*", joined)
      BRC.opt.force_more_message("Your orc.*dies", joined)
    end,
    Cheibriados = function(joined)
      BRC.util.add_or_remove(BRC.RISKY_EGOS, "Ponderous", not joined)
    end,
    Jiyva = function(joined)
      BRC.opt.flash_screen_message("god:splits in two", joined)
      BRC.opt.message_mute("You hear a.*(slurping|squelching) noise", joined)
    end,
    Lugonu = function(joined)
      BRC.util.add_or_remove(BRC.RISKY_EGOS, "distort", not joined)
    end,
    Trog = function(joined)
      BRC.util.add_or_remove(BRC.ARTPROPS_BAD, "-Cast", not joined)
      BRC.util.add_or_remove(BRC.RISKY_EGOS, "antimagic", not joined)
    end,
    Xom = function(joined)
      BRC.opt.flash_screen_message("god:", joined)
    end,
  },
} -- f_dynamic_options.Config (do not remove this comment)

---- Local constants ----
local IGNORE_SPELLBOOKS_STRING = table.concat(BRC.SPELLBOOKS, ", ")
local HIGH_LVL_MAGIC_STRING = "scrolls? of amnesia, potions? of brilliance, ring of wizardry"

---- Local variables ----
local C -- config alias
local cur_god
local ignore_all_magic
local ignore_advanced_magic
local xl_force_mores_active

---- Initialization ----
function f_dynamic_options.init()
  C = f_dynamic_options.Config

  cur_god = "No God"
  ignore_advanced_magic = false
  ignore_all_magic = false
  xl_force_mores_active = {}

  -- Class options
  local handler = C.class_options[you.class()]
  if handler then handler() end

  -- Race options
  local race = you.race()
  handler = C.race_options[race]
  if handler then handler() end
  if util.contains(BRC.UNDEAD_RACES, race) then
    BRC.opt.force_more_message("monster_warning:wielding.*of holy wrath", true)
  end
  if not util.contains(BRC.POIS_RES_RACES, race) then
    BRC.opt.force_more_message("monster_warning:curare", true)
  end
end

---- Local functions ----
local function set_god_options()
  if cur_god == you.god() then return end
  local prev_god = cur_god
  cur_god = you.god()

  local abandoned = C.god_options[prev_god]
  if abandoned then abandoned(false) end

  local joined = C.god_options[cur_god]
  if joined then joined(true) end
end

local function set_xl_options()
  for i, v in ipairs(C.xl_force_mores) do
    local should_be_active = you.xl() <= v.xl
    if xl_force_mores_active[i] ~= should_be_active then
      xl_force_mores_active[i] = should_be_active
      BRC.opt.force_more_message(v.pattern, should_be_active)
    end
  end
end

local function set_skill_options()
  -- If zero spellcasting or no spells, don't stop on spellbook pickup, and allow -Cast / antimagic
  local no_spells = you.skill("Spellcasting") == 0 or #you.spells() == 0
  if ignore_all_magic ~= no_spells then
    ignore_all_magic = no_spells
    BRC.opt.explore_stop_pickup_ignore(IGNORE_SPELLBOOKS_STRING, no_spells)
    BRC.util.add_or_remove(BRC.ARTPROPS_BAD, "-Cast", not no_spells)
    BRC.util.add_or_remove(BRC.RISKY_EGOS, "antimagic", not no_spells)
  end

  -- If heavy armour and low armour skill, ignore spellcasting items
  if ignore_all_magic and you.race() ~= "Mountain Dwarf" then
    local worn = items.equipped_at("armour")
    local encumbered_magic = worn and worn.encumbrance > (4 + you.skill("Armour") / 2)
    if ignore_advanced_magic ~= encumbered_magic then
      ignore_advanced_magic = encumbered_magic
      BRC.opt.autopickup_exceptions(HIGH_LVL_MAGIC_STRING, encumbered_magic)
    end
  end
end

---- Crawl hook functions ----
function f_dynamic_options.ready()
  set_god_options()
  set_xl_options()
  set_skill_options()
end

}
############################### End lua/features/dynamic-options.lua ###############################
##########################################################################################

################################### Begin lua/features/exclude-dropped.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: exclude-dropped
-- @module f_exclude_dropped
-- Excludes dropped items from autopickup, pickup resumes autopickup.
-- @todo Can remove when crawl's drop_disables_autopickup setting reaches feature parity.
--    (Configurable/optional, dropping partial stack does not exclude, pickup resumes autopickup)
---------------------------------------------------------------------------------------------------

f_exclude_dropped = {}
f_exclude_dropped.BRC_FEATURE_NAME = "exclude-dropped"
f_exclude_dropped.Config = {
  not_weapon_scrolls = true, -- Don't exclude enchant/brand scrolls if holding an enchantable weapon
} -- f_exclude_dropped.Config (do not remove this comment)

---- Persistent variables ----
ed_dropped_items = BRC.Data.persist("ed_dropped_items", {})

---- Local functions ----
local function add_exclusion(item_name)
  if not util.contains(ed_dropped_items, item_name) then
    table.insert(ed_dropped_items, item_name)
  end
  BRC.opt.autopickup_exceptions(item_name, true)
end

local function remove_exclusion(item_name)
  util.remove(ed_dropped_items, item_name)
  BRC.opt.autopickup_exceptions(item_name, false)
end

local function enchantable_weap_in_inv()
  return util.exists(items.inventory(), function(i)
    return i.is_weapon
      and not BRC.it.is_magic_staff(i)
      and i.plus < 9
      and (not i.artefact or you.race() == "Mountain Dwarf")
  end)
end

local function clean_item_text(text)
  text = BRC.txt.clean(text)
  text = text:gsub("{.*}", "")
  text = text:gsub("[.]", "")
  text = text:gsub("%(.*%)", "")
  return util.trim(text)
end

local function extract_jewellery_or_evoker(text)
  local idx = text:find("ring of", 1, true)
    or text:find("amulet of", 1, true)
    or text:find("wand of", 1, true)
  if idx then return text:sub(idx, #text) end

  for _, item_name in ipairs(BRC.MISC_ITEMS) do
    if text:find(item_name) then return item_name end
  end
end

local function extract_missile(text)
  for _, item_name in ipairs(BRC.MISSILES) do
    if text:find(item_name) then return item_name end
  end
end

local function extract_potion(text)
  local idx = text:find("potions? of")
  if idx then return "potions? of " .. util.trim(text:sub(idx + 10, #text)) end
end

local function extract_scroll(text)
  local idx = text:find("scrolls? of")
  if idx then return "scrolls? of " .. util.trim(text:sub(idx + 10, #text)) end
end

--[[
  get_item_name() - Tries to extract item name from text.
  Returns name of item, or nil if not recognized as an excludable item.
--]]
local function get_item_name(text)
  text = clean_item_text(text)
  return extract_jewellery_or_evoker(text)
    or extract_missile(text)
    or extract_potion(text)
    or extract_scroll(text)
end

local function should_exclude(item_name, full_msg)
  -- Enchant/Brand weapon scrolls continue pickup if they're still useful
  if
    f_exclude_dropped.Config.not_weapon_scrolls
    and (item_name:contains("enchant weapon") or item_name:contains("brand weapon"))
    and enchantable_weap_in_inv()
  then
    return false
  end

  -- Don't exclude if we dropped partial stack (except for jewellery)
  for _, inv in ipairs(items.inventory()) do
    if inv.name("qual"):contains(item_name) then
      return BRC.it.is_jewellery(inv)
        or inv.quantity == 1
        or full_msg:contains("ou drop " .. item_name .. " " .. inv.quantity)
    end
  end

  return true
end

---- Initialization ----
function f_exclude_dropped.init()
  for _, v in ipairs(ed_dropped_items) do
    add_exclusion(v)
  end
end

---- Crawl hook functions ----
function f_exclude_dropped.c_message(text, channel)
  if channel ~= "plain" then return end

  local picked_up = BRC.txt.get_pickup_info(text)
  if not picked_up and not text:contains("ou drop ") then return end

  local item_name = get_item_name(text)
  if not item_name then return end

  if picked_up then
    remove_exclusion(item_name)
  elseif should_exclude(item_name, text) then
    add_exclusion(item_name)
  end
end

}
############################### End lua/features/exclude-dropped.lua ###############################
##########################################################################################

################################### Begin lua/features/fully-recover.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: fully-recover
-- @module f_fully_recover
-- Rests until no negative duration statuses. Doesn't stop rest on each status expiration.
-- @todo Can remove when crawl's explore_auto_rest_status setting reaches feature parity.
---------------------------------------------------------------------------------------------------

f_fully_recover = {}
f_fully_recover.BRC_FEATURE_NAME = "fully-recover"
f_fully_recover.Config = {
  rest_off_statuses = { -- Keep resting until these statuses are gone
    "berserk", "confused", "corroded", "diminished spells", "marked", "short of breath",
    "slowed", "sluggish", "tree%-form", "vulnerable", "weakened",
  },
} -- f_fully_recover.Config (do not remove this comment)

---- Local constants ----
local MAX_TURNS_TO_WAIT = 500

---- Local variables ----
local C -- config alias
local recovery_start_turn
local explore_after_recovery

---- Initialization ----
function f_fully_recover.init()
  C = f_fully_recover.Config
  recovery_start_turn = 0
  explore_after_recovery = false

  BRC.opt.macro(BRC.util.get_cmd_key("CMD_EXPLORE") or "o", "macro_brc_explore")
  BRC.opt.runrest_ignore_message("recovery:.*", true)
  BRC.opt.runrest_ignore_message("duration:.*", true)
  BRC.opt.message_mute("^HP restored", true)
  BRC.opt.message_mute("Magic restored", true)
end

---- Local functions ----
local function abort_fully_recover()
  recovery_start_turn = 0
  explore_after_recovery = false
  you.stop_activity()
end

local function finish_fully_recover()
  local turns = you.turns() - recovery_start_turn
  BRC.mpr.lightgreen(string.format("Fully recovered (%d turns)", turns))

  recovery_start_turn = 0
  you.stop_activity()

  if explore_after_recovery then
    explore_after_recovery = false
    BRC.util.do_cmd("CMD_EXPLORE")
  end
end

local function should_ignore_status(s)
  if s == "corroded" then
    return BRC.you.by_slimy_wall() or you.branch() == "Dis"
  elseif s == "slowed" then
    return BRC.you.zero_stat()
  end
  return false
end

local function fully_recovered()
  if you.contamination() > 0 then return false end
  local hp, mhp = you.hp()
  local mp, mmp = you.mp()
  if hp ~= mhp then return false end
  if mp ~= mmp then return false end

  local status = you.status()
  for _, s in ipairs(C.rest_off_statuses) do
    if status:find(s) and not should_ignore_status(s) then return false end
  end

  return true
end

local function remove_statuses_from_config()
  local status = you.status()
  local to_remove = {}
  for _, s in ipairs(C.rest_off_statuses) do
    if status:find(s) then table.insert(to_remove, s) end
  end
  for _, s in ipairs(to_remove) do
    util.remove(C.rest_off_statuses, s)
    BRC.mpr.error("  Removed: " .. s)
  end
end

local function start_fully_recover()
  recovery_start_turn = you.turns()
  BRC.opt.single_turn_mute("You start waiting.")
end

---- Macro function: Attach full recovery to auto-explore ----
function macro_brc_explore()
  if BRC.active == false or f_fully_recover.Config.disabled then
    return BRC.util.do_cmd("CMD_EXPLORE")
  end

  if fully_recovered() then
    if recovery_start_turn > 0 then
      finish_fully_recover()
    else
      BRC.util.do_cmd("CMD_EXPLORE")
    end
  else
    if you.feel_safe() then explore_after_recovery = true end
    BRC.util.do_cmd("CMD_REST")
  end
end

---- Crawl hook functions ----
function f_fully_recover.c_message(text, channel)
  if channel == "plain" then
    if text:contains("ou start waiting") or text:contains("ou start resting") then
      if not fully_recovered() then start_fully_recover() end
    end
  elseif recovery_start_turn > 0 then
    if channel == "timed_portal" then
      abort_fully_recover()
    elseif fully_recovered() then
      finish_fully_recover()
    end
  end
end

function f_fully_recover.ready()
  if recovery_start_turn > 0 then
    if fully_recovered() then
      finish_fully_recover()
    elseif not you.feel_safe() then
      abort_fully_recover()
    elseif you.turns() - recovery_start_turn > MAX_TURNS_TO_WAIT then
      BRC.mpr.error("fully-recover timed out after " .. MAX_TURNS_TO_WAIT .. " turns.", true)
      BRC.mpr.error("f_fully_recover.Config.rest_off_statuses:")
      remove_statuses_from_config()
      abort_fully_recover()
    else
      BRC.util.do_cmd("CMD_SAFE_WAIT")
    end
  else
    explore_after_recovery = false
  end
end

}
############################### End lua/features/fully-recover.lua ###############################
##########################################################################################

################################### Begin lua/features/go-up-macro.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: go-up-macro
-- @module f_go_up_macro
-- Handles orb run mechanics: HP-based monster ignore for cntl-E macro
---------------------------------------------------------------------------------------------------

f_go_up_macro = {}
f_go_up_macro.BRC_FEATURE_NAME = "go-up-macro"
f_go_up_macro.Config = {
  go_up_macro_key = BRC.util.cntl("e"), -- Key for "go up closest stairs" macro

  ignore_mon_on_orb_run = true, -- Ignore monsters on orb run
  -- %HP thresholds for ignoring monsters during orb run (2-7 tiles away, depending on HP percent)
  orb_ignore_hp_min = 0.30, -- HP percent to stop ignoring monsters
  orb_ignore_hp_max = 0.70, -- HP percent to ignore monsters at min distance away (2 tiles)
} -- f_go_up_macro.Config (do not remove this comment)

---- Local variables ----
local orb_ignore_distance

---- Local functions ----
local function set_orb_ignore_distance(distance)
  if orb_ignore_distance then
    BRC.opt.runrest_ignore_monster(".*:" .. orb_ignore_distance, false)
    orb_ignore_distance = nil
  end
  if distance then
    orb_ignore_distance = distance
    BRC.opt.runrest_ignore_monster(".*:" .. orb_ignore_distance, true)
  end
end

--- Get distance (2 - 7) to ignore monsters based on HP percent
local function get_ignore_distance_from_hp()
  local hp, mhp = you.hp()
  local hp_pct = hp / mhp
  local min_pct = f_go_up_macro.Config.orb_ignore_hp_min
  local max_pct = f_go_up_macro.Config.orb_ignore_hp_max

  if hp_pct <= min_pct then return nil end
  if hp_pct >= max_pct then return 2 end

  -- Linear interpolation between min_pct and max_pct
  local ratio = (hp_pct - min_pct) / (max_pct - min_pct)
  return math.floor(2 + ratio * (you.los() - 2))
end

---- Initialization ----
function f_go_up_macro.init()
  BRC.opt.macro(f_go_up_macro.Config.go_up_macro_key, "macro_brc_go_up")
end

---- Macro function ----
--- Go up the closest stairs (Cntl-E)
function macro_brc_go_up()
  if BRC.active == false or f_go_up_macro.Config.disabled then return end

  if you.have_orb() and f_go_up_macro.Config.ignore_mon_on_orb_run then
    local distance = get_ignore_distance_from_hp()
    if distance ~= orb_ignore_distance then set_orb_ignore_distance(distance) end
  end

  -- Go up closest stairs; different macro for D:1 and portals
  local where = you.where()
  if where == "D:1" and you.have_orb()
    or where == "Temple"
    or util.contains(BRC.PORTAL_FEATURE_NAMES, you.branch())
  then
    crawl.sendkeys({ "X", "<", "\r", BRC.KEYS.ESC, "<" }) -- {ESC, <} handles standing on stairs
  else
    crawl.sendkeys({ BRC.util.cntl("g"), "<" })
  end
  crawl.flush_input()
end


}
############################### End lua/features/go-up-macro.lua ###############################
##########################################################################################

################################### Begin lua/features/inscribe-stats.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: inscribe-stats
-- @module f_inscribe_stats
-- Inscribes and updates weapon DPS/dmg/delay, and armour AC/EV/SH, for items in inventory.
-- For Coglin weapons, evaluates as if swapping out the primary weapon (for artefact stat changes)
---------------------------------------------------------------------------------------------------

f_inscribe_stats = {}
f_inscribe_stats.BRC_FEATURE_NAME = "inscribe-stats"
f_inscribe_stats.Config = {
  inscribe_weapons = true, -- Inscribe weapon stats on pickup
  inscribe_armour = true, -- Inscribe armour stats on pickup
  dmg_type = BRC.DMG_TYPE.unbranded,
} -- f_inscribe_stats.Config (do not remove this comment)

---- Local constants ----
local NUM_PATTERN = "[%+%-:]%d+%.%d*" -- Matches numbers w/ decimal

---- Local functions ----
local function inscribe_armour_stats(it)
  local abbr = BRC.it.is_shield(it) and "SH" or "AC"
  local ac_or_sh, ev = BRC.eq.arm_stats(it)
  local sign_change = false

  local new_insc
  if it.inscription:find(abbr .. NUM_PATTERN) then
    new_insc = it.inscription:gsub(abbr .. NUM_PATTERN, ac_or_sh)
    if not it.inscription:contains(ac_or_sh:sub(1, 3)) then sign_change = true end

    if ev and ev ~= "" then
      new_insc = new_insc:gsub("EV" .. NUM_PATTERN, ev)
      if not it.inscription:contains(ev:sub(1, 3)) then sign_change = true end
    end
  else
    new_insc = ac_or_sh
    if ev and ev ~= "" then new_insc = string.format("%s, %s", new_insc, ev) end
    if it.inscription and it.inscription ~= "" then
      new_insc = string.format("%s; %s", new_insc, it.inscription)
    end
  end

  it.inscribe(new_insc, false)

  -- If f_color_inscribe is enabled, update the color
  if
    sign_change
    and f_color_inscribe
    and f_color_inscribe.Config
    and not f_color_inscribe.Config.disabled
    and f_color_inscribe.colorize
  then
    f_color_inscribe.colorize(it)
  end
end

local function inscribe_weapon_stats(it)
  local orig_inscr = it.inscription
  local dps_inscr = BRC.eq.wpn_stats(it, BRC.DMG_TYPE[f_inscribe_stats.Config.dmg_type])
  local prefix, suffix = "", ""

  local idx = orig_inscr:find("DPS:", 1, true)
  if idx then
    if idx > 1 then prefix = orig_inscr:sub(1, idx - 1) .. "; " end
    if idx + #dps_inscr - 1 < #orig_inscr then
      suffix = orig_inscr:sub(idx + #dps_inscr, #orig_inscr)
    end
  elseif #orig_inscr > 0 then
    suffix = "; " .. orig_inscr
  end

  it.inscribe(table.concat({ prefix, dps_inscr, suffix }), false)
end

---- Crawl hook functions ----
function f_inscribe_stats.do_stat_inscription(it)
  if f_inscribe_stats.Config.inscribe_weapons and it.is_weapon then
    inscribe_weapon_stats(it)
  elseif f_inscribe_stats.Config.inscribe_armour
    and BRC.it.is_armour(it)
    and not BRC.it.is_scarf(it)
  then
    inscribe_armour_stats(it)
  end
end

function f_inscribe_stats.ready()
  for _, inv in ipairs(items.inventory()) do
    f_inscribe_stats.do_stat_inscription(inv)
  end
end

}
############################### End lua/features/inscribe-stats.lua ###############################
##########################################################################################

################################### Begin lua/features/misc-alerts.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: misc-alerts
-- @module f_misc_alerts
-- @author gammafunk (save game w/ msg), buehler
-- Various single-purpose alerts: save game w/ msg, low HP, faith amulet, spell level changes.
---------------------------------------------------------------------------------------------------

f_misc_alerts = {}
f_misc_alerts.BRC_FEATURE_NAME = "misc-alerts"
f_misc_alerts.Config = {
  save_with_msg = true, -- Shift-S to save and leave yourself a message
  alert_low_hp_threshold = 0.35, -- % max HP to alert; 0 to disable
  alert_spell_level_changes = true, -- Alert when you gain additional spell levels
  alert_remove_faith = true, -- Reminder to remove amulet at max piety
  remove_faith_hotkey = true, -- Hotkey remove amulet
} -- f_misc_alerts.Config (do not remove this comment)

---- Persistent variables ----
ma_alerted_max_piety = BRC.Data.persist("ma_alerted_max_piety", false)
ma_saved_msg = BRC.Data.persist("ma_saved_msg", "")

---- Local constants ----
local REMOVE_FAITH_MSG = "6 star piety! Maybe ditch that amulet soon."

---- Local variables ----
local C -- config alias
local below_hp_threshold
local prev_spell_levels

---- Initialization ----
function f_misc_alerts.init()
  C = f_misc_alerts.Config
  below_hp_threshold = false
  prev_spell_levels = you.spell_levels()

  if C.save_with_msg then
    BRC.opt.macro(BRC.util.get_cmd_key("CMD_SAVE_GAME") or "S", "macro_brc_save")
    if ma_saved_msg and ma_saved_msg ~= "" then
      BRC.mpr.white("MESSAGE: " .. ma_saved_msg)
      ma_saved_msg = nil
    end
  end
end

---- Local functions ----
local function alert_low_hp()
  local hp, mhp = you.hp()
  if below_hp_threshold then
    below_hp_threshold = hp ~= mhp
  elseif hp <= C.alert_low_hp_threshold * mhp then
    below_hp_threshold = true
    local low_hp_msg = "Dropped below " .. 100 * C.alert_low_hp_threshold .. "%% HP"
    BRC.mpr.que_optmore(true, BRC.txt.wrap(BRC.txt.magenta(low_hp_msg), BRC.EMOJI.EXCLAMATION))
  end
end

local function alert_remove_faith()
  if not ma_alerted_max_piety and you.piety_rank() == 6 then
    local am = items.equipped_at("amulet")
    if am and am.subtype() == "amulet of faith" and not am.artefact then
      if you.god() == "Uskayaw" then return end
      BRC.mpr.more(REMOVE_FAITH_MSG, BRC.COL.lightcyan)
      ma_alerted_max_piety = true
      if C.remove_faith_hotkey and BRC.Hotkey then
        BRC.Hotkey.set("remove", "amulet of faith", false, function()
          items.equipped_at("amulet"):remove()
        end)
      end
    end
  end
end

local function alert_spell_level_changes()
  local new_spell_levels = you.spell_levels()
  if new_spell_levels > prev_spell_levels then
    local delta = new_spell_levels - prev_spell_levels
    local msg = string.format("Gained %s spell level%s", delta, delta > 1 and "s" or "")
    local suffix = string.format(" (%s available)", new_spell_levels)
    BRC.mpr.lightcyan(msg .. BRC.txt.cyan(suffix))
  elseif new_spell_levels < prev_spell_levels then
    BRC.mpr.magenta(new_spell_levels .. " spell levels remaining")
  end

  prev_spell_levels = new_spell_levels
end

---- Macro function: Save with message feature ----
function macro_brc_save()
  if BRC.active == false
    or f_misc_alerts.Config.disabled
    or not f_misc_alerts.Config.save_with_msg
  then
    return BRC.util.do_cmd("CMD_SAVE_GAME")
  end

  if not BRC.mpr.yesno("Save game and exit?", BRC.COL.lightcyan) then
    BRC.mpr.okay()
    return
  end

  BRC.mpr.white("Leave a message: ", "prompt")
  ma_saved_msg = crawl.c_input_line()
  BRC.util.do_cmd("CMD_SAVE_GAME_NOW")
end

---- Crawl hook functions ----
function f_misc_alerts.ready()
  if C.alert_remove_faith then alert_remove_faith() end
  if C.alert_low_hp_threshold > 0 then alert_low_hp() end
  if C.alert_spell_level_changes then alert_spell_level_changes() end
end

}
############################### End lua/features/misc-alerts.lua ###############################
##########################################################################################

################################### Begin lua/features/mute-messages.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: mute-messages
-- @module f_mute_messages
-- Mutes various crawl messages, with configurable levels of reduction.

f_mute_messages = {}
f_mute_messages.BRC_FEATURE_NAME = "mute-messages"
f_mute_messages.Config = {
  mute_level = 2,
  messages = {
    -- Light reduction; unnecessary messages
    [1] = {
      -- Unnecessary
      "You now have .* runes",
      "to see all the runes you have collected",
      "A chill wind blows around you",
      "An electric hum fills the air",
      "You reach to attack",

      -- Interface
      "for a list of commands and other information",
      "Marking area around",
      "(Reduced|Removed|Placed new) exclusion",
      "You can access your shopping list by pressing '\\$'",

      -- Wielding weapons
      "Your .* exudes an aura of protection",
      "Your .* glows with a cold blue light",

      -- Monsters /Allies / Neutrals
      "dissolves into shadows",
      "You swap places",
      "Your spectral weapon disappears",

      -- Spells
      "Your foxfire dissipates",

      -- Religion
      "accepts your kill",
      "is honoured by your kill",
    },

    -- Moderate reduction; potentially confusing but no info lost
    [2] = {
      -- Allies / monsters
      "Ancestor HP restored",
      "The (bush|fungus|plant) (looks sick|begins to die|is engulfed|is struck)",
      "evades? a web",
      "is (lightly|moderately|heavily|severely) (damaged|wounded)",
      "is almost (dead|destroyed)",

      -- Interface
      "Use which ability\\?",
      "Evoke which item\\?$",
      "Shift\\-Dir \\- straight line",

      -- Books
      "You pick up (?!a manual).*and begin reading",
      "Unfortunately\\, you learn nothing new",

      -- Ground items / features
      "There is a.*(door|gate|staircase|web).*here",
      "You see here .*(corpse|skeleton)",
      "You now have \\d+ gold piece",
      "You enter the shallow water",
      "Moving in this stuff is going to be slow",

      -- Religion
      "Your shadow attacks",
    },

    -- Heavily reduced messages for speed runs
    [3] = {
      "No target in view",
      "You (bite|headbutt|kick)",
      "You (burn|freeze|drain)",
      "You block",
      "but do(es)? no damage",
      "misses you",
    },
  },
} -- f_mute_messages.Config (do not remove this comment)

---- Initialization ----
function f_mute_messages.init()
  if f_mute_messages.Config.mute_level and f_mute_messages.Config.mute_level > 0 then
    for i = 1, f_mute_messages.Config.mute_level do
      if not f_mute_messages.Config.messages[i] then break end
      for _, message in ipairs(f_mute_messages.Config.messages[i]) do
        BRC.opt.message_mute(message, true)
      end
    end
  end
end

}
############################### End lua/features/mute-messages.lua ###############################
##########################################################################################

################################### Begin lua/features/quiver-reminders.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: quiver-reminders
-- @module f_quiver_reminders
-- A handful of useful quiver-related reminders. (AKA things I often forget.)
---------------------------------------------------------------------------------------------------

f_quiver_reminders = {}
f_quiver_reminders.BRC_FEATURE_NAME = "quiver-reminders"
f_quiver_reminders.Config = {
  confirm_consumables = true,
  warn_diff_missile_turns = 10,
} -- f_quiver_reminders.Config (do not remove this comment)

---- Local variables ----
local C -- config alias
local last_thrown
local last_thrown_turn

---- Initialization ----
function f_quiver_reminders.init()
  C = f_quiver_reminders.Config
  last_thrown = nil
  last_thrown_turn = -1

  BRC.opt.macro(BRC.util.get_cmd_key("CMD_FIRE") or "f", "macro_brc_fire")
end

---- Local functions ----
local function quiver_missile_by_name(name)
  local slot = nil
  for _, inv in ipairs(items.inventory()) do
    if inv.name("qual") == name then
      slot = inv.slot
      break
    end
  end

  if not slot then return end
  crawl.sendkeys(BRC.util.get_cmd_key("CMD_QUIVER_ITEM") .. "*(" .. BRC.txt.int2char(slot))
  crawl.flush_input()
end

---- Macro function: Fire from quiver ----
function macro_brc_fire()
  if BRC.active == false or f_quiver_reminders.Config.disabled then
    return BRC.util.do_cmd("CMD_FIRE")
  end

  local quivered = items.fired_item()
  if not quivered then return end

  if C.confirm_consumables then
    local cls = quivered.class(true)
    if cls == "potion" or cls == "scroll" then
      local action = cls == "potion" and "drink" or "read"
      local q = BRC.txt.lightgreen(quivered.name())
      local msg = string.format("Really %s %s from quiver?", action, q)
      if not BRC.mpr.yesno(msg) then return BRC.mpr.okay() end
    end
  end

  if you.turns() - last_thrown_turn <= C.warn_diff_missile_turns then
    if last_thrown ~= quivered.name("qual") then
      local q = BRC.txt.lightgreen(quivered.name("qual"))
      if not BRC.mpr.yesno("Did you mean to throw " .. q .. "?") then
        local t = BRC.txt.lightgreen(last_thrown)
        if BRC.mpr.yesno("Quiver and throw " .. t .. " instead?") then
          quiver_missile_by_name(last_thrown)
        else
          return BRC.mpr.okay()
        end
      end
    end
  end

  BRC.util.do_cmd("CMD_FIRE")
end

---- Crawl hook functions ----
function f_quiver_reminders.c_message(text, _)
  local cleaned = BRC.txt.clean(text)
  local prefix = "You throw a "
  if cleaned:sub(1, #prefix) == prefix then
    last_thrown = cleaned:sub(#prefix + 1, #cleaned - 1):gsub(" {.*}", "")
    last_thrown_turn = you.turns()
  end
end

}
############################### End lua/features/quiver-reminders.lua ###############################
##########################################################################################

################################### Begin lua/features/remind-id.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: remind-id
-- @module f_remind_id
-- Alerts a reminder to read scroll of ID, when carrying unidentified items.
-- Before finding scroll of ID, stops explore when largest stack of un-ID'd scrolls/pots increases.
---------------------------------------------------------------------------------------------------

f_remind_id = {}
f_remind_id.BRC_FEATURE_NAME = "remind-id"
f_remind_id.Config = {
  stop_on_scrolls_count = 2, -- Stop when largest un-ID'd scroll stack increases and is >= this
  stop_on_pots_count = 3, -- Stop when largest un-ID'd potion stack increases and is >= this
  emoji = BRC.Config.emojis and "🎁" or BRC.txt.magenta("?"),
  read_id_hotkey = true, -- Put read ID on hotkey
} -- f_remind_id.Config (do not remove this comment)

---- Persistent variables ----
ri_found_scroll_of_id = BRC.Data.persist("ri_found_scroll_of_id", false)

---- Local variables ----
local C -- config alias
local do_remind_id_check

---- Initialization ----
function f_remind_id.init()
  C = f_remind_id.Config
  do_remind_id_check = true
end

---- Local functions ----
local function get_max_stack(class)
  local max_stack_size = 0
  local slot = nil
  for _, inv in ipairs(items.inventory()) do
    if inv.class(true) == class and not inv.is_identified then
      if inv.quantity > max_stack_size then
        max_stack_size = inv.quantity
        slot = inv.slot
      elseif inv.quantity == max_stack_size then
        slot = nil -- If tied for max, no slot set a new max
      end
    end
  end
  return max_stack_size, slot
end

local function have_scroll_of_id()
  return util.exists(items.inventory(), function(i)
    return i.name("qual") == "scroll of identify"
  end)
end

local function have_unid_item()
  return util.exists(items.inventory(), function(i)
    return not i.is_identified
  end)
end

---- Crawl hook functions ----
function f_remind_id.c_assign_invletter(it)
  if
    not it.is_identified and have_scroll_of_id()
    or it.name("qual") == "scroll of identify" and have_unid_item()
  then
    you.stop_activity()
    do_remind_id_check = true
  end
end

function f_remind_id.c_message(text, channel)
  if channel ~= "plain" then return end

  if text:find("scrolls? of identify") then
    ri_found_scroll_of_id = true
    -- Don't re-trigger on dropping or on hotkey notification
    text = BRC.txt.clean(text)
    if not text:contains("ou drop ") and not text:contains("to read ") and have_unid_item() then
      you.stop_activity()
      do_remind_id_check = true
    end
  else
    local name, slot = BRC.txt.get_pickup_info(text)
    if not name then return end

    local is_scroll = name:contains("scroll")
    local is_potion = name:contains("potion")
    if not (is_scroll or is_potion) then return end

    if ri_found_scroll_of_id then
      -- Check for pickup unidentified consumable
      if not name:contains(" of ") then
        do_remind_id_check = true
        if have_scroll_of_id() then you.stop_activity() end
      end
    else
      -- Check if max stack size increased
      local num_scrolls, slot_scrolls = get_max_stack("scroll")
      local num_pots, slot_pots = get_max_stack("potion")
      if
        is_scroll and slot_scrolls == slot and num_scrolls >= C.stop_on_scrolls_count
        or is_potion and slot_pots == slot and num_pots >= C.stop_on_pots_count
      then
        you.stop_activity()
      end
    end
  end
end

function f_remind_id.ready()
  if do_remind_id_check then
    do_remind_id_check = false
    if have_unid_item() and have_scroll_of_id() then
      local msg = BRC.txt.wrap(BRC.txt.magenta("You have something to identify."), C.emoji)
      BRC.mpr.stop(msg)
      if C.read_id_hotkey and BRC.Hotkey then
        BRC.Hotkey.set("read", "scroll of identify", false, function()
          for _, inv in ipairs(items.inventory()) do
            if inv.name("qual") == "scroll of identify" then
              BRC.util.do_cmd("CMD_READ")
              crawl.sendkeys(BRC.txt.int2char(inv.slot))
              crawl.flush_input()
              return
            end
          end
        end)
      end
    end
  end
end

}
############################### End lua/features/remind-id.lua ###############################
##########################################################################################

################################### Begin lua/features/pickup-alert/pa-config.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: pickup-alert-config
-- @submodule f_pickup_alert.Config
-- Configuration and in-depth tuning heuristics for the pickup-alert feature.
---------------------------------------------------------------------------------------------------

f_pickup_alert = f_pickup_alert or {}
f_pickup_alert.Config = {}
f_pickup_alert.Config.Pickup = {
  armour = true,
  weapons = true,
  weapons_pure_upgrades_only = true, -- Only pick up better versions of same exact weapon
  staves = true,
} -- f_pickup_alert.Config.Pickup (do not remove this comment)

f_pickup_alert.Config.Alert = {
  armour_sensitivity = 1.0, -- Adjust all armour alerts; 0 to disable all (typical range 0.5-2.0)
  weapon_sensitivity = 1.0, -- Adjust all weapon alerts; 0 to disable all (typical range 0.5-2.0)
  orbs = true,
  staff_resists = true,
  talismans = true,
  first_ranged = true,
  first_polearm = true,
  autopickup_disabled = true, -- If autopickup is off, alert for items that would be autopicked up

  -- Each usable item is alerted once.
  one_time = {
    "buckler", "kite shield", "tower shield", "crystal plate armour",
    "gold dragon scales", "pearl dragon scales", "storm dragon scales", "shadow dragon scales",
    "quick blade", "demon blade", "eudemon blade", "double sword", "triple sword",
    "broad axe", "executioner's axe",
    "demon whip", "eveningstar", "giant spiked club", "morningstar", "sacred scourge",
    "lajatang", "bardiche", "demon trident", "partisan", "trishula",
    "hand cannon", "triple crossbow",
  },
  -- Only do one-time alerts if your skill >= this value, in weap_school/armour/shield
  OTA_require_skill = { weapon = 2, armour = 2.5, shield = 0 },

  hotkey_travel = true,
  hotkey_pickup = true,

  allow_arte_weap_upgrades = true, -- If false, won't alert weapons as upgrades to an artefact

  -- Only alert a plain talisman if its min_skill <= Shapeshifting + talisman_lvl_diff
  talisman_lvl_diff = you.class() == "Shapeshifter" and 27 or 6,

  -- Which alerts generate a force_more
  More = {
    early_weap = false, -- Good weapons found early
    upgrade_weap = false, -- Better DPS / weapon_score
    weap_ego = false, -- New or diff egos
    body_armour = false,
    shields = true,
    aux_armour = false,
    armour_ego = true, -- New or diff egos
    high_score_weap = false, -- Highest damage found
    high_score_armour = true, -- Highest AC found
    one_time_alerts = true,
    artefact = false, -- Any artefact
    trained_artefacts = true, -- Artefacts where you have corresponding skill > 0
    orbs = false, -- Unique orbs
    talismans = you.class() == "Shapeshifter", -- True for shapeshifter, false for everyone else
    staff_resists = false, -- When a staff gives a missing resistance
    autopickup_disabled = true, -- Alerts for autopickup items, when autopickup is disabled
  },
} -- f_pickup_alert.Config.Alert (do not remove this comment)

---- Heuristics for tuning the pickup/alert system. Advanced behavior customization.
f_pickup_alert.Config.Tuning = {}

--[[
  f_pickup_alert.Config.Tuning.Armour: Magic numbers for the armour pickup/alert system.
  For armour with different encumbrance, alert when ratio of gain/loss (AC|EV) is > value
  Lower values mean more alerts. gain/diff/same/lose refers to egos.
  min_gain/max_loss block alerts for new egos, when AC or EV delta is outside limits
  ignore_small: if abs(AC+EV) <= this, ignore ratios and alert any gain/diff ego
--]]
f_pickup_alert.Config.Tuning.Armour = {
  Lighter = {
    gain_ego = 0.6,
    new_ego = 0.7,
    diff_ego = 0.9,
    same_ego = 1.2,
    lost_ego = 2.0,
    min_gain = 3.0,
    max_loss = 4.0,
    ignore_small = 3.5,
  },

  Heavier = {
    gain_ego = 0.4,
    new_ego = 0.5,
    diff_ego = 0.6,
    same_ego = 0.7,
    lost_ego = 2.0,
    min_gain = 3.0,
    max_loss = 8.0,
    ignore_small = 5,
  },

  encumb_penalty_weight = 0.7, -- [0-2.0] Penalty to heavy armour when training magic/ranged
  early_xl = 6, -- Alert all usable runed body armour if XL <= early_xl
  diff_body_ego_is_good = false, -- More alerts for diff_ego in body armour (skips min_gain check)
} -- f_pickup_alert.Config.Tuning.Armour (do not remove this comment)

--[[
  f_pickup_alert.Config.Tuning.Weap: Magic numbers for the weapon pickup/alert system, namely:
    1. Cutoffs for pickup/alert weapons (when DPS ratio exceeds a value)
    2. Cutoffs for when alerts are active (XL, skill_level)
  Pickup/alert system will try to upgrade ANY weapon in your inventory.
  "DPS ratio" is (new_weapon_score / inventory_weapon_score). Score considers DPS/brand/accuracy.
--]]
f_pickup_alert.Config.Tuning.Weap = {}
f_pickup_alert.Config.Tuning.Weap.Pickup = {
  add_ego = 1.0, -- Pickup weapon that gains a brand if DPS ratio > add_ego
  same_type_melee = 1.2, -- Pickup melee weap of same school if DPS ratio > same_type_melee
  same_type_ranged = 1.1, -- Pickup ranged weap if DPS ratio > same_type_ranged
  accuracy_weight = 0.25, -- Treat +1 Accuracy as +accuracy_weight DPS
} -- f_pickup_alert.Config.Tuning.Weap.Pickup (do not remove this comment)

f_pickup_alert.Config.Tuning.Weap.Alert = {
  -- Alerts for weapons not requiring an extra hand
  pure_dps = 1.0, -- Alert if DPS ratio > pure_dps
  gain_ego = 0.8, -- Gaining ego; Alert if DPS ratio > gain_ego
  new_ego = 0.8, -- Get ego not in inventory; Alert if DPS ratio > new_ego
  low_skill_penalty_damping = 8, -- [0-20] Reduces penalty to weapons of lower-trained schools

  -- Alerts for 2-handed weapons, when carrying 1-handed
  AddHand = {
    ignore_sh_lvl = 4.0, -- Treat offhand as empty if shield_skill < ignore_sh_lvl
    add_ego_lose_sh = 0.8, -- Alert 1h -> 2h (using shield) if DPS ratio > add_ego_lose_sh
    not_using = 1.0, --  Alert 1h -> 2h (not using 2nd hand) if DPS ratio > not_using
  },

  -- Alerts for good early weapons of all types
  Early = {
    xl = 7, -- Alert early weapons if XL <= xl
    skill = { factor = 1.5, offset = 2.0 }, -- Ignore weapons with skill_diff > XL*factor+offset
    branded_min_plus = 4, -- Alert branded weapons with plus >= branded_min_plus
  },

  -- Alerts for particularly strong ranged weapons
  EarlyRanged = {
    xl = 14, -- Alert strong ranged weapons if XL <= xl
    min_plus = 7, -- Alert ranged weapons with plus >= min_plus
    branded_min_plus = 4, -- Alert branded ranged weapons with plus >= branded_min_plus
    max_shields = 8.0, -- Alert 2h ranged, despite a wearing shield, if shield_skill <= max_shields
  },
} -- f_pickup_alert.Config.Tuning.Weap.Alert (do not remove this comment)

f_pickup_alert.Config.AlertColor = {
  weapon = { desc = BRC.COL.magenta, item = BRC.COL.yellow, stats = BRC.COL.lightgrey },
  body_arm = { desc = BRC.COL.lightblue, item = BRC.COL.lightcyan, stats = BRC.COL.lightgrey },
  aux_arm = { desc = BRC.COL.lightblue, item = BRC.COL.yellow },
  orb = { desc = BRC.COL.green, item = BRC.COL.lightgreen },
  talisman = { desc = BRC.COL.green, item = BRC.COL.lightgreen },
  misc = { desc = BRC.COL.brown, item = BRC.COL.white },
} -- f_pickup_alert.Config.AlertColor (do not remove this comment)

f_pickup_alert.Config.Emoji = not BRC.Config.emojis and {} or {
  RARE_ITEM = "💎",
  ARTEFACT = "💠",
  ORB = "🔮",
  TALISMAN = "🧬",
  STAFF_RES = "🔥",

  WEAPON = "⚔️",
  RANGED = "🏹",
  POLEARM = "🔱",
  TWO_HAND = "✋🤚",

  EGO = "✨",
  ACCURACY = "🎯",
  STRONGER = "💪",
  STRONGEST = "💪💪",
  LIGHTER = "⏬",
  HEAVIER = "⏫",

  AUTOPICKUP = "👍",
} -- f_pickup_alert.Config.Emoji (do not remove this comment)

}
############################### End lua/features/pickup-alert/pa-config.lua ###############################
##########################################################################################

################################### Begin lua/features/pickup-alert/pa-main.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: pickup-alert
-- @module f_pickup_alert
-- Comprehensive pickup and alert system for weapons, armour, and miscellaneous items.
-- Several submodules: pa-config, pa-data, pa-armour, pa-weapons, pa-misc.
---------------------------------------------------------------------------------------------------

f_pickup_alert = f_pickup_alert or {}
f_pickup_alert.BRC_FEATURE_NAME = "pickup-alert"

---- Local variables ----
local C -- config alias
local A -- alert config alias
local M -- more config alias
local pause_pa_system
local hold_alerts_for_next_turn
local function_queue -- queue of actions for next ready()

---- Initialization ----
function f_pickup_alert.init()
  C = f_pickup_alert.Config
  A = f_pickup_alert.Config.Alert
  M = f_pickup_alert.Config.Alert.More
  pause_pa_system = false
  hold_alerts_for_next_turn = false
  function_queue = {}

  BRC.mpr.debug("Initialize pickup-alert submodules...")
  if f_pa_data.init then f_pa_data.init() end
  BRC.mpr.debug("  pa-data loaded")

  if f_pa_armour then
    if f_pa_armour.init then f_pa_armour.init() end
    BRC.mpr.debug("  pa-armour loaded")
  end

  if f_pa_weapons then
    if f_pa_weapons.init then f_pa_weapons.init() end
    BRC.mpr.debug("  pa-weapons loaded")
  end

  if f_pa_misc then
    if f_pa_misc.init then f_pa_misc.init() end
    BRC.mpr.debug("  pa-misc loaded")
  end

  -- Don't alert for starting items
  for _, inv in ipairs(items.inventory()) do
    f_pa_data.remember_alert(inv)
    f_pa_data.remove_OTA(inv)
  end
end

---- Local functions ----
local function do_autopickup(it)
  if options.autopick_on == false
    and A.autopickup_disabled
    and not f_pa_data.already_alerted(it)
  then
    f_pickup_alert.do_alert(it, "Autopickup item", C.Emoji.AUTOPICKUP, M.autopickup_disabled)
  end

  return true
end

local function has_configured_force_more(it)
  if it.artefact then
    if M.artefact then return true end
    if M.trained_artefacts then
      -- Accept artefacts with any relevant training, or no training required
      local s = BRC.you.skill_with(it)
      if s == nil or s > 0 then return true end
    end
  end

  return M.armour_ego and BRC.it.is_armour(it) and BRC.eq.get_ego(it)
end

local function track_unique_egos(it)
  local ego = BRC.eq.get_ego(it)
  if
    ego
    and not util.contains(pa_egos_alerted, ego)
    and not (it.artefact and BRC.eq.is_risky(it))
  then
    pa_egos_alerted[#pa_egos_alerted+1] = ego
  end
end

local function get_alert_color_for_item(it)
  if it.is_weapon then return C.AlertColor.weapon end
  if BRC.it.is_orb(it) then return C.AlertColor.orb end
  if BRC.it.is_talisman(it) then return C.AlertColor.talisman end
  if BRC.it.is_body_armour(it) then return C.AlertColor.body_arm end
  if BRC.it.is_armour(it) then return C.AlertColor.aux_arm end
  return C.AlertColor.misc
end

local function should_skip_pickup_check(it)
  return BRC.active == false
    or pause_pa_system
    or you.have_orb()
    or (not it.is_identified and (it.branded or it.artefact or BRC.it.is_magic_staff(it)))
end

local function check_and_trigger_alerts(it, unworn_aux_item)
  if f_pa_data.already_alerted(it) then return true end

  -- One-time alerts
  if f_pa_misc and A.one_time and #A.one_time > 0 then
    if f_pa_misc.alert_OTA(it) then return true end
  end

  -- Item-specific alerts
  if BRC.it.is_magic_staff(it) and f_pa_misc and A.staff_resists then
    if f_pa_misc.alert_staff(it) then return true end
  elseif BRC.it.is_orb(it) and f_pa_misc and A.orbs then
    if f_pa_misc.alert_orb(it) then return true end
  elseif BRC.it.is_talisman(it) and f_pa_misc and A.talismans then
    if f_pa_misc.alert_talisman(it) then return true end
  elseif BRC.it.is_armour(it) and f_pa_armour and A.armour_sensitivity > 0 then
    if f_pa_armour.alert_armour(it, unworn_aux_item) then return true end
  elseif it.is_weapon and f_pa_weapons and A.weapon_sensitivity > 0 then
    if f_pa_weapons.alert_weapon(it) then return true end
  end

  return false
end

---- Public API ----
function f_pickup_alert.pause_alerts()
  hold_alerts_for_next_turn = true
end

function f_pickup_alert.do_alert(it, alert_type, emoji, force_more)
  local item_name = f_pa_data.get_keyname(it, true)
  local alert_col = get_alert_color_for_item(it)

  -- Handle special formatting for weapons and body armour
  if it.is_weapon then
    f_pa_data.update_high_scores(it)
    local weapon_info = string.format(" (%s)", BRC.eq.wpn_stats(it))
    item_name = item_name .. BRC.txt[C.AlertColor.weapon.stats](weapon_info)
  elseif BRC.it.is_armour(it) then
    track_unique_egos(it)
    if BRC.it.is_body_armour(it) then
      f_pa_data.update_high_scores(it)
      local ac, ev = BRC.eq.arm_stats(it)
      local armour_info = string.format(" {%s, %s}", ac, ev)
      item_name = item_name .. BRC.txt[C.AlertColor.body_arm.stats](armour_info)
    end
  end

  local tokens = {}
  tokens[1] = emoji and emoji or BRC.txt.cyan("----")
  tokens[#tokens + 1] = BRC.txt[alert_col.desc](string.format(" %s:", alert_type))
  tokens[#tokens + 1] = BRC.txt[alert_col.item](string.format(" %s ", item_name))
  tokens[#tokens + 1] = tokens[1]
  BRC.mpr.que_optmore(force_more or has_configured_force_more(it), table.concat(tokens))

  f_pa_data.add_recent_alert(it)
  f_pa_data.remember_alert(it)

  if not hold_alerts_for_next_turn then you.stop_activity() end

  local it_name = it.name()
  function_queue[#function_queue + 1] = function()
    -- Set hotkeys (have to do next turn, so player position is updated for setting waypoint)
    if util.exists(you.floor_items(), function(fl) return fl.name() == it_name end) then
      if A.hotkey_pickup and BRC.Hotkey then BRC.Hotkey.pickup(it_name, true) end
    else
      if A.hotkey_travel and BRC.Hotkey then BRC.Hotkey.waypoint(it_name) end
    end
  end

  return true
end

---- Crawl hook functions ----
function f_pickup_alert.autopickup(it, _)
  if should_skip_pickup_check(it) then return end

  local unworn_aux_item = nil -- Track carried aux armour for mutation scenarios
  if it.is_useless then
    -- Allow alerts for useless aux armour, iff you're carrying one (implies a temporary mutation)
    if not BRC.it.is_aux_armour(it) then return end
    local st = it.subtype()
    for _, inv in ipairs(items.inventory()) do
      if inv.subtype() == st then
        unworn_aux_item = inv
        break
      end
    end
    if not unworn_aux_item then return end
  else
    if BRC.it.is_armour(it) then
      if C.Pickup.armour and f_pa_armour.pickup_armour(it) then return do_autopickup(it) end
    elseif BRC.it.is_magic_staff(it) then
      if C.Pickup.staves and f_pa_misc.pickup_staff(it) then return do_autopickup(it) end
    elseif it.is_weapon then
      if C.Pickup.weapons and f_pa_weapons.pickup_weapon(it) then return do_autopickup(it) end
    elseif f_pa_misc and f_pa_misc.is_unneeded_ring(it) then
      return false
    end
  end

  -- Item not picked up - check if it should trigger alerts
  if check_and_trigger_alerts(it, unworn_aux_item) then return end
end

function f_pickup_alert.c_assign_invletter(it)
  f_pa_misc.alert_OTA(it)
  f_pa_data.remove_recent_alert(it)
  f_pa_data.remember_alert(it)

  -- Re-enable the alert, iff we are able to use another one
  if BRC.you.num_eq_slots(it) > 1 then f_pa_data.forget_alert(it) end

  -- Ensure we always stop for these autopickup types
  if it.is_weapon or BRC.it.is_armour(it) then
    f_pa_data.update_high_scores(it)
    you.stop_activity()
  end
end

function f_pickup_alert.c_message(text, channel)
  -- Avoid firing alerts when changing armour/weapons
  if channel == "multiturn" then
    if not pause_pa_system and text:contains("ou start ") then pause_pa_system = true end
  elseif channel == "plain" then
    if pause_pa_system and (text:contains("ou stop ") or text:contains("ou finish ")) then
      pause_pa_system = false
    elseif text:contains("one exploring") or text:contains("artly explored") then
      local tokens = { "Recent alerts:" }
      for _, v in ipairs(pa_recent_alerts) do
        tokens[#tokens + 1] = string.format("\n  %s", v)
      end
      if #tokens > 1 then BRC.mpr.que(table.concat(tokens), BRC.COL.magenta) end
      pa_recent_alerts = {}
    end
  end
end

function f_pickup_alert.ready()
  hold_alerts_for_next_turn = false
  util.foreach(function_queue, function(f) f() end)
  function_queue = {}

  if pause_pa_system then return end
  f_pa_weapons.ready()
  f_pa_data.update_high_scores(items.equipped_at("armour"))
end

}
############################### End lua/features/pickup-alert/pa-main.lua ###############################
##########################################################################################

################################### Begin lua/features/pickup-alert/pa-data.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: pickup-alert-data
-- @submodule f_pa_data
-- Persistent data management and alert tracking for the pickup-alert feature.
---------------------------------------------------------------------------------------------------

f_pa_data = {}

---- Persistent variables ----
pa_items_alerted = BRC.Data.persist("pa_items_alerted", {})
pa_recent_alerts = BRC.Data.persist("pa_recent_alerts", {})
pa_OTA_items = BRC.Data.persist("pa_OTA_items", f_pickup_alert.Config.Alert.one_time)
pa_high_score = BRC.Data.persist("pa_high_score", { ac = 0, weapon = 0, plain_dmg = 0 })
pa_egos_alerted = BRC.Data.persist("pa_egos_alerted", {})

---- Local functions ----
local function get_pa_keys(it, use_plain_name)
  if it.class(true) == "bauble" then
    return it.name("qual"):gsub('"', ""), 0
  elseif BRC.it.is_talisman(it) or BRC.it.is_orb(it) then
    return it.name():gsub('"', ""), 0
  elseif BRC.it.is_magic_staff(it) then
    return it.name("base"):gsub('"', ""), 0
  else
    local name = it.name(use_plain_name and "plain" or "base"):gsub('"', "")
    local value = tonumber(name:sub(1, 3))
    if not value then return name, 0 end
    return util.trim(name:sub(4)), value
  end
end

---- Public API ----
function f_pa_data.already_alerted(it)
  local name, value = get_pa_keys(it)
  if pa_items_alerted[name] ~= nil and tonumber(pa_items_alerted[name]) >= value then
    return name
  end
end

function f_pa_data.remember_alert(it)
  if not (it.is_weapon or BRC.it.is_armour(it, true) or BRC.it.is_talisman(it)) then return end
  local name, value = get_pa_keys(it)
  local cur_val = tonumber(pa_items_alerted[name])
  if not cur_val or value > cur_val then pa_items_alerted[name] = value end

  -- Add lesser versions of same item, to avoid alerting an inferior item
  if BRC.eq.get_ego(it) and not BRC.eq.is_risky(it) and not BRC.it.is_talisman(it) then
    -- Add plain unbranded version
    name = it.name("db")
    cur_val = tonumber(pa_items_alerted[name])
    if not cur_val or value > cur_val then pa_items_alerted[name] = value end

    -- For branded artefact, add the plain branded version
    local verbose_ego = it.ego(false)
    if it.artefact and verbose_ego then
      local branded_name
      if BRC.ADJECTIVE_EGOS[verbose_ego] then
        branded_name = BRC.ADJECTIVE_EGOS[verbose_ego] .. " " .. name
      else
        branded_name = name .. " of " .. verbose_ego
      end
      cur_val = tonumber(pa_items_alerted[name])
      if not cur_val or value > cur_val then pa_items_alerted[branded_name] = value end
    end

    -- Armour may hit multiple egos based on artefact properties. Add each plain branded version.
    if it.artefact and BRC.it.is_armour(it) then
      for k, v in pairs(it.artprops) do
        if v > 0 and BRC.ARTPROPS_EGO[k] then
          local branded_name = name .. " of " .. BRC.ARTPROPS_EGO[k]
          cur_val = tonumber(pa_items_alerted[branded_name])
          if not cur_val or value > cur_val then pa_items_alerted[branded_name] = value end
        end
      end
    end
  end
end

function f_pa_data.forget_alert(it)
  local name, _ = get_pa_keys(it)
  pa_items_alerted[name] = nil
end

function f_pa_data.add_recent_alert(it)
  if it.is_weapon or BRC.it.is_armour(it, true) or BRC.it.is_talisman(it) then
    pa_recent_alerts[#pa_recent_alerts + 1] = it.name()
  end
end

function f_pa_data.remove_recent_alert(it)
  util.remove(pa_recent_alerts, it.name())
end

function f_pa_data.find_OTA(it)
  local qualname = it.name("qual")
  for _, v in ipairs(pa_OTA_items) do
    if v and qualname:find(v) then return v end
  end
end

function f_pa_data.remove_OTA(it)
  repeat
    local item_name = f_pa_data.find_OTA(it)
    if item_name == nil then return end
    util.remove(pa_OTA_items, item_name)
  until item_name == nil
end

--- Return name with plus included and quotes removed; used as key in tables
function f_pa_data.get_keyname(it, use_plain_name)
  local name, value = get_pa_keys(it, use_plain_name)
  if not (BRC.it.is_armour(it) or it.is_weapon) then return name end
  if value >= 0 then value = string.format("+%s", value) end
  return string.format("%s %s", value, name)
end

--- Return string of the high score type if item sets a new high score, else nil
function f_pa_data.update_high_scores(it)
  if not it then return end
  local ret_val = nil

  if BRC.it.is_armour(it) then
    local ac = BRC.eq.get_ac(it)
    if ac > pa_high_score.ac then
      pa_high_score.ac = ac
      if not ret_val then ret_val = "Highest AC" end
    end
  elseif it.is_weapon then
    -- Don't alert for unusable weapons
    if BRC.eq.get_hands(it) == 2 and not BRC.you.free_offhand() then return end

    local dmg = BRC.eq.get_avg_dmg(it, BRC.DMG_TYPE.branded)
    if dmg > pa_high_score.weapon then
      pa_high_score.weapon = dmg
      if not ret_val then ret_val = "Highest damage" end
    end

    dmg = BRC.eq.get_avg_dmg(it, BRC.DMG_TYPE.plain)
    if dmg > pa_high_score.plain_dmg then
      pa_high_score.plain_dmg = dmg
      if not ret_val then ret_val = "Highest plain damage" end
    end
  end

  return ret_val
end

}
############################### End lua/features/pickup-alert/pa-data.lua ###############################
##########################################################################################

################################### Begin lua/features/pickup-alert/pa-armour.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: pickup-alert-armour
-- @submodule f_pa_armour
-- @author Medar, gammafunk, buehler
-- Armour pickup and alert functions for the pickup-alert feature.
---------------------------------------------------------------------------------------------------

f_pa_armour = {}

---- Local constants ----
local ENCUMB_ARMOUR_DIVISOR = 2 -- Encumbrance penalty is offset by (Armour / ENCUMB_ARMOUR_DIVISOR)
local SAME = "same_ego"
local LOST = "lost_ego"
local GAIN = "gain_ego"
local NEW = "new_ego"
local DIFF = "diff_ego"
local HEAVIER = "Heavier"
local LIGHTER = "Lighter"

---- Local variables ----
local H -- heuristic tuning alias
local E -- emoji config alias
local A -- alert config alias
local M -- more config alias
local ARMOUR_ALERT

---- Initialization ----
function f_pa_armour.init()
  H = f_pickup_alert.Config.Tuning.Armour
  E = f_pickup_alert.Config.Emoji
  A = f_pickup_alert.Config.Alert
  M = f_pickup_alert.Config.Alert.More

  ARMOUR_ALERT = {
    artefact = { msg = "Artefact armour", emoji = E.ARTEFACT },
    [GAIN] = { msg = "Gain ego", emoji = E.EGO },
    [NEW] = { msg = "New ego", emoji = E.EGO },
    [DIFF] = { msg = "Diff ego", emoji = E.EGO },
    [LIGHTER] = {
      [GAIN] = { msg = "Gain ego (Lighter armour)", emoji = E.EGO },
      [NEW] = { msg = "New ego (Lighter armour)", emoji = E.EGO },
      [DIFF] = { msg = "Diff ego (Lighter armour)", emoji = E.EGO },
      [SAME] = { msg = "Lighter armour", emoji = E.LIGHTER },
      [LOST] = { msg = "Lighter armour (Lost ego)", emoji = E.LIGHTER },
    },
    [HEAVIER] = {
      [GAIN] = { msg = "Gain ego (Heavier armour)", emoji = E.EGO },
      [NEW] = { msg = "New ego (Heavier armour)", emoji = E.EGO },
      [DIFF] = { msg = "Diff ego (Heavier armour)", emoji = E.EGO },
      [SAME] = { msg = "Heavier Armour", emoji = E.HEAVIER },
      [LOST] = { msg = "Heavier Armour (Lost ego)", emoji = E.HEAVIER },
    },
  } -- ARMOUR_ALERT (do not remove this comment)
end

---- Local functions ----
local function aux_slot_is_impaired(it)
  local st = it.subtype()
  -- Skip boots/gloves/helmet if wearing Lear's hauberk
  local worn = items.equipped_at("armour")
  if worn and worn.name("qual") == "Lear's hauberk" and st ~= "cloak" then return true end

  -- Mutation interference
  if st == "gloves" then
    return BRC.you.mut_lvl("demonic touch") >= 3 and not BRC.you.free_offhand()
        or BRC.you.mut_lvl("claws") > 0 and not items.equipped_at("weapon")
  elseif st == "boots" then
    return BRC.you.mut_lvl("hooves") > 0
        or BRC.you.mut_lvl("talons") > 0
  elseif it.name("base"):contains("helmet") then
    return BRC.you.mut_lvl("horns") > 0
        or BRC.you.mut_lvl("beak") > 0
        or BRC.you.mut_lvl("antennae") > 0
  end

  return false
end

local function get_adjusted_ev_delta(encumb_delta, ev_delta)
  local encumb_skills = you.skill("Spellcasting")
    + you.skill("Ranged Weapons")
    - you.skill("Armour") / ENCUMB_ARMOUR_DIVISOR
  local encumb_impact = encumb_skills / you.xl()
  encumb_impact = math.max(0, math.min(1, encumb_impact)) -- Clamp to 0-1

  -- Subtract weighted encumbrance penalty, to align with ev_delta (heavier is negative)
  return ev_delta - encumb_delta * encumb_impact * H.encumb_penalty_weight
end

local function get_ego_change_type(cur_ego, it_ego)
  if it_ego == cur_ego then
    return SAME
  elseif not it_ego then
    return LOST
  elseif not cur_ego then
    return GAIN
  elseif not util.contains(pa_egos_alerted, it_ego) then
    return NEW
  else
    return DIFF
  end
end

--- Decides if an ego change is good enough to skip the min_gain check.
--- For DIFF egos (neutral change), true for Shields/Aux, configurable for body armour
local function is_good_ego_change(ego_change, is_body_armour)
  if ego_change == DIFF then return not is_body_armour or H.diff_body_ego_is_good end
  return ego_change == GAIN or ego_change == NEW
end

local function send_armour_alert(it, t_alert)
  return f_pickup_alert.do_alert(it, t_alert.msg, t_alert.emoji, M.body_armour)
end

-- Local functions: Pickup
local function pickup_body_armour(it)
  local cur = items.equipped_at("armour")
  if not cur then return false end -- surely am naked for a reason

  -- No pickup if wearing an artefact
  if cur.artefact then return false end

  -- No pickup if adding encumbrance or losing AC
  local encumb_delta = it.encumbrance - cur.encumbrance
  if encumb_delta > 0 then return false end
  local ac_delta = BRC.eq.get_ac(it) - BRC.eq.get_ac(cur)
  if ac_delta < 0 then return false end

  -- Pickup: Pure upgrades
  local it_ego = BRC.eq.get_ego(it)
  local cur_ego = BRC.eq.get_ego(cur)
  if it_ego == cur_ego then return (ac_delta > 0 or encumb_delta < 0) end
  return not cur_ego and (ac_delta >= 0 or encumb_delta <= 0)
end

local function pickup_shield(it)
  -- Don't replace these
  local cur = items.equipped_at("offhand")
  if not BRC.it.is_shield(cur) then return false end
  if cur.encumbrance ~= it.encumbrance then return false end
  if cur.artefact then return false end

  -- Pickup: artefact
  if it.artefact then return true end

  -- Pickup: Pure upgrades
  local it_plus = it.plus or 0
  local it_ego = BRC.eq.get_ego(it)
  local cur_ego = BRC.eq.get_ego(cur)
  if it_ego == cur_ego then return it_plus > cur.plus end
  return not cur_ego and it_plus >= cur.plus
end

local function pickup_aux_armour(it)
  -- Pickup: Anything if the slot is empty, unless downside from mutation
  if aux_slot_is_impaired(it) then return false end
  local all_equipped, num_slots = BRC.you.equipped_at(it)
  if #all_equipped < num_slots then
    -- If we're carrying one (implying a blocking mutation), don't pickup another
    if num_slots == 1 then
      local ST = it.subtype()
      return not util.exists(items.inventory(), function(inv) return inv.subtype() == ST end)
    end
    return true
  end

  -- Pickup: artefact, unless slot(s) already full of artefact(s)
  for i, cur in ipairs(all_equipped) do
    if not cur.artefact then break end
    if i == num_slots then return false end
  end
  if it.artefact then return true end

  -- Pickup: Pure upgrades
  local it_ac = BRC.eq.get_ac(it)
  local it_ego = BRC.eq.get_ego(it)
  for _, cur in ipairs(all_equipped) do
    local cur_ac = BRC.eq.get_ac(cur)
    local cur_ego = BRC.eq.get_ego(cur)
    if it_ego == cur_ego then
      if it_ac > cur_ac then return true end
    elseif not cur_ego then
      if it_ac >= cur_ac then return true end
    end
  end
  return false
end

-- Local functions: Alerting
local function should_alert_body_armour(weight, gain, loss, ego_change)
  -- Check if armour stat trade-off meets configured ratio thresholds
  local meets_ratio = loss <= 0
    or (gain / loss > H[weight][ego_change] / A.armour_sensitivity)
  if not meets_ratio then return false end

  -- Additional ego-specific restrictions
  if ego_change == SAME or is_good_ego_change(ego_change, true) then
    return loss <= H[weight].max_loss * A.armour_sensitivity
  else
    return gain >= H[weight].min_gain / A.armour_sensitivity
  end
end

-- Alert when finding higher AC than previously seen, unless training spells/ranged and NOT armour
local function alert_highest_ac(it)
  if you.xl() > 12 then return false end
  local total_skill = you.skill("Spellcasting") + you.skill("Ranged Weapons")
  if total_skill > 0 and you.skill("Armour") == 0 then return false end

  if pa_high_score.ac == 0 then
    local worn = items.equipped_at("armour")
    if not worn then return false end
    pa_high_score.ac = BRC.eq.get_ac(worn)
  else
    local itAC = BRC.eq.get_ac(it)
    if itAC > pa_high_score.ac then
      pa_high_score.ac = itAC
      return f_pickup_alert.do_alert(it, "Highest AC", E.STRONGEST, M.high_score_armour)
    end
  end

  return false
end

local function alert_body_armour(it)
  local cur = items.equipped_at("armour")
  if not cur then return false end

  -- Always alert artefacts once identified
  if it.artefact then return send_armour_alert(it, ARMOUR_ALERT.artefact) end

  -- Get changes to ego, AC, EV, encumbrance
  local it_ego = BRC.eq.get_ego(it)
  local cur_ego = BRC.eq.get_ego(cur)
  local ego_change = get_ego_change_type(cur_ego, it_ego)
  local ac_delta = BRC.eq.get_ac(it) - BRC.eq.get_ac(cur)
  local ev_delta = BRC.eq.get_armour_ev(it) - BRC.eq.get_armour_ev(cur)
  local encumb_delta = it.encumbrance - cur.encumbrance

  -- Alert new egos if same encumbrance, or small change to total (AC+EV)
  if is_good_ego_change(ego_change, true) then
    if encumb_delta == 0 then return send_armour_alert(it, ARMOUR_ALERT[ego_change]) end

    local weight = encumb_delta < 0 and LIGHTER or HEAVIER
    if math.abs(ac_delta + ev_delta) <= H[weight].ignore_small * A.armour_sensitivity then
      BRC.mpr.debug("small change: AC:" .. ac_delta .. ", EV:" .. ev_delta)
      return send_armour_alert(it, ARMOUR_ALERT[weight][ego_change])
    end
  end

  -- Check if lighter/heavier armour meets stat trade-off thresholds
  if encumb_delta < 0 then
    if should_alert_body_armour(LIGHTER, ev_delta, -ac_delta, ego_change) then
      BRC.mpr.debug("Lighter: AC:" .. ac_delta .. ", EV:" .. ev_delta .. ", " .. ego_change)
      return send_armour_alert(it, ARMOUR_ALERT[LIGHTER][ego_change])
    end
  elseif encumb_delta > 0 then
    local adj_ev_delta = get_adjusted_ev_delta(encumb_delta, ev_delta)
    if should_alert_body_armour(HEAVIER, ac_delta, -adj_ev_delta, ego_change) then
      BRC.mpr.debug("Heavier: AC:" .. ac_delta .. ", EV:" .. ev_delta .. ", " .. ego_change)
      return send_armour_alert(it, ARMOUR_ALERT[HEAVIER][ego_change])
    end
  end

  -- Check for record AC values or early-game ego armour
  if alert_highest_ac(it) then return true end
  if it_ego and you.xl() <= H.early_xl then
    return f_pickup_alert.do_alert(it, "Early armour", E.EGO)
  end
end

local function alert_shield(it)
  if it.artefact then
    return f_pickup_alert.do_alert(it, "Artefact shield", E.ARTEFACT, M.shields)
  end

  -- Don't alert shields if not wearing one (one_time_alerts fire for the first of each type)
  local cur = items.equipped_at("offhand")
  if not BRC.it.is_shield(cur) then return false end

  -- Alert: New ego, Gain SH
  local ego_change = get_ego_change_type(BRC.eq.get_ego(cur), BRC.eq.get_ego(it))
  if is_good_ego_change(ego_change, false) then
    local alert_msg = BRC.txt.capitalize(ego_change):gsub("_", " ")
    return f_pickup_alert.do_alert(it, alert_msg, E.EGO, M.shields)
  elseif BRC.eq.get_sh(it) > BRC.eq.get_sh(cur) then
    return f_pickup_alert.do_alert(it, "Higher SH", E.STRONGER, M.shields)
  end
end

local function alert_aux_armour(it, unworn_inv_item)
  if it.artefact then
    return f_pickup_alert.do_alert(it, "Artefact aux armour", E.ARTEFACT, M.aux_armour)
  end

  local all_equipped, num_slots = BRC.you.equipped_at(it)
  if #all_equipped < num_slots then
    if unworn_inv_item then
      all_equipped[#all_equipped + 1] = unworn_inv_item
    else
      -- Catch dangerous brands or items blocked by non-innate mutations
      return f_pickup_alert.do_alert(it, "Aux armour", BRC.EMOJI.EXCLAMATION, M.aux_armour)
    end
  end

  local it_ego = BRC.eq.get_ego(it)
  for _, cur in ipairs(all_equipped) do
    local ego_change = get_ego_change_type(BRC.eq.get_ego(cur), it_ego)
    if is_good_ego_change(ego_change, false) then
      local alert_msg = BRC.txt.capitalize(ego_change):gsub("_", " ")
      return f_pickup_alert.do_alert(it, alert_msg, E.EGO, M.aux_armour)
    elseif BRC.eq.get_ac(it) > BRC.eq.get_ac(cur) then
      return f_pickup_alert.do_alert(it, "Higher AC", E.STRONGER, M.aux_armour)
    end
  end
end

---- Public API ----
function f_pa_armour.pickup_armour(it)
  if BRC.eq.is_risky(it) then return false end

  if BRC.it.is_body_armour(it) then
    return pickup_body_armour(it)
  elseif BRC.it.is_shield(it) then
    return pickup_shield(it)
  else
    return pickup_aux_armour(it)
  end
end

--- Alerts armour items that didn't auto-pickup but are worth considering.
--- This comes after pickup, so there will be no pure upgrades.
-- @param unworn_inv_item (optional) to compare against an unworn aux armour item in inventory.
function f_pa_armour.alert_armour(it, unworn_inv_item)
  if BRC.it.is_body_armour(it) then
    return alert_body_armour(it)
  elseif BRC.it.is_shield(it) then
    return alert_shield(it)
  else
    return alert_aux_armour(it, unworn_inv_item)
  end
end

}
############################### End lua/features/pickup-alert/pa-armour.lua ###############################
##########################################################################################

################################### Begin lua/features/pickup-alert/pa-misc.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: pickup-alert-misc
-- @submodule f_pa_misc
-- Miscellaneous item pickup and alert functions for the pickup-alert feature.
---------------------------------------------------------------------------------------------------

f_pa_misc = {}

---- Local variables ----
local E -- emoji config alias
local A -- alert config alias
local M -- more config alias

---- Initialization ----
function f_pa_misc.init()
  E = f_pickup_alert.Config.Emoji
  A = f_pickup_alert.Config.Alert
  M = f_pickup_alert.Config.Alert.More
end

---- Local functions ----

---- Public API ----
function f_pa_misc.alert_orb(it)
  return f_pickup_alert.do_alert(it, "New orb", E.ORB, M.orbs)
end

function f_pa_misc.alert_OTA(it)
  local ota_item = f_pa_data.find_OTA(it)
  if not ota_item then return end

  local do_alert = true

  if BRC.it.is_shield(it) then
    if you.skill("Shields") < A.OTA_require_skill.shield then return end

    -- Don't alert if already wearing a larger shield
    if ota_item == "buckler" then
      if BRC.you.have_shield() then do_alert = false end
    elseif ota_item == "kite shield" then
      local sh = items.equipped_at("offhand")
      if sh and sh.name("qual") == "tower shield" then do_alert = false end
    end
  elseif BRC.it.is_armour(it) then
    if you.skill("Armour") < A.OTA_require_skill.armour then return end
  elseif it.is_weapon then
    if you.skill(it.weap_skill) < A.OTA_require_skill.weapon then return end
  end

  f_pa_data.remove_OTA(it)
  if not do_alert then return false end
  return f_pickup_alert.do_alert(it, "Found first", E.RARE_ITEM, M.one_time_alerts)
end

function f_pa_misc.alert_staff(it)
  local basename = it.name("base")
  local tag
  local tag_color

  if basename == "staff of air" then
    if you.res_shock() > 0 then return false end
    tag = "rElec"
    tag_color = BRC.COL.lightcyan
  elseif basename == "staff of alchemy" then
    if you.res_poison() > 0 then return false end
    tag = "rPois"
    tag_color = BRC.COL.lightgreen
  elseif basename == "staff of cold" then
    if you.res_cold() > 0 then return false end
    tag = "rC+"
    tag_color = BRC.COL.lightblue
  elseif basename == "staff of fire" then
    if you.res_fire() > 0 then return false end
    tag = "rF+"
    tag_color = BRC.COL.lightred
  elseif basename == "staff of necromancy" then
    if you.res_draining() > 0 then return false end
    tag = "rN+"
    tag_color = BRC.COL.lightmagenta
  else
    return false
  end

  for _, inv in ipairs(items.inventory()) do
    if inv.is_weapon and inv.name("plain"):contains(tag) then
      return false
    end
  end

  tag = BRC.txt[tag_color]("(" .. tag .. ")")
  return f_pickup_alert.do_alert(it, "Staff resistance " .. tag, E.STAFF_RES, M.staff_resists)
end

function f_pa_misc.alert_talisman(it)
  if not it.is_identified then return false end -- Necessary to avoid firing on '\' menu
  if it.artefact then
    return f_pickup_alert.do_alert(it, "Artefact talisman", E.TALISMAN, M.talismans)
  end
  local required_skill = BRC.it.get_talisman_min_level(it) - A.talisman_lvl_diff
  if required_skill > BRC.you.shapeshifting_skill() then return false end
  return f_pickup_alert.do_alert(it, "New talisman", E.TALISMAN, M.talismans)
end

function f_pa_misc.is_unneeded_ring(it)
  if not BRC.it.is_ring(it) or it.artefact or you.race() == "Octopode" then return false end
  local missing_hand = BRC.you.mut_lvl("missing a hand") > 0
  local st = it.subtype()
  local found_first = false
  for _, inv in ipairs(items.inventory()) do
    if BRC.it.is_ring(inv) and inv.subtype() == st then
      if found_first or missing_hand then return true end
      found_first = true
    end
  end
  return false
end

function f_pa_misc.pickup_staff(it)
  if f_pa_data.already_alerted(it) then return false end
  if BRC.you.skill(BRC.it.get_staff_school(it)) == 0 then return false end

  local qualname = it.name("qual")
  local max_slots = BRC.you.num_eq_slots(it)
  local count = 0
  for _, inv in ipairs(items.inventory()) do
    if inv.name("qual") == qualname then
      count = count + 1
      if count >= max_slots then return false end
    end
  end

  return true
end

}
############################### End lua/features/pickup-alert/pa-misc.lua ###############################
##########################################################################################

################################### Begin lua/features/pickup-alert/pa-weapons.lua ###################################
############### https://github.com/brianfaires/crawl-rc/ ###############
{
---------------------------------------------------------------------------------------------------
-- BRC feature module: pickup-alert-weapons
-- @submodule f_pa_weapons
-- Weapon pickup and alert functions for the pickup-alert feature.
-- _weapon_cache table stores info about inventory weapons, to avoid repeat calculations.
---------------------------------------------------------------------------------------------------

f_pa_weapons = {}

---- Persistent variables ----
pa_lowest_hands_alerted = BRC.Data.persist("pa_lowest_hands_alerted", {
  ["Ranged Weapons"] = 3, -- Track lowest hand count alerted for this weapon school
  ["Polearms"] = 3, -- Track lowest hand count alerted for this weapon school
})

---- Local constants ----
local FIRST_WEAPON_XL_CUTOFF = 6 -- Stop first-weapon alerts after this experience level
local POLEARM_RANGED_CUTOFF = 3 -- Stop polearm alerts when ranged skill reaches this level
local UPGRADE_SKILL_FACTOR = 0.5 -- No upgrade alerts if weapon skill is this % of top skill
-- Weapon cache constants
local RANGED_PREFIX = "range_"
local MELEE_PREFIX = "melee_"
local WEAP_CACHE_KEYS = {
  "melee_1", "melee_1b", "melee_2", "melee_2b", "range_1", "range_1b", "range_2", "range_2b"
} -- WEAP_CACHE_KEYS (do not remove this comment)

---- Local variables ----
local C -- config alias
local W -- heuristic tuning alias
local E -- emoji config alias
local A -- alert config alias
local M -- more config alias
local top_attack_skill
local _weapon_cache = {} -- Cache info for inventory weapons to avoid repeat calculations

---- Initialization ----
function f_pa_weapons.init()
  C = f_pickup_alert.Config
  W = f_pickup_alert.Config.Tuning.Weap
  E = f_pickup_alert.Config.Emoji
  A = f_pickup_alert.Config.Alert
  M = f_pickup_alert.Config.Alert.More
  top_attack_skill = BRC.you.top_wpn_skill() or "Unarmed Combat"
  _weapon_cache.refresh(true)

  if not A.first_ranged then pa_lowest_hands_alerted["Ranged Weapons"] = 0 end
  if not A.first_polearm then pa_lowest_hands_alerted["Polearms"] = 0 end
end

---- Local functions ----
local function get_score(it, no_brand_bonus)
  if it.dps and it.acc then
    -- Handle cached /  high-score tuples in _weapon_cache
    return it.dps + it.acc * W.Pickup.accuracy_weight
  end
  local dmg_type = no_brand_bonus and BRC.DMG_TYPE.unbranded or BRC.DMG_TYPE.scoring
  local acc_bonus = (it.accuracy + (it.plus or 0)) * W.Pickup.accuracy_weight
  return BRC.eq.get_dps(it, dmg_type) + acc_bonus
end

local function is_upgradable_weapon(it, cur)
  return cur.is_ranged == it.is_ranged
    and BRC.it.is_polearm(cur) == BRC.it.is_polearm(it)
    and (
      you.race() == "Gnoll"
      or BRC.you.skill(it.weap_skill) >= UPGRADE_SKILL_FACTOR * BRC.you.skill(cur.weap_skill)
    )
end

-- is_weapon_upgrade() -> boolean: compares floor weapon to one in inventory
-- `cur` comes from _weapon_cache - it has some pre-computed values
local function is_weapon_upgrade(it, cur, strict)
  if not cur.allow_upgrade then return false end
  if strict then
    -- Pure upgrades only
    if cur.artefact or it.subtype() ~= cur.subtype() then return false end
    if it.artefact then return true end
    local it_plus = it.plus or 0
    local cur_ego = BRC.eq.get_ego(cur)
    if BRC.eq.get_ego(it) == cur_ego then return it_plus > cur.plus end
    return not cur_ego and it_plus >= cur.plus
  end

  -- Check if it's a very likely upgrade
  if it.subtype() == cur.subtype() then
    if it.artefact then return true end
    if cur.artefact and not A.allow_arte_weap_upgrades then return false end

    local it_ego = BRC.eq.get_ego(it)
    local cur_ego = BRC.eq.get_ego(cur)
    if cur_ego and not it_ego then return false end
    if it_ego and not cur_ego then return get_score(it) / cur.score > W.Pickup.add_ego end
    return it_ego == cur_ego and (it.plus or 0) > cur.plus
  elseif it.weap_skill == cur.weap_skill or you.race() == "Gnoll" then
    if BRC.eq.get_hands(it) > cur.hands then return false end
    if cur.is_ranged ~= it.is_ranged then return false end
    if BRC.it.is_polearm(cur) ~= BRC.it.is_polearm(it) then return false end

    if it.artefact then return true end
    if cur.artefact and not A.allow_arte_weap_upgrades then return false end

    local min_ratio = it.is_ranged and W.Pickup.same_type_ranged or W.Pickup.same_type_melee
    return get_score(it) / cur.score > min_ratio
  end

  return false
end

local function make_alert(it, msg, emoji, fm_option)
  return { it = it, msg = msg, emoji = emoji, fm_option = fm_option }
end

local function need_first_weapon()
  return you.xl() < FIRST_WEAPON_XL_CUTOFF
    and _weapon_cache.is_empty()
    and you.skill("Unarmed Combat") == 0
    and BRC.you.mut_lvl("claws") == 0
end

-- Local functions: Weapon cache
function _weapon_cache.get_primary_key(it)
  local tokens = {}
  tokens[1] = it.is_ranged and RANGED_PREFIX or MELEE_PREFIX
  tokens[2] = tostring(it.hands)
  if BRC.eq.get_ego(it) then tokens[3] = "b" end
  return table.concat(tokens)
end

--- Get all categories this weapon fits into (including more-restrictive categories)
function _weapon_cache.get_keys(is_ranged, hands, is_branded)
  local ranged_types = is_ranged and { RANGED_PREFIX, MELEE_PREFIX } or { MELEE_PREFIX }
  local handed_types = hands == 1 and { "1", "2" } or { "2" }
  local branded_types = is_branded and { "b", "" } or { "" }

  -- Generate all combinations
  local keys = {}
  for _, r in ipairs(ranged_types) do
    for _, h in ipairs(handed_types) do
      for _, b in ipairs(branded_types) do
        keys[#keys + 1] = table.concat({ r, h, b })
      end
    end
  end

  return keys
end

function _weapon_cache.add_weapon(it)
  local weap_data = {}
  weap_data.is_weapon = it.is_weapon
  weap_data.basename = it.name("base")
  weap_data._subtype = it.subtype()
  weap_data.subtype = function() -- For consistency with crawl item.subtype()
    return weap_data._subtype
  end
  weap_data.weap_skill = it.weap_skill
  weap_data.skill_lvl = BRC.you.skill(it.weap_skill)
  weap_data.is_ranged = it.is_ranged
  weap_data.hands = BRC.eq.get_hands(it)
  weap_data.artefact = it.artefact
  weap_data._ego = BRC.eq.get_ego(it)
  weap_data.ego = function() -- For consistency with crawl item.ego()
    return weap_data._ego
  end
  weap_data.plus = it.plus or 0
  weap_data.acc = it.accuracy + weap_data.plus
  weap_data.damage = it.damage
  weap_data.dps = BRC.eq.get_dps(it)
  weap_data.score = get_score(it)
  weap_data.unbranded_score = get_score(it, true)

  -- Check for exclusion tags
  local lower_insc = it.inscription:lower()
  weap_data.allow_upgrade = not (lower_insc:contains("!u") or lower_insc:contains("!brc"))

  -- Track unique egos
  if weap_data._ego and not util.contains(_weapon_cache.egos, weap_data._ego) then
    _weapon_cache.egos[#_weapon_cache.egos + 1] = weap_data._ego
  end

  -- Track max damage for applicable weapon categories
  local keys = _weapon_cache.get_keys(weap_data.is_ranged, weap_data.hands, weap_data._ego ~= nil)

  -- Update the max DPS for each category
  for _, key in ipairs(keys) do
    if weap_data.dps > _weapon_cache.max_dps[key].dps then
      _weapon_cache.max_dps[key].dps = weap_data.dps
      _weapon_cache.max_dps[key].acc = weap_data.acc
    end
  end

  _weapon_cache.weapons[#_weapon_cache.weapons + 1] = weap_data
  return weap_data
end

function _weapon_cache.is_empty()
  return _weapon_cache.max_dps["melee_2"].dps == 0 -- The most restrictive category
end

function _weapon_cache.refresh(skip_turn_check)
  local cur_turn = you.turns()
  if _weapon_cache.turn and _weapon_cache.turn == cur_turn and not skip_turn_check then return end
  _weapon_cache.turn = cur_turn
  _weapon_cache.weapons = {}
  _weapon_cache.egos = {}

  -- Can reuse max_dps table
  if _weapon_cache.max_dps then
    for _, key in ipairs(WEAP_CACHE_KEYS) do
      _weapon_cache.max_dps[key].dps = 0
      _weapon_cache.max_dps[key].acc = 0
    end
  else
    _weapon_cache.max_dps = {}
    for _, key in ipairs(WEAP_CACHE_KEYS) do
      _weapon_cache.max_dps[key] = { dps = 0, acc = 0 }
    end
  end

  for _, inv in ipairs(items.inventory()) do
    if inv.is_weapon and not BRC.it.is_magic_staff(inv) then
      _weapon_cache.add_weapon(inv)
      f_pa_data.update_high_scores(inv)
    end
  end
end

-- Local functions: Alerting
local function get_first_of_skill_alert(it)
  local skill = it.weap_skill
  if not pa_lowest_hands_alerted[skill] then return end

  local hands = BRC.eq.get_hands(it)
  if pa_lowest_hands_alerted[skill] > hands then
    -- Some early checks to skip alerts
    if hands == 2 and BRC.you.have_shield() then return end
    if skill == "Polearms" and you.skill("Ranged Weapons") >= POLEARM_RANGED_CUTOFF then return end

    -- Update lowest # hands alerted, and alert
    pa_lowest_hands_alerted[skill] = hands
    local msg = "First " .. string.sub(skill, 1, -2) .. (hands == 1 and " (1-handed)" or "")
    return make_alert(it, msg, E.WEAPON, M.early_weap)
  end
end

local function get_early_weapon_alert(it)
  -- Alert really good usable ranged weapons
  if it.is_ranged and you.xl() <= W.Alert.EarlyRanged.xl then
    local min_plus = W.Alert.EarlyRanged[BRC.eq.get_ego(it) and "branded_min_plus" or "min_plus"]
    if (it.plus or 0) >= min_plus / A.weapon_sensitivity then
      local low_shield_training = you.skill("Shields") <= W.Alert.EarlyRanged.max_shields
      if BRC.eq.get_hands(it) == 1 or not BRC.you.have_shield() or low_shield_training then
        return make_alert(it, "Ranged weapon", E.RANGED, M.early_weap)
      end
    end
  end

  if you.xl() <= W.Alert.Early.xl then
    -- Ignore items if we're clearly going another route
    local skill_setting = W.Alert.Early.skill
    local skill_diff = BRC.you.skill(top_attack_skill) - BRC.you.skill(it.weap_skill)
    if skill_diff > you.xl() * skill_setting.factor + skill_setting.offset then return false end

    local it_plus = it.plus or 0
    if
      BRC.eq.get_ego(it)
      or it_plus >= W.Alert.Early.branded_min_plus / A.weapon_sensitivity
    then
      return make_alert(it, "Early weapon", E.WEAPON, M.early_weap)
    end
  end

  return false
end

local function get_weap_high_score_alert(it)
  if _weapon_cache.is_empty() then return end -- Skip if not using weapons
  local category = f_pa_data.update_high_scores(it)
  if not category then return end
  return make_alert(it, category, E.WEAPON, M.high_score_weap)
end

-- get_upgrade_alert() subroutines
local function can_use_2h_without_losing_shield()
  return BRC.you.free_offhand() or (you.skill("Shields") < W.Alert.AddHand.ignore_sh_lvl)
end

local function check_upgrade_free_offhand(it, ratio)
  local it_ego = BRC.eq.get_ego(it)
  if it_ego and not util.contains(_weapon_cache.egos, it_ego) and ratio > W.Alert.new_ego then
    return make_alert(it, "New ego (2-handed)", E.EGO, M.weap_ego)
  elseif ratio > W.Alert.AddHand.not_using then
    return make_alert(it, "2-handed weapon", E.TWO_HAND, M.upgrade_weap)
  end
  return false
end

local function check_upgrade_lose_shield(it, cur, ratio)
  if (
      BRC.eq.get_ego(it)
      and not BRC.eq.get_ego(cur)
      and ratio > W.Alert.AddHand.add_ego_lose_sh
    )
  then
    return make_alert(it, "2-handed weapon (Gain ego)", E.TWO_HAND, M.weap_ego)
  end

  return false
end

local function check_upgrade_no_hand_loss(it, cur, ratio)
  if BRC.eq.get_ego(it, true) then -- Don't overvalue Speed/Heavy egos (only consider their DPS)
    local it_ego = BRC.eq.get_ego(it)
    if not BRC.eq.get_ego(cur) then
      if ratio > W.Alert.gain_ego then
        return make_alert(it, "Gain ego", E.EGO, M.weap_ego)
      end
    elseif not util.contains(_weapon_cache.egos, it_ego) and ratio > W.Alert.new_ego then
      return make_alert(it, "New ego", E.EGO, M.weap_ego)
    end
  end

  if ratio > W.Alert.pure_dps then
    return make_alert(it, "DPS increase", E.WEAPON, M.upgrade_weap)
  end

  return false
end

local function check_upgrade_same_subtype(it, cur, best_dps, best_score)
  local it_ego = BRC.eq.get_ego(it, true) -- Don't overvalue speed/heavy (only consider their DPS)
  local cur_ego = BRC.eq.get_ego(cur)
  if it_ego and it_ego ~= cur_ego then
    local change = cur_ego and "Diff ego" or "Gain ego"
    return make_alert(it, change, E.EGO, M.weap_ego)
  end

  local s = A.weapon_sensitivity
  if get_score(it) > best_score / s or BRC.eq.get_dps(it) > best_dps / s then
    return make_alert(it, "Weapon upgrade", E.WEAPON, M.upgrade_weap)
  end
end

--- Check if weapon is worth alerting for, compared against one weapon currently in inventory
-- @param cur (weapon) comes from _weapon_cache - it has some pre-computed values
local function get_upgrade_alert(it, cur, best_dps, best_score)
  -- Ensure the non-strict upgrade is checked, if not already done in pickup_weapon()
  if C.Pickup.weapons_pure_upgrades_only and is_weapon_upgrade(it, cur, false) then
    return make_alert(it, "Weapon upgrade", E.WEAPON, M.upgrade_weap)
  end

  if it.artefact then return make_alert(it, "Artefact weapon", E.ARTEFACT) end
  if cur.artefact and not A.allow_arte_weap_upgrades then return false end
  if not is_upgradable_weapon(it, cur) then return end

  if cur.subtype() == it.subtype() then
    return check_upgrade_same_subtype(it, cur, best_dps, best_score)
  end

  -- Get ratio of weap_score / best_score. Penalize lower-trained skills
  local damp = W.Alert.low_skill_penalty_damping
  local penalty = (BRC.you.skill(it.weap_skill) + damp) / (BRC.you.skill(top_attack_skill) + damp)
  local ratio = penalty * get_score(it) / best_score * A.weapon_sensitivity

  if BRC.eq.get_hands(it) <= cur.hands then
    return check_upgrade_no_hand_loss(it, cur, ratio)
  elseif can_use_2h_without_losing_shield() then
    return check_upgrade_free_offhand(it, ratio)
  else
    return check_upgrade_lose_shield(it, cur, ratio)
  end
end

local function get_inventory_upgrade_alert(it)
  -- Once, find the top dps & score for inventory weapons of the same category
  local inv_best = _weapon_cache.max_dps[_weapon_cache.get_primary_key(it)]
  local top_dps = inv_best and inv_best.dps or 0
  local top_score = inv_best and get_score(inv_best) or 0

  -- Compare against all inventory weapons, even from other categories
  for _, inv in ipairs(_weapon_cache.weapons) do
    if inv.allow_upgrade then
      local best_dps = math.max(inv.dps, top_dps)
      local best_score = math.max(inv.score, top_score)
      local a = get_upgrade_alert(it, inv, best_dps, best_score)
      if a then return a end
    end
  end
end

local function get_weapon_alert(it)
  return get_inventory_upgrade_alert(it)
    or get_first_of_skill_alert(it)
    or get_early_weapon_alert(it)
    or get_weap_high_score_alert(it)
end

---- Public API ----
function f_pa_weapons.pickup_weapon(it)
  _weapon_cache.refresh()
  if need_first_weapon() then
    -- Check if we're carrying a weapon that didn't go into _weapon_cache (like a staff)
    return not util.exists(items.inventory(), function(i) return i.is_weapon end)
  end

  if BRC.eq.is_risky(it) then return false end
  for _, inv in ipairs(_weapon_cache.weapons) do
    if is_weapon_upgrade(it, inv, C.Pickup.weapons_pure_upgrades_only) then
      -- Confirm after updating cache, to avoid spurious alerts from XP gain.
      _weapon_cache.refresh(true)
      if is_weapon_upgrade(it, inv, C.Pickup.weapons_pure_upgrades_only) then return true end
    end
  end
end

function f_pa_weapons.alert_weapon(it)
  _weapon_cache.refresh()
  local a = get_weapon_alert(it)
  if not a then return false end

  -- Refresh mid-turn to avoid spurious alerts from XP gain. (Except for first-of-skill alerts)
  if not a.msg:contains("First ") then
    _weapon_cache.refresh(true)
    a = get_weapon_alert(it)
    if not a then return false end
  end

  return f_pickup_alert.do_alert(a.it, a.msg, a.emoji, a.fm_option)
end

---- Crawl hook functions ----
function f_pa_weapons.ready()
  top_attack_skill = BRC.you.top_wpn_skill() or "Unarmed Combat"
end

}
############################### End lua/features/pickup-alert/pa-weapons.lua ###############################
##########################################################################################

############## Lua Hook Functions ##############
{
function c_message(text, channel)
  BRC.c_message(text, channel)
end

function c_answer_prompt(prompt)
  return BRC.c_answer_prompt(prompt)
end

function c_assign_invletter(it)
  return BRC.c_assign_invletter(it)
end

function ch_start_running(kind)
  BRC.ch_start_running(kind)
end

function ready()
  BRC.ready()
end

BRC.init()
}
