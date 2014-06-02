&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/engineerRep01.w
    
    Purpose:        Management Report - Actual Reports
    
    Notes:
    
    
    When        Who         What
    10/11/2010  DJS         Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */


{lib/common.i}
{lib/constants.i}

&if defined (UIB_is_Running) &then
def var lc-batch-id           as char no-undo.
def var lc-local-company      as char no-undo.
def var lc-local-view-type    as char no-undo.   /* 1=Detailed , 2=SummaryDetail, 3=Summary */ 
def var lc-local-report-type  as char no-undo.   /* 1=Customer, 2=Engineer, 3=Issues */  
def var lc-local-period-type  as char no-undo.   /* 1=Week, 2=Month  */
def var lc-local-engineers    as char no-undo.
def var lc-local-customers    as char no-undo.
def var lc-local-period       as char no-undo.
def var lc-local-offline      as char no-undo. 
&else
def input param lc-batch-id           as char no-undo.
def input param lc-local-company      as char no-undo.
def input param lc-local-view-type    as char no-undo.
def input param lc-local-report-type  as char no-undo.
def input param lc-local-period-type  as char no-undo.
def input param lc-local-engineers    as char no-undo.
def input param lc-local-customers    as char no-undo.
def input param lc-local-period       as char no-undo.
def input param lc-local-offline      as char no-undo.

&endif


def var lc-global-helpdesk      as char no-undo.
def var lc-global-reportpath    as char no-undo.
def var lc-FileDescription      as char format "x(70)" no-undo.
def var lc-FileSaveAs           as char format "x(170)" no-undo.
def var lc-FilePrefix           as char format "x(70)" no-undo.
def var lc-FileSuffix           as char format "x(70)" no-undo.
 
/* Local Variable Definitions ---                                       */

/* Local Variable Definitions ---                                       */
def var lc-rowid        as char no-undo.
def var lc-toolbarid    as char no-undo.

def buffer b-issue        for issue.
def buffer issue          for issue.
def buffer issAction      for issAction.
def buffer IssActivity    for IssActivity.

def var li-tot-billable             as int no-undo.
def var li-tot-nonbillable          as int no-undo.
def var li-tot-productivity         as dec no-undo.
def var li-tot-period-billable      as int no-undo.
def var li-tot-period-nonbillable   as int no-undo.
def var li-tot-period-productivity  as dec no-undo.


def temp-table issRep NO-UNDO like issActivity
  field AccountNumber like issue.AccountNumber
  field ActionDesc    like issAction.Notes
  field ActivityType  like issActivity.ContractType
  field IssueDate     like Issue.IssueDate
  field period-of     as int
  index i-cust AccountNumber  period-of
  index i-user ActivityBy  period-of.
 
def temp-table issTime NO-UNDO
  field IssueNumber   like issActivity.IssueNumber
  field AccountNumber like issue.AccountNumber
  field ActivityBy    like issActivity.ActivityBy
  field period-of     as int
  field billable      as int
  field nonbillable   as int
  index i-num IssueNumber  period-of.

def temp-table issTotal NO-UNDO
  field AccountNumber like issue.AccountNumber
  field ActivityBy    like issActivity.ActivityBy
  field billable      as int
  field nonbillable   as int
  field productivity  as dec
  index i-num AccountNumber  
  index i-by  ActivityBy.

def temp-table issUser NO-UNDO
  field ActivityBy    like issActivity.ActivityBy
  field period-of     as int
  field billable      as int
  field nonbillable   as int
  field productivity  as dec
  index i-num ActivityBy  period-of.

def temp-table issCust NO-UNDO
  field AccountNumber like issue.AccountNumber
  field period-of     as int
  field billable      as int
  field nonbillable   as int
  field num-issues    as int
  index i-num AccountNumber  period-of.

def temp-table issTable NO-UNDO like issue 
  index i-num AccountNumber.

def temp-table this-period no-undo
  field td-id         as char
  field td-period     as int
  field td-hours      as dec
  index i-week td-id td-period .

def buffer b-issRep   for issRep.
def buffer b-issTime  for issTime.
def buffer b-issTotal for issTotal.
def buffer b-issUser  for issUser.
def buffer b-issCust  for issCust.

def var lc-submitweek       as char     no-undo.
def var lc-submitday        as char extent 7    no-undo.
def var lc-submitreason     as char extent 7    no-undo.

def var hi-date             as date no-undo.
def var lo-date             as date no-undo.
def var vx                  as int  no-undo.
def var vc                  as char no-undo.   
                            
def var lc-error-field      as char no-undo.
def var lc-error-msg        as char no-undo.
def var lc-title            as char no-undo.
                            
                            
def var lc-lodate           as char no-undo.
def var lc-hidate           as char no-undo.
def var lc-pdf              as char no-undo.
                            
def var viewType            as int  no-undo.
def var reportType          as int  no-undo.
def var periodType          as int  no-undo.
def var periodDesc          as char no-undo.

def var li-curr-year        as int format "9999"  no-undo.
def var li-end-week         as int format "99"    no-undo.
def var ld-curr-hours       as dec format "9999.99" extent 7   no-undo.
def var lc-day              as char initial "Mon,Tue,Wed,Thu,Fri,Sat,Sun" no-undo.
def var ll-multi-period     as log  no-undo.
def var lc-period-array     as char no-undo.
def var lc-period           as char no-undo.

def var chExcelApplication  as com-handle.
def var chWorkbook          as com-handle.
def var chWorksheet         as com-handle.
def var chWorksheet2        as com-handle.
def var chChart             as com-handle.
def var chWorksheetRange    as com-handle.
def var objRange            as com-handle.
def var iColumn             as int initial 1  no-undo.
def var cColumn             as char no-undo.
def var cRange              as char no-undo.

