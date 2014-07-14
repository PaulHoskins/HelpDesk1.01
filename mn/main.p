&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*           This .W file was created with the Progress AppBuilder.     */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
         HEIGHT             = 11.58
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
  output-http-header("Cache-Control", "no-cache":U).  
  output-http-header("Pragma", "no-cache":U).  
  output-http-header("Expires", "Thu, 01 Dec 1994 16:00:00 GMT":U).

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
        
    def var lc-user as char no-undo.
    def var lc-value as char no-undo.
    
    assign lc-user = get-user-field("ExtranetUser").
    IF lc-user = "" THEN
    DO:
    
        assign lc-value = get-cookie("ExtranetUser").
    
        assign lc-user = htmlib-DecodeUser(lc-value).
    END.

    
    /*if lc-user = "" then
    do:
        assign lc-user = get-user-field("ExtranetUser").
    end.
    */
    if lc-user = "" then
    do:
        RUN run-web-object IN web-utilities-hdl ("mn/notloggedin.p").
        return.
    end.
    

    find webuser where webuser.LoginID = lc-user no-lock no-error.

    find company where company.CompanyCode = webuser.CompanyCode no-lock no-error.

  
    set-user-field("ExtranetUser",webuser.LoginID).

    assign lc-value = htmlib-EncodeUser(webuser.LoginID). 
            
    Set-Cookie("ExtranetUser",
                      lc-value,
                      dynamic-function("com-CookieDate",lc-user),
                      dynamic-function("com-CookieTime",lc-user),
                      APPurl,
                      ?,
                      if hostURL begins "https" then "secure" else ?).

    RUN outputHeader.
  
    {&OUT}
        '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">' skip "~n" +
         '<HTML>' skip
         '<HEAD>' skip
         "<TITLE>" Company.name ' - Help Desk' "</TITLE>":U SKIP
         "</HEAD>":U SKIP.
    
  
    /*
    {&out}
        '<frameset rows="50,*" cols="*" frameborder="NO" border="0" framespacing="0">' skip
            '<frame src="' appurl '/mn/menutop.p" name="menutop" scrolling="NO" noresize>' skip
            '<frameset cols="195,*" frameborder="NO" border="0" framespacing="0">' skip
                '<frame src="' appurl '/mn/menupanel.p" name="leftpanel" scrolling="YES" noresize>' skip
                '<frame src="' appurl '/mn/mainframe.p" name="mainwindow">' skip
            '</frameset>' skip
        '</frameset>' skip.
    */
    /* Increase for split assignments class */

    {&out}
        '<frameset rows="50,*" cols="*" frameborder="NO" border="0" framespacing="0">' skip
            '<frame src="' appurl '/mn/menutop.p" name="menutop" scrolling="NO" noresize>' skip
            '<frameset cols="250,*" frameborder="NO" border="0" framespacing="0">' skip
                '<frame src="' appurl '/mn/menupanel.p" name="leftpanel" scrolling="YES" noresize>' skip
                '<frame src="' appurl '/mn/mainframe.p" name="mainwindow">' skip
            '</frameset>' skip
        '</frameset>' skip.

    {&OUT} htmlib-Footer() skip.
    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

