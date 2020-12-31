/*! * auxiliarJS Library v1 * auxiliar javascript code * Author: Victor
Pablos Ceruelo */ /*
----------------------------------------------------------------------------------------------------------------
*/ /*
----------------------------------------------------------------------------------------------------------------
*/ /*
----------------------------------------------------------------------------------------------------------------
*/

<%@page import="constants.KConstants"%>
<%@page import="auxiliar.JspsUtils"%>

<% if (JspsUtils.getStringWithValueS().equals("N")) { %>
<script type="text/javascript">
<% } %>

/* ---------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------- */


// Sort the array of answers.
function arraySortFunction(elt1, elt2) {
	console.info(elt1);
	console.info(elt2);
	// Info:
    // return -1: Sort "a" to be a lower index than "b"
	// return 0: "a" and "b" should be considered equal, and no sorting performed.
	// return +1: Sort "b" to be a lower index than "a".
	if (elt1[elt1.length -1] == "Truth Value") return -1;
	if (elt2[elt2.length -1] == "Truth Value") return +1;
	var elt1float = parseFloat(elt1[elt1.length -1]);
	var elt2float = parseFloat(elt2[elt2.length -1]);
	
	if (elt1float >  elt2float) return -1;
	if (elt1float == elt2float) return 0;
	if (elt1float <  elt2float) return +1;
}

function truncate_truth_value (truth_value) {
	if (truth_value == "Truth Value") return truth_value;
	
	var newValue = parseFloat(truth_value);
	if ((newValue != null) && (newValue != undefined) && (newValue != NaN) && (newValue != "Truth Value")) {
		return newValue.toFixed(2);
	} 
	else {
		return truth_value;
	}
}

function resultOver(value, answer) {
	if ((answer == null) || (answer == undefined)) return false;
	var realValue = answer[answer.length -1];
	if ((realValue == null) || (realValue == undefined)) return false;
	if (realValue == "Truth Value") return true;
	return (parseFloat(realValue) > value);
}

function prologNameInColloquialLanguage(textLabelIn) {
	var textLabel = null;
	
	if ((textLabelIn == null) || (textLabelIn == undefined)) {
		alert("prologNameInColloquialLanguage: null or undefined input.");
		return null;
	}
	if (! isString(textLabelIn)) {
		alert("prologNameInColloquialLanguage: input is not a string.");
		return null;		
	}
	
	// debug.info("textLabel: " + textLabelIn);
	var i = textLabelIn.indexOf("_");
	while (i != -1) {
		textLabel = ""; //Initialize
		textLabel += textLabelIn.substring(0, i);
		textLabel += " ";
		textLabel += textLabelIn.substring(i+1, textLabelIn.length);
		// debug.info(textLabel);
		i = textLabel.indexOf("_");
		textLabelIn = textLabel;
	}
	textLabel = textLabelIn;
	return textLabel;
}

/* ---------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------- */

var answersIndexes = null;

function infoForQueryAnswers (tableName, queryAnswerIndex) {
	this.tableName = tableName;
	this.queryAnswersIndexes = new Array();
	if ((queryAnswerIndex != null) && (queryAnswerIndex != undefined)) {
		this.queryAnswersIndexes[0] = queryAnswerIndex;
	}
}

function insertInfoForQueryAnswers (tableName, queryAnswerIndex) {
	if (answersIndexes == null) {
		answersIndexes = new Array();
	}
	
	var i = 0;
	var found = false;
	while ((i < answersIndexes.length) && (! found)) {
		if (tableName == answersIndexes[i].tableName) {
			found = true;
		}
		else i++;
	}
	
	if (! found) {
		answersIndexes[answersIndexes.length] = new infoForQueryAnswers(tableName, queryAnswerIndex);
	}
	else {
		if ((queryAnswerIndex != null) && (queryAnswerIndex != undefined)) {
			answersIndexes[i].queryAnswersIndexes[answersIndexes[i].queryAnswersIndexes.length] = queryAnswerIndex;
		}
	}
}


