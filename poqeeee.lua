local player = game.Players.LocalPlayer

local function executeAgain()
    local scriptSource = [[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sauma1/userscript/refs/heads/main/script%20fisch",  true))()
    ]]
    local success, err = pcall(function()
        loadstring(scriptSource)()
    end)

    if not success then
        warn("Error saat mengeksekusi ulang: ", err)
    end
end

executeAgain()

player.CharacterAdded:Connect(function()
    task.wait(1) 
    executeAgain()
end)
