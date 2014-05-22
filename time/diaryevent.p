&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************

    Program:        sys/kbsearch.p
    
    Purpose:        KB Search
    
    Notes:
    
    
    When        Who         What
    01/08/2006  phoski      Initial
     
***********************************************************************/
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var lc-error-field as char no-undo.
def var lc-error-mess  as char no-undo.

def var lc-rowid as char no-undo.

def var li-max-lines as int initial 12 no-undo.
def var lr-first-row as rowid no-undo.
def var lr-last-row  as rowid no-undo.
def var li-count     as int   no-undo.
def var ll-prev      as log   no-undo.
def var ll-next      as log   no-undo.
def var lc-search    as char  no-undo.
def var lc-firstrow  as char  no-undo.
def var lc-lastrow   as char  no-undo.
def var lc-navigation as char no-undo.
def var lc-parameters   as char no-undo.
def var lc-smessage     as char no-undo.
def var lc-link-otherp  as char no-undo.
def var lc-char         as char no-undo.
def var lc-nopass       as char no-undo.

def var lc-code     as char no-undo.
def var lc-desc     as char no-undo.
def var lc-knbcode  as char no-undo.
def var lc-type     as char no-undo.

def var lc-type-code    as char
    initial "T|I|C"     no-undo.
def var lc-type-desc    as char
    initial "Title|Text|Both Title And Text" no-undo.

def var lc-mainText   as char no-undo.
def var lc-timeText   as char no-undo.
def var lc-innerText  as char no-undo.
def var lc-sliderText as char no-undo.
def var lc-otherText  as char no-undo.



def temp-table DE like DiaryEvents
field idRow       as rowid
field eventID     as char format "xx"
field overLap     as char format "x(9)" 
field comment     as char
field columnID    as int format "z9"
field issueLeft   as int
field issueWidth  as int.

def buffer bDE for DE.
def buffer bbDE for DE.
 
def var timeSPixels as char no-undo.
def var timeFinish  as dec  no-undo.
def var timeFPixels as char no-undo.
def var daysIssues  as int  no-undo.
def var issueWidth  as int  no-undo.
def var issueLeft   as int  no-undo.
def var timeStart   as dec  no-undo.
def var timeEnd     as dec  no-undo.
def var offSetCol   as int  no-undo.
def var offSetWidth as int  no-undo.
def var offRowid    as rowid  no-undo. 

/*
def var p-cx        as char initial "1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"  no-undo.

*/
def var p-cx        as char initial "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40"  no-undo.
def var p-vx        as int  no-undo.
def var p-vz        as int  no-undo.
def var p-zx        as int  no-undo.


def buffer bDiaryEvents for DiaryEvents.
def buffer b-query for DiaryEvents.
def buffer b-search for DiaryEvents.
def query q for b-query scrolling.


def var lc-lodate as char.
def var lc-hidate as char.


def temp-table DDEE like DiaryEvents.


  /* WORKING VARS */
  def var vx                 as int no-undo.
  def var yx                 as int no-undo.
  def var zx                 as int no-undo.
  def var mx                 as int no-undo.
  def var cx                 as int no-undo.
  def var AMPM               as char format "xx" extent 2 initial ["AM","PM"]  no-undo.
  def var ap                 as int  no-undo.
  def var dayDate            as date no-undo.
  def var bubbleNo           as int initial 1  no-undo.
  def var dayWidth           as char   no-undo.
                            
  def var currentDay         as date   no-undo.  
  def var viewerDay          as date   no-undo.
  def var dayDesc            as char   no-undo.
  def var dayNum             as int    no-undo.
  def var dayList            as char   format "x(9)"
      initial " Sunday , Monday , Tuesday , Wednesday , Thursday , Friday , Saturday ".


  /* PARAM VARS */
  def var dayRange            as int    no-undo.
  def var hourFrom            as int    no-undo.
  def var hourTo              as int    no-undo.
  def var coreHourFrom        as int    no-undo.
  def var coreHourTo          as int    no-undo.
  def var incWeekend          as log    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnText Procedure 
