--[[\n  Protected by Chú Roblox\n]]
local _g = getfenv()
local _s = string.char
local _b = table.concat

local function _dec(t, k)
    local res = {}
    for i = 1, #t do
        res[i] = _s(t[i] - k)
    end
    return _b(res)
end

local _ServiceCache = {}
local function _GS(name)
    if not _ServiceCache[name] then
        _ServiceCache[name] = game:GetService(name)
    end
    return _ServiceCache[name]
end

local Players = _GS("Players")
local TweenService = _GS("TweenService")
local UserInputService = _GS("UserInputService")
local TeleportService = _GS("TeleportService")
local CoreGui = _GS("CoreGui")
local RunService = _GS("RunService")
local Lighting = _GS("Lighting")
local GuiService = _GS("GuiService")
local Stats = _GS("Stats")
local VirtualInputManager = _GS("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TargetGui = (gethui and gethui()) or CoreGui or PlayerGui

local LOGO_ID = "rbxassetid://89243556917765"
local DISPLAY_ZINDEX = 9999

local function safeLoad(url, settings)
    task.spawn(function()
        local success, err = pcall(function()
            local code = game:HttpGet(url)
            if settings then
                loadstring(code)(settings)
            else
                loadstring(code)()
            end
        end)
        if not success then
            warn("[Chú Roblox] Lỗi tải script: " .. tostring(err))
        end
    end)
end

local introGui = Instance.new("ScreenGui")
introGui.Name = "ChúRoblox_Intro"
introGui.IgnoreGuiInset = true
introGui.ResetOnSpawn = false
introGui.DisplayOrder = DISPLAY_ZINDEX + 1
introGui.Parent = TargetGui

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.fromScale(1, 1)
bgFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
bgFrame.BackgroundTransparency = 0.2
bgFrame.BorderSizePixel = 0
bgFrame.Parent = introGui

local logoImage = Instance.new("ImageLabel")
logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
logoImage.Position = UDim2.fromScale(0.5, 0.45)
logoImage.Size = UDim2.fromOffset(0, 0)
logoImage.BackgroundTransparency = 1
logoImage.Image = LOGO_ID
logoImage.ImageTransparency = 1
logoImage.Parent = introGui

local titleLabel = Instance.new("TextLabel")
titleLabel.AnchorPoint = Vector2.new(0.5, 0)
titleLabel.Position = UDim2.fromScale(0.5, 0.7)
titleLabel.Size = UDim2.fromOffset(400, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Chú Roblox Hub"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true
titleLabel.TextTransparency = 1
titleLabel.Parent = introGui

task.spawn(function()
    TweenService:Create(logoImage, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(150, 150),
        ImageTransparency = 0
    }):Play()
    TweenService:Create(titleLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()

    task.wait(2)

    local fade = TweenInfo.new(0.8)
    TweenService:Create(logoImage, fade, {ImageTransparency = 1}):Play()
    TweenService:Create(titleLabel, fade, {TextTransparency = 1}):Play()
    local bgFade = TweenService:Create(bgFrame, fade, {BackgroundTransparency = 1})
    bgFade:Play()
    bgFade.Completed:Wait()
    introGui:Destroy()
end)

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ChúRoblox_Toggle"
toggleGui.ResetOnSpawn = false
toggleGui.DisplayOrder = DISPLAY_ZINDEX
toggleGui.Parent = TargetGui

local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.fromOffset(50, 50)
toggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
toggleBtn.BorderSizePixel = 0
toggleBtn.Image = LOGO_ID
toggleBtn.ImageTransparency = 0
toggleBtn.AutoButtonColor = true
toggleBtn.Parent = toggleGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 255, 255)
btnStroke.Thickness = 2
btnStroke.Transparency = 0.3
btnStroke.Parent = toggleBtn

local dragging, dragStart, startPos, hasDragged
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        hasDragged = false
        dragStart = input.Position
        startPos = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            hasDragged = true
        end
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local statsGui = Instance.new("ScreenGui")
statsGui.Name = "ChúRoblox_Stats"
statsGui.ResetOnSpawn = false
statsGui.Parent = TargetGui

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.fromOffset(220, 30)
statsFrame.Position = UDim2.new(1, -230, 0, 10)
statsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statsFrame.BackgroundTransparency = 0.3
statsFrame.BorderSizePixel = 0
statsFrame.Parent = statsGui

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 6)
statsCorner.Parent = statsFrame

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.fromScale(1, 1)
statsLabel.BackgroundTransparency = 1
statsLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
statsLabel.Font = Enum.Font.GothamMedium
statsLabel.TextSize = 12
statsLabel.Text = "Chú Roblox | FPS: -- | Ping: --ms"
statsLabel.Parent = statsFrame

