<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="programAnalysis.FunctionPoint"%>
<%@page import="programAnalysis.ProgramPartAnalysis"%>
<%@page import="constants.KUrls"%>
<%@page import="auxiliar.LocalUserInfo"%>
<%@page import="constants.KConstants"%>
<%@page import="auxiliar.JspsUtils"%>
<%@page import="storeHouse.RequestStoreHouse"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.io.InputStreamReader"%>


<%
	RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
	ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);
	LocalUserInfo localUserInfo = requestStoreHouse.getSession().getLocalUserInfo();
	String mode = requestStoreHouse.getRequestParameter(KConstants.Request.mode);
	String fileName = requestStoreHouse.getRequestParameter(KConstants.Request.fileNameParam);
	String fileOwner = requestStoreHouse.getRequestParameter(KConstants.Request.fileOwnerParam);
	String predDefined = requestStoreHouse.getRequestParameter(KConstants.Fuzzifications.predDefined);
	String predNecessary = requestStoreHouse.getRequestParameter(KConstants.Fuzzifications.predNecessary);
	
	String saveUrl = KUrls.Fuzzifications.Save.getUrl(true) + 
			"&" + KConstants.Request.fileNameParam + "=" + fileName + 
			"&" + KConstants.Request.fileOwnerParam + "=" + fileOwner +
			"&" + KConstants.Request.mode + "=" + mode;
			JspsUtils.getValue(saveUrl);
	
	ProgramPartAnalysis [][] fuzzifications = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis [][] programFields = resultsStoreHouse.getProgramPartAnalysis2();
	ProgramPartAnalysis [] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis [] othersFuzzifications = null;
	String [] keyValues = null;
	
	if (fuzzifications.length >= 1) {
		if(fuzzifications[0].length == 1) {
			thisFuzzification = fuzzifications[0];
			keyValues = JspsUtils.getKeyValues(thisFuzzification);
		} else if(fuzzifications[0].length > 1) {
			if(StringUtils.equals(mode, KConstants.Request.modeAdvanced)) {
				thisFuzzification = fuzzifications[0];
				keyValues = JspsUtils.getKeyValues(thisFuzzification);
			} else if(StringUtils.equals(mode, KConstants.Request.modeBasic)) {
				for(ProgramPartAnalysis program : fuzzifications[0]) {
					if(program.getOnly_for_user() != null && StringUtils.equals(program.getOnly_for_user(), localUserInfo.getLocalUserName())) {
						ProgramPartAnalysis [] thisFuzz = new ProgramPartAnalysis[1];
						thisFuzz[0] = program;
						keyValues = JspsUtils.getKeyValues(thisFuzz);
						thisFuzzification = thisFuzz;
						break;
					}
				}
			}
		}
		
		if (thisFuzzification.length == 1) {
			defaultFuzzification = thisFuzzification[0];
			myFuzzification = thisFuzzification[0];
			othersFuzzifications = new ProgramPartAnalysis[0];
		}
		else {
			defaultFuzzification = JspsUtils.getDefaultFuzzification(thisFuzzification);
			myFuzzification = JspsUtils.getMyFuzzification(thisFuzzification, localUserInfo, mode);
			othersFuzzifications = JspsUtils.getOthersFuzzifications(thisFuzzification, localUserInfo, mode);
		}
	}
	
	LinkedHashMap<String, String> defaultFuzzPoints = defaultFuzzification.getFunctionPoints();
	LinkedHashMap<String, String> myFuzzPoints = myFuzzification.getFunctionPoints(); 
	
	JSONObject jsonVals = new JSONObject(myFuzzPoints);
	
	
	/* String format = "";
	List<String> l = new ArrayList<String>(myFuzzPoints.values());
	if(!myFuzzPoints.entrySet().isEmpty()) {
		if(myFuzzPoints.entrySet().size() > 2) {
			format = "mediumFormat";
		} else if(StringUtils.equals(l.get(0), "0")) {
			format = "increasingFormat";
		} else {
			format = "decreasingFormat";
		}
	} */
	String format = myFuzzification.getFunctionFormat();
	List<String> vals = new ArrayList<String>();
	for (int i=0; i<keyValues.length; i++) {
		//String fuzzificationBarDivId = KConstants.JspsDivsIds.fuzzificationBarValueDivId + "[" + i + "]";
		vals.add(keyValues[i]);
	}
%>


