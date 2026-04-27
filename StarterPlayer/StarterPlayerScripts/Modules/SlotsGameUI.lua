-- @ScriptType: ModuleScript
local SlotsGameUI = {}
local TweenService = game:GetService("TweenService")

local symbols = {"🍒", "🍋", "🍉", "🔔", "💎", "7️⃣"}

function SlotsGameUI.Init(parentFrame, playSlotsFunc, onBackCallback, updateLocalUI)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 1
	container.Parent = parentFrame

	local backBtn = Instance.new("TextButton")
	backBtn.Size = UDim2.new(0, 100, 0, 40)
	backBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
	backBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	backBtn.Text = "< Back"
	backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	backBtn.Font = Enum.Font.GothamBold
	backBtn.TextSize = 18
	backBtn.Parent = container

	local chipsDisplay = Instance.new("TextLabel")
	chipsDisplay.Size = UDim2.new(0.3, 0, 0.08, 0)
	chipsDisplay.Position = UDim2.new(0.65, 0, 0.02, 0)
	chipsDisplay.BackgroundTransparency = 1
	chipsDisplay.Text = "Chips: 0"
	chipsDisplay.TextColor3 = Color3.fromRGB(255, 215, 0)
	chipsDisplay.Font = Enum.Font.GothamBold
	chipsDisplay.TextScaled = true
	chipsDisplay.TextXAlignment = Enum.TextXAlignment.Right
	chipsDisplay.Parent = container

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0.15, 0)
	title.Position = UDim2.new(0, 0, 0.05, 0)
	title.BackgroundTransparency = 1
	title.Text = "HIGH STAKES SLOTS"
	title.TextColor3 = Color3.fromRGB(255, 215, 0)
	title.Font = Enum.Font.GothamBlack
	title.TextScaled = true
	title.Parent = container

	local machineBg = Instance.new("Frame")
	machineBg.Size = UDim2.new(0.6, 0, 0.4, 0)
	machineBg.Position = UDim2.new(0.2, 0, 0.25, 0)
	machineBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	machineBg.BorderSizePixel = 6
	machineBg.BorderColor3 = Color3.fromRGB(255, 215, 0)
	machineBg.ZIndex = 2
	machineBg.Parent = container

	local machineShadow = Instance.new("Frame")
	machineShadow.Size = UDim2.new(1.04, 0, 1.08, 0)
	machineShadow.Position = UDim2.new(-0.02, 0, 0, 0)
	machineShadow.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
	machineShadow.ZIndex = 1
	machineShadow.Parent = machineBg

	local leverHousing = Instance.new("Frame")
	leverHousing.Size = UDim2.new(0.08, 0, 0.4, 0)
	leverHousing.Position = UDim2.new(1, 0, 0.3, 0)
	leverHousing.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	leverHousing.BorderSizePixel = 2
	leverHousing.BorderColor3 = Color3.fromRGB(30, 30, 40)
	leverHousing.ZIndex = 1
	leverHousing.Parent = machineBg

	local leverBase = Instance.new("Frame")
	leverBase.Size = UDim2.new(0.4, 0, 0.8, 0)
	leverBase.Position = UDim2.new(0.5, 0, 0.5, 0)
	leverBase.AnchorPoint = Vector2.new(0.5, 0.5)
	leverBase.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	leverBase.ZIndex = 2
	leverBase.Parent = leverHousing

	local leverArm = Instance.new("Frame")
	leverArm.Size = UDim2.new(0.4, 0, 2.5, 0)
	leverArm.Position = UDim2.new(0.5, 0, 0.8, 0)
	leverArm.AnchorPoint = Vector2.new(0.5, 1)
	leverArm.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
	leverArm.BorderSizePixel = 1
	leverArm.ZIndex = 3
	leverArm.Parent = leverBase

	local leverKnob = Instance.new("TextButton")
	leverKnob.Size = UDim2.new(4, 0, 0.4, 0)
	leverKnob.Position = UDim2.new(0.5, 0, 0, 0)
	leverKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	leverKnob.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
	leverKnob.Text = ""
	leverKnob.ZIndex = 4
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = leverKnob
	leverKnob.Parent = leverArm

	local reels = {}
	for i = 1, 3 do
		local reelBg = Instance.new("Frame")
		reelBg.Size = UDim2.new(0.28, 0, 0.8, 0)
		reelBg.Position = UDim2.new(0.04 + ((i-1) * 0.32), 0, 0.1, 0)
		reelBg.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
		reelBg.ClipsDescendants = true
		reelBg.ZIndex = 3
		reelBg.Parent = machineBg

		local reelShadow = Instance.new("Frame")
		reelShadow.Size = UDim2.new(1, 0, 1, 0)
		reelShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		reelShadow.ZIndex = 6
		local grad = Instance.new("UIGradient")
		grad.Rotation = 90
		grad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(0.3, 1),
			NumberSequenceKeypoint.new(0.7, 1),
			NumberSequenceKeypoint.new(1, 0.2)
		})
		grad.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
		grad.Parent = reelShadow
		reelShadow.Parent = reelBg

		local strip = Instance.new("Frame")
		strip.Size = UDim2.new(1, 0, 2, 0)
		strip.Position = UDim2.new(0, 0, 0, 0)
		strip.BackgroundTransparency = 1
		strip.ZIndex = 4
		strip.Parent = reelBg

		local topSym = Instance.new("TextLabel")
		topSym.Size = UDim2.new(1, 0, 0.5, 0)
		topSym.Position = UDim2.new(0.5, 0, 0.25, 0)
		topSym.AnchorPoint = Vector2.new(0.5, 0.5)
		topSym.BackgroundTransparency = 1
		topSym.Text = symbols[1]
		topSym.TextColor3 = Color3.fromRGB(0, 0, 0)
		topSym.Font = Enum.Font.GothamBlack
		topSym.TextScaled = true
		topSym.ZIndex = 5
		topSym.Parent = strip

		local bottomSym = topSym:Clone()
		bottomSym.Position = UDim2.new(0.5, 0, 0.75, 0)
		bottomSym.Parent = strip

		reels[i] = {bg = reelBg, strip = strip, topSym = topSym, bottomSym = bottomSym}
	end

	local legend = Instance.new("TextLabel")
	legend.Size = UDim2.new(0.9, 0, 0.04, 0)
	legend.Position = UDim2.new(0.05, 0, 0.67, 0)
	legend.BackgroundTransparency = 1
	legend.Text = "PAYTABLE: 🍒 15/5 | 🍋 30/10 | 🍉 60/20 | 🔔 100/35 | 💎 250/75 | 7️⃣ 1000/150"
	legend.TextColor3 = Color3.fromRGB(220, 220, 220)
	legend.Font = Enum.Font.GothamBold
	legend.TextScaled = true
	legend.Parent = container

	local resultText = Instance.new("TextLabel")
	resultText.Size = UDim2.new(1, 0, 0.08, 0)
	resultText.Position = UDim2.new(0, 0, 0.72, 0)
	resultText.BackgroundTransparency = 1
	resultText.Text = ""
	resultText.TextColor3 = Color3.fromRGB(255, 255, 255)
	resultText.Font = Enum.Font.GothamBold
	resultText.TextScaled = true
	resultText.Parent = container

	local spinBtn = Instance.new("TextButton")
	spinBtn.Size = UDim2.new(0.4, 0, 0.15, 0)
	spinBtn.Position = UDim2.new(0.3, 0, 0.82, 0)
	spinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	spinBtn.Text = "PULL LEVER OR SPIN (10 Chips)"
	spinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	spinBtn.Font = Enum.Font.GothamBlack
	spinBtn.TextScaled = true
	spinBtn.Parent = container

	local winBanner = Instance.new("TextLabel")
	winBanner.Size = UDim2.new(0, 0, 0, 0)
	winBanner.Position = UDim2.new(0.5, 0, 0.45, 0)
	winBanner.AnchorPoint = Vector2.new(0.5, 0.5)
	winBanner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	winBanner.BackgroundTransparency = 0.2
	winBanner.Font = Enum.Font.GothamBlack
	winBanner.TextColor3 = Color3.fromRGB(255, 215, 0)
	winBanner.TextScaled = true
	winBanner.ZIndex = 100
	winBanner.Visible = false
	local bannerCorner = Instance.new("UICorner")
	bannerCorner.CornerRadius = UDim.new(0, 15)
	bannerCorner.Parent = winBanner
	winBanner.Parent = container

	local isSpinning = false
	local spinningReels = {false, false, false}
	local finishedSpinning = {false, false, false}
	local finalSymbols = {"", "", ""}
	local activeEffects = {}

	local function clearEffects()
		for _, effect in ipairs(activeEffects) do
			if effect and effect.Parent then
				effect:Destroy()
			end
		end
		activeEffects = {}
		winBanner.Visible = false
		winBanner.Size = UDim2.new(0, 0, 0, 0)
		machineBg.BorderColor3 = Color3.fromRGB(255, 215, 0)
		for i = 1, 3 do
			reels[i].topSym.Size = UDim2.new(1, 0, 0.5, 0)
		end
	end

	local function popReel(reelLabel)
		local ti = TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, 0, true)
		local tween = TweenService:Create(reelLabel, ti, {Size = UDim2.new(1.3, 0, 0.65, 0)})
		tween:Play()
	end

	local function triggerMatchEffect(indices, isJackpot)
		for _, idx in ipairs(indices) do
			local glow = Instance.new("Frame")
			glow.Size = UDim2.new(1, 0, 1, 0)
			glow.Position = UDim2.new(0, 0, 0, 0)
			glow.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
			glow.BackgroundTransparency = 0.3
			glow.BorderSizePixel = 0
			glow.ZIndex = 5
			glow.Parent = reels[idx].bg
			table.insert(activeEffects, glow)

			local glowTween = TweenService:Create(glow, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.8})
			glowTween:Play()

			local popTween = TweenService:Create(reels[idx].topSym, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, 2, true), {Size = UDim2.new(1.4, 0, 0.7, 0)})
			popTween:Play()
		end

		winBanner.Text = isJackpot and "JACKPOT!" or "BIG WIN!"
		winBanner.Visible = true
		local bannerIn = TweenService:Create(winBanner, TweenInfo.new(0.6, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = UDim2.new(0.7, 0, 0.25, 0)})
		bannerIn:Play()

		local coinAmount = isJackpot and 60 or 25
		task.spawn(function()
			for i = 1, coinAmount do
				if not winBanner.Visible then break end
				local coin = Instance.new("TextLabel")
				coin.Text = (math.random(1, 2) == 1) and "💎" or "💰"
				coin.BackgroundTransparency = 1
				coin.TextScaled = true
				coin.Size = UDim2.new(0.08, 0, 0.08, 0)
				coin.Position = UDim2.new(0.5, 0, 0.45, 0)
				coin.AnchorPoint = Vector2.new(0.5, 0.5)
				coin.ZIndex = 50
				coin.Parent = container
				table.insert(activeEffects, coin)

				local targetX = math.random(-30, 130) / 100
				local targetY = math.random(-30, 130) / 100

				local t = TweenService:Create(coin, TweenInfo.new(math.random(15, 30)/10, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(targetX, 0, targetY, 0),
					Rotation = math.random(-360, 360)
				})
				t:Play()

				task.spawn(function()
					t.Completed:Wait()
					local fade = TweenService:Create(coin, TweenInfo.new(0.3), {TextTransparency = 1})
					fade:Play()
					fade.Completed:Wait()
					if coin and coin.Parent then
						coin:Destroy()
					end
				end)

				task.wait(0.02)
			end
		end)

		task.spawn(function()
			for i = 1, 30 do
				if not winBanner.Visible then break end
				machineBg.BorderColor3 = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
				task.wait(0.1)
			end
			machineBg.BorderColor3 = Color3.fromRGB(255, 215, 0)
		end)
	end

	local function spinReelAnim(i)
		local reel = reels[i]
		task.spawn(function()
			while spinningReels[i] do
				reel.bottomSym.Text = reel.topSym.Text
				reel.topSym.Text = symbols[math.random(1, #symbols)]

				reel.strip.Position = UDim2.new(0, 0, -1, 0)
				local tween = TweenService:Create(reel.strip, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {Position = UDim2.new(0, 0, 0, 0)})
				tween:Play()
				tween.Completed:Wait()
			end

			reel.bottomSym.Text = reel.topSym.Text
			reel.topSym.Text = finalSymbols[i]

			reel.strip.Position = UDim2.new(0, 0, -1, 0)
			local finalTween = TweenService:Create(reel.strip, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
			finalTween:Play()
			finalTween.Completed:Wait()

			finishedSpinning[i] = true
		end)
	end

	local function doSpin()
		if isSpinning then return end
		isSpinning = true
		spinBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		leverKnob.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
		resultText.Text = ""

		clearEffects()

		task.spawn(function()
			local pullDown = TweenService:Create(leverArm, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0.4, 0, 0.5, 0)})
			pullDown:Play()
			pullDown.Completed:Wait()
			local pullUp = TweenService:Create(leverArm, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = UDim2.new(0.4, 0, 2.5, 0)})
			pullUp:Play()
		end)

		spinningReels = {true, true, true}
		finishedSpinning = {false, false, false}
		spinReelAnim(1)
		spinReelAnim(2)
		spinReelAnim(3)

		local result = playSlotsFunc:InvokeServer()

		if result.Success then
			task.wait(0.5)

			for i = 1, 3 do
				finalSymbols[i] = result.Reels[i]
				spinningReels[i] = false

				while not finishedSpinning[i] do
					task.wait(0.05)
				end

				popReel(reels[i].topSym)

				if i < 3 then
					local waitTime = (i == 2) and 0.4 or 0.2
					task.wait(waitTime)
				end
			end

			isSpinning = false

			if result.Won then
				resultText.Text = "WIN: +" .. tostring(result.Amount) .. " CHIPS!"
				resultText.TextColor3 = Color3.fromRGB(50, 255, 50)
				machineBg.BorderColor3 = Color3.fromRGB(50, 255, 50)

				local matchedIndices = {}
				local isJackpot = false

				if result.Reels[1] == result.Reels[2] and result.Reels[2] == result.Reels[3] then
					matchedIndices = {1, 2, 3}
					if result.Reels[1] == "7️⃣" then
						isJackpot = true
					end
				elseif result.Reels[1] == result.Reels[2] then
					matchedIndices = {1, 2}
				elseif result.Reels[2] == result.Reels[3] then
					matchedIndices = {2, 3}
				elseif result.Reels[1] == result.Reels[3] then
					matchedIndices = {1, 3}
				end

				triggerMatchEffect(matchedIndices, isJackpot)
			else
				resultText.Text = "LOSS!"
				resultText.TextColor3 = Color3.fromRGB(255, 50, 50)
			end

			updateLocalUI(result.FinalData)
		else
			spinningReels = {false, false, false}
			isSpinning = false
			resultText.Text = result.Reason or "Error"
			resultText.TextColor3 = Color3.fromRGB(255, 50, 50)
		end

		spinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		leverKnob.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
	end

	backBtn.MouseButton1Click:Connect(function()
		if not isSpinning then
			clearEffects()
			onBackCallback()
		end
	end)

	spinBtn.MouseButton1Click:Connect(doSpin)
	leverKnob.MouseButton1Click:Connect(doSpin)

	return {
		UpdateChips = function(amount)
			chipsDisplay.Text = "Chips: " .. tostring(amount)
		end
	}
end

return SlotsGameUI