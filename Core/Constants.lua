local _, addon = ...

do
    local DIFFICULTY_COLOR = {}
    addon.DIFFICULTY_COLOR = DIFFICULTY_COLOR

    for _, difficulty in pairs(Enum.RelativeContentDifficulty) do
        local diffColor = GetDifficultyColor(difficulty)
        DIFFICULTY_COLOR[difficulty] = CreateColor(diffColor.r, diffColor.g, diffColor.b, 1)
    end
end