def var pi-array    as int extent 2  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-CreateExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CreateExcel Procedure 
FUNCTION CreateExcel RETURNS LOGICAL
  ( offline as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Date2Wk Procedure 
FUNCTION Date2Wk RETURNS CHARACTER
  (input dMyDate as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dayOfWeek) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dayOfWeek Procedure 
FUNCTION dayOfWeek RETURNS INTEGER
  (input dMyDate as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExcelBorders) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ExcelBorders Procedure 
FUNCTION ExcelBorders RETURNS LOGICAL
  ( colF      as char,
    colT      as char,
    colColour as char,   
    edgeL     as char,   
    edgeT     as char,   
    edgeR     as char,   
    edgeB     as char,   
    lineL     as char,   
    lineT     as char,   
    lineR     as char,   
    lineB     as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FinishExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FinishExcel Procedure 
FUNCTION FinishExcel RETURNS LOGICAL
  ( offline as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDate Procedure 
FUNCTION getDate RETURNS CHARACTER
 (input dMyDate as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Mth2Date) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Mth2Date Procedure 
FUNCTION Mth2Date RETURNS CHARACTER
(cMthYrNo as char) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-percentage-calc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD percentage-calc Procedure 
FUNCTION percentage-calc RETURNS DECIMAL
  ( p-one as dec,
    p-two as dec )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-safe-Chars) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD safe-Chars Procedure 
FUNCTION safe-Chars RETURNS CHARACTER
  (  char_in as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ThisDate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ThisDate Procedure 
FUNCTION ThisDate RETURNS CHARACTER
  (input thisday as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Wk2Date) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Wk2Date Procedure 
FUNCTION Wk2Date RETURNS CHARACTER
 (cWkYrNo as char) FORWARD.

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
         HEIGHT             = 9.23
         WIDTH              = 34.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "BATCHPATH"
no-lock no-error.
assign lc-global-helpdesk =  WebAttr.AttrValue .

find WebAttr where WebAttr.SystemID = "BATCHWORK"
             and   WebAttr.AttrID   = "REPORTPATH"
no-lock no-error.
assign lc-global-reportpath =  WebAttr.AttrValue .

find first BatchWork where BatchWork.BatchID = integer(lc-batch-id) no-error.

/* output to "C:\temp\djstest2.txt" append.             */
/* put                                                  */
/* "lc-batch-id           "   lc-batch-id          skip */
/* "lc-local-company      "   lc-local-company     skip */
/* "lc-local-view-type    "   lc-local-view-type   skip */
/* "lc-local-report-type  "   lc-local-report-type skip */
/* "lc-local-period-type  "   lc-local-period-type skip */
/* "lc-local-engineers    "   lc-local-engineers   skip */
/* "lc-local-customers    "   lc-local-customers   skip */
/* "lc-local-period       "   lc-local-period      skip */
/* "lc-local-offline      "   lc-local-offline     skip */
/*                                                 skip */
/*                                                      */
/*   avail batchwork skip(2)                            */
/*   .                                                  */
/* output close.                                        */

if not avail BatchWork then return.

/* Process the latest Web event. */
RUN process-web-request no-error.

if not error-status:error  then
  assign BatchWork.BatchRun = true
         BatchWork.description = lc-FileDescription.
else assign BatchWork.description = "Failed".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Build-Year) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Build-Year Procedure 
PROCEDURE Build-Year :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param lc-loginid            as char no-undo.
def input param lc-period             as char no-undo.

def var vx                            as int  no-undo.
def var vz                            as int  no-undo.
def var zx                            as int  no-undo.
def var lc-date                       as char no-undo.
def var hi-pc-date                    as date no-undo.
def var lo-pc-date                    as date no-undo.
def var std-hours                     as dec format "99.99" no-undo.
def var tmp-hours                     as dec format "99.99" no-undo.
def var lc-list-reason-id             as char initial "|01|02|03|04|05|10"  no-undo.
def var lc-list-reason                as char initial "Select|BANK|LEAVE|SICK|DOC|DENT|OT"  no-undo.
def var lc-beg-wk                     as int  no-undo.
def var lc-end-wk                     as int  no-undo.
def var lc-tot-wk                     as int  no-undo.

empty temp-table this-period.

    for each WebStdTime where WebStdTime.CompanyCode = lc-local-company                      
                        and   WebStdTime.LoginID     = lc-loginid                             
                        and   WebStdTime.StdWkYear   = integer(lc-period)
                        no-lock:
          do vx = 1 to 7:
            assign tmp-hours         =   ((truncate(WebStdTime.StdAMEndTime[vx] / 100,0) + dec(WebStdTime.StdAMEndTime[vx] modulo 100 / 60))          /* convert time to decimal  */ 
                                       - (truncate(WebStdTime.StdAMStTime[vx] / 100,0) + dec(WebStdTime.StdAMStTime[vx] modulo 100 / 60)))            /* convert time to decimal  */ 
                                       + ((truncate(WebStdTime.StdPMEndTime[vx] / 100,0) + dec(WebStdTime.StdPMEndTime[vx] modulo 100 / 60))          /* convert time to decimal  */                               
                                       - (truncate(WebStdTime.StdPMStTime[vx] / 100,0) + dec(WebStdTime.StdPMStTime[vx] modulo 100 / 60)))            /* convert time to decimal  */ 
                   ld-curr-hours[vx] = tmp-hours                                                                                                                                       
                   std-hours         = std-hours + tmp-hours. 
           end.
    end.

    do vx = integer(entry(1,lc-period-array,",")) to integer(entry(num-entries(lc-period-array,","),lc-period-array,",")) :
      assign lc-date    = ""
             hi-pc-date = ?
             lo-pc-date = ?
             lc-beg-wk  = 0
             lc-end-wk  = 0
             lc-tot-wk  = 0
             tmp-hours  = 0.

      if periodType = 2 then /* Month */ 
      do:
        assign lc-date    = Mth2Date(string(string(vx,"99") + "-" + lc-period))
               hi-pc-date = date(entry(1,lc-date,"|"))
               lo-pc-date = date(entry(2,lc-date,"|"))

               lc-end-wk  = integer(entry(1,entry(2,lc-date,"|"),"/"))
               zx         = dayOfWeek(hi-pc-date)  /* if lc-beg-wk = 1 then 7 else lc-beg-wk - 1 */
          .
        do vz = 1 to lc-end-wk:
            tmp-hours = tmp-hours + ld-curr-hours[zx].
            if zx >= 7 then zx = 0.
            zx = zx + 1.
        end.
      end.
      else
        assign lc-date    = Wk2Date(string(string(vx,"99") + "-" + lc-period))
               hi-pc-date = date(entry(1,lc-date,"|"))
               lo-pc-date = date(entry(2,lc-date,"|"))
               tmp-hours  = std-hours.

      create this-period.
      assign td-id     = lc-loginid
             td-period = vx
             td-hours  = tmp-hours.
       
      for each WebUserTime where WebUserTime.CompanyCode = lc-local-company                      
                           and   WebUserTime.LoginID     = lc-loginid                             
                           and   WebUserTime.EventDate   >= hi-pc-date
                           and   WebUserTime.EventDate   <= lo-pc-date
                           no-lock:
        case WebUserTime.EventType :
          when "BANK"  then td-hours = td-hours - WebUserTime.EventHours.
          when "LEAVE" then td-hours = td-hours - WebUserTime.EventHours.
          when "SICK"  then td-hours = td-hours - WebUserTime.EventHours.
          when "DOC"   then td-hours = td-hours - WebUserTime.EventHours.
          when "DENT"  then td-hours = td-hours - WebUserTime.EventHours.
          when "OT"    then td-hours = td-hours + WebUserTime.EventHours.
        end case.
  
       
      end.
    end.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excelReportA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excelReportA Procedure 
PROCEDURE excelReportA :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/
def input param pc-rep-type     as int no-undo.
def var pc-local-period         as char no-undo.  
CreateExcel(lc-local-offline).                    /* Create Excel Application */
chWorkSheet = chExcelApplication:Sheets:Item(1).  /* get the active Worksheet */
chWorkSheet:Columns("A:G"):NumberFormat = "@".
chWorkSheet:PageSetup:Orientation = if pc-rep-type = 3 then {&xlPortrait} else {&xlLandscape} no-error.
chWorkSheet:Cells:Font:Name = 'Tahoma'.
/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 26.
chWorkSheet:Columns("B"):ColumnWidth = 12.
chWorkSheet:Columns("C"):ColumnWidth = if pc-rep-type = 1 then 50 else if pc-rep-type = 2 then 40 else  18.
chWorkSheet:Columns("D"):ColumnWidth = if pc-rep-type = 2 then 18 else 12.
chWorkSheet:Columns("E"):ColumnWidth = 12.
chWorkSheet:Columns("F"):ColumnWidth = 12.
if pc-rep-type = 2 then
do:
  chWorkSheet:Columns("G"):ColumnWidth = 12.
  chWorkSheet:Range("A1:G1"):Font:Bold = TRUE.
end.
else chWorkSheet:Range("A1:F1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Customer by " + lc-local-period-type + " - " + replace(periodDesc,"_"," to ").
chWorkSheet:Range("D1"):Value = "Report run:".
chWorkSheet:Range("E1"):Value = thisdate(today).
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Customer".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type <> 1 then lc-local-period-type else "".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 1 then "" else if pc-rep-type = 2 then "Brief Description" else  "Number of Issues" .
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then  "" else "Billlable".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "Billlable" else "Non Billable".               
cRange = "F" + cColumn.                               
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "Non Billable" else "Total".
if pc-rep-type = 2 then 
do:
  cRange = "G" + cColumn.
  chWorkSheet:Range(cRange):Value = "Total".
  ExcelBorders("A" + cColumn,"G" + cColumn,"36","1","1","1","1","1","1","1","1").
  chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
end.
else
do: 
  ExcelBorders("A" + cColumn,"F" + cColumn,"36","1","1","1","1","1","1","1","1").
  chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
end.

for each issRep break by issRep.AccountNumber by issRep.period-of by issRep.IssueNumber :

  if first-of(issRep.period-of) and pc-rep-type <> 1 then
  do:
    pc-local-period = string(issRep.period-of,"99") + "-" + lc-period.
    find  issCust where issCust.AccountNumber = issRep.AccountNumber 
                  and   issCust.period-of     = issRep.period-of no-lock no-error.
    find  Customer where Customer.CompanyCode  = lc-local-company   
                   and  Customer.AccountNumber = issRep.AccountNumber no-lock no-error.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = if first-of(issRep.AccountNumber) and avail Customer then if length(Customer.Name) > 23 then substr(Customer.Name,1,23) + " ... " else Customer.Name   else "".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value =  pc-local-period .
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 3 then string(issCust.num-issues) else "".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "" else com-TimeToString(issCust.billable).
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(issCust.billable) else com-TimeToString(issCust.nonbillable).
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(issCust.nonbillable) else com-TimeToString(issCust.billable + issCust.nonbillable).
    if pc-rep-type = 2 then
    do:
      cRange = "G" + cColumn.
      chWorkSheet:Range(cRange):Value = com-TimeToString(issCust.billable + issCust.nonbillable).
      chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
    end.
    else if pc-rep-type = 1 then chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
    
    if pc-rep-type <> 3 then
    do:
      find  issTime where issTime.IssueNumber = issRep.IssueNumber and issTime.AccountNumber = issRep.AccountNumber and issTime.period =  issRep.period-of  no-lock no-error.
      iColumn = iColumn + 1.
      cColumn = STRING(iColumn).
      cRange = "B" + cColumn.
      chWorkSheet:Range(cRange):Value = "Issue No".
      cRange = "C" + cColumn.
      chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "" else "Contract Type".
      cRange = "D" + cColumn.
      chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "Contract Type" else "".
      chWorkSheet:Range("A" + cColumn + ":D" + cColumn):Font:Bold = TRUE.
      if pc-rep-type = 2 then
      if first-of(issRep.AccountNumber) then ExcelBorders("A" + string(iColumn - 1),"G" + cColumn,"","1","1","1","1","1","1","1","1").  
                        else ExcelBorders("B" + string(iColumn - 1),"G" + cColumn,"","1","1","1","1","1","1","1","1").
    
    end.
  end.
  
  if first-of(issRep.AccountNumber) and pc-rep-type = 1 then
  do:
    find issCust where issCust.AccountNumber = issRep.AccountNumber  
                 and   issCust.period-of     = issRep.period-of  no-lock no-error.
    find issTotal where issTotal.AccountNumber = issRep.AccountNumber  no-lock no-error.
    find Customer where Customer.CompanyCode   = lc-local-company 
                  and   Customer.AccountNumber = issRep.AccountNumber no-lock no-error.
    
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = if avail Customer then if length(Customer.Name) > 23 then substr(Customer.Name,1,23) + " ... " else Customer.Name else "Unknown".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = pc-local-period.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.billable).
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.nonbillable).                     
    cRange = "F" + cColumn.          
    chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.billable + issTotal.nonbillable).
    chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
  end.
  
  if first-of(issRep.IssueNumber) and pc-rep-type <> 3 then
  do:
    find  issTime where issTime.IssueNumber = issRep.IssueNumber and issTime.AccountNumber = issRep.AccountNumber  and issTime.period =  issRep.period-of  no-lock no-error.
    if pc-rep-type = 1 then
    do:
      iColumn = iColumn + 1.
      cColumn = STRING(iColumn).
      cRange = "B" + cColumn.
      chWorkSheet:Range(cRange):Value = "Issue No".
      cRange = "C" + cColumn.
      chWorkSheet:Range(cRange):Value = "Contract Type          Date: " + string(issRep.IssueDate,"99/99/9999").
      chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
    end.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = string(issRep.IssueNumber).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then IssRep.Description else issRep.ContractType.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then issRep.ContractType else com-TimeToString(if avail issTime then issTime.billable else 0).
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(if avail issTime then issTime.billable else 0) else com-TimeToString(if avail issTime then issTime.nonbillable else 0).                     
    cRange = "F" + cColumn.                               
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(if avail issTime then issTime.nonbillable else 0) else com-TimeToString((if avail issTime then issTime.billable else 0) + (if avail issTime then issTime.nonbillable else 0)).
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString((if avail issTime then issTime.billable else 0) + (if avail issTime then issTime.nonbillable else 0)) else "".
    
    if pc-rep-type = 1 then
    do:
      chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
      iColumn = iColumn + 1.
      cColumn = STRING(iColumn).
      cRange = "B" + cColumn.
      chWorkSheet:Range(cRange):Value = "Description:".
      cRange = "C" + cColumn.
      chWorkSheet:Range(cRange):Value = safe-Chars(issRep.Description).
      
      iColumn = iColumn + 1.
      cColumn = STRING(iColumn).
      cRange = "B" + cColumn.
      chWorkSheet:Range(cRange):Value = "Action Desc:".
      cRange = "C" + cColumn.
      chWorkSheet:Range(cRange):Value = safe-Chars(issRep.ActionDesc).
      chWorkSheet:Range(cRange):WrapText = True.
      chWorkSheet:Range(cRange):NumberFormat = "General".
    end.
  end.
  
  if pc-rep-type = 1 then
  do:
    /*         find  Customer where Customer.AccountNumber = issRep.AccountNumber no-lock no-error. */
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Activity:".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = issRep.ActivityType + " by: " + issRep.ActivityBy + " on: " + string(issRep.StartDate,"99/99/9999").
    
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Billable:".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = if issRep.Billable then "Yes" else "No".
    
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Time:".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(issRep.Duration) .
    
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Activity Desc:".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = safe-Chars(issRep.Notes).
    chWorkSheet:Range(cRange):WrapText = True.
    chWorkSheet:Range(cRange):NumberFormat = "General".
    ExcelBorders("B" + cColumn,"C" + cColumn,"","","","","2","","","","1").
