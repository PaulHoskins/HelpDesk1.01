{lib/maillib.i}
{lib/princexml.i} 

    def var pc-CompanyCode      as char no-undo.
    def var pi-IssueNumber      as int no-undo.
    def var pc-user             as char no-undo.
    def var pc-old-statuscode   as char no-undo.
    def var pc-new-statuscode   as char no-undo.

    def buffer IssStatus    for IssStatus.
    def buffer Issue        for Issue.
    def buffer WebStatus    for WebStatus.
    def buffer WebNote      for WebNote.
    def buffer WebUser      for WebUser.
    def buffer Company      for Company.

    def var lc-loginid      as char no-undo.
        
    def var lc-text         as char     no-undo.
    def var lc-html         as char     no-undo.
    def var lc-header       as char     no-undo.




              run prince/issstatusxml.p
                (
                    "ourit2",
                    1039,
                    "CUSTOMER",
                    output lc-text,
                    output lc-html 
                    ).

/* output to "c:\temp\djsone.txt".  */
/*   put unformatted lc-text skip.  */
/* output close.                    */
/* output to "c:\temp\djstwo.txt".  */
/*   put unformatted lc-html skip.  */
/* output close.                    */

lc-header =  dynamic-function("pxml-Email-Header", "ourit2").

message lc-header
  view-as alert-box info buttons OK.

              dynamic-function("mlib-SendMultipartEmail",
                    "Ourit2",
                    "",
                    if pc-old-StatusCode = ""
                    then "New Issue Raised " + string(1040)
                    else "Status Change For Issue " + string(1040)
                    ,
                    'Dear ' 
                    + "David"
                    + ',~n~n' 
                    + 'Please find attached details of the issue you have logged with '
                    + "Ourit2" 
                    + '.~n' 
                    + lc-text
                    ,
                    lc-header
                    + '<div id="content" style="border-top: 1px solid black;" ><br /><br /><br /><p>' 
                    + 'Dear ' 
                    + "David" 
                    + '</p><p>' 
                    + 'Please find attached details of the issue you have logged with '
                    + "Ourit2" 
                    + '<p/><br />' 
                    + lc-html
                    ,
                    "onebob@gmail.com"
                    ).






