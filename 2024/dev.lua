require("utils")


local vec_mt = {
	__add = function(left, right)
		return setmetatable(
			Vec2:new(left.x + right.x, left.y + right.y),
			vec_mt
		)
	end, 
	__sub = function(left, right)
		return setmetatable(
			Vec2:new(left.x - right.x, left.y - right.y),
			vec_mt
		)
	end,
	__call = function(x, y)
		print("__call")
		return Vec2:new(x, y)
	end
}


------------------------------------------------

-- https://www.lua.org/pil/16.1.html

-- default attribute values
Account = { balance = 0 }

function Account:new(o)
	o = o or {}   -- create object if user does not provide one
	self.__index = self
	return setmetatable(o, self)
end

function Account:deposit(amount)
	self.balance = self.balance + amount
end

function Account:withdraw(amount)
	self.balance = self.balance - amount
end

-- SpecialAccount inherits from Account
SpecialAccount = Account:new()

function SpecialAccount:withdraw(amount)
	if amount - self.balance >= self:getLimit() then
		error"insufficient funds"
	end
	self.balance = self.balance - amount
end

function SpecialAccount:getLimit()
	return self.limit or 0
end

a = Account:new{balance = 0}
s = SpecialAccount:new{limit=1000.00}

a:deposit(100.00)
s:deposit(100.00)
--s:withdraw(2000.00)


Vec2 = setmetatable({ x = 1, y = 2 }, {__tostring = function() return "Vec2" end})
function Vec2:new(o)
	s = string.format("Missing init object: %s {x, y}", self)
	o = o or error(s)
	self.__index = self
	return setmetatable(o, self)
end

function Vec2:rotate()
	self.x, self.y = -1 * self.y, self.x
end

local v = Vec2:new{y=3}

pprint{v}
v:rotate()
pprint{v}

