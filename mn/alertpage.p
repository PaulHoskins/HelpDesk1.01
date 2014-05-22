&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mn/alertpage.p
    
    Purpose:        Alert Info    
    
    Notes:
    
    
    When        Who         What
    08/05/2006  phoski      Initial
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{iss/issue.i}

def buffer customer     for Customer.
def buffer WebAction    for WebAction.
def buffer Issue        for Issue.

def var lc-info             as char no-undo.
def var lc-object           as char no-undo.
def var li-tag-end          as int no-undo.
def var lc-dummy-return     as char initial "MYXXX111PPP2222"   no-undo.

def var lc-Action-TBAR      as char
    initial "actiontb"      no-undo.
def var lc-Alert-TBAR      as char
    initial "alerttb"      no-undo.

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

&IF DEFINED(EXCLUDE-ip-ActionTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ActionTable Procedure 
PROCEDURE ip-ActionTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer b-query      for IssAction.

    def var lc-assign-info      as char no-undo.
    

    {&out} skip
           htmlib-StartFieldSet("Actions Assigned To You") 
           
           .

    {&out}
        tbar-BeginID(lc-Action-TBAR,"")
           tbar-BeginOptionID(lc-Action-TBAR) skip(2)
            tbar-Link("view",?,"off","")
            tbar-Link("update",?,"off","")
            tbar-EndOption()
            
           tbar-End().

    {&out} htmlib-StartMntTable()
           htmlib-TableHeading(
                    "Customer|Issue^right|Details|Action Date^left|Action Details^left|Assigned By"
                    ) skip.
    for each b-query no-lock
        where b-query.AssignTo = lc-global-user
          and b-query.ActionStatus = "OPEN",
            each Issue no-lock
                where Issue.CompanyCode = b-Query.CompanyCode
                  and Issue.IssueNumber = b-Query.IssueNumber,
                  each Customer no-lock
                    where Customer.CompanyCode = Issue.CompanyCode
                      and Customer.AccountNumber = Issue.AccountNumber

            break by b-query.AssignDate 
                  by b-query.AssignTime
                    
          :


        
        find WebAction 
            where WebAction.ActionID = b-query.ActionID
            no-lock no-error.

       
        {&out}
            skip(1)
            tbar-trID(lc-Action-TBAR,rowid(b-query))
            skip(1)
            htmlib-MntTableField(
                html-encode(customer.AccountNumber + ' ' + customer.name),'left')
            htmlib-MntTableField(string(b-query.IssueNumber),'right') 
            htmlib-MntTableField(html-encode(issue.BriefDescription),'left')
            htmlib-MntTableField(string(b-query.ActionDate,"99/99/9999"),'left') skip
            .

        if b-query.notes <> "" then
        do:
        
            assign 
                lc-info = 
                replace(htmlib-MntTableField(html-encode(WebAction.Description),'left'),'</td>','')
                lc-object = "hdobj" + string(b-query.issActionID).
        
            assign li-tag-end = index(lc-info,">").

            {&out} substr(lc-info,1,li-tag-end).

            assign substr(lc-info,1,li-tag-end) = "".
            
            {&out} 
                '<img class="expandboxi" src="/images/general/plus.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">':U skip.
            {&out} lc-info.
    
            {&out} htmlib-ExpandBox(lc-object,b-query.Notes).

            {&out} '</td>' skip.
        end.
        else {&out}
            htmlib-MntTableField(WebAction.Description,'left').
        
        assign lc-assign-info = com-userName(b-query.AssignBy).

        if lc-assign-info <> "" and b-query.AssignDate <> ? 
        then assign lc-assign-info = lc-assign-info + ' ' + 
                                     string(b-query.AssignDate,'99/99/9999') + ' ' + 
                                     string(b-query.AssignTime,'hh:mm am').

        {&out}
            htmlib-MntTableField(lc-Assign-Info,'left').

         {&out} skip
                tbar-BeginHidden(rowid(b-query))
                tbar-Link("view",rowid(b-query),
                          'javascript:HelpWindow('
                          + '~'' + appurl 
                          + '/iss/issueview.p?rowid=' + string(rowid(Issue))
                          + '~'' 
                          + ');'
                          ,"")
                tbar-Link("update",rowid(issue),appurl + '/' + "iss/issueframe.p","")
                
            tbar-EndHidden()

            skip.

        {&out}
            '</tr>' skip.

       

    end.


    {&out} htmlib-EndTable() skip.

    {&out} skip 
           htmlib-EndFieldSet() 
           skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-AlertTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-AlertTable Procedure 
PROCEDURE ip-AlertTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer b-query      for IssAlert.

    def var lc-sla-info     as char no-undo.
    
    def var ll-missed       as log no-undo.
        
    {&out} skip
           htmlib-StartFieldSet("SLA Alerts") 
           .

    {&out}
        tbar-BeginID(lc-Alert-TBAR,"")
           tbar-BeginOptionID(lc-Alert-TBAR) skip(2)
            tbar-Link("view",?,"off","")
            tbar-Link("update",?,"off","")
            tbar-EndOption()
            
           tbar-End().

    {&out} htmlib-StartMntTable()
           htmlib-TableHeading(
                    "Date/Time|Customer|Issue^right|Details^left|SLA^left|SLA Details^left"
                    ) skip.
    for each b-query no-lock
        where b-query.LoginID = lc-global-user
         ,
            each Issue no-lock
                where Issue.CompanyCode = b-Query.CompanyCode
                  and Issue.IssueNumber = b-Query.IssueNumber,
                  each Customer no-lock
                    where Customer.CompanyCode = Issue.CompanyCode
                      and Customer.AccountNumber = Issue.AccountNumber

            break by b-Query.CreateDate 
                  by b-Query.CreateTime 
                  by b-Query.IssueNumber
                  
          :


        find slahead where slahead.SLAID = Issue.link-SLAID no-lock no-error.
        if not avail slahead then next.

        {&out}
            skip(1)
            tbar-trID(lc-Alert-TBAR,rowid(b-query))
            skip(1)
            htmlib-MntTableField(
                html-encode(
                    string(b-query.CreateDate,"99/99/9999") 
                    + " " + string(b-query.CreateTime,"hh:mm am")
                    ),'left'
                )
            htmlib-MntTableField(
                html-encode(customer.AccountNumber + ' ' + customer.name),'left')
            htmlib-MntTableField(string(b-query.IssueNumber),'right') 
            
            .

        if Issue.LongDescription <> "" then
        do:
        
            assign 
                lc-info = 
                replace(htmlib-MntTableField(html-encode(Issue.BriefDescription),'left'),'</td>','')
                lc-object = "hdobj" + string(issue.IssueNumber).
        
            assign li-tag-end = index(lc-info,">").

            {&out} substr(lc-info,1,li-tag-end).

            assign substr(lc-info,1,li-tag-end) = "".
            
            {&out} 
                '<img class="expandboxi" src="/images/general/plus.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">':U skip.
            {&out} lc-info.
    
            {&out} htmlib-ExpandBox(lc-object,Issue.LongDescription).

            {&out} '</td>' skip.
        end.
        else {&out}
            htmlib-MntTableField(Issue.BriefDescription,'left').
        
        if b-query.SLALevel > 0 then
        do:
            assign lc-sla-info = string(b-query.SLALevel) + " - " + 
                                 slahead.RespDesc[b-query.SLALevel] + 
                                 ' ' + string(Issue.SLADate[b-query.SLALevel],'99/99/9999') +
                                 ' ' + string(Issue.SLATime[b-query.SLALevel],'hh:mm am').
            if b-query.SLALevel = 10
            or Issue.SLADate[b-Query.SLALevel + 1] = ?
            then assign ll-missed = true
                         lc-sla-info = '<span style="color: red";>' +
                                      lc-sla-info + '</span>'.
        end.

        {&out}
            htmlib-MntTableField(slahead.description,'left')
            htmlib-MntTableField(lc-sla-info,'left').

         {&out} skip
                tbar-BeginHidden(rowid(b-query))
                tbar-Link("view",rowid(b-query),
                          'javascript:HelpWindow('
                          + '~'' + appurl 
                          + '/iss/issueview.p?rowid=' + string(rowid(Issue))
                          + '~'' 
                          + ');'
                          ,"")
                tbar-Link("update",rowid(issue),appurl + '/' + "iss/issueframe.p","")
                
            tbar-EndHidden()

            skip.

        {&out}
            '</tr>' skip.

       

    end.


    {&out} htmlib-EndTable() skip.

    if ll-missed then
    {&out} '<div style="border: 2px solid red; padding: 4px;"><span style="color: red;"><center>** SLA details shown in red are outside their SLA **</center></span></div>'.

    {&out} skip 
           htmlib-EndFieldSet() 
           skip.

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
  
    {lib/checkloggedin.i}

   
    RUN outputHeader.
    
    {&out} htmlib-Header("Alerts") skip.

    {&out} htmlib-JScript-Maintenance() skip.

   
    {&out} htmlib-StartForm("mainform","post", appurl + '/mn/alertpage.p' ) skip.

    {&out} htmlib-ProgramTitle("Your Actions & Alerts") skip.
    
    {&out} '<script language="JavaScript" src="/scripts/js/hidedisplay.js"></script>' skip.


    {&out} tbar-JavaScript(lc-Action-TBAR) skip
           tbar-JavaScript(lc-Alert-TBAR).

    if com-NumberOfAlerts(lc-global-user) > 0
    then RUN ip-AlertTable.
    if com-NumberOfActions(lc-global-user) > 0 
    then RUN ip-ActionTable.
   
    {&out} htmlib-EndForm().

    
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

