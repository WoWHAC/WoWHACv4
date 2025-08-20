local _, WoWHACv4 = ...

local ConROProvider = WoWHACv4.Provider:extend("ConROProvider")
function ConROProvider:init()
    WoWHACv4:Log("Supplier found: ConRO.")
    --if ConROWindow and ConROWindow.fontkey then
    --    local Keybind = ConROWindow.fontkey
    --    local last = Keybind:GetText()
    --    WoWHACv4:SecureHook(Keybind, "SetText", function(_, txt)
    --        if txt ~= last then
    --            last = txt
    --            self:Fire(txt, ConRO.Spell)
    --        end
    --    end)
    --end
    --if ConROWindow2 and ConROWindow2.fontkey then
    --    local Keybind = ConROWindow2.fontkey
    --    WoWHACv4:SecureHook(Keybind, "SetText", function(_, txt)
    --        self:FireNext(txt, ConRO.SuggestedSpells[2])
    --    end)
    --end
end

function ConROProvider:GetCurrent()
    return ConRO:improvedGetBindingText(ConRO:FindKeybinding(ConRO.Spell))
end

function ConROProvider:GetCurrentId()
    return ConRO.Spell
end

function ConROProvider:GetNext()
    return ConRO:improvedGetBindingText(ConRO:FindKeybinding(ConRO.SuggestedSpells[2]))
end

function ConROProvider:GetNextId()
    return ConRO.SuggestedSpells[2]
end

WoWHACv4.providers["ConRO"] = ConROProvider