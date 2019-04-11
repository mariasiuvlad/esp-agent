sv2 = net.createServer(net.TCP, 30)
if sv2 then
  sv2:listen(8080, function(conn)
    local size = 0
    local currentSize = 0
    -- onReceive
    conn:on("receive", function(s, chunk)
      num = tonumber(chunk)
      if num ~= nil then -- save message size
        size = num
        file.open("app.lua", "w+")
      else
        if not size then -- size was not received before handling message
          s:send("err")
        end
        file.write(chunk)
        currentSize = currentSize + #chunk
        if (currentSize >= size) then -- end of message reached
          s:send("ok") -- triggers "sent" handler
        end
      end
    end)
    -- onReceive ends
    conn:on("sent", function(s) -- onSent
      s:close()
      file.flush()
      file.close()
      node.restart()
    end)
    -- onSent ends
  end)
end
