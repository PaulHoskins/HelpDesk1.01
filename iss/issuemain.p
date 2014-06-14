&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/issuemain.p
    
    Purpose:        Issue Maintenance
    
    Notes:
    
    
    When        Who         What
    06/04/2006  phoski      SearchField populate
    06/06/2006  phoski      Category
    
    30/08/2010  DJS         3704 Amended to include new gmap & rdp buttons

***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


 
def buffer b-table  for issue.
def buffer b-cust   for Customer.
 
def buffer b-issue  for issue.
def buffer b-IStatus  for IssStatus.
def buffer b-user   for WebUser.
def buffer b-status for WebStatus.

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.


def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.

def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-area         as char no-undo.
def var lc-account      as char no-undo.
def var lc-status       as char no-undo.
def var lc-assign       as char no-undo.
def var lc-parameters   as char no-undo.

def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.

def var lc-icustname        as char no-undo.
def var lc-AreaCode         as char no-undo.
def var lc-briefdescription as char no-undo.
def var lc-longdescription  as char no-undo.
def var lc-currentstatus    as char no-undo.
def var lc-currentassign    as char no-undo.
def var lc-statnote         as char no-undo.
def var lc-planned          as char no-undo.
def var lc-catcode          as char no-undo.
def var lc-ticket           as char no-undo.
def var lc-category         as char no-undo.

def var lc-sla-rows         as char no-undo.
def var lc-sla-selected     as char no-undo.
DEF VAR li-OpenActions      AS INT  NO-UNDO.
DEF VAR ll-IsOpen           AS LOG  NO-UNDO.

/* Lists */
def var lc-list-area        as char no-undo.
def var lc-list-aname       as char no-undo.

def var lc-list-status      as char no-undo.
def var lc-list-sname       as char no-undo.

def var lc-list-assign      as char no-undo.
def var lc-list-assname     as char no-undo.

def var lc-list-catcode     as char no-undo.
def var lc-list-cname       as char no-undo.
DEF VAR lc-iclass           AS CHAR NO-UNDO.


def var lc-pdf as char no-undo.
def var lc-submitsource as char no-undo.
def var lc-link-otherp  as char no-undo.
def var ll-superuser    as log  no-undo.

def var lc-name     as char no-undo.

def var lc-Doc-TBAR         as char 
    initial "doctb"         no-undo.

def var lc-Action-TBAR      as char
    initial "acttb"         no-undo.

/* Contract stuff  */

def var lc-list-ctype       as char no-undo.
def var lc-list-cdesc       as char no-undo.
def var lc-contract-type    as char no-undo.
def var lc-ContractCode     as char no-undo.
def var lc-billable-flag    as char no-undo.
def var ll-billing          as log  no-undo.
def var lc-ContractAccount   as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fn-DescribeSLA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-DescribeSLA Procedure 
FUNCTION fn-DescribeSLA RETURNS CHARACTER
  ( pr-rowid as rowid )  FORWARD.

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
         HEIGHT             = 14.15
         WIDTH              = 60.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}
{iss/issue.i}
{lib/ticket.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-ActionPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ActionPage Procedure 
PROCEDURE ip-ActionPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&out}
           skip
           tbar-BeginID(lc-Action-TBAR,"")
           tbar-Link("add",?,
                     'javascript:PopUpWindow('
                          + '~'' + appurl 
                     + '/iss/actionupdate.p?mode=add&issuerowid=' + string(rowid(b-table))
                          + '~'' 
                          + ');'
                          ,"")
                      skip
            tbar-BeginOptionID(lc-Action-TBAR) skip.

    if ll-SuperUser
    then {&out} tbar-Link("delete",?,"off","").

    {&out}  tbar-Link("update",?,"off","")
/*             tbar-Link("addactivity",?,"off","")    */
/*             tbar-Link("updateactivity",?,"off","") */
            tbar-Link("multiiss",?,"off","")
            tbar-EndOption()
            tbar-End().

    {&out}
            '<div id="IDAction"></div>'.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-AreaCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-AreaCode Procedure 
PROCEDURE ip-AreaCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{&out}  skip
            '<select name="areacode" class="inputfield">' skip.
    {&out}
            '<option value="' dynamic-function("htmlib-Null") '" ' if lc-AreaCode = dynamic-function("htmlib-Null") 
                then "selected" else "" '>Select Area</option>' skip
            '<option value="" ' if lc-AreaCode = ""
                then "selected" else "" '>Not Applicable/Unknown</option>' skip        
            .
    for each webIssArea no-lock
        where webIssArea.CompanyCode = lc-Global-Company 
          break by webIssArea.GroupID
                by webIssArea.AreaCode:

        if first-of(webissArea.GroupID) then
        do:
            find webissagrp
                where webissagrp.companycode = webissArea.CompanyCode
                  and webissagrp.Groupid     = webissArea.GroupID no-lock no-error.
            {&out}
                '<optgroup label="' html-encode(if avail webissagrp then webissagrp.description else "Unknown") '">' skip.
        end.

        {&out}
            '<option value="' webIssArea.AreaCode '" ' if lc-AreaCode = webIssArea.AreaCode  
                then "selected" else "" '>' html-encode(webIssArea.Description) '</option>' skip.

        if last-of(WebIssArea.GroupID) then {&out} '</optgroup>' skip.
    end.

    {&out} '</select>'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-BackToIssue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BackToIssue Procedure 
