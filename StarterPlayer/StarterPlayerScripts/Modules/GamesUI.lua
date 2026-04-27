-- @ScriptType: ModuleScript
local GamesUI = {}

function GamesUI.Init(parentFrame)
	local uigridLayout = Instance.new("UIGridLayout")
	uigridLayout.CellSize = UDim2.new(0.3, 0, 0.4, 0)
	uigridLayout.CellPadding = UDim2.new(0.03, 0, 0.03, 0)
	uigridLayout.Parent = parentFrame

	local buttons = {}

	local function createGameCard(name)
		local card = Instance.new("Frame")
		card.Name = name .. "Card"
		card.BackgroundColor3 = Color3.fromRGB(35, 35, 40)

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, 0, 0.4, 0)
		title.BackgroundTransparency = 1
		title.Text = name
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.Font = Enum.Font.GothamBold
		title.TextScaled = true
		title.Parent = card

		local playBtn = Instance.new("TextButton")
		playBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
		playBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
		playBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		playBtn.Text = "Open Game"
		playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		playBtn.Font = Enum.Font.GothamBold
		playBtn.TextScaled = true
		playBtn.Parent = card

		card.Parent = parentFrame
		buttons[name] = playBtn
	end

	createGameCard("Slots")
	createGameCard("Blackjack")
	createGameCard("Poker")
	createGameCard("Roulette")

	return buttons
end

return GamesUI