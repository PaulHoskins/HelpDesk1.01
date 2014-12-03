/***********************************************************************

    Program:        rep/engtime.p
    
    Purpose:        Enqineer Time Management
    
    Notes:
    
    
    When        Who         What
    
    03/12/2014  phoski      Initial
           
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lc-error-field AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-error-msg   AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-rowid       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-char        AS CHARACTER NO-UNDO.



DEFINE VARIABLE lc-lodate      AS CHARACTER FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE lc-hidate      AS CHARACTER FORMAT "99/99/9999" NO-UNDO.

DEFINE BUFFER this-user FOR WebUser.
  


DEFINE VARIABLE lc-filename   AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-CodeName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE li-loop       AS INTEGER   NO-UNDO.

DEFINE VARIABLE lc-output     AS CHARACTER NO-UNDO.


{rep/issuelogtt.i}
{lib/maillib.i}
{lib/princexml.i}



/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no





/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-Format-Select-Account) = 0 &THEN

FUNCTION Format-Select-Account RETURNS CHARACTER
    ( pc-htm AS CHARACTER )  FORWARD.


&ENDIF


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

&IF DEFINED(EXCLUDE-ip-ExportJScript) = 0 &THEN

PROCEDURE ip-ExportJScript :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    {&out} skip
            '<script language="JavaScript" src="/scripts/js/hidedisplay.js"></script>' skip.

    {&out} skip 
          '<script language="JavaScript">' skip.

    {&out} skip
        'function ChangeAccount() ~{' skip
        '   SubmitThePage("AccountChange")' skip
        '~}' skip

        'function ChangeStatus() ~{' skip
        '   SubmitThePage("StatusChange")' skip
        '~}' skip

            'function ChangeDates() ~{' skip
        '   SubmitThePage("DatesChange")' skip
        '~}' skip.

    {&out} skip
           '</script>' skip.
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-ExportReport) = 0 &THEN

PROCEDURE ip-ExportReport :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pc-filename AS CHARACTER NO-UNDO.
    
/*
    DEFINE BUFFER customer     FOR customer.
    DEFINE BUFFER issue        FOR issue.
    

    DEFINE VARIABLE lc-GenKey     AS CHARACTER NO-UNDO.

   
    ASSIGN
        lc-genkey = STRING(NEXT-VALUE(ReportNumber)).
    
        
    pc-filename = SESSION:TEMP-DIR + "/IssueLog-" + lc-GenKey
        + ".csv".

    OUTPUT TO VALUE(pc-filename).

    PUT UNFORMATTED
                
        '"Customer","Issue Number","Description","Issue Type","Raised By","System","SLA Level","' +
        'Date Raised","Time Raised","Date Completed","Time Completed","Activity Duration","SLA Achieved","SLA Comment","' +
        '"Closed By' SKIP.


    FOR EACH tt-ilog NO-LOCK
        BREAK BY tt-ilog.AccountNumber
        BY tt-ilog.IssueNumber
        :
            
        FIND customer WHERE customer.CompanyCode = lc-global-company
            AND customer.AccountNumber = tt-ilog.AccountNumber
            NO-LOCK NO-ERROR.


        EXPORT DELIMITER ','
            ( customer.AccountNumber + " " + customer.NAME )
            tt-ilog.issuenumber
            tt-ilog.briefDescription
            tt-ilog.iType
            tt-ilog.RaisedLoginID
            tt-ilog.AreaCode
            tt-ilog.SLALevel
            tt-ilog.CreateDate
            STRING(tt-ilog.CreateTime,"hh:mm")
      
            IF tt-ilog.CompDate = ? THEN "" ELSE STRING(tt-ilog.CompDate,"99/99/9999")

            IF tt-ilog.CompTime = 0 THEN "" ELSE STRING(tt-ilog.CompTime,"hh:mm")
       
            tt-ilog.ActDuration
            tt-ilog.SLAAchieved
            tt-ilog.SLAComment
            tt-ilog.ClosedBy

            . 
           
    END.

    OUTPUT CLOSE.
*/


END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-InitialProcess) = 0 &THEN

PROCEDURE ip-InitialProcess :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    
        
    ASSIGN
        
        lc-lodate      = get-value("lodate")         
        lc-hidate      = get-value("hidate")
        
        .
    IF request_method = "GET" THEN
    DO:
        
        IF lc-lodate = ""
            THEN ASSIGN lc-lodate = STRING(TODAY - 7, "99/99/9999").
        
        IF lc-hidate = ""
            THEN ASSIGN lc-hidate = STRING(TODAY, "99/99/9999").
        
        
    END.

    
    

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-PrintReport) = 0 &THEN

