local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- [ ARAYÜZ KURULUMU ]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GundogdiUI"

-- Sağ Üst Menü Butonu
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

-- PANEL İSMİ (İstediğin gibi değiştirildi)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "gündoğdisex"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

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

-- [ HİLELER (Sorunsuz Çalışan Versiyonlar) ]

-- 1. SPEED HACK (Zorunlu Döngü)
local speedLoop
CreateToggle("Speed Hack", 50, function(state)
    if state then
        -- Blox Fruits hızı sıfırlamasın diye saniyede 60 kere gücümüzü zorluyoruz
        speedLoop = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 100
            end
        end)
    else
        if speedLoop then speedLoop:Disconnect() end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- 2. GERÇEK FLY (Kamera Yönüne Doğru WASD ile Uçuş)
local flyLoop
local bg, bv
CreateToggle("Fly Mode", 100, function(state)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if state and hrp then
        bg = Instance.new("BodyGyro", hrp)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame

        bv = Instance.new("BodyVelocity", hrp)
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

        flyLoop = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.PlatformStand = true -- Karakteri havada tutar
                bg.cframe = Camera.CFrame -- Yüzümüz kameraya döner
                
                local moveDir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                
                bv.velocity = moveDir * 100 -- Uçuş Hızı
            end
        end)
    else
        if flyLoop then flyLoop:Disconnect() end
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)

-- 3. MEYVE BULUCU (ESP ve Teleport)
local fruitFinderActive = false
CreateToggle("Meyve Bulucu", 150, function(state)
    fruitFinderActive = state
    
    if fruitFinderActive then
        task.spawn(function()
            while fruitFinderActive do
                local found = false
                
                -- Bütün haritayı tara
                for _, obj in pairs(Workspace:GetChildren()) do
                    -- Meyveler Tool'dur ve içinde "Fruit" kelimesi geçer
                    if obj:IsA("Tool") and string.find(string.lower(obj.Name), "fruit") then
                        local handle = obj:FindFirstChild("Handle")
                        if handle then
                            found = true
                            
                            -- 1) ESP OLUŞTUR (Meyveyi Ekranda Göster)
                            if not handle:FindFirstChild("FruitESP") then
                                local bgui = Instance.new("BillboardGui", handle)
                                bgui.Name = "FruitESP"
                                bgui.AlwaysOnTop = true
                                bgui.Size = UDim2.new(0, 200, 0, 50)
                                
                                local txt = Instance.new("TextLabel", bgui)
                                txt.Size = UDim2.new(1, 0, 1, 0)
                                txt.Text = "🍎 " .. obj.Name .. " 🍎"
                                txt.TextColor3 = Color3.fromRGB(0, 255, 0)
                                txt.BackgroundTransparency = 1
                                txt.TextScaled = true
                                txt.Font = Enum.Font.GothamBold
                            end
                            
                            -- 2) MEYVEYE TWEEN ILE IŞINLAN (Kodu bulup yöne gitme)
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local hrp = char.HumanoidRootPart
                                local dist = (hrp.Position - handle.Position).Magnitude
                                local speed = 250 -- Işınlanma hızı (ban yememek için 250 ideal)
                                
                                local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = handle.CFrame})
                                tween:Play()
                                tween.Completed:Wait() -- Meyveye gidene kadar bekle
                            end
                            break -- Bir meyveyi alınca döngüyü kır, diğerine sonra geçer
                        end
                    end
                end
                
                if not found then
                    print("[gündoğdisex]: Yerde meyve yok, bekleniyor...")
                end
                
                task.wait(1) -- Oyunu kastırmamak için 1 saniye bekle
            end
        end)
    else
        -- Özellik kapatılırsa ekrandaki ESP yazılarını sil
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Tool") and string.find(string.lower(obj.Name), "fruit") then
                local handle = obj:FindFirstChild("Handle")
                if handle and handle:FindFirstChild("FruitESP") then
                    handle.FruitESP:Destroy()
                end
            end
        end
    end
end)
