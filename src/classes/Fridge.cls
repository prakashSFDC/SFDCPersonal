public class Fridge {
    
private String modelNumber;
private Integer numberInStock;

public void updateStock(Integer justSold) {
    numberInStock = numberInStock - justSold;
}

}