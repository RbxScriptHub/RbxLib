-- rbxscriptlib: A futuristic, developer-friendly Roblox UI library
-- Inspired by OrionLib with a modern left-side navigation layout

local rbxscriptlib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Core UI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "rbxscriptlib"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Theme configuration
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 30),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(220, 220, 220),
        Glow = Color3.fromRGB(50, 150, 255),
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(0, 100, 200),
        Text = Color3.fromRGB(30, 30, 30),
        Glow = Color3.fromRGB(100, 180, 255),
    },
    Futuristic = {
        Background = Color3.fromRGB(10, 10, 20),
        Accent = Color3.fromRGB(0, 255, 200),
        Text = Color3.fromRGB(200, 255, 255),
        Glow = Color3.fromRGB(50, 255, 220),
    }
}

local CurrentTheme = Themes.Futuristic
local Font = Enum.Font.Code
local FontSize = Enum.FontSize.Size18

-- Internal state
local Windows = {}
local ActiveWindow = nil
local UIState = {}
local Registry = {}
local DebugConsole = { logs = {} }

-- Animation helper
local function createTween(instance, properties, duration, easingStyle)
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Notification system
local function showNotification(message, duration)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 200, 0, 50)
    notification.Position = UDim2.new(1, -210, 0, 10)
    notification.BackgroundColor3 = CurrentTheme.Background
    notification.BorderColor3 = CurrentTheme.Glow
    notification.Parent = ScreenGui

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Text = message
    text.TextColor3 = CurrentTheme.Text
    text.Font = Font
    text.TextSize = 16
    text.BackgroundTransparency = 1
    text.Parent = notification

    createTween(notification, { Position = UDim2.new(1, -210, 0, 60) }, 0.3)
    wait(duration or 3)
    createTween(notification, { Position = UDim2.new(1, 0, 0, 60) }, 0.3)
    wait(0.3)
    notification:Destroy()
end

