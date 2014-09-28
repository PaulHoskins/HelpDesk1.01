
/*------------------------------------------------------------------------
    File        : md5-test.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : paul
    Created     : Thu Sep 25 07:35:41 BST 2014
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE websalt NO-UNDO
    FIELD loginid AS CHARACTER
    FIELD sdate   AS DATE
    FIELD sother  AS CHAR
    FIELD sval    AS CHARACTER
    INDEX pr
    loginid sdate sother.
        
        


/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


FUNCTION sltDecodeValue RETURNS CHARACTER 
	(pc-loginid AS CHARACTER,
	 pd-date  AS DATE,
	 pc-other AS CHAR,
	 pc-value AS CHAR) FORWARD.

FUNCTION sltEncodeValue RETURNS CHARACTER 
    (pc-loginid AS CHARACTER,
    pd-date  AS DATE,
    pc-other AS CHAR,
    pc-value AS CHAR) FORWARD.

FUNCTION sltGenerate RETURNS CHARACTER 
    (pc-loginid AS CHARACTER,
    pd-date  AS DATE,
    pc-other AS CHAR) FORWARD.


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE lc-key AS CHARACTER FORMAT 'x(24)' NO-UNDO.
DEFINE VARIABLE lc-back AS CHARACTER FORMAT 'x(24)' NO-UNDO.


FOR EACH Customer NO-LOCK WITH DOWN STREAM-IO:
    
    lc-key = DYNAMIC-FUNCTION("sltEncodeValue","paul",TODAY,"",STRING(ROWID(customer))).
   
    lc-back = DYNAMIC-FUNCTION("sltDecodeValue","paul",TODAY,"",lc-key).
    
    DISPLAY
        lc-key 
 
      lc-back STRING(ROWID(Customer)) FORMAT 'x(20)'.
    
END.

/* ************************  Function Implementations ***************** */


FUNCTION sltDecodeValue RETURNS CHARACTER 
	    ( pc-loginid AS CHARACTER ,
    pd-date  AS DATE ,
    pc-other AS CHAR,
    pc-value AS CHAR ):
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/	

    DEFINE BUFFER websalt FOR websalt.  
    DEFINE VARIABLE lr-data AS MEMPTR NO-UNDO.
    DEFINE VARIABLE lc-data AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lr-mem   AS RAW NO-UNDO.
    
            
    FIND websalt WHERE websalt.loginid = pc-loginid
        AND websalt.sdate = pd-date
        AND websalt.sother = pc-other NO-LOCK NO-ERROR.
    IF NOT AVAILABLE websalt THEN RETURN ?.
    
    DEFINE VARIABLE lr-pbe-key  AS RAW NO-UNDO.
    
 
    lr-pbe-key = GENERATE-PBE-KEY(websalt.sval).
   
    lr-data = BASE64-DECODE(pc-value) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN ?.
        
    ASSIGN
            SECURITY-POLICY:SYMMETRIC-ENCRYPTION-ALGORITHM = "AES_OFB_128"
            SECURITY-POLICY:SYMMETRIC-ENCRYPTION-KEY = lr-pbe-key
            SECURITY-POLICY:SYMMETRIC-ENCRYPTION-IV = ?.
            
    
    lc-data = GET-STRING(DECRYPT (lr-data),1).
     
    RETURN lc-data.
		
END FUNCTION.

FUNCTION sltEncodeValue RETURNS CHARACTER
    ( pc-loginid AS CHARACTER ,
    pd-date  AS DATE ,
    pc-other AS CHAR,
    pc-value AS CHAR):
    /*------------------------------------------------------------------------------
            Purpose:  																	  
            Notes:  																	  
    ------------------------------------------------------------------------------*/	

    DEFINE BUFFER websalt FOR websalt.  
    DEFINE VARIABLE lr-data AS RAW NO-UNDO.
    DEFINE VARIABLE lc-data AS CHARACTER NO-UNDO.
    
    		
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
            websalt.sval = DYNAMIC-FUNCTION("sltGenerate",pc-loginid,pd-date,pc-other).    
    END.	
    
    DEFINE VARIABLE lr-pbe-key  AS RAW NO-UNDO.
    
 
    lr-pbe-key = GENERATE-PBE-KEY(websalt.sval).
    
    ASSIGN
            SECURITY-POLICY:SYMMETRIC-ENCRYPTION-ALGORITHM = "AES_OFB_128"
            SECURITY-POLICY:SYMMETRIC-ENCRYPTION-KEY = lr-pbe-key
            SECURITY-POLICY:SYMMETRIC-ENCRYPTION-IV = ?.
            
    lr-data = ENCRYPT (pc-value).
    
    lc-data = BASE64-ENCODE(lr-data).
    
    
   
 
 
    RETURN lc-data.
    
END FUNCTION.

FUNCTION sltGenerate RETURNS CHARACTER 
    ( pc-loginid AS CHARACTER ,
      pd-date  AS DATE ,
      pc-other AS CHAR):
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

        
    
    