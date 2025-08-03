-- zhora_announce/server.lua

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Your admin groups configuration
local adminGroups = {
    ['admin'] = true,
    ['superadmin'] = true,
    ['moderator'] = true
    -- Add your admin groups here
}

-- Function to send announcements to clients
local function dispatchAnnouncementToClients(message, title, type)
    local annTitle = title or "Server Announcement"
    local annType = type or "info"

    if message and message ~= "" then
        TriggerClientEvent('zhora_announce:show', -1, message, annTitle, annType) -- -1 sends to all clients
        -- Server console logging is now centralized here
    else
        print("[zhora_announce] Error: Attempted to send empty announcement.")
    end
end

-- Function for command execution (internal logic) - simplified without pipe parsing
local function handleAdminAnnounceCommand(sourcePlayerId, message, type, defaultTitle)
    local xPlayer = ESX.GetPlayerFromId(sourcePlayerId)
    local playerName = xPlayer and GetPlayerName(sourcePlayerId) or "SYSTEM"
    local playerIdentifier = xPlayer and xPlayer.identifier or "system_command"
    local annType = type or "info"
    local title = defaultTitle or "Announcement"

    if message and message ~= "" then
        dispatchAnnouncementToClients(message, title, annType)
        print(("[zhora_announce] CMD ANNOUNCE - Type: %s | Admin: '%s' (%s) | Title: '%s' | Message: %s"):format(annType, playerName, playerIdentifier, title, message))
    else
        if sourcePlayerId and sourcePlayerId > 0 then
             TriggerClientEvent('chat:addMessage', sourcePlayerId, {
                args = {"^1zhora", "Please enter a message for the announcement."}
            })
        end
    end
end

-- Helper function for command registration with default titles
local function registerAnnounceCommand(commandName, defaultType, defaultTitle, permissionMessage)
    RegisterCommand(commandName, function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        local message = table.concat(args, " ")

        if xPlayer and adminGroups[xPlayer.getGroup()] then
            handleAdminAnnounceCommand(source, message, defaultType, defaultTitle)
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = {"^1zhora", permissionMessage or "You don't have permission to use this command."}
            })
            if xPlayer then
                print(("[zhora_announce] ACCESS DENIED (CMD): Player '%s' (%s) tried to use /%s."):format(GetPlayerName(source), xPlayer.identifier, commandName))
            end
        end
    end, false)
end

-- /announce command with title support
RegisterCommand('announce', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local announceType = "info"
    local message = ""

    -- Type detection (optional, if first parameter is a known type)
    if args[1] and (Config.AnnounceSounds[args[1]:lower()] or args[1]:lower() == "info" or args[1]:lower() == "warning" or args[1]:lower() == "wichtig") then
        announceType = args[1]:lower()
        table.remove(args, 1)
    end
    message = table.concat(args, " ")

    if xPlayer and adminGroups[xPlayer.getGroup()] then
        handleAdminAnnounceCommand(source, message, announceType, "Server Announcement")
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^1zhora", "You don't have permission to use this command."}
        })
        if xPlayer then
             print(("[zhora_announce] ACCESS DENIED (CMD): Player '%s' (%s) tried to use /announce."):format(GetPlayerName(source), xPlayer.identifier))
        end
    end
end, false)

-- Register specific commands with default titles
registerAnnounceCommand('ainfo', 'info', 'Information', "No permission for info announcements.")
registerAnnounceCommand('awarn', 'warning', 'Warning', "No permission for warning announcements.")
registerAnnounceCommand('awichtig', 'wichtig', 'Important', "No permission for important announcements.")
registerAnnounceCommand('asuccess', 'success', 'Success', "No permission for success announcements.")
registerAnnounceCommand('aerror', 'error', 'Error', "No permission for error announcements.")
registerAnnounceCommand('aserver', 'server', 'Server Notice', "No permission for server announcements.")

-- Additional themed commands with specific titles
registerAnnounceCommand('arestart', 'warning', 'Server Restart', "No permission for restart announcements.")
registerAnnounceCommand('aevent', 'info', 'Event Notification', "No permission for event announcements.")
registerAnnounceCommand('aupdate', 'info', 'Update Notice', "No permission for update announcements.")
registerAnnounceCommand('amaintenance', 'warning', 'Maintenance', "No permission for maintenance announcements.")

