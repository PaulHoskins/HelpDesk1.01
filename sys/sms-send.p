&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webuserpref.p
    
    Purpose:        User Preferences
    
    Notes:
    
    
    When        Who         What
    28/04/2006  phoski      Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.

def var lc-from         as char no-undo.
def var lc-to           as char no-undo.
def var lc-text         as char no-undo.

def var lc-url          as char no-undo.

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

&IF DEFINED(EXCLUDE-ip-AccessDenied) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-AccessDenied Procedure 
PROCEDURE ip-AccessDenied :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN outputHeader.
    
    {&out} htmlib-Header("Send SMS Message") skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle("Send SMS Message") skip.


    
    {&out} 
        '<p class="errormessage">'
            'You do not have access to this web page'
        '</p>'.
    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    

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
  emails:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.

    if lc-from = ""
    then run htmlib-AddErrorMessage(
                'from', 
                'You must enter who the message is from',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
    if length(lc-from) > 11
    then run htmlib-AddErrorMessage(
                'from', 
                'The from field can not be over 11 characters long',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
    if lc-to = ""
    then run htmlib-AddErrorMessage(
                'to', 
                'You must enter one or more mobiles numbers',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
                
    if lc-text = ""
    then run htmlib-AddErrorMessage(
                'text', 
                'You must enter a message to send',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
    if length(lc-text) > 160 
    then run htmlib-AddErrorMessage(
                'text', 
                'The message can not be over 160 characters long',
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

    find webuser where webuser.loginid = lc-user no-lock no-error.

    if webuser.UserClass = "CUSTOMER"
    or not webuser.AccessSMS then
    do:
        RUN ip-AccessDenied.
        return.

    end.

    assign
        lc-to = get-value("to")
        lc-text = get-value("text")
        lc-from = get-value("from").

    if request_method = "POST" then
    do:
        RUN ip-Validate( output lc-error-field,
                         output lc-error-msg ).

        if lc-error-field = "" then
        do:
            assign
                lc-url = 
                appurl + '/sys/sms-post.p'
                + '?username=' + lc-global-sms-username 
                + '&password=' + lc-global-sms-password
                + '&from=' + lc-from
                + '&to=' + lc-to
                + '&text=' + replace(lc-text,"~n"," ")
                .
                                  

        end.
    end.
    else
    do:
        find company where company.companycode = webuser.CompanyCode no-lock no-error.
        assign 
            lc-from = trim(substr(company.name,1,11)).
        
    end.
  
    RUN outputHeader.
    
    {&out} htmlib-Header("Send SMS Message") skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle("Send SMS Message") skip.


    
    {&out} htmlib-StartInputTable() skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("from",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("From")
           else htmlib-SideLabel("From"))
           '</TD>' skip
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("from",11,lc-from) skip
           '</TD>'
           '<td valign="top" style="font-size: 10px;padding-left: 10px; padding-bottom: 10px;">Can be your mobile number or a name etc.<br>(11 characters max)</td>'
           '</tr>'.
                    

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("to",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Send To Mobiles")
            else htmlib-SideLabel("Send To Mobiles"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TextArea("to",lc-to,4,30)
            '</TD>' skip
            '<td valign="top" style="font-size: 10px; padding-left: 10px; padding-bottom: 10px;">Enter the mobiles numbers, comma separated, to send the message to.<br>(100 numbers max)</td>'
            '</tr>'.

     {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("text",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Message")
            else htmlib-SideLabel("Message"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TextArea("text",lc-text,4,30)
            '</TD>' skip
         '<td valign="top" style="font-size: 10px; padding-left: 10px; padding-bottom: 10px;">Enter your message.<br>(160 characters max)</td>'

            '</tr>'.

    
    {&out} htmlib-EndTable() skip.


    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.
    
    if lc-url <> "" then
    do:
        {&out} skip
           '<div id="sms">'
           htmlib-StartFieldSet("Sending Message").

        {&out} '<p>Please wait.... See below for success ...</p>'.
        {&out} '<iframe src="' lc-url '" frameborder="0"></iframe>'.
        {&out} 
            htmlib-EndFieldSet() 
            '</div>'.

    end.
    {&out} '<center>' htmlib-SubmitButton("submitform","Send Message") 
               '</center>' skip.
    
         
    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

