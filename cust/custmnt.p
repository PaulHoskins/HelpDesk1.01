&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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


def var v-debug      as log initial false.

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.


def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.


def buffer b-valid for customer.
def buffer b-table for customer.

def temp-table conts like ContractType
    index i-conts ContractNumber.

def buffer b-tabletype for WebissCont.
def buffer bb-tabletype for WebissCont.
def temp-table b-webcont like WebissCont.

def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.



def var lc-accountnumber    as char no-undo.
def var lc-name             as char no-undo.
def var lc-address1         as char no-undo.
def var lc-address2         as char no-undo.
def var lc-city             as char no-undo.
def var lc-county           as char no-undo.
def var lc-country          as char no-undo.
def var lc-postcode         as char no-undo.
def var lc-telephone        as char no-undo.
def var lc-contact          as char no-undo.
def var lc-notes            as char no-undo. 
def var lc-supportticket    as char no-undo.
def var lc-statementemail   as char no-undo.
def var lc-isActive         as char no-undo.
def var lc-viewAction       as char no-undo.
def var lc-viewActivity     as char no-undo.
DEF VAR lc-st-num           AS CHAR NO-UNDO.
DEF VAR lc-st-code          AS CHAR NO-UNDO.
DEF VAR lc-st-descr         AS CHAR NO-UNDO.



def var lc-sla-rows         as char no-undo.
def var lc-sla-selected     as char no-undo.

def var lc-temp             as char no-undo.

def var vx                  as int  no-undo.
def var vz                  as int  no-undo.
def var vc-con              as char extent 20 no-undo.

def var lc-saved-contracts  as char no-undo.
def var lc-saved-connums    as char no-undo.
def var lc-saved-billables  as char no-undo.
def var lc-saved-connotes   as char no-undo.
def var lc-saved-defcons    as char no-undo.
def var lc-saved-conactives as char no-undo.
def var lc-saved-recids     as char no-undo.

def var lc-connums-list     as char no-undo.
def var lc-contract-list    as char no-undo.
def var lc-billable-list    as char no-undo.
def var lc-connotes-list    as char no-undo.
def var lc-defcons-list     as char no-undo.
def var lc-conactive-list   as char no-undo.
def var lc-contractnotes    as char no-undo.
def var lc-contractbilling  as char no-undo.

def var lc-contract         as char extent 20 no-undo.
def var ll-billable         as log  extent 20 no-undo.
def var lc-connotes         as char extent 20 no-undo.
def var ll-default          as log  extent 20 no-undo.
def var ll-conactive        as log  extent 20 no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addBalloon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addBalloon Procedure 
FUNCTION addBalloon RETURNS CHARACTER
  ( f-text as char )  FORWARD.

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
         HEIGHT             = 6.12
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

