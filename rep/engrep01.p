&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/engrep01.p
    
    Purpose:        Management Report - Web Page
    
    Notes:
    
    
    When        Who         What
    10/11/2010  DJS         Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-global-helpdesk    as char no-undo.
def var lc-global-reportpath  as char no-undo.

def var lc-error-field      as char no-undo.
def var lc-error-msg        as char no-undo.
def var lc-title            as char no-undo.

def var lc-reptypeA         as char no-undo.   
def var lc-reptypeE         as char no-undo.
def var lc-reptypeC         as char no-undo.
def var lc-reptype-checked  as char no-undo.
def var lc-selectengineer   as char no-undo.
def var lc-selectcustomer   as char no-undo.
def var lc-selectmonth      as char no-undo.
def var lc-selectweek       as char no-undo.
def var lc-selectyear       as char no-undo.

def var lc-date             as char no-undo.
def var lc-days             as char no-undo.
def var lc-pdf              as char no-undo.
def var lc-setrun           as log  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Date2Wk Procedure 
FUNCTION Date2Wk RETURNS INTEGER
  (input dMyDate as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Period) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Period Procedure 
FUNCTION Format-Select-Period RETURNS CHARACTER
  ( pc-htm as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Type) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Select-Type Procedure 
FUNCTION Format-Select-Type RETURNS CHARACTER
  ( pc-htm as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Submit-Button) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Format-Submit-Button Procedure 
FUNCTION Format-Submit-Button RETURNS CHARACTER
  ( pc-htm as char,
    pc-val as char)  FORWARD.

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
         WIDTH              = 34.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}
{lib/maillib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

{lib/checkloggedin.i}

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "BATCHPATH"
no-lock no-error.
assign lc-global-helpdesk =  WebAttr.AttrValue .

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "REPORTPATH"
no-lock no-error.
assign lc-global-reportpath =  WebAttr.AttrValue .

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-customer-select) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-customer-select Procedure 
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

    for each customer no-lock
       where customer.company = lc-global-company
          by customer.name:
 
      {&out}
            '<option value="'  customer.accountnumber '" ' '>'  html-encode(customer.name) '</option>' skip.
        end.
    {&out} '</select></div>'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-engcust-table) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-engcust-table Procedure 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-engineer-select) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-engineer-select Procedure 
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

    for each webUser no-lock
       where webuser.company = lc-global-company
       and   webuser.UserClass matches "*internal*"
       and   webuser.superuser = true
/*        and   webuser.JobTitle matches "*engineer*" */
        by webUser.name:

                
 
      {&out}
            '<option value="'  webUser.loginid '" ' '>'  html-encode(webuser.name) '</option>' skip.
 
        end.
  
      

    {&out} '</select></div>'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ExportJavascript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportJavascript Procedure 
PROCEDURE ip-ExportJavascript :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  
      {&out}
      '<script language="JavaScript">' skip


/*         function loopSelected()                                                    */
/*         {                                                                          */
/*           var txtSelectedValuesObj = document.getElementById('txtSelectedValues'); */
/*           var selectedArray = new Array();                                         */
/*           var selObj = document.getElementById('selSeaShells');                    */
/*           var i;                                                                   */
/*           var count = 0;                                                           */
/*           for (i=0; i<selObj.options.length; i++) {                                */
/*             if (selObj.options[i].selected) {                                      */
/*               selectedArray[count] = selObj.options[i].value;                      */
/*               count++;                                                             */
/*             }                                                                      */
/*           }                                                                        */
/*           txtSelectedValuesObj.value = selectedArray;                              */
/*         }                                                                          */




         
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-month-select) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-month-select Procedure 
PROCEDURE ip-month-select :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var lc-year  as char  no-undo.
def var zx       as int   no-undo.
def var lc-desc  as char  initial "January,February,March,April,May,June,July,August,September,October,November,December" no-undo.

 
    {&out}  '<div id="monthdiv" style="display:none;">' skip
      '<span class="tableheading" >Please select period(s)</span><br>' skip .
      
      
/*       '<select id="selectyear" name="selectyear" class="inputfield" align="top" >' skip.                                  */
/*                                                                                                                           */
/*       do zx = 0 to 4:                                                                                                     */
/*         lc-year = string(year(today) - zx).                                                                               */
/*       {&out}                                                                                                              */
/*             '<option value="' lc-year '" ' if zx = 0 then "selected" else "" ' >'  html-encode(lc-year) '</option>' skip. */
/*         end.                                                                                                              */
/*            {&out} '</select>' skip                                                                                        */

      {&out} 
            '<select id="selectmonth" name="selectmonth" class="inputfield" ' skip
            'multiple="multiple" size=8 width="150px" style="width:150px;" >' skip.
        {&out}
            '<option value="ALL" selected >Select All</option>' skip.
 
      do zx = 1 to 12 :
      {&out}
            '<option value="' string(zx,"99") '" >'  html-encode(entry(zx,lc-desc)) '</option>' skip.
        end.
     {&out} '</select></div>'.

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
DEF BUFFER BatchWork FOR BatchWork.

