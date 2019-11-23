local STARTUP_DELAY = 0
local ENABLE_NTP = false
local MDNS_NAME = "esp01"

-- -------------------------------------------------------------------------


local function pcall_dofile(f)
    local ok, err = pcall(dofile, f)
    if not ok then
        return nil, err
    end
    return err
end


local has_run_startup = false
function startup()
    if not file.exists("init.lua") then
        print("[init] init.lua has been removed")
        return
    end

    local application, err = pcall_dofile("application.lc")
    if not err then
        has_run_startup = true
    else
        print("[init] application failed to load", err)
    end
end

-- -------------------------------------------------------------------------

local wifi_config = pcall_dofile("wifi_config.lc")
if not wifi_config then
    print("[init] Missing wifi_config.lc")
    return
end

-- Define WiFi station event callbacks
local wifi_connect_event = function(T)
    print("[init] Connected to '" .. T.SSID .. "'")
    print("[init] Waiting for IP address...")
end

local timesync
local wifi_got_ip_event = function(T)
    -- Note: Having an IP address does not mean there is internet access!
    -- Internet connectivity can be determined with net.dns.resolve().

    print("[init] IP Address: " .. T.IP)

    if not has_run_startup then
        if ENABLE_NTP then
            timesync = pcall_dofile("timesync.lc")
            timesync.sync()
        end

        if STARTUP_DELAY > 0 then
            print("[init] You have " .. STARTUP_DELAY .. " seconds to abort startup")
            tmr.create():alarm(STARTUP_DELAY * 1000, tmr.ALARM_SINGLE, startup)
        else
            startup()
        end
    else
        if ENABLE_NTP then
            timesync.sync_once()
        end
    end

    mdns.register(MDNS_NAME)
end

local wifi_disconnect_event = function(T)
    if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then
        -- the station has disassociated from a previously connected AP
        return
    end

    print("\n[init] Could not connect to '" .. T.SSID .. "'")

    -- There are many possible disconnect reasons, the following iterates through
    -- the list and returns the string corresponding to the disconnect reason.
    for key, val in pairs(wifi.eventmon.reason) do
        if val == T.reason then
            print("[init] Disconnect reason: " .. val .. "(" .. key .. ")")
            break
        end
    end
end

-- Register WiFi Station event callbacks
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)

print("[init] Connecting to '" .. wifi_config.WIFI_SSID .. "'")
wifi.setmode(wifi.STATION)

wifi.sta.config({ ssid = wifi_config.WIFI_SSID, pwd = wifi_config.WIFI_PSK })
