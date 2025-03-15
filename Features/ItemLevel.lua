if not TooltipDataProcessor.AddTooltipPostCall then return end

local GameTooltip = GameTooltip
local UnitIsPlayer = UnitIsPlayer
local UnitGUID = UnitGUID
local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists
local CanInspect = CanInspect
local CheckInteractDistance = CheckInteractDistance
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetAverageItemLevel = GetAverageItemLevel
local NotifyInspect = NotifyInspect
local ClearInspectPlayer = ClearInspectPlayer
local RoundToSignificantDigits = RoundToSignificantDigits
local GetTime = GetTime

local ITEM_LEVEL_LABEL = NORMAL_FONT_COLOR:WrapTextInColorCode(STAT_AVERAGE_ITEM_LEVEL .. ":")

local function AddTooltipLine(avgItemLevel, refresh)
    if avgItemLevel > 0 then
        avgItemLevel = RoundToSignificantDigits(avgItemLevel, 2)
        GameTooltip:AddDoubleLine(ITEM_LEVEL_LABEL, avgItemLevel, nil, nil, nil, 1, 1, 1)
        if refresh then
            GameTooltip:Show()
        end
    end
end

local ItemLevel = {}
do
    local CACHE_EXPIRATION_TIME = 120
    
    local UNIT_ITEMLEVEL_CACHE = {}
    local UNIT_ITEMLEVEL_TIMESTAMP = {}

    function ItemLevel:Cache(guid, avgItemLevel)
        UNIT_ITEMLEVEL_CACHE[guid] = avgItemLevel
        UNIT_ITEMLEVEL_TIMESTAMP[guid] = GetTime()
    end

    function ItemLevel:Get(guid)
        local avgItemLevel = UNIT_ITEMLEVEL_CACHE[guid]
        local timestamp = UNIT_ITEMLEVEL_TIMESTAMP[guid]
        local elapsed = timestamp and (GetTime() - timestamp) or (CACHE_EXPIRATION_TIME + 1)
        
        if avgItemLevel and elapsed <= CACHE_EXPIRATION_TIME then
            return avgItemLevel  
        end
    
        UNIT_ITEMLEVEL_CACHE[guid] = nil
        UNIT_ITEMLEVEL_TIMESTAMP[guid] = nil
    
        return nil
    end
end

local Player = {}
do
    local INV_SLOTS = {1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17}

    local timerHandle = nil
    local lastInspectedGuid = nil
    local lastInspectedUnit = nil
    local frame = CreateFrame("Frame")
    frame:SetScript("OnEvent", function(self, event, guid)
        if event == "INSPECT_READY" then
            if lastInspectedUnit and UnitExists(lastInspectedUnit) and lastInspectedGuid == guid then
                local avgItemLevel = C_PaperDollInfo.GetInspectItemLevel(lastInspectedUnit)
                if avgItemLevel > 0 then
                    ItemLevel:Cache(guid, avgItemLevel)
                    AddTooltipLine(avgItemLevel, true)
                end
                lastInspectedUnit = nil
                lastInspectedGuid = nil
            end
            self:UnregisterEvent(event)
        end
    end)

    local function IsUnitInspectable(unit)
        return CanInspect(unit) and UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit)
    end

    local function StartInspect()
        if lastInspectedUnit and IsUnitInspectable(lastInspectedUnit) then
            frame:RegisterEvent("INSPECT_READY")
            NotifyInspect(lastInspectedUnit)
        end
    end

    local function InspectAsync(unit)
        Player:ClearInspection()
        if IsUnitInspectable(unit) then
            timerHandle = C_Timer.NewTicker(2, StartInspect, 1)
        end
    end

    function Player:InspectAverageItemLevel(unit)
        lastInspectedUnit = unit

        local guid = UnitGUID(unit)
        local avgItemLevel = ItemLevel:Get(guid) or 0

        if avgItemLevel == 0 and lastInspectedGuid ~= guid then
            lastInspectedGuid = guid
            InspectAsync(unit)
        end

        return avgItemLevel
    end

    function Player:ClearInspection()
        if timerHandle then
            timerHandle:Cancel()
            timerHandle = nil
        end
    end

    function Player:GetAverageItemLevel()
        local _, equipped = GetAverageItemLevel()
        return equipped or 0
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()

    if unit and UnitIsPlayer(unit) then
        local avgItemLevel = 0
        
        if UnitIsUnit(unit, "player") then
            avgItemLevel = Player:GetAverageItemLevel()
        elseif IsShiftKeyDown() then
            avgItemLevel = Player:InspectAverageItemLevel(unit)
        end

        AddTooltipLine(avgItemLevel)
    else
        Player:ClearInspection()
    end
end)