&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/webconttime.p
    
    Purpose:        User Maintenance - Contract Time Editor
    
    Notes:
    
    
    When        Who         What
    09/04/2006  phoski      Initial
    10/04/2006  phoski      CompanyCode
    
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field    as char no-undo.
def var lc-error-msg      as char no-undo.

def var li-curr-year      as int format "9999"  no-undo.
def var li-end-week       as int format "99"    no-undo.
def var ld-curr-hours     as dec  format "99.99" extent 7   no-undo.
def var lc-day            as char initial "Mon,Tue,Wed,Thu,Fri,Sat,Sun" no-undo.

def var lc-mode           as char no-undo.
def var lc-rowid          as char no-undo.
def var lc-title          as char no-undo.
                          
def buffer b-valid        for webuser.
def buffer b-table        for webuser.
def buffer b-query        for Customer.

def var lc-search         as char  no-undo.
def var lc-firstrow       as char  no-undo.
def var lc-lastrow        as char  no-undo.
def var lc-navigation     as char no-undo.
def var lc-parameters     as char no-undo.
                          
def var lc-link-label     as char no-undo.
def var lc-submit-label   as char no-undo.
def var lc-link-url       as char no-undo.

def var lc-loginid        as char no-undo.
def var lc-forename       as char no-undo.
def var lc-surname        as char no-undo.
def var lc-email          as char no-undo.
def var lc-usertitle      as char no-undo.
def var lc-pagename       as char no-undo.
def var lc-disabled       as char no-undo.
def var lc-accountnumber  as char no-undo.
def var lc-jobtitle       as char no-undo.
def var lc-telephone      as char no-undo.
def var lc-password       as char no-undo.
def var lc-userClass      as char no-undo.

def var lc-usertitleCode  as char initial '' no-undo.
def var lc-usertitleDesc  as char initial '' no-undo.

def temp-table this-year
  field ty-week-no  as int
  field ty-hours    as dec
  index i-week ty-week-no.

def temp-table this-day
  field td-week-no  as int
  field td-day-no   as int
  field td-hours    as dec
  field td-reason   as char
  index i-week td-week-no td-day-no.

def var lc-submitweek       as char     no-undo.
def var lc-submitday        as char extent 7    no-undo.
def var lc-submitreason     as char extent 7    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Date2Wk Procedure 
FUNCTION Date2Wk RETURNS CHARACTER
  (input dMyDate as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dayOfWeek) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dayOfWeek Procedure 
FUNCTION dayOfWeek RETURNS INTEGER
  (input dMyDate as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-Wk2Date) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Wk2Date Procedure 
FUNCTION Wk2Date RETURNS CHARACTER
 (cWkYrNo as char) FORWARD.

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

