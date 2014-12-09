/***********************************************************************

    Program:        batch/renewals.p
    
    Purpose:        Renewals Processing
    
    Notes:
    
    
    When        Who         What
    03/09/2010  DJS         Initial build

***********************************************************************/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
  
{lib/common.i}
{iss/issue.i}
{lib/ticket.i}
/* {lib/htmlib.i} */

lc-global-company = TRIM(OS-GETENV("COMPANYCODE")).
IF lc-global-company = ?
    OR lc-global-company = "" THEN lc-global-company = "ouritdept".

lc-global-user = TRIM(OS-GETENV("BATCHID")).
IF lc-global-user = ? 
    OR lc-global-user = "" THEN lc-global-user = "BATCH".


DEFINE VARIABLE lc-error-field      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-error-msg        AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-accountnumber    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-briefdescription AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-longdescription  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-submitsource     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-raisedlogin      AS CHARACTER NO-UNDO.
DEFINE VARIABLE li-issue            AS INTEGER   NO-UNDO.
DEFINE VARIABLE lc-date             AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-AreaCode         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-Address          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-Ticket           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-title            AS CHARACTER NO-UNDO.


DEFINE VARIABLE lc-list-number      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-name        AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-list-login       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-lname       AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-list-area        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-aname       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-gotomaint        AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-sla-rows         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-sla-selected     AS CHARACTER NO-UNDO.
DEFINE VARIABLE ll-customer         AS LOG       NO-UNDO.

DEFINE VARIABLE lc-default-catcode  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-catcode          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-catcode     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-cname       AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-issuesource      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-emailid          AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-list-actcode     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-actdesc     AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-custivid         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-subivid          AS CHARACTER NO-UNDO.
 
 
/* Action Stuff */

DEFINE VARIABLE lc-Quick            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-actioncode       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-ActionNote       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-CustomerView     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-actionstatus     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-assign      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-assname     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-currentassign    AS CHARACTER NO-UNDO.

/* Activity */
DEFINE VARIABLE lc-hours            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-mins             AS CHARACTER NO-UNDO.
DEFINE VARIABLE li-hours            AS INTEGER   NO-UNDO.
DEFINE VARIABLE li-mins             AS INTEGER   NO-UNDO.
DEFINE VARIABLE lc-StartDate        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-starthour        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-startmin         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-endDate          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-endhour          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-endmin           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-ActDescription   AS CHARACTER NO-UNDO.

/* Status */
DEFINE VARIABLE lc-list-status      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-sname       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-currentstatus    AS CHARACTER NO-UNDO.


DEFINE VARIABLE lc-htmldesc         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cdate               AS CHARACTER FORMAT "x(16)" NO-UNDO.
DEFINE VARIABLE ddate               AS DATE      FORMAT "99/99/9999" INITIAL 01/01/1999 NO-UNDO.
DEFINE VARIABLE firstCustI          AS LOG       INITIAL TRUE NO-UNDO.



DEFINE BUFFER b-ivSub   FOR ivSub.
DEFINE BUFFER b-CustIv  FOR CustIv.
DEFINE BUFFER b-ivField FOR ivField.

DEFINE VARIABLE lf-Audit AS DECIMAL NO-UNDO.

DEFINE STREAM repOutStream .




/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no





/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-checkdate) = 0 &THEN

FUNCTION checkdate RETURNS DATE
    (chkdate AS CHARACTER, lang AS CHARACTER) FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-getIssue) = 0 &THEN

FUNCTION getIssue RETURNS CHARACTER
    (f-area AS CHARACTER, f-group AS CHARACTER) FORWARD.


&ENDIF


/* *********************** Procedure Settings ************************ */



/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */

 




/* ***************************  Main Block  *************************** */




OUTPUT stream repOutStream to value(SESSION:TEMP-DIR + "/renewals.html") unbuffered.

