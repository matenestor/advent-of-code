local inspect = require("inspect")


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

function is_unsafe_level_change(a, b, first_direction)
	local diff = b - a
	local current_direction = diff > 0

	local direction_changed = not (current_direction == first_direction)
	local unsafe_level = math.abs(diff) < 1 or 3 < math.abs(diff) 

	--[[
	]]
	print(string.format("D:%s\tCD:%s FD:%s CH:%s UL:%s",
		tostring(diff),
		tostring(current_direction),
		tostring(first_direction),
		tostring(direction_changed),
		tostring(unsafe_level)
	))

	return direction_changed or unsafe_level
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

function try_dropping_elements(report, i)
	-- try droping elements from two elements back
	for drop_index = i-2, i do
		local report_mod = drop_element(report, drop_index)
		print(">>" .. inspect(report_mod))
		if is_report_safe(report_mod, false) then
			-- found a safe report after droping an element
			return true
		end
	end

	return false
end

function is_report_safe(report, problem_damper_active)
	local first_direction = report[2] - report[1] > 0
	local safe_report = true

	for i = 2, #report do
		if is_unsafe_level_change(report[i-1], report[i], first_direction) then
			if problem_damper_active then
				-- FIXME this leads to indirect recursion...
				if not try_dropping_elements(report, i) then
					safe_report = false
				end

				-- the rest of the report is already checked from the recursion
				break
			else
				safe_report = false
				break
			end
		end
	end

	return safe_report
end

function part2(data)
	local res = 0

	for _, report in ipairs(data) do
		if is_report_safe(report, true) then
			print("OK " .. inspect(report)) 
			res = res + 1
		else
			print("   " .. inspect(report)) 
		end
		print()
	end

	return res
end


local data = parse_data(FILENAME_INPUT)
--print("part 1 (2):", part1(data))
print("part 2 (4):", part2(data))

