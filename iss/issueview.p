&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/issueview.p
    
    Purpose:        View Issue
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      CompanyCode    
    05/07/2006  phoski      Category  
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


def buffer b-valid  for issue.
def buffer b-table  for issue.
def buffer b-cust   for Customer.
def buffer b-status for webstatus.
def buffer b-area   for webIssarea.

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.


def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.
def var lc-autoprint as char no-undo.
def var ll-customer as log no-undo.

def var lc-Doc-TBAR        as char 
    initial "doctb"         no-undo.

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

&IF DEFINED(EXCLUDE-ip-Action) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Action Procedure 
PROCEDURE ip-Action :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    def buffer b-query      for issAction.
    def buffer IssActivity  for IssActivity.
    
    def var lc-info             as char no-undo.
    def var lc-object           as char no-undo.
    def var li-tag-end          as int no-undo.
    def var lc-dummy-return     as char initial "MYXXX111PPP2222"   no-undo.
    def var li-duration         as int no-undo.
    def var li-total-duration   as int no-undo.

    find first b-query of b-table no-lock no-error.
    if not avail b-query then return.

    {&out} skip
          replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').
    {&out}
           htmlib-TableHeading(
           "Date|Action|Currently<br>Assigned To|Date|Activity|By|Duration<br>(H:MM)^right"
           ) skip.

    for each b-query no-lock
        where b-query.CompanyCode = b-table.CompanyCode
          and b-query.IssueNumber = b-table.IssueNumber
          by b-Query.ActionDate desc
          by b-Query.CreateDate desc
          by b-Query.CreateTime desc
          :

        find WebAction 
            where WebAction.ActionID = b-query.ActionID
            no-lock no-error.

        assign
            li-duration = 0.
        for each IssActivity no-lock
            where issActivity.CompanyCode = b-table.CompanyCode
              and issActivity.IssueNumber = b-table.IssueNumber
              and IssActivity.IssActionId = b-query.IssActionID:
            li-duration = li-duration + IssActivity.Duration.
        end.
        assign
            li-total-duration = li-total-duration + li-duration.

        {&out}
            skip(1)
            '<tr>'
            skip(1)
            htmlib-MntTableField(string(b-query.ActionDate,"99/99/9999")
                                 + ( if b-query.ActionStatus = "CLOSED"
                                     then " - Closed" else ""),'left') skip(2).

        if b-query.notes <> "" then
        do:
        
            assign 
                lc-info = 
                replace(htmlib-MntTableField(html-encode(WebAction.Description),'left'),'</td>','')
                lc-object = "hdobj" + string(b-query.issActionID).
        
            assign li-tag-end = index(lc-info,">").

            {&out} substr(lc-info,1,li-tag-end).

            assign substr(lc-info,1,li-tag-end) = "".
            
            {&out} 
                '<img class="expandboxi" src="/images/general/plus.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">':U skip.
            {&out} lc-info.
    
            {&out} htmlib-ExpandBox(lc-object,b-query.Notes).

            {&out} '</td>' skip.
        end.
        else {&out}
            htmlib-MntTableField(WebAction.Description,'left').
        {&out}
            htmlib-MntTableField(
                dynamic-function("com-UserName",b-query.AssignTo)
                ,'left')
            htmlib-MntTableField("",'left')
            htmlib-MntTableField("",'left')
            htmlib-MntTableField("",'left')
            htmlib-MntTableField(
                if li-Duration > 0 
                                     then '<strong>' + html-encode(com-TimeToString(li-duration)) + '</strong>'
                                     else "",'right')
            
            '</tr>' skip.

        for each IssActivity no-lock
            where issActivity.CompanyCode = b-query.CompanyCode
              and issActivity.IssueNumber = b-query.IssueNumber
              and IssActivity.IssActionId = b-query.IssActionID
              by IssActivity.ActDate desc
              by IssActivity.CreateDate desc
              by IssActivity.CreateTime desc:

            {&out}
                skip(1)
                '<tr>'
                skip(1)
                htmlib-MntTableField("",'left') 
                htmlib-MntTableField("",'left')
                htmlib-MntTableField("",'left')

                htmlib-MntTableField(string(IssActivity.ActDate,'99/99/9999'),'left') skip.


            if IssActivity.notes <> "" then
            do:
            
                assign 
                    lc-info = 
                    replace(htmlib-MntTableField(html-encode(IssActivity.Description),'left'),'</td>','')
                    lc-object = "hdobj" + string(IssActivity.issActivityID).
            
                assign li-tag-end = index(lc-info,">").
    
                {&out} substr(lc-info,1,li-tag-end).
    
                assign substr(lc-info,1,li-tag-end) = "".
                
                {&out} 
                    '<img class="expandboxi" src="/images/general/plus.gif" onClick="hdexpandcontent(this, ~''
                            lc-object '~')">':U skip.
                {&out} lc-info.
        
                {&out} htmlib-ExpandBox(lc-object,IssActivity.Notes).
    
                {&out} '</td>' skip.
            end.
            else {&out}
                htmlib-MntTableField(IssActivity.Description,'left').

                
            {&out}
                htmlib-MntTableField(
                dynamic-function("com-UserName",IssActivity.ActivityBy)
                ,'left')
                htmlib-MntTableField(if IssActivity.Duration > 0 
                                     then html-encode(com-TimeToString(IssActivity.Duration))
                                     else "",'right')
            
                
            '</tr>' skip.


        end.

    end.
    
    if li-total-duration <> 0 then
    {&out} '<tr class="tabrow1" style="font-weight: bold; border: 1px solid black;">'
                replace(htmlib-MntTableField("Total Duration","right"),"<td","<td colspan=6 ")
                htmlib-MntTableField(html-encode(com-TimeToString(li-total-duration))
                                     ,'right')
                
            '</tr>'.
    {&out} skip 
           htmlib-EndTable()
           skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-BuildPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildPage Procedure 
