local player = game.Players.LocalPlayer
local sg = game:GetService("StarterGui")
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")

local correctKey = "TUBERS93"
local keyEntered = false
local isHidden = false
local mainGui = nil
local execBox = nil
local circleBtn = nil
local savedScripts = {}
local currentSearchResults = {}

local currentWidth = 400
local minWidth = 300
local maxWidth = 600
local widthStep = 50

local function executeLua(code)
    if code and code ~= "" then
        local func, err = loadstring(code)
        if func then
            local success, result = pcall(func)
            if not success then
                sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Error: " .. tostring(result), Duration = 5})
            else
                sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Code executed!", Duration = 3})
            end
        else
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Error: " .. tostring(err), Duration = 5})
        end
    end
end

local function saveScriptData(name, code)
    if not name or name == "" then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Enter a script name!", Duration = 3})
        return
    end
    savedScripts[name] = code
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Script '" .. name .. "' saved!", Duration = 3})
    updateSavedList()
end

local function searchScriptblox(query)
    if not query or query == "" then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Enter a search query!", Duration = 3})
        return
    end
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Searching ScriptBlox for: " .. query, Duration = 3})
    local success, data = pcall(function()
        return game:HttpGet("https://scriptblox.com/api/scripts/search?q=" .. http:UrlEncode(query) .. "&limit=10", true)
    end)
    if success and data then
        local decoded = http:JSONDecode(data)
        if decoded and decoded.results then
            currentSearchResults = decoded.results
            local results = ""
            for i, script in pairs(decoded.results) do
                results = results .. i .. ". " .. script.title .. " (by " .. script.author .. ")\n"
            end
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Results:\n" .. results, Duration = 10})
            updateSearchResults()
        else
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "No scripts found.", Duration = 3})
        end
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Failed to search ScriptBlox", Duration = 3})
    end
end

local function loadScriptFromScriptBlox(id)
    local success, data = pcall(function()
        return game:HttpGet("https://scriptblox.com/api/scripts/" .. id, true)
    end)
    if success and data then
        local decoded = http:JSONDecode(data)
        if decoded and decoded.script then
            return decoded.script
        end
    end
    return nil
end

local function updateFrameWidth(frame, newWidth)
    currentWidth = math.clamp(newWidth, minWidth, maxWidth)
    frame.Size = UDim2.new(0, currentWidth, 0, 380)
    frame.Position = UDim2.new(0.5, -currentWidth/2, 0.5, -190)
end

local function updateSavedList()
end

local function updateSearchResults()
end

local function createCircleButton()
    local gui = Instance.new("ScreenGui")
    gui.Name = "TubersCircleBtn"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0.5, -25, 0.85, 0)
    btn.Text = "*"
    btn.TextColor3 = Color3.new(0, 1, 0)
    btn.BackgroundColor3 = Color3.new(0.05, 0.1, 0.05)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 3
    btn.BorderColor3 = Color3.new(0, 1, 0)
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
            btn.Visible = false
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Executor Shown", Duration = 2})
        end
    end)

    return btn
end

