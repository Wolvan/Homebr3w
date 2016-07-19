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
local BLUE = Color.new(70,50,250)

local APP_VERSION = "1.1.0"
local APP_DIR = "/Homebr3w"
local APP_CACHE = APP_DIR.."/Cache"
local APP_CONFIG = APP_DIR.."/config.json"
local APP_CIA_DIR = APP_DIR.."/CIAs"
local INSTALLED_STATE = {
	NOT_INSTALLED = 4,
	LATEST_VERSION = 3,
	OUTDATED_VERSION = 1,
	VERSION_UNKNOWN = 2
}

local API_URL = "https://api.titledb.com/"

--[[
	Libraries that I use get defined here
	Unfortunately I can not simply load them
	with require or dofile since those do not
	read from romfs
]]--
--dkjson by David Kolf, http://dkolf.de/src/dkjson-lua.fsl/ for full source
--[==[

David Kolf's JSON module for Lua 5.1/5.2

Version 2.5


For the documentation see the corresponding readme.txt or visit
<http://dkolf.de/src/dkjson-lua.fsl/>.

You can contact the author by sending an e-mail to 'david' at the
domain 'dkolf.de'.


Copyright (C) 2010-2013 David Heiko Kolf

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]==]
function jsonfunction()
	local a=true;local b=false;local c='json'local pairs,type,tostring,tonumber,getmetatable,setmetatable,rawset=pairs,type,tostring,tonumber,getmetatable,setmetatable,rawset;local error,require,pcall,select=error,require,pcall,select;local d,e=math.floor,math.huge;local f,g,h,i,j,k,l,m=string.rep,string.gsub,string.sub,string.byte,string.char,string.find,string.len,string.format;local n=string.match;local o=table.concat;local p={version="dkjson 2.5"}if b then _G[c]=p end;local q=nil;pcall(function()local r=require"debug".getmetatable;if r then getmetatable=r end end)p.null=setmetatable({},{__tojson=function()return"null"end})local function s(t)local u,v,w=0,0,0;for x,y in pairs(t)do if x=='n'and type(y)=='number'then w=y;if y>u then u=y end else if type(x)~='number'or x<1 or d(x)~=x then return false end;if x>u then u=x end;v=v+1 end end;if u>10 and u>w and u>v*2 then return false end;return true,u end;local z={["\""]="\\\"",["\\"]="\\\\",["\b"]="\\b",["\f"]="\\f",["\n"]="\\n",["\r"]="\\r",["\t"]="\\t"}local function A(B)local C=z[B]if C then return C end;local D,E,F,G=i(B,1,4)D,E,F,G=D or 0,E or 0,F or 0,G or 0;if D<=0x7f then C=D elseif 0xc0<=D and D<=0xdf and E>=0x80 then C=(D-0xc0)*0x40+E-0x80 elseif 0xe0<=D and D<=0xef and E>=0x80 and F>=0x80 then C=((D-0xe0)*0x40+E-0x80)*0x40+F-0x80 elseif 0xf0<=D and D<=0xf7 and E>=0x80 and F>=0x80 and G>=0x80 then C=(((D-0xf0)*0x40+E-0x80)*0x40+F-0x80)*0x40+G-0x80 else return""end;if C<=0xffff then return m("\\u%.4x",C)elseif C<=0x10ffff then C=C-0x10000;local H,I=0xD800+d(C/0x400),0xDC00+C%0x400;return m("\\u%.4x\\u%.4x",H,I)else return""end end;local function J(K,L,M)if k(K,L)then return g(K,L,M)else return K end end;local function N(C)C=J(C,"[%z\1-\31\"\\\127]",A)if k(C,"[\194\216\220\225\226\239]")then C=J(C,"\194[\128-\159\173]",A)C=J(C,"\216[\128-\132]",A)C=J(C,"\220\143",A)C=J(C,"\225\158[\180\181]",A)C=J(C,"\226\128[\140-\143\168-\175]",A)C=J(C,"\226\129[\160-\175]",A)C=J(C,"\239\187\191",A)C=J(C,"\239\191[\176-\191]",A)end;return"\""..C.."\""end;p.quotestring=N;local function O(K,P,v)local Q,R=k(K,P,1,true)if Q then return h(K,1,Q-1)..v..h(K,R+1,-1)else return K end end;local S,T;local function U()S=n(tostring(0.5),"([^05+])")T="[^0-9%-%+eE"..g(S,"[%^%$%(%)%%%.%[%]%*%+%-%?]","%%%0").."]+"end;U()local function V(W)return O(J(tostring(W),T,""),S,".")end;local function X(K)local W=tonumber(O(K,".",S))if not W then U()W=tonumber(O(K,".",S))end;return W end;local function Y(Z,_,a0)_[a0+1]="\n"_[a0+2]=f("  ",Z)a0=a0+2;return a0 end;function p.addnewline(a1)if a1.indent then a1.bufferlen=Y(a1.level or 0,a1.buffer,a1.bufferlen or#a1.buffer)end end;local a2;local function a3(a4,C,a5,a6,Z,_,a0,a7,a8,a1)local a9=type(a4)if a9~='string'and a9~='number'then return nil,"type '"..a9 .."' is not supported as a key by JSON."end;if a5 then a0=a0+1;_[a0]=","end;if a6 then a0=Y(Z,_,a0)end;_[a0+1]=N(a4)_[a0+2]=":"return a2(C,a6,Z,_,a0+2,a7,a8,a1)end;local function aa(ab,_,a1)local a0=a1.bufferlen;if type(ab)=='string'then a0=a0+1;_[a0]=ab end;return a0 end;local function ac(ad,C,a1,_,a0,ae)ae=ae or ad;local af=a1.exception;if not af then return nil,ae else a1.bufferlen=a0;local ag,ah=af(ad,C,a1,ae)if not ag then return nil,ah or ae end;return aa(ag,_,a1)end end;function p.encodeexception(ad,C,a1,ae)return N("<"..ae..">")end;a2=function(C,a6,Z,_,a0,a7,a8,a1)local ai=type(C)local aj=getmetatable(C)aj=type(aj)=='table'and aj;local ak=aj and aj.__tojson;if ak then if a7[C]then return ac('reference cycle',C,a1,_,a0)end;a7[C]=true;a1.bufferlen=a0;local ag,ah=ak(C,a1)if not ag then return ac('custom encoder failed',C,a1,_,a0,ah)end;a7[C]=nil;a0=aa(ag,_,a1)elseif C==nil then a0=a0+1;_[a0]="null"elseif ai=='number'then local al;if C~=C or C>=e or-C>=e then al="null"else al=V(C)end;a0=a0+1;_[a0]=al elseif ai=='boolean'then a0=a0+1;_[a0]=C and"true"or"false"elseif ai=='string'then a0=a0+1;_[a0]=N(C)elseif ai=='table'then if a7[C]then return ac('reference cycle',C,a1,_,a0)end;a7[C]=true;Z=Z+1;local am,v=s(C)if v==0 and aj and aj.__jsontype=='object'then am=false end;local ah;if am then a0=a0+1;_[a0]="["for Q=1,v do a0,ah=a2(C[Q],a6,Z,_,a0,a7,a8,a1)if not a0 then return nil,ah end;if Q<v then a0=a0+1;_[a0]=","end end;a0=a0+1;_[a0]="]"else local a5=false;a0=a0+1;_[a0]="{"local an=aj and aj.__jsonorder or a8;if an then local ao={}v=#an;for Q=1,v do local x=an[Q]local y=C[x]if y then ao[x]=true;a0,ah=a3(x,y,a5,a6,Z,_,a0,a7,a8,a1)a5=true end end;for x,y in pairs(C)do if not ao[x]then a0,ah=a3(x,y,a5,a6,Z,_,a0,a7,a8,a1)if not a0 then return nil,ah end;a5=true end end else for x,y in pairs(C)do a0,ah=a3(x,y,a5,a6,Z,_,a0,a7,a8,a1)if not a0 then return nil,ah end;a5=true end end;if a6 then a0=Y(Z-1,_,a0)end;a0=a0+1;_[a0]="}"end;a7[C]=nil else return ac('unsupported type',C,a1,_,a0,"type '"..ai.."' is not supported by JSON.")end;return a0 end;function p.encode(C,a1)a1=a1 or{}local ap=a1.buffer;local _=ap or{}a1.buffer=_;U()local ag,ah=a2(C,a1.indent,a1.level or 0,_,a1.bufferlen or 0,a1.tables or{},a1.keyorder,a1)if not ag then error(ah,2)elseif ap==_ then a1.bufferlen=ag;return true else a1.bufferlen=nil;a1.buffer=nil;return o(_)end end;local function aq(K,ar)local as,at,au=1,1,0;while true do at=k(K,"\n",at,true)if at and at<ar then as=as+1;au=at;at=at+1 else break end end;return"line "..as..", column "..ar-au end;local function av(K,aw,ar)return nil,l(K)+1,"unterminated "..aw.." at "..aq(K,ar)end;local function ax(K,at)while true do at=k(K,"%S",at)if not at then return nil end;local ay=h(K,at,at+1)if ay=="\239\187"and h(K,at+2,at+2)=="\191"then at=at+3 elseif ay=="//"then at=k(K,"[\n\r]",at+2)if not at then return nil end elseif ay=="/*"then at=k(K,"*/",at+2)if not at then return nil end;at=at+2 else return at end end end;local az={["\""]="\"",["\\"]="\\",["/"]="/",["b"]="\b",["f"]="\f",["n"]="\n",["r"]="\r",["t"]="\t"}local function aA(C)if C<0 then return nil elseif C<=0x007f then return j(C)elseif C<=0x07ff then return j(0xc0+d(C/0x40),0x80+d(C)%0x40)elseif C<=0xffff then return j(0xe0+d(C/0x1000),0x80+d(C/0x40)%0x40,0x80+d(C)%0x40)elseif C<=0x10ffff then return j(0xf0+d(C/0x40000),0x80+d(C/0x1000)%0x40,0x80+d(C/0x40)%0x40,0x80+d(C)%0x40)else return nil end end;local function aB(K,at)local aC=at+1;local _,v={},0;while true do local aD=k(K,"[\"\\]",aC)if not aD then return av(K,"string",at)end;if aD>aC then v=v+1;_[v]=h(K,aC,aD-1)end;if h(K,aD,aD)=="\""then aC=aD+1;break else local aE=h(K,aD+1,aD+1)local C;if aE=="u"then C=tonumber(h(K,aD+2,aD+5),16)if C then local aF;if 0xD800<=C and C<=0xDBff then if h(K,aD+6,aD+7)=="\\u"then aF=tonumber(h(K,aD+8,aD+11),16)if aF and 0xDC00<=aF and aF<=0xDFFF then C=(C-0xD800)*0x400+aF-0xDC00+0x10000 else aF=nil end end end;C=C and aA(C)if C then if aF then aC=aD+12 else aC=aD+6 end end end end;if not C then C=az[aE]or aE;aC=aD+2 end;v=v+1;_[v]=C end end;if v==1 then return _[1],aC elseif v>1 then return o(_),aC else return"",aC end end;local aG;local function aH(aw,aI,K,aJ,aK,aL,aM)local aN=l(K)local t,v={},0;local at=aJ+1;if aw=='object'then setmetatable(t,aL)else setmetatable(t,aM)end;while true do at=ax(K,at)if not at then return av(K,aw,aJ)end;local aO=h(K,at,at)if aO==aI then return t,at+1 end;local aP,aQ;aP,at,aQ=aG(K,at,aK,aL,aM)if aQ then return nil,at,aQ end;at=ax(K,at)if not at then return av(K,aw,aJ)end;aO=h(K,at,at)if aO==":"then if aP==nil then return nil,at,"cannot use nil as table index (at "..aq(K,at)..")"end;at=ax(K,at+1)if not at then return av(K,aw,aJ)end;local aR;aR,at,aQ=aG(K,at,aK,aL,aM)if aQ then return nil,at,aQ end;t[aP]=aR;at=ax(K,at)if not at then return av(K,aw,aJ)end;aO=h(K,at,at)else v=v+1;t[v]=aP end;if aO==","then at=at+1 end end end;aG=function(K,at,aK,aL,aM)at=at or 1;at=ax(K,at)if not at then return nil,l(K)+1,"no valid JSON value (reached the end)"end;local aO=h(K,at,at)if aO=="{"then return aH('object',"}",K,at,aK,aL,aM)elseif aO=="["then return aH('array',"]",K,at,aK,aL,aM)elseif aO=="\""then return aB(K,at)else local aS,aT=k(K,"^%-?[%d%.]+[eE]?[%+%-]?%d*",at)if aS then local aU=X(h(K,aS,aT))if aU then return aU,aT+1 end end;aS,aT=k(K,"^%a%w*",at)if aS then local aV=h(K,aS,aT)if aV=="true"then return true,aT+1 elseif aV=="false"then return false,aT+1 elseif aV=="null"then return aK,aT+1 end end;return nil,at,"no valid JSON value at "..aq(K,at)end end;local function aW(...)if select("#",...)>0 then return...else return{__jsontype='object'},{__jsontype='array'}end end;function p.decode(K,at,aK,...)local aL,aM=aW(...)return aG(K,at,aK,aL,aM)end;function p.use_lpeg()local aX=require("lpeg")if aX.version()=="0.11"then error"due to a bug in LPeg 0.11, it cannot be used for JSON matching"end;local aY=aX.match;local aZ,a_,b0=aX.P,aX.S,aX.R;local function b1(K,at,ah,a1)if not a1.msg then a1.msg=ah.." at "..aq(K,at)a1.pos=at end;return false end;local function b2(ah)return aX.Cmt(aX.Cc(ah)*aX.Carg(2),b1)end;local b3=aZ"//"*(1-a_"\n\r")^0;local b4=aZ"/*"*(1-aZ"*/")^0*aZ"*/"local b5=(a_" \n\r\t"+aZ"\239\187\191"+b3+b4)^0;local b6=1-a_"\"\\\n\r"local b7=aZ"\\"*aX.C(a_"\"\\/bfnrt"+b2"unsupported escape sequence")/az;local b8=b0("09","af","AF")local function b9(ba,at,bb,bc)bb,bc=tonumber(bb,16),tonumber(bc,16)if 0xD800<=bb and bb<=0xDBff and 0xDC00<=bc and bc<=0xDFFF then return true,aA((bb-0xD800)*0x400+bc-0xDC00+0x10000)else return false end end;local function bd(be)return aA(tonumber(be,16))end;local bf=aZ"\\u"*aX.C(b8*b8*b8*b8)local bg=aX.Cmt(bf*bf,b9)+bf/bd;local bh=bg+b7+b6;local bi=aZ"\""*aX.Cs(bh^0)*(aZ"\""+b2"unterminated string")local bj=aZ"-"^-1*(aZ"0"+b0"19"*b0"09"^0)local bk=aZ"."*b0"09"^0;local bl=a_"eE"*a_"+-"^-1*b0"09"^1;local bm=bj*bk^-1*bl^-1/X;local bn=aZ"true"*aX.Cc(true)+aZ"false"*aX.Cc(false)+aZ"null"*aX.Carg(1)local bo=bm+bi+bn;local bp,bq;local function br(K,at,aK,a1)local bs,bt;local bu;local bv,bw={},0;repeat bs,bt,bu=aY(bp,K,at,aK,a1)if not bu then break end;at=bu;bw=bw+1;bv[bw]=bs until bt=='last'return at,setmetatable(bv,a1.arraymeta)end;local function bx(K,at,aK,a1)local bs,a4,bt;local bu;local bv={}repeat a4,bs,bt,bu=aY(bq,K,at,aK,a1)if not bu then break end;at=bu;bv[a4]=bs until bt=='last'return at,setmetatable(bv,a1.objectmeta)end;local by=aZ"["*aX.Cmt(aX.Carg(1)*aX.Carg(2),br)*b5*(aZ"]"+b2"']' expected")local bz=aZ"{"*aX.Cmt(aX.Carg(1)*aX.Carg(2),bx)*b5*(aZ"}"+b2"'}' expected")local bA=b5*(by+bz+bo)local bB=bA+b5*b2"value expected"bp=bA*b5*(aZ","*aX.Cc'cont'+aX.Cc'last')*aX.Cp()local bC=aX.Cg(b5*bi*b5*(aZ":"+b2"colon expected")*bB)bq=bC*b5*(aZ","*aX.Cc'cont'+aX.Cc'last')*aX.Cp()local bD=bB*aX.Cp()function p.decode(K,at,aK,...)local a1={}a1.objectmeta,a1.arraymeta=aW(...)local bs,bE=aY(bD,K,at,aK,a1)if a1.msg then return nil,a1.pos,a1.msg else return bs,bE end end;p.use_lpeg=function()return p end;p.using_lpeg=true;return p end;if a then pcall(p.use_lpeg)end;return p
end
local json = jsonfunction()

-- qrencode by Patrick Gundlach, http://speedata.github.com/luaqrcode/ for full source
--- Please report bugs on the [github project page](http://speedata.github.com/luaqrcode/).
-- Copyright (c) 2012, Patrick Gundlach
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--	 * Redistributions of source code must retain the above copyright
--	   notice, this list of conditions and the following disclaimer.
--	 * Redistributions in binary form must reproduce the above copyright
--	   notice, this list of conditions and the following disclaimer in the
--	   documentation and/or other materials provided with the distribution.
--	 * Neither the name of the <organization> nor the
--	   names of its contributors may be used to endorse or promote products
--	   derived from this software without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
function qrencodefunction()
	local a={[0]={0,0,0,0,0,0,0,0},{1,0,0,0,0,0,0,0},{0,1,0,0,0,0,0,0},{1,1,0,0,0,0,0,0},{0,0,1,0,0,0,0,0},{1,0,1,0,0,0,0,0},{0,1,1,0,0,0,0,0},{1,1,1,0,0,0,0,0},{0,0,0,1,0,0,0,0},{1,0,0,1,0,0,0,0},{0,1,0,1,0,0,0,0},{1,1,0,1,0,0,0,0},{0,0,1,1,0,0,0,0},{1,0,1,1,0,0,0,0},{0,1,1,1,0,0,0,0},{1,1,1,1,0,0,0,0},{0,0,0,0,1,0,0,0},{1,0,0,0,1,0,0,0},{0,1,0,0,1,0,0,0},{1,1,0,0,1,0,0,0},{0,0,1,0,1,0,0,0},{1,0,1,0,1,0,0,0},{0,1,1,0,1,0,0,0},{1,1,1,0,1,0,0,0},{0,0,0,1,1,0,0,0},{1,0,0,1,1,0,0,0},{0,1,0,1,1,0,0,0},{1,1,0,1,1,0,0,0},{0,0,1,1,1,0,0,0},{1,0,1,1,1,0,0,0},{0,1,1,1,1,0,0,0},{1,1,1,1,1,0,0,0},{0,0,0,0,0,1,0,0},{1,0,0,0,0,1,0,0},{0,1,0,0,0,1,0,0},{1,1,0,0,0,1,0,0},{0,0,1,0,0,1,0,0},{1,0,1,0,0,1,0,0},{0,1,1,0,0,1,0,0},{1,1,1,0,0,1,0,0},{0,0,0,1,0,1,0,0},{1,0,0,1,0,1,0,0},{0,1,0,1,0,1,0,0},{1,1,0,1,0,1,0,0},{0,0,1,1,0,1,0,0},{1,0,1,1,0,1,0,0},{0,1,1,1,0,1,0,0},{1,1,1,1,0,1,0,0},{0,0,0,0,1,1,0,0},{1,0,0,0,1,1,0,0},{0,1,0,0,1,1,0,0},{1,1,0,0,1,1,0,0},{0,0,1,0,1,1,0,0},{1,0,1,0,1,1,0,0},{0,1,1,0,1,1,0,0},{1,1,1,0,1,1,0,0},{0,0,0,1,1,1,0,0},{1,0,0,1,1,1,0,0},{0,1,0,1,1,1,0,0},{1,1,0,1,1,1,0,0},{0,0,1,1,1,1,0,0},{1,0,1,1,1,1,0,0},{0,1,1,1,1,1,0,0},{1,1,1,1,1,1,0,0},{0,0,0,0,0,0,1,0},{1,0,0,0,0,0,1,0},{0,1,0,0,0,0,1,0},{1,1,0,0,0,0,1,0},{0,0,1,0,0,0,1,0},{1,0,1,0,0,0,1,0},{0,1,1,0,0,0,1,0},{1,1,1,0,0,0,1,0},{0,0,0,1,0,0,1,0},{1,0,0,1,0,0,1,0},{0,1,0,1,0,0,1,0},{1,1,0,1,0,0,1,0},{0,0,1,1,0,0,1,0},{1,0,1,1,0,0,1,0},{0,1,1,1,0,0,1,0},{1,1,1,1,0,0,1,0},{0,0,0,0,1,0,1,0},{1,0,0,0,1,0,1,0},{0,1,0,0,1,0,1,0},{1,1,0,0,1,0,1,0},{0,0,1,0,1,0,1,0},{1,0,1,0,1,0,1,0},{0,1,1,0,1,0,1,0},{1,1,1,0,1,0,1,0},{0,0,0,1,1,0,1,0},{1,0,0,1,1,0,1,0},{0,1,0,1,1,0,1,0},{1,1,0,1,1,0,1,0},{0,0,1,1,1,0,1,0},{1,0,1,1,1,0,1,0},{0,1,1,1,1,0,1,0},{1,1,1,1,1,0,1,0},{0,0,0,0,0,1,1,0},{1,0,0,0,0,1,1,0},{0,1,0,0,0,1,1,0},{1,1,0,0,0,1,1,0},{0,0,1,0,0,1,1,0},{1,0,1,0,0,1,1,0},{0,1,1,0,0,1,1,0},{1,1,1,0,0,1,1,0},{0,0,0,1,0,1,1,0},{1,0,0,1,0,1,1,0},{0,1,0,1,0,1,1,0},{1,1,0,1,0,1,1,0},{0,0,1,1,0,1,1,0},{1,0,1,1,0,1,1,0},{0,1,1,1,0,1,1,0},{1,1,1,1,0,1,1,0},{0,0,0,0,1,1,1,0},{1,0,0,0,1,1,1,0},{0,1,0,0,1,1,1,0},{1,1,0,0,1,1,1,0},{0,0,1,0,1,1,1,0},{1,0,1,0,1,1,1,0},{0,1,1,0,1,1,1,0},{1,1,1,0,1,1,1,0},{0,0,0,1,1,1,1,0},{1,0,0,1,1,1,1,0},{0,1,0,1,1,1,1,0},{1,1,0,1,1,1,1,0},{0,0,1,1,1,1,1,0},{1,0,1,1,1,1,1,0},{0,1,1,1,1,1,1,0},{1,1,1,1,1,1,1,0},{0,0,0,0,0,0,0,1},{1,0,0,0,0,0,0,1},{0,1,0,0,0,0,0,1},{1,1,0,0,0,0,0,1},{0,0,1,0,0,0,0,1},{1,0,1,0,0,0,0,1},{0,1,1,0,0,0,0,1},{1,1,1,0,0,0,0,1},{0,0,0,1,0,0,0,1},{1,0,0,1,0,0,0,1},{0,1,0,1,0,0,0,1},{1,1,0,1,0,0,0,1},{0,0,1,1,0,0,0,1},{1,0,1,1,0,0,0,1},{0,1,1,1,0,0,0,1},{1,1,1,1,0,0,0,1},{0,0,0,0,1,0,0,1},{1,0,0,0,1,0,0,1},{0,1,0,0,1,0,0,1},{1,1,0,0,1,0,0,1},{0,0,1,0,1,0,0,1},{1,0,1,0,1,0,0,1},{0,1,1,0,1,0,0,1},{1,1,1,0,1,0,0,1},{0,0,0,1,1,0,0,1},{1,0,0,1,1,0,0,1},{0,1,0,1,1,0,0,1},{1,1,0,1,1,0,0,1},{0,0,1,1,1,0,0,1},{1,0,1,1,1,0,0,1},{0,1,1,1,1,0,0,1},{1,1,1,1,1,0,0,1},{0,0,0,0,0,1,0,1},{1,0,0,0,0,1,0,1},{0,1,0,0,0,1,0,1},{1,1,0,0,0,1,0,1},{0,0,1,0,0,1,0,1},{1,0,1,0,0,1,0,1},{0,1,1,0,0,1,0,1},{1,1,1,0,0,1,0,1},{0,0,0,1,0,1,0,1},{1,0,0,1,0,1,0,1},{0,1,0,1,0,1,0,1},{1,1,0,1,0,1,0,1},{0,0,1,1,0,1,0,1},{1,0,1,1,0,1,0,1},{0,1,1,1,0,1,0,1},{1,1,1,1,0,1,0,1},{0,0,0,0,1,1,0,1},{1,0,0,0,1,1,0,1},{0,1,0,0,1,1,0,1},{1,1,0,0,1,1,0,1},{0,0,1,0,1,1,0,1},{1,0,1,0,1,1,0,1},{0,1,1,0,1,1,0,1},{1,1,1,0,1,1,0,1},{0,0,0,1,1,1,0,1},{1,0,0,1,1,1,0,1},{0,1,0,1,1,1,0,1},{1,1,0,1,1,1,0,1},{0,0,1,1,1,1,0,1},{1,0,1,1,1,1,0,1},{0,1,1,1,1,1,0,1},{1,1,1,1,1,1,0,1},{0,0,0,0,0,0,1,1},{1,0,0,0,0,0,1,1},{0,1,0,0,0,0,1,1},{1,1,0,0,0,0,1,1},{0,0,1,0,0,0,1,1},{1,0,1,0,0,0,1,1},{0,1,1,0,0,0,1,1},{1,1,1,0,0,0,1,1},{0,0,0,1,0,0,1,1},{1,0,0,1,0,0,1,1},{0,1,0,1,0,0,1,1},{1,1,0,1,0,0,1,1},{0,0,1,1,0,0,1,1},{1,0,1,1,0,0,1,1},{0,1,1,1,0,0,1,1},{1,1,1,1,0,0,1,1},{0,0,0,0,1,0,1,1},{1,0,0,0,1,0,1,1},{0,1,0,0,1,0,1,1},{1,1,0,0,1,0,1,1},{0,0,1,0,1,0,1,1},{1,0,1,0,1,0,1,1},{0,1,1,0,1,0,1,1},{1,1,1,0,1,0,1,1},{0,0,0,1,1,0,1,1},{1,0,0,1,1,0,1,1},{0,1,0,1,1,0,1,1},{1,1,0,1,1,0,1,1},{0,0,1,1,1,0,1,1},{1,0,1,1,1,0,1,1},{0,1,1,1,1,0,1,1},{1,1,1,1,1,0,1,1},{0,0,0,0,0,1,1,1},{1,0,0,0,0,1,1,1},{0,1,0,0,0,1,1,1},{1,1,0,0,0,1,1,1},{0,0,1,0,0,1,1,1},{1,0,1,0,0,1,1,1},{0,1,1,0,0,1,1,1},{1,1,1,0,0,1,1,1},{0,0,0,1,0,1,1,1},{1,0,0,1,0,1,1,1},{0,1,0,1,0,1,1,1},{1,1,0,1,0,1,1,1},{0,0,1,1,0,1,1,1},{1,0,1,1,0,1,1,1},{0,1,1,1,0,1,1,1},{1,1,1,1,0,1,1,1},{0,0,0,0,1,1,1,1},{1,0,0,0,1,1,1,1},{0,1,0,0,1,1,1,1},{1,1,0,0,1,1,1,1},{0,0,1,0,1,1,1,1},{1,0,1,0,1,1,1,1},{0,1,1,0,1,1,1,1},{1,1,1,0,1,1,1,1},{0,0,0,1,1,1,1,1},{1,0,0,1,1,1,1,1},{0,1,0,1,1,1,1,1},{1,1,0,1,1,1,1,1},{0,0,1,1,1,1,1,1},{1,0,1,1,1,1,1,1},{0,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1}}local function b(c)local d=#c;local e=0;local f=1;for g=1,d do e=e+c[g]*f;f=f*2 end;return e end;local function h(i,d)local j=a[i]local k=a[d]local c={}for g=1,8 do if j[g]~=k[g]then c[g]=1 else c[g]=0 end end;return b(c)end;local function l(m,n)local o=string.format("%o",m)local p={["0"]="000",["1"]="001",["2"]="010",["3"]="011",["4"]="100",["5"]="101",["6"]="110",["7"]="111"}o=string.gsub(o,"(.)",function(q)return p[q]end)o=string.gsub(o,"^0*(.*)$","%1")local r=string.format("%%%ds",n)local s=string.format(r,o)return string.gsub(s," ","0")end;local function t(u,v,m,w)if v=="1"then u[m][w]=2 else u[m][w]=-2 end end;local function x(y)local z;if string.match(y,"^[0-9]+$")then return 1 elseif string.match(y,"^[0-9A-Z $%%*./:+-]+$")then return 2 else return 4 end;assert(false,"never reached")return nil end;local A={{19,16,13,9},{34,28,22,16},{55,44,34,26},{80,64,48,36},{108,86,62,46},{136,108,76,60},{156,124,88,66},{194,154,110,86},{232,182,132,100},{274,216,154,122},{324,254,180,140},{370,290,206,158},{428,334,244,180},{461,365,261,197},{523,415,295,223},{589,453,325,253},{647,507,367,283},{721,563,397,313},{795,627,445,341},{861,669,485,385},{932,714,512,406},{1006,782,568,442},{1094,860,614,464},{1174,914,664,514},{1276,1000,718,538},{1370,1062,754,596},{1468,1128,808,628},{1531,1193,871,661},{1631,1267,911,701},{1735,1373,985,745},{1843,1455,1033,793},{1955,1541,1115,845},{2071,1631,1171,901},{2191,1725,1231,961},{2306,1812,1286,986},{2434,1914,1354,1054},{2566,1992,1426,1096},{2702,2102,1502,1142},{2812,2216,1582,1222},{2956,2334,1666,1276}}local function B(C,z,D)local E=z;if z==4 then E=3 elseif z==8 then E=4 end;assert(E<=4)local F,G,n,H,I;local J={{10,9,8,8},{12,11,16,10},{14,13,16,12}}local K=40;local L=1;for M=1,4 do if D==nil or M>=D then for N=1,#A do G=A[N][M]*8;G=G-4;if N<10 then n=J[1][E]elseif N<27 then n=J[2][E]elseif N<=40 then n=J[3][E]end;H=G-n;if E==1 then I=math.floor(H*3/10)elseif E==2 then I=math.floor(H*2/11)elseif E==3 then I=math.floor(H*1/8)else I=math.floor(H*1/13)end;if I>=C then if N<=K then K=N;L=M end;break end end end end;return K,L end;local function O(y,N,z)local g=z;if z==4 then g=3 elseif z==8 then g=4 end;assert(g<=4)local J={{10,9,8,8},{12,11,16,10},{14,13,16,12}}local n;if N<10 then n=J[1][g]elseif N<27 then n=J[2][g]elseif N<=40 then n=J[3][g]else assert(false,"get_length, version > 40 not supported")end;local C=l(#y,n)return C end;local function P(y,D,z)local E;if z then assert(false,"not implemented")E=z else E=x(y)end;local N,M;N,M=B(#y,E,D)local Q=O(y,N,E)return N,M,l(E,4),E,Q end;local R={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,36,-1,-1,-1,37,38,-1,-1,-1,-1,39,40,-1,41,42,43,0,1,2,3,4,5,6,7,8,9,44,-1,-1,-1,-1,-1,-1,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,-1,-1,-1,-1,-1}local function S(y)local v=""local T;string.gsub(y,"..?.?",function(p)T=tonumber(p)if#p==3 then v=v..l(T,10)elseif#p==2 then v=v..l(T,7)else v=v..l(T,4)end end)return v end;local function U(y)local v=""local T;local V,W;string.gsub(y,"..?",function(p)if#p==2 then V=R[string.byte(string.sub(p,1,1))]W=R[string.byte(string.sub(p,2,2))]T=V*45+W;v=v..l(T,11)else T=R[string.byte(p)]v=v..l(T,6)end end)return v end;local function X(y)local s={}string.gsub(y,".",function(m)s[#s+1]=l(string.byte(m),8)end)return table.concat(s)end;local function Y(y,z)if z==1 then return S(y)elseif z==2 then return U(y)elseif z==4 then return X(y)else assert(false,"not implemented yet")end end;local function Z(N,M,_)local a0,a1;local a2=A[N][M]*8;a0=math.min(4,a2-#_)if a0>0 then _=_..string.rep("0",a0)end;if math.fmod(#_,8)~=0 then a1=8-math.fmod(#_,8)_=_..string.rep("0",a1)end;assert(math.fmod(#_,8)==0)while#_<a2 do _=_.."11101100"if#_<a2 then _=_.."00010001"end end;return _ end;local a3={[0]=0,2,4,8,16,32,64,128,29,58,116,232,205,135,19,38,76,152,45,90,180,117,234,201,143,3,6,12,24,48,96,192,157,39,78,156,37,74,148,53,106,212,181,119,238,193,159,35,70,140,5,10,20,40,80,160,93,186,105,210,185,111,222,161,95,190,97,194,153,47,94,188,101,202,137,15,30,60,120,240,253,231,211,187,107,214,177,127,254,225,223,163,91,182,113,226,217,175,67,134,17,34,68,136,13,26,52,104,208,189,103,206,129,31,62,124,248,237,199,147,59,118,236,197,151,51,102,204,133,23,46,92,184,109,218,169,79,158,33,66,132,21,42,84,168,77,154,41,82,164,85,170,73,146,57,114,228,213,183,115,230,209,191,99,198,145,63,126,252,229,215,179,123,246,241,255,227,219,171,75,150,49,98,196,149,55,110,220,165,87,174,65,130,25,50,100,200,141,7,14,28,56,112,224,221,167,83,166,81,162,89,178,121,242,249,239,195,155,43,86,172,69,138,9,18,36,72,144,61,122,244,245,247,243,251,235,203,139,11,22,44,88,176,125,250,233,207,131,27,54,108,216,173,71,142,1}local a4={[0]=0,255,1,25,2,50,26,198,3,223,51,238,27,104,199,75,4,100,224,14,52,141,239,129,28,193,105,248,200,8,76,113,5,138,101,47,225,36,15,33,53,147,142,218,240,18,130,69,29,181,194,125,106,39,249,185,201,154,9,120,77,228,114,166,6,191,139,98,102,221,48,253,226,152,37,179,16,145,34,136,54,208,148,206,143,150,219,189,241,210,19,92,131,56,70,64,30,66,182,163,195,72,126,110,107,58,40,84,250,133,186,61,202,94,155,159,10,21,121,43,78,212,229,172,115,243,167,87,7,112,192,247,140,128,99,13,103,74,222,237,49,197,254,24,227,165,153,119,38,184,180,124,17,68,146,217,35,32,137,46,55,63,209,91,149,188,207,205,144,135,151,178,220,252,190,97,242,86,211,171,20,42,93,158,132,60,57,83,71,109,65,162,31,45,67,216,183,123,164,118,196,23,73,236,127,12,111,246,108,161,59,82,41,157,85,170,251,96,134,177,187,204,62,90,203,89,95,176,156,169,160,81,11,245,22,235,122,117,44,215,79,174,213,233,230,231,173,232,116,214,244,234,168,80,88,175}local a5={[7]={21,102,238,149,146,229,87,0},[10]={45,32,94,64,70,118,61,46,67,251,0},[13]={78,140,206,218,130,104,106,100,86,100,176,152,74,0},[15]={105,99,5,124,140,237,58,58,51,37,202,91,61,183,8,0},[16]={120,225,194,182,169,147,191,91,3,76,161,102,109,107,104,120,0},[17]={136,163,243,39,150,99,24,147,214,206,123,239,43,78,206,139,43,0},[18]={153,96,98,5,179,252,148,152,187,79,170,118,97,184,94,158,234,215,0},[20]={190,188,212,212,164,156,239,83,225,221,180,202,187,26,163,61,50,79,60,17,0},[22]={231,165,105,160,134,219,80,98,172,8,74,200,53,221,109,14,230,93,242,247,171,210,0},[24]={21,227,96,87,232,117,0,111,218,228,226,192,152,169,180,159,126,251,117,211,48,135,121,229,0},[26]={70,218,145,153,227,48,102,13,142,245,21,161,53,165,28,111,201,145,17,118,182,103,2,158,125,173,0},[28]={123,9,37,242,119,212,195,42,87,245,43,21,201,232,27,205,147,195,190,110,180,108,234,224,104,200,223,168,0},[30]={180,192,40,238,216,251,37,156,130,224,193,226,173,42,125,222,96,239,86,110,48,50,182,179,31,216,152,145,173,41,0}}local function a6(_)local a7={}local J=string.gsub(_,"(........)",function(m)a7[#a7+1]=tonumber(m,2)end)return a7 end;local function a8(a9,aa)local ab={[0]=0}for g=0,aa-a9-1 do ab[g]=0 end;local ac=a5[a9]for g=1,a9+1 do ab[aa-a9+g-1]=ac[g]end;return ab end;local function ad(J)local ae={}for g=0,#J do ae[g]=a4[J[g]]end;return ae end;local function af(J,ag)local ae={}for g=0,#J do ae[g]=a3[J[g]]end;return ae end;local function ah(_,a9)local ai;if type(_)=="string"then ai=a6(_)elseif type(_)=="table"then ai=_ else assert(false,"Unknown type for data: %s",type(_))end;local ag=#ai;local aa=ag+a9-1;local ab,aj;local ak;local al={}local am,an={},{}for g=1,ag do am[aa-g+1]=ai[g]end;for g=1,aa-ag do am[g]=0 end;am[0]=0;an=ad(am)while aa>=a9 do ab=a8(a9,aa)local ao=an[aa]for g=aa,aa-a9,-1 do if ab[g]+ao>255 then ab[g]=math.fmod(ab[g]+ao,255)else ab[g]=ab[g]+ao end end;for g=aa-a9-1,0,-1 do ab[g]=0 end;al=af(ab)am=af(an)aj={}for g=aa,0,-1 do aj[g]=h(al[g],am[g])end;ak=aa;for g=ak,0,-1 do if g<a9 then break end;if aj[g]==0 then aj[g]=nil;aa=aa-1 else break end end;am=aj;an=ad(am)end;local s={}for g=#am,0,-1 do s[#s+1]=am[g]end;return s end;local ap={{{1,{26,19,2}},{1,{26,16,4}},{1,{26,13,6}},{1,{26,9,8}}},{{1,{44,34,4}},{1,{44,28,8}},{1,{44,22,11}},{1,{44,16,14}}},{{1,{70,55,7}},{1,{70,44,13}},{2,{35,17,9}},{2,{35,13,11}}},{{1,{100,80,10}},{2,{50,32,9}},{2,{50,24,13}},{4,{25,9,8}}},{{1,{134,108,13}},{2,{67,43,12}},{2,{33,15,9},2,{34,16,9}},{2,{33,11,11},2,{34,12,11}}},{{2,{86,68,9}},{4,{43,27,8}},{4,{43,19,12}},{4,{43,15,14}}},{{2,{98,78,10}},{4,{49,31,9}},{2,{32,14,9},4,{33,15,9}},{4,{39,13,13},1,{40,14,13}}},{{2,{121,97,12}},{2,{60,38,11},2,{61,39,11}},{4,{40,18,11},2,{41,19,11}},{4,{40,14,13},2,{41,15,13}}},{{2,{146,116,15}},{3,{58,36,11},2,{59,37,11}},{4,{36,16,10},4,{37,17,10}},{4,{36,12,12},4,{37,13,12}}},{{2,{86,68,9},2,{87,69,9}},{4,{69,43,13},1,{70,44,13}},{6,{43,19,12},2,{44,20,12}},{6,{43,15,14},2,{44,16,14}}},{{4,{101,81,10}},{1,{80,50,15},4,{81,51,15}},{4,{50,22,14},4,{51,23,14}},{3,{36,12,12},8,{37,13,12}}},{{2,{116,92,12},2,{117,93,12}},{6,{58,36,11},2,{59,37,11}},{4,{46,20,13},6,{47,21,13}},{7,{42,14,14},4,{43,15,14}}},{{4,{133,107,13}},{8,{59,37,11},1,{60,38,11}},{8,{44,20,12},4,{45,21,12}},{12,{33,11,11},4,{34,12,11}}},{{3,{145,115,15},1,{146,116,15}},{4,{64,40,12},5,{65,41,12}},{11,{36,16,10},5,{37,17,10}},{11,{36,12,12},5,{37,13,12}}},{{5,{109,87,11},1,{110,88,11}},{5,{65,41,12},5,{66,42,12}},{5,{54,24,15},7,{55,25,15}},{11,{36,12,12},7,{37,13,12}}},{{5,{122,98,12},1,{123,99,12}},{7,{73,45,14},3,{74,46,14}},{15,{43,19,12},2,{44,20,12}},{3,{45,15,15},13,{46,16,15}}},{{1,{135,107,14},5,{136,108,14}},{10,{74,46,14},1,{75,47,14}},{1,{50,22,14},15,{51,23,14}},{2,{42,14,14},17,{43,15,14}}},{{5,{150,120,15},1,{151,121,15}},{9,{69,43,13},4,{70,44,13}},{17,{50,22,14},1,{51,23,14}},{2,{42,14,14},19,{43,15,14}}},{{3,{141,113,14},4,{142,114,14}},{3,{70,44,13},11,{71,45,13}},{17,{47,21,13},4,{48,22,13}},{9,{39,13,13},16,{40,14,13}}},{{3,{135,107,14},5,{136,108,14}},{3,{67,41,13},13,{68,42,13}},{15,{54,24,15},5,{55,25,15}},{15,{43,15,14},10,{44,16,14}}},{{4,{144,116,14},4,{145,117,14}},{17,{68,42,13}},{17,{50,22,14},6,{51,23,14}},{19,{46,16,15},6,{47,17,15}}},{{2,{139,111,14},7,{140,112,14}},{17,{74,46,14}},{7,{54,24,15},16,{55,25,15}},{34,{37,13,12}}},{{4,{151,121,15},5,{152,122,15}},{4,{75,47,14},14,{76,48,14}},{11,{54,24,15},14,{55,25,15}},{16,{45,15,15},14,{46,16,15}}},{{6,{147,117,15},4,{148,118,15}},{6,{73,45,14},14,{74,46,14}},{11,{54,24,15},16,{55,25,15}},{30,{46,16,15},2,{47,17,15}}},{{8,{132,106,13},4,{133,107,13}},{8,{75,47,14},13,{76,48,14}},{7,{54,24,15},22,{55,25,15}},{22,{45,15,15},13,{46,16,15}}},{{10,{142,114,14},2,{143,115,14}},{19,{74,46,14},4,{75,47,14}},{28,{50,22,14},6,{51,23,14}},{33,{46,16,15},4,{47,17,15}}},{{8,{152,122,15},4,{153,123,15}},{22,{73,45,14},3,{74,46,14}},{8,{53,23,15},26,{54,24,15}},{12,{45,15,15},28,{46,16,15}}},{{3,{147,117,15},10,{148,118,15}},{3,{73,45,14},23,{74,46,14}},{4,{54,24,15},31,{55,25,15}},{11,{45,15,15},31,{46,16,15}}},{{7,{146,116,15},7,{147,117,15}},{21,{73,45,14},7,{74,46,14}},{1,{53,23,15},37,{54,24,15}},{19,{45,15,15},26,{46,16,15}}},{{5,{145,115,15},10,{146,116,15}},{19,{75,47,14},10,{76,48,14}},{15,{54,24,15},25,{55,25,15}},{23,{45,15,15},25,{46,16,15}}},{{13,{145,115,15},3,{146,116,15}},{2,{74,46,14},29,{75,47,14}},{42,{54,24,15},1,{55,25,15}},{23,{45,15,15},28,{46,16,15}}},{{17,{145,115,15}},{10,{74,46,14},23,{75,47,14}},{10,{54,24,15},35,{55,25,15}},{19,{45,15,15},35,{46,16,15}}},{{17,{145,115,15},1,{146,116,15}},{14,{74,46,14},21,{75,47,14}},{29,{54,24,15},19,{55,25,15}},{11,{45,15,15},46,{46,16,15}}},{{13,{145,115,15},6,{146,116,15}},{14,{74,46,14},23,{75,47,14}},{44,{54,24,15},7,{55,25,15}},{59,{46,16,15},1,{47,17,15}}},{{12,{151,121,15},7,{152,122,15}},{12,{75,47,14},26,{76,48,14}},{39,{54,24,15},14,{55,25,15}},{22,{45,15,15},41,{46,16,15}}},{{6,{151,121,15},14,{152,122,15}},{6,{75,47,14},34,{76,48,14}},{46,{54,24,15},10,{55,25,15}},{2,{45,15,15},64,{46,16,15}}},{{17,{152,122,15},4,{153,123,15}},{29,{74,46,14},14,{75,47,14}},{49,{54,24,15},10,{55,25,15}},{24,{45,15,15},46,{46,16,15}}},{{4,{152,122,15},18,{153,123,15}},{13,{74,46,14},32,{75,47,14}},{48,{54,24,15},14,{55,25,15}},{42,{45,15,15},32,{46,16,15}}},{{20,{147,117,15},4,{148,118,15}},{40,{75,47,14},7,{76,48,14}},{43,{54,24,15},22,{55,25,15}},{10,{45,15,15},67,{46,16,15}}},{{19,{148,118,15},6,{149,119,15}},{18,{75,47,14},31,{76,48,14}},{34,{54,24,15},34,{55,25,15}},{20,{45,15,15},61,{46,16,15}}}}local aq={0,7,7,7,7,7,0,0,0,0,0,0,0,3,3,3,3,3,3,3,4,4,4,4,4,4,4,3,3,3,3,3,3,3,0,0,0,0,0,0}local function ar(N,M,_)if type(_)=="table"then local aj=""for g=1,#_ do aj=aj..l(_[g],8)end;_=aj end;local as=ap[N][M]local at,au;local av={}local ap={}local aw=1;local ax=0;local ay=0;for g=1,#as/2 do for az=1,as[2*g-1]do at=as[2*g][2]au=as[2*g][1]-as[2*g][2]ay=ay+au*8;av[#av+1]=string.sub(_,ax*8+1,(ax+at)*8)tmp_tab=ah(av[#av],au)tmp_str=""for m=1,#tmp_tab do tmp_str=tmp_str..l(tmp_tab[m],8)end;ap[#ap+1]=tmp_str;ax=ax+at;aw=aw+1 end end;local aA=""ax=1;repeat for g=1,#av do if ax<#av[g]then aA=aA..string.sub(av[g],ax,ax+7)end end;ax=ax+8 until#aA==#_;local aB=""ax=1;repeat for g=1,#ap do if ax<#ap[g]then aB=aB..string.sub(ap[g],ax,ax+7)end end;ax=ax+8 until#aB==ay;return aA..aB end;local function aC(aD)local size=#aD;for g=1,8 do for az=1,8 do aD[g][az]=-2;aD[size-8+g][az]=-2;aD[g][size-8+az]=-2 end end;for g=1,7 do aD[1][g]=2;aD[7][g]=2;aD[g][1]=2;aD[g][7]=2;aD[size][g]=2;aD[size-6][g]=2;aD[size-g+1][1]=2;aD[size-g+1][7]=2;aD[1][size-g+1]=2;aD[7][size-g+1]=2;aD[g][size-6]=2;aD[g][size]=2 end;for g=1,3 do for az=1,3 do aD[2+az][g+2]=2;aD[size-az-1][g+2]=2;aD[2+az][size-g-1]=2 end end end;local function aE(aD)local aF,aG;aF=7;aG=9;for g=aG,#aD-8 do if math.fmod(g,2)==1 then aD[g][aF]=2 else aD[g][aF]=-2 end end;for g=aG,#aD-8 do if math.fmod(g,2)==1 then aD[aF][g]=2 else aD[aF][g]=-2 end end end;local aH={{},{6,18},{6,22},{6,26},{6,30},{6,34},{6,22,38},{6,24,42},{6,26,46},{6,28,50},{6,30,54},{6,32,58},{6,34,62},{6,26,46,66},{6,26,48,70},{6,26,50,74},{6,30,54,78},{6,30,56,82},{6,30,58,86},{6,34,62,90},{6,28,50,72,94},{6,26,50,74,98},{6,30,54,78,102},{6,28,54,80,106},{6,32,58,84,110},{6,30,58,86,114},{6,34,62,90,118},{6,26,50,74,98,122},{6,30,54,78,102,126},{6,26,52,78,104,130},{6,30,56,82,108,134},{6,34,60,86,112,138},{6,30,58,86,114,142},{6,34,62,90,118,146},{6,30,54,78,102,126,150},{6,24,50,76,102,128,154},{6,28,54,80,106,132,158},{6,32,58,84,110,136,162},{6,26,54,82,110,138,166},{6,30,58,86,114,142,170}}local function aI(aD)local N=(#aD-17)/4;local aJ=aH[N]local aK,aL;for m=1,#aJ do for w=1,#aJ do if not(m==1 and w==1 or m==#aJ and w==1 or m==1 and w==#aJ)then aK=aJ[m]+1;aL=aJ[w]+1;aD[aK][aL]=2;aD[aK+1][aL]=-2;aD[aK-1][aL]=-2;aD[aK+2][aL]=2;aD[aK-2][aL]=2;aD[aK][aL-2]=2;aD[aK+1][aL-2]=2;aD[aK-1][aL-2]=2;aD[aK+2][aL-2]=2;aD[aK-2][aL-2]=2;aD[aK][aL+2]=2;aD[aK+1][aL+2]=2;aD[aK-1][aL+2]=2;aD[aK+2][aL+2]=2;aD[aK-2][aL+2]=2;aD[aK][aL-1]=-2;aD[aK+1][aL-1]=-2;aD[aK-1][aL-1]=-2;aD[aK+2][aL-1]=2;aD[aK-2][aL-1]=2;aD[aK][aL+1]=-2;aD[aK+1][aL+1]=-2;aD[aK-1][aL+1]=-2;aD[aK+2][aL+1]=2;aD[aK-2][aL+1]=2 end end end end;local aM={{[-1]="111111111111111",[0]="111011111000100","111001011110011","111110110101010","111100010011101","110011000101111","110001100011000","110110001000001","110100101110110"},{[-1]="111111111111111",[0]="101010000010010","101000100100101","101111001111100","101101101001011","100010111111001","100000011001110","100111110010111","100101010100000"},{[-1]="111111111111111",[0]="011010101011111","011000001101000","011111100110001","011101000000110","010010010110100","010000110000011","010111011011010","010101111101101"},{[-1]="111111111111111",[0]="001011010001001","001001110111110","001110011100111","001100111010000","000011101100010","000001001010101","000110100001100","000100000111011"}}local function aN(u,M,aO)local aP=aM[M][aO]local aQ;for g=1,7 do aQ=string.sub(aP,g,g)t(u,aQ,9,#u-g+1)end;for g=8,9 do aQ=string.sub(aP,g,g)t(u,aQ,9,17-g)end;for g=10,15 do aQ=string.sub(aP,g,g)t(u,aQ,9,16-g)end;for g=1,6 do aQ=string.sub(aP,g,g)t(u,aQ,g,9)end;aQ=string.sub(aP,7,7)t(u,aQ,8,9)for g=8,15 do aQ=string.sub(aP,g,g)t(u,aQ,#u-15+g,9)end end;local aR={"001010010011111000","000111101101000100","100110010101100100","011001011001010100","011011111101110100","001000110111001100","111000100001101100","010110000011011100","000101001001111100","000111101101000010","010111010001100010","111010000101010010","001001100101110010","011001011001001010","011000001011101010","100100110001011010","000110111111111010","001000110111000110","000100001111100110","110101011111010110","000001110001110110","010110000011001110","001111110011101110","101011101011011110","000000101001111110","101010111001000001","000001111011100001","010111010001010001","011111001111110001","110100001101001001","001110100001101001","001001100101011001","010000010101111001","100101100011000101"}local function aS(u,N)if N<7 then return end;local size=#u;local v=aR[N-6]local m,w,aQ;local aT,aU;aT=#u-10;aU=1;for g=1,#v do aQ=string.sub(v,g,g)m=aT+math.fmod(g-1,3)w=aU+math.floor((g-1)/3)t(u,aQ,m,w)end;aT=1;aU=#u-10;for g=1,#v do aQ=string.sub(v,g,g)m=aT+math.floor((g-1)/3)w=aU+math.fmod(g-1,3)t(u,aQ,m,w)end end;local function aV(N,M,aO)local size;local aD={}size=N*4+17;for g=1,size do aD[g]={}for az=1,size do aD[g][az]=0 end end;aC(aD)aE(aD)aS(aD,N)aD[9][size-7]=2;aI(aD)aN(aD,M,aO)return aD end;local function aW(aO,m,w,aX)m=m-1;w=w-1;local aY=false;if aO==-1 then elseif aO==0 then if math.fmod(m+w,2)==0 then aY=true end elseif aO==1 then if math.fmod(w,2)==0 then aY=true end elseif aO==2 then if math.fmod(m,3)==0 then aY=true end elseif aO==3 then if math.fmod(m+w,3)==0 then aY=true end elseif aO==4 then if math.fmod(math.floor(w/2)+math.floor(m/3),2)==0 then aY=true end elseif aO==5 then if math.fmod(m*w,2)+math.fmod(m*w,3)==0 then aY=true end elseif aO==6 then if math.fmod(math.fmod(m*w,2)+math.fmod(m*w,3),2)==0 then aY=true end elseif aO==7 then if math.fmod(math.fmod(m*w,3)+math.fmod(m+w,2),2)==0 then aY=true end else assert(false,"This can't happen (mask must be <= 7)")end;if aY then return 1-2*tonumber(aX)else return-1+2*tonumber(aX)end end;local function aZ(u,m,w,a_,b0)local s={}local aw=1;local z="right"while aw<=#b0 do if z=="right"and u[m][w]==0 then s[#s+1]={m,w}z="left"aw=aw+1 elseif z=="left"and u[m-1][w]==0 then s[#s+1]={m-1,w}z="right"aw=aw+1;if a_=="up"then w=w-1 else w=w+1 end elseif z=="right"and u[m-1][w]==0 then s[#s+1]={m-1,w}aw=aw+1;if a_=="up"then w=w-1 else w=w+1 end else if a_=="up"then w=w-1 else w=w+1 end end;if w<1 or w>#u then m=m-2;if m==7 then m=6 end;if a_=="up"then a_="down"w=1 else a_="up"w=#u end end end;return s,m,w,a_ end;local function b1(u,_,aO)size=#u;local m,w,b2;local b3,b4,i;local a_="up"local b5=0;m,w=size,size;string.gsub(_,".?.?.?.?.?.?.?.?",function(b0)b5=b5+1;b2,m,w,a_=aZ(u,m,w,a_,b0,aO)for g=1,#b0 do b3=b2[g][1]b4=b2[g][2]i=aW(aO,b3,b4,string.sub(b0,g,g))if debugging then u[b3][b4]=i*(g+10)else u[b3][b4]=i end end end)end;local function b6(u)local b7,b8,b9,ba=0,0,0,0;local size=#u;local bb=0;local bc;local bd;local be;for m=1,size do be=0;bc=nil;for w=1,size do if u[m][w]>0 then bb=bb+1;bd=false else bd=true end;bd=u[m][w]<0;if bc==bd then be=be+1 else if be>=5 then b7=b7+be-2 end;be=1 end;bc=bd end;if be>=5 then b7=b7+be-2 end end;for w=1,size do be=0;bc=nil;for m=1,size do bd=u[m][w]<0;if bc==bd then be=be+1 else if be>=5 then b7=b7+be-2 end;be=1 end;bc=bd end;if be>=5 then b7=b7+be-2 end end;for m=1,size do for w=1,size do if w<size-1 and m<size-1 and(u[m][w]<0 and u[m+1][w]<0 and u[m][w+1]<0 and u[m+1][w+1]<0 or u[m][w]>0 and u[m+1][w]>0 and u[m][w+1]>0 and u[m+1][w+1]>0)then b8=b8+3 end;if w+6<size and u[m][w]>0 and u[m][w+1]<0 and u[m][w+2]>0 and u[m][w+3]>0 and u[m][w+4]>0 and u[m][w+5]<0 and u[m][w+6]>0 and(w+10<size and u[m][w+7]<0 and u[m][w+8]<0 and u[m][w+9]<0 and u[m][w+10]<0 or w-4>=1 and u[m][w-1]<0 and u[m][w-2]<0 and u[m][w-3]<0 and u[m][w-4]<0)then b9=b9+40 end;if m+6<=size and u[m][w]>0 and u[m+1][w]<0 and u[m+2][w]>0 and u[m+3][w]>0 and u[m+4][w]>0 and u[m+5][w]<0 and u[m+6][w]>0 and(m+10<=size and u[m+7][w]<0 and u[m+8][w]<0 and u[m+9][w]<0 and u[m+10][w]<0 or m-4>=1 and u[m-1][w]<0 and u[m-2][w]<0 and u[m-3][w]<0 and u[m-4][w]<0)then b9=b9+40 end end end;local bf=bb/(size*size)ba=math.floor(math.abs(bf*100-50))*2;return b7+b8+b9+ba end;local function bg(N,M,_,aO)local J=aV(N,M,aO)b1(J,_,aO)local bh=b6(J)return J,bh end;local function bi(N,M,_)local J,bh;local bj,bk;bj,bk=bg(N,M,_,0)for g=1,7 do J,bh=bg(N,M,_,g)if bh<bk then bj=J;bk=bh end end;return bj end;local function bl(y,M,z)local aA,N,M,bm,z,bn;N,M,bm,z,bn=P(y)bm=bm..bn;bm=bm..Y(y,z)bm=Z(N,M,bm)aA=ar(N,M,bm)if math.fmod(#aA,8)~=0 then return false,string.format("Arranged data %% 8 != 0: data length = %d, mod 8 = %d",#aA,math.fmod(#aA,8))end;aA=aA..string.rep("0",aq[N])local J=bi(N,M,aA)return true,J end;if testing then return{encode_string_numeric=S,encode_string_ascii=U,qrcode=bl,binary=l,get_mode=x,get_length=O,add_pad_data=Z,get_generator_polynominal_adjusted=a8,get_pixel_with_mask=aW,get_version_eclevel_mode_bistringlength=P,remainder=aq,arrange_codewords_and_calculate_ec=ar,calculate_error_correction=ah,convert_bitstring_to_bytes=a6,bit_xor=h}end;return{qrcode=bl}
end
local qrencode = qrencodefunction().qrcode

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
	},
	leftRightJump = {
		text = "Left/Right Jump",
		value = 10,
		minValue = 1,
		maxValue = 15
	},
	groupInstalledApps = {
		text = "Group installed apps",
		value = true
	}
}
local config_backup = {}

