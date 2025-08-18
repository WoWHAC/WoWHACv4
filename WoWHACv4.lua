WoWHACv4 = LibStub("AceAddon-3.0"):NewAddon("WoWHACv4", "AceConsole-3.0", "AceEvent-3.0")

local weakAurasStatus = false
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local f = CreateFrame("Frame","TestBorder",UIParent)
f:SetSize(2,2)
f:SetPoint("TOPLEFT")
f:SetFrameStrata( "TOOLTIP" )

WoWHACv4.db = LibStub('AceDB-3.0'):New("MaxDpsCooldownsDB", {
    profile = {
		points = {"CENTER","UIParent","CENTER",100,100},
		cds = false,
		size  = {40, 20},
		text  = "CDs",
	}
})

function WoWHACv4:CreateButton()
  if WoWHACv4.btn then return end

  local parent = (PARENT_NAME and _G[PARENT_NAME]) or UIParent
  local w, h   = WoWHACv4.db.profile.size[1], WoWHACv4.db.profile.size[2]

  local btn = CreateFrame("Button", "MaxDpsCooldowns_Button", parent, "UIPanelButtonTemplate")
  btn:SetSize(w, h)
  btn:SetPoint("CENTER")
  btn:SetText(WoWHACv4.db.profile.text)
  btn:SetClampedToScreen(true)

  -- Перетаскивание и сохранение позиции
  btn:SetMovable(true)
  btn:EnableMouse(true)
  btn:RegisterForDrag("LeftButton")
  btn:SetScript("OnDragStart", btn.StartMoving)
  btn:SetScript("OnDragStop", function(b)
    b:StopMovingOrSizing()
    local p, rel, rp, x, y = b:GetPoint()
    WoWHACv4.db.profile.point = {p, rel and rel:GetName() or "UIParent", rp, x, y}
  end)

  -- Переключаем ТОЛЬКО цвет текста
  local fs = btn.Text or btn:GetFontString()
  btn:SetScript("OnClick", function()
    WoWHACv4.db.profile.cds = not WoWHACv4.db.profile.cds
    WoWHACv4:UpdateTextColor()
  end)

  WoWHACv4.btn, WoWHACv4.fs = btn, fs
end

function WoWHACv4:ApplyPosition()
  local p = WoWHACv4.db.profile.points
  local rel = _G[p[2]] or UIParent
  WoWHACv4.btn:ClearAllPoints()
  WoWHACv4.btn:SetPoint(p[1], rel, p[3], p[4], p[5])
end

function WoWHACv4:UpdateTextColor()
  local fs = WoWHACv4.fs or (WoWHACv4.btn and (WoWHACv4.btn.Text or WoWHACv4.btn:GetFontString()))
  if not fs then return end
  if WoWHACv4.db.profile.cds then fs:SetTextColor(0,1,0) else fs:SetTextColor(1,0,0) end
end


f.back = f:CreateTexture(nil,"BACKGROUND",nil,-1)
f.back:SetAllPoints(f)
f.back:SetTexture(255/255,100,100)

f:RegisterEvent("UNIT_SPELLCAST_SENT")
f:RegisterEvent("UNIT_SPELLCAST_START")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")

