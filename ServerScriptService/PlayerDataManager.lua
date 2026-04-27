-- @ScriptType: Script
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = Instance.new("Folder")
remotes.Name = "CasinoRemotes"
remotes.Parent = ReplicatedStorage

local updateUIEvent = Instance.new("RemoteEvent")
updateUIEvent.Name = "UpdateUI"
updateUIEvent.Parent = remotes

local requestPlayEvent = Instance.new("RemoteEvent")
requestPlayEvent.Name = "RequestPlay"
requestPlayEvent.Parent = remotes

local playSlotsFunc = Instance.new("RemoteFunction")
playSlotsFunc.Name = "PlaySlots"
playSlotsFunc.Parent = remotes

local playerData = {}

-- Fixed payout scaling: higher tier = strictly better payouts
local slotSymbols = {
	{symbol = "🍒", weight = 50, match3 = 15,  match2 = 5},
	{symbol = "🍋", weight = 25, match3 = 30,  match2 = 10},
	{symbol = "🍉", weight = 12, match3 = 60,  match2 = 20},
	{symbol = "🔔", weight = 8,  match3 = 100, match2 = 35},
	{symbol = "💎", weight = 4,  match3 = 250, match2 = 75},
	{symbol = "7️⃣", weight = 1,  match3 = 1000, match2 = 150}
}

local totalWeight = 0
for _, v in ipairs(slotSymbols) do
	totalWeight = totalWeight + v.weight
end

local function getWeightedSymbol()
	local rng = math.random(1, totalWeight)
	local current = 0
	for _, v in ipairs(slotSymbols) do
		current = current + v.weight
		if rng <= current then
			return v.symbol
		end
	end
	return "🍒"
end

local function initializePlayer(player)
	playerData[player.UserId] = {
		Chips = 100,
		Stats = {
			Luck = 1,
			Intelligence = 1,
			Nerve = 1,
			Reputation = 1
		}
	}
	updateUIEvent:FireClient(player, playerData[player.UserId])
end

Players.PlayerAdded:Connect(initializePlayer)

Players.PlayerRemoving:Connect(function(player)
	playerData[player.UserId] = nil
end)

playSlotsFunc.OnServerInvoke = function(player)
	local data = playerData[player.UserId]
	if data and data.Chips >= 10 then
		data.Chips = data.Chips - 10

		updateUIEvent:FireClient(player, data)

		local resultReels = {getWeightedSymbol(), getWeightedSymbol(), getWeightedSymbol()}
		local won = false
		local winAmount = 0

		-- Check if we have a natural Match 3
		local hasMatch3 = (resultReels[1] == resultReels[2] and resultReels[2] == resultReels[3])

		-- Generous Rigging Mechanic: If we didn't naturally hit a Match 3, give a high chance to force it
		if not hasMatch3 then
			-- 15% base chance + (5% per Luck level) to force a win
			local forceWinChance = 15 + (data.Stats.Luck * 5) 

			if math.random(1, 100) <= forceWinChance then
				resultReels[2] = resultReels[1]
				resultReels[3] = resultReels[1]
			end
		end

		-- Recalculate symbol counts after potential rigging
		local symbolCounts = {}
		for i = 1, 3 do
			local sym = resultReels[i]
			if symbolCounts[sym] then
				symbolCounts[sym] = symbolCounts[sym] + 1
			else
				symbolCounts[sym] = 1
			end
		end

		-- Distribute payouts based on final reels
		for _, v in ipairs(slotSymbols) do
			if symbolCounts[v.symbol] == 3 then
				won = true
				winAmount = v.match3
				break
			elseif symbolCounts[v.symbol] == 2 then
				won = true
				winAmount = v.match2
				break
			end
		end

		if won then
			data.Chips = data.Chips + winAmount
		end

		task.wait(0.1) 

		return {Success = true, Won = won, Amount = winAmount, Reels = resultReels, FinalData = data}
	else
		return {Success = false, Reason = "Not enough chips"}
	end
end