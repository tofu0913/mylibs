
require('mylibs/res')
require('mylibs/caster')

local done_callback = nil

local function isInParty(name)
	en = get_spells({['ja']=name}).en:split(' (UC)')[1]
    local pt = windower.ffxi.get_party()
    for i = 0, 5 do
        local member = pt['p'..i]
        if member ~= nil and member.name == en then
            return true
        end
    end
    return false
end

function callnpc(cmd, callback)
	if not TRUSTS then
		log('No TRUSTS configured...')
	end
	
	cast_init()
	for c = 1, #TRUSTS do
		if not isInParty(TRUSTS[c]) then
			add_spell('ma', TRUSTS[c])
			-- log('calling '..TRUSTS[c])
		end
    end
	add_command('//'..cmd..' TRUST_callback:done')
	cast_all()
	done_callback = callback
end

windower.register_event('addon command', function(command, ...)
	if command == 'TRUST_callback:done' and done_callback then
		done_callback()
	end
end)