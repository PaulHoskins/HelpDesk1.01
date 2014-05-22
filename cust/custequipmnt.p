&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        cust/custequipmnt.p
    
    Purpose:        Customer Inventory   
    
    Notes:
    
    
    When        Who         What
    30/07/2006  phoski      Initial
    
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


def buffer customer     for customer.
def buffer CustField    for CustField.
def buffer b-valid      for CustIV.
def buffer b-table      for CustIV.


def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.
def var lc-customer     as char no-undo.
def var lc-returnback   as char no-undo.

def var lc-link-label       as char no-undo.
def var lc-submit-label     as char no-undo.
def var lc-link-url         as char no-undo.
def var lc-submitsource     as char no-undo.

def var lc-list-class         as char no-undo.
def var lc-list-Name          as char no-undo.


def var lc-ref              as char no-undo.
def var lc-ivClass          as char no-undo.

def temp-table tt           no-undo
    field ivFieldID         like ivField.ivFieldID
    field FieldData         like custField.FieldData
    index ivFieldID 
            ivFieldId.
def var lf-CustIVID         like custField.CustIVID no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnSelectClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSelectClass Procedure 
FUNCTION fnSelectClass RETURNS CHARACTER
  ( pc-htm as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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

&IF DEFINED(EXCLUDE-ip-GetClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GetClass Procedure 
PROCEDURE ip-GetClass :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pc-Code as char no-undo.
    def output param pc-Name as char no-undo.

    
    def buffer ivClass  for IvClass.
    def buffer ivSub    for ivSub.


    assign pc-Code = htmlib-Null()
           pc-Name          = "Select Inventory".


    for each ivClass no-lock
             where ivClass.CompanyCode = lc-global-company
             ,
             each IvSub of ivClass no-lock
             by ivClass.name:

        assign pc-Code = pc-Code + '|' + "C" + string(ivSub.ivSubid)
               pc-Name          = pc-Name + '|' + 
                                  ivClass.name + " - " + ivSub.name.

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-GetCurrent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-GetCurrent Procedure 
PROCEDURE ip-GetCurrent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer ivField      for ivField.
    def buffer CustField    for CustField.
    def var lc-object       as char     no-undo.
    def var lc-value        as char     no-undo.
    def var lf-ivSubID      as dec      no-undo.

    
    for each ivField of ivSub no-lock
        by ivField.dOrder
        by ivField.dLabel:
    
        
        assign lc-object = "FLD" + string(ivField.ivFieldID).
        assign lc-value = "".

        find CustField
            where CustField.CustIVID = b-table.CustIvID
              and CustField.ivFieldId = ivField.ivFieldID
              no-lock no-error.

        set-user-field(lc-object,if avail CustField then CustField.FieldData else "").
  
    
    end.
              

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-InventoryTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-InventoryTable Procedure 
PROCEDURE ip-InventoryTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer ivClass      for ivClass.
    def buffer ivSub        for ivSub.
    def buffer ivField      for ivField.
    def var lc-object       as char     no-undo.
    def var lc-value        as char     no-undo.
    def var lf-ivSubID      as dec      no-undo.

    {&out}
        '<tr><td colspan=2>'.


    {&out} skip
           htmlib-StartFieldSet("Inventory Details") 
           htmlib-StartMntTable().

    {&out}
            htmlib-TableHeading(
            "^right|Details^left|Notes^left"
            ) skip.

    if lc-ivClass begins "C" then
    do:
        assign
            lf-ivSubId = dec(substr(lc-ivClass,2)).

        find ivSub where ivSub.ivSubID = lf-ivSubId no-lock no-error.

        if avail ivSub and can-find(ivClass of ivSub no-lock) then
        do:
            find ivClass of ivSub no-lock no-error.
            for each ivField of ivSub no-lock
                by ivField.dOrder
                by ivField.dLabel:

                {&out} '<tr class="tabrow1">'.

                {&out} '<th style="text-align: right; vertical-align: text-top;">'
                        html-encode(ivField.dLabel + ":").

                if ivField.dMandatory and can-do("add,update",lc-mode)
                then {&out} '<br><span style="font-size: 8px;">Mandatory</span>'.
                {&out}
                        '</th>'.

                assign lc-object = "FLD" + string(ivField.ivFieldID).
                assign lc-value = get-value(lc-object).

                if can-do("view,delete",lc-mode) then 
                do:
                    {&out} htmlib-MntTableField(replace(html-encode(lc-value),"~n","<br>"),'left') skip.
                end.
                else
                do:
                    {&out} '<td>' skip.

                    case ivField.dType:
                        when "TEXT" then
                        do:
                            {&out} htmlib-InputField(lc-object,40,lc-value).
                        end.
                        when "DATE" then
                        do:
                            {&out} htmlib-InputField(lc-object,10,lc-value).
                        end.
                        when "NUMBER" then
                        do:
                            {&out} htmlib-InputField(lc-object,10,lc-value).
                        end.
                        when "YES/NO" then
                        do:
                            {&out} htmlib-Select(lc-object,"Yes|No","Yes|No",if lc-value = "" then "Yes" else lc-value).
                        end.
                        when "NOTE" then
                        do:
                            {&out} htmlib-TextArea(lc-object,lc-value,5,40).
                        end.
                        otherwise
                            do:
                                {&out} html-encode('Error - type ' + ivField.dType + ' unknown').
                            end.

                    end case.
                    {&out} '</td>' skip.

                end.
                {&out} htmlib-MntTableField(html-encode(ivField.dPrompt),'left') skip.





                {&out} '</tr>' skip.
            end.
        end.

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

&IF DEFINED(EXCLUDE-ip-JavaScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-JavaScript Procedure 
PROCEDURE ip-JavaScript :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&out} skip 
          '<script language="JavaScript">' skip.

    {&out} skip
        'function ChangeClass() ~{' skip
        '   SubmitThePage("ClassChange")' skip
        '~}' skip.

      
    {&out} skip
           '</script>' skip.
    {&out} htmlib-JScript-Maintenance() skip.
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

    def buffer ivClass      for ivClass.
    def buffer ivSub        for ivSub.
    def buffer ivField      for ivField.
    def var lc-object       as char     no-undo.
    def var lc-value        as char     no-undo.
    def var lf-ivSubID      as dec      no-undo.
    def var ld-date         as date     no-undo.
    def var lf-number       as dec      no-undo.

    
    if lc-ivClass = htmlib-Null() 
    then run htmlib-AddErrorMessage(
                    'ivclass', 
                    'You must select the inventory type',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
    
    if lc-ref = ""
    or lc-ref = ?
    then run htmlib-AddErrorMessage(
                    'ref', 
                    'You must enter the reference',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
 
    empty temp-table tt.

    if lc-ivClass <> htmlib-Null() then
    do:
        assign
            lf-ivSubId = dec(substr(lc-ivClass,2)).

        find ivSub where ivSub.ivSubID = lf-ivSubId no-lock no-error.

        if avail ivSub and can-find(ivClass of ivSub no-lock) then
        do:
            find ivClass of ivSub no-lock no-error.
            for each ivField of ivSub no-lock
                by ivField.dOrder
                by ivField.dLabel:

                
                
                assign lc-object = "FLD" + string(ivField.ivFieldID).
                assign lc-value = get-value(lc-object).

                create tt.
                assign tt.ivFieldID = ivField.ivFieldID
                       tt.FieldData = lc-value.

                if lc-value = "" and ivField.dMandatory 
                then run htmlib-AddErrorMessage(
                         lc-object, 
                         'The inventory field ' + html-encode(ivField.dLabel) + ' is mandatory',
                         input-output pc-error-field,
                         input-output pc-error-msg ).
                else
                if lc-value <> "" then
                case ivField.dType:
                    when "DATE" then
                    do:
                        assign
                            ld-date = date(lc-value) no-error.
                        if error-status:error 
                        then run htmlib-AddErrorMessage(
                             lc-object, 
                             'The inventory field ' + html-encode(ivField.dLabel) + ' is not a valid date',
                             input-output pc-error-field,
                             input-output pc-error-msg ).
                        else assign tt.FieldData = string(ld-date,"99/99/9999").
                        
                    end.
                    when "NUMBER" then
                    do:
                        assign
                            lf-number = dec(lc-value) no-error.
                        if error-status:error 
                        then run htmlib-AddErrorMessage(
                             lc-object, 
                             'The inventory field ' + html-encode(ivField.dLabel) + ' is not a valid number',
                             input-output pc-error-field,
                             input-output pc-error-msg ).
                        else assign tt.FieldData = string(lf-number).
                        
                    end.
                    

                end case.
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

    assign lc-mode = get-value("mode")
           lc-rowid = get-value("rowid")
           lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation")
           lc-customer   = get-value("customer")
           lc-returnback = get-value("returnback").

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
                    lc-submit-label = "Add Inventory".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Inventory'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Inventory'.
    end case.


    find customer where rowid(customer) = to-rowid(lc-customer)
            no-lock no-error.

    RUN ip-GetClass ( output lc-list-class, output lc-list-Name ).

    assign lc-title = lc-title + ' Customer Inventory'
           lc-link-url = appurl + '/cust/custequip.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&customer=' + lc-customer +
                                  '&returnback=' + lc-returnback +
                                  '&' + htmlib-RandomURL()
                           .

    if lc-returnback = "renewal"
    then assign lc-link-url = appurl + "/cust/ivrenewal.p".
    else 
    if lc-returnback = "customerview" 
    then assign lc-link-url = appurl + "/cust/custview.p?source=menu&rowid=" + 
        get-value("customer").

    if can-do("view,update,delete",lc-mode) then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid)
             no-lock no-error.
        if not avail b-table then
        do:
            set-user-field("mode",lc-mode).
            set-user-field("title",lc-title).
            set-user-field("nexturl",appurl + "/cust/custequip.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.
        
        find ivSub of b-table no-lock no-error.
        find ivClass of ivSub no-lock no-error.

        set-user-field("inventory",
                       ivClass.name + " - " + ivSub.name).
        assign lc-ivClass = "C" + string(b-table.ivSubID).

        set-user-field("ivclass",lc-ivClass).
        if request_method = "GET"
        or lc-mode = "VIEW"
        then RUN ip-GetCurrent.
    end.


    if request_method = "POST" then
    do:
        assign
            lc-submitsource = get-value("submitsource").
        if lc-submitsource <> "ClassChange" then
        do:
        
            if lc-mode <> "delete" then
            do:
                assign lc-ref          = get-value("ref")
                       lc-ivclass      = get-value("ivclass")
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
                        assign b-table.accountnumber = customer.accountnumber
                               b-table.CompanyCode   = customer.CompanyCode
                               b-table.CustIvID      = ?
                               b-table.ivSubID       = dec(substr(lc-ivclass,2))
                               lc-firstrow           = string(rowid(b-table)).
                        do while true:
                            run lib/makeaudit.p (
                                "",
                                output lf-custIVID
                                ).
                            if can-find(first CustIV
                                        where CustIV.CustIvID = lf-custIVID no-lock)
                                        then next.
                            assign
                                b-table.CustIvID = lf-CustIvID.
                            leave.
                        end.
                       
                    end.
                    
                    assign b-table.ref = lc-ref
                               .

                    for each CustField of b-table exclusive-lock:
                        delete CustField.
                    end.
                    for each tt:
                        create CustField.
                        buffer-copy tt to CustField
                            assign CustField.CustIvID = b-table.CustIvID.
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
                    for each CustField of b-table exclusive-lock:
                        delete CustField.
                    end.
                    delete b-table.
                end.
            end.

            if lc-error-field = "" then
            do:
                if lc-returnback = "renewal" then
                do:
                    RUN run-web-object IN web-utilities-hdl ("cust/ivrenewal.p").
                    return.
                end.
                else
                if lc-returnback = "customerview" then
                do:
                    set-user-field("source","menu").
                    set-user-field("rowid",get-value("customer")).
                    RUN run-web-object IN web-utilities-hdl ("cust/custview.p").
                    return.
                end.
                set-user-field("navigation",'refresh').
                set-user-field("firstrow",lc-firstrow).
                set-user-field("search",lc-search).
                RUN run-web-object IN web-utilities-hdl ("cust/custequip.p").
                return.
            end.
        
        end.

        
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        
        if can-do("view,delete",lc-mode)
        or request_method <> "post" then 
        do:
            assign lc-ref      = b-table.ref
                   .
            
        end.
        else assign lc-ivClass = "C" + string(b-table.ivSubID).
       
    end.
    else
    do:
        if request_method = "POST" 
        then assign lc-ivClass = get-value("ivclass").
    end.


    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip.
    RUN ip-JavaScript.


    {&out}
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
            (if lookup("ivclass",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Inventory Type")
            else htmlib-SideLabel("Inventory Type"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">'.

    if lc-mode = "ADD" 
    then {&out} fnSelectClass(htmlib-Select("ivclass",lc-list-class,lc-list-Name,
                lc-ivclass)) skip.
    else {&out} html-encode(get-value("inventory")).

    {&out}
            '</TD></TR>' skip. 

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("ref",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Reference")
            else htmlib-SideLabel("Reference"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("ref",40,lc-ref) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-ref),'left')
           skip.
    {&out} '</TR>' skip.


    RUN ip-InventoryTable.

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
         
    {&out} skip
           htmlib-Hidden("customer",lc-customer) skip
           htmlib-Hidden("returnback",lc-returnback) skip
           htmlib-hidden("submitsource","") skip.
   
    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnSelectClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSelectClass Procedure 
FUNCTION fnSelectClass RETURNS CHARACTER
  ( pc-htm as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<select',
                   '<select onChange="ChangeClass()"'). 


  RETURN lc-htm.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