DEFAULT_CHAT_FRAME:AddMessage("WoWHACv4: Waiting for a response from WeakAuras")
local function HookWA()
    if not WeakAuras or not WeakAuras.ScanEvents then return end
	DEFAULT_CHAT_FRAME:AddMessage("WoWHACv4: WeakAuras detected, waiting for the supplier")
	if IsAddOnLoaded("Hekili") then	
		DEFAULT_CHAT_FRAME:AddMessage("WoWHACv4: Selected supplier - Hekili")
		hooksecurefunc(WeakAuras, "ScanEvents", function(event, _, _, _, _, arg5)
			if event == "HEKILI_RECOMMENDATION_UPDATE" then
				if arg5 then
					if arg5[1] then
						if arg5[1].keybind then
								Process(arg5[1].keybind)
						end
					end
				end
			end
		end)
	elseif IsAddOnLoaded("ConRO") then
		DEFAULT_CHAT_FRAME:AddMessage("WoWHACv4: Selected supplier - ConRO")
        if ConROWindow and ConROWindow.fontkey then
			local Keybind = ConROWindow.fontkey
			local last = Keybind:GetText()
			hooksecurefunc(Keybind, "SetText", function(self, txt)
				if txt ~= last then
					last = txt
					Process(txt)
				end
			end)
        end
	elseif IsAddOnLoaded("HeroRotation") then
		DEFAULT_CHAT_FRAME:AddMessage("WoWHACv4: Selected supplier - HeroRotation")
		local Keybind = HeroRotation.MainIconFrame.Keybind
		local last = Keybind:GetText()
		hooksecurefunc(Keybind, "SetText", function(self, txt)
			local burst = HeroRotation.SmallIconFrame.Icon[1].Keybind
			if burst and burst:IsVisible() then
				local burstHotkey = burst:GetText()
				if burstHotkey and burstHotkey ~= "" then
					txt = burstHotkey
				end
			end
			if txt ~= last then
				last = txt
				Process(txt)
			end
		end)
	elseif IsAddOnLoaded("MaxDps") then
		DEFAULT_CHAT_FRAME:AddMessage("WoWHACv4: Selected supplier - MaxDps")
		
		WoWHACv4:CreateButton()
		WoWHACv4:ApplyPosition()
		WoWHACv4:UpdateTextColor()
		
		hooksecurefunc(WeakAuras, "ScanEvents", function(event, flags)
			if event == "MAXDPS_COOLDOWN_UPDATE" then
				if true then
					for _, frame in pairs(MaxDps.Frames) do
						if frame and frame:IsVisible() then
							print(frame.ovType)
							if WoWHACv4.db.profile.cds or frame.ovType ~= "cooldown" then
								local button = frame:GetParent()
								local keybind = string.upper(button.HotKey:GetText()):gsub("S%-", "S")
											:gsub("C%-", "C")
											:gsub("A%-", "A")
								Process(keybind)
								return
							end
						end
					end
					return
				end
			end
		end)
	end
end

if IsAddOnLoaded("WeakAuras") then
    HookWA()
else
    local weakAurasFrame = CreateFrame("Frame")
    weakAurasFrame:RegisterEvent("ADDON_LOADED")
    weakAurasFrame:SetScript("OnEvent", function(_, _, name)
        if name == "WeakAuras" then
            HookWA()
            weakAurasFrame:UnregisterEvent("ADDON_LOADED")
        end
    end)
end

local function IsGCDActive()
    local spellCooldownInfo = C_Spell.GetSpellCooldown(61304)
    if spellCooldownInfo.startTime == 0 then return false end
    return (spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime()) > 0
end

local red = 0
local green = 0
local blue = 0

local updateInterval = 0.1
local timeSinceLastUpdate = 0

f:SetScript("OnUpdate", function(self, elapsed)
      timeSinceLastUpdate = timeSinceLastUpdate + elapsed
      if timeSinceLastUpdate >= updateInterval then
        timeSinceLastUpdate = 0
         
        local casting = UnitCastingInfo("player") ~= nil
        local channeling = UnitChannelInfo("player") ~= nil
        local gcdActive = IsGCDActive()
         
        if casting or channeling or gcdActive then
		   f.back:SetColorTexture(0, 0, 0)
           return
        end
		 
		f.back:SetColorTexture(red, green, blue)
      end
end)


f:SetScript("OnEvent", function(_, event, unit, _, spellID)
	if unit ~= "player" then return end
	f.back:SetColorTexture(0, 0, 0)
end)

function Process(keyBind)
    keyBind = normalizeModifiers(keyBind)
    red = getRed(keyBind)
    green = getGreen(keyBind)
    blue = getBlue(keyBind)
end

