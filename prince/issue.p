&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/issue.p
    
    Purpose:        Issue PDF Report     
    
    Notes:
    
    
    When        Who         What
    11/04/2006  phoski      Initial - replace old version      
    
    14/09/2010  DJS         3708 Additional changes for date selection
***********************************************************************/
                                          
{lib/htmlib.i}
{lib/princexml.i}


&IF DEFINED(UIB_is_Running) EQ 0 &THEN

def input param pc-CompanyCode      as char no-undo.
def input param pc-Account          as char no-undo.
def input param pc-Status           as char no-undo.
def input param pc-Assign           as char no-undo.
def input param pc-Area             as char no-undo.
def input param pc-user             as char no-undo.
def input param pc-category         as char no-undo.
def input param pc-lodate           as char no-undo.  /* 3708  */
def input param pc-hidate           as char no-undo.  /* 3708  */
def output param pc-pdf             as char no-undo.

&ELSE

def var pc-CompanyCode              as char no-undo.
def var pc-Account                  as char no-undo.
def var pc-Status                   as char no-undo.
def var pc-Assign                   as char no-undo.
def var pc-Area                     as char no-undo.
def var pc-user                     as char no-undo.
def var pc-category                 as char no-undo.
def var pc-lodate                   as char no-undo.     /* 3708  */  
def var pc-hidate                   as char no-undo.     /* 3708  */  
def var pc-pdf                     as char no-undo.

assign pc-Account   = htmlib-Null()
       pc-status = htmlib-Null()
       pc-assign = htmlib-Null()
       pc-Area   = htmlib-Null()
       pc-user   = 'phoski'
       pc-category = htmlib-Null()
       pc-CompanyCode = "MICAR"
       pc-lodate  = string(today - 30 )       /* 3708  */  
       pc-hidate  = string(today)             /* 3708  */  
  .

&ENDIF


def temp-table tt no-undo
    field lineno        as int
    field n-date        as date
    field n-time        as int
    field n-user        as char
    field n-contents    as char
    field s-date        as date
    field s-time        as int
    field s-user        as char
    field s-status      as char
    index lineno
            lineno.

def buffer  WebUser     for WebUser.
def buffer  b-query     for Issue.
def buffer  b-status    for WebStatus.
def buffer  b-area      for WebIssArea.
def buffer  b-user      for WebUser.

def query q for b-query scrolling.


def var lc-pdf-file     as char no-undo.
def var li-current-y    as int no-undo.
def var li-max-y        as int initial 50 no-undo.
def var li-current-page as int no-undo.

def var lc-status       as char no-undo.
def var lc-area         as char no-undo.

def var lc-open-status  as char no-undo.
def var lc-closed-status as char no-undo.
def var lc-acc-lo       as char no-undo.
def var lc-acc-hi       as char no-undo.
def var lc-ass-lo       as char no-undo.
def var lc-ass-hi       as char no-undo.
def var lc-area-lo      as char no-undo.
def var lc-area-hi      as char no-undo.
def var lc-srch-status  as char no-undo.
def var li-loop         as int no-undo.
def var lc-char         as char no-undo.
def var li-count        as int  no-undo.
def var lc-cat-lo       as char no-undo.
def var lc-cat-hi       as char no-undo.
def var lc-date-lo      as char no-undo.        /* 3708  */  
def var lc-date-hi      as char no-undo.        /* 3708  */  

def var lc-html         as char     no-undo.
def var lc-pdf          as char     no-undo.
def var ll-ok           as log      no-undo.
def var li-ReportNumber as int      no-undo.
def var ll-customer     as log      no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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


find WebUser where WebUser.LoginID = pc-user no-lock no-error.
assign
    ll-customer = WebUser.UserClass = "CUSTOMER".

RUN ip-StatusType ( output lc-open-status , output lc-closed-status ).

RUN ip-SetRanges.

assign
    pc-pdf = ?
    li-ReportNumber = next-value(ReportNumber).
assign 
    lc-html = session:temp-dir + caps(pc-CompanyCode) + "-IssueReport-" + string(li-ReportNumber).

assign 
    lc-pdf = lc-html + ".pdf"
    lc-html = lc-html + ".html".

os-delete value(lc-pdf) no-error.
os-delete value(lc-html) no-error.


dynamic-function("pxml-Initialise").

create tt-pxml.
assign 
    tt-pxml.PageOrientation = "LANDSCAPE".

dynamic-function("pxml-OpenStream",lc-html).
dynamic-function("pxml-Header", pc-CompanyCode).

RUN ip-Print.

dynamic-function("pxml-Footer",pc-CompanyCode).
dynamic-function("pxml-CloseStream").


ll-ok = dynamic-function("pxml-Convert",lc-html,lc-pdf).

if ll-ok
then assign pc-pdf = lc-pdf.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-Print) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Print Procedure 
PROCEDURE ip-Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def buffer IssNote for IssNote.
def buffer Customer for Customer.
def buffer b-assign for WebUser.


def var lc-customer as char no-undo.
def var lc-assign   as char no-undo.
def var li-line     as int  no-undo.

