&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        cust/ivrenewal.p
    
    Purpose:        Inventory Renewal Browse
    
    Notes:
    
    
    When        Who         What
    16/07/2006  phoski      Initial 
    
    10/09/2010  DJS         3671 amended to utilise for inventory
                              renewals - added menu item
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

def var lc-rowid as char no-undo.
def var lc-link-print as char no-undo.

def var li-max-lines as int initial 12 no-undo.


def buffer b-query  for ivField.
def buffer b-search for ivField.



  
def query q for b-query scrolling.


def var lc-info         as char no-undo.
def var lc-object       as char no-undo.
def var li-tag-end      as int no-undo.
def var lc-dummy-return as char initial "MYXXX111PPP2222"   no-undo.
def var lc-Customer     as char no-undo.
def var lc-link-otherp  as char no-undo.

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

&IF DEFINED(EXCLUDE-ip-ExportJScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportJScript Procedure 
PROCEDURE ip-ExportJScript :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   
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
    
    def buffer Customer for Customer.

    def var ld-date         as date     no-undo.
    def var ld-renewal      as date     no-undo.

    {lib/checkloggedin.i}

    
    RUN outputHeader.
    
    
    {&out} htmlib-Header("Inventory Renewals") skip.

    RUN ip-ExportJScript.

    {&out} htmlib-JScript-Maintenance() skip.

    {&out} htmlib-StartForm("mainform","post", appurl + '/cust/ivrenewal.p' ) skip.

    {&out} htmlib-ProgramTitle("Inventory Renewals") 
           htmlib-hidden("submitsource","") skip
           .
  
    
    {&out}
            tbar-Begin(
                ""
                )
            tbar-BeginOption()
            tbar-Link("view",?,"off",lc-link-otherp)
            tbar-Link("update",?,"off",lc-link-otherp)
            tbar-EndOption()
            tbar-End().

    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="97%"') skip
           htmlib-TableHeading(
            "Customer|Inventory Reference|Class|Field|Date|Warning Period|Days Remaining"
            ) skip.
 
    for each b-query no-lock
        where b-query.dType = "date"
          and b-query.dWarning > 0,
          first ivSub of b-query no-lock:

        if ivSub.Company <> lc-global-company then next.

        for each CustField no-lock
            where CustField.ivFieldID = b-query.ivFieldID:

            
            if custField.FieldData = "" 
            or custField.FieldData = ? then next.

            assign
                ld-renewal = date(custfield.FieldData) no-error.
            if error-status:error 
            or ld-renewal = ? then next.

            if today >= ld-renewal - b-query.dWarning
/*             and ld-renewal >= today                           removed for 3671    */
              
            then 
            do:

                find custIv 
                    where custiv.CustIvID = 
                    custField.CustIvId no-lock no-error.
                            
                find customer of CustIv no-lock no-error.
                find ivClass  of ivSub  no-lock no-error.

                assign
                    lc-link-otherp = "returnback=renewal&customer=" + string(rowid(customer)) +
                    '&' + htmlib-RandomURL().
                {&out}
                    tbar-tr(rowid(custiv))
                        '<td>' html-encode(customer.AccountNumber + " - " + customer.name) '</td>'
                        '<td>' html-encode(custiv.Ref)  '</td>'
                        '<td>' html-encode(ivClass.name + " - " + 
                                           ivSub.name ) '</td>'
                        '<td>' html-encode(b-query.dLabel) '</td>'
                        '<td>' string(ld-renewal,'99/99/9999') '</td>'
                        '<td>' string(b-query.dWarning) '</td>'
                        '<td>' ld-renewal - today '</td>'
                        tbar-BeginHidden(rowid(custiv)) 
                        tbar-Link("view",rowid(custiv),appurl + '/cust/custequipmnt.p',lc-link-otherp)
                        tbar-Link("update",rowid(custiv),appurl + '/cust/custequipmnt.p',lc-link-otherp)
                        tbar-EndHidden() 

                    '</tr>' skip.

            end.
        end.

       
            
    end.

    {&out} skip 
           htmlib-EndTable()
           skip.


    {&out} htmlib-EndForm().

    
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