function normalizeModifiers(keyBind)
	if keyBind == nil then
		return nil
	end
    keyBind = keyBind:upper()
    local result = ""
    local withAlt = false
    local withCtrl = false
    local withShift = false
    if keyBind:len() > 1 and keyBind:match("^A") ~= nil then
        withAlt = true
        keyBind = keyBind:sub(2)
    end
    if keyBind:len() > 1 and keyBind:match("^C") ~= nil then
        withCtrl = true
        keyBind = keyBind:sub(2)
    end
    if keyBind:len() > 1 and keyBind:match("^S") ~= nil then
        withShift = true
        keyBind = keyBind:sub(2)
    end
    if withShift then
        result = "SHIFT\-" .. result
    end
    if withCtrl then
        result = "CTRL\-" .. result
    end
    if withAlt then
        result = "ALT\-" .. result
    end
    return result .. keyBind
end

function getRed(keyBind)
    local red = 0
	if keyBind == nil then
		return red
	end
    if keyBind:match('ALT.CTRL.SHIFT.') ~= nil then
        red = 70/255
    elseif keyBind:match("ALT.CTRL.") ~= nil then
        red = 60/255
    elseif keyBind:match("ALT.SHIFT.") ~= nil then
        red = 50/255
    elseif keyBind:match("ALT.") ~= nil then
        red = 40/255
    elseif keyBind:match("CTRL.SHIFT.") ~= nil then
        red = 30/255
    elseif keyBind:match("CTRL.") ~= nil then
        red = 20/255
    elseif keyBind:match("SHIFT.") ~= nil then
        red = 10/255
    end
    return red
end

-- ` = 96
-- 1 = 49
-- 2 = 50
-- 3 = 51
-- 4 = 52
-- 5 = 53
-- 6 = 54
-- 7 = 55
-- 8 = 56
-- 9 = 57
-- 0 = 48
-- - = 45
-- = = 61
-- Q = 81
-- W = 87
-- E = 69
-- R = 82
-- T = 84
-- Y = 89
-- U = 85
-- I = 73
-- O = 79
-- P = 80
-- [ = 91
-- ] = 93
-- A = 65
-- S = 83
-- D = 68
-- F = 70
-- G = 71
-- H = 72
-- J = 74
-- K = 75
-- L = 76
-- ; = 59
-- ' = 39
-- Z = 90
-- X = 88
-- C = 67
-- V = 86
-- B = 66
-- N = 78
-- M = 77
-- , = 44
-- . = 46
-- / = 47
-- F1 = 149
-- F2 = 150
-- F3 = 151
-- F4 = 152
-- F5 = 153
-- F6 = 154
-- F7 = 155
-- F8 = 156
-- F9 = 157
-- F10 = 158
-- F11 = 159
-- F12 = 160
function getGreen(keyBind)
    local green = 0
	if keyBind == nil then
		return green
	end
    keyBind = keyBind:gsub("ALT.", ""):gsub("CTRL.", ""):gsub("SHIFT.", "")
    if keyBind:len() == 1 then
        green = keyBind:byte() .. ""
        green = green * 1
        green = green /255
    elseif keyBind:match("^F") ~= nil then
        if keyBind:match("^F12$") ~= nil then
            green = 160/255
        elseif keyBind:match("^F11$") ~= nil then
            green = 159/255
        elseif keyBind:match("^F10$") ~= nil then
            green = 158/255
        elseif keyBind:match("^F9$") ~= nil then
            green = 157/255
        elseif keyBind:match("^F8$") ~= nil then
            green = 156/255
        elseif keyBind:match("^F7$") ~= nil then
            green = 155/255
        elseif keyBind:match("^F6$") ~= nil then
            green = 154/255
        elseif keyBind:match("^F5$") ~= nil then
            green = 153/255
        elseif keyBind:match("^F4$") ~= nil then
            green = 152/255
        elseif keyBind:match("^F3$") ~= nil then
            green = 151/255
        elseif keyBind:match("^F2$") ~= nil then
            green = 150/255
        elseif keyBind:match("^F1$") ~= nil then
            green = 149/255
        end
    end
    return green
end

function getBlue(keyBind)
    return getRed(keyBind)
end
