local UI = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function UI:CreateWindow(title, size, position, verifyKeyCallback)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "RbxScriptUI_" .. title:gsub("%s+", "_")

    -- Key System Frame (Centered Modal with Futuristic Loading Animation)
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 300, 0, 180)
    KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = ScreenGui
    KeyFrame.Visible = true

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 10)
    KeyCorner.Parent = KeyFrame

    local KeyGradient = Instance.new("UIGradient")
    KeyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 15, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 25, 35))
    })
    KeyGradient.Rotation = 45
    KeyGradient.Parent = KeyFrame

    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Thickness = 2
    KeyStroke.Color = Color3.fromRGB(0, 200, 255)
    KeyStroke.Transparency = 0.5
    KeyStroke.Parent = KeyFrame

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 40)
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
    KeyTitle.Text = "RbxScript Key Verification"
    KeyTitle.TextSize = 20
    KeyTitle.Font = Enum.Font.SourceSansBold
    KeyTitle.TextXAlignment = Enum.TextXAlignment.Center
    KeyTitle.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.9, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.05, 0, 0, 50)
    KeyInput.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    KeyInput.TextColor3 = Color3.fromRGB(220, 220, 220)
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter your key here"
    KeyInput.TextSize = 14
    KeyInput.Font = Enum.Font.SourceSans
    KeyInput.Parent = KeyFrame

    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.CornerRadius = UDim.new(0, 6)
    KeyInputCorner.Parent = KeyInput

    local KeySubmit = Instance.new("TextButton")
    KeySubmit.Size = UDim2.new(0.4, 0, 0, 30)
    KeySubmit.Position = UDim2.new(0.3, 0, 0, 100)
    KeySubmit.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    KeySubmit.TextColor3 = Color3.fromRGB(10, 15, 25)
    KeySubmit.Text = "Submit"
    KeySubmit.TextSize = 14
    KeySubmit.Font = Enum.Font.SourceSans
    KeySubmit.Parent = KeyFrame

    local KeySubmitCorner = Instance.new("UICorner")
    KeySubmitCorner.CornerRadius = UDim.new(0, 6)
    KeySubmitCorner.Parent = KeySubmit

    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0.9, 0, 0, 5)
    LoadingBar.Position = UDim2.new(0.05, 0, 0, 140)
    LoadingBar.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    LoadingBar.Visible = false
    LoadingBar.Parent = KeyFrame

    local LoadingBarCorner = Instance.new("UICorner")
    LoadingBarCorner.CornerRadius = UDim.new(0, 3)
    LoadingBarCorner.Parent = LoadingBar

    local LoadingFill = Instance.new("Frame")
    LoadingFill.Size = UDim2.new(0, 0, 1, 0)
    LoadingFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    LoadingFill.Parent = LoadingBar

    local LoadingFillCorner = Instance.new("UICorner")
    LoadingFillCorner.CornerRadius = UDim.new(0, 3)
    LoadingFillCorner.Parent = LoadingFill

    -- Main Window Frame
    local Frame = Instance.new("Frame")
    Frame.Size = size or UDim2.new(0, 600, 0, 400)
    Frame.Position = position or UDim2.new(0.5, -300, 0.5, -200)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true
    Frame.ClipsDescendants = true
    Frame.Visible = false

    local FrameGradient = Instance.new("UIGradient")
    FrameGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 15, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 25, 35))
    })
    FrameGradient.Rotation = 45
    FrameGradient.Parent = Frame

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Thickness = 2
    FrameStroke.Color = Color3.fromRGB(0, 200, 255)
    FrameStroke.Transparency = 0.5
    FrameStroke.Parent = Frame

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 150))
    })
    TitleGradient.Rotation = 90
    TitleGradient.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TitleLabel.Text = "RbxScript - " .. title
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    TitleLabel.Parent = TitleBar

    -- Main Content Area
    local MainContent = Instance.new("Frame")
    MainContent.Size = UDim2.new(1, 0, 1, -30)
    MainContent.Position = UDim2.new(0, 0, 0, 30)
    MainContent.BackgroundTransparency = 1
    MainContent.Parent = Frame

    -- Tab Navigation (Left Side)
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 150, 1, 0)
    TabContainer.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainContent

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Vertical
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabContainer

    -- Content Area (Right Side)
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -150, 1, 0)
    ContentFrame.Position = UDim2.new(0, 150, 0, 0)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ClipsDescendants = true
    ContentFrame.Parent = MainContent

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentFrame

    -- Notification Area
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(0, 250, 0, 60)
    NotificationFrame.Position = UDim2.new(0.5, -125, 0.05, 0)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Parent = ScreenGui
    NotificationFrame.Visible = false

    local NotificationCorner = Instance.new("UICorner")
    NotificationCorner.CornerRadius = UDim.new(0, 8)
    NotificationCorner.Parent = NotificationFrame

    local NotificationLabel = Instance.new("TextLabel")
    NotificationLabel.Size = UDim2.new(1, -20, 1, -10)
    NotificationLabel.Position = UDim2.new(0, 10, 0, 5)
    NotificationLabel.BackgroundTransparency = 1
    NotificationLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    NotificationLabel.Text = ""
    NotificationLabel.TextSize = 16
    NotificationLabel.Font = Enum.Font.SourceSans
    NotificationLabel.TextWrapped = true
    NotificationLabel.TextXAlignment = Enum.TextXAlignment.Left
    NotificationLabel.Parent = NotificationFrame

    -- Resize Handles
    local MinSize = Vector2.new(400, 300)
    local MaxSize = Vector2.new(800, 600)

    local RightHandle = Instance.new("Frame")
    RightHandle.Size = UDim2.new(0, 10, 1, 0)
    RightHandle.Position = UDim2.new(1, -10, 0, 0)
    RightHandle.BackgroundTransparency = 1
    RightHandle.Parent = Frame

    local BottomHandle = Instance.new("Frame")
    BottomHandle.Size = UDim2.new(1, 0, 0, 10)
    BottomHandle.Position = UDim2.new(0, 0, 1, -10)
    BottomHandle.BackgroundTransparency = 1
    BottomHandle.Parent = Frame

    local Window = {
        ScreenGui = ScreenGui,
        Frame = Frame,
        KeyFrame = KeyFrame,
        TabContainer = TabContainer,
        ContentFrame = ContentFrame,
        Tabs = {},
        CurrentTab = nil,
        NotificationFrame = NotificationFrame,
        NotificationLabel = NotificationLabel,
        IsMinimized = false,
        Keybind = Enum.KeyCode.Insert,
        ThemeColor = Color3.fromRGB(0, 200, 255),
        Elements = {}
    }

    -- Key System Submit with Loading Animation
    KeySubmit.MouseButton1Click:Connect(function()
        local key = KeyInput.Text
        KeyInput.Visible = false
        KeySubmit.Visible = false
        LoadingBar.Visible = true
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(LoadingFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
        tween:Play()
        tween.Completed:Connect(function()
            if verifyKeyCallback(key) then
                KeyFrame.Visible = false
                Frame.Visible = true
                Window:ShowNotification("Key verified successfully!", 2)
            else
                Window:ShowNotification("Invalid key!", 3)
                KeyInput.Text = ""
                KeyInput.Visible = true
                KeySubmit.Visible = true
                LoadingBar.Visible = false
                LoadingFill.Size = UDim2.new(0, 0, 1, 0)
            end
        end)
    end)

    -- Toggle UI Visibility with Fade Animation
    function Window:ToggleVisibility()
        local targetTransparency = self.Frame.BackgroundTransparency == 0.1 and 1 or 0.1
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenService:Create(self.Frame, tweenInfo, {BackgroundTransparency = targetTransparency}):Play()
        for _, child in pairs(self.Frame:GetDescendants()) do
            if child:IsA("GuiObject") then
                TweenService:Create(child, tweenInfo, {BackgroundTransparency = targetTransparency}):Play()
            end
        end
    end

    -- Resize Logic
    local resizingRight = false
    local resizingBottom = false

    RightHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizingRight = true
        end
    end)

    RightHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizingRight = false
        end
    end)

    BottomHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizingBottom = true
        end
    end)

    BottomHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizingBottom = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local framePos = Frame.AbsolutePosition
            local newSize = Frame.AbsoluteSize

            if resizingRight then
                newSize = Vector2.new(
                    math.clamp(mousePos.X - framePos.X, MinSize.X, MaxSize.X),
                    newSize.Y
                )
                Frame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
                ContentFrame.Size = UDim2.new(1, -150, 1, -30)
            end

            if resizingBottom then
                newSize = Vector2.new(
                    newSize.X,
                    math.clamp(mousePos.Y - framePos.Y, MinSize.Y, MaxSize.Y)
                )
                Frame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
                TabContainer.Size = UDim2.new(0, 150, 1, -30)
                ContentFrame.Size = UDim2.new(1, -150, 1, -30)
            end
        end
    end)

    function Window:ShowNotification(message, duration)
        self.NotificationLabel.Text = message
        self.NotificationFrame.Visible = true
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        TweenService:Create(self.NotificationFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
        spawn(function()
            wait(duration or 3)
            local tweenOut = TweenService:Create(self.NotificationFrame, tweenInfo, {BackgroundTransparency = 1})
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                self.NotificationFrame.Visible = false
            end)
        end)
    end

    function Window:Minimize()
        if self.IsMinimized then
            self.Frame.Size = size or UDim2.new(0, 600, 0, 400)
            self.TabContainer.Visible = true
            self.ContentFrame.Visible = true
            self.IsMinimized = false
        else
            self.Frame.Size = UDim2.new(0, self.Frame.AbsoluteSize.X, 0, 30)
            self.TabContainer.Visible = false
            self.ContentFrame.Visible = false
            self.IsMinimized = true
        end
    end

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 230)
    MinimizeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    MinimizeButton.Text = "-"
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.SourceSans
    MinimizeButton.Parent = TitleBar

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton

    MinimizeButton.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)

    function Window:SetKeybind(keybind)
        self.Keybind = keybind
    end

    function Window:SetThemeColor(color)
        self.ThemeColor = color
        TitleBar.BackgroundColor3 = color
        MinimizeButton.BackgroundColor3 = color:Lerp(Color3.fromRGB(0, 20, 40), 0.3)
        self.NotificationLabel.TextColor3 = color
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
        for _, element in pairs(self.Elements) do
            if element.Type == "TabButton" then
                element.Button.TextColor3 = element.Button.BackgroundColor3 == color and Color3.fromRGB(220, 220, 220) or Color3.fromRGB(180, 180, 180)
                element.Stroke.Color = color
            elseif element.Type == "Button" then
                element.Button.TextColor3 = color
                element.Stroke.Color = color
            elseif element.Type == "Checkbox" then
                element.Label.TextColor3 = color
                element.Checkbox.BackgroundColor3 = element.Value and color or Color3.fromRGB(50, 50, 50)
            elseif element.Type == "Slider" then
                element.Label.TextColor3 = color
                element.Fill.BackgroundColor3 = color
                element.SliderButton.BackgroundColor3 = color
            elseif element.Type == "Keybind" then
                element.Label.TextColor3 = color
                element.Button.TextColor3 = color
                element.Stroke.Color = color
            elseif element.Type == "ColorPicker" then
                element.Label.TextColor3 = color
                element.RLabel.TextColor3 = color
                element.GLabel.TextColor3 = color
                element.BLabel.TextColor3 = color
                element.RFill.BackgroundColor3 = color
                element.GFill.BackgroundColor3 = color
                element.BFill.BackgroundColor3 = color
                element.RSliderButton.BackgroundColor3 = color
                element.GSliderButton.BackgroundColor3 = color
                element.BSliderButton.BackgroundColor3 = color
            elseif element.Type == "Dropdown" then
                element.Label.TextColor3 = color
                element.DropdownButton.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
                element.DropdownButton.TextColor3 = color
            elseif element.Type == "TextInput" then
                element.Label.TextColor3 = color
                element.Input.TextColor3 = color
                element.Input.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
            elseif element.Type == "Label" then
                element.Label.TextColor3 = color
            elseif element.Type == "ProgressBar" then
                element.Label.TextColor3 = color
                element.Fill.BackgroundColor3 = color
            end
        end
    end

    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.Text = name
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.SourceSans
        TabButton.Parent = TabContainer
        TabButton.BorderSizePixel = 0

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Thickness = 1
        TabStroke.Color = self.ThemeColor
        TabStroke.Transparency = 0.7
        TabStroke.Parent = TabButton

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = self.ThemeColor
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentFrame

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.Parent = TabContent

        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
        end)

        local Tab = { Content = TabContent }
        self.Tabs[name] = Tab
        table.insert(self.Elements, { Type = "TabButton", Button = TabButton, Stroke = TabStroke })

        TabButton.MouseButton1Click:Connect(function()
            if self.CurrentTab then
                self.CurrentTab.Content.Visible = false
            end
            TabContent.Visible = true
            self.CurrentTab = Tab
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn == TabButton and self.ThemeColor or Color3.fromRGB(30, 30, 30)
                    btn.TextColor3 = btn == TabButton and Color3.fromRGB(220, 220, 220) or Color3.fromRGB(180, 180, 180)
                    for _, element in pairs(self.Elements) do
                        if element.Type == "TabButton" and element.Button == btn then
                            element.Stroke.Color = self.ThemeColor
                        end
                    end
                end
            end
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(TabContent, tweenInfo, {ScrollBarImageTransparency = 0}):Play()
        end)

        return Tab
    end

    function Window:CreateButton(tab, name, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -20, 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.TextColor3 = self.ThemeColor
        Button.Text = name
        Button.TextSize = 14
        Button.Font = Enum.Font.SourceSans
        Button.Parent = tab.Content
        Button.BorderSizePixel = 0

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = Button

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Thickness = 1
        UIStroke.Color = self.ThemeColor
        UIStroke.Transparency = 0.7
        UIStroke.Parent = Button

        Button.MouseButton1Click:Connect(function()
            callback()
            local tween = TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
            tween:Play()
            tween.Completed:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            end)
        end)
        table.insert(self.Elements, { Type = "Button", Button = Button, Stroke = UIStroke })
        return Button
    end

    function Window:CreateCheckbox(tab, name, default, callback)
        local CheckboxFrame = Instance.new("Frame")
        CheckboxFrame.Size = UDim2.new(1, -20, 0, 40)
        CheckboxFrame.BackgroundTransparency = 1
        CheckboxFrame.Parent = tab.Content

        local CheckboxLabel = Instance.new("TextLabel")
        CheckboxLabel.Size = UDim2.new(0.8, 0, 1, 0)
        CheckboxLabel.BackgroundTransparency = 1
        CheckboxLabel.TextColor3 = self.ThemeColor
        CheckboxLabel.Text = name
        CheckboxLabel.TextSize = 14
        CheckboxLabel.Font = Enum.Font.SourceSans
        CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        CheckboxLabel.Parent = CheckboxFrame

        local Checkbox = Instance.new("TextButton")
        Checkbox.Size = UDim2.new(0, 20, 0, 20)
        Checkbox.Position = UDim2.new(0.9, -10, 0.5, -10)
        Checkbox.BackgroundColor3 = default and self.ThemeColor or Color3.fromRGB(50, 50, 50)
        Checkbox.Text = ""
        Checkbox.Parent = CheckboxFrame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Checkbox

        local value = default
        Checkbox.MouseButton1Click:Connect(function()
            value = not value
            Checkbox.BackgroundColor3 = value and self.ThemeColor or Color3.fromRGB(50, 50, 50)
            callback(value)
        end)

        table.insert(self.Elements, { Type = "Checkbox", Checkbox = Checkbox, Label = CheckboxLabel, Value = value })
        return Checkbox
    end

    function Window:CreateSlider(tab, name, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -20, 0, 60)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = tab.Content

        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(1, 0, 0, 20)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.TextColor3 = self.ThemeColor
        SliderLabel.Text = name .. ": " .. tostring(default)
        SliderLabel.TextSize = 14
        SliderLabel.Font = Enum.Font.SourceSans
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame

        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -10, 0, 10)
        SliderBar.Position = UDim2.new(0, 5, 0, 30)
        SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SliderBar.Parent = SliderFrame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = SliderBar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = self.ThemeColor
        Fill.Parent = SliderBar

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(0, 5)
        FillCorner.Parent = Fill

        local SliderButton = Instance.new("TextButton")
        SliderButton.Size = UDim2.new(0, 20, 0, 20)
        SliderButton.Position = UDim2.new((default - min) / (max - min), -10, -0.5, -5)
        SliderButton.BackgroundColor3 = self.ThemeColor
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
                local barX = SliderBar.AbsolutePosition.X
                local barWidth = SliderBar.AbsoluteSize.X
                local relativeX = math.clamp((mouseX - barX) / barWidth, 0, 1)
                local value = min + (max - min) * relativeX
                value = math.round(value * 10) / 10
                Fill.Size = UDim2.new(relativeX, 0, 1, 0)
                SliderButton.Position = UDim2.new(relativeX, -10, -0.5, -5)
                SliderLabel.Text = name .. ": " .. tostring(value)
                callback(value)
            end
        end)

        table.insert(self.Elements, { Type = "Slider", Label = SliderLabel, Fill = Fill, SliderButton = SliderButton })
        return SliderFrame
    end

    function Window:CreateKeybind(tab, name, default, callback)
        local KeybindFrame = Instance.new("Frame")
        KeybindFrame.Size = UDim2.new(1, -20, 0, 40)
        KeybindFrame.BackgroundTransparency = 1
        KeybindFrame.Parent = tab.Content

        local KeybindLabel = Instance.new("TextLabel")
        KeybindLabel.Size = UDim2.new(0.8, 0, 1, 0)
        KeybindLabel.BackgroundTransparency = 1
        KeybindLabel.TextColor3 = self.ThemeColor
        KeybindLabel.Text = name .. ": " .. tostring(default.Name)
        KeybindLabel.TextSize = 14
        KeybindLabel.Font = Enum.Font.SourceSans
        KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
        KeybindLabel.Parent = KeybindFrame

        local KeybindButton = Instance.new("TextButton")
        KeybindButton.Size = UDim2.new(0, 60, 0, 30)
        KeybindButton.Position = UDim2.new(0.9, -10, 0.5, -15)
        KeybindButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        KeybindButton.TextColor3 = self.ThemeColor
        KeybindButton.Text = "Set"
        KeybindButton.TextSize = 12
        KeybindButton.Font = Enum.Font.SourceSans
        KeybindButton.Parent = KeybindFrame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = KeybindButton

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Thickness = 1
        UIStroke.Color = self.ThemeColor
        UIStroke.Transparency = 0.7
        UIStroke.Parent = KeybindButton

        local waitingForKey = false
        KeybindButton.MouseButton1Click:Connect(function()
            waitingForKey = true
            KeybindButton.Text = "Press a key..."
            self:ShowNotification("Press a key to set the keybind", 2)
        end)

        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard and not gameProcessed then
                local key = input.KeyCode
                KeybindButton.Text = "Set"
                KeybindLabel.Text = name .. ": " .. key.Name
                waitingForKey = false
                self:SetKeybind(key)
                callback(key)
                connection:Disconnect()
            end
        end)

        table.insert(self.Elements, { Type = "Keybind", Label = KeybindLabel, Button = KeybindButton, Stroke = UIStroke })
        return KeybindFrame
    end

    function Window:CreateColorPicker(tab, name, default, callback)
        local ColorPickerFrame = Instance.new("Frame")
        ColorPickerFrame.Size = UDim2.new(1, -20, 0, 140)
        ColorPickerFrame.BackgroundTransparency = 1
        ColorPickerFrame.Parent = tab.Content

        local ColorLabel = Instance.new("TextLabel")
        ColorLabel.Size = UDim2.new(1, 0, 0, 20)
        ColorLabel.BackgroundTransparency = 1
        ColorLabel.TextColor3 = self.ThemeColor
        ColorLabel.Text = name
        ColorLabel.TextSize = 14
        ColorLabel.Font = Enum.Font.SourceSans
        ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
        ColorLabel.Parent = ColorPickerFrame

        -- R Slider
        local RLabel = Instance.new("TextLabel")
        RLabel.Size = UDim2.new(1, 0, 0, 20)
        RLabel.Position = UDim2.new(0, 0, 0, 20)
        RLabel.BackgroundTransparency = 1
        RLabel.TextColor3 = self.ThemeColor
        RLabel.Text = "R: " .. math.floor(default.R * 255)
        RLabel.TextSize = 12
        RLabel.Font = Enum.Font.SourceSans
        RLabel.TextXAlignment = Enum.TextXAlignment.Left
        RLabel.Parent = ColorPickerFrame

        local RSliderBar = Instance.new("Frame")
        RSliderBar.Size = UDim2.new(1, -10, 0, 10)
        RSliderBar.Position = UDim2.new(0, 5, 0, 40)
        RSliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        RSliderBar.Parent = ColorPickerFrame

        local RCorner = Instance.new("UICorner")
        RCorner.CornerRadius = UDim.new(0, 5)
        RCorner.Parent = RSliderBar

        local RFill = Instance.new("Frame")
        RFill.Size = UDim2.new(default.R, 0, 1, 0)
        RFill.BackgroundColor3 = self.ThemeColor
        RFill.Parent = RSliderBar

        local RFillCorner = Instance.new("UICorner")
        RFillCorner.CornerRadius = UDim.new(0, 5)
        RFillCorner.Parent = RFill

        local RSliderButton = Instance.new("TextButton")
        RSliderButton.Size = UDim2.new(0, 20, 0, 20)
        RSliderButton.Position = UDim2.new(default.R, -10, -0.5, -5)
        RSliderButton.BackgroundColor3 = self.ThemeColor
        RSliderButton.Text = ""
        RSliderButton.Parent = RSliderBar

        local RSliderButtonCorner = Instance.new("UICorner")
        RSliderButtonCorner.CornerRadius = UDim.new(0, 10)
        RSliderButtonCorner.Parent = RSliderButton

        -- G Slider
        local GLabel = Instance.new("TextLabel")
        GLabel.Size = UDim2.new(1, 0, 0, 20)
        GLabel.Position = UDim2.new(0, 0, 0, 60)
        GLabel.BackgroundTransparency = 1
        GLabel.TextColor3 = self.ThemeColor
        GLabel.Text = "G: " .. math.floor(default.G * 255)
        GLabel.TextSize = 12
        GLabel.Font = Enum.Font.SourceSans
        GLabel.TextXAlignment = Enum.TextXAlignment.Left
        GLabel.Parent = ColorPickerFrame

        local GSliderBar = Instance.new("Frame")
        GSliderBar.Size = UDim2.new(1, -10, 0, 10)
        GSliderBar.Position = UDim2.new(0, 5, 0, 80)
        GSliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        GSliderBar.Parent = ColorPickerFrame

        local GCorner = Instance.new("UICorner")
        GCorner.CornerRadius = UDim.new(0, 5)
        GCorner.Parent = GSliderBar

        local GFill = Instance.new("Frame")
        GFill.Size = UDim2.new(default.G, 0, 1, 0)
        GFill.BackgroundColor3 = self.ThemeColor
        GFill.Parent = GSliderBar

        local GFillCorner = Instance.new("UICorner")
        GFillCorner.CornerRadius = UDim.new(0, 5)
        GFillCorner.Parent = GFill

        local GSliderButton = Instance.new("TextButton")
        GSliderButton.Size = UDim2.new(0, 20, 0, 20)
        GSliderButton.Position = UDim2.new(default.G, -10, -0.5, -5)
        GSliderButton.BackgroundColor3 = self.ThemeColor
        GSliderButton.Text = ""
        GSliderButton.Parent = GSliderBar

        local GSliderButtonCorner = Instance.new("UICorner")
        GSliderButtonCorner.CornerRadius = UDim.new(0, 10)
        GSliderButtonCorner.Parent = GSliderButton

        -- B Slider
        local BLabel = Instance.new("TextLabel")
        BLabel.Size = UDim2.new(1, 0, 0, 20)
        BLabel.Position = UDim2.new(0, 0, 0, 100)
        BLabel.BackgroundTransparency = 1
        BLabel.TextColor3 = self.ThemeColor
        BLabel.Text = "B: " .. math.floor(default.B * 255)
        BLabel.TextSize = 12
        BLabel.Font = Enum.Font.SourceSans
        BLabel.TextXAlignment = Enum.TextXAlignment.Left
        BLabel.Parent = ColorPickerFrame

        local BSliderBar = Instance.new("Frame")
        BSliderBar.Size = UDim2.new(1, -10, 0, 10)
        BSliderBar.Position = UDim2.new(0, 5, 0, 120)
        BSliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        BSliderBar.Parent = ColorPickerFrame

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 5)
        BCorner.Parent = BSliderBar

        local BFill = Instance.new("Frame")
        BFill.Size = UDim2.new(default.B, 0, 1, 0)
        BFill.BackgroundColor3 = self.ThemeColor
        BFill.Parent = BSliderBar

        local BFillCorner = Instance.new("UICorner")
        BFillCorner.CornerRadius = UDim.new(0, 5)
        BFillCorner.Parent = BFill

        local BSliderButton = Instance.new("TextButton")
        BSliderButton.Size = UDim2.new(0, 20, 0, 20)
        BSliderButton.Position = UDim2.new(default.B, -10, -0.5, -5)
        BSliderButton.BackgroundColor3 = self.ThemeColor
        BSliderButton.Text = ""
        BSliderButton.Parent = BSliderBar

        local BSliderButtonCorner = Instance.new("UICorner")
        BSliderButtonCorner.CornerRadius = UDim.new(0, 10)
        BSliderButtonCorner.Parent = BSliderButton

        local r, g, b = default.R * 255, default.G * 255, default.B * 255

        local function updateColor()
            local color = Color3.fromRGB(r, g, b)
            callback(color)
            self:SetThemeColor(color)
        end

        local draggingR = false
        RSliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingR = true
            end
        end)

        RSliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingR = false
            end
        end)

        local draggingG = false
        GSliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingG = true
            end
        end)

        GSliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingG = false
            end
        end)

        local draggingB = false
        BSliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingB = true
            end
        end)

        BSliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingB = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouseX = input.Position.X
                if draggingR then
                    local barX = RSliderBar.AbsolutePosition.X
                    local barWidth = RSliderBar.AbsoluteSize.X
                    local relativeX = math.clamp((mouseX - barX) / barWidth, 0, 1)
                    r = math.round(relativeX * 255)
                    RFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    RSliderButton.Position = UDim2.new(relativeX, -10, -0.5, -5)
                    RLabel.Text = "R: " .. r
                    updateColor()
                end
                if draggingG then
                    local barX = GSliderBar.AbsolutePosition.X
                    local barWidth = GSliderBar.AbsoluteSize.X
                    local relativeX = math.clamp((mouseX - barX) / barWidth, 0, 1)
                    g = math.round(relativeX * 255)
                    GFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    GSliderButton.Position = UDim2.new(relativeX, -10, -0.5, -5)
                    GLabel.Text = "G: " .. g
                    updateColor()
                end
                if draggingB then
                    local barX = BSliderBar.AbsolutePosition.X
                    local barWidth = BSliderBar.AbsoluteSize.X
                    local relativeX = math.clamp((mouseX - barX) / barWidth, 0, 1)
                    b = math.round(relativeX * 255)
                    BFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    BSliderButton.Position = UDim2.new(relativeX, -10, -0.5, -5)
                    BLabel.Text = "B: " .. b
                    updateColor()
                end
            end
        end)

        table.insert(self.Elements, {
            Type = "ColorPicker",
            Label = ColorLabel,
            RLabel = RLabel,
            GLabel = GLabel,
            BLabel = BLabel,
            RFill = RFill,
            GFill = GFill,
            BFill = BFill,
            RSliderButton = RSliderButton,
            GSliderButton = GSliderButton,
            BSliderButton = BSliderButton
        })
        return ColorPickerFrame
    end

    function Window:CreateDropdown(tab, name, options, default, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, -20, 0, 40)
        DropdownFrame.BackgroundTransparency = 1
        DropdownFrame.Parent = tab.Content

        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Size = UDim2.new(0.8, 0, 1, 0)
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.TextColor3 = self.ThemeColor
        DropdownLabel.Text = name .. ": " .. default
        DropdownLabel.TextSize = 14
        DropdownLabel.Font = Enum.Font.SourceSans
        DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        DropdownLabel.Parent = DropdownFrame

        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Size = UDim2.new(0, 60, 0, 30)
        DropdownButton.Position = UDim2.new(0.9, -10, 0.5, -15)
        DropdownButton.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
        DropdownButton.TextColor3 = self.ThemeColor
        DropdownButton.Text = "Select"
        DropdownButton.TextSize = 12
        DropdownButton.Font = Enum.Font.SourceSans
        DropdownButton.Parent = DropdownFrame

        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 6)
        DropdownCorner.Parent = DropdownButton

        local DropdownList = Instance.new("Frame")
        DropdownList.Size = UDim2.new(0, 100, 0, #options * 30)
        DropdownList.Position = UDim2.new(0.9, -110, 0.5, 15)
        DropdownList.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
        DropdownList.Visible = false
        DropdownList.Parent = DropdownFrame

        local ListCorner = Instance.new("UICorner")
        ListCorner.CornerRadius = UDim.new(0, 6)
        ListCorner.Parent = DropdownList

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.FillDirection = Enum.FillDirection.Vertical
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = DropdownList

        for _, option in pairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
            OptionButton.TextColor3 = Color3.fromRGB(220, 220, 220)
            OptionButton.Text = option
            OptionButton.TextSize = 12
            OptionButton.Font = Enum.Font.SourceSans
            OptionButton.Parent = DropdownList

            OptionButton.MouseButton1Click:Connect(function()
                DropdownLabel.Text = name .. ": " .. option
                DropdownList.Visible = false
                callback(option)
            end)
        end

        DropdownButton.MouseButton1Click:Connect(function()
            DropdownList.Visible = not DropdownList.Visible
        end)

        table.insert(self.Elements, { Type = "Dropdown", Label = DropdownLabel, DropdownButton = DropdownButton })
        return DropdownFrame
    end

    function Window:CreateTextInput(tab, name, default, callback)
        local TextInputFrame = Instance.new("Frame")
        TextInputFrame.Size = UDim2.new(1, -20, 0, 40)
        TextInputFrame.BackgroundTransparency = 1
        TextInputFrame.Parent = tab.Content

        local TextInputLabel = Instance.new("TextLabel")
        TextInputLabel.Size = UDim2.new(0.8, 0, 1, 0)
        TextInputLabel.BackgroundTransparency = 1
        TextInputLabel.TextColor3 = self.ThemeColor
        TextInputLabel.Text = name
        TextInputLabel.TextSize = 14
        TextInputLabel.Font = Enum.Font.SourceSans
        TextInputLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextInputLabel.Parent = TextInputFrame

        local TextInput = Instance.new("TextBox")
        TextInput.Size = UDim2.new(0, 100, 0, 30)
        TextInput.Position = UDim2.new(0.9, -10, 0.5, -15)
        TextInput.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
        TextInput.TextColor3 = Color3.fromRGB(220, 220, 220)
        TextInput.Text = default
        TextInput.TextSize = 12
        TextInput.Font = Enum.Font.SourceSans
        TextInput.Parent = TextInputFrame

        local TextInputCorner = Instance.new("UICorner")
        TextInputCorner.CornerRadius = UDim.new(0, 6)
        TextInputCorner.Parent = TextInput

        TextInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(TextInput.Text)
            end
        end)

        table.insert(self.Elements, { Type = "TextInput", Label = TextInputLabel, Input = TextInput })
        return TextInputFrame
    end

    function Window:CreateLabel(tab, name)
        local LabelFrame = Instance.new("Frame")
        LabelFrame.Size = UDim2.new(1, -20, 0, 30)
        LabelFrame.BackgroundTransparency = 1
        LabelFrame.Parent = tab.Content

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = self.ThemeColor
        Label.Text = name
        Label.TextSize = 14
        Label.Font = Enum.Font.SourceSans
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = LabelFrame

        table.insert(self.Elements, { Type = "Label", Label = Label })
        return Label
    end

    function Window:CreateProgressBar(tab, name, maxValue, callback)
        local ProgressFrame = Instance.new("Frame")
        ProgressFrame.Size = UDim2.new(1, -20, 0, 40)
        ProgressFrame.BackgroundTransparency = 1
        ProgressFrame.Parent = tab.Content

        local ProgressLabel = Instance.new("TextLabel")
        ProgressLabel.Size = UDim2.new(1, 0, 0, 20)
        ProgressLabel.BackgroundTransparency = 1
        ProgressLabel.TextColor3 = self.ThemeColor
        ProgressLabel.Text = name .. ": 0%"
        ProgressLabel.TextSize = 14
        ProgressLabel.Font = Enum.Font.SourceSans
        ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
        ProgressLabel.Parent = ProgressFrame

        local ProgressBar = Instance.new("Frame")
        ProgressBar.Size = UDim2.new(1, -10, 0, 10)
        ProgressBar.Position = UDim2.new(0, 5, 0, 25)
        ProgressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ProgressBar.Parent = ProgressFrame

        local ProgressBarCorner = Instance.new("UICorner")
        ProgressBarCorner.CornerRadius = UDim.new(0, 5)
        ProgressBarCorner.Parent = ProgressBar

        local ProgressFill = Instance.new("Frame")
        ProgressFill.Size = UDim2.new(0, 0, 1, 0)
        ProgressFill.BackgroundColor3 = self.ThemeColor
        ProgressFill.Parent = ProgressBar

        local ProgressFillCorner = Instance.new("UICorner")
        ProgressFillCorner.CornerRadius = UDim.new(0, 5)
        ProgressFillCorner.Parent = ProgressFill

        local function updateProgress(value)
            local percentage = math.clamp(value / maxValue, 0, 1)
            ProgressFill.Size = UDim2.new(percentage, 0, 1, 0)
            ProgressLabel.Text = name .. ": " .. math.floor(percentage * 100) .. "%"
            callback(value)
        end

        table.insert(self.Elements, { Type = "ProgressBar", Label = ProgressLabel, Fill = ProgressFill })
        return { Frame = ProgressFrame, Update = updateProgress }
    end

    return Window
end

return UI
