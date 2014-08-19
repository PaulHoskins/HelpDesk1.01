/***********************************************************************

    Program:        cust/custmnt.p
    
    Purpose:        Customer Maintenance         
    
    Notes:
    
    
    When        Who         What
    10/04/2006  phoski      CompanyCode  
    11/04/2006  phoski      Show users on view    
    30/04/2006  phoski      Mobile number on user list
    15/07/2006  phoski      Ticket flag
    20/07/2006  phoski      Statement Email
    26/07/2006  phoski      Ticket Transactions
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


DEFINE VARIABLE v-debug        AS LOG       INITIAL FALSE NO-UNDO.

DEFINE VARIABLE lc-error-field AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-error-msg   AS CHARACTER NO-UNDO.


DEFINE VARIABLE lc-mode        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-rowid       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-title       AS CHARACTER NO-UNDO.


DEFINE BUFFER b-valid FOR customer.
DEFINE BUFFER b-table FOR customer.

DEFINE TEMP-TABLE conts LIKE ContractType
    INDEX i-conts ContractNumber.

DEFINE BUFFER b-tabletype  FOR WebissCont.
DEFINE BUFFER bb-tabletype FOR WebissCont.
DEFINE TEMP-TABLE b-webcont LIKE WebissCont.

DEFINE VARIABLE lc-search           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-firstrow         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-lastrow          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-navigation       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-parameters       AS CHARACTER NO-UNDO.


DEFINE VARIABLE lc-link-label       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-submit-label     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-link-url         AS CHARACTER NO-UNDO.



DEFINE VARIABLE lc-accountnumber    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-name             AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-address1         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-address2         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-city             AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-county           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-country          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-postcode         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-telephone        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-contact          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-notes            AS CHARACTER NO-UNDO. 
DEFINE VARIABLE lc-supportticket    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-statementemail   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-isActive         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-viewAction       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-viewActivity     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-st-num           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-st-code          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-st-descr         AS CHARACTER NO-UNDO.



DEFINE VARIABLE lc-sla-rows         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-sla-selected     AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-temp             AS CHARACTER NO-UNDO.

DEFINE VARIABLE vx                  AS INTEGER   NO-UNDO.
DEFINE VARIABLE vz                  AS INTEGER   NO-UNDO.
DEFINE VARIABLE vc-con              AS CHARACTER EXTENT 20 NO-UNDO.

DEFINE VARIABLE lc-saved-contracts  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-saved-connums    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-saved-billables  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-saved-connotes   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-saved-defcons    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-saved-conactives AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-saved-recids     AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-connums-list     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-contract-list    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-billable-list    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-connotes-list    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-defcons-list     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-conactive-list   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-contractnotes    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-contractbilling  AS CHARACTER NO-UNDO.

DEFINE VARIABLE lc-contract         AS CHARACTER EXTENT 20 NO-UNDO.
DEFINE VARIABLE ll-billable         AS LOG       EXTENT 20 NO-UNDO.
DEFINE VARIABLE lc-connotes         AS CHARACTER EXTENT 20 NO-UNDO.
DEFINE VARIABLE ll-default          AS LOG       EXTENT 20 NO-UNDO.
DEFINE VARIABLE ll-conactive        AS LOG       EXTENT 20 NO-UNDO.




/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no





/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addBalloon) = 0 &THEN

FUNCTION addBalloon RETURNS CHARACTER
    ( f-text AS CHARACTER )  FORWARD.


&ENDIF


/* *********************** Procedure Settings ************************ */



/* *************************  Create Window  ************************** */

/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.12
         WIDTH              = 60.57.
/* END WINDOW DEFINITION */
                                                                        */

/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}



 




/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */



RUN process-web-request.



/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-AccountUsers) = 0 &THEN

PROCEDURE ip-AccountUsers :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pc-companycode      AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER pc-AccountNumber    AS CHARACTER     NO-UNDO.
    
    DEFINE BUFFER b-query  FOR webUser.
    DEFINE VARIABLE lc-nopass   AS CHARACTER NO-UNDO.


    IF NOT CAN-FIND(FIRST b-query
        WHERE b-query.CompanyCode   = pc-CompanyCode
        AND b-query.AccountNumber = pc-AccountNumber NO-LOCK) 
        THEN RETURN.
   

    

    {&out} skip
           htmlib-StartFieldSet("Customer Users") 
           htmlib-StartMntTable().

    {&out}
    htmlib-TableHeading(
        "User Name^left|Name^left|Email^left|Telephone|Mobile|Track?|Disabled?"
        ) skip.


    FOR EACH b-query NO-LOCK
        WHERE b-query.CompanyCode   = pc-CompanyCode
        AND b-query.AccountNumber = pc-AccountNumber
        :
    
   
        ASSIGN 
            lc-nopass = IF b-query.passwd = ""
                           OR b-query.passwd = ?
                           THEN " (No password)"
                           ELSE "".
        
        {&out}
        '<tr>' skip
            htmlib-MntTableField(html-encode(b-query.loginid),'left')
            htmlib-MntTableField(html-encode(b-query.name),'left')
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

       
            
    END.


    {&out} skip 
           htmlib-EndTable()
           htmlib-EndFieldSet() 
           skip.


END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-AddContracts) = 0 &THEN

