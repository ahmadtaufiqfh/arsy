-- Toggle Name/Level Visibility System
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

-- Simple toggle function - no loops
local function toggleAllBillboards(hide)
    if hide then
        -- Disable all BillboardGuis in the game
        for _, workspaceObj in pairs(workspace:GetDescendants()) do
            if workspaceObj:IsA("BillboardGui") then
                if not workspaceObj:GetAttribute("WasEnabled") then
                    workspaceObj:SetAttribute("WasEnabled", workspaceObj.Enabled)
                end
                workspaceObj.Enabled = false
            end
        end
    else
        -- Enable all BillboardGuis that were disabled
        for _, workspaceObj in pairs(workspace:GetDescendants()) do
            if workspaceObj:IsA("BillboardGui") then
                local wasEnabled = workspaceObj:GetAttribute("WasEnabled")
                if wasEnabled ~= nil then
                    workspaceObj.Enabled = wasEnabled
                else
                    workspaceObj.Enabled = true
                end
            end
        end
    end
end

-- Update button appearance
local function updateButton()
    if isHidden then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        print("✅ Semua Billboard: DISABLED")
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        print("✅ Semua Billboard: ENABLED")
    end
end

-- Button click handler
toggleBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    toggleAllBillboards(isHidden)
    updateButton()
end)

-- Monitor for new BillboardGuis
workspace.DescendantAdded:Connect(function(descendant)
    if isHidden and descendant:IsA("BillboardGui") then
        descendant.Enabled = false
    end
end)

-- Auto refresh
spawn(function()
    while task.wait(3) do
        if isHidden then
            toggleAllBillboards(true)
        end
    end
end)

-- Initialize
updateButton()
toggleAllBillboards(isHidden)

print("🎯 System Ready")
print("• 🔴 RED = Semua Billboard Visible")
print("• 🟢 GREEN = Semua Billboard Hidden")
print("• Termasuk semua player")
print("• Click circle to toggle")