FOR EACH customer WHERE customer.IsActive
    AND customer.CompanyCode =  lc-global-company NO-LOCK
    BREAK BY customer.name :
    ASSIGN 
        firstCustI = TRUE.
    /*   if customer.account <> "179" then next. /*   FOR TESTING ONLY          */ */

    FOR EACH CustIv   NO-LOCK OF customer,
        FIRST ivSub   NO-LOCK OF CustIv,
        FIRST ivClass NO-LOCK OF ivSub
        BREAK 
        BY ivClass.DisplayPriority DESCENDING
        BY ivClass.name
        BY ivSub.DisplayPriority DESCENDING
        BY ivSub.name
        BY CustIv.Ref:
    
    
        FIND b-ivSub OF CustIv NO-LOCK NO-ERROR.
    
        FOR EACH ivField OF b-ivSub NO-LOCK
            WHERE ivField.dtype = "date" 
            AND   (ivField.dLabel MATCHES("*expir*") OR ivField.dLabel MATCHES("*renew*") )
            AND   ivField.dwarning > 0
            BY ivField.dOrder
            BY ivField.dLabel:
      
            FIND CustField
                WHERE CustField.CustIvID = custIv.CustIvId
                AND CustField.ivFieldId = ivField.ivFieldId
                NO-LOCK NO-ERROR.
    
    
            IF AVAILABLE custField THEN 
            DO:
                ASSIGN  
                    cdate = CustField.FieldData 
                    ddate = checkdate(cdate, 'uk') no-error .

                IF (ddate  - int(ivField.dwarning)) < TODAY THEN
                DO:
                    RUN ip-GenerateInventory(INPUT ROWID(CustIv), OUTPUT lc-htmldesc).
                    RUN ip-GenerateIssue( customer.accountNumber,
                        ENTRY(1,getissue(TRIM(ivClass.name),""),"|"), /* eg "02",  software */
                        CAPS(ENTRY(2,getissue(TRIM(ivClass.name),""),"|")),
                        TRIM(CustIv.Ref) + " - " + trim(ivField.dLabel) + " " + string(ddate),
                        lc-htmldesc,
                        STRING(CustIv.CustIvID),
                        STRING(CustIv.ivSubID)
                        ).
                END.
                ELSE
                DO:
                    IF firstCustI THEN
                    DO:
                        firstCustI = FALSE.
                        PUT STREAM repOutStream UNFORMATTED  
                            '<html><head></head><body><table padding="2px" >'  SKIP
                            '<tr><td colspan=3 ><hr></td></tr>'
                            '<tr><td colspan=3 >A/C # : '  customer.AccountNumber  ' - ' customer.name '</td></tr>'
                            '<tr><td colspan=3 ><hr></td></tr>'
                            '<tr><td colspan=3 ></td></tr>'.
       
                    END.
                    PUT STREAM repOutStream UNFORMATTED 
                        '<tr><td>' CAPS(TRIM(ivClass.name))   '</td><td></td>'
                        ' <td>' TRIM(ivSub.name)              '</td><td></td></tr>'
                        '<tr><td>' TRIM(CustIv.Ref)           '</td><td></td>'
                        ' <td>' TRIM(ivField.dLabel)          '</td><td></td></tr>'
                        '<tr><td>' ddate                      '</td><td></td><td></td></tr>'
                        '<tr><td><hr></td></tr>'.
                END.
            END.
        END.
    END.
END.


OUTPUT stream repOutStream close.
QUIT.



/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-CreateIssue) = 0 &THEN

