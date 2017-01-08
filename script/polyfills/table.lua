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
	Table manipulation functions
	deepcopy() is a  way to copy tables without
	linking them through references.
	countTableElements() returns the actual number
	if elements a table contains instead of only
	the highest number index like # does.
	table.filter is a Lua implementation of JS'
	Array.filter() function.
	table.dump is a debugging tool that allows
	dumping contents of a table to file for later
	inspection quickly.
]]--


--[[
    Copy table and break references of it to the old values
    Gives an identical copy of the table back that can be
    modified without the original table contents to be affected
]]
local function deepcopy(orig)
	local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
table.deepcopy = deepcopy

--[[
    Compared to using #, this function returns the actual
    amount of elements in the table instead of just the
    highest numerical index
]]--
function table.countElements(tbl)
	local i = 0
	for k,v in pairs(tbl) do
		i = i + 1
	end
	return i
end

--[[
    An implementation of JS' Array.filter() in Lua.
    Returns a table that is filtered by whatever function
    has been passed as filterIter
]]--
table.filter = function(workingTable, filterIter)
	local out = {}
	for index, value in pairs(workingTable) do
		if filterIter(value, index, workingTable) then out[index] = value end
	end
	return out
end

--[[
    A debugging tool that quickly dumps the contents of a table to
    the SD Card for further inspection later on.

    Warning: This requires dkjson to already be loaded to work!
]]--
table.dump = function(tbl, filename)
	if not filename then filename = "tbl_dump.json" end
	local jsonString = libraries["dkjson"].encode(tbl, { indent = true })
	System.deleteFile(filename)
	local file = io.open("/"..filename, FCREATE)
	io.write(file, 0, jsonString, jsonString:len())
	io.close(file)
end
