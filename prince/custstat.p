&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        prince/custstat.p
    
    Purpose:        Customer Statement PDF   
    
    Notes:
    
    
    When        Who         What
    26/07/2006  phoski      Initial
***********************************************************************/
                                          
{lib/htmlib.i}
{lib/princexml.i}

&IF DEFINED(UIB_is_Running) EQ 0 &THEN

def input param pc-user             as char no-undo.
def input param pc-CompanyCode      as char no-undo.
def input param pc-AccountNumber    as char no-undo.
def input param pd-lodate           as date no-undo.
def input param pd-hidate           as date no-undo.
def output param pc-pdf            as char no-undo.

&ELSE

def var pc-user                    as char no-undo.
def var pc-CompanyCode             as char no-undo.
def var pc-AccountNumber           as char no-undo.
def var pd-lodate                   as date no-undo.
def var pd-hidate                    as date no-undo.
def var pc-pdf                     as char no-undo.

assign pc-CompanyCode = "OURITDEPT"
       pd-lodate        = today - 100
       pd-hidate        = today
       pc-AccountNumber = "9999".

&ENDIF


{iss/issue.i}

def var ld-lo-date      as date     no-undo.
def var ld-hi-date      as date     no-undo.

def var lc-html         as char     no-undo.
def var lc-pdf          as char     no-undo.
def var ll-ok           as log      no-undo.
def var li-ReportNumber as int      no-undo.

def buffer Customer     for Customer.
def buffer Company      for Company.

def buffer Issue        for Issue.

def temp-table tt       no-undo like Issue
    field udf-Close         as date format '99/99/9999'
    field udf-By            as char
    field udf-prev-period   as int
    field udf-this-period   as int
        .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnUserName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUserName Procedure 
FUNCTION fnUserName RETURNS CHARACTER
  ( pc-LoginID  as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

assign
    ld-hi-date = pd-hidate
    ld-lo-date = pd-lodate.

assign
    pc-pdf = ?
    li-ReportNumber = next-value(ReportNumber).
assign 
    lc-html = session:temp-dir + caps(pc-CompanyCode) + "-Statement-" + string(li-ReportNumber).

assign 
    lc-pdf = lc-html + ".pdf"
    lc-html = lc-html + ".html".

os-delete value(lc-pdf) no-error.
os-delete value(lc-html) no-error.

find Customer 
    where customer.CompanyCode = pc-companyCode
      and customer.AccountNumber = pc-AccountNumber no-lock no-error.
find Company
        where Company.CompanyCode = pc-companyCode no-lock no-error.


RUN ip-BuildIssueData.

dynamic-function("pxml-Initialise").

create tt-pxml.
assign 
    tt-pxml.PageOrientation = "PORTRAIT".

dynamic-function("pxml-OpenStream",lc-html).

dynamic-function("pxml-StandardHTMLBegin").

dynamic-function("pxml-DocumentStyleSheet","statement",pc-companyCode).
dynamic-function("pxml-PrePrintFooter",pc-companyCode).

dynamic-function("pxml-StandardBody").

RUN ip-Print.

dynamic-function("pxml-Footer",pc-CompanyCode).
dynamic-function("pxml-CloseStream").


ll-ok = dynamic-function("pxml-Convert",lc-html,lc-pdf).

if ll-ok
then assign pc-pdf = lc-pdf.
    
&IF DEFINED(UIB_is_Running) ne 0 &THEN

    os-command silent start value(lc-pdf).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-BuildIssueData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildIssueData Procedure 
PROCEDURE ip-BuildIssueData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer Issue    for Issue.
    def buffer Ticket   for Ticket.

    def var ld-CloseDate        as date     no-undo.
    def var lc-By               as char     no-undo.

    for each issue no-lock
        where issue.CompanyCode = pc-companyCode
          and issue.AccountNumber = pc-AccountNumber
          and issue.IssueDate <= ld-hi-date
          :

        /*
        ***
        *** If the job is completed then ignore if outside period if
        *** there are no ticket transactions in the period
        ***
        ***
        */
        if dynamic-function("islib-IssueIsOpen",rowid(Issue)) = false then
        do:
            assign
                ld-CloseDate = dynamic-function("islib-CloseDate",rowid(Issue)).
            if ld-CloseDate < ld-lo-Date 
            or ld-CloseDate = ? then 
            do:
                if not 
                    can-find(first ticket
                             where ticket.CompanyCode = pc-CompanyCode
                               and ticket.IssueNumber = issue.IssueNumber
                               and ticket.TxnDate >= ld-lo-date
                               and ticket.TxnDate <= ld-hi-date
                               no-lock) then next.
                
            end.

            find first IssStatus of Issue no-lock no-error.
            if avail issStatus
            then assign lc-By = issStatus.LoginId.
            
        end.
        else assign ld-CloseDate = ?
                    lc-by = "".

        create tt.
        buffer-copy Issue to tt.

        assign
            tt.udf-Close = ld-CloseDate
            tt.udf-by    = lc-By.

        for each ticket no-lock
                 where ticket.CompanyCode = pc-CompanyCode
                   and ticket.IssueNumber = issue.IssueNumber
                   and ticket.TxnDate <= ld-hi-date:

            if ticket.TxnDate < ld-lo-date
            then assign
                        tt.udf-prev-period = tt.udf-prev-period + ( ticket.Amount * -1 ).
            else assign 
                        tt.udf-this-period = tt.udf-this-period + ( ticket.Amount * -1 ).

        end.

    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CompanyInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CompanyInfo Procedure 
PROCEDURE ip-CompanyInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&prince}
        '<table class="info">' skip.
        

    {&prince} '<tr><th style="text-align: right;">From:</th><td>' dynamic-function("pxml-Safe",Company.Name) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Company.Address1) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Company.Address2) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Company.City) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Company.County) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Company.Country) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Company.PostCode) '</td></tr>' skip.

    RUN ip-InfoBanner.

    {&prince} '</table>'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CustomerAddress) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CustomerAddress Procedure 
