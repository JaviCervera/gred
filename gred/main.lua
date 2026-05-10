local _hx_hidden = {__id__=true, hx__closures=true, super=true, prototype=true, __fields__=true, __ifields__=true, __class__=true, __properties__=true, __fields__=true, __name__=true}

_hx_array_mt = {
    __newindex = function(t,k,v)
        local len = t.length
        t.length =  k >= len and (k + 1) or len
        rawset(t,k,v)
    end
}

function _hx_is_array(o)
    return type(o) == "table"
        and o.__enum__ == nil
        and getmetatable(o) == _hx_array_mt
end



function _hx_tab_array(tab, length)
    tab.length = length
    return setmetatable(tab, _hx_array_mt)
end



function _hx_print_class(obj, depth)
    local first = true
    local result = ''
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            if first then
                first = false
            else
                result = result .. ', '
            end
            if _hx_hidden[k] == nil then
                result = result .. k .. ':' .. _hx_tostring(v, depth+1)
            end
        end
    end
    return '{ ' .. result .. ' }'
end

function _hx_print_enum(o, depth)
    if o.length == 2 then
        return o[0]
    else
        local str = o[0] .. "("
        for i = 2, (o.length-1) do
            if i ~= 2 then
                str = str .. "," .. _hx_tostring(o[i], depth+1)
            else
                str = str .. _hx_tostring(o[i], depth+1)
            end
        end
        return str .. ")"
    end
end

function _hx_tostring(obj, depth)
    if depth == nil then
        depth = 0
    elseif depth > 5 then
        return "<...>"
    end

    local tstr = _G.type(obj)
    if tstr == "string" then return obj
    elseif tstr == "nil" then return "null"
    elseif tstr == "number" then
        if obj == _G.math.POSITIVE_INFINITY then return "Infinity"
        elseif obj == _G.math.NEGATIVE_INFINITY then return "-Infinity"
        elseif obj == 0 then return "0"
        elseif obj ~= obj then return "NaN"
        else return _G.tostring(obj)
        end
    elseif tstr == "boolean" then return _G.tostring(obj)
    elseif tstr == "userdata" then
        local mt = _G.getmetatable(obj)
        if mt ~= nil and mt.__tostring ~= nil then
            return _G.tostring(obj)
        else
            return "<userdata>"
        end
    elseif tstr == "function" then return "<function>"
    elseif tstr == "thread" then return "<thread>"
    elseif tstr == "table" then
        if obj.__enum__ ~= nil then
            return _hx_print_enum(obj, depth)
        elseif obj.toString ~= nil and not _hx_is_array(obj) then return obj:toString()
        elseif _hx_is_array(obj) then
            if obj.length > 5 then
                return "[...]"
            else
                local str = ""
                for i=0, (obj.length-1) do
                    if i == 0 then
                        str = str .. _hx_tostring(obj[i], depth+1)
                    else
                        str = str .. "," .. _hx_tostring(obj[i], depth+1)
                    end
                end
                return "[" .. str .. "]"
            end
        elseif obj.__class__ ~= nil then
            return _hx_print_class(obj, depth)
        else
            local buffer = {}
            local ref = obj
            if obj.__fields__ ~= nil then
                ref = obj.__fields__
            end
            for k,v in pairs(ref) do
                if _hx_hidden[k] == nil then
                    _G.table.insert(buffer, _hx_tostring(k, depth+1) .. ' : ' .. _hx_tostring(obj[k], depth+1))
                end
            end

            return "{ " .. table.concat(buffer, ", ") .. " }"
        end
    else
        _G.error("Unknown Lua type", 0)
        return ""
    end
end

function _hx_error(obj)
    if obj.value then
        _G.print("runtime error:\n " .. _hx_tostring(obj.value));
    else
        _G.print("runtime error:\n " .. tostring(obj));
    end

    if _G.debug and _G.debug.traceback then
        _G.print(debug.traceback());
    end
end


local function _hx_obj_newindex(t,k,v)
    t.__fields__[k] = true
    rawset(t,k,v)
end

local _hx_obj_mt = {__newindex=_hx_obj_newindex, __tostring=_hx_tostring}

local function _hx_a(...)
  local __fields__ = {};
  local ret = {__fields__ = __fields__};
  local max = select('#',...);
  local tab = {...};
  local cur = 1;
  while cur < max do
    local v = tab[cur];
    __fields__[v] = true;
    ret[v] = tab[cur+1];
    cur = cur + 2
  end
  return setmetatable(ret, _hx_obj_mt)
end

local function _hx_e()
  return setmetatable({__fields__ = {}}, _hx_obj_mt)
end

local function _hx_o(obj)
  return setmetatable(obj, _hx_obj_mt)
end

local function _hx_new(prototype)
  return setmetatable({__fields__ = {}}, {__newindex=_hx_obj_newindex, __index=prototype, __tostring=_hx_tostring})
end

function _hx_field_arr(obj)
    res = {}
    idx = 0
    if obj.__fields__ ~= nil then
        obj = obj.__fields__
    end
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            res[idx] = k
            idx = idx + 1
        end
    end
    return _hx_tab_array(res, idx)
end

local _hxClasses = {}
local Int = _hx_e();
local Dynamic = _hx_e();
local Float = _hx_e();
local Bool = _hx_e();
local Class = _hx_e();
local Enum = _hx_e();

local Array = _hx_e()
local Camera = _hx_e()
local Cursor = _hx_e()
local Flag = _hx_e()
local FlagManager = _hx_e()
local Grid = _hx_e()
local GridLoader = _hx_e()
local GridManager = _hx_e()
local GridSaver = _hx_e()
local Main = _hx_e()
local Math = _hx_e()
local MemblockReader = _hx_e()
local MemblockWriter = _hx_e()
local String = _hx_e()
local Std = _hx_e()
local TextureReader = _hx_e()
local TextureViewer = _hx_e()
local UndoManager = _hx_e()
__command_ICommand = _hx_e()
__command_PlaceFlagCommand = _hx_e()
__command_RemoveFlagCommand = _hx_e()
__command_RemoveTileCommand = _hx_e()
__command_SetTileCommand = _hx_e()
__grid_mesh_GridMeshCreator = _hx_e()
__grid_mesh_GridSurface = _hx_e()
__grid_mesh_GridVertex = _hx_e()
__grid_mesh_StairMeshCreator = _hx_e()
__haxe_IMap = _hx_e()
__haxe_ds_StringMap = _hx_e()
__haxe_iterators_ArrayIterator = _hx_e()
__haxe_iterators_ArrayKeyValueIterator = _hx_e()

local _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw
local _hx_pcall_default = {};
local _hx_pcall_break = {};

Array.new = function() 
  local self = _hx_new(Array.prototype)
  Array.super(self)
  return self
end
Array.super = function(self) 
  _hx_tab_array(self, 0);
end
Array.prototype = _hx_e();
Array.prototype.concat = function(self,a) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = self;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  local ret = _g;
  local _g = 0;
  while (_g < a.length) do 
    local i = a[_g];
    _g = _g + 1;
    ret:push(i);
  end;
  do return ret end
end
Array.prototype.join = function(self,sep) 
  local tbl = ({});
  local _g_current = 0;
  local _g_array = self;
  while (_g_current < _g_array.length) do 
    _g_current = _g_current + 1;
    local i = _g_array[_g_current - 1];
    _G.table.insert(tbl, Std.string(i));
  end;
  do return _G.table.concat(tbl, sep) end
end
Array.prototype.pop = function(self) 
  if (self.length == 0) then 
    do return nil end;
  end;
  local ret = self[self.length - 1];
  self[self.length - 1] = nil;
  self.length = self.length - 1;
  do return ret end
end
Array.prototype.push = function(self,x) 
  self[self.length] = x;
  do return self.length end
end
Array.prototype.reverse = function(self) 
  local tmp;
  local i = 0;
  while (i < Std.int(self.length / 2)) do 
    tmp = self[i];
    self[i] = self[(self.length - i) - 1];
    self[(self.length - i) - 1] = tmp;
    i = i + 1;
  end;
end
Array.prototype.shift = function(self) 
  if (self.length == 0) then 
    do return nil end;
  end;
  local ret = self[0];
  if (self.length == 1) then 
    self[0] = nil;
  else
    if (self.length > 1) then 
      self[0] = self[1];
      _G.table.remove(self, 1);
    end;
  end;
  local tmp = self;
  tmp.length = tmp.length - 1;
  do return ret end
end
Array.prototype.slice = function(self,pos,_end) 
  if ((_end == nil) or (_end > self.length)) then 
    _end = self.length;
  else
    if (_end < 0) then 
      _end = _G.math.fmod((self.length - (_G.math.fmod(-_end, self.length))), self.length);
    end;
  end;
  if (pos < 0) then 
    pos = _G.math.fmod((self.length - (_G.math.fmod(-pos, self.length))), self.length);
  end;
  if ((pos > _end) or (pos > self.length)) then 
    do return _hx_tab_array({}, 0) end;
  end;
  local ret = _hx_tab_array({}, 0);
  local _g = pos;
  local _g1 = _end;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    ret:push(self[i]);
  end;
  do return ret end
end
Array.prototype.sort = function(self,f) 
  local i = 0;
  local l = self.length;
  while (i < l) do 
    local swap = false;
    local j = 0;
    local max = (l - i) - 1;
    while (j < max) do 
      if (f(self[j], self[j + 1]) > 0) then 
        local tmp = self[j + 1];
        self[j + 1] = self[j];
        self[j] = tmp;
        swap = true;
      end;
      j = j + 1;
    end;
    if (not swap) then 
      break;
    end;
    i = i + 1;
  end;
end
Array.prototype.splice = function(self,pos,len) 
  if ((len < 0) or (pos > self.length)) then 
    do return _hx_tab_array({}, 0) end;
  else
    if (pos < 0) then 
      pos = self.length - (_G.math.fmod(-pos, self.length));
    end;
  end;
  len = Math.min(len, self.length - pos);
  local ret = _hx_tab_array({}, 0);
  local _g = pos;
  local _g1 = pos + len;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    ret:push(self[i]);
    self[i] = self[i + len];
  end;
  local _g = pos + len;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    self[i] = self[i + len];
  end;
  local tmp = self;
  tmp.length = tmp.length - len;
  do return ret end
