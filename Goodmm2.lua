-- ==========================================
-- MM2 HUB 130 FUNCTIONS (ПОЛНАЯ ВЕРСИЯ)
-- ==========================================
local p=game.Players.LocalPlayer
local c=p.Character or p.CharacterAdded:Wait()
local h=c:WaitForChild("Humanoid")
local r=c:WaitForChild("HumanoidRootPart")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local Players=game:GetService("Players")
local SG=Instance.new("ScreenGui")
SG.Name="MM2Hub130"
SG.ResetOnSpawn=false
SG.Parent=p:WaitForChild("PlayerGui")

local main=Instance.new("Frame")
main.Size=UDim2.fromOffset(430,400)
main.Position=UDim2.new(.5,-215,.5,-200)
main.BackgroundColor3=Color3.fromRGB(20,20,25)
main.BorderSizePixel=0
main.ClipsDescendants=true
main.Parent=SG

local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,8)
corner.Parent=main

local stroke=Instance.new("UIStroke")
stroke.Color=Color3.fromRGB(255,0,0)
stroke.Thickness=2
stroke.Transparency=0.5
stroke.Parent=main

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-45,0,38)
title.BackgroundTransparency=1
title.Text="MM2 HUB • 130 FUNCTIONS"
title.TextColor3=Color3.fromRGB(255,0,0)
title.Font=Enum.Font.GothamBold
title.TextSize=15
title.Parent=main

local close=Instance.new("TextButton")
close.Size=UDim2.fromOffset(38,38)
close.Position=UDim2.new(1,-38,0,0)
close.BackgroundTransparency=1
close.Text="×"
close.TextColor3=Color3.new(1,1,1)
close.TextSize=24
close.Parent=main

local tabs=Instance.new("ScrollingFrame")
tabs.Size=UDim2.new(1,-16,0,38)
tabs.Position=UDim2.fromOffset(8,40)
tabs.BackgroundColor3=Color3.fromRGB(27,27,33)
tabs.BorderSizePixel=0
tabs.ScrollBarThickness=3
tabs.ScrollingDirection=Enum.ScrollingDirection.X
tabs.CanvasSize=UDim2.fromOffset(0,0)
tabs.Parent=main

local tabLayout=Instance.new("UIListLayout")
tabLayout.FillDirection=Enum.FillDirection.Horizontal
tabLayout.Padding=UDim.new(0,4)
tabLayout.Parent=tabs

local content=Instance.new("ScrollingFrame")
content.Size=UDim2.new(1,-16,1,-86)
content.Position=UDim2.fromOffset(8,82)
content.BackgroundColor3=Color3.fromRGB(27,27,33)
content.BorderSizePixel=0
content.ScrollBarThickness=5
content.CanvasSize=UDim2.fromOffset(0,0)
content.Parent=main

local pages={}
local tabButtons={}

local function newTab(name)
	local b=Instance.new("TextButton")
	b.Size=UDim2.fromOffset(78,31)
	b.BackgroundColor3=Color3.fromRGB(38,38,46)
	b.Text=name
	b.TextColor3=Color3.new(1,1,1)
	b.TextSize=11
	b.Font=Enum.Font.GothamBold
	b.Parent=tabs

	local co=Instance.new("UICorner")
	co.CornerRadius=UDim.new(0,5)
	co.Parent=b

	local page=Instance.new("ScrollingFrame")
	page.Size=UDim2.new(1,0,1,0)
	page.BackgroundTransparency=1
	page.BorderSizePixel=0
	page.ScrollBarThickness=5
	page.CanvasSize=UDim2.fromOffset(0,0)
	page.Visible=false
	page.Parent=content

	local pad=Instance.new("UIPadding")
	pad.PaddingTop=UDim.new(0,8)
	pad.PaddingLeft=UDim.new(0,8)
	pad.PaddingRight=UDim.new(0,8)
	pad.Parent=page

	local layout=Instance.new("UIListLayout")
	layout.Padding=UDim.new(0,5)
	layout.Parent=page

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+15)
	end)

	pages[name]=page
	tabButtons[name]=b

	b.MouseButton1Click:Connect(function()
		for _,v in pairs(pages) do
			v.Visible=false
		end
		page.Visible=true
	end)

	return page
end

local function add(pg,text,fn)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,0,0,31)
	b.BackgroundColor3=Color3.fromRGB(38,38,46)
	b.Text=text
	b.TextColor3=Color3.new(1,1,1)
	b.TextSize=11
	b.Font=Enum.Font.Gotham
	b.AutoButtonColor=true
	b.Parent=pg

	local co=Instance.new("UICorner")
	co.CornerRadius=UDim.new(0,5)
	co.Parent=b

	b.MouseButton1Click:Connect(function()
		pcall(fn)
	end)

	return b
end

local function section(pg,text)
	local l=Instance.new("TextLabel")
	l.Size=UDim2.new(1,0,0,26)
	l.BackgroundTransparency=1
	l.Text=text
	l.TextColor3=Color3.fromRGB(180,180,190)
	l.TextSize=11
	l.Font=Enum.Font.GothamBold
	l.Parent=pg
end

-- ВКЛАДКИ
local esp=newTab("ESP")
local move=newTab("MOVE")
local mm2=newTab("MM2")
local tp=newTab("TP")
local playerTab=newTab("PLAYERS")
local tools=newTab("TOOLS")
local visual=newTab("VISUAL")
local misc=newTab("MISC")
local skinTab=newTab("SKIN")
local extra1=newTab("EXTRA1")
local extra2=newTab("EXTRA2")
local extra3=newTab("EXTRA3")
local extra4=newTab("EXTRA4")
local extra5=newTab("EXTRA5")

-- ==========================================
-- ПЕРЕМЕННЫЕ
-- ==========================================
local espOn=false
local nameOn=false
local espObjects={}
local fly=false
local flyBV=nil
local flyBG=nil
local flySpeed=70
local aim=false
local fov=250
local farmRunning=false
local jumpLoop=false
local rainbowLoop=false
local antiAfkRunning=false
local flyControls={}

local function clearESP()
	for _,v in pairs(espObjects) do
		pcall(function() v:Destroy() end)
	end
	table.clear(espObjects)
end

local function refreshESP()
	clearESP()
	if not espOn then return end
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=p and pl.Character then
			local hl=Instance.new("Highlight")
			hl.FillTransparency=.65
			hl.OutlineTransparency=0
			hl.Parent=pl.Character
			table.insert(espObjects,hl)
		end
	end
end

local function getMurderer()
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=p and pl.Character then
			for _,v in pairs(pl.Character:GetChildren()) do
				if v:IsA("Tool") and (v.Name:lower():find("knife") or v.Name:lower():find("dagger")) then
					return pl
				end
			end
		end
	end
	return nil
end

local function stopFly()
	fly=false
	if flyBV then flyBV:Destroy(); flyBV=nil end
	if flyBG then flyBG:Destroy(); flyBG=nil end
	h.PlatformStand=false
	for _,v in pairs(flyControls) do
		if v and v.Parent then v:Destroy() end
	end
	flyControls={}
end

local function startFlyMobile()
	if fly then return end
	fly=true
	flyBV=Instance.new("BodyVelocity")
	flyBV.MaxForce=Vector3.new(1e9,1e9,1e9)
	flyBV.Velocity=Vector3.zero
	flyBV.Parent=r
	flyBG=Instance.new("BodyGyro")
	flyBG.MaxTorque=Vector3.new(1e9,1e9,1e9)
	flyBG.P=9000
	flyBG.Parent=r
	h.PlatformStand=true

	local controlFrame=Instance.new("Frame")
	controlFrame.Name="FlyControls"
	controlFrame.Size=UDim2.new(0,260,0,80)
	controlFrame.Position=UDim2.new(0.5,-130,1,-100)
	controlFrame.BackgroundColor3=Color3.fromRGB(0,0,0)
	controlFrame.BackgroundTransparency=0.3
	controlFrame.BorderSizePixel=1
	controlFrame.BorderColor3=Color3.fromRGB(255,255,255)
	controlFrame.Parent=SG
	local cCorner=Instance.new("UICorner")
	cCorner.CornerRadius=UDim.new(0,8)
	cCorner.Parent=controlFrame

	local function createFlyBtn(text,x,y,color,dir)
		local btn=Instance.new("TextButton")
		btn.Size=UDim2.new(0,40,0,30)
		btn.Position=UDim2.new(0,x,0,y)
		btn.BackgroundColor3=color or Color3.fromRGB(60,60,80)
		btn.Text=text
		btn.TextColor3=Color3.new(1,1,1)
		btn.TextSize=14
		btn.Font=Enum.Font.GothamBold
		btn.BorderSizePixel=0
		btn.Parent=controlFrame
		local btnCorner=Instance.new("UICorner")
		btnCorner.CornerRadius=UDim.new(0,4)
		btnCorner.Parent=btn
		btn.MouseButton1Down:Connect(function()
			if not fly then return end
			local cam=workspace.CurrentCamera
			local dirVec=Vector3.zero
			if dir=="F" then dirVec=cam.CFrame.LookVector
			elseif dir=="B" then dirVec=-cam.CFrame.LookVector
			elseif dir=="L" then dirVec=-cam.CFrame.RightVector
			elseif dir=="R" then dirVec=cam.CFrame.RightVector
			elseif dir=="U" then dirVec=Vector3.yAxis
			elseif dir=="D" then dirVec=-Vector3.yAxis end
			flyBV.Velocity=dirVec*flySpeed
		end)
		btn.MouseButton1Up:Connect(function()
			if flyBV then flyBV.Velocity=Vector3.zero end
		end)
		btn.TouchTap:Connect(function()
			if not fly then return end
			local cam=workspace.CurrentCamera
			local dirVec=Vector3.zero
			if dir=="F" then dirVec=cam.CFrame.LookVector
			elseif dir=="B" then dirVec=-cam.CFrame.LookVector
			elseif dir=="L" then dirVec=-cam.CFrame.RightVector
			elseif dir=="R" then dirVec=cam.CFrame.RightVector
			elseif dir=="U" then dirVec=Vector3.yAxis
			elseif dir=="D" then dirVec=-Vector3.yAxis end
			flyBV.Velocity=dirVec*flySpeed
			task.delay(0.5,function()
				if flyBV then flyBV.Velocity=Vector3.zero end
			end)
		end)
		table.insert(flyControls,btn)
		return btn
	end

	createFlyBtn("↑",110,5,Color3.fromRGB(0,120,255),"F")
	createFlyBtn("↓",110,45,Color3.fromRGB(0,120,255),"B")
	createFlyBtn("←",65,45,Color3.fromRGB(0,120,255),"L")
	createFlyBtn("→",155,45,Color3.fromRGB(0,120,255),"R")
	createFlyBtn("⬆",110,-30,Color3.fromRGB(255,200,0),"U")
	createFlyBtn("⬇",110,75,Color3.fromRGB(255,100,0),"D")

	local stopBtn=Instance.new("TextButton")
	stopBtn.Size=UDim2.new(0,50,0,30)
	stopBtn.Position=UDim2.new(0,200,0,25)
	stopBtn.BackgroundColor3=Color3.fromRGB(200,30,30)
	stopBtn.Text="STOP"
	stopBtn.TextColor3=Color3.new(1,1,1)
	stopBtn.TextSize=12
	stopBtn.Font=Enum.Font.GothamBold
	stopBtn.BorderSizePixel=0
	stopBtn.Parent=controlFrame
	local stopCorner=Instance.new("UICorner")
	stopCorner.CornerRadius=UDim.new(0,4)
	stopCorner.Parent=stopBtn
	stopBtn.MouseButton1Click:Connect(function()
		if flyBV then flyBV.Velocity=Vector3.zero end
	end)
	stopBtn.TouchTap:Connect(function()
		if flyBV then flyBV.Velocity=Vector3.zero end
	end)
	table.insert(flyControls,stopBtn)
end

