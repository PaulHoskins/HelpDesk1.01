&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        prince/issstatusxml.p
    
    Purpose:        Generate Issue PDF         
    
    Notes:
    
    
    When        Who         What
    11/06/2011  DJS         Initial - from issstaus.p for new html emails
       
    
***********************************************************************/

&IF DEFINED(UIB_is_Running) EQ 0 &THEN
def input param pc-CompanyCode  as char     no-undo.
def input param pi-IssueNumber  as int      no-undo.
def input param pc-destination  as char     no-undo.
def output param pc-text        as char     no-undo.
def output param pc-html        as char     no-undo.

&ELSE

def var pc-CompanyCode  as char     no-undo.
def var pi-IssueNumber  as int      no-undo.
def var pc-destination  as char     no-undo.
def var pc-text         as char     no-undo.
def var pc-html         as char     no-undo.

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

def var lc-html     as char no-undo.
def var lc-text     as char no-undo.
def var odd-even    as log initial false no-undo.

 
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

/* assign                                                                                      */
/*     lc-html = session:temp-dir + caps(pc-CompanyCode) + "-Issue-" + string(pi-IssueNumber). */


/* lc-html =           dynamic-function("pxml-Email-Header", pc-CompanyCode).  */

lc-html = lc-html +     '<p class="sub" style="font-weight: bold;font-size: 15px;text-align: center;">Issue Number ' + string(Issue.IssueNumber) + '</p>' .
lc-html = lc-html +     '<table class="info" style="width: 70%;  100%;margin-left:auto;margin-right:auto;  ">' .
lc-html = lc-html +     '<tr><th style = "text-align: right;vertical-align: text-top;">Customer:</th><td style="padding-left: 10px;">' + pxml-Safe(Customer.AccountNumber) + '&nbsp;' .
lc-html = lc-html +     pxml-Safe(Customer.name) + '</td></tr>' .
lc-html = lc-html +     '<tr><th style = "text-align: right;vertical-align: text-top;">Date:</th><td style="padding-left: 10px;">' + string(Issue.IssueDate,"99/99/9999") + '</td></tr>' .
lc-html = lc-html +     '<tr><th style = "text-align: right;vertical-align: text-top;">Raised By:</th><td style="padding-left: 10px;">' + pxml-Safe(lc-Raised) + '</td></tr>' .
lc-html = lc-html +     '<tr><th style = "text-align: right;vertical-align: text-top;">Description:</th><td style="padding-left: 10px;">' + pxml-Safe(Issue.BriefDescription) + '</td></tr>' .
lc-html = lc-html +     '<tr><th style = "text-align: right;vertical-align: text-top;">Details:</th><td style="padding-left: 10px;">' + replace(pxml-safe(Issue.LongDescription),'~n','<BR>') + '</td></tr>' .
lc-html = lc-html +     '<tr><th style = "text-align: right;vertical-align: text-top;">Area:</th><td style="padding-left: 10px;">' + pxml-safe(if avail WebIssArea then string(WebIssArea.description) else "") + '</td></tr>' .
lc-html = lc-html +     '<tr><th style = "text-align: right;vertical-align: text-top;">Current Status:</th><td style="padding-left: 10px;">' + pxml-safe(if avail WebStatus then string(WebStatus.description) else "").

if avail WebStatus and WebStatus.CompletedStatus then lc-html = lc-html + '&nbsp;<b>(Completed)</b>' .
                             else lc-html = lc-html + "" . 

lc-html = lc-html +    '</td></tr>' .
 
lc-text =               'Issue Number ' + string(Issue.IssueNumber) + '~n~n' .

lc-text = lc-text +     'Customer:~t~t' + pxml-Safe(Customer.AccountNumber) + '~t' .
lc-text = lc-text +     pxml-Safe(Customer.name) + '~n' .
lc-text = lc-text +     'Date:~t~t~t' + string(Issue.IssueDate,"99/99/9999") + '~n' .
lc-text = lc-text +     'Raised By:~t~t' + pxml-Safe(lc-Raised) + '~n' .
lc-text = lc-text +     'Description:~t~t' + pxml-Safe(Issue.BriefDescription) + '~n' .
lc-text = lc-text +     'Details:~t~t' + replace(pxml-safe(Issue.LongDescription),'~n','<BR>') + '~n' .
lc-text = lc-text +     'Area:~t~t~t' + pxml-safe(if avail WebIssArea then string(WebIssArea.description) else "") + '~n' .
lc-text = lc-text +     'Current Status:~t~t' + pxml-safe(if avail WebStatus then string(WebStatus.description) else "").

if avail WebStatus and WebStatus.CompletedStatus then lc-text = lc-text + ' (Completed) ~n~n' .
                             else lc-text = lc-text + '~n~n' .






if pc-destination = "INTERNAL" then
do:
    find b-WebUser
        where b-WebUser.LoginID = Issue.AssignTo no-lock no-error.
    assign lc-Assigned = if avail b-WebUser then pxml-Safe(trim(b-webUser.Forename + " " + b-WebUser.Surname)) + " " + string(Issue.AssignDate,"99/99/9999") else "&nbsp;"
           lc-html = lc-html + '<tr><th style = "text-align: right;vertical-align: text-top;">Assigned To:</th><td style="padding-left: 10px;">' + lc-Assigned + '</td></tr>'
           lc-text = lc-text + 'Assigned To:~t' + lc-Assigned + '~n' .
end.

lc-html = lc-html + '</table>' .
lc-html = lc-html + '<p class="sub" style="font-weight: bold;font-size: 15px;text-align: center;">Issue History</p>'.
lc-html = lc-html + '<table class="browse" style="width: 100%;border: 1px solid black;">' .
lc-html = lc-html + '<thead style="background-color: #DFDFDF;"><tr><th>Date</th><th>Time</th><th>Status</th><th>By</th></tr></thead>' .

lc-text = lc-text + 'Issue History ~n'.
lc-text = lc-text + 'Date~t~tTime~t~tStatus~t~tBy ~n~n' .


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

 
        lc-html = lc-html + '<tr ' + if odd-even then 'style="background-color: #F2F2F2;        border-top: 1px solid black;"' else ''  +  ' >' .
        lc-html = lc-html +     '<td>' + string(IssStatus.ChangeDate,"99/99/9999") + '</td>' .
        lc-html = lc-html +     '<td>' + string(IssStatus.ChangeTime,"hh:mm am") + '</td>'. 
        lc-html = lc-html +     '<td>' + pxml-Safe(WebStatus.description) + '</td>'. 
        lc-html = lc-html +     '<td>' + lc-Assigned + '</td>' .
        lc-html = lc-html + '</tr>' .
        odd-even = odd-even = false.


        lc-text = lc-text + string(IssStatus.ChangeDate,"99/99/9999") + '~t' .
        lc-text = lc-text + string(IssStatus.ChangeTime,"hh:mm am")  + '~t' .
        lc-text = lc-text + pxml-Safe(WebStatus.description)  + '~t' .
        lc-text = lc-text + lc-Assigned  + '~n' .


end.


lc-html = lc-html + '</table><br /><br />'.


assign pc-html = lc-html
       pc-text = lc-text.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


