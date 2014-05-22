&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/moveissue.p
    
    Purpose:        Issue Maintenance - Move Customer
    
    Notes:
    
    
    When        Who         What
    07/04/2007  phoski      Initial
    
    09/08/2010  DJS         3667 - view only active co's & users

***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-valid  for issue.
def buffer b-table  for issue.
def buffer b-cust   for Customer.
def buffer b-status for webstatus.
def buffer b-area   for webIssarea.


def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.

def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-area         as char no-undo.
def var lc-account      as char no-undo.
def var lc-status       as char no-undo.
def var lc-assign       as char no-undo.
def var lc-parameters   as char no-undo.

def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.

def var lc-category         as char no-undo.

def var lc-submitsource as char no-undo.
def var lc-link-otherp  as char no-undo.

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
         HEIGHT             = 14.15
         WIDTH              = 60.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}
{iss/issue.i}
{lib/ticket.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-BackToIssue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BackToIssue Procedure 
PROCEDURE ip-BackToIssue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var lc-link-url     as char no-undo.

    RUN outputHeader.
    {&out} htmlib-Header(lc-title) skip.
   
    assign request_method = "get".

    assign lc-link-url = '"' + 
                         appurl + '/iss/issue.p' + 
                        '?search=' + lc-search + 
                        '&firstrow=' + lc-firstrow + 
                        '&lastrow=' + lc-lastrow + 
                        '&navigation=refresh' +
                        '&time=' + string(time) + 
                        '&account=' + lc-account + 
                        '&status=' + lc-status +
                        '&assign=' + lc-assign + 
                        '&area=' + lc-area + 
                        '&category=' + lc-category +
                        '"'.
    
   

    {&out} '<script language="javascript">' skip.

           
    {&out} 'NewURL = ' lc-link-url  skip
           'self.location = NewURL' skip
            '</script>' skip.

    {&OUT} htmlib-Footer() skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-BuildPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildPage Procedure 
PROCEDURE ip-BuildPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def buffer b-cust   for customer.
    def buffer b-user   for WebUser.
    def buffer b-cat    for WebIssCat.

    def var lc-icustname as char no-undo.
    def var lc-raised    as char no-undo.
    def var lc-assign    as char no-undo.
    
    find b-cust of b-table no-lock no-error.
    find b-cat  of b-table no-lock no-error.
    
    if avail b-cust
    then assign lc-icustname = b-cust.AccountNumber + 
                               ' ' + b-cust.Name.
    else assign lc-icustname = 'N/A'.

    assign
        lc-raised = com-UserName(b-table.RaisedLogin).

    
    assign
        lc-assign = com-UserName(b-table.AssignTo).

    {&out} htmlib-StartInputTable() skip.

    find b-area of b-table no-lock no-error.
    find b-status of b-table no-lock no-error.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Customer")
           '</TD>' skip
           htmlib-TableField(html-encode(lc-icustname),'left') skip
           '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Date")
           '</TD>' skip
           htmlib-TableField(if b-table.IssueDate = ? then "" else 
               string(b-table.IssueDate,'99/99/9999') + " " + 
               string(b-table.IssueTime,'hh:mm am'),'left') skip
           '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Raised By")
           '</TD>' skip
           htmlib-TableField(html-encode(lc-raised),'left') skip

           .

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Description")
           '</TD>'
            htmlib-TableField(b-table.briefdescription,"") 
            '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Notes")
          '</TD>'
           htmlib-TableField(replace(b-table.longdescription,'~n','<BR>'),"") 
           '</TR>' skip.


    if avail b-area then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Area")
          '</TD>'
           htmlib-TableField(b-area.description,"") 
           '</TR>' skip.
    
    if avail b-status then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Status")
          '</TD>'
           htmlib-TableField(b-status.description,"") 
           '</TR>' skip.

    if avail b-cat then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Category")
          '</TD>'
           htmlib-TableField(b-cat.description,"") 
           '</TR>' skip.

    
    if lc-assign <> "" then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Assigned To")
          '</TD>'
           htmlib-TableField(lc-assign,"") 
           '</TR>' skip.

    
    if b-table.PlannedCompletion <> ?  then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Planned Completion")
           '</TD>'
           htmlib-TableField(string(b-table.PlannedCompletion,'99/99/9999'),"") 
           '</TR>' skip.

    

    {&out} '<tr><td valign=top align=right">'
            htmlib-SideLabel("Select Account")
            '</td>'
            '<td>' skip.
                
   
    {&out} '<select name="newaccount" class="inputfield">' skip.

    for each customer no-lock
        where customer.companyCode = b-table.Company
        and   customer.isActive = true                            /* 3667 */  
           by customer.name:

        if customer.AccountNumber = b-table.AccountNumber then next.

        {&out}
            '<option value="' customer.AccountNumber '">'
                html-encode(customer.Name) '</option>' skip.
    end.

    {&out} '</select></td></tr>' skip.
    
    {&out} htmlib-EndTable() skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-MoveAccount) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-MoveAccount Procedure 
