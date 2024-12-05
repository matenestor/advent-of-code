FILENAME_INPUT = "inputs/input2.txt"
--FILENAME_INPUT = "inputs/sample2.txt"


function parse_data(filename)
	local f = io.open(filename, "r")
	local raw_data = f:read("*all")
	f:close()

	local data = {}
	-- Lua indeces start at 1
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

function is_report_safe(report)
	-- true when ascending
	local first_direction = report[1] - report[2] < 0

	for i = 1, #report-1 do
		local diff = report[i] - report[i+1]
		local current_direction = diff < 0

		local direction_changed = current_direction ~= first_direction
		local unsafe_level = math.abs(diff) < 1 or 3 < math.abs(diff) 

		if direction_changed or unsafe_level then
			return false
		end
	end

	return true
end

function part1(data)
	local res = 0

	for _, report in ipairs(data) do
		if is_report_safe(report) then
			res = res + 1
		end
	end

	return res
end

function drop_element(array, index)
	local new_array = {}
	for i, e in ipairs(array) do
		if i ~= index then
			table.insert(new_array, e)
		end
	end
	return new_array
end

function try_dropping_elements(report)
	for drop_index = 1, #report do
		local report_mod = drop_element(report, drop_index)

		if is_report_safe(report_mod) then
			-- found a safe report after droping an element
			return true
		end
	end

	return false
end

function part2(data)
	local res = 0

	for _, report in ipairs(data) do
		if is_report_safe(report) then
			res = res + 1
		-- this function could take an index of the element that is causing the
		-- report ot be unsafe and check only from the index-2
		elseif try_dropping_elements(report) then
			res = res + 1
		end
	end

	return res
end


local data = parse_data(FILENAME_INPUT)
print("part 1 (2):", part1(data))
print("part 2 (4):", part2(data))

