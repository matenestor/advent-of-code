local inspect = require("inspect")


FILENAME_INPUT = "inputs/input5.txt"
--FILENAME_INPUT = "inputs/sample5.txt"

function pprint(object)
	print(inspect(object))
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
	for e in iter(array) do
		if e == element then
			return true
		end
	end
	return false
end

function parse_data(filename)
	local f = io.open(filename, "r")

	local page_ordering_rules = {}
	local pages_to_produce = {}

	-- parse xx|yy
	for line in f:lines() do
		if line == "" then break end
		local n1, n2 = line:match("(%d+)|(%d+)")
		table.insert(page_ordering_rules, {tonumber(n1), tonumber(n2)})
	end

	-- parse xx,yy,..zz
	local i = 1
	for line in f:lines() do
		table.insert(pages_to_produce, {})

		for n in line:gmatch("%d+") do
			table.insert(pages_to_produce[i], tonumber(n))
		end
		i = i + 1
	end

	f:close()
	return page_ordering_rules, pages_to_produce
end

function create_rules_map(page_ordering_rules)
	local rules_map = {}

	for n1, n2 in iter_duos(page_ordering_rules) do
		if rules_map[n1] == nil then
			rules_map[n1] = {}
		end
		table.insert(rules_map[n1], n2)

		-- The last element in the ordering rules never occurs as 'n1'
		-- (at least in the sample), so add it to the map with an empty table
		if rules_map[n2] == nil then
			rules_map[n2] = {}
		end
	end

	return rules_map
end

function is_page_in_order(page_ordering_rules, pages)
	for i = 1, #pages-1 do
		if not contains(page_ordering_rules[pages[i]], pages[i+1]) then
			-- page is not in correct order
			return false
		end
	end
	return true
end

function part1(page_ordering_rules, pages_to_produce)
	local res = 0

	for pages in iter(pages_to_produce) do
		if is_page_in_order(page_ordering_rules, pages) then
			res = res + pages[#pages // 2 + 1]
		end
	end

	return res
end

function correct_pages(page_ordering_rules, pages)
	local corrected_pages = {}

	pprint{page_ordering_rules, pages}

	return corrected_pages
end

function part2(page_ordering_rules, pages_to_produce)
	local res = 0

	for pages in iter(pages_to_produce) do
		if not is_page_in_order(page_ordering_rules, pages) then
			local corrected_pages = correct_pages(page_ordering_rules, pages)
			res = res + corrected_pages[#corrected_pages // 2 + 1]
		end
	end

	return res
end


local page_ordering_rules, pages_to_produce = parse_data(FILENAME_INPUT)
page_ordering_rules = create_rules_map(page_ordering_rules)

print("part 1 (143):", part1(page_ordering_rules, pages_to_produce))
--print("part 2 (123):", part2(page_ordering_rules, pages_to_produce))

