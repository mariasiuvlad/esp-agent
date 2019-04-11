function announce()
  udp = net.createUDPSocket()
  udp:send(10000, "192.168.0.255", "hello world")
end

function onReceive(sck, data)
  local response = sjson.encode({
    bootreason=node.bootreason(),
    chipid='' .. node.chipid(),
    meminfo='' .. node.egc.meminfo(),
    currtime='' .. rtctime.get(),
  })
  sck:send(response)
end

function onSent(sck)
  -- sck:close()
end

-- server listens on 80, if data received, print data to console and send "hello world" back to caller
-- 30s time out for a inactive client
sv = net.createServer(net.TCP, 30)
if sv then
  -- announce
  announce()
  -- listen
  sv:listen(80, function(conn)
    conn:on("sent", onSent)
    conn:on("receive", onReceive)
  end)
end
