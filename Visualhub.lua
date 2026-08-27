local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local sg = game:GetService("StarterGui")
local lighting = game:GetService("Lighting")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

local auraActive = false
local auraType = "demon"
local auraParts = {}
local auraAttachments = {}

-- ===== ШЕЙДЕРЫ =====
local function applyShaders(shaderType)
    if shaderType == "bloom" then
        local bloom = Instance.new("BloomEffect")
        bloom.Intensity = 0.5
        bloom.Size = 20
        bloom.Threshold = 0.2
        bloom.Parent = lighting
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Bloom ON", Duration = 2})
    elseif shaderType == "color" then
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Brightness = 0.1
        colorCorrection.Contrast = 0.2
        colorCorrection.Saturation = 0.3
        colorCorrection.Parent = lighting
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Color Correction ON", Duration = 2})
    elseif shaderType == "blur" then
        local blur = Instance.new("BlurEffect")
        blur.Size = 10
        blur.Parent = lighting
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Blur ON", Duration = 2})
    elseif shaderType == "sun" then
        local sunRays = Instance.new("SunRaysEffect")
        sunRays.Intensity = 0.5
        sunRays.Spread = 1
        sunRays.Parent = lighting
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Sun Rays ON", Duration = 2})
    elseif shaderType == "depth" then
        local depth = Instance.new("DepthOfFieldEffect")
        depth.FarIntensity = 0.5
        depth.NearIntensity = 0.2
        depth.Parent = lighting
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Depth of Field ON", Duration = 2})
    end
end

local function removeShaders()
    for _, v in pairs(lighting:GetChildren()) do
        if v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
            v:Destroy()
        end
    end
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "All Shaders Removed", Duration = 2})
end

-- ===== АУРЫ (РАБОЧИЕ) =====
local function clearAuras()
    for _, v in pairs(auraParts) do
        if v and v.Parent then
            v:Destroy()
        end
    end
    auraParts = {}
    for _, v in pairs(auraAttachments) do
        if v and v.Parent then
            v:Destroy()
        end
    end
    auraAttachments = {}
    auraActive = false
end

local function createAura(aType)
    clearAuras()
    auraActive = true
    auraType = aType

    local colors = {
        demon = {Color3.new(1, 0, 0), Color3.new(0.5, 0, 0)},
        angel = {Color3.new(1, 1, 1), Color3.new(0.5, 0.5, 1)},
        fire = {Color3.new(1, 0.5, 0), Color3.new(1, 0, 0)},
        ice = {Color3.new(0, 1, 1), Color3.new(0, 0.5, 1)},
        dark = {Color3.new(0.2, 0.2, 0.2), Color3.new(0, 0, 0)}
    }

    local color = colors[aType] or colors.demon

    -- 1. Создаём светящуюся сферу вокруг персонажа
    local sphere = Instance.new("Part")
    sphere.Size = Vector3.new(10, 10, 10)
    sphere.Shape = Enum.PartType.Ball
    sphere.Transparency = 0.7
    sphere.CanCollide = false
    sphere.Anchored = false
    sphere.BrickColor = BrickColor.new(Color3.new(color[1].r, color[1].g, color[1].b))
    sphere.Material = Enum.Material.Neon
    sphere.Parent = workspace

    local weld = Instance.new("Weld")
    weld.Part0 = hrp
    weld.Part1 = sphere
    weld.C0 = CFrame.new(0, 0, 0)
    weld.Parent = sphere

    table.insert(auraParts, sphere)

    -- 2. Создаём партиклы на персонаже
    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Texture = "rbxassetid://7894763210"
    particleEmitter.Rate = 150
    particleEmitter.Lifetime = NumberRange.new(1, 2)
    particleEmitter.SpreadAngle = Vector2.new(360, 360)
    particleEmitter.VelocityInheritance = 0
    particleEmitter.Speed = NumberRange.new(2, 5)
    particleEmitter.Transparency = NumberSequence.new(0.8, 0)
    particleEmitter.Size = NumberSequence.new(1, 3)
    particleEmitter.Color = ColorSequence.new(color[1], color[2])
    particleEmitter.Parent = hrp

    table.insert(auraParts, particleEmitter)

    -- 3. Создаём кольца (для красоты)
    for i = 1, 3 do
        local ring = Instance.new("Part")
        ring.Size = Vector3.new(8 + i * 2, 0.5, 8 + i * 2)
        ring.Shape = Enum.PartType.Cylinder
        ring.Transparency = 0.5
        ring.CanCollide = false
        ring.Anchored = false
        ring.BrickColor = BrickColor.new(Color3.new(color[1].r, color[1].g, color[1].b))
        ring.Material = Enum.Material.Neon
        ring.Parent = workspace

        local ringWeld = Instance.new("Weld")
        ringWeld.Part0 = hrp
        ringWeld.Part1 = ring
        ringWeld.C0 = CFrame.new(0, -2 + i * 2, 0)
        ringWeld.Parent = ring

        table.insert(auraParts, ring)

        -- Вращение колец
        runService.Heartbeat:Connect(function()
            if not auraActive then return end
            ring.CFrame = ring.CFrame * CFrame.Angles(0, 0.02, 0)
        end)
    end

    sg:SetCore("SendNotification", {Title = "[PRO]", Text = string.upper(aType) .. " AURA ON", Duration = 2})
