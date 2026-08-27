local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local sg = game:GetService("StarterGui")
local cam = workspace.CurrentCamera
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local tweenService = game:GetService("TweenService")

local godModeActive = false
local noFallActive = false
local currentSpeed = 16
local currentJump = 50

local function updateCharacterReferences()
    char = player.Character
    if char then
        hrp = char:FindFirstChild("HumanoidRootPart")
        hum = char:FindFirstChild("Humanoid")
    end
end

local function antiBan()
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "Kick" or method == "Ban" then return nil end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

local function toggleGodMode()
    if not hum then return end
    godModeActive = not godModeActive
    if godModeActive then
        hum.Health = math.huge
        hum.MaxHealth = math.huge
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if godModeActive and hum then
                hum.Health = math.huge
            end
        end)
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "God Mode ON", Duration = 2})
    else
        hum.Health = 100
        hum.MaxHealth = 100
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "God Mode OFF", Duration = 2})
    end
end

local function loadFlyScript()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Loading Fly Script...", Duration = 3})
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-The-best-fly-gui-246203", true))()
    end)
    if success then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Fly Script Loaded!", Duration = 3})
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Failed to load Fly: " .. tostring(err), Duration = 5})
    end
end

local function setSpeed(value)
    if not hum then return end
    currentSpeed = value
    hum.WalkSpeed = value
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Speed set to " .. value, Duration = 2})
end

local function setJump(value)
    if not hum then return end
    currentJump = value
    hum.JumpPower = value
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Jump set to " .. value, Duration = 2})
end

local function toggleNoFall()
    if not hum then return end
    noFallActive = not noFallActive
    if noFallActive then
        hum.StateChanged:Connect(function(old, new)
            if noFallActive and new == Enum.HumanoidStateType.Falling and hrp then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 5, 0)
            end
        end)
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "NoFall ON", Duration = 2})
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "NoFall OFF", Duration = 2})
    end
end

local function killAll()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
            v.Character.Humanoid.Health = 0
        end
    end
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Kill All Executed", Duration = 2})
end

local function executeLua(code)
    if code and code ~= "" then
        local func, err = loadstring(code)
        if func then
            local success, result = pcall(func)
            if not success then
                sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Error: " .. tostring(result), Duration = 5})
            else
                sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Code executed", Duration = 3})
            end
        else
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Error: " .. tostring(err), Duration = 5})
        end
    end
end

local function resetCharacter()
    player:LoadCharacter()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Resetting...", Duration = 2})
    wait(1)
    updateCharacterReferences()
    if godModeActive then toggleGodMode() end
    if noFallActive then toggleNoFall() end
    setSpeed(currentSpeed)
    setJump(currentJump)
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Character Reset Complete", Duration = 2})
end

local function loadInfinityYield()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Loading Infinity Yield...", Duration = 3})
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
    end)
    if success then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Infinity Yield Loaded!", Duration = 3})
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Failed to load Infinity Yield: " .. tostring(err), Duration = 5})
    end
end

