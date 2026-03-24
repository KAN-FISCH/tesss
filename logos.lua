local httpService = game:GetService("HttpService")

local InterfaceManager = {} do
	InterfaceManager.Folder = "FluentSettings"
    InterfaceManager.Settings = {
        Theme = "Dark",
        Acrylic = true,
        Transparency = true,
        MenuKeybind = Enum.KeyCode.LeftControl -- Menggunakan Enum untuk keybind
    }

    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local fluentUI = playerGui:FindFirstChild("FluentUI") -- GUI utama
    local logoButton = fluentUI:FindFirstChild("LogoButton") -- Tombol logo
    local isMinimized = false -- Status minimize

    function InterfaceManager:ToggleMinimize()
        isMinimized = not isMinimized
        
        if isMinimized then
            -- Sembunyikan semua elemen kecuali logo
            for _, v in pairs(fluentUI:GetChildren()) do
                if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("ImageLabel") then
                    v.Visible = false
                end
            end
            logoButton.Visible = true
        else
            -- Tampilkan kembali semua elemen
            for _, v in pairs(fluentUI:GetChildren()) do
                v.Visible = true
            end
            logoButton.Visible = false
        end
    end

    -- Bind tombol keyboard untuk minimize GUI
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == InterfaceManager.Settings.MenuKeybind then
            InterfaceManager:ToggleMinimize()
        end
    end)

    -- Jika logo diklik, tampilkan kembali GUI
    logoButton.MouseButton1Click:Connect(function()
        InterfaceManager:ToggleMinimize()
    end)

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
		local Library = self.Library
        local Settings = InterfaceManager.Settings

        InterfaceManager:LoadSettings()

		local section = tab:AddSection("Interface")

		local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
			Title = "Theme",
			Description = "Changes the interface theme.",
			Values = Library.Themes,
			Default = Settings.Theme,
			Callback = function(Value)
				Library:SetTheme(Value)
                Settings.Theme = Value
                InterfaceManager:SaveSettings()
			end
		})

        InterfaceTheme:SetValue(Settings.Theme)
	
		if Library.UseAcrylic then
			section:AddToggle("AcrylicToggle", {
				Title = "Acrylic",
				Description = "The blurred background requires graphic quality 8+",
				Default = Settings.Acrylic,
				Callback = function(Value)
					Library:ToggleAcrylic(Value)
                    Settings.Acrylic = Value
                    InterfaceManager:SaveSettings()
				end
			})
		end
	
		section:AddToggle("TransparentToggle", {
			Title = "Transparency",
			Description = "Makes the interface transparent.",
			Default = Settings.Transparency,
			Callback = function(Value)
				Library:ToggleTransparency(Value)
				Settings.Transparency = Value
                InterfaceManager:SaveSettings()
			end
		})
	
		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Settings.MenuKeybind })
		MenuKeybind:OnChanged(function()
			Settings.MenuKeybind = MenuKeybind.Value
            InterfaceManager:SaveSettings()
		end)
		Library.MinimizeKeybind = MenuKeybind
    end
end

return InterfaceManager
