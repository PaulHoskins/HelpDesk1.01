&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        mail/monitor.p
    
    Purpose:        Mail Monitor - Email2DB post
    
    Notes:
    
    
    When        Who         What
    14/07/2006  phoski      Initial
       
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


{lib/common.i}
{lib/maillib.i}

  DEF STREAM djs.
def var lc-from         as char no-undo.
def var lc-to           as char no-undo.
def var lc-subject      as char no-undo.
def var lc-body         as char no-undo.
def var lc-attachdir    as char no-undo.
def var lc-attachfile   as char no-undo.
def var lc-html         as char no-undo.
def var lc-date         as char no-undo.

def var lc-epulse-cstring as char initial
    "THIS REPORT HAS BEEN SENT TO THE CLIENT:"
    no-undo.

def var lc-epulse-error-begin   as char initial
        "Status : Error" no-undo.

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
         WIDTH              = 61.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-Decode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Decode Procedure 
PROCEDURE ip-Decode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-subject  as char     no-undo.

    def output param pc-AccountNumber   as char no-undo.

    def var li-one  as int      no-undo.
    def var li-two  as int      no-undo.
    def var lc-temp as char     no-undo.

    assign
        li-one = index(pc-subject,"-").

    if li-one = 0 then leave.

    assign
        li-two = index(pc-subject,"-",li-one + 1).

    if li-two = 0 then leave.

    assign
        lc-temp = substr(pc-subject,li-one + 1,
                         ( li-two - li-one ) - 1) no-error.

    lc-temp = trim(lc-temp).

    pc-AccountNumber = lc-temp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ProcessEmail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ProcessEmail Procedure 
PROCEDURE ip-ProcessEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def buffer b        for EmailH.
    def buffer WebUser  for WebUser.

    def var li-loop             as int  no-undo.
    def var lc-file             as char no-undo.
    def var lc-title            as char no-undo.
    def var lc-AccountNumber    as char no-undo.
    def var lc-msg              as char no-undo.
    
    def var li-year             as int  no-undo.
    def var li-month            as int  no-undo.
    def var li-day              as int  no-undo.
    def var ld-date             as date no-undo.


    def var lf-EmailID      like    EmailH.EmailID      no-undo.

    find company where company.CompanyCode = lc-global-company no-lock no-error.



    repeat transaction on error undo , leave:



        RUN ip-Decode ( lc-subject, output lc-AccountNumber).
            
        if lc-AccountNumber <> "" then 
        do:
            find customer where customer.companycode = lc-global-company
                            and customer.accountNumber = lc-AccountNumber
                            no-lock no-error.
            
            if not avail Customer
            then lc-AccountNumber = "".
        end.
PUT STREAM djs UNFORMATTED "Customer: "  lc-AccountNumber SKIP.
PUT STREAM djs UNFORMATTED "Customer: "  lc-body SKIP.

        
        if index(lc-body,"Status : Error") = 0 then leave.

        ld-date = ?.
       
        if lc-date <> "" then
        do:
            assign li-year = int(substr(lc-date,1,4)) no-error.
            if error-status:error 
            then li-year = 0.

            assign li-month = int(substr(lc-date,6,2)) no-error.
            if error-status:error
            then li-month = 0.

            assign li-day = int(substr(lc-date,9,2)) no-error.
            if error-status:error
            then li-day = 0.

            if li-year <> 0
            and li-month <> 0
            and li-day <> 0 then
            do:
                ld-date = date(li-month,li-day,li-year) no-error.
                if error-status:error
                then ld-date = ?.
            end.


        end.
        

        if ld-date = ?
        then ld-date = today.

        find last b no-lock no-error.

        assign
            lf-EmailID = if avail b then b.EmailID + 1 else 1.
        create b.
        assign 
            b.CompanyCode = lc-global-company
            b.EmailID     = lf-EmailID.

        assign
            b.Email       = lc-from
            b.mText       = lc-body
            b.Subject     = lc-Subject
            b.RcpDate     = ld-date
            b.RcpTime     = time.
            b.AccountNumber = lc-AccountNumber.

        {&out} skip
            'Created msg ' lf-EmailID.
        leave.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-UploadAttachment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-UploadAttachment Procedure 
