import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class q1 {
    private static final String INPUT_FILE_NAME = "resale-flat-prices.csv";
    private static final String OUTPUT_FILE_NAME = "q1.csv";
    private static final String CSV_SPLITTER = ",";

    private static final int INDEX_FLAT_TYPE = 2;
    private static final int INDEX_FLAT_MODEL = 7;

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(INPUT_FILE_NAME));
        BufferedWriter writer = new BufferedWriter(new FileWriter(OUTPUT_FILE_NAME));
        String line = "";

        while ((line = reader.readLine()) != null) {
            String[] record = line.split(CSV_SPLITTER);
            if (record.length != 10) {
                throw new IOException("The number of columns is wrong.");
            }

            if (isDesiredRecord(record)) {
                writer.write(line);
                writer.newLine();
            }
        }

        reader.close();
        writer.close();
    }

    /**
     * Checks whether a record's flat type is "3 ROOM" and flat model is "TERRACE".
     */
    private static boolean isDesiredRecord(String[] record) {
        return record[INDEX_FLAT_TYPE].equals("3 ROOM") && record[INDEX_FLAT_MODEL].equals("TERRACE");
    }
}
