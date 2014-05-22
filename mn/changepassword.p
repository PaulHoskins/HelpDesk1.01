&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*           This .W file was created with the Progress AppBuilder.     */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg   as char no-undo.

def var lc-oldpass     as char no-undo.
def var lc-newpass1    as char no-undo.
def var lc-newpass2    as char no-undo.

def var lc-expire       as char no-undo.

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
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-user as char no-undo.
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.

    def var li-length as int no-undo.

    def buffer b-user for webuser.


    assign li-length = int(htmlib-GetAttr("PasswordRule","MinLength")).

    find b-user where b-user.loginid = pc-user no-lock no-error.

    if not avail b-user then
    do:
        run htmlib-AddErrorMessage(
                    'null', 
                    'Your user record has been deleted',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        return.
    end.
    if lc-oldpass = "" 
    then run htmlib-AddErrorMessage(
                    'oldpass', 
                    'You must enter your old password',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
    else 
    if encode(lc-oldpass) <> b-user.passwd 
    then run htmlib-AddErrorMessage(
                    'oldpass', 
                    'This is not the correct password',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-newpass1 = "" 
    then run htmlib-AddErrorMessage(
                    'newpass1', 
                    'You must enter the new password',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
    else
    if length(lc-newpass1) < li-length 
    then run htmlib-AddErrorMessage(
                    'newpass1', 
                    'Your new password must be at least ' + 
                        string(li-length) + ' characters long',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
    else
    if lc-newpass1 begins pc-user 
    then run htmlib-AddErrorMessage(
                    'newpass1', 
                    'Your new password can start with or be your user name',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
    else
    if lc-newpass1 <> lc-newpass2 
    then run htmlib-AddErrorMessage(
                    'newpass1', 
                    'The new passwords must be the same',
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
    
    def buffer b-user for webuser.

    {lib/checkloggedin.i}

    lc-expire    = get-value("expire").

    if request_method = "POST" then
    do:
        assign lc-oldpass   = get-value("oldpass")
               lc-newpass1  = get-value("newpass1")
               lc-newpass2  = get-value("newpass2")
               .
        RUN ip-Validate ( lc-user ,
                          output lc-error-field,
                          output lc-error-msg ).
        if lc-error-msg = "" then
        do:

            find b-user where b-user.loginid = lc-user
                 exclusive-lock.
            assign b-user.passwd = encode(lc-newpass1).

            assign b-user.LastPasswordChange = today.

            
            set-user-field("passwordchanged","yes").
            if lc-expire = "yes"
            then RUN run-web-object IN web-utilities-hdl ("mn/main.p").
            else RUN run-web-object IN web-utilities-hdl ("mn/mainframe.p").
            return.

        end.
                   
    end.

    RUN outputHeader.
    
    {&out} htmlib-Header("Change Password") 
           htmlib-StartForm("mainform","post", appurl + '/mn/changepassword.p' ).

    if lc-expire = "yes"
    then {&out} htmlib-ProgramTitle("Password Expired - Please select a new one").
    else {&out} htmlib-ProgramTitle("Change Your Password").

    if lc-expire = "yes" then
    {&out}
      '<div style="border: 1px dotted red; padding: 15px; margin-bottom: 10px; margin-top: 10px; font-weight: bold; font-size: 12px; background-color: #FFFFCC;">'
                
        '<p>For security reasons your password is required to be changed.<p>'
        
      '</div>' skip.

    {&out} htmlib-StartInputTable() skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("oldpass",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Old Password")
           else htmlib-SideLabel("Old Password"))
           '</TD>' skip
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputPassword("oldpass",20,"") skip
           '</TD></TR>' SKIP.
    
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("newpass1",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("New Password")
           else htmlib-SideLabel("New Password"))
           '</TD>' skip
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputPassword("newpass1",20,"") skip
           '</TD></TR>' SKIP.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("newpass2",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Re-enter New Password")
           else htmlib-SideLabel("Re-enter New Password"))
           '</TD>' skip
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputPassword("newpass2",20,"") skip
           '</TD></TR>' SKIP.


    {&out} htmlib-EndTable() skip.

    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.

    {&out} '<center>' htmlib-SubmitButton("submitform","Change Password") 
               '</center>' skip.
    
    {&out}
        htmlib-hidden("expire",get-value("expire")).

    {&OUT} htmlib-EndForm() skip 
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

