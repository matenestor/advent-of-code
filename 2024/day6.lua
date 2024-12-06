require("utils")


FILENAME_INPUT = "inputs/input6.txt"
--FILENAME_INPUT = "inputs/sample6.txt"


function parse_data(filename)
	local data = {}
	local start_pos = {}

	local i = 1
	for line in io.lines(filename) do
		data[i] = {}

		local j = 1
		for char in line:gmatch(".") do
			if char == "." then
				table.insert(data[i], 0)
			elseif char == "#" then
				table.insert(data[i], -1)
			else
				-- starting position already visited and can be accessed again
				table.insert(data[i], 1)
				start_pos = Vec2:new(j, i)
			end
			j = j + 1
		end
		i = i + 1
	end

	return data, start_pos
end

-- This is over-engineered, but I want to try OOP in Lua

Vec2 = {
	__add = function(left, right)
		return Vec2:new(left.x + right.x, left.y + right.y)
	end,
	__tostring = function(self)
		return string.format("y = %d, x = %d", self.y, self.x)
	end
}
function Vec2:new(x, y)
	local o = {x = x, y = y}
	self.__index = self
	return setmetatable(o, self)
end

function Vec2:rotate_right() self.x, self.y = -1 * self.y, self.x end
--function Vec2:rotate_left()  self.x, self.y = self.y, -1 * self.x end

function inside_grid(grid, pos)
	return 1 <= pos.x and pos.x <= #grid[1] and 1 <= pos.y and pos.y <= #grid
end

function can_move_to(grid, new_pos)
	return grid[new_pos.y][new_pos.x] >= 0
end

function part1(grid, pos)
	local res = 0
	local dir = Vec2:new(0, -1)  -- up

	local new_pos = pos + dir
	while inside_grid(grid, new_pos) do
		if can_move_to(grid, new_pos) then
			pos = new_pos
			-- how many times was this field visited
			grid[pos.y][pos.x] = grid[pos.y][pos.x] + 1
		else
			dir:rotate_right()
		end

		new_pos = pos + dir
	end

	-- count the amount of visited fields (NOTE: not how many times visited)
	for row in iter(grid) do
		for field in iter(row) do
			if field > 0 then
				res = res + 1
			end
		end
	end

	return res
end

function part2(data)
	local res = 0

	return res
end


local data, pos = parse_data(FILENAME_INPUT)
print("part 1 (41):", part1(data, pos))
--print("part 2 ():", part2(data))