end
Array.prototype.toString = function(self) 
  local tbl = ({});
  _G.table.insert(tbl, "[");
  _G.table.insert(tbl, self:join(","));
  _G.table.insert(tbl, "]");
  do return _G.table.concat(tbl, "") end
end
Array.prototype.unshift = function(self,x) 
  local len = self.length;
  local _g = 0;
  local _g1 = len;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    self[len - i] = self[(len - i) - 1];
  end;
  self[0] = x;
end
Array.prototype.insert = function(self,pos,x) 
  if (pos > self.length) then 
    pos = self.length;
  end;
  if (pos < 0) then 
    pos = self.length + pos;
    if (pos < 0) then 
      pos = 0;
    end;
  end;
  local cur_len = self.length;
  while (cur_len > pos) do 
    self[cur_len] = self[cur_len - 1];
    cur_len = cur_len - 1;
  end;
  self[pos] = x;
end
Array.prototype.remove = function(self,x) 
  local _g = 0;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    if (self[i] == x) then 
      local _g = i;
      local _g1 = self.length - 1;
      while (_g < _g1) do 
        _g = _g + 1;
        local j = _g - 1;
        self[j] = self[j + 1];
      end;
      self[self.length - 1] = nil;
      self.length = self.length - 1;
      do return true end;
    end;
  end;
  do return false end
end
Array.prototype.contains = function(self,x) 
  local _g = 0;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    if (self[i] == x) then 
      do return true end;
    end;
  end;
  do return false end
end
Array.prototype.indexOf = function(self,x,fromIndex) 
  local _end = self.length;
  if (fromIndex == nil) then 
    fromIndex = 0;
  else
    if (fromIndex < 0) then 
      fromIndex = self.length + fromIndex;
      if (fromIndex < 0) then 
        fromIndex = 0;
      end;
    end;
  end;
  local _g = fromIndex;
  local _g1 = _end;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    if (x == self[i]) then 
      do return i end;
    end;
  end;
  do return -1 end
end
Array.prototype.lastIndexOf = function(self,x,fromIndex) 
  if ((fromIndex == nil) or (fromIndex >= self.length)) then 
    fromIndex = self.length - 1;
  else
    if (fromIndex < 0) then 
      fromIndex = self.length + fromIndex;
      if (fromIndex < 0) then 
        do return -1 end;
      end;
    end;
  end;
  local i = fromIndex;
  while (i >= 0) do 
    if (self[i] == x) then 
      do return i end;
    else
      i = i - 1;
    end;
  end;
  do return -1 end
end
Array.prototype.copy = function(self) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = self;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  do return _g end
end
Array.prototype.map = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = self;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    _g:push(f(i));
  end;
  do return _g end
end
Array.prototype.filter = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = self;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    if (f(i)) then 
      _g:push(i);
    end;
  end;
  do return _g end
end
Array.prototype.iterator = function(self) 
  do return __haxe_iterators_ArrayIterator.new(self) end
end
Array.prototype.keyValueIterator = function(self) 
  do return __haxe_iterators_ArrayKeyValueIterator.new(self) end
end
Array.prototype.resize = function(self,len) 
  if (self.length < len) then 
    self.length = len;
  else
    if (self.length > len) then 
      local _g = len;
      local _g1 = self.length;
      while (_g < _g1) do 
        _g = _g + 1;
        local i = _g - 1;
        self[i] = nil;
      end;
      self.length = len;
    end;
  end;
end

Camera.new = function(cursor) 
  local self = _hx_new(Camera.prototype)
  Camera.super(self,cursor)
  return self
end
Camera.super = function(self,cursor) 
  self.entity = _G.CreateCamera();
  self.cursor = cursor;
  self.distance = 6;
  self.wasEditing = true;
  _G.SetCameraRange(self.entity, 0.1, 100);
end
Camera.prototype = _hx_e();
Camera.prototype.update = function(self,editing) 
  if (editing) then 
    _G.SetEntityPosition(self.entity, _G.EntityX(self.cursor.entity), _G.EntityY(self.cursor.entity), _G.EntityZ(self.cursor.entity));
    _G.MoveEntity(self.entity, 0, 0, -_G.Max(2, self.distance - _G.CursorZ()));
    _G.SetEntityRotation(self.entity, 89.9, 0, 0);
    self.wasEditing = true;
  else
    if (self.wasEditing) then 
      _G.SetEntityPosition(self.entity, _G.EntityX(self.cursor.entity), _G.EntityY(self.cursor.entity), _G.EntityZ(self.cursor.entity));
      _G.SetEntityRotation(self.entity, 0, 0, 0);
    end;
    if (_G.KeyDown(38)) then 
      _G.MoveEntity(self.entity, 0, 0, 2.0 * _G.DeltaTime());
    end;
    if (_G.KeyDown(40)) then 
      _G.MoveEntity(self.entity, 0, 0, -2. * _G.DeltaTime());
    end;
    if (_G.KeyDown(37)) then 
      _G.TurnEntity(self.entity, 0, -90. * _G.DeltaTime(), 0);
    end;
    if (_G.KeyDown(39)) then 
      _G.TurnEntity(self.entity, 0, 90.0 * _G.DeltaTime(), 0);
    end;
    if (_G.KeyDown(81)) then 
      _G.TranslateEntity(self.entity, 0, 2.0 * _G.DeltaTime(), 0);
    end;
    if (_G.KeyDown(65)) then 
      _G.TranslateEntity(self.entity, 0, -2. * _G.DeltaTime(), 0);
    end;
    self.wasEditing = false;
  end;
end

Cursor.new = function(grid) 
  local self = _hx_new(Cursor.prototype)
  Cursor.super(self,grid)
  return self
end
Cursor.super = function(self,grid) 
  self.grid = grid;
  self.alpha = 0.5;
  self.alphaDir = 1;
  local mesh = _G.CreateCubeMesh();
  self.entity = _G.CreateModel(mesh);
  _G.FreeMesh(mesh);
  local mat = _G.EntityMaterial(self.entity, 1);
  _G.SetMaterialType(mat, 6);
  _G.SetMaterialFlag(mat, 1, false);
  _G.SetMaterialFlag(mat, 64, true);
  self:reset();
end
Cursor.prototype = _hx_e();
Cursor.prototype.reset = function(self) 
  _G.SetEntityPosition(self.entity, self.grid:tilesX() / 2, self.grid:tilesY() / 2, self.grid:tilesZ() / 2);
end
Cursor.prototype.update = function(self,editing) 
  if (editing and not _G.EntityVisible(self.entity)) then 
    _G.SetEntityVisible(self.entity, true);
  end;
  if (not editing and _G.EntityVisible(self.entity)) then 
    _G.SetEntityVisible(self.entity, false);
  end;
  if (editing) then 
    local tmp = self;
    tmp.alpha = tmp.alpha + ((self.alphaDir * 0.5) * _G.DeltaTime());
    if ((self.alpha <= 0.25) or (self.alpha >= 0.75)) then 
      self.alpha = _G.Clamp(self.alpha, 0.25, 0.75);
      self.alphaDir = self.alphaDir * -1;
    end;
    _G.SetMeshColor(_G.ModelMesh(self.entity), _G.FadeColor(-23296, _G.Int(self.alpha * 255)));
    _G.UpdateMesh(_G.ModelMesh(self.entity));
    if (_G.KeyHit(38)) then 
      _G.TranslateEntity(self.entity, 0, 0, 1);
    end;
    if (_G.KeyHit(40)) then 
      _G.TranslateEntity(self.entity, 0, 0, -1);
    end;
    if (_G.KeyHit(37)) then 
      _G.TranslateEntity(self.entity, -1, 0, 0);
    end;
    if (_G.KeyHit(39)) then 
      _G.TranslateEntity(self.entity, 1, 0, 0);
    end;
    if (_G.KeyHit(81)) then 
      _G.TranslateEntity(self.entity, 0, 1, 0);
    end;
    if (_G.KeyHit(65)) then 
      _G.TranslateEntity(self.entity, 0, -1, 0);
    end;
    _G.SetEntityPosition(self.entity, _G.Clamp(_G.EntityX(self.entity), 1, self.grid:tilesX()), _G.Clamp(_G.EntityY(self.entity), 1, self.grid:tilesY()), _G.Clamp(_G.EntityZ(self.entity), 1, self.grid:tilesZ()));
  end;
end

Flag.new = function(id,x,y,z) 
  local self = _hx_new(Flag.prototype)
  Flag.super(self,id,x,y,z)
  return self
end
Flag.super = function(self,id,x,y,z) 
  self.id = id;
  self.entity = _G.CreateSprite(nil, 6);
  self.active = false;
  self:position(x, y, z);
  self:setActive(true);
end
Flag.prototype = _hx_e();
Flag.prototype.destroy = function(self) 
  _G.FreeEntity(self.entity);
end
Flag.prototype.position = function(self,x,y,z) 
  _G.SetEntityPosition(self.entity, x, y, z);
end
Flag.prototype.x = function(self) 
  do return _G.EntityX(self.entity) end
end
Flag.prototype.y = function(self) 
  do return _G.EntityY(self.entity) end
end
Flag.prototype.z = function(self) 
  do return _G.EntityZ(self.entity) end
end
Flag.prototype.setActive = function(self,active) 
  if (Flag.activeTexture == nil) then 
    Flag.activeTexture = _G.LoadTexture("icons/flag_red.png");
  end;
  if (Flag.inactiveTexture == nil) then 
    Flag.inactiveTexture = _G.LoadTexture("icons/flag_orange.png");
  end;
  if (active ~= self.active) then 
    self.active = active;
    if (active) then 
      _G.SetMaterialTexture(_G.EntityMaterial(self.entity, 1), 1, Flag.activeTexture);
    else
      _G.SetMaterialTexture(_G.EntityMaterial(self.entity, 1), 1, Flag.inactiveTexture);
    end;
  end;
