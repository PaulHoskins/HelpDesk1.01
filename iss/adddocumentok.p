&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        iss/adddocumentok.p
    
    Purpose:        Issue Document Upload 
    
    Notes:
    
    
    When        Who         What
    09/04/2006  phoski      Initial
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


def var lc-type as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.

def var lc-relkey   as char no-undo.
def var lc-thefile  as char no-undo.

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

    def var li-docid    like doch.docid no-undo.
    def var lr-raw      as raw          no-undo.
    def var li-line     as int          no-undo.
    def var lc-problem  as char         no-undo.
    def var li-size     as int          no-undo.
    def var lc-command  as char         no-undo.
    def var lc-source   as char         no-undo.
    def var lc-dest     as char         no-undo.
    def var lc-cview    as char         no-undo.


    def var lc-ext   as char no-undo.
    
    assign lc-type = get-value("type")
           lc-rowid = get-value("rowid")
           lc-thefile = get-value("thefile")
           lc-cview   = get-value("custview").
    
    assign lc-thefile = replace(lc-thefile," ","").
    
    assign
        lc-dest   = "c:/helpdeskupload"
        /* lc-source = "https://" + server_name + "/hdupload/" + lc-thefile
        */
        lc-source = HostURL + "/hdupload/" + lc-thefile
        .


    os-create-dir value(lc-dest).

    assign lc-command = "c:/wget/wget --directory-prefix=" + lc-dest +
                        " " + lc-source + " --no-check-certificate".

    
    os-command silent value(lc-command).
    
    
    assign lc-thefile = lc-dest + "/" + lc-thefile.
       
    case lc-type:
        when "customer" then
        do:
            find customer where rowid(customer) = to-rowid(lc-rowid) no-lock
                 no-error.
            assign lc-relkey = customer.accountnumber.

        end.
        when "issue" then
        do:
            find issue where rowid(issue) = to-rowid(lc-rowid) no-lock no-error.
            assign lc-relkey = string(issue.issuenumber).


        end.
    end case.

    
    if search(lc-thefile) = ? then
    do:
        assign lc-problem = "The document could not be transferred".
    end.
    
    assign lc-ext = substr(lc-thefile,index(lc-thefile,".") + 1) no-error.

    if error-status:error then
    do:
        assign lc-problem = "The document type is unknown, the document was not uploaded".
    end.
    else
    if can-do(lc-global-excludeType,lc-ext) then 
    do:
        assign lc-problem = "This type of document can not be uploaded".    
    end.

    if lc-problem = "" then
    do:
        file-info:file-name = lc-thefile.
        li-size = file-info:file-size.
        if li-size = 0 
        then assign lc-problem = "The document is empty, the document was not uplaoded".

    end.
    
    if lc-problem = "" then
    repeat:
        li-docid = next-value(docid).
        if can-find(doch where doch.docid = li-docid no-lock) then next.
        create doch.
        assign doch.docid = li-docid
              doch.CreateBy = lc-user
              doch.CreateDate = today
              doch.CreateTime = time
              doch.RelType = lc-type
              doch.RelKey  = lc-relkey
              doch.CompanyCode = lc-global-company
              doch.DocType = caps(lc-ext)
              doch.InBytes = li-size
              doch.CustomerView = lc-cview = "on".

        assign 
              doch.descr = get-value("comment")
              .


        assign length(lr-raw) = 16384.
        input from value(lc-thefile) binary no-map no-convert.
        repeat:
            import unformatted lr-raw.
            assign li-line = li-line + 1.
            create docl.
            assign docl.DocID = li-DocID
                   docl.Lineno  = li-line
                   docl.rdata    = lr-raw.
               
        end.
        input close.
        assign length(lr-raw) = 0.

        os-delete value(lc-thefile). 
        
        leave.

   end.
   else set-user-field("problem",lc-problem).


   set-user-field("mode","refresh").
   set-user-field("rowid",lc-rowid).
   
   if lc-problem <> "" then
   do:
       assign request_method = "GET".
       RUN run-web-object IN web-utilities-hdl ("iss/adddocument.p").
       return.
   end.

   RUN outputHeader.
     
   {&out} '<html>' skip
        '<script language="javascript">' skip
                    'var ParentWindow = opener' skip
                    'ParentWindow.documentCreated()' skip
                    '</script>' skip
        '<body><h1>Document Loaded</h1></body></html>'.

   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

