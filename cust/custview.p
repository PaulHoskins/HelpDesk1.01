&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        cust/custview.p
    
    Purpose:        Customer Maintenance         
    
    Notes:
    
    
    When        Who         What
    03/08/2006  phoski      Initial
    
    23/08/2010  DJS         3677 Added remote connection ability
    23/08/2010  DJS         3678 Modified map facility to use google 
                                maps instead of streetmaps
                                
    02/09/2010 DJS          3674 - Added Quickview buttons in view    
    28/04/2014 phoski       Customer Assets 
                          
                                
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field  as char no-undo.
def var lc-error-msg    as char no-undo.


def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.

def buffer b-customer for customer.     /* 3677 & 3678 */           
def buffer b-custIv for custIv.         /* 3677 & 3678 */           
def buffer b-ivSub for ivSub.           /* 3677 & 3678 */           
                                               
def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.

def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.

def var lc-accountnumber    as char no-undo.
def var lc-name             as char no-undo.
def var lc-address1         as char no-undo.
def var lc-address2         as char no-undo.
def var lc-city             as char no-undo.
def var lc-county           as char no-undo.
def var lc-country          as char no-undo.
def var lc-postcode         as char no-undo.
def var lc-telephone        as char no-undo.
def var lc-contact          as char no-undo.
def var lc-notes            as char no-undo.
def var lc-supportticket    as char no-undo.
def var lc-statementemail   as char no-undo.

def var lc-sla-rows         as char no-undo.
def var lc-sla-selected     as char no-undo.

def var lc-temp             as char no-undo.
def var rdpIP               as char no-undo.              /* 3677 & 3678 */
def var rdpUser             as char no-undo.              /* 3677 & 3678 */
def var rdpPWord            as char no-undo.              /* 3677 & 3678 */
def var rdpDomain           as char no-undo.              /* 3677 & 3678 */
def var first-RDP           as log  initial true no-undo. /* 3677 & 3678 */

DEF VAR ll-Customer         AS LOG INITIAL FALSE NO-UNDO.

def var lc-Doc-TBAR        as char 
    initial "doctb"         no-undo.
def var lc-Issue-TBAR       as char
    initial "isstbar"       no-undo.
def var lc-Invent-TBAR      as char
    initial "ivtb"          no-undo.
def var lc-Cust-TBAR        as char 
    initial "custtb"        no-undo.
def var lc-Asset-TBAR       as char 
    initial "assettb"        no-undo.

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
         HEIGHT             = 11.54
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

