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


def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.


def buffer b-valid for webuser.
def buffer b-table for webuser.


def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.



def var lc-loginid      as char no-undo.
def var lc-forename     as char no-undo.
def var lc-surname      as char no-undo.
def var lc-email        as char no-undo.
def var lc-usertitle    as char no-undo.
def var lc-pagename     as char no-undo.
def var lc-disabled     as char no-undo.
def var lc-accountnumber as char no-undo.
def var lc-jobtitle     as char no-undo.
def var lc-telephone    as char no-undo.
def var lc-password     as char no-undo.
def var lc-userClass    as char no-undo.
def var lc-customertrack as char no-undo.
def var lc-recordsperpage as char no-undo.
def var lc-usertitleCode  as char
    initial ''    no-undo.
def var lc-usertitleDesc  as char
    initial '' no-undo.

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

    

    assign li-int = int(lc-recordsperpage) no-error.
    if error-status:error 
    or li-int < 5 then run htmlib-AddErrorMessage(
                'recordsperpage', 
                'The number of records to display must be 5 or greater',
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

    assign lc-mode = "UPDATE"
           lc-rowid = string(rowid(webuser))
           .

    find b-table where rowid(b-table) = to-rowid(lc-rowid)
         no-lock no-error.
    if not avail b-table then
    do:
        set-user-field("mode",lc-mode).
        set-user-field("title",lc-title).
        RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
        return.
    end.


    if request_method = "POST" then
    do:
        
        assign lc-customertrack = get-value("customertrack")
               lc-recordsperpage = get-value("recordsperpage")
               .
        RUN ip-Validate( output lc-error-field,
                         output lc-error-msg ).

        if lc-error-msg = "" then
        do:
            find b-table where rowid(b-table) = to-rowid(lc-rowid)
                exclusive-lock no-wait no-error.
            if locked b-table 
            then  run htmlib-AddErrorMessage(
                           'none', 
                           'This record is locked by another user',
                           input-output lc-error-field,
                           input-output lc-error-msg ).
            else
            do:
                assign 
                       b-table.customertrack    = lc-customertrack = 'on'
                       b-table.recordsperpage   = int(lc-recordsperpage)
                       .
                
                set-user-field("prefsaved","yes").

            end.
        end.
    end.

  
    find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
    
    if request_method <> "post"
    then assign 
                lc-customertrack = if b-table.customertrack then 'on' else ''
                lc-recordsperpage = string(b-table.recordsperpage)
                    .

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle("Your Preferences") skip.


    
    {&out} htmlib-StartInputTable() skip.

    if get-value("prefsaved") = "yes" then
    do:
        {&out} '<tr><th colspan="2" style="text-align: center;">Your preferences have been saved.<br><br></th></tr>'.
    end.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("customertrack",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Track Your Issues?")
            else htmlib-SideLabel("Track Your Issues?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("customertrack", if lc-customertrack = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-customertrack = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("recordperpage",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Records Per Page")
            else htmlib-SideLabel("Records Per Page"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("recordsperpage",2,lc-recordsperpage) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-recordsperpage),'left')
           skip.
    {&out} '</TR>' skip.


    {&out} htmlib-EndTable() skip.


    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.
    
    {&out} '<center>' htmlib-SubmitButton("submitform","Update") 
               '</center>' skip.
    
         
    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

