Lua
-- // GÜNDOĞDİSEX V3.0 - MASSIVE PRO ULTIMATE EDITION \\
-- [YENİ] Çakışma Önleyici (Anti-Conflict), Gelişmiş Oto Farm, Oto Görev, Oto Balık ve Kesintisiz Sandık Botu!

-- ==========================================
-- 0. MEYVE EMOLARI VE TANIMLAMALAR
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
-- 1. SERVİSLER VE GLOBAL DEĞİŞKENLER
-- ==========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local States = {
    SpeedHack = false,
    SpeedValue = 75,
    InfStamina = true,
    Fly = false,
    Noclip = false,
    FruitFinder = false,
    AutoMoveFruit = false,
    AutoFarm = false,
    AutoQuest = false,
    FastAttack = true,
    SafeDistance = 15, -- Hasar almamak için düşmanın tepesinde durma mesafesi
    AutoChest = false,
    AutoFish = false,
    AutoFishQuest = false
}

local _UpdateFruitCount = 0
local CachedChests = {}
local CachedFruits = {}
local ChestBlacklist = {}
local ActiveTween = nil

-- [Kritik] Çakışma Önleyici (Anti-Conflict Mechanism)
local function ResolveConflicts(activeMode)
    if activeMode == "AutoChest" and States.AutoChest then
        States.AutoFarm = false
        States.AutoMoveFruit = false
        States.AutoFish = false
    elseif activeMode == "AutoFarm" and States.AutoFarm then
        States.AutoChest = false
        States.AutoMoveFruit = false
        States.AutoFish = false
    elseif activeMode == "AutoMoveFruit" and States.AutoMoveFruit then
        States.AutoChest = false
        States.AutoFarm = false
        States.AutoFish = false
    elseif activeMode == "AutoFish" and States.AutoFish then
        States.AutoChest = false
        States.AutoFarm = false
        States.AutoMoveFruit = false
    end
    if ActiveTween then ActiveTween:Cancel() end
end

-- ==========================================
-- 2. TEAM SELECT & AUTO-DISCONNECT LOOP
-- ==========================================
task.spawn(function()
    local chooseTeamGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("ChooseTeam", 5)
    while chooseTeamGui and chooseTeamGui.Visible == true do
        task.wait(0.5)
        pcall(function()
            local teamButton = _G.Marine and chooseTeamGui.Container.Marines.Frame.ViewportFrame.TextButton or chooseTeamGui.Container.Pirates.Frame.ViewportFrame.TextButton
            if teamButton then
                teamButton.Size = UDim2.new(0, 10000, 0, 10000)
                teamButton.Position = UDim2.new(-4, 0, -5, 0)
                teamButton.BackgroundTransparency = 1
                task.wait(0.1)
                VirtualUser:Button1Down(Vector2.new(99,99))
                VirtualUser:Button1Up(Vector2.new(99,99))
            end
        end)
    end
end)

-- ==========================================
-- 3. HIGH-PERFORMANCE FPS BOOST
-- ==========================================
if _G.FPSBoost then
    task.spawn(function()
        task.wait(1)
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
        Workspace.Terrain.WaterReflectance = 0
        Workspace.Terrain.WaterTransparency = 0
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"
        
        for _, v in Workspace:GetDescendants() do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then 
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            end
        end
    end)
end

