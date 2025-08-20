if type(C_AddOns) ~= "table" then
    C_AddOns = {}
end

if type(C_AddOns.IsAddOnLoaded) ~= "function" then
    function C_AddOns.IsAddOnLoaded(name)
        -- В старых клиентах была глобальная функция IsAddOnLoaded
        if type(_G.IsAddOnLoaded) == "function" then
            local ok, loaded = pcall(_G.IsAddOnLoaded, name)
            if ok and loaded ~= nil then
                return loaded
            end
        end

        -- Альтернативная проверка через список аддонов
        if type(GetNumAddOns) == "function" and type(GetAddOnInfo) == "function" then
            for i = 1, GetNumAddOns() do
                local addonName, _, _, enabled = GetAddOnInfo(i)
                if addonName == name then
                    return not not enabled
                end
            end
        end

        -- Если вообще ничего не сработало
        return false
    end
end
