local XML = {name = "root", cdata = '', node = {}}; local metaXML = {}; setmetatable (XML,metaXML);

metaXML.__index = function (t, k)
  if not t.node[k] then t.node[k] = {name = k, cdata = '', node = {} }; setmetatable (t.node[k], metaXML) end
  return t.node[k]
end

metaXML.__newindex = function (t, k, v)
  t.node[k] = {name = k, cdata = v, node = {} }; setmetatable (t.node[k], metaXML)
end

metaXML.__tostring = function (t) 
  local n = ''; local o = {}
  table.insert (o,t.cdata)
  for k,v in pairs (t.node) do 
    if (#v.node == 0) then
      if type (k) == "number" then n = t.name else n = k end
      table.insert (o,'<'..n..'>'..metaXML.__tostring(v).."</"..n..'>')
    else
      table.insert (o,metaXML.__tostring(v))
    end
  end
  return table.concat(o)
end

return XML