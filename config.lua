Config = {}


Config.DefaultDisplayDuration = 4000


Config.SoundPathInNUI = "sounds/" -- = html/sounds/your_sound.ogg

-- Sound Config
Config.AnnounceSounds = {
    -- Volume
    defaultVolume = 0.4, --  0.0 (mute) and 1.0 (max Volume)

    -- Define the filename and desired volume for each announcement type here.
    -- The filename is relative to the above-defined Config.SoundPathInNUI.
    -- If no sound should be played for a type, set 'file = nil'.

    info = {
        file = "info.ogg",     --  zhora_announce/html/sounds/info_sound.ogg
        volume = 0.3
    },
    warning = {
        file = "warn.ogg",  --  zhora_announce/html/sounds/warning_sound.ogg
        volume = 0.5
    },
    important = {
        file = "error.ogg",  --  zhora_announce/html/sounds/wichtig_sound.ogg
        volume = 0.6
    },
    server = { 
        file = "success.ogg",     
        volume = 0.3
    },
    announcement = { --  General Announcement Type   
        file = "success.ogg",
        volume = 0.4
    },
    information = { --  Alternative to 'info'
        file = "success.ogg",
        volume = 0.3
    },
    datasaved = { --  For save notifications
        file = "success.ogg",  --  Could use a positive, short sound
        volume = 0.3
    },
    error = { --  For error messages
        file = "success.ogg",    --  zhora_announce/html/sounds/error_sound.ogg
        volume = 0.6
    },
    success = { --  For success messages
        file = "success.ogg",  --  zhora_announce/html/sounds/success_sound.ogg
        volume = 0.4
    },
    bank = { --  For bank notifications
        file = "success.ogg",     --  Or a specific "money" sound
        volume = 0.4
    },
    characterstatus = { --  For character status messages
        file = "success.ogg",  --  Could use a attention-grabbing sound
        volume = 0.5
    }
}