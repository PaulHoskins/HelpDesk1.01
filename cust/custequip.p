&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        cust/custequip.p
    
    Purpose:        Customer Maintenance - Equipment Browse        
    
    Notes:
    
    
    When        Who         What
    22/04/2006  phoski      Initial
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
def var lc-customer     as char no-undo.
def var lc-returnback   as char no-undo.
def var lc-link-url     as char no-undo.
def var lc-temp         as char no-undo.

def buffer Customer for Customer.
def buffer ivClass  for ivClass.
def buffer ivSub    for ivSub.
def buffer b-query for CustIv.
def buffer b-search for CustIv.


def query q for b-query scrolling.

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
  
    {lib/checkloggedin.i}

   
    assign lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation").
    
    assign lc-parameters = "search=" + lc-search +
                           "&firstrow=" + lc-firstrow + 
                           "&lastrow=" + lc-lastrow.

    assign
        lc-customer = get-value("customer")
        lc-returnback = get-value("returnback").
    
    assign lc-char = htmlib-GetAttr('system','MNTNoLinesDown').
    
    assign li-max-lines = int(lc-char) no-error.
    if error-status:error
    or li-max-lines < 1
    or li-max-lines = ? then li-max-lines = 12.

    find customer
        where rowid(customer) = to-rowid(lc-customer) no-lock no-error.

    lc-link-url = appurl + '/cust/cust.p' + 
                                  '?firstrow=' + lc-returnback + 
                                  '&navigation=refresh' +
                                  '&time=' + string(time).

    RUN outputHeader.
    
    {&out} htmlib-Header("Maintain Customer Inventory") skip.

   
    {&out} htmlib-JScript-Maintenance() skip.

    {&out} htmlib-StartForm("mainform","post", appurl + '/cust/custequip.p' ) skip.

    {&out} htmlib-ProgramTitle("Maintain Customer Inventory - " + 
                               customer.name) skip.
    
    {&out} htmlib-TextLink("Back",lc-link-url) '<BR><BR>' skip.

    {&out}
            tbar-Begin(
                tbar-Find(appurl + "/cust/custequip.p")
                )
            tbar-Link("add",?,appurl + '/cust/custequipmnt.p',"customer=" +
                      lc-customer + "&returnback=" + lc-returnback)
            tbar-BeginOption()
            tbar-Link("view",?,"off",lc-link-otherp)
            tbar-Link("update",?,"off",lc-link-otherp)
            tbar-Link("delete",?,"off",lc-link-otherp)
            tbar-EndOption()
            tbar-End().

    {&out} skip
           htmlib-StartMntTable().

    {&out}
            htmlib-TableHeading(
            "Inventory|Reference"
            ) skip.


    open query q for each b-query no-lock
        of customer.

    get first q no-lock.

    if lc-navigation = "nextpage" then
    do:
        reposition q to rowid to-rowid(lc-lastrow) no-error.
        if error-status:error = false then
        do:
            get next q no-lock.
            get next q no-lock.
            if not avail b-query then get first q.
        end.
    end.
    else
    if lc-navigation = "prevpage" then
    do:
        reposition q to rowid to-rowid(lc-firstrow) no-error.
        if error-status:error = false then
        do:
            get next q no-lock.
            reposition q backwards li-max-lines + 1.
            get next q no-lock.
            if not avail b-query then get first q.
        end.
    end.
    else
    if lc-navigation = "search" then
    do:
        find first b-search
             where b-search.CompanyCode = lc-global-company
             and b-search.accountnumber = customer.AccountNumber
             and b-search.Ref >= lc-Search no-lock no-error.
        if avail b-search then
        do:
            reposition q to rowid rowid(b-search) no-error.
            get next q no-lock.
        end.
        else assign lc-smessage = "Your search found no records, displaying all".
    end.
    else
    if lc-navigation = "refresh" then
    do:
        reposition q to rowid to-rowid(lc-firstrow) no-error.
        if error-status:error = false then
        do:
            get next q no-lock.
            if not avail b-query then get first q.
        end.  
        else get first q.
    end.

    assign li-count = 0
           lr-first-row = ?
           lr-last-row  = ?.

    repeat while avail b-query:
   
        
        assign lc-rowid = string(rowid(b-query)).
        
        assign li-count = li-count + 1.
        if lr-first-row = ?
        then assign lr-first-row = rowid(b-query).
        assign lr-last-row = rowid(b-query).
        
        assign lc-link-otherp = 'search=' + lc-search +
                                '&firstrow=' + string(lr-first-row) +
                                '&customer=' + lc-customer + 
                                '&returnback=' + lc-returnback.

        assign lc-temp = "".

        find ivSub of b-query no-lock no-error.
        if avail ivSub then
        do:
            find ivClass of ivSub no-lock no-error.
            if avail ivClass 
            then assign lc-temp = ivClass.name + " - " + ivSub.name.
        end.

        {&out}
            skip
            tbar-tr(rowid(b-query))
            skip

            htmlib-MntTableField(html-encode(lc-temp),'left')
            htmlib-MntTableField(html-encode(b-query.ref),'left')
            tbar-BeginHidden(rowid(b-query))
                tbar-Link("view",rowid(b-query),appurl + '/cust/custequipmnt.p',lc-link-otherp)
                tbar-Link("update",rowid(b-query),appurl + '/cust/custequipmnt.p',lc-link-otherp)
                tbar-Link("delete",rowid(b-query),
                          if DYNAMIC-FUNCTION('com-CanDelete':U,lc-user,"customerequip",rowid(b-query))
                          then ( appurl + '/cust/custequipmnt.p') else "off",
                          lc-link-otherp)
                
            tbar-EndHidden()
            '</tr>' skip.

       

        if li-count = li-max-lines then leave.

        get next q no-lock.
            
    end.

    if li-count < li-max-lines then
    do:
        {&out} skip htmlib-BlankTableLines(li-max-lines - li-count) skip.
    end.

    {&out} skip 
           htmlib-EndTable()
           skip.

    {lib/navpanel.i "cust/custequip.p"}

    {&out} skip
           htmlib-Hidden("firstrow", string(lr-first-row)) skip
           htmlib-Hidden("lastrow", string(lr-last-row)) skip
           htmlib-Hidden("customer",lc-customer) skip
           htmlib-Hidden("returnback",lc-returnback)
           skip.

    {&out} 
        '<div id="urlinfo">|customer=' lc-customer "|returnback=" lc-returnback '</div>'.

    {&out} htmlib-EndForm().

    
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

