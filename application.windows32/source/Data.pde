import java.util.Arrays;

// class to read in the data and output it in the desired format
class Data {
  
  // hashmap to store the indices
  public HashMap<String,Integer> aoiIDs;
  
  // array for selection/interactivity
  public boolean[] selected;
  
  public String[] name;
  public String[] region;
   
  // arrays to store the data
  public Float[] f1;
  public Float[] precision;
  public Float[] recall;
  
  
  // constructor
  Data(String fileName) {
    
    // load the data
    this.loadData(fileName);
    
  }
  
  
  // helper function to load the alcohole consumption data from csv file
  private void loadData(String fileName) {
  
    this.aoiIDs = new HashMap<String,Integer>();
    String[] input = loadStrings(fileName);
    String header = input[0];
    String[] rows = Arrays.copyOfRange(input, 1, input.length);
    
    this.f1 = new Float[rows.length];
    this.precision = new Float[rows.length];
    this.recall = new Float[rows.length];
    this.selected = new boolean[rows.length];
    this.name = new String[rows.length];
    this.region = new String[rows.length];
    
    for (Integer i=0;i<rows.length;i++) {
      // Reads country name and population density value from CSV row
      String row = rows[i];
      String[] columns = row.split(";");
      println("test");
      
      this.f1[i] = Float.parseFloat(columns[2]);
      this.precision[i] = Float.parseFloat(columns[3]);
      this.recall[i] = Float.parseFloat(columns[4]);
      
      this.selected[i] = false;
      
      this.name[i] = columns[1];
      this.region[i] = columns[5];
      
      this.aoiIDs.put(columns[1],i);
        
    }
    }
    
    
    // returns a data entry object according to the country
    public DataEntry get(String aoiID) {
      Integer index = this.aoiIDs.get(aoiID);
      if (index == null) {
        return null;
      }
      
      DataEntry d = new DataEntry();
      d.aoiID =  aoiID;
      d.f1 = this.f1[index];
      d.precision = this.precision[index];
      d.recall = this.recall[index];
      d.selected = this.selected[index];
      d.name = this.name[index];
      d.region = this.region[index];
      
      return d;
    }
    

}
  

  
