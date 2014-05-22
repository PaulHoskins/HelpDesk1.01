&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/confissue.p
    
    Purpose:        Confirm Issue Creation
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      CompanyCode      
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.


def var lc-issuenumber as char no-undo.


def var lc-title        as char no-undo.
def var ll-customer     as log  no-undo.

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
{iss/issue.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
    def var ll-ok as log no-undo.

    def var lc-customer as char no-undo.
    def var lc-raised   as char no-undo.
    def var lc-area     as char no-undo.

    def buffer b-cust for Customer.
    def buffer b-iss  for Issue.
    def buffer b-user for WebUser.
    def buffer b-area for WebIssArea.

    {lib/checkloggedin.i}

    assign lc-issuenumber = get-value("newissue").
    if lc-issuenumber = ""
    then assign lc-issuenumber = get-value("savenewissue").

    ll-customer = com-IsCustomer(lc-global-company,lc-user).

    assign lc-title = 'Issue Created'.
   
    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip.
  
    {&out}
           htmlib-StartForm("mainform","post", appurl + '/iss/confissue.p' )
           htmlib-ProgramTitle(lc-title) skip.


    {&out} htmlib-Hidden("savenewissue",lc-issuenumber)
           htmlib-TextLink("Add New Issue",appurl + '/iss/addissue.p') '<BR><BR>' skip
           '<table align=center cellpadding="5">' skip.


    find b-iss where b-iss.CompanyCode = lc-global-company
                 and b-iss.IssueNumber = int(lc-issuenumber) no-lock no-error.
    if not avail b-iss then return.

    find b-cust of b-iss no-lock no-error.
    if avail b-cust 
    then assign lc-customer = b-cust.AccountNumber + ' ' + b-cust.name.
    else assign lc-customer = "".

    find b-user where b-user.LoginId = b-iss.RaisedLoginID no-lock no-error.
    if avail b-user 
    then assign lc-raised = b-user.name.
    else assign lc-raised = "".

    find b-area of b-iss no-lock no-error.
    if avail b-area
    then assign lc-area = b-area.description.
    else assign lc-area = "".

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            htmlib-SideLabel("Issue Number")
            '</TD>' 
            htmlib-TableField(html-encode(lc-issuenumber),'left')
            '<TD VALIGN="TOP" ALIGN="right">' 
            htmlib-SideLabel("Customer")
            '</TD>' 
            htmlib-TableField(html-encode(lc-customer),'left')
            '</TR>' skip. 

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            htmlib-SideLabel("Raised By")
            '</TD>' 
            htmlib-TableField(html-encode(lc-raised),'left')
            '<TD VALIGN="TOP" ALIGN="right">' 
            htmlib-SideLabel("Area")
            '</TD>' 
            htmlib-TableField(html-encode(lc-area),'left')
            '</TR>' skip. 

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            htmlib-SideLabel("Brief Description")
            '</TD>' 
            htmlib-TableField(html-encode(b-iss.BriefDescription),'left')
            '<TD VALIGN="TOP" ALIGN="right">' 
            htmlib-SideLabel("Details")
            '</TD>' 
            htmlib-TableField(replace(b-iss.LongDescription,'~n','<BR>'),'left')
            '</TR>' skip. 
   
    if ll-customer then
    do:
        {&out} '<tr><th colspan="4" align="center">'
               'The helpdesk have been informed about this issue'
               '</th></tr>'.
    end.
    {&out} htmlib-EndTable() skip.

    
    {&OUT}  htmlib-EndForm() skip
            htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

