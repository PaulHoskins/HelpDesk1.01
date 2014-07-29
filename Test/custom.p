@program FILE(name="custom.p", module="Test").

/*------------------------------------------------------------------------
    File        : custom.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pauldd
    Created     : Sun Jul 20 10:48:19 BST 2014
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

ROUTINE-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */
DEF VAR xx AS INT NO-UNDO.


/* ***************************  Main Block  *************************** */
@program(name="custom.p").
PROCEDURE fuck:
    
END PROCEDURE.
    