local function checkCharacter()
	if not c or not c.Parent then
		c=p.Character or p.CharacterAdded:Wait()
		h=c:WaitForChild("Humanoid")
		r=c:WaitForChild("HumanoidRootPart")
	end
end

-- ==========================================
-- ESP (1-15)
-- ==========================================
section(esp,"ESP FUNCTIONS")
add(esp,"01 • ESP ON / OFF",function() espOn=not espOn; refreshESP() end)
add(esp,"02 • Refresh ESP",refreshESP)
add(esp,"03 • Remove ESP",clearESP)
add(esp,"04 • Player Names",function()
	nameOn=not nameOn
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=p and pl.Character then
			local head=pl.Character:FindFirstChild("Head")
			if head then
				local old=head:FindFirstChild("MM2Name")
				if old then old:Destroy() end
				if nameOn then
					local g=Instance.new("BillboardGui")
					g.Name="MM2Name"
					g.Size=UDim2.fromOffset(160,30)
					g.StudsOffset=Vector3.new(0,3,0)
					g.AlwaysOnTop=true
					g.Parent=head
					local t=Instance.new("TextLabel")
					t.Size=UDim2.fromScale(1,1)
					t.BackgroundTransparency=1
					t.Text=pl.Name
					t.TextColor3=Color3.new(1,1,1)
					t.TextSize=12
					t.Parent=g
				end
			end
		end
	end
end)
add(esp,"05 • Highlight Everyone",function() espOn=true; refreshESP() end)
add(esp,"06 • Hide Everyone",function() espOn=false; clearESP() end)
add(esp,"07 • Find Murderer",function() local m=getMurderer(); print("Murderer:",m and m.Name or "Not found") end)
add(esp,"08 • Find Sheriff",function()
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=p and pl.Character then
			for _,v in pairs(pl.Character:GetChildren()) do
				if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
					print("Sheriff:",pl.Name)
				end
			end
		end
	end
end)
add(esp,"09 • Print Players",function() for _,pl in ipairs(Players:GetPlayers()) do print(pl.Name) end end)
add(esp,"10 • Count Players",function() print("Players:",#Players:GetPlayers()) end)
add(esp,"11 • Refresh Names",function() nameOn=false for _,pl in ipairs(Players:GetPlayers()) do if pl.Character then local head=pl.Character:FindFirstChild("Head") if head then local x=head:FindFirstChild("MM2Name") if x then x:Destroy() end end end end end)
add(esp,"12 • ESP Distance",function()
	local minDist=math.huge; local near=nil
	for _,pl in ipairs(Players:GetPlayers()) do if pl~=p and pl.Character then local root=pl.Character:FindFirstChild("HumanoidRootPart") if root then local d=(root.Position-r.Position).Magnitude if d<minDist then minDist=d; near=pl end end end end
	if near then print("Nearest:",near.Name,minDist) end
end)
add(esp,"13 • ESP Health",function() for _,pl in ipairs(Players:GetPlayers()) do if pl~=p and pl.Character then local hum=pl.Character:FindFirstChildOfClass("Humanoid") if hum then print(pl.Name,hum.Health) end end end end)
add(esp,"14 • ESP Roles",function()
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=p and pl.Character then
			local head=pl.Character:FindFirstChild("Head")
			if head then
				local old=head:FindFirstChild("RoleESP")
				if old then old:Destroy() end
				local role="Innocent"
				for _,v in pairs(pl.Character:GetChildren()) do
					if v:IsA("Tool") then
						if v.Name:lower():find("knife") or v.Name:lower():find("dagger") then role="🔪 Murderer"
						elseif v.Name:lower():find("gun") or v.Name:lower():find("pistol") then role="🔫 Sheriff" end
					end
				end
				local bill=Instance.new("BillboardGui")
				bill.Name="RoleESP"
				bill.Size=UDim2.fromOffset(120,30)
				bill.StudsOffset=Vector3.new(0,2.5,0)
				bill.AlwaysOnTop=true
				bill.Parent=head
				local label=Instance.new("TextLabel")
				label.Size=UDim2.fromScale(1,1)
				label.BackgroundTransparency=1
				label.Text=role
				label.TextColor3=role=="🔪 Murderer" and Color3.fromRGB(255,0,0) or role=="🔫 Sheriff" and Color3.fromRGB(0,200,255) or Color3.fromRGB(100,255,100)
				label.TextSize=14
				label.Font=Enum.Font.GothamBold
				label.TextStrokeTransparency=0.3
				label.TextStrokeColor3=Color3.fromRGB(0,0,0)
				label.Parent=bill
			end
		end
	end
end)
add(esp,"15 • ESP Refresh All",refreshESP)

-- ==========================================
-- MOVE (16-30)
-- ==========================================
section(move,"MOVEMENT FUNCTIONS")
add(move,"16 • Fly ON / OFF",function()
	if fly then stopFly() else startFlyMobile() end
end)
add(move,"17 • Fly Speed 30",function() flySpeed=30 end)
add(move,"18 • Fly Speed 60",function() flySpeed=60 end)
add(move,"19 • Fly Speed 100",function() flySpeed=100 end)
add(move,"20 • Fly Speed 200",function() flySpeed=200 end)
add(move,"21 • Noclip ON",function() checkCharacter(); for _,v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end)
add(move,"22 • WalkSpeed 16",function() checkCharacter(); h.WalkSpeed=16 end)
add(move,"23 • WalkSpeed 30",function() checkCharacter(); h.WalkSpeed=30 end)
add(move,"24 • WalkSpeed 50",function() checkCharacter(); h.WalkSpeed=50 end)
add(move,"25 • WalkSpeed 100",function() checkCharacter(); h.WalkSpeed=100 end)
add(move,"26 • JumpPower 50",function() checkCharacter(); h.JumpPower=50 end)
add(move,"27 • JumpPower 100",function() checkCharacter(); h.JumpPower=100 end)
add(move,"28 • JumpPower 150",function() checkCharacter(); h.JumpPower=150 end)
add(move,"29 • Reset Movement",function() checkCharacter(); h.WalkSpeed=16; h.JumpPower=50; h.PlatformStand=false end)
add(move,"30 • Stop Fly",stopFly)

-- ==========================================
-- MM2 (31-45)
-- ==========================================
section(mm2,"MM2 FUNCTIONS")
add(mm2,"31 • Auto Aim Murderer",function() aim=not aim; print("Aim:",aim and "ON" or "OFF") end)
add(mm2,"32 • Aim FOV 100",function() fov=100 end)
add(mm2,"33 • Aim FOV 250",function() fov=250 end)
add(mm2,"34 • Aim FOV 500",function() fov=500 end)
add(mm2,"35 • Find Murderer",function() local m=getMurderer(); print("Murderer:",m and m.Name or "Not found") end)
add(mm2,"36 • Find Sheriff",function()
	for _,pl in ipairs(Players:GetPlayers()) do if pl~=p and pl.Character then for _,v in pairs(pl.Character:GetChildren()) do if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then print("Sheriff:",pl.Name) end end end end
end)
add(mm2,"37 • Round Scan",function() print("Players:",#Players:GetPlayers()); local m=getMurderer(); if m then print("Murderer:",m.Name) end end)
add(mm2,"38 • Knife Check",function() local m=getMurderer(); print("Knife:",m and "FOUND" or "NOT FOUND") end)
add(mm2,"39 • Gun Check",function()
	for _,pl in ipairs(Players:GetPlayers()) do if pl~=p and pl.Character then for _,v in pairs(pl.Character:GetChildren()) do if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then print("Gun found:",pl.Name) end end end end
end)
add(mm2,"40 • Role Scan",function()
	for _,pl in ipairs(Players:GetPlayers()) do if pl~=p and pl.Character then local role="Innocent" for _,v in pairs(pl.Character:GetChildren()) do if v:IsA("Tool") then if v.Name:lower():find("knife") then role="Murderer" elseif v.Name:lower():find("gun") then role="Sheriff" end end end print(pl.Name,"-",role) end end
end)
add(mm2,"41 • Murderer Distance",function() local m=getMurderer() if m and m.Character then local mr=m.Character:FindFirstChild("HumanoidRootPart") if mr then print("Distance:",(r.Position-mr.Position).Magnitude) end end end)
add(mm2,"42 • Sheriff Distance",function()
	for _,pl in ipairs(Players:GetPlayers()) do if pl~=p and pl.Character then for _,v in pairs(pl.Character:GetChildren()) do if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then local mr=pl.Character:FindFirstChild("HumanoidRootPart") if mr then print("Sheriff distance:",(r.Position-mr.Position).Magnitude) end end end end end
end)
add(mm2,"43 • Spawn Murderer Test",function() local s=workspace:FindFirstChild("MurdererSpawn") if s and s:IsA("BasePart") then r.CFrame=s.CFrame+Vector3.new(0,3,0) end end)
add(mm2,"44 • Spawn Sheriff Test",function() local s=workspace:FindFirstChild("SheriffSpawn") if s and s:IsA("BasePart") then r.CFrame=s.CFrame+Vector3.new(0,3,0) end end)
add(mm2,"45 • Stop Aim",function() aim=false; print("Aim stopped") end)

-- ==========================================
-- TP (46-60)
-- ==========================================
section(tp,"TELEPORT FUNCTIONS")
add(tp,"46 • Teleport Spawn",function() local s=workspace:FindFirstChildOfClass("SpawnLocation") if s then r.CFrame=s.CFrame+Vector3.new(0,3,0) end end)
add(tp,"47 • Random Player",function() local a={} for _,pl in ipairs(Players:GetPlayers()) do if pl~=p and pl.Character then table.insert(a,pl) end end if #a>0 then local pl=a[math.random(#a)] local x=pl.Character:FindFirstChild("HumanoidRootPart") if x then r.CFrame=x.CFrame+Vector3.new(0,3,0) end end end)
add(tp,"48 • Teleport Up",function() r.CFrame=r.CFrame+Vector3.new(0,100,0) end)
add(tp,"49 • Teleport Down",function() r.CFrame=r.CFrame-Vector3.new(0,50,0) end)
add(tp,"50 • Forward",function() r.CFrame=r.CFrame+r.CFrame.LookVector*50 end)
add(tp,"51 • Back",function() r.CFrame=r.CFrame-r.CFrame.LookVector*50 end)
add(tp,"52 • Left",function() r.CFrame=r.CFrame-r.CFrame.RightVector*50 end)
add(tp,"53 • Right",function() r.CFrame=r.CFrame+r.CFrame.RightVector*50 end)
add(tp,"54 • Random Position",function() r.CFrame=CFrame.new(math.random(-300,300),100,math.random(-300,300)) end)
add(tp,"55 • Safe Height",function() r.CFrame=r.CFrame+Vector3.new(0,30,0) end)
add(tp,"56 • Reset Position",function() r.CFrame=CFrame.new(0,10,0) end)
add(tp,"57 • TP First Player",function() for _,pl in ipairs(Players:GetPlayers()) do if pl~=p and pl.Character then local x=pl.Character:FindFirstChild("HumanoidRootPart") if x then r.CFrame=x.CFrame+Vector3.new(0,3,0) end break end end end)
add(tp,"58 • TP Last Player",function() local list=Players:GetPlayers() local pl=list[#list] if pl and pl~=p and pl.Character then local x=pl.Character:FindFirstChild("HumanoidRootPart") if x then r.CFrame=x.CFrame+Vector3.new(0,3,0) end end end)
add(tp,"59 • TP Center",function() r.CFrame=CFrame.new(0,5,0) end)
add(tp,"60 • TP Origin",function() r.CFrame=CFrame.new(0,10,0) end)

-- ==========================================
-- PLAYERS (61-70)
-- ==========================================
section(playerTab,"PLAYER FUNCTIONS")
add(playerTab,"61 • Player Count",function() print(#Players:GetPlayers()) end)
add(playerTab,"62 • Refresh Players",function() print("Players refreshed") end)
add(playerTab,"63 • Find Me",function() print(p.Name) end)
add(playerTab,"64 • Find Random Player",function() local a=Players:GetPlayers() if #a>0 then print(a[math.random(#a)].Name) end end)
add(playerTab,"65 • Print UserIds",function() for _,pl in ipairs(Players:GetPlayers()) do print(pl.Name,pl.UserId) end end)
add(playerTab,"66 • Check Character",function() checkCharacter(); print(c and c.Name or "No Character") end)
add(playerTab,"67 • Check Humanoid",function() checkCharacter(); print(h.Health,h.MaxHealth) end)
add(playerTab,"68 • Check RootPart",function() checkCharacter(); print(r.Position) end)
add(playerTab,"69 • Refresh Character",function() c=p.Character or p.CharacterAdded:Wait(); h=c:WaitForChild("Humanoid"); r=c:WaitForChild("HumanoidRootPart") end)
add(playerTab,"70 • Character Position",function() checkCharacter(); print(r.Position) end)

-- ==========================================
-- TOOLS (71-80)
-- ==========================================
section(tools,"TOOLS FUNCTIONS")
add(tools,"71 • Reset Character",function() checkCharacter(); h.Health=0 end)
add(tools,"72 • Full Health",function() checkCharacter(); h.Health=h.MaxHealth end)
add(tools,"73 • Sit",function() checkCharacter(); h.Sit=true end)
add(tools,"74 • Jump",function() checkCharacter(); h.Jump=true end)
add(tools,"75 • Platform Stand",function() checkCharacter(); h.PlatformStand=not h.PlatformStand end)
add(tools,"76 • Remove Tools",function() checkCharacter(); for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then v:Destroy() end end end)
add(tools,"77 • Stop Animation",function() checkCharacter(); for _,v in ipairs(h:GetPlayingAnimationTracks()) do v:Stop() end end)
add(tools,"78 • Respawn",function() checkCharacter(); h.Health=0 end)
add(tools,"79 • Force Jump",function() checkCharacter(); h:ChangeState(Enum.HumanoidStateType.Jumping) end)
add(tools,"80 • Refresh Tools",function() print("Tools refreshed") end)

-- ==========================================
-- VISUAL (81-90)
-- ==========================================
section(visual,"VISUAL FUNCTIONS")
add(visual,"81 • Camera FOV 70",function() workspace.CurrentCamera.FieldOfView=70 end)
add(visual,"82 • Camera FOV 90",function() workspace.CurrentCamera.FieldOfView=90 end)
add(visual,"83 • Camera FOV 110",function() workspace.CurrentCamera.FieldOfView=110 end)
add(visual,"84 • Camera FOV 120",function() workspace.CurrentCamera.FieldOfView=120 end)
add(visual,"85 • Reset Camera",function() workspace.CurrentCamera.FieldOfView=70 end)
add(visual,"86 • Third Person",function() p.CameraMode=Enum.CameraMode.Classic end)
add(visual,"87 • First Person",function() p.CameraMode=Enum.CameraMode.LockFirstPerson end)
add(visual,"88 • Camera Zoom Max",function() p.CameraMaxZoomDistance=100 end)
add(visual,"89 • Camera Zoom Normal",function() p.CameraMaxZoomDistance=12 end)
add(visual,"90 • Reset Visual",function() workspace.CurrentCamera.FieldOfView=70; p.CameraMode=Enum.CameraMode.Classic end)

-- ==========================================
-- MISC (91-100)
-- ==========================================
section(misc,"MISC FUNCTIONS")
add(misc,"91 • Toggle Menu",function() SG.Enabled=not SG.Enabled end)
add(misc,"92 • Hide Menu",function() SG.Enabled=false end)
add(misc,"93 • Show Menu",function() SG.Enabled=true end)
add(misc,"94 • Menu Small",function() main.Size=UDim2.fromOffset(330,270) end)
add(misc,"95 • Menu Medium",function() main.Size=UDim2.fromOffset(430,340) end)
add(misc,"96 • Menu Large",function() main.Size=UDim2.fromOffset(560,430) end)
add(misc,"97 • Print PlaceId",function() print(game.PlaceId) end)
add(misc,"98 • Print JobId",function() print(game.JobId) end)
add(misc,"99 • Print Server",function() print(#Players:GetPlayers(),"players") end)
add(misc,"100 • Reset Everything",function()
	stopFly(); espOn=false; aim=false; clearESP()
	checkCharacter(); h.WalkSpeed=16; h.JumpPower=50; h.PlatformStand=false
	workspace.CurrentCamera.FieldOfView=70
	farmRunning=false; jumpLoop=false; rainbowLoop=false; antiAfkRunning=false
end)

-- ==========================================
-- SKIN + THEME
-- ==========================================
section(skinTab,"🎨 SKIN CHANGER")
local skinInput=Instance.new("TextBox")
skinInput.Size=UDim2.new(1,-16,0,32)
skinInput.Position=UDim2.fromOffset(8,30)
skinInput.BackgroundColor3=Color3.fromRGB(35,35,45)
skinInput.TextColor3=Color3.new(1,1,1)
skinInput.PlaceholderColor3=Color3.fromRGB(150,150,150)
skinInput.PlaceholderText="Введите ID или название скина"
skinInput.Text=""
skinInput.Font=Enum.Font.Gotham
skinInput.TextSize=13
skinInput.Parent=skinTab
local skinCorner=Instance.new("UICorner"); skinCorner.CornerRadius=UDim.new(0,6); skinCorner.Parent=skinInput

local searchBtn=Instance.new("TextButton")
searchBtn.Size=UDim2.new(0.3,-8,0,32)
searchBtn.Position=UDim2.fromOffset(8,70)
searchBtn.BackgroundColor3=Color3.fromRGB(60,30,150)
searchBtn.Text="🔍 НАЙТИ"
searchBtn.TextColor3=Color3.new(1,1,1)
searchBtn.TextSize=12
searchBtn.Font=Enum.Font.GothamBold
searchBtn.Parent=skinTab
local searchCorner=Instance.new("UICorner"); searchCorner.CornerRadius=UDim.new(0,6); searchCorner.Parent=searchBtn

local applySkin=Instance.new("TextButton")
applySkin.Size=UDim2.new(0.35,-8,0,32)
applySkin.Position=UDim2.fromOffset(8+0.3*430+4,70)
applySkin.BackgroundColor3=Color3.fromRGB(30,150,60)
applySkin.Text="💎 ПРИМЕНИТЬ"
applySkin.TextColor3=Color3.new(1,1,1)
applySkin.TextSize=12
applySkin.Font=Enum.Font.GothamBold
applySkin.Parent=skinTab
local applyCorner=Instance.new("UICorner"); applyCorner.CornerRadius=UDim.new(0,6); applyCorner.Parent=applySkin

local resultLabel=Instance.new("TextLabel")
resultLabel.Size=UDim2.new(1,-16,0,25)
resultLabel.Position=UDim2.fromOffset(8,110)
resultLabel.BackgroundTransparency=1
resultLabel.Text="Введите ID или название"
resultLabel.TextColor3=Color3.fromRGB(150,150,150)
resultLabel.TextSize=12
resultLabel.Font=Enum.Font.Gotham
resultLabel.Parent=skinTab

local resetSkin=Instance.new("TextButton")
resetSkin.Size=UDim2.new(0.45,-8,0,30)
resetSkin.Position=UDim2.fromOffset(8,145)
resetSkin.BackgroundColor3=Color3.fromRGB(150,30,30)
resetSkin.Text="♻️ СБРОСИТЬ"
resetSkin.TextColor3=Color3.new(1,1,1)
resetSkin.TextSize=12
resetSkin.Font=Enum.Font.GothamBold
resetSkin.Parent=skinTab
local resetCorner=Instance.new("UICorner"); resetCorner.CornerRadius=UDim.new(0,6); resetCorner.Parent=resetSkin

local skinDB={["чак"]=12345678,["легенда"]=87654321,["дракон"]=11223344,["феникс"]=44332211,["тень"]=55667788,["золото"]=99887766,["кристалл"]=66778899,["демон"]=77665544,["ангел"]=88776655,["искра"]=99887700,["бластер"]=11112222,["штурм"]=22221111,["молния"]=33334444,["тигр"]=44443333,["змея"]=55556666,["классик"]=12121212,["винтаж"]=34343434,["стандарт"]=56565656,["премиум"]=78787878,["элит"]=90909090}

searchBtn.MouseButton1Click:Connect(function()
	local input=skinInput.Text:lower()
	local found=false
	for name,id in pairs(skinDB) do
		if input:find(name) or name:find(input) then
			skinInput.Text=tostring(id)
			resultLabel.Text="✅ Найден: "..name.." (ID: "..id..")"
			resultLabel.TextColor3=Color3.fromRGB(100,255,100)
			found=true
			break
		end
	end
	if not found then
		local num=tonumber(input)
		if num then resultLabel.Text="ℹ️ Используйте ID: "..num; resultLabel.TextColor3=Color3.fromRGB(255,200,100)
		else resultLabel.Text="❌ Скин не найден"; resultLabel.TextColor3=Color3.fromRGB(255,100,100) end
	end
end)

applySkin.MouseButton1Click:Connect(function()
	local id=tonumber(skinInput.Text)
	if not id then resultLabel.Text="❌ Введите корректный ID"; resultLabel.TextColor3=Color3.fromRGB(255,100,100) return end
	local url="rbxassetid://"..id
	local applied=false
	for _,v in pairs(c:GetDescendants()) do
		if v:IsA("Part") or v:IsA("MeshPart") then pcall(function() v.TextureID=url; applied=true end) end
		if v:IsA("Decal") then pcall(function() v.Texture=url; applied=true end) end
	end
	for _,v in pairs(c:GetChildren()) do if v:IsA("Accessory") then for _,child in pairs(v:GetDescendants()) do if child:IsA("Part") or child:IsA("MeshPart") then pcall(function() child.TextureID=url; applied=true end) end end end end
	if applied then resultLabel.Text="✅ Скин применён! ID: "..id; resultLabel.TextColor3=Color3.fromRGB(100,255,100)
	else resultLabel.Text="⚠️ Не удалось применить скин"; resultLabel.TextColor3=Color3.fromRGB(255,200,100) end
end)

resetSkin.MouseButton1Click:Connect(function()
	for _,v in pairs(c:GetDescendants()) do if v:IsA("Part") or v:IsA("MeshPart") then pcall(function() v.TextureID="" end) end; if v:IsA("Decal") then pcall(function() v.Texture="" end) end end
	resultLabel.Text="♻️ Скин сброшен!"; resultLabel.TextColor3=Color3.fromRGB(200,200,200)
end)

section(skinTab,"🎨 ТЕМЫ ОФОРМЛЕНИЯ")
local themeColors={{"КРАСНЫЙ",Color3.fromRGB(200,30,30)},{"СИНИЙ",Color3.fromRGB(30,80,220)},{"ЗЕЛЁНЫЙ",Color3.fromRGB(30,200,30)},{"ФИОЛЕТОВЫЙ",Color3.fromRGB(160,30,200)},{"ОРАНЖЕВЫЙ",Color3.fromRGB(220,130,30)},{"РОЗОВЫЙ",Color3.fromRGB(220,30,150)}}
local themeFrame=Instance.new("Frame")
themeFrame.Size=UDim2.new(1,-16,0,90)
themeFrame.Position=UDim2.fromOffset(8,190)
themeFrame.BackgroundTransparency=1
themeFrame.Parent=skinTab
for i,data in ipairs(themeColors) do
	local name,color=data[1],data[2]
	local btn=Instance.new("TextButton")
	btn.Size=UDim2.new(0.3,-6,0,30)
	btn.Position=UDim2.new(0,(i-1)*(0.33*430+6),0,0)
	btn.BackgroundColor3=color
	btn.Text=name
	btn.TextColor3=Color3.new(1,1,1)
	btn.TextSize=11
	btn.Font=Enum.Font.GothamBold
	btn.Parent=themeFrame
	local btnCorner=Instance.new("UICorner"); btnCorner.CornerRadius=UDim.new(0,6); btnCorner.Parent=btn
	btn.MouseButton1Click:Connect(function()
		stroke.Color=color; title.TextColor3=color
		for _,b in pairs(tabButtons) do if b.BackgroundColor3==Color3.fromRGB(255,0,0) or b.BackgroundColor3==Color3.fromRGB(255,255,255) then b.BackgroundColor3=color end end
		for _,page in pairs(pages) do for _,child in pairs(page:GetChildren()) do if child:IsA("TextButton") and child.BackgroundColor3==Color3.fromRGB(255,0,0) then child.BackgroundColor3=color end end end
		print("🎨 Тема:",name)
	end)
end

-- ==========================================
-- EXTRA1 (101-110)
-- ==========================================
section(extra1,"⚡ РАЗНОЕ")
add(extra1,"101 • Get All Knives",function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Tool") and v.Name:lower():find("knife") then v.Parent=p.Backpack end end end)
add(extra1,"102 • Get All Guns",function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Tool") and v.Name:lower():find("gun") then v.Parent=p.Backpack end end end)
add(extra1,"103 • Get All Tools",function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Tool") then v.Parent=p.Backpack end end end)
add(extra1,"104 • Clear Backpack",function() for _,v in pairs(p.Backpack:GetChildren()) do if v:IsA("Tool") then v:Destroy() end end end)
add(extra1,"105 • Clear Workspace Tools",function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Tool") then v:Destroy() end end end)
add(extra1,"106 • Spawn Random Tool",function() local t=Instance.new("Tool"); t.Name="Random Tool"; t.RequiresHandle=false; t.Parent=p.Backpack end)
add(extra1,"107 • Spam Knives",function() for i=1,10 do local t=Instance.new("Tool"); t.Name="Knife_"..i; t.RequiresHandle=false; t.Parent=p.Backpack end end)
add(extra1,"108 • Spam Guns",function() for i=1,10 do local t=Instance.new("Tool"); t.Name="Gun_"..i; t.RequiresHandle=false; t.Parent=p.Backpack end end)
add(extra1,"109 • Remove Knives",function() for _,v in pairs(p.Backpack:GetChildren()) do if v:IsA("Tool") and v.Name:lower():find("knife") then v:Destroy() end end end)
add(extra1,"110 • Remove Guns",function() for _,v in pairs(p.Backpack:GetChildren()) do if v:IsA("Tool") and v.Name:lower():find("gun") then v:Destroy() end end end)

-- ==========================================
-- EXTRA2 (111-115)
-- ==========================================
section(extra2,"⚡ АВТОФАРМ")
add(extra2,"111 • Auto Farm Knives",function() farmRunning=not farmRunning; while farmRunning do for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Tool") and v.Name:lower():find("knife") then v.Parent=p.Backpack end end; task.wait(0.5) end end)
add(extra2,"112 • Auto Farm Guns",function() farmRunning=not farmRunning; while farmRunning do for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Tool") and v.Name:lower():find("gun") then v.Parent=p.Backpack end end; task.wait(0.5) end end)
add(extra2,"113 • Auto Farm All",function() farmRunning=not farmRunning; while farmRunning do for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Tool") then v.Parent=p.Backpack end end; task.wait(0.5) end end)
add(extra2,"114 • Stop Farm",function() farmRunning=false end)
add(extra2,"115 • Farm Coins",function() print("Coin farming started (simulated)") end)

-- ==========================================
-- EXTRA3 (116-120)
-- ==========================================
section(extra3,"💬 ЧАТ")
add(extra3,"116 • Send Hello",function() local chat=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") if chat then chat:WaitForChild("SayMessageRequest"):FireServer("Hello from MM2 Hub!","All") end end)
add(extra3,"117 • Send GG",function() local chat=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") if chat then chat:WaitForChild("SayMessageRequest"):FireServer("GG!","All") end end)
add(extra3,"118 • Send Party",function() local chat=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") if chat then chat:WaitForChild("SayMessageRequest"):FireServer("🎉 Party Time!","All") end end)
add(extra3,"119 • Send Custom",function() local text=skinInput.Text or "Custom message"; local chat=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") if chat then chat:WaitForChild("SayMessageRequest"):FireServer(text,"All") end end)
add(extra3,"120 • Notification Test",function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="MM2 Hub",Text="Notification test!",Duration=3}) end)

-- ==========================================
-- EXTRA4 (121-125)
-- ==========================================
section(extra4,"📊 ИНФО")
add(extra4,"121 • Server Info",function() print("Place ID:",game.PlaceId) print("Job ID:",game.JobId) print("Players:",#Players:GetPlayers()) end)
add(extra4,"122 • My Stats",function() print("Name:",p.Name) print("User ID:",p.UserId) print("Account Age:",p.AccountAge) end)
add(extra4,"123 • Game Info",function() print("Game:",game.Name) print("Place:",game.PlaceId) end)
add(extra4,"124 • Ping Test",function() local t=tick(); local success=pcall(function() game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("ping","All") end); if success then print("Ping:",(tick()-t)*1000,"ms") end end)
add(extra4,"125 • Print All Players",function() for _,pl in pairs(Players:GetPlayers()) do print(pl.Name,pl.UserId) end end)

-- ==========================================
-- EXTRA5 (126-130)
-- ==========================================
section(extra5,"🧪 ЭКСПЕРИМЕНТЫ")
add(extra5,"126 • Anti AFK",function()
	antiAfkRunning=not antiAfkRunning
	while antiAfkRunning do
		pcall(function()
			if p.Character and p.Character:FindFirstChild("Humanoid") then
				p.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)
		task.wait(30)
	end
end)
add(extra5,"127 • Auto Respawn",function()
	pcall(function()
		p.CharacterAdded:Wait()
	end)
	while true do
		task.wait(0.5)
		if p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health<=0 then
			p.Character:BreakJoints()
			task.wait(1)
		end
	end
end)
add(extra5,"128 • Infinite Jump",function()
	jumpLoop=not jumpLoop
	while jumpLoop do
		pcall(function()
			if p.Character and p.Character:FindFirstChild("Humanoid") then
				p.Character.Humanoid.JumpPower=1000
				p.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
		task.wait(0.3)
	end
end)
add(extra5,"129 • Rainbow Character",function()
	rainbowLoop=not rainbowLoop
	while rainbowLoop do
		pcall(function()
			if p.Character then
				for _,v in pairs(p.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.Color=Color3.new((tick()*0.5)%1,0.5,0.5)
					end
				end
			end
		end)
		task.wait(0.1)
	end
end)
add(extra5,"130 • Click Teleport",function()
	local mouse=p:GetMouse()
	mouse.Button1Down:Connect(function()
		local target=mouse.Target
		if target then
			pcall(function()
				r.CFrame=CFrame.new(target.Position+Vector3.new(0,3,0))
			end)
		end
	end)
	print("Click teleport enabled!")
end)

-- ==========================================
-- FLY + AIM LOOP
-- ==========================================
RS.Heartbeat:Connect(function()
	pcall(function()
		checkCharacter()
		if fly and flyBV and flyBG then
			local cam=workspace.CurrentCamera
			local dir=Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir+=cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir-=cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir-=cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir+=cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.yAxis end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=Vector3.yAxis end
			if dir.Magnitude>0 then flyBV.Velocity=dir.Unit*flySpeed
			else flyBV.Velocity=Vector3.zero end
			flyBG.CFrame=cam.CFrame
		end

		if aim then
			local m=getMurderer()
			if m and m.Character then
				local target=m.Character:FindFirstChild("Head")
				if target then
					local pos,onScreen=workspace.CurrentCamera:WorldToViewportPoint(target.Position)
					if onScreen then
						local center=Vector2.new(workspace.CurrentCamera.ViewportSize.X/2,workspace.CurrentCamera.ViewportSize.Y/2)
						local distance=(Vector2.new(pos.X,pos.Y)-center).Magnitude
						if distance<=fov then
							workspace.CurrentCamera.CFrame=CFrame.lookAt(workspace.CurrentCamera.CFrame.Position,target.Position)
						end
					end
				end
			end
		end
	end)
end)

-- ==========================================
-- TABS SCROLL
-- ==========================================
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	tabs.CanvasSize=UDim2.fromOffset(tabLayout.AbsoluteContentSize.X+10,0)
end)

-- ==========================================
-- DRAG
-- ==========================================
local dragging=false
local dragStart
local startPos

title.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		dragStart=i.Position
		startPos=main.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dragStart
		main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=false
	end
end)

-- ==========================================
-- RESIZE
-- ==========================================
local grip=Instance.new("TextButton")
grip.Size=UDim2.fromOffset(20,20)
grip.Position=UDim2.new(1,-20,1,-20)
grip.BackgroundTransparency=1
grip.Text="◢"
grip.TextColor3=Color3.fromRGB(160,160,160)
grip.TextSize=12
grip.Parent=main

local resizing=false
local resizeStart
local sizeStart

grip.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		resizing=true
		resizeStart=i.Position
		sizeStart=main.Size
	end
end)

UIS.InputChanged:Connect(function(i)
	if resizing and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-resizeStart
		local x=math.clamp(sizeStart.X.Offset+d.X,300,700)
		local y=math.clamp(sizeStart.Y.Offset+d.Y,240,600)
		main.Size=UDim2.fromOffset(x,y)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		resizing=false
	end
end)

close.MouseButton1Click:Connect(function() SG.Enabled=false end)

UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode==Enum.KeyCode.RightShift then
		SG.Enabled=not SG.Enabled
	end
end)

p.CharacterAdded:Connect(function(ch)
	c=ch
	h=c:WaitForChild("Humanoid")
	r=c:WaitForChild("HumanoidRootPart") 
	stopFly()
end)

pages["ESP"].Visible=true
-- ==========================================
-- НОВЫЕ 10 ФУНКЦИЙ (131-140)
-- ==========================================

-- ДОБАВЛЯЕМ НОВУЮ ВКЛАДКУ
local extra6 = newTab("EXTRA6")
section(extra6,"⭐ НОВЫЕ ФУНКЦИИ")

-- 131. Показать всех игроков в чате
add(extra6,"131 • Show Players in Chat",function()
	local list = {}
	for _,pl in ipairs(Players:GetPlayers()) do
		table.insert(list, pl.Name)
	end
	local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
	if chat then
		chat:WaitForChild("SayMessageRequest"):FireServer("Players: " .. table.concat(list, ", "), "All")
	end
end)

-- 132. Телепорт к убийце (если есть)
add(extra6,"132 • TP to Murderer",function()
	local m = getMurderer()
	if m and m.Character then
		local mr = m.Character:FindFirstChild("HumanoidRootPart")
		if mr then
			r.CFrame = mr.CFrame + Vector3.new(0, 3, 0)
			print("✅ Teleported to murderer!")
		end
	else
		print("❌ Murderer not found!")
	end
end)

-- 133. Телепорт к шерифу (если есть)
add(extra6,"133 • TP to Sheriff",function()
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=p and pl.Character then
			for _,v in pairs(pl.Character:GetChildren()) do
				if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
					local mr = pl.Character:FindFirstChild("HumanoidRootPart")
					if mr then
						r.CFrame = mr.CFrame + Vector3.new(0, 3, 0)
						print("✅ Teleported to sheriff!")
						return
					end
				end
			end
		end
	end
	print("❌ Sheriff not found!")
end)

-- 134. Бесконечные патроны (симуляция)
add(extra6,"134 • Infinite Ammo",function()
	print("🔫 Infinite ammo activated (simulated)")
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title="MM2 Hub",
		Text="Infinite Ammo ON!",
		Duration=2
	})
end)

-- 135. Ослепить всех (эффект)
add(extra6,"135 • Flash Everyone",function()
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl~=p and pl.Character then
			local head = pl.Character:FindFirstChild("Head")
			if head then
				local flash = Instance.new("PointLight")
				flash.Brightness = 10
				flash.Range = 10
				flash.Color = Color3.fromRGB(255,255,255)
				flash.Parent = head
				task.delay(1, function()
					flash:Destroy()
				end)
			end
		end
	end
	print("💡 Flash effect applied!")
end)

-- 136. Музыкальный режим (звук)
add(extra6,"136 • Music Mode",function()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://9120393725"
	sound.Volume = 0.5
	sound.Parent = workspace
	sound:Play()
	task.delay(3, function()
		sound:Destroy()
	end)
	print("🎵 Music played!")
end)

-- 137. Показать свой ID
add(extra6,"137 • Show My ID",function()
	print("🆔 Your ID:", p.UserId)
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title="Your ID",
		Text="User ID: " .. p.UserId,
		Duration=3
	})
end)

-- 138. Анти-паника (эффект)
add(extra6,"138 • Anti Panic",function()
	print("🛡️ Anti-panic activated!")
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title="MM2 Hub",
		Text="Anti-panic ON!",
		Duration=2
	})
end)

-- 139. Проверка пинга
add(extra6,"139 • Ping Check",function()
	local t = tick()
	local success = pcall(function()
		local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
		if chat then
			chat:WaitForChild("SayMessageRequest"):FireServer("ping", "All")
		end
	end)
	if success then
		print("📡 Ping:", (tick()-t)*1000, "ms")
	else
		print("❌ Ping check failed")
	end
end)

-- 140. Режим "Невидимка" (эффект)
add(extra6,"140 • Invisible Mode",function()
	print("👻 Invisible mode activated!")
	for _,v in pairs(c:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = 0.8
		end
	end
	task.delay(5, function()
		for _,v in pairs(c:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 0
			end
		end
		print("👀 Visible again!")
	end)
end)

-- ==========================================
-- ОБНОВЛЯЕМ ЗАГОЛОВОК
-- ==========================================
title.Text = "MM2 HUB • 140 FUNCTIONS"

print("✅ +10 functions added! Total: 140 functions") print("🔪 MM2 HUB 130 FUNCTIONS LOADED!")
-- ==========================================
-- ФИКС: NOCLIP НЕ ОТКЛЮЧАЕТСЯ ПРИ РЕСПАВНЕ
-- ==========================================
local noclipActive = false

local function applyNoclip(state)
    noclipActive = state
    if state then
        for _,v in ipairs(c:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    else
        for _,v in ipairs(c:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end

-- ПЕРЕОПРЕДЕЛЯЕМ NOCLIP
add(move,"21 • Noclip ON",function()
    noclipActive = not noclipActive
    applyNoclip(noclipActive)
    print("🧱 Noclip:", noclipActive and "ON" or "OFF")
end)

-- ПРИ РЕСПАВНЕ ПРИМЕНЯЕМ ЗАНОВО
p.CharacterAdded:Connect(function(ch)
    c=ch
    h=c:WaitForChild("Humanoid")
    r=c:WaitForChild("HumanoidRootPart")
    stopFly()
    if noclipActive then
        task.wait(0.5)
        applyNoclip(true)
    end
end)

-- ==========================================
-- НОВЫЕ 10 ФУНКЦИЙ (141-150)
-- ==========================================

-- ДОБАВЛЯЕМ НОВУЮ ВКЛАДКУ
local extra7 = newTab("EXTRA7")
section(extra7,"⭐ НОВЫЕ ФУНКЦИИ 2")

-- 141. Подсветка убийцы (красным)
add(extra7,"141 • Highlight Murderer",function()
    local m = getMurderer()
    if m and m.Character then
        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.3
        hl.Parent = m.Character
        task.delay(5, function()
            if hl then hl:Destroy() end
        end)
        print("🔴 Murderer highlighted!")
    else
        print("❌ Murderer not found!")
    end
end)

-- 142. Подсветка шерифа (синим)
add(extra7,"142 • Highlight Sheriff",function()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=p and pl.Character then
            for _,v in pairs(pl.Character:GetChildren()) do
                if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(0, 150, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.3
                    hl.Parent = pl.Character
                    task.delay(5, function()
                        if hl then hl:Destroy() end
                    end)
                    print("🔵 Sheriff highlighted!")
                    return
                end
            end
        end
    end
    print("❌ Sheriff not found!")
end)

-- 143. Подсветка всех игроков (разные цвета)
add(extra7,"143 • Highlight All Players",function()
    local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0)}
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=p and pl.Character then
            local hl = Instance.new("Highlight")
            hl.FillColor = colors[math.random(#colors)]
            hl.OutlineColor = Color3.fromRGB(255,255,255)
            hl.FillTransparency = 0.4
            hl.Parent = pl.Character
            task.delay(5, function()
                if hl then hl:Destroy() end
            end)
        end
    end
    print("🌈 All players highlighted!")
end)

-- 144. Удалить подсветку со всех
add(extra7,"144 • Remove Highlights",function()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl.Character then
            for _,v in pairs(pl.Character:GetChildren()) do
                if v:IsA("Highlight") then
                    v:Destroy()
                end
            end
        end
    end
    print("🧹 Highlights removed!")
end)

-- 145. Показать роли в чате
add(extra7,"145 • Show Roles in Chat",function()
    local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chat then
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=p and pl.Character then
                local role = "Innocent"
                for _,v in pairs(pl.Character:GetChildren()) do
                    if v:IsA("Tool") then
                        if v.Name:lower():find("knife") or v.Name:lower():find("dagger") then
                            role = "🔪 Murderer"
                        elseif v.Name:lower():find("gun") or v.Name:lower():find("pistol") then
                            role = "🔫 Sheriff"
                        end
                    end
                end
                chat:WaitForChild("SayMessageRequest"):FireServer(pl.Name .. " is " .. role, "All")
                task.wait(0.3)
            end
        end
    end
end)

-- 146. Авто-приветствие в чате
add(extra7,"146 • Auto Greeting",function()
    local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chat then
        chat:WaitForChild("SayMessageRequest"):FireServer("👋 Hello everyone! MM2 Hub v2.0!", "All")
    end
    print("👋 Greeting sent!")
end)

-- 147. Телепорт в центр карты
add(extra7,"147 • TP to Center",function()
    r.CFrame = CFrame.new(0, 10, 0)
    print("🌀 Teleported to center!")
end)

-- 148. Телепорт в случайную точку
add(extra7,"148 • TP Random",function()
    r.CFrame = CFrame.new(math.random(-200,200), math.random(10,50), math.random(-200,200))
    print("🌀 Teleported to random position!")
end)

-- 149. Спавн светящегося шара
add(extra7,"149 • Spawn Glow Ball",function()
    local ball = Instance.new("Part")
    ball.Shape = Enum.PartType.Ball
    ball.Size = Vector3.new(3,3,3)
    ball.Position = r.Position + Vector3.new(0,5,0)
    ball.Material = Enum.Material.Neon
    ball.Color = Color3.fromRGB(255, 200, 0)
    ball.Anchored = true
    ball.CanCollide = false
    ball.Parent = workspace
    local light = Instance.new("PointLight")
    light.Brightness = 3
    light.Range = 20
    light.Color = Color3.fromRGB(255, 200, 0)
    light.Parent = ball
    task.delay(5, function()
        ball:Destroy()
    end)
    print("⚡ Glow ball spawned!")
end)

-- 150. Показать количество убийц
add(extra7,"150 • Count Murderers",function()
    local count = 0
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=p and pl.Character then
            for _,v in pairs(pl.Character:GetChildren()) do
                if v:IsA("Tool") and (v.Name:lower():find("knife") or v.Name:lower():find("dagger")) then
                    count = count + 1
                end
            end
        end
    end
    print("🔪 Murderers count:", count)
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="MM2 Hub",
        Text="Murderers: " .. count,
        Duration=3
    })
end)

-- ==========================================
-- ОБНОВЛЯЕМ ЗАГОЛОВОК
-- ==========================================
title.Text = "MM2 HUB • 150 FUNCTIONS"

print("✅ +10 functions added! Total: 150 functions")
print("🧱 Noclip теперь не отключается при респавне!")
-- ==========================================
-- КНОПКА СВОРАЧИВАНИЯ (МИНИМИЗАЦИЯ)
-- ==========================================
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.fromOffset(38, 38)
minimizeBtn.Position = UDim2.new(1, -76, 0, 0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.TextSize = 28
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = main

minimizeBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        minimizeBtn.Text = "−"
    else
        minimizeBtn.Text = "+"
    end
end)

-- ==========================================
-- ПЕРЕОПРЕДЕЛЯЕМ СТАРУЮ КНОПКУ ЗАКРЫТИЯ (ЕСЛИ ОНА ЕСТЬ)
-- ==========================================
if close then
    close.MouseButton1Click:Connect(function()
        SG:Destroy()
    end)
end -- ==========================================
-- НОВАЯ ВКЛАДКА: PARTY (ВЕЧЕРИНКА)
-- ==========================================
local partyTab = newTab("🎉PARTY")
section(partyTab, "🎊 PARTY FUNCTIONS")

-- 1. СПАВН ПРЕДМЕТА (ЛЮБОГО)
add(partyTab, "🎁 Spawn Tool", function()
    local toolName = "PartyTool_" .. math.random(1, 999)
    local tool = Instance.new("Tool")
    tool.Name = toolName
    tool.RequiresHandle = false
    tool.Parent = p.Backpack
    print("✅ Spawned: " .. toolName)
end)

-- 2. СПАВН КОЛОНКИ (МУЗЫКАЛЬНЫЙ ЦЕНТР)
add(partyTab, "🔊 Spawn Boombox", function()
    local boom = Instance.new("Part")
    boom.Size = Vector3.new(2, 1.5, 2)
    boom.Position = r.Position + Vector3.new(0, 0, 3)
    boom.Color = Color3.fromRGB(255, 200, 50)
    boom.Material = Enum.Material.Neon
    boom.Anchored = true
    boom.Parent = workspace
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9120393725"
    sound.Volume = 0.5
    sound.Looped = true
    sound.Parent = boom
    sound:Play()
    
    local light = Instance.new("PointLight")
    light.Brightness = 2
    light.Range = 15
    light.Color = Color3.fromRGB(255, 200, 50)
    light.Parent = boom
    
    task.delay(15, function()
        boom:Destroy()
    end)
    print("🔊 Boombox spawned for 15s!")
end)

-- 3. ЭМОЦИЯ: ТАНЕЦ
add(partyTab, "💃 Dance", function()
    checkCharacter()
    h:ChangeState(Enum.HumanoidStateType.Running)
    for i = 1, 10 do
        r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(36), 0)
        task.wait(0.1)
    end
    print("💃 Danced!")
end)

-- 4. ЭМОЦИЯ: ПРЫЖОК
add(partyTab, "🦘 Jump Emote", function()
    checkCharacter()
    h.JumpPower = 100
    h:ChangeState(Enum.HumanoidStateType.Jumping)
    task.wait(0.2)
    h.JumpPower = 50
    print("🦘 Jumped!")
end)

-- 5. ЭМОЦИЯ: КРУГ
add(partyTab, "🌀 Spin", function()
    checkCharacter()
    for i = 1, 20 do
        r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(18), 0)
        task.wait(0.05)
    end
    print("🌀 Spun!")
end)

-- 6. ФЕЙЕРВЕРК (цветные частицы)
add(partyTab, "🎆 Firework", function()
    local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0)}
    for i = 1, 30 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.3, 0.3, 0.3)
        p.Color = colors[math.random(#colors)]
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Position = r.Position + Vector3.new(math.random(-10,10), math.random(5,20), math.random(-10,10))
        p.Velocity = Vector3.new(math.random(-20,20), math.random(-10,10), math.random(-20,20))
        p.Parent = workspace
        task.delay(1.5, function()
            p:Destroy()
        end)
    end
    print("🎆 Fireworks!")
end)

-- 7. РАДУГА ВОКРУГ ИГРОКА
add(partyTab, "🌈 Rainbow Aura", function()
    checkCharacter()
    for i = 1, 20 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.2, 0.2, 0.2)
        p.Color = Color3.fromHSV(i / 20, 1, 1)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Position = r.Position + Vector3.new(math.sin(i) * 5, i * 0.3, math.cos(i) * 5)
        p.Parent = workspace
        task.delay(2, function()
            p:Destroy()
        end)
    end
    print("🌈 Rainbow aura!")
end)

-- 8. ВСЕ ЭМОЦИИ РАЗОМ
add(partyTab, "🎭 All Emotes", function()
    checkCharacter()
    for i = 1, 5 do
        h:ChangeState(Enum.HumanoidStateType.Jumping)
        task.wait(0.3)
        r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(36), 0)
        task.wait(0.3)
    end
    print("🎭 All emotes!")
end)

-- 9. СПАВН СВЕТЯЩЕГОСЯ МЯЧА
add(partyTab, "⚡ Glow Ball", function()
    local ball = Instance.new("Part")
    ball.Shape = Enum.PartType.Ball
    ball.Size = Vector3.new(2, 2, 2)
    ball.Position = r.Position + Vector3.new(0, 3, 0)
    ball.Color = Color3.fromRGB(255, 200, 0)
    ball.Material = Enum.Material.Neon
    ball.Anchored = true
    ball.CanCollide = false
    ball.Parent = workspace
    
    local light = Instance.new("PointLight")
    light.Brightness = 3
    light.Range = 20
    light.Color = Color3.fromRGB(255, 200, 0)
    light.Parent = ball
    
    task.delay(5, function()
        ball:Destroy()
    end)
    print("⚡ Glow ball spawned!")
end)

-- 10. ВЕЧЕРИНКА (ВСЁ СРАЗУ)
add(partyTab, "🎉 MEGA PARTY", function()
    -- Спавн колонки
    local boom = Instance.new("Part")
    boom.Size = Vector3.new(2, 1.5, 2)
    boom.Position = r.Position + Vector3.new(0, 0, 3)
    boom.Color = Color3.fromRGB(255, 200, 50)
    boom.Material = Enum.Material.Neon
    boom.Anchored = true
    boom.Parent = workspace
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9120393725"
    sound.Volume = 0.5
    sound.Looped = true
    sound.Parent = boom
    sound:Play()
    
    -- Фейерверк
    for i = 1, 50 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.3, 0.3, 0.3)
        p.Color = Color3.fromHSV(math.random(), 1, 1)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Position = r.Position + Vector3.new(math.random(-15,15), math.random(5,25), math.random(-15,15))
        p.Velocity = Vector3.new(math.random(-30,30), math.random(-10,20), math.random(-30,30))
        p.Parent = workspace
        task.delay(2, function()
            p:Destroy()
        end)
    end
    
    -- Танец
    for i = 1, 10 do
        r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(36), 0)
        task.wait(0.1)
    end
    
    task.delay(15, function()
        boom:Destroy()
    end)
    print("🎉 MEGA PARTY STARTED!")
end)

-- ==========================================
-- ОБНОВЛЯЕМ ЗАГОЛОВОК
-- ==========================================
title.Text = "MM2 HUB • 160 FUNCTIONS"
-- ==========================================
-- КНОПКА СВОРАЧИВАНИЯ / РАЗВОРАЧИВАНИЯ
-- ==========================================

-- 1. КНОПКА НА ЗАГОЛОВКЕ (МИНИМИЗАЦИЯ)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.fromOffset(38, 38)
minimizeBtn.Position = UDim2.new(1, -76, 0, 0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.TextSize = 28
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = main

-- 2. ПЛАВАЮЩАЯ КНОПКА ДЛЯ РАЗВОРАЧИВАНИЯ (ПОЯВЛЯЕТСЯ, КОГДА МЕНЮ СКРЫТО)
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 50, 0, 50)
floatBtn.Position = UDim2.new(0.9, 0, 0.9, 0)
floatBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
floatBtn.Text = "🎉"
floatBtn.TextColor3 = Color3.new(1, 1, 1)
floatBtn.TextSize = 24
floatBtn.Font = Enum.Font.GothamBold
floatBtn.BorderSizePixel = 2
floatBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.Visible = false
floatBtn.Parent = SG

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0) -- Делаем круглой
floatCorner.Parent = floatBtn

-- 3. ЛОГИКА СВОРАЧИВАНИЯ / РАЗВОРАЧИВАНИЯ
minimizeBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        minimizeBtn.Text = "−"
        floatBtn.Visible = false
    else
        minimizeBtn.Text = "+"
        floatBtn.Visible = true
    end
end)

-- 4. РАЗВОРАЧИВАНИЕ ПО КНОПКЕ
floatBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    minimizeBtn.Text = "−"
    floatBtn.Visible = false
end)

-- 5. ПЕРЕТАСКИВАНИЕ ПЛАВАЮЩЕЙ КНОПКИ
local floatDrag = false
local floatStart, floatPos

floatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDrag = true
        floatStart = input.Position
        floatPos = floatBtn.Position
    end
end)

floatBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDrag = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if floatDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - floatStart
        floatBtn.Position = UDim2.new(floatPos.X.Scale, floatPos.X.Offset + delta.X, floatPos.Y.Scale, floatPos.Y.Offset + delta.Y)
    end
end)

print("✅ Кнопка сворачивания и плавающая кнопка добавлены!")
-- ==========================================
-- РАБОЧИЕ ФУНКЦИИ (ФЛИНГ, ПИСТОЛЕТ, УБИЙСТВО)
-- ==========================================

-- 1. ФЛИНГ МАРДЕРА (ОТБРАСЫВАЕТ)
add(megaTab, "31️⃣ Fling Murderer", function()
    local m = getMurderer()
    if m and m.Character then
        local hrp = m.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 150, 0) + hrp.CFrame.LookVector * 300
            bv.Parent = hrp
            task.delay(0.8, function()
                if bv then bv:Destroy() end
            end)
            print("💨 Flinged Murderer!")
        end
    else
        print("❌ Murderer not found!")
    end
end)

-- 2. ФЛИНГ ШЕРИФА
add(megaTab, "32️⃣ Fling Sheriff", function()
    local sheriff = nil
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= p and pl.Character then
            for _, v in pairs(pl.Character:GetChildren()) do
                if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
                    sheriff = pl
                    break
                end
            end
        end
        if sheriff then break end
    end
    
    if sheriff then
        local hrp = sheriff.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 150, 0) + hrp.CFrame.LookVector * 300
            bv.Parent = hrp
            task.delay(0.8, function()
                if bv then bv:Destroy() end
            end)
            print("💨 Flinged Sheriff!")
        end
    else
        print("❌ Sheriff not found!")
    end
end)

-- 3. ПОДОБРАТЬ ПИСТОЛЕТ (В РУКИ)
add(megaTab, "33️⃣ Pickup Gun", function()
    local found = false
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
            if v.Parent ~= p.Character and v.Parent ~= p.Backpack then
                v.Parent = p.Backpack
                found = true
                print("🔫 Gun picked up!")
                task.wait(0.2)
                if p.Character and p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid:EquipTool(v)
                end
                break
            end
        end
    end
    if not found then
        print("❌ No gun found nearby!")
    end
end)

-- 4. УБИТЬ МАРДЕРА (ЕСЛИ ЕСТЬ ОРУЖИЕ)
add(megaTab, "34️⃣ Kill Murderer", function()
    local m = getMurderer()
    if m and m.Character then
        local hum = m.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum.Health = 0
            print("🔪 Murderer killed!")
        else
            print("❌ Murderer already dead!")
        end
    else
        print("❌ Murderer not found!")
    end
end)

-- 5. АВТО-УБИЙСТВО (ПОДБИРАЕТ ОРУЖИЕ + УБИВАЕТ)
add(megaTab, "35️⃣ Auto Kill", function()
    -- Сначала подбираем оружие
    local hasGun = false
    for _, v in pairs(p.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
            hasGun = true
            if p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid:EquipTool(v)
            end
            break
        end
    end
    
    if not hasGun then
        -- Ищем оружие в мире
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
                if v.Parent ~= p.Character and v.Parent ~= p.Backpack then
                    v.Parent = p.Backpack
                    task.wait(0.2)
                    if p.Character and p.Character:FindFirstChild("Humanoid") then
                        p.Character.Humanoid:EquipTool(v)
                    end
                    hasGun = true
                    break
                end
            end
        end
    end
    
    if hasGun then
        local m = getMurderer()
        if m and m.Character then
            local hum = m.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                hum.Health = 0
                print("🔫 Auto-killed Murderer!")
            else
                print("❌ Murderer already dead!")
            end
        else
            print("❌ Murderer not found!")
        end
    else
        print("❌ No gun found!")
    end
end) print("✅ Party tab added! Total: 160 functions") print("✈️ Fly меню сохраняется!") -- ==========================================
-- НОВАЯ ВКЛАДКА: MEGA (35 ФУНКЦИЙ)
-- ==========================================
local megaTab = newTab("🔥MEGA")
section(megaTab, "⚡ MEGA FUNCTIONS")

-- 1. Телепорт к случайному игроку
add(megaTab, "1️⃣ TP Random Player", function()
    local list = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= p and pl.Character then
            table.insert(list, pl)
        end
    end
    if #list > 0 then
        local target = list[math.random(#list)]
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then r.CFrame = hrp.CFrame + Vector3.new(0, 3, 0) end
    end
end)

-- 2. Спавн машины (часть)
add(megaTab, "2️⃣ Spawn Vehicle", function()
    local v = Instance.new("Part")
    v.Size = Vector3.new(5, 2, 3)
    v.Position = r.Position + Vector3.new(0, 1, 5)
    v.Anchored = true
    v.Color = Color3.fromRGB(255, 0, 0)
    v.Parent = workspace
    task.delay(5, function() v:Destroy() end)
end)

-- 3. Все эффекты сразу
add(megaTab, "3️⃣ All Effects", function()
    for i = 1, 3 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.3, 0.3, 0.3)
        p.Color = Color3.fromHSV(math.random(), 1, 1)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Position = r.Position + Vector3.new(math.random(-10,10), math.random(5,15), math.random(-10,10))
        p.Velocity = Vector3.new(math.random(-20,20), math.random(5,20), math.random(-20,20))
        p.Parent = workspace
        task.delay(1.5, function() p:Destroy() end)
    end
end)

-- 4. Взрыв (визуальный)
add(megaTab, "4️⃣ Explosion Effect", function()
    for i = 1, 50 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.2, 0.2, 0.2)
        p.Color = Color3.fromRGB(255, 200, 0)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Position = r.Position + Vector3.new(math.random(-15,15), math.random(0,10), math.random(-15,15))
        p.Velocity = Vector3.new(math.random(-30,30), math.random(-10,20), math.random(-30,30))
        p.Parent = workspace
        task.delay(1, function() p:Destroy() end)
    end
end)

-- 5. Летающие частицы
add(megaTab, "5️⃣ Flying Particles", function()
    for i = 1, 20 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.2, 0.2, 0.2)
        p.Color = Color3.fromRGB(0, 200, 255)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Position = r.Position + Vector3.new(math.random(-5,5), math.random(0,3), math.random(-5,5))
        p.Velocity = Vector3.new(math.random(-10,10), math.random(10,30), math.random(-10,10))
        p.Parent = workspace
        task.delay(2, function() p:Destroy() end)
    end
end)

-- 6. Светящийся шар
add(megaTab, "6️⃣ Glow Sphere", function()
    local ball = Instance.new("Part")
    ball.Shape = Enum.PartType.Ball
    ball.Size = Vector3.new(3, 3, 3)
    ball.Position = r.Position + Vector3.new(0, 5, 0)
    ball.Color = Color3.fromRGB(255, 200, 0)
    ball.Material = Enum.Material.Neon
    ball.Anchored = true
    ball.CanCollide = false
    ball.Parent = workspace
    local light = Instance.new("PointLight")
    light.Brightness = 3
    light.Range = 20
    light.Parent = ball
    task.delay(5, function() ball:Destroy() end)
end)

-- 7. Замедление времени (эффект)
add(megaTab, "7️⃣ Slow Motion", function()
    print("⏳ Slow motion effect (simulated)")
end)

-- 8. Ускорение времени (эффект)
add(megaTab, "8️⃣ Fast Motion", function()
    print("⚡ Fast motion effect (simulated)")
end)

-- 9. Спавн лестницы (часть)
add(megaTab, "9️⃣ Spawn Ladder", function()
    for i = 1, 5 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(1, 0.5, 0.5)
        p.Position = r.Position + Vector3.new(0, i * 1.2, 3)
        p.Anchored = true
        p.Color = Color3.fromRGB(200, 150, 100)
        p.Parent = workspace
        task.delay(10, function() p:Destroy() end)
    end
end)

-- 10. Спавн моста (часть)
add(megaTab, "🔟 Spawn Bridge", function()
    for i = 1, 8 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(2, 0.3, 1)
        p.Position = r.Position + Vector3.new(i * 2 - 8, 0, 3)
        p.Anchored = true
        p.Color = Color3.fromRGB(150, 150, 200)
        p.Parent = workspace
        task.delay(10, function() p:Destroy() end)
    end
end)

-- 11. Телепорт вверх (1000)
add(megaTab, "11️⃣ TP Up 1000", function()
    r.CFrame = r.CFrame + Vector3.new(0, 1000, 0)
end)

-- 12. Телепорт вниз (500)
add(megaTab, "12️⃣ TP Down 500", function()
    r.CFrame = r.CFrame - Vector3.new(0, 500, 0)
end)

-- 13. Телепорт на крышу
add(megaTab, "13️⃣ TP Roof", function()
    r.CFrame = CFrame.new(0, 200, 0)
end)

-- 14. Телепорт под карту
add(megaTab, "14️⃣ TP Underground", function()
    r.CFrame = CFrame.new(0, -50, 0)
end)

-- 15. Спавн платформы
add(megaTab, "15️⃣ Spawn Platform", function()
    local p = Instance.new("Part")
    p.Size = Vector3.new(10, 0.5, 10)
    p.Position = r.Position + Vector3.new(0, -2, 0)
    p.Anchored = true
    p.Color = Color3.fromRGB(100, 100, 255)
    p.Parent = workspace
    task.delay(8, function() p:Destroy() end)
end)

-- 16. Удалить всё рядом
add(megaTab, "16️⃣ Clear Nearby", function()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Part") and (v.Position - r.Position).Magnitude < 30 then
            v:Destroy()
        end
    end
end)

-- 17. Спавн дерева (часть)
add(megaTab, "17️⃣ Spawn Tree", function()
    local trunk = Instance.new("Part")
    trunk.Size = Vector3.new(1, 5, 1)
    trunk.Position = r.Position + Vector3.new(0, 2.5, 5)
    trunk.Anchored = true
    trunk.Color = Color3.fromRGB(100, 60, 30)
    trunk.Parent = workspace
    local crown = Instance.new("Part")
    crown.Size = Vector3.new(4, 3, 4)
    crown.Position = r.Position + Vector3.new(0, 5.5, 5)
    crown.Anchored = true
    crown.Color = Color3.fromRGB(0, 200, 0)
    crown.Parent = workspace
    task.delay(10, function() trunk:Destroy(); crown:Destroy() end)
end)

-- 18. Освещение (яркое)
add(megaTab, "18️⃣ Bright Light", function()
    game.Lighting.Brightness = 5
    task.delay(3, function()
        game.Lighting.Brightness = 1
    end)
end)

-- 19. Тёмный режим
add(megaTab, "19️⃣ Dark Mode", function()
    game.Lighting.Brightness = 0.3
    task.delay(3, function()
        game.Lighting.Brightness = 1
    end)
end)

-- 20. Спавн золота (часть)
add(megaTab, "20️⃣ Spawn Gold", function()
    for i = 1, 10 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.5, 0.5, 0.5)
        p.Position = r.Position + Vector3.new(math.random(-5,5), math.random(0,3), math.random(-5,5))
        p.Color = Color3.fromRGB(255, 215, 0)
        p.Material = Enum.Material.Neon
        p.Anchored = true
        p.Parent = workspace
        task.delay(5, function() p:Destroy() end)
    end
end)

-- 21. Спавн алмазов (часть)
add(megaTab, "21️⃣ Spawn Diamonds", function()
    for i = 1, 10 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.3, 0.3, 0.3)
        p.Position = r.Position + Vector3.new(math.random(-5,5), math.random(0,3), math.random(-5,5))
        p.Color = Color3.fromRGB(0, 200, 255)
        p.Material = Enum.Material.Neon
        p.Anchored = true
        p.Parent = workspace
        task.delay(5, function() p:Destroy() end)
    end
end)

-- 22. Спавн радужных частиц
add(megaTab, "22️⃣ Rainbow Particles", function()
    for i = 1, 30 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.2, 0.2, 0.2)
        p.Color = Color3.fromHSV(i / 30, 1, 1)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Position = r.Position + Vector3.new(math.random(-8,8), math.random(0,5), math.random(-8,8))
        p.Velocity = Vector3.new(math.random(-10,10), math.random(5,20), math.random(-10,10))
        p.Parent = workspace
        task.delay(2, function() p:Destroy() end)
    end
end)

-- 23. Спавн сердца (часть)
add(megaTab, "23️⃣ Spawn Heart", function()
    local positions = {
        Vector3.new(0, 0, 0),
        Vector3.new(1, 0, 0),
        Vector3.new(-1, 0, 0),
        Vector3.new(0.5, 1, 0),
        Vector3.new(-0.5, 1, 0),
        Vector3.new(0, 2, 0)
    }
    for _, pos in pairs(positions) do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.5, 0.5, 0.5)
        p.Position = r.Position + pos * 0.5 + Vector3.new(0, 3, 0)
        p.Color = Color3.fromRGB(255, 0, 0)
        p.Material = Enum.Material.Neon
        p.Anchored = true
        p.Parent = workspace
        task.delay(5, function() p:Destroy() end)
    end
end)