PROCEDURE ip-BuildPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def buffer b-cust   for customer.
    def buffer b-user   for WebUser.
    def buffer b-cat    for WebIssCat.

    def var lc-icustname as char no-undo.
    def var lc-raised    as char no-undo.
    def var lc-assign    as char no-undo.
    
    find b-cust of b-table no-lock no-error.
    find b-cat  of b-table no-lock no-error.
    
    if avail b-cust
    then assign lc-icustname = b-cust.AccountNumber + 
                               ' ' + b-cust.Name.
    else assign lc-icustname = 'N/A'.

    assign
        lc-raised = com-UserName(b-table.RaisedLogin).

    
    assign
        lc-assign = com-UserName(b-table.AssignTo).

    {&out} htmlib-StartInputTable() skip.

    find b-area of b-table no-lock no-error.
    find b-status of b-table no-lock no-error.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Customer")
           '</TD>' skip
           htmlib-TableField(html-encode(lc-icustname),'left') skip
           '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Date")
           '</TD>' skip
           htmlib-TableField(if b-table.IssueDate = ? then "" else 
               string(b-table.IssueDate,'99/99/9999') + " " + 
               string(b-table.IssueTime,'hh:mm am'),'left') skip
           '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Raised By")
           '</TD>' skip
           htmlib-TableField(html-encode(lc-raised),'left') skip

           .

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Description")
           '</TD>'
            htmlib-TableField(b-table.briefdescription,"") 
            '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Notes")
          '</TD>'
           htmlib-TableField(replace(b-table.longdescription,'~n','<BR>'),"") 
           '</TR>' skip.


    if avail b-area then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Area")
          '</TD>'
           htmlib-TableField(b-area.description,"") 
           '</TR>' skip.
    
    if avail b-status then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Status")
          '</TD>'
           htmlib-TableField(b-status.description,"") 
           '</TR>' skip.

    if avail b-cat then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Category")
          '</TD>'
           htmlib-TableField(b-cat.description,"") 
           '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          htmlib-SideLabel("Class")
          '</TD>'
           htmlib-TableField(b-table.iClass,"") 
           '</TR>' skip.

    if not ll-Customer then
    do:
        if lc-assign <> "" then
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
              htmlib-SideLabel("Assigned To")
              '</TD>'
               htmlib-TableField(lc-assign,"") 
               '</TR>' skip.
    
        
        if b-table.PlannedCompletion <> ?  then
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
               htmlib-SideLabel("Planned Completion")
               '</TD>'
               htmlib-TableField(string(b-table.PlannedCompletion,'99/99/9999'),"") 
               '</TR>' skip.
    
         
   
    end.
    {&out} htmlib-EndTable() skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CustomerViewAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CustomerViewAction Procedure 
