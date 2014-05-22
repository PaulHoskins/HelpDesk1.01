&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/ajax/document.p
    
    Purpose:        Issue Documents       
    
    Notes:
    
    
    When        Who         What
    03/05/2006  phoski      Initial
    

***********************************************************************/
CREATE WIDGET-POOL.


def var lc-rowid        as char no-undo.
def var lc-toolbarid    as char no-undo.
def var lc-toggle       as char no-undo.


def buffer b-table for issue.
def buffer b-query  for doch.

def var lc-type         as char 
    initial "ISSUE"  no-undo.

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
         HEIGHT             = 14.14
         WIDTH              = 60.6.
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
    
    {lib/checkloggedin.i} 
    
    assign
        lc-rowid = get-value("rowid")
        lc-toolbarid = get-value("toolbarid").
    

    find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.

   
    assign
        lc-toggle = get-value("toggle").

    if lc-toggle <> "" then
    do:
        find b-query
            where b-query.DocID = int(lc-toggle) exclusive-lock no-error.

        if avail b-query
        then assign b-query.CustomerView = not b-Query.CustomerView.
    end.
    
    RUN outputHeader.
    
    {&out} skip
          replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').

    if dynamic-function("com-isCustomer",b-table.companycode,lc-user) = true
    then {&out}
           htmlib-TableHeading(
           "Date|Time|By|Description|Type|Size (KB)^right"
           ) skip.
    else {&out}
           htmlib-TableHeading(
           "Date|Time|By|Description|Customer View?|Type|Size (KB)^right"
           ) skip.

    for each b-query no-lock
        where b-query.CompanyCode = b-table.CompanyCode
          and b-query.RelType = "issue"
          and b-query.RelKey  = string(b-table.IssueNumber):

        if dynamic-function("com-isCustomer",b-table.companycode,lc-user)
        and b-query.CustomerView = false then next.

        {&out}
            skip(1)
            tbar-trID(lc-ToolBarID,rowid(b-query))
            skip(1)
            htmlib-MntTableField(string(b-query.CreateDate,"99/99/9999"),'left')
            htmlib-MntTableField(string(b-query.CreateTime,"hh:mm am"),'left')
            htmlib-MntTableField(html-encode(dynamic-function("com-UserName",b-query.CreateBy)),'left')
            htmlib-MntTableField(b-query.descr,'left').

        if dynamic-function("com-isCustomer",b-table.CompanyCode,lc-user) = false
        then {&out} htmlib-MntTableField(if b-query.CustomerView then 'Yes' else 'No','left').

       
        {&out}
            htmlib-MntTableField(b-query.DocType,'left')
            htmlib-MntTableField(string(round(b-query.InBytes / 1024,2)),'right')
            tbar-BeginHidden(rowid(b-query))
            /*
                tbar-Link("documentview",rowid(b-query),appurl + '/sys/docview.p',"docid=" + string(b-query.docid))
            */
                tbar-Link("delete",rowid(b-query),
                          'javascript:ConfirmDeleteAttachment(' +
                          "ROW" + string(rowid(b-query)) + ','
                          + string(b-query.docid) + ');',
                          "")
                tbar-Link("customerview",rowid(b-query),
                          'javascript:CustomerView(' +
                          "ROW" + string(rowid(b-query)) + ','
                          + string(b-query.docid) + ');',
                          "")
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

   
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

