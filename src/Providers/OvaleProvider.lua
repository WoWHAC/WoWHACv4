local _, WoWHACv5 = ...

local OvaleProvider = WoWHACv5.Provider:extend("OvaleProvider")

local currentHotkey;

function OvaleProvider:init()
    WoWHACv5:Log("Supplier found: Ovale.")
    local KEY_REPLACEMENTS = {
        ["ALT%-"] = "A",
        ["CTRL%-"] = "C",
        ["SHIFT%-"] = "S",
        ["NUMPAD"] = "N",
        ["PLUS"] = "+",
        ["MINUS"] = "-",
        ["MULTIPLY"] = "*",
        ["DIVIDE"] = "/",
    }
    function Ovale:ChercherShortcut(slot)
        local name
        if slot > 12 and Bartender4 then
            name = "CLICK BT4Button" .. slot .. ":LeftButton"
        else
            if slot <= 24 or slot > 72 then
                name = "ACTIONBUTTON" .. (((slot - 1) % 12) + 1)
            elseif slot <= 36 then
                name = "MULTIACTIONBAR3BUTTON" .. (slot - 24)
            elseif slot <= 48 then
                name = "MULTIACTIONBAR4BUTTON" .. (slot - 36)
            elseif slot <= 60 then
                name = "MULTIACTIONBAR2BUTTON" .. (slot - 48)
            else
                name = "MULTIACTIONBAR1BUTTON" .. (slot - 60)
            end
        end
        local key = name and GetBindingKey(name)
        if key then
            key = key:upper():gsub("%s+", "")
            -- заменить всё по словарю
            for pat, repl in pairs(KEY_REPLACEMENTS) do
                key = key:gsub(pat, repl)
            end
        end
        return key
    end
    WoWHACv5.ToggleBurstFrame:Show()
    local function GetSpellIdByName(name)
        return name and Ovale:GetSpellIdByName(name) or nil
    end

    local itemCache = {}
    local _GetItemSpell = GetItemSpell
    function GetItemSpell(id, ...)
        local name = _GetItemSpell(id, ...)
        if name then
            itemCache[name] = id
        end
        return name
    end

    local function GetItemIdByName(name)
        return name and itemCache[name] or nil
    end

    local function IsReady(start, duration)
        return (start or 0) <= 0 or ((start + (duration or 0) - GetTime()) <= 0)
    end
    local function NormalizeSuggestion(spell)
        if not spell then
            return
        end

        local spellName = spell.spellName
        if not spellName then
            return
        end

        local spellId = GetSpellIdByName(spellName)
        if spellId then
            local cd = C_Spell.GetSpellCooldown(spellId)
            if IsReady(cd.startTime, cd.duration) then
                return spell.icons[1].shortcut:GetText()
            end
        else
            local itemId = GetItemIdByName(spellName)
            if itemId then
                local start, duration = GetItemCooldown(itemId)
                if IsReady(start, duration) then
                    return spell.icons[1].shortcut:GetText()
                end
            end
        end
    end
    WoWHACv5:SecureHook(Ovale.frame, "OnUpdate", function(frame)
        local actions = frame.actions
        local spell
        local order = { 4, 3, (WoWHACv5.burst and 2 or 6), 1 }
        for _, idx in ipairs(order) do
            spell = NormalizeSuggestion(actions[idx])
            if spell then
                break
            end
        end

        currentHotkey = spell
    end)
end
function OvaleProvider:GetCurrentHotKey()
    return currentHotkey
end

function OvaleProvider:GetCurrentId()
    return 0
end

WoWHACv5.providers["Ovale"] = OvaleProvider