local frameCount = 0
local lastUpdate = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastUpdate >= 1 then
        local fps = frameCount
        frameCount = 0
        lastUpdate = tick()
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        statsLabel.Text = string.format("Chú Roblox | FPS: %d | Ping: %dms", fps, ping)
    end
end)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local successFluent, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not successFluent or not Fluent then
    warn("[Chú Roblox] Không thể tải thư viện Fluent UI!")
    return
end

local Window = Fluent:CreateWindow({
    Title = "Chú Roblox",
    SubTitle = "tổng hợp script by chú roblox",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 370),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End
})

toggleBtn.MouseButton1Click:Connect(function()
    if not hasDragged then
        local key = Window.MinimizeKey or Enum.KeyCode.End
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end
end)

local Tabs = {
    Info = Window:AddTab({Title = "Thông Tin", Icon = "info"}),
    Player = Window:AddTab({Title = "Nhân Vật", Icon = "user"}),
    ESP = Window:AddTab({Title = "Nhìn Xuyên Tường", Icon = "eye"}),
    Teleport = Window:AddTab({Title = "Dịch Chuyển", Icon = "map-pin"}),
    BloxFruits = Window:AddTab({Title = "Blox Fruits", Icon = "shield"}),
    GrowAGarden = Window:AddTab({Title = "Grow A Garden", Icon = "file-text"}),
    Forest = Window:AddTab({Title = "99 Nights Forest", Icon = "file-text"}),
    Troll = Window:AddTab({Title = "Troll Player", Icon = "smile"}),
    Misc = Window:AddTab({Title = "Tiện Ích", Icon = "settings"}),
    Settings = Window:AddTab({Title = "Cài Đặt", Icon = "sliders"}),
}

Tabs.Info:AddButton({
    Title = "Sao chép Link Youtube",
    Description = "Kênh Youtube: Chú roblox",
    Callback = function()
        setclipboard("https://www.youtube.com/@churobloxnew")
        Fluent:Notify({Title = "Thành công", Content = "Đã dán link vào bộ nhớ tạm!", Duration = 3})
    end
})

Tabs.Info:AddButton({
    Title = "Shop Chú Roblox",
    Description = "Shop acc: Chú roblox",
    Callback = function()
        setclipboard("https://churobloxshop.com/")
        Fluent:Notify({Title = "Thành công", Content = "Đã dán link vào bộ nhớ tạm!", Duration = 3})
    end
})

local currentSpeed = 16
local currentJump = 50
local isSpeedEnabled = false
local isJumpEnabled = false
local isNoclip = false
local isInfJump = false

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if isSpeedEnabled then humanoid.WalkSpeed = currentSpeed end
            if isJumpEnabled then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = currentJump
            end
        end

        if isNoclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if isInfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Tabs.Player:AddSlider("WalkSpeed", {
    Title = "Tốc Độ Di Chuyển (Speed)",
    Default = 16, Min = 16, Max = 300, Rounding = 0,
    Callback = function(Value)
        currentSpeed = Value
        isSpeedEnabled = (Value > 16)
    end
})

Tabs.Player:AddSlider("JumpPower", {
    Title = "Độ Cao Nhảy (Jump)",
    Default = 50, Min = 50, Max = 400, Rounding = 0,
    Callback = function(Value)
        currentJump = Value
        isJumpEnabled = (Value > 50)
    end
})

Tabs.Player:AddToggle("Noclip_Toggle", {
    Title = "Noclip (Đi Xuyên Tường)",
    Default = false,
    Callback = function(Value) isNoclip = Value end
})

Tabs.Player:AddKeybind("NoclipKey", {
    Title = "Phím Tắt Noclip",
    Mode = "Toggle",
    Default = "N",
    Callback = function(Value)
        isNoclip = Value
        Fluent:Notify({Title = "Noclip", Content = "Trạng thái Noclip: " .. tostring(Value), Duration = 2})
    end
})

Tabs.Player:AddToggle("InfJump_Toggle", {
    Title = "Infinite Jump (Nhảy Vô Hạn)",
    Default = false,
    Callback = function(Value) isInfJump = Value end
})

local isESPEnabled = false
local espConnections = {}

local function removeESPFromChar(char)
    if char then
        local oldHl = char:FindFirstChild("ChúRoblox_ESP")
        if oldHl then oldHl:Destroy() end
    end
end

local function applyESP(plr)
    if plr == LocalPlayer then return end

    local function setupChar(char)
        if not char then return end
        removeESPFromChar(char)

        if isESPEnabled then
            local hl = Instance.new("Highlight")
            hl.Name = "ChúRoblox_ESP"
            hl.FillColor = Color3.fromRGB(0, 255, 255)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = char
            hl.Parent = char
        end
    end

    if plr.Character then
        setupChar(plr.Character)
    end

    if not espConnections[plr] then
        espConnections[plr] = plr.CharacterAdded:Connect(function(newChar)
            task.wait(0.5)
            setupChar(newChar)
        end)
    end
