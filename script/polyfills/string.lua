--[[
    Homebr3w

	A Homebrew Application to download other Homebrew
	Apps based on TitleDB.com's database

    Copyright (c) Wolvan

    All rights reserved. Licensed under the MIT license.
    See LICENSE in the project root for license information.

    Source available at https://github.com/Wolvan/Homebr3w
]]--

--[[
	String manipulation functions
	split() takes a string and returns a table of substrings
	split at the separator.
	startsWith() returns true if the string starts with
	a given string.
]]--
function string.split(self, sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end
function string.startsWith(String, Start)
	return string.sub(String,1,string.len(Start))==Start
end
