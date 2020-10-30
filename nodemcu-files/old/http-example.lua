------------------------------------------------------------------------------
-- HTTP server Hello world example
--
-- LICENCE: http://opensource.org/licenses/MIT
-- Vladimir Dronnikov <dronnikov@gmail.com>
------------------------------------------------------------------------------
local url_data = {
    root = {
        url = "/",
        file = "index.html"
    },
    not_found = {
        file = "not_found.html"
    },
    wifi = {
        getap = {
            url = "/wifi/getap"
        },
        set = {
            url = "/wifi/set"
        }
    }
}

function sendPage(c, fileName) -- open file, read a chunk, and send it!
    local idx = 0 -- keep track of where we are in the file
    file.open(fileName)
    file.seek("set", idx)
    while true do
        local str = file.read(500)
        if not str then
            file.close() -- close the file to let other callbacks use the filesystem
            break
        end -- no more to send. 
        c:send(str)
        idx = idx + 500
    end
end

require("httpserver").createServer(80, function(req, res)
    -- analyse method and url
    o_log.print_log("+R", req.method, req.url, node.heap())
    -- setup handler of headers, if any
    -- req.onheader = function(self, name, value)
    -- o_log.print_log("+H", name, value)
    -- E.g. look for "content-type" header,
    --   setup body parser to particular format
    -- if name == "content-type" then
    --   if value == "application/json" then
    --     req.ondata = function(self, chunk) ... end
    --   elseif value == "application/x-www-form-urlencoded" then
    --     req.ondata = function(self, chunk) ... end
    --   end
    -- end
    -- end

    -- setup handler of body, if any

    req.ondata = function(self, chunk)
        o_log.print_log("+B", chunk and #chunk, node.heap())

        if not chunk then

            -- control finish to async functions
            local doFinish = true

            -- reply
            res:send(nil, 200)
            res:send_header("Connection", "close")

            if req.method == "GET" then

                -- res:send("Hello, world!\n")
                if req.url == url_data.root.url then
                    sendPage(res, url_data.root.file)
                elseif req.url == url_data.wifi.getap.url then

                    doFinish = nil

                    wifi.sta.getap(function(t)

                        res:send('[')
                        local isFirst = true

                        for name, info in pairs(t) do
                            if not isFirst then
                                res:send(',')
                            else
                                isFirst = false
                            end
                            res:send('{ "name": "' .. name .. '", "info": "' .. info .. '" }')
                        end

                        res:send(']')
                        endWork()

                    end)

                else
                    sendPage(res, url_data.not_found.file)
                end

            elseif req.method == "POST" then

                if req.url == url_data.wifi.set.url then

                    res:send('{ "ok": "true" }')

                end

            end

            -- or just do something not waiting till body (if any) comes
            -- res:finish("Hello, world!")
            -- res:finish("Salut, monde!")

            if doFinish then
                endWork()
            end
        end

    end

    function endWork()
        res:finish()
        req = nil
        res = nil
    end

end)
