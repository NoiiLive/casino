-- @ScriptType: ModuleScript
local StatsUI = {}

function StatsUI.Init(parentFrame)
	local uilistLayout = Instance.new("UIListLayout")
	uilistLayout.Padding = UDim.new(0, 10)
	uilistLayout.Parent = parentFrame

	local function createStatRow(statName)
		local row = Instance.new("Frame")
		row.Name = statName .. "Row"
		row.Size = UDim2.new(1, 0, 0, 40)
		row.BackgroundTransparency = 1

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = statName
		nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.TextSize = 20
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = row

		local valLabel = Instance.new("TextLabel")
		valLabel.Name = "ValueLabel"
		valLabel.Size = UDim2.new(0.5, 0, 1, 0)
		valLabel.Position = UDim2.new(0.5, 0, 0, 0)
		valLabel.BackgroundTransparency = 1
		valLabel.Text = "1"
		valLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		valLabel.Font = Enum.Font.GothamBold
		valLabel.TextSize = 20
		valLabel.TextXAlignment = Enum.TextXAlignment.Right
		valLabel.Parent = row

		row.Parent = parentFrame
		return valLabel
	end

	local statLabels = {}
	statLabels.Luck = createStatRow("Luck")
	statLabels.Intelligence = createStatRow("Intelligence")
	statLabels.Nerve = createStatRow("Nerve")
	statLabels.Reputation = createStatRow("Reputation")

	return statLabels
end

function StatsUI.Update(statLabels, statsData)
	if statsData then
		if statsData.Luck then statLabels.Luck.Text = tostring(statsData.Luck) end
		if statsData.Intelligence then statLabels.Intelligence.Text = tostring(statsData.Intelligence) end
		if statsData.Nerve then statLabels.Nerve.Text = tostring(statsData.Nerve) end
		if statsData.Reputation then statLabels.Reputation.Text = tostring(statsData.Reputation) end
	end
end

return StatsUI