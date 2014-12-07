/***********************************************************************

    Program:        rep/engrep01-build.p
    
    Purpose:        Enginner Time Report - Build Data
    
    Notes:
    
    
    When        Who         What
    10/11/2010  DJS         Initial
    14/06/2014  phoski      fix customer read
    21/11/2014  phoski      re-write all code
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */


{lib/common.i}
{lib/constants.i}
{rep/engrep01-build.i}


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

DEFINE OUTPUT PARAMETER TABLE FOR tt-IssRep.
DEFINE OUTPUT PARAMETER TABLE FOR tt-IssTime.
DEFINE OUTPUT PARAMETER TABLE FOR tt-IssTotal.
DEFINE OUTPUT PARAMETER TABLE FOR tt-IssUser.
DEFINE OUTPUT PARAMETER TABLE FOR tt-IssCust.
DEFINE OUTPUT PARAMETER TABLE FOR tt-IssTable.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ThisPeriod.



DEFINE VARIABLE lc-global-reportpath AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-FileDescription   AS CHARACTER FORMAT "x(70)" NO-UNDO.
DEFINE VARIABLE lc-FileSaveAs        AS CHARACTER FORMAT "x(170)" NO-UNDO.
DEFINE VARIABLE lc-FilePrefix        AS CHARACTER FORMAT "x(70)" NO-UNDO.
DEFINE VARIABLE lc-FileSuffix        AS CHARACTER FORMAT "x(70)" NO-UNDO.
DEFINE VARIABLE lc-local-offline     AS CHARACTER INITIAL 'ONLINE' NO-UNDO.

DEFINE BUFFER b-issue     FOR issue.
DEFINE BUFFER issue       FOR issue.
DEFINE BUFFER issAction   FOR issAction.
DEFINE BUFFER IssActivity FOR IssActivity.
DEFINE BUFFER webuser     FOR WebUser.
DEFINE BUFFER ro-user     FOR WebUser.


DEFINE VARIABLE li-tot-billable            AS INTEGER NO-UNDO.
DEFINE VARIABLE li-tot-nonbillable         AS INTEGER NO-UNDO.
DEFINE VARIABLE li-tot-productivity        AS DECIMAL NO-UNDO.
DEFINE VARIABLE li-tot-period-billable     AS INTEGER NO-UNDO.
DEFINE VARIABLE li-tot-period-nonbillable  AS INTEGER NO-UNDO.
DEFINE VARIABLE li-tot-period-productivity AS DECIMAL NO-UNDO.

DEFINE BUFFER b-tt-IssRep   FOR tt-IssRep.
DEFINE BUFFER b-tt-IssTime  FOR tt-IssTime.
DEFINE BUFFER b-tt-IssTotal FOR tt-IssTotal.
DEFINE BUFFER b-tt-IssUser  FOR tt-IssUser.
DEFINE BUFFER b-tt-IssCust  FOR tt-IssCust.

DEFINE VARIABLE lc-submitweek      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lc-submitday       AS CHARACTER  EXTENT 7 NO-UNDO.
DEFINE VARIABLE lc-submitreason    AS CHARACTER  EXTENT 7 NO-UNDO.

DEFINE VARIABLE hi-date            AS DATE       NO-UNDO.
DEFINE VARIABLE lo-date            AS DATE       NO-UNDO.
DEFINE VARIABLE vx                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE vc                 AS CHARACTER  NO-UNDO.   
                            
DEFINE VARIABLE lc-error-field     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lc-error-msg       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lc-title           AS CHARACTER  NO-UNDO.
                            
                            
DEFINE VARIABLE lc-lodate          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lc-hidate          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lc-pdf             AS CHARACTER  NO-UNDO.
                            
DEFINE VARIABLE viewType           AS INTEGER    NO-UNDO.
DEFINE VARIABLE reportType         AS INTEGER    NO-UNDO.
DEFINE VARIABLE periodType         AS INTEGER    NO-UNDO.
DEFINE VARIABLE periodDesc         AS CHARACTER  NO-UNDO.

DEFINE VARIABLE li-curr-year       AS INTEGER    FORMAT "9999" NO-UNDO.
DEFINE VARIABLE li-end-week        AS INTEGER    FORMAT "99" NO-UNDO.
DEFINE VARIABLE ld-curr-hours      AS DECIMAL    FORMAT "9999.99" EXTENT 7 NO-UNDO.
DEFINE VARIABLE lc-day             AS CHARACTER  INITIAL "Mon,Tue,Wed,Thu,Fri,Sat,Sun" NO-UNDO.
DEFINE VARIABLE ll-multi-period    AS LOG        NO-UNDO.
DEFINE VARIABLE lc-period-array    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lc-period          AS CHARACTER  NO-UNDO.

DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
DEFINE VARIABLE chWorksheet2       AS COM-HANDLE.
DEFINE VARIABLE chChart            AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange   AS COM-HANDLE.
DEFINE VARIABLE objRange           AS COM-HANDLE.
DEFINE VARIABLE iColumn            AS INTEGER    INITIAL 1 NO-UNDO.
DEFINE VARIABLE cColumn            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRange             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE pi-array           AS INTEGER    EXTENT 2 NO-UNDO.




/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no





/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-CreateExcel) = 0 &THEN

FUNCTION CreateExcel RETURNS LOGICAL
    ( offline AS CHARACTER )  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

FUNCTION Date2Wk RETURNS CHARACTER
    (INPUT dMyDate AS DATE)  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-dayOfWeek) = 0 &THEN

FUNCTION dayOfWeek RETURNS INTEGER
    (INPUT dMyDate AS DATE)  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-ExcelBorders) = 0 &THEN

FUNCTION ExcelBorders RETURNS LOGICAL
    ( colF      AS CHARACTER,
    colT      AS CHARACTER,
    colColour AS CHARACTER,   
    edgeL     AS CHARACTER,   
    edgeT     AS CHARACTER,   
    edgeR     AS CHARACTER,   
    edgeB     AS CHARACTER,   
    lineL     AS CHARACTER,   
    lineT     AS CHARACTER,   
    lineR     AS CHARACTER,   
    lineB     AS CHARACTER )  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-FinishExcel) = 0 &THEN

FUNCTION FinishExcel RETURNS LOGICAL
    ( offline AS CHARACTER )  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-getDate) = 0 &THEN

FUNCTION getDate RETURNS CHARACTER
    (INPUT dMyDate AS DATE)  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-Mth2Date) = 0 &THEN

FUNCTION Mth2Date RETURNS CHARACTER
    (cMthYrNo AS CHARACTER) FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-percentage-calc) = 0 &THEN

FUNCTION percentage-calc RETURNS DECIMAL
    ( p-one AS DECIMAL,
    p-two AS DECIMAL )  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-safe-Chars) = 0 &THEN

FUNCTION safe-Chars RETURNS CHARACTER
    (  char_in AS CHARACTER )  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-ThisDate) = 0 &THEN

FUNCTION ThisDate RETURNS CHARACTER
    (INPUT thisday AS DATE)  FORWARD.


&ENDIF

&IF DEFINED(EXCLUDE-Wk2Date) = 0 &THEN

FUNCTION Wk2Date RETURNS CHARACTER
    (cWkYrNo AS CHARACTER) FORWARD.


&ENDIF


/* *********************** Procedure Settings ************************ */



/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.23
         WIDTH              = 34.57.
/* END WINDOW DEFINITION */
                                                                        */

/* ************************* Included-Libraries *********************** */



 




/* ************************  Main Code Block  *********************** */



/* Process the latest Web event. */
RUN ipBuildData NO-ERROR.




/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Build-Year) = 0 &THEN

