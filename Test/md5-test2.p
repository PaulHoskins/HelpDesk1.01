
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

{lib/syseclib.i}
        


/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */




/* ***************************  Main Block  *************************** */
DEFINE VARIABLE lc-key AS CHARACTER FORMAT 'x(24)' NO-UNDO.
DEFINE VARIABLE lc-back AS CHARACTER FORMAT 'x(24)' NO-UNDO.


FOR EACH Customer NO-LOCK WITH DOWN STREAM-IO:
    
    lc-key = DYNAMIC-FUNCTION("sysec-EncodeValue","paul",TODAY,"",STRING(ROWID(customer))).
   
    lc-back = DYNAMIC-FUNCTION("sysec-DecodeValue","paul",TODAY,"",lc-key).
    
    DISPLAY
        lc-key 
        LENGTH(lc-key)
 
      lc-back STRING(ROWID(Customer)) FORMAT 'x(20)'.
    
END.

/* ************************  Function Implementations ***************** */    