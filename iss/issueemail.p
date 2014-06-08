&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/issueemail.p
    
    Purpose:        Issue Email Page
    
    Notes:
    
    
    When        Who         What
    07/06/2014  phoski      Initial
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

def var lc-rowid as char no-undo.
def var lc-link-print as char no-undo.

def var li-max-lines as int initial 12 no-undo.
def var lr-first-row as rowid no-undo.
def var lr-last-row  as rowid no-undo.
def var li-count     as int   no-undo.

def var lc-status       as char no-undo.
def var lc-customer     as char no-undo.
def var lc-issdate      as char no-undo.
def var lc-raised       as char no-undo.
def var lc-assigned     as char no-undo.
DEF buffer issue        for issue.
def buffer customer     for customer.
def buffer WebStatus    for WebStatus.
def buffer WebUser      for WebUser.
def buffer WebIssArea   for WebIssArea.
def buffer this-user    for WebUser.
  

DEF VAR lc-IPref        AS CHAR     NO-UNDO.
DEF VAR lc-iField       AS CHAR     NO-UNDO.


DEF VAR li-col          AS INT      NO-UNDO.
def var lc-area         as char no-undo.
def var lc-info         as char no-undo.
def var lc-object       as char no-undo.
def var li-tag-end      as int no-undo.
def var lc-dummy-return as char initial "MYXXX111PPP2222"   no-undo.


def var lc-QPhrase  as char    no-undo.
def var vhLBuffer       as handle  no-undo.
def var vhLQuery        as handle  no-undo.

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
         HEIGHT             = 14.15
         WIDTH              = 60.57.
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

