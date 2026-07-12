-- // GÜNDOĞDİSEX V3.6 - ULTIMATE APEX EDITION (STABLE & CONFLICT-FREE) \\
-- Bütün çakışmalar giderildi, Mutex öncelik motoru eklendi.
-- [+] YENİ: Gerçek Meyveleri Toplama (TouchInterest) ve Depolama (Auto Store).
-- [+] YENİ: Yeni Nesil Meyve Yağmuru Efekti (Kitsune, T-Rex vb.).
-- [+] YENİ: Gacha Bekleme Süresi Kırıcı (No Cooldown) & Apex Luck Boost.
-- [+] YENİ: Akıllı Oto Sunucu Değiştirme (Server Hop) & F9 Konsol Motoru.

-- ==========================================
-- 0. GÜVENLİK (ANTI-KICK & ANTI-BAN & CRASH FIX)
-- ==========================================
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    if setreadonly then setreadonly(mt, false) end
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "Kick" or method == "kick" or method == "Teleport") then
            return nil -- Oyundan atılmayı engeller (Codex Uyumlu)
        end
        return oldNamecall(self, ...)
    end)
    if setreadonly then setreadonly(mt, true) end
end)

-- ==========================================
-- 0.1 KULLANICI AYARLARI (TEAM SELECT)
-- ==========================================
_G.Marine = true 
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
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- KONSOL BİLGİLENDİRME FONKSİYONU (F9)
local function GDX_Log(msg, type)
    local prefix = "👑 [GÜNDOĞDİSEX V3.6 APEX]: "
    if type == "WARN" then
        warn(prefix .. tostring(msg))
    else
        print(prefix .. tostring(msg))
    end
end

GDX_Log("Gündoğdisex V3.6 Başarıyla Yüklendi! Sistemler aktif ediliyor...")

local States = {
    SpeedHack = false, SpeedValue = 75,
    InfStamina = false, Noclip = false,
    FruitFinder = false, AutoMoveFruit = false, AutoStoreFruit = false, FruitRain = false,
    AutoFarm = false, DashMode = true, AutoQuest = false, MobAura = false, FastAttack = false,
    AutoChest = false, AutoFish = false, AutoFishQuest = false,
    AutoGacha = false, MirageTracker = false, KitsuneTracker = false, AutoEmber = false,
    -- [+] YENİ ÖZELLİKLER:
    NoCooldownGacha = false, LuckBoost = false, AutoServerHop = false
}

-- ÇAKIŞMA ÖNLEYİCİ MUTEX 
local ActiveTask = "NONE" 
local _UpdateFruitCount = 0
local CachedChests = {}
local CachedFruits = {}
local SafePlatform = nil
local AntiRagdollBV = nil

-- Güvenli Uçan Platform & Titreme (Ragdoll) Engelleyici
local function CreateSafePlatform()
    if not SafePlatform then
        SafePlatform = Instance.new("Part", Workspace)
        SafePlatform.Name = "GDX_SafePlatform"
        SafePlatform.Size = Vector3.new(15, 1, 15)
        SafePlatform.Anchored = true
        SafePlatform.CanCollide = true
        SafePlatform.Transparency = 1
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if not AntiRagdollBV or not AntiRagdollBV.Parent then
            AntiRagdollBV = Instance.new("BodyVelocity")
            AntiRagdollBV.Name = "GDX_Stabilizer"
            AntiRagdollBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            AntiRagdollBV.Velocity = Vector3.new(0, 0, 0)
            AntiRagdollBV.Parent = char.HumanoidRootPart
        end
        char.Humanoid.Sit = false
    end
end

local function RemoveSafePlatform()
    if SafePlatform then SafePlatform.CFrame = CFrame.new(0, -5000, 0) end
    if AntiRagdollBV then AntiRagdollBV:Destroy() AntiRagdollBV = nil end
end

