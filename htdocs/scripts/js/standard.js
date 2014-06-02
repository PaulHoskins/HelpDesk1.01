var HlpWinHdl = null
var PopUpWinHdl = null
var RepWinHdl = null
var LookupWinHdl = null

function ClosePage() {

	CloseHelpWindow()
	ClosePopUpWindow()
	CloseRepWindow()
	CloseLookupWindow()

}

function ClosePageRefreshParent() {
	
	var ParentWindow = opener
	var ParentLocation = ParentWindow.location
	
	ClosePage()
	
	ParentLocation += "&addnote=done"
	
	ParentWindow.location = ParentLocation
	
}

function LookupWindow(URL, FieldName, Desc) {

	var tim = new Date().valueOf();

	URL += "?FieldName=" + FieldName
	URL += "&Description=" + Desc
	URL += "&wsrndnum=" + Math.random()
        URL += "&wsrndtme=" + tim
	LookupWinHdl = window.open(URL,"LookupWindow","width=700,height=500,scrollbars=yes,resizable")
	LookupWinHdl.focus()

}

function CloseLookupWindow () {

	if (LookupWinHdl == null)
	        return
	
	if (LookupWinHdl.closed)
	        return
	
    	LookupWinHdl.close()
}

function HelpWindow(HelpPageURL) {
	
	HlpWinHdl = window.open(HelpPageURL,"HelpWindow","width=700,height=500,scrollbars=yes,resizable")
	HlpWinHdl.focus()

}

function CloseHelpWindow () {

	if (HlpWinHdl == null)
	        return
	
	if (HlpWinHdl.closed)
	        return
	
    	HlpWinHdl.close()
}


function PopUpWindow(HelpPageURL) {
	
	PopUpWinHdl = window.open(HelpPageURL,"PopupWindow","width=700,height=500,scrollbars=yes,resizable")
	PopUpWinHdl.focus()

}

function ClosePopUpWindow () {

	if (PopUpWinHdl == null)
	        return
	
	if (PopUpWinHdl.closed)
	        return
	
    	PopUpWinHdl.close()
}

function OpenNewWindow(URL) {
	var WindowHdl = null
	WindowHdl = window.open(URL,"NewWindow","width=600,height=400,menubar=yes,statusbar=yes,scrollbars=yes,resizable")
	WindowHdl.focus()
	
}

function RepWindow(HelpPageURL) {
	
	RepWinHdl = window.open(HelpPageURL,"ReportWindow","width=700,height=500,scrollbars=yes,resizable")
	RepWinHdl.focus()

}

function CloseRepWindow () {

	if (RepWinHdl == null)
	        return
	
	if (RepWinHdl.closed)
	        return
	
    	RepWinHdl.close()
}

function SubmitThePage(SubmitValue) {
	var FieldName = "submitsource"
	document.mainform.elements[FieldName].value = SubmitValue
	document.mainform.submit()
	
}

function ahahBegin(target) {

   if ( document.getElementById(target).innerHTML == "" ) 
   {
   	document.getElementById(target).innerHTML = '<img src="/images/ajax/load.gif" border=0">'
   }	
       
}

function ahah(url,target) {
// native XMLHttpRequest object
   var RandomTime = new Date().valueOf()
   url = url + "&RandMath=" + Math.random()
   url = url + "&RandomTime=" + RandomTime
   ahahBegin(target)
   if (window.XMLHttpRequest) {
       req = new XMLHttpRequest();
       req.onreadystatechange = function() {ahahDone(target);};
       req.open("GET", url, true);
       req.send(null);
   // IE/Windows ActiveX version
   } else if (window.ActiveXObject) {
       req = new ActiveXObject("Microsoft.XMLHTTP");
       if (req) {
           req.onreadystatechange = function() {ahahDone(target);};
           req.open("GET", url, true);
           req.send();
       }
   }
}

function ahahPost(url,target) {
// native XMLHttpRequest object

if (window.XMLHttpRequest) {
       req = new XMLHttpRequest();
       req.onreadystatechange = function() {ahahDone(target);};
       req.open("POST", url, true);
       req.send(null);
   // IE/Windows ActiveX version
   } else if (window.ActiveXObject) {
       req = new ActiveXObject("Microsoft.XMLHTTP");
       if (req) {
           req.onreadystatechange = function() {ahahDone(target);};
           req.open("POST", url, true);
           req.send();
       }
   }
}

function ahahDone(target) {
   // only if req is "loaded"
   if (req.readyState == 4) {
       // only if "OK"
       if (req.status == 200 || req.status == 304) {
           results = req.responseText;
           document.getElementById(target).innerHTML = results;
       } else {
           document.getElementById(target).innerHTML = "";
       }
   }
}

var objRowSelected = null
var objRowInit = false
var objRowDefault = null

function rowInit () {
	
	if ( objRowInit ) {
		return
	}
	objRowInit = true
	
	var objtoolBarOption = document.getElementById("tboption")
	
	objRowDefault = objtoolBarOption.innerHTML
	
		
	return

}
function rowSelect (rowObject, rowToolIDName) {


	var objRowToolBar = document.getElementById(rowToolIDName)
	var objtoolBarOption = document.getElementById("tboption")
	
	rowInit()
		
	if ( objRowSelected != null ) {
		objRowSelected.className = "tabrow1"
	}
	
	if ( objRowSelected == rowObject ) {
		objRowSelected = null
		rowObject.className = "tabrow1"
		// Was space
		objtoolBarOption.innerHTML = objRowDefault
		
		return
	}
	
	rowObject.className = "tabrowselected"
	objRowSelected = rowObject
				
	objtoolBarOption.innerHTML = objRowToolBar.innerHTML
	
	
}

function rowOver (rowObject) {

	if ( objRowSelected != rowObject ) {
		rowObject.className = "tabrowover"
		return
	}
	rowObject.className = "tabrowselected" 
}

function rowOut (rowObject) {

	if ( objRowSelected != rowObject ) {
		rowObject.className = "tabrow1"
		return
	}
	rowObject.className = "tabrowselected"

}

function AjaxSimpleDescription ( formField, AppURL , CompanyCode, FieldType, ObjectName ) {

	var fieldContent = escape(formField.value)
		
	var AjaxURL = AppURL
	AjaxURL += "/lib/ajaxsimplevalidate.p?simple=yes"
	AjaxURL += "&value=" + fieldContent
	AjaxURL += "&type=" + FieldType
	AjaxURL += "&companycode=" + CompanyCode
	
	ahah(AjaxURL,ObjectName)
	
	
	
}

function GrowOver (rowObject) {

	
	rowObject.className = "overbargraph" 
}

function GrowOut (rowObject) {

	
	rowObject.className = "bargraph"

}