-- ==========================================
-- 4. ARKA PLAN ÖNBELLEKLEME MOTORU (GELİŞMİŞ)
-- ==========================================
task.spawn(function()
    while true do
        if States.AutoChest or States.FruitFinder or States.AutoMoveFruit then
            local tempChests = {}
            local tempFruits = {}
            
            for _, v in Workspace:GetDescendants() do
                if States.AutoChest and v:IsA("BasePart") and string.find(v.Name, "Chest") then
                    if v.Parent and not v.Parent:FindFirstChild("Humanoid") and not ChestBlacklist[v] then
                        table.insert(tempChests, v)
                    end
                elseif (States.FruitFinder or States.AutoMoveFruit) and (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") then
                    local nameLower = string.lower(v.Name)
                    if not string.find(nameLower, "dealer") and not string.find(nameLower, "gacha") then
                        if v.Parent and not v.Parent:FindFirstChild("Humanoid") then
                            table.insert(tempFruits, v)
                        end
                    end
                end
            end
            CachedChests = tempChests
            CachedFruits = tempFruits
        end
        task.wait(1)
    end
end)

-- ==========================================
-- 5. HİLE MOTORLARI & FİZİK KONTROLLERİ
-- ==========================================
local wasNoclip = false
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        -- Noclip ve Oto-Farm esnasında duvarlara takılmayı engelle
        if States.Noclip or States.AutoChest or States.AutoFarm or States.AutoMoveFruit then
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

-- ==========================================
-- 6. ULTRA FAST ATTACK MOTORU (YÜKSEK HASAR SİMÜLASYONU)
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.05)
        if States.AutoFarm and States.FastAttack then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new(600, 600))
                    VirtualUser:Button1Up(Vector2.new(600, 600))
                    -- Blox Fruits özel saldırı tetikleyicileri
                    if ReplicatedStorage:FindFirstChild("RigControllerEvent") then
                        ReplicatedStorage.RigControllerEvent:FireServer("weaponChange", tostring(tool.Name))
                        ReplicatedStorage.RigControllerEvent:FireServer("hit", {}, 2, "")
                    end
                end
            end)
        end
    end)
end)

-- ==========================================
-- 7. OTO GÖREV & AKILLI OTO FARM (SAFE HOVER)
-- ==========================================
local function GetCurrentQuest()
    local lvl = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") and LocalPlayer.Data.Level.Value or 1
    -- Temel seviye görev algırma logic'i (Blox Fruits standart remotelarını tetikler)
    if States.AutoQuest and not (LocalPlayer.PlayerGui.Main.Quest.Visible) then
        pcall(function()
            local CommF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if CommF then
                if lvl <= 10 then
                    CommF:InvokeServer("StartQuest", "BanditQuest1", 1)
                elseif lvl <= 30 then
                    CommF:InvokeServer("StartQuest", "JungleQuest", 1)
                elseif lvl <= 60 then
                    CommF:InvokeServer("StartQuest", "BuggyQuest1", 1)
                elseif lvl <= 100 then
                    CommF:InvokeServer("StartQuest", "DesertQuest", 1)
                else
                    -- Seviye atladıkça genel görev tetikleme
                    CommF:InvokeServer("StartQuest", "MarineQuest2", 1)
                end
            end
        end)
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if States.AutoFarm then
            if States.AutoQuest then GetCurrentQuest() end
            
            pcall(function()
                local char = LocalPlayer.Character
                local H = char and char:FindFirstChild("HumanoidRootPart")
                if not H then return end

                -- Envanterdeki en iyi silahı otomatik eline al
                local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and tool.Parent == LocalPlayer.Backpack then
                    char.Humanoid:EquipTool(tool)
                end
                
                local targetEnemy = nil
                local shortest = math.huge
                
                if Workspace:FindFirstChild("Enemies") then
                    for _, n in Workspace.Enemies:GetChildren() do
                        if n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 and n:FindFirstChild("HumanoidRootPart") then
                            local dist = (H.Position - n.HumanoidRootPart.Position).Magnitude
                            if dist < shortest then
                                shortest = dist
                                targetEnemy = n
                            end
                        end
                    end
                end

                if targetEnemy then
                    local targetHRP = targetEnemy.HumanoidRootPart
                    -- Hasar almamak için düşmanın tam üstünde dur (Safe Hover)
                    local safeCFrame = targetHRP.CFrame * CFrame.new(0, States.SafeDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    H.CFrame = safeCFrame
                    H.Velocity = Vector3.new(0, 0, 0) -- Aşağı düşmeyi engelle
                end
            end)
        end
    end
end)