PROCEDURE Build-Year :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER lc-loginid            AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER lc-period             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE vx                AS INTEGER   NO-UNDO.
    DEFINE VARIABLE vz                AS INTEGER   NO-UNDO.
    DEFINE VARIABLE zx                AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-date           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hi-pc-date        AS DATE      NO-UNDO.
    DEFINE VARIABLE lo-pc-date        AS DATE      NO-UNDO.
    DEFINE VARIABLE std-hours         AS DECIMAL   FORMAT "99.99" NO-UNDO.
    DEFINE VARIABLE tmp-hours         AS DECIMAL   FORMAT "99.99" NO-UNDO.
    DEFINE VARIABLE lc-list-reason-id AS CHARACTER INITIAL "|01|02|03|04|05|10" NO-UNDO.
    DEFINE VARIABLE lc-list-reason    AS CHARACTER INITIAL "Select|BANK|LEAVE|SICK|DOC|DENT|OT" NO-UNDO.
    DEFINE VARIABLE lc-beg-wk         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-end-wk         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lc-tot-wk         AS INTEGER   NO-UNDO.

    EMPTY TEMP-TABLE tt-ThisPeriod.

    FOR EACH WebStdTime WHERE WebStdTime.CompanyCode = pc-CompanyCode                      
        AND   WebStdTime.LoginID     = lc-loginid                             
        AND   WebStdTime.StdWkYear   = integer(lc-period)
        NO-LOCK:
        DO vx = 1 TO 7:
            ASSIGN 
                tmp-hours         = ((TRUNCATE(WebStdTime.StdAMEndTime[vx] / 100,0) + dec(WebStdTime.StdAMEndTime[vx] MODULO 100 / 60))          /* convert time to decimal  */ 
                                       - (TRUNCATE(WebStdTime.StdAMStTime[vx] / 100,0) + dec(WebStdTime.StdAMStTime[vx] MODULO 100 / 60)))            /* convert time to decimal  */ 
                                       + ((TRUNCATE(WebStdTime.StdPMEndTime[vx] / 100,0) + dec(WebStdTime.StdPMEndTime[vx] MODULO 100 / 60))          /* convert time to decimal  */                               
                - (TRUNCATE(WebStdTime.StdPMStTime[vx] / 100,0) + dec(WebStdTime.StdPMStTime[vx] MODULO 100 / 60)))            /* convert time to decimal  */ 
                ld-curr-hours[vx] = tmp-hours                                                                                                                                       
                std-hours         = std-hours + tmp-hours. 
        END.
    END.

    DO vx = INTEGER(ENTRY(1,lc-period-array,",")) TO INTEGER(ENTRY(NUM-ENTRIES(lc-period-array,","),lc-period-array,",")) :
        ASSIGN 
            lc-date    = ""
            hi-pc-date = ?
            lo-pc-date = ?
            lc-beg-wk  = 0
            lc-end-wk  = 0
            lc-tot-wk  = 0
            tmp-hours  = 0.

        IF periodType = 2 THEN /* Month */ 
        DO:
            ASSIGN 
                lc-date    = Mth2Date(STRING(STRING(vx,"99") + "-" + lc-period))
                hi-pc-date = DATE(ENTRY(1,lc-date,"|"))
                lo-pc-date = DATE(ENTRY(2,lc-date,"|"))

                lc-end-wk  = INTEGER(ENTRY(1,ENTRY(2,lc-date,"|"),"/"))
                zx         = dayOfWeek(hi-pc-date)  /* if lc-beg-wk = 1 then 7 else lc-beg-wk - 1 */
                .
            DO vz = 1 TO lc-end-wk:
                tmp-hours = tmp-hours + ld-curr-hours[zx].
                IF zx >= 7 THEN zx = 0.
                zx = zx + 1.
            END.
        END.
        ELSE
            ASSIGN lc-date    = Wk2Date(STRING(STRING(vx,"99") + "-" + lc-period))
                hi-pc-date = DATE(ENTRY(1,lc-date,"|"))
                lo-pc-date = DATE(ENTRY(2,lc-date,"|"))
                tmp-hours  = std-hours.

        CREATE tt-ThisPeriod.
        ASSIGN 
            td-id     = lc-loginid
            td-period = vx
            td-hours  = tmp-hours.
       
        FOR EACH WebUserTime WHERE WebUserTime.CompanyCode = pc-CompanyCode                      
            AND   WebUserTime.LoginID     = lc-loginid                             
            AND   WebUserTime.EventDate   >= hi-pc-date
            AND   WebUserTime.EventDate   <= lo-pc-date
            NO-LOCK:
            CASE WebUserTime.EventType :
                WHEN "BANK"  THEN 
                    td-hours = td-hours - WebUserTime.EventHours.
                WHEN "LEAVE" THEN 
                    td-hours = td-hours - WebUserTime.EventHours.
                WHEN "SICK"  THEN 
                    td-hours = td-hours - WebUserTime.EventHours.
                WHEN "DOC"   THEN 
                    td-hours = td-hours - WebUserTime.EventHours.
                WHEN "DENT"  THEN 
                    td-hours = td-hours - WebUserTime.EventHours.
                WHEN "OT"    THEN 
                    td-hours = td-hours + WebUserTime.EventHours.
            END CASE.
  
       
        END.
    END.
     
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-excelReportA) = 0 &THEN

PROCEDURE excelReportA :
    /*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-rep-type     AS INTEGER NO-UNDO.
    DEFINE VARIABLE pc-local-period AS CHARACTER NO-UNDO.  

    CreateExcel(lc-local-offline).                    /* Create Excel Application */
    chWorkSheet = chExcelApplication:Sheets:Item(1).  /* get the active Worksheet */
    chWorkSheet:Columns("A:G"):NumberFormat = "@".
    chWorkSheet:PageSetup:Orientation = IF pc-rep-type = 3 THEN {&xlPortrait} ELSE {&xlLandscape} NO-ERROR.
    chWorkSheet:Cells:Font:Name = 'Tahoma'.
    /* set the column names for the Worksheet */
    chWorkSheet:Columns("A"):ColumnWidth = 26.
chWorkSheet:Columns("B"):ColumnWidth = 12.
chWorkSheet:Columns("C"):ColumnWidth = IF pc-rep-type = 1 THEN 50 ELSE IF pc-rep-type = 2 THEN 40 ELSE  18.
chWorkSheet:Columns("D"):ColumnWidth = IF pc-rep-type = 2 THEN 18 ELSE 12.
chWorkSheet:Columns("E"):ColumnWidth = 12.
chWorkSheet:Columns("F"):ColumnWidth = 12.
IF pc-rep-type = 2 THEN
DO:
    chWorkSheet:Columns("G"):ColumnWidth = 12.
