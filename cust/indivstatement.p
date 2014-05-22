&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/custstat.p
    
    Purpose:        Customer Statements - Web Page
    
    Notes:
    
    
    When        Who         What
    26/07/2006  phoski      Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.
def var lc-title as char no-undo.


def var lc-lodate       as char no-undo.
def var lc-hidate       as char no-undo.
def var lc-pdf          as char no-undo.
def var lc-view         as char no-undo.
{lib/maillib.i}

def var lc-AccountNumber    as char no-undo.



def var lc-link-label   as char no-undo.
def var lc-link-url     as char no-undo.

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

&IF DEFINED(EXCLUDE-ip-HeaderInclude-Calendar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-HeaderInclude-Calendar Procedure 
PROCEDURE ip-HeaderInclude-Calendar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ProcessReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ProcessReport Procedure 
PROCEDURE ip-ProcessReport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


        run prince/custstat.p 
        ( lc-global-user,
          lc-global-company,
          lc-AccountNumber,
          date(lc-lodate),
          date(lc-hidate),
          output lc-pdf ).
    
        lc-pdf = search(lc-pdf).

        if lc-view = "on" then return.

        if lc-pdf <> "" 
        then mlib-SendAttEmail 
        ( lc-global-company,
          "",
          "HelpDesk Statement for " + customer.name,
          "Please find attached your statement covering the period "
          + string(date(lc-lodate),"99/99/9999") + " to " +
          string(date(lc-hidate),'99/99/9999'),
          webuser.email,
          "",
          "",
          lc-pdf ).
                


      
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


        
    def var ld-date     as date     no-undo.
    def var li-loop     as int      no-undo.
    def var lc-rowid    as char     no-undo.

    assign
        ld-date = date(lc-lodate) no-error.
    if error-status:error 
    or ld-date = ?
    then run htmlib-AddErrorMessage(
                'lodate', 
                'The date is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    assign
        ld-date = date(lc-hidate) no-error.
    if error-status:error 
    or ld-date = ?
    then run htmlib-AddErrorMessage(
                'hidate', 
                'The date is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    if pc-error-field <> "" then return.

    if date(lc-lodate) > date(lc-hidate) then
    do:
        run htmlib-AddErrorMessage(
                'hidate', 
                'The date range is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
        return.
    end.
   

   

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

    assign
        lc-AccountNumber = get-value("accountnumber").

    find customer
        where customer.companyCode = lc-global-company
          and customer.AccountNumber = lc-AccountNumber no-lock no-error.
    
    if request_method = "POST" then
    do:
        
        assign
            lc-hidate = get-value("hidate")
            lc-lodate = get-value("lodate")
            lc-view   = get-value("view")
            .
        
        RUN ip-Validate( output lc-error-field,
                         output lc-error-msg ).

        if lc-error-msg = "" then
        do:
            RUN ip-ProcessReport.

            
            
            if lc-view <> "on"
            then set-user-field("statementsent","yes").
            else set-user-field("showpdf",lc-pdf).
                
            assign
                request_method = "GET".
            if Webuser.UserClass = "CUSTOMER" then
            do:
                RUN run-web-object IN web-utilities-hdl ("iss/issue.p").
                return.
            end.
            set-user-field("source","menu").
            set-user-field("rowid",string(rowid(customer))).
            
            RUN run-web-object IN web-utilities-hdl ("cust/custview.p").
            return.

            
        end.
    end.

      assign
        lc-link-label = "Cancel"
        lc-link-url = appurl + '/cust/custview.p' + 
                                  '?source=menu&rowid=' + string(rowid(customer))
                                   +
                                  '&time=' + string(time)
                           .
    if Webuser.UserClass = "CUSTOMER" then
    assign lc-link-url = appurl + '/iss/issue.p'.
    if request_method <> "post"
    then assign lc-hidate = string(today,"99/99/9999")
                lc-lodate = string(today - day(today) + 1,"99/99/9999")
               
                .

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle(
               
               if webuser.UserClass = "CUSTOMER"
               then "Produce Statement" else "Customer Statement - " + customer.Name) skip.


    
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.

    {&out} htmlib-StartInputTable() skip.

   
    {&out} '<TR>'
            '<TD VALIGN="TOP" ALIGN="right">' 

            
            (if lookup("lodate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Statement From")
            else htmlib-SideLabel("Statement From"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("lodate",10,lc-lodate) 
            htmlib-CalendarLink("lodate")
            '</td>' skip
        
            '<TD VALIGN="TOP" ALIGN="right">' 

            
            (if lookup("hidate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("To")
            else htmlib-SideLabel("To"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("hidate",10,lc-hidate) 
            htmlib-CalendarLink("hidate")
            '</td>' skip
            '<TD VALIGN="TOP" ALIGN="right">' 
               '&nbsp;'
            htmlib-SideLabel("View Statement?")
            '<br><span style="font-size: 10px;">Statement will be emailed<br>to you if not ticked</span>'
            '</td>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("view", if lc-view = 'on'
                                        then true else false) 
               
            '</TD>'
            
            '</tr>' skip.

    {&out} htmlib-EndTable() skip.

   
    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.
    
    {&out} '<center><br>' htmlib-SubmitButton("submitform","Create Statement") 
               '</center>' skip.
    
         
    {&out} htmlib-Hidden("accountnumber",lc-accountnumber) skip.

    {&out} htmlib-EndForm() skip
          htmlib-CalendarScript("hidate")
          htmlib-CalendarScript("lodate") skip.


   
    {&out} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

