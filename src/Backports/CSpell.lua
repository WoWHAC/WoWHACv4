if type(C_Spell) ~= "table" then
    C_Spell = {}
end
if type(C_Spell.GetSpellCooldown) ~= "function" then
    C_Spell.GetSpellCooldown = function(spellId)
        local start, duration, enabled = GetSpellCooldown(spellId)
        return {
            startTime = start or 0,
            duration = duration or 0,
            isEnabled = (enabled == 1 or enabled == true)
        }
    end
end