PROCEDURE ip-AddContracts :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE nextID  AS INTEGER NO-UNDO.

    DO vx = 1 TO NUM-ENTRIES(TRIM(lc-saved-contracts,"|"),"|"):
  
        FIND b-tabletype 
            WHERE  ROWID(b-tabletype)  = to-rowid(ENTRY(vx,lc-saved-recids,"|"))
            EXCLUSIVE-LOCK NO-ERROR.
  
        IF ENTRY(vx,lc-saved-contracts,"|") = "NONE" 
            OR ENTRY(vx,lc-saved-contracts,"|") = "" 
            AND AVAILABLE b-tabletype THEN 
        DO:
            DELETE b-tabletype.
            IF v-debug THEN 
            DO:
                OUTPUT to "c:\temp\djstest.txt" append.
                PUT UNFORMATTED "Deleted  - " STRING(vx) " -- "  ENTRY(vx,lc-saved-recids,"|")  " - "  STRING(NUM-ENTRIES(lc-saved-contracts,"|")) SKIP.
                OUTPUT close.
            END.
        END.
        ELSE
        DO:
  
            IF NOT AVAILABLE b-tabletype THEN 
            DO:
                FIND LAST bb-tabletype 
                    WHERE bb-tabletype.CompanyCode     = b-table.CompanyCode
                    AND   bb-tabletype.Customer        = b-table.AccountNumber 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE bb-tabletype THEN nextID = bb-tabletype.ConID + 1.
                ELSE nextID = 1.
                IF v-debug THEN 
                DO:
                    OUTPUT to "c:\temp\djstest.txt" append.
                    PUT UNFORMATTED "Created  -  " STRING(vx) "  "  STRING(nextID) " _ "  STRING(NUM-ENTRIES(lc-saved-contracts,"|")) SKIP.
                    OUTPUT close.
                END.
                CREATE b-tabletype.
                ASSIGN 
                    b-tabletype.ConID          = nextID
                    b-tabletype.CompanyCode    = b-table.CompanyCode  
                    b-tabletype.Customer       = b-table.AccountNumber 
                    b-tabletype.ContractCode   = ENTRY(vx,lc-saved-contracts,"|")
                    b-tabletype.Billable       = ENTRY(vx,lc-saved-billables,"|") = "yes"
                    b-tabletype.Notes          = ENTRY(vx,lc-saved-connotes,"|")
                    b-tabletype.DefCon         = ENTRY(vx,lc-saved-defcons,"|") = "yes"
                    b-tabletype.ConActive      = ENTRY(vx,lc-saved-conactives,"|") = "yes"
                    .
                IF v-debug THEN 
                DO:
                    OUTPUT to "c:\temp\djstest.txt" append.
                    PUT UNFORMATTED "Done Created  -  " STRING(vx) "  "  STRING(nextID) SKIP.
                    OUTPUT close.
                END.
  
            END.
            ELSE
            DO:
                ASSIGN 
                    b-tabletype.ContractCode   = ENTRY(vx,lc-saved-contracts,"|")
                    b-tabletype.Billable       = ENTRY(vx,lc-saved-billables,"|") = "yes"
                    b-tabletype.Notes          = ENTRY(vx,lc-saved-connotes,"|")
                    b-tabletype.DefCon         = ENTRY(vx,lc-saved-defcons,"|") = "yes"
                    b-tabletype.ConActive      = ENTRY(vx,lc-saved-conactives,"|") = "yes"
                    .
                IF v-debug THEN 
                DO:  
                    OUTPUT to "c:\temp\djstest.txt" append.
                    PUT UNFORMATTED "In Assign Update   " SKIP.
                    OUTPUT close.
                END.
            END.
        END.
    END.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-Contracts) = 0 &THEN

