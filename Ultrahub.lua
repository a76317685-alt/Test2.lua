local player = game.Players.LocalPlayer
local sg = game:GetService("StarterGui")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall

local correctKey = "50187"
local keyEntered = false

local godModeActive = false
local noFallActive = false
local currentSpeed = 16
local currentJump = 50
local flyActive = false
local bv, bg
local aimbotActive = false
local espActive = false
local noclipActive = false
local infiniteJumpActive = false
local antiKickActive = false
local clickTPActive = false
local autoClickActive = false
local rainbowSpeedActive = false
local noclipBody = nil

local dragging = false
local dragStart = nil
local startPos = nil

local function antiBan()
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "Kick" or method == "Ban" or method == "Remove" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

local function toggleGodMode()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
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

local function toggleFly()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flyActive = not flyActive
    if flyActive then
        bg = Instance.new("BodyGyro")
        bv = Instance.new("BodyVelocity")
        bg.Parent = hrp
        bv.Parent = hrp
        bg.MaxTorque = Vector3.new(1, 1, 1) * 1e9
        bg.P = 1e9
        bv.MaxForce = Vector3.new(1, 1, 1) * 1e9
        bv.Velocity = Vector3.new(0, 0, 0)
        uis.InputBegan:Connect(function(input)
            if flyActive and input.KeyCode == Enum.KeyCode.Space then
                bv.Velocity = Vector3.new(0, 50, 0)
            end
        end)
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Fly ON (Space up)", Duration = 2})
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Fly OFF", Duration = 2})
    end
end

local function setSpeed(value)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if not hum then return end
    currentSpeed = value
    hum.WalkSpeed = value
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Speed set to " .. value, Duration = 2})
end

local function setJump(value)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if not hum then return end
    currentJump = value
    hum.JumpPower = value
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Jump set to " .. value, Duration = 2})
end

local function toggleNoFall()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
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

local function loadVisualEffects()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Loading Visual Effects...", Duration = 3})
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/a76317685-alt/Test2.lua/refs/heads/main/Visualhub.lua", true))()
    end)
    if success then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Visual Effects Loaded!", Duration = 3})
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Failed to load Visual Effects: " .. tostring(err), Duration = 5})
    end
end

local function toggleAimbot()
    aimbotActive = not aimbotActive
    if aimbotActive then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Aimbot ON", Duration = 2})
        spawn(function()
            while aimbotActive do
                local target = nil
                local dist = math.huge
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                        local pos = v.Character.Head.Position
                        local distance = (pos - cam.CFrame.Position).magnitude
                        if distance < dist then
                            dist = distance
                            target = v
                        end
                    end
                end
                if target and target.Character then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
                end
                wait(0.05)
            end
        end)
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Aimbot OFF", Duration = 2})
    end
end

local function toggleESP()
    espActive = not espActive
    if espActive then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "ESP ON", Duration = 2})
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character then
                local hl = Instance.new("Highlight")
                hl.Parent = v.Character
                hl.FillColor = Color3.new(1, 0, 0)
                hl.OutlineColor = Color3.new(0, 0, 0)
                hl.FillTransparency = 0.3
                hl.Adornee = v.Character:FindFirstChild("Head") or v.Character
            end
        end
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character then
                for _, obj in pairs(v.Character:GetChildren()) do
                    if obj:IsA("Highlight") then
                        obj:Destroy()
                    end
                end
            end
        end
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "ESP OFF", Duration = 2})
    end
end

local function toggleNoClip()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    noclipActive = not noclipActive
    if noclipActive then
        if noclipBody then noclipBody:Destroy() end
        noclipBody = Instance.new("BodyVelocity")
        noclipBody.MaxForce = Vector3.new(1, 1, 1) * 1e9
        noclipBody.Velocity = Vector3.new(0, 0, 0)
        noclipBody.Parent = hrp
        hrp.CanCollide = false
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "NoClip ON", Duration = 2})
    else
        if noclipBody then noclipBody:Destroy() end
        hrp.CanCollide = true
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "NoClip OFF", Duration = 2})
    end
end

