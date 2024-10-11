
local callback_table = {}

function fsd_go(app, path, callback)
    key = tostring(os.clock()*1000)
    callback_table[key] = callback
    windower.send_command("input //fsd g "..path.." "..key.." "..app)
end

windower.register_event('addon command', function(command, ...)
    if string.find(command, 'FSD_callback:') == 1 then
        key = string.sub(command, 14, -1)
        if key and callback_table[key] then
            cb = callback_table[key]
            callback_table[key] = nil
            cb()
        end
    end
end)