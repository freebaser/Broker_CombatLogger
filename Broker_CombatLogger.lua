local ADDON_NAME, ns = ...

local autolog = true -- Automatically enable logging for zones below
local autoDisable = true -- Always disable logging if not in an autolog zone
local Z = {
    --[752] = true, -- Baradin Hold
    --[754] = true, -- Blackwing Descent
    --[758] = true, -- The Bastion of Twilight
    --[773] = true, -- Throne of the Four Winds
    --[800] = true, -- Firelands
    --[824] = true, -- Dragon Soul
	 [897] = true, -- Heart of Fear
	 [896] = true, -- Mogu'shan Vaults
	 [886] = true, -- Terrace of Endless Spring
	 [930] = true, -- Throne of Thunder
	 [953] = true, -- Siege of Orgrimmar

    -- [MapAreaID] = true,
}

local ENABLE = ENABLE
local DISABLE = DISABLE
local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

local enableIcon = "Interface\\CURSOR\\Attack"
local disableIcon = "Interface\\CURSOR\\UnableAttack"

local frame = CreateFrame('Frame', nil, ChatFrame1EditBox)
frame:HookScript("OnHide", function(self)
    if(LoggingCombat()) then
        ns.broker.icon = enableIcon
        ns.broker.text = "|cff00FF00"..ENABLE.."|r"
    else
        ns.broker.icon = disableIcon
        ns.broker.text = DISABLE
    end
end)

ns.broker = LibStub("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, {
    label = ADDON_NAME,
    type = "data source",
    icon = disableIcon,
    text = DISABLE,
    OnClick = function(self, button)
        if(button == "LeftButton") then
            if(LoggingCombat()) then
                ns:Disable()
            else
                ns:Enable()
            end
        end
    end,
    OnTooltipShow = function(tip)
        if(tip and tip.AddLine) then
            tip:AddLine("|cffFFFF00"..ADDON_NAME.."|r")
            tip:AddLine(("|cffFF00FF%s|r |cffFFFFFF%s|r"):format(L["Left-click"], L["to toggle combat logging."]))
        end
    end,
})

function ns:Enable()
	if(not LoggingCombat()) then
		print(COMBATLOGENABLED)
	end
    LoggingCombat(true)
    ns.broker.icon = enableIcon
    ns.broker.text = "|cff00FF00"..ENABLE.."|r"
end

function ns:Disable()
	if(LoggingCombat()) then
		print(COMBATLOGDISABLED)
	end
    LoggingCombat(false)
    ns.broker.icon = disableIcon
    ns.broker.text = DISABLE
end

local zoneDelay = CreateFrame"Frame"
zoneDelay:SetScript("OnUpdate", function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if(self.elapsed < 5) then return end

	if(IsInInstance()) then
		SetMapToCurrentZone()
	end

	local zone = GetCurrentMapAreaID()
    if(Z[zone]) then
        ns:Enable()
    elseif(autoDisable) then
        ns:Disable()
    end

    self:Hide()
    self.elapsed = 0
end)

local zoneChanged = CreateFrame"Frame" 
zoneChanged:RegisterEvent"PLAYER_ENTERING_WORLD"
zoneChanged:SetScript("OnEvent", function(self, event, ...)

	if(event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent"PLAYER_ENTERING_WORLD"
		self:RegisterEvent"ZONE_CHANGED_NEW_AREA"
	end

    if(autolog) then
        zoneDelay:Show()
    end
end)