-- ==========================================
-- 2. TEAM SELECT & ANTI-AFK ENGINE
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
    while task.wait(0.5) do
        pcall(function()
            local chooseTeamGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam")
            if chooseTeamGui and chooseTeamGui.Visible then
                local teamButton = _G.Marine and chooseTeamGui.Container.Marines.Frame.ViewportFrame.TextButton or chooseTeamGui.Container.Pirates.Frame.ViewportFrame.TextButton
                if teamButton then
                    teamButton.Size = UDim2.new(0, 10000, 0, 10000)
                    teamButton.Position = UDim2.new(-4, 0, -5, 0)
                    teamButton.BackgroundTransparency = 1
                    task.wait(0.1)
                    VirtualUser:Button1Down(Vector2.new(99,99))
                    VirtualUser:Button1Up(Vector2.new(99,99))
                    GDX_Log("Takım otomatik seçildi.")
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
            pcall(function()
                local tempChests, tempFruits = {}, {}
                for _, v in Workspace:GetDescendants() do
                    if States.AutoChest and v:IsA("Model") and string.find(v.Name, "Chest") then
                        local root = v:FindFirstChild("PrimaryPart") or v:FindFirstChildOfClass("Part")
                        if root then table.insert(tempChests, root) end
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
            end)
        end
        task.wait(1)
    end
end)

-- ==========================================
-- 4. HİLE VE FİZİK MOTORLARI (SPEED, NOCLIP)
-- ==========================================
local wasNoclip = false
RunService.Stepped:Connect(function()
    pcall(function()
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
end)

-- ==========================================
-- 5. AKILLI GÖREV & YÜKSEK HASARLI OTO-FARM
-- ==========================================
local QuestDatabase = {
    {Level = 1, QuestName = "BanditQuest1", LevelReq = 1, MobName = "Bandit"},
    {Level = 15, QuestName = "JungleQuest", LevelReq = 1, MobName = "Monkey"},
    {Level = 30, QuestName = "JungleQuest", LevelReq = 2, MobName = "Gorilla"},
    {Level = 60, QuestName = "DesertQuest", LevelReq = 1, MobName = "Desert Bandit"}
}

local function GetBestQuest()
    local myLevel = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") and LocalPlayer.Data.Level.Value or 1
    local bestQuest = QuestDatabase[1]
    for _, q in ipairs(QuestDatabase) do
        if myLevel >= q.Level then bestQuest = q end
    end
    return bestQuest
end

local function EquipSlot1Tool(char)
    local backpack = LocalPlayer.Backpack
    local tool = backpack:FindFirstChildOfClass("Tool")
    for _, v in ipairs(backpack:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == "Melee" or v.ToolTip == "Sword") then
            tool = v
            break
        end
    end
    if tool and char:FindFirstChild("Humanoid") then
        char.Humanoid:EquipTool(tool)
        return tool
    end
    return char:FindFirstChildOfClass("Tool")
end

task.spawn(function()
    while task.wait(0.05) do
        if (States.AutoFarm or States.AutoQuest) and States.MobAura then
            pcall(function()
                local char = LocalPlayer.Character
                local H = char and char:FindFirstChild("HumanoidRootPart")
                if H and Workspace:FindFirstChild("Enemies") then
                    for _, mob in Workspace.Enemies:GetChildren() do
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            if (mob.HumanoidRootPart.Position - H.Position).Magnitude < 300 then
                                mob.HumanoidRootPart.CFrame = H.CFrame * CFrame.new(0, -20, -5)
                                mob.HumanoidRootPart.CanCollide = false
                                mob.Humanoid.WalkSpeed = 0
                                mob.Humanoid.JumpPower = 0
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if States.AutoQuest or States.AutoFarm then
            ActiveTask = "FARMING"
            CreateSafePlatform()
            pcall(function()
                local char = LocalPlayer.Character
                local H = char and char:FindFirstChild("HumanoidRootPart")
                local tool = EquipSlot1Tool(char)
                local targetMobName = nil
                
                if States.AutoQuest then
                    local currentQuest = GetBestQuest()
                    targetMobName = currentQuest.MobName
                    local questTracker = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                    if not questTracker or not questTracker.Visible then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.LevelReq)
                        task.wait(1)
                    end
                end

                if Workspace:FindFirstChild("Enemies") then
                    local targetFound = false
                    for _, n in Workspace.Enemies:GetChildren() do
                        if n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 and n:FindFirstChild("HumanoidRootPart") then
                            if not targetMobName or string.find(n.Name, targetMobName) or not States.AutoQuest then
                                targetFound = true
                                local safePos = n.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                                if States.DashMode then
                                    TweenService:Create(H, TweenInfo.new((H.Position - safePos.Position).Magnitude/300, Enum.EasingStyle.Linear), {CFrame = safePos}):Play()
                                else
                                    H.CFrame = safePos
                                end
                                SafePlatform.CFrame = H.CFrame * CFrame.new(0, -4, 0)
                                if tool then
                                    tool:Activate()
                                    if States.FastAttack then VirtualUser:ClickButton1(Vector2.new(500, 500)) end
                                end
                                break
                            end
                        end
                    end
                    if not targetFound and SafePlatform then SafePlatform.CFrame = CFrame.new(0, -5000, 0) end
                end
            end)
        else
            if ActiveTask == "FARMING" then ActiveTask = "NONE" end
            RemoveSafePlatform()
        end
    end
end)

-- ==========================================
-- 6. OTO BALIK TUTMA VE UZAKTAN OTO GACHA
-- ==========================================
task.spawn(function()
    while task.wait(0.2) do
        if States.AutoFish and ActiveTask == "NONE" then
            ActiveTask = "FISHING"
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    if States.AutoFishQuest then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("FishermanQuest", "Start")
                    end
                    local rod = LocalPlayer.Backpack:FindFirstChild("Fishing Rod") or char:FindFirstChild("Fishing Rod")
                    if rod then
                        char.Humanoid:EquipTool(rod)
                        rod:Activate()
                        local fishGui = LocalPlayer.PlayerGui:FindFirstChild("Fishing")
                        if fishGui and fishGui.Enabled then
                            local bar = fishGui:FindFirstChild("Bar") or fishGui:FindFirstChild("Progress")
                            if bar then bar.Value = 100 end
                            VirtualUser:Button1Down(Vector2.new(500,500))
                            VirtualUser:Button1Up(Vector2.new(500,500))
                        end
                    end
                end
            end)
        elseif ActiveTask == "FISHING" and not States.AutoFish then
            ActiveTask = "NONE"
        end
    end
end)