&IF DEFINED(EXCLUDE-ip-build-year) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-build-year Procedure 
PROCEDURE ip-build-year :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var vx        as int  no-undo.
    def var vz        as int  no-undo.
    def var lc-date   as char no-undo.
    def var hi-date   as date no-undo.
    def var lo-date   as date no-undo.
    def var std-hours as dec format "99.99" no-undo.
    def var tmp-hours as dec format "99.99" no-undo.
    def var lc-list-reason-id as char initial "|01|02|03|04|05|10"  no-undo.
    def var lc-list-reason    as char initial "Select|BANK|LEAVE|SICK|DOC|DENT|OT"  no-undo.
  

    for each WebStdTime where WebStdTime.CompanyCode = lc-global-company                      
                        and   WebStdTime.LoginID     = lc-loginid                             
                        and   WebStdTime.StdWkYear   = li-curr-year
                        no-lock:
          do vx = 1 to 7:
            assign tmp-hours         =   ((truncate(WebStdTime.StdAMEndTime[vx] / 100,0) + dec(WebStdTime.StdAMEndTime[vx] modulo 100 / 60))          /* convert time to decimal  */ 
                                       - (truncate(WebStdTime.StdAMStTime[vx] / 100,0) + dec(WebStdTime.StdAMStTime[vx] modulo 100 / 60)))            /* convert time to decimal  */ 
                                       + ((truncate(WebStdTime.StdPMEndTime[vx] / 100,0) + dec(WebStdTime.StdPMEndTime[vx] modulo 100 / 60))          /* convert time to decimal  */                               
                                       - (truncate(WebStdTime.StdPMStTime[vx] / 100,0) + dec(WebStdTime.StdPMStTime[vx] modulo 100 / 60)))            /* convert time to decimal  */ 
                   ld-curr-hours[vx] = tmp-hours                                                                                                                                       
                   std-hours         = std-hours + tmp-hours.  
          end.
    end.
 

    do vx = 1 to li-end-week:
      assign lc-date = Wk2Date(string(string(vx,"99") + "-" + string(li-curr-year,"9999")))
             hi-date = date(entry(1,lc-date,"|"))
             lo-date = date(entry(2,lc-date,"|")).

      create this-year.
      assign ty-week-no = vx
             ty-hours   = std-hours.
       
        for each WebUserTime where WebUserTime.CompanyCode = lc-global-company                      
                             and   WebUserTime.LoginID     = lc-loginid                             
                             and   WebUserTime.EventDate   >= hi-date
                             and   WebUserTime.EventDate   <= lo-date 
                             no-lock:
          case WebUserTime.EventType :
            when "BANK"  then ty-hours = ty-hours - WebUserTime.EventHours.
            when "LEAVE" then ty-hours = ty-hours - WebUserTime.EventHours.
            when "SICK"  then ty-hours = ty-hours - WebUserTime.EventHours.
            when "DOC"   then ty-hours = ty-hours - WebUserTime.EventHours.
            when "DENT"  then ty-hours = ty-hours - WebUserTime.EventHours.
            when "OT"    then ty-hours = ty-hours + WebUserTime.EventHours.
          end case.
          assign vz = dayOfWeek(WebUserTime.EventDate).
          create this-day.
          assign td-week-no = vx
                 td-day-no  = vz
                 td-hours   = WebUserTime.EventHours 
                 td-reason  = entry(lookup(WebUserTime.EventType,lc-list-reason,"|"),lc-list-reason-id,"|")
            .
         
        end.
    end.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-ExportAccordion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-ExportAccordion Procedure 
PROCEDURE ip-ExportAccordion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {&out}
      '<style type="text/css">' skip
      
      '.clear ~{ /* generic container (i.e. div) for floating buttons */' skip
      'overflow: hidden;'    skip
      'width: 100%;' skip
      '~}' skip

      'a.button ~{' skip
      'background: transparent url(~'/images/toolbar/bg_button_a.gif~') no-repeat scroll top right;' skip
      'color: #444;' skip
      'display: block;' skip
      'float: left;' skip
      'font: normal 12px arial, sans-serif;' skip
      'height: 24px;' skip
      'margin-right: 6px;' skip
      'padding-right: 18px; /* sliding doors padding */' skip
      'text-decoration: none;' skip
      '~}' skip

      'a.button span ~{' skip
      'background: transparent url(~'/images/toolbar/bg_button_span1.gif~') no-repeat;' skip
      'display: block;' skip
      'line-height: 14px;' skip
      'padding: 5px 0 5px 18px;' skip
       'cursor: pointer;' skip
      '~} ' skip

      'a.button:active ~{' skip
      'background-position: bottom right;' skip
      'color: #000;' skip
      'outline: none; /* hide dotted outline in Firefox */' skip
       'cursor: pointer;' skip
      '~}' skip

      'a.button:active span ~{' skip
      'background-position: bottom left;' skip
      'padding: 6px 0 4px 18px; /* push text down 1px */' skip
       'cursor: pointer;' skip
      '~} ' skip

      '.buttonbox ~{' skip
      'border: 0px dotted blue;'  skip
      'padding: 1px; ' skip
      'margin-bottom: 1px;'  skip
      'margin-top: 1px; ' skip
      'font-weight: bold; ' skip
      'background-color: #FFFFFF;' skip
      'position: relative;' skip
      'width: 100%;' skip
      'height: 20px;     ' skip
      '~}' skip


      '.AccordionTitle, .AccordionTitle1, .AccordionTitle2, .AccordionContent, .AccordionContainer' skip
      '~{' skip
      'position: relative;' skip
      'margin-left:auto;' skip
      'margin-right:auto;' skip
      'width: 650px; /*changeble*/' skip
      'border-bottom: 1px dotted white;' skip
      '~}' skip


      '.AccordionTitle' skip
      '~{' skip
      'height: 20px; /*changeble*/' skip
      'overflow: hidden;' skip
      'cursor: pointer;' skip
      'font-family: Verdana; /*changeble*/' skip
      'font-size: 12px; /*changeble*/' skip
      'font-weight: normal; /*changeble*/' skip
      'vertical-align: middle; /*changeble*/' skip
      'text-align: center; /*changeble*/' skip
      'display: table-cell;' skip
      '-moz-user-select: none;' skip
      'border-top: none; /*changeble*/' skip
      'border-bottom: none; /*changeble*/' skip
      'border-left: none; /*changeble*/' skip
      'border-right: none; /*changeble*/' skip
      'background-color: #0099cc;' skip
      'color: White;' skip
      '~}' skip

      '.AccordionTitle1' skip
      '~{' skip
      'height: 20px; /*changeble*/' skip
      'overflow: hidden;' skip
      'cursor: pointer;' skip
      'font-family: Verdana; /*changeble*/' skip
      'font-size: 12px; /*changeble*/' skip
      'font-weight: normal; /*changeble*/' skip
      'vertical-align: middle; /*changeble*/' skip
      'text-align: center; /*changeble*/' skip
      'display: table-cell;' skip
      '-moz-user-select: none;' skip
      'border-top: none; /*changeble*/' skip
      'border-bottom: none; /*changeble*/' skip
      'border-left: none; /*changeble*/' skip
      'border-right: none; /*changeble*/' skip
      'background-color: #E4ECF0;' skip
