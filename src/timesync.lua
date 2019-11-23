local callback = function(sec, usec, server, info)
    print("[Timesync] Synchronized", sec, usec, server)
end

local err_cb = function(code, cause)
    print("[Timesync] Error", code, cause)
end


local function sync()
    sntp.sync(nil, callback, err_cb, 1)
end

local function sync_once()
    sntp.sync(nil, callback, err_cb)
end


return {
    sync = sync,
    sync_once = sync_once
}
