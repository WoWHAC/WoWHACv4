local addonName, WoWHACv4 = ...
WoWHACv4 = LibStub("AceAddon-3.0"):NewAddon(WoWHACv4, addonName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

WoWHACv4.providers = {}

--[[===== LOGGER START =====]]
WoWHACv4.debug = false

function WoWHACv4:Debug(message)
    if WoWHACv4.debug then
        self:Log(message)
    end
end

function WoWHACv4:Log(message)
    self:Print("[WoWHACv4] " .. message)
end
--[[===== LOGGER END =====]]

--[[===== LIFECYCLE START =====]]
function WoWHACv4:OnInitialize()
    --  nothing to do, but can be used by external lua via AceHook so we should keep it
end

function WoWHACv4:OnEnable()
    self:Log("Initializing...")
    self:SendMessage("WOWHACV4_ENABLE")
end

function WoWHACv4:OnDisable()
    --  nothing to do, but can be used by external lua via AceHook so we should keep it
end
--[[===== LIFECYCLE END =====]]