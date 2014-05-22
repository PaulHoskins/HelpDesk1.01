    def var lc-rowid as char no-undo.

  
    /* ------- checkDate function ------- */
    /*       (C) DJS 1996 RiverSoft       */
  function checkdate returns date (chkdate as char, lang as char):
  def var retdate as date no-undo.
  def var tmpdate as char no-undo.
  if num-entries(chkdate,"/") <> 3 then 
  do:
      if lang = 'uk' and session:date-format = 'dmy' then
      do:
      tmpdate = string(substr(chkdate,1,2) + '/' +
                       substr(chkdate,3,2) + '/' +
                       substr(chkdate,5) ). /* US */
      retdate = date(tmpdate) no-error.
      if error-status:error then retdate = ?.
      end.
  end.
  else do:
      retdate = date(chkdate) no-error.
      if error-status:error then retdate = ?.
  end.
  return retdate.
  end function.
  /* --- end of checkDate function --- */

    for each ivField   :

        if ivField.dtype <>  "date" 
          and (ivField.dLabel matches("*expir*") or ivField.dLabel matches("*renewal*") )
        then
        do:
    
          display
              ivField.ivSubID 
              ivField.ivFieldID
/*               ivField.dOrder */
              ivField.dLabel
              ivField.dType
/*               ivField.dwarning   */
/*               ivField.dMandatory */
/*               ivField.dPrompt    */
             with width 78.

          assign ivField.dtype = "date".

display "---------------------------------------------".
              for each ivSub of ivField no-lock :
  
                display ivSub with 1 col.


display "---------------------------------------------".

                  for each CustField of ivField :

                    display 

                      CustField.FieldData 
      
                      with 1 col.

/*                     if checkdate(CustField.FieldData, 'uk') = ?  then                                 */
/*                      assign CustField.FieldData = "".                                                 */
/*                      else assign CustField.FieldData = string(checkdate(CustField.FieldData, 'uk')) . */


                  end.

display "---------------------------------------------".            
          end.
        end.
 
  end.
