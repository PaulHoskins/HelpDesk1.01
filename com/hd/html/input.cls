 
 /*------------------------------------------------------------------------
    File        : input
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : paul
    Created     : Sun Jul 20 11:54:33 BST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS com.hd.html.input USE-WIDGET-POOL: 

	DEFINE PUBLIC PROPERTY type AS CHARACTER INITIAL 'input' NO-UNDO 
	GET.
	SET. 

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/

	METHOD PUBLIC VOID render(  ):
	    
	    CASE type:
	        WHEN "xx" THEN
            DO:
            END.
        END CASE.
    		
		RETURN.

		

	END METHOD.

	DESTRUCTOR PUBLIC input ( ):

	END DESTRUCTOR.

END CLASS.