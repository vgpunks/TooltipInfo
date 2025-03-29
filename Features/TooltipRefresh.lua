local UnitIsPlayer = UnitIsPlayer
local UnitIsUnit = UnitIsUnit

local GameTooltip = GameTooltip

local frame = CreateFrame("Frame")
frame:RegisterEvent("MODIFIER_STATE_CHANGED")
frame:SetScript("OnEvent", function(self, event, key, down)
    if not key:find("SHIFT") then return end
    if GameTooltip:IsForbidden() or not GameTooltip:IsShown() then return end
    if UnitIsPlayer("mouseover") and not UnitIsUnit("mouseover", "player") then
        GameTooltip:RefreshData()
    end
end)