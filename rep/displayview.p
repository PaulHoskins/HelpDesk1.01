/***********************************************************************

    Program:        rep/displayview.p
    
    Purpose:        Management Report -  Display Report detail
    
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
def var TYPEOF                  as char initial "Detail,Summary_Detail,Summary" no-undo.
def var ISSUE                   as char initial "Customer,Engineer,Issues"  no-undo.
def var CAL                     as char initial "Week,Month" no-undo.
 

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "BATCHPATH"
no-lock no-error.
assign lc-global-helpdesk =  WebAttr.AttrValue .

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "REPORTPATH"
no-lock no-error.
assign lc-global-reportpath =  WebAttr.AttrValue .

assign lc-docid = get-value("docid").

find first BatchWork where rowid(BatchWork) = to-rowid(lc-docid) no-lock no-error.

  output-content-type("text/html").
  put {&webstream} unformatted
      '<html><head><title>Document Details</title></head>' skip
      '<body>' skip
      '<h2> Details for batch ' string(BatchWork.BatchID) ' </h2><br /> ' skip
      ' Run date: ' string(BatchWork.BatchDate,"99/99/9999")  ' Time: ' string(BatchWork.BatchTime,"HH:MM")  '<br /> ' skip
      ' <br /> ' skip
      ' Description : ' BatchWork.Description ' <br /> ' skip
      ' View : '        entry(integer(BatchWork.BatchParams[2]),TYPEOF) ' <br /> ' skip
      ' For :  '        entry(integer(BatchWork.BatchParams[3]),ISSUE) ' <br /> ' skip
      ' By : '          entry(integer(BatchWork.BatchParams[4]),CAL) ' <br /> ' skip.

      if BatchWork.BatchParams[3] = "2" then  put {&webstream} unformatted ' Engineers : '   BatchWork.BatchParams[5] ' <br /> ' skip.
        else  put {&webstream} unformatted ' Customers : '   BatchWork.BatchParams[6] ' <br /> ' skip.
  put {&webstream} unformatted
      ' Period : '      BatchWork.BatchParams[7] ' <br /> <br />' skip
      '<input   type="button" id=closebutton value="Close"    name="ButtonClose" onclick="javascript:window.close()"  class="button">'  skip
      ' </body></html>' skip.


 
 


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