/*       'background-color: #F5F5F5;' skip */
      'color: Black;' skip
      '~}' skip

      '.AccordionTitle2' skip
      '~{' skip
      'height: 20px; /*changeble*/' skip
      'overflow: hidden;' skip
      'cursor: pointer;' skip
      'font-family: Verdana; /*changeble*/' skip
      'font-size: 12px; /*changeble*/' skip
      'font-weight: normal; /*changeble*/' skip
      'vertical-align: middle; /*changeble*/' skip
      'text-align: center; /*changeble*/' skip
      'display: table-cell;' skip
      '-moz-user-select: none;' skip
      'border-top: none; /*changeble*/' skip
      'border-bottom: none; /*changeble*/' skip
      'border-left: none; /*changeble*/' skip
      'border-right: none; /*changeble*/' skip
      'background-color: #A4C1F4;' skip
      'color: Black;' skip
      '~}' skip

      '.AccordionContent' skip
      '~{' skip
      'height: 0px;' skip
      'overflow: hidden; /*display: none;  */' skip
      '~}' skip


      '.AccordionContent_' skip
      '~{' skip
      'height: auto;' skip
      '~}' skip


      '.AccordionContainer' skip
      '~{' skip
      'border-top: solid 1px #C1C1C1; /*changeble*/' skip
      'border-bottom: solid 1px #C1C1C1; /*changeble*/' skip
      'border-left: solid 1px #C1C1C1; /*changeble*/' skip
      'border-right: solid 1px #C1C1C1; /*changeble*/' skip
      '~}' skip


      '.ContentTable' skip
      '~{' skip
      'width: 100%;' skip
      'text-align: center;' skip
      'color: White;' skip
      '~}' skip

      '.ContentCell' skip
      '~{' skip
      'background-color: #666666;' skip
      '~}' skip

      '.ContentTable a:link, a:visited' skip
      '~{' skip
      'color: White;' skip
      'text-decoration: none;' skip
      '~}' skip

      '.ContentTable a:hover' skip
      '~{' skip
      'color: Yellow;' skip
      'text-decoration: none;' skip
      '~}' skip

      '</style>' skip

      '<script type="text/javascript" language="JavaScript">' skip
      'var ContentHeight = 0;' skip
      'var TimeToSlide = 200;' skip
      'var openAccordion = "";' skip
      'var totalAcc = 0 ;' skip
      'var firstTime = ' if lc-mode = 'display' or lc-mode = 'insert' then 'true' else 'false' skip
      
      'function runAccordion(index)' skip
      '~{' skip
      'if (inEdit) ' skip
      '~{' skip
      ' alert("You have made changes to this week~'s times\n Please update or cancel before continuing" ); ' skip
      ' return; ' skip
      '~}' skip
      'var nID = "Accordion" + index + "Content";' skip
      'if(openAccordion == nID)' skip
      'nID = "";' skip
      'ContentHeight = document.getElementById("Accordion" + index + "Content"+"_").offsetHeight;' skip
      'setTimeout("animate(" + new Date().getTime() + "," + TimeToSlide + ",~'"' skip
      '+ openAccordion + "~',~'" + nID + "~')", 33);' skip
      'openAccordion = nID;' skip
      '~}' skip

      'function animate(lastTick, timeLeft, closingId, openingId)' skip
      '~{' skip
      'var curTick = new Date().getTime();' skip
      'var elapsedTicks = curTick - lastTick;' skip
      'var opening = (openingId == "") ? null : document.getElementById(openingId);' skip
      'var closing = (closingId == "") ? null : document.getElementById(closingId);' skip
      'if(timeLeft <= elapsedTicks)' skip
      '~{' skip
      'if(opening != null)' skip
      'opening.style.height = ~'auto~';' skip
      'if(closing != null)' skip
      '~{' skip
      '//closing.style.display = ~'none~';' skip
      'closing.style.height = ~'0px~';' skip
      '~}' skip
      'return;' skip
      '~}' skip
      'timeLeft -= elapsedTicks;' skip
      'var newClosedHeight = Math.round((timeLeft/TimeToSlide) * ContentHeight);' skip
      'if(opening != null)' skip
      '~{' skip
      'if(opening.style.display != ~'block~')' skip
      'opening.style.display = ~'block~';' skip
      'opening.style.height = (ContentHeight - newClosedHeight) + ~'px~';' skip
      '~}' skip
      'if(closing != null)' skip
      'closing.style.height = newClosedHeight + ~'px~';' skip
      'setTimeout("animate(" + curTick + "," + timeLeft + ",~'"' skip
      '+ closingId + "~',~'" + openingId + "~')", 33);' skip
      '~}' skip

      'function checkLoad()' skip
      '~{' skip
      'if (window.onLoad)' skip
      '~{' skip
      'window.resizeBy(0, totalAcc * 20);' skip
      '~}' skip
      'else ~{' skip
      'setTimeout("checkLoad();", 1000);' skip
      '~}' skip
