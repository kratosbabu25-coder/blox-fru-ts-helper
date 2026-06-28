-- // GÜNDOĞDİSEX V2.1 - MASSIVE ULTIMATE EDITION (IMAGE ESP & FULL MAP SCAN) \\

-- ==========================================
-- 0. MEYVE RESİM AYARLARI (BURAYI KENDİNE GÖRE DOLDUR)
-- ==========================================
local FruitImages = {
    ["Kitsune"] = "rbxassetid://0000000",
    ["T-Rex"]   = "rbxassetid://0000000",
    ["Leopard"] = "rbxassetid://0000000",
    ["Dough"]   = "rbxassetid://0000000",
    ["Dragon"]  = "rbxassetid://0000000",
    ["Rumble"]  = "rbxassetid://0000000",
    ["Quake"]   = "rbxassetid://0000000",
    ["Buddha"]  = "rbxassetid://0000000",
    ["Portal"]  = "rbxassetid://0000000",
    ["Magma"]   = "rbxassetid://0000000",
    ["Light"]   = "rbxassetid://0000000",
    ["Ice"]     = "rbxassetid://0000000",
    ["Dark"]    = "rbxassetid://0000000",
    ["Flame"]   = "rbxassetid://0000000",
    ["Sand"]    = "rbxassetid://0000000",
    ["Rocket"]  = "rbxassetid://0000000",
    ["Spin"]    = "rbxassetid://0000000",
    ["Chop"]    = "rbxassetid://0000000",
    ["Default"] = "rbxassetid://0000000" 
}

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

local States = {
    SpeedHack = false,
    SpeedValue = 75,
    InfStamina = false,
    Fly = false,
    FruitFinder = false,
    AutoMoveFruit = false,
    AutoFarm = false,
    Noclip = false -- DÜZELTİLDİ: Artık otomatik açık gelmeyecek.
}

-- ==========================================
-- 3. HİLE MOTORLARI
-- ==========================================
local wasNoclip = false

R.Stepped:Connect(function()
    local char = L.Character
    if char then
        if States.Noclip then
            wasNoclip = true
            for _, v in pairs(char:GetChildren()) do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end
        elseif wasNoclip then
            wasNoclip = false
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end

        if States.SpeedHack and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = States.SpeedValue
        end
        if States.InfStamina and char:FindFirstChild("Energy") then 
            char.Energy.Value = char.Energy.MaxValue 
        end
    end
end)

R.Heartbeat:Connect(function()
    if States.Fly and L.Character and L.Character:FindFirstChild("HumanoidRootPart") then
        local H = L.Character.HumanoidRootPart
        local D = Vector3.new()
        if U:IsKeyDown(Enum.KeyCode.W) then D += Cam.CFrame.LookVector end
        if U:IsKeyDown(Enum.KeyCode.S) then D -= Cam.CFrame.LookVector end
        if U:IsKeyDown(Enum.KeyCode.A) then D -= Cam.CFrame.RightVector end
        if U:IsKeyDown(Enum.KeyCode.D) then D += Cam.CFrame.RightVector end
        H.CFrame += D * (States.SpeedValue / 20)
        H.Velocity = Vector3.new()
    end
end)

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

