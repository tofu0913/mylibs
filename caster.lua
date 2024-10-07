
require('actions')

local queue = {}
local performing = {}
local enabled = false
local lastcasttime = os.clock()

function add_spell(typ, spell, tar)
    table.insert(queue, {['type']=typ, ['spell']=spell, ['target']=tar or 'me'})
end

function cast_all()
    if #queue == 0 then
        log('Nothing can be cast')
    end
    enabled = true
end

windower.register_event('prerender', function()
    if enabled and os.clock() - lastcasttime > 1 and #queue > 0 and not performing.casting then
        q = queue[1]
        performing.type = q.type
        performing.spell = q.spell
        performing.target = q.target
        -- log('Perform '..performing.spell)
        windower.send_command(windower.to_shift_jis('input /'..performing.type..' '..performing.spell..' <'..performing.target..'>'))
        
        lastcasttime = os.clock()
    end
end)

ActionPacket.open_listener(function(act)
    if not performing.type or act.param == 0 then
        return
    end
    local actionpacket = ActionPacket.new(act)
    local category = actionpacket:get_category_string()
    local target = actionpacket:get_targets()()
    local acts = target:get_actions()()
    local param, resource, action_id, interruption, conclusion = acts:get_spell()
    if category == 'casting_begin' then
        if not performing.casting and res[resource][action_id].name == performing.spell then
            -- log('casting')
            performing.casting = true
        end
        
    elseif category == 'spell_finish' then
        if performing.casting and res[resource][action_id].name == performing.spell then
            -- log('done')
            table.remove(queue, 1)
            performing = {}
            if #queue == 0 then
                enabled = false
                log('All done')
            end
        end
    end
end)
