/***********************************************************************

    Program:        rep/issuelogtt.i
    
    Purpose:        Issue Log Temp Table Def
    
    Notes:
    
    
    When        Who         What
    
    01/05/2014  phoski      Initial
***********************************************************************/

DEFINE TEMP-TABLE tt-ilog NO-UNDO
    FIELD issueNumber      LIKE issue.IssueNumber
    FIELD AccountNumber    LIKE issue.AccountNumber
    FIELD BriefDescription LIKE issue.BriefDescription
    FIELD iType            AS CHARACTER LABEL 'Issue Type'
    FIELD RaisedLoginID    LIKE issue.RaisedLoginID
    FIELD AreaCode         LIKE issue.AreaCode LABEL 'System'
    FIELD SLALevel         AS INTEGER   LABEL 'SLA Level'
    FIELD CreateDate       LIKE issue.CreateDate LABEL 'Date Raised'
    FIELD CreateTime       LIKE issue.CreateTime LABEL 'Time Raised'
    FIELD CompDate         LIKE issue.CompDate LABEL 'Date Raised'
    FIELD CompTime         LIKE issue.CompTime LABEL 'Time Raised'
    FIELD ActDuration      AS CHARACTER LABEL 'Activity Duration'
    FIELD SLAAchieved      AS LOG       LABEL 'SLA Achieved'
    FIELD SLAComment       AS CHARACTER LABEL 'SLA Comment'
    FIELD ClosedBy         AS CHARACTER LABEL 'Closed By'
    FIELD isClosed         AS LOG       LABEL 'Is Closed'
    FIELD iActDuration     AS INTEGER 
    
    
    INDEX MainKey IS PRIMARY 
        AccountNumber IssueNumber       
    .




/* ********************  Preprocessor Definitions  ******************** */






/* *********************** Procedure Settings ************************ */



/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */

 




/* ***************************  Main Block  *************************** */



