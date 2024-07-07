package model.service;

import model.adapter.InventoryProduct;
import model.bean.Product;
import model.dao.InventoryDAO;
import model.dao.ProductDAO;

import java.util.List;

public class InventoryService {

    public static InventoryService instance;

    public static InventoryService getInstance() {
        if(instance==null) instance = new InventoryService();
        return  instance;
    }

    public List<InventoryProduct> showInventoryView() {
        return InventoryDAO.showInventoryView();
    }

    public List<InventoryProduct> getTopSoldoutProduct(int number) {
        return ProductDAO.getTopSoldoutProduct(number);
    }

    public List<InventoryProduct> showDiscountView() { return InventoryDAO.showDiscountView();}


//    INSERT NEW PRODUCT.

    public void insertNewProduct(String name, String description, double costPrice, double sellingPrice,
                                 int quantity, int categoryId, List<String> imagesPath) {
        InventoryDAO.insertNewProduct(name, description, costPrice, sellingPrice, quantity, categoryId, imagesPath);
    }

    public void insertNewProduct(String name, String description, double costPrice, double sellingPrice, int quantity, int categoryId, int discountId, List<String> imagesPath) {
        InventoryDAO.insertNewProduct(name, description, costPrice, sellingPrice, quantity, categoryId, discountId, imagesPath);
    }

//    Lấy mọi thông tin product + inventory .
    public InventoryProduct getIdProduct(int id) {
        return InventoryDAO.getIdProduct(id);
    }


}
