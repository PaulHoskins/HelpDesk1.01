
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
function ganttBuild () {
	//alert ("paul here = " + ganttURL);
	$.get(ganttURL, function(data, status){
        //alert("Data: " + data + "\nStatus: " + status);
        jQuery.globalEval( data );
        gantt.config.row_height = 24;
	gantt.config.min_column_width = 50;
	gantt.templates.scale_cell_class = function(date){
		if(date.getDay()==0||date.getDay()==6){
			return "weekend";
		}
	};
	gantt.templates.task_cell_class = function(item,date){
		if(date.getDay()==0||date.getDay()==6){
			return "weekend" ;
		}
	};

	gantt.config.columns = [
		{name:"text", label:"Task name", width:"*", tree:true },
		{name:"start_time", label:"Start time", template:function(obj){
			return gantt.templates.date_grid(obj.start_date);
		}, align: "center", width:60 },
		{name:"duration", label:"Duration", align:"center", width:60},
		{name:"add", label:"", width:44 }
	];

	gantt.config.grid_width = 390;
	gantt.config.date_grid = "%F %d";
	gantt.config.scale_height  = 60;
	gantt.config.subscales = [
		{ unit:"week", step:1, date:"Week #%W"}
	];


	(function(){
		gantt.config.font_width_ratio = 7;
		gantt.templates.leftside_text = function leftSideTextTemplate(start, end, task) {
			if (getTaskFitValue(task) === "left") {
				return task.text;
			}
			return "";
		};
		gantt.templates.rightside_text = function rightSideTextTemplate(start, end, task) {
			if (getTaskFitValue(task) === "right") {
				return task.text;
			}
			return "";
		};
		gantt.templates.task_text = function taskTextTemplate(start, end, task){
			if (getTaskFitValue(task) === "center") {
				return task.text;
			}
			return "";
		};

		function getTaskFitValue(task){
			var taskStartPos = gantt.posFromDate(task.start_date),
				taskEndPos = gantt.posFromDate(task.end_date);

			var width = taskEndPos - taskStartPos;
			var textWidth = (task.text || "").length * gantt.config.font_width_ratio;

			if(width < textWidth){
				var ganttLastDate = gantt.getState().max_date;
				var ganttEndPos = gantt.posFromDate(ganttLastDate);
				if(ganttEndPos - taskEndPos < textWidth){
					return "left"
				}
				else {
					return "right"
				}
			}
			else {
				return "center";
			}
		}
	})();

        gantt.init("gantt_here");
        gantt.parse(tasks);
        //alert ("all done");

        
    });

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
    		if ( i == 6 ) {
    			ganttBuild()
    			return

    		}

	}
};