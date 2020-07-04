local LED_COUNT = 120
local PORT = 42170

print("[LUX] Initializing ws2812...")
ws2812.init()
ws2812.write(string.rep(string.char(0x00), LED_COUNT * 3))

print("[LUX] Creating UDP socket...")
local socket = net.createUDPSocket()

local handle_data = function(sock, data, remote_port, remote_ip)
    local data_len = string.len(data)
    if data_len < 3 then
        print("[LUX] Message has invalid length: " .. data_len)
        return
    end

    if data:byte(1) ~= 0x4C or data:byte(2) ~= 0x58 then
        print("[LUX] Invalid header")
        return
    end

    local mode = data:byte(3)
    local effect_payload_offset = 4

    if (mode == 0) then
        local led_count = data:byte(effect_payload_offset)

        local expected_data_len = effect_payload_offset + led_count * 3
        if expected_data_len ~= data_len then
            print("[LUX] Message length expected " .. expected_data_len .. ", got " .. data_len)
            return
        end

        ws2812.write(data:sub(effect_payload_offset + 1))
    elseif (mode == 0xff) then
        sock:send(remote_port, remote_ip, "1")
    else
        -- TODO Add support for other modes
        print("[LUX] Unsupported mode: " .. mode)
        return
    end
end

socket:on("receive", handle_data)


print("[LUX] Listening on port " .. PORT)
socket:listen(PORT)