PROCEDURE ip-PDF:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pc-pdf AS CHARACTER NO-UNDO.
    
    /*
    DEFINE BUFFER customer     FOR customer.
    DEFINE BUFFER issue        FOR issue.
    
    DEFINE VARIABLE lc-html         AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE lc-pdf          AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE ll-ok           AS LOG      NO-UNDO.
    DEFINE VARIABLE li-ReportNumber AS INTEGER      NO-UNDO.

    ASSIGN    
        li-ReportNumber = NEXT-VALUE(ReportNumber).
    ASSIGN 
        lc-html = SESSION:TEMP-DIR + caps(lc-global-company) + "-issueLog-" + string(li-ReportNumber).

    ASSIGN 
        lc-pdf = lc-html + ".pdf"
        lc-html = lc-html + ".html".

    OS-DELETE value(lc-pdf) no-error.
    OS-DELETE value(lc-html) no-error.


    DYNAMIC-FUNCTION("pxml-Initialise").

    CREATE tt-pxml.
    ASSIGN 
        tt-pxml.PageOrientation = "LANDSCAPE".

    DYNAMIC-FUNCTION("pxml-OpenStream",lc-html).
    DYNAMIC-FUNCTION("pxml-Header", lc-global-company).
   
        
    {&prince}
    '<p style="text-align: center; font-size: 14px; font-weight: 900;">Issue Log - '
    'From ' STRING(DATE(lc-lodate),"99/99/9999")
    ' To ' STRING(DATE(lc-hidate),"99/99/9999") 
      
    '</div>'.


   

    
    FOR EACH tt-ilog NO-LOCK
        BREAK BY tt-ilog.AccountNumber
        BY tt-ilog.IssueNumber
        :

        IF FIRST-OF(tt-ilog.AccountNumber) THEN
        DO:
            FIND customer WHERE customer.CompanyCode = lc-global-company
                AND customer.AccountNumber = tt-ilog.AccountNumber
                NO-LOCK NO-ERROR.
            {&prince} htmlib-BeginCriteria("Customer - " + tt-ilog.AccountNumber + " " + 
                customer.NAME) SKIP.
                
            {&prince}
            '<table class="landrep">'
            '<thead>'
            '<tr>'
            htmlib-TableHeading(
                "Issue Number^right|Description^left|Issue Class^left|Raised By^left|System^left|SLA Level^left|" +
                "Date Raised^right|Time Raised^left|Date Completed^right|Time Completed^left|Activity Duration^right|SLA Achieved^left|SLA Comment^left|" +
                "Closed By^left")
                
            '</tr>'
            '</thead>'
        skip.


        END.


        {&prince}
            skip
            '<tr>'
            skip
            htmlib-MntTableField(html-encode(string(tt-ilog.issuenumber)),'right')

            htmlib-MntTableField(html-encode(string(tt-ilog.briefDescription)),'left')
            htmlib-MntTableField(html-encode(string(tt-ilog.iType)),'left')

            htmlib-MntTableField(html-encode(string(tt-ilog.RaisedLoginID)),'left')

            htmlib-MntTableField(html-encode(string(tt-ilog.AreaCode)),'left')
            htmlib-MntTableField(html-encode(string(tt-ilog.SLALevel)),'right')
            htmlib-MntTableField(html-encode(string(tt-ilog.CreateDate,"99/99/9999")),'right')
            htmlib-MntTableField(html-encode(string(tt-ilog.CreateTime,"hh:mm")),'right').
        
        IF tt-ilog.CompDate <> ? THEN
            {&prince}
        htmlib-MntTableField(html-encode(STRING(tt-ilog.CompDate,"99/99/9999")),'right')
        htmlib-MntTableField(html-encode(STRING(tt-ilog.CompTime,"hh:mm")),'right').
        ELSE
        {&prince}
            htmlib-MntTableField(html-encode(""),'right')
            htmlib-MntTableField(html-encode(""),'right').    

        {&prince}
        htmlib-MntTableField(html-encode(STRING(tt-ilog.ActDuration)),'right')
        htmlib-MntTableField(html-encode(STRING(tt-ilog.SLAAchieved)),'left')
        htmlib-MntTableField(REPLACE(tt-ilog.SLAComment,'~n','<br/>'),'left')

        htmlib-MntTableField(html-encode(STRING(tt-ilog.ClosedBy)),'left')



            SKIP .

        {&prince} '</tr>' SKIP.






        IF LAST-OF(tt-ilog.AccountNumber) THEN
        DO:
            {&prince} skip 
                htmlib-EndTable()
                skip.

            {&prince} htmlib-EndCriteria().


        END.


    END.
       

    DYNAMIC-FUNCTION("pxml-Footer",lc-global-company).
    DYNAMIC-FUNCTION("pxml-CloseStream").


    ll-ok = DYNAMIC-FUNCTION("pxml-Convert",lc-html,lc-pdf).

    OS-DELETE value(lc-html) no-error.
    
    IF ll-ok
        THEN ASSIGN pc-pdf = lc-pdf.
    */