/*         'alert(firstTime);' skip */
      'if ( firstTime )' skip
      '~{' skip
      'firstTime = false;' skip
      'fitWindow();' skip
      '~}' skip
      '~}' skip


      'function FitBody() ~{' skip
      'var iSize = getSizeXY();' skip
      'var iScroll = getScrollXY();' skip
/*       'window.alert( 'Width = ' + iSize[0]  +  '   Height = ' + iSize[1] );' skip     */
/*       'window.alert( 'Width = ' + iScroll[0]  +  '   Height = ' + iScroll[1] );' skip */
      'iWidth = iSize[0] + iScroll[0] + 28 ;' skip
      'iHeight = iSize[1] + iScroll[1] + iScroll[1] + 20 ;' skip
/*       'window.alert( 'Width = ' + iWidth  +  '   Height = ' + iHeight );' skip */
      'if (iScroll[1] != 0 ) window.resizeTo(iWidth, iHeight);' skip
      'self.focus();' skip
      '~};' skip

      'function getSizeXY() ~{' skip
      'var myWidth = 0, myHeight = 0;' skip
      'if( typeof( window.innerWidth ) == "number" ) ~{' skip
      '//Non-IE' skip
      'myWidth = window.innerWidth;' skip
      'myHeight = window.innerHeight;' skip
      '//window.alert("NON IE");' skip
      '~} else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) ~{' skip
      '//IE 6+ in standards compliant mode' skip
      'myWidth = document.documentElement.clientWidth;' skip
      'myHeight = document.documentElement.clientHeight;' skip
      '//window.alert("IE 6");' skip
      '~} else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) ~{' skip
      '//IE 4 compatible' skip
      'myWidth = document.body.clientWidth;' skip
      'myHeight = document.body.clientHeight;' skip
      '//window.alert("IE 4");' skip
      '~}' skip
/*       '//window.alert( 'Width = ' + myWidth  +  '   Height = ' + myHeight );' skip */
      'return [ myWidth, myHeight ];' skip
      '~}' skip

      'function getScrollXY() ~{' skip
      'var scrOfX = 0, scrOfY = 0;' skip
      'if( typeof( window.pageYOffset ) == "number" ) ~{' skip
      '//Netscape compliant' skip
      'scrOfY = window.pageYOffset;' skip
      'scrOfX = window.pageXOffset;' skip
      '~} else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) ~{' skip
      '//DOM compliant' skip
      'scrOfY = document.body.scrollTop;' skip
      'scrOfX = document.body.scrollLeft;' skip
      '~} else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) ~{' skip
      '//IE6 standards compliant mode' skip
      'scrOfY = document.documentElement.scrollTop;' skip
      'scrOfX = document.documentElement.scrollLeft;' skip
      '~}' skip
