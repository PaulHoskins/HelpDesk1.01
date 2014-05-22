&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


{lib/htmlib.i}
{lib/pdf_inc.i}
{lib/pdf_rep.i}

&IF DEFINED(UIB_is_Running) EQ 0 &THEN

def input param pc-Account          as char no-undo.
def input param pc-Status           as char no-undo.
def input param pc-Assign           as char no-undo.
def input param pc-Area             as char no-undo.
def input param pc-user             as char no-undo.
def output param pc-file            as char no-undo.

&ELSE

def var pc-Account                  as char no-undo.
def var pc-Status                   as char no-undo.
def var pc-Assign                   as char no-undo.
def var pc-Area                     as char no-undo.
def var pc-user                     as char no-undo.
def var pc-file                     as char no-undo.

assign pc-Account   = htmlib-Null()
       pc-status = htmlib-Null()
       pc-assign = htmlib-Null()
       pc-Area   = htmlib-Null()
       pc-user   = 'phoskins'.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-CheckPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CheckPage Procedure 
FUNCTION CheckPage RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

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
   Other Settings: CODE-ONLY
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


RUN ip-StatusType ( output lc-open-status , output lc-closed-status ).

RUN ip-SetRanges.

assign pc-file = replib-FileName().

os-delete value(pc-file) no-error.

RUN pdf_new ("Spdf",pc-file).

RUN pdf_set_Orientation ("Spdf","Landscape").
RUN pdf_set_PaperType ("Spdf","A4").

run replib-NewPage("Micar Computer Systems","Issue Report",
                   input-output li-current-page).
RUN ip-PrintRange.

RUN ip-ReportHeading.

RUN ip-Print.

RUN pdf_set_font ("Spdf","Times-Bold",10.0).
do li-count = 1 to 20:
    run pdf_skip("Spdf").
end.
run pdf_text_at ( "Spdf", "End of report",140).


RUN pdf_close("Spdf").

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

def buffer b-note for IssNote.
def buffer b-cust for Customer.
def buffer b-assign for WebUser.


def var lc-customer as char no-undo.
def var lc-assign   as char no-undo.
def var li-line     as int  no-undo.

open query q for each b-query no-lock
        where b-query.AccountNumber >= lc-acc-lo
          and b-query.AccountNumber <= lc-acc-hi
          and b-query.AssignTo >= lc-ass-lo
          and b-query.AssignTo <= lc-ass-hi
          and b-query.AreaCode >= lc-area-lo
          and b-query.AreaCode <= lc-area-hi
          and can-do(lc-srch-status,b-query.StatusCode)
          by b-query.IssueNumber.

