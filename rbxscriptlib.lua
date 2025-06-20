local RbxScriptHub = {}
RbxScriptHub.__index = RbxScriptHub

local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Theme Module
local Theme = {
    CurrentTheme = "DarkFuturistic",
    Themes = {
        DarkFuturistic = {
            BackgroundColor = Color3.fromRGB(20, 20, 20),
            TextColor = Color3.fromRGB(255, 255, 255),
            AccentColor = Color3.fromRGB(0, 170, 255),
            BorderColor = Color3.fromRGB(50, 50, 50)
        },
        LightModern = {
            BackgroundColor = Color3.fromRGB(240, 240, 240),
            TextColor = Color3.fromRGB(0, 0, 0),
            AccentColor = Color3.fromRGB(0, 120, 215),
            BorderColor = Color3.fromRGB(200, 200, 200)
        }
    }
}

function Theme:ApplyTo(element)
    if element:IsA("GuiObject") then
        element.BackgroundColor3 = self.Themes[self.CurrentTheme].BackgroundColor
        if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
            element.TextColor3 = self.Themes[self.CurrentTheme].TextColor
        end
        if element:IsA("Frame") or element:IsA("TextButton") then
            element.BorderColor3 = self.Themes[self.CurrentTheme].BorderColor
        end
    end
    for _, child in pairs(element:GetChildren()) do
        self:ApplyTo(child)
    end
end

function Theme:SetTheme(name)
    if self.Themes[name] then
        self.CurrentTheme = name
    end
end

-- Component Classes
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, text, defaultValue, onChange)
    local self = setmetatable({}, Toggle)
    self.Frame = Instance.new("Frame", parent)
    self.Frame.Size = UDim2.new(1, 0, 0, 30)
    self.Label = Instance.new("TextLabel", self.Frame)
    self.Label.Size = UDim2.new(0.7, 0, 1, 0)
    self.Label.Text = text
    self.ToggleButton = Instance.new("TextButton", self.Frame)
    self.ToggleButton.Size = UDim2.new(0.2, 0, 0.8, 0)
    self.ToggleButton.Position = UDim2.new(0.75, 0, 0.1, 0)
    self.ToggleButton.Text = defaultValue and "ON" or "OFF"
    self.Value = defaultValue
    Theme:ApplyTo(self.Frame)
    self.ToggleButton.MouseButton1Click:Connect(function()
        self.Value = not self.Value
        self.ToggleButton.Text = self.Value and "ON" or "OFF"
        onChange(self.Value)
    end)
    return self
end

local Button = {}
Button.__index = Button

function Button.new(parent, text, onClick)
    local self = setmetatable({}, Button)
    self.Frame = Instance.new("TextButton", parent) -- Pastikan ini TextButton
    self.Frame.Size = UDim2.new(1, 0, 0, 30)
    self.Frame.Text = text
    Theme:ApplyTo(self.Frame)
    if self.Frame:IsA("TextButton") then
        self.Frame.MouseButton1Click:Connect(onClick)
    else
        warn("Button harus berupa TextButton!")
    end
    return self
end

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(parent, options, default, onChange)
    local self = setmetatable({}, Dropdown)
    self.Frame = Instance.new("Frame", parent)
    self.Frame.Size = UDim2.new(1, 0, 0, 30)
    self.Button = Instance.new("TextButton", self.Frame)
    self.Button.Size = UDim2.new(1, 0, 1, 0)
    self.Button.Text = default or options[1]
    self.Menu = Instance.new("Frame", self.Frame)
    self.Menu.Size = UDim2.new(1, 0, 0, 0)
    self.Menu.Position = UDim2.new(0, 0, 1, 0)
    self.Menu.Visible = false
    local layout = Instance.new("UIListLayout", self.Menu)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    Theme:ApplyTo(self.Frame)
    for _, option in pairs(options) do
        local optionButton = Instance.new("TextButton", self.Menu)
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Text = option
        optionButton.MouseButton1Click:Connect(function()
            self.Button.Text = option
            self.Menu.Visible = false
            onChange(option)
        end)
    end
    self.Button.MouseButton1Click:Connect(function()
        self.Menu.Visible = not self.Menu.Visible
        self.Menu.Size = UDim2.new(1, 0, 0, #options * 30)
    end)
    return self
end

local TextBox = {}
TextBox.__index = TextBox

function TextBox.new(parent, placeholder, onChange)
    local self = setmetatable({}, TextBox)
    self.Frame = Instance.new("TextBox", parent)
    self.Frame.Size = UDim2.new(1, 0, 0, 30)
    self.Frame.PlaceholderText = placeholder
    Theme:ApplyTo(self.Frame)
    self.Frame.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            onChange(self.Frame.Text)
        end
    end)
    return self
