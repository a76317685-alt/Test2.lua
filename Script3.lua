local player = game.Players.LocalPlayer
local sg = game:GetService("StarterGui")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local http = game:GetService("HttpService")

local password = "XyZ#2026!QwErTy@"
local keyEntered = false
local mainGui = nil
local keyGui = nil
local keyVisible = true
local mainVisible = true
local circleBtn = nil

local dragging = false
local dragStart = nil
local startPos = nil
local dragObject = nil

local currentWidth = 350
local minWidth = 250
local maxWidth = 600
local widthStep = 50

local function fastExecute(code)
    if code and code ~= "" then
        local fn, err = loadstring(code)
        if fn then
            local success, result = pcall(fn)
            if not success then
                sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "Error: " .. tostring(result), Duration = 3})
            else
                sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "✅ Executed!", Duration = 1})
            end
        else
            sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "Error: " .. tostring(err), Duration = 3})
        end
    end
end

local function createCircleButton()
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlashCircleBtn"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0.5, -25, 0.85, 0)
    btn.Text = "⚡"
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.BackgroundColor3 = Color3.new(0.02, 0.02, 0.05)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 3
    btn.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 30
    btn.Visible = false
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    circleBtn = btn

    btn.MouseButton1Click:Connect(function()
        if mainGui then
            mainGui.Enabled = true
            mainVisible = true
            local frame = mainGui:FindFirstChild("MainFrame")
            if frame then
                frame.Visible = true
            end
            btn.Visible = false
            sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "🔓 Инжектор открыт", Duration = 2})
        end
    end)

    return btn
end

local function updateFrameWidth(frame, newWidth)
    currentWidth = math.clamp(newWidth, minWidth, maxWidth)
    frame.Size = UDim2.new(0, currentWidth, 0, 350)
    frame.Position = UDim2.new(0.5, -currentWidth/2, 0.5, -175)
end

