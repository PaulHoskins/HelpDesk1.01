&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webuser.p
    
    Purpose:        User Maintenance - Browser   
    
    Notes:
    
    
    When        Who         What
    09/04/2006  phoski      Contractor link to accounts
    10/04/2006  phoski      Company Code
    11/04/2006  phoski      Show customer for CUSTOMER type users
    13/06/2014  phoski      Various for UX

***********************************************************************/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

def var lc-rowid as char no-undo.


def var li-max-lines as int initial 12 no-undo.
def var lr-first-row as rowid no-undo.
def var lr-last-row  as rowid no-undo.
def var li-count     as int   no-undo.
def var ll-prev      as log   no-undo.
def var ll-next      as log   no-undo.
def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.
def var lc-smessage     as char no-undo.
def var lc-link-otherp  as char no-undo.
def var lc-char         as char no-undo.
def var lc-nopass       as char no-undo.
DEF VAR lc-selacc       AS CHAR NO-UNDO.




def buffer b-query for webuser.
def buffer b-search for webuser.

/*
def query q for b-query scrolling.
*/

def var lc-QPhrase  as char    no-undo.
def var vhLBuffer       as handle  no-undo.
def var vhLQuery        as handle  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnToolbarAccountSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnToolbarAccountSelection Procedure 
FUNCTION fnToolbarAccountSelection RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

