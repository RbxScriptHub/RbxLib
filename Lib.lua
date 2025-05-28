local RbxLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Fungsi untuk membuat Window utama
function RbxLib:MakeWindow(config)
    local window = {}
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Name or "RbxLibUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false

    -- Frame utama dengan desain futuristik
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    -- Efek neon dengan UIStroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.4
    stroke.Parent = mainFrame

    -- Corner radius untuk tampilan modern
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    -- Animasi fade-in saat window muncul
    mainFrame.BackgroundTransparency = 1
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0.3}):Play()

    -- Judul window
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Name or "RbxLib"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.TextSize = 26
    title.Font = Enum.Font.Gotham
    title.TextTransparency = 0
    title.Parent = mainFrame

    -- Container untuk tabs
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    -- Layout untuk tabs
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabContainer

    -- Content area untuk elemen tab
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -10, 1, -100)
    contentFrame.Position = UDim2.new(0, 5, 0, 95)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local currentTab = nil

    -- Fungsi untuk membuat Tab
    function window:MakeTab(config)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 0, 30)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        tabButton.BackgroundTransparency = 0.5
        tabButton.Text = config.Name or "Tab"
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        tabButton.TextSize = 16
        tabButton.Font = Enum.Font.Gotham
        tabButton.Parent = tabContainer

        local tabStroke = Instance.new("UIStroke")
        tabStroke.Color = Color3.fromRGB(0, 200, 255)
        tabStroke.Thickness = 1
        tabStroke.Transparency = 0.5
        tabStroke.Parent = tabButton

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton

        -- Frame untuk konten tab
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentFrame

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.Parent = tabContent

        -- Logika switching tab
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            tabContent.Visible = true
            currentTab = tabContent
            TweenService:Create(tabButton, tweenInfo, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(0, 255, 255)}):Play()
        end)

        -- Fungsi untuk membuat Button
        function tab:AddButton(config)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 40)
            button.Position = UDim2.new(0, 5, 0, 0)
            button.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
            button.BackgroundTransparency = 0.4
            button.Text = config.Name or "Button"
            button.TextColor3 = Color3.fromRGB(200, 200, 255)
            button.TextSize = 16
            button.Font = Enum.Font.Gotham
            button.Parent = tabContent

            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = Color3.fromRGB(0, 200, 255)
            buttonStroke.Thickness = 1
            buttonStroke.Transparency = 0.5
            buttonStroke.Parent = button

            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 8)
            buttonCorner.Parent = button

            -- Efek hover
            button.MouseEnter:Connect(function()
                TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(0, 255, 255)}):Play()
            end)
            button.MouseLeave:Connect(function()
                TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(200, 200, 255)}):Play()
            end)

            -- Callback saat diklik
            button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
        end

        -- Fungsi untuk membuat Toggle
        function tab:AddToggle(config)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -10, 0, 40)
            toggleFrame.Position = UDim2.new(0, 5, 0, 0)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = config.Name or "Toggle"
            toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
            toggleLabel.TextSize = 16
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame

            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Position = UDim2.new(0.9, -10, 0.5, -10)
            toggleButton.BackgroundColor3 = config.Default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame

            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 10)
            toggleCorner.Parent = toggleButton

            local toggleStroke = Instance.new("UIStroke")
            toggleStroke.Color = Color3.fromRGB(0, 200, 255)
            toggleStroke.Thickness = 1
            toggleStroke.Transparency = 0.5
            toggleStroke.Parent = toggleButton

            local toggleState = config.Default or false

            toggleButton.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = toggleState and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)}):Play()
                if config.Callback then
                    config.Callback(toggleState)
                end
            end)
        end

        return tab
    end

    -- Fungsi untuk menghancurkan UI
    function window:Destroy()
        screenGui:Destroy()
    end

    return window
end

return RbxLib
