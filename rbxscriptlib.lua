-- rbxscriptlib: A futuristic, developer-friendly Roblox UI library
-- Inspired by OrionLib, with a modern left-side navigation layout


local rbxscriptlib = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Library state
local library = {
	Windows = {},
	ActiveWindow = nil,
	Theme = {
		PrimaryColor = Color3.fromRGB(10, 25, 47), -- Dark blue for sci-fi aesthetic
		AccentColor = Color3.fromRGB(0, 255, 255), -- Cyan for glowing highlights
		BackgroundColor = Color3.fromRGB(20, 20, 30),
		TextColor = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSansPro,
		FontSize = 16,
	},
	Animations = {
		OpenTween = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		HoverTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
	},
	Registry = {}, -- Tracks all UI elements for debugging
	IsLocked = false,
	KeySystemEnabled = false,
	Key = nil,
}

-- Utility functions
local function createInstance(className, properties)
	local instance = Instance.new(className)
	for prop, value in pairs(properties or {}) do
		instance[prop] = value
	end
	return instance
end

local function applyGlow(element, color)
	local glow = createInstance("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, color),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
		}),
		Rotation = 45,
		Parent = element,
	})
end

-- Window creation
function rbxscriptlib:CreateWindow(name)
	local window = {
		Name = name,
		Tabs = {},
		ScreenGui = createInstance("ScreenGui", {
			Name = name .. "_ScreenGui",
			Parent = Players.LocalPlayer.PlayerGui,
			ResetOnSpawn = false,
		}),
		MainFrame = nil,
		NavFrame = nil,
		ContentFrame = nil,
		Notifications = {},
	}

	-- Main frame with futuristic styling
	window.MainFrame = createInstance("Frame", {
		Name = "MainFrame",
		Size = UDim2.new(0, 600, 0, 400),
		Position = UDim2.new(0.5, -300, 0.5, -200),
		BackgroundColor3 = library.Theme.BackgroundColor,
		BorderSizePixel = 0,
		Parent = window.ScreenGui,
	})
	window.MainFrame.ClipsDescendants = true
	createInstance("UICorner", { CornerRadius = UDim.new(0, 8), Parent = window.MainFrame })
	applyGlow(window.MainFrame, library.Theme.AccentColor)

	-- Navigation panel (left side)
	window.NavFrame = createInstance("Frame", {
		Name = "NavFrame",
		Size = UDim2.new(0, 150, 1, 0),
		BackgroundColor3 = library.Theme.PrimaryColor,
		BorderSizePixel = 0,
		Parent = window.MainFrame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 8), Parent = window.NavFrame })
	createInstance("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = window.NavFrame,
	})

	-- Content frame (right side)
	window.ContentFrame = createInstance("Frame", {
		Name = "ContentFrame",
		Size = UDim2.new(1, -150, 1, 0),
		Position = UDim2.new(0, 150, 0, 0),
		BackgroundTransparency = 1,
		Parent = window.MainFrame,
	})
	createInstance("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
		Parent = window.ContentFrame,
	})

	-- Store window
	library.Windows[name] = window
	library.ActiveWindow = window
	library.Registry[name] = { Type = "Window", Instance = window.MainFrame }

	return window
end

-- Tab creation
function rbxscriptlib:CreateTab(window, name)
	local tab = {
		Name = name,
		Sections = {},
		NavButton = nil,
		ContentFrame = nil,
	}

	-- Navigation button
	tab.NavButton = createInstance("TextButton", {
		Name = name .. "_Button",
		Size = UDim2.new(1, -10, 0, 40),
		Position = UDim2.new(0, 5, 0, 0),
		BackgroundColor3 = library.Theme.PrimaryColor,
		Text = name,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		Parent = window.NavFrame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tab.NavButton })
	applyGlow(tab.NavButton, library.Theme.AccentColor)

	-- Content frame for tab
	tab.ContentFrame = createInstance("Frame", {
		Name = name .. "_Content",
		Size = UDim2.new(1, -10, 1, -10),
		Position = UDim2.new(0, 5, 0, 5),
		BackgroundTransparency = 1,
		Parent = window.ContentFrame,
		Visible = false,
	})
	createInstance("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
		Parent = tab.ContentFrame,
	})

	-- Tab switching
	tab.NavButton.MouseButton1Click:Connect(function()
		for _, t in pairs(window.Tabs) do
			t.ContentFrame.Visible = false
			t.NavButton.BackgroundColor3 = library.Theme.PrimaryColor
		end
		tab.ContentFrame.Visible = true
		TweenService:Create(
			tab.NavButton,
			library.Animations.OpenTween,
			{ BackgroundColor3 = library.Theme.AccentColor }
		):Play()
	end)

	-- Store tab
	window.Tabs[name] = tab
	library.Registry[name .. "_Tab"] = { Type = "Tab", Instance = tab.ContentFrame }

	return tab