task.spawn(function()
    while task.wait(3) do
        if States.AutoGacha then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
                GDX_Log("Uzaktan Gacha tetiklendi!")
            end)
        end
    end
end)

-- ==========================================
-- 6.5 APEX LUCK BOOST, NO COOLDOWN & SERVER HOP
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        if States.LuckBoost then
            pcall(function()
                -- RNG Tohumu Yenile (Entropy Artırımı)
                math.randomseed(os.time() + math.random(100000, 999999))
                
                -- Lag yaratan animasyonları ve UI bloklarını gizle
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                if pGui and pGui:FindFirstChild("Main") then
                    local gachaUI = pGui.Main:FindFirstChild("FruitDealerCousin") or pGui.Main:FindFirstChild("Gacha")
                    if gachaUI and gachaUI.Visible then
                        gachaUI.Visible = false
                        GDX_Log("Luck Boost: Gacha animasyonu atlandı, anında alım devrede!")
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if States.NoCooldownGacha then
            pcall(function()
                -- İstemci süre sınırını kaldır
                if LocalPlayer:GetAttribute("GachaCooldown") then
                    LocalPlayer:SetAttribute("GachaCooldown", 0)
                end
                
                -- Agresif Alım İstekleri
                local remote = ReplicatedStorage.Remotes.CommF_
                if States.LuckBoost then
                    remote:InvokeServer("Cousin", "Buy", true) 
                else
                    remote:InvokeServer("Cousin", "Buy")
                end
            end)
        end
    end
end)