&IF DEFINED(EXCLUDE-ip-EmailHTML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-EmailHTML Procedure 
PROCEDURE ip-EmailHTML :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  {&out}
      '<tr><td colspan=' li-col '>' SKIP
       htmlib-BeginCriteria("Email Details " + STRING(issue.IssueNumber)).

  lc-IField = lc-iPref + 'tmped'.

  {&out} replace(get-value(lc-iField),'~n','<BR />'). 
  {&out}
      htmlib-EndCriteria()
      '</td></tr>' SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
        '~}' skip

            'function ChangeDates() ~{' skip
        '   SubmitThePage("DatesChange")' skip
        '~}' skip.

    {&out} skip
           '</script>' skip.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-InitialProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-InitialProcess Procedure 
PROCEDURE ip-InitialProcess :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ipGetMethodProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ipGetMethodProcess Procedure 
PROCEDURE ipGetMethodProcess :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   

    def var lc-descr        as char no-undo.
    def var lc-tmpcode      AS CHAR NO-UNDO.
    DEF VAR lc-tmptxt       AS CHAR NO-UNDO.
    DEF VAR lc-convtxt      AS CHAR NO-UNDO.

    for each issue NO-LOCK where issue.CompanyCode = lc-global-company
                             AND issue.assignto = lc-global-user,
        FIRST WebStatus of issue where WebStatus.CompletedStatus = no no-lock:

        assign
            lc-ipref = "I" + STRING(issue.IssueNumber)
            lc-IField = lc-iPref + 'tmpsel'
            lc-TmpCode = issue.LastTmpCode.
        IF lc-TmpCode = "" THEN lc-TmpCode = "1".

        set-user-field(lc-iField,lc-TmpCode).

        IF lc-tmpCode = "" THEN NEXT.

        FIND iemailtmp
                WHERE iemailtmp.companyCode = lc-global-company
                  AND iemailtmp.tmpCode = lc-tmpCode
                  NO-LOCK NO-ERROR.
        IF NOT AVAIL iemailtmp THEN NEXT.
        
        RUN lib/translatetemplate.p 
               (
                   lc-global-company,
                   iemailtmp.tmpCode,
                   issue.issueNumber,
                   NO,
                   iemailtmp.tmptxt,
                   OUTPUT lc-convtxt,
                   OUTPUT lc-descr
               ).
        
        
        lc-IField = lc-iPref + 'tmped'.
        set-user-field(lc-iField,lc-convtxt).
        





   END.

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

    DEF VAR iloop       AS INT      NO-UNDO.
    DEF VAR cPart       AS CHAR     NO-UNDO.
    DEF VAR cCode       AS CHAR     NO-UNDO.
    DEF VAR cDesc       AS CHAR     NO-UNDO.
    DEF VAR lc-LastAct  AS CHAR     NO-UNDO.
   
    
    find this-user
        where this-user.LoginID = lc-global-user no-lock no-error.
    

    RUN ip-InitialProcess.

    IF REQUEST_method = "GET" THEN
    DO:
        RUN ipGetMethodProcess.
    END.
    ELSE
    DO:

    END.

    RUN outputHeader.
    {&out} DYNAMIC-FUNCTION('htmlib-CalendarInclude':U) skip.
    {&out} htmlib-Header("Issue Email") skip.
    RUN ip-ExportJScript.
    {&out} htmlib-JScript-Maintenance() skip.
    {&out} htmlib-StartForm("mainform","post", appurl + '/iss/issueemail.p' ) skip.
    {&out} htmlib-ProgramTitle("Issue Email -" + this-user.NAME + " Open Issues ") 
           htmlib-hidden("submitsource","") skip.
    
   
   

    {&out}
        tbar-Begin("")
           
        tbar-BeginOption().
    {&out}
            tbar-Link("view",?,"off","").
      {&out}
            tbar-EndOption()
            tbar-End().


    {&out} skip
          replace(htmlib-StartMntTable(),'width="100%"','width="100%"') skip
          htmlib-TableHeading(
           "|SLA Date<br/>SLA Warning|Issue Number^right|Date^right|Brief Description^left|Status^left|Area|Class|Assigned To|Last Contact|Customer^left"
           ) skip.
    ASSIGN li-col = 11.


    assign li-count = 0
           lr-first-row = ?
           lr-last-row  = ?.

    for each issue NO-LOCK where issue.CompanyCode = lc-global-company
                             AND issue.assignto = lc-global-user,
        FIRST WebStatus of issue where WebStatus.CompletedStatus = no no-lock:

 
        assign lc-rowid = string(rowid(issue))
               lc-ipref = "I" + STRING(issue.IssueNumber)
               lc-issdate = if issue.issuedate = ? then "" else string(issue.issuedate,'99/99/9999').
        assign li-count = li-count + 1.
        if lr-first-row = ?
        then assign lr-first-row = rowid(issue).
        assign lr-last-row = rowid(issue).
       
        find customer of issue no-lock no-error.
        assign lc-customer = if avail customer then customer.name else "".

        assign lc-status = WebStatus.Description.
        if WebStatus.CompletedStatus
        THEN lc-status = lc-status + ' (closed)'.
        else lc-status = lc-status + ' (open)'.
        
        
        find WebUser where WebUser.LoginID = issue.AssignTo no-lock no-error.
        
        if avail WebUser then
        do:
            assign lc-assigned = WebUser.name.
            if issue.AssignDate <> ? then
            assign
                lc-assigned = lc-assigned + "~n" + string(issue.AssignDate,"99/99/9999") + " " +
                                                  string(issue.AssignTime,"hh:mm am").
        end.

        find WebUser where WebUser.LoginID = issue.RaisedLogin no-lock no-error.
        
        assign lc-raised = if avail WebUser then WebUser.name else "".
        assign lc-assigned = "".


        find WebIssArea of issue no-lock no-error.
        
        assign lc-area = if avail WebIssArea then WebIssArea.description else "".
        {&out}
            skip
            tbar-tr(rowid(issue))
            skip.

        /* SLA Traffic Light */
   
        {&out} '<td valign="top" align="right">' SKIP.

        IF issue.tlight = li-global-sla-fail
        THEN {&out} '<img src="/images/sla/fail.gif">' SKIP.
        ELSE
        IF issue.tlight = li-global-sla-amber
        THEN {&out} '<img src="/images/sla/warn.gif">' SKIP.
        
        ELSE
        IF issue.tlight = li-global-sla-ok
        THEN {&out} '<img src="/images/sla/ok.gif">' SKIP.
        ELSE {&out} '&nbsp;' SKIP.
        
        {&out} '</td>' skip.

        IF issue.slatrip <> ? THEN
        DO:
            {&out} '<td valign="top" align="left" nowrap>' SKIP
                   STRING(issue.slatrip,"99/99/9999 HH:MM") SKIP.


            IF issue.slaAmber <> ? THEN
            {&out} '<br/>' SKIP
                   STRING(issue.slaAmber,"99/99/9999 HH:MM") SKIP.
            {&out} '</td>' SKIP.

        END.
        ELSE {&out} '<td>&nbsp;</td>' SKIP.

        {&out}
            htmlib-MntTableField(html-encode(string(issue.issuenumber)),'right')
            htmlib-MntTableField(html-encode(lc-issdate),'right').
        if issue.LongDescription <> ""
        and issue.LongDescription <> issue.briefdescription then
        do:
            assign lc-info = 
                replace(htmlib-MntTableField(html-encode(issue.briefdescription),'left'),'</td>','')
                lc-object = "hdobj" + string(issue.issuenumber).
            assign li-tag-end = index(lc-info,">").
            {&out} substr(lc-info,1,li-tag-end).
            assign substr(lc-info,1,li-tag-end) = "".
            {&out} 
                '<img class="expandboxi" src="/images/general/plus.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">':U skip.
            {&out} lc-info.
            {&out} htmlib-ExpandBox(lc-object,issue.LongDescription).
            {&out} '</td>' skip.
        end.
        else {&out} htmlib-MntTableField(html-encode(issue.briefdescription),"left").
        {&out}
            htmlib-MntTableField(html-encode(lc-status),'left')
            htmlib-MntTableField(html-encode(lc-area),'left')
            htmlib-MntTableField(html-encode(issue.iclass),'left').
      
        IF issue.lastActivity = ?
        THEN lc-lastAct = "".
        ELSE lc-lastAct = STRING(issue.lastActivity,"99/99/9999 HH:MM").
        
        {&out}
            htmlib-MntTableField(replace(html-encode(lc-assigned),"~n","<br>"),'left')
            htmlib-MntTableField(replace(html-encode(lc-LastAct),"~n","<br>"),'left').

        
        if lc-raised = ""
        then {&out} htmlib-MntTableField(html-encode(lc-customer),'left').
        else
        do:
            assign lc-info = 
                replace(htmlib-MntTableField(html-encode(lc-customer),'left'),'</td>','')
                lc-object = "hdobjcust" + string(issue.issuenumber).
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
    
        
        {&out} skip
                tbar-BeginHidden(rowid(issue)).
        
        {&out}
                tbar-Link("view",rowid(issue),
                          'javascript:HelpWindow('
                          + '~'' + appurl 
                          + '/iss/issueview.p?rowid=' + string(rowid(issue))
                          + '~'' 
                          + ');'
                          ,"").
        
        {&out}
            tbar-EndHidden()
            SKIP.
          
        {&out}
           '</tr>' skip.

        RUN ip-EmailHTML.
 
       
    end.
 
    
    {&out} skip 
           htmlib-EndTable()
           skip.
    

    {&out} htmlib-EndForm() skip.

   

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