local function toggleInfiniteJump()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    infiniteJumpActive = not infiniteJumpActive
    if infiniteJumpActive then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Infinite Jump ON", Duration = 2})
        spawn(function()
            while infiniteJumpActive do
                if uis:IsKeyDown(Enum.KeyCode.Space) and hrp then
                    hrp.Velocity = Vector3.new(0, 35, 0)
                end
                wait(0.05)
            end
        end)
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Infinite Jump OFF", Duration = 2})
    end
end

local function toggleAntiKick()
    antiKickActive = not antiKickActive
    if antiKickActive then
        local oldRemove = player.Remove
        player.Remove = function() return nil end
        local ts = game:GetService("TeleportService")
        local oldTeleport = ts.Teleport
        ts.Teleport = function() return nil end
        sg:SetCore("SendNotification", function() return nil end)
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Anti-Kick ON", Duration = 2})
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Anti-Kick OFF", Duration = 2})
    end
end

local function toggleClickTP()
    clickTPActive = not clickTPActive
    if clickTPActive then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Click TP ON (click on ground)", Duration = 2})
        uis.InputBegan:Connect(function(input)
            if clickTPActive and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local target = player:GetMouse().Hit
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if target and hrp then
                    hrp.CFrame = CFrame.new(target.p) + Vector3.new(0, 3, 0)
                end
            end
        end)
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Click TP OFF", Duration = 2})
    end
end

local function toggleAutoClick()
    local char = player.Character
    if not char then return end
    autoClickActive = not autoClickActive
    if autoClickActive then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "AutoClick ON", Duration = 2})
        spawn(function()
            while autoClickActive do
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("Hitbox") then
                        local target = nil
                        for _, p in pairs(game.Players:GetPlayers()) do
                            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                                target = p
                                break
                            end
                        end
                        if target and target.Character then
                            v:FireServer(target.Character.HumanoidRootPart)
                        end
                    end
                end
                wait(0.1)
            end
        end)
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "AutoClick OFF", Duration = 2})
    end
end

local function toggleRainbowSpeed()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if not hum then return end
    rainbowSpeedActive = not rainbowSpeedActive
    if rainbowSpeedActive then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Rainbow Speed ON", Duration = 2})
        spawn(function()
            while rainbowSpeedActive do
                for _, v in pairs({1, 0.5, 0, 0.5, 1, 0}) do
                    hum.WalkSpeed = 16 + v * 50
                    wait(0.1)
                end
            end
        end)
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Rainbow Speed OFF", Duration = 2})
    end
end

local function serverHop()
    local servers = {}
    local success, data = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
    end)
    if not success then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Failed to get servers", Duration = 3})
        return
    end
    local decoded = game:GetService("HttpService"):JSONDecode(data)
    if not decoded or not decoded.data then return end
    for _, server in pairs(decoded.data) do
        if server.playing < 12 and server.id ~= game.JobId then
            table.insert(servers, server)
        end
    end
    if #servers > 0 then
        local server = servers[math.random(1, #servers)]
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, player)
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Server Hop!", Duration = 2})
    else
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "No servers found", Duration = 2})
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