END PROCEDURE.

PROCEDURE ip-PrintReport :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
/*
    DEFINE BUFFER customer     FOR customer.
    DEFINE BUFFER issue        FOR issue.
    
    FOR EACH tt-ilog NO-LOCK
        BREAK BY tt-ilog.AccountNumber
        BY tt-ilog.IssueNumber
        :

        IF FIRST-OF(tt-ilog.AccountNumber) THEN
        DO:
            FIND customer WHERE customer.CompanyCode = lc-global-company
                AND customer.AccountNumber = tt-ilog.AccountNumber
                NO-LOCK NO-ERROR.
            {&out} htmlib-BeginCriteria("Customer - " + tt-ilog.AccountNumber + " " + 
                customer.NAME) SKIP.
                
            {&out} skip
                replace(htmlib-StartMntTable(),'width="100%"','width="100%"') skip
                htmlib-TableHeading(
                "Issue Number^right|Description^left|Issue Class^left|Raised By^left|System^left|SLA Level^left|" +
                "Date Raised^right|Time Raised^left|Date Completed^right|Time Completed^left|Activity Duration^right|SLA Achieved^left|SLA Comment^left|" +
                "Closed By^left"
            ) skip.


        END.


        {&out}
            skip
            '<tr>'
            skip
            htmlib-MntTableField(html-encode(string(tt-ilog.issuenumber)),'right')

            htmlib-MntTableField(html-encode(string(tt-ilog.briefDescription)),'left')
            htmlib-MntTableField(html-encode(string(tt-ilog.iType)),'left')

            htmlib-MntTableField(html-encode(string(tt-ilog.RaisedLoginID)),'left')

            htmlib-MntTableField(html-encode(string(tt-ilog.AreaCode)),'left')
            htmlib-MntTableField(html-encode(string(tt-ilog.SLALevel)),'right')
            htmlib-MntTableField(html-encode(string(tt-ilog.CreateDate,"99/99/9999")),'right')
            htmlib-MntTableField(html-encode(string(tt-ilog.CreateTime,"hh:mm")),'right').
        
        IF tt-ilog.CompDate <> ? THEN
            {&out} 
        htmlib-MntTableField(html-encode(STRING(tt-ilog.CompDate,"99/99/9999")),'right')
        htmlib-MntTableField(html-encode(STRING(tt-ilog.CompTime,"hh:mm")),'right').
        ELSE
        {&out} 
            htmlib-MntTableField(html-encode(""),'right')
            htmlib-MntTableField(html-encode(""),'right').    

        {&out}
        htmlib-MntTableField(html-encode(STRING(tt-ilog.ActDuration)),'right')
        htmlib-MntTableField(html-encode(STRING(tt-ilog.SLAAchieved)),'left')
        htmlib-MntTableField(REPLACE(tt-ilog.SLAComment,'~n','<br/>'),'left')

        htmlib-MntTableField(html-encode(STRING(tt-ilog.ClosedBy)),'left')



            SKIP .

        {&out} '</tr>' SKIP.






        IF LAST-OF(tt-ilog.AccountNumber) THEN
        DO:
            {&out} skip 
                htmlib-EndTable()
                skip.

            {&out} htmlib-EndCriteria().


        END.


    END.
    */

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-ProcessReport) = 0 &THEN

PROCEDURE ip-ProcessReport :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/


    /*
    RUN rep/issuelogbuild.p (
        lc-global-company,
        lc-global-user,
        lc-lo-Account,
        lc-hi-Account,
        get-value("allcust") = "on",
        DATE(lc-lodate),
        DATE(lc-hidate),
        SUBSTR(TRIM(lc-classlist),2),
        OUTPUT TABLE tt-ilog

        ).
     */   

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-Selection) = 0 &THEN

