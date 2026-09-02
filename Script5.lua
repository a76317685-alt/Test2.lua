-- =====================================================
-- 🔐 КЛЮЧ Le32133 + ЗАГРУЗКА HYPER M4X EVADE
-- =====================================================
local player = game.Players.LocalPlayer
local SG = Instance.new("ScreenGui")
SG.Parent = player:WaitForChild("PlayerGui")
SG.ResetOnSpawn = false

local isMobile = game:GetService("UserInputService").TouchEnabled
local CORRECT_KEY = "Le32133"

-- ============================================================
-- 🎨 КРАСИВОЕ ОКНО ВВОДА КЛЮЧА
-- ============================================================
local KeyFrame = Instance.new("Frame", SG)
KeyFrame.Size = UDim2.new(0, isMobile and 300 or 350, 0, isMobile and 180 or 200)
KeyFrame.Position = UDim2.new(0.5, isMobile and -150 or -175, 0.3, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
KeyFrame.Active = true
KeyFrame.Draggable = true
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
KeyFrame.ClipsDescendants = true

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Title.Text = "🔐 АКТИВАЦИЯ HYPER M4X"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = isMobile and 16 or 18
Title.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
KeyInput.BorderColor3 = Color3.fromRGB(0, 200, 255)
KeyInput.BorderSizePixel = 2
KeyInput.Text = ""
KeyInput.PlaceholderText = "Введите ключ..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextXAlignment = Enum.TextXAlignment.Center
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

local ActivateBtn = Instance.new("TextButton", KeyFrame)
ActivateBtn.Size = UDim2.new(0.4, 0, 0, 40)
ActivateBtn.Position = UDim2.new(0.3, 0, 0.7, 0)
ActivateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ActivateBtn.Text = "✅ АКТИВИРОВАТЬ"
ActivateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateBtn.TextSize = isMobile and 12 or 14
ActivateBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", ActivateBtn).CornerRadius = UDim.new(0, 6)

ActivateBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    if input == CORRECT_KEY then
        -- Успешная активация
        KeyFrame:TweenSize(UDim2.new(0, isMobile and 300 or 350, 0, 100), "Out", "Quad", 0.3, true)
        KeyInput.Visible = false
        ActivateBtn.Visible = false
        
        local SuccessLabel = Instance.new("TextLabel", KeyFrame)
        SuccessLabel.Size = UDim2.new(0.8, 0, 0, 40)
        SuccessLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
        SuccessLabel.BackgroundTransparency = 1
        SuccessLabel.Text = "✅ ДОСТУП РАЗРЕШЁН!"
        SuccessLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        SuccessLabel.TextSize = isMobile and 20 or 24
        SuccessLabel.Font = Enum.Font.SourceSansBold
        SuccessLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        print("🔓 Ключ принят! Загрузка Hyper M4X Evade...")
        
        task.wait(1)
        KeyFrame.Visible = false
        KeyFrame:Destroy()
        
        -- ============================================================
        -- 🚀 ЗАГРУЗКА HYPER M4X EVADE (ТОЧНО ТАКОЙ ЖЕ КОД)
        -- ============================================================
        -- Это код из твоего сообщения
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MITTO-m4x/Hyper_M4X_EVA/refs/heads/main/Hyper_EVADE.lua"))()
        
        print("✅ Hyper M4X Evade загружен!")
        
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "❌ НЕВЕРНЫЙ КЛЮЧ!"
        KeyInput.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(1.5)
        KeyInput.PlaceholderText = "Введите ключ..."
        KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

print("🔐 КЛЮЧ-СИСТЕМА ЗАГРУЖЕНА!")
print("🔑 КЛЮЧ: " .. CORRECT_KEY)
print("📌 ВВЕДИ КЛЮЧ И ЗАГРУЗИТСЯ HYPER M4X EVADE")