def var li-run      as int no-undo.
def var TYPEOF      as char initial "Detail,Summary_Detail,Summary" no-undo.
def var ISSUE       as char initial "Customer,Engineer,Issues"  no-undo.
def var CAL         as char initial "Week,Month" no-undo.
def var typedesc    as char initial "Detail,SumDet,Summary" no-undo.
def var engcust     as char initial "Cust,Eng,Iss"  no-undo.
def var weekly      as char initial "Week,Month" no-undo.
def var period      as char no-undo.
def var reportdesc  as char no-undo.
def var periodDesc as char no-undo.

/* build period string  */


assign period = if lc-reptypeC = "week" 
                then 
                  if num-entries(lc-selectweek) > 1 then string(string(entry(1,lc-selectweek),"99") + "-" + string(lc-selectyear,"9999") + "|" +  string(entry(num-entries(lc-selectweek),lc-selectweek),"99") + "-" + string(lc-selectyear,"9999")   )
                           else string(string(lc-selectweek,"99") + "-" + string(lc-selectyear,"9999"))
                else 
                  if num-entries(lc-selectmonth) > 1 then string(string(entry(1,lc-selectmonth),"99") + "-" + string(lc-selectyear,"9999") + "|" +  string(entry(num-entries(lc-selectmonth),lc-selectmonth),"99") + "-" + string(lc-selectyear,"9999")   )
                             else string(string(lc-selectmonth,"99") + "-" + string(lc-selectyear,"9999")).
   

if period begins "AL" then period = replace(period,"AL","ALL").


/* build report name  */

if index(period,"|") > 0 then periodDesc = replace(period,"|","_").
                         else periodDesc = period.

reportdesc = entry(lookup(lc-reptypeE,engcust  ) ,ISSUE ) + "_" 
           + entry(lookup(lc-reptypeA,typedesc ) ,TYPEOF) + "_" 
           + entry(lookup(lc-reptypeC,weekly   ) ,CAL   )  + "_" 
           + periodDesc.

/* fetch next report id  */
assign li-run = next-value(ReportNumber).

DO TRANSACTION:


create BatchWork  no-error.
assign
     BatchWork.BatchDate      = today
     BatchWork.BatchTime      = time
     BatchWork.BatchID        = li-run
     BatchWork.BatchProg      = "rep/engineerRep01.w"
     BatchWork.BatchUser      = lc-global-user
     BatchWork.Description    = reportdesc
     BatchWork.BatchParams[1] = lc-global-company                     /* lc-local-company     */ 
     BatchWork.BatchParams[2] = string(lookup(lc-reptypeA,typedesc))  /* lc-local-view-type   1=Detailed, 2=SummaryDetail, 3=Summary */
     BatchWork.BatchParams[3] = string(lookup(lc-reptypeE,engcust))   /* lc-local-report-type 1=Customer, 2=Engineer, 3=Issues       */
     BatchWork.BatchParams[4] = string(lookup(lc-reptypeC,weekly))    /* lc-local-period-type */
     BatchWork.BatchParams[5] = lc-selectengineer                     /* lc-local-customers   */ 
     BatchWork.BatchParams[6] = lc-selectcustomer                     /* lc-local-engineers   */ 
     BatchWork.BatchParams[7] = period                                /* lc-local-period      */ 
     BatchWork.BatchParams[8] = "offline"  /* ALWAYS!! */             /* lc-local-offline     */ 
.
 

MESSAGE "Batch ID = "  BatchWork.BatchID  LC-global-helpdesk SKIP.
RELEASE BatchWork.

END.



 os-command silent value("start /min " + lc-global-helpdesk + "\batchwork.bat " + string(li-run)).


 
