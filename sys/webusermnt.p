&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webusermnt.p
    
    Purpose:        User Maintenance 
    
    Notes:
    
    
    When        Who         What
    09/04/2006  phoski      UserClass field
    10/04/2006  phoski      Company Code
    11/04/2006  phoski      CustomerTrack
    28/04/2006  phoski      RecordsPerPage
    30/04/2006  phoski      Mobile & AllowSMS AccessSMS
    17/08/2006  phoski      QuickView
    20/05/2014  phoski      DFS bug fixes & Team Selections
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-msg  as char no-undo.

def var li-curr-year      as int format "9999"  no-undo.
def var li-end-week       as int format "99"    no-undo.
def var ld-curr-hours     as dec  format "99.99" extent 7   no-undo.
def var lc-day            as char initial "Mon,Tue,Wed,Thu,Fri,Sat,Sun" no-undo.

def var lc-mode as char no-undo.
def var lc-rowid as char no-undo.
def var lc-title as char no-undo.


def buffer b-valid for webuser.
def buffer b-table for webuser.
DEF BUFFER webuSteam    FOR webuSteam.
DEF BUFFER steam        FOR steam.

def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.


def var lc-link-label   as char no-undo.
def var lc-submit-label as char no-undo.
def var lc-link-url     as char no-undo.


def var lc-loginid      as char no-undo.
def var lc-forename     as char no-undo.
def var lc-surname      as char no-undo.
def var lc-email        as char no-undo.
def var lc-usertitle    as char no-undo.
def var lc-pagename     as char no-undo.
def var lc-disabled     as char no-undo.
def var lc-accountnumber as char no-undo.
def var lc-jobtitle     as char no-undo.
def var lc-telephone    as char no-undo.
def var lc-password     as char no-undo.
def var lc-userClass    as char no-undo.
def var lc-customertrack as char no-undo.
def var lc-recordsperpage as char no-undo.
def var lc-mobile         as char no-undo.
def var lc-allowsms       as char no-undo.
def var lc-accesssms      as char no-undo.
def var lc-superuser      as char no-undo.
def var lc-quickview      as char  no-undo.
def var lc-DefaultUser    as char  no-undo.
DEF VAR lc-html           AS CHAR NO-UNDO.
DEF VAR ll-check          AS LOG  NO-UNDO.
DEF VAR li-Count          AS INT  NO-UNDO.
DEF VAR li-row            AS INT INITIAL 3 NO-UNDO.


def var lc-usertitleCode  as char
    initial ''    no-undo.
def var lc-usertitleDesc  as char
    initial '' no-undo.

