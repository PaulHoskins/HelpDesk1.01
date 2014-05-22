&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/kbview.p
    
    Purpose:        KB View
    
    Notes:
    
    
    When        Who         What
    01/08/2006  phoski      Initial   
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


def buffer b-valid      for knbText.
def buffer b-table      for knbText.

def buffer knbSection   for knbSection.
def buffer knbItem      for knbItem.


def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.


def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.
def var lc-Search as char no-undo.

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

&IF DEFINED(EXCLUDE-ip-BuildPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildPage Procedure 
PROCEDURE ip-BuildPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def var lc-text     as char.
    def var li-loop     as int  no-undo.
    def var lc-char     as char no-undo.

    def buffer knbText  for knbText.

    find knbItem where knbItem.knbID = b-table.knbID no-lock no-error.
    find knbSection of knbItem no-lock no-error.

    find knbText where knbText.knbID = b-table.knbID
                   and knbText.dType = "I" no-lock no-error.
    

    if avail knbText then
    do:
        assign lc-text = knbText.dData.

        /*
        ***
        *** Catch Size errors 
        ***
        */
        THISBLOCK:
        do on error undo THISBLOCK , leave THISBLOCK:
        
            assign
                lc-text = if avail knbText then replace(html-encode(knbText.dData),
                                             '~n','<br>')
                         else "".
            
    
            if lc-text <> "" then
            do li-loop = 1 to num-entries(lc-search," "):
                assign
                    lc-char = trim(entry(li-loop,lc-search," ")).
                if lc-char = "" then next.
        
                assign
                    lc-text = replace(lc-text,lc-char,'<span class="hi">' + lc-char + "</span>").
            end.
        end.
        

    end.
    {&out} htmlib-StartInputTable() skip.

     {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Section") '</TD>' skip
           htmlib-TableField(html-encode(knbSection.Description),'left') skip
           '</tr>' skip.    

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Title") '</TD>' skip
           htmlib-TableField(html-encode(knbItem.kTitle),'left') skip
           '</tr>' skip.

     /*
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Text") '</TD>' skip
           htmlib-TableField(replace(html-encode(knbText.dData),
                                     '~n','<br/>'),'left') skip
           '</tr>' skip.
    */
    {&out} '<tr><td class="tablefield" colspan=2">' skip
                    '<div style="margin: 5px;">'
                htmlib-BeginCriteria("Details") '<br>'
                lc-text
        htmlib-EndCriteria()
                    '</div>'
        '</td></tr>'.
                

    
    {&out} htmlib-EndTable() skip.

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
    
    {lib/checkloggedin.i}

    assign lc-rowid = get-value("rowid")
           lc-search = get-value("search")
           .
    if lc-rowid = ""
    then assign lc-rowid = get-value("saverowid").

    assign lc-title = 'View'.

    find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock no-error.

    assign lc-title = lc-title + ' KB Item ' + string(b-table.knbID).
    

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           '<style>' skip
           '.hi ~{ font-weight: 900;color: red; ~}' skip
           '</style>' skip
           htmlib-StartForm("mainform","post", appurl + '/sys/kbview.p' )
           htmlib-ProgramTitle(lc-title).
    {&out} htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("search",lc-search) skip.

    {&out} '<a href="javascript:window.print()"><img src="/images/general/print.gif" border=0 style="padding: 5px;"></a>' skip.

    
    RUN ip-BuildPage.

    

    {&OUT} htmlib-EndForm() skip 
           htmlib-Footer() skip.
    
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

