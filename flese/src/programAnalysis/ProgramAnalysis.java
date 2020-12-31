package programAnalysis;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import auxiliar.LocalUserInfo;
import constants.ArrayStructure;
import constants.KConstants;
import filesAndPaths.FilesAndPathsException;
import filesAndPaths.ProgramFileInfo;
import functionUtils.SimilarityFunction;
import storeHouse.CacheStoreHouse;
import storeHouse.CacheStoreHouseCleaner;
import storeHouse.CacheStoreHouseException;
import storeHouse.RequestStoreHouse;

public class ProgramAnalysis {
	final Log LOG = LogFactory.getLog(ProgramAnalysis.class);

	private ProgramFileInfo programFileInfo;
	private ArrayList<ProgramPartAnalysis> programParts = null;

	public ArrayList<ProgramPartAnalysis> getProgramParts() {
		return programParts;
	}

	public void setProgramParts(ArrayList<ProgramPartAnalysis> programParts) {
		this.programParts = programParts;
	}

	private ProgramPartAnalysis[][] programFunctionsOrdered = null;
	private LinkedList<ProgramPartAnalysis> programFields = new LinkedList<ProgramPartAnalysis>();

	private List<SimilarityFunction> programSimilarityFnctions = null;

	/**
	 * Analizes the program file pointed by filePath.
	 * 
	 * @param requestStoreHouse
	 * @throws Exception
	 *             when any of the previous is null or empty string.
	 */
	private ProgramAnalysis(ProgramFileInfo programFileInfo) throws Exception {

		this.programFileInfo = programFileInfo;

		LOG.info("\n filePath: " + programFileInfo.getProgramFileFullPath());

		programParts = new ArrayList<ProgramPartAnalysis>();

		BufferedReader reader = new BufferedReader(new FileReader(programFileInfo.getProgramFileFullPath()));

		String line;
		ProgramPartAnalysis programPart = null;
		boolean continues = false;

		while ((line = reader.readLine()) != null) {
			while (line != null) {
				if (!continues) {
					programPart = new ProgramPartAnalysis();
				}
				line = programPart.parse(line);
			}
			continues = programPart.partIsIncomplete();
			if (!continues) {
				programParts.add(programPart);
				if (programPart.isFieldsDef()) {
					programFields.add(programPart);
				}

			}
		}
		reader.close();

	}

	public static ProgramAnalysis getProgramAnalysisClass(ProgramFileInfo programFileInfo) throws Exception {
		String fullPath = programFileInfo.getProgramFileFullPath();

		Object o = CacheStoreHouse.retrieve(ProgramAnalysis.class, fullPath, fullPath, fullPath, true);
		ProgramAnalysis object = (ProgramAnalysis) o;
		// object = null;
		if (object == null) {
			object = new ProgramAnalysis(programFileInfo);
			object.getProgramFuzzifications();
			CacheStoreHouse.store(ProgramAnalysis.class, fullPath, fullPath, fullPath, object, true);
		}
		return object;
	}

	public static ProgramAnalysis getProgramAnalysisClass2(ProgramFileInfo programFileInfo) throws Exception {
		String fullPath = programFileInfo.getProgramFileFullPath();

		Object o = CacheStoreHouse.retrieve(ProgramAnalysis.class, fullPath, fullPath, fullPath, true);
		ProgramAnalysis object = (ProgramAnalysis) o;
		// object = null;
		if (object == null) {
			object = new ProgramAnalysis(programFileInfo);
			object.getProgramFuzzifications();
			CacheStoreHouse.store(ProgramAnalysis.class, fullPath, fullPath, fullPath, object, true);
		}
		return object;
	}

	public static void clearCacheInstancesFor(ProgramFileInfo programFileInfo)
			throws FilesAndPathsException, CacheStoreHouseException {
		String fullPath = programFileInfo.getProgramFileFullPath();

		CacheStoreHouse.store(ProgramAnalysis.class, fullPath, fullPath, fullPath, null, true);
	}

	public List<SimilarityFunction> getSimilarityFunctions() throws Exception {

		LOG.info("getSimilarityFunctions");
		if (programParts == null)
			throw new Exception("programParts is null.");

		// Cache.
		if (programSimilarityFnctions != null) {
			return programSimilarityFnctions;
		}

		programSimilarityFnctions = new ArrayList<SimilarityFunction>();

		for (int i = 0; i < programParts.size(); i++) {
			ProgramPartAnalysis programPart = programParts.get(i);
			if (programPart.getHead() != null
					&& programPart.getHead().startsWith(KConstants.Fuzzifications.similarityFunction)) {
				SimilarityFunction parsedSimilarity = parseSimilarity(programPart.getHead());
				if (parsedSimilarity != null && !parsedSimilarity.getDatabaseName().equals("_")) {
					programSimilarityFnctions.add(parsedSimilarity);
				}
			}
		}

		return programSimilarityFnctions;
	}

	private ProgramPartAnalysis[][] getProgramFuzzifications() throws Exception {

		LOG.info("getProgramFuzzifications");
		if (programParts == null)
			throw new Exception("programParts is null.");

		// Cache.
		if (programFunctionsOrdered != null) {
			return programFunctionsOrdered;
		}

		ArrayList<HashMap<String, ProgramPartAnalysis>> progrFunctsOrdered = new ArrayList<HashMap<String, ProgramPartAnalysis>>();
		ProgramPartAnalysis programPart = null;
		int i = 0, j = 0;

		for (i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);
			if (programPart.isFunction()) {
				boolean placed = false;

				j = 0;
				while ((j < progrFunctsOrdered.size()) && (!placed)) {
					if ((progrFunctsOrdered.get(j) != null) && (progrFunctsOrdered.get(j).size() > 0)) {
						Collection<String> keysTmp = progrFunctsOrdered.get(j).keySet();
						String[] keys = keysTmp.toArray(new String[keysTmp.size()]);
						ProgramPartAnalysis representative = progrFunctsOrdered.get(j).get(keys[0]);

						if (representative != null
								&& (representative.getPredDefined().equals(programPart.getPredDefined()))
								&& (representative.getPredNecessary().equals(programPart.getPredNecessary()))) {

							progrFunctsOrdered.get(j).put(programPart.getKeyForHashMap(), programPart);
							placed = true;
						}
					}
					j++;
				}
				if (!placed) {
					HashMap<String, ProgramPartAnalysis> current = new HashMap<String, ProgramPartAnalysis>();
					current.put(programPart.getKeyForHashMap(), programPart);
					progrFunctsOrdered.add(current);
					placed = true;
				}
			}
			/*
			 * else { LOG.info("Not a function. programPart.getHead(): " +
			 * programPart.getHead()); String [] lines = programPart.getLines();
			 * String line = ""; for (int k = 0; k< lines.length; k++) { line +=
			 * lines[k] + "\n"; } LOG.info(line); }
			 */
		}

		programFunctionsOrdered = new ProgramPartAnalysis[progrFunctsOrdered.size()][];

