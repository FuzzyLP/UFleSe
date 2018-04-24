<%@page import="storeHouse.RequestStoreHouse"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="auxiliar.JspsUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.*"%>
<%@page import="constants.KUrls"%>
<%@page import="constants.KConstants"%>
<%@page import="org.json.*"%>

<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>

<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>

<%@page import="fileConverters.SQLParser"%>
<%@page import="filesAndPaths.ProgramFileInfo"%>
<%@page import="fileConverters.CSVWriter"%>
<%@page import="fileConverters.JSONFlattener"%>
<%@page import="java.io.File"%>

<div class="fileViewTable">
	<%
		RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
		ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);

		String[] msgs = resultsStoreHouse.getResultMessages();
		String fileName = resultsStoreHouse.getRequestParamsHashMap().get("fileName")[0];
		String fileOwner = resultsStoreHouse.getRequestParamsHashMap().get("fileOwner")[0];
		ProgramFileInfo programFileInfo = requestStoreHouse.getProgramFileInfo();
		String filePath = programFileInfo.getProgramFileFullPath();

		if ((msgs != null) && (msgs.length > 0)) {
			for (int i = 0; i < msgs.length; i++) {
				out.println(msgs[i]);
			}
		} else {
			String[] fileContents = resultsStoreHouse.getfileContents();

			if ((fileContents != null) && (fileContents.length > 0)) {
				boolean csv = false;
				boolean json = false;
				boolean xlsx = false;
				boolean xls = false;
				boolean sql = false;

				String[] types;
				if (fileContents[0] == null) //FILE IS CSV
				{
					csv = true;
					fileName = fileContents[1];
					fileOwner = fileContents[2];
					String[] aux = new String[fileContents.length - 3];
					for (int i = 0; i < aux.length; i++)
						aux[i] = fileContents[i + 3];
					fileContents = aux;
					int numberOfColumns = fileContents[0].split(",").length;
	%>
	Select the types for the columns: <br>

	<script type="text/javascript">initializeTypes(<%=numberOfColumns%>);</script>

	<%
		for (int i = 0; i < numberOfColumns; i++) {
	%>
	<form action="types">
		<select name="selectType [<%=i%>]" onchange="setType(this, <%=i%>);">
			<option value=1>String</option>
			<option value=2>Integer</option>
			<option value=3>Float</option>
			<option value=4>Boolean</option>
			<option value=5>Enum</option>
			<option value=6>DateTime</option>
		</select>
		<%
			}

					} else if (fileName.endsWith("json")) {
						json = true;

						List<Map<String, String>> flatJson = JSONFlattener.parseJson(new File(filePath), "UTF-8");
						Set<String> headers = CSVWriter.collectHeaders(flatJson);
						String[] headerArray = headers.toArray(new String[0]);

						if (headerArray.length > 0) {
							int numberOfColumns = headerArray.length;
		%>
		Select the types for the columns: <br>

		<script type="text/javascript">initializeTypes(<%=numberOfColumns%>);</script>

		<%
			for (int i = 0; i < numberOfColumns; i++) {
		%>
		<form action="types">
			<label><%=headerArray[i]%></label> <select name="selectType [<%=i%>]"
				onchange="setType(this, <%=i%>);">
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

						} else if (fileName.endsWith("sql")) {

							sql = true;

							List<String> columns = new ArrayList<String>();

							columns = SQLParser.parseColumns(filePath);

							if (columns.size() > 0) {
								int numberOfColumns = columns.size();
			%>
			Select the types for the columns: <br>

			<script type="text/javascript">initializeTypes(<%=numberOfColumns%>);</script>

			<%
				for (int i = 0; i < numberOfColumns; i++) {
			%>
			<form action="types">
				<label><%=columns.get(i)%></label> <select
					name="selectType [<%=i%>]" onchange="setType(this, <%=i%>);">
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

							}

							if (fileName.endsWith("xlsx") || fileName.endsWith("xls")) {

								if (fileName.endsWith("xlsx")) {
									xlsx = true;
									InputStream ExcelFileToRead = new FileInputStream(filePath);
									XSSFWorkbook wb = new XSSFWorkbook(ExcelFileToRead);

									XSSFWorkbook test = new XSSFWorkbook();

									XSSFSheet sheet = wb.getSheetAt(0);
									XSSFRow row;
									XSSFCell cell;

									Iterator rows = sheet.rowIterator();

									int i = 0;

									while (rows.hasNext()) {

										row = (XSSFRow) rows.next();
										Iterator cells = row.cellIterator();

										if (i == 0) {

											int numberOfColumns = row.getPhysicalNumberOfCells();
				%>
				Select the types for the columns: <br>

				<script type="text/javascript">initializeTypes(<%=numberOfColumns%>);</script>

				<%
					for (int loop = 0; loop < numberOfColumns; loop++) {
				%>
				<form action="types">
					<select name="selectType [<%=loop%>]"
						onchange="setType(this, <%=loop%>);">
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

											cells = row.cellIterator();
					%>
					<div class="fileViewTableRow">
						<%
							while (cells.hasNext()) {
													cell = (XSSFCell) cells.next();

													if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
						%>
						<div class="fileViewTableCell">
							<%=cell.getStringCellValue() + ", "%>
						</div>
						<%
							} else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
						%>
						<div class="fileViewTableCell">
							<%=((int) cell.getNumericCellValue()) + ", "%>
						</div>
						<%
							} else {
						%>
						<div class="fileViewTableCell">
							<%=cell.getRawValue() + ", "%>
						</div>
						<%
							}
												}
												i++;
						%>
					</div>
					<%
						}
									} else {
										xls = true;
										InputStream ExcelFileToRead = new FileInputStream(filePath);
										HSSFWorkbook wb = new HSSFWorkbook(ExcelFileToRead);

										HSSFSheet sheet = wb.getSheetAt(0);
										HSSFRow row;
										HSSFCell cell;
										int i = 0;
										Iterator rows = sheet.rowIterator();

										while (rows.hasNext()) {
					%>
					<div class="fileViewTableRow">
						<%
							row = (HSSFRow) rows.next();
												if (i == 0) {

													int numberOfColumns = row.getPhysicalNumberOfCells();
						%>
						Select the types for the columns: <br>

						<script type="text/javascript">initializeTypes(<%=numberOfColumns%>);</script>

						<%
							for (int loop = 0; loop < numberOfColumns; loop++) {
						%>
						<form action="types">
							<select name="selectType [<%=loop%>]"
								onchange="setType(this, <%=loop%>);">
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

													Iterator cells = row.cellIterator();

													while (cells.hasNext()) {
														cell = (HSSFCell) cells.next();

														if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
							%>
							<div class="fileViewTableCell">
								<%=cell.getStringCellValue() + ", "%>
							</div>
							<%
								} else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
							%>
							<div class="fileViewTableCell">
								<%=((int) cell.getNumericCellValue()) + ", "%>
							</div>
							<%
								} else {
														}
													}
													i++;
							%>
						
					</div>
					<%
						}
									}
								}

								else {
									for (int i = 0; i < fileContents.length; i++) {
					%>
					<div class="fileViewTableRow">
						<div class="fileViewTableCell">
							<%=fileContents[i]%>
						</div>
					</div>
					<%
						}
								}
								if (csv) {
									String saveUrl = KUrls.Files.Save.getUrl(true) + "&fileName=" + fileName + "&fileOwner="
											+ fileOwner;
					%>
				</form>
				<INPUT type='submit' value='Create Prolog file'
					onclick="createPL('<%=KConstants.JspsDivsIds.convertToProlog%>', '<%=saveUrl%>')">
</div>
<div class='personalizationDivSaveButtonAndMsgTableCell'
	id='<%=KConstants.JspsDivsIds.convertToProlog%>'></div>
<%
	return;
			}

			if (json) {
				String saveUrl = KUrls.Files.SaveJson.getUrl(true) + "&fileName=" + fileName + "&fileOwner="
						+ fileOwner;
%>
</form>
<INPUT type='submit' value='Create Prolog file'
	onclick="createPL('<%=KConstants.JspsDivsIds.convertToProlog%>', '<%=saveUrl%>')">
<div class='personalizationDivSaveButtonAndMsgTableCell'
	id='<%=KConstants.JspsDivsIds.convertToProlog%>'></div>
<%
	return;
			}

			if (xlsx) {
				String saveUrl = KUrls.Files.SaveXLSX.getUrl(true) + "&fileName=" + fileName + "&fileOwner="
						+ fileOwner;
%>
</form>
<INPUT type='submit' value='Create Prolog file'
	onclick="createPL('<%=KConstants.JspsDivsIds.convertToProlog%>', '<%=saveUrl%>')">

<div class='personalizationDivSaveButtonAndMsgTableCell'
	id='<%=KConstants.JspsDivsIds.convertToProlog%>'></div>
<%
	return;
			}

			if (xls) {
				String saveUrl = KUrls.Files.SaveXLS.getUrl(true) + "&fileName=" + fileName + "&fileOwner="
						+ fileOwner;
%>
</form>
<INPUT type='submit' value='Create Prolog file'
	onclick="createPL('<%=KConstants.JspsDivsIds.convertToProlog%>', '<%=saveUrl%>')">

<div class='personalizationDivSaveButtonAndMsgTableCell'
	id='<%=KConstants.JspsDivsIds.convertToProlog%>'></div>
<%
	return;
			}

			if (sql) {
				String saveUrl = KUrls.Files.SaveSQL.getUrl(true) + "&fileName=" + fileName + "&fileOwner="
						+ fileOwner;
%>
</form>
<INPUT type='submit' value='Create Prolog file'
	onclick="createPL('<%=KConstants.JspsDivsIds.convertToProlog%>', '<%=saveUrl%>')">

<div class='personalizationDivSaveButtonAndMsgTableCell'
	id='<%=KConstants.JspsDivsIds.convertToProlog%>'></div>
<%
	return;
			}

		}
	}
%>







<!--  END -->
