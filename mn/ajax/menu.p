&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mn/menupanel.p
    
    Purpose:        Left Panel Menu   
    
    Notes:
    
    
    When        Who         What
    22/04/2006  phoski      Initial - replace old leftpanel.p      
    
    03/08/2010  DJS         Changed superuseranalysis for more effective 
                            run through issues table
    10/09/2010  DJS         3671 Amended to remove inventory renewals 
                              from 'alert' box.
    30/04/2014  phoski      Custview link for customers          
                              
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

def var lc-user as char no-undo.
def var lc-pass as char no-undo.

def var li-item as int no-undo.
def var ll-Alert        as log no-undo.


def temp-table tt-menu no-undo
    field ItemNo        as int
    field Level         as int
    field Description   as char 
    field ObjURL        as char
    field ObjTarget     as char
    field ObjType       as char
    field AltInfo       as char
    field aTitle        as char 
    field OverDue       as log

    index i-ItemNo is primary unique
            ItemNo.

def var lc-system as char no-undo.
def var lc-image  as char no-undo.
def var lc-company as char no-undo.

def var lc-address      as char     no-undo.
def var li-cust-open    as int      no-undo.
def var li-user-open    as int      no-undo.

def var li-total    as int      no-undo.

def temp-table tt   no-undo
    field ACode         as char
    field ADescription  as char
    field ACount        as int
    FIELD CCount        AS INT EXTENT 3
    index i-ACode     is primary ACode 
    index i-ACount    ACount DESCENDING ADescription.

DEF VAR mytime AS INT.

ETIME(YES).

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
         HEIGHT             = 14.15
         WIDTH              = 60.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-InternalUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-InternalUser Procedure 
PROCEDURE ip-InternalUser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var li-ActionCount  as int no-undo.
    def var li-AlertCount   as int no-undo.
    def var li-EmailCount   as int no-undo.
    def var li-UnCount      as int no-undo.
    def var li-Inventory    as int no-undo.
    def var lc-Random       as char no-undo.
    def var li-OpenAction  as int no-undo.


    li-ActionCount = com-NumberOfActions(webUser.LoginID).
    li-AlertCount  = com-NumberOfAlerts(webUser.LoginID).
    li-EmailCount  = com-NumberOfEmails(webUser.LoginID).
/*     li-Inventory   = com-NumberOfInventoryWarnings(webUser.LoginId). */
    li-OpenAction  = com-NumberOfOpenActions(webUser.LoginId).


    if WebUser.SuperUser
    and WebUser.UserClass = "INTERNAL"
    then li-uncount = com-NumberUnAssigned(webuser.CompanyCode).
    assign
        ll-Alert = li-ActionCount > 0 or li-AlertCount > 0 
                   or li-unCount > 0 or li-EmailCount > 0
                   or li-Inventory > 0
                   or li-OpenAction > 0
                .

    if WebUser.UserClass = "INTERNAL" 