assign lc-setrun = true.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-report-type) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-report-type Procedure 
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
      htmlib-Radio("reptype", "detail" , true ) '</td>'
      htmlib-TableField(html-encode("Detail"),'left') '</tr>' skip.
    
    {&out}
      htmlib-trmouse() '<td>' 
      htmlib-Radio("reptype" , "sumdet", false) '</td>'
      htmlib-TableField(html-encode("Summary Detail"),'left') '</tr>' skip.

    {&out}
      htmlib-trmouse() '<td>' 
      htmlib-Radio("reptype" , "summary", false) '</td>'
      htmlib-TableField(html-encode("Summary"),'left') '</tr>' skip.
    
    {&out} skip 
      htmlib-EndTable()
      skip.


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
 
 if lc-selectengineer begins "ALL," and num-entries(lc-selectengineer) > 1 then lc-selectengineer = substr(lc-selectengineer,index(lc-selectengineer,",") + 1).
 if lc-selectcustomer begins "ALL," and num-entries(lc-selectcustomer) > 1 then lc-selectcustomer = substr(lc-selectcustomer,index(lc-selectcustomer,",") + 1).
 if lc-selectmonth    begins "ALL," and num-entries(lc-selectmonth)    > 1 then lc-selectmonth = substr(lc-selectmonth,index(lc-selectmonth,",") + 1).
 if lc-selectweek     begins "ALL," and num-entries(lc-selectweek)     > 1 then lc-selectweek = substr(lc-selectweek,index(lc-selectweek,",") + 1).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-week-month) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-week-month Procedure 
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
      Format-Select-Period(htmlib-Radio("weekly", "week" , true ) ) '</td>'
      htmlib-TableField(html-encode("By Week"),'left') '</tr>' skip.
    
    {&out}
      htmlib-trmouse() '<td>' 
      Format-Select-Period(htmlib-Radio("weekly" , "month", false) ) '</td>'
      htmlib-TableField(html-encode("By Month"),'left') '</tr>' skip.
    
    {&out} skip 
      htmlib-EndTable()
      skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-week-select) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-week-select Procedure 
PROCEDURE ip-week-select :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var zx       as int   no-undo.
def var lc-year  as char  no-undo.

  
    
    {&out}  '<div id="weekdiv" style="display:block;">' skip
      '<span class="tableheading" >Please select period(s)</span><br>' skip .



/*       '<select id="selectyear" name="selectyear" class="inputfield" align="top" >' skip.                                  */
/*                                                                                                                           */
/*                                                                                                                           */
/*                                                                                                                           */
/*       do zx = 0 to 4:                                                                                                     */
/*                                                                                                                           */
/*         lc-year = string(year(today) - zx).                                                                               */
/*                                                                                                                           */
/*       {&out}                                                                                                              */
/*             '<option value="' lc-year '" ' if zx = 0 then "selected" else "" ' >'  html-encode(lc-year) '</option>' skip. */
/*                                                                                                                           */
/*         end.                                                                                                              */
/*     {&out} '</select>' skip                                                                                               */


    {&out} 
            '<select id="selectweek" name="selectweek" class="inputfield" ' skip
            'multiple="multiple" size=8 width="150px" style="width:150px;" >' skip.
  
        {&out}
            '<option value="ALL" selected >Select All</option>' skip.
 
      do zx = 1 to 53 :
  
 
      {&out}
            '<option value="' string(zx,"99") '" ' '>Week '  html-encode(string(zx,"99")) '</option>' skip.
 
        end.
  
      


      
 
      
     {&out} '</select></div>'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-year-select) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-year-select Procedure 
PROCEDURE ip-year-select :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var lc-year as char no-undo.
def var zx      as int  no-undo.

    {&out}  '<div id="yeardiv" style="display:block; margin-top:14px;">' skip
             
            '<select id="selectyear" name="selectyear" class="inputfield" ' skip
            '   >' skip.
  
 
 
      do zx = 0 to 4:
                
        lc-year = string(year(today) - zx).
 
      {&out}
            '<option value="' lc-year '" >'  html-encode(lc-year) '</option>' skip.
 
        end.
  
      

    {&out} '</select></div>'.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  emails:       
