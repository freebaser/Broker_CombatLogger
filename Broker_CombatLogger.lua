local ADDON_NAME, ns = ...

local L = {}
if(GetLocale() == 'enUS') then
    L["Enabled"] = "Enabled"
    L["Disabled"] = "Disabled"
    L["Left-click"] = "Left-click"
    L["Toggle"] = "to toggle combat logging."
elseif(GetLocale() == 'frFR') then
    L["Enabled"] = "Activ�"
    L["Disabled"] = "D�sactiv�"
    L["Left-click"] = "Left-click"
    L["Toggle"] = "to toggle combat logging."
elseif(GetLocale() == 'ruRU') then
    L["Enabled"] = "Включено"
    L["Disabled"] = "Выключено"
    L["Left-click"] = "Left-click"
    L["Toggle"] = "to toggle combat logging."
elseif(GetLocale() == 'koKR') then
    L["Enabled"] = "가능"
    L["Disabled"] = "불가능"
    L["Left-click"] = "Left-click"
    L["Toggle"] = "to toggle combat logging."
elseif(GetLocale() == 'zhCN') then
    L["Enabled"] = "记录中"
    L["Disabled"] = "未记录"
    L["Left-click"] = "Left-click"
    L["Toggle"] = "to toggle combat logging."
elseif(GetLocale() == 'zhCN') then
    L["Enabled"] = "記錄中"
    L["Disabled"] = "未記錄"
    L["Left-click"] = "Left-click"
    L["Toggle"] = "to toggle combat logging."
else
    L["Enabled"] = "Enabled"
    L["Disabled"] = "Disabled"
    L["Left-click"] = "Left-click"
    L["Toggle"] = "to toggle combat logging."
end

local enableIcon = "Interface\\CURSOR\\Attack"
local disableIcon = "Interface\\CURSOR\\UnableAttack"

ns.broker = LibStub("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, {
    type = "launcher",
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
            tip:AddLine(("|cffFF00FF%s|r |cffFFFFFF%s|r"):format(L["Left-click"], L["Toggle"]))
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

ns:RegisterEvent"PLAYER_ENTERING_WORLD"
function ns:PLAYER_ENTERING_WORLD()
    if LoggingCombat() then
        ns:Enable()
    end

    self:UnregisterEvent"PLAYER_ENTERING_WORLD"
end