/*      AND ( webuser.surname BEGINS "bibby"      */
/*         OR webuser.surname BEGINS "shilling" ) */
        then
    do:
        {&out} 
                '<br /><a class="tlink" style="width: 100%;" href="' appurl
                '/time/diaryframe.p' lc-random '" target="mainwindow" title="Diary View">' skip
                'Your Diary' 
                '</a><br /><br />' skip.      
    end.



    if ll-Alert then
    do:
        {&out} '<div class="menualert">'.
        assign
            lc-Random = "?random=" + string(int(today)) + string(time) + string(etime) + string(rowid(webuser)).
        if li-ActionCount > 0
        or li-AlertCount > 0 then
        do:
            {&out} 
                '<a class="tlink" style="border:none; width: 100%;" href="' appurl
                '/mn/alertpage.p' lc-random '" target="mainwindow" title="Alerts">Your' skip.
         
            if li-ActionCount > 0 then
            {&out} ' actions (' li-ActionCount ')'.
            if li-AlertCount > 0 then
            do:
                {&out} ( if li-ActionCount > 0 then ' & ' else ' ' ) 'SLA alerts (' li-AlertCount ')'.
            end.
            {&out} '</a><br />' skip.
        end.
        if li-unCount > 0 
        then {&out} 
                '<a class="tlink" style="border: none; width: 100%;" href="' appurl
                '/iss/issue.p' lc-random '&status=allopen&assign=NotAssigned" target="mainwindow" title="Unassigned Issues">'
                li-uncount ' Unassigned Issues</a><br />'.

        if li-EmailCount > 0 
        then {&out} 
                '<a class="tlink" style="border: none; width: 100%;" href="' appurl
                '/mail/mail.p' lc-random '" target="mainwindow" title="HelpDesk Emails">'
                li-EmailCount ' HelpDesk Emails</a><br />'.

        if li-Inventory > 0 
        then {&out} 
                '<a class="tlink" style="border: none; width: 100%;" href="' appurl
                '/cust/ivrenewal.p' lc-random '" target="mainwindow" title="Inventory Renewals">'
                li-Inventory ' Inventory Renewals</a><br />'.
        if li-OpenAction > 0
        then {&out} 
                '<a class="tlink" style="border: none; width: 100%;" href="' appurl
                '/iss/openaction.p' lc-random '" target="mainwindow" title="Open Actions">' skip
                'Open Actions (' li-OpenAction ')'
                '</a><br />' skip.

   
        {&out} '</div>'.

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-NewMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-NewMenu Procedure 
PROCEDURE ip-NewMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    def buffer b-tt-menu      for tt-menu.
    def buffer b-sub-menu     for tt-menu.
    def var lc-object       as char no-undo.

    def var lc-desc         as char     no-undo.


    {&out} '<div id="menustrip" style="margin: 7px;">' htmlib-BeginCriteria("Menu").

    {&out} '<div id="menu">' skip.

    for each tt-menu no-lock :
        if tt-menu.Level > 1 then next.
        
       
        if tt-menu.ObjType = "WS" then
        do:
            {&out} '<div class="menusub" style="margin-left: 0px;">' skip
                   '<table><tr><td nowrap>'.
            {&out} '<a href="'  appurl  '/' tt-menu.ObjURL '" target="' tt-menu.ObjTarget '"' skip.
              
            {&out} ' title="' + html-encode(tt-menu.description) '"'.

            {&out} '>' skip
                     html-encode(tt-menu.description) 
                    '</a></br>' skip.
            {&out} '</td></tr>'.
            {&out} '</table></div>' skip.

            next.
        end.
       
        assign lc-desc = html-encode(tt-menu.description).

        assign
            lc-object = "msub" + string(tt-menu.ItemNo).

        {&out}
            '<div id="mhd' tt-menu.ItemNo '" class="menuhd">'
            '<img src="/images/general/menuclosed.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">'
                '&nbsp;'
                lc-desc
            '</div>' skip.
        
        {&out} '<div class="menusub" style="display:none;" id="' lc-Object  '">' skip.

        {&out} '<table>'.

        for each b-sub-menu where b-sub-menu.ItemNo > tt-menu.ItemNo no-lock   :

            if b-sub-menu.Level = 1 then leave.

            if rowid(b-sub-menu) = rowid(tt-menu) then next.
            {&out} '<tr><td nowrap>'.

           
            {&out} '<a href="'  appurl  '/' b-sub-menu.ObjURL '" target="' b-sub-menu.ObjTarget '"'.
                
            {&out} ' title="' + html-encode(b-sub-menu.description) '"'.
            {&out}  '>'
                     html-encode(b-sub-menu.description) 
                    '</a></br>' skip.
            {&out} '</td></tr>'.
                   
            
        end.
        {&out} '</table>'.

        {&out} '</div>' skip.

    end.

    {&out} '</div>' skip.

    {&out} htmlib-EndCriteria() '</div>'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SuperUserAnalysis) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SuperUserAnalysis Procedure 