def var lc-HoursOnAm    as char  extent 7 initial "00:00" no-undo.
def var lc-HoursOffAm   as char  extent 7 initial "00:00" no-undo.
def var lc-HoursOnPm    as char  extent 7 initial "00:00" no-undo.
def var lc-HoursOffPm   as char  extent 7 initial "00:00" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-html-InputFieldMasked) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD html-InputFieldMasked Procedure 
FUNCTION html-InputFieldMasked RETURNS CHARACTER
  ( pc-name as char,
    pc-maxlength as char,
    pc-datatype as char,
    pc-mask as char,
    pc-value as char,
    pc-style as char )  FORWARD.

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
         WIDTH              = 60.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}
{lib/htmlib.i}
{lib/maillib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ip-Page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-Page Procedure 
PROCEDURE ip-Page :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
           ( if lookup("loginid",lc-error-field,'|') > 0 
           then htmlib-SideLabelError("User Name")
           else htmlib-SideLabel("User Name"))
           '</TD>' skip
           .

    if lc-mode = "ADD" then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
           htmlib-InputField("loginid",20,lc-loginid) skip
           '</TD>'.
    else
    {&out} htmlib-TableField(html-encode(lc-loginid),'left')
           skip.
    {&out} '</TR>' skip.

    if not can-do("VIEW,DELETE",lc-mode) then
    do:
        {&out} '<TR><TD VALIGN="TOP" ALIGN="RIGHT">' 
            if lookup("password",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Password")
            else htmlib-SideLabel("Password")
            '</TD><TD VALIGN="TOP" ALIGN="LEFT">'.
        {&out}  htmlib-InputPassword("password",20,"")
                '</TD>' skip.
    end.
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("usertitle",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Title")
            else htmlib-SideLabel("Title"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("usertitle",lc-usertitleCode,lc-usertitleDesc,lc-usertitle) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(
        entry(lookup(lc-usertitle,lc-usertitleCode,'|'),lc-usertitleDesc,'|')
        ),'left')
           skip.
    {&out} '</TR>' skip.



    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("forename",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Forename")
            else htmlib-SideLabel("Forename"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("forename",40,lc-forename) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-forename),'left')
           skip.
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("surname",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Surname")
            else htmlib-SideLabel("Surname"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("surname",40,lc-surname) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-surname),'left')
           skip.
    {&out} '</TR>' skip.

     {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("jobtitle",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Job Title/Position")
            else htmlib-SideLabel("Job Title/Position"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("jobtitle",20,lc-jobtitle) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-jobtitle),'left')
           skip.
    {&out} '</TR>' skip.
 

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("email",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Email")
            else htmlib-SideLabel("Email"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("email",40,lc-email) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-email),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("customertrack",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Customer Track?")
            else htmlib-SideLabel("Customer Track?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("customertrack", if lc-customertrack = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-customertrack = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("telephone",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Telephone")
            else htmlib-SideLabel("Telephone"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("telephone",20,lc-telephone) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-telephone),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("mobile",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Mobile")
            else htmlib-SideLabel("Mobile"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("mobile",20,lc-mobile) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-mobile),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("allowsms",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("SLA SMS Alerts?")
            else htmlib-SideLabel("SLA SMS Alerts?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("allowsms", if lc-allowsms = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-allowsms = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("accesssms",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Access SMS Web Page?")
            else htmlib-SideLabel("Access SMS Web Page?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("accesssms", if lc-accesssms = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-accesssms = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("pagename",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Menu Page")
            else htmlib-SideLabel("Menu Page"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("pagename",20,lc-pagename) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-pagename),'left')
           skip.
    if can-do("add,update",lc-mode) then
    do:
        {&out} skip
               '<td>'
               htmlib-Lookup("Lookup Page",
                             "pagename",
                             "nullfield",
                             appurl + '/lookup/menupage.p')
               '</TD>'
               skip.
    end.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("userclass",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("User Type")
            else htmlib-SideLabel("User Type"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-Select("userclass","INTERNAL|CUSTOMER|CONTRACT","Internal|Customer|Contractor",lc-userclass) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(
        lc-userclass
        ),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("superuser",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Super User?")
            else htmlib-SideLabel("Super User?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("superuser", if lc-superuser = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-superuser = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("quickview",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Access To Quick View?")
            else htmlib-SideLabel("Access To Quick View?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("quickview", if lc-quickview = 'on'
                                        then true else false) 
           '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-quickview = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("accountnumber",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Account Number")
            else htmlib-SideLabel("Account Number"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("accountnumber",8,lc-accountnumber) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-accountnumber),'left')
           skip.
    if can-do("add,update",lc-mode) then
    do:
        {&out} skip
               '<td>'
               htmlib-Lookup("Lookup Account",
                             "accountnumber",
                             "nullfield",
                             appurl + '/lookup/customer.p')
               '</TD>'
               skip.
    end.
    {&out} '</TR>' skip.

   
    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("disabled",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Disabled?")
            else htmlib-SideLabel("Disabled?"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("disabled", if lc-disabled = 'on'
                                        then true else false) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-disabled = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("defaultuser",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Main Customer Issue Contact?")
            else htmlib-SideLabel("Main Customer Issue Contact?"))
            
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-CheckBox("defaultuser", if lc-defaultuser = 'on'
                                        then true else false) 
          
           '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(if lc-defaultuser = 'on'
                                         then 'yes' else 'no'),'left')
           skip.
    
    {&out} '</TR>' skip.


    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            (if lookup("recordperpage",lc-error-field,'|') > 0 
            then htmlib-SideLabelError("Records Per Page")
            else htmlib-SideLabel("Records Per Page"))
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    {&out} '<TD VALIGN="TOP" ALIGN="left">'
            htmlib-InputField("recordsperpage",2,lc-recordsperpage) 
            '</TD>' skip.
    else 
    {&out} htmlib-TableField(html-encode(lc-recordsperpage),'left')
           skip.
    {&out} '</TR>' skip.

    {&out} '<TR><TD VALIGN="TOP" ALIGN="right">' 
            htmlib-SideLabel("Assigned Support Teams")
            '</TD>'.
    
    if not can-do("view,delete",lc-mode) then
    DO:
        {&out} '<TD VALIGN="TOP" ALIGN="left">'.

        {&out} htmlib-StartMntTable().

        FOR EACH steam NO-LOCK WHERE STEAM.companycode = lc-global-company:

            li-count = li-count + 1.
            IF li-count = 1 THEN
            DO:
                {&out} '<tr>' SKIP.

            END.
            lc-html = "steam" + STRING(steam.st-num).
            ll-check = get-value(lc-html) = "on".
            {&out} '<td>' htmlib-CheckBox(lc-html,ll-check) 
                ' - '  html-encode(steam.descr) '</td>' SKIP.
            IF li-count MOD li-row = 0 THEN
            DO:
                {&out} '</tr>'.
                li-count = 0.
            END.


        END.
        {&out} htmlib-EndTable() skip.

        {&out} '</TD>' skip.
    END.
    else
    DO:
        {&out} '<TD VALIGN="TOP" ALIGN="left">'.

        {&out} htmlib-StartMntTable().

        FOR EACH steam NO-LOCK WHERE STEAM.companycode = lc-global-company:

            lc-html = "steam" + STRING(steam.st-num).
            ll-check = get-value(lc-html) = "on".
            IF NOT ll-check THEN NEXT.

            li-count = li-count + 1.
            IF li-count = 1 THEN
            DO:
                {&out} '<tr>' SKIP.

            END.
            
            {&out} '<td>' html-encode(steam.descr) '</td>' SKIP.
            IF li-count MOD li-row = 0 THEN
            DO:
                {&out} '</tr>'.
                li-count = 0.
            END.


        END.
        {&out} htmlib-EndTable() skip.

        {&out} '</TD>' skip.

     
    END.

    {&out} '</TR>' skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ResetOtherMain) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ResetOtherMain Procedure 
PROCEDURE ip-ResetOtherMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-companycode      as char     no-undo.
    def input param pc-accountNumber    as char     no-undo.
    def input param pc-loginid          as char     no-undo.

    def buffer b-user   for webUser.

    
    for each b-user exclusive-lock
        where b-user.companyCode = pc-companyCode
          and b-user.AccountNumber = pc-AccountNumber:

        if b-user.LoginId <> pc-LoginId
        then assign b-user.defaultUser = false.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-timestable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-timestable Procedure 
PROCEDURE ip-timestable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var vx      as int  no-undo.
    def var lc-year as char no-undo.
    def var zx      as int  no-undo. 
    def var lc-var  as char no-undo.


        

    {&out} '<script>' skip.

        for each WebStdTime where WebStdTime.companycode = lc-global-company     
                            and   WebStdTime.LoginID     = b-table.loginID       
                            no-lock:                             
               lc-var = ''.
               do vx = 1 to 7:
                assign lc-var = lc-var +  string(WebStdTime.StdAMStTime[vx],"9999")   + ','
                       lc-var = lc-var +  string(WebStdTime.StdAMEndTime[vx],"9999")  + ','
                       lc-var = lc-var +  string(WebStdTime.StdPMStTime[vx],"9999")   + ','
                       lc-var = lc-var +  string(WebStdTime.StdPMEndTime[vx],"9999")  + ','  .
               end.
               lc-var = substr(lc-var,1,length(lc-var) - 1) . 

               {&out} 'var YEAR' string(WebStdTime.StdWkYear) ' = ~'' lc-var '~' ;' skip.

 
        end.

    {&out}  
           'function changeThisYear(varObj)' skip
           '~{' skip
           '  if (inEdit)' skip
           '  ~{' skip
           '    alert("You may have made changes to this year~'s times\n Please update or cancel before continuing");' skip
           '    return;' skip
           '  ~}' skip

           '  if (varObj != null)' skip
           '  ~{' skip
/*    '      alert(varObj.value);' skip */
           'try ~{' skip
           '  eval("var newyear=" + "YEAR" + varObj.value );  ' skip
           '~}' skip
           'catch (e) ~{' skip
           '   ' skip
           '~}' skip
/*       'alert("PAST HERE")' skip */
           '  document.mainform.elements["submityear"].value = varObj.value;' skip
/* 'alert(newyear);' skip */
/*       if (typeof __JSON != 'undefined') { */
           '  if (newyear)' skip
           ' ~{' skip
           '  var thisyear = newyear.split(",");' skip
/*    '     alert(thisyear);' skip */
           '  for (i=1;i<8;i++)' skip
           '   ~{' skip
           '      document.getElementById("hoursOnAm" + i).value = thisyear.shift();' skip
           '      document.getElementById("hoursOffAm" + i).value = thisyear.shift();' skip
           '      document.getElementById("hoursOnPm" + i).value = thisyear.shift();' skip
           '      document.getElementById("hoursOffPm" + i).value = thisyear.shift();' skip
           '   ~}' skip
           '   forceDisplay("mainform","60") ; ' skip
           '   focusDisplay("hoursOnAm1"); ' skip
           '  ~}' skip
           '  else' skip
           '  ~{' skip
           '   var answer = confirm("Do you want to copy the currently displayed times?\n (Cancel for cleared display of times)");' skip
           '   if (answer) ~{  ~};' skip
           '   else ~{ ' skip
           '  for (i=1;i<8;i++)' skip
           '   ~{' skip
           '      document.getElementById("hoursOnAm" + i).value = "0000";' skip
           '      document.getElementById("hoursOffAm" + i).value = "0000";' skip
           '      document.getElementById("hoursOnPm" + i).value = "0000";' skip
           '      document.getElementById("hoursOffPm" + i).value = "0000";' skip
           '   ~}' skip
           '   forceDisplay("mainform","60") ; ' skip
           '   focusDisplay("hoursOnAm1"); ' skip
            '  ~} ' skip
           '  ~} ' skip
           ' ~} ' skip 
           '~}' skip
           '</script>' skip.
    
    
    {&out} '<div id="newyeardiv" style="display:block;">' skip 
           '<select id="submityear" name="submityear" class="inputfield" ' skip
           ' onchange="changeThisYear(this);"  >' skip
           '<option value="" ' '>  Select Year </option>' skip.
           do zx = -1 to 4:
             lc-year = string(year(today) - zx).
             {&out} '<option value="' lc-year '" ' if integer(lc-year) = li-curr-year then "selected" else "" '>'  html-encode(lc-year) '</option>' skip.
           end.
    {&out} '</select>' skip.
    {&out} '</div>'.



 

    {&out} '<div id="changethisyear" > ' skip 
             htmlib-StartTable("mnt",
                              0,
                              0,
                              2,
                              0,
                              "center") skip.
    {&out}
           htmlib-TableHeading(
           "|Contracted Times (24 Hour Clock) for " + string(li-curr-year)
           ) skip.


   {&out} '<tr><td valign="top" align="right">'  skip
          '<td valign="top" align="center">On</td><td>&nbsp;</td> ' skip
          '<td valign="top" align="center">Off</td><td>&nbsp;</td> ' skip
          '<td valign="top" align="center">On</td><td>&nbsp;</td> ' skip
          '<td valign="top" align="center">Off</td><td>&nbsp;</td> ' skip.

 
    do vx = 1 to 7:
      
       {&out} '<tr><td valign="top" align="right">' entry(vx,lc-day) skip
       '<td valign="top" align="center">' html-InputFieldMasked("hoursOnAm"+ string(vx), "4","60","HH:MM",lc-HoursOnAm[vx],"font-family:verdana;font-size:10pt;width:50px;") '</td><td>&nbsp;</td>' skip     
       '<td valign="top" align="center">' html-InputFieldMasked("hoursOffAm"+ string(vx),"4","60","HH:MM",lc-HoursOffAm[vx],"font-family:verdana;font-size:10pt;width:50px;")'</td><td>&nbsp;</td>' skip     
       '<td valign="top" align="center">' html-InputFieldMasked("hoursOnPm"+ string(vx), "4","60","HH:MM",lc-HoursOnPm[vx],"font-family:verdana;font-size:10pt;width:50px;") '</td><td>&nbsp;</td>' skip     
       '<td valign="top" align="center">' html-InputFieldMasked("hoursOffPm"+ string(vx),"4","60","HH:MM",lc-HoursOffPm[vx],"font-family:verdana;font-size:10pt;width:50px;")'</td>' skip                    
       '</tr>' skip.                      
     end.

 

 

    {&out} skip 
           htmlib-EndTable() skip 
           '</div>' skip.
   


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
  emails:       
------------------------------------------------------------------------------*/
    def output param pc-error-field as char no-undo.
    def output param pc-error-msg  as char no-undo.


    def var li-int      as int      no-undo.

    if lc-mode = "ADD":U then
    do:
        if lc-loginid = ""
        or lc-loginid = ?
        then run htmlib-AddErrorMessage(
                    'loginid', 
                    'You must enter the user name',
                    input-output pc-error-field,
                    input-output pc-error-msg ).
        

        if can-find(first b-valid
                    where b-valid.loginid = lc-loginid
                    no-lock)
        then run htmlib-AddErrorMessage(
                    'loginid', 
                    'This user already exists',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    end.

    if lc-forename = ""
    or lc-forename = ?
    then run htmlib-AddErrorMessage(
                    'forename', 
                    'You must enter the forename',
                    input-output pc-error-field,
                    input-output pc-error-msg ).

    if lc-surname = ""
    or lc-surname = ?
    then run htmlib-AddErrorMessage(
                'surname', 
                'You must enter the surname',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    if lc-allowsms = "on"
    and lc-mobile = ""
    then run htmlib-AddErrorMessage(
                'allowsms', 
                'To allow SLA SMS alert messages you must enter a mobile number',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    if lc-allowsms = "on"
    and lc-userClass = "CUSTOMER"
    then run htmlib-AddErrorMessage(
                'allowsms', 
                'SLA SMS alert messages can not be sent to a customer',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
    if lc-accesssms = "on"
    and lc-userClass = "CUSTOMER"
    then run htmlib-AddErrorMessage(
                'accesssms', 
                'Access to the SMS web page is restricted to internal users',
                 input-output pc-error-field,
                 input-output pc-error-msg ).

    if lc-userClass <> "INTERNAL"
    and lc-superuser = "on" then
    do:
        run htmlib-AddErrorMessage(
                'superuser', 
                'Only Internal users can be super users',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
    end.
    if lc-userClass = "CUSTOMER"
    and lc-quickview = "on" then
    do:
        run htmlib-AddErrorMessage(
                'quickview', 
                'Only Internal users can have access to the quick view menu',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
    end.

    if lc-userclass <> "CUSTOMER"
    and lc-accountnumber <> "" then
    do:
        run htmlib-AddErrorMessage(
                'userclass', 
                'Internal/Contractor users do not have an account',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
    end.
    else
    if lc-userclass = "CUSTOMER"
    and lc-accountnumber = "" then
    do:
        run htmlib-AddErrorMessage(
                'accountnumber', 
                'You must enter an account',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
    end.

    if lc-accountnumber <> "" then
    do:
        if not can-find(customer where customer.company = lc-global-company and customer.accountnumber = lc-accountnumber no-lock)
        then run htmlib-AddErrorMessage(
                'accountnumber', 
                'This account does not exist',
                 input-output pc-error-field,
                 input-output pc-error-msg ).
    end.

    assign li-int = int(lc-recordsperpage) no-error.
    if error-status:error 
    or li-int < 5 then run htmlib-AddErrorMessage(
                'recordsperpage', 
                'This number of records to display must be 5 or greater',
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
  emails:       In the event that this Web object is state-aware, this is
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
  emails:       
------------------------------------------------------------------------------*/
    
    def var li-loop  as int  no-undo.

    {lib/checkloggedin.i} 


    assign lc-usertitleCode = htmlib-GetAttr("USER","Titles").

    if lc-usertitleCode =  "" 
    then assign lc-usertitleCode = 'Mr|Mrs'.

    assign lc-usertitleDesc = lc-usertitleCode.


    assign lc-mode = get-value("mode")
           lc-rowid = get-value("rowid")
           lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation")
           li-curr-year  = integer(get-value("submityear")).

    if li-curr-year = ? or li-curr-year = 0 then li-curr-year = year(today).

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
                    lc-submit-label = "Add User".
        when 'view'
        then assign lc-title = 'View'
                    lc-link-label = "Back"
                    lc-submit-label = "".
        when 'delete'
        then assign lc-title = 'Delete'
                    lc-link-label = 'Cancel deletion'
                    lc-submit-label = 'Delete User'.
        when 'Update'
        then assign lc-title = 'Update'
                    lc-link-label = 'Cancel update'
                    lc-submit-label = 'Update User'.
    end case.


    assign lc-title = lc-title + ' User'
           lc-link-url = appurl + '/sys/webuser.p' + 
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
            set-user-field("nexturl",appurl + "/sys/webuser.p").
            RUN run-web-object IN web-utilities-hdl ("mn/deleted.p").
            return.
        end.

    end.


    if request_method = "POST" then
    do:
        if lc-mode <> "delete" then
        do:
            assign lc-loginid         = get-value("loginid")
                   lc-forename        = get-value("forename")
                   lc-surname         = get-value("surname")
                   lc-email           = get-value("email")
                   lc-usertitle       = get-value("usertitle")
                   lc-pagename        = get-value("pagename")
                   lc-disabled        = get-value("disabled")
                   lc-accountnumber   = get-value("accountnumber")
                   lc-Jobtitle        = get-value("jobtitle")
                   lc-telephone       = get-value("telephone")
                   lc-password        = get-value("password")
                   lc-userclass       = get-value("userclass")
                   lc-customertrack   = get-value("customertrack")
                   lc-recordsperpage  = get-value("recordsperpage")
                   lc-allowsms        = get-value("allowsms")
                   lc-mobile          = get-value("mobile")
                   lc-accesssms       = get-value("accesssms")
                   lc-superuser       = get-value("superuser")
                   lc-quickview       = get-value("quickview")
                   lc-defaultuser     = get-value("defaultuser")
                   .
            
            do li-loop = 1 to 7:
              lc-HoursOnAm[li-loop]  =  get-value("hoursOnAm" + string(li-loop)).
              lc-HoursOffAm[li-loop] =  get-value("hoursOffAm" + string(li-loop)).
              lc-HoursOnPm[li-loop]  =  get-value("hoursOnPm" + string(li-loop)).
              lc-HoursOffPm[li-loop] =  get-value("hoursOffPm" + string(li-loop)).
            end.
            

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
                    assign b-table.loginid = lc-loginid
                           b-table.CompanyCode = lc-global-company
                           lc-firstrow      = string(rowid(b-table))
                           .
                   
                end.
                if lc-error-msg = "" then
                do:
                    assign b-table.forename         = lc-forename
                           b-table.surname          = lc-surname
                           b-table.email            = lc-email
                           b-table.usertitle        = lc-usertitle
                           b-table.pagename         = lc-pagename
                           b-table.disabled         = lc-disabled = 'on'
                           b-table.customertrack    = lc-customertrack = 'on'
                           b-table.accountnumber    = lc-accountnumber
                           b-table.jobtitle         = lc-jobtitle
                           b-table.telephone        = lc-telephone
                           b-table.userclass        = lc-userclass
                           b-table.recordsperpage   = int(lc-recordsperpage)
                           b-table.mobile           = lc-mobile
                           b-table.allowsms         = lc-allowsms = "on"
                           b-table.accesssms        = lc-accesssms = "on"
                           b-table.superuser        = lc-superuser = "on"
                           b-table.quickview        = lc-quickview = "on"
                           b-table.defaultuser      = lc-defaultuser = "on"
                           .
                    assign b-table.name = b-table.forename + ' ' + 
                                          b-table.surname.
                    if lc-password <> "" then 
                    do:
                        assign b-table.PassWd = encode(lc-password).
                        /*
                        dynamic-function("mlib-SendPassword",b-table.loginid,lc-password).
                        */
                    end.
                    FOR EACH webusteam OF b-table  EXCLUSIVE-LOCK:
                    
                            DELETE webusteam.
                    END.
                    FOR EACH steam NO-LOCK
                        WHERE steam.companycode = lc-global-company:
                        lc-html = "steam" + STRING(steam.st-num).
                        IF get-value(lc-html) <> "on" THEN NEXT.
                        CREATE webuSteam.
                        ASSIGN
                             webuSteam.LoginID = b-table.loginid
                             webuSteam.st-num = steam.st-num.

                    END.
                    if b-table.UserClass = "customer"
                    and b-table.AccountNumber <> ""
                    and b-table.DefaultUser = true then 
                    do:
                        b-table.CustomerTrack = true.
                        RUN ip-ResetOtherMain ( lc-global-company,
                                                 b-table.AccountNumber,
                                                 b-table.LoginId ).
                    end.
                    find first WebStdTime where WebStdTime.companycode = lc-global-company
                                          and   WebStdTime.LoginID     = b-table.loginID
                                          and   WebStdTime.StdWkYear   = li-curr-year
                                          exclusive-lock no-error.
                    if not avail WebStdTime then
                    do:
                      create WebStdTime.
                      assign WebStdTime.companycode = lc-global-company
                             WebStdTime.LoginID     = b-table.loginID
                             WebStdTime.StdWkYear   = li-curr-year.
                    end.
                    do li-loop = 1 to 7:
                      assign WebStdTime.StdAMStTime[li-loop]   = integer(replace(lc-HoursOnAm[li-loop],":",""))
                             WebStdTime.StdAMEndTime[li-loop]  = integer(replace(lc-HoursOffAm[li-loop],":",""))
                             WebStdTime.StdPMStTime[li-loop]   = integer(replace(lc-HoursOnPm[li-loop],":",""))
                             WebStdTime.StdPMEndTime[li-loop]  = integer(replace(lc-HoursOffPm[li-loop],":",""))  .
                    end.
                end.
            end.
        end.
        else
        do:
            find b-table where rowid(b-table) = to-rowid(lc-rowid)
                 exclusive-lock no-wait no-error.
            if locked b-table 
            then run htmlib-AddErrorMessage(
                                   'none', 
                                   'This record is locked by another user',
                                   input-output lc-error-field,
                                   input-output lc-error-msg ).
            else 
            do:
                FOR EACH webusteam OF b-table  EXCLUSIVE-LOCK:
                    
                    DELETE webusteam.
                END.
                delete b-table.
            END.
        end.

        if lc-error-field = "" then
        do:
            RUN outputHeader.
            set-user-field("navigation",'refresh').
            set-user-field("firstrow",lc-firstrow).
            set-user-field("search",lc-search).
            RUN run-web-object IN web-utilities-hdl ("sys/webuser.p").
            return.
        end.
    end.

    if lc-mode <> 'add' then
    do:
        find b-table where rowid(b-table) = to-rowid(lc-rowid) no-lock.
        assign lc-loginid = b-table.loginid.
        IF request_method = "GET" THEN
        FOR EACH webUsteam OF b-table NO-LOCK:
                
            lc-html = "steam" + STRING(webusteam.st-num).
            set-user-field(lc-html,"on").

        END.


        if can-do("view,delete",lc-mode) 
        or request_method <> "post" then 
        do:
            assign 
                lc-surname        = b-table.surname
                lc-email          = b-table.email
                lc-forename       = b-table.forename
                lc-usertitle      = b-table.usertitle
                lc-pagename       = b-table.pagename
                lc-disabled       = if b-table.disabled then 'on' else ''
                lc-accountnumber  = b-table.accountnumber
                lc-jobtitle       = b-table.jobtitle
                lc-telephone      = b-table.telephone
                lc-userclass      = b-table.userclass
                lc-customertrack  = if b-table.customertrack then 'on' else ''
                lc-recordsperpage = string(b-table.recordsperpage)
                lc-mobile         = b-table.mobile
                lc-accesssms      = if b-table.accesssms then 'on' else ''
                lc-allowsms       = if b-table.allowsms then 'on' 
                                    else ''
                lc-superuser      = if b-table.superuser then 'on'
                                    else ''
                lc-quickview      = if b-table.QuickView then 'on' 
                                    else '' 
                lc-defaultuser    = if b-table.DefaultUser then 'on'
                                    else ''
                    .
            find first WebStdTime where WebStdTime.companycode = lc-global-company
                                and   WebStdTime.LoginID     = b-table.loginID
                                and   WebStdTime.StdWkYear   = li-curr-year
                                no-lock no-error.
            if  avail WebStdTime then
            do li-loop = 1 to 7:
                assign lc-HoursOnAm[li-loop]  = string(WebStdTime.StdAMStTime[li-loop],"9999")
                       lc-HoursOffAm[li-loop] = string(WebStdTime.StdAMEndTime[li-loop],"9999")
                       lc-HoursOnPm[li-loop]  = string(WebStdTime.StdPMStTime[li-loop],"9999")
                       lc-HoursOffPm[li-loop] = string(WebStdTime.StdPMEndTime[li-loop],"9999")   .
             end.
        END.

       
    end.
    
    if request_method = "GET" and lc-mode = "ADD" then
    do:
        assign 
            lc-recordsperpage = "10".
    end.

    RUN outputHeader.
    
    {&out} htmlib-Header(lc-title) skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle(lc-title) skip.

/*     {&out} '<script language="JavaScript" src="/scripts/js/debug.js"></script>' skip.  */

    {&out} '<script language="JavaScript"> var debugThis         = false; </script>' skip.
    {&out} '<script language="JavaScript" src="/scripts/js/validate.js"></script>' skip.


    {&out} htmlib-Hidden ("savemode", lc-mode) skip
           htmlib-Hidden ("saverowid", lc-rowid) skip
           htmlib-Hidden ("savesearch", lc-search) skip
           htmlib-Hidden ("savefirstrow", lc-firstrow) skip
           htmlib-Hidden ("savelastrow", lc-lastrow) skip
           htmlib-Hidden ("savenavigation", lc-navigation) skip
           htmlib-Hidden ("nullfield", lc-navigation) skip.
        
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.

    {&out} '<table><tr><td>' skip.

    {&out} htmlib-StartInputTable() skip.


    RUN ip-Page.          


    {&out} htmlib-EndTable() skip.

    {&out} '</td><td valign="top" >' skip.


    {&out} htmlib-StartMntTable().
    
    if available b-table and b-table.UserClass <> "customer" 
      then run ip-timestable.
    {&out} htmlib-EndTable() skip.
    {&out} '</td></tr></table>' skip.



    if lc-error-msg <> "" then
    do:
        {&out} '<BR><BR><CENTER>' 
                htmlib-MultiplyErrorMessage(lc-error-msg) '</CENTER>' skip.
    end.

    if lc-submit-label <> "" then
    do:
        {&out} '<center>' htmlib-SubmitButton("submitform",lc-submit-label) 
               '</center>' skip.
    end.
         
   
    
    if lc-mode <> 'add'  and lc-userclass <> 'customer' then
      {&out} '<script>' skip
      ' forceDisplay("mainform","60") ; ' skip
      ' focusDisplay("hoursOnAm1"); ' skip
      '</script>' skip.

   {&out} htmlib-EndForm() skip
          htmlib-Footer() skip.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-html-InputFieldMasked) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION html-InputFieldMasked Procedure 
FUNCTION html-InputFieldMasked RETURNS CHARACTER
  ( pc-name as char,
    pc-maxlength as char,
    pc-datatype as char,
    pc-mask as char,
    pc-value as char,
    pc-style as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

def var r-htm as char no-undo.
   
r-htm = '<input type="text" id="' + pc-name + '" name="' + pc-name + '" value="' + pc-value + '"' +
        ' maxlength="' + pc-maxlength + '" datatype="' + pc-datatype + '" mask="' + pc-mask + '"' +
        ' onpaste="return tbPaste(this);"' +
        ' onfocus="return tbFocus(this);"' +
        ' onkeydown="return tbFunction(this);"' +
        ' onkeypress="return tbMask(this);"' +
        ' style="' + pc-style + '">'.
        
return r-htm.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

