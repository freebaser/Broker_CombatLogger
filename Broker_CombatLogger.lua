local ADDON_NAME, ns = ...

local autolog = false -- Automatically enable logging for zones below
local autoDisable = true -- Always disable logging if not in an autolog zone
local Z = {
    [752] = true, -- Baradin Hold
    [754] = true, -- Blackwing Descent
    [758] = true, -- The Bastion of Twilight
    [773] = true, -- Throne of the Four Winds
    -- [MapAreaID] = true,
}

local L = ns.Locale

local enableIcon = "Interface\\CURSOR\\Attack"
local disableIcon = "Interface\\CURSOR\\UnableAttack"

local frame = CreateFrame('Frame', nil, ChatFrame1EditBox)
frame:SetScript('OnHide', function(self)
    if LoggingCombat() then
        ns.broker.icon = enableIcon
        ns.broker.text = "|cff00FF00"..L["Enabled"].."|r"
    else
        ns.broker.icon = disableIcon
        ns.broker.text = L["Disabled"]
    end
end)

ns.broker = LibStub("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, {
    label = "CombatLogger",
    type = "data source",
    icon = disableIcon,
    text = L["Disabled"],
    OnClick = function(self, button)
        if button == "LeftButton" then
            if LoggingCombat() then
                ns:Disable()
            else
                ns:Enable()
            end
        end
    end,
    OnTooltipShow = function(tip)
        if tip and tip.AddLine then
            tip:AddLine("|cffFFFF00CombatLogger|r")
            tip:AddLine(("|cffFF00FF%s|r |cffFFFFFF%s|r"):format(L["Left-click"], L["to toggle combat logging."]))
        end
    end,
})

function ns:Enable()
    LoggingCombat(true)
    ns.broker.icon = enableIcon
    ns.broker.text = "|cff00FF00"..L["Enabled"].."|r"
    print(COMBATLOGENABLED)
end

function ns:Disable()
    LoggingCombat(false)
    ns.broker.icon = disableIcon
    ns.broker.text = L["Disabled"]
    print(COMBATLOGDISABLED)
end

local f = CreateFrame("frame")
f:SetScript("OnEvent", function(self, event, ...) if ns[event] then return ns[event](ns, event, ...) end end)
function ns:RegisterEvent(...) for i=1,select("#", ...) do f:RegisterEvent((select(i, ...))) end end
function ns:UnregisterEvent(...) for i=1,select("#", ...) do f:UnregisterEvent((select(i, ...))) end end

local zoneFrame = CreateFrame"Frame"
local delaytimer = 0
local zoneDelay = function(self, elapsed)
    delaytimer = delaytimer + elapsed

    if delaytimer < 5 then return end

    if IsInInstance() then
        SetMapToCurrentZone()
        local zone = GetCurrentMapAreaID()

        --print(GetInstanceInfo().." "..zone.." Logger")

        if Z[zone] and not LoggingCombat() then
            ns:Enable()
        end
    elseif autoDisable and LoggingCombat() then
        ns:Disable()
    end

    self:SetScript("OnUpdate", nil)
    delaytimer = 0
end

ns:RegisterEvent"PLAYER_ENTERING_WORLD"
ns:RegisterEvent"ZONE_CHANGED_NEW_AREA"
function ns:PLAYER_ENTERING_WORLD()
    if LoggingCombat() then
        ns:Enable()
    end

    self:UnregisterEvent"PLAYER_ENTERING_WORLD"
    if autolog then
        zoneFrame:SetScript("OnUpdate", zoneDelay)
    end
end
ns.ZONE_CHANGED_NEW_AREA = ns.PLAYER_ENTERING_WORLD

