package fileConverters;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class SQLtoCSVConverter {

	public static void sqlToCSVConversion(File inputFile, File outputFile, String separator) {
		List<String> queries = new ArrayList<String>();

		queries = SQLParser.createQueries(inputFile.getAbsolutePath());

		// For storing data into CSV files
		StringBuffer data = new StringBuffer();

		try {
			FileOutputStream fos = new FileOutputStream(outputFile);

			for (String oneQuery : queries) {
				if (oneQuery.contains("CREATE")) {
					List<String> parsedData = SQLParser.createQueryParse(oneQuery);
					for (int loop = 0; loop < parsedData.size(); loop++) {
						data.append(parsedData.get(loop).replaceAll("'", ""));
						if (loop < (parsedData.size() - 1)) {
							data.append(separator);
						}
					}
				} else if (oneQuery.contains("INSERT")) {
					List<String> parsedData = SQLParser.insertQueryParse(oneQuery);
					for (int loop = 0; loop < parsedData.size(); loop++) {
						data.append(parsedData.get(loop).replaceAll("'", ""));
						if (loop < (parsedData.size() - 1)) {
							data.append(separator);
						}
					}
				}

				data.append('\n');

			}

			fos.write(data.toString().getBytes());
			fos.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