-- Helper function for custom title commands
local function registerCustomTitleCommand(commandName, defaultType, permissionMessage)
    RegisterCommand(commandName, function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        
        if not xPlayer or not adminGroups[xPlayer.getGroup()] then
            TriggerClientEvent('chat:addMessage', source, {
                args = {"^1zhora", permissionMessage or "You don't have permission to use this command."}
            })
            if xPlayer then
                print(("[zhora_announce] ACCESS DENIED (CMD): Player '%s' (%s) tried to use /%s."):format(GetPlayerName(source), xPlayer.identifier, commandName))
            end
            return
        end

        if #args < 2 then
            TriggerClientEvent('chat:addMessage', source, {
                args = {"^1zhora", "Usage: /" .. commandName .. " [title] [message]"}
            })
            return
        end

        -- First argument is the title, rest is the message
        local customTitle = args[1]
        table.remove(args, 1)
        local message = table.concat(args, " ")

        if message and message ~= "" and customTitle and customTitle ~= "" then
            dispatchAnnouncementToClients(message, customTitle, defaultType)
            local playerName = GetPlayerName(source)
            local playerIdentifier = xPlayer.identifier
            print(("[zhora_announce] CUSTOM TITLE CMD - Type: %s | Admin: '%s' (%s) | Title: '%s' | Message: %s"):format(defaultType, playerName, playerIdentifier, customTitle, message))
            
            TriggerClientEvent('chat:addMessage', source, {
                args = {"^2zhora", string.format("Custom announcement sent! Title: '%s'", customTitle)}
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = {"^1zhora", "Please provide both a title and a message."}
            })
        end
    end, false)
end

-- Custom title commands - first argument is title, rest is message
registerCustomTitleCommand('titleinfo', 'info', "No permission for custom info announcements.")
registerCustomTitleCommand('titlewarn', 'warning', "No permission for custom warning announcements.")
registerCustomTitleCommand('titlewichtig', 'wichtig', "No permission for custom important announcements.")
registerCustomTitleCommand('titlesuccess', 'success', "No permission for custom success announcements.")
registerCustomTitleCommand('titleerror', 'error', "No permission for custom error announcements.")
registerCustomTitleCommand('titleserver', 'server', "No permission for custom server announcements.")

-- Alternative shorter names for custom title commands
registerCustomTitleCommand('cinfo', 'info', "No permission for custom info announcements.")
registerCustomTitleCommand('cwarn', 'warning', "No permission for custom warning announcements.")
registerCustomTitleCommand('cwichtig', 'wichtig', "No permission for custom important announcements.")
registerCustomTitleCommand('csuccess', 'success', "No permission for custom success announcements.")
registerCustomTitleCommand('cerror', 'error', "No permission for custom error announcements.")
registerCustomTitleCommand('cserver', 'server', "No permission for custom server announcements.")

-- Universal custom announce command with type detection
RegisterCommand('cannounce', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or not adminGroups[xPlayer.getGroup()] then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^1zhora", "You don't have permission to use this command."}
        })
        return
    end

    if #args < 3 then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^1zhora", "Usage: /cannounce [type] [title] [message]"}
        })
        return
    end

    local announceType = args[1]:lower()
    local customTitle = args[2]
    table.remove(args, 1) -- Remove type
    table.remove(args, 1) -- Remove title
    local message = table.concat(args, " ")

    -- Validate type
    if not Config.AnnounceSounds[announceType] and announceType ~= "info" and announceType ~= "warning" and announceType ~= "wichtig" then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^1zhora", "Invalid type. Available types: info, warning, wichtig, success, error, server"}
        })
        return
    end

    if message and message ~= "" and customTitle and customTitle ~= "" then
        dispatchAnnouncementToClients(message, customTitle, announceType)
        local playerName = GetPlayerName(source)
        local playerIdentifier = xPlayer.identifier
        print(("[zhora_announce] CUSTOM ANNOUNCE CMD - Type: %s | Admin: '%s' (%s) | Title: '%s' | Message: %s"):format(announceType, playerName, playerIdentifier, customTitle, message))
        
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^2zhora", string.format("Custom announcement sent! Type: %s, Title: '%s'", announceType, customTitle)}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^1zhora", "Please provide type, title and message."}
        })
    end
end, false)