PROCEDURE ip-CustomerAddress :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&prince}
        '<table class="info">' skip.
        

    {&prince} '<tr><th style="text-align: right;">To:</th><td>' dynamic-function("pxml-Safe",Customer.Name) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Customer.Address1) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Customer.Address2) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Customer.City) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Customer.County) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Customer.Country) '</td></tr>' skip.
    {&prince} '<tr><td>&nbsp;</td><td>' dynamic-function("pxml-Safe",Customer.PostCode) '</td></tr>' skip.

    {&prince} '</table>'.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Header) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Header Procedure 
PROCEDURE ip-Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var lc-logo as char         no-undo.

    assign
        lc-logo = dynamic-function("pxml-FileNameLogo",pc-CompanyCode).

    
    {&prince} '<div class="heading">' skip.


    {&prince}
        '<p style="font-size: 20px; font-weight: 900; text-align: center; margin-top: 10px; margin-bottom: 10px;">'
            'HelpDesk Statement' skip.

    /*
    if lc-logo <> ?
    then {&prince} 
            '<img src="' lc-logo '" style="clear: left; float: right; margin-top: 10px; margin-right: 10px;">' skip. 
    */
    {&prince}
        '</p>' skip.

    
    {&prince}
        '<table class="address" width=100%>'
            '<tr>'
                '<td style="width: 350px;">' skip.
    

    RUN ip-CustomerAddress.

    
    {&prince}
                '</td>'
                '<td>' skip.
    

    RUN ip-CompanyInfo.

    {&prince}
            '</td>'
            '</tr>'


        '</table>' skip.

      
    
    {&prince} 
        '</div>'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-InfoBanner) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-InfoBanner Procedure 
PROCEDURE ip-InfoBanner :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    {&prince}
        
        '<tr>'
            '<th style="text-align: right;">Page Number:</th>'
                '<td>' '<span id="thepage">&nbsp;</span>'
                    '</td>'
        '</tr>'
        '<tr>'
            '<th style="text-align: right;">Period Covered:</th>'
            '<td>' string(ld-lo-date,'99/99/9999') ' - ' string(ld-hi-date,'99/99/9999') '</td>'
        '</tr>'
        .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Print) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Print Procedure 
