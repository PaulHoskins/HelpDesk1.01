&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webcompmnt.p
    
    Purpose:        Company Maintenance             
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      Initial
    11/04/2006  phoski      SMTP & Email & WebAddress & EmailFooter
    23/04/2006  phoski      HelpDeskPhone
    14/07/2006  phoski      MonitorMessage
    21/03/2007  phoski      Timeout & PasswordExpire
    
    07/09/2010  DJS         3704  Removed streetmap button.
    30/04/2014  phoski      Marketing Banner

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


def buffer b-valid for company.
def buffer b-table for company.


def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.



def var lc-companycode      as char no-undo.
def var lc-name             as char no-undo.
def var lc-smtp             as char no-undo.
def var lc-helpdeskemail    as char no-undo.
def var lc-email2db         as char no-undo.
def var lc-HelpDeskPhone    as char no-undo.
def var lc-webaddress       as char no-undo.
def var lc-emailfooter      as char no-undo.
def var lc-monitormessage   as char no-undo.
def var lc-slabeginhour     as char no-undo.
def var lc-slabeginmin      as char no-undo.
def var lc-slaendhour     as char no-undo.
def var lc-slaendmin      as char no-undo.

def var lc-address1         as char no-undo.
def var lc-address2         as char no-undo.
def var lc-city             as char no-undo.
def var lc-county           as char no-undo.
def var lc-country          as char no-undo.
def var lc-postcode         as char no-undo.
def var lc-temp             as char no-undo.
def var lc-issueinfo        as char no-undo.
def var lc-TimeOut          as char no-undo.
def var lc-PasswordExpire   as char no-undo.
DEF VAR lc-mBanner          AS CHAR NO-UNDO.

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

