&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************

    Program:        lib/checkloggedin.i
    
    Purpose:        Make sure user is logged in                  
    
    Notes:
    
    
    When        Who         What
    10/09/2006  phoski      com-InitialSetup

***********************************************************************/

def var lc-user as char no-undo.
def var lc-value as char no-undo.

assign lc-value = get-cookie("ExtranetUser").
/*
set-user-field("IPADD",REMOTE_ADDR).
MESSAGE "Set IPADD" REMOTE_ADDR.
*/

assign lc-user = htmlib-DecodeUser(lc-value).

if lc-user = "" then
do:
    assign lc-user = get-user-field("ExtranetUser").
end.
if lc-user = "" then
do:
    RUN run-web-object IN web-utilities-hdl ("mn/notloggedin.p").
    return.
end.
set-user-field("ExtranetUser",lc-user).

dynamic-function("com-InitialSetup",lc-user).

if request_method <> "POST" then
Set-Cookie("ExtranetUser",
          htmlib-EncodeUser(lc-user),
          dynamic-function("com-CookieDate",lc-user),
          dynamic-function("com-CookieTime",lc-user),
          APPurl,
          ?,
          if hostURL begins "https" then "secure" else ?).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