end

local function removeAura()
    clearAuras()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Aura Removed", Duration = 2})
end

-- ===== ВИЗУАЛЬНЫЕ ЭФФЕКТЫ =====
local function flashbang()
    local gui = Instance.new("ScreenGui")
    gui.Parent = player.PlayerGui
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(2, 0, 2, 0)
    frame.Position = UDim2.new(-0.5, 0, -0.5, 0)
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BackgroundTransparency = 0
    frame.Parent = gui
    tweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    wait(0.5)
    gui:Destroy()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "FLASHBANG!", Duration = 2})
end

local function colorize(color)
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = color
    colorCorrection.Parent = lighting
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Colorized: " .. tostring(color), Duration = 2})
end

local function removeColor()
    for _, v in pairs(lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Color Removed", Duration = 2})
end

local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "VisualEffects"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 520)
    frame.Position = UDim2.new(0.5, -210, 0.5, -260)
    frame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 50)
    top.BackgroundColor3 = Color3.new(0.2, 0.05, 0.3)
    top.BackgroundTransparency = 0.2
    top.BorderSizePixel = 0
    top.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "✦ VISUAL EFFECTS v2.0 ✦"
    title.TextColor3 = Color3.new(0.6, 0.2, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -40, 0, 10)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.BackgroundColor3 = Color3.new(0.5, 0, 0)
    close.BackgroundTransparency = 0.3
    close.BorderSizePixel = 0
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.Parent = top
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -60)
    scroll.Position = UDim2.new(0, 5, 0, 55)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.Parent = frame

    local function addButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.Parent = scroll

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    addButton("🔥 DEMON AURA", Color3.new(0.8, 0, 0), function() createAura("demon") end)
    addButton("👼 ANGEL AURA", Color3.new(1, 1, 1), function() createAura("angel") end)
    addButton("🔥 FIRE AURA", Color3.new(1, 0.5, 0), function() createAura("fire") end)
    addButton("❄️ ICE AURA", Color3.new(0, 0.8, 1), function() createAura("ice") end)
    addButton("🌑 DARK AURA", Color3.new(0.2, 0.2, 0.2), function() createAura("dark") end)
    addButton("❌ REMOVE AURA", Color3.new(0.5, 0.5, 0.5), removeAura)

    addButton("✨ BLOOM", Color3.new(0.8, 0.8, 0.8), function() applyShaders("bloom") end)
    addButton("🎨 COLOR CORRECTION", Color3.new(0.6, 0.6, 1), function() applyShaders("color") end)
    addButton("🌀 BLUR", Color3.new(0.5, 0.5, 0.8), function() applyShaders("blur") end)
    addButton("☀️ SUN RAYS", Color3.new(1, 0.8, 0.2), function() applyShaders("sun") end)
    addButton("📸 DEPTH OF FIELD", Color3.new(0.4, 0.8, 0.8), function() applyShaders("depth") end)
    addButton("🗑️ REMOVE SHADERS", Color3.new(0.5, 0.5, 0.5), removeShaders)

    addButton("💥 FLASHBANG", Color3.new(1, 1, 1), flashbang)
    addButton("🔴 RED TINT", Color3.new(1, 0, 0), function() colorize(Color3.new(1, 0, 0)) end)
    addButton("🔵 BLUE TINT", Color3.new(0, 0, 1), function() colorize(Color3.new(0, 0, 1)) end)
    addButton("🟢 GREEN TINT", Color3.new(0, 1, 0), function() colorize(Color3.new(0, 1, 0)) end)
    addButton("🟣 PURPLE TINT", Color3.new(0.5, 0, 1), function() colorize(Color3.new(0.5, 0, 1)) end)
    addButton("🗑️ REMOVE COLOR", Color3.new(0.5, 0.5, 0.5), removeColor)

    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    frame:TweenSize(UDim2.new(0, 420, 0, 520), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
end

player.CharacterAdded:Connect(function()
    wait(1)
    char = player.Character
    hrp = char:FindFirstChild("HumanoidRootPart")
    hum = char:FindFirstChild("Humanoid")
end)

pcall(function()
    createUI()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "VISUAL EFFECTS v2.0 LOADED!", Duration = 3})
end)