&IF DEFINED(EXCLUDE-ip-Asset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Asset Procedure 
PROCEDURE ip-Asset :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    def input param pc-ToolBarID        as char     no-undo.


    DEF var ll-ToolBar          AS LOG      NO-UNDO.
    
    def var lc-rowid as char no-undo.
    
    
    def var li-max-lines as int initial 12 no-undo.
    def var lr-first-row as rowid no-undo.
    def var lr-last-row  as rowid no-undo.
    def var li-count     as int   no-undo.
    def var ll-prev      as log   no-undo.
    def var ll-next      as log   no-undo.
    def var lc-search    as char  no-undo.
    def var lc-firstrow  as char  no-undo.
    def var lc-lastrow   as char  no-undo.
    def var lc-navigation as char no-undo.
    def var lc-parameters   as char no-undo.
    def var lc-smessage     as char no-undo.
    def var lc-link-otherp  as char no-undo.
    def var lc-char         as char no-undo.
    def var lc-customer     as char no-undo.
    def var lc-returnback   as char no-undo.
    def var lc-link-url     as char no-undo.
    def var lc-temp         as char no-undo.


    DEF BUFFER customer FOR customer.
    def buffer b-query  for CustAst.


    ASSIGN
        lc-returnback="customerview".


    find customer 
        where customer.CompanyCode = pc-CompanyCode
          and customer.AccountNumber = pc-AccountNumber
          no-lock.

    lc-customer = STRING(ROWID(customer)).




    if not dynamic-function("com-IsCustomer",lc-global-company,lc-global-user) then
    do:
        assign ll-toolbar = true.
        {&out} SKIP
            tbar-BeginID(pc-ToolBarID,"") SKIP
            tbar-Link("add",?,appurl + '/cust/custassetmnt.p',"customer=" +
                      string(rowid(customer)) + "&returnback=customerview")
            tbar-BeginOptionID(pc-ToolBarID)

            tbar-Link("view",?,"off",lc-link-otherp)
            tbar-Link("update",?,"off",lc-link-otherp)
            tbar-Link("delete",?,"off",lc-link-otherp)

 
            tbar-EndOption()
            tbar-End() SKIP.
  
    end.

    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').
    
    {&out}
           htmlib-TableHeading(
           "ID|Description|Type|Manufacturer|Model|Serial|Location|Status|Purchase|Cost^right"
           ) skip.

    open query q for each b-query no-lock
        of customer.

    get first q no-lock.

    repeat while avail b-query:
   
        
        assign lc-rowid = string(rowid(b-query)).
        
        assign li-count = li-count + 1.
        if lr-first-row = ?
        then assign lr-first-row = rowid(b-query).
        assign lr-last-row = rowid(b-query).
        
        assign lc-link-otherp = 'search=' + lc-search +
                                '&firstrow=' + string(lr-first-row) +
                                '&customer=' + lc-customer + 
                                '&returnback=' + lc-returnback.

      

        {&out}
            skip
             tbar-trID(pc-ToolBarID,rowid(b-query))
            skip

            
            htmlib-MntTableField(html-encode(b-query.AssetID),'left')
            htmlib-MntTableField(html-encode(b-query.descr),'left')
            htmlib-MntTableField(html-encode(b-query.AType + " " +
                                 DYNAMIC-FUNCTION("com-GenTabDesc",
                         b-query.CompanyCode, "Asset.Type", 
                         b-query.AType))
                                 ,'left')
            htmlib-MntTableField(html-encode(b-query.Amanu + " " +
                                 DYNAMIC-FUNCTION("com-GenTabDesc",
                         b-query.CompanyCode, "Asset.Manu", 
                         b-query.AManu))
                                 ,'left')
            htmlib-MntTableField(html-encode(b-query.model),'left')
            htmlib-MntTableField(html-encode(b-query.serial),'left')
            htmlib-MntTableField(html-encode(b-query.location),'left')
            htmlib-MntTableField(html-encode(b-query.Astatus + " " +
                                 DYNAMIC-FUNCTION("com-GenTabDesc",
                         b-query.CompanyCode, "Asset.Status", 
                         b-query.AStatus))
                                 ,'left')

            htmlib-MntTableField(html-encode(IF b-query.purchased = ? THEN '' ELSE STRING(b-query.purchased,"99/99/9999")),'left')

            htmlib-MntTableField(html-encode(string(b-query.cost,">>>>>>>>9.99-")),'right') SKIP
            SKIP



            tbar-BeginHidden(rowid(b-query))
            tbar-Link("view",rowid(b-query),appurl + '/cust/custassetmnt.p',lc-link-otherp)
            tbar-Link("update",rowid(b-query),appurl + '/cust/custassetmnt.p',lc-link-otherp)
            tbar-Link("delete",rowid(b-query),appurl + '/cust/custassetmnt.p',lc-link-otherp)
                
            tbar-EndHidden()
            '</tr>' skip.

       

        get next q no-lock.
            
    end.

    {&out} skip 
           htmlib-EndTable()
           skip.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CustomerDocuments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CustomerDocuments Procedure 
PROCEDURE ip-CustomerDocuments :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    def input param pc-ToolBarID        as char     no-undo.

    
    def buffer Customer for Customer.
    def buffer doch     for doch.
    def var lc-type         as char 
        initial "CUSTOMER"  no-undo.

    find customer 
        where customer.CompanyCode = pc-CompanyCode
          and customer.AccountNumber = pc-AccountNumber
          no-lock.

    {&out}
            tbar-BeginID(pc-ToolBarID,"")
            tbar-BeginOptionID(pc-ToolBarID)
            tbar-Link("documentview",?,"off","")
            tbar-EndOption()
            tbar-End().

    {&out} skip
          replace(htmlib-StartMntTable(),'width="100%"','width="97%"') skip.
    {&out}
           htmlib-TableHeading(
           "Date|Time|By|Description|Type|Size (KB)^right"
           ) skip.

    for each doch no-lock
        where doch.CompanyCode = lc-global-company
          and doch.RelType = "customer"
          and doch.RelKey  = customer.AccountNumber:

        IF ll-customer THEN
        DO:
            IF NOT doch.customerView THEN NEXT.

        END.
        {&out}
            skip
            tbar-trID(pc-ToolBarID,rowid(doch))
            skip
            htmlib-MntTableField(string(doch.CreateDate,"99/99/9999"),'left')
            htmlib-MntTableField(string(doch.CreateTime,"hh:mm am"),'left')
            htmlib-MntTableField(html-encode(dynamic-function("com-UserName",doch.CreateBy)),'left')
            htmlib-MntTableField(doch.descr,'left')
            htmlib-MntTableField(doch.DocType,'left')
            htmlib-MntTableField(string(round(doch.InBytes / 1024,2)),'right')
            tbar-BeginHidden(rowid(doch))
                 tbar-Link("documentview",rowid(doch),
                          'javascript:OpenNewWindow('
                          + '~'' + appurl 
                          + '/sys/docview.' + lc(doch.doctype) + '?docid=' + string(doch.docid)
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

&IF DEFINED(EXCLUDE-ip-CustomerMainInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CustomerMainInfo Procedure 
PROCEDURE ip-CustomerMainInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    def input param pc-ToolBarID        as char     no-undo.
    
    def buffer b-query  for Customer.
    

    def var lc-address      as char     no-undo.
    def var lc-temp         as char     no-undo.
    def var lc-tempAddress  as char     no-undo. /* 3678 */ 

    find b-query
        where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber no-lock no-error.
    if not avail b-query then return.
   
    assign
        lc-address = "".

    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.Address1).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.Address2).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.City).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.County).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.Country).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.PostCode).
    
    lc-tempAddress = lc-address.  /* 3678 */ 

    if get-value("source") = "menu" then
    do:
         {&out}
            tbar-BeginID(pc-ToolBarID,"")
            tbar-Link("addissue",?,appurl + '/' + "iss/addissue.p","issuesource=custenq&accountnumber=" + customer.AccountNumber)
            tbar-Link("statement",?,appurl + '/' + "cust/indivstatement.p","source=menu&accountnumber=" + customer.AccountNumber)
             SKIP.
          IF NOT ll-customer THEN
          {&out}
            tbar-Link("Gmap",?,'javascript:void(0)"onclick="goGMAP(~''                  /* 3678 */ 
                                 + replace(b-query.postcode," ","+")                    /* 3678 */ 
                                 + '~',~''                                              /* 3678 */ 
                                 + replace(replace(trim(b-query.name)," ","+"),"&","")  /* 3678 */ 
                                 + '~',~''                                              /* 3678 */ 
                                 + replace(replace(lc-tempAddress,"~n","+"),"&","")     /* 3678 */ 
                                 + '~')'  ,"")                                          /* 3678 */ 
            tbar-Link("RDP",?,'javascript:void(0)"onclick="goRDP()'  ,"")               /* 3677 */
               SKIP.

          {&out}
            tbar-BeginOptionID(pc-ToolBarID)
            tbar-EndOption()
            tbar-End().
    end.
    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').

    {&out}
            htmlib-TableHeading(
            "Account^left|Name^left|Address^left|Contact|Telephone|Support Team|Notes")
            skip.

    {&out}
        '<tr>' skip
        htmlib-MntTableField(html-encode(b-query.AccountNumber),'left')
        htmlib-MntTableField(html-encode(b-query.name),'left').

    if b-query.PostCode = "" then
    {&out}
        htmlib-MntTableField(replace(html-encode(lc-address),"~n","<br>"),'left').
    else
    do:
        assign lc-temp = replace(htmlib-MntTableField(replace(html-encode(lc-address),"~n","<br>"),'left'),"</td>","").
          /* 3678 removed streetmap */ 
        {&out} lc-temp.
    end.

    {&out}
        htmlib-MntTableField(html-encode(b-query.Contact),'left')
        htmlib-MntTableField(html-encode(b-query.Telephone),'left').
    FIND steam WHERE steam.companyCode = b-query.CompanyCode
                 AND steam.st-num = b-query.st-num NO-LOCK NO-ERROR.
    {&out} htmlib-MntTableField(IF AVAIL steam THEN STRING(steam.st-num) + " - " + steam.descr ELSE 'None','left').
    if b-query.notes = ""
    then {&out} htmlib-MntTableField("",'left').
    else {&out} replace(htmlib-TableField(replace(html-encode(b-query.notes),"~n",'<br>'),'left'),
                '<td','<th style="color: red;') skip.

    {&out} '</tr>' skip.

    {&out} skip 
           htmlib-EndTable().

    IF NOT ll-customer THEN
    {&out} htmlib-CustomerViewable(b-query.CompanyCode,b-Query.AccountNumber) SKIP.

    {&out} htmlib-CustomerDocs(b-query.CompanyCode,b-Query.AccountNumber,appurl,ll-customer)    /* 3674 */

           skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CustomerOpenIssue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CustomerOpenIssue Procedure 
