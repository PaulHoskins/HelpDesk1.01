&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

def var lc-error-field as char no-undo.
def var lc-error-msg   as char no-undo.

def var lc-rowid as char no-undo.
def var lc-char         as char no-undo.

def var lc-lo-account  as char no-undo.
def var lc-hi-account  as char no-undo.

def var lc-lodate       as char format "99/99/9999" no-undo.
def var lc-hidate       as char format "99/99/9999" no-undo.

def buffer this-user        for WebUser.
  
DEF VAR ll-Customer         AS LOG  NO-UNDO.

DEF VAR lc-list-acc         AS CHAR NO-UNDO.
DEF VAR lc-list-aname       AS CHAR NO-UNDO.

DEF VAR lc-filename     AS CHAR     NO-UNDO.

DEF VAR lr-UUID         AS RAW      NO-UNDO.
DEF VAR lc-GenKey       AS CHAR     NO-UNDO.
DEF VAR lc-CodeName     AS CHAR     NO-UNDO.
DEF VAR li-loop         AS INT      NO-UNDO.

DEF VAR lc-ClassList        AS CHAR NO-UNDO.


{rep/issuelogtt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-Format-Select-Account) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Account Procedure 
FUNCTION Format-Select-Account RETURNS CHARACTER
   ( pc-htm as char )  FORWARD.

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

