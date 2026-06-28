-- // GÜNDOĞDİSEX V2 - STEALTH & ULTIMATE PRO SÜRÜM \\
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // AYARLAR VE DEĞİŞKENLER
local FlyEnabled, AutoFarm = false, false
local Speed = 350 -- Başlangıç hızı

-- // 1. GÜÇLENDİRİLMİŞ NO CLIP (Duvar Geçişi)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- // 2. TWEEN MOTORU (Anti-Ban / Tespit Edilmeyi Zorlaştırır)
local function TweenTo(targetCFrame)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local dist = (hrp.Position - targetCFrame.Position).Magnitude
        -- Hız çarpanı burada kullanılıyor
        local duration = math.clamp(dist / Speed, 0.1, 5) 
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
    end
end

-- // 3. HİLE VE FARM MOTORU
RunService.Heartbeat:Connect(function()
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

-- AutoFarm (Düzeltildi: Üstten Vurma + Slot 1)
task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoFarm and Workspace:FindFirstChild("Enemies") then
            -- 1. Slotu Zorla Seç
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool then char.Humanoid:EquipTool(tool) end
            end

            -- NPC'lerin Üstüne Git (Safe Hover)
            for _, npc in pairs(Workspace.Enemies:GetChildren()) do
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 and npc:FindFirstChild("HumanoidRootPart") then
                    -- NPC'nin 10 stud üstüne git (Hasar almazsın)
                    TweenTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                    
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

-- // 4. ARAYÜZ
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 550); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "GÜNDOĞDİSEX V2"
Title.Size = UDim2.new(1, 0, 0, 60); Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBlack; Title.TextSize = 30

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(0.9, 0, 0.7, 0); Scroll.Position = UDim2.new(0.05, 0, 0.15, 0)
Scroll.BackgroundTransparency = 1; Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

local function CreateBtn(name, callback)
    local B = Instance.new("TextButton", Scroll); B.Size = UDim2.new(1, 0, 0, 40)
    B.Text = name; B.BackgroundColor3 = Color3.fromRGB(30,30,30); B.TextColor3 = Color3.new(1,1,1)
    B.MouseButton1Click:Connect(callback)
    return B
end

CreateBtn("UÇUŞ MODU: OFF", function(b) FlyEnabled = not FlyEnabled; b.Text = FlyEnabled and "UÇUŞ: ON" or "UÇUŞ: OFF" end)
CreateBtn("AUTO FARM: OFF", function(b) AutoFarm = not AutoFarm; b.Text = AutoFarm and "FARM: ON" or "FARM: OFF" end)

-- Hız Ayar Butonu
local SpeedBtn = CreateBtn("HIZ ÇARPANI: " .. Speed, function()
    Speed = Speed + 50
    if Speed > 1000 then Speed = 350 end -- Reset atma
    local btn = SpeedBtn
    btn.Text = "HIZ ÇARPANI: " .. Speed
end)

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
