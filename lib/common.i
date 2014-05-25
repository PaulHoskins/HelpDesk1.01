&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************

    Program:        lib/common.i
    
    Purpose:             
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      Initial
    
    03/08/2010  DJS         Clarified ambiguous buffer names.
    01/05/2014  phoski      New functions
    
***********************************************************************/

{lib/attrib.i}
{lib/slatt.i}

&global-define INTERNAL INTERNAL
&global-define CUSTOMER CUSTOMER
&global-define CONTRACT CONTRACT

def var lc-global-selcode                   as char 
    initial "WALESFOREVER"                  no-undo.
def var lc-global-seldesc                   as char
    initial "None"                     no-undo.

def var lc-global-company                   as char no-undo.
def var lc-global-user                      as char no-undo.
def var lc-global-internal                  as char 
    initial "INTERNAL,CONTRACT"             no-undo.

def var lc-global-dtype                     as char
    initial "Text|Number|Date|Note|Yes/No"           no-undo.

def var lc-global-respaction-code           as char
    initial "None|Email|EmailPage|Page|Web" no-undo.
def var lc-global-respaction-display        as char
    initial "None|Send Email|Send Email & SMS|Send SMS|Web Alert" no-undo.

def var lc-global-tbase-code                as char
    initial "OFF|REAL"                      no-undo.
def var lc-global-tbase-display             as char
    initial "Office Hours|24 Hours"         no-undo.

def var lc-global-abase-code                as char
    initial "ISSUE|ALERT"                   no-undo.
def var lc-global-abase-display             as char
    initial "Issue Date/Time|Previous Alert Date/Time"         
                                            no-undo.

def var lc-global-respunit-code             as char
    initial "None|Minute|Hour|Day|Week"     no-undo.
def var lc-global-respunit-display          as char
    initial "None|Minute|Hour|Day|Week"     no-undo.

def var lc-global-action-code                as char
    initial "OPEN|CLOSED"                    no-undo.
def var lc-global-action-display             as char
    initial "Open|Closed"                    no-undo.

def var lc-global-hour-code                 as char no-undo.
def var lc-global-hour-display              as char no-undo.
def var lc-global-min-code                 as char no-undo.
def var lc-global-min-display              as char no-undo.

def var lc-System-KB-Code                   as char
    initial "SYS.ISSUE"                     no-undo.
def var lc-System-KB-Desc                   as char
    initial "Completed Issues"              no-undo.

def var lc-System-Note-Code                 as char
    initial 'SYS.ACCOUNT,SYS.EMAILCUST,SYS.ASSIGN,SYS.SLA,SYS.MISC,SYS.SLAWARN,SYS.SLAMISSED'  no-undo.
def var lc-System-Note-Desc                 as char
    initial 'System - Account Changed,System - Customer Emailed,System - Issue Assignment,System - SLA Assigned,System - Misc Note,System - SLA Warning,System - SLA Missed'
    no-undo.

DEF VAR lc-global-GT-Code       AS CHAR INITIAL
    'Asset.Type,Asset.Manu,Asset.Status'        NO-UNDO.


DEF VAR lc-global-iclass-code   AS CHAR INITIAL
    'Issue|Admin|Project'                       NO-UNDO.



def var lc-global-SupportTicket-Code               as char
    initial 'NONE|YES|BOTH'                 no-undo.
def var lc-global-SupportTicket-Desc               as char
    initial 'Standard Support Only|Ticket Support Only|Standard And Ticket Support'
                                     
    no-undo.
def var lc-global-Allow-TicketSupport       as char
    initial 'YES|BOTH'                 no-undo.
def var lc-global-sms-username              as char
    initial 'tomcarroll'                        no-undo.
def var lc-global-sms-password              as char
    initial 'cr34tion'                      no-undo.

def var lc-global-excludeType               as char
    initial "exe,vbs"                       no-undo.