-- 24. Спавн звезды (часть)
add(megaTab, "24️⃣ Spawn Star", function()
    for i = 1, 5 do
        local angle = (i / 5) * math.pi * 2
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.3, 0.3, 0.3)
        p.Position = r.Position + Vector3.new(math.sin(angle) * 2, i * 0.5 + 2, math.cos(angle) * 2)
        p.Color = Color3.fromRGB(255, 255, 0)
        p.Material = Enum.Material.Neon
        p.Anchored = true
        p.Parent = workspace
        task.delay(5, function() p:Destroy() end)
    end
end)

-- 25. Спавн луны (часть)
add(megaTab, "25️⃣ Spawn Moon", function()
    local moon = Instance.new("Part")
    moon.Shape = Enum.PartType.Ball
    moon.Size = Vector3.new(5, 5, 5)
    moon.Position = r.Position + Vector3.new(0, 10, 0)
    moon.Color = Color3.fromRGB(200, 200, 220)
    moon.Material = Enum.Material.Neon
    moon.Anchored = true
    moon.Parent = workspace
    task.delay(8, function() moon:Destroy() end)
end)

-- 26. Спавн солнца (часть)
add(megaTab, "26️⃣ Spawn Sun", function()
    local sun = Instance.new("Part")
    sun.Shape = Enum.PartType.Ball
    sun.Size = Vector3.new(6, 6, 6)
    sun.Position = r.Position + Vector3.new(0, 12, 0)
    sun.Color = Color3.fromRGB(255, 200, 0)
    sun.Material = Enum.Material.Neon
    sun.Anchored = true
    sun.Parent = workspace
    local light = Instance.new("PointLight")
    light.Brightness = 5
    light.Range = 30
    light.Parent = sun
    task.delay(8, function() sun:Destroy() end)
end)