end

FlagManager.new = function() 
  local self = _hx_new(FlagManager.prototype)
  FlagManager.super(self)
  return self
end
FlagManager.super = function(self) 
  self.lst = _hx_tab_array({}, 0);
  self.currentActive = nil;
end
FlagManager.prototype = _hx_e();
FlagManager.prototype.update = function(self,activeFlag) 
  if (activeFlag ~= self.currentActive) then 
    if (self.currentActive ~= nil) then 
      local flag = self:find(self.currentActive);
      if (flag ~= nil) then 
        flag:setActive(false);
      end;
      self.currentActive = nil;
    end;
    if (activeFlag ~= nil) then 
      local flag = self:find(activeFlag);
      if (flag ~= nil) then 
        flag:setActive(true);
        self.currentActive = activeFlag;
      end;
    end;
  end;
end
FlagManager.prototype.drawFlagNumbers = function(self,font,cam) 
  local _g = 0;
  local _g1 = self.lst;
  while (_g < _g1.length) do 
    local flag = _g1[_g];
    _g = _g + 1;
    _G.WorldToScreen(cam, _G.EntityX(flag.entity), _G.EntityY(flag.entity), _G.EntityZ(flag.entity));
    local label = Std.string(flag.id);
    local width = _G.TextWidth(font, label);
    local height = _G.TextHeight(font, label);
    _G.DrawRect(_G.Int(_G.PointX()), _G.Int(_G.PointY()), width, height, -16777216);
    _G.DrawText(font, label, _G.Int(_G.PointX()), _G.Int(_G.PointY()), -256);
  end;
end
FlagManager.prototype.clear = function(self) 
  local _g = 0;
  local _g1 = self.lst;
  while (_g < _g1.length) do 
    local flag = _g1[_g];
    _g = _g + 1;
    flag:destroy();
  end;
  self.lst = _hx_tab_array({}, 0);
  self.currentActive = nil;
end
FlagManager.prototype.place = function(self,flagId,x,y,z) 
  local index = self:findIndex(flagId);
  if (index == nil) then 
    self.lst:push(Flag.new(flagId, x, y, z));
    self.lst:sort(function(a,b) 
      do return a.id - b.id end;
    end);
  else
    self.lst[index]:position(x, y, z);
  end;
end
FlagManager.prototype.remove = function(self,flagId) 
  local index = self:findIndex(flagId);
  if (index == nil) then 
    do return end;
  end;
  self.lst[index]:destroy();
  self.lst:splice(index, 1);
end
FlagManager.prototype.find = function(self,flagId) 
  local index = self:findIndex(flagId);
  if (index ~= nil) then 
    do return self.lst[index] end;
  else
    do return nil end;
  end;
end
FlagManager.prototype.findIndex = function(self,flagId) 
  local _g = 0;
  local _g1 = self.lst.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    if (self.lst[i].id == flagId) then 
      do return i end;
    end;
  end;
  do return nil end
end
FlagManager.prototype.size = function(self) 
  do return self.lst.length end
end
FlagManager.prototype.at = function(self,index) 
  if ((index <= 0) or (index > self:size())) then 
    do return nil end;
  end;
  do return self.lst[index - 1] end
end

Grid.new = function(tilesX,tilesY,tilesZ,texPath) 
  local self = _hx_new(Grid.prototype)
  Grid.super(self,tilesX,tilesY,tilesZ,texPath)
  return self
end
Grid.super = function(self,tilesX,tilesY,tilesZ,texPath) 
  self.texPath = texPath;
  self.tiles = _hx_tab_array({}, 0);
  self.model = nil;
  self.filtering = true;
  self.wireframe = false;
  self:reset(tilesX, tilesY, tilesZ);
end
Grid.prototype = _hx_e();
Grid.prototype.getTexturePath = function(self) 
  do return self.texPath end
end
Grid.prototype.reset = function(self,tilesX,tilesY,tilesZ) 
  if (self.model ~= nil) then 
    _G.FreeEntity(self.model);
    self.model = nil;
  end;
  self.tiles = _hx_tab_array({}, 0);
  local _g = 0;
  local _g1 = tilesX;
  while (_g < _g1) do 
    _g = _g + 1;
    local x = _g - 1;
    self.tiles:push(_hx_tab_array({}, 0));
    local _g = 0;
    local _g1 = tilesY;
    while (_g < _g1) do 
      _g = _g + 1;
      local y = _g - 1;
      self.tiles[x]:push(_hx_tab_array({}, 0));
      local _g = 0;
      local _g1 = tilesZ;
      while (_g < _g1) do 
        _g = _g + 1;
        local z = _g - 1;
        self.tiles[x][y]:push(nil);
      end;
    end;
  end;
end
Grid.prototype.tilesX = function(self) 
  do return self.tiles.length end
end
Grid.prototype.tilesY = function(self) 
  if (self:tilesX() == 0) then 
    do return 0 end;
  end;
  do return self.tiles[0].length end
end
Grid.prototype.tilesZ = function(self) 
  if (self:tilesY() == 0) then 
    do return 0 end;
  end;
  do return self.tiles[0][0].length end
end
Grid.prototype.hasTile = function(self,x,y,z) 
  if ((x < 1) or (x > self:tilesX())) then 
    do return false end;
  end;
  if ((y < 1) or (y > self:tilesY())) then 
    do return false end;
  end;
  if ((z < 1) or (z > self:tilesZ())) then 
    do return false end;
  end;
  do return self.tiles[x - 1][y - 1][z - 1] ~= nil end
end
Grid.prototype.setTile = function(self,x,y,z,kind,ceilingTexName,wallTexName,floorTexName,updateModel) 
  if (updateModel == nil) then 
    updateModel = true;
  end;
  if ((((self:getTileType(x, y, z) ~= kind) or (self:ceilingTextureName(x, y, z) ~= ceilingTexName)) or (self:wallTextureName(x, y, z) ~= wallTexName)) or (self:floorTextureName(x, y, z) ~= floorTexName)) then 
    self.tiles[x - 1][y - 1][z - 1] = _hx_o({__fields__={kind=true,ceiling=true,wall=true,floor=true},kind=kind,ceiling=ceilingTexName,wall=wallTexName,floor=floorTexName});
    if (updateModel) then 
      self:_updateModel();
    end;
  end;
end
Grid.prototype.removeTile = function(self,x,y,z,updateModel) 
  if (updateModel == nil) then 
    updateModel = true;
  end;
  if (self:hasTile(x, y, z)) then 
    self.tiles[x - 1][y - 1][z - 1] = nil;
    if (updateModel) then 
      self:_updateModel();
    end;
  end;
end
Grid.prototype.getTileType = function(self,x,y,z) 
  if (not self:hasTile(x, y, z)) then 
    do return 0 end;
  end;
  do return self.tiles[x - 1][y - 1][z - 1].kind end
end
Grid.prototype.ceilingTextureName = function(self,x,y,z) 
  if (not self:hasTile(x, y, z)) then 
    do return "" end;
  end;
  do return self.tiles[x - 1][y - 1][z - 1].ceiling end
end
Grid.prototype.wallTextureName = function(self,x,y,z) 
  if (not self:hasTile(x, y, z)) then 
    do return "" end;
  end;
  do return self.tiles[x - 1][y - 1][z - 1].wall end
end
Grid.prototype.floorTextureName = function(self,x,y,z) 
  if (not self:hasTile(x, y, z)) then 
    do return "" end;
  end;
  do return self.tiles[x - 1][y - 1][z - 1].floor end
end
Grid.prototype._updateModel = function(self) 
  if (self.model ~= nil) then 
    _G.FreeEntity(self.model);
  end;
  local mesh = __grid_mesh_GridMeshCreator.create(self);
  self.model = _G.CreateModel(mesh);
  self:_applyFiltering();
  self:_applyWireframe();
  _G.FreeMesh(mesh);
end
Grid.prototype.toggleFiltering = function(self) 
  self.filtering = not self.filtering;
  self:_applyFiltering();
end
Grid.prototype.filteringEnabled = function(self) 
  do return self.filtering end
end
Grid.prototype._applyFiltering = function(self) 
  if (self.model == nil) then 
    do return end;
  end;
  local mode = (function() 
    local _hx_1
    if (self.filtering) then 
    _hx_1 = 3; else 
    _hx_1 = 0; end
    return _hx_1
  end )();
  local _g = 1;
  local _g1 = _G.EntityNumMaterials(self.model) + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    _G.SetMaterialFilterMode(_G.EntityMaterial(self.model, i), mode);
  end;
end
Grid.prototype.toggleWireframe = function(self) 
  if (self.model ~= nil) then 
    self.wireframe = not self.wireframe;
    self:_applyWireframe();
  end;
end
Grid.prototype.wireframeEnabled = function(self) 
  do return self.wireframe end
end
Grid.prototype._applyWireframe = function(self) 
  if (self.model == nil) then 
    do return end;
  end;
  local mode = (function() 
    local _hx_1
    if (self.wireframe) then 
    _hx_1 = 1; else 
    _hx_1 = 0; end
    return _hx_1
  end )();
  local _g = 1;
  local _g1 = _G.EntityNumMaterials(self.model) + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    _G.SetMaterialRenderMode(_G.EntityMaterial(self.model, i), mode);
  end;
end

GridLoader.new = {}
GridLoader.load = function(grid,flagMgr,filename) 
  local memblock = _G.LoadMemblock(filename);
  local reader = MemblockReader.new(memblock);
  reader:readByte();
  local tilesX = reader:readByte();
  local tilesY = reader:readByte();
  local tilesZ = reader:readByte();
  grid:reset(tilesX, tilesY, tilesZ);
  local texs = GridLoader.loadTextureNames(reader);
  local numTiles = reader:readInt();
  local _g = 0;
  local _g1 = numTiles;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    GridLoader.loadTile(grid, texs, reader);
  end;
  grid:_updateModel();
  flagMgr:clear();
  local numFlags = reader:readByte();
  local _g = 0;
  local _g1 = numFlags;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    GridLoader.loadFlag(flagMgr, reader);
  end;
  _G.FreeMemblock(memblock);
