&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/slamnt.p
    
    Purpose:        SLA Maintenance      
    
    Notes:
    
    
    When        Who         What
    28/04/2006  phoski      Initial      
    15/05/2014  phoski      Amber Warning period
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


def buffer b-valid  for slahead.
def buffer b-table  for slahead.
def buffer Customer for Customer.


def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.


def var lf-Audit            as dec  no-undo.
def var lc-slacode          as char no-undo.
def var lc-description      as char no-undo.
def var lc-AccountNumber    as char no-undo.
def var lc-Notes            as char no-undo.
def var lc-TimeBase         as char no-undo.
def var lc-AlertBase        as char no-undo.
def var lc-incSat           as char no-undo.
def var lc-incSun           as char no-undo.
DEF VAR lc-AmberWarning     AS CHAR NO-UNDO.


def var li-loop             as int                  no-undo.
def var lc-respunit         like slahead.respunit   no-undo.
def var lc-respdesc         like lc-respunit        no-undo.
def var lc-resptime         like lc-respunit        no-undo.
def var lc-respaction       like lc-respunit        no-undo.
def var lc-respdest         like lc-respunit        no-undo.

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

&IF DEFINED(EXCLUDE-ip-AlertTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-AlertTable Procedure 
PROCEDURE ip-AlertTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var li-loop         as int      no-undo.
    def var lc-object       as char     no-undo.
    def var lc-value        as char     no-undo.

    {&out}
        '<tr><td colspan=2>'.


    {&out} skip
           htmlib-StartFieldSet("SLA Alerts") 
           htmlib-StartMntTable().

    {&out}
            htmlib-TableHeading(
            "Level^right|Description^left|Unit^left|Time^left|Action^left|Alert To^left"
            ) skip.

    do li-loop = 1 to 10:
        {&out} '<tr class="tabrow1">'.

        {&out} '<th style="text-align: right; vertical-align: text-top;">'
                         li-loop ":" '</th>'.

        if can-do("view,delete",lc-mode) then
        do:
            {&out} 
                '<td>' html-encode(b-table.respdesc[li-loop]) '</td>'
                '<td>' html-encode(
                    dynamic-function("com-DecodeLookup",b-table.respunit[li-loop],
                                     lc-global-respunit-code,
                                     lc-global-respunit-display)
                                     ) '</td>'
                '<td>' if b-table.resptime[li-loop] = 0
                       then "&nbsp;" else html-encode(string(b-table.resptime[li-loop])) '</td>'
                '<td>' html-encode(
                    dynamic-function("com-DecodeLookup",b-table.respaction[li-loop],
                                     lc-global-respaction-code,
                                     lc-global-respaction-display)
                                     ) '</td>'
                '<td>' html-encode(b-table.respdest[li-loop]) '</td>'
                .

        end.
        else
        do:
            assign 
                lc-object = "respdesc" + string(li-loop)
                lc-value  = get-value(lc-object).
            {&out} '<td>' htmlib-InputField(lc-object,20,lc-value) '</td>'.

            assign 
                lc-object = "respunit" + string(li-loop)
                lc-value  = get-value(lc-object).
            {&out} '<td>' htmlib-Select(lc-object,lc-global-respunit-code,lc-global-respunit-display,lc-value) '</td>'.

            assign 
                lc-object = "resptime" + string(li-loop)
                lc-value  = get-value(lc-object).
            {&out} '<td>' htmlib-InputField(lc-object,4,lc-value) '</td>'.

            assign 
                lc-object = "respaction" + string(li-loop)
                lc-value  = get-value(lc-object).
            {&out} '<td>' htmlib-Select(lc-object,lc-global-respaction-code,lc-global-respaction-display,lc-value) '</td>'.

            assign 
                lc-object = "respdest" + string(li-loop)
                lc-value  = get-value(lc-object).
            {&out} '<td>' htmlib-InputField(lc-object,30,lc-value) '</td>'.



        end.

        {&out} '</tr>'.
    end.
    {&out} skip 
           htmlib-EndTable()
           htmlib-EndFieldSet() 
           skip.

    {&out} '</td></tr>'.

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

    def var lf-dec      as dec          no-undo.
    def var li-index    as int          no-undo.
    def var lc-char     as char         no-undo.
    DEF VAR li-int      AS INT          NO-UNDO.

    def buffer webuser  for webuser.

    if lc-mode = "ADD":U then
    do:
        if lc-slacode = ""
        or lc-slacode = ?
        then run htmlib-AddErrorMessage(
                    'slacode', 
                    'You must enter the SLA code',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        

        if can-find(first b-valid
                    where b-valid.slacode = lc-slacode
                      and b-valid.companycode = lc-global-company
                      and b-valid.AccountNumber = lc-accountnumber
                    no-lock)
        then run htmlib-AddErrorMessage(
                    'slacode', 
                    'This SLA code already exists',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        if lc-accountnumber <> "" then
        do:
            if not can-find(customer where customer.companycode = lc-global-company
                                       and customer.AccountNumber = lc-accountNumber no-lock)
            then run htmlib-AddErrorMessage(
                    'accountnumber', 
                    'This customer does not exist',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
            else
            if not can-find(first b-valid
                    where b-valid.slacode = lc-slacode
                      and b-valid.companycode = lc-global-company
                      and b-valid.AccountNumber = ""
                    no-lock)
            then run htmlib-AddErrorMessage(
                    'slacode', 
                    'This SLA code does not exist, a default must exist before creating a customer SLA',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        end.
    end.

    if lc-description = ""
    or lc-description = ?
    then run htmlib-AddErrorMessage(
                    'description', 
                    'You must enter the description',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    ASSIGN
        li-int = INT(lc-amberWarning) NO-ERROR.

    IF ERROR-STATUS:ERROR 
    OR li-int < 0 
    OR li-int = ? 
    THEN run htmlib-AddErrorMessage(
                    'amberwarning', 
                    'Amber warning period is invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    do li-loop = 1 to 10:
        /*
        ***
        *** if description is blank then all other resp stuff
        *** should be as well
        ***
        */
        if lc-respdesc[li-loop] = "" then
        do:
            if lc-respunit[li-loop] <> "none"
            or lc-resptime[li-loop] <> ""
            or lc-respaction[li-loop] <> "none" 
            or lc-respdest[li-loop] <> "" 
            then run htmlib-AddErrorMessage(
                    'null', 
                    'Alert ' + string(li-loop) + 
                    ': All fields should be blank or set to none if the level is not used',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        end.
        else
        do:
            if li-loop > 1 then
            do: 
                if lc-respdesc[li-loop - 1] = "" 
                then run htmlib-AddErrorMessage(
                    'null', 
                    'Alert ' + string(li-loop) + 
                    ': The previous level is blank, you can not have unused levels between used levels',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
                next.
            end.
            if lc-respunit[li-loop] = "none" 
            then run htmlib-AddErrorMessage(
                    'null', 
                    'Alert ' + string(li-loop) + 
                    ': If this level is used you must select a unit',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

            assign
                lf-dec = dec(lc-resptime[li-loop]) no-error.
            if error-status:error 
            or lf-dec < 1
            or truncate(lf-dec,0) <> lf-dec 
            then run htmlib-AddErrorMessage(
                    'null', 
                    'Alert ' + string(li-loop) + 
                    ': If this level is used you must enter an integer time above zero',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
            if lc-respaction[li-loop] = "none" 
            then run htmlib-AddErrorMessage(
                    'null', 
                    'Alert ' + string(li-loop) + 
                    ': If this level is used you must select an action',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
            /*if lc-respdest[li-loop] = "" 
            then run htmlib-AddErrorMessage(
                    'null', 
                    'Alert ' + string(li-loop) + 
                    ': If this level is used you must select one or more users to alert',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
            else
            */
            if lc-respdest[li-loop] <> "" then
            do li-index = 1 to num-entries(lc-respdest[li-loop]):

                assign lc-char = trim(entry(li-index,lc-respdest[li-loop])).
                if lc-char = "" then
                do:
                    run htmlib-AddErrorMessage(
                        'null', 
                        'Alert ' + string(li-loop) + 
                        ': You can not have blank entries in the alert destination entry',
                        input-output pc-error-field,
                        input-output pc-error-msg ).
                end.

                find webuser
                    where webuser.loginid = lc-char no-lock no-error.
                if not avail webuser 
                or webuser.CompanyCode <> lc-global-company
                then run htmlib-AddErrorMessage(
                        'null', 
                        'Alert ' + string(li-loop) + 
                        ': The user ' + lc-char + ' does not exist',
                        input-output pc-error-field,
                        input-output pc-error-msg ).
                else 
                if webuser.UserClass = "CUSTOMER" 
                then run htmlib-AddErrorMessage(
                        'null', 
                        'Alert ' + string(li-loop) + 
                        ': The user ' + lc-char + ' is a customer, you can not send SLA alerts to them',
                        input-output pc-error-field,
                        input-output pc-error-msg ).

            end.


        end.
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
                    lc-submit-label = "Add SLA".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete SLA'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update SLA'.
    end case.


    assign lc-title = lc-title + ' SLA'
           lc-link-url = appurl + '/sys/sla.p' + 
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
            set-user-field("nexturl",appurl + "/sys/sla.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.

    end.


    if request_method = "POST" then
    do:

        if lc-mode <> "delete" then
        do:
            assign lc-slacode       = get-value("slacode")
                   lc-description   = get-value("description")
                   lc-notes         = get-value("notes")
                   lc-accountnumber = get-value("accountnumber")
                   lc-TimeBase      = get-value("timebase")
                   lc-incSat        = get-value("incsat")
                   lc-incSun        = get-value("incsun")
                   lc-AlertBase     = get-value("alertbase")
                   lc-amberWarning  = get-value("amberwarning")
                   .
  
            do li-loop = 1 to 10:
                assign 
                    lc-respdesc[li-loop] = get-value("respdesc" + string(li-loop))
                    lc-respunit[li-loop] = get-value("respunit" + string(li-loop))
                    lc-resptime[li-loop] = get-value("resptime" + string(li-loop))
                    lc-respaction[li-loop] = get-value("respaction" + string(li-loop))
                    lc-respdest[li-loop] = get-value("respdest" + string(li-loop))
                .
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
                    assign b-table.slacode = caps(lc-slacode)
                           b-table.companycode = lc-global-company
                           b-table.AccountNumber = caps(lc-accountNumber)
                           lc-firstrow      = string(rowid(b-table))
                           .
                    do while true:
                        run lib/makeaudit.p (
                            "",
                            output lf-audit
                            ).
                        if can-find(first slaHead
                                    where slaHead.SLAID = lf-audit no-lock)
                                    then next.
                        assign
                            b-table.SLAID = lf-audit.
                        leave.
                    end.
                   
                end.
                if lc-error-msg = "" then
                do:
                    assign 
                        b-table.description     = lc-description
                        b-table.notes           = lc-notes  
                        b-table.TimeBase        = lc-TimeBase
                        b-table.AlertBase       = lc-AlertBase
                        b-table.incSat          = lc-incsat = "on"
                        b-table.incSun          = lc-incSun = "on"
                        b-table.AmberWarning    = INT(lc-amberWarning)
                          .
                   
                    do li-loop = 1 to 10:
                        if lc-respdesc[li-loop] = "" 
                        then assign
                                b-table.respdesc[li-loop] = ""
                                b-table.respunit[li-loop] = ""
                                b-table.resptime[li-loop] = 0
                                b-table.respaction[li-loop] = ""
                                b-table.respdest[li-loop] = "".
                        else assign
                                b-table.respdesc[li-loop] = lc-respdesc[li-loop]
                                b-table.respunit[li-loop] = lc-respunit[li-loop]
                                b-table.resptime[li-loop] = int(lc-resptime[li-loop])
                                b-table.respaction[li-loop] = lc-respaction[li-loop]
                                b-table.respdest[li-loop] = lc-respdest[li-loop].


                    end.
                    release b-table.    
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
            RUN run-web-object IN web-utilities-hdl ("sys/sla.p").
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        assign lc-slacode = b-table.slacode
               lc-AccountNumber = b-table.AccountNumber.

        if can-do("view,delete",lc-mode)
        or request_method <> "post" then 
        do:
            assign lc-description   = b-table.description
                    lc-notes         = b-table.notes
                    lc-accountnumber = b-table.AccountNumber
                    lc-timeBase      = b-table.TimeBase
                    lc-AlertBase     = b-table.AlertBase
                    lc-incSun        = if b-table.incsun then "on" else ""
                    lc-incSat        = if b-table.incsat then "on" else ""
                    lc-AmberWarning  = STRING(b-table.AmberWarning)
                    .
            do li-loop = 1 to 10:
                if b-table.respdesc[li-loop] = "" then next.
                assign
                    lc-respdesc[li-loop] = b-table.respdesc[li-loop] 
                    lc-respunit[li-loop] = b-table.respunit[li-loop] 
                    lc-resptime[li-loop] = string(b-table.resptime[li-loop]) 
                    lc-respaction[li-loop] = b-table.respaction[li-loop]
                    lc-respdest[li-loop] = b-table.respdest[li-loop].
                set-user-field("respdesc" + string(li-loop),lc-respdesc[li-loop]).
                set-user-field("respunit" + string(li-loop),lc-respunit[li-loop]).
                set-user-field("resptime" + string(li-loop),lc-resptime[li-loop]).
                set-user-field("respaction" + string(li-loop),lc-respaction[li-loop]).
                set-user-field("respdest" + string(li-loop),lc-respdest[li-loop]).


            end.
        end.
    end.

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", appurl + '/sys/slamnt.p' )
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
           ( if lookup("slacode",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("SLA Code")
           else htmlib-SideLabel("SLA Code"))
           '</TD>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("slacode",20,lc-slacode) skip
           '</TD>'.
    else
    {&out} htmlib-TableField(html-encode(lc-slacode),'left')
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
    
    if lc-mode = "ADD" then
    do:
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
               ( if lookup("accountnumber",lc-error-field,'|') > 0 
               then htmlib-SideLabelError("Account Number")
               else htmlib-SideLabel("Account Number"))
               '</TD>' skip
               .

        {&out} 
            '<TD VALIGN="TOP" ALIGN="left">'
                '<input class="inputfield" name="accountnumber" size="8" value="' get-value("accountnumber") '"' skip
                'onBlur="javascript:AjaxSimpleDescription(this,~'' appurl '~',~'' lc-global-company '~',~'accountnumber~',~'customername~');"'
                '>'
                
                skip(2)
                htmlib-ALookup("accountnumber","nullfield",appurl + '/lookup/customer.p')
                skip(2)
                '<span id="customername" class="reffield">&nbsp;</span>'
            '</TD>'.
        {&out} '</TR>' skip.
    end.
    else
    if lc-accountNumber <> "" 
    and can-find(customer where customer.companycode = lc-global-company
                            and customer.AccountNumber = lc-AccountNumber
                            no-lock) then
    do:
        find customer 
            where customer.CompanyCode = lc-global-company
              and customer.AccountNumber = lc-AccountNumber
              no-lock no-error.
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
               ( if lookup("accountnumber",lc-error-field,'|') > 0 
               then htmlib-SideLabelError("Account Number")
               else htmlib-SideLabel("Account Number"))
               '</TD>'
               htmlib-TableField(html-encode(lc-accountnumber + " " + customer.name),'left')
                '</tr>'
               skip.
    end.

   

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("timebase",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("SLA Covers")
            else htmlib-SideLabel("SLA Covers"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("timebase",lc-global-tbase-code,lc-global-tbase-display,lc-timebase)
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(dynamic-function("com-DecodeLookup",lc-timebase,
                                     lc-global-tbase-code,
                                     lc-global-tbase-display
                                     ),'left')
           skip.
    {&out} '</TR>' skip.

    


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          (if lookup("incsat",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("SLA Covers Saturdays?")
          else htmlib-SideLabel("SLA Covers Saturdays?"))
          '</TD>'.

    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
          htmlib-CheckBox("incsat", if lc-incsat = 'on'
                                      then true else false) 
          '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-incsat = 'on'
                                       then 'yes' else 'no'),'left')
         skip.

    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          (if lookup("incsun",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("SLA Covers Sundays?")
          else htmlib-SideLabel("SLA Covers Sundays?"))
          '</TD>'.

    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
          htmlib-CheckBox("incsun", if lc-incsun = 'on'
                                      then true else false) 
          '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-incsun = 'on'
                                       then 'yes' else 'no'),'left')
         skip.

    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("alertbase",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("SLA Alerts Time Based On")
            else htmlib-SideLabel("SLA Alerts Time Based On"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("alertbase",lc-global-abase-code,lc-global-abase-display,lc-alertbase)
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(dynamic-function("com-DecodeLookup",lc-alertbase,
                                     lc-global-abase-code,
                                     lc-global-abase-display
                                     ),'left')
           skip.
    {&out} '</TR>' skip.

     {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("amberwarning",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Amber Warning (Minutes)")
            else htmlib-SideLabel("Amber Warning (Minutes)"))
            '</TD>'.

     if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("amberwarning",4,lc-amberwarning) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-amberwarning),'left')
           skip.
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("notes",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Note")
            else htmlib-SideLabel("Note"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-TextArea("notes",lc-notes,5,60)
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(replace(html-encode(lc-notes),"~n",'<br>'),'left')
           skip.
    {&out} '</TR>' skip.


    RUN ip-AlertTable.

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

