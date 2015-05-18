/***********************************************************************

    Program:        dashboard/ajax/panel.p
    
    Purpose:        Dasboard panel.p
    
    Notes:
    
    
    When        Who         What
    16/05/2015  phoski      Initial
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE VARIABLE lh-Buffer1 AS HANDLE NO-UNDO.
DEFINE VARIABLE lh-Query   AS HANDLE NO-UNDO.




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


&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

PROCEDURE ip-BuildCompanyStats:
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE li-count     AS INTEGER      NO-UNDO.
    
    DEFINE VARIABLE lc-QPhrase   AS CHARACTER    NO-UNDO.
    
    
    DEFINE BUFFER Issue FOR Issue.
       
    ASSIGN 
        
        lc-QPhrase = 
        "for each issue NO-LOCK where issue.CompanyCode = '" + string(lc-Global-Company) + "'".
    
    CREATE QUERY lh-Query  
        ASSIGN 
        CACHE = 500 .

    lh-Buffer1 = BUFFER issue:HANDLE.
   
    lh-Query:SET-BUFFERS(lh-Buffer1).
    lh-Query:QUERY-PREPARE(lc-QPhrase).
    lh-Query:QUERY-OPEN().
    
    lh-Query:GET-FIRST(NO-LOCK). 
    
    REPEAT WHILE lh-Buffer1:AVAILABLE: 
        
        ASSIGN 
            li-count = li-count + 1.
    
        lh-Query:GET-NEXT(NO-LOCK). 
         
    END.   
    
    lh-Query:QUERY-CLOSE ().
     
    DELETE OBJECT lh-Query NO-ERROR. 
    

END PROCEDURE.

PROCEDURE ip-IssueGridHeader:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-title         AS CHARACTER NO-UNDO.
    
    {&out} '<table class="easyui-datagrid"
        title="' pc-title ' "
        data-options="fitColumns:true,singleSelect:true,striped:true"
    >
    <thead>
        <tr>
            <th data-options="field:~'sla~',sortable:false">SLA</th>
            <th data-options="field:~'sladate~',sortable:false">SLA Date</th>
            <th data-options="field:~'slawarn~',sortable:false">SLA Warning</th>
            <th data-options="field:~'issue~',align:~'right~',sortable:false">Issue</th>
            <th data-options="field:~'dt~',align:~'right~',sortable:false">Date</th>
            <th data-options="field:~'bdesc~',sortable:false">Brief Description</th>
            <th data-options="field:~'stat~',sortable:false">Status</th>
            <th data-options="field:~'area~',sortable:false">Area</th>
            <th data-options="field:~'class~',sortable:false">Class</th>
            <th data-options="field:~'assigned~',sortable:false">Assigned</th>
            <th data-options="field:~'cname~',sortable:false">Customer</th>
        </tr>
    </thead>
    <tbody>' skip.
    

END PROCEDURE.

PROCEDURE ip-IssueGridRow:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pr-issue    AS ROWID        NO-UNDO.
    
    DEFINE BUFFER Customer FOR Customer.
    DEFINE BUFFER b-query   FOR issue.
    DEFINE BUFFER b-qcust   FOR Customer.
    DEFINE BUFFER b-search  FOR issue.
    DEFINE BUFFER b-cust    FOR customer.
    DEFINE BUFFER b-status  FOR WebStatus.  
    DEFINE BUFFER b-user    FOR WebUser.
    DEFINE BUFFER b-Area    FOR WebIssArea. 
    DEFINE BUFFER this-user FOR WebUser.

    DEFINE VARIABLE lc-status         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-customer       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-issdate        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-raised         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-assigned       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-area           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-open-status    AS CHARACTER NO-UNDO.

    
    FIND b-query WHERE ROWID(b-query) = pr-issue NO-LOCK NO-ERROR.
    IF NOT AVAILABLE b-query THEN RETURN.
    
    FIND Customer OF b-query NO-LOCK NO-ERROR.
    
    FIND b-status OF b-query NO-LOCK NO-ERROR.
    IF AVAILABLE b-status THEN
    DO:
        ASSIGN 
            lc-status = b-status.Description.
        IF b-status.CompletedStatus
            THEN lc-status = lc-status + ' (closed)'.
        ELSE lc-status = lc-status + ' (open)'.
    END.
    ELSE lc-status = "".
    
    FIND b-user WHERE b-user.LoginID = b-query.RaisedLogin NO-LOCK NO-ERROR.
    ASSIGN 
        lc-raised = IF AVAILABLE b-user THEN b-user.name ELSE "".
    ASSIGN 
        lc-assigned = "".
    FIND b-user WHERE b-user.LoginID = b-query.AssignTo NO-LOCK NO-ERROR.
    IF AVAILABLE b-user THEN
    DO:
        ASSIGN 
            lc-assigned = b-user.name.
            
        IF b-query.AssignDate <> ? THEN
            ASSIGN
                lc-assigned = lc-assigned + " " + string(b-query.AssignDate,"99/99/9999") + " " +
                                                  string(b-query.AssignTime,"hh:mm am").
                                                  
    END.
    FIND b-area OF b-query NO-LOCK NO-ERROR.
    ASSIGN 
        lc-area = IF AVAILABLE b-area THEN b-area.description ELSE "None".
      
      
    {&out}  '<tr><td>'.
          
    IF b-query.tlight = li-global-sla-fail
        THEN {&out} '<img src="/images/sla/fail.jpg" height="20" width="20" alt="SLA Fail">' SKIP.
    ELSE
    IF b-query.tlight = li-global-sla-amber
    THEN {&out} '<img src="/images/sla/warn.jpg" height="20" width="20" alt="SLA Amber">' SKIP.
    ELSE
    IF b-query.tlight = li-global-sla-ok
    THEN {&out} '<img src="/images/sla/ok.jpg" height="20" width="20" alt="SLA OK">' SKIP.

    ELSE {&out} '&nbsp;' SKIP.

    {&out} '</td><td>' IF b-query.slaTrip <> ? THEN       
    STRING(b-query.slatrip,"99/99/9999 HH:MM") ELSE "".
    
    {&out} '</td><td>' IF b-query.slaAmber <> ? THEN       
    STRING(b-query.slaAmber,"99/99/9999 HH:MM") ELSE "".
    
    {&out} '</td><td>' b-query.IssueNumber 
    '</td><td>' STRING(b-query.IssueDate,"99/99/9999") 
    '</td><td>' b-query.BriefDescription 
    '</td><td>' lc-status 
    '</td><td>' lc-area
    '</td><td>' com-DecodeLookup(b-query.iClass,lc-global-iclass-code,lc-global-iclass-desc)
    '</td><td>' lc-assigned
    '</td><td>' Customer.Name 
    '</td></tr>' SKIP.    
                  
        

END PROCEDURE.

PROCEDURE ip-LatestIssue:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-count        AS INTEGER      NO-UNDO.
    DEFINE VARIABLE li-max          AS INTEGER      NO-UNDO.
    
    DEFINE VARIABLE lc-QPhrase   AS CHARACTER    NO-UNDO.
    
    
    DEFINE BUFFER Issue FOR Issue.
       
    ASSIGN 
        li-max = 20
        lc-QPhrase = 
        "for each issue NO-LOCK where issue.CompanyCode = '" + string(lc-Global-Company) + "' by issue.IssueNumber DESCENDING".
    RUN ip-IssueGridHeader ( "Latest " + string(li-max) + " Issues").
    CREATE QUERY lh-Query  
        ASSIGN 
        CACHE = 100 .

    lh-Buffer1 = BUFFER issue:HANDLE.
   
    lh-Query:SET-BUFFERS(lh-Buffer1).
    lh-Query:QUERY-PREPARE(lc-QPhrase).
    lh-Query:QUERY-OPEN().
    
    lh-Query:GET-FIRST(NO-LOCK). 
    
    REPEAT WHILE lh-Buffer1:AVAILABLE: 
        
        ASSIGN 
            li-count = li-count + 1.
        RUN ip-IssueGridRow ( ROWID(issue)).
        
        
        IF li-count >= li-max THEN LEAVE.
        
        
        lh-Query:GET-NEXT(NO-LOCK). 
         
    END.   
    
    lh-Query:QUERY-CLOSE ().
     
    DELETE OBJECT lh-Query NO-ERROR. 
    
    
    {&out} '</tbody></table>' SKIP.

END PROCEDURE.

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


&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  emails:       
------------------------------------------------------------------------------*/

    {lib/checkloggedin.i}

    
    RUN outputHeader.
    
    RUN ip-LatestIssue.
    
   
    
  
END PROCEDURE.


&ENDIF