end

local function updateAllESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if isESPEnabled then
                applyESP(plr)
            else
                if plr.Character then removeESPFromChar(plr.Character) end
            end
        end
    end
end

Tabs.ESP:AddToggle("ESP_Toggle", {
    Title = "Bật ESP Người Chơi (Highlight)",
    Default = false,
    Callback = function(Value)
        isESPEnabled = Value
        updateAllESP()
    end
})

Players.PlayerAdded:Connect(function(plr)
    applyESP(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
    if espConnections[plr] then
        espConnections[plr]:Disconnect()
        espConnections[plr] = nil
    end
end)

local selectedPlayer = nil

local function getPlayerList()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.DisplayName .. " (@" .. p.Name .. ")")
        end
    end
    return names
end

local playerDropdown = Tabs.Teleport:AddDropdown("PlayerTPDropdown", {
    Title = "Chọn Người Chơi",
    Values = getPlayerList(),
    Multi = false,
    Default = nil,
    Callback = function(Value)
        for _, p in pairs(Players:GetPlayers()) do
            if (p.DisplayName .. " (@" .. p.Name .. ")") == Value then
                selectedPlayer = p
                break
            end
        end
    end
})

Tabs.Teleport:AddButton({
    Title = "Làm Mới Danh Sách",
    Callback = function()
        playerDropdown:SetValues(getPlayerList())
    end
})

Tabs.Teleport:AddButton({
    Title = "Dịch Chuyển Đến Người Chơi",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                Fluent:Notify({Title = "Dịch Chuyển", Content = "Đã tới vị trí của " .. selectedPlayer.DisplayName, Duration = 3})
            end
        else
            Fluent:Notify({Title = "Lỗi", Content = "Không tìm thấy vị trí người chơi!", Duration = 3})
        end
    end
})

local bfSettings = {JoinTeam = "Pirates", Translator = true}

Tabs.BloxFruits:AddButton({Title = "Neji Hub no key", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-NejiDepzai/Bloxfruits/refs/heads/main/Main.lua", bfSettings) end})
Tabs.BloxFruits:AddButton({Title = "w-azure Hub", Callback = function() safeLoad("https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua") end})
Tabs.BloxFruits:AddButton({Title = "Banana-Cat-Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Von63rd/Banana-Cat-Hub/refs/heads/main/loader.luau") end})
Tabs.BloxFruits:AddButton({Title = "Thundarz Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/BloxFruit/Chest/AllDevices.lua", bfSettings) end})
Tabs.BloxFruits:AddButton({Title = "Tay Hub no key", Callback = function() safeLoad("https://raw.githubusercontent.com/VTDROBLOX/Animehub/refs/heads/main/Tayhub.lua") end})
Tabs.BloxFruits:AddButton({Title = "Speed Hub X", Callback = function() safeLoad("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua") end})
Tabs.BloxFruits:AddButton({Title = "Than Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/thantzy/thanhub/refs/heads/main/thanv1") end})
Tabs.BloxFruits:AddButton({Title = "BlueX Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua") end})
Tabs.BloxFruits:AddButton({Title = "Tsoul Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Tsuo7/TsuoHub/main/Tsuoscripts") end})
Tabs.BloxFruits:AddButton({Title = "Volcano Hub V3", Callback = function() safeLoad("https://raw.githubusercontent.com/indexeduu/BF-NewVer/refs/heads/main/V3New.lua") end})
Tabs.BloxFruits:AddButton({Title = "Brave Hub no key", Callback = function() safeLoad("https://raw.githubusercontent.com/Jadelly261/FruitBlox/refs/heads/main/BraveLoader") end})
Tabs.BloxFruits:AddButton({Title = "Fix Lag", Callback = function() safeLoad("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua") end})

Tabs.GrowAGarden:AddButton({Title = "Zinx Hub (Best Spawner)", Callback = function() safeLoad("https://raw.githubusercontent.com/Hub-dev33/Main/refs/heads/main/ALLinOne.lua") end})
Tabs.GrowAGarden:AddButton({Title = "Casual Hub", Callback = function() safeLoad("https://api.jnkie.com/api/v1/luascripts/public/056bf72c3cd7af38ca292db583aaba9ecd12205d214716e14654ee7781bfee23/download") end})
Tabs.GrowAGarden:AddButton({Title = "Ajjans Hub", Callback = function() safeLoad("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua") end})
Tabs.GrowAGarden:AddButton({Title = "Star Scripts Spawner", Callback = function() safeLoad("https://raw.githubusercontent.com/scripteredwinter/scripts/refs/heads/main/gag2spawner") end})
Tabs.GrowAGarden:AddButton({Title = "Polluted Hub", Callback = function() safeLoad("https://api.luarmor.net/files/v4/loaders/e8580ba6e94aeaa7aa2486f060167f85.lua") end})
Tabs.GrowAGarden:AddButton({Title = "Blue X Hub ", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua") end})

Tabs.Forest:AddButton({Title = "Voidware Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua") end})
Tabs.Forest:AddButton({Title = "Speed Hub X", Callback = function() safeLoad("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua") end})
Tabs.Forest:AddButton({Title = "Pulse Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Chavels123/Loader/refs/heads/main/loader.lua") end})