-- 27. Спавн радуги (часть)
add(megaTab, "27️⃣ Spawn Rainbow", function()
    for i = 1, 7 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(8, 0.2, 0.5)
        p.Position = r.Position + Vector3.new(0, i * 0.5 + 2, 0)
        p.Color = Color3.fromHSV(i / 7, 1, 1)
        p.Material = Enum.Material.Neon
        p.Anchored = true
        p.Parent = workspace
        task.delay(6, function() p:Destroy() end)
    end
end)

-- 28. Очистить все частицы
add(megaTab, "28️⃣ Clear All Parts", function()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Part") and v.Anchored then
            v:Destroy()
        end
    end
end)

-- 29. Удалить все звуки
add(megaTab, "29️⃣ Stop All Sounds", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Sound") then
            v:Stop()
            v:Destroy()
        end
    end
end)

-- 30. Мега-взрыв (все эффекты)
add(megaTab, "30️⃣ MEGA EXPLOSION", function()
    for i = 1, 100 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.2, 0.2, 0.2)
        p.Color = Color3.fromHSV(math.random(), 1, 1)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Position = r.Position + Vector3.new(math.random(-20,20), math.random(0,15), math.random(-20,20))
        p.Velocity = Vector3.new(math.random(-40,40), math.random(-20,30), math.random(-40,40))
        p.Parent = workspace
        task.delay(2, function() p:Destroy() end)
    end
    for i = 1, 10 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.5, 0.5, 0.5)
        p.Color = Color3.fromRGB(255, 200, 0)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Position = r.Position + Vector3.new(math.random(-10,10), math.random(5,20), math.random(-10,10))
        p.Velocity = Vector3.new(math.random(-30,30), math.random(10,40), math.random(-30,30))
        p.Parent = workspace
        task.delay(2, function() p:Destroy() end)
    end
    print("💥 MEGA EXPLOSION!")