local parsedApplist = {}
local installed = {}
local blacklistedApps = {}

local remVer = nil
local locVer = nil
local canUpdate = nil

local imageCache = {}
local mtimeCache = {}

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
	Functions to save and load any table to or from
	a JSON encoded file somewhere on the SD card
]]--
function saveTable(filename, tbl)
	if not tbl then tbl = {} end
	if not filename then filename = APP_DIR.."/tbl.json" end
	local jsonString = json.encode(tbl, { indent = true })
	local currentPath = ""
	local splitPath = filename:split("/")
	for i = 1, #splitPath - 1 do
		if splitPath[i] then
			currentPath = currentPath.."/"..splitPath[i]
			System.createDirectory(currentPath)
		end
	end
	local file = io.open(filename, FCREATE)
	io.write(file, 0, jsonString, jsonString:len())
	io.close(file)
end
function loadTable(filename, defaulttbl)
	if not filename then filename = APP_DIR.."/tbl.json" end
	if not defaulttbl then defaulttbl = {} end
	if not System.doesFileExist(filename) then
		saveTable(filename, defaulttbl)
	end
	local file = io.open(filename, FREAD)
	
	local filesize = 0
	filesize = tonumber(io.size(file))
	if filesize == 0 then
		io.close(file)
		saveTable(filename, defaulttbl)
		file = io.open(filename, FREAD)
	end
	
	local file_contents = io.read(file, 0, tonumber(io.size(file)))
	io.close(file)
	local loaded_config = json.decode(file_contents)
	if type(loaded_config) == "table" then
		return loaded_config
	else
		return nil
	end
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
	saveTable(APP_CONFIG, config)
