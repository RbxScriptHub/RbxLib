--[[
    RBH - RbxScriptHub
    Modern, dynamic, and futuristic UI library for Roblox script hubs
    Version 1.0.0
]]

local RBH = {}
RBH.__index = RBH
RBH.Version = "1.0.0"

-- Dependencies
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Constants
local DEFAULT_THEME = {
    Primary = Color3.fromRGB(45, 125, 255),
    Secondary = Color3.fromRGB(30, 30, 40),
    Background = Color3.fromRGB(20, 20, 30),
    Text = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(255, 85, 85),
    Success = Color3.fromRGB(85, 255, 85),
    Warning = Color3.fromRGB(255, 255, 85),
    Error = Color3.fromRGB(255, 85, 85),
}

local LIGHT_THEME = {
    Primary = Color3.fromRGB(0, 100, 255),
    Secondary = Color3.fromRGB(240, 240, 245),
    Background = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(255, 65, 65),
    Success = Color3.fromRGB(65, 200, 65),
    Warning = Color3.fromRGB(220, 180, 0),
    Error = Color3.fromRGB(220, 50, 50),
}

-- Utility functions
local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled and not UserInputService.KeyboardEnabled
end

-- Notification System
local Notification = {}
Notification.__index = Notification

function Notification.new(message, duration, notificationType)
    local self = setmetatable({}, Notification)
    
    self.Message = message
    self.Duration = duration or 5
    self.Type = notificationType or "Default"
    self.Id = HttpService:GenerateGUID(false)
    
    return self
end

