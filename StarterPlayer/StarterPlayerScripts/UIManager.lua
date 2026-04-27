-- @ScriptType: LocalScript
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts")
local modules = playerScripts:WaitForChild("Modules")

local GamesUI = require(modules:WaitForChild("GamesUI"))
local StatsUI = require(modules:WaitForChild("StatsUI"))
local SlotsGameUI = require(modules:WaitForChild("SlotsGameUI"))

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CasinoMainUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
topBar.ZIndex = 10

local topBarPadding = Instance.new("UIPadding")
topBarPadding.PaddingLeft = UDim.new(0, 60)
topBarPadding.Parent = topBar

local chipsLabel = Instance.new("TextLabel")
chipsLabel.Name = "ChipsLabel"
chipsLabel.Size = UDim2.new(0.3, 0, 1, 0)
chipsLabel.Position = UDim2.new(0.65, 0, 0, 0)
chipsLabel.BackgroundTransparency = 1
chipsLabel.Text = "Chips: 0"
chipsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
chipsLabel.TextScaled = true
chipsLabel.Font = Enum.Font.GothamBold
chipsLabel.TextXAlignment = Enum.TextXAlignment.Right
chipsLabel.Parent = topBar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local navBar = Instance.new("Frame")
navBar.Name = "NavBar"
navBar.Size = UDim2.new(0.2, 0, 1, 0)
navBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
navBar.BorderSizePixel = 0
navBar.Parent = contentFrame

local viewsFrame = Instance.new("Frame")
viewsFrame.Name = "ViewsFrame"
viewsFrame.Size = UDim2.new(0.75, 0, 0.9, 0)
viewsFrame.Position = UDim2.new(0.225, 0, 0.05, 0)
viewsFrame.BackgroundTransparency = 1
viewsFrame.Parent = contentFrame

local activeGameFrame = Instance.new("Frame")
activeGameFrame.Name = "ActiveGameFrame"
activeGameFrame.Size = UDim2.new(1, 0, 1, -50)
activeGameFrame.Position = UDim2.new(0, 0, 0, 50)
activeGameFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
activeGameFrame.Visible = false
activeGameFrame.Parent = mainFrame

local uilistLayout = Instance.new("UIListLayout")
uilistLayout.Parent = navBar
uilistLayout.SortOrder = Enum.SortOrder.LayoutOrder
uilistLayout.Padding = UDim.new(0, 5)

local views = {}

local function createView(name)
	local view = Instance.new("Frame")
	view.Name = name .. "View"
	view.Size = UDim2.new(1, 0, 1, 0)
	view.BackgroundTransparency = 1
	view.Visible = false
	view.Parent = viewsFrame
	views[name] = view
	return view
end

local function createNavButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name .. "Button"
	btn.Size = UDim2.new(1, 0, 0, 50)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 18
	btn.LayoutOrder = order
	btn.Parent = navBar

	createView(name)

	btn.MouseButton1Click:Connect(function()
		for viewName, viewFrame in pairs(views) do
			viewFrame.Visible = (viewName == name)
		end
	end)
end

createNavButton("Games", 1)
createNavButton("Stats", 2)
createNavButton("Passive", 3)

if views["Games"] then
	views["Games"].Visible = true
end

local gameButtons = GamesUI.Init(views["Games"])
local statLabels = StatsUI.Init(views["Stats"])

local remotes = ReplicatedStorage:WaitForChild("CasinoRemotes")
local updateUIEvent = remotes:WaitForChild("UpdateUI")
local playSlotsFunc = remotes:WaitForChild("PlaySlots")

local updateLocalUI
local slotsUIController

updateLocalUI = function(data)
	chipsLabel.Text = "Chips: " .. tostring(data.Chips)
	StatsUI.Update(statLabels, data.Stats)
	if slotsUIController then
		slotsUIController.UpdateChips(data.Chips)
	end
end

slotsUIController = SlotsGameUI.Init(activeGameFrame, playSlotsFunc, function()
	activeGameFrame.Visible = false
	contentFrame.Visible = true
end, updateLocalUI)

if gameButtons.Slots then
	gameButtons.Slots.MouseButton1Click:Connect(function()
		contentFrame.Visible = false
		activeGameFrame.Visible = true
	end)
end

updateUIEvent.OnClientEvent:Connect(updateLocalUI)