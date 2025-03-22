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
    OnShow = function(self, info)
        self.editBox.originalText = info.id
        self.editBox:SetText(info.id)
        self.editBox:HighlightText()
        self.editBox:SetScript("OnTextChanged", OnTextChanged)
        info.id = nil
    end,
    OnHide = function(self, info)
        self.editBox:SetScript("OnTextChanged", nil)
        info.id = nil
    end,
    EditBoxOnEnterPressed = HideParentPanel,
    EditBoxOnEscapePressed = HideParentPanel,
    whileDead = true,
}