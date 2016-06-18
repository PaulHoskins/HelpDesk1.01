/***********************************************************************

    Program:        lib/createSurveyRequest.p
    
    Purpose:        Creates a Survey and sends the email       
    
    Notes:
    
    
    When        Who         What
    22/04/2006  phoski      Initial
    
***********************************************************************/
DEFINE INPUT PARAMETER pc-companyCode   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pc-acs_code      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pi-IssueNumber   AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pc-LoginID       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pc-Email         AS CHARACTER NO-UNDO.
 
{lib/common.i}

DEFINE BUFFER acs_head  FOR acs_head.
DEFINE BUFFER acs_line  FOR acs_line.
DEFINE BUFFER company   FOR Company.



DEFINE VARIABLE MyUUID AS RAW       NO-UNDO.
DEFINE VARIABLE cGUID  AS CHARACTER NO-UNDO. 
    

FIND acs_head 
    WHERE acs_head.CompanyCode = pc-CompanyCode
    AND acs_head.acs_code = pc-acs_code NO-LOCK NO-ERROR.
IF NOT AVAILABLE acs_head THEN RETURN.
            
ASSIGN  
        MyUUID = GENERATE-UUID  
        cGUID  = GUID(MyUUID). 
