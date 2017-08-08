%httpHandlers
    quit

html(method,path)
    new buffer
    new lines
    new bytes
    new handler
    new line
    
    set (lines,bytes)=0
    do getHandler^%httpUtil("html",.handler)
    
    open path:readonly
    use path

    for  set lines=lines+1 read buffer(lines) set bytes=bytes+$length(buffer(lines)) quit:$zeof

    close path
    use $principal

    write $$getStatus^%httpUtil(200),terminator
    write "Server: mhttpd/0.0.1",terminator
    write "Content-Length: ",bytes,terminator
    write "Content-Type: ",handler("mime-type"),terminator
    w terminator,terminator

    for line=1:1:lines  do
    . write buffer(line),terminator 

    quit
htmleof
    close path
    

png(method,path)
    quit

jpg(method,path)
    quit

gif(method,path)
    quit

ico(method,path)
    quit

json(method,path)
    quit

javascript(method,path)
    quit

css(method,path)
    quit


    