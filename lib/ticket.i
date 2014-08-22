/***********************************************************************

    Program:        lib/ticket.i
    
    Purpose:        Ticket Library
    
    Notes:
    
    
    When        Who         What
    16/07/2006  phoski      Initial   
***********************************************************************/


DEFINE TEMP-TABLE tt-ticket NO-UNDO LIKE ticket.




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



/* **********************  Internal Procedures  *********************** */

PROCEDURE tlib-IssueChanged :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-rowid        AS ROWID                NO-UNDO.
    DEFINE INPUT PARAMETER pc-loginid      LIKE webuser.loginid    NO-UNDO.
    DEFINE INPUT PARAMETER pl-from         AS LOG                  NO-UNDO.
    DEFINE INPUT PARAMETER pl-to           AS LOG                  NO-UNDO.

    DEFINE BUFFER Issue       FOR Issue.
    DEFINE BUFFER Customer    FOR Customer.
    DEFINE BUFFER IssActivity FOR IssActivity.

    DEFINE VARIABLE li-TicketAmount LIKE Issue.TicketAmount NO-UNDO.
    DEFINE VARIABLE lc-Reference    LIKE Ticket.Reference NO-UNDO.

    IF pl-to = pl-from THEN RETURN.

    FIND Issue WHERE ROWID(Issue) = pr-rowid EXCLUSIVE-LOCK.
    
    /*
    ***
    *** Converting from a ticket to non ticket, issue has no
    *** activity so ignore
    ***
    */
    IF Issue.TicketAmount = 0 AND NOT pl-to THEN RETURN.
    
    FIND Customer WHERE Customer.CompanyCode = Issue.Companycode
        AND Customer.AccountNumber = Issue.AccountNumber
        EXCLUSIVE-LOCK.

    /*
    ***
    *** Moving to a ticket based issue
    ***
    */
    IF pl-to THEN
    DO:
        /*
        ***
        *** Sum up all activities
        ***
        */
        FOR EACH IssActivity OF Issue NO-LOCK:
            ASSIGN 
                li-TicketAmount = li-TicketAmount + IssActivity.Duration.
        END.
        IF li-TicketAmount = 0 THEN RETURN.

        ASSIGN
            lc-Reference    = "Issue Changed To Ticket"
            li-TicketAmount = li-TicketAmount * -1.

    END.
    /*
    ***
    *** From a ticket base issue to nonticket
    ***
    */ 
    ELSE
    DO:
        /*
        ***
        *** Need to reverse the ticket balance
        ***
        */
        ASSIGN 
            li-TicketAmount = Issue.TicketAmount 
            lc-reference    = "Issue Changed To Non-Ticket".
    END.

    EMPTY TEMP-TABLE tt-ticket.

    CREATE tt-ticket.
    ASSIGN
        tt-ticket.CompanyCode   = issue.CompanyCode
        tt-ticket.AccountNumber = issue.AccountNumber
        tt-ticket.Amount        = li-TicketAmount
        tt-ticket.CreateBy      = pc-LoginID
        tt-ticket.CreateDate    = TODAY
        tt-ticket.CreateTime    = TIME
        tt-ticket.IssueNumber   = Issue.IssueNumber
        tt-ticket.Reference     = lc-Reference
        tt-ticket.TickID        = ?
        tt-ticket.TxnDate       = TODAY
        tt-ticket.TxnTime       = TIME
        tt-ticket.TxnType       = "ADJ".


    RUN tlib-PostTicket.


    
END PROCEDURE.


PROCEDURE tlib-PostTicket :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    
    DEFINE BUFFER ticket   FOR ticket.
    DEFINE BUFFER customer FOR customer.
    DEFINE BUFFER Issue    FOR Issue.


    DEFINE VARIABLE lf-tickid LIKE ticket.tickID NO-UNDO.

    SAVE-BLOCK:
    REPEAT TRANSACTION ON ERROR UNDO , LEAVE:

        FOR EACH tt-ticket EXCLUSIVE-LOCK:
                    
            FIND customer WHERE customer.companycode = tt-ticket.companycode
                AND customer.AccountNumber = tt-ticket.AccountNumber
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE customer THEN
            DO:
                MESSAGE PROGRAM-NAME(1) " Missing Account " tt-ticket.AccountNumber.
                NEXT.
            END.

            FIND LAST ticket NO-LOCK NO-ERROR.
            ASSIGN
                lf-TickID = IF AVAILABLE ticket THEN ticket.TickID + 1 ELSE 1.
            
            CREATE ticket.
            BUFFER-COPY 
                tt-ticket EXCEPT tt-ticket.TickID
                TO ticket
                ASSIGN 
                ticket.TickID = lf-TickID.

            
            ASSIGN
                Customer.TicketBalance = Customer.TicketBalance + ticket.Amount.

            IF tt-ticket.Issue > 0 THEN
            DO:
                FIND Issue WHERE Issue.companyCode = tt-ticket.CompanyCode
                    AND Issue.IssueNumber = tt-ticket.IssueNumber
                    EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE Issue
                    THEN ASSIGN Issue.TicketAmount = Issue.TicketAmount + ( ticket.Amount * -1 ).
            END.

            RELEASE ticket.
            RELEASE customer.
            DELETE tt-ticket.

        END.


        LEAVE.
    END.
END PROCEDURE.