end
function loadConfig()
	local loaded_config = loadTable(APP_CONFIG, config)
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

--[[
	Take a Title ID and generate a
	Download QR Code Image for it
]]--
function drawQRToTopScreen(tid)
	local multiplier = 7
	local offset_x, offset_y = 75, 5
	local screen = TOP_SCREEN
	local function drawSquare(a,b,color)
		local x, y = (a + 1) * multiplier, (b + 1) * multiplier
		for i = 0, multiplier do
			for j = 0, multiplier do
				Screen.drawPixel(x + i + offset_x, y + j + offset_y, color, screen)
			end
		end
	end
	oldpad = pad
	local ok, data = qrencode(API_URL.."v0/proxy/"..tid)
	if ok then
		local qr = Screen.createImage((#data[1]+4) * multiplier, (#data+4) * multiplier, WHITE)
		Screen.drawImage(offset_x,offset_y,qr,screen)
		local color = WHITE
		for k,v in pairs(data) do
			for a,b in pairs(v) do
				if b < 0 then color = WHITE
				elseif b > 0 then color = Color.new(0,0,0) end
				drawSquare(k, a, color)
			end
		end
		while true do
			pad = Controls.read()
			if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
				Screen.freeImage(qr)
				main()
			elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
				Screen.freeImage(qr)
				main()
			elseif Controls.check(pad, KEY_X) and not Controls.check(oldpad, KEY_X) then
				Screen.freeImage(qr)
				main()
			elseif Controls.check(pad, KEY_Y) and not Controls.check(oldpad, KEY_Y) then
				Screen.freeImage(qr)
				main()
			end
			oldpad = pad
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
	Return the install state of an application
	All values come from
	INSTALLED_STATE =
	{
		VERSION_UNKNOWN,
		OUTDATED_VERSION,
		LATEST_VERSION,
		NOT_INSTALLED
	}
]]--
function getInstalledState(tid)
	local title = getTitleByID(tid)
	if installed[title.titleid] and not mtimeCache[title.titleid] then
		return INSTALLED_STATE.VERSION_UNKNOWN
	elseif installed[title.titleid] and mtimeCache[title.titleid] < title.mtime then
		return INSTALLED_STATE.OUTDATED_VERSION
	elseif installed[title.titleid] and mtimeCache[title.titleid] >= title.mtime then
		return INSTALLED_STATE.LATEST_VERSION
	end
	return INSTALLED_STATE.NOT_INSTALLED
