
local record_timer = os.clock()
local pre_pos = {x=9999,y=9999}
local follow_name = nil
local follow_queue = {}
local follow_target = {}
local follow_target_dist = 1

function runtopos(x,y)
	-- log(x..','..y)
	local self_vector = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
	local angle = (math.atan2((y - self_vector.y), (x - self_vector.x))*180/math.pi)*-1
	windower.ffxi.run((angle):radian())
end

function follow_start(input)
	p = nil
	if type(input) == "number" then
		p = windower.ffxi.get_mob_by_id(input)
	elseif type(input) == "string" then
		p = windower.ffxi.get_mob_by_name(name)
	end
	if p then
		if math.sqrt(p.distance) > 20 then
			log('Target too far...')
		else
			follow_name = p.name
		end
	else
		log('Nothing can follow')
	end
end

function follow_stop()
	follow_name = nil
	follow_queue = {}
	follow_target = {}
	windower.ffxi.run(false)
end

windower.register_event('prerender', function(...)
    if follow_name then
        pl = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
        if pl then
			if os.clock() - record_timer >= 0.1 then
				local target = windower.ffxi.get_mob_by_name(follow_name)
				if target then
					-- log(target.x..','..target.y)
					if math.sqrt(math.pow(target.x-pl.x,2) + math.pow(target.y-pl.y,2)) <= 20 and	--ignore too far
						math.sqrt(math.pow(target.x-pre_pos.x,2) + math.pow(target.y-pre_pos.y,2)) ~=0 then	--ignore the same pos
						pre_pos.x = target.x
						pre_pos.y = target.y
						table.insert(follow_queue, pre_pos)
					end
				end
				record_timer = os.clock()
			end
			if next(follow_target) == nil then
				local item = table.remove(follow_queue, 1)
				if item then
					follow_target = item
				else
					follow_target = {}
				end
			end
			if next(follow_target) ~= nil then
				local distance = math.sqrt(math.pow(pl.x-follow_target.x,2) + math.pow(pl.y-follow_target.y,2))
				-- log(distance)
				if distance > follow_target_dist then
					runtopos(follow_target.x, follow_target.y)
				else
					follow_target = {}
					windower.ffxi.run(false)
				end
			end
        end
    end
end)