PROCEDURE ip-BackToIssue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var lc-link-url     as char no-undo.

    RUN outputHeader.
    {&out} htmlib-Header(lc-title) skip.
   
    assign request_method = "get".

    assign lc-link-url = '"' + 
                         appurl + '/iss/issue.p' + 
                        '?search=' + lc-search + 
                        '&firstrow=' + lc-firstrow + 
                        '&lastrow=' + lc-lastrow + 
                        '&navigation=refresh' +
                        '&time=' + string(time) + 
                        '&account=' + lc-account + 
                        '&status=' + lc-status +
                        '&assign=' + lc-assign + 
                        '&area=' + lc-area + 
                        '&category=' + lc-category +
                        '&iclass=' + lc-iclass +
                        '"'.
    
    if lc-submitsource = "print" then
    {&out} '<script language="javascript">' skip
           'function PrintWindow(HelpPageURL) ~{' skip
           '    PrintWinHdl = window.open(HelpPageURL,"PrintWindow","width=600,height=400,scrollbars=yes,resizable")' skip
               '    PrintWinHdl.focus()' skip
           '~}' skip
           '</script>' skip.

    {&out} '<script language="javascript">' skip.

           
    if lc-submitsource = "print" 
    then {&out} 
           'PrintWindow("' appurl '/iss/issueview.p?autoprint=yes&rowid=' string(rowid(b-table)) '")' skip.


    if get-value("fromcview") = "yes" then
    do:
        find customer 
            where customer.CompanyCode = b-table.CompanyCode
              and customer.AccountNumber = b-table.AccountNumber 
              no-lock no-error.
        assign
            lc-link-url = appurl + "/cust/custview.p?mode=view&source=menu&rowid=" + 
            string(rowid(customer)).

        lc-link-url = '"' + lc-link-url + '"'.
        
    end.
    
    
    {&out} 'myParent = self.parent' skip
           'NewURL = ' lc-link-url  skip
           'myParent.location = NewURL' skip
            '</script>' skip.

    {&OUT} htmlib-Footer() skip.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ContractSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ContractSelect Procedure 
PROCEDURE ip-ContractSelect PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def var lc-char as char  no-undo.

    {&out}  skip
            '<select id="selectcontract" name="selectcontract" class="inputfield"  onchange=~"javascript:ChangeContract();~">' skip.
    {&out}
            '<option value="ADHOC|yes" >Ad Hoc</option>' skip
            .

    if lc-ContractAccount <> ""  then
    do:

      if can-find (first WebIssCont                           
               where WebIssCont.CompanyCode     = lc-global-company     
                 and WebIssCont.Customer        = lc-ContractAccount     
                 and WebIssCont.ConActive       = true ) 
      then
      do:
        for each WebIssCont no-lock                             
           where WebIssCont.CompanyCode     = lc-global-company     
             and WebIssCont.Customer        = lc-ContractAccount     
             and WebIssCont.ConActive       = true
             :                                        

          find first ContractType  where ContractType.CompanyCode = WebIssCont.CompanyCode
                                    and  ContractType.ContractNumber = WebissCont.ContractCode 
                                    no-lock no-error. 

           if WebIssCont.DefCon and lc-contract-type = "" then
              assign lc-contract-type = WebIssCont.ContractCode
                     ll-billing       = WebissCont.Billable
                     lc-billable-flag = if ll-billing  then "yes" else "".
           else
              assign lc-contract-type = lc-contract-type
                     ll-billing       = lc-billable-flag = "yes".
                   

      {&out}
            '<option value="' WebIssCont.ContractCode "|" string(WebissCont.Billable) '" ' .

            if b-table.ContractType = WebIssCont.ContractCode then
            do:   
            {&out}      " selected " .
            end.

       {&out}  '>'  html-encode(if avail ContractType then ContractType.Description else "Unknown")


              '</option>' skip.
        end.
      end.
    end.
   {&out} '</select>'.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Documents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Documents Procedure 
PROCEDURE ip-Documents :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&out}
           skip
           tbar-BeginID(lc-Doc-TBAR,"")
           tbar-Link("add",?,'javascript:documentAdd();',"") skip
            tbar-BeginOptionID(lc-Doc-TBAR) skip
            tbar-Link("delete",?,"off","")
            tbar-Link("customerview",?,"off","")
            tbar-Link("documentview",?,"off","")
            tbar-EndOption()
            
           tbar-End().

    {&out}
            '<div id="IDDocument"></div>'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-HeaderInclude-Calendar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-HeaderInclude-Calendar Procedure 