PROCEDURE ip-SuperUserAnalysis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def buffer b-Issue        for Issue.
    def buffer b-WebStatus    for WebStatus.
    def var    badList        as char no-undo.
    DEF VAR    iloop        AS INT NO-UNDO.

    for each WebStatus where WebStatus.Completed = true 
                       and   WebStatus.CompanyCode = lc-global-company
      no-lock:
      assign badList =   WebStatus.StatusCode + "," + badList.
    end.

    for each Issue no-lock
      where Issue.CompanyCode = lc-global-company
      and   Issue.AssignTo    <> ""
      and   index(badList,Issue.StatusCode)  = 0
       :
    
        assign li-total = li-total + 1.
    
        find tt where tt.ACode = Issue.AssignTo use-index i-Acode no-error.
        if not avail tt then
        do:
            create tt.
            assign tt.Acode = Issue.AssignTo.
            assign tt.ADescription = dynamic-function("com-UserName",Issue.AssignTo).
    
        end.
        assign tt.Acount = tt.ACount + 1.
        DO iloop = 1 TO NUM-ENTRIES(lc-global-iclass-code,"|"):
            IF issue.iclass = ENTRY(iloop,lc-global-iclass-code,"|")
            THEN ASSIGN tt.ccount[iloop] = tt.ccount[iloop] + 1.
        END.
    
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SuperUserAnalysisOLD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SuperUserAnalysisOLD Procedure 
PROCEDURE ip-SuperUserAnalysisOLD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def buffer b-Issue        for Issue.
    def buffer b-WebStatus    for WebStatus.

      for each Issue fields (CompanyCode StatusCode AssignTo IssueNumber )
      no-lock
        where Issue.CompanyCode = lc-global-company

          ,
          first WebStatus no-lock
                where WebStatus.companyCode = Issue.CompanyCode
                  and WebStatus.StatusCode  = Issue.StatusCode
                  and WebStatus.Completed   = false
          :

        assign li-total = li-total + 1.


        if Issue.AssignTo = "" then next.

        find tt where tt.ACode = Issue.AssignTo use-index i-Acode no-error.
        if not avail tt then
        do:
            create tt.
            assign tt.Acode = Issue.AssignTo.
            assign tt.ADescription = dynamic-function("com-UserName",Issue.AssignTo).
            
        end.
        assign tt.Acount = tt.ACount + 1.

       
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SuperUserFinal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SuperUserFinal Procedure 
PROCEDURE ip-SuperUserFinal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN ip-SuperUserAnalysis.

    DEF VAR iloop   AS INT  NO-UNDO.
    DEF VAR lc-class AS CHAR NO-UNDO.

    find first tt no-lock no-error.
    
    mytime = etime.
    
    if avail tt then
    do:
        {&out} '<div style="margin: 7px;">'.


        {&out} htmlib-BeginCriteria("Assignments - " + string(time,'hh:mm am')).

        {&out} '<table style="font-size: 10px;">'.

        find first tt where tt.ACode = "Renewals" no-lock no-error.
        {&out} 
            '<tr><td>'
            '<a title="View Issues" target="mainwindow" class="tlink" style="border:none;' if avail tt then 'color: red;' else ''
            '" href="' appurl '/iss/issue.p?frommenu=yes&status=allopen&assign=Renewals">'
            html-encode("Renewals")
            '</a></td><td align=right class="menuinfo">' if avail tt then tt.ACount else 0 '</td></tr>'.

        for each tt no-lock where tt.ACode <> "Renewals" use-index i-ACount :
            lc-Class = TRIM(SUBSTR(tt.ADescription,1,15)).
            {&out} 
                '<tr><td nowrap  style="vertical-align:top">'
                '<a title="View All Issues For ' html-encode(tt.ADescription) '" target="mainwindow" class="tlink" style="border:none;" href="' 
                appurl '/iss/issue.p?frommenu=yes&status=allopen&iclass=All&assign=' tt.ACode '">'
                html-encode(lc-class)
                '</a></td>' SKIP.
             IF tt.Acount = 0 THEN
             {&out} '<td align=right class="menuinfo">' tt.ACount '</td></tr>'.
             ELSE
             DO:
                 {&out} '<td align=right  style="vertical-align:top">' SKIP.
                 DO iloop = 1 TO NUM-ENTRIES(lc-global-iclass-code,"|"):
                     IF iloop > 3 THEN NEXT.
                     lc-class = ENTRY(iloop,lc-global-iclass-code,"|").
                     IF iloop > 1 THEN {&out} '-'.
                     {&out} 
                         '<a title="View Issues For ' lc-class '" target="mainwindow" class="tlink" style="border:none;" href="' 
                            appurl '/iss/issue.p?frommenu=yes&status=allopen&iclass=' lc-class ' &assign=' tt.ACode '">'
                            string(tt.CCount[iloop]) '</a>' SKIP.


                 END.

                 {&out} '</td></tr>' SKIP.




             END.

            
        end.
        {&out} '</table>'.
        {&out} htmlib-EndCriteria().
        {&out} '</div>'.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mnlib-BuildIssueMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mnlib-BuildIssueMenu Procedure 