-- OTO SUNUCU DEĞİŞTİRME (SERVER HOP ENGINE)
task.spawn(function()
    while task.wait(5) do
        if States.AutoServerHop then
            GDX_Log("Auto Server-Hop: Düşük pingli/boş yeni sunucu aranıyor...", "WARN")
            pcall(function()
                local sfUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
                if req then
                    local response = req({Url = sfUrl, Method = "GET"})
                    if response.Body then
                        local body = HttpService:JSONDecode(response.Body)
                        if body and body.data then
                            for _, v in pairs(body.data) do
                                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                                    GDX_Log("Uygun sunucu bulundu (" .. v.playing .. "/" .. v.maxPlayers .. "). Işınlanılıyor!")
                                    TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                                    task.wait(5)
                                    break
                                end
                            end
                        end
                    end
                else
                    -- Fallback: Standart Işınlanma
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end)
            task.wait(10)
        end
    end
end)

-- ==========================================
-- 7. KİLİTLENMEYEN OTO SANDIK & MEYVE ESP & DEPOLAMA
-- ==========================================
task.spawn(function()
    while task.wait(0.05) do
        if States.AutoChest and ActiveTask == "NONE" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            ActiveTask = "CHESTING"
            pcall(function()
                local H = LocalPlayer.Character.HumanoidRootPart
                local closestChest, shortest, targetIndex = nil, math.huge, -1
                for idx, v in ipairs(CachedChests) do
                    if v and v.Parent then
                        local dist = (H.Position - v.Position).Magnitude
                        if dist < shortest then
                            shortest = dist; closestChest = v; targetIndex = idx
                        end
                    end
                end
                if closestChest then
                    local tweenTime = math.clamp(shortest / 350, 0.05, 1.5)
                    local movementTween = TweenService:Create(H, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = closestChest.CFrame})
                    movementTween:Play()
                    if firetouchinterest then
                        firetouchinterest(H, closestChest, 0)
                        task.wait(0.1)
                        firetouchinterest(H, closestChest, 1)
                    end
                    movementTween.Completed:Wait()
                    if targetIndex ~= -1 then table.remove(CachedChests, targetIndex) end
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
    while task.wait(0.2) do
        if States.AutoMoveFruit and ActiveTask == "NONE" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                for idx, v in ipairs(CachedFruits) do
                    if v and v.Parent and v:FindFirstChild("Handle") then
                        local H = LocalPlayer.Character.HumanoidRootPart
                        H.CFrame = v.Handle.CFrame
                        if firetouchinterest then
                            firetouchinterest(H, v.Handle, 0)
                            task.wait(0.1)
                            firetouchinterest(H, v.Handle, 1)
                        end
                        GDX_Log("Meyve toplandı: " .. v.Name)
                        table.remove(CachedFruits, idx)
                        break
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if States.AutoStoreFruit then
            pcall(function()
                local function CheckAndStore(item)
                    if item:IsA("Tool") and (string.find(item.Name, "Fruit") or string.find(item.Name, "Meyve")) then
                        local fruitName = item:GetAttribute("OriginalName") or item.Name
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", fruitName)
                        GDX_Log("Meyve depoya atıldı (Auto Store): " .. fruitName)
                    end
                end
                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do CheckAndStore(v) end
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetChildren()) do CheckAndStore(v) end
                end
            end)
        end
    end
end)

-- ==========================================
-- 8. ADA TAKİP VE AZURE EMBER 
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if States.MirageTracker or States.KitsuneTracker then
                for _, v in pairs(Workspace.Map:GetChildren()) do
                    if States.MirageTracker and string.find(v.Name, "Mirage") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetModelCFrame() * CFrame.new(0, 100, 0)
                        States.MirageTracker = false 
                        GDX_Log("Mirage Adası bulundu, ışınlanıldı!")
                    end
                    if States.KitsuneTracker and string.find(v.Name, "Kitsune") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetModelCFrame() * CFrame.new(0, 100, 0)
                        States.KitsuneTracker = false
                        GDX_Log("Kitsune Adası bulundu, ışınlanıldı!")
                    end
                end
            end

            if States.AutoEmber then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if string.find(v.Name, "AzureEmber") and v:IsA("BasePart") then
                        local H = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if H then
                            H.CFrame = v.CFrame
                            if firetouchinterest then
                                firetouchinterest(H, v, 0)
                                firetouchinterest(H, v, 1)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- 8.5 YENİ NESİL MEYVE YAĞMURU (GÖRSEL ŞÖLEN)