local function createMainUI()
    mainGui = Instance.new("ScreenGui")
    mainGui.Name = "TubersExecutor"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 380)
    frame.Position = UDim2.new(0.5, -200, 0.5, -190)
    frame.BackgroundColor3 = Color3.new(0.05, 0.1, 0.05)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.new(0, 1, 0)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = mainGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 0)
    corner.Parent = frame

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 35)
    top.BackgroundColor3 = Color3.new(0.02, 0.15, 0.02)
    top.BackgroundTransparency = 0.2
    top.BorderSizePixel = 2
    top.BorderColor3 = Color3.new(0, 1, 0)
    top.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -160, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "✦ TUBERS93 EXECUTOR ✦"
    title.TextColor3 = Color3.new(0, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local sizeLeft = Instance.new("TextButton")
    sizeLeft.Size = UDim2.new(0, 25, 0, 25)
    sizeLeft.Position = UDim2.new(1, -120, 0, 5)
    sizeLeft.Text = "◀"
    sizeLeft.TextColor3 = Color3.new(1, 1, 1)
    sizeLeft.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
    sizeLeft.BackgroundTransparency = 0.3
    sizeLeft.BorderSizePixel = 2
    sizeLeft.BorderColor3 = Color3.new(0, 1, 0)
    sizeLeft.Font = Enum.Font.GothamBold
    sizeLeft.TextSize = 14
    sizeLeft.Parent = top

    local sizeRight = Instance.new("TextButton")
    sizeRight.Size = UDim2.new(0, 25, 0, 25)
    sizeRight.Position = UDim2.new(1, -90, 0, 5)
    sizeRight.Text = "▶"
    sizeRight.TextColor3 = Color3.new(1, 1, 1)
    sizeRight.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
    sizeRight.BackgroundTransparency = 0.3
    sizeRight.BorderSizePixel = 2
    sizeRight.BorderColor3 = Color3.new(0, 1, 0)
    sizeRight.Font = Enum.Font.GothamBold
    sizeRight.TextSize = 14
    sizeRight.Parent = top

    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.new(0, 25, 0, 25)
    hideBtn.Position = UDim2.new(1, -60, 0, 5)
    hideBtn.Text = "_"
    hideBtn.TextColor3 = Color3.new(1, 1, 1)
    hideBtn.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
    hideBtn.BackgroundTransparency = 0.3
    hideBtn.BorderSizePixel = 2
    hideBtn.BorderColor3 = Color3.new(0, 1, 0)
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.TextSize = 18
    hideBtn.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 25, 0, 25)
    close.Position = UDim2.new(1, -30, 0, 5)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.BackgroundColor3 = Color3.new(0.5, 0, 0)
    close.BackgroundTransparency = 0.3
    close.BorderSizePixel = 2
    close.BorderColor3 = Color3.new(0, 1, 0)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.Parent = top

    sizeLeft.MouseButton1Click:Connect(function()
        updateFrameWidth(frame, currentWidth - widthStep)
    end)

    sizeRight.MouseButton1Click:Connect(function()
        updateFrameWidth(frame, currentWidth + widthStep)
    end)

    hideBtn.MouseButton1Click:Connect(function()
        mainGui.Enabled = false
        if circleBtn then circleBtn.Visible = true end
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Hidden (Click * to show)", Duration = 2})
    end)

    close.MouseButton1Click:Connect(function()
        mainGui:Destroy()
        if circleBtn then circleBtn:Destroy() end
    end)

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 35)
    tabBar.BackgroundColor3 = Color3.new(0.02, 0.1, 0.02)
    tabBar.BackgroundTransparency = 0.2
    tabBar.BorderSizePixel = 2
    tabBar.BorderColor3 = Color3.new(0, 1, 0)
    tabBar.Parent = frame

    local tabs = {"executor", "saved", "search", "settings"}
    local tabNames = {"⚡ EXEC", "💾 SAVED", "🔍 SEARCH", "⚙ SETTINGS"}
    local tabButtons = {}
    local tabContainers = {}

    for i, tab in pairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.25, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
        btn.Text = tabNames[i]
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = (i == 1) and Color3.new(0.1, 0.3, 0.1) or Color3.new(0.02, 0.05, 0.02)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = tabBar

        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, -10, 1, -70)
        container.Position = UDim2.new(0, 5, 0, 70)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 5
        container.Visible = (i == 1)
        container.Parent = frame

        tabButtons[tab] = btn
        tabContainers[tab] = container

        btn.MouseButton1Click:Connect(function()
            for _, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.new(0.02, 0.05, 0.02)
            end
            btn.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
            for _, c in pairs(tabContainers) do
                c.Visible = false
            end
            container.Visible = true
        end)
    end

    execBox = Instance.new("TextBox")
    execBox.Size = UDim2.new(1, 0, 0, 140)
    execBox.Position = UDim2.new(0, 0, 0, 0)
    execBox.Text = ""
    execBox.TextColor3 = Color3.new(1, 1, 1)
    execBox.BackgroundColor3 = Color3.new(0.02, 0.05, 0.02)
    execBox.BorderSizePixel = 2
    execBox.BorderColor3 = Color3.new(0, 1, 0)
    execBox.PlaceholderText = "-- Enter Lua code here --"
    execBox.PlaceholderColor3 = Color3.new(0.3, 0.6, 0.3)
    execBox.ClearTextOnFocus = false
    execBox.Font = Enum.Font.Code
    execBox.TextSize = 14
    execBox.TextXAlignment = Enum.TextXAlignment.Left
    execBox.TextYAlignment = Enum.TextYAlignment.Top
    execBox.Parent = tabContainers["executor"]

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0.6, 0, 0, 30)
    execBtn.Position = UDim2.new(0.2, 0, 0.8, 0)
    execBtn.Text = "▶️ EXECUTE"
    execBtn.TextColor3 = Color3.new(1, 1, 1)
    execBtn.BackgroundColor3 = Color3.new(0.1, 0.4, 0.1)
    execBtn.BorderSizePixel = 2
    execBtn.BorderColor3 = Color3.new(0, 1, 0)
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 14
    execBtn.Parent = tabContainers["executor"]
    execBtn.MouseButton1Click:Connect(function()
        executeLua(execBox.Text)
    end)

    local saveNameBox = Instance.new("TextBox")
    saveNameBox.Size = UDim2.new(0.6, 0, 0, 25)
    saveNameBox.Position = UDim2.new(0, 0, 0, 0)
    saveNameBox.Text = ""
    saveNameBox.TextColor3 = Color3.new(1, 1, 1)
    saveNameBox.BackgroundColor3 = Color3.new(0.02, 0.05, 0.02)
    saveNameBox.BorderSizePixel = 2
    saveNameBox.BorderColor3 = Color3.new(0, 1, 0)
    saveNameBox.PlaceholderText = "Script name..."
    saveNameBox.Font = Enum.Font.Gotham
    saveNameBox.TextSize = 12
    saveNameBox.Parent = tabContainers["saved"]

    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0.35, 0, 0, 25)
    saveBtn.Position = UDim2.new(0.65, 0, 0, 0)
    saveBtn.Text = "💾 SAVE"
    saveBtn.TextColor3 = Color3.new(1, 1, 1)
    saveBtn.BackgroundColor3 = Color3.new(0.1, 0.4, 0.1)
    saveBtn.BorderSizePixel = 2
    saveBtn.BorderColor3 = Color3.new(0, 1, 0)
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.TextSize = 12
    saveBtn.Parent = tabContainers["saved"]
    saveBtn.MouseButton1Click:Connect(function()
        saveScriptData(saveNameBox.Text, execBox.Text)
        saveNameBox.Text = ""
    end)

    local savedList = Instance.new("ScrollingFrame")
    savedList.Size = UDim2.new(1, 0, 0, 160)
    savedList.Position = UDim2.new(0, 0, 0, 30)
    savedList.BackgroundTransparency = 1
    savedList.ScrollBarThickness = 5
    savedList.Parent = tabContainers["saved"]

    function updateSavedList()
        for _, child in pairs(savedList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        local layout = Instance.new("UIListLayout")
        layout.Parent = savedList
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 4)

        for name, code in pairs(savedScripts) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.Text = name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = Color3.new(0.1, 0.2, 0.1)
            btn.BackgroundTransparency = 0.2
            btn.BorderSizePixel = 2
            btn.BorderColor3 = Color3.new(0, 1, 0)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Parent = savedList
            btn.MouseButton1Click:Connect(function()
                execBox.Text = code
                sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Loaded: " .. name, Duration = 2})
            end)

            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 25, 0, 18)
            delBtn.Position = UDim2.new(1, -30, 0.5, -9)
            delBtn.Text = "X"
            delBtn.TextColor3 = Color3.new(1, 0, 0)
            delBtn.BackgroundColor3 = Color3.new(0.3, 0, 0)
            delBtn.BackgroundTransparency = 0.2
            delBtn.BorderSizePixel = 2
            delBtn.BorderColor3 = Color3.new(0, 1, 0)
            delBtn.Font = Enum.Font.GothamBold
            delBtn.TextSize = 10
            delBtn.Parent = btn
            delBtn.MouseButton1Click:Connect(function()
                savedScripts[name] = nil
                updateSavedList()
                sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Deleted: " .. name, Duration = 2})
            end)
        end

        savedList.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            savedList.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
    end

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(0.6, 0, 0, 25)
    searchBox.Position = UDim2.new(0, 0, 0, 0)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.new(1, 1, 1)
    searchBox.BackgroundColor3 = Color3.new(0.02, 0.05, 0.02)
    searchBox.BorderSizePixel = 2
    searchBox.BorderColor3 = Color3.new(0, 1, 0)
    searchBox.PlaceholderText = "Search scripts..."
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.Parent = tabContainers["search"]

    local searchBtn = Instance.new("TextButton")
    searchBtn.Size = UDim2.new(0.35, 0, 0, 25)
    searchBtn.Position = UDim2.new(0.65, 0, 0, 0)
    searchBtn.Text = "🔍 SEARCH"
    searchBtn.TextColor3 = Color3.new(1, 1, 1)
    searchBtn.BackgroundColor3 = Color3.new(0.1, 0.4, 0.1)
    searchBtn.BorderSizePixel = 2
    searchBtn.BorderColor3 = Color3.new(0, 1, 0)
    searchBtn.Font = Enum.Font.GothamBold
    searchBtn.TextSize = 12
    searchBtn.Parent = tabContainers["search"]
    searchBtn.MouseButton1Click:Connect(function()
        if searchBox.Text ~= "" then
            searchScriptblox(searchBox.Text)
        end
    end)

    local searchResults = Instance.new("ScrollingFrame")
    searchResults.Size = UDim2.new(1, 0, 0, 160)
    searchResults.Position = UDim2.new(0, 0, 0, 30)
    searchResults.BackgroundTransparency = 1
    searchResults.ScrollBarThickness = 5
    searchResults.Parent = tabContainers["search"]

    function updateSearchResults()
        for _, child in pairs(searchResults:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        local layout = Instance.new("UIListLayout")
        layout.Parent = searchResults
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 4)

        for i, script in pairs(currentSearchResults) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.Text = script.title .. " (by " .. script.author .. ")"
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = Color3.new(0.1, 0.2, 0.1)
            btn.BackgroundTransparency = 0.2
            btn.BorderSizePixel = 2
            btn.BorderColor3 = Color3.new(0, 1, 0)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            btn.Parent = searchResults
            btn.MouseButton1Click:Connect(function()
                local code = loadScriptFromScriptBlox(script.id)
                if code then
                    execBox.Text = code
                    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Loaded: " .. script.title, Duration = 2})
                else
                    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Failed to load script", Duration = 3})
                end
            end)

            local saveBtn = Instance.new("TextButton")
            saveBtn.Size = UDim2.new(0, 25, 0, 18)
            saveBtn.Position = UDim2.new(1, -30, 0.5, -9)
            saveBtn.Text = "S"
            saveBtn.TextColor3 = Color3.new(0, 1, 0)
            saveBtn.BackgroundColor3 = Color3.new(0, 0.3, 0)
            saveBtn.BackgroundTransparency = 0.2
            saveBtn.BorderSizePixel = 2
            saveBtn.BorderColor3 = Color3.new(0, 1, 0)
            saveBtn.Font = Enum.Font.GothamBold
            saveBtn.TextSize = 10
            saveBtn.Parent = btn
            saveBtn.MouseButton1Click:Connect(function()
                local code = loadScriptFromScriptBlox(script.id)
                if code then
                    saveScriptData(script.title, code)
                end
            end)
        end

        searchResults.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            searchResults.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
    end

    local settingsLabel = Instance.new("TextLabel")
    settingsLabel.Size = UDim2.new(1, 0, 0, 30)
    settingsLabel.Text = "⚙ SETTINGS"
    settingsLabel.TextColor3 = Color3.new(0, 1, 0)
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Font = Enum.Font.GothamBold
    settingsLabel.TextSize = 16
    settingsLabel.Parent = tabContainers["settings"]

    local credLabel = Instance.new("TextLabel")
    credLabel.Size = UDim2.new(1, 0, 0, 20)
    credLabel.Position = UDim2.new(0, 0, 0, 40)
    credLabel.Text = "TUBERS93 EXECUTOR v13.0"
    credLabel.TextColor3 = Color3.new(0, 1, 0)
    credLabel.BackgroundTransparency = 1
    credLabel.Font = Enum.Font.Gotham
    credLabel.TextSize = 12
    credLabel.Parent = tabContainers["settings"]

    updateSavedList()
