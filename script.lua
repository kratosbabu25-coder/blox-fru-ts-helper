-- // GÜNDOĞDİSEX V2 - STEALTH & ULTIMATE \\
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // 1. GÜÇLENDİRİLMİŞ NO CLIP (Duvar Geçişi)
local Noclip = true
RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- // 2. TWEEN MOTORU (Anti-Kick / Tespit Edilmeyi Zorlaştırır)
-- Işınlanma yerine karakteri hedefe yumuşak bir şekilde uçurur.
local function TweenTo(targetCFrame)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local dist = (hrp.Position - targetCFrame.Position).Magnitude
        local speed = 350 -- Burayı çok artırma, sunucu algılar
        local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
    end
end

-- // 3. HİLE VE FARM MOTORU
local FlyEnabled, AutoFarm = false, false

RunService.Heartbeat:Connect(function()
    -- Uçuş (CFrame ile yumuşak hareket)
    if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        hrp.CFrame = hrp.CFrame + (moveDir * 2.5)
        hrp.Velocity = Vector3.new(0,0,0)
    end
end)

-- AutoFarm & Meyve ESP (Tween ile Stealth)
task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoFarm and Workspace:FindFirstChild("Enemies") then
            for _, npc in pairs(Workspace.Enemies:GetChildren()) do
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    TweenTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

-- // 4. ARAYÜZ (GÜNDOĞDİSEX V2)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 550); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- Başlık
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "GÜNDOĞDİSEX V2"
Title.Size = UDim2.new(1, 0, 0, 60); Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBlack; Title.TextSize = 30

-- Butonlar
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(0.9, 0, 0.7, 0); Scroll.Position = UDim2.new(0.05, 0, 0.15, 0)
Scroll.BackgroundTransparency = 1; Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

local function CreateBtn(name, callback)
    local B = Instance.new("TextButton", Scroll); B.Size = UDim2.new(1, 0, 0, 40)
    B.Text = name; B.BackgroundColor3 = Color3.fromRGB(30,30,30); B.TextColor3 = Color3.new(1,1,1)
    B.MouseButton1Click:Connect(callback)
end

CreateBtn("UÇUŞ MODU: OFF", function(b) FlyEnabled = not FlyEnabled; b.Text = FlyEnabled and "UÇUŞ: ON" or "UÇUŞ: OFF" end)
CreateBtn("AUTO FARM: OFF", function(b) AutoFarm = not AutoFarm; b.Text = AutoFarm and "FARM: ON" or "FARM: OFF" end)
CreateBtn("MEYVE BULUCU (GİT)", function() 
    for _,o in pairs(Workspace:GetChildren()) do 
        if o:IsA("Tool") and string.find(string.lower(o.Name), "fruit") then 
            TweenTo(o.Handle.CFrame) 
            break 
        end 
    end 
end)

-- Ada Işınlanma
if Workspace:FindFirstChild("_WorldOrigin") then
    for _, island in pairs(Workspace._WorldOrigin.Locations:GetChildren()) do
        CreateBtn("🏝️ " .. island.Name, function() TweenTo(island.CFrame + Vector3.new(0, 50, 0)) end)
    end
end

-- Kuru Kafa Toggle
local ToggleBtn = Instance.new("TextButton", ScreenGui); ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0.9, 0, 0.05, 0); ToggleBtn.Text = "☠️"; ToggleBtn.TextSize = 30
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