DEF VAR li-global-sla-fail      AS INT INITIAL  10  NO-UNDO.
DEF VAR li-global-sla-amber     AS INT INITIAL  20  NO-UNDO.
DEF VAR li-global-sla-ok        AS INT INITIAL  30  NO-UNDO.
DEF VAR li-global-sla-na        AS INT INITIAL  99  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AllowCustomerAccess Include 
FUNCTION com-AllowCustomerAccess RETURNS LOGICAL
  ( pc-CompanyCode as char,
    pc-LoginID as char,
    pc-AccountNumber as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AllowTicketSupport Include 
FUNCTION com-AllowTicketSupport RETURNS LOGICAL
  ( pr-rowid as rowid )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AreaName Include 
FUNCTION com-AreaName RETURNS CHARACTER
  ( pc-CompanyCode as char ,
    pc-AreaCode    AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AskTicket Include 
FUNCTION com-AskTicket RETURNS LOGICAL
  ( pc-companyCode  as char,
    pc-AccountNumber      as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AssignedToUser Include 
FUNCTION com-AssignedToUser RETURNS INTEGER
 ( pc-CompanyCode as char,
   pc-LoginID     as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CanDelete Include 
FUNCTION com-CanDelete RETURNS LOGICAL
  ( pc-loginid  as char,
    pc-table    as char,
    pr-rowid    as rowid )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CatName Include 
FUNCTION com-CatName RETURNS CHARACTER
  ( pc-CompanyCode as char,
    pc-Code AS CHAR
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CheckSystemSetup Include 
FUNCTION com-CheckSystemSetup RETURNS LOGICAL
  ( pc-CompanyCode as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CookieDate Include 
FUNCTION com-CookieDate RETURNS DATE
  ( pc-user as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CookieTime Include 
FUNCTION com-CookieTime RETURNS INTEGER
( pc-user as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CustomerAvailableSLA Include 
FUNCTION com-CustomerAvailableSLA RETURNS CHARACTER
  ( pc-CompanyCode as char,
    pc-AccountNumber as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CustomerName Include 
FUNCTION com-CustomerName RETURNS CHARACTER
  ( pc-Company as char,
    pc-Account  as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CustomerOpenIssues Include 
FUNCTION com-CustomerOpenIssues RETURNS INTEGER
 ( pc-CompanyCode as char,
   pc-accountNumber as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-DecodeLookup Include 
FUNCTION com-DecodeLookup RETURNS CHARACTER
  ( pc-code as char,
    pc-code-list as char,
    pc-code-display as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-DescribeTicket Include 
FUNCTION com-DescribeTicket RETURNS CHARACTER
  ( pc-TxnType as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-GenTabDesc Include 
FUNCTION com-GenTabDesc RETURNS CHARACTER
  ( pc-CompanyCode as char,
    pc-GType AS CHAR,
    pc-Code AS CHAR
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-GetDefaultCategory Include 
FUNCTION com-GetDefaultCategory RETURNS CHARACTER
  ( pc-CompanyCode as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-Initialise Include 
FUNCTION com-Initialise RETURNS logical
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-InitialSetup Include 
FUNCTION com-InitialSetup RETURNS LOGICAL
  ( pc-LoginID as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-InternalTime Include 
FUNCTION com-InternalTime RETURNS INTEGER
  ( pi-hours as int,
    pi-mins  as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-IsContractor Include 
FUNCTION com-IsContractor RETURNS LOGICAL
  ( pc-companyCode  as char,
    pc-LoginID      as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-IsCustomer Include 
FUNCTION com-IsCustomer RETURNS LOGICAL
  ( pc-companyCode  as char,
    pc-LoginID      as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-IssueStatusAlert Include 
FUNCTION com-IssueStatusAlert RETURNS LOGICAL
  ( pc-CompanyCode as char,
    pc-CreateSource as char,
    pc-StatusCode   as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-IsSuperUser Include 
FUNCTION com-IsSuperUser RETURNS LOGICAL
  ( pc-LoginID      as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-MonthBegin Include 
FUNCTION com-MonthBegin RETURNS DATE
  ( pd-date as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-MonthEnd Include 
FUNCTION com-MonthEnd RETURNS DATE
  ( pd-date as date )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NearestTimeUnit Include 
FUNCTION com-NearestTimeUnit RETURNS INTEGER
  ( pi-time as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfActions Include 
FUNCTION com-NumberOfActions RETURNS INTEGER
  ( pc-LoginID as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfAlerts Include 
FUNCTION com-NumberOfAlerts RETURNS INTEGER
 ( pc-LoginID as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfEmails Include 
FUNCTION com-NumberOfEmails RETURNS INTEGER
  ( pc-LoginID as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfInventoryWarnings Include 
FUNCTION com-NumberOfInventoryWarnings RETURNS INTEGER
    ( pc-LoginID as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfOpenActions Include 
FUNCTION com-NumberOfOpenActions RETURNS INTEGER
  ( pc-LoginID as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberUnAssigned Include 
FUNCTION com-NumberUnAssigned RETURNS INTEGER
 ( pc-CompanyCode as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-QuickView Include 
FUNCTION com-QuickView RETURNS logical
  ( pc-LoginID  as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-RequirePasswordChange Include 
FUNCTION com-RequirePasswordChange RETURNS LOGICAL
  ( pc-user as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-SLADescription Include 
FUNCTION com-SLADescription RETURNS CHARACTER
    ( pf-SLAID as dec )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-StatusTrackIssue Include 
FUNCTION com-StatusTrackIssue RETURNS LOGICAL
  ( pc-companycode as char,
    pc-StatusCode  as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-StringReturn Include 
FUNCTION com-StringReturn RETURNS CHARACTER
  ( pc-orig as char,
    pc-add as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-SystemLog Include 
FUNCTION com-SystemLog RETURNS LOGICAL
  ( pc-ActType as char,
    pc-LoginID as char,
    pc-AttrData as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-TicketOnly Include 
FUNCTION com-TicketOnly RETURNS LOGICAL
  ( pc-companyCode  as char,
    pc-AccountNumber      as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-TimeReturn Include 
FUNCTION com-TimeReturn RETURNS CHARACTER
  ( pc-Type as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-TimeToString Include 
FUNCTION com-TimeToString RETURNS CHARACTER
  ( pi-time as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-UserName Include 
FUNCTION com-UserName RETURNS CHARACTER
  ( pc-LoginID as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-UsersCompany Include 
FUNCTION com-UsersCompany RETURNS CHARACTER
  ( pc-LoginID  as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-UserTrackIssue Include 
FUNCTION com-UserTrackIssue RETURNS logical
    ( pc-LoginID as char
     )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-WriteQueryInfo Include 
FUNCTION com-WriteQueryInfo RETURNS LOGICAL
  ( hQuery AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15.38
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DYNAMIC-FUNCTION('com-Initialise':U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GenTabSelect Include 
PROCEDURE com-GenTabSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pc-CompanyCode as char no-undo.
    DEF INPUT  PARAM pc-GType       AS CHAR NO-UNDO.

    def output param pc-code     as char no-undo.
    def output param pc-Desc     as char no-undo.

    DEF VAR icount AS INT       NO-UNDO.


    def buffer b-GenTab for GenTab.

    for each b-GenTab no-lock 
        where b-GenTab.CompanyCode = pc-CompanyCode
          AND b-GenTab.gType = pc-gType
       :

        if icount = 0 
        then assign pc-code = b-GenTab.gCode
                    pc-Desc    = b-GenTab.Descr.

        else assign pc-code = pc-code + '|' + 
               b-GenTab.gCode
               pc-Desc = pc-Desc + '|' + 
               b-GenTab.Descr.

        icount = icount + 1.

    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetAction Include 
PROCEDURE com-GetAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  pc-CompanyCode     as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Desc            as char no-undo.


    def buffer b-buffer for WebAction.

    for each b-buffer no-lock 
        where b-buffer.CompanyCode = pc-CompanyCode
        by b-buffer.Description:

        if pc-codes = ""
        then assign pc-Codes = b-buffer.ActionCode
                    pc-Desc = b-buffer.Description.
        else assign pc-Codes = pc-Codes + '|' + 
               b-buffer.ActionCode
               pc-Desc = pc-Desc + '|' + 
               b-buffer.Description.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetActivityType Include 
PROCEDURE com-GetActivityType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input  param pc-companyCode     as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Active          as char no-undo.
    def output param pc-Desc            as char no-undo.
    def output param pc-Time            as char no-undo.

/* def var acttype as char initial "Take Call|Travel for Job|Analyse Fault|Repair Fault|Order Goods".  */
/* def var actcodes as char initial "1|2|3|4|5".                                                       */

    def buffer b-WebActType for WebActType .

    assign pc-Codes  = ""
           pc-Active = ""
           pc-Desc   = ""
           pc-Time   = "".


    for each b-WebActType no-lock 
        where b-WebActType.CompanyCode = pc-CompanyCode
        break by b-WebActType.TypeID 
              :

        assign pc-Codes  = pc-Codes  + '|' + string(b-WebActType.TypeID)
               pc-Active = pc-Active + '|' + b-WebActType.ActivityType 
               pc-Desc   = pc-Desc   + '|' + b-WebActType.Description  
               pc-Time   = pc-Time   + '|' + string(b-WebActType.MinTime)
          .
    end.

    assign
        pc-Codes  = substr(pc-Codes,2)
        pc-Active = substr(pc-Active,2)
        pc-Desc   = substr(pc-Desc,2)  
        pc-Time   = substr(pc-Time,2).  
    
    
    
    
    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetArea Include 
PROCEDURE com-GetArea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  pc-CompanyCode     as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Desc            as char no-undo.


    def buffer b-IssArea for WebIssArea.

    assign pc-Codes = dynamic-function("htmlib-Null") + "|NotAssigned"
           pc-Desc = "All Areas|Not Assigned".


    for each b-IssArea no-lock 
        where b-IssArea.CompanyCode = pc-CompanyCode
        /* by b-IssArea.Description: */
        :
        assign pc-Codes = pc-Codes + '|' + 
               b-IssArea.AreaCode
               pc-Desc = pc-Desc + '|' + 
               b-IssArea.Description.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetAreaIssue Include 
PROCEDURE com-GetAreaIssue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  pc-CompanyCode     as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Desc            as char no-undo.


    def buffer b-IssArea for WebIssArea.

    assign pc-Codes = ""
           pc-Desc = "Not Applicable/Known".


    for each b-IssArea no-lock 
        where b-IssArea.CompanyCode = pc-CompanyCode
        by b-IssArea.Description:
        assign pc-Codes = pc-Codes + '|' + 
               b-IssArea.AreaCode
               pc-Desc = pc-Desc + '|' + 
               b-IssArea.Description.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetAssign Include 
PROCEDURE com-GetAssign :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-CompanyCode as char no-undo.
    def output param pc-LoginID     as char no-undo.
    def output param pc-Name        as char no-undo.


    def buffer b-user for WebUser.

    assign pc-LoginID = dynamic-function("htmlib-Null") + "|NotAssigned"
           pc-name = "All People|Not Assigned".


    for each b-user no-lock 
        where can-do(lc-global-internal,b-user.UserClass)
        and b-user.CompanyCode = pc-CompanyCode
        by b-user.name:
        assign pc-LoginID = pc-LoginID + '|' + 
               b-user.LoginID
               pc-name = pc-name + '|' + 
               b-user.Name.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetAssignIssue Include 
PROCEDURE com-GetAssignIssue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-CompanyCode as char no-undo.
    def output param pc-LoginID     as char no-undo.
    def output param pc-Name        as char no-undo.


    def buffer b-user for WebUser.

    assign pc-LoginID = ""
           pc-name = "Not Assigned".


    for each b-user no-lock 
        where can-do(lc-global-internal,b-user.UserClass)
        and b-user.CompanyCode = pc-CompanyCode
        by b-user.name:
        assign pc-LoginID = pc-LoginID + '|' + 
               b-user.LoginID
               pc-name = pc-name + '|' + 
               b-user.Name.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetAssignList Include 
PROCEDURE com-GetAssignList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-CompanyCode as char no-undo.
    def output param pc-LoginID     as char no-undo.
    def output param pc-Name        as char no-undo.


    def buffer b-user for WebUser.

    for each b-user no-lock 
        where can-do(lc-global-internal,b-user.UserClass)
        and b-user.CompanyCode = pc-CompanyCode
        by b-user.name:

        if pc-loginID = ""
        then assign pc-loginID = b-user.LoginID
                    pc-name    = b-user.Name.

        else assign pc-LoginID = pc-LoginID + '|' + 
               b-user.LoginID
               pc-name = pc-name + '|' + 
               b-user.Name.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetAutoAction Include 
PROCEDURE com-GetAutoAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  pc-CompanyCode     as char no-undo.
    def input param  pc-Exclude         as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Desc            as char no-undo.

    def buffer b-buffer for WebAction.

    assign
        pc-codes = ""
        pc-desc  = "No Auto Action".

    for each b-buffer no-lock 
        where b-buffer.CompanyCode = pc-CompanyCode
        by b-buffer.Description:

        if b-buffer.ActionCode = pc-Exclude then next.

        assign pc-Codes = pc-Codes + '|' + 
               b-buffer.ActionCode
               pc-Desc = pc-Desc + '|' + 
               b-buffer.Description.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetCategoryIssue Include 
PROCEDURE com-GetCategoryIssue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-company             as char no-undo.
    def output param pc-CatCode             as char no-undo.
    def output param pc-Description         as char no-undo.

    
    def buffer b-Cat for WebIssCat.

   
    assign pc-CatCode = ""
           pc-Description = "".

    for each b-Cat no-lock
        where b-Cat.CompanyCode = pc-company
           by b-Cat.description
            :

        if pc-CatCode = ""
        then assign  pc-CatCode     = b-Cat.CatCode
                     pc-Description = b-Cat.Description.
        else assign pc-CatCode      = pc-CatCode + '|' + b-Cat.CatCode
                    pc-Description  = pc-Description + '|' + b-Cat.Description.

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetCatSelect Include 
PROCEDURE com-GetCatSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  pc-CompanyCode     as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Desc            as char no-undo.


    def buffer b-IssArea for WebIssCat.

    assign pc-Codes = dynamic-function("htmlib-Null")
           pc-Desc = "All Categories".


    for each b-IssArea no-lock 
        where b-IssArea.CompanyCode = pc-CompanyCode
        /* by b-IssArea.Description: */
        :
        assign pc-Codes = pc-Codes + '|' + 
               b-IssArea.CatCode
               pc-Desc = pc-Desc + '|' + 
               b-IssArea.Description.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetCustomer Include 
PROCEDURE com-GetCustomer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-CompanyCode      as char no-undo.
    def input param pc-LoginID          as char no-undo.
    def output param pc-AccountNumber   as char no-undo.
    def output param pc-Name            as char no-undo.


    def buffer b-cust for customer.
    def buffer b-user for WebUser.

    assign pc-AccountNumber = dynamic-function("htmlib-Null")
           pc-name = "All Customers".

    find b-user where b-user.LoginID = pc-LoginID no-lock no-error.
    
    for each b-cust no-lock 
        where b-cust.CompanyCode = pc-CompanyCode
            by b-cust.name:
        if avail b-user then
        do:
            if not DYNAMIC-FUNCTION('com-AllowCustomerAccess':U,
                                    pc-companyCode,
                                    pc-LoginID,
                                    b-cust.AccountNumber) then next.
        end.
        assign pc-AccountNumber = pc-AccountNumber + '|' + 
               b-cust.AccountNumber
               pc-name = pc-name + '|' + 
               b-cust.Name.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetCustomerAccount Include 
PROCEDURE com-GetCustomerAccount :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-CompanyCode      as char no-undo.
    def input param pc-LoginID          as char no-undo.
    def output param pc-AccountNumber   as char no-undo.
    def output param pc-Name            as char no-undo.


    def buffer b-cust for customer.
    def buffer b-user for WebUser.

   
    find b-user where b-user.LoginID = pc-LoginID no-lock no-error.
    
    for each b-cust no-lock 
        where b-cust.CompanyCode = pc-CompanyCode
            by b-cust.AccountNumber:
        IF pc-AccountNumber = "" 
        THEN ASSIGN 
                pc-AccountNumber = b-cust.AccountNumber
                pc-name = b-cust.AccountNumber + " " + b-cust.NAME.
        ELSE assign 
               pc-AccountNumber = pc-AccountNumber + '|' + 
               b-cust.AccountNumber
               pc-name = pc-name + '|' + 
               b-cust.AccountNumber + " " + b-cust.Name.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetInternalUser Include 
PROCEDURE com-GetInternalUser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-CompanyCode as char no-undo.
    def output param pc-LoginID     as char no-undo.
    def output param pc-Name        as char no-undo.


    def buffer b-user for WebUser.

   
    for each b-user no-lock 
        where can-do(lc-global-internal,b-user.UserClass)
        and b-user.CompanyCode = pc-CompanyCode
        by b-user.name:

        if pc-loginID = ""
        then assign pc-LoginID = b-user.LoginID
                    pc-name    = b-user.name.
        else assign pc-LoginID = pc-LoginID + '|' + 
                      b-user.LoginID
                    pc-name = pc-name + '|' + 
                        b-user.Name.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetKBSection Include 
PROCEDURE com-GetKBSection :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  pc-CompanyCode     as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Desc            as char no-undo.


    def buffer b-buffer for knbSection.

    for each b-buffer no-lock 
        where b-buffer.CompanyCode = pc-CompanyCode
        by b-buffer.Description:

        if pc-codes = ""
        then assign pc-Codes = b-buffer.knbCode
                    pc-Desc = b-buffer.Description.
        else assign pc-Codes = pc-Codes + '|' + b-buffer.knbCode
                    pc-Desc = pc-Desc + '|' + b-buffer.Description.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetStatus Include 
PROCEDURE com-GetStatus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-companyCode     as char no-undo.
    def output param pc-Codes   as char no-undo.
    def output param pc-Name            as char no-undo.


    def buffer b-WebStatus for WebStatus.

    assign pc-Codes = dynamic-function("htmlib-Null")
           pc-name = "All Status Codes".


    for each b-WebStatus no-lock 
        where b-WebStatus.CompanyCode = pc-CompanyCode
        break by b-WebStatus.CompletedStatus 
              by ( if b-WebStatus.DisplayOrder = 0 then 99999 else b-Webstatus.DisplayOrder )
              by b-WebStatus.description:
        if first-of(b-WebStatus.CompletedStatus) then
        do:
            if b-WebStatus.CompletedStatus = false 
            then assign pc-Codes = pc-Codes + "|AllOpen"
                        pc-name = pc-name + '|* All Open'.
            else assign pc-Codes = pc-Codes + "|AllClosed"
                        pc-name = pc-name + '|* All Closed'.

        end.
        assign pc-Codes = pc-Codes + '|' + 
               b-WebStatus.StatusCode
               pc-name = pc-name + '|&nbsp;&nbsp;&nbsp;' + 
               b-WebStatus.description.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetStatusIssue Include 
PROCEDURE com-GetStatusIssue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input  param pc-companyCode     as char no-undo.
    def output param pc-Codes   as char no-undo.
    def output param pc-Name            as char no-undo.


    def buffer b-WebStatus for WebStatus.

    assign pc-Codes = ""
           pc-name =  "".


    for each b-WebStatus no-lock 
        where b-WebStatus.CompanyCode = pc-CompanyCode
        break by b-WebStatus.CompletedStatus 
              by ( if b-WebStatus.DisplayOrder = 0 then 99999 else b-Webstatus.DisplayOrder )
              by b-WebStatus.description:
        assign pc-Codes = pc-Codes + '|' + 
               b-WebStatus.StatusCode
               pc-name = pc-name + '|' + 
               b-WebStatus.description + " (" + 
                ( if b-WebStatus.CompletedStatus then "Closed" else "Open" ) + 
            ")".
    end.

    assign
        pc-codes = substr(pc-codes,2)
        pc-name  = substr(pc-name,2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetStatusOpenOnly Include 
PROCEDURE com-GetStatusOpenOnly :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-companyCode     as char no-undo.
    def output param pc-Codes   as char no-undo.
    def output param pc-Name            as char no-undo.


    def buffer b-WebStatus for WebStatus.

    assign pc-Codes = "AllOpen"
           pc-name = "All Open".


    for each b-WebStatus no-lock 
        where b-WebStatus.CompanyCode = pc-CompanyCode
          AND b-webStatus.CompletedStatus = FALSE
        break by b-WebStatus.CompletedStatus 
              by ( if b-WebStatus.DisplayOrder = 0 then 99999 else b-Webstatus.DisplayOrder )
              by b-WebStatus.description:
                                                                   /*
                                                                   if first-of(b-WebStatus.CompletedStatus) then
        do:
            if b-WebStatus.CompletedStatus = false 
            then assign pc-Codes = pc-Codes + "|AllOpen"
                        pc-name = pc-name + '|* All Open'.
            else assign pc-Codes = pc-Codes + "|AllClosed"
                        pc-name = pc-name + '|* All Closed'.

        end.
        */
        assign pc-Codes = pc-Codes + '|' + 
               b-WebStatus.StatusCode
               pc-name = pc-name + '|&nbsp;&nbsp;&nbsp;' + 
               b-WebStatus.description.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetTeams Include 
PROCEDURE com-GetTeams :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  pc-CompanyCode     as char no-undo.
    def output param pc-Codes           as char no-undo.
    def output param pc-Desc            as char no-undo.


    def buffer b-buffer for steam.

    for each b-buffer no-lock 
        where b-buffer.CompanyCode = pc-CompanyCode
        :

        if pc-codes = ""
        then assign pc-Codes = string(b-buffer.st-num)
                    pc-Desc = b-buffer.Descr.
        else assign pc-Codes = pc-Codes + '|' + 
               string(b-buffer.st-num)
               pc-Desc = pc-Desc + '|' + 
               b-buffer.Descr.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-ResetDefaultStatus Include 
PROCEDURE com-ResetDefaultStatus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-CompanyCode      as char     no-undo.

    def buffer b-WebStatus  for WebStatus.

    for each b-WebStatus
        where b-WebStatus.CompanyCode = pc-CompanyCode
          and b-WebStatus.DefaultCode exclusive-lock:

        assign 
            b-WebStatus.DefaultCode = no.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-SplitTime Include 
PROCEDURE com-SplitTime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-time     as int      no-undo.
    def output param pi-hours   as int      no-undo.
    def output param pi-mins    as int      no-undo.

    def var li-sec-hours        as int      initial 3600 no-undo.
    def var li-seconds          as int      no-undo.
   
    assign 
        li-seconds = pi-time mod li-sec-hours
        pi-mins = truncate(li-seconds / 60,0).
        
    assign
        pi-time = pi-time - li-seconds.
        
    assign
        pi-hours = truncate(pi-time / li-sec-hours,0).

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-StatusType Include 
PROCEDURE com-StatusType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param     pc-CompanyCode      as char no-undo.
    def output param    pc-open-status      as char no-undo.
    def output param    pc-closed-status    as char no-undo.

    def buffer b-status for WebStatus.

    for each b-status no-lock
        where b-status.CompanyCode = pc-companyCode
        by ( if b-status.DisplayOrder = 0 then 99999 else b-status.DisplayOrder ):
        if b-status.CompletedStatus = false 
        then assign pc-open-status = trim(pc-open-status + ',' + b-status.StatusCode).
        else assign pc-closed-status = trim(pc-closed-status + ',' + b-status.StatusCode).
        
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AllowCustomerAccess Include 
FUNCTION com-AllowCustomerAccess RETURNS LOGICAL
  ( pc-CompanyCode as char,
    pc-LoginID as char,
    pc-AccountNumber as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer b-user       for WebUser.
    def buffer b-ContAccess for ContAccess.
    DEF BUFFER webusteam    FOR webusteam.
    DEF BUFFER customer     FOR customer.
    DEF VAR ll-Steam    AS LOG NO-UNDO.
    DEF VAR ll-Access   AS LOG NO-UNDO.

    
    ll-Steam = CAN-FIND(FIRST webUsteam WHERE webusteam.loginid =  pc-LoginID NO-LOCK).


    find b-user where b-user.LoginID = pc-LoginID no-lock no-error.

    if not avail b-user then return false.

    /*
    ***
    *** If internal member of a team then customer must be in one of his/her team
    ***
    */
    if b-user.UserClass = "{&INTERNAL}" then 
    do:
        IF NOT ll-Steam THEN return true.
        FIND customer WHERE customer.companyCode = pc-CompanyCode
                        AND customer.AccountNumber = pc-AccountNumber NO-LOCK NO-ERROR.
        IF customer.st-num = 0 THEN RETURN FALSE.
        ll-access = CAN-FIND(FIRST webUsteam WHERE webusteam.loginid = pc-LoginID
                                          AND webusteam.st-num = customer.st-num NO-LOCK).
        RETURN ll-access.
    END.

    if b-user.UserClass = "{&CUSTOMER}" then
    do:
        return b-user.AccountNumber = pc-AccountNumber.
    end.

    return can-find(first b-ContAccess where b-ContAccess.LoginID = pc-LoginID 
                      and b-ContAccess.AccountNumber = pc-AccountNumber no-lock ).


 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AllowTicketSupport Include 
FUNCTION com-AllowTicketSupport RETURNS LOGICAL
  ( pr-rowid as rowid ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer customer for customer.

    find customer where rowid(customer) = pr-rowid no-lock no-error.
    if not avail customer then return false.

    return can-do(replace(lc-global-Allow-TicketSupport,"|",","),customer.SupportTicket).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AreaName Include 
FUNCTION com-AreaName RETURNS CHARACTER
  ( pc-CompanyCode as char ,
    pc-AreaCode    AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF BUFFER b1   FOR webissArea.


    FIND b1 WHERE b1.CompanyCode = pc-CompanyCode
              AND b1.AreaCode    = pc-AreaCode
                NO-LOCK NO-ERROR.


    RETURN IF AVAIL b1 THEN b1.DESCRIPTION ELSE "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AskTicket Include 
FUNCTION com-AskTicket RETURNS LOGICAL
  ( pc-companyCode  as char,
    pc-AccountNumber      as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Customer for Customer.

    find Customer
        where Customer.CompanyCode      = pc-companyCode
          and Customer.AccountNumber    = pc-AccountNumber
          no-lock no-error.
    
    if not avail Customer then return false.
    
    return Customer.SupportTicket = "BOTH".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AssignedToUser Include 
FUNCTION com-AssignedToUser RETURNS INTEGER
 ( pc-CompanyCode as char,
   pc-LoginID     as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-return as int      no-undo.

    def buffer Issue        for Issue.
    def buffer WebStatus    for WebStatus.


    for each Issue no-lock
        where Issue.CompanyCode = pc-companyCode
          and Issue.AssignTo = pc-LoginID
          use-index AssignTo ,
          first WebStatus no-lock
                where WebStatus.companyCode = Issue.CompanyCode
                  and WebStatus.StatusCode  = Issue.StatusCode
                  and WebStatus.Completed   = false
          :

        assign li-return = li-return + 1.

    end.

    return li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CanDelete Include 
FUNCTION com-CanDelete RETURNS LOGICAL
  ( pc-loginid  as char,
    pc-table    as char,
    pr-rowid    as rowid ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer webuser      for webuser.
    def buffer customer     for customer.
    def buffer custiv       for custiv.
    def buffer issue        for issue.
    def buffer ivClass      for ivClass.
    def buffer ivSub        for ivSub.
    def buffer ivField      for IvField.
    def buffer CustField    for CustField.
    def buffer webIssCat    for WebIssCat.
    def buffer issAction    for issAction.
    def buffer issStatus    for issStatus.
    def buffer issNote      for IssNote.
    def buffer WebStatus    for WebStatus.
    def buffer webNote      for WebNote.
    def buffer webIssArea   for WebIssArea.
    def buffer knbSection   for knbSection.
    def buffer knbItem      for knbItem.
    def buffer webissagrp   for webissagrp.
    DEF BUFFER steam        FOR steam.

    case pc-table:
        when "webissagrp" then
        do:
            find webissagrp where rowid(webissagrp) = pr-rowid no-lock no-error.
            if not avail webissagrp then return false.
            return not 
                    can-find(first WebIssArea 
                             where webIssArea.CompanyCode = webissagrp.CompanyCode
                               and webIssArea.GroupID = webissagrp.GroupId no-lock).
            
        end.
        when "webIssCat" then
        do:
            find webIssCat where rowid(webIssCat) = pr-rowid no-lock no-error.
            if not avail webIssCat then return false.
            if webIssCat.IsDefault then return false.
            return not 
                    can-find(first issue of webissCat no-lock).
        end.
        when "webEQClass" then
        do:
            return true.
            /* PH - Allow delete regardless 
            find ivClass where rowid(ivClass) = pr-rowid no-lock no-error.
            if not avail ivClass then return false.
            return not
                can-find(first ivSub of ivClass no-lock).
            */
        end.
        when "webSubClass" then
        do:
            return true.
            /*
            find ivSub where rowid(ivSub) = pr-rowid no-lock no-error.
            if not avail ivSub then return false.
            if can-find(first ivField where ivField.ivSubID = 
                               ivSub.ivSubID no-lock) then return false.

            if can-find(first Custiv where Custiv.ivSubID = 
                               ivSub.ivSubID no-lock) then return false.
            return true.
            */    
        end.
        when "webInvField" then
        do:
            find ivfield where rowid(ivfield) = pr-rowid no-lock no-error.
            if not avail ivfield then return false.

            return not 
                can-find(first Custfield 
                         where CustField.ivFieldID = ivField.ivFieldID
                         no-lock).


        end.
        when "CUSTOMER" then
        do:
            find customer where rowid(customer) = pr-rowid no-lock no-error.
            if not avail customer then return false.
            if can-find(first issue
                where issue.CompanyCode     = customer.CompanyCode
                  and issue.AccountNumber   = customer.AccountNumber
                  no-lock) then return false.
            if can-find(first WebUser
                where WebUser.CompanyCode     = customer.CompanyCode
                  and WebUser.AccountNumber   = customer.AccountNumber
                  no-lock) then return false.
            return true.
        end.
        when "customerequip" then
        do:
            return true.
        end.
        when "WEBUSER" then
        do:
            find webuser where rowid(webuser) = pr-rowid no-lock no-error.
            if not avail webuser then return false.
            if can-find(first issue
                where issue.AssignTo = webuser.LoginID no-lock) 
            then return false.
            if can-find(first issue
                where issue.RaisedLoginID = webuser.LoginID no-lock) 
            then return false.
            if can-find(first issAction
                        where issAction.AssignTo = webuser.LoginID no-lock)
            then return false.

            if can-find(first issAction
                        where issAction.AssignBy = webuser.LoginID no-lock)
            then return false.
            if can-find(first issAction
                        where issAction.CreatedBy = webuser.LoginID no-lock)
            then return false.
            return true.
        end.

        


        when "webactivetype" then
        do:
            return true.
        end.
            
        when "webeqcontract" then
        do:
              return true.
        end.

        when "webattr" then
        do:
            return false.
        end.
        when "webmenu" then
        do:
            return false.
        end.
        when "webobject" then
        do:
            return false.
        end.
        when "webstatus" then
        do:
            find webStatus where rowid(webStatus) = pr-rowid no-lock no-error.
            if not avail webStatus then return false.
            if webStatus.DefaultCode then return false.

            if can-find(first IssStatus where issStatus.CompanyCode = 
                        webStatus.CompanyCode
                        and IssStatus.NewStatusCode = webStatus.StatusCode
                        no-lock)
            or can-find(first IssStatus where issStatus.CompanyCode = 
                        webStatus.CompanyCode
                        and IssStatus.OldStatusCode = webStatus.StatusCode
                        no-lock) then return false.

            return true.


        end.
        when "webnote" then
        do:
            find webNote where rowid(webNote) = pr-rowid no-lock no-error.
            if not avail webNote then return false.
            if webNote.NoteCode begins "sys." then return false.

            if can-find(first issNote
                        where issNote.CompanyCode = webNote.CompanyCode
                          and issNote.NoteCode    = webNote.NoteCode no-lock)
            then return false.


            return true.

        end.
        when "webIssArea" then
        do:
            find webIssArea where rowid(webIssArea) = pr-rowid no-lock no-error.
            if not avail webIssArea then return false.
            if can-find(first issue
                        where issue.CompanyCode = webIssArea.CompanyCode
                          and issue.AreaCode    = webIssArea.AreaCode no-lock)
            then return false.

            return true.

        end.
        when "webcomp" then
        do:
            return false.
        end.
        when "WEBACTION" then
        do:
            find webAction where rowid(webAction) = pr-rowid no-lock no-error.
            if not avail webAction then return false.
            if can-find(first issAction
                        where issAction.ActionID = webAction.ActionID
                          no-lock)
            then return false.

            return true.
        end.
        when "knbsection" then
        do:
            find knbSection where rowid(knbSection) = pr-rowid no-lock no-error.
            if not avail knbSection then return false.
            if can-find(first knbItem of knbSection no-lock)
            then return false.

            return true.
        end.
        when "knbitem" then
        do:
            return true.
        end.
        WHEN "gentab" THEN
        DO:
            RETURN TRUE.
        END.
        WHEN "Steam" THEN
        DO:
            FIND steam WHERE ROWID(steam) = pr-rowid NO-LOCK NO-ERROR.

            RETURN NOT
                CAN-FIND(FIRST customer 
                         WHERE customer.companyCode = steam.companyCode
                           AND customer.st-num = steam.st-num NO-LOCK).


        END.
        otherwise
            do:
                message "com-CanDelete invalid table for " pc-table.
                return false.
            end.
    end case.
 
    return true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CatName Include 
FUNCTION com-CatName RETURNS CHARACTER
  ( pc-CompanyCode as char,
    pc-Code AS CHAR
    ) :


    
    def buffer b-table for WebissCat.

    FIND b-table no-lock 
        where b-table.CompanyCode = pc-CompanyCode
          AND b-table.CatCode = pc-Code NO-ERROR.

       
    RETURN IF AVAIL  b-table THEN b-table.DESCRIPTION ELSE pc-code.




END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CheckSystemSetup Include 
FUNCTION com-CheckSystemSetup RETURNS LOGICAL
  ( pc-CompanyCode as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
                               /*
                               def var lc-System-Note-Code                 as char
    initial 'SYS.EMAILCUST,SYS.ASSIGN,SYS.SLA'  no-undo.
def var lc-System-Note-Desc                 as char
    initial 'System - Customer Emailed,System - Issue Assignment,Sys - SLA Assigned'
    no-undo.
*/
    def var li-loop as int      no-undo.
  
    def buffer WebNote      for WebNote.
    def buffer KnbSection   for knbSection.

    if pc-companyCode = "" then return true.

    do transaction:
        do li-loop = 1 to num-entries(lc-System-Note-Code):
            if can-find(WebNote where WebNote.CompanyCode = pc-companyCode 
                         and WebNote.NoteCode = entry(li-loop,lc-System-Note-Code) no-lock)
                        then next.
            create WebNote.
            assign 
                WebNote.CompanyCode = pc-companyCode
                WebNote.NoteCode    = entry(li-loop,lc-System-Note-Code)
                WebNote.description = entry(li-loop,lc-System-Note-Desc)
                WebNote.CustomerCanView = false.
            release WebNote.
        end.


    end.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CookieDate Include 
FUNCTION com-CookieDate RETURNS DATE
  ( pc-user as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer webuser for webuser.
    def buffer company for company.

    find webuser where webuser.LoginID = pc-user no-lock no-error.
    if not avail webuser then return ?.
    
    find company where company.CompanyCode = webuser.CompanyCode 
        no-lock no-error.
    if not avail company then return ?.
    
    return if company.timeout = 0 then ? else today.
        
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CookieTime Include 
FUNCTION com-CookieTime RETURNS INTEGER
( pc-user as char ) :
/*------------------------------------------------------------------------------
 Purpose:  
   Notes:  
------------------------------------------------------------------------------*/

    def buffer webuser for webuser.
    def buffer company for company.

    find webuser where webuser.LoginID = pc-user no-lock no-error.
    if not avail webuser then return ?.
    
    find company where company.CompanyCode = webuser.CompanyCode 
        no-lock no-error.
    if not avail company then return ?.
    /*
    message "time * 60 = " string(time,"hh:mm:SS") " to = " company.timeout 
                    " rev = " string(time + ( company.timeout * 60 ),"hh:mm:SS").
    */
    return if company.timeout = 0 then ? else time + ( company.timeout * 60 ).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CustomerAvailableSLA Include 
FUNCTION com-CustomerAvailableSLA RETURNS CHARACTER
  ( pc-CompanyCode as char,
    pc-AccountNumber as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var lc-return   as char     no-undo.
    def var li-loop     as int      no-undo.
    def var lc-char     as char     no-undo.

    def buffer slahead  for slahead.


    do li-loop = 1 to 2:
        assign
            lc-char = if li-loop = 1 then pc-AccountNumber else "".
        if li-loop = 1 and lc-char = "" then next.

        for each slahead no-lock
            where slahead.companycode = pc-CompanyCode
              and slahead.AccountNumber = lc-char
              by slahead.SLACode:

            if lc-return = ""
            then lc-return = string(rowid(slahead)).
            else lc-return = lc-return + "|" + string(rowid(slahead)).
        end.

    end.
    

    return lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CustomerName Include 
FUNCTION com-CustomerName RETURNS CHARACTER
  ( pc-Company as char,
    pc-Account  as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

   
    def buffer b-Customer   for Customer.

    
    find b-Customer
        where b-Customer.CompanyCode = pc-Company
          and b-Customer.AccountNumber = pc-Account
          no-lock no-error.

    return if avail b-Customer then b-Customer.name else "".


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CustomerOpenIssues Include 
FUNCTION com-CustomerOpenIssues RETURNS INTEGER
 ( pc-CompanyCode as char,
   pc-accountNumber as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-return as int      no-undo.

    def buffer Issue        for Issue.
    def buffer WebStatus    for WebStatus.


    for each Issue no-lock
        where Issue.CompanyCode = pc-companyCode
          and Issue.AccountNumber = pc-AccountNumber
          ,
          first WebStatus no-lock
                where WebStatus.companyCode = Issue.CompanyCode
                  and WebStatus.StatusCode  = Issue.StatusCode
                  and WebStatus.Completed   = false
          :

        assign li-return = li-return + 1.

    end.

    return li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-DecodeLookup Include 
FUNCTION com-DecodeLookup RETURNS CHARACTER
  ( pc-code as char,
    pc-code-list as char,
    pc-code-display as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-index        as int          no-undo.

    assign
        li-index = lookup(pc-code,pc-code-list,"|").

    return
        if li-index = 0 then pc-code
        else entry(li-index,pc-code-display,"|").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-DescribeTicket Include 
FUNCTION com-DescribeTicket RETURNS CHARACTER
  ( pc-TxnType as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    case pc-txntype:
        when "TCK" then return "Ticket".
        when "ADJ" then return "Adjustment".
        when "ACT" then return "Activity".
    end case.
      
    return pc-txntype.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-GenTabDesc Include 
FUNCTION com-GenTabDesc RETURNS CHARACTER
  ( pc-CompanyCode as char,
    pc-GType AS CHAR,
    pc-Code AS CHAR
    ) :


    
    def buffer b-GenTab for GenTab.

    FIND b-GenTab no-lock 
        where b-GenTab.CompanyCode = pc-CompanyCode
          AND b-GenTab.gType = pc-gType
          AND b-gentab.gCode = pc-Code NO-ERROR.

       
    RETURN IF AVAIL  b-gentab THEN b-GenTab.Descr ELSE "Missing".




END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-GetDefaultCategory Include 
FUNCTION com-GetDefaultCategory RETURNS CHARACTER
  ( pc-CompanyCode as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer b-table for WebIssCat.


    find first b-table
        where b-table.CompanyCode = pc-CompanyCode
          and b-table.isDefault   = true
          no-lock no-error.

    return
        if avail b-table then b-table.CatCode else "".


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-Initialise Include 
FUNCTION com-Initialise RETURNS logical
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-loop     as int      no-undo.


    do li-loop = 0 to 23:

        if li-loop = 0 then
        do:
            assign 
                lc-global-hour-display = "00"
                lc-global-hour-code    = "00".
            next.
        end.
        assign 
            lc-global-hour-code = lc-global-hour-code + "|" + 
                                  string(li-loop)
            lc-global-hour-display = lc-global-hour-display + "|" + 
                                         string(li-loop).

       
                
    end.

    do li-loop = 0 to 55 by 5:
        if li-loop = 0
        then assign lc-global-min-code = string(li-loop)
                    lc-global-min-display = string(li-loop,"99").
        else assign lc-global-min-code = lc-global-min-code + "|" + string(li-loop)
                    lc-global-min-display = lc-global-min-display + "|" + string(li-loop,"99").
    end.
    
    do li-loop = 0 to 59 by 1:
        if li-loop = 0
        then assign lc-global-min-code = string(li-loop)
                    lc-global-min-display = string(li-loop,"99").
        else assign lc-global-min-code = lc-global-min-code + "|" + string(li-loop)
                    lc-global-min-display = lc-global-min-display + "|" + string(li-loop,"99").
    end.


    RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-InitialSetup Include 
FUNCTION com-InitialSetup RETURNS LOGICAL
  ( pc-LoginID as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer webuser for webuser.

    assign lc-global-user = pc-LoginID.


    find webuser where webuser.LoginID = pc-LoginID no-lock no-error.

    if avail webuser then 
    do:
        assign lc-global-company = webuser.CompanyCode.
        DYNAMIC-FUNCTION('com-CheckSystemSetup':U,lc-global-company).
    end.


    return true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-InternalTime Include 
FUNCTION com-InternalTime RETURNS INTEGER
  ( pi-hours as int,
    pi-mins  as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


    return ( ( pi-hours * 60 ) * 60 ) + ( pi-mins * 60 ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-IsContractor Include 
FUNCTION com-IsContractor RETURNS LOGICAL
  ( pc-companyCode  as char,
    pc-LoginID      as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Webuser for WebUser.

    find WebUser
        where WebUser.LoginID = pc-LoginID
          no-lock no-error.
    
    if not avail WebUser then return false.
    
    return WebUser.UserClass = "contract".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-IsCustomer Include 
FUNCTION com-IsCustomer RETURNS LOGICAL
  ( pc-companyCode  as char,
    pc-LoginID      as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Webuser for WebUser.

    find WebUser
        where WebUser.LoginID = pc-LoginID
          no-lock no-error.
    
    if not avail WebUser then return false.
    
    return WebUser.UserClass = "customer".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-IssueStatusAlert Include 
FUNCTION com-IssueStatusAlert RETURNS LOGICAL
  ( pc-CompanyCode as char,
    pc-CreateSource as char,
    pc-StatusCode   as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer WebStatus    for WebStatus.

    if pc-CreateSource <> "EMAIL" then return true.

    find WebStatus
        where WebStatus.CompanyCode = pc-CompanyCode
          and WebStatus.StatusCode  = pc-StatusCode no-lock no-error.
    if not avail WebStatus then return true.

    return not WebStatus.IgnoreEmail.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-IsSuperUser Include 
FUNCTION com-IsSuperUser RETURNS LOGICAL
  ( pc-LoginID      as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Webuser for WebUser.

    find WebUser
        where WebUser.LoginID = pc-LoginID
          no-lock no-error.
    
    if not avail WebUser then return false.
    
    return WebUser.UserClass = "INTERNAL" and WebUser.SuperUser.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-MonthBegin Include 
FUNCTION com-MonthBegin RETURNS DATE
  ( pd-date as date) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN pd-date - ( day(pd-date) ) + 1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-MonthEnd Include 
FUNCTION com-MonthEnd RETURNS DATE
  ( pd-date as date ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ((DATE(MONTH(pd-date),28,YEAR(pd-date)) + 4) - 
          DAY(DATE(MONTH(pd-date),28,YEAR(pd-date)) + 4)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NearestTimeUnit Include 
FUNCTION com-NearestTimeUnit RETURNS INTEGER
  ( pi-time as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  
    def var lc-time     as char     no-undo.
    def var li-mins     as int      no-undo.
    def var li-rem      as int      no-undo.


    assign
        lc-time = string(pi-time,"hh:mm").


    assign
        li-mins = int(substr(lc-time,4,2)).


    if li-mins = 0 then return 0.

    assign
        li-rem = li-mins mod 5.

    return ( li-mins - ( li-mins mod 5 ) ). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfActions Include 
FUNCTION com-NumberOfActions RETURNS INTEGER
  ( pc-LoginID as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-return as int      no-undo.

    def buffer IssAction    for IssAction.


    for each IssAction no-lock
        where IssAction.AssignTo = pc-LoginID
          and IssAction.ActionStatus = "OPEN":

        assign li-return = li-return + 1.

    end.

    return li-return.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfAlerts Include 
FUNCTION com-NumberOfAlerts RETURNS INTEGER
 ( pc-LoginID as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-return as int      no-undo.

    def buffer IssAlert    for IssAlert.


    for each IssAlert no-lock
        where IssAlert.LoginID = pc-LoginID
          :

        assign li-return = li-return + 1.

    end.

    return li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfEmails Include 
FUNCTION com-NumberOfEmails RETURNS INTEGER
  ( pc-LoginID as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-return       as int      no-undo.
    def buffer webuser      for webuser.
    def buffer e            for EmailH.

    find webuser where webuser.LoginID = pc-loginID no-lock no-error.

    if avail webuser
    and webuser.userclass = "INTERNAL" and webuser.SuperUser then
    do:
        for each e where e.companyCode = webuser.CompanyCode no-lock:
            assign
                li-return = li-return + 1.
        end.
    end.
    
    return li-return.
    


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfInventoryWarnings Include 
FUNCTION com-NumberOfInventoryWarnings RETURNS INTEGER
    ( pc-LoginID as char ) :
/*------------------------------------------------------------------------------
 Purpose:  
   Notes:  
------------------------------------------------------------------------------*/

    def var li-return       as int      no-undo.
    def var ld-WarnFrom     as date     no-undo.
    def var ld-DueDate      as date     no-undo.
    
    def buffer webUser      for WebUser.
    def buffer ivField      for ivField.
    def buffer ivSub        for ivSub.
    def buffer custField    for custField.

    find webuser where webuser.LoginID = pc-loginID no-lock no-error.

    if DYNAMIC-FUNCTION('com-IsSuperUser':U,pc-loginid) then
    for each ivField no-lock
        where ivField.dType = "date"
          and ivField.dWarning > 0,
          first ivSub of ivField no-lock:

        if ivSub.CompanyCode <> webuser.CompanyCode then next.

        assign
            ld-WarnFrom = today - ivField.dWarning.

        for each CustField no-lock
            where CustField.ivFieldID = ivField.ivFieldID:

            
            if custField.FieldData = "" 
            or custField.FieldData = ? then next.

            assign
                ld-DueDate = date(custfield.FieldData) no-error.
            if error-status:error 
            or ld-DueDate = ? then next.

            /* 
            *** Waring base on
            *** Today in within range of Inventory Date - Warning Period AND
            *** Inventory Date is today or in the future
            *** If the inventory date has passed then no more warnings
            ***
            */
            if today >= ld-DueDate - ivField.dWarning
            and ld-DueDate >= today  
            then assign li-return = li-return + 1.
        end.
            


    end.

    return li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfOpenActions Include 
FUNCTION com-NumberOfOpenActions RETURNS INTEGER
  ( pc-LoginID as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-return as int      no-undo.

    def buffer IssAction    for IssAction.
    def buffer WebUser      for WebUser.


    find webuser where webuser.LoginID = pc-loginid no-lock no-error.

    if not avail webuser then return 0.


    if webUser.SuperUser then
    for each IssAction no-lock
        where IssAction.CompanyCode = webuser.CompanyCode
          and IssAction.ActionStatus = "OPEN":

        assign li-return = li-return + 1.

    end.

    return li-return.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberUnAssigned Include 
FUNCTION com-NumberUnAssigned RETURNS INTEGER
 ( pc-CompanyCode as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var li-return as int      no-undo.

    def buffer Issue        for Issue.
    def buffer WebStatus    for WebStatus.


    for each Issue no-lock
        where Issue.CompanyCode = pc-companyCode
          and Issue.AssignTo = ""
          use-index AssignTo ,
          first WebStatus no-lock
                where WebStatus.companyCode = Issue.CompanyCode
                  and WebStatus.StatusCode  = Issue.StatusCode
                  and WebStatus.Completed   = false
          :

        assign li-return = li-return + 1.

    end.

    return li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-QuickView Include 
FUNCTION com-QuickView RETURNS logical
  ( pc-LoginID  as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer b-WebUser    for webUser.
    def buffer b-Customer   for Customer.

    find b-WebUser
        where b-WebUser.LoginID = pc-LoginID no-lock no-error.

    if not avail b-webuser
    or b-webuser.UserClass = "{&CUSTOMER}" then return false.

    if b-webuser.UserClass = "{&CONTRACT}" then return true.
    
    if b-webuser.SuperUser then return true.

    return b-webuser.QuickView.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-RequirePasswordChange Include 
FUNCTION com-RequirePasswordChange RETURNS LOGICAL
  ( pc-user as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer webUser for WebUser.
    def buffer company for company.
  

    find webUser
        where webUser.loginid = pc-user exclusive-lock no-wait no-error.

    if locked webuser
    or not avail webuser then return false.

    
    find company 
        where company.CompanyCode = webuser.CompanyCode no-lock no-error.
    if not avail company then return false.

    if company.PasswordExpire = 0 then return false.

    
    if webuser.LastPasswordChange = ?
        then assign webUser.LastPasswordChange = today.


    return ( webuser.LastPasswordChange + company.PasswordExpire ) <=
           today.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-SLADescription Include 
FUNCTION com-SLADescription RETURNS CHARACTER
    ( pf-SLAID as dec ) :
/*------------------------------------------------------------------------------
 Purpose:  
   Notes:  
------------------------------------------------------------------------------*/

   def buffer slahead  for slahead.

   find slahead
       where slahead.SLAID = pf-SLAID
       no-lock no-error.


   return if avail slahead
          then slahead.description else "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-StatusTrackIssue Include 
FUNCTION com-StatusTrackIssue RETURNS LOGICAL
  ( pc-companycode as char,
    pc-StatusCode  as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer  webStatus   for webStatus.

    find webStatus
        where webStatus.companycode = pc-companycode
          and webStatus.StatusCode  = pc-statuscode
          no-lock no-error.

    return if avail webstatus then webstatus.CustomerTrack else false.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-StringReturn Include 
FUNCTION com-StringReturn RETURNS CHARACTER
  ( pc-orig as char,
    pc-add as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if pc-add = ""
    or pc-add = ? then return pc-orig.

    if pc-orig = "" then return pc-add.

    return pc-orig + "~n" + pc-add.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-SystemLog Include 
FUNCTION com-SystemLog RETURNS LOGICAL
  ( pc-ActType as char,
    pc-LoginID as char,
    pc-AttrData as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer SysAct for SysAct.

    do transaction:
        create SysAct.
        assign
            SysAct.ActDate = today
            SysAct.ActTime = time
            SysAct.LoginID = pc-LoginID
            SysAct.ActType = pc-ActType
            SysAct.AttrData = pc-AttrData.

        release SysAct.
    end.


    return true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-TicketOnly Include 
FUNCTION com-TicketOnly RETURNS LOGICAL
  ( pc-companyCode  as char,
    pc-AccountNumber      as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Customer for Customer.

    find Customer
        where Customer.CompanyCode      = pc-companyCode
          and Customer.AccountNumber    = pc-AccountNumber
          no-lock no-error.
    
    if not avail Customer then return false.
    
    return Customer.SupportTicket = "YES".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-TimeReturn Include 
FUNCTION com-TimeReturn RETURNS CHARACTER
  ( pc-Type as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    case pc-Type:
        when "HOUR" 
        then      return lc-global-hour-code + "^" + lc-global-hour-display.
        otherwise return lc-global-min-code + "^" + lc-global-min-display.
    end case.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-TimeToString Include 
FUNCTION com-TimeToString RETURNS CHARACTER
  ( pi-time as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    def var li-sec-hours        as int      initial 3600 no-undo.
    def var li-seconds          as int      no-undo.
    def var li-mins             as int      no-undo.
    def var li-hours            as int      no-undo.
    def var ll-neg              as log      no-undo.

    if pi-time < 0 then assign ll-neg = true
                               pi-time = pi-time * -1.

    assign 
        li-seconds = pi-time mod li-sec-hours
        li-mins = truncate(li-seconds / 60,0).
        
    assign
        pi-time = pi-time - li-seconds.
        
    assign
        li-hours = truncate(pi-time / li-sec-hours,0).

    return trim( ( if ll-neg then "-" else "" ) + string(li-hours) + ":" + string(li-mins,'99')).
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-UserName Include 
FUNCTION com-UserName RETURNS CHARACTER
  ( pc-LoginID as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer webuser  for webuser.

    case pc-loginID:
        when "SLA.ALERT" then return "SLA Processing".
    end case.

    find webuser
        where webuser.LoginID = pc-LoginID
        no-lock no-error.


    return if avail webuser
           then trim(webuser.forename + " " + webuser.surname)
           else pc-LoginID.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-UsersCompany Include 
FUNCTION com-UsersCompany RETURNS CHARACTER
  ( pc-LoginID  as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer b-WebUser    for webUser.
    def buffer b-Customer   for Customer.

    find b-WebUser
        where b-WebUser.LoginID = pc-LoginID no-lock no-error.

    if not avail b-webuser
    or b-webuser.UserClass <> "{&CUSTOMER}" then return "".

    find b-Customer
        where b-Customer.CompanyCode = b-WebUser.CompanyCode
          and b-Customer.AccountNumber = b-WebUser.AccountNumber
          no-lock no-error.

    return if avail b-Customer then b-Customer.name else "".


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-UserTrackIssue Include 
FUNCTION com-UserTrackIssue RETURNS logical
    ( pc-LoginID as char
     ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer  webUser   for webUser.

    find webUser
        where webUser.LoginID = pc-LoginID
          no-lock no-error.

    return if avail webUser and webUser.email <> "" 
           then webUser.CustomerTrack else false.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-WriteQueryInfo Include 
FUNCTION com-WriteQueryInfo RETURNS LOGICAL
  ( hQuery AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ix     AS INTEGER NO-UNDO.
  DEFINE VARIABLE jx     AS INTEGER NO-UNDO.

  REPEAT ix = 1 TO hQuery:NUM-BUFFERS:  
      jx = LOOKUP("WHOLE-INDEX", hQuery:INDEX-INFORMATION(ix)).  
      IF jx > 0 
      THEN    MESSAGE "inefficient index" ENTRY(jx + 1, hQuery:INDEX-INFORMATION(ix)).  
      ELSE     MESSAGE "bracketed index use of" hQuery:INDEX-INFORMATION(ix).
   END.


  RETURN TRUE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