chWorkSheet:Range("A1:G1"):Font:Bold = TRUE.
END.
else chWorkSheet:Range("A1:F1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Customer by " + pc-PeriodType + " - " + replace(periodDesc,"_"," to ").
chWorkSheet:Range("D1"):Value = "Report run:".
chWorkSheet:Range("E1"):Value = thisdate(TODAY).
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Customer".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type <> 1 THEN pc-PeriodType ELSE "".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 1 THEN "" ELSE IF pc-rep-type = 2 THEN "Brief Description" ELSE  "Number of Issues" .
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN  "" ELSE "Billlable".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "Billlable" ELSE "Non Billable".               
cRange = "F" + cColumn.                               
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "Non Billable" ELSE "Total".
IF pc-rep-type = 2 THEN 
DO:
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total".
    ExcelBorders("A" + cColumn,"G" + cColumn,"36","1","1","1","1","1","1","1","1").
    chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
END.
ELSE
DO: 
    ExcelBorders("A" + cColumn,"F" + cColumn,"36","1","1","1","1","1","1","1","1").
    chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
END.

FOR EACH tt-IssRep BREAK BY tt-IssRep.AccountNumber BY tt-IssRep.period-of BY tt-IssRep.IssueNumber :

    IF FIRST-OF(tt-IssRep.period-of) AND pc-rep-type <> 1 THEN
    DO:
        pc-local-period = STRING(tt-IssRep.period-of,"99") + "-" + lc-period.
        FIND  tt-IssCust WHERE tt-IssCust.AccountNumber = tt-IssRep.AccountNumber 
            AND   tt-IssCust.period-of     = tt-IssRep.period-of NO-LOCK NO-ERROR.
        FIND  Customer WHERE Customer.CompanyCode  = pc-CompanyCode   
            AND  Customer.AccountNumber = tt-IssRep.AccountNumber NO-LOCK NO-ERROR.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = IF FIRST-OF(tt-IssRep.AccountNumber) AND AVAILABLE Customer THEN IF LENGTH(Customer.Name) > 23 THEN substr(Customer.Name,1,23) + " ... " ELSE Customer.Name   ELSE "".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value =  pc-local-period .
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 3 THEN STRING(tt-IssCust.num-issues) ELSE "".
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "" ELSE com-TimeToString(tt-IssCust.billable).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(tt-IssCust.billable) ELSE com-TimeToString(tt-IssCust.nonbillable).
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(tt-IssCust.nonbillable) ELSE com-TimeToString(tt-IssCust.billable + tt-IssCust.nonbillable).
        IF pc-rep-type = 2 THEN
        DO:
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssCust.billable + tt-IssCust.nonbillable).
            chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
        END.
        ELSE IF pc-rep-type = 1 THEN chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
    
        IF pc-rep-type <> 3 THEN
        DO:
            FIND  tt-IssTime WHERE tt-IssTime.IssueNumber = tt-IssRep.IssueNumber AND tt-IssTime.AccountNumber = tt-IssRep.AccountNumber AND tt-IssTime.period =  tt-IssRep.period-of  NO-LOCK NO-ERROR.
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Issue No".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "" ELSE "Contract Type".
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "Contract Type" ELSE "".
            chWorkSheet:Range("A" + cColumn + ":D" + cColumn):Font:Bold = TRUE.
            IF pc-rep-type = 2 THEN
                IF FIRST-OF(tt-IssRep.AccountNumber) THEN ExcelBorders("A" + string(iColumn - 1),"G" + cColumn,"","1","1","1","1","1","1","1","1").  
                ELSE ExcelBorders("B" + string(iColumn - 1),"G" + cColumn,"","1","1","1","1","1","1","1","1").
    
        END.
    END.
  
    IF FIRST-OF(tt-IssRep.AccountNumber) AND pc-rep-type = 1 THEN
    DO:
        FIND tt-IssCust WHERE tt-IssCust.AccountNumber = tt-IssRep.AccountNumber  
            AND   tt-IssCust.period-of     = tt-IssRep.period-of  NO-LOCK NO-ERROR.
        FIND tt-IssTotal WHERE tt-IssTotal.AccountNumber = tt-IssRep.AccountNumber  NO-LOCK NO-ERROR.
        FIND Customer WHERE Customer.CompanyCode   = pc-CompanyCode 
            AND   Customer.AccountNumber = tt-IssRep.AccountNumber NO-LOCK NO-ERROR.
    
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = IF AVAILABLE Customer THEN IF LENGTH(Customer.Name) > 23 THEN substr(Customer.Name,1,23) + " ... " ELSE Customer.Name ELSE "Unknown".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = pc-local-period.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.billable).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.nonbillable).                     
        cRange = "F" + cColumn.          
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable).
        chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
    END.
  
    IF FIRST-OF(tt-IssRep.IssueNumber) AND pc-rep-type <> 3 THEN
    DO:
        FIND  tt-IssTime WHERE tt-IssTime.IssueNumber = tt-IssRep.IssueNumber AND tt-IssTime.AccountNumber = tt-IssRep.AccountNumber  AND tt-IssTime.period =  tt-IssRep.period-of  NO-LOCK NO-ERROR.
        IF pc-rep-type = 1 THEN
        DO:
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Issue No".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = "Contract Type          Date: " + string(tt-IssRep.IssueDate,"99/99/9999").
            chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
        END.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = STRING(tt-IssRep.IssueNumber).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN tt-IssRep.Description ELSE tt-IssRep.ContractType.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN tt-IssRep.ContractType ELSE com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0) ELSE com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0).                     
        cRange = "F" + cColumn.                               
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0) ELSE com-TimeToString((IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0) + (IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0)).
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString((IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0) + (IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0)) ELSE "".
    
        IF pc-rep-type = 1 THEN
        DO:
            chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Description:".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = safe-Chars(tt-IssRep.Description).
      
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Action Desc:".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = safe-Chars(tt-IssRep.ActionDesc).
            chWorkSheet:Range(cRange):WrapText = TRUE.
            chWorkSheet:Range(cRange):NumberFormat = "General".
        END.
    END.
  
    IF pc-rep-type = 1 THEN
    DO:
        /*         find  Customer where Customer.AccountNumber = tt-IssRep.AccountNumber no-lock no-error. */
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Activity:".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-IssRep.ActivityType + " by: " + tt-IssRep.ActivityBy + " on: " + string(tt-IssRep.StartDate,"99/99/9999").
    
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Billable:".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = IF tt-IssRep.Billable THEN "Yes" ELSE "No".
    
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Time:".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssRep.Duration) .
    
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Activity Desc:".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = safe-Chars(tt-IssRep.Notes).
        chWorkSheet:Range(cRange):WrapText = TRUE.
        chWorkSheet:Range(cRange):NumberFormat = "General".
        ExcelBorders("B" + cColumn,"C" + cColumn,"","","","","2","","","","1").
    /*     iColumn = iColumn + 1. */
    END.
    IF LAST-OF(tt-IssRep.period-of) AND pc-rep-type = 2 THEN
    DO:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value =  "Total".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssCust.billable).
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssCust.nonbillable).                     
        cRange = "G" + cColumn.                               
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssCust.billable + tt-IssCust.nonbillable).
        chWorkSheet:Range("D" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
        ExcelBorders("D" + cColumn,"G" + cColumn,"","2","1","2","1","1","1","1","1").
        iColumn = iColumn + 1.
    END.
    IF LAST-OF(tt-IssRep.AccountNumber) AND pc-rep-type = 1 THEN
    DO:
        FIND tt-IssTotal WHERE tt-IssTotal.AccountNumber = tt-IssRep.AccountNumber  NO-LOCK NO-ERROR.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "Customer Total".
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.billable).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.nonbillable).
        cRange = "F" + cColumn.                               
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable).
        chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
        iColumn = iColumn + 1.
        ExcelBorders("A" + cColumn,"F" + cColumn,"","","2","","1","","1","","1").
    END.
    IF LAST-OF(tt-IssRep.AccountNumber) AND pc-rep-type <> 1 THEN
    DO:
        FIND tt-IssTotal WHERE tt-IssTotal.AccountNumber = tt-IssRep.AccountNumber  NO-LOCK NO-ERROR.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 3 THEN  "Total" ELSE "Customer Total".
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 3 THEN com-TimeToString(tt-IssTotal.billable) ELSE "".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 3 THEN com-TimeToString(tt-IssTotal.nonbillable) ELSE com-TimeToString(tt-IssTotal.billable).
        cRange = "F" + cColumn.                               
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 3 THEN com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable) ELSE com-TimeToString(tt-IssTotal.nonbillable) .
        cRange = "G" + cColumn.                               
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable) ELSE "".
        IF pc-rep-type = 3 THEN ExcelBorders("C" + cColumn,"F" + cColumn,"","","2","","1","","1","","1").
        ELSE ExcelBorders("C" + cColumn,"G" + cColumn,"","","1","","1","","1","","1").
        IF pc-rep-type = 2 THEN chWorkSheet:Range("C" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
        iColumn = iColumn + 1.
    END.
    IF LAST-OF(tt-IssRep.AccountNumber) AND pc-rep-type = 3 THEN  iColumn = iColumn + 1.
END.
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Report Total".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "" ELSE com-TimeToString(li-tot-billable).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(li-tot-billable) ELSE  com-TimeToString(li-tot-nonbillable).
cRange = "F" + cColumn.                               
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(li-tot-nonbillable) ELSE com-TimeToString(li-tot-billable + li-tot-nonbillable).
IF pc-rep-type = 2 THEN 
DO:
    cRange = "G" + cColumn.                               
    chWorkSheet:Range(cRange):Value = com-TimeToString(li-tot-billable + li-tot-nonbillable).
    chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
    ExcelBorders("A" + cColumn,"G" + cColumn,"34","","1","","1","","1","","1").
END.
ELSE
DO:
    chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
    ExcelBorders("A" + cColumn,"F" + cColumn,"34","","1","","1","","1","","1").
END.
iColumn = iColumn + 1.
/*     chWorkSheet:Range("A1:A" + string(iColumn)):COLUMNS:AutoFit. */
chWorkSheet:Range("B1:B" + string(iColumn)):Columns:VerticalAlignment = 1  .
chWorkSheet:PageSetup:PrintArea = IF pc-rep-type = 2 THEN "A1:G"+ string(iColumn) ELSE "A1:F"+ string(iColumn) NO-ERROR.
chWorkSheet:PageSetup:Zoom = 90 NO-ERROR.
FinishExcel(lc-local-offline).                    /* Close Excel Application */
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-excelReportB) = 0 &THEN

PROCEDURE excelReportB :
    /*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-rep-type AS INTEGER  NO-UNDO.
    DEFINE VARIABLE std-hours       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE pc-local-period AS CHARACTER NO-UNDO. 
    CreateExcel(lc-local-offline).                    /* Create Excel Application */
    chWorkSheet = chExcelApplication:Sheets:Item(1).  /* get the active Worksheet */
    chWorkSheet:Columns("A:I"):NumberFormat = "@".
    chWorkSheet:PageSetup:Orientation = {&xlLandscape} NO-ERROR.
    chWorkSheet:Cells:Font:Name = 'Tahoma'.
    /* set the column sizes for the Worksheet */
    chWorkSheet:Columns("A"):ColumnWidth = 18.
chWorkSheet:Columns("B"):ColumnWidth = IF pc-rep-type = 1 THEN 18 ELSE 12.
chWorkSheet:Columns("C"):ColumnWidth = IF pc-rep-type = 1 THEN 50 ELSE IF pc-rep-type = 2 THEN 26 ELSE 18.
chWorkSheet:Columns("D"):ColumnWidth = IF pc-rep-type = 2 THEN 26 ELSE 12.
chWorkSheet:Columns("E"):ColumnWidth = IF pc-rep-type = 2 THEN 18 ELSE 12.
chWorkSheet:Columns("F"):ColumnWidth = 12.
IF pc-rep-type = 2 THEN
DO:
    chWorkSheet:Columns("G"):ColumnWidth = 12.
