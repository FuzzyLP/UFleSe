<%@page import="auxiliar.JspsUtils"%>
<%@page import="storeHouse.RequestStoreHouse"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.common.base.Splitter"%>

<%
	RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
	ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);
	String [] msgs = resultsStoreHouse.getResultMessages();
	for (int i=0; i<msgs.length; i++) {
		out.println(msgs[i]);
	}
	
	String createdPL = "";
	String query = request.getQueryString().split("\\?")[1];
    final Map<String, String> map = Splitter.on('&').trimResults().withKeyValueSeparator('=').split(query);
    if(map.containsKey("createdPL")) createdPL = map.get("createdPL");
%>

<script type="text/javascript">
var createdPL = '<%= createdPL %>';
if(createdPL != "") {
	window.location.href = window.location.href + "?createdPL=" + createdPL;
}
window.location.reload();

location.reload(true)

</script>

<!-- END -->