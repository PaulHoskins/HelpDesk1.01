&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/issuelogbuild.p
    
    Purpose:        Issue Log - Build Data       
    
    Notes:
    
    
    When        Who         What
    03/05/2014  phoski      Initial   
***********************************************************************/

{rep/issuelogtt.i}


&IF DEFINED(UIB_is_Running) EQ 0 &THEN

def input param pc-companycode          as char         no-undo.
DEF INPUT PARAM pc-loginid              AS CHAR         NO-UNDO.
DEF INPUT PARAM pc-FromAccountNumber    AS CHAR         NO-UNDO.
DEF INPUT PARAM pc-ToAccountNumber      AS CHAR         NO-UNDO.
def input param pd-FromDate             as date         no-undo.
def input param pd-ToDate               as date         no-undo.
DEF INPUT PARAM pc-ClassList            AS CHAR         NO-UNDO.



def output param table              for tt-ilog.

&ELSE

def VAR pc-companycode          as char         no-undo.
DEF VAR pc-loginid              AS CHAR         NO-UNDO.
DEF VAR pc-FromAccountNumber    AS CHAR         NO-UNDO.
DEF VAR pc-ToAccountNumber      AS CHAR         NO-UNDO.
def VAR pd-FromDate             as date         no-undo.
def VAR pd-ToDate               as date         no-undo.



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
    
    DEF BUFFER issue        FOR issue.
    DEF BUFFER IssStatus    for IssStatus.
    DEF BUFFER IssActivity  FOR IssActivity.
    DEF BUFFER issnote      FOR issnote.

    
    DEF VAR li-seconds  AS INT      NO-UNDO.
    DEF VAR li-min      AS INT      NO-UNDO.
    DEF VAR li-hr       AS INT      NO-UNDO.
    DEF VAR li-work     AS INT      NO-UNDO.
    DEF VAR ldt-Comp    AS DATETIME NO-UNDO.

    

    /*
    ***
    *** All issues created before the hi date
    ***
    */    
    for each issue no-lock
        where issue.CompanyCode = pc-companyCode
          AND issue.AccountNumber >= pc-FromAccountNumber
          AND issue.AccountNumber <= pc-ToAccountNumber
          and issue.IssueDate >= pd-fromDate
          and issue.IssueDate <= pd-ToDate
          AND CAN-DO(pc-classList,issue.iClass)
        :

        if not can-find(customer of Issue no-lock) then next.
                        
        create tt-ilog.
        BUFFER-COPY issue TO tt-ilog.

        /*
        ***
        *** If the job is completed then ignore if outside period
        ***
        */
        ASSIGN 
            tt-ilog.iType = issue.IClass.


        ASSIGN
            tt-ilog.isClosed =  NOT dynamic-function("islib-IssueIsOpen",rowid(Issue)).

        IF tt-ilog.SLALevel = ?
        THEN tt-ilog.SLALevel = 0.

        ASSIGN tt-ilog.SLAAchieved = TRUE.


        IF tt-ilog.isClosed THEN
        DO: 
            find first IssStatus of Issue no-lock no-error.

            IF AVAIL issStatus THEN
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
                    assign
                        tt-ilog.SLAAchieved = ldt-Comp <= issue.SLATrip.


                END.
                ASSIGN tt-ilog.SLAComment = 
                   /* STRING(ldt-comp,"99/99/9999 HH:MM") + " " + */
                    STRING(issue.SLATrip,"99/99/9999 HH:MM").
            END.
        END.

        ASSIGN 
            tt-ilog.AreaCode = dynamic-function("com-AreaName",pc-companyCode,issue.AreaCode)
            tt-ilog.RaisedLoginID = DYNAMIC-FUNCTION("com-UserName",tt-ilog.RaisedLoginID).


        /*
        ***
        *** Time spent 
        ***
        */
        ASSIGN 
            li-seconds = 0.

        for each IssActivity of Issue NO-LOCK:
   

            assign 
                li-seconds = li-seconds + IssActivity.Duration.

        end.
        li-work = li-seconds.

        IF li-seconds > 0 THEN
        DO:
            li-seconds = ROUND(li-seconds / 60,0).

            li-min = li-seconds MOD 60.

            IF li-seconds - li-min >= 60 THEN
            assign
                li-hr = round( (li-seconds - li-min) / 60 , 0 ).
            ELSE li-hr = 0.

            ASSIGN
                tt-ilog.ActDuration = STRING(li-hr) + ":" + STRING(li-min,'99')
                .

        END.

    end.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

