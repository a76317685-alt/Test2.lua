local player = game.Players.LocalPlayer
local sg = game:GetService("StarterGui")
local uis = game:GetService("UserInputService")

local correctKey = "c00lkidd hub 2026"
local keyEntered = false
local mainGui = nil
local quizPassed = false
local currentQuestion = 1

local questions = {
    {
        text = "🎮 Вопрос 1: В какую игру я чаще всего играю на TikTok?",
        answer = "murino horror"
    },
    {
        text = "🎮 Вопрос 2: Какой мой любимый режим в Murder Mystery 2?",
        answer = "hardcore"
    },
    {
        text = "🎮 Вопрос 3: Какой скрипт я использую чаще всего?",
        answer = "infinity yield"
    }
}

local function checkQuiz()
    return quizPassed
end

local function createMainUI()
    if mainGui then mainGui:Destroy() end
    mainGui = Instance.new("ScreenGui")
    mainGui.Name = "c00lkiddHub"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 420)
    frame.Position = UDim2.new(0.5, -160, 0.5, -210)
    frame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 4
    frame.BorderColor3 = Color3.new(1, 0, 0)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = mainGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 0)
    corner.Parent = frame

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 35)
    top.BackgroundColor3 = Color3.new(0.1, 0, 0)
    top.BackgroundTransparency = 0.2
    top.BorderSizePixel = 2
    top.BorderColor3 = Color3.new(1, 0, 0)
    top.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "✦ c00lkidd ULTRA HUB ✦"
    title.TextColor3 = Color3.new(1, 0, 0)
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

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -45)
    scroll.Position = UDim2.new(0, 5, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.Parent = frame

    local function addButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.new(1, 0, 0)
        btn.Parent = scroll
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    addButton("✈️ FLY", Color3.new(0.2, 0, 0), function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1,1,1) * 1e9
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp
        uis.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                bv.Velocity = Vector3.new(0,50,0)
            end
        end)
        sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "Fly ON", Duration = 2})
    end)

    addButton("⚡ SPEED 60", Color3.new(0.2, 0.1, 0), function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 60 end
        sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "Speed 60", Duration = 2})
    end)

    addButton("🦘 JUMP 80", Color3.new(0.1, 0.1, 0), function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = 80 end
        sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "Jump 80", Duration = 2})
    end)

    addButton("🛡️ GOD MODE", Color3.new(0, 0.2, 0), function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.Health = math.huge end
        sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "God Mode ON", Duration = 2})
    end)

    addButton("⚡ SPEED 100", Color3.new(0.15, 0.1, 0), function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 100 end
        sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "Speed 100", Duration = 2})
    end)

    addButton("📌 TP TO PLAYER", Color3.new(0.1, 0, 0.1), function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character then
                hrp.CFrame = v.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "Teleported to " .. v.Name, Duration = 2})
                return
            end
        end
    end)

    addButton("🌀 INFINITY YIELD", Color3.new(0.2, 0, 0.2), function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
    end)

    local execBox = Instance.new("TextBox")
    execBox.Size = UDim2.new(1, 0, 0, 70)
    execBox.Position = UDim2.new(0, 0, 1, -85)
    execBox.Text = ""
    execBox.TextColor3 = Color3.new(1, 1, 1)
    execBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    execBox.BorderSizePixel = 2
    execBox.BorderColor3 = Color3.new(1, 0, 0)
    execBox.PlaceholderText = "-- Enter Lua code here --"
    execBox.PlaceholderColor3 = Color3.new(0.5, 0, 0)
    execBox.ClearTextOnFocus = false
    execBox.Font = Enum.Font.Code
    execBox.TextSize = 14
    execBox.TextXAlignment = Enum.TextXAlignment.Left
    execBox.TextYAlignment = Enum.TextYAlignment.Top
    execBox.Parent = scroll

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0.6, 0, 0, 30)
    execBtn.Position = UDim2.new(0.2, 0, 1, -50)
    execBtn.Text = "▶️ EXECUTE"
    execBtn.TextColor3 = Color3.new(1, 1, 1)
    execBtn.BackgroundColor3 = Color3.new(0.3, 0, 0)
    execBtn.BorderSizePixel = 2
    execBtn.BorderColor3 = Color3.new(1, 0, 0)
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 14
    execBtn.Parent = scroll
    execBtn.MouseButton1Click:Connect(function()
        local code = execBox.Text
        if code and code ~= "" then
            local func, err = loadstring(code)
            if func then
                pcall(func)
                sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "Code executed!", Duration = 3})
            else
                sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "Error: " .. tostring(err), Duration = 5})
            end
        end
    end)

    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 100)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 100)
    end)
