/* Do not use a CGI variable for the file name */
{src/web/method/wrap-cgi.i}
def var lc-pdf as char no-undo.
assign lc-pdf = get-value("PDF").
assign lc-pdf = session:temp-dir + lc-pdf.
define stream infile.
define variable vdata as raw no-undo.


output-content-type("application/pdf").
input stream infile from value(lc-pdf) binary.
length(vdata) = 512.
repeat:
    import stream infile unformatted vdata.
    put {&WEBSTREAM} control vdata.
end.
length(vdata) = 0.
input stream infile close.
os-delete value(lc-pdf) no-error.




