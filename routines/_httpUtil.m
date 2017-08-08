%httpUtil
    quit

;**
; setConfig -- set a configuration value
;
setConfig(name,value)
    set ^%httpd("config","sites",host,name)=value
    quit


;**
; getConfig -- get a configuration value
;
getConfig(name)
    quit $get(^%httpd("config","sites",host,name))

;**
; setRequestHeader -- set a request header
;
setRequestHeader(name,value)
    set requestHeaders(name)=value
    quit


;**
; getRequestHeader -- get the value of a request header
;
getRequestHeader(name)
    quit $get(requestHeaders(name))


writeLog(message)

    ; set up local variables
    new horolog
    set horolog=$horolog
 
    set ^%httpdLog(horolog,$job)=$zdate(horolog)_": "_message

    quit

;**
; translatePath -- translates the path segment of a URL to a filesystem path
;  urlPath:     the path to be translated
;  candidates:  (by reference) an array of paths to try
;
translatePath(urlPath,candidates)

    ; set up local variables
    new path,documentRoot,counter,index
    set index="",counter=1

    set documentRoot=config("documentRoot")
   
    ; if we're looking at a path with no file, assume we need to fetch
    ; the directory index from config("index")
    if $$isDirectoryIndex(urlPath) do
    . for  set index=$order(config("index",index)) quit:index=""  do
    . . set candidates(counter)=$$normalizePath(documentRoot,urlPath,config("index",index))
    . . set counter=counter+1
    else  do
    . set counter=1
    . set candidates(counter)=$$normalizePath(documentRoot,urlPath,"")

    quit counter

isDirectoryIndex(path)
    if $extract(path,$length(path))="/" quit 1
    quit 0

lastChar(str)
    quit $extract(str,$length(str))

firstChar(str)
    quit $extract(str,1)

normalizePath(first,second,third)

    ; set up local vars
    new result,tmp,i,char,last
    set tmp=first_"/"_second_"/"_third
    set (result,last)=""

    for i=1:1:$l(tmp)  do
    . set char=$extract(tmp,i) 
    . if '((char="/")&(last="/")) do
    . . set result=result_char
    . set last=char
    
    quit result

getHandler(extension,handler)
    merge handler=config("handlers",extension)
    quit

;**
; getStatus -- get the appropriate status message
;
getStatus(statusCode)

    ; set up local vars
    new statusCodes

    ; build a table of status codes
    set statusCodes(100)="Continue"
    set statusCodes(101)="Switching Protocols"
    set statusCodes(200)="OK"
    set statusCodes(201)="Created"
    set statusCodes(202)="Accepted"
    set statusCodes(203)="Non-Authoritative Information"
    set statusCodes(204)="No Content"
    set statusCodes(205)="Reset Content"
    set statusCodes(206)="Partial Content"
    set statusCodes(300)="Multiple Choices"
    set statusCodes(301)="Moved Permanently"
    set statusCodes(302)="Found"
    set statusCodes(303)="See Other"
    set statusCodes(404)="Not Found"
    set statusCodes(500)="Internal Server Error"

    quit "HTTP/"_httpVersion_" "_statusCode_" "_statusCodes(statusCode)


;**
; checkDefaults -- set up sane defaults if no such defaults exist
;
checkDefaults

    ; set default document root
    if '$data(^%httpd("config","sites","default","documentRoot")) do
    . s ^%httpd("config","sites","default","documentRoot")="/var/www/html"

    ; set default index configuration
    if '$data(^%httpd("config","index")) do
    . set ^%httpd("config","sites","default","index",1)="index.html"
    . set ^(2)="index.htm"

    ; set default handlers
    if '$data(^%httpd("config","sites","default","handlers","html")) do
    . set ^%httpd("config","sites","default","handlers","html","routine")="html^%httpHandlers"
    . set ^("mime-type")="text/html"

    quit