/*     iColumn = iColumn + 1. */
  end.
  if last-of(issRep.period-of) and pc-rep-type = 2 then
  do:
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value =  "Total".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(issCust.billable).
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(issCust.nonbillable).                     
    cRange = "G" + cColumn.                               
    chWorkSheet:Range(cRange):Value = com-TimeToString(issCust.billable + issCust.nonbillable).
    chWorkSheet:Range("D" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
    ExcelBorders("D" + cColumn,"G" + cColumn,"","2","1","2","1","1","1","1","1").
    iColumn = iColumn + 1.
  end.
  if last-of(issRep.AccountNumber) and pc-rep-type = 1 then
  do:
    find issTotal where issTotal.AccountNumber = issRep.AccountNumber  no-lock no-error.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Customer Total".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.billable).
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.nonbillable).
    cRange = "F" + cColumn.                               
    chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.billable + issTotal.nonbillable).
    chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
    iColumn = iColumn + 1.
    ExcelBorders("A" + cColumn,"F" + cColumn,"","","2","","1","","1","","1").
  end.
  if last-of(issRep.AccountNumber) and pc-rep-type <> 1 then
  do:
    find issTotal where issTotal.AccountNumber = issRep.AccountNumber  no-lock no-error.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 3 then  "Total" else "Customer Total".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 3 then com-TimeToString(issTotal.billable) else "".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 3 then com-TimeToString(issTotal.nonbillable) else com-TimeToString(issTotal.billable).
    cRange = "F" + cColumn.                               
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 3 then com-TimeToString(issTotal.billable + issTotal.nonbillable) else com-TimeToString(issTotal.nonbillable) .
    cRange = "G" + cColumn.                               
    chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(issTotal.billable + issTotal.nonbillable) else "".
    if pc-rep-type = 3 then ExcelBorders("C" + cColumn,"F" + cColumn,"","","2","","1","","1","","1").
    else ExcelBorders("C" + cColumn,"G" + cColumn,"","","1","","1","","1","","1").
    if pc-rep-type = 2 then chWorkSheet:Range("C" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
    iColumn = iColumn + 1.
  end.
  if last-of(issRep.AccountNumber) and pc-rep-type = 3 then  iColumn = iColumn + 1.
end.
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Report Total".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "" else com-TimeToString(li-tot-billable).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(li-tot-billable) else  com-TimeToString(li-tot-nonbillable).
cRange = "F" + cColumn.                               
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(li-tot-nonbillable) else com-TimeToString(li-tot-billable + li-tot-nonbillable).
if pc-rep-type = 2 then 
do:
  cRange = "G" + cColumn.                               
  chWorkSheet:Range(cRange):Value = com-TimeToString(li-tot-billable + li-tot-nonbillable).
  chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
  ExcelBorders("A" + cColumn,"G" + cColumn,"34","","1","","1","","1","","1").
end.
else
do:
  chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
  ExcelBorders("A" + cColumn,"F" + cColumn,"34","","1","","1","","1","","1").
end.
iColumn = iColumn + 1.
/*     chWorkSheet:Range("A1:A" + string(iColumn)):COLUMNS:AutoFit. */
chWorkSheet:Range("B1:B" + string(iColumn)):Columns:VerticalAlignment = 1  .
chWorkSheet:PageSetup:PrintArea = if pc-rep-type = 2 then "A1:G"+ string(iColumn) else "A1:F"+ string(iColumn) no-error.
chWorkSheet:PageSetup:Zoom = 90 no-error.
FinishExcel(lc-local-offline).                    /* Close Excel Application */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excelReportB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excelReportB Procedure 
PROCEDURE excelReportB :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/
def input param pc-rep-type as int  no-undo.
def var std-hours               as char no-undo.
def var pc-local-period         as char no-undo. 
CreateExcel(lc-local-offline).                    /* Create Excel Application */
chWorkSheet = chExcelApplication:Sheets:Item(1).  /* get the active Worksheet */
chWorkSheet:Columns("A:I"):NumberFormat = "@".
chWorkSheet:PageSetup:Orientation = {&xlLandscape} no-error.
chWorkSheet:Cells:Font:Name = 'Tahoma'.
/* set the column sizes for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 18.
chWorkSheet:Columns("B"):ColumnWidth = if pc-rep-type = 1 then 18 else 12.
chWorkSheet:Columns("C"):ColumnWidth = if pc-rep-type = 1 then 50 else if pc-rep-type = 2 then 26 else 18.
chWorkSheet:Columns("D"):ColumnWidth = if pc-rep-type = 2 then 26 else 12.
chWorkSheet:Columns("E"):ColumnWidth = if pc-rep-type = 2 then 18 else 12.
chWorkSheet:Columns("F"):ColumnWidth = 12.
if pc-rep-type = 2 then
do:
  chWorkSheet:Columns("G"):ColumnWidth = 12.
  chWorkSheet:Columns("H"):ColumnWidth = 12.
  chWorkSheet:Columns("I"):ColumnWidth = 15.
  /*       chWorkSheet:Range("A1:I1"):Font:Bold = TRUE. */
end.
else if pc-rep-type = 3 then
do:
  chWorkSheet:Columns("G"):ColumnWidth = 15.
  chWorkSheet:Range("A1:G1"):Font:Bold = TRUE.
end.
else chWorkSheet:Range("A1:F1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Engineer by " +  lc-local-period-type + " - " + replace(periodDesc,"_"," to ").
chWorkSheet:Range("D1"):Value = "Report run:".
chWorkSheet:Range("E1"):Value = thisdate(today).
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Engineer".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = lc-local-period-type.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 1 then " " else if pc-rep-type = 2 then  "Client" else  "Contract Time" . 
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "Brief Description" else "Billable". 
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "Contract Time" else "Non Billable".               
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "Billable" else "Total".
if pc-rep-type = 2 then
do:
  cRange = "G" + cColumn.
  chWorkSheet:Range(cRange):Value = "Non Billable" .
  cRange = "H" + cColumn.           
  chWorkSheet:Range(cRange):Value = "Total" .
  cRange = "I" + cColumn.    
  chWorkSheet:Range(cRange):Value = "Productivity %".
  ExcelBorders("A" + cColumn,"I" + cColumn,"36","1","1","1","1","1","1","1","1").
  chWorkSheet:Range("A" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
end.
else if pc-rep-type = 3 then
do:
  cRange = "G" + cColumn.                               
  chWorkSheet:Range(cRange):Value = "Productivity %".
  ExcelBorders("A" + cColumn,"G" + cColumn,"36","1","1","1","1","1","1","1","1").  
  chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
end.
else
do: 
  ExcelBorders("A" + cColumn,"F" + cColumn,"36","1","1","1","1","1","1","1","1").  
  chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
end.
/* END OF HEADINGS */
for each issRep break by issRep.ActivityBy by issRep.period-of by issRep.IssueNumber :
if first-of(issRep.period-of) and pc-rep-type <> 1 then
do:
  pc-local-period = string(issRep.period-of,"99") + "-" + lc-period.
  find issUser where issUser.ActivityBy = issRep.ActivityBy and   issUser.period-of  = issRep.period-of no-lock no-error.
  find issTotal where issTotal.ActivityBy = issRep.ActivityBy  no-lock no-error.
  assign std-hours = com-TimeToString(issUser.billable + issUser.nonbillable)
         std-hours = string(dec(integer( entry(1,std-hours,":")) + truncate(integer(entry(2,std-hours,":")) / 60,2))) .
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn).
  cRange = "A" + cColumn.
  chWorkSheet:Range(cRange):Value = if first-of(issRep.ActivityBy) then issUser.ActivityBy else "".
  cRange = "B" + cColumn.
  chWorkSheet:Range(cRange):Value = pc-local-period.
  cRange = "C" + cColumn.
  chWorkSheet:Range(cRange):Value = if pc-rep-type = 2  then "" else string(issUser.productivity,"zzz9.99") .
  cRange = "D" + cColumn.
  chWorkSheet:Range(cRange):Value = if pc-rep-type = 2  then "" else com-TimeToString(issUser.billable).
  cRange = "E" + cColumn.
  chWorkSheet:Range(cRange):Value = if pc-rep-type = 2  then string(issUser.productivity,"zzz9.99") else com-TimeToString(issUser.nonbillable).                     
  cRange = "F" + cColumn.
  chWorkSheet:Range(cRange):Value = if pc-rep-type = 2  then com-TimeToString(issUser.billable) else com-TimeToString(issUser.billable + issUser.nonbillable).      
  if pc-rep-type = 2 then
  do: 
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(issUser.nonbillable).        
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(issUser.billable + issUser.nonbillable).
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = string(percentage-calc(dec(std-hours),issUser.productivity),"zz9.99" ). 
    chWorkSheet:Range("A" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
  end.
  if pc-rep-type = 3 then
  do:
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = string(percentage-calc(dec(std-hours),issUser.productivity),"zz9.99" ). 
  end.
  if pc-rep-type = 1 then
  do:
    find issTime where issTime.IssueNumber = issRep.IssueNumber and issTime.ActivityBy = issRep.ActivityBy and issTime.period =  issRep.period-of  no-lock no-error.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Issue No".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value =  "Contract Type".
    chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
  end.
  if pc-rep-type = 2 then
  do:
    find issTime where issTime.IssueNumber = issRep.IssueNumber and issTime.ActivityBy = issRep.ActivityBy and issTime.period =  issRep.period-of  no-lock no-error.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Issue No".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value =  "Contract Type".
    chWorkSheet:Range("A" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
    if first-of(issRep.ActivityBy) then ExcelBorders("A" + string(iColumn - 1),"I" + cColumn,"","1","1","1","1","1","1","1","1").  
           else ExcelBorders("B" + string(iColumn - 1),"I" + cColumn,"","1","1","1","1","1","1","1","1").
  end.
end.
/* END OF SUB HEADING 1 */
if first-of(issRep.ActivityBy) and pc-rep-type = 1 then
do:
  find  issUser where issUser.ActivityBy = issRep.ActivityBy and issUser.period-of  = issRep.period-of no-lock no-error.
  find issTotal where issTotal.ActivityBy = issRep.ActivityBy  no-lock no-error.
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn).
  cRange = "A" + cColumn.
  chWorkSheet:Range(cRange):Value = issUser.ActivityBy.
  cRange = "B" + cColumn.
  chWorkSheet:Range(cRange):Value = pc-local-period.
  cRange = "D" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.billable).
  cRange = "E" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.nonbillable).
  cRange = "F" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.billable + issTotal.nonbillable).
  chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
