
require('actions')
res = require('resources')

local queue = {}
local performing = {}
local enabled = false
local lastcasttime = os.clock()
local castingtimeout = nil
local castingtimeout_cmd = nil
local targetmode = false

function add_spell(typ, spell, tar)
    table.insert(queue, {['type']=typ, ['spell']=spell, ['target']=tar or 'me'})
end

function add_command(cmd)
    table.insert(queue, {['type']='cmd', ['command']=cmd})
end

require('logger')
function cast_all()
    -- log(#queue)
    if #queue == 0 then
        log('Nothing can be cast')
    end
    enabled = true
end

local DEFAULT_WAIT_TIME = 2
local wait_time = DEFAULT_WAIT_TIME

function cast_reset()
	cast_init()
	performing = {}
end

function cast_timeout(cmd)
	castingtimeout_cmd = cmd
end
function cast_targetmode()
	targetmode = true
end

function cast_init()
    queue = {}
	targetmode = false
	castingtimeout_cmd = nil
	wait_time = DEFAULT_WAIT_TIME
end

function cast_time(sec)
	wait_time = sec
end

windower.register_event('prerender', function()
	if enabled and targetmode then
		local target = windower.ffxi.get_mob_by_target('t')
		if not target or (target and not isMob(target.id))then
			cast_reset()
			log('No target, reset')
			return
		end
	end
    if enabled and os.clock() - lastcasttime > wait_time and #queue > 0 and not performing.casting then
        q = queue[1]
        if q.type == 'cmd' then
            windower.send_command('input '..windower.to_shift_jis(q.command))
            table.remove(queue, 1)
            performing = {}
            if #queue == 0 then
                enabled = false
                -- log('All done')
            end
        else
            performing.type = q.type
            performing.spell = q.spell
            performing.target = q.target
            -- log('Perform '..performing.spell)
            windower.send_command('input /'..performing.type..' '..windower.to_shift_jis(performing.spell)..' <'..performing.target..'>')
			if not castingtimeout then
				castingtimeout = os.clock()
			end
        end
        
        lastcasttime = os.clock()
    end
	if enabled and castingtimeout and os.clock() - castingtimeout > 10 then
		castingtimeout = nil
		log('found timeout')
		cast_reset()
		if castingtimeout_cmd then
			windower.send_command('input '..windower.to_shift_jis(castingtimeout_cmd))
		end
	end
end)

ActionPacket.open_listener(function(act)
    if not enabled or not performing.type or act.param == 0 then
        return
    end
    local actionpacket = ActionPacket.new(act)
    local category = actionpacket:get_category_string()
    local target = actionpacket:get_targets()()
    local acts = target:get_actions()()
    local param, resource, action_id, interruption, conclusion = acts:get_spell()
    -- log(category)
    if category == 'casting_begin' and not interruption then
        if not performing.casting and res[resource][action_id].name == performing.spell then
            -- log('casting')
            performing.casting = true
			castingtimeout = nil
        end
		
    elseif category == 'casting_begin' and interruption then
		performing = {}
        
    elseif S{'job_ability','job_ability_unblinkable'}:contains(category) then
        if res[resource][action_id].name == performing.spell then
            -- log('done')
            table.remove(queue, 1)
            performing = {}
			castingtimeout = nil
            if #queue == 0 then
                enabled = false
                -- log('All done')
            end
        end
        
    elseif S{'spell_finish'}:contains(category) then
        if performing.casting and res[resource][action_id].name == performing.spell then
            -- log('done')
            table.remove(queue, 1)
            performing = {}
            if #queue == 0 then
                enabled = false
                -- log('All done')
            end
        end
    end
end)
