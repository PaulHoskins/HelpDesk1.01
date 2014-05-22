&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/addnote.p
    
    Purpose:        Add Note To Issue    
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      CompanyCode      
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.

def buffer b-issue for Issue.
def buffer b-table for IssNote.
def buffer b-status for WebNote.
def buffer b-user   for WebUser.
def var lc-rowid as char no-undo.
def var lc-mode  as char no-undo.


def var lc-type   as char no-undo.
def var lc-note   as char no-undo.


def var lc-list-note    as char no-undo.
def var lc-list-desc    as char no-undo.

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

&IF DEFINED(EXCLUDE-ip-GetNoteTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GetNoteTypes Procedure 
PROCEDURE ip-GetNoteTypes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pc-note   as char no-undo.
    def output param pc-desc            as char no-undo.


    def buffer b-notetype for WebNote.

    assign pc-note = htmlib-Null()
           pc-desc = "Select Note Type".


    for each b-notetype no-lock 
        where b-notetype.companycode = lc-global-company 
        by b-notetype.description:
       
        assign pc-note = pc-note + '|' + 
               b-notetype.NoteCode
               pc-desc = pc-desc + '|' + 
               b-notetype.description.
    end.
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


    if lc-type = htmlib-Null() 
    then run htmlib-AddErrorMessage(
                    'type', 
                    'You select the note type',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-note = ""
    then run htmlib-AddErrorMessage(
                    'note', 
                    'You must enter the note',
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
    
    {lib/checkloggedin.i}


    assign lc-rowid = get-value("rowid")
          lc-mode  = get-value("mode").

    if lc-rowid = "" 
    then assign lc-rowid = get-value("saverowid")
                lc-mode  = get-value("savemode").

    find b-issue where rowid(b-issue) = to-rowid(lc-rowid) no-lock no-error.
    if request_method = "post" then
    do:
        assign lc-note = get-value("note")
              lc-type = get-value("type").
        RUN ip-Validate( output lc-error-field,
                        output lc-error-msg ).

        if lc-error-msg = "" then
        do:
            create b-table.
            assign b-table.IssueNumber = b-issue.IssueNumber
                   b-table.CompanyCode = b-issue.CompanyCode
                   b-table.CreateDate  = today
                   b-table.CreateTime = time
                   b-table.LoginID    = lc-user
                   b-table.NoteCode   = lc-type
                   b-table.Contents   = lc-note.
            RUN outputHeader.
            {&out} '<html><head></head>' skip.

            {&out} '<script language="javascript">' skip
                    'var ParentWindow = opener' skip
                    'ParentWindow.noteCreated()' skip
                    'self.close()' skip
                    '</script>' skip.

            {&out} '</html>'.
            return.


        end.

    end.

    RUN ip-GetNoteTypes ( output lc-list-note,
                         output lc-list-desc ).
   
    
    RUN outputHeader.

    {&out} replace(htmlib-Header("Add Note"),
                  "ClosePage",
                  "ClosePage") skip.

    {&out} htmlib-StartForm("mainform","post", appurl + '/iss/addnote.p' ) skip.

    {&out} htmlib-ProgramTitle("Add Note").

  
    {&out} htmlib-Hidden("savemode",lc-mode)
          htmlib-Hidden("saverowid",lc-rowid).

  
    {&out} htmlib-StartInputTable() skip.



    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("type",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Note Type")
            else htmlib-SideLabel("Note Type"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("type",lc-list-note,lc-list-desc,
                lc-type)
            '</TD></TR>' skip. 


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          (if lookup("note",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("Note")
          else htmlib-SideLabel("Note"))
          '</TD>' skip
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-TextArea("note",lc-note,10,60)
          '</TD>' skip
           skip.


    {&out} htmlib-EndTable() skip.
    
    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.

    {&out} '<center>' htmlib-SubmitButton("submitform","Add Note") 
               '</center>' skip.
    


    {&out} htmlib-Hidden("submitsource","null").


    {&OUT} htmlib-EndForm() skip 
           htmlib-Footer() skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

