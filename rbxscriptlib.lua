-- RbxScriptHub (RBH) - Modern UI Library for Roblox Script Hub
-- Version: 1.0.0
-- License: MIT
-- GitHub: https://github.com/RbxScriptHub/RbxLib

local RbxScriptHub = {}
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Theme Configuration
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Hover = Color3.fromRGB(50, 50, 65),
    },
    Light = {
        Primary = Color3.fromRGB(240, 240, 240),
        Secondary = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(0, 120, 200),
        Text = Color3.fromRGB(0, 0, 0),
        Hover = Color3.fromRGB(180, 180, 180),
    }
}

local CurrentTheme = Themes.Dark
local UIInstance = nil
local Minimized = false
local Tabs = {}
local Notifications = {}
local FavoriteScripts = {}
local GameScripts = {}

-- Utility Functions
local function createTween(instance, properties, duration, easingStyle)
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main UI Creation
function RbxScriptHub:CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RbxScriptHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui
    UIInstance = ScreenGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = CurrentTheme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Drag Functionality
    local dragging, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -40, 0, 10)
    MinimizeButton.BackgroundColor3 = CurrentTheme.Accent
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = CurrentTheme.Text
    MinimizeButton.Parent = MainFrame

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 5)
    MinimizeCorner.Parent = MinimizeButton

    -- Minimize Logo
    local MinimizeLogo = Instance.new("TextLabel")
    MinimizeLogo.Size = UDim2.new(0, 50, 0, 50)
    MinimizeLogo.Position = UDim2.new(0.5, -25, 0, 10)
    MinimizeLogo.BackgroundTransparency = 1
    MinimizeLogo.Text = "RBH"
    MinimizeLogo.TextColor3 = CurrentTheme.Accent
    MinimizeLogo.TextScaled = true
    MinimizeLogo.Visible = false
    MinimizeLogo.Parent = ScreenGui

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = CurrentTheme.Secondary
    Sidebar.Parent = MainFrame

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.Parent = Sidebar

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -150, 1, -40)
    Content.Position = UDim2.new(0, 150, 0, 40)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- Minimize/Restore Logic
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            createTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            createTween(MainFrame, {BackgroundTransparency = 1}, 0.3)
            MinimizeLogo.Visible = true
            createTween(MinimizeLogo, {TextTransparency = 0}, 0.3)
        else
            createTween(MainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
            createTween(MainFrame, {BackgroundTransparency = 0}, 0.3)
            MinimizeLogo.Visible = false
            createTween(MinimizeLogo, {TextTransparency = 1}, 0.3)
        end
    end)

    MinimizeLogo.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and Minimized then
            Minimized = false
            createTween(MainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
            createTween(MainFrame, {BackgroundTransparency = 0}, 0.3)
            MinimizeLogo.Visible = false
            createTween(MinimizeLogo, {TextTransparency = 1}, 0.3)
        end
    end)

    -- Notification System
    local NotificationContainer = Instance.new("Frame")
    NotificationContainer.Size = UDim2.new(0, 300, 1, 0)
    NotificationContainer.Position = UDim2.new(1, -310, 0, 0)
    NotificationContainer.BackgroundTransparency = 1
    NotificationContainer.Parent = ScreenGui

    local NotificationList = Instance.new("UIListLayout")
    NotificationList.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotificationList.Padding = UDim.new(0, 5)
    NotificationList.Parent = NotificationContainer

    -- Store UI components
    self.MainFrame = MainFrame
    self.Sidebar = Sidebar
    self.Content = Content
    self.NotificationContainer = NotificationContainer
end

-- Tab System
function RbxScriptHub:AddTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -10, 0, 30)
    TabButton.Position = UDim2.new(0, 5, 0, 5)
    TabButton.BackgroundColor3 = CurrentTheme.Secondary
    TabButton.Text = name
    TabButton.TextColor3 = CurrentTheme.Text
    TabButton.Parent = self.Sidebar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 5)
    TabCorner.Parent = TabButton

    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.Parent = self.Content

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContent

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Content.Visible = false
            createTween(tab.Button, {BackgroundColor3 = CurrentTheme.Secondary}, 0.2)
        end
        TabContent.Visible = true
        createTween(TabButton, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
    end)

    TabButton.MouseEnter:Connect(function()
        if not TabContent.Visible then
            createTween(TabButton, {BackgroundColor3 = CurrentTheme.Hover}, 0.2)
        end
    end)

    TabButton.MouseLeave:Connect(function()
        if not TabContent.Visible then
            createTween(TabButton, {BackgroundColor3 = CurrentTheme.Secondary}, 0.2)
        end
    end)

    table.insert(Tabs, {Button = TabButton, Content = TabContent, Name = name})
    return TabContent
end

