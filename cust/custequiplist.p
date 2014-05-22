&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        cust/custequip.p
    
    Purpose:        Customer Maintenance - Equipment Browse        
    
    Notes:
    
    
    When        Who         What
    22/04/2006  phoski      Initial
    
    03/09/2010  DJS         3704 - Customer Details Tab alteration
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

def var lc-rowid as char no-undo.


def var lc-customer     as char no-undo.


def buffer b-ivClass    for ivClass.
def buffer b-query      for CustIv.
def buffer b-search     for CustIv.

def buffer b-customer   for customer.     /* 3704 */ 
def buffer b-custIv     for custIv.       /* 3704 */ 
def buffer b-ivSub      for ivSub.        /* 3704 */ 


def query q for b-query scrolling.

def var lc-object           as char no-undo.
def var lc-subobject        as char no-undo.
def var lc-ajaxSubWindow    as char no-undo.
def var lc-expand           as char no-undo.


def var lc-htmlreturn       as char no-undo.                 /* 3704 */ 
def var ll-htmltrue         as log  no-undo.                 /* 3704 */ 
def var lc-temp             as char no-undo.                 /* 3704 */ 
def var rdpIP               as char no-undo.                 /* 3704 */            
def var rdpUser             as char no-undo.                 /* 3704 */ 
def var rdpPWord            as char no-undo.                 /* 3704 */            
def var rdpDomain           as char no-undo.                 /* 3704 */ 
def var first-RDP           as log  initial true no-undo.    /* 3704 */ 
def var lc-tempAddress      as char no-undo.                 /* 3704 */

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

&IF DEFINED(EXCLUDE-ip-AccountHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-AccountHeader Procedure 
PROCEDURE ip-AccountHeader :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       New in 3704 
------------------------------------------------------------------------------*/
  def input param p-postcode as char no-undo.
  def input param p-name     as char no-undo.


{&out}
    '<div class="toolbar"> <span style="margin-left:2px;">'
    '<a href="javascript:void(0)"onclick="goGMAP(~''
    + replace(p-postcode," ","+")                  
    + '~',~''                                               
    + replace(replace(trim(p-name)," ","+"),"&","")
    + '~',~''                                               
    + replace(replace(lc-tempAddress,"~n","+"),"&","")                                              
    + '~')">'
    '<img border="0" src="/images/toolbar3/Gmap.gif" alt="View map" class="tbarimg"></a>'
    '<a href="javascript:void(0)"onclick="goRDP()">'
    '<img border="0" src="/images/toolbar3/winrdp.gif" alt="Connect to customer" class="tbarimg"></a>'
    '</span></div>'
  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-AccountInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-AccountInformation Procedure 
PROCEDURE ip-AccountInformation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-companycode      as char     no-undo.
    def input param pc-AccountNumber    as char     no-undo.
    
    def buffer b-query  for Customer.
    

    def var lc-address      as char     no-undo.
    def var lc-temp         as char     no-undo.
   


    find b-query
        where b-query.CompanyCode   = pc-CompanyCode
          and b-query.AccountNumber = pc-AccountNumber no-lock no-error.
    if not avail b-query then return.
   

    
    assign
        lc-address = "".

    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.Address1).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.Address2).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.City).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.County).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.Country).
    lc-address = dynamic-function("com-StringReturn",lc-address,b-query.PostCode).

    assign lc-tempAddress = lc-address.                                     /* 3704 */ 
                                                                            
    RUN ip-AccountHeader(b-query.postcode, b-query.name).                   /* 3704 */ 

    {&out} skip
           replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').

    {&out}
            htmlib-TableHeading(
            "Account^left|Name^left|Address^left|Contact|Telephone|Notes")
            skip.

    {&out}
        '<tr>' skip
        htmlib-MntTableField(html-encode(b-query.AccountNumber),'left')
        htmlib-MntTableField(html-encode(b-query.name),'left').

