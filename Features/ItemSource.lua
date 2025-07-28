local GetDisplayedItem = TooltipUtil and TooltipUtil.GetDisplayedItem
local GetItemInfo = GetItemInfo
local RequestLoadItemDataByID = C_Item and C_Item.RequestLoadItemDataByID

local _G = _G

local EXPAC_LABEL = HIGHLIGHT_FONT_COLOR:WrapTextInColorCode("Expansion:") .. " %s"

local LINK_PATTERN = ":(%w+)"

local ITEMS_CACHE = {}

do
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
    frame:SetScript("OnEvent", function(_, _, itemID, success)
        if success and not ITEMS_CACHE[itemID] then
            local expacID = select(15, GetItemInfo(itemID))
            if expacID then
                ITEMS_CACHE[itemID] = _G["EXPANSION_NAME" .. expacID]
                if GameTooltip:IsShown() then
                    GameTooltip:RefreshData()
                end
            end
        end
    end)
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local itemID = data and data.id

    if not itemID then
        local GetItem = GetDisplayedItem or tooltip.GetItem
        if GetItem then
            local _, link = GetItem(tooltip)
            itemID = link:match(LINK_PATTERN)
        end
    end

    local itemExpacSourceName = ITEMS_CACHE[itemID]

    if not itemExpacSourceName and itemID and RequestLoadItemDataByID then
        RequestLoadItemDataByID(itemID)
    end

    if itemExpacSourceName then
        tooltip:AddLine(" ")
        tooltip:AddLine(EXPAC_LABEL:format(itemExpacSourceName))
    end
end)