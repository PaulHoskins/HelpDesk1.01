&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/iemailtest.p
    
    Purpose:        Email Template Tester  
    
    Notes:
    
    
    When        Who         What
    02/06/2014  phoski      Initial      
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.


def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.


def buffer b-valid for iemailtmp.
def buffer b-table for iemailtmp.
DEF BUFFER issue   FOR issue.



def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.



def var lc-descr        as char no-undo.
def var lc-tmpcode      AS CHAR NO-UNDO.
DEF VAR lc-tmptxt       AS CHAR NO-UNDO.
DEF VAR lc-issue        AS CHAR NO-UNDO.
DEF VAR lc-convtxt      AS CHAR NO-UNDO.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-Validate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Validate Procedure 
PROCEDURE ip-Validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  emails:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.
    DEF VAR li-int      AS INT      NO-UNDO.


    ASSIGN li-int = INT(lc-issue) NO-ERROR.

    IF ERROR-STATUS:ERROR
    OR li-int < 1 THEN
    DO:
        run htmlib-AddErrorMessage(
                        'issue', 
                        'The issue number must be entered',
                        input-output pc-error-field,
                        input-output pc-error-msg ).
        RETURN.

    END.

    FIND issue WHERE issue.companyCode = lc-global-company
                 AND issue.issueNumber = li-int NO-LOCK NO-ERROR.

    IF NOT AVAIL issue THEN
    DO:
        run htmlib-AddErrorMessage(
                        'issue', 
                        'The issue number does not exist',
                        input-output pc-error-field,
                        input-output pc-error-msg ).
        RETURN.

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
   *      The following example sets cutmpcode=23 and expires tomorrow at (about) the 
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
    
    DEF VAR iloop       AS INT      NO-UNDO.
    DEF VAR cPart       AS CHAR     NO-UNDO.
    DEF VAR cCode       AS CHAR     NO-UNDO.
    DEF VAR cDesc       AS CHAR     NO-UNDO.

    {lib/checkloggedin.i} 
    

    assign lc-mode = get-value("mode")
           lc-rowid = get-value("rowid")
           lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation").

    if lc-mode = "" 
    then assign lc-mode = get-field("savemode")
                lc-rowid = get-field("saverowid")
                lc-search = get-value("savesearch")
                lc-firstrow = get-value("savefirstrow")
                lc-lastrow  = get-value("savelastrow")
                lc-navigation = get-value("savenavigation").

    assign lc-parameters = "search=" + lc-search +
                           "&firstrow=" + lc-firstrow + 
                           "&lastrow=" + lc-lastrow.

    case lc-mode:
  
        when 'testv'
        then assign lc-link-label = "Back"
                    lc-submit-label = "Test Email Template".
  
    end case.


    assign lc-title = 'Test Email Template'
           lc-link-url = appurl + '/sys/iemailtmp.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&time=' + string(time)
                           .


    find b-table where rowid(b-table) = to-rowid(lc-rowid)
         no-lock no-error.
    if not avail b-table then
    do:
        set-user-field("mode",lc-mode).
        set-user-field("title",lc-title).
        set-user-field("nexturl",appurl + "/sys/iemailtmp.p").
        RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
        return.
    end.



    if request_method = "POST" then
    do:
    
        assign lc-issue     = get-value("issue")
              .
        
           
        RUN ip-Validate( output lc-error-field,
                         output lc-error-msg ).
    
        if lc-error-msg = "" then
        do:
            RUN lib/translatetemplate.p 
                (
                    lc-global-company,
                    b-table.tmpCode,
                    issue.issueNumber,
                    YES,
                    b-table.tmptxt,
                    OUTPUT lc-convtxt,
                    OUTPUT lc-error-msg
                ).
         

           
            
        end.
 
        
    end.
    ELSE
    DO:

        FIND LAST issue WHERE issue.companyCode = lc-global-company
                          AND issue.AssignTo = lc-user NO-LOCK NO-ERROR.
        IF NOT AVAIL issue THEN
        FIND LAST issue WHERE issue.companyCode = lc-global-company
                         NO-LOCK NO-ERROR.


        IF AVAIL issue
        THEN lc-issue = STRING(issue.IssueNumber).
    END.


    find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
    assign 
        lc-tmpcode = string(b-table.tmpcode)
        lc-descr   = b-table.descr
        lc-tmptxt  = b-table.tmptxt.


    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", appurl + '/sys/iemailtest.p' )
           htmlib-ProgramTitle(lc-title) skip.

    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip
           htmlib-Hidden ("nullfield", lc-navigation) skip.
        
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.

    {&out} htmlib-StartInputTable() skip.



    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("tmpcode",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Template Code")
           else htmlib-SideLabel("Template Code"))
           '</TD>' skip
           .

    {&out} htmlib-TableField(html-encode(lc-tmpcode),'left')
           skip.


    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("descr",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Description")
            else htmlib-SideLabel("Description"))
            '</TD>'
            htmlib-TableField(html-encode(lc-descr),'left')
            SKIP
            '</TR>'.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("tmptxt",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Template Text")
            else htmlib-SideLabel("Template Text"))
            '</TD>'
            htmlib-TableField(REPLACE(lc-tmptxt,'~n','<br />'),'left')
           '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("issue",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Test Issue Number")
            else htmlib-SideLabel("Test Issue Number"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("issue",15,lc-issue) 
            '</TD></tr>' skip.

    if request_method = "POST" then
    do:
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            htmlib-SideLabel("Merged Template")
            '</TD>'
            htmlib-TableField(REPLACE(lc-convtxt,'~n','<br />'),'left')
            '</TR>' skip.

    END.

    {&out} htmlib-EndTable() skip.


    if lc-error-msg <> "" then
    DO:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.

    if lc-submit-label <> "" then
    do:
        {&out} '<center>' htmlib-SubmitButton("submitform",lc-submit-label) 
               '</center>' skip.
    end.
         
    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

