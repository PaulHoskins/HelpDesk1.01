/***********************************************************************

    Program:        lib/ssyseclib.i
    
    Purpose:        Security Lib     
    
    Notes:
    
    
    When        Who         What
    25/09/2014  phoski      initial

***********************************************************************/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */

DEFINE VARIABLE lc-global-cookie-name    AS CHARACTER    
    INITIAL 'LoginInfo' NO-UNDO.
DEFINE VARIABLE li-global-pass-max-retry AS INTEGER 
    INITIAL 10 NO-UNDO.
DEFINE VARIABLE lc-global-pack-key      AS CHARACTER 
    INITIAL 'abcEFghi>'                 NO-UNDO.
       

FUNCTION syec-UserHasAcessToObject RETURNS LOGICAL 
    (pc-loginid AS CHARACTER,
    pc-objType AS CHARACTER,
    pc-objInfo AS CHARACTER,
     pc-ObjOther AS CHARACTER) FORWARD.

FUNCTION sysec-DecodeValue RETURNS CHARACTER 
    (pc-loginid AS CHARACTER,
    pd-date  AS DATE,
    pc-other AS CHARACTER,
    pc-value AS CHARACTER) FORWARD.

FUNCTION sysec-EncodeValue RETURNS CHARACTER 
    (pc-loginid AS CHARACTER,
    pd-date  AS DATE,
    pc-other AS CHARACTER,
    pc-value AS CHARACTER) FORWARD.

FUNCTION sysec-GeneratePBE-Password RETURNS CHARACTER 
    (pc-loginid AS CHARACTER,
    pd-date  AS DATE,
    pc-other AS CHARACTER) FORWARD.

/* ***************************  Main Block  *************************** */

/* ************************  Function Implementations ***************** */


FUNCTION syec-UserHasAcessToObject RETURNS LOGICAL 
    ( pc-loginid AS CHARACTER,
    pc-objType AS CHARACTER,
    pc-objInfo AS CHARACTER,
    pc-ObjOther AS CHARACTER  ):
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/	

    DEFINE VARIABLE llok AS LOGICAL NO-UNDO.
    llok = TRUE.

    RUN lib/syec-checkaccess.p 
    (
    INPUT pc-loginid,
    INPUT pc-ObjType,
    INPUT pc-ObjInfo,
    INPUT  pc-ObjOther,
    OUTPUT llok
    ).
   
    
    RETURN llok.

		
END FUNCTION.

FUNCTION sysec-DecodeValue RETURNS CHARACTER 
    ( pc-loginid AS CHARACTER ,
    pd-date  AS DATE ,
    pc-other AS CHARACTER,
    pc-value AS CHARACTER ):
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/    

    DEFINE BUFFER websalt FOR websalt.  
    DEFINE BUFFER websession FOR websession.
     
    DEFINE VARIABLE lr-data AS MEMPTR    NO-UNDO.
    DEFINE VARIABLE lc-data AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lr-mem  AS RAW       NO-UNDO.
    
    IF pc-other = "Inventory"
    THEN 
    DO:
        FIND FIRST  websession
             WHERE websession.wsKey = pc-value
                AND websession.wsDate = pd-date NO-LOCK NO-ERROR.
                
        RETURN IF AVAILABLE websession THEN websession.wsValue ELSE ?.
    END.
        
    FIND websalt WHERE websalt.loginid = pc-loginid
        AND websalt.sdate = pd-date
        AND websalt.sother = pc-other NO-LOCK NO-ERROR.
    IF NOT AVAILABLE websalt THEN RETURN ?.
    
    DEFINE VARIABLE lr-pbe-key AS RAW NO-UNDO.
    
 
    lr-pbe-key = GENERATE-PBE-KEY(websalt.sval).
   
    lr-data = BASE64-DECODE(pc-value) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN ?.
        
    ASSIGN
        SECURITY-POLICY:SYMMETRIC-ENCRYPTION-ALGORITHM = "AES_OFB_128"
        SECURITY-POLICY:SYMMETRIC-ENCRYPTION-KEY       = lr-pbe-key
        SECURITY-POLICY:SYMMETRIC-ENCRYPTION-IV        = ?.
            
    
    lc-data = GET-STRING(DECRYPT (lr-data),1).
     
    RETURN lc-data.

		
END FUNCTION.

FUNCTION sysec-EncodeValue RETURNS CHARACTER 
    ( pc-loginid AS CHARACTER ,
    pd-date  AS DATE ,
    pc-other AS CHARACTER,
    pc-value AS CHARACTER ):
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/    

    DEFINE BUFFER websalt FOR websalt. 
    DEFINE BUFFER websession FOR websession.
    
    DEFINE VARIABLE lr-data AS RAW       NO-UNDO.
    DEFINE VARIABLE lc-data AS CHARACTER NO-UNDO.
    
    IF pc-other = "Inventory" THEN 
    DO:
        lc-data = DYNAMIC-FUNCTION("sysec-GeneratePBE-Password",pc-loginid,pd-date,pc-other). 
        
        CREATE websession.
        ASSIGN 
            websession.wsKey = lc-data
            websession.wsDate = pd-date
            websession.wsValue = pc-value.
        RELEASE websession.    
        RETURN lc-data.
        
    END.
             
    FIND websalt WHERE websalt.loginid = pc-loginid
        AND websalt.sdate = pd-date
        AND websalt.sother = pc-other NO-LOCK NO-ERROR.
    IF NOT AVAILABLE websalt THEN
    DO:
        CREATE websalt.
        ASSIGN 
            websalt.loginid = pc-loginid
            websalt.sdate   = pd-date
            websalt.sother  = pc-other.
        ASSIGN
            websalt.sval = DYNAMIC-FUNCTION("sysec-GeneratePBE-Password",pc-loginid,pd-date,pc-other).    
    END.    
    
    DEFINE VARIABLE lr-pbe-key AS RAW NO-UNDO.
    
 
    lr-pbe-key = GENERATE-PBE-KEY(websalt.sval).
    
    ASSIGN
        SECURITY-POLICY:SYMMETRIC-ENCRYPTION-ALGORITHM = "AES_OFB_128"
        SECURITY-POLICY:SYMMETRIC-ENCRYPTION-KEY       = lr-pbe-key
        SECURITY-POLICY:SYMMETRIC-ENCRYPTION-IV        = ?.
            
    lr-data = ENCRYPT (pc-value).
    
    lc-data = BASE64-ENCODE(lr-data).

    RETURN lc-data.
    
		
END FUNCTION.

FUNCTION sysec-GeneratePBE-Password RETURNS CHARACTER 
    ( pc-loginid AS CHARACTER ,
    pd-date  AS DATE ,
    pc-other AS CHARACTER):
    /*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/    

    DEFINE VARIABLE MyUUID AS RAW       NO-UNDO.
    DEFINE VARIABLE cGUID  AS CHARACTER NO-UNDO. 
    ASSIGN  
        MyUUID = GENERATE-UUID  
        cGUID  = GUID(MyUUID). 
    
    RETURN cGUID.
        
		
END FUNCTION.

