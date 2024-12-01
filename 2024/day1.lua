FILENAME_INPUT = "inputs/input1.txt"
--FILENAME_INPUT = "inputs/sample1.txt"


function parse_data(filename)
	local f = io.open(filename, "r")
	local raw_data = f:read("*all")
	f:close()

	local data = {
		left = {},
		right = {},
	}

	-- separate numbers from the file into two arrays
	for line in raw_data:gmatch("[^\r\n]+") do
		local nums_match = line:gmatch("%d+")

		table.insert(data["left"], tonumber(nums_match()))
		table.insert(data["right"], tonumber(nums_match()))
	end

	return data
end

function part1(data)
	local res = 0

	table.sort(data["left"])
	table.sort(data["right"])

	for i = 1,#data.right do
		res = res + math.abs(data.left[i] - data.right[i])
	end

	return res
end

function part2(data)
	local res = 0

	for _, num in ipairs(data.left) do
		local occ = 0
		for _, num2 in ipairs(data.right) do
			if num == num2 then
				occ = occ + 1
			end
		end
		res = res + num * occ
	end

	return res
end


local data = parse_data(FILENAME_INPUT)
print("part 1:", part1(data))
print("part 2:", part2(data))

