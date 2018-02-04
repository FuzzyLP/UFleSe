<%@page import="programAnalysis.FunctionPoint"%>
<%@page import="programAnalysis.ProgramAnalysis"%>
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

	ProgramPartAnalysis[][] programFields = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis[] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis[] othersFuzzifications = null;
	String[] keyValues = null;

	String defineModifier = "define_modifier(rather/2, TV_In, TV_Out) :- TV_Out .=. TV_In * TV_In </br>define_modifier(very/2, TV_In, TV_Out) :- TV_Out .=. TV_In * TV_In * TV_In </br>define_modifier(little/2, TV_In, TV_Out) :- TV_Out * TV_Out .=. TV_In </br>define_modifier(very_little/2, TV_In, TV_Out) :- TV_Out * TV_Out * TV_Out .=. TV_In";
	String defineModifierShow = "define_modifier(rather/2, TV_In, TV_Out) :- TV_Out .=. TV_In * TV_In. \ndefine_modifier(very/2, TV_In, TV_Out) :- TV_Out .=. TV_In * TV_In * TV_In. \ndefine_modifier(little/2, TV_In, TV_Out) :- TV_Out * TV_Out .=. TV_In. \ndefine_modifier(very_little/2, TV_In, TV_Out) :- TV_Out * TV_Out * TV_Out .=. TV_In.";
	
	int x, y;
%>

<div>
	<hr />
</div>
<textarea rows="5" cols="100" readonly id="fuzzificationAddModifierText"><%=defineModifierShow%></textarea>


<%
	String saveUrl = KUrls.Fuzzifications.SaveModifier.getUrl(true) + "&" + KConstants.Request.fileNameParam + "="
			+ fileName + "&" + KConstants.Request.fileOwnerParam + "=" + fileOwner + "&"
			+ KConstants.Request.mode + "=" + mode;
	JspsUtils.getValue(saveUrl);
%>
<div class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
	<div class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
		<div class='personalizationDivSaveButtonAndMsgTable'>
			<div class='personalizationDivSaveButtonAndMsgTableRow'>
				<div class='personalizationDivSaveButtonAndMsgTableCell'>
					<input type='submit' value='Save modifications'
						onclick="saveModifier('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>', '<%=saveUrl%>', '<%=defineModifier%>')">
				</div>
				<div class='personalizationDivSaveButtonAndMsgTableCell'>
					&nbsp;&nbsp;&nbsp;&nbsp;</div>
				<div class='personalizationDivSaveButtonAndMsgTableCell'
					id='<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>'>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- END -->