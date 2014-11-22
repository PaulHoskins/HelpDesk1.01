/***********************************************************************

    Program:        rep/engrep01.p
    
    Purpose:        Management Report - Web Page
    
    Notes:
    
    
    When        Who         What
    10/11/2010  DJS         Initial
    21/11/2014  phoski      Fix it
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lc-global-helpdesk   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-global-reportpath AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-error-field       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-error-msg         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-title             AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-reptypeA          AS CHARACTER NO-UNDO.   
DEFINE VARIABLE lc-reptypeE          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-reptypeC          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-reptype-checked   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-selectengineer    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-selectcustomer    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-selectmonth       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-selectweek        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-selectyear        AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-date              AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-days              AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-pdf               AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-setrun            AS LOG       NO-UNDO.

DEFINE VARIABLE li-run               AS INTEGER   NO-UNDO.
DEFINE VARIABLE TYPEOF               AS CHARACTER INITIAL "Detail,Summary Detail,Summary" NO-UNDO.
DEFINE VARIABLE ISSUE                AS CHARACTER INITIAL "Customer,Engineer,Issues" NO-UNDO.
DEFINE VARIABLE CAL                  AS CHARACTER INITIAL "Week,Month" NO-UNDO.
DEFINE VARIABLE typedesc             AS CHARACTER INITIAL "Detail,SumDet,Summary" NO-UNDO.
DEFINE VARIABLE engcust              AS CHARACTER INITIAL "Cust,Eng,Iss" NO-UNDO.
DEFINE VARIABLE weekly               AS CHARACTER INITIAL "Week,Month" NO-UNDO.
DEFINE VARIABLE period               AS CHARACTER NO-UNDO.
DEFINE VARIABLE reportdesc           AS CHARACTER NO-UNDO.
DEFINE VARIABLE periodDesc           AS CHARACTER NO-UNDO.

{rep/engrep01-build.i}




/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no





/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

FUNCTION Date2Wk RETURNS INTEGER
    (INPUT dMyDate AS DATE)  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Period) = 0 &THEN

FUNCTION Format-Select-Period RETURNS CHARACTER
    ( pc-htm AS CHARACTER)  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Type) = 0 &THEN

FUNCTION Format-Select-Type RETURNS CHARACTER
    ( pc-htm AS CHARACTER)  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-Format-Submit-Button) = 0 &THEN

FUNCTION Format-Submit-Button RETURNS CHARACTER
    ( pc-htm AS CHARACTER,
    pc-val AS CHARACTER)  FORWARD.


&ENDIF


/* *********************** Procedure Settings ************************ */



/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.15
         WIDTH              = 34.29.
/* END WINDOW DEFINITION */
                                                                        */

/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}
{lib/maillib.i}
{lib/replib.i}




 




/* ************************  Main Code Block  *********************** */




/* Process the latest Web event. */
RUN process-web-request.



/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-customer-select) = 0 &THEN

PROCEDURE ip-customer-select :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    
 
    {&out}  '<div id="customerdiv" style="display:none;">' skip
            '<span class="tableheading" >Please select customer(s)</span><br>' skip
            '<select id="selectcustomer" name="selectcustomer" class="inputfield" ' skip
            'multiple="multiple" size=8 width="200px" style="width:200px;" >' skip.
 
    {&out}
    '<option value="ALL" selected >Select All</option>' skip.

    FOR EACH customer NO-LOCK
        WHERE customer.company = lc-global-company
        BY customer.name:
 
        {&out}
        '<option value="'  customer.accountnumber '" ' '>'  html-encode(customer.name) '</option>' skip.
    END.
    {&out} '</select></div>'.
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-engcust-table) = 0 &THEN