FUNCTION fnText RETURNS CHARACTER
  ( pf-knbid as dec,
    pi-count as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-timeFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD timeFormat Procedure 
FUNCTION timeFormat RETURNS CHARACTER
 (param1 as int) FORWARD.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */

find first DiaryParams no-lock.
 lc-lodate    = string(today - 10).  
 lc-hidate    = string(today) .


 for each issue no-lock
        where issue.CompanyCode = "ouritdept"
/*           and issue.AccountNumber >= "1"   */
/*           and issue.AccountNumber <= "999" */
          and issue.AssignTo >= "A"
          and issue.AssignTo <= "C"
/*           and issue.AreaCode >= ""         */
/*           and issue.AreaCode <= "zzzzzzz"  */
/*           and issue.CatCode  >= ""         */
/*           and issue.CatCode  <= "zzzzzzz"  */
/*                                              */
          and issue.CreateDate >= date(lc-lodate)  
          and issue.CreateDate <= date(lc-hidate)  
       :

   create DDEE.
   assign 
     DDEE.EventData   = Issue.BriefDescription 
     DDEE.ID          = string(Issue.IssueNumber)
     DDEE.Name        = Issue.AssignTo   
     DDEE.StartDate   = Issue.AssignDate
     DDEE.StartTime   = integer(   string(substr( string(Issue.AssignTime ,"HH:MM"),1,2) + substr( string(Issue.AssignTime ,"HH:MM"),4,2),"9999" ))
     DDEE.EndDate     = Issue.CompDate
     DDEE.EndTime     = DDEE.StartTime + 100
     DDEE.EventRowid  = string(rowid(issue))

     .

 end.
     
  

 assign viewerDay     = today  
        dayRange      = 3
        coreHourFrom  = integer(substr(DiaryParams.coreHours,1,4))
        coreHourTo    = integer(substr(DiaryParams.coreHours,5,4))
        hourFrom      = 0500
        hourTo        = 2000
        incWeekend    = false
        dayWidth      = string(if dayRange > 15 then 75 else round(1200 / dayRange,0))
       
   .
                      
do zx = 1 to dayRange:
   assign currentDay = date(string(viewerDay + (zx - (round(dayRange / 2,0)))))
          dayNum     = weekday(currentDay).
   if dayNum = 1 or dayNum = 7 then cx = cx + 1.
end.
if cx > 0 then dayWidth = string(if dayRange > 15 then 85 else round(1200 / (dayRange - cx),0)).
                      


RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createDaySlider) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDaySlider Procedure 
PROCEDURE createDaySlider :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

lc-sliderText =  
'<div id="bars" style="margin-top:20px; margin-left:50%; margin-right:50%; width:100%;z-index:100 ">'  +
  '<div  style="margin-left:auto; margin-right:auto; width:250px; ">'  +
    '<div >'  +
      '<img src="C:/Inetpub/wwwroot/TSWeb/images/minus-sign.png" alt="" style="right:20px; float: left;" />'  +
    '</div>'  +
    '<div >'  +
      '<img src="C:/Inetpub/wwwroot/TSWeb/images/plus-sign.png" alt="" style="float: right;" />'  +
    '</div>'  +

    '<div id="track1" style="margin-left:auto; margin-right:auto; width:200px; height:9px;">'  +
      '<div id="track1-left">'  +
        '</div>'  +
        '<div id="handle1" style="width:19px; height:20px;">'  +
          '<img src="C:/Inetpub/wwwroot/TSWeb/images/slider-images-handle.png" alt="" style="float: left;" />'  +
        '</div>'  +
      '</div>'  +
/*     '<div id="div-1" style="position:absolute; top:0px; left:2px; " >'  +                                                                 */
/*       '<input type="button" id=printbutton value="Print"    name="ButtonPrint" onclick="javascript:window.print()"  class="button">'  +   */
/*     '</div>'  +                                                                                                                           */
/*     '<div id="div-1a" style="position:absolute; top:0px; right:2px; width:57px;" >'  +                                                    */
/*       '<input   type="button" id=closebutton value="Close"    name="ButtonClose" onclick="javascript:window.close()"  class="button">'  + */
/*     '</div>'  +                                                                                                                           */
    '</div>'  +
  '</div>'  +
