/*  for each batchwork:           */
/*   update batchwork with 1 col. */
/* end.                           */
/*                                */
/*                                */
/*                                */

def var lc-global-helpdesk    as char no-undo.
def var lc-global-reportpath  as char no-undo.

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "BATCHPATH"
no-lock no-error.
assign lc-global-helpdesk =  WebAttr.AttrValue .

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "REPORTPATH"
no-lock no-error.
assign lc-global-reportpath =  WebAttr.AttrValue .

message lc-global-helpdesk skip lc-global-reportpath
  view-as alert-box info buttons OK.
                                                                                                                         
for each BatchWork where BatchRun <> true
  no-lock: 
  
  os-command  silent value("start /min " + lc-global-helpdesk + "\batchwork.bat " + string(batchid)).
  INNER: repeat :
  if BatchRun <> true then 
  do:
    pause 10 no-message.
    next INNER.
  end.
  else leave INNER.

  end.

end.
