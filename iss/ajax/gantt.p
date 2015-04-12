/***********************************************************************

    Program:        iss/ajax/gantt.p
    
    Purpose:        Issue Build Gantt    
    
    Notes:
    
    
    When        Who         What
    12/04/2015  phoski      Initial
    

***********************************************************************/
CREATE WIDGET-POOL.


DEFINE VARIABLE lc-rowid AS CHARACTER NO-UNDO.


DEFINE BUFFER b-table FOR issue.





/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no






/* *********************** Procedure Settings ************************ */



/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.14
         WIDTH              = 60.6.
/* END WINDOW DEFINITION */
                                                                        */

/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}
{iss/issue.i}
{lib/ticket.i}
{lib/project.i}



 




/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.



/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

PROCEDURE outputHeader :
    /*------------------------------------------------------------------------------
      Purpose:     Output the MIME header, and any "cookie" information needed 
                   by this procedure.  
      Parameters:  <none>
      objtargets:       In the event that this Web object is state-aware, this is
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


&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  objtargets:       
------------------------------------------------------------------------------*/
    
    {lib/checkloggedin.i} 
    
    ASSIGN
        lc-rowid = get-value("rowid")
        .
    

    
    FIND b-table WHERE ROWID(b-table) = to-rowid(lc-rowid) NO-LOCK.
    
    DEFINE VARIABLE li-Count        AS INTEGER EXTENT 2 NO-UNDO.
    DEFINE VARIABLE li-This         AS INTEGER NO-UNDO.
    DEFINE VARIABLE lc-string       AS CHARACTER NO-UNDO.
    
    
    RUN prjlib-BuildGanttData (
        lc-global-user,
        b-table.companyCode,
        b-table.IssueNumber,
        OUTPUT TABLE tt-proj-tasks
        ).
    
    ASSIGN
        li-Count = 0
        li-This = 0.
        
    FOR EACH tt-proj-tasks NO-LOCK:
        ASSIGN
            li-count[1] = li-count[1] + 1.
        IF tt-proj-tasks.parentID > 0 
            THEN ASSIGN li-count[2] = li-count[2] + 1.
        
        
    END.    
       
    RUN outputHeader.
    
    
    /*
    ***
    *** All this does is create a javascript var called tasks, this gets eval'ed in the issue/custom.js ganttBuild function
    ***
    */
    {&out} 
        'var tasks = ~{' SKIP
        '   data:[' SKIP.
       
    FOR EACH tt-proj-tasks NO-LOCK:
        ASSIGN
            li-this = li-this + 1.
        
        ASSIGN
            lc-string = REPLACE(STRING(tt-proj-tasks.startDate,"99/99/9999"),"/","-").
        {&out}
        '   ~{id:' tt-proj-tasks.id ', text:"' tt-proj-tasks.txt '", start_date:"' lc-string '", duration:' tt-proj-tasks.duration
        ', datatype:"' IF tt-proj-tasks.parentID = 0 THEN 'PH' ELSE 'TA' '"'
        ', progress:' STRING(tt-proj-tasks.prog) ', open: true'.
        
        IF tt-proj-tasks.parentID = 0
            THEN {&out} '~}'.
        else {&out} ', parent:' tt-proj-tasks.parentID '~}'.
        
        IF li-this = li-count[1]
            THEN {&out} SKIP.
        ELSE {&out} ',' SKIP. /* end of rec */
     
        
        
    END.    
      
    {&out} skip
        '],' SKIP /*end of data */
        '   links:[' SKIP.
    ASSIGN
        li-this = 0.
    FOR EACH tt-proj-tasks NO-LOCK
        WHERE tt-proj-tasks.parentid > 0 
        BY tt-proj-tasks.rno:
        ASSIGN
            li-this = li-this + 1.
        
        {&out}
        '~{id:' li-this ', source:' tt-proj-tasks.parentid ', target:' tt-proj-tasks.id ' , type:"1" ~}'.
        
        IF li-this = li-count[2]
            THEN {&out} SKIP.
        ELSE {&out} ',' SKIP. /* end of rec */
        
        
        
        
    END.
            
    
    {&out} SKIP
        ']' SKIP /* end of links */
    '~};' SKIP /* end of tasks */
    /* 
   'gantt.init("gantt_here");' SKIP
   'gantt.parse(tasks);' SKIP
   */
    .
            
END PROCEDURE.


&ENDIF

