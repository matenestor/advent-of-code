local inspect = require("inspect")


FILENAME_INPUT = "inputs/input4.txt"
--FILENAME_INPUT = "inputs/sample4.txt"


function parse_data(filename)
	local f = io.open(filename, "r")
	local raw_data = f:read("*all")
	f:close()

	local data = {}
	local i = 1
	for line in raw_data:gmatch("[^\n\r]+") do
		table.insert(data, {})
		for char in line:gmatch(".") do
			table.insert(data[i], char)
		end
		i = i + 1  -- is there a way to get index from some iterator?
	end

	return data
end

-- neighbours 
local nbs = {
	{-1, -1}, {-1, 0}, {-1, 1},
	{ 0, -1},          { 0, 1},
	{ 1, -1}, { 1, 0}, { 1, 1},
}

function is_within_bounds(i, j, max_i, max_j)
	return 0 < i and i <= max_i and 0 < j and j <= max_j
end

function parse_word(word, data, i, j, nb_pos)
	local ni, nj = table.unpack(nb_pos)

	if not is_within_bounds(i + word:len()*ni, j + word:len()*nj, #data, #data[1]) then
		return false
	end

	for w = 1, word:len() do
		local char_from_input = data[i + w*ni][j + w*nj]
		local char_to_parse = word:sub(w, w)

		if char_from_input ~= char_to_parse then
			return false
		end
	end

	return true
end

function parse_all_words(word, data, i, j)
	local parsed_count = 0

	for _, nb_pos in ipairs(nbs) do
		-- try to parse given word in current neighbour's direction
		if parse_word(word, data, i, j, nb_pos) then
			parsed_count = parsed_count + 1
		end
	end

	return parsed_count
end

function part1(data)
	local res = 0

	for i = 1, #data do
		for j = 1, #data[i] do
			if data[i][j] == "X" then
				res = res + parse_all_words("MAS", data, i, j)
			end
		end
	end

	return res
end

function part2(data)
	local res = 0

	return res
end


local data = parse_data(FILENAME_INPUT)
print("part 1 (18):", part1(data))
--print("part 2 ():", part2(data))