		for (i = 0; i < progrFunctsOrdered.size(); i++) {
			HashMap<String, ProgramPartAnalysis> tmp1 = progrFunctsOrdered.get(i);
			Collection<ProgramPartAnalysis> tmp2 = tmp1.values();
			programFunctionsOrdered[i] = tmp2.toArray(new ProgramPartAnalysis[tmp2.size()]);
		}
		return programFunctionsOrdered;
	}

	public ProgramPartAnalysis[][] getAllProgramFuzzifications(LocalUserInfo localUserInfo, String predDefined,
			String predNecessary, String mode) throws Exception {

		if (predDefined == null) {
			predDefined = "";
		}

		if (predNecessary == null) {
			predNecessary = "";
		}

		if ((mode == null) || ("".equals(mode))) {
			mode = KConstants.Request.modeBasic;
		}

		if (programFunctionsOrdered == null) {
			getProgramFuzzifications();
		}

		ProgramPartAnalysis function = null;
		ArrayList<ArrayList<ProgramPartAnalysis>> filteredResults = new ArrayList<ArrayList<ProgramPartAnalysis>>();
		ArrayList<ProgramPartAnalysis> filteredResult = null;

		for (int i = 0; i < programFunctionsOrdered.length; i++) {
			filteredResult = new ArrayList<ProgramPartAnalysis>();

			for (int j = 0; j < programFunctionsOrdered[i].length; j++) {
				function = programFunctionsOrdered[i][j];

				if ((predDefined.equals("") || (predDefined.equals(function.getPredDefined())))) {
					if ((predNecessary.equals("") || (predNecessary.equals(function.getPredNecessary())))) {
						if (function.getPredOwner().equals(KConstants.Fuzzifications.DEFAULT_DEFINITION)) {
							// The default definition is always retrieved.
							filteredResult.add(function);
						} else {
							if ((KConstants.Request.modeAdvanced.equals(mode))
									|| (function.getPredOwner().equals(localUserInfo.getLocalUserName()))) {
								// If the mode is not advanced and the logged
								// user is the fuzzification owner,
								// retrieve it too.
								filteredResult.add(function);
							}
						}
					}
				}
			}

			if (filteredResult.size() > 0) {
				filteredResults.add(filteredResult);
			}
		}

		ProgramPartAnalysis[][] results = new ProgramPartAnalysis[filteredResults.size()][];
		for (int i = 0; i < filteredResults.size(); i++) {
			results[i] = filteredResults.get(i).toArray(new ProgramPartAnalysis[filteredResults.get(i).size()]);
		}
		return results;
	}

	public ProgramPartAnalysis[][] getProgramFuzzifications(LocalUserInfo localUserInfo, String predDefined,
			String predNecessary, String mode) throws Exception {

		if (predDefined == null) {
			predDefined = "";
		}

		if (predNecessary == null) {
			predNecessary = "";
		}

		if ((mode == null) || ("".equals(mode))) {
			mode = KConstants.Request.modeBasic;
		}

		// If logged user is not the file owner then edition mode is always
		// basic.
		if (!(programFileInfo.getFileOwner().equals(localUserInfo.getLocalUserName()))) {
			mode = KConstants.Request.modeBasic;
		}

		if (programFunctionsOrdered == null) {
			getProgramFuzzifications();
		}

		ProgramPartAnalysis function = null;
		ArrayList<ArrayList<ProgramPartAnalysis>> filteredResults = new ArrayList<ArrayList<ProgramPartAnalysis>>();
		ArrayList<ProgramPartAnalysis> filteredResult = null;

		for (int i = 0; i < programFunctionsOrdered.length; i++) {
			filteredResult = new ArrayList<ProgramPartAnalysis>();

			for (int j = 0; j < programFunctionsOrdered[i].length; j++) {
				function = programFunctionsOrdered[i][j];

				if ((predDefined.equals("") || (predDefined.equals(function.getPredDefined())))) {
					if ((predNecessary.equals("") || (predNecessary.equals(function.getPredNecessary())))) {
						if (function.getPredOwner().equals(KConstants.Fuzzifications.DEFAULT_DEFINITION)) {
							// The default definition is always retrieved.
							filteredResult.add(function);
						} else {
							if ((KConstants.Request.modeAdvanced.equals(mode))
									|| (function.getPredOwner().equals(localUserInfo.getLocalUserName()))) {
								// If the mode is not advanced and the logged
								// user is the fuzzification owner,
								// retrieve it too.
								filteredResult.add(function);
							}
						}
					}
				}
			}

			if (filteredResult.size() > 0) {
				filteredResults.add(filteredResult);
			}
		}

		ProgramPartAnalysis[][] results = new ProgramPartAnalysis[filteredResults.size()][];
		for (int i = 0; i < filteredResults.size(); i++) {
			results[i] = filteredResults.get(i).toArray(new ProgramPartAnalysis[filteredResults.get(i).size()]);
		}
		return results;
	}

	public ProgramPartAnalysis[][] getProgramFields() {
		ProgramPartAnalysis[][] result = new ProgramPartAnalysis[1][programFields.size()];
		result[0] = new ProgramPartAnalysis[programFields.size()];
		for (int i = 0; i < result[0].length; i++)
			result[0][i] = programFields.get(i);
		return result;
	}

	public int updateProgramFile(LocalUserInfo localUserInfo, String predDefined, String predNecessary, String mode,
			String[][] functionDefinition) throws Exception {

		LOG.info("saving the fuzzification " + predDefined + " depending on " + predNecessary + " in mode " + mode);

		// Security issues ("" strings).
		if ("".equals(predDefined))
			throw new Exception("predDefined cannot be empty string.");
		if ("".equals(predNecessary))
			throw new Exception("predNecessary cannot be empty string.");
		if ("".equals(mode)) {
			mode = KConstants.Request.modeBasic;
		}

		// If I'm not the owner I can change only my fuzzification.
		// If I'm the owner I can change mine and the default one, but no other
		// one.
		String predOwner = localUserInfo.getLocalUserName();
		if ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
				&& (KConstants.Request.modeAdvanced.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		if ((KConstants.Request.modeEditingDefault.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		ProgramPartAnalysis programPart = null;

		if (programFileInfo.existsFile(false)) {
			programFileInfo.remove();
		}
		File file = programFileInfo.createFile(true);

		ArrayList<ProgramPartAnalysis> programPartsAffected = new ArrayList<ProgramPartAnalysis>();
		boolean foundFuzzifications = false;
		boolean copiedBackFuzzifications = false;

		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);

		String databaseName = "";
		String[] temp = predDefined.split("\\(");
		databaseName = temp[1].replaceAll("\\)", "");

		boolean madeChanges = false;
		
		for(int i = 0; i < programParts.size(); i++) {
			ProgramPartAnalysis programP = programParts.get(i);
			if (StringUtils.equals(mode, KConstants.Request.modeBasic) && (programP.isFunction())
					&& (programP.getPredDefined().equals(predDefined))
					&& (programP.getPredNecessary().equals(predNecessary))
					&& StringUtils.equals(programP.getOnly_for_user(), localUserInfo.getLocalUserName())) {
				programParts.remove(i);
			}
		}
		
//		String indexOfFunc = null;

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);
			// LOG.info("analyzing the program line: " + programPart.getLine());

			if (!copiedBackFuzzifications) {
				if ((programPart.isFunction()) && (programPart.getPredDefined().equals(predDefined))
						&& (programPart.getPredNecessary().equals(predNecessary))) {
					foundFuzzifications = true;
					programPartsAffected.add(programPart);
					if(StringUtils.equals(mode, KConstants.Request.modeCreate)) {
						mode = KConstants.Request.modeBasic;
					}
				} else {
					if (foundFuzzifications) {
						if (StringUtils.equals(mode, KConstants.Request.modeAdvanced)) {
							programPartsAffected = updateAffectedProgramParts(programPartsAffected, predDefined,
									predNecessary, predOwner, functionDefinition);
						}
						writeProgramParts(programPartsAffected, bw);
						copiedBackFuzzifications = true;
					}
					// else if (i < (programParts.size() - 2)) {
					// ProgramPartAnalysis tempProgramPart = programParts.get(i
					// + 1);
					// if (tempProgramPart.getHead() != null &&
					// tempProgramPart.getHead().contains("define_database")
					// && !tempProgramPart.getHead().contains(databaseName)) {
					// writeProgramParts(updateAffectedProgramParts(new
					// ArrayList<ProgramPartAnalysis>(),
					// predDefined, predNecessary, predOwner,
					// functionDefinition), bw);
					// madeChanges = true;
					// }
					// }
				}
			}

			if ((!foundFuzzifications) || (foundFuzzifications && copiedBackFuzzifications)) {
				writeProgramPart(programPart, bw);
			}
			
//			if(programPart.isFunction()) {
//				indexOfFunc = programPart.getPredDefined();
//			}
			
		}

		if (StringUtils.equals(mode, KConstants.Request.modeBasic) && !madeChanges)
			writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), predDefined,
					predNecessary, predOwner, functionDefinition), bw);
		
		bw.close();

		//add the new defined fuzzy criteria
		if (StringUtils.equals(mode, KConstants.Request.modeCreate) && !madeChanges) {
			Path path = Paths.get(programFileInfo.getProgramFileFullPath());
			List<String> lines = Files.readAllLines(path, StandardCharsets.UTF_8);
			ProgramPartAnalysis newProgramPart = createNewProgramPart(predDefined,
					predNecessary, functionDefinition);
//			String extraLine = newProgramPart.getPredDefined() + " :~ " + KConstants.ProgramAnalysis.markerForDefaultsTo + "(0)." + "\n";  
			String extraLine = "";
			String[] programPartLines = newProgramPart.getLines();
			if (programPartLines != null) {
				for (int i = 0; i < programPartLines.length; i++) {
					extraLine += programPartLines[i] + "\n";
				}
			}
//			int newLinePosition = lines.indexOf(indexOfFunc + " :~ " + KConstants.ProgramAnalysis.markerForDefaultsTo + "(0).");
//			lines.add(newLinePosition, extraLine);
			lines.add(extraLine);
			Files.write(path, lines, StandardCharsets.UTF_8);
		}
		
		if (copiedBackFuzzifications) {
			this.programParts = null;
			this.programFunctionsOrdered = null;
			CacheStoreHouseCleaner.clean(programFileInfo);
			return 0;
		}
		return 0;
	}
	
	public int updateProgramFileSynAnt(LocalUserInfo localUserInfo, String predDefined, String predNecessary, String mode,
			String synAnt) throws Exception {

		LOG.info("saving the synonym/antonym " + predDefined + " depending on " + predNecessary + " in mode " + mode);

		// Security issues ("" strings).
		if ("".equals(predDefined))
			throw new Exception("predDefined cannot be empty string.");
		if ("".equals(predNecessary))
			throw new Exception("predNecessary cannot be empty string.");
		if ("".equals(mode)) {
			mode = KConstants.Request.modeBasic;
		}

		// If I'm not the owner I can change only my syn/ant.
		// If I'm the owner I can change mine and the default one, but no other
		// one.
		String predOwner = localUserInfo.getLocalUserName();
		if ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
				&& (KConstants.Request.modeAdvanced.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		if ((KConstants.Request.modeEditingDefault.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		ProgramPartAnalysis programPart = null;

		if (programFileInfo.existsFile(false)) {
			programFileInfo.remove();
		}
		File file = programFileInfo.createFile(true);

		ArrayList<ProgramPartAnalysis> programPartsAffected = new ArrayList<ProgramPartAnalysis>();
		boolean foundSynAnt = false;
		boolean copiedBackSynAnt = false;

		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);

		String databaseName = "";
		String[] temp = predDefined.split("\\(");
		databaseName = temp[1].replaceAll("\\)", "");

		boolean madeChanges = false;
		
		for(int i = 0; i < programParts.size(); i++) {
			ProgramPartAnalysis programP = programParts.get(i);
			if (StringUtils.equals(mode, KConstants.Request.modeCreate) && (programP.isSynAnt())
					&& (programP.getPredDefined().equals(predDefined))
					&& (programP.getPredNecessary().equals(predNecessary))
					&& StringUtils.equals(programP.getOnly_for_user(), localUserInfo.getLocalUserName())) {
				programParts.remove(i);
			}
		}
		
//		String indexOfFunc = null;

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);
			// LOG.info("analyzing the program line: " + programPart.getLine());

			if (!copiedBackSynAnt) {
				if ((programPart.isSynAnt()) && (programPart.getPredDefined().equals(predDefined))
						&& (programPart.getPredNecessary().equals(predNecessary))) {
					foundSynAnt = true;
					programPartsAffected.add(programPart);
					if(StringUtils.equals(mode, KConstants.Request.modeCreate)) {
						mode = KConstants.Request.modeBasic;
					}
				} else {
					if (foundSynAnt) {
						if (StringUtils.equals(mode, KConstants.Request.modeAdvanced)) {
							programPartsAffected = updateAffectedProgramPartsSynAnt(programPartsAffected, predDefined,
									predNecessary, predOwner);
						}
						writeProgramParts(programPartsAffected, bw);
						copiedBackSynAnt = true;
					}
					// else if (i < (programParts.size() - 2)) {
					// ProgramPartAnalysis tempProgramPart = programParts.get(i
					// + 1);
					// if (tempProgramPart.getHead() != null &&
					// tempProgramPart.getHead().contains("define_database")
					// && !tempProgramPart.getHead().contains(databaseName)) {
					// writeProgramParts(updateAffectedProgramParts(new
					// ArrayList<ProgramPartAnalysis>(),
					// predDefined, predNecessary, predOwner,
					// functionDefinition), bw);
					// madeChanges = true;
					// }
					// }
				}
			}

			if ((!foundSynAnt) || (foundSynAnt && copiedBackSynAnt)) {
				writeProgramPart(programPart, bw);
			}
			
//			if(programPart.isFunction()) {
//				indexOfFunc = programPart.getPredDefined();
//			}
			
		}

		if (StringUtils.equals(mode, KConstants.Request.modeBasic) && !madeChanges)
			writeProgramParts(updateAffectedProgramPartsSynAnt(new ArrayList<ProgramPartAnalysis>(), predDefined,
					predNecessary, predOwner), bw);
		
		bw.close();

		//add the new defined syn/ant criteria
		if (StringUtils.equals(mode, KConstants.Request.modeCreate) && !madeChanges) {
			Path path = Paths.get(programFileInfo.getProgramFileFullPath());
			List<String> lines = Files.readAllLines(path, StandardCharsets.UTF_8);
			ProgramPartAnalysis newProgramPart = createNewProgramPartSynAnt(predDefined,
					predNecessary,synAnt);
//			String extraLine = newProgramPart.getPredDefined() + " :~ " + KConstants.ProgramAnalysis.markerForDefaultsTo + "(0)." + "\n";  
			String extraLine = "";
//			String extraLine = predDefined + " :~ synonym_of(" + predNecessary + ",prod,1).";
			String[] programPartLines = newProgramPart.getLines();
			if (programPartLines != null) {
				for (int i = 0; i < programPartLines.length; i++) {
					extraLine += programPartLines[i] + "\n";
				}
			}
//			int newLinePosition = lines.indexOf(indexOfFunc + " :~ " + KConstants.ProgramAnalysis.markerForDefaultsTo + "(0).");
//			lines.add(newLinePosition, extraLine);
			lines.add(extraLine);
			Files.write(path, lines, StandardCharsets.UTF_8);
		}
		
		if (copiedBackSynAnt) {
			this.programParts = null;
			this.programFunctionsOrdered = null;
			CacheStoreHouseCleaner.clean(programFileInfo);
			return 0;
		}
		return 0;
	}
	
	public int updateProgramFileFuzzRule(LocalUserInfo localUserInfo, Map<String, Object> fuzzRuleDetails, String predNecessary, String mode) throws Exception {

		LOG.info("saving the fuzzy rule " + fuzzRuleDetails.get(KConstants.Fuzzifications.fuzzyRuleName) + " depending on " + predNecessary  + " in mode " + mode);

		// Security issues ("" strings).
		if ("".equals(predNecessary))
			throw new Exception("predNecessary cannot be empty string.");
		if ("".equals(fuzzRuleDetails.get(KConstants.Fuzzifications.fuzzyRuleName)))
			throw new Exception("fuzzy rule name cannot be empty string.");
		if ("".equals(fuzzRuleDetails.get(KConstants.Fuzzifications.agregatorOperator)))
			throw new Exception("agregator operator cannot be empty string.");
		if ("".equals(fuzzRuleDetails.get(KConstants.Fuzzifications.predicates)))
			throw new Exception("predicates cannot be empty list.");
		if ("".equals(mode)) {
			mode = KConstants.Request.modeBasic;
		}

		// If I'm not the owner I can change only my fuzzy rule.
		// If I'm the owner I can change mine and the default one, but no other
		// one.
		String predOwner = localUserInfo.getLocalUserName();
		if ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
				&& (KConstants.Request.modeAdvanced.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		if ((KConstants.Request.modeEditingDefault.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		ProgramPartAnalysis programPart = null;

		if (programFileInfo.existsFile(false)) {
			programFileInfo.remove();
		}
		File file = programFileInfo.createFile(true);

		ArrayList<ProgramPartAnalysis> programPartsAffected = new ArrayList<ProgramPartAnalysis>();
		boolean foundFuzzyRule = false;
		boolean copiedBackFuzzyRule = false;

		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);

//		String databaseName = "";
//		String[] temp = predDefined.split("\\(");
//		databaseName = temp[1].replaceAll("\\)", "");

		boolean madeChanges = false;
		
		String predDefined = fuzzRuleDetails.get(KConstants.Fuzzifications.fuzzyRuleName) + "(" + predNecessary + ")";
		
		for(int i = 0; i < programParts.size(); i++) {
			ProgramPartAnalysis programP = programParts.get(i);
			if (StringUtils.equals(mode, KConstants.Request.modeCreate) && (programP.isFuzzRule())
					&& (programP.getPredDefined().equals(predDefined))
					&& (programP.getPredNecessary().equals(predNecessary))
					/**&& StringUtils.equals(programP.getOnly_for_user(), localUserInfo.getLocalUserName())*/) {
				programParts.remove(i);
			}
		}
		
//		String indexOfFunc = null;

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);
			// LOG.info("analyzing the program line: " + programPart.getLine());

			if (!copiedBackFuzzyRule) {
				if ((programPart.isFuzzRule()) && (programPart.getPredDefined().equals(predDefined))
						&& (programPart.getPredNecessary().equals(predNecessary))
						) {
					foundFuzzyRule = true;
					programPartsAffected.add(programPart);
//					if(StringUtils.equals(mode, KConstants.Request.modeCreate)) {
//						mode = KConstants.Request.modeBasic;
//					}
				} else {
					if (foundFuzzyRule) {
						if (StringUtils.equals(mode, KConstants.Request.modeAdvanced)) {
							programPartsAffected = updateAffectedProgramPartsFuzzyRule(programPartsAffected, fuzzRuleDetails.get(KConstants.Fuzzifications.fuzzyRuleName).toString(),
									predNecessary, predOwner);
						}
						writeProgramParts(programPartsAffected, bw);
						copiedBackFuzzyRule = true;
					}
					// else if (i < (programParts.size() - 2)) {
					// ProgramPartAnalysis tempProgramPart = programParts.get(i
					// + 1);
					// if (tempProgramPart.getHead() != null &&
					// tempProgramPart.getHead().contains("define_database")
					// && !tempProgramPart.getHead().contains(databaseName)) {
					// writeProgramParts(updateAffectedProgramParts(new
					// ArrayList<ProgramPartAnalysis>(),
					// predDefined, predNecessary, predOwner,
					// functionDefinition), bw);
					// madeChanges = true;
					// }
					// }
				}
			}

			if ((!foundFuzzyRule) || (foundFuzzyRule && copiedBackFuzzyRule)) {
				writeProgramPart(programPart, bw);
			}
			
//			if(programPart.isFunction()) {
//				indexOfFunc = programPart.getPredDefined();
//			}
			
		}

		if (StringUtils.equals(mode, KConstants.Request.modeBasic) && !madeChanges)
			writeProgramParts(updateAffectedProgramPartsFuzzyRule(new ArrayList<ProgramPartAnalysis>(), fuzzRuleDetails.get(KConstants.Fuzzifications.fuzzyRuleName).toString(),
					predNecessary, predOwner), bw);
		
		bw.close();

		//add the new defined fuzzy rule criteria
		if (StringUtils.equals(mode, KConstants.Request.modeCreate) && !madeChanges) {
			Path path = Paths.get(programFileInfo.getProgramFileFullPath());
			List<String> lines = Files.readAllLines(path, StandardCharsets.UTF_8);
			ProgramPartAnalysis newProgramPart = createNewProgramPartFuzzyRule(fuzzRuleDetails,
					predNecessary);
//			String extraLine = newProgramPart.getPredDefined() + " :~ " + KConstants.ProgramAnalysis.markerForDefaultsTo + "(0)." + "\n";  
			String extraLine = "";
//			String extraLine = predDefined + " :~ synonym_of(" + predNecessary + ",prod,1).";
			String[] programPartLines = newProgramPart.getLines();
			if (programPartLines != null) {
				for (int i = 0; i < programPartLines.length; i++) {
					extraLine += programPartLines[i] + "\n";
				}
			}
//			int newLinePosition = lines.indexOf(indexOfFunc + " :~ " + KConstants.ProgramAnalysis.markerForDefaultsTo + "(0).");
//			lines.add(newLinePosition, extraLine);
			lines.add(extraLine);
			Files.write(path, lines, StandardCharsets.UTF_8);
		}
		
		if (copiedBackFuzzyRule) {
			this.programParts = null;
			this.programFunctionsOrdered = null;
			CacheStoreHouseCleaner.clean(programFileInfo);
			return 0;
		}
		return 0;
	}
	
	public void removeFuzzy(LocalUserInfo localUserInfo, String predDefined, String predNecessary, String mode,
			String[][] functionDefinition) throws Exception {

		LOG.info("removing the fuzzification " + predDefined + " depending on " + predNecessary);

		// Security issues ("" strings).
		if ("".equals(predDefined))
			throw new Exception("predDefined cannot be empty string.");
		if ("".equals(predNecessary))
			throw new Exception("predNecessary cannot be empty string.");

		// If I'm not the owner I can change only my fuzzification.
		// If I'm the owner I can change mine and the default one, but no other
		// one.
//		String predOwner = localUserInfo.getLocalUserName();
//		if ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
//				&& (KConstants.Request.modeAdvanced.equals(mode))) {
//			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
//		}
//
//		if ((KConstants.Request.modeEditingDefault.equals(mode))) {
//			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
//		}

		ProgramPartAnalysis programPart = null;

		if (programFileInfo.existsFile(false)) {
			programFileInfo.remove();
		}
		File file = programFileInfo.createFile(true);

		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);

