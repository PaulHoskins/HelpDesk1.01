{src/web/method/wrap-cgi.i}

def var li-docid as int no-undo.

assign li-docid = dec(get-value("docid")).

find doch where doch.docid = li-docid no-lock no-error.

if not avail doch then
do:
    run ip-Error("Missing document").
    return.
end.

case doch.doctype:
    when "PDF" then output-content-type("application/pdf").
    when "DOC" 
    or when "DOT" then output-content-type("application/msword").
    when "HTM"  
    or when "HTML" then output-content-type("text/html").
    when "XLS" 
    or when "XLT" 
    or when "XLTX" then output-content-type("application/vnd.ms-excel").
    when "TXT" then output-content-type("text/plain~;charset=iso-8859-1").
    when "INI"
    or when "D"
    or when "DF" then output-content-type("text/plain").
    when "PPT" then output-content-type("application/ms-powerpoint").
    when "PNG" then output-content-type("image/png").
    when "GIF" then output-content-type("image/gif").
    when "jpe"
    or when "jpg"
    or when "jpeg" then output-content-type("image/jpeg").
    when "XML" then output-content-type("text/xml").
    when "ZIP" then output-content-type("application/zip").
    WHEN "msg" THEN output-content-type("application/vnd.ms-outlook").
    otherwise
        do:
            output-content-type("application/" + lc(doch.doctype)).
            /*
            run ip-Error("Unknown content type of " + doch.doctype).
            return.
            */
        end.
end case.

for each docl where docl.docid = li-docid no-lock:
    put {&WEBSTREAM} control docl.rdata.
end.

procedure ip-Error:

    def input param pc-error as char no-undo.

    output-content-type("text/html").

    put {&webstream} unformatted
        '<html><head><title>Document Error</title></head>'
        '<body>'
        '<h1>This document can not be displayed</h1><br>'
        '<h2>Document ID =' li-docid '</h2><br>'
        '<h2>' pc-error '</h2></body></html>' skip.

    return.

end procedure.
