&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webinvfieldmnt.p
    
    Purpose:        Equipment Subclass Maintenance - Field Def             
    
    Notes:
    
    
    When        Who         What
    12/04/2006  phoski      Initial
    30/07/2006  phoski      Warning field on numbers

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


def buffer ivClass  for ivClass.
def buffer ivSub    for ivSub.
def buffer b-valid  for ivField.
def buffer b-table  for ivField.


def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.




def var lc-ClassCode    as char  no-undo.
def var lc-subcode      as char  no-undo.
def var lc-firstback    as char  no-undo.
def var lf-Audit        as dec   no-undo.

def var lc-dlabel       as char  no-undo.
def var lc-dorder       as char  no-undo.
def var lc-dtype        as char  no-undo.
def var lc-dMandatory   as char  no-undo.
def var lc-dprompt      as char  no-undo.
def var lc-dWarning     as char  no-undo.

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


    def var li-int      as int      no-undo.
    
    if lc-dorder = ""
    or lc-dorder = ?
    then 
    do:
        run htmlib-AddErrorMessage(
                'dorder', 
                'You must enter the display order',
                input-output pc-error-field,
                input-output pc-error-msg ).
        return.
    end.

    assign li-int = int(lc-dorder) no-error.
    if error-status:error or li-int <= 0 then
    do:
        run htmlib-AddErrorMessage(
                'dorder', 
                'You must enter a numeric display order',
                input-output pc-error-field,
                input-output pc-error-msg ).
        return.
        
    end.
        
    if lc-dlabel = ""
    or lc-dlabel = ?
    then run htmlib-AddErrorMessage(
                    'dlabel', 
                    'You must enter the label',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-dtype = "date" then
    do:
        assign li-int = int(lc-dwarning) no-error.
        if error-status:error or li-int < 0 then
        do:
            run htmlib-AddErrorMessage(
                'dwarning', 
                'You must enter a numeric warning period',
                input-output pc-error-field,
                input-output pc-error-msg ).
        return.

        end.
    end.
    else 
    if lc-dwarning <> "" then
    do:
        run htmlib-AddErrorMessage(
                'dwarning', 
                'The warning period is only applicable to dates',
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


     assign
        lc-classcode = get-value("classcode")
        lc-subcode   = get-value("subcode").

    find ivClass where rowid(ivClass) = to-rowid(lc-classcode) no-lock no-error.
    find ivSub   where rowid(ivSub)   = to-rowid(lc-subcode)   no-lock no-error.

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
                           "&lastrow=" + lc-lastrow + 
                           "&classcode=" + lc-classcode + 
                           "&subcode=" + lc-subcode.
    assign
        lc-firstback = get-value("firstback").

    case lc-mode:
        when 'add'
        then assign lc-title = 'Add'
                    lc-link-label = "Cancel addition"
                    lc-submit-label = "Add Custom Field".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Custom Field'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Custom Field'.
    end case.


    assign lc-title = lc-title + ' Custom Field - '
                + html-encode(ivClass.name) + " - " + 
                html-encode(ivSub.name)
           lc-link-url = appurl + '/sys/webinvfield.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&time=' + string(time) + 
                                  '&classcode=' + lc-classcode +
                                  '&subcode=' + lc-subcode +
                                  '&firstback=' + lc-firstback 
                           .

    if can-do("view,update,delete",lc-mode) then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid)
             no-lock no-error.
        if not avail b-table then
        do:
            set-user-field("mode",lc-mode).
            set-user-field("title",lc-title).
            set-user-field("nexturl",appurl + "/sys/webinvfield.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.

    end.


    if request_method = "POST" then
    do:

        if lc-mode <> "delete" then
        do:
            assign
                lc-dlabel = get-value("dlabel")
                lc-dorder = get-value("dorder")
                lc-dtype  = get-value("dtype")
                lc-dMandatory = get-value("dmandatory")
                lc-dprompt = get-value("dprompt")
                lc-dWarning = get-value("dwarning").
            
               
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
                        b-table.ivSubId     = ivSub.ivSubId
                        lc-firstrow         = string(rowid(b-table))
                           .
                    do while true:
                        run lib/makeaudit.p (
                            "",
                            output lf-audit
                            ).
                        if can-find(first ivField
                                    where ivField.ivFieldID = lf-audit no-lock)
                                    then next.
                        assign
                            b-table.ivFieldID = lf-audit.
                        leave.
                    end.
                   
                end.
                if lc-error-msg = "" then
                do:
                    assign 
                        b-table.dOrder = int(lc-dorder)
                        b-table.dLabel = lc-dlabel
                        b-table.dType  = lc-dType
                        b-table.dPrompt = lc-dprompt
                        b-table.dMandatory = lc-dMandatory = "on"
                        b-table.dWarning   = int(lc-dwarning)
                    .
                   
                    
                end.
            end.
        end.
        else
        do:
            find b-table where rowid(b-table) = to-rowid(lc-rowid)
                 exclusive-lock no-wait no-error.
            if locked b-table 
            then run htmlib-AddErrorMessage(
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
            set-user-field("classcode",lc-classcode).
            set-user-field("subcode",lc-subcode).
            set-user-field("firstback",lc-firstback).
            RUN run-web-object IN web-utilities-hdl ("sys/webinvfield.p").
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        

        if can-do("view,delete",lc-mode)
        or request_method <> "post"
        then assign 
                lc-dorder = string(b-table.dorder)
                lc-dlabel = b-table.dlabel
                lc-dtype  = b-table.dtype
                lc-dmandatory = if b-table.dmandatory then 'on' else ''
                lc-dprompt    = b-table.dprompt
                lc-dwarning   = if b-table.dType = "date"
                                then string(b-table.dWarning)
                                else ""
                .
     
    end.

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", appurl + '/sys/webinvfieldmnt.p' )
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
           ( if lookup("dorder",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Order")
           else htmlib-SideLabel("Order"))
           '</TD>' skip
           .

    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("dorder",10,lc-dorder) skip
           '</TD>'.
    

    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("dlabel",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Label")
            else htmlib-SideLabel("Label"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("dlabel",40,lc-dlabel) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-dlabel),'left')
           skip.
    {&out} '</TR>' skip.

  
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("dtype",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Type")
            else htmlib-SideLabel("Type"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("dtype",lc-global-dtype,lc-global-dtype,lc-dtype) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(
        lc-dtype
        ),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("dwarning",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Warning Period")
           else htmlib-SideLabel("Warning Period"))
           '</TD>' skip
           .

    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("dwarning",3,lc-dwarning) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(
        lc-dwarning
        ),'left')
           skip.
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("dmandatory",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Mandatory?")
            else htmlib-SideLabel("Mandatory?"))
            '</TD>'.
    
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("dmandatory", if lc-dmandatory = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-dmandatory = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("dprompt",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Prompt")
           else htmlib-SideLabel("Prompt"))
           '</TD>' skip
           .

    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("dprompt",60,lc-dprompt) skip
           '</TD>'.
    

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
          
    {&out}
        htmlib-Hidden("classcode", lc-classcode) skip
        htmlib-Hidden("subcode", lc-subcode) skip
        htmlib-Hidden("firstback",lc-firstback) skip.

    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

