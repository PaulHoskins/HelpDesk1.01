/***********************************************************************

    Program:        lib/project-tt.i
    
    Purpose:        Complex Project Library - Temp table definitions
    
    Notes:
    
    
    When        Who         What
    08/04/2015  phoski      Initial
    
***********************************************************************/

DEFINE TEMP-TABLE tt-proj-tasks NO-UNDO 
    FIELD rno       AS INTEGER
    
    FIELD id        AS INT64
    FIELD startDate AS DATE
    FIELD txt       AS CHARACTER
    FIELD prog      AS DECIMAL
    FIELD duration  AS INTEGER 
    FIELD parentID  AS INT64
    
    FIELD EndDate   AS DATE 
    
    FIELD dataType  AS CHARACTER
    FIELD EngCode   AS CHARACTER 
    FIELD EngName   AS CHARACTER  
    FIELD cRow      AS CHARACTER 
    INDEX prim IS UNIQUE PRIMARY rno
    INDEX id id
    INDEX ParID parentID
    .
