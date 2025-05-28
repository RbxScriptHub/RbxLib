-- rbxscript lib: A modern, futuristic UI library for Roblox
-- Inspired by Rayfield Interface Suite
-- Features: Windows, Tabs, Buttons, Toggles, Sliders, Dropdowns, Keybinds, Toggleable Key System
-- Design: Dark theme with neon accents, smooth animations, mobile-friendly

local rbxscriptLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GuiService = game:GetService("GuiService")

-- Create the main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "rbxscriptLibGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Constants for UI styling
local UI_CORNER_RADIUS = UDim.new(0, 8)
local NEON_COLOR = Color3.fromRGB(0, 255, 255)
local BACKGROUND_COLOR = Color3.fromRGB(20, 20, 30)
local ACCENT_COLOR = Color3.fromRGB(40, 40, 50)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

-- Animation settings
local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Key system configuration
local KeySystem = {
    Key = "rbxscript2025", -- Default key
    SaveKey = true,
    FileName = "rbxscript_key"
}

-- Main library function to create a window
function rbxscriptLib:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "rbxscript lib"
    local windowSize = config.Size or UDim2.new(0, 500, 0, 400)
    local keySystemEnabled = config.KeySystemEnabled or false -- New toggleable key system option

    -- Create main window frame
    local Window = Instance.new("Frame")
    Window.Size = windowSize
    Window.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
    Window.BackgroundColor3 = BACKGROUND_COLOR
    Window.BorderSizePixel = 0
    Window.Active = true
    Window.ClipsDescendants = true
    Window.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UI_CORNER_RADIUS
    UICorner.Parent = Window

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = ACCENT_COLOR
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Window

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -10, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = windowTitle
    TitleText.TextColor3 = TEXT_COLOR
    TitleText.TextSize = 18
    TitleText.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = TEXT_COLOR
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        Window.Visible = false
    end)

    -- Tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 150, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = ACCENT_COLOR
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Window

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabContainer

    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -150, 1, -40)
    ContentArea.Position = UDim2.new(0, 150, 0, 40)
    ContentArea.BackgroundColor3 = BACKGROUND_COLOR
    ContentArea.BorderSizePixel = 0
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = Window

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentArea

    local tabs = {}
    local currentTab = nil

    -- Function to create a tab
    function tabs:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = ACCENT_COLOR
        TabButton.Text = tabName
        TabButton.TextColor3 = TEXT_COLOR
        TabButton.TextSize = 16
        TabButton.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentArea

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 10)
        TabContentLayout.Parent = TabContent

        local tabElements = {}

        TabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Content.Visible = false
                currentTab.Button.BackgroundColor3 = ACCENT_COLOR
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = NEON_COLOR
            currentTab = {Button = TabButton, Content = TabContent}
        end)

        -- Initialize first tab as active
        if not currentTab then
            TabButton:Click()
        end

        -- Function to create a button
        function tabElements:CreateButton(buttonConfig)
            buttonConfig = buttonConfig or {}
            local buttonText = buttonConfig.Name or "Button"
            local callback = buttonConfig.Callback or function() end

            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -20, 0, 40)
            Button.Position = UDim2.new(0, 10, 0, 0)
            Button.BackgroundColor3 = ACCENT_COLOR
            Button.Text = buttonText
            Button.TextColor3 = TEXT_COLOR
            Button.TextSize = 16
            Button.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
            Button.Parent = TabContent

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UI_CORNER_RADIUS
            ButtonCorner.Parent = Button

            Button.MouseButton1Click:Connect(function()
                callback()
            end)

            -- Hover animation
            Button.MouseEnter:Connect(function()
                local tween = TweenService:Create(Button, TWEEN_INFO, {BackgroundColor3 = NEON_COLOR})
                tween:Play()
            end)

            Button.MouseLeave:Connect(function()
                local tween = TweenService:Create(Button, TWEEN_INFO, {BackgroundColor3 = ACCENT_COLOR})
                tween:Play()
            end)
        end

        -- Function to create a toggle
        function tabElements:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local toggleName = toggleConfig.Name or "Toggle"
            local default = toggleConfig.Default or false
            local callback = toggleConfig.Callback or function() end

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
            ToggleFrame.Position = UDim2.new(0, 10, 0, 0)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Parent = TabContent

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleName
            ToggleLabel.TextColor3 = TEXT_COLOR
            ToggleLabel.TextSize = 16
            ToggleLabel.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            ToggleButton.BackgroundColor3 = default and NEON_COLOR or ACCENT_COLOR
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 10)
            ToggleCorner.Parent = ToggleButton

            local isToggled = default

            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                local tween = TweenService:Create(ToggleButton, TWEEN_INFO, {BackgroundColor3 = isToggled and NEON_COLOR or ACCENT_COLOR})
                tween:Play()
                callback(isToggled)
            end)
        end

        -- Function to create a slider
        function tabElements:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local sliderName = sliderConfig.Name or "Slider"
            local min = sliderConfig.Min or 0
            local max = sliderConfig.Max or 100
            local default = sliderConfig.Default or min
            local callback = sliderConfig.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -20, 0, 60)
            SliderFrame.Position = UDim2.new(0, 10, 0, 0)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = TabContent

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, 0, 0, 20)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderName .. ": " .. default
            SliderLabel.TextColor3 = TEXT_COLOR
            SliderLabel.TextSize = 16
            SliderLabel.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, 0, 0, 10)
            SliderBar.Position = UDim2.new(0, 0, 0, 30)
            SliderBar.BackgroundColor3 = ACCENT_COLOR
            SliderBar.Parent = SliderFrame

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 5)
            SliderCorner.Parent = SliderBar

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = NEON_COLOR
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar

            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(0, 5)
            SliderFillCorner.Parent = SliderFill

            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(0, 20, 0, 20)
            SliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0, -5)
            SliderButton.BackgroundColor3 = NEON_COLOR
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar

            local SliderButtonCorner = Instance.new("UICorner")
            SliderButtonCorner.CornerRadius = UDim.new(0, 10)
            SliderButtonCorner.Parent = SliderButton

            local dragging = false

            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouseX = input.Position.X
                    local sliderX = SliderBar.AbsolutePosition.X
                    local sliderWidth = SliderBar.AbsoluteSize.X
                    local relativeX = math.clamp((mouseX - sliderX) / sliderWidth, 0, 1)
                    local value = min + (max - min) * relativeX
                    value = math.floor(value + 0.5)
                    SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    SliderButton.Position = UDim2.new(relativeX, -10, 0, -5)
                    SliderLabel.Text = sliderName .. ": " .. value
                    callback(value)
                end
            end)
        end

        -- Function to create a dropdown
        function tabElements:CreateDropdown(dropdownConfig)
            dropdownConfig = dropdownConfig or {}
            local dropdownName = dropdownConfig.Name or "Dropdown"
            local options = dropdownConfig.Options or {"Option 1", "Option 2"}
            local default = dropdownConfig.Default or options[1]
            local callback = dropdownConfig.Callback or function() end

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, -20, 0, 40)
            DropdownFrame.Position = UDim2.new(0, 10, 0, 0)
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.Parent = TabContent

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundColor3 = ACCENT_COLOR
            DropdownButton.Text = dropdownName .. ": " .. default
            DropdownButton.TextColor3 = TEXT_COLOR
            DropdownButton.TextSize = 16
            DropdownButton.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
            DropdownButton.Parent = DropdownFrame

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UI_CORNER_RADIUS
            DropdownCorner.Parent = DropdownButton

            local DropdownList = Instance.new("Frame")
            DropdownList.Size = UDim2.new(1, 0, 0, #options * 40)
            DropdownList.Position = UDim2.new(0, 0, 1, 5)
            DropdownList.BackgroundColor3 = ACCENT_COLOR
            DropdownList.Visible = false
            DropdownList.ClipsDescendants = true
            DropdownList.Parent = DropdownFrame

            local DropdownListCorner = Instance.new("UICorner")
            DropdownListCorner.CornerRadius = UI_CORNER_RADIUS
            DropdownListCorner.Parent = DropdownList

            local DropdownListLayout = Instance.new("UIListLayout")
            DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownListLayout.Parent = DropdownList

            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 40)
                OptionButton.BackgroundColor3 = ACCENT_COLOR
                OptionButton.Text = option
                OptionButton.TextColor3 = TEXT_COLOR
                OptionButton.TextSize = 16
                OptionButton.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
                OptionButton.Parent = DropdownList

                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = dropdownName .. ": " .. option
                    DropdownList.Visible = false
                    callback(option)
                end)
            end

            DropdownButton.MouseButton1Click:Connect(function()
                DropdownList.Visible = not DropdownList.Visible
            end)
        end

        -- Function to create a keybind
        function tabElements:CreateKeybind(keybindConfig)
            keybindConfig = keybindConfig or {}
            local keybindName = keybindConfig.Name or "Keybind"
            local defaultKey = keybindConfig.Default or Enum.KeyCode.F
            local callback = keybindConfig.Callback or function() end

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, -20, 0, 40)
            KeybindFrame.Position = UDim2.new(0, 10, 0, 0)
            KeybindFrame.BackgroundTransparency = 1
            KeybindFrame.Parent = TabContent

            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -60, 1, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = keybindName .. ": " .. tostring(defaultKey)
            KeybindLabel.TextColor3 = TEXT_COLOR
            KeybindLabel.TextSize = 16
            KeybindLabel.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame

            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 40, 0, 20)
            KeybindButton.Position = UDim2.new(1, -40, 0.5, -10)
            KeybindButton.BackgroundColor3 = ACCENT_COLOR
            KeybindButton.Text = "..."
            KeybindButton.TextColor3 = TEXT_COLOR
            KeybindButton.TextSize = 16
            KeybindButton.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
            KeybindButton.Parent = KeybindFrame

            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 10)
            KeybindCorner.Parent = KeybindButton

            local currentKey = defaultKey
            local waitingForKey = false

            KeybindButton.MouseButton1Click:Connect(function()
                waitingForKey = true
                KeybindButton.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input)
                if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeybindButton.Text = tostring(currentKey)
                    KeybindLabel.Text = keybindName .. ": " .. tostring(currentKey)
                    waitingForKey = false
                    callback(currentKey)
                end
            end)
        end

        return tabElements
    end

    -- Key system implementation (only if enabled)
    if keySystemEnabled then
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Size = UDim2.new(0, 300, 0, 200)
        KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
        KeyFrame.BackgroundColor3 = BACKGROUND_COLOR
        KeyFrame.BorderSizePixel = 0
        KeyFrame.Parent = ScreenGui

        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UI_CORNER_RADIUS
        KeyCorner.Parent = KeyFrame

        local KeyLabel = Instance.new("TextLabel")
        KeyLabel.Size = UDim2.new(1, 0, 0, 40)
        KeyLabel.BackgroundTransparency = 1
        KeyLabel.Text = "Enter Key"
        KeyLabel.TextColor3 = TEXT_COLOR
        KeyLabel.TextSize = 18
        KeyLabel.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
        KeyLabel.Parent = KeyFrame

        local KeyTextBox = Instance.new("TextBox")
        KeyTextBox.Size = UDim2.new(1, -20, 0, 40)
        KeyTextBox.Position = UDim2.new(0, 10, 0, 60)
        KeyTextBox.BackgroundColor3 = ACCENT_COLOR
        KeyTextBox.Text = ""
        KeyTextBox.TextColor3 = TEXT_COLOR
        KeyTextBox.TextSize = 16
        KeyTextBox.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
        KeyTextBox.Parent = KeyFrame

        local KeyTextBoxCorner = Instance.new("UICorner")
        KeyTextBoxCorner.CornerRadius = UI_CORNER_RADIUS
        KeyTextBoxCorner.Parent = KeyTextBox

        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Size = UDim2.new(1, -20, 0, 40)
        SubmitButton.Position = UDim2.new(0, 10, 0, 120)
        SubmitButton.BackgroundColor3 = NEON_COLOR
        SubmitButton.Text = "Submit"
        SubmitButton.TextColor3 = TEXT_COLOR
        SubmitButton.TextSize = 16
        SubmitButton.Font = Enum.Font.Gotham -- Changed from SourceSansPro to Gotham
        SubmitButton.Parent = KeyFrame

        local SubmitCorner = Instance.new("UICorner")
        SubmitCorner.CornerRadius = UI_CORNER_RADIUS
        SubmitCorner.Parent = SubmitButton

        Window.Visible = false

        SubmitButton.MouseButton1Click:Connect(function()
            if KeyTextBox.Text == KeySystem.Key then
                KeyFrame.Visible = false
                Window.Visible = true
                if KeySystem.SaveKey then
                    -- Simulate saving key (not implemented due to Roblox limitations)
                    print("Key saved (simulation)")
                end
            else
                KeyTextBox.Text = "Invalid Key"
                wait(1)
                KeyTextBox.Text = ""
            end
        end)
    else
        Window.Visible = true -- Show window immediately if key system is disabled
    end

    return tabs
end

-- Toggle UI visibility with a keybind (default: RightShift)
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        ScreenGui.Enabled = uiVisible
    end
end)

return rbxscriptLib