'</div>'  
.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createEvents Procedure 
PROCEDURE createEvents :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  p-vx = 0.

  do while p-vx <> p-vz :
   p-zx = p-zx + 1.
   for each DE where integer(DE.columnID) < 1
     break by DE.StartTime :
     if DE.StartTime >= timeEnd then assign timeEnd  = DE.EndTime
                                            DE.columnID = p-zx
                                            p-vx = p-vx + 1.
   end.
   timeEnd = 0.
  end.

  for each DE by DE.StartTime  :
    for each bDE where  bDE.EndTime >= DE.EndTime :
       if ( (((DE.StartTime < bDE.StartTime) and (DE.StartTime < bDE.EndTime)) or ((DE.StartTime > bDE.StartTime) and (DE.StartTime > bDE.EndTime))) and DE.columnID <> bDE.columnID )
       then do:
         if( (((DE.EndTime < bDE.StartTime) and (DE.EndTime < bDE.EndTime)) or ((DE.EndTime > bDE.StartTime) and (DE.EndTime > bDE.EndTime))) and DE.columnID <> bDE.columnID )
         then do:
           if bDE.columnID > DE.columnID then assign DE.overLap = DE.overLap.
           else if bDE.eventID < DE.eventID then assign DE.overLap = DE.overLap + ","  + string(bDE.eventID).
         end.
         else do:
           assign DE.overLap = DE.overLap + "," + string(bDE.eventID).
         end.
       end.
       else if DE.columnID <> bDE.columnID then do:
        assign DE.overLap = DE.overLap + "," + string(bDE.eventID).
       end.
       else do:
        assign DE.overLap = DE.overLap.
       end.
    end.
  end.

  for each DE by DE.StartTime :

  INNER:
  for each bDE :
    if lookup(bDE.eventID,DE.overLap) > 0 
    then
    do:
      if bDE.columnID > DE.issueWidth 
      then 
      do:
          DE.issueWidth = bDE.columnID.
      end.
      else if bDE.issueWidth > DE.issueWidth 
      then
      do: 
          DE.issueWidth = bDE.issueWidth. 
      end.
    end.
  end.

   if DE.issueWidth < DE.columnID then DE.issueWidth = DE.columnID.
   DE.issueLeft = DE.columnID.

  end.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-diaryHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE diaryHeader Procedure 
PROCEDURE diaryHeader :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


{&out}

'<link type="text/css" rel="stylesheet" href="demo.css" />' skip
 
'<script src="C:/Inetpub/wwwroot/TSWeb/javascripts/prototype.js" type="text/javascript"></script>' skip
'<script src="C:/Inetpub/wwwroot/TSWeb/javascripts/slider.js" type="text/javascript"></script>' skip
'<script type="text/javascript">' skip
' var myWidth=1200;' skip
' var myHeight=10;' skip
' var isIE = false;' skip
skip

/* FIX DIV POSITION */
'function fixTimeDiv(div) ~{' skip
'  var obj = document.getElementById(div);' skip
'  var cw = document.body.clientWidth;' skip
'  var ch = document.body.clientHeight;' skip
'  var x = document.body.scrollLeft;' skip
'  var y = document.body.scrollTop;' skip
'  var w = obj.offsetWidth;' skip
'  var h = obj.offsetHeight;' skip
/*   'alert( " Y = " + y + "  CW = "  + cw  + "  W = " + w + " Total = " + ( cw + x - (cw  +  w - 60)  ) );'  */
'  if ( isIE == true ) ~{' skip
'    obj.style.left = cw + x - (cw +  w - 60);' skip
'    obj.style.top =  15;' skip
'  ~}' skip
'  else ~{' skip
'    obj.style.left = cw + x - (cw + w - 54);' skip
'    obj.style.top = 15;' skip
'  ~}' skip
'~}' skip
skip

/* Select Event */
'function eventSelect(newRow)' skip
' ~{' skip
'window.open(~'temp.html~',~'mywindow~',~'width=800,height=600~');' skip
' ~}' skip
skip


/* SCROLL WINDOW */
'function scrollWindow()' skip
' ~{' skip
  'window.location.hash = "moveHere";'
' ~}' skip
skip
'</script>' skip


 /* STYLE ADDITION */
'<STYLE TYPE="text/css">' skip
'<!--' skip
'* html .minwidth ~{' skip
'    border-left:' dayWidth 'px; ' skip
'         _width:' dayWidth 'px; ' skip  /* IE6 hack */
'          width:' dayWidth 'px; ' skip
'      min-width:' dayWidth 'px; ' skip
'~}' skip
'-->' skip

'<style type="text/css" media="screen" >' skip

	/* put the left rounded edge on the track */
'	#track1-left ~{' skip
'		position: absolute;' skip
'		width: 5px;' skip
'		height: 9px;' skip
'		background: transparent url(C:/Inetpub/wwwroot/TSWeb/images/slider-images-track-left.png) no-repeat top left;' skip
'		zindex:9999;' skip
'	~}' skip

	/* put the track and the right rounded edge on the track */
