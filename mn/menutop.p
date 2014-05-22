&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mn/menutop.p
    
    Purpose:        Menu Top Panel            
    
    Notes:
    
    
    When        Who         What
    23/04/2006  phoski      Various
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-user as char no-undo.

def temp-table tt-menu no-undo
    field ItemNo        as int
    field Level         as int
    field Description   as char 
    field ObjURL        as char
    field ObjTarget     as char
    field ObjType       as char
    field MenuLocation  as char
    field TopOrder      as int

    index ItemNo is primary unique
            ItemNo.

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

&IF DEFINED(EXCLUDE-ip-BeginMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BeginMenu Procedure 
PROCEDURE ip-BeginMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find webuser where webuser.loginid = lc-user no-lock no-error.

    if not avail webUser then return.

    find company of webuser no-lock no-error.


    
    {&OUT}
    '<div id="topcontent"><div id="topheader">':U SKIP
   
    '<img src="/images/topbar/' 
        lc(webUser.companyCode) '/small-logo.gif" style="float: left;">' skip '&nbsp;' 
        html-encode(Company.Name) ' - Help Desk':U SKIP
    '   </div>':U SKIP
    '   <div id="topbarmenu">':U SKIP.


    {&out}
       '<span class="topbarinfo">&nbsp;User: ' html-encode(webuser.name).
     
    
    if com-IsCustomer(webuser.CompanyCode,webuser.LoginID) then
    do:
        find customer where customer.CompanyCode = webuser.CompanyCode
                        and customer.AccountNumber = webuser.AccountNumber
                        no-lock no-error.
        if avail customer
        then {&out} html-encode(' - ' + customer.name).
    end.
    {&out} '</span>'
        .

    {&out} '               <span id="topbaritem">':U SKIP.


    if avail webuser then
    do:
        RUN mnlib-BuildMenu ( webuser.pagename, 1 ).
        RUN ip-BuildLinks.
    end.

    {&OUT}
    '&nbsp;</span></div></div>':U SKIP.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-BuildLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildLinks Procedure 
PROCEDURE ip-BuildLinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var lc-htm-2 as char initial
    '<a href="&1" target="mainwindow" title="&2">&3</a>' 
                no-undo.
    def var lc-out       as char no-undo.
    

    for each tt-menu exclusive-lock
        by tt-menu.TopOrder:
        if tt-menu.ObjType <> 'WS' then next.
        
        if can-do("B,T",tt-menu.MenuLocation) = false then next.
        assign tt-menu.ObjURL = appurl + '/' + tt-menu.ObjURL.
        
        
        assign lc-out = substitute(lc-htm-2,tt-menu.Objurl,html-encode(tt-menu.description),html-encode(tt-menu.description)).
        
        {&out} lc-out skip.
  
    end.

    if webuser.UserClass <> "CUSTOMER"
    and webuser.AccessSMS 
    then {&out} '<a href="' appurl '/sys/sms-send.p" target="mainwindow">SMS</a>'.

    {&out} '<a href="' appurl "/mn/login.p?logoff=yes&company=" webuser.Company '" target="_top" title="Log off helpdesk">Log Off</a>'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-JScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-JScript Procedure 
PROCEDURE ip-JScript :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Style) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Style Procedure 
PROCEDURE ip-Style :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

return.
/*
    {&out} 

'<style>' skip
'body ~{ margin-top: 0px;' skip 
        'margin-left: 0px;' skip 
        'margin-right: 0px; ~}' skip

'</style>' skip.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mnlib-BuildMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mnlib-BuildMenu Procedure 
PROCEDURE mnlib-BuildMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pc-menu     as char no-undo.
    def input param pi-level    as int  no-undo.

    def buffer b-menu for webmhead.
    def buffer b2-menu for webmhead.
    def buffer b-line for webmline.
    def buffer b2-line for webmline.
    def buffer b-object for webobject.

    def var li-ItemNo       as int no-undo.


    find b-menu where b-menu.pagename = pc-menu no-lock no-error.

    if not avail b-menu then return.

    for each b-line of b-menu no-lock:
        if b-line.linktype = 'page' then
        do:
            find b2-menu where b2-menu.pagename = b-line.linkobject
                 no-lock no-error.
            if not avail b2-menu then next.
            find first b2-line of b2-menu no-lock no-error.
            if not avail b2-line then next.
        end.
        else
        do:
            find b-object where b-object.objectid = b-line.linkobject
                          no-lock no-error.
            if not avail b-object then
            do: 
               
                next.
            end.
        end.
        find last tt-menu no-lock no-error.
        assign li-itemno = if avail tt-menu 
                           then tt-menu.itemno + 1
                           else 1.
        if b-line.linktype = 'Page' then
        do:
            create tt-menu.
            assign tt-menu.ItemNo = li-itemno
                   tt-menu.Level  = pi-Level
                   tt-menu.Description  = b2-menu.PageDesc.
            run mnlib-BuildMenu( b2-menu.PageName, pi-level + 1 ).

        end.
        else
        do:
            create tt-menu.
            assign tt-menu.ItemNo = li-itemno
                   tt-menu.Level  = pi-Level
                   tt-menu.Description = b-object.Description
                   tt-menu.ObjURL      = b-object.ObjURL
                   tt-menu.ObjTarget   = b-object.ObjTarget
                   tt-menu.ObjType     = b-object.ObjType
                   tt-menu.MenuLocation = b-object.MenuLocation
                   tt-menu.TopOrder     = b-object.TopOrder.

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
  
    def var lc-value as char no-undo.



    assign lc-value = get-cookie("ExtranetUser").

    assign lc-user = htmlib-DecodeUser(lc-value).

    RUN outputHeader.
  
    {&out}
        '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">' skip 
    '<HTML>' 
         '<HEAD>' 
         '<meta http-equiv="Cache-Control" content="No-Cache">' 
         '<meta http-equiv="Pragma"        content="No-Cache">'
         '<meta http-equiv="Expires"       content="0">' 
         '<TITLE>' + "menutop" + '</TITLE>' 
         DYNAMIC-FUNCTION('htmlib-StyleSheet':U).

    RUN ip-Style.
    RUN ip-JScript.
    {&out}
        
        '<script language="JavaScript" src="/scripts/js/standard.js"></script>' +
        '</HEAD>' +
        '<BODY>'.

    RUN ip-BeginMenu.

    {&OUT} htmlib-Footer() skip.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

