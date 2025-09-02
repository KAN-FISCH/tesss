local placeScripts = {
    [86710642002144] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Talamau.lua",
    [2693023319] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Antartika.lua",
    [131716211654599] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/fish.lua",
    [95777993643016] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Arunika.lua",
    [102234703920418] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Daun.lua",
    [89100225746834] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Tanditek.lua",
    [73384821369941] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Ulap.lua",
    [123224294054165] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Atin.lua",
    [8735521924] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/DISX/shieldtcentaura-enc.lua",
    [86076978383613] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/huntyZomby.lua",
    [103754275310547] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/huntyZomby.lua",
    [128473079243102] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/arunika2.lua"
}
local currentPlaceId = game.PlaceId
if placeScripts[currentPlaceId] then
    local scriptUrl = placeScripts[currentPlaceId]
    local success, result = pcall(function()
        return loadstring(game:HttpGet(scriptUrl))()
    end)
    if not success then
        warn("Failed to execute script for place " .. currentPlaceId .. ": " .. result)
    end
else
    print("No script defined for place ID: " .. currentPlaceId)
end
