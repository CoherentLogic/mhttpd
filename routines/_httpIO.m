%httpIO
    quit

fileExtension(fileName)
 quit $piece(fileName,".",$length(fileName,"."))

fileExists(fileName)
    if $zsearch(fileName)=fileName quit 1
    quit 0