local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local TextStatusBar = CreateFromMixins(TextStatusBarMixin)

do
    local text = GameTooltipStatusBar:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
    text:SetPoint("CENTER")
    GameTooltipStatusBar.TextString = text
end

local function CalculateHealthFactor(value, isHighHealth)
    return isHighHealth and (1.0 - value) * 1.5 or (1.0 - (value * 2))
end

local function AdjustColorIntensity(colorValue, factor, isHighHealth)
    dimmedColor = colorValue * (1 - factor)

    return isHighHealth and (dimmedColor + colorValue * 0.7 * factor) or dimmedColor
end

GameTooltipStatusBar.capNumericDisplay = true
GameTooltipStatusBar.forceShow = true
GameTooltipStatusBar.lockShow = 0
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
    if(textString) then
        if value == 0 then
            self.TextString:Hide()
        else
            if unit then
                value, max = UnitHealth(unit), UnitHealthMax(unit)
            end
            TextStatusBar.UpdateTextStringWithValues(self, textString, value, 0, max)
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