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
    Code to modify certain behavior of integrated Lua functions
    for example to extend their capabilities
]]--

--Define type to also be able to return a type from a given meta table, if defined
local oldType = type
function type(obj)
    if getmetatable(obj) then
        return oldType(obj), getmetatable(obj).__type
    else
        return oldType(obj)
    end
end