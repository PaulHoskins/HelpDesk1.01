&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webmenumnt.p
    
    Purpose:        Menu Page Maintenance
    
    Notes:
    
    
    When        Who         What
    26/04/2014  phoski      40 Lines  
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


def buffer b-valid for webmhead.
def buffer b-table for webmhead.
def buffer b-line  for webmline.

def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.



def var lc-pagename     as char no-undo.
def var lc-pagedesc  as char no-undo.

def var li-max-lines    as int initial 40 no-undo.


def temp-table tt no-undo like webmline 
    field Extension as char
    field Description as char
    index PageLine is Primary
            PageLine.

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

&IF DEFINED(EXCLUDE-ip-BuildDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildDescription Procedure 
PROCEDURE ip-BuildDescription :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def buffer b-valobj for webobject.
    def buffer b-valmen for webmhead.

    for each tt exclusive-lock:
        assign tt.description = ''.

        if tt.linktype = 'NA' then next.

        
        case tt.linktype:
            when 'Object' then
            do:
                find b-valobj
                     where b-valobj.Objectid = tt.linkobject no-lock no-error.
                if avail b-valobj
                then assign tt.description = b-valobj.description.
            end.
            when 'Page' then
            do:
                find b-valmen
                   where b-valmen.pagename = tt.linkobject no-lock no-error.
                if avail b-valmen
                then assign tt.description = b-valmen.pagedesc.
                  
            end.

        end case.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-BuildLinePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildLinePage Procedure 
PROCEDURE ip-BuildLinePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN ip-BuildDescription.

    {&out} '<tr><td align=center colspan=2><table width=100%>' skip.
    if can-do("view,delete",lc-mode) = false
    then {&out} htmlib-TableHeading("Line^right|Type|Link|Description") skip.
    else {&out} htmlib-TableHeading("Type|Link|Description") skip.

           

    for each tt no-lock:
        if can-do('view,delete',lc-mode) then
        do:
            if tt.linktype = 'na' then next.
            {&out} '<tr>'
                htmlib-TableField(html-encode(tt.linktype),'left')
                htmlib-TableField(html-encode(tt.linkobject),'left')
                htmlib-TableField(html-encode(tt.description),'left')
                '</tr>' skip.
            next.
        end.

        {&out} '<TR>' skip.

        {&out} '<td align=right valign=top>' string(tt.pageline) '</td>' skip.

        {&out} '<TD align=left valign=top>'
               htmlib-Select("select" + tt.extension,
                             "NA|Object|Page",
                             "Not used|Object|Menu Page",
                             tt.LinkType)
                '</td>' skip.
               
        {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("object" + tt.extension,20,tt.LinkObject) 
           '</TD>' skip.


        {&out} '<td valign=top align=left">' tt.Description '</td>' skip.


        {&out} '</TR>' skip.
    end.



    {&out} '</table></td><tr>' skip.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CopyDBToTemp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CopyDBToTemp Procedure 
PROCEDURE ip-CopyDBToTemp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each tt no-lock:
        find b-line 
             where b-line.pagename = lc-pagename
               and b-line.pageline = tt.pageline
               no-lock no-error.
        if avail b-line then
        do:
            buffer-copy b-line to tt.
        end.

    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CopyHTMToTemp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CopyHTMToTemp Procedure 
PROCEDURE ip-CopyHTMToTemp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var lc-select as char no-undo.
    def var lc-object as char no-undo.

    for each tt:
        assign lc-select = get-value("select" + tt.extension).

        assign lc-object = get-value("object" + tt.extension).

        assign tt.linktype = lc-select
               tt.linkobject = lc-object.
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CreateBlankMenuLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CreateBlankMenuLines Procedure 
PROCEDURE ip-CreateBlankMenuLines :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var li-loop as int no-undo.
    do li-loop = 1 to li-max-lines:
        create tt.
        assign tt.PageLine = li-loop
               tt.Extension = string(li-loop,"999")
               tt.LinkType = "NA".
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-UpdateLines) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-UpdateLines Procedure 
PROCEDURE ip-UpdateLines :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    
    def var li-loop as int no-undo.

        
    for each b-line where b-line.pagename = b-table.pagename exclusive-lock:
        delete b-line.
    end. 
    
    for each tt exclusive-lock:
        if tt.linktype = 'NA' then
        do:
            delete tt.
            next.
        end.
        assign tt.pagename = b-table.pagename
               li-loop     = li-loop + 1
               tt.pageline = li-loop.
        create b-line.
        buffer-copy tt to b-line.

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
  objtargets:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.

    def buffer b-valobj for webobject.
    def buffer b-valmen for webmhead.


    if lc-mode = "ADD":U then
    do:
        if lc-pagename = ""
        or lc-pagename = ?
        then run htmlib-AddErrorMessage(
                    'pagename', 
                    'You must enter the name',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        

        if can-find(first b-valid
                    where b-valid.pagename = lc-pagename
                    no-lock)
        then run htmlib-AddErrorMessage(
                    'pagename', 
                    'This name already exists',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    end.

    if lc-pagedesc = ""
    or lc-pagedesc = ?
    then run htmlib-AddErrorMessage(
                    'pagedesc', 
                    'You must enter the description',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if pc-error-field <> "" then return.

    for each tt exclusive-lock:
        if tt.linktype = 'NA' then next.

        if tt.linkobject = ""
        or tt.linkobject = ? then
        do:
            run htmlib-AddErrorMessage(
                    'null', 
                    'Line ' + string(tt.pageline) + 
                    ' - You must enter the object or menu page',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
            
        end.
        else
        case tt.linktype:
            when 'Object' then
            do:
                if not can-find(b-valobj
                            where b-valobj.Objectid = tt.linkobject no-lock)
                then run htmlib-AddErrorMessage(
                    'null', 
                    'Line ' + string(tt.pageline) + 
                    ' - This web object does not exist',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
            end.
            when 'Page' then
            do:
                if not can-find(b-valmen
                            where b-valmen.pagename = tt.linkobject no-lock)
                then run htmlib-AddErrorMessage(
                    'null', 
                    'Line ' + string(tt.pageline) + 
                    ' - This menu page does not exist',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
                if tt.linkobject = lc-pagename then
                do:
                    run htmlib-AddErrorMessage(
                        'null', 
                        'Line ' + string(tt.pageline) + 
                        ' - A menu can not contain it self',
                        input-output pc-error-field,
                        input-output pc-error-msg ).
                end.
            end.

        end case.
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
  objtargets:       In the event that this Web object is state-aware, this is
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
  objtargets:       
------------------------------------------------------------------------------*/
    
    {lib/checkloggedin.i} 

    RUN ip-CreateBlankMenuLines.

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
                    lc-submit-label = "Add Menu Page".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Menu Page'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Menu Page'.
    end case.


    assign lc-title = lc-title + ' Menu Page'
           lc-link-url = appurl + '/sys/webmenu.p' + 
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
            set-user-field("nexturl",appurl + "/sys/webmenu.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.

    end.


    if request_method = "POST" then
    do:

        if lc-mode <> "delete" then
        do:
            assign lc-pagename  = get-value("pagename")
                   lc-pagedesc    = get-value("pagedesc")
                   
                   .
            
            RUN ip-CopyHTMToTemp.

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
                    assign b-table.pagename = lc-pagename
                           lc-firstrow      = string(rowid(b-table)).
                   
                end.
                if lc-error-msg = "" then
                do:
                    assign b-table.pagedesc  = lc-pagedesc
                           .
                    RUN ip-UpdateLines.
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
            else 
            do:
                for each b-line of b-table exclusive-lock:
                    delete b-line.
                end.
                delete b-table.
            end.
        end.

        if lc-error-field = "" then
        do:
            RUN outputHeader.
            set-user-field("navigation",'refresh').
            set-user-field("firstrow",lc-firstrow).
            set-user-field("search",lc-search).
            RUN run-web-object IN web-utilities-hdl ("sys/webmenu.p").
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        assign lc-pagename = b-table.pagename.

        if can-do("view,delete",lc-mode)
        or request_method <> "post" then 
        do:
            assign lc-pagedesc   = b-table.pagedesc.
            RUN ip-CopyDBToTemp.
        end.
        /* if request_method = "post" 
        then RUN ip-CopyHTMToTemp.
        */
    end.



    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle(lc-title) skip.

    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip.
        
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.

    {&out} htmlib-StartInputTable() skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("pagename",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Page Name")
           else htmlib-SideLabel("Page Name"))
           '</TD>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("pagename",20,lc-pagename) skip
           '</TD>'.
    else
    {&out} htmlib-TableField(html-encode(lc-pagename),'left')
           skip.


    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("pagedesc",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Description")
            else htmlib-SideLabel("Description"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("pagedesc",40,lc-pagedesc) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-pagedesc),'left')
           skip.
    {&out} '</TR>' skip.

    RUN ip-BuildLinePage.


    /*
    {&out} htmlib-Select("ASELECT","01|02|03|04","num1|num2|num3|num4","04").
    */
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