/*     if b-query.PostCode = "" then                                                                                       */
    {&out}
        htmlib-MntTableField(replace(html-encode(lc-address),"~n","<br>"),'left').
/*     else                                                                                                                */
/*     do:                                                                                                                 */
/*         assign lc-temp = replace(htmlib-MntTableField(replace(html-encode(lc-address),"~n","<br>"),'left'),"</td>",""). */
/*         lc-temp = lc-temp +                                                                                             */
/*                 '<br><a  target="new" href="http://www.streetmap.co.uk/streetmap.dll?postcode2map?code='                */
/*                         + replace(b-query.postcode," ","+")                                                             */
/*                         + "&title="                                                                                     */
/*                         + replace(replace(b-query.name," ","+"),"&","")                                                 */
/*                         + '"><img border=0 src=/images/general/map.gif title="View Map TWO">'                           */
/*                         + '</a>'.                                                                                       */
/*             .                                                                                                           */
/*         {&out} lc-temp.                                                                                                 */
/*     end.                                                                                                                */

    {&out}
        htmlib-MntTableField(html-encode(b-query.Contact),'left')
        htmlib-MntTableField(html-encode(b-query.Telephone),'left').

    if b-query.notes = ""
    then {&out} htmlib-MntTableField("",'left').
    else {&out} replace(htmlib-TableField(replace(html-encode(b-query.notes),"~n",'<br>'),'left'),
                '<td','<th style="color: red;') skip.
    {&out}
     
        '</tr>' skip.

       



    {&out} skip 
           htmlib-EndTable()
           
           skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-ip-SetRDP-M) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SetRDP-M Procedure 
PROCEDURE ip-SetRDP-M :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       New in 3704 
------------------------------------------------------------------------------*/
  def input param p-recid as recid no-undo.
  def output param p-html         as char initial "~',~'~',~'"  no-undo.
  def output param  p-ok          as log  initial false no-undo.
  def var ou                      as char no-undo.
  def var ip                      as char no-undo.

  find b-custIv where recid(b-custIv) = p-recid no-lock no-error.
  find first b-ivSub of b-custIv no-lock no-error.
  
  find first ivField of b-ivSub
     where ivField.ivFieldID = 73932 no-lock no-error.

  find first CustField
      where CustField.CustIvID = b-custIv.CustIvId
        and CustField.ivFieldId = ivField.ivFieldId
        no-lock no-error.

  if avail CustField then 
  do:
    assign
        ip = trim(CustField.FieldData)
        ou = substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou = ou + substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou = ou + substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou =  ou + TRIM(substr(ip,1,3), "~/,.;:!? ~"~ '[]()abcdefghijklmnopqrstuvwxyz").
        
    if num-entries(ou,".") <> 4 then return.
    else 
    do:
      assign rdpIP = trim(ou)
             p-ok  = true.
      
      find first ivField of b-ivSub
        where ivField.ivFieldID = 73934 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpUser = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
                                     
      find first ivField of b-ivSub
        where ivField.ivFieldID = 73935 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpPWord  = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
                                     
      find first ivField of b-ivSub
        where ivField.ivFieldID = 73933 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpDomain  = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
  
       p-html =  rdpIP + '~',~'' + rdpUser + '~',~'' + rdpDomain.

      end.

    end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-SetRDP-O) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-SetRDP-O Procedure 
PROCEDURE ip-SetRDP-O :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       New in 3704 
------------------------------------------------------------------------------*/
  def input param p-recid as recid no-undo.
  def output param p-html         as char initial "~',~'~',~'"  no-undo.
  def output param p-ok           as log  initial false no-undo.
  def var ou                      as char no-undo.
  def var ip                      as char no-undo.


  find b-custIv where recid(b-custIv) = p-recid no-lock no-error.
  find first b-ivSub of b-custIv no-lock no-error.
  
  find first ivField of b-ivSub
     where ivField.ivFieldID = 53 no-lock no-error.
