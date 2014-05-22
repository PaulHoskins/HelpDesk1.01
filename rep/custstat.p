&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/custstat.p
    
    Purpose:        Customer Statements - Web Page
    
    Notes:
    
    
    When        Who         What
    26/07/2006  phoski      Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.
def var lc-title as char no-undo.


def var lc-lodate       as char no-undo.
def var lc-hidate       as char no-undo.
def var lc-test         as char no-undo.
def var lc-pdf          as char no-undo.
def var lc-avail        as char no-undo.

{lib/maillib.i}

def temp-table tt       no-undo like Customer.

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
{lib/maillib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-CustomerTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CustomerTable Procedure 
PROCEDURE ip-CustomerTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def buffer b-query for customer.

    def var li-count        as int              no-undo.
    def var li-cols         as int initial 4    no-undo.
    def var lc-default      as char
        initial "Statement?^left" no-undo.
    def var lc-header       as char             no-undo.
   
    def var lc-name         as char             no-undo.
    def var lc-value        as char             no-undo.
    
    do li-count = 1 to li-cols:
        if li-count = 1
        then lc-header = lc-default.
        else lc-header = lc-header + "|" + lc-default.
    end.

    {&out} skip
           htmlib-StartFieldSet("Select Customers") 
           htmlib-StartMntTable().

    {&out}
            htmlib-TableHeading(
            lc-header
            ) skip.


    assign li-count = 0
           lc-avail = "".

    for each b-query no-lock
        where b-query.CompanyCode   = lc-Global-Company
          and b-query.StatementEmail <> ""
          by b-query.name
         :

        assign
            lc-name = "tog" + string(rowid(b-query)).

        if request_method = "get" then set-user-field(lc-name,"on").

        assign
            lc-value = get-value(lc-name).
        
        if lc-avail = ""
        then assign lc-avail = lc-name.
        else assign lc-avail = lc-avail + "|" + lc-name.

        if li-count = 0 then
        do:
            {&out} '<tr>' skip.
        end.

        {&out}
            '<td>' 

                htmlib-CheckBox(lc-name, if lc-value = 'on'
                                        then true else false) 

                    '&nbsp;'
                    b-query.name
            '</td>' skip.

        assign li-count = li-count + 1.
        if li-count = li-cols then
        do:
            assign li-count = 0.
            {&out} '</tr>' skip.
        end.

    end.
    if li-count > 0 then {&out} '</tr>' skip.

    {&out} skip 
           htmlib-EndTable()
           htmlib-EndFieldSet() 
           skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-ip-ProcessReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ProcessReport Procedure 
PROCEDURE ip-ProcessReport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each tt no-lock:

        run prince/custstat.p 
        ( lc-global-user,
          tt.CompanyCode,
          tt.AccountNumber,
          date(lc-lodate),
          date(lc-hidate),
          output lc-pdf ).
    
        lc-pdf = search(lc-pdf).

        if lc-pdf <> "" 
        then mlib-SendAttEmail 
        ( lc-global-company,
          "",
          "HelpDesk Statement for " + tt.name,
          "Please find attached your statement covering the period "
          + string(date(lc-lodate),"99/99/9999") + " to " +
          string(date(lc-hidate),'99/99/9999'),
          ( if lc-test = "on" then webuser.email else tt.StatementEmail),
          "",
          "",
          lc-pdf ).
                


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


    def buffer Customer for Customer.
        
    def var ld-date     as date     no-undo.
    def var li-loop     as int      no-undo.
    def var lc-rowid    as char     no-undo.

    assign
        ld-date = date(lc-lodate) no-error.
    if error-status:error 
    or ld-date = ?
    then run htmlib-AddErrorMessage(
                'lodate', 
                'The date is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    assign
        ld-date = date(lc-hidate) no-error.
    if error-status:error 
    or ld-date = ?
    then run htmlib-AddErrorMessage(
                'hidate', 
                'The date is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    if pc-error-field <> "" then return.

    if date(lc-lodate) > date(lc-hidate) then
    do:
        run htmlib-AddErrorMessage(
                'hidate', 
                'The date range is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
        return.
    end.
    empty temp-table tt.

    do li-loop = 1 to num-entries(lc-avail,"|"):

        if get-value(entry(li-loop,lc-avail,"|")) <> "on" then next.

        assign
            lc-rowid = substr(entry(li-loop,lc-avail,"|"),4).

        find customer
            where rowid(customer) = to-rowid(lc-rowid) no-lock no-error.
        if not avail customer then next.

        find tt where tt.CompanyCode = customer.CompanyCode
                  and tt.AccountNumber = customer.AccountNumber no-lock no-error.
        if avail tt then
        do:
            message "duplicate = " lc-rowid li-loop lc-avail.
            next.
        end.
        create tt.
        buffer-copy customer to tt.
    end.

    find first tt no-lock no-error.

    if not avail tt then run htmlib-AddErrorMessage(
                'dummy', 
                'You must select one or more customers',
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

    find webuser where webuser.loginid = lc-user no-lock no-error.

    empty temp-table tt.

    if request_method = "POST" then
    do:
        
        assign
            lc-hidate = get-value("hidate")
            lc-lodate = get-value("lodate")
            lc-test = get-value("test")
            lc-avail = get-value("avail")
            .
        
        RUN ip-Validate( output lc-error-field,
                         output lc-error-msg ).

        if lc-error-msg = "" then
        do:
            RUN ip-ProcessReport.
            
        end.
    end.

  
    if request_method <> "post"
    then assign lc-hidate = string(today,"99/99/9999")
                lc-lodate = string(today - day(today) + 1,"99/99/9999")
                lc-test = "on"
                .

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle("Customer Statements") skip.


    
    {&out} htmlib-StartInputTable() skip.

   
    {&out} '<TR>'
            '<TD VALIGN="TOP" ALIGN="right">' 

            
            (if lookup("lodate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Statement From")
            else htmlib-SideLabel("Statement From"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("lodate",10,lc-lodate) 
            htmlib-CalendarLink("lodate")
            '</td>' skip
        
            '<TD VALIGN="TOP" ALIGN="right">' 

            
            (if lookup("hidate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("To")
            else htmlib-SideLabel("To"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("hidate",10,lc-hidate) 
            htmlib-CalendarLink("hidate")
            '</td>' skip
            
            '<TD VALIGN="TOP" ALIGN="right">&nbsp;' 
            (if lookup("test",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Test Statements To " + webuser.email + "?")
            else htmlib-SideLabel("Test Statements To " + webuser.email + "?"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
                htmlib-CheckBox("test", if lc-test = 'on'
                                        then true else false) 
            '</TD>'
        
            '</tr>' skip.

    {&out} htmlib-EndTable() skip.

    RUN ip-CustomerTable.

    if request_method = "post" and lc-error-msg = "" then
    do:
        {&out} '<p style="font-size: 12px;">Statements have been emailed to ' 
            (if lc-test = "on" then webuser.email else " the customers" )
            '</p>'.
    end.

    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.
    
    {&out} '<center>' htmlib-SubmitButton("submitform","Create Statements") 
               '</center>' skip.
    
         
    {&out} htmlib-Hidden("avail",lc-avail) skip.

    {&out} htmlib-EndForm() skip
          htmlib-CalendarScript("hidate")
          htmlib-CalendarScript("lodate") skip.


   
    {&out} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