end
GridLoader.loadTextureNames = function(reader) 
  local texs = _hx_tab_array({}, 0);
  local count = reader:readByte();
  local _g = 0;
  local _g1 = count;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    texs:push(reader:readString());
  end;
  do return texs end;
end
GridLoader.loadTile = function(grid,texs,reader) 
  local x = reader:readByte();
  local y = reader:readByte();
  local z = reader:readByte();
  local kind = reader:readByte();
  local ceilingTex = texs[reader:readByte() - 1];
  local wallTex = texs[reader:readByte() - 1];
  local floorTex = texs[reader:readByte() - 1];
  grid:setTile(x, y, z, kind, ceilingTex, wallTex, floorTex, false);
end
GridLoader.loadFlag = function(flagMgr,reader) 
  local id = reader:readByte();
  local x = reader:readByte();
  local y = reader:readByte();
  local z = reader:readByte();
  flagMgr:place(id, x, y, z);
end

GridManager.new = function(grid,cursor,ceilingTexRetriever,wallTexRetriever,floorTexRetriever,flagMgr,undoMgr) 
  local self = _hx_new(GridManager.prototype)
  GridManager.super(self,grid,cursor,ceilingTexRetriever,wallTexRetriever,floorTexRetriever,flagMgr,undoMgr)
  return self
end
GridManager.super = function(self,grid,cursor,ceilingTexRetriever,wallTexRetriever,floorTexRetriever,flagMgr,undoMgr) 
  self.grid = grid;
  self.cursor = cursor;
  self.ceilingTexRetriever = ceilingTexRetriever;
  self.wallTexRetriever = wallTexRetriever;
  self.floorTexRetriever = floorTexRetriever;
  self.flagMgr = flagMgr;
  self.undoMgr = undoMgr;
  self.lights = nil;
  self:reset();
end
GridManager.prototype = _hx_e();
GridManager.prototype.reset = function(self) 
  self.filename = nil;
  self.editing = true;
  self.mode = 1;
  self.currentFlag = 1;
  self.grid:reset(self.grid:tilesX(), self.grid:tilesY(), self.grid:tilesZ());
  self.cursor:reset();
end
GridManager.prototype.update = function(self) 
  if (_G.KeyHit(13)) then 
    self.editing = not self.editing;
  end;
  if (_G.KeyHit(70)) then 
    self.grid:toggleFiltering();
  end;
  if (_G.KeyHit(76)) then 
    self:toggleLighting();
  end;
  if (_G.KeyHit(82)) then 
    self.grid:toggleWireframe();
  end;
  if (_G.KeyHit(85)) then 
    self.currentFlag = _G.Int(_G.Max(1, self.currentFlag - 1));
  end;
  if (_G.KeyHit(73)) then 
    self.currentFlag = _G.Int(_G.Min(100, self.currentFlag + 1));
  end;
  if (_G.KeyHit(80)) then 
    self:placeFlag();
  end;
  if (_G.KeyHit(79)) then 
    self:deleteFlag();
  end;
  if (self.editing) then 
    if (_G.KeyHit(112)) then 
      self:reset();
    end;
    if (_G.KeyHit(113)) then 
      local selected = _G.RequestFile("Grid filename", "*.grd", false, self.filename);
      if (selected ~= "") then 
        GridLoader.load(self.grid, self.flagMgr, selected);
        self.filename = selected;
        self.undoMgr:reset();
      end;
    end;
    if (_G.KeyHit(114)) then 
      if (self.filename == nil) then 
        local selected = _G.RequestFile("Grid filename", "*.grd", true, self.filename);
        if (selected ~= "") then 
          self.filename = selected;
        end;
      end;
      if (self.filename ~= nil) then 
        GridSaver.save(self.grid, self.flagMgr, self.filename);
      end;
    end;
    if (_G.KeyHit(115)) then 
      self.mode = self.mode + 1;
      if (self.mode > 5) then 
        self.mode = 1;
      end;
    end;
    if (_G.KeyDown(32)) then 
      self.undoMgr:addUndo(__command_SetTileCommand.new(self.grid, _G.Int(_G.EntityX(self.cursor.entity)), _G.Int(_G.EntityY(self.cursor.entity)), _G.Int(_G.EntityZ(self.cursor.entity)), self.mode, self.ceilingTexRetriever:textureName(), self.wallTexRetriever:textureName(), self.floorTexRetriever:textureName()):execute());
    end;
    if (_G.KeyDown(46)) then 
      self.undoMgr:addUndo(__command_RemoveTileCommand.new(self.grid, _G.Int(_G.EntityX(self.cursor.entity)), _G.Int(_G.EntityY(self.cursor.entity)), _G.Int(_G.EntityZ(self.cursor.entity))):execute());
    end;
  end;
end
GridManager.prototype.toggleLighting = function(self) 
  if (not self:lightingEnabled()) then 
    self.lights = _G.CreateEntity();
    _G.SetEntityParent(_G.CreateLight(0), self.lights);
    _G.SetEntityParent(_G.CreateLight(0), self.lights);
    _G.SetEntityParent(_G.CreateLight(0), self.lights);
    _G.SetEntityRotation(_G.EntityChild(self.lights, 2), 0, 180, 0);
    _G.SetEntityRotation(_G.EntityChild(self.lights, 3), 90, 0, 0);
    _G.SetAmbient(-4210753);
  else
    _G.FreeEntity(self.lights);
    _G.SetAmbient(-1);
    self.lights = nil;
  end;
end
GridManager.prototype.lightingEnabled = function(self) 
  do return self.lights ~= nil end
end
GridManager.prototype.placeFlag = function(self) 
  self.undoMgr:addUndo(__command_PlaceFlagCommand.new(self.currentFlag, _G.EntityX(self.cursor.entity), _G.EntityY(self.cursor.entity), _G.EntityZ(self.cursor.entity), self.flagMgr):execute());
end
GridManager.prototype.deleteFlag = function(self) 
  self.undoMgr:addUndo(__command_RemoveFlagCommand.new(self.currentFlag, self.flagMgr):execute());
end
GridManager.prototype.getCurrentFlag = function(self) 
  do return self.currentFlag end
end
GridManager.prototype.isEditing = function(self) 
  do return self.editing end
end
GridManager.prototype.getModeName = function(self) 
  local names = _hx_tab_array({[0]="Tile", "Stairs Forward", "Stairs Right", "Stairs Backwards", "Stairs Left"}, 5);
  if ((self.mode < 1) or (self.mode > names.length)) then 
    do return "" end;
  end;
  do return names[self.mode - 1] end
end

GridSaver.new = {}
GridSaver.save = function(grid,flagMgr,filename) 
  local texs = GridSaver.gridTextures(grid);
  local memblock = _G.CreateMemblock(GridSaver.gridMemblockSize(grid, flagMgr, texs));
  local writer = MemblockWriter.new(memblock);
  GridSaver.writeHeader(grid, writer);
  GridSaver.writeTextures(texs, writer);
  GridSaver.writeTiles(grid, texs, writer);
  GridSaver.writeFlags(flagMgr, writer);
  _G.SaveMemblock(memblock, filename);
  _G.FreeMemblock(memblock);
end
GridSaver.gridTextures = function(grid) 
  local texs = _hx_tab_array({}, 0);
  local _g = 1;
  local _g1 = grid:tilesX() + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local x = _g - 1;
    local _g = 1;
    local _g1 = grid:tilesY() + 1;
    while (_g < _g1) do 
      _g = _g + 1;
      local y = _g - 1;
      local _g = 1;
      local _g1 = grid:tilesZ() + 1;
      while (_g < _g1) do 
        _g = _g + 1;
        local z = _g - 1;
        local ceilTex = grid:ceilingTextureName(x, y, z);
        local wallTex = grid:wallTextureName(x, y, z);
        local floorTex = grid:floorTextureName(x, y, z);
        if (texs:indexOf(ceilTex) == -1) then 
          texs:push(ceilTex);
        end;
        if (texs:indexOf(wallTex) == -1) then 
          texs:push(wallTex);
        end;
        if (texs:indexOf(floorTex) == -1) then 
          texs:push(floorTex);
        end;
      end;
    end;
  end;
  do return texs end;
end
GridSaver.gridMemblockSize = function(grid,flagMgr,texs) 
  do return ((GridSaver.headerSize() + GridSaver.texturesSize(texs)) + GridSaver.tilesSize(grid)) + GridSaver.flagsSize(flagMgr) end;
end
GridSaver.headerSize = function() 
  do return 4 end;
end
GridSaver.texturesSize = function(texs) 
  local size = 1;
  local _g = 0;
  while (_g < texs.length) do 
    local tex = texs[_g];
    _g = _g + 1;
    size = size + (4 + _G.Len(tex));
  end;
  do return size end;
end
GridSaver.tilesSize = function(grid) 
  do return 4 + (GridSaver.numTilesSet(grid) * 7) end;
end
GridSaver.numTilesSet = function(grid) 
  local count = 0;
  local _g = 1;
  local _g1 = grid:tilesX() + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local x = _g - 1;
    local _g = 1;
    local _g1 = grid:tilesY() + 1;
    while (_g < _g1) do 
      _g = _g + 1;
      local y = _g - 1;
      local _g = 1;
      local _g1 = grid:tilesZ() + 1;
      while (_g < _g1) do 
        _g = _g + 1;
        local z = _g - 1;
        if (grid:hasTile(x, y, z)) then 
          count = count + 1;
        end;
      end;
    end;
  end;
  do return count end;
end
GridSaver.flagsSize = function(flagMgr) 
  do return 1 + (flagMgr:size() * 4) end;
end
GridSaver.writeHeader = function(grid,writer) 
  writer:writeByte(1);
  writer:writeByte(grid:tilesX());
  writer:writeByte(grid:tilesY());
  writer:writeByte(grid:tilesZ());