&IF DEFINED(EXCLUDE-ip-ExportJScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportJScript Procedure 
PROCEDURE ip-ExportJScript :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{&out}
        '<script language="JavaScript" src="/scripts/js/menu.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/prototype.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/scriptaculous.js"></script>' skip
        .

    {&out} skip
            '<script language="JavaScript" src="/scripts/js/hidedisplay.js"></script>' skip.

    {&out} skip 
          '<script language="JavaScript">' skip.

    {&out} skip
        'function OptionChange(obj) ~{' skip
        '   SubmitThePage("selection");' SKIP
        '~}' skip.

    {&out} skip
           '</script>' skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-navigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-navigate Procedure 
PROCEDURE ip-navigate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    if lc-navigation = "nextpage" then
    do:
        vhLQuery:reposition-to-rowid(to-rowid(lc-lastrow)) .
        if error-status:error = false then
        do:
          vhLQuery:get-next(no-lock).
          vhLQuery:get-next(no-lock).
    
          if not avail b-query then vhLQuery:get-first(no-lock).
      end.
    end.
    else
    if lc-navigation = "prevpage" then
    do:
      vhLQuery:reposition-to-rowid(to-rowid(lc-firstrow)) no-error.
      if error-status:error = false then
      do:
        vhLQuery:get-next(no-lock).
         vhLQuery:reposition-backwards(li-max-lines + 1). 
         vhLQuery:get-next(no-lock).
        if not avail b-query then vhLQuery:get-first(no-lock).
    end.
    end.
    else
    if lc-navigation = "refresh" then
    do:
        vhLQuery:reposition-to-rowid(to-rowid(lc-firstrow)) no-error.
        if error-status:error = false then
        do:
          vhLQuery:get-next(no-lock).
           if not avail b-query then vhLQuery:get-first(no-lock).
       end.  
       else vhLQuery:get-first(no-lock).
    end.
    else 
    if lc-navigation = "lastpage" then
    do:
      vhLQuery:get-last(no-lock).
      vhLQuery:reposition-backwards(li-max-lines).
      vhLQuery:get-next(no-lock).
     if not avail b-query then vhLQuery:get-first(no-lock).
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
  
    def var lc-CustomerInfo     as char         no-undo.

    {lib/checkloggedin.i}

    assign lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation")
           lc-selacc     = get-value("selacc").
    
    assign lc-parameters = "search=" + lc-search +
                           "&firstrow=" + lc-firstrow + 
                           "&lastrow=" + lc-lastrow +
                           "&selacc=" + lc-selacc.

    
    ASSIGN
        lc-link-otherp = lc-parameters.

    
    assign lc-char = htmlib-GetAttr('system','MNTNoLinesDown').
    
    assign li-max-lines = int(lc-char) no-error.
    if error-status:error
    or li-max-lines < 1
    or li-max-lines = ? then li-max-lines = 12.

    RUN outputHeader.
    
    {&out} htmlib-Header("Maintain Users") skip.

    {&out} htmlib-JScript-Maintenance() skip.
    RUN ip-ExportJScript.

    {&out} htmlib-StartForm("mainform","post", appurl + '/sys/webuser.p' ) skip.

    {&out} htmlib-ProgramTitle("Maintain Users") skip
           htmlib-hidden("submitsource","") skip.
    
    {&out}
            tbar-Begin(
                DYNAMIC-FUNCTION('fnToolbarAccountSelection':U) 
                + 
                tbar-FindLabel(appurl + "/sys/webuser.p","Find Name")
                )
            tbar-Link("add",?,appurl + '/' + "sys/webusermnt.p",lc-link-otherp)
            tbar-BeginOption()
            tbar-Link("view",?,"off",lc-link-otherp)
            tbar-Link("update",?,"off",lc-link-otherp)
            tbar-Link("delete",?,"off",lc-link-otherp)
            tbar-Link("genpassword",?,"off",lc-link-otherp)
            tbar-Link("contaccess",?,"off",lc-link-otherp)
            tbar-Link("conttime",?,"off",lc-link-otherp)
            tbar-EndOption()
            tbar-End().

    {&out} skip
           htmlib-StartMntTable().

    {&out}
            htmlib-TableHeading(
            "User Name^left|Name^left|Customer|Email^left|Disabled?"
            ) skip.

    lc-QPhrase = 
        "for each b-query NO-LOCK where b-query.CompanyCode = '" + string(lc-Global-Company) + "'".

    IF lc-selacc <> "" THEN
    DO:
        IF lc-selacc = "INTERNAL"
        THEN ASSIGN 
                lc-qPhrase = lc-qphrase + " and b-query.AccountNumber = ''".
        ELSE
        IF lc-selacc = "ALLC"
        THEN ASSIGN 
                lc-qPhrase = lc-qphrase + " and b-query.AccountNumber > ''".
        ELSE ASSIGN 
                lc-qPhrase = lc-qphrase + " and b-query.AccountNumber = '" + lc-selacc + "'".
    END.


     
    IF lc-search <> "" THEN
    DO:
        assign
            lc-qPhrase = lc-qphrase + " and b-query.name contains '" + lc-search + "'".
    END.

    lc-QPhrase = lc-QPhrase + ' INDEXED-REPOSITION'.
    
    create query vhLQuery.

    vhLBuffer = buffer b-query:handle.

    vhLQuery:set-buffers(vhLBuffer).
    vhLQuery:query-prepare(lc-QPhrase).
    vhLQuery:QUERY-OPEN().


    vhLQuery:GET-FIRST(no-lock).

    run ip-navigate.


    assign li-count = 0
           lr-first-row = ?
           lr-last-row  = ?.

     repeat while vhLBuffer:available: 

        
        assign
            lc-CustomerInfo = dynamic-function("com-UsersCompany",
                                               b-query.LoginID).
        
        if lc-CustomerInfo <> ""
        then assign lc-customerInfo = b-query.AccountNumber + " " +
                                      lc-CustomerInfo.

        assign lc-rowid = string(rowid(b-query)).
        
        assign li-count = li-count + 1.
        if lr-first-row = ?
        then assign lr-first-row = rowid(b-query).
        assign lr-last-row = rowid(b-query).
        
        assign lc-link-otherp = 'search=' + lc-search +
                                '&firstrow=' + string(lr-first-row).

        assign lc-nopass = if b-query.passwd = ""
                           or b-query.passwd = ?
                           then " (No password)"
                           else "".
        {&out}
            skip
            tbar-tr(rowid(b-query))
            skip
            htmlib-MntTableField(html-encode(b-query.loginid),'left')
            htmlib-MntTableField(html-encode(b-query.name),'left')
            htmlib-MntTableField(html-encode(lc-CustomerInfo),'left')

            htmlib-MntTableField(html-encode(b-query.email),'left')
            htmlib-MntTableField(html-encode((if b-query.disabled = true
                                          then 'Yes' else 'No') + lc-nopass),'left') skip

            tbar-BeginHidden(rowid(b-query))
                tbar-Link("view",rowid(b-query),appurl + '/' + "sys/webusermnt.p",lc-link-otherp)
                tbar-Link("update",rowid(b-query),appurl + '/' + "sys/webusermnt.p",lc-link-otherp)
                tbar-Link("delete",rowid(b-query),
                          if DYNAMIC-FUNCTION('com-CanDelete':U,lc-user,"webuser",rowid(b-query))
                          then ( appurl + '/' + "sys/webusermnt.p") else "off",
                          lc-link-otherp)
                tbar-Link("genpassword",rowid(b-query),appurl + '/' + "sys/webusergen.p","customer=" + 
                                                string(rowid(b-query)) 
                                                )
                tbar-Link("contaccess",rowid(b-query),
                              if b-query.UserClass = "CONTRACT"
                              then ( appurl + '/' + "sys/webcontaccess.p") else "off",lc-link-otherp)

                tbar-Link("conttime",rowid(b-query),
                              if b-query.UserClass = "INTERNAL"
                              then ( appurl + '/' + "sys/webconttime.p") else "off",lc-link-otherp)
            tbar-EndHidden()
            '</tr>' skip.

       

        if li-count = li-max-lines then leave.


       
        vhLQuery:get-next(no-lock). /* 3933  */

            
    end.

    if li-count < li-max-lines then
    do:
        {&out} skip htmlib-BlankTableLines(li-max-lines - li-count) skip.
    end.

    {&out} skip 
           htmlib-EndTable()
           skip.

   
    {&out} htmlib-StartPanel() 
            skip.


    {&out}  '<tr><td align="left">'.


    if lr-first-row <> ? then
    do:
        vhLQuery:GET-FIRST(no-lock). 
       
        if rowid(b-query) = lr-first-row 
        then assign ll-prev = false.
        else assign ll-prev = true.

        
        vhLQuery:get-last(no-lock). 

        if rowid(b-query) = lr-last-row
        then assign ll-next = false.
        else assign ll-next = true.

        if ll-prev 
        then {&out} htmlib-MntButton(appurl + '/' + "sys/webuser.p","PrevPage","Prev Page").


        if ll-next 
        then {&out} htmlib-MntButton(appurl + '/' + "sys/webuser.p","NextPage","Next Page").

        if not ll-prev
        and not ll-next 
        then {&out} "&nbsp;".


    end.
    else {&out} "&nbsp;".

    {&out} '</td><td align="right">' htmlib-ErrorMessage(lc-smessage)
          '</td></tr>'.

    {&out} htmlib-EndPanel().

     
    {&out} skip
           htmlib-Hidden("firstrow", string(lr-first-row)) skip
           htmlib-Hidden("lastrow", string(lr-last-row)) skip
           skip.

    
    {&out} htmlib-EndForm().

    
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnToolbarAccountSelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnToolbarAccountSelection Procedure 
FUNCTION fnToolbarAccountSelection RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    
    DEF VAR lc-return       AS CHAR     NO-UNDO.

    DEF VAR lc-codes        AS CHAR     NO-UNDO.
    DEF VAR lc-names        AS CHAR     NO-UNDO.
    DEF VAR lc-this         AS CHAR     NO-UNDO.

    DEF BUFFER customer FOR customer.

    ASSIGN
        lc-codes = "|INTERNAL|ALLC"
        lc-names = "All Users|Internal Users|All Customer Users"
        lc-this  = get-value("selacc").
   
    FOR EACH customer NO-LOCK
            WHERE customer.companyCode = lc-global-company
        BY customer.NAME:
        ASSIGN lc-codes = lc-codes + "|" + customer.AccountNumber
               lc-names = lc-names + "|" + customer.NAME.

    END.

    lc-return =  htmlib-SelectJS(
            "selacc",
            'OptionChange(this)',
            lc-codes,
            lc-names,
            lc-this
            ).



    lc-return = "<b>Account/User Type:</b>" + lc-return + "&nbsp;".

    RETURN lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

