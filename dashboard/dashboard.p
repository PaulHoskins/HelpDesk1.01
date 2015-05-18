/***********************************************************************

    Program:        dashboard/dashboard.p
    
    Purpose:        View a dashboard.p
    
    Notes:
    
    
    When        Who         What
    16/05/2015  phoski      Initial
    
***********************************************************************/
CREATE WIDGET-POOL.



DEFINE VARIABLE lc-Panel-ID AS CHARACTER NO-UNDO.
DEFINE VARIABLE MyUUID      AS RAW       NO-UNDO.
DEFINE VARIABLE cGUID       AS CHARACTER NO-UNDO.

    




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
{iss/issue.i}
{lib/ticket.i}
{lib/project.i}



 




/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.



/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

PROCEDURE ip-HTM-Header:
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pc-return       AS CHARACTER NO-UNDO.
      
      
    pc-return = 
        '~n<link rel="stylesheet" type="text/css" href="/asset/jquery-easyui-1.4.2/themes/default/easyui.css">' +
        '~n<link rel="stylesheet" type="text/css" href="/asset/jquery-easyui-1.4.2/themes/icon.css">' +
        '~n<link rel="stylesheet" type="text/css" href="/asset/jquery-easyui-1.4.2/themes/color.css">' +
    
        lc-global-jquery +
        lc-global-jquery-ui 
            
        .
    

END PROCEDURE.

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

    
       
       
    RUN outputHeader.
     
         
    {&out} htmlib-Header("Dashboard") skip.
  

    {&out} htmlib-StartForm("mainform","post", appurl + '/dashboard/dashboard.p' ) skip.



    DEFINE VARIABLE li-panel        AS INTEGER      NO-UNDO.
    DEFINE VARIABLE li-panel-count  AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lc-panel-URL    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE li-panel-size   AS INTEGER      NO-UNDO.
    DEFINE VARIABLE li-region-size  AS INTEGER      NO-UNDO.
    DEFINE VARIABLE lc-dashb-title  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lc-panel-title  AS CHARACTER    NO-UNDO.
    
    
       
    ASSIGN 
        lc-dashb-title = "HelpDesk Dashboard " + string(NOW).
       
    ASSIGN 
        li-panel-count = 4
        li-panel-size = 300
        li-region-size = max(800, ( li-panel-size * li-panel-count)) + 200.
    .
    
    {&out}
    '<div id="cc" class="easyui-layout" style="width:100%;height:' li-region-size 'px;">
    <div data-options="region:~'north~',title:~'HelpDesk Dashboard~',split:true" style="height:100px;"></div>
    <div data-options="region:~'west~',title:~'Options~',split:true" style="width:100px;">' SKIP.
    {&out} '<div style="padding:5px 5px;">' SKIP.
    
    {&out} '<a href="javascript:init();" class="easyui-linkbutton" data-options="iconCls:~'icon-reload~'">Reload</a>' SKIP.
    {&out} '</div>' SKIP.
    
    {&out} '</div>
    <div data-options="region:~'center~',title:~'' lc-dashb-title '~'" style="padding:5px;background:#eee;">' SKIP.
    
        
    DO li-panel = 1 TO li-panel-count:
        ASSIGN
            lc-Panel-ID = "panel" + string(li-panel)
            lc-panel-title = "Latest 20 Issues".
    
        {&out} '<div id="' lc-Panel-ID '" class="easyui-panel" title="' lc-Panel-title '" ' SKIP
               'style="width:99%;height:' li-panel-size 'px;padding:5px;background:#fafafa;"
        data-options="iconCls:~'icon-large-shapes~',closable:true,collapsible:true,minimizable:false,maximizable:true"></div>' skip.
      
    END.
          
    /* end of center */
    {&out} '</div>
</div>' SKIP.
   
    {&out} '<script>' SKIP
           'function init () ~{' skip.
   
    DO li-panel = 1 TO li-panel-count:
        ASSIGN
            MyUUID = GENERATE-UUID  
            cGUID  = GUID(MyUUID).
        
        lc-Panel-ID = "panel" + string(li-panel).
        lc-panel-URL = appurl + "/dashboard/ajax/panel.p".
        lc-panel-URL = appurl + "/dashboard/ajax/panel.p?Session=" + cGuid 
            + "&panelid=" + lc-panel-id 
            + "&number=" + string(li-panel).
 
        {&out}
        "$('#" lc-panel-ID "').panel(~{
    href:'" lc-Panel-URL "'
~});" SKIP.


    END.

    {&out} skip 
         '~}' SKIP
         'init ();' skip
        '</script>' SKIP.
            
    {&out} htmlib-EndForm() skip.

   

    {&OUT} htmlib-Footer() skip.
    
   
    
END PROCEDURE.


&ENDIF

