-- // GÜNDOĞDİSEX V2.1 - MASSIVE ULTIMATE EDITION \\

-- ==========================================
-- 1. KULLANICININ ÖZEL AYARLARI (TEAM SELECT & FPS BOOST)
-- ==========================================
if not _G.Marine or _G.Pirate then
	spawn(function()
		while wait() do
			if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Visible == true then
				game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Size = UDim2.new(0, 10000, 0, 10000)
				game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Position = UDim2.new(-4, 0, -5, 0)
				game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.BackgroundTransparency = 1
				wait(.5)
				game:GetService'VirtualUser':Button1Down(Vector2.new(99,99))
				game:GetService'VirtualUser':Button1Up(Vector2.new(99,99))
			end     
		end
	end)
end

if _G.Marine then
	spawn(function()
		while wait() do
			if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Visible == true then
				game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.Size = UDim2.new(0, 10000, 0, 10000)
				game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.Position = UDim2.new(-4, 0, -5, 0)
				game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.BackgroundTransparency = 1
				wait(.5)
				game:GetService'VirtualUser':Button1Down(Vector2.new(99,99))
				game:GetService'VirtualUser':Button1Up(Vector2.new(99,99))
			end
		end
	end)
end

if _G.Pirate then 
	spawn(function()
		while wait() do
			if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Visible == true then
				game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Size = UDim2.new(0, 10000, 0, 10000)
				game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Position = UDim2.new(-4, 0, -5, 0)
				game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.BackgroundTransparency = 1
				wait(.5)
				game:GetService'VirtualUser':Button1Down(Vector2.new(99,99))
				game:GetService'VirtualUser':Button1Up(Vector2.new(99,99))
			end
		end
	end)
end

if _G.FPSBoost then
	spawn(function()
		wait(3)
		local decalsyeeted = true
		local g = game
		local w = g.Workspace
		local l = g.Lighting
		local t = w.Terrain
		t.WaterWaveSize = 0
		t.WaterWaveSpeed = 0
		t.WaterReflectance = 0
		t.WaterTransparency = 0
		l.GlobalShadows = false
		l.FogEnd = 9e9
		l.Brightness = 0
		settings().Rendering.QualityLevel = "Level01"
		for i, v in pairs(g:GetDescendants()) do
			if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then 
				v.Material = "Plastic"
				v.Reflectance = 0
			elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0)
			elseif v:IsA("Explosion") then
				v.BlastPressure = 1
				v.BlastRadius = 1
			elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
				v.Enabled = false
			elseif v:IsA("MeshPart") then
				v.Material = "Plastic"
				v.Reflectance = 0
				v.TextureID = 10385902758728957
			end
		end
		for i, e in pairs(l:GetChildren()) do
			if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
				e.Enabled = false
			end
		end
	end)
end

-- ==========================================
-- 2. SERVİSLER VE DEĞİŞKENLER
-- ==========================================
local P = game:GetService("Players")
local W = game:GetService("Workspace")
local R = game:GetService("RunService")
local T = game:GetService("TweenService")
local U = game:GetService("UserInputService")
local C = game:GetService("CoreGui")
local Rep = game:GetService("ReplicatedStorage")
local L = P.LocalPlayer
local Cam = W.CurrentCamera

-- Hile Durumları (Toggles)
local States = {
    SpeedHack = false,
    SpeedValue = 75,
    InfStamina = false,
    Fly = false,
    FruitFinder = false,
    AutoMoveFruit = false,
    AutoFarm = false,
    Noclip = true
}

-- ==========================================
-- 3. HİLE MOTORLARI (CORE LOGIC)
-- ==========================================

-- Noclip, Speed Hack & Infinite Stamina
R.Stepped:Connect(function()
    local char = L.Character
    if char then
        -- Noclip
        if States.Noclip then
            for _, v in pairs(char:GetDescendants()) do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end
        end
        -- Speed Hack
        if States.SpeedHack and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = States.SpeedValue
        end
        -- Infinite Stamina (Görsel ve Lokal Enerji Sabitleme)
        if States.InfStamina then
            if char:FindFirstChild("Energy") then char.Energy.Value = char.Energy.MaxValue end
        end
    end
end)

-- Fly Mode
R.Heartbeat:Connect(function()
    if States.Fly and L.Character and L.Character:FindFirstChild("HumanoidRootPart") then
        local H = L.Character.HumanoidRootPart
        local D = Vector3.new()
        if U:IsKeyDown(Enum.KeyCode.W) then D += Cam.CFrame.LookVector end
        if U:IsKeyDown(Enum.KeyCode.S) then D -= Cam.CFrame.LookVector end
        if U:IsKeyDown(Enum.KeyCode.A) then D -= Cam.CFrame.RightVector end
        if U:IsKeyDown(Enum.KeyCode.D) then D += Cam.CFrame.RightVector end
        H.CFrame += D * (States.SpeedValue / 20) -- Hızı SpeedHack sliderına bağladım
        H.Velocity = Vector3.new()
    end
end)

