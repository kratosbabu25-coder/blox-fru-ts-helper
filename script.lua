-- // GÜNDOĞDİSEX V3.1 - UNIVERSAL UI FIX & APEX EDITION \\
-- CoreGui engeli aşıldı; Solara, Delta, Wave, Celery, Xeno vb. tüm executorlar ile %100 uyumlu.

-- ==========================================
-- 1. SERVİSLER VE EVRENSEL UI YÖNLENDİRİCİ
-- ==========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.1)
    LocalPlayer = Players.LocalPlayer
end

-- DÜZELTİLMİŞ KISIM: Tüm Executorlar İçin En Güvenli GUI Hedefi
local function GetGUIParent()
    -- 1. gethui() Testi
    if type(gethui) == "function" then
        local success, ui = pcall(function() return gethui() end)
        if success and ui then 
            return ui 
        end
    end
    
    -- 2. CoreGui Testi (Bazı executor'lar sahte CoreGui döner, test etmemiz şart)
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then
        local testSuccess, _ = pcall(function()
            local test = Instance.new("ScreenGui")
            test.Parent = coreGui
            test:Destroy()
        end)
        if testSuccess then 
            return coreGui 
        end
    end
    
    -- 3. Son Çare: PlayerGui (Her zaman %100 çalışır)
    return LocalPlayer:WaitForChild("PlayerGui", 10) or LocalPlayer:WaitForChild("PlayerGui")
end

local TargetParent = GetGUIParent()

-- ==========================================
-- 2. DEĞİŞKENLER VE MUTEX DURUM TABLOSU
-- ==========================================
local States = {
    SpeedHack = false, SpeedValue = 75,
    InfStamina = false, Fly = false, Noclip = false,
    FruitFinder = false, AutoMoveFruit = false,
    AutoFarm = false, AutoQuest = false, MobAura = false, FastAttack = false,
    AutoChest = false, AutoFish = false, AutoFishQuest = false
}

local ActiveTask = "NONE"
local _UpdateFruitCount = 0
local CachedChests = {}
local CachedFruits = {}
local SafePlatform = nil

-- ==========================================
-- 3. ARAYÜZ (UI) MOTORU - ANINDA YÜKLEME
-- ==========================================
-- Eski menüyü temizle (Eğer PlayerGui'ye atandıysa oradan da temizler)
pcall(function()
    for _, old in ipairs(TargetParent:GetChildren()) do
        if old.Name == "GDX_V3_APEX" then old:Destroy() end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GDX_V3_APEX"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = TargetParent

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 680)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -340)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 8)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "GÜNDOĞDİSEX V3.1 APEX 👑"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24