PROCEDURE ip-CustomerOpenIssue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    def input param pc-ToolBarID        as char     no-undo.


    def var lc-status       as char no-undo.
    
    def var lc-issdate      as char no-undo.
    def var lc-raised       as char no-undo.
    def var lc-assigned     as char no-undo.
    def var li-count        as int no-undo.
    
    
    def var lc-open-status  as char no-undo.
    def var lc-closed-status as char no-undo.
    
    def buffer b-query  for issue.
    def buffer b-search for issue.
    def buffer b-status for WebStatus.
    def buffer b-user   for WebUser.
    def buffer b-Area   for WebIssArea.
      
    def query q for b-query scrolling.
    
    def var lc-area         as char no-undo.
   
    def var lc-info         as char no-undo.
    def var lc-object       as char no-undo.
    def var li-tag-end      as int no-undo.
    def var lc-dummy-return as char initial "CTMYXXX111PPP2222"   no-undo.
    
    def buffer Customer for Customer.
    

    find customer 
        where customer.CompanyCode = pc-CompanyCode
          and customer.AccountNumber = pc-AccountNumber
          no-lock.

    RUN com-StatusType ( pc-CompanyCode , output lc-open-status , output lc-closed-status ).

    {&out}
            tbar-BeginID(pc-ToolBarID,"")
            tbar-Link("addissue",?,appurl + '/' + "iss/addissue.p","issuesource=custenq&accountnumber=" + customer.AccountNumber)
            
            tbar-BeginOptionID(pc-ToolBarID)
            
            tbar-Link("view",?,"off","")
            tbar-Link("update",?,"off","")
            tbar-EndOption()
            tbar-End().

    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="97%"') skip
           htmlib-TableHeading(
            "Issue Number^right|Date^right|Brief Description^left|Status^left|Area|Assigned To|By^left"
            ) skip.


    open query q for each b-query no-lock
        where b-query.Company = pc-companyCode
          and b-query.AccountNumber = pc-AccountNumber
          and can-do(lc-open-status,b-query.StatusCode)
          by b-query.IssueNumber desc.

    get first q no-lock.
    repeat while avail b-query:
   
        
        assign lc-rowid = string(rowid(b-query))
               lc-issdate = if b-query.issuedate = ? then "" else string(b-query.issuedate,'99/99/9999').
        

        assign li-count = li-count + 1.
       
        

        find b-status of b-query no-lock no-error.
        if avail b-status then
        do:
            assign lc-status = b-status.Description.
            if b-status.CompletedStatus
            then lc-status = lc-status + ' (closed)'.
            else lc-status = lc-status + ' (open)'.
        end.
        else lc-status = "".

        find b-user where b-user.LoginID = b-query.RaisedLogin no-lock no-error.
        assign lc-raised = if avail b-user then b-user.name else "".

        find b-user where b-user.LoginID = b-query.AssignTo no-lock no-error.
        assign lc-assigned = if avail b-user then b-user.name else "".

        find b-area of b-query no-lock no-error.
        assign lc-area = if avail b-area then b-area.description else "".

        {&out}
            skip
            tbar-trID(pc-ToolBarID,rowid(b-query))
            skip
            htmlib-MntTableField(html-encode(string(b-query.issuenumber)),'right')
            htmlib-MntTableField(html-encode(lc-issdate),'right') skip.

        if b-query.LongDescription <> ""
        and b-query.LongDescription <> b-query.briefdescription then
        do:
        
            assign lc-info = 
                replace(htmlib-MntTableField(html-encode(b-query.briefdescription),'left'),'</td>','')
                lc-object = "hdobj" + string(b-query.issuenumber).
    
            assign li-tag-end = index(lc-info,">").

            {&out} substr(lc-info,1,li-tag-end).

            assign substr(lc-info,1,li-tag-end) = "".

            {&out} 
                '<img class="expandboxi" src="/images/general/plus.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">':U skip.
            {&out} lc-info.
    
            {&out} htmlib-ExpandBox(lc-object,b-query.LongDescription).
            
            {&out} '</td>' skip.
        end.
        else {&out} htmlib-MntTableField(html-encode(b-query.briefdescription),"left").

        {&out}
            htmlib-MntTableField(html-encode(lc-status),'left')
            htmlib-MntTableField(html-encode(lc-area),'left')
            htmlib-MntTableField(html-encode(lc-assigned),'left').

        {&out} htmlib-MntTableField(html-encode(lc-raised),'left').
        

        {&out} skip
                tbar-BeginHidden(rowid(b-query))
                tbar-Link("view",rowid(b-query),
                          'javascript:HelpWindow('
                          + '~'' + appurl 
                          + '/iss/issueview.p?rowid=' + string(rowid(b-query))
                          + '~'' 
                          + ');'
                          ,"")
                tbar-Link("update",rowid(b-query),appurl + '/' + "iss/issueframe.p","fromcview=yes")
                
            tbar-EndHidden() skip.

        {&out}
            '</tr>' skip.

       

       get next q no-lock.
            
    end.


    {&out} skip 
           htmlib-EndTable()
           skip.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CustomerSecondary) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CustomerSecondary Procedure 