PROCEDURE ip-Contracts :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE vy  AS INTEGER  NO-UNDO.
    DEFINE VARIABLE v-conn-start  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE total-contracts AS INTEGER  NO-UNDO.
    
    total-contracts = 10.

    total-contracts = total-contracts .

    v-conn-start = '<table id=~'dynamiccontents~' cellpadding=0 cellspacing=0  valign=~'top~'><tr>'.
    v-conn-start = v-conn-start + '<td  class=~'sidelabel~'  valign=~'top~'>Contracts:&nbsp;</td><td>'.
  

    /* FIRST CONTRACT                                                                                                                    */
    IF vx > 0 THEN
    DO:
        vc-con[1] = vc-con[1] + '<!--   FIRST  --><div id=~'DD1~'  >'.
        vc-con[1] = vc-con[1] + '<input id=~'defcon1~' name=~'defcon1~' class=~'inputfield~' type=~'radio~' ' + addBalloon("Default?") + ' onclick=~'javascript:SDefCon(1)~' value=~'defcon1~'' .
        IF ll-default[1] = TRUE THEN vc-con[1] = vc-con[1] + ' checked '.
        vc-con[1] = vc-con[1] + '><select class=~'inputfield~'  id=~'contract1~' name=~'contract1~' valign=~'top~' width=~'200px~' disabled >'.
        FOR EACH conts NO-LOCK:
            vc-con[1] = vc-con[1] + '<option '.
            IF lc-contract[1] = conts.ContractNumber THEN
                vc-con[1] = vc-con[1] + ' selected '.
            vc-con[1] = vc-con[1] + '  value=~'' + conts.ContractNumber + '~'>' + conts.Description + '</option>'.
        END.
        vc-con[1] = vc-con[1] + '</select>'.
        vc-con[1] = vc-con[1] + '<input id=~'cnotes1~' class=~'tablefield~' type=~'text~' onChange=~'javascript:SNotes(1,this.value)~' value=~'' + lc-connotes[1] +   '~' >'.
        vc-con[1] = vc-con[1] + ' <input id=~'conactive1~' type=~'checkbox~' ' + addBalloon("Active?") + ' onclick=~\~"javascript:SConActive(~'1~');~\~"   '.
        IF ll-conactive[1] THEN vc-con[1] = vc-con[1] + " checked ".
        vc-con[1] = vc-con[1] + ' >'.
        vc-con[1] = vc-con[1] + ' <input id=~'billable1~' type=~'checkbox~' ' + addBalloon("Billable?") + ' onclick=~\~"javascript:SBillable(~'1~');~\~"   '.
        IF ll-billable[1] THEN vc-con[1] = vc-con[1] + " checked ".
        vc-con[1] = vc-con[1] + ' >'.
        vc-con[1] = vc-con[1] + ' <img src=~'/images/general/remove01.gif~'' + addBalloon("Click to delete") + ' id=~'RM1~' onclick=~\~"javascript:SRemove(this);~\~">'.
        vc-con[1] = vc-con[1] + '</div></td></tr>'.
        vc-con[1] = vc-con[1] + '<tr><td></td><td> '.
    END.


    /* NEXT CONTRACTS                                                                                                                       */
    IF vx > 1 THEN
    DO vz = 2 TO vx :          
        vc-con[vz] = '<!--   NEXT  --><div id=~'DD' + string(vz) + '~' >'.
        vc-con[vz] = vc-con[vz] + '<input  id=~'defcon' + string(vz) + '~' name=~'defcon' + string(vz) + '~'  class=~'inputfield~' type=~'radio~' ' + addBalloon("Default?") + ' onclick=~'javascript:SDefCon(' + string(vz) + ')~' value=~'defcon' + string(vz) + '~''.
        IF ll-default[vz] = TRUE THEN vc-con[vz] = vc-con[vz] + ' checked '.
        vc-con[vz] = vc-con[vz] + '><select class=~'inputfield~'  id=~'contract' + string(vz) + '~' name=~'contract' + string(vz) + '~' valign=~'top~' width=~'100px~' disabled >'.
        FOR EACH conts NO-LOCK   :
            vc-con[vz] = vc-con[vz] + '<option '.
            IF lc-contract[vz] = conts.ContractNumber THEN 
                vc-con[vz] = vc-con[vz] + ' selected '.
            vc-con[vz] = vc-con[vz] + ' value=~'' + conts.ContractNumber + '~'>' + conts.Description + '</option>'. 
        END.
        vc-con[vz] = vc-con[vz] + '</select>'. 
        vc-con[vz] = vc-con[vz] + '<input id=~'cnotes' + string(vz) + '~' class=~'tablefield~' type=~'text~' onChange=~'javascript:SNotes(' + string(vz) + ',this.value)~' value=~'' + lc-connotes[vz] +   '~' >'.
        vc-con[vz] = vc-con[vz] + ' <input id=~'conactive' + string(vz) + '~' type=~'checkbox~' ' + addBalloon("Active?") + ' onclick=~\~"javascript:SConActive(~'' + string(vz) + '~');~\~"   '.
        IF ll-conactive[vz] THEN vc-con[vz] = vc-con[vz] + " checked ".
        vc-con[vz] = vc-con[vz] + ' >'.
        vc-con[vz] = vc-con[vz] + ' <input id=~'billable' + string(vz) + '~' type=~'checkbox~' ' + addBalloon("Billable?") + ' onclick=~\~"javascript:SBillable(~'' + string(vz) + '~');~\~"   '.
        IF ll-billable[vz] THEN vc-con[vz] = vc-con[vz] + " checked ".
        vc-con[vz] = vc-con[vz] + ' >'.
        vc-con[vz] = vc-con[vz] + ' <img src=~'/images/general/remove01.gif~'' + addBalloon("Click to delete") + ' id=~'RM'  + string(vz) + '~' onclick=~\~"javascript:SRemove(this);~\~">'.
        vc-con[vz] = vc-con[vz] + '</div></td></tr><tr> '.  
        vc-con[vz] = vc-con[vz] + '<td></td><td   >'.  
    END.
  


    /* BLANK CONTRACTS                                                                                                                       */
    IF vx <= total-contracts THEN
    DO vz = (vx + 1) TO total-contracts :

        vc-con[vz] = '<!--   BLANKS  --><div id=~'DD' + string(vz) + '~' style=~\~"display:none;~\~"  >'.
        /*   vc-con[vz] = ' <tr    ><td></td><td   ><div id=~'DD' + string(vz) + '~'    >'.  */
        vc-con[vz] = vc-con[vz] + '<input  id=~'defcon' + string(vz) + '~' name=~'defcon' + string(vz) + '~'  class=~'inputfield~' type=~'radio~' ' + addBalloon("Default?") + ' onclick=~'javascript:SDefCon(' + string(vz) + ')~' value=~'defcon' + string(vz) + '~''.
        IF ll-default[vz] = TRUE THEN vc-con[vz] = vc-con[vz] + ' checked '.
        vc-con[vz] = vc-con[vz] + '><select class=~'inputfield~' id=~'contract' + string(vz) + '~' name=~'contract' + string(vz) + '~' disabled  valign=~'top~' width=~'100px~' >'.
        vc-con[vz] = vc-con[vz] + '<option '.
        vc-con[vz] = vc-con[vz] + ' value=~'NONE~'>Add Contract</option>'. 
        FOR EACH conts NO-LOCK:
            IF LOOKUP(STRING(conts.ContractNumber),lc-contract-list) > 0 THEN 
                NEXT.
            vc-con[vz] = vc-con[vz] + '<option '.
            vc-con[vz] = vc-con[vz] + ' value=~'' + conts.ContractNumber + '~'>' + conts.Description + '</option>'. 
        END.
        vc-con[vz] = vc-con[vz] + ' </select>'.
        vc-con[vz] = vc-con[vz] + '<input id=~'cnotes' + string(vz) + '~' class=~'tablefield~' type=~'text~' onChange=~'javascript:SNotes(' + string(vz) + ',this.value)~' value=~'' + lc-connotes[vz] +   '~' >'.
        vc-con[vz] = vc-con[vz] + ' <input id=~'conactive' + string(vz) + '~' type=~'checkbox~' ' + addBalloon("Active?") + ' onclick=~\~"javascript:SConActive(~'' + string(vz) + '~');~\~"   '.
        IF ll-conactive[vz] THEN vc-con[vz] = vc-con[vz] + " checked ".
        vc-con[vz] = vc-con[vz] + ' >'.
        vc-con[vz] = vc-con[vz] + ' <input id=~'billable' + string(vz) + '~' type=~'checkbox~' ' + addBalloon("Billable?") + ' onclick=~\~"javascript:SBillable(~'' + string(vz) + '~');~\~"   '.
        IF ll-billable[vz] THEN vc-con[vz] = vc-con[vz] + " checked ".
        vc-con[vz] = vc-con[vz] + ' >'.
        vc-con[vz] = vc-con[vz] + ' <img src=~'/images/general/remove01.gif~'' + addBalloon("Click to delete") + ' id=~'RM'  + string(vz) + '~' onclick=~\~"javascript:SRemove(this);~\~">'.
        vc-con[vz] = vc-con[vz] + '</div></td></tr><tr><td></td><td> '.
    END.
 
    /*   vz = vz + 1. */
  
    {&out}  htmlib-Hidden ("vx...............", STRING(vx)) skip.
    {&out}  htmlib-Hidden ("vz...............", STRING(vz)) skip.

    /* NEW CONTRACT                                                                                                                             */
    IF vx < total-contracts THEN 
        vc-con[20] = vc-con[20] + '<!--   ADD  --><div id=~'DD' + string(20) + '~' >'.
    ELSE
        vc-con[20] = vc-con[20] + '<!--   ADD  --><div id=~'DD' + string(20) + '~' style=~\~"display:none;~\~"  >'.

    vc-con[20] = vc-con[20] + '<input id=~'defcon' + string(20) + '~' name=~'defcon' + string(20) + '~' class=~'inputfield~' type=~'radio~' ' + addBalloon("Default?") + '   value=~'defcon' + string(20) + '~' '.
    IF vz <= 1 THEN vc-con[20] = vc-con[20] + " checked".
    vc-con[20] = vc-con[20] + '><select class=~'inputfield~' id=~'contract' + string(20) + '~' name=~'contract' + string(20) + '~' ' + addBalloon("Choose Contract") + ' onChange=~'javascript:SNewContract(' + string(20) + ')~' valign=~'top~' width=~'100px~' >'.
    vc-con[20] = vc-con[20] + '<option '.
    vc-con[20] = vc-con[20] + ' value=~'NONE~'>Add Contract</option>'.
    FOR EACH conts NO-LOCK:
        IF LOOKUP(STRING(conts.ContractNumber),lc-contract-list) > 0 THEN
            NEXT.
        vc-con[20] = vc-con[20] + '<option '.
        vc-con[20] = vc-con[20] + ' value=~'' + conts.ContractNumber + '~'>' + conts.Description + '</option>'.
    END.
    vc-con[20] = vc-con[20] + ' </select>'.
    vc-con[20] = vc-con[20] + '<input id=~'cnotes' + string(20) + '~' class=~'tablefield~' type=~'text~' value=~'~'  >'.
    vc-con[20] = vc-con[20] + ' <input id=~'conactive' + string(20) + '~' type=~'checkbox~'' + addBalloon("Active?") + ' checked  >'.
    vc-con[20] = vc-con[20] + ' <input id=~'billable' + string(20) + '~' type=~'checkbox~'' + addBalloon("Billable?") + ' >'.
    vc-con[20] = vc-con[20] + ' <img src=~'/images/general/tick.gif~'' + addBalloon("Click to add") + ' onclick=~\~"javascript:SAddContract(~'' + string(20) + '~');~\~"></td></tr> '.
    vc-con[20] = vc-con[20] + '</div>'.
 

      
    vc-con[20] = vc-con[20] + ' </td></tr></table>'.
    vc-con[20] = vc-con[20] + '<div id=~'balloon~' class=~'infobox~' style=~'top:;right:200px;float:right;width:100px;height:10px;padding:5px;text-align:center;position:absolute;display:none;text-decoration:bold;~'></div> '.

  
    /* DISPLAY CONTRACTS */
    {&out} 
    '<script type="text/javascript">' skip
  'document.getElementById("contracts").innerHTML = "' v-conn-start .

    IF vz <= 1 THEN  {&out}  vc-con[1] .
  else
  do vy = 1 to vz:
    
