&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        prince/issstatus.p
    
    Purpose:        Generate Issue PDF         
    
    Notes:
    
    
    When        Who         What
    11/04/2006  phoski      Initial
        
    03/08/2010  DJS         3665 - Changed to putput only the html file
                            for the email
    12/08/2010  DJS         3665a - Error in test - ll-ok not set
    
***********************************************************************/

&IF DEFINED(UIB_is_Running) EQ 0 &THEN
def input param pc-CompanyCode  as char     no-undo.
def input param pi-IssueNumber  as int      no-undo.
def input param pc-destination  as char     no-undo.
def output param pc-pdf         as char     no-undo.

&ELSE

def var pc-CompanyCode  as char     no-undo.
def var pi-IssueNumber  as int      no-undo.
def var pc-destination  as char     no-undo.
def var pc-pdf         as char     no-undo.

assign
    pc-companyCode = "MICAR"
    pi-IssueNumber = 2309
    pc-destination = "internal".
&ENDIF

{lib/princexml.i}

def buffer WebUser      for WebUser.
def buffer b-WebUser    for WebUser.
def buffer WebIssArea   for WebIssArea.
def buffer WebStatus    for WebStatus.
def buffer IssStatus    for IssStatus.
def buffer Issue        for Issue.
def buffer Customer     for Customer.

def var lc-html         as char     no-undo.
def var lc-pdf          as char     no-undo.
def var lc-Raised       as char     no-undo.
def var lc-Assigned     as char     no-undo.
def var ll-ok           as log      no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    
assign
    pc-pdf = ?.

find Issue where Issue.CompanyCode = pc-companycode
             and issue.IssueNumber = pi-IssueNumber
             no-lock no-error.
if not avail Issue then return.

find customer of Issue no-lock no-error.
if not avail Customer then return.

if Issue.RaisedLoginID <> "" then
do:
    find WebUser where WebUser.loginID = Issue.RaisedLoginID no-lock no-error.
    if avail webUser 
    then assign lc-Raised = trim(WebUser.Forename + " " + WebUser.Surname).

end.

find WebIssArea of Issue no-lock no-error.
find WebStatus of Issue no-lock no-error.

assign 
    lc-html = session:temp-dir + caps(pc-CompanyCode) + "-Issue-" + string(pi-IssueNumber).

assign 
    lc-pdf = lc-html + ".pdf"
    lc-html = lc-html + ".html".

os-delete value(lc-pdf) no-error.
os-delete value(lc-html) no-error.

dynamic-function("pxml-Initialise").
dynamic-function("pxml-OpenStream",lc-html).

dynamic-function("pxml-Header", pc-CompanyCode).

{&prince}
    '<p class="sub">Issue Number ' string(Issue.IssueNumber) '</p>' skip
    '<table class="info">' skip
    '<tr><th>Customer:</th><td>' pxml-Safe(Customer.AccountNumber) '&nbsp;' 
                pxml-Safe(Customer.name) '</td></tr>' skip
    '<tr><th>Date:</th><td>' string(Issue.IssueDate,"99/99/9999") '</td></tr>' skip
    '<tr><th>Raised By:</th><td>' pxml-Safe(lc-Raised) '</td></tr>' skip
    '<tr><th>Description:</th><td>' pxml-Safe(Issue.BriefDescription) '</td></tr>' skip
    '<tr><th>Details:</th><td>' replace(pxml-safe(Issue.LongDescription),'~n','<BR>') '</td></tr>' skip
    '<tr><th>Area:</th><td>' pxml-safe(WebIssArea.description) '</td></tr>' skip
    '<tr><th>Current Status:</th><td>' pxml-safe(WebStatus.description)
            ( if WebStatus.CompletedStatus then '&nbsp;<b>(Completed)</b>' else "" ) '</td></tr>' skip
    .

if pc-destination = "INTERNAL" then
do:
    find b-WebUser
        where b-WebUser.LoginID = Issue.AssignTo no-lock no-error.
    assign lc-Assigned =
        if avail b-WebUser
        then pxml-Safe(trim(b-webUser.Forename + " " + b-WebUser.Surname)) + 
             " " + string(Issue.AssignDate,"99/99/9999") else "&nbsp;".
    {&prince}                                                                       
        '<tr><th>Assigned To:</th><td>' lc-Assigned '</td></tr>' skip.
end.

{&prince}
    '</table>' skip.



{&prince}
    '<p class="sub">Issue History</p>' skip
    '<table class="browse">' skip
    '<thead><tr><th>Date</th><th>Time</th><th>Status</th><th>By</th></tr></thead>' skip.


for each IssStatus no-lock of Issue
    by IssStatus.ChangeDate desc
    by IssStatus.ChangeTime desc:

    find WebStatus where WebStatus.CompanyCode = Issue.Company
                     and WebStatus.StatusCode = IssStatus.NewStatusCode no-lock no-error.

    if not avail WebStatus then next.

    find b-WebUser
        where b-WebUser.LoginID = IssStatus.LoginID no-lock no-error.
    assign lc-Assigned =
        if avail b-WebUser
        then pxml-Safe(trim(b-webUser.Forename + " " + b-WebUser.Surname)) else "&nbsp;".

    {&prince} 
        '<tr>' skip
            '<td>' string(IssStatus.ChangeDate,"99/99/9999") '</td>' skip
            '<td>' string(IssStatus.ChangeTime,"hh:mm am") '</td>' skip
            '<td>' pxml-Safe(WebStatus.description) '</td>' skip
            '<td>' lc-Assigned '</td>' skip
        '</tr>' skip.

end.


{&prince} '</table>'.


dynamic-function("pxml-Footer",pc-CompanyCode).
dynamic-function("pxml-CloseStream").


/* ll-ok = dynamic-function("pxml-Convert",lc-html,lc-pdf). */

/* if ll-ok */
/* then     */
  assign pc-pdf = lc-html.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