PROCEDURE ip-engcust-table :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
 

    {&out}
    htmlib-StartMntTable()
    htmlib-TableHeading("Customer or Engineer") skip.
    
    {&out}
    htmlib-trmouse() '<td>' skip
      Format-Select-Type(htmlib-Radio("engcust", "eng" , true ) ) '</td>' skip
      htmlib-TableField(html-encode("Engineer"),'left') '</tr>' skip.
    
    {&out}
    htmlib-trmouse() '<td>' skip
      Format-Select-Type(htmlib-Radio("engcust" , "cust", false) ) '</td>' skip
      htmlib-TableField(html-encode("Customer"),'left') '</tr>' skip.
    
    {&out} skip 
      htmlib-EndTable()
      skip.


END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-engineer-select) = 0 &THEN

PROCEDURE ip-engineer-select :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
  
 
    {&out}  '<div id="engineerdiv" style="display:block;">' skip
            '<span class="tableheading" >Please select engineer(s)</span><br>' skip
            '<select id="selectengineer" name="selectengineer" class="inputfield" ' skip
            'multiple="multiple" size=8 width="200px" style="width:200px;" >' skip.

 
    {&out}
    '<option value="ALL" selected >Select All</option>' skip.

    FOR EACH webUser NO-LOCK
        WHERE webuser.company = lc-global-company
        AND   webuser.UserClass = "internal"
        BY webUser.name:

                
 
        {&out}
        '<option value="'  webUser.loginid '" ' '>'  html-encode(webuser.name) '</option>' skip.
 
    END.
  
      

    {&out} '</select></div>'.


END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-ExportJavascript) = 0 &THEN