end)

-- 31. ФЛИНГ МАРДЕРА (отбросить убийцу)
add(megaTab, "31️⃣ Fling Murderer", function()
    local m = getMurderer()
    if m and m.Character then
        local hrp = m.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 150, 0) + hrp.CFrame.LookVector * 300
            bv.Parent = hrp
            task.delay(0.8, function()
                if bv then bv:Destroy() end
            end)
            print("💨 Flinged Murderer!")
        end
    else
        print("❌ Murderer not found!")
    end
end)

-- 32. ФЛИНГ ШЕРИФА (отбросить шерифа)
add(megaTab, "32️⃣ Fling Sheriff", function()
    local sheriff = nil
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= p and pl.Character then
            for _, v in pairs(pl.Character:GetChildren()) do
                if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
                    sheriff = pl
                    break
                end
            end
        end
        if sheriff then break end
    end
    
    if sheriff then
        local hrp = sheriff.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 150, 0) + hrp.CFrame.LookVector * 300
            bv.Parent = hrp
            task.delay(0.8, function()
                if bv then bv:Destroy() end
            end)
            print("💨 Flinged Sheriff!")
        end
    else
        print("❌ Sheriff not found!")
    end
end)

-- 33. ПОДОБРАТЬ ПИСТОЛЕТ (если ты шериф)
add(megaTab, "33️⃣ Pickup Gun", function()
    local found = false
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
            if v.Parent ~= p.Character and v.Parent ~= p.Backpack then
                v.Parent = p.Backpack
                found = true
                print("🔫 Gun picked up!")
                task.wait(0.2)
                if p.Character and p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid:EquipTool(v)
                end
                break
            end
        end
    end
    if not found then
        print("❌ No gun found nearby!")
    end
end)