end
GridSaver.writeTextures = function(texs,writer) 
  writer:writeByte(texs.length);
  local _g = 0;
  while (_g < texs.length) do 
    local tex = texs[_g];
    _g = _g + 1;
    writer:writeString(tex);
  end;
end
GridSaver.writeTiles = function(grid,texs,writer) 
  writer:writeInt(GridSaver.numTilesSet(grid));
  local _g = 1;
  local _g1 = grid:tilesX() + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local x = _g - 1;
    local _g = 1;
    local _g1 = grid:tilesY() + 1;
    while (_g < _g1) do 
      _g = _g + 1;
      local y = _g - 1;
      local _g = 1;
      local _g1 = grid:tilesZ() + 1;
      while (_g < _g1) do 
        _g = _g + 1;
        local z = _g - 1;
        GridSaver.writeTile(grid, x, y, z, texs, writer);
      end;
    end;
  end;
end
GridSaver.writeTile = function(grid,x,y,z,texs,writer) 
  if (grid:hasTile(x, y, z)) then 
    writer:writeByte(x);
    writer:writeByte(y);
    writer:writeByte(z);
    writer:writeByte(grid:getTileType(x, y, z));
    writer:writeByte(texs:indexOf(grid:ceilingTextureName(x, y, z)) + 1);
    writer:writeByte(texs:indexOf(grid:wallTextureName(x, y, z)) + 1);
    writer:writeByte(texs:indexOf(grid:floorTextureName(x, y, z)) + 1);
  end;
end
GridSaver.writeFlags = function(flagMgr,writer) 
  writer:writeByte(flagMgr:size());
  local _g = 1;
  local _g1 = flagMgr:size() + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    GridSaver.writeFlag(flagMgr:at(i), writer);
  end;
end
GridSaver.writeFlag = function(flag,writer) 
  if (flag == nil) then 
    do return end;
  end;
  writer:writeByte(flag.id);
  writer:writeByte(_G.Int(flag:x()));
  writer:writeByte(_G.Int(flag:y()));
  writer:writeByte(_G.Int(flag:z()));
end

Main.new = {}
Main.main = function() 
  local TEX_PATH = "../textures/";
  _G.load("dialogs");
  _G.OpenScreen(1024, 768, _G.DesktopDepth(), 6);
  local textureNames = TextureReader.read(TEX_PATH);
  local ceilingTexViewer = TextureViewer.new(textureNames, 1, TEX_PATH, 87, 69);
  local wallTexViewer = TextureViewer.new(textureNames, 2, TEX_PATH, 83, 68);
  local floorTexViewer = TextureViewer.new(textureNames, 3, TEX_PATH, 88, 67);
  local grid = Grid.new(64, 16, 64, TEX_PATH);
  local cursor = Cursor.new(grid);
  local flagMgr = FlagManager.new();
  local undoMgr = UndoManager.new();
  local gridMgr = GridManager.new(grid, cursor, ceilingTexViewer, wallTexViewer, floorTexViewer, flagMgr, undoMgr);
  local cam = Camera.new(cursor);
  while (not _G.ScreenShouldClose()) do 
    undoMgr:update();
    cursor:update(gridMgr:isEditing());
    cam:update(gridMgr:isEditing());
    gridMgr:update();
    if (gridMgr:isEditing()) then 
      ceilingTexViewer:update();
      wallTexViewer:update();
      floorTexViewer:update();
    end;
    flagMgr:update(gridMgr:getCurrentFlag());
    _G.DrawWorld();
    flagMgr:drawFlagNumbers(nil, cam.entity);
    if (gridMgr:isEditing()) then 
      ceilingTexViewer:draw(_G.ScreenWidth() - 144, 16, 128, 128);
      wallTexViewer:draw(_G.ScreenWidth() - 144, 160, 128, 128);
      floorTexViewer:draw(_G.ScreenWidth() - 144, 304, 128, 128);
      _G.DrawText(nil, Std.string(Std.string("[F1] New -- [F2] Load -- [F3] Save -- [F4] Mode: ") .. Std.string(gridMgr:getModeName())) .. Std.string(" -- [ENTER] Preview"), 8, 8, -1);
      _G.DrawText(nil, Std.string(Std.string(Std.string(Std.string(Std.string(Std.string(Std.string(Std.string("[F] ") .. Std.string(Main.enableDisableText(grid:filteringEnabled()))) .. Std.string(" texture filtering -- ")) .. Std.string("[L] ")) .. Std.string(Main.enableDisableText(gridMgr:lightingEnabled()))) .. Std.string(" lighting -- ")) .. Std.string("[R] ")) .. Std.string(Main.enableDisableText(grid:wireframeEnabled()))) .. Std.string(" wireframe"), 8, 24, -1);
      _G.DrawText(nil, Std.string(Std.string(Std.string(Std.string("[U/I] Select flag number (current: ") .. Std.string(gridMgr:getCurrentFlag())) .. Std.string(") -- ")) .. Std.string("[P] Place flag -- ")) .. Std.string("[O] Delete flag"), 8, 40, -1);
      _G.DrawText(nil, Std.string(Std.string(Std.string(Std.string(Std.string("Cursor Position ") .. Std.string(_G.Int(_G.EntityX(cursor.entity)))) .. Std.string("x")) .. Std.string(_G.Int(_G.EntityY(cursor.entity)))) .. Std.string("x")) .. Std.string(_G.Int(_G.EntityZ(cursor.entity))), 8, _G.ScreenHeight() - 24, -1);
    end;
    _G.RefreshScreen();
  end;
end
Main.enableDisableText = function(state) 
  if (state) then 
    do return "Disable" end;
  else
    do return "Enable" end;
  end;
end

Math.new = {}
Math.isNaN = function(f) 
  do return f ~= f end;
end
Math.isFinite = function(f) 
  if (f > -_G.math.huge) then 
    do return f < _G.math.huge end;
  else
    do return false end;
  end;
end
Math.min = function(a,b) 
  if (Math.isNaN(a) or Math.isNaN(b)) then 
    do return (0/0) end;
  else
    do return _G.math.min(a, b) end;
  end;
end

MemblockReader.new = function(memblock) 
  local self = _hx_new(MemblockReader.prototype)
  MemblockReader.super(self,memblock)
  return self
end
MemblockReader.super = function(self,memblock) 
  self.memblock = memblock;
  self.offset = 0;
end
MemblockReader.prototype = _hx_e();
MemblockReader.prototype.readByte = function(self) 
  local val = _G.PeekByte(self.memblock, self.offset);
  local tmp = self;
  tmp.offset = tmp.offset + 1;
  do return val end
end
MemblockReader.prototype.readInt = function(self) 
  local val = _G.PeekInt(self.memblock, self.offset);
  local tmp = self;
  tmp.offset = tmp.offset + 4;
  do return val end
end
MemblockReader.prototype.readString = function(self) 
  local val = _G.PeekString(self.memblock, self.offset);
  local tmp = self;
  tmp.offset = tmp.offset + (4 + _G.Len(val));
  do return val end
end

MemblockWriter.new = function(memblock) 
  local self = _hx_new(MemblockWriter.prototype)
  MemblockWriter.super(self,memblock)
  return self
end
MemblockWriter.super = function(self,memblock) 
  self.memblock = memblock;
  self.offset = 0;
end
MemblockWriter.prototype = _hx_e();
MemblockWriter.prototype.writeByte = function(self,v) 
  _G.PokeByte(self.memblock, self.offset, v);
  local tmp = self;
  tmp.offset = tmp.offset + 1;
end
MemblockWriter.prototype.writeInt = function(self,v) 
  _G.PokeInt(self.memblock, self.offset, v);
  local tmp = self;
  tmp.offset = tmp.offset + 4;
end
MemblockWriter.prototype.writeString = function(self,v) 
  _G.PokeString(self.memblock, self.offset, v);
  local tmp = self;
  tmp.offset = tmp.offset + (4 + _G.Len(v));
end

String.new = function(string) 
  local self = _hx_new(String.prototype)
  String.super(self,string)
  self = string
  return self
end
String.super = function(self,string) 
end
String.__index = function(s,k) 
  if (k == "length") then 
    do return _G.string.len(s) end;
  else
    local o = String.prototype;
    local field = k;
    if ((function() 
      local _hx_1
      if ((_G.type(o) == "string") and ((String.prototype[field] ~= nil) or (field == "length"))) then 
      _hx_1 = true; elseif (o.__fields__ ~= nil) then 
      _hx_1 = o.__fields__[field] ~= nil; else 
      _hx_1 = o[field] ~= nil; end
      return _hx_1
    end )()) then 
      do return String.prototype[k] end;
    else
      if (String.__oldindex ~= nil) then 
        if (_G.type(String.__oldindex) == "function") then 
          do return String.__oldindex(s, k) end;
        else
          if (_G.type(String.__oldindex) == "table") then 
            do return String.__oldindex[k] end;
          end;
        end;
        do return nil end;
      else
        do return nil end;
      end;
    end;
  end;
end
String.indexOfEmpty = function(s,startIndex) 
  local length = _G.string.len(s);
  if (startIndex < 0) then 
    startIndex = length + startIndex;
    if (startIndex < 0) then 
      startIndex = 0;
    end;
  end;
  if (startIndex > length) then 
    do return length end;
  else
    do return startIndex end;
  end;
end
String.fromCharCode = function(code) 
  do return _G.string.char(code) end;
end
String.prototype = _hx_e();
String.prototype.toUpperCase = function(self) 
  do return _G.string.upper(self) end
end
String.prototype.toLowerCase = function(self) 
  do return _G.string.lower(self) end
end
String.prototype.indexOf = function(self,str,startIndex) 
  if (startIndex == nil) then 
    startIndex = 1;
  else
    startIndex = startIndex + 1;
  end;
  if (str == "") then 
    do return String.indexOfEmpty(self, startIndex - 1) end;
  end;
  local r = _G.string.find(self, str, startIndex, true);
  if ((r ~= nil) and (r > 0)) then 
    do return r - 1 end;
  else
    do return -1 end;
  end;