-- UI Components
function RbxScriptHub:CreateButton(tab, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.BackgroundColor3 = CurrentTheme.Accent
    Button.Text = text
    Button.TextColor3 = CurrentTheme.Text
    Button.Parent = tab

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        createTween(Button, {BackgroundColor3 = CurrentTheme.Hover}, 0.1)
        callback()
        wait(0.1)
        createTween(Button, {BackgroundColor3 = CurrentTheme.Accent}, 0.1)
    end)

    Button.MouseEnter:Connect(function()
        createTween(Button, {BackgroundColor3 = CurrentTheme.Hover}, 0.2)
    end)

    Button.MouseLeave:Connect(function()
        createTween(Button, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
    end)
end

function RbxScriptHub:CreateToggle(tab, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = tab

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = CurrentTheme.Text
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 20)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.BackgroundColor3 = default and CurrentTheme.Accent or CurrentTheme.Secondary
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleButton

    local state = default
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        createTween(ToggleButton, {BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.Secondary}, 0.2)
        callback(state)
    end)
end

function RbxScriptHub:CreateDropdown(tab, text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, -10, 0, 30)
    DropdownFrame.BackgroundColor3 = CurrentTheme.Secondary
    DropdownFrame.Parent = tab

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.Text = text
    DropdownButton.TextColor3 = CurrentTheme.Text
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Parent = DropdownFrame

    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, #options * 30)
    DropdownList.Position = UDim2.new(0, 0, 1, 5)
    DropdownList.BackgroundColor3 = CurrentTheme.Secondary
    DropdownList.Visible = false
    DropdownList.Parent = DropdownFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropdownList

    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.Text = option
        OptionButton.TextColor3 = CurrentTheme.Text
        OptionButton.BackgroundColor3 = CurrentTheme.Secondary
        OptionButton.Parent = DropdownList

        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = option
            DropdownList.Visible = false
            callback(option)
        end)

        OptionButton.MouseEnter:Connect(function()
            createTween(OptionButton, {BackgroundColor3 = CurrentTheme.Hover}, 0.2)
        end)

        OptionButton.MouseLeave:Connect(function()
            createTween(OptionButton, {BackgroundColor3 = CurrentTheme.Secondary}, 0.2)
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
        createTween(DropdownList, {Position = DropdownList.Visible and UDim2.new(0, 0, 1, 5) or UDim2.new(0, 0, 1, 0)}, 0.2)
    end)
end

-- Notification System
function RbxScriptHub:CreateNotification(text, duration)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 250, 0, 60)
    Notification.BackgroundColor3 = CurrentTheme.Primary
    Notification.BackgroundTransparency = 0.2
    Notification.Parent = self.NotificationContainer

    local NotificationCorner = Instance.new("UICorner")
    NotificationCorner.CornerRadius = UDim.new(0, 5)
    NotificationCorner.Parent = Notification

    local NotificationText = Instance.new("TextLabel")
    NotificationText.Size = UDim2.new(1, -10, 1, -10)
    NotificationText.Position = UDim2.new(0, 5, 0, 5)
    NotificationText.BackgroundTransparency = 1
    NotificationText.Text = text
    NotificationText.TextColor3 = CurrentTheme.Text
    NotificationText.TextWrapped = true
    NotificationText.Parent = Notification

    Notification.Position = UDim2.new(1, 260, 1, -70)
    createTween(Notification, {Position = UDim2.new(1, -260, 1, -70)}, 0.3)

    local function destroyNotification()
        createTween(Notification, {Position = UDim2.new(1, 260, 1, -70)}, 0.3)
        wait(0.3)
        Notification:Destroy()
    end

    Notification.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            destroyNotification()
        end
    end)

    if duration then
        spawn(function()
            wait(duration)
            if Notification.Parent then
                destroyNotification()
            end
        end)
    end

    table.insert(Notifications, Notification)
end

-- Theme Switching
function RbxScriptHub:SwitchTheme(themeName)
    CurrentTheme = Themes[themeName] or Themes.Dark
    self.MainFrame.BackgroundColor3 = CurrentTheme.Primary
    for _, tab in pairs(Tabs) do
        tab.Button.BackgroundColor3 = tab.Content.Visible and CurrentTheme.Accent or CurrentTheme.Secondary
    end
    -- Update other components as needed
end

-- Script Loader
function RbxScriptHub:LoadScript(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        self:CreateNotification("Script loaded successfully!", 3)
    else
        self:CreateNotification("Failed to load script: " .. tostring(result), 5)
    end
end

-- Game Detection
function RbxScriptHub:DetectGame()
    local placeId = game.PlaceId
    self:CreateNotification("Detected Game: " .. placeId, 3)
    -- Implement script fetching logic based on placeId
end

-- Keyboard/Controller Support
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F6 then
        RbxScriptHub.MainFrame.Visible = not RbxScriptHub.MainFrame.Visible
    end
end)

return RbxScriptHub
