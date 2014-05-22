&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        batch/renewals.p
    
    Purpose:        Renewals Processing
    
    Notes:
    
    
    When        Who         What
    03/09/2010  DJS        Initial build

***********************************************************************/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
  
{lib/common.i}
{iss/issue.i}
{lib/ticket.i}
/* {lib/htmlib.i} */

lc-global-company = trim(os-getenv("COMPANYCODE")).
if lc-global-company = ?
  or lc-global-company = "" then lc-global-company = "ouritdept".

lc-global-user = trim(os-getenv("BATCHID")).
if lc-global-user = ? 
  or lc-global-user = "" then lc-global-user = "BATCH".


def var lc-error-field      as char no-undo.
def var lc-error-msg        as char no-undo.

def var lc-accountnumber    as char no-undo.
def var lc-briefdescription as char no-undo.
def var lc-longdescription  as char no-undo.
def var lc-submitsource     as char no-undo.
def var lc-raisedlogin      as char no-undo.
def var li-issue            as int no-undo.
def var lc-date             as char no-undo.
def var lc-AreaCode         as char no-undo.
def var lc-Address          as char no-undo.
def var lc-Ticket           as char no-undo.
def var lc-title            as char no-undo.


def var lc-list-number      as char no-undo.
def var lc-list-name        as char no-undo.

def var lc-list-login       as char no-undo.
def var lc-list-lname       as char no-undo.

def var lc-list-area        as char no-undo.
def var lc-list-aname       as char no-undo.
def var lc-gotomaint        as char no-undo.

def var lc-sla-rows         as char no-undo.
def var lc-sla-selected     as char no-undo.
def var ll-customer         as log  no-undo.

def var lc-default-catcode  as char no-undo.
def var lc-catcode          as char no-undo.
def var lc-list-catcode     as char no-undo.
def var lc-list-cname       as char no-undo.

def var lc-issuesource      as char no-undo.
def var lc-emailid          as char no-undo.

def var lc-list-actcode     as char no-undo.
def var lc-list-actdesc     as char no-undo.

def var lc-custivid         as char no-undo.
def var lc-subivid          as char no-undo.
 
 
/* Action Stuff */

def var lc-Quick            as char no-undo.
def var lc-actioncode       as char no-undo.
def var lc-ActionNote       as char no-undo.
def var lc-CustomerView     as char no-undo.
def var lc-actionstatus     as char no-undo.
def var lc-list-assign      as char no-undo.
def var lc-list-assname     as char no-undo.
def var lc-currentassign    as char no-undo.

/* Activity */
def var lc-hours            as char no-undo.
def var lc-mins             as char no-undo.
def var li-hours            as int  no-undo.
def var li-mins             as int  no-undo.
def var lc-StartDate        as char no-undo.
def var lc-starthour        as char no-undo.
def var lc-startmin         as char no-undo.
def var lc-endDate          as char no-undo.
def var lc-endhour          as char no-undo.
def var lc-endmin           as char no-undo.
def var lc-ActDescription   as char no-undo.

/* Status */
def var lc-list-status      as char no-undo.
def var lc-list-sname       as char no-undo.
def var lc-currentstatus    as char no-undo.


def var lc-htmldesc         as char no-undo.
def var cdate               as char format "x(16)" no-undo.
def var ddate               as date format "99/99/9999" initial 01/01/1999 no-undo.
def var firstCustI          as log initial true  no-undo.



def buffer b-ivSub for ivSub.
def buffer b-CustIv for CustIv.
def buffer b-ivField for ivField.

def var lf-Audit            as dec  no-undo.

def stream repOutStream .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-checkdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkdate Procedure 
FUNCTION checkdate RETURNS DATE
 (chkdate as char, lang as char) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIssue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIssue Procedure 
FUNCTION getIssue RETURNS CHARACTER
  (f-area as char, f-group as char) FORWARD.

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




output stream repOutStream to value(session:temp-dir + "/renewals.html") unbuffered.

for each customer where customer.IsActive
    and customer.CompanyCode =  lc-global-company no-lock
    break by customer.name :