-- FRUIT FINDER & AUTO-MOVE
task.spawn(function()
    while task.wait(1) do 
        local fruitCount, closestFruitPart, shortestDistance = 0, nil, math.huge
        local char = L.Character
        local H = char and char:FindFirstChild("HumanoidRootPart")

        for _, o in pairs(W:GetDescendants()) do
            local nameLower = string.lower(o.Name)
            
            -- DÜZELTİLDİ: 'not o:FindFirstChild("Humanoid")' eklendi ki NPC'leri (meyve satıcısı vs.) bulmasın
            if string.find(nameLower, "fruit") and not o:FindFirstChild("Humanoid") and (o:IsA("Tool") or o:IsA("Model")) then
                local targetPart = o:FindFirstChild("Handle") or o:FindFirstChildOfClass("MeshPart") or o:FindFirstChildOfClass("Part")
                
                if targetPart then
                    fruitCount = fruitCount + 1
                    
                    local cleanName = o.Name
                    cleanName = string.gsub(cleanName, " Fruit", "")
                    cleanName = string.gsub(cleanName, "Fruit ", "")
                    cleanName = string.gsub(cleanName, "Fruit", "")
                    cleanName = string.gsub(cleanName, "Blox", "")
                    cleanName = cleanName:match("^%s*(.-)%s*$") 
                    
                    local isMysterious = false
                    if cleanName == "" then
                        cleanName = "❓ GİZEMLİ MEYVE ❓"
                        isMysterious = true
                    end

                    local iconImage = FruitImages["Default"]
                    if not isMysterious and FruitImages[cleanName] and FruitImages[cleanName] ~= "rbxassetid://0000000" then
                        iconImage = FruitImages[cleanName]
                    end

                    if States.FruitFinder then
                        local esp = o:FindFirstChild("ESP_GUI")
                        if not esp then
                            esp = Instance.new("BillboardGui", o)
                            esp.Name = "ESP_GUI"
                            esp.Size = UDim2.new(0, 100, 0, 130)
                            esp.AlwaysOnTop = true
                            esp.Adornee = targetPart 

                            local icon = Instance.new("ImageLabel", esp)
                            icon.Name = "Icon"
                            icon.Size = UDim2.new(1, 0, 0, 100)
                            icon.BackgroundTransparency = 1
                            icon.Image = iconImage

                            local l = Instance.new("TextLabel", esp)
                            l.Name = "NameLabel"
                            l.Size = UDim2.new(2, 0, 0, 30) 
                            l.Position = UDim2.new(-0.5, 0, 0, 100)
                            l.BackgroundTransparency = 1
                            
                            if isMysterious then
                                l.TextColor3 = Color3.fromRGB(255, 85, 0) 
                            else
                                l.TextColor3 = Color3.fromRGB(85, 255, 127) 
                            end
                            l.TextStrokeTransparency = 0 
                            l.Font = Enum.Font.GothamBlack
                        end

                        if esp and H then
                            local dist = (H.Position - targetPart.Position).Magnitude
                            local lbl = esp:FindFirstChild("NameLabel")
                            local iconUI = esp:FindFirstChild("Icon")
                            
                            if lbl then
                                lbl.Text = string.format("%s\n[%.0f m]", cleanName, dist)
                                lbl.TextSize = math.clamp(150 / (dist / 10), 12, 22)
                            end
                            if iconUI and iconUI.Image == "" or iconUI.Image == "rbxassetid://0000000" then
                                iconUI.Image = iconImage
                            end
                        end
                    else
                        if o:FindFirstChild("ESP_GUI") then o.ESP_GUI:Destroy() end
                    end

                    if H then
                        local dist = (H.Position - targetPart.Position).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestFruitPart = targetPart
                        end
                    end
                end
            end
        end
        _G.UpdateFruitCount = fruitCount
        
        if States.AutoMoveFruit and closestFruitPart and H then
            local tweenTime = shortestDistance / 300 -- Hız limiti kontrolü
            T:Create(H, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = closestFruitPart.CFrame}):Play()
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
MainFrame.Size = UDim2.new(0, 480, 0, 700) 
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -350)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true; MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50); Title.BackgroundTransparency = 1
Title.Text = "Hile kullanma oçun oğlinin oğli V2.1 👑"
Title.TextColor3 = Color3.fromRGB(255, 50, 50); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 28

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -110); Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 6; Scroll.ScrollBarImageColor3 = Color3.fromRGB(255,0,0)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 8); UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateCategory(name)
    local lbl = Instance.new("TextLabel", Scroll)
    lbl.Size = UDim2.new(1, 0, 0, 30); lbl.BackgroundTransparency = 1
    lbl.Text = "  ■ " .. name; lbl.TextColor3 = Color3.fromRGB(255, 200, 200); lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 18; lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(name, stateKey, extraText)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.6, 0, 0.6, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left

    if extraText then
        local sub = Instance.new("TextLabel", frame)
        sub.Size = UDim2.new(0.6, 0, 0.4, 0); sub.Position = UDim2.new(0, 10, 0.6, 0)
        sub.BackgroundTransparency = 1; sub.Text = extraText; sub.TextColor3 = Color3.fromRGB(150,150,150)
        sub.Font = Enum.Font.Gotham; sub.TextSize = 11; sub.TextXAlignment = Enum.TextXAlignment.Left
    end

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 70, 0, 30); btn.Position = UDim2.new(1, -80, 0.5, -15)
    btn.BackgroundColor3 = States[stateKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    btn.Text = States[stateKey] and "ON" or "OFF"; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        States[stateKey] = not States[stateKey]
        btn.BackgroundColor3 = States[stateKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = States[stateKey] and "ON" or "OFF"
    end)
    return frame, lbl
end

local function CreateButton(name, btnText, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.5, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 160, 0, 30); btn.Position = UDim2.new(1, -170, 0.5, -15)
    btn.BackgroundColor3 = Color3.fromRGB(50, 15, 15); btn.BorderColor3 = Color3.fromRGB(255, 0, 0); btn.BorderSizePixel = 1
    btn.Text = btnText; btn.TextColor3 = Color3.fromRGB(255,100,100); btn.Font = Enum.Font.GothamBold

    btn.MouseButton1Click:Connect(callback)
end

CreateCategory("LOCAL ADMIN & SYSTEM")
CreateButton("🖥️ Open F9 Developer Console", "FORCE OPEN", function()
    pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", true) end)
end)
CreateButton("👑 Local God Mode (Invisible)", "EXECUTE", function()
    if L.Character then
        for _,v in pairs(L.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 1 end
        end
    end
end)

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

CreateCategory("TELEPORT LOCATIONS")
if W:FindFirstChild("_WorldOrigin") and W._WorldOrigin:FindFirstChild("Locations") then
    local islands = W._WorldOrigin.Locations:GetChildren()
    if #islands > 0 then
        for _, island in pairs(islands) do
            CreateButton("🏝️ " .. island.Name, "TELEPORT", function()
                local hrp = L.Character and L.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- DÜZELTİLDİ: Hedef konuma giderken mesafeye dayalı dinamik süre hesaplaması (Anti-cheat bypass)
                    local targetPos = island.CFrame + Vector3.new(0, 50, 0)
                    local dist = (hrp.Position - targetPos.Position).Magnitude
                    local tweenTime = math.clamp(dist / 300, 0.5, 45) -- 300 hız limiti, minimum 0.5s
                    
                    T:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = targetPos}):Play()
                end
            end)
        end
    else
        CreateButton("Adalar Yükleniyor...", "BEKLE", function() end)
    end
else
    CreateButton("Bilinmeyen Harita Sürümü", "HATA", function() end)
end

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
CreateButton("🎁 Give/Spawn Random Fruit", "🍒 ROLL FRUIT", function()
    pcall(function() Rep.Remotes.CommF_:InvokeServer("Cousin", "Buy") end)
end)

CreateCategory("STATS BOOST")
CreateButton("❤️ Max Health", "SET 1000 HP", function()
    if L.Character and L.Character:FindFirstChild("Humanoid") then
        L.Character.Humanoid.MaxHealth = 1000; L.Character.Humanoid.Health = 1000
    end
end)
CreateButton("⭐ Max XP", "SET LEVEL 100", function()
    if L:FindFirstChild("Data") and L.Data:FindFirstChild("Level") then L.Data.Level.Value = 100 end
end)
CreateButton("🔄 Give Stamina", "REFRESH STAMINA", function()
    if L.Character and L.Character:FindFirstChild("Energy") then L.Character.Energy.Value = L.Character.Energy.MaxValue end
end)

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

U.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        if MainFrame then MainFrame.Visible = not MainFrame.Visible end
    end
end)

Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)