end.
if first-of(issRep.IssueNumber) and pc-rep-type <> 3 then
do:
  find issTime where issTime.IssueNumber = issRep.IssueNumber and issTime.ActivityBy = issRep.ActivityBy and issTime.period =  issRep.period-of  no-lock no-error.
  find Customer where Customer.AccountNumber = issRep.AccountNumber no-lock no-error.
  if pc-rep-type = 1 then
  do:
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Issue No".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value =  "Contract Type          Date: " + string(issRep.IssueDate,"99/99/9999").
    chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
  end.
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn).
  cRange = "A" + cColumn.
  chWorkSheet:Range(cRange):Value = "".
  cRange = "B" + cColumn.
  chWorkSheet:Range(cRange):Value = string(issRep.IssueNumber).
  cRange = "C" + cColumn.
  chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then if avail customer then if length(Customer.Name) > 23 then substr(Customer.Name,1,23) + " ... " else Customer.Name else "Unknown" else  issRep.ContractType.
  cRange = "D" + cColumn.
  chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then if length(issRep.Description) > 23 then substr(issRep.Description,1,23) + " ... " else issRep.Description else com-TimeToString(if avail issTime then issTime.billable else 0).
  cRange = "E" + cColumn.
  chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then issRep.ContractType else com-TimeToString(if avail issTime then issTime.nonbillable else 0).                     
  cRange = "F" + cColumn.
  chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(if avail issTime then issTime.billable else 0) else com-TimeToString((if avail issTime then issTime.billable else 0) + (if avail issTime then issTime.nonbillable else 0)).
  if pc-rep-type = 2 then
  do:
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(if avail issTime then issTime.nonbillable else 0).                                                       
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString((if avail issTime then issTime.billable else 0) + (if avail issTime then issTime.nonbillable else 0)).     
  end.
  else  chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
  if pc-rep-type = 1 then
  do:
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Client".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = if avail customer then if length(Customer.Name) > 23 then substr(Customer.Name,1,23) + " ... " else Customer.Name else "Unknown".
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Brief Description".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = safe-Chars(issRep.Description).
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Action Desc".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = safe-Chars(issRep.ActionDesc).
    chWorkSheet:Range(cRange):WrapText = True.
    chWorkSheet:Range(cRange):NumberFormat = "General".
  end.
