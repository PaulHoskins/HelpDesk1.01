{src/web/method/wrap-cgi.i}

def var lc-global-helpdesk      as char no-undo.
def var lc-global-reportpath    as char no-undo.
def var lc-docid                as char no-undo.
def var lc-doctype              as char no-undo.
def var lb-blob                 as raw  no-undo.
def var li-line                 as int  no-undo.

def temp-table newdoc like docl.

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "BATCHPATH"
no-lock no-error.
assign lc-global-helpdesk =  WebAttr.AttrValue .

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "REPORTPATH"
no-lock no-error.
assign lc-global-reportpath =  WebAttr.AttrValue .

assign lc-docid = get-value("docid").

assign lc-docid = string(lc-global-reportpath + "\" + lc-docid + ".xls")
       lc-doctype = "xls".


assign length(lb-blob) = 16384.
input from value(lc-docid) binary no-map no-convert.
repeat:
    import unformatted lb-blob.
    assign li-line = li-line + 1.
    create newdoc.
    assign newdoc.DocID   = 1
           newdoc.Lineno  = li-line
           newdoc.rdata   = lb-blob.
end.
input close.
assign length(lb-blob) = 0.

case lc-doctype:
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
            run ip-Error("Unknown content type of " + lc-docid).
            return.
        end.
end case.

for each newdoc where newdoc.docid = 1 no-lock:
    put {&WEBSTREAM} control newdoc.rdata.
end.



procedure ip-Error:
    def input param pc-error as char no-undo.
    output-content-type("text/html").
    put {&webstream} unformatted
        '<html><head><title>Document Error</title></head>'
        '<body>'
        '<h1>This document can not be displayed</h1><br>'
        '<h2>Document ID =' lc-docid '</h2><br>'
        '<h2>' pc-error '</h2></body></html>' skip.
    return.
end procedure.
