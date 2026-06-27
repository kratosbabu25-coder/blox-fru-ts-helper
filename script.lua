local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- (Arayüz kodların buraya gelecek...)
-- [Burada senin yazdığın Arayüz ve Başlık kodları mevcut]

-- Meyve Toplama Fonksiyonu
local function meyveTopla()
    for _, obje in pairs(Workspace:GetChildren()) do
        if obje:IsA("Tool") and string.find(obje.Name, "Fruit") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = obje.Handle.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.5)
                pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", obje.Name) end)
            end
        end
    end
end

-- Uçuş Modu Fonksiyonu
local flying = false
local function toggleFly()
    flying = not flying
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 50, 0)
    else
        hrp:FindFirstChild("BodyVelocity"):Destroy()
    end
end

-- Butonlara İşlev Ekleme (Güncellenmiş)
createAdminButton("Hız Hilesi (Speed)", function() 
    LocalPlayer.Character.Humanoid.WalkSpeed = 100 
end, 60)

createAdminButton("Tüm Meyveleri Topla", function() 
    meyveTopla()
end, 110)

createAdminButton("Uçuş Modu (Fly)", function() 
    toggleFly()
end, 160)
