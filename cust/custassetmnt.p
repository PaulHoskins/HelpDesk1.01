&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        cust/custassetmnt.p
    
    Purpose:        Customer Asset 
    
    Notes:
    
    
    When        Who         What
    27/04/2014  phoski      Initial
    
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
def buffer b-valid      for CustAst.
def buffer b-table      for CustAst.


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

def var lc-list-code          as char no-undo.
def var lc-list-desc          as char no-undo.

def var lc-AssetID              as char no-undo.
DEF var lc-aType                AS CHAR NO-UNDO.
DEF VAR lc-aManu                AS CHAR NO-UNDO.
DEF VAR lc-Model                AS CHAR NO-UNDO.
DEF VAR lc-serial               AS CHAR NO-UNDO.
DEF VAR lc-location             AS CHAR NO-UNDO.
DEF VAR lc-aStatus              AS CHAR NO-UNDO.
DEF VAR lc-Purchased            AS CHAR NO-UNDO.
DEF VAR lc-cost                 AS CHAR NO-UNDO.
DEF VAR lc-descr                AS CHAR NO-UNDO.
DEF VAR lc-details              AS CHAR NO-UNDO.

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

&IF DEFINED(EXCLUDE-ip-HeaderInclude-Calendar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-HeaderInclude-Calendar Procedure 
PROCEDURE ip-HeaderInclude-Calendar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

    def var lc-object       as char     no-undo.
    def var lc-value        as char     no-undo.
   
    def var ld-date         as date     no-undo.
    def var lf-number       as dec      no-undo.

    
    
    
    if lc-AssetID = ""
    or lc-AssetID = ?
    then run htmlib-AddErrorMessage(
                    'assetid', 
                    'You must enter the asset id',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    IF lc-mode = "ADD" 
    AND can-find( b-table 
                  WHERE  b-table.accountnumber = customer.accountnumber
                     AND b-table.CompanyCode   = customer.CompanyCode
                     AND b-table.AssetID = lc-AssetID NO-LOCK ) 
    THEN run htmlib-AddErrorMessage(
                    'assetid', 
                    'You asset already exists',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
 
    if lc-descr = ""
    or lc-descr = ?
    then run htmlib-AddErrorMessage(
                    'descr', 
                    'You must enter the asset description',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

 
    IF lc-purchased <> "" THEN
    DO:
        ld-date = DATE(lc-purchased) NO-ERROR.
        IF ld-date = ? THEN
            run htmlib-AddErrorMessage(
                    'purchased', 
                    'The purchase date is invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    END.
   
    IF lc-cost <> "" THEN
    DO:
        lf-number = Dec(lc-cost) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            run htmlib-AddErrorMessage(
                    'cost', 
                    'The cost is invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    END.

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
                    lc-submit-label = "Add Asset".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Asset'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Asset'.
    end case.


    find customer where rowid(customer) = to-rowid(lc-customer)
            no-lock no-error.

   
    assign lc-title = lc-title + ' Customer Asset'
           lc-link-url = appurl + '/cust/custasset.p' + 
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
        get-value("customer") + "&showtab=ASSET".
 

    if can-do("view,update,delete",lc-mode) then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid)
             no-lock no-error.
        if not avail b-table then
        do:
            set-user-field("mode",lc-mode).
            set-user-field("title",lc-title).
            set-user-field("nexturl",appurl + "/cust/custasset.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.
        
        ASSIGN 
            lc-AssetID = b-table.AssetID.

        if request_method = "GET"
        or lc-mode = "VIEW" then 
        DO:
            ASSIGN 
                lc-aType = b-table.aType
                lc-aManu = b-table.aManu
                lc-model = b-table.model
                lc-serial = b-table.serial
                lc-location = b-table.location
                lc-aStatus = b-table.aStatus
                lc-Purchased = IF b-table.Purchased = ? THEN ""
                    ELSE STRING(b-table.Purchased,"99/99/9999")
                lc-cost     =   STRING(b-table.cost,">>>>>>>>>9.99-")
                lc-descr    =   b-table.descr
                lc-details  =   b-table.details


                .
        END.
    end.


    if request_method = "POST" then
    do:
        assign
            lc-submitsource = get-value("submitsource").
       
        
        if lc-mode <> "delete" then
        do:
            IF lc-mode = "ADD"
            THEN assign lc-AssetID          = caps(get-value("assetid")).
        
            ASSIGN
                lc-aType    =   get-value("atype")
                lc-amanu    =   get-value("amanu")
                lc-model    =   get-value("model")
                lc-serial   =   GET-VALUE("serial")
                lc-location =   get-value("location")
                lc-aStatus  =   get-value("astatus")
                lc-purchased =  get-value("purchased")
                lc-cost     =   get-value("cost")
                lc-descr    =   get-value("descr")
                lc-details  =   get-value("details")

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
                            b-table.AssetID      = lc-AssetID
                           lc-firstrow           = string(rowid(b-table)).
                    
                   
                end.
                
                /* Update here */
        
        
                ASSIGN
                    b-table.atype   = lc-atype
                    b-table.amanu   = lc-amanu
                    b-table.model   = lc-model
                    b-table.serial  = lc-serial
                    b-table.location = lc-location
                    b-table.astatus = lc-astatus
                    b-table.purchased = IF lc-purchased = "" THEN ? 
                                        ELSE DATE(lc-purchased)
                    b-table.cost       = DEC(lc-cost)
                    b-table.descr      = lc-descr
                    b-table.details     = lc-details


                    .
                
                    
        
                
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
                DELETE b-table.    
            end.
        end.
        
        if lc-error-field = "" then
        do:
            if lc-returnback = "customerview" then
            do:
                set-user-field("source","menu").
                set-user-field("rowid",get-value("customer")).
                set-user-field("showtab","asset").
                RUN run-web-object IN web-utilities-hdl ("cust/custview.p").
                return.
            end.
        
            set-user-field("navigation",'refresh').
            set-user-field("firstrow",lc-firstrow).
            set-user-field("search",lc-search).
            RUN run-web-object IN web-utilities-hdl ("cust/custasset.p").
            return.
        end.
        
      

        
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        
        if can-do("view,delete",lc-mode)
        or request_method <> "post" then 
        do:
            assign lc-AssetID      = b-table.AssetID
                   .
            
        end.
       
    end.
    else
    do:
        
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
            (if lookup("assetid",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Asset ID")
            else htmlib-SideLabel("Asset ID"))
            '</TD>' .
    
    if can-do("ADD",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("assetid",20,lc-AssetID) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-AssetID),'left')
           skip.
    {&out} '</TR>' skip.

     {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("descr",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Description")
            else htmlib-SideLabel("Description"))
            '</TD>' .
    
    if can-do("add,update",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("descr",60,lc-descr) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-descr),'left')
           skip.
    {&out} '</TR>' skip.

    RUN com-GenTabSelect ( customer.CompanyCode, "Asset.Type", 
                           OUTPUT lc-list-code,
                           OUTPUT lc-list-desc ).

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("atype",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Type")
            else htmlib-SideLabel("Type"))
            '</TD>'
             '<TD VALIGN="TOP" ALIGN="left">' SKIP.

    
    IF can-do("ADD,UPDATE",lc-mode)
    then {&out} htmlib-Select("atype",lc-list-code,lc-list-desc,
                lc-atype) skip.
    else {&out} html-encode(lc-atype) "&nbsp" 
        html-encode(
            DYNAMIC-FUNCTION("com-GenTabDesc",
                         customer.CompanyCode, "Asset.Type", 
                         lc-atype)

            ).

    {&out} '</TD></TR>' skip. 

    RUN com-GenTabSelect ( customer.CompanyCode, "Asset.Manu", 
                            OUTPUT lc-list-code,
                            OUTPUT lc-list-desc ).

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
             (if lookup("amanu",lc-error-field,'|') > 0 
             then htmlib-SideLabelError("Manufacturer")
             else htmlib-SideLabel("Manufacturer"))
             '</TD>'
              '<TD VALIGN="TOP" ALIGN="left">' SKIP.


    IF can-do("ADD,UPDATE",lc-mode)
    then {&out} htmlib-Select("amanu",lc-list-code,lc-list-desc,
                 lc-amanu) skip.
    else {&out} html-encode(lc-amanu) "&nbsp" 
         html-encode(
             DYNAMIC-FUNCTION("com-GenTabDesc",
                          customer.CompanyCode, "Asset.Manu", 
                          lc-amanu)

             ).

    {&out} '</TD></TR>' skip. 

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("model",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Model")
            else htmlib-SideLabel("Model"))
            '</TD>' .
    
    if can-do("add,update",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("model",20,lc-model) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-model),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("serial",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Serial")
            else htmlib-SideLabel("Serial"))
            '</TD>' .
    
    if can-do("add,update",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("serial",20,lc-serial) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-serial),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("location",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Location")
            else htmlib-SideLabel("Location"))
            '</TD>' .
    
    if can-do("add,update",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("location",20,lc-location) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-location),'left')
           skip.
    {&out} '</TR>' skip.

    RUN com-GenTabSelect ( customer.CompanyCode, "Asset.Status", 
                           OUTPUT lc-list-code,
                           OUTPUT lc-list-desc ).

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("astatus",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Status")
            else htmlib-SideLabel("Status"))
            '</TD>'
             '<TD VALIGN="TOP" ALIGN="left">' SKIP.

    
    IF can-do("ADD,UPDATE",lc-mode)
    then {&out} htmlib-Select("astatus",lc-list-code,lc-list-desc,
                lc-astatus) skip.
    else {&out} html-encode(lc-astatus) "&nbsp" 
        html-encode(
            DYNAMIC-FUNCTION("com-GenTabDesc",
                         customer.CompanyCode, "Asset.Status", 
                         lc-astatus)

            ).

    {&out} '</TD></TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           (if lookup("purchased",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Purchase Date")
           else htmlib-SideLabel("Purchase Date"))
           '</TD>'
           '<TD VALIGN="TOP" ALIGN="left">'.
    
    IF can-do("ADD,UPDATE",lc-mode)
    THEN {&out}
        /*
            htmlib-InputField("purchased",10,lc-purchased) 
         htmlib-CalendarLink("purchased") */
         htmlib-CalendarInputField("purchased",10,lc-purchased) 
            htmlib-CalendarLink("purchased")

           '</TD>' skip.
    ELSE
    {&out} htmlib-TableField(html-encode(lc-purchased),'left')
           skip.
    {&out} '</TR>' skip.

     {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("cost",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Cost")
            else htmlib-SideLabel("Cost"))
            '</TD>' .
    
    if can-do("add,update",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("cost",15,lc-cost) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-cost),'left')
           skip.
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          (if lookup("longdescription",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("Details")
          else htmlib-SideLabel("Details"))
          '</TD>' SKIP.


     if can-do("add,update",lc-mode) then
     {&out} 
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-TextArea("details",lc-details,5,60)
          '</TD>' skip
           skip.
     ELSE
    {&out} htmlib-TableField(replace(html-encode(lc-details),"~n","<br>"),'left')
           skip.


  
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
         
    {&out} htmlib-CalendarScript("purchased") skip.

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

