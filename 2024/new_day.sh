#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo -e "Day number required!\nUsage: ./new_day.sh <day-number> [sample-result]"
	exit 1
fi

DAY="$1"

touch "inputs/sample$DAY.txt"
echo  "inputs/sample$DAY.txt"
touch "inputs/input$DAY.txt"
echo  "inputs/input$DAY.txt"


if [ -z "$2" ]; then
	SAMPLE_RESULT=""
else
	SAMPLE_RESULT="$2"
fi

TEMPLATE="require (\"utils\")

--FILENAME_INPUT = \"inputs/input$DAY.txt\"
FILENAME_INPUT = \"inputs/sample$DAY.txt\"


function parse_data(filename)
	--local f = io.open(filename, "r")
	local data = {}

	local i = 1
	for line in io.lines(filename) do
		data[i] = {}
		for num in line:gmatch(\"%d+\") do
			table.insert(data[i], tonumber(num))
		end
		i = i + 1
	end

	--f:close()
	return data
end

function part1(data)
	local res = 0

	return res
end

function part2(data)
	local res = 0

	return res
end


local data = parse_data(FILENAME_INPUT)
print(\"part 1 ($SAMPLE_RESULT):\", part1(data))
--print(\"part 2 ():\", part2(data))
"
echo "$TEMPLATE" > "day$DAY.lua"
echo "day$DAY.lua"