PROCEDURE ip-HeaderInclude-Calendar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-IssueMain) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-IssueMain Procedure 
PROCEDURE ip-IssueMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer b-cust   for customer.
    def buffer b-user   for WebUser.
    DEF BUFFER WebAttr  FOR WebAttr.

    def var lc-SLA-Describe as char no-undo.
    def var lc-icustname    as char no-undo.
    def var lc-raised       as char no-undo.


    find b-cust where b-cust.CompanyCode = b-table.CompanyCode
                  and b-cust.AccountNumber = b-table.AccountNumber
            no-lock no-error.

    if avail b-cust
    then assign lc-icustname = b-cust.AccountNumber + 
                               ' ' + b-cust.Name.
    else assign lc-icustname = 'N/A'.

    assign lc-SLA-Describe = dynamic-function("fn-DescribeSLA",rowid(b-table)).

    find b-user where b-user.LoginId = b-table.RaisedLogin 
         no-lock no-error.
    assign lc-raised = if avail b-user then b-user.name else "".
    {&out} htmlib-StartInputTable() skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Customer")
           '</TD>' skip
           htmlib-TableField(html-encode(lc-icustname),'left') skip
           '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Date")
           '</TD>' skip
           htmlib-TableField(
               ( if b-table.IssueDate = ? then "" else string(b-table.IssueDate,'99/99/9999')) + 
               " " + string(b-table.IssueTime,"hh:mm am")
                   ,'left') skip
           '</tr>'
           '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("SLA")
           '</TD>' skip
           htmlib-TableField(
                    replace(if lc-sla-describe = "" then "&nbsp" else lc-sla-describe,
                        "~n","<br>")
                   ,'left') skip
           '</tr>'.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Contract")
           '</TD><td>' skip .

    RUN ip-ContractSelect.

    {&out} '</TD></tr> ' skip.  


    {&out} '<tr><td valign="top" align="right">' 
            htmlib-SideLabel("Billable?")
            '</td><td valign="top" align="left">'
            replace(htmlib-CheckBox("billcheck", if ll-billing then true else false),
                    '>',' onClick="ChangeBilling(this);">')
            '</td></tr>' skip.


    {&out} 
           '<TR><TD VALIGN="TOP" ALIGN="right">' 
           htmlib-SideLabel("Raised By")
           '</TD>' skip
           htmlib-TableField(html-encode(lc-raised),'left') skip
          '</tr>'

           .

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           (if lookup("briefdescription",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Brief Description")
           else htmlib-SideLabel("Brief Description"))
           '</TD>'
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("briefdescription",60,lc-briefdescription) 
           '</TD>' skip.
    {&out} '</TR>' skip.
    
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          (if lookup("longdescription",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("Details")
          else htmlib-SideLabel("Details"))
          '</TD>' skip
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-TextArea("longdescription",lc-longdescription,5,60)
          '</TD>' skip
           skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("areacode",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Area")
            else htmlib-SideLabel("Area"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">' skip.

    RUN ip-AreaCode.         
    {&out}        '</TD></TR>' skip. 

    IF li-OpenActions <> 0  THEN
    DO:
        {&out} '<tr><td>&nbsp;</td><td><div class="infobox" style="font-size: 10px;">This issue has open actions ('
             li-openActions 
            ') and can not be closed.</div></td></tr>'
            SKIP.
    END.
    ELSE
    IF ll-IsOpen THEN
    DO:
        find WebAttr where WebAttr.SystemID = "SYSTEM"
             and   WebAttr.AttrID   = "ISSCLOSEWARNING" NO-LOCK NO-ERROR.
             
        IF AVAIL webattr THEN
        {&out} '<tr><td>&nbsp;</td><td>' SKIP
            '<div class="infobox" style="font-size: 10px;">' webattr.attrValue 
            '</div></td></tr>'
            SKIP.
    END.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("currentstatus",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Status")
            else htmlib-SideLabel("Status"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("currentstatus",lc-list-status,lc-list-sname,
                lc-currentstatus)
            '</TD></TR>' skip. 

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
          (if lookup("statnote",lc-error-field,'|') > 0 
          then htmlib-SideLabelError("New Status Note")
          else htmlib-SideLabel("New Status Note"))
          '</TD>' skip
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-TextArea("statnote",lc-statnote,3,60)
          '</TD>' skip
           skip.

    if lc-list-catcode <> "" then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (if lookup("catcode",lc-error-field,'|') > 0 
        then htmlib-SideLabelError("Category")
        else htmlib-SideLabel("Category"))
        '</TD>' 
        '<TD VALIGN="TOP" ALIGN="left">'
        htmlib-Select("catcode",lc-list-catcode,lc-list-cname,
            lc-catcode)
        '</TD></TR>' skip. 
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("iclass",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Class")
            else htmlib-SideLabel("Class"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("iclass",lc-global-iclass-code,lc-global-iclass-code,
                lc-iclass)
            '</TD></TR>' skip. 

    if lc-sla-rows <> "" then
    do:
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
               (if lookup("sla",lc-error-field,'|') > 0 
               then htmlib-SideLabelError("SLA")
               else htmlib-SideLabel("SLA"))
               '</TD>'
               '<TD VALIGN="TOP" ALIGN="left">' skip.
        RUN ip-SLATable.
        {&out}
               '</TD>' skip.
        {&out} '</TR>' skip.

    end.
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("currentassign",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Assigned To")
            else htmlib-SideLabel("Assigned To"))
            '</TD>' 
            '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("currentassign",lc-list-assign,lc-list-assname,
                lc-currentassign)
            '</TD></TR>' skip. 

   {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           (if lookup("planned",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Planned Completion")
           else htmlib-SideLabel("Planned Completion"))
           '</TD>'
           '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("planned",10,lc-planned) 
           htmlib-CalendarLink("planned")
           '</TD>' skip.
    {&out} '</TR>' skip.

    

    if com-AskTicket(lc-global-company,b-cust.AccountNumber) then
    do:
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("ticket",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Ticketed Issue?")
            else htmlib-SideLabel("Ticketed Issue?"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left">'
                htmlib-CheckBox("ticket", if lc-ticket = 'on'
                                        then true else false) 
            '</TD></TR>' skip.
    end.

    {&out} htmlib-EndTable() skip.

    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.

    {&out} '<center>' htmlib-SubmitButton("submitform","Update Issue") 
                '&nbsp;'
                '<input class="submitbutton" type=button name=print value="Update & Print" onclick="SubmitThePage(~'print~')">'
               '</center>' skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-IssueStatusHistory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-IssueStatusHistory Procedure 
PROCEDURE ip-IssueStatusHistory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pr-rowid        as rowid        no-undo.

    def var lc-name     as char no-undo.
    def var lc-status   as char no-undo.



    find b-issue where rowid(b-issue) = pr-rowid no-lock no-error.

    if avail b-issue then
    do:
        {&out}
            replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"')
            htmlib-tableHeading(
            "Date^right|Time^right|Status|By"
            ) skip.

        for each b-IStatus no-lock
            where b-IStatus.CompanyCode = b-issue.CompanyCode
              and b-IStatus.IssueNumber = b-issue.IssueNumber:

            find b-status where b-status.CompanyCode = b-issue.CompanyCode
                            and b-status.StatusCode = b-IStatus.NewStatusCode no-lock no-error.
            
            assign lc-status = if avail b-status then b-status.description else "".

            find b-user where b-user.LoginID = b-IStatus.LoginID no-lock no-error.
            assign lc-name = if avail b-user then b-user.name else "".

            {&out} 
                htmlib-trmouse()
                htmlib-tableField(string(b-IStatus.ChangeDate,'99/99/9999'),'right')
                htmlib-tableField(string(b-IStatus.ChangeTime,'hh:mm am'),'right')
                htmlib-tableField(html-encode(lc-status),'left')
                htmlib-tableField(html-encode(lc-name),'left')
                '</tr>' skip.
        end.
        {&out} skip 
           htmlib-EndTable()
           skip.


    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-NotePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-NotePage Procedure 
PROCEDURE ip-NotePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&out}
           skip(5)
           tbar-Begin("")
           tbar-Link("addnote",?,'javascript:noteAdd();',"")
           tbar-End().

    {&out}
            '<div id="IDNoteAjax"></div>'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SLATable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SLATable Procedure 
PROCEDURE ip-SLATable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer slahead  for slahead.
    def var li-loop     as int      no-undo.
    def var lc-object   as char     no-undo.
    def var lc-rowid    as char     no-undo.


    {&out}
        htmlib-StartMntTable()
        htmlib-TableHeading(
        "Select?^left|SLA"
        ) skip.

    if lc-global-company = "MICAR" then
    do:
    {&out}
        htmlib-trmouse()
            '<td>'
                htmlib-Radio("sla", "slanone" , if lc-sla-selected = "slanone" then true else false)
            '</td>'
            htmlib-TableField(html-encode("None"),'left')

        '</tr>' skip.
    end.

    do li-loop = 1 to num-entries(lc-sla-rows,"|"):
        assign
            lc-rowid = entry(li-loop,lc-sla-rows,"|").

        find slahead where rowid(slahead) = to-rowid(lc-rowid) no-lock no-error.
        if not avail slahead then next.
        assign
            lc-object = "sla" + lc-rowid.
        {&out}
            htmlib-trmouse()
                '<td>'
                    htmlib-Radio("sla" , lc-object, if lc-sla-selected = lc-object then true else false) 
                '</td>'
                htmlib-TableField(html-encode(slahead.description),'left')
                
            '</tr>' skip.

    end.
    
        
    {&out} skip 
       htmlib-EndTable()
       skip.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Update) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Update Procedure 
PROCEDURE ip-Update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pr-rowid        as rowid no-undo.
    def input param pc-user         as char  no-undo.

    def var lc-old-status           as  char no-undo.
    def var lc-old-assign           as  char no-undo.
    def var ll-old-ticket           as  log  no-undo.
    def var lc-old-AreaCode         as  char no-undo.

    def var lf-old-link-SLAID       like Issue.link-SLAID no-undo.


    def buffer Issue        for Issue.
    def buffer WebStatus    for WebStatus.

    find Issue where rowid(Issue) = pr-rowid exclusive-lock.

    assign 
        lc-old-Status       = Issue.StatusCode
        lc-old-assign       = Issue.AssignTo
        lf-old-link-SLAID   = Issue.link-SLAID
        ll-old-ticket       = Issue.Ticket
        lc-old-AreaCode     = Issue.AreaCode.

    assign Issue.briefdescription = lc-briefdescription
           Issue.longdescription  = lc-longdescription
           Issue.AreaCode         = lc-AreaCode
           Issue.CatCode          = lc-CatCode
           Issue.StatusCode       = lc-currentstatus
           Issue.Ticket           = lc-ticket = "on"
           Issue.ContractType     = lc-contract-type  
           Issue.Billable         = lc-billable-flag  = "on"
           Issue.SearchField      = Issue.briefdescription + " " + 
                                      Issue.LongDescription
           issue.iClass           = lc-iclass
           .

    if lc-old-status <> lc-currentstatus then
    do:
        if lc-statnote <> "" then
        do:
            find WebStatus where WebStatus.companycode = Issue.CompanyCode
                             and WebStatus.StatusCode = lc-currentstatus 
                    no-lock no-error. 
            if avail WebStatus
            and WebStatus.NoteCode <> "" 
            then run islib-CreateNote( Issue.CompanyCode,
                                       Issue.IssueNumber,
                                       pc-user,
                                       WebStatus.NoteCode,
                                       lc-statnote).
        end.
    end.

    if ll-old-ticket <> Issue.Ticket then
    do:
        run tlib-IssueChanged
            ( rowid(Issue),
              pc-user,
              ll-old-ticket,
              Issue.Ticket ).
    end.
    if lc-currentassign <>  Issue.AssignTo then
    do:
        if lc-currentassign = "" 
        then assign Issue.AssignDate = ?
                    Issue.AssignTime = 0.
        else assign Issue.AssignDate = today
                    Issue.AssignTime = time.

        islib-AssignChanged(rowid(issue),
                            pc-user,
                            Issue.AssignTo,
                            lc-currentAssign).
        assign Issue.AssignTo = lc-currentassign.
    end.


    if lc-sla-selected = "slanone" 
    or lc-sla-rows = "" then 
    do:
        assign Issue.link-SLAID = 0
               Issue.SLAStatus = "OFF".
    end.
    else
    do:
        find slahead where rowid(slahead) = to-rowid(substr(lc-sla-selected,4)) no-lock no-error.
        if avail slahead
        then assign Issue.link-SLAID = slahead.SLAID.
    end.
    
    if lc-planned = ""
    then assign Issue.PlannedCompletion = ?.
    else assign Issue.PlannedCompletion = date(lc-planned).


    if lc-old-status <> lc-currentstatus then
    do:
        release issue.
        find Issue where rowid(Issue) = pr-rowid exclusive-lock.
        run islib-StatusHistory(
                        Issue.CompanyCode,
                        Issue.IssueNumber,
                        pc-user,
                        lc-old-status,
                        lc-currentStatus ).
        release issue.
        find Issue where rowid(Issue) = pr-rowid exclusive-lock.
        
    end.

    if lf-old-link-SLAID <> Issue.link-SLAID then
    do:
        release issue.
        find Issue where rowid(Issue) = pr-rowid exclusive-lock.
        dynamic-function("islib-RemoveAlerts",rowid(Issue)).
        islib-SLAChanged(
                        rowid(Issue),
                        pc-user,
                        lf-old-link-SLAID,
                        Issue.link-SLAID ).
        release issue.
        find Issue where rowid(Issue) = pr-rowid exclusive-lock.
        if Issue.link-SLAID = 0 then
        do:
            assign Issue.link-SLAID = 0.
        end.
        else
        do:
            empty temp-table tt-sla-sched.
            run lib/slacalc.p
                ( Issue.IssueDate,
                  Issue.IssueTime,
                  Issue.link-SLAID,
                  output table tt-sla-sched ).
            assign
                Issue.SLADate = ?
                Issue.SLALevel = 0
                Issue.SLAStatus = "OFF"
                Issue.SLATime  = 0
                issue.SLATrip = ?
                issue.SLAAmber = ?.

            for each tt-sla-sched no-lock
                where tt-sla-sched.Level > 0:

                assign
                    Issue.SLADate[tt-sla-sched.Level] = tt-sla-sched.sDate
                    Issue.SLATime[tt-sla-sched.Level] = tt-sla-sched.sTime.
                assign
                    Issue.SLAStatus = "ON".
            end.
             IF issue.slaDate[2] <> ? 
             THEN ASSIGN issue.SLATrip = 
                 DATETIME(STRING(Issue.SLADate[2],"99/99/9999") + " " 
                + STRING(Issue.SLATime[2],"HH:MM")).


        end.

    end.

    release issue.
    find Issue where rowid(Issue) = pr-rowid exclusive-lock.
    if Issue.AreaCode <> lc-old-AreaCode 
    and Issue.AreaCode <> "" 
    then dynamic-function("islib-DefaultActions",Issue.CompanyCode,
                                     Issue.IssueNumber).
    if dynamic-function("islib-StatusIsClosed",
                        Issue.CompanyCode,
                        Issue.StatusCode)
    then dynamic-function("islib-RemoveAlerts",rowid(Issue)).


    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Validate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Validate Procedure 
PROCEDURE ip-Validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.


    def var ld-date as date no-undo.
    def var lf-dec  as dec no-undo.
    
    if lc-briefdescription = "" 
    then run htmlib-AddErrorMessage(
                    'briefdescription', 
                    'You must enter the brief description',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-longdescription = ""
    then run htmlib-AddErrorMessage(
                    'longdescription', 
                    'You must enter the details',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-currentstatus <> b-table.StatusCode then
    do:
        find b-status where b-status.CompanyCode = lc-global-company
                        and b-status.StatusCode = lc-currentstatus
             no-lock no-error.
        if b-status.NoteCode <> "" 
        and lc-statnote = "" then
        run htmlib-AddErrorMessage(
                    'statnote', 
                    'You must enter a status note when changing to this status',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        
        if b-status.NoteCode = "" 
        and trim(lc-statnote) <> "" then
        run htmlib-AddErrorMessage(
                    'statnote', 
                    'A status note is not required for this status',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    end.
    else
    do:
        if trim(lc-statnote) <> "" then
        run htmlib-AddErrorMessage(
                    'statnote', 
                    'A status note is not required unless you change the status',
                    input-output pc-error-field,
                    input-output pc-error-msg ).    
    end.

    if lc-planned <> "" then
    do:
        assign ld-date = ?.
        assign ld-date = date(lc-planned) no-error.
        if error-status:error
        or ld-date = ?
        then run htmlib-AddErrorMessage(
                    'planned', 
                    'The planned completion date is invalid',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
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
        ll-superuser = dynamic-function("com-IsSuperUser",lc-global-user).

    assign lc-mode = get-value("mode")
           lc-rowid = get-value("rowid")
           lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation")
           lc-account = get-value("account")
           lc-status  = get-value("status")
           lc-assign  = get-value("assign")
           lc-area    = get-value("area")
           lc-category = get-value("category")
           lc-submitsource = get-value("submitsource")
           lc-contract-type  = get-value("contract")
           lc-billable-flag  = get-value("billcheck")
           lc-iclass       = get-value("iclass").

    .
    IF lc-iclass = ""
    THEN lc-iclass = ENTRY(1,lc-global-iclass-code,"|").


    if lc-mode = "" 
    then assign lc-mode = get-field("savemode")
                    lc-rowid = get-field("saverowid")
                    lc-search = get-value("savesearch")
                    lc-firstrow = get-value("savefirstrow")
                    lc-lastrow  = get-value("savelastrow")
                    lc-navigation = get-value("savenavigation")
                    lc-account = get-value("saveaccount")
                    lc-status  = get-value("savestatus")
                    lc-assign  = get-value("saveassign")
                    lc-area    = get-value("savearea")
                    lc-category = get-value("savecategory")
                    lc-contract-type  = get-value("savecontract")  
                    lc-billable-flag  = get-value("savebillable") 
      .

    assign lc-parameters = "search=" + lc-search +
                               "&firstrow=" + lc-firstrow + 
                               "&lastrow=" + lc-lastrow.


     case lc-mode:
        when 'add'
        then assign lc-title = 'Add'
                    lc-link-label = "Cancel addition"
                    lc-submit-label = "Add Issue".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Issue'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Issue'.
    end case.
    find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock no-error.
    find customer of b-table no-lock no-error.
    
    li-OpenActions = com-IssueActionsStatus(b-table.companyCode,b-table.issueNumbe,'Open').

    IF li-OpenActions = 0 
    THEN RUN com-GetStatusIssue ( lc-global-company , output lc-list-status, output lc-list-sname ).
    ELSE RUN com-GetStatusIssueOpen ( lc-global-company , output lc-list-status, output lc-list-sname ).
   
    IF dynamic-function("islib-StatusIsClosed",
                        b-table.CompanyCode,
                        b-table.StatusCode) 
    THEN ll-IsOpen = FALSE.
    ELSE ll-isOpen = TRUE.

    RUN com-GetAreaIssue ( lc-global-company , output lc-list-area , output lc-list-aname ).
    RUN com-GetAssignIssue ( lc-global-company , output lc-list-assign , output lc-list-assname ).
    run com-GetCategoryIssue( lc-global-company, output lc-list-catcode, output lc-list-cname ).
    
    

    

    assign lc-title = lc-title + ' Issue ' + string(b-table.issuenumber) + ' - ' +
           html-encode(customer.accountNumber + " - " + customer.name)
           lc-ContractAccount = customer.accountNumber.
    
    assign
        lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,b-table.AccountNumber).

    if request_method = "post" then
    do:
        assign lc-areacode         = get-value("areacode")
               lc-briefdescription = get-value("briefdescription")
               lc-longdescription  = get-value("longdescription")
               lc-currentstatus    = get-value("currentstatus")
               lc-currentassign    = get-value("currentassign")
               lc-planned          = get-value("planned")
               lc-statnote         = get-value("statnote")
               lc-sla-selected     = get-value("sla")
               lc-catcode          = get-value("catcode")
               lc-ticket           = get-value("ticket")
               lc-contract-type    = get-value("selectcontract")
               lc-billable-flag    = get-value("billcheck")
               lc-iclass           = get-value("iclass").
          
          
        if com-TicketOnly(lc-global-company,
                          b-table.AccountNumber)
        then assign lc-ticket = "on".

        
        RUN ip-Validate( output lc-error-field,
                             output lc-error-msg ).
        if lc-error-field = "" then
        do:
            RUN ip-Update ( rowid(b-table), lc-user ).
            RUN ip-BackToIssue.
            return.

        end.


    end.
    else
    do:
        assign lc-areacode          = b-table.AreaCode
               lc-briefdescription  = b-table.briefdescription
               lc-longdescription   = b-table.longdescription
               lc-currentstatus     = b-table.StatusCode
               lc-currentassign     = b-table.AssignTo
               lc-catcode           = b-table.CatCode
               lc-ticket            = if b-table.Ticket then "on" else ""
               lc-contract-type     = b-table.ContractType   
               lc-billable-flag     = if b-table.Billable then "yes" else ""
               lc-iclass            = b-table.iclass
               .

        if b-Table.PlannedCompletion = ?
        then lc-planned = "".
        else lc-planned = string(b-table.plannedCompletion,'99/99/9999').

        assign
            lc-sla-selected = "slanone".
        if b-table.link-SLAID <> 0 then
        do:
            find slahead 
                where slahead.SLAID = b-table.link-SLAID no-lock no-error.
            if avail slahead
            then assign lc-sla-selected = "sla" + string(rowid(slahead)).

        end.
              
    end.
   
    RUN outputHeader.
    
    {&out}
         '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">' skip 
         '<HTML>' skip
         '<HEAD>' skip
          
         '<meta http-equiv="Cache-Control" content="No-Cache">' skip
         '<meta http-equiv="Pragma"        content="No-Cache">' skip
         '<meta http-equiv="Expires"       content="0">' skip
         '<TITLE>' lc-title '</TITLE>' skip
         DYNAMIC-FUNCTION('htmlib-StyleSheet':U) skip.

    
    {&out}  
       '<script>'
           'var NoteAjax = "' appurl '/iss/ajax/note.p?rowid=' string(rowid(b-table)) '"' skip
           'var CustomerAjax = "' appurl '/cust/custequiplist.p?expand=yes&ajaxsubwindow=yes&customer=' string(rowid(customer)) '"' skip
           'var DocumentAjax = "' appurl '/iss/ajax/document.p?rowid=' string(rowid(b-table)) 
                    '&toolbarid=' lc-Doc-TBAR 
                    '"' skip
           'var ActionAjax = "' appurl '/iss/ajax/action.p?allowdelete=' if ll-SuperUser then "yes" else "no" '&rowid=' string(rowid(b-table)) 
                    '&toolbarid=' lc-Action-TBAR 
                    '"' skip
           'var NoteAddURL = "' appurl '/iss/addnote.p?rowid=' + lc-rowid '"' skip
           'var DocumentAddURL = "' appurl '/iss/adddocument.p?rowid=' + lc-rowid '"' skip
           'var IssueROWID = "' string(rowid(b-table)) '"' skip
       '</script>' skip.



    {&out} 
        '<script type="text/javascript" src="/scripts/js/issue/custom.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/tree.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/prototype.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/scriptaculous.js"></script>' skip.


    {&out}
         '<script type="text/javascript" src="/scripts/js/tabber.js"></script>' skip
         '<link rel="stylesheet" href="/style/tab.css" TYPE="text/css" MEDIA="screen">' skip
         '<script language="JavaScript" src="/scripts/js/standard.js"></script>' skip
         DYNAMIC-FUNCTION('htmlib-CalendarInclude':U) skip.

    
    {&out} tbar-JavaScript(lc-Doc-TBAR) skip.
    {&out} tbar-JavaScript(lc-Action-TBAR) skip.


/* 3678 ----------------------> */ 
 {&out}  '<script type="text/javascript" >~n'
            'var pIP =  window.location.host; ~n'
            'function goGMAP(pCODE, pNAME, pADD) ~{~n'
            'var pOPEN = "http://www.google.co.uk/maps/preview?q=";' SKIP
            'pOPEN = pOPEN + pCODE;~n' SKIP
            'window.open(pOPEN, ~'WinName~' , ~'width=645,height=720,left=0,top=0~');~n'
            ' ~}~n'
            '</script>'  skip.
/* ----------------------- 3678 */ 

/* 3677 ----------------------> */ 
    {&out}  '<script type="text/javascript" >~n'
            'function newRDP(rdpI, rdpU, rdpD) ~{~n'
            'var sIP =  window.location.host; ~n'
            'var sHTML="<div style:visibility=~'hidden~' >Connect to customer</div>";~n'
            'var sScript="<SCRIPT DEFER>  ";~n'
            'sScript = sScript +  "function goRDP()~{ window.open("~n'
            'sScript = sScript +  "~'";~n'
            'sScript = sScript + "http://";~n'
            'sScript = sScript + sIP;~n'
            'sScript = sScript + ":8090/TSweb.html?server=";~n'
            'sScript = sScript + rdpI;~n'
            'sScript = sScript + "&username=";~n'
            'sScript = sScript + rdpU;~n'
            'sScript = sScript + "&domain=";~n'
            'sScript = sScript + rdpD;~n'
            'sScript = sScript + "~'";~n'
            'sScript = sScript + ", ~'WinName~', ~'width=655,height=420,left=0,top=0~'); ~} ";~n'
            'sScript = sScript + " </SCRIPT" + ">";~n'
            'ScriptDiv.innerHTML = sHTML + sScript;~n'
            'document.getElementById(~'ScriptDiv~').style.visibility=~'hidden~';~n'
            ' ~}~n'
            '</script>'  skip.
/* ------------------------ 3677 */ 
    {&out} 
        '<script>' skip
        'function ConfirmDeleteAttachment(ObjectID,DocID) ~{' skip
        '   var DocumentAjax = "' appurl '/iss/ajax/deldocument.p?docid=" + DocID' skip
        '   if (confirm("Are you sure you want to delete this document?")) ~{' skip
        "       ObjectID.style.display = 'none';" skip
        "       ahah(DocumentAjax,'placeholder');" skip
        '       var objtoolBarOption = document.getElementById("doctbtboption");' skip
        '       objtoolBarOption.innerHTML = doctbobjRowDefault;' skip
        '   ~}' skip
        '~}' skip
        '</script>' skip.

    {&out} 
        '<script>' skip
        'function CustomerView(ObjectID,DocID) ~{' skip
        'var NewDocumentAjax = "' appurl '/iss/ajax/document.p?rowid=' string(rowid(b-table)) 
                    '&toolbarid=' lc-Doc-TBAR '&toggle='
                    '" + DocID;' skip
        'var objtoolBarOption = document.getElementById("doctbtboption");' skip
        'objtoolBarOption.innerHTML = doctbobjRowDefault;' skip
        "ahah(NewDocumentAjax,'IDDocument');"
        '~}' skip
        '</script>' skip.

    {&out} 
        '<script>' skip
        'function ConfirmDeleteAction(ObjectID,ActionID) ~{' skip
        '   var DocumentAjax = "' appurl '/iss/ajax/delaction.p?actionid=" + ActionID' skip
        '   if (confirm("Are you sure you want to delete this action?")) ~{' skip
        "       ObjectID.style.display = 'none';" skip
        "       ahah(DocumentAjax,'placeholder');" skip
        '       var objtoolBarOption = document.getElementById("acttbtboption");' skip
        '       objtoolBarOption.innerHTML = acttbobjRowDefault;' skip
        '       actionTableBuild();' skip
        '   ~}' skip
        '~}' skip
        '</script>'.

    {&out}
         '</HEAD>' skip
         '<body class="normaltext" onUnload="ClosePage()">' skip
        .


   
  

    /* {&out} '<script type="text/javascript" src="/scripts/js/issue/tab.js"></script>' skip. */
    {&out}
           htmlib-StartForm("mainform","post", appurl + '/iss/issuemain.p' )
           htmlib-ProgramTitle(lc-title).


    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip
           htmlib-Hidden ("saveaccount", lc-account) skip
           htmlib-Hidden ("savestatus", lc-status) skip
           htmlib-Hidden ("saveassign", lc-assign) skip
           htmlib-Hidden ("savearea", lc-area) skip
           htmlib-Hidden ("savecategory", lc-category ) skip
           htmlib-Hidden ("savecontract", lc-contract-type  ) skip
           htmlib-Hidden ("savebillable", lc-billable-flag   ) skip
           .

   
    {&out}
        '<div class="tabber">' skip.

    /*
    *** Main Issue Details
    */
    {&out} 
        '<div class="tabbertab" title="Issue Details">' skip.
    RUN ip-IssueMain.
    {&out}
        '</div>' skip.  

    /*
    *** Actions
    */
    {&out} 
        '<div class="tabbertab" title="Actions & Activities">' skip.
    RUN ip-ActionPage.
    {&out} 
        '</div>'.

    /*
    *** Notes
    */
    {&out} 
        '<div class="tabbertab" title="Notes">' skip.
    RUN ip-NotePage.
    {&out} 
        '</div>'.

    /*
    *** Attachments
    */
    {&out} 
        '<div class="tabbertab" title="Attachments">' skip.
    RUN ip-Documents.
    {&out} 
        '</div>'.


    /*
    *** Status Changes
    */
    {&out} 
        '<div class="tabbertab" title="Status Changes">' skip.
    RUN ip-IssueStatusHistory ( rowid(b-table)).
    {&out} 
        '</div>'.
    /*
    *** Customer Details
    */
    {&out} 
        '<div class="tabbertab" title="Customer Details">' skip.
    {&out}
            '<div id="IDCustomerAjax">Loading Notes</div>'.
    {&out} 
        '</div>'.


    {&out} '</div>' skip.           /* tabber */
    

    {&out} '<div id="placeholder" style="display: none;"></div>' skip.

    {&out} htmlib-Hidden("submitsource","null")
           htmlib-Hidden("fromcview",get-value("fromcview"))
           htmlib-Hidden("contract",lc-contract-type) skip
        /*
           htmlib-Hidden("billcheck",lc-billable-flag) */
        skip.

    
    {&OUT} htmlib-EndForm() skip.

    {&out}
            htmlib-CalendarScript("planned") skip.

    {&out} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fn-DescribeSLA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-DescribeSLA Procedure 
FUNCTION fn-DescribeSLA RETURNS CHARACTER
  ( pr-rowid as rowid ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


    def buffer issue        for issue.
    def buffer slahead      for slahead.

    def var lc-return   as char no-undo.
    def var li-loop     as int  no-undo.
    def var lc-line     as char no-undo.
    def var ll-table    as log  no-undo.


    find issue
        where rowid(issue) = pr-rowid no-lock no-error.

    if not avail issue then return "".


    if issue.link-SLAID = 0 
    or issue.link-SLAID = ?
    or not can-find(slahead where slahead.slaid = issue.link-slaid no-lock)
    then return "No SLA".

    find slahead where slahead.slaid = issue.link-slaid no-lock no-error.

    assign lc-return = slahead.description.

    if DYNAMIC-FUNCTION('islib-IssueIsOpen':U,pr-rowid) then
    do:
        do li-loop = 1 to 10:
            if Issue.SLADate[li-loop] = ?
            or slahead.RespDesc[li-loop] = "" then next.

            if ll-table = false then
            do:
                assign lc-return = lc-return + 
                    htmlib-StartMntTable() +
                    htmlib-TableHeading(
                    "Level^right|Description|Date").
                assign ll-table = true.
            end.
            assign lc-line = '<tr class="tabrow1">'.
            
            assign
                lc-line = lc-line + 
                          htmlib-TableField(string(li-loop) + 
                                            if li-loop = Issue.SLALevel then "*" else "",'right') +
                          htmlib-TableField(html-encode(
                              slahead.RespDesc[li-loop] + ' (' + 
                               slahead.RespUnit[li-loop] + ' ' + string(slahead.RespTime[li-loop])
                               + ')'
                              
                              ),'left')
                         + 
                         htmlib-TableField(html-encode(
                              string(issue.SLADate[li-loop],"99/99/9999") + " " + 
                              string(issue.SLATime[li-loop],"hh:mm am")
                              
                              ),'left')
                         + '</tr>'.
            /*
            assign lc-line = "Level " + string(li-loop) + ": " + 
                               slahead.RespDesc[li-loop] + ' (' + 
                               slahead.RespUnit[li-loop] + ' ' + string(slahead.RespTime[li-loop])
                               + ')'.
            assign lc-line = lc-line + " at " + 
                        string(issue.SLADate[li-loop],"99/99/9999") + " " + 
                        string(issue.SLATime[li-loop],"hh:mm am").
            */

            assign lc-return = lc-return + lc-line.

            
        end.
        if ll-table
        then assign lc-return = lc-return + htmlib-EndTable().
        
    end.
    
    return lc-return.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