-- Özel Akıcı Sürükleme (Smooth Drag - Mobil & PC Uyumlu)
local dragging, dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -110)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateCategory(name)
    local lbl = Instance.new("TextLabel", Scroll)
    lbl.Size = UDim2.new(1, 0, 0, 28)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  ■ " .. name
    lbl.TextColor3 = Color3.fromRGB(255, 180, 180)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(name, stateKey, extraText)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(25, 12, 12)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.65, 0, extraText and 0.55 or 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    if extraText then
        local sub = Instance.new("TextLabel", frame)
        sub.Size = UDim2.new(0.65, 0, 0.45, 0)
        sub.Position = UDim2.new(0, 10, 0.55, 0)
        sub.BackgroundTransparency = 1
        sub.Text = extraText
        sub.TextColor3 = Color3.fromRGB(170, 170, 170)
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 10
        sub.TextXAlignment = Enum.TextXAlignment.Left
    end

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 70, 0, 28)
    btn.Position = UDim2.new(1, -80, 0.5, -14)
    btn.BackgroundColor3 = States[stateKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    btn.Text = States[stateKey] and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        States[stateKey] = not States[stateKey]
        btn.BackgroundColor3 = States[stateKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = States[stateKey] and "ON" or "OFF"
    end)
    return frame, lbl
end

-- MENÜ ELEMANLARI
CreateCategory("🚀 GELİŞMİŞ SAVAŞ & GÖREV (ÇAKIŞMA KORUMALI)")
CreateToggle("🤖 Akıllı Oto Görev (Smart Quest)", "AutoQuest", "Seviyene uygun görevi alır, durdurana kadar looplar.")
CreateToggle("⚔️ Oto Farm (Sıfır Hasar / Hover)", "AutoFarm", "Düşmanın tepesinde güvenli platformda vurur.")
CreateToggle("🧲 Mob Aura (Toplu Kesim / Bring)", "MobAura", "Etraftaki tüm mobları vurduğun yere kilitler.")
CreateToggle("⚡ Fast Attack (Seri Vuruş)", "FastAttack", "Saldırı hızını maksimuma çıkarır.")

CreateCategory("🎣 OTO BALIK VE BALIKÇI GÖREVİ")
CreateToggle("🐟 Oto Balık Tutma (Auto Fish)", "AutoFish", "Oltayı atar ve minigame'i hatasız tamamlar.")
CreateToggle("📜 Balıkçıdan Oto Görev Al", "AutoFishQuest", "Balık tutarken sürekli NPC'den görev yeniler.")

CreateCategory("💰 TOPLAMA & MEYVE (MUTEX KONTROLLÜ)")
CreateToggle("💰 Ultra Oto Sandık (No-Freeze)", "AutoChest", "Alınan sandık anında silinir, asla kilitlenmez!")
local fruitFrame = CreateToggle("🍎 Meyve Bulucu & ESP", "FruitFinder", "0 Meyve Algılandı!")
CreateToggle("⭐ Meyveye Otomatik Git", "AutoMoveFruit", "En yakın meyveye ışınlanır.")

CreateCategory("⚡ KARAKTER HİLELERİ")
CreateToggle("⚡ Hız Hilesi (Speed Hack)", "SpeedHack", "Walkspeed değerini artırır.")
CreateToggle("✔ Sınırsız Stamina", "InfStamina", "Enerjinin tükenmesini engeller.")
CreateToggle("👻 Duvarlardan Geçme (NoClip)", "Noclip", "Tüm engellerin içinden geçmeni sağlar.")

-- ALT KISAYOL BARI
local BottomBar = Instance.new("Frame", MainFrame)
BottomBar.Size = UDim2.new(1, 0, 0, 45)
BottomBar.Position = UDim2.new(0, 0, 1, -45)
BottomBar.BackgroundColor3 = Color3.fromRGB(10, 5, 5)

local function AddBottomBtn(txt, pos, cb)
    local b = Instance.new("TextButton", BottomBar)
    b.Size = UDim2.new(0.3, 0, 0.7, 0)
    b.Position = UDim2.new(pos, 0, 0.15, 0)
    b.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
    b.BorderColor3 = Color3.fromRGB(200, 0, 0)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(cb)
end

AddBottomBtn("GİZLE [K]", 0.03, function() MainFrame.Visible = false end)
AddBottomBtn("KONSOL [F9]", 0.35, function() pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", true) end) end)
AddBottomBtn("AĞI TEMİZLE", 0.67, function() CachedChests = {}; CachedFruits = {} end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.K then MainFrame.Visible = not MainFrame.Visible end
end)

Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)

-- ==========================================
-- 4. VERİTABANI VE YARDIMCI MOTORLAR
-- ==========================================
local QuestDatabase = {
    {Level = 1, QuestName = "BanditQuest1", LevelReq = 1, MobName = "Bandit", QuestNPC = "Bandit Quest Giver"},
    {Level = 15, QuestName = "JungleQuest", LevelReq = 1, MobName = "Monkey", QuestNPC = "Adventurer"},
    {Level = 30, QuestName = "JungleQuest", LevelReq = 2, MobName = "Gorilla", QuestNPC = "Adventurer"},
    {Level = 60, QuestName = "DesertQuest", LevelReq = 1, MobName = "Desert Bandit", QuestNPC = "Desert Adventurer"},
    {Level = 90, QuestName = "SnowQuest", LevelReq = 1, MobName = "Snow Bandit", QuestNPC = "Villager"},
    {Level = 120, QuestName = "MarineQuest2", LevelReq = 1, MobName = "Chief Petty Officer", QuestNPC = "Marine Notice"},
    {Level = 150, QuestName = "SkyQuest", LevelReq = 1, MobName = "Sky Bandit", QuestNPC = "Mad Scientist"},
    {Level = 700, QuestName = "Area2Quest", LevelReq = 1, MobName = "Raider", QuestNPC = "Quest Giver"},
    {Level = 1500, QuestName = "Sea3Quest", LevelReq = 1, MobName = "Pirate Millionaire", QuestNPC = "King Red Head"}
}

local function CreateSafePlatform()
    if not SafePlatform then
        SafePlatform = Instance.new("Part", Workspace)
        SafePlatform.Name = "GDX_SafePlatform"
        SafePlatform.Size = Vector3.new(10, 1, 10)
        SafePlatform.Anchored = true
        SafePlatform.CanCollide = true
        SafePlatform.Transparency = 1
    end
end

local function GetCurrentLevel()
    local success, lvl = pcall(function() return LocalPlayer.Data.Level.Value end)
    return success and lvl or 1
end

local function GetBestQuest()
    local myLevel = GetCurrentLevel()
    local bestQuest = QuestDatabase[1]
    for _, q in ipairs(QuestDatabase) do
        if myLevel >= q.Level then bestQuest = q end
    end
    return bestQuest
end

-- ==========================================
-- 5. ARKA PLAN DÖNGÜLERİ (ANTI-AFK, CACHE, FARM)
-- ==========================================
task.spawn(function()
    while true do
        task.wait(60)
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if fruitFrame and fruitFrame.Parent then
            fruitFrame:GetChildren()[2].Text = _UpdateFruitCount .. " Meyve Algılandı!"
        end
    end
end)

task.spawn(function()
    while true do
        if States.AutoChest or States.FruitFinder or States.AutoMoveFruit then
            local tempChests, tempFruits = {}, {}
            pcall(function()
                for _, v in Workspace:GetDescendants() do
                    if States.AutoChest and v:IsA("BasePart") and string.find(v.Name, "Chest") then
                        if v.Parent and not v.Parent:FindFirstChild("Humanoid") and not v:IsDescendantOf(LocalPlayer.Character) then
                            table.insert(tempChests, v)
                        end
                    elseif (States.FruitFinder or States.AutoMoveFruit) and (v:IsA("Tool") or v:IsA("Model")) and string.find(string.lower(v.Name), "fruit") then
                        local nameLower = string.lower(v.Name)
                        if not string.find(nameLower, "dealer") and not string.find(nameLower, "gacha") then
                            if v.Parent and not v.Parent:FindFirstChild("Humanoid") and not string.find(string.lower(v.Parent.Name), "npc") then
                                table.insert(tempFruits, v)
                            end
                        end
                    end
                end
            end)
            CachedChests = tempChests
            CachedFruits = tempFruits
        end
        task.wait(1)
    end
end)

local wasNoclip = false
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        if States.Noclip or States.AutoChest or States.AutoFarm or States.AutoQuest then
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

-- Mob Aura & Fast Attack
task.spawn(function()
    while true do
        task.wait(0.05)
        if (States.AutoFarm or States.AutoQuest) and States.MobAura then
            pcall(function()
                local char = LocalPlayer.Character
                local H = char and char:FindFirstChild("HumanoidRootPart")
                if H and Workspace:FindFirstChild("Enemies") then
                    for _, mob in Workspace.Enemies:GetChildren() do
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") do
                            if (mob.HumanoidRootPart.Position - H.Position).Magnitude < 250 then
                                mob.HumanoidRootPart.CFrame = H.CFrame * CFrame.new(0, -12, -3)
                                mob.HumanoidRootPart.CanCollide = false
                                mob.Humanoid.WalkSpeed = 0
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Ana Farm ve Görev Motoru (Mutex Öncelik: 1)
task.spawn(function()
    while true do
        task.wait(0.1)
        if States.AutoQuest or States.AutoFarm then
            ActiveTask = "FARMING"
            CreateSafePlatform()
            
            local char = LocalPlayer.Character
            local H = char and char:FindFirstChild("HumanoidRootPart")
            local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or (char and char:FindFirstChildOfClass("Tool"))
            
            if char and H and char:FindFirstChild("Humanoid") then
                if tool and tool.Parent == LocalPlayer.Backpack then
                    char.Humanoid:EquipTool(tool)
                end

                local targetMobName = nil
                if States.AutoQuest then
                    local currentQuest = GetBestQuest()
                    targetMobName = currentQuest.MobName
                    local questTracker = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                    if not questTracker or not questTracker.Visible then
                        pcall(function()
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.LevelReq)
                        end)
                        task.wait(0.5)
                    end
                end

                if Workspace:FindFirstChild("Enemies") then
                    local targetFound = false
                    for _, n in Workspace.Enemies:GetChildren() do
                        if n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 and n:FindFirstChild("HumanoidRootPart") then
                            if not targetMobName or string.find(n.Name, targetMobName) or not States.AutoQuest then
                                targetFound = true
                                local safeCFrame = n.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                H.CFrame = safeCFrame
                                SafePlatform.CFrame = H.CFrame * CFrame.new(0, -3, 0)
                                
                                if tool then
                                    tool:Activate()
                                    if States.FastAttack and pcall(function() return ReplicatedStorage.Remotes.CommF_ end) then
                                        VirtualUser:ClickButton1(Vector2.new(500, 500))
                                    end
                                end
                                break
                            end
                        end
                    end
                    if not targetFound and SafePlatform then SafePlatform.CFrame = CFrame.new(0, -500, 0) end
                end
            end
        else
            if ActiveTask == "FARMING" then ActiveTask = "NONE" end
            if SafePlatform then SafePlatform.CFrame = CFrame.new(0, -500, 0) end
        end
    end
end)

-- Oto Balık (Mutex Öncelik: 2)
task.spawn(function()
    while true do
        task.wait(0.2)
        if States.AutoFish and ActiveTask == "NONE" then
            ActiveTask = "FISHING"
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                if States.AutoFishQuest then
                    pcall(function()
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("FishermanQuest", "Start")
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "FishQuest", 1)
                    end)
                end
                local rod = LocalPlayer.Backpack:FindFirstChild("Fishing Rod") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                if rod and string.find(string.lower(rod.Name), "rod") then
                    char.Humanoid:EquipTool(rod)
                    rod = char:FindFirstChild(rod.Name)
                end
                if rod then
                    rod:Activate()
                    VirtualUser:ClickButton1(Vector2.new(500, 500))
                    pcall(function()
                        local fishGui = LocalPlayer.PlayerGui:FindFirstChild("Fishing") or LocalPlayer.PlayerGui:FindFirstChild("FishGUI")
                        if fishGui and fishGui.Enabled then
                            local btn = fishGui:FindFirstChildOfClass("ImageButton") or fishGui:FindFirstChildOfClass("TextButton", true)
                            if btn then VirtualUser:ClickButton1(Vector2.new(btn.AbsolutePosition.X, btn.AbsolutePosition.Y)) end
                            if fishGui:FindFirstChild("Progress") then fishGui.Progress.Value = 100 end
                        end
                    end)
                end
            end
        elseif ActiveTask == "FISHING" and not States.AutoFish then
            ActiveTask = "NONE"
        end
    end
end)

-- Oto Sandık (Mutex Öncelik: 4)
task.spawn(function()
    while true do
        task.wait(0.05)
        if States.AutoChest and ActiveTask == "NONE" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            ActiveTask = "CHESTING"
            pcall(function()
                local H = LocalPlayer.Character.HumanoidRootPart
                local closestChest, shortest, targetIndex = nil, math.huge, -1
                for idx, v in ipairs(CachedChests) do
                    if v and v.Parent and v:IsA("BasePart") then
                        local dist = (H.Position - v.Position).Magnitude
                        if dist < shortest then shortest = dist; closestChest = v; targetIndex = idx end
                    end
                end
                if closestChest then
                    local movementTween = TweenService:Create(H, TweenInfo.new(math.clamp(shortest / 350, 0.05, 0.8), Enum.EasingStyle.Linear), {CFrame = closestChest.CFrame})
                    movementTween:Play()
                    if firetouchinterest then
                        firetouchinterest(H, closestChest, 0); firetouchinterest(H, closestChest, 1)
                    end
                    movementTween.Completed:Wait()
                    if targetIndex ~= -1 then table.remove(CachedChests, targetIndex) end
                    closestChest:Destroy()
                else
                    task.wait(0.2)
                end
            end)
        elseif ActiveTask == "CHESTING" and not States.AutoChest then
            ActiveTask = "NONE"
        end
    end
end)

-- Meyve ESP ve Oto Gitme (Mutex Öncelik: 3)
task.spawn(function()
    while true do
        task.wait(0.5)
        local char = LocalPlayer.Character
        local H = char and char:FindFirstChild("HumanoidRootPart")
        local fCount, closestFruitPart, shortestDistance = 0, nil, math.huge
        
        for _, o in ipairs(CachedFruits) do
            if o and o.Parent then
                local targetPart = o:FindFirstChild("Handle") or o:FindFirstChildOfClass("MeshPart") or o:FindFirstChildOfClass("Part")
                if targetPart then
                    fCount = fCount + 1
                    local cleanName = o:IsA("Model") and "❓ GİZEMLİ MEYVE ❓" or string.gsub(o.Name, " Fruit", "")
                    if States.FruitFinder then
                        local esp = o:FindFirstChild("ESP_GUI") or Instance.new("BillboardGui", o)
                        if esp.Name ~= "ESP_GUI" then
                            esp.Name = "ESP_GUI"; esp.Size = UDim2.new(0, 150, 0, 50); esp.AlwaysOnTop = true; esp.Adornee = targetPart
                            local l = Instance.new("TextLabel", esp)
                            l.Name = "NameLabel"; l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
                            l.TextColor3 = Color3.fromRGB(85, 255, 127); l.Font = Enum.Font.GothamBlack
                        end
                        if H and esp:FindFirstChild("NameLabel") then
                            local dist = (H.Position - targetPart.Position).Magnitude
                            esp.NameLabel.Text = string.format("%s\n[%.0f m]", cleanName, dist)
                            if dist < shortestDistance then shortestDistance = dist; closestFruitPart = targetPart end
                        end
                    elseif o:FindFirstChild("ESP_GUI") then o.ESP_GUI:Destroy() end
                end
            end
        end
        _UpdateFruitCount = fCount
        if States.AutoMoveFruit and closestFruitPart and H and ActiveTask == "NONE" then
            ActiveTask = "FRUITING"
            TweenService:Create(H, TweenInfo.new(shortestDistance / 300, Enum.EasingStyle.Linear), {CFrame = closestFruitPart.CFrame * CFrame.new(0, 3, 0)}):Play()
        elseif ActiveTask == "FRUITING" and not States.AutoMoveFruit then
            ActiveTask = "NONE"
        end
    end
end)