PROCEDURE ip-CustomerSecondary :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    
    def buffer b-query  for Customer.
    

    find b-query
        where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber no-lock no-error.
    if not avail b-query then return.
   

    
    
    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').

    {&out}
            htmlib-TableHeading(
            "Default SLA^left|Other SLA|Support Type^left|Ticket Balance^right|Statement Email")
            skip.

    {&out}
        '<tr>' skip.

    if b-query.DefaultSLAID = 0
    then {&out} htmlib-MntTableField(html-encode("None"),'left').
    else
    do:
        find slahead where slahead.SLAID = b-query.DefaultSLAID no-lock no-error.
        {&out} htmlib-MntTableField(html-encode(slahead.description),'left').
    end.

    {&out} '<td>' skip.
    RUN ip-SLA.
    {&out}
           '</td>'.
    {&out} htmlib-MntTableField(dynamic-function("com-DecodeLookup",b-query.supportticket,
                                     lc-global-SupportTicket-Code,
                                     lc-global-SupportTicket-Desc
                                     ),'left') skip.

    {&out} htmlib-MntTableField(if DYNAMIC-FUNCTION('com-AllowTicketSupport':U,rowid(b-query))
                                 then dynamic-function("com-TimeToString",b-query.TicketBalance)
                                 else "&nbsp;",'right') skip
          htmlib-MntTableField(html-encode(b-query.statementemail),'left').
           
    
    {&out}
     
        '</tr>' skip.

    


    {&out} skip 
           htmlib-EndTable()
           
           skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-CustomerUsers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-CustomerUsers Procedure 