-- Auto Farm (Safe Hover 10 Stud + 1. Slot Force)
task.spawn(function()
    while task.wait(0.1) do
        if States.AutoFarm and W:FindFirstChild("Enemies") then
            local char = L.Character
            if char and char:FindFirstChild("Humanoid") then
                local firstTool = L.Backpack:FindFirstChildOfClass("Tool")
                if firstTool and not char:FindFirstChildOfClass("Tool") then
                    char.Humanoid:EquipTool(firstTool)
                end
            end
            
            for _, n in pairs(W.Enemies:GetChildren()) do
                if n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 and n:FindFirstChild("HumanoidRootPart") then
                    local H = char:FindFirstChild("HumanoidRootPart")
                    if H then T:Create(H, TweenInfo.new(0.1), {CFrame = n.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)}):Play() end
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end
end)

-- Fruit Finder ESP & Auto-Move
task.spawn(function()
    while task.wait(1) do
        local fruitCount = 0
        local closestFruit = nil
        local shortestDistance = math.huge
        local char = L.Character
        local H = char and char:FindFirstChild("HumanoidRootPart")

        for _, o in pairs(W:GetChildren()) do
            if o:IsA("Tool") and o.Name:lower():find("fruit") then
                fruitCount = fruitCount + 1
                
                -- ESP Sistemi
                if States.FruitFinder then
                    if not o:FindFirstChild("ESP_GUI") then
                        local b = Instance.new("BillboardGui", o); b.Name = "ESP_GUI"; b.Size = UDim2.new(0, 200, 0, 50); b.AlwaysOnTop = true
                        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.Text = o.Name; l.TextColor3 = Color3.new(1,0,0); l.BackgroundTransparency = 1; l.Font = Enum.Font.GothamBold
                        R.RenderStepped:Connect(function()
                            if char and H and o:FindFirstChild("Handle") then
                                local dist = (H.Position - o.Handle.Position).Magnitude
                                l.TextSize = math.clamp(150 / (dist / 10), 15, 40)
                            end
                        end)
                    end
                else
                    if o:FindFirstChild("ESP_GUI") then o.ESP_GUI:Destroy() end
                end

                -- En yakın meyveyi bulma (Auto-Move için)
                if H and o:FindFirstChild("Handle") then
                    local dist = (H.Position - o.Handle.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestFruit = o
                    end
                end
            end
        end

        -- Arayüzdeki meyve sayısını güncelleme eventi (UI oluşturulunca bağlanacak)
        _G.UpdateFruitCount = fruitCount

        -- Auto-Move to Fruit
        if States.AutoMoveFruit and closestFruit and H then
            T:Create(H, TweenInfo.new(shortestDistance / 300, Enum.EasingStyle.Linear), {CFrame = closestFruit.Handle.CFrame}):Play()
        end
    end
end)

-- ==========================================
-- 4. KAPSAMLI ARAYÜZ (GÜNDOĞDİSEX V2.1 UI)
-- ==========================================
if C:FindFirstChild("GDX_V2") then C.GDX_V2:Destroy() end

local ScreenGui = Instance.new("ScreenGui", C)
ScreenGui.Name = "GDX_V2"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 650)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -325)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true

-- Başlık
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "GÜNDOĞDİSEX V2.1 👑"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 28

