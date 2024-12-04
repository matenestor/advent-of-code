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

-- part 1 neighbours 
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

function parse_xmas(data, i, j)
	local top_left  = data[i-1][j-1]
	local top_right = data[i-1][j+1]
	local btm_left  = data[i+1][j-1]
	local btm_right = data[i+1][j+1]

	-- basically explicitly written:
	-- local chars = { top_left, top_right, btm_left, btm_right }
	-- chars.M == 2 and chars.S == 2 and chars[1] ~= chars[4]
	-- (chars[1] ~= chars[4] checks that Ms or Ss are not on the same diagonal)

	local ms_diagonal_1 = (top_left  == "M" and btm_right == "S") or (top_left  == "S" and btm_right == "M")
	local ms_diagonal_2 = (top_right == "M" and btm_left  == "S") or (top_right == "S" and btm_left  == "M")	

	return ms_diagonal_1 and ms_diagonal_2
end

function part2(data)
	local res = 0

	for i = 2, #data-1 do
		for j = 2, #data[i]-1 do
			if data[i][j] == "A" and parse_xmas(data, i, j) then
				res = res + 1
			end
		end
	end

	return res
end


local data = parse_data(FILENAME_INPUT)
print("part 1 (18):", part1(data))
print("part 2 (9):", part2(data))