PROCEDURE ip-EngineerReport:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-rep-type      AS INT   NO-UNDO.
    
    DEFINE VARIABLE pc-local-period AS CHARACTER NO-UNDO.  
    
    
    {&out} '<table width=100% class="rptable">' SKIP.
    
    CASE pc-rep-type:
        WHEN 1 THEN
            DO:
                {&out} replib-TableHeading('Engineer^left|Week^left||Billable^right|Non Billable^right|Total^right') SKIP.
            END.
        WHEN 2 THEN
            DO:
            END.
        WHEN 3 THEN
            DO:
            END.
        
    END CASE.
    
    FOR EACH tt-IssRep NO-LOCK 
        BREAK BY tt-IssRep.ActivityBy 
        BY tt-IssRep.period-of 
        BY tt-IssRep.IssueNumber:
            
        IF FIRST-OF(tt-IssRep.ActivityBy) AND pc-rep-type = 1 THEN
        DO:
            FIND  tt-IssUser WHERE tt-IssUser.ActivityBy = tt-IssRep.ActivityBy AND tt-IssUser.period-of  = tt-IssRep.period-of NO-LOCK NO-ERROR.
            FIND tt-IssTotal WHERE tt-IssTotal.ActivityBy = tt-IssRep.ActivityBy  NO-LOCK NO-ERROR.
            {&out}
            '<tr>' SKIP
                  replib-RepField(tt-IssUser.ActivityBy,'','font-weight:bold')
                  replib-RepField('','','')
                  replib-RepField('','','')
                  replib-RepField(com-TimeToString(tt-IssTotal.billable),'right','font-weight:bold')
                  replib-RepField(com-TimeToString(tt-IssTotal.nonbillable),'right','font-weight:bold')
                  replib-RepField(com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable),'right','font-weight:bold')
                '</tr>' SKIP.
                
        END.
        
        
        IF FIRST-OF(tt-IssRep.IssueNumber) AND pc-rep-type <> 3 THEN
        DO:
            FIND tt-IssTime WHERE tt-IssTime.IssueNumber = tt-IssRep.IssueNumber AND tt-IssTime.ActivityBy = tt-IssRep.ActivityBy AND tt-IssTime.period =  tt-IssRep.period-of  NO-LOCK NO-ERROR.
            FIND Customer WHERE Customer.AccountNumber = tt-IssRep.AccountNumber 
                AND customer.companyCode  = lc-global-company NO-LOCK NO-ERROR.
            IF pc-rep-type = 1 THEN
            DO:
           
                {&out}
                '<tr>' SKIP
                    replib-RepField('','','')
                    replib-RepField('Issue Number','left','font-weight:bold')
                    replib-RepField("Contract Type          Date: " + string(tt-IssRep.IssueDate,"99/99/9999"),'left','font-weight:bold')
                    '</tr>' SKIP 
                               
                '<tr>' SKIP
                    replib-RepField('','','')
                    replib-RepField(STRING(tt-IssRep.IssueNumber),'left','')
                    replib-RepField(tt-IssRep.ContractType,'left','')
                    replib-RepField(com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0),"right","")
                    replib-RepField(com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0),"right","")
                    replib-RepField(com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.billable + tt-IssTime.nonbillable ELSE 0),"right","")
                    
                    
                    '</tr>' SKIP. 
                {&out} 
                '<tr>' SKIP
                        replib-RepField('','','')
                        replib-RepField('Client','left','')
                        replib-RepField(IF AVAILABLE customer THEN Customer.Name ELSE "Unknown",'left','')
                        '</tr>' SKIP
                        '<tr>' SKIP
                        replib-RepField('','','')
                        replib-RepField('Brief Description','left','')
                        replib-RepField(tt-IssRep.Description,'left','')
                        '</tr>' SKIP
                        '<tr>' SKIP
                        replib-RepField('','','')
                        replib-RepField('Action Desc','left','')
                       
                        replib-RepField(replace(tt-IssRep.ActionDesc,'~n','<br/>'),'left',' max-width: 100px;')
                        
                        '</tr>' SKIP
                        
                .
     
                                   
            END.
            
     
        
        /*
        IF pc-rep-type = 2 THEN
        DO:
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0).                                                       
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = com-TimeToString((IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0) + (IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0)).     
        END.
        ELSE  chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
     */
        END.
        
        IF pc-rep-type = 1 THEN
        DO:
            /*
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Activity".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-IssRep.ActivityType + " by: " + tt-IssRep.ActivityBy + " on: " + string(tt-IssRep.StartDate,"99/99/9999").
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Billable".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = IF tt-IssRep.Billable THEN "Yes" ELSE "No".
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Time".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssRep.Duration) .
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Activity Desc".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = safe-Chars(tt-IssRep.Notes).
            chWorkSheet:Range(cRange):WrapText = TRUE.
            chWorkSheet:Range(cRange):NumberFormat = "General".
            ExcelBorders("B" + cColumn,"C" + cColumn,"","","","","2","","","","1").
            */
            {&out} 
                '<tr>' SKIP
                replib-RepField('','','')
                        replib-RepField('Activity','left','')
                        replib-RepField(tt-IssRep.ActivityType + " by: " + tt-IssRep.ActivityBy + " on: " + string(tt-IssRep.StartDate,"99/99/9999"),'left','')
                        
                '</tr>' SKIP
                '<tr>' SKIP
                replib-RepField('','','')
                        replib-RepField('Billable','left','')
                        replib-RepField(IF tt-IssRep.Billable THEN "Yes" ELSE "No",'left','')
                        
                '</tr>' SKIP
                '<tr>' SKIP
                replib-RepField('','','')
                        replib-RepField('Time','left','')
                        replib-RepField(com-TimeToString(tt-IssRep.Duration),'left','')
                        
                '</tr>' SKIP
                
                '<tr>' SKIP
                replib-RepField('','','')
                        replib-RepField('Activity Desc','left','')
                        replib-RepField(replace(tt-IssRep.Notes,'~n','<br/>'),'left',' max-width: 100px;')
                       
                '</tr>' SKIP
                
                
                
                .
                
        END.
      
    
        
        
    END. /* each tt-Issrep */
    

    {&out} '</table>' SKIP.

END PROCEDURE.

