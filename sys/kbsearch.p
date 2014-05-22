&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/kbsearch.p
    
    Purpose:        KB Search
    
    Notes:
    
    
    When        Who         What
    01/08/2006  phoski      Initial
     
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

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
def var lc-nopass       as char no-undo.

def var lc-code     as char no-undo.
def var lc-desc     as char no-undo.
def var lc-knbcode  as char no-undo.
def var lc-type     as char no-undo.

def var lc-type-code    as char
    initial "T|I|C"     no-undo.
def var lc-type-desc    as char
    initial "Title|Text|Both Title And Text" no-undo.


def buffer b-query for knbtext.
def buffer b-search for knbtext.
def query q for b-query scrolling.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnText Procedure 
FUNCTION fnText RETURNS CHARACTER
  ( pf-knbid as dec,
    pi-count as int )  FORWARD.

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

&IF DEFINED(EXCLUDE-ip-Search) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Search Procedure 
PROCEDURE ip-Search :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def buffer knbItem      for knbitem.
    def buffer knbSection   for knbSection.

    
    if lc-knbCode = "ALL" then
    open query q for each b-query no-lock
        where b-query.dData contains lc-search
          and b-query.dType = lc-type
          and b-query.companycode = lc-global-company.
    else 
    open query q for each b-query no-lock
        where b-query.dData contains lc-search
          and b-query.dType = lc-type
          and b-query.companycode = lc-global-company
          and b-query.knbcode = lc-knbCode.

    {&out}
            tbar-Begin(
                ""
                )
            tbar-BeginOption()
            tbar-Link("view",?,"off",lc-link-otherp)
            
            tbar-EndOption()
            tbar-End().

    
    {&out} skip
           htmlib-StartMntTable().

    {&out}
            htmlib-TableHeading(
            "Title|Section|Ref"
            ) skip.

    get first q no-lock.

    if lc-navigation = "nextpage" then
    do:
        reposition q to rowid to-rowid(lc-lastrow) no-error.
        if error-status:error = false then
        do:
            get next q no-lock.
            get next q no-lock.
            if not avail b-query then get first q no-lock.
        end.
    end.
    else
    if lc-navigation = "prevpage" then
    do:
        reposition q to rowid to-rowid(lc-firstrow) no-error.
        if error-status:error = false then
        do:
            get next q no-lock.
            reposition q backwards li-max-lines + 1.
            get next q no-lock.
            if not avail b-query then get first q no-lock.
        end.
    end.
    else
    if lc-navigation = "refresh" then
    do:
        reposition q to rowid to-rowid(lc-firstrow) no-error.
        if error-status:error = false then
        do:
            get next q no-lock.
            if not avail b-query then get first q no-lock.
        end.  
        else get first q no-lock.
    end.

    assign li-count = 0
           lr-first-row = ?
           lr-last-row  = ?.


    repeat while avail b-query:
        
        assign lc-rowid = string(rowid(b-query)).
        
        assign li-count = li-count + 1.
        if lr-first-row = ?
        then assign lr-first-row = rowid(b-query).
        assign lr-last-row = rowid(b-query).
        
        assign lc-link-otherp = 'search=' + lc-search +
                                '&firstrow=' + string(lr-first-row).

        find knbItem where knbItem.knbID = b-query.knbID no-lock no-error.
        find knbSection of knbItem no-lock no-error.
       
        {&out}
            skip
            tbar-tr(rowid(b-query))
            skip(4)
            htmlib-MntTableField(html-encode(knbItem.kTitle)
                                 + '<br>' 
                                 + '<div class="hi">'
                                 + DYNAMIC-FUNCTION('fnText':U,b-query.knbId,5)
                                 + '</div>','left')
            skip(4)
            htmlib-MntTableField(html-encode(knbSection.description),'left')
            htmlib-MntTableField(html-encode(string(b-query.knbID)),'left')
            
            skip
                tbar-BeginHidden(rowid(b-query))
                tbar-Link("view",rowid(b-query),
                          'javascript:HelpWindow('
                          + '~'' + appurl 
                          + '/sys/kbview.p?rowid=' + string(rowid(b-query)) +
                            '&search=' + url-encode(lc-search,"")
                          + '~'' 
                          + ');'
                          ,lc-link-otherp)
                
                tbar-EndHidden()
                skip
               '</tr>' skip.
             
            
       

        if li-count = li-max-lines then leave.

        get next q no-lock.
            
    end.

    if li-count < li-max-lines then
    do:
        {&out} skip htmlib-BlankTableLines(li-max-lines - li-count) skip.
    end.

    {&out} skip 
           htmlib-EndTable()
           skip.

    
    if lr-first-row = ? 
    then lc-error-mess = "No entries where found".

    {lib/navpanel.i "sys/kbsearch.p"}

    
    {&out} 
        '<div id="urlinfo">|type=' lc-type "|knbcode=" lc-knbcode '</div>'.
    {&out} skip
           htmlib-Hidden("firstrow", string(lr-first-row)) skip
           htmlib-Hidden("lastrow", string(lr-last-row)) skip
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

   
    assign lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation").
    
    assign lc-parameters = "search=" + lc-search +
                           "&firstrow=" + lc-firstrow + 
                           "&lastrow=" + lc-lastrow.

    
    
    assign lc-char = htmlib-GetAttr('system','MNTNoLinesDown').
    
    assign li-max-lines = int(lc-char) no-error.
    if error-status:error
    or li-max-lines < 1
    or li-max-lines = ? then li-max-lines = 12.

    assign
        li-max-lines = 5.

    run com-GetKBSection(lc-global-company,
                         output lc-code,
                         output lc-desc).

    assign 
        lc-code = "ALL|" + lc-code
        lc-desc = "All Sections|" + lc-desc.

    assign
        lc-knbcode = get-value("knbcode")
        lc-type    = get-value("type").


    RUN outputHeader.
    
    {&out} htmlib-Header("KB Search") skip.

    {&out}
        '<style>' skip
           '.hi ~{ color: red; font-size: 10px; margin-left: 15px; font-style: italic;~}' skip
           '</style>' skip.

    {&out} htmlib-JScript-Maintenance() skip.

    {&out} htmlib-StartForm("mainform","post", appurl + '/sys/kbsearch.p' ) skip.

    {&out} htmlib-ProgramTitle("KB Search") skip.
    

    {&out} htmlib-BeginCriteria("Search Issues").

    {&out} '<table align=center>' skip.

    {&out}
           '<tr>'
           '<td align=right valign=top>' htmlib-SideLabel("Search For") '</td>'
           '<td align=left valign=top>' 
                htmlib-InputField("search",80,lc-search) '</td></tr>' 
            skip.
    {&out}
           '<tr>'
           '<td align=right valign=top>' htmlib-SideLabel("In Sections") '</td>'
           '<td align=left valign=top>' 
                htmlib-Select("knbcode",lc-code,lc-desc,lc-knbcode)
            skip.

     {&out}
           '<tr>'
           '<td align=right valign=top>' htmlib-SideLabel("Search In") '</td>'
           '<td align=left valign=top>' 
                htmlib-Select("type",lc-type-code,lc-type-desc,lc-type)
            skip.

    {&out} '</table>'.

    /*
    {&out} '<p>'
                'Method= ' request_method '<br>'
                'Search= ' lc-search '<br>'
                'First = ' lc-firstrow '<br>'
                'Last  = ' lc-lastrow '<br>'
                'Nav   = ' lc-navigation '<br>'
                'Sect  = ' lc-knbcode '<br>'
                'Type  = ' lc-type '<br>'
            '</p>'.
     */       
    {&out} '<center>' htmlib-SubmitButton("submitform","Search") 
               '</center>' skip.
    

    {&out} htmlib-EndCriteria().

    if lc-search <> "" then
    do:
        RUN ip-Search.
    end.
    else 
    if request_method = "post"
    then lc-error-mess = "You must select something to search for".

    

    if lc-error-mess <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-mess) '</CENTER>' skip.
    end.

    {&out} htmlib-EndForm().

    
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnText Procedure 
FUNCTION fnText RETURNS CHARACTER
  ( pf-knbid as dec,
    pi-count as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer knbText  for knbText.  
    def var li-count    as int no-undo.
    def var li-found    as int no-undo.
    def var lc-return   as char no-undo.
    def var lc-char     as char no-undo.

    find knbText where knbText.knbID = pf-knbID
                   and knbText.dType = "I" no-lock no-error.
    if not avail knbText then return "&nbsp;".


    do li-count = 1 to num-entries(knbText.dData,"~n"):

        assign lc-char = entry(li-count,knbText.dData,"~n").
        if trim(lc-char) = "" then next.

       
        if li-found = 0
        then assign lc-return = right-trim(lc-char).
        else assign lc-return = lc-return + "<br>" + right-trim(lc-char).

        assign li-found = li-found + 1.

        if li-found = pi-count then leave.

    end.

    return lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

