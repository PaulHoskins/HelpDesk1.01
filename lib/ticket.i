&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************

    Program:        lib/ticket.i
    
    Purpose:        Ticket Library
    
    Notes:
    
    
    When        Who         What
    16/07/2006  phoski      Initial   
***********************************************************************/


def temp-table tt-ticket    no-undo like ticket.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tlib-IssueChanged Include 
PROCEDURE tlib-IssueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pr-rowid        as rowid                no-undo.
    def input param pc-loginid      like webuser.loginid    no-undo.
    def input param pl-from         as log                  no-undo.
    def input param pl-to           as log                  no-undo.

    def buffer Issue        for Issue.
    def buffer Customer     for Customer.
    def buffer IssActivity  for IssActivity.

    def var li-TicketAmount like Issue.TicketAmount no-undo.
    def var lc-Reference    like Ticket.Reference   no-undo.

    if pl-to = pl-from then return.

    message program-name(1) " from = " pl-from " to = " pl-to.

    find Issue where rowid(Issue) = pr-rowid exclusive-lock.
    
    /*
    ***
    *** Converting from a ticket to non ticket, issue has no
    *** activity so ignore
    ***
    */
    if Issue.TicketAmount = 0 and not pl-to then return.
    
    find Customer where Customer.CompanyCode = Issue.Companycode
                    and Customer.AccountNumber = Issue.AccountNumber
                    exclusive-lock.

    /*
    ***
    *** Moving to a ticket based issue
    ***
    */
    if pl-to then
    do:
        /*
        ***
        *** Sum up all activities
        ***
        */
        for each IssActivity of Issue no-lock:
            assign li-TicketAmount = li-TicketAmount + IssActivity.Duration.
        end.
        if li-TicketAmount = 0 then return.

        assign
            lc-Reference    = "Issue Changed To Ticket"
            li-TicketAmount = li-TicketAmount * -1.

    end.
    /*
    ***
    *** From a ticket base issue to nonticket
    ***
    */ 
    else
    do:
        /*
        ***
        *** Need to reverse the ticket balance
        ***
        */
        assign 
            li-TicketAmount     = Issue.TicketAmount 
            lc-reference        = "Issue Changed To Non-Ticket".
    end.

    empty temp-table tt-ticket.

    create tt-ticket.
    assign
        tt-ticket.CompanyCode       =   issue.CompanyCode
        tt-ticket.AccountNumber     =   issue.AccountNumber
        tt-ticket.Amount            =   li-TicketAmount
        tt-ticket.CreateBy          =   pc-LoginID
        tt-ticket.CreateDate        =   today
        tt-ticket.CreateTime        =   time
        tt-ticket.IssueNumber       =   Issue.IssueNumber
        tt-ticket.Reference         =   lc-Reference
        tt-ticket.TickID            =   ?
        tt-ticket.TxnDate           =   today
        tt-ticket.TxnTime           =   time
        tt-ticket.TxnType           =   "ADJ".


    RUN tlib-PostTicket.


    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tlib-PostTicket Include 
PROCEDURE tlib-PostTicket :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def buffer ticket       for ticket.
    def buffer customer     for customer.
    def buffer Issue        for Issue.


    def var lf-tickid       like ticket.tickID  no-undo.

    SAVE-BLOCK:
    repeat transaction on error undo , leave:

        for each tt-ticket exclusive-lock:
                    
            find customer where customer.companycode = tt-ticket.companycode
                            and customer.AccountNumber = tt-ticket.AccountNumber
                            exclusive-lock no-error.
            if not avail customer then
            do:
                message program-name(1) " Missing Account " tt-ticket.AccountNumber.
                next.
            end.

            find last ticket no-lock no-error.
            assign
                lf-TickID = if avail ticket then ticket.TickID + 1 else 1.
            
            create ticket.
            buffer-copy 
                tt-ticket except tt-ticket.TickID
                to ticket
                    assign ticket.TickID = lf-TickID.

            
            assign
                Customer.TicketBalance = 
                Customer.TicketBalance + ticket.Amount.

            if tt-ticket.Issue > 0 then
            do:
                find Issue where Issue.companyCode = tt-ticket.CompanyCode
                             and Issue.IssueNumber = tt-ticket.IssueNumber
                             exclusive-lock no-error.
                if avail Issue
                then assign Issue.TicketAmount = Issue.TicketAmount + ( ticket.Amount * -1 ).
            end.

            release ticket.
            release customer.
            delete tt-ticket.

        end.


        leave.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

