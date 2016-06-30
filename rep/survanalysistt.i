/***********************************************************************

    Program:        rep/survanalysistt.i
    
    Purpose:        Survey Analysis TT
    
    Notes:
    
    
    When        Who         What
    
    30/06/2016  phoski      Initial

***********************************************************************/

DEFINE TEMP-TABLE tt-san    NO-UNDO
    FIELD   sortField       AS CHARACTER 
    FIELD   eng-loginid     AS CHARACTER
    FIELD   issueNumber     AS INTEGER
    FIELD   issDate         AS DATE
   
    
    INDEX sortField         sortField.
    
    