-- Test command for admins to test all announcement types
RegisterCommand('testannounce', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or not adminGroups[xPlayer.getGroup()] then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^1zhora", "You don't have permission to use this command."}
        })
        return
    end

    if args[1] and args[1]:lower() == "all" then
        -- Collect all available announce types from the config
        local availableTypes = {}
        if Config and Config.AnnounceSounds then
            for typeName, _ in pairs(Config.AnnounceSounds) do
                if typeName ~= "defaultVolume" then -- Skip defaultVolume since it's not a type
                    table.insert(availableTypes, typeName)
                end
            end
        end
        
        -- Sort types alphabetically for consistent order
        table.sort(availableTypes)
        
        -- Create an announcement for each type
        for i, announceType in ipairs(availableTypes) do
            local testMessage = string.format("This is a test message for the %s announcement type. Everything is working correctly!", announceType)
            local testTitle = string.format("Test %s", announceType:upper())
            
            -- Add a small delay between announcements
            Citizen.SetTimeout((i-1) * 6000, function()
                dispatchAnnouncementToClients(testMessage, testTitle, announceType)
            end)
        end
        
        print(string.format("[testannounce] %d announce types will be played in sequence for %s:", #availableTypes, GetPlayerName(source)))
        for i, typeName in ipairs(availableTypes) do
            print(string.format("  %d. %s", i, typeName))
        end
        
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^2zhora", string.format("Testing %d announcement types in sequence...", #availableTypes)}
        })
        
    else
        -- Original behavior: Single test with specific type
        local testType = args[1] or "info"
        local testMessage = table.concat(args, " ", 2)
        if testMessage == nil or testMessage == "" then
            testMessage = "This is a test announcement for the " .. testType .. " type. The system is working correctly!"
        end
        local testTitle = "Test " .. testType:upper()
        
        dispatchAnnouncementToClients(testMessage, testTitle, testType)
        
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^2zhora", "Test announcement sent with title: " .. testTitle}
        })
    end
end, false)

-- Event handler for announcements from other server scripts (with title support)
RegisterNetEvent('zhora_announce:trigger')
AddEventHandler('zhora_announce:trigger', function(message, title, type)
    local eventSource = source -- The source of the event

    -- If 'source' is empty ("") or 0, the event was triggered server-side.
    -- A positive value for 'source' would be a client network ID.
    if eventSource == "" or eventSource == 0 or eventSource == nil then
        -- Event was triggered by a server script (e.g. ns_giveaway) -> treat as trusted
        local annTitle = title or "System Event"
        local annType = type or "info"

        if message and message ~= "" then
            dispatchAnnouncementToClients(message, annTitle, annType)
            print(("[zhora_announce] EVENT ANNOUNCE (Server-Triggered) - Type: %s | Title: '%s' | Message: %s"):format(annType, annTitle, message))
        else
            print("[zhora_announce] Error: Empty event announcement (Server-Triggered) received.")
        end
    else
        -- Event was triggered by a client. Permission check is REQUIRED here!
        local xPlayer = ESX.GetPlayerFromId(eventSource)
        if xPlayer and adminGroups[xPlayer.getGroup()] then
            -- An admin client triggered the event
            local annTitle = title or "Admin Announcement"
            local annType = type or "info"
            if message and message ~= "" then
                dispatchAnnouncementToClients(message, annTitle, annType)
                print(("[zhora_announce] EVENT ANNOUNCE (Admin-Client %s) - Type: %s | Title: '%s' | Message: %s"):format(eventSource, annType, annTitle, message))
            else
                print("[zhora_announce] Error: Empty event announcement (Admin-Client %s) received."):format(eventSource)
            end
        else
            -- Unauthorized client
            print(("[zhora_announce] SECURITY WARNING: Unauthorized client (ID: %s, Name: %s) attempted to trigger 'zhora_announce:trigger'. Blocked."):format(tostring(eventSource), GetPlayerName(eventSource) or "Unknown"))
            -- Optional: DropPlayer(eventSource, "Unauthorized event trigger attempt.")
        end
    end
end)

-- Exports for other resources with title support
function TriggerAnnounce(message, title, type)
    local annTitle = title or "System Announcement"
    local annType = type or "info"
    if message and message ~= "" then
        dispatchAnnouncementToClients(message, annTitle, annType)
        print(("[zhora_announce] EXPORT ANNOUNCE - Type: %s | Title: '%s' | Message: %s"):format(annType, annTitle, message))
    end
end

function TriggerInfoAnnounce(message, title) TriggerAnnounce(message, title or "Information", "info") end
function TriggerWarningAnnounce(message, title) TriggerAnnounce(message, title or "Warning", "warning") end
function TriggerWichtigAnnounce(message, title) TriggerAnnounce(message, title or "Important", "wichtig") end
function TriggerSuccessAnnounce(message, title) TriggerAnnounce(message, title or "Success", "success") end
function TriggerErrorAnnounce(message, title) TriggerAnnounce(message, title or "Error", "error") end
function TriggerServerAnnounce(message, title) TriggerAnnounce(message, title or "Server Notice", "server") end

print("[zhora_announce] Server script loaded. Event handler 'zhora_announce:trigger' is active.")