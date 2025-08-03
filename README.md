# 🎯 zhora_announce

**A modern, professional announcement system for FiveM ESX servers**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Version](https://img.shields.io/badge/Version-1.1.0-blue.svg)
[![ESX](https://img.shields.io/badge/ESX-Legacy-green.svg)](https://github.com/esx-framework/esx-legacy)


## DEMO VIDEO

[![Demo](https://img.shields.io/badge/Demo-Watch%20Video-red.svg)](https://streamable.com/zo3p1m)

A feature-rich announcement system with beautiful UI animations, sound integration, queue management, and extensive customization options. Perfect for server announcements, events, notifications, and admin communications.

## 🌟 Features

- **🎨 Modern UI Design** - Clean, responsive interface with smooth animations and glassmorphism effects
- **🔊 Sound Integration** - Customizable sounds for different announcement types with volume control
- **📊 Queue System** - Automatic queueing and sequential display of multiple announcements
- **🔐 Admin Permissions** - Role-based access control with ESX group integration
- **🎭 Multiple Types** - Support for info, warning, important, success, error, and custom announcement types
- **🏷️ Custom Titles** - Create announcements with custom titles or use predefined ones
- **🔌 API Integration** - Easy integration with other resources via events and exports
- **⚙️ Fully Configurable** - Customize colors, icons, sounds, display duration, and more
- **🔄 Queue Management** - Smart announcement queuing with cooldown system
- **📱 Responsive Design** - Works on all screen sizes and resolutions

## 📋 Requirements

- **ESX Framework** - Tested and optimized for ESX Legacy framework

## 🚀 Installation

### Step 1: Download and Extract
1. Download the `zhora_announce` resource
2. Extract to your server's `resources` directory
3. Ensure the folder structure matches:
```
zhora_announce/
├── fxmanifest.lua
├── config.lua
├── server/
│   └── server.lua
├── client/
│   └── client.lua
└── html/
    ├── ui.html
    ├── style.css
    ├── script.js
    └── sounds/
        ├── info.ogg
        ├── warn.ogg
        ├── error.ogg
        └── success.ogg
```

### Step 2: Add to Server Config
Add to your `server.cfg`:
```cfg
ensure zhora_announce
```

### Step 3: Start the Resource
```
restart zhora_announce
```

## ⚙️ Configuration

### Display Settings
```lua
Config.DefaultDisplayDuration = 4000  -- Duration in milliseconds (4 seconds)
Config.SoundPathInNUI = "sounds/"     -- Path to sound files relative to html folder
```

### Sound Configuration
Configure sounds for each announcement type in `config.lua`:

```lua
Config.AnnounceSounds = {
    defaultVolume = 0.4,  -- Global default volume (0.0 to 1.0)
    
    info = {
        file = "info.ogg",
        volume = 0.3
    },
    warning = {
        file = "warn.ogg", 
        volume = 0.5
    },
    important = {  -- Note: Your config uses "important", not "wichtig"
        file = "error.ogg",
        volume = 0.6
    },
    success = {
        file = "success.ogg",
        volume = 0.4
    },
    error = {
        file = "success.ogg",  -- You can use different sound files
        volume = 0.6
    },
    server = {
        file = "success.ogg",
        volume = 0.3
    }
    -- Add more types as needed
}
```

### Available Announcement Types
Based on your configuration, these types are available:
- `info` - General information (Blue icon)
- `warning` - Warnings and alerts (Orange icon)
- `important` - Critical messages (Red icon)
- `success` - Success confirmations (Green icon)
- `error` - Error messages (Red icon)
- `server` - Server-related messages (Gray icon)
- `announcement` - General announcements (Orange icon)
- `information` - Alternative to info (Blue icon)
- `datasaved` - Data save confirmations (Green icon)
- `bank` - Banking notifications (Blue icon)
- `characterstatus` - Character status messages (Red icon)

## 🎮 Commands Reference

### Standard Commands (Predefined Titles)
| Command | Type | Default Title | Description |
|---------|------|---------------|-------------|
| `/ainfo [message]` | info | "Information" | General information announcements |
| `/awarn [message]` | warning | "Warning" | Warning and alert messages |
| `/awichtig [message]` | wichtig | "Important" | Critical/important messages |
| `/asuccess [message]` | success | "Success" | Success confirmation messages |
| `/aerror [message]` | error | "Error" | Error and failure messages |
| `/aserver [message]` | server | "Server Notice" | Server-related announcements |

### Themed Quick Commands
| Command | Type | Default Title | Use Case |
|---------|------|---------------|----------|
| `/arestart [message]` | warning | "Server Restart" | Server restart notifications |
| `/aevent [message]` | info | "Event Notification" | Event announcements |
| `/aupdate [message]` | info | "Update Notice" | Server update notifications |
| `/amaintenance [message]` | warning | "Maintenance" | Maintenance announcements |

### Custom Title Commands
**Format:** `command [custom_title] [message]`

| Command | Type | Description |
|---------|------|-------------|
| `/titleinfo [title] [message]` | info | Info announcement with custom title |
| `/titlewarn [title] [message]` | warning | Warning announcement with custom title |
| `/titlewichtig [title] [message]` | wichtig | Important announcement with custom title |
| `/titlesuccess [title] [message]` | success | Success announcement with custom title |
| `/titleerror [title] [message]` | error | Error announcement with custom title |
| `/titleserver [title] [message]` | server | Server announcement with custom title |

### Short Custom Title Commands  
| Command | Type | Description |
|---------|------|-------------|
| `/cinfo [title] [message]` | info | Short custom info command |
| `/cwarn [title] [message]` | warning | Short custom warning command |
| `/cwichtig [title] [message]` | wichtig | Short custom important command |
| `/csuccess [title] [message]` | success | Short custom success command |
| `/cerror [title] [message]` | error | Short custom error command |
| `/cserver [title] [message]` | server | Short custom server command |

### Universal Commands
| Command | Format | Description |
|---------|--------|-------------|
| `/announce [type] [message]` | Basic announcement with type detection |
| `/cannounce [type] [title] [message]` | Universal custom announcement |

### Testing Commands
| Command | Description |
|---------|-------------|
| `/testannounce [type] [message]` | Test single announcement type |
| `/testannounce all` | Test all configured announcement types in sequence |

## 💡 Usage Examples

### Basic Usage
```bash
# Standard announcements with default titles
/ainfo Server will restart in 10 minutes
/awarn Please park all vehicles safely
/asuccess Event completed successfully!

# Custom title announcements
/titleinfo "Breaking News" A new update has been released
/cwarn "Road Closure" Main street blocked due to construction
/csuccess "Winner!" Congratulations to Player123

# Universal custom announcement
/cannounce info "Special Event" Join the race at the airport now!
```

### Advanced Examples

#### 1. Server Management
```bash
# Server restart sequence
/arestart Server will restart in 5 minutes for updates
/arestart Server restarting in 2 minutes - save your progress
/arestart Server restart imminent - disconnecting in 30 seconds

# Maintenance announcements
/amaintenance Scheduled maintenance starting at 3 AM EST
/titleserver "Maintenance Complete" All systems are back online
```

#### 2. Event Management
```bash
# Event announcements
/aevent Street race starting at the airport in 5 minutes
/titleinfo "Event Starting" PvP tournament begins now!
/csuccess "Event Winner" Congratulations to RaceKing123!

# Custom event series
/cannounce info "Weekly Race" Join us every Friday for racing events
/cannounce success "Champion" This week's racing champion is SpeedDemon!
```

#### 3. Player Management
```bash
# Welcome messages
/cinfo "Welcome" New player guidelines can be found on our website
/titleinfo "Server Rules" Please read /rules before playing

# Warnings and violations
/cwarn "Speed Limit" Excessive speeding will result in fines
/titleerror "Rule Violation" Player123 has been warned for RDM
```

## 🔗 API Integration

### Server-Side Events

#### `zhora_announce:trigger`
The main event for triggering announcements from other resources.

**Syntax:**
```lua
TriggerEvent('zhora_announce:trigger', message, title, type)
```

**Parameters:**
- `message` (string) - The announcement message
- `title` (string, optional) - Custom title (defaults to "System Event")
- `type` (string, optional) - Announcement type (defaults to "info")

**Examples:**
```lua
-- Basic announcement
TriggerEvent('zhora_announce:trigger', 
    'Welcome to our server!', 
    'Welcome Message', 
    'info'
)

-- Player join notification
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local playerName = GetPlayerName(playerId)
    TriggerEvent('zhora_announce:trigger', 
        playerName .. ' has joined the server!', 
        'Player Joined', 
        'info'
    )
end)

-- Shop purchase notification
RegisterServerEvent('shop:purchaseComplete')
AddEventHandler('shop:purchaseComplete', function(itemName, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    TriggerEvent('zhora_announce:trigger', 
        xPlayer.getName() .. ' purchased ' .. itemName .. ' for $' .. price, 
        'Shop Purchase', 
        'success'
    )
end)
```

### Export Functions

#### Main Export Function
```lua
exports.zhora_announce:TriggerAnnounce(message, title, type)
```

#### Type-Specific Export Functions
```lua
exports.zhora_announce:TriggerInfoAnnounce(message, title)
exports.zhora_announce:TriggerWarningAnnounce(message, title)
exports.zhora_announce:TriggerWichtigAnnounce(message, title)  -- Important announcements
exports.zhora_announce:TriggerSuccessAnnounce(message, title)
exports.zhora_announce:TriggerErrorAnnounce(message, title)
exports.zhora_announce:TriggerServerAnnounce(message, title)
```

**Example Usage:**
```lua
-- In another resource
exports.zhora_announce:TriggerSuccessAnnounce(
    'Transaction completed successfully!', 
    'Banking System'
)

exports.zhora_announce:TriggerWarningAnnounce(
    'Suspicious activity detected in your account', 
    'Security Alert'
)
```

## 🎯 Integration Examples

### 1. Player Management System
```lua
-- player_manager.lua
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local playerName = GetPlayerName(playerId)
    local playerCount = GetNumPlayerIndices()
    
    TriggerEvent('zhora_announce:trigger', 
        string.format('%s joined the server! (%d/%d players)', 
            playerName, playerCount, GetConvarInt('sv_maxclients', 32)
        ), 
        'Player Joined', 
        'info'
    )
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    local playerName = GetPlayerName(playerId)
    local playerCount = GetNumPlayerIndices() - 1
    
    TriggerEvent('zhora_announce:trigger', 
        string.format('%s left the server (%d/%d players)', 
            playerName, playerCount, GetConvarInt('sv_maxclients', 32)
        ), 
        'Player Left', 
        'warning'
    )
end)
```

### 2. Economy System Integration
```lua
-- economy_system.lua
RegisterServerEvent('economy:largeTransaction')
AddEventHandler('economy:largeTransaction', function(amount, fromPlayer, toPlayer)
    if amount >= 100000 then -- $100k or more
        TriggerEvent('zhora_announce:trigger', 
            string.format('Large transaction: $%s transferred between players', 
                ESX.Math.GroupDigits(amount)
            ), 
            'Economy Alert', 
            'bank'
        )
    end
end)

RegisterServerEvent('economy:companyBankrupt')
AddEventHandler('economy:companyBankrupt', function(companyName)
    TriggerEvent('zhora_announce:trigger', 
        string.format('%s has declared bankruptcy!', companyName), 
        'Business News', 
        'error'
    )
end)
```

### 3. Event System Integration
```lua
-- event_system.lua
local function startEvent(eventType, location)
    local eventMessages = {
        race = string.format('Street race starting at %s! Join now!', location),
        heist = string.format('Bank heist opportunity at %s - high risk, high reward!', location),
        delivery = string.format('Urgent delivery mission available at %s', location)
    }
    
    TriggerEvent('zhora_announce:trigger', 
        eventMessages[eventType] or 'Special event starting!', 
        'Event: ' .. eventType:upper(), 
        'announcement'
    )
end

local function endEvent(eventType, winner, reward)
    TriggerEvent('zhora_announce:trigger', 
        string.format('%s won the %s event and earned $%s!', 
            winner, eventType, ESX.Math.GroupDigits(reward)
        ), 
        'Event Complete', 
        'success'
    )
end
```

### 4. Admin System Integration
```lua
-- admin_system.lua
RegisterServerEvent('admin:playerBanned')
AddEventHandler('admin:playerBanned', function(playerName, adminName, reason)
    TriggerEvent('zhora_announce:trigger', 
        string.format('%s was banned by %s. Reason: %s', 
            playerName, adminName, reason
        ), 
        'Admin Action', 
        'error'
    )
end)

RegisterServerEvent('admin:serverMessage')
AddEventHandler('admin:serverMessage', function(message, adminName)
    TriggerEvent('zhora_announce:trigger', 
        message, 
        'Admin: ' .. adminName, 
        'important'
    )
end)
```

### 5. Automated Server Messages
```lua
-- auto_announcements.lua
local announcements = {
    {
        message = "Remember to follow server rules! Type /rules for more info",
        title = "Server Reminder",
        type = "info",
        interval = 300000 -- 5 minutes
    },
    {
        message = "Join our Discord server for updates and community events!",
        title = "Discord",
        type = "info", 
        interval = 600000 -- 10 minutes
    },
    {
        message = "Report any bugs or issues to staff members",
        title = "Bug Reports",
        type = "warning",
        interval = 900000 -- 15 minutes
    }
}

CreateThread(function()
    while true do
        for _, announcement in ipairs(announcements) do
            TriggerEvent('zhora_announce:trigger', 
                announcement.message, 
                announcement.title, 
                announcement.type
            )
            Wait(announcement.interval)
        end
    end
end)
```

## 🎨 Customization Guide

### Adding New Announcement Types

#### 1. Update Config
Add new types to `config.lua`:
```lua
Config.AnnounceSounds = {
    -- Existing types...
    
    police = {
        file = "police_siren.ogg",
        volume = 0.7
    },
    medical = {
        file = "medical_alert.ogg", 
        volume = 0.5
    },
    fire = {
        file = "fire_alarm.ogg",
        volume = 0.8
    }
}
```

#### 2. Update UI Styles
Add corresponding styles to `html/script.js`:
```javascript
const typeStyles = {
    // Existing styles...
    
    "police": { 
        iconClass: "fa-solid fa-shield-halved", 
        color: "#0066cc" 
    },
    "medical": { 
        iconClass: "fa-solid fa-briefcase-medical", 
        color: "#cc0000" 
    },
    "fire": { 
        iconClass: "fa-solid fa-fire-flame-curved", 
        color: "#ff6600" 
    }
}
```

#### 3. Add Commands (Optional)
Add new commands in `server.lua`:
```lua
registerAnnounceCommand('apolice', 'police', 'Police Alert', "No permission for police announcements.")
registerAnnounceCommand('amedical', 'medical', 'Medical Alert', "No permission for medical announcements.")
registerAnnounceCommand('afire', 'fire', 'Fire Department', "No permission for fire announcements.")
```

### Customizing Display Duration
```lua
-- In config.lua - change global default
Config.DefaultDisplayDuration = 6000  -- 6 seconds

-- Per announcement type (in your resource)
TriggerEvent('zhora_announce:trigger', 'Important message', 'Critical', 'important')
-- Note: Duration is controlled by the config, not per announcement
```

### Customizing Appearance

#### Colors and Styling
Edit `html/style.css` to customize appearance:
```css
/* Change container background */
#announcement-container {
    background-color: rgba(25, 25, 30, 0.95); /* Darker background */
    border: 2px solid rgba(255, 255, 255, 0.1); /* More visible border */
}

/* Change title color */
#announcement-title {
    color: #FFD700; /* Gold color */
    text-shadow: 0 0 10px rgba(255, 215, 0, 0.5); /* Glow effect */
}
```

#### Animation Timing
```css
/* Faster animations */
#announcement-container {
    transition: opacity 0.3s ease, transform 0.3s ease; /* Faster transitions */
}

#announcement-container.exiting {
    transition: opacity 0.5s ease-out, transform 0.5s ease-out; /* Faster exit */
}
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Commands Not Working
**Problem:** Admin commands return "no permission" error
**Solutions:**
- Check if your group is added to `adminGroups` in `server.lua`
- Verify ESX is loaded before zhora_announce
- Ensure you have the correct group assigned to your player
- Check server console for error messages

#### 2. Announcements Not Displaying
**Problem:** Announcements aren't showing up
**Solutions:**
- Verify the resource is started: `ensure zhora_announce`
- Check file paths in `fxmanifest.lua` are correct
- Ensure `Config.DefaultDisplayDuration` isn't set too low

#### 3. No Sound Playing
**Problem:** Announcements show but no sound plays
**Solutions:**
- Verify sound files exist in `html/sounds/` folder
- Check file format (`.ogg` recommended for best compatibility)
- Test with different volume levels in config
- Try using `/testannounce` command to test sounds

#### 4. Resource Loading Issues
**Problem:** Resource fails to start
**Solutions:**
- Check server console for specific error messages
- Ensure es_extended is loaded before zhora_announce
- Verify all dependencies are installed
- Check server.cfg for proper resource loading order

#### 5. Announcement Type Issues
**Problem:** Some announcement types don't work as expected
**Solutions:**
- Verify all type names are consistent between `config.lua` and server scripts
- Check that the type exists in your `Config.AnnounceSounds` configuration
- Test with `/testannounce [type]` to verify specific types work
- Ensure sound files exist for each configured type

### Debug Mode
Enable detailed logging by uncommenting debug lines in the code:
```lua
-- In server.lua, uncomment console.log lines
print("[zhora_announce] Debug: Command executed by " .. playerName)

-- In client.lua, uncomment debug prints  
print("[zhora_announce] Debug: Announcement received")
```

### Performance Optimization
```lua
-- Reduce announcement frequency to prevent spam
local lastAnnouncement = 0
local announceDelay = 5000 -- 5 seconds between announcements

function OptimizedAnnounce(message, title, type)
    local currentTime = GetGameTimer()
    if currentTime - lastAnnouncement >= announceDelay then
        TriggerEvent('zhora_announce:trigger', message, title, type)
        lastAnnouncement = currentTime
    end
end
```

## 📊 Configuration Reference

### Complete Config.lua Template
```lua
Config = {}

-- Display settings
Config.DefaultDisplayDuration = 4000  -- 4 seconds
Config.SoundPathInNUI = "sounds/"

-- Sound configuration
Config.AnnounceSounds = {
    defaultVolume = 0.4,
    
    info = { file = "info.ogg", volume = 0.3 },
    warning = { file = "warn.ogg", volume = 0.5 },
    important = { file = "error.ogg", volume = 0.6 },
    success = { file = "success.ogg", volume = 0.4 },
    error = { file = "success.ogg", volume = 0.6 },
    server = { file = "success.ogg", volume = 0.3 },
    announcement = { file = "success.ogg", volume = 0.4 },
    information = { file = "success.ogg", volume = 0.3 },
    datasaved = { file = "success.ogg", volume = 0.3 },
    bank = { file = "success.ogg", volume = 0.4 },
    characterstatus = { file = "success.ogg", volume = 0.5 }
}
```


## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **Issues:** Create an issue on GitHub
- **Discord:** zhorafps
- **Documentation:** Check this README and code comments

---

**Made with ❤️ for the FiveM community**

> **Note:** This announcement system is designed to enhance server communication and create a more engaging player experience. Use responsibly and ensure announcements add value to your server community.
