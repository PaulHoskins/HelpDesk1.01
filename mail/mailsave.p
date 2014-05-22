&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mail/mailsave.p
    
    Purpose:        Main Received - Save to Customer
    
    Notes:
    
    
    When        Who         What
    16/07/2006  phoski      Initial 
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.

def var lc-rowid as char no-undo.
def var lc-link-print as char no-undo.

def var li-max-lines as int initial 12 no-undo.


def buffer b-query  for doch.
def buffer b-search for doch.
def buffer doch     for Doch.


  
def query q for b-query scrolling.

def var lc-tog-name     as char no-undo.
def var lc-desc-name    as char no-undo.

def var lc-list-number      as char no-undo.
def var lc-list-name        as char no-undo.
def var lc-accountnumber    as char no-undo.

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

    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GetAccountNumbers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GetAccountNumbers Procedure 
PROCEDURE ip-GetAccountNumbers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pc-AccountNumber as char no-undo.
    def output param pc-Name          as char no-undo.

    def buffer b-user for WebUser.
    def buffer b-cust for Customer.


    assign pc-AccountNumber = htmlib-Null()
           pc-Name          = "Select Account".


    for each b-cust no-lock
             where b-cust.CompanyCode = lc-global-company
             by b-cust.name:

        assign pc-AccountNumber = pc-AccountNumber + '|' + b-cust.AccountNumber
               pc-Name          = pc-Name + '|' + b-cust.name.

    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Save) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Save Procedure 
PROCEDURE ip-Save :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    
    find emailh where rowid(emailh) = to-rowid(lc-rowid) exclusive-lock.

    for each doch exclusive-lock
        where doch.CompanyCode = lc-global-company
          and doch.RelType     = "EMAIL"
          and doch.RelKey      = string(emailh.EmailID):

        assign lc-tog-name = "tog" + string(rowid(doch))
               lc-desc-name = "desc" + string(rowid(doch)).

        if get-value(lc-tog-name) <> "on" then 
        do:
            for each docl of doch exclusive-lock:
                delete docl.
            end.
            delete doch.
            next.
        end.
            

        assign
            doch.RelType = "CUSTOMER"
            doch.RelKey  = lc-accountnumber.
        assign
            doch.Descr   = get-value(lc-desc-name).
        assign
            doch.CreateBy = lc-global-user.
        
    end.

    delete emailh.

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

    def var li-count        as int      no-undo.

    if not can-find(customer where customer.accountnumber 
                        = lc-accountnumber 
                        and customer.companycode = lc-global-company
                        no-lock) 
    then run htmlib-AddErrorMessage(
                    'accountnumber', 
                    'You must select the account',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    for each doch no-lock
        where doch.CompanyCode = lc-global-company
          and doch.RelType     = "EMAIL"
          and doch.RelKey      = string(emailh.EmailID):

        assign lc-tog-name = "tog" + string(rowid(doch))
               lc-desc-name = "desc" + string(rowid(doch)).

        if get-value(lc-tog-name) <> "on" then next.

        if get-value(lc-desc-name) = "" then
        do:
            run htmlib-AddErrorMessage(
                    lc-desc-name, 
                    'You must enter the description',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

        end.
        assign
            li-count = li-count + 1.
    end.

    if li-count = 0 
    then run htmlib-AddErrorMessage(
                    'accountnumber', 
                    'You must select one or more attachments to save',
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
    
    def buffer Customer for Customer.

    def var lc-message  as char     no-undo.
    def var li-Attach   as int      no-undo.

    {lib/checkloggedin.i}

    assign
        lc-rowid = get-value("rowid").

    find emailh where rowid(emailh) = to-rowid(lc-rowid) no-lock no-error.

    RUN ip-GetAccountNumbers ( output lc-list-number,
                               output lc-list-name ).


    if emailh.AccountNumber <> "" then
    do:
        find customer
            where customer.CompanyCode      = lc-global-company
              and customer.AccountNumber    = emailh.AccountNumber
              no-lock no-error.
        if avail customer then
        do:
            assign
                lc-list-number = customer.AccountNumber
                lc-list-name   = customer.name
                lc-accountnumber = customer.AccountNumber.
        end.
    end.
    
    if request_method = 'post' then
    do:
        assign lc-accountnumber = get-value("accountnumber")
               .
        RUN ip-Validate( output lc-error-field,
                             output lc-error-msg ).
        if lc-error-field = "" then
        do:
            RUN ip-Save.
            assign request_method = "GET".
            RUN run-web-object IN web-utilities-hdl ("mail/mail.p").
            return.
        end.
              
    
    end.

    RUN outputHeader.
    
    
    {&out} htmlib-Header("HelpDesk Emails - Save To Customer Documents") skip.

    RUN ip-ExportJScript.

    {&out} htmlib-JScript-Maintenance() skip.

    {&out} htmlib-StartForm("mainform","post", appurl + '/mail/mailsave.p' ) skip.

    {&out} htmlib-ProgramTitle("HelpDesk Emails - Save To Customer Documents") 
           htmlib-hidden("submitsource","") skip
           .
  
    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="97%"') skip
           htmlib-TableHeading(
            "Customer^left|From^left|Subject^left|Date^left"
            ) skip.

    {&out}
        '<tr>'
        htmlib-MntTableField(
            htmlib-Select("accountnumber",lc-list-number,lc-list-name,
                lc-accountnumber)
            ,'left')
        htmlib-MntTableField(html-encode(emailh.Email),'left')
        htmlib-MntTableField(html-encode(emailh.Subject),'left')
        htmlib-MntTableField(string(emailh.RcpDate,'99/99/9999') + ' - ' + string(emailh.RcpTime,"hh:mm am"),'left')
        .

    {&out} skip 
           htmlib-EndTable()
           skip.


    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="97%"') skip
           htmlib-TableHeading(
            "Save?^left|Attachment^left|Description^left"
            ) skip.
 
    open query q for each b-query no-lock
        where b-query.CompanyCode = lc-global-company
          and b-query.RelType     = "EMAIL"
          and b-query.RelKey      = string(emailh.EmailID)
          
          .
          

    get first q no-lock.
    
    repeat while avail b-query:
        
        assign lc-tog-name = "tog" + string(rowid(b-query))
               lc-desc-name = "desc" + string(rowid(b-query)).

        if request_method = "GET"
        then set-user-field(lc-desc-name,
                            b-query.descr).

        {&out}
            skip
            tbar-tr(rowid(b-query))
            skip
            htmlib-MntTableField(
                htmlib-CheckBox(lc-tog-name,
                    if request_method = "GET"
                    or get-value(lc-tog-name) = "on" then true
                    else false)
                ,'left')
            htmlib-MntTableField(html-encode(b-query.descr),'left')
            htmlib-MntTableField(
                htmlib-InputField
                    (lc-desc-name,60,get-value(lc-desc-name))
                ,'left').

        {&out}
           
           '</tr>' skip.

        get next q no-lock.
            
    end.

    {&out} skip 
           htmlib-EndTable()
           skip.

    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.

    {&out} '<center>' htmlib-SubmitButton("submitform","Copy") 
               '</center>' skip.

    {&out}
        htmlib-Hidden("rowid",lc-rowid).
   
    {&out} htmlib-EndForm().

    
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

