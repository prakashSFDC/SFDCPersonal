public class RerenderController {
  private static Map<String, List<SelectOption>> catValueMap = new Map<String, List<SelectOption>> ();
  
  static {
   List <Selectoption> fruits = new List<SelectOption>();
   fruits.add(new SelectOption('Apple','Apple'));
   fruits.add(new SelectOption('Grape', 'Grape'));
   fruits.add(new SelectOption('Banana','Banana'));   
   fruits.add(new SelectOption('Orange','Orange'));      
   catValueMap.put('Fruits', fruits);   
   
   List <Selectoption> animals = new List<SelectOption>();
   animals.add(new SelectOption('Dog','Dog'));
   animals.add(new SelectOption('Cat', 'Cat'));
   animals.add(new SelectOption('Monkey','Monkey'));   
   animals.add(new SelectOption('Donkey','Donkey'));      
   catValueMap.put('Animals', animals);      
   
   List <Selectoption> computers = new List<SelectOption>();
   computers.add(new SelectOption('Dell','Dell'));
   computers.add(new SelectOption('Compaq', 'Compaq'));
   computers.add(new SelectOption('Acer','Acer'));   
   computers.add(new SelectOption('Apple','Apple'));      
   catValueMap.put('Computers', computers);   
  }

  public List<SelectOption> categories {get ; set;}
  public String category {get ; set;}
  public List<SelectOption> categoryValues {get ; set;}
  public String categoryValue {get ; set;}  
  
  {
      categories = new List<Selectoption>();
      categories.add(new Selectoption('Fruits', 'Fruits'));
      categories.add(new Selectoption('Animals', 'Animals'));
      categories.add(new Selectoption('Computers','Computers'));

      categoryValues = New List<SelectOption>();
  }

   public String getCategoryValuesAsCSV () {
       String csv = '';
       if (categoryValues != null) {
           for (Selectoption so: categoryValues ){
               csv += so.getValue() + ' , ';
           }
       }
       return csv;
   }
   
   public void onCategoryChange() {
       categoryValues = catValueMap.get(category);  
   }  
}