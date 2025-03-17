local function OnTextChanged(self)
    self:SetText(self.originalText)
    self:SetCursorPosition(0)
    self:SetFocus()
    self:HighlightText()
end

StaticPopupDialogs["TOOLTIPINFO_COPY_ID"] = StaticPopupDialogs["TOOLTIPINFO_COPY_ID"] or {
    text = "Copy %s.",
    button2 = CLOSE,
    hasEditBox = true,
    editBoxWidth = 320,
    closeButton = true,
    OnShow = function(self, data)
        self.editBox.originalText = data
        self.editBox:SetText(data)
        self.editBox:HighlightText()
        self.editBox:SetScript("OnTextChanged", OnTextChanged)
    end,
    OnHide = function(self)
        self.editBox:SetScript("OnTextChanged", nil)
    end,
    EditBoxOnEnterPressed = HideParentPanel,
    EditBoxOnEscapePressed = HideParentPanel,
    whileDead = true,
}