chWorkSheet:Columns("H"):ColumnWidth = 12.
chWorkSheet:Columns("I"):ColumnWidth = 15.
/*       chWorkSheet:Range("A1:I1"):Font:Bold = TRUE. */
END.
else if pc-rep-type = 3 then
do:
chWorkSheet:Columns("G"):ColumnWidth = 15.
chWorkSheet:Range("A1:G1"):Font:Bold = TRUE.
END.
else chWorkSheet:Range("A1:F1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Engineer by " +  pc-PeriodType + " - " + replace(periodDesc,"_"," to ").
chWorkSheet:Range("D1"):Value = "Report run:".
chWorkSheet:Range("E1"):Value = thisdate(TODAY).
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Engineer".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = pc-PeriodType.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 1 THEN " " ELSE IF pc-rep-type = 2 THEN  "Client" ELSE  "Contract Time" . 
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "Brief Description" ELSE "Billable". 
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "Contract Time" ELSE "Non Billable".               
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "Billable" ELSE "Total".
IF pc-rep-type = 2 THEN
DO:
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Non Billable" .
    cRange = "H" + cColumn.           
    chWorkSheet:Range(cRange):Value = "Total" .
    cRange = "I" + cColumn.    
    chWorkSheet:Range(cRange):Value = "Productivity %".
    ExcelBorders("A" + cColumn,"I" + cColumn,"36","1","1","1","1","1","1","1","1").
    chWorkSheet:Range("A" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
END.
ELSE IF pc-rep-type = 3 THEN
    DO:
        cRange = "G" + cColumn.                               
        chWorkSheet:Range(cRange):Value = "Productivity %".
        ExcelBorders("A" + cColumn,"G" + cColumn,"36","1","1","1","1","1","1","1","1").  
        chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
    END.
    ELSE
    DO: 
        ExcelBorders("A" + cColumn,"F" + cColumn,"36","1","1","1","1","1","1","1","1").  
        chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
    END.
/* END OF HEADINGS */
FOR EACH tt-IssRep BREAK BY tt-IssRep.ActivityBy BY tt-IssRep.period-of BY tt-IssRep.IssueNumber :
    IF FIRST-OF(tt-IssRep.period-of) AND pc-rep-type <> 1 THEN
    DO:
        pc-local-period = STRING(tt-IssRep.period-of,"99") + "-" + lc-period.
        FIND tt-IssUser WHERE tt-IssUser.ActivityBy = tt-IssRep.ActivityBy AND   tt-IssUser.period-of  = tt-IssRep.period-of NO-LOCK NO-ERROR.
        FIND tt-IssTotal WHERE tt-IssTotal.ActivityBy = tt-IssRep.ActivityBy  NO-LOCK NO-ERROR.
        ASSIGN 
            std-hours = com-TimeToString(tt-IssUser.billable + tt-IssUser.nonbillable)
            std-hours = STRING(dec(INTEGER( ENTRY(1,std-hours,":")) + truncate(INTEGER(ENTRY(2,std-hours,":")) / 60,2))) .
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = IF FIRST-OF(tt-IssRep.ActivityBy) THEN tt-IssUser.ActivityBy ELSE "".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = pc-local-period.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2  THEN "" ELSE STRING(tt-IssUser.productivity,"zzz9.99") .
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2  THEN "" ELSE com-TimeToString(tt-IssUser.billable).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2  THEN STRING(tt-IssUser.productivity,"zzz9.99") ELSE com-TimeToString(tt-IssUser.nonbillable).                     
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2  THEN com-TimeToString(tt-IssUser.billable) ELSE com-TimeToString(tt-IssUser.billable + tt-IssUser.nonbillable).      
        IF pc-rep-type = 2 THEN
        DO: 
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssUser.nonbillable).        
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssUser.billable + tt-IssUser.nonbillable).
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = STRING(percentage-calc(dec(std-hours),tt-IssUser.productivity),"zz9.99" ). 
            chWorkSheet:Range("A" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
        END.
        IF pc-rep-type = 3 THEN
        DO:
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = STRING(percentage-calc(dec(std-hours),tt-IssUser.productivity),"zz9.99" ). 
        END.
        IF pc-rep-type = 1 THEN
        DO:
            FIND tt-IssTime WHERE tt-IssTime.IssueNumber = tt-IssRep.IssueNumber AND tt-IssTime.ActivityBy = tt-IssRep.ActivityBy AND tt-IssTime.period =  tt-IssRep.period-of  NO-LOCK NO-ERROR.
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Issue No".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value =  "Contract Type".
            chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
        END.
        IF pc-rep-type = 2 THEN
        DO:
            FIND tt-IssTime WHERE tt-IssTime.IssueNumber = tt-IssRep.IssueNumber AND tt-IssTime.ActivityBy = tt-IssRep.ActivityBy AND tt-IssTime.period =  tt-IssRep.period-of  NO-LOCK NO-ERROR.
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Issue No".
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value =  "Contract Type".
            chWorkSheet:Range("A" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
            IF FIRST-OF(tt-IssRep.ActivityBy) THEN ExcelBorders("A" + string(iColumn - 1),"I" + cColumn,"","1","1","1","1","1","1","1","1").  
            ELSE ExcelBorders("B" + string(iColumn - 1),"I" + cColumn,"","1","1","1","1","1","1","1","1").
        END.
    END.
    /* END OF SUB HEADING 1 */
    IF FIRST-OF(tt-IssRep.ActivityBy) AND pc-rep-type = 1 THEN
    DO:
        FIND  tt-IssUser WHERE tt-IssUser.ActivityBy = tt-IssRep.ActivityBy AND tt-IssUser.period-of  = tt-IssRep.period-of NO-LOCK NO-ERROR.
        FIND tt-IssTotal WHERE tt-IssTotal.ActivityBy = tt-IssRep.ActivityBy  NO-LOCK NO-ERROR.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-IssUser.ActivityBy.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = pc-local-period.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.billable).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.nonbillable).
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable).
        chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
    END.
    IF FIRST-OF(tt-IssRep.IssueNumber) AND pc-rep-type <> 3 THEN
    DO:
        FIND tt-IssTime WHERE tt-IssTime.IssueNumber = tt-IssRep.IssueNumber AND tt-IssTime.ActivityBy = tt-IssRep.ActivityBy AND tt-IssTime.period =  tt-IssRep.period-of  NO-LOCK NO-ERROR.
        FIND Customer WHERE Customer.AccountNumber = tt-IssRep.AccountNumber 
            AND customer.companyCode  = pc-CompanyCode NO-LOCK NO-ERROR.
        IF pc-rep-type = 1 THEN
        DO:
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Issue No".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value =  "Contract Type          Date: " + string(tt-IssRep.IssueDate,"99/99/9999").
            chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
        END.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = STRING(tt-IssRep.IssueNumber).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN IF AVAILABLE customer THEN IF LENGTH(Customer.Name) > 23 THEN substr(Customer.Name,1,23) + " ... " ELSE Customer.Name ELSE "Unknown" ELSE  tt-IssRep.ContractType.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN IF LENGTH(tt-IssRep.Description) > 23 THEN substr(tt-IssRep.Description,1,23) + " ... " ELSE tt-IssRep.Description ELSE com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN tt-IssRep.ContractType ELSE com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0).                     
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0) ELSE com-TimeToString((IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0) + (IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0)).
        IF pc-rep-type = 2 THEN
        DO:
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0).                                                       
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = com-TimeToString((IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0) + (IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0)).     
        END.
        ELSE  chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
        IF pc-rep-type = 1 THEN
        DO:
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Client".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = IF AVAILABLE customer THEN TRIM(substr(Customer.Name,1,23)) ELSE "Unknownxxxx".
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Brief Description".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = safe-Chars(tt-IssRep.Description).
            iColumn = iColumn + 1.
            cColumn = STRING(iColumn).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Action Desc".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = safe-Chars(tt-IssRep.ActionDesc).
            chWorkSheet:Range(cRange):WrapText = TRUE.
            chWorkSheet:Range(cRange):NumberFormat = "General".
        END.
    END. 
    IF pc-rep-type = 1 THEN
    DO:
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
    END.
    IF LAST-OF(tt-IssRep.period-of) AND pc-rep-type = 2 THEN
    DO:
        FIND  tt-IssUser WHERE tt-IssUser.ActivityBy = tt-IssRep.ActivityBy AND   tt-IssUser.period-of  = tt-IssRep.period-of  NO-LOCK NO-ERROR.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value =  "Total".
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssUser.billable).
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssUser.nonbillable).
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssUser.billable + tt-IssUser.nonbillable).
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = STRING(percentage-calc(dec(std-hours),tt-IssUser.productivity),"zz9.99" ). 
        chWorkSheet:Range("E" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
        ExcelBorders("E" + cColumn,"I" + cColumn,"","2","1","2","1","1","1","1","1").  
        iColumn = iColumn + 1. 
    END.
    IF LAST-OF(tt-IssRep.ActivityBy) AND pc-rep-type = 1 THEN
    DO:
        FIND tt-IssTotal WHERE tt-IssTotal.ActivityBy = tt-IssRep.ActivityBy  NO-LOCK NO-ERROR.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "Engineer Total".  
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.billable).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.nonbillable).
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable).
        chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
        ExcelBorders("A" + cColumn,"F" + cColumn,"","","2","","1","","1","","1").
        iColumn = iColumn + 1.
    END.
    IF LAST-OF(tt-IssRep.ActivityBy) AND pc-rep-type <> 1 THEN
    DO:  
        FIND tt-IssTotal WHERE tt-IssTotal.ActivityBy = tt-IssRep.ActivityBy  NO-LOCK NO-ERROR. 
        ASSIGN 
            std-hours = com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable)
            std-hours = STRING(dec(INTEGER( ENTRY(1,std-hours,":")) + truncate(INTEGER(ENTRY(2,std-hours,":")) / 60,2))) . 
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn). 
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = IF pc-rep-type = 3 THEN "Total" ELSE "".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value =  IF pc-rep-type = 3 THEN STRING(tt-IssTotal.productivity,"zzz9.99") ELSE "" .
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value =  IF pc-rep-type = 3 THEN com-TimeToString(tt-IssTotal.billable) ELSE "Engineer Total".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value =  IF pc-rep-type = 3 THEN com-TimeToString(tt-IssTotal.nonbillable) ELSE STRING(tt-IssTotal.productivity,"zzz9.99").
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value =  IF pc-rep-type = 3 THEN com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable) ELSE com-TimeToString(tt-IssTotal.billable) .
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value =  IF pc-rep-type = 3 THEN STRING(percentage-calc(dec(std-hours),tt-IssTotal.productivity),"zz9.99" ) ELSE com-TimeToString(tt-IssTotal.nonbillable) .
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value =  IF pc-rep-type = 2 THEN com-TimeToString(tt-IssTotal.billable + tt-IssTotal.nonbillable) ELSE "".
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value =  IF pc-rep-type = 2 THEN STRING(percentage-calc(dec(std-hours),tt-IssTotal.productivity),"zz9.99" ) ELSE "" .
        IF pc-rep-type = 3 THEN ExcelBorders("C" + cColumn,"G" + cColumn,"","","2","","1","","1","","1").
        ELSE ExcelBorders("D" + cColumn,"I" + cColumn,"","","1","","1","","1","","1").
        IF pc-rep-type = 2 THEN chWorkSheet:Range("D" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
        iColumn = iColumn + 1.
    END.
END.
iColumn = iColumn + 2.
cColumn = STRING(iColumn).    
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Report Total".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "" ELSE com-TimeToString(li-tot-billable).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN "" ELSE com-TimeToString(li-tot-nonbillable).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(li-tot-billable) ELSE com-TimeToString(li-tot-billable + li-tot-nonbillable).
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(li-tot-nonbillable) ELSE "" .
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = IF pc-rep-type = 2 THEN com-TimeToString(li-tot-billable + li-tot-nonbillable) ELSE "". 
IF pc-rep-type = 3 THEN 
DO:
    chWorkSheet:Range("A" + cColumn + ":G" + cColumn):Font:Bold = TRUE.
    ExcelBorders("A" + cColumn,"G" + cColumn,"34","","1","","1","","1","","1").  
END.
ELSE IF pc-rep-type = 2 THEN 
    DO:
        chWorkSheet:Range("A" + cColumn + ":I" + cColumn):Font:Bold = TRUE.
        ExcelBorders("A" + cColumn,"I" + cColumn,"34","","1","","1","","1","","1").  
    END.
    ELSE 
    DO:
        chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
        ExcelBorders("A" + cColumn,"F" + cColumn,"34","","1","","1","","1","","1").  
    END.
chWorkSheet:Range("B1:B" + string(iColumn + 1)):Columns:VerticalAlignment = 1  .
IF pc-rep-type = 1 THEN chWorkSheet:PageSetup:PrintArea = "A1:F"+ string(iColumn + 1) NO-ERROR.
IF pc-rep-type = 2 THEN chWorkSheet:PageSetup:PrintArea = "A1:I"+ string(iColumn + 1) NO-ERROR.
IF pc-rep-type = 3 THEN chWorkSheet:PageSetup:PrintArea = "A1:G"+ string(iColumn + 1) NO-ERROR.
chWorkSheet:PageSetup:Zoom =  IF pc-rep-type = 2 THEN 80 ELSE 90 NO-ERROR.
IF lc-local-offline = "online"  THEN chExcelApplication:Visible = TRUE.
FinishExcel(lc-local-offline).  /* Close Excel Application */
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-excelReportC) = 0 &THEN