/*   where ivField.ivFieldID = 74870 no-lock no-error.  */

  find first CustField
      where CustField.CustIvID = b-custIv.CustIvId
        and CustField.ivFieldId = ivField.ivFieldId
        no-lock no-error.

  if avail CustField then 
  do:
    assign
        ip = trim(CustField.FieldData)
        ou = substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou = ou + substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou = ou + substr(ip,1,index(ip,"."))
        ip = substr(ip,index(ip,".") + 1)
        ou =  ou + TRIM(substr(ip,1,3), "~/,.;:!? ~"~ '[]()abcdefghijklmnopqrstuvwxyz").
        
    if num-entries(ou,".") <> 4 then return.
    else 
    do:
      assign rdpIP = trim(ou)
             p-ok  = true. 
      
      find first ivField of b-ivSub
        where ivField.ivFieldID = 54 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpUser = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
                                     
      find first ivField of b-ivSub
        where ivField.ivFieldID = 55 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpPWord  = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
                                     
      find first ivField of b-ivSub
        where ivField.ivFieldID = 45619 no-lock no-error.
  
      find first CustField
          where CustField.CustIvID = b-custIv.CustIvId
            and CustField.ivFieldId = ivField.ivFieldId
            no-lock no-error.
    
      if avail CustField then assign rdpDomain  = if trim(CustField.FieldData) <> "" then trim(CustField.FieldData) else " ".
  
     p-html =  rdpIP + '~',~'' + rdpUser + '~',~'' + rdpDomain.

    end.

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
   
   if lc-AjaxSubWindow = "yes"
   then output-content-type("text/plain~; charset=iso-8859-1":U).
   else output-content-type ("text/html":U).
  
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

   
    assign
        lc-customer = get-value("customer")
        lc-ajaxSubWindow = get-value("ajaxsubwindow")
        lc-expand = get-value("expand").
        

    find customer
        where rowid(customer) = to-rowid(lc-customer) no-lock no-error.

    RUN outputHeader.
    
    if lc-AjaxSubWindow <> "yes" then
    do:
    
        {&out} htmlib-Header("Customer Inventory List") skip.
    
        {&out} 
            '<script language="JavaScript" src="/scripts/js/tree.js"></script>' skip.
    
        {&out} htmlib-StartForm("mainform","post", appurl + '/cust/custequip.p' ) skip.
        
        {&out} htmlib-ProgramTitle("Customer Inventory List - " + 
                               customer.name) skip.
    
        {&out} skip
           htmlib-StartMntTable().
    end.
    else
    do:
       RUN ip-AccountInformation ( customer.CompanyCode,
                                    customer.AccountNumber ).
       RUN ip-AccountUsers ( customer.CompanyCode,
                              customer.AccountNumber ).
       find first b-query of customer no-lock no-error.
        if not avail b-query then return.
        {&out}
            replace(htmlib-StartMntTable(),'width="100%"','width="95%" align="center"').

    end.
    
    {&out}
            htmlib-TableHeading(
            "Select Inventory|"
            ) skip.

    
    {&out}
        '<tr class="tabrow1">'
        '<td valign="top" nowrap class="tree">' skip
        .
    for each b-query no-lock of customer,
        first ivSub no-lock of b-query,
        first ivClass no-lock of ivSub
        break by ivClass.DisplayPriority DESC
              by ivClass.Name
              by ivSub.DisplayPriority DESC
              by ivSub.name
              by b-query.Ref:

        
        

        assign 
            lc-object = "CLASS" + string(rowid(ivClass))
            lc-subobject = "SUB" + string(rowid(ivSub)).
        if first-of(ivClass.name) then
        do:
            if lc-expand = "yes" 
            then {&out} '<img src="/images/general/menuopen.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">'
                '&nbsp;' '<span style="' ivClass.Style '">' html-encode(ivClass.name) '</span><br>'
                '<div id="' lc-object '" style="padding-left: 15px; display: block;">' skip.
            else {&out}
                '<img src="/images/general/menuclosed.gif" onClick="hdexpandcontent(this, ~''
                        lc-object '~')">'
                '&nbsp;' '<span style="' ivClass.Style '">' html-encode(ivClass.name) '</span><br>'
                '<div id="' lc-object '" style="padding-left: 15px; display: none;">' skip.
        end.

        if first-of(ivSub.name) then
        do:
            if lc-expand = "yes"
            then {&out} 
                '<img src="/images/general/menuopen.gif" onClick="hdexpandcontent(this, ~''
                        lc-subobject '~')">'
                '&nbsp;'
                '<span style="' ivSub.Style '">'
                html-encode(ivSub.name) '</span><br>' skip
                '<div id="' lc-subobject '" style="padding-left: 15px; display: block;">' skip.
                
            else {&out} 
                '<img src="/images/general/menuclosed.gif" onClick="hdexpandcontent(this, ~''
                        lc-subobject '~')">'
                '&nbsp;'
                '<span style="' ivSub.Style '">'
                html-encode(ivSub.name) '</span><br>' skip
                '<div id="' lc-subobject '" style="padding-left: 15px; display: none;">' skip.
        end.
       