PROCEDURE ip-ExportJavascript :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

  
    {&out}
    '<script language="JavaScript">' skip



         
       'function validateForm()' skip
        '~{' skip
        'var selectengineer = document.getElementById("selectengineer").value; ' skip
        'var selectcustomer = document.getElementById("selectcustomer").value; ' skip
        'var selectmonth    = document.getElementById("selectmonth").value; ' skip
        'var selectweek     = document.getElementById("selectweek").value; ' skip
        'var reptype        = document.getElementById("reptype").checked; ' skip
        'var engcust        = document.getElementById("engcust").checked; ' skip
        'var weekly         = document.getElementById("weekly").checked; ' skip
        'if (engcust) ~{' skip
        '  if ( selectengineer == "ALL" ) ~{' skip
        '   var answer = confirm("Selecting ALL Enginers may make this report\n   run for along time.  Are you sure?\n           (Cancel to change)");' skip
        '   if (answer) ~{ return true;  ~}' skip
        '   else ~{ return false; ~}' skip
        '  ~}' skip
        '~}' skip
        'else ~{' skip
        '  if ( selectcustomer == "ALL" ) ~{' skip
        '   var answer = confirm("Selecting ALL Customers may make this report\n   run for along time.  Are you sure?\n           (Cancel to change)");' skip
        '   if (answer) ~{ return true;  ~}' skip
        '   else ~{   return false; ~}' skip
        '  ~}' skip
        '~}' skip
        'if (weekly) ~{' skip
        '  if ( selectweek == "ALL" ) ~{' skip
        '   var answer = confirm("Selecting ALL Weeks may make this report\n   run for along time.  Are you sure?\n           (Cancel to change)");' skip
        '   if (answer) ~{ return true;  ~}' skip
        '   else ~{     return false; ~}' skip
        '  ~}' skip
        '~}' skip
        'else ~{' skip
        '  if ( selectmonth == "ALL" ) ~{' skip
        '   var answer = confirm("Selecting ALL Months may make this report\n   run for along time.  Are you sure?\n           (Cancel to change)");' skip
        '   if (answer) ~{ return true;  ~}' skip
        '   else ~{       return false; ~}' skip
        '  ~}' skip
        '~}' skip
        '~}' skip
       
        '</script>' skip.              
              
              
              
              
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-month-select) = 0 &THEN