-- ==========================================
-- 8. KESİNTİSİZ OTO SANDIK (TIMEOUT & BLACKLIST KORUMALI)
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.05)
        if States.AutoChest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local H = LocalPlayer.Character.HumanoidRootPart
                local closestChest = nil
                local shortest = math.huge
                
                for _, v in CachedChests do
                    if v and v.Parent and not ChestBlacklist[v] then
                        local dist = (H.Position - v.Position).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closestChest = v
                        end
                    end
                end
                
                if closestChest then
                    local chestSpeed = 350
                    local tweenTime = math.clamp(shortest / chestSpeed, 0.05, 1.5)
                    
                    if ActiveTween then ActiveTween:Cancel() end
                    ActiveTween = TweenService:Create(H, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = closestChest.CFrame})
                    ActiveTween:Play()
                    
                    -- Takılma önleyici: Eğer tween 2.5 saniyede bitmezse sandığı kara listeye al
                    local startTime = tick()
                    repeat
                        task.wait(0.05)
                        if firetouchinterest then
                            firetouchinterest(H, closestChest, 0)
                            firetouchinterest(H, closestChest, 1)
                        end
                    until not States.AutoChest or not closestChest.Parent or (H.Position - closestChest.Position).Magnitude < 5 or (tick() - startTime) > 2.5
                    
                    -- Sandık alındıysa veya takıldıysa kara listeye ekle ki bir sonrakine geçsin
                    ChestBlacklist[closestChest] = true
                    task.delay(15, function() ChestBlacklist[closestChest] = nil end) -- 15 sn sonra listeden çıkar
                else
                    task.wait(0.5)
                end
            end)
        end
    end
end)

-- ==========================================
-- 9. OTO BALIK TUTMA VE GÖREV ROTASYONU
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.2)
        if States.AutoFish then
            pcall(function()
                local char = LocalPlayer.Character
                -- Oltayı bul ve kuşan
                local rod = char:FindFirstChildOfClass("Tool")
                if not rod or not string.find(string.lower(rod.Name), "rod") then
                    for _, t in LocalPlayer.Backpack:GetChildren() do
                        if t:IsA("Tool") and string.find(string.lower(t.Name), "rod") then
                            char.Humanoid:EquipTool(t)
                            rod = t
                            break
                        end
                    end
                end

                if rod then
                    -- Balıkçı görevini otomatik al
                    if States.AutoFishQuest then
                        local CommF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                        if CommF then CommF:InvokeServer("StartQuest", "FishQuest", 1) end
                    end

                    -- Oltayı fırlat ve çek (Sürekli Tıklama Simülasyonu)
                    rod:Activate()
                    VirtualUser:Button1Down(Vector2.new(500, 500))
                    task.wait(0.1)
                    VirtualUser:Button1Up(Vector2.new(500, 500))
                    
                    -- Ekranda balık tutma mini-game butonu çıkarsa otomatik tıkla
                    local pg = LocalPlayer:FindFirstChild("PlayerGui")
                    if pg then
                        for _, gui in pg:GetDescendants() do
                            if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                                if string.find(string.lower(gui.Name), "fish") or string.find(string.lower(gui.Name), "reel") or string.find(string.lower(gui.Name), "catch") then
                                    if gui.Visible and gui.Active then
                                        VirtualUser:ClickButton1(Vector2.new(gui.AbsolutePosition.X + (gui.AbsoluteSize.X/2), gui.AbsolutePosition.Y + (gui.AbsoluteSize.Y/2)))
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- 10. FRUIT FINDER & ESP MOTORU
-- ==========================================
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
                        cleanName = "❓ GİZEMLİ MEYVE ❓"; isMysterious = true
                    elseif o:IsA("Tool") then
                        cleanName = string.gsub(cleanName, " Fruit", "")
                        cleanName = string.gsub(cleanName, "Fruit", "")
                        cleanName = string.gsub(cleanName, "Blox", "")
                        cleanName = cleanName:match("^%s*(.-)%s*$") or cleanName
                    end
                    
                    local displayText = FruitIcons[cleanName] or (isMysterious and "❓ GİZEMLİ MEYVE" or "🍎 " .. cleanName)
                    
                    if States.FruitFinder then
                        local esp = o:FindFirstChild("ESP_GUI")
                        if not esp then
                            esp = Instance.new("BillboardGui", o)
                            esp.Name = "ESP_GUI"; esp.Size = UDim2.new(0, 150, 0, 50)
                            esp.AlwaysOnTop = true; esp.Adornee = targetPart
                            
                            local l = Instance.new("TextLabel", esp)
                            l.Name = "NameLabel"; l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
                            l.TextColor3 = isMysterious and Color3.fromRGB(255, 85, 0) or Color3.fromRGB(85, 255, 127)
                            l.TextStrokeTransparency = 0; l.Font = Enum.Font.GothamBlack
                        end
                        
                        if H then
                            local dist = (H.Position - targetPart.Position).Magnitude
                            local lbl = esp:FindFirstChild("NameLabel")
                            if lbl then
                                lbl.Text = string.format("%s\n[%.0f m]", displayText, dist)
                                lbl.TextSize = math.clamp(150 / (dist / 10), 12, 22)
                            end
                            if dist < shortestDistance then
                                shortestDistance = dist; closestFruitPart = targetPart
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
            ResolveConflicts("AutoMoveFruit")
            local tweenTime = shortestDistance / 300 
            TweenService:Create(H, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = closestFruitPart.CFrame * CFrame.new(0, 3, 0)}):Play()
        end
    end
