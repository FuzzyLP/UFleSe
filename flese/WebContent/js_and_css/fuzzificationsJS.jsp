/*! * auxiliarJS Library v1 * auxiliar javascript code * Author: Victor
Pablos Ceruelo */ /*
----------------------------------------------------------------------------------------------------------------
*/ /*
----------------------------------------------------------------------------------------------------------------
*/ /*
----------------------------------------------------------------------------------------------------------------
*/

<%@page import="constants.KConstants.Fuzzifications"%>
<%@page import="constants.KUrls"%>
<%@page import="constants.KConstants"%>
<%@page import="auxiliar.JspsUtils"%>

<% if (JspsUtils.getStringWithValueS().equals("N")) { %>
<script type="text/javascript">
<% } %>

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

$(function() {
    if (sessionStorage.reloadAfterPageLoad) {
        sessionStorage.reloadAfterPageLoad = false;
    	$("#userOptions").trigger("click");
    }
}); 

var similarityExist = false;

var fuzzificationFunction = null;

var validation = {validate:false, msg:""};

var modifyFuzzification = false;

function fuzzificationPoints (predOwner, predOwnerHumanized, functionPoints) {
	this.predOwner = predOwner;
	this.name = predOwnerHumanized;
	this.data = functionPoints;
	this.modified = false;
	return this;
}

function fuzzificationFunctionConstructor(predDefined, predNecessary, functionFormat, modifiable, msgTop, msgBottom, fuzzificationPoints) {
	this.predDefined = predDefined;
	this.predNecessary = predNecessary;
	this.functionFormat = functionFormat;
	this.modifiable = modifiable;
	this.msgTop = msgTop;
	this.msgBottom = msgBottom;
	this.fuzzificationPoints = fuzzificationPoints; // ownersPersonalizations
}

function setFuzzificationFunction (predDefined, predNecessary, functionFormat, modifiable, msgTop, msgBottom, fuzzificationPoints) {
	fuzzificationFunction = new fuzzificationFunctionConstructor(predDefined, predNecessary, functionFormat, modifiable, msgTop, msgBottom, fuzzificationPoints);
}

function indexOfMyPersonalizedFunction() {
	var i = fuzzificationFunction.modifiable;
	
	if (i < fuzzificationFunction.fuzzificationPoints.length) {
		return i;
	}
	
	debug.info("IndexOfMyPersonalizedFunction: i < 0");
	return -1;
	
}

function pointCreated(newX, fuzzificationGraphicDivId, newBar, newSpan, table, fuzzificationBarDivId) //function to add a rupture point in the function and create another empty row
{
	var i = indexOfMyPersonalizedFunction();
	var newPoints = new Array(fuzzificationFunction.fuzzificationPoints[i].data.length+1);
	var j;
	var k;
	for(j=0,k=0;j<fuzzificationFunction.fuzzificationPoints[i].data.length+1;j++, k++)
	{
		if ((k == fuzzificationFunction.fuzzificationPoints[i].data.length && fuzzificationFunction.fuzzificationPoints[i].data[k-1][0] < newX.value) || (k>0 && fuzzificationFunction.fuzzificationPoints[i].data[k-1][0] < newX.value && fuzzificationFunction.fuzzificationPoints[i].data[k][0] > newX.value) || (k == 0 && fuzzificationFunction.fuzzificationPoints[i].data[k][0] > newX.value))   
		{
			newPoints[j]=[newX.value, 0];
			j++;
		}
		if (j < fuzzificationFunction.fuzzificationPoints[i].data.length+1)
			newPoints[j] = fuzzificationFunction.fuzzificationPoints[i].data[k];
	}
	fuzzificationFunction.fuzzificationPoints[i].data = newPoints;
	fuzzificationFunction.fuzzificationPoints[i].modified=true;
	
	// Display in the graphic the result.
	insertFuzzificationGraphicRepresentation(fuzzificationGraphicDivId);
	
	var barContainer = getContainer(newBar);
	var spanContainer = getContainer(newSpan);
	var tableContainer = getContainer(table);

	barContainer.innerHTML = "";
	spanContainer.innerHTML = "";
	
	var hid = document.createElement("input");
	hid.setAttribute("type","hidden");
	hid.setAttribute("name", "fuzzificationBars["+fuzzificationFunction.fuzzificationPoints[i].data.length+ "].fpx");
	hid.setAttribute("value",""+newX.value);

	
	var bar = document.createElement("input");
	bar.setAttribute("type","range");
	bar.setAttribute("name", "fuzzificationBars["+fuzzificationFunction.fuzzificationPoints[i].data.length+ "].fpy");
	bar.setAttribute("min","0");
	bar.setAttribute("max","1");
	bar.setAttribute("step","0.01");
	
	bar.setAttribute("value","0");
	bar.setAttribute("width","150px");
	bar.setAttribute("onchange","barValueChanged(this, '"+ fuzzificationBarDivId + "["+fuzzificationFunction.fuzzificationPoints[i].data.length + "]' , '"+newX.value+"', '"+fuzzificationGraphicDivId+"');");
	
	barContainer.appendChild(hid);
	barContainer.appendChild(bar);
	barContainer.setAttribute("id","");
	barContainer.setAttribute("class","personalizationDivFuzzificationFunctionValuesTableCell");
	
	spanContainer.setAttribute("id",fuzzificationBarDivId + "["+fuzzificationFunction.fuzzificationPoints[i].data.length + "]");
	
	newX.setAttribute("onchange","pointChanged('"+newX.value+"','this,'"+fuzzificationBarDivId+"["+fuzzificationFunction.fuzzificationPoints[i].data.length + "]', fuzzificationBars["+fuzzificationFunction.fuzzificationPoints[i].data.length+"]','"+fuzzificationGraphicDivId+"');");
	
	var span = document.createElement("span");
	span.setAttribute("id",fuzzificationBarDivId + "["+fuzzificationFunction.fuzzificationPoints[i].data.length + "]" );
	spanContainer.appendChild(span);
	spanContainer.appendChild(document.createTextNode(""+0));
	
	var row = document.createElement("div");
	row.setAttribute("class", "personalizationDivFuzzificationFunctionValuesTableRow");
	var xCell = document.createElement("div");
	xCell.setAttribute("class", "personalizationDivFuzzificationFunctionValuesTableCell");
	var xInput = document.createElement("input");
	xInput.setAttribute("type","number");
	xInput.setAttribute("value","");
	xInput.setAttribute("onchange","pointCreated(this, '"+fuzzificationGraphicDivId +"','newBar','newSpan','table', '"+fuzzificationBarDivId+"');");
	var barDiv = document.createElement("div");
	barDiv.setAttribute("class","personalizationDivFuzzificationFunctionValuesTableCell");
	barDiv.setAttribute("id","newBar");
	var spanDiv = document.createElement("div");
	spanDiv.setAttribute("class","personalizationDivFuzzificationFunctionValuesTableCell");
	var spanInput = document.createElement("div");
	spanInput.setAttribute("id","newSpan");
	var cell = document.createElement("div");
	cell.setAttribute("class","personalizationDivFuzzificationFunctionValuesTableCell");
	
	xCell.appendChild(xInput);
	spanDiv.appendChild(spanInput);
	cell.appendChild(document.createTextNode(""+-1));
	spanInput.appendChild(document.createTextNode(""+-1));
	row.appendChild(xCell);
	row.appendChild(barDiv);
	row.appendChild(spanDiv);
	row.appendChild(cell);
	
	tableContainer.appendChild(row);
	
	
}