end

-- Section creation
function rbxscriptlib:CreateSection(tab, name)
	local section = {
		Name = name,
		Frame = createInstance("Frame", {
			Name = name .. "_Section",
			Size = UDim2.new(1, -10, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = library.Theme.BackgroundColor,
			BorderSizePixel = 0,
			Parent = tab.ContentFrame,
		}),
		Elements = {},
	}
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = section.Frame })
	createInstance("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = section.Frame,
	})
	createInstance("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		Parent = section.Frame,
	})

	-- Section title
	local title = createInstance("TextLabel", {
		Name = name .. "_Title",
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize + 2,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = section.Frame,
	})

	tab.Sections[name] = section
	library.Registry[name .. "_Section"] = { Type = "Section", Instance = section.Frame }

	return section
end

-- Notification system
function rbxscriptlib:ShowNotification(window, title, message, duration)
	local notification = createInstance("Frame", {
		Name = "Notification_" .. title,
		Size = UDim2.new(0, 200, 0, 80),
		Position = UDim2.new(1, -210, 1, -90),
		BackgroundColor3 = library.Theme.BackgroundColor,
		Parent = window.ScreenGui,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = notification })
	applyGlow(notification, library.Theme.AccentColor)

	local titleLabel = createInstance("TextLabel", {
		Size = UDim2.new(1, -10, 0, 20),
		Position = UDim2.new(0, 5, 0, 5),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		Parent = notification,
	})

	local messageLabel = createInstance("TextLabel", {
		Size = UDim2.new(1, -10, 0, 50),
		Position = UDim2.new(0, 5, 0, 25),
		BackgroundTransparency = 1,
		Text = message,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize - 2,
		TextWrapped = true,
		Parent = notification,
	})

	TweenService:Create(notification, library.Animations.OpenTween, { Position = UDim2.new(1, -210, 1, -90) }):Play()
	task.delay(duration or 3, function()
		TweenService:Create(notification, library.Animations.OpenTween, { Position = UDim2.new(1, 0, 1, -90) }):Play()
		task.delay(0.3, function()
			notification:Destroy()
		end)
	end)

	library.Registry[title .. "_Notification"] = { Type = "Notification", Instance = notification }
end

-- Button creation
function rbxscriptlib:CreateButton(section, name, callback)
	local button = createInstance("TextButton", {
		Name = name .. "_Button",
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = library.Theme.PrimaryColor,
		Text = name,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		Parent = section.Frame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = button })
	applyGlow(button, library.Theme.AccentColor)

	button.MouseButton1Click:Connect(function()
		if not library.IsLocked then
			callback()
		end
	end)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, library.Animations.HoverTween, { BackgroundColor3 = library.Theme.AccentColor }):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, library.Animations.HoverTween, { BackgroundColor3 = library.Theme.PrimaryColor }):Play()
	end)

	section.Elements[name] = { Type = "Button", Instance = button }
	library.Registry[name .. "_Button"] = { Type = "Button", Instance = button }

	return button
end