assign firstCustI = true.
/*   if customer.account <> "179" then next. /*   FOR TESTING ONLY          */ */

  for each CustIv   no-lock of customer,
    first ivSub   no-lock of CustIv,
    first ivClass no-lock of ivSub
    break 
    by ivClass.DisplayPriority desc
    by ivClass.name
    by ivSub.DisplayPriority desc
    by ivSub.name
    by CustIv.Ref:
    
    
    find b-ivSub of CustIv no-lock no-error.
    
    for each ivField of b-ivSub no-lock
        where ivField.dtype = "date" 
        and   (ivField.dLabel matches("*expir*") or ivField.dLabel matches("*renew*") )
        and   ivField.dwarning > 0
        by ivField.dOrder
        by ivField.dLabel:
      
    find CustField
      where CustField.CustIvID = custIv.CustIvId
      and CustField.ivFieldId = ivField.ivFieldId
      no-lock no-error.
    
    
      if avail custField then 
      do:
        assign  cdate = CustField.FieldData 
                ddate = checkdate(cdate, 'uk') no-error .

        if (ddate  - int(ivField.dwarning)) < today then
        do:
          run ip-GenerateInventory(input rowid(CustIv), output lc-htmldesc).
          run ip-GenerateIssue( customer.account,
                                entry(1,getissue(trim(ivClass.name),""),"|"), /* eg "02",  software */
                                caps(entry(2,getissue(trim(ivClass.name),""),"|")),
                                trim(CustIv.Ref) + " - " + trim(ivField.dLabel) + " " + string(ddate),
                                lc-htmldesc,
                                string(CustIv.CustIvID),
                                string(CustIv.ivSubID)
                                 ).
        end.
        else
        do:
          if firstCustI then
            do:
              firstCustI = false.
              put stream repOutStream unformatted  
                '<html><head></head><body><table padding="2px" >'  skip
                '<tr><td colspan=3 ><hr></td></tr>'
                '<tr><td colspan=3 >A/C # : '  customer.AccountNumber  ' - ' customer.name '</td></tr>'
                '<tr><td colspan=3 ><hr></td></tr>'
                '<tr><td colspan=3 ></td></tr>'.
       
            end.
            put stream repOutStream unformatted 
                '<tr><td>' caps(trim(ivClass.name))   '</td><td></td>'
                ' <td>' trim(ivSub.name)              '</td><td></td></tr>'
                '<tr><td>' trim(CustIv.Ref)           '</td><td></td>'
                ' <td>' trim(ivField.dLabel)          '</td><td></td></tr>'
                '<tr><td>' ddate                      '</td><td></td><td></td></tr>'
                '<tr><td><hr></td></tr>'.
        end.
      end.
    end.
  end.
end.