'	#track1 ~{' skip
'		background: transparent url(C:/Inetpub/wwwroot/TSWeb/images/slider-images-track-right.png) no-repeat top right;' skip

'	~}' skip
'body ~{' skip
'	background-color: #F2EFE9;' skip
'	color: #000000;' skip
'	font-family: Verdana, Arial, Helvetica, sans-serif;' skip
'	font-size: 11px;' skip
'	font-style: normal;' skip
'	font-variant: normal;' skip
'	font-weight: normal;' skip
'	margin: 0px 0px 0px 0px;' skip
'~}' skip
'.programtitle ~{' skip
'	background-color: #F2EFE9;' skip
'	color: Blue;' skip
'	text-align: center;' skip
'	width: 100%;' skip
'	word-spacing: 2px;' skip
'	font: Verdana;' skip
'	font-weight: bold;' skip
'	font-size: 14px;' skip
'~}' skip
'.button ~{' skip
'	FONT-FAMILY: Verdana, Helvetica, Arial, San-Serif;' skip
'	font-weight:normal;' skip
'	font-size:100%;' skip
'	color:#000000;' skip
'	background-color:#ffffff;' skip
'	border-color:#6699ff;' skip
'	margin-top:2pt;' skip
'	margin-left: .5em;' skip
'~}' skip
 skip 

'</STYLE>' skip
  '</head>' skip
 skip
 .
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertEvents Procedure 
PROCEDURE insertEvents :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var timeStart   as dec  no-undo.
def var timeSPixels as char no-undo.
def var timeFinish  as dec  no-undo.
def var timeFPixels as char no-undo.
def var daysIssues  as int  no-undo.
def var issueWidth  as int  no-undo.
def var issueLeft   as int  no-undo.
def var startMin    as int  no-undo.
def var startMax    as int  no-undo.
def var offSetCol   as int  no-undo.
def var offSetWidth as int  no-undo.
def var offRowid    as rowid  no-undo.


/* Down to XXX will be iterations through the database... */

/* assign timeStart = truncate(hourFrom / 100,0) + dec(hourFrom modulo 100 / 60).  */

