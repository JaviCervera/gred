function ListIndex(lst, val)
  for i, v in ipairs(lst) do
    if v == val then return i end
  end
  return nil
end
