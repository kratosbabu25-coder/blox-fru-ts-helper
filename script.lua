local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Modern Xeno-Style ScreenGui
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "XenoPanel"

-- Toggle Butonu (Ekranın Ortasında)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Text = "X"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.Bold
ToggleBtn.BorderSizePixel = 0
local Corner = Instance.new("UICorner", ToggleBtn)
Corner.CornerRadius = UDim.new(0, 10)
ToggleBtn.Draggable = true

-- Ana Panel
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Visible = false
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- Başlık
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "XENO HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold

-- Aç/Kapa Mantığı
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Buton Oluşturucu (Xeno Tarzı)
local function createButton(text, callback, y)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
end

-- Fonksiyonlar
createButton("Hız Hilesi (Speed)", function() 
    LocalPlayer.Character.Humanoid.WalkSpeed = 100 
end, 60)

createButton("Uçuş Modu (Fly)", function() 
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and not hrp:FindFirstChild("BodyVelocity") then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 30, 0)
    else
        if hrp:FindFirstChild("BodyVelocity") then hrp.BodyVelocity:Destroy() end
    end
end, 110)