function Notification:Show(parent)
    if not parent then return end
    
    local theme = RBH.CurrentTheme
    local colors = {
        Default = theme.Primary,
        Success = theme.Success,
        Warning = theme.Warning,
        Error = theme.Error
    }
    
    local notificationFrame = Create("Frame", {
        Name = "Notification_"..self.Id,
        Parent = parent,
        BackgroundColor3 = colors[self.Type],
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(0.3, 0, 0, 0),
        Position = UDim2.new(1, 10, 1, -10),
        AnchorPoint = Vector2.new(1, 1),
        ClipsDescendants = true
    })
    
    local corner = Create("UICorner", {
        Parent = notificationFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    local stroke = Create("UIStroke", {
        Parent = notificationFrame,
        Color = colors[self.Type],
        Transparency = 0.7,
        Thickness = 1
    })
    
    local textLabel = Create("TextLabel", {
        Parent = notificationFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        Text = self.Message,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Font = Enum.Font.GothamMedium
    })
    
    local closeButton = Create("TextButton", {
        Parent = notificationFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0, 5),
        Text = "×",
        TextColor3 = theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        ZIndex = 2
    })
    
    -- Animation
    notificationFrame.Size = UDim2.new(0.3, 0, 0, 0)
    local textHeight = textLabel.TextBounds.Y + 20
    local targetHeight = math.clamp(textHeight, 50, 200)
    
    Tween(notificationFrame, {
        Size = UDim2.new(0.3, 0, 0, targetHeight)
    }, 0.3)
    
    -- Close functionality
    local function Close()
        Tween(notificationFrame, {
            Size = UDim2.new(0.3, 0, 0, 0)
        }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In):Wait()
        notificationFrame:Destroy()
    end
    
    closeButton.MouseButton1Click:Connect(Close)
    
    if self.Duration > 0 then
        task.delay(self.Duration, Close)
    end
    
    self.Close = Close
    self.Frame = notificationFrame
end

-- Main UI Class
function RBH.new(options)
    options = options or {}
    local self = setmetatable({}, RBH)
    
    -- Configuration
    self.Config = {
        Title = options.Title or "RBH Script Hub",
        Size = options.Size or UDim2.new(0.5, 0, 0.7, 0),
        Position = options.Position or UDim2.new(0.25, 0, 0.15, 0),
        MinSize = options.MinSize or UDim2.new(0.3, 0, 0.4, 0),
        MaxSize = options.MaxSize or UDim2.new(0.9, 0, 0.9, 0),
        Theme = options.Theme or DEFAULT_THEME,
        DefaultDarkTheme = true
    }
    
    RBH.CurrentTheme = self.Config.Theme
    
    -- Create main screen gui
    self.ScreenGui = Create("ScreenGui", {
        Name = "RBH_"..HttpService:GenerateGUID(false),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    if options.Parent then
        self.ScreenGui.Parent = options.Parent
    else
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Main window
    self.MainFrame = Create("Frame", {
        Name = "MainWindow",
        Parent = self.ScreenGui,
        BackgroundColor3 = self.Config.Theme.Background,
        Size = self.Config.Size,
        Position = self.Config.Position,
        ClipsDescendants = true
    })
    
    -- UI Corner
    Create("UICorner", {
        Parent = self.MainFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- UI Stroke
    Create("UIStroke", {
        Parent = self.MainFrame,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    -- Drop shadow
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        Parent = self.MainFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = -1
    })
    
    -- Title bar
    self.TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = self.MainFrame,
        BackgroundColor3 = self.Config.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0
    })
    
    Create("UICorner", {
        Parent = self.TitleBar,
        CornerRadius = UDim.new(0, 12),
        CornerRadii = UDim.new(0, 12, 0, 12, 0, 0, 0, 0)
    })
    
    -- Title text
    self.TitleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.25, 0, 0, 0),
        Text = self.Config.Title,
        TextColor3 = self.Config.Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold
    })
    
    -- Minimized version (only shows RBH logo)
    self.MinimizedFrame = Create("Frame", {
        Name = "Minimized",
        Parent = self.ScreenGui,
        BackgroundColor3 = self.Config.Theme.Secondary,
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(0.5, -30, 0, 10),
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0)
    })
    
    Create("UICorner", {
        Parent = self.MinimizedFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    Create("UIStroke", {
        Parent = self.MinimizedFrame,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    local minimizedLabel = Create("TextLabel", {
        Name = "RBHLogo",
        Parent = self.MinimizedFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "RBH",
        TextColor3 = self.Config.Theme.Primary,
        TextSize = 16,
        Font = Enum.Font.GothamBold
    })
    
    -- Minimize button
    self.MinimizeButton = Create("TextButton", {
        Name = "MinimizeButton",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0, 5),
        Text = "_",
        TextColor3 = self.Config.Theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold
    })
    
    -- Close button
    self.CloseButton = Create("TextButton", {
        Name = "CloseButton",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        Text = "×",
        TextColor3 = self.Config.Theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold
    })
    
    -- Content area
    self.ContentFrame = Create("Frame", {
        Name = "Content",
        Parent = self.MainFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50)
    })
    
    -- Tab system
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Tab buttons container
    self.TabButtonsFrame = Create("Frame", {
        Name = "TabButtons",
        Parent = self.MainFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 45)
    })
    
    -- Notification container
    self.NotificationContainer = Create("Frame", {
        Name = "Notifications",
        Parent = self.ScreenGui,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.3, 0, 0.5, 0),
        Position = UDim2.new(1, -10, 0.5, -10),
        AnchorPoint = Vector2.new(1, 0.5),
        ClipsDescendants = true
    })
    
    -- Initialize drag and resize functionality
    self:InitializeDrag()
    self:InitializeResize()
    
    -- Set up button events
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    minimizedLabel.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Add theme toggle button
    self.ThemeToggle = Create("TextButton", {
        Name = "ThemeToggle",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -105, 0, 5),
        Text = "☀️",
        TextColor3 = self.Config.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold
    })
    
    self.ThemeToggle.MouseButton1Click:Connect(function()
        self:ToggleTheme()
    end)
    
    return self
end

-- Initialize window dragging
function RBH:InitializeDrag()
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function Update(input)
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        -- Keep window within screen bounds
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local windowSize = self.MainFrame.AbsoluteSize
        
        newPosition = UDim2.new(
            math.clamp(newPosition.X.Scale, 0, 1 - windowSize.X/viewportSize.X),
            math.clamp(newPosition.X.Offset, 0, viewportSize.X - windowSize.X),
            math.clamp(newPosition.Y.Scale, 0, 1 - windowSize.Y/viewportSize.Y),
            math.clamp(newPosition.Y.Offset, 0, viewportSize.Y - windowSize.Y)
        )
        
        self.MainFrame.Position = newPosition
    end
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            Update(input)
        end
    end)
end