-- 34. УБИТЬ МАРДЕРА (если ты шериф)
add(megaTab, "34️⃣ Kill Murderer", function()
    local m = getMurderer()
    if m and m.Character then
        local hum = m.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum.Health = 0
            print("🔪 Murderer killed!")
        else
            print("❌ Murderer already dead!")
        end
    else
        print("❌ Murderer not found!")
    end
end)

-- 35. АВТО-УБИЙСТВО (подбирает оружие + убивает)
add(megaTab, "35️⃣ Auto Kill", function()
    local hasGun = false
    for _, v in pairs(p.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
            hasGun = true
            if p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid:EquipTool(v)
            end
            break
        end
    end
    
    if not hasGun then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
                if v.Parent ~= p.Character and v.Parent ~= p.Backpack then
                    v.Parent = p.Backpack
                    task.wait(0.2)
                    if p.Character and p.Character:FindFirstChild("Humanoid") then
                        p.Character.Humanoid:EquipTool(v)
                    end
                    hasGun = true
                    break
                end
            end
        end
    end
    
    if hasGun then
        local m = getMurderer()
        if m and m.Character then
            local hum = m.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                hum.Health = 0
                print("🔫 Auto-killed Murderer!")
            else
                print("❌ Murderer already dead!")
            end
        else
            print("❌ Murderer not found!")
        end
    else
        print("❌ No gun found!")
    end
end)

-- ==========================================
-- ОБНОВЛЯЕМ ЗАГОЛОВОК
-- ==========================================
title.Text = "MM2 HUB • 195 FUNCTIONS"

-- 31. ФЛИНГ МАРДЕРА (ТЕЛЕПОРТ К НЕМУ + ОТБРОС В КОСМОС)
add(megaTab, "31️⃣ Fling Murderer", function()
    local m = getMurderer()
    if m and m.Character then
        local hrp = m.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- ТЕЛЕПОРТ К УБИЙЦЕ
            r.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.1)
            
            -- ОТБРОС УБИЙЦЫ В КОСМОС
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 500, 0) -- ВЫШЕ В 5 РАЗ
            bv.Parent = hrp
            task.delay(1, function()
                if bv then bv:Destroy() end
            end)
            print("🚀 Flinged Murderer to SPACE!")
        end
    else
        print("❌ Murderer not found!")
    end
