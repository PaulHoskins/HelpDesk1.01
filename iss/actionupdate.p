&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/actionupdate.p
    
    Purpose:        Issue - Action Add/Update
    
    Notes:
    
    
    When        Who         What
    09/04/2006  phoski      Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


def var lc-issue-rowid          as char no-undo.
def var lc-rowid                as char no-undo.
def var lc-title                as char no-undo.
def var lc-mode                 as char no-undo.

def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.

def buffer b-table  for IssAction.
def buffer issue    for Issue.
def buffer b-user   for WebUser.
def buffer customer for Customer.

def var lc-list-action      as char no-undo.
def var lc-list-aname       as char no-undo.
def var lc-list-assign      as char no-undo.
def var lc-list-assname     as char no-undo.

def var lc-actioncode       as char     no-undo.
def var lc-notes            as char     no-undo.
def var lc-assign           as char     no-undo.
def var lc-status           as char     no-undo.
def var lc-actiondate       as char     no-undo.
def var lc-CustomerView     as char     no-undo.


def var lf-Audit            as dec  no-undo.
def var lc-temp             as char no-undo.

def var lr-temp             as rowid no-undo.


{iss/issue.i}

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
         HEIGHT             = 14.14
         WIDTH              = 60.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}
{lib/maillib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-HeaderInclude-Calendar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-HeaderInclude-Calendar Procedure 
PROCEDURE ip-HeaderInclude-Calendar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Page Procedure 
PROCEDURE ip-Page :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&out} htmlib-StartInputTable() skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("actiondate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Date")
            else htmlib-SideLabel("Date"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("actiondate",10,lc-actiondate) 
            htmlib-CalendarLink("actiondate")
           '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-actiondate),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("actiontype",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Action Type")
           else htmlib-SideLabel("Action Type"))
           '</TD>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-Select("actioncode",lc-list-action,lc-list-aname,
                lc-actioncode)
           '</TD>'.
    else
    {&out} htmlib-TableField(html-encode(lc-actioncode),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            htmlib-SideLabel("Issue Details")
          '</TD>' skip
           '<TD VALIGN="TOP" ALIGN="left" class="tablefield">'
           replace(Issue.LongDescription,"~n","<br>")
          '<br><input type="button" class="submitbutton" onclick="copyinfo();" value="Copy To Note">' skip
          '</TD></tr>' skip
           skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          (if lookup("statnote",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("Note")
          else htmlib-SideLabel("Note"))
          '</TD>' skip
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-TextArea("notes",lc-notes,6,40)
          '</TD></tr>' skip
           skip.

   {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           (if lookup("assign",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Assigned To")
           else htmlib-SideLabel("Assigned To"))
           '</TD>' 
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-Select("assign",lc-list-assign,lc-list-assname,
               lc-assign)
           '</TD></TR>' skip. 

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("customerview",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Customer View?")
            else htmlib-SideLabel("Customer View?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("customerview", if lc-customerview = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-customerview = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("status",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Action Status")
            else htmlib-SideLabel("Action Status"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("status",lc-global-action-code,lc-global-action-display,lc-status)
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(dynamic-function("com-DecodeLookup",lc-status,
                                     lc-global-action-code,
                                     lc-global-action-display
                                     ),'left')
           skip.
    {&out} '</TR>' skip.



    {&out} htmlib-EndTable() skip.

    if lc-error-msg <> "" then
    do:
       {&out} '<BR><BR><CENTER>' 
               htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.
    
    if lc-submit-label <> "" then
    do:
       {&out} '<center>' htmlib-SubmitButton("submitform",lc-submit-label) 
              '</center>' skip.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Validate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Validate Procedure 
PROCEDURE ip-Validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.


    def var ld-date     as date     no-undo.
    def var li-int      as int      no-undo.

    assign
        ld-date = date(lc-actiondate) no-error.

    if error-status:error
    or ld-date = ? 
    then run htmlib-AddErrorMessage(
                    'actiondate', 
                    'The date is invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).



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
  emails:       In the event that this Web object is state-aware, this is
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
  emails:       
------------------------------------------------------------------------------*/

    {lib/checkloggedin.i}

    assign 
        lc-issue-rowid = get-value("issuerowid")
        lc-mode        = get-value("mode")
        lc-rowid       = get-value("rowid").

    
    find issue
        where rowid(issue) = to-rowid(lc-issue-rowid) no-lock.
    find customer where Customer.CompanyCode = Issue.CompanyCode
                    and Customer.AccountNumber = Issue.AccountNumber
                    no-lock no-error.


    RUN com-GetAction ( lc-global-company , output lc-list-action, output lc-list-aname ).
    RUN com-GetAssignIssue ( lc-global-company , output lc-list-assign , output lc-list-assname ).

    case lc-mode:
        when 'add'
        then assign lc-title = 'Add'
                    lc-link-label = "Cancel addition"
                    lc-submit-label = "Add Action".
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Action'.
    end case.

    assign
        lc-title = lc-title + " Action - Issue " + string(issue.IssueNumber).


    if request_method = "POST" then
    do:
        if lc-mode <> "delete" then
        do:
            assign lc-actioncode   = get-value("actioncode")
                   lc-notes        = get-value("notes")
                   lc-assign       = get-value("assign")
                   lc-status       = get-value("status")
                   lc-actiondate   = get-value("actiondate")
                   lc-customerview   = get-value("customerview")
                   .
            
               
            RUN ip-Validate( output lc-error-field,
                             output lc-error-msg ).

            if lc-error-msg = "" then
            do:
                
                if lc-mode = 'update' then
                do:
                    find b-table where rowid(b-table) = to-rowid(lc-rowid)
                        exclusive-lock no-wait no-error.
                    if locked b-table 
                    then  run htmlib-AddErrorMessage(
                                   'none', 
                                   'This record is locked by another user',
                                   input-output lc-error-field,
                                   input-output lc-error-msg ).
                end.
                else
                do:
                    find WebAction
                        where WebAction.CompanyCode = lc-global-company
                          and WebAction.ActionCode  = lc-ActionCode
                          no-lock no-error.
                    create b-table.
                    assign b-table.actionID    = WebAction.ActionID
                           b-table.CompanyCode = lc-global-company
                           b-table.IssueNumber = issue.IssueNumber
                           b-table.CreateDate  = today
                           b-table.CreateTime  = time
                           b-table.CreatedBy   = lc-global-user
                           b-table.customerview    = lc-customerview = "on"
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
                            b-table.IssActionID = lf-audit.
                        leave.
                    end.
                   
                end.
                if lc-error-msg = "" then
                do:
                    assign b-table.notes            = lc-notes
                           b-table.ActionStatus     = lc-Status
                           b-table.ActionDate       = date(lc-ActionDate)
                           b-table.customerview    = lc-customerview = "on".

                    if lc-mode = "ADD"
                    or b-table.assignto <> lc-assign then 
                    do:
                        if lc-assign = ""
                        then assign b-table.AssignDate = ?
                                    b-table.AssignTime = 0.
                        else
                        do:
                            assign b-table.AssignDate = today
                                   b-table.AssignTime = time
                                   b-table.AssignBy   = lc-global-user.
                            find WebAction
                                where WebAction.ActionID = b-table.ActionID
                                  no-lock no-error.
                            find b-user
                                where b-user.LoginID = lc-assign
                                no-lock no-error.
                            if avail webaction
                            and webaction.emailassign
                            and avail b-user
                            and b-user.email <> "" then
                            do:
                                assign
                                    lc-temp = 
                                        "Customer: " + Customer.name + "~n" + 
                                        "Issue Number: " + string(Issue.IssueNumber) + '~n' + 
                                        "Issue Description: " + Issue.BriefDescription + '~n'.
                                if Issue.LongDescription <> "" 
                                then assign lc-temp = lc-temp + Issue.LongDescription + "~n".

                                assign lc-temp = lc-temp + "~nAction Details~n" + 
                                                 webAction.description + "~n" + 
                                                 b-table.Notes + "~n~n" + 
                                                 "Assigned to you by " + 
                                                 com-UserName(lc-global-user) + 
                                                 " on " + string(b-table.AssignDate,'99/99/9999') + 
                                                 " " + string(b-table.AssignTime,"hh:mm am").
                                              
                                dynamic-function("mlib-SendEmail",
                                                 lc-global-company,
                                                 "",
                                                 "HelpDesk Action Assignment - Issue " + 
                                                 string(Issue.IssueNumber),
                                                 lc-temp,
                                                 b-user.email).
                            end.

                        end.
                    end.
                    assign
                        b-table.AssignTo = lc-assign.

                    if lc-mode = "ADD" then
                    do:
                        assign lr-temp = rowid(b-table).
                        release b-table.
                        find b-table where rowid(b-table) = lr-temp exclusive-lock.

                        dynamic-function("islib-CreateAutoAction",
                                         b-table.IssActionID).
                    end.


                end.
            end.
        end.
        else
        do:
            find b-table where rowid(b-table) = to-rowid(lc-rowid)
                 exclusive-lock no-wait no-error.
            if locked b-table 
            then run htmlib-AddErrorMessage(
                                   'none', 
                                   'This record is locked by another user',
                                   input-output lc-error-field,
                                   input-output lc-error-msg ).
            else delete b-table.
        end.

        if lc-error-field = "" then
        do:
            
            RUN outputHeader.
            {&out} 
                '<html>' skip
                '<script language="javascript">' skip
                'var ParentWindow = opener' skip
                'ParentWindow.actionCreated()' skip
                
                '</script>' skip
                '<body><h1>ActionUpdated</h1></body></html>'.
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        find WebAction
            where WebAction.ActionID = b-table.ActionID no-lock no-error.
        assign lc-actioncode = WebAction.description.

        if can-do("view,delete",lc-mode)
        or request_method <> "post"
        then assign lc-notes        = b-table.notes
                    lc-assign       = b-table.assignto
                    lc-status       = b-table.ActionStatus
                    lc-actiondate   = string(b-table.ActionDate,'99/99/9999')
                    lc-customerview   = if b-table.CustomerView 
                                        then "on" else ""
                    .
       
    end.
    
    if request_method = "GET" and lc-mode = "ADD" then
    do:
        assign 
            lc-assign = lc-global-user
            lc-actiondate = string(today,'99/99/9999')
            lc-customerview = 
                       if Customer.ViewAction then "on" else "".
    end.


    /** **/

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           .

    {&out} 
        '<script>' skip
        'function copyinfo() ~{' skip
        'document.mainform.elements["notes"].value = document.mainform.elements["longdescription"].value' skip
        '~}' skip
        '</script>' skip.
    
    {&out}
       htmlib-StartForm("mainform","post", selfurl)
       htmlib-ProgramTitle(lc-title) skip.


    RUN ip-Page.

    {&out} htmlib-Hidden("issuerowid",lc-issue-rowid) skip
           htmlib-Hidden("mode",lc-mode) skip
           htmlib-Hidden("rowid",lc-rowid) skip
           htmlib-Hidden("longdescription",issue.LongDescription) skip.

    {&out} htmlib-EndForm() skip.


    if not can-do("view,delete",lc-mode)  then
    do:
        {&out}
            htmlib-CalendarScript("actiondate") skip.
    end.
    {&out}
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

