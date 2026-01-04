--==================================================
-- JUND×CODEX | Fish It
--==================================================

local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local Player = Players.LocalPlayer

--================ KEY =================
local FREE_KEY = "FREE_a1c1fffa1377a74e03a2a74a54c99663"
local PREMIUM_KEY = "PREMIUM_a1c1fffa1377a74e03a2a74a54c99663"

--================ TELEGRAM =================
local BOT_TOKEN = "7910084721:AAGsf-k5ZrE7Q3ty5EN08FUJkWqwde3IMCY"
local CHAT_ID = "-1001234567890"
local TELE_LINK = "https://t.me/+8LsulneQ-zdjNDc1"

--================ STATE =================
local AutoTap = false
local AutoJump = false
local TapDelay = 0.3

--================ CLEAN =================
pcall(function() game.CoreGui.JUND_KEY:Destroy() end)
pcall(function() game.CoreGui.JUND_MENU:Destroy() end)

--================ TELE SEND =================
local function SendToTelegram(keyUsed)
	local country = "Unknown"
	pcall(function()
		country = LocalizationService:GetCountryRegionForPlayerAsync(Player)
	end)

	local msg =
		"🔓 JUND×CODEX UNLOCK\n\n"..
		"👤 User : "..Player.Name.."\n"..
		"🆔 ID : "..Player.UserId.."\n"..
		"🌍 Country : "..country.."\n"..
		"📅 Account Age : "..Player.AccountAge.." days\n"..
		"🔑 Key : "..keyUsed

	pcall(function()
		HttpService:PostAsync(
			"https://api.telegram.org/bot"..BOT_TOKEN.."/sendMessage",
			HttpService:JSONEncode({
				chat_id = CHAT_ID,
				text = msg
			}),
			Enum.HttpContentType.ApplicationJson
		)
	end)
end

--================ KEY GUI =================
local KeyGui = Instance.new("ScreenGui", game.CoreGui)
KeyGui.Name = "JUND_KEY"

local KF = Instance.new("Frame", KeyGui)
KF.Size = UDim2.fromOffset(320,190)
KF.Position = UDim2.fromScale(0.5,0.5)
KF.AnchorPoint = Vector2.new(0.5,0.5)
KF.BackgroundColor3 = Color3.fromRGB(25,25,25)
KF.Active = true
KF.Draggable = true
Instance.new("UICorner", KF)

local KT = Instance.new("TextLabel", KF)
KT.Size = UDim2.new(1,0,0,30)
KT.Text = "JUND×CODEX KEY SYSTEM"
KT.TextColor3 = Color3.new(1,1,1)
KT.BackgroundTransparency = 1
KT.TextScaled = true

local KB = Instance.new("TextBox", KF)
KB.Size = UDim2.new(1,-40,0,34)
KB.Position = UDim2.fromOffset(20,42)
KB.PlaceholderText = "Masukkan Key"
KB.BackgroundColor3 = Color3.fromRGB(45,45,45)
KB.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KB)

local function KeyBtn(txt,x,color)
	local b = Instance.new("TextButton", KF)
	b.Size = UDim2.new(0.45,0,0,34)
	b.Position = UDim2.fromScale(x,0.72)
	b.Text = txt
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.new(1,1,1)
	b.Active = true
	Instance.new("UICorner", b)
	return b
end

local GetKey = KeyBtn("GET KEY",0.05,Color3.fromRGB(0,120,255))
local Unlock = KeyBtn("UNLOCK",0.5,Color3.fromRGB(0,200,120))

GetKey.MouseButton1Click:Connect(function()
	setclipboard(TELE_LINK)
	KB.PlaceholderText = "Link Telegram dicopy"
end)

--================ MENU (LOCKED) =================
local MenuGui = Instance.new("ScreenGui", game.CoreGui)
MenuGui.Name = "JUND_MENU"
MenuGui.Enabled = false

local Ball = Instance.new("TextButton", MenuGui)
Ball.Size = UDim2.fromOffset(44,44)
Ball.Position = UDim2.fromScale(0.05,0.5)
Ball.Text = "JX"
Ball.BackgroundColor3 = Color3.fromRGB(60,60,60)
Ball.TextColor3 = Color3.new(1,1,1)
Ball.Visible = false
Ball.Active = true
Ball.Draggable = true
Instance.new("UICorner", Ball)

local Main = Instance.new("Frame", MenuGui)
Main.Size = UDim2.fromOffset(480,290)
Main.Position = UDim2.fromScale(0.32,0.3)
Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

Ball.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,28)
Title.Text = "JUND×CODEX"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.TextScaled = true