get first q no-lock.
repeat while avail b-query:

    find b-status where b-status.StatusCode = 
                        b-query.StatusCode no-lock no-error.
    if avail b-status then
    do:
        assign lc-status = b-status.Description.
        if b-status.CompletedStatus
        then lc-status = lc-status + ' (closed)'.
        else lc-status = lc-status + ' (open)'.
    end.
    else lc-status = "".

    find b-area where b-area.AreaCode = b-query.AreaCode 
         no-lock no-error.
    assign lc-area = if avail b-area 
                     then b-area.Description else "".

    find b-cust where b-cust.AccountNumber = b-query.AccountNumber no-lock 
                no-error.
    assign lc-customer = if avail b-cust
                        then b-cust.name else "Missing".
    
    find b-assign where b-assign.loginid = b-query.AssignTo no-lock no-error.
    assign lc-assign = if avail b-assign then b-assign.Name
                       else "".
    CheckPage().


    RUN pdf_set_font ("Spdf","Times-Bold",10.0).
    run pdf_text_at ( "Spdf", '      Issue: ' + string(b-Query.IssueNumber)
                      ,1).
    run pdf_text_at ( "Spdf", b-Query.BriefDescription,30).


    run pdf_text_at ( "Spdf", 'Date: ' + string(b-Query.IssueDate,'99/99/9999'),
                      120).
    
    run pdf_text_at ( "Spdf", 'Status: ' + lc-status,
                      150).

    run pdf_text_at ( "Spdf", 'Area: ' + lc-area,
                      240).
    run pdf_skip("Spdf").
    
    do li-loop = 1 to num-entries(b-Query.LongDescription,'~n'):
        CheckPage().
        RUN pdf_set_font ("Spdf","Times-Roman",10.0).
        assign lc-char = entry(li-loop,b-Query.LongDescription,'~n').
        RUN pdf_text_at  ("Spdf", lc-char,30).
        run pdf_skip("Spdf").
    end.

    CheckPage().
    RUN pdf_set_font ("Spdf","Times-Roman",10.0).
    run pdf_text_at ( "Spdf", 'Customer: ' + lc-customer
                              ,1).
    run pdf_text_at ( "Spdf", 'Assigned: ' + lc-assign,
                      114).
    run pdf_skip("Spdf").

    for each tt exclusive-lock:
        delete tt.
    end.

    assign li-line = 0.

    for each b-note no-lock 
        where b-note.IssueNumber = b-Query.IssueNumber 
        by b-note.CreateDate desc
        by b-note.CreateTime desc
           
        :
        
        find b-user where b-user.loginid = b-note.Loginid no-lock no-error.

        assign li-line = li-line + 1.
        create tt.
        assign tt.lineno = li-line
               tt.n-date = b-note.CreateDate
               tt.n-time = b-note.CreateTime
               tt.n-user = if avail b-user 
                           then b-user.name else ""
               tt.n-contents = entry(1,b-note.contents,'~n').
            .
        if num-entries(b-note.contents,'~n') > 1 then
        do li-loop = 2 to num-entries(b-note.contents,'~n'):
            if trim(entry(li-loop,b-note.contents,'~n')) = '' then next.
            assign li-line = li-line + 1.
            create tt.
            assign tt.lineno = li-line
                   tt.n-contents = entry(li-loop,b-note.contents,'~n').

        end.
    end.

    for each IssStatus no-lock
        where IssStatus.IssueNumber = b-query.IssueNumber
           by IssStatus.ChangeDate desc
           by IssStatus.ChangeTime desc:

        find b-user where b-user.Loginid = IssStatus.LoginId no-lock no-error.
        find b-status where b-status.StatusCode = IssStatus.NewStatusCode
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
        CheckPage().
        RUN pdf_set_font ("Spdf","Times-Bold",10.0).
        run pdf_text_at ( "Spdf","Notes",1).
        run pdf_text_at ( "Spdf","Status Changes",175).
        run pdf_skip ("Spdf").
        CheckPage().
        RUN pdf_set_font ("Spdf","Times-Roman",10.0).
        run pdf_text_at ( "Spdf","Date",1).
        run pdf_text_at ( "Spdf","User",38).
        run pdf_text_at ( "Spdf","Details",65).

        run pdf_text_at ("Spdf","Date",175).
        run pdf_text_at ("Spdf","User",212).
        run pdf_text_at ("Spdf","Status",240).

        run pdf_skip ("Spdf").

        for each tt:
            CheckPage().
            if tt.n-date <> ?
            or tt.n-contents <> "" then
            do:
                if tt.n-date <> ? 
                then run pdf_text_at("Spdf",string(tt.n-date,'99/99/9999') 
                                     + ' ' + string(tt.n-time,'hh:mm am'),1).
            end.
            run pdf_text_at ("Spdf", tt.n-user,38).
            run pdf_text_at ("Spdf", tt.n-contents,65).

            if tt.s-date <> ? then
            do:
                run pdf_text_at("Spdf",string(tt.s-date,'99/99/9999') 
                                     + ' ' + string(tt.s-time,'hh:mm am'),175).
            end.
            run pdf_text_at("Spdf",tt.s-user,212).
            run pdf_text_at("Spdf",tt.s-status,240).
            run pdf_Skip("Spdf").
        end.
        
    end.

   
    RUN pdf_set_dash ("Spdf",1,0).
    RUN pdf_line  ("Spdf", pdf_LeftMargin("Spdf"), pdf_TextY("Spdf") + 5, pdf_PageWidth("Spdf") - 20 , pdf_TextY("Spdf") + 5, 2).
    RUN pdf_skip ("Spdf").

    get next q no-lock.

    if avail b-query then
    do:
        if not CheckPage()
        then run pdf_skip("Spdf").
    end.
    
end.

do while true:
    run pdf_skip("Spdf").
    RUN pdf_text_at  ("Spdf", fill(" ",60),1).
    if CheckPage() then leave.
    
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
    RUN pdf_set_font ("Spdf","Times-Bold",12.0).
    run pdf_text_at ( "Spdf", "Report Criteria",30).
    run pdf_skip("Spdf").
    RUN pdf_text_at  ("Spdf", "Account:",30).
    run pdf_text_at  ("Spdf",lc-Account,50).
    run pdf_skip("Spdf").
    RUN pdf_text_at  ("Spdf", "Status:",34).
    run pdf_text_at  ("Spdf",lc-Status,50).
    run pdf_skip("Spdf").
    RUN pdf_text_at  ("Spdf", "Area:",36).
    run pdf_text_at  ("Spdf",lc-Area,50).
    run pdf_skip("Spdf").
    RUN pdf_text_at  ("Spdf", "Assigned To:",23).
    run pdf_text_at  ("Spdf",lc-assign,50).
    run pdf_skip("Spdf").
    run pdf_skip("Spdf").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ReportHeading) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ReportHeading Procedure 
PROCEDURE ip-ReportHeading :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    return.

    
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

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-CheckPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CheckPage Procedure 
FUNCTION CheckPage RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    def var ll-skip as log no-undo.
    
    
    assign li-current-y = pdf_textY("Spdf")
           ll-skip      = false.
    if li-current-y <= li-max-y then 
    do:
        run replib-NewPage("Micar Computer Systems","Issue Report",
                  input-output li-current-page).
        RUN ip-ReportHeading.
        assign ll-skip = true.
    end.
    RETURN ll-skip.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

