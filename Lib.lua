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
    mainFrame.Visible = false -- Awalnya disembunyikan jika key system aktif

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

    -- Animasi tween
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    -- Judul window
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Name or "RbxLib"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.TextSize = 26
    title.Font = Enum.Font.Gotham
    title.TextTransparency = 0
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = mainFrame

    -- Tombol Minimize
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -60, 0, 10)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    minimizeButton.BackgroundTransparency = 0.4
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    minimizeButton.TextSize = 20
    minimizeButton.Font = Enum.Font.Gotham
    minimizeButton.Parent = mainFrame

    local minimizeStroke = Instance.new("UIStroke")
    minimizeStroke.Color = Color3.fromRGB(0, 200, 255)
    minimizeStroke.Thickness = 1
    minimizeStroke.Transparency = 0.5
    minimizeStroke.Parent = minimizeButton

    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeButton

    -- Tombol Close
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    closeButton.BackgroundTransparency = 0.4
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.Gotham
    closeButton.Parent = mainFrame

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Color3.fromRGB(255, 0, 0)
    closeStroke.Thickness = 1
    closeStroke.Transparency = 0.5
    closeStroke.Parent = closeButton

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

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
    local isMinimized = false

    -- Logika Minimize
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 450, 0, 50)}):Play()
            tabContainer.Visible = false
            contentFrame.Visible = false
            minimizeButton.Text = "+"
        else
            TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 450, 0, 350)}):Play()
            tabContainer.Visible = true
            contentFrame.Visible = true
            minimizeButton.Text = "-"
        end
    end)

    -- Efek hover untuk minimize
    minimizeButton.MouseEnter:Connect(function()
        TweenService:Create(minimizeButton, tweenInfo, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(0, 255, 255)}):Play()
    end)
    minimizeButton.MouseLeave:Connect(function()
        TweenService:Create(minimizeButton, tweenInfo, {BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(200, 200, 255)}):Play()
    end)

    -- Logika Close
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Efek hover untuk close
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, tweenInfo, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 0, 0)}):Play()
    end)
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, tweenInfo, {BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)

    -- Key System
    if config.UseKeySystem then
        local keyFrame = Instance.new("Frame")
        keyFrame.Size = UDim2.new(0, 300, 0, 200)
        keyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
        keyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        keyFrame.BackgroundTransparency = 0.3
        keyFrame.Parent = screenGui

        local keyStroke = Instance.new("UIStroke")
        keyStroke.Color = Color3.fromRGB(0, 200, 255)
        keyStroke.Thickness = 2
        keyStroke.Transparency = 0.4
        keyStroke.Parent = keyFrame

        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 12)
        keyCorner.Parent = keyFrame

        -- Animasi fade-in untuk key frame
        keyFrame.BackgroundTransparency = 1
        TweenService:Create(keyFrame, tweenInfo, {BackgroundTransparency = 0.3}):Play()

        -- Judul key system
 local keyTitle = Instance.new("TextLabel")
        keyTitle.Size = UDim2.new(1, 0, 0, 40)
        keyTitle.BackgroundTransparency = 1
        keyTitle.Text = "Enter Key"
        keyTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
        keyTitle.TextSize = 22
        keyTitle.Font = Enum.Font.Gotham
        keyTitle.Parent = keyFrame

        -- TextBox untuk input kunci
        local keyInput = Instance.new("TextBox")
        keyInput.Size = UDim2.new(0.8, 0, 0, 40)
        keyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
        keyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        keyInput.BackgroundTransparency = 0.4
        keyInput.Text = ""
        keyInput.PlaceholderText = "Input your key here"
        keyInput.TextColor3 = Color3.fromRGB(200, 200, 255)
        keyInput.TextSize = 16
        keyInput.Font = Enum.Font.Gotham
        keyInput.Parent = keyFrame

        local inputStroke = Instance.new("UIStroke")
        inputStroke.Color = Color3.fromRGB(0, 200, 255)
        inputStroke.Thickness = 1
        inputStroke.Transparency = 0.5
        inputStroke.Parent = keyInput

        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 8)
        inputCorner.Parent = keyInput

        -- Tombol submit
        local submitButton = Instance.new("TextButton")
        submitButton.Size = UDim2.new(0.8, 0, 0, 40)
        submitButton.Position = UDim2.new(0.1, 0, 0.6, 0)
        submitButton.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        submitButton.BackgroundTransparency = 0.4
        submitButton.Text = "Submit"
        submitButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        submitButton.TextSize = 16
        submitButton.Font = Enum.Font.Gotham
        submitButton.Parent = keyFrame

        local submitStroke = Instance.new("UIStroke")
        submitStroke.Color = Color3.fromRGB(0, 200, 255)
        submitStroke.Thickness = 1
        submitStroke.Transparency = 0.5
        submitStroke.Parent = submitButton

        local submitCorner = Instance.new("UICorner")
        submitCorner.CornerRadius = UDim.new(0, 8)
        submitCorner.Parent = submitButton

        -- Efek hover untuk tombol submit
        submitButton.MouseEnter:Connect(function()
            TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(0, 255, 255)}):Play()
        end)
        submitButton.MouseLeave:Connect(function()
            TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(200, 200, 255)}):Play()
        end)

        -- Notifikasi error
        local function showError(message)
            local errorFrame = Instance.new("Frame")
            errorFrame.Size = UDim2.new(0, 250, 0, 100)
            errorFrame.Position = UDim2.new(0.5, -125, 0.5, -50)
            errorFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            errorFrame.BackgroundTransparency = 0.3
            errorFrame.Parent = screenGui

            local errorStroke = Instance.new("UIStroke")
            errorStroke.Color = Color3.fromRGB(255, 0, 0)
            errorStroke.Thickness = 2
            errorStroke.Transparency = 0.4
            errorStroke.Parent = errorFrame

            local errorCorner = Instance.new("UICorner")
            errorCorner.CornerRadius = UDim.new(0, 8)
            errorCorner.Parent = errorFrame

            local errorLabel = Instance.new("TextLabel")
            errorLabel.Size = UDim2.new(1, 0, 1, 0)
            errorLabel.BackgroundTransparency = 1
            errorLabel.Text = message or "Invalid Key!"
            errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            errorLabel.TextSize = 16
            errorLabel.Font = Enum.Font.Gotham
            errorLabel.TextWrapped = true
            errorLabel.Parent = errorFrame

            errorFrame.BackgroundTransparency = 1
            TweenService:Create(errorFrame, tweenInfo, {BackgroundTransparency = 0.3}):Play()
            wait(2)
            TweenService:Create(errorFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
            wait(0.5)
            errorFrame:Destroy()
        end

        -- Logika submit kunci
        submitButton.MouseButton1Click:Connect(function()
            local inputKey = keyInput.Text
            if inputKey == config.CorrectKey then
                keyFrame:Destroy()
                mainFrame.Visible = true
                TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0.3}):Play()
            else
                showError("Invalid Key! Try again.")
                keyInput.Text = ""
            end
        end)
    else
        -- Jika key system tidak aktif, langsung tampilkan UI
        mainFrame.Visible = true
        TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0.3}):Play()
    end

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

        -- Fungsi untuk membuat Keybind Picker
        function tab:AddKeybind(config)
            local keybindFrame = Instance.new("Frame")
            keybindFrame.Size = UDim2.new(1, -10, 0, 40)
            keybindFrame.BackgroundTransparency = 1
            keybindFrame.Parent = tabContent

            local keybindLabel = Instance.new("TextLabel")
            keybindLabel.Size = UDim2.new(0.8, 0, 1, 0)
            keybindLabel.BackgroundTransparency = 1
            keybindLabel.Text = config.Name or "Keybind"
            keybindLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
            keybindLabel.TextSize = 16
            keybindLabel.Font = Enum.Font.Gotham
            keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            keybindLabel.Parent = keybindFrame

            local keybindButton = Instance.new("TextButton")
            keybindButton.Size = UDim2.new(0, 60, 0, 20)
            keybindButton.Position = UDim2.new(0.9, -10, 0.5, -10)
            keybindButton.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
            keybindButton.BackgroundTransparency = 0.4
            keybindButton.Text = config.Default and config.Default.Name or "T"
            keybindButton.TextColor3 = Color3.fromRGB(200, 200, 255)
            keybindButton.TextSize = 14
            keybindButton.Font = Enum.Font.Gotham
            keybindButton.Parent = keybindFrame

            local keybindStroke = Instance.new("UIStroke")
            keybindStroke.Color = Color3.fromRGB(0, 200, 255)
            keybindStroke.Thickness = 1
            keybindStroke.Transparency = 0.5
            keybindStroke.Parent = keybindButton

            local keybindCorner = Instance.new("UICorner")
            keybindCorner.CornerRadius = UDim.new(0, 8)
            keybindCorner.Parent = keybindButton

            local isBinding = false
            local currentKey = config.Default or Enum.KeyCode.T

            -- Efek hover
            keybindButton.MouseEnter:Connect(function()
                TweenService:Create(keybindButton, tweenInfo, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(0, 255, 255)}):Play()
            end)
            keybindButton.MouseLeave:Connect(function()
                TweenService:Create(keybindButton, tweenInfo, {BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(200, 200, 255)}):Play()
            end)

            -- Logika keybind picker
            keybindButton.MouseButton1Click:Connect(function()
                isBinding = true
                keybindButton.Text = "Press a key..."
                local inputConnection
                inputConnection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard and isBinding then
                        currentKey = input.KeyCode
                        keybindButton.Text = input.KeyCode.Name
                        isBinding = false
                        inputConnection:Disconnect()
                        if config.Callback then
                            config.Callback(currentKey)
                        end
                    end
                end)
            end)

            -- Deteksi keybind saat ditekan
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey and not isBinding then
                    if config.Callback then
                        config.Callback(currentKey)
                    end
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
