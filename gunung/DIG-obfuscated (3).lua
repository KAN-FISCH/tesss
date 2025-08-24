local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local searchHwidUrl = "http://api.shieldteamhq.com/api/key/search-hwid"
local validateKeyUrl = "http://api.shieldteamhq.com/api/key/validate"
local urlExecute = "http://api.shieldteamhq.xyz/api/key/execute"

-- Fungsi untuk mendapatkan API key dari berbagai sumber
local function getApiKey()
    -- Cari dari berbagai sumber yang mungkin
    if script_key then
        return script_key
    elseif _G.script_key then
        return _G.script_key
    elseif getgenv and getgenv().script_key then
        return getgenv().script_key
    elseif shared and shared.script_key then
        return shared.script_key
    end
    
    -- Jika tidak ditemukan, minta input dari user
    print("🔑 SILAKAN MASUKKAN API KEY ANDA:")
    local input = read() or ""
    
    if input and input ~= "" then
        return input
    else
        warn("❌ API KEY TIDAK VALID!")
        LocalPlayer:Kick("API KEY TIDAK DITEMUKAN! Silakan hubungi support.")
        return nil
    end
end

-- Dapatkan API key
local apiKey = getApiKey()

if not apiKey or apiKey == "" then
    return -- Stop execution jika tidak ada key
end

print("🔑 API Key yang digunakan:", apiKey)

-- Fungsi searchHwid
local function searchHwid(apiKey, hwid)
    local success, response = pcall(function()
        return request({
            Url = searchHwidUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                apiKey = apiKey,
                hwid = hwid
            })
        })
    end)
    
    if not success then
        warn("❌ Gagal menghubungi API (search HWID):", response)
        LocalPlayer:Kick("Tidak dapat terhubung ke server validasi.")
        return false
    end
    
    local status, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    
    if not status then
        warn("❌ Gagal parsing response:", data)
        LocalPlayer:Kick("Kesalahan dalam memproses data validasi.")
        return false
    end
    
    if data.error == "API key tidak ditemukan atau nonaktif" then
        warn("❌ API key tidak valid")
        LocalPlayer:Kick("KEY Anda tidak valid.")
        return false
    end
    
    if data.error == "expired" then
        warn("❌ API key expired")
        LocalPlayer:Kick("Masa aktif KEY sudah habis. Silakan perpanjang.")
        return false
    end
    
    if data.error == "HWID BERBEDA GUNAKAN KEY LAIN" then
        warn("❌ HWID berbeda/ kosong")
        LocalPlayer:Kick("HWID berbeda! Harap gunakan KEY lain.")
        return false
    end
    
    if data.hwid == "HWID belum terdaftar" then
        print("ℹ️ HWID belum terdaftar")
        return false
    end
    
    if data.hwid ~= hwid then
        warn("❌ HWID berbeda! Terdaftar:", data.hwid, " | Saat ini:", hwid)
        LocalPlayer:Kick("HWID tidak cocok. Akses ditolak.")
        return false
    end
    
    print("✅ HWID terdaftar:", data.hwid)
    return true
end

-- Fungsi validateKey
local function validateKey(apiKey, hwid)
    local success, response = pcall(function()
        return request({
            Url = validateKeyUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                apiKey = apiKey,
                hwid = hwid
            })
        })
    end)
    
    if not success then
        warn("❌ Gagal menghubungi API (validate Key):", response)
        return false
    end

    local status, body = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    
    if not status then
        warn("❌ Gagal parsing response:", body)
        return false
    end
    
    if body.message == "API key valid dan HWID cocok" or body.message == "HWID ditambahkan, API key diaktifkan" then
        print("✅ API Key valid dan HWID cocok.")
        return true
    else
        warn("❌ Validasi gagal:", body.error or "Tidak diketahui")
        return false
    end
end

-- Fungsi runScript
local function runScript(apiKey)
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    print("🆔 HWID Anda:", hwid)
    
    if not searchHwid(apiKey, hwid) then
        if not validateKey(apiKey, hwid) then
            warn("❌ Validasi gagal. Skrip dihentikan.")
            LocalPlayer:Kick("KEY tidak valid.")
            return false
        end
    end
    
    print("✅ [🔒] Validasi berhasil! Menjalankan skrip premium...")
    return true
end

-- Fungsi untuk memuat script premium
local function loadPremiumScript()
    print("🚀 Memuat script premium...")
    
    -- Ganti dengan URL script premium Anda
    local premiumScriptUrl = "https://raw.githubusercontent.com/username/repo/main/premium-script.lua"
    
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(premiumScriptUrl)
        return loadstring(scriptContent)()
    end)
    
    if not success then
        warn("❌ Gagal memuat script premium:", result)
    end
end

-- Fungsi executeScript
function executeScript()
    print("🚀 [DEBUG] Mengeksekusi script...")
    
    -- Kirim request ke urlExecute
    local execSuccess, execResponse = pcall(function()
        return request({
            Url = urlExecute,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                apiKey = apiKey
            })
        })
    end)
    
    if not execSuccess then
        warn("❌ Gagal menghubungi server execute:", execResponse)
        return
    end
    
    if runScript(apiKey) then
        -- Jika validasi berhasil, load script premium
        loadPremiumScript()
    end
end

-- Jalankan script
executeScript()