PROCEDURE excelReportC :
    /*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-rep-type AS INTEGER  NO-UNDO.
    CreateExcel(lc-local-offline).                    /* Create Excel Application */
    chWorkSheet = chExcelApplication:Sheets:Item(1).  /* get the active Worksheet */
    chWorkSheet:Columns("A:F"):NumberFormat = "@".
    chWorkSheet:PageSetup:Orientation = {&xlLandscape} NO-ERROR.
    /* set the column names for the Worksheet */
    chWorkSheet:Columns("A"):ColumnWidth = 26.
chWorkSheet:Columns("B"):ColumnWidth = 18.
chWorkSheet:Columns("C"):ColumnWidth = 50.
chWorkSheet:Columns("D"):ColumnWidth = 12.
chWorkSheet:Columns("E"):ColumnWidth = 12.
chWorkSheet:Columns("F"):ColumnWidth = 12.
chWorkSheet:Range("A1:F1"):Font:Bold = TRUE.
chWorkSheet:Cells:Font:Name = 'Tahoma'.
chWorkSheet:Range("A1"):Value = "Issues by " + pc-PeriodType.
chWorkSheet:Range("B1"):Value = "".
chWorkSheet:Range("C1"):Value = "".
chWorkSheet:Range("D1"):Value = "Report run:".
chWorkSheet:Range("E1"):Value = thisdate(TODAY).
iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Engineer".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = pc-PeriodType.
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
FOR EACH tt-IssRep BREAK BY tt-IssRep.IssueNumber :
    FIND  tt-IssUser WHERE tt-IssUser.ActivityBy = tt-IssRep.ActivityBy NO-LOCK NO-ERROR.
    IF FIRST-OF(tt-IssRep.IssueNumber) THEN
    DO:
        FIND  tt-IssTime WHERE tt-IssTime.IssueNumber = tt-IssRep.IssueNumber NO-LOCK NO-ERROR.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Issue No".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value =  "Contract Type          Date: " + string(tt-IssRep.IssueDate,"99/99/9999").
        chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = STRING(tt-IssRep.IssueNumber).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-IssRep.ContractType.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = com-TimeToString(IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0).                     
        cRange = "F" + cColumn.                               
        chWorkSheet:Range(cRange):Value = com-TimeToString((IF AVAILABLE tt-IssTime THEN tt-IssTime.billable ELSE 0) + (IF AVAILABLE tt-IssTime THEN tt-IssTime.nonbillable ELSE 0)).
        chWorkSheet:Range("A" + cColumn + ":F" + cColumn):Font:Bold = TRUE.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Description".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = safe-Chars(tt-IssRep.Description).
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Action Desc".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = safe-Chars(tt-IssRep.ActionDesc).
        chWorkSheet:Range(cRange):WrapText = TRUE.
        chWorkSheet:Range(cRange):NumberFormat = "General".
    END.
    FIND  Customer WHERE Customer.CompanyCode   = pc-CompanyCode 
        AND   Customer.AccountNumber = tt-IssRep.AccountNumber NO-LOCK NO-ERROR.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Activity".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-IssRep.ActivityType + " for: " + IF AVAILABLE Customer THEN IF LENGTH(Customer.Name) > 23 THEN substr(Customer.Name,1,23) + " ... " ELSE Customer.Name ELSE "Unknown".
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Billable".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = IF tt-IssRep.Billable THEN "Yes" ELSE "No".
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Time".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = com-TimeToString(tt-IssRep.Duration) .
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Activity Desc".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = safe-Chars(tt-IssRep.Notes).
    chWorkSheet:Range(cRange):WrapText = TRUE.
    chWorkSheet:Range(cRange):NumberFormat = "General".
    iColumn = iColumn + 1.
END.
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
chWorkSheet:PageSetup:PrintArea = "A1:F"+ string(iColumn) NO-ERROR.
chWorkSheet:PageSetup:Zoom = 90 NO-ERROR.
FinishExcel(lc-local-offline).      /* Close Excel Application */
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ipBuildData) = 0 &THEN

