/***************************************************************************

    Program:    base/lib/attrib.i    
    
    Purpose:    Library for data tags
            
                Data tags are multiply fields stored in on char field
                The data is stored as
                <Name><Break Delim><Value><Attr Delim><Name2> etc
                
                Use this library to set and read the fields
                
    History

    Job     Date        Who         What
    #642    08/11/2002  phoski      initial
    #877    18/11/2003  phoski      Windows problem

****************************************************************************/
&IF DEFINED(attrlib-library-defined) = 0 &THEN

&GLOB attrlib-library-defined yes


&SCOPE attrlibNull      FieldIsNull     /* Null field */
&SCOPE attrlibDelim     '~t'            /* Delim attributes */
&SCOPE attrlibBreak     '|'             /* Delim attribute name/value */

PROCEDURE attrlib-SetAttribute:

    def input param pc-AttrName         as char             no-undo.
    def input param pc-AttrValue        as char             no-undo.
    def input-output param pc-Attribute as char             no-undo.
    
    def var lc-AttrName                 as char             no-undo.
    def var lc-AttrValue                as char             no-undo.
    def var lc-string                   as char             no-undo.
    def var li-Attribute                as int              no-undo.
     
    if pc-AttrValue = ?
    then assign pc-AttrValue = "{&attrlibNull}".
    
    if pc-Attribute <> ?
    and pc-Attribute <> "" then
    do li-Attribute = 1 to num-entries(pc-Attribute,{&attrlibDelim}):
        assign lc-String = entry(li-Attribute,pc-Attribute,{&attrlibDelim}).
        if num-entries(lc-string,{&attrlibBreak}) <> 2
        then next.
        assign lc-AttrName = entry(1,lc-string,{&attrlibBreak})
               lc-AttrValue = entry(2,lc-string,{&attrlibBreak}).
        if lc-AttrName <> pc-AttrName then next. 
                 
        assign lc-string = lc-AttrName + {&attrlibBreak} + pc-AttrValue.
                     
                       
        assign entry(li-Attribute,pc-Attribute,{&attrlibDelim}) = lc-String.
        return.

    end.
    if pc-Attribute = ""
    or pc-Attribute = ?
    then pc-Attribute = pc-AttrName + {&attrlibBreak} + pc-AttrValue.
    else pc-attribute = pc-attribute + {&attrlibDelim} + 
                        pc-AttrName + {&attrlibBreak} + pc-AttrValue.
                        
END PROCEDURE.

PROCEDURE attrlib-GetAttribute:
    def input param pc-AttrName         as char             no-undo.
    def input param pc-Attribute        as char             no-undo.
    def output param pc-AttrValue       as char             no-undo.
    
    def var lc-AttrName                 as char             no-undo.
    def var lc-AttrValue                as char             no-undo.
    def var lc-string                   as char             no-undo.
    def var li-Attribute                as int              no-undo.
     
    if pc-Attribute <> ?
    and pc-Attribute <> "" then
    do li-Attribute = 1 to num-entries(pc-Attribute,{&attrlibDelim}):
        assign lc-String = entry(li-Attribute,pc-Attribute,{&attrlibDelim}).
        if num-entries(lc-string,{&attrlibBreak}) <> 2
        then next.
        assign lc-AttrName = entry(1,lc-string,{&attrlibBreak})
               lc-AttrValue = entry(2,lc-string,{&attrlibBreak}).
        if lc-AttrName <> pc-AttrName then next. 
        
        if lc-AttrValue = "{&attrlibNull}"
        then lc-attrValue = ?.

        assign pc-AttrValue = trim(lc-AttrValue).
        
    end.


END PROCEDURE.

&ENDIF