//		String databaseName = "";
//		String[] temp = predDefined.split("\\(");
//		databaseName = temp[1].replaceAll("\\)", "");

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);
			if ((programPart.isFunction()) && (programPart.getPredDefined().equals(predDefined))
					&& (programPart.getPredNecessary().equals(predNecessary))) {
				//DONT WRITE THIS FUZZY
//				System.out.println(programPart);
			}
			//If the fuzzy to remove is default, remove it also
//			else if ((programPart.isDefault()) && (programPart.getPredDefined().equals(predDefined))
//					&& (programPart.getPredNecessary().equals(predNecessary))) {
//				//DONT WRITE THIS FUZZY
//				System.out.println(programPart);
//			} 
			else {
				writeProgramPart(programPart, bw);
			}

		}

		bw.close();

	}

	private void writeProgramParts(ArrayList<ProgramPartAnalysis> programParts, BufferedWriter bw) throws IOException {
		for (int i = 0; i < programParts.size(); i++) {
			writeProgramPart(programParts.get(i), bw);
		}
	}

	private void writeProgramPart(ProgramPartAnalysis programPart, BufferedWriter bw) throws IOException {
		String[] lines = programPart.getLines();
		if (lines != null) {
			for (int i = 0; i < lines.length; i++) {
				bw.write(lines[i] + "\n");
			}
		}
	}

	private ArrayList<ProgramPartAnalysis> updateAffectedProgramParts(
			ArrayList<ProgramPartAnalysis> programPartsAffected, String predDefined, String predNecessary,
			String predOwner, String defaultValue) throws ProgramAnalysisException {
		boolean updated = false;
		int j = 0;

		for (j = 0; j < programPartsAffected.size(); j++) {
			if (programPartsAffected.get(j).getPredOwner().equals(predOwner)) {
				programPartsAffected.get(j).updateDefaultFunction(defaultValue);
				updated = true;
			}
		}

		if (!updated) {
			ProgramPartAnalysis newProgramPart = new ProgramPartAnalysis();
			newProgramPart.setPredDefined(predDefined);
			newProgramPart.setPredNecessary(predNecessary);
			newProgramPart.setPredOwner(predOwner);
			newProgramPart.updateDefaultFunction(defaultValue);

			programPartsAffected.add(newProgramPart);
		}
		return programPartsAffected;
	}
	
	private ArrayList<ProgramPartAnalysis> updateAffectedProgramPartsSynAnt(
			ArrayList<ProgramPartAnalysis> programPartsAffected, String predDefined, String predNecessary,
			String predOwner) throws ProgramAnalysisException {
		boolean updated = false;
		int j = 0;

		for (j = 0; j < programPartsAffected.size(); j++) {
			if (programPartsAffected.get(j).getPredOwner().equals(predOwner)) {
//				programPartsAffected.get(j).updateDefaultFunction(defaultValue);
				updated = true;
			}
		}

		if (!updated) {
			ProgramPartAnalysis newProgramPart = new ProgramPartAnalysis();
			newProgramPart.setPredDefined(predDefined);
			newProgramPart.setPredNecessary(predNecessary);
			newProgramPart.setPredOwner(predOwner);
//			newProgramPart.updateDefaultFunction(defaultValue);

			programPartsAffected.add(newProgramPart);
		}
		return programPartsAffected;
	}
	
	private ArrayList<ProgramPartAnalysis> updateAffectedProgramPartsFuzzyRule(
			ArrayList<ProgramPartAnalysis> programPartsAffected, String predDefined, String predNecessary,
			String predOwner) throws ProgramAnalysisException {
		boolean updated = false;
		int j = 0;

		for (j = 0; j < programPartsAffected.size(); j++) {
			if (programPartsAffected.get(j).getPredOwner().equals(predOwner)) {
//				programPartsAffected.get(j).updateDefaultFunction(defaultValue);
				updated = true;
			}
		}

		if (!updated) {
			ProgramPartAnalysis newProgramPart = new ProgramPartAnalysis();
			newProgramPart.setPredDefined(predDefined);
			newProgramPart.setPredNecessary(predNecessary);
			newProgramPart.setPredOwner(predOwner);
//			newProgramPart.updateDefaultFunction(defaultValue);

			programPartsAffected.add(newProgramPart);
		}
		return programPartsAffected;
	}

	private ArrayList<ProgramPartAnalysis> updateAffectedProgramParts(
			ArrayList<ProgramPartAnalysis> programPartsAffected, String predDefined, String predNecessary,
			String predOwner, String[][] functionDefinition) throws ProgramAnalysisException {
		boolean updated = false;
		int j = 0;

		for (j = 0; j < programPartsAffected.size(); j++) {
			if (programPartsAffected.get(j).getPredOwner().equals(predOwner)) {
				programPartsAffected.get(j).updateFunction(functionDefinition);
				updated = true;
			}
		}

		if (!updated) {
			ProgramPartAnalysis newProgramPart = new ProgramPartAnalysis();
			newProgramPart.setPredDefined(predDefined);
			newProgramPart.setPredNecessary(predNecessary);
			newProgramPart.setPredOwner(predOwner);
			newProgramPart.updateFunction(functionDefinition);

			programPartsAffected.add(newProgramPart);
		}
		return programPartsAffected;
	}

	private ProgramPartAnalysis createNewProgramPart(
			String predDefined, String predNecessary,
			String[][] functionDefinition) throws ProgramAnalysisException {
		ProgramPartAnalysis newProgramPart = new ProgramPartAnalysis();
		newProgramPart.setPredDefined(predDefined);
		newProgramPart.setPredNecessary(predNecessary);
		newProgramPart.updateFunction(functionDefinition);
		return newProgramPart;
	}
	
	private ProgramPartAnalysis createNewProgramPartSynAnt(
			String predDefined, String predNecessary, String synAnt) throws ProgramAnalysisException {
		ProgramPartAnalysis newProgramPart = new ProgramPartAnalysis();
		newProgramPart.setPredDefined(predDefined);
		newProgramPart.setPredNecessary(predNecessary);
		newProgramPart.setLinesSynAnt(synAnt);
		return newProgramPart;
	}
	
	private ProgramPartAnalysis createNewProgramPartFuzzyRule(
			Map<String, Object> fuzzRuleDetails, String predNecessary) throws ProgramAnalysisException {
		ProgramPartAnalysis newProgramPart = new ProgramPartAnalysis();
		newProgramPart.setPredDefined(fuzzRuleDetails.get(KConstants.Fuzzifications.fuzzyRuleName).toString());
		newProgramPart.setPredNecessary(predNecessary);
		newProgramPart.setRuleAggregator(fuzzRuleDetails.get(KConstants.Fuzzifications.agregatorOperator).toString());
		newProgramPart.setRuleBody(fuzzRuleDetails.get(KConstants.Fuzzifications.predicates).toString());
		if(fuzzRuleDetails.get(KConstants.Fuzzifications.credibilityOperator) != "")
			newProgramPart.setWithCredibility(fuzzRuleDetails.get(KConstants.Fuzzifications.credibilityOperator) + ", " + fuzzRuleDetails.get(KConstants.Fuzzifications.credibilityValue));
		newProgramPart.setLinesFuzzyRule();
		return newProgramPart;
	}
	
	public String[][] getFunctionDefinition(RequestStoreHouse requestStoreHouse) {
		int counter = 0;
		String[][] functionDefinition = null;
		StringBuilder paramsDebug = new StringBuilder();
		paramsDebug.append("Function definition to save: ");

		while ((requestStoreHouse.getRequestParameter("fpx[" + counter + "]") != null)
				&& (!"".equals((requestStoreHouse.getRequestParameter("fpx[" + counter + "]"))))
				&& (requestStoreHouse.getRequestParameter("fpy[" + counter + "]") != null)
				&& (!"".equals((requestStoreHouse.getRequestParameter("fpy[" + counter + "]"))))) {
			counter++;
		}

		if (counter > 0) {
			functionDefinition = new String[counter][2];
			for (int i = 0; i < counter; i++) {
				functionDefinition[i][0] = requestStoreHouse.getRequestParameter("fpx[" + i + "]");
				functionDefinition[i][1] = requestStoreHouse.getRequestParameter("fpy[" + i + "]");
				paramsDebug.append("\n" + functionDefinition[i][0] + " -> " + functionDefinition[i][1] + " ");
			}
		}
		LOG.info(paramsDebug.toString());
		return functionDefinition;
	}

	public ArrayList<LinkedHashMap<String, String>> getAllDefinedFunctionDefinition(String predDefined) {
		int i = 0;
		ArrayList<LinkedHashMap<String, String>> fuzz = new ArrayList<LinkedHashMap<String, String>>();
		boolean found = false;
		System.out.println("" + programFunctionsOrdered.length);
		while ((i < programFunctionsOrdered.length) && (!found)) {
			if ((programFunctionsOrdered[i][0].getHead()).equals(predDefined)) {
				for (int j = 0; j < programFunctionsOrdered[i].length; j++) {
					// Taking out the default rule
					if (programFunctionsOrdered[i][j].getOnly_for_user() != null) {
						LinkedHashMap<String, String> h = programFunctionsOrdered[i][j].getFunctionPoints();
						fuzz.add(h);
					}
				}
				found = true;
			}
			i++;
			return fuzz;
		}
		return new ArrayList<LinkedHashMap<String, String>>();
	}

	// public int updateProgramFileForDefault(LocalUserInfo localUserInfo,
	// String predDefined, String predNecessary,
	// String mode, String defaultValue) throws Exception {
	// LOG.info("saving the fuzzification " + predDefined + " depending on " +
	// predNecessary + " in mode " + mode);
	//
	// // Security issues ("" strings).
	// if ("".equals(predDefined))
	// throw new Exception("predDefined cannot be empty string.");
	// if ("".equals(predNecessary))
	// throw new Exception("predNecessary cannot be empty string.");
	// if ("".equals(mode)) {
	// mode = KConstants.Request.modeBasic;
	// }
	//
	// // If I'm not the owner I can change only my fuzzification.
	// // If I'm the owner I can change mine and the default one, but no other
	// // one.
	// String predOwner = localUserInfo.getLocalUserName();
	// if
	// ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
	// && (KConstants.Request.modeAdvanced.equals(mode))) {
	// predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
	// }
	//
	// if ((KConstants.Request.modeEditingDefault.equals(mode))) {
	// predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
	// }
	//
	// ProgramPartAnalysis programPart = null;
	//
	// if (programFileInfo.existsFile(false)) {
	// programFileInfo.remove();
	// }
	// File file = programFileInfo.createFile(true);
	//
	// ArrayList<ProgramPartAnalysis> programPartsAffected = new
	// ArrayList<ProgramPartAnalysis>();
	// boolean foundFuzzifications = false;
	// boolean copiedBackFuzzifications = false;
	//
	// FileWriter fw = new FileWriter(file.getAbsoluteFile());
	// BufferedWriter bw = new BufferedWriter(fw);
	//
	// for (int i = 0; i < programParts.size(); i++) {
	// programPart = programParts.get(i);
	// // LOG.info("analyzing the program line: " + programPart.getLine());
	//
	// if (!copiedBackFuzzifications) {
	// if (programPart.getPredDefined() != null
	// && (predNecessary.equals(KConstants.Fuzzifications.defaultFunction))
	// && (programPart.getPredDefined().equals(predDefined))) {
	// foundFuzzifications = true;
	// programPartsAffected.add(programPart);
	// } else {
	// if (foundFuzzifications) {
	// programPartsAffected = updateAffectedProgramParts(programPartsAffected,
	// predDefined,
	// predNecessary, predOwner, defaultValue);
	// writeProgramParts(programPartsAffected, bw);
	// copiedBackFuzzifications = true;
	// }
	// }
	// }
	//
	// if ((!foundFuzzifications) || (foundFuzzifications &&
	// copiedBackFuzzifications)) {
	// writeProgramPart(programPart, bw);
	// }
	// }
	//
	// if (copiedBackFuzzifications) {
	// this.programParts = null;
	// this.programFunctionsOrdered = null;
	// CacheStoreHouseCleaner.clean(programFileInfo);
	// return 0;
	// }
	// writeProgramParts(updateAffectedProgramParts(new
	// ArrayList<ProgramPartAnalysis>(), predDefined, predNecessary,
	// predOwner, defaultValue), bw);
	// bw.close();
	//
	// return 0;
	// }

	public int updateProgramFile(LocalUserInfo localUserInfo, String predDefined, String predNecessary, String mode,
			String[][] functionDefinition, String defaultFunction, String defaultValue) throws Exception {

		LOG.info("saving the fuzzification with default" + predDefined + " depending on " + predNecessary + " in mode "
				+ mode);

		// Security issues ("" strings).
		if ("".equals(predDefined))
			throw new Exception("predDefined cannot be empty string.");
		if ("".equals(predNecessary))
			throw new Exception("predNecessary cannot be empty string.");
		if ("".equals(defaultFunction))
			throw new Exception("default cannot be empty string.");
		if ("".equals(defaultValue))
			throw new Exception("defaultValue cannot be empty string.");

		if ("".equals(mode)) {
			mode = KConstants.Request.modeBasic;
		}

		// If I'm not the owner I can change only my fuzzification.
		// If I'm the owner I can change mine and the default one, but no other
		// one.
		String predOwner = localUserInfo.getLocalUserName();
		if ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
				&& (KConstants.Request.modeAdvanced.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		if ((KConstants.Request.modeEditingDefault.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		ProgramPartAnalysis programPart = null;

		if (programFileInfo.existsFile(false)) {
			programFileInfo.remove();
		}
		File file = programFileInfo.createFile(true);

		ArrayList<ProgramPartAnalysis> programPartsAffected = new ArrayList<ProgramPartAnalysis>();
		boolean foundFuzzifications = false;
		boolean foundDefault = false;
		boolean copiedBackFuzzifications = false;

		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);
		
		for(int i = 0; i < programParts.size(); i++) {
			ProgramPartAnalysis programP = programParts.get(i);
			if (StringUtils.equals(mode, KConstants.Request.modeBasic) && (programP.isFunction())
					&& (programP.getPredDefined().equals(predDefined))
					&& (programP.getPredNecessary().equals(predNecessary))
					&& StringUtils.equals(programP.getOnly_for_user(), localUserInfo.getLocalUserName())) {
				programParts.remove(i);
			}
		}

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);
			// LOG.info("analyzing the program line: " + programPart.getLine());

			if (!copiedBackFuzzifications) {
				if ((programPart.isFunction()) && (programPart.getPredDefined().equals(predDefined))
						&& (programPart.getPredNecessary().equals(predNecessary))) {
					foundFuzzifications = true;
					programPartsAffected.add(programPart);
				} else if (programPart.getPredDefined() != null && programPart.getPredNecessary() == null
						&& (defaultFunction.equals(KConstants.Fuzzifications.defaultFunction))
						&& (programPart.getPredDefined().equals(predDefined))) {
					foundDefault = true;
					programPartsAffected.add(programPart);
				} else {
					if (foundFuzzifications) {
						programPartsAffected = updateAffectedProgramParts(programPartsAffected, predDefined,
								predNecessary, predOwner, functionDefinition);
						writeProgramParts(programPartsAffected, bw);
						copiedBackFuzzifications = true;
					}
					if (foundDefault) {
						programPartsAffected = updateAffectedProgramParts(programPartsAffected, predDefined,
								predNecessary, predOwner, defaultValue);
						writeProgramParts(programPartsAffected, bw);
						copiedBackFuzzifications = true;
					}
				}
			}

			if ((!foundFuzzifications) || (foundFuzzifications && copiedBackFuzzifications)
					|| (foundDefault && copiedBackFuzzifications)) {
				writeProgramPart(programPart, bw);
			}
		}

		if (!foundDefault && !StringUtils.equals(mode, KConstants.Request.modeCreate))
			writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), predDefined,
					defaultFunction, predOwner, defaultValue), bw);

		if (!foundFuzzifications && !StringUtils.equals(mode, KConstants.Request.modeCreate))
			writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), predDefined,
					predNecessary, predOwner, functionDefinition), bw);

		bw.close();
		
		//add the new defined fuzzy criteria
				if (StringUtils.equals(mode, KConstants.Request.modeCreate)) {
					Path path = Paths.get(programFileInfo.getProgramFileFullPath());
					List<String> lines = Files.readAllLines(path, StandardCharsets.UTF_8);
					ProgramPartAnalysis newProgramPart = createNewProgramPart(predDefined,
							predNecessary, functionDefinition);
					String extraLine = newProgramPart.getPredDefined() + " :~ " + KConstants.ProgramAnalysis.markerForDefaultsTo + "(" + defaultValue + ")." + "\n";  
					String[] programPartLines = newProgramPart.getLines();
					if (programPartLines != null) {
						for (int i = 0; i < programPartLines.length; i++) {
							extraLine += programPartLines[i] + "\n";
						}
					}
					lines.add(extraLine);
					Files.write(path, lines, StandardCharsets.UTF_8);
				}

		if (copiedBackFuzzifications) {
			this.programParts = null;
			this.programFunctionsOrdered = null;
			CacheStoreHouseCleaner.clean(programFileInfo);
			return 0;
		}

		return 0;
	}

	public String[][] parseData(String databaseName, ArrayList<ProgramPartAnalysis> programParts) {
		String[][] resultData = null;
		ArrayStructure temp = new ArrayStructure();
		int index = 0;
		if (programParts != null) {
			for (ProgramPartAnalysis programPart : programParts) {
				if (programPart.getHead() != null) {
					String tempData = programPart.getHead();
					if (tempData.startsWith(databaseName)) {
						tempData = tempData.replace(databaseName, "");
						tempData = tempData.replaceAll("\\(", "");
						tempData = tempData.replaceAll("\\)", "");
						tempData = tempData.replaceAll("\"", "");
						tempData = tempData.replaceAll("\\s+", "");

						String[] row = tempData.split(",");
						for (int loop = 0; loop < row.length; loop++) {
							temp.add(loop, index, row[loop]);
						}
						index++;
					}
				}
			}

			resultData = temp.toArray();
		}
		return resultData;
	}
	
	public Map<String, SimilarityFunction> getParsedSimilarity(LocalUserInfo localUserInfo, String databaseName, String columnName, String value1,
			String value2) throws Exception {
		LOG.info("Checking the simiarity for " + databaseName + " depending on " + columnName + " if exist");

		Map<String, SimilarityFunction> res = new HashMap<String, SimilarityFunction>();
		if ("".equals(databaseName))
			throw new Exception("Database cannot be empty string.");
		if ("".equals(columnName))
			throw new Exception("Column cannot be empty string.");
		
//		SimilarityFunction parsedSimilarity = null;
		ProgramPartAnalysis programPart = null;

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);

			if (programPart.getHead() != null
					&& programPart.getHead().startsWith(KConstants.Fuzzifications.similarityFunction)) {
				SimilarityFunction similarity = parseSimilarity(programPart.getHead());
				if (similarity != null && similarity.getDatabaseName() != null) {
					if (similarity.getDatabaseName().equals(databaseName)
							&& similarity.getTableName().equals(columnName)
							&& (similarity.getColumnValue1().equals(value1)
									&& similarity.getColumnValue2().equals(value2))) {
//						parsedSimilarity = similarity;
						res.put("exist", similarity);
					} else if (similarity.getDatabaseName().equals(databaseName)
							&& similarity.getTableName().equals(columnName)
							&& (similarity.getColumnValue2().equals(value1)
											&& similarity.getColumnValue1().equals(value2))) {
						res.put("opposit", null);
					}
				}
			}
		}
		return res;
	}
	
	public void removeSimilarity(LocalUserInfo localUserInfo, String predDefined, String predNecessary, String databaseName, String columnName, String value1,
			String value2) throws Exception {
		LOG.info("Removing the simiarity for " + databaseName + " depending on " + columnName);

		if ("".equals(databaseName))
			throw new Exception("Database cannot be empty string.");
		if ("".equals(columnName))
			throw new Exception("Column cannot be empty string.");
		
		// If I'm not the owner I can change only my fuzzification.
		// If I'm the owner I can change mine and the default one, but no other
		// one.
//		String predOwner = localUserInfo.getLocalUserName();
//		if ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
//				&& (KConstants.Request.modeAdvanced.equals(mode))) {
//			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
//		}
//
//		if ((KConstants.Request.modeEditingDefault.equals(mode))) {
//			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
//		}

		ProgramPartAnalysis programPart = null;

		if (programFileInfo.existsFile(false)) {
			programFileInfo.remove();
		}
		File file = programFileInfo.createFile(true);

		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);
			if (programPart.getHead() != null
					&& programPart.getHead().startsWith(KConstants.Fuzzifications.similarityFunction)) {
				SimilarityFunction similarity = parseSimilarity(programPart.getHead());
				if (similarity != null && similarity.getDatabaseName() != null) {
					if (similarity.getDatabaseName().equals(databaseName)
							&& similarity.getTableName().equals(columnName)
							&& ((similarity.getColumnValue1().equals(value1)
									&& similarity.getColumnValue2().equals(value2))
									|| (similarity.getColumnValue2().equals(value1)
											&& similarity.getColumnValue1().equals(value2)))) {
						System.out.println("==$$=="+value1);
						//DONT WRITE THIS SIMILARITY: similarity
//						System.out.println(programPart);
//						System.out.println(similarity);
					} else {
						writeProgramPart(programPart, bw);
					}
				}
			}
			else {
				writeProgramPart(programPart, bw);
			}

		}

		bw.close();
		
	}

	public int updateProgramFile(LocalUserInfo localUserInfo, String databaseName, String columnName, String value1,
			String value2, String mode, String similartyValue, String oldValue1, String oldValue2) throws Exception {
		LOG.info("saving the simiarity for " + databaseName + " depending on " + columnName + " in mode " + mode);

		if ("".equals(databaseName))
			throw new Exception("Database cannot be empty string.");
		if ("".equals(columnName))
			throw new Exception("Column cannot be empty string.");
		if ("".equals(mode)) {
			mode = KConstants.Request.modeBasic;
		}

		String predOwner = localUserInfo.getLocalUserName();
		if ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
				&& (KConstants.Request.modeAdvanced.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		if ((KConstants.Request.modeEditingDefault.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		ProgramPartAnalysis programPart = null;

		if (programFileInfo.existsFile(false)) {
			programFileInfo.remove();
		}
		File file = programFileInfo.createFile(true);

		ArrayList<ProgramPartAnalysis> programPartsAffected = new ArrayList<ProgramPartAnalysis>();

		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);

		boolean occurrence = false;
		boolean toUpdate = false;
		boolean updateExiting = false;

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);

			if (programPart.getHead() != null
					&& programPart.getHead().startsWith(KConstants.Fuzzifications.similarityFunction)) {
				SimilarityFunction parsedSimilarity = parseSimilarity(programPart.getHead());
				if (parsedSimilarity != null && parsedSimilarity.getDatabaseName() != null && bw != null) {
					if (parsedSimilarity.getDatabaseName().equals(databaseName)
							&& parsedSimilarity.getTableName().equals(columnName)
							&& ((parsedSimilarity.getColumnValue1().equals(value1)
									&& parsedSimilarity.getColumnValue2().equals(value2))
									|| (parsedSimilarity.getColumnValue2().equals(value1)
											&& parsedSimilarity.getColumnValue1().equals(value2)))) {
						if(KConstants.Request.modeUpdateSimilarity.equals(mode) || KConstants.Request.modeUpdateExitingSimilarity.equals(mode)) {
							/**toUpdate = true;*/
							//When user try to create a new similarity that's already exist, from "Define new". or update a similarity from "Modify the existing criterion"
							//Create the new 4 related line with updated value
							if(parsedSimilarity.getColumnValue1().equals(value1) && parsedSimilarity.getColumnValue2().equals(value2)) {
								writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
										value1, value2, similartyValue, predOwner), bw);
								writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
										value2, value1, similartyValue, predOwner), bw);
								writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
										value1, value1, "1", predOwner), bw);
								writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
										value2, value2, "1", predOwner), bw);
							} else if(parsedSimilarity.getColumnValue1().equals(value2) && parsedSimilarity.getColumnValue2().equals(value1)) {
								writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
										value2, value1, similartyValue, predOwner), bw);
								writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
										value1, value2, similartyValue, predOwner), bw);
								writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
										value2, value2, "1", predOwner), bw);
								writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
										value1, value1, "1", predOwner), bw);
							}
							i += 3;
							occurrence = true;
						} else if (!KConstants.Request.modeUpdate.equals(mode) && !KConstants.Request.modeUpdateExitingSimilarity.equals(mode)) {
							occurrence = true;
							writeProgramPart(programPart, bw);
						}
					} /**else if(parsedSimilarity.getDatabaseName().equals(databaseName)
							&& parsedSimilarity.getTableName().equals(columnName)
							&& ((parsedSimilarity.getColumnValue1().equals(oldValue1)
									&& parsedSimilarity.getColumnValue2().equals(oldValue2))
									|| (parsedSimilarity.getColumnValue2().equals(oldValue1)
											&& parsedSimilarity.getColumnValue1().equals(oldValue2)))) {
						if(KConstants.Request.modeUpdateExitingSimilarity.equals(mode)) {
							updateExiting = true;
							//for now we have not used this variable 'updateExiting', maybe we can use it in the future
						}
					} */ else {
						writeProgramPart(programPart, bw);
					}
				} else {
					writeProgramPart(programPart, bw);
				}
			} else {
				writeProgramPart(programPart, bw);
			}
		}

		int result = -1;
		if (!occurrence || toUpdate) {
			writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
					value1, value2, similartyValue, predOwner), bw);

			writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
					value2, value1, similartyValue, predOwner), bw); // counterpart
																		// with
																		// same
																		// similarity
																		// value
			
			writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
					value1, value1, "1", predOwner), bw); // counterpart
																		// with
																		// value1
																		// value1
			writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), databaseName, columnName,
					value2, value2, "1", predOwner), bw); // counterpart
																		// with
																		// value2
																		// value2

			result = 0;
		}

		bw.close();
		return result;
	}

	private SimilarityFunction parseSimilarity(String function) {
		SimilarityFunction simiarityParsed = new SimilarityFunction();

		String[] temp = function.split("\\(", 2);
		String[] functionParts = temp[1].split(",");

		try {
			simiarityParsed.setDatabaseName(functionParts[0]); // database

			if (!functionParts[1].equals("X") && !functionParts[1].equals("Y")) {
				temp = functionParts[1].split("\\(", 2);
				simiarityParsed.setTableName(temp[0].trim()); // table column
				simiarityParsed.setColumnValue1(temp[1].replaceAll("\\)", "").trim()); // first
				// value
			} else {
				simiarityParsed.setTableName(functionParts[1].trim()); // table
																		// column
				simiarityParsed.setColumnValue1(functionParts[1].trim()); // first

			}

			if (!functionParts[2].trim().equals("X") && !functionParts[2].trim().equals("Y")) {
				temp = functionParts[2].split("\\(", 2);
				simiarityParsed.setColumnValue2(temp[1].replaceAll("\\)", "").trim()); // second
				// value
			} else {
				simiarityParsed.setColumnValue2(functionParts[2].trim()); // second
			}
			simiarityParsed.setSimilarityValue(functionParts[3].replaceAll("\\)", "").trim()); // similarity
			// value
		} catch (IndexOutOfBoundsException ind) {
			throw ind;
		}

		return simiarityParsed;
	}

	public int updateProgramFile(LocalUserInfo localUserInfo, String mode, String modifierValue) throws Exception {
		LOG.info("saving the modifier" + modifierValue + " in mode " + mode);

		if ("".equals(modifierValue))
			throw new Exception("Column cannot be empty string.");
		if ("".equals(mode)) {
			mode = KConstants.Request.modeBasic;
		}

		String predOwner = localUserInfo.getLocalUserName();
		if ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
				&& (KConstants.Request.modeAdvanced.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		if ((KConstants.Request.modeEditingDefault.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		ProgramPartAnalysis programPart = null;

		if (programFileInfo.existsFile(false)) {
			programFileInfo.remove();
		}
		File file = programFileInfo.createFile(true);

		ArrayList<ProgramPartAnalysis> programPartsAffected = new ArrayList<ProgramPartAnalysis>();

		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);
			writeProgramPart(programPart, bw);
		}

		String[] updatedModifier = modifierValue.split("</br>");
		for (int loop = 0; loop < updatedModifier.length; loop++) {
			writeProgramParts(
					updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(), updatedModifier[loop], predOwner),
					bw);
		}

		bw.close();
		return 0;
	}

	//Auto Generated Criteria after clicking on Convert into prolog button

	public int updateProgramFileForDefaultSimiarity(LocalUserInfo localUserInfo, String mode, String databaseNameValue)
			throws Exception {
		LOG.info("saving the defaut similarity" + databaseNameValue + " in mode " + mode);

		if ("".equals(databaseNameValue))
			throw new Exception("Database Name cannot be empty string.");
		if ("".equals(mode)) {
			mode = KConstants.Request.modeBasic;
		}

		String predOwner = localUserInfo.getLocalUserName();
		if ((localUserInfo.getLocalUserName().equals(programFileInfo.getFileOwner()))
				&& (KConstants.Request.modeAdvanced.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		if ((KConstants.Request.modeEditingDefault.equals(mode))) {
			predOwner = KConstants.Fuzzifications.DEFAULT_DEFINITION;
		}

		ProgramPartAnalysis programPart = null;

		if (programFileInfo.existsFile(false)) {
			programFileInfo.remove();
		}
		File file = programFileInfo.createFile(true);

		ArrayList<ProgramPartAnalysis> programPartsAffected = new ArrayList<ProgramPartAnalysis>();

		FileWriter fw = new FileWriter(file.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);

		for (int i = 0; i < programParts.size(); i++) {
			programPart = programParts.get(i);
			writeProgramPart(programPart, bw);
		}

		writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(),
				createDefaultSimilarityFunction(databaseNameValue), predOwner), bw);

		writeProgramParts(updateAffectedProgramParts(new ArrayList<ProgramPartAnalysis>(),
				createDefaulDifferencetSimilarityFunction(databaseNameValue), predOwner), bw);
		bw.close();
		return 0;
	}

	
	private String createDefaultSimilarityFunction(String databaseNameValue) {
		String defaultSimilarityFunction = KConstants.Fuzzifications.similarityFunction + "(" + databaseNameValue + ","
				+ "X" + ", " + "X" + ", " + "1" + "):- ground(" + "X" + ")";
		return defaultSimilarityFunction;
	}

	private String createDefaulDifferencetSimilarityFunction(String databaseNameValue) {
		String defaultSimilarityFunction = KConstants.Fuzzifications.similarityFunction + "(" + databaseNameValue + ","
				+ "X" + ", " + "Y" + ", " + "0" + "):- ground(" + "X" + "), " + "ground(" + "Y" + "), " + "X\\=Y";
		return defaultSimilarityFunction;
	}
	
	private ArrayList<ProgramPartAnalysis> updateAffectedProgramParts(
			ArrayList<ProgramPartAnalysis> programPartsAffected, String modifierValue, String predOwner) {
		boolean updated = false;

		if (!updated) {
			ProgramPartAnalysis newProgramPart = new ProgramPartAnalysis();
			newProgramPart.setPredOwner(predOwner);
			newProgramPart.updateModifierFunction(modifierValue);

			programPartsAffected.add(newProgramPart);
		}
		return programPartsAffected;
	}

	private ArrayList<ProgramPartAnalysis> updateAffectedProgramParts(
			ArrayList<ProgramPartAnalysis> programPartsAffected, String databaseName, String columnName, String value1,
			String value2, String similartyValue, String predOwner) throws ProgramAnalysisException {
		boolean updated = false;

		if (!updated) {
			ProgramPartAnalysis newProgramPart = new ProgramPartAnalysis();
			newProgramPart.setPredOwner(predOwner);
			newProgramPart.updateSimilarityFunction(databaseName, columnName, value1, value2, similartyValue);

			programPartsAffected.add(newProgramPart);
		}
		return programPartsAffected;
	}
}

/*
 * 
 */

/* EOF */