PROCEDURE ip-CreateIssue :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    
    
    DEFINE VARIABLE lr-Action AS ROWID   NO-UNDO.
    DEFINE VARIABLE lr-Issue  AS ROWID   NO-UNDO.
    DEFINE VARIABLE li-amount AS INTEGER NO-UNDO.

    IF lc-actionCode <> lc-global-selcode THEN
    DO:

    
        FIND WebAction
            WHERE WebAction.CompanyCode = lc-global-company
            AND WebAction.ActionCode  = lc-ActionCode
            NO-LOCK NO-ERROR.
        CREATE IssAction.
        ASSIGN 
            IssAction.actionID     = WebAction.ActionID
            IssAction.CompanyCode  = lc-global-company
            IssAction.IssueNumber  = issue.IssueNumber
            IssAction.CreateDate   = TODAY
            IssAction.CreateTime   = TIME
            IssAction.CreatedBy    = lc-global-user
            IssAction.customerview = lc-customerview = "on"
            .
    
        DO WHILE TRUE:
            RUN lib/makeaudit.p (
                "",
                OUTPUT lf-audit
                ).
            IF CAN-FIND(FIRST IssAction
                WHERE IssAction.IssActionID = lf-audit NO-LOCK)
                THEN NEXT.
            ASSIGN
                IssAction.IssActionID = lf-audit.
            LEAVE.
        END.
    
        ASSIGN 
            IssAction.notes        = lc-actionnote
            IssAction.ActionStatus = lc-ActionStatus
            IssAction.ActionDate   = TODAY
            IssAction.customerview = lc-customerview = "on"
            IssAction.AssignTo     = lc-currentassign
            IssAction.AssignDate   = TODAY
            IssAction.AssignTime   = TIME.
    
        ASSIGN
            lr-Action = ROWID(issAction).
        RELEASE issAction.
        
        FIND issAction WHERE ROWID(issAction) = lr-Action EXCLUSIVE-LOCK.
    
        DYNAMIC-FUNCTION("islib-CreateAutoAction",issAction.IssActionID).
    
        IF lc-ActDescription <> "" THEN
        DO:
    
            
            CREATE IssActivity.
            ASSIGN 
                IssActivity.IssActionID = IssAction.IssActionID
                IssActivity.CompanyCode = lc-global-company
                IssActivity.IssueNumber = issue.IssueNumber
                IssActivity.CreateDate  = TODAY
                IssActivity.CreateTime  = TIME
                IssActivity.CreatedBy   = lc-global-user
                IssActivity.ActivityBy  = lc-CurrentAssign
                .
        
            DO WHILE TRUE:
                RUN lib/makeaudit.p (
                    "",
                    OUTPUT lf-audit
                    ).
                IF CAN-FIND(FIRST IssActivity
                    WHERE IssActivity.IssActivityID = lf-audit NO-LOCK)
                    THEN NEXT.
                ASSIGN
                    IssActivity.IssActivityID = lf-audit.
                LEAVE.
            END.
        
            ASSIGN 
                IssActivity.description  = lc-actdescription
                IssActivity.ActDate      = TODAY
                IssActivity.customerview = lc-customerview = "on".
        
            IF lc-startdate <> "" THEN
            DO:
                ASSIGN 
                    IssActivity.StartDate = DATE(lc-StartDate).
        
                ASSIGN 
                    IssActivity.StartTime = DYNAMIC-FUNCTION("com-InternalTime",
                                 int(lc-starthour),
                                 int(lc-startmin)
                                 ).
            END.
            ELSE ASSIGN IssActivity.StartDate = ?
                    IssActivity.StartTime = 0.
        
            IF lc-enddate <> "" THEN
            DO:
                ASSIGN 
                    IssActivity.EndDate = DATE(lc-endDate).
        
                ASSIGN 
                    IssActivity.Endtime = DYNAMIC-FUNCTION("com-InternalTime",
                                int(lc-endhour),
                                int(lc-endmin)
                                ).
                
            END.
            ELSE ASSIGN IssActivity.EndDate = ?
                    IssActivity.EndTime = 0.
        
        
            ASSIGN 
                IssActivity.Duration = ( ( int(lc-hours) * 60 ) * 60 ) + 
                ( int(lc-mins) * 60 ).
        
        
            IF Issue.Ticket THEN
            DO:
                ASSIGN
                    li-amount = IssActivity.Duration.
                IF li-amount <> 0 THEN
                DO:
                    EMPTY TEMP-TABLE tt-ticket.
                    CREATE tt-ticket.
                    ASSIGN
                        tt-ticket.CompanyCode   = issue.CompanyCode
                        tt-ticket.AccountNumber = issue.AccountNumber
                        tt-ticket.Amount        = li-Amount * -1
                        tt-ticket.CreateBy      = lc-global-user
                        tt-ticket.CreateDate    = TODAY
                        tt-ticket.CreateTime    = TIME
                        tt-ticket.IssueNumber   = Issue.IssueNumber
                        tt-ticket.Reference     = IssActivity.description
                        tt-ticket.TickID        = ?
                        tt-ticket.TxnDate       = IssActivity.ActDate
                        tt-ticket.TxnTime       = TIME
                        tt-ticket.TxnType       = "ACT"
                        tt-ticket.IssActivityID = IssActivity.IssActivityID.
                    RUN tlib-PostTicket.
                END.
            END.
        END.
    END.
    /* *** 
       *** final update of the issue
       ***                                   */
    ASSIGN
        Issue.AssignTo   = lc-CurrentAssign
        Issue.AssignDate = TODAY
        Issue.AssignTime = TIME
        lr-Issue         = ROWID(Issue).

    IF Issue.StatusCode <> lc-currentstatus THEN
    DO:
        RELEASE issue.
        FIND Issue WHERE ROWID(Issue) = lr-Issue EXCLUSIVE-LOCK.
        RUN islib-StatusHistory(
            Issue.CompanyCode,
            Issue.IssueNumber,
            lc-global-user,
            Issue.StatusCode,
            lc-currentStatus ).
        RELEASE issue.
        FIND Issue WHERE ROWID(Issue) = lr-Issue EXCLUSIVE-LOCK.
        ASSIGN
            Issue.StatusCode = lc-CurrentStatus.
        
    END.

    IF DYNAMIC-FUNCTION("islib-StatusIsClosed",
        Issue.CompanyCode,
        Issue.StatusCode)
        THEN DYNAMIC-FUNCTION("islib-RemoveAlerts",ROWID(Issue)).


