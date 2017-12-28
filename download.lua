XML = [[
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="template.xsl"?>

<root>
  <download>]]

local p = io.popen('find "/webfile'..ngx.var.uri..'" -type f -printf "%f\n"')
for file in p:lines() do
   XML = XML..'<file dir="'..ngx.var.uri..'" name="'..file..'" />'
end

XML = XML .. [[
</download>
</root>
]]

ngx.say(XML);