function pointChanged(oldPoint, newPoint, fuzzificationBarDivName,fuzzificationBarDivId, fuzzificationGraphicDivId) //function to modify the X component of the fuzzy points
{
	var i = indexOfMyPersonalizedFunction();

	if (i >= 0) {
		var j=0; 
		var found = false;
		
		while ((j < fuzzificationFunction.fuzzificationPoints[i].data.length) && (! found)) {
			if (fuzzificationFunction.fuzzificationPoints[i].data[j][0] == oldPoint) {
				fuzzificationFunction.fuzzificationPoints[i].data[j][0] = newPoint.value;
				fuzzificationFunction.fuzzificationPoints[i].modified = true;
				found = true;
			}
			else {
				j++;
			}
		}
		if (! found) {
			debug.info("changeFuzzificationPointValue: not found");
		}
	}
	else {
		debug.info("changeFuzzificationPointValue: not found");
	}
	
	hid = document.getElementByName(fuzzificationBarDivName + ".fpx");
	bar = document.getElementByName(fuzzificationBarDivName + ".fpy");
	hid.setAttribute("value", ""+newX.value);
	bar.setAttribute("onchange", "barValueChanged(this, '"+fuzzificationBarDivId+"', '"+newX+"', '"+fuzzificationGraphicDivId+"');");

	// Display in the graphic the result.
	insertFuzzificationGraphicRepresentation(fuzzificationGraphicDivId);
	
}

