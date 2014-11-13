/***********************************************************************

    Program:        cust/custequiptable.p
    
    Purpose:        Customer Maintenance - Ajax Table    
    
    Notes:
    
    
    When        Who         What
    22/04/2006  phoski      Initial
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lc-rowid    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-value    AS CHARACTER NO-UNDO.

DEFINE VARIABLE ll-customer AS LOG       NO-UNDO.

DEFINE VARIABLE lc-inv-key  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-cust-key AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-sec-key  AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-part1    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-part2    AS CHARACTER NO-UNDO.



DEFINE BUFFER this-user FOR WebUser.

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no






/* *********************** Procedure Settings ************************ */



/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.14
         WIDTH              = 60.6.
/* END WINDOW DEFINITION */
                                                                        */

/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}



 




/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.



/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

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


&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

PROCEDURE process-web-request :
    /*------------------------------------------------------------------------------
      Purpose:     Process the web request.
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
  
    DEFINE VARIABLE lc-msg  AS CHARACTER    NO-UNDO.
       
    ASSIGN 
        lc-rowid = get-value("rowid").
        
    
    ASSIGN
        lc-rowid = DYNAMIC-FUNCTION("sysec-DecodeValue","Inventory",TODAY,"Inventory",lc-rowid).
        
    
    
    ASSIGN
        lc-sec-key = get-value("sec").
        
    ASSIGN
        lc-sec-key = DYNAMIC-FUNCTION("sysec-DecodeValue","GlobalSecure",TODAY,"GlobalSecure",lc-sec-key).
      
    ASSIGN
        lc-part1 = ENTRY(1,lc-sec-key,":")  
        lc-part2 = ENTRY(2,lc-sec-key,":") NO-ERROR.
    
          
    ASSIGN
        lc-cust-key = get-value("customer").
        
    ASSIGN
        lc-cust-key = DYNAMIC-FUNCTION("sysec-DecodeValue",lc-part2,TODAY,"Customer",lc-cust-key).
      
               
    /*
    ***
    *** Note 
    *** No output headers etc as this procedure is called thru Ajax
    ***
    */
    
    FIND customer WHERE ROWID(customer) = to-rowid(lc-cust-key) NO-LOCK NO-ERROR.
    FIND this-user WHERE ROWID(this-user) = to-rowid(lc-part1) NO-LOCK NO-ERROR.
    
    
       
    
    FIND custIv WHERE ROWID(custIv) = to-rowid(lc-rowid) NO-LOCK NO-ERROR.

    IF NOT AVAILABLE custIv 
        OR NOT AVAILABLE Customer
        OR NOT AVAILABLE this-user THEN 
    DO:
        MESSAGE " Avail custIv = " AVAILABLE custIv 
                " Avail Customer = " AVAILABLE Customer
                " avail this-user = " AVAILABLE this-user
                " get-value(rowid) = "  get-value("rowid")
                " get-value(Sec) = " get-value("sec").
                
                
        lc-msg = "URL Invalid - Access denied".
    END.
    
    IF lc-msg <> "" THEN
    DO:
        IF this-user.disabled THEN
        DO:
            lc-msg = "Account Disabled - Access denied".  
        END.
    
        IF com-IsCustomer(this-user.CompanyCode
            ,this-user.LoginID) AND this-user.accountNumber <> CustIv.AccountNumber THEN
        DO:
            lc-msg = "Invalid Account - Access denied".
        END.
    
    END.
    
    
        
    RUN outputHeader.
    
    IF lc-msg <> "" THEN
    DO:
        {&out} '<div class="infobox">' lc-msg '</div>'.
        RETURN.
    END.
        
       
    {&out} skip
           htmlib-StartFieldSet("Inventory Details For " + 
                                custIv.Ref) 
           htmlib-StartMntTable().

    {&out}
    htmlib-TableHeading(
        "^right|Details^left|Notes^left"
        ) skip.

    FIND ivSub OF CustIv NO-LOCK NO-ERROR.

    FOR EACH ivField OF ivSub NO-LOCK
        BY ivField.dOrder
        BY ivField.dLabel:

        {&out} '<tr class="tabrow1">'.

        {&out} '<th style="text-align: right; vertical-align: text-top;">'
        html-encode(ivField.dLabel + ":").

        {&out}
        '</th>'.

        
        FIND CustField
            WHERE CustField.CustIvID = custIv.CustIvId
            AND CustField.ivFieldId = ivField.ivFieldId
            NO-LOCK NO-ERROR.
        ASSIGN
            lc-value = IF AVAILABLE Custfield THEN CustField.FieldData
                       ELSE "".
        IF lc-value = ?
            THEN ASSIGN lc-value = "".
        {&out} htmlib-MntTableField(REPLACE(html-encode(lc-value),"~n","<br>"),'left') skip.
        {&out} htmlib-MntTableField(html-encode(ivField.dPrompt),'left') skip.

        {&out} '</tr>' skip.
    END.

    {&out} skip 
           htmlib-EndTable()
           htmlib-EndFieldSet() 
           skip.

END PROCEDURE.


&ENDIF