/*       '//window.alert( 'Width = ' + scrOfX  +  '   Height = ' + scrOfY );' skip */
      'return [ scrOfX, scrOfY ];' skip
      '~}' skip
      
      '</script>' skip
      .



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ip-time-display) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ip-time-display Procedure 
PROCEDURE ip-time-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var vx      as int  no-undo.
    def var vz      as int  no-undo.
    def var lc-date as char no-undo.
    def var hi-date as date no-undo.
    def var lo-date as date no-undo.
    def var lc-list-reason-id as char initial "|01|02|03|04|05|10"  no-undo.
    def var lc-list-reason    as char initial "Select|B.Hol|A/Leave|Sick|Doctor|Dentist|Overtime"  no-undo.
    def var lc-saved-reason   as char initial "00" no-undo.

 

    
   for each this-year :

   
      assign lc-date = Wk2Date(string(string(this-year.ty-week-no,"99") + "-" + string(li-curr-year,"9999")))
             hi-date  = date(entry(1,lc-date,"|")).


      {&out}
          '<div onclick="runAccordion(' string(this-year.ty-week-no) ');">' skip
          '  <div class="AccordionTitle' string(if this-year.ty-week-no modulo 2 = 0 then 1 else 2)  '"  onselectstart="return false;">' skip
          '    <span style="float:left;margin-left:20px;text-align:bottom;"><strong>Week ' string(this-year.ty-week-no,"99") '</strong> (' replace(lc-date,"|"," - ") ')'
          '    </span><span style="float:right;margin-right:20px;text-align:bottom;">' string(ty-hours,">9.99") '</span>' skip
          '  </div>' skip
          '</div>' skip
          '<div id="Accordion' string(this-year.ty-week-no) 'Content" class="AccordionContent">' skip
          '   <div id="Accordion' string(this-year.ty-week-no) 'Content_" class="AccordionContent_">' skip  .

 
 
       {&out} 
 
         
               '   <div id="weekdiv' string(this-year.ty-week-no) '" name="weekdiv' string(this-year.ty-week-no) '"  >' skip
               '      <table   style="border:5px solid ' if this-year.ty-week-no modulo 2 = 0 then "#E4ECF0" else "#A4C1F4" ';"  ><tr><td>&nbsp;' skip
               '</td>'
               ''
               '      <td>' string(entry(1,lc-day)) ' - ' string(day(hi-date + 0))     '</td>'
               '      <td>' string(entry(2,lc-day)) ' - ' string(day(hi-date + 1)) '</td>' 
               '      <td>' string(entry(3,lc-day)) ' - ' string(day(hi-date + 2)) '</td>' 
               '      <td>' string(entry(4,lc-day)) ' - ' string(day(hi-date + 3)) '</td>' 
               '      <td>' string(entry(5,lc-day)) ' - ' string(day(hi-date + 4)) '</td>' 
               '      <td>' string(entry(6,lc-day)) ' - ' string(day(hi-date + 5)) '</td>' 
               '      <td>' string(entry(7,lc-day)) ' - ' string(day(hi-date + 6)) '</td>'  
               '      </tr>' skip
               '      <tr><td width="50px">Contracted Hours:</td> ' skip.
          
       do vx = 1 to 7:


                  {&out} '     <td>'       string(ld-curr-hours[vx],"99.99") '</td>'  skip.
       end.


       {&out}  '      <tr><td width="50px">Change Hours:</td> ' skip.

       do vx = 1 to 7:

         find first this-day where this-day.td-week-no = this-year.ty-week-no
                             and   this-day.td-day-no  = vx
                             no-lock no-error.


         if avail this-day then
         do:
           if integer(this-day.td-reason) < 10 then
            {&out} '      <td>'  html-InputFieldMasked("weekno" + string(this-year.ty-week-no) + "-" + string(vx,"99"), "5","20","99.99",  
                                             string(this-day.td-hours,"99.99"),"font-family:verdana;font-size:10pt;color:red;width:40px;") '</td>'  skip.
           else
            {&out} '      <td>'  html-InputFieldMasked("weekno" + string(this-year.ty-week-no) + "-" + string(vx,"99"), "5","20","99.99",  
                                             string(this-day.td-hours,"99.99"),"font-family:verdana;font-size:10pt;color:green;width:40px;") '</td>'  skip.

         end.
         else
            {&out} '      <td>'  html-InputFieldMasked("weekno" + string(this-year.ty-week-no) + "-" + string(vx,"99"), "5","20","99.99", "00.00" 
                                            ,"font-family:verdana;font-size:10pt;width:40px;") '</td>'  skip.
       end.

       {&out} '     </tr><tr><td> Reason:</td> ' skip.

       do vx = 1 to 7:
         
         find first this-day where this-day.td-week-no = this-year.ty-week-no
                             and   this-day.td-day-no  = vx
                             no-lock no-error.

         {&out} '       <td width="40px" >' htmlib-Select("reasonno" + string(this-year.ty-week-no) + "-" + string(vx,"99"),lc-list-reason-id,lc-list-reason,
                                                   if avail this-day then this-day.td-reason else "")  '</td>'  skip.
              
       end.


       {&out}  '</tr>' skip
         '<tr><td cellpadding="2px" height="20px" colspan=8 >'
         '<div style="width:100%; height:20px; margin-right:auto; margin-left:auto; ">'
         '<input class="submitbutton" type="button" onclick="javascript:inEdit=false;runAccordion(' string(this-year.ty-week-no) ');"  value="Cancel" />' skip
     
         '<input class="submitbutton" type="button" onclick="javascript:updateHours(' string(this-year.ty-week-no) ');"  value="Update" />' skip
         '</div></td>'          
         '     </tr></table></div>' skip.
         
 
                      

 
        {&out}
          
          ' </div>' skip
          '</div>' skip.

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
    
    def var lc-object           as char     no-undo.
    def var vx                  as int      no-undo.
    def var lc-date             as char     no-undo.
    def var lc-list-reason-id as char initial "|01|02|03|04|05|10"  no-undo.
    def var lc-list-reason    as char initial "Select|BANK|LEAVE|SICK|DOC|DENT|OT"  no-undo.


    {lib/checkloggedin.i} 




    assign lc-mode            = get-value("mode")
           lc-rowid           = get-value("rowid")
           lc-search          = get-value("search")
           lc-firstrow        = get-value("firstrow")
           lc-lastrow         = get-value("lastrow")
           lc-navigation      = get-value("navigation")
           li-curr-year       = integer(get-value("submityear"))
           lc-submitweek      = get-value("submitweek")
           lc-submitday[1]    = get-value("submitday1")
           lc-submitday[2]    = get-value("submitday2")
           lc-submitday[3]    = get-value("submitday3")
           lc-submitday[4]    = get-value("submitday4")
           lc-submitday[5]    = get-value("submitday5")
           lc-submitday[6]    = get-value("submitday6")
           lc-submitday[7]    = get-value("submitday7")
           lc-submitreason[1] = get-value("submitreason1")
           lc-submitreason[2] = get-value("submitreason2")
           lc-submitreason[3] = get-value("submitreason3")
           lc-submitreason[4] = get-value("submitreason4")
           lc-submitreason[5] = get-value("submitreason5")
           lc-submitreason[6] = get-value("submitreason6")
           lc-submitreason[7] = get-value("submitreason7")
           .
    if li-curr-year = ? or li-curr-year = 0 then li-curr-year = year(today).
  
    assign  li-end-week  = integer(entry(2,Date2Wk(date("01/01/" + string(li-curr-year + 1 )) - 1) ,"|")). /* work out the number of weeks for this year */


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
    assign lc-loginid = b-table.loginid.
    assign lc-title = 'Contracted Times For ' + 
           html-encode(b-table.forename + " " + b-table.surname)
           lc-link-label = "Cancel"
           lc-submit-label = "Update Times".
      
    assign lc-link-url = appurl + '/sys/webuser.p' + 
                                  '?search=' + lc-search + 
                                  '&firstrow=' + lc-firstrow + 
                                  '&lastrow=' + lc-lastrow + 
                                  '&navigation=refresh' +
                                  '&time=' + string(time).
   

    if request_method = "POST" then
    do:
 
                output to "C:\djstext.txt" append.
                put unformatted  
                       " lc-mode         " lc-mode  skip
                       " li-curr-year  "   li-curr-year  skip
                       " lc-submitweek "   lc-submitweek   skip
                       " lc-submitday1 "   lc-submitday[1]   skip
                       " lc-submitday2 "   lc-submitday[2]   skip
                       " lc-submitday3 "   lc-submitday[3]   skip
                       " lc-submitday4 "   lc-submitday[4]   skip
                       " lc-submitday5 "   lc-submitday[5]   skip
                       " lc-submitday6 "   lc-submitday[6]   skip
                       " lc-submitday7 "   lc-submitday[7]   skip
                       " lc-submitreason1 "   lc-submitreason[1]   skip
                       " lc-submitreason2 "   lc-submitreason[2]   skip
                       " lc-submitreason3 "   lc-submitreason[3]   skip
                       " lc-submitreason4 "   lc-submitreason[4]   skip
                       " lc-submitreason5 "   lc-submitreason[5]   skip
                       " lc-submitreason6 "   lc-submitreason[6]   skip
                       " lc-submitreason7 "   lc-submitreason[7]   skip                  .

                output close.


        do vx = 1 to 7:
 
          assign lc-object  = string(integer(lc-submitweek),"99") + "-" + string(li-curr-year)
                 lc-date    = entry(1,Wk2Date(lc-object),"|")
                 lc-date    = string(date(lc-date) - 1 + vx).

           if lc-submitreason[vx] <> "" then
           do:
               
             find first WebUserTime where WebUserTime.CompanyCode = lc-global-company                      
                                    and   WebUserTime.LoginID     = lc-loginid                             
                                    and   WebUserTime.EventDate   = date(lc-date)
                                    exclusive-lock no-error.
                    
                  output to "C:\djstext.txt" append.
                  put unformatted  "lc-mode " lc-mode  skip
                    "USER  " lc-loginid skip
                  "lc-object     "    lc-object  skip
                  "lc-date       "    lc-date        skip
                  "Avail?  "      avail webUserTime    skip(2).
                    
                  output close.
  
              if avail WebuserTime then
              do:
                assign WebUserTime.EventHours  = dec(lc-submitday[vx])
                       WebUserTime.EventType   = entry(lookup(lc-submitreason[vx],lc-list-reason-id,"|"),lc-list-reason,"|").
              end.
              else
              do:
                create WebUserTime.
                assign WebUserTime.CompanyCode = lc-global-company           
                       WebUserTime.LoginID     = lc-loginid                  
                       WebUserTime.EventDate   = date(lc-date) 
                       WebUserTime.EventHours  = dec(lc-submitday[vx])
                       WebUserTime.EventType   = entry(lookup(lc-submitreason[vx],lc-list-reason-id,"|"),lc-list-reason,"|").      
              end.
           end.
        end.          
    end.



    RUN outputHeader.
    
    {&out} htmlib-OpenHeader(lc-title) skip
           htmlib-StartForm("mainform","post", selfurl )
           htmlib-ProgramTitle(lc-title) skip.

         run ip-ExportAccordion.

    {&out} '<script language="JavaScript" src="/scripts/js/debug.js"></script>' skip
           '<script language="JavaScript" src="/scripts/js/validate.js"></script>' skip.

    {&out} htmlib-CloseHeader("") skip.

    {&out} htmlib-Hidden ("mode", lc-mode) skip
           htmlib-Hidden ("rowid", lc-rowid) skip
           htmlib-Hidden ("search", lc-search) skip
           htmlib-Hidden ("firstrow", lc-firstrow) skip
           htmlib-Hidden ("lastrow", lc-lastrow) skip
           htmlib-Hidden ("navigation", lc-navigation) skip
           htmlib-Hidden ("nullfield", lc-navigation) skip
           htmlib-Hidden ("submityear", string(li-curr-year)) skip
           htmlib-Hidden ("submitweek", "") skip
           htmlib-Hidden ("submitday1", "") skip
           htmlib-Hidden ("submitday2", "") skip
           htmlib-Hidden ("submitday3", "") skip
           htmlib-Hidden ("submitday4", "") skip
           htmlib-Hidden ("submitday5", "") skip
           htmlib-Hidden ("submitday6", "") skip
           htmlib-Hidden ("submitday7", "") skip
           htmlib-Hidden ("submitreason1", "") skip
           htmlib-Hidden ("submitreason2", "") skip
           htmlib-Hidden ("submitreason3", "") skip
           htmlib-Hidden ("submitreason4", "") skip
           htmlib-Hidden ("submitreason5", "") skip
           htmlib-Hidden ("submitreason6", "") skip
           htmlib-Hidden ("submitreason7", "") skip 
      .
        
    {&out} htmlib-TextLink(lc-link-label,lc-link-url) '<BR><BR>' skip.

    
    {&out} skip
          htmlib-StartMntTable().
    {&out}
           htmlib-TableHeading(
           "Contracted Times for " + string(li-curr-year) + 
           "| <div id=~"chgyear~"style=~"cursor:pointer;~" onclick=~"changeYear();~" >Change Year</div>"
           ) skip.



          {&out}
          '<tr><td><br><div id="AccordionContainer" class="AccordionContainer">' skip.

    run ip-build-year.
    run ip-time-display.

    {&out} skip '</div         ></td></tr>' skip.


    {&out} skip 
           htmlib-EndTable()
           skip.

           def var lc-year as char no-undo.
           def var zx      as int  no-undo.
           
    {&out} '<div id="hiddenyeardiv" style="display:none;">' skip 

           '<select id="selectyear" name="selectyear" class="inputfield" ' skip
           ' onchange="changeYear(this);"  >' skip
           '<option value="" ' '>  Select Year </option>' skip.

           do zx = -1 to 4:
             lc-year = string(year(today) - zx).
             {&out} '<option value="' lc-year '" ' '>'  html-encode(lc-year) '</option>' skip.
            end.
    {&out} '</select>' skip.
      
    {&out} '</div>'.
    
    {&out} htmlib-StartPanel() 
           skip.


    {&out} htmlib-EndPanel().
         
    {&out} htmlib-EndForm() skip
           htmlib-Footer() skip.


    {&out} '<script>' skip