local function createMainUI()
    if mainGui then mainGui:Destroy() end
    mainGui = Instance.new("ScreenGui")
    mainGui.Name = "FlashInjector"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 350, 0, 350)
    frame.Position = UDim2.new(0.5, -175, 0.5, -175)
    frame.BackgroundColor3 = Color3.new(0.02, 0.02, 0.05)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    frame.Active = true
    frame.Draggable = false
    frame.Parent = mainGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 40)
    top.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    top.BackgroundTransparency = 0.2
    top.BorderSizePixel = 2
    top.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    top.Active = true
    top.Parent = frame

    local sizeLeft = Instance.new("TextButton")
    sizeLeft.Size = UDim2.new(0, 25, 0, 25)
    sizeLeft.Position = UDim2.new(1, -120, 0, 7)
    sizeLeft.Text = "◀"
    sizeLeft.TextColor3 = Color3.new(1, 1, 1)
    sizeLeft.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
    sizeLeft.BackgroundTransparency = 0.3
    sizeLeft.BorderSizePixel = 2
    sizeLeft.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    sizeLeft.Font = Enum.Font.GothamBold
    sizeLeft.TextSize = 14
    sizeLeft.Parent = top

    local sizeRight = Instance.new("TextButton")
    sizeRight.Size = UDim2.new(0, 25, 0, 25)
    sizeRight.Position = UDim2.new(1, -90, 0, 7)
    sizeRight.Text = "▶"
    sizeRight.TextColor3 = Color3.new(1, 1, 1)
    sizeRight.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
    sizeRight.BackgroundTransparency = 0.3
    sizeRight.BorderSizePixel = 2
    sizeRight.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    sizeRight.Font = Enum.Font.GothamBold
    sizeRight.TextSize = 14
    sizeRight.Parent = top

    sizeLeft.MouseButton1Click:Connect(function()
        updateFrameWidth(frame, currentWidth - widthStep)
    end)

    sizeRight.MouseButton1Click:Connect(function()
        updateFrameWidth(frame, currentWidth + widthStep)
    end)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -160, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "✦ FLASH INJECTOR ✦"
    title.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local hideMainBtn = Instance.new("TextButton")
    hideMainBtn.Size = UDim2.new(0, 25, 0, 25)
    hideMainBtn.Position = UDim2.new(1, -60, 0, 7)
    hideMainBtn.Text = "_"
    hideMainBtn.TextColor3 = Color3.new(1, 1, 1)
    hideMainBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
    hideMainBtn.BackgroundTransparency = 0.3
    hideMainBtn.BorderSizePixel = 2
    hideMainBtn.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    hideMainBtn.Font = Enum.Font.GothamBold
    hideMainBtn.TextSize = 18
    hideMainBtn.Parent = top

    hideMainBtn.MouseButton1Click:Connect(function()
        mainVisible = not mainVisible
        frame.Visible = mainVisible
        if mainVisible then
            hideMainBtn.Text = "_"
            if circleBtn then circleBtn.Visible = false end
            sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "🔓 Главное окно показано", Duration = 2})
        else
            hideMainBtn.Text = "□"
            if circleBtn then circleBtn.Visible = true end
            sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "🔒 Главное окно скрыто", Duration = 2})
        end
    end)

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 25, 0, 25)
    close.Position = UDim2.new(1, -30, 0, 7)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.BackgroundColor3 = Color3.new(0.5, 0, 0)
    close.BackgroundTransparency = 0.3
    close.BorderSizePixel = 0
    close.Font = Enum.Font.GothamBold
    close.TextSize = 16
    close.Parent = top
    close.MouseButton1Click:Connect(function()
        mainGui:Destroy()
        mainGui = nil
        if circleBtn then circleBtn.Visible = true end
    end)

    local execBox = Instance.new("TextBox")
    execBox.Size = UDim2.new(1, -10, 0, 150)
    execBox.Position = UDim2.new(0, 5, 0, 50)
    execBox.Text = ""
    execBox.TextColor3 = Color3.new(1, 1, 1)
    execBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    execBox.BorderSizePixel = 2
    execBox.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    execBox.PlaceholderText = "-- Enter Lua code here --"
    execBox.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
    execBox.ClearTextOnFocus = false
    execBox.Font = Enum.Font.Code
    execBox.TextSize = 14
    execBox.TextXAlignment = Enum.TextXAlignment.Left
    execBox.TextYAlignment = Enum.TextYAlignment.Top
    execBox.Parent = frame

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0.6, 0, 0, 35)
    execBtn.Position = UDim2.new(0.2, 0, 0.75, 0)
    execBtn.Text = "⚡ EXECUTE"
    execBtn.TextColor3 = Color3.new(1, 1, 1)
    execBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
    execBtn.BorderSizePixel = 2
    execBtn.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 16
    execBtn.Parent = frame
    execBtn.MouseButton1Click:Connect(function()
        fastExecute(execBox.Text)
    end)

    local function addQuickButton(text, color, y, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.28, 0, 0, 25)
        btn.Position = UDim2.new(y, 0, 0.88, 0)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = frame
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    addQuickButton("🧹 CLEAR", Color3.new(0.2, 0.1, 0.1), 0.02, function()
        execBox.Text = ""
    end)

    addQuickButton("🧪 TEST", Color3.new(0.1, 0.2, 0.1), 0.36, function()
        execBox.Text = 'print("FLASH INJECTOR TEST!")\nlocal p = game.Players.LocalPlayer\nif p.Character then p.Character.Humanoid.WalkSpeed = 60 end'
    end)

    addQuickButton("🔄 RESET", Color3.new(0.1, 0.1, 0.2), 0.70, function()
        player:LoadCharacter()
        sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "🔄 Reset", Duration = 2})
    end)

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local framePos = frame.AbsolutePosition
            local frameSize = frame.AbsoluteSize
            if pos.X >= framePos.X and pos.X <= framePos.X + frameSize.X and
               pos.Y >= framePos.Y and pos.Y <= framePos.Y + 40 then
                dragging = true
                dragStart = pos
                startPos = frame.Position
                dragObject = input
            end
        end
    end

    local function onInputChanged(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end

    local function onInputEnded(input)
        if input == dragObject then
            dragging = false
            dragObject = nil
        end
    end

    uis.InputBegan:Connect(onInputBegan)
    uis.InputChanged:Connect(onInputChanged)
    uis.InputEnded:Connect(onInputEnded)
end

local function createKeyUI()
    if keyGui then keyGui:Destroy() end
    keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 180)
    frame.Position = UDim2.new(0.5, -150, 0.5, -90)
    frame.BackgroundColor3 = Color3.new(0.02, 0.02, 0.05)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    frame.Active = true
    frame.Draggable = false
    frame.Parent = keyGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 35)
    top.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    top.BackgroundTransparency = 0.2
    top.BorderSizePixel = 0
    top.Active = true
    top.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "✦ FLASH INJECTOR ✦"
    title.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local hideKeyBtn = Instance.new("TextButton")
    hideKeyBtn.Size = UDim2.new(0, 25, 0, 25)
    hideKeyBtn.Position = UDim2.new(1, -60, 0, 5)
    hideKeyBtn.Text = "_"
    hideKeyBtn.TextColor3 = Color3.new(1, 1, 1)
    hideKeyBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
    hideKeyBtn.BackgroundTransparency = 0.3
    hideKeyBtn.BorderSizePixel = 2
    hideKeyBtn.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    hideKeyBtn.Font = Enum.Font.GothamBold
    hideKeyBtn.TextSize = 18
    hideKeyBtn.Parent = top

    hideKeyBtn.MouseButton1Click:Connect(function()
        keyVisible = not keyVisible
        frame.Visible = keyVisible
        if keyVisible then
            hideKeyBtn.Text = "_"
            sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "🔓 Окно пароля показано", Duration = 2})
        else
            hideKeyBtn.Text = "□"
            sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "🔒 Окно пароля скрыто", Duration = 2})
        end
    end)

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 25, 0, 25)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.BackgroundColor3 = Color3.new(0.5, 0, 0)
    close.BackgroundTransparency = 0.3
    close.BorderSizePixel = 0
    close.Font = Enum.Font.GothamBold
    close.TextSize = 16
    close.Parent = top
    close.MouseButton1Click:Connect(function()
        keyGui:Destroy()
        keyGui = nil
    end)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.8, 0, 0, 30)
    box.Position = UDim2.new(0.1, 0, 0.3, 0)
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    box.PlaceholderText = "Enter password..."
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = frame

    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(0.5, 0, 0, 30)
    checkBtn.Position = UDim2.new(0.25, 0, 0.6, 0)
    checkBtn.Text = "✓ UNLOCK"
    checkBtn.TextColor3 = Color3.new(1, 1, 1)
    checkBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
    checkBtn.BorderSizePixel = 2
    checkBtn.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.TextSize = 14
    checkBtn.Parent = frame

    checkBtn.MouseButton1Click:Connect(function()
        if box.Text == password then
            keyEntered = true
            keyGui:Destroy()
            keyGui = nil
            sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "✅ Access Granted!", Duration = 2})
            createCircleButton()
            createMainUI()
        else
            sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "❌ Wrong password!", Duration = 2})
            box.Text = ""
        end
    end)

    local function onKeyInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local framePos = frame.AbsolutePosition
            local frameSize = frame.AbsoluteSize
            if pos.X >= framePos.X and pos.X <= framePos.X + frameSize.X and
               pos.Y >= framePos.Y and pos.Y <= framePos.Y + 35 then
                dragging = true
                dragStart = pos
                startPos = frame.Position
                dragObject = input
            end
        end
    end

    uis.InputBegan:Connect(onKeyInputBegan)
    uis.InputChanged:Connect(onInputChanged)
    uis.InputEnded:Connect(onInputEnded)
end

sg:SetCore("SendNotification", {Title = "[FLASH]", Text = "Enter password to continue", Duration = 3})
createKeyUI()
