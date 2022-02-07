import java.util.Arrays;

// class to read in the data and output it in the desired format
class Data {
  
  // hashmap to store the indices
  public HashMap<String,Integer> countries;
  
  // array for selection/interactivity
  public boolean[] selected;
  
  public String[] continent;
   
  // arrays to store the data
  public Float[] total;
  public Float[] years;
  public Float[] beer;
  public Float[] spirit;
  public Float[] wine;
  
  
  // constructor
  Data(String fileName) {
    
    // load the data
    this.loadData(fileName);
    
  }
  
  
  // helper function to load the alcohole consumption data from csv file
  private void loadData(String fileName) {
  
    this.countries = new HashMap<String,Integer>();
    String[] input = loadStrings(fileName);
    String header = input[0];
    String[] rows = Arrays.copyOfRange(input, 1, input.length);
    
    this.total = new Float[rows.length];
    this.years = new Float[rows.length];
    this.beer = new Float[rows.length];
    this.spirit = new Float[rows.length];
    this.wine = new Float[rows.length];
    this.selected = new boolean[rows.length];
    this.continent = new String[rows.length];
    
    for (Integer i=0;i<rows.length;i++) {
      // Reads country name and population density value from CSV row
      String row = rows[i];
      String[] columns = row.split(";");
      
      this.years[i] = Float.parseFloat(columns[1]);
      this.beer[i] = Float.parseFloat(columns[2]);
      this.spirit[i] = Float.parseFloat(columns[3]);
      this.wine[i] = Float.parseFloat(columns[4]);
      this.total[i] = Float.parseFloat(columns[5]);
      
      this.selected[i] = false;
      
      this.continent[i] = columns[6];
      
      this.countries.put(columns[0],i);
        
    }
    }
    
    
    // returns a data entry object according to the country
    public DataEntry get(String country) {
      Integer index = this.countries.get(country);
      if (index == null) {
        return null;
      }
      
      DataEntry d = new DataEntry();
      d.countryName =  country;
      d.total = this.total[index];
      d.years = this.years[index];
      d.beerServings = this.beer[index];
      d.spiritServings = this.spirit[index];
      d.wineServings = this.wine[index];
      d.selected = this.selected[index];
      d.continent = this.continent[index];
      
      return d;
    }
    

}
  

  