PROCEDURE mnlib-BuildIssueMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param pc-menu     as char no-undo.
    def input param pi-level    as int  no-undo.

    def buffer b-menu for webmhead.
    def buffer b2-menu for webmhead.
    def buffer b-line for webmline.
    def buffer b2-line for webmline.
    def buffer b-object for webobject.
    def buffer b-user   for webuser.

    def var li-ItemNo       as int no-undo.
    def var lc-desc         as char no-undo.

    find b-user where b-user.loginid = lc-user no-lock no-error.

    if can-do("INTERNAL,CONTRACT",b-user.UserClass) then
    do:
        for each Issue no-lock
            where Issue.CompanyCode = b-user.CompanyCode
              and Issue.AssignTo = b-user.LoginID,
            first WebStatus NO-LOCK
                     where WebStatus.CompanyCode = Issue.CompanyCode 
                       and WebStatus.StatusCode = Issue.StatusCode
                       and WebStatus.CompletedStatus = false

            break by Issue.AccountNumber
                  by Issue.IssueNumber desc:

            find Customer of Issue no-lock no-error.

            assign lc-desc = if avail customer then customer.name 
                             else "No Customer".

            if first-of(issue.AccountNumber) then
            do:
                find last tt-menu no-lock no-error.
                assign li-itemno = if avail tt-menu 
                               then tt-menu.itemno + 1
                               else 1.
                create tt-menu.
                assign tt-menu.ItemNo = li-itemno
                       tt-menu.Level  = pi-level
                       tt-menu.Description = lc-desc.

                find first CustIV of customer no-lock no-error.
                if avail custIV then
                do:
                    find last tt-menu no-lock no-error.
                    assign li-itemno = if avail tt-menu 
                               then tt-menu.itemno + 1
                               else 1.
                    create tt-menu.
                    assign tt-menu.itemno = li-itemno
                       tt-menu.Level =  pi-level + 1
                       tt-menu.Description = "Inventory"
                       tt-menu.ObjType = "WS"
                       tt-menu.ObjTarget = "mainwindow"
                       tt-menu.ObjURL  = "cust/custequiplist.p?expand=yes&customer=" + string(rowid(customer)).

                    assign 
                       tt-menu.aTitle  = 'Inventory for ' + html-encode(customer.name).
                       .
                end.
            end.
            find last tt-menu no-lock no-error.
            assign li-itemno = if avail tt-menu 
                               then tt-menu.itemno + 1
                               else 1.
            create tt-menu.
            assign tt-menu.itemno = li-itemno
                   tt-menu.Level =  pi-level + 1
                   tt-menu.Description = string(Issue.IssueNumber) + ' ' + 
                                         Issue.BriefDescription
                   tt-menu.ObjType = "WS"
                   tt-menu.ObjTarget = "mainwindow"
                   tt-menu.ObjURL  = "iss/issueframe.p?mode=update&return=home&rowid=" + string(rowid(issue)).
                   .

            if Issue.PlannedCompletion <> ?
            and Issue.PlannedCompletion < today then
            assign tt-menu.OverDue = true.
           
        end.
    end.
    else
    /*
    ***
    *** Customer 
    ***
    */
    do:
        for each Issue no-lock
            where Issue.CompanyCode = b-user.CompanyCode
              and Issue.AccountNumber = b-user.AccountNumber,
            first WebStatus where webStatus.CompanyCode = Issue.CompanyCode
                              and WebStatus.StatusCode = Issue.StatusCode
                              and WebStatus.CompletedStatus = false

            break by Issue.AreaCode
                  by Issue.IssueNumber desc:

            find WebIssArea of Issue no-lock no-error.

            assign lc-desc = if avail WebIssArea then WebIssArea.Description 
                             else "Not Known".

            if first-of(issue.AreaCode) then
            do:
                find last tt-menu no-lock no-error.
                assign li-itemno = if avail tt-menu 
                               then tt-menu.itemno + 1
                               else 1.
                create tt-menu.
                assign tt-menu.ItemNo = li-itemno
                       tt-menu.Level  = pi-level
                       tt-menu.Description = lc-desc.
            end.
            find last tt-menu no-lock no-error.
            assign li-itemno = if avail tt-menu 
                               then tt-menu.itemno + 1
                               else 1.
            create tt-menu.
            assign tt-menu.itemno = li-itemno
                   tt-menu.Level =  pi-level + 1
                   tt-menu.Description = string(Issue.IssueNumber) + ' ' + 
                                         Issue.BriefDescription
                   tt-menu.ObjType = "WS"
                   tt-menu.ObjTarget = "mainwindow"
                   tt-menu.ObjURL  = "iss/issueview.p?mode=update&return=home&rowid=" + string(rowid(issue)).
                   .
           
        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mnlib-BuildMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mnlib-BuildMenu Procedure 
