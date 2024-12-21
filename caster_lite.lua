
local queue = {}

function add_spell(typ, spell, tar)
    table.insert(queue, {['type']=typ, ['spell']=spell, ['target']=tar or 'me'})
end

function add_command(cmd)
    table.insert(queue, {['type']='cmd', ['command']=cmd})
end

function cast_all()
    local str = 'input //as init; wait 0.1;'
    for _,q in pairs(queue) do
        if q.type == 'cmd' then
            str = str .. ('input //as add '..q.type..' "'..q.command..'";')
        else
            str = str .. ('input //as add '..q.type..' "'..windower.to_shift_jis(q.spell)..'" '..q.target..'; wait 0.1;')
        end
    end
    str = str .. 'input //as cast'
    windower.send_command(str)
    queue = {}
end

function cast_init()
	queue = {}
end