end
String.prototype.lastIndexOf = function(self,str,startIndex) 
  local ret = -1;
  if (startIndex == nil) then 
    startIndex = #self;
  end;
  while (true) do 
    local startIndex1 = ret + 1;
    if (startIndex1 == nil) then 
      startIndex1 = 1;
    else
      startIndex1 = startIndex1 + 1;
    end;
    local p;
    if (str == "") then 
      p = String.indexOfEmpty(self, startIndex1 - 1);
    else
      local r = _G.string.find(self, str, startIndex1, true);
      p = (function() 
        local _hx_1
        if ((r ~= nil) and (r > 0)) then 
        _hx_1 = r - 1; else 
        _hx_1 = -1; end
        return _hx_1
      end )();
    end;
    if (((p == -1) or (p > startIndex)) or (p == ret)) then 
      break;
    end;
    ret = p;
  end;
  do return ret end
end
String.prototype.split = function(self,delimiter) 
  local idx = 1;
  local ret = _hx_tab_array({}, 0);
  while (idx ~= nil) do 
    local newidx = 0;
    if (#delimiter > 0) then 
      newidx = _G.string.find(self, delimiter, idx, true);
    else
      if (idx >= #self) then 
        newidx = nil;
      else
        newidx = idx + 1;
      end;
    end;
    if (newidx ~= nil) then 
      local match = _G.string.sub(self, idx, newidx - 1);
      ret:push(match);
      idx = newidx + #delimiter;
    else
      ret:push(_G.string.sub(self, idx, #self));
      idx = nil;
    end;
  end;
  do return ret end
end
String.prototype.toString = function(self) 
  do return self end
end
String.prototype.substring = function(self,startIndex,endIndex) 
  if (endIndex == nil) then 
    endIndex = #self;
  end;
  if (endIndex < 0) then 
    endIndex = 0;
  end;
  if (startIndex < 0) then 
    startIndex = 0;
  end;
  if (endIndex < startIndex) then 
    do return _G.string.sub(self, endIndex + 1, startIndex) end;
  else
    do return _G.string.sub(self, startIndex + 1, endIndex) end;
  end;
end
String.prototype.charAt = function(self,index) 
  do return _G.string.sub(self, index + 1, index + 1) end
end
String.prototype.charCodeAt = function(self,index) 
  do return _G.string.byte(self, index + 1) end
end
String.prototype.substr = function(self,pos,len) 
  if ((len == nil) or (len > (pos + #self))) then 
    len = #self;
  else
    if (len < 0) then 
      len = #self + len;
    end;
  end;
  if (pos < 0) then 
    pos = #self + pos;
  end;
  if (pos < 0) then 
    pos = 0;
  end;
  do return _G.string.sub(self, pos + 1, pos + len) end
end

Std.new = {}
Std.string = function(s) 
  do return _hx_tostring(s, 0) end;
end
Std.int = function(x) 
  if (not Math.isFinite(x) or Math.isNaN(x)) then 
    do return 0 end;
  else
    do return _hx_bit_clamp(x) end;
  end;
end

TextureReader.new = {}
TextureReader.read = function(path) 
  local textures = _hx_tab_array({}, 0);
  local contents = _G.DirContents(path);
  local _g = 1;
  local _g1 = _G.SplitCount(contents, "\n") + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    local tex = _G.SplitIndex(contents, "\n", i);
    local ext = _G.Lower(_G.ExtractExt(tex));
    if ((_G.Left(tex, 1) ~= ".") and ((ext == "jpg") or (ext == "png"))) then 
      textures:push(tex);
    end;
  end;
  do return textures end;
end

TextureViewer.new = function(textureNames,selected,path,prevKey,nextKey) 
  local self = _hx_new(TextureViewer.prototype)
  TextureViewer.super(self,textureNames,selected,path,prevKey,nextKey)
  return self
end
TextureViewer.super = function(self,textureNames,selected,path,prevKey,nextKey) 
  self.names = textureNames;
  self.selected = _G.Int(_G.Clamp(selected, 1, self.names.length));
  self.path = path;
  self.tex = nil;
  self.prevKey = prevKey;
  self.nextKey = nextKey;
  self:reloadTexture();
end
TextureViewer.prototype = _hx_e();
TextureViewer.prototype.update = function(self) 
  if (_G.KeyHit(self.prevKey)) then 
    self:prevTexture();
  end;
  if (_G.KeyHit(self.nextKey)) then 
    self:nextTexture();
  end;
end
TextureViewer.prototype.draw = function(self,x,y,width,height) 
  if (self.tex ~= nil) then 
    _G.DrawTextureEx(self.tex, x, y, width, height, -1);
  end;
end
TextureViewer.prototype.textureName = function(self) 
  do return self.names[self.selected - 1] end
end
TextureViewer.prototype.nextTexture = function(self) 
  self.selected = self.selected + 1;
  if (self.selected > self.names.length) then 
    self.selected = 1;
  end;
  self:reloadTexture();
end
TextureViewer.prototype.prevTexture = function(self) 
  self.selected = self.selected - 1;
  if (self.selected < 1) then 
    self.selected = self.names.length;
  end;
  self:reloadTexture();
end
TextureViewer.prototype.reloadTexture = function(self) 
  self.tex = _G.LoadTexture(Std.string(self.path) .. Std.string(self.names[self.selected - 1]));
end

UndoManager.new = function() 
  local self = _hx_new(UndoManager.prototype)
  UndoManager.super(self)
  return self
end
UndoManager.super = function(self) 
  self._undo = _hx_tab_array({}, 0);
  self._redo = _hx_tab_array({}, 0);
end
UndoManager.prototype = _hx_e();
UndoManager.prototype.addUndo = function(self,command) 
  if (command ~= nil) then 
    self._undo:push(command);
    self._redo:resize(0);
  end;
end
UndoManager.prototype.canUndo = function(self) 
  do return self._undo.length > 0 end
end
UndoManager.prototype.canRedo = function(self) 
  do return self._redo.length > 0 end
end
UndoManager.prototype.undo = function(self) 
  if (self:canUndo()) then 
    local result = self._undo[self._undo.length - 1]:execute();
    self._undo:pop();
    if (result ~= nil) then 
      self._redo:push(result);
    end;
  end;
end
UndoManager.prototype.redo = function(self) 
  if (self:canRedo()) then 
    local result = self._redo[self._redo.length - 1]:execute();
    self._redo:pop();
    if (result ~= nil) then 
      self._undo:push(result);
    end;
  end;
end
UndoManager.prototype.update = function(self) 
  if (_G.KeyDown(162) or _G.KeyDown(163)) then 
    if (_G.KeyHit(90)) then 
      self:undo();
    end;
    if (_G.KeyHit(89)) then 
      self:redo();
    end;
  end;
end
UndoManager.prototype.reset = function(self) 
  self._undo:resize(0);
  self._redo:resize(0);
end

__command_ICommand.new = {}

__command_PlaceFlagCommand.new = function(id,x,y,z,mgr) 
  local self = _hx_new(__command_PlaceFlagCommand.prototype)
  __command_PlaceFlagCommand.super(self,id,x,y,z,mgr)
  return self
end
__command_PlaceFlagCommand.super = function(self,id,x,y,z,mgr) 
  self.id = id;
  self.x = x;
  self.y = y;
  self.z = z;
  self.mgr = mgr;
end
__command_PlaceFlagCommand.__interfaces__ = {__command_ICommand}
__command_PlaceFlagCommand.prototype = _hx_e();
__command_PlaceFlagCommand.prototype.execute = function(self) 
  local undoCmd = nil;
  if (self.mgr:findIndex(self.id) == nil) then 
    undoCmd = __command_RemoveFlagCommand.new(self.id, self.mgr);
  else
    local flag = self.mgr:find(self.id);
    if (flag == nil) then 
      do return nil end;
    end;
    if (((flag:x() == self.x) and (flag:y() == self.y)) and (flag:z() == self.z)) then 
      do return nil end;
    end;
    undoCmd = __command_PlaceFlagCommand.new(self.id, flag:x(), flag:y(), flag:z(), self.mgr);
  end;
  self.mgr:place(self.id, self.x, self.y, self.z);
  do return undoCmd end
end

__command_RemoveFlagCommand.new = function(id,mgr) 
  local self = _hx_new(__command_RemoveFlagCommand.prototype)
  __command_RemoveFlagCommand.super(self,id,mgr)
  return self
end
__command_RemoveFlagCommand.super = function(self,id,mgr) 
  self.id = id;
  self.mgr = mgr;
end
__command_RemoveFlagCommand.__interfaces__ = {__command_ICommand}
__command_RemoveFlagCommand.prototype = _hx_e();
__command_RemoveFlagCommand.prototype.execute = function(self) 
  local flag = self.mgr:find(self.id);
  if (flag == nil) then 
    do return nil end;
  end;
  local undoCmd = __command_PlaceFlagCommand.new(self.id, flag:x(), flag:y(), flag:z(), self.mgr);
  self.mgr:remove(self.id);
  do return undoCmd end
end

__command_RemoveTileCommand.new = function(grid,x,y,z) 
  local self = _hx_new(__command_RemoveTileCommand.prototype)
  __command_RemoveTileCommand.super(self,grid,x,y,z)
  return self
end
__command_RemoveTileCommand.super = function(self,grid,x,y,z) 
  self.grid = grid;
  self.x = x;
  self.y = y;
  self.z = z;
end
__command_RemoveTileCommand.__interfaces__ = {__command_ICommand}
__command_RemoveTileCommand.prototype = _hx_e();
__command_RemoveTileCommand.prototype.execute = function(self) 
  if (self.grid:hasTile(self.x, self.y, self.z)) then 
    local undoCmd = __command_SetTileCommand.new(self.grid, self.x, self.y, self.z, self.grid:getTileType(self.x, self.y, self.z), self.grid:ceilingTextureName(self.x, self.y, self.z), self.grid:wallTextureName(self.x, self.y, self.z), self.grid:floorTextureName(self.x, self.y, self.z));
    self.grid:removeTile(self.x, self.y, self.z);
    do return undoCmd end;
  end;
  do return nil end
end

__command_SetTileCommand.new = function(grid,x,y,z,kind,ceilingTexName,wallTexName,floorTexName) 
  local self = _hx_new(__command_SetTileCommand.prototype)
  __command_SetTileCommand.super(self,grid,x,y,z,kind,ceilingTexName,wallTexName,floorTexName)
  return self
end
__command_SetTileCommand.super = function(self,grid,x,y,z,kind,ceilingTexName,wallTexName,floorTexName) 
  self.grid = grid;
  self.x = x;
  self.y = y;
  self.z = z;
  self.kind = kind;
  self.ceilingTexName = ceilingTexName;
  self.wallTexName = wallTexName;
  self.floorTexName = floorTexName;
end
__command_SetTileCommand.__interfaces__ = {__command_ICommand}
__command_SetTileCommand.prototype = _hx_e();
__command_SetTileCommand.prototype.execute = function(self) 
  local undoCmd = nil;
  if (self.grid:hasTile(self.x, self.y, self.z)) then 
    if ((((self.grid:getTileType(self.x, self.y, self.z) ~= self.kind) or (self.grid:ceilingTextureName(self.x, self.y, self.z) ~= self.ceilingTexName)) or (self.grid:wallTextureName(self.x, self.y, self.z) ~= self.wallTexName)) or (self.grid:floorTextureName(self.x, self.y, self.z) ~= self.floorTexName)) then 
      undoCmd = __command_SetTileCommand.new(self.grid, self.x, self.y, self.z, self.grid:getTileType(self.x, self.y, self.z), self.grid:ceilingTextureName(self.x, self.y, self.z), self.grid:wallTextureName(self.x, self.y, self.z), self.grid:floorTextureName(self.x, self.y, self.z));
    end;
  else
    undoCmd = __command_RemoveTileCommand.new(self.grid, self.x, self.y, self.z);
  end;
  self.grid:setTile(self.x, self.y, self.z, self.kind, self.ceilingTexName, self.wallTexName, self.floorTexName);
  do return undoCmd end
end

__grid_mesh_GridMeshCreator.new = function(grid) 
  local self = _hx_new(__grid_mesh_GridMeshCreator.prototype)
  __grid_mesh_GridMeshCreator.super(self,grid)
  return self
end
__grid_mesh_GridMeshCreator.super = function(self,grid) 
  self.grid = grid;
  self.surfs = __haxe_ds_StringMap.new();
  local _g = 1;
  local _g1 = grid:tilesX() + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local x = _g - 1;
    local _g = 1;
    local _g1 = grid:tilesY() + 1;
    while (_g < _g1) do 
      _g = _g + 1;
      local y = _g - 1;
      local _g = 1;
      local _g1 = grid:tilesZ() + 1;
      while (_g < _g1) do 
        _g = _g + 1;
        local z = _g - 1;
        self:addGridMeshTile(x, y, z);
      end;
    end;
  end;
end
__grid_mesh_GridMeshCreator.create = function(grid) 
  local creator = __grid_mesh_GridMeshCreator.new(grid);
  local mesh = _G.CreateMesh();
  local s = creator.surfs:iterator();
  while (s:hasNext()) do 
    local s = s:next();
    s:addToMesh(mesh);
  end;
  _G.UpdateMesh(mesh);
  do return mesh end;
end
__grid_mesh_GridMeshCreator.prototype = _hx_e();
__grid_mesh_GridMeshCreator.prototype.addGridMeshTile = function(self,x,y,z) 
  if (not self.grid:hasTile(x, y, z)) then 
    do return end;
  end;
  local t = self.grid:getTileType(x, y, z);
  if (t == 1) then 
    self:addBlock(x, y, z);
  end;
  if (t == 2) then 
    self:addStairs(x, y, z, 0);
  end;
  if (t == 3) then 
    self:addStairs(x, y, z, 90);
  end;
  if (t == 4) then 
    self:addStairs(x, y, z, 180);
  end;
  if (t == 5) then 
    self:addStairs(x, y, z, 270);
  end;
end
__grid_mesh_GridMeshCreator.prototype.addBlock = function(self,x,y,z,floor,front,right,back,left) 
  if (left == nil) then 
    left = true;
  end;
  if (back == nil) then 
    back = true;
  end;
  if (right == nil) then 
    right = true;
  end;
  if (front == nil) then 
    front = true;
  end;
  if (floor == nil) then 
    floor = true;
  end;
  local surf = self:findSurface(self.grid:floorTextureName(x, y, z));
  if (floor and not self.grid:hasTile(x, y - 1, z)) then 
    local sx = x - 0.5;
    local sy = y - 0.5;
    local sz = z - 0.5;
    local a = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz, 0, 1, 0, -1, 0, 1));
    local b = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy, sz, 0, 1, 0, -1, 1, 1));
    local c = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy, sz + 1, 0, 1, 0, -1, 1, 0));
    local d = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz + 1, 0, 1, 0, -1, 0, 0));
    surf:addIndex(a);
    surf:addIndex(c);
    surf:addIndex(b);
    surf:addIndex(a);
    surf:addIndex(d);
    surf:addIndex(c);
  end;
  surf = self:findSurface(self.grid:ceilingTextureName(x, y, z));
  if (not self.grid:hasTile(x, y + 1, z)) then 
    local sx = x - 0.5;
    local sy = y + 0.5;
    local sz = z - 0.5;
    local a = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz, 0, -1, 0, -1, 0, 1));
    local b = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy, sz, 0, -1, 0, -1, 1, 1));
    local c = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy, sz + 1, 0, -1, 0, -1, 1, 0));
    local d = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz + 1, 0, -1, 0, -1, 0, 0));
    surf:addIndex(a);
    surf:addIndex(b);
    surf:addIndex(c);
    surf:addIndex(a);
    surf:addIndex(c);
    surf:addIndex(d);
  end;
  surf = self:findSurface(self.grid:wallTextureName(x, y, z));
  if (left and not self.grid:hasTile(x - 1, y, z)) then 
    local sx = x - 0.5;
    local sy = y - 0.5;
    local sz = z - 0.5;
    local a = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz, 1, 0, 0, -1, 0, 1));
    local b = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz + 1, 1, 0, 0, -1, 1, 1));
    local c = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy + 1, sz + 1, 1, 0, 0, -1, 1, 0));
    local d = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy + 1, sz, 1, 0, 0, -1, 0, 0));
    surf:addIndex(a);
    surf:addIndex(c);
    surf:addIndex(b);
    surf:addIndex(a);
    surf:addIndex(d);
    surf:addIndex(c);
  end;
  if (right and not self.grid:hasTile(x + 1, y, z)) then 
    local sx = x + 0.5;
    local sy = y - 0.5;
    local sz = z - 0.5;
    local a = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz, -1, 0, 0, -1, 0, 1));
    local b = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz + 1, -1, 0, 0, -1, 1, 1));
    local c = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy + 1, sz + 1, -1, 0, 0, -1, 1, 0));
    local d = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy + 1, sz, -1, 0, 0, -1, 0, 0));
    surf:addIndex(b);
    surf:addIndex(c);
    surf:addIndex(a);
    surf:addIndex(a);
    surf:addIndex(c);
    surf:addIndex(d);
  end;
  if (front and not self.grid:hasTile(x, y, z + 1)) then 
    local sx = x - 0.5;
    local sy = y - 0.5;
    local sz = z + 0.5;
    local a = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz, 0, 0, -1, -1, 0, 1));
    local b = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy, sz, 0, 0, -1, -1, 1, 1));
    local c = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy + 1, sz, 0, 0, -1, -1, 1, 0));
    local d = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy + 1, sz, 0, 0, -1, -1, 0, 0));
    surf:addIndex(a);
    surf:addIndex(d);
    surf:addIndex(c);
    surf:addIndex(a);
    surf:addIndex(c);
    surf:addIndex(b);
  end;
  if (back and not self.grid:hasTile(x, y, z - 1)) then 
    local sx = x - 0.5;
    local sy = y - 0.5;
    local sz = z - 0.5;
    local a = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz, 0, 0, 1, -1, 0, 1));
    local b = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy, sz, 0, 0, 1, -1, 1, 1));
    local c = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy + 1, sz, 0, 0, 1, -1, 1, 0));
    local d = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy + 1, sz, 0, 0, 1, -1, 0, 0));
    surf:addIndex(a);
    surf:addIndex(b);
    surf:addIndex(d);
    surf:addIndex(b);
    surf:addIndex(c);
    surf:addIndex(d);
  end;