{&out}  vc-con[vy] .

END.
{&out}  vc-con[20] .

{&out} 
'";' skip
  '</script>' skip
  
  htmlib-Hidden ("contractnotes", lc-contractnotes) skip
  htmlib-Hidden ("contractbilling", lc-contractbilling) skip.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-MainPage) = 0 &THEN

PROCEDURE ip-MainPage :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    {&out} htmlib-StartTable("mnt",
        100,
        0,
        0,
        0,
        "center").


    {&out} '<TR align="left"><TD VALIGN="TOP" ALIGN="right" width="25%">' 
        ( IF LOOKUP("accountnumber",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("Account Number")
        ELSE htmlib-SideLabel("Account Number"))
    '</TD>' skip
    .

    IF lc-mode = "ADD" THEN
        {&out} '<TD VALIGN="TOP" ALIGN="left">'
    htmlib-InputField("accountnumber",8,lc-accountnumber) skip
           '</TD>'.
    else
    {&out} htmlib-TableField(html-encode(lc-accountnumber),'left')
           skip.

    {&out} '<td valign="top" align="right" >' skip
           '<div id="contracts" name="contracts" style="position:absolute;float:right;width:450px;right:20px;">&nbsp;' skip
           '</div>'
           '</td>' skip.



    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (IF LOOKUP("name",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("Name")
        ELSE htmlib-SideLabel("Name"))
    '</TD>'.
    
    IF NOT CAN-DO("view,delete",lc-mode) THEN
        {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
    htmlib-InputField("name",40,lc-name) 
    '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-name),'left')
           skip.

    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (IF LOOKUP("address1",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("Address")
        ELSE htmlib-SideLabel("Address"))
    '</TD>'.
    
    IF NOT CAN-DO("view,delete",lc-mode) THEN
        {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
    htmlib-InputField("address1",40,lc-address1) 
    '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-address1),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (IF LOOKUP("address2",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("")
        ELSE htmlib-SideLabel(""))
    '</TD>'.
    
    IF NOT CAN-DO("view,delete",lc-mode) THEN
        {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
    htmlib-InputField("address2",40,lc-address2) 
    '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-address2),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (IF LOOKUP("city",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("City/Town")
        ELSE htmlib-SideLabel("City/Town"))
    '</TD>'.
    
    IF NOT CAN-DO("view,delete",lc-mode) THEN
        {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
    htmlib-InputField("city",40,lc-city) 
    '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-city),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (IF LOOKUP("county",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("County")
        ELSE htmlib-SideLabel("County"))
    '</TD>'.
    
    IF NOT CAN-DO("view,delete",lc-mode) THEN
        {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
    htmlib-InputField("county",40,lc-county) 
    '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-county),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (IF LOOKUP("country",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("Country")
        ELSE htmlib-SideLabel("Country"))
    '</TD>'.
    
    IF NOT CAN-DO("view,delete",lc-mode) THEN
        {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
    htmlib-InputField("country",40,lc-country) 
    '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-country),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
        (IF LOOKUP("postcode",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("Post Code")
        ELSE htmlib-SideLabel("Post Code"))
    '</TD>'.
    
    IF NOT CAN-DO("view,delete",lc-mode) THEN
        {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
    htmlib-InputField("postcode",20,lc-postcode) 
    '</TD>' skip.
    else 
    do:

IF lc-postcode = "" THEN 
    {&out} htmlib-TableField(html-encode(lc-postcode),'left')
           skip.
        else
        do:
lc-temp = REPLACE(htmlib-TableField(html-encode(lc-postcode),'left'),"</td>","").
lc-temp = lc-temp + 
    '<br><a  target="new" href="http://www.streetmap.co.uk/streetmap.dll?postcode2map?code=' 
    + replace(lc-postcode," ","+") 
    + "&title=" 
    + replace(REPLACE(lc-name," ","+"),"&","")
    + '"><img border=0 src=/images/general/map.gif title="View Map">' 
    + '</a>'.
.
{&out} lc-temp.


END.
END.
{&out} '</TR>' skip.

{&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
    (IF LOOKUP("contact",lc-error-field,'|') > 0 
    THEN htmlib-SideLabelError("Contact")
    ELSE htmlib-SideLabel("Contact"))
'</TD>'.
    
IF NOT CAN-DO("view,delete",lc-mode) THEN
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
htmlib-InputField("contact",40,lc-contact) 
'</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-contact),'left')
           skip.
{&out} '</TR>' skip.

{&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
    (IF LOOKUP("telephone",lc-error-field,'|') > 0 
    THEN htmlib-SideLabelError("Telephone")
    ELSE htmlib-SideLabel("Telephone"))
'</TD>'.
    
IF NOT CAN-DO("view,delete",lc-mode) THEN
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
htmlib-InputField("telephone",20,lc-telephone) 
'</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-telephone),'left')
           skip.
{&out} '</TR>' skip.

{&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
    (IF LOOKUP("notes",lc-error-field,'|') > 0 
    THEN htmlib-SideLabelError("Note")
    ELSE htmlib-SideLabel("Note"))
'</TD>'.
    
IF NOT CAN-DO("view,delete",lc-mode) THEN
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
htmlib-TextArea("notes",lc-notes,5,60)
'</TD>' skip.
    else 
    {&out} htmlib-TableField(replace(html-encode(lc-notes),"~n",'<br>'),'left')
           skip.
{&out} '</TR>' skip.

    
IF lc-sla-rows <> "" THEN
DO:
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right" width="25%">' 
        (IF LOOKUP("sla",lc-error-field,'|') > 0 
        THEN htmlib-SideLabelError("Default SLA")
        ELSE htmlib-SideLabel("Default SLA"))
    '</TD>'
        .
    IF NOT CAN-DO("view,delete",lc-mode)
        THEN 
    DO:
        {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">' skip.
        RUN ip-SLATable.
        {&out} '</td>'.
    END.
    ELSE 
    DO:
        IF b-table.DefaultSLAID = 0
            THEN {&out} htmlib-TableField(html-encode("None"),'left').
            else
            do:
    FIND slahead WHERE slahead.SLAID = b-table.DefaultSLAID NO-LOCK NO-ERROR.
    {&out} htmlib-TableField(html-encode(slahead.description),'left').
END.
               

END.

{&out} '</TR>' skip.

END.
{&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
    (IF LOOKUP("st-num",lc-error-field,'|') > 0 
    THEN htmlib-SideLabelError("Support Team")
    ELSE htmlib-SideLabel("Support Team"))
'</TD>'.
    
IF NOT CAN-DO("view,delete",lc-mode) THEN
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
htmlib-Select("st-num",lc-st-Code,lc-st-descr,lc-st-num)
'</TD>' skip.
    else 
    {&out} htmlib-TableField(lc-st-num,'left')
           skip.
{&out} '</TR>' skip.

/***/

{&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
    (IF LOOKUP("supportticket",lc-error-field,'|') > 0 
    THEN htmlib-SideLabelError("Support Tickets Used?")
    ELSE htmlib-SideLabel("Support Tickets Used?"))
'</TD>'.
    
IF NOT CAN-DO("view,delete",lc-mode) THEN
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
htmlib-Select("supportticket",lc-global-SupportTicket-Code,lc-global-SupportTicket-Desc,lc-supportticket)
'</TD>' skip.
    else 
    {&out} htmlib-TableField(dynamic-function("com-DecodeLookup",lc-supportticket,
                                     lc-global-SupportTicket-Code,
                                     lc-global-SupportTicket-Desc
                                     ),'left')
           skip.
{&out} '</TR>' skip.

{&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
    (IF LOOKUP("statementemail",lc-error-field,'|') > 0 
    THEN htmlib-SideLabelError("Statement Email Address")
    ELSE htmlib-SideLabel("Statement Email Address"))
'</TD>'.
    
IF NOT CAN-DO("view,delete",lc-mode) THEN
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
htmlib-InputField("statementemail",40,lc-statementemail) 
'</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-statementemail),'left')
           skip.
{&out} '</TR>' skip.


IF NOT CAN-DO("view,delete",lc-mode) THEN
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
    (IF LOOKUP("viewaction",lc-error-field,'|') > 0 
    THEN htmlib-SideLabelError("View Actions?")
    ELSE htmlib-SideLabel("View Actions?"))
'</TD>'
'<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
htmlib-CheckBox("viewaction", IF lc-viewAction = 'on'
    THEN TRUE ELSE FALSE) 
'</TD></TR>' skip.

IF NOT CAN-DO("view,delete",lc-mode) THEN
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
    (IF LOOKUP("viewactivity",lc-error-field,'|') > 0 
    THEN htmlib-SideLabelError("View Activities?")
    ELSE htmlib-SideLabel("View Activities?"))
'</TD>'
'<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
htmlib-CheckBox("viewactivity", IF lc-viewActivity = 'on'
    THEN TRUE ELSE FALSE) 
'</TD></TR>' skip.


IF NOT CAN-DO("view,delete",lc-mode) THEN
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
    (IF LOOKUP("gotomaint",lc-error-field,'|') > 0 
    THEN htmlib-SideLabelError("Active?")
    ELSE htmlib-SideLabel("Active?"))
'</TD>'
'<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
htmlib-CheckBox("isactive", IF lc-isActive = 'on'
    THEN TRUE ELSE FALSE) 
'</TD></TR>' skip.

{&out} htmlib-EndTable() skip.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-SLATable) = 0 &THEN

PROCEDURE ip-SLATable :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    
    DEFINE BUFFER slahead  FOR slahead.
    DEFINE VARIABLE li-loop     AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lc-object   AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE lc-rowid    AS CHARACTER     NO-UNDO.


    {&out}
    htmlib-StartMntTable()
    htmlib-TableHeading(
        "Select?^left|SLA|Notes"
        ) skip.

    IF lc-global-company = "MICAR" THEN
    DO:
        {&out}
        htmlib-trmouse()
        '<td>'
        htmlib-Radio("sla", "slanone" , IF lc-sla-selected = "slanone" THEN TRUE ELSE FALSE)
        '</td>'
        htmlib-TableField(html-encode("None"),'left')
        htmlib-TableField("",'left')
        '</tr>' skip.
    END.

    DO li-loop = 1 TO NUM-ENTRIES(lc-sla-rows,"|"):
        ASSIGN
            lc-rowid = ENTRY(li-loop,lc-sla-rows,"|").

        FIND slahead WHERE ROWID(slahead) = to-rowid(lc-rowid) NO-LOCK NO-ERROR.
        IF NOT AVAILABLE slahead THEN NEXT.
        ASSIGN
            lc-object = "sla" + lc-rowid.
        {&out}
        htmlib-trmouse()
        '<td>'
        htmlib-Radio("sla" , lc-object, IF lc-sla-selected = lc-object THEN TRUE ELSE FALSE) 
        '</td>'
        htmlib-TableField(html-encode(slahead.description),'left')
        htmlib-TableField(REPLACE(slahead.notes,"~n",'<br>'),'left')
        '</tr>' skip.

    END.
    
        
    {&out} skip 
       htmlib-EndTable()
       skip.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-TicketTransactions) = 0 &THEN

PROCEDURE ip-TicketTransactions :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-companycode      AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER pc-AccountNumber    AS CHARACTER     NO-UNDO.
    
    DEFINE BUFFER b-query      FOR ticket.
    DEFINE BUFFER IssActivity  FOR IssActivity.
    DEFINE BUFFER issue        FOR issue.
        
    DEFINE VARIABLE lc-Issue        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lc-Activity     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE li-cf           AS INTEGER  NO-UNDO.


    IF NOT CAN-FIND(FIRST b-query
        WHERE b-query.CompanyCode   = pc-CompanyCode
        AND b-query.AccountNumber = pc-AccountNumber NO-LOCK) 
        THEN RETURN.

    {&out} skip
           htmlib-StartFieldSet("Ticket Transactions") 
           htmlib-StartMntTable().

    {&out}
    htmlib-TableHeading(
        "Date^right|Type|Reference|Issue Number^right||Activity|Time^right|Carried Forward^right"
        ) skip.


    FOR EACH b-query NO-LOCK
        WHERE b-query.CompanyCode   = pc-CompanyCode
        AND b-query.AccountNumber = pc-AccountNumber
        :

        ASSIGN
            lc-issue = ""
            lc-Activity = ""
            li-cf = li-cf + b-query.Amount.

        IF b-query.IssueNumber > 0 THEN
        DO:
            FIND Issue OF b-query NO-LOCK NO-ERROR.

            IF AVAILABLE Issue 
                THEN ASSIGN lc-issue = Issue.BriefDescription.
        END.

        IF b-query.IssActivityID > 0 THEN
        DO:
            FIND issActivity WHERE issActivity.issActivityID = 
                b-query.IssActivityID NO-LOCK NO-ERROR.
            IF AVAILABLE issActivity 
                THEN ASSIGN lc-Activity = issActivity.description.
        END.
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




    END.

    {&out} skip 
           htmlib-EndTable()
           htmlib-EndFieldSet() 
           skip.

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-ip-Validate) = 0 &THEN

PROCEDURE ip-Validate :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      objtargets:       
    ------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pc-error-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-error-msg  AS CHARACTER NO-UNDO.

    IF lc-mode = "ADD":U THEN
    DO:
        IF lc-accountnumber = ""
            OR lc-accountnumber = ?
            THEN RUN htmlib-AddErrorMessage(
                'accountnumber', 
                'You must enter the account number',
                INPUT-OUTPUT pc-error-field,
                INPUT-OUTPUT pc-error-msg ).
        

        IF CAN-FIND(FIRST b-valid
            WHERE b-valid.CompanyCode = lc-global-company
            AND b-valid.accountnumber = lc-accountnumber
            NO-LOCK)
            THEN RUN htmlib-AddErrorMessage(
                'accountnumber', 
                'This account number already exists',
                INPUT-OUTPUT pc-error-field,
                INPUT-OUTPUT pc-error-msg ).

    END.

    IF lc-name = ""
        OR lc-name = ?
        THEN RUN htmlib-AddErrorMessage(
            'name', 
            'You must enter the name',
            INPUT-OUTPUT pc-error-field,
            INPUT-OUTPUT pc-error-msg ).
 

END PROCEDURE.


&ENDIF

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

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


&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  objtargets:       
------------------------------------------------------------------------------*/


    {lib/checkloggedin.i} 
  
    FOR EACH ContractType WHERE ContractType.CompanyCode = lc-global-company
        NO-LOCK:
        CREATE conts.
        BUFFER-COPY ContractType TO conts.
    END.

    FOR EACH conts:
        ASSIGN 
            lc-contractnotes = lc-contractnotes + conts.Notes + "|"
            lc-contractbilling = lc-contractbilling + IF conts.Billable THEN "yes|" ELSE  "|".

    END.

    RUN com-GetTeams ( lc-global-company, OUTPUT lc-st-code, OUTPUT lc-st-descr ).

    ASSIGN
        lc-st-code = "0|" + lc-st-code
        lc-st-descr = "None Selected|" + lc-st-descr.


    ASSIGN 
        lc-mode = get-value("mode")
        lc-rowid = get-value("rowid")
        lc-search = get-value("search")
        lc-firstrow = get-value("firstrow")
        lc-lastrow  = get-value("lastrow")
        lc-navigation = get-value("navigation").

    IF lc-mode = "" 
        THEN ASSIGN lc-mode = get-field("savemode")
            lc-rowid = get-field("saverowid")
            lc-search = get-value("savesearch")
            lc-firstrow = get-value("savefirstrow")
            lc-lastrow  = get-value("savelastrow")
            lc-navigation = get-value("savenavigation").

    ASSIGN 
        lc-parameters = "search=" + lc-search +
                           "&firstrow=" + lc-firstrow + 
                           "&lastrow=" + lc-lastrow.

    CASE lc-mode:
        WHEN 'add'
        THEN 
            ASSIGN 
                lc-title = 'Add'
                lc-link-label = "Cancel addition"
                lc-submit-label = "Add Customer".
        WHEN 'view'
        THEN 
            ASSIGN 
                lc-title = 'View'
                lc-link-label = "Back"
                lc-submit-label = "".
        WHEN 'delete'
        THEN 
            ASSIGN 
                lc-title = 'Delete'
                lc-link-label = 'Cancel deletion'
                lc-submit-label = 'Delete Customer'.
        WHEN 'Update'
        THEN 
            ASSIGN 
                lc-title = 'Update'
                lc-link-label = 'Cancel update'
                lc-submit-label = 'Update Customer'.
    END CASE.


    ASSIGN 
        lc-title = lc-title + ' Customer'
        lc-link-url = appurl + '/cust/cust.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&time=' + string(TIME)
        .

    IF CAN-DO("view,update,delete",lc-mode) THEN
    DO:
        FIND b-table WHERE ROWID(b-table) = to-rowid(lc-rowid)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b-table THEN
        DO:
            set-user-field("mode",lc-mode).
            set-user-field("title",lc-title).
            set-user-field("nexturl",appurl + "/cust/cust.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            RETURN.
        END.
        vx = 0.
        FOR EACH WebissCont WHERE WebissCont.CompanyCode = b-table.CompanyCode
            AND   WebissCont.Customer    = b-table.AccountNumber
            NO-LOCK
            BY    WebIssCont.ConID  :
            CREATE b-webcont.
            BUFFER-COPY WebissCont TO b-webcont.
            ASSIGN  
                vx = vx + 1
                lc-contract[vx]    = STRING(WebissCont.ContractCode)
                ll-billable[vx]    = WebissCont.Billable
                lc-connotes[vx]    = STRING(WebissCont.Notes)
                ll-default[vx]     = WebissCont.DefCon
                ll-conactive[vx]   = WebissCont.ConActive
                lc-contract-list   = lc-contract-list + string(WebissCont.ContractCode) + "|"
                lc-billable-list   = lc-billable-list + string(WebissCont.Billable) + "|"
                lc-connotes-list   = lc-connotes-list + string(WebissCont.Notes) + "|"
                lc-defcons-list    = lc-defcons-list  + string(WebissCont.DefCon) + "|"
                lc-conactive-list  = lc-conactive-list  + string(WebissCont.ConActive) + "|"
                lc-connums-list    = lc-connums-list  + string(WebissCont.ConID) + "|"
                lc-saved-recids    = lc-saved-recids + string(ROWID(WebIssCont)) + "|".
        END.
        ASSIGN  
            lc-saved-contracts  =  TRIM(lc-contract-list,"|")
            lc-saved-billables  =  TRIM(lc-billable-list,"|")
            lc-saved-connotes   =  TRIM(lc-connotes-list,"|")
            lc-saved-defcons    =  TRIM(lc-defcons-list,"|")
            lc-saved-conactives =  TRIM(lc-conactive-list,"|")
            lc-saved-connums    =  TRIM(lc-connums-list,"|")
            .                                             

    END.
    
    IF request_method = "POST" THEN
    DO:

        IF lc-mode <> "delete" THEN
        DO:
            ASSIGN 
                lc-accountnumber     = get-value("accountnumber")
                lc-name              = get-value("name")
                lc-address1          = get-value("address1")
                lc-address2          = get-value("address2")
                lc-city              = get-value("city")
                lc-county            = get-value("county")
                lc-country           = get-value("country")
                lc-postcode          = get-value("postcode")
                lc-telephone         = get-value("telephone")
                lc-contact           = get-value("contact")
                lc-notes             = get-value("notes")
                lc-sla-selected      = get-value("sla")
                lc-supportticket     = get-value("supportticket")
                lc-statementemail    = get-value("statementemail")
                lc-isactive          = get-value("isactive")
                lc-st-num            = get-value("st-num")
                lc-viewAction        = get-value("viewaction")
                lc-viewActivity      = get-value("viewactivity")
                lc-saved-contracts   = get-value("savedcontracts")
                lc-saved-billables   = get-value("savedbillables")
                lc-saved-connotes    = get-value("savedconnotes")
                lc-saved-defcons     = get-value("saveddefcons")
                lc-saved-conactives  = get-value("savedconactives")
                lc-saved-recids      = get-value("savedrecids")
                .

            
            RUN ip-Validate( OUTPUT lc-error-field,
                OUTPUT lc-error-msg ).

            IF lc-error-msg = "" THEN
            DO:
                
                IF lc-mode = 'update' THEN
                DO:
                    FIND b-table WHERE ROWID(b-table) = to-rowid(lc-rowid)
                        EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                    IF LOCKED b-table 
                        THEN  RUN htmlib-AddErrorMessage(
                            'none', 
                            'This record is locked by another user',
                            INPUT-OUTPUT lc-error-field,
                            INPUT-OUTPUT lc-error-msg ).
                END.
                ELSE
                DO:
                    CREATE b-table.
                    ASSIGN 
                        b-table.accountnumber = CAPS(lc-accountnumber)
                        b-table.CompanyCode   = lc-global-company
                        lc-firstrow      = STRING(ROWID(b-table)).
                   
                END.
                IF lc-error-msg = "" THEN
                DO:
                    ASSIGN 
                        b-table.name         = lc-name
                        b-table.address1       = lc-address1
                        b-table.address2       = lc-address2
                        b-table.city           = lc-city
                        b-table.county         = lc-county
                        b-table.country        = lc-country
                        b-table.postcode       = lc-postcode
                        b-table.contact        = lc-contact
                        b-table.telephone      = lc-telephone
                        b-table.notes          = lc-notes
                        b-table.supportticket  = lc-supportticket
                        b-table.statementemail = lc-statementemail
                        b-table.isActive       = lc-isActive = "on"
                        b-table.ViewAction     = lc-viewAction = "on"
                        b-table.ViewActivity   = lc-viewActivity = "on"
                        b-table.st-num         = INT(lc-st-num)
                        vz = 0.
                     
                    RUN ip-AddContracts.

                    ASSIGN
                        lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,b-table.AccountNumber).
                    IF lc-sla-selected = "slanone" 
                        OR lc-sla-rows = "" THEN 
                    DO:
                        ASSIGN 
                            b-table.DefaultSLAID = 0.
                           
                    END.
                    ELSE
                    DO:
                        FIND slahead WHERE ROWID(slahead) = to-rowid(substr(lc-sla-selected,4)) NO-LOCK NO-ERROR.
                        IF AVAILABLE slahead THEN 
                        DO:
                            ASSIGN 
                                b-table.DefaultSLAID = slahead.SLAID.
                        END.
    
                    END.
                END.
            END.

        END.
        ELSE
        DO:
            FIND b-table WHERE ROWID(b-table) = to-rowid(lc-rowid)
                EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF LOCKED b-table 
                THEN  RUN htmlib-AddErrorMessage(
                    'none', 
                    'This record is locked by another user',
                    INPUT-OUTPUT lc-error-field,
                    INPUT-OUTPUT lc-error-msg ).
            ELSE 
            DO:
                
                DELETE b-table.
            END.
        END.

        IF lc-error-field = "" THEN
        DO:
            RUN outputHeader.
            set-user-field("navigation",'refresh').
            set-user-field("firstrow",lc-firstrow).
            set-user-field("search",lc-search).
            RUN run-web-object IN web-utilities-hdl ("cust/cust.p").
            RETURN.
        END.
    END.

    IF lc-mode <> 'add' THEN
    DO:
        FIND b-table WHERE ROWID(b-table) = to-rowid(lc-rowid) NO-LOCK.
        ASSIGN 
            lc-accountnumber = b-table.accountnumber.

        IF CAN-DO("view,delete",lc-mode)
            OR request_method <> "post" THEN 
        DO:
            ASSIGN 
                lc-name      = b-table.name
                lc-address1  = b-table.address1
                lc-address2  = b-table.address2
                lc-city      = b-table.city
                lc-county    = b-table.county
                lc-country   = b-table.country
                lc-postcode  = b-table.postcode
                lc-telephone = b-table.telephone
                lc-contact   = b-table.contact
                lc-notes     = b-table.notes
                lc-supportticket = b-table.SupportTicket
                lc-statementemail = b-table.statementemail
                lc-isactive = IF b-table.isActive THEN "on" ELSE ""
                lc-viewAction = IF b-table.viewAction THEN "on" ELSE ""
                lc-viewActivity = IF b-table.viewActivity THEN "on" ELSE ""
                lc-st-num = STRING(b-table.st-num)
                .

            IF b-table.DefaultSLAID = 0
                THEN ASSIGN lc-sla-selected = "slanone".
            ELSE
            DO:
                FIND slahead
                    WHERE slahead.SLAID = b-table.defaultSLAID NO-LOCK NO-ERROR.
                IF AVAILABLE slahead
                    THEN ASSIGN lc-sla-selected = "sla" + string(ROWID(slahead)).
            END.
            
        END.
        ASSIGN 
            lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,b-table.AccountNumber).
       
    END.
    ELSE ASSIGN lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,"").


    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle(lc-title) skip.

    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip.
        
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.



    RUN ip-MainPage.

    RUN ip-Contracts.

    IF lc-mode = "view" THEN
    DO:
        RUN ip-TicketTransactions ( b-table.CompanyCode, b-table.AccountNumber ).
        RUN ip-AccountUsers ( b-table.CompanyCode, b-table.AccountNumber ).
    END.


    IF lc-error-msg <> "" THEN
    DO:
        {&out} '<BR><BR><CENTER>' 
        htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    END.

    IF lc-submit-label <> "" THEN
    DO:
        {&out} '<br><center>' htmlib-SubmitButton("submitform",lc-submit-label) 
        '</center>' skip.
    END.

    {&out} htmlib-Hidden ("savedcontracts", lc-saved-contracts) skip
           htmlib-Hidden ("savedbillables", lc-saved-billables) skip
           htmlib-Hidden ("savedconnotes", lc-saved-connotes) skip
           htmlib-Hidden ("saveddefcons", lc-saved-defcons) skip
           htmlib-Hidden ("savedconactives", lc-saved-conactives) skip
           htmlib-Hidden ("savedrecids", lc-saved-recids) skip
           htmlib-Hidden ("totalcontracts", string(vx)) skip.

    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.
    
  
END PROCEDURE.


&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addBalloon) = 0 &THEN

FUNCTION addBalloon RETURNS CHARACTER
    ( f-text AS CHARACTER ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE newText AS CHARACTER NO-UNDO.

    newText = "onMouseOver=~\~"javascript:displayBalloon(~'balloon~',~'on~',~' ".
    newText = newText +  f-text.
    newText = newText + "~');~\~"".
    newText = newText +  " onMouseOut=~\~"javascript:displayBalloon(~'balloon~',~'off~',~' ".
    newText = newText +  f-text.
    newText = newText +  "~');~\~"" .
 


    RETURN newText.

END FUNCTION.


&ENDIF