-- Main library functions
function rbxscriptlib:CreateWindow(title)
    local windowId = HttpService:GenerateGUID(false)
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 600, 0, 400)
    window.Position = UDim2.new(0.5, -300, 0.5, -200)
    window.BackgroundColor3 = CurrentTheme.Background
    window.BorderColor3 = CurrentTheme.Glow
    window.Parent = ScreenGui
    window.ClipsDescendants = true

    local navPanel = Instance.new("Frame")
    navPanel.Size = UDim2.new(0, 150, 1, 0)
    navPanel.BackgroundColor3 = CurrentTheme.Background:lerp(CurrentTheme.Glow, 0.1)
    navPanel.Parent = window

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -150, 1, 0)
    contentArea.Position = UDim2.new(0, 150, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = window

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Text = title
    titleLabel.TextColor3 = CurrentTheme.Text
    titleLabel.Font = Font
    titleLabel.TextSize = 20
    titleLabel.BackgroundColor3 = CurrentTheme.Accent
    titleLabel.Parent = window

    local windowData = {
        Id = windowId,
        Frame = window,
        NavPanel = navPanel,
        ContentArea = contentArea,
        Tabs = {},
        ActiveTab = nil
    }

    Windows[windowId] = windowData
    Registry[windowId] = windowData
    ActiveWindow = windowData

    return windowData
end

function rbxscriptlib:CreateTab(window, name)
    local tabId = HttpService:GenerateGUID(false)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Position = UDim2.new(0, 0, 0, #window.Tabs * 40 + 40)
    tabButton.Text = name
    tabButton.TextColor3 = CurrentTheme.Text
    tabButton.Font = Font
    tabButton.TextSize = 16
    tabButton.BackgroundColor3 = CurrentTheme.Background
    tabButton.Parent = window.NavPanel

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = window.ContentArea
    contentFrame.Visible = false

    local tabData = {
        Id = tabId,
        Button = tabButton,
        Content = contentFrame,
        Sections = {}
    }

    table.insert(window.Tabs, tabData)
    Registry[tabId] = tabData

    tabButton.MouseButton1Click:Connect(function()
        if window.ActiveTab then
            window.ActiveTab.Content.Visible = false
            createTween(window.ActiveTab.Button, { BackgroundColor3 = CurrentTheme.Background }, 0.2)
        end
        tabData.Content.Visible = true
        createTween(tabButton, { BackgroundColor3 = CurrentTheme.Accent }, 0.2)
        window.ActiveTab = tabData
    end)

    if not window.ActiveTab then
        tabData.Content.Visible = true
        tabButton.BackgroundColor3 = CurrentTheme.Accent
        window.ActiveTab = tabData
    end

    return tabData
end

function rbxscriptlib:CreateSection(tab, name)
    local sectionId = HttpService:GenerateGUID(false)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 100)
    section.Position = UDim2.new(0, 5, 0, #tab.Sections * 110 + 10)
    section.BackgroundColor3 = CurrentTheme.Background:lerp(CurrentTheme.Glow, 0.05)
    section.BorderColor3 = CurrentTheme.Glow
    section.Parent = tab.Content

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, 0, 0, 20)
    sectionLabel.Text = name
    sectionLabel.TextColor3 = CurrentTheme.Text
    sectionLabel.Font = Font
    sectionLabel.TextSize = 16
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Parent = section

    local sectionData = {
        Id = sectionId,
        Frame = section,
        Elements = {}
    }

    table.insert(tab.Sections, sectionData)
    Registry[sectionId] = sectionData
    return sectionData
end

function rbxscriptlib:CreateButton(section, name, callback)
    local buttonId = HttpService:GenerateGUID(false)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, #section.Elements * 40 + 30)
    button.Text = name
    button.TextColor3 = CurrentTheme.Text
    button.Font = Font
    button.TextSize = 14
    button.BackgroundColor3 = CurrentTheme.Accent
    button.Parent = section.Frame

    button.MouseButton1Click:Connect(function()
        createTween(button, { BackgroundColor3 = CurrentTheme.Glow }, 0.1)
        wait(0.1)
        createTween(button, { BackgroundColor3 = CurrentTheme.Accent }, 0.1)
        if callback then callback() end
    end)

    table.insert(section.Elements, button)
    Registry[buttonId] = button
    return button
end

function rbxscriptlib:CreateToggle(section, name, default, callback)
    local toggleId = HttpService:GenerateGUID(false)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -10, 0, 30)
    toggle.Position = UDim2.new(0, 5, 0, #section.Elements * 40 + 30)
    toggle.Text = name .. (default and " (On)" or " (Off)")
    toggle.TextColor3 = CurrentTheme.Text
    toggle.Font = Font
    toggle.TextSize = 14
    toggle.BackgroundColor3 = default and CurrentTheme.Accent or CurrentTheme.Background
    toggle.Parent = section.Frame

    local value = default
    toggle.MouseButton1Click:Connect(function()
        value = not value
        toggle.Text = name .. (value and " (On)" or " (Off)")
        toggle.BackgroundColor3 = value and CurrentTheme.Accent or CurrentTheme.Background
        if callback then callback(value) end
        UIState[toggleId] = value
    end)

    UIState[toggleId] = value
    table.insert(section.Elements, toggle)
    Registry[toggleId] = toggle
    return toggle
end

function rbxscriptlib:ChangeToggleValue(toggle, value)
    toggle.Text = toggle.Text:match("^(.-)%s%(%a+%)") .. (value and " (On)" or " (Off)")
    toggle.BackgroundColor3 = value and CurrentTheme.Accent or CurrentTheme.Background
    UIState[toggle.Name] = value
end

function rbxscriptlib:CreateColorPicker(section, name, default, callback)
    local pickerId = HttpService:GenerateGUID(false)
    local picker = Instance.new("Frame")
    picker.Size = UDim2.new(1, -10, 0, 30)
    picker.Position = UDim2.new(0, 5, 0, #section.Elements * 40 + 30)
    picker.BackgroundColor3 = default or Color3.fromRGB(255, 255, 255)
    picker.Parent = section.Frame

    local pickerLabel = Instance.new("TextLabel")
    pickerLabel.Size = UDim2.new(1, 0, 1, 0)
    pickerLabel.Text = name
    pickerLabel.TextColor3 = CurrentTheme.Text
    pickerLabel.Font = Font
    pickerLabel.TextSize = 14
    pickerLabel.BackgroundTransparency = 1
    pickerLabel.Parent = picker

    -- Simplified color picker (Roblox doesn't support native color picking)
    picker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Placeholder for color picker UI (would require a custom UI)
            showNotification("Color picker opened (simulated)", 2)
            if callback then callback(picker.BackgroundColor3) end
        end
    end)

    UIState[pickerId] = default
    table.insert(section.Elements, picker)
    Registry[pickerId] = picker
    return picker
end

function rbxscriptlib:SetColorPickerValue(picker, color)
    picker.BackgroundColor3 = color
    UIState[picker.Name] = color
end

function rbxscriptlib:CreateSlider(section, name, min, max, default, callback)
    local sliderId = HttpService:GenerateGUID(false)
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -10, 0, 30)
    slider.Position = UDim2.new(0, 5, 0, #section.Elements * 40 + 30)
    slider.BackgroundColor3 = CurrentTheme.Background
    slider.Parent = section.Frame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 10)
    sliderBar.Position = UDim2.new(0, 0, 0, 20)
    sliderBar.BackgroundColor3 = CurrentTheme.Accent
    sliderBar.Parent = slider

    local value = default or min
    local function updateSlider()
        local ratio = (value - min) / (max - min)
        sliderBar.Size = UDim2.new(ratio, 0, 0, 10)
        if callback then callback(value) end
        UIState[sliderId] = value
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = UserInputService:GetMouseLocation()
            local relativeX = (mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            value = math.clamp(min + relativeX * (max - min), min, max)
            updateSlider()
        end
    end)

    UIState[sliderId] = value
    table.insert(section.Elements, slider)
    Registry[sliderId] = slider
    return slider
end

function rbxscriptlib:ChangeSliderValue(slider, value)
    UIState[slider.Name] = value
    local min, max = 0, 100 -- Placeholder, would need to store min/max
    slider:FindFirstChild("Frame").Size = UDim2.new((value - min) / (max - min), 0, 0, 10)
end

function rbxscriptlib:CreateLabel(section, text)
    local labelId = HttpService:GenerateGUID(false)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 30)
    label.Position = UDim2.new(0, 5, 0, #section.Elements * 40 + 30)
    label.Text = text
    label.TextColor3 = CurrentTheme.Text
    label.Font = Font
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.Parent = section.Frame

    table.insert(section.Elements, label)
    Registry[labelId] = label
    return label
end

function rbxscriptlib:ChangeLabelContent(label, text)
    label.Text = text
end

function rbxscriptlib:CreateParagraph(section, text)
    local paragraphId = HttpService:GenerateGUID(false)
    local paragraph = Instance.new("TextLabel")
    paragraph.Size = UDim2.new(1, -10, 0, 50)
    paragraph.Position = UDim2.new(0, 5, 0, #section.Elements * 60 + 30)
    paragraph.Text = text
    paragraph.TextColor3 = CurrentTheme.Text
    paragraph.Font = Font
    paragraph.TextSize = 14
    paragraph.TextWrapped = true
    paragraph.BackgroundTransparency = 1
    paragraph.Parent = section.Frame

    table.insert(section.Elements, paragraph)
    Registry[paragraphId] = paragraph
    return paragraph
end

function rbxscriptlib:ChangeParagraphContent(paragraph, text)
    paragraph.Text = text
end

function rbxscriptlib:CreateInput(section, name, callback)
    local inputId = HttpService:GenerateGUID(false)
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -10, 0, 30)
    input.Position = UDim2.new(0, 5, 0, #section.Elements * 40 + 30)
    input.Text = name
    input.TextColor3 = CurrentTheme.Text
    input.Font = Font
    input.TextSize = 14
    input.BackgroundColor3 = CurrentTheme.Background
    input.Parent = section.Frame

    input.FocusLost:Connect(function()
        local value = input.Text
        if tonumber(value) then
            value = tonumber(value)
        elseif value:lower() == "true" or value:lower() == "false" then
            value = value:lower() == "true"
        end
        if callback then callback(value) end
        UIState[inputId] = value
    end)

    table.insert(section.Elements, input)
    Registry[inputId] = input
    return input
end

function rbxscriptlib:CreateKeybind(section, name, default, callback)
    local keybindId = HttpService:GenerateGUID(false)
    local keybind = Instance.new("TextButton")
    keybind.Size = UDim2.new(1, -10, 0, 30)
    keybind.Position = UDim2.new(0, 5, 0, #section.Elements * 40 + 30)
    keybind.Text = name .. " (" .. tostring(default or Enum.KeyCode.T) .. ")"
    keybind.TextColor3 = CurrentTheme.Text
    keybind.Font = Font
    keybind.TextSize = 14
    keybind.BackgroundColor3 = CurrentTheme.Background
    keybind.Parent = section.Frame

    local binding = false
    local key = default or Enum.KeyCode.T
    keybind.MouseButton1Click:Connect(function()
        binding = true
        keybind.Text = name .. " (Press a key)"
    end)

    UserInputService.InputBegan:Connect(function(input)
        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
            key = input.KeyCode
            keybind.Text = name .. " (" .. tostring(key) .. ")"
            binding = false
            if callback then callback(key) end
            UIState[keybindId] = key
        end
    end)

    table.insert(section.Elements, keybind)
    Registry[keybindId] = keybind
    return keybind
end

function rbxscriptlib:ChangeKeybindValue(keybind, key)
    keybind.Text = keybind.Text:match("^(.-)%s%(%a+%)") .. " (" .. tostring(key) .. ")"
    UIState[keybind.Name] = key
end

function rbxscriptlib:CreateDropdown(section, name, options, callback)
    local dropdownId = HttpService:GenerateGUID(false)
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, -10, 0, 30)
    dropdown.Position = UDim2.new(0, 5, 0, #section.Elements * 40 + 30)
    dropdown.Text = name .. " (" .. options[1] .. ")"
    dropdown.TextColor3 = CurrentTheme.Text
    dropdown.Font = Font
    dropdown.TextSize = 14
    dropdown.BackgroundColor3 = CurrentTheme.Background
    dropdown.Parent = section.Frame

    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    dropdownFrame.Position = UDim2.new(0, 0, 1, 0)
    dropdownFrame.BackgroundColor3 = CurrentTheme.Background
    dropdownFrame.Visible = false
    dropdownFrame.Parent = dropdown

    local dropdownOptions = {}
    for i, option in ipairs(options) do
        local optButton = Instance.new("TextButton")
        optButton.Size = UDim2.new(1, 0, 0, 30)
        optButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
        optButton.Text = option
        optButton.TextColor3 = CurrentTheme.Text
        optButton.Font = Font
        optButton.TextSize = 14
        optButton.BackgroundColor3 = CurrentTheme.Background
        optButton.Parent = dropdownFrame

        optButton.MouseButton1Click:Connect(function()
            dropdown.Text = name .. " (" .. option .. ")"
            dropdownFrame.Visible = false
            if callback then callback(option) end
            UIState[dropdownId] = option
        end)
        table.insert(dropdownOptions, optButton)
    end

    dropdown.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
    end)

    table.insert(section.Elements, dropdown)
    Registry[dropdownId] = { Button = dropdown, Frame = dropdownFrame, Options = dropdownOptions }
    return dropdown
end

function rbxscriptlib:AddDropdownOption(dropdown, option)
    local dropdownData = Registry[dropdown.Name]
    local optButton = Instance.new("TextButton")
    optButton.Size = UDim2.new(1, 0, 0, 30)
    optButton.Position = UDim2.new(0, 0, 0, #dropdownData.Options * 30)
    optButton.Text = option
    optButton.TextColor3 = CurrentTheme.Text
    optButton.Font = Font
    optButton.TextSize = 14
    optButton.BackgroundColor3 = CurrentTheme.Background
    optButton.Parent = dropdownData.Frame

    optButton.MouseButton1Click:Connect(function()
        dropdown.Text = dropdown.Text:match("^(.-)%s%(%a+%)") .. " (" .. option .. ")"
        dropdownData.Frame.Visible = false
        UIState[dropdown.Name] = option
    end)

    table.insert(dropdownData.Options, optButton)
    dropdownData.Frame.Size = UDim2.new(1, 0, 0, #dropdownData.Options * 30)
end

function rbxscriptlib:SelectDropdownOption(dropdown, option)
    dropdown.Text = dropdown.Text:match("^(.-)%s%(%a+%)") .. " (" .. option .. ")"
    UIState[dropdown.Name] = option
end

function rbxscriptlib:Finalize()
    -- Build and optimize UI
    showNotification("UI Finalized", 2)
end

function rbxscriptlib:Destroy()
    ScreenGui:Destroy()
    Windows = {}
    Registry = {}
    UIState = {}
    ActiveWindow = nil
end

function rbxscriptlib:ChangeTheme(themeName)
    CurrentTheme = Themes[themeName] or Themes.Futuristic
    for _, window in pairs(Windows) do
        window.Frame.BackgroundColor3 = CurrentTheme.Background
        window.NavPanel.BackgroundColor3 = CurrentTheme.Background:lerp(CurrentTheme.Glow, 0.1)
        window.Frame.BorderColor3 = CurrentTheme.Glow
        for _, tab in pairs(window.Tabs) do
            tab.Button.TextColor3 = CurrentTheme.Text
            for _, section in pairs(tab.Sections) do
                section.Frame.BackgroundColor3 = CurrentTheme.Background:lerp(CurrentTheme.Glow, 0.05)
                section.Frame.BorderColor3 = CurrentTheme.Glow
                for _, element in pairs(section.Elements) do
                    if element:IsA("TextLabel") or element:IsA("TextButton") then
                        element.TextColor3 = CurrentTheme.Text
                    end
                end
            end
        end
    end
end

function rbxscriptlib:ToggleVisibility(element)
    element.Visible = not element.Visible
end

function rbxscriptlib:ShowDebugConsole()
    for _, log in ipairs(DebugConsole.logs) do
        print(log)
    end
end

-- Plugin API (placeholder)
function rbxscriptlib:RegisterPlugin(plugin)
    DebugConsole.logs[#DebugConsole.logs + 1] = "Plugin registered: " .. plugin.Name
end

-- Example usage
local window = rbxscriptlib:CreateWindow("rbxscriptlib Demo")
local tab = rbxscriptlib:CreateTab(window, "Main")
local section = rbxscriptlib:CreateSection(tab, "Controls")
rbxscriptlib:CreateButton(section, "Click Me", function() showNotification("Button Clicked!", 2) end)
rbxscriptlib:CreateToggle(section, "Toggle Feature", true, function(value) showNotification("Toggle: " .. tostring(value), 2) end)
rbxscriptlib:CreateSlider(section, "Speed", 0, 100, 50, function(value) showNotification("Slider: " .. value, 2) end)
rbxscriptlib:CreateDropdown(section, "Select Option", {"Option 1", "Option 2", "Option 3"}, function(option) showNotification("Selected: " .. option, 2) end)
rbxscriptlib:Finalize()

return rbxscriptlib
