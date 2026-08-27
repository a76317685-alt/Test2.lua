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

local guiVisible = true
local flying = false
local bv, bg

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

local function godMode()
    hum.Health = math.huge
    hum.MaxHealth = math.huge
    hum:GetPropertyChangedSignal("Health"):Connect(function()
        hum.Health = math.huge
    end)
    player.CharacterAdded:Connect(function(newChar)
        wait(0.5)
        newChar:WaitForChild("Humanoid").Health = math.huge
        newChar:WaitForChild("Humanoid").MaxHealth = math.huge
    end)
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "God Mode ON", Duration = 2})
end

local function fly()
    if flying then
        flying = false
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Fly OFF", Duration = 2})
        return
    end
    flying = true
    bg = Instance.new("BodyGyro")
    bv = Instance.new("BodyVelocity")
    bg.Parent = hrp
    bv.Parent = hrp
    bg.MaxTorque = Vector3.new(1, 1, 1) * 1e9
    bg.P = 1e9
    bv.MaxForce = Vector3.new(1, 1, 1) * 1e9
    bv.Velocity = Vector3.new(0, 0, 0)
    uis.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Space then
            bv.Velocity = Vector3.new(0, 50, 0)
        end
    end)
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Fly ON (Space up)", Duration = 2})
end

local function setSpeed(value)
    hum.WalkSpeed = value
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Speed set to " .. value, Duration = 2})
end

local function setJump(value)
    hum.JumpPower = value
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Jump set to " .. value, Duration = 2})
end

local function executeLua(code)
    if code and code ~= "" then
        local func, err = loadstring(code)
        if func then
            local success, result = pcall(func)
            if not success then
                sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Error: " .. tostring(result), Duration = 5})
            else
                sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Code executed successfully", Duration = 3})
            end
        else
            sg:SetCore("SendNotification", {Title = "[PRO]", Text = "Error: " .. tostring(err), Duration = 5})
        end
    end
end

local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "UltraHub"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 500)
    frame.Position = UDim2.new(0.5, -200, 0.5, -250)
    frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 50)
    top.BackgroundColor3 = Color3.new(0.2, 0.1, 0.4)
    top.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Text = "[PRO] ULTRA HUB"
    title.TextColor3 = Color3.new(0.5, 0.2, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 35, 0, 30)
    close.Position = UDim2.new(1, -40, 0, 10)
    close.Text = "X"
    close.TextColor3 = Color3.new(1, 0, 0)
    close.BackgroundColor3 = Color3.new(0.5, 0, 0)
    close.Parent = top
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -60)
    scroll.Position = UDim2.new(0, 5, 0, 55)
    scroll.BackgroundTransparency = 1
    scroll.Parent = frame

    local function addButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.2
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = scroll
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    addButton("🛡️ God Mode", Color3.new(0, 0.6, 0.2), godMode)
    addButton("✈️ Fly", Color3.new(0, 0.6, 0.8), fly)
    addButton("⚡ Speed 50", Color3.new(0.8, 0.8, 0), function() setSpeed(50) end)
    addButton("⚡ Speed 100", Color3.new(0.8, 0.8, 0), function() setSpeed(100) end)
    addButton("⚡ Speed 250", Color3.new(0.8, 0.8, 0), function() setSpeed(250) end)
    addButton("🦘 Jump 80", Color3.new(0, 0.8, 0.4), function() setJump(80) end)
    addButton("🦘 Jump 150", Color3.new(0, 0.8, 0.4), function() setJump(150) end)
    addButton("🦘 Jump 300", Color3.new(0, 0.8, 0.4), function() setJump(300) end)

    local execFrame = Instance.new("Frame")
    execFrame.Size = UDim2.new(1, 0, 0, 100)
    execFrame.Position = UDim2.new(0, 0, 1, -100)
    execFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
    execFrame.BackgroundTransparency = 0.2
    execFrame.Parent = scroll

    local execBox = Instance.new("TextBox")
    execBox.Size = UDim2.new(1, -10, 0, 40)
    execBox.Position = UDim2.new(0, 5, 0, 5)
    execBox.Text = ""
    execBox.TextColor3 = Color3.new(1, 1, 1)
    execBox.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    execBox.PlaceholderText = "Enter Lua code here..."
    execBox.ClearTextOnFocus = false
    execBox.Font = Enum.Font.Code
    execBox.TextSize = 14
    execBox.Parent = execFrame

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(1, -10, 0, 35)
    execBtn.Position = UDim2.new(0, 5, 0, 50)
    execBtn.Text = "▶️ Execute"
    execBtn.TextColor3 = Color3.new(1, 1, 1)
    execBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 16
    execBtn.Parent = execFrame
    execBtn.MouseButton1Click:Connect(function()
        executeLua(execBox.Text)
    end)
end

pcall(function()
    antiBan()
    createUI()
    sg:SetCore("SendNotification", {Title = "[PRO]", Text = "ULTRA HUB LOADED", Duration = 3})
end)

uis.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        sg:SetCore("SendNotification", {Title = "[PRO]", Text = "ULTRA HUB: F1 - toggle GUI (not implemented)", Duration = 3})
    end
end)
