&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mn/menupanel.p
    
    Purpose:        Left Panel Menu   
    
    Notes:
    
    
    When        Who         What
    22/04/2006  phoski      Initial - replace old leftpanel.p  
    26/06/2006  phoski      Prototype    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

def var lc-user as char no-undo.
def var lc-pass as char no-undo.

def var li-item as int no-undo.


def temp-table tt-menu no-undo
    field ItemNo        as int
    field Level         as int
    field Description   as char 
    field ObjURL        as char
    field ObjTarget     as char
    field ObjType       as char
    field AltInfo       as char
    field aTitle        as char 
    field OverDue       as log

    index ItemNo is primary unique
            ItemNo.

def var lc-system as char no-undo.
def var lc-image  as char no-undo.
def var lc-company as char no-undo.

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

     assign lc-system = htmlib-GetAttr("system","systemname")
            lc-image  = htmlib-GetAttr("system","companylogo")
            lc-company = htmlib-GetAttr("system","companyname").

    RUN outputHeader.
    
    /* {&out} htmlib-Header("leftpanel") skip. */
    {&out}
         '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">' skip "~n" +
         '<HTML>' skip
         '<HEAD>' skip
         '<meta http-equiv="Cache-Control" content="No-Cache">' skip
         '<meta http-equiv="Pragma"        content="No-Cache">' skip
         '<meta http-equiv="Expires"       content="0">' skip
         '<TITLE></TITLE>' skip
         DYNAMIC-FUNCTION('htmlib-StyleSheet':U) skip.
    {&out} '<link rel="stylesheet" href="/style/menu.css" type="text/css">' skip.

    
    {&out}
        '<script language="JavaScript" src="/scripts/js/standard.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/menu.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/prototype.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/scriptaculous.js"></script>' skip
        .


    find webuser where webuser.loginid = lc-user no-lock no-error.
    if avail webuser then
    do:

        {&out} 
            '<script>' skip
            'function GetAlerts(target) ~{' skip
            '   var url = "' appurl '/mn/ajax/menu.p?user=' webuser.LoginID '"' skip
            '   var myAjax = new Ajax.PeriodicalUpdater( target, url, ~{evalScripts: true, asynchronous:true, frequency:28800 ~});' skip
            '~}' skip.

        if dynamic-function("com-QuickView",webuser.LoginID)
        then {&out}
                'function SuperUser(target) ~{' skip
                '   var url = "' appurl '/mn/ajax/superuser.p?user=' webuser.LoginID '"' skip
                '   var myAjax = new Ajax.PeriodicalUpdater( target, url, ~{evalScripts: true, asynchronous:true, frequency:28800 ~});' skip
                '~}' skip.
        {&out}
            'function InitialisePage() ~{' skip
            '  GetAlerts("ajaxmenu");' skip.
        

        if dynamic-function("com-QuickView",webuser.LoginID)
        then {&out} '  SuperUser("superuser");' skip.

        {&out}
            '~}' skip
            '</script>' skip.   

        {&out}
            '</head>' skip '<body onLoad="InitialisePage()">'.

        
        /* window.location.reload(false); */

        {&out} '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="tlink" style="border:none;" href="javascript:window.location.reload(true);">Refresh Menu</a><br>&nbsp;' SKIP.

        {&out} '<div id="ajaxmenu"></div>' skip.
        
        if dynamic-function("com-QuickView",webuser.LoginID)
        then {&out} '<div id="superuser"></div>' skip.

    end.
    else {&out}
            '</head>' skip '<body>'.
    
   
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

