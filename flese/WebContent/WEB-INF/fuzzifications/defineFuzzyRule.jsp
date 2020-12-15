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
	
	ProgramPartAnalysis[][] fuzzifications = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis [][] programFields = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis [] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis [] othersFuzzifications = null;
	String [] keyValues = null;
	
	String predDefined = "", predNecessary = "";
	int x, y;

	String saveUrl = KUrls.Fuzzifications.DefineFuzzRule.getUrl(true) + 
			"&" + KConstants.Request.fileNameParam + "=" + fileName + 
			"&" + KConstants.Request.fileOwnerParam + "=" + fileOwner +
			"&" + KConstants.Request.mode + "=" + mode;
%>

<style>
	.predicatesTable {
	    border: none;
	    width: 80%;
	}
	.predicatesTable td {
	    min-width: 10px;
	}
	.predicatesLabel, .credibilityLabel {
		float: left;
	}
	#addFuzzyPredicate, #addCredibility {
		float: left;
    	margin-left: 10px;
	}
	#predNecessary {
		float: left;
	}
	.predicateSpan {
		float: left;
	}
	.removePredicate {
	    float: right;
	}
	#credibilityDetail {
		float: left;
		text-align: left;
	}
	#credibilityValueTxt {
	    width: 90px;
	}
	#credibilityValue {
	    width: 170px;
	}
	#fuzzyPredicates {
	    background-color: white;
	    border-radius: 10px;
	    display: none;
	    padding: 11px;
	}
	.predicateDiv:not(:last-child) {
		margin-bottom: 5px;
	}
</style>

<script type="text/javascript">
	var selectedFormat;
	$(function(){
		$("#saveModification").click(function() {
			var fuzzyRuleName = $("#fuzzyRuleName").val();
			var agregatorOperator = $("#agregatorOperator").val();
			var predicates = [];
			var regExp = /\(([^)]+)\)/;
			var dbName;
			$("#fuzzyPredicates div").each(function(i, div) {
				predicates.push($(div).attr("data-predicate"));
				if(i == 0) dbName = regExp.exec($(div).attr("data-predicate"))[1];
			});
			if(fuzzyRuleName !== "" && agregatorOperator !== "" && predicates.length > 0) {
				var credibilityOperator = $("#credibilityOperator").val();
				var credibilityValue = $("#credibilityValue").val();
				var fuzzificationSaveStatusId = '<%= KConstants.JspsDivsIds.fuzzificationSaveStatusDivId %>';
				var saveUrl	= '<%= saveUrl %>';
				defineNewFuzzyRule(fuzzificationSaveStatusId, saveUrl, dbName, fuzzyRuleName, agregatorOperator, predicates, credibilityOperator, credibilityValue, function(){
					$("#auxAndInvisibleSection").dialog("close");
				});
			} else {
				$("#fuzzificationSaveStatus").html(validation.msg);
			}
		});
		
		/* $("#closeDialog").click(function() {
			$("#auxAndInvisibleSection").dialog("close");
		}); */
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
						<div class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class="personalizationDivFuzzificationFunctionValuesTableCell">
								Define fuzzy rule name <input type ='text' id = 'fuzzyRuleName'></input>
							</div>
							<!-- <hr> -->
							<br>
							
							<div class="personalizationDivFuzzificationFunctionValuesTableCell">
								Define the agregator operator
								<select id="agregatorOperator">
									<option value=""></option>
									<option value="min">Min</option>
									<option value="max">Max</option>
									<option value="prod">Prod</option>
									<option value="luka">Luka</option>
									<option value="dprod">dProd</option>
									<option value="dluka">dLuka</option>
								</select>
							</div>
							<!-- <hr> -->
							<br>
							
							<div class="personalizationDivFuzzificationFunctionValuesTableCell">
								<label class="predicatesLabel">Select the fuzzy predicates</label>
								<span id="addFuzzyPredicate">
									<img src="images/add.png" width="20" alt="Add fuzzy predicate" title="Add fuzzy predicate" />
								</span>
								<table class="predicatesTable">
							 		<tr>
							 			<td valign="top">
							 				<select id="predNecessary" style="display: none;">
							 					<option value=""></option>
												<%
													for (int i = 0; i < fuzzifications.length; i++) {
														if ((fuzzifications[i] != null) && (fuzzifications[i].length > 0)) {
															ProgramPartAnalysis fuzzification = fuzzifications[i][0];
															predNecessary = fuzzification.getPredDefined();
															String fuzzyPredicate = fuzzification.getPredDefined().substring(0,fuzzification.getPredDefined().indexOf("("));
												%>
												<option value='<%=predNecessary%>'><%=fuzzyPredicate%></option>
												<%
														}
													}
												%>
											</select>
							 			</td>
							 			<td><div id="fuzzyPredicates"></div></td>
							 		</tr>
								</table>
							</div>
							<!-- <hr> -->
							<br>
							
							<div class="personalizationDivFuzzificationFunctionValuesTableCell">
								<label class="credibilityLabel">Do you want to define credibility for this rule?</label>
								<span id="addCredibility">
									<img src="images/add.png" width="20" alt="Add credibility" title="Add credibility" />
								</span><br><br>
								<div id="credibilityDetail" style="display: none;">
									Define credibility operator
									<select id="credibilityOperator">
										<option value=""></option>
										<option value="min">Min</option>
										<option value="max">Max</option>
										<option value="prod">Prod</option>
										<option value="luka">Luka</option>
										<option value="dprod">dProd</option>
										<option value="dluka">dLuka</option>
									</select>
									<br><br>
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										How much this rule is credible?</div>
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										<input type="range" name="defaultValue" min="0" max="1" step="0.01"
											value="0.5" width="150px" id="credibilityValue">
									</div>
									<div class="personalizationDivFuzzificationFunctionValuesTableCell">
										<input type="text" id="credibilityValueTxt" value="0.5">
									</div>
								</div>
							</div>
							<!-- <hr> -->
							<br>
							
						</div>
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
										<INPUT id="saveModification" type='submit' value='Save'>
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