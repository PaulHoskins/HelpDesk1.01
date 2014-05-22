&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mn/ajax/superuser.p
    
    Purpose:        Super User Ajax Panel
    
    Notes:
    
    
    When        Who         What
    06/08/2006  phoski      Initial   
    
    03/08/2010  DJS         Small changes for possible speedup
     
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */



def var lc-user as char no-undo.

DEF VAR ll-SuperUser        AS LOG      NO-UNDO.

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

&IF DEFINED(EXCLUDE-ip-ContractorView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ContractorView Procedure 
PROCEDURE ip-ContractorView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&out} '<div id="quickview" style="display: none; margin: 7px;">'.
   
    {&out} htmlib-BeginCriteria("Quick View").

    {&out} '<table style="font-size: 10px;" id="customerList">'.
    for each customer  
      no-lock
        where customer.CompanyCode = webuser.CompanyCode use-index Name
        ,
        first ContAccess
          no-lock
            where ContAccess.LoginId = lc-user
              and ContAccess.AccountNumber = customer.AccountNumber 
              
        :
        

        {&out}
        '<tr><td>'
            '<a title="View Customer" target="mainwindow" class="tlink" style="border:none;" href="' appurl '/cust/custview.p?source=menu&rowid=' 
                    string(rowid(customer)) '">'
            html-encode(customer.Name)
            '</a></td></tr>'.

    end.
    
    {&out} '</table>'.
    {&out} htmlib-EndCriteria().
    {&out} '</div>'.

     {&out}
        '<script>' skip
        'superuserresp = function() ~{' skip
        /* ' Effect.SlideDown(~'overview~', ~{duration:3~});' skip */
        ' Effect.Grow(~'quickview~');' skip

        '~}' skip 
        'superuserresp();' skip
        '</script>'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CustomerQuickView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CustomerQuickView Procedure 
PROCEDURE ip-CustomerQuickView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR ll-Steam    AS LOG NO-UNDO.
    DEF VAR ll-HasIss   AS LOG NO-UNDO.

    {&out} '<div id="quickview" style="display: none; margin: 7px;">'.
    {&out} htmlib-BeginCriteria("Quick View").
    
    {&out} '<table style="font-size: 10px;" id="customerList">'.

   
    ll-Steam = CAN-FIND(FIRST webUsteam WHERE webusteam.loginid = lc-user NO-LOCK).



    for each customer  no-lock
        where customer.CompanyCode = webuser.CompanyCode 
          and customer.iSActive
        use-index Name:

        /*
        *** if user is in teams then customer must be in 1 of the users teams
        *** or they have been assigned to the an issue for the customer
        */
        IF ll-steam
        AND NOT CAN-FIND(FIRST webUsteam WHERE webusteam.loginid = lc-user
                                       AND webusteam.st-num = customer.st-num NO-LOCK) 
        THEN 
        do:
            ASSIGN ll-HasIss = FALSE.
            for each Issue no-lock
                where Issue.CompanyCode = webuser.CompanyCode
                  and Issue.AssignTo = webuser.LoginID
                  AND issue.AccountNumber = customer.AccountNumber,
                    first WebStatus no-lock
                        where WebStatus.CompanyCode = Issue.CompanyCode 
                              and WebStatus.StatusCode = Issue.StatusCode
                              and WebStatus.CompletedStatus = false:
                ll-HasIss = TRUE.
                LEAVE.
            END.
            IF NOT ll-HasIss THEN NEXT.
        END.

        {&out}
        '<tr><td>'
            '<a title="View Customer" target="mainwindow" class="tlink" style="border:none;" href="' appurl '/cust/custview.p?source=menu&rowid=' 
                    string(rowid(customer)) '">'
            html-encode(customer.Name)
            '</a></td></tr>'.

    end.

    {&out} '</table>'.
    {&out} htmlib-EndCriteria().
    {&out} '</div>'.

     {&out}
        '<script>' skip
        'superuserresp = function() ~{' skip
        /* ' Effect.SlideDown(~'overview~', ~{duration:3~});' skip */
        ' Effect.Grow(~'quickview~');' skip

        '~}' skip 
        'superuserresp();' skip
        '</script>'.


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


    assign lc-user = get-value("user").


    RUN outputHeader.
    
    
    find webuser where webuser.loginid = lc-user no-lock no-error.

    
    if not avail webuser then return.
    
    ll-superUser = dynamic-function("com-IsSuperUser",webuser.LoginID).


    if not dynamic-function("com-QuickView",webuser.LoginID)
    then return.

    if ll-SuperUser
    or webUser.UserClass = "INTERNAL"
    then RUN ip-CustomerQuickView.
    else RUN ip-ContractorView.

    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