PROCEDURE ip-MoveAccount :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pr-rowid        as rowid        no-undo.
    def input param pc-account      as char         no-undo.


    find issue
        where rowid(issue) = pr-rowid exclusive-lock.

    for each issAlert of Issue exclusive-lock:
        delete issAlert.
    end.

    /*
    ***
    *** Reverse any tickets on this issue
    ***
    */
    if issue.Ticket and issue.TicketAmount <> 0 then
    do:
        find customer
                where customer.CompanyCode = issue.CompanyCode
                  and customer.AccountNumber = issue.AccountNumber exclusive-lock.
        for each Ticket exclusive-lock
            where ticket.CompanyCode = issue.CompanyCode
              and ticket.IssueNumber = issue.IssueNumber:

            delete ticket.
        end.

        assign
            customer.TicketBalance = customer.TicketBalance + issue.TicketAmount.
    end.

    run islib-CreateNote(
        lc-global-company,
        issue.IssueNumber,
        lc-global-user,
        "SYS.ACCOUNT",
        "Issue moved from customer " + 
        dynamic-function("com-CustomerName",Issue.CompanyCode,Issue.AccountNumber)
        ).
    assign
        Issue.AccountNumber = pc-account
        Issue.link-SLAID    = 0
        Issue.SLADate       = ?
        Issue.SLALevel      = ?
        Issue.SLAStatus     = "OFF"
        Issue.SLATime       = 0
        Issue.Ticket        = false
        Issue.TicketAmount  = 0.

    if com-IsCustomer(Issue.CompanyCode,Issue.CreateBy) 
    then issue.CreateBy = "".

    if com-IsCustomer(Issue.CompanyCode,Issue.RaisedLoginId) 
    then issue.RaisedLoginId = "".

    find customer
        where customer.CompanyCode = issue.CompanyCode
          and customer.AccountNumber = issue.AccountNumber exclusive-lock.

    if customer.SupportTicket = "YES" then
    do:
        assign
            Issue.Ticket = true.
        empty temp-table tt-ticket.
        for each issActivity
            where issActivity.CompanyCode = Issue.CompanyCode
              and issActivity.IssueNumber = Issue.IssueNumber no-lock:
            create tt-ticket.
            assign
                tt-ticket.CompanyCode       =   issue.CompanyCode
                tt-ticket.AccountNumber     =   issue.AccountNumber
                tt-ticket.Amount            =   issActivity.Duration * -1
                tt-ticket.CreateBy          =   lc-global-user
                tt-ticket.CreateDate        =   today
                tt-ticket.CreateTime        =   time
                tt-ticket.IssueNumber       =   Issue.IssueNumber
                tt-ticket.Reference         =   issActivity.description
                tt-ticket.TickID            =   ?
                tt-ticket.TxnDate           =   issActivity.ActDate
                tt-ticket.TxnTime           =   time
                tt-ticket.TxnType           =   "ACT"
                tt-ticket.IssActivityID     =   issActivity.IssActivityID.
        end.
        release issue.
        RUN tlib-PostTicket.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHeader Procedure 