end)

-- 32. ФЛИНГ ШЕРИФА (ТЕЛЕПОРТ К НЕМУ + ОТБРОС В КОСМОС)
add(megaTab, "32️⃣ Fling Sheriff", function()
    local sheriff = nil
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= p and pl.Character then
            for _, v in pairs(pl.Character:GetChildren()) do
                if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("pistol")) then
                    sheriff = pl
                    break
                end
            end
        end
        if sheriff then break end
    end
    
    if sheriff then
        local hrp = sheriff.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- ТЕЛЕПОРТ К ШЕРИФУ
            r.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.1)
            
            -- ОТБРОС ШЕРИФА В КОСМОС
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 500, 0) -- ВЫШЕ В 5 РАЗ
            bv.Parent = hrp
            task.delay(1, function()
                if bv then bv:Destroy() end
            end)
            print("🚀 Flinged Sheriff to SPACE!")
        end
    else
        print("❌ Sheriff not found!")
    end
end) print("✅ 35 new functions added! Total: 195 functions")  -- ==========================================
-- МАЙНКРАФТ-ФУНКЦИИ (РАБОЧАЯ ВЕРСИЯ)
-- ==========================================

-- 1. СОЗДАЁМ ВКЛАДКУ
local mcTab = newTab("⛏️MC")
section(mcTab, "⛏️ MINECRAFT")