PROCEDURE ip-GenerateReport:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE li-loop     AS INT      NO-UNDO.
    DEFINE BUFFER webuser       FOR webuser.
    DEFINE BUFFER customer      FOR Customer.
    
     
    /*
    lc-global-company,
            STRING(LOOKUP(lc-reptypeA,typedesc)),
            STRING(LOOKUP(lc-reptypeE,engcust)),
            STRING(LOOKUP(lc-reptypeC,weekly)),
            lc-selectengineer ,
            lc-selectcustomer ,
            period,
            OUTPUT TABLE tt-IssRep,
            OUTPUT TABLE tt-IssTime,
            OUTPUT TABLE tt-IssTotal,
            OUTPUT TABLE tt-IssUser,
            OUTPUT TABLE tt-IssCust,
            OUTPUT TABLE tt-IssTable,
            OUTPUT TABLE tt-ThisPeriod
       
    DEFINE INPUT PARAMETER pc-CompanyCode      AS CHARACTER NO-UNDO.
    /* 1=Detailed , 2=SummaryDetail, 3=Summary */ 
    DEFINE INPUT PARAMETER pc-ViewType    AS CHARACTER NO-UNDO.
    /* 1=Customer, 2=Engineer, 3=Issues */  
    DEFINE INPUT PARAMETER pc-ReportType  AS CHARACTER NO-UNDO.
    /* 1=Week, 2=Month  */
    DEFINE INPUT PARAMETER pc-PeriodType  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-Engineers    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-Customers    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-Period      AS CHARACTER NO-UNDO.
    */

    {&out} 'rep params = <br>' 
    "1= " STRING(LOOKUP(lc-reptypeA,typedesc)) '<br>'
    "2= " STRING(LOOKUP(lc-reptypeE,engcust)) '<br>'
    "3= " STRING(LOOKUP(lc-reptypeC,weekly)) '<br>'
    "4= " lc-selectengineer '<br>'
    "5= " lc-selectcustomer '<br>'
    "6= " period '<br>'.
    
    {&out} htmlib-BeginCriteria("Report Criteria").
    
    {&out} '<table align=center><tr>' skip.

    {&out} '<th valign="top">Report Type: </th><td valign="top">' 
    ENTRY(LOOKUP(lc-reptypeA,typedesc),typeof)
    '</td>' SKIP
           '<th valign="top">For: </th><td valign="top">' 
                entry(LOOKUP(lc-reptypeE,engcust),issue)
             '</td>' SKIP
           '<th valign="top">Period Type: </th><td valign="top">' 
              entry(LOOKUP(lc-reptypeC,weekly),cal) '</td>' SKIP
           '<th valign="top">Period(s): </th><td valign="top">' replace(period,"|","<br/>") '</td>' SKIP
           '<th valign="top">' IF LOOKUP(lc-reptypeE,engcust) = 1 THEN "Customer(s)"
                  ELSE 'Engineer(s)' ': </th><td valign="top">'.
                  
         
    IF LOOKUP(lc-reptypeE,engcust) = 2 THEN
    DO:
        IF lc-selectengineer <> "ALL" THEN
        DO li-loop = 1 TO NUM-ENTRIES(lc-selectengineer):
            FIND WebUser WHERE WebUser.LoginID = entry(li-loop,lc-selectEngineer) NO-LOCK NO-ERROR.
            IF AVAILABLE webuser THEN 
                {&out} WebUser.Name '<br/>'.
            ELSE 
            {&out} entry(li-loop,lc-selectEngineer) '<br/>'.
            
        END.
        ELSE {&out} lc-SelectEngineer.
        
    END.
    ELSE
    DO:
        IF lc-selectcustomer <> "ALL" THEN
        DO li-loop = 1 TO NUM-ENTRIES(lc-selectcustomer):
            FIND customer WHERE Customer.CompanyCode = lc-global-company
                AND Customer.AccountNumber = ENTRY(li-loop,lc-selectcustomer) NO-LOCK NO-ERROR.
            IF AVAILABLE customer THEN 
                {&out} Customer.Name '<br/>'.
            ELSE 
            {&out} entry(li-loop,lc-selectCustomer) '<br/>'.
            
        END.
        ELSE {&out} lc-SelectCustomer.
        
    END.
    
    
             
    {&out} '</td>' SKIP
    .
       
    {&out} '</tr></table>' skip.
    
    {&out} htmlib-EndCriteria().
    
                         
    /* LOOKUP(lc-reptypeA,typedesc) */
    
    {&out} htmlib-BeginCriteria("Report") '<div id="repdata">'.
       
    CASE STRING(LOOKUP(lc-reptypeE,engcust)):
        WHEN "1" THEN /* Customer */
            DO:
                
            END.
        WHEN "2" THEN /* Engineer */
            DO:
                RUN ip-EngineerReport (LOOKUP(lc-reptypeA,typedesc)).
                
            END.
        
    END.  
    
    {&out} '</div>
            'htmlib-EndCriteria().
       
        
        
    
END PROCEDURE.

PROCEDURE ip-month-select :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE lc-year  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE zx       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-desc  AS CHARACTER  INITIAL "January,February,March,April,May,June,July,August,September,October,November,December" NO-UNDO.

 
    {&out}  '<div id="monthdiv" style="display:none;">' skip
      '<span class="tableheading" >Please select period(s)</span><br>' skip .
      
      
                                                                                   

    {&out} 
    '<select id="selectmonth" name="selectmonth" class="inputfield" ' skip
            'multiple="multiple" size=8 width="150px" style="width:150px;" >' skip.
    {&out}
    '<option value="ALL" selected >Select All</option>' skip.
 
    DO zx = 1 TO 12 :
        {&out}
        '<option value="' STRING(zx,"99") '" >'  html-encode(ENTRY(zx,lc-desc)) '</option>' skip.
    END.
    {&out} '</select></div>'.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-ProcessReport) = 0 &THEN