PROCEDURE mnlib-BuildMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pc-menu     as char no-undo.
    def input param pi-level    as int  no-undo.

    def buffer b-menu for webmhead.
    def buffer b2-menu for webmhead.
    def buffer b-line for webmline.
    def buffer b2-line for webmline.
    def buffer b-object for webobject.

    def var li-ItemNo       as int no-undo.
    def var ll-has-side     as log no-undo.

    find b-menu where b-menu.pagename = pc-menu no-lock no-error.

    if not avail b-menu then return.

    for each b-line of b-menu no-lock:
        if b-line.linktype = 'page' then
        do:
            find b2-menu where b2-menu.pagename = b-line.linkobject
                 no-lock no-error.
            if not avail b2-menu then next.
            find first b2-line of b2-menu no-lock no-error.
            if not avail b2-line then next.
            assign ll-has-side = false.
            for each b2-line of b2-menu no-lock:
                find b-object where b-object.objectid = b2-line.linkobject no-lock no-error.
                if not avail b-object then next.
                if can-do("l,b",b-object.menulocation) = false then next.
                assign ll-has-side = true.
                leave.
            end.
            if not ll-has-side then next.
        end.
        else
        do:
            find b-object where b-object.objectid = b-line.linkobject
                          no-lock no-error.
            if not avail b-object then next.
            if can-do("l,b",b-object.menulocation) = false then next.
        end.
        find last tt-menu no-lock no-error.
        assign li-itemno = if avail tt-menu 
                           then tt-menu.itemno + 1
                           else 1.
        if b-line.linktype = 'Page' then
        do:
            create tt-menu.
            assign tt-menu.ItemNo       = li-itemno
                   tt-menu.Level        = pi-Level
                   tt-menu.Description  = b2-menu.PageDesc.
            run mnlib-BuildMenu( b2-menu.PageName, pi-level + 1 ).

        end.
        else
        do:
            create tt-menu.
            assign tt-menu.ItemNo      = li-itemno
                   tt-menu.Level       = pi-Level
                   tt-menu.Description = b-object.Description
                   tt-menu.ObjURL      = b-object.ObjURL
                   tt-menu.ObjTarget   = b-object.ObjTarget
                   tt-menu.ObjType     = b-object.ObjType.

        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHeader Procedure 
