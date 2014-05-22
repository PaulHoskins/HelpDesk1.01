&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/issuerep.p
    
    Purpose:        Issue list/report for internal users
    
    Notes:
    
    
    When        Who         What
    05/04/2006  phoski      hidedisplay.js for issue detailed info
    06/04/2006  phoski      SearchField
    06/04/2006  phoski      Sort by descending issue number
    10/04/2006  phoski      CompanyCode
    11/04/2006  phoski      common routines
    11/04/2006  phoski      htmlib-trmouse()
      
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

def var lc-rowid as char no-undo.


def var li-max-lines as int initial 12 no-undo.
def var lr-first-row as rowid no-undo.
def var lr-last-row  as rowid no-undo.
def var li-count     as int   no-undo.
def var ll-prev      as log   no-undo.
def var ll-next      as log   no-undo.
def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.
def var lc-smessage     as char no-undo.
def var lc-link-otherp  as char no-undo.
def var lc-link-print   as char no-undo.
def var lc-char         as char no-undo.

def var lc-sel-account  as char no-undo.
def var lc-sel-status   as char no-undo.
def var lc-sel-assign   as char no-undo.
def var lc-sel-area     as char no-undo.
def var lc-status       as char no-undo.
def var lc-customer     as char no-undo.
def var lc-issdate      as char no-undo.
def var lc-raised       as char no-undo.
def var lc-assigned     as char no-undo.


def var lc-open-status  as char no-undo.
def var lc-closed-status as char no-undo.

def buffer b-query  for issue.
def buffer b-search for issue.
def buffer b-cust   for customer.
def buffer b-status for WebStatus.
def buffer b-user   for WebUser.
def buffer b-Area   for WebIssArea.
  
def query q for b-query scrolling.

def var lc-area         as char no-undo.
def var lc-list-acc     as char no-undo.
def var lc-list-aname   as char no-undo.
def var lc-acc-lo       as char no-undo.
def var lc-acc-hi       as char no-undo.
def var lc-ass-lo       as char no-undo.
def var lc-ass-hi       as char no-undo.
def var lc-area-lo      as char no-undo.
def var lc-area-hi      as char no-undo.
def var lc-srch-status  as char no-undo.
def var lc-srch-desc    as char no-undo.

def var lc-list-status  as char no-undo.
def var lc-list-sname   as char no-undo.

def var lc-list-assign  as char no-undo.
def var lc-list-assname   as char no-undo.


def var lc-list-area  as char no-undo.
def var lc-list-arname   as char no-undo.

def var lc-info         as char no-undo.
def var lc-object       as char no-undo.
def var li-tag-end      as int no-undo.
def var lc-dummy-return as char initial "MYXXX111PPP2222"   no-undo.

def var lc-frommenu     as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-Format-Select-Account) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Account Procedure 
FUNCTION Format-Select-Account RETURNS CHARACTER
   ( pc-htm as char )  FORWARD.

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
         HEIGHT             = 14.14
         WIDTH              = 60.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */


RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-ExportJScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportJScript Procedure 
PROCEDURE ip-ExportJScript :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&out} skip
            '<script language="JavaScript" src="/scripts/js/hidedisplay.js"></script>' skip.
    {&out} skip 
          '<script language="JavaScript">' skip.

    {&out} skip
        'function ChangeAccount() ~{' skip
        '   SubmitThePage("AccountChange")' skip
        '~}' skip

        'function ChangeStatus() ~{' skip
        '   SubmitThePage("StatusChange")' skip
        '~}' skip.

    {&out} skip
           '</script>' skip.
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


   
    assign lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation")
           lc-sel-account = get-value("account")
           lc-sel-status  = get-value("status")
           lc-sel-assign  = get-value("assign")
           lc-sel-area    = get-value("area").
    
    if lc-sel-account = ""
    then assign lc-sel-account = htmlib-Null().

    if lc-sel-status = ""
    then assign lc-sel-status = htmlib-Null().

    if lc-sel-assign = ""
    then assign lc-sel-assign = htmlib-Null().

    if lc-sel-area = ""
    then assign lc-sel-area = htmlib-Null().

    assign lc-parameters = "search=" + lc-search +
                           "&firstrow=" + lc-firstrow + 
                           "&lastrow=" + lc-lastrow.

    if get-value("frommenu") = "yes"
    then assign lc-sel-assign = lc-global-user
                lc-sel-status = "AllOpen".
    assign lc-char = '100000'.
    
    assign li-max-lines = int(lc-char) no-error.
    if error-status:error
    or li-max-lines < 1
    or li-max-lines = ? then li-max-lines = 12.

    

    RUN com-GetCustomer ( lc-global-company , lc-global-user, output lc-list-acc, output lc-list-aname ).

    RUN com-GetStatus ( lc-global-company , output lc-list-status, output lc-list-sname ).

    RUN com-StatusType ( lc-global-company , output lc-open-status , output lc-closed-status ).

    find webuser where webuser.companycode = lc-global-company
        and webuser.loginid = lc-global-user no-lock.
    if webuser.UserClass = "CONTRACT" 
    then assign lc-list-assign = webuser.loginid
                lc-list-assname = webuser.name
                lc-sel-assign   = webuser.loginid.

    else RUN com-GetAssign ( lc-global-company , output lc-list-assign , output lc-list-assname ).
    
    RUN com-GetArea ( lc-global-company , output lc-list-area , output lc-list-arname ).


    assign lc-link-print = appurl + '/iss/issueprint.p?account=' + html-encode(lc-sel-account) 
                         + '&area=' + lc-sel-area 
                         + '&assign=' + lc-sel-assign 
                         + '&status=' + lc-sel-status.

    RUN outputHeader.
    
    {&out} htmlib-Header("Issue Report") skip.

    RUN ip-ExportJScript.

    {&out} htmlib-JScript-Maintenance() skip.

    {&out} htmlib-StartForm("mainform","post", appurl + '/iss/issuerep.p' ) skip.

    {&out} htmlib-ProgramTitle("Issue Report") 
           htmlib-hidden("submitsource","") skip.
    
    {&out} htmlib-BeginCriteria("Search Issues").
    {&out} '<table width="95%" align=center><tr>' skip
           
           '<td align=right valign=top>' htmlib-SideLabel("Customer") '</td>'
           '<td align=left valign=top>' 
                format-Select-Account(htmlib-Select("account",lc-list-acc,lc-list-aname,lc-sel-account)) '</td>'
           '<td align=right valign=top>' htmlib-SideLabel("Status") '</td>'
           '<td align=left valign=top>' skip(2)
                format-Select-Account(htmlib-Select("status",lc-list-status,lc-list-sname,lc-sel-status)) '</td>'
           skip(2)
           '<td align=right valign=top>' htmlib-SideLabel("Assigned") '</td>'
           '<td align=left valign=top>' 
                format-Select-Account(htmlib-Select("assign",lc-list-assign,lc-list-assname,lc-sel-assign)) '</td>'
           '<td align=right valign=top>' htmlib-SideLabel("Area") '</td>'
           '<td align=left valign=top>' 
                format-Select-Account(htmlib-Select("area",lc-list-area,lc-list-arname,lc-sel-area)) '</td>'
           '</tr>' skip
           .

    {&out} htmlib-EndPanel().

    {&out} htmlib-EndCriteria().

    {&out}
            tbar-Begin(
                replace(tbar-Find(appurl + "/iss/issuerep.p"),'MntButtonPress','IssueButtonPress')
                )
            tbar-Link("pdf",?,
                      'javascript:RepWindow('
                          + '~'' + lc-link-print 
                          + '~'' 
                          + ');'
                      ,lc-link-otherp)
            tbar-BeginOption()
            tbar-Link("view",?,"off",lc-link-otherp)
            tbar-EndOption()
            tbar-End().

    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="97%"') skip
           htmlib-TableHeading(
            "Issue Number^right|Date^right|Brief Description^left|Status^left|Area|Assigned To|Customer^left"
            ) skip.


    if lc-sel-account = htmlib-Null()
    then assign lc-acc-lo = ""
                lc-acc-hi = "ZZZZZZZZZZZZZZZZZZZZZZZZ".
    else assign lc-acc-lo = lc-sel-account
                lc-acc-hi = lc-sel-account.

    if lc-sel-status = htmlib-Null() 
    then assign lc-srch-status = "*".
    else
    if lc-sel-status = "AllOpen" 
    then assign lc-srch-status = lc-open-status.
    else 
    if lc-sel-status = "AllClosed"
    then assign lc-srch-status = lc-closed-status.
    else assign lc-srch-status = lc-sel-status.

    
    if lc-sel-assign = htmlib-null() 
    then assign lc-ass-lo = ""
                lc-ass-hi = "ZZZZZZZZZZZZZZZZ".
    else
    if lc-sel-assign = "NotAssigned" 
    then assign lc-ass-lo = ""
                lc-ass-hi = "".
    else assign lc-ass-lo = lc-sel-assign
                lc-ass-hi = lc-sel-assign.

    if lc-sel-area = htmlib-null() 
    then assign lc-area-lo = ""
                lc-area-hi = "ZZZZZZZZZZZZZZZZ".
    else
    if lc-sel-area = "NotAssigned" 
    then assign lc-area-lo = ""
                lc-area-hi = "".
    else assign lc-area-lo = lc-sel-area
                lc-area-hi = lc-sel-area.


    if lc-search > "" then
    open query q for each b-query no-lock
        where b-query.Company = lc-global-company
          and b-query.AccountNumber >= lc-acc-lo
          and b-query.AccountNumber <= lc-acc-hi
          and b-query.AssignTo >= lc-ass-lo
          and b-query.AssignTo <= lc-ass-hi
          and b-query.AreaCode >= lc-area-lo
          and b-query.AreaCode <= lc-area-hi
          and can-do(lc-srch-status,b-query.StatusCode)
          and b-query.SearchField contains lc-search
          by b-query.IssueNumber desc.
    else
    open query q for each b-query no-lock
        where b-query.Company = lc-global-company
          and b-query.AccountNumber >= lc-acc-lo
          and b-query.AccountNumber <= lc-acc-hi
          and b-query.AssignTo >= lc-ass-lo
          and b-query.AssignTo <= lc-ass-hi
          and b-query.AreaCode >= lc-area-lo
          and b-query.AreaCode <= lc-area-hi
          and can-do(lc-srch-status,b-query.StatusCode)
          by b-query.IssueNumber desc.

    get first q no-lock.

    if lc-navigation = "nextpage" then
    do:
        reposition q to rowid to-rowid(lc-lastrow) no-error.
        if error-status:error = false then
        do:
            get next q no-lock.
            get next q no-lock.
            if not avail b-query then get first q.
        end.
    end.
    else
    if lc-navigation = "prevpage" then
    do:
        reposition q to rowid to-rowid(lc-firstrow) no-error.
        if error-status:error = false then
        do:
            get next q no-lock.
            reposition q backwards li-max-lines + 1.
            get next q no-lock.
            if not avail b-query then get first q.
        end.
    end.
    else
    if lc-navigation = "refresh" then
    do:
        reposition q to rowid to-rowid(lc-firstrow) no-error.
        if error-status:error = false then
        do:
            get next q no-lock.
            if not avail b-query then get first q.
        end.  
        else get first q.
    end.

    assign li-count = 0
           lr-first-row = ?
           lr-last-row  = ?.

    repeat while avail b-query:
   
        
        assign lc-rowid = string(rowid(b-query))
               lc-issdate = if b-query.issuedate = ? then "" else string(b-query.issuedate,'99/99/9999').
        
        assign li-count = li-count + 1.
        if lr-first-row = ?
        then assign lr-first-row = rowid(b-query).
        assign lr-last-row = rowid(b-query).
        
        assign lc-link-otherp = 'search=' + lc-search +
                                '&firstrow=' + string(lr-first-row) +
                                '&account=' + lc-sel-account + 
                                '&status=' + lc-sel-status + 
                                '&assign=' + lc-sel-assign + 
                                '&area=' + lc-sel-area.

        find b-cust of b-query no-lock no-error.
        assign lc-customer = if avail b-cust then b-cust.name else "".

        find b-status of b-query no-lock no-error.
        if avail b-status then
        do:
            assign lc-status = b-status.Description.
            if b-status.CompletedStatus
            then lc-status = lc-status + ' (closed)'.
            else lc-status = lc-status + ' (open)'.
        end.
        else lc-status = "".

        find b-user where b-user.LoginID = b-query.RaisedLogin no-lock no-error.
        assign lc-raised = if avail b-user then b-user.name else "".

        find b-user where b-user.LoginID = b-query.AssignTo no-lock no-error.
        assign lc-assigned = if avail b-user then b-user.name else "".

        find b-area of b-query no-lock no-error.
        assign lc-area = if avail b-area then b-area.description else "".

        {&out}
            skip
            tbar-tr(rowid(b-query))
            skip
            htmlib-MntTableField(html-encode(string(b-query.issuenumber)),'right')
            htmlib-MntTableField(html-encode(lc-issdate),'right') skip.

        if b-query.LongDescription <> ""
        and b-query.LongDescription <> b-query.briefdescription then
        do:
        
            assign lc-info = 
                replace(htmlib-MntTableField(html-encode(b-query.briefdescription),'left'),'</td>','')
                lc-object = "hdobj" + string(b-query.issuenumber).
    
            assign li-tag-end = index(lc-info,">").

            {&out} substr(lc-info,1,li-tag-end).

            assign substr(lc-info,1,li-tag-end) = "".

            {&out} 
                '<img class="expandboxi" src="/images/general/plus.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">':U skip.
            {&out} lc-info.
    
            {&out} htmlib-ExpandBox(lc-object,b-query.LongDescription).
            
            {&out} '</td>' skip.
        end.
        else {&out} htmlib-MntTableField(html-encode(b-query.briefdescription),"left").

        {&out}
            htmlib-MntTableField(html-encode(lc-status),'left')
            htmlib-MntTableField(html-encode(lc-area),'left')
            htmlib-MntTableField(html-encode(lc-assigned),'left').

        if lc-raised = ""
        then {&out} htmlib-MntTableField(html-encode(lc-customer),'left').
        else
        do:
            assign lc-info = 
                replace(htmlib-MntTableField(html-encode(lc-customer),'left'),'</td>','')
                lc-object = "hdobjcust" + string(b-query.issuenumber).
    
            assign li-tag-end = index(lc-info,">").

            {&out} substr(lc-info,1,li-tag-end).

            assign substr(lc-info,1,li-tag-end) = "".

            {&out} 
                '<img class="expandboxi" src="/images/general/plus.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">':U skip.
            {&out} lc-info.
    
            {&out} htmlib-SimpleExpandBox(lc-object,lc-raised).
            
            {&out} '</td>' skip.
        end.
                                                       /*
            htmlib-MntTableField(html-encode(lc-raised),'left').
                                                         */

        {&out} skip
                tbar-BeginHidden(rowid(b-query))
                tbar-Link("view",rowid(b-query),
                          'javascript:HelpWindow('
                          + '~'' + appurl 
                          + '/iss/issueview.p?rowid=' + string(rowid(b-query))
                          + '~'' 
                          + ');'
                          ,lc-link-otherp)
                
            tbar-EndHidden() skip.

        /*

            '<td valign="top" align="left">' skip
            '<a href="javascript:HelpWindow(~'' + 
                appurl + '/' + '/iss/issueview.p?rowid=' + string(rowid(b-query)) 
                + '~')">'
                '<IMG border="0" src="/images/maintenance/view.gif" alg="View">'
            '</A></td>' skip
            */

        {&out}
            '</tr>' skip.

       

       get next q no-lock.
            
    end.

   {&out} skip 
           htmlib-EndTable()
           skip.

    

    {&out} skip
           htmlib-Hidden("firstrow", string(lr-first-row)) skip
           htmlib-Hidden("lastrow", string(lr-last-row)) skip
           skip.

    
    {&out} htmlib-EndForm().

    
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-Format-Select-Account) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Account Procedure 
FUNCTION Format-Select-Account RETURNS CHARACTER
   ( pc-htm as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<select',
                   '<select onChange="ChangeAccount()"')
                   . 


  RETURN lc-htm.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

