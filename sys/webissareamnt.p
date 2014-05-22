&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webissareamnt.p
    
    Purpose:        Issue Area Maintenance       
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      CompanyCode
    02/07/2006  phoski      Default Actions      
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


def buffer b-valid for webissarea.
def buffer b-table for webissarea.


def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.

def var lc-field        as char no-undo.

def var lc-areacode      as char no-undo.
def var lc-description   as char no-undo.
def var lc-groupid      as char no-undo.
def var lc-actioncode    as char extent 10 no-undo.
def var li-loop          as int no-undo.
def var lc-act-code      as char no-undo.
def var lc-act-desc      as char no-undo.

def var lc-grp-code     as char no-undo.
def var lc-grp-desc     as char no-undo.

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

&IF DEFINED(EXCLUDE-ip-ActionCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ActionCode Procedure 
PROCEDURE ip-ActionCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  pc-CompanyCode     as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Desc            as char no-undo.


    def buffer b-IssArea for WebAction.

    assign pc-Codes = ""
           pc-Desc = "None".


    for each b-IssArea no-lock 
        where b-IssArea.CompanyCode = pc-CompanyCode
        by b-IssArea.Description:
        assign pc-Codes = pc-Codes + '|' + 
               b-IssArea.ActionCode
               pc-Desc = pc-Desc + '|' + 
               b-IssArea.Description.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GroupCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GroupCode Procedure 
PROCEDURE ip-GroupCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  pc-CompanyCode     as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Desc            as char no-undo.


    def buffer b-buffer for WebIssAGrp.

    assign pc-Codes = ""
           pc-Desc = "None".


    for each b-buffer no-lock 
        where b-buffer.CompanyCode = pc-CompanyCode:

        if pc-Codes = ""
        then assign pc-Codes = b-buffer.GroupID
                    pc-desc  = b-buffer.Description.
        else
        assign pc-Codes = pc-Codes + '|' + 
               b-buffer.GroupID
               pc-Desc = pc-Desc + '|' + 
               b-buffer.Description.
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
  emails:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.


    if lc-mode = "ADD":U then
    do:
        if lc-areacode = ""
        or lc-areacode = ?
        then run htmlib-AddErrorMessage(
                    'areacode', 
                    'You must enter the area code',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        

        if can-find(first b-valid
                    where b-valid.areacode = lc-areacode
                      and b-valid.companycode = lc-global-company
                    no-lock)
        then run htmlib-AddErrorMessage(
                    'areacode', 
                    'This area code already exists',
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
                    lc-submit-label = "Add Area".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Area'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Area'.
    end case.


    assign lc-title = lc-title + ' Area'
           lc-link-url = appurl + '/sys/webissarea.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&time=' + string(time)
                           .

    RUN ip-ActionCode ( lc-global-company,
                        output lc-act-code,
                        output lc-act-desc ).
    run ip-GroupCode ( lc-global-company,
                        output lc-grp-code,
                        output lc-grp-desc ).

    if can-do("view,update,delete",lc-mode) then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid)
             no-lock no-error.
        if not avail b-table then
        do:
            set-user-field("mode",lc-mode).
            set-user-field("title",lc-title).
            set-user-field("nexturl",appurl + "/sys/webissarea.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.

    end.


    if request_method = "POST" then
    do:

        if lc-mode <> "delete" then
        do:
            assign lc-areacode   = get-value("areacode")
                   lc-description  = get-value("description")
                   lc-groupid      = get-value("groupid")
                   .

            do li-loop = 1 to 10:
                assign lc-actioncode[li-loop] =
                        get-value("actioncode" + string(li-loop)).
            end.
  
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
                    assign b-table.areacode = caps(lc-areacode)
                           b-table.companycode = lc-global-company
                           lc-firstrow      = string(rowid(b-table))
                           .
                    
                   
                end.
                if lc-error-msg = "" then
                do:
                    assign b-table.description     = lc-description
                           b-table.groupid         = lc-groupid
                          .
                    do li-loop = 1 to 10:
                        assign
                            b-table.def-ActionCode[li-loop] = 
                            lc-actioncode[li-loop].
                    end.
                    
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
            RUN run-web-object IN web-utilities-hdl ("sys/webissarea.p").
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        assign lc-areacode = b-table.areacode.

        if can-do("view,delete",lc-mode) or request_method <> "post"
        then 
        do:
            assign lc-description   = b-table.description
                   lc-groupid       = b-table.groupid.
                    
            do li-loop = 1 to 10:
                assign lc-actioncode[li-loop] = b-table.def-ActionCode[li-loop].
            end.
        end.
       
    end.

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", appurl + '/sys/webissareamnt.p' )
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
           ( if lookup("areacode",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Area Code")
           else htmlib-SideLabel("Area Code"))
           '</TD>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("areacode",20,lc-areacode) skip
           '</TD>'.
    else
    {&out} htmlib-TableField(html-encode(lc-areacode),'left')
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
    

    {&out} 
        '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (if lookup("groupid",lc-error-field,'|') > 0 
        then htmlib-SideLabelError("Area Group")
        else htmlib-SideLabel("Area Group"))
        '</TD>'.

     if not can-do("view,delete",lc-mode) then
     {&out} '<TD VALIGN="TOP" ALIGN="left">'
             htmlib-Select("groupid",lc-grp-code,lc-grp-desc,
            lc-groupid)
             '</TD>' skip.
     else 
     
     do: 
         find webissAgrp
             where webissagrp.companycode = lc-global-company
               and webissagrp.groupid = lc-groupid no-lock no-error.

         {&out} htmlib-TableField(html-encode(
                if avail webissagrp
                then webissagrp.description else "")
           ,'left')

            skip.
     end.
     {&out} '</TR>' skip.

    if lc-act-code <> "" then
    do li-loop = 1 to 10:
        if lc-actioncode[li-loop] = ""
        and can-do("view,delete",lc-mode) then next.

        assign lc-field = "actioncode" + string(li-loop).

        {&out} 
            '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup(lc-field,lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Default Action " + string(li-loop))
            else htmlib-SideLabel("Default Action " + string(li-loop)))
            '</TD>'.

         if not can-do("view,delete",lc-mode) then
         {&out} '<TD VALIGN="TOP" ALIGN="left">'
                 htmlib-Select(lc-field,lc-act-code,lc-act-desc,
                lc-actioncode[li-loop])
                 '</TD>' skip.
         else 
         {&out} htmlib-TableField(html-encode(
                dynamic-function("com-DecodeLookup",
                                 lc-actioncode[li-loop],
                                 lc-act-code,
                                 lc-act-desc)
                                 ),'left')

                skip.
         {&out} '</TR>' skip.
        



        

    end.
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

