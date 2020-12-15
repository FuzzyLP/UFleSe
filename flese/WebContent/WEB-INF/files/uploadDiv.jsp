<%@taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@page import="constants.KConstants"%>
<%@page import="constants.KUrls"%>




<%
	String urlUpload = KUrls.Files.Upload.getUrl(true);
%>


<br />

<div class="container-fluid">
	<div class="row">
    	<div class="col-4">
    		<FORM ID='<%=KConstants.JspsDivsIds.uploadFormId %>'
				ENCTYPE='multipart/form-data' method='POST' accept-charset='UTF-8'
				target='<%=KConstants.JspsDivsIds.uploadFormTargetiFrameId %>'
				action='<%=urlUpload %>'>
				<%-- <INPUT TYPE='file' id='file' style='display:none' NAME='programFileToUpload' size='50'
					onchange='fileUploadAutomaticSendActionOnChange("<%=KConstants.JspsDivsIds.uploadFormId %>", "<%=KConstants.JspsDivsIds.uploadStatusDivId%>");'> --%>
			   	<div class="input-group mb-3">
					<div class="input-group-prepend hidden">
				    	<span class="input-group-text"></span>
				  	</div>
				  	<div class="custom-file">
					    <input id='file' name='programFileToUpload' type="file" class="custom-file-input"  
					    	onchange='fileUploadAutomaticSendActionOnChange("<%=KConstants.JspsDivsIds.uploadFormId %>", "<%=KConstants.JspsDivsIds.uploadStatusDivId%>");'>
					    <label class="custom-file-label" for="inputGroupFile01"></label>
				  	</div>
				</div>
			</FORM>
    	</div>
	    <div class="col">
	    </div>
	    <div class="col">
	    </div>
  	</div>
 </div>

<div id='<%=KConstants.JspsDivsIds.uploadStatusDivId%>'></div>

<iframe id='<%=KConstants.JspsDivsIds.uploadFormTargetiFrameId %>'
	name='<%=KConstants.JspsDivsIds.uploadFormTargetiFrameId%>'
	style='display: none;'></iframe>
<!-- style='display:none;' -->

<script type="text/javascript">
	insertiFrameWindowEvaluationOfJS('<%=KConstants.JspsDivsIds.uploadFormTargetiFrameId %>');
</script>





<!-- END -->