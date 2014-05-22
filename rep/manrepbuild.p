&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/manrepbuild.p
    
    Purpose:        Management Report - Build Data       
    
    Notes:
    
    
    When        Who         What
    10/07/2006  phoski      Initial   
    03/05/2014  phoski      Read activity nolock
***********************************************************************/

{rep/manreptt.i}


&IF DEFINED(UIB_is_Running) EQ 0 &THEN

def input param pc-companycode      as char         no-undo.
def input param pd-Date             as date         no-undo.
def input param pi-Days             as int          no-undo.
def output param table              for tt-mrep.

&ELSE

def var pc-companycode      as char no-undo.
def var pd-date as date     no-undo.
def var pi-days as int      no-undo.

assign
    pc-companycode = "MICAR"
    pd-date = today
    pi-days = 7.

&ENDIF

{iss/issue.i}


def var ld-lo-date      as date     no-undo.
def var ld-hi-date      as date     no-undo.

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

assign
    ld-lo-date = pd-date - pi-days
    ld-hi-date = pd-date.

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

    def var ld-CloseDate        as date     no-undo.

    /*
    ***
    *** All issues created before the hi date
    ***
    */    
    for each issue no-lock
        where issue.CompanyCode = pc-companyCode
          and issue.IssueDate <= ld-hi-date
          and Issue.CatCode   > ""
        :

        if not can-find(customer of Issue no-lock) then next.
                        
        /*
        ***
        *** If the job is completed then ignore if outside period
        ***
        */
        if dynamic-function("islib-IssueIsOpen",rowid(Issue)) = false then
        do:
            assign
                ld-CloseDate = dynamic-function("islib-CloseDate",rowid(Issue)).
            if ld-CloseDate < ld-lo-Date 
            or ld-CloseDate = ? then next.
            
        end.
        else ld-CloseDate = ?.

        find tt-mrep 
            where tt-mrep.AccountNumber = Issue.AccountNumber
              and tt-mrep.CatCode       = Issue.CatCode
            exclusive-lock no-error.
        if not avail tt-mrep then
        do:
            create tt-mrep.
            assign tt-mrep.AccountNumber = Issue.AccountNumber
                   tt-mrep.CatCode       = Issue.CatCode.
        end.

        /*
        ***
        *** If the issue was created before the period then bfwd,
        *** otherwise opened in period
        ***
        */
        if Issue.IssueDate < ld-lo-date 
        then assign tt-mrep.Bfwd = tt-mrep.Bfwd + 1.
        else assign tt-mrep.OpenPer = tt-mrep.OpenPer + 1.

        /*
        ***
        *** Closed in the period?
        ***
        */
        if ld-CloseDate <> ? then
        do:
            if ld-CloseDate <= ld-hi-date
            then assign tt-mrep.ClosePer = tt-mrep.ClosePer + 1.
        end.

        /*
        ***
        *** Time spent in the period
        ***
        */
        for each IssActivity of Issue 
            where IssActivity.ActDate >= ld-lo-date
              and IssActivity.ActDate <= ld-hi-date NO-LOCK:

            assign 
                tt-mrep.Duration = tt-mrep.Duration + IssActivity.Duration.

        end.

        assign
            tt-mrep.OutSt = ( tt-mrep.Bfwd + tt-mrep.OpenPer ) - tt-mrep.ClosePer.
                            

    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

