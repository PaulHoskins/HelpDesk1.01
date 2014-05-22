&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/ivdue.p
    
    Purpose:        Inventory Due - Web Page
    
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
    
    run prince/ivdue.p 
        ( lc-global-user,
          lc-global-company,
          date(lc-lodate),
          date(lc-hidate),
          output lc-pdf ).

   
       

      
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


    
        
    def var ld-lodate   as date     no-undo.
    def var ld-hidate   as date     no-undo.
    def var li-loop     as int      no-undo.
    def var lc-rowid    as char     no-undo.

    
    assign
        ld-lodate = date(lc-lodate) no-error.
    if error-status:error 
    or ld-lodate = ?
    then run htmlib-AddErrorMessage(
                'lodate', 
                'The from date is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    assign
        ld-hidate = date(lc-hidate) no-error.
    if error-status:error 
    or ld-hidate = ?
    then run htmlib-AddErrorMessage(
                'hidate', 
                'The to date is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    if ld-lodate > ld-hidate 
    then run htmlib-AddErrorMessage(
                'lodate', 
                'The date range is invalid',
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

    if request_method = "POST" then
    do:
        
        assign
            lc-lodate = get-value("lodate")
            lc-hidate = get-value("hidate")
            
            .
        
        RUN ip-Validate( output lc-error-field,
                         output lc-error-msg ).

        if lc-error-msg = "" then
        do:
            RUN ip-ProcessReport.
            
        end.
    end.

  
    if request_method <> "post"
    then assign lc-lodate = string(dynamic-function("com-MonthBegin",today),"99/99/9999")
                lc-hidate = string(dynamic-function("com-MonthEnd",today),"99/99/9999")
                .

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle("Customer Inventory Renewals") skip.


    
    {&out} htmlib-StartInputTable() skip.

   
    {&out} '<TR>' skip
            '<TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("lodate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("From Date")
            else htmlib-SideLabel("From Date"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("lodate",10,lc-lodate) 
            htmlib-CalendarLink("lodate")
            '</td>' skip
            '<td>&nbsp;</td>'
            '<TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("hidate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("To Date")
            else htmlib-SideLabel("To Date"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("hidate",10,lc-hidate) 
            htmlib-CalendarLink("hidate")
            '</td>' skip
            
            
            '</tr>' skip.

    {&out} htmlib-EndTable() skip.

    
    if request_method = "post" and lc-error-msg = "" then
    do:
        
    end.

    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.
    
    {&out} '<center>' htmlib-SubmitButton("submitform","Report") 
               '</center>' skip.
    
    {&out} htmlib-EndForm() skip
          htmlib-CalendarScript("lodate") skip
          htmlib-CalendarScript("hidate") skip.


    if lc-pdf <> "" then
    do:
        {&out} '<script>' skip
            "OpenNewWindow('"
                    appurl "/rep/viewpdf3.p?PDF=" 
                    url-encode(lc-pdf,"query") "')" skip
            '</script>' skip.
    end.
   
    {&out} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

