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
	//String predDefined = requestStoreHouse.getRequestParameter(KConstants.Fuzzifications.predDefined);
	//String predNecessary = requestStoreHouse.getRequestParameter(KConstants.Fuzzifications.predNecessary);
	
	
	ProgramPartAnalysis [][] programFields = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis [] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis [] othersFuzzifications = null;
	String [] keyValues = null;

	/*if (programFields.length >= 1) {
		thisFuzzification = programFields[0];
		keyValues = JspsUtils.getKeyValues(thisFuzzification);
		
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
	
	
	HashMap<String, String> defaultFuzzPoints = defaultFuzzification.getFunctionPoints();
	HashMap<String, String> myFuzzPoints = myFuzzification.getFunctionPoints(); 
	
	*/
	String predDefined = "", predNecessary = "";
	int x, y;

	String saveUrl = KUrls.Fuzzifications.Save.getUrl(true) + 
			"&" + KConstants.Request.fileNameParam + "=" + fileName + 
			"&" + KConstants.Request.fileOwnerParam + "=" + fileOwner +
			"&" + KConstants.Request.mode + "=" + mode;
%>


<script type="text/javascript">
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
		});
		
		$("input[name='creteriaFormat']").change(function() {
			if($("#predDefined").val() !== "") {
				$(".selectedFormats div.format").hide();
				selectedFormat = $("input[name='creteriaFormat']:checked").val();
				$(".selectedFormats div."+selectedFormat).show();
			} else 
				$(".selectedFormats div.format").hide();
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
				saveNewFuzzification(fuzzificationSaveStatusId, saveUrl, predNecessary, predDefined, creteriaFormat, values, defaultValueResult, null /*validateCheckBox()*/, function(){
					$("#auxAndInvisibleSection").dialog("close");
				});
			} else {
				$("#fuzzificationSaveStatus").html(validation.msg);
			}
		});
		
		$("#closeDialog").click(function() {
			$("#auxAndInvisibleSection").dialog("close");
		});
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
							
							<!-- <div class="creteriaFormats">
							<div align="left"><strong>Choose the correct sentence</strong></div>
								<div class="row">
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										<input type="radio" name="creteriaFormat" value="increasingFormat" >When the value of <b class="predNecessaryTarget"></b> is INCREASING then 
										<b class="dbTarget"></b> is becoming MORE <b class="predDefinedTarget">_</b>
									</div>
								</div>
								<div class="row">
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										<input type="radio" name="creteriaFormat" value="decreasingFormat" >When the value of <b class="predNecessaryTarget"></b> is DECREASING then 
										<b class="dbTarget"></b> is becoming MORE <b class="predDefinedTarget">_</b>
									</div>
								</div>
								<div class="row">
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										<input type="radio" name="creteriaFormat" value="mediumFormat" >When the value of <b class="predNecessaryTarget"></b> is BETWEEN a certain interval of values, then  
										the <b class="dbTarget"></b> is <b class="predDefinedTarget">_</b> and when the <b class="predNecessaryTarget"></b> is LOWER/HIGHER than the interval of values, then 
										the <b class="dbTarget"></b> is NOT <b class="predDefinedTarget">_</b>
									</div>
								</div>
							</div> -->
							
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
											<img id="format1" src="images/format1.png">
										</div>
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
											<img id="format2" src="images/format2.png">
											
										</div>
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
													<img id="format3" src="images/format3.png">
										</div>
									</div>
								</div>
							</div>
							<!-- <div class="personalizationDivFuzzificationFunctionValuesTableRow">
								<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											Initial value: x: <input type ='number' id = 'xPoint'></input>
										</div>
								<div class="personalizationDivFuzzificationFunctionValuesTableCell">
								Truth value: <input type ='number' min='0' max='1' id='tValue'></input>
								</div>
							</div>
							<div class="personalizationDivFuzzificationFunctionValuesTableRow">
								<div class="personalizationDivFuzzificationFunctionValuesTableCell">
											Initial value: y: <input type ='number' id = 'yPoint'></input>
										</div>
								<div class="personalizationDivFuzzificationFunctionValuesTableCell">
								Truth value for y: <input type ='number' min='0' max='1' id='ytValue'></input>
								</div>
							</div> -->
							
						</div>
					</div>
					
							<!-- New Code For Default -->
							<div>
							<hr/>
							</div>
							<!-- <div class="row">
							&nbsp;&nbsp;
							<label class="switch">
  							<input type="checkbox" id="toggleButton" onchange="Toggle()" value="0">
  							<span class="slider"></span>
							</label>
							&nbsp;&nbsp;Add Default Value
							</div>
							<div class="row">
							</div>
							<div class="personalizationDivFuzzificationFunctionValuesTableRow hiddenDefault" id="personalizationDivFuzzificationDefaultValues">
							Default Value:  <input type="range" name="defaultValue" min="0" max="1" step="0.01" value="1" width="150px" id="defaultValue">
							<input type="text" id="defaultValueResult">
							</div> -->
							 
        

<%
	JspsUtils.getValue(saveUrl); 
%>

					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class='personalizationDivSaveButtonAndMsgTable'>
								<div class='personalizationDivSaveButtonAndMsgTableRow'>
									<div class='personalizationDivSaveButtonAndMsgTableCell'>
										<INPUT id="saveModification" type='submit' value='Save modifications'>
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