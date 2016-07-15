--[[
	Homebr3w
	
	A Homebrew Application to download other Homebrew
	Apps based on TitleDB.com's database
	
	Homebr3w is licensed under GPL 3.0, the full license
	can be found in the root of this repository inside of
	the LICENSE or LICENSE.md file.
	
	Copyright (C) 2016 https://github.com/Wolvan
]]--


-- START OF PROGRAM

-- BEGIN UTILITY CODE DECLARATION
--[[
	Define some constants for easier usage
	later on
]]--
local WHITE = Color.new(255,255,255)
local YELLOW = Color.new(255,205,66)
local RED = Color.new(255,0,0)
local GREEN = Color.new(55,255,0)

local APP_VERSION = "1.0.0"
local APP_DIR = "/Homebr3w"
local APP_CACHE = APP_DIR.."/Cache"
local APP_CONFIG = APP_DIR.."/config.json"
local APP_CIA_DIR = APP_DIR.."/CIAs"

local API_URL = "https://api.titledb.com/"

--[[
	Libraries that I use get defined here
	Unfortunately I can not simply load them
	with require or dofile since those do not
	read from romfs
]]--
--dkjson by David Kolf, http://dkolf.de/src/dkjson-lua.fsl/ for full source
function jsonfunction()
	local a=true;local b=false;local c='json'local pairs,type,tostring,tonumber,getmetatable,setmetatable,rawset=pairs,type,tostring,tonumber,getmetatable,setmetatable,rawset;local error,require,pcall,select=error,require,pcall,select;local d,e=math.floor,math.huge;local f,g,h,i,j,k,l,m=string.rep,string.gsub,string.sub,string.byte,string.char,string.find,string.len,string.format;local n=string.match;local o=table.concat;local p={version="dkjson 2.5"}if b then _G[c]=p end;local q=nil;pcall(function()local r=require"debug".getmetatable;if r then getmetatable=r end end)p.null=setmetatable({},{__tojson=function()return"null"end})local function s(t)local u,v,w=0,0,0;for x,y in pairs(t)do if x=='n'and type(y)=='number'then w=y;if y>u then u=y end else if type(x)~='number'or x<1 or d(x)~=x then return false end;if x>u then u=x end;v=v+1 end end;if u>10 and u>w and u>v*2 then return false end;return true,u end;local z={["\""]="\\\"",["\\"]="\\\\",["\b"]="\\b",["\f"]="\\f",["\n"]="\\n",["\r"]="\\r",["\t"]="\\t"}local function A(B)local C=z[B]if C then return C end;local D,E,F,G=i(B,1,4)D,E,F,G=D or 0,E or 0,F or 0,G or 0;if D<=0x7f then C=D elseif 0xc0<=D and D<=0xdf and E>=0x80 then C=(D-0xc0)*0x40+E-0x80 elseif 0xe0<=D and D<=0xef and E>=0x80 and F>=0x80 then C=((D-0xe0)*0x40+E-0x80)*0x40+F-0x80 elseif 0xf0<=D and D<=0xf7 and E>=0x80 and F>=0x80 and G>=0x80 then C=(((D-0xf0)*0x40+E-0x80)*0x40+F-0x80)*0x40+G-0x80 else return""end;if C<=0xffff then return m("\\u%.4x",C)elseif C<=0x10ffff then C=C-0x10000;local H,I=0xD800+d(C/0x400),0xDC00+C%0x400;return m("\\u%.4x\\u%.4x",H,I)else return""end end;local function J(K,L,M)if k(K,L)then return g(K,L,M)else return K end end;local function N(C)C=J(C,"[%z\1-\31\"\\\127]",A)if k(C,"[\194\216\220\225\226\239]")then C=J(C,"\194[\128-\159\173]",A)C=J(C,"\216[\128-\132]",A)C=J(C,"\220\143",A)C=J(C,"\225\158[\180\181]",A)C=J(C,"\226\128[\140-\143\168-\175]",A)C=J(C,"\226\129[\160-\175]",A)C=J(C,"\239\187\191",A)C=J(C,"\239\191[\176-\191]",A)end;return"\""..C.."\""end;p.quotestring=N;local function O(K,P,v)local Q,R=k(K,P,1,true)if Q then return h(K,1,Q-1)..v..h(K,R+1,-1)else return K end end;local S,T;local function U()S=n(tostring(0.5),"([^05+])")T="[^0-9%-%+eE"..g(S,"[%^%$%(%)%%%.%[%]%*%+%-%?]","%%%0").."]+"end;U()local function V(W)return O(J(tostring(W),T,""),S,".")end;local function X(K)local W=tonumber(O(K,".",S))if not W then U()W=tonumber(O(K,".",S))end;return W end;local function Y(Z,_,a0)_[a0+1]="\n"_[a0+2]=f("  ",Z)a0=a0+2;return a0 end;function p.addnewline(a1)if a1.indent then a1.bufferlen=Y(a1.level or 0,a1.buffer,a1.bufferlen or#a1.buffer)end end;local a2;local function a3(a4,C,a5,a6,Z,_,a0,a7,a8,a1)local a9=type(a4)if a9~='string'and a9~='number'then return nil,"type '"..a9 .."' is not supported as a key by JSON."end;if a5 then a0=a0+1;_[a0]=","end;if a6 then a0=Y(Z,_,a0)end;_[a0+1]=N(a4)_[a0+2]=":"return a2(C,a6,Z,_,a0+2,a7,a8,a1)end;local function aa(ab,_,a1)local a0=a1.bufferlen;if type(ab)=='string'then a0=a0+1;_[a0]=ab end;return a0 end;local function ac(ad,C,a1,_,a0,ae)ae=ae or ad;local af=a1.exception;if not af then return nil,ae else a1.bufferlen=a0;local ag,ah=af(ad,C,a1,ae)if not ag then return nil,ah or ae end;return aa(ag,_,a1)end end;function p.encodeexception(ad,C,a1,ae)return N("<"..ae..">")end;a2=function(C,a6,Z,_,a0,a7,a8,a1)local ai=type(C)local aj=getmetatable(C)aj=type(aj)=='table'and aj;local ak=aj and aj.__tojson;if ak then if a7[C]then return ac('reference cycle',C,a1,_,a0)end;a7[C]=true;a1.bufferlen=a0;local ag,ah=ak(C,a1)if not ag then return ac('custom encoder failed',C,a1,_,a0,ah)end;a7[C]=nil;a0=aa(ag,_,a1)elseif C==nil then a0=a0+1;_[a0]="null"elseif ai=='number'then local al;if C~=C or C>=e or-C>=e then al="null"else al=V(C)end;a0=a0+1;_[a0]=al elseif ai=='boolean'then a0=a0+1;_[a0]=C and"true"or"false"elseif ai=='string'then a0=a0+1;_[a0]=N(C)elseif ai=='table'then if a7[C]then return ac('reference cycle',C,a1,_,a0)end;a7[C]=true;Z=Z+1;local am,v=s(C)if v==0 and aj and aj.__jsontype=='object'then am=false end;local ah;if am then a0=a0+1;_[a0]="["for Q=1,v do a0,ah=a2(C[Q],a6,Z,_,a0,a7,a8,a1)if not a0 then return nil,ah end;if Q<v then a0=a0+1;_[a0]=","end end;a0=a0+1;_[a0]="]"else local a5=false;a0=a0+1;_[a0]="{"local an=aj and aj.__jsonorder or a8;if an then local ao={}v=#an;for Q=1,v do local x=an[Q]local y=C[x]if y then ao[x]=true;a0,ah=a3(x,y,a5,a6,Z,_,a0,a7,a8,a1)a5=true end end;for x,y in pairs(C)do if not ao[x]then a0,ah=a3(x,y,a5,a6,Z,_,a0,a7,a8,a1)if not a0 then return nil,ah end;a5=true end end else for x,y in pairs(C)do a0,ah=a3(x,y,a5,a6,Z,_,a0,a7,a8,a1)if not a0 then return nil,ah end;a5=true end end;if a6 then a0=Y(Z-1,_,a0)end;a0=a0+1;_[a0]="}"end;a7[C]=nil else return ac('unsupported type',C,a1,_,a0,"type '"..ai.."' is not supported by JSON.")end;return a0 end;function p.encode(C,a1)a1=a1 or{}local ap=a1.buffer;local _=ap or{}a1.buffer=_;U()local ag,ah=a2(C,a1.indent,a1.level or 0,_,a1.bufferlen or 0,a1.tables or{},a1.keyorder,a1)if not ag then error(ah,2)elseif ap==_ then a1.bufferlen=ag;return true else a1.bufferlen=nil;a1.buffer=nil;return o(_)end end;local function aq(K,ar)local as,at,au=1,1,0;while true do at=k(K,"\n",at,true)if at and at<ar then as=as+1;au=at;at=at+1 else break end end;return"line "..as..", column "..ar-au end;local function av(K,aw,ar)return nil,l(K)+1,"unterminated "..aw.." at "..aq(K,ar)end;local function ax(K,at)while true do at=k(K,"%S",at)if not at then return nil end;local ay=h(K,at,at+1)if ay=="\239\187"and h(K,at+2,at+2)=="\191"then at=at+3 elseif ay=="//"then at=k(K,"[\n\r]",at+2)if not at then return nil end elseif ay=="/*"then at=k(K,"*/",at+2)if not at then return nil end;at=at+2 else return at end end end;local az={["\""]="\"",["\\"]="\\",["/"]="/",["b"]="\b",["f"]="\f",["n"]="\n",["r"]="\r",["t"]="\t"}local function aA(C)if C<0 then return nil elseif C<=0x007f then return j(C)elseif C<=0x07ff then return j(0xc0+d(C/0x40),0x80+d(C)%0x40)elseif C<=0xffff then return j(0xe0+d(C/0x1000),0x80+d(C/0x40)%0x40,0x80+d(C)%0x40)elseif C<=0x10ffff then return j(0xf0+d(C/0x40000),0x80+d(C/0x1000)%0x40,0x80+d(C/0x40)%0x40,0x80+d(C)%0x40)else return nil end end;local function aB(K,at)local aC=at+1;local _,v={},0;while true do local aD=k(K,"[\"\\]",aC)if not aD then return av(K,"string",at)end;if aD>aC then v=v+1;_[v]=h(K,aC,aD-1)end;if h(K,aD,aD)=="\""then aC=aD+1;break else local aE=h(K,aD+1,aD+1)local C;if aE=="u"then C=tonumber(h(K,aD+2,aD+5),16)if C then local aF;if 0xD800<=C and C<=0xDBff then if h(K,aD+6,aD+7)=="\\u"then aF=tonumber(h(K,aD+8,aD+11),16)if aF and 0xDC00<=aF and aF<=0xDFFF then C=(C-0xD800)*0x400+aF-0xDC00+0x10000 else aF=nil end end end;C=C and aA(C)if C then if aF then aC=aD+12 else aC=aD+6 end end end end;if not C then C=az[aE]or aE;aC=aD+2 end;v=v+1;_[v]=C end end;if v==1 then return _[1],aC elseif v>1 then return o(_),aC else return"",aC end end;local aG;local function aH(aw,aI,K,aJ,aK,aL,aM)local aN=l(K)local t,v={},0;local at=aJ+1;if aw=='object'then setmetatable(t,aL)else setmetatable(t,aM)end;while true do at=ax(K,at)if not at then return av(K,aw,aJ)end;local aO=h(K,at,at)if aO==aI then return t,at+1 end;local aP,aQ;aP,at,aQ=aG(K,at,aK,aL,aM)if aQ then return nil,at,aQ end;at=ax(K,at)if not at then return av(K,aw,aJ)end;aO=h(K,at,at)if aO==":"then if aP==nil then return nil,at,"cannot use nil as table index (at "..aq(K,at)..")"end;at=ax(K,at+1)if not at then return av(K,aw,aJ)end;local aR;aR,at,aQ=aG(K,at,aK,aL,aM)if aQ then return nil,at,aQ end;t[aP]=aR;at=ax(K,at)if not at then return av(K,aw,aJ)end;aO=h(K,at,at)else v=v+1;t[v]=aP end;if aO==","then at=at+1 end end end;aG=function(K,at,aK,aL,aM)at=at or 1;at=ax(K,at)if not at then return nil,l(K)+1,"no valid JSON value (reached the end)"end;local aO=h(K,at,at)if aO=="{"then return aH('object',"}",K,at,aK,aL,aM)elseif aO=="["then return aH('array',"]",K,at,aK,aL,aM)elseif aO=="\""then return aB(K,at)else local aS,aT=k(K,"^%-?[%d%.]+[eE]?[%+%-]?%d*",at)if aS then local aU=X(h(K,aS,aT))if aU then return aU,aT+1 end end;aS,aT=k(K,"^%a%w*",at)if aS then local aV=h(K,aS,aT)if aV=="true"then return true,aT+1 elseif aV=="false"then return false,aT+1 elseif aV=="null"then return aK,aT+1 end end;return nil,at,"no valid JSON value at "..aq(K,at)end end;local function aW(...)if select("#",...)>0 then return...else return{__jsontype='object'},{__jsontype='array'}end end;function p.decode(K,at,aK,...)local aL,aM=aW(...)return aG(K,at,aK,aL,aM)end;function p.use_lpeg()local aX=require("lpeg")if aX.version()=="0.11"then error"due to a bug in LPeg 0.11, it cannot be used for JSON matching"end;local aY=aX.match;local aZ,a_,b0=aX.P,aX.S,aX.R;local function b1(K,at,ah,a1)if not a1.msg then a1.msg=ah.." at "..aq(K,at)a1.pos=at end;return false end;local function b2(ah)return aX.Cmt(aX.Cc(ah)*aX.Carg(2),b1)end;local b3=aZ"//"*(1-a_"\n\r")^0;local b4=aZ"/*"*(1-aZ"*/")^0*aZ"*/"local b5=(a_" \n\r\t"+aZ"\239\187\191"+b3+b4)^0;local b6=1-a_"\"\\\n\r"local b7=aZ"\\"*aX.C(a_"\"\\/bfnrt"+b2"unsupported escape sequence")/az;local b8=b0("09","af","AF")local function b9(ba,at,bb,bc)bb,bc=tonumber(bb,16),tonumber(bc,16)if 0xD800<=bb and bb<=0xDBff and 0xDC00<=bc and bc<=0xDFFF then return true,aA((bb-0xD800)*0x400+bc-0xDC00+0x10000)else return false end end;local function bd(be)return aA(tonumber(be,16))end;local bf=aZ"\\u"*aX.C(b8*b8*b8*b8)local bg=aX.Cmt(bf*bf,b9)+bf/bd;local bh=bg+b7+b6;local bi=aZ"\""*aX.Cs(bh^0)*(aZ"\""+b2"unterminated string")local bj=aZ"-"^-1*(aZ"0"+b0"19"*b0"09"^0)local bk=aZ"."*b0"09"^0;local bl=a_"eE"*a_"+-"^-1*b0"09"^1;local bm=bj*bk^-1*bl^-1/X;local bn=aZ"true"*aX.Cc(true)+aZ"false"*aX.Cc(false)+aZ"null"*aX.Carg(1)local bo=bm+bi+bn;local bp,bq;local function br(K,at,aK,a1)local bs,bt;local bu;local bv,bw={},0;repeat bs,bt,bu=aY(bp,K,at,aK,a1)if not bu then break end;at=bu;bw=bw+1;bv[bw]=bs until bt=='last'return at,setmetatable(bv,a1.arraymeta)end;local function bx(K,at,aK,a1)local bs,a4,bt;local bu;local bv={}repeat a4,bs,bt,bu=aY(bq,K,at,aK,a1)if not bu then break end;at=bu;bv[a4]=bs until bt=='last'return at,setmetatable(bv,a1.objectmeta)end;local by=aZ"["*aX.Cmt(aX.Carg(1)*aX.Carg(2),br)*b5*(aZ"]"+b2"']' expected")local bz=aZ"{"*aX.Cmt(aX.Carg(1)*aX.Carg(2),bx)*b5*(aZ"}"+b2"'}' expected")local bA=b5*(by+bz+bo)local bB=bA+b5*b2"value expected"bp=bA*b5*(aZ","*aX.Cc'cont'+aX.Cc'last')*aX.Cp()local bC=aX.Cg(b5*bi*b5*(aZ":"+b2"colon expected")*bB)bq=bC*b5*(aZ","*aX.Cc'cont'+aX.Cc'last')*aX.Cp()local bD=bB*aX.Cp()function p.decode(K,at,aK,...)local a1={}a1.objectmeta,a1.arraymeta=aW(...)local bs,bE=aY(bD,K,at,aK,a1)if a1.msg then return nil,a1.pos,a1.msg else return bs,bE end end;p.use_lpeg=function()return p end;p.using_lpeg=true;return p end;if a then pcall(p.use_lpeg)end;return p
end
local json = jsonfunction()

--[[
	Modes to sort the Applist
]]--
local sortModes = {
	{
		text = "ID (ascending)",
		sortFunction = function(a, b)
			return a.id < b.id
		end
	},
	{
		text = "ID (descending)",
		sortFunction = function(a, b)
			return a.id > b.id
		end
	},
	{
		text = "Alphabet (ascending)",
		sortFunction = function(a, b)
			local aName = a.name
			local bName = b.name
			aName = aName:sub(1,1):upper()..aName:sub(2)
			bName = bName:sub(1,1):upper()..bName:sub(2)
			return aName < bName
		end
	},
	{
		text = "Alphabet (descending)",
		sortFunction = function(a, b)
			local aName = a.name
			local bName = b.name
			aName = aName:sub(1,1):upper()..aName:sub(2)
			bName = bName:sub(1,1):upper()..bName:sub(2)
			return aName > bName
		end
	},
	{
		text = "Size (ascending)",
		sortFunction = function(a, b)
			return a.size < b.size
		end
	},
	{
		text = "Size (descending)",
		sortFunction = function(a, b)
			return a.size > b.size
		end
	}
}

--[[
	Define various variables for later
	use in the application
]]--
local config = {
	enableUpdateCheck = {
		text = "Enable Update Check",
		value = true
	},
	deleteCIAAfterInstall = {
		text = "Delete CIA after install",
		value = true
	},
	downloadRetryCount = {
		text = "Download Retries",
		value = 3,
		minValue = 1,
		maxValue = 10
	},
	defaultSortMode = {
		text = "Default sorting mode",
		value = 3,
		minValue = 1,
		maxValue = #sortModes
	}
}
local config_backup = {}

local parsedApplist = {}
local installed = {}
local blacklistedApps = {}

local homebr3wInfo = {}
local remVer = nil
local locVer = nil
local canUpdate = nil

local imageCache = {}

local selectedCIA = 1
local menuOffset = 0
local selection = 1
local screenHeightVar = 13
local menu_selection = 1
local options_selection = 1
local sortMode = 3

local home = "Homemenu"
if System.checkBuild() ~= 1 then
	home = "Homebrew Launcher"
end

local pad = Controls.read()
local oldpad = pad

--[[
	Poor Man's Breakpoint
	This function makes debugging a lot easier
	since this can be used as a makeshift
	breakpoint to halt execution anywhere in the
	Script
]]--
function STOP()
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			System.exit()
		end
		oldpad = pad
	end
end

--[[
	Function for different data types that Lua doesn't
	come with natively.
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
function deepcopy(orig)
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
function countTableElements(tbl)
	local i = 0
	for k,v in pairs(tbl) do
		i = i + 1
	end
	return i
end
table.filter = function(workingTable, filterIter)
	local out = {}
	for index, value in pairs(workingTable) do
		if filterIter(value, index, workingTable) then out[index] = value end
	end
	return out
end
table.dump = function(tbl, filename)
	if not filename then filename = "tbl_dump.json" end
	local jsonString = json.encode(tbl, { indent = true })
	local file = io.open("/"..filename, FCREATE)
	io.write(file, 0, jsonString, jsonString:len())
	io.close(file)
end

--[[
	Functions to save and load config from a config
	file. The config table gets encoded as JSON file
	and saved to the SD. 
	Loading reads that file (or creates it if it 
	doesn't exist before reading), decodes the JSON
	and then overwrites each value of the config
	table that is defined in the decoded JSON Object.
	This way, settings that are not stored in the config
	yet just use the default value set in the config table.
]]--
function saveConfig()
	local jsonString = json.encode(config, { indent = true })
	System.createDirectory(APP_DIR)
	local file = io.open(APP_CONFIG, FCREATE)
	io.write(file, 0, jsonString, jsonString:len())
	io.close(file)
end
function loadConfig()
	local configPath = APP_CONFIG
	if not System.doesFileExist(configPath) then
		saveConfig()
	end
	local file = io.open(configPath, FREAD)
	
	local filesize = 0
	filesize = tonumber(io.size(file))
	if filesize == 0 then
		io.close(file)
		saveConfig()
		file = io.open(configPath, FREAD)
	end
	
	local file_contents = io.read(file, 0, tonumber(io.size(file)))
	io.close(file)
	local loaded_config = json.decode(file_contents)
	if type(loaded_config) == "table" then
		for k,v in pairs(loaded_config) do
			config[k] = v
		end
	else
		return false
	end
	return true
end

--[[
	This function just presents an error to
	the user. Overriding the keypressFunction
	allows changing behavior of the error
]]--
function showError(errorMsg, keypressFunction)
	keypressFunction = keypressFunction or function()
		pad = Controls.read()
		if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			Screen.waitVblankStart()
			Screen.flip()
			main()
		end
		oldpad = pad
	end
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	Screen.waitVblankStart()
	Screen.flip()
	local splitString = errorMsg:split("\n")
	for k,v in pairs(splitString) do
		Screen.debugPrint(5, ((k-1)*15)+5, v, RED, TOP_SCREEN)
	end
	Screen.debugPrint(5, 95, "GitHub can be found at", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 110, "https://github.com/Wolvan", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 125, "/Homebr3w", WHITE, BOTTOM_SCREEN)
	while true do
		keypressFunction()
	end
end

--[[
	Functions to parse and compare SemVer compliant
	versions. parseVersion accepts and parses Strings
	in the format MAJOR.MINOR.PATCH and returns a table
	{major, minor, version} which can be used by
	isUpdateAvailable
]]--
function parseVersion(verString)
	if verString == nil or verString == "" then
		verString = "0.0.0"
	end
	
	verString = verString:gsub(" ", "")
	local version = {}
	local splitVersion = verString:split(".")
	if splitVersion[1]:lower():startsWith("v") then
		splitVersion[1] = splitVersion[1]:sub(2)
	end
	
	version.major = tonumber(splitVersion[1]) or 0
	version.minor = tonumber(splitVersion[2]) or 0
	version.patch = tonumber(splitVersion[3]) or 0
	
	return version
end
function isUpdateAvailable(localVersion, remoteVersion)
	if remoteVersion.major > localVersion.major then
		return true
	end
	if (remoteVersion.minor > localVersion.minor) and (remoteVersion.major >= localVersion.major) then
		return true
	end
	if (remoteVersion.patch > localVersion.patch) and (remoteVersion.major >= localVersion.major) and (remoteVersion.minor >= localVersion.minor) then
		return true
	end
	return false
end

--[[
	Check if the User has Wi-Fi disabled and an
	Internet connection is available
]]--
function checkWifi()
	if not Network.isWifiEnabled() then
		showError("Wi-Fi is disabled. Restart and try again.\nPress A to go back to "..home..".", function()
			pad = Controls.read()
			if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
				System.exit()
			end
			oldpad = pad
		end)
	end
end

--[[
	Check App State to close the App in case
	of exitting from home menu. 
	Function should be used in every while
	loop that allows going to Homemenu by
	pressing HOME!
]]--
function checkForExit()
	if System.checkStatus() == APP_EXITING then
		System.exit()
	end
end

--[[
	Function to download File from Internet
]]--
function getFile(path, downloadURL, method, data)
	if not method or (method ~= "GET" and method ~= "POST" and method ~= "HEAD") then method = "GET" end
	if not data then data = {} end
	System.deleteFile(path)
	Network.downloadFile(downloadURL, path, "User-Agent: Homebr3w/"..APP_VERSION, method, json.encode(data))
	local filesize = 0
	if System.doesFileExist(path) then
		local encTitleKeys = io.open(path, FREAD)
		filesize = tonumber(io.size(encTitleKeys))
		io.close(encTitleKeys)
	end
	if filesize == 0 then
		System.deleteFile(path)
		return false
	end
	return true
end
--[[
	Function that gets a json string from
	the web and decodes it into a table
]]--
function getJSON(url, method, data)
	if not method or (method ~= "GET" and method ~= "POST" and method ~= "HEAD") then method = "POST" end
	if not data then
		data = {
			action = "list",
			fields = { "id", "titleid", "author", "description", "name", "create_time", "update_time", "size", "mtime" }
		}
	end
	local tbl = {}
	local remoteData = Network.requestString(url, "User-Agent: Homebr3w/"..APP_VERSION, method, json.encode(data))
	if remoteData ~= "" and remoteData ~= nil and type(remoteData) == "string" then
		tbl = json.decode(remoteData)
	else
		return false, tbl
	end
	return true, tbl
end

--[[
	Get a title from the Applist by titleid
]]--
function getTitleByID(titleid)
	for k,v in pairs(parsedApplist) do
		if v.titleid == titleid then
			return v
		end
	end
end
-- END UTILITY CODE DECLARATION

-- BEGIN MAIN PROGRAM CODE
--[[
	Go through all of the icon files in the
	Cache directory and download icons that
	are missing.
]]--
function checkCache(tbl)
	local function cache(titleid)
		System.createDirectory(APP_CACHE)
		local path = APP_CACHE.."/"..titleid..".png"
		local downloadURL = API_URL.."images/"..titleid..".png"
		local success = getFile(path, downloadURL)
		local tries = 0
		while (tries < config.downloadRetryCount.value) and (not success) do
			success = getFile(path, downloadURL)
			tries = tries + 1
		end
		return success
	end
	local tid = "0004000000130800"
	local failed = 0
	for k,v in pairs(tbl) do
		Screen.clear(BOTTOM_SCREEN)
		tid = v.titleid
		Screen.debugPrint(5, 5, "Checking Icon "..k.." of "..#tbl.."...", WHITE, BOTTOM_SCREEN)
		if not System.doesFileExist(APP_CACHE.."/"..tid..".png") then
			Screen.debugPrint(5, 20, "Downloading "..tid, WHITE, BOTTOM_SCREEN)
			if not cache(tid) then failed = failed + 1 end
		end
		if failed > 0 then Screen.debugPrint(5, 35, "Failed downloading "..failed.." Icons", WHITE, BOTTOM_SCREEN) end
	end
	Screen.clear(BOTTOM_SCREEN)
end

--[[
	Return a subset of the applist that
	contains all titleIDs of apps that
	are installed on the 3ds in a lookup
	table kind of way
	isInstalled[TITLEID] = true or nil(false)
]]--
function checkInstalled()
	local sysapps = System.listCIA()
	local installed = table.filter(parsedApplist, function (item)
		local dectid = tonumber(item.titleid:gsub("0004000", ""), 16)
		for k,v in pairs(sysapps) do
			if dectid == v.unique_id then
				return true
			end
		end
		return false
	end)
	local tbl = {}
	for k,v in pairs(installed) do
		tbl[v.titleid] = true
	end
	return tbl
end

--[[
	Take a title ID, parse it into it's
	hexadecimal value and launch it from
	SD Card
]]--
function launchByTitleId(titleid)
	System.launchCIA(tonumber(titleid:gsub("0004000", ""), 16), SDMC)
end

--[[
	Clear the image cache that is being
	created in RAM for showing the icons
	on the details page
]]--
function clearImageCache()
	for k,v in pairs(imageCache) do
		Screen.freeImage(v)
		imageCache[k] = nil
	end
end

--[[
	Take a TitleID, download the corresponding
	.cia from TitleDB.com and then install it
	to SD
]]--
function downloadAndInstall(titleid)
	
	oldpad = pad
	Screen.waitVblankStart()
	Screen.refresh()
	Screen.clear(BOTTOM_SCREEN)
	Screen.clear(TOP_SCREEN)
	Screen.flip()
	System.createDirectory(APP_CIA_DIR)
	local title = getTitleByID(titleid)
	if title then
		Screen.debugPrint(5, 5, title.name, WHITE, TOP_SCREEN)
		local line = 20
		Screen.debugPrint(5, line, "Downloading...", WHITE, TOP_SCREEN)
		local path = APP_CIA_DIR.."/"..title.titleid.."_"..title.name..".cia"
		local downloadURL = API_URL.."v0/proxy/"..title.titleid
		local success = getFile(path, downloadURL)
		local tries = 0
		while (tries < config.downloadRetryCount.value) and (not success) do
			success = getFile(path, downloadURL)
			tries = tries + 1
		end
		
		if success then
			Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
			if System.checkBuild() == 1 then
				line = 35
				Screen.debugPrint(5, line, "Installing...", WHITE, TOP_SCREEN)
				System.installCIA(path, SDMC)
				if config.deleteCIAAfterInstall.value then System.deleteFile(path) end
				installed[titleid] = true
				Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
				
				Screen.debugPrint(5, 180, "Press A to launch the title", WHITE, BOTTOM_SCREEN)
			else
				Screen.debugPrint(5, 5, "Download finished! Unfortunately,", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 20, "the Ninjhax build of Homebr3w", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 35, "can not install the App", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 50, "automatically. Please use a", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 65, "titlemanager (like FBI) and ", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 80, "install the .cia manually, it's", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 95, "saved in the '/Homebr3w/CIAs'", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 110, "directory.", WHITE, BOTTOM_SCREEN)
			end
			
			Screen.debugPrint(5, 195, "Press B to go to title list", WHITE, BOTTOM_SCREEN)
			
			while true do
				pad = Controls.read()
				if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
					oldpad = pad
					if System.checkBuild() == 1 then launchByTitleId(parsedApplist[selectedCIA].titleid) end
				elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
					oldpad = pad
					main()
				end
				oldpad = pad
			end
		else
			Screen.debugPrint(270, line, "[FAILED]", RED, TOP_SCREEN)
			Screen.debugPrint(5, 195, "Press B to go to title list", WHITE, BOTTOM_SCREEN)
			
			while true do
				pad = Controls.read()
				if Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
					oldpad = pad
					main()
				end
				oldpad = pad
			end
			return false
		end
	end
	return false
end

function optionsMenu()
	oldpad = pad
	Screen.waitVblankStart()
	Screen.refresh()
	
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "Options", YELLOW, TOP_SCREEN)
	Screen.debugPrint(20, (options_selection * 15) + 5, ">", WHITE, TOP_SCREEN)
	local config_keys = {}
	local i = 1
	for k,v in pairs(config) do
		Screen.debugPrint(30, (i * 15) + 5, v.text, WHITE, TOP_SCREEN)
		if type(v.value) == "boolean" then
			if v.value then
				Screen.debugPrint(350, (i * 15) + 5, "On", GREEN, TOP_SCREEN)
			else
				Screen.debugPrint(350, (i * 15) + 5, "Off", RED, TOP_SCREEN)
			end
		elseif type(v.value) == "number" then
			Screen.debugPrint(350, (i * 15) + 5, v.value, YELLOW, TOP_SCREEN)
		end
		
		config_keys[#config_keys+1] = k
		i = i + 1
	end
	
	Screen.clear(BOTTOM_SCREEN)
	Screen.debugPrint(5, 110, "up/down - Select option", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 125, "left/right - Change setting", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 140, "A - Save", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 155, "B - Cancel", WHITE, BOTTOM_SCREEN)
	Screen.flip()
	
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_DDOWN) and not Controls.check(oldpad, KEY_DDOWN) then
			options_selection = options_selection + 1
			if (options_selection > #config_keys) then
				options_selection = 1
			end
		elseif Controls.check(pad, KEY_DUP) and not Controls.check(oldpad, KEY_DUP) then
			options_selection = options_selection - 1
			if (options_selection < 1) then
				options_selection = #config_keys
			end
		elseif Controls.check(pad, KEY_DLEFT) and not Controls.check(oldpad, KEY_DLEFT) then
			local currentSetting = config[config_keys[options_selection]]
			if type(currentSetting.value) == "boolean" then
				currentSetting.value = not currentSetting.value
			elseif type(currentSetting.value) == "number" then
				currentSetting.value = currentSetting.value - 1
				if currentSetting.minValue then
					if currentSetting.value < currentSetting.minValue then currentSetting.value = currentSetting.minValue end
				end
				config[config_keys[options_selection]].value = currentSetting.value
			end
		elseif Controls.check(pad, KEY_DRIGHT) and not Controls.check(oldpad, KEY_DRIGHT) then
			local currentSetting = config[config_keys[options_selection]]
			if type(currentSetting.value) == "boolean" then
				currentSetting.value = not currentSetting.value
			elseif type(currentSetting.value) == "number" then
				currentSetting.value = currentSetting.value + 1
				if currentSetting.maxValue then
					if currentSetting.value > currentSetting.maxValue then currentSetting.value = currentSetting.maxValue end
				end
				config[config_keys[options_selection]].value = currentSetting.value
			end
		elseif Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			oldpad = pad
			config_backup = deepcopy(config)
			saveConfig()
			menu()
		elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
			oldpad = pad
			config = deepcopy(config_backup)
			menu()
		end
		oldpad = pad
		optionsMenu()
	end
end

function menu()
	local menu_options = {
		{
			text = "Settings",
			callback = function() optionsMenu() end
		},
		{
			text = "Back to Applist",
			callback = function() main() end
		},
		{
			text = "Exit App",
			callback = System.exit
		}
	}
	local function printBottomScreen()
		Screen.clear(BOTTOM_SCREEN)
		if canUpdate then
			Screen.debugPrint(5, 220, "Update version "..remVer.major.."."..remVer.minor.."."..remVer.patch.." now available!", RED, TOP_SCREEN)
		end
		Screen.debugPrint(5, 50, "Thanks to the following people:", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 65, "ksanislo - For TitleDB.com", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 80, "yellows8 - For icon and banner", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 95, "Rinnegatamante - For LPP3DS", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 110, "3DSGuy - Banner Sound", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 125, "You - For using this tool at all", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 140, "AFgt - For testing this tool", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 155, "Nai - For testing this tool", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 205, "v"..APP_VERSION, WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 220, "Homebr3w by Wolvan", WHITE, BOTTOM_SCREEN)
	end
	local function printTopScreen()
		Screen.clear(TOP_SCREEN)
		Screen.debugPrint(5, 5, "Homebr3w v"..APP_VERSION, YELLOW, TOP_SCREEN)
		Screen.debugPrint(20, (menu_selection * 15) + 5, ">", WHITE, TOP_SCREEN)
		for k,v in pairs(menu_options) do
			Screen.debugPrint(30, (k * 15) + 5, v.text, WHITE, TOP_SCREEN)
		end
	end
	
	oldpad = pad
	Screen.refresh()
	Screen.waitVblankStart()
	printTopScreen()
	printBottomScreen()
	Screen.flip()
	
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_DDOWN) and not Controls.check(oldpad, KEY_DDOWN) then
			menu_selection = menu_selection + 1
			if (menu_selection > #menu_options) then
				menu_selection = 1
			end
		elseif Controls.check(pad, KEY_DUP) and not Controls.check(oldpad, KEY_DUP) then
			menu_selection = menu_selection - 1
			if (menu_selection < 1) then
				menu_selection = #menu_options
			end
		elseif Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			oldpad = pad
			menu_options[menu_selection].callback()
		elseif Controls.check(pad, KEY_HOME) and System.checkBuild() ~= 1 then
			System.exit()
		elseif Controls.check(pad, KEY_HOME) and System.checkBuild() == 1 then
			System.showHomeMenu()
		end
		checkForExit()
		oldpad = pad
		menu()
	end
end

--[[
	Print a title's info to the Bottom Screen
]]--
function printTitleInfo(titleid)
	Screen.clear(BOTTOM_SCREEN)
	local title = getTitleByID(titleid)
	if title then
		if not imageCache[title.titleid] and System.doesFileExist(APP_CACHE.."/"..titleid..".png") then
			imageCache[title.titleid] = Screen.loadImage(APP_CACHE.."/"..titleid..".png")
		end
		if imageCache[title.titleid] then Screen.drawImage(5, 5, imageCache[title.titleid], BOTTOM_SCREEN) end
		Screen.debugPrint(58, 5, title.name, WHITE, BOTTOM_SCREEN)
		if #title.author < 25 then
			Screen.debugPrint(58, 20, "by "..title.author, WHITE, BOTTOM_SCREEN)
		else
			Screen.debugPrint(58, 20, "by "..title.author:sub(1, 25), WHITE, BOTTOM_SCREEN)
			Screen.debugPrint(58, 35, title.author:sub(26), WHITE, BOTTOM_SCREEN)
		end
		
		if #title.description < 33 then
			Screen.debugPrint(5, 60, title.description, WHITE, BOTTOM_SCREEN)
		else
			Screen.debugPrint(5, 60, title.description:sub(1, 33), WHITE, BOTTOM_SCREEN)
			Screen.debugPrint(5, 75, title.description:sub(34), WHITE, BOTTOM_SCREEN)
		end
		
		Screen.debugPrint(5, 100, "TID: "..title.titleid, WHITE, BOTTOM_SCREEN)
		local lastUpdated = title.create_time
		if title.update_time then lastUpdated = title.update_time end
		Screen.debugPrint(5, 115, "Last update: "..lastUpdated, WHITE, BOTTOM_SCREEN)
		local size = title.size
		local unit = "B"
		if size >  1024 then -- Byte -> Kilobyte
			size = size / 1024
			unit = "KB"
		end
		if size > 1024 then -- Kilobyte -> Megabyte
			size = size / 1024
			unit = "MB"
		end
		if size > 1024 then -- Megabyte -> Gigabyte
			size = size / 1024
			unit = "GB"
		end
		Screen.debugPrint(5, 130, string.format("Size: %.2f%s", size, unit), WHITE, BOTTOM_SCREEN)
		if installed[title.titleid] then Screen.debugPrint(5, 145, "Installed! You can install this again.", GREEN, BOTTOM_SCREEN) end
		
		if System.checkBuild() == 1 and installed[title.titleid] then Screen.debugPrint(5, 160, "Press X to start app", GREEN, BOTTOM_SCREEN) end
		if System.checkBuild() ~= 1 then Screen.debugPrint(5, 195, "Press A to download", WHITE, BOTTOM_SCREEN)
		else Screen.debugPrint(5, 195, "Press A to download and install", WHITE, BOTTOM_SCREEN) end
		Screen.debugPrint(5, 210, "Press L/R to sort list", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 225, "Press Start to access menu", WHITE, BOTTOM_SCREEN)
	end
end

function printTitleList()
	Screen.clear(BOTTOM_SCREEN)
	local color = WHITE
	local title = {}
	for i = 1, screenHeightVar, 1 do
		title = parsedApplist[i + menuOffset]
		if title then
			color = WHITE
			if installed[title.titleid] then
				color = GREEN
			end
			if selection == i then
				color = YELLOW
			end
			Screen.debugPrint(15, (i * 15) + 5, title.name, color, TOP_SCREEN)
			Screen.debugPrint(5, (selection * 15) + 5, ">", YELLOW, TOP_SCREEN)
		end
	end
end

function printTopScreen()
	Screen.clear(TOP_SCREEN)
	if canUpdate then
		screenHeightVar = 12
	end
	Screen.debugPrint(5, 5, "Homebr3w v"..APP_VERSION.." - A homebrew browser", RED, TOP_SCREEN)
	printTitleList()
	if canUpdate then Screen.debugPrint(5, 205, "Update version "..remVer.major.."."..remVer.minor.."."..remVer.patch.." now available!", RED, TOP_SCREEN) end
	Screen.debugPrint(5, 220, "Sort mode "..sortMode..": "..sortModes[sortMode].text, RED, TOP_SCREEN)
end

function main()
	oldpad = pad
	Screen.waitVblankStart()
	Screen.refresh()
	printTopScreen()
	printTitleInfo(parsedApplist[selectedCIA].titleid)
	Screen.flip()
	
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_DDOWN) and not Controls.check(oldpad, KEY_DDOWN) then
			selectedCIA = selectedCIA + 1
			selection = selection + 1
			if (selectedCIA > #parsedApplist) then
				selectedCIA = 1
				menuOffset = 0
				selection = 1
			end
			if selection > screenHeightVar then
				selection = screenHeightVar
				menuOffset = menuOffset + 1
			end
		elseif Controls.check(pad, KEY_DUP) and not Controls.check(oldpad, KEY_DUP) then
			selectedCIA = selectedCIA - 1
			selection = selection - 1
			if (selectedCIA < 1) then
				selectedCIA = #parsedApplist
				selection = screenHeightVar
				menuOffset = #parsedApplist - screenHeightVar
			end
			if selection < 1 then
				selection = 1
				menuOffset = menuOffset - 1
			end
		elseif Controls.check(pad, KEY_DLEFT) and not Controls.check(oldpad, KEY_DLEFT) then
		elseif Controls.check(pad, KEY_L) and not Controls.check(oldpad, KEY_L) then
			sortMode = sortMode - 1
			if sortMode < 1 then sortMode = #sortModes end
			table.sort(parsedApplist, sortModes[sortMode].sortFunction)
		elseif Controls.check(pad, KEY_R) and not Controls.check(oldpad, KEY_R) then
			sortMode = sortMode + 1
			if sortMode > #sortModes then sortMode = 1 end
			table.sort(parsedApplist, sortModes[sortMode].sortFunction)
		elseif Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			oldpad = pad
			downloadAndInstall(parsedApplist[selectedCIA].titleid)
		elseif Controls.check(pad, KEY_X) and not Controls.check(oldpad, KEY_X) and installed[parsedApplist[selectedCIA].titleid] and System.checkBuild() == 1 then
			oldpad = pad
			launchByTitleId(parsedApplist[selectedCIA].titleid)
		elseif Controls.check(pad, KEY_START) and not Controls.check(oldpad, KEY_START) then
			oldpad = pad
			menu()
		elseif Controls.check(pad, KEY_HOME) and System.checkBuild() ~= 1 then
			System.exit()
		elseif Controls.check(pad, KEY_HOME) and System.checkBuild() == 1 then
			System.showHomeMenu()
		end
		checkForExit()
		oldpad = pad
		main()
	end
end

function init()
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	Screen.waitVblankStart()
	Screen.flip()
	
	local line = 5
	Screen.debugPrint(5, line, "Initialising Homebr3w, please wait...", WHITE, TOP_SCREEN)
	
	line = 20
	Screen.debugPrint(5, line, "Loading config...", WHITE, TOP_SCREEN)
	if loadConfig() then
		config_backup = deepcopy(config)
		sortMode = config.defaultSortMode.value
		Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	else
		Screen.debugPrint(270, line, "[FAILED]", RED, TOP_SCREEN)
	end
	
	line = 35
	Screen.debugPrint(5, line, "Checking Wi-Fi...", WHITE, TOP_SCREEN)
	checkWifi()
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 50
	Screen.debugPrint(5, line, "Retrieving Applist...", WHITE, TOP_SCREEN)
	local tries = 0
	local success, tbl = false, {}
	while (tries < config.downloadRetryCount.value) and (not success) do
		tries = tries + 1
		success, tbl = getJSON(API_URL.."v0/")
	end
	
	if not success then
		showError("Error occured while fetching remote data\nPress A to try again\nPress B to return to "..home..".", function()
			pad = Controls.read()
			if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
				init()
			elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
				System.exit()
			end
			oldpad = pad
		end)
	end
	parsedApplist = tbl
	table.sort(parsedApplist, sortModes[sortMode].sortFunction)
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 65
	Screen.debugPrint(5, line, "Retrieving Homebr3w info...", WHITE, TOP_SCREEN)
	tries = 0
	success, tbl = false, {}
	while (tries < config.downloadRetryCount.value) and (not success) do
		tries = tries + 1
		success, tbl = getJSON("http://homebr3w.wolvan.at/meta.php")
	end
	
	if not success then
		showError("Error occured while fetching remote data\nPress A to try again\nPress B to return to "..home..".", function()
			pad = Controls.read()
			if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
				init()
			elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
				System.exit()
			end
			oldpad = pad
		end)
	end
	homebr3wInfo = tbl
	blacklistedApps = homebr3wInfo.blacklisted
	parsedApplist = table.filter(parsedApplist, function (item)
		for k,v in pairs(blacklistedApps) do
			if item.titleid == v then
				return false
			end
		end
		return true
	end)
	if not parsedApplist[1] then table.remove(parsedApplist, 1) end
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 80
	Screen.debugPrint(5, line, "Checking for Updates...", WHITE, TOP_SCREEN)
	if config.enableUpdateCheck.value then
		locVer = parseVersion(APP_VERSION)
		remVer = parseVersion(homebr3wInfo.current_version)
		canUpdate = isUpdateAvailable(locVer, remVer)
		Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	else
		Screen.debugPrint(270, line, "[SKIPPED]", YELLOW, TOP_SCREEN)
	end
	
	line = 95
	Screen.debugPrint(5, line, "Checking cache...", WHITE, TOP_SCREEN)
	checkCache(parsedApplist)
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 110
	Screen.debugPrint(5, line, "Checking installed CIAs...", WHITE, TOP_SCREEN)
	installed = checkInstalled()
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	main()
end

-- END MAIN PROGRAM CODE
init()
