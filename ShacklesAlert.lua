-- Create main frame
local f = CreateFrame("Frame")

local WARNING_TEXT = "SHACKLES INCOMING!"
local WARNING_DEBUFF_TEXT = "YOU ARE SHACKLED!"
local DEBUFF_NAME = "Shackles of the Legion"

-- Create the warning frame
local warningFrame = CreateFrame("Frame", nil, UIParent)
warningFrame:SetWidth(400)
warningFrame:SetHeight(100)
warningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
warningFrame:Hide()

local warningText = warningFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
warningText:SetAllPoints()
warningText:SetTextColor(1, 0, 0)
warningText:SetText(WARNING_TEXT)
warningText:SetShadowColor(0, 0, 0, 1)
warningText:SetShadowOffset(2, -2)

-- Fullscreen dim background
local glowFrame = CreateFrame("Frame", nil, UIParent)
glowFrame:SetAllPoints(UIParent)
glowFrame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
glowFrame:SetBackdropColor(0, 0, 0, 0.5)
glowFrame:Hide()

-- Timer
local timerFrame = CreateFrame("Frame")
timerFrame:Hide()

local elapsedTime = 0

timerFrame:SetScript("OnUpdate", function()
    elapsedTime = elapsedTime + arg1
    if elapsedTime >= 9 then
        warningFrame:Hide()
        glowFrame:Hide()
        this:Hide()
    end
end)

-- Function to show warning
local function ShowWarning(text)
    warningText:SetText(text)
    warningFrame:Show()
    glowFrame:Show()
    PlaySoundFile("Interface\\AddOns\\ShacklesAlert\\alert.wav")
    elapsedTime = 0
    timerFrame:Show()
end

-- Scan player debuffs
local function CheckPlayerDebuffs()
    for i = 1, 40 do
        local name = UnitDebuff("player", i)
        if not name then break end
        if name == DEBUFF_NAME then
            ShowWarning(WARNING_DEBUFF_TEXT)
            break
        end
    end
end

-- Event handler
f:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
f:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
f:RegisterEvent("PLAYER_AURAS_CHANGED")

f:SetScript("OnEvent", function()
    if event == "CHAT_MSG_RAID_BOSS_EMOTE" or event == "CHAT_MSG_MONSTER_EMOTE" then
        local msg = arg1
        if msg and string.find(string.lower(msg), "shackles of the legion") then
            ShowWarning(WARNING_TEXT)
        end
    elseif event == "PLAYER_AURAS_CHANGED" then
        CheckPlayerDebuffs()
    end
end)

-- Slash command to test
SLASH_SHACKLESALERT1 = "/shacklesalert"
SlashCmdList["SHACKLESALERT"] = function(msg)
    if msg == "test" then
        ShowWarning("TEST WARNING")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000ShacklesAlert Commands:|r")
        DEFAULT_CHAT_FRAME:AddMessage("/shacklesalert test - Test the warning")
    end
end