do zx = 1 to dayRange:

   assign currentDay = date(string(viewerDay + (zx - (round(dayRange / 2,0)))))
          dayNum     = weekday(currentDay).
 

   if dayNum = 1 or dayNum = 7 then next.


   if can-find(first DDEE where DDEE.StartDate = currentDay)
   then
   do:
     lc-innerText = lc-innerText +  /* CCC */
            '<td width="'  + dayWidth  + 'px"  style="height:1px;text-align:left;">'  .
    

     empty temp-table DE no-error.
     p-vx = 0.
     p-vz = 0.
     p-zx = 0.

  
     for each DDEE no-lock 
        where DDEE.StartDate = currentDay
        break by DDEE.StartTime :
          
         create DE.
         buffer-copy DDEE to DE.

         assign p-vx = p-vx + 1
                DE.eventID   = entry(p-vx,p-cx)
                DE.issueWidth = 1.

             if first(DDEE.StartTime) 
             then assign timeEnd     =  DDEE.EndTime
                         DE.columnID = 1 .
             else assign p-vz = p-vz + 1.
     end.

     run createEvents.
  
     for each DE by DE.columnID:
  
            assign bubbleNo = bubbleNo + 1
                   timeStart   = truncate(DE.StartTime / 100,0) + dec(DE.StartTime modulo 100 / 60) /* convert time to decimal  */
                   timeSPixels = string(((timeStart - (hourFrom / 100)) * 40) - 18)
                   timeFinish  = truncate(DE.EndTime / 100,0) + dec(DE.EndTime modulo 100 / 60) /* convert time to decimal  */
                   timeFPixels = string(((timeFinish - timeStart) * 40)  )                 
                   issueWidth  = truncate(100 / DE.issueWidth,0) - 1                   
                   issueLeft   = (DE.issueleft - 1) * (issueWidth + 1)
                   .
 
     lc-innerText = lc-innerText +  /* CCC */
                '<div id="AA"  style="display:block;margin-right:5px;position:relative;height:1px;font-size:1px;margin-top:-1px;">'  .


     lc-innerText = lc-innerText +  /* DDD */
                '<div id="BB" onselectstart="return false;" onclick="javascript:event.cancelBubble=true;eventSelect("'   + DE.EventRowid  +  '");"' +
                  ' style="-moz-user-select:none;-khtml-user-select:none;user-select:none;cursor:pointer;' +
                  ' position:absolute;font-family:Tahoma;font-size:8pt;white-space:no-wrap;' +

                  'left:' + string(issueLeft)  + '%;top:' + timeSPixels + 'px;width:' + string(issueWidth) + '%;height:' + timeFPixels + 'px;background-color:#000000;">' +

             /*                      ^^^^^ hour position                                                               */
                  '<div id="CC" ' +
                  ' onmouseover="this.style.backgroundColor=' +
                  '#DCDCDC' + 
                  ';event.cancelBubble=true;"' +
                  ' onmouseout="this.style.backgroundColor=' + 
                  '#FFFFFF' + 
                  ';event.cancelBubble=true;"' +
                  ' title="' +
          string(DE.Name + " - " + timeFormat(DE.StartTime) + " - " + timeFormat(DE.EndTime) +  " - " + DE.EventData ) /* Full details here */
          .
           timeFPixels = string(integer(timeFPixels) - 2 ). /* fix the inner height */
           issueWidth  = if issueWidth < 70 then 98 else 99.                  /* fix the inner width */
       lc-innerText = lc-innerText +
                    '" style="width:' + string(issueWidth) + '%;margin-top:1px;display:block;height:' + timeFPixels + 'px;background-color:#FFFFFF;border-left:1px solid #000000;border-right:1px solid #000000;overflow:hidden;">' +
                      /*                                     vvvv^^^^  time spread of box                  */
                    '<div id="INNER" style="float:left;width:5px;height:' + timeFPixels + 'px;margin-top:0px;background-color:Blue;font-size:1px;"></div>' +
                     '<div style="float:left;width:1px;background-color:#000000;height:100%;"></div>' +
                     '<div style="float:left;width:2px;height:100%;"></div>' +
                     '<div style="padding:1px;">' +
       string(DE.Name + "<br>" + timeFormat(DE.StartTime) + " - " + timeFormat(DE.EndTime) +  "<br>" + DE.EventData )  + /* Box detail here */
                    '</div>' +
                  '</div>' +
                '</div>' .

     lc-innerText = lc-innerText +  /* EEE */
                '</div>'  .
              
     end.
   lc-innerText = lc-innerText +  '</td>' .
 
   end.
   else
   do:
   lc-innerText = lc-innerText +  /* BBB */
            '<td width="'  + dayWidth  + 'px" style="height:1px;text-align:left;">'  +
              '<div style="display:block;margin-right:5px;position:relative;height:1px;font-size:1px;margin-top:-1px;">'  +
              '</div>'  +
            '</td>' .
   end.

end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mainDiary) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mainDiary Procedure 
PROCEDURE mainDiary :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* START OF PAGE */

 

run timeBar.

lc-innerText =   /* MAIN OUTER TABLE BEGIN */
'<table id="Calendar1" cellpadding="0" cellspacing="0" border="0" width="1200px" >'  +
    '<tr>'  +
      '<td valign="top">'   

  .
lc-innerText = lc-innerText + 
'<div style="position:absolute;top:39px;left:44px;;border-right:1px solid #000000;">' +
'<table id="CalendarInner" cellpadding="0" cellspacing="0" border="0" width="100%" style="border-bottom:1px solid #000000;text-align:left;">'  +
  '<tr>'  +
    '<td valign="top">'  +
    '</td>' +
    '<td width="100%" valign="top">'  .

 lc-innerText = lc-innerText +   /* AAA */
      '<table cellpadding="0" cellspacing="0" border="0" width="100%" style="border-left:1px solid #000000;">'  +
        '<tr style="height:1px;background-color:#000000;">'  .

 run insertEvents.

  /*   below here should be constant .....*/