end

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(parent, defaultKey, onChange)
    local self = setmetatable({}, Keybind)
    self.Frame = Instance.new("TextButton", parent)
    self.Frame.Size = UDim2.new(1, 0, 0, 30)
    self.Frame.Text = defaultKey or "None"
    Theme:ApplyTo(self.Frame)
    self.Frame.MouseButton1Click:Connect(function()
        self.Frame.Text = "Press Key..."
        local userInputService = game:GetService("UserInputService")
        local connection
        connection = userInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                self.Frame.Text = input.KeyCode.Name
                onChange(input.KeyCode)
                connection:Disconnect()
            end
        end)
    end)
    return self
end

local Slider = {}
Slider.__index = Slider

function Slider.new(parent, min, max, default, onChange)
    local self = setmetatable({}, Slider)
    self.Frame = Instance.new("Frame", parent)
    self.Frame.Size = UDim2.new(1, 0, 0, 30)
    self.SliderBar = Instance.new("TextButton", self.Frame)
    self.SliderBar.Size = UDim2.new(0.8, 0, 0.5, 0)
    self.SliderBar.Position = UDim2.new(0.1, 0, 0.25, 0)
    self.ValueLabel = Instance.new("TextLabel", self.Frame)
    self.ValueLabel.Size = UDim2.new(0.1, 0, 1, 0)
    self.ValueLabel.Position = UDim2.new(0.9, 0, 0, 0)
    self.Value = default or min
    Theme:ApplyTo(self.Frame)
    local function updateValue(x)
        local newValue = min + (max - min) * (x / self.SliderBar.AbsoluteSize.X)
        self.Value = math.clamp(math.floor(newValue), min, max)
        self.ValueLabel.Text = tostring(self.Value)
        onChange(self.Value)
    end
    self.SliderBar.MouseButton1Down:Connect(function(input)
        local moveConnection
        moveConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local relX = math.clamp(input.Position.X - self.SliderBar.AbsolutePosition.X, 0, self.SliderBar.AbsoluteSize.X)
            updateValue(relX)
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                moveConnection:Disconnect()
            end
        end)
    end)
    updateValue((default - min) / (max - min) * self.SliderBar.AbsoluteSize.X)
    return self
end

local Label = {}
Label.__index = Label

function Label.new(parent, text)
    local self = setmetatable({}, Label)
    self.Frame = Instance.new("TextLabel", parent)
    self.Frame.Size = UDim2.new(1, 0, 0, 30)
    self.Frame.Text = text
    Theme:ApplyTo(self.Frame)
    return self
end

-- Tab System
local TabSystem = {}
TabSystem.__index = TabSystem

function TabSystem.new(parent)
    local self = setmetatable({}, TabSystem)
    self.Tabs = {}
    self.TabBar = Instance.new("Frame", parent)
    self.TabBar.Size = UDim2.new(1, 0, 0, 40)
    self.ContentArea = Instance.new("Frame", parent)
    self.ContentArea.Size = UDim2.new(1, 0, 1, -40)
    self.ContentArea.Position = UDim2.new(0, 0, 0, 40)
    local layout = Instance.new("UIListLayout", self.TabBar)
    layout.FillDirection = Enum.FillDirection.Horizontal
    Theme:ApplyTo(self.TabBar)
    Theme:ApplyTo(self.ContentArea)
    return self
end

function TabSystem:AddTab(name)
    local tab = {}
    tab.Name = name
    tab.Button = Instance.new("TextButton", self.TabBar)
    tab.Button.Size = UDim2.new(0, 100, 1, 0)
    tab.Button.Text = name
    tab.Content = Instance.new("ScrollingFrame", self.ContentArea)
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    local layout = Instance.new("UIListLayout", tab.Content)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    Theme:ApplyTo(tab.Button)
    Theme:ApplyTo(tab.Content)
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    return tab.Content
end