-- Initialize window resizing
function RBH:InitializeResize()
    local resizing
    local resizeInput
    local resizeStart
    local startSize
    local startPos
    
    local resizeHandle = Create("Frame", {
        Name = "ResizeHandle",
        Parent = self.MainFrame,
        BackgroundColor3 = self.Config.Theme.Primary,
        BackgroundTransparency = 0.8,
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.new(0, 0, 1, -4),
        BorderSizePixel = 0,
        ZIndex = 2
    })
    
    Create("UICorner", {
        Parent = resizeHandle,
        CornerRadius = UDim.new(0, 12),
        CornerRadii = UDim.new(0, 0, 0, 0, 0, 12, 0, 12)
    })
    
    local function Update(input)
        local delta = input.Position - resizeStart
        local newSize = UDim2.new(
            startSize.X.Scale, 
            math.clamp(startSize.X.Offset + delta.X, self.Config.MinSize.X.Offset, self.Config.MaxSize.X.Offset),
            startSize.Y.Scale,
            math.clamp(startSize.Y.Offset + delta.Y, self.Config.MinSize.Y.Offset, self.Config.MaxSize.Y.Offset)
        )
        
        self.MainFrame.Size = newSize
        
        -- Adjust position if window goes out of bounds
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local windowSize = self.MainFrame.AbsoluteSize
        local windowPos = self.MainFrame.AbsolutePosition
        
        if windowPos.X + windowSize.X > viewportSize.X then
            self.MainFrame.Position = UDim2.new(
                self.MainFrame.Position.X.Scale,
                viewportSize.X - windowSize.X,
                self.MainFrame.Position.Y.Scale,
                self.MainFrame.Position.Y.Offset
            )
        end
        
        if windowPos.Y + windowSize.Y > viewportSize.Y then
            self.MainFrame.Position = UDim2.new(
                self.MainFrame.Position.X.Scale,
                self.MainFrame.Position.X.Offset,
                self.MainFrame.Position.Y.Scale,
                viewportSize.Y - windowSize.Y
            )
        end
    end
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = self.MainFrame.Size
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)
    
    resizeHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            resizeInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == resizeInput and resizing then
            Update(input)
        end
    end)
end

-- Toggle minimize/restore
function RBH:ToggleMinimize()
    if self.MinimizedFrame.Visible then
        -- Restore
        self.MinimizedFrame.Visible = false
        self.MainFrame.Visible = true
        
        Tween(self.MainFrame, {
            Size = self.Config.Size,
            Position = self.Config.Position
        }, 0.3)
    else
        -- Minimize
        local minimizedPos = UDim2.new(0.5, -30, 0, 10)
        
        Tween(self.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = minimizedPos
        }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In):Wait()
        
        self.MainFrame.Visible = false
        self.MinimizedFrame.Visible = true
    end
end

-- Toggle light/dark theme
function RBH:ToggleTheme()
    self.Config.DefaultDarkTheme = not self.Config.DefaultDarkTheme
    self:ApplyTheme(self.Config.DefaultDarkTheme and DEFAULT_THEME or LIGHT_THEME)
end

-- Apply theme to all elements
function RBH:ApplyTheme(theme)
    RBH.CurrentTheme = theme
    
    -- Main window
    self.MainFrame.BackgroundColor3 = theme.Background
    self.MainFrame.UIStroke.Color = theme.Primary
    
    -- Title bar
    self.TitleBar.BackgroundColor3 = theme.Secondary
    
    -- Text elements
    self.TitleLabel.TextColor3 = theme.Text
    self.MinimizeButton.TextColor3 = theme.Text
    self.CloseButton.TextColor3 = theme.Text
    self.ThemeToggle.TextColor3 = theme.Text
    
    -- Minimized frame
    self.MinimizedFrame.BackgroundColor3 = theme.Secondary
    self.MinimizedFrame.UIStroke.Color = theme.Primary
    self.MinimizedFrame.RBHLogo.TextColor3 = theme.Primary
    
    -- Update all tabs and elements
    for _, tab in pairs(self.Tabs) do
        if tab.ApplyTheme then
            tab:ApplyTheme(theme)
        end
    end
end

