
function checkDeBuffs()
    local player = windower.ffxi.get_player()
    local buffs = S(player.buffs):map(string.lower .. table.get-{'english'} .. table.get+{res.buffs})
    if buffs.sleep or buffs.petrification or buffs.stun or buffs.charm or buffs.amnesia or buffs.terror or buffs.lullaby or buffs.impairment then
        return false
    end
    return true
end

function hasBuff(buffname)
    for i,v in pairs(windower.ffxi.get_player()['buffs']) do
        if res.buffs[v] and res.buffs[v].ja == buffname then
            return true
        end
    end
    return false
end

function isJob(job)
    if windower.ffxi.get_player().main_job == job then
        return true
    end
    return false
end

function isSubJob(job)
    if windower.ffxi.get_player().sub_job == job then
        return true
    end
    return false
end

function isInParty(pid)
    if pid == windower.ffxi.get_player().id then
        return true
    end
    local pt = windower.ffxi.get_party()
    for i = 0, 5 do
        local member = pt['p'..i]
        if member ~= nil and member.mob and member.mob.id == pid then
            return true
        end
    end
    return false
end

function getPartyTarget()
	local pt = windower.ffxi.get_party()
    for i = 0, 5 do
        local member = pt['p'..i]
		if member and member.mob then
			if member.mob.status == 1 and member.mob.target_index > 0 then
				local t = windower.ffxi.get_mob_by_index(member.mob.target_index)
				if t and t["valid_target"] and t["hpp"] >0 and t['spawn_type']==16 then
					return member.mob.target_index
				end
			end
		end
	end
	return 0
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function dump_res()
    local file = assert(io.open(windower.addon_path..'test.lua', "w"))
    file:write('short_song_names = {\n')
    for id in res.spells:prefix('/song'):keyset():it() do
        spell = res.spells[id]
        file:write('\t["'..spell.en..'"] = {id='..spell.id..',en="'..spell.en..'",ja="'..spell.ja..'"},\n')
    end
    file:write('}\nreturn short_song_names')
    file:close()
end

function array_contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function string_split(s, p)
    local temp = {}
    local index = 0
    local last_index = string.len(s)
    if not string.find(s, p, index) then
        table.insert(temp, s)
        return temp
    end

    while true do
        local i, e = string.find(s, p, index)

        if i and e then
            local next_index = e + 1
            local word_bound = i - 1
            table.insert(temp, string.sub(s, index, word_bound))
            index = next_index
        else            
            if index > 0 and index <= last_index then
                table.insert(temp, string.sub(s, index, last_index))
            elseif index == 0 then
                temp = nil
            end
            break
        end
    end

    return temp
end

function in_pos(x, y)
	local pl = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
	if math.sqrt(math.pow(x-pl.x,2) + math.pow(y-pl.y,2)) < 5 then
		return true
	end
	return false
end

function isMob(id)
    m = windower.ffxi.get_mob_by_id(id)
    if m and m['spawn_type']==16 and m['hpp'] >0 then
        return true
    end
    return false
end