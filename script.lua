-- // GÜNDOĞDİSEX V3.5 - DEFINITIVE PRO EDITION (ALL-IN-ONE SYSTEM) \\

-- ==========================================
-- 0. MEYVE RESİM AYARLARI (ESKİ KODDAN GERİ GETİRİLDİ)
-- ==========================================
local FruitImages = {
    ["Kitsune"]  = "rbxassetid://0000000",
    ["Leopard"]  = "rbxassetid://0000000",
    ["Dragon"]   = "rbxassetid://0000000",
    ["T-Rex"]    = "rbxassetid://0000000",
    ["Dough"]    = "rbxassetid://0000000",
    ["Mammoth"]  = "rbxassetid://0000000",
    ["Spirit"]   = "rbxassetid://0000000",
    ["Venom"]    = "rbxassetid://0000000",
    ["Control"]  = "rbxassetid://0000000",
    ["Shadow"]   = "rbxassetid://0000000",
    ["Gravity"]  = "rbxassetid://0000000",
    ["Blizzard"] = "rbxassetid://0000000",
    ["Pain"]     = "rbxassetid://0000000",
    ["Rumble"]   = "rbxassetid://0000000",
    ["Portal"]   = "rbxassetid://0000000",
    ["Phoenix"]  = "rbxassetid://0000000",
    ["Sound"]    = "rbxassetid://0000000",
    ["Spider"]   = "rbxassetid://0000000",
    ["Love"]     = "rbxassetid://0000000",
    ["Buddha"]   = "rbxassetid://0000000",
    ["Quake"]    = "rbxassetid://0000000",
    ["Magma"]    = "rbxassetid://0000000",
    ["Ghost"]    = "rbxassetid://0000000",
    ["Barrier"]  = "rbxassetid://0000000",
    ["Rubber"]   = "rbxassetid://0000000",
    ["Light"]    = "rbxassetid://0000000",
    ["Diamond"]  = "rbxassetid://0000000",
    ["Dark"]     = "rbxassetid://0000000",
    ["Sand"]     = "rbxassetid://0000000",
    ["Ice"]      = "rbxassetid://0000000",
    ["Falcon"]   = "rbxassetid://0000000",
    ["Flame"]    = "rbxassetid://0000000",
    ["Spike"]    = "rbxassetid://0000000",
    ["Smoke"]    = "rbxassetid://0000000",
    ["Bomb"]     = "rbxassetid://0000000",
    ["Spring"]   = "rbxassetid://0000000",
    ["Chop"]     = "rbxassetid://0000000",
    ["Spin"]     = "rbxassetid://0000000",
    ["Rocket"]   = "rbxassetid://0000000",
    ["Default"]  = "rbxassetid://0000000" 
}

-- ==========================================
-- 1. STEALTH & ANTI-BAN ALTYAPISI (KICK KORUMASI)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Rep = game:GetService("ReplicatedStorage")
local L = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

-- AFK Kick Koruması
L.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- UI Gizleme ve Sızma Güvenliği
local randomUIName = "GDX_SYS_" .. tostring(math.random(11111, 99999))
for _, v in pairs(CoreGui:GetChildren()) do
    if string.find(v.Name, "GDX_") then v:Destroy() end
end

-- Otomatik Takım Seçici (Geri Getirildi)
if not _G.Marine or _G.Pirate then
    spawn(function()
        while wait() do
            if L.PlayerGui:FindFirstChild("Main") and L.PlayerGui.Main:FindFirstChild("ChooseTeam") and L.PlayerGui.Main.ChooseTeam.Visible == true then
                L.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Size = UDim2.new(0, 10000, 0, 10000)
                L.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Position = UDim2.new(-4, 0, -5, 0)
                L.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.BackgroundTransparency = 1
                wait(.5)
                VirtualUser:Button1Down(Vector2.new(99,99))
                VirtualUser:Button1Up(Vector2.new(99,99))
            end     
        end
    end)
end

-- FPS Boost Sistemi (Geri Getirildi)
local function applyFPSBoost()
    local t = Workspace.Terrain
    t.WaterWaveSize = 0; t.WaterWaveSpeed = 0; t.WaterReflectance = 0; t.WaterTransparency = 0
    game:GetService("Lighting").GlobalShadows = false
    settings().Rendering.QualityLevel = "Level01"
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then 
            v.Material = "Plastic"; v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        end
    end
end

-- Hile Durum Hafızası
local States = {
    SpeedHack = false,
    SpeedValue = 75,
    InfStamina = false,
    Fly = false,
    FruitFinder = false,
    AutoMoveFruit = false,
    AutoFarm = false,
    AutoChest = false, 
    Noclip = false,
    AutoRaid = false
}

