local inspect = require("inspect")


function pprint(object)
	print(inspect(object))
end

function copy(array)
	local new_array = {}
	for _, n in ipairs(array) do
		table.insert(new_array, n)
	end
	return new_array
end

function iter(array)
	-- needs to start at 0, because it is
	-- incremented once before the first use
	local index = 0
	return function()
		while index < #array do
			index = index + 1
 			return array[index]
		end
	end
end

function iter_duos(array)
	local index = 1
	return function()
		while index < #array do
			index = index + 1
			local e1, e2 = table.unpack(array[index])
 			return e1, e2
		end
	end
end

function contains(array, element)
	for _, e in ipairs(array) do
		if e == element then
			return true
		end
	end
	return false
end

function remove(array, element)
	local new_array = {}
	for _, e in ipairs(array) do
		-- NOTE this will drop every element; there are no duplicates in this problem, so whatever
		if e ~= element then
			table.insert(new_array, e)
		end
	end
	return new_array
end
