&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        rep/ajax/reportview.p
    
    Purpose:        Management Report - Ajax Web Page - Display Reports
    
    Notes:
    
    
    When        Who         What
    10/11/2010  DJS         Initial
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var li-total    as int      no-undo.

def temp-table tt  like BatchWork
  field ttrowid     as rowid .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCreate Procedure 
FUNCTION fnCreate RETURNS LOGICAL
  ( pc-ID as char,
    pc-ADescription as char )  FORWARD.

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
         WIDTH              = 37.
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

&IF DEFINED(EXCLUDE-ip-BuildAnalysis) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-BuildAnalysis Procedure 
PROCEDURE ip-BuildAnalysis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer Issue        for Issue.
    def buffer WebStatus    for WebStatus.
    def buffer Customer     for Customer.
    
    for each BatchWork no-lock
      where  BatchWork.BatchUser      = lc-global-user
      and    BatchWork.BatchParams[1] = lc-global-company
      by BatchWork.batchID descending
      :

        if BatchWork.BatchRun then assign li-total = li-total + 1.

        create tt.
        buffer-copy BatchWork to tt.
        assign ttrowid = rowid(BatchWork).
         

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-displaydocs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-displaydocs Procedure 
PROCEDURE ip-displaydocs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   {&out}
            tbar-Begin("")
            tbar-BeginOption()
            tbar-Link("statement",?,"off","")
            tbar-Link("documentview",?,"off","")
            tbar-Link("delete",?,"off","")
            tbar-EndOption()
            tbar-End().
    
/*    {&out} ' <div id="displaydet" style="display:none;margin-left:auto;margin-right:auto;top:100px" ><div>' skip.  */

   {&out} '<script language="javascript">' skip
         'function ConfirmDelete(DocID) ~{' skip
         '     alert("YEP"); ' skip
         '~}' skip                
         '</script>' skip.
    {&out} skip
          htmlib-StartMntTable().
    {&out}
           htmlib-TableHeading(
           "Date|Time|By|Description"   /* 3674 */ 
           ) skip.

    for each tt no-lock:

        {&out}
            skip
            tbar-tr(rowid(tt))
            skip
            htmlib-MntTableField(string(tt.BatchDate,"99/99/9999"),'left')
            htmlib-MntTableField(string(tt.BatchTime,"hh:mm am"),'left')
            htmlib-MntTableField(html-encode(dynamic-function("com-UserName",lc-global-user)),'left')
            htmlib-MntTableField(tt.description,'left')
            htmlib-MntTableField(if tt.BatchRun then 'Completed' else 'Running','left')
            htmlib-MntTableField(if tt.BatchDelete then 'Deleting' else ' ','left')
            tbar-BeginHidden(rowid(tt))  
                 tbar-Link("statement",rowid(tt),  if tt.BatchRun then     
                          'javascript:OpenNewWindow('                                    
                          + '~'' + appurl 
                          + '/rep/displayview.p' 
                          + '?docid=' + string(tt.ttrowid)
                          + '~'' 
                          + ');' else 'off'
                          ,"")  
                 tbar-Link("documentview",rowid(tt),  if tt.BatchRun then                                
                          'javascript:OpenNewWindow('                                    
                          + '~'' + appurl 
                          + '/rep/reportview.' 
                          + lc("xls") + '?docid=' + string(string(tt.batchID) + "_" + tt.description)
                          + '~'' 
                          + ');' else 'off'
                          ,"")
/*                  tbar-Link("delete",tt.ttrowid ,  if tt.BatchRun then               */
/*                           'javascript:OpenNewWindow('                               */
/*                           + '~'' + appurl                                           */
/*                           + '/rep/deleteview.p?rowid=' + string(tt.ttrowid) + ' ~'' */
/*                           + ');' else 'off'                                         */
/*                           ,"")                                                      */




                 tbar-Link("delete",tt.ttrowid, if tt.BatchRun then  appurl + '/rep/deleteview.p' else 'off' ,"")

            tbar-EndHidden() skip

            '</tr>' skip.

    end.

    {&out} skip 
           htmlib-EndTable()
           skip.

/*   {&out} htmlib-EndForm() skip */
/*          htmlib-Footer() skip. */


    
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
  
    {lib/checkloggedin.i}
    
    RUN outputHeader.
    
    RUN ip-BuildAnalysis.

    {&out} '<div id="overview" style="display: block;">' skip.
    {&out} '<div class="loglink">'.

    {&out} '<p style="text-align: center; font-weight: 900;">' skip.

if li-total = 0
  then {&out} 'There are no reports to display.' skip.
  else {&out} 'There are currently ' li-Total ' reports available (' string(today,'99/99/9999') ' - ' string(time,'hh:mm am') ')' skip.
  
    {&out} '</p></div>'.

    {&out} '<table border=0 width=98% align="center">'.

    {&out} '<tr><td valign="top">'.

    RUN ip-displaydocs.

    {&out} '</td></tr>'.

    {&out} '</table></div>'.


    {&out} '</div>'.





END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCreate Procedure 
FUNCTION fnCreate RETURNS LOGICAL
  ( pc-ID as char,
    pc-ADescription as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    find tt where tt.Batchid    = integer(pc-ID)
               exclusive-lock no-error.
    if not avail tt then
    do:
        create tt.
        assign tt.Batchid    = integer(pc-ID)
               tt.Description = pc-ADescription.
    end.

/*     assign                         */
/*         tt.ACount = tt.Acount + 1. */
    return true.
 
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

