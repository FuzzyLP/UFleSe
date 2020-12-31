package managers;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;

import com.google.common.base.Splitter;

import auxiliar.NextStep;
import constants.KConstants;
import constants.KUrls;
import conversors.QueryConversorException;
import filesAndPaths.FilesAndPathsException;
import filesAndPaths.ProgramFileInfo;
import programAnalysis.ProgramAnalysis;
import programAnalysis.ProgramPartAnalysis;
import prologConnector.CiaoPrologConnectorException;
import prologConnector.CiaoPrologNormalQuery;
import prologConnector.CiaoPrologProgramIntrospectionQuery;
import prologConnector.CiaoPrologQueryAnswer;
import prologConnector.CiaoPrologTestingQuery;
import prologConnector.PlConnectionEnvelopeException;
import prologConnector.ProgramIntrospection;
import storeHouse.RequestStoreHouseException;

public class QueriesManager extends AbstractManager {

	public QueriesManager() {
		super();
	}

	@Override
	public String methodToInvokeIfMethodRequestedIsNotAvailable() {
		return "selectProgramFile";
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public void selectProgramFile() throws FilesAndPathsException, RequestStoreHouseException, FileSharingException {
		ProgramFileInfo[] filesList = FilesManagerAux.list(requestStoreHouse);
		resultsStoreHouse.setFilesList(filesList);

		// Forward to the jsp page.
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.SelectProgramFilePage, ""));
	}

	public void programFileActions() throws FilesAndPathsException, RequestStoreHouseException {
		ProgramFileInfo programFileInfo = requestStoreHouse.getProgramFileInfo();
		resultsStoreHouse.setProgramFileInfo(programFileInfo);
		// Forward to the jsp page.
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.ProgramFileActionsPage, ""));
	}

	public void selectQueryStartType() throws Exception {
		CiaoPrologProgramIntrospectionQuery ciaoPrologProgramIntrospectionQuery = CiaoPrologProgramIntrospectionQuery
				.getInstance(requestStoreHouse);
		ProgramIntrospection programIntrospection = ciaoPrologProgramIntrospectionQuery.getProgramIntrospection();
		resultsStoreHouse.setCiaoPrologProgramIntrospection(programIntrospection);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.SelectQueryStartTypePage, ""));
	}

	public void selectQuery() throws Exception {
		CiaoPrologProgramIntrospectionQuery ciaoPrologProgramIntrospectionQuery = CiaoPrologProgramIntrospectionQuery
				.getInstance(requestStoreHouse);
		ProgramIntrospection programIntrospection = ciaoPrologProgramIntrospectionQuery.getProgramIntrospection();
		resultsStoreHouse.setCiaoPrologProgramIntrospection(programIntrospection);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.SelectQueryPage, ""));
	}

	public void selectQueryAddLine() throws Exception {
		CiaoPrologProgramIntrospectionQuery ciaoPrologProgramIntrospectionQuery = CiaoPrologProgramIntrospectionQuery
				.getInstance(requestStoreHouse);
		ProgramIntrospection programIntrospection = ciaoPrologProgramIntrospectionQuery.getProgramIntrospection();
		resultsStoreHouse.setCiaoPrologProgramIntrospection(programIntrospection);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.SelectQueryAddLinePage, ""));
	}

	public void selectQueryAddAggr() throws Exception {
		CiaoPrologProgramIntrospectionQuery ciaoPrologProgramIntrospectionQuery = CiaoPrologProgramIntrospectionQuery
				.getInstance(requestStoreHouse);
		ProgramIntrospection programIntrospection = ciaoPrologProgramIntrospectionQuery.getProgramIntrospection();
		resultsStoreHouse.setCiaoPrologProgramIntrospection(programIntrospection);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.SelectQueryAddAggrPage, ""));
	}

	public void selectNegation() throws Exception {
		CiaoPrologProgramIntrospectionQuery ciaoPrologProgramIntrospectionQuery = CiaoPrologProgramIntrospectionQuery
				.getInstance(requestStoreHouse);
		ProgramIntrospection programIntrospection = ciaoPrologProgramIntrospectionQuery.getProgramIntrospection();
		resultsStoreHouse.setCiaoPrologProgramIntrospection(programIntrospection);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.SelectNegationPage, ""));
	}

	public void selectModifier() throws Exception {
		List<Map<String, String>> fuzzyFunctions = new ArrayList<Map<String, String>>();
		CiaoPrologProgramIntrospectionQuery ciaoPrologProgramIntrospectionQuery = CiaoPrologProgramIntrospectionQuery
				.getInstance(requestStoreHouse);
		ProgramIntrospection programIntrospection = ciaoPrologProgramIntrospectionQuery.getProgramIntrospection();
		resultsStoreHouse.setCiaoPrologProgramIntrospection(programIntrospection);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.SelectModifierPage, ""));
	}
	
	private <K, V> K getKey(Map<K, V> map, String value) {
	    for (Entry<K, V> entry : map.entrySet()) {
	        if (entry.getValue().equals(value)) {
	            return entry.getKey();
	        }
	    }
	    return null;
	}

	public void selectOperator() throws Exception {
		CiaoPrologProgramIntrospectionQuery ciaoPrologProgramIntrospectionQuery = CiaoPrologProgramIntrospectionQuery
				.getInstance(requestStoreHouse);
		ProgramIntrospection programIntrospection = ciaoPrologProgramIntrospectionQuery.getProgramIntrospection();
		resultsStoreHouse.setCiaoPrologProgramIntrospection(programIntrospection);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.SelectOperatorPage, ""));
	}

	public void selectValue() throws Exception {
		CiaoPrologProgramIntrospectionQuery ciaoPrologProgramIntrospectionQuery = CiaoPrologProgramIntrospectionQuery
				.getInstance(requestStoreHouse);
		ProgramIntrospection programIntrospection = ciaoPrologProgramIntrospectionQuery.getProgramIntrospection();
		resultsStoreHouse.setCiaoPrologProgramIntrospection(programIntrospection);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.SelectValuePage, ""));
	}

	public void evaluate() throws Exception {
		CiaoPrologQueryAnswer[] queryAnswers = new CiaoPrologQueryAnswer[0];
		String[] queryVariablesNames = new String[0];
		try {
			CiaoPrologNormalQuery query = CiaoPrologNormalQuery.getInstance(requestStoreHouse);
			queryAnswers = query.getQueryAnswers();
			queryVariablesNames = query.getVariablesNames();
		} catch (QueryConversorException e) {
			queryAnswers = new CiaoPrologQueryAnswer[0];
			queryVariablesNames = new String[0];
			String msg = e.getMessage();
			resultsStoreHouse.addResultMessage(msg);
		} catch (CiaoPrologConnectorException e) {
			queryAnswers = new CiaoPrologQueryAnswer[0];
			queryVariablesNames = new String[0];
			String msg = e.getMessage();
			resultsStoreHouse.addResultMessage(msg);
		} catch (PlConnectionEnvelopeException e) {
			queryAnswers = new CiaoPrologQueryAnswer[0];
			queryVariablesNames = new String[0];
			String msg = e.getMessage();
			resultsStoreHouse.addResultMessage(msg);
		}
		CiaoPrologProgramIntrospectionQuery ciaoPrologProgramIntrospectionQuery = CiaoPrologProgramIntrospectionQuery
				.getInstance(requestStoreHouse);
		ProgramIntrospection programIntrospection = ciaoPrologProgramIntrospectionQuery.getProgramIntrospection();
		ProgramAnalysis pAnalysis = ProgramAnalysis.getProgramAnalysisClass(programIntrospection.getProgramFileInfo());
		//String parameterString = requestStoreHouse.getRequestParametersString();
		//parameterString = StringUtils.replacePattern(parameterString, ".operator=*&", ".operator=X");
		//final String keyPattern = "\\S+";
		//final String valuePattern = "(\\S+|\"[*\"]*\")";
		//Map<String, String> parametersMap = Splitter.onPattern(keyPattern + "=" + valuePattern).withKeyValueSeparator("=").split(requestStoreHouse.getRequestParametersString());
		Map<String, String[]> parametersMap = requestStoreHouse.getRequest().getParameterMap();
		for (Map.Entry<String,String[]> parameterMap : parametersMap.entrySet()) {
			if(StringUtils.startsWith(parameterMap.getKey(), "queryLine[")) {
				if(!parametersMap.containsKey(StringUtils.replace(parameterMap.getKey(), ".pred", ".negation")))
					for(ProgramPartAnalysis pPArtAnalysis : pAnalysis.getProgramParts()) {
						if(StringUtils.isNotBlank(pPArtAnalysis.getPredDefined())
								&& StringUtils.isNotBlank(pPArtAnalysis.getPredNecessary())
								&& StringUtils.equals(StringUtils.split(pPArtAnalysis.getPredDefined(), "(")[0], parameterMap.getValue()[0])
								&& pPArtAnalysis.getFunctionPoints() != null 
								&& !pPArtAnalysis.getFunctionPoints().isEmpty()) {
							String predName = pPArtAnalysis.getPredDefined();
							if(requestStoreHouse.getRequestParameter(this.getKey(parametersMap, new String(predName))) != null) {
								String pred = StringUtils.split(pPArtAnalysis.getPredNecessary(), "(")[0];
								for(int i=0;i<queryAnswers.length;i++) {
									if(queryAnswers[i].getCiaoPrologQueryVariableAnswer(pred) != null
											&& StringUtils.isNumeric(queryAnswers[i].getCiaoPrologQueryVariableAnswer(pred).toString())) {
										float predValue = Float.valueOf(queryAnswers[i].getCiaoPrologQueryVariableAnswer(pred).toString());
										float trueValue = Float.valueOf(this.getKey(pPArtAnalysis.getFunctionPoints(), "1"));
	//									float falseValue = Float.valueOf(this.getKey(pPArtAnalysis.getFunctionPoints(), "0"));
										if(StringUtils.equals(pPArtAnalysis.getFunctionFormat(), "decreasing")) {
		//									if(requestStoreHouse.getRequestParameter(this.getKey(requestStoreHouse.getRequest().getParameterMap(), "cheap") != null)
		//											&& requestStoreHouse.getRequestParameter(this.getKey(requestStoreHouse.getRequest().getParameterMap(), "cheap") == "fnot") {
		//									}
											if(predValue <= trueValue) {
												PropertyUtils.setProperty(queryAnswers[i].getVarsAnswers(), "Truth Value", "1");
											}
										}
										else if(StringUtils.equals(pPArtAnalysis.getFunctionFormat(), "increasing")) {
											if(predValue >= trueValue) {
												PropertyUtils.setProperty(queryAnswers[i].getVarsAnswers(), "Truth Value", "1");
											}
										}
									}
								}
							}
						}
					}
			}
		}
		resultsStoreHouse.setCiaoPrologQueryAnswers(queryAnswers);
		resultsStoreHouse.setCiaoPrologQueryVariablesNames(queryVariablesNames);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.EvaluatePage, ""));
	}
	
	public void test() throws Exception {
		CiaoPrologTestingQuery query = CiaoPrologTestingQuery.getInstance(requestStoreHouse.getProgramFileInfo());
		CiaoPrologQueryAnswer[] queryAnswers = query.getQueryAnswers();
		resultsStoreHouse.setCiaoPrologQueryAnswers(queryAnswers);
		setNextStep(new NextStep(KConstants.NextStep.forward_to, KUrls.Queries.EvaluatePage, ""));
	}

}
