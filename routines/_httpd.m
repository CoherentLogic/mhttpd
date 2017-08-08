%httpd
    ; initialize our variables
    new request,resource,verb,raw,name,value,i

    ; check for defaults
    do checkDefaults^%httpUtil
    
    ; set up basic environment
    set terminator=$char(13,10)
    set httpVersion="1.0"
    
    ; read the request from the socket
    read request
    
    ; parse out the http verb and resource string
    set verb=$piece(request," ",1)
    set resource=$piece(request," ",2)
    
    ; if we have a third part of the request denoting version, set the version accordingly
    if $length(request," ")>2 do 
    . set:$extract($piece(request," ",3),1,8)="HTTP/1.1" httpVersion="1.1"

    ; parse http headers
    for i=2:1:$length(request,terminator) do
    . set raw=$piece(request,terminator,i)
    . set name=$piece(raw,": ",1)
    . set value=$piece(raw,": ",2)
    . do:name'="" setRequestHeader^%httpUtil(name,value)
    
    ; bring in any virtual host configuration
    set:$data(requestHeaders("Host")) host=$piece(requestHeaders("Host"),":",1)
    set:'$data(requestHeaders("Host")) host="default"
    if $data(^%httpd("config","sites",host)) do
    . kill config
    . merge config=^%httpd("config","sites",host)
    else  do
    . set host="default"
    . kill config
    . merge config=^%httpd("config","sites",host)

    ; perform the requested http verb
    do:verb="GET" httpGet(resource)
    do:verb="POST" httpPost(resource)
    quit

;**
; httpGet -- service a GET request
;  urlPath: the path of the requested resource  
;
httpGet(urlPath)

    ; set up local variables
    new candidateCount,requestStatus,candidates,candidate,file,extension,handler
    new handlerRoutine,exec
    set requestStatus=""
    set candidate=""
    
    ; translate the path into a filesystem path and get array of candidates to try
    set candidateCount=$$translatePath^%httpUtil(urlPath,.candidates)

    ; loop through the candidates and find the first one that exists
    for  set candidate=$order(candidates(candidate)) quit:candidate=""  do
    . if $$fileExists^%httpIO(candidates(candidate)) do
    . . set file=candidates(candidate)
    . . set extension=$$fileExtension^%httpIO(file)
    . . do getHandler^%httpUtil(extension,.handler)
    . . set handlerRoutine=handler("routine")
    . . set exec="do "_handlerRoutine_"(""GET"","""_file_""")"
    . . xecute exec

    quit

;**
; httpPost -- service a POST request
;  urlPath: the path of the requested resource  
;
httpPost(urlPath)
 quit