PROCEDURE ip-CustomerUsers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    
    def buffer b-query  for webUser.
    def var lc-nopass   as char no-undo.
    def var lc-main     as char no-undo.


    def var lc-Last     as char no-undo.

    if not can-find(first b-query
                where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber no-lock) 
                 then return.
   
    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="97%"') skip.

    {&out}
            htmlib-TableHeading(
            "User Name^left|Name^left|Last Login|Email^left|Telephone|Mobile|Track?|Disabled?"
            ) skip.


    for each b-query no-lock
        where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber
         :
    
   
         if b-query.DefaultUser 
         then assign lc-main = b-query.Name.

         assign lc-nopass = if b-query.passwd = ""
                           or b-query.passwd = ?
                           then " (No password)"
                           else "".
        
        if b-query.LastDate = ?
        then assign lc-last = "".
        else assign lc-last = string(b-query.LastDate,"99/99/9999") + " " + string(b-query.LastTime,"hh:mm am").

        {&out}
            '<tr>' skip
            htmlib-MntTableField(html-encode(b-query.loginid),'left')
            htmlib-MntTableField(html-encode(b-query.name),'left')
            htmlib-MntTableField(html-encode(lc-last),'left')
            htmlib-MntTableField(html-encode(b-query.email),'left')
            htmlib-MntTableField(html-encode(b-query.Telephone),'left')
            htmlib-MntTableField(html-encode(b-query.Mobile),'left')
            htmlib-MntTableField(html-encode(if b-query.CustomerTrack = true
                                          then 'Yes' else 'No'),'left')
            htmlib-MntTableField(html-encode((if b-query.disabled = true
                                          then 'Yes' else 'No') + lc-nopass),'left')

            .
            
        {&out}
            
            '</tr>' skip.
     
    end.


    {&out} skip 
           htmlib-EndTable()
           skip.

    if lc-main <> "" then
    do:
        {&out} '<div class="infobox">'
                    html-encode(lc-main) " is the main issue contact for this account</div>" .
                
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Inventory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Inventory Procedure 
PROCEDURE ip-Inventory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    
    def buffer Customer for Customer.
    def buffer ivClass  for ivClass.
    def buffer ivSub    for ivSub.
    def buffer b-query for CustIv.
    def buffer b-search for CustIv.

    def var lc-object           as char no-undo.
    def var lc-subobject        as char no-undo.
    def var lc-ajaxSubWindow    as char no-undo.
    def var lc-expand           as char no-undo.
    def var ll-toolbar          as log  no-undo.
    def var lc-update-id        as char no-undo.
    def var lc-htmlreturn       as char no-undo.   /* 3677 */ 
    def var ll-htmltrue         as log  no-undo.   /* 3677 */ 


    lc-expand = "yes".

    find customer 
        where customer.CompanyCode = pc-CompanyCode
          and customer.AccountNumber = pc-AccountNumber
          no-lock.

    
    /*
    *** Link to maintain inventory info
    */

    if dynamic-function("com-IsContractor",lc-global-company,lc-global-user) then
    do:
/*         assign ll-toolbar = true.                                           */
/*         {&out}                                                              */
/*             tbar-BeginID(lc-invent-TBAR,"")                                 */
/*             tbar-Link("add",?,appurl + '/cust/custequipmnt.p',"customer=" + */
/*                       string(rowid(customer)) + "&returnback=customerview") */
/*             tbar-BeginOptionID(lc-invent-TBAR)                              */
/*                                                                             */
/*             tbar-Link("update",?,"off","")                                  */
/*             tbar-Link("delete",?,"off","")                                  */
/*             tbar-EndOption()                                                */
/*             tbar-End().                                                     */
    end.
    else
    if not dynamic-function("com-IsCustomer",lc-global-company,lc-global-user) then
    do:
        assign ll-toolbar = true.
        {&out}
            tbar-BeginID(lc-invent-TBAR,"")
            tbar-Link("add",?,appurl + '/cust/custequipmnt.p',"customer=" +
                      string(rowid(customer)) + "&returnback=customerview")
            tbar-BeginOptionID(lc-invent-TBAR)

            tbar-Link("update",?,"off","")
 
            tbar-EndOption()
            tbar-End().
  
    end.
   
    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').

    {&out}
            htmlib-TableHeading(
            "Select Inventory|"
            ) skip.

    
    {&out}
        '<tr class="tabrow1">'
        '<td valign="top" nowrap class="tree">' skip
        .
    for each b-query no-lock of customer,
        first ivSub no-lock of b-query,
        first ivClass no-lock of ivSub
        break 
              by ivClass.DisplayPriority desc
              by ivClass.name
              by ivSub.DisplayPriority desc
              by ivSub.name
              by b-query.Ref:

        
        

        assign 
            lc-object = "CLASS" + string(rowid(ivClass))
            lc-subobject = "SUB" + string(rowid(ivSub)).
        if first-of(ivClass.name) then
        do:
            if lc-expand = "yes" 
            then {&out} '<img src="/images/general/menuopen.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">'
                '&nbsp;' '<span style="' ivClass.Style '">' html-encode(ivClass.name) '</span><br>'
                '<div id="' lc-object '" style="padding-left: 15px; display: block;">' skip.
            else {&out}
                '<img src="/images/general/menuclosed.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">'
                '&nbsp;' '<span style="' ivClass.Style '">' html-encode(ivClass.name) '</span><br>'
                '<div id="' lc-object '" style="padding-left: 15px; display: none;">' skip.
        end.

        if first-of(ivSub.name) then
        do:
            
            if lc-expand = "yes"
            then {&out} 
                '<img src="/images/general/menuopen.gif" onClick="hdexpandcontent(this, ~''
                        lc-subobject '~')">'
                '&nbsp;'
                '<span style="' ivSub.Style '">'
                html-encode(ivSub.name) '</span><br>' skip
                '<div id="' lc-subobject '" style="padding-left: 15px; display: block;">' skip.
                
            else {&out} 
                '<img src="/images/general/menuclosed.gif" onClick="hdexpandcontent(this, ~''
                        lc-subobject '~')">'
                '&nbsp;'
                '<span style="' ivSub.Style '">'
                html-encode(ivSub.name) '</span><br>' skip
                '<div id="' lc-subobject '" style="padding-left: 15px; display: none;">' skip.
        end.
       
        ll-htmltrue = false.
        
        {&out} '<a '.

        if b-query.ivSubID = 52 then
        do:
          run ip-SetRDP-O( recid(b-query),
                           output lc-htmlreturn,
                           output ll-htmltrue).
        end.
        else
        if b-query.ivSubID = 73928 then
        do:
          run ip-SetRDP-M( recid(b-query),
                           output lc-htmlreturn,
                           output ll-htmltrue).
        end.
          
        if ll-htmltrue then {&out} ' onclick="javascript:newRDP(~'' + lc-htmlreturn + '~')"  '.
          
        {&out} 'href="'
               "javascript:ahah('" 
               appurl "/cust/custequiptable.p?rowid=" string(rowid(b-query))
               "','inventory');".

        if ll-toolbar then
        do:
            assign lc-update-id = "clx" + string(rowid(b-query)).

            {&out} 'ivtbrowSelect (' lc-update-id ',~'' lc-update-id '~');'. 
        end.
        {&out}
                    '">' html-encode(b-query.ref) '</a><br>' skip.

        if first-RDP then
        do:
          if ll-htmltrue then
          do:
            assign first-RDP = false.
            {&out} '<div id="ScriptDiv" style="visibility:hidden; position:absolute; top:-1px; left:-1px " ></div>'.
            {&out} '<div id="ScriptSet" style="visibility:hidden; position:absolute; top:-1px; left:-1px " > ~n'
                   '<script defer > ~n'
                   '<!-- hide script from old browsers ~n'
                   '   newRDP(~'' + lc-htmlreturn + '~'); ~n'
                   ' --> ~n'
                   '</script></div>~n'.
          end.
        end.

        if ll-toolbar then
        do:
            

            {&out}
                '<div id="' lc-update-id '" style="display: none;">'
                tbar-Link("update",rowid(b-query),appurl + '/cust/custequipmnt.p',"customer=" + string(rowid(customer)) + "&returnback=customerview")