PROCEDURE ipBuildData:
    /*------------------------------------------------------------------------------
      Purpose:     Process the web request.
      Parameters:  <none>
      emails:       
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE vc       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vx       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE typedesc AS CHARACTER INITIAL "Detail,Summary_Detail,Summary" NO-UNDO. 
    DEFINE VARIABLE engcust  AS CHARACTER INITIAL "Customer,Engineer,Issues" NO-UNDO.
    DEFINE VARIABLE weekly   AS CHARACTER INITIAL "Week,Month" NO-UNDO.


    ASSIGN
        viewType             = INTEGER(pc-ViewType)         /* pc-ViewType    1=Detailed , 2=SummaryDetail, 3=Summary */   
        reportType           = INTEGER(pc-ReportType)       /* pc-ReportType  1=Customer, 2=Engineer, 3=Issues */            
        periodType           = INTEGER(pc-PeriodType)       /* pc-PeriodType  1=Week, 2=Month  */                            
        pc-ViewType   = ENTRY(viewType,typedesc)  /* set these to descriptions  */ 
        pc-ReportType = ENTRY(reportType,engcust) /* set these to descriptions  */
        pc-PeriodType = ENTRY(periodType,weekly)  /* set these to descriptions  */
        .
    /* Get year from period - ignore month(s) or week(s) */
    IF INDEX(pc-Period,"|") = 0 THEN lc-period = ENTRY(2,ENTRY(1,pc-Period,"|"),"-").
    ELSE lc-period = ENTRY(1,ENTRY(2, pc-Period,"-"),"|").

    IF periodType = 1 THEN
    DO:
        IF pc-Period BEGINS "ALL" THEN
        DO:
            vc = Wk2Date("01-" + entry(2,pc-Period,"-")).
            hi-date =  DATE(ENTRY(1,vc,"|")). 
            vc =  Wk2Date(ENTRY(1,getDate(  DATE("31/12/" + entry(2,pc-Period,"-") )  ),"|") + "-" + entry(2,pc-Period,"-")).
            lo-date =  DATE(ENTRY(2,vc,"|")). 
        END.
        ELSE IF INDEX(pc-Period,"|") = 0 THEN 
            DO:  
                vc = Wk2Date(pc-Period).
                hi-date =  DATE(ENTRY(1,vc,"|")). 
                lo-date =  DATE(ENTRY(2,vc,"|")). 
            END.
            ELSE
            DO:
                vc = Wk2Date(ENTRY(1,pc-Period,"|")).
                hi-date =  DATE(ENTRY(1,vc,"|")). 
                vc = Wk2Date(ENTRY(2,pc-Period,"|")).
                lo-date =  DATE(ENTRY(2,vc,"|")). 
            END.
    END.
    ELSE
    DO:
        IF pc-Period BEGINS "ALL" THEN
        DO:
            vc = Mth2Date("01-" + entry(2,pc-Period,"-")).
            hi-date =  DATE(ENTRY(1,vc,"|")). 
            vc =  Wk2Date(ENTRY(1,getDate(  DATE("31/12/" + entry(2,pc-Period,"-") )  ),"|") + "-" + entry(2,pc-Period,"-")).
            lo-date =  DATE(ENTRY(2,vc,"|")).
        END.
        ELSE IF INDEX(pc-Period,"|") = 0 THEN 
            DO:  
                vc = Mth2Date(pc-Period).
                hi-date =  DATE(ENTRY(1,vc,"|")). 
                lo-date =  DATE(ENTRY(2,vc,"|")). 
            END.
            ELSE
            DO:
                vc = Mth2Date(ENTRY(1,pc-Period,"|")).
                hi-date =  DATE(ENTRY(1,vc,"|")). 
                vc = Mth2Date(ENTRY(2,pc-Period,"|")).
                lo-date =  DATE(ENTRY(2,vc,"|")). 
            END.
    END.

    IF pc-Period BEGINS "ALL" THEN /* we need to make the report split months/weeks */
    DO:
        ll-multi-period = TRUE.
        IF periodType = 1 THEN /* Week */
        DO vx = 1 TO INTEGER(ENTRY(2,getDate(DATE("31/12/" + entry(2,pc-Period,"-"))),"|")) :
            lc-period-array = lc-period-array + string(vx) + ",".
        END.
        ELSE
        DO vx = 1 TO 12 :
            lc-period-array = lc-period-array + string(vx) + ",".
        END.
    END.
    ELSE
        IF INDEX(pc-Period,"|") > 0  THEN /* we need to make the report split months/weeks */
        DO:
            ll-multi-period = TRUE.
            IF periodType = 1 THEN /* Week */
            DO vx = INTEGER(ENTRY(1,ENTRY(1, pc-Period,"|"),"-")) TO INTEGER(ENTRY(1,ENTRY(2, pc-Period,"|"),"-")) :
                lc-period-array = lc-period-array + string(vx) + ",".
            END.
            ELSE
            DO vx = INTEGER(ENTRY(1,ENTRY(1, pc-Period,"|"),"-")) TO INTEGER(ENTRY(1,ENTRY(2, pc-Period,"|"),"-"))  :
                lc-period-array = lc-period-array + string(vx) + ",".
            END.
        END.
        ELSE lc-period-array = ENTRY(1,ENTRY(1, pc-Period,"|"),"-").

    lc-period-array = TRIM(lc-period-array,",").

    pi-array[1] = INTEGER(ENTRY(1,lc-period-array)).                           /* quick fix fo week no probs  */
    pi-array[2] = INTEGER(ENTRY(NUM-ENTRIES(lc-period-array),lc-period-array)).


    IF INDEX(pc-Period,"|") > 0 THEN periodDesc = REPLACE(pc-Period,"|","_").
    ELSE periodDesc = pc-Period.

    

    IF reportType = 1 THEN
    DO:
        FOR EACH IssActivity NO-LOCK
            WHERE IssActivity.companycode = pc-CompanyCode
            AND   IssActivity.StartDate >= hi-date
            AND   IssActivity.StartDate <= lo-date,
            FIRST ro-user NO-LOCK
            WHERE ro-user.companycode = pc-CompanyCode
            AND ro-user.LoginID = IssActivity.ActivityBy 
            AND ro-user.UserClass = "internal"
            :
            INNER: 
            DO:
                FIND FIRST issAction OF issActivity NO-LOCK NO-ERROR.
                IF NOT AVAILABLE issAction THEN NEXT.

                FIND Issue NO-LOCK
                    WHERE issue.companycode = pc-CompanyCode
                    AND   Issue.IssueNumber = issAction.IssueNumber
                    AND   IF pc-Customers = "ALL" THEN TRUE  ELSE LOOKUP(Issue.AccountNumber,pc-Customers,",") > 0
                    NO-ERROR.
                IF NOT AVAILABLE Issue THEN LEAVE INNER.
                RUN ReportA(reportType) .
      
            END.
        END.
        RUN ReportC .
        /*
        MESSAGE "STARTING EXCEL" VIEW-AS ALERT-BOX.
        
        RUN excelReportA(viewType) . 
        */
    END.
    ELSE IF reportType = 2 THEN
        DO:
            FOR EACH webuser NO-LOCK
                WHERE webuser.companycode = pc-CompanyCode
                AND   webuser.UserClass = "internal"
                AND IF pc-Engineers = "ALL" THEN TRUE ELSE  LOOKUP(webuser.loginid,pc-Engineers,",") > 0
                :
                FOR EACH IssActivity NO-LOCK
                    WHERE IssActivity.CompanyCode = webuser.CompanyCode
                    AND IssActivity.ActivityBy  = webuser.loginid
                    AND IssActivity.StartDate >= hi-date
                    AND IssActivity.StartDate <= lo-date
                    :

                    FIND FIRST issAction OF issActivity NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE issAction THEN NEXT.

                    FIND FIRST issue NO-LOCK WHERE issue.CompanyCode = webuser.CompanyCode
                        AND issue.IssueNumber = IssActivity.IssueNumber NO-ERROR.
                    RUN ReportA(reportType).
                END.             
            END.               
            RUN ReportB.
            /*
            MESSAGE "STARTING EXCEL" VIEW-AS ALERT-BOX.
            
            RUN excelReportB(viewType).
            */
        END.
        ELSE  
        DO:
            FOR EACH IssActivity NO-LOCK
                WHERE IssActivity.CompanyCode = pc-CompanyCode
                AND IssActivity.StartDate >= hi-date
                AND IssActivity.StartDate <= lo-date,
                FIRST ro-user NO-LOCK
                WHERE ro-user.companycode = pc-CompanyCode
                AND ro-user.LoginID = IssActivity.ActivityBy 
                AND ro-user.UserClass = "internal"
              
                :

                FIND FIRST issAction OF issActivity NO-LOCK NO-ERROR.
                IF NOT AVAILABLE issAction THEN NEXT.

                FIND FIRST issue NO-LOCK WHERE issue.CompanyCode = pc-CompanyCode
                    AND issue.IssueNumber = IssActivity.IssueNumber NO-ERROR.
                RUN ReportA(reportType).
            END.             
            RUN ReportB.              
        /* RUN excelReportC(viewType). */  
        END.

  
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ReportA) = 0 &THEN