/* COLUMN DATE ENTRY  */
 lc-mainText =  
        '</tr>' +
        '<tr style="background-color:#ECE9D8;height:21px;">'  .

    do zx = 1 to dayRange:
    
        assign dayDate = viewerDay + int(zx - (round(dayRange / 2,0)))
               dayNum  = weekday(dayDate)
               dayDesc = entry(dayNum,dayList)
               dayDesc = if dayRange > 9 then substr(dayDesc,1,4) else dayDesc
               .
     if dayNum = 1 or dayNum = 7 then next.

     lc-mainText = lc-mainText +
              '<td valign="bottom" style="background-color:#ECE9D8;cursor:default;border-right:1px solid #000000; ">'.
     
     if dayDate = today then  
          lc-mainText = lc-mainText +  '<a name="moveHere" />'  +
                  '<div id="two" class="minwidth" style="display:block;background-color:yellow;border-bottom:1px solid #000000;text-align:center;height:20px; ">'.

     else lc-mainText = lc-mainText +  '<div id="two" class="minwidth" style="display:block;border-bottom:1px solid #000000;text-align:center;height:20px; ">'.

     lc-mainText = lc-mainText +         '<div >' +
             
                    '<div id="four" style="padding:2px;font-family:Tahoma;font-size:10pt;width:90%">' +
                      '<div id="three" style="position:relative; font-family:Tahoma;font-size:10pt;float:left;left:-12px;width:30px">' +
                        string(day(dayDate))  +
                      '</div>' +
                      '<span style="position:relative;left:-20px;">' + dayDesc  + '</span>' +
            			 '</div>' +
                    '</div>' +
          			'</div>' +
        			'</td>'   .   
    end.

 lc-mainText = lc-mainText +
        '</tr>'  .


/* HOUR CELL ENTRY  */
        
  do vx = 01 to 24 :
  
    if vx * 100 > hourFrom and vx * 100 < hourTo then  /* or how ever many hours to do... */
    do:
  
   lc-mainText = lc-mainText +
          '<!-- empty cells -->' +
          '<tr>'   .
  
       do zx = 1 to dayRange:
        assign dayDate = viewerDay + int(zx - (round(dayRange / 2,0)))
               dayNum  = weekday(dayDate)
               dayDesc = string(viewerDay + (zx - (round(dayRange / 2,0)))) + " - " + string(vx).
      
       if dayNum = 1 or dayNum = 7 then next.

       lc-mainText = lc-mainText +
              '<td onclick="javascript:alert(' + 
               '\"' +  dayDesc  + ':00' + 
               '\"' + 
               ');"'.
             
        if vx * 100 < coreHourFrom or vx * 100  > coreHourTo or dayNum = 1 or dayNum = 7 then
          lc-mainText = lc-mainText + ' onmouseover="this.style.backgroundColor=' + 
                 '#99FFCC' + 
                  ';"' +
                 ' onmouseout="this.style.backgroundColor=' + 
                 '#CCFFCC' + 
                 ';"' +
                 ' valign="bottom" style="background-color:#CCFFCC;cursor:pointer;cursor:hand;border-right:1px solid #000000;height:20px;">' 
                .
        else
          lc-mainText = lc-mainText + ' onmouseover="this.style.backgroundColor=' + 
                 '#FFED95' + 
                 ';"' +
                 ' onmouseout="this.style.backgroundColor=' + 
                 '#FFFFD5' + 
                 ';"' +
                 ' valign="bottom" style="background-color:#FFFFD5;cursor:pointer;cursor:hand;border-right:1px solid #000000;height:20px;">' 
                .
          lc-mainText = lc-mainText +
                '<div style="display:block;height:14px;border-bottom:1px solid #EAD098;z-index:50;">' +
                  '<span style="font-size:1px">&nbsp;</span>' +
                '</div>' +
              '</td>'  .
       end.
      
   lc-mainText = lc-mainText +
          '</tr>'  + 
          '<tr style="height:20px;">'  .
  
       do zx = 1 to dayRange:
         assign dayDate = viewerDay + int(zx - (round(dayRange / 2,0)))
                dayNum  = weekday(dayDate)
                dayDesc = string(viewerDay + (zx - (round(dayRange / 2,0)))) + " - " + string(vx).
      
         if dayNum = 1 or dayNum = 7 then next.

       lc-mainText = lc-mainText +
              '<td onclick="javascript:alert(' + 
               '\"' +  dayDesc  + ':30' + 
               '\"' + 
               ');"'.
 

        if vx * 100 < coreHourFrom or vx * 100  > coreHourTo or dayNum = 1 or dayNum = 7 then
          lc-mainText = lc-mainText + ' onmouseover="this.style.backgroundColor=' + 
                 '#99FFCC' + 
                 ';"' +
                 ' onmouseout="this.style.backgroundColor=' + 
                 '#CCFFCC' + 
                 ' ;"' +
                 ' valign="bottom" style="background-color:#CCFFCC;cursor:pointer;cursor:hand;border-right:1px solid #000000;height:20px;">'
                .
        else
          lc-mainText = lc-mainText + ' onmouseover="this.style.backgroundColor=' + 
                 '#FFED95' + 
                 ';"' +
                 ' onmouseout="this.style.backgroundColor=' + 
                 '#FFFFD5' + 
                 ';"' +
                 ' valign="bottom" style="background-color:#FFFFD5;cursor:pointer;cursor:hand;border-right:1px solid #000000;height:20px;">' 
                .
          lc-mainText = lc-mainText +
                  '<div style="display:block;height:14px;border-bottom:1px solid #EAD098;z-index:50;">' +
                  '<span style="font-size:1px">&nbsp;</span>' +
                '</div>' +
            '</td>'  .
       end.
   
   lc-mainText = lc-mainText +
          '</tr>'  .
    end.
  end.
        