end

--[[
	Sort app list with selected sorting mode
	and then group them by install state if
	the config option is enabled
]]
function sortAppList()
	table.sort(parsedApplist, sortModes[sortMode].sortFunction)
	if config.groupInstalledApps.value then
		local appsByState = {}
		local iS = INSTALLED_STATE.NOT_INSTALLED
		for k,v in pairs(parsedApplist) do
			iS = getInstalledState(v.titleid)
			if not appsByState[iS] then appsByState[iS] = {} end
			table.insert(appsByState[iS], v)
		end
		local tbl = {}
		for k,v in pairs(appsByState) do
			for i,j in pairs(v) do
				table.insert(tbl, j)
			end
		end
		parsedApplist = tbl
	end
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
				mtimeCache[title.titleid] = title.mtime
				saveTable(APP_DIR.."/mtime.json", mtimeCache)
				Screen.debugPrint(5, 180, "Press A to launch the title", WHITE, BOTTOM_SCREEN)
			else
				mtimeCache[title.titleid] = title.mtime
				saveTable(APP_DIR.."/mtime.json", mtimeCache)
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
			Screen.debugPrint(5, 210, "Press Start to go to "..home, WHITE, BOTTOM_SCREEN)
			
			while true do
				pad = Controls.read()
				if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
					oldpad = pad
					if System.checkBuild() == 1 then launchByTitleId(parsedApplist[selectedCIA].titleid) end
				elseif Controls.check(pad, KEY_START) and not Controls.check(oldpad, KEY_START) then
					System.exit()
				elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
					oldpad = pad
					main()
				end
				oldpad = pad
			end
		else
			Screen.debugPrint(270, line, "[FAILED]", RED, TOP_SCREEN)
			Screen.debugPrint(5, 195, "Press B to go to title list", WHITE, BOTTOM_SCREEN)
			Screen.debugPrint(5, 210, "Press Start to go to "..home, WHITE, BOTTOM_SCREEN)
			
			while true do
				pad = Controls.read()
				if Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
					oldpad = pad
					main()
				elseif Controls.check(pad, KEY_START) and not Controls.check(oldpad, KEY_START) then
					System.exit()
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
			sortAppList()
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

