local _, WoWHACv4 = ...

local ConROProvider = WoWHACv4.Provider:extend("ConROProvider")

function ConROProvider:init()
    WoWHACv4:Log("Supplier found: ConRO.")
    if ConROWindow and ConROWindow.fontkey then
        local Keybind = ConROWindow.fontkey
        local last = Keybind:GetText()
        WoWHACv4:SecureHook(Keybind, "SetText", function(_, txt)
            if txt ~= last then
                last = txt
                self:Fire(txt)
            end
        end)
    end
end

WoWHACv4.providers["ConRO"] = ConROProvider