local XML = require "lib.XML"

XML.html.body = "Hello, world!"
XML.html.body.para = "Zero"
XML.html.body.p[1] = "First"
XML.html.body.p[1]._num = "1"
XML.html.body.p[2] = "Second"

print (XML)