open query q for each b-query no-lock
        where b-query.CompanyCode = pc-CompanyCode
          and b-query.AccountNumber >= lc-acc-lo
          and b-query.AccountNumber <= lc-acc-hi
          and b-query.AssignTo >= lc-ass-lo
          and b-query.AssignTo <= lc-ass-hi
          and b-query.AreaCode >= lc-area-lo
          and b-query.AreaCode <= lc-area-hi
          and b-query.CatCode  >= lc-cat-lo
          and b-query.CatCode  <= lc-cat-hi
          and b-query.CreateDate  >= date(lc-date-lo)              /* 3708  */  
          and b-query.CreateDate  <= date(lc-date-hi)              /* 3708  */  
          and can-do(lc-srch-status,b-query.StatusCode)
          by b-query.IssueNumber.

get first q no-lock.
repeat while avail b-query:

    find b-status of b-query no-lock no-error.

    if avail b-status then
    do:
        assign lc-status = b-status.Description.
        if b-status.CompletedStatus
        then lc-status = lc-status + ' (closed)'.
        else lc-status = lc-status + ' (open)'.

        assign lc-status = pxml-safe(lc-status).
    end.
    else lc-status = "&nbsp;".

    find b-area of b-query no-lock no-error.
    assign lc-area = if avail b-area 
                     then pxml-safe(b-area.Description)
                     else "&nbsp;".

    find Customer of b-query no-lock 
                no-error.
    assign lc-customer = if avail Customer
                        then pxml-safe(Customer.name) else "Missing".
    
    find b-assign where b-assign.loginid = b-query.AssignTo no-lock no-error.
    assign lc-assign = if avail b-assign then pxml-safe(b-assign.Name)
                       else "".
    

    
    /*
    ***
    *** Header Here
    ***
    */

    {&prince}
        '<table class="hinfo">' skip
        '<thead><tr>' skip
            '<th>Issue Number:</th><td>' b-query.IssueNumber '</td>' skip
             '<th>Date:</th>' skip
            '<td>' string(b-query.Issuedate,'99/99/9999') '</td>' skip
            '<th>Status:</th><td>' lc-status '</td>' skip
            '<th>Area:</th><td>' lc-area '</td>' skip

        '</tr>' skip.
    {&prince}
        '<tr>'
            '<th>Customer:</th>'
            '<td>' lc-Customer '</td>' skip
            '<td colspan="4">' 
                replace(pxml-safe(b-query.BriefDescription + '~n' + b-query.longdescription),'~n','<BR>')
            '</td>'
            '<th>Assigned:</th>'
            '<td>' lc-assign '</td>'
        '</tr></thead>' skip.      


    {&prince} '</table>'.
    empty temp-table tt.

    assign li-line = 0.

    for each IssNote no-lock of b-query
        by IssNote.CreateDate desc
        by IssNote.CreateTime desc
        :
        find webnote of IssNote no-lock no-error.
        if not avail webNote then next.
        if ll-customer and not WebNote.CustomerCanView then next.
        
        find b-user where b-user.loginid = IssNote.Loginid no-lock no-error.

        assign li-line = li-line + 1.
        create tt.
        assign tt.lineno = li-line
               tt.n-date = IssNote.CreateDate
               tt.n-time = IssNote.CreateTime
               tt.n-user = if avail b-user 
                           then b-user.name else ""
               tt.n-contents = IssNote.contents.
    end.

    for each IssStatus no-lock of b-query
            by IssStatus.ChangeDate desc
           by IssStatus.ChangeTime desc:

        find b-user where b-user.Loginid = IssStatus.LoginId no-lock no-error.
        find b-status where b-status.companyCode = b-query.CompanyCode
                        and b-status.StatusCode = IssStatus.NewStatusCode
             no-lock no-error.
        find first tt where tt.s-date = ? exclusive-lock no-error.
        if not avail tt then
        do:
            find last tt no-lock no-error.
            assign li-line = if avail tt then tt.lineno + 1
                               else 1.
            create tt.
            assign tt.lineno = li-line.
        end.
        assign tt.s-date = IssStatus.ChangeDate
               tt.s-time = IssStatus.ChangeTime
               tt.s-user = if avail b-user then b-user.name else ""
               tt.s-status = if avail b-status then b-status.description
                             else "".
    end.

    find first tt no-lock no-error.
    if avail tt then
    do:
        {&prince}
            '<table class="browse">' skip
            '<thead>' skip
            '<tr><th colspan="3" style="border-bottom: none;">Notes</th><th colspan="3" style="border-bottom: none;">Status Changes</th></tr>'
            '<tr><th>Date</th><th>User</th><th>Details</th><th>Date</th><th>User</th><th>Status</tr></thead>' skip.

        for each tt no-lock:
            {&prince}
                '<tr>'
                    '<td>'
                        if tt.n-date = ? then "&nbsp;" 
                        else string(tt.n-date,"99/99/9999") + "&nbsp;" + string(tt.n-time,"hh:mm am")
                    '</td>'
                    '<td>'
                        if tt.n-user = "" then "&nbsp;"
                        else pxml-safe(tt.n-user)
                    '</td>'
                    '<td>'
                        if tt.n-contents = "" then "&nbsp;"
                        else replace(pxml-safe(tt.n-contents),'~n','<BR>')
                    '</td>'

                    '<td>'
                        if tt.s-date = ? then "&nbsp;" 
                        else string(tt.s-date,"99/99/9999") + "&nbsp;" + string(tt.s-time,"hh:mm am")
                    '</td>'
                    '<td>'
                        if tt.s-user = "" then "&nbsp;"
                        else pxml-safe(tt.s-user)
                    '</td>'
                    '<td>'
                        if tt.s-status = "" then "&nbsp;"
                        else pxml-safe(tt.s-status)
                    '</td>'



                '</tr>' skip.


            
        end.

        {&prince} '</table>' skip.
        
    end.

    {&prince}
        '<br>' skip.
    
    get next q no-lock.

    
