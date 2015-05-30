return function (con, args, payload)
   con:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\nCache-Control: private, no-store\r\n\r\n")
   con:send('<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Post</title></head>')
   con:send('<body>')
   con:send('<h1>Post</h1>')
   local form = [===[
   <form method="POST">
      Contents:<br><textarea name="contents">test</textarea><br>
     
      <input type="submit" value="Submit">
   </form>
   ]===]

   con:send(form)

   if (args.__post ~= nil) then
		con:send("<pre>")
		con:send(args.__post)
		con:send("</pre>")
		local i = string.find(args.__post, "\r\n\r\n")
		print("p",i)
		
		local i2 = string.find(args.__post, "=", i)
		print("p2",i2)
		if(args.file and args.action and args.action=="upload") then
			con:send("<h2>writing ")
			con:send(args.file)
			con:send("</h2>")
			file.open(args.file, "w")
			file.write(string.sub(args.__post,i2))
			file.close()
		end
		args.__post = nil
	end

   con:send('<h2>Received the following values:</h2>')
   con:send("<ul>\n")
   for name, value in pairs(args) do
      if value == nil then value = "nil" end
      con:send('<li><b>' .. name .. ':</b> ' .. value .. "<br></li>\n")
   end

   con:send("</ul>\n")
   con:send('</body></html>')
end
