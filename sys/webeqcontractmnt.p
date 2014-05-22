&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webeqcontractmnt.p
    
    Purpose:        Equipment contract Maintenance             
    
    Notes:
    
    
    When        Who         What
    12/04/2006  phoski      Initial

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


def buffer b-valid for ContractType.
def buffer b-table for ContractType.


def var lc-search       as char  no-undo.
def var lc-firstrow     as char  no-undo.
def var lc-lastrow      as char  no-undo.
def var lc-navigation   as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.



def var lc-contractcode     as char no-undo.
def var lc-desc             as char no-undo.
def var lc-billable         as char no-undo.
def var lc-notes            as char no-undo.

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

    def var li-int                  as int no-undo.
    
    if lc-mode = "ADD":U then
    do:
        if lc-contractcode = ""
        or lc-contractcode = ?
        then run htmlib-AddErrorMessage(
                    'contractcode', 
                    'You must enter the code',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        

        if can-find(first b-valid
                    where b-valid.companycode = lc-global-company
                      and b-valid.ContractNumber = lc-contractcode
                    no-lock)
        then run htmlib-AddErrorMessage(
                    'contractcode', 
                    'This code already exists',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    end.

    if lc-desc = ""
    or lc-desc = ?
    then run htmlib-AddErrorMessage(
                    'desc', 
                    'You must enter the contract desc',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

   
    if lc-notes = ""
    or lc-notes = ?
    then run htmlib-AddErrorMessage(
                    'notes', 
                    'The notes field must not be empty',
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
                    lc-submit-label = "Add Contract".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Contract'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Contract'.
    end case.


    assign lc-title = lc-title + ' Inventory Contract'
           lc-link-url = appurl + '/sys/webeqcontract.p' + 
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
            set-user-field("nexturl",appurl + "/sys/webeqcontract.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.

    end.


    if request_method = "POST" then
    do:

        if lc-mode <> "delete" then
        do:
            assign lc-contractcode      = get-value("contractcode")
                   lc-desc              = get-value("desc")
                   lc-billable          = get-value("billable")
                   lc-notes             = get-value("notes")
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
                    assign 
                        b-table.Companycode     = lc-global-company
                        b-table.ContractNumber  = caps(lc-contractcode)
                        lc-firstrow             = string(rowid(b-table))
                           .
                   
                end.
                if lc-error-msg = "" then
                do:
                    assign 
/*                         b-table.ContractNumber  = lc-desc */
                        b-table.Description     = lc-desc
                        b-table.billable        = lc-billable = 'on'
                        b-table.notes           = lc-notes
                        
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
            
 
        end.

        if lc-error-field = "" then
        do:
            RUN outputHeader.
            set-user-field("navigation",'refresh').
            set-user-field("firstrow",lc-firstrow).
            set-user-field("search",lc-search).
            RUN run-web-object IN web-utilities-hdl ("sys/webeqcontract.p").
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        assign lc-contractcode = b-table.ContractNumber.

        if can-do("view,delete",lc-mode)
        or request_method <> "post"
        then assign 
                lc-desc           = b-table.Description
                lc-billable       = if b-table.billable then "on" else ""
                lc-notes          = b-table.notes
                .
       
    end.

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", appurl + '/sys/webeqcontractmnt.p' )
           htmlib-ProgramTitle(lc-title) skip.

    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip
           htmlib-Hidden ("nullfield", lc-navigation) skip.
        
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.

    if lc-mode = "DELETE" then
    do:
        {&out}  '<div contract="infobox">'
                'Warning:<br>'
                'Deletion of this contract will also delete all other related details, e.g customer inventory of this contract'
                '</div>' skip.
    end.

    {&out} htmlib-StartInputTable() skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("contractcode",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Code")
           else htmlib-SideLabel("Code"))
           '</TD>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("contractcode",10,lc-contractcode) skip
           '</TD>'.
    else
    {&out} htmlib-TableField(html-encode(lc-contractcode),'left')
           skip.


    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("desc",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Description")
            else htmlib-SideLabel("Description"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("desc",40,lc-desc) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-desc),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("billable",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Billable")
            else htmlib-SideLabel("Billable"))
            '</TD>'.
    
/*     if not can-do("view,delete",lc-mode) then */
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
/*             htmlib-InputField("billable",3,lc-billable) */
            htmlib-CheckBox("billable", if lc-billable = 'on' then true else false) 
            '</TD>' skip.
/*     else                                                      */
/*     {&out} htmlib-TableField(html-encode(lc-billable),'left') */
/*            skip.                                              */
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           (if lookup("notes",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Notes")
           else htmlib-SideLabel("Notes"))
           '</TD>' skip.

    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TextArea("notes",lc-notes,10,60)
           '</TD>' 
            skip.
    else {&out} '<td valign="top">'
            htmlib-TableField(html-encode(lc-notes),'left')
        '</td>' skip.
    {&out} '</tr>' skip.

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

