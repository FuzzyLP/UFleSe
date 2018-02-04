<%@page import="storeHouse.RequestStoreHouse"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="auxiliar.JspsUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="constants.KUrls"%>
<%@page import="constants.KConstants"%>


<div class="fileViewTable">
	<% 
	RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
	ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);

	String [] msgs = resultsStoreHouse.getResultMessages();
	String fileName = null;
	String fileOwner = null;
	if ((msgs != null) && (msgs.length > 0)) { 
		for (int i=0; i<msgs.length; i++) {
			out.println(msgs[i]);
		}
	} else { 
		String [] fileContents = resultsStoreHouse.getfileContents();
		
		if ((fileContents != null) && (fileContents.length > 0)) {
			boolean csv = false;
			boolean json = false;
			String [] types;
			if (fileContents[0] == null) //FILE IS CSV
			{
				csv = true;
				fileName = fileContents[1];
				fileOwner = fileContents[2];
				String [] aux = new String[fileContents.length - 3];
				for (int i = 0; i<aux.length; i++)
					aux[i] = fileContents[i+3];
				fileContents = aux;
				int numberOfColumns = fileContents[0].split(",").length;
				%>
				Select the types for the columns:
				<br>
				
				<script type="text/javascript">initializeTypes(<%= numberOfColumns%>);</script>
				
				<%
				for(int i = 0; i<numberOfColumns; i++)
				{
					%>
					<form action="types">
					<select name=selectType [<%= i %>] onchange="setType(<%= i %>, this);" />
					  <option value=1>String</option> 
 					  <option value=2>Integer</option> 
 					  <option value=3>Float</option>
  					  <option value=4>Boolean</option> 
  					  <option value=5>Enum</option> 
   				      <option value=6>DateTime</option> 
					</select>
					<%
				}

			}
			for (int i=0; i< fileContents.length; i++) {
%>
	<div class="fileViewTableRow">
		<div class="fileViewTableCell">
			<%= fileContents[i] %>
		</div>
	</div>
	<%
			}
			if (csv)
			{
				String saveUrl = KUrls.Files.Save.getUrl(true)+"&fileName="+fileName+"&fileOwner="+fileOwner;
				%>
				</form>
				<INPUT type='submit' value='Create Prolog file' onclick="createPL('<%=KConstants.JspsDivsIds.convertToProlog%>', '<%=saveUrl%>')">
				</div>
				<div class='personalizationDivSaveButtonAndMsgTableCell' id='<%=KConstants.JspsDivsIds.convertToProlog%>'> </div>
				<%				
				
				return;
			}
			
			if (json)
			{
				String saveUrl = KUrls.Files.Save.getUrl(true)+"&fileName="+fileName+"&fileOwner="+fileOwner;
				%>
				</form>
				<INPUT type='submit' value='Create Prolog file' onclick="createPL('<%=KConstants.JspsDivsIds.convertToProlog%>', '<%=saveUrl%>')">
				</div>
				<div class='personalizationDivSaveButtonAndMsgTableCell' id='<%=KConstants.JspsDivsIds.convertToProlog%>'> </div>
				<%				
				
				return;
			}
			
			
		}
	}
%>

</div>






<!--  END -->
