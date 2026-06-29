-- // GÜNDOĞDİSEX V2.5 - MASSIVE PRO ULTIMATE EDITION (HYPER-OPTIMIZED & STABLE) \\

-- ==========================================
-- 0. MEYVE EMOLARI VE İŞARETLERİ
-- ==========================================
local FruitIcons = {
    ["Kitsune"]  = "🦊 Kitsune", ["Leopard"]  = "🐆 Leopard", ["Dragon"]   = "🐉 Dragon",
    ["T-Rex"]    = "🦖 T-Rex", ["Dough"]    = "🍩 Dough", ["Mammoth"]  = "🦣 Mammoth",
    ["Spirit"]   = "👻 Spirit", ["Venom"]    = "🧪 Venom", ["Control"]  = "🕹️ Control",
    ["Shadow"]   = "🖤 Shadow", ["Gravity"]  = "🪐 Gravity", ["Blizzard"] = "❄️ Blizzard",
    ["Pain"]     = "💥 Pain", ["Rumble"]   = "⚡ Rumble", ["Portal"]   = "🌀 Portal",
    ["Phoenix"]  = "🦅 Phoenix", ["Sound"]    = "🎵 Sound", ["Spider"]   = "🕸️ Spider",
    ["Love"]     = "💖 Love", ["Buddha"]   = "🔱 Buddha", ["Quake"]    = "🫨 Quake",
    ["Magma"]    = "🌋 Magma", ["Ghost"]    = "👻 Ghost", ["Barrier"]  = "🚧 Barrier",
    ["Rubber"]   = "🎈 Rubber", ["Light"]    = "✨ Light", ["Diamond"]  = "💎 Diamond",
    ["Dark"]     = "🌙 Dark", ["Sand"]     = "⏳ Sand", ["Ice"]      = "🧊 Ice",
    ["Falcon"]   = "🦅 Falcon", ["Flame"]    = "🔥 Flame", ["Spike"]    = "🌵 Spike",
    ["Smoke"]    = "💨 Smoke", ["Bomb"]     = "💣 Bomb", ["Spring"]   = " Springs",
    ["Chop"]     = "🪓 Chop", ["Spin"]     = "🌀 Spin", ["Rocket"]   = "🚀 Rocket",
    ["Default"]  = "🍎 Meyve" 
}

-- ==========================================
-- 1. SERVİSLER VE DEĞİŞKENLER
-- ==========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local States = {
    SpeedHack = false,
    SpeedValue = 75,
    InfStamina = false,
    Fly = false,
    FruitFinder = false,
    AutoMoveFruit = false,
    AutoFarm = false,
    AutoChest = false, 
    Noclip = false 
}

local _UpdateFruitCount = 0
local CachedChests = {}
local CachedFruits = {}

-- ==========================================
-- 2. TEAM SELECT & AUTO-DISCONNECT LOOP
-- ==========================================
task.spawn(function()
    local chooseTeamGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("ChooseTeam")
    while chooseTeamGui.Visible == true do
        task.wait(0.5)
        pcall(function()
            local teamButton = nil
            if _G.Marine then
                teamButton = chooseTeamGui.Container.Marines.Frame.ViewportFrame.TextButton
            else
                teamButton = chooseTeamGui.Container.Pirates.Frame.ViewportFrame.TextButton
            end
            
            if teamButton then
                teamButton.Size = UDim2.new(0, 10000, 0, 10000)
                teamButton.Position = UDim2.new(-4, 0, -5, 0)
                teamButton.BackgroundTransparency = 1
                task.wait(0.1)
                game:GetService("VirtualUser"):Button1Down(Vector2.new(99,99))
                game:GetService("VirtualUser"):Button1Up(Vector2.new(99,99))
            end
        end)
    end
end)

-- ==========================================
-- 3. HIGH-PERFORMANCE FPS BOOST
-- ==========================================
if _G.FPSBoost then
    task.spawn(function()
        task.wait(2)
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
        Workspace.Terrain.WaterReflectance = 0
        Workspace.Terrain.WaterTransparency = 0
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"
        
        for _, v in pcall(game.GetDescendants, game) and game:GetDescendants() or {} do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") or v:IsA("MeshPart") then 
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
                if v:IsA("MeshPart") then v.TextureID = "" end
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
        for _, e in Lighting:GetChildren() do
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end
    end)