output stream repOutStream close.
quit.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-CreateIssue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CreateIssue Procedure 
PROCEDURE ip-CreateIssue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    
    def var lr-Action       as rowid        no-undo.
    def var lr-Issue        as rowid        no-undo.
    def var li-amount       as int          no-undo.

    if lc-actionCode <> lc-global-selcode then
    do:

    
        find WebAction
            where WebAction.CompanyCode = lc-global-company
              and WebAction.ActionCode  = lc-ActionCode
              no-lock no-error.
        create IssAction.
        assign IssAction.actionID       = WebAction.ActionID
               IssAction.CompanyCode    = lc-global-company
               IssAction.IssueNumber    = issue.IssueNumber
               IssAction.CreateDate     = today
               IssAction.CreateTime     = time
               IssAction.CreatedBy      = lc-global-user
               IssAction.customerview   = lc-customerview = "on"
               .
    
        do while true:
            run lib/makeaudit.p (
                "",
                output lf-audit
                ).
            if can-find(first IssAction
                        where IssAction.IssActionID = lf-audit no-lock)
                        then next.
            assign
                IssAction.IssActionID   = lf-audit.
            leave.
        end.
    
        assign IssAction.notes          = lc-actionnote
               IssAction.ActionStatus   = lc-ActionStatus
               IssAction.ActionDate     = today
               IssAction.customerview   = lc-customerview = "on"
               IssAction.AssignTo       = lc-currentassign
               IssAction.AssignDate     = today
               IssAction.AssignTime     = time.
    
        assign
            lr-Action = rowid(issAction).
        release issAction.
        
        find issAction where rowid(issAction) = lr-Action exclusive-lock.
    
        dynamic-function("islib-CreateAutoAction",issAction.IssActionID).
    
        if lc-ActDescription <> "" then
        do:
    
            
            create IssActivity.
            assign IssActivity.IssActionID = IssAction.IssActionID
                   IssActivity.CompanyCode = lc-global-company
                   IssActivity.IssueNumber = issue.IssueNumber
                   IssActivity.CreateDate  = today
                   IssActivity.CreateTime  = time
                   IssActivity.CreatedBy   = lc-global-user
                   IssActivity.ActivityBy  = lc-CurrentAssign
                   .
        
            do while true:
                run lib/makeaudit.p (
                    "",
                    output lf-audit
                    ).
                if can-find(first IssActivity
                            where IssActivity.IssActivityID = lf-audit no-lock)
                            then next.
                assign
                    IssActivity.IssActivityID = lf-audit.
                leave.
            end.
        
            assign IssActivity.description      = lc-actdescription
                   IssActivity.ActDate          = today
                   IssActivity.customerview    = lc-customerview = "on".
        
            if lc-startdate <> "" then
            do:
                assign IssActivity.StartDate = date(lc-StartDate).
        
                assign IssActivity.StartTime = dynamic-function("com-InternalTime",
                                 int(lc-starthour),
                                 int(lc-startmin)
                                 ).
            end.
            else assign IssActivity.StartDate = ?
                        IssActivity.StartTime = 0.
        
            if lc-enddate <> "" then
            do:
                assign IssActivity.EndDate = date(lc-endDate).
        
                assign IssActivity.Endtime = dynamic-function("com-InternalTime",
                                int(lc-endhour),
                                int(lc-endmin)
                                ).
                
            end.
            else assign IssActivity.EndDate = ?
                        IssActivity.EndTime = 0.
        
        
            assign IssActivity.Duration = 
                ( ( int(lc-hours) * 60 ) * 60 ) + 
                ( int(lc-mins) * 60 ).
        
        
            if Issue.Ticket then
            do:
                assign
                    li-amount = IssActivity.Duration.
                if li-amount <> 0 then
                do:
                    empty temp-table tt-ticket.
                    create tt-ticket.
                    assign
                        tt-ticket.CompanyCode       =   issue.CompanyCode
                        tt-ticket.AccountNumber     =   issue.AccountNumber
                        tt-ticket.Amount            =   li-Amount * -1
                        tt-ticket.CreateBy          =   lc-global-user
                        tt-ticket.CreateDate        =   today
                        tt-ticket.CreateTime        =   time
                        tt-ticket.IssueNumber       =   Issue.IssueNumber
                        tt-ticket.Reference         =   IssActivity.description
                        tt-ticket.TickID            =   ?
                        tt-ticket.TxnDate           =   IssActivity.ActDate
                        tt-ticket.TxnTime           =   time
                        tt-ticket.TxnType           =   "ACT"
                        tt-ticket.IssActivityID     =   IssActivity.IssActivityID.
                    RUN tlib-PostTicket.
                end.
            end.
        end.
    end.
 /* *** 
    *** final update of the issue
    ***                                   */
    assign
        Issue.AssignTo  = lc-CurrentAssign
        Issue.AssignDate = today
        Issue.AssignTime = time
        lr-Issue       = rowid(Issue).

    if Issue.StatusCode <> lc-currentstatus then
    do:
        release issue.
        find Issue where rowid(Issue) = lr-Issue exclusive-lock.
        run islib-StatusHistory(
                        Issue.CompanyCode,
                        Issue.IssueNumber,
                        lc-global-user,
                        Issue.StatusCode,
                        lc-currentStatus ).
        release issue.
        find Issue where rowid(Issue) = lr-Issue exclusive-lock.
        assign
            Issue.StatusCode = lc-CurrentStatus.
        
    end.

    if dynamic-function("islib-StatusIsClosed",
                        Issue.CompanyCode,
                        Issue.StatusCode)
    then dynamic-function("islib-RemoveAlerts",rowid(Issue)).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GenerateInventory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GenerateInventory Procedure 
PROCEDURE ip-GenerateInventory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

 def input param lr-rowid as rowid  no-undo.
 def output param lc-html as char   no-undo.
 def var lc-value         as char   no-undo.
 def var lc-temp          as char   no-undo.

 assign lc-html = "".

/*  lc-html = '<code><div style="float:left; width:800px;">'. */
/*                                                            */
  find custIv where rowid(custIv) = lr-rowid no-lock no-error.

/*     lc-html = "                Inventory Details For "  + custIv.Ref + "            ~n~n". */
/*     assign lc-html = lc-html + '<span class="inform"><fieldset><legend>' + lc-temp + '</legend>'.  */
/*                                                                                                    */
/*     assign lc-html = lc-html + htmlib-StartMntTable().                                             */
/*     lc-temp = "^right|Details^left|&nbsp^left".                                                    */
/*     assign lc-html = lc-html + htmlib-TableHeading(lc-temp) .                                      */

    find ivSub of CustIv no-lock no-error.

    for each b-ivField of ivSub no-lock
        by b-ivField.dOrder
        by b-ivField.dLabel:

