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

DEFINE VARIABLE lc-global-selcode                   AS CHARACTER 
    INITIAL "WALESFOREVER"                  NO-UNDO.
DEFINE VARIABLE lc-global-seldesc                   AS CHARACTER
    INITIAL "None"                     NO-UNDO.

DEFINE VARIABLE lc-global-company                   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-global-user                      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-global-internal                  AS CHARACTER 
    INITIAL "INTERNAL,CONTRACT"             NO-UNDO.

DEFINE VARIABLE lc-global-dtype                     AS CHARACTER
    INITIAL "Text|Number|Date|Note|Yes/No"           NO-UNDO.

DEFINE VARIABLE lc-global-respaction-code           AS CHARACTER
    INITIAL "None|Email|EmailPage|Page|Web" NO-UNDO.
DEFINE VARIABLE lc-global-respaction-display        AS CHARACTER
    INITIAL "None|Send Email|Send Email & SMS|Send SMS|Web Alert" NO-UNDO.

DEFINE VARIABLE lc-global-tbase-code                AS CHARACTER
    INITIAL "OFF|REAL"                      NO-UNDO.
DEFINE VARIABLE lc-global-tbase-display             AS CHARACTER
    INITIAL "Office Hours|24 Hours"         NO-UNDO.

DEFINE VARIABLE lc-global-abase-code                AS CHARACTER
    INITIAL "ISSUE|ALERT"                   NO-UNDO.
DEFINE VARIABLE lc-global-abase-display             AS CHARACTER
    INITIAL "Issue Date/Time|Previous Alert Date/Time"         
                                            NO-UNDO.

DEFINE VARIABLE lc-global-respunit-code             AS CHARACTER
    INITIAL "None|Minute|Hour|Day|Week"     NO-UNDO.
DEFINE VARIABLE lc-global-respunit-display          AS CHARACTER
    INITIAL "None|Minute|Hour|Day|Week"     NO-UNDO.

DEFINE VARIABLE lc-global-action-code                AS CHARACTER
    INITIAL "OPEN|CLOSED"                    NO-UNDO.
DEFINE VARIABLE lc-global-action-display             AS CHARACTER
    INITIAL "Open|Closed"                    NO-UNDO.

DEFINE VARIABLE lc-global-hour-code                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-global-hour-display              AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-global-min-code                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-global-min-display              AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-System-KB-Code                   AS CHARACTER
    INITIAL "SYS.ISSUE"                     NO-UNDO.
DEFINE VARIABLE lc-System-KB-Desc                   AS CHARACTER
    INITIAL "Completed Issues"              NO-UNDO.

DEFINE VARIABLE lc-System-Note-Code                 AS CHARACTER
    INITIAL 'SYS.ACCOUNT,SYS.EMAILCUST,SYS.ASSIGN,SYS.SLA,SYS.MISC,SYS.SLAWARN,SYS.SLAMISSED'  NO-UNDO.
DEFINE VARIABLE lc-System-Note-Desc                 AS CHARACTER
    INITIAL 'System - Account Changed,System - Customer Emailed,System - Issue Assignment,System - SLA Assigned,System - Misc Note,System - SLA Warning,System - SLA Missed'
    NO-UNDO.

DEFINE VARIABLE lc-global-GT-Code       AS CHARACTER INITIAL
    'Asset.Type,Asset.Manu,Asset.Status'        NO-UNDO.


DEFINE VARIABLE lc-global-iclass-code   AS CHARACTER INITIAL
    'Issue|Admin|Project'                       NO-UNDO.



DEFINE VARIABLE lc-global-SupportTicket-Code               AS CHARACTER
    INITIAL 'NONE|YES|BOTH'                 NO-UNDO.
DEFINE VARIABLE lc-global-SupportTicket-Desc               AS CHARACTER
    INITIAL 'Standard Support Only|Ticket Support Only|Standard And Ticket Support'
                                     
    NO-UNDO.
DEFINE VARIABLE lc-global-Allow-TicketSupport       AS CHARACTER
    INITIAL 'YES|BOTH'                 NO-UNDO.
DEFINE VARIABLE lc-global-sms-username              AS CHARACTER
    INITIAL 'tomcarroll'                        NO-UNDO.
DEFINE VARIABLE lc-global-sms-password              AS CHARACTER
    INITIAL 'cr34tion'                      NO-UNDO.

DEFINE VARIABLE lc-global-excludeType               AS CHARACTER
    INITIAL "exe,vbs"                       NO-UNDO.

