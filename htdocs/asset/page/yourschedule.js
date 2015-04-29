/*
	phoski 02/04/2015 initial
*/


function drawSchedule () {

	//scheduler.config.readonly_form = true;
	//scheduler.config.readonly = true;
	scheduler.locale.labels.year_tab ="Year";
	scheduler.config.year_x = 2; //2 months in a row
	scheduler.config.year_y = 6; //3 months in a column
	scheduler.init('scheduler_here', new Date(),"month");
	scheduler.parse(events, "json");
	
}