function TabSystem:SelectTab(tab)
    if self.CurrentTab then
        TweenService:Create(self.CurrentTab.Content, TweenInfo.new(0.3), {Position = UDim2.new(-1, 0, 0, 0)}):Play()
        self.CurrentTab.Content.Visible = false
    end
    self.CurrentTab = tab
    tab.Content.Position = UDim2.new(1, 0, 0, 0)
    tab.Content.Visible = true
    TweenService:Create(tab.Content, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
end

-- Notification System
local NotificationSystem = {}
NotificationSystem.__index = NotificationSystem

function NotificationSystem.new(parent)
    local self = setmetatable({}, NotificationSystem)
    self.Queue = {}
    self.Container = Instance.new("Frame", parent)
    self.Container.Size = UDim2.new(0, 200, 1, 0)
    self.Container.Position = UDim2.new(1, -200, 0, 0)
    self.Container.BackgroundTransparency = 1
    return self
end

function NotificationSystem:ShowNotification(message, duration)
    local notif = Instance.new("TextLabel", self.Container)
    notif.Size = UDim2.new(1, 0, 0, 50)
    notif.Position = UDim2.new(0, 0, 1, 0)
    notif.Text = message
    notif.BackgroundTransparency = 0.5
    Theme:ApplyTo(notif)
    table.insert(self.Queue, notif)
    self:UpdateNotifications()
    task.spawn(function()
        wait(duration or 5)
        TweenService:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        wait(0.5)
        notif:Destroy()
        table.remove(self.Queue, 1)
        self:UpdateNotifications()
    end)
end

function NotificationSystem:UpdateNotifications()
    for i, notif in ipairs(self.Queue) do
        TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 1, -50 * i)}):Play()
    end
end

-- Script Loader
local ScriptLoader = {}
ScriptLoader.__index = ScriptLoader

function ScriptLoader.new()
    local self = setmetatable({}, ScriptLoader)
    self.Favorites = {}
    self.Scripts = {}
    return self
end

function ScriptLoader:LoadScript(url, callback)
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)
    if success then
        callback(result)
    else
        warn("Failed to load script from " .. url)
    end
end

function ScriptLoader:AddFavorite(name, url)
    table.insert(self.Favorites, {Name = name, Url = url})
end

function ScriptLoader:RegisterScript(name, url, placeIds)
    table.insert(self.Scripts, {Name = name, Url = url, PlaceIds = placeIds})
end

-- Main Library
function RbxScriptHub.new()
    local self = setmetatable({}, RbxScriptHub)
    
    -- Main UI Setup
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    self.MainFrame = Instance.new("Frame", screenGui)
    self.MainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    
    self.Logo = Instance.new("TextButton", screenGui) -- Menggunakan TextButton untuk klik
    self.Logo.Size = UDim2.new(0, 50, 0, 50)
    self.Logo.Position = UDim2.new(0.5, -25, 0, 0)
    self.Logo.Text = "RBH"
    self.Logo.Font = Enum.Font.SourceSansBold
    self.Logo.TextSize = 20
    self.Logo.Visible = false
    
    -- Systems
    self.TabSystem = TabSystem.new(self.MainFrame)
    self.NotificationSystem = NotificationSystem.new(screenGui)
    self.ScriptLoader = ScriptLoader.new()
    
    -- Theme Application
    Theme:ApplyTo(self.MainFrame)
    Theme:ApplyTo(self.Logo)
    
    -- Minimize/Restore
    local minimized = false
    self.Logo.MouseButton1Click:Connect(function()
        if minimized then
            self:Restore()
            minimized = false
        end
    end)
    
    -- Game Detection
    local placeId = game.PlaceId
    for _, script in pairs(self.ScriptLoader.Scripts) do
        if table.find(script.PlaceIds, placeId) then
            local tab = self:AddTab(script.Name)
            Button.new(tab, "Load " .. script.Name, function()
                self.ScriptLoader:LoadScript(script.Url, function(content)
                    loadstring(content)()
                end)
            end)
        end
    end
    
    return self
end

function RbxScriptHub:AddTab(name)
    return self.TabSystem:AddTab(name)
end

function RbxScriptHub:Notify(message, duration)
    self.NotificationSystem:ShowNotification(message, duration)
end

function RbxScriptHub:Minimize()
    TweenService:Create(self.MainFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.5)
    self.MainFrame.Visible = false
    self.Logo.Visible = true
end

function RbxScriptHub:Restore()
    self.MainFrame.Visible = true
    TweenService:Create(self.MainFrame, TweenInfo.new(0.5), {Size = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    self.Logo.Visible = false
end

function RbxScriptHub:SetTheme(name)
    Theme:SetTheme(name)
    Theme:ApplyTo(self.MainFrame)
    Theme:ApplyTo(self.Logo)
end

function RbxScriptHub:LoadScript(url, callback)
    self.ScriptLoader:LoadScript(url, callback)
end

function RbxScriptHub:AddFavoriteScript(name, url)
    self.ScriptLoader:AddFavorite(name, url)
end

function RbxScriptHub:RegisterScript(name, url, placeIds)
    self.ScriptLoader:RegisterScript(name, url, placeIds)
end

return RbxScriptHub