PROCEDURE ip-Selection :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE iloop       AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cPart       AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cCode       AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE cDesc       AS CHARACTER     NO-UNDO.
    
    FIND this-user
        WHERE this-user.LoginID = lc-global-user NO-LOCK NO-ERROR.

           
    {&out}
    '<table align="center"><tr>' 
    '<td valign="top" align="right">' 
        (IF LOOKUP("lodate",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("From Date")
        ELSE htmlib-SideLabel("From Date"))
    '</td>'
    '<td valign="top" align="left">'
    htmlib-CalendarInputField("lodate",10,lc-lodate) 
    htmlib-CalendarLink("lodate")
    '</td>' SKIP
    '<td valign="top" align="right">' 
        (IF LOOKUP("hidate",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("To Date")
        ELSE htmlib-SideLabel("To Date"))
    '</td>'
    '<td valign="top" align="left">'
    htmlib-CalendarInputField("hidate",10,lc-hidate) 
    htmlib-CalendarLink("hidate")
    '</td>' skip.
    

    
  
    {&out} '</table>' skip.
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-Validate) = 0 &THEN

PROCEDURE ip-Validate :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      emails:       
    ------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pc-error-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-error-msg  AS CHARACTER NO-UNDO.


    DEFINE VARIABLE ld-lodate   AS DATE     NO-UNDO.
    DEFINE VARIABLE ld-hidate   AS DATE     NO-UNDO.
    DEFINE VARIABLE li-loop     AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lc-rowid    AS CHARACTER     NO-UNDO.

    ASSIGN
        ld-lodate = DATE(lc-lodate) no-error.
    IF ERROR-STATUS:ERROR 
        OR ld-lodate = ?
        THEN RUN htmlib-AddErrorMessage(
            'lodate', 
            'The from date is invalid',
            INPUT-OUTPUT pc-error-field,
            INPUT-OUTPUT pc-error-msg ).

    ASSIGN
        ld-hidate = DATE(lc-hidate) no-error.
    IF ERROR-STATUS:ERROR 
        OR ld-hidate = ?
        THEN RUN htmlib-AddErrorMessage(
            'hidate', 
            'The to date is invalid',
            INPUT-OUTPUT pc-error-field,
            INPUT-OUTPUT pc-error-msg ).

    IF ld-lodate > ld-hidate 
        THEN RUN htmlib-AddErrorMessage(
            'lodate', 
            'The date range is invalid',
            INPUT-OUTPUT pc-error-field,
            INPUT-OUTPUT pc-error-msg ).




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

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

PROCEDURE process-web-request :
    /*------------------------------------------------------------------------------
      Purpose:     Process the web request.
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE lc-filename AS CHARACTER NO-UNDO.
    
  
    {lib/checkloggedin.i}

    
    FIND this-user
        WHERE this-user.LoginID = lc-global-user NO-LOCK NO-ERROR.
   
    RUN ip-InitialProcess.

    IF request_method = "POST" THEN
    DO:
        
        
        RUN ip-Validate( OUTPUT lc-error-field,
            OUTPUT lc-error-msg ).

        IF lc-error-msg = "" THEN
        DO:
            RUN ip-ProcessReport.
            
            
            
        END.
    END.

    
    RUN outputHeader.

    {&out} DYNAMIC-FUNCTION('htmlib-CalendarInclude':U) skip.
    {&out} htmlib-Header("Engineer Time Management") skip.
    RUN ip-ExportJScript.
    {&out} htmlib-JScript-Maintenance() skip.
    {&out} htmlib-StartForm("mainform","post", appurl + '/rep/engtime.p' ) skip.
    {&out} htmlib-ProgramTitle("Engineer Time Management") 
    htmlib-hidden("submitsource","") skip.
    {&out} htmlib-BeginCriteria("Report Criteria").
    
    
    RUN ip-Selection.

    {&out} htmlib-EndCriteria().

    

    IF lc-error-msg <> "" THEN
    DO:
        {&out} '<BR><BR><CENTER>' 
        htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    END.

    {&out} '<center>' htmlib-SubmitButton("submitform","Report") 
    '</center>' skip.

    
    
    
    IF request_method = "POST" 
        AND lc-error-msg = "" THEN
    DO:
       
        
        
    END.



    
    {&out} htmlib-EndForm() skip.
    {&out} htmlib-CalendarScript("lodate") skip
           htmlib-CalendarScript("hidate") skip.
   

    {&OUT} htmlib-Footer() skip.


END PROCEDURE.


&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-Format-Select-Account) = 0 &THEN

FUNCTION Format-Select-Account RETURNS CHARACTER
    ( pc-htm AS CHARACTER ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE lc-htm AS CHARACTER NO-UNDO.

    lc-htm = REPLACE(pc-htm,'<select',
        '<select onChange="ChangeAccount()"')
        . 


    RETURN lc-htm.


END FUNCTION.


&ENDIF

