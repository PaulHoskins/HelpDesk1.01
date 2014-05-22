&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        batch/slaprocess.p
    
    Purpose:        SLA Processing
    
    Notes:
    
    
    When        Who         What
    12/05/2006  phoski      Initial

***********************************************************************/

{lib/common.i}
{iss/issue.i}

def buffer Issue        for Issue.
def buffer ro-Issue     for Issue.
def buffer IssAlert     for IssAlert.
def buffer Company      for Company.
def buffer SLAhead      for slahead.
def buffer WebUser      for WebUser.

def stream s-log.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnLog Procedure 
FUNCTION fnLog RETURNS LOGICAL
  ( pc-data as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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

def var ld-date             as date         no-undo.
def var li-time             as int          no-undo.
def var li-level            as int          no-undo.
def var li-loop             as int          no-undo.

def var lc-Description      as char         no-undo.
def var ld-Alert            as date         no-undo.
def var lc-Time             as char         no-undo.
def var lc-details          as char         no-undo.
def var lc-NoteCode         as char         no-undo.
def var ll-SLAMissed        as log          no-undo.
def var lc-System           as char         no-undo.
def var ll-email            as log          no-undo.
def var lc-mail             as char         no-undo.
def var ll-sms              as log          no-undo.
def var lc-subject          as char         no-undo.
def var lc-Dest             as char         no-undo.

DEF VAR ldt-Level2      AS DATETIME NO-UNDO.
DEF VAR ldt-Amber2      AS DATETIME NO-UNDO.
DEF VAR li-Mill         AS INT      NO-UNDO.
DEF VAR lc-dt           AS CHAR     NO-UNDO.


output stream s-log to value(session:temp-dir + "/sla-batch.log") UNBUFFERED Append.

fnLog("SLA Batch Begins").

assign
    lc-System = "SLA.ALERT".

for each ro-Issue no-lock
    where ro-Issue.SLAStatus = "ON" transaction:
    
    find Issue
        where rowid(Issue) = rowid(ro-Issue) exclusive-lock no-wait no-error.
    if locked Issue then next.

    /*
    fnlog ( "check " + Issue.companycode + " " + STRING(Issue.issuenumber)).
    */

    if DYNAMIC-FUNCTION('islib-IssueIsOpen':U,rowid(Issue)) = false
    or Issue.link-SLAID = ?
    or Issue.link-SLAID = 0 
    or not can-find(slahead where slahead.SLAID = Issue.link-SLAID ) 
    or Issue.SLADate[1] = ? then
    do:
        dynamic-function("islib-RemoveAlerts",rowid(Issue)).
        assign
            Issue.SLAStatus = "OFF"
            issue.tlight = li-global-sla-na.
            .
        release Issue.
        next.
    end.

    FIND slahead WHERE slahead.SLAID = Issue.link-SLAID NO-LOCK NO-ERROR.

    assign
        ld-date = today
        li-time = TIME
        issue.tlight = li-global-sla-ok.


    IF issue.slaDate[2] <> ? THEN
    DO:
        lc-dt = STRING(Issue.SLADate[2],"99/99/9999") + " " 
            + STRING(Issue.SLATime[2],"HH:MM").
        ldt-level2 = DATETIME(lc-dt).
        ASSIGN 
            issue.SLATrip = ldt-Level2
            issue.SLAAmber = ?.

        IF slahead.amberWarning > 0 THEN
        DO:
            li-mill = (  slahead.amberWarning * 60 ) * 1000.
            ldt-Amber2 = ldt-Level2 - li-Mill.
            issue.slaamber = ldt-Amber2.
            

        END.


    END.

    /*
    ***
    *** Has the SLA Started? 
    ***
    */
    if Issue.SLADate[1] > ld-date then next.

    if Issue.SLADate[1] = ld-date
    and Issue.SLATime[1] > li-time then 
    DO:
       next.
    END.

    /*
    *** SLA LEvel 2 is the tripwire 
    */
   


    IF issue.slaDate[2] <> ? THEN
    DO:
        lc-dt = STRING(Issue.SLADate[2],"99/99/9999") + " " 
            + STRING(Issue.SLATime[2],"HH:MM").
        ldt-Level2 = DATETIME(lc-dt).

        IF ldt-level2 <= NOW 
        THEN ASSIGN issue.tlight = li-global-sla-fail.
        ELSE
        IF slahead.amberWarning > 0 THEN
        DO:
         
            IF NOW >= issue.slaamber
            THEN ASSIGN issue.tlight = li-global-sla-amber.


        END.


    END.
    ELSE ASSIGN issue.tlight = li-global-sla-fail.



    /*
    fnlog ( "check " + Issue.companycode + " " + STRING(Issue.issuenumber)).
    */
    /*
    ***
    *** Alerts done to final level?
    ***
    */
    if Issue.SLALevel = 10
    or Issue.SLADate[Issue.SLALevel + 1] = ? then
    do:
       next.
    end.
        
    /*
    ***
    *** Now find out the level I'm at 
    ***
    */
    assign
        li-Level = 0.

    do li-loop = 1 to 10:
        if Issue.SLADate[li-loop] = ? 
        or Issue.SLADate[li-loop] > ld-date then leave.
        if Issue.SLADate[li-loop] = ld-date
        and Issue.SLATime[li-loop] > li-time then leave.
        assign
            li-level = li-loop.

    end.
    /*
    ***
    *** If calculated level is <= current level then nothing to do
    ***
    */
    if li-level <= Issue.SLALevel then next.

    /*
    ***
    *** Need to create an alert
    ***
    */
    find sla where sla.SLAID = Issue.link-SLAID no-lock no-error.
    /*
    *** 
    *** SLA has been changed so do something
    ***
    */
    if sla.RespDesc[li-level] = "" then
    do:
        next.
    end.

    if li-level = 10
    or Issue.SLADate[li-level + 1] = ? 
    then assign ll-SLAMissed = true.
    else assign ll-SLAMissed = false.

    assign
        lc-details = "SLA Details " + 
                     sla.RespDesc[li-level] + " Due " + 
                     string(Issue.SLADate[li-level],'99/99/9999') +
                     ' ' + 
                     string(Issue.SLATime[li-level],'hh:mm am').
    if not ll-SLAMissed then
    do:
        if sla.RespDesc[li-level + 1] <> "" then
        do:
            assign
                lc-details = lc-details + "~n" +
                         "Next alert will be " +
                         sla.RespDesc[li-level + 1] + " at " +
                         string(Issue.SLADate[li-level + 1],'99/99/9999') +
                         ' ' + 
                         string(Issue.SLATime[li-level + 1],'hh:mm am').
        end.
    end.
    run islib-CreateNote( Issue.CompanyCode,
                          Issue.IssueNumber,
                          lc-system,
                          if ll-SLAMissed
                          then 'SYS.SLAMISSED' else 'SYS.SLAWARN',
                          lc-details).    
    assign
        ll-Email = sla.RespAction[li-level] begins "email"
        ll-sms   = can-do("EmailPage,Page",sla.RespAction[li-level]).
                   
    find customer of Issue no-lock no-error.

    /*
    ***
    *** Kill any existing alerts for the issue
    ***
    */
    dynamic-function("islib-RemoveAlerts",rowid(Issue)).
    /*
    ***
    *** Need to send alerts to the users on SLA plus the
    *** person its assigned too
    ***
    ***
    */
    assign
        lc-dest = sla.RespDest[li-level].
    if Issue.AssignTo <> ""
    and can-do(lc-dest,Issue.AssignTo) = false then 
    do:
        if lc-dest = ""
        then assign lc-dest = Issue.AssignTo.
        else assign lc-dest = lc-dest + "," + Issue.AssignTo.
    end.
    if lc-dest <> "" then
    do li-loop = 1 to num-entries(lc-dest) with frame f-dest:

        find webuser
                where webuser.LoginID = entry(li-loop,lc-dest)
                      no-lock no-error.
        if not avail WebUser then next.

        /*
        ***
        *** Always create a webpage alert 
        ***
        */
        create IssAlert.
        assign 
            IssAlert.CompanyCode    = Issue.CompanyCode
            IssAlert.IssueNumber    = Issue.IssueNumber
            IssAlert.LoginID        = webuser.LoginID
            IssAlert.SLALevel       = li-level
            IssAlert.CreateDate     = ld-date
            IssAlert.CreateTime     = li-time.
        
        
        /*
        ***
        *** SMS Alerts
        ***
        */
        if ll-sms and webuser.Mobile <> "" 
        and webUser.allowSMS then
        do:
            assign lc-mail = "Issue: " + string(Issue.IssueNumber) 
                                + ' ' + Issue.BriefDescription + " " + 
                                "Customer: " + customer.name.
            assign lc-mail = lc-mail + "~n" + lc-details.

            create SMSQueue.
            assign
                SMSQueue.CompanyCode = Issue.CompanyCode
                SMSQueue.IssueNumber = Issue.IssueNumber
                SMSQueue.QStatus    = 0
                SMSQueue.CreateDate = ld-date
                SMSQueue.CreateTime = li-time
                SMSQueue.CreatedBy  = lc-System
                SMSQueue.SendTo     = webuser.LoginID
                SMSQueue.Msg        = lc-mail
                SMSQueue.Mobile     = webuser.Mobile
                .
           
            
        end.

        /*
        ***
        *** Email Alerts
        ***
        */
        if ll-email and webUser.Email <> "" then
        do:

            assign lc-mail = "Issue: " + string(Issue.IssueNumber) 
                                + ' ' + Issue.BriefDescription + "~n" + 
                                "Customer: " + customer.name.
            if Issue.LongDescription <> "" 
            then lc-mail = lc-mail + "~n" + Issue.LongDescription.
    
            assign lc-mail = lc-mail + "~n~n~n" + lc-details.
    
            if Issue.AssignTo <> ""
            then assign lc-mail = lc-mail + "~n~n~nAssigned to " + com-UserName(Issue.AssignTo) 
                + ' at ' 
                + string(Issue.AssignDate,'99/99/9999') + 
                ' ' + string(Issue.AssignTime,'hh:mm am')
                .
            assign lc-subject = "SLA Alert for " + "Issue " + string(Issue.IssueNumber) +
                   ' - Customer ' + Customer.name.

             dynamic-function("mlib-SendEmail",
                             Issue.Company,
                             "",
                             lc-Subject,
                             lc-mail,
                             WebUser.email).
        end.
        
    end.

    /*
    ***
    *** Everything done for this Issue/Alert so set the alert level
    ***
    */
    assign
        Issue.SLALevel = li-Level.
end.

fnLog("SLA Batch Ends").

output stream s-log close.

quit.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnLog Procedure 
FUNCTION fnLog RETURNS LOGICAL
  ( pc-data as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    put stream s-log unformatted
        string(today,"99/99/9999") " " 
        string(time,"hh:mm:ss") "  -  " pc-data skip.
  
    return true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