/*       ' forceDisplay("mainform","20") ; ' skip */
/*       ' focusDisplay("hoursOnAm1"); ' skip */
      '</script>' skip.


    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-Date2Wk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Date2Wk Procedure 
FUNCTION Date2Wk RETURNS CHARACTER
  (input dMyDate as date) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var cYear     as char no-undo.
  def var iWkNo     as int  no-undo.
  def var iDayNo    as int  no-undo.
  def var dYrBegin  as date no-undo.
  def var WkOne     as int  no-undo.
  assign cYear  = entry(3,string(dMyDate),"/")
         WkOne  = weekday(date("01/01/" + cYear)).
  if WkOne <= 5 then dYrBegin = date("01/01/" + cYear).
  else dYrBegin = date("01/01/" + cYear) + WkOne.
  assign iDayNo = integer(dMyDate - dYrBegin) + 1  
         iWkNo  = round(iDayNo / 7,0) + 1 . 
  return string(string(iDayNo) + "|" + string(iWkNo) + "|" + cYear).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dayOfWeek) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dayOfWeek Procedure 
FUNCTION dayOfWeek RETURNS INTEGER
  (input dMyDate as date) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var rDate     as int no-undo.
  def var WkSt      as int  initial 2 no-undo. /* 1=Sun,2=Mon */
  def var DayList   as char no-undo.
  if WkSt = 1 then DayList = "1,2,3,4,5,6,7".
              else DayList = "7,1,2,3,4,5,6".

  rDate = weekday(dMyDate).
  rDate = integer(entry(rDate,DayList)).
  return  rDate.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-Wk2Date) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Wk2Date Procedure 
FUNCTION Wk2Date RETURNS CHARACTER
 (cWkYrNo as char):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var cYear     as char no-undo.
  def var iWkNo     as int  no-undo.
  def var iDayNo    as int  no-undo.
  def var iSDayNo   as date no-undo.
  def var iEDayNo   as date no-undo.
  def var dYrBegin  as date no-undo.
  def var WkOne     as int  no-undo.
  def var WkSt      as int  initial 2 no-undo. /* 1=Sun,2=Mon */
  if index(cWkYrNo,"-") <> 3 then return "Format should be xx-xxxx".
  assign cYear  = entry(2,cWkYrNo,"-")
         WkOne  = weekday(date("01/01/" + cYear)).
  if WkOne <= 5 then dYrBegin = date("01/01/" + cYear).
  else dYrBegin = date("01/01/" + cYear) + WkOne.
  assign iWkNo  = integer(entry(1,cWkYrNo,"-"))
         iDayNo = (iWkNo * 7) - 7
        iSDayNo = dYrBegin + iDayNo - WkOne + WkSt 
        iEDayNo = iSDayNo + 6 .
  return string(string(iSDayNo,"99/99/9999") + "|" + string(iEDayNo,"99/99/9999")).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

