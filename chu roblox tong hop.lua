local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local TargetGui = (gethui and gethui()) or CoreGui or PlayerGui

-- I
local LOGO_ID = "rbxassetid://89243556917765"
local DISPLAY_ZINDEX = 9999

-- 
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


-- ============================================================
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

    task.wait(2.5)

    local fade = TweenInfo.new(0.8)
    TweenService:Create(logoImage, fade, {ImageTransparency = 1}):Play()
    TweenService:Create(titleLabel, fade, {TextTransparency = 1}):Play()
    local bgFade = TweenService:Create(bgFrame, fade, {BackgroundTransparency = 1})
    bgFade:Play()
    bgFade.Completed:Wait()
    introGui:Destroy()
end)


-- ============================================================
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

-- Kéo thả nút tròn
local dragging, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
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
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)


-- ============================================================
repeat task.wait() until game:IsLoaded()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Chú Roblox",
    SubTitle = "tổng hợp script by chú roblox",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 370),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End
})

toggleBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- TẤT CẢ CÁC TAB
local Tabs = {
    Info = Window:AddTab({Title = "Thông Tin", Icon = "info"}),
    Player = Window:AddTab({Title = "Nhân Vật", Icon = "user"}),
    BloxFruits = Window:AddTab({Title = "Blox Fruits", Icon = "sword"}),
    GrowAGarden = Window:AddTab({Title = "Grow A Garden", Icon = "flower"}),
    Forest = Window:AddTab({Title = "99 Nights Forest", Icon = "trees"}),
    Troll = Window:AddTab({Title = "Troll Player", Icon = "smile"}),
    Misc = Window:AddTab({Title = "Tiện Ích", Icon = "settings"})
}

-- TAB: THÔNG TIN
Tabs.Info:AddButton({
    Title = "Sao chép Link Youtube",
    Description = "Kênh Youtube: Chú roblox",
    Callback = function()
        setclipboard("https://www.youtube.com/@churobloxnew")
        Fluent:Notify({Title = "Thành công", Content = "Đã dán link vào bộ nhớ tạm!", Duration = 3})
    end
})


-- ============================================================
local currentSpeed = 16
local currentJump = 50
local isSpeedEnabled = false
local isJumpEnabled = false
local isNoclip = false
local isInfJump = false

-- RenderStepped duy trì WalkSpeed & JumpPower
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if isSpeedEnabled then
                humanoid.WalkSpeed = currentSpeed
            end
            if isJumpEnabled then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = currentJump
            end
        end

        -- Noclip (Xuyên tường)
        if isNoclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- 
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
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
            end
        end)
    end
})

Tabs.Player:AddSlider("JumpPower", {
    Title = "Độ Cao Nhảy (Jump)",
    Default = 50, Min = 50, Max = 400, Rounding = 0,
    Callback = function(Value)
        currentJump = Value
        isJumpEnabled = (Value > 50)
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                hum.UseJumpPower = true
                hum.JumpPower = Value
            end
        end)
    end
})

Tabs.Player:AddToggle("Noclip_Toggle", {
    Title = "Noclip (Đi Xuyên Tường)",
    Default = false,
    Callback = function(Value)
        isNoclip = Value
    end
})

Tabs.Player:AddToggle("InfJump_Toggle", {
    Title = "Infinite Jump (Nhảy Vô Hạn)",
    Default = false,
    Callback = function(Value)
        isInfJump = Value
    end
})


-- ============================================================
local bfSettings = {JoinTeam = "Pirates", Translator = true}