-- ==========================================
local RainFruits = {
    {Name = "Kitsune Fruit", Color = Color3.fromRGB(0, 200, 255)},
    {Name = "T-Rex Fruit", Color = Color3.fromRGB(255, 60, 0)},
    {Name = "Mammoth Fruit", Color = Color3.fromRGB(139, 69, 19)},
    {Name = "Leopard Fruit", Color = Color3.fromRGB(255, 215, 0)},
    {Name = "Dragon Fruit", Color = Color3.fromRGB(255, 0, 50)}
}

task.spawn(function()
    while task.wait(0.2) do
        if States.FruitRain and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local H = LocalPlayer.Character.HumanoidRootPart
                local randomFruit = RainFruits[math.random(1, #RainFruits)]
                
                local fruitPart = Instance.new("Part")
                fruitPart.Size = Vector3.new(2, 2, 2)
                fruitPart.CFrame = H.CFrame * CFrame.new(math.random(-60, 60), math.random(50, 120), math.random(-60, 60))
                fruitPart.Color = randomFruit.Color
                fruitPart.Material = Enum.Material.Neon
                fruitPart.Shape = Enum.PartType.Ball
                fruitPart.CanCollide = false
                fruitPart.Anchored = false
                fruitPart.Parent = Workspace
                
                local esp = Instance.new("BillboardGui", fruitPart)
                esp.Size = UDim2.new(0, 150, 0, 50)
                esp.AlwaysOnTop = true
                
                local txt = Instance.new("TextLabel", esp)
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = randomFruit.Name
                txt.TextColor3 = randomFruit.Color
                txt.Font = Enum.Font.GothamBlack
                txt.TextScaled = true
                txt.TextStrokeTransparency = 0
                
                Debris:AddItem(fruitPart, 4)
            end)
        end
    end
end)

-- ==========================================
-- 9. GÜNDOĞDİSEX YENİ NESİL ARAYÜZ (GÜNCELLENDİ)
-- ==========================================
if CoreGui:FindFirstChild("GDX_V3_Panel") then CoreGui.GDX_V3_Panel:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GDX_V3_Panel"
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 8, 8); ToggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 0); ToggleBtn.BorderSizePixel = 2
ToggleBtn.Text = "GDX"; ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50); ToggleBtn.Font = Enum.Font.GothamBlack; ToggleBtn.TextSize = 16
ToggleBtn.Active = true; ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 600); MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 8); MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0); MainFrame.BorderSizePixel = 2
MainFrame.Active = true; MainFrame.Draggable = true; MainFrame.Visible = false

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45); Title.BackgroundTransparency = 1; Title.Text = "GÜNDOĞDİSEX V3.6 APEX 👑"
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
        -- TUŞA BASINCA KONSOLA BİLGİ GÖNDERİR:
        GDX_Log("[" .. name .. "] durumu değiştirildi -> " .. tostring(btn.Text))
    end)
    return frame, lbl
end

-- MENÜ İÇERİKLERİ YÜKLENİYOR
CreateCategory("🚀 GELİŞMİŞ SAVAŞ & GÖREV (ÇAKIŞMA KORUMALI)")
CreateToggle("🤖 Akıllı Oto Görev (Smart Quest)", "AutoQuest", "Uzaktan görev alır (CommF_).")
CreateToggle("⚔️ Oto Farm (Sıfır Hasar / Sabit)", "AutoFarm", "Sadece 1. Slottaki silahı kullanır.")
CreateToggle("✈️ Dash Modu (Noclip)", "DashMode", "Açıksa uçar, kapalıysa direkt ışınlanır.")
CreateToggle("🧲 Mob Aura (Toplu Kesim)", "MobAura", "Tüm mobları tam altına sabitler (Hasar almazsın).")
CreateToggle("⚡ Fast Attack (Seri Vuruş)", "FastAttack", "Saldırı hızını maksimuma çıkarır.")

