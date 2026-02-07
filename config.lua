-- Toggle Name/Level Visibility System
print("Toggle Visibility System Initialized")

local isHidden = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToggleUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 20, 0, 20)
toggleBtn.Position = UDim2.new(1, -45, 0, 15)
toggleBtn.Text = ""
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
toggleBtn.BackgroundTransparency = 0.5
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 10
toggleBtn.TextWrapped = true
toggleBtn.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = toggleBtn

-- Function to toggle visibility
local function toggleNameLevelUI(hide)
    local allPlayerNames = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        allPlayerNames[player.Name] = true
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, gui in pairs(player.Character:GetDescendants()) do
                if gui:IsA("BillboardGui") then
                    local containsNameOrLevel = false
                    
                    for _, textObj in pairs(gui:GetDescendants()) do
                        if textObj:IsA("TextLabel") and textObj.Text then
                            local text = textObj.Text
                            
                            if allPlayerNames[text] then
                                containsNameOrLevel = true
                                break
                            end
                            
                            if text:match("^[Ll][Vv]%.?%s*%d+") then
                                containsNameOrLevel = true
                                break
                            end
                        end
                    end
                    
                    if containsNameOrLevel then
                        if hide then
                            if not gui:GetAttribute("WasEnabled") then
                                gui:SetAttribute("WasEnabled", gui.Enabled)
                            end
                            gui.Enabled = false
                        else
                            local wasEnabled = gui:GetAttribute("WasEnabled")
                            if wasEnabled ~= nil then
                                gui.Enabled = wasEnabled
                            else
                                gui.Enabled = true
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Update button appearance
local function updateButton()
    if isHidden then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        print("Visibility: HIDDEN")
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        print("Visibility: VISIBLE")
    end
end

-- Button click handler
toggleBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    toggleNameLevelUI(isHidden)
    updateButton()
end)

-- Handle character changes
local function handleCharacter(character)
    wait(1)
    
    if isHidden then
        local names = {}
        for _, p in pairs(Players:GetPlayers()) do
            names[p.Name] = true
        end
        
        for _, gui in pairs(character:GetDescendants()) do
            if gui:IsA("BillboardGui") then
                local isTarget = false
                
                for _, textObj in pairs(gui:GetDescendants()) do
                    if textObj:IsA("TextLabel") and textObj.Text then
                        local text = textObj.Text
                        if names[text] or text:match("^[Ll][Vv]%.?") then
                            isTarget = true
                            break
                        end
                    end
                end
                
                if isTarget then
                    gui.Enabled = false
                end
            end
        end
    end
end

-- Monitor local player character
if LocalPlayer.Character then
    handleCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(handleCharacter)

-- Monitor other players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        handleCharacter(character)
    end)
end)

-- Auto refresh
spawn(function()
    while task.wait(3) do
        if isHidden then
            toggleNameLevelUI(true)
        end
    end
end)

-- Initialize
updateButton()
toggleNameLevelUI(isHidden)

print("System Ready")
print("Red = Visible | Green = Hidden")
