local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [ GÜVENLİ IŞINLANMA (TWEEN) - Anti-Cheat Bypass ]
-- Blox Fruits anında ışınlanmayı (CFrame) banlar. Bu yüzden profesyonel scriptler karakteri havada süzülerek götürür.
local function TweenTeleport(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local speed = 300 -- Hız 350'yi geçerse oyun atabilir.
    local time = distance / speed
    
    -- Karakterin düşmemesi için yerçekimini sıfırla
    local bv = hrp:FindFirstChild("TweenVelocity") or Instance.new("BodyVelocity", hrp)
    bv.Name = "TweenVelocity"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    tween.Completed:Wait() -- Işınlanma bitene kadar bekle
    
    if bv then bv:Destroy() end
end

-- [ ARAYÜZ (AKOF KING STYLE) ]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ProHubUI"

-- Sağ Üst Menü Butonu (Yuvarlak)
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.95, -25, 0.05, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.Image = "rbxassetid://6031094677" 
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- Ana Panel
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "BLOX FRUITS PRO HUB"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Gelişmiş Switch Fonksiyonu
local function CreateToggle(name, yPos, callback)
    local Frame = Instance.new("Frame", MainFrame)
    Frame.Size = UDim2.new(0.9, 0, 0, 40)
    Frame.Position = UDim2.new(0.05, 0, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.Text = name
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.25, 0, 0.7, 0)
    Btn.Position = UDim2.new(0.7, 0, 0.15, 0)
    Btn.Text = "OFF"
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
    
    local isEnabled = false
    Btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        Btn.Text = isEnabled and "ON" or "OFF"
        Btn.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        callback(isEnabled)
    end)
end

-- [ HİLE ÖZELLİKLERİ ]

-- 1. Güvenli Uçuş / Noclip
local noclipConnection
CreateToggle("Güvenli Uçuş (Noclip)", 50, function(state)
    local char = LocalPlayer.Character
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

-- 2. Meyve Bulucu (Fruit ESP & Teleport)
local autoFruitLoop = false
CreateToggle("Otomatik Meyve Topla", 100, function(state)
    autoFruitLoop = state
    while autoFruitLoop do
        task.wait(1)
        -- Workspace içindeki düşmüş meyveleri arar
        local foundFruit = false
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Tool") and string.find(string.lower(obj.Name), "fruit") then
                print("Meyve Bulundu: " .. obj.Name .. " - Işınlanılıyor...")
                TweenTeleport(obj.Handle.CFrame)
                foundFruit = true
                task.wait(2) -- Alması için biraz bekle
                break
            end
        end
        if not foundFruit then
            print("Haritada meyve bulunamadı, bekleniyor...")
        end
    end
end)

-- 3. Hızlı Yürüme (Anti-Cheat'e takılmayan versiyon)
local speedLoop
CreateToggle("Speed Hack (Güvenli)", 150, function(state)
    if state then
        speedLoop = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 80 -- 80 üstü Blox Fruits'te bazen geri atar
            end
        end)
    else
        if speedLoop then speedLoop:Disconnect() end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
        end
    end
end)
