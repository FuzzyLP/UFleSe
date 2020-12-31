package storeHouse;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import auxiliar.Dates;
import filesAndPaths.FilesAndPathsException;
import filesAndPaths.ProgramFileInfo;
import functionUtils.SimilarityFunction;
import managers.FileSharingException;
import managers.FilesManagerAux;
import ontologies.InterfaceOntologyQuery;
import programAnalysis.ProgramPartAnalysis;
import prologConnector.CiaoPrologQueryAnswer;
import prologConnector.ProgramIntrospection;

public class ResultsStoreHouse {

	private HashMap<String, String[]> requestParams = null;
	private String exceptionMsg = null;
	private ArrayList<String> resultMessages = null;
	private ProgramFileInfo[] filesList = new ProgramFileInfo[0];
	private String[] fileContents = null;
	private ProgramFileInfo programFileInfo = null;
	private ProgramPartAnalysis[][] programPartAnalysis = null;
	private ProgramPartAnalysis[][] programPartAnalysis2 = null;
	private ArrayList<ProgramPartAnalysis> programPart = null;
	private String[][] programPartData = null;
	private ProgramIntrospection programIntrospection = null;
	private String[] variablesNames = null;
	private CiaoPrologQueryAnswer[] queryAnswers = new CiaoPrologQueryAnswer[0];
	private ArrayList<InterfaceOntologyQuery> ontologiesQueries = null;
	private List<SimilarityFunction> similarityFnctions = null;

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * Adds a message to the request session attribute msgs.
	 * 
	 * @param msg
	 *            is the message to be added. Cannot be null.
	 */
	public void setExceptionMsg(String exceptionMsg) {
		if ((exceptionMsg != null) && (!"".equals(exceptionMsg))) {
			this.exceptionMsg = Dates.getStringOfCurrentDate() + " " + exceptionMsg;
		}
	}

