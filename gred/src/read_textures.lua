function SplitLines(str)
  local t = {}
  for str in string.gmatch(str, "[^\n]+") do
    table.insert(t, str)
  end
  return t
end

function ReadTextures(path)
  local textures = {}
  for _, file in ipairs(SplitLines(DirContents(path))) do
    local ext = file:match("^.+(%..+)$")
    if file ~= "." and file ~= ".." and (ext == ".jpg" or ext == ".png") then
      textures[#textures + 1] = file
    end
  end
  table.sort(textures)
  return textures
end