/* -------------------------------------------------------------------------- 3704 STARTS */ 
 

        ll-htmltrue = false.
        
        {&out} '<a '.

        if b-query.ivSubID = 52 then
        do:
          run ip-SetRDP-O( recid(b-query),
                           output lc-htmlreturn,
                           output ll-htmltrue).
        end.
        else
        if b-query.ivSubID = 73928 then
        do:
          run ip-SetRDP-M( recid(b-query),
                           output lc-htmlreturn,
                           output ll-htmltrue).
        end.
          
        if ll-htmltrue then {&out} ' onclick="javascript:newRDP(~'' + lc-htmlreturn + '~')"  '.
          
        {&out} 'href="'
               "javascript:ahah('" 
               appurl "/cust/custequiptable.p?rowid=" string(rowid(b-query))
               "','inventory');".

        {&out}
                    '">' html-encode(b-query.ref) '</a><br>' skip.

        if first-RDP then
        do:
          if ll-htmltrue then
          do:
            assign first-RDP = false.
            {&out} '<div id="ScriptDiv" style="visibility:hidden; position:absolute; top:-1px; left:-1px " ></div>'.
            {&out} '<div id="ScriptSet" style="visibility:hidden; position:absolute; top:-1px; left:-1px " > ~n'
                   '<script defer > ~n'
                   '<!-- hide script from old browsers ~n'
                   '   newRDP(~'' + lc-htmlreturn + '~'); ~n'
                   ' --> ~n'
                   '</script></div>~n'.
          end.
        end.


/* -------------------------------------------------------------------------- 3704  end */ 

        if last-of(ivSub.name) then
        do:
            {&out} '</div>' skip.
            
             
        end.


        if last-of(ivClass.name) then
        do:
            {&out} '</div>' skip.
            
        end.

        
            
    end.

    {&out} '</td>' skip.
                
    {&out} '<td valign="top" rowspan="100" ><div id="inventory">&nbsp;</div></td>'.
    {&out} '</tr>' skip.


    {&out} skip 
           htmlib-EndTable()
           skip.
        /* -------------------------------------------------------------------------- 3704 */ 
     if  first-RDP then
     do:
       {&out} '<div id="ScriptSet" style="visibility:hidden; position:absolute; top:-1px; left:-1px " > ~n'
              '<script defer > ~n'
              '<!-- hide script from old browsers   ~n'
              '   function goRDP() ~{ ~n'
              '     alert("No connection information found"); ~n'
              '   ~}   ~n'
              ' --> ~n'
              '</script></div>~n'.
     end.    
    
        /* -------------------------------------------------------------------------- 3704 */ 
    if lc-AjaxSubWindow <> "yes" then
    do:
        {&out} skip
               htmlib-Hidden("customer",lc-customer) skip
               skip.
    
        {&out} htmlib-EndForm().
    


        {&OUT} htmlib-Footer() skip.

    
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