	public String getExceptionMsg() {
		if (this.exceptionMsg == null) {
			return "";
		}
		return exceptionMsg;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void addResultMessage(String msg) {
		if (msg != null) {
			if (resultMessages == null) {
				resultMessages = new ArrayList<String>();
			}
			resultMessages.add(msg);
		}
	}

	public String[] getResultMessages() {
		if (resultMessages == null) {
			return new String[0];
		}
		return resultMessages.toArray(new String[resultMessages.size()]);
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setFilesList(ProgramFileInfo[] filesList) {
		this.filesList = null;
		if (filesList != null) {
			this.filesList = filesList;
		}
	}

	public ProgramFileInfo[] getFilesList() {
		if (filesList == null) {
			return new ProgramFileInfo[0];
		}
		return filesList;
	}
	
	public List<ProgramFileInfo> getPLFilesList(RequestStoreHouse requestStoreHouse) {
		List<ProgramFileInfo> plFilesList = new ArrayList<ProgramFileInfo>();
		
		if(filesList.length > 0)
			filterPL(filesList,plFilesList);
		
		if(filesList.length == 0 && requestStoreHouse != null && requestStoreHouse.getSession().getLocalUserInfo() != null) {
			FilesManagerAux filesManagerAux = new FilesManagerAux();
			try {
				ProgramFileInfo[] newFilesList = filesManagerAux.list(requestStoreHouse);
				filterPL(newFilesList,plFilesList);
			} catch (RequestStoreHouseException e) {
				e.printStackTrace();
			} catch (FilesAndPathsException e) {
				e.printStackTrace();
			} catch (FileSharingException e) {
				e.printStackTrace();
			}
		}
		return plFilesList;
	}
	private void filterPL(ProgramFileInfo[] sourceList, List<ProgramFileInfo> targetList) {
		for(int i=0;i<=sourceList.length-1;i++)
			if(StringUtils.contains(sourceList[i].getFileName(), ".pl"))
				targetList.add(sourceList[i]);
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setFileContents(String[] fileContents) {
		this.fileContents = null;
		if (fileContents != null) {
			this.fileContents = fileContents;
		}
	}

	public String[] getfileContents() {
		if (fileContents == null) {
			return new String[0];
		}
		return fileContents;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setProgramFileInfo(ProgramFileInfo programFileInfo) {
		this.programFileInfo = null;
		if (programFileInfo != null) {
			this.programFileInfo = programFileInfo;
		}
	}

	public ProgramFileInfo getProgramFileInfo() {
		return programFileInfo;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setProgramPartAnalysis(ProgramPartAnalysis[][] programPartAnalysis) {
		this.programPartAnalysis = null;
		if (programPartAnalysis != null) {
			this.programPartAnalysis = programPartAnalysis;
		}
	}
	
	public ProgramPartAnalysis[][] getProgramPartAnalysis() {
		if (programPartAnalysis == null) {
			return new ProgramPartAnalysis[0][];
		}
		return programPartAnalysis;
	}
	
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setProgramPartAnalysis2(ProgramPartAnalysis[][] programPartAnalysis2) {
		this.programPartAnalysis2 = null;
		if (programPartAnalysis2 != null) {
			this.programPartAnalysis2 = programPartAnalysis2;
		}
	}
	
	public ProgramPartAnalysis[][] getProgramPartAnalysis2() {
		if (programPartAnalysis2 == null) {
			return new ProgramPartAnalysis[0][];
		}
		return programPartAnalysis2;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setProgramPart(ArrayList<ProgramPartAnalysis> programPart) {
		this.programPart = null;
		if (programPart != null) {
			this.programPart = programPart;
		}
	}

	public ArrayList<ProgramPartAnalysis> getProgramPart() {
		return programPart;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setCiaoPrologQueryAnswers(CiaoPrologQueryAnswer[] queryAnswers) {
		this.queryAnswers = new CiaoPrologQueryAnswer[0];
		if (queryAnswers != null) {
			this.queryAnswers = queryAnswers;
		}
	}

	public CiaoPrologQueryAnswer[] getCiaoPrologQueryAnswers() {
		if (queryAnswers == null) {
			return new CiaoPrologQueryAnswer[0];
		}
		return this.queryAnswers;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setCiaoPrologQueryVariablesNames(String[] variablesNames) {
		this.variablesNames = null;
		if (variablesNames != null) {
			this.variablesNames = variablesNames;
		}
	}

	public String[] getCiaoPrologQueryVariablesNames() {
		if (variablesNames == null) {
			return new String[0];
		}
		return this.variablesNames;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setCiaoPrologProgramIntrospection(ProgramIntrospection programIntrospection) {
		this.programIntrospection = null;
		if (programIntrospection != null) {
			this.programIntrospection = programIntrospection;
		}
	}

	public ProgramIntrospection getCiaoPrologProgramIntrospection() {
		return this.programIntrospection;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void setRequestParamsHashMap(HashMap<String, String[]> requestParams) {
		this.requestParams = requestParams;
	}

	public HashMap<String, String[]> getRequestParamsHashMap() {
		return this.requestParams;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void resetOntologyQueryResults() {
		this.ontologiesQueries = null;
	}

	public void addOntologyQueryResults(InterfaceOntologyQuery ontologyQuery) {
		if (this.ontologiesQueries == null) {
			this.ontologiesQueries = new ArrayList<InterfaceOntologyQuery>();
		}
		this.ontologiesQueries.add(ontologyQuery);
	}

	public InterfaceOntologyQuery[] getOntologyQueryResults() {
		if (this.ontologiesQueries == null) {
			return new InterfaceOntologyQuery[0];
		}
		return this.ontologiesQueries.toArray(new InterfaceOntologyQuery[this.ontologiesQueries.size()]);
	}

	public String[][] getProgramPartData() {
		return programPartData;
	}

	public void setProgramPartData(String[][] programPartData) {
		this.programPartData = programPartData;
	}
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public List<SimilarityFunction> getSimilarityFnctions() {
		return similarityFnctions;
	}

	public void setSimilarityFnctions(List<SimilarityFunction> similarityFnctions) {
		this.similarityFnctions = similarityFnctions;
	}

}

// EOF
