/***********************************************************************

    Program:        lib/project.i
    
    Purpose:        Complex Project Library
    
    Notes:
    
    
    When        Who         What
    02/04/2015  phoski      Initial
    
***********************************************************************/


/* **********************  Internal Procedures  *********************** */

PROCEDURE prjlib-NewProject:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-user              AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-companyCode       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pi-IssueNumber       AS INTEGER NO-UNDO.
    
    DEFINE BUFFER issue     FOR Issue.
    DEFINE BUFFER ptp_proj  FOR ptp_proj.
    DEFINE BUFFER ptp_phase FOR ptp_phase.
    DEFINE BUFFER ptp_task  FOR ptp_task.
    
    
    this_block:
    REPEAT TRANSACTION ON ERROR UNDO, LEAVE:
        FIND Issue
            WHERE Issue.CompanyCode = pc-CompanyCode
            AND Issue.IssueNumber = pi-IssueNumber EXCLUSIVE-LOCK NO-ERROR.
              
        FIND ptp_proj WHERE ptp_proj.CompanyCode = Issue.CompanyCode
            AND ptp_proj.ProjCode = Issue.projCode
            NO-LOCK NO-ERROR.
        FOR EACH ptp_phase NO-LOCK OF ptp_proj:
            RUN prjlib-ProcessPhase ( pc-user, pc-companyCode, pi-issueNumber, ptp_phase.phaseid ).
            
        END.              
        LEAVE this_block.
    END.
    


END PROCEDURE.

PROCEDURE prjlib-ProcessPhase:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-user              AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-companyCode       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pi-IssueNumber       AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pi-phaseid           AS INT64 NO-UNDO.
    
    DEFINE BUFFER issue     FOR Issue.
    DEFINE BUFFER issPhase  FOR issPhase.
    
    DEFINE BUFFER ptp_proj  FOR ptp_proj.
    DEFINE BUFFER ptp_phase FOR ptp_phase.
    DEFINE BUFFER ptp_task  FOR ptp_task.
    
    
    this_block:
    REPEAT TRANSACTION ON ERROR UNDO, LEAVE:
        FIND Issue
            WHERE Issue.CompanyCode = pc-CompanyCode
            AND Issue.IssueNumber = pi-IssueNumber EXCLUSIVE-LOCK NO-ERROR.
              
        FIND ptp_proj WHERE ptp_proj.CompanyCode = Issue.CompanyCode
            AND ptp_proj.ProjCode = Issue.projCode
            NO-LOCK NO-ERROR.
        FIND ptp_phase WHERE ptp_phase.PhaseID = pi-phaseid NO-LOCK.
        
        CREATE issPhase.
        BUFFER-COPY ptp_phase TO issPhase
            ASSIGN
                issPhase.IssueNumber = Issue.IssueNumber.
                
        FOR EACH ptp_task NO-LOCK 
            WHERE ptp_task.CompanyCode = Issue.CompanyCode
            AND ptp_task.ProjCode = Issue.projCode
            AND ptp_task.PhaseID = pi-phaseid:
                            
            RUN prjlib-ProcessTask ( pc-user, pc-companyCode, pi-issueNumber, ptp_phase.phaseid, ptp_task.TaskID ).                
        END.           
    
        LEAVE this_block.
    END.
    


END PROCEDURE.

PROCEDURE prjlib-ProcessTask:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-user              AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-companyCode       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pi-IssueNumber       AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pi-phaseid           AS INT64 NO-UNDO.
    DEFINE INPUT PARAMETER pi-taskid            AS INT64 NO-UNDO.
    
    DEFINE BUFFER issue     FOR Issue.
    DEFINE BUFFER issPhase  FOR issPhase.
    DEFINE BUFFER ptp_proj  FOR ptp_proj.
    DEFINE BUFFER ptp_phase FOR ptp_phase.
    DEFINE BUFFER ptp_task  FOR ptp_task.
    
    
    this_block:
    REPEAT TRANSACTION ON ERROR UNDO, LEAVE:
        FIND Issue
            WHERE Issue.CompanyCode = pc-CompanyCode
            AND Issue.IssueNumber = pi-IssueNumber EXCLUSIVE-LOCK NO-ERROR.
              
        FIND IssPhase
            WHERE IssPhase.CompanyCode = pc-CompanyCode
            AND IssPhase.IssueNumber = pi-IssueNumber 
            AND issPhase.phaseid = pi-phaseid 
            EXCLUSIVE-LOCK NO-ERROR.
              
                    
        FIND ptp_proj WHERE ptp_proj.CompanyCode = Issue.CompanyCode
            AND ptp_proj.ProjCode = Issue.projCode
            NO-LOCK NO-ERROR.
        FIND ptp_phase WHERE ptp_phase.PhaseID = pi-phaseid NO-LOCK.
        
        FIND ptp_task WHERE ptp_task.taskID = pi-taskid NO-LOCK.
                   
    
        LEAVE this_block.
    END.
    


END PROCEDURE.
