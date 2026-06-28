-- // GÜNDOĞDİSEX V2 - STABLE PRO SÜRÜM \\
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // AYARLAR
local FlyEnabled, AutoFarm, Noclip = false, false, true
local Speed = 350

-- // 1. NO CLIP (Toggle Eklendi)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and Noclip then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- // 2. TWEEN MOTORU
local function TweenTo(targetCFrame)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local dist = (hrp.Position - targetCFrame.Position).Magnitude
        local duration = math.clamp(dist / Speed, 0.5, 3) 
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        tween:Play()
    end
end

-- // 3. HİLE VE FARM MOTORU
-- AutoFarm (Düzeltildi: Vuruş mesafesi 3 stud, Slot 1 zorunlu)
task.spawn(function()
    while task.wait(0.2) do
        if AutoFarm and Workspace:FindFirstChild("Enemies") then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                -- SADECE 1. Slotu Zorla Seç
                local tools = LocalPlayer.Backpack:GetChildren()
                for _, t in pairs(tools) do
                    if t:IsA("Tool") then
                        char.Humanoid:EquipTool(t)
                        break -- Sadece ilk bulduğunda dur, diğerlerine geçme
                    end
                end
            end

            for _, npc in pairs(Workspace.Enemies:GetChildren()) do
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 and npc:FindFirstChild("HumanoidRootPart") then
                    -- Vuruş mesafesini 3 stud yaptım (Adamlara vurabilirsin)
                    TweenTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
                    
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

-- // MEYVE ESP (Meyve Adı ve Uzaklık Ölçeklendirme)
task.spawn(function()
    while task.wait(1) do
        for _, o in pairs(Workspace:GetChildren()) do
            if o:IsA("Tool") and o.Name:lower():find("fruit") and not o:FindFirstChild("FruitESP") then
                local bill = Instance.new("BillboardGui", o); bill.Name = "FruitESP"; bill.Size = UDim2.new(0, 200, 0, 50); bill.AlwaysOnTop = true
                local label = Instance.new("TextLabel", bill); label.Size = UDim2.new(1,0,1,0); label.Text = o.Name; label.TextColor3 = Color3.new(1,1,0); label.BackgroundTransparency = 1
                
                -- Uzaklığa göre büyüme mantığı
                RunService.RenderStepped:Connect(function()
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - o.Handle.Position).Magnitude
                    label.TextSize = math.clamp(100 / (dist / 10), 20, 50) -- Uzaklaştıkça küçülür, yaklaştıkça büyür
                end)
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

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(0.9, 0, 0.8, 0); Scroll.Position = UDim2.new(0.05, 0, 0.1, 0)
Scroll.BackgroundTransparency = 1; Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

local function CreateBtn(name, callback)
    local B = Instance.new("TextButton", Scroll); B.Size = UDim2.new(1, 0, 0, 40)
    B.Text = name; B.BackgroundColor3 = Color3.fromRGB(30,30,30); B.TextColor3 = Color3.new(1,1,1)
    B.MouseButton1Click:Connect(callback)
    return B
end

CreateBtn("NO CLIP: ON", function(b) Noclip = not Noclip; b.Text = Noclip and "NO CLIP: ON" or "NO CLIP: OFF" end)
CreateBtn("UÇUŞ: OFF", function(b) FlyEnabled = not FlyEnabled; b.Text = FlyEnabled and "UÇUŞ: ON" or "UÇUŞ: OFF" end)
CreateBtn("AUTO FARM: OFF", function(b) AutoFarm = not AutoFarm; b.Text = AutoFarm and "FARM: ON" or "FARM: OFF" end)

-- Ada Işınlanma (Hassas Konumlandırma)
if Workspace:FindFirstChild("_WorldOrigin") then
    for _, island in pairs(Workspace._WorldOrigin.Locations:GetChildren()) do
        CreateBtn("🏝️ " .. island.Name, function() 
            -- Işınlanmayı daha güvenli ve yüksekten yaptım
            local target = island.CFrame * CFrame.new(0, 50, 0)
            local H = LocalPlayer.Character.HumanoidRootPart
            TweenService:Create(H, TweenInfo.new(1), {CFrame = target}):Play()
        end)
    end
end

-- Kuru Kafa Toggle
local ToggleBtn = Instance.new("TextButton", ScreenGui); ToggleBtn.Position = UDim2.new(0.9, 0, 0.05, 0); ToggleBtn.Text = "☠️"
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
