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

DEFINE VARIABLE lc-error-field AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-error-mess  AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-user        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-pass        AS CHARACTER NO-UNDO.

DEFINE VARIABLE li-item        AS INTEGER   NO-UNDO.


DEFINE TEMP-TABLE tt-menu NO-UNDO
    FIELD ItemNo      AS INTEGER
    FIELD Level       AS INTEGER
    FIELD Description AS CHARACTER 
    FIELD ObjURL      AS CHARACTER
    FIELD ObjTarget   AS CHARACTER
    FIELD ObjType     AS CHARACTER

    INDEX ItemNo IS PRIMARY UNIQUE
    ItemNo.

DEFINE VARIABLE lc-system  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-image   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-company AS CHARACTER NO-UNDO.




/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no






/* *********************** Procedure Settings ************************ */



/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.15
         WIDTH              = 60.57.
/* END WINDOW DEFINITION */
                                                                        */

/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}



 




/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.



/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-HeaderMenu) = 0 &THEN

PROCEDURE ip-HeaderMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-NewMenu) = 0 &THEN

PROCEDURE ip-NewMenu :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    
    RETURN.

/*
    for each tt-menu no-lock:
        if tt-menu.ObjType = "WS" then next.

        {&out} html-encode(tt-menu.description) '<br>' skip.

    end. */
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-mnlib-BuildIssueMenu) = 0 &THEN

PROCEDURE mnlib-BuildIssueMenu :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pc-menu     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pi-level    AS INTEGER  NO-UNDO.

    DEFINE BUFFER b-menu FOR webmhead.
    DEFINE BUFFER b2-menu FOR webmhead.
    DEFINE BUFFER b-line FOR webmline.
    DEFINE BUFFER b2-line FOR webmline.
    DEFINE BUFFER b-object FOR webobject.
    DEFINE BUFFER b-user   FOR webuser.

    DEFINE VARIABLE li-ItemNo       AS INTEGER NO-UNDO.
    DEFINE VARIABLE lc-desc         AS CHARACTER NO-UNDO.

    FIND b-user WHERE b-user.loginid = lc-user NO-LOCK NO-ERROR.

    IF CAN-DO("INTERNAL,CONTRACT",b-user.UserClass) THEN
    DO:
        FOR EACH Issue NO-LOCK
            WHERE Issue.CompanyCode = b-user.CompanyCode,
            FIRST WebStatus WHERE WebStatus.CompanyCode = Issue.CompanyCode 
            AND WebStatus.StatusCode = Issue.StatusCode
            AND WebStatus.CompletedStatus = FALSE

            BREAK BY Issue.AccountNumber
            BY Issue.IssueNumber DESCENDING:

            FIND Customer OF Issue NO-LOCK NO-ERROR.

            ASSIGN 
                lc-desc = IF AVAILABLE customer THEN customer.name 
                             ELSE "No Customer".

            IF FIRST-OF(issue.AccountNumber) THEN
            DO:
                FIND LAST tt-menu NO-LOCK NO-ERROR.
                ASSIGN 
                    li-itemno = IF AVAILABLE tt-menu 
                               THEN tt-menu.itemno + 1
                               ELSE 1.
                CREATE tt-menu.
                ASSIGN 
                    tt-menu.ItemNo = li-itemno
                    tt-menu.Level  = pi-level
                    tt-menu.Description = lc-desc.
            END.
            FIND LAST tt-menu NO-LOCK NO-ERROR.
            ASSIGN 
                li-itemno = IF AVAILABLE tt-menu 
                               THEN tt-menu.itemno + 1
                               ELSE 1.
            CREATE tt-menu.
            ASSIGN 
                tt-menu.itemno = li-itemno
                tt-menu.Level =  pi-level + 1
                tt-menu.Description = STRING(Issue.IssueNumber) + ' ' + 
                                         Issue.BriefDescription
                tt-menu.ObjType = "WS"
                tt-menu.ObjTarget = "mainwindow"
                tt-menu.ObjURL  = "iss/issueframe.p?mode=update&return=home&rowid=" + string(ROWID(issue)).
            .
           
        END.
    END.
    ELSE
    /*
    ***
    *** Customer 
    ***
    */
    DO:
        FOR EACH Issue NO-LOCK
            WHERE Issue.CompanyCode = b-user.CompanyCode
            AND Issue.AccountNumber = b-user.AccountNumber,
            FIRST WebStatus WHERE webStatus.CompanyCode = Issue.CompanyCode
            AND WebStatus.StatusCode = Issue.StatusCode
            AND WebStatus.CompletedStatus = FALSE

            BREAK BY Issue.AreaCode
            BY Issue.IssueNumber DESCENDING:

            FIND WebIssArea OF Issue NO-LOCK NO-ERROR.

            ASSIGN 
                lc-desc = IF AVAILABLE WebIssArea THEN WebIssArea.Description 
                             ELSE "Not Known".

            IF FIRST-OF(issue.AreaCode) THEN
            DO:
                FIND LAST tt-menu NO-LOCK NO-ERROR.
                ASSIGN 
                    li-itemno = IF AVAILABLE tt-menu 
                               THEN tt-menu.itemno + 1
                               ELSE 1.
                CREATE tt-menu.
                ASSIGN 
                    tt-menu.ItemNo = li-itemno
                    tt-menu.Level  = pi-level
                    tt-menu.Description = lc-desc.
            END.
            FIND LAST tt-menu NO-LOCK NO-ERROR.
            ASSIGN 
                li-itemno = IF AVAILABLE tt-menu 
                               THEN tt-menu.itemno + 1
                               ELSE 1.
            CREATE tt-menu.
            ASSIGN 
                tt-menu.itemno = li-itemno
                tt-menu.Level =  pi-level + 1
                tt-menu.Description = STRING(Issue.IssueNumber) + ' ' + 
                                         Issue.BriefDescription
                tt-menu.ObjType = "WS"
                tt-menu.ObjTarget = "mainwindow"
                tt-menu.ObjURL  = "iss/issueview.p?mode=update&return=home&rowid=" + string(ROWID(issue)).
            .
           
        END.
    END.
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-mnlib-BuildMenu) = 0 &THEN