end
__grid_mesh_GridMeshCreator.prototype.addStairs = function(self,x,y,z,yaw) 
  self:addBlock(x, y, z, false, yaw ~= 0, yaw ~= 90, yaw ~= 180, yaw ~= 270);
  local stairsMesh = __grid_mesh_StairMeshCreator.create(x, y, z, yaw);
  local stairsSurf = _G.MeshSurface(stairsMesh, 1);
  local surf = self:findSurface(self.grid:floorTextureName(x, y, z));
  local numVerts = surf:numVertices();
  local _g = 1;
  local _g1 = _G.NumVertices(stairsSurf) + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local v = _g - 1;
    surf:addVertex(__grid_mesh_GridVertex.new(_G.VertexX(stairsSurf, v), _G.VertexY(stairsSurf, v), _G.VertexZ(stairsSurf, v), _G.VertexNX(stairsSurf, v), _G.VertexNY(stairsSurf, v), _G.VertexNZ(stairsSurf, v), _G.VertexColor(stairsSurf, v), _G.VertexU(stairsSurf, v, 1), _G.VertexV(stairsSurf, v, 1)));
  end;
  local _g = 1;
  local _g1 = _G.NumIndices(stairsSurf) + 1;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    surf:addIndex(numVerts + _G.SurfaceIndex(stairsSurf, i));
  end;
  _G.FreeMesh(stairsMesh);
