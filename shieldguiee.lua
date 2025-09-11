-- discord.gg/ancestral
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local RenderStepped = RunService.RenderStepped
local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local function generateRandomString(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;:',.<>/?`~"
    local str = {}
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        str[i] = string.sub(chars, randIndex, randIndex)
    end
    return table.concat(str)
end

local function New(Name, Properties, Parent)
    local _instance = Instance.new(Name)

    for i, v in pairs(Properties) do
        _instance[i] = v
    end

    if Parent then
        _instance.Parent = Parent
    end

    return _instance
end

local Custom = {} do
  Custom.ColorRGB = Color3.fromRGB(25, 25, 112)
  Custom.AccentColor = Color3.fromRGB(75, 0, 130)
  Custom.DarkBlue = Color3.fromRGB(25, 25, 112)
  Custom.BackgroundDark = Color3.fromRGB(12, 12, 25)
  Custom.FrameDark = Color3.fromRGB(20, 20, 35)

  function Custom:EnabledAFK()
    Player.Idled:Connect(function()
      VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      task.wait(1)
      VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
  end
end

Custom:EnabledAFK()

-- Single ScreenGui instance
local MainScreenGui = nil

local function getSafeParent()
    local success, result = pcall(function()
        if RunService:IsStudio() then
            return Player.PlayerGui
        end
        local methods = {
            function() return gethui() end,
            function() return cloneref(game:GetService("CoreGui")) end,
            function() return game:GetService("CoreGui") end
        }
        
        for _, method in ipairs(methods) do
            local success, parent = pcall(method)
            if success and parent then
                return parent
            end
        end
        
        return Player.PlayerGui
    end)
    
    return success and result or Player.PlayerGui
end

local function createMainScreenGui()
    if MainScreenGui and MainScreenGui.Parent then
        MainScreenGui:Destroy()
    end

    MainScreenGui = New("ScreenGui", {
        Name = "UiX-Main",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = math.random(-50, 50),
        Archivable = false
    }, getSafeParent())
    
    ProtectGui(MainScreenGui)
    
    if MainScreenGui then
        MainScreenGui.AncestryChanged:Connect(function()
            if not MainScreenGui.Parent then
                MainScreenGui.Parent = getSafeParent()
            end
        end)
    end
    
    return MainScreenGui
end

-- Initialize main ScreenGui
createMainScreenGui()

-- Notification container in main ScreenGui
local NotificationContainer = New("Frame", {
    AnchorPoint = Vector2.new(1,1),
    BackgroundTransparency = 1,
    Position = UDim2.new(1,-30,1,-30),
    Size = UDim2.new(0,320,1,0),
    Name = "NotificationContainer",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, MainScreenGui)

-- Close button container in main ScreenGui
local CloseButtonContainer = New("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Name = "CloseButtonContainer",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, MainScreenGui)

local function MakeDraggable(topbarObject, object)
    local dragging = false
    local dragStart
    local startPos
    local targetPos = object.Position
    local smoothness = 0.15
    local releaseTweenTime = 0.25

    local function UpdateTarget(input)
        local delta = input.Position - dragStart
        targetPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false

                    local tween = TweenService:Create(object, TweenInfo.new(releaseTweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
                    tween:Play()
                end
            end)
        end
    end)

    topbarObject.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateTarget(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateTarget(input)
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            object.Position = object.Position:Lerp(targetPos, smoothness)
        end
    end)
end

function CircleClick(Button, X, Y)
	task.spawn(function()
		Button.ClipsDescendants = true
		
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Custom.ColorRGB
		Circle.ImageTransparency = 0.7
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Name = "Circle"
		Circle.Parent = Button
		
		local NewX = X - Button.AbsolutePosition.X
		local NewY = Y - Button.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)

		local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5

		local Time = 0.5
		local TweenInfo = TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local Tween = TweenService:Create(Circle, TweenInfo, {
			Size = UDim2.new(0, Size, 0, Size),
			Position = UDim2.new(0.5, -Size/2, 0.5, -Size/2)
		})
		
		Tween:Play()
		
		Tween.Completed:Connect(function()
			for i = 1, 10 do
				Circle.ImageTransparency = Circle.ImageTransparency + 0.01
				wait(Time / 10)
			end
			Circle:Destroy()
		end)
	end)
end

local Speed_Library, Notification = {}, {}
Speed_Library.Unloaded = false

function Speed_Library:SetNotification(Config)
    local Title = Config[1] or Config.Title or ""
    local Description = Config[2] or Config.Description or ""
    local Content = Config[3] or Config.Content or ""
    local Time = Config[5] or Config.Time or 0.5
    local Delay = Config[6] or Config.Delay or 5

    local Count = 0
    NotificationContainer.ChildRemoved:Connect(function()
        Count = 0
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        for _, v in ipairs(NotificationContainer:GetChildren()) do
            local NewPOS = UDim2.new(0,0,1,-((v.Size.Y.Offset + 12) * Count))
            TweenService:Create(v,tweenInfo,{Position=NewPOS}):Play()
            Count = Count + 1
        end
    end)

    local _Count = 0
    for _, v in ipairs(NotificationContainer:GetChildren()) do
        _Count = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
    end

    local NotificationFrame = New("Frame", {
        BackgroundColor3 = Custom.BackgroundDark,
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,0,150),
        Name = "NotificationFrame",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0,1),
        Position = UDim2.new(0,0,1,-(_Count))
    }, NotificationContainer)

    local NotificationFrameReal = New("Frame", {
        BackgroundColor3 = Custom.BackgroundDark,
        BorderSizePixel = 0,
        Position = UDim2.new(0,400,0,0),
        Size = UDim2.new(1,0,1,0),
        Name = "NotificationFrameReal"
    }, NotificationFrame)

    New("UICorner",{CornerRadius=UDim.new(0,12)}, NotificationFrameReal)

    New("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Custom.BackgroundDark),
            ColorSequenceKeypoint.new(0.5, Custom.FrameDark),
            ColorSequenceKeypoint.new(1, Custom.AccentColor)
        },
        Rotation = 135,
    }, NotificationFrameReal)

    local DropShadowHolder = New("Frame", {
        BackgroundTransparency=1,
        BorderSizePixel=0,
        Size=UDim2.new(1,0,1,0),
        ZIndex=0,
        Name="DropShadowHolder",
        Parent=NotificationFrameReal
    })

    local DropShadow = New("ImageLabel", {
        Image="rbxassetid://6015897843",
        ImageColor3=Custom.BackgroundDark,
        ImageTransparency=0.3,
        ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450),
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        Position=UDim2.new(0.5,0,0.5,0),
        Size=UDim2.new(1,47,1,47),
        ZIndex=0,
        Name="DropShadow",
        Parent=DropShadowHolder
    })

    local Top = New("Frame", {
        BackgroundTransparency=0.999,
        Size=UDim2.new(1,0,0,36),
        Name="Top",
        Parent=NotificationFrameReal
    })

    local TextLabel = New("TextLabel", {
        Font=Enum.Font.GothamBold,
        Text=Title,
        TextColor3=Color3.fromRGB(255,255,255),
        TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=0.999,
        Size=UDim2.new(1,0,1,0),
        Position=UDim2.new(0,10,0,0),
        Parent=Top
    })

    New("UIStroke",{Color=Color3.fromRGB(255,255,255),Thickness=0.5,Parent=TextLabel})
    New("UICorner",{Parent=Top,CornerRadius=UDim.new(0,8)})

    local TextLabel1 = New("TextLabel", {
        Font=Enum.Font.GothamBold,
        Text=Description,
        TextColor3=Custom.ColorRGB,
        TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=0.999,
        Size=UDim2.new(1,0,1,0),
        Position=UDim2.new(0,TextLabel.TextBounds.X+15,0,0),
        Parent=Top
    })

    New("UIStroke",{Color=Custom.ColorRGB,Thickness=0.6,Parent=TextLabel1})

    local Close = New("TextButton", {
        Font=Enum.Font.SourceSans,
        Text="",
        BackgroundTransparency=0.999,
        AnchorPoint=Vector2.new(1,0.5),
        Position=UDim2.new(1,-5,0.5,0),
        Size=UDim2.new(0,25,0,25),
        Name="Close",
        Parent=Top
    })

    local ImageLabel = New("ImageLabel", {
        Image="rbxassetid://9886659671",
        ImageColor3=Custom.ColorRGB,
        AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundTransparency=0.999,
        BorderSizePixel=0,
        Position=UDim2.new(0.49,0,0.5,0),
        Size=UDim2.new(1,-8,1,-8),
        Parent=Close
    })

    local TextLabel2 = New("TextLabel", {
        Font=Enum.Font.GothamBold,
        TextColor3=Color3.fromRGB(200,200,200),
        TextSize=13,
        Text=Content,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top,
        BackgroundTransparency=0.999,
        BorderSizePixel=0,
        Position=UDim2.new(0,10,0,27),
        Size=UDim2.new(1,-20,0,13),
        Parent=NotificationFrameReal,
        TextWrapped=true
    })

    TextLabel2.Size = UDim2.new(1,-20,0,13+(13*(TextLabel2.TextBounds.X//TextLabel2.AbsoluteSize.X)))

    if TextLabel2.AbsoluteSize.Y < 27 then
        NotificationFrame.Size = UDim2.new(1,0,0,65)
    else
        NotificationFrame.Size = UDim2.new(1,0,0,TextLabel2.AbsoluteSize.Y+40)
    end

    local Waitted = false
    function Notification:Close()
        if Waitted then return false end
        Waitted = true
        local tween = TweenService:Create(NotificationFrameReal,TweenInfo.new(tonumber(Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),{Position=UDim2.new(0,400,0,0)})
        tween:Play()
        task.wait(tonumber(Time)/1.2)
        NotificationFrame:Destroy()
        Waitted = false
    end

    Close.Activated:Connect(function() Notification:Close() end)

    TweenService:Create(NotificationFrameReal, TweenInfo.new(tonumber(Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {Position=UDim2.new(0,0,0,0)} ):Play()
    task.delay(tonumber(Delay), Notification.Close)

    return Notification
end

function Speed_Library:CreateWindow(Config)
  local Title = Config[1] or Config.Title or ""
  local Description = Config[2] or Config.Description or ""
  local TabWidth = Config[3] or Config["Tab Width"] or 120
  local SizeUi = Config[4] or Config.SizeUi or UDim2.fromOffset(550, 315)

  local Funcs = {}

  -- Create close button in the main ScreenGui
  local Close_ImageButton = New("ImageButton", {
    BackgroundColor3 = Custom.BackgroundDark,
    BorderColor3 = Custom.ColorRGB,
    BorderSizePixel = 1,
    Position = UDim2.new(0.1021, 0, 0.0743, 0),
    Size = UDim2.new(0, 59, 0, 49),
    Image = "rbxassetid://125992172976297",
    Visible = false,
    ZIndex = 10
  }, CloseButtonContainer)

  local UICorner = New("UICorner", {
    Name = generateRandomString(12),
    CornerRadius = UDim.new(0, 12),
  }, Close_ImageButton)

  local UIGradient = New("UIGradient", {
    Color = ColorSequence.new{
      ColorSequenceKeypoint.new(0, Custom.ColorRGB),
      ColorSequenceKeypoint.new(0.5, Custom.AccentColor),
      ColorSequenceKeypoint.new(1, Custom.DarkBlue)
    },
    Rotation = 45,
  }, Close_ImageButton)

  MakeDraggable(Close_ImageButton, Close_ImageButton)

  -- Main window container
  local WindowContainer = New("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Name = "WindowContainer",
    ZIndex = 1
  }, MainScreenGui)

  local DropShadowHolder = New("Frame", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 455, 0, 350),
    ZIndex = 0,
    Name = generateRandomString(12),
    Position = UDim2.new(0.5, -227, 0.5, -175)
  }, WindowContainer)

  local DropShadow = New("ImageLabel", {
    Image = "rbxassetid://6015897843",
    ImageColor3 = Custom.BackgroundDark,
    ImageTransparency = 0.3,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = SizeUi,
    ZIndex = 0,
    Name = generateRandomString(12)
  }, DropShadowHolder)

  local Main = New("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Custom.BackgroundDark,
    BackgroundTransparency = 0.05,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = SizeUi,
    Name = generateRandomString(12)
  }, DropShadow)

  New("UICorner", {
    CornerRadius = UDim.new(0, 16)
  }, Main)

  New("UIGradient", {
    Color = ColorSequence.new{
      ColorSequenceKeypoint.new(0, Custom.BackgroundDark),
      ColorSequenceKeypoint.new(0.3, Custom.FrameDark),
      ColorSequenceKeypoint.new(0.7, Custom.AccentColor),
      ColorSequenceKeypoint.new(1, Custom.DarkBlue)
    },
    Rotation = 135,
  }, Main)

  New("UIStroke", {
    Color = Custom.ColorRGB,
    Thickness = 2,
    Transparency = 0.3
  }, Main)

  local Top = New("Frame", {
    BackgroundColor3 = Custom.BackgroundDark,
    BackgroundTransparency = 0.2,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 38),
    Name = "Top"
  }, Main)

  New("UIGradient", {
    Color = ColorSequence.new{
      ColorSequenceKeypoint.new(0, Custom.FrameDark),
      ColorSequenceKeypoint.new(1, Custom.AccentColor)
    },
    Rotation = 90,
  }, Top)

  local TextLabel = New("TextLabel", {
      Font = Enum.Font.GothamBold,
      Text = Title,
      TextColor3 = Color3.fromRGB(255, 255, 255),
      TextSize = 16,
      TextXAlignment = Enum.TextXAlignment.Center,
      TextYAlignment = Enum.TextYAlignment.Center,
      BackgroundTransparency = 1,
      BorderSizePixel = 0,
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.new(0.5, 0, 0.35, 0),
      Size = UDim2.new(0.5, 0, 0.3, 0)
  }, Top)

  New("UICorner", {
    CornerRadius = UDim.new(0, 16)
  }, Top)

  New("UIStroke", {
    Color = Color3.fromRGB(255, 255, 255),
    Thickness = 0.8,
    Transparency = 0.7
  }, TextLabel)

  local TextLabel1 = New("TextLabel", {
      Font = Enum.Font.GothamBold,
      Text = Description,
      TextColor3 = Custom.ColorRGB,
      TextSize = 14,
      TextXAlignment = Enum.TextXAlignment.Center,
      TextYAlignment = Enum.TextYAlignment.Center,
      BackgroundTransparency = 1,
      BorderSizePixel = 0,
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.new(0.5, 0, 0.72, 0),
      Size = UDim2.new(0.5, 0, 0.3, 0)
  }, Top)

  New("UIStroke", {
    Color = Custom.ColorRGB,
    Thickness = 0.6
  }, TextLabel1)

  local Close = New("TextButton", {
    Font = Enum.Font.SourceSans,
    Text = "",
    TextColor3 = Color3.fromRGB(0, 0, 0),
    TextSize = 14,
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(1, -8, 0.5, 0),
    Size = UDim2.new(0, 25, 0, 25),
    Name = "Close"
  }, Top)

  local ImageLabel1 = New("ImageLabel", {
    Image = "rbxassetid://9886659671",
    ImageColor3 = Custom.ColorRGB,
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0.49, 0, 0.5, 0),
    Size = UDim2.new(1, -8, 1, -8)
  }, Close)

  local Min = New("TextButton", {
    Font = Enum.Font.SourceSans,
    Text = "",
    TextColor3 = Color3.fromRGB(0, 0, 0),
    TextSize = 14,
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(1, -42, 0.5, 0),
    Size = UDim2.new(0, 25, 0, 25),
    Name = "Min"
  }, Top)

  New("ImageLabel", {
    Image = "rbxassetid://9886659276",
    ImageColor3 = Custom.DarkBlue,
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(1, -8, 1, -8)
  }, Min)

  local LayersTab = New("Frame", {
    BackgroundColor3 = Custom.FrameDark,
    BackgroundTransparency = 0.1,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 9, 0, 50),
    Size = UDim2.new(0, TabWidth, 1, -59),
    Name = "LayersTab"
  }, Main)

  New("UICorner", {
    CornerRadius = UDim.new(0, 8)
  }, LayersTab)

  New("UIGradient", {
    Color = ColorSequence.new{
      ColorSequenceKeypoint.new(0, Custom.FrameDark),
      ColorSequenceKeypoint.new(1, Custom.AccentColor)
    },
    Rotation = 45,
  }, LayersTab)

  New("UIStroke", {
    Color = Custom.ColorRGB,
    Thickness = 1,
    Transparency = 0.6
  }, LayersTab)

  New("Frame", {
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Custom.ColorRGB,
    BackgroundTransparency = 0.3,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, 0, 0, 38),
    Size = UDim2.new(1, 0, 0, 2),
    Name = "DecideFrame"
  }, Main)

  local Layers = New("Frame", {
    BackgroundColor3 = Custom.FrameDark,
    BackgroundTransparency = 0.1,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.new(0, TabWidth + 18, 0, 50),
    Size = UDim2.new(1, -(TabWidth + 9 + 18), 1, -59),
    Name = "Layers"
  }, Main)

  New("UICorner", {
    CornerRadius = UDim.new(0, 8)
  }, Layers)

  New("UIGradient", {
    Color = ColorSequence.new{
      ColorSequenceKeypoint.new(0, Custom.FrameDark),
      ColorSequenceKeypoint.new(0.6, Custom.BackgroundDark),
      ColorSequenceKeypoint.new(1, Custom.AccentColor)
    },
    Rotation = 90,
  }, Layers)

  New("UIStroke", {
    Color = Custom.DarkBlue,
    Thickness = 1,
    Transparency = 0.5
  }, Layers)

  local NameTab = New("TextLabel", {
    Font = Enum.Font.GothamBold,
    Text = "",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 24,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9990000128746033,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 30),
    Name = "NameTab"
  }, Layers)

  New("UIStroke", {
    Color = Custom.ColorRGB,
    Thickness = 0.8,
    Transparency = 0.4
  }, NameTab)