PROCEDURE ip-ProcessReport :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    

    

    ASSIGN 
        period = IF lc-reptypeC = "week" 
                THEN 
                  IF NUM-ENTRIES(lc-selectweek) > 1 THEN STRING(STRING(ENTRY(1,lc-selectweek),"99") + "-" + string(lc-selectyear,"9999") + "|" +  string(ENTRY(NUM-ENTRIES(lc-selectweek),lc-selectweek),"99") + "-" + string(lc-selectyear,"9999")   )
                           ELSE STRING(STRING(lc-selectweek,"99") + "-" + string(lc-selectyear,"9999"))
                ELSE 
                  IF NUM-ENTRIES(lc-selectmonth) > 1 THEN STRING(STRING(ENTRY(1,lc-selectmonth),"99") + "-" + string(lc-selectyear,"9999") + "|" +  string(ENTRY(NUM-ENTRIES(lc-selectmonth),lc-selectmonth),"99") + "-" + string(lc-selectyear,"9999")   )
                             ELSE STRING(STRING(lc-selectmonth,"99") + "-" + string(lc-selectyear,"9999")).
   

    IF period BEGINS "AL" THEN period = REPLACE(period,"AL","ALL").


    

    RUN rep/engrep01-build.p
        (
        lc-global-company,
        STRING(LOOKUP(lc-reptypeA,typedesc)),
        STRING(LOOKUP(lc-reptypeE,engcust)),
        STRING(LOOKUP(lc-reptypeC,weekly)),
        lc-selectengineer ,
        lc-selectcustomer ,
        period,
        OUTPUT TABLE tt-IssRep,
        OUTPUT TABLE tt-IssTime,
        OUTPUT TABLE tt-IssTotal,
        OUTPUT TABLE tt-IssUser,
        OUTPUT TABLE tt-IssCust,
        OUTPUT TABLE tt-IssTable,
        OUTPUT TABLE tt-ThisPeriod
        ).
        
        



 
    ASSIGN 
        lc-setrun = TRUE.
       
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-report-type) = 0 &THEN

PROCEDURE ip-report-type :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    {&out}
    htmlib-StartMntTable()
    htmlib-TableHeading("Report Type") skip.
    
    {&out}
    htmlib-trmouse() '<td>' 
    htmlib-Radio("reptype", "detail" , TRUE ) '</td>'
    htmlib-TableField(html-encode("Detail"),'left') '</tr>' skip.
    
    {&out}
    htmlib-trmouse() '<td>' 
    htmlib-Radio("reptype" , "sumdet", FALSE) '</td>'
    htmlib-TableField(html-encode("Summary Detail"),'left') '</tr>' skip.

    {&out}
    htmlib-trmouse() '<td>' 
    htmlib-Radio("reptype" , "summary", FALSE) '</td>'
    htmlib-TableField(html-encode("Summary"),'left') '</tr>' skip.
    
    {&out} skip 
      htmlib-EndTable()
      skip.


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
 
    IF lc-selectengineer BEGINS "ALL," AND NUM-ENTRIES(lc-selectengineer) > 1 THEN lc-selectengineer = substr(lc-selectengineer,INDEX(lc-selectengineer,",") + 1).
    IF lc-selectcustomer BEGINS "ALL," AND NUM-ENTRIES(lc-selectcustomer) > 1 THEN lc-selectcustomer = substr(lc-selectcustomer,INDEX(lc-selectcustomer,",") + 1).
    IF lc-selectmonth    BEGINS "ALL," AND NUM-ENTRIES(lc-selectmonth)    > 1 THEN lc-selectmonth = substr(lc-selectmonth,INDEX(lc-selectmonth,",") + 1).
    IF lc-selectweek     BEGINS "ALL," AND NUM-ENTRIES(lc-selectweek)     > 1 THEN lc-selectweek = substr(lc-selectweek,INDEX(lc-selectweek,",") + 1).


END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-week-month) = 0 &THEN