PROCEDURE ip-Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    
    RUN ip-Header.

    {&prince} '<div id="content">'.


    RUN ip-StatementDetails.

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-StatementDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-StatementDetails Procedure 
PROCEDURE ip-StatementDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer webIssArea   for webIssArea.
    def buffer Ticket       for Ticket.

    def var lc-Area         as char no-undo.

    def var li-prev-period  as int  no-undo.
    def var li-this-period  as int  no-undo.
    def var ll-HasTicket    as log  no-undo.
    def var li-TicketNew    as int  no-undo.
    def var li-TicketPrev   as int  no-undo.
    def var ll-TickCols     as log  no-undo.
    def var li-Activity     as int  no-undo.
    def var lc-td           as char no-undo.
    def var ll-fact         as log  no-undo.
    
    assign
        ll-TickCols = customer.SupportTicket <> "NONE".

    for each tt no-lock:
        if tt.ticket
        then assign ll-TickCols = true.
    end.

    {&prince}
        '<table class="landrep">'
            '<thead>'
                '<tr>'
                    '<th style="text-align: right;">Issue</th>'
                    '<th>Description</th>'
                    '<th>Area</th>'
                    '<th>Opened</th>'
                    '<th>By</th>'
                    '<th>Closed</th>'
                    '<th>By</th>'.

    if ll-TickCols
    then {&prince}
                    '<th style="text-align: right;">Ticket<br/>Previous Periods</th>'
                    '<th style="text-align: right;">Ticket<br/>This Period</th>'
                    '<th style="text-align: right;">Ticket<br/>Total</th>'.

    {&prince}
                    
                '</tr>' skip
            '</thead>' skip
            '<tbody>' skip.

    
    for each tt no-lock
        by tt.IssueNumber:

        if tt.ticket
        then assign ll-HasTicket = true.

        assign
            lc-Area = "&nbsp;".
        if tt.AreaCode <> "" then
        do:

            find WebIssArea
                where WebIssArea.CompanyCode = tt.CompanyCode
                  and WebIssArea.AreaCode    = tt.AreaCode
                  no-lock no-error.

            if avail WebIssArea
            then assign lc-Area = dynamic-function("pxml-safe",WebIssArea.description).
        end.
        {&prince}
            '<tr>' 
                '<td style="text-align: right;">' tt.IssueNumber '</td>' skip
                '<td>' dynamic-function("pxml-safe",tt.BriefDescription) '</td>'
                '<td>' lc-Area '</td>'
                '<td>' string(tt.IssueDate,"99/99/9999") '</td>'
                '<td>' fnUserName(tt.RaisedLoginID) '</td>'
                '<td>' if tt.udf-Close = ? then "&nbsp;" 
                       else string(tt.udf-Close,'99/99/9999') '</td>'
                '<td>' fnUserName(tt.udf-By) '</td>'.

        
        if ll-TickCols
        then {&prince}
                '<td style="text-align: right;">' if tt.Ticket
                       then dynamic-function("com-TimeToString",
                                             tt.udf-prev-period)
                       else '&nbsp;' '</td>' 
                '<td style="text-align: right;">' if tt.Ticket
                       then dynamic-function("com-TimeToString",
                                             tt.udf-this-period)
                       else '&nbsp;' '</td>' 
                '<td style="text-align: right;">' if tt.Ticket
                       then dynamic-function("com-TimeToString",
                                             tt.udf-this-period + tt.udf-prev-period)
                       else '&nbsp;' '</td>'.

        {&prince}
            '</tr>' skip.

        assign 
            li-prev-period = li-prev-period + tt.udf-prev-period
            li-this-period = li-this-period + tt.udf-this-period.

        if Customer.ViewAction and 
        can-find(first IssAction no-lock
                 where IssAction.CompanyCode = Customer.CompanyCode
                   and IssAction.IssueNumber = tt.IssueNumber
                   and IssAction.CustomerView = true) then
        do:
            {&prince} '<tr><td>&nbsp;</td><td style="column-span: 6;">'.
            
            
            {&prince} skip(2)
                '<table class="action">'
                    '<thead>'
                    '<tr>'
                        '<th>Action</th>'
                        '<th>Details</th>'
                        '<th>Assigned To</th>'.

            if Customer.ViewActivity then
            do:
                {&prince}
                    '<th>Activity</th>'
                    '<th>Details</th>'
                    '<th>Site Visit?</th>'
                    '<th>By</th>'.
            end.
            {&prince}
                '</thead>'
                '</tr>'
                '<tbody>' skip.

            for each IssAction no-lock
                 where IssAction.CompanyCode = Customer.CompanyCode
                   and IssAction.IssueNumber = tt.IssueNumber
                   and IssAction.CustomerView = true
                   by IssAction.ActionDate 
                     by IssAction.CreateDate 
                     by IssAction.CreateTime:


                assign li-activity = 0.
                if Customer.ViewActivity then
                for each IssActivity no-lock
                   where issActivity.CompanyCode = IssAction.CompanyCode
                     and issActivity.IssueNumber = IssAction.IssueNumber
                     and IssActivity.IssActionId = IssAction.IssActionID
                     and IssActivity.CustomerView
                     :
                    li-activity = li-activity + 1.
    
                end.
                if li-activity <= 1
                then lc-td = '<td>'.
                else lc-td = '<td style="row-span: ' + string(li-activity) + ';">'.

                find WebAction 
                    where WebAction.ActionID = issAction.ActionID
                    no-lock no-error.

       

                {&prince}
                    '<tr>'
                        lc-td string(issAction.ActionDate,"99/99/9999") '</td>'
                        lc-td dynamic-function("pxml-safe",WebAction.Description).

                if IssAction.Notes <> ""
                then {&prince} 
                            '<br />'
                            replace(dynamic-function("pxml-safe",IssAction.Notes),"~n","<br />").
                            
                {&prince} 
                    '</td>'
                    lc-td
                        dynamic-function("pxml-safe",dynamic-function("com-UserName",IssAction.AssignTo))
                    '</td>'.

                assign
                    ll-fact = true.

                if Customer.ViewActivity then
                for each IssActivity no-lock
                   where issActivity.CompanyCode = IssAction.CompanyCode
                     and issActivity.IssueNumber = IssAction.IssueNumber
                     and IssActivity.IssActionId = IssAction.IssActionID
                     and IssActivity.CustomerView
                     by IssActivity.ActDate 
                    by IssActivity.CreateDate 
                    by IssActivity.CreateTime:

                    if not ll-fact then
                    do:
                        {&prince} '<tr>' skip.
                    end.

                    {&prince} 
                        '<td>' string(IssActivity.ActDate,"99/99/9999") '</td>'
                        '<td>' dynamic-function("pxml-safe",IssActivity.Description).
                    
                    if IssActivity.Notes <> ""
                    then {&prince} 
                                '<br />'
                                replace(dynamic-function("pxml-safe",IssActivity.Notes),"~n","<br />").

                    {&prince} '</td>'
                        '<td>' if IssActivity.SiteVisit then "Yes" else "&nbsp;" '</td>'
                        '<td>' dynamic-function("pxml-safe",
                               dynamic-function("com-UserName",IssActivity.ActivityBy))
                            '</td>'.

                    {&prince} '</tr>' skip.
                    ll-fact = false.

                end.
                {&prince} '</tr>'.
            end.

            {&prince} '</tbody></table>'.



            /* end of td */
            
            {&prince} '</td>' skip.

            if ll-tickCols 
            then {&prince} '<td column-span: 3;">&nbsp;</td>'.

            {&prince} '</tr>'.
        end.

    end.

    if ll-HasTicket then
    do:
        {&prince}
            '<tr>'
                '<th style="text-align: right; column-span: 7; border-top: 1px solid black;">Total:</th>' 
                '<th style="text-align: right; border-top: 1px solid black;">' dynamic-function("com-TimeToString",li-prev-period) '</th>' 
                '<th style="text-align: right; border-top: 1px solid black;">' dynamic-function("com-TimeToString",li-this-period) '</th>' 
                '<th style="text-align: right; border-top: 1px solid black;">' dynamic-function("com-TimeToString",li-this-period + li-prev-period) '</th>' 
            '</tr>' skip.

    end.

    {&prince}
        '</tbody></table>'.

    for each ticket no-lock
                 where ticket.CompanyCode = pc-CompanyCode
                   and ticket.AccountNumber = pc-AccountNumber
                   and ticket.TxnDate <= ld-hi-date
                   and ticket.TxnType = "TCK":

        /*
        ***
        *** New Ticket in this period
        ***
        */
        if ticket.TxnDate >= ld-lo-date and ticket.TxnType = "TCK" 
        then assign li-TicketNew = li-TicketNew + ticket.Amount.

        /*
        ***
        *** Bfwd balance
        ***
        */
        if ticket.TxnDate < ld-lo-date 
        then assign li-TicketPrev = li-TicketPrev + ticket.Amount. 

        
    end.

    /*
    ***
    *** For ticket customers show bfwd figures
    ***
    */
    if ll-TickCols then
    do:
        {&prince}
        '<br/>'
        '<span class="total">'
        '<table class="ticket">'
            '<thead>'
                '<tr>'
                    '<th style="text-align: center; column-span: 4;">Ticket Balance</th>'
                   
                    
                '</tr>' skip
                '<tr>'
                    '<th style="text-align: right;">Hours Brought Forward</th>'
                    '<th style="text-align: right;">Hours Purchased In Period</th>'
                    '<th style="text-align: right;">Hours Used In Period</th>'
                    '<th style="text-align: right;">Hours Carried Forward</th>'
                    
                '</tr>' skip
            '</thead>' skip
            '<tbody>' skip.

        {&prince}
            '<tr>' skip
                '<td style="text-align: right;">' dynamic-function("com-TimeToString",li-TicketPrev) '</td>' 
                '<td style="text-align: right;">' dynamic-function("com-TimeToString",li-TicketNew) '</td>' 
                '<td style="text-align: right;">' dynamic-function("com-TimeToString",li-this-period + li-prev-period) '</td>' 
                '<td style="text-align: right;">' dynamic-function("com-TimeToString",( li-TicketPrev + li-TicketNew)
                                                                                      - ( li-this-period + li-prev-period)) '</td>' 



            '</tr>' skip.

        {&prince}
            '</tbody></table>'.

        {&prince}
            '</span>'.

        
    end.


    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnUserName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUserName Procedure 
FUNCTION fnUserName RETURNS CHARACTER
  ( pc-LoginID  as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer webUser for webUser.
 
    find webUser
            where webuser.LoginID = pc-LoginID no-lock no-error.

    if avail webUser 
    then return dynamic-function("pxml-safe",webUser.Name).
    else return "&nbsp;".




END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