&IF DEFINED(EXCLUDE-ip-ExportJScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportJScript Procedure 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ExportReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportReport Procedure 
PROCEDURE ip-ExportReport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEF BUFFER customer     FOR customer.
    DEF BUFFER issue        FOR issue.
    
  
   
    ASSIGN  lr-UUID = GENERATE-UUID
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
            string(tt-ilog.CreateTime,"hh:mm")
      
            IF tt-ilog.CompDate = ? THEN "" ELSE STRING(tt-ilog.CompDate,"99/99/9999")

            IF tt-ilog.CompTime = 0 THEN "" ELSE string(tt-ilog.CompTime,"hh:mm")
       
            tt-ilog.ActDuration
            tt-ilog.SLAAchieved
            tt-ilog.SLAComment
            tt-ilog.ClosedBy

           . 
           
    END.

    OUTPUT CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-InitialProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-InitialProcess Procedure 
PROCEDURE ip-InitialProcess :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if ll-customer then
    do:
        assign lc-lo-account = this-user.AccountNumber
               .
        set-user-field("loaccount",this-user.AccountNumber).
        set-user-field("hiaccount",this-user.AccountNumber).


    end.
    ELSE
    DO:
        
    END.


    
    assign
        lc-lo-account = get-value("loaccount")
        lc-hi-account = get-value("hiaccount")    
        lc-lodate      = get-value("lodate")         
        lc-hidate      = get-value("hidate")
               
    
 
        .
    
    RUN com-GetCustomerAccount ( lc-global-company , lc-global-user, output lc-list-acc, output lc-list-aname ).



    IF request_method = "GET" THEN
    DO:
        
        if lc-lodate = ""
        then assign lc-lodate = string(today - 365, "99/99/9999").
        
        if lc-hidate = ""
        then assign lc-hidate = string(today, "99/99/9999").
        
        
        if lc-lo-account = ""
        then assign lc-lo-account = ENTRY(1,lc-list-acc,"|").
    
        if lc-hi-account = ""
        then assign lc-hi-account = ENTRY(num-entries(lc-list-acc,"|"),lc-list-acc,"|").

        DO li-loop = 1 TO NUM-ENTRIES(lc-global-iclass-code,"|"):
            lc-codeName = "chk" + ENTRY(li-loop,lc-global-iclass-code,"|").
            set-user-field(lc-codeName,"on").
        END.
    END.

    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-PrintReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-PrintReport Procedure 
PROCEDURE ip-PrintReport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER customer     FOR customer.
    DEF BUFFER issue        FOR issue.
    
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
            htmlib-MntTableField(html-encode(string(tt-ilog.CompDate,"99/99/9999")),'right')
            htmlib-MntTableField(html-encode(string(tt-ilog.CompTime,"hh:mm")),'right').
        ELSE
        {&out} 
            htmlib-MntTableField(html-encode(""),'right')
            htmlib-MntTableField(html-encode(""),'right').    

        {&out}
            htmlib-MntTableField(html-encode(string(tt-ilog.ActDuration)),'right')
            htmlib-MntTableField(html-encode(string(tt-ilog.SLAAchieved)),'left')
            htmlib-MntTableField(html-encode(string(tt-ilog.SLAComment)),'left')

            htmlib-MntTableField(html-encode(string(tt-ilog.ClosedBy)),'left')



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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ProcessReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ProcessReport Procedure 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Selection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Selection Procedure 
PROCEDURE ip-Selection :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iloop       AS INT      NO-UNDO.
    DEF VAR cPart       AS CHAR     NO-UNDO.
    DEF VAR cCode       AS CHAR     NO-UNDO.
    DEF VAR cDesc       AS CHAR     NO-UNDO.
    
    find this-user
        where this-user.LoginID = lc-global-user no-lock no-error.

    if not ll-customer
    then {&out}
           '<td align=right valign=top>' 
            (if lookup("loaccount",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("From Customer")
            else htmlib-SideLabel("From Customer"))

         '</td>'
           '<td align=left valign=top>' 
                htmlib-Select("loaccount",lc-list-acc,lc-list-aname,lc-lo-account) '</td>'.

    
    {&out} 
            '<td valign="top" align="right">' 
            (if lookup("lodate",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("From Date")
            else htmlib-SideLabel("From Date"))
            '</td>'
            '<td valign="top" align="left">'
            htmlib-CalendarInputField("lodate",10,lc-lodate) 
            htmlib-CalendarLink("lodate")
            '</td>' skip.

    if not ll-customer
    then {&out}
           '</tr><tr>' SKIP
           '<td align=right valign=top>' 
           (if lookup("loaccount",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("To Customer")
            else htmlib-SideLabel("To Customer"))
        
        '</td>'
           '<td align=left valign=top>' 
                htmlib-Select("hiaccount",lc-list-acc,lc-list-aname,lc-hi-account) '</td>'.

    {&out} '<td valign="top" align="right">' 
          (if lookup("hidate",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("To Date")
          else htmlib-SideLabel("To Date"))
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Validate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Validate Procedure 
PROCEDURE ip-Validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  emails:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.


    def var ld-lodate   as date     no-undo.
    def var ld-hidate   as date     no-undo.
    def var li-loop     as int      no-undo.
    def var lc-rowid    as char     no-undo.

    assign
        ld-lodate = date(lc-lodate) no-error.
    if error-status:error 
    or ld-lodate = ?
    then run htmlib-AddErrorMessage(
                'lodate', 
                'The from date is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    assign
        ld-hidate = date(lc-hidate) no-error.
    if error-status:error 
    or ld-hidate = ?
    then run htmlib-AddErrorMessage(
                'hidate', 
                'The to date is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    if ld-lodate > ld-hidate 
    then run htmlib-AddErrorMessage(
                'lodate', 
                'The date range is invalid',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    if lc-lo-account > lc-hi-account 
    then run htmlib-AddErrorMessage(
                 'loaccount', 
                 'The customer range is invalid',
                  input-output pc-error-field,
                  input-output pc-error-msg ).


     DO li-loop = 1 TO NUM-ENTRIES(lc-global-iclass-code,"|"):
        lc-codeName = "chk" + ENTRY(li-loop,lc-global-iclass-code,"|").
    
    
         IF get-value(lc-CodeName) = "on" THEN
         DO:
           lc-classlist = lc-ClassList + "," + 
               ENTRY(li-loop,lc-global-iclass-code,"|").
         END.
      
        
    END.
    IF trim(lc-classlist ) = "" 
    THEN run htmlib-AddErrorMessage(
                 'Lalal', 
                 'You must select one or more classes',
                  input-output pc-error-field,
                  input-output pc-error-msg ).





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

    
    find this-user
        where this-user.LoginID = lc-global-user no-lock no-error.
    
    assign
        ll-customer = this-user.UserClass = "CUSTOMER".

    RUN ip-InitialProcess.

   if request_method = "POST" then
   do:
        
        
        RUN ip-Validate( output lc-error-field,
                         output lc-error-msg ).

        if lc-error-msg = "" then
        do:
            RUN ip-ProcessReport.
            
        end.
    end.

    
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

    

    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.

    {&out} '<center>' htmlib-SubmitButton("submitform","Report") 
               '</center>' skip.

    
    
    
    if request_method = "POST" 
    AND lc-error-msg = "" then
    do:
       
        RUN ip-PrintReport.   
        
    end.



    
    {&out} htmlib-EndForm() skip.
    {&out} htmlib-CalendarScript("lodate") skip
           htmlib-CalendarScript("hidate") skip.
   

    {&OUT} htmlib-Footer() skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-Format-Select-Account) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Account Procedure 
FUNCTION Format-Select-Account RETURNS CHARACTER
   ( pc-htm as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<select',
                   '<select onChange="ChangeAccount()"')
                   . 


  RETURN lc-htm.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

