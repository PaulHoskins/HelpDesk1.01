&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/ajax/action.p
    
    Purpose:        Issue Actions    
    
    Notes:
    
    
    When        Who         What
    03/05/2006  phoski      Initial
    21/03/2007  phoski      Sort Activity by DATE/CREATE TIME desc

***********************************************************************/
CREATE WIDGET-POOL.


def var lc-rowid        as char no-undo.
def var lc-toolbarid    as char no-undo.


def buffer b-table      for issue.
def buffer b-query      for issAction.
def buffer IssActivity  for IssActivity.

def var lc-info             as char no-undo.
def var lc-object           as char no-undo.
def var li-tag-end          as int no-undo.
def var lc-dummy-return     as char initial "MYXXX111PPP2222"   no-undo.
def var li-duration         as int no-undo.
def var li-total-duration   as int no-undo.
def var lc-AllowDelete      as char no-undo.

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

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHeader Procedure 
PROCEDURE outputHeader :
/*------------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  objtargets:       In the event that this Web object is state-aware, this is
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
  objtargets:       
------------------------------------------------------------------------------*/
    
    def var li-count        as int      no-undo.
    def var lc-start        as char     no-undo.
    def var lc-Action       as char     no-undo.
    def var lc-Audit        as char     no-undo.
    def var ll-HasClosed    as log      no-undo.

    assign
        lc-rowid = get-value("rowid")
        lc-toolbarid = get-value("toolbarid")
        lc-AllowDelete = get-value("allowdelete").
    

    find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.

    
    RUN outputHeader.
    
    {&out}
        htmlib-CustomerViewable(b-table.CompanyCode,b-table.AccountNumber).

    {&out} skip
          replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').
    {&out}
           htmlib-TableHeading(
           "Date|Assigned To|Created|Action|Date|Activity|Site Visit|By|Start/End|Duration<br>(H:MM)^right"
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
            assign
                li-duration = li-duration + IssActivity.Duration
                li-count    = li-count + 1.
        end.
        assign
            li-total-duration = li-total-duration + li-duration.

        assign
            li-count = li-count + 1.

        assign
            lc-Action = string(b-Query.ActionDate,"99/99/99").
        if b-query.ActionStatus = "CLOSED"
        then assign lc-Action = '<span style="color: green;">' + lc-Action + "**</span>"
                    ll-HasClosed = true.

        assign
            lc-Audit = string(b-Query.CreateDate,"99/99/99") + " " + 
                       string(b-Query.CreateTime,"hh:mm") + " " + 
                       dynamic-function("com-UserName",b-query.CreatedBy).
                       
        {&out}
            skip(1)
            tbar-trID(lc-ToolBarID,rowid(b-query))
            skip(1)
            htmlib-MntTableField(lc-Action,'left')
            htmlib-MntTableField(
                dynamic-function("com-UserName",b-query.AssignTo)
                ,'left')
            htmlib-MntTableField(lc-Audit,'left').

        if b-query.notes <> "" then
        do:
        
            assign 
                lc-info = 
                replace(htmlib-MntTableField(html-encode(WebAction.Description),'left'),'</td>','')
                lc-object = "hdobj" + string(b-query.issActionID).
        
            lc-info = replace(lc-info,"<td","<td colspan=6 ").

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
            replace(htmlib-MntTableField(WebAction.Description,'left'),
                    "<td","<td colspan=6 ").
        {&out}
            
            htmlib-MntTableField(
                if li-Duration > 0 
                                     then '<strong>' + html-encode(com-TimeToString(li-duration)) + '</strong>'
                                     else "",'right')
            
            tbar-BeginHidden(rowid(b-query)).

        if lc-allowDelete = "yes" 
        then {&out} tbar-Link("delete",rowid(b-query),
                          'javascript:ConfirmDeleteAction(' +
                          "ROW" + string(rowid(b-query)) + ','
                           
                          
                          + string(b-query.issActionID) + ');',
                          "").
        {&out}
            
                tbar-Link("update",?,
                     'javascript:PopUpWindow('
                          + '~'' + appurl 
                          + '/iss/actionupdate.p?mode=update&issuerowid=' + string(rowid(b-table)) + "&rowid=" + string(rowid(b-query))
                          + '~'' 
                          + ');'
                          ,"")
/*                 tbar-Link("addactivity",?,                                                                                                   */
/*                      'javascript:PopUpWindow('                                                                                               */
/*                           + '~'' + appurl                                                                                                    */
/*                           + '/iss/activityupdate.p?mode=add&issuerowid=' + string(rowid(b-table)) + "&actionrowid=" + string(rowid(b-query)) */
/*                           + '~''                                                                                                             */
/*                           + ');'                                                                                                             */
/*                           ,"")                                                                                                               */
/*                 tbar-Link("updateactivity",?,"off","")                                                                                       */
                tbar-Link("multiiss",?,
                     'javascript:PopUpWindow('
                          + '~'' + appurl 
                          + '/iss/activityupdmain.p?mode=display&issuerowid=' + string(rowid(b-table)) + "&rowid=" + string(rowid(b-query)) + "&actionrowid=" + string(rowid(b-query))
                          + '~'' 
                          + ');'
                          ,"") skip
                         

            tbar-EndHidden()
            '</tr>' skip.

        for each IssActivity no-lock
            where issActivity.CompanyCode = b-query.CompanyCode
              and issActivity.IssueNumber = b-query.IssueNumber
              and IssActivity.IssActionId = b-query.IssActionID
              by issActivity.ActDate DESC
              by IssActivity.CreateDate desc
              by issActivity.CreateTime DESC:

            assign
                lc-start = "".

            if issActivity.StartDate <> ? then
            do:
                assign
                    lc-start = string(issActivity.StartDate,"99/99/99") + 
                               " " +
                               string(issActivity.StartTime,"hh:mm").

                if issActivity.EndDate <> ? then
                assign
                    lc-start = lc-start + " - " + 
                               string(issActivity.EndDate,"99/99/99") + 
                               " " +
                               string(issActivity.EndTime,"hh:mm").
                                
            end.

            {&out}
                skip(1)
                tbar-trID(lc-ToolBarID,rowid(IssActivity))
                skip(1)
                replace(htmlib-MntTableField("",'left'),"<td","<td colspan=4") 
                htmlib-MntTableField(string(IssActivity.ActDate,'99/99/99'),'left') skip.


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
                htmlib-MntTableField(if IssActivity.SiteVisit then "Yes" else "&nbsp;",'left').

            {&out}
                htmlib-MntTableField(
                dynamic-function("com-UserName",IssActivity.ActivityBy)
                ,'left')
                htmlib-MntTableField(html-encode(lc-Start),'left')
                htmlib-MntTableField(if IssActivity.Duration > 0 
                                     then html-encode(com-TimeToString(IssActivity.Duration))
                                     else "",'right')
            
                tbar-BeginHidden(rowid(IssActivity))
            
                    tbar-Link("update",?,
                     'javascript:PopUpWindow('
                          + '~'' + appurl 
                          + '/iss/actionupdate.p?mode=update&issuerowid=' + string(rowid(b-table)) + "&rowid=" + string(rowid(b-query))
                          + '~'' 
                          + ');'
                          ,"")
/*                     tbar-Link("addactivity",?,                                                                                                    */
/*                      'javascript:PopUpWindow('                                                                                                    */
/*                           + '~'' + appurl                                                                                                         */
/*                           + '/iss/activityupdate.p?mode=add&issuerowid=' + string(rowid(b-table)) + "&actionrowid=" + string(rowid(b-query))      */
/*                           + '~''                                                                                                                  */
/*                           + ');'                                                                                                                  */
/*                           ,"")                                                                                                                    */
/*                      tbar-Link("updateactivity",?,                                                                                                */
/*                      'javascript:PopUpWindow('                                                                                                    */
/*                           + '~'' + appurl                                                                                                         */
/*                           + '/iss/activityupdate.p?mode=update&issuerowid=' + string(rowid(b-table)) + "&actionrowid=" + string(rowid(b-query)) + */
/*                                          "&rowid=" + string(rowid(IssActivity))                                                                   */
/*                           + '~''                                                                                                                  */
/*                           + ');'                                                                                                                  */
/*                           ,"")                                                                                                                    */
                         

                tbar-EndHidden()
            '</tr>' skip.


        end.

    end.
    
    if li-total-duration <> 0 then
    {&out} '<tr class="tabrow1" style="font-weight: bold; border: 1px solid black;">'
                replace(htmlib-MntTableField("Total Duration","right"),"<td","<td colspan=9 ")
                htmlib-MntTableField(html-encode(com-TimeToString(li-total-duration))
                                     ,'right')
                
            '</tr>'.

    if ll-HasClosed then
    do:
        {&out} '<tr class="tabrow1" style="font-weight: bold; border: 1px solid black;">'
                replace(htmlib-MntTableField("** Closed Actions","left"),"<td",'<td colspan=10 style="color:green;"')
                
            '</tr>'.
    end.
    {&out} skip 
           htmlib-EndTable()
           skip.

   
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