END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-GenerateInventory) = 0 &THEN

PROCEDURE ip-GenerateInventory :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    

    DEFINE INPUT PARAMETER lr-rowid AS ROWID  NO-UNDO.
    DEFINE OUTPUT PARAMETER lc-html AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lc-value AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-temp  AS CHARACTER NO-UNDO.

    ASSIGN 
        lc-html = "".

    /*  lc-html = '<code><div style="float:left; width:800px;">'. */
    /*                                                            */
    FIND custIv WHERE ROWID(custIv) = lr-rowid NO-LOCK NO-ERROR.

    /*     lc-html = "                Inventory Details For "  + custIv.Ref + "            ~n~n". */
    /*     assign lc-html = lc-html + '<span class="inform"><fieldset><legend>' + lc-temp + '</legend>'.  */
    /*                                                                                                    */
    /*     assign lc-html = lc-html + htmlib-StartMntTable().                                             */
    /*     lc-temp = "^right|Details^left|&nbsp^left".                                                    */
    /*     assign lc-html = lc-html + htmlib-TableHeading(lc-temp) .                                      */

    FIND ivSub OF CustIv NO-LOCK NO-ERROR.

    FOR EACH b-ivField OF ivSub NO-LOCK
        BY b-ivField.dOrder
        BY b-ivField.dLabel:

        /*         assign lc-html = lc-html + '<tr class="tabrow1">'.                                       */
        /*         assign lc-html = lc-html + '<th style="text-align: right; vertical-align: text-top;">'.  */
        ASSIGN 
            lc-html = lc-html + b-ivField.dLabel + ": ".
        /*         assign lc-html = lc-html +  '</th>'. */
        /*                                              */
        
        FIND CustField
            WHERE CustField.CustIvID = custIv.CustIvId
            AND CustField.ivFieldId = b-ivField.ivFieldId
            NO-LOCK NO-ERROR.
        ASSIGN
            lc-value = IF AVAILABLE Custfield THEN CustField.FieldData
                       ELSE "".
        IF lc-value = ?
            THEN ASSIGN lc-value = "".
        ASSIGN 
            lc-html = lc-html + lc-value + "~n".

    /*         assign lc-html = lc-html + htmlib-MntTableField(replace(lc-value,"~n","<br>"),'left') . */
    /*         assign lc-html = lc-html + htmlib-MntTableField("&nbsp",'left') .                       */
    /*         assign lc-html = lc-html + '</tr>' .                                                    */
    END.

    /*     assign lc-html = lc-html + htmlib-EndTable().     */
    /*     assign lc-html = lc-html + htmlib-EndFieldSet() . */
  
    ASSIGN 
        lc-html = lc-html + "~n".

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-GenerateIssue) = 0 &THEN

