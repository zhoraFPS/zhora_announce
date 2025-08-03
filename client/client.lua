local announcementVisible = false
local announcementQueue = {}
local displayDuration = Config.DefaultDisplayDuration or 10000 -- Load from config
local cooldownActive = false
local currentAnnouncementTimerId = nil
local useNewTimerApi = Citizen.Timer ~= nil and type(Citizen.Timer.Create) == 'function' and type(Citizen.Timer.Delete) == 'function'

-- Citizen.CreateThread(function() -- Initialization check can be removed or minimized
--     Citizen.Wait(100)
--     if not Config or not Config.AnnounceSounds then
--         print("[zhora_announce_client] WARNING: Config.AnnounceSounds not loaded correctly.")
--     end
-- end)

local function ClearActiveTimer()
    if currentAnnouncementTimerId then
        if useNewTimerApi then
            Citizen.Timer.Delete(currentAnnouncementTimerId)
        elseif Citizen.ClearTimeout then
            Citizen.ClearTimeout(currentAnnouncementTimerId)
        end
        currentAnnouncementTimerId = nil
    end
end

local function CreateNewTimer(duration, callback)
    ClearActiveTimer()
    if useNewTimerApi then
        currentAnnouncementTimerId = Citizen.Timer.Create(duration, function()
            currentAnnouncementTimerId = nil
            callback()
        end)
    else
        currentAnnouncementTimerId = Citizen.SetTimeout(duration, function()
            currentAnnouncementTimerId = nil
            callback()
        end)
    end
end

function ShowAnnouncement(message, sender, type)
    local announcementType = type or "info"
    local soundFileToPlay = nil
    local soundVolumeToPlay = 0.5

    if Config and Config.AnnounceSounds then
        soundVolumeToPlay = Config.AnnounceSounds.defaultVolume or 0.5
        local soundSettings = Config.AnnounceSounds[announcementType]
        if soundSettings then
            if soundSettings.file then
                local soundPathPrefix = Config.SoundPathInNUI or "sounds/"
                soundFileToPlay = soundPathPrefix .. soundSettings.file
            end
            if soundSettings.volume ~= nil then
                soundVolumeToPlay = soundSettings.volume
            end
        end
    end

    SendNUIMessage({
        type = "showAnnouncement",
        text = message,
        sender = sender or "Server",
        announcementType = announcementType,
        duration = displayDuration,
        soundFile = soundFileToPlay,
        volume = soundVolumeToPlay
    })
    announcementVisible = true

    CreateNewTimer(displayDuration, function()
        SendNUIMessage({ type = "hideAnnouncement" })
        announcementVisible = false
        cooldownActive = true
        CreateNewTimer(600, function()
            cooldownActive = false
            if #announcementQueue > 0 then
                local nextAnn = table.remove(announcementQueue, 1)
                ShowAnnouncement(nextAnn.message, nextAnn.sender, nextAnn.type)
            end
        end)
    end)
end

RegisterNetEvent('zhora_announce:show')
AddEventHandler('zhora_announce:show', function(message, sender, type)
    local announcementType = type or "info"
    if not message or message == "" then return end
    local announcementData = { message = message, sender = sender, type = announcementType }

    if announcementVisible or cooldownActive or #announcementQueue > 0 then
        table.insert(announcementQueue, announcementData)
        SendNUIMessage({ type = "queuedAnnouncement", count = #announcementQueue })
    else
        ShowAnnouncement(announcementData.message, announcementData.sender, announcementData.type)
    end
end)

print("[zhora_announce] Client script loaded.")