PROCEDURE ip-UploadAttachment :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pf-EmailID      like EmailH.EmailID     no-undo.
    def input param pc-FileName     as char                 no-undo.
    def input param pc-Title        as char                 no-undo.
    
    def var li-docid    like doch.docid no-undo.
    def var lr-raw      as raw          no-undo.
    def var li-line     as int          no-undo.
    def var li-size     as int          no-undo.
    


    def var lc-ext   as char no-undo.
    def var lc-valid as char initial
            "zip,doc,dot,xlt,xls,ppt,pdf,htm,html,txt,ini,d,df,xml,png,gif,jpg,jpeg,jpe,png" no-undo.


    assign lc-ext = substr(pc-FileName,r-index(pc-FileName,".") + 1) no-error.

    if error-status:error then return.
    
    if can-do(lc-valid,lc-ext) = false then return.
    
    file-info:file-name = pc-FileName.
    li-size = file-info:file-size.
    if li-size = 0 
    then return.
    
    repeat:
        li-docid = next-value(docid).
        if can-find(doch where doch.docid = li-docid no-lock) then next.
        create doch.
        assign doch.docid = li-docid
              doch.CreateBy = "EMAIL"
              doch.CreateDate = today
              doch.CreateTime = time
              doch.RelType = "EMAIL"
              doch.RelKey  = string(pf-EmailID)
              doch.CompanyCode = lc-global-company
              doch.DocType = caps(lc-ext)
              doch.InBytes = li-size.

        assign 
              doch.descr = pc-title
              .


        assign length(lr-raw) = 16384.
        input from value(pc-FileName) binary no-map no-convert.
        repeat:
            import unformatted lr-raw.
            assign li-line = li-line + 1.
            create docl.
            assign docl.DocID = li-DocID
                   docl.Lineno  = li-line
                   docl.rdata    = lr-raw.
               
        end.
        input close.
        os-delete value(pc-filename) no-error.
        assign length(lr-raw) = 0.

        leave.

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
    OUTPUT STREAM djs  TO "c:\temp\epulse.log" APPEND.
  PUT STREAM djs UNFORMATTED "START --------------------------------------" SKIP.

    assign
        lc-from         = get-value("from")
        lc-to           = get-value("to")
        lc-subject      = get-value("subject")
        lc-body         = get-value("body")
        lc-attachdir    = get-value("attachdir")
        lc-attachfile   = get-value("attachfile")
        lc-date         = get-value("msgdate").
        .
    
    PUT STREAM djs UNFORMATTED "EMAIL: " SKIP.

PUT STREAM djs UNFORMATTED  "lc-from       " lc-from     SKIP.     
PUT STREAM djs UNFORMATTED  "lc-to         " lc-to       SKIP.         
PUT STREAM djs UNFORMATTED  "lc-subject    " lc-subject  SKIP.         
PUT STREAM djs UNFORMATTED  "lc-body       " lc-body     SKIP.            
PUT STREAM djs UNFORMATTED  "lc-date       " lc-date    SKIP.          




    RUN outputHeader.
    
    
    
    assign
        lc-global-company = "OURITDEPT".

   
    {&out} string(time,"hh:mm:ss") " mail monitor received from "
            lc-from " to " lc-to " for company " lc-global-company
            " subject " lc-subject 
            .

    if lc-global-company <> "" 
    and lc-from <> ""
    then RUN ip-ProcessEmail.
    
   PUT STREAM djs UNFORMATTED "END --------------------------------------" SKIP(2).
   OUTPUT STREAM djs  CLOSE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

