package model.service;

import model.bean.Discount;
import model.bean.Product;
import model.bean.Rate;
import model.dao.ProductDAO;
import model.dao.UserDAO;
import model.db.JDBIConnector;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ProductService {
    public static ProductService instance;

    public static ProductService getInstance() {
        if (instance == null) instance = new ProductService();
        return instance;
    }

    public List<Product> getAll() {
        return ProductDAO.getAll();
    }

    public Product getProductById(String id) {
        return ProductDAO.getProductById(id);
    }

    public double productPriceIncludeDiscount(Product p) {
        if (p != null) {
            Discount discountApplied = DiscountService.getInstance().getDiscountById(p.getDiscountId() + "");
            if (discountApplied != null) {
                Timestamp currentTimestamp = new Timestamp(new Date().getTime());
                if ((discountApplied.getStartDate().getTime() <= (currentTimestamp.getTime()))
                        && (currentTimestamp.getTime() <= (discountApplied.getEndDate().getTime()))) {
                    return p.getSellingPrice() * (1 - discountApplied.getPercentageOff());
                } else {
                    return p.getSellingPrice();
                }
            } else return p.getSellingPrice();
        }
        return 0;
    }

    //danh sách sản phẩm đang được giảm giá
    public List<Product> productDiscountMainPage() {
        return ProductDAO.discountProduct();
    }

    public List<Product> listProductDiscount() {
        return ProductDAO.listDiscountProduct();
    }

    public List<Product> sortListProductDiscountAZ() {
        return ProductDAO.sortDiscountProductAZ();
    }

    public List<Product> sortListProductDiscountZA() {
        return ProductDAO.sortDiscountProductZA();
    }

    public List<Product> getProductsByCategoryId(int category_id) {
        return ProductDAO.findByCategory(category_id);
    }

    public void deleteProduct(String product_id) {
        ProductDAO.deleteProduct(product_id);
    }

    public void switchIsSale(String product_id) {
        ProductDAO.switchIsSale(product_id);
    }

    public List<Product> getTrueIsSaleProduct() {
        return ProductDAO.getTrueIsSaleProduct();
    }

    public List<Product> getFalseIsSaleProduct() {
        return ProductDAO.getFalseIsSaleProduct();
    }

    public List<Product> getTrueHasDiscountProduct() {
        return ProductDAO.getTrueHasDiscountProduct();
    }

    public List<Product> getFalseHasDiscountProduct() {
        return ProductDAO.getFalseHasDiscountProduct();
    }

    public List<Product> getNullQuantityProduct() {
        return ProductDAO.getNullQuantityProduct();
    }

    public List<Product> getProductByAsName(String subName) {
        return ProductDAO.getProductBySubName(subName);
    }

    public List<Product> getProductByDiscountId(int discountId) {
        return ProductDAO.getProductByDiscountId(discountId);
    }

    public void removeDiscount(int product_id) {
        ProductDAO.removeDiscount(product_id);
    }

    public void setDiscountForProductList(String discountId, List<String> product_id_list) {
        ProductDAO.setDiscountForProductList(discountId, product_id_list);
    }

    public void setNullDiscountForProductList(String discountId) {
        ProductDAO.setNullDiscountForProductList(discountId);
    }

    public void insertNewProduct(String name, String description, double costPrice, double sellingPrice,
                                 int quantity, int categoryId, List<String> imagesPath) {
        ProductDAO.insertNewProduct(name, description, costPrice, sellingPrice, quantity, categoryId, imagesPath);
    }


    //Sắp xếp từ thấp đến cao
    public List<Product> sortProductsAZ() {
        return ProductDAO.sortProductAZ();
    }

    //sắp xếp từ cao đến thấp
    public List<Product> sortProductsZA() {
        return ProductDAO.sortProductZA();
    }

    public List<Product> getAllProduct() {
        return ProductDAO.getAll();
    }

    public List<Product> getTopSoldoutProduct(int number) {
        return ProductDAO.getTopSoldoutProduct(number);
    }

    public Product getProductById(int productID) {
        return ProductDAO.getProduct(productID);
    }

    public List<Product> getRelatedProduct(int productId, int categoryId, int limit) {
        return ProductDAO.getRelatedProduct(productId, categoryId, limit);
    }

    public List<Rate> getRateForProduct(int productId) {
        return ProductDAO.getRateForProduct(productId);
    }

    public int getNumberRateStarsByUser(int productId, int userId) {
        return ProductDAO.getNumberRateStarsByUser(productId, userId);
    }

    public List<Rate> getRatesByStarNumber(int productId, int starRatings, int userId) {
        return ProductDAO.getRatesByStarNumber(productId, starRatings, userId);
    }

    public List<Rate> getRatesFirstUser(int productId, int userId) {
       return ProductDAO.getRatesFirstUser(productId, userId);
    }

    public Integer getStarNumberCount(int productId, int starRatings) {
        return ProductDAO.getStarNumberCount(productId, starRatings);
    }

    public Integer getStarNumberCount(int productId) {
        return ProductDAO.getStarNumberCount(productId);
    }

    public void changeRate(int productId, int userId, int starRatings, String comment) {
        if (ProductDAO.rateExists(productId, userId) != null) {
            ProductDAO.updateRate(productId, userId, starRatings, comment);
        } else {
            ProductDAO.insertRate(productId, userId, starRatings, comment);
        }
    }

    public Rate rateExists(int productId, int userId) {
        return ProductDAO.rateExists(productId, userId);
    }

    public int getChangeNumber(int productId, int userId) {
        boolean check = UserService.getInstance().checkUserAllowedToRate(productId, userId);
        // nếu mua r => get Rate -> xem changeNumber
        if (check) {
            Rate rate = ProductService.getInstance().rateExists(productId, userId);
            return (rate != null) ? rate.getChangeNumber() : -1;
        }
        return -1;
    }

    public void editProduct(String id, String name, String description, double costPrice, double sellingPrice, int quantity, String categoryId, String discountId) {
        ProductDAO.updateProduct(id, name, description, costPrice, sellingPrice, quantity, categoryId, discountId);
    }

    public void editProduct(String id, String name, String description, double costPrice, double sellingPrice, int quantity, String categoryId) {
        ProductDAO.updateProduct(id, name, description, costPrice, sellingPrice, quantity, categoryId);
    }

    public void insertNewProduct(String name, String description, double costPrice, double sellingPrice, int quantity, int categoryId, int discountId, List<String> imagesPath) {
        ProductDAO.insertNewProduct(name, description, costPrice, sellingPrice, quantity, categoryId, discountId, imagesPath);
    }

    public long getNumberAvailProduct() {
        return ProductDAO.getNumberAvailProduct();
    }

    public static void main(String[] args) {
        System.out.println(UserDAO.checkUserAllowedToRate(118, 4));
        System.out.println(getInstance().getChangeNumber(118, 4));
         Rate changeNumber = ProductService.getInstance().rateExists(118, 4);
        System.out.println("rate -> number: " + changeNumber.getChangeNumber());
    }
}
