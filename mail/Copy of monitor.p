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


def var lc-from         as char no-undo.
def var lc-to           as char no-undo.
def var lc-subject      as char no-undo.
def var lc-body         as char no-undo.
def var lc-attachdir    as char no-undo.
def var lc-attachfile   as char no-undo.
def var lc-html         as char no-undo.

def var lc-epulse-cstring as char initial
    "THIS REPORT HAS BEEN SENT TO THE CLIENT: Our IT Dept -"
    no-undo.

def var lc-epulse-error-begin   as char initial
        "<http://dashboard.hound-dog.co.uk/images/testerror.gif>" no-undo.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-EpulseMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-EpulseMessage Procedure 
PROCEDURE ip-EpulseMessage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-msg          as char         no-undo.

    def output param pc-AccountNumber as char       no-undo.
    def output param pc-Result        as char       no-undo.
    
    def var li-customer             as int          no-undo.
    def var lc-work                 as char         no-undo.
    def var li-loop                 as int          no-undo.
    def var li-begin                as int          no-undo.
    def var li-end                  as int          no-undo.
    def var li-error                as int          no-undo.
    def var lc-error                as char         no-undo.
    def var lc-result               as char         no-undo.
    def var lc-word                 as char         no-undo.
    def var lc-final                as char         no-undo.

    
    
    assign 
        li-customer = index(pc-msg,lc-epulse-cstring).

    if li-customer = 0 then 
    do:
        return.
    end.
    
    assign lc-work = 
        replace(replace(substr(pc-msg,li-customer + length(lc-epulse-cstring))," ","|"),"~n","|").

    
    
    if num-entries(lc-work,"|") = 0 then 
    do:
        return.
    end.

    do li-loop = 1 to min(10,num-entries(lc-work,"|")):
        assign pc-AccountNumber = trim(entry(li-loop,lc-work,"|")).
        if pc-AccountNumber <> "" then leave.
    end.
    if pc-AccountNumber = "" then return.
    message "String = " pc-AccountNumber length(pc-AccountNumber).

    find Customer
        where Customer.CompanyCode = lc-global-company
          and Customer.AccountNumber = pc-AccountNumber 
          no-lock no-error.
    if not avail Customer then 
    do:
        pc-AccountNumber = "".
        return.
    end.
   
    assign
        li-error = index(pc-msg,lc-epulse-error-begin).
    if li-error = 0 then 
    do:
        pc-AccountNumber = "".
        return.
    end.
    
    lc-work = pc-msg.

    do while true:

        assign li-error = index(lc-work,lc-epulse-error-begin).
        if li-error = 0 then leave.

        /*
        *** Position after error
        */
        assign lc-work = substr(lc-work,li-error + length(lc-epulse-error-begin)).
        
        /*
        *** Theres a link to an error gif so position after this
        */
        assign li-begin = index(lc-work,">").

        if li-begin = 0 then leave.

        assign lc-work = substr(lc-work,li-begin + 1).
        

        /* 
        *** lc-work contains then message from the errors begins to the end of the html
        *** so need to get the next < which denotes the next epulse start message
        */

        assign
            li-end = index(lc-work,"<").

        if li-end > 0
        then lc-error = substr(lc-work,1,li-end - 1).
        else lc-error = lc-work.

        lc-error = replace(lc-error,"~n","|").
        lc-error = replace(lc-error," ","|").

        assign lc-result = "".
        do li-loop = 1 to num-entries(lc-error,"|").
            lc-word = entry(li-loop,lc-error,"|").
            if lc-word = "" then next.
            lc-result = lc-result + " " + lc-word.

        end.
        lc-result = trim(lc-result).
           
       

        if lc-final = ""
        then assign lc-final = lc-result.
        else assign lc-final = lc-final + "~n" + lc-result.

        if li-end = 0 then leave.

        assign
            lc-work = substr(lc-work,li-end).
       

    end.

    assign pc-Result = lc-Final.


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
    
   

    def var lf-EmailID      like    EmailH.EmailID      no-undo.

    find company where company.CompanyCode = lc-global-company no-lock no-error.

    /*
    assign
        lc-AttachDir = replace(lc-AttachDir,"~n","|")
        lc-AttachDir = replace(lc-AttachDir,"~r","|").

    assign
        lc-AttachFile = replace(lc-AttachFile,"~n","|")
        lc-AttachFile = replace(lc-AttachFile,"~r","|").
*/
    
    repeat transaction on error undo , leave:

        message "Checking message" lc-body.

        RUN ip-EpulseMessage ( lc-body, 
                               output lc-AccountNumber, 
                               output lc-Msg ).

        if lc-AccountNumber = "" then 
        do:
            message "no account so ignore".
            message "Msg = " lc-msg.
            leave.
        end.
        message "Process for account " lc-AccountNumber.


        find last b no-lock no-error.

        assign
            lf-EmailID = if avail b then b.EmailID + 1 else 1.
        create b.
        assign 
            b.CompanyCode = lc-global-company
            b.EmailID     = lf-EmailID.

        assign
            b.Email       = lc-from
            b.mText       = lc-msg
            b.Subject     = lc-Subject
            b.RcpDate     = today
            b.RcpTime     = time.
            b.AccountNumber = lc-AccountNumber.

        /*
        if lc-AttachDir <> "" then
        do li-loop = 1 to num-entries(lc-AttachDir,"|"):
            assign
                lc-file = trim(entry(li-loop,lc-AttachDir,"|"))
                lc-title = trim(entry(li-loop,lc-AttachFile,"|")).
            if search(lc-file) = ? then next.

            
            RUN ip-UploadAttachment
                ( lf-EmailID,
                  lc-file,
                  lc-title ).
            
        end.
        */
        /*
        mlib-SendEmail
            ( lc-global-company,
              "",
              "RE: " + lc-subject,
              company.MonitorMessage + 
              '~n~n' + 
              'Your Email:~n' +
              fill("-",80) + '~n' +
              lc-body + 
              '~n~n'
              ,
              lc-from).
        */        
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
  
    assign
        lc-from         = get-value("from")
        lc-to           = get-value("to")
        lc-subject      = get-value("subject")
        lc-body         = get-value("body")
        lc-attachdir    = get-value("attachdir")
        lc-attachfile   = get-value("attachfile")
        /* lc-html         = get-value("html") */
        .
    

    RUN outputHeader.
    
   
    assign
        lc-global-company = "OURITDEPT".

   
    {&out} string(time,"hh:mm:ss") " mail monitor received from "
            lc-from " to " lc-to " for company " lc-global-company
            " subject " lc-subject lc-body
            .

    if lc-global-company <> "" 
    and lc-from <> ""
    then RUN ip-ProcessEmail.
    
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

