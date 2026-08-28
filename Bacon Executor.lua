local player = game.Players.LocalPlayer
local sg = game:GetService("StarterGui")
local uis = game:GetService("UserInputService")

local correctKey = "123"
local keyEntered = false
local mainGui = nil

local function executeLua(code)
    if code and code ~= "" then
        local func, err = loadstring(code)
        if func then
            local success, result = pcall(func)
            if not success then
                sg:SetCore("SendNotification", {Title = "[BACON]", Text = "Error: " .. tostring(result), Duration = 5})
            else
                sg:SetCore("SendNotification", {Title = "[BACON]", Text = "✅ Code executed!", Duration = 2})
            end
        else
            sg:SetCore("SendNotification", {Title = "[BACON]", Text = "Error: " .. tostring(err), Duration = 5})
        end
    end
end

local function createMainUI()
    if mainGui then mainGui:Destroy() end
    mainGui = Instance.new("ScreenGui")
    mainGui.Name = "BaconInjector"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 420)
    frame.Position = UDim2.new(0.5, -175, 0.5, -210)
    frame.BackgroundColor3 = Color3.new(0.1, 0.05, 0.05)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.new(0.8, 0.3, 0.1)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = mainGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 35)
    top.BackgroundColor3 = Color3.new(0.2, 0.1, 0.05)
    top.BackgroundTransparency = 0.2
    top.BorderSizePixel = 0
    top.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "✦ BACON INJECTOR ✦"
    title.TextColor3 = Color3.new(0.8, 0.5, 0.2)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

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
        mainGui:Destroy()
        mainGui = nil
    end)

    -- КОНСОЛЬ (вывод сообщений)
    local consoleFrame = Instance.new("ScrollingFrame")
    consoleFrame.Size = UDim2.new(1, -10, 0, 150)
    consoleFrame.Position = UDim2.new(0, 5, 0, 40)
    consoleFrame.BackgroundColor3 = Color3.new(0.02, 0.02, 0.02)
    consoleFrame.BackgroundTransparency = 0.3
    consoleFrame.BorderSizePixel = 2
    consoleFrame.BorderColor3 = Color3.new(0.8, 0.3, 0.1)
    consoleFrame.ScrollBarThickness = 5
    consoleFrame.Parent = frame

    local consoleCorner = Instance.new("UICorner")
    consoleCorner.CornerRadius = UDim.new(0, 6)
    consoleCorner.Parent = consoleFrame

    local consoleContainer = Instance.new("Frame")
    consoleContainer.Size = UDim2.new(1, 0, 1, 0)
    consoleContainer.BackgroundTransparency = 1
    consoleContainer.Parent = consoleFrame

    local consoleLayout = Instance.new("UIListLayout")
    consoleLayout.Parent = consoleContainer
    consoleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    consoleLayout.Padding = UDim.new(0, 2)

    local function addConsoleMessage(text, color)
        local msg = Instance.new("TextLabel")
        msg.Size = UDim2.new(1, -10, 0, 20)
        msg.Text = text
        msg.TextColor3 = color or Color3.new(1, 1, 1)
        msg.BackgroundTransparency = 1
        msg.Font = Enum.Font.Code
        msg.TextSize = 12
        msg.TextXAlignment = Enum.TextXAlignment.Left
        msg.Parent = consoleContainer
        consoleFrame.CanvasSize = UDim2.new(0, 0, 0, consoleLayout.AbsoluteContentSize.Y + 10)
        consoleFrame.CanvasPosition = Vector2.new(0, consoleFrame.CanvasSize.Y.Offset)
        consoleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            consoleFrame.CanvasSize = UDim2.new(0, 0, 0, consoleLayout.AbsoluteContentSize.Y + 10)
            consoleFrame.CanvasPosition = Vector2.new(0, consoleFrame.CanvasSize.Y.Offset)
        end)
    end

    addConsoleMessage("🍀 BACON INJECTOR v2.0", Color3.new(0.8, 0.5, 0.2))
    addConsoleMessage("⚡ UNC: ∞ (бесконечность)", Color3.new(0.3, 0.8, 0.3))
    addConsoleMessage("📌 Введи код и нажми EXECUTE", Color3.new(0.3, 0.6, 1))
    addConsoleMessage("---", Color3.new(0.5, 0.5, 0.5))

    -- ПОЛЕ ВВОДА КОДА
    local execBox = Instance.new("TextBox")
    execBox.Size = UDim2.new(1, -10, 0, 100)
    execBox.Position = UDim2.new(0, 5, 0, 200)
    execBox.Text = ""
    execBox.TextColor3 = Color3.new(1, 1, 1)
    execBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    execBox.BorderSizePixel = 2
    execBox.BorderColor3 = Color3.new(0.8, 0.3, 0.1)
    execBox.PlaceholderText = "-- Enter Lua code here --"
    execBox.PlaceholderColor3 = Color3.new(0.5, 0.2, 0)
    execBox.ClearTextOnFocus = false
    execBox.Font = Enum.Font.Code
    execBox.TextSize = 14
    execBox.TextXAlignment = Enum.TextXAlignment.Left
    execBox.TextYAlignment = Enum.TextYAlignment.Top
    execBox.Parent = frame

    -- КНОПКИ
    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0.45, 0, 0, 30)
    execBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
    execBtn.Text = "▶️ EXECUTE"
    execBtn.TextColor3 = Color3.new(1, 1, 1)
    execBtn.BackgroundColor3 = Color3.new(0.3, 0.15, 0)
    execBtn.BorderSizePixel = 2
    execBtn.BorderColor3 = Color3.new(0.8, 0.3, 0.1)
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 14
    execBtn.Parent = frame

    execBtn.MouseButton1Click:Connect(function()
        local code = execBox.Text
        if code and code ~= "" then
            addConsoleMessage("> Executing code...", Color3.new(0.3, 0.8, 1))
            executeLua(code)
            addConsoleMessage("✅ Done!", Color3.new(0.3, 1, 0.3))
            execBox.Text = ""
        else
            addConsoleMessage("❌ Enter some code!", Color3.new(1, 0.3, 0.3))
        end
    end)

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0.4, 0, 0, 30)
    clearBtn.Position = UDim2.new(0.55, 0, 0.8, 0)
    clearBtn.Text = "🗑️ CLEAR"
    clearBtn.TextColor3 = Color3.new(1, 1, 1)
    clearBtn.BackgroundColor3 = Color3.new(0.2, 0.1, 0.1)
    clearBtn.BorderSizePixel = 2
    clearBtn.BorderColor3 = Color3.new(0.8, 0.3, 0.1)
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.TextSize = 14
    clearBtn.Parent = frame

    clearBtn.MouseButton1Click:Connect(function()
        execBox.Text = ""
        for _, child in pairs(consoleContainer:GetChildren()) do
            child:Destroy()
        end
        addConsoleMessage("🧹 Console cleared", Color3.new(0.5, 0.5, 0.5))
        addConsoleMessage("---", Color3.new(0.5, 0.5, 0.5))
    end)

    -- КНОПКА БЫСТРОГО ТЕСТА
    local testBtn = Instance.new("TextButton")
    testBtn.Size = UDim2.new(0.3, 0, 0, 25)
    testBtn.Position = UDim2.new(0.35, 0, 0.92, 0)
    testBtn.Text = "🧪 TEST"
    testBtn.TextColor3 = Color3.new(1, 1, 1)
    testBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    testBtn.BorderSizePixel = 2
    testBtn.BorderColor3 = Color3.new(0.8, 0.3, 0.1)
    testBtn.Font = Enum.Font.GothamBold
    testBtn.TextSize = 12
    testBtn.Parent = frame

    testBtn.MouseButton1Click:Connect(function()
        local testCode = [[
            print("BACON TEST!")
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
        ]]
        execBox.Text = testCode
        addConsoleMessage("🧪 Test code loaded", Color3.new(0.3, 0.8, 0.8))
    end)

    addConsoleMessage("✅ Ready!", Color3.new(0.3, 1, 0.3))
