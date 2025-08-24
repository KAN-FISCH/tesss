local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local request = (syn and syn.request) or (http and http.request) or request

local searchHwidUrl = "http://api.shieldteamhq.com/api/key/search-hwid"
local validateKeyUrl = "http://api.shieldteamhq.com/api/key/validate"
local urlExecute = "http://api.shieldteamhq.xyz/api/key/execute"


local success, response = pcall(function()
    return request({
        Url = urlExecute,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            apiKey = "poqe"
        })
    })
end)

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
        warn("Gagal menghubungi API (search HWID):", response)
        LocalPlayer:Kick("Tidak dapat terhubung ke server validasi.")
        return false
    end
    local status, data = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    if not status then
        warn("Gagal parsing response:", data)
        LocalPlayer:Kick("Kesalahan dalam memproses data validasi.")
        return false
    end
    if data.error == "API key tidak ditemukan atau nonaktif" then
        warn("API key tidak valid")
        LocalPlayer:Kick("KEY Anda tidak valid.")
        return false
    end
    if data.hwid == "HWID belum terdaftar" then
        print("HWID belum terdaftar:", data.hwid)
        return false
    end
    if data.hwid ~= hwid then
        warn("HWID berbeda! Terdaftar:", data.hwid, " | Saat ini:", hwid)
        LocalPlayer:Kick("HWID tidak cocok. Akses ditolak.")
        return false
    end
    print("HWID terdaftar:", data.hwid)
    return true
end

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
        warn("Gagal menghubungi API (validate Key):", response)
        return false
    end

    local status, body = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    if not status then
        warn("Gagal parsing response:", body)
        return false
    end
    local data = body
    if data.message == "API key valid dan HWID cocok" or data.message == "HWID ditambahkan, API key diaktifkan" then
        print("API Key valid dan HWID cocok.")
        return true
    else
        warn("Validasi gagal:", data.error or "Tidak diketahui")
        return false
    end
end

local function runScript(apiKey)
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    print("HWID Anda:", hwid)
    
    if not searchHwid(apiKey, hwid) then
        if not validateKey(apiKey, hwid) then
            warn("Validasi gagal. Skrip dihentikan.")
            LocalPlayer:Kick("KEY tidak valid.")
            return false
        end
    end
    
    print("[🔒] Menjalankan skrip premium...")
    return true
end

function executeScript()
    print("[DEBUG] Mengeksekusi script...")
	request({Url = urlExecute,Method = "POST",Headers = {["Content-Type"] = "application/json"}
    })
    if not script_key then
        warn("[❌] script_key tidak ditemukan! Harap masukkan API key.")
        LocalPlayer:Kick("U DOESNT HAVE ACCESS ! FUCK U")
        return
    end
	
    print("[DEBUG] API Key yang digunakan:", script_key)
    if runScript(script_key) then
        print('tesssssssss')
		
    end
end

executeScript()
