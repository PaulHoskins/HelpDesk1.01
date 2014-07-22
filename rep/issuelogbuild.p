&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/issuelogbuild.p
    
    Purpose:        Issue Log - Build Data       
    
    Notes:
    
    
    When        Who         What
    03/05/2014  phoski      Initial  cc 
***********************************************************************/

{rep/issuelogtt.i}


&IF DEFINED(UIB_is_Running) EQ 0 &THEN

DEFINE INPUT PARAMETER pc-companycode          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pc-loginid              AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pc-FromAccountNumber    AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pc-ToAccountNumber      AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pd-FromDate             AS DATE         NO-UNDO.
DEFINE INPUT PARAMETER pd-ToDate               AS DATE         NO-UNDO.
DEFINE INPUT PARAMETER pc-ClassList            AS CHARACTER         NO-UNDO.



DEFINE OUTPUT PARAMETER table              FOR tt-ilog.

&ELSE

DEFINE VARIABLE pc-companycode          AS CHARACTER         NO-UNDO.
DEFINE VARIABLE pc-loginid              AS CHARACTER         NO-UNDO.
DEFINE VARIABLE pc-FromAccountNumber    AS CHARACTER         NO-UNDO.
DEFINE VARIABLE pc-ToAccountNumber      AS CHARACTER         NO-UNDO.
DEFINE VARIABLE pd-FromDate             AS DATE         NO-UNDO.
DEFINE VARIABLE pd-ToDate               AS DATE         NO-UNDO.



&ENDIF

{lib/common.i}

{iss/issue.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */



RUN ip-BuildData.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-BuildData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildData Procedure 
PROCEDURE ip-BuildData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE BUFFER issue        FOR issue.
    DEFINE BUFFER IssStatus    FOR IssStatus.
    DEFINE BUFFER IssActivity  FOR IssActivity.
    DEFINE BUFFER issnote      FOR issnote.

    
    DEFINE VARIABLE li-seconds  AS INTEGER      NO-UNDO.
    DEFINE VARIABLE li-min      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE li-hr       AS INTEGER      NO-UNDO.
    DEFINE VARIABLE li-work     AS INTEGER      NO-UNDO.
    DEFINE VARIABLE ldt-Comp    AS DATETIME NO-UNDO.

    

    /*
    ***
    *** All issues created before the hi date
    ***
    */    
    FOR EACH issue NO-LOCK
        WHERE issue.CompanyCode = pc-companyCode
          AND issue.AccountNumber >= pc-FromAccountNumber
          AND issue.AccountNumber <= pc-ToAccountNumber
          AND issue.IssueDate >= pd-fromDate
          AND issue.IssueDate <= pd-ToDate
          AND CAN-DO(pc-classList,issue.iClass)
        :

        IF NOT CAN-FIND(customer OF Issue NO-LOCK) THEN NEXT.
                        
        CREATE tt-ilog.
        BUFFER-COPY issue TO tt-ilog.

        /*
        ***
        *** If the job is completed then ignore if outside period
        ***
        */
        ASSIGN 
            tt-ilog.iType = issue.IClass.


        ASSIGN
            tt-ilog.isClosed =  NOT DYNAMIC-FUNCTION("islib-IssueIsOpen",ROWID(Issue)).

        IF tt-ilog.SLALevel = ?
        THEN tt-ilog.SLALevel = 0.

        ASSIGN tt-ilog.SLAAchieved = TRUE.


        IF tt-ilog.isClosed THEN
        DO: 
            FIND FIRST IssStatus OF Issue NO-LOCK NO-ERROR.

            IF AVAILABLE issStatus THEN
            DO:
                ASSIGN 
                    tt-ilog.Compdate = issStatus.ChangeDate
                    tt-ilog.CompTime = issStatus.ChangeTime
                    tt-ilog.ClosedBy = DYNAMIC-FUNCTION("com-UserName",issStatus.loginID).
            END.

            /*
            FIND LAST issnote OF issue 
                WHERE issnote.notecode =  'SYS.SLAMISSED'
                NO-LOCK NO-ERROR.
            IF NOT AVAIL issnote 
            THEN ASSIGN tt-ilog.SLAAchieved = TRUE.
            ELSE ASSIGN tt-ilog.SLAAchieved = FALSE
                        tt-ilog.SLAComment = issnote.CONTENTS.

            */
            IF issue.slaTrip <> ? THEN
            DO:
                ldt-comp = ?.
                IF tt-ilog.Compdate <> ? THEN
                DO:
                    ldt-Comp = DATETIME(
                        STRING(tt-ilog.CompDate,"99/99/9999") + " " + 
                                        STRING(tt-ilog.CompTime,"hh:mm")
                               ).
                    ASSIGN
                        tt-ilog.SLAAchieved = ldt-Comp <= issue.SLATrip.


                END.
                ASSIGN tt-ilog.SLAComment = 
                   /* STRING(ldt-comp,"99/99/9999 HH:MM") + " " + */
                    STRING(issue.SLATrip,"99/99/9999 HH:MM").
            END.
        END.

        ASSIGN 
            tt-ilog.AreaCode = DYNAMIC-FUNCTION("com-AreaName",pc-companyCode,issue.AreaCode)
            tt-ilog.RaisedLoginID = DYNAMIC-FUNCTION("com-UserName",tt-ilog.RaisedLoginID).


        /*
        ***
        *** Time spent 
        ***
        */
        ASSIGN 
            li-seconds = 0.

        FOR EACH IssActivity OF Issue NO-LOCK:
   

            ASSIGN 
                li-seconds = li-seconds + IssActivity.Duration.

        END.
        li-work = li-seconds.

        IF li-seconds > 0 THEN
        DO:
            li-seconds = ROUND(li-seconds / 60,0).

            li-min = li-seconds MOD 60.

            IF li-seconds - li-min >= 60 THEN
            ASSIGN
                li-hr = ROUND( (li-seconds - li-min) / 60 , 0 ).
            ELSE li-hr = 0.

            ASSIGN
                tt-ilog.ActDuration = STRING(li-hr) + ":" + STRING(li-min,'99')
                .

        END.

    END.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

