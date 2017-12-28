local msec = ngx.now()*1000
local alphabet = {
  'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
  'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
  '0','1','2','3','4','5','6','7','8','9'
}

local base = 62
local uid  = ''

while (msec > base) do
  digit = msec % base
  uid = uid..alphabet[digit+1]
  msec = msec / base
  msec = msec - msec % 1
end

local upload = require "resty.upload"
local cjson = require "cjson"
local conf = {
  SERVER_PATH = "d:\\",
  UPLOAD_PATH = "d:\\"
}

local chunk_size = 4096
local form, err = upload:new(chunk_size)
if not form then
    ngx.log(ngx.ERR, "failed to new upload: ", err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

form:set_timeout(1000)

string.split = function(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end

string.trim = function(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end


os.execute("mkdir "..conf["UPLOAD_PATH"].."/"..uid)
local saveRootPath = conf["UPLOAD_PATH"]..uid.."/"

local fileToSave
local ret_save = false

while true do
    local typ, res, err = form:read()
    if not typ then
        ngx.say("failed to read: ", err)
        return
    end

    if typ == "header" then
        local key = res[1]
        local value = res[2]
        if key == "Content-Disposition" then
            -- form-data; name="testFileName"; filename="testfile.txt"
            local kvlist = string.split(value, ';')
            for _, kv in ipairs(kvlist) do
                local seg = string.trim(kv)
                if seg:find("filename") then
                    local kvfile = string.split(seg, "=")
                    local filename = string.sub(kvfile[2], 2, -2)
                    if filename then
                        fileToSave = io.open(saveRootPath .. filename, "w+")
                        if not fileToSave then
                            ngx.say("failed to open file ", filename)
                            return
                        end
                        break
                    end
                end
            end
        end
    elseif typ == "body" then
        if fileToSave then
            fileToSave:write(res)
        end
    elseif typ == "part_end" then
        if fileToSave then
            fileToSave:close()
            fileToSave = nil
        end

        ret_save = true
    elseif typ == "eof" then
        break
    else
        ngx.log(ngx.INFO, "do other things")
    end
end

return ngx.say(uid)