/*                 tbar-Link("delete",rowid(b-query),appurl + '/cust/custequipmnt.p',"customer=" + string(rowid(customer)) + "&returnback=customerview")  */
                '</div>'
                .
        end.
        
        if last-of(ivSub.name) then
        do:
            {&out} '</div>' skip.
        end.

        if last-of(ivClass.name) then
        do:
            {&out} '</div>' skip.
        end.
    end.

    {&out} '</td>' skip.
    {&out} '<td valign="top" rowspan="100" ><div id="inventory">&nbsp;</div></td>'.
    {&out} '</tr>' skip.
    {&out} skip 
           htmlib-EndTable()
           skip.

     if  first-RDP then
     do:
       {&out} '<div id="ScriptSet" style="visibility:hidden; position:absolute; top:-1px; left:-1px " > ~n'
              '<script defer > ~n'
              '<!-- hide script from old browsers   ~n'
              '   function goRDP() ~{ ~n'
              '     alert("No connection information found"); ~n'
              '   ~}   ~n'
              ' --> ~n'
              '</script></div>~n'.
     end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SetRDP-M) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SetRDP-M Procedure 
PROCEDURE ip-SetRDP-M :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param p-recid as recid no-undo.
  def output param p-html         as char initial "~',~'~',~'"  no-undo.
  def output param  p-ok          as log  initial false no-undo.
  def var ou                      as char no-undo.
  def var ip                      as char no-undo.

  find b-custIv where recid(b-custIv) = p-recid no-lock no-error.
  find first b-ivSub of b-custIv no-lock no-error.
  
  find first ivField of b-ivSub
     where ivField.ivFieldID = 73932 no-lock no-error.

  find first CustField
      where CustField.CustIvID = b-custIv.CustIvId
        and CustField.ivFieldId = ivField.ivFieldId
        no-lock no-error.

  if avail CustField then 
  do:
    assign
        ip = trim(CustField.FieldData)
        ou = substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou = ou + substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou = ou + substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou =  ou + TRIM(substr(ip,1,3), "~/,.;:!? ~"~ '[]()abcdefghijklmnopqrstuvwxyz").
        
    if num-entries(ou,".") <> 4 then return.
    else 
    do:
      assign rdpIP = trim(ou)
             p-ok  = true.
      
      find first ivField of b-ivSub
        where ivField.ivFieldID = 73934 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpUser = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
                                     
      find first ivField of b-ivSub
        where ivField.ivFieldID = 73935 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpPWord  = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
                                     
      find first ivField of b-ivSub
        where ivField.ivFieldID = 73933 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpDomain  = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
  
       p-html =  rdpIP + '~',~'' + rdpUser + '~',~'' + rdpDomain.

      end.

    end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SetRDP-O) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SetRDP-O Procedure 
