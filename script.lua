-- // GÜNDOĞDİSEX V3.5 - ULTIMATE APEX EDITION (STABLE & CONFLICT-FREE) \\
-- Bütün çakışmalar giderildi, Mutex öncelik motoru eklendi.
-- Ekrana sürüklenebilir aç/kapat (Toggle) butonu entegre edildi.
-- Otomatik Takım Seçme sistemi başarıyla birleştirildi.

-- ==========================================
-- 0. KULLANICI AYARLARI (TEAM SELECT)
-- ==========================================
_G.Marine = true -- Eğer Korsan (Pirate) olmak istersen bunu false, _G.Pirate'i true yap.
_G.Pirate = false

-- ==========================================
-- 1. SERVİSLER, DEĞİŞKENLER VE MUTEX KİLİDİ
-- ==========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui") or Players.LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

local States = {
    SpeedHack = false, SpeedValue = 75,
    InfStamina = false, Noclip = false,
    FruitFinder = false, AutoMoveFruit = false,
    AutoFarm = false, AutoQuest = false, MobAura = false, FastAttack = false,
    AutoChest = false, AutoFish = false, AutoFishQuest = false
}

-- ÇAKIŞMA ÖNLEYİCİ MUTEX 
local ActiveTask = "NONE" 
local _UpdateFruitCount = 0
local CachedChests = {}
local CachedFruits = {}
local SafePlatform = nil

-- Güvenli Uçan Platform
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

-- ==========================================
-- 2. TEAM SELECT & ANTI-AFK ENGINE (V2.4 ENTEGRASYONU)
-- ==========================================
task.spawn(function()
    while true do
        task.wait(60)
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local chooseTeamGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam")
            if chooseTeamGui and chooseTeamGui.Visible then
                local teamButton
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
                    VirtualUser:Button1Down(Vector2.new(99,99))
                    VirtualUser:Button1Up(Vector2.new(99,99))
                end
            end
        end)
    end
end)

-- ==========================================
-- 3. AKILLI ÖNBELLEKLEME (CACHE) MOTORU
-- ==========================================
task.spawn(function()
    while true do
        if States.AutoChest or States.FruitFinder or States.AutoMoveFruit then
            local tempChests, tempFruits = {}, {}
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
            CachedChests = tempChests
            CachedFruits = tempFruits
        end
        task.wait(1)
    end
end)

-- ==========================================
-- 4. HİLE VE FİZİK MOTORLARI (SPEED, NOCLIP)
-- ==========================================
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

-- ==========================================
-- 5. AKILLI GÖREV & YÜKSEK HASARLI OTO-FARM
-- ==========================================
local QuestDatabase = {
    {Level = 1, QuestName = "BanditQuest1", LevelReq = 1, MobName = "Bandit"},
    {Level = 15, QuestName = "JungleQuest", LevelReq = 1, MobName = "Monkey"},
    {Level = 30, QuestName = "JungleQuest", LevelReq = 2, MobName = "Gorilla"},
    {Level = 60, QuestName = "DesertQuest", LevelReq = 1, MobName = "Desert Bandit"},
    {Level = 90, QuestName = "SnowQuest", LevelReq = 1, MobName = "Snow Bandit"},
    {Level = 120, QuestName = "MarineQuest2", LevelReq = 1, MobName = "Chief Petty Officer"},
    {Level = 150, QuestName = "SkyQuest", LevelReq = 1, MobName = "Sky Bandit"},
    {Level = 700, QuestName = "Area2Quest", LevelReq = 1, MobName = "Raider"},
    {Level = 1500, QuestName = "Sea3Quest", LevelReq = 1, MobName = "Pirate Millionaire"}
}

local function GetBestQuest()
    local myLevel = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") and LocalPlayer.Data.Level.Value or 1
    local bestQuest = QuestDatabase[1]
    for _, q in ipairs(QuestDatabase) do
        if myLevel >= q.Level then bestQuest = q end
    end
    return bestQuest
end