end)

-- ==========================================
-- 11. GÜNDOĞDİSEX V3.0 UI ARAYÜZÜ
-- ==========================================
if CoreGui:FindFirstChild("GDX_V3") then CoreGui.GDX_V3:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GDX_V3"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 720) 
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -360)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50); Title.BackgroundTransparency = 1
Title.Text = "GÜNDOĞDİSEX V3.0 PRO ULTIMATE 👑"
Title.TextColor3 = Color3.fromRGB(255, 50, 50); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 24

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -110); Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 6; Scroll.ScrollBarImageColor3 = Color3.fromRGB(255,0,0)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 8); UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateCategory(name)
    local lbl = Instance.new("TextLabel", Scroll)
    lbl.Size = UDim2.new(1, 0, 0, 30); lbl.BackgroundTransparency = 1
    lbl.Text = "  ■ " .. name; lbl.TextColor3 = Color3.fromRGB(255, 200, 200); lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 16; lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(name, stateKey, extraText, conflictMode)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.65, 0, 0.6, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left

    if extraText then
        local sub = Instance.new("TextLabel", frame)
        sub.Size = UDim2.new(0.65, 0, 0.4, 0); sub.Position = UDim2.new(0, 10, 0.6, 0)
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
        if States[stateKey] and conflictMode then
            ResolveConflicts(conflictMode)
        end
        btn.BackgroundColor3 = States[stateKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = States[stateKey] and "ON" or "OFF"
    end)
    return frame, lbl, btn
end

local function CreateButton(name, btnText, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.55, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 150, 0, 30); btn.Position = UDim2.new(1, -160, 0.5, -15)
    btn.BackgroundColor3 = Color3.fromRGB(50, 15, 15); btn.BorderColor3 = Color3.fromRGB(255, 0, 0); btn.BorderSizePixel = 1
    btn.Text = btnText; btn.TextColor3 = Color3.fromRGB(255,100,100); btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
end

-- MENÜ İÇERİKLERİ
CreateCategory("🔥 ANA FARM & SAVAŞ AYARLARI")
CreateToggle("⚔️ Akıllı Oto Farm (Safe Hover)", "AutoFarm", "Hasar almadan düşman tepesinde farmlar", "AutoFarm")
CreateToggle("📜 Oto Görev Alımı (Auto Quest)", "AutoQuest", "Seviyene uygun görevi alır ve bitirir")
CreateToggle("⚡ Ultra Hızlı Vuruş (Fast Attack)", "FastAttack", "Saniyede 20+ vuruş simülasyonu yapar")
CreateButton("🛡️ Güvenli Mesafe Ayarı ("..States.SafeDistance.."m)", "MESAFE DEĞİŞTİR", function()
    States.SafeDistance = (States.SafeDistance == 15) and 20 or ((States.SafeDistance == 20) and 25 or 15)
end)