local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "UltraHub"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 560)
    frame.Position = UDim2.new(0.5, -210, 0.5, -280)
    frame.BackgroundColor3 = Color3.new(0.08, 0.05, 0.15)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 50)
    top.BackgroundColor3 = Color3.new(0.15, 0.05, 0.3)
    top.BackgroundTransparency = 0.2
    top.BorderSizePixel = 0
    top.Parent = frame

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 20)
    topCorner.Parent = top

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "✦ ULTRA HUB v5.1 ✦"
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

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = close

    close.MouseButton1Click:Connect(function()
        frame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        wait(0.3)
        gui:Destroy()
    end)

    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(1, 0, 0, 40)
    tabs.Position = UDim2.new(0, 0, 0, 50)
    tabs.BackgroundColor3 = Color3.new(0.1, 0.05, 0.2)
    tabs.BackgroundTransparency = 0.3
    tabs.BorderSizePixel = 0
    tabs.Parent = frame

    local mainTab = Instance.new("TextButton")
    mainTab.Size = UDim2.new(0.5, 0, 1, 0)
    mainTab.Position = UDim2.new(0, 0, 0, 0)
    mainTab.Text = "📋 MAIN"
    mainTab.TextColor3 = Color3.new(1, 1, 1)
    mainTab.BackgroundColor3 = Color3.new(0.3, 0.1, 0.6)
    mainTab.BackgroundTransparency = 0.2
    mainTab.BorderSizePixel = 0
    mainTab.Font = Enum.Font.GothamBold
    mainTab.TextSize = 16
    mainTab.Parent = tabs

    local execTab = Instance.new("TextButton")
    execTab.Size = UDim2.new(0.5, 0, 1, 0)
    execTab.Position = UDim2.new(0.5, 0, 0, 0)
    execTab.Text = "⚡ EXECUTOR"
    execTab.TextColor3 = Color3.new(1, 1, 1)
    execTab.BackgroundColor3 = Color3.new(0.1, 0.05, 0.2)
    execTab.BackgroundTransparency = 0.2
    execTab.BorderSizePixel = 0
    execTab.Font = Enum.Font.GothamBold
    execTab.TextSize = 16
    execTab.Parent = tabs

    local mainContainer = Instance.new("ScrollingFrame")
    mainContainer.Size = UDim2.new(1, -10, 1, -100)
    mainContainer.Position = UDim2.new(0, 5, 0, 95)
    mainContainer.BackgroundTransparency = 1
    mainContainer.ScrollBarThickness = 5
    mainContainer.Visible = true
    mainContainer.Parent = frame

    local execContainer = Instance.new("ScrollingFrame")
    execContainer.Size = UDim2.new(1, -10, 1, -100)
    execContainer.Position = UDim2.new(0, 5, 0, 95)
    execContainer.BackgroundTransparency = 1
    execContainer.ScrollBarThickness = 5
    execContainer.Visible = false
    execContainer.Parent = frame

    local function addButton(container, text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextScaled = false
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.Parent = container

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    addButton(mainContainer, "🛡️ GOD MODE", Color3.new(0, 0.6, 0.2), toggleGodMode)
    addButton(mainContainer, "✈️ FLY (LOAD)", Color3.new(0, 0.5, 0.8), loadFlyScript)
    addButton(mainContainer, "🌀 NO FALL", Color3.new(0.2, 0.6, 0.6), toggleNoFall)
    addButton(mainContainer, "⚡ SPEED 50", Color3.new(0.8, 0.7, 0), function() setSpeed(50) end)
    addButton(mainContainer, "⚡ SPEED 100", Color3.new(0.8, 0.7, 0), function() setSpeed(100) end)
    addButton(mainContainer, "⚡ SPEED 250", Color3.new(0.8, 0.7, 0), function() setSpeed(250) end)
    addButton(mainContainer, "🦘 JUMP 80", Color3.new(0, 0.7, 0.4), function() setJump(80) end)
    addButton(mainContainer, "🦘 JUMP 150", Color3.new(0, 0.7, 0.4), function() setJump(150) end)
    addButton(mainContainer, "🦘 JUMP 300", Color3.new(0, 0.7, 0.4), function() setJump(300) end)
    addButton(mainContainer, "💀 KILL ALL", Color3.new(0.8, 0, 0), killAll)
    addButton(mainContainer, "🔄 RESET", Color3.new(0.5, 0.5, 0.5), resetCharacter)
    addButton(mainContainer, "🌀 INFINITY YIELD", Color3.new(0.8, 0.3, 0.8), loadInfinityYield)

    local execBox = Instance.new("TextBox")
    execBox.Size = UDim2.new(1, 0, 0, 80)
    execBox.Position = UDim2.new(0, 0, 0, 5)
    execBox.Text = ""
    execBox.TextColor3 = Color3.new(1, 1, 1)
    execBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
    execBox.BorderSizePixel = 0
    execBox.PlaceholderText = "-- Enter Lua code here --"
    execBox.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
    execBox.ClearTextOnFocus = false
    execBox.Font = Enum.Font.Code
    execBox.TextSize = 14
    execBox.TextXAlignment = Enum.TextXAlignment.Left
    execBox.TextYAlignment = Enum.TextYAlignment.Top
    execBox.Parent = execContainer

    local execBoxCorner = Instance.new("UICorner")
    execBoxCorner.CornerRadius = UDim.new(0, 10)
    execBoxCorner.Parent = execBox

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(1, 0, 0, 40)
    execBtn.Position = UDim2.new(0, 0, 0, 90)
    execBtn.Text = "▶️ EXECUTE"
    execBtn.TextColor3 = Color3.new(1, 1, 1)
    execBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
    execBtn.BorderSizePixel = 0
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 18
    execBtn.Parent = execContainer

    local execBtnCorner = Instance.new("UICorner")
    execBtnCorner.CornerRadius = UDim.new(0, 10)
    execBtnCorner.Parent = execBtn

    execBtn.MouseButton1Click:Connect(function()
        executeLua(execBox.Text)
    end)

    mainTab.MouseButton1Click:Connect(function()
        mainContainer.Visible = true
        execContainer.Visible = false
        mainTab.BackgroundColor3 = Color3.new(0.3, 0.1, 0.6)
        execTab.BackgroundColor3 = Color3.new(0.1, 0.05, 0.2)
    end)

    execTab.MouseButton1Click:Connect(function()
        mainContainer.Visible = false
        execContainer.Visible = true
        execTab.BackgroundColor3 = Color3.new(0.3, 0.1, 0.6)
        mainTab.BackgroundColor3 = Color3.new(0.1, 0.05, 0.2)
    end)

    local layout = Instance.new("UIListLayout")
    layout.Parent = mainContainer
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    mainContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        mainContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    frame:TweenSize(UDim2.new(0, 420, 0, 560), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
end

player.CharacterAdded:Connect(function()
    wait(1)
    updateCharacterReferences()
    if godModeActive then toggleGodMode() end
    if noFallActive then toggleNoFall() end
    setSpeed(currentSpeed)
    setJump(currentJump)
end)

pcall(function()
    antiBan()
    createUI()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "ULTRA HUB v5.1 LOADED", Duration = 3})
end)
