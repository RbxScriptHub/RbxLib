-- RbxScriptHub (RBH) UI Library
-- Version: 1.0.0
-- Optimized for Roblox Executors (Synapse, Fluxus, etc.)
-- Author: Grok (Generated for xAI)

local RBH = {}
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Theme Configuration
RBH.Themes = {
    Dark = {
        Primary = Color3.fromRGB(30, 30, 50),
        Secondary = Color3.fromRGB(40, 40, 70),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(60, 60, 90),
        Notification = Color3.fromRGB(50, 50, 80)
    },
    Light = {
        Primary = Color3.fromRGB(240, 240, 255),
        Secondary = Color3.fromRGB(220, 220, 240),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(0, 0, 0),
        Border = Color3.fromRGB(180, 180, 200),
        Notification = Color3.fromRGB(200, 200, 220)
    }
}
RBH.CurrentTheme = RBH.Themes.Dark

-- Core UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RBH_ScreenGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Animation Utility
local function createTween(instance, properties, duration, easingStyle)
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Draggable Window
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

-- Notification System
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Size = UDim2.new(0, 300, 0, 400)
NotificationContainer.Position = UDim2.new(1, -310, 1, -410)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

function RBH:CreateNotification(message, duration)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 280, 0, 60)
    notification.Position = UDim2.new(0, 0, 1, 0)
    notification.BackgroundColor3 = RBH.CurrentTheme.Notification
    notification.BackgroundTransparency = 0.3
    notification.BorderColor3 = RBH.CurrentTheme.Border
    notification.Parent = NotificationContainer

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 1, -20)
    text.Position = UDim2.new(0, 10, 0, 10)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = RBH.CurrentTheme.Text
    text.TextScaled = true
    text.Parent = notification

    createTween(notification, {Position = UDim2.new(0, 0, 0, -70)}, 0.5, Enum.EasingStyle.Sine)
    wait(duration or 3)
    createTween(notification, {BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, -100)}, 0.5, Enum.EasingStyle.Sine)
    wait(0.5)
    notification:Destroy()
end