PROCEDURE ip-CustomerViewAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   def input param pc-user as char no-undo.

   def buffer b-query      for issAction.
   def buffer IssActivity  for IssActivity.
   def buffer webuser      for webuser.
   def buffer customer     for customer.

   

   def var lc-info             as char no-undo.
   def var lc-object           as char no-undo.
   def var li-tag-end          as int no-undo.
   def var lc-dummy-return     as char initial "MYXXX111PPP2222"   no-undo.
   def var lc-desc             as char no-undo.

   
   find WebUser
        where WebUser.LoginID = pc-user
          no-lock no-error.

   if not avail webuser then return.

   find customer
       where customer.CompanyCode = webuser.CompanyCode
         and customer.AccountNumber = webuser.AccountNumber
       no-lock.


   if not customer.viewAction then return.

   find first b-query of b-table
       where b-query.CustomerView no-lock no-error.
   if not avail b-query then return.

   {&out} skip
         replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').
   {&out}
          htmlib-TableHeading(
          "Date|Action|Currently<br>Assigned To|Date|Activity|Site Visit?|By"
          ) skip.

   for each b-query no-lock
       where b-query.CompanyCode = b-table.CompanyCode
         and b-query.IssueNumber = b-table.IssueNumber
         and b-query.CustomerView
         by b-Query.ActionDate desc
         by b-Query.CreateDate desc
         by b-Query.CreateTime desc
         :

       find WebAction 
           where WebAction.ActionID = b-query.ActionID
           no-lock no-error.

       
       assign lc-desc = html-encode(WebAction.Description).

       if b-query.notes <> "" then
       do:
           assign lc-desc = lc-desc + " - " + 
                  replace(html-encode(b-query.notes),"~n","<br>").
       end.
       {&out}
           skip(1)
           '<tr>'
           skip(1)
           htmlib-MntTableField(string(b-query.ActionDate,"99/99/9999")
                                + ( if b-query.ActionStatus = "CLOSED"
                                    then " - Closed" else ""),'left') skip(2).

       {&out}
           htmlib-MntTableField(lc-desc,'left').
       {&out}
           htmlib-MntTableField(
               dynamic-function("com-UserName",b-query.AssignTo)
               ,'left')
           htmlib-MntTableField("",'left')
           htmlib-MntTableField("",'left')
           htmlib-MntTableField("",'left')
           '</tr>' skip.

       if customer.viewActivity then
       for each IssActivity no-lock
           where issActivity.CompanyCode = b-query.CompanyCode
             and issActivity.IssueNumber = b-query.IssueNumber
             and IssActivity.IssActionId = b-query.IssActionID
             and IssActivity.CustomerView
             by IssActivity.ActDate desc
             by IssActivity.CreateDate desc
             by IssActivity.CreateTime desc:

           {&out}
               skip(1)
               '<tr>'
               skip(1)
               htmlib-MntTableField("",'left') 
               htmlib-MntTableField("",'left')
               htmlib-MntTableField("",'left')

               htmlib-MntTableField(string(IssActivity.ActDate,'99/99/9999'),'left') skip.


           assign
               lc-desc = html-encode(IssActivity.Description).

           if IssActivity.notes <> "" then
           do:
               assign lc-desc = lc-desc + " - " + 
                      replace(html-encode(IssActivity.notes),"~n","<br>").
           end.

           {&out}
               htmlib-MntTableField(lc-desc,'left')
               htmlib-MntTableField(if IssActivity.SiteVisit then "Yes" else "No",'left').


           {&out}
               htmlib-MntTableField(
               dynamic-function("com-UserName",IssActivity.ActivityBy)
               ,'left')
               
           '</tr>' skip.


       end.

   end.

   
   {&out} skip 
          htmlib-EndTable()
          skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Document) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Document Procedure 
