package functionUtils;

public class SimilarityFunction {

	private String databaseName;
	private String tableName;
	private String columnValue1;
	private String columnValue2;
	private String similarityValue;

	public String getDatabaseName() {
		return databaseName;
	}

	public void setDatabaseName(String databaseName) {
		this.databaseName = databaseName;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getColumnValue1() {
		return columnValue1;
	}

	public void setColumnValue1(String columnValue1) {
		this.columnValue1 = columnValue1;
	}

	public String getColumnValue2() {
		return columnValue2;
	}

	public void setColumnValue2(String columnValue2) {
		this.columnValue2 = columnValue2;
	}

	public String getSimilarityValue() {
		return similarityValue;
	}

	public void setSimilarityValue(String similarityValue) {
		this.similarityValue = similarityValue;
	}

}