PROCEDURE ip-SetRDP-O :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param p-recid as recid no-undo.
  def output param p-html         as char initial "~',~'~',~'"  no-undo.
  def output param  p-ok          as log  initial false no-undo.
  def var ou                      as char no-undo.
  def var ip                      as char no-undo.


  find b-custIv where recid(b-custIv) = p-recid no-lock no-error.
  find first b-ivSub of b-custIv no-lock no-error.
  
  find first ivField of b-ivSub
     where ivField.ivFieldID = 53 no-lock no-error.
/*   where ivField.ivFieldID = 74870 no-lock no-error.  */

  find first CustField
      where CustField.CustIvID = b-custIv.CustIvId
        and CustField.ivFieldId = ivField.ivFieldId
        no-lock no-error.

  if avail CustField then 
  do:
    assign
        ip = trim(CustField.FieldData)
        ou = substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou = ou + substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou = ou + substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou =  ou + TRIM(substr(ip,1,3), "~/,.;:!? ~"~ '[]()abcdefghijklmnopqrstuvwxyz").
        
    if num-entries(ou,".") <> 4 then return.
    else 
    do:
      assign rdpIP = trim(ou)
             p-ok  = true. 
      
      find first ivField of b-ivSub
        where ivField.ivFieldID = 54 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpUser = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
                                     
      find first ivField of b-ivSub
        where ivField.ivFieldID = 55 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpPWord  = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
                                     
      find first ivField of b-ivSub
        where ivField.ivFieldID = 45619 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpDomain  = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
  
     p-html =  rdpIP + '~',~'' + rdpUser + '~',~'' + rdpDomain.

    end.

  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SLA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SLA Procedure 
PROCEDURE ip-SLA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def buffer slahead  for slahead.
    def var li-loop     as int      no-undo.
    def var lc-rowid    as char     no-undo.


    {&out}
        htmlib-StartMntTable()
        .

    do li-loop = 1 to num-entries(lc-sla-rows,"|"):
        assign
            lc-rowid = entry(li-loop,lc-sla-rows,"|").

        find slahead where rowid(slahead) = to-rowid(lc-rowid) no-lock no-error.
        if not avail slahead then next.
        {&out}
            '<tr>' skip
                replace(htmlib-TableField(html-encode(slahead.description),'left'),
                        '<td',
                        '<td nowrap ')
                htmlib-TableField(replace(slahead.notes,"~n",'<br>') + '<br>','left')
                        
            '</tr>' skip.

    end.
    
        
    {&out} skip 
       htmlib-EndTable()
       skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Tickets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Tickets Procedure 
PROCEDURE ip-Tickets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    
    def buffer b-query      for ticket.
    def buffer IssActivity  for IssActivity.
    def buffer issue        for issue.
        
    def var lc-Issue        as char no-undo.
    def var lc-Activity     as char no-undo.
    def var li-cf           as int  no-undo.


    if not can-find(first b-query
                   where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber no-lock) 
                 then return.

    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="97%"') skip.

    {&out}
            htmlib-TableHeading(
            "Date^right|Type|Reference|Issue Number^right||Activity|Time^right|Carried Forward^right"
            ) skip.


    for each b-query no-lock
        where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber
         :

        assign
            lc-issue = ""
            lc-Activity = ""
            li-cf = li-cf + b-query.Amount.

        if b-query.IssueNumber > 0 then
        do:
            find Issue of b-query no-lock no-error.

            if avail Issue 
            then assign lc-issue = Issue.BriefDescription.
        end.

        if b-query.IssActivityID > 0 then
        do:
            find issActivity where issActivity.issActivityID = 
                                   b-query.IssActivityID no-lock no-error.
            if avail issActivity 
            then assign lc-Activity = issActivity.description.
        end.
        {&out}
            '<tr>' skip
            htmlib-MntTableField(string(b-query.txndate,'99/99/9999'),'right')
            htmlib-MntTableField(html-encode(dynamic-function("com-DescribeTicket",b-query.TxnType)),'left')
            htmlib-MntTableField(html-encode(b-query.Reference),'left')
            htmlib-MntTableField(if b-query.IssueNumber = 0
                                 then "&nbsp;" else string(b-query.IssueNumber),'right')
            htmlib-MntTableField(html-encode(lc-issue),'left')
            htmlib-MntTableField(html-encode(lc-Activity),'left')
            htmlib-MntTableField(dynamic-function("com-TimeToString",b-query.Amount),'right')
            htmlib-MntTableField(dynamic-function("com-TimeToString",li-cf),'right')

            .
            
        {&out}
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
  objtargets:       
------------------------------------------------------------------------------*/
    
    {lib/checkloggedin.i} 

    assign lc-mode = get-value("mode")
           lc-rowid = get-value("rowid")
           lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation").

    assign lc-mode = "view".

    if lc-mode = "" 
    then assign lc-mode = get-field("savemode")
                lc-rowid = get-field("saverowid")
                lc-search = get-value("savesearch")
                lc-firstrow = get-value("savefirstrow")
                lc-lastrow  = get-value("savelastrow")
                lc-navigation = get-value("savenavigation").

    assign lc-parameters = "search=" + lc-search +
                           "&firstrow=" + lc-firstrow + 
                           "&lastrow=" + lc-lastrow.

    assign lc-title = 'View'
           lc-link-label = "Back".
                    
        

    assign lc-title = lc-title + ' Customer'
           lc-link-url = appurl + '/cust/cust.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&time=' + string(time)
                           .

    find customer where rowid(customer) = to-rowid(lc-rowid)
         no-lock no-error.
    if not avail customer then
    do:
        set-user-field("mode",lc-mode).
        set-user-field("title",lc-title).
        set-user-field("nexturl",appurl + "/cust/cust.p").
        RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
        return.
    end.


    assign
        ll-customer = com-IsCustomer(lc-global-company,lc-user).
    
   
    find customer where rowid(customer) = to-rowid(lc-rowid) no-lock.
    
    assign lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,customer.AccountNumber).
   
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
        '<script language="JavaScript" src="/scripts/js/tree.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/prototype.js"></script>' skip
        '<script language="JavaScript" src="/scripts/js/scriptaculous.js"></script>' skip.


    {&out}
         '<script type="text/javascript" src="/scripts/js/tabber.js"></script>' skip
         '<link rel="stylesheet" href="/style/tab.css" TYPE="text/css" MEDIA="screen">' skip
         '<script language="JavaScript" src="/scripts/js/standard.js"></script>' skip
         .