PROCEDURE ip-GenerateIssue :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
   

    DEFINE INPUT PARAMETER pc-accountnumber        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-AreaCode             AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-briefdescription     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-longdescription      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-actionnote           AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-custivid             AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-subivid              AS CHARACTER NO-UNDO.



    ASSIGN 
        lc-accountnumber    = pc-accountnumber
        lc-briefdescription = pc-briefdescription
        lc-longdescription  = pc-longdescription
        /*                lc-submitsource     = "submitsource" */
        lc-raisedlogin      = "BATCH"
        lc-date             = STRING(TODAY)
        lc-AreaCode         = pc-AreaCode 
        lc-gotomaint        = "true"
        /*                lc-sla-selected     = "sla" */
        lc-catcode          = "QUOTES"
        lc-ticket           = "on"
        lc-quick            = "quick"
        lc-currentassign    = "Renewals"
        lc-actioncode       = "380"   /* Urgent request  */
        lc-actionnote       = pc-actionnote
        lc-customerview     = "false"
        lc-actionstatus     = "OPEN"
        lc-hours            = ""
        lc-mins             = "15"
        lc-startdate        = STRING(TODAY)
        lc-starthour        = "12"
        lc-startmin         = "30"
        lc-enddate          = STRING(TODAY + 30)
        lc-endhour          = "12"
        lc-endmin           = "30"
        lc-actdescription   = "Investigate"
        lc-currentstatus    = "NEW"
        lc-custivid         = pc-custivid   
        lc-subivid          = pc-subivid  .
        

    FIND FIRST issue WHERE issue.AccountNumber      = lc-accountnumber                  
        AND   issue.CompanyCode        = lc-global-company
        AND   issue.CreateBy           = lc-global-user   
        AND   issue.areacode           = lc-areacode                       
        AND   issue.CatCode            = lc-catcode                        
        AND   issue.Ticket             = TRUE             
        AND   issue.BatchID            = string(TRIM(lc-BriefDescription) + "|" +        
        trim(lc-global-company) + "|" +         
        trim(lc-areacode) + "|" +  
        trim(lc-custivid) + "|" +  
        trim(lc-subivid))
        NO-LOCK NO-ERROR.  

    IF AVAILABLE issue THEN RETURN.

    RUN ip-Initialise.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-Initialise) = 0 &THEN

PROCEDURE ip-Initialise :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    

    REPEAT:
        FIND LAST issue 
            WHERE issue.companycode = lc-global-company
            NO-LOCK NO-ERROR.
        ASSIGN
            li-issue = IF AVAILABLE issue THEN issue.issueNumber + 1
                ELSE 1.
        LEAVE.
    END.
    
    ASSIGN 
        lc-ticket = "on".

    CREATE issue.
    ASSIGN 
        issue.IssueNumber      = li-issue
        issue.BriefDescription = lc-BriefDescription
        issue.LongDescription  = lc-LongDescription
        issue.AccountNumber    = lc-accountnumber
        issue.CompanyCode      = lc-global-company
        issue.CreateDate       = TODAY
        issue.CreateTime       = TIME
        issue.CreateBy         = lc-global-user
        issue.IssueDate        = DATE(lc-date)
        issue.IssueTime        = TIME
        issue.areacode         = lc-areacode
        issue.CatCode          = lc-catcode
        issue.Ticket           = lc-ticket = "on"
        issue.BatchID          = STRING(TRIM(lc-BriefDescription) + "|" +           
                                             trim(lc-global-company) + "|" +         
                                             trim(lc-areacode) + "|" +  
                                             trim(lc-custivid) + "|" +  
                                             trim(lc-subivid))      
                                      

        .

    IF lc-emailID <> ""
        THEN ASSIGN issue.CreateSource = "EMAIL".
                                     

    IF ll-customer THEN
    DO:
        ASSIGN 
            lc-sla-selected = "slanone".
        IF customer.DefaultSLAID <> 0 THEN
        DO:
            FIND slahead WHERE slahead.SLAID = Customer.DefaultSLAID NO-LOCK NO-ERROR.

            IF AVAILABLE slahead
                THEN ASSIGN lc-sla-selected = "sla" + string(ROWID(slahead)).
        END.
    END.

    /*     assign                                                                           */
    /*         lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,lc-AccountNumber).  */
    IF lc-sla-selected = "slanone" 
        OR lc-sla-rows = "" THEN 
    DO:
        ASSIGN 
            Issue.link-SLAID = 0
            Issue.SLAStatus  = "OFF".
    END.
    ELSE
    DO:
        FIND slahead WHERE ROWID(slahead) = to-rowid(substr(lc-sla-selected,4)) NO-LOCK NO-ERROR.
        IF AVAILABLE slahead THEN 
        DO:
            ASSIGN 
                Issue.link-SLAID = slahead.SLAID.

            EMPTY TEMP-TABLE tt-sla-sched.
            RUN lib/slacalc.p
                ( Issue.IssueDate,
                Issue.IssueTime,
                Issue.link-SLAID,
                OUTPUT table tt-sla-sched ).
            ASSIGN
                Issue.SLADate   = ?
                Issue.SLALevel  = 0
                Issue.SLAStatus = "OFF"
                Issue.SLATime   = 0.
            FOR EACH tt-sla-sched NO-LOCK
                WHERE tt-sla-sched.Level > 0:
    
                ASSIGN
                    Issue.SLADate[tt-sla-sched.Level] = tt-sla-sched.sDate
                    Issue.SLATime[tt-sla-sched.Level] = tt-sla-sched.sTime.
                ASSIGN
                    Issue.SLAStatus = "ON".
            END.
            IF issue.slaDate[2] <> ? 
                THEN ASSIGN issue.SLATrip = DATETIME(STRING(Issue.SLADate[2],"99/99/9999") + " " 
            + STRING(Issue.SLATime[2],"HH:MM")).

        END.

    END.

    ASSIGN 
        issue.RaisedLoginid = lc-raisedlogin.

    ASSIGN 
        issue.StatusCode = "NEW".

    RUN islib-StatusHistory(
        issue.CompanyCode,
        issue.IssueNumber,
        lc-global-user,
        "",
        issue.StatusCode ).

    IF lc-emailid <> "" THEN
    DO:
        FIND emailh WHERE emailh.EmailID = dec(lc-EmailID) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE emailh THEN
        DO:

            FOR EACH doch WHERE doch.CompanyCode = lc-global-company
                AND doch.RelType     = "EMAIL"
                AND doch.RelKey      = string(emailh.EmailID) EXCLUSIVE-LOCK:
                ASSIGN
                    doch.RelType  = "ISSUE"  
                    doch.RelKey   = STRING(Issue.IssueNumber)
                    doch.CreateBy = lc-global-user.
            END.
            DELETE emailh.
        END.

    END.

    islib-DefaultActions(lc-global-company,
        Issue.IssueNumber).
    IF NOT ll-Customer 
        THEN RUN ip-CreateIssue.
    
    
  
