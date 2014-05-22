&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************

    Program:        rep/issuelogtt.i
    
    Purpose:        Issue Log Temp Table Def
    
    Notes:
    
    
    When        Who         What
    
    01/05/2014  phoski      Initial
***********************************************************************/

DEF TEMP-TABLE tt-ilog              NO-UNDO
    FIELD   issueNumber             LIKE issue.IssueNumber
    FIELD   AccountNumber           LIKE issue.AccountNumber
    FIELD   BriefDescription        LIKE issue.BriefDescription
    FIELD   iType                   AS CHAR LABEL 'Issue Type'
    FIELD   RaisedLoginID           LIKE issue.RaisedLoginID
    FIELD   AreaCode                LIKE issue.AreaCode LABEL 'System'
    FIELD   SLALevel                AS INT LABEL 'SLA Level'
    FIELD   CreateDate              LIKE issue.CreateDate LABEL 'Date Raised'
    FIELD   CreateTime              LIKE issue.CreateTime LABEL 'Time Raised'
    FIELD   CompDate                LIKE issue.CompDate LABEL 'Date Raised'
    FIELD   CompTime                LIKE issue.CompTime LABEL 'Time Raised'
    FIELD   ActDuration             AS CHAR LABEL 'Activity Duration'
    FIELD   SLAAchieved             AS LOG LABEL 'SLA Achieved'
    FIELD   SLAComment              AS CHAR LABEL 'SLA Comment'
    FIELD   ClosedBy                AS CHAR LABEL 'Closed By'
    FIELD   isClosed                AS LOG  LABEL 'Is Closed'

    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