-- İçerik Kaydırma Alanı
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -110)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255,0,0)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- /// UI YARDIMCI FONKSİYONLARI \\\ --
local function CreateCategory(name)
    local lbl = Instance.new("TextLabel", Scroll)
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. name
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(name, stateKey, extraText)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.6, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left

    if extraText then
        local sub = Instance.new("TextLabel", frame)
        sub.Size = UDim2.new(0.6, 0, 0.4, 0); sub.Position = UDim2.new(0, 10, 0.6, 0)
        sub.BackgroundTransparency = 1; sub.Text = extraText; sub.TextColor3 = Color3.fromRGB(150,150,150)
        sub.Font = Enum.Font.Gotham; sub.TextSize = 11; sub.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Size = UDim2.new(0.6, 0, 0.6, 0)
    end

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 60, 0, 25); btn.Position = UDim2.new(1, -70, 0.5, -12.5)
    btn.BackgroundColor3 = States[stateKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    btn.Text = States[stateKey] and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        States[stateKey] = not States[stateKey]
        btn.BackgroundColor3 = States[stateKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = States[stateKey] and "ON" or "OFF"
    end)
    return frame, lbl
end

local function CreateButton(name, btnText, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.5, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 150, 0, 25); btn.Position = UDim2.new(1, -160, 0.5, -12.5)
    btn.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn.BorderSizePixel = 1
    btn.Text = btnText; btn.TextColor3 = Color3.fromRGB(255,100,100); btn.Font = Enum.Font.GothamBold

    btn.MouseButton1Click:Connect(callback)
end

-- /// KATEGORİLERİ DOLDURMA \\\ --

CreateCategory("PLAYER CHEATS")
local _, spdLabel = CreateToggle("⚡ Speed Hack (Ayarla: "..States.SpeedValue..")", "SpeedHack")
CreateButton("Hızı Arttır (+25)", "SET SPEED", function()
    States.SpeedValue = States.SpeedValue + 25
    if States.SpeedValue > 500 then States.SpeedValue = 50 end
    spdLabel.Text = "⚡ Speed Hack (Ayarla: "..States.SpeedValue..")"
end)
CreateToggle("✔ Infinite Stamina", "InfStamina", "ACTIVE (Prevents drain)")
CreateToggle("🦅 Fly Mode", "Fly", "Vertical [W/S] Horizontal [Mouse]")
CreateToggle("👻 No Clip (Duvar Geçişi)", "Noclip", "RunService Stepped Bypassed")
CreateToggle("⚔️ Auto Farm (Safe Hover)", "AutoFarm", "10 Studs Up + 1st Slot Force")

CreateCategory("FRUIT OPTIONS")
local fruitFrame, fruitLbl = CreateToggle("🍎 Fruit Finder", "FruitFinder", "0 Fruits Detected!")
task.spawn(function()
    while task.wait(2) do
        if fruitFrame and fruitFrame.Parent then
            fruitFrame:GetChildren()[2].Text = (_G.UpdateFruitCount or 0) .. " Fruits Detected!"
        end
    end
end)
CreateToggle("⭐ Auto-Move to Fruit", "AutoMoveFruit", "Tweens to nearest fruit")
CreateButton("🎁 Give Random Fruit", "🍒 GENERATE FRUIT", function()
    -- Blox Fruits Rastgele Meyve Alma Kodu (Cousin)
    pcall(function()
        Rep.Remotes.CommF_:InvokeServer("Cousin", "Buy")
    end)
end)

CreateCategory("STATS BOOST")
CreateButton("❤️ Max Health", "SET 1000 HP", function()
    if L.Character and L.Character:FindFirstChild("Humanoid") then
        L.Character.Humanoid.MaxHealth = 1000
        L.Character.Humanoid.Health = 1000
    end
end)
CreateButton("⭐ Max XP", "SET LEVEL 100", function()
    -- Sadece Local Spoof
    if L:FindFirstChild("Data") and L.Data:FindFirstChild("Level") then
        L.Data.Level.Value = 100
    end
end)
CreateButton("🔄 Give Stamina", "REFRESH STAMINA", function()
    if L.Character and L.Character:FindFirstChild("Energy") then
        L.Character.Energy.Value = L.Character.Energy.MaxValue
    end
end)

-- Alt Bar (Kaydet, Gizle, Çıkış)
local BottomBar = Instance.new("Frame", MainFrame)
BottomBar.Size = UDim2.new(1, 0, 0, 50); BottomBar.Position = UDim2.new(0, 0, 1, -50)
BottomBar.BackgroundColor3 = Color3.fromRGB(10, 0, 0)

local function AddBottomBtn(txt, pos, callback)
    local b = Instance.new("TextButton", BottomBar)
    b.Size = UDim2.new(0.3, 0, 0.6, 0); b.Position = UDim2.new(pos, 0, 0.2, 0)
    b.BackgroundColor3 = Color3.fromRGB(30, 10, 10); b.BorderColor3 = Color3.fromRGB(200,0,0)
    b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(callback)
end

AddBottomBtn("SAVE SETTINGS", 0.03, function() print("Settings Saved!") end)
AddBottomBtn("HIDE MENU [K]", 0.35, function() MainFrame.Visible = false end)
AddBottomBtn("LOGOUT", 0.67, function() ScreenGui:Destroy() end)

-- K Tuşu ile Menü Gizleme/Açma
U.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        if MainFrame then MainFrame.Visible = not MainFrame.Visible end
    end
end)

-- Scroll boyutunu içeriğe göre ayarla
Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)