function changeFuzzificationPointValue(fpx, valueFloat) {
	var i = indexOfMyPersonalizedFunction();

	if (i >= 0) {
		var j=0; 
		var found = false;
		
		while ((j < fuzzificationFunction.fuzzificationPoints[i].data.length) && (! found)) {
			if (fuzzificationFunction.fuzzificationPoints[i].data[j][0] == fpx) {
				fuzzificationFunction.fuzzificationPoints[i].data[j][1] = valueFloat;
				fuzzificationFunction.fuzzificationPoints[i].modified = true;
				found = true;
			}
			else {
				j++;
			}
		}
		if (! found) {
			debug.info("changeFuzzificationPointValue: not found");
		}
	}
	else {
		debug.info("changeFuzzificationPointValue: not found");
	}
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function barValueChanged(barObject, fuzzificationBarDivId, fpx, fuzzificationGraphicDivId) {
	
	debug.info("barValueChanged");
	
	if ((barObject == null) || (barObject == undefined)) {
		debug.info("barObject is null or undefined in barValueChanged.");
		return;
	}
	
	var valueOriginal=barObject.value;
	if  ((valueOriginal == null) || (valueOriginal == undefined) || (isNaN(valueOriginal))) {
		alert("Erroneous value. I'll reset to 0.");
		barObject.value = 0;
		valueOriginal = 0;
		return;
	}
	
	var valueFloat = parseFloat(valueOriginal);
	var valueToShow = 0;
	
	if ((valueFloat != null) && (valueFloat != undefined) && (! isNaN(valueFloat))) {
		valueToShow = valueFloat.toFixed(2);
	}
	else {
		valueFloat = 0;
		valueToShow = 0;
	}
		
	// Modify the stored value 
	changeFuzzificationPointValue(fpx, valueFloat);

	// Show value in the div.
	var fuzzificationBarDiv = getContainer(fuzzificationBarDivId);
	fuzzificationBarDiv.innerHTML = valueToShow;

	// Display in the graphic the result.
	insertFuzzificationGraphicRepresentation(fuzzificationGraphicDivId);
}


/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function insertFuzzificationGraphicRepresentation(fuzzificationGraphicDivId) {
	
	var div = document.getElementById(fuzzificationGraphicDivId);
	if ((div != null) && (div != undefined)) {
		div.innerHTML = ""; // Re-initialize
	
		var container = document.createElement('div');
		container.id = fuzzificationGraphicDivId + "Container";
		container.style.width= "50em"; 
		container.style.height= "15em";
		container.style.margin= "2em";
		container.style['text-align'] = "center";
		container.style['align'] = "center";
		div.appendChild(container);
	
		// alert("insertFuzzificationGraphicRepresentation not implemented yet !!!");
		drawChart(container.id, null, null);
	}
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

// var charts = new Array(); // globally available
var chart = null;

function drawChart(divIdentifier, width, height) {
	
	if ((fuzzificationFunction != null) && (fuzzificationFunction.fuzzificationPoints != null)) {

		var minValue = null;
		var maxValue = null;
		var currentValue = 0;
		for (var i=0; i<fuzzificationFunction.fuzzificationPoints.length; i++) {
			for (var j=0; j<fuzzificationFunction.fuzzificationPoints[i].data.length; j++) {
				currentValue = fuzzificationFunction.fuzzificationPoints[i].data[j][0];
				if ((minValue == null) || (minValue > currentValue)) {
					minValue = currentValue;
				}
				if ((maxValue == null) || (maxValue < currentValue)) {
					maxValue = currentValue;
				}
			}
		}
		
		var extension = (maxValue - minValue) * (10 / 100);
		if (! (minValue == 0)) {
			minValue = minValue - extension;
		}
		maxValue = maxValue + extension;
		
		//Start chart line from 0 or 1
		var newMinValue = 0;
		var newSeries = [];
		var fuzzificationPointsData = [];
		if(fuzzificationFunction.functionFormat == "decreasing") {
			newMinValue = 1;
			var tmp = $("div.valToEdit input#valueOf0").val();
			$("div.valToEdit input#valueOf0").val($("div.valToEdit input#valueOf1").val());
			$("div.valToEdit input#valueOf1").val(tmp);
		}
		$.each(fuzzificationFunction.fuzzificationPoints, function(i, fuzzificationPoint) {
			var seriesPoints = {};
			if(fuzzificationPoint.data.length > 0) { // && fuzzificationPoint.data[0][0] !== 0
				fuzzificationPointsData[0] = [newMinValue, newMinValue];
				for(var j=0;j<fuzzificationPoint.data.length;j++) {
					if(fuzzificationFunction.functionFormat == "decreasing") {
						fuzzificationPointsData[1] = [fuzzificationPoint.data[0][0], null];
						fuzzificationPointsData[2] = [fuzzificationPoint.data[1][0], null];
						fuzzificationPointsData[1][1] = fuzzificationPoint.data[0][1];
						fuzzificationPointsData[2][1] = fuzzificationPoint.data[1][1];
					} else 
						fuzzificationPointsData[j+1] = fuzzificationPoint.data[j];
				}
				if(fuzzificationPointsData.length > 0) {
					seriesPoints.data = fuzzificationPointsData;
					seriesPoints.modified = fuzzificationPoint.modified;
					seriesPoints.name = fuzzificationPoint.name;
					seriesPoints.predOwner = fuzzificationPoint.predOwner;
					newSeries.push(seriesPoints);
				}
			}
		});
		$.each(newSeries, function(i, serie) {
			var a = serie.data[0][0];
			var b = serie.data[1][0];
			var dif = parseFloat(b) - parseFloat(a);
			var newPx = parseFloat(serie.data[serie.data.length-1][0]) + dif;
			var newPy = 0;
			if(fuzzificationFunction.functionFormat == "increasing")
				newPy = 1;
			serie.data.push([newPx, newPy]);
		});
		/* $.each(newSeries, function(i, serie) {
			serie.data.splice(serie.data.length-1,1);
		}); */
		if(newSeries.length == 0) {
			newSeries = fuzzificationFunction.fuzzificationPoints;
		}
		var xAxisLAbelPoint = [];
		for(var i=1;i<newSeries[0]["data"].length-2;i++) {
			xAxisLAbelPoint.push(newSeries[0]["data"][i][0]);
		}
		chart = newHighCHarts(newMinValue,maxValue,fuzzificationFunction,width,height,divIdentifier,xAxisLAbelPoint,newSeries,null);
		console.warn(chart.xAxis[0].tickPositions);
		var isMatched = true;
		$.each(xAxisLAbelPoint, function(i, val) {
			if($.inArray(val, chart.xAxis[0].tickPositions) == -1) {
				isMatched = false;
				chart.xAxis[0].tickPositions.push(val);
			}
		});
		if(!isMatched) {
		  	customTickPositions = chart.xAxis[0].tickPositions.sort(function(a, b){return a-b});
		  	chart = null;
		  	console.warn(customTickPositions);
		  	chart = newHighCHarts(newMinValue,maxValue,fuzzificationFunction,width,height,divIdentifier,xAxisLAbelPoint,newSeries,customTickPositions);
		}
	}
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function newHighCHarts(newMinValue,maxValue,fuzzificationFunction,width,height,divIdentifier,xAxisLAbelPoint,newSeries,customTickPositions) {
	var xAxis = {
			title: { text: fuzzificationFunction.msgBottom },
			min: newMinValue, //minValue
			max: maxValue,
	        labels: {
	            formatter: function () {
	            	if($.inArray(this.value, xAxisLAbelPoint) != -1) {
	           			return this.value + "<br> V" + ($.inArray(this.value, xAxisLAbelPoint) + 1);
	           		} else {
	           			return this.value;
	           		}
	            }
	        }
        };
	if(customTickPositions) {
		xAxis["tickPositions"] = customTickPositions;
	}
	return new Highcharts.Chart({
        chart: {
	        renderTo: divIdentifier,
   	    type: 'line', //,
   	    width: width,
   	    height: height
/*		style: { margin: '0 auto' } */
        },
        title: { text: fuzzificationFunction.msgTop },
        xAxis: xAxis,
        yAxis: {
			title: { text: 'Truth value' },
			min: 0,
			max: 1
	     },
/*	    	     navigator: { height: 30, width: 40 }, center: [60, 45], size: 50, */
   	 	series: newSeries
     });
}

/* 
 *----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function personalizeProgramFile(url, params, fileName, firstTabTitle) {
	var containerId = '<%=KConstants.JspsDivsIds.auxAndInvisibleSection %>';
	
	loadAjaxInDialog(containerId, url + params, 'Personalize program file ' + fileName, function() {
		$("div.tab button#defaultOpen").html(firstTabTitle);
		$("div.tabcontent div.customLabel").html(firstTabTitle+" ");
	});
	
	//prevent the browser to follow the link
	return false;
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function fuzzificationFunctionNameInColloquial(currentName, grade) {
	var result = null;
	if ((currentName != null) && (currentName != "") && (currentName != "----")) {
	
		var i = currentName.indexOf("(");
		var j = currentName.indexOf(")");
		
		if ((i != -1) && (j != -1)){
			result = "";
			if ((grade == 'all') || (grade == 'subject')) {
				result += currentName.substring(i+"(".length, j);
			}
			if (grade == 'all') {
				result += " is ";
			}
			if ((grade == 'all') || (grade == 'adjective')) {
				result += currentName.substring(0, i);
			}
		}
	}
	
	if ((result == null) && (currentName != null)) return currentName;
	else return prologNameInColloquialLanguage(result);
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function personalizationFunctionChanged(comboBox, PersonalizationFunctionUnderModificationDivId, urlEdit, urlNew, urlDefine, urlAdd, urlSynAnt, urlFuzzyRule, urlUpdate) {
	
	var params = getComboBoxValue(comboBox);
	if (params != "") {
		var ne = "";
		if($(comboBox).attr("data-updatefuzz-url")) {
			var urlUpdateFuzz = $(comboBox).attr("data-updatefuzz-url");
			loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlUpdateFuzz + params,function(){ 
				defineNewFuzzyFormValidation();
				$('#defineNew select#personalizationSelectComboBoxId2').removeAttr('data-fromupdate');
			});
		 } else if($(comboBox).attr("data-updatesimilarity-url")) {
			 var urlUpdateSimilarity = $(comboBox).attr("data-updatesimilarity-url");
			 console.info(urlUpdateSimilarity + params);
				loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlUpdateSimilarity + params, function() {
					$('#defineNew select#personalizationSelectComboBoxId2').removeAttr('data-fromupdate');
				});
		 }
		else if (params.split("&")[params.split("&").length-1] == "new") {
			loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlNew + params,function(){ defineNewFuzzyFormValidation(); });
		} else if (params.split("&")[params.split("&").length-1] == "define")
			loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlDefine + params);
		else if(params.split("&")[params.split("&").length-1] == "add")
			loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlAdd + params);
		else if(params.split("&")[params.split("&").length-1] == "update")
			loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlUpdate + params);
		else if(params.split("&")[params.split("&").length-1] == "fuzzyRule") {
			loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlFuzzyRule + params, function() {
				//Predicates
				var predicates = [];
				$("#addFuzzyPredicate").click(function() {
					$("#predNecessary").show();
					$("#predNecessary").change(function() {
						if($(this).val() !== "" && predicates.indexOf($(this).val()) == -1) {
							predicates.push($(this).val());
							var predId = Math.floor((Math.random() * 100) + 1);
							var addedPredicate = "<div data-pred-rem='predRem"+predId+"' data-predicate='"+$(this).val()+"' class='predicateDiv'><span class='predicateSpan'>"+$(this).val()+"</span><img id='predRem"+predId+"' src='images/cross.png' width='20' data-predicate='"+$(this).val()+"' class='removePredicate' /><br></div>";
							$("#fuzzyPredicates").append(addedPredicate);
							$("#predRem"+predId).click(function() {
								predicates.splice($.inArray($(this).attr("data-predicate"),predicates),1);
								$("div[data-pred-rem='"+$(this).attr("id")+"']").remove();
								if(predicates.length > 0) 
									$("#fuzzyPredicates").show();
								else
									$("#fuzzyPredicates").hide();
							});
							$("#predNecessary").val("");
							if(predicates.length > 0) 
								$("#fuzzyPredicates").show();
							else
								$("#fuzzyPredicates").hide();
						}
					});
				});
				//Credibility
				$("#addCredibility").click(function() {
					$("#credibilityDetail").show();
				});
				$("#credibilityValue").on("change input", function() {
					$("#credibilityValueTxt").val($(this).val());
				});
				$("#credibilityValueTxt").keyup(function() {
					$("#credibilityValue").val($(this).val());
				});
			});
		}
		else if(params.split("&")[params.split("&").length-1] == "synAnt")
			loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlSynAnt + params);
		else {
			loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlEdit + params);
		}
	}
	else {
		var container = getContainer(PersonalizationFunctionUnderModificationDivId);
		container.innerHTML = "Please choose a valid fuzzification function.";
	}
	
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function removeExistingCriteria(comboBox, PersonalizationFunctionUnderModificationDivId, urlRemoveFuzzy, urlRemoveSimilarity) {
	if($("#"+comboBox.id).val() !== "----") {
		var params = getComboBoxValue(comboBox);
		if (params != "") {
			//$("b#criterionName").html('"'+$("#"+comboBox.id+" option:selected").html()+'"');
			//$("b#criterionName").html('"'+getParamFromGivenUrl($("#"+comboBox.id).val(), "predDefined")+'"');
			
			$("#dialog-confirm").modal('show');
			$("#dialog-confirm .modal-footer button.removeIt").click(function() {
				$("#dialog-confirm").modal("hide");
				var ne = "";
       			if($("#"+comboBox.id).find(":selected").attr("data-type") == "fuzzy") {
       				loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlRemoveFuzzy + $("#"+comboBox.id).val(), function() {
       					$("b#criterionName").html("");
       					//$("#dialog-confirm").dialog("hide");
       					$(".modal:visible").modal("hide");
       					//$("#dialog-confirm").modal("hide");
       				});
       			 } else if($("#"+comboBox.id).find(":selected").attr("data-type") == "similarity") {
       				loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlRemoveSimilarity + $("#"+comboBox.id).val(), function() {
       					$("b#criterionName").html("");
       					$(".modal:visible").modal("hide");
       					//$("#dialog-confirm").modal("hide");
       				});
       			 }
			});
			/* $("#dialog-confirm .modal-footer button.cancel").click(function() {
				$("#dialog-confirm").modal("hide");
			}); */
			
			/* $("#dialog-confirm").dialog({
	            resizable: false,
	            height: "auto",
	            width: 600,
	            minHeight: 300,
	            modal: true,
	            buttons: {
	              "Remove it": function() {
	           			var ne = "";
	           			if($("#"+comboBox.id).find(":selected").attr("data-type") == "fuzzy") {
	           				loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlRemoveFuzzy + $("#"+comboBox.id).val(), function() {
	           					$("#auxAndInvisibleSection").dialog("close");
	           					$("b#criterionName").html("");
	           					$("#dialog-confirm").dialog("close");
	           				});
	           			 } else if($("#"+comboBox.id).find(":selected").attr("data-type") == "similarity") {
	           				loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlRemoveSimilarity + $("#"+comboBox.id).val(), function() {
	           					$("#auxAndInvisibleSection").dialog("close");
	           					$("b#criterionName").html("");
	           					$("#dialog-confirm").dialog("close");
	           				});
	           			 }
	              },
	              Cancel: function() {
	            	  $("b#criterionName").html("");
	                $(this).dialog("close");
	              }
	    		}
	 		}); */
		} else {
			var container = getContainer(PersonalizationFunctionUnderModificationDivId);
			container.innerHTML = "Please choose a valid fuzzification function.";
		}
    }
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function modificationFunctionChanged(comboBox, PersonalizationFunctionUnderModificationDivId, urlEdit, urlNew, urlDefine, urlAdd, urlUpdate, urlUpdateFuzz, urlUpdateSimilarity) {
	
	var params = getComboBoxValue(comboBox);
	if (params != "") {
		var tabName;
		var label;
		if(getParamFromGivenUrl(params, "mode") == "advanced" || getParamFromGivenUrl(params, "mode") == "update") {
			tabName = "Modification";
			label = "Modify &nbsp;";
		} else if(getParamFromGivenUrl(params, "mode") == "basic") {
			tabName = "Personalization";
			label = "Personalize &nbsp;";
		}
		if($("#"+comboBox.id).find(":selected").attr("data-type") == "fuzzy") {
			$('div.tab button.tablinks').eq(1).html(tabName);
			$("#defineNew div.personalizationDivSelectFuzzificationTableCell").eq(0).html(label);
			$("#defineNew select#personalizationSelectComboBoxId2").val($("#defineNew select#personalizationSelectComboBoxId2 option[data-type='fuzzy']").val());
			$('#defineNew select#personalizationSelectComboBoxId2').removeAttr('data-updatesimilarity-url');
			$('#defineNew select#personalizationSelectComboBoxId2').attr('data-updatefuzz-url',urlUpdateFuzz + params);
			$('#defineNew select#personalizationSelectComboBoxId2').attr('data-fromupdate', true);
			$("#defineNew select#personalizationSelectComboBoxId2 option[data-type='fuzzy']").trigger('change');
			$('#defineNew select#personalizationSelectComboBoxId2').attr('disabled','disabled');
			$('div.tab button.tablinks').eq(1).click();
		} else if($("#"+comboBox.id).find(":selected").attr("data-type") == "similarity") {
			$('div.tab button.tablinks').eq(1).html(tabName);
			$("#defineNew div.personalizationDivSelectFuzzificationTableCell").eq(0).html(label);
			$("#defineNew select#personalizationSelectComboBoxId2").val($("#defineNew select#personalizationSelectComboBoxId2 option[data-type='similarity']").val());
			$('#defineNew select#personalizationSelectComboBoxId2').removeAttr('data-updatefuzz-url');
			$('#defineNew select#personalizationSelectComboBoxId2').attr('data-updatesimilarity-url',urlUpdateSimilarity + params);
			$('#defineNew select#personalizationSelectComboBoxId2').attr('data-fromupdate', true);
			$("#defineNew select#personalizationSelectComboBoxId2 option[data-type='similarity']").trigger('change');
			$('#defineNew select#personalizationSelectComboBoxId2').attr('disabled','disabled');
			$('div.tab button.tablinks').eq(1).click();
		}
		//for fuzzy update
		//loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlEdit + params);
		//for similarity update
		//loadAjaxIn(PersonalizationFunctionUnderModificationDivId, urlUpdate + params);
	}
	else {
		var container = getContainer(PersonalizationFunctionUnderModificationDivId);
		container.innerHTML = "Please choose a valid fuzzification function.";
	}
	
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function defineNewFuzzyFormValidation() {
	//increasingFormat FORM VALIDATION
	$("div.increasingFormat input#xPoint").on("change paste keyup", function() {
		if($(this).val()!=="" && $("div.increasingFormat input#yPoint").val()!=="")
			if(parseInt($(this).val()) < parseInt($("div.increasingFormat input#yPoint").val())) {
				validation.validate = true;
				validation.msg = "";
				$(this).css("border-color","");
				$("div.increasingFormat input#yPoint").css("border-color","");
			} else {
				$(this).css("border-color","red");
				$("div.increasingFormat input#yPoint").css("border-color","red");
				validation.validate = false;
				validation.msg = "V1 should be <b>lower</b> than V2";
			}
	});
	$("div.increasingFormat input#yPoint").on("change paste keyup", function() {
		if($(this).val()!=="" && $("div.increasingFormat input#xPoint").val()!=="")
			if(parseInt($(this).val()) > parseInt($("div.increasingFormat input#xPoint").val())) {
				validation.validate = true;
				validation.msg = "";
				$(this).css("border-color","");
				$("div.increasingFormat input#xPoint").css("border-color","");
			} else {
				validation.validate = false;
				$(this).css("border-color","red");
				$("div.increasingFormat input#xPoint").css("border-color","red");
				validation.msg = "V1 should be <b>lower</b> than V2";
			}
	});
	//decreasingFormat FORM VALIDATION
	$("div.decreasingFormat input#xPoint").on("change paste keyup", function() {
		if($(this).val()!=="" && $("div.decreasingFormat input#yPoint").val()!=="")
			if(parseInt($(this).val()) < parseInt($("div.decreasingFormat input#yPoint").val())) {
				validation.validate = true;
				validation.msg = "";
				$(this).css("border-color","");
				$("div.decreasingFormat input#yPoint").css("border-color","");
			} else {
				$(this).css("border-color","red");
				$("div.decreasingFormat input#yPoint").css("border-color","red");
				validation.validate = false;
				validation.msg = "V1 should be <b>lower</b> than V2";
			}
	});
	$("div.decreasingFormat input#yPoint").on("change paste keyup", function() {
		if($(this).val()!=="" && $("div.decreasingFormat input#xPoint").val()!=="")
			if(parseInt($(this).val()) > parseInt($("div.decreasingFormat input#xPoint").val())) {
				validation.validate = true;
				validation.msg = "";
				$(this).css("border-color","");
				$("div.decreasingFormat input#xPoint").css("border-color","");
			} else {
				validation.validate = false;
				$(this).css("border-color","red");
				$("div.decreasingFormat input#xPoint").css("border-color","red");
				validation.msg = "V1 should be <b>lower</b> than V2";
			}
	});
	//mediumFormat FORM VALIDATION
	$("div.mediumFormat input#xPoint").on("change paste keyup", function() {
		if($(this).val()!=="" && $("div.mediumFormat input#yPoint").val()!=="" && $("div.mediumFormat input#zPoint").val()!=="" && $("div.mediumFormat input#wPoint").val()!=="")
			if(parseInt($(this).val()) < parseInt($("div.mediumFormat input#yPoint").val())
					&& parseInt($("div.mediumFormat input#yPoint").val()) < parseInt($("div.mediumFormat input#zPoint").val())
					&& parseInt($("div.mediumFormat input#zPoint").val()) < parseInt($("div.mediumFormat input#wPoint").val())) {
				validation.validate = true;
				validation.msg = "";
				$(this).css("border-color","");
				$("div.mediumFormat input#yPoint").css("border-color","");
				$("div.mediumFormat input#zPoint").css("border-color","");
				$("div.mediumFormat input#wPoint").css("border-color","");
			} else {
				$(this).css("border-color","red");
				$("div.mediumFormat input#yPoint").css("border-color","red");
				$("div.mediumFormat input#zPoint").css("border-color","red");
				$("div.mediumFormat input#wPoint").css("border-color","red");
				validation.validate = false;
				validation.msg = "V2 should be <b>higher</b> than V1<br>V3 should be <b>higher</b> than V2<br>V4 should be <b>higher</b> than V3";
			}
	});
	$("div.mediumFormat input#yPoint").on("change paste keyup", function() {
		if($(this).val()!=="" && $("div.mediumFormat input#xPoint").val()!=="" && $("div.mediumFormat input#zPoint").val()!=="" && $("div.mediumFormat input#wPoint").val()!=="")
			if(parseInt($("div.mediumFormat input#xPoint").val()) < parseInt($(this).val())
					&& parseInt($(this).val()) < parseInt($("div.mediumFormat input#zPoint").val())
					&& parseInt($("div.mediumFormat input#zPoint").val()) < parseInt($("div.mediumFormat input#wPoint").val())) {
				validation.validate = true;
				validation.msg = "";
				$(this).css("border-color","");
				$("div.mediumFormat input#xPoint").css("border-color","");
				$("div.mediumFormat input#zPoint").css("border-color","");
				$("div.mediumFormat input#wPoint").css("border-color","");
			} else {
				$(this).css("border-color","red");
				$("div.mediumFormat input#xPoint").css("border-color","red");
				$("div.mediumFormat input#zPoint").css("border-color","red");
				$("div.mediumFormat input#wPoint").css("border-color","red");
				validation.validate = false;
				validation.msg = "V2 should be <b>higher</b> than V1<br>V3 should be <b>higher</b> than V2<br>V4 should be <b>higher</b> than V3";
			}
	});
	$("div.mediumFormat input#zPoint").on("change paste keyup", function() {
		if($(this).val()!=="" && $("div.mediumFormat input#xPoint").val()!=="" && $("div.mediumFormat input#yPoint").val()!=="" && $("div.mediumFormat input#wPoint").val()!=="")
			if(parseInt($("div.mediumFormat input#xPoint").val()) < parseInt($("div.mediumFormat input#yPoint").val())
					&& parseInt($("div.mediumFormat input#yPoint").val()) < parseInt($(this).val())
					&& parseInt($(this).val()) < parseInt($("div.mediumFormat input#wPoint").val())) {
				validation.validate = true;
				validation.msg = "";
				$(this).css("border-color","");
				$("div.mediumFormat input#xPoint").css("border-color","");
				$("div.mediumFormat input#yPoint").css("border-color","");
				$("div.mediumFormat input#wPoint").css("border-color","");
			} else {
				$(this).css("border-color","red");
				$("div.mediumFormat input#xPoint").css("border-color","red");
				$("div.mediumFormat input#yPoint").css("border-color","red");
				$("div.mediumFormat input#wPoint").css("border-color","red");
				validation.validate = false;
				validation.msg = "V2 should be <b>higher</b> than V1<br>V3 should be <b>higher</b> than V2<br>V4 should be <b>higher</b> than V3";
			}
	});
	$("div.mediumFormat input#wPoint").on("change paste keyup", function() {
		if($(this).val()!=="" && $("div.mediumFormat input#xPoint").val()!=="" && $("div.mediumFormat input#yPoint").val()!=="" && $("div.mediumFormat input#zPoint").val()!=="")
			if(parseInt($("div.mediumFormat input#xPoint").val()) < parseInt($("div.mediumFormat input#yPoint").val())
					&& parseInt($("div.mediumFormat input#yPoint").val()) < parseInt($("div.mediumFormat input#zPoint").val())
					&& parseInt($("div.mediumFormat input#zPoint").val()) < parseInt($(this).val())) {
				validation.validate = true;
				validation.msg = "";
				$(this).css("border-color","");
				$("div.mediumFormat input#xPoint").css("border-color","");
				$("div.mediumFormat input#yPoint").css("border-color","");
				$("div.mediumFormat input#zPoint").css("border-color","");
			} else {
				$(this).css("border-color","red");
				$("div.mediumFormat input#xPoint").css("border-color","red");
				$("div.mediumFormat input#yPoint").css("border-color","red");
				$("div.mediumFormat input#zPoint").css("border-color","red");
				validation.validate = false;
				validation.msg = "V2 should be <b>higher</b> than V1<br>V3 should be <b>higher</b> than V2<br>value4 should be <b>higher</b> than V3";
			}
	});
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function saveFuzzification(fuzzificationSaveStatusDivId, saveUrl, callback) {
	var fuzzificationSaveStatusDiv = getContainer(fuzzificationSaveStatusDivId);
	fuzzificationSaveStatusDiv.innerHTML = loadingImageHtml(false);
	
	var i = indexOfMyPersonalizedFunction();
	
	if($("input.values[data-modified='true']").length !== 0) {
		fuzzificationFunction.fuzzificationPoints[i].modified = true;
	}

	if (i >= 0) {
		if (fuzzificationFunction.fuzzificationPoints[i].modified) {
			for (var j=0; j < fuzzificationFunction.fuzzificationPoints[i].data.length; j++) {
				var fpx = null;
				if($("input#valueOf"+j).length !== 0) {
					fpx = parseInt($("input#valueOf"+j).val());
				} else {
					var fpx = fuzzificationFunction.fuzzificationPoints[i].data[j][0];
				}
				if(fuzzificationFunction.functionFormat=="decreasing" && j==0) {
					var fpy = fuzzificationFunction.fuzzificationPoints[i].data[1][1];
				} else if(fuzzificationFunction.functionFormat=="decreasing" && j==1) { 
					var fpy = fuzzificationFunction.fuzzificationPoints[i].data[0][1];
				} else {
					var fpy = fuzzificationFunction.fuzzificationPoints[i].data[j][1];
				}
		
				saveUrl += "&fpx["+j+"]=" + fpx;
				saveUrl += "&fpy["+j+"]=" + fpy;
			}
	
			fuzzificationFunction.fuzzificationPoints[i].modified = false;
			loadAjaxIn(fuzzificationSaveStatusDivId, saveUrl, function() {
				/* $("#auxAndInvisibleSection").dialog("close"); */
				$(".modal:visible").modal("hide");
			});
		}
		else {
			fuzzificationSaveStatusDiv.innerHTML = "No changes to save.";
		}
	}
	else {
		fuzzificationSaveStatusDiv.innerHTML = "Impossible to save fuzzification modifications.";
	}
}

function updateFuzzification(fuzzificationSaveStatusDivId, saveUrl, predNecessary, predDefined, creteriaFormat, values, callback) {
	var fuzzificationSaveStatusDiv = getContainer(fuzzificationSaveStatusDivId);
	fuzzificationSaveStatusDiv.innerHTML = loadingImageHtml(false);
	
	
	//fuzzificationFunction.fuzzificationPoints[0].modified = true;

	//if (fuzzificationFunction.fuzzificationPoints[0].modified) {
		//fuzzificationFunction.fuzzificationPoints[0].modified = false;
		saveUrl +=
		"&" + '<%=KConstants.Fuzzifications.predDefined%>' + "=" + predDefined + "(" + predNecessary.split("(")[1] +
		"&" + '<%=KConstants.Fuzzifications.predNecessary%>' + "=" + predNecessary;
		if(creteriaFormat == "increasingFormat") {
			saveUrl += "&fpx[0]=" + values.xValue;
			saveUrl += "&fpy[0]=" + values.tValue;
			saveUrl += "&fpx[1]=" + values.yPoint;
			saveUrl += "&fpy[1]=" + values.ytValue;
		} else if(creteriaFormat == "decreasingFormat") {
			saveUrl += "&fpx[0]=" + values.xValue;
			saveUrl += "&fpy[0]=" + values.tValue;
			saveUrl += "&fpx[1]=" + values.yPoint;
			saveUrl += "&fpy[1]=" + values.ytValue;
		} else if(creteriaFormat == "mediumFormat") {
			saveUrl += "&fpx[0]=" + values.xValue;
			saveUrl += "&fpy[0]=" + values.tValue;
			saveUrl += "&fpx[1]=" + values.yPoint;
			saveUrl += "&fpy[1]=" + values.ytValue;
			saveUrl += "&fpx[2]=" + values.zValue;
			saveUrl += "&fpy[2]=" + values.ztValue;
			saveUrl += "&fpx[3]=" + values.wPoint;
			saveUrl += "&fpy[3]=" + values.wtValue;
		}
		console.info(saveUrl);
		loadAjaxIn(fuzzificationSaveStatusDivId, saveUrl, callback);
	//}
	//else {
	//	fuzzificationSaveStatusDiv.innerHTML = "No changes to save.";
	//}
}


function saveNewFuzzification(fuzzificationSaveStatusId, saveUrl, predNecessary, predDefined, creteriaFormat, values, defaultValue, addDefault, callback)
{
	funcPoints = [[values.xValue,values.tValue],[values.yPoint,values.ytValue]];
	if(creteriaFormat == "mediumFormat") {
		funcPoints.push([values.zValue,values.ztValue],[values.wPoint,values.wtValue]);
	}
	<%-- if(addDefault == true){
		owner = saveUrl.split("&")[4].split("=")[1];
		setFuzzificationFunction(predDefined, predNecessary, 0, predDefined, predNecessary, [fuzzificationPoints(owner, owner, funcPoints)]);
		this.fuzzificationFunction.fuzzificationPoints[0].modified = true;
			value =  defaultValue;
			
			saveUrl = saveUrl +
			"&" + '<%=KConstants.Fuzzifications.predDefined%>' + "=" + predDefined + "(" + predNecessary.split("(")[1] +
			"&" + '<%=KConstants.Fuzzifications.predNecessary%>' + "=" + predNecessary
			+ "&"+ '<%=KConstants.Fuzzifications.defaultValue%>' + "=" + value + "&" + 
			'<%=KConstants.Request.defaultParam%>' + "=" + 'true'
			+ "&mode=create";
			console.log(saveUrl);
			saveFuzzification(fuzzificationSaveStatusId, saveUrl, callback);
	} else {
		owner = saveUrl.split("&")[4].split("=")[1];
		setFuzzificationFunction(predDefined, predNecessary, 0, predDefined, predNecessary, [fuzzificationPoints(owner, owner, funcPoints)]);
		this.fuzzificationFunction.fuzzificationPoints[0].modified = true;
		saveUrl = saveUrl +
		"&" + '<%=KConstants.Fuzzifications.predDefined%>' + "=" + predDefined + "(" + predNecessary.split("(")[1] +
		"&" + '<%=KConstants.Fuzzifications.predNecessary%>' + "=" + predNecessary+ "&" + 
		'<%=KConstants.Request.defaultParam%>' + "=" + 'false'
		+ "&mode=create";
		console.log(saveUrl);
		saveFuzzification(fuzzificationSaveStatusId, saveUrl, callback);
	} --%>
	var owner = saveUrl.split("&")[4].split("=")[1];
	setFuzzificationFunction(predDefined, predNecessary, null, 0, predDefined, predNecessary, [fuzzificationPoints(owner, owner, funcPoints)]);
	this.fuzzificationFunction.fuzzificationPoints[0].modified = true;
	saveUrl = saveUrl +
	"&" + '<%=KConstants.Fuzzifications.predDefined%>' + "=" + predDefined + "(" + predNecessary.split("(")[1] +
	"&" + '<%=KConstants.Fuzzifications.predNecessary%>' + "=" + predNecessary+ "&" + 
	'<%=KConstants.Request.defaultParam%>' + "=" + 'false'
	+ "&mode=create";
	console.log(saveUrl);
	saveFuzzification(fuzzificationSaveStatusId, saveUrl, callback);
}

function defineNewSynAnt(fuzzificationSaveStatusId, saveUrl, dbName, synonymName, antonymName, callback)
{
	var owner = saveUrl.split("&")[4].split("=")[1];
	saveUrl = saveUrl +
	"&" + '<%=KConstants.Fuzzifications.synonymName%>' + "=" + synonymName +
	"&" + '<%=KConstants.Fuzzifications.antonymName%>' + "=" + antonymName +
	"&" + '<%=KConstants.Fuzzifications.predNecessary%>' + "=" + dbName + "&" + 
	'<%=KConstants.Request.defaultParam%>' + "=" + 'false'
	+ "&mode=create";
	console.log(saveUrl);
	loadAjaxIn(fuzzificationSaveStatusId, saveUrl, function() {
		/* $("#auxAndInvisibleSection").dialog("close"); */
		$(".modal:visible").modal("hide");
	});
}

function defineNewFuzzyRule(fuzzificationSaveStatusId, saveUrl, dbName, fuzzyRuleName, agregatorOperator, predicates, credibilityOperator, credibilityValue, callback)
{
	var owner = saveUrl.split("&")[4].split("=")[1];
	saveUrl = saveUrl +
	"&" + '<%=KConstants.Fuzzifications.fuzzyRuleName%>' + "=" + fuzzyRuleName +
	"&" + '<%=KConstants.Fuzzifications.agregatorOperator%>' + "=" + agregatorOperator +
	"&" + '<%=KConstants.Fuzzifications.predicates%>' + "=" + predicates +
	"&" + '<%=KConstants.Fuzzifications.credibilityOperator%>' + "=" + credibilityOperator +
	"&" + '<%=KConstants.Fuzzifications.credibilityValue%>' + "=" + credibilityValue +
	"&" + '<%=KConstants.Fuzzifications.predNecessary%>' + "=" + dbName + "&" +
	'<%=KConstants.Request.defaultParam%>' + "=" + 'false'
	+ "&mode=create";
	console.log(saveUrl);
	loadAjaxIn(fuzzificationSaveStatusId, saveUrl, function() {
		/* $("#auxAndInvisibleSection").dialog("close"); */
		$(".modal:visible").modal("hide");
	});
}

function checkIfSimilarityExist(fuzzificationSaveStatusDivId, saveUrl, value1, value2, similarity) {
	if(value2 != "") {
		saveUrl = saveUrl + "&" + '<%=KConstants.Request.value1Index%>' + "=" + value1.value +
		"&" + '<%=KConstants.Request.value2Index%>' + "=" + value2.value +
		"&" + '<%=KConstants.Request.similarityValue%>' + "=" + similarity.value ;
		loadAjaxIn(null, saveUrl, function(res) {
			var simalarityValue = res.replace(/\s/g, '').split("<!--END-->")[0];
			if(simalarityValue != "" && simalarityValue == "opposit") {
				$("#defaultValue").val(0.5);
				$("#defaultValueResult").val(0.5);
				$("span#similarityMsg").html(getSimilarityState(0.5));
				$("span#similarityMsg").removeAttr("class");
				$("span#similarityMsg").addClass(getSimilarityStyle(0.5));
				$("#fuzzificationSimilarityValue div.personalizationDivFuzzificationFunctionValuesTableRow:nth-child(3) input").attr("disabled","disabled");
				$("#fuzzificationSimilarityValue #fuzzificationSaveStatus").html("Similarity already exist!");
				$("#fuzzificationSimilarityValue input[value='Save modifications']").attr("disabled","disabled");
				similarityExist = true;
			} else if(simalarityValue != "" && simalarityValue != "opposit") {
				$("#defaultValue").val(simalarityValue);
				$("#defaultValueResult").val(simalarityValue);
				$("span#similarityMsg").html(getSimilarityState(simalarityValue));
				$("span#similarityMsg").removeAttr("class");
				$("span#similarityMsg").addClass(getSimilarityStyle(simalarityValue));
				$("#fuzzificationSimilarityValue div.personalizationDivFuzzificationFunctionValuesTableRow:nth-child(3) input").removeAttr("disabled");
				$("#fuzzificationSimilarityValue #fuzzificationSaveStatus").html("");
				$("#fuzzificationSimilarityValue input[value='Save modifications']").removeAttr("disabled");
				similarityExist = true;
			} else {
				$("#defaultValue").val(0.5);
				$("#defaultValueResult").val(0.5);
				$("span#similarityMsg").html(getSimilarityState(0.5));
				$("span#similarityMsg").removeAttr("class");
				$("span#similarityMsg").addClass(getSimilarityStyle(0.5));
				$("#fuzzificationSimilarityValue div.personalizationDivFuzzificationFunctionValuesTableRow:nth-child(3) input").removeAttr("disabled");
				$("#fuzzificationSimilarityValue #fuzzificationSaveStatus").html("");
				$("#fuzzificationSimilarityValue input[value='Save modifications']").removeAttr("disabled");
			}
		});
	}
}

function saveSimilarity(fuzzificationSaveStatusDivId, saveUrl, value1, value2, similarity){
	saveUrl = saveUrl + "&" + '<%=KConstants.Request.value1Index%>' + "=" + value1.value +
	"&" + '<%=KConstants.Request.value2Index%>' + "=" + value2.value +
	"&" + '<%=KConstants.Request.similarityValue%>' + "=" + similarity.value ;
	if(similarityExist) {
		saveUrl = saveUrl + "&mode=" + '<%=KConstants.Request.modeUpdateSimilarity%>';
	}
	loadAjaxIn(fuzzificationSaveStatusDivId, saveUrl, function() {
		/* $("#auxAndInvisibleSection").dialog("close"); */
		$(".modal:visible").modal("hide");
	});
}

function updateSimilarity(fuzzificationSaveStatusDivId, saveUrl, value1, value2, similarity, oldValue1, oldValue2){
	saveUrl = saveUrl + "&" + '<%=KConstants.Request.value1Index%>' + "=" + value1 +
	"&" + '<%=KConstants.Request.value2Index%>' + "=" + value2 +
	"&" + '<%=KConstants.Request.oldValue1Index%>' + "=" + oldValue1 +
	"&" + '<%=KConstants.Request.oldValue2Index%>' + "=" + oldValue2 +
	"&" + '<%=KConstants.Request.similarityValue%>' + "=" + similarity.value ;
	loadAjaxIn(fuzzificationSaveStatusDivId, saveUrl, function() {
		/* $("#auxAndInvisibleSection").dialog("close"); */
		$(".modal:visible").modal("hide");
	});
}

function saveModifier(fuzzificationSaveStatusDivId, saveUrl, modifier){
	saveUrl = saveUrl + "&" + '<%=KConstants.Request.modifierValue%>' + "=" + modifier;
	loadAjaxIn(fuzzificationSaveStatusDivId, saveUrl, function() {
		/* $("#auxAndInvisibleSection").dialog("close"); */
		$(".modal:visible").modal("hide");
		location.reload();
	});
}

function selectedDatabaseChanged(fuzzificationSaveStatusId, comboBox, url){
	comboBoxValue = getComboBoxValue(comboBox);
	if(comboBoxValue != "---"){
	url= url+"&"+ '<%=KConstants.Request.databaseIndex%>'+ "=" + comboBoxValue;
	loadAjaxIn(fuzzificationSaveStatusId, url);
	}
}

function selectedColumnChanged(fuzzificationSaveStatusId, comboBox, url){
	comboBoxValue = getComboBoxValue(comboBox);
	if(comboBoxValue != "---"){
	url= url+"&"+ '<%=KConstants.Request.columnIndex%>'+ "=" + comboBoxValue;
	loadAjaxIn(fuzzificationSaveStatusId, url);
	}
}

function getComboBoxValue(comboBox) {
	if (comboBox == null) {
		debug.info("getComboBoxValue: comboBox is null");
		return "";
	}
	if (comboBox == undefined) {
		debug.info("getComboBoxValue: comboBox is undefined");
		return "";
	}
	
	var comboBoxSelectedIndex = comboBox.selectedIndex;
	if (comboBoxSelectedIndex == null) {
		debug.info("getComboBoxValue: comboBoxSelectedIndex is null");
		return "";
	}
	if (comboBoxSelectedIndex == undefined) {
		debug.info("getComboBoxValue: comboBoxSelectedIndex is undefined");
		return "";
	}
	
	var comboBoxSelectedField = comboBox.options[comboBoxSelectedIndex];
	if (comboBoxSelectedField == null) {
		debug.info("getComboBoxValue: comboBoxSelectedField is null");
		return "";
	}
	if (comboBoxSelectedField == undefined) {
		debug.info("getComboBoxValue: comboBoxSelectedField is undefined");
		return "";
	}

	var comboBoxValue = comboBoxSelectedField.value;
	var comboBoxText = comboBoxSelectedField.text;
	var comboBoxName = comboBoxSelectedField.name;
	var comboBoxTitle = comboBoxSelectedField.title;
	debug.info("getComboBoxValue: value: " + comboBoxValue);
	debug.info("getComboBoxValue: text: " + comboBoxText);
	debug.info("getComboBoxValue: name: " + comboBoxName);
	debug.info("getComboBoxValue: title: " + comboBoxTitle);

	if (comboBoxValue === null) {
		debug.info("getComboBoxValue: comboBoxValue is null (===).");
		return "";
	}
	
	// alert("comboBoxValue: " + comboBoxValue);
	if (comboBoxValue == null) {
		debug.info("getComboBoxValue: comboBoxValue is null (==).");
		return "";
	}
	
	if (comboBoxValue == "") {
		debug.info("getComboBoxValue: comboBoxValue is empty string.");
		return "";
	} 

	if (comboBoxValue == "----") {
		debug.info("getComboBoxValue: comboBoxValue is default value (----).");
		return "";
	}
	
	return comboBoxValue;
}
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

// EOF

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

<% if (JspsUtils.getStringWithValueS().equals("N")) { %>
</script>
<%
	}
%>