PROCEDURE outputHeader :
/*------------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  Notes:       In the event that this Web object is state-aware, this is
               a good place to set the webState and webTimeout attributes.
------------------------------------------------------------------------------*/

  /* To make this a state-aware Web object, pass in the timeout period 
   * (in minutes) before running outputContentType.  If you supply a timeout 
   * period greater than 0, the Web object becomes state-aware and the 
   * following happens:
   *
   *   - 4GL variables webState and webTimeout are set
   *   - a cookie is created for the broker to id the client on the return trip
   *   - a cookie is created to id the correct procedure on the return trip
   *
   * If you supply a timeout period less than 1, the following happens:
   *
   *   - 4GL variables webState and webTimeout are set to an empty string
   *   - a cookie is killed for the broker to id the client on the return trip
   *   - a cookie is killed to id the correct procedure on the return trip
   *
   * Example: Timeout period of 5 minutes for this Web object.
   *
   *   setWebState (5.0).
   */
    
  /* 
   * Output additional cookie information here before running outputContentType.
   *      For more information about the Netscape Cookie Specification, see
   *      http://home.netscape.com/newsref/std/cookie_spec.html  
   *   
   *      Name         - name of the cookie
   *      Value        - value of the cookie
   *      Expires date - Date to expire (optional). See TODAY function.
   *      Expires time - Time to expire (optional). See TIME function.
   *      Path         - Override default URL path (optional)
   *      Domain       - Override default domain (optional)
   *      Secure       - "secure" or unknown (optional)
   * 
   *      The following example sets cust-num=23 and expires tomorrow at (about) the 
   *      same time but only for secure (https) connections.
   *      
   *      RUN SetCookie IN web-utilities-hdl 
   *        ("custNum":U, "23":U, TODAY + 1, TIME, ?, ?, "secure":U).
   */ 
  output-content-type("text/plain~; charset=iso-8859-1":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    assign lc-user = get-value("user").


    RUN outputHeader.
    
    
    find webuser where webuser.loginid = lc-user no-lock no-error.

    
    
    if avail webuser then
    do:
        assign
            lc-global-company = webuser.Company.

        {&out} '<div class="inform"><fieldset>'
               '<span class="menuinfo">'.

        if can-do(lc-global-internal,WebUser.UserClass) then
        do:
            /* {&out} "You are logged in as " + html-encode(webuser.name). */
            
            
            RUN ip-InternalUser.
        end.
        else
        do:
            find customer where customer.CompanyCode = WebUser.CompanyCode
                          and Customer.AccountNumber = webUser.AccountNumber
                          no-lock no-error.
            assign
                lc-address = customer.name
                li-cust-open = com-CustomerOpenIssues(customer.companycode,
                                                      customer.AccountNumber).

            lc-address = dynamic-function("com-StringReturn",lc-address,customer.Address1).
            lc-address = dynamic-function("com-StringReturn",lc-address,customer.Address2).
            lc-address = dynamic-function("com-StringReturn",lc-address,customer.City).
            lc-address = dynamic-function("com-StringReturn",lc-address,customer.County).
            lc-address = dynamic-function("com-StringReturn",lc-address,customer.Country).
            lc-address = dynamic-function("com-StringReturn",lc-address,customer.PostCode).

            {&out} '<p>' replace(lc-address,"~n","<br>") '</p>'.
            {&out} SKIP
                '<a title="Your Details" target="mainwindow" class="tlink" style="border:none;" href="' appurl '/cust/custview.p?source=menu&rowid=' 
                    string(rowid(customer)) '">'
                "View Your Details"
                '</a>' SKIP.


        end.
        {&out} '</span>'.
        {&out}
                '</fieldset></div>'.

        if can-do(lc-global-internal,WebUser.UserClass) then
        do:
        
            if webUser.UserClass = "INTERNAL" 
            and webUser.SuperUser then
            do:
                find last tt-menu no-lock no-error.
                assign li-item = if avail tt-menu then tt-menu.itemno + 1 
                             else 1.
                create tt-menu.
                assign tt-menu.itemno = li-item
                   tt-menu.Level =  1
                   tt-menu.Description = "HelpDesk Monitor"
                   tt-menu.ObjType = "WS"
                   tt-menu.ObjTarget = "mainwindow"
                   tt-menu.ObjURL  = 'iss/issueoverview.p?frommenu=yes'
                   tt-menu.AltInfo = "Monitor HelpDesk issues"
                   .
            end.

            assign li-user-open = com-AssignedToUser(webuser.CompanyCode,
                                                     webuser.LoginID).
            find last tt-menu no-lock no-error.
            assign li-item = if avail tt-menu then tt-menu.itemno + 1 
                         else 1.
            create tt-menu.
            assign tt-menu.itemno = li-item
               tt-menu.Level =  1
               tt-menu.Description = "Your Issues"
               tt-menu.ObjType = "WS"
               tt-menu.ObjTarget = "mainwindow"
               tt-menu.ObjURL = 'iss/issue.p?assign=' + WebUser.LoginID + 
                    '&status=AllOpen&iclass=All'
               tt-menu.AltInfo = "View your issues"
               .
            if li-user-open > 0 
            then assign tt-menu.description = tt-menu.description + ' (' + 
                        string(li-user-open) + ' open)'.

        end.
        else
        do:
            find last tt-menu no-lock no-error.
            assign li-item = if avail tt-menu then tt-menu.itemno + 1 
                         else 1.

            create tt-menu.
            assign tt-menu.itemno = li-item
                   tt-menu.Level =  1
                   tt-menu.Description = "Add New Issue"
                   tt-menu.ObjType = "WS"
                   tt-menu.ObjTarget = "mainwindow"
                   tt-menu.ObjURL  = 'iss/addissue.p'.
               .
           find last tt-menu no-lock no-error.
           assign li-item = if avail tt-menu then tt-menu.itemno + 1 
                        else 1.

            create tt-menu.
            assign tt-menu.itemno = li-item
               tt-menu.Level =  1
               tt-menu.Description = "Your Issues"
               tt-menu.ObjType = "WS"
               tt-menu.ObjTarget = "mainwindow"
               tt-menu.ObjURL  = 'iss/issue.p?frommenu=yes&status=allopen&iclass=All'
               tt-menu.AltInfo = "View your issues"
               .
            if li-cust-open > 0 
            then assign tt-menu.description = tt-menu.description + ' (' + 
                        string(li-cust-open) + ' open)'.
        end.

        RUN mnlib-BuildIssueMenu ( webuser.pagename, 1 ).

        RUN mnlib-BuildMenu ( webuser.pagename, 1 ).


        find last tt-menu no-lock no-error.
        assign li-item = if avail tt-menu then tt-menu.itemno + 1 
                         else 1.

        create tt-menu.
        assign tt-menu.itemno = li-item
               tt-menu.Level =  1
               tt-menu.Description = "Preferences"
               tt-menu.ObjType = "WS"
               tt-menu.ObjTarget = "mainwindow"
               tt-menu.ObjURL  = 'sys/webuserpref.p'.
               .

        find last tt-menu no-lock no-error.
        assign li-item = if avail tt-menu then tt-menu.itemno + 1 
                         else 1.

        create tt-menu.
        assign tt-menu.itemno = li-item
               tt-menu.Level =  1
               tt-menu.Description = "Change Your Password"
               tt-menu.ObjType = "WS"
               tt-menu.ObjTarget = "mainwindow"
               tt-menu.ObjURL  = 'mn/changepassword.p'.
               .

        RUN ip-NewMenu.
        
        if WebUser.UserClass = "INTERNAL" 
        and WebUser.SuperUser
        then RUN ip-SuperUserFinal.

    end.

    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