lc-mainText = lc-mainText +
		  '</table>'   +   
    '</td>'        +   
  '</tr>'          +   
'</table>'         +
'</div>'           +
'</table>'        
    .




lc-mainText = lc-mainText +

  '<!--[if IE ]>'  +
  ' <script>'  +
  '   isIE = true;'  +
  ' </script>'  +
  '<![endif]-->'  +
  '<script type="text/javascript">'  +
  '  fixTimeDiv("fixedTimeDiv");'  +
  '  window.setInterval(~'fixTimeDiv("fixedTimeDiv")~', 50);'  +
  '  scrollWindow();'  +
  '</script>'  
  .

lc-mainText = lc-mainText +
    
  '<script type="text/javascript" language="javascript">'  +
  '// <![CDATA['  +
  '// horizontal slider control with preset values'  +
  'new Control.Slider(~'handle1~', ~'track1~', ~{'  +
  'range: $R(1, 41),'  +
  'values: [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 25, 31, 41],'  +
  'sliderValue: 15, // wont work if set to 0 due to a bug(?) in script.aculo.us'  +
  'onSlide: function(v)~{ $(~'debug1~').innerHTML = ~'slide: ~' + v ~},'  +
  'onChange: function(v)~{ $(~'debug1~').innerHTML = ~'changed: ~' + v ~},'  +
  '~});'  +
  '// ]]>'  +
  '</script>' 

  .

/* output to "c:\temp\djs.txt".      */
/* put unformatted lc-mainText skip. */
/* output close.                     */
/*                                   */

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
  

    {lib/checkloggedin.i}

   
    assign lc-search = get-value("search")
           lc-firstrow = get-value("firstrow")
           lc-lastrow  = get-value("lastrow")
           lc-navigation = get-value("navigation").
    
    assign lc-parameters = "search=" + lc-search +
                           "&firstrow=" + lc-firstrow + 
                           "&lastrow=" + lc-lastrow.

    
    
    assign lc-char = htmlib-GetAttr('system','MNTNoLinesDown').
    
/*     assign li-max-lines = int(lc-char) no-error. */
/*     if error-status:error                        */
/*     or li-max-lines < 1                          */
/*     or li-max-lines = ? then li-max-lines = 12.  */
/*                                                  */
/*     assign                                       */
/*         li-max-lines = 5.                        */
/*                                                  */
/*     run com-GetKBSection(lc-global-company,      */
/*                          output lc-code,         */
/*                          output lc-desc).        */
/*                                                  */
/*     assign                                       */
/*         lc-code = "ALL|" + lc-code               */
/*         lc-desc = "All Sections|" + lc-desc.     */
/*                                                  */
/*     assign                                       */
/*         lc-knbcode = get-value("knbcode")        */
/*         lc-type    = get-value("type").          */


    RUN outputHeader.
    


        {&out}
        '<style>' skip
           '.hi ~{ color: red; font-size: 10px; margin-left: 15px; font-style: italic;~}' skip
           '</style>' skip 
           '<link href="/style/diary.css" type="text/css" rel="stylesheet" />' skip.

    run diaryHeader.



    {&out} htmlib-Header("Diary View") skip.

    {&out} htmlib-JScript-Maintenance() skip.

    {&out} htmlib-StartForm("mainform","post", appurl + '/time/diary01.p' ) skip.

    {&out} htmlib-ProgramTitle("Engineers Time Recording") skip.
    
 
    {&out}

    '<div id="diaryscreen" style="clear: both;" class="toolbar">&nbsp;' skip
    ' <br><br><br><br>' skip
    '</div>' skip
      '<iframe id="diaryinner" name="diaryinner" src="" width="800px" height="600px" >' skip
        '</iframe >' skip
     .



  {&out}
  '<script type="text/javascript" language="javascript">' skip
  ' <!-- ' skip
  .
    
    run mainDiary.

  {&out}
  'function populateIframe() ~{' skip
  'var ifrm = document.getElementById("diaryinner");' skip
  'ifrm = (ifrm.contentWindow) ? ifrm.contentWindow : (ifrm.contentDocument.document) ? ifrm.contentDocument.document : ifrm.contentDocument;' skip
  'ifrm.document.open();' skip
  'ifrm.document.write(~'' lc-sliderText " " lc-timeText " " lc-innerText  " " lc-mainText
  '~');' skip
  'ifrm.document.close();' skip
  '~}' skip
  'populateIframe(); ' skip
  ' // -->' skip 
  '</script>' skip
   .



 
    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-timeBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE timeBar Procedure 
