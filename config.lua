-- Toggle Billboard Visibility System
print("Toggle System Initialized")

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

-- Simple toggle function
local function toggleAllPlayerBillboards(hide)
    -- Get all characters
    local characters = workspace:FindFirstChild("Characters")
    if not characters then return end
    
    -- Toggle all Billboards in Characters folder
    for _, billboard in pairs(characters:GetDescendants()) do
        if billboard:IsA("BillboardGui") then
            if hide then
                if not billboard:GetAttribute("WasEnabled") then
                    billboard:SetAttribute("WasEnabled", billboard.Enabled)
                end
                billboard.Enabled = false
            else
                local wasEnabled = billboard:GetAttribute("WasEnabled")
                if wasEnabled ~= nil then
                    billboard.Enabled = wasEnabled
                else
                    billboard.Enabled = true
                end
            end
        end
    end
end

-- Update button appearance
local function updateButton()
    if isHidden then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        print("✅ Player Billboard: DISABLED")
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        print("✅ Player Billboard: ENABLED")
    end
end

-- Button click handler
toggleBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    toggleAllPlayerBillboards(isHidden)
    updateButton()
end)

-- Monitor for new Billboards in Characters folder
local function monitorCharacters()
    local characters = workspace:WaitForChild("Characters")
    characters.DescendantAdded:Connect(function(descendant)
        if isHidden and descendant:IsA("BillboardGui") then
            descendant.Enabled = false
        end
    end)
end

spawn(monitorCharacters)

-- Auto refresh
spawn(function()
    while task.wait(3) do
        if isHidden then
            toggleAllPlayerBillboards(true)
        end
    end
end)

-- Initialize
updateButton()
toggleAllPlayerBillboards(isHidden)

print("🎯 System Ready")
print("• 🔴 RED = Player Billboard Visible")
print("• 🟢 GREEN = Player Billboard Hidden")
print("• Hanya billboard di folder Characters")
print("• Click circle to toggle")