PROCEDURE ip-week-month :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    {&out}
    htmlib-StartMntTable()
    htmlib-TableHeading("Week or Month") skip.
    
    {&out}
    htmlib-trmouse() '<td>' 
    Format-Select-Period(htmlib-Radio("weekly", "week" , TRUE ) ) '</td>'
    htmlib-TableField(html-encode("By Week"),'left') '</tr>' skip.
    
    {&out}
    htmlib-trmouse() '<td>' 
    Format-Select-Period(htmlib-Radio("weekly" , "month", FALSE) ) '</td>'
    htmlib-TableField(html-encode("By Month"),'left') '</tr>' skip.
    
    {&out} skip 
      htmlib-EndTable()
      skip.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-week-select) = 0 &THEN

PROCEDURE ip-week-select :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE zx       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-year  AS CHARACTER  NO-UNDO.

  
    
    {&out}  '<div id="weekdiv" style="display:block;">' skip
      '<span class="tableheading" >Please select period(s)</span><br>' skip .

    {&out} 
    '<select id="selectweek" name="selectweek" class="inputfield" ' skip
            'multiple="multiple" size=8 width="150px" style="width:150px;" >' skip.
  
    {&out}
    '<option value="ALL" selected >Select All</option>' skip.
 
    DO zx = 1 TO 53 :
  
 
        {&out}
        '<option value="' STRING(zx,"99") '" ' '>Week '  html-encode(STRING(zx,"99")) '</option>' skip.
 
    END.

      
    {&out} '</select></div>'.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-year-select) = 0 &THEN

PROCEDURE ip-year-select :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE lc-year AS CHARACTER NO-UNDO.
    DEFINE VARIABLE zx      AS INTEGER  NO-UNDO.

    {&out}  '<div id="yeardiv" style="display:block; margin-top:14px;">' skip
             
            '<select id="selectyear" name="selectyear" class="inputfield" ' skip
            '   >' skip.
  
 
 
    DO zx = 0 TO 4:
                
        lc-year = STRING(YEAR(TODAY) - zx).
 
        {&out}
        '<option value="' lc-year '" >'  html-encode(lc-year) '</option>' skip.
 
    END.
  
      

    {&out} '</select></div>'.
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

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
  
    FIND webuser WHERE webuser.loginid = lc-global-user NO-LOCK NO-ERROR.
  
    IF request_method = "POST" THEN
    DO:
        ASSIGN
            lc-reptypeA       = get-value("reptype")   /* 1=Detailed , 2=SummaryDetail, 3=Summary */ 
            lc-reptypeE       = get-value("engcust")
            lc-reptypeC       = get-value("weekly")
            lc-selectengineer = get-value("selectengineer")
            lc-selectcustomer = get-value("selectcustomer")
            lc-selectmonth    = get-value("selectmonth")      
            lc-selectweek     = get-value("selectweek") 
            lc-selectyear     = ENTRY(1,get-value("selectyear")).  

        OUTPUT to "C:\temp\djstest.txt".

        PUT UNFORMATTED
            "lc-reptypeA         "   lc-reptypeA        SKIP
            "lc-reptypeE         "   lc-reptypeE        SKIP
            "lc-reptypeC         "   lc-reptypeC        SKIP
            "lc-selectengineer   "   lc-selectengineer  SKIP
            "lc-selectcustomer   "   lc-selectcustomer  SKIP
            "lc-selectmonth      "   lc-selectmonth     SKIP
            "lc-selectweek       "   lc-selectweek      SKIP
            "lc-selectyear       "   lc-selectyear      SKIP(2).

        OUTPUT close.

        RUN ip-Validate(OUTPUT lc-error-field).

        IF lc-error-field = "" 
            THEN RUN ip-ProcessReport.
      
    END.

    IF request_method <> "post"
        THEN ASSIGN lc-date = STRING(TODAY,"99/99/9999")
            lc-days = "7".

    RUN outputHeader.  
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", appurl + '/rep/engrep01.p'  )
           htmlib-ProgramTitle("Engineers Time Report") skip.

    {&out}
    '<script language="JavaScript" src="/scripts/js/prototype.js"></script>' skip
    '<script language="JavaScript" src="/scripts/js/scriptaculous.js"></script>' skip
    '<script language="JavaScript" src="/scripts/js/effects.js"></script>' skip
    .
    
    RUN ip-ExportJavascript.
    IF request_method <> "POST" OR lc-error-field <> "" THEN
    DO:
         
        {&out} htmlib-StartTable("mnt",
            0,
            0,
            5,
            0,
            "center") skip.

        {&out} '<TD VALIGN="TOP" ALIGN="center" WIDTH="200px">'  skip.
        RUN ip-report-type.
        {&out}         '</TD> ' skip.

   
        {&out} ' <TD VALIGN="TOP" ALIGN="center" WIDTH="200px">'  skip.
        RUN ip-engcust-table.
        RUN ip-week-month.
        {&out}         '</TD>' skip.
    
        {&out} '<TD VALIGN="TOP" ALIGN="center" HEIGHT="150px">'  skip.
        RUN ip-year-select.
        {&out}         '</TD>' skip.
     
        {&out} '<TD VALIGN="TOP" ALIGN="center" HEIGHT="150px">'  skip.
        RUN ip-week-select.
        RUN ip-month-select.
        {&out}         '</TD>' skip.
     
        {&out} '<TD VALIGN="TOP" ALIGN="center" HEIGHT="150px">'  skip.
        RUN ip-engineer-select.
        RUN ip-customer-select.
        {&out}         '</TD></TR>' skip.

        {&out} htmlib-EndTable() skip.


        IF lc-error-msg <> "" THEN
        DO:
            {&out} '<BR><BR><CENTER>' 
            htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
        END.
    
        {&out} '<center>' Format-Submit-Button("submitform","Report")
        '</center><br>' skip.
    
        {&out} htmlib-Hidden("submitsource","").
  
  
    END.
    ELSE
    DO:
        RUN ip-GenerateReport.
    END.
    
    {&out} htmlib-EndForm() skip.
    
    
         
    {&out} htmlib-Footer() skip.
    

