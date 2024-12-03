FILENAME_INPUT = "inputs/input3.txt"
--FILENAME_INPUT = "inputs/sample3a.txt"
--FILENAME_INPUT = "inputs/sample3b.txt"


function parse_data(filename)
	local f = io.open(filename, "r")
	local raw_data = f:read("*all")
	f:close()

	return raw_data
end

function part1(data)
	local res = 0
	local n1, n2

	for match in data:gmatch("mul%(%d+,%d+%)") do
		n1, n2 = match:match("(%d+),(%d+)")
		res = res + n1 * n2
	end

	return res
end

function part2(data)
	local res = 0

	-- Brackets are escaped with a percentage %
	-- The whole string is a pattern, but only the text enclosed in unescaped
	-- brackets will be captured. So this pattern will return two numbers
	-- without the "mul"
	local MATCH_MUL = "mul%((%d+),(%d+)%)"
	local MATCH_DO = "do%(%)"
	local MATCH_DONT = "don't%(%)"
	local enable_mul = true
	local tokens = {}

	-- Lua doesn't support selective matching (like OR operation in regexes)
	-- The brackets () in the match pattern makes the gmatch call yield an index
	-- of where the match occurs
	for pos in data:gmatch("()" .. MATCH_DO)   do tokens[pos] = MATCH_DO end
	for pos in data:gmatch("()" .. MATCH_DONT) do tokens[pos] = MATCH_DONT end
	for pos in data:gmatch("()" .. MATCH_MUL)  do tokens[pos] = MATCH_MUL end

	-- Lua doesn't keep iterate keys in a table in order, so extract the keys
	-- and sort them, so they can be used to ordered iteration
	local sorted_keys = {}
	for idx, _ in pairs(tokens) do
		table.insert(sorted_keys, idx)
	end
	table.sort(sorted_keys)

	for _, key in pairs(sorted_keys) do
		local idx, tok = key, tokens[key]

		if tok == MATCH_DO then
			enable_mul = true
		elseif tok == MATCH_DONT then
			enable_mul = false
		else
			if enable_mul then
				local n1, n2 = data:sub(idx):match(MATCH_MUL)
				res = res + n1 * n2
			end
		end
	end

	return res
end


local data = parse_data(FILENAME_INPUT)
print("part 1:", part1(data))
print("part 2:", part2(data))