PROCEDURE timeBar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 

/*  run createDaySlider. */

 lc-timeText =

  '<div id="fixedTimeDiv" style="position:absolute;top:0px;left:0px;width:54px;z-index:100;">' +

  '<input type="button" onclick="scrollWindow()" value="Today" />'  + 
  

        '<table cellpadding="0" cellspacing="0" border="0" width="0" style="border-left:1px solid #000000;border-right:1px solid #000000;border-bottom:1px solid #000000;">'  +
          '<tr style="height:1px;background-color:#000000;">'  +
            '<td>'  +
            '</td>' +
          '</tr>'  +
          '<tr style="height:21px;">'  +
            '<td valign="bottom" style="background-color:#ECE9D8;cursor:default;">'  +
              '<div style="display:block;border-bottom:1px solid #000000;text-align:right;">'  + 
                '<div style="padding:2px;font-size:6pt;">' +
                  '&nbsp;' +
                '</div>'  +
              '</div>'  +
            '</td>'  +
          '</tr>'  .

    do vx = 01 to 24 :
      if vx * 100 > hourFrom and vx * 100 < hourTo then /* or how ever many hours to do... */
      do:
        if vx > 11 then assign ap = 2.
                     else assign ap = 1.
        if vx > 12 then assign yx = vx - 12.
                     else assign yx = vx.

    lc-timeText = lc-timeText +

           '<tr style="height:40px;">' +
            '<td valign="bottom" style="background-color:#ECE9D8;cursor:default;">' +
             '<div id="idMenuFixedInViewport" >' +
              '<div style="display:block;border-bottom:1px solid #ACA899;height:39px;text-align:right;">' +
                '<div style="padding:2px;font-family:Tahoma;font-size:16pt;">' +
          string(yx)   +
                  '<span style="font-size:10px; vertical-align: super; ">&nbsp;' +
          string(AMPM[ap])    +
                  '</span>' +
                '</div>' +
              '</div>' +
            '</div>' +
            '</td>' +
          '</tr>'  .
      end.
    end.

   lc-timeText = lc-timeText +
        '</table>' +
     '</div>'
     .



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnText Procedure 
FUNCTION fnText RETURNS CHARACTER
  ( pf-knbid as dec,
    pi-count as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def buffer knbText  for knbText.  
    def var li-count    as int no-undo.
    def var li-found    as int no-undo.
    def var lc-return   as char no-undo.
    def var lc-char     as char no-undo.

    find knbText where knbText.knbID = pf-knbID
                   and knbText.dType = "I" no-lock no-error.
    if not avail knbText then return "&nbsp;".


    do li-count = 1 to num-entries(knbText.dData,"~n"):

        assign lc-char = entry(li-count,knbText.dData,"~n").
        if trim(lc-char) = "" then next.

       
        if li-found = 0
        then assign lc-return = right-trim(lc-char).
        else assign lc-return = lc-return + "<br>" + right-trim(lc-char).

        assign li-found = li-found + 1.

        if li-found = pi-count then leave.

    end.

    return lc-return.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-timeFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION timeFormat Procedure 
FUNCTION timeFormat RETURNS CHARACTER
 (param1 as int):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var hh as char no-undo.
  def var mm as char no-undo.
  def var ss as char no-undo.
  def var aa as char no-undo.
 
  assign hh = string(int(substr(string(param1,"9999"),1,2)))
         mm  = substr(string(param1,"9999"),3,2).
         return string(string(hh) + ":" + string(mm) ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