-- Main Window
function RBH:CreateWindow(title)
    local window = {}
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = RBH.CurrentTheme.Primary
    mainFrame.BorderColor3 = RBH.CurrentTheme.Border
    mainFrame.Parent = ScreenGui
    makeDraggable(mainFrame)

    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = RBH.CurrentTheme.Secondary
    titleBar.Text = title
    titleBar.TextColor3 = RBH.CurrentTheme.Text
    titleBar.Font = Enum.Font.SourceSansBold
    titleBar.TextSize = 18
    titleBar.Parent = mainFrame

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -30, 0, 0)
    minimizeButton.BackgroundColor3 = RBH.CurrentTheme.Accent
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = RBH.CurrentTheme.Text
    minimizeButton.Parent = titleBar

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 50, 0, 50)
    logo.Position = UDim2.new(0.5, -25, 0, 10)
    logo.BackgroundColor3 = RBH.CurrentTheme.Primary
    logo.Text = "RBH"
    logo.TextColor3 = RBH.CurrentTheme.Text
    logo.Font = Enum.Font.SourceSansBold
    logo.TextSize = 24
    logo.Visible = false
    logo.Parent = ScreenGui

    local isMinimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            createTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
            logo.Visible = true
            createTween(logo, {BackgroundTransparency = 0}, 0.3)
        else
            createTween(mainFrame, {Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0}, 0.3)
            createTween(logo, {BackgroundTransparency = 1}, 0.3)
            wait(0.3)
            logo.Visible = false
        end
    end)

    logo.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isMinimized then
            isMinimized = false
            createTween(mainFrame, {Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0}, 0.3)
            createTween(logo, {BackgroundTransparency = 1}, 0.3)
            wait(0.3)
            logo.Visible = false
        end
    end)

    -- Tab System
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 100, 1, -30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = RBH.CurrentTheme.Secondary
    tabContainer.Parent = mainFrame

    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, -100, 1, -30)
    tabContent.Position = UDim2.new(0, 100, 0, 30)
    tabContent.BackgroundColor3 = RBH.CurrentTheme.Primary
    tabContent.Parent = mainFrame

    local tabs = {}
    function window:AddTab(name)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Position = UDim2.new(0, 0, 0, #tabs * 40)
        tabButton.BackgroundColor3 = RBH.CurrentTheme.Secondary
        tabButton.Text = name
        tabButton.TextColor3 = RBH.CurrentTheme.Text
        tabButton.Parent = tabContainer

        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = tabContent

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.Frame.Visible = false
                createTween(t.Button, {BackgroundColor3 = RBH.CurrentTheme.Secondary}, 0.2)
            end
            tabFrame.Visible = true
            createTween(tabButton, {BackgroundColor3 = RBH.CurrentTheme.Accent}, 0.2)
        end)

        tab.Button = tabButton
        tab.Frame = tabFrame
        table.insert(tabs, tab)
        return tab
    end

    -- Component Creators
    function window:AddButton(tab, text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 0, 30)
        button.Position = UDim2.new(0, 10, 0, #tab.Frame:GetChildren() * 40)
        button.BackgroundColor3 = RBH.CurrentTheme.Accent
        button.Text = text
        button.TextColor3 = RBH.CurrentTheme.Text
        button.Parent = tab.Frame
        button.MouseButton1Click:Connect(callback)
        button.MouseEnter:Connect(function()
            createTween(button, {BackgroundColor3 = RBH.CurrentTheme.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.2)}, 0.2)
        end)
        button.MouseLeave:Connect(function()
            createTween(button, {BackgroundColor3 = RBH.CurrentTheme.Accent}, 0.2)
        end)
    end

    function window:AddToggle(tab, text, callback)
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 100, 0, 30)
        toggle.Position = UDim2.new(0, 10, 0, #tab.Frame:GetChildren() * 40)
        toggle.BackgroundColor3 = RBH.CurrentTheme.Secondary
        toggle.Text = text .. ": OFF"
        toggle.TextColor3 = RBH.CurrentTheme.Text
        toggle.Parent = tab.Frame
        local state = false
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.Text = text .. ": " .. (state and "ON" or "OFF")
            createTween(toggle, {BackgroundColor3 = state and RBH.CurrentTheme.Accent or RBH.CurrentTheme.Secondary}, 0.2)
            callback(state)
        end)
    end

    function window:AddTextBox(tab, placeholder, callback)
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0, 150, 0, 30)
        textBox.Position = UDim2.new(0, 10, 0, #tab.Frame:GetChildren() * 40)
        textBox.BackgroundColor3 = RBH.CurrentTheme.Secondary
        textBox.TextColor3 = RBH.CurrentTheme.Text
        textBox.PlaceholderText = placeholder
        textBox.Parent = tab.Frame
        textBox.FocusLost:Connect(function()
            callback(textBox.Text)
        end)
    end

    function window:AddSlider(tab, text, min, max, callback)
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(0, 150, 0, 30)
        slider.Position = UDim2.new(0, 10, 0, #tab.Frame:GetChildren() * 40)
        slider.BackgroundColor3 = RBH.CurrentTheme.Secondary
        slider.Parent = tab.Frame

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = RBH.CurrentTheme.Accent
        fill.Parent = slider

        local value = min
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = UserInputService:GetMouseLocation()
                local relativeX = (mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
                value = min + (max - min) * relativeX
                createTween(fill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
                callback(value)
            end
        end)
    end

    -- Script Loader
    local favoriteScripts = {}
    function window:AddScriptLoader(tab)
        local scriptInput = Instance.new("TextBox")
        scriptInput.Size = UDim2.new(0, 200, 0, 30)
        scriptInput.Position = UDim2.new(0, 10, 0, #tab.Frame:GetChildren() * 40)
        scriptInput.BackgroundColor3 = RBH.CurrentTheme.Secondary
        scriptInput.TextColor3 = RBH.CurrentTheme.Text
        scriptInput.PlaceholderText = "Enter Script URL"
        scriptInput.Parent = tab.Frame

        local loadButton = Instance.new("TextButton")
        loadButton.Size = UDim2.new(0, 100, 0, 30)
        loadButton.Position = UDim2.new(0, 220, 0, #tab.Frame:GetChildren() * 40)
        loadButton.BackgroundColor3 = RBH.CurrentTheme.Accent
        loadButton.Text = "Load"
        loadButton.TextColor3 = RBH.CurrentTheme.Text
        loadButton.Parent = tab.Frame

        loadButton.MouseButton1Click:Connect(function()
            local success, result = pcall(function()
                local script = HttpService:GetAsync(scriptInput.Text)
                loadstring(script)()
                RBH:CreateNotification("Script loaded successfully!")
            end)
            if not success then
                RBH:CreateNotification("Failed to load script: " .. result)
            end
        end)
    end

    -- Theme Switcher
    function window:SetTheme(theme)
        RBH.CurrentTheme = RBH.Themes[theme] or RBH.CurrentTheme
        mainFrame.BackgroundColor3 = RBH.CurrentTheme.Primary
        titleBar.BackgroundColor3 = RBH.CurrentTheme.Secondary
        tabContainer.BackgroundColor3 = RBH.CurrentTheme.Secondary
        tabContent.BackgroundColor3 = RBH.CurrentTheme.Primary
        for _, tab in pairs(tabs) do
            tab.Button.BackgroundColor3 = RBH.CurrentTheme.Secondary
        end
    end

    return window
end

-- Game Detection
function RBH:DetectGame()
    local placeId = game.PlaceId
    RBH:CreateNotification("Detected Game PlaceId: " .. placeId)
    -- Placeholder for script suggestion logic
end

-- Keyboard/Controller Support
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end
end)

return RBH
