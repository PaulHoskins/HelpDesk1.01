/***********************************************************************

    Program:        rep/survanalysis-build.p
    
    Purpose:        Survey Analysis Report - Build
    
    Notes:
    
    
    When        Who         What
    
    30/06/2016  phoski      Initial

***********************************************************************/

{rep/survanalysistt.i}
DEFINE INPUT PARAMETER pc-companycode          AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pc-acs_code             AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pi-acs_line_id          AS INTEGER           NO-UNDO.
DEFINE INPUT PARAMETER pc-FromAccountNumber    AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pc-ToAccountNumber      AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pl-allcust              AS LOG               NO-UNDO.
DEFINE INPUT PARAMETER pd-FromDate             AS DATE              NO-UNDO.
DEFINE INPUT PARAMETER pd-ToDate               AS DATE              NO-UNDO.
DEFINE INPUT PARAMETER pc-FromEng              AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pc-ToEng                AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAMETER pc-sort                 AS CHARACTER         NO-UNDO.


DEFINE OUTPUT PARAMETER table              FOR tt-san.
