local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local boxes = {}

local function createBox(player)
    if player == LocalPlayer then return end
    
    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(0, 255, 120)
    box.Thickness = 2
    box.Filled = false
    box.Visible = false
    
    boxes[player] = box
end

for _, player in ipairs(Players:GetPlayers()) do
    createBox(player)
end

Players.PlayerAdded:Connect(createBox)

Players.PlayerRemoving:Connect(function(player)
    if boxes[player] then
        boxes[player]:Remove()
        boxes[player] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for player, box in pairs(boxes) do
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            local pos, onScreen = WorldToScreen(hrp.Position)
            if onScreen then
                -- Calculate dynamic size based on distance
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                local size = math.clamp(1000 / dist, 10, 300)
                
                box.Position = Vector2.new(pos.X - size / 2, pos.Y - size / 2)
                box.Size = Vector2.new(size, size)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end)
