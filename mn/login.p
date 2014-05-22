&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mn/login.p
    
    Purpose:        Helpdesk Login               
    
    Notes:
    
    
    When        Who         What
    08/04/2006  phoski      Page layout changes
    11/04/2006  phoski      Email password changes
    23/04/2006  phoski      Form changed
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

def var lc-user as char no-undo.
def var lc-pass as char no-undo.
def var lc-value as char no-undo.
def var lc-reason as char no-undo.

def var lc-url-company  as char no-undo.

def buffer WebUser      for webuser.
def buffer company      for company.

def var lc-AttrData     as char no-undo.

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
         HEIGHT             = 12.92
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

&IF DEFINED(EXCLUDE-ip-CompanyInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CompanyInfo Procedure 
PROCEDURE ip-CompanyInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&out} '<br><br><div class="loglink" style="clear:both;">'.
    if company.helpdeskEmail <> "" 
    then {&out} '<p><img src="/images/contact/email.gif">&nbsp;' 
                '<a href="mailto:' company.HelpDeskEmail '">'
        
                html-encode(company.helpdeskemail) 
        '</a>'
        '</p>'.
    if company.helpdeskPhone <> "" 
    then {&out} '<p><img src="/images/contact/phone.gif">&nbsp;' 
        html-encode(company.helpdeskphone) '</p>'.
    if company.WebAddress <> "" 
    then {&out} '<p><img  src="/images/contact/web.gif">&nbsp;'
                '<a href="' company.WebAddress '">'
                html-encode(company.WebAddress) 
                '</a>'
                '</p>'.
    


    {&out} '</div>'.
    

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

    def input param pc-user as char no-undo.
    def input param pc-pass as char no-undo.
    def output param pc-reason as char no-undo.

    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.


    assign pc-reason = "".

    def buffer b-webuser for webuser.

    if pc-user = "" then
    do:
        run htmlib-AddErrorMessage('User', 'You must enter your user name',
                                   input-output pc-error-field,
                                   input-output pc-error-msg ).
        return.
    end.
    
    
    find b-webuser where b-webuser.LoginID = pc-user no-lock no-error.
    if not avail b-webuser 
    or b-webuser.companycode <> lc-url-company then
    do:
        run htmlib-AddErrorMessage('User', 'This user name does not exist',
                                   input-output pc-error-field,
                                   input-output pc-error-msg ).
        return.
    end.

    if b-webuser.disabled then
    do:
        run htmlib-AddErrorMessage('User', 'Your user account has been disabled',
                                   input-output pc-error-field,
                                   input-output pc-error-msg ).

    end.

    if encode(lc-pass) <> b-webuser.Passwd then
    do:
        run htmlib-AddErrorMessage('User', 'The password is incorrect',
                                   input-output pc-error-field,
                                   input-output pc-error-msg ).
        assign pc-reason = "password".
        return.
    end.

    case b-webuser.UserClass:
        when "CONTRACT" then
        do:
            if not can-find(first ContAccess
                            where ContAccess.Loginid = b-webuser.LoginID
                            no-lock) then
            do:


            end.
        end.
    end case.

    

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
  

    assign
        lc-url-company = get-value("company").

    if lc-url-company = ""
    or not can-find(company where company.companycode = lc-url-company)
    then assign lc-url-company = "MICAR".

    assign
        lc-url-company = lc(lc-url-company)
        lc-global-company = lc-url-company.

    find company where company.companycode = lc-url-company no-lock no-error.
    
    if request_method = "GET" and get-value("logoff") = "yes" then
    do:
        delete-cookie("ExtranetUser",appurl,?).
    end.

    if request_method = "POST" then
    do:
        assign lc-user = get-field("user")
               lc-pass = get-field("password").

        RUN ip-Validate ( 
                            input lc-user,
                            input lc-pass,
                            output lc-reason,
                            output lc-error-field,
                            output lc-error-mess ).  
        if lc-error-mess = "" then
        do:
            run attrlib-SetAttribute("USER",lc-user,input-output lc-AttrData).
            run attrlib-SetAttribute("IP",remote_addr,input-output lc-AttrData).

            com-SystemLog("Login",lc-user,lc-AttrData).

            set-user-field("IPADD",REMOTE_ADDR).

            assign lc-value = htmlib-EncodeUser(lc-user). 
            
            find webUser 
                where webUser.LoginID = lc-user exclusive-lock no-wait no-error.
            if avail WebUser
            then assign WebUser.LastDate = today
                        WebUser.LastTime = time.

            Set-Cookie("ExtranetUser",
                      lc-value,
                      dynamic-function("com-CookieDate",lc-user),
                      dynamic-function("com-CookieTime",lc-user),
                      APPurl,
                      ?,
                      if hostURL begins "https" then "secure" else ?).

            assign
                REQUEST_METHOD = "GET".
            set-user-field("ExtranetUser",lc-user).
            if dynamic-function("com-RequirePasswordChange",lc-user) then 
            do:
                set-user-field("expire","yes").
                run run-web-object IN web-utilities-hdl ("mn/changepassword.p").

            end.
            else RUN run-web-object IN web-utilities-hdl ("mn/main.p").
            return.
        end.
        
    end.

    

    RUN outputHeader.
    
    {&out} htmlib-Header(company.name + " - Help Desk Login") skip.
    
    {&out}
            '<div style="width: 100%;">'
                '<img src="/images/menu/' lc-url-company '/banner.jpg" style="float: right;">'
            '</div>' skip.
   
    {&out} '<div style="clear: both;">'.

    {&out} htmlib-StartForm("mainform","post", selfurl ).
    
    {&out} '<table align="left" width="80%" style="font-size: 10px;">' skip
           '<tr><td align="left" rowspan="3" valign="top" style="xborder-right: 1px dotted black;">'
           '<img src="/images/topbar/' lc-url-company '/logo.gif" style="float: left; margin-right: 15px; margin-bottom: 15px;">'
           '<p><strong>Welcome to the ' company.name ' Help Desk</strong><p>'
           'Please enter your user name and password to login to the Help Desk.<br><br>'
           'If you require a user name and/or password then you can contact us using the following details:' skip.

    
    RUN ip-CompanyInfo.
    

    if lc-reason = "password" then 
    do:
        find WebUser where WebUser.Loginid = lc-user no-lock no-error.
        find company where company.companycode = WebUser.companycode no-lock.

        if WebUser.email <> "" 
        and ( company.smtp <> "" and company.helpdeskemail <> "" ) then
        do:
            {&out} '<br><br><div class="loglink">'
                    
                   '<p>Hi ' WebUser.forename ',<br>' skip
                   'The password entered was incorrect for your user name.&nbsp;'
                   'Click ' 
                        '<a href="' appurl "/mn/loginpass.p?rowid=" string(rowid(WebUser)) '" style="font-weight: bolder;">'
                        'here</a>'
                        ' for a new password to be generated and sent to your email address.'

                
                   '</p>' skip
                    '</div>'.
        end.
    end.
    {&out}
            '</td><td valign="top" align="right">' skip.


    {&out} '<table><tr><td>'.

    {&out} ( if lookup("user",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("User Name")
           else htmlib-SideLabel("User Name"))
           skip
           '</td><td valign="top" align="left">'
           htmlib-InputField("user",20,lc-user)
           skip
           '</td></tr><tr><td valign="top" align="right">' skip
           if lookup("password",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Password")
           else htmlib-SideLabel("Password")
           skip
           '</td><td valign="top" align="left">'
           htmlib-InputPassword("password",20,"")
           '</td></tr>'.

  
    {&out} '<tr><td align=center colspan="2" nowrap><BR>' htmlib-MultiplyErrorMessage(lc-error-mess)
           htmlib-SubmitButton("submitform","Login") skip
          '</td></tr></table>' skip.

    

    {&out} '</td></tr></table>' skip.


    
    {&out} htmlib-Hidden("company",lc-url-company).     
    
 

    {&out} htmlib-EndForm() skip '</div>'.
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

