%HTTPD
 N TERM S TERM=$C(13,10)
 N REQ,RES,VERB,RSRC,HOST
 R REQ
 S VERB=$P(REQ," ",1),RSRC=$P(REQ," ",2)
 D:VERB="GET" GET(RSRC)
 D:VERB="POST" POST(RSRC)
 QUIT
 ;
 ;
GET(RESOURCE)
 D STATUS(200)
 QUIT
 ;
 ;
POST(RESOURCE)
 QUIT
 ;
 ;
STATUS(CODE)
 S STATUS(100)="Continue"
 S STATUS(101)="Switching Protocols"
 S STATUS(200)="OK"
 S STATUS(201)="Created"
 S STATUS(202)="Accepted"
 S STATUS(203)="Non-Authoritative Information"
 S STATUS(204)="No Content"
 S STATUS(205)="Reset Content"
 S STATUS(206)="Partial Content"
 S STATUS(300)="Multiple Choices"
 S STATUS(301)="Moved Permanently"
 S STATUS(302)="Found"
 S STATUS(303)="See Other"
 W "HTTP/1.1 ",CODE," ",STATUS(CODE),TERM
 QUIT
 ;
 ;