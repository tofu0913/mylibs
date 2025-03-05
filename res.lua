
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