-- to create a constant use (really..?)
-- local FILENAME_INPUT <const> = "inputs/input1.txt"
FILENAME_INPUT = "inputs/input1.txt"

-- Everything is 'global' by default.
-- So. Write. 'local'. Everywhere. -_-


function parse_data(filename)
	local f = io.open(filename, "r")
	local data = f:read()
	f:close()
	return data
end

function part1(data)
	-- Count the '(' character by replacing everything else with nothing
	-- The arrow up in "[^ ]" is a negation of what to search for
	-- The hashmark '#' in the beginning is to get count of the return array
	local opening = #data:gsub("[^(]", "")
	local closing = #data:gsub("[^)]", "")

	return opening - closing
end

function part2(data)
	local floor, idx = 0, 0

	-- to enumerate an iterator like in Python, define own 'enumerate' function
	--
	-- local function enumerate(iter)
	-- 	local i = 0
	-- 	return function()
	-- 		i = i + 1
	-- 		return i, iter()
	-- 	end
	-- end

	-- iterate every character by matching every character
	for c in data:gmatch(".") do
		if c == ")" then floor = floor - 1
		else			 floor = floor + 1
		end

		-- Lua doesn't have +=, -=, etc.
		idx = idx + 1
		if floor == -1 then break end
	end

	return idx
end


data = parse_data(FILENAME_INPUT)
print("part 1:", part1(data)) -- 74
print("part 2:", part2(data)) -- 1795