------------------------------------------------------------------------------*/
    
  {lib/checkloggedin.i} 
  
  find webuser where webuser.loginid = lc-global-user no-lock no-error.
  
  if request_method = "POST" then
  do:
      assign
          lc-reptypeA       = get-value("reptype")   /* 1=Detailed , 2=SummaryDetail, 3=Summary */ 
          lc-reptypeE       = get-value("engcust")
          lc-reptypeC       = get-value("weekly")
          lc-selectengineer = get-value("selectengineer")
          lc-selectcustomer = get-value("selectcustomer")
          lc-selectmonth    = get-value("selectmonth")      
          lc-selectweek     = get-value("selectweek") 
          lc-selectyear     = entry(1,get-value("selectyear")).  

      output to "C:\temp\djstest.txt" append.

      put unformatted
      "lc-reptypeA         "   lc-reptypeA        skip
      "lc-reptypeE         "   lc-reptypeE        skip
      "lc-reptypeC         "   lc-reptypeC        skip
      "lc-selectengineer   "   lc-selectengineer  skip
      "lc-selectcustomer   "   lc-selectcustomer  skip
      "lc-selectmonth      "   lc-selectmonth     skip
      "lc-selectweek       "   lc-selectweek      skip
      "lc-selectyear       "   lc-selectyear      skip(2).

      output close.

      run ip-Validate(output lc-error-field).

      if lc-error-field = "" then RUN ip-ProcessReport.
      
  end.

  if request_method <> "post"
    then assign lc-date = string(today,"99/99/9999")
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
    
    run ip-ExportJavascript.

    {&out} htmlib-StartTable("mnt",
                              0,
                              0,
                              5,
                              0,
                              "center") skip.

    {&out} '<TD VALIGN="TOP" ALIGN="center" WIDTH="200px">'  skip.
      run ip-report-type.
    {&out}         '</TD> ' skip.

   
    {&out} ' <TD VALIGN="TOP" ALIGN="center" WIDTH="200px">'  skip.
      run ip-engcust-table.
      run ip-week-month.
    {&out}         '</TD>' skip.
    
    {&out} '<TD VALIGN="TOP" ALIGN="center" HEIGHT="150px">'  skip.
       run ip-year-select.
    {&out}         '</TD>' skip.
     
    {&out} '<TD VALIGN="TOP" ALIGN="center" HEIGHT="150px">'  skip.
       run ip-week-select.
       run ip-month-select.
    {&out}         '</TD>' skip.
     
    {&out} '<TD VALIGN="TOP" ALIGN="center" HEIGHT="150px">'  skip.
      run ip-engineer-select.
      run ip-customer-select.
    {&out}         '</TD></TR>' skip.

    {&out} htmlib-EndTable() skip.


    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.
    
    {&out} '<center>' Format-Submit-Button("submitform","Report")
           '</center><br>' skip.
    
   {&out} htmlib-Hidden("submitsource","null").
  
  
   {&out} htmlib-EndForm() skip.

   {&out} '<div id="ajaxdiv"></div>' skip.

   find webuser where webuser.loginid = lc-global-user no-lock no-error.
   
   if avail webuser and dynamic-function("com-IsSuperUser",webuser.LoginID) then
   do:
       {&out} 
        '<script language="JavaScript" >' skip
         ' <!-- ' skip
          'function GetAlerts(target) ~{' skip
           '   var url = "' appurl '/rep/ajax/reportview.p?user=' webuser.LoginID '"' skip
           '   var myAjax = new Ajax.PeriodicalUpdater( target, url, ~{evalScripts:true, asynchronous:true, frequency:15 ~});' skip
           '~}' skip
          'function AjaxStartPage() ~{' skip
          ' GetAlerts("ajaxdiv")' skip
          '~}' skip
         'AjaxStartPage();' skip
         ' --> ' skip
         '</script>'.
   end.

   {&out} htmlib-Footer() skip.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Date2Wk Procedure 
FUNCTION Date2Wk RETURNS INTEGER
  (input dMyDate as date) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

def var cYear as char no-undo.
def var iDayNo as integer no-undo.
def var iCent as int no-undo.
def var iWkNo as int  no-undo.
assign
cYear = substring(string(dMyDate),7)
cYear = if length(cYear) = 4 then substring(cYear,3) else cYear
iCent = truncate(year(today) / 100,0)
iDayNo = dMyDate - date(12,31,(iCent * 100) + (integer(cYear) - 1)).
iWkNo = iDayNo / 7. 

return  iWkNo.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Period) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Period Procedure 
FUNCTION Format-Select-Period RETURNS CHARACTER
  ( pc-htm as char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<input',
                   '<input onClick="ChangeReportPeriod(this.value)"'). 


  RETURN lc-htm.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Select-Type) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Select-Type Procedure 
FUNCTION Format-Select-Type RETURNS CHARACTER
  ( pc-htm as char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var lc-htm as char no-undo.

  lc-htm = replace(pc-htm,'<input',
                   '<input onClick="ChangeReportType(this.value)"'). 


  RETURN lc-htm.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Format-Submit-Button) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Format-Submit-Button Procedure 
FUNCTION Format-Submit-Button RETURNS CHARACTER
  ( pc-htm as char,
    pc-val as char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var lc-htm as char no-undo.

  lc-htm = '<input onclick="return validateForm()" class="submitbutton" type="submit" name="' + pc-htm + '" value="' + pc-val + '"> ' .

 
  RETURN lc-htm.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