&IF DEFINED(EXCLUDE-ip-BuildPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildPage Procedure 
PROCEDURE ip-BuildPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{&out} htmlib-StartInputTable() skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("companycode",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Company Code")
           else htmlib-SideLabel("Company Code"))
           '</TD>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("companycode",10,lc-companycode) skip
           '</TD>'.
    else
    {&out} htmlib-TableField(html-encode(lc-companycode),'left')
           skip.

    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("name",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Name")
            else htmlib-SideLabel("Name"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("name",40,lc-name) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-name),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("address1",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Address")
            else htmlib-SideLabel("Address"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("address1",40,lc-address1) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-address1),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("address2",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("")
            else htmlib-SideLabel(""))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("address2",40,lc-address2) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-address2),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("city",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("City/Town")
            else htmlib-SideLabel("City/Town"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("city",40,lc-city) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-city),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("county",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("County")
            else htmlib-SideLabel("County"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("county",40,lc-county) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-county),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("country",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Country")
            else htmlib-SideLabel("Country"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("country",40,lc-country) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-country),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("postcode",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Post Code")
            else htmlib-SideLabel("Post Code"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("postcode",20,lc-postcode) 
            '</TD>' skip.
    else 
    do:

        if lc-postcode = "" then 
        {&out} htmlib-TableField(html-encode(lc-postcode),'left')
           skip.
        else

         {&out}  replace(htmlib-TableField(html-encode(lc-postcode),'left'),"</td>","").

    end.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("webaddress",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Web Site")
            else htmlib-SideLabel("Web Site"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("webaddress",40,lc-webaddress) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-webaddress),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("smtp",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("SMTP Server")
            else htmlib-SideLabel("SMTP Server"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("smtp",40,lc-smtp) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-smtp),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("helpdeskemail",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("HelpDesk Email Address")
            else htmlib-SideLabel("HelpDesk Email Address"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("helpdeskemail",40,lc-helpdeskemail) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-helpdeskemail),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("email2db",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Email2DB Monitor")
            else htmlib-SideLabel("Email2DB Monitor"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("email2db",40,lc-email2db) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-email2db),'left')
           skip.
    {&out} '</TR>' skip.



    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("helpdeskphone",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("HelpDesk Phone")
            else htmlib-SideLabel("HelpDesk Phone"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("helpdeskphone",20,lc-helpdeskphone) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-helpdeskphone),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("timeout",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Timeout (Mins)")
            else htmlib-SideLabel("Timeout (Mins)"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("timeout",2,lc-timeout) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-timeout),'left')
           skip.
    {&out} '</TR>' skip.
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("passwordexpire",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Password Expiry (Days)")
            else htmlib-SideLabel("Password Expiry (Days)"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("passwordexpire",2,lc-passwordexpire) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-passwordexpire),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("emailfooter",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Email Footer")
            else htmlib-SideLabel("Email Footer"))
            '</TD>'.
    

    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TextArea("emailfooter",lc-emailfooter,10,60)
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(replace(html-encode(lc-emailfooter),"~n",'<br>'),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("monitormessage",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Email Monitor Reply")
            else htmlib-SideLabel("Email Monitor Reply"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TextArea("monitormessage",lc-monitormessage,10,60)
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(replace(html-encode(lc-monitormessage),"~n",'<br>'),'left')
           skip.
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("issueinfo",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Customer Note")
            else htmlib-SideLabel("Customer Note"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TextArea("issueinfo",lc-issueinfo,10,60)
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(replace(html-encode(lc-issueinfo),"~n",'<br>'),'left')
           skip.
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            if lookup("slabegin",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Office Hours Based SLA - Start/End")
            else htmlib-SideLabel("Office Hours Based SLA - Start/End")
               
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TimeSelect("slabeginhour",lc-slabeginhour,"slabeginmin",lc-slabeginmin)
            ' / ' 
            htmlib-TimeSelect("slaendhour",lc-slaendhour,"slaendmin",lc-slaendmin)
            
            '</TD>' skip.
    else 
    {&out} htmlib-TableField("format time",'left')
           skip.
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("mbanner",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Marketing HTML")
            else htmlib-SideLabel("Marketing HTML"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TextArea("mbanner",lc-mbanner,10,60)
            '</TD>' skip.
    else
    
    DO:
        IF lc-mbanner <> "" THEN
        {&out} htmlib-TableField(html-encode(lc-mbanner) + '<BR><BR><BR>' + lc-mbanner,'left')
           skip.
        ELSE
        {&out} htmlib-TableField("&nbsp;",'left') SKIP.

    END.
    {&out} '</TR>' skip.



    {&out} htmlib-EndTable() skip.
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


    def var lc-code         as char no-undo.
    def var li-int          as int  no-undo.

    if lc-mode = "ADD":U then
    do:
        if lc-companycode = ""
        or lc-companycode = ?
        then run htmlib-AddErrorMessage(
                    'companycode', 
                    'You must enter the company',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        

        if can-find(first b-valid
                    where b-valid.companycode = lc-companycode
                    no-lock)
        then run htmlib-AddErrorMessage(
                    'companycode', 
                    'This company already exists',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    end.

    if lc-name = ""
    or lc-name = ?
    then run htmlib-AddErrorMessage(
                    'name', 
                    'You must enter the company name',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

   
    assign li-int = int(lc-Timeout) no-error.
    if error-status:error
    or li-int < 0 
    then run htmlib-AddErrorMessage(
                    'timeout', 
                    'The timeout period must be 0 or greater',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
    
    assign li-int = int(lc-PasswordExpire) no-error.
    if error-status:error
    or li-int < 0 
    then run htmlib-AddErrorMessage(
                    'passwordexpire', 
                    'The password expiry period must be 0 or greater',
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
        when 'add'
        then assign lc-title = 'Add'
                    lc-link-label = "Cancel addition"
                    lc-submit-label = "Add Company".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Company'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Company'.
    end case.


    assign lc-title = lc-title + ' Company'
           lc-link-url = appurl + '/sys/webcomp.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&time=' + string(time)
                           .

    if can-do("view,update,delete",lc-mode) then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid)
             no-lock no-error.
        if not avail b-table then
        do:
            set-user-field("mode",lc-mode).
            set-user-field("title",lc-title).
            set-user-field("nexturl",appurl + "/sys/webcomp.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.

    end.


    if request_method = "POST" then
    do:

        if lc-mode <> "delete" then
        do:
            assign lc-companycode   = get-value("companycode")
                   lc-name          = get-value("name")
                   lc-address1      = get-value("address1")
                   lc-address2      = get-value("address2")
                   lc-city          = get-value("city")
                   lc-county        = get-value("county")
                   lc-country       = get-value("country")
                   lc-postcode      = get-value("postcode")
                   lc-smtp          = get-value("smtp")
                   lc-helpdeskemail = get-value("helpdeskemail")
                   lc-helpdeskphone = get-value("helpdeskphone")
                   lc-webaddress    = get-value("webaddress")
                   lc-emailfooter   = get-value("emailfooter")
                   lc-slabeginhour  = get-value("slabeginhour")
                   lc-slabeginmin   = get-value("slabeginmin")
                   lc-slaendhour    = get-value("slaendhour")
                   lc-slaendmin     = get-value("slaendmin")
                   lc-monitormessage = get-value("monitormessage")
                   lc-issueinfo = get-value("issueinfo")
                   lc-timeout   = get-value("timeout")
                   lc-passwordexpire = get-value("passwordexpire")
                   lc-email2db       = get-value("email2db")
                   lc-mbanner        = get-value("mbanner")

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
                    create b-table.
                    assign b-table.companycode = caps(lc-companycode)
                           lc-firstrow      = string(rowid(b-table))
                           .
                   
                end.
                if lc-error-msg = "" then
                do:
                    assign 
                        b-table.name            = lc-name
                        b-table.address1 = lc-address1
                       b-table.address2 = lc-address2
                       b-table.city     = lc-city
                       b-table.county   = lc-county
                       b-table.country  = lc-country
                       b-table.postcode = lc-postcode
                        b-table.smtp            = lc-smtp
                        b-table.helpdeskemail   = lc-helpdeskemail
                        b-table.helpdeskphone   = lc-helpdeskphone
                        b-table.webaddress      = lc-webaddress
                        b-table.emailfooter     = lc-emailfooter
                        b-table.slabeginhour    = int(lc-slabeginhour)
                        b-table.slabeginmin     = int(lc-slabeginmin)
                        b-table.slaendhour      = int(lc-slaendhour)
                        b-table.slaendmin       = int(lc-slaendmin)
                        b-table.MonitorMessage  = lc-monitormessage
                        b-table.issueinfo = lc-issueinfo
                        b-table.Timeout   = int(lc-timeout)
                        b-table.PasswordExpire = int(lc-passwordExpire)
                        b-table.Email2DB       = lc-Email2DB
                        b-table.mBanner        = lc-mBanner
                           .
                   
                    
                end.
            end.
        end.
        else
        do:
            find b-table where rowid(b-table) = to-rowid(lc-rowid)
                 exclusive-lock no-wait no-error.
            if locked b-table 
            then  run htmlib-AddErrorMessage(
                                   'none', 
                                   'This record is locked by another user',
                                   input-output lc-error-field,
                                   input-output lc-error-msg ).
            else delete b-table.
        end.

        if lc-error-field = "" then
        do:
            RUN outputHeader.
            set-user-field("navigation",'refresh').
            set-user-field("firstrow",lc-firstrow).
            set-user-field("search",lc-search).
            RUN run-web-object IN web-utilities-hdl ("sys/webcomp.p").
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        assign lc-companycode = b-table.companycode.

        if can-do("view,delete",lc-mode)
        or request_method <> "post"
        then assign 
                lc-name             = b-table.name
                lc-address1  = b-table.address1
                   lc-address2  = b-table.address2
                   lc-city      = b-table.city
                   lc-county    = b-table.county
                   lc-country   = b-table.country
                   lc-postcode  = b-table.postcode
                lc-smtp             = b-table.smtp
                lc-helpdeskemail    = b-table.helpdeskemail
                lc-helpdeskphone    = b-table.helpdeskphone
                lc-webaddress       = b-table.webaddress
                lc-emailfooter      = b-table.emailfooter
                lc-monitormessage   = b-table.monitormessage
                lc-slabeginhour     = string(b-table.slabeginhour)
                lc-slabeginmin      = string(b-table.slabeginmin)
                lc-slaendhour       = string(b-table.slaendhour)
                lc-slaendmin        = string(b-table.slaendmin)
                lc-issueinfo = b-table.issueinfo
                lc-timeout = string(b-table.timeout)
                lc-passwordexpire = string(b-table.passwordExpire)
                lc-email2db       = b-table.email2db
                lc-mbanner        = b-table.mBanner
                    .
       
    end.

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", appurl + '/sys/webcompmnt.p' )
           htmlib-ProgramTitle(lc-title) skip.

    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip
           htmlib-Hidden ("nullfield", lc-navigation) skip.
        
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.

    
    RUN ip-BuildPage.

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
         
    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