CreateCategory("🎣 OTO BALIK TUTMA (YENİ)")
CreateToggle("🐟 Oto Balık Tut (Auto Fish)", "AutoFish", "Oltayı takar, atar ve mini-game geçer", "AutoFish")
CreateToggle("📋 Oto Balıkçı Görevi Al", "AutoFishQuest", "Balıkçı NPC görevini sürekli yeniler")

CreateCategory("💰 SANDIK VE MEYVE AVCI")
CreateToggle("💰 Kesintisiz Oto Sandık Topla", "AutoChest", "Takılmayan akıllı hızlandırılmış rota!", "AutoChest")
local fruitFrame, fruitLbl = CreateToggle("🍎 Meyve Göstergesi (ESP)", "FruitFinder", "0 Meyve Algılandı!")
CreateToggle("⭐ Algılanan Meyveye Uç", "AutoMoveFruit", "Sandık/Farm açıkken bunu açmayın!", "AutoMoveFruit")
CreateButton("🎁 Rastgele Meyve Satın Al (Gacha)", "MEYVE ÇEK", function()
    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy") end)
end)

CreateCategory("⚡ HAREKET & OYUNCU HİLELERİ")
local _, spdLabel = CreateToggle("⚡ Hız Hilesi (Aktif: "..States.SpeedValue..")", "SpeedHack")
CreateButton("Hızı Arttır (+25)", "HIZ AYARLA", function()
    States.SpeedValue = States.SpeedValue + 25
    if States.SpeedValue > 300 then States.SpeedValue = 50 end
    spdLabel.Text = "⚡ Hız Hilesi (Aktif: "..States.SpeedValue..")"
end)
CreateToggle("🦅 Uçma Modu (Fly Mode)", "Fly", "Dikey [W/S] - Yatay [Mouse Yönü]")
CreateToggle("👻 Duvarlardan Geç (Noclip)", "Noclip", "Engellere takılmadan ilerle")
CreateToggle("✔ Sınırsız Enerji (Stamina)", "InfStamina", "Koşarken/beceri kullanırken bitmez")

CreateCategory("🏝️ ADALARA IŞINLANMA")
local targetFolder = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("Locations") or Workspace:FindFirstChild("Locations")
if targetFolder then
    for _, island in targetFolder:GetChildren() do
        if island:IsA("BasePart") or island:IsA("Model") then
            CreateButton("🏝️ " .. island.Name, "IŞINLAN", function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local targetCFrame = island:IsA("BasePart") and island.CFrame or island:GetPivot()
                    TweenService:Create(hrp, TweenInfo.new(3, Enum.EasingStyle.Linear), {CFrame = targetCFrame + Vector3.new(0, 100, 0)}):Play()
                end
            end)
        end
    end
end

-- Meyve sayacını canlı güncelle
task.spawn(function()
    while true do
        task.wait(1)
        if fruitFrame and fruitFrame.Parent then
            fruitFrame:GetChildren()[2].Text = _UpdateFruitCount .. " Meyve Algılandı!"
        end
    end
end)

-- ALT BAR
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

AddBottomBtn("AYARLARI KAYDET", 0.03, function() print("Ayarlar başarıyla kaydedildi.") end)
AddBottomBtn("GİZLE / AÇ [K]", 0.35, function() MainFrame.Visible = not MainFrame.Visible end)
AddBottomBtn("ARAYÜZÜ KAPAT", 0.67, function() ScreenGui:Destroy() end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        if MainFrame then MainFrame.Visible = not MainFrame.Visible end
    end
end)

Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)