&IF DEFINED(EXCLUDE-ip-AccountUsers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-AccountUsers Procedure 
PROCEDURE ip-AccountUsers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    
    def buffer b-query  for webUser.
    def var lc-nopass   as char no-undo.


    if not can-find(first b-query
                where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber no-lock) 
                 then return.
   

    

    {&out} skip
           htmlib-StartFieldSet("Customer Users") 
           htmlib-StartMntTable().

    {&out}
            htmlib-TableHeading(
            "User Name^left|Name^left|Email^left|Telephone|Mobile|Track?|Disabled?"
            ) skip.


    for each b-query no-lock
        where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber
         :
    
   
         assign lc-nopass = if b-query.passwd = ""
                           or b-query.passwd = ?
                           then " (No password)"
                           else "".
        
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

       
            
    end.


    {&out} skip 
           htmlib-EndTable()
           htmlib-EndFieldSet() 
           skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-AddContracts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-AddContracts Procedure 
PROCEDURE ip-AddContracts :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var nextID  as int no-undo.

do vx = 1 to num-entries(trim(lc-saved-contracts,"|"),"|"):
  
   find b-tabletype 
      where  rowid(b-tabletype)  = to-rowid(entry(vx,lc-saved-recids,"|"))
      exclusive-lock no-error.
  
  if entry(vx,lc-saved-contracts,"|") = "NONE" 
   or entry(vx,lc-saved-contracts,"|") = "" 
    and avail b-tabletype then 
  do:
   delete b-tabletype.
if v-debug then do:
output to "c:\temp\djstest.txt" append.
put unformatted "Deleted  - " string(vx) " -- "  entry(vx,lc-saved-recids,"|")  " - "  string(num-entries(lc-saved-contracts,"|")) skip.
output close.
end.
  end.
  else
  do:
  
     if not avail b-tabletype then 
     do:
          find last bb-tabletype 
              where bb-tabletype.CompanyCode     = b-table.CompanyCode
              and   bb-tabletype.Customer        = b-table.AccountNumber 
              no-lock no-error.
               if avail bb-tabletype then nextID = bb-tabletype.ConID + 1.
                                     else nextID = 1.
if v-debug then do:
output to "c:\temp\djstest.txt" append.
put unformatted "Created  -  " string(vx) "  "  string(nextID) " _ "  string(num-entries(lc-saved-contracts,"|")) skip.
output close.
end.
           create b-tabletype.
           assign b-tabletype.ConID          = nextID
                  b-tabletype.CompanyCode    = b-table.CompanyCode  
                  b-tabletype.Customer       = b-table.AccountNumber 
                  b-tabletype.ContractCode   = entry(vx,lc-saved-contracts,"|")
                  b-tabletype.Billable       = entry(vx,lc-saved-billables,"|") = "yes"
                  b-tabletype.Notes          = entry(vx,lc-saved-connotes,"|")
                  b-tabletype.DefCon         = entry(vx,lc-saved-defcons,"|") = "yes"
                  b-tabletype.ConActive      = entry(vx,lc-saved-conactives,"|") = "yes"
             .
if v-debug then do:
output to "c:\temp\djstest.txt" append.
put unformatted "Done Created  -  " string(vx) "  "  string(nextID) skip.
output close.
end.
  
     end.
     else
     do:
     assign b-tabletype.ContractCode   = entry(vx,lc-saved-contracts,"|")
            b-tabletype.Billable       = entry(vx,lc-saved-billables,"|") = "yes"
            b-tabletype.Notes          = entry(vx,lc-saved-connotes,"|")
            b-tabletype.DefCon         = entry(vx,lc-saved-defcons,"|") = "yes"
            b-tabletype.ConActive      = entry(vx,lc-saved-conactives,"|") = "yes"
           .
if v-debug then do:  
output to "c:\temp\djstest.txt" append.
put unformatted "In Assign Update   " skip.
output close.
end.
     end.
  end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Contracts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Contracts Procedure 
PROCEDURE ip-Contracts :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var vy  as int  no-undo.
def var v-conn-start  as char no-undo.
def var total-contracts as int  no-undo.
    
total-contracts = 10.

total-contracts = total-contracts .

  v-conn-start = '<table id=~'dynamiccontents~' cellpadding=0 cellspacing=0  valign=~'top~'><tr>'.
  v-conn-start = v-conn-start + '<td  class=~'sidelabel~'  valign=~'top~'>Contracts:&nbsp;</td><td>'.
  

  /* FIRST CONTRACT                                                                                                                    */
  if vx > 0 then
  do:
    vc-con[1] = vc-con[1] + '<!--   FIRST  --><div id=~'DD1~'  >'.
    vc-con[1] = vc-con[1] + '<input id=~'defcon1~' name=~'defcon1~' class=~'inputfield~' type=~'radio~' ' + addBalloon("Default?") + ' onclick=~'javascript:SDefCon(1)~' value=~'defcon1~'' .
    if ll-default[1] = true then vc-con[1] = vc-con[1] + ' checked '.
    vc-con[1] = vc-con[1] + '><select class=~'inputfield~'  id=~'contract1~' name=~'contract1~' valign=~'top~' width=~'200px~' disabled >'.
    for each conts no-lock:
      vc-con[1] = vc-con[1] + '<option '.
      if lc-contract[1] = conts.ContractNumber then
        vc-con[1] = vc-con[1] + ' selected '.
      vc-con[1] = vc-con[1] + '  value=~'' + conts.ContractNumber + '~'>' + conts.Description + '</option>'.
    end.
    vc-con[1] = vc-con[1] + '</select>'.
    vc-con[1] = vc-con[1] + '<input id=~'cnotes1~' class=~'tablefield~' type=~'text~' onChange=~'javascript:SNotes(1,this.value)~' value=~'' + lc-connotes[1] +   '~' >'.
     vc-con[1] = vc-con[1] + ' <input id=~'conactive1~' type=~'checkbox~' ' + addBalloon("Active?") + ' onclick=~\~"javascript:SConActive(~'1~');~\~"   '.
    if ll-conactive[1] then vc-con[1] = vc-con[1] + " checked ".
    vc-con[1] = vc-con[1] + ' >'.
    vc-con[1] = vc-con[1] + ' <input id=~'billable1~' type=~'checkbox~' ' + addBalloon("Billable?") + ' onclick=~\~"javascript:SBillable(~'1~');~\~"   '.
    if ll-billable[1] then vc-con[1] = vc-con[1] + " checked ".
    vc-con[1] = vc-con[1] + ' >'.
    vc-con[1] = vc-con[1] + ' <img src=~'/images/general/remove01.gif~'' + addBalloon("Click to delete") + ' id=~'RM1~' onclick=~\~"javascript:SRemove(this);~\~">'.
    vc-con[1] = vc-con[1] + '</div></td></tr>'.
    vc-con[1] = vc-con[1] + '<tr><td></td><td> '.
  end.


  /* NEXT CONTRACTS                                                                                                                       */
  if vx > 1 then
  do vz = 2 to vx :          
    vc-con[vz] = '<!--   NEXT  --><div id=~'DD' + string(vz) + '~' >'.
    vc-con[vz] = vc-con[vz] + '<input  id=~'defcon' + string(vz) + '~' name=~'defcon' + string(vz) + '~'  class=~'inputfield~' type=~'radio~' ' + addBalloon("Default?") + ' onclick=~'javascript:SDefCon(' + string(vz) + ')~' value=~'defcon' + string(vz) + '~''.
    if ll-default[vz] = true then vc-con[vz] = vc-con[vz] + ' checked '.
    vc-con[vz] = vc-con[vz] + '><select class=~'inputfield~'  id=~'contract' + string(vz) + '~' name=~'contract' + string(vz) + '~' valign=~'top~' width=~'100px~' disabled >'.
    for each conts no-lock   :
      vc-con[vz] = vc-con[vz] + '<option '.
      if lc-contract[vz] = conts.ContractNumber then 
        vc-con[vz] = vc-con[vz] + ' selected '.
      vc-con[vz] = vc-con[vz] + ' value=~'' + conts.ContractNumber + '~'>' + conts.Description + '</option>'. 
    end.
    vc-con[vz] = vc-con[vz] + '</select>'. 
    vc-con[vz] = vc-con[vz] + '<input id=~'cnotes' + string(vz) + '~' class=~'tablefield~' type=~'text~' onChange=~'javascript:SNotes(' + string(vz) + ',this.value)~' value=~'' + lc-connotes[vz] +   '~' >'.
    vc-con[vz] = vc-con[vz] + ' <input id=~'conactive' + string(vz) + '~' type=~'checkbox~' ' + addBalloon("Active?") + ' onclick=~\~"javascript:SConActive(~'' + string(vz) + '~');~\~"   '.
    if ll-conactive[vz] then vc-con[vz] = vc-con[vz] + " checked ".
    vc-con[vz] = vc-con[vz] + ' >'.
      vc-con[vz] = vc-con[vz] + ' <input id=~'billable' + string(vz) + '~' type=~'checkbox~' ' + addBalloon("Billable?") + ' onclick=~\~"javascript:SBillable(~'' + string(vz) + '~');~\~"   '.
    if ll-billable[vz] then vc-con[vz] = vc-con[vz] + " checked ".
    vc-con[vz] = vc-con[vz] + ' >'.
    vc-con[vz] = vc-con[vz] + ' <img src=~'/images/general/remove01.gif~'' + addBalloon("Click to delete") + ' id=~'RM'  + string(vz) + '~' onclick=~\~"javascript:SRemove(this);~\~">'.
    vc-con[vz] = vc-con[vz] + '</div></td></tr><tr> '.  
    vc-con[vz] = vc-con[vz] + '<td></td><td   >'.  
   end.
  


  /* BLANK CONTRACTS                                                                                                                       */
  if vx <= total-contracts then
  do vz = (vx + 1) to total-contracts :

    vc-con[vz] = '<!--   BLANKS  --><div id=~'DD' + string(vz) + '~' style=~\~"display:none;~\~"  >'.
  /*   vc-con[vz] = ' <tr    ><td></td><td   ><div id=~'DD' + string(vz) + '~'    >'.  */
    vc-con[vz] = vc-con[vz] + '<input  id=~'defcon' + string(vz) + '~' name=~'defcon' + string(vz) + '~'  class=~'inputfield~' type=~'radio~' ' + addBalloon("Default?") + ' onclick=~'javascript:SDefCon(' + string(vz) + ')~' value=~'defcon' + string(vz) + '~''.
    if ll-default[vz] = true then vc-con[vz] = vc-con[vz] + ' checked '.
    vc-con[vz] = vc-con[vz] + '><select class=~'inputfield~' id=~'contract' + string(vz) + '~' name=~'contract' + string(vz) + '~' disabled  valign=~'top~' width=~'100px~' >'.
    vc-con[vz] = vc-con[vz] + '<option '.
    vc-con[vz] = vc-con[vz] + ' value=~'NONE~'>Add Contract</option>'. 
    for each conts no-lock:
      if lookup(string(conts.ContractNumber),lc-contract-list) > 0 then 
        next.
      vc-con[vz] = vc-con[vz] + '<option '.
      vc-con[vz] = vc-con[vz] + ' value=~'' + conts.ContractNumber + '~'>' + conts.Description + '</option>'. 
    end.
    vc-con[vz] = vc-con[vz] + ' </select>'.
    vc-con[vz] = vc-con[vz] + '<input id=~'cnotes' + string(vz) + '~' class=~'tablefield~' type=~'text~' onChange=~'javascript:SNotes(' + string(vz) + ',this.value)~' value=~'' + lc-connotes[vz] +   '~' >'.
    vc-con[vz] = vc-con[vz] + ' <input id=~'conactive' + string(vz) + '~' type=~'checkbox~' ' + addBalloon("Active?") + ' onclick=~\~"javascript:SConActive(~'' + string(vz) + '~');~\~"   '.
    if ll-conactive[vz] then vc-con[vz] = vc-con[vz] + " checked ".
    vc-con[vz] = vc-con[vz] + ' >'.
      vc-con[vz] = vc-con[vz] + ' <input id=~'billable' + string(vz) + '~' type=~'checkbox~' ' + addBalloon("Billable?") + ' onclick=~\~"javascript:SBillable(~'' + string(vz) + '~');~\~"   '.
    if ll-billable[vz] then vc-con[vz] = vc-con[vz] + " checked ".
    vc-con[vz] = vc-con[vz] + ' >'.
    vc-con[vz] = vc-con[vz] + ' <img src=~'/images/general/remove01.gif~'' + addBalloon("Click to delete") + ' id=~'RM'  + string(vz) + '~' onclick=~\~"javascript:SRemove(this);~\~">'.
    vc-con[vz] = vc-con[vz] + '</div></td></tr><tr><td></td><td> '.
  end.
 
/*   vz = vz + 1. */
  
  {&out}  htmlib-Hidden ("vx...............", string(vx)) skip.
  {&out}  htmlib-Hidden ("vz...............", string(vz)) skip.

 /* NEW CONTRACT                                                                                                                             */
 if vx < total-contracts then 
    vc-con[20] = vc-con[20] + '<!--   ADD  --><div id=~'DD' + string(20) + '~' >'.
 else
    vc-con[20] = vc-con[20] + '<!--   ADD  --><div id=~'DD' + string(20) + '~' style=~\~"display:none;~\~"  >'.

    vc-con[20] = vc-con[20] + '<input id=~'defcon' + string(20) + '~' name=~'defcon' + string(20) + '~' class=~'inputfield~' type=~'radio~' ' + addBalloon("Default?") + '   value=~'defcon' + string(20) + '~' '.
    if vz <= 1 then vc-con[20] = vc-con[20] + " checked".
    vc-con[20] = vc-con[20] + '><select class=~'inputfield~' id=~'contract' + string(20) + '~' name=~'contract' + string(20) + '~' ' + addBalloon("Choose Contract") + ' onChange=~'javascript:SNewContract(' + string(20) + ')~' valign=~'top~' width=~'100px~' >'.
    vc-con[20] = vc-con[20] + '<option '.
    vc-con[20] = vc-con[20] + ' value=~'NONE~'>Add Contract</option>'.
    for each conts no-lock:
      if lookup(string(conts.ContractNumber),lc-contract-list) > 0 then
        next.
      vc-con[20] = vc-con[20] + '<option '.
      vc-con[20] = vc-con[20] + ' value=~'' + conts.ContractNumber + '~'>' + conts.Description + '</option>'.
    end.
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

  if vz <= 1 then  {&out}  vc-con[1] .
  else
  do vy = 1 to vz:
    
     {&out}  vc-con[vy] .

  end.
  {&out}  vc-con[20] .

  {&out} 
  '";' skip
  '</script>' skip
  
  htmlib-Hidden ("contractnotes", lc-contractnotes) skip
  htmlib-Hidden ("contractbilling", lc-contractbilling) skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-MainPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-MainPage Procedure 
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
           ( if lookup("accountnumber",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("Account Number")
           else htmlib-SideLabel("Account Number"))
           '</TD>' skip
           .

    if lc-mode = "ADD" then
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
            (if lookup("name",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Name")
            else htmlib-SideLabel("Name"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("name",40,lc-name) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-name),'left')
           skip.

    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("address1",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Address")
            else htmlib-SideLabel("Address"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("address1",40,lc-address1) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-address1),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("address2",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("")
            else htmlib-SideLabel(""))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("address2",40,lc-address2) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-address2),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("city",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("City/Town")
            else htmlib-SideLabel("City/Town"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("city",40,lc-city) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-city),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("county",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("County")
            else htmlib-SideLabel("County"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("county",40,lc-county) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-county),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("country",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Country")
            else htmlib-SideLabel("Country"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("country",40,lc-country) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-country),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("postcode",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Post Code")
            else htmlib-SideLabel("Post Code"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("postcode",20,lc-postcode) 
            '</TD>' skip.
    else 
    do:

        if lc-postcode = "" then 
        {&out} htmlib-TableField(html-encode(lc-postcode),'left')
           skip.
        else
        do:
            lc-temp = replace(htmlib-TableField(html-encode(lc-postcode),'left'),"</td>","").
            lc-temp = lc-temp + 
                '<br><a  target="new" href="http://www.streetmap.co.uk/streetmap.dll?postcode2map?code=' 
                        + replace(lc-postcode," ","+") 
                        + "&title=" 
                        + replace(replace(lc-name," ","+"),"&","")
                        + '"><img border=0 src=/images/general/map.gif title="View Map">' 
                        + '</a>'.
            .
        {&out} lc-temp.


        end.
    end.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("contact",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Contact")
            else htmlib-SideLabel("Contact"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("contact",40,lc-contact) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-contact),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("telephone",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Telephone")
            else htmlib-SideLabel("Telephone"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("telephone",20,lc-telephone) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-telephone),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("notes",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Note")
            else htmlib-SideLabel("Note"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-TextArea("notes",lc-notes,5,60)
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(replace(html-encode(lc-notes),"~n",'<br>'),'left')
           skip.
    {&out} '</TR>' skip.

    
    if lc-sla-rows <> "" then
    do:
        {&out} '<TR><TD VALIGN="TOP" ALIGN="right" width="25%">' 
               (if lookup("sla",lc-error-field,'|') > 0 
               then htmlib-SideLabelError("Default SLA")
               else htmlib-SideLabel("Default SLA"))
               '</TD>'
               .
        if not can-do("view,delete",lc-mode)
        then 
        do:
            {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">' skip.
            RUN ip-SLATable.
            {&out} '</td>'.
        end.
        else 
        do:
            if b-table.DefaultSLAID = 0
            then {&out} htmlib-TableField(html-encode("None"),'left').
            else
            do:
                find slahead where slahead.SLAID = b-table.DefaultSLAID no-lock no-error.
                {&out} htmlib-TableField(html-encode(slahead.description),'left').
            end.
               

        end.

        {&out} '</TR>' skip.

    end.
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("st-num",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Support Team")
            else htmlib-SideLabel("Support Team"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-Select("st-num",lc-st-Code,lc-st-descr,lc-st-num)
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(lc-st-num,'left')
           skip.
    {&out} '</TR>' skip.

    /***/

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("supportticket",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Support Tickets Used?")
            else htmlib-SideLabel("Support Tickets Used?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
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
            (if lookup("statementemail",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Statement Email Address")
            else htmlib-SideLabel("Statement Email Address"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-InputField("statementemail",40,lc-statementemail) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-statementemail),'left')
           skip.
    {&out} '</TR>' skip.


    if not can-do("view,delete",lc-mode) then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("viewaction",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("View Actions?")
            else htmlib-SideLabel("View Actions?"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-CheckBox("viewaction", if lc-viewAction = 'on'
                                        then true else false) 
            '</TD></TR>' skip.

     if not can-do("view,delete",lc-mode) then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("viewactivity",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("View Activities?")
            else htmlib-SideLabel("View Activities?"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-CheckBox("viewactivity", if lc-viewActivity = 'on'
                                        then true else false) 
            '</TD></TR>' skip.


    if not can-do("view,delete",lc-mode) then
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("gotomaint",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Active?")
            else htmlib-SideLabel("Active?"))
            '</TD>'
            '<TD VALIGN="TOP" ALIGN="left" COLSPAN="2">'
            htmlib-CheckBox("isactive", if lc-isActive = 'on'
                                        then true else false) 
            '</TD></TR>' skip.

    {&out} htmlib-EndTable() skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SLATable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SLATable Procedure 
PROCEDURE ip-SLATable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def buffer slahead  for slahead.
    def var li-loop     as int      no-undo.
    def var lc-object   as char     no-undo.
    def var lc-rowid    as char     no-undo.


    {&out}
        htmlib-StartMntTable()
        htmlib-TableHeading(
        "Select?^left|SLA|Notes"
        ) skip.

    if lc-global-company = "MICAR" then
    do:
    {&out}
        htmlib-trmouse()
            '<td>'
                htmlib-Radio("sla", "slanone" , if lc-sla-selected = "slanone" then true else false)
            '</td>'
            htmlib-TableField(html-encode("None"),'left')
            htmlib-TableField("",'left')
        '</tr>' skip.
    end.

    do li-loop = 1 to num-entries(lc-sla-rows,"|"):
        assign
            lc-rowid = entry(li-loop,lc-sla-rows,"|").

        find slahead where rowid(slahead) = to-rowid(lc-rowid) no-lock no-error.
        if not avail slahead then next.
        assign
            lc-object = "sla" + lc-rowid.
        {&out}
            htmlib-trmouse()
                '<td>'
                    htmlib-Radio("sla" , lc-object, if lc-sla-selected = lc-object then true else false) 
                '</td>'
                htmlib-TableField(html-encode(slahead.description),'left')
                htmlib-TableField(replace(slahead.notes,"~n",'<br>'),'left')
            '</tr>' skip.

    end.
    
        
    {&out} skip 
       htmlib-EndTable()
       skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-TicketTransactions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-TicketTransactions Procedure 
PROCEDURE ip-TicketTransactions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    
    def buffer b-query      for ticket.
    def buffer IssActivity  for IssActivity.
    def buffer issue        for issue.
        
    def var lc-Issue        as char no-undo.
    def var lc-Activity     as char no-undo.
    def var li-cf           as int  no-undo.


    if not can-find(first b-query
                   where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber no-lock) 
                 then return.

    {&out} skip
           htmlib-StartFieldSet("Ticket Transactions") 
           htmlib-StartMntTable().

    {&out}
            htmlib-TableHeading(
            "Date^right|Type|Reference|Issue Number^right||Activity|Time^right|Carried Forward^right"
            ) skip.


    for each b-query no-lock
        where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber
         :

        assign
            lc-issue = ""
            lc-Activity = ""
            li-cf = li-cf + b-query.Amount.

        if b-query.IssueNumber > 0 then
        do:
            find Issue of b-query no-lock no-error.

            if avail Issue 
            then assign lc-issue = Issue.BriefDescription.
        end.

        if b-query.IssActivityID > 0 then
        do:
            find issActivity where issActivity.issActivityID = 
                                   b-query.IssActivityID no-lock no-error.
            if avail issActivity 
            then assign lc-Activity = issActivity.description.
        end.
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




    end.

    {&out} skip 
           htmlib-EndTable()
           htmlib-EndFieldSet() 
           skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-Validate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Validate Procedure 
PROCEDURE ip-Validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  objtargets:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.

    if lc-mode = "ADD":U then
    do:
        if lc-accountnumber = ""
        or lc-accountnumber = ?
        then run htmlib-AddErrorMessage(
                    'accountnumber', 
                    'You must enter the account number',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        

        if can-find(first b-valid
                    where b-valid.CompanyCode = lc-global-company
                      and b-valid.accountnumber = lc-accountnumber
                    no-lock)
        then run htmlib-AddErrorMessage(
                    'accountnumber', 
                    'This account number already exists',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    end.

    if lc-name = ""
    or lc-name = ?
    then run htmlib-AddErrorMessage(
                    'name', 
                    'You must enter the name',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
 

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
  
    for each ContractType where ContractType.CompanyCode = lc-global-company
      no-lock:
      create conts.
      buffer-copy ContractType to conts.
    end.

    for each conts:
      assign lc-contractnotes = lc-contractnotes + conts.Notes + "|"
             lc-contractbilling = lc-contractbilling + if conts.Billable then "yes|" else  "|".

    end.

    RUN com-GetTeams ( lc-global-company, OUTPUT lc-st-code, OUTPUT lc-st-descr ).

    ASSIGN
        lc-st-code = "0|" + lc-st-code
        lc-st-descr = "None Selected|" + lc-st-descr.


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

    case lc-mode:
        when 'add'
        then assign lc-title = 'Add'
                    lc-link-label = "Cancel addition"
                    lc-submit-label = "Add Customer".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete Customer'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update Customer'.
    end case.


    assign lc-title = lc-title + ' Customer'
           lc-link-url = appurl + '/cust/cust.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&time=' + string(time)
                           .

    if can-do("view,update,delete",lc-mode) then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid)
             no-lock no-error.
        if not avail b-table then
        do:
            set-user-field("mode",lc-mode).
            set-user-field("title",lc-title).
            set-user-field("nexturl",appurl + "/cust/cust.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.
        vx = 0.
        for each WebissCont where WebissCont.CompanyCode = b-table.CompanyCode
                            and   WebissCont.Customer    = b-table.AccountNumber
                            no-lock
                            by    WebIssCont.ConID  :
          create b-webcont.
          buffer-copy WebissCont to b-webcont.
          assign  vx = vx + 1
                  lc-contract[vx]    = string(WebissCont.ContractCode)
                  ll-billable[vx]    = WebissCont.Billable
                  lc-connotes[vx]    = string(WebissCont.Notes)
                  ll-default[vx]     = WebissCont.DefCon
                  ll-conactive[vx]   = WebissCont.ConActive
                  lc-contract-list   = lc-contract-list + string(WebissCont.ContractCode) + "|"
                  lc-billable-list   = lc-billable-list + string(WebissCont.Billable) + "|"
                  lc-connotes-list   = lc-connotes-list + string(WebissCont.Notes) + "|"
                  lc-defcons-list    = lc-defcons-list  + string(WebissCont.DefCon) + "|"
                  lc-conactive-list  = lc-conactive-list  + string(WebissCont.ConActive) + "|"
                  lc-connums-list    = lc-connums-list  + string(WebissCont.ConID) + "|"
                  lc-saved-recids    = lc-saved-recids + string(rowid(WebIssCont)) + "|".
        end.
        assign  lc-saved-contracts  =  trim(lc-contract-list,"|")
                lc-saved-billables  =  trim(lc-billable-list,"|")
                lc-saved-connotes   =  trim(lc-connotes-list,"|")
                lc-saved-defcons    =  trim(lc-defcons-list,"|")
                lc-saved-conactives =  trim(lc-conactive-list,"|")
                lc-saved-connums    =  trim(lc-connums-list,"|")
          .                                             

    end.
    
    if request_method = "POST" then
    do:

        if lc-mode <> "delete" then
        do:
            assign lc-accountnumber     = get-value("accountnumber")
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

            
            RUN ip-Validate( output lc-error-field,
                             output lc-error-msg ).

            if lc-error-msg = "" then
            do:
                
                if lc-mode = 'update' then
                do:
                    find b-table where rowid(b-table) = to-rowid(lc-rowid)
                        exclusive-lock no-wait no-error.
                    if locked b-table 
                    then  run htmlib-AddErrorMessage(
                                   'none', 
                                   'This record is locked by another user',
                                   input-output lc-error-field,
                                   input-output lc-error-msg ).
                end.
                else
                do:
                    create b-table.
                    assign b-table.accountnumber = caps(lc-accountnumber)
                           b-table.CompanyCode   = lc-global-company
                           lc-firstrow      = string(rowid(b-table)).
                   
                end.
                if lc-error-msg = "" then
                do:
                      assign b-table.name         = lc-name
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

                    assign
                    lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,b-table.AccountNumber).
                    if lc-sla-selected = "slanone" 
                    or lc-sla-rows = "" then 
                    do:
                        assign b-table.DefaultSLAID = 0.
                           
                    end.
                    else
                    do:
                        find slahead where rowid(slahead) = to-rowid(substr(lc-sla-selected,4)) no-lock no-error.
                        if avail slahead then 
                        do:
                            assign b-table.DefaultSLAID = slahead.SLAID.
                        end.
    
                    end.
                end.
            end.

        end.
        else
        do:
            find b-table where rowid(b-table) = to-rowid(lc-rowid)
                 exclusive-lock no-wait no-error.
            if locked b-table 
            then  run htmlib-AddErrorMessage(
                                   'none', 
                                   'This record is locked by another user',
                                   input-output lc-error-field,
                                   input-output lc-error-msg ).
            else 
            do:
                
                delete b-table.
            end.
        end.

        if lc-error-field = "" then
        do:
            RUN outputHeader.
            set-user-field("navigation",'refresh').
            set-user-field("firstrow",lc-firstrow).
            set-user-field("search",lc-search).
            RUN run-web-object IN web-utilities-hdl ("cust/cust.p").
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        assign lc-accountnumber = b-table.accountnumber.

        if can-do("view,delete",lc-mode)
        or request_method <> "post" then 
        do:
            assign lc-name      = b-table.name
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
                   lc-isactive = if b-table.isActive then "on" else ""
                   lc-viewAction = if b-table.viewAction then "on" else ""
                   lc-viewActivity = if b-table.viewActivity then "on" else ""
                   lc-st-num = STRING(b-table.st-num)
                   .

            if b-table.DefaultSLAID = 0
            then assign lc-sla-selected = "slanone".
            else
            do:
                find slahead
                    where slahead.SLAID = b-table.defaultSLAID no-lock no-error.
                if avail slahead
                then assign lc-sla-selected = "sla" + string(rowid(slahead)).
            end.
            
        end.
        assign lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,b-table.AccountNumber).
       
    end.
    else assign lc-sla-rows = com-CustomerAvailableSLA(lc-global-company,"").


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

    if lc-mode = "view" then
    do:
        RUN ip-TicketTransactions ( b-table.CompanyCode, b-table.AccountNumber ).
        RUN ip-AccountUsers ( b-table.CompanyCode, b-table.AccountNumber ).
    end.


    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.

    if lc-submit-label <> "" then
    do:
        {&out} '<br><center>' htmlib-SubmitButton("submitform",lc-submit-label) 
               '</center>' skip.
    end.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addBalloon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addBalloon Procedure 
FUNCTION addBalloon RETURNS CHARACTER
  ( f-text as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
def var newText as char no-undo.

newText = "onMouseOver=~\~"javascript:displayBalloon(~'balloon~',~'on~',~' ".
newText = newText +  f-text.
newText = newText + "~');~\~"".
newText = newText +  " onMouseOut=~\~"javascript:displayBalloon(~'balloon~',~'off~',~' ".
newText = newText +  f-text.
newText = newText +  "~');~\~"" .
 


 RETURN newText.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

