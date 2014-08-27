/***********************************************************************

    Program:        rep/issuelog.p
    
    Purpose:        Issue Log Report
    
    Notes:
    
    
    When        Who         What
    
    01/05/2014  phoski      Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lc-error-field AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-error-msg   AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-rowid       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-char        AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-lo-account  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-hi-account  AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-lodate      AS CHARACTER FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE lc-hidate      AS CHARACTER FORMAT "99/99/9999" NO-UNDO.

DEFINE BUFFER this-user FOR WebUser.
  
DEFINE VARIABLE ll-Customer   AS LOG       NO-UNDO.

DEFINE VARIABLE lc-list-acc   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-list-aname AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-filename   AS CHARACTER NO-UNDO.

DEFINE VARIABLE lr-UUID       AS RAW       NO-UNDO.
DEFINE VARIABLE lc-GenKey     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-CodeName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE li-loop       AS INTEGER   NO-UNDO.

DEFINE VARIABLE lc-ClassList  AS CHARACTER NO-UNDO.


{rep/issuelogtt.i}




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


    DEFINE BUFFER customer     FOR customer.
    DEFINE BUFFER issue        FOR issue.
    
  
   
    ASSIGN  
        lr-UUID = GENERATE-UUID
        lc-GenKey = GUID(lr-UUID).

    lc-filename = SESSION:TEMP-DIR + "/" + lc-GenKey
        + ".csv".

    OUTPUT TO VALUE(lc-filename).

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


END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-InitialProcess) = 0 &THEN

PROCEDURE ip-InitialProcess :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    IF ll-customer THEN
    DO:
        ASSIGN 
            lc-lo-account = this-user.AccountNumber
            .
        set-user-field("loaccount",this-user.AccountNumber).
        set-user-field("hiaccount",this-user.AccountNumber).


    END.
    ELSE
    DO:
        
    END.


    
    ASSIGN
        lc-lo-account = get-value("loaccount")
        lc-hi-account = get-value("hiaccount")    
        lc-lodate      = get-value("lodate")         
        lc-hidate      = get-value("hidate")
               
    
 
        .
    
    RUN com-GetCustomerAccount ( lc-global-company , lc-global-user, OUTPUT lc-list-acc, OUTPUT lc-list-aname ).



    IF request_method = "GET" THEN
    DO:
        
        IF lc-lodate = ""
            THEN ASSIGN lc-lodate = STRING(TODAY - 365, "99/99/9999").
        
        IF lc-hidate = ""
            THEN ASSIGN lc-hidate = STRING(TODAY, "99/99/9999").
        
        
        IF lc-lo-account = ""
            THEN ASSIGN lc-lo-account = ENTRY(1,lc-list-acc,"|").
    
        IF lc-hi-account = ""
            THEN ASSIGN lc-hi-account = ENTRY(NUM-ENTRIES(lc-list-acc,"|"),lc-list-acc,"|").

        DO li-loop = 1 TO NUM-ENTRIES(lc-global-iclass-code,"|"):
            lc-codeName = "chk" + ENTRY(li-loop,lc-global-iclass-code,"|").
            set-user-field(lc-codeName,"on").
        END.
    END.

    
    

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-PrintReport) = 0 &THEN

PROCEDURE ip-PrintReport :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

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
        htmlib-MntTableField(html-encode(STRING(tt-ilog.SLAComment)),'left')

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

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-ProcessReport) = 0 &THEN

PROCEDURE ip-ProcessReport :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/



    RUN rep/issuelogbuild.p (
        lc-global-company,
        lc-global-user,
        lc-lo-Account,
        lc-hi-Account,
        DATE(lc-lodate),
        DATE(lc-hidate),
        SUBSTR(TRIM(lc-classlist),2),
        OUTPUT TABLE tt-ilog

        ).



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

    IF NOT ll-customer
        THEN {&out}
    '<td align=right valign=top>' 
        (IF LOOKUP("loaccount",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("From Customer")
        ELSE htmlib-SideLabel("From Customer"))

    '</td>'
    '<td align=left valign=top>' 
    htmlib-Select("loaccount",lc-list-acc,lc-list-aname,lc-lo-account) '</td>'.

    
    {&out} 
    '<td valign="top" align="right">' 
        (IF LOOKUP("lodate",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("From Date")
        ELSE htmlib-SideLabel("From Date"))
    '</td>'
    '<td valign="top" align="left">'
    htmlib-CalendarInputField("lodate",10,lc-lodate) 
    htmlib-CalendarLink("lodate")
    '</td>' skip.

    IF NOT ll-customer
        THEN {&out}
    '</tr><tr>' SKIP
           '<td align=right valign=top>' 
           (if lookup("loaccount",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("To Customer")
            else htmlib-SideLabel("To Customer"))
        
        '</td>'
           '<td align=left valign=top>' 
                htmlib-Select("hiaccount",lc-list-acc,lc-list-aname,lc-hi-account) '</td>'.

    {&out} '<td valign="top" align="right">' 
        (IF LOOKUP("hidate",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("To Date")
        ELSE htmlib-SideLabel("To Date"))
    '</td>'
    '<td valign="top" align="left">'
    htmlib-CalendarInputField("hidate",10,lc-hidate) 
    htmlib-CalendarLink("hidate")
    '</td>' skip.

    {&out} '</tr>' SKIP.

    DO li-loop = 1 TO NUM-ENTRIES(lc-global-iclass-code,"|"):
        lc-codeName = "chk" + ENTRY(li-loop,lc-global-iclass-code,"|").

        {&out} '<tr><td valign="top" align="right">' 
        htmlib-SideLabel("Include Class " +  SUBSTR(lc-codeName,4))
        '</td>'
        '<td valign="top" align="left">'
        htmlib-checkBox(lc-CodeName,get-value(lc-CodeName) = "on")
        '</td></tr>' skip.


        
    END.

  
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

    IF lc-lo-account > lc-hi-account 
        THEN RUN htmlib-AddErrorMessage(
            'loaccount', 
            'The customer range is invalid',
            INPUT-OUTPUT pc-error-field,
            INPUT-OUTPUT pc-error-msg ).


    DO li-loop = 1 TO NUM-ENTRIES(lc-global-iclass-code,"|"):
        lc-codeName = "chk" + ENTRY(li-loop,lc-global-iclass-code,"|").
    
    
        IF get-value(lc-CodeName) = "on" THEN
        DO:
            lc-classlist = lc-ClassList + "," + 
                ENTRY(li-loop,lc-global-iclass-code,"|").
        END.
      
        
    END.
    IF TRIM(lc-classlist ) = "" 
        THEN RUN htmlib-AddErrorMessage(
            'Lalal', 
            'You must select one or more classes',
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
  
    {lib/checkloggedin.i}

    
    FIND this-user
        WHERE this-user.LoginID = lc-global-user NO-LOCK NO-ERROR.
    
    ASSIGN
        ll-customer = this-user.UserClass = "CUSTOMER".

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
    {&out} htmlib-Header("Issue Log") skip.
    RUN ip-ExportJScript.
    {&out} htmlib-JScript-Maintenance() skip.
    {&out} htmlib-StartForm("mainform","post", appurl + '/rep/issuelog.p' ) skip.
    {&out} htmlib-ProgramTitle("Issue Log") 
    htmlib-hidden("submitsource","") skip.
    {&out} htmlib-BeginCriteria("Report Criteria").
    
    {&out} '<table align=center><tr>' skip.

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
       
        RUN ip-PrintReport.   
        
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

