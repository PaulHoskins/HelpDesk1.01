/***********************************************************************

    Program:        lib/project.i
    
    Purpose:        Complex Project Library
    
    Notes:
    
    
    When        Who         What
    02/04/2015  phoski      Initial
    
***********************************************************************/

{lib/project-tt.i}

FUNCTION prjlib-WorkingDays RETURNS INTEGER 
    (pi-Time      AS INTEGER) FORWARD.

/* **********************  Internal Procedures  *********************** */

PROCEDURE prjlib-BuildGanttData:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-user              AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-companyCode       AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pi-IssueNumber       AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-proj-tasks.
    
    
    
    DEFINE BUFFER issue     FOR Issue.
    DEFINE BUFFER issPhase  FOR issPhase.
    DEFINE BUFFER IssAction FOR IssAction.
    DEFINE BUFFER eSched    FOR eSched.
    
    DEFINE VARIABLE li-rno   AS INTEGER NO-UNDO.
    DEFINE VARIABLE ld-Start AS DATE    NO-UNDO.
    DEFINE VARIABLE ld-end   AS DATE    NO-UNDO.
    DEFINE VARIABLE lr-row   AS ROWID   NO-UNDO.
    
    
    FIND Issue
        WHERE Issue.CompanyCode = pc-CompanyCode
        AND Issue.IssueNumber = pi-IssueNumber NO-LOCK NO-ERROR.
            
            
    FOR EACH issPhase NO-LOCK
        WHERE IssPhase.CompanyCode = pc-CompanyCode
        AND IssPhase.IssueNumber = pi-IssueNumber 
        BY issPhase.DisplayOrder:
        ASSIGN 
            li-rno = li-rno + 1.
                
        CREATE tt-proj-tasks.
        ASSIGN
            tt-proj-tasks.rno       = li-rno
            tt-proj-tasks.id        = issPhase.PhaseID
            tt-proj-tasks.txt       = issPhase.Descr 
            tt-proj-tasks.prog      = 0.00
            tt-proj-tasks.startDate = Issue.prj-Start
            tt-proj-tasks.EndDate   = Issue.prj-Start
            tt-proj-tasks.duration  = 1
            tt-proj-tasks.parentID  = 0.
            
        ASSIGN
            lr-row   = ROWID(tt-proj-tasks)
            ld-start = ?
            ld-end   = ?.
        
        FOR EACH IssAction NO-LOCK
            WHERE IssAction.CompanyCode = pc-CompanyCode
            AND IssAction.IssueNumber = pi-IssueNumber
            AND IssAction.PhaseID = issPhase.PhaseID
            BY IssAction.DisplayOrder:
            ASSIGN 
                li-rno = li-rno + 1.    
            CREATE tt-proj-tasks.
            ASSIGN
                tt-proj-tasks.rno       = li-rno
                tt-proj-tasks.id        = IssAction.Taskid
                tt-proj-tasks.txt       = IssAction.ActDescription
                /* + " " +
                com-TimeToString(IssAction.EstDuration) */
                tt-proj-tasks.prog      = 0.00
                tt-proj-tasks.startDate = IssAction.ActionDate
                tt-proj-tasks.duration  = DYNAMIC-FUNCTION("prjlib-WorkingDays",IssAction.EstDuration)
                tt-proj-tasks.EndDate   = tt-proj-tasks.startDate + tt-proj-tasks.duration - 1
                tt-proj-tasks.parentID  = issPhase.PhaseID.
         
            IF ld-end = ?
                THEN ASSIGN ld-end = tt-proj-tasks.EndDate. 
            IF ld-start = ?
                THEN ASSIGN ld-start = tt-proj-tasks.StartDate.
            
            IF ld-start > tt-proj-tasks.StartDate
                THEN ASSIGN ld-start = tt-proj-tasks.StartDate.
            IF ld-end < tt-proj-tasks.EndDate
                THEN ASSIGN ld-end = tt-proj-tasks.endDate.
            
                   
        END.  
        
        FIND tt-proj-tasks WHERE ROWID(tt-proj-tasks) = lr-row EXCLUSIVE-LOCK.
                  
        ASSIGN
             tt-proj-tasks.startDate = ld-start
             tt-proj-tasks.EndDate   =  ld-end
             tt-proj-tasks.duration  = ( ld-end - ld-start ) + 1
             /*
             tt-proj-tasks.txt =  tt-proj-tasks.txt + " " +
                    string(ld-start,"99/99/9999") + " " +  string(ld-End,"99/99/9999")
             */
             .
                
    END.
               

END PROCEDURE.

PROCEDURE prjlib-NewProject:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-user              AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-companyCode       AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pi-IssueNumber       AS INTEGER      NO-UNDO.
    
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
    DEFINE BUFFER IssAction FOR IssAction.
    DEFINE BUFFER eSched    FOR eSched.
    
    DEFINE VARIABLE lf-Audit  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE lr-Action AS ROWID   NO-UNDO.
    
    
    
    
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
                   
        /**/
        
        CREATE IssAction.
        ASSIGN 
            IssAction.actionID     = ? /* There's no action */
            IssAction.CompanyCode  = Issue.companyCode
            IssAction.IssueNumber  = issue.IssueNumber
            IssAction.CreateDate   = TODAY
            IssAction.CreateTime   = TIME
            IssAction.CreatedBy    = pc-user
            IssAction.customerview = NO
            .
    
        DO WHILE TRUE:
            RUN lib/makeaudit.p (
                "",
                OUTPUT lf-audit
                ).
            IF CAN-FIND(FIRST IssAction
                WHERE IssAction.IssActionID = lf-audit NO-LOCK)
                THEN NEXT.
            ASSIGN
                IssAction.IssActionID = lf-audit.
            LEAVE.
        END.
        ASSIGN 
            IssAction.notes        = ptp_task.descr
            IssAction.ActionStatus = "OPEN"
            IssAction.ActionDate   = ( Issue.prj-Start + ptp_task.StartDay ) - 1 
            IssAction.AssignTo     = Issue.AssignTo
            IssAction.AssignDate   = TODAY
            IssAction.AssignTime   = TIME.
       
        BUFFER-COPY ptp_task TO IssAction.
        
        CREATE eSched.
        ASSIGN
            eSched.eSchedID = NEXT-VALUE(esched).
        BUFFER-COPY IssAction TO eSched.
                    
                 
        ASSIGN
            IssAction.ActDescription = ptp_task.Descr
            IssAction.phaseid        = ptp_task.phaseid.
            
        LEAVE this_block.
    END.
    


END PROCEDURE.


/* ************************  Function Implementations ***************** */

FUNCTION prjlib-WorkingDays RETURNS INTEGER 
    ( pi-Time      AS INTEGER  ):
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE li-1day AS INTEGER NO-UNDO.
    
    
    ASSIGN 
        li-1day = ( 7.5 * 60 ) * 60. /* 7.5 hours into seconds */
    
    IF pi-time <= li-1day
        THEN RETURN 1.
    		

		
END FUNCTION.
