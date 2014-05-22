/***********************************************************************

    Program:        rep/deleteview.p
    
    Purpose:        Management Report -  - Delete Reports
    
    Notes:
    
    
    When        Who         What
    10/11/2010  DJS         Initial
    
***********************************************************************/


{src/web/method/wrap-cgi.i}

def var lc-global-helpdesk      as char no-undo.
def var lc-global-reportpath    as char no-undo.
def var lc-docid                as char no-undo.
def var lc-doctype              as char no-undo.
def var lb-blob                 as raw  no-undo.
def var li-line                 as int  no-undo.
def var lc-webuser              as char no-undo.

def temp-table newdoc like docl.

  output to "C:\temp\djs.txt" append.
  put unformatted 
    "lc-docid                "  lc-docid skip
    "lc-global-helpdesk      "  lc-global-helpdesk skip
    "lc-global-reportpath    "  lc-global-reportpath skip(2).
  output close.




find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "BATCHPATH"
no-lock no-error.
assign lc-global-helpdesk =  WebAttr.AttrValue .

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "REPORTPATH"
no-lock no-error.
assign lc-global-reportpath =  WebAttr.AttrValue .

assign lc-docid = get-value("rowid").

find first BatchWork where rowid(BatchWork) = to-rowid(lc-docid) no-error. 

if avail BatchWork then 
do: 
  assign BatchWork.BatchDelete = true
         lc-webuser = BatchWork.BatchUser
         lc-docid   = string(lc-global-reportpath + "\" + string(BatchWork.batchID) + "_" + BatchWork.Description + ".xls").

  output to "C:\temp\djs.txt" append.
  put unformatted 
    "lc-docid                "  lc-docid skip
    "lc-global-helpdesk      "  lc-global-helpdesk skip
    "lc-global-reportpath    "  lc-global-reportpath skip
    "BatchWork.batchID       "  BatchWork.batchID skip
    "BatchWork.Description   "  BatchWork.Description skip(2).
  
  output close.

  os-delete value(lc-docid) no-error.
  delete BatchWork.
  RUN run-web-object IN web-utilities-hdl ("rep/engrep01.p").
  return .
end.
else
do:
  output-content-type("text/html").
  put {&webstream} unformatted
      '<html><head><title>Document Error</title></head>'
      '<body>'
      '<h1>This document can not be deleted</h1><br>'
      '<h2>Document ID = ' lc-docid '</h2><br>'
      '<h2> Please contact your system administrator. </h2></body></html>' skip.
  return .
end.