/* 3678 ----------------------> */ 
    {&out}  '<script type="text/javascript" >~n'
            'var pIP =  window.location.host; ~n'
            'function goGMAP(pCODE, pNAME, pADD) ~{~n'
            'var pOPEN = "http://";~n'
            'pOPEN = pOPEN + pIP;~n'
            'pOPEN = pOPEN + ":8090/Gmap.html?postCode=";~n'
            'pOPEN = pOPEN + pCODE;~n'
            'pOPEN = pOPEN + "&Name=";~n'
            'pOPEN = pOPEN + pNAME;~n'
            'pOPEN = pOPEN + "&Address=";~n'
            'pOPEN = pOPEN + pADD;~n'
            /*alert(pOPEN);~n' */ 
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

    {&out} tbar-JavaScript(lc-Doc-TBAR) skip.
    
    {&out} tbar-JavaScript(lc-Issue-TBAR) skip.

    {&out} tbar-JavaScript(lc-invent-TBAR) skip.

    {&out} tbar-JavaScript(lc-cust-TBAR) skip.
    
    {&out} tbar-JavaScript(lc-Asset-TBAR) skip.


    {&out}
         '</HEAD>' skip
         '<body class="normaltext" onUnload="ClosePage()">' skip.

    {&out}
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle(lc-title) skip.

    if get-value("statementsent") = "yes" then
    do:
        {&out} '<div class="infobox">A statement for this customer has been sent to your email address.</div>' skip.
    end.
    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip.
        
    if get-value("source") <> "menu"
    then {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<br>' skip.

    RUN ip-CustomerMainInfo ( customer.CompanyCode, customer.AccountNumber, lc-cust-TBAR ) .
    
    {&out}
        '<div class="tabber">' skip.


    {&out}
        '<div class="tabbertab" title="Inventory">' skip
            .
    RUN ip-Inventory ( customer.CompanyCode, customer.AccountNumber ).
    
    {&out} 
        '</div>'.

    {&out}
        '<div class="tabbertab" title="Open Issues">' skip.
    RUN ip-CustomerOpenIssue ( customer.CompanyCode, customer.AccountNumber, lc-Issue-TBAR ).
    {&out} 
        '</div>'.


    {&out}
        '<div class="tabbertab" title="Documents">' skip
            .
    RUN ip-CustomerDocuments ( customer.CompanyCode, customer.AccountNumber, lc-Doc-TBAR ).

    {&out} 
        '</div>'.

    {&out}
        '<div class="tabbertab" title="Other Details">' skip
            .
    RUN ip-CustomerSecondary ( customer.CompanyCode, customer.AccountNumber ) .
    {&out} 
        '</div>'.


    if DYNAMIC-FUNCTION('com-AllowTicketSupport':U,rowid(customer)) then
    do:
        {&out}
            '<div class="tabbertab" title="Tickets">' skip.
        RUN ip-Tickets ( customer.CompanyCode, customer.AccountNumber ).
        {&out} 
            '</div>'.
    end.

    {&out}
        '<div class="tabbertab" title="Users">' skip.
    RUN ip-CustomerUsers ( customer.CompanyCode, customer.AccountNumber ).
    {&out} 
        '</div>'.

    IF get-value("showtab") = "ASSET" THEN
    {&out}
        '<div class="tabbertab tabbertabdefault" title="Asset">' skip
            .
    ELSE
        {&out}
        '<div class="tabbertab" title="Asset">' skip
            .

    RUN ip-Asset ( customer.CompanyCode, customer.AccountNumber, lc-Asset-TBAR ).
    
    {&out} 
        '</div>'.

    {&out} 
        '</div>' skip.          /* end tabber */


    {&out} htmlib-Hidden("source", get-value("source")) skip.

    if get-value("showpdf") <> "" then
    do:
        {&out} '<script>' skip
            "OpenNewWindow('"
                    appurl "/rep/viewpdf3.pdf?PDF=" 
                    url-encode(get-value("showpdf"),"query") "')" skip
            '</script>' skip.
    end.

    IF ll-customer THEN
    DO:
        {&out} htmlib-mBanner(customer.CompanyCode).
            
    END.
    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