function markAsLatest()
	oldpad = pad
	Screen.waitVblankStart()
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "Marking all installed Apps as latest...", WHITE, TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	Screen.flip()
	
	for k,v in pairs(checkInstalled()) do
		if v and not mtimeCache[k] then
			mtimeCache[k] = getTitleByID(k).mtime
		end
	end
	saveTable(APP_DIR.."/mtime.json", mtimeCache)
	Screen.debugPrint(5, 20, "Done! Press A to continue.", WHITE, TOP_SCREEN)
	
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			menu()
		end
		oldpad = pad
	end
end

function menu()
	local menu_options = {
		{
			text = "Settings",
			callback = function() optionsMenu() end
		},
		{
			text = "Mark unknown versions as latest",
			callback = function() markAsLatest() end
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
		if #title.author < 24 then
			Screen.debugPrint(58, 20, "by "..title.author, WHITE, BOTTOM_SCREEN)
		else
			Screen.debugPrint(58, 20, "by "..title.author:sub(1, 24), WHITE, BOTTOM_SCREEN)
			Screen.debugPrint(58, 35, title.author:sub(25), WHITE, BOTTOM_SCREEN)
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
		local installedState = getInstalledState(title.titleid)
		if installedState == INSTALLED_STATE.VERSION_UNKNOWN then
			Screen.debugPrint(5, 145, "Version unknown! Install to fix this.", YELLOW, BOTTOM_SCREEN)
		elseif installedState == INSTALLED_STATE.OUTDATED_VERSION then
			Screen.debugPrint(5, 145, "App Update available!", RED, BOTTOM_SCREEN)
		elseif installedState == INSTALLED_STATE.LATEST_VERSION then
			Screen.debugPrint(5, 145, "Latest version installed!", GREEN, BOTTOM_SCREEN)
		end
		
		if System.checkBuild() == 1 and installedState ~= INSTALLED_STATE.NOT_INSTALLED then Screen.debugPrint(5, 160, "Press X to start app", GREEN, BOTTOM_SCREEN) end
		
		Screen.debugPrint(5, 180, "Press Y to show QR Code", WHITE, BOTTOM_SCREEN)
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
			local installedState = getInstalledState(title.titleid)
			if installedState == INSTALLED_STATE.VERSION_UNKNOWN then
				color = YELLOW
			elseif installedState == INSTALLED_STATE.OUTDATED_VERSION then
				color = RED
			elseif installedState == INSTALLED_STATE.LATEST_VERSION then
				color = GREEN
			end
			if selection == i then
				color = BLUE
			end
			Screen.debugPrint(15, (i * 15) + 5, title.name, color, TOP_SCREEN)
			Screen.debugPrint(5, (selection * 15) + 5, ">", BLUE, TOP_SCREEN)
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
		elseif Controls.check(pad, KEY_DRIGHT) and not Controls.check(oldpad, KEY_DRIGHT) then
			selectedCIA = selectedCIA + config.leftRightJump.value
			selection = selection + config.leftRightJump.value
			if (selectedCIA > #parsedApplist) then
				selectedCIA = 1
				menuOffset = 0
				selection = 1
			end
			if selection > screenHeightVar then
				menuOffset = menuOffset + (selection - screenHeightVar)
				selection = screenHeightVar
			end
		elseif Controls.check(pad, KEY_DLEFT) and not Controls.check(oldpad, KEY_DLEFT) then
			selectedCIA = selectedCIA - config.leftRightJump.value
			selection = selection - config.leftRightJump.value
			if (selectedCIA < 1) then
				selectedCIA = #parsedApplist
				selection = screenHeightVar
				menuOffset = #parsedApplist - screenHeightVar
			end
			if selection < 1 then
				menuOffset = menuOffset + (selection - 1)
				if menuOffset < 0 then
					menuOffset = 0
				end
				selection = 1
			end
		elseif Controls.check(pad, KEY_L) and not Controls.check(oldpad, KEY_L) then
			sortMode = sortMode - 1
			if sortMode < 1 then sortMode = #sortModes end
			sortAppList()
		elseif Controls.check(pad, KEY_R) and not Controls.check(oldpad, KEY_R) then
			sortMode = sortMode + 1
			if sortMode > #sortModes then sortMode = 1 end
			sortAppList()
		elseif Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			oldpad = pad
			downloadAndInstall(parsedApplist[selectedCIA].titleid)
		elseif Controls.check(pad, KEY_X) and not Controls.check(oldpad, KEY_X) and getInstalledState(parsedApplist[selectedCIA].titleid) ~= INSTALLED_STATE.NOT_INSTALLED and System.checkBuild() == 1 then
			oldpad = pad
			launchByTitleId(parsedApplist[selectedCIA].titleid)
		elseif Controls.check(pad, KEY_Y) and not Controls.check(oldpad, KEY_Y) then
			drawQRToTopScreen(parsedApplist[selectedCIA].titleid)
		elseif Controls.check(pad, KEY_START) and not Controls.check(oldpad, KEY_START) then
			oldpad = pad
			menu()
		elseif Controls.check(pad, KEY_SELECT) and not Controls.check(oldpad, KEY_SELECT) then
			System.exit()
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
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 65
	Screen.debugPrint(5, line, "Retrieving Homebr3w info...", WHITE, TOP_SCREEN)
	tries = 0
	success, tbl = false, {}
	while (tries < config.downloadRetryCount.value) and (not success) do
		tries = tries + 1
		success, tbl = getJSON("https://raw.githubusercontent.com/Wolvan/Homebr3w/master/data/blacklist.json")
	end
	
	if not success then
		blacklistedApps = nil
		Screen.debugPrint(270, line, "[FAILED]", RED, TOP_SCREEN)
	else
		blacklistedApps = tbl.blacklisted
		saveTable(APP_DIR.."/blacklist.json", blacklistedApps)
		Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	end
	
	line = 80
	Screen.debugPrint(5, line, "Checking for Updates...", WHITE, TOP_SCREEN)
	if config.enableUpdateCheck.value then
		tries = 0
		success, tbl = false, {}
		while (tries < config.downloadRetryCount.value) and (not success) do
			tries = tries + 1
			success, tbl = getJSON("https://api.github.com/repos/Wolvan/Homebr3w/releases/latest")
		end
		
		if not success then
			Screen.debugPrint(270, line, "[FAILED]", RED, TOP_SCREEN)
		else
			locVer = parseVersion(APP_VERSION)
			remVer = parseVersion(tbl.tag_name)
			canUpdate = isUpdateAvailable(locVer, remVer)
			Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
		end
	else
		Screen.debugPrint(270, line, "[SKIPPED]", YELLOW, TOP_SCREEN)
	end
	
	line = 95
	Screen.debugPrint(5, line, "Checking cache...", WHITE, TOP_SCREEN)
	checkCache(parsedApplist)
	if not blacklistedApps then
		local loadedBlacklist = loadTable(APP_DIR.."/blacklist.json", {})
		if loadedBlacklist then blacklistedApps = loadedBlacklist 
		else blacklistedApps = {} end
	end
	mtimeCache = loadTable(APP_DIR.."/mtime.json", {}) or {}
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 110
	Screen.debugPrint(5, line, "Checking installed CIAs...", WHITE, TOP_SCREEN)
	installed = checkInstalled()
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 125
	Screen.debugPrint(5, line, "Finishing init process...", WHITE, TOP_SCREEN)
	parsedApplist = table.filter(parsedApplist, function (item)
		for k,v in pairs(blacklistedApps) do
			if item.titleid == v then
				return false
			end
		end
		return true
	end)
	if not parsedApplist[1] then table.remove(parsedApplist, 1) end
	sortAppList()
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	main()
end

-- END MAIN PROGRAM CODE
init()