-- Add a new tab
function RBH:AddTab(name, icon)
    local tab = {}
    tab.Name = name or "Tab "..(#self.Tabs + 1)
    tab.Icon = icon
    
    -- Tab button
    tab.Button = Create("TextButton", {
        Name = "TabButton_"..tab.Name,
        Parent = self.TabButtonsFrame,
        BackgroundColor3 = self.Config.Theme.Secondary,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, (#self.Tabs * 105), 0, 0),
        Text = tab.Name,
        TextColor3 = self.Config.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false
    })
    
    Create("UICorner", {
        Parent = tab.Button,
        CornerRadius = UDim.new(0, 6)
    })
    
    Create("UIStroke", {
        Parent = tab.Button,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    -- Tab content
    tab.Content = Create("ScrollingFrame", {
        Name = "TabContent_"..tab.Name,
        Parent = self.ContentFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = self.Config.Theme.Primary,
        ScrollBarImageTransparency = 0.7,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false
    })
    
    local layout = Create("UIListLayout", {
        Parent = tab.Content,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Button hover effects
    tab.Button.MouseEnter:Connect(function()
        Tween(tab.Button, {
            BackgroundTransparency = 0.5,
            TextColor3 = self.Config.Theme.Primary
        }, 0.2)
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if tab == self.CurrentTab then
            Tween(tab.Button, {
                BackgroundTransparency = 0.3,
                TextColor3 = self.Config.Theme.Primary
            }, 0.2)
        else
            Tween(tab.Button, {
                BackgroundTransparency = 0.7,
                TextColor3 = self.Config.Theme.Text
            }, 0.2)
        end
    end)
    
    -- Tab selection
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    -- Add to tabs list
    table.insert(self.Tabs, tab)
    
    -- Select first tab if none selected
    if not self.CurrentTab then
        self:SelectTab(tab)
    end
    
    -- Update tab buttons position
    self:UpdateTabButtons()
    
    return tab
end

-- Update tab buttons position
function RBH:UpdateTabButtons()
    local totalWidth = #self.Tabs * 105 - 5
    local startX = (self.TabButtonsFrame.AbsoluteSize.X - totalWidth) / 2
    
    for i, tab in ipairs(self.Tabs) do
        tab.Button.Position = UDim2.new(0, startX + (i-1)*105, 0, 0)
    end
end

-- Select a tab
function RBH:SelectTab(tab)
    if self.CurrentTab == tab then return end
    
    -- Deselect current tab
    if self.CurrentTab then
        Tween(self.CurrentTab.Button, {
            BackgroundTransparency = 0.7,
            TextColor3 = self.Config.Theme.Text
        }, 0.2)
        
        self.CurrentTab.Content.Visible = false
    end
    
    -- Select new tab
    self.CurrentTab = tab
    
    Tween(tab.Button, {
        BackgroundTransparency = 0.3,
        TextColor3 = self.Config.Theme.Primary
    }, 0.2)
    
    tab.Content.Visible = true
    
    -- Animation
    tab.Content.Size = UDim2.new(1, -20, 1, 0)
    tab.Content.Position = UDim2.new(0, 20, 0, 0)
    tab.Content.BackgroundTransparency = 1
    
    Tween(tab.Content, {
        Position = UDim2.new(0, 0, 0, 0)
    }, 0.3)
end

-- Add a button to a tab
function RBH:AddButton(tab, options)
    options = options or {}
    
    local button = Create("TextButton", {
        Name = options.Name or "Button",
        Parent = tab.Content,
        BackgroundColor3 = self.Config.Theme.Secondary,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 40),
        Text = options.Text or "Button",
        TextColor3 = self.Config.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false
    })
    
    Create("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, 6)
    })
    
    Create("UIStroke", {
        Parent = button,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        Tween(button, {
            BackgroundTransparency = 0.5,
            TextColor3 = self.Config.Theme.Primary
        }, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Tween(button, {
            BackgroundTransparency = 0.7,
            TextColor3 = self.Config.Theme.Text
        }, 0.2)
    end)
    
    -- Click effect
    button.MouseButton1Down:Connect(function()
        Tween(button, {
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.new(1, 1, 1)
        }, 0.1)
    end)
    
    button.MouseButton1Up:Connect(function()
        Tween(button, {
            BackgroundTransparency = 0.5,
            TextColor3 = self.Config.Theme.Primary
        }, 0.2)
    end)
    
    -- Callback
    if options.Callback then
        button.MouseButton1Click:Connect(function()
            options.Callback()
        end)
    end
    
    return button
end

-- Add a toggle to a tab
function RBH:AddToggle(tab, options)
    options = options or {}
    options.Default = options.Default or false
    
    local toggle = Create("Frame", {
        Name = options.Name or "Toggle",
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Parent = toggle,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = options.Text or "Toggle",
        TextColor3 = self.Config.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamMedium
    })
    
    local toggleFrame = Create("Frame", {
        Name = "ToggleFrame",
        Parent = toggle,
        BackgroundColor3 = self.Config.Theme.Secondary,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(0.25, 0, 0.6, 0),
        Position = UDim2.new(0.75, 0, 0.2, 0),
        AnchorPoint = Vector2.new(1, 0)
    })
    
    Create("UICorner", {
        Parent = toggleFrame,
        CornerRadius = UDim.new(1, 0)
    })
    
    Create("UIStroke", {
        Parent = toggleFrame,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    local toggleButton = Create("Frame", {
        Name = "ToggleButton",
        Parent = toggleFrame,
        BackgroundColor3 = options.Default and self.Config.Theme.Primary or self.Config.Theme.Text,
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = options.Default and UDim2.new(0.6, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0, 0)
    })
    
    Create("UICorner", {
        Parent = toggleButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- State
    local state = options.Default
    
    local function UpdateToggle()
        if state then
            Tween(toggleButton, {
                Position = UDim2.new(0.6, 0, 0, 0),
                BackgroundColor3 = self.Config.Theme.Primary
            }, 0.2)
            
            Tween(toggleFrame.UIStroke, {
                Color = self.Config.Theme.Primary
            }, 0.2)
        else
            Tween(toggleButton, {
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = self.Config.Theme.Text
            }, 0.2)
            
            Tween(toggleFrame.UIStroke, {
                Color = self.Config.Theme.Text
            }, 0.2)
        end
    end
    
    -- Click functionality
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            state = not state
            UpdateToggle()
            
            if options.Callback then
                options.Callback(state)
            end
        end
    end)
    
    -- Getter function
    function toggle:GetValue()
        return state
    end
    
    -- Setter function
    function toggle:SetValue(value)
        state = value
        UpdateToggle()
    end
    
    return toggle
end

-- Add a slider to a tab
function RBH:AddSlider(tab, options)
    options = options or {}
    options.Min = options.Min or 0
    options.Max = options.Max or 100
    options.Default = options.Default or options.Min
    options.Precision = options.Precision or 1
    
    local slider = Create("Frame", {
        Name = options.Name or "Slider",
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50)
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Parent = slider,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        Text = options.Text or ("Slider: "..options.Default),
        TextColor3 = self.Config.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamMedium
    })
    
    local sliderTrack = Create("Frame", {
        Name = "SliderTrack",
        Parent = slider,
        BackgroundColor3 = self.Config.Theme.Secondary,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 0, 25)
    })
    
    Create("UICorner", {
        Parent = sliderTrack,
        CornerRadius = UDim.new(1, 0)
    })
    
    Create("UIStroke", {
        Parent = sliderTrack,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    local sliderFill = Create("Frame", {
        Name = "SliderFill",
        Parent = sliderTrack,
        BackgroundColor3 = self.Config.Theme.Primary,
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    })
    
    Create("UICorner", {
        Parent = sliderFill,
        CornerRadius = UDim.new(1, 0)
    })
    
    local sliderButton = Create("TextButton", {
        Name = "SliderButton",
        Parent = sliderTrack,
        BackgroundColor3 = self.Config.Theme.Text,
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(0, 0, 0.5, -7.5),
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(0, 0.5)
    })
    
    Create("UICorner", {
        Parent = sliderButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    Create("UIStroke", {
        Parent = sliderButton,
        Color = self.Config.Theme.Primary,
        Thickness = 1
    })
    
    -- Initial value
    local value = math.clamp(options.Default, options.Min, options.Max)
    local percent = (value - options.Min) / (options.Max - options.Min)
    
    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    sliderButton.Position = UDim2.new(percent, -7.5, 0.5, 0)
    label.Text = options.Text and (options.Text..": "..value) or ("Slider: "..value)
    
    -- Dragging functionality
    local dragging = false
    
    local function UpdateSlider(input)
        local x = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
        x = math.clamp(x, 0, 1)
        
        percent = x
        value = math.floor((options.Min + (options.Max - options.Min) * percent) / options.Precision * options.Precision
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -7.5, 0.5, 0)
        label.Text = options.Text and (options.Text..": "..value) or ("Slider: "..value)
        
        if options.Callback then
            options.Callback(value)
        end
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            
            -- Highlight
            Tween(sliderButton, {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(percent, -9, 0.5, 0)
            }, 0.1)
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            
            -- Unhighlight
            Tween(sliderButton, {
                Size = UDim2.new(0, 15, 0, 15),
                Position = UDim2.new(percent, -7.5, 0.5, 0)
            }, 0.1)
        end
    end)
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    -- Getter function
    function slider:GetValue()
        return value
    end
    
    -- Setter function
    function slider:SetValue(newValue)
        value = math.clamp(newValue, options.Min, options.Max)
        percent = (value - options.Min) / (options.Max - options.Min)
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -7.5, 0.5, 0)
        label.Text = options.Text and (options.Text..": "..value) or ("Slider: "..value)
    end
    
    return slider
end

-- Add a dropdown to a tab
function RBH:AddDropdown(tab, options)
    options = options or {}
    options.Options = options.Options or {"Option 1", "Option 2"}
    options.Default = options.Default or options.Options[1]
    
    local dropdown = Create("Frame", {
        Name = options.Name or "Dropdown",
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    local mainButton = Create("TextButton", {
        Name = "MainButton",
        Parent = dropdown,
        BackgroundColor3 = self.Config.Theme.Secondary,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 30),
        Text = options.Default,
        TextColor3 = self.Config.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false
    })
    
    Create("UICorner", {
        Parent = mainButton,
        CornerRadius = UDim.new(0, 6)
    })
    
    Create("UIStroke", {
        Parent = mainButton,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    local arrow = Create("TextLabel", {
        Name = "Arrow",
        Parent = mainButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        Text = "▼",
        TextColor3 = self.Config.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium
    })
    
    local optionsFrame = Create("ScrollingFrame", {
        Name = "Options",
        Parent = dropdown,
        BackgroundColor3 = self.Config.Theme.Secondary,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 35),
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = self.Config.Theme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ClipsDescendants = true
    })
    
    Create("UICorner", {
        Parent = optionsFrame,
        CornerRadius = UDim.new(0, 6)
    })
    
    Create("UIStroke", {
        Parent = optionsFrame,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    local layout = Create("UIListLayout", {
        Parent = optionsFrame,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- State
    local open = false
    local selected = options.Default
    
    -- Create options
    local function CreateOptions()
        optionsFrame:ClearAllChildren()
        
        for i, option in ipairs(options.Options) do
            local optionButton = Create("TextButton", {
                Name = "Option_"..option,
                Parent = optionsFrame,
                BackgroundColor3 = self.Config.Theme.Secondary,
                BackgroundTransparency = 0.7,
                Size = UDim2.new(1, -10, 0, 25),
                Position = UDim2.new(0, 5, 0, (i-1)*30),
                Text = option,
                TextColor3 = self.Config.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false
            })
            
            Create("UICorner", {
                Parent = optionButton,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Hover effect
            optionButton.MouseEnter:Connect(function()
                Tween(optionButton, {
                    BackgroundTransparency = 0.5,
                    TextColor3 = self.Config.Theme.Primary
                }, 0.2)
            end)
            
            optionButton.MouseLeave:Connect(function()
                Tween(optionButton, {
                    BackgroundTransparency = 0.7,
                    TextColor3 = self.Config.Theme.Text
                }, 0.2)
            end)
            
            -- Select option
            optionButton.MouseButton1Click:Connect(function()
                selected = option
                mainButton.Text = selected
                open = false
                
                Tween(optionsFrame, {
                    Size = UDim2.new(1, 0, 0, 0)
                }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Wait()
                
                optionsFrame.Visible = false
                
                if options.Callback then
                    options.Callback(selected)
                end
            end)
        end
        
        -- Update canvas size
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            optionsFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
    end
    
    CreateOptions()
    
    -- Toggle dropdown
    mainButton.MouseButton1Click:Connect(function()
        open = not open
        
        if open then
            optionsFrame.Visible = true
            local height = math.min(#options.Options * 30 + 10, 150)
            
            Tween(optionsFrame, {
                Size = UDim2.new(1, 0, 0, height)
            }, 0.2)
        else
            Tween(optionsFrame, {
                Size = UDim2.new(1, 0, 0, 0)
            }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Wait()
            
            optionsFrame.Visible = false
        end
    end)
    
    -- Hover effect
    mainButton.MouseEnter:Connect(function()
        Tween(mainButton, {
            BackgroundTransparency = 0.5,
            TextColor3 = self.Config.Theme.Primary
        }, 0.2)
    end)
    
    mainButton.MouseLeave:Connect(function()
        Tween(mainButton, {
            BackgroundTransparency = 0.7,
            TextColor3 = self.Config.Theme.Text
        }, 0.2)
    end)
    
    -- Getter function
    function dropdown:GetValue()
        return selected
    end
    
    -- Setter function
    function dropdown:SetValue(value)
        if table.find(options.Options, value) then
            selected = value
            mainButton.Text = selected
            
            if options.Callback then
                options.Callback(selected)
            end
        end
    end
    
    -- Update options
    function dropdown:UpdateOptions(newOptions)
        options.Options = newOptions
        CreateOptions()
    end
    
    return dropdown
end

-- Add a textbox to a tab
function RBH:AddTextBox(tab, options)
    options = options or {}
    options.Placeholder = options.Placeholder or "Enter text..."
    options.Default = options.Default or ""
    
    local textBox = Create("Frame", {
        Name = options.Name or "TextBox",
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Parent = textBox,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        Text = options.Text or "Text Input:",
        TextColor3 = self.Config.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamMedium
    })
    
    local inputFrame = Create("Frame", {
        Name = "InputFrame",
        Parent = textBox,
        BackgroundColor3 = self.Config.Theme.Secondary,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 25)
    })
    
    Create("UICorner", {
        Parent = inputFrame,
        CornerRadius = UDim.new(0, 6)
    })
    
    Create("UIStroke", {
        Parent = inputFrame,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    local actualTextBox = Create("TextBox", {
        Name = "TextBox",
        Parent = inputFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        Text = options.Default,
        PlaceholderText = options.Placeholder,
        TextColor3 = self.Config.Theme.Text,
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        ClearTextOnFocus = false
    })
    
    -- Focus effects
    actualTextBox.Focused:Connect(function()
        Tween(inputFrame, {
            BackgroundTransparency = 0.5,
        }, 0.2)
        
        Tween(inputFrame.UIStroke, {
            Color = self.Config.Theme.Primary,
            Transparency = 0.5
        }, 0.2)
    end)
    
    actualTextBox.FocusLost:Connect(function()
        Tween(inputFrame, {
            BackgroundTransparency = 0.7,
        }, 0.2)
        
        Tween(inputFrame.UIStroke, {
            Color = self.Config.Theme.Primary,
            Transparency = 0.7
        }, 0.2)
        
        if options.Callback then
            options.Callback(actualTextBox.Text)
        end
    end)
    
    -- Getter function
    function textBox:GetValue()
        return actualTextBox.Text
    end
    
    -- Setter function
    function textBox:SetValue(value)
        actualTextBox.Text = value
    end
    
    return textBox
end

-- Add a keybind to a tab
function RBH:AddKeybind(tab, options)
    options = options or {}
    options.Default = options.Default or Enum.KeyCode.Unknown
    
    local keybind = Create("Frame", {
        Name = options.Name or "Keybind",
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Parent = keybind,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = options.Text or "Keybind:",
        TextColor3 = self.Config.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamMedium
    })
    
    local keyButton = Create("TextButton", {
        Name = "KeyButton",
        Parent = keybind,
        BackgroundColor3 = self.Config.Theme.Secondary,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(0.25, 0, 0.8, 0),
        Position = UDim2.new(0.75, 0, 0.1, 0),
        Text = tostring(options.Default):gsub("Enum.KeyCode.", ""),
        TextColor3 = self.Config.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false
    })
    
    Create("UICorner", {
        Parent = keyButton,
        CornerRadius = UDim.new(0, 6)
    })
    
    Create("UIStroke", {
        Parent = keyButton,
        Color = self.Config.Theme.Primary,
        Transparency = 0.7,
        Thickness = 1
    })
    
    -- State
    local listening = false
    local currentKey = options.Default
    
    -- Hover effect
    keyButton.MouseEnter:Connect(function()
        Tween(keyButton, {
            BackgroundTransparency = 0.5,
            TextColor3 = self.Config.Theme.Primary
        }, 0.2)
    end)
    
    keyButton.MouseLeave:Connect(function()
        if not listening then
            Tween(keyButton, {
                BackgroundTransparency = 0.7,
                TextColor3 = self.Config.Theme.Text
            }, 0.2)
        end
    end)
    
    -- Keybind functionality
    keyButton.MouseButton1Click:Connect(function()
        listening = true
        keyButton.Text = "..."
        
        Tween(keyButton, {
            BackgroundTransparency = 0.3,
            TextColor3 = self.Config.Theme.Accent
        }, 0.2)
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keyButton.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
                
                if options.Callback then
                    options.Callback(currentKey)
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                currentKey = Enum.KeyCode.Unknown
                keyButton.Text = "None"
                
                if options.Callback then
                    options.Callback(currentKey)
                end
            end
            
            listening = false
            connection:Disconnect()
            
            Tween(keyButton, {
                BackgroundTransparency = 0.7,
                TextColor3 = self.Config.Theme.Text
            }, 0.2)
        end)
    end)
    
    -- Getter function
    function keybind:GetValue()
        return currentKey
    end
    
    -- Setter function
    function keybind:SetValue(keyCode)
        currentKey = keyCode
        keyButton.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
    end
    
    return keybind
end

-- Add a label to a tab
function RBH:AddLabel(tab, options)
    options = options or {}
    
    local label = Create("TextLabel", {
        Name = options.Name or "Label",
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, options.Height or 20),
        Text = options.Text or "Label",
        TextColor3 = self.Config.Theme.Text,
        TextSize = options.TextSize or 14,
        TextXAlignment = options.XAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = options.YAlignment or Enum.TextYAlignment.Center,
        Font = Enum.Font.GothamMedium,
        TextWrapped = options.Wrapped or false
    })
    
    if options.Center then
        label.TextXAlignment = Enum.TextXAlignment.Center
    end
    
    return label
end

-- Add a separator to a tab
function RBH:AddSeparator(tab, options)
    options = options or {}
    
    local separator = Create("Frame", {
        Name = options.Name or "Separator",
        Parent = tab.Content,
        BackgroundColor3 = self.Config.Theme.Primary,
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0
    })
    
    return separator
end

-- Show a notification
function RBH:Notify(message, duration, notificationType)
    local notification = Notification.new(message, duration, notificationType)
    notification:Show(self.NotificationContainer)
    return notification
end

-- Destroy the UI
function RBH:Destroy()
    self.ScreenGui:Destroy()
    setmetatable(self, nil)
end

-- Game detection and script loading
function RBH:LoadGameScripts()
    local placeId = game.PlaceId
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
    
    -- Add a tab for game-specific scripts
    local gameTab = self:AddTab(gameName)
    
    -- Add a label with game info
    self:AddLabel(gameTab, {
        Text = "Detected Game: "..gameName.." ("..placeId..")",
        TextSize = 16,
        Height = 30
    })
    
    -- Add a separator
    self:AddSeparator(gameTab)
    
    -- Add script loader
    local scriptLoader = self:AddTextBox(gameTab, {
        Text = "Load Script from URL:",
        Placeholder = "Paste script URL here...",
        Height = 60
    })
    
    local loadButton = self:AddButton(gameTab, {
        Text = "Load Script",
        Callback = function()
            local url = scriptLoader:GetValue()
            if url and url ~= "" then
                self:Notify("Loading script from URL...", 2, "Success")
                
                -- In a real implementation, you would load the script here
                -- For example: loadstring(game:HttpGet(url))()
                
                -- This is just a placeholder for demonstration
                task.delay(1, function()
                    self:Notify("Script loaded successfully!", 3, "Success")
                end)
            else
                self:Notify("Please enter a valid URL", 3, "Error")
            end
        end
    })
    
    -- Add favorite scripts section
    local favoritesLabel = self:AddLabel(gameTab, {
        Text = "Favorite Scripts:",
        TextSize = 16,
        Height = 30
    })
    
    -- Example favorite scripts (in a real implementation, these would be saved)
    local exampleScripts = {
        {Name = "Infinite Yield", Description = "Admin commands"},
        {Name = "Dark Dex", Description = "Explorer tool"},
        {Name = "Simple Spy", Description = "Remote spy"}
    }
    
    for _, scriptInfo in pairs(exampleScripts) do
        local scriptFrame = self:AddButton(gameTab, {
            Text = scriptInfo.Name.." - "..scriptInfo.Description,
            Callback = function()
                self:Notify("Loading "..scriptInfo.Name.."...", 2, "Default")
                
                -- In a real implementation, you would load the script here
                task.delay(1, function()
                    self:Notify(scriptInfo.Name.." loaded!", 3, "Success")
                end)
            end
        })
    end
end

return RBH