<script type="text/javascript">

	<%
		String dbPredIsPredDefined = JspsUtils.getFromFuzzificationNameOf(defaultFuzzification, KConstants.Fuzzifications.database, true) + " is " +
				JspsUtils.getFromFuzzificationNameOf(defaultFuzzification, KConstants.Fuzzifications.predDefined, true);
		String PredNecessaryOfADbPred = JspsUtils.getFromFuzzificationNameOf(defaultFuzzification, KConstants.Fuzzifications.predNecessary, true) +
				" of a " + JspsUtils.getFromFuzzificationNameOf(defaultFuzzification, KConstants.Fuzzifications.database, true);
		
		String name;
		
		out.print("setFuzzificationFunction('" + defaultFuzzification.getPredDefined() + "', '" + defaultFuzzification.getPredNecessary());
		out.print("', '" + defaultFuzzification.getFunctionFormat() + "', 0, '" + dbPredIsPredDefined + "', '" + PredNecessaryOfADbPred + "', new Array("); 
		
		name = defaultFuzzification.getPredOwner();
		if (mode.equals(KConstants.Request.modeAdvanced)) {
			name = KConstants.Fuzzifications.PREVIOUS_DEFAULT_DEFINITION;
		}
		
		out.print(JspsUtils.convertFunctionPointsToJS(name, keyValues, defaultFuzzPoints));
		out.print(", ");
		
		name = myFuzzification.getPredOwner();
		out.print(JspsUtils.convertFunctionPointsToJS(name, keyValues, myFuzzPoints));
		
		if (othersFuzzifications.length > 0) {
			for (int i=0; i<othersFuzzifications.length; i++) {
				name = othersFuzzifications[i].getPredOwner();
				out.print(", ");
				out.print(JspsUtils.convertFunctionPointsToJS(name, keyValues, othersFuzzifications[i].getFunctionPoints()));			
			}
		}
		out.print("));");
	%>

	var selectedFormat;
	$(function(){
		$(".selectedFormats div.format").hide();
		var regExp = /\(([^)]+)\)/;
		var dbName = regExp.exec($("#predNecessary").val())[1];
		$(".dbTarget").html(dbName);
		var regExpFuncName = "((\\w+)\\s*\\()";
		var predNecessary = $("#predNecessary").val().match(regExpFuncName)[2];
		$(".predNecessaryTarget").html(predNecessary);
		$("#predNecessary").change(function() {
			predNecessary = $("#predNecessary").val().split("(")[0];
			$(".predNecessaryTarget").html(predNecessary);
			$("#defineNew #fuzzificationSaveStatus").html("");
		});
		$("#predDefined").keyup(function() {
			var predDefined = $(this).val();
			$(".predDefinedTarget").html(predDefined);
		});
		
		$("#predDefined").keyup(function() {
			if($(this).val() == "") {
				$(".selectedFormats div.format").hide();
				$("input[name='creteriaFormat']").attr("disabled","disabled");
				$("input[name='creteriaFormat']").prop('checked', false);
			} else {
				$("input[name='creteriaFormat']").removeAttr("disabled","disabled");
			}
			$("#defineNew #fuzzificationSaveStatus").html("");
		});
		
		$("input[name='creteriaFormat']").change(function() {
			if($("#predDefined").val() !== "") {
				$(".selectedFormats div.format").hide();
				selectedFormat = $("input[name='creteriaFormat']:checked").val();
				$(".selectedFormats div."+selectedFormat).show();
			} else 
				$(".selectedFormats div.format").hide();
			$("#defineNew #fuzzificationSaveStatus").html("");
		});
		
		$("#saveModification").click(function() {
			if(validation.validate) {
				var fuzzificationSaveStatusId = '<%= KConstants.JspsDivsIds.fuzzificationSaveStatusDivId %>';
				var saveUrl	= '<%= saveUrl %>';
				var predNecessary = $("#predNecessary").val();
				var predDefined = $("#predDefined").val();
				var creteriaFormat = selectedFormat;
				var values = {};
				values.xValue = $("input[id='xPoint']:visible").val();
				values.tValue = $(".selectedFormats .format."+$("input[name='creteriaFormat']:checked").val()+" input#tValue").val();
				values.yPoint = $("input[id='yPoint']:visible").val();
				values.ytValue = $(".selectedFormats .format."+$("input[name='creteriaFormat']:checked").val()+" input#ytValue").val();
				if($("input[name='creteriaFormat']:checked").val() == "mediumFormat") {
					values.zValue = $("input[id='zPoint']:visible").val();
					values.ztValue = $(".selectedFormats .format."+$("input[name='creteriaFormat']:checked").val()+" input#ztValue").val();
					values.wPoint = $("input[id='wPoint']:visible").val();
					values.wtValue = $(".selectedFormats .format."+$("input[name='creteriaFormat']:checked").val()+" input#wtValue").val();
				}
				/* var defaultValueResult = $("#defaultValueResult").val(); */
				var defaultValueResult = null;
				
				updateFuzzification(fuzzificationSaveStatusId, saveUrl, predNecessary, predDefined, creteriaFormat, values, function(){
					$("#auxAndInvisibleSection").dialog("close");
				});
			} else {
				$("#fuzzificationSaveStatus").html(validation.msg);
			}
		});
		
		/* $("#closeDialog").click(function() {
			$("#auxAndInvisibleSection").dialog("close");
		}); */
		
		//Fill values
		var predNecessary = '<%= predNecessary %>';
		var predDefined = '<%= predDefined %>';
		$("#defineNew select#predNecessary").val(predNecessary);
		$("#defineNew select#predNecessary").change();
		$("#defineNew select#predNecessary").attr("disabled","disabled");
		$("#defineNew input#predDefined").val(predDefined.split("(")[0]);
		$("#defineNew input#predDefined").keyup();
		$("#defineNew input#predDefined").attr("disabled","disabled");
		
		var format = '<%= format %>';
		var vals = '<%= jsonVals %>';
		var obj = JSON.parse(vals);
		if(format == "increasing") {
			$("#defineNew input[type='radio'][name='creteriaFormat'][value='increasingFormat']").trigger("click");
			$("#defineNew div.selectedFormats div.format.increasingFormat input#xPoint").val(Object.keys(obj)[0]);
			$("#defineNew div.selectedFormats div.format.increasingFormat input#yPoint").val(Object.keys(obj)[1]);
			var container = document.getElementById("increasingChart");
			drawChart(container,500,200);
		} else if(format == "decreasing") {
			$("#defineNew input[type='radio'][name='creteriaFormat'][value='decreasingFormat']").trigger("click");
			$("#defineNew div.selectedFormats div.format.decreasingFormat input#xPoint").val(Object.keys(obj)[0]);
			$("#defineNew div.selectedFormats div.format.decreasingFormat input#yPoint").val(Object.keys(obj)[1]);
			var container = document.getElementById("decreasingChart");
			drawChart(container,500,200);
		} else if(format == "medium") {
			$("#defineNew input[type='radio'][name='creteriaFormat'][value='mediumFormat']").trigger("click");
			$("#defineNew div.selectedFormats div.format.mediumFormat input#xPoint").val(Object.keys(obj)[0]);
			$("#defineNew div.selectedFormats div.format.mediumFormat input#yPoint").val(Object.keys(obj)[1]);
			$("#defineNew div.selectedFormats div.format.mediumFormat input#zPoint").val(Object.keys(obj)[2]);
			$("#defineNew div.selectedFormats div.format.mediumFormat input#wPoint").val(Object.keys(obj)[3]);
			var container = document.getElementById("mediumChart");
			drawChart(container,500,300);
		}
	});
