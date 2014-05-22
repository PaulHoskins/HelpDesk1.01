&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webstatusmnt.p
    
    Purpose:        Status Maintenance           
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      CompanyCode  
    11/04/2006  phoski      DefaultCode & CustomerTrack & DisplayOrder   
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


def buffer b-valid for webstatus.
def buffer b-table for webstatus.


def var lc-search       as char  no-undo.
def var lc-firstrow     as char  no-undo.
def var lc-lastrow      as char  no-undo.
def var lc-navigation   as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.



def var lc-defaultcode      as char no-undo.
def var lc-customertrack    as char no-undo.
def var lc-displayorder     as char no-undo.
def var lc-statuscode       as char no-undo.
def var lc-description      as char no-undo.
def var lc-notecode         as char no-undo.
def var lc-completedstatus  as char no-undo.
def var lc-ignoreemail      as char no-undo.

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

    def var li-int  as int no-undo.
    
    if lc-mode = "ADD":U then
    do:
        if lc-statuscode = ""
        or lc-statuscode = ?
        then run htmlib-AddErrorMessage(
                    'statuscode', 
                    'You must enter the status code',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        

        if can-find(first b-valid
                    where b-valid.statuscode = lc-statuscode
                      and b-valid.CompanyCode = lc-global-company
                    no-lock)
        then run htmlib-AddErrorMessage(
                    'statuscode', 
                    'This status code already exists',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    end.

    if lc-description = ""
    or lc-description = ?
    then run htmlib-AddErrorMessage(
                    'description', 
                    'You must enter the description',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-notecode <> "" then
    do:
        if can-find(WebNote where WebNote.NoteCode = lc-notecode no-lock)
        = false then
        do:
            run htmlib-AddErrorMessage(
                    'notecode', 
                    'The note does not exist',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        end.
    end.

    assign li-int = int(lc-displayorder) no-error.

    if error-status:error 
    then run htmlib-AddErrorMessage(
                    'displayorder', 
                    'The display order must be an integer',
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
                    lc-submit-label = "Add Status".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Status'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Status'.
    end case.


    assign lc-title = lc-title + ' Status'
           lc-link-url = appurl + '/sys/webstatus.p' + 
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
            set-user-field("nexturl",appurl + "/sys/webstatus.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.

    end.


    if request_method = "POST" then
    do:

        if lc-mode <> "delete" then
        do:
            assign lc-statuscode        = get-value("statuscode")
                   lc-description       = get-value("description")
                   lc-completedstatus   = get-value("completedstatus")
                   lc-notecode          = get-value("notecode")
                   lc-defaultcode       = get-value("defaultcode")
                   lc-customertrack     = get-value("customertrack")
                   lc-displayorder      = get-value("displayorder")
                   lc-ignoreemail       = get-value("ignoreemail")
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
                    assign b-table.statuscode = caps(lc-statuscode)
                           b-table.CompanyCode = lc-global-company
                           lc-firstrow      = string(rowid(b-table))
                           .
                   
                end.
                if lc-error-msg = "" then
                do:
                    if lc-defaultcode = "on"
                    then run com-ResetDefaultStatus ( lc-global-company ).

                    assign b-table.description     = lc-description
                           b-table.completedstatus = lc-completedstatus = 'on'
                           b-table.defaultcode     = lc-defaultcode = 'on'
                           b-table.CustomerTrack   = lc-customertrack = 'on'
                           b-table.IgnoreEmail     = lc-IgnoreEmail = 'on'
                           b-table.DisplayOrder    = int(lc-displayOrder)
                           b-table.notecode        = caps(lc-notecode)
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
            RUN run-web-object IN web-utilities-hdl ("sys/webstatus.p").
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        assign lc-statuscode = b-table.statuscode.

        if can-do("view,delete",lc-mode)
        or request_method <> "post"
        then assign lc-description       = b-table.description
                    lc-completedstatus   = if b-table.completedstatus then 'on' else ''
                    lc-notecode          = b-table.notecode
                    lc-displayorder      = string(b-table.displayorder)
                    lc-defaultcode       = if b-table.defaultcode then 'on' else ''
                    lc-customertrack     = if b-table.customertrack then 'on' else ''
                    lc-IgnoreEmail       = if b-table.IgnoreEmail then 'on' else ''

                    .
       
    end.

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", appurl + '/sys/webstatusmnt.p' )
           htmlib-ProgramTitle(lc-title) skip.

    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip
           htmlib-Hidden ("nullfield", lc-navigation) skip.
        
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.

    {&out} htmlib-StartInputTable() skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("statuscode",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Status Code")
           else htmlib-SideLabel("Status Code"))
           '</TD>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("statuscode",20,lc-statuscode) skip
           '</TD>'.
    else
    {&out} htmlib-TableField(html-encode(lc-statuscode),'left')
           skip.


    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("description",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Description")
            else htmlib-SideLabel("Description"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("description",40,lc-description) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-description),'left')
           skip.
    {&out} '</TR>' skip.
    

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("completedstatus",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Completed?")
            else htmlib-SideLabel("Completed?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("completedstatus", if lc-completedstatus = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-completedstatus = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("defaultcode",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Default Status?")
            else htmlib-SideLabel("Default Status?"))
            '</TD>'.
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("defaultcode", if lc-defaultcode = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-defaultcode = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("customertrack",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Customer Track?")
            else htmlib-SideLabel("Customer Track?"))
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
            (if lookup("ignoreemail",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Ignore Epulse Issues?")
            else htmlib-SideLabel("Ignore Epulse Issues?"))
            '</TD>'.
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("ignoreemail", if lc-ignoreemail = 'on'
                                        then true else false) 
            '<div class="infobox" style="font-size: 10px">If ticked then no alerts will be sent to the customer.</div>'
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-ignoreemail = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("displayorder",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Display Order")
            else htmlib-SideLabel("Display Order"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("displayorder",4,lc-displayorder) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-displayorder),'left')
           skip.
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("notecode",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Default Note")
            else htmlib-SideLabel("Default Note"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("notecode",20,lc-notecode) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-notecode),'left')
           skip.
    if can-do("add,update",lc-mode) then
    do:
        {&out} skip
               '<td>'
               htmlib-Lookup("Lookup Note",
                             "notecode",
                             "nullfield",
                             appurl + '/lookup/note.p')
               '</TD>'
               skip.
    end.
    {&out} '</TR>' skip.
    

    {&out} htmlib-EndTable() skip.


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