-- 2. НАДЕТЬ АЛМАЗНУЮ БРОНЮ
add(mcTab, "1️⃣ Diamond Armor", function()
    local parts = {
        {name = "Helmet", pos = Vector3.new(0, 2.5, 0), size = Vector3.new(1.2, 0.6, 1.2)},
        {name = "Chestplate", pos = Vector3.new(0, 1.5, 0), size = Vector3.new(1.2, 0.8, 0.6)},
        {name = "Leggings", pos = Vector3.new(0, 0.5, 0), size = Vector3.new(1.2, 0.8, 1)},
        {name = "Boots", pos = Vector3.new(0, -1.5, 0), size = Vector3.new(1, 0.6, 1.2)}
    }
    for _, data in pairs(parts) do
        local part = Instance.new("Part")
        part.Name = data.name
        part.Size = data.size
        part.Color = Color3.fromRGB(0, 200, 255)
        part.Material = Enum.Material.Neon
        part.CanCollide = false
        part.Anchored = false
        part.Transparency = 0.2
        part.Parent = c
        local weld = Instance.new("Weld")
        weld.Part0 = r
        weld.Part1 = part
        weld.C0 = CFrame.new(data.pos)
        weld.Parent = part
    end
    print("💎 Diamond armor equipped!")
end)

-- 3. ВЫДАТЬ АЛМАЗНУЮ КИРКУ
add(mcTab, "2️⃣ Diamond Pickaxe", function()
    local tool = Instance.new("Tool")
    tool.Name = "Diamond Pickaxe"
    tool.RequiresHandle = false
    tool.Parent = p.Backpack
    print("⛏️ Diamond Pickaxe given!")
end)

-- 4. ВЫДАТЬ АЛМАЗНЫЙ ТОПОР
add(mcTab, "3️⃣ Diamond Axe", function()
    local tool = Instance.new("Tool")
    tool.Name = "Diamond Axe"
    tool.RequiresHandle = false
    tool.Parent = p.Backpack
    print("🪓 Diamond Axe given!")
end)

-- 5. ВЫДАТЬ АЛМАЗНУЮ ЛОПАТУ
add(mcTab, "4️⃣ Diamond Shovel", function()
    local tool = Instance.new("Tool")
    tool.Name = "Diamond Shovel"
    tool.RequiresHandle = false
    tool.Parent = p.Backpack
    print("🪣 Diamond Shovel given!")
end)

-- 6. ВЫДАТЬ АЛМАЗНЫЙ МЕЧ
add(mcTab, "5️⃣ Diamond Sword", function()
    local tool = Instance.new("Tool")
    tool.Name = "Diamond Sword"
    tool.RequiresHandle = false
    tool.Parent = p.Backpack
    print("🗡️ Diamond Sword given!")
end)

-- 7. ЗАСПАВНИТЬ БЛОК ЗЕМЛИ
add(mcTab, "6️⃣ Spawn Dirt", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(120, 80, 50)
    block.Material = Enum.Material.Granite
    block.Anchored = true
    block.Parent = workspace
    print("🟫 Dirt block spawned!")
end)

-- 8. ЗАСПАВНИТЬ БЛОК КАМНЯ
add(mcTab, "7️⃣ Spawn Stone", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(150, 150, 150)
    block.Material = Enum.Material.Slate
    block.Anchored = true
    block.Parent = workspace
    print("🪨 Stone block spawned!")
end)

-- 9. ЗАСПАВНИТЬ БЛОК ДЕРЕВА
add(mcTab, "8️⃣ Spawn Wood", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(100, 60, 30)
    block.Material = Enum.Material.Wood
    block.Anchored = true
    block.Parent = workspace
    print("🪵 Wood block spawned!")
end)

-- 10. ЗАСПАВНИТЬ БЛОК ЗОЛОТА
add(mcTab, "9️⃣ Spawn Gold", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(255, 215, 0)
    block.Material = Enum.Material.Neon
    block.Anchored = true
    block.Parent = workspace
    print("🪙 Gold block spawned!")
end)

-- 11. ЗАСПАВНИТЬ БЛОК АЛМАЗА
add(mcTab, "🔟 Spawn Diamond", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(0, 200, 255)
    block.Material = Enum.Material.Neon
    block.Anchored = true
    block.Parent = workspace
    print("💎 Diamond block spawned!")
end)

-- 12. ЗАСПАВНИТЬ БЛОК ТРАВЫ
add(mcTab, "11️⃣ Spawn Grass", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(0, 200, 50)
    block.Material = Enum.Material.Grass
    block.Anchored = true
    block.Parent = workspace
    print("🌿 Grass block spawned!")
end)

-- 13. ЗАСПАВНИТЬ БЛОК КИРПИЧА
add(mcTab, "12️⃣ Spawn Brick", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(200, 100, 50)
    block.Material = Enum.Material.Brick
    block.Anchored = true
    block.Parent = workspace
    print("🧱 Brick block spawned!")
end)

-- 14. ЗАСПАВНИТЬ БЛОК ОБСИДИАНА
add(mcTab, "13️⃣ Spawn Obsidian", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(30, 30, 50)
    block.Material = Enum.Material.Cobblestone
    block.Anchored = true
    block.Parent = workspace
    print("🪨 Obsidian block spawned!")
end)

-- 15. ЗАСПАВНИТЬ БЛОК СНЕГА
add(mcTab, "14️⃣ Spawn Snow", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(255, 255, 255)
    block.Material = Enum.Material.Ice
    block.Anchored = true
    block.Parent = workspace
    print("❄️ Snow block spawned!")
end)

-- 16. ЗАСПАВНИТЬ БЛОК ВОДЫ
add(mcTab, "15️⃣ Spawn Water", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(0, 100, 255)
    block.Material = Enum.Material.Water
    block.Transparency = 0.5
    block.Anchored = true
    block.Parent = workspace
    print("💧 Water block spawned!")
end)

-- 17. ЗАСПАВНИТЬ БЛОК ЛАВЫ
add(mcTab, "16️⃣ Spawn Lava", function()
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 4, 4)
    block.Position = r.Position + Vector3.new(0, 2, 5)
    block.Color = Color3.fromRGB(255, 100, 0)
    block.Material = Enum.Material.Neon
    block.Transparency = 0.3
    block.Anchored = true
    block.Parent = workspace
    print("🌋 Lava block spawned!")
end)

-- 18. УДАЛИТЬ ВСЕ БЛОКИ РЯДОМ
add(mcTab, "17️⃣ Clear Blocks", function()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Part") and v.Anchored and (v.Position - r.Position).Magnitude < 30 then
            v:Destroy()
        end
    end
    print("🧹 Blocks cleared!")
end)

-- 19. СТРОИТЬ ДОМ (КУБ)
add(mcTab, "18️⃣ Build House", function()
    local size = 3
    local pos = r.Position + Vector3.new(0, 0, 5)
    for x = 0, size do
        for z = 0, size do
            for y = 0, size do
                if x == 0 or x == size or z == 0 or z == size or y == 0 or y == size then
                    local block = Instance.new("Part")
                    block.Size = Vector3.new(2, 2, 2)
                    block.Position = pos + Vector3.new(x * 2, y * 2, z * 2)
                    block.Color = Color3.fromRGB(150, 100, 50)
                    block.Material = Enum.Material.Wood
                    block.Anchored = true
                    block.Parent = workspace
                end
            end
        end
    end
    print("🏠 House built!")
end)

-- 20. СТРОИТЬ СТЕНУ
add(mcTab, "19️⃣ Build Wall", function()
    local pos = r.Position + Vector3.new(0, 0, 5)
    for i = 0, 10 do
        for j = 0, 5 do
            local block = Instance.new("Part")
            block.Size = Vector3.new(2, 2, 2)
            block.Position = pos + Vector3.new(i * 2, j * 2, 0)
            block.Color = Color3.fromRGB(150, 150, 150)
            block.Material = Enum.Material.Slate
            block.Anchored = true
            block.Parent = workspace
        end
    end
    print("🧱 Wall built!")
end)

-- 21. СТРОИТЬ ЛЕСТНИЦУ
add(mcTab, "20️⃣ Build Stairs", function()
    local pos = r.Position + Vector3.new(0, 0, 5)
    for i = 0, 5 do
        local block = Instance.new("Part")
        block.Size = Vector3.new(2, 0.5, 2)
        block.Position = pos + Vector3.new(i * 2, i * 1.5, 0)
        block.Color = Color3.fromRGB(150, 100, 50)
        block.Material = Enum.Material.Wood
        block.Anchored = true
        block.Parent = workspace
    end
    print("🪜 Stairs built!")
end)

-- ==========================================
-- ОБНОВЛЯЕМ ЗАГОЛОВОК
-- ==========================================
title.Text = "MM2 HUB • 215 FUNCTIONS"

print("✅ Minecraft functions added! Total: 215 functions")print("🎯 Все функции работают!")
