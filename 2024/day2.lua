FILENAME_INPUT = "inputs/input2.txt"
--FILENAME_INPUT = "inputs/sample2.txt"


function parse_data(filename)
	local f = io.open(filename, "r")
	local raw_data = f:read("*all")
	f:close()

	local data = {}
	-- Lua start indeces at 1
	local idx = 1

	for line in raw_data:gmatch("[^\r\n]+") do
		table.insert(data, {})
		for num in line:gmatch("%d+") do
			table.insert(data[idx], tonumber(num))
		end
		idx = idx + 1
	end

	return data
end

function part1(data)
	local res = 0

	for _, report in ipairs(data) do
		-- true when increasing
		local first_direction = report[2] - report[1] > 0
		local diff, current_direction
		local direction_changed, unsafe_level
		local safe_report = true

		for i = 2, #report do
			diff = report[i] - report[i-1]
			current_direction = diff > 0

			direction_changed = not (current_direction == first_direction)
			unsafe_level = math.abs(diff) < 1 or 3 < math.abs(diff) 

			if direction_changed or unsafe_level then
				safe_report = false
				break
			end
		end

		if safe_report then
			res = res + 1
		end
	end

	return res
end

function part2(data)
	local res = 0

	return res
end


local data = parse_data(FILENAME_INPUT)
print("part 1:", part1(data))
--print("part 2:", part2(data))