</script>
<hr>
<div class='personalizationDivFuzzificationFunctionTable'>
	<div id='FuzzificationTable'>
		<div class='personalizationDivFuzzificationFunctionTableRow'>
			<div class='personalizationDivFuzzificationFunctionTableCell2'
				id='<%=KConstants.JspsDivsIds.fuzzificationValuesAndButtonDivId %>'>
				<div class='personalizationDivFuzzificationFunctionWithButtonTable'>
					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div
							class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class="personalizationDivFuzzificationFunctionValuesTableRow">
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										Select the ITEM on which you want create your criteria:
									</div>
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										<select id = 'predNecessary'>
										<%
											for (int i =0; i < programFields[0].length ; i++)
											{
												if (programFields[0][i].getProgramFields() != null)
												{
													for (int j=0;j<programFields[0][i].getProgramFields().length; j++)
													{
														if (programFields[0][i].getProgramFields()[j][1].contains("rfuzzy_integer_type") && programFields[0][i].getProgramFields()[j][0] != null)
														{
															%> <option value='<%=programFields[0][i].getProgramFields()[j][0] + "(" + programFields[0][i].getDatabaseName() + ")"%>'><%=programFields[0][i].getProgramFields()[j][0] + "(" + programFields[0][i].getDatabaseName() + ")"%></option>
														<%}
													}
												}
											}
										%>
										</select>
									</div>
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										Criteria's Name <input type ='text' id = 'predDefined'></input>
									</div>
							</div>
							<hr>
							<div class="creteriaFormats">
							<div align="left"><strong>Choose the correct sentence</strong></div>
								<div class="row">
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										<input type="radio" name="creteriaFormat" value="increasingFormat" disabled="disabled">More <b class="predNecessaryTarget"></b> more <b class="predDefinedTarget">_</b>
									</div>
								</div>
								<div class="row">
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										<input type="radio" name="creteriaFormat" value="decreasingFormat" disabled="disabled">Less <b class="predNecessaryTarget"></b> more <b class="predDefinedTarget">_</b>
									</div>
								</div>
								<div class="row">
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										<input type="radio" name="creteriaFormat" value="mediumFormat" disabled="disabled"> Only for a range of  <b class="predNecessaryTarget"></b> 
									</div>
								</div>
							</div>
							
							<div class="selectedFormats">
							
								<div class="format increasingFormat">
								<hr>
									<div class="personalizationDivFuzzificationFunctionValuesTableRow">
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											What is the MAXIMUM value of <b class="predNecessaryTarget"></b> that is NOT <b class="predDefinedTarget"></b> at all?
										</div>
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' id = 'xPoint'></input>
										</div>&nbsp;&nbsp;
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' min='0' max='1' id='tValue' value="0" style="display: none !important;"></input>
										
										</div>
									</div>
									<div class="personalizationDivFuzzificationFunctionValuesTableRow">
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											What is the MINIMUM value of <b class="predNecessaryTarget"></b> that is COMPLETLY <b class="predDefinedTarget"></b> ?
										</div>
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' id = 'yPoint'></input>
										</div>&nbsp;&nbsp;
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' min='0' max='1' id='ytValue' value="1" style="display: none !important;"></input>
											<!-- <img id="format1" src="images/format1.png"> -->
										</div>
										<div id="increasingChart" style="margin-top: -65px !important"></div>
									</div>
								</div>
								
								<div class="format decreasingFormat">
								<hr>
									<div class="personalizationDivFuzzificationFunctionValuesTableRow">
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											What is the MAXIMUM value of <b class="predNecessaryTarget"></b> that is COMPLETLY <b class="predDefinedTarget"></b> ?
										</div>
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' id = 'xPoint'></input>
										</div>&nbsp;&nbsp;
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' min='0' max='1' id='tValue' value="1" style="display: none !important;"></input>
											
										</div>
									</div>
									<div class="personalizationDivFuzzificationFunctionValuesTableRow">
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											What is the MINIMUM value of <b class="predNecessaryTarget"></b> that is NOT <b class="predDefinedTarget"></b> ?
										</div>
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' id = 'yPoint'></input>
										</div>&nbsp;&nbsp;
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' min='0' max='1' id='ytValue' value="0" style="display: none !important;"></input>
											<!-- <img id="format2" src="images/format2.png"> -->
										</div>
										<div id="decreasingChart" style="margin-top: -65px !important"></div>
									</div>
								</div>
								
								<div class="format mediumFormat">
								<hr>
									<div class="personalizationDivFuzzificationFunctionValuesTableRow">
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											What is the MAXIMUM value of <b class="predNecessaryTarget"></b> that is NOT <b class="predDefinedTarget"></b> at all?
										</div>
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' id = 'xPoint'></input>
										</div>&nbsp;&nbsp;
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' min='0' max='1' id='tValue' value="0" style="display: none !important;"></input>
											
										</div>
									</div>
									<div class="personalizationDivFuzzificationFunctionValuesTableRow">
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											What is the MINIMUM value of <b class="predNecessaryTarget"></b> that is COMPLETLY <b class="predDefinedTarget"></b> ?
										</div>
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' id = 'yPoint'></input>
										</div>&nbsp;&nbsp;
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' min='0' max='1' id='ytValue' value="1" style="display: none !important;"></input>
											
										</div>
									</div>
									<div class="personalizationDivFuzzificationFunctionValuesTableRow">
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											What is the MAXIMUM value of <b class="predNecessaryTarget"></b> that is COMPLETLY <b class="predDefinedTarget"></b> ?
										</div>
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' id = 'zPoint'></input>
										</div>&nbsp;&nbsp;
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' min='0' max='1' id='ztValue' value="1" style="display: none !important;"></input>
											
										</div>
									</div>
									<div class="personalizationDivFuzzificationFunctionValuesTableRow">
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											What is the MINIMUM value of <b class="predNecessaryTarget"></b> that is NOT <b class="predDefinedTarget"></b> ?
										</div>
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' id = 'wPoint'></input>
										</div>&nbsp;&nbsp;
										<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											<input type ='number' min='0' max='1' id='wtValue' value="0" style="display: none !important;"></input>
											<!-- <img id="format3" src="images/format3.png"> -->
										</div>
										<div id="mediumChart" style="margin-top: -173px !important"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
							<div>
							<hr/>
							</div>
        

<%
	JspsUtils.getValue(saveUrl); 
%>

					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class='personalizationDivSaveButtonAndMsgTable'>
								<div class='personalizationDivSaveButtonAndMsgTableRow'>
									<div class='personalizationDivSaveButtonAndMsgTableCell'>
										<!-- <INPUT id="saveModification" type='submit' value='Save modifications'> -->
										<button id="saveModification" type="button" class="btn btn-dark">Save modifications</button>
									</div>
									<div class='personalizationDivSaveButtonAndMsgTableCell'>
										&nbsp;&nbsp;&nbsp;&nbsp;</div>
									<div class='personalizationDivSaveButtonAndMsgTableCell'
										id='<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId %>'>
									</div>
								</div>
							</div>
						</div>
						<div class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class='personalizationDivSaveButtonAndMsgTable'>
								<INPUT id="closeDialog" type="button" value='Exit'>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- END -->