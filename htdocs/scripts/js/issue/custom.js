
function noteTableBuild () {
	ahah(NoteAjax,'IDNoteAjax')
}
function noteAdd () {
	PopUpWindow(NoteAddURL)
}
function noteCreated () {
	noteTableBuild()
}

function customerInfo () {
	ahah(CustomerAjax,'IDCustomerAjax')
}

function documentTableBuild () {
	ahah(DocumentAjax,'IDDocument')
}
function documentAdd () {
	PopUpWindow(DocumentAddURL)
}
function documentCreated () {
	documentTableBuild()
	ClosePopUpWindow()
}
function actionTableBuild () {
	ahah(ActionAjax,'IDAction')
}
function actionCreated () {
	actionTableBuild()
	ClosePopUpWindow()
}
function mainPageBuild () {
	var FieldName = "currentstatus"
	var pvalue =  document.mainform.elements[FieldName].value
	var callURL = ''
	callURL = ActionBox1URL
	callURL += "&currentstatus=" + pvalue
	ahah(callURL,'actionbox1')
}


var tabberOptions = {
	'onClick':function(argsObj) {
		var t = argsObj.tabber; /* Tabber object */
		var i = argsObj.index; /* Which tab was clicked (0..n) */
    		var div = this.tabs[i].div; /* The tab content div */

    		if ( i == 0 ) {
				mainPageBuild()
			}
    		if ( i == 1 ) {
    			actionTableBuild()
    			return
    		}
    		if ( i == 2 ) {	/* Notes */
			noteTableBuild()
			return
    		}
    		if ( i == 3 ) {
			documentTableBuild()
    		}
    		if ( i == 5 ) {
    			customerInfo()
    			return
    		}

	}
};