end

-- ==========================================
-- 4. ARKA PLAN ÖNBELLEKLEME MOTORU (LAG ÖNLEYİCİ)
-- ==========================================
task.spawn(function()
    while true do
        if States.AutoChest or States.FruitFinder or States.AutoMoveFruit then
            local tempChests = {}
            local tempFruits = {}
            
            for _, v in Workspace:GetDescendants() do
                -- Sandık Filtreleme
                if States.AutoChest and v:IsA("BasePart") and string.find(v.Name, "Chest") then
                    if v.Parent and not v.Parent:FindFirstChild("Humanoid") and not v:IsDescendantOf(LocalPlayer.Character) then
                        table.insert(tempChests, v)
                    end
                -- Meyve Filtreleme
                elseif (States.FruitFinder or States.AutoMoveFruit) and (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") then
                    local nameLower = string.lower(v.Name)
                    if not string.find(nameLower, "dealer") and not string.find(nameLower, "gacha") then
                        local parent = v.Parent
                        if parent and not parent:FindFirstChild("Humanoid") and not string.find(string.lower(parent.Name), "npc") then
                            table.insert(tempFruits, v)
                        end
                    end
                end
            end
            CachedChests = tempChests
            CachedFruits = tempFruits
        end
        task.wait(1.5) -- Ağır tarama yükü 1.5 saniyeye düşürüldü. FPS düşüşü sıfırlandı.
    end
end)

-- ==========================================
-- 5. HİLE MOTORLARI & AYARLARI
-- ==========================================
local wasNoclip = false
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        if States.Noclip or States.AutoChest then
            wasNoclip = true
            for _, v in char:GetChildren() do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end
        elseif wasNoclip then
            wasNoclip = false
            for _, v in char:GetChildren() do
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
    if States.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local H = LocalPlayer.Character.HumanoidRootPart
        local D = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then D += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then D -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then D -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then D += Camera.CFrame.RightVector end
        H.CFrame += D * (States.SpeedValue / 20)
        H.Velocity = Vector3.new()
    end
end)

-- AUTO FARM MOTORU
task.spawn(function()
    while true do
        task.wait(0.1)
        if States.AutoFarm and Workspace:FindFirstChild("Enemies") then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                -- Otomatik Tool Kuşanma
                local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and tool.Parent == LocalPlayer.Backpack then
                    char.Humanoid:EquipTool(tool)
                end
                
                for _, n in Workspace.Enemies:GetChildren() do
                    if n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 and n:FindFirstChild("HumanoidRootPart") then
                        local H = char.HumanoidRootPart
                        H.CFrame = n.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        if tool then tool:Activate() end
                        break
                    end
                end
            end
        end
    end
end)

-- OTO SANDIK MOTORU (ÖNBELLEK TABANLI)
task.spawn(function()
    while true do
        task.wait(0.02)
        if States.AutoChest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local H = LocalPlayer.Character.HumanoidRootPart
                local closestChest = nil
                local shortest = math.huge
                
                for _, v in CachedChests do
                    if v and v.Parent then
                        local dist = (H.Position - v.Position).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closestChest = v
                        end
                    end
                end
                
                if closestChest then
                    local chestSpeed = 350
                    local tweenTime = math.clamp(shortest / chestSpeed, 0.05, 0.4)
                    local movementTween = TweenService:Create(H, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = closestChest.CFrame})
                    movementTween:Play()
                    
                    if firetouchinterest then
                        firetouchinterest(H, closestChest, 0)
                        firetouchinterest(H, closestChest, 1)
                    end
                    movementTween.Completed:Wait()
                else
                    task.wait(0.3)
                end
            end)
        end
    end
end)

