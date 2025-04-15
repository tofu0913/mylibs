
res = require('resources')

function get_job_abilities(input)
	for key, item in pairs(res.job_abilities) do
		-- if type(input) == "string" and item.ja == input then
			-- return item
		-- else
		if input.en and item.en == input.en then
			return item
		elseif input.ja and item.ja == input.ja then
			return item
		end
	end
end

function get_spells(input)
	for key, item in pairs(res.spells) do
		-- if type(input) == "string" and item.ja == input then
			-- return item
		-- else
		if input.en and item.en == input.en then
			return item
		elseif input.ja and item.ja == input.ja then
			return item
		end
	end
end

function get_zone(ja)
    for key,zone in pairs(res.zones) do
		if zone.ja == ja then
			return zone
		end
	end
end

function get_job_id(ens)
    for key,job in pairs(res.jobs) do
		if job.ens == ens then
			return job.id
		end
	end
end