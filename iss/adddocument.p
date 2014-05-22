&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/adddocument.p
    
    Purpose:        Issue Document Upload 
    
    Notes:
    
    
    When        Who         What
    09/04/2006  phoski      Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-type as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.

def var lc-relkey   as char no-undo.

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


    assign lc-type = "issue"
           lc-rowid = get-value("rowid").

    if lc-rowid = ""
    then assign lc-rowid = get-value("ownerrowid").

    assign lc-title = "Upload Document For".

      case lc-type:
        when "customer" then
        do:
            find customer where rowid(customer) = to-rowid(lc-rowid) no-lock
                 no-error.
            if avail customer
            then assign lc-title = lc-title + " Customer " + caps(customer.accountnumber) + 
                    " " + html-encode(customer.name).
                 assign lc-relkey = customer.accountnumber.

        end.
        when "issue" then
        do:
            find issue where rowid(issue) = to-rowid(lc-rowid) no-lock no-error.
            if avail issue
            then assign lc-title = lc-title + " Issue " + string(issue.issuenumber).
            assign lc-relkey = string(issue.issuenumber).


        end.
    end case.


    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           .

    {&out} '<script language="JavaScript" src="/scripts/js/docupval.js"></script>' skip.   

    {&out}
        replace(htmlib-StartForm("mainform","post", "/perl/uploaddoc.pl"),
                "<form",
                '<form ENCTYPE="multipart/form-data" ')
       htmlib-ProgramTitle(lc-title) skip.

    if get-value("problem") <> "" 
    then {&out} '<div class="infobox">'
                    get-value("problem")
                '</div>' skip.

    {&out} '<table align=center>'
           '<tr><td align="right">'  htmlib-SideLabel('Document') '</td><td><input size="60" class="inputfield" type="file" name="filename"></td></tr>'

           '<tr><td align="right">'  htmlib-SideLabel('Description') '</td><td>' htmlib-InputField("comment",60,"") '</td></tr>'
            '<tr><td align="right">'  htmlib-SideLabel('Customer View?') '</td><td>' 
                    htmlib-CheckBox('custview', if request_method = "get" then true else get-value("custview") = "on") '</td></tr>'

           '</table>'
        
        '<br><br><center><input class="actionbutton" type="button" value="Load Document" onclick="DoSubmit()"></center>'
        .
    {&out} htmlib-Hidden("type",lc-type)
           htmlib-Hidden("rowid",lc-rowid).

         
    {&out} htmlib-Hidden("OKPage", appurl + '/iss/adddocumentok.p?type=' + lc-type
                                + "&rowid=" + lc-rowid).

    {&out} htmlib-Hidden("NotOKPage", appurl + '/sys/docupfail.p?type=' + lc-type
                                + "&rowid=" + lc-rowid).

    /*'<input type="hidden" name="OKPage" value="' AppURL '/idoc-upok.r?rowid=' lc-rowid '">' */
    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

