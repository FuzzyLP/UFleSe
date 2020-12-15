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
	"&" + KConstants.Request.mode + "=" + mode +
	"&" + KConstants.Fuzzifications.predDefined + "=" + predDefined +
	"&" + KConstants.Fuzzifications.predNecessary + "=" + predNecessary;
	JspsUtils.getValue(saveUrl);
	
	ProgramPartAnalysis [][] fuzzifications = resultsStoreHouse.getProgramPartAnalysis();
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

%>
<div class='personalizationDivFuzzificationFunctionTable'>
	<% if (mode.equals(KConstants.Request.modeAdvanced)) { %>
	<div class='personalizationDivFuzzificationFunctionTableRow'>
		<div class='personalizationDivFuzzificationFunctionTableCell1'
			id='<%=KConstants.JspsDivsIds.fuzzificationGraphicDivId %>'></div>
	</div>
	<% } %>
	<div id='FuzzificationTable'>
		<div class='personalizationDivFuzzificationFunctionTableRow'>
			<div class='personalizationDivFuzzificationFunctionTableCell2'
				id='<%=KConstants.JspsDivsIds.fuzzificationValuesAndButtonDivId %>'>
				<div class='personalizationDivFuzzificationFunctionWithButtonTable'>
					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div
							class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class='personalizationDivFuzzificationFunctionValuesTable' id="table">
								<div
									class='personalizationDivFuzzificationFunctionValuesTableRow'>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										A
										<%= JspsUtils.getFromFuzzificationNameOf(defaultFuzzification, KConstants.Fuzzifications.database, true) %>
										whose value for
										<%= JspsUtils.getFromFuzzificationNameOf(defaultFuzzification, KConstants.Fuzzifications.predNecessary, true) %>
										is
									</div>
									<%-- <div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										is
										<%= JspsUtils.getFromFuzzificationNameOf(defaultFuzzification, KConstants.Fuzzifications.predDefined, true) %>
										with a degree of
									</div>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										Current Value</div>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										<% if (mode.equals(KConstants.Request.modeAdvanced)) { %>
										Old Value
										<% } else { %>
										Default Value
										<% } %>
									</div> --%>
								</div>
	
								<% 
									for (int i=0; i<keyValues.length; i++) { 
										String fuzzificationBarDivId = KConstants.JspsDivsIds.fuzzificationBarValueDivId + "[" + i + "]";
										/* String defaultValue = JspsUtils.getValueFor(keyValues[i], defaultFuzzPoints, defaultFuzzPoints);
										String myValue = JspsUtils.getValueFor(keyValues[i], myFuzzPoints, defaultFuzzPoints); */
								%>
								<div
									class='personalizationDivFuzzificationFunctionValuesTableRow'>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell valToEdit'>
										<input id='valueOf<%= i %>' class="values" data-modified="false" type="number" value ='<%= keyValues[i] %>' onchange="pointChanged('<%= keyValues[i] %>', this,fuzzificationBars[<%= i %>], '<%=fuzzificationBarDivId %>' '<%= KConstants.JspsDivsIds.fuzzificationGraphicDivId %>')"> 
									</div>
									<%-- <div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										<input type='hidden' name='fuzzificationBars[<%= i %>].fpx'
											value='<%= keyValues[i] %>' /> <input type='range'
											name='fuzzificationBars[<%= i %>].fpy' min='0' max='1'
											step='0.01' value='<%= myValue %>' width='150px'
											onchange="barValueChanged(this, '<%=fuzzificationBarDivId %>', '<%= keyValues[i] %>', '<%= KConstants.JspsDivsIds.fuzzificationGraphicDivId %>');" />
									</div>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										<span id='<%=fuzzificationBarDivId %>'><%= myValue %></span>
									</div>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										<%= defaultValue %>
									</div> --%>
								</div>
								<% } %>
								<%-- <div
									class='personalizationDivFuzzificationFunctionValuesTableRow'>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										<input type="number" value ='' onchange="pointCreated(this, '<%= KConstants.JspsDivsIds.fuzzificationGraphicDivId %>','newBar','newSpan','table', '<%=KConstants.JspsDivsIds.fuzzificationBarValueDivId%>')"> 
									</div>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell' id="newBar">
									</div>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										<span id='newSpan'>-1</span>
									</div>
									<div
										class='personalizationDivFuzzificationFunctionValuesTableCell'>
										-1
									</div>
								</div> --%>
							</div>
						</div>
					</div>
	
					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div
							class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class='personalizationDivSaveButtonAndMsgTable'>
								<div class='personalizationDivSaveButtonAndMsgTableRow'>
									<div class='personalizationDivSaveButtonAndMsgTableCell'>
										<<%-- INPUT type='submit' value='Save modifications'
											onclick="saveFuzzification('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId %>', '<%=saveUrl %>')"> --%>
										<button type="button" class="btn btn-dark" 
											onclick="saveFuzzification('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId %>', '<%=saveUrl %>')">Save modifications</button>
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

<div id="MyDiv">You can't modify this fuzzification, Flese is taking care of it for you.
 <br> An user already modified it.</div>

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
	if ((mode.equals(KConstants.Request.modeAdvanced))&&(thisFuzzification.length != 1))
	{
		%> 
		document.getElementById('FuzzificationTable').style.display = "block";
	    document.getElementById('FuzzificationTable').style.display = "none";<%
	} else {
		%> 
		document.getElementById('MyDiv').style.display = "block";
	    document.getElementById('MyDiv').style.display = "none";<%
	}
%>
	
	
	insertFuzzificationGraphicRepresentation('<%= KConstants.JspsDivsIds.fuzzificationGraphicDivId %>');
	
	$("input.values").on("change paste keyup", function(){
	   if($(this).attr("value") != $(this).val())
	      $(this).attr("data-modified",true);
	   else
	      $(this).attr("data-modified",false);
	});
	
</script>

<!-- END -->