PROCEDURE mnlib-BuildMenu :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pc-menu     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pi-level    AS INTEGER  NO-UNDO.

    DEFINE BUFFER b-menu FOR webmhead.
    DEFINE BUFFER b2-menu FOR webmhead.
    DEFINE BUFFER b-line FOR webmline.
    DEFINE BUFFER b2-line FOR webmline.
    DEFINE BUFFER b-object FOR webobject.

    DEFINE VARIABLE li-ItemNo       AS INTEGER NO-UNDO.
    DEFINE VARIABLE ll-has-side     AS LOG NO-UNDO.

    FIND b-menu WHERE b-menu.pagename = pc-menu NO-LOCK NO-ERROR.

    IF NOT AVAILABLE b-menu THEN RETURN.

    FOR EACH b-line OF b-menu NO-LOCK:
        IF b-line.linktype = 'page' THEN
        DO:
            FIND b2-menu WHERE b2-menu.pagename = b-line.linkobject
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE b2-menu THEN NEXT.
            FIND FIRST b2-line OF b2-menu NO-LOCK NO-ERROR.
            IF NOT AVAILABLE b2-line THEN NEXT.
            ASSIGN 
                ll-has-side = FALSE.
            FOR EACH b2-line OF b2-menu NO-LOCK:
                FIND b-object WHERE b-object.objectid = b2-line.linkobject NO-LOCK NO-ERROR.
                IF NOT AVAILABLE b-object THEN NEXT.
                IF CAN-DO("l,b",b-object.menulocation) = FALSE THEN NEXT.
                ASSIGN 
                    ll-has-side = TRUE.
                LEAVE.
            END.
            IF NOT ll-has-side THEN NEXT.
        END.
        ELSE
        DO:
            FIND b-object WHERE b-object.objectid = b-line.linkobject
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE b-object THEN NEXT.
            IF CAN-DO("l,b",b-object.menulocation) = FALSE THEN NEXT.
        END.
        FIND LAST tt-menu NO-LOCK NO-ERROR.
        ASSIGN 
            li-itemno = IF AVAILABLE tt-menu 
                           THEN tt-menu.itemno + 1
                           ELSE 1.
        IF b-line.linktype = 'Page' THEN
        DO:
            CREATE tt-menu.
            ASSIGN 
                tt-menu.ItemNo = li-itemno
                tt-menu.Level  = pi-Level
                tt-menu.Description  = b2-menu.PageDesc.
            RUN mnlib-BuildMenu( b2-menu.PageName, pi-level + 1 ).

        END.
        ELSE
        DO:
            CREATE tt-menu.
            ASSIGN 
                tt-menu.ItemNo = li-itemno
                tt-menu.Level  = pi-Level
                tt-menu.Description = b-object.Description
                tt-menu.ObjURL      = b-object.ObjURL
                tt-menu.ObjTarget   = b-object.ObjTarget
                tt-menu.ObjType     = b-object.ObjType.

        END.
    END.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

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