-- FRUIT FINDER & ESP MOTORU (ÖNBELLEK TABANLI)
task.spawn(function()
    while true do
        task.wait(0.5)
        local char = LocalPlayer.Character
        local H = char and char:FindFirstChild("HumanoidRootPart")
        local fCount = 0
        local closestFruitPart = nil
        local shortestDistance = math.huge
        
        for _, o in CachedFruits do
            if o and o.Parent then
                local targetPart = o:FindFirstChild("Handle") or o:FindFirstChildOfClass("MeshPart") or o:FindFirstChildOfClass("Part")
                if targetPart then
                    fCount = fCount + 1
                    local cleanName = o.Name
                    local isMysterious = false
                    
                    if o:IsA("Model") then
                        cleanName = "❓ GİZEMLİ MEYVE ❓"
                        isMysterious = true
                    elseif o:IsA("Tool") then
                        cleanName = string.gsub(cleanName, " Fruit", "")
                        cleanName = string.gsub(cleanName, "Fruit ", "")
                        cleanName = string.gsub(cleanName, "Fruit", "")
                        cleanName = string.gsub(cleanName, "Blox", "")
                        cleanName = cleanName:match("^%s*(.-)%s*$") or cleanName
                    end
                    
                    local displayText = FruitIcons[cleanName] or (isMysterious and "❓ GİZEMLİ MEYVE" or "🍎 " .. cleanName)
                    
                    if States.FruitFinder then
                        local esp = o:FindFirstChild("ESP_GUI")
                        if not esp then
                            esp = Instance.new("BillboardGui", o)
                            esp.Name = "ESP_GUI"
                            esp.Size = UDim2.new(0, 150, 0, 50)
                            esp.AlwaysOnTop = true
                            esp.Adornee = targetPart
                            
                            local l = Instance.new("TextLabel", esp)
                            l.Name = "NameLabel"
                            l.Size = UDim2.new(1, 0, 1, 0)
                            l.BackgroundTransparency = 1
                            l.TextColor3 = isMysterious and Color3.fromRGB(255, 85, 0) or Color3.fromRGB(85, 255, 127)
                            l.TextStrokeTransparency = 0 
                            l.Font = Enum.Font.GothamBlack
                        end
                        
                        if H then
                            local dist = (H.Position - targetPart.Position).Magnitude
                            local lbl = esp:FindFirstChild("NameLabel")
                            if lbl then
                                lbl.Text = string.format("%s\n[%.0f m]", displayText, dist)
                                lbl.TextSize = math.clamp(150 / (dist / 10), 12, 22)
                            end
                            if dist < shortestDistance then
                                shortestDistance = dist
                                closestFruitPart = targetPart
                            end
                        end
                    else
                        if o:FindFirstChild("ESP_GUI") then o.ESP_GUI:Destroy() end
                    end
                end
            end
        end
        _UpdateFruitCount = fCount
        
        if States.AutoMoveFruit and closestFruitPart and H then
            local tweenTime = shortestDistance / 300 
            TweenService:Create(H, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = closestFruitPart.CFrame * CFrame.new(0, 3, 0)}):Play()
        end
    end
end)

-- ==========================================
-- 6. GÜNDOĞDİSEX V2.5 UI ARAYÜZÜ
-- ==========================================
if CoreGui:FindFirstChild("GDX_V2") then CoreGui.GDX_V2:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GDX_V2"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 700) 
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -350)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50); Title.BackgroundTransparency = 1
Title.Text = "GÜNDOĞDİSEX V2.5 👑"
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
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
end

-- MENÜ ELEMANLARI DOLDURULUYOR
CreateCategory("LOCAL ADMIN & SYSTEM")
CreateButton("🖥️ Open F9 Developer Console", "FORCE OPEN", function()
    pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", true) end)
end)
CreateButton("👑 Local God Mode (Invisible)", "EXECUTE", function()
    if LocalPlayer.Character then
        for _,v in char:GetDescendants() do
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
CreateToggle("💰 Ultra Auto Chest Farm", "AutoChest", "High-speed cached vector calculation!")

CreateCategory("🏝️ GELİŞMİŞ ADALARA TELEPORT")
local targetFolder = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("Locations") or Workspace:FindFirstChild("Locations") or Workspace:FindFirstChild("Islands")
local locationFound = false

if targetFolder then
    for _, island in targetFolder:GetChildren() do
        if island:IsA("BasePart") or island:IsA("Model") then
            locationFound = true
            local targetCFrame = island:IsA("BasePart") and island.CFrame or island:GetPivot()
            CreateButton("🏝️ " .. island.Name, "IŞINLAN", function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - targetCFrame.Position).Magnitude
                    local tweenTime = math.clamp(dist / 350, 0.5, 30)
                    TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = targetCFrame + Vector3.new(0, 150, 0)}):Play()
                end
            end)
        end
    end
