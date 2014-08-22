/***********************************************************************

    Program:        lib/checkloggedin.i
    
    Purpose:        Make sure user is logged in                  
    
    Notes:
    
    
    When        Who         What
    10/09/2006  phoski      com-InitialSetup

***********************************************************************/

DEFINE VARIABLE lc-user  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lc-value AS CHARACTER NO-UNDO.

ASSIGN 
    lc-value = get-cookie("ExtranetUser").
/*
set-user-field("IPADD",REMOTE_ADDR).
MESSAGE "Set IPADD" REMOTE_ADDR.
*/

ASSIGN 
    lc-user = htmlib-DecodeUser(lc-value).

IF lc-user = "" THEN
DO:
    ASSIGN 
        lc-user = get-user-field("ExtranetUser").
END.
IF lc-user = "" THEN
DO:
    RUN run-web-object IN web-utilities-hdl ("mn/notloggedin.p").
    RETURN.
END.
set-user-field("ExtranetUser",lc-user).

DYNAMIC-FUNCTION("com-InitialSetup",lc-user).

IF request_method <> "POST" THEN
    Set-Cookie("ExtranetUser",
        htmlib-EncodeUser(lc-user),
        DYNAMIC-FUNCTION("com-CookieDate",lc-user),
        DYNAMIC-FUNCTION("com-CookieTime",lc-user),
        APPurl,
        ?,
        IF hostURL BEGINS "https" THEN "secure" ELSE ?).



