&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/ajax/overview.p
    
    Purpose:        Issue Overview - Ajax
    
    Notes:
    
    
    When        Who         What
    22/04/2006  phoski      Initial
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var li-total    as int      no-undo.

def temp-table tt   no-undo
    field AType         as char
    field ACode         as char
    field ADescription  as char
    field ACount        as int
    index AType
            AType
            ACount      desc
            ADescription.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCreate Procedure 
FUNCTION fnCreate RETURNS LOGICAL
  ( pc-AType as char,
    pc-ACode as char,
    pc-ADescription as char )  FORWARD.

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

&IF DEFINED(EXCLUDE-ip-BuildAnalysis) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildAnalysis Procedure 
PROCEDURE ip-BuildAnalysis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer Issue        for Issue.
    def buffer WebStatus    for WebStatus.
    def buffer Customer     for Customer.
    
    for each Issue no-lock
        where Issue.CompanyCode = lc-global-company
          ,
          first WebStatus no-lock
                where WebStatus.companyCode = Issue.CompanyCode
                  and WebStatus.StatusCode  = Issue.StatusCode
                  and WebStatus.Completed   = false
          :

        assign li-total = li-total + 1.


        dynamic-function("fnCreate",
                         "STATUS",
                         Issue.StatusCode,
                         WebStatus.Description
                             ).

        dynamic-function("fnCreate",
                         "USER",
                         Issue.AssignTo,
                         if Issue.AssignTo = "" then "Unassigned"
                         else dynamic-function("com-UserName",Issue.AssignTo)
                             ).

        find customer of Issue no-lock no-error.

        dynamic-function("fnCreate",
                         "CUSTOMER",
                         Issue.AccountNumber,
                         Customer.name
                             ).

        find WebIssArea of Issue no-lock no-error.

        if avail webIssArea then
        dynamic-function("fnCreate",
                         "AREA",
                         Issue.AreaCode,
                         WebIssArea.Description
                             ).
        

         

    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Graph) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Graph Procedure 
PROCEDURE ip-Graph :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-AType  as char     no-undo.

    def var li-base         as int        no-undo.
    def var li-perc         as int        no-undo.
    def var lc-link         as char       no-undo.
    def var lc-click        as char       no-undo.
    
   /* {&out} '<div class="bargraphcontainer" style="margin-top:10px;"><div class="bargraphcaption"><strong>'.
   */

    {&out} '<div class="bargraphcontainer" style="margin-top:10px;"><div class="loglink" style="border-left: none;text-align: center; font-weight: 900;">'.
    case pc-AType:
        when "USER" 
        then {&out} 'Open Issues By Assignment'.
        when "CUSTOMER" 
        then {&out} 'Open Issues By Customer'.
        when "STATUS"
        then {&out} 'Open Issues By Status'.
        when "AREA"
        then {&out} 'Open Issues By Area'.
    end case.

    {&out} '</div><br>'.


    find first tt where tt.AType = pc-AType no-lock.


    assign li-base = tt.ACount.


    for each tt where tt.AType = pc-AType no-lock:

        {&out}
            '<div class="bartitle">' html-encode(tt.ADescription) '</div>'.

        assign
            li-perc = round( tt.ACount / ( li-Base / 100 ),0).
        if li-perc <= 0 then li-perc = 1.

       /* 'iss/issue.p?frommenu=yes&status=allopen' */

        lc-link = "".
        case pc-AType:
            when "USER" 
            then assign lc-link = appurl + '/iss/issue.p?iclass=All&frommenu=yes&status=allopen&assign=' + if tt.Acode = ""
                    then "NotAssigned" else tt.ACode.
            when "CUSTOMER"
            then assign lc-link = appurl + '/iss/issue.p?iclass=All&frommenu=yes&status=allopen&account=' + tt.ACode.
            when "AREA"
            then assign lc-link = appurl + '/iss/issue.p?iclass=All&frommenu=yes&status=allopen&area=' + tt.ACode.
            when "STATUS"
            then assign lc-link = appurl + '/iss/issue.p?iclass=All&frommenu=yes&status=' + tt.ACode.
        end case.

        if lc-link <> ""
        then lc-click = 'onclick="javascript:self.location = ~'' + lc-link + '~';"'.
        {&out} 
            '<div alt="Click to view details" ' lc-click ' onmouseover="javascript:GrowOver(this)" onmouseout="javascript:GrowOut(this)" class="bargraph" style="width:' li-perc '%;">' tt.ACount '</div>' skip.

    end.


    {&out} '</div>'.

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
  output-content-type("text/plain~; charset=iso-8859-1":U).
  
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
    
    RUN outputHeader.
    
    RUN ip-BuildAnalysis.

    {&out} '<div id="overview" style="display: none;">' skip.

    if li-total = 0 
    then {&out} '<p class="loglink">There are no open issues.</p>'.
    else
    do:
        {&out} '<div class="loglink">'.
    
        {&out} '<p style="text-align: center; font-weight: 900;">There are currently ' li-Total ' open issues (' string(today,'99/99/9999') ' - ' 
                    string(time,'hh:mm am') ')</p>'.
        {&out} '</div>'.
    
        {&out} '<table border=0 width=98% align="center">'.
    
        {&out} '<tr><td valign="top">'.
    
        RUN ip-Graph ( 'USER' ).
    
        {&out} '</td><td valign="top">'.
    
        RUN ip-Graph ( 'CUSTOMER' ).
    
        {&out} '</td></tr><tr><td valign="top">'.
    
        RUN ip-Graph ( 'STATUS' ).
    
        {&out} '</td><td valign="top">'.
    
        RUN ip-Graph ( 'AREA' ).
    
        {&out} '</td></tr>'.
    
        {&out} '</table>'.
    end.

    {&out} '</div>'.

    {&out}
        '<script>' skip
        'myresponse = function() ~{' skip
        /* ' Effect.SlideDown(~'overview~', ~{duration:3~});' skip */
        ' Effect.Grow(~'overview~');' skip

        '~}' skip 
        'myresponse();' skip
        '</script>'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCreate Procedure 
FUNCTION fnCreate RETURNS LOGICAL
  ( pc-AType as char,
    pc-ACode as char,
    pc-ADescription as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    find tt where tt.AType = pc-AType
              and tt.ACode = pc-ACode 
              exclusive-lock no-error.
    if not avail tt then
    do:
        create tt.
        assign tt.AType = pc-AType
               tt.ACode = pc-ACode
               tt.ADescription = pc-ADescription.
    end.

    assign
        tt.ACount = tt.Acount + 1.
    return true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