PROCEDURE ip-Document :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param pr-rowid        as rowid        no-undo.
    def input param pc-ToolBarID    as char         no-undo.


    def buffer this-user for WebUser.
    def var ll-Customer  as log no-undo.

    find this-user
        where this-user.LoginID = lc-global-user no-lock no-error.

    assign
        ll-customer = this-user.UserClass = "CUSTOMER".

    def buffer b-query  for doch.
    def buffer b-table  for Issue.

    find b-table where rowid(b-table) = pr-rowid no-lock no-error.

    find first b-query 
        where b-query.CompanyCode = b-table.CompanyCode
          and b-query.RelType = "issue"
          and b-query.RelKey  = string(b-table.IssueNumber) no-lock no-error.
    if not avail b-query then return.

    if ll-customer then
    do:
        find first b-query 
        where b-query.CompanyCode = b-table.CompanyCode
          and b-query.RelType = "issue"
          and b-query.RelKey  = string(b-table.IssueNumber)
          and b-query.CustomerView = true no-lock no-error.

        if not avail b-query
        then return.
    end.
    {&out}
        tbar-BeginID(pc-ToolBarID,"")
        tbar-BeginOptionID(pc-ToolBarID) 
        tbar-Link("documentview",?,"off","")
        tbar-EndOption()
        tbar-End().

    {&out} skip
          replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').
    {&out}
           htmlib-TableHeading(
           "Date|Time|By|Description|Type|Size (KB)^right"
           ) skip.

    for each b-query no-lock
        where b-query.CompanyCode = b-table.CompanyCode
          and b-query.RelType = "issue"
          and b-query.RelKey  = string(b-table.IssueNumber):

        if ll-customer and b-query.CustomerView = false then next.
        

        {&out}
            skip(1)
            tbar-trID(pc-ToolBarID,rowid(b-query))
            skip(1)
            htmlib-MntTableField(string(b-query.CreateDate,"99/99/9999"),'left')
            htmlib-MntTableField(string(b-query.CreateTime,"hh:mm am"),'left')
            htmlib-MntTableField(html-encode(dynamic-function("com-UserName",b-query.CreateBy)),'left')
            htmlib-MntTableField(b-query.descr,'left')
            htmlib-MntTableField(b-query.DocType,'left')
            htmlib-MntTableField(string(round(b-query.InBytes / 1024,2)),'right')
            tbar-BeginHidden(rowid(b-query))
                tbar-Link("documentview",rowid(b-query),
                          'javascript:OpenNewWindow('
                          + '~'' + appurl 
                          + '/sys/docview.' + lc(b-query.doctype) + '?docid=' + string(b-query.docid)
                          + '~'' 
                          + ');'
                          ,"")
            tbar-EndHidden()
            '</tr>' skip.

    end.

    {&out} skip 
           htmlib-EndTable()
           skip.

   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-NoteList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-NoteList Procedure 
PROCEDURE ip-NoteList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-Issue as int no-undo.
    def input param pc-user  as char no-undo.


    def buffer b-note for IssNote.
    def buffer b-user for WebUser.
    def buffer b-type for WebNote.
    def buffer b-iss  for Issue.

    def var lc-name as char no-undo.
    def var lc-status as char no-undo.
    def var ll-showprivate as log no-undo.
    def var li-count as int no-undo.

    find b-iss 
        where b-iss.companycode = lc-global-company
          and b-iss.IssueNumber = pi-Issue
          no-lock no-error.


    for each b-note no-lock
           where b-note.CompanyCode = lc-global-company
             and b-note.IssueNumber = pi-Issue:

           find b-type where b-type.CompanyCode = b-note.CompanyCode
                         and b-type.NoteCode = b-note.NoteCode no-lock no-error.
           if avail b-type then
           do:
               if b-type.CustomerCanView = false and ll-customer then next.
               
           end.

           assign li-count = li-count + 1.
           if li-count = 1 then 
           {&out}
            htmlib-StartMntTable()
            htmlib-TableHeading(
            "Date^right|Time^right|Details|By"
            ) skip.

           find b-type of b-note no-lock no-error.

           assign lc-status = if avail b-type then b-type.description else "".

           assign lc-status = lc-status + '<br>' + replace(b-note.Contents,'~n','<BR>').

           find b-user where b-user.LoginID = b-note.LoginID no-lock no-error.

           assign
                lc-name = com-UserName(b-note.LoginID).
          
           {&out} '<tr>' skip
               htmlib-TableField(string(b-note.CreateDate,'99/99/9999'),'right')
               htmlib-TableField(string(b-note.CreateTime,'hh:mm am'),'right')
               htmlib-TableField(lc-status,'left')
               htmlib-TableField(html-encode(lc-name),'left')
               '</tr>' skip.
    end.
    if li-count > 0 then
    {&out} skip 
        htmlib-EndTable()
        skip.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-StatusList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-StatusList Procedure 