DEFINE VARIABLE li-global-sla-fail      AS INTEGER INITIAL  10  NO-UNDO.
DEFINE VARIABLE li-global-sla-amber     AS INTEGER INITIAL  20  NO-UNDO.
DEFINE VARIABLE li-global-sla-ok        AS INTEGER INITIAL  30  NO-UNDO.
DEFINE VARIABLE li-global-sla-na        AS INTEGER INITIAL  99  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AllowCustomerAccess Include 
FUNCTION com-AllowCustomerAccess RETURNS LOGICAL
  ( pc-CompanyCode AS CHARACTER,
    pc-LoginID AS CHARACTER,
    pc-AccountNumber AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AllowTicketSupport Include 
FUNCTION com-AllowTicketSupport RETURNS LOGICAL
  ( pr-rowid AS ROWID )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AreaName Include 
FUNCTION com-AreaName RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER ,
    pc-AreaCode    AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AskTicket Include 
FUNCTION com-AskTicket RETURNS LOGICAL
  ( pc-companyCode  AS CHARACTER,
    pc-AccountNumber      AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-AssignedToUser Include 
FUNCTION com-AssignedToUser RETURNS INTEGER
 ( pc-CompanyCode AS CHARACTER,
   pc-LoginID     AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CanDelete Include 
FUNCTION com-CanDelete RETURNS LOGICAL
  ( pc-loginid  AS CHARACTER,
    pc-table    AS CHARACTER,
    pr-rowid    AS ROWID )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CatName Include 
FUNCTION com-CatName RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER,
    pc-Code AS CHARACTER
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CheckSystemSetup Include 
FUNCTION com-CheckSystemSetup RETURNS LOGICAL
  ( pc-CompanyCode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CookieDate Include 
FUNCTION com-CookieDate RETURNS DATE
  ( pc-user AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CookieTime Include 
FUNCTION com-CookieTime RETURNS INTEGER
( pc-user AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CustomerAvailableSLA Include 
FUNCTION com-CustomerAvailableSLA RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER,
    pc-AccountNumber AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CustomerName Include 
FUNCTION com-CustomerName RETURNS CHARACTER
  ( pc-Company AS CHARACTER,
    pc-Account  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-CustomerOpenIssues Include 
FUNCTION com-CustomerOpenIssues RETURNS INTEGER
 ( pc-CompanyCode AS CHARACTER,
   pc-accountNumber AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-DecodeLookup Include 
FUNCTION com-DecodeLookup RETURNS CHARACTER
  ( pc-code AS CHARACTER,
    pc-code-list AS CHARACTER,
    pc-code-display AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-DescribeTicket Include 
FUNCTION com-DescribeTicket RETURNS CHARACTER
  ( pc-TxnType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-GenTabDesc Include 
FUNCTION com-GenTabDesc RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER,
    pc-GType AS CHARACTER,
    pc-Code AS CHARACTER
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-GetDefaultCategory Include 
FUNCTION com-GetDefaultCategory RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-Initialise Include 
FUNCTION com-Initialise RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-InitialSetup Include 
FUNCTION com-InitialSetup RETURNS LOGICAL
  ( pc-LoginID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-InternalTime Include 
FUNCTION com-InternalTime RETURNS INTEGER
  ( pi-hours AS INTEGER,
    pi-mins  AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-IsContractor Include 
FUNCTION com-IsContractor RETURNS LOGICAL
  ( pc-companyCode  AS CHARACTER,
    pc-LoginID      AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-IsCustomer Include 
FUNCTION com-IsCustomer RETURNS LOGICAL
  ( pc-companyCode  AS CHARACTER,
    pc-LoginID      AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-IssueActionsStatus Include 
FUNCTION com-IssueActionsStatus RETURNS INTEGER
  ( pc-companyCode AS CHARACTER,
    pi-issue   AS INTEGER,
    pc-status  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-IssueStatusAlert Include 
FUNCTION com-IssueStatusAlert RETURNS LOGICAL
  ( pc-CompanyCode AS CHARACTER,
    pc-CreateSource AS CHARACTER,
    pc-StatusCode   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-IsSuperUser Include 
FUNCTION com-IsSuperUser RETURNS LOGICAL
  ( pc-LoginID      AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-MonthBegin Include 
FUNCTION com-MonthBegin RETURNS DATE
  ( pd-date AS DATE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-MonthEnd Include 
FUNCTION com-MonthEnd RETURNS DATE
  ( pd-date AS DATE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NearestTimeUnit Include 
FUNCTION com-NearestTimeUnit RETURNS INTEGER
  ( pi-time AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfActions Include 
FUNCTION com-NumberOfActions RETURNS INTEGER
  ( pc-LoginID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfAlerts Include 
FUNCTION com-NumberOfAlerts RETURNS INTEGER
 ( pc-LoginID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfEmails Include 
FUNCTION com-NumberOfEmails RETURNS INTEGER
  ( pc-LoginID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfInventoryWarnings Include 
FUNCTION com-NumberOfInventoryWarnings RETURNS INTEGER
    ( pc-LoginID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberOfOpenActions Include 
FUNCTION com-NumberOfOpenActions RETURNS INTEGER
  ( pc-LoginID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-NumberUnAssigned Include 
FUNCTION com-NumberUnAssigned RETURNS INTEGER
 ( pc-CompanyCode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-QuickView Include 
FUNCTION com-QuickView RETURNS LOGICAL
  ( pc-LoginID  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-RequirePasswordChange Include 
FUNCTION com-RequirePasswordChange RETURNS LOGICAL
  ( pc-user AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-SLADescription Include 
FUNCTION com-SLADescription RETURNS CHARACTER
    ( pf-SLAID AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-StatusTrackIssue Include 
FUNCTION com-StatusTrackIssue RETURNS LOGICAL
  ( pc-companycode AS CHARACTER,
    pc-StatusCode  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-StringReturn Include 
FUNCTION com-StringReturn RETURNS CHARACTER
  ( pc-orig AS CHARACTER,
    pc-add AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-SystemLog Include 
FUNCTION com-SystemLog RETURNS LOGICAL
  ( pc-ActType AS CHARACTER,
    pc-LoginID AS CHARACTER,
    pc-AttrData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-TicketOnly Include 
FUNCTION com-TicketOnly RETURNS LOGICAL
  ( pc-companyCode  AS CHARACTER,
    pc-AccountNumber      AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-TimeReturn Include 
FUNCTION com-TimeReturn RETURNS CHARACTER
  ( pc-Type AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-TimeToString Include 
FUNCTION com-TimeToString RETURNS CHARACTER
  ( pi-time AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-UserName Include 
FUNCTION com-UserName RETURNS CHARACTER
  ( pc-LoginID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-UsersCompany Include 
FUNCTION com-UsersCompany RETURNS CHARACTER
  ( pc-LoginID  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD com-UserTrackIssue Include 
FUNCTION com-UserTrackIssue RETURNS LOGICAL
    ( pc-LoginID AS CHARACTER
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

    DEFINE INPUT  PARAMETER pc-CompanyCode AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-GType       AS CHARACTER NO-UNDO.

    DEFINE OUTPUT PARAMETER pc-code     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE icount AS INTEGER       NO-UNDO.


    DEFINE BUFFER b-GenTab FOR GenTab.

    FOR EACH b-GenTab NO-LOCK 
        WHERE b-GenTab.CompanyCode = pc-CompanyCode
          AND b-GenTab.gType = pc-gType
       :

        IF icount = 0 
        THEN ASSIGN pc-code = b-GenTab.gCode
                    pc-Desc    = b-GenTab.Descr.

        ELSE ASSIGN pc-code = pc-code + '|' + 
               b-GenTab.gCode
               pc-Desc = pc-Desc + '|' + 
               b-GenTab.Descr.

        icount = icount + 1.

    END.


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
    DEFINE INPUT PARAMETER  pc-CompanyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-buffer FOR WebAction.

    FOR EACH b-buffer NO-LOCK 
        WHERE b-buffer.CompanyCode = pc-CompanyCode
        BY b-buffer.Description:

        IF pc-codes = ""
        THEN ASSIGN pc-Codes = b-buffer.ActionCode
                    pc-Desc = b-buffer.Description.
        ELSE ASSIGN pc-Codes = pc-Codes + '|' + 
               b-buffer.ActionCode
               pc-Desc = pc-Desc + '|' + 
               b-buffer.Description.
    END.
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
    
    DEFINE INPUT  PARAMETER pc-companyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Active          AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc            AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Time            AS CHARACTER NO-UNDO.

/* def var acttype as char initial "Take Call|Travel for Job|Analyse Fault|Repair Fault|Order Goods".  */
/* def var actcodes as char initial "1|2|3|4|5".                                                       */

    DEFINE BUFFER b-WebActType FOR WebActType .

    ASSIGN pc-Codes  = ""
           pc-Active = ""
           pc-Desc   = ""
           pc-Time   = "".


    FOR EACH b-WebActType NO-LOCK 
        WHERE b-WebActType.CompanyCode = pc-CompanyCode
        BREAK BY b-WebActType.TypeID 
              :

        ASSIGN pc-Codes  = pc-Codes  + '|' + string(b-WebActType.TypeID)
               pc-Active = pc-Active + '|' + b-WebActType.ActivityType 
               pc-Desc   = pc-Desc   + '|' + b-WebActType.Description  
               pc-Time   = pc-Time   + '|' + string(b-WebActType.MinTime)
          .
    END.

    ASSIGN
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
    DEFINE INPUT PARAMETER  pc-CompanyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-IssArea FOR WebIssArea.

    ASSIGN pc-Codes = DYNAMIC-FUNCTION("htmlib-Null") + "|NotAssigned"
           pc-Desc = "All Areas|Not Assigned".


    FOR EACH b-IssArea NO-LOCK 
        WHERE b-IssArea.CompanyCode = pc-CompanyCode
        /* by b-IssArea.Description: */
        :
        ASSIGN pc-Codes = pc-Codes + '|' + 
               b-IssArea.AreaCode
               pc-Desc = pc-Desc + '|' + 
               b-IssArea.Description.
    END.
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
    DEFINE INPUT PARAMETER  pc-CompanyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-IssArea FOR WebIssArea.

    ASSIGN pc-Codes = ""
           pc-Desc = "Not Applicable/Known".


    FOR EACH b-IssArea NO-LOCK 
        WHERE b-IssArea.CompanyCode = pc-CompanyCode
        BY b-IssArea.Description:
        ASSIGN pc-Codes = pc-Codes + '|' + 
               b-IssArea.AreaCode
               pc-Desc = pc-Desc + '|' + 
               b-IssArea.Description.
    END.

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
    DEFINE INPUT  PARAMETER pc-CompanyCode AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-LoginID     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name        AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-user FOR WebUser.

    ASSIGN pc-LoginID = DYNAMIC-FUNCTION("htmlib-Null") + "|NotAssigned"
           pc-name = "All People|Not Assigned".


    FOR EACH b-user NO-LOCK 
        WHERE CAN-DO(lc-global-internal,b-user.UserClass)
        AND b-user.CompanyCode = pc-CompanyCode
        BY b-user.name:
        ASSIGN pc-LoginID = pc-LoginID + '|' + 
               b-user.LoginID
               pc-name = pc-name + '|' + 
               b-user.Name.
    END.
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
    DEFINE INPUT  PARAMETER pc-CompanyCode AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-LoginID     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name        AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-user FOR WebUser.

    ASSIGN pc-LoginID = ""
           pc-name = "Not Assigned".


    FOR EACH b-user NO-LOCK 
        WHERE CAN-DO(lc-global-internal,b-user.UserClass)
        AND b-user.CompanyCode = pc-CompanyCode
        BY b-user.name:
        ASSIGN pc-LoginID = pc-LoginID + '|' + 
               b-user.LoginID
               pc-name = pc-name + '|' + 
               b-user.Name.
    END.
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
    DEFINE INPUT  PARAMETER pc-CompanyCode AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-LoginID     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name        AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-user FOR WebUser.

    FOR EACH b-user NO-LOCK 
        WHERE CAN-DO(lc-global-internal,b-user.UserClass)
        AND b-user.CompanyCode = pc-CompanyCode
        BY b-user.name:

        IF pc-loginID = ""
        THEN ASSIGN pc-loginID = b-user.LoginID
                    pc-name    = b-user.Name.

        ELSE ASSIGN pc-LoginID = pc-LoginID + '|' + 
               b-user.LoginID
               pc-name = pc-name + '|' + 
               b-user.Name.
    END.
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
    DEFINE INPUT PARAMETER  pc-CompanyCode     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  pc-Exclude         AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc            AS CHARACTER NO-UNDO.

    DEFINE BUFFER b-buffer FOR WebAction.

    ASSIGN
        pc-codes = ""
        pc-desc  = "No Auto Action".

    FOR EACH b-buffer NO-LOCK 
        WHERE b-buffer.CompanyCode = pc-CompanyCode
        BY b-buffer.Description:

        IF b-buffer.ActionCode = pc-Exclude THEN NEXT.

        ASSIGN pc-Codes = pc-Codes + '|' + 
               b-buffer.ActionCode
               pc-Desc = pc-Desc + '|' + 
               b-buffer.Description.
    END.
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
    DEFINE INPUT  PARAMETER pc-company             AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-CatCode             AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Description         AS CHARACTER NO-UNDO.

    
    DEFINE BUFFER b-Cat FOR WebIssCat.

   
    ASSIGN pc-CatCode = ""
           pc-Description = "".

    FOR EACH b-Cat NO-LOCK
        WHERE b-Cat.CompanyCode = pc-company
           BY b-Cat.description
            :

        IF pc-CatCode = ""
        THEN ASSIGN  pc-CatCode     = b-Cat.CatCode
                     pc-Description = b-Cat.Description.
        ELSE ASSIGN pc-CatCode      = pc-CatCode + '|' + b-Cat.CatCode
                    pc-Description  = pc-Description + '|' + b-Cat.Description.

    END.

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
    DEFINE INPUT PARAMETER  pc-CompanyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-IssArea FOR WebIssCat.

    ASSIGN pc-Codes = DYNAMIC-FUNCTION("htmlib-Null")
           pc-Desc = "All Categories".


    FOR EACH b-IssArea NO-LOCK 
        WHERE b-IssArea.CompanyCode = pc-CompanyCode
        /* by b-IssArea.Description: */
        :
        ASSIGN pc-Codes = pc-Codes + '|' + 
               b-IssArea.CatCode
               pc-Desc = pc-Desc + '|' + 
               b-IssArea.Description.
    END.
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
    DEFINE INPUT PARAMETER pc-CompanyCode      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-LoginID          AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-AccountNumber   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-cust FOR customer.
    DEFINE BUFFER b-user FOR WebUser.

    ASSIGN pc-AccountNumber = DYNAMIC-FUNCTION("htmlib-Null")
           pc-name = "All Customers".

    FIND b-user WHERE b-user.LoginID = pc-LoginID NO-LOCK NO-ERROR.
    
    FOR EACH b-cust NO-LOCK 
        WHERE b-cust.CompanyCode = pc-CompanyCode
            BY b-cust.name:
        IF AVAILABLE b-user THEN
        DO:
            IF NOT DYNAMIC-FUNCTION('com-AllowCustomerAccess':U,
                                    pc-companyCode,
                                    pc-LoginID,
                                    b-cust.AccountNumber) THEN NEXT.
        END.
        ASSIGN pc-AccountNumber = pc-AccountNumber + '|' + 
               b-cust.AccountNumber
               pc-name = pc-name + '|' + 
               b-cust.Name.
    END.


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
    DEFINE INPUT PARAMETER pc-CompanyCode      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-LoginID          AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-AccountNumber   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-cust FOR customer.
    DEFINE BUFFER b-user FOR WebUser.

   
    FIND b-user WHERE b-user.LoginID = pc-LoginID NO-LOCK NO-ERROR.
    
    FOR EACH b-cust NO-LOCK 
        WHERE b-cust.CompanyCode = pc-CompanyCode
            BY b-cust.AccountNumber:
        IF pc-AccountNumber = "" 
        THEN ASSIGN 
                pc-AccountNumber = b-cust.AccountNumber
                pc-name = b-cust.AccountNumber + " " + b-cust.NAME.
        ELSE ASSIGN 
               pc-AccountNumber = pc-AccountNumber + '|' + 
               b-cust.AccountNumber
               pc-name = pc-name + '|' + 
               b-cust.AccountNumber + " " + b-cust.Name.
    END.


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
    DEFINE INPUT  PARAMETER pc-CompanyCode AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-LoginID     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name        AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-user FOR WebUser.

   
    FOR EACH b-user NO-LOCK 
        WHERE CAN-DO(lc-global-internal,b-user.UserClass)
        AND b-user.CompanyCode = pc-CompanyCode
        BY b-user.name:

        IF pc-loginID = ""
        THEN ASSIGN pc-LoginID = b-user.LoginID
                    pc-name    = b-user.name.
        ELSE ASSIGN pc-LoginID = pc-LoginID + '|' + 
                      b-user.LoginID
                    pc-name = pc-name + '|' + 
                        b-user.Name.
    END.
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
    DEFINE INPUT PARAMETER  pc-CompanyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-buffer FOR knbSection.

    FOR EACH b-buffer NO-LOCK 
        WHERE b-buffer.CompanyCode = pc-CompanyCode
        BY b-buffer.Description:

        IF pc-codes = ""
        THEN ASSIGN pc-Codes = b-buffer.knbCode
                    pc-Desc = b-buffer.Description.
        ELSE ASSIGN pc-Codes = pc-Codes + '|' + b-buffer.knbCode
                    pc-Desc = pc-Desc + '|' + b-buffer.Description.
    END.

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
    DEFINE INPUT  PARAMETER pc-companyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-WebStatus FOR WebStatus.

    ASSIGN pc-Codes = DYNAMIC-FUNCTION("htmlib-Null")
           pc-name = "All Status Codes".


    FOR EACH b-WebStatus NO-LOCK 
        WHERE b-WebStatus.CompanyCode = pc-CompanyCode
        BREAK BY b-WebStatus.CompletedStatus 
              BY ( IF b-WebStatus.DisplayOrder = 0 THEN 99999 ELSE b-Webstatus.DisplayOrder )
              BY b-WebStatus.description:
        IF FIRST-OF(b-WebStatus.CompletedStatus) THEN
        DO:
            IF b-WebStatus.CompletedStatus = FALSE 
            THEN ASSIGN pc-Codes = pc-Codes + "|AllOpen"
                        pc-name = pc-name + '|* All Open'.
            ELSE ASSIGN pc-Codes = pc-Codes + "|AllClosed"
                        pc-name = pc-name + '|* All Closed'.

        END.
        ASSIGN pc-Codes = pc-Codes + '|' + 
               b-WebStatus.StatusCode
               pc-name = pc-name + '|&nbsp;&nbsp;&nbsp;' + 
               b-WebStatus.description.
    END.

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
    
    DEFINE INPUT  PARAMETER pc-companyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-WebStatus FOR WebStatus.

    ASSIGN pc-Codes = ""
           pc-name =  "".


    FOR EACH b-WebStatus NO-LOCK 
        WHERE b-WebStatus.CompanyCode = pc-CompanyCode
        BREAK BY b-WebStatus.CompletedStatus 
              BY ( IF b-WebStatus.DisplayOrder = 0 THEN 99999 ELSE b-Webstatus.DisplayOrder )
              BY b-WebStatus.description:
        ASSIGN pc-Codes = pc-Codes + '|' + 
               b-WebStatus.StatusCode
               pc-name = pc-name + '|' + 
               b-WebStatus.description + " (" + 
                ( IF b-WebStatus.CompletedStatus THEN "Closed" ELSE "Open" ) + 
            ")".
    END.

    ASSIGN
        pc-codes = substr(pc-codes,2)
        pc-name  = substr(pc-name,2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-GetStatusIssueOpen Include 
PROCEDURE com-GetStatusIssueOpen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-companyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-WebStatus FOR WebStatus.

    ASSIGN pc-Codes = ""
           pc-name =  "".


    FOR EACH b-WebStatus NO-LOCK 
        WHERE b-WebStatus.CompanyCode = pc-CompanyCode
          AND b-WeBStatus.CompletedStatus = NO
        BREAK BY ( IF b-WebStatus.DisplayOrder = 0 THEN 99999 ELSE b-Webstatus.DisplayOrder )
              BY b-WebStatus.description:
        ASSIGN pc-Codes = pc-Codes + '|' + 
               b-WebStatus.StatusCode
               pc-name = pc-name + '|' + 
               b-WebStatus.description + " (" + 
                ( IF b-WebStatus.CompletedStatus THEN "Closed" ELSE "Open" ) + 
            ")".
    END.

    ASSIGN
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
    DEFINE INPUT  PARAMETER pc-companyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Name            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-WebStatus FOR WebStatus.

    ASSIGN pc-Codes = "AllOpen"
           pc-name = "All Open".


    FOR EACH b-WebStatus NO-LOCK 
        WHERE b-WebStatus.CompanyCode = pc-CompanyCode
          AND b-webStatus.CompletedStatus = FALSE
        BREAK BY b-WebStatus.CompletedStatus 
              BY ( IF b-WebStatus.DisplayOrder = 0 THEN 99999 ELSE b-Webstatus.DisplayOrder )
              BY b-WebStatus.description:
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
        ASSIGN pc-Codes = pc-Codes + '|' + 
               b-WebStatus.StatusCode
               pc-name = pc-name + '|&nbsp;&nbsp;&nbsp;' + 
               b-WebStatus.description.
    END.
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
    DEFINE INPUT PARAMETER  pc-CompanyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-buffer FOR steam.

    FOR EACH b-buffer NO-LOCK 
        WHERE b-buffer.CompanyCode = pc-CompanyCode
        :

        IF pc-codes = ""
        THEN ASSIGN pc-Codes = STRING(b-buffer.st-num)
                    pc-Desc = b-buffer.Descr.
        ELSE ASSIGN pc-Codes = pc-Codes + '|' + 
               string(b-buffer.st-num)
               pc-Desc = pc-Desc + '|' + 
               b-buffer.Descr.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE com-getTemplateSelect Include 
PROCEDURE com-getTemplateSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pc-CompanyCode     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Codes           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-Desc            AS CHARACTER NO-UNDO.


    DEFINE BUFFER b-buffer FOR iemailtmp.

    FOR EACH b-buffer NO-LOCK 
        WHERE b-buffer.CompanyCode = pc-CompanyCode
       :
        IF pc-codes = ""
        THEN ASSIGN pc-Codes = b-buffer.tmpcode
                    pc-Desc = b-buffer.Descr.
        ELSE ASSIGN pc-Codes = pc-Codes + '|' + b-buffer.tmpCode
                    pc-Desc = pc-Desc + '|' + b-buffer.Descr.
    END.


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
    DEFINE INPUT PARAMETER pc-CompanyCode      AS CHARACTER     NO-UNDO.

    DEFINE BUFFER b-WebStatus  FOR WebStatus.

    FOR EACH b-WebStatus
        WHERE b-WebStatus.CompanyCode = pc-CompanyCode
          AND b-WebStatus.DefaultCode EXCLUSIVE-LOCK:

        ASSIGN 
            b-WebStatus.DefaultCode = NO.
    END.
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
    DEFINE INPUT PARAMETER pi-time     AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-hours   AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-mins    AS INTEGER      NO-UNDO.

    DEFINE VARIABLE li-sec-hours        AS INTEGER      INITIAL 3600 NO-UNDO.
    DEFINE VARIABLE li-seconds          AS INTEGER      NO-UNDO.
   
    ASSIGN 
        li-seconds = pi-time MOD li-sec-hours
        pi-mins = TRUNCATE(li-seconds / 60,0).
        
    ASSIGN
        pi-time = pi-time - li-seconds.
        
    ASSIGN
        pi-hours = TRUNCATE(pi-time / li-sec-hours,0).

    
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
    DEFINE INPUT PARAMETER     pc-CompanyCode      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER    pc-open-status      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER    pc-closed-status    AS CHARACTER NO-UNDO.

    DEFINE BUFFER b-status FOR WebStatus.

    FOR EACH b-status NO-LOCK
        WHERE b-status.CompanyCode = pc-companyCode
        BY ( IF b-status.DisplayOrder = 0 THEN 99999 ELSE b-status.DisplayOrder ):
        IF b-status.CompletedStatus = FALSE 
        THEN ASSIGN pc-open-status = TRIM(pc-open-status + ',' + b-status.StatusCode).
        ELSE ASSIGN pc-closed-status = TRIM(pc-closed-status + ',' + b-status.StatusCode).
        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AllowCustomerAccess Include 
FUNCTION com-AllowCustomerAccess RETURNS LOGICAL
  ( pc-CompanyCode AS CHARACTER,
    pc-LoginID AS CHARACTER,
    pc-AccountNumber AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-user       FOR WebUser.
    DEFINE BUFFER b-ContAccess FOR ContAccess.
    DEFINE BUFFER webusteam    FOR webusteam.
    DEFINE BUFFER customer     FOR customer.
    DEFINE VARIABLE ll-Steam    AS LOG NO-UNDO.
    DEFINE VARIABLE ll-Access   AS LOG NO-UNDO.

    
    ll-Steam = CAN-FIND(FIRST webUsteam WHERE webusteam.loginid =  pc-LoginID NO-LOCK).


    FIND b-user WHERE b-user.LoginID = pc-LoginID NO-LOCK NO-ERROR.

    IF NOT AVAILABLE b-user THEN RETURN FALSE.

    /*
    ***
    *** If internal member of a team then customer must be in one of his/her team
    ***
    */
    IF b-user.UserClass = "{&INTERNAL}" THEN 
    DO:
        IF NOT ll-Steam THEN RETURN TRUE.
        FIND customer WHERE customer.companyCode = pc-CompanyCode
                        AND customer.AccountNumber = pc-AccountNumber NO-LOCK NO-ERROR.
        IF customer.st-num = 0 THEN RETURN FALSE.
        ll-access = CAN-FIND(FIRST webUsteam WHERE webusteam.loginid = pc-LoginID
                                          AND webusteam.st-num = customer.st-num NO-LOCK).
        RETURN ll-access.
    END.

    IF b-user.UserClass = "{&CUSTOMER}" THEN
    DO:
        RETURN b-user.AccountNumber = pc-AccountNumber.
    END.

    RETURN CAN-FIND(FIRST b-ContAccess WHERE b-ContAccess.LoginID = pc-LoginID 
                      AND b-ContAccess.AccountNumber = pc-AccountNumber NO-LOCK ).


 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AllowTicketSupport Include 
FUNCTION com-AllowTicketSupport RETURNS LOGICAL
  ( pr-rowid AS ROWID ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER customer FOR customer.

    FIND customer WHERE ROWID(customer) = pr-rowid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE customer THEN RETURN FALSE.

    RETURN CAN-DO(REPLACE(lc-global-Allow-TicketSupport,"|",","),customer.SupportTicket).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AreaName Include 
FUNCTION com-AreaName RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER ,
    pc-AreaCode    AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER b1   FOR webissArea.


    FIND b1 WHERE b1.CompanyCode = pc-CompanyCode
              AND b1.AreaCode    = pc-AreaCode
                NO-LOCK NO-ERROR.


    RETURN IF AVAILABLE b1 THEN b1.DESCRIPTION ELSE "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AskTicket Include 
FUNCTION com-AskTicket RETURNS LOGICAL
  ( pc-companyCode  AS CHARACTER,
    pc-AccountNumber      AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER Customer FOR Customer.

    FIND Customer
        WHERE Customer.CompanyCode      = pc-companyCode
          AND Customer.AccountNumber    = pc-AccountNumber
          NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE Customer THEN RETURN FALSE.
    
    RETURN Customer.SupportTicket = "BOTH".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-AssignedToUser Include 
FUNCTION com-AssignedToUser RETURNS INTEGER
 ( pc-CompanyCode AS CHARACTER,
   pc-LoginID     AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-return AS INTEGER      NO-UNDO.

    DEFINE BUFFER Issue        FOR Issue.
    DEFINE BUFFER WebStatus    FOR WebStatus.


    FOR EACH Issue NO-LOCK
        WHERE Issue.CompanyCode = pc-companyCode
          AND Issue.AssignTo = pc-LoginID
           ,
          FIRST WebStatus NO-LOCK
                WHERE WebStatus.companyCode = Issue.CompanyCode
                  AND WebStatus.StatusCode  = Issue.StatusCode
                  AND WebStatus.Completed   = FALSE
          :

        ASSIGN li-return = li-return + 1.

    END.

    RETURN li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CanDelete Include 
FUNCTION com-CanDelete RETURNS LOGICAL
  ( pc-loginid  AS CHARACTER,
    pc-table    AS CHARACTER,
    pr-rowid    AS ROWID ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER webuser      FOR webuser.
    DEFINE BUFFER customer     FOR customer.
    DEFINE BUFFER custiv       FOR custiv.
    DEFINE BUFFER issue        FOR issue.
    DEFINE BUFFER ivClass      FOR ivClass.
    DEFINE BUFFER ivSub        FOR ivSub.
    DEFINE BUFFER ivField      FOR IvField.
    DEFINE BUFFER CustField    FOR CustField.
    DEFINE BUFFER webIssCat    FOR WebIssCat.
    DEFINE BUFFER issAction    FOR issAction.
    DEFINE BUFFER issStatus    FOR issStatus.
    DEFINE BUFFER issNote      FOR IssNote.
    DEFINE BUFFER WebStatus    FOR WebStatus.
    DEFINE BUFFER webNote      FOR WebNote.
    DEFINE BUFFER webIssArea   FOR WebIssArea.
    DEFINE BUFFER knbSection   FOR knbSection.
    DEFINE BUFFER knbItem      FOR knbItem.
    DEFINE BUFFER webissagrp   FOR webissagrp.
    DEFINE BUFFER steam        FOR steam.

    CASE pc-table:
        WHEN "webissagrp" THEN
        DO:
            FIND webissagrp WHERE ROWID(webissagrp) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE webissagrp THEN RETURN FALSE.
            RETURN NOT 
                    CAN-FIND(FIRST WebIssArea 
                             WHERE webIssArea.CompanyCode = webissagrp.CompanyCode
                               AND webIssArea.GroupID = webissagrp.GroupId NO-LOCK).
            
        END.
        WHEN "webIssCat" THEN
        DO:
            FIND webIssCat WHERE ROWID(webIssCat) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE webIssCat THEN RETURN FALSE.
            IF webIssCat.IsDefault THEN RETURN FALSE.
            RETURN NOT 
                    CAN-FIND(FIRST issue OF webissCat NO-LOCK).
        END.
        WHEN "webEQClass" THEN
        DO:
            RETURN TRUE.
            /* PH - Allow delete regardless 
            find ivClass where rowid(ivClass) = pr-rowid no-lock no-error.
            if not avail ivClass then return false.
            return not
                can-find(first ivSub of ivClass no-lock).
            */
        END.
        WHEN "webSubClass" THEN
        DO:
            RETURN TRUE.
            /*
            find ivSub where rowid(ivSub) = pr-rowid no-lock no-error.
            if not avail ivSub then return false.
            if can-find(first ivField where ivField.ivSubID = 
                               ivSub.ivSubID no-lock) then return false.

            if can-find(first Custiv where Custiv.ivSubID = 
                               ivSub.ivSubID no-lock) then return false.
            return true.
            */    
        END.
        WHEN "webInvField" THEN
        DO:
            FIND ivfield WHERE ROWID(ivfield) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ivfield THEN RETURN FALSE.

            RETURN NOT 
                CAN-FIND(FIRST Custfield 
                         WHERE CustField.ivFieldID = ivField.ivFieldID
                         NO-LOCK).


        END.
        WHEN "CUSTOMER" THEN
        DO:
            FIND customer WHERE ROWID(customer) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE customer THEN RETURN FALSE.
            IF CAN-FIND(FIRST issue
                WHERE issue.CompanyCode     = customer.CompanyCode
                  AND issue.AccountNumber   = customer.AccountNumber
                  NO-LOCK) THEN RETURN FALSE.
            IF CAN-FIND(FIRST WebUser
                WHERE WebUser.CompanyCode     = customer.CompanyCode
                  AND WebUser.AccountNumber   = customer.AccountNumber
                  NO-LOCK) THEN RETURN FALSE.
            RETURN TRUE.
        END.
        WHEN "customerequip" THEN
        DO:
            RETURN TRUE.
        END.
        WHEN "WEBUSER" THEN
        DO:
            FIND webuser WHERE ROWID(webuser) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE webuser THEN RETURN FALSE.
            IF CAN-FIND(FIRST issue
                WHERE issue.AssignTo = webuser.LoginID 
                  AND issue.companyCode = webuser.companyCode NO-LOCK) 
            THEN RETURN FALSE.
            IF CAN-FIND(FIRST issue
                WHERE issue.RaisedLoginID = webuser.LoginID 
                  AND issue.companyCode = webuser.companyCode NO-LOCK) 
            THEN RETURN FALSE.
            IF CAN-FIND(FIRST issAction
                        WHERE issAction.AssignTo = webuser.LoginID NO-LOCK)
            THEN RETURN FALSE.

            IF CAN-FIND(FIRST issAction
                        WHERE issAction.AssignBy = webuser.LoginID NO-LOCK)
            THEN RETURN FALSE.
            IF CAN-FIND(FIRST issAction
                        WHERE issAction.CreatedBy = webuser.LoginID NO-LOCK)
            THEN RETURN FALSE.
            RETURN TRUE.
        END.

        


        WHEN "webactivetype" THEN
        DO:
            RETURN TRUE.
        END.
            
        WHEN "webeqcontract" THEN
        DO:
              RETURN TRUE.
        END.

        WHEN "webattr" THEN
        DO:
            RETURN FALSE.
        END.
        WHEN "webmenu" THEN
        DO:
            RETURN FALSE.
        END.
        WHEN "webobject" THEN
        DO:
            RETURN FALSE.
        END.
        WHEN "webstatus" THEN
        DO:
            FIND webStatus WHERE ROWID(webStatus) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE webStatus THEN RETURN FALSE.
            IF webStatus.DefaultCode THEN RETURN FALSE.

            IF CAN-FIND(FIRST IssStatus WHERE issStatus.CompanyCode = 
                        webStatus.CompanyCode
                        AND IssStatus.NewStatusCode = webStatus.StatusCode
                        NO-LOCK)
            OR CAN-FIND(FIRST IssStatus WHERE issStatus.CompanyCode = 
                        webStatus.CompanyCode
                        AND IssStatus.OldStatusCode = webStatus.StatusCode
                        NO-LOCK) THEN RETURN FALSE.

            RETURN TRUE.


        END.
        WHEN "webnote" THEN
        DO:
            FIND webNote WHERE ROWID(webNote) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE webNote THEN RETURN FALSE.
            IF webNote.NoteCode BEGINS "sys." THEN RETURN FALSE.

            IF CAN-FIND(FIRST issNote
                        WHERE issNote.CompanyCode = webNote.CompanyCode
                          AND issNote.NoteCode    = webNote.NoteCode NO-LOCK)
            THEN RETURN FALSE.


            RETURN TRUE.

        END.
        WHEN "webIssArea" THEN
        DO:
            FIND webIssArea WHERE ROWID(webIssArea) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE webIssArea THEN RETURN FALSE.
            IF CAN-FIND(FIRST issue
                        WHERE issue.CompanyCode = webIssArea.CompanyCode
                          AND issue.AreaCode    = webIssArea.AreaCode NO-LOCK)
            THEN RETURN FALSE.

            RETURN TRUE.

        END.
        WHEN "webcomp" THEN
        DO:
            RETURN FALSE.
        END.
        WHEN "WEBACTION" THEN
        DO:
            FIND webAction WHERE ROWID(webAction) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE webAction THEN RETURN FALSE.
            IF CAN-FIND(FIRST issAction
                        WHERE issAction.ActionID = webAction.ActionID
                          NO-LOCK)
            THEN RETURN FALSE.

            RETURN TRUE.
        END.
        WHEN "knbsection" THEN
        DO:
            FIND knbSection WHERE ROWID(knbSection) = pr-rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE knbSection THEN RETURN FALSE.
            IF CAN-FIND(FIRST knbItem OF knbSection NO-LOCK)
            THEN RETURN FALSE.

            RETURN TRUE.
        END.
        WHEN "knbitem" THEN
        DO:
            RETURN TRUE.
        END.
        WHEN "gentab" THEN
        DO:
            RETURN TRUE.
        END.
        WHEN 'iemailtmp' THEN
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
        OTHERWISE
            DO:
                MESSAGE "com-CanDelete invalid table for " pc-table.
                RETURN FALSE.
            END.
    END CASE.
 
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CatName Include 
FUNCTION com-CatName RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER,
    pc-Code AS CHARACTER
    ) :


    
    DEFINE BUFFER b-table FOR WebissCat.

    FIND b-table NO-LOCK 
        WHERE b-table.CompanyCode = pc-CompanyCode
          AND b-table.CatCode = pc-Code NO-ERROR.

       
    RETURN IF AVAILABLE  b-table THEN b-table.DESCRIPTION ELSE pc-code.




END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CheckSystemSetup Include 
FUNCTION com-CheckSystemSetup RETURNS LOGICAL
  ( pc-CompanyCode AS CHARACTER ) :
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
    DEFINE VARIABLE li-loop AS INTEGER      NO-UNDO.
  
    DEFINE BUFFER WebNote      FOR WebNote.
    DEFINE BUFFER KnbSection   FOR knbSection.

    IF pc-companyCode = "" THEN RETURN TRUE.

    DO TRANSACTION:
        DO li-loop = 1 TO NUM-ENTRIES(lc-System-Note-Code):
            IF CAN-FIND(WebNote WHERE WebNote.CompanyCode = pc-companyCode 
                         AND WebNote.NoteCode = entry(li-loop,lc-System-Note-Code) NO-LOCK)
                        THEN NEXT.
            CREATE WebNote.
            ASSIGN 
                WebNote.CompanyCode = pc-companyCode
                WebNote.NoteCode    = ENTRY(li-loop,lc-System-Note-Code)
                WebNote.description = ENTRY(li-loop,lc-System-Note-Desc)
                WebNote.CustomerCanView = FALSE.
            RELEASE WebNote.
        END.


    END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CookieDate Include 
FUNCTION com-CookieDate RETURNS DATE
  ( pc-user AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER webuser FOR webuser.
    DEFINE BUFFER company FOR company.

    FIND webuser WHERE webuser.LoginID = pc-user NO-LOCK NO-ERROR.
    IF NOT AVAILABLE webuser THEN RETURN ?.
    IF WebUser.disabletimeout THEN RETURN ?.
    
    
    FIND company WHERE company.CompanyCode = webuser.CompanyCode 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE company THEN RETURN ?.
    
    RETURN IF company.timeout = 0 THEN ? ELSE TODAY.
        
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CookieTime Include 
FUNCTION com-CookieTime RETURNS INTEGER
( pc-user AS CHARACTER ) :
/*------------------------------------------------------------------------------
 Purpose:  
   Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER webuser FOR webuser.
    DEFINE BUFFER company FOR company.

    FIND webuser WHERE webuser.LoginID = pc-user NO-LOCK NO-ERROR.
    IF NOT AVAILABLE webuser THEN RETURN ?.
    IF WebUser.disabletimeout THEN RETURN ?.
    
    
    FIND company WHERE company.CompanyCode = webuser.CompanyCode 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE company THEN RETURN ?.
    /*
    message "time * 60 = " string(time,"hh:mm:SS") " to = " company.timeout 
                    " rev = " string(time + ( company.timeout * 60 ),"hh:mm:SS").
    */
    RETURN IF company.timeout = 0 THEN ? ELSE TIME + ( company.timeout * 60 ).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CustomerAvailableSLA Include 
FUNCTION com-CustomerAvailableSLA RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER,
    pc-AccountNumber AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lc-return   AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE li-loop     AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lc-char     AS CHARACTER     NO-UNDO.

    DEFINE BUFFER slahead  FOR slahead.


    DO li-loop = 1 TO 2:
        ASSIGN
            lc-char = IF li-loop = 1 THEN pc-AccountNumber ELSE "".
        IF li-loop = 1 AND lc-char = "" THEN NEXT.

        FOR EACH slahead NO-LOCK
            WHERE slahead.companycode = pc-CompanyCode
              AND slahead.AccountNumber = lc-char
              BY slahead.SLACode:

            IF lc-return = ""
            THEN lc-return = STRING(ROWID(slahead)).
            ELSE lc-return = lc-return + "|" + string(ROWID(slahead)).
        END.

    END.
    

    RETURN lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CustomerName Include 
FUNCTION com-CustomerName RETURNS CHARACTER
  ( pc-Company AS CHARACTER,
    pc-Account  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

   
    DEFINE BUFFER b-Customer   FOR Customer.

    
    FIND b-Customer
        WHERE b-Customer.CompanyCode = pc-Company
          AND b-Customer.AccountNumber = pc-Account
          NO-LOCK NO-ERROR.

    RETURN IF AVAILABLE b-Customer THEN b-Customer.name ELSE "".


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-CustomerOpenIssues Include 
FUNCTION com-CustomerOpenIssues RETURNS INTEGER
 ( pc-CompanyCode AS CHARACTER,
   pc-accountNumber AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-return AS INTEGER      NO-UNDO.

    DEFINE BUFFER Issue        FOR Issue.
    DEFINE BUFFER WebStatus    FOR WebStatus.


    FOR EACH Issue NO-LOCK
        WHERE Issue.CompanyCode = pc-companyCode
          AND Issue.AccountNumber = pc-AccountNumber
          ,
          FIRST WebStatus NO-LOCK
                WHERE WebStatus.companyCode = Issue.CompanyCode
                  AND WebStatus.StatusCode  = Issue.StatusCode
                  AND WebStatus.Completed   = FALSE
          :

        ASSIGN li-return = li-return + 1.

    END.

    RETURN li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-DecodeLookup Include 
FUNCTION com-DecodeLookup RETURNS CHARACTER
  ( pc-code AS CHARACTER,
    pc-code-list AS CHARACTER,
    pc-code-display AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-index        AS INTEGER          NO-UNDO.

    ASSIGN
        li-index = LOOKUP(pc-code,pc-code-list,"|").

    RETURN
        IF li-index = 0 THEN pc-code
        ELSE ENTRY(li-index,pc-code-display,"|").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-DescribeTicket Include 
FUNCTION com-DescribeTicket RETURNS CHARACTER
  ( pc-TxnType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE pc-txntype:
        WHEN "TCK" THEN RETURN "Ticket".
        WHEN "ADJ" THEN RETURN "Adjustment".
        WHEN "ACT" THEN RETURN "Activity".
    END CASE.
      
    RETURN pc-txntype.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-GenTabDesc Include 
FUNCTION com-GenTabDesc RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER,
    pc-GType AS CHARACTER,
    pc-Code AS CHARACTER
    ) :


    
    DEFINE BUFFER b-GenTab FOR GenTab.

    FIND b-GenTab NO-LOCK 
        WHERE b-GenTab.CompanyCode = pc-CompanyCode
          AND b-GenTab.gType = pc-gType
          AND b-gentab.gCode = pc-Code NO-ERROR.

       
    RETURN IF AVAILABLE  b-gentab THEN b-GenTab.Descr ELSE "Missing".




END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-GetDefaultCategory Include 
FUNCTION com-GetDefaultCategory RETURNS CHARACTER
  ( pc-CompanyCode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-table FOR WebIssCat.


    FIND FIRST b-table
        WHERE b-table.CompanyCode = pc-CompanyCode
          AND b-table.isDefault   = TRUE
          NO-LOCK NO-ERROR.

    RETURN
        IF AVAILABLE b-table THEN b-table.CatCode ELSE "".


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-Initialise Include 
FUNCTION com-Initialise RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-loop     AS INTEGER      NO-UNDO.


    DO li-loop = 0 TO 23:

        IF li-loop = 0 THEN
        DO:
            ASSIGN 
                lc-global-hour-display = "00"
                lc-global-hour-code    = "00".
            NEXT.
        END.
        ASSIGN 
            lc-global-hour-code = lc-global-hour-code + "|" + 
                                  string(li-loop)
            lc-global-hour-display = lc-global-hour-display + "|" + 
                                         string(li-loop).

       
                
    END.

    DO li-loop = 0 TO 55 BY 5:
        IF li-loop = 0
        THEN ASSIGN lc-global-min-code = STRING(li-loop)
                    lc-global-min-display = STRING(li-loop,"99").
        ELSE ASSIGN lc-global-min-code = lc-global-min-code + "|" + string(li-loop)
                    lc-global-min-display = lc-global-min-display + "|" + string(li-loop,"99").
    END.
    
    DO li-loop = 0 TO 59 BY 1:
        IF li-loop = 0
        THEN ASSIGN lc-global-min-code = STRING(li-loop)
                    lc-global-min-display = STRING(li-loop,"99").
        ELSE ASSIGN lc-global-min-code = lc-global-min-code + "|" + string(li-loop)
                    lc-global-min-display = lc-global-min-display + "|" + string(li-loop,"99").
    END.


    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-InitialSetup Include 
FUNCTION com-InitialSetup RETURNS LOGICAL
  ( pc-LoginID AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER webuser FOR webuser.

    ASSIGN lc-global-user = pc-LoginID.


    FIND webuser WHERE webuser.LoginID = pc-LoginID NO-LOCK NO-ERROR.

    IF AVAILABLE webuser THEN 
    DO:
        ASSIGN lc-global-company = webuser.CompanyCode.
        DYNAMIC-FUNCTION('com-CheckSystemSetup':U,lc-global-company).
    END.


    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-InternalTime Include 
FUNCTION com-InternalTime RETURNS INTEGER
  ( pi-hours AS INTEGER,
    pi-mins  AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


    RETURN ( ( pi-hours * 60 ) * 60 ) + ( pi-mins * 60 ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-IsContractor Include 
FUNCTION com-IsContractor RETURNS LOGICAL
  ( pc-companyCode  AS CHARACTER,
    pc-LoginID      AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER Webuser FOR WebUser.

    FIND WebUser
        WHERE WebUser.LoginID = pc-LoginID
          NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE WebUser THEN RETURN FALSE.
    
    RETURN WebUser.UserClass = "contract".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-IsCustomer Include 
FUNCTION com-IsCustomer RETURNS LOGICAL
  ( pc-companyCode  AS CHARACTER,
    pc-LoginID      AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER Webuser FOR WebUser.

    FIND WebUser
        WHERE WebUser.LoginID = pc-LoginID
          NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE WebUser THEN RETURN FALSE.
    
    RETURN WebUser.UserClass = "customer".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-IssueActionsStatus Include 
FUNCTION com-IssueActionsStatus RETURNS INTEGER
  ( pc-companyCode AS CHARACTER,
    pi-issue   AS INTEGER,
    pc-status  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-return AS INTEGER      NO-UNDO.

    DEFINE BUFFER IssAction    FOR IssAction.


    FOR EACH IssAction NO-LOCK
        WHERE IssAction.companycode = pc-companyCode
          AND issAction.issuenumber = pi-issue 
          AND IssAction.ActionStatus = pc-status:

        ASSIGN li-return = li-return + 1.

    END.

    RETURN li-return.
    

  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-IssueStatusAlert Include 
FUNCTION com-IssueStatusAlert RETURNS LOGICAL
  ( pc-CompanyCode AS CHARACTER,
    pc-CreateSource AS CHARACTER,
    pc-StatusCode   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER WebStatus    FOR WebStatus.

    IF pc-CreateSource <> "EMAIL" THEN RETURN TRUE.

    FIND WebStatus
        WHERE WebStatus.CompanyCode = pc-CompanyCode
          AND WebStatus.StatusCode  = pc-StatusCode NO-LOCK NO-ERROR.
    IF NOT AVAILABLE WebStatus THEN RETURN TRUE.

    RETURN NOT WebStatus.IgnoreEmail.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-IsSuperUser Include 
FUNCTION com-IsSuperUser RETURNS LOGICAL
  ( pc-LoginID      AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER Webuser FOR WebUser.

    FIND WebUser
        WHERE WebUser.LoginID = pc-LoginID
          NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE WebUser THEN RETURN FALSE.
    
    RETURN WebUser.UserClass = "INTERNAL" AND WebUser.SuperUser.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-MonthBegin Include 
FUNCTION com-MonthBegin RETURNS DATE
  ( pd-date AS DATE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN pd-date - ( DAY(pd-date) ) + 1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-MonthEnd Include 
FUNCTION com-MonthEnd RETURNS DATE
  ( pd-date AS DATE ) :
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
  ( pi-time AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  
    DEFINE VARIABLE lc-time     AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE li-mins     AS INTEGER      NO-UNDO.
    DEFINE VARIABLE li-rem      AS INTEGER      NO-UNDO.


    ASSIGN
        lc-time = STRING(pi-time,"hh:mm").


    ASSIGN
        li-mins = int(substr(lc-time,4,2)).


    IF li-mins = 0 THEN RETURN 0.

    ASSIGN
        li-rem = li-mins MOD 5.

    RETURN ( li-mins - ( li-mins MOD 5 ) ). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfActions Include 
FUNCTION com-NumberOfActions RETURNS INTEGER
  ( pc-LoginID AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-return AS INTEGER      NO-UNDO.

    DEFINE BUFFER IssAction    FOR IssAction.


    FOR EACH IssAction NO-LOCK
        WHERE IssAction.AssignTo = pc-LoginID
          AND IssAction.ActionStatus = "OPEN":

        ASSIGN li-return = li-return + 1.

    END.

    RETURN li-return.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfAlerts Include 
FUNCTION com-NumberOfAlerts RETURNS INTEGER
 ( pc-LoginID AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-return AS INTEGER      NO-UNDO.

    DEFINE BUFFER IssAlert    FOR IssAlert.


    FOR EACH IssAlert NO-LOCK
        WHERE IssAlert.LoginID = pc-LoginID
          :

        ASSIGN li-return = li-return + 1.

    END.

    RETURN li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfEmails Include 
FUNCTION com-NumberOfEmails RETURNS INTEGER
  ( pc-LoginID AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-return       AS INTEGER      NO-UNDO.
    DEFINE BUFFER webuser      FOR webuser.
    DEFINE BUFFER e            FOR EmailH.

    FIND webuser WHERE webuser.LoginID = pc-loginID NO-LOCK NO-ERROR.

    IF AVAILABLE webuser
    AND webuser.userclass = "INTERNAL" AND webuser.SuperUser THEN
    DO:
        FOR EACH e WHERE e.companyCode = webuser.CompanyCode NO-LOCK:
            ASSIGN
                li-return = li-return + 1.
        END.
    END.
    
    RETURN li-return.
    


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfInventoryWarnings Include 
FUNCTION com-NumberOfInventoryWarnings RETURNS INTEGER
    ( pc-LoginID AS CHARACTER ) :
/*------------------------------------------------------------------------------
 Purpose:  
   Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-return       AS INTEGER      NO-UNDO.
    DEFINE VARIABLE ld-WarnFrom     AS DATE     NO-UNDO.
    DEFINE VARIABLE ld-DueDate      AS DATE     NO-UNDO.
    
    DEFINE BUFFER webUser      FOR WebUser.
    DEFINE BUFFER ivField      FOR ivField.
    DEFINE BUFFER ivSub        FOR ivSub.
    DEFINE BUFFER custField    FOR custField.

    FIND webuser WHERE webuser.LoginID = pc-loginID NO-LOCK NO-ERROR.

    IF DYNAMIC-FUNCTION('com-IsSuperUser':U,pc-loginid) THEN
    FOR EACH ivField NO-LOCK
        WHERE ivField.dType = "date"
          AND ivField.dWarning > 0,
          FIRST ivSub OF ivField NO-LOCK:

        IF ivSub.CompanyCode <> webuser.CompanyCode THEN NEXT.

        ASSIGN
            ld-WarnFrom = TODAY - ivField.dWarning.

        FOR EACH CustField NO-LOCK
            WHERE CustField.ivFieldID = ivField.ivFieldID:

            
            IF custField.FieldData = "" 
            OR custField.FieldData = ? THEN NEXT.

            ASSIGN
                ld-DueDate = DATE(custfield.FieldData) no-error.
            IF ERROR-STATUS:ERROR 
            OR ld-DueDate = ? THEN NEXT.

            /* 
            *** Waring base on
            *** Today in within range of Inventory Date - Warning Period AND
            *** Inventory Date is today or in the future
            *** If the inventory date has passed then no more warnings
            ***
            */
            IF TODAY >= ld-DueDate - ivField.dWarning
            AND ld-DueDate >= TODAY  
            THEN ASSIGN li-return = li-return + 1.
        END.
            


    END.

    RETURN li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberOfOpenActions Include 
FUNCTION com-NumberOfOpenActions RETURNS INTEGER
  ( pc-LoginID AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-return AS INTEGER      NO-UNDO.

    DEFINE BUFFER IssAction    FOR IssAction.
    DEFINE BUFFER WebUser      FOR WebUser.


    FIND webuser WHERE webuser.LoginID = pc-loginid NO-LOCK NO-ERROR.

    IF NOT AVAILABLE webuser THEN RETURN 0.


    IF webUser.SuperUser THEN
    FOR EACH IssAction NO-LOCK
        WHERE IssAction.CompanyCode = webuser.CompanyCode
          AND IssAction.ActionStatus = "OPEN":

        ASSIGN li-return = li-return + 1.

    END.

    RETURN li-return.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-NumberUnAssigned Include 
FUNCTION com-NumberUnAssigned RETURNS INTEGER
 ( pc-CompanyCode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE li-return AS INTEGER      NO-UNDO.

    DEFINE BUFFER Issue        FOR Issue.
    DEFINE BUFFER WebStatus    FOR WebStatus.


    FOR EACH Issue NO-LOCK
        WHERE Issue.CompanyCode = pc-companyCode
          AND Issue.AssignTo = ""
           ,
          FIRST WebStatus NO-LOCK
                WHERE WebStatus.companyCode = Issue.CompanyCode
                  AND WebStatus.StatusCode  = Issue.StatusCode
                  AND WebStatus.Completed   = FALSE
          :

        ASSIGN li-return = li-return + 1.

    END.

    RETURN li-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-QuickView Include 
FUNCTION com-QuickView RETURNS LOGICAL
  ( pc-LoginID  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-WebUser    FOR webUser.
    DEFINE BUFFER b-Customer   FOR Customer.

    FIND b-WebUser
        WHERE b-WebUser.LoginID = pc-LoginID NO-LOCK NO-ERROR.

    IF NOT AVAILABLE b-webuser
    OR b-webuser.UserClass = "{&CUSTOMER}" THEN RETURN FALSE.

    IF b-webuser.UserClass = "{&CONTRACT}" THEN RETURN TRUE.
    
    IF b-webuser.SuperUser THEN RETURN TRUE.

    RETURN b-webuser.QuickView.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-RequirePasswordChange Include 
FUNCTION com-RequirePasswordChange RETURNS LOGICAL
  ( pc-user AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER webUser FOR WebUser.
    DEFINE BUFFER company FOR company.
  

    FIND webUser
        WHERE webUser.loginid = pc-user EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

    IF LOCKED webuser
    OR NOT AVAILABLE webuser THEN RETURN FALSE.

    
    FIND company 
        WHERE company.CompanyCode = webuser.CompanyCode NO-LOCK NO-ERROR.
    IF NOT AVAILABLE company THEN RETURN FALSE.

    IF company.PasswordExpire = 0 THEN RETURN FALSE.

    
    IF webuser.LastPasswordChange = ?
        THEN ASSIGN webUser.LastPasswordChange = TODAY.


    RETURN ( webuser.LastPasswordChange + company.PasswordExpire ) <=
           TODAY.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-SLADescription Include 
FUNCTION com-SLADescription RETURNS CHARACTER
    ( pf-SLAID AS DECIMAL ) :
/*------------------------------------------------------------------------------
 Purpose:  
   Notes:  
------------------------------------------------------------------------------*/

   DEFINE BUFFER slahead  FOR slahead.

   FIND slahead
       WHERE slahead.SLAID = pf-SLAID
       NO-LOCK NO-ERROR.


   RETURN IF AVAILABLE slahead
          THEN slahead.description ELSE "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-StatusTrackIssue Include 
FUNCTION com-StatusTrackIssue RETURNS LOGICAL
  ( pc-companycode AS CHARACTER,
    pc-StatusCode  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER  webStatus   FOR webStatus.

    FIND webStatus
        WHERE webStatus.companycode = pc-companycode
          AND webStatus.StatusCode  = pc-statuscode
          NO-LOCK NO-ERROR.

    RETURN IF AVAILABLE webstatus THEN webstatus.CustomerTrack ELSE FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-StringReturn Include 
FUNCTION com-StringReturn RETURNS CHARACTER
  ( pc-orig AS CHARACTER,
    pc-add AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF pc-add = ""
    OR pc-add = ? THEN RETURN pc-orig.

    IF pc-orig = "" THEN RETURN pc-add.

    RETURN pc-orig + "~n" + pc-add.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-SystemLog Include 
FUNCTION com-SystemLog RETURNS LOGICAL
  ( pc-ActType AS CHARACTER,
    pc-LoginID AS CHARACTER,
    pc-AttrData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER SysAct FOR SysAct.

    DO TRANSACTION:
        CREATE SysAct.
        ASSIGN
            SysAct.ActDate = TODAY
            SysAct.ActTime = TIME
            SysAct.LoginID = pc-LoginID
            SysAct.ActType = pc-ActType
            SysAct.AttrData = pc-AttrData.

        RELEASE SysAct.
    END.


    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-TicketOnly Include 
FUNCTION com-TicketOnly RETURNS LOGICAL
  ( pc-companyCode  AS CHARACTER,
    pc-AccountNumber      AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER Customer FOR Customer.

    FIND Customer
        WHERE Customer.CompanyCode      = pc-companyCode
          AND Customer.AccountNumber    = pc-AccountNumber
          NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE Customer THEN RETURN FALSE.
    
    RETURN Customer.SupportTicket = "YES".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-TimeReturn Include 
FUNCTION com-TimeReturn RETURNS CHARACTER
  ( pc-Type AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE pc-Type:
        WHEN "HOUR" 
        THEN      RETURN lc-global-hour-code + "^" + lc-global-hour-display.
        OTHERWISE RETURN lc-global-min-code + "^" + lc-global-min-display.
    END CASE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-TimeToString Include 
FUNCTION com-TimeToString RETURNS CHARACTER
  ( pi-time AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE li-sec-hours        AS INTEGER      INITIAL 3600 NO-UNDO.
    DEFINE VARIABLE li-seconds          AS INTEGER      NO-UNDO.
    DEFINE VARIABLE li-mins             AS INTEGER      NO-UNDO.
    DEFINE VARIABLE li-hours            AS INTEGER      NO-UNDO.
    DEFINE VARIABLE ll-neg              AS LOG      NO-UNDO.

    IF pi-time < 0 THEN ASSIGN ll-neg = TRUE
                               pi-time = pi-time * -1.

    ASSIGN 
        li-seconds = pi-time MOD li-sec-hours
        li-mins = TRUNCATE(li-seconds / 60,0).
        
    ASSIGN
        pi-time = pi-time - li-seconds.
        
    ASSIGN
        li-hours = TRUNCATE(pi-time / li-sec-hours,0).

    RETURN TRIM( ( IF ll-neg THEN "-" ELSE "" ) + string(li-hours) + ":" + string(li-mins,'99')).
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-UserName Include 
FUNCTION com-UserName RETURNS CHARACTER
  ( pc-LoginID AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER webuser  FOR webuser.

    CASE pc-loginID:
        WHEN "SLA.ALERT" THEN RETURN "SLA Processing".
    END CASE.

    FIND webuser
        WHERE webuser.LoginID = pc-LoginID
        NO-LOCK NO-ERROR.


    RETURN IF AVAILABLE webuser
           THEN TRIM(webuser.forename + " " + webuser.surname)
           ELSE pc-LoginID.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-UsersCompany Include 
FUNCTION com-UsersCompany RETURNS CHARACTER
  ( pc-LoginID  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-WebUser    FOR webUser.
    DEFINE BUFFER b-Customer   FOR Customer.

    FIND b-WebUser
        WHERE b-WebUser.LoginID = pc-LoginID NO-LOCK NO-ERROR.

    IF NOT AVAILABLE b-webuser
    OR b-webuser.UserClass <> "{&CUSTOMER}" THEN RETURN "".

    FIND b-Customer
        WHERE b-Customer.CompanyCode = b-WebUser.CompanyCode
          AND b-Customer.AccountNumber = b-WebUser.AccountNumber
          NO-LOCK NO-ERROR.

    RETURN IF AVAILABLE b-Customer THEN b-Customer.name ELSE "".


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION com-UserTrackIssue Include 
FUNCTION com-UserTrackIssue RETURNS LOGICAL
    ( pc-LoginID AS CHARACTER
     ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE BUFFER  webUser   FOR webUser.

    FIND webUser
        WHERE webUser.LoginID = pc-LoginID
          NO-LOCK NO-ERROR.

    RETURN IF AVAILABLE webUser AND webUser.email <> "" 
           THEN webUser.CustomerTrack ELSE FALSE.

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

