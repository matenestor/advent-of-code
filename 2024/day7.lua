require("utils")


FILENAME_INPUT = "inputs/input7.txt"
--FILENAME_INPUT = "inputs/sample7.txt"


function parse_data(filename)
	local data = {}

	local i = 1
	for line in io.lines(filename) do
		data[i] = {}
		for num in line:gmatch("%d+") do
			table.insert(data[i], tonumber(num))
		end
		i = i + 1
	end

	return data
end

function add(a, b) return a + b end
function mul(a, b) return a * b end

function behead(array)
	local head, tail = array[1], {}
	for i = 2, #array do
		table.insert(tail, array[i])
	end
	return head, tail
end

function apply_operators(total, nums, ops)
	local op = ops[1]
	local total = op(nums[1], nums[2])
	local nums_i, ops_i = 3, 2

	while nums_i <= #nums do
		op = ops[ops_i]
		total = op(total, nums[nums_i])

		nums_i = nums_i + 1
		ops_i = ops_i + 1
	end

	return total
end

function operators_exist(total, nums)
	-- nums    n_ops=bits    max_perm
	-- 3 ->    2       11    = 3
	-- 4 ->    3      111    = 7
	-- 5 ->    4     1111    = 15
	-- 6 ->    5    11111    = 31

	local n_ops = #nums - 1
	local perm, max_perm = 0, math.floor(2^n_ops) - 1

	while perm <= max_perm do
		local ops = {}
		local o, p = n_ops, perm

		-- go through bits of the 'perm' number where
		-- 1 represents 'mul' and 0 represents 'add'
		-- (creating product({add, mul}, repeat=n_ops)
		while o > 0 do
			if p & 1 == 1 then
				table.insert(ops, mul)
			else
				table.insert(ops, add)
			end
			-- another operator
			p = p >> 1
			o = o - 1
		end

		-- operators found
		if total == apply_operators(total, nums, ops) then
			return true
		end

		-- another permutation
		perm = perm + 1
	end

	return false
end

function part1(data)
	local res = 0

	for calibration in iter(data) do
		local total, nums = behead(calibration)
		if operators_exist(total, nums) then
			res = res + total
		end
	end

	return res
end

function part2(data)
	local res = 0

	return res
end


local data = parse_data(FILENAME_INPUT)
print("part 1 (3749):", part1(data))
--print("part 2 (11387):", part2(data))