-- Checkbox toggle creation
function rbxscriptlib:CreateToggle(section, name, default, callback)
	local toggle = {
		Frame = createInstance("Frame", {
			Name = name .. "_Toggle",
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundTransparency = 1,
			Parent = section.Frame,
		}),
		Value = default or false,
	}

	local label = createInstance("TextLabel", {
		Size = UDim2.new(1, -40, 1, 0),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = toggle.Frame,
	})

	local toggleButton = createInstance("TextButton", {
		Size = UDim2.new(0, 30, 0, 20),
		Position = UDim2.new(1, -30, 0.5, -10),
		BackgroundColor3 = default and library.Theme.AccentColor or library.Theme.PrimaryColor,
		Text = "",
		Parent = toggle.Frame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = toggleButton })

	toggleButton.MouseButton1Click:Connect(function()
		if not library.IsLocked then
			toggle.Value = not toggle.Value
			TweenService:Create(
				toggleButton,
				library.Animations.HoverTween,
				{ BackgroundColor3 = toggle.Value and library.Theme.AccentColor or library.Theme.PrimaryColor }
			):Play()
			callback(toggle.Value)
		end
	end)

	section.Elements[name] = { Type = "Toggle", Instance = toggle.Frame, Value = toggle.Value }
	library.Registry[name .. "_Toggle"] = { Type = "Toggle", Instance = toggle.Frame }

	return toggle
end

-- Change toggle value
function rbxscriptlib:ChangeToggle(section, name, value)
	local toggle = section.Elements[name]
	if toggle and toggle.Type == "Toggle" then
		toggle.Value = value
		local toggleButton = toggle.Frame:FindFirstChildOfClass("TextButton")
		TweenService:Create(
			toggleButton,
			library.Animations.HoverTween,
			{ BackgroundColor3 = value and library.Theme.AccentColor or library.Theme.PrimaryColor }
		):Play()
	end
end

-- Color picker creation
function rbxscriptlib:CreateColorPicker(section, name, default, callback)
	local colorPicker = {
		Frame = createInstance("Frame", {
			Name = name .. "_ColorPicker",
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundTransparency = 1,
			Parent = section.Frame,
		}),
		Value = default or Color3.new(1, 1, 1),
	}

	local label = createInstance("TextLabel", {
		Size = UDim2.new(1, -40, 1, 0),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = colorPicker.Frame,
	})

	local colorButton = createInstance("TextButton", {
		Size = UDim2.new(0, 30, 0, 20),
		Position = UDim2.new(1, -30, 0.5, -10),
		BackgroundColor3 = default,
		Text = "",
		Parent = colorPicker.Frame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = colorButton })

	-- Placeholder for color picker UI (simplified for Roblox)
	colorButton.MouseButton1Click:Connect(function()
		if not library.IsLocked then
			-- In a real implementation, open a color picker UI
			local newColor = Color3.new(math.random(), math.random(), math.random()) -- Placeholder
			colorPicker.Value = newColor
			colorButton.BackgroundColor3 = newColor
			callback(newColor)
		end
	end)

	section.Elements[name] = { Type = "ColorPicker", Instance = colorPicker.Frame, Value = colorPicker.Value }
	library.Registry[name .. "_ColorPicker"] = { Type = "ColorPicker", Instance = colorPicker.Frame }

	return colorPicker
end

-- Set color picker value
function rbxscriptlib:SetColorPicker(section, name, color)
	local colorPicker = section.Elements[name]
	if colorPicker and colorPicker.Type == "ColorPicker" then
		colorPicker.Value = color
		local colorButton = colorPicker.Frame:FindFirstChildOfClass("TextButton")
		colorButton.BackgroundColor3 = color
	end
end

-- Slider creation
function rbxscriptlib:CreateSlider(section, name, min, max, default, callback)
	local slider = {
		Frame = createInstance("Frame", {
			Name = name .. "_Slider",
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1,
			Parent = section.Frame,
		}),
		Value = default or min,
	}

	local label = createInstance("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Text = name .. ": " .. default,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = slider.Frame,
	})

	local sliderBar = createInstance("Frame", {
		Size = UDim2.new(1, -10, 0, 10),
		Position = UDim2.new(0, 5, 0, 30),
		BackgroundColor3 = library.Theme.PrimaryColor,
		Parent = slider.Frame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 4), Parent = sliderBar })

	local fill = createInstance("Frame", {
		Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = library.Theme.AccentColor,
		Parent = sliderBar,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 4), Parent = fill })

	local sliderButton = createInstance("TextButton", {
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new((default - min) / (max - min), -10, 0, -5),
		BackgroundColor3 = library.Theme.AccentColor,
		Text = "",
		Parent = sliderBar,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sliderButton })

	local dragging = false
	sliderButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not library.IsLocked then
			dragging = true
		end
	end)
	sliderButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local relativeX = math.clamp(
				(input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X,
				0,
				1
			)
			slider.Value = min + (max - min) * relativeX
			sliderButton.Position = UDim2.new(relativeX, -10, 0, -5)
			fill.Size = UDim2.new(relativeX, 0, 1, 0)
			label.Text = name .. ": " .. math.floor(slider.Value)
			callback(slider.Value)
		end
	end)

	section.Elements[name] = { Type = "Slider", Instance = slider.Frame, Value = slider.Value }
	library.Registry[name .. "_Slider"] = { Type = "Slider", Instance = slider.Frame }

	return slider