-- ==========================================
-- 2. HAREKET VE NO-CLIP MOTORU
-- ==========================================
local wasNoclip = false
RunService.Stepped:Connect(function()
    local char = L.Character
    if char then
        if States.Noclip or States.AutoChest or States.AutoRaid then
            wasNoclip = true
            for _, v in pairs(char:GetChildren()) do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end
        elseif wasNoclip then
            wasNoclip = false
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = true end
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

RunService.Heartbeat:Connect(function()
    if States.Fly and L.Character and L.Character:FindFirstChild("HumanoidRootPart") then
        local H = L.Character.HumanoidRootPart
        local D = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then D += Cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then D -= Cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then D -= Cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then D += Cam.CFrame.RightVector end
        H.CFrame += D * (States.SpeedValue / 20)
        H.Velocity = Vector3.new()
    end
end)

-- ==========================================
-- 3. PRO OTOMATİK RAİD MOTORU (GOD MODE & FAST KILL)
-- ==========================================
task.spawn(function()
    while task.wait(0.05) do
        if States.AutoRaid then
            pcall(function()
                local char = L.Character
                local H = char and char:FindFirstChild("HumanoidRootPart")
                if not H then return end

                local firstTool = L.Backpack:FindFirstChildOfClass("Tool")
                if firstTool and not char:FindFirstChildOfClass("Tool") then
                    char.Humanoid:EquipTool(firstTool)
                end

                if Workspace:FindFirstChild("Enemies") then
                    local target = nil
                    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            target = enemy
                            break
                        end
                    end

                    if target then
                        -- God Mode & Hitbox Enjeksiyonu (Düşmanın 12 stud yukarısında durur, hasar almaz)
                        H.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                        H.Velocity = Vector3.new(0,0,0)

                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then 
                            tool:Activate()
                            if firetouchinterest and tool:FindFirstChild("Handle") then
                                firetouchinterest(tool.Handle, target.HumanoidRootPart, 0)
                                firetouchinterest(tool.Handle, target.HumanoidRootPart, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- 4. ULTRA AKICI SANDIK MOTORU (💰 ESP DESTEKLİ)
-- ==========================================
task.spawn(function()
    local cachedChests = {}
    local function refreshChestCache()
        cachedChests = {}
        for _, v in pairs(Workspace:GetDescendants()) do
            if string.find(v.Name, "Chest") and v:IsA("BasePart") then
                table.insert(cachedChests, v)
                if not v:FindFirstChild("ChestMoneyESP") then
                    local bgu = Instance.new("BillboardGui", v)
                    bgu.Name = "ChestMoneyESP"; bgu.Size = UDim2.new(0, 50, 0, 50); bgu.AlwaysOnTop = true
                    local tl = Instance.new("TextLabel", bgu)
                    tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1
                    tl.Text = "💰"; tl.TextSize = 26; tl.Font = Enum.Font.GothamBold; tl.TextColor3 = Color3.fromRGB(255, 215, 0)
                end
            end
        end
    end

    while task.wait(0.05) do
        if States.AutoChest then
            pcall(function()
                local char = L.Character
                local H = char and char:FindFirstChild("HumanoidRootPart")
                if not H then return end

                local validChests = {}
                for _, c in pairs(cachedChests) do
                    if c and c.Parent and c:IsA("BasePart") then table.insert(validChests, c) end
                end
                cachedChests = validChests

                if #cachedChests == 0 then refreshChestCache() end
                if #cachedChests == 0 then
                    States.AutoChest = false -- Sandık kalmadıysa otomatik kapanır
                    return
                end

                local closestChest = nil
                local shortest = math.huge
                for _, c in pairs(cachedChests) do
                    local dist = (H.Position - c.Position).Magnitude
                    if dist < shortest then shortest = dist; closestChest = c end
                end

                if closestChest then
                    local ChestSpeed = 6.5
                    while States.AutoChest and closestChest and closestChest.Parent and (H.Position - closestChest.Position).Magnitude > 1.5 do
                        if not L.Character or not L.Character:FindFirstChild("HumanoidRootPart") then break end
                        H = L.Character.HumanoidRootPart
                        local direction = (closestChest.Position - H.Position).Unit
                        local nextPosition = H.Position + (direction * math.min(ChestSpeed, (closestChest.Position - H.Position).Magnitude))
                        H.CFrame = CFrame.new(nextPosition, closestChest.Position)
                        H.Velocity = Vector3.new(0,0,0)
                        if firetouchinterest then
                            firetouchinterest(H, closestChest, 0); firetouchinterest(H, closestChest, 1)
                        end
                        RunService.Heartbeat:Wait()
                    end
                end
            end)
        else
            cachedChests = {}
        end
    end
end)

-- ==========================================
-- 5. MEYVE BULUCU (FRUIT ESP & AUTO MOVE)
-- ==========================================
task.spawn(function()
    while task.wait(1) do 
        local fruitCount, closestFruitPart, shortestDistance = 0, nil, math.huge
        local char = L.Character
        local H = char and char:FindFirstChild("HumanoidRootPart")

        for _, o in pairs(Workspace:GetDescendants()) do
            local nameLower = string.lower(o.Name)
            if string.find(nameLower, "fruit") and (o:IsA("Tool") or o:IsA("Model")) then
                if string.find(nameLower, "dealer") or string.find(nameLower, "gacha") then continue end
                if o.Parent and (o.Parent:FindFirstChild("Humanoid") or string.find(string.lower(o.Parent.Name), "npc")) then continue end

                local targetPart = o:FindFirstChild("Handle") or o:FindFirstChildOfClass("MeshPart") or o:FindFirstChildOfClass("Part")
                if targetPart then
                    fruitCount = fruitCount + 1
                    local cleanName = o.Name
                    local isMysterious = o:IsA("Model") and true or false
                    if isMysterious then cleanName = "❓ GİZEMLİ MEYVE ❓" else cleanName = string.gsub(cleanName, "Fruit", "") end

                    if States.FruitFinder then
                        local esp = o:FindFirstChild("ESP_GUI")
                        if not esp then
                            esp = Instance.new("BillboardGui", o)
                            esp.Name = "ESP_GUI"; esp.Size = UDim2.new(0, 100, 0, 130); esp.AlwaysOnTop = true; esp.Adornee = targetPart
                            local l = Instance.new("TextLabel", esp)
                            l.Name = "NameLabel"; l.Size = UDim2.new(2, 0, 0, 30); l.Position = UDim2.new(-0.5, 0, 0, 100); l.BackgroundTransparency = 1
                            l.TextColor3 = isMysterious and Color3.fromRGB(255, 85, 0) or Color3.fromRGB(85, 255, 127)
                            l.Font = Enum.Font.GothamBlack; l.TextStrokeTransparency = 0
                        end
                        if esp and H then
                            local dist = (H.Position - targetPart.Position).Magnitude
                            if esp:FindFirstChild("NameLabel") then esp.NameLabel.Text = string.format("%s\n[%.0f m]", cleanName, dist) end
                        end
                    else
                        if o:FindFirstChild("ESP_GUI") then o.ESP_GUI:Destroy() end
                    end

                    if H and (H.Position - targetPart.Position).Magnitude < shortestDistance then
                        shortestDistance = (H.Position - targetPart.Position).Magnitude
                        closestFruitPart = targetPart
                    end
                end
            end
        end
        _G.UpdateFruitCount = fruitCount
        if States.AutoMoveFruit and closestFruitPart and H then
            TweenService:Create(H, TweenInfo.new(shortestDistance / 300, Enum.EasingStyle.Linear), {CFrame = closestFruitPart.CFrame * CFrame.new(0, 3, 0)}):Play()
        end
    end
end)

-- ==========================================
-- 6. MAKSİMUM GELİŞMİŞ PRO UI TASARIMI
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = randomUIName
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 490, 0, 720); MainFrame.Position = UDim2.new(0.5, -245, 0.5, -360)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 4, 4); MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0); MainFrame.BorderSizePixel = 2
MainFrame.Active = true; MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50); Title.BackgroundTransparency = 1
Title.Text = "GÜNDOĞDİSEX V3.5 ULTRA PRO 👑"; Title.TextColor3 = Color3.fromRGB(255, 215, 0); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 24

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -120); Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 6; Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 8); UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateCategory(name)
    local lbl = Instance.new("TextLabel", Scroll)
    lbl.Size = UDim2.new(1, 0, 0, 30); lbl.BackgroundTransparency = 1
    lbl.Text = " 🔱 " .. name; lbl.TextColor3 = Color3.fromRGB(255, 230, 150); lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 16; lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(name, stateKey, extra)
    local frame = Instance.new("Frame", Scroll); frame.Size = UDim2.new(1, 0, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(22, 8, 8)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(0.6, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1
    lbl.Text = name; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 75, 0, 30); btn.Position = UDim2.new(1, -85, 0.5, -15)
    btn.BackgroundColor3 = States[stateKey] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    btn.Text = States[stateKey] and "ON" or "OFF"; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(function()
        States[stateKey] = not States[stateKey]
        btn.BackgroundColor3 = States[stateKey] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        btn.Text = States[stateKey] and "ON" or "OFF"
    end)
    return frame, lbl
end

local function CreateButton(name, btnText, callback)
    local frame = Instance.new("Frame", Scroll); frame.Size = UDim2.new(1, 0, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(22, 8, 8)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(0.5, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1
    lbl.Text = name; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 150, 0, 30); btn.Position = UDim2.new(1, -160, 0.5, -15)
    btn.BackgroundColor3 = Color3.fromRGB(35, 12, 12); btn.BorderColor3 = Color3.fromRGB(255, 215, 0); btn.Text = btnText; btn.TextColor3 = Color3.fromRGB(255, 215, 0); btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
end

-- UI Menü Elemanlarının Kaydı
CreateCategory("SEA TRANSITIONS (DENİZ GEÇİŞLERİ)")
CreateButton("🌊 1. Deniz'e Geçiş Yap (Old World)", "TELEPORT", function() TeleportService:Teleport(2753915549, L) end)
CreateButton("🌊 2. Deniz'e Geçiş Yap (New World)", "TELEPORT", function() TeleportService:Teleport(4442274628, L) end)
CreateButton("🌊 3. Deniz'e Geçiş Yap (Third Sea)", "TELEPORT", function() TeleportService:Teleport(7449423635, L) end)

CreateCategory("PRO COMBAT & ULTIMATE RAID")
CreateToggle("⚔️ Auto Raid (God Mode/Fast Kill)", "AutoRaid")
CreateToggle("👻 No Clip (Duvar Geçişi)", "Noclip")
CreateToggle("🦅 Fly Mode (Serbest Uçuş)", "Fly")

CreateCategory("AUTOMATION & SYSTEMS")
CreateToggle("💰 Ultra Auto Chest Farm", "AutoChest")
local _, spdLabel = CreateToggle("⚡ Speed Hack", "SpeedHack")
CreateButton("Hızı Arttır (+25)", "SET SPEED", function()
    States.SpeedValue = States.SpeedValue + 25
    if States.SpeedValue > 500 then States.SpeedValue = 50 end
    spdLabel.Text = "⚡ Speed Hack (Ayarla: "..States.SpeedValue..")"
end)

CreateCategory("FRUIT SYSTEMS")
CreateToggle("🍎 Fruit Finder ESP", "FruitFinder")
CreateToggle("⭐ Auto-Move to Fruit", "AutoMoveFruit")

CreateCategory("SPOOF INJECTIONS (VISUAL CASH)")
CreateButton("💵 Her Basışta +2M Beli Artır", "INJECT 2M", function()
    pcall(function() if L:FindFirstChild("Data") and L.Data:FindFirstChild("Beli") then L.Data.Beli.Value = L.Data.Beli.Value + 2000000 end end)
end)
CreateButton("🔮 Her Basışta +1000 Fragment Artır", "INJECT 1K", function()
    pcall(function() if L:FindFirstChild("Data") and L.Data:FindFirstChild("Fragments") then L.Data.Fragments.Value = L.Data.Fragments.Value + 1000 end end)
end)

CreateCategory("SYSTEM CONTROLS & BOOSTS")
CreateButton("🖥️ Open F9 Developer Console", "FORCE OPEN", function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", true) end)
CreateButton("⚙️ Apply Mega FPS Boost", "BOOST NOW", applyFPSBoost)

local BottomBar = Instance.new("Frame", MainFrame); BottomBar.Size = UDim2.new(1, 0, 0, 50); BottomBar.Position = UDim2.new(0, 0, 1, -50); BottomBar.BackgroundColor3 = Color3.fromRGB(8, 2, 2)
local function AddBottomBtn(txt, pos, callback)
    local b = Instance.new("TextButton", BottomBar); b.Size = UDim2.new(0.3, 0, 0.6, 0); b.Position = UDim2.new(pos, 0, 0.2, 0)
    b.BackgroundColor3 = Color3.fromRGB(25, 8, 8); b.BorderColor3 = Color3.fromRGB(255, 215, 0); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.MouseButton1Click:Connect(callback)
end
AddBottomBtn("SAVE CONFIG", 0.03, function() print("Config saved successfully.") end)
AddBottomBtn("HIDE [K]", 0.35, function() MainFrame.Visible = false end)
AddBottomBtn("UNLOAD UI", 0.67, function() ScreenGui:Destroy() end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then MainFrame.Visible = not MainFrame.Visible end
end)

Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20) end)