end.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-PrintRange) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-PrintRange Procedure 
PROCEDURE ip-PrintRange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var lc-account      as char no-undo.
    def var lc-status       as char no-undo.
    def var lc-area         as char no-undo.
    def var lc-assign       as char no-undo.

    def buffer b-cust for Customer.
    def buffer b-Status for WebStatus.
    def buffer b-Area   for WebIssArea.
    def buffer b-user   for WebUser.

    if pc-account = htmlib-Null()
    then assign lc-account = 'All'.
    else
    do:
        find b-cust where b-cust.AccountNumber = pc-account no-lock no-error.
        assign lc-account = if avail b-cust then b-cust.name else "".
    end.

    case pc-status:
        when 'allopen' then lc-status = 'Open'.
        when 'allclosed' then lc-status = 'Closed'.
        when htmlib-null() then lc-status = 'All'.
        otherwise
        do:
            find b-status where b-status.StatusCode = pc-status no-lock no-error.
            assign lc-status = if avail b-status
                               then b-status.Description else pc-status.
        end.
    end case.

    if pc-Area = htmlib-Null()
    then assign lc-area = 'All'.
    else
    do:
        find b-area where b-area.AreaCode = pc-Area no-lock no-error.
        assign lc-area = if avail b-area 
                         then b-area.Description else "".
    end.

    case pc-Assign:
        when 'NotAssigned' then lc-assign = 'Not Assigned'.
        when htmlib-Null() then lc-assign = 'All'.
        otherwise
        do:
            find b-user where b-user.LoginID = pc-assign no-lock no-error.
            assign lc-assign = if avail b-user then b-user.name else "".
        end.
    end case.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SetRanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SetRanges Procedure 
PROCEDURE ip-SetRanges :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if pc-account = htmlib-Null()
    then assign lc-acc-lo = ""
                lc-acc-hi = "ZZZZZZZZZZZZZZZZZZZZZZZZ".
    else assign lc-acc-lo = pc-account
                lc-acc-hi = pc-account.

    if ll-Customer
    then assign lc-acc-lo = webuser.AccountNumber
                lc-acc-hi = webUser.AccountNumber.

    if pc-status = htmlib-Null() 
    then assign lc-srch-status = "*".
    else
    if pc-status = "AllOpen" 
    then assign lc-srch-status = lc-open-status.
    else 
    if pc-status = "AllClosed"
    then assign lc-srch-status = lc-closed-status.
    else assign lc-srch-status = pc-status.

    
    if pc-assign = htmlib-null() 
    then assign lc-ass-lo = ""
                lc-ass-hi = "ZZZZZZZZZZZZZZZZ".
    else
    if pc-assign = "NotAssigned" 
    then assign lc-ass-lo = ""
                lc-ass-hi = "".
    else assign lc-ass-lo = pc-assign
                lc-ass-hi = pc-assign.

    if pc-area = htmlib-null() 
    then assign lc-area-lo = ""
                lc-area-hi = "ZZZZZZZZZZZZZZZZ".
    else
    if pc-area = "NotAssigned" 
    then assign lc-area-lo = ""
                lc-area-hi = "".
    else assign lc-area-lo = pc-area
                lc-area-hi = pc-area.

    if pc-category = htmlib-Null()
    then assign lc-cat-lo = ""
                lc-cat-hi = "zzzzzzzzzzzzzzz".
    else assign lc-cat-lo = pc-category
                lc-cat-hi = pc-category.

    if pc-lodate = htmlib-Null()                             /* 3708  */  
    then assign lc-date-lo = string(today - 365)             /* 3708  */  
                lc-date-hi = string(today).                  /* 3708  */  
    else assign lc-date-lo = pc-lodate                       /* 3708  */  
                lc-date-hi = pc-hidate.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-StatusType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-StatusType Procedure 
PROCEDURE ip-StatusType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param    pc-open-status      as char no-undo.
    def output param    pc-closed-status    as char no-undo.

    def buffer b-status for WebStatus.

    for each b-status no-lock:
        if b-status.CompletedStatus = false 
        then assign pc-open-status = trim(pc-open-status + ',' + b-status.StatusCode).
        else assign pc-closed-status = trim(pc-closed-status + ',' + b-status.StatusCode).
       
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