Tabs.BloxFruits:AddButton({Title = "Redz Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/newredzv3/Scripts/refs/heads/main/main.luau", bfSettings) end})
Tabs.BloxFruits:AddButton({Title = "w-azure Hub", Callback = function() safeLoad("https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua") end})
Tabs.BloxFruits:AddButton({Title = "Banana Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/kimprobloxdz/Banana-Free/refs/heads/main/Protected_5609200582002947.lua.txt") end})
Tabs.BloxFruits:AddButton({Title = "Thundarz Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/BloxFruit/Chest/AllDevices.lua", bfSettings) end})
Tabs.BloxFruits:AddButton({Title = "Min Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/LuaCrack/Min/refs/heads/main/MinXt2Eng") end})
Tabs.BloxFruits:AddButton({Title = "Speed Hub X", Callback = function() safeLoad("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua") end})
Tabs.BloxFruits:AddButton({Title = "Than Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/thantzy/thanhub/refs/heads/main/thanv1") end})
Tabs.BloxFruits:AddButton({Title = "BlueX Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua") end})
Tabs.BloxFruits:AddButton({Title = "Tsoul Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Tsuo7/TsuoHub/main/Tsuoscripts") end})
Tabs.BloxFruits:AddButton({Title = "Volcano Hub V3", Callback = function() safeLoad("https://raw.githubusercontent.com/indexeduu/BF-NewVer/refs/heads/main/V3New.lua") end})
Tabs.BloxFruits:AddButton({Title = "HOHO Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI") end})
Tabs.BloxFruits:AddButton({Title = "Fix Lag", Callback = function() safeLoad("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua") end})


-- ============================================================
Tabs.GrowAGarden:AddButton({Title = "Zinx Hub (Best Spawner)", Callback = function() safeLoad("https://raw.githubusercontent.com/Hub-dev33/Main/refs/heads/main/ALLinOne.lua") end})
Tabs.GrowAGarden:AddButton({Title = "Casual Hub", Callback = function() safeLoad("https://api.jnkie.com/api/v1/luascripts/public/056bf72c3cd7af38ca292db583aaba9ecd12205d214716e14654ee7781bfee23/download") end})
Tabs.GrowAGarden:AddButton({Title = "Ajjans Hub", Callback = function() safeLoad("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua") end})
Tabs.GrowAGarden:AddButton({Title = "Star Scripts Spawner", Callback = function() safeLoad("https://raw.githubusercontent.com/scripteredwinter/scripts/refs/heads/main/gag2spawner") end})
Tabs.GrowAGarden:AddButton({Title = "Polluted Hub", Callback = function() safeLoad("https://api.luarmor.net/files/v4/loaders/e8580ba6e94aeaa7aa2486f060167f85.lua") end})
Tabs.GrowAGarden:AddButton({Title = "Blue X Hub ", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua") end})


-- ============================================================
Tabs.Forest:AddButton({Title = "Voidware Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua") end})
Tabs.Forest:AddButton({Title = "Speed Hub X", Callback = function() safeLoad("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua") end})
Tabs.Forest:AddButton({Title = "Pulse Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Chavels123/Loader/refs/heads/main/loader.lua") end})


-- ============================================================
Tabs.Troll:AddButton({
    Title = "Fly (Script Bay)",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/hieuhieu989/Vihieu-fly/refs/heads/main/vihieu%20Fly.lua.txt")
    end
})

Tabs.Troll:AddButton({
    Title = "Jerk Off Script",
    Callback = function()
        safeLoad("https://pastefy.app/wa3v2Vgm/raw")
    end
})


-- ============================================================
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

-- Duy trì Fullbright không bị game reset
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
            local VirtualUser = game:GetService("VirtualUser")
            antiAfkConn = LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            Fluent:Notify({Title = "Anti-AFK", Content = "Đã bật chống AFK!", Duration = 3})
        else
            if antiAfkConn then
                antiAfkConn:Disconnect()
                antiAfkConn = nil
            end
            Fluent:Notify({Title = "Anti-AFK", Content = "Đã tắt chống AFK!", Duration = 3})
        end
    end
})

Tabs.Misc:AddButton({
    Title = "Super Fix Lag (Tăng FPS)",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
        Lighting.GlobalShadows = false
        Fluent:Notify({Title = "Fix Lag", Content = "Đã tối ưu hóa đồ họa thành công!", Duration = 3})
    end
})

Tabs.Misc:AddButton({
    Title = "Vào Lại Server (Rejoin Game)",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Tabs.Misc:AddButton({
    Title = "Đổi Server Khác (Server Hop)",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/LeoK39/ServerHop/main/Script.lua")
    end
})

Window:SelectTab(Tabs.Info)
Fluent:Notify({Title = "Chú Roblox", Content = "Đã tải đầy đủ menu và tính năng!", Duration = 3})
-- con chó nào láy code của vi hiếu cẩn thận t đấy