END PROCEDURE.


&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

FUNCTION Date2Wk RETURNS INTEGER
    (INPUT dMyDate AS DATE) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE cYear AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iDayNo AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCent AS INTEGER NO-UNDO.
    DEFINE VARIABLE iWkNo AS INTEGER  NO-UNDO.
    ASSIGN
        cYear = SUBSTRING(STRING(dMyDate),7)
        cYear = IF LENGTH(cYear) = 4 THEN SUBSTRING(cYear,3) ELSE cYear
        iCent = TRUNCATE(YEAR(TODAY) / 100,0)
        iDayNo = dMyDate - date(12,31,(iCent * 100) + (INTEGER(cYear) - 1)).
    iWkNo = iDayNo / 7. 

    RETURN  iWkNo.


END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Period) = 0 &THEN

FUNCTION Format-Select-Period RETURNS CHARACTER
    ( pc-htm AS CHARACTER) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE lc-htm AS CHARACTER NO-UNDO.

    lc-htm = REPLACE(pc-htm,'<input',
        '<input onClick="ChangeReportPeriod(this.value)"'). 


    RETURN lc-htm.

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Type) = 0 &THEN

FUNCTION Format-Select-Type RETURNS CHARACTER
    ( pc-htm AS CHARACTER) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE lc-htm AS CHARACTER NO-UNDO.

    lc-htm = REPLACE(pc-htm,'<input',
        '<input onClick="ChangeReportType(this.value)"'). 


    RETURN lc-htm.

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-Format-Submit-Button) = 0 &THEN

FUNCTION Format-Submit-Button RETURNS CHARACTER
    ( pc-htm AS CHARACTER,
    pc-val AS CHARACTER) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE lc-htm AS CHARACTER NO-UNDO.

    lc-htm = '<input onclick="return validateForm()" class="submitbutton" type="submit" name="' + pc-htm + '" value="' + pc-val + '"> ' .

 
    RETURN lc-htm.

END FUNCTION.


&ENDIF

