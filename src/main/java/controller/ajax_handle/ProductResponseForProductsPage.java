package controller.ajax_handle;

import lombok.*;

public class ProductResponseForProductsPage {
    private int id;
    private String name;
    private int sellingPrice;
    private int stock;
    private double finalPrice;
    private String imagePath;

    public ProductResponseForProductsPage(int id, String name, int sellingPrice, int stock, double finalPrice, String imagePath) {
        this.id = id;
        this.name = name;
        this.sellingPrice = sellingPrice;
        this.stock = stock;
        this.finalPrice = finalPrice;
        this.imagePath = imagePath;
    }
}
