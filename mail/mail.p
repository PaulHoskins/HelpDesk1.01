&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mail/mail.p
    
    Purpose:        Main Received
    
    Notes:
    
    
    When        Who         What
    16/07/2006  phoski      Initial 
    
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


def buffer b-query  for EmailH.
def buffer b-search for EmailH.
def buffer doch     for Doch.


  
def query q for b-query scrolling.


def var lc-info         as char no-undo.
def var lc-object       as char no-undo.
def var li-tag-end      as int no-undo.
def var lc-dummy-return as char initial "MYXXX111PPP2222"   no-undo.
def var lc-Customer     as char no-undo.

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

    {&out}
        '<script>' skip
        'function DeleteEmail(row) ~{' skip
            'if (!confirm("Delete this email?"))' skip 
            'return' skip
            'var FName = "submitsource"' skip
            'document.mainform.elements[FName].value = "DeleteEmail"' skip
            'FName = "deleterow"' skip
            'document.mainform.elements[FName].value = row' skip
            'document.mainform.submit()' skip
           '~}' skip
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
    
    def buffer Customer for Customer.

    def var lc-message  as char     no-undo.
    def var li-Attach   as int      no-undo.

    {lib/checkloggedin.i}

    if get-value("submitsource") = "DeleteEmail" then
    do:
        find emailh where rowid(emailh) = to-rowid(get-value("deleterow")) exclusive-lock no-error.
        if avail emailh then
        do:
            for each doch exclusive-lock
                where doch.CompanyCode = lc-global-company
                  and doch.RelType     = "EMAIL"
                  and doch.RelKey      = string(emailh.EmailID):
                for each docl of doch exclusive-lock:
                    delete docl.
                end.
                delete doch.
            end.
            delete emailh.
        end.
    end.
    RUN outputHeader.
    
    
    {&out} htmlib-Header("HelpDesk Emails") skip.

    RUN ip-ExportJScript.

    {&out} htmlib-JScript-Maintenance() skip.

    {&out} htmlib-StartForm("mainform","post", appurl + '/mail/mail.p' ) skip.

    {&out} htmlib-ProgramTitle("HelpDesk Emails") 
           htmlib-hidden("submitsource","") skip
           htmlib-hidden("deleterow","") skip.
  
    {&out}
            tbar-Begin(
               ""
                )
            tbar-BeginOption()
            tbar-Link("emailissue",?,"off","")
            tbar-Link("emailsave",?,"off","")
            tbar-Link("emaildelete",?,"off","")
 
            tbar-EndOption()
            tbar-End().

    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="97%"') skip
           htmlib-TableHeading(
            "Customer^left|Date^left|Subject|Attachments"
            ) skip.
 
    open query q for each b-query no-lock
        where b-query.CompanyCode = lc-global-company
          and b-query.Email > ""
          .
          

    get first q no-lock.
    
    repeat while avail b-query:
        assign lc-rowid = string(rowid(b-query)).
        assign
            lc-message = b-query.Mtext.

        assign lc-customer = "".

        if b-query.AccountNumber <> "" then
        do:
            find Customer where Customer.CompanyCode = lc-global-company
                            and Customer.AccountNumber = b-query.AccountNumber
                            no-lock no-error.
            if avail Customer
            then assign lc-customer = customer.AccountNumber + " " +
                                      customer.name.
        end.
        {&out}
            skip
            tbar-tr(rowid(b-query))
            skip
            htmlib-MntTableField(html-encode(lc-customer),'left')
            htmlib-MntTableField(string(b-query.RcpDate,'99/99/9999') 
                                ,'left').

        
        if lc-message <> ""
        and lc-message <> b-query.subject then
        do:
        
            assign lc-info = 
                replace(htmlib-MntTableField(html-encode(b-query.subject),'left'),'</td>','')
                lc-object = "hdobj" + string(b-query.emailid).
    
           
            assign li-tag-end = index(lc-info,">").

            {&out} substr(lc-info,1,li-tag-end).

            assign substr(lc-info,1,li-tag-end) = "".
            
            {&out} 
                '<img class="expandboxi" src="/images/general/plus.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">':U skip.
            {&out} lc-info.
    
             def var lc-work as char no-undo.

            
             lc-work = htmlib-ExpandBox(lc-object,lc-message).

             lc-work = replace(lc-work,"Status : Error",
                                "<span style='color: red; font-size: 12px;'>" + 
                                  "STATUS : ERROR</span>").
             {&out} lc-work.

            {&out} '</td>' skip.
        end.
        else {&out} htmlib-MntTableField(html-encode(b-query.subject),"left").
 
        
        assign li-Attach = 0.

        find first doch 
            where doch.CompanyCode = b-query.CompanyCode
              and doch.RelType     = "EMAIL"
              and doch.RelKey      = string(b-query.EmailID)
              no-lock no-error.
        if not avail doch 
        then {&out} htmlib-MntTableField("&nbsp;","left").
        else
        do:
            {&out} skip(4)
                   '<td nowrap>'.

            for each doch 
                    where doch.CompanyCode = b-query.CompanyCode
                      and doch.RelType     = "EMAIL"
                      and doch.RelKey      = string(b-query.EmailID)
                      no-lock:

                assign li-Attach = li-Attach + 1.

                {&out}
                    '<a class="tlink" style="border:none; width: 100%;" href="'
                        'javascript:OpenNewWindow('
                          + '~'' + appurl 
                          + '/sys/docview.p?docid=' + string(doch.docid)
                          + '~'' 
                          + ');'
                      '">'
                        doch.descr 
                    '</a><br>'.
            end.

            {&out} '</td>' skip(4).

        end.
        {&out} skip
                tbar-BeginHidden(rowid(b-query))
                tbar-Link("emailissue",rowid(b-query),
                          appurl + '/' + "iss/addissue.p",
                          "emailid=" + string(b-query.EmailID) + "&issuesource=email"
                          )
                tbar-Link("emailsave",rowid(b-query),
                          if li-Attach > 0 then
                          appurl + '/' + "mail/mailsave.p" else "off",
                          ""
                          )
                tbar-Link("emaildelete",rowid(b-query),
                          'javascript:DeleteEmail('
                          + '~'' + string(rowid(b-query))
                          + '~'' 
                          + ');'
                          ,"")
                .

        
        {&out}
                
            tbar-EndHidden()
            skip
           '</tr>' skip.

       

        get next q no-lock.
            
    end.

    {&out} skip 
           htmlib-EndTable()
           skip.

   
    {&out} htmlib-EndForm().

    
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

