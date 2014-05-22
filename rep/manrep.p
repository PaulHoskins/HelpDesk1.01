&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/manrep.p
    
    Purpose:        Management Report - Web Page
    
    Notes:
    
    
    When        Who         What
    10/07/2006  phoski      Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.
def var lc-title as char no-undo.


def var lc-date         as char no-undo.
def var lc-days         as char no-undo.
def var lc-pdf as char          no-undo.
{rep/manreptt.i}
{lib/maillib.i}

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

    

    run rep/manrepbuild.p 
        ( lc-global-company,
          date(lc-date),
          int(lc-days),
          output table tt-mrep ).

    run prince/manrep.p 
        ( lc-global-user,
          lc-global-company,
          date(lc-date),
          int(lc-days),
          input table tt-mrep,
          output lc-pdf ).
    
    /* lc-pdf = search(lc-pdf). */

    /*if lc-pdf <> "" 
    then mlib-SendAttEmail 
        ( lc-global-company,
          "",
          "HelpDesk Management Report",
          "Please find the attached the above report covering the period from "
          + string(date(lc-date) - int(lc-days),'99/99/9999') + ' to ' +
          string(date(lc-date),'99/99/9999'),
          webuser.email,
          "",
          "",
          lc-pdf ).
    */        
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


    def var li-int      as int      no-undo.
    def var ld-date     as date     no-undo.


    assign
        ld-date = date(lc-date) no-error.
    if error-status:error 
    then run htmlib-AddErrorMessage(
                'date', 
                'The date is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    

    assign li-int = int(lc-days) no-error.
    if error-status:error 
    or li-int < 1 then run htmlib-AddErrorMessage(
                'days', 
                'The number of days must be over zero',
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
            lc-date = get-value("date")
            lc-days = get-value("days").
        
        RUN ip-Validate( output lc-error-field,
                         output lc-error-msg ).

        if lc-error-msg = "" then
        do:
            RUN ip-ProcessReport.
            
        end.
    end.

  
    if request_method <> "post"
    then assign lc-date = string(today,"99/99/9999")
                lc-days = "7".
                .

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle("Management Report") skip.


    
    {&out} htmlib-StartInputTable() skip.

   
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("date",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Report Date")
            else htmlib-SideLabel("Report Date"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("date",10,lc-date) 
            htmlib-CalendarLink("date")
            '</td></tr>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("recordperpage",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Period (Days)")
            else htmlib-SideLabel("Period (Days)"))
            '</TD><td>'
            htmlib-InputField("days",3,lc-days) 
            '</TD></TR>' skip.


    {&out} htmlib-EndTable() skip.


    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.
    
    {&out} '<center>' htmlib-SubmitButton("submitform","Report") 
               '</center>' skip.
    
         
    {&out} htmlib-Hidden("pdf",lc-pdf).

    {&out} htmlib-EndForm() skip
          htmlib-CalendarScript("date") skip.


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