local function createMainUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "UltraHub"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 560)
    frame.Position = UDim2.new(0.5, -210, 0.5, -280)
    frame.BackgroundColor3 = Color3.new(0.08, 0.05, 0.15)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
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

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "✦ ULTRA HUB v8.1 ✦"
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
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.Parent = scroll

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    addButton("🛡️ GOD MODE", Color3.new(0, 0.6, 0.2), toggleGodMode)
    addButton("✈️ FLY", Color3.new(0, 0.5, 0.8), toggleFly)
    addButton("🛩️ FLY (LOAD)", Color3.new(0, 0.6, 0.8), loadFlyScript)
    addButton("🌀 NO FALL", Color3.new(0.2, 0.6, 0.6), toggleNoFall)
    addButton("🚫 NOCLIP", Color3.new(0.5, 0.5, 0.5), toggleNoClip)
    addButton("♾️ INFINITE JUMP", Color3.new(0.4, 0.4, 0.8), toggleInfiniteJump)
    addButton("⚡ SPEED 50", Color3.new(0.8, 0.7, 0), function() setSpeed(50) end)
    addButton("⚡ SPEED 100", Color3.new(0.8, 0.7, 0), function() setSpeed(100) end)
    addButton("⚡ SPEED 250", Color3.new(0.8, 0.7, 0), function() setSpeed(250) end)
    addButton("🦘 JUMP 80", Color3.new(0, 0.7, 0.4), function() setJump(80) end)
    addButton("🦘 JUMP 150", Color3.new(0, 0.7, 0.4), function() setJump(150) end)
    addButton("🦘 JUMP 300", Color3.new(0, 0.7, 0.4), function() setJump(300) end)
    addButton("💀 KILL ALL", Color3.new(0.8, 0, 0), killAll)
    addButton("🔄 RESET", Color3.new(0.5, 0.5, 0.5), resetCharacter)
    addButton("🌀 INFINITY YIELD", Color3.new(0.8, 0.3, 0.8), loadInfinityYield)
    addButton("🌀 VISUAL EFFECTS", Color3.new(0.5, 0.2, 0.8), loadVisualEffects)
    addButton("🎯 AIMBOT", Color3.new(0, 0.4, 0.8), toggleAimbot)
    addButton("👁️ ESP", Color3.new(0.6, 0, 0.8), toggleESP)
    addButton("🚀 SERVER HOP", Color3.new(0.2, 0.8, 0.8), serverHop)
    addButton("🛡️ ANTI-KICK", Color3.new(0.6, 0, 0.8), toggleAntiKick)
    addButton("📌 CLICK TP", Color3.new(0.2, 0.8, 0.4), toggleClickTP)
    addButton("🖱️ AUTOCLICK", Color3.new(0.8, 0.2, 0.6), toggleAutoClick)
    addButton("🌀 RAINBOW SPEED", Color3.new(0.8, 0.2, 0.8), toggleRainbowSpeed)

    local execBox = Instance.new("TextBox")
    execBox.Size = UDim2.new(1, 0, 0, 80)
    execBox.Position = UDim2.new(0, 0, 1, -95)
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
    execBox.Parent = scroll

    local execBoxCorner = Instance.new("UICorner")
    execBoxCorner.CornerRadius = UDim.new(0, 8)
    execBoxCorner.Parent = execBox

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(1, 0, 0, 35)
    execBtn.Position = UDim2.new(0, 0, 1, -55)
    execBtn.Text = "▶️ EXECUTE"
    execBtn.TextColor3 = Color3.new(1, 1, 1)
    execBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
    execBtn.BorderSizePixel = 0
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 16
    execBtn.Parent = scroll

    local execBtnCorner = Instance.new("UICorner")
    execBtnCorner.CornerRadius = UDim.new(0, 8)
    execBtnCorner.Parent = execBtn

    execBtn.MouseButton1Click:Connect(function()
        executeLua(execBox.Text)
    end)

    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 110)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 110)
    end)

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    local function onInputChanged(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end

    top.InputBegan:Connect(onInputBegan)
    top.InputChanged:Connect(onInputChanged)
end

local function createKeyUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystem"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.new(0.1, 0.05, 0.2)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "✦ ENTER KEY ✦"
    title.TextColor3 = Color3.new(0.6, 0.2, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.8, 0, 0, 40)
    box.Position = UDim2.new(0.1, 0, 0.3, 0)
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.BackgroundColor3 = Color3.new(0.2, 0.1, 0.3)
    box.BorderSizePixel = 0
    box.PlaceholderText = "Enter key here..."
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    box.Parent = frame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 8)
    boxCorner.Parent = box

    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(0.6, 0, 0, 40)
    checkBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
    checkBtn.Text = "✓ CHECK"
    checkBtn.TextColor3 = Color3.new(1, 1, 1)
    checkBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
    checkBtn.BorderSizePixel = 0
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.TextSize = 18
    checkBtn.Parent = frame

    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 8)
    checkCorner.Parent = checkBtn

    checkBtn.MouseButton1Click:Connect(function()
        if box.Text == correctKey then
            keyEntered = true
            gui:Destroy()
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Key Accepted! Loading...", Duration = 2})
            wait(0.5)
            antiBan()
            createMainUI()
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "ULTRA HUB v8.1 LOADED", Duration = 3})
        else
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Wrong Key! Try again.", Duration = 3})
            box.Text = ""
        end
    end)

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -35, 0, 5)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.BackgroundColor3 = Color3.new(0.5, 0, 0)
    close.BackgroundTransparency = 0.3
    close.BorderSizePixel = 0
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.Parent = frame
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

pcall(function()
    createKeyUI()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Enter the key to continue", Duration = 3})
end)
