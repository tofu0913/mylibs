
local queue = {}

function add_spell(typ, spell, tar)
    table.insert(queue, {['type']=typ, ['spell']=spell, ['target']=tar or 'me'})
end

function cast_all()
    local str = ''
    for _,q in pairs(queue) do
        str = str .. ('input //as add '..q.type..' "'..q.spell..'" '..q.target..'; wait 0.1;')
    end
    send_command(str)
    send_command('input //as cast')
end

function cast_init()
    send_command('input //as init')
end