PROCEDURE ip-StatusList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-Issue as int no-undo.
    def input param pc-user  as char no-undo.


    def buffer b-table for IssStatus.
    def buffer b-status for WebStatus.
    def buffer b-user for WebUser.
    
    

    def var lc-name as char no-undo.
    def var lc-status as char no-undo.
    
    {&out}
            htmlib-StartMntTable()
            htmlib-TableHeading(
            "Date^right|Time^right|Status|By"
            ) skip.

    for each b-table no-lock
            where b-table.CompanyCode = lc-global-company
              and b-table.IssueNumber = pi-issue
               by b-table.ChangeDate desc
               by b-table.ChangeTime desc:

        find b-status where b-status.CompanyCode = lc-global-company
                        and b-status.StatusCode = b-table.NewStatusCode no-lock no-error.
            
        assign lc-status = if avail b-status then b-status.description else "".

        find b-user where b-user.LoginID = b-table.LoginID no-lock no-error.
        assign lc-name = if avail b-user then b-user.name else "".

        {&out} '<tr>' skip
                htmlib-TableField(string(b-table.ChangeDate,'99/99/9999'),'right')
                htmlib-TableField(string(b-table.ChangeTime,'hh:mm am'),'right')
                htmlib-TableField(html-encode(lc-status),'left')
                htmlib-TableField(html-encode(lc-name),'left')
                '</tr>' skip.
    end.
    {&out} skip 
           htmlib-EndTable()
           skip.
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
  output-content-type ("text/html":U).
  
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
    
    {lib/checkloggedin.i}


    assign
        ll-Customer = com-IsCustomer(lc-global-company,lc-user).

   
    assign lc-rowid = get-value("rowid")
           lc-autoprint = get-value("autoprint").
    if lc-rowid = ""
    then assign lc-rowid = get-value("saverowid").

    assign lc-title = 'View'.

    find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock no-error.

    assign lc-title = lc-title + ' Issue ' + string(b-table.issuenumber).
    

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
          '<script language="JavaScript" src="/scripts/js/hidedisplay.js"></script>' skip.

    {&out} tbar-JavaScript(lc-Doc-TBAR) skip.

    {&out}
           htmlib-StartForm("mainform","post", appurl + '/iss/issueview.p' )
           htmlib-ProgramTitle(lc-title).
    {&out} htmlib-Hidden ("saverowid", lc-rowid) skip.

    {&out} '<a href="javascript:window.print()"><img src="/images/general/print.gif" border=0 style="padding: 5px;"></a>' skip.

    
    RUN ip-BuildPage.

    RUN ip-NoteList ( b-table.IssueNumber , lc-user ).

    RUN ip-StatusList ( b-table.IssueNumber , lc-user ).

    if not ll-Customer
    then RUN ip-Action.
    else RUN ip-CustomerViewAction ( lc-user ).

    RUN ip-Document ( rowid(b-table), lc-Doc-TBAR ).


    {&OUT} htmlib-EndForm() skip 
           htmlib-Footer() skip.
    
    if lc-autoprint = "yes" then
    do:
        {&out} '<script language="javascript">' skip
               'window.print()' skip
               '</script>' skip.

    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