END PROCEDURE.


&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-checkdate) = 0 &THEN

FUNCTION checkdate RETURNS DATE
    (chkdate AS CHARACTER, lang AS CHARACTER):
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:    Original code from:
                  /* ------- checkDate function ------- */
                  /*       (C) DJS 1996 RiverSoft       */
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE retdate AS DATE      NO-UNDO.
    DEFINE VARIABLE tmpdate AS CHARACTER NO-UNDO.
    IF NUM-ENTRIES(chkdate,"/") <> 3 THEN 
    DO:
        IF lang = 'uk' AND SESSION:DATE-FORMAT = 'dmy' THEN
        DO:
            tmpdate = STRING(substr(chkdate,1,2) + '/' +
                substr(chkdate,3,2) + '/' +
                substr(chkdate,5) ). /* US */
            retdate = DATE(tmpdate) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN retdate = ?.
        END.
    END.
    ELSE 
    DO:
        retdate = DATE(chkdate) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN retdate = ?.
    END.
    RETURN retdate.

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-getIssue) = 0 &THEN

FUNCTION getIssue RETURNS CHARACTER
    (f-area AS CHARACTER, f-group AS CHARACTER):
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    FOR EACH webIssArea WHERE webIssArea.Description MATCHES("*" + f-area + "*") NO-LOCK:
        FIND webissagrp WHERE webissagrp.companycode = webissArea.CompanyCode
            AND webissagrp.Groupid     = webissArea.GroupID 
            AND webissagrp.description MATCHES("*" + f-group + "*") NO-LOCK NO-ERROR.
        IF AVAILABLE webissagrp THEN 
        DO:
            /*     message webIssArea.AreaCode skip  webIssArea.Description skip  webissArea.GroupID skip webissagrp.description  view-as alert-box.  */
            RETURN STRING( webIssArea.AreaCode  + "|" +  webissagrp.description).
        END.
        ELSE RETURN STRING(webIssArea.AreaCode + "|").
    END.


END FUNCTION.


&ENDIF

