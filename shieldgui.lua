function Item:AddDropdown(Config)
    local Title = Config[1] or Config.Title or ""
    local Content = Config[2] or Config.Content or ""
    local Multi = Config[3] or Config.Multi or false
    local Options = Config[4] or Config.Options or {}
    local Default = Config[5] or Config.Default or {}
    local Callback = Config[6] or Config.Callback or function() end

    local Funcs_Dropdown = {Value = Default, Options = Options}

    local Dropdown = Custom:Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.935,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        LayoutOrder = ItemCount,
        Size = UDim2.new(1, 0, 0, 35),
        Name = "Dropdown"
    }, SectionAdd)

    local DropdownButton = Custom:Create("TextButton", {
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.999,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Name = "ToggleButton"
    }, Dropdown)

    Custom:Create("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, Dropdown)

    local DropdownTitle = Custom:Create("TextLabel", {
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Color3.fromRGB(230, 230, 230),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.999,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -180, 0, 13),
        Name = "DropdownTitle",
        Parent = Dropdown
    })

    local DropdownContent = Custom:Create("TextLabel", {
        Font = Enum.Font.GothamBold,
        Text = Content,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        TextTransparency = 0.6,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.999,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 23),
        Size = UDim2.new(1, -180, 0, 12),
        Name = "DropdownContent",
        Parent = Dropdown
    })
    
    DropdownContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (DropdownContent.TextBounds.X // DropdownContent.AbsoluteSize.X)))
    DropdownContent.TextWrapped = true
    Dropdown.Size = UDim2.new(1, 0, 0, DropdownContent.AbsoluteSize.Y + 33)
    
    DropdownContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        DropdownContent.TextWrapped = false
        
        DropdownContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (DropdownContent.TextBounds.X // DropdownContent.AbsoluteSize.X)))
        Dropdown.Size = UDim2.new(1, 0, 0, DropdownContent.AbsoluteSize.Y + 33)
        
        DropdownContent.TextWrapped = true
        UpdateSizeSection()
    end)

    local SelectOptionsFrame = Custom:Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.95,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -7, 0.5, 0),
        Size = UDim2.new(0, 148, 0, 30),
        Name = "SelectOptionsFrame",
        LayoutOrder = CountDropdown
    }, Dropdown)

    Custom:Create("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, SelectOptionsFrame)

    DropdownButton.Activated:Connect(function()
        if not MoreBlur.Visible then
            MoreBlur.Visible = true
            
            local tweenInfo = TweenInfo.new(0.1)

            DropPageLayout:JumpToIndex(SelectOptionsFrame.LayoutOrder)
                        
            local BlurTween = TweenService:Create(MoreBlur, tweenInfo, {BackgroundTransparency = 0.7})
            local DropdownTween = TweenService:Create(DropdownSelect, tweenInfo, {Position = UDim2.new(1, -11, 0.5, 0)})
            
            BlurTween:Play()
            DropdownTween:Play()
        end
    end)

    local OptionSelecting = Custom:Create("TextLabel", {
        Font = Enum.Font.GothamBold,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        TextTransparency = 0.6,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.999,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0.5, 0),
        Size = UDim2.new(1, -30, 1, -8),
        Name = "OptionSelecting",
    }, SelectOptionsFrame)

    local OptionImg = Custom:Create("ImageLabel", {
        Image = "rbxassetid://16851841101",
        ImageColor3 = Color3.fromRGB(231, 231, 231),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.999,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 25, 0, 25),
        Name = "OptionImg",
    }, SelectOptionsFrame)

    local ScrollSelect = Custom:Create("ScrollingFrame", {
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
        ScrollBarThickness = 0,
        Active = true,
        LayoutOrder = CountDropdown,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.999,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Name = "ScrollSelect",
    }, DropdownFolder)
    
    -- Create Search Bar with proper positioning
    local SearchBar = Custom:Create("TextBox", {
        Font = Enum.Font.GothamBold,
        PlaceholderText = "Search options...",
        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.3,
        BorderColor3 = Color3.fromRGB(80, 80, 80),
        BorderSizePixel = 1,
        Size = UDim2.new(1, -6, 0, 25),
        Position = UDim2.new(0, 3, 0, 3),
        Name = "SearchBar",
        LayoutOrder = -1, -- Put search bar at the top
        Parent = ScrollSelect
    })

    Custom:Create("UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, SearchBar)

    Custom:Create("UIListLayout", {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, ScrollSelect)

    -- Search Bar Logic - Fixed
    SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = SearchBar.Text:lower()
        for _, optionFrame in pairs(ScrollSelect:GetChildren()) do
            if optionFrame:IsA("Frame") and optionFrame.Name == "Option" then
                local optionText = optionFrame:FindFirstChild("OptionText")
                if optionText then
                    local shouldShow = searchText == "" or optionText.Text:lower():find(searchText, 1, true) ~= nil
                    optionFrame.Visible = shouldShow
                end
            end
        end
        
        -- Update canvas size after search
        local function UpdateCanvasSize()
            local OffsetY = 28 -- Account for search bar
            for _, child in ipairs(ScrollSelect:GetChildren()) do
                if child.Name ~= "UIListLayout" and child.Name ~= "SearchBar" and child.Visible then
                    OffsetY = OffsetY + 3 + child.Size.Y.Offset
                end
            end
            ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
        end
        UpdateCanvasSize()
    end)

    local DropCount = 0

    function Funcs_Dropdown:Clear()
        for _, DropFrame in pairs(ScrollSelect:GetChildren()) do
            if DropFrame.Name == "Option" then
                DropFrame:Destroy()
            end
        end
        Funcs_Dropdown.Value = {}
        Funcs_Dropdown.Options = {}
        OptionSelecting.Text = "Select Options"
        DropCount = 0
    end
    
    function Funcs_Dropdown:Set(Value)
        Funcs_Dropdown.Value = Value or Funcs_Dropdown.Value

        for _, Drop in pairs(ScrollSelect:GetChildren()) do
            if Drop.Name == "Option" then
                local optionText = Drop:FindFirstChild("OptionText")
                if optionText then
                    local isTextFound = table.find(Funcs_Dropdown.Value, optionText.Text)
                    local tweenInfoInOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

                    local Size = isTextFound and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0)
                    local BackgroundTransparency = isTextFound and 0.935 or 0.999
                    local Transparency = isTextFound and 0 or 0.999
            
                    local chooseFrame = Drop:FindFirstChild("ChooseFrame")
                    if chooseFrame then
                        TweenService:Create(chooseFrame, tweenInfoInOut, {Size = Size}):Play()
                        local stroke = chooseFrame:FindFirstChild("UIStroke")
                        if stroke then
                            TweenService:Create(stroke, tweenInfoInOut, {Transparency = Transparency}):Play()
                        end
                    end
                    TweenService:Create(Drop, tweenInfoInOut, {BackgroundTransparency = BackgroundTransparency}):Play()
                end
            end
        end
    
        local DropdownValueTable = table.concat(Funcs_Dropdown.Value, ", ")
        OptionSelecting.Text = DropdownValueTable ~= "" and DropdownValueTable or "Select Options"
        Callback(Funcs_Dropdown.Value)
    end

    function Funcs_Dropdown:AddOption(OptionName)
        OptionName = OptionName or "Option"

        local Option = Custom:Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.999,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            LayoutOrder = DropCount,
            Size = UDim2.new(1, 0, 0, 30),
            Name = "Option",
            Visible = true -- Ensure options are visible by default
        }, ScrollSelect)

        Custom:Create("UICorner", {
            CornerRadius = UDim.new(0, 3)
        }, Option)

        local OptionButton = Custom:Create("TextButton", {
            Font = Enum.Font.GothamBold,
            Text = "",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.999,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Name = "OptionButton"
        }, Option)

        local OptionText = Custom:Create("TextLabel", {
            Font = Enum.Font.GothamBold,
            Text = OptionName,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(230, 230, 230),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 0),
            Size = UDim2.new(1, -16, 1, 0),
            Name = "OptionText"
        }, Option)

        local ChooseFrame = Custom:Create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Custom.ColorRGB,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 0),
            Name = "ChooseFrame"
        }, Option)

        Custom:Create("UIStroke", {
            Color = Custom.ColorRGB,
            Thickness = 1.6,
            Transparency = 0.999
        }, ChooseFrame)

        Custom:Create("UICorner", {}, ChooseFrame)

        OptionButton.Activated:Connect(function()
            CircleClick(OptionButton, Player:GetMouse().X, Player:GetMouse().Y)
        
            local isOptionSelected = Option.BackgroundTransparency > 0.95

            if Multi then
                if isOptionSelected then
                    if not table.find(Funcs_Dropdown.Value, OptionName) then
                        table.insert(Funcs_Dropdown.Value, OptionName)
                    end
                else
                    for i, value in ipairs(Funcs_Dropdown.Value) do
                        if value == OptionName then
                            table.remove(Funcs_Dropdown.Value, i)
                            break
                        end
                    end
                end
            else
                Funcs_Dropdown.Value = {OptionName}
            end

            Funcs_Dropdown:Set(Funcs_Dropdown.Value)
        end)
    
        -- Update canvas size function - Fixed
        local function UpdateCanvasSize()
            task.wait() -- Small delay to ensure layout has updated
            local OffsetY = 28 -- Account for search bar height + padding
            
            for _, child in ipairs(ScrollSelect:GetChildren()) do
                if child.Name ~= "UIListLayout" and child.Name ~= "SearchBar" and child.Visible then
                    OffsetY = OffsetY + 3 + child.Size.Y.Offset
                end
            end

            ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
        end
    
        UpdateCanvasSize()
        DropCount += 1
    end

    function Funcs_Dropdown:Refresh(RefreshList, Selecting)
        RefreshList = RefreshList or {}
        Selecting = Selecting or {}
        
        Funcs_Dropdown:Clear()
        
        for _, Drop in ipairs(RefreshList) do
            Funcs_Dropdown:AddOption(Drop)
        end

        Funcs_Dropdown.Options = RefreshList
        Funcs_Dropdown:Set(Selecting)
    end

    -- Initialize with options
    Funcs_Dropdown:Refresh(Funcs_Dropdown.Options, Funcs_Dropdown.Value)

    ItemCount += 1
    CountDropdown += 1
    return Funcs_Dropdown
end