end

if not locationFound then
    local backupIslands = {
        ["Starter Island"] = Vector3.new(979, 12, 1242),
        ["Middle Town"] = Vector3.new(-1184, 12, 1500),
        ["Jungle"] = Vector3.new(-1414, 12, -2824),
        ["Pirate Village"] = Vector3.new(-1115, 12, 3870),
        ["Desert"] = Vector3.new(1094, 12, 4212),
        ["Frozen Village"] = Vector3.new(1255, 12, -1254),
        ["Marine Fortress"] = Vector3.new(-3705, 12, 5635),
        ["Skypia (Sky)"] = Vector3.new(-1643, 812, -125),
        ["Prison"] = Vector3.new(4845, 12, 905),
        ["Magma Village"] = Vector3.new(-5230, 12, 8520)
    }
    for name, pos in backupIslands do
        CreateButton("🏝️ " .. name, "IŞINLAN (PRO)", function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                TweenService:Create(hrp, TweenInfo.new(4, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos + Vector3.new(0, 50, 0))}):Play()
            end
        end)
    end
end

CreateCategory("FRUIT OPTIONS")
local fruitFrame, fruitLbl = CreateToggle("🍎 Fruit Finder", "FruitFinder", "0 Fruits Detected!")
task.spawn(function()
    while true do
        task.wait(1.5)
        if fruitFrame and fruitFrame.Parent then
            fruitFrame:GetChildren()[2].Text = _UpdateFruitCount .. " Fruits Detected!"
        end
    end
end)
CreateToggle("⭐ Auto-Move to Fruit", "AutoMoveFruit", "Disable Chest Farm while using this!")
CreateButton("🎁 Give/Spawn Random Fruit", "🍒 ROLL FRUIT", function()
    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy") end)
end)

CreateCategory("STATS BOOST")
CreateButton("❤️ Max Health", "SET 1000 HP", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = 1000; LocalPlayer.Character.Humanoid.Health = 1000
    end
end)
CreateButton("⭐ Max XP", "SET LEVEL 100", function()
    if LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then LocalPlayer.Data.Level.Value = 100 end
end)
CreateButton("🔄 Give Stamina", "REFRESH STAMINA", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Energy") then LocalPlayer.Character.Energy.Value = LocalPlayer.Character.Energy.MaxValue end
end)

-- ALT BAR VE KAPATMA AYARLARI
local BottomBar = Instance.new("Frame", MainFrame)
BottomBar.Size = UDim2.new(1, 0, 0, 50); BottomBar.Position = UDim2.new(0, 0, 1, -50)
BottomBar.BackgroundColor3 = Color3.fromRGB(10, 0, 0)

local function AddBottomBtn(txt, pos, callback)
    local b = Instance.new("TextButton", BottomBar)
    b.Size = UDim2.new(0.3, 0, 0.6, 0); b.Position = UDim2.new(pos, 0, 0.2, 0)
    b.BackgroundColor3 = Color3.fromRGB(30, 10, 10); b.BorderColor3 = Color3.fromRGB(200,0,0)
    b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(callback)
end

AddBottomBtn("SAVE SETTINGS", 0.03, function() print("Settings Saved!") end)
AddBottomBtn("HIDE MENU [K]", 0.35, function() MainFrame.Visible = false end)
AddBottomBtn("LOGOUT", 0.67, function() ScreenGui:Destroy() end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        if MainFrame then MainFrame.Visible = not MainFrame.Visible end
    end
end)

-- CANVAS SIZE AUTO UPDATE
Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)
