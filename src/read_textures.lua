function ReadTextures(path)
  local textures = {}
  local contents = DirContents(path)
  for i = 1, SplitCount(contents, "\n") do
    local tex = SplitIndex(contents, "\n", i)
    local ext = Lower(ExtractExt(tex))
    if Left(tex, 1) ~= "." and (ext == "jpg" or ext == "png") then
      textures[#textures + 1] = tex
    end
  end
  return textures
end