PROCEDURE ReportA :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER reportType  AS INTEGER  NO-UNDO.

    DEFINE VARIABLE pi-period-of           AS INTEGER NO-UNDO.
    DEFINE VARIABLE pi-period-billable     AS INTEGER NO-UNDO. 
    DEFINE VARIABLE pi-period-nonbillable  AS INTEGER NO-UNDO.
    DEFINE VARIABLE pi-period-productivity AS DECIMAL NO-UNDO.
    DEFINE VARIABLE pi-period-num-issues   AS INTEGER NO-UNDO.

    FIND FIRST ContractType 
        WHERE ContractType.CompanyCode  = Issue.CompanyCode
        AND ContractType.ContractNumber = Issue.ContractType NO-LOCK NO-ERROR.

    pi-period-of = INTEGER(ENTRY(periodType,getDate(IssActivity.StartDate),"|")).

    /*    if pi-period-of < pi-array[1] or pi-period-of > pi-array[2] then return. /* quick fix fo week no probs  */  */

    FIND FIRST tt-IssRep 
        WHERE tt-IssRep.IssueNumber   = IssActivity.IssueNumber 
        AND   tt-IssRep.IssActionID   = IssActivity.IssActionID
        AND   tt-IssRep.IssActivityID = IssActivity.IssActivityID
        AND   tt-IssRep.AccountNumber = Issue.AccountNumber 
        AND   tt-IssRep.period-of     = pi-period-of NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-IssRep THEN
    DO:
        CREATE tt-IssRep.
        BUFFER-COPY issActivity TO tt-IssRep.
    END.
    ASSIGN 
        tt-IssRep.AccountNumber = issue.AccountNumber
        tt-IssRep.ActionDesc    = issAction.Notes
        tt-IssRep.ActivityType  = IssActivity.ActDescription
        tt-IssRep.ContractType  = IF AVAILABLE ContractType THEN ContractType.Description ELSE "Ad Hoc" 
        tt-IssRep.IssueDate     = issue.IssueDate
        tt-IssRep.period-of     = pi-period-of.
    /* TIME RECORDS */
    FIND FIRST tt-IssTime WHERE tt-IssTime.IssueNumber   = IssActivity.IssueNumber 
        AND   tt-IssTime.period-of     = pi-period-of  
        AND  (IF reportType = 1 THEN tt-IssTime.AccountNumber = issue.AccountNumber 
        ELSE tt-IssTime.ActivityBy    = IssActivity.ActivityBy )
        NO-ERROR.
    IF NOT AVAILABLE tt-IssTime THEN
    DO: 
        CREATE tt-IssTime.                    
        ASSIGN 
            tt-IssTime.IssueNumber   = IssActivity.IssueNumber
            tt-IssTime.AccountNumber = issue.AccountNumber
            tt-IssTime.ActivityBy    = IssActivity.ActivityBy
            tt-IssTime.period-of     = pi-period-of
            tt-IssTime.billable      = IF IssActivity.Billable THEN IssActivity.Duration ELSE 0
            tt-IssTime.nonbillable   = IF NOT IssActivity.Billable THEN IssActivity.Duration ELSE 0.
    END.
    ELSE
        ASSIGN tt-IssTime.billable    = IF IssActivity.Billable THEN tt-IssTime.billable + IssActivity.Duration ELSE tt-IssTime.billable
            tt-IssTime.nonbillable = IF NOT IssActivity.Billable THEN tt-IssTime.nonbillable + IssActivity.Duration ELSE tt-IssTime.nonbillable.

    /* TOTAL RECORDS */
    ASSIGN 
        li-tot-billable    = IF IssActivity.Billable THEN li-tot-billable + IssActivity.Duration ELSE li-tot-billable              
        li-tot-nonbillable = IF NOT IssActivity.Billable THEN li-tot-nonbillable + IssActivity.Duration ELSE li-tot-nonbillable. 

    IF reportType = 1 THEN FIND FIRST tt-IssTotal WHERE tt-IssTotal.AccountNumber = issue.AccountNumber NO-ERROR.
    IF reportType = 2 THEN FIND FIRST tt-IssTotal WHERE tt-IssTotal.ActivityBy = IssActivity.ActivityBy NO-ERROR.
    IF NOT AVAILABLE tt-IssTotal THEN
    DO: 
        CREATE tt-IssTotal.                    
        ASSIGN 
            tt-IssTotal.AccountNumber = IF reportType = 1 THEN issue.AccountNumber ELSE ""
            tt-IssTotal.ActivityBy    = IF reportType = 2 THEN IssActivity.ActivityBy ELSE ""
            tt-IssTotal.billable      = IF IssActivity.Billable THEN IssActivity.Duration ELSE 0
            tt-IssTotal.nonbillable   = IF NOT IssActivity.Billable THEN IssActivity.Duration ELSE 0. 
    END.
    ELSE
        ASSIGN tt-IssTotal.billable    = IF IssActivity.Billable THEN tt-IssTotal.billable + IssActivity.Duration ELSE tt-IssTotal.billable
            tt-IssTotal.nonbillable = IF NOT IssActivity.Billable THEN tt-IssTotal.nonbillable + IssActivity.Duration ELSE tt-IssTotal.nonbillable.    

    /* USER RECORDS */
    FIND tt-IssUser WHERE tt-IssUser.ActivityBy = IssActivity.ActivityBy 
        AND   tt-IssUser.period-of  = pi-period-of NO-ERROR.
    IF NOT AVAILABLE tt-IssUser THEN 
    DO:
        CREATE tt-IssUser.
        ASSIGN 
            tt-IssUser.ActivityBy = IssActivity.ActivityBy
            tt-IssUser.period-of  = pi-period-of.
    END.
    ASSIGN 
        tt-IssUser.billable    = IF IssActivity.Billable THEN tt-IssUser.billable + IssActivity.Duration ELSE tt-IssUser.billable              
        tt-IssUser.nonbillable = IF NOT IssActivity.Billable THEN tt-IssUser.nonbillable + IssActivity.Duration ELSE tt-IssUser.nonbillable.
    /* CUSTOMER RECORDS */
    FIND tt-IssCust WHERE tt-IssCust.AccountNumber = issue.AccountNumber 
        AND   tt-IssCust.period-of     = pi-period-of NO-ERROR.
    IF NOT AVAILABLE tt-IssCust THEN 
    DO:
        CREATE tt-IssCust.
        ASSIGN 
            tt-IssCust.AccountNumber = issue.AccountNumber
            tt-IssCust.period-of     = pi-period-of.
    END.                                                 
    ASSIGN 
        tt-IssCust.billable    = IF IssActivity.Billable THEN tt-IssCust.billable + IssActivity.Duration ELSE tt-IssCust.billable              
        tt-IssCust.nonbillable = IF NOT IssActivity.Billable THEN tt-IssCust.nonbillable + IssActivity.Duration ELSE tt-IssCust.nonbillable.


END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ReportB) = 0 &THEN

PROCEDURE ReportB :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/



    FOR EACH webuser NO-LOCK
        WHERE webuser.companycode = pc-CompanyCode
        AND WebUser.UserClass = "Internal"
        AND IF pc-Engineers = "ALL" THEN TRUE ELSE LOOKUP(webuser.loginid,pc-Engineers,",") > 0
        :
        li-tot-productivity = 0.
        RUN Build-Year( webuser.loginid ,
            lc-period ) NO-ERROR.
        FOR EACH tt-ThisPeriod:
            
            FIND tt-IssUser WHERE tt-IssUser.ActivityBy = webuser.loginid
                AND   tt-IssUser.period-of  = td-period
                NO-ERROR.
            IF AVAILABLE tt-IssUser 
            THEN ASSIGN tt-IssUser.productivity = td-hours
                    li-tot-productivity  = li-tot-productivity + td-hours. 
        END.
        FIND tt-IssTotal WHERE tt-IssTotal.ActivityBy = webuser.loginid NO-ERROR.
        IF AVAILABLE tt-IssTotal 
        THEN ASSIGN tt-IssTotal.productivity = li-tot-productivity.
    END.
 
END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ReportC) = 0 &THEN

PROCEDURE ReportC :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE pi-num-issues AS INTEGER EXTENT 55 NO-UNDO.     
    DEFINE VARIABLE pi-period-of  AS INTEGER NO-UNDO.
  
    FOR EACH Customer NO-LOCK
        WHERE Customer.companycode = pc-CompanyCode
        AND  IF pc-Customers = "ALL" THEN TRUE ELSE  LOOKUP(Customer.AccountNumber,pc-Customers,",") > 0
        BREAK BY Customer.AccountNumber: 
    
        ASSIGN 
            pi-num-issues = 0.
    
        FOR EACH issue OF customer NO-LOCK WHERE issue.IssueDate >= hi-date 
            AND   issue.IssueDate <= lo-date  BREAK BY issue.IssueNumber :
    
            pi-period-of = INTEGER(ENTRY(periodType,getDate(issue.IssueDate),"|")).
  
            pi-num-issues[pi-period-of] = pi-num-issues[pi-period-of]  + 1.

        END.

        FOR EACH tt-IssCust WHERE tt-IssCust.AccountNumber = Customer.AccountNumber:
            ASSIGN 
                tt-IssCust.num-issues = pi-num-issues[tt-IssCust.period-of].
        END.

    END.

END PROCEDURE.


&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-CreateExcel) = 0 &THEN

FUNCTION CreateExcel RETURNS LOGICAL
    ( offline AS CHARACTER ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    CREATE "Excel.Application" chExcelApplication.                   /* create a new Excel Application object */
    chExcelApplication:DisplayAlerts = FALSE.
    chExcelApplication:interactive   = offline = "online".
    IF offline = "online"  THEN chExcelApplication:Visible = TRUE.   /* launch Excel so it is visible to the user */
    ELSE chExcelApplication:Visible = FALSE.
    chExcelApplication:ErrorCheckingOptions:NumberAsText = FALSE.
    chWorkbook = chExcelApplication:Workbooks:Add().                 /* create a new Workbook */ 
    MESSAGE "bOOK STARTED" VIEW-AS ALERT-BOX.
  chExcelApplication:Visible = TRUE. 
    RETURN TRUE.

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

FUNCTION Date2Wk RETURNS CHARACTER
    (INPUT dMyDate AS DATE) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    /* returns DAY WEEK YEAR */
    DEFINE VARIABLE cYear    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iWkNo    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iDayNo   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dYrBegin AS DATE      NO-UNDO.
    DEFINE VARIABLE WkOne    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE WkSt     AS INTEGER   INITIAL 2 NO-UNDO. /* 1=Sun,2=Mon */
    DEFINE VARIABLE DayList  AS CHARACTER NO-UNDO.
    IF WkSt = 1 THEN DayList = "1,2,3,4,5,6,7".
    ELSE DayList = "7,1,2,3,4,5,6".
    ASSIGN 
        cYear = STRING(YEAR(dMyDate))
        WkOne = WEEKDAY(DATE("01/01/" + cYear))
        WkOne = INTEGER(ENTRY(WkOne,DayList)).
    IF WkOne < 5 
        OR WkOne = 1 THEN dYrBegin = DATE("01/01/" + cYear).
    ELSE dYrBegin = DATE("01/01/" + cYear) + WkOne.
    ASSIGN 
        iDayNo = INTEGER(dMyDate - dYrBegin) + 1  
        iWkNo  = ROUND(iDayNo / 7,0) + 1 . 
    RETURN STRING(STRING(iDayNo) + "|" + string(iWkNo) + "|" + cYear).
END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-dayOfWeek) = 0 &THEN