/*         assign lc-html = lc-html + '<tr class="tabrow1">'.                                       */
/*         assign lc-html = lc-html + '<th style="text-align: right; vertical-align: text-top;">'.  */
        assign lc-html = lc-html + b-ivField.dLabel + ": ".
/*         assign lc-html = lc-html +  '</th>'. */
/*                                              */
        
        find CustField
            where CustField.CustIvID = custIv.CustIvId
              and CustField.ivFieldId = b-ivField.ivFieldId
              no-lock no-error.
        assign
            lc-value = if avail Custfield then CustField.FieldData
                       else "".
        if lc-value = ?
        then assign lc-value = "".
        assign lc-html = lc-html + lc-value + "~n".

/*         assign lc-html = lc-html + htmlib-MntTableField(replace(lc-value,"~n","<br>"),'left') . */
/*         assign lc-html = lc-html + htmlib-MntTableField("&nbsp",'left') .                       */
/*         assign lc-html = lc-html + '</tr>' .                                                    */
    end.

/*     assign lc-html = lc-html + htmlib-EndTable().     */
/*     assign lc-html = lc-html + htmlib-EndFieldSet() . */
  
    assign lc-html = lc-html + "~n".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GenerateIssue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GenerateIssue Procedure 
PROCEDURE ip-GenerateIssue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   

  def input param pc-accountnumber        as char no-undo.
  def input param pc-AreaCode             as char no-undo.
  def input param pc-briefdescription     as char no-undo.
  def input param pc-longdescription      as char no-undo.
  def input param pc-actionnote           as char no-undo.
  def input param pc-custivid             as char no-undo.
  def input param pc-subivid              as char no-undo.



        assign lc-accountnumber    = pc-accountnumber
               lc-briefdescription = pc-briefdescription
               lc-longdescription  = pc-longdescription
/*                lc-submitsource     = "submitsource" */
               lc-raisedlogin      = "BATCH"
               lc-date             = string(today)
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
               lc-startdate        = string(today)
               lc-starthour        = "12"
               lc-startmin         = "30"
               lc-enddate          = string(today + 30)
               lc-endhour          = "12"
               lc-endmin           = "30"
               lc-actdescription   = "Investigate"
               lc-currentstatus    = "NEW"
               lc-custivid         = pc-custivid   
               lc-subivid          = pc-subivid  .
        

    find first issue where issue.AccountNumber      = lc-accountnumber                  
                     and   issue.CompanyCode        = lc-global-company
                     and   issue.CreateBy           = lc-global-user   
                     and   issue.areacode           = lc-areacode                       
                     and   issue.CatCode            = lc-catcode                        
                     and   issue.Ticket             = true             
                     and   issue.BatchID            = string(trim(lc-BriefDescription) + "|" +        
                                                      trim(lc-global-company) + "|" +         
                                                      trim(lc-areacode) + "|" +  
                                                      trim(lc-custivid) + "|" +  
                                                      trim(lc-subivid))
                    no-lock no-error.  

    if avail issue then return.

    run ip-Initialise.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Initialise) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Initialise Procedure 
PROCEDURE ip-Initialise :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

  repeat:
        find last issue 
            where issue.companycode = lc-global-company
            no-lock no-error.
        assign
            li-issue = 
                if avail issue then issue.issueNumber + 1
                else 1.
        leave.
    end.
    
    assign lc-ticket = "on".

    create issue.
    assign issue.IssueNumber        = li-issue
           issue.BriefDescription   = lc-BriefDescription
           issue.LongDescription    = lc-LongDescription
           issue.AccountNumber      = lc-accountnumber
           issue.CompanyCode        = lc-global-company
           issue.CreateDate         = today
           issue.CreateTime         = time
           issue.CreateBy           = lc-global-user
           issue.IssueDate          = date(lc-date)
           issue.IssueTime          = time
           issue.areacode           = lc-areacode
           issue.CatCode            = lc-catcode
           issue.Ticket             = lc-ticket = "on"
           issue.BatchID            = string(trim(lc-BriefDescription) + "|" +           
                                             trim(lc-global-company) + "|" +         
                                             trim(lc-areacode) + "|" +  
                                             trim(lc-custivid) + "|" +  
                                             trim(lc-subivid))      
                                      

            .

    if lc-emailID <> ""
    then assign issue.CreateSource = "EMAIL".
                                     

    if ll-customer then
    do:
        assign 
            lc-sla-selected = "slanone".
        if customer.DefaultSLAID <> 0 then
        do:
            find slahead where slahead.SLAID = Customer.DefaultSLAID no-lock no-error.

            if avail slahead
            then assign lc-sla-selected = "sla" + string(rowid(slahead)).
        end.
    end.