end

local function createKeyUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystem"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 160)
    frame.Position = UDim2.new(0.5, -140, 0.5, -80)
    frame.BackgroundColor3 = Color3.new(0.05, 0.1, 0.05)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.new(0, 1, 0)
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 0)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "✦ ENTER KEY ✦"
    title.TextColor3 = Color3.new(0, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.8, 0, 0, 30)
    box.Position = UDim2.new(0.1, 0, 0.3, 0)
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BackgroundColor3 = Color3.new(0.02, 0.05, 0.02)
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.new(0, 1, 0)
    box.PlaceholderText = "Enter key..."
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = frame

    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(0.5, 0, 0, 30)
    checkBtn.Position = UDim2.new(0.25, 0, 0.6, 0)
    checkBtn.Text = "✓ CHECK"
    checkBtn.TextColor3 = Color3.new(1, 1, 1)
    checkBtn.BackgroundColor3 = Color3.new(0.1, 0.4, 0.1)
    checkBtn.BorderSizePixel = 2
    checkBtn.BorderColor3 = Color3.new(0, 1, 0)
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.TextSize = 14
    checkBtn.Parent = frame

    checkBtn.MouseButton1Click:Connect(function()
        if box.Text == correctKey then
            gui:Destroy()
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Key Accepted!", Duration = 2})
            createCircleButton()
            createMainUI()
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "TUBERS93 EXECUTOR LOADED", Duration = 3})
        else
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Wrong Key!", Duration = 3})
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

sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Enter the key to continue", Duration = 3})
createKeyUI()