end.
if pc-rep-type = 1 then
do:
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn).
  cRange = "B" + cColumn.
  chWorkSheet:Range(cRange):Value = "Activity".
  cRange = "C" + cColumn.
  chWorkSheet:Range(cRange):Value = issRep.ActivityType + " by: " + issRep.ActivityBy + " on: " + string(issRep.StartDate,"99/99/9999").
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn).
  cRange = "B" + cColumn.
  chWorkSheet:Range(cRange):Value = "Billable".
  cRange = "C" + cColumn.
  chWorkSheet:Range(cRange):Value = if issRep.Billable then "Yes" else "No".
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn).
  cRange = "B" + cColumn.
  chWorkSheet:Range(cRange):Value = "Time".
  cRange = "C" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issRep.Duration) .
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn).
  cRange = "B" + cColumn.
  chWorkSheet:Range(cRange):Value = "Activity Desc".
  cRange = "C" + cColumn.
  chWorkSheet:Range(cRange):Value = safe-Chars(issRep.Notes).
  chWorkSheet:Range(cRange):WrapText = True.
  chWorkSheet:Range(cRange):NumberFormat = "General".
  ExcelBorders("B" + cColumn,"C" + cColumn,"","","","","2","","","","1").
end.
if last-of(issRep.period-of) and pc-rep-type = 2 then
do:
  find  issUser where issUser.ActivityBy = issRep.ActivityBy and   issUser.period-of  = issRep.period-of  no-lock no-error.
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn).
  cRange = "E" + cColumn.
  chWorkSheet:Range(cRange):Value =  "Total".
  cRange = "F" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issUser.billable).
  cRange = "G" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issUser.nonbillable).
  cRange = "H" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issUser.billable + issUser.nonbillable).
  cRange = "I" + cColumn.
  chWorkSheet:Range(cRange):Value = string(percentage-calc(dec(std-hours),issUser.productivity),"zz9.99" ). 
  chWorkSheet:Range("E" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
  ExcelBorders("E" + cColumn,"I" + cColumn,"","2","1","2","1","1","1","1","1").  
  iColumn = iColumn + 1. 
end.
if last-of(issRep.ActivityBy) and pc-rep-type = 1 then
do:
find issTotal where issTotal.ActivityBy = issRep.ActivityBy  no-lock no-error.
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn).
  cRange = "C" + cColumn.
  chWorkSheet:Range(cRange):Value = "Engineer Total".  
  cRange = "D" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.billable).
  cRange = "E" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.nonbillable).
  cRange = "F" + cColumn.
  chWorkSheet:Range(cRange):Value = com-TimeToString(issTotal.billable + issTotal.nonbillable).
  chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
  ExcelBorders("A" + cColumn,"F" + cColumn,"","","2","","1","","1","","1").
  iColumn = iColumn + 1.