-- CLOSE
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(22,22)
Close.Position = UDim2.fromScale(0.95,0.05)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,0,0)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

--================ TABS =================
local Tabs = {"Fishing","Teleport","Credit"}
local Pages = {}
local Buttons = {}

for i,v in ipairs(Tabs) do
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.fromOffset(100,28)
	b.Position = UDim2.fromOffset(10,38+(i-1)*32)
	b.Text = v
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	Buttons[v] = b

	local p = Instance.new("Frame", Main)
	p.Size = UDim2.fromOffset(340,230)
	p.Position = UDim2.fromOffset(130,40)
	p.BackgroundTransparency = 1
	p.Visible = false
	Pages[v] = p
end

local function OpenTab(n)
	for _,p in pairs(Pages) do p.Visible = false end
	Pages[n].Visible = true
end
for k,b in pairs(Buttons) do
	b.MouseButton1Click:Connect(function()
		OpenTab(k)
	end)
end
OpenTab("Fishing")

--================ FISHING =================
local F = Pages.Fishing

local function Toggle(text,y)
	local b = Instance.new("TextButton", F)
	b.Size = UDim2.new(1,0,0,30)
	b.Position = UDim2.fromOffset(0,y)
	b.Text = text.." : OFF"
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local AT = Toggle("Auto Tap",0)
AT.MouseButton1Click:Connect(function()
	AutoTap = not AutoTap
	AT.Text = "Auto Tap : "..(AutoTap and "ON" or "OFF")
end)

local AJ = Toggle("Auto Jump",40)
AJ.MouseButton1Click:Connect(function()
	AutoJump = not AutoJump
	AJ.Text = "Auto Jump : "..(AutoJump and "ON" or "OFF")
end)

local DB = Instance.new("TextBox", F)
DB.Size = UDim2.new(1,0,0,30)
DB.Position = UDim2.fromOffset(0,80)
DB.Text = tostring(TapDelay)
DB.PlaceholderText = "Delay 0.00 - 5"
DB.BackgroundColor3 = Color3.fromRGB(50,50,50)
DB.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", DB)

DB.FocusLost:Connect(function()
	local v = tonumber(DB.Text)
	if v and v >= 0 and v <= 5 then
		TapDelay = v
	end
end)

--================ TELEPORT (SCROLL FIX) =================
local TP = Pages.Teleport
local SF = Instance.new("ScrollingFrame", TP)
SF.Size = UDim2.new(1,0,1,0)
SF.ScrollBarThickness = 6
SF.AutomaticCanvasSize = Enum.AutomaticSize.Y
SF.BackgroundTransparency = 1
Instance.new("UIListLayout", SF)

local function Refresh()
	for _,c in ipairs(SF:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			local b = Instance.new("TextButton", SF)
			b.Size = UDim2.new(1,0,0,28)
			b.Text = plr.Name
			b.BackgroundColor3 = Color3.fromRGB(50,50,50)
			b.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", b)
			b.MouseButton1Click:Connect(function()
				if Player.Character and plr.Character then
					Player.Character:MoveTo(plr.Character.HumanoidRootPart.Position)
				end
			end)
		end
	end
end
Players.PlayerAdded:Connect(Refresh)
Players.PlayerRemoving:Connect(Refresh)
Refresh()

--================ CREDIT =================
local C = Pages.Credit
local CL = Instance.new("TextLabel", C)
CL.Size = UDim2.new(1,0,1,0)
CL.Text = "JUND × CODEX\nVIRGO SUKA ES\nJUNZ HECKEL"
CL.TextColor3 = Color3.new(1,1,1)
CL.BackgroundTransparency = 1
CL.TextScaled = true

--================ LOOPS =================
task.spawn(function()
	while task.wait(0.05) do
		if AutoTap then
			local s = workspace.CurrentCamera.ViewportSize
			VIM:SendMouseButtonEvent(s.X/2,s.Y/2,0,true,game,0)
			VIM:SendMouseButtonEvent(s.X/2,s.Y/2,0,false,game,0)
		end
	end
end)

task.spawn(function()
	while task.wait(0.2) do
		if AutoJump and Player.Character then
			local h = Player.Character:FindFirstChildOfClass("Humanoid")
			if h and h.FloorMaterial ~= Enum.Material.Air then
				h:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

--================ UNLOCK =================
Unlock.MouseButton1Click:Connect(function()
	if KB.Text ~= FREE_KEY and KB.Text ~= PREMIUM_KEY then
		KB.Text = ""
		KB.PlaceholderText = "KEY SALAH"
		return
	end

	SendToTelegram(KB.Text)

	KeyGui:Destroy()
	MenuGui.Enabled = true
	Ball.Visible = true
end)