FUNCTION dayOfWeek RETURNS INTEGER
    (INPUT dMyDate AS DATE) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE rDate   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE WkSt    AS INTEGER   INITIAL 2 NO-UNDO. /* 1=Sun,2=Mon */
    DEFINE VARIABLE DayList AS CHARACTER NO-UNDO.
    IF WkSt = 1 THEN DayList = "1,2,3,4,5,6,7".
    ELSE DayList = "7,1,2,3,4,5,6".

    rDate = WEEKDAY(dMyDate).
    rDate = INTEGER(ENTRY(rDate,DayList)).
    RETURN  rDate.

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-ExcelBorders) = 0 &THEN

FUNCTION ExcelBorders RETURNS LOGICAL
    ( colF      AS CHARACTER,
    colT      AS CHARACTER,
    colColour AS CHARACTER,   
    edgeL     AS CHARACTER,   
    edgeT     AS CHARACTER,   
    edgeR     AS CHARACTER,   
    edgeB     AS CHARACTER,   
    lineL     AS CHARACTER,   
    lineT     AS CHARACTER,   
    lineR     AS CHARACTER,   
    lineB     AS CHARACTER ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE edgeWeight AS CHARACTER INITIAL "" NO-UNDO.
    DEFINE VARIABLE edgeLine   AS CHARACTER INITIAL "" NO-UNDO.


    objRange = chWorkSheet:Range(colF + ":" + colT).
 
    IF colColour <> "" THEN objRange:Interior:ColorIndex = INTEGER(colColour).

    IF edgeL  <> "" THEN objRange:Borders({&xlEdgeLeft}):Weight   = IF edgeL = "1" THEN {&xlThick} ELSE IF edgeL = "2" THEN {&xlThin} ELSE {&xlMedium}.
    IF edgeT  <> "" THEN objRange:Borders({&xlEdgeTop}):Weight    = IF edgeT = "1" THEN {&xlThick} ELSE IF edgeT = "2" THEN {&xlThin} ELSE {&xlMedium}. 
    IF edgeR  <> "" THEN objRange:Borders({&xlEdgeRight}):Weight  = IF edgeR = "1" THEN {&xlThick} ELSE IF edgeR = "2" THEN {&xlThin} ELSE {&xlMedium}.  
    IF edgeB  <> "" THEN objRange:Borders({&xlEdgeBottom}):Weight = IF edgeB = "1" THEN {&xlThick} ELSE IF edgeB = "2" THEN {&xlThin} ELSE {&xlMedium}. 

    IF lineL  <> "" THEN objRange:Borders({&xlEdgeLeft}):linestyle   = {&xlContinuous}.    
    IF lineT  <> "" THEN objRange:Borders({&xlEdgeTop}):linestyle    = {&xlContinuous}.     
    IF lineR  <> "" THEN objRange:Borders({&xlEdgeRight}):linestyle  = {&xlContinuous}.   
    IF lineB  <> "" THEN objRange:Borders({&xlEdgeBottom}):linestyle = {&xlContinuous}.  
 

    RETURN TRUE.   /* Function return value. */

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-FinishExcel) = 0 &THEN

FUNCTION FinishExcel RETURNS LOGICAL
    ( offline AS CHARACTER ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    IF offline = "online"  THEN chExcelApplication:Visible = TRUE.
    ELSE 
    DO:  
        chExcelApplication:ActiveWorkBook:Saved = TRUE NO-ERROR.
        chExcelApplication:ActiveSheet:Saveas(lc-FileSaveAs, "1") NO-ERROR.
    END.
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


&ENDIF

&IF DEFINED(EXCLUDE-getDate) = 0 &THEN

FUNCTION getDate RETURNS CHARACTER
    (INPUT dMyDate AS DATE) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    /* returns WEEK MONTH YEAR */
    DEFINE VARIABLE cMonth AS CHARACTER NO-UNDO.
    DEFINE VARIABLE rDate  AS CHARACTER NO-UNDO.
    cMonth = STRING(MONTH(dMyDate)).
    rDate = Date2WK(dMyDate).
    IF ENTRY(2,rDate,"|") = "0"  THEN rDate = Date2WK(dMyDate - 5).
    RETURN STRING(ENTRY(2,rDate,"|") + "|" + cMonth + "|" + string(YEAR(dMyDate))).

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-Mth2Date) = 0 &THEN

FUNCTION Mth2Date RETURNS CHARACTER
    (cMthYrNo AS CHARACTER):
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE iYear     AS INTEGER NO-UNDO FORMAT "9999".
    DEFINE VARIABLE iMthNo    AS INTEGER NO-UNDO.
    DEFINE VARIABLE iDate     AS DATE    NO-UNDO EXTENT 12 FORMAT "99/99/99".
    DEFINE VARIABLE iMonthNum AS INTEGER NO-UNDO. 
    IF INDEX(cMthYrNo,"-") <> 3 THEN RETURN "Format should be xx-xxxx".
    ASSIGN 
        iMonthNum = INTEGER(ENTRY(1,cMthYrNo,"-")).     /* set month */
    iYear     = INTEGER(ENTRY(2,cMthYrNo,"-")).         /* set year  */
    DO iMthNo = 2 TO 13:
        IF iMthNo <> 13 THEN iDate[iMthNo - 1] = DATE(iMthNo,1,iYear) - 1.
        ELSE iDate[12] = DATE(1,1,iYear + 1) - 1.
    END.
    RETURN STRING("01/" + string(iMonthNum) + "/" + string(iYear) + "|" + string(iDate[iMonthNum],"99/99/9999")).
END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-percentage-calc) = 0 &THEN

FUNCTION percentage-calc RETURNS DECIMAL
    ( p-one AS DECIMAL,
    p-two AS DECIMAL ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE p-result AS DECIMAL.
    /*  p-one =   billable/nonbillable total      */
    /*  p-two =   productivity / contarcted hours */
    p-result = ROUND(( p-one * 100) / p-two , 2).
    RETURN p-result.

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-safe-Chars) = 0 &THEN

FUNCTION safe-Chars RETURNS CHARACTER
    (  char_in AS CHARACTER ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    IF TRIM(char_in) BEGINS "-" THEN
        ASSIGN char_in = REPLACE(char_in, "-":U, " ~ ":U)  .     /* minuss mess with cell entry */
    RETURN char_in. 

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-ThisDate) = 0 &THEN

FUNCTION ThisDate RETURNS CHARACTER
    (INPUT thisday AS DATE) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE td AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dd AS CHARACTER NO-UNDO.
    DEFINE VARIABLE mm AS CHARACTER NO-UNDO.
    DEFINE VARIABLE yy AS CHARACTER NO-UNDO.
    DEFINE VARIABLE da AS CHARACTER NO-UNDO.
    ASSIGN  
        dd = STRING(DAY(thisday))
        mm = ENTRY(MONTH(thisday),"Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec",",")
        yy = STRING(YEAR(thisday))
        da = ENTRY(WEEKDAY(thisday),"Sun,Mon,Tue,Wed,Thu,Fri,Sat",",")
        td = da + " " + dd + " " + mm + " " + yy .

    RETURN td.

END FUNCTION.


&ENDIF

&IF DEFINED(EXCLUDE-Wk2Date) = 0 &THEN

FUNCTION Wk2Date RETURNS CHARACTER
    (cWkYrNo AS CHARACTER):
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    DEFINE VARIABLE cYear    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iWkNo    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iDayNo   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iSDayNo  AS DATE      NO-UNDO.
    DEFINE VARIABLE iEDayNo  AS DATE      NO-UNDO.
    DEFINE VARIABLE dYrBegin AS DATE      NO-UNDO.
    DEFINE VARIABLE WkOne    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE WkSt     AS INTEGER   INITIAL 2 NO-UNDO. /* 1=Sun,2=Mon */
    IF INDEX(cWkYrNo,"-") <> 3 THEN RETURN "Format should be xx-xxxx".
    ASSIGN 
        cYear = ENTRY(2,cWkYrNo,"-")
        WkOne = WEEKDAY(DATE("01/01/" + cYear)).
    IF WkOne <= 5 THEN dYrBegin = DATE("01/01/" + cYear).
    ELSE dYrBegin = DATE("01/01/" + cYear) + WkOne.
    ASSIGN 
        iWkNo   = INTEGER(ENTRY(1,cWkYrNo,"-"))
        iDayNo  = (iWkNo * 7) - 7
        iSDayNo = dYrBegin + iDayNo - WkOne + WkSt 
        iEDayNo = iSDayNo + 6 .
    RETURN STRING(STRING(iSDayNo,"99/99/9999") + "|" + string(iEDayNo,"99/99/9999")).

END FUNCTION.


&ENDIF

