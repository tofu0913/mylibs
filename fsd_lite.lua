
local callback_table = {}

function fsd_go(app, path, callback)
    key = tostring(os.clock()*1000)
    callback_table[key] = callback
    windower.send_command("input //fsd g "..path.." "..key.." "..app)
end

function fsd_to(app, x, y, callback)
    key = tostring(os.clock()*1000)
    callback_table[key] = callback
    windower.send_command("input //fsd t "..x.." "..y.." "..key.." "..app)
end

function fsd_go_loop(app, path)
    windower.send_command("input //fsd l "..path)
end

function fsd_go_reverse(app, path, callback)
    key = tostring(os.clock()*1000)
    callback_table[key] = callback
    windower.send_command("input //fsd gr "..path.." "..key.." "..app)
end

function fsd_go_back(app, callback)
    key = tostring(os.clock()*1000)
    callback_table[key] = callback
    windower.send_command("input //fsd b "..key.." "..app)
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