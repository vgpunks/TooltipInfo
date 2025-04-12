local GameTooltip = GameTooltip
local GameTooltipStatusBar = GameTooltipStatusBar

local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass

local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local STATUSBAR_TEXTURE = "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill"
local STATUSBAR_WIDTH = 12

do
    local text = GameTooltipStatusBar:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
    text:SetPoint("CENTER")
    GameTooltipStatusBar.TextString = text
end

do
    local text = CreateFromMixins(TextStatusBarMixin)
    GameTooltipStatusBar.TextStatusBar = text
end

do
    local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture(STATUSBAR_TEXTURE)
    bg:SetAllPoints()
    bg:SetVertexColor(0.33, 0.33, 0.33, 0.5)
    GameTooltipStatusBar.Background = bg
end

local function CalculateHealthFactor(value, isHighHealth)
    return isHighHealth and (1.0 - value) * 1.5 or (1.0 - (value * 2))
end

local function AdjustColorIntensity(colorValue, factor, isHighHealth)
    local dimmedColor = colorValue * (1 - factor)

    return isHighHealth and (dimmedColor + colorValue * 0.7 * factor) or dimmedColor
end

GameTooltipStatusBar.capNumericDisplay = true
GameTooltipStatusBar.forceShow = true
GameTooltipStatusBar.lockShow = 0
GameTooltipStatusBar:SetHeight(STATUSBAR_WIDTH)
GameTooltipStatusBar:SetStatusBarTexture(STATUSBAR_TEXTURE)
GameTooltipStatusBar:HookScript("OnValueChanged", function(self, value)
    self:SetStatusBarColor(0, 1, 0)

    if not value then
        return
    end

    local min, max = self:GetMinMaxValues()
    if (value < min) or (value > max) then
        return
    end

    local _, unit = GameTooltip:GetUnit()

    -- Shows percentage on structures
    self.showPercentage = not unit and max == 1

    local textString = self.TextString

    if textString then
        if value == 0 then
            self.TextString:Hide()
            self.Background:Hide()
        else
            if unit then
                value, max = UnitHealth(unit), UnitHealthMax(unit)
            end
            self.TextStatusBar.UpdateTextStringWithValues(self, textString, value, 0, max)
            self.Background:Show()
        end
    end

    value = (value - min) / (max - min)

    local isHighHealth = value > 0.5
    local factor = CalculateHealthFactor(value, isHighHealth)
    local r, g, b = 0, 1, 0

    if unit and UnitIsPlayer(unit) then
        local _, classFilename = UnitClass(unit)

        if classFilename then
            local classColor = RAID_CLASS_COLORS[classFilename]

            if classColor then
                r, g, b = classColor.r, classColor.g, classColor.b
            end
        end
    end

    r = AdjustColorIntensity(r, factor, isHighHealth)
    g = AdjustColorIntensity(g, factor, isHighHealth)
    b = AdjustColorIntensity(b, factor, isHighHealth)

    r = isHighHealth and r or r + factor

    self:SetStatusBarColor(r, g, b)
end)

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end 

    if GameTooltipStatusBar.TextString then
        local textWidth = GameTooltipStatusBar.TextString:GetStringWidth()

        if textWidth then
            tooltip:SetMinimumWidth(textWidth)
        end
    end
end)