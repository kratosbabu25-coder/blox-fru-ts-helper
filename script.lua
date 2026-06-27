-- // GÜNDOĞDİSEX V4 - ULTIMATE EDITION \\
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- [1] NO CLIP & HIZLI UÇUŞ (CFrame Bypass)
local Noclip = true
local FlySpeed = 10
RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- [2] MEYVE BULUCU (Gecikmesiz ESP)
local function FindFruits()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Tool") and string.find(string.lower(obj.Name), "fruit") then
            -- Meyve bulursa üzerine ışınlan
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.Handle.CFrame
            end
        end
    end
end

-- [3] ANA DALLANMIŞ MENÜ
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 500)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true -- Menüyü sürükleyebilirsin

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "GÜNDOĞDİSEX V4"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold

-- [4] OTOMATİK FARM (NPC VURMA ALTYAPISI)
local AutoFarm = false
local function StartAutoFarm()
    task.spawn(function()
        while AutoFarm do
            task.wait(0.1)
            if Workspace:FindFirstChild("Enemies") then
                for _, npc in pairs(Workspace.Enemies:GetChildren()) do
                    if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end
        end
    end)
end

-- Menü Butonları
local FarmBtn = Instance.new("TextButton", MainFrame)
FarmBtn.Text = "Auto Farm: OFF"
FarmBtn.Size = UDim2.new(0.9, 0, 0, 40)
FarmBtn.Position = UDim2.new(0.05, 0, 0, 50)
FarmBtn.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    FarmBtn.Text = AutoFarm and "Auto Farm: ON" or "OFF"
    if AutoFarm then StartAutoFarm() end
end)

local FruitBtn = Instance.new("TextButton", MainFrame)
FruitBtn.Text = "Meyve Bul ve Al"
FruitBtn.Size = UDim2.new(0.9, 0, 0, 40)
FruitBtn.Position = UDim2.new(0.05, 0, 0, 100)
FruitBtn.MouseButton1Click:Connect(FindFruits)

-- Menüyü Gizle/Göster Butonu (Kuru Kafa)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.95, -25, 0.05, 0)
ToggleBtn.Text = "☠️"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