task.spawn(function()
    while true do
        task.wait(0.05)
        if (States.AutoFarm or States.AutoQuest) and States.MobAura then
            pcall(function()
                local char = LocalPlayer.Character
                local H = char and char:FindFirstChild("HumanoidRootPart")
                if H and Workspace:FindFirstChild("Enemies") then
                    for _, mob in Workspace.Enemies:GetChildren() do
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
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

-- ==========================================
-- 6. OTO BALIK TUTMA
-- ==========================================
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

-- ==========================================
-- 7. KİLİTLENMEYEN OTO SANDIK & MEYVE ESP
-- ==========================================
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
                        if dist < shortest then
                            shortest = dist; closestChest = v; targetIndex = idx
                        end
                    end
                end
                
                if closestChest then
                    local tweenTime = math.clamp(shortest / 350, 0.05, 0.8)
                    local movementTween = TweenService:Create(H, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = closestChest.CFrame})
                    movementTween:Play()
                    
                    if firetouchinterest then
                        firetouchinterest(H, closestChest, 0)
                        firetouchinterest(H, closestChest, 1)
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

-- ==========================================
-- 8. GÜNDOĞDİSEX YENİ NESİL ARAYÜZ (EKRAN SİMGESİ EKLENDİ)
-- ==========================================
if CoreGui:FindFirstChild("GDX_V3_Panel") then CoreGui.GDX_V3_Panel:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GDX_V3_Panel"
ScreenGui.ResetOnSpawn = false

-- 8.1 EKRANDA DURAN AÇ/KAPAT (TOGGLE) LOGOSU
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 8, 8)
ToggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Text = "GDX"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 16
ToggleBtn.Active = true
ToggleBtn.Draggable = true -- MOBİL & PC İÇİN SÜRÜKLENEBİLİR!
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- 8.2 ANA PANEL (GİZLENEBİLİR)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 600)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 8)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false -- BAŞLANGIÇTA KAPALI, GDX LOGOSUNA TIKLAYINCA AÇILACAK

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45); Title.BackgroundTransparency = 1; Title.Text = "GÜNDOĞDİSEX V3.5 APEX 👑"
Title.TextColor3 = Color3.fromRGB(255, 50, 50); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 22

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -110); Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 6; Scroll.ScrollBarImageColor3 = Color3.fromRGB(255,0,0)

local UIList = Instance.new("UIListLayout", Scroll); UIList.Padding = UDim.new(0, 8); UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateCategory(name)
    local lbl = Instance.new("TextLabel", Scroll); lbl.Size = UDim2.new(1, 0, 0, 28); lbl.BackgroundTransparency = 1
    lbl.Text = "  ■ " .. name; lbl.TextColor3 = Color3.fromRGB(255, 180, 180); lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 15; lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(name, stateKey, extraText)
    local frame = Instance.new("Frame", Scroll); frame.Size = UDim2.new(1, 0, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(25, 12, 12)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(0.65, 0, extraText and 0.55 or 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = name; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left

    if extraText then
        local sub = Instance.new("TextLabel", frame); sub.Size = UDim2.new(0.65, 0, 0.45, 0); sub.Position = UDim2.new(0, 10, 0.55, 0)
        sub.BackgroundTransparency = 1; sub.Text = extraText; sub.TextColor3 = Color3.fromRGB(170,170,170); sub.Font = Enum.Font.Gotham; sub.TextSize = 10; sub.TextXAlignment = Enum.TextXAlignment.Left
    end

    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 70, 0, 28); btn.Position = UDim2.new(1, -80, 0.5, -14)
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

-- MENÜ İÇERİKLERİ
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

-- MEYVE SAYACI
task.spawn(function()
    while true do
        task.wait(1)
        if fruitFrame and fruitFrame.Parent then
            fruitFrame:GetChildren()[2].Text = _UpdateFruitCount .. " Meyve Algılandı!"
        end
    end
end)

-- ALT KONTROL BAR
local BottomBar = Instance.new("Frame", MainFrame); BottomBar.Size = UDim2.new(1, 0, 0, 45); BottomBar.Position = UDim2.new(0, 0, 1, -45); BottomBar.BackgroundColor3 = Color3.fromRGB(10, 5, 5)
local function AddBottomBtn(txt, pos, cb)
    local b = Instance.new("TextButton", BottomBar); b.Size = UDim2.new(0.3, 0, 0.7, 0); b.Position = UDim2.new(pos, 0, 0.15, 0)
    b.BackgroundColor3 = Color3.fromRGB(40, 10, 10); b.BorderColor3 = Color3.fromRGB(200,0,0); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); b.MouseButton1Click:Connect(cb)
end

AddBottomBtn("PANELİ KAPAT", 0.03, function() MainFrame.Visible = false end)
AddBottomBtn("KONSOL [F9]", 0.35, function() pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", true) end) end)
AddBottomBtn("AĞI TEMİZLE", 0.67, function() CachedChests = {}; CachedFruits = {} end)

Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)