var queryAnswersOver70 = null;
var queryAnswersOver50 = null;
var queryAnswersOver0 = null;
function showAnswers(runQueryDivId, answers) {
	var runQueryDiv = getContainer(runQueryDivId);
	if ((runQueryDiv == null) || (runQueryDiv == undefined)) {
		debug.info("ERROR: runQueryDiv is null or undefined.");
		alert("ERROR: runQueryDiv is null or undefined.");
		return;
	}
		
	if ((answers == null) || (answers.length <= 1)) {
		runQueryDiv.innerHTML = "The query has no answers.";
		return;
	}
	
	// alert("answers.length" + answers.length);
	answers.sort(arraySortFunction);

	var best10answersName = "10 best results";
	var answersOver70Name = "Results over 70%";
	var answersOver50Name = "Results over 50%";
	var answersOver0Name  = "Results over 0%";
	var allAnswers        = "All results";
	
	// Initialize multiDimensional array.
	answersIndexes = null;

	// Initialize to keep the final order.
	insertInfoForQueryAnswers(best10answersName, null);
	insertInfoForQueryAnswers(answersOver70Name, null);
	insertInfoForQueryAnswers(answersOver50Name, null);
	insertInfoForQueryAnswers(answersOver0Name, null);
	insertInfoForQueryAnswers(allAnswers, null);
	
	for (var i=0; i<answers.length; i++) {
		var answer = answers[i];
		if ((i <= 10) && (resultOver(0, answer))) insertInfoForQueryAnswers(best10answersName, i);
		if (resultOver(0.7, answer)) insertInfoForQueryAnswers(answersOver70Name, i);
		if (resultOver(0.5, answer)) insertInfoForQueryAnswers(answersOver50Name, i);
		if (resultOver(0, answer)) insertInfoForQueryAnswers(answersOver0Name, i);
		insertInfoForQueryAnswers(allAnswers, i);
	}
	
	runQueryDiv.innerHTML = "";

	var tabsDiv = document.createElement('div');
	tabsDiv.id = "tabs";
	runQueryDiv.appendChild(tabsDiv);
	var tabsDivList = document.createElement('ul');
	tabsDivList.id = "resultTab";
	tabsDivList.className = "nav nav-tabs";
	tabsDivList.setAttribute("role", "tablist");
	tabsDiv.appendChild(tabsDivList);
	
	var html = null;
	var i = null;
	var j = null;
	var k = null;
	var tabDiv = null;
	var tabContentDiv = null;
	var row = null;
	var cell = null;
		
	html = "";
	j = 1;
	for (i=0; i<answersIndexes.length; i++) {
		// The first answer is information about the database fields.
		if (answersIndexes[i].queryAnswersIndexes.length > 1) {
			var activeNav = "", ariaSelected = "false";
			if(i==0) { activeNav = "active bg-dark text-white"; ariaSelected = "true";}
			html += "<li class='nav-item' role='presentation'><a class='nav-link "+activeNav+"' id='tabNav-"+j+"' data-toggle='tab' href='#tabs-"+j+"' role='tab'  aria-controls='tabs-"+j+"'"
				+ " aria-selected='"+ariaSelected+"'>"+answersIndexes[i].tableName+"</a></li>";
			j++;
		}
	}
	tabsDivList.innerHTML = html;
		
	html = "";
	j = 1;
	tabContentDiv = document.createElement('div');
	tabContentDiv.className = "tab-content";
	tabsDiv.appendChild(tabContentDiv);
	for (i=0; i<answersIndexes.length; i++) {
		// The first answer is information about the database fields.
		if (answersIndexes[i].queryAnswersIndexes.length > 1) {
			tabPaneDiv = document.createElement('div');
			tabPaneDiv.id = "tabs-" + j;
			if(i==0) tabPaneDiv.className = "tab-pane fade show active";
			else tabPaneDiv.className = "tab-pane fade";
			tabPaneDiv.setAttribute("role", "tabpanel");
			tabPaneDiv.setAttribute("aria-labelledby", "tabs-" + j);
			j++;
			tabContentDiv.appendChild(tabPaneDiv);

			// Now insert each answer in a row, inside the table
			table = document.createElement('table');
			table.className = "table table-dark";
			/* thead = document.createElement('thead');
			table.appendChild(thead);
			tr_head = document.createElement('tr');
			thead.appendChild(tr_head);
			th = document.createElement('th');
			th.setAttribute("scope","col");
			tr_head.appendChild(th); */
			tbody = document.createElement('tbody');
			table.appendChild(tbody);
			var answersTitles = answers[0];
			for (k=0; k<answersIndexes[i].queryAnswersIndexes.length; k++) {
				tr_body = document.createElement('tr');
				tbody.appendChild(tr_body);
				var answer = answers[answersIndexes[i].queryAnswersIndexes[k]];
				for (var l=1; l<answer.length; l++) {
					td = document.createElement('td');
					tr_body.appendChild(td);
					td.innerHTML = showCellAnswer(k, l, answer.length, answersTitles, answer[l]);
				}
			}
			tabPaneDiv.appendChild(table);
		}
	}
	
	// Enable tabs
	//$( "#tabs" ).tabs();
	
	$('#resultTab a').on('click', function (e) {
	  e.preventDefault();
	  $(this).tab('show');
	  $('#resultTab a.bg-dark').removeClass("bg-dark").removeClass("text-white");
	  $(this).addClass("bg-dark text-white");
	});
	$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){
        e.target // active tab
        e.relatedTarget // previous tab
    });

}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function showCellAnswer(currentRow, currentColumn, columnsLength, answersTitles, answer) {
	if ((currentRow != 0) && (currentColumn == 1)) {
		return buildIndexAnswer(currentRow, answer);
	}
	else {
		if (currentColumn+1 > columnsLength) {
			return truncate_truth_value(answer);
		}
		else {
			if (answersTitles[currentColumn] == 'url') {
				return buildUrlAnswer(answer);	
			}
			else {
				return prologNameInColloquialLanguage(answer);
			}
		}
	}
}

function buildIndexAnswer(currentRow, answer) {
	// title='" + answer + "'
	// alt='Database entry: " + answer + "'
	return "<a href='#' class='resultRowNum' onclick='return false;' title='Database entry: " + answer + "'> nº." + currentRow + "</a>";
}

function buildUrlAnswer(answer) {
	return "<a href='#' class='resultRowNum' onclick='openUrlInNewTab(" + answer + ")' title='view " + answer + "'>view</a>";
}


/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function debugQueryAnswers(parentDivId) {
	var parentDiv = document.getElementById(parentDivId);
	var debugDiv = document.createElement('div');
	debugDiv.className = "debugTable";
	parentDiv.appendChild(debugDiv);
	var rowDiv = null;
	var cellDiv = null;
	
	for (var i=0; i<queryAnswers.length; i++) {
		rowDiv = document.createElement('div');
		rowDiv.className = "debugTableRow";
		debugDiv.appendChild(rowDiv);
		
		for (var j=0; j < queryAnswers[i].length; j++) {
			cellDiv = document.createElement('div');
			cellDiv.className = "debugTableCell";
			rowDiv.appendChild(cellDiv);
			
			cellDiv.innerHTML = queryAnswers[i][j];
		}
	}
}


// EOF

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

<% if (JspsUtils.getStringWithValueS().equals("N")) { %>
</script>
<% } %>