end.
if last-of(issRep.ActivityBy) and pc-rep-type <> 1 then
do:  
  find issTotal where issTotal.ActivityBy = issRep.ActivityBy  no-lock no-error. 
  assign std-hours = com-TimeToString(issTotal.billable + issTotal.nonbillable)
         std-hours = string(dec(integer( entry(1,std-hours,":")) + truncate(integer(entry(2,std-hours,":")) / 60,2))) . 
  iColumn = iColumn + 1.
  cColumn = STRING(iColumn). 
  cRange = "B" + cColumn.
  chWorkSheet:Range(cRange):Value = if pc-rep-type = 3 then "Total" else "".
  cRange = "C" + cColumn.
  chWorkSheet:Range(cRange):Value =  if pc-rep-type = 3 then string(issTotal.productivity,"zzz9.99") else "" .
  cRange = "D" + cColumn.
  chWorkSheet:Range(cRange):Value =  if pc-rep-type = 3 then com-TimeToString(issTotal.billable) else "Engineer Total".
  cRange = "E" + cColumn.
  chWorkSheet:Range(cRange):Value =  if pc-rep-type = 3 then com-TimeToString(issTotal.nonbillable) else string(issTotal.productivity,"zzz9.99").
  cRange = "F" + cColumn.
  chWorkSheet:Range(cRange):Value =  if pc-rep-type = 3 then com-TimeToString(issTotal.billable + issTotal.nonbillable) else com-TimeToString(issTotal.billable) .
  cRange = "G" + cColumn.
  chWorkSheet:Range(cRange):Value =  if pc-rep-type = 3 then string(percentage-calc(dec(std-hours),issTotal.productivity),"zz9.99" ) else com-TimeToString(issTotal.nonbillable) .
  cRange = "H" + cColumn.
  chWorkSheet:Range(cRange):Value =  if pc-rep-type = 2 then com-TimeToString(issTotal.billable + issTotal.nonbillable) else "".
  cRange = "I" + cColumn.
  chWorkSheet:Range(cRange):Value =  if pc-rep-type = 2 then string(percentage-calc(dec(std-hours),issTotal.productivity),"zz9.99" ) else "" .
  if pc-rep-type = 3 then ExcelBorders("C" + cColumn,"G" + cColumn,"","","2","","1","","1","","1").
  else ExcelBorders("D" + cColumn,"I" + cColumn,"","","1","","1","","1","","1").
  if pc-rep-type = 2 then chWorkSheet:Range("D" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
  iColumn = iColumn + 1.
end.
end.
iColumn = iColumn + 2.
cColumn = STRING(iColumn).    
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Report Total".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "" else com-TimeToString(li-tot-billable).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then "" else com-TimeToString(li-tot-nonbillable).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(li-tot-billable) else com-TimeToString(li-tot-billable + li-tot-nonbillable).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(li-tot-nonbillable) else "" .
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = if pc-rep-type = 2 then com-TimeToString(li-tot-billable + li-tot-nonbillable) else "". 
if pc-rep-type = 3 then do:
  chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
  ExcelBorders("A" + cColumn,"G" + cColumn,"34","","1","","1","","1","","1").  
end.
else if pc-rep-type = 2 then do:
  chWorkSheet:Range("A" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
  ExcelBorders("A" + cColumn,"I" + cColumn,"34","","1","","1","","1","","1").  
end.
else do:
  chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
  ExcelBorders("A" + cColumn,"F" + cColumn,"34","","1","","1","","1","","1").  
end.
chWorkSheet:Range("B1:B" + string(iColumn + 1)):Columns:VerticalAlignment = 1  .
if pc-rep-type = 1 then chWorkSheet:PageSetup:PrintArea = "A1:F"+ string(iColumn + 1) no-error.
if pc-rep-type = 2 then chWorkSheet:PageSetup:PrintArea = "A1:I"+ string(iColumn + 1) no-error.
if pc-rep-type = 3 then chWorkSheet:PageSetup:PrintArea = "A1:G"+ string(iColumn + 1) no-error.
chWorkSheet:PageSetup:Zoom =  if pc-rep-type = 2 then 80 else 90 no-error.
if lc-local-offline = "online"  then chExcelApplication:Visible = true.
FinishExcel(lc-local-offline).  /* Close Excel Application */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excelReportC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excelReportC Procedure 
PROCEDURE excelReportC :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/
def input param pc-rep-type as int  no-undo.
CreateExcel(lc-local-offline).                    /* Create Excel Application */
chWorkSheet = chExcelApplication:Sheets:Item(1).  /* get the active Worksheet */
chWorkSheet:Columns("A:F"):NumberFormat = "@".
chWorkSheet:PageSetup:Orientation = {&xlLandscape} no-error.
/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 26.
chWorkSheet:Columns("B"):ColumnWidth = 18.
chWorkSheet:Columns("C"):ColumnWidth = 50.
chWorkSheet:Columns("D"):ColumnWidth = 12.
chWorkSheet:Columns("E"):ColumnWidth = 12.
chWorkSheet:Columns("F"):ColumnWidth = 12.
chWorkSheet:Range("A1:F1"):Font:Bold = TRUE.
chWorkSheet:Cells:Font:Name = 'Tahoma'.
chWorkSheet:Range("A1"):Value = "Issues by " + lc-local-period-type.
chWorkSheet:Range("B1"):Value = "".
chWorkSheet:Range("C1"):Value = "".
chWorkSheet:Range("D1"):Value = "Report run:".
chWorkSheet:Range("E1"):Value = thisdate(today).
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Engineer".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = lc-local-period-type.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value =  " ".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Billlable".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Non Billable".               
cRange = "F" + cColumn.                               
chWorkSheet:Range(cRange):Value = "Total".
objRange = chWorkSheet:Range("A" + cColumn + ":F" + cColumn).
objRange:Interior:ColorIndex = 36.
objRange:Borders({&xlEdgeLeft}):linestyle = {&xlContinuous}.
objRange:Borders({&xlEdgeTop}):linestyle = {&xlContinuous}.
objRange:Borders({&xlEdgeRight}):linestyle = {&xlContinuous}.
objRange:Borders({&xlEdgeBottom}):linestyle = {&xlContinuous}.
objRange:Borders({&xlEdgeLeft}):Weight = {&xlThick}.
objRange:Borders({&xlEdgeTop}):Weight = {&xlThick}.
objRange:Borders({&xlEdgeRight}):Weight = {&xlThick}.
objRange:Borders({&xlEdgeBottom}):Weight = {&xlThick}.
chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
for each issRep break by issRep.IssueNumber :
find  issUser where issUser.ActivityBy = issRep.ActivityBy no-lock no-error.
if first-of(issRep.IssueNumber) then
do:
find  issTime where issTime.IssueNumber = issRep.IssueNumber no-lock no-error.
iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Issue No".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value =  "Contract Type          Date: " + string(issRep.IssueDate,"99/99/9999").
chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = string(issRep.IssueNumber).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = issRep.ContractType.
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = com-TimeToString(if avail issTime then issTime.billable else 0).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = com-TimeToString(if avail issTime then issTime.nonbillable else 0).                     
cRange = "F" + cColumn.                               
chWorkSheet:Range(cRange):Value = com-TimeToString((if avail issTime then issTime.billable else 0) + (if avail issTime then issTime.nonbillable else 0)).
chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Description".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = safe-Chars(issRep.Description).
iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Action Desc".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = safe-Chars(issRep.ActionDesc).
chWorkSheet:Range(cRange):WrapText = True.
chWorkSheet:Range(cRange):NumberFormat = "General".
end.
find  Customer where Customer.CompanyCode   = lc-local-company 
               and   Customer.AccountNumber = issRep.AccountNumber no-lock no-error.
iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Activity".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = issRep.ActivityType + " for: " + if avail Customer then if length(Customer.Name) > 23 then substr(Customer.Name,1,23) + " ... " else Customer.Name else "Unknown".
iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Billable".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = if issRep.Billable then "Yes" else "No".
iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Time".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = com-TimeToString(issRep.Duration) .
iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Activity Desc".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = safe-Chars(issRep.Notes).
chWorkSheet:Range(cRange):WrapText = True.
chWorkSheet:Range(cRange):NumberFormat = "General".
iColumn = iColumn + 1.
end.
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Report Total".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value =  "".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = com-TimeToString(li-tot-billable).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = com-TimeToString(li-tot-nonbillable).                     
cRange = "F" + cColumn.                               
chWorkSheet:Range(cRange):Value = com-TimeToString(li-tot-billable + li-tot-nonbillable).
chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
iColumn = iColumn + 1.
objRange = chWorkSheet:Range("A"  + cColumn ,"F" + cColumn).
objRange:Interior:ColorIndex = 34.
objRange:Borders({&xlEdgeTop}):linestyle = {&xlContinuous}.
objRange:Borders({&xlEdgeTop}):Weight = {&xlThick}.
objRange:Borders({&xlEdgeBottom}):linestyle = {&xlContinuous}.
objRange:Borders({&xlEdgeBottom}):Weight = {&xlThick}.
chWorkSheet:Range("A1:A" + string(iColumn)):COLUMNS:AutoFit.
chWorkSheet:Range("B1:B" + string(iColumn)):Columns:VerticalAlignment = 1  .
chWorkSheet:PageSetup:PrintArea = "A1:F"+ string(iColumn) no-error.
chWorkSheet:PageSetup:Zoom = 90 no-error.
FinishExcel(lc-local-offline).      /* Close Excel Application */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  emails:       
------------------------------------------------------------------------------*/

def var vc          as char no-undo.
def var vx          as int  no-undo.
def var typedesc    as char initial "Detail,Summary_Detail,Summary" no-undo. 
def var engcust     as char initial "Customer,Engineer,Issues"  no-undo.
def var weekly      as char initial "Week,Month" no-undo.



assign
viewType   = integer(lc-local-view-type)         /* lc-local-view-type    1=Detailed , 2=SummaryDetail, 3=Summary */   
reportType = integer(lc-local-report-type)       /* lc-local-report-type  1=Customer, 2=Engineer, 3=Issues */            
periodType = integer(lc-local-period-type)       /* lc-local-period-type  1=Week, 2=Month  */                            
lc-local-view-type   = entry(viewType,typedesc)  /* set these to descriptions  */ 
lc-local-report-type = entry(reportType,engcust) /* set these to descriptions  */
lc-local-period-type = entry(periodType,weekly)  /* set these to descriptions  */
.
/* Get year from period - ignore month(s) or week(s) */
if index(lc-local-period,"|") = 0 then lc-period = entry(2,entry(1,lc-local-period,"|"),"-").
                                  else lc-period = entry(1,entry(2, lc-local-period ,"-"),"|").

if periodType = 1 then
do:
  if lc-local-period begins "ALL" then
  do:
    vc = Wk2Date("01-" + entry(2,lc-local-period,"-")).
    hi-date =  date(entry(1,vc,"|")). 
    vc =  Wk2Date(entry(1,getDate(  date("31/12/" + entry(2,lc-local-period,"-") )  ),"|") + "-" + entry(2,lc-local-period,"-")).
    lo-date =  date(entry(2,vc,"|")). 
  end.
  else if index(lc-local-period,"|") = 0 then 
  do:  
    vc = Wk2Date(lc-local-period).
    hi-date =  date(entry(1,vc,"|")). 
    lo-date =  date(entry(2,vc,"|")). 
  end.
  else
  do:
    vc = Wk2Date(entry(1,lc-local-period,"|")).
    hi-date =  date(entry(1,vc,"|")). 
    vc = Wk2Date(entry(2,lc-local-period,"|")).
    lo-date =  date(entry(2,vc,"|")). 
  end.
end.
else
do:
  if lc-local-period begins "ALL" then
  do:
    vc = Mth2Date("01-" + entry(2,lc-local-period,"-")).
    hi-date =  date(entry(1,vc,"|")). 
    vc =  Wk2Date(entry(1,getDate(  date("31/12/" + entry(2,lc-local-period,"-") )  ),"|") + "-" + entry(2,lc-local-period,"-")).
    lo-date =  date(entry(2,vc,"|")).
  end.
  else if index(lc-local-period,"|") = 0 then 
  do:  
    vc = Mth2Date(lc-local-period).
    hi-date =  date(entry(1,vc,"|")). 
    lo-date =  date(entry(2,vc,"|")). 
  end.
  else
  do:
    vc = Mth2Date(entry(1,lc-local-period,"|")).
    hi-date =  date(entry(1,vc,"|")). 
    vc = Mth2Date(entry(2,lc-local-period,"|")).
    lo-date =  date(entry(2,vc,"|")). 
  end.
end.

if lc-local-period begins "ALL" then /* we need to make the report split months/weeks */
do:
  ll-multi-period = true.
  if periodType = 1 then /* Week */
  do vx = 1 to integer(entry(2,getDate(date("31/12/" + entry(2,lc-local-period,"-"))),"|")) :
     lc-period-array = lc-period-array + string(vx) + ",".
  end.
  else
  do vx = 1 to 12 :
     lc-period-array = lc-period-array + string(vx) + ",".
  end.
end.
else
if index(lc-local-period,"|") > 0  then /* we need to make the report split months/weeks */
do:
  ll-multi-period = true.
  if periodType = 1 then /* Week */
  do vx = integer(entry(1,entry(1, lc-local-period ,"|"),"-")) to integer(entry(1,entry(2, lc-local-period ,"|"),"-")) :
     lc-period-array = lc-period-array + string(vx) + ",".
  end.
  else
  do vx = integer(entry(1,entry(1, lc-local-period ,"|"),"-")) to integer(entry(1,entry(2, lc-local-period ,"|"),"-"))  :
     lc-period-array = lc-period-array + string(vx) + ",".
  end.
end.
else lc-period-array = entry(1,entry(1, lc-local-period ,"|"),"-").

lc-period-array = trim(lc-period-array,",").

pi-array[1] = integer(entry(1,lc-period-array)).                           /* quick fix fo week no probs  */
pi-array[2] = integer(entry(num-entries(lc-period-array),lc-period-array)).


if index(lc-local-period,"|") > 0 then periodDesc = replace(lc-local-period,"|","_").
                                  else periodDesc = lc-local-period.

lc-FileDescription = entry(reportType,engcust) + "_" 
                     + entry(viewType,typedesc) + "_" 
                     + lc-local-period-type + "_" 
                     + periodDesc.
lc-FilePrefix = lc-global-reportpath + "\" + lc-batch-id + "_".
lc-FileSuffix = ".xls".
lc-FileSaveAs = lc-FilePrefix + lc-FileDescription + lc-FileSuffix.

if reportType = 1 then
do:
  for each IssActivity no-lock
     where IssActivity.companycode = lc-local-company
     and   IssActivity.StartDate >= hi-date
     and   IssActivity.StartDate <= lo-date
     :
     INNER: do:
      find issAction no-lock of IssActivity no-error .

      if avail issAction then
        find Issue no-lock
        where issue.companycode = lc-local-company
        and   Issue.IssueNumber = issAction.IssueNumber
        and   if lc-local-customers = "ALL" then true  else lookup(Issue.AccountNumber,lc-local-customers,",") > 0
        no-error.
          if not avail Issue then leave INNER.
             run ReportA(reportType) .
    end.
  end.
  run ReportC .
  run excelReportA(viewType) .
end.
else if reportType = 2 then
do:
  for each webuser no-lock
     where webuser.companycode = lc-local-company
     and if lc-local-engineers = "ALL" then true else  lookup(webuser.loginid,lc-local-engineers,",") > 0
     :
    for each IssActivity no-lock
       where IssActivity.CompanyCode = webuser.CompanyCode
         and IssActivity.ActivityBy  = webuser.loginid
         and IssActivity.StartDate >= hi-date
         and IssActivity.StartDate <= lo-date
         :

       find first issAction no-lock of issActivity.
       find first issue no-lock where issue.CompanyCode = webuser.CompanyCode
                                  and issue.IssueNumber = IssActivity.IssueNumber no-error.
         run ReportA(reportType).
    end.             
  end.               
  run ReportB.
  run excelReportB(viewType).
end.
else  
do:
    for each IssActivity no-lock
       where IssActivity.CompanyCode = lc-local-company
         and IssActivity.StartDate >= hi-date
         and IssActivity.StartDate <= lo-date
        :

       find first issAction no-lock of issActivity.
       find first issue no-lock where issue.CompanyCode = lc-local-company
                                  and issue.IssueNumber = IssActivity.IssueNumber no-error.
         run ReportA(reportType).
    end.             
  run ReportB.              
  run excelReportC(viewType).  
end.

  /* ------------------------------------------------------ */

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ReportA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReportA Procedure 
PROCEDURE ReportA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param reportType  as int  no-undo.

def var pi-period-of            as int  no-undo.
def var pi-period-billable      as int  no-undo. 
def var pi-period-nonbillable   as int  no-undo.
def var pi-period-productivity  as dec  no-undo.
def var pi-period-num-issues    as int  no-undo.

   find first ContractType no-lock where ContractType.CompanyCode  = Issue.CompanyCode
                                   and ContractType.ContractNumber = Issue.ContractType no-error.

   pi-period-of = integer(entry(periodType,getDate(IssActivity.StartDate),"|")).

/*    if pi-period-of < pi-array[1] or pi-period-of > pi-array[2] then return. /* quick fix fo week no probs  */  */

   find first issRep where issRep.IssueNumber   = IssActivity.IssueNumber 
                     and   issRep.IssActionID   = IssActivity.IssActionID
                     and   issRep.IssActivityID = IssActivity.IssActivityID
                     and   issRep.AccountNumber = Issue.AccountNumber 
                     and   issRep.period-of     = pi-period-of no-error.
   if not avail issRep then
   do:
     create issRep.
     buffer-copy issActivity to issRep.
   end.
   assign issRep.AccountNumber = issue.AccountNumber
          issRep.ActionDesc    = issAction.Notes
          issRep.ActivityType  = IssActivity.ActDescription
          issRep.ContractType  = if avail ContractType then ContractType.Description else "Ad Hoc" 
          issRep.IssueDate     = issue.IssueDate
          issRep.period-of     = pi-period-of.
/* TIME RECORDS */
   find first issTime where issTime.IssueNumber   = IssActivity.IssueNumber 
                      and   issTime.period-of     = pi-period-of  
                      and  (if reportType = 1 then issTime.AccountNumber = issue.AccountNumber 
                                              else issTime.ActivityBy    = IssActivity.ActivityBy )
                      no-error.
   if not avail issTime then
   do: 
     create issTime.                    
     assign issTime.IssueNumber         = IssActivity.IssueNumber
            issTime.AccountNumber       = issue.AccountNumber
            issTime.ActivityBy          = IssActivity.ActivityBy
            issTime.period-of           = pi-period-of
            issTime.billable            = if IssActivity.Billable then IssActivity.Duration else 0
            issTime.nonbillable         = if not IssActivity.Billable then IssActivity.Duration else 0.
   end.
   else
     assign issTime.billable            = if IssActivity.Billable then issTime.billable + IssActivity.Duration else issTime.billable
            issTime.nonbillable         = if not IssActivity.Billable then issTime.nonbillable + IssActivity.Duration else issTime.nonbillable.

/* TOTAL RECORDS */
  assign li-tot-billable    = if IssActivity.Billable then li-tot-billable + IssActivity.Duration else li-tot-billable              
         li-tot-nonbillable = if not IssActivity.Billable then li-tot-nonbillable + IssActivity.Duration else li-tot-nonbillable. 

   if reportType = 1 then find first issTotal where issTotal.AccountNumber = issue.AccountNumber no-error.
   if reportType = 2 then find first issTotal where issTotal.ActivityBy = IssActivity.ActivityBy no-error.
   if not avail issTotal then
   do: 
     create issTotal.                    
     assign issTotal.AccountNumber       = if reportType = 1 then issue.AccountNumber else ""
            issTotal.ActivityBy          = if reportType = 2 then IssActivity.ActivityBy else ""
            issTotal.billable            = if IssActivity.Billable then IssActivity.Duration else 0
            issTotal.nonbillable         = if not IssActivity.Billable then IssActivity.Duration else 0. 
   end.
   else
     assign issTotal.billable            = if IssActivity.Billable then issTotal.billable + IssActivity.Duration else issTotal.billable
            issTotal.nonbillable         = if not IssActivity.Billable then issTotal.nonbillable + IssActivity.Duration else issTotal.nonbillable.    

/* USER RECORDS */
  find issUser where issUser.ActivityBy = IssActivity.ActivityBy 
               and   issUser.period-of  = pi-period-of no-error.
  if not avail issUser then 
  do:
    create issUser.
    assign issUser.ActivityBy = IssActivity.ActivityBy
           issUser.period-of  = pi-period-of.
  end.
  assign issUser.billable           =  if IssActivity.Billable then issUser.billable + IssActivity.Duration else issUser.billable              
         issUser.nonbillable        =  if not IssActivity.Billable then issUser.nonbillable + IssActivity.Duration else issUser.nonbillable.
/* CUSTOMER RECORDS */
  find issCust where issCust.AccountNumber = issue.AccountNumber 
               and   issCust.period-of     = pi-period-of no-error.
  if not avail issCust then 
  do:
    create issCust.
    assign issCust.AccountNumber = issue.AccountNumber
           issCust.period-of     = pi-period-of.
  end.                                                 
    assign issCust.billable           =  if IssActivity.Billable then issCust.billable + IssActivity.Duration else issCust.billable              
           issCust.nonbillable        =  if not IssActivity.Billable then issCust.nonbillable + IssActivity.Duration else issCust.nonbillable.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ReportB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReportB Procedure 
PROCEDURE ReportB :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



for each webuser no-lock
   where webuser.companycode = lc-local-company
   and if lc-local-engineers = "ALL" then true else  lookup(webuser.loginid,lc-local-engineers,",") > 0
   :
    li-tot-productivity = 0.
    run Build-Year( webuser.loginid ,
                    lc-period ) no-error.
    for each this-period:
      find issUser where issUser.ActivityBy = webuser.loginid
                   and   issUser.period-of  = td-period
                   no-error.
      if avail issUser then 
         assign issUser.productivity  = td-hours
                li-tot-productivity   = li-tot-productivity + td-hours. 
    end.
    find issTotal where issTotal.ActivityBy = webuser.loginid no-error.
        if avail issTotal then assign issTotal.productivity = li-tot-productivity.
end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ReportC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReportC Procedure 
PROCEDURE ReportC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var pi-num-issues   as int  extent 55 no-undo.     
def var pi-period-of    as int  no-undo.
  
  for each Customer no-lock
     where Customer.companycode = lc-local-company
     and  if lc-local-customers = "ALL" then true else  lookup(Customer.AccountNumber,lc-local-customers,",") > 0
     break by Customer.AccountNumber: 
    
    assign pi-num-issues = 0.
    
    for each issue of customer no-lock where issue.IssueDate >= hi-date 
                                       and   issue.IssueDate <= lo-date  break by issue.IssueNumber :
    
      pi-period-of = integer(entry(periodType,getDate(issue.IssueDate),"|")).
  
      pi-num-issues[pi-period-of] = pi-num-issues[pi-period-of]  + 1.

    end.

    for each issCust where issCust.AccountNumber = Customer.AccountNumber:
       assign issCust.num-issues   = pi-num-issues[issCust.period-of].
    end.

  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-CreateExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CreateExcel Procedure 
FUNCTION CreateExcel RETURNS LOGICAL
  ( offline as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CREATE "Excel.Application" chExcelApplication.                   /* create a new Excel Application object */
    chExcelApplication:DisplayAlerts = FALSE.
    chExcelApplication:interactive   = offline = "online".
    if offline = "online"  then chExcelApplication:Visible = true.   /* launch Excel so it is visible to the user */
                           else chExcelApplication:Visible = false.
    chExcelApplication:ErrorCheckingOptions:NumberAsText = FALSE.
    chWorkbook = chExcelApplication:Workbooks:Add().                 /* create a new Workbook */ 

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Date2Wk Procedure 
FUNCTION Date2Wk RETURNS CHARACTER
  (input dMyDate as date) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  /* returns DAY WEEK YEAR */
  def var cYear     as char no-undo.
  def var iWkNo     as int  no-undo.
  def var iDayNo    as int  no-undo.
  def var dYrBegin  as date no-undo.
  def var WkOne     as int  no-undo.
  def var WkSt      as int  initial 2 no-undo. /* 1=Sun,2=Mon */
  def var DayList   as char no-undo.
  if WkSt = 1 then DayList = "1,2,3,4,5,6,7".
              else DayList = "7,1,2,3,4,5,6".
  assign cYear  = string(year(dMyDate))
         WkOne  = weekday(date("01/01/" + cYear))
         WkOne  = integer(entry(WkOne,DayList)).
  if WkOne < 5 
  or WkOne = 1 then dYrBegin = date("01/01/" + cYear).
               else dYrBegin = date("01/01/" + cYear) + WkOne.
  assign iDayNo = integer(dMyDate - dYrBegin) + 1  
         iWkNo  = round(iDayNo / 7,0) + 1 . 
  return string(string(iDayNo) + "|" + string(iWkNo) + "|" + cYear).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dayOfWeek) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dayOfWeek Procedure 
FUNCTION dayOfWeek RETURNS INTEGER
  (input dMyDate as date) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var rDate     as int no-undo.
  def var WkSt      as int  initial 2 no-undo. /* 1=Sun,2=Mon */
  def var DayList   as char no-undo.
  if WkSt = 1 then DayList = "1,2,3,4,5,6,7".
              else DayList = "7,1,2,3,4,5,6".

  rDate = weekday(dMyDate).
  rDate = integer(entry(rDate,DayList)).
  return  rDate.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ExcelBorders) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ExcelBorders Procedure 
FUNCTION ExcelBorders RETURNS LOGICAL
  ( colF      as char,
    colT      as char,
    colColour as char,   
    edgeL     as char,   
    edgeT     as char,   
    edgeR     as char,   
    edgeB     as char,   
    lineL     as char,   
    lineT     as char,   
    lineR     as char,   
    lineB     as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

def var edgeWeight  as char initial ""  no-undo.
def var edgeLine    as char initial ""  no-undo.


objRange = chWorkSheet:Range(colF + ":" + colT).
 
if colColour <> "" then objRange:Interior:ColorIndex = integer(colColour).

if edgeL  <> "" then objRange:Borders({&xlEdgeLeft}):Weight   = if edgeL = "1" then {&xlThick} else if edgeL = "2" then {&xlThin} else {&xlMedium}.
if edgeT  <> "" then objRange:Borders({&xlEdgeTop}):Weight    = if edgeT = "1" then {&xlThick} else if edgeT = "2" then {&xlThin} else {&xlMedium}. 
if edgeR  <> "" then objRange:Borders({&xlEdgeRight}):Weight  = if edgeR = "1" then {&xlThick} else if edgeR = "2" then {&xlThin} else {&xlMedium}.  
if edgeB  <> "" then objRange:Borders({&xlEdgeBottom}):Weight = if edgeB = "1" then {&xlThick} else if edgeB = "2" then {&xlThin} else {&xlMedium}. 

if lineL  <> "" then objRange:Borders({&xlEdgeLeft}):linestyle   = {&xlContinuous}.    
if lineT  <> "" then objRange:Borders({&xlEdgeTop}):linestyle    = {&xlContinuous}.     
if lineR  <> "" then objRange:Borders({&xlEdgeRight}):linestyle  = {&xlContinuous}.   
if lineB  <> "" then objRange:Borders({&xlEdgeBottom}):linestyle = {&xlContinuous}.  
 
















  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FinishExcel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FinishExcel Procedure 
FUNCTION FinishExcel RETURNS LOGICAL
  ( offline as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if offline = "online"  then chExcelApplication:Visible = true.
    else 
    do:  
      chExcelApplication:ActiveWorkBook:Saved = TRUE NO-ERROR.
      chExcelApplication:ActiveSheet:Saveas(lc-FileSaveAs, "1") NO-ERROR.
    end.
  /* just to note for future use - change the '1' to 6 for CSV, 23 for winCSV,   */
  /* 44 for HTML, 21 for MSDOS TXT - Hope this helps ! DJS                       */
   chExcelApplication:DisplayAlerts = TRUE.
   chExcelApplication:Quit().
   /* release com-handles */
   RELEASE OBJECT chExcelApplication NO-ERROR.     
   RELEASE OBJECT chWorkbook NO-ERROR.
   RELEASE OBJECT chWorkSheet NO-ERROR.

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDate Procedure 
FUNCTION getDate RETURNS CHARACTER
 (input dMyDate as date) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  /* returns WEEK MONTH YEAR */
  def var cMonth  as char no-undo.
  def var rDate   as char no-undo.
  cMonth = string(month(dMyDate)).
  rDate = Date2WK(dMyDate).
  if entry(2,rDate,"|") = "0"  then rDate = Date2WK(dMyDate - 5).
  return string(entry(2,rDate,"|") + "|" + cMonth + "|" + string(year(dMyDate))).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Mth2Date) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Mth2Date Procedure 
FUNCTION Mth2Date RETURNS CHARACTER
(cMthYrNo as char):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var iYear     as int no-undo format "9999".
  def var iMthNo    as int  no-undo.
  def var iDate     as date no-undo extent 12 format "99/99/99".
  def var iMonthNum as int  no-undo. 
  if index(cMthYrNo,"-") <> 3 then return "Format should be xx-xxxx".
  assign iMonthNum = integer(entry(1,cMthYrNo,"-")).     /* set month */
         iYear     = integer(entry(2,cMthYrNo,"-")).         /* set year  */
  do iMthNo = 2 to 13:
    if iMthNo <> 13 then iDate[iMthNo - 1] = date(iMthNo,1,iYear) - 1.
    else iDate[12] = date(1,1,iYear + 1) - 1.
  end.
return string("01/" + string(iMonthNum) + "/" + string(iYear) + "|" + string(iDate[iMonthNum],"99/99/9999")).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-percentage-calc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION percentage-calc Procedure 
FUNCTION percentage-calc RETURNS DECIMAL
  ( p-one as dec,
    p-two as dec ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
def var p-result as dec.
/*  p-one =   billable/nonbillable total      */
/*  p-two =   productivity / contarcted hours */
p-result = round(( p-one * 100) / p-two , 2).
return p-result.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-safe-Chars) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION safe-Chars Procedure 
FUNCTION safe-Chars RETURNS CHARACTER
  (  char_in as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

 if trim(char_in) begins "-" then
    assign char_in = REPLACE(char_in, "-":U, " ~ ":U)  .     /* minuss mess with cell entry */
 return char_in. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ThisDate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ThisDate Procedure 
FUNCTION ThisDate RETURNS CHARACTER
  (input thisday as date) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

def var td as char no-undo.
def var dd as char no-undo.
def var mm as char no-undo.
def var yy as char no-undo.
def var da as char no-undo.
assign  dd       = string(day(thisday))
        mm       = entry(month(thisday),"Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec",",")
        yy       = string(year(thisday))
        da       = entry(weekday(thisday),"Sun,Mon,Tue,Wed,Thu,Fri,Sat",",")
        td = da + " " + dd + " " + mm + " " + yy .

return td.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Wk2Date) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Wk2Date Procedure 
FUNCTION Wk2Date RETURNS CHARACTER
 (cWkYrNo as char):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var cYear     as char no-undo.
  def var iWkNo     as int  no-undo.
  def var iDayNo    as int  no-undo.
  def var iSDayNo   as date no-undo.
  def var iEDayNo   as date no-undo.
  def var dYrBegin  as date no-undo.
  def var WkOne     as int  no-undo.
  def var WkSt      as int  initial 2 no-undo. /* 1=Sun,2=Mon */
  if index(cWkYrNo,"-") <> 3 then return "Format should be xx-xxxx".
  assign cYear  = entry(2,cWkYrNo,"-")
         WkOne  = weekday(date("01/01/" + cYear)).
  if WkOne <= 5 then dYrBegin = date("01/01/" + cYear).
  else dYrBegin = date("01/01/" + cYear) + WkOne.
  assign iWkNo  = integer(entry(1,cWkYrNo,"-"))
         iDayNo = (iWkNo * 7) - 7
        iSDayNo = dYrBegin + iDayNo - WkOne + WkSt 
        iEDayNo = iSDayNo + 6 .
  return string(string(iSDayNo,"99/99/9999") + "|" + string(iEDayNo,"99/99/9999")).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