&ENDIF

&IF DEFINED(EXCLUDE-p-BeginNexus) = 0 &THEN

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


&ENDIF

&IF DEFINED(EXCLUDE-p-BuildItem) = 0 &THEN

PROCEDURE p-BuildItem :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER pi-item AS INTEGER NO-UNDO.

    DEFINE INPUT PARAMETER pi-level AS INTEGER NO-UNDO.

    DEFINE INPUT PARAMETER pc-label AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-url   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-target AS CHARACTER NO-UNDO.


    ASSIGN 
        pi-item = pi-item + 1.

    IF pi-level > 0
        THEN ASSIGN pc-label = FILL('*',pi-level) + pc-label.

    {&out} '<param name=Item' STRING(pi-item) ' value="' pc-label '">' skip.

    IF pc-url = ""
        THEN pc-url = "$".

    IF pc-url BEGINS 'javascriptxxxxxxx':U 
        THEN {&out} '<param name=URL' STRING(pi-item) ' value=' pc-url '>' skip.
    else {&out} '<param name=URL' string(pi-item) ' value="' pc-url '">' skip.

    IF pc-target <> ""
        THEN {&out} '<param name=Target' STRING(pi-item) ' value="' pc-target '">' skip.


END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-p-EndNexus) = 0 &THEN

PROCEDURE p-EndNexus :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    
    {&out} '</APPLET>' skip.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

PROCEDURE process-web-request :
    /*------------------------------------------------------------------------------
      Purpose:     Process the web request.
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    
    
   
    DEFINE VARIABLE lc-value AS CHARACTER NO-UNDO.



    ASSIGN 
        lc-value = get-cookie("ExtranetUser").

    ASSIGN 
        lc-user = htmlib-DecodeUser(lc-value).

    ASSIGN 
        lc-system = htmlib-GetAttr("system","systemname")
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
   
    FIND webuser WHERE webuser.loginid = lc-user NO-LOCK NO-ERROR.

    IF AVAILABLE webuser THEN
    DO:
        {&out} '<div class="inform"><fieldset>'
        "You are logged in as " + webuser.name
        '</fieldset></div>'.
    END.
    ELSE {&out} '<p>no user</p>'.

    
    

    IF AVAILABLE webuser THEN
    DO:
        RUN mnlib-BuildIssueMenu ( webuser.pagename, 1 ).
        RUN mnlib-BuildMenu ( webuser.pagename, 1 ).
    END.


    RUN ip-NewMenu.
    RUN p-BeginNexus.


    RUN p-BuildItem ( INPUT-OUTPUT li-item,
        1,
        'Your Issues',
        appurl + '/mn/mainframe.p',
        'mainwindow').


    FOR EACH tt-menu EXCLUSIVE-LOCK:
        IF tt-menu.ObjType = 'WS'
            THEN ASSIGN tt-menu.ObjURL = appurl + '/' + tt-menu.ObjURL.
        
        RUN p-BuildItem( INPUT-OUTPUT li-item,
            tt-menu.Level,
            tt-menu.Description,
            tt-menu.ObjURL,
            tt-menu.ObjTarget ).

    END.

    /*
    RUN p-BuildItem ( input-output li-item,
                      1,
                      'Contact ' + lc-company,
                      appurl + '/mn/contactsheet.p',
                      'mainwindow').
    */

    IF AVAILABLE webuser THEN
        RUN p-BuildItem ( INPUT-OUTPUT li-item,
            1,
            'Change Your Password',
            appurl + '/mn/changepassword.p',
            'mainwindow').

    RUN p-EndNexus.
    
    {&out} '</form>' skip.
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-xip-HTM-Header) = 0 &THEN

PROCEDURE xip-HTM-Header :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pc-htm             AS CHARACTER NO-UNDO.

    ASSIGN 
        pc-htm = 
        '<meta http-equiv="refresh" content="300;url=' 
        + appurl + '/mn/leftpanel.p' +
        '"><META HTTP-EQUIV="Expires" CONTENT="0">'.
END PROCEDURE.


&ENDIF