end

-- Change slider value
function rbxscriptlib:ChangeSlider(section, name, value)
	local slider = section.Elements[name]
	if slider and slider.Type == "Slider" then
		local min, max = 0, 100 -- Placeholder, should be stored with slider
		slider.Value = math.clamp(value, min, max)
		local relativeX = (value - min) / (max - min)
		local sliderBar = slider.Frame:FindFirstChildOfClass("Frame")
		local fill = sliderBar:FindFirstChildOfClass("Frame")
		local sliderButton = sliderBar:FindFirstChildOfClass("TextButton")
		sliderButton.Position = UDim2.new(relativeX, -10, 0, -5)
		fill.Size = UDim2.new(relativeX, 0, 1, 0)
		slider.Frame:FindFirstChildOfClass("TextLabel").Text = name .. ": " .. math.floor(value)
	end
end

-- Label creation
function rbxscriptlib:CreateLabel(section, name, text)
	local label = createInstance("TextLabel", {
		Name = name .. "_Label",
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = section.Frame,
	})

	section.Elements[name] = { Type = "Label", Instance = label }
	library.Registry[name .. "_Label"] = { Type = "Label", Instance = label }

	return label
end

-- Change label content
function rbxscriptlib:ChangeLabel(section, name, text)
	local label = section.Elements[name]
	if label and label.Type == "Label" then
		label.Instance.Text = text
	end
end

-- Paragraph creation
function rbxscriptlib:CreateParagraph(section, name, text)
	local paragraph = createInstance("TextLabel", {
		Name = name .. "_Paragraph",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize - 2,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = section.Frame,
	})

	section.Elements[name] = { Type = "Paragraph", Instance = paragraph }
	library.Registry[name .. "_Paragraph"] = { Type = "Paragraph", Instance = paragraph }

	return paragraph
end

-- Change paragraph content
function rbxscriptlib:ChangeParagraph(section, name, text)
	local paragraph = section.Elements[name]
	if paragraph and paragraph.Type == "Paragraph" then
		paragraph.Instance.Text = text
	end
end

-- Adaptive input creation
function rbxscriptlib:CreateInput(section, name, default, callback)
	local input = {
		Frame = createInstance("Frame", {
			Name = name .. "_Input",
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundTransparency = 1,
			Parent = section.Frame,
		}),
		Value = default or "",
	}

	local label = createInstance("TextLabel", {
		Size = UDim2.new(1, -100, 1, 0),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = input.Frame,
	})

	local textBox = createInstance("TextBox", {
		Size = UDim2.new(0, 90, 0, 20),
		Position = UDim2.new(1, -90, 0.5, -10),
		BackgroundColor3 = library.Theme.PrimaryColor,
		Text = default or "",
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		Parent = input.Frame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = textBox })

	textBox.FocusLost:Connect(function()
		if not library.IsLocked then
			local value = textBox.Text
			-- Auto-detect type
			if tonumber(value) then
				input.Value = tonumber(value)
			elseif value:lower() == "true" or value:lower() == "false" then
				input.Value = value:lower() == "true"
			else
				input.Value = value
			end
			callback(input.Value)
		end
	end)

	section.Elements[name] = { Type = "Input", Instance = input.Frame, Value = input.Value }
	library.Registry[name .. "_Input"] = { Type = "Input", Instance = input.Frame }

	return input
end

