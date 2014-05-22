&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************

    Program:        iss/issue.i
    
    Purpose:        Issue Library        
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      CompanyCode   
    11/04/2006  phoski      Customer Tracking   
    
    20/06/2011  DJS         Changed to send HTML email 
                              rather than attached PDF
***********************************************************************/

{lib/maillib.i}
{lib/princexml.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-AssignChanged Include 
FUNCTION islib-AssignChanged RETURNS LOGICAL
  ( pr-rowid    as rowid,
    pc-loginID    as char,
    pc-old-assign as char,
    pc-new-assign as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-CloseDate Include 
FUNCTION islib-CloseDate RETURNS DATE
 ( pr-rowid    as rowid)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-CloseOfIssue Include 
FUNCTION islib-CloseOfIssue RETURNS LOGICAL
  ( pc-LoginId as char ,
    pr-rowid as rowid )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-CreateAutoAction Include 
FUNCTION islib-CreateAutoAction RETURNS LOGICAL
  ( pf-IssActionID as dec )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-DefaultActions Include 
FUNCTION islib-DefaultActions RETURNS LOGICAL
  ( pc-companyCode  as char,
    pi-Issue        as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-IssueIsOpen Include 
FUNCTION islib-IssueIsOpen RETURNS LOGICAL
  ( pr-rowid    as rowid)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-OutsideSLA Include 
FUNCTION islib-OutsideSLA RETURNS LOGICAL
  ( pr-rowid    as rowid
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-RemoveAlerts Include 
FUNCTION islib-RemoveAlerts RETURNS LOGICAL
  ( pr-rowid as rowid )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-SLAChanged Include 
FUNCTION islib-SLAChanged RETURNS LOGICAL
  ( pr-rowid    as rowid,
    pc-loginID    as char,
    pf-old-SLAID as dec,
    pf-new-SLAID as dec )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-StatusIsClosed Include 
FUNCTION islib-StatusIsClosed RETURNS LOGICAL
  ( pc-CompanyCode as char,
    pc-StatusCode as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD islib-WhoToAlert Include 
FUNCTION islib-WhoToAlert RETURNS CHARACTER
  ( pc-CompanyCode      as char,
    pi-IssueNumber      as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE islib-CreateNote Include 
PROCEDURE islib-CreateNote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-CompanyCode  as char no-undo.
    def input param pi-IssueNumber  as int no-undo.
    def input param pc-user as char no-undo.
    def input param pc-code as char no-undo.
    def input param pc-note as char no-undo.

    def buffer b-status for IssNote.
    
    create b-status.
    assign b-status.CompanyCode = pc-CompanyCode
           b-status.IssueNumber = pi-IssueNumber
           b-status.LoginId     = pc-user
           b-status.CreateDate  = today
           b-status.CreateTime  = time
           b-status.NoteCode = pc-Code
           b-status.Contents = pc-note
           .
       
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE islib-StatusHistory Include 
PROCEDURE islib-StatusHistory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-CompanyCode      as char no-undo.
    def input param pi-IssueNumber      as int no-undo.
    def input param pc-user             as char no-undo.
    def input param pc-old-statuscode   as char no-undo.
    def input param pc-new-statuscode   as char no-undo.

    def buffer IssStatus    for IssStatus.
    def buffer Issue        for Issue.
    def buffer WebStatus    for WebStatus.
    def buffer WebNote      for WebNote.
    def buffer WebUser      for WebUser.
    def buffer Company      for Company.

    def var lc-loginid      as char no-undo.
        
    def var lc-text         as char     no-undo.
    def var lc-html         as char     no-undo.  /* Added for HTML emails */
    def var lc-header       as char     no-undo.  /* Added for HTML emails */

    create IssStatus.
    assign IssStatus.CompanyCode = pc-CompanyCode
           IssStatus.IssueNumber = pi-IssueNumber
           IssStatus.LoginId     = pc-user
           IssStatus.ChangeDate  = today
           IssStatus.ChangeTime  = time
           IssStatus.OldStatusCode = pc-old-StatusCode
           IssStatus.NewStatusCode = pc-new-StatusCode
           .

    find Issue
        where Issue.companycode = pc-CompanyCode
          and Issue.IssueNumber = pi-IssueNumber
          no-lock no-error.

    if avail issue then
    do:
        lc-loginid = DYNAMIC-FUNCTION('islib-WhoToAlert':U,Issue.CompanyCode,Issue.IssueNumber).
    end.


    if avail Issue
    and lc-loginid <> "" 
    and dynamic-function("com-StatusTrackIssue",pc-companycode,pc-new-StatusCode)
    and dynamic-function("com-UserTrackIssue",lc-loginID)
    and dynamic-function("com-IssueStatusAlert",pc-companyCode,issue.CreateSource,pc-new-StatusCode) then
    do:
        if can-find(WebNote
                    where WebNote.CompanyCode = pc-companyCode
                      and WebNote.NoteCode = "SYS.EMAILCUST" no-lock) then
        do:
            find WebUser 
                where webUser.LoginID = lc-loginID no-lock no-error.
            find company where company.CompanyCode = pc-companycode no-lock no-error.



            run prince/issstatusxml.p   /* Changed for HTML emails  - was  issstatus.p */
                (
                    pc-companyCode,
                    pi-IssueNumber,
                    "CUSTOMER",
                    output lc-text, /* Changed for HTML emails - was lc-pdf */
                    output lc-html  /* Added for HTML emails */
                    ).


            lc-header =  dynamic-function("pxml-Email-Header", pc-companycode).  /* Added for HTML emails */


            dynamic-function("mlib-SendMultipartEmail",
                  pc-companycode,
                  "",
                  if pc-old-StatusCode = ""
                  then "New Issue Raised " + string(pi-IssueNumber)
                  else "Status Change For Issue " + string(pi-IssueNumber)
                  ,
                  'Dear ' 
                  + trim(WebUser.ForeName)   
                  + ',~n~n' 
                  + 'Please find attached details of the issue you have logged with '
                  + company.name
                  + '.~n' 
                  + lc-text
                  ,
                  lc-header
                  + '<div id="content" style="border-top: 1px solid black;" ><br /><br /><br /><p>' 
                  + 'Dear ' 
                  + trim(WebUser.ForeName)   
                  + '</p><p>' 
                  + 'Please find attached details of the issue you have logged with '
                  + company.name 
                  + '<p/><br />' 
                  + lc-html
                  ,
                  WebUser.Email
                  ).
            
            
            
/*             if lc-pdf <> ? then                                                                              */
/*             do:                                                                                              */
/*                 dynamic-function("mlib-SendAttEmail",                                                        */
/*                     pc-companycode,                                                                          */
/*                     "",                                                                                      */
/*                     if pc-old-StatusCode = ""                                                                */
/*                     then "New Issue Raised " + string(pi-IssueNumber)                                        */
/*                     else "Status Change For Issue " + string(pi-IssueNumber),                                */
/*                     "Dear " + trim(WebUser.ForeName) +                                                       */
/*                     ",~n~n" +                                                                                */
/*                     "Please find attached details of the issue you have logged with " + company.name + ".~n" */
/*                     lc-pdf                                                                                   */
/*                         ,                                                                                    */
/*                     WebUser.Email,                                                                           */
/*                     "",                                                                                      */
/*                     "",                                                                                      */
/*                     ""  /* lc-pdf */                                                                         */
/*                     ).                                                                                       */

                RUN islib-CreateNote
                    ( pc-companyCode,
                      pi-IssueNumber,
                      pc-user,
                      "SYS.EMAILCUST",
                      "Status changed email sent to " + 
                      trim(webUser.ForeName + " " + webUser.Surname) + 
                      " at " + webuser.Email
                      ).
/*             end. */
        end.
    end.

    if islib-StatusIsClosed(pc-companyCode,pc-new-StatusCode) = true 
    and islib-StatusIsClosed(pc-companyCode,pc-old-statusCode) = false then
    do:
        DYNAMIC-FUNCTION('islib-CloseOfIssue':U,pc-user,rowid(Issue)).
    end.
    
    return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-AssignChanged Include 
FUNCTION islib-AssignChanged RETURNS LOGICAL
  ( pr-rowid    as rowid,
    pc-loginID    as char,
    pc-old-assign as char,
    pc-new-assign as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Issue for Issue.
    def var lc-message as char no-undo.

    if pc-old-assign = pc-new-assign then return true.

    find issue
        where rowid(issue) = pr-rowid no-lock no-error.

    if not avail issue then return false.


    if can-find(WebNote
                    where WebNote.CompanyCode = Issue.CompanyCode
                      and WebNote.NoteCode = "SYS.ASSIGN" no-lock) then
    do:
        
        RUN islib-CreateNote
                ( Issue.CompanyCode,
                  Issue.IssueNumber,
                  pc-LoginID,
                  "SYS.ASSIGN",
                  'From: ' + dynamic-function("com-UserName",pc-old-assign) + '~n' +
                  'To: ' + dynamic-function("com-UserName",pc-new-assign) + '~n'
                  ).
        
    end.



    return true.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-CloseDate Include 
FUNCTION islib-CloseDate RETURNS DATE
 ( pr-rowid    as rowid) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer issue        for issue.
    def buffer WebStatus    for WebStatus.
    def buffer IssStatus    for IssStatus.

    def var lc-return   as date no-undo.


    find issue
        where rowid(issue) = pr-rowid no-lock no-error.

    if not avail issue then return ?.

    find WebStatus of Issue no-lock no-error.

    if not avail WebStatus then return ?.

    if not WebStatus.CompletedStatus then return ?.
        
    find first IssStatus of Issue no-lock no-error.

    if not avail IssStatus then return ?.


    return IssStatus.ChangeDate.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-CloseOfIssue Include 
FUNCTION islib-CloseOfIssue RETURNS LOGICAL
  ( pc-LoginId as char ,
    pr-rowid as rowid ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Issue        for Issue.
    def buffer IssAction    for IssAction.
    def buffer WebNote      for WebNote.
    def buffer WebAction    for WebAction.


    find Issue where rowid(issue) = pr-rowid no-lock no-error.
    if not avail Issue then return true.

    /*** PH REMOVED
    for each IssAction
        where issAction.CompanyCode = Issue.CompanyCode
          and issAction.IssueNumber = Issue.IssueNumber
          and IssAction.ActionStatus = "OPEN":

        assign
            IssAction.ActionStatus = "CLOSED".

        if can-find(WebNote
                    where WebNote.CompanyCode = Issue.CompanyCode
                      and WebNote.NoteCode = "SYS.MISC" no-lock) then
        do:
            find WebAction
                where WebAction.ActionID = IssAction.ActionID
                no-lock no-error.
            if avail WebAction
            then RUN islib-CreateNote
                    ( Issue.CompanyCode,
                      Issue.IssueNumber,
                      pc-LoginID,
                      "SYS.MISC",
                      "Issue closed - Action automatically closed : " + WebAction.description 
                      ).
            
        end.
    end.
    ***/


    return true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-CreateAutoAction Include 
FUNCTION islib-CreateAutoAction RETURNS LOGICAL
  ( pf-IssActionID as dec ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer IssAction    for IssAction.
    def buffer b-table      for IssAction.
    def buffer WebAction    for WebAction.
    def buffer b-WebAction  for WebAction.
    def var lf-Audit        like IssAction.IssActionId      no-undo.


    find IssAction
        where IssAction.IssActionID = pf-IssActionID no-lock no-error.
    if not avail IssAction then return false.


    find b-WebAction
        where b-WebAction.ActionID = IssAction.ActionID no-lock no-error.
    if not avail b-WebAction then return false.
    if b-WebAction.autoActionCode = "" then return false.
    
    find WebAction
        where WebAction.CompanyCode = b-WebAction.CompanyCode
          and WebAction.ActionCode  = b-WebAction.AutoActionCode
          no-lock no-error.
    if not avail WebAction then return false.

    find first b-table
        where b-table.CompanyCode = WebAction.CompanyCode
          and b-table.IssueNumber = issAction.IssueNumber
          and b-table.ActionID    = WebAction.ActionID 
          no-lock no-error.
    if avail b-table then return false.

    create b-table.
    assign b-table.IssActionID = ?.

    do while true:
        run lib/makeaudit.p (
            "",
            output lf-audit
            ).
        if can-find(first IssAction
                    where IssAction.IssActionID = lf-audit no-lock)
                    then next.
        assign
            b-table.IssActionID = lf-audit.
        leave.
    end.

    message "Created Auto Action = " lf-Audit.

    assign b-table.actionID    = WebAction.ActionID
           b-table.CompanyCode = WebAction.CompanyCode
           b-table.IssueNumber = IssAction.IssueNumber
           b-table.CreateDate  = IssAction.CreateDate
           b-table.CreateTime  = IssAction.CreateTime
           b-table.CreatedBy   = IssAction.CreatedBy
           b-table.notes       = "Auto Generated - Auto Action For " + b-WebAction.description
           b-table.ActionStatus = issAction.ActionStatus
           b-table.ActionDate   = issAction.ActionDate.

    return true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-DefaultActions Include 
FUNCTION islib-DefaultActions RETURNS LOGICAL
  ( pc-companyCode  as char,
    pi-Issue        as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Issue        for Issue.
    def buffer WebIssArea   for WebIssArea.
    def buffer IssAction    for IssAction.
    def buffer b-table      for IssAction.
    def buffer WebAction    for WebAction.
    def var li-loop         as int no-undo.
    def var lf-Audit        as dec no-undo.
    def var lr-temp         as rowid no-undo.

    find Issue where Issue.CompanyCode = pc-companyCode
                 and Issue.IssueNumber = pi-Issue no-lock no-error.

    if not avail Issue then return true.

    find WebIssArea of Issue no-lock no-error.
    if not avail WebIssArea then return true.

    do li-loop = 1 to 10:

        if WebIssArea.def-ActionCode[li-loop] = "" then next.

        find WebAction
            where WebAction.CompanyCode = pc-companyCode
              and WebAction.ActionCode  = WebIssArea.def-ActionCode[li-loop]
              no-lock no-error.
        if not avail WebAction then next.

        find first IssAction
            where IssAction.CompanyCode = pc-companyCode
              and IssAction.IssueNumber = Issue.IssueNumber
              and IssAction.ActionID    = WebAction.ActionID
              no-lock no-error.
        if avail IssAction then next.

        create b-table.
        assign b-table.actionID    = WebAction.ActionID
               b-table.CompanyCode = pc-companyCode
               b-table.IssueNumber = Issue.IssueNumber
               b-table.CreateDate  = today
               b-table.CreateTime  = time
               b-table.CreatedBy   = "SYSTEM"
               .

        do while true:
            run lib/makeaudit.p (
                "",
                output lf-audit
                ).
            if can-find(first IssAction
                        where IssAction.IssActionID = lf-audit no-lock)
                        then next.
            assign
                b-table.IssActionID = lf-audit.

            leave.
        end.

        assign b-table.notes            = "Auto Generated - Default Action For " + WebIssArea.description
               b-table.ActionStatus     = "OPEN"
               b-table.ActionDate       = today
               b-table.AssignDate       = ?
               b-table.AssignTime       = 0.

        assign lr-temp = rowid(b-table).
        release b-table.

        find b-table where rowid(b-table) = lr-temp no-lock no-error.

        DYNAMIC-FUNCTION('islib-CreateAutoAction':U,b-table.IssActionID).
    end.
  



    return true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-IssueIsOpen Include 
FUNCTION islib-IssueIsOpen RETURNS LOGICAL
  ( pr-rowid    as rowid) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer issue        for issue.
    def buffer WebStatus    for WebStatus.
    
    def var lc-return   as char no-undo.


    find issue
        where rowid(issue) = pr-rowid no-lock no-error.

    if not avail issue then return false.

    find WebStatus of Issue no-lock no-error.

    if not avail WebStatus then return false.


    return WebStatus.CompletedStatus = false.



END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-OutsideSLA Include 
FUNCTION islib-OutsideSLA RETURNS LOGICAL
  ( pr-rowid    as rowid
    ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer issue        for issue.
    def buffer WebStatus    for WebStatus.
    
    def var lc-return   as char no-undo.


    find issue
        where rowid(issue) = pr-rowid no-lock no-error.

    if not avail issue then return false.
    if issue.SLAStatus = "OFF" then return false.

    if DYNAMIC-FUNCTION('islib-IssueIsOpen':U,rowid(Issue)) = false
    or Issue.link-SLAID = ?
    or Issue.link-SLAID = 0 
    or not can-find(sla where sla.SLAID = Issue.link-SLAID ) 
    or Issue.SLADate[1] = ? then return false.

    if Issue.SLALevel = 0 then return false.

    if Issue.SLALevel = 10
    or Issue.SLADate[Issue.SLALevel + 1] = ? then return true.
    else return false.




    return true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-RemoveAlerts Include 
FUNCTION islib-RemoveAlerts RETURNS LOGICAL
  ( pr-rowid as rowid ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    def buffer issue        for issue.
    def buffer IssAlert     for IssAlert.
    
    def var lc-return   as char no-undo.


    find issue
        where rowid(issue) = pr-rowid no-lock no-error.
    
    for each IssAlert of Issue exclusive-lock:
        delete IssAlert.
    end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-SLAChanged Include 
FUNCTION islib-SLAChanged RETURNS LOGICAL
  ( pr-rowid    as rowid,
    pc-loginID    as char,
    pf-old-SLAID as dec,
    pf-new-SLAID as dec ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer Issue for Issue.
    def var lc-message as char no-undo.

    if pf-old-SLAID = pf-new-SLAID then return true.

    find issue
        where rowid(issue) = pr-rowid exclusive-lock no-error.

    if not avail issue then return false.


    if can-find(WebNote
                    where WebNote.CompanyCode = Issue.CompanyCode
                      and WebNote.NoteCode = "SYS.SLA" no-lock) then
    do:
        
        RUN islib-CreateNote
                ( Issue.CompanyCode,
                  Issue.IssueNumber,
                  pc-LoginID,
                  "SYS.SLA",
                  'From: ' + dynamic-function("com-SLADescription",pf-old-SLAID) + '~n' +
                  'To: ' + dynamic-function("com-SLADescription",pf-new-SLAID) + '~n'
                  ).
        
    end.



    return true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-StatusIsClosed Include 
FUNCTION islib-StatusIsClosed RETURNS LOGICAL
  ( pc-CompanyCode as char,
    pc-StatusCode as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    def buffer WebStatus    for WebStatus.
    
    def var lc-return   as char no-undo.

    find WebStatus 
        where WebStatus.CompanyCode = pc-CompanyCode
          and WebStatus.StatusCode = pc-StatusCode
          no-lock no-error.

    if not avail WebStatus then return false.

    return WebStatus.CompletedStatus.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION islib-WhoToAlert Include 
FUNCTION islib-WhoToAlert RETURNS CHARACTER
  ( pc-CompanyCode      as char,
    pi-IssueNumber      as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    def buffer Issue      for Issue.
    def buffer WebUser    for WebUser.

    find Issue
        where Issue.CompanyCode = pc-CompanyCode
          and Issue.IssueNumber = pi-IssueNumber no-lock no-error.

    if not avail Issue then return "".

    if Issue.RaisedLoginID <> ""
    then return Issue.RaisedLoginID.

    find first WebUser
        where WebUser.companyCode = pc-companyCode
          and WebUser.AccountNumber = Issue.AccountNumber
          and WebUser.DefaultUser  
        no-lock no-error.

    return if avail WebUser then webuser.loginid else "".

  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

