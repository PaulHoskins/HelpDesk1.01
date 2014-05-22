&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mn/leftpanel.p
    
    Purpose:        Left Panel Menu   
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      CompanyCode      
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

&IF DEFINED(EXCLUDE-ip-HeaderMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-HeaderMenu Procedure 
PROCEDURE ip-HeaderMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-NewMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-NewMenu Procedure 
PROCEDURE ip-NewMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    return.

/*
    for each tt-menu no-lock:
        if tt-menu.ObjType = "WS" then next.

        {&out} html-encode(tt-menu.description) '<br>' skip.

    end. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mnlib-BuildIssueMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mnlib-BuildIssueMenu Procedure 
PROCEDURE mnlib-BuildIssueMenu :
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
    def buffer b-user   for webuser.

    def var li-ItemNo       as int no-undo.
    def var lc-desc         as char no-undo.

    find b-user where b-user.loginid = lc-user no-lock no-error.

    if can-do("INTERNAL,CONTRACT",b-user.UserClass) then
    do:
        for each Issue no-lock
            where Issue.CompanyCode = b-user.CompanyCode,
            first WebStatus where WebStatus.CompanyCode = Issue.CompanyCode 
                              and WebStatus.StatusCode = Issue.StatusCode
                              and WebStatus.CompletedStatus = false

            break by Issue.AccountNumber
                  by Issue.IssueNumber desc:

            find Customer of Issue no-lock no-error.

            assign lc-desc = if avail customer then customer.name 
                             else "No Customer".

            if first-of(issue.AccountNumber) then
            do:
                find last tt-menu no-lock no-error.
                assign li-itemno = if avail tt-menu 
                               then tt-menu.itemno + 1
                               else 1.
                create tt-menu.
                assign tt-menu.ItemNo = li-itemno
                       tt-menu.Level  = pi-level
                       tt-menu.Description = lc-desc.
            end.
            find last tt-menu no-lock no-error.
            assign li-itemno = if avail tt-menu 
                               then tt-menu.itemno + 1
                               else 1.
            create tt-menu.
            assign tt-menu.itemno = li-itemno
                   tt-menu.Level =  pi-level + 1
                   tt-menu.Description = string(Issue.IssueNumber) + ' ' + 
                                         Issue.BriefDescription
                   tt-menu.ObjType = "WS"
                   tt-menu.ObjTarget = "mainwindow"
                   tt-menu.ObjURL  = "iss/issueframe.p?mode=update&return=home&rowid=" + string(rowid(issue)).
                   .
           
        end.
    end.
    else
    /*
    ***
    *** Customer 
    ***
    */
    do:
        for each Issue no-lock
            where Issue.CompanyCode = b-user.CompanyCode
              and Issue.AccountNumber = b-user.AccountNumber,
            first WebStatus where webStatus.CompanyCode = Issue.CompanyCode
                              and WebStatus.StatusCode = Issue.StatusCode
                              and WebStatus.CompletedStatus = false

            break by Issue.AreaCode
                  by Issue.IssueNumber desc:

            find WebIssArea of Issue no-lock no-error.

            assign lc-desc = if avail WebIssArea then WebIssArea.Description 
                             else "Not Known".

            if first-of(issue.AreaCode) then
            do:
                find last tt-menu no-lock no-error.
                assign li-itemno = if avail tt-menu 
                               then tt-menu.itemno + 1
                               else 1.
                create tt-menu.
                assign tt-menu.ItemNo = li-itemno
                       tt-menu.Level  = pi-level
                       tt-menu.Description = lc-desc.
            end.
            find last tt-menu no-lock no-error.
            assign li-itemno = if avail tt-menu 
                               then tt-menu.itemno + 1
                               else 1.
            create tt-menu.
            assign tt-menu.itemno = li-itemno
                   tt-menu.Level =  pi-level + 1
                   tt-menu.Description = string(Issue.IssueNumber) + ' ' + 
                                         Issue.BriefDescription
                   tt-menu.ObjType = "WS"
                   tt-menu.ObjTarget = "mainwindow"
                   tt-menu.ObjURL  = "iss/issueview.p?mode=update&return=home&rowid=" + string(rowid(issue)).
                   .
           
        end.
    end.
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
    def var ll-has-side     as log no-undo.

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
            assign ll-has-side = false.
            for each b2-line of b2-menu no-lock:
                find b-object where b-object.objectid = b2-line.linkobject no-lock no-error.
                if not avail b-object then next.
                if can-do("l,b",b-object.menulocation) = false then next.
                assign ll-has-side = true.
                leave.
            end.
            if not ll-has-side then next.
        end.
        else
        do:
            find b-object where b-object.objectid = b-line.linkobject
                          no-lock no-error.
            if not avail b-object then next.
            if can-do("l,b",b-object.menulocation) = false then next.
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
                   tt-menu.ObjType     = b-object.ObjType.

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

&IF DEFINED(EXCLUDE-p-BeginNexus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-BeginNexus Procedure 
PROCEDURE p-BeginNexus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&out}
    '<applet code=ryNexus width=' 
            htmlib-GetAttr("Nexus", "Width") 
            ' height='
            htmlib-GetAttr("Nexus","Height")
            ' archive="' htmlib-GetAttr("Nexus","ScriptDir") 'Nexus.jar" mayscript name="' 
        htmlib-GetAttr("Nexus","ScriptDir" )
                       'Nexus.jar">' skip
    '<param name=Copyright value="Nexus (c) 2001 Cool Focus [www.coolfocus.com]">' skip 
    '<param name=CabBase value="' htmlib-GetAttr("Nexus","ScriptDir") 'Nexus.cab">' skip.


    {&out} '<param name="Base" value="bdc01|b">' skip.
    {&out} '<param name="Key" value="48262995-17047773-8629527-30866493">' skip.

    {&out} '<param name="LoadBgColor" value="FFFFFF">' skip.
    {&out} htmlib-NexusParam("BgColor") skip.
    {&out} htmlib-NexusParam("TextColor") skip.
    {&out} htmlib-NexusParam("FocusButtonColor") skip.
    {&out} htmlib-NexusParam("FocusTextColor") skip.
    {&out} htmlib-NexusParam("SelectBorderColor") skip.
    {&out} htmlib-NexusParam("SelectFillColor") skip.
    {&out} htmlib-NexusParam("ButtonBgImage") skip.
    {&out} htmlib-NexusParam("SelectTextColor") skip.
    {&out} htmlib-NexusParam("LineColor") skip.
    {&out} htmlib-NexusParam("ToggleColor") skip.
    {&out} htmlib-NexusParam("ToggleFocusColor") skip.
    {&out} htmlib-NexusParam("KeepTextColor") skip.
    
    {&out} htmlib-NexusParam("Font") skip.
    {&out} htmlib-NexusParam("ExpandLinks") skip.
    {&out} htmlib-NexusParam("AutoCollapse") skip.
    {&out} htmlib-NexusParam("InheritColor") skip.
    {&out} htmlib-NexusParam("InitialSelect") skip.
    {&out} htmlib-NexusParam("InitialExpand") skip.
    {&out} htmlib-NexusParam("DefaultTarget") skip.
    {&out} htmlib-NexusParam("UseHandCursor") skip.
    
    {&out} '<!--Optional images for toggle buttons -->' skip.
    
    {&out} htmlib-NexusParam("ToggleExpand") skip.
    /* {&out} htmlib-NexusParam("ToggleExpandFocus") skip. */
    {&out} htmlib-NexusParam("ToggleCollapse") skip.
    /* {&out} htmlib-NexusParam("ToggleCollapseFocus") skip. */
    
    {&out} '<!--scrollbar-->' skip.
    
    {&out} htmlib-NexusParam("ScrollBaseColor") skip.
    {&out} htmlib-NexusParam("ScrollArrowColor") skip.
    {&out} htmlib-NexusParam("ScrollArrowFocusColor") skip.
    {&out} htmlib-NexusParam("ScrollArrowDisabledColor") skip.
    {&out} htmlib-NexusParam("Scroll3DButtons") skip.
    {&out} htmlib-NexusParam("ScrollAutohide") skip.
    {&out} htmlib-NexusParam("ScrollBgImage") skip.
    {&out} htmlib-NexusParam("ScrollStyle") skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-p-BuildItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-BuildItem Procedure 
PROCEDURE p-BuildItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input-output param pi-item as int no-undo.

    def input param pi-level as int no-undo.

    def input param pc-label as char no-undo.
    def input param pc-url   as char no-undo.
    def input param pc-target as char no-undo.


    assign pi-item = pi-item + 1.

    if pi-level > 0
    then assign pc-label = fill('*',pi-level) + pc-label.

    {&out} '<param name=Item' string(pi-item) ' value="' pc-label '">' skip.

    if pc-url = ""
    then pc-url = "$".

    if pc-url begins 'javascriptxxxxxxx':U 
    then {&out} '<param name=URL' string(pi-item) ' value=' pc-url '>' skip.
    else {&out} '<param name=URL' string(pi-item) ' value="' pc-url '">' skip.

    if pc-target <> ""
    then {&out} '<param name=Target' string(pi-item) ' value="' pc-target '">' skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-p-EndNexus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-EndNexus Procedure 
PROCEDURE p-EndNexus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    {&out} '</APPLET>' skip.

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

    RUN ip-HeaderMenu.
    {&out}
        '</HEAD>' skip
        '<script language="JavaScript" src="/scripts/js/standard.js"></script>' skip
        '<BODY class="normaltext">'.
   
    find webuser where webuser.loginid = lc-user no-lock no-error.

    if avail webuser then
    do:
        {&out} '<div class="inform"><fieldset>'
               "You are logged in as " + webuser.name
                '</fieldset></div>'.
    end.
    else {&out} '<p>no user</p>'.

    
    

    if avail webuser then
    do:
        RUN mnlib-BuildIssueMenu ( webuser.pagename, 1 ).
        RUN mnlib-BuildMenu ( webuser.pagename, 1 ).
    end.


    RUN ip-NewMenu.
    RUN p-BeginNexus.


    RUN p-BuildItem ( input-output li-item,
                      1,
                      'Your Issues',
                      appurl + '/mn/mainframe.p',
                      'mainwindow').


    for each tt-menu exclusive-lock:
        if tt-menu.ObjType = 'WS'
        then assign tt-menu.ObjURL = appurl + '/' + tt-menu.ObjURL.
        
        run p-BuildItem( input-output li-item,
                         tt-menu.Level,
                         tt-menu.Description,
                         tt-menu.ObjURL,
                         tt-menu.ObjTarget ).

    end.

    /*
    RUN p-BuildItem ( input-output li-item,
                      1,
                      'Contact ' + lc-company,
                      appurl + '/mn/contactsheet.p',
                      'mainwindow').
    */

    if avail webuser then
    RUN p-BuildItem ( input-output li-item,
                      1,
                      'Change Your Password',
                      appurl + '/mn/changepassword.p',
                      'mainwindow').

    RUN p-EndNexus.
    
    {&out} '</form>' skip.
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-xip-HTM-Header) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xip-HTM-Header Procedure 
PROCEDURE xip-HTM-Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pc-htm             as char no-undo.

    assign pc-htm = 
        '<meta http-equiv="refresh" content="300;url=' 
        + appurl + '/mn/leftpanel.p' +
        '"><META HTTP-EQUIV="Expires" CONTENT="0">'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