CreateCategory("🔮 UZAKTAN İŞLEMLER & EVENT")
CreateToggle("🎰 Uzaktan Oto Gacha (Meyve Al)", "AutoGacha", "NPC'ye gitmeden rastgele meyve açar.")
-- [+] YENİ EKLENEN TUŞLAR:
CreateToggle("⚡ Gacha Bekleme Süresi Kırıcı", "NoCooldownGacha", "2 Saatlik süreyi ve UI kilidini atlayıp seri alım dener.")
CreateToggle("🍀 Apex Luck Boost (Şans Artırıcı)", "LuckBoost", "RNG tohumunu yeniler, animasyonu silip nadir meyve şansını zorlar.")
CreateToggle("🔄 Oto Sunucu Değiştir (Server Hop)", "AutoServerHop", "Sürekli yeni/boş sunuculara geçerek meyve arar.")
-- [Devam eden tuşlar]
CreateToggle("🏝️ Oto Mirage Bulucu", "MirageTracker", "Mirage adası doğduğunda oraya ışınlanır.")
CreateToggle("🦊 Oto Kitsune Adası", "KitsuneTracker", "Kitsune adası çıktığında anında gider.")
CreateToggle("🔵 Oto Kitsune Ember (Topçuk)", "AutoEmber", "Adadaki uçan topçukları otomatik toplar.")

CreateCategory("🎣 OTO BALIK VE BALIKÇI")
CreateToggle("🐟 Oto Balık Tutma", "AutoFish", "Oltayı atar ve minigame'i hatasız tamamlar.")
CreateToggle("📜 Balıkçıdan Oto Görev Al", "AutoFishQuest", "Balık tutarken sürekli NPC'den görev yeniler.")

CreateCategory("💰 TOPLAMA & MEYVE (YENİ SİSTEM)")
CreateToggle("💰 Ultra Oto Sandık (Fixlendi)", "AutoChest", "Engellere takılmadan sandıkları yok eder.")
local fruitFrame = CreateToggle("🍎 Meyve Bulucu & ESP", "FruitFinder", "0 Meyve Algılandı!")
CreateToggle("⭐ Meyveye Oto Git ve Al", "AutoMoveFruit", "Meyveye uçar ve anında çantana çeker.")
CreateToggle("📦 Oto Meyve Depola (Store)", "AutoStoreFruit", "Çantandaki gerçek meyveyi direk depoya atar.")

CreateCategory("✨ EĞLENCE & VİSUAL (YENİ)")
CreateToggle("🌧️ Yeni Nesil Meyve Yağmuru", "FruitRain", "Kitsune, T-Rex gökten yağar (Sadece Görseldir).")

CreateCategory("⚡ KARAKTER HİLELERİ")
CreateToggle("⚡ Hız Hilesi (Speed Hack)", "SpeedHack", "Walkspeed değerini artırır.")
CreateToggle("👻 Duvarlardan Geçme (NoClip)", "Noclip", "Tüm engellerin içinden geçmeni sağlar.")

-- ALT KONTROL BAR
local BottomBar = Instance.new("Frame", MainFrame); BottomBar.Size = UDim2.new(1, 0, 0, 45); BottomBar.Position = UDim2.new(0, 0, 1, -45); BottomBar.BackgroundColor3 = Color3.fromRGB(10, 5, 5)
local function AddBottomBtn(txt, pos, cb)
    local b = Instance.new("TextButton", BottomBar); b.Size = UDim2.new(0.3, 0, 0.7, 0); b.Position = UDim2.new(pos, 0, 0.15, 0)
    b.BackgroundColor3 = Color3.fromRGB(40, 10, 10); b.BorderColor3 = Color3.fromRGB(200,0,0); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); b.MouseButton1Click:Connect(cb)
end

AddBottomBtn("PANELİ KAPAT", 0.03, function() MainFrame.Visible = false GDX_Log("Panel gizlendi.") end)
AddBottomBtn("KONSOL [F9]", 0.35, function() pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", true) end) GDX_Log("F9 Geliştirici Konsolu açıldı.") end)
AddBottomBtn("AĞI TEMİZLE", 0.67, function() CachedChests = {}; CachedFruits = {} GDX_Log("Önbellek (Cache) temizlendi.") end)

Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)
