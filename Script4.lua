-- =====================================================
-- ⚡ SSR INJECTOR v5.0 (КРУГ + ОТКРЫТИЕ)
-- =====================================================
local player = game.Players.LocalPlayer
local SG = Instance.new("ScreenGui")
SG.Parent = player:WaitForChild("PlayerGui")
SG.ResetOnSpawn = false

local isMinimized = false

-- ============================================================
-- 📋 ГЛАВНОЕ ОКНО (РАСТЯНУТО ВПРАВО)
-- ============================================================
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 400, 0, 250)
Main.Position = UDim2.new(0.7, -200, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(0, 255, 0)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Main.ClipsDescendants = true

-- ============================================================
-- 🔝 ЗАГОЛОВОК
-- ============================================================
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 35)
Top.BackgroundColor3 = Color3.fromRGB(0, 20, 0)
Top.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ SSR INJECTOR v5.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextSize = 16
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================================
-- ⭕ КРУГЛАЯ КНОПКА (НАСТОЯЩИЙ КРУГ)
-- ============================================================
local CircleBtn = Instance.new("TextButton", SG)
CircleBtn.Size = UDim2.new(0, 50, 0, 50)
CircleBtn.Position = UDim2.new(0.9, -25, 0.05, 0)
CircleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
CircleBtn.BackgroundTransparency = 0.2
CircleBtn.BorderSizePixel = 0
CircleBtn.Text = "●"
CircleBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
CircleBtn.TextSize = 30
CircleBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", CircleBtn).CornerRadius = UDim.new(1, 0)
CircleBtn.ZIndex = 999

CircleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Main.Visible = false
        CircleBtn.Size = UDim2.new(0, 60, 0, 60)
        CircleBtn.Position = UDim2.new(0.9, -30, 0.05, 0)
        CircleBtn.Text = "●"
        CircleBtn.TextSize = 35
    else
        Main.Visible = true
        CircleBtn.Size = UDim2.new(0, 50, 0, 50)
        CircleBtn.Position = UDim2.new(0.9, -25, 0.05, 0)
        CircleBtn.Text = "●"
        CircleBtn.TextSize = 30
    end
end)

-- ============================================================
-- 📋 КОНТЕНТ (ПОЛЕ ВВОДА + EXEC)
-- ============================================================
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -12, 1, -80)
Content.Position = UDim2.new(0, 6, 0, 40)
Content.BackgroundTransparency = 1

-- ============================================================
-- 🖊️ ПОЛЕ ВВОДА
-- ============================================================
local InputBox = Instance.new("TextBox", Content)
InputBox.Size = UDim2.new(1, 0, 0, 60)
InputBox.Position = UDim2.new(0, 0, 0, 20)
InputBox.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
InputBox.BorderColor3 = Color3.fromRGB(0, 255, 0)
InputBox.BorderSizePixel = 2
InputBox.Text = ""
InputBox.PlaceholderText = "require(79802892692544).load('4x4x_40x77')"
InputBox.TextColor3 = Color3.fromRGB(0, 255, 0)
InputBox.TextSize = 14
InputBox.Font = Enum.Font.Code
InputBox.MultiLine = true
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Top
InputBox.ClearTextOnFocus = false
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 4)

-- ============================================================
-- ⚡ КНОПКА "EXEC"
-- ============================================================
local ExecBtn = Instance.new("TextButton", Content)
ExecBtn.Size = UDim2.new(0.4, 0, 0, 40)
ExecBtn.Position = UDim2.new(0.3, 0, 0.7, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
ExecBtn.BorderSizePixel = 2
ExecBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
ExecBtn.Text = "⚡ EXEC"
ExecBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
ExecBtn.TextSize = 18
ExecBtn.Font = Enum.Font.Code
Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 4)
ExecBtn.MouseButton1Click:Connect(function()
    local script = InputBox.Text
    if script == "" then
        StatusLabel.Text = "❌ ВВЕДИТЕ СКРИПТ!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end

    StatusLabel.Text = "⏳ ВЫПОЛНЕНИЕ..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

    local success, err = pcall(function()
        loadstring(script)()
    end)

    if success then
        StatusLabel.Text = "✅ СКРИПТ ВЫПОЛНЕН!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.Text = "❌ ОШИБКА: " .. tostring(err)
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- ============================================================
-- 🔽 СТАТУС-БАР
-- ============================================================
local Bottom = Instance.new("Frame", Main)
Bottom.Size = UDim2.new(1, 0, 0, 30)
Bottom.Position = UDim2.new(0, 0, 1, -30)
Bottom.BackgroundColor3 = Color3.fromRGB(0, 20, 0)
Bottom.BorderSizePixel = 0

local StatusLabel = Instance.new("TextLabel", Bottom)
StatusLabel.Size = UDim2.new(0.9, 0, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "✅ SSR READY"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================================
-- ⌨️ ГОРЯЧИЕ КЛАВИШИ
-- ============================================================
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F12 then
        CircleBtn.MouseButton1Click:Fire()
    end
    if input.KeyCode == Enum.KeyCode.Return then
        ExecBtn.MouseButton1Click:Fire()
    end
    if input.KeyCode == Enum.KeyCode.F4 and input:IsKeyDown(Enum.KeyCode.LeftAlt) then
        SG:Destroy()
    end
end)

print("⚡ SSR INJECTOR v5.0 ЗАГРУЖЕН!")
print("📌 Круг — сворачивание/разворачивание")
print("📌 Enter — выполнить скрипт")
