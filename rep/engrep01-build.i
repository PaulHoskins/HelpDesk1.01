/***********************************************************************

    Program:        rep/engrep01-build.i
    
    Purpose:        Enginner Time Report - Temp tables
    
    Notes:
    
    
    When        Who         What
    21/11/2014  phoski      Initial
***********************************************************************/

DEFINE TEMP-TABLE tt-IssRep NO-UNDO LIKE issActivity
    FIELD AccountNumber LIKE issue.AccountNumber
    FIELD ActionDesc    LIKE issAction.Notes
    FIELD ActivityType  LIKE issActivity.ContractType
    FIELD IssueDate     LIKE Issue.IssueDate
    FIELD period-of     AS INTEGER
    INDEX i-cust AccountNumber period-of
    INDEX i-user ActivityBy    period-of.
 
DEFINE TEMP-TABLE tt-IssTime NO-UNDO
    FIELD IssueNumber   LIKE issActivity.IssueNumber
    FIELD AccountNumber LIKE issue.AccountNumber
    FIELD ActivityBy    LIKE issActivity.ActivityBy
    FIELD period-of     AS INTEGER
    FIELD billable      AS INTEGER
    FIELD nonbillable   AS INTEGER
    INDEX i-num IssueNumber period-of.

DEFINE TEMP-TABLE tt-IssTotal NO-UNDO
    FIELD AccountNumber LIKE issue.AccountNumber
    FIELD ActivityBy    LIKE issActivity.ActivityBy
    FIELD billable      AS INTEGER
    FIELD nonbillable   AS INTEGER
    FIELD productivity  AS DECIMAL
    INDEX i-num AccountNumber  
    INDEX i-by  ActivityBy.

DEFINE TEMP-TABLE tt-IssUser NO-UNDO
    FIELD ActivityBy   LIKE issActivity.ActivityBy
    FIELD period-of    AS INTEGER
    FIELD billable     AS INTEGER
    FIELD nonbillable  AS INTEGER
    FIELD productivity AS DECIMAL
    INDEX i-num ActivityBy period-of.

DEFINE TEMP-TABLE tt-IssCust NO-UNDO
    FIELD AccountNumber LIKE issue.AccountNumber
    FIELD period-of     AS INTEGER
    FIELD billable      AS INTEGER
    FIELD nonbillable   AS INTEGER
    FIELD num-issues    AS INTEGER
    INDEX i-num AccountNumber period-of.

DEFINE TEMP-TABLE tt-IssTable NO-UNDO LIKE issue 
    INDEX i-num AccountNumber.

DEFINE TEMP-TABLE tt-ThisPeriod NO-UNDO
    FIELD td-id     AS CHARACTER
    FIELD td-period AS INTEGER
    FIELD td-hours  AS DECIMAL
    INDEX i-week td-id td-period .
    