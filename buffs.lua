
packets = require('packets')
local member_table = S{nil, nil, nil, nil, nil}

function parse_buffs(data)
    for  k = 0, 4 do
        local id = data:unpack('I', k*48+5)
        
        if id ~= 0 then
            for i = 1, 32 do
                local buff = data:byte(k*48+5+16+i-1) + 256*( math.floor( data:byte(k*48+5+8+ math.floor((i-1)/4)) / 4^((i-1)%4) )%4) -- Credit: Byrth, GearSwap
                if member_table[id] then
					member_table[id]['buffs'][i] = buff
				end
            end
        end
    end
end

windower.register_event('incoming chunk', function(id, data)
    if id == 0x0DD then
        local packet = packets.parse('incoming', data)
        
        if not member_table:contains(packet['Name']) then
            member_table:append(packet['Name'])
            member_table[packet['ID']] = {['name']=packet['Name'], ['buffs']={}}
        end
    end
    
    if id == 0x076 then
        parse_buffs(data)
    end
end)

function init_member_table()
	local party = windower.ffxi.get_party()
    local key_indices = {'p1', 'p2', 'p3', 'p4', 'p5'}
    
    for k = 1, 5 do
        local member = party[key_indices[k]]
        
        if member and member.mob then
            if not member.mob.is_npc and not member_table:contains(member.name) then
                member_table[k] = member.name
                member_table[member.mob.id] = {['name']= member.name, ['buffs']={}}
                -- member_table[member.name] = member.mob.id
            end
        end
    end
end

function check_buff(buffs, buff_id)
	local got = false
	for i = 1, #buffs do
		if buffs[i] == buff_id then
			got = true
		end
	end
	return got
end

function check_buffs(buffs, targets)
	for i = 1, #targets do
		for k = 1, #buffs do
			if buffs[k] == targets[i] then
				log('have '..targets[i])
				return true
			end
		end
	end
	return false
end

function has_pt_buffs(buffnames)
	buff_ids = {}
	for key, item in pairs(res.buffs) do
		if buffnames:contains(item.ja) then
			table.insert(buff_ids, #buff_ids, item.id)
		end
	end
	-- Check self first
	if not check_buffs(windower.ffxi.get_player().buffs, buff_ids) then
		return windower.ffxi.get_player().id
	end
	-- Check pt members
    for k = 1, 5 do
        local member = windower.ffxi.get_party()['p'..k]
		if member and member.mob and member_table[member.mob.id] and math.sqrt(member.mob.distance) < 20 then
			if #member_table[member.mob.id]['buffs'] > 0 then
				-- if not check_buff(member_table[member.mob.id]['buffs'], buff_id) then
					-- return member.name
				if not check_buffs(member_table[member.mob.id]['buffs'], buff_ids) then
					return member.name
				end
			end
		end
	end
	return nil
end

function check_pt_buff(buff_id)
	if not check_buff(windower.ffxi.get_player().buffs, buff_id) then
		return windower.ffxi.get_player().id
	end
    for k = 1, 5 do
        local member = windower.ffxi.get_party()['p'..k]
		if member and member.mob and member_table[member.mob.id] and math.sqrt(member.mob.distance) < 20 then
			if #member_table[member.mob.id]['buffs'] > 0 then
				if not check_buff(member_table[member.mob.id]['buffs'], buff_id) then
					return member.name
				end
			end
		end
	end
end

function has_pt_buff(buffname)
	for key, item in pairs(res.buffs) do
		if item.ja == buffname then
			return check_pt_buff(item.id)
		end
	end
	return nil
end

function has_ptnames_buff(names, buffname)
	local buff_id = 0
	for key, item in pairs(res.buffs) do
		if item.ja == buffname then
			buff_id = item.id
			break
		end
	end
	if buff_id == 0 then return end
	if names:contains(windower.ffxi.get_player().name) and not check_buff(windower.ffxi.get_player().buffs, buff_id) then
		return windower.ffxi.get_player().id
	end
    for k = 1, 5 do
        local member = windower.ffxi.get_party()['p'..k]
		if member and names:contains(member.name) and member.mob and member_table[member.mob.id] and math.sqrt(member.mob.distance) < 20 then
			if #member_table[member.mob.id]['buffs'] > 0 then
				if not check_buff(member_table[member.mob.id]['buffs'], buff_id) then
					return member.name
				end
			end
		end
	end
end

function count_songs(buffs)
	local count = 0
	for i = 1, #buffs do
		if buffs[i] >= 195 and buffs[i] <= 222 and buffs[i] ~= 217 then
			count = count +1
		end
	end
	return count
end

function get_song_counts()
	local counts = {}
	counts[1] = count_songs(windower.ffxi.get_player().buffs)
	
	local party = windower.ffxi.get_party()
    local key_indices = {'p1', 'p2', 'p3', 'p4', 'p5'}
    
    for k = 1, 5 do
        local member = party[key_indices[k]]
		if member and member.mob and member_table[member.mob.id] and math.sqrt(member.mob["distance"]) <= 20 then
			if #member_table[member.mob.id]['buffs'] > 0 then
				counts[k+1] = count_songs(member_table[member.mob.id]['buffs'])
			end
		end
	end
	return counts
end

function get_max_song_count()
	local rtn = 0
	local five = true
	local four = true
	local c = get_song_counts()
	for i = 1, #c do
		if c[i] then
			if c[i] > rtn then
				rtn = c[i]
			end
			if c[i] < 5 then
				five = false
			end
			if c[i] ~= 4 then
				four = false
			end
		end
	end
	if five then
		return 5.1
	elseif four then
		return 4.1
	end
	return rtn
end