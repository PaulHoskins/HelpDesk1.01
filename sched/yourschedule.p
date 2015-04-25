/***********************************************************************

    Program:        sched/yourschedule.p
    
    Purpose:        Show An Engineers Schedule - Not Edittable
    
    Notes:
    
    
    When        Who         What
    25/04/2015  phoski      Initial
    

***********************************************************************/
CREATE WIDGET-POOL.



DEFINE VARIABLE lc-rowid    AS CHARACTER    NO-UNDO.

DEFINE BUFFER b-table FOR esched.
DEFINE BUFFER blogin  FOR webuser.





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

PROCEDURE ip-HTM-Header:
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/
      DEFINE OUTPUT PARAMETER pc-return       AS CHARACTER NO-UNDO.
      
      
      pc-return = 
            '<script type="text/javascript" src="/asset/jquery/jquery-1.11.2.min.js"></script>~n' +
            '<script src="/asset/sched/codebase/dhtmlxscheduler.js" type="text/javascript" charset="utf-8"></script>~n' + 
            '<link rel="stylesheet" href="/asset/sched/codebase/dhtmlxscheduler.css" type="text/css" media="screen" title="no title" charset="utf-8">~n' +
            '<script language="JavaScript" src="/asset/page/yourschedule.js?v=1.0.0"></script>~n' 
        
            .
    

END PROCEDURE.

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
    
    output-content-type ("text/html":U).
    
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
        lc-rowid = get-value("engineer").
        
    
    ASSIGN
        lc-rowid = DYNAMIC-FUNCTION("sysec-DecodeValue",lc-user,TODAY,"ScheduleKey",lc-rowid).
        
   
    FIND blogin WHERE ROWID(blogin) = to-rowid(lc-rowid) NO-LOCK NO-ERROR.
    
       
    RUN outputHeader.
     
         
    {&out} htmlib-Header("Project Schedule") skip.
  

    {&out} htmlib-StartForm("mainform","post", appurl + '/sched/yourschedule.p' ) skip.
    
    
    {&out} htmlib-ProgramTitle("Project Schedule - " + dynamic-function("com-UserName",blogin.LoginID)). 
   
    
    
           
    {&out} htmlib-EndForm() skip.

   

    {&OUT} htmlib-Footer() skip.
    
   
    
END PROCEDURE.


&ENDIF

