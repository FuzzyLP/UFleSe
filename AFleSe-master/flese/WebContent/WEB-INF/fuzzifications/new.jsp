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

%>
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
										Select column and name for the fuzzification:
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
										Function Name <input type ='text' id = 'predDefined'></input>
									</div>
							</div>
							<div class="personalizationDivFuzzificationFunctionValuesTableRow">
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
							</div>
							
						</div>
					</div>
					
							<!-- New Code For Default -->
							<div>
							<hr/>
							</div>
							<div class="row">
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
							</div>
        
	<%
	
 String saveUrl = KUrls.Fuzzifications.Save.getUrl(true) + 
			"&" + KConstants.Request.fileNameParam + "=" + fileName + 
			"&" + KConstants.Request.fileOwnerParam + "=" + fileOwner +
			"&" + KConstants.Request.mode + "=" + mode;
JspsUtils.getValue(saveUrl); 
%>
					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div
							class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class='personalizationDivSaveButtonAndMsgTable'>
								<div class='personalizationDivSaveButtonAndMsgTableRow'>
									<div class='personalizationDivSaveButtonAndMsgTableCell'>
										<INPUT type='submit' value='Save modifications'
											onclick="saveNewFuzzification('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId %>', '<%=saveUrl %>', predNecessary, predDefined, xPoint, tValue, yPoint, ytValue, defaultValueResult, validateCheckBox())">
									</div>
									<div class='personalizationDivSaveButtonAndMsgTableCell'>
										&nbsp;&nbsp;&nbsp;&nbsp;</div>
									<div class='personalizationDivSaveButtonAndMsgTableCell'
										id='<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId %>'>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- END -->