end
__grid_mesh_GridMeshCreator.prototype.findSurface = function(self,texName) 
  if (self.surfs.h[texName] ~= nil) then 
    local ret = self.surfs.h[texName];
    if (ret == __haxe_ds_StringMap.tnull) then 
      ret = nil;
    end;
    do return ret end;
  end;
  local this1 = self.surfs;
  local value = __grid_mesh_GridSurface.new(Std.string(self.grid:getTexturePath()) .. Std.string(texName));
  local _this = this1;
  if (value == nil) then 
    _this.h[texName] = __haxe_ds_StringMap.tnull;
  else
    _this.h[texName] = value;
  end;
  local ret = self.surfs.h[texName];
  if (ret == __haxe_ds_StringMap.tnull) then 
    ret = nil;
  end;
  do return ret end
end

__grid_mesh_GridSurface.new = function(texName) 
  local self = _hx_new(__grid_mesh_GridSurface.prototype)
  __grid_mesh_GridSurface.super(self,texName)
  return self
end
__grid_mesh_GridSurface.super = function(self,texName) 
  if (texName == nil) then 
    texName = "";
  end;
  self.texName = texName;
  self.verts = _hx_tab_array({}, 0);
  self.idxs = _hx_tab_array({}, 0);
end
__grid_mesh_GridSurface.prototype = _hx_e();
__grid_mesh_GridSurface.prototype.addVertex = function(self,vertex) 
  self.verts:push(vertex);
  do return self.verts.length - 1 end
end
__grid_mesh_GridSurface.prototype.numVertices = function(self) 
  do return self.verts.length end
end
__grid_mesh_GridSurface.prototype.addIndex = function(self,idx) 
  self.idxs:push(idx);
end
__grid_mesh_GridSurface.prototype.numIndices = function(self) 
  do return self.idxs.length end
end
__grid_mesh_GridSurface.prototype.addToMesh = function(self,mesh) 
  local vertices = self:verticesMemblock();
  local indices = self:indicesMemblock();
  local surf = _G.AddSurface(mesh, vertices, self:numVertices(), indices, self:numIndices(), 0);
  local mat = _G.SurfaceMaterial(surf);
  if (self.texName ~= "") then 
    _G.SetMaterialTexture(mat, 1, _G.LoadTexture(self.texName));
  end;
  _G.FreeMemblock(vertices);
  _G.FreeMemblock(indices);
  do return surf end
end
__grid_mesh_GridSurface.prototype.verticesMemblock = function(self) 
  local vertexSize = 36;
  local memblock = _G.CreateMemblock(vertexSize * self:numVertices());
  local _g = 0;
  local _g1 = self.verts.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    local v = self.verts[i];
    _G.PokeFloat(memblock, i * vertexSize, v.x);
    _G.PokeFloat(memblock, (i * vertexSize) + 4, v.y);
    _G.PokeFloat(memblock, (i * vertexSize) + 8, v.z);
    _G.PokeFloat(memblock, (i * vertexSize) + 12, v.nx);
    _G.PokeFloat(memblock, (i * vertexSize) + 16, v.ny);
    _G.PokeFloat(memblock, (i * vertexSize) + 20, v.nz);
    _G.PokeInt(memblock, (i * vertexSize) + 24, v.color);
    _G.PokeFloat(memblock, (i * vertexSize) + 28, v.u);
    _G.PokeFloat(memblock, (i * vertexSize) + 32, v.v);
  end;
  do return memblock end
end
__grid_mesh_GridSurface.prototype.indicesMemblock = function(self) 
  local indexSize = 2;
  local memblock = _G.CreateMemblock(indexSize * self:numIndices());
  local _g = 0;
  local _g1 = self.idxs.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    _G.PokeShort(memblock, i * indexSize, self.idxs[i]);
  end;
  do return memblock end
end

__grid_mesh_GridVertex.new = function(x,y,z,nx,ny,nz,color,u,v) 
  local self = _hx_new()
  __grid_mesh_GridVertex.super(self,x,y,z,nx,ny,nz,color,u,v)
  return self
end
__grid_mesh_GridVertex.super = function(self,x,y,z,nx,ny,nz,color,u,v) 
  self.x = x;
  self.y = y;
  self.z = z;
  self.nx = nx;
  self.ny = ny;
  self.nz = nz;
  self.color = color;
  self.u = u;
  self.v = v;
end

__grid_mesh_StairMeshCreator.new = {}
__grid_mesh_StairMeshCreator.create = function(x,y,z,yaw) 
  local surf = __grid_mesh_GridSurface.new();
  __grid_mesh_StairMeshCreator.addStepWall(0, 0, 0, surf);
  __grid_mesh_StairMeshCreator.addStepWall(0, 0.2, 0.25, surf);
  __grid_mesh_StairMeshCreator.addStepWall(0, 0.4, 0.50, surf);
  __grid_mesh_StairMeshCreator.addStepWall(0, 0.6, 0.75, surf);
  __grid_mesh_StairMeshCreator.addStepWall(0, 0.8, 1, surf);
  __grid_mesh_StairMeshCreator.addStepFloor(0, 0.2, 0, surf);
  __grid_mesh_StairMeshCreator.addStepFloor(0, 0.4, 0.25, surf);
  __grid_mesh_StairMeshCreator.addStepFloor(0, 0.6, 0.50, surf);
  __grid_mesh_StairMeshCreator.addStepFloor(0, 0.8, 0.75, surf);
  local mesh = _G.CreateMesh();
  surf:addToMesh(mesh);
  if (yaw ~= 0) then 
    _G.RotateMesh(mesh, 0, yaw, 0);
  end;
  _G.TranslateMesh(mesh, x, y, z);
  _G.UpdateMesh(mesh);
  do return mesh end;
end
__grid_mesh_StairMeshCreator.addStepWall = function(x,y,z,surf) 
  local sx = x - 0.5;
  local sy = y - 0.5;
  local sz = z - 0.5;
  local a = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz, 0, 0, -1, -1, 0, 0.2));
  local b = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy, sz, 0, 0, -1, -1, 1, 0.2));
  local c = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy + 0.2, sz, 0, 0, -1, -1, 1, 0));
  local d = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy + 0.2, sz, 0, 0, -1, -1, 0, 0));
  surf:addIndex(a);
  surf:addIndex(d);
  surf:addIndex(c);
  surf:addIndex(a);
  surf:addIndex(c);
  surf:addIndex(b);
end
__grid_mesh_StairMeshCreator.addStepFloor = function(x,y,z,surf) 
  local sx = x - 0.5;
  local sy = y - 0.5;
  local sz = z - 0.5;
  local a = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz, 0, 1, 0, -1, 0, 0.25));
  local b = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy, sz, 0, 1, 0, -1, 1, 0.25));
  local c = surf:addVertex(__grid_mesh_GridVertex.new(sx + 1, sy, sz + 0.25, 0, 1, 0, -1, 1, 0));
  local d = surf:addVertex(__grid_mesh_GridVertex.new(sx, sy, sz + 0.25, 0, 1, 0, -1, 0, 0));
  surf:addIndex(a);
  surf:addIndex(c);
  surf:addIndex(b);
  surf:addIndex(a);
  surf:addIndex(d);
  surf:addIndex(c);
end

__haxe_IMap.new = {}

__haxe_ds_StringMap.new = function() 
  local self = _hx_new(__haxe_ds_StringMap.prototype)
  __haxe_ds_StringMap.super(self)
  return self
end
__haxe_ds_StringMap.super = function(self) 
  self.h = ({});
end
__haxe_ds_StringMap.__interfaces__ = {__haxe_IMap}
__haxe_ds_StringMap.prototype = _hx_e();
__haxe_ds_StringMap.prototype.keys = function(self) 
  local _gthis = self;
  local next = _G.next;
  local cur = next(self.h, nil);
  do return _hx_o({__fields__={next=true,hasNext=true},next=function(self) 
    local ret = cur;
    cur = next(_gthis.h, cur);
    do return ret end;
  end,hasNext=function(self) 
    do return cur ~= nil end;
  end}) end
end
__haxe_ds_StringMap.prototype.iterator = function(self) 
  local _gthis = self;
  local it = self:keys();
  do return _hx_o({__fields__={hasNext=true,next=true},hasNext=function(self) 
    do return it:hasNext() end;
  end,next=function(self) 
    do return _gthis.h[it:next()] end;
  end}) end
end

__haxe_iterators_ArrayIterator.new = function(array) 
  local self = _hx_new(__haxe_iterators_ArrayIterator.prototype)
  __haxe_iterators_ArrayIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayIterator.super = function(self,array) 
  self.current = 0;
  self.array = array;
end
__haxe_iterators_ArrayIterator.prototype = _hx_e();
__haxe_iterators_ArrayIterator.prototype.hasNext = function(self) 
  do return self.current < self.array.length end
end
__haxe_iterators_ArrayIterator.prototype.next = function(self) 
  do return self.array[(function() 
  local _hx_obj = self;
  local _hx_fld = 'current';
  local _ = _hx_obj[_hx_fld];
  _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
   return _;
   end)()] end
end

__haxe_iterators_ArrayKeyValueIterator.new = function(array) 
  local self = _hx_new()
  __haxe_iterators_ArrayKeyValueIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayKeyValueIterator.super = function(self,array) 
  self.array = array;
end
if _hx_bit_raw then
    _hx_bit_clamp = function(v)
    if v <= 2147483647 and v >= -2147483648 then
        if v > 0 then return _G.math.floor(v)
        else return _G.math.ceil(v)
        end
    end
    if v > 2251798999999999 then v = v*2 end;
    if (v ~= v or math.abs(v) == _G.math.huge) then return nil end
    return _hx_bit_raw.band(v, 2147483647 ) - math.abs(_hx_bit_raw.band(v, 2147483648))
    end
else
    _hx_bit_clamp = function(v)
        if v < -2147483648 then
            return -2147483648
        elseif v > 2147483647 then
            return 2147483647
        elseif v > 0 then
            return _G.math.floor(v)
        else
            return _G.math.ceil(v)
        end
    end
end;



_hx_array_mt.__index = Array.prototype

local _hx_static_init = function()
  __haxe_ds_StringMap.tnull = ({});
  
  
end

_hx_static_init();
_G.xpcall(Main.main, _hx_error)