-- Keybind creation
function rbxscriptlib:CreateKeybind(section, name, default, callback)
	local keybind = {
		Frame = createInstance("Frame", {
			Name = name .. "_Keybind",
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundTransparency = 1,
			Parent = section.Frame,
		}),
		Value = default or Enum.KeyCode.T,
	}

	local label = createInstance("TextLabel", {
		Size = UDim2.new(1, -60, 1, 0),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = keybind.Frame,
	})

	local keyButton = createInstance("TextButton", {
		Size = UDim2.new(0, 50, 0, 20),
		Position = UDim2.new(1, -50, 0.5, -10),
		BackgroundColor3 = library.Theme.PrimaryColor,
		Text = default.Name,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		Parent = keybind.Frame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyButton })

	local binding = false
	keyButton.MouseButton1Click:Connect(function()
		if not library.IsLocked then
			binding = true
			keyButton.Text = "Press a key..."
		end
	end)

	UserInputService.InputBegan:Connect(function(input)
		if binding and input.UserInputType == Enum.UserInputType.Keyboard then
			keybind.Value = input.KeyCode
			keyButton.Text = input.KeyCode.Name
			binding = false
			callback(keybind.Value)
		end
	end)

	section.Elements[name] = { Type = "Keybind", Instance = keybind.Frame, Value = keybind.Value }
	library.Registry[name .. "_Keybind"] = { Type = "Keybind", Instance = keybind.Frame }

	return keybind
end

-- Change keybind value
function rbxscriptlib:ChangeKeybind(section, name, key)
	local keybind = section.Elements[name]
	if keybind and keybind.Type == "Keybind" then
		keybind.Value = key
		local keyButton = keybind.Frame:FindFirstChildOfClass("TextButton")
		keyButton.Text = key.Name
	end
end

-- Dropdown creation
function rbxscriptlib:CreateDropdown(section, name, options, default, multiSelect, callback)
	local dropdown = {
		Frame = createInstance("Frame", {
			Name = name .. "_Dropdown",
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundTransparency = 1,
			Parent = section.Frame,
		}),
		Options = options or {},
		Value = multiSelect and {} or (default or options[1]),
		IsMultiSelect = multiSelect,
	}

	local label = createInstance("TextLabel", {
		Size = UDim2.new(1, -100, 1, 0),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = dropdown.Frame,
	})

	local dropdownButton = createInstance("TextButton", {
		Size = UDim2.new(0, 90, 0, 20),
		Position = UDim2.new(1, -90, 0.5, -10),
		BackgroundColor3 = library.Theme.PrimaryColor,
		Text = multiSelect and "Select" or (default or options[1] or ""),
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize,
		Parent = dropdown.Frame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = dropdownButton })

	local dropdownMenu = createInstance("Frame", {
		Name = "Menu",
		Size = UDim2.new(0, 90, 0, 0),
		Position = UDim2.new(1, -90, 0.5, 10),
		BackgroundColor3 = library.Theme.BackgroundColor,
		BorderSizePixel = 0,
		Visible = false,
		Parent = dropdown.Frame,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = dropdownMenu })
	createInstance("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = dropdownMenu,
	})

	local function updateMenu()
		dropdownMenu.Size = UDim2.new(0, 90, 0, #dropdown.Options * 25 + 10)
		dropdownMenu:ClearAllChildren()
		createInstance("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5),
			Parent = dropdownMenu,
		})
		for _, option in ipairs(dropdown.Options) do
			local optButton = createInstance("TextButton", {
				Size = UDim2.new(1, -10, 0, 20),
				Position = UDim2.new(0, 5, 0, 0),
				BackgroundColor3 = library.Theme.PrimaryColor,
				Text = option,
				TextColor3 = library.Theme.TextColor,
				Font = library.Theme.Font,
				TextSize = library.Theme.FontSize,
				Parent = dropdownMenu,
			})
			createInstance("UICorner", { CornerRadius = UDim.new(0, 4), Parent = optButton })

			optButton.MouseButton1Click:Connect(function()
				if not library.IsLocked then
					if multiSelect then
						if not table.find(dropdown.Value, option) then
							table.insert(dropdown.Value, option)
						else
							table.remove(dropdown.Value, table.find(dropdown.Value, option))
						end
						dropdownButton.Text = #dropdown.Value > 0 and table.concat(dropdown.Value, ", ") or "Select"
					else
						dropdown.Value = option
						dropdownButton.Text = option
						dropdownMenu.Visible = false
					end
					callback(dropdown.Value)
				end
			end)
		end
	end

	dropdownButton.MouseButton1Click:Connect(function()
		if not library.IsLocked then
			dropdownMenu.Visible = not dropdownMenu.Visible
		end
	end)

	updateMenu()

	section.Elements[name] = { Type = "Dropdown", Instance = dropdown.Frame, Value = dropdown.Value }
	library.Registry[name .. "_Dropdown"] = { Type = "Dropdown", Instance = dropdown.Frame }

	return dropdown