end

local function createKeyUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystem"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 420)
    frame.Position = UDim2.new(0.5, -170, 0.5, -210)
    frame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 4
    frame.BorderColor3 = Color3.new(1, 0, 0)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 0)
    corner.Parent = frame

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 35)
    top.BackgroundColor3 = Color3.new(0.1, 0, 0)
    top.BackgroundTransparency = 0.2
    top.BorderSizePixel = 2
    top.BorderColor3 = Color3.new(1, 0, 0)
    top.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "🟥 c00lkidd ULTRA HUB 🟥"
    title.TextColor3 = Color3.new(1, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 25, 0, 25)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "X"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.BackgroundColor3 = Color3.new(0.5, 0, 0)
    close.BackgroundTransparency = 0.3
    close.BorderSizePixel = 0
    close.Font = Enum.Font.GothamBold
    close.TextSize = 16
    close.Parent = top
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.8, 0, 0, 30)
    box.Position = UDim2.new(0.1, 0, 0.12, 0)
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.new(1, 0, 0)
    box.PlaceholderText = "Введите ключ..."
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = frame

    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(0.3, 0, 0, 30)
    checkBtn.Position = UDim2.new(0.35, 0, 0.22, 0)
    checkBtn.Text = "✅ CHECK"
    checkBtn.TextColor3 = Color3.new(1, 1, 1)
    checkBtn.BackgroundColor3 = Color3.new(0.2, 0, 0)
    checkBtn.BorderSizePixel = 2
    checkBtn.BorderColor3 = Color3.new(1, 0, 0)
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.TextSize = 14
    checkBtn.Parent = frame

    checkBtn.MouseButton1Click:Connect(function()
        if box.Text == correctKey then
            keyEntered = true
            gui:Destroy()
            sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "✅ Ключ принят!", Duration = 3})
            createMainUI()
        else
            sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "❌ Неверный ключ!", Duration = 3})
            box.Text = ""
        end
    end)

    local linkLabel = Instance.new("TextLabel")
    linkLabel.Size = UDim2.new(1, 0, 0, 20)
    linkLabel.Position = UDim2.new(0, 0, 0.3, 0)
    linkLabel.Text = "📱 Получить ключ: @limbo3041"
    linkLabel.TextColor3 = Color3.new(0.3, 0.8, 1)
    linkLabel.BackgroundTransparency = 1
    linkLabel.Font = Enum.Font.GothamBold
    linkLabel.TextSize = 14
    linkLabel.Parent = frame

    local linkBtn = Instance.new("TextButton")
    linkBtn.Size = UDim2.new(0.4, 0, 0, 25)
    linkBtn.Position = UDim2.new(0.3, 0, 0.36, 0)
    linkBtn.Text = "📋 COPY LINK"
    linkBtn.TextColor3 = Color3.new(1, 1, 1)
    linkBtn.BackgroundColor3 = Color3.new(0.1, 0.05, 0.1)
    linkBtn.BorderSizePixel = 2
    linkBtn.BorderColor3 = Color3.new(1, 0, 0)
    linkBtn.Font = Enum.Font.GothamBold
    linkBtn.TextSize = 12
    linkBtn.Parent = frame
    linkBtn.MouseButton1Click:Connect(function()
        local link = "https://www.tiktok.com/@limbo3041"
        if setclipboard then
            setclipboard(link)
            sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "🔗 Ссылка скопирована!", Duration = 3})
        else
            sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "❌ setclipboard не поддерживается", Duration = 3})
        end
    end)

    local quizLabel = Instance.new("TextLabel")
    quizLabel.Size = UDim2.new(1, 0, 0, 20)
    quizLabel.Position = UDim2.new(0, 0, 0.44, 0)
    quizLabel.Text = "📋 ОТВЕТЬ НА ВОПРОСЫ (про мой контент)"
    quizLabel.TextColor3 = Color3.new(0.3, 0.8, 1)
    quizLabel.BackgroundTransparency = 1
    quizLabel.Font = Enum.Font.GothamBold
    quizLabel.TextSize = 12
    quizLabel.Parent = frame

    local qLabel = Instance.new("TextLabel")
    qLabel.Size = UDim2.new(0.9, 0, 0, 30)
    qLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
    qLabel.Text = questions[currentQuestion].text
    qLabel.TextColor3 = Color3.new(1, 1, 1)
    qLabel.BackgroundTransparency = 1
    qLabel.Font = Enum.Font.Gotham
    qLabel.TextSize = 12
    qLabel.TextWrapped = true
    qLabel.Parent = frame

    local qBox = Instance.new("TextBox")
    qBox.Size = UDim2.new(0.8, 0, 0, 25)
    qBox.Position = UDim2.new(0.1, 0, 0.64, 0)
    qBox.Text = ""
    qBox.TextColor3 = Color3.new(1, 1, 1)
    qBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    qBox.BorderSizePixel = 2
    qBox.BorderColor3 = Color3.new(1, 0, 0)
    qBox.PlaceholderText = "Ваш ответ..."
    qBox.Font = Enum.Font.Gotham
    qBox.TextSize = 14
    qBox.Parent = frame

    local qBtn = Instance.new("TextButton")
    qBtn.Size = UDim2.new(0.3, 0, 0, 25)
    qBtn.Position = UDim2.new(0.35, 0, 0.74, 0)
    qBtn.Text = "> ОТВЕТИТЬ"
    qBtn.TextColor3 = Color3.new(1, 1, 1)
    qBtn.BackgroundColor3 = Color3.new(0.2, 0, 0)
    qBtn.BorderSizePixel = 2
    qBtn.BorderColor3 = Color3.new(1, 0, 0)
    qBtn.Font = Enum.Font.GothamBold
    qBtn.TextSize = 12
    qBtn.Parent = frame

    qBtn.MouseButton1Click:Connect(function()
        local answer = string.lower(qBox.Text)
        local correct = string.lower(questions[currentQuestion].answer)
        if answer == correct then
            sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "✅ Правильно! Переходим к следующему вопросу", Duration = 3})
            currentQuestion = currentQuestion + 1
            if currentQuestion > #questions then
                quizPassed = true
                sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "🎉 Ты ответил на все вопросы! Загружай скрипт.", Duration = 5})
                qBtn.Text = "✅ ГОТОВО"
                qBtn.BackgroundColor3 = Color3.new(0, 0.3, 0)
                qLabel.Text = "🎉 Все вопросы пройдены!"
                qBox.Visible = false
            else
                qLabel.Text = questions[currentQuestion].text
                qBox.Text = ""
            end
        else
            sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "❌ Неправильно! Попробуй ещё раз.", Duration = 3})
            qBox.Text = ""
        end
    end)

    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0.6, 0, 0, 30)
    loadBtn.Position = UDim2.new(0.2, 0, 0.85, 0)
    loadBtn.Text = "🚀 LOAD SCRIPT"
    loadBtn.TextColor3 = Color3.new(1, 1, 1)
    loadBtn.BackgroundColor3 = Color3.new(0.3, 0, 0)
    loadBtn.BorderSizePixel = 3
    loadBtn.BorderColor3 = quizPassed and Color3.new(0, 1, 0) or Color3.new(0.3, 0.3, 0.3)
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.TextSize = 16
    loadBtn.Parent = frame

    loadBtn.MouseButton1Click:Connect(function()
        if not quizPassed then
            sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "❌ Ответь на все вопросы!", Duration = 3})
            return
        end
        keyEntered = true
        gui:Destroy()
        sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "🚀 Загрузка...", Duration = 3})
        wait(1)
        createMainUI()
    end)
end

sg:SetCore("SendNotification", {Title = "[c00lkidd]", Text = "Введите ключ или ответьте на вопросы", Duration = 3})
createKeyUI()