Tabs.Troll:AddButton({Title = "Fly (Script Bay)", Callback = function() safeLoad("https://raw.githubusercontent.com/hieuhieu989/Vihieu-fly/refs/heads/main/vihieu%20Fly.lua.txt") end})
Tabs.Troll:AddButton({Title = "Jerk Off Script", Callback = function() safeLoad("https://pastefy.app/wa3v2Vgm/raw") end})

local isFullbright = false
local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldGlobalShadows = Lighting.GlobalShadows

Tabs.Misc:AddToggle("Fullbright_Toggle", {
    Title = "Fullbright (Sáng Màn Hình)",
    Default = false,
    Callback = function(Value)
        isFullbright = Value
        if isFullbright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = oldBrightness
            Lighting.ClockTime = oldClockTime
            Lighting.GlobalShadows = oldGlobalShadows
        end
    end
})

Lighting.Changed:Connect(function()
    if isFullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    end
end)

local antiAfkConn
Tabs.Misc:AddToggle("AntiAFK_Toggle", {
    Title = "Anti-AFK (Chống Văng Game)",
    Default = false,
    Callback = function(Value)
        if Value then
            local VirtualUser = _GS("VirtualUser")
            antiAfkConn = LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            Fluent:Notify({Title = "Anti-AFK", Content = "Đã bật chống AFK!", Duration = 3})
        else
            if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
            Fluent:Notify({Title = "Anti-AFK", Content = "Đã tắt chống AFK!", Duration = 3})
        end
    end
})

local isAutoRejoin = false
Tabs.Misc:AddToggle("AutoRejoin_Toggle", {
    Title = "Auto Rejoin Khi Mất Kết Nối",
    Default = false,
    Callback = function(Value) isAutoRejoin = Value end
})

GuiService.ErrorMessageChanged:Connect(function()
    if isAutoRejoin then
        task.wait(2)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

Tabs.Misc:AddButton({
    Title = "Super Fix Lag & Boost FPS",
    Callback = function()
        for _, item in pairs(Lighting:GetChildren()) do
            if item:IsA("PostEffect") or item:IsA("Atmosphere") or item:IsA("Clouds") then
                item:Destroy()
            end
        end
        
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9

        for _, object in pairs(workspace:GetDescendants()) do
            if object:IsA("BasePart") then
                object.Material = Enum.Material.SmoothPlastic
                object.CastShadow = false
                object.Reflectance = 0
            elseif object:IsA("Decal") or object:IsA("Texture") then
                object.Transparency = 1
            elseif object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Smoke") or object:IsA("Fire") then
                object.Enabled = false
            end
        end

        for _, item in pairs(Lighting:GetChildren()) do
            if item:IsA("Sky") then item:Destroy() end
        end

        local newSky = Instance.new("Sky")
        local textureUri = "rbxassetid://89243556917765"
        newSky.SkyboxBk = textureUri
        newSky.SkyboxDn = textureUri
        newSky.SkyboxFt = textureUri
        newSky.SkyboxLf = textureUri
        newSky.SkyboxRt = textureUri
        newSky.SkyboxUp = textureUri
        newSky.Parent = Lighting

        Fluent:Notify({Title = "Fix Lag", Content = "Đã tối ưu đồ họa, thay Bầu trời & Boost FPS!", Duration = 3})
    end
})

Tabs.Misc:AddButton({
    Title = "Vào Lại Server (Rejoin Game)",
    Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end
})

Tabs.Misc:AddButton({
    Title = "Đổi Server Khác (Server Hop)",
    Callback = function() safeLoad("https://raw.githubusercontent.com/LeoK39/ServerHop/main/Script.lua") end
})

pcall(function()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/SaveManager.lua"))()
    SaveManager:SetLibrary(Fluent)
    SaveManager:SetFolder("ChuRobloxConfig")
    SaveManager:BuildConfigFolder()
    SaveManager:BuildFolderSection(Tabs.Settings)
end)

Window:SelectTab(Tabs.Info)
Fluent:Notify({
    Title = "Chú Roblox", 
    Content = "Đã Fix Full Lỗi thành công!", 
    Duration = 3
})
-- con chó nào lấy script của chú roblox cẩn thận t hack đc roblox cx hack đc mxh của m