end

-- Add options to dropdown
function rbxscriptlib:AddDropdownOptions(section, name, newOptions)
	local dropdown = section.Elements[name]
	if dropdown and dropdown.Type == "Dropdown" then
		for _, option in ipairs(newOptions) do
			if not table.find(dropdown.Options, option) then
				table.insert(dropdown.Options, option)
			end
		end
		-- Update menu (simplified, would need actual menu refresh)
	end
end

-- Select dropdown option
function rbxscriptlib:SelectDropdownOption(section, name, option)
	local dropdown = section.Elements[name]
	if dropdown and dropdown.Type == "Dropdown" then
		if dropdown.IsMultiSelect then
			if not table.find(dropdown.Value, option) then
				table.insert(dropdown.Value, option)
			end
			dropdown.Frame:FindFirstChildOfClass("TextButton").Text = table.concat(dropdown.Value, ", ")
		else
			dropdown.Value = option
			dropdown.Frame:FindFirstChildOfClass("TextButton").Text = option
		end
	end
end

-- Theme switching
function rbxscriptlib:SwitchTheme(themeName)
	if themeName == "Light" then
		library.Theme = {
			PrimaryColor = Color3.fromRGB(200, 200, 200),
			AccentColor = Color3.fromRGB(0, 120, 255),
			BackgroundColor = Color3.fromRGB(240, 240, 240),
			TextColor = Color3.fromRGB(0, 0, 0),
			Font = Enum.Font.SourceSansPro,
			FontSize = 16,
		}
	elseif themeName == "Dark" then
		library.Theme = {
			PrimaryColor = Color3.fromRGB(30, 30, 30),
			AccentColor = Color3.fromRGB(255, 100, 100),
			BackgroundColor = Color3.fromRGB(20, 20, 20),
			TextColor = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.SourceSansPro,
			FontSize = 16,
		}
	else -- Futuristic
		library.Theme = {
			PrimaryColor = Color3.fromRGB(10, 25, 47),
			AccentColor = Color3.fromRGB(0, 255, 255),
			BackgroundColor = Color3.fromRGB(20, 20, 30),
			TextColor = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.SourceSansPro,
			FontSize = 16,
		}
	end

	-- Update all elements (simplified, would need to iterate through registry)
	for _, window in pairs(library.Windows) do
		window.MainFrame.BackgroundColor3 = library.Theme.BackgroundColor
		window.NavFrame.BackgroundColor3 = library.Theme.PrimaryColor
		for _, tab in pairs(window.Tabs) do
			tab.NavButton.BackgroundColor3 = library.Theme.PrimaryColor
			tab.NavButton.TextColor3 = library.Theme.TextColor
			for _, section in pairs(tab.Sections) do
				section.Frame.BackgroundColor3 = library.Theme.BackgroundColor
				for _, element in pairs(section.Elements) do
					if element.Type == "Button" or element.Type == "Toggle" or element.Type == "ColorPicker" or element.Type == "Slider" or element.Type == "Dropdown" then
						local button = element.Instance:FindFirstChildOfClass("TextButton") or element.Instance
						if button then
							button.BackgroundColor3 = library.Theme.PrimaryColor
							button.TextColor3 = library.Theme.TextColor
						end
					elseif element.Type == "Label" or element.Type == "Paragraph" then
						element.Instance.TextColor3 = library.Theme.TextColor
					end
				end
			end
		end
	end
end

-- Font customization
function rbxscriptlib:SetFont(font, size)
	library.Theme.Font = font
	library.Theme.FontSize = size
	-- Update all text elements (simplified)
	for _, window in pairs(library.Windows) do
		for _, tab in pairs(window.Tabs) do
			tab.NavButton.Font = font
			tab.NavButton.TextSize = size
			for _, section in pairs(tab.Sections) do
				for _, element in pairs(section.Elements) do
					if element.Type == "Label" or element.Type == "Paragraph" then
						element.Instance.Font = font
						element.Instance.TextSize = size
					elseif element.Type == "Button" or element.Type == "Toggle" or element.Type == "ColorPicker" or element.Type == "Slider" or element.Type == "Dropdown" then
						local button = element.Instance:FindFirstChildOfClass("TextButton") or element.Instance
						if button then
							button.Font = font
							button.TextSize = size
						end
					end
				end
			end
		end
	end
end

-- Toggle visibility
function rbxscriptlib:ToggleVisibility(window, visible)
	window.MainFrame.Visible = visible
end

-- Save UI state
function rbxscriptlib:SaveState(window)
	local state = {}
	for tabName, tab in pairs(window.Tabs) do
		for sectionName, section in pairs(tab.Sections) for elementName, element in pairs(section.Elements) do
			if element.Value then
				state[tabName .. "_" .. sectionName .. "_" .. elementName] = element.Value
			end
		end
	end
	return HttpService:JSONEncode(state)
end

-- Load UI state
function rbxscriptlib:LoadState(window, stateJson)
	local state = HttpService:JSONDecode(stateJson)
	for key, value in pairs(state) do
		local tabName, sectionName, elementName = key:match("([^_]+)_([^_]+)_(.+)")
		local tab = window.Tabs[tabName]
		if tab then
			local section = tab.Sections[sectionName]
			if section then
				local element = section.Elements[elementName]
				if element then
					if element.Type == "Toggle" then
						self:ChangeToggle(section, elementName, value)
					elseif element.Type == "Slider" then
						self:ChangeSlider(section, elementName, value)
					elseif element.Type == "Dropdown" then
						self:SelectDropdownOption(section, elementName, value)
					elseif element.Type == "ColorPicker" then
						self:SetColorPicker(section, elementName, value)
					end
				end
			end
		end
	end
end

-- Debug console
function rbxscriptlib:OpenDebugConsole(window)
	local console = createInstance("Frame", {
		Name = "DebugConsole",
		Size = UDim2.new(0, 300, 0, 200),
		Position = UDim2.new(0, 10, 1, -210),
		BackgroundColor3 = library.Theme.BackgroundColor,
		Parent = window.ScreenGui,
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = console })
	createInstance("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = console })

	local log = createInstance("TextLabel", {
		Size = UDim2.new(1, -10, 0, 180),
		Position = UDim2.new(0, 5, 0, 5),
		BackgroundTransparency = 1,
		Text = "Debug Console:\n" .. HttpService:JSONEncode(library.Registry, { Pretty = true }),
		TextColor3 = library.Theme.TextColor,
		Font = library.Theme.Font,
		TextSize = library.Theme.FontSize - 2,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = console,
	})

	library.Registry["DebugConsole"] = { Type = "DebugConsole", Instance = console }
end

-- Finalize UI
function rbxscriptlib:Finalize(window)
	if #window.Tabs > 0 then
		window.Tabs[window.Tabs[1].Name].ContentFrame.Visible = true
		window.Tabs[window.Tabs[1].Name].NavButton.BackgroundColor3 = library.Theme.AccentColor
	end
	TweenService:Create(
		window.MainFrame,
		library.Animations.OpenTween,
		{ Position = UDim2.new(0.5, -300, 0.5, -200) }
	):Play()
end

-- Destroy UI
function rbxscriptlib:Destroy(window)
	window.ScreenGui:Destroy()
	library.Windows[window.Name] = nil
	library.Registry[window.Name] = nil
end

-- Key system
function rbxscriptlib:EnableKeySystem(key)
	library.KeySystemEnabled = true
	library.Key = key
	library.IsLocked = true
end

function rbxscriptlib:Unlock(key)
	if library.KeySystemEnabled and key == library.Key then
		library.IsLocked = false
	end
end

-- Plugin API
function rbxscriptlib:RegisterPlugin(pluginName, pluginFunctions)
	library.Plugins = library.Plugins or {}
	library.Plugins[pluginName] = pluginFunctions
end

return rbxscriptlib