end

local function createKeyUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystem"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 160)
    frame.Position = UDim2.new(0.5, -140, 0.5, -80)
    frame.BackgroundColor3 = Color3.new(0.1, 0.05, 0.05)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.new(0.8, 0.3, 0.1)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "✦ BACON INJECTOR ✦"
    title.TextColor3 = Color3.new(0.8, 0.5, 0.2)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.8, 0, 0, 30)
    box.Position = UDim2.new(0.1, 0, 0.3, 0)
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.new(0.8, 0.3, 0.1)
    box.PlaceholderText = "Enter key..."
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = frame

    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(0.5, 0, 0, 30)
    checkBtn.Position = UDim2.new(0.25, 0, 0.6, 0)
    checkBtn.Text = "✓ CHECK"
    checkBtn.TextColor3 = Color3.new(1, 1, 1)
    checkBtn.BackgroundColor3 = Color3.new(0.3, 0.15, 0)
    checkBtn.BorderSizePixel = 2
    checkBtn.BorderColor3 = Color3.new(0.8, 0.3, 0.1)
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.TextSize = 14
    checkBtn.Parent = frame

    checkBtn.MouseButton1Click:Connect(function()
        if box.Text == correctKey then
            keyEntered = true
            gui:Destroy()
            sg:SetCore("SendNotification", {Title = "[BACON]", Text = "✅ Key accepted!", Duration = 2})
            createMainUI()
        else
            sg:SetCore("SendNotification", {Title = "[BACON]", Text = "❌ Wrong key!", Duration = 2})
            box.Text = ""
        end
    end)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 2)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.BackgroundColor3 = Color3.new(0.5, 0, 0)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

sg:SetCore("SendNotification", {Title = "[BACON]", Text = "Enter key: 123", Duration = 3})
createKeyUI()