PROCEDURE outputHeader :
/*------------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  Notes:       In the event that this Web object is state-aware, this is
               a good place to set the webState and webTimeout attributes.
------------------------------------------------------------------------------*/

  /* To make this a state-aware Web object, pass in the timeout period 
   * (in minutes) before running outputContentType.  If you supply a timeout 
   * period greater than 0, the Web object becomes state-aware and the 
   * following happens:
   *
   *   - 4GL variables webState and webTimeout are set
   *   - a cookie is created for the broker to id the client on the return trip
   *   - a cookie is created to id the correct procedure on the return trip
   *
   * If you supply a timeout period less than 1, the following happens:
   *
   *   - 4GL variables webState and webTimeout are set to an empty string
   *   - a cookie is killed for the broker to id the client on the return trip
   *   - a cookie is killed to id the correct procedure on the return trip
   *
   * Example: Timeout period of 5 minutes for this Web object.
   *
   *   setWebState (5.0).
   */
    
  /* 
   * Output additional cookie information here before running outputContentType.
   *      For more information about the Netscape Cookie Specification, see
   *      http://home.netscape.com/newsref/std/cookie_spec.html  
   *   
   *      Name         - name of the cookie
   *      Value        - value of the cookie
   *      Expires date - Date to expire (optional). See TODAY function.
   *      Expires time - Time to expire (optional). See TIME function.
   *      Path         - Override default URL path (optional)
   *      Domain       - Override default domain (optional)
   *      Secure       - "secure" or unknown (optional)
   * 
   *      The following example sets cust-num=23 and expires tomorrow at (about) the 
   *      same time but only for secure (https) connections.
   *      
   *      RUN SetCookie IN web-utilities-hdl 
   *        ("custNum":U, "23":U, TODAY + 1, TIME, ?, ?, "secure":U).
   */ 
  output-content-type ("text/html":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    {lib/checkloggedin.i}

     assign lc-mode = get-value("mode")
               lc-rowid = get-value("rowid")
               lc-search = get-value("search")
               lc-firstrow = get-value("firstrow")
               lc-lastrow  = get-value("lastrow")
               lc-navigation = get-value("navigation")
               lc-account = get-value("account")
               lc-status  = get-value("status")
               lc-assign  = get-value("assign")
               lc-area    = get-value("area")
               lc-category = get-value("category")
               lc-submitsource = get-value("submitsource").


    if lc-mode = "" 
    then assign lc-mode = get-field("savemode")
                    lc-rowid = get-field("saverowid")
                    lc-search = get-value("savesearch")
                    lc-firstrow = get-value("savefirstrow")
                    lc-lastrow  = get-value("savelastrow")
                    lc-navigation = get-value("savenavigation")
                    lc-account = get-value("saveaccount")
                    lc-status  = get-value("savestatus")
                    lc-assign  = get-value("saveassign")
                    lc-area    = get-value("savearea")
                    lc-category = get-value("savecategory").

    assign lc-parameters = "search=" + lc-search +
                               "&firstrow=" + lc-firstrow + 
                               "&lastrow=" + lc-lastrow.


    find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock no-error.

    assign 
        lc-title = "Move Issue - " + string(b-table.IssueNumber)
        lc-link-url = appurl + '/iss/issue.p' + 
                        '?search=' + lc-search + 
                        '&firstrow=' + lc-firstrow + 
                        '&lastrow=' + lc-lastrow + 
                        '&navigation=refresh' +
                        '&time=' + string(time) + 
                        '&account=' + lc-account + 
                        '&status=' + lc-status +
                        '&assign=' + lc-assign + 
                        '&area=' + lc-area + 
                        '&category=' + lc-category
                        
        lc-link-label = "Cancel".

    

    if request_method = "POST" then
    do:

        RUN ip-MoveAccount ( to-rowid(lc-rowid),
                             get-value("newaccount")
                             ).
        RUN ip-BackToIssue.
        return.
    end.

    RUN outputHeader.

    {&out}
         '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">' skip 
         '<HTML>' skip
         '<HEAD>' skip

         '<meta http-equiv="Cache-Control" content="No-Cache">' skip
         '<meta http-equiv="Pragma"        content="No-Cache">' skip
         '<meta http-equiv="Expires"       content="0">' skip
         '<TITLE>' lc-title '</TITLE>' skip
         DYNAMIC-FUNCTION('htmlib-StyleSheet':U) skip
         '<script language="JavaScript" src="/scripts/js/standard.js"></script>' skip
         DYNAMIC-FUNCTION('htmlib-CalendarInclude':U) skip.


    
    {&out}
         '</HEAD>' skip
         '<body class="normaltext" onUnload="ClosePage()">' skip
        .

    {&out}
           htmlib-StartForm("mainform","post", appurl + '/iss/moveissue.p' )
           htmlib-ProgramTitle(lc-title).


     {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip
           htmlib-Hidden ("saveaccount", lc-account) skip
           htmlib-Hidden ("savestatus", lc-status) skip
           htmlib-Hidden ("saveassign", lc-assign) skip
           htmlib-Hidden ("savearea", lc-area) skip
           htmlib-Hidden ("savecategory", lc-category ) skip.
    
    {&out} htmlib-Hidden("submitsource","null").

    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.


    RUN ip-BuildPage.

    {&out} '<br><br><center>' htmlib-SubmitButton("submitform","Update Account").

    {&OUT} htmlib-EndForm() skip.

    
    
    {&out} htmlib-Footer() skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

