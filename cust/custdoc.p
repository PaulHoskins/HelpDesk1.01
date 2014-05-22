&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        cust/custdoc.p
    
    Purpose:        Customer - Documents         
    
    Notes:
    
    
    When        Who         What
    09/04/2006  phoski      Initial
    10/04/2006  phoski      CompanyCode
    
    02/09/2010  DJS         3674 - Added Quickview facility

***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.


def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.


def buffer b-valid for customer.
def buffer b-table for customer.
def buffer b-query  for doch.


def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.
def var lc-subaction    as char no-undo.
def var lc-deleterow    as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.

def var lc-type         as char 
    initial "CUSTOMER"  no-undo.

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

    

    if request_method = "POST" and can-do("DELETE,TOGGLE,TOGGLEQ",get-value("subaction")) = false then  /* 3674 */
    do:
        RUN outputHeader.
        set-user-field("navigation",'refresh').
        set-user-field("firstrow",lc-firstrow).
        set-user-field("search",lc-search).
        RUN run-web-object IN web-utilities-hdl ("cust/cust.p").
        return.
 
    end.
  

    
    if get-value("subaction") = "delete" and request_method = "POST" then
    do:
        find b-query where b-query.DocID = int(get-value("deleteid")) exclusive-lock no-error.
        if avail b-query then
        do:
            message "Delete id = " b-query.DocID.
            for each docl of b-query exclusive-lock:
                delete docl.
            end.
            delete b-query.
        end.
    end.
    else
    if get-value("subaction") = "toggle" and request_method = "POST" then
    do:
        find b-query where b-query.DocID = int(get-value("toggleid")) exclusive-lock no-error.
        if avail b-query 
        then assign b-query.CustomerView = not b-query.CustomerView.
    end.
    if get-value("subaction") = "toggleQ" and request_method = "POST" then                      /* 3674 */
    do:                                                                                         /* 3674 */
        find b-query where b-query.DocID = int(get-value("toggleQid")) exclusive-lock no-error. /* 3674 */  
        if avail b-query                                                                        /* 3674 */  
        then assign b-query.QuickView = not b-query.QuickView.                                  /* 3674 */  
    end.                                                                                        /* 3674 */  

    find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.

    assign lc-title = 'Documents For ' +
                       html-encode(b-table.AccountNumber + " " + 
                                   b-table.name).
                    


    assign
        lc-link-label = "Back"
        lc-link-url = appurl + '/cust/cust.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&time=' + string(time)
                           .
    
    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip.

    
     {&out} '<script language="javascript">' skip.

    {&OUT}
        'function MntButtonPress(ButtonEvent,NewURL) ~{':U SKIP
        'this.location = NewURL':U SKIP
        '~}':U SKIP
        'function ConfirmDelete(DocID) ~{' skip
        '   if (confirm("Are you sure you want to delete this document?")) ~{' skip
        '   document.mainform.elements["subaction"].value = "delete";' skip
        '   document.mainform.elements["deleteid"].value = DocID;' skip
        '   document.mainform.submit();' skip
        '   ~}' skip
        '~}' skip
        'function ToggleCustomerView(DocID) ~{' skip
        '   document.mainform.elements["subaction"].value = "toggle";' skip
        '   document.mainform.elements["toggleid"].value = DocID;' skip
        '   document.mainform.submit();' skip
        '~}' skip
        'function ToggleQuickView(DocID) ~{' skip                                                 /* 3674 */ 
        '   document.mainform.elements["subaction"].value = "toggleQ";' skip                      /* 3674 */ 
        '   document.mainform.elements["toggleQid"].value = DocID;' skip                          /* 3674 */ 
        '   document.mainform.submit();' skip                                                     /* 3674 */ 
        '~}' skip                                                                                 /* 3674 */ 
        '</script>' skip.                                                                         
    


    {&out}
           htmlib-StartForm("mainform","post", appurl + "/cust/custdoc.p" )
           htmlib-ProgramTitle(lc-title) skip.

    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip.
        
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.

  
    if get-value("problem") <> "" then
    do:
        {&out} '<div class="infobox">' get-value("problem") '</div>' skip.
    end.
    {&out}
            tbar-Begin(
                ""
                )
            tbar-Link("add",?,appurl + '/sys/docup.p',"type=" +
                      lc-type + "&ownerrowid=" + lc-rowid)
            tbar-BeginOption()
            tbar-Link("delete",?,"off","")
            tbar-Link("customerview",?,"off","")
            tbar-Link("quickview",?,"off","")   /* 3674 */ 
            tbar-Link("documentview",?,"off","")
            tbar-EndOption()
            tbar-End().

    {&out} skip
          htmlib-StartMntTable().
    {&out}
           htmlib-TableHeading(
           "Date|Time|By|Description|Customer View|Quick View|Type|Size (KB)^right"   /* 3674 */ 
           ) skip.

    for each b-query no-lock
        where b-query.CompanyCode = lc-global-company
          and b-query.RelType = "customer"
          and b-query.RelKey  = b-table.AccountNumber:

        {&out}
            skip
            tbar-tr(rowid(b-query))
            skip
            htmlib-MntTableField(string(b-query.CreateDate,"99/99/9999"),'left')
            htmlib-MntTableField(string(b-query.CreateTime,"hh:mm am"),'left')
            htmlib-MntTableField(html-encode(dynamic-function("com-UserName",b-query.CreateBy)),'left')
            htmlib-MntTableField(b-query.descr,'left')
            htmlib-MntTableField(if b-query.CustomerView then 'Yes' else 'No','left')
            htmlib-MntTableField(if b-query.Quickview then 'Yes' else 'No','left') /* 3674 */ 
            htmlib-MntTableField(b-query.DocType,'left')
            htmlib-MntTableField(string(round(b-query.InBytes / 1024,2)),'right')
            tbar-BeginHidden(rowid(b-query))
                tbar-Link("delete",rowid(b-query),
                          'javascript:ConfirmDelete(' + string(b-query.docid) + ');',
                          "")
                 tbar-Link("customerview",rowid(b-query),
                          'javascript:ToggleCustomerView(' + string(b-query.docid) + ');',
                          "")
                 tbar-Link("quickview",rowid(b-query),                                    /* 3674 */   
                          'javascript:ToggleQuickView(' + string(b-query.docid) + ');',   /* 3674 */   
                          "")                                                             /* 3674 */   
                 tbar-Link("documentview",rowid(b-query),                                 
                          'javascript:OpenNewWindow('                                    
                          + '~'' + appurl 
                          + '/sys/docview.' 
                            + lc(b-query.DocType) + '?docid=' + string(b-query.docid)
                          + '~'' 
                          + ');'
                          ,"")
                
            tbar-EndHidden()
            '</tr>' skip.

    end.

    {&out} skip 
           htmlib-EndTable()
           skip.

    {&out}
            htmlib-Hidden("subaction","")
            htmlib-Hidden("deleteid","")
            htmlib-Hidden("toggleid","")
            htmlib-Hidden("toggleQid","").   /* 3674 */ 


    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