/*     assign                                                                           */
/*         lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,lc-AccountNumber).  */
    if lc-sla-selected = "slanone" 
    or lc-sla-rows = "" then 
    do:
        assign Issue.link-SLAID = 0
               Issue.SLAStatus = "OFF".
    end.
    else
    do:
        find slahead where rowid(slahead) = to-rowid(substr(lc-sla-selected,4)) no-lock no-error.
        if avail slahead then 
        do:
            assign Issue.link-SLAID = slahead.SLAID.

            empty temp-table tt-sla-sched.
            run lib/slacalc.p
                ( Issue.IssueDate,
                  Issue.IssueTime,
                  Issue.link-SLAID,
                  output table tt-sla-sched ).
            assign
                Issue.SLADate = ?
                Issue.SLALevel = 0
                Issue.SLAStatus = "OFF"
                Issue.SLATime  = 0.
            for each tt-sla-sched no-lock
                where tt-sla-sched.Level > 0:
    
                assign
                    Issue.SLADate[tt-sla-sched.Level] = tt-sla-sched.sDate
                    Issue.SLATime[tt-sla-sched.Level] = tt-sla-sched.sTime.
                assign
                    Issue.SLAStatus = "ON".
            end.
            IF issue.slaDate[2] <> ? 
                            THEN ASSIGN issue.SLATrip = DATETIME(STRING(Issue.SLADate[2],"99/99/9999") + " " 
            + STRING(Issue.SLATime[2],"HH:MM")).

        end.

    end.

    assign issue.RaisedLoginid = lc-raisedlogin.

    assign issue.StatusCode = "NEW".

    run islib-StatusHistory(
            issue.CompanyCode,
            issue.IssueNumber,
            lc-global-user,
            "",
            issue.StatusCode ).

    if lc-emailid <> "" then
    do:
        find emailh where emailh.EmailID = dec(lc-EmailID) exclusive-lock no-error.
        if avail emailh then
        do:

            for each doch where doch.CompanyCode = lc-global-company
                            and doch.RelType     = "EMAIL"
                            and doch.RelKey      = string(emailh.EmailID) exclusive-lock:
                assign
                    doch.RelType = "ISSUE"  
                    doch.RelKey  = string(Issue.IssueNumber)
                    doch.CreateBy = lc-global-user.
            end.
            delete emailh.
        end.

    end.

    islib-DefaultActions(lc-global-company,
                         Issue.IssueNumber).
    if not ll-Customer 
    then RUN ip-CreateIssue.
    
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-checkdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkdate Procedure 
FUNCTION checkdate RETURNS DATE
 (chkdate as char, lang as char):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:    Original code from:
              /* ------- checkDate function ------- */
              /*       (C) DJS 1996 RiverSoft       */
------------------------------------------------------------------------------*/

  def var retdate as date no-undo.
  def var tmpdate as char no-undo.
  if num-entries(chkdate,"/") <> 3 then 
  do:
      if lang = 'uk' and session:date-format = 'dmy' then
      do:
      tmpdate = string(substr(chkdate,1,2) + '/' +
                       substr(chkdate,3,2) + '/' +
                       substr(chkdate,5) ). /* US */
      retdate = date(tmpdate) no-error.
      if error-status:error then retdate = ?.
      end.
  end.
  else do:
      retdate = date(chkdate) no-error.
      if error-status:error then retdate = ?.
  end.
  return retdate.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIssue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIssue Procedure 
FUNCTION getIssue RETURNS CHARACTER
  (f-area as char, f-group as char):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  for each webIssArea where webIssArea.Description matches("*" + f-area + "*") no-lock:
  find webissagrp where webissagrp.companycode = webissArea.CompanyCode
                    and webissagrp.Groupid     = webissArea.GroupID 
                    and webissagrp.description matches("*" + f-group + "*") no-lock no-error.
   if avail webissagrp then 
   do:
 /*     message webIssArea.AreaCode skip  webIssArea.Description skip  webissArea.GroupID skip webissagrp.description  view-as alert-box.  */
     return string( webIssArea.AreaCode  + "|" +  webissagrp.description).
   end.
   else return string(webIssArea.AreaCode + "|").
  end.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

