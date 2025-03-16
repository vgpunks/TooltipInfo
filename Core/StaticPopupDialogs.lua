StaticPopupDialogs["TOOLTIPINFO_COPY_ID"] = StaticPopupDialogs["TOOLTIPINFO_COPY_ID"] or {
    text = "Copy %s.",
    button2 = CLOSE,
    hasEditBox = true,
    editBoxWidth = 320,
    closeButton = true,
    OnShow = function(self, data)
        self.editBox:SetText(data)
        self.editBox:HighlightText()
    end,
    EditBoxOnEnterPressed = HideParentPanel,
    EditBoxOnEscapePressed = HideParentPanel,
    whileDead = true,
}