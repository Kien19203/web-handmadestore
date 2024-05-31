package model.dao;

import model.bean.*;
import model.db.JDBIConnector;

import java.util.Collections;
import java.util.List;
import java.util.UUID;

import model.service.ImageService;
import model.service.ProductService;

import java.sql.Connection;
import java.util.*;

import java.util.stream.Collectors;

public class ProductDAO {
    //Tất cả các sản phẩm
    public static List<Product> getAll() {
        List<Product> product = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product")
                        .mapToBean(Product.class)
                        .stream()
                        .toList()
        );
        return product;
    }

    public static Product getProductById(final String id) {
        Optional<Product> product = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where id= :id")
                        .bind("id", id)
                        .mapToBean(Product.class)
                        .stream()
                        .findFirst()
        );
        return product.isEmpty() ? null : product.get();
    }

    public static void deleteProduct(String product_id) {
        //delete products image
        ImageService.deleteProductImage(product_id);
        //delete order_details has products
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("DELETE FROM order_details WHERE productId=?")
                        .bind(0, product_id)
                        .execute()
        );
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("DELETE FROM product WHERE id=?")
                        .bind(0, product_id)
                        .execute()
        );
    }

    public static void switchIsSale(String product_id) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE product SET isSale = CASE WHEN isSale = 0 THEN 1 ELSE 0 END WHERE id=?")
                        .bind(0, product_id)
                        .execute()
        );
    }


    public static List<Product> listSixProduct(int offset) {
        try {
            List<Product> products = JDBIConnector.me().withHandle(handle ->
                    handle.createQuery("select * from product limit 6 offset :offset")
                            .bind("offset", offset)
                            .mapToBean(Product.class)
                            .stream().toList());

            return products;
        } catch (Exception e) {
            // Xử lý exception, ví dụ: log hoặc throw lại một exception khác.
            e.printStackTrace();
            return Collections.emptyList(); // hoặc return null tùy vào trường hợp
        }
    }

    public static List<Product> findByCategory(int categoryID) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where categoryId = :id")
                        .bind("id", categoryID)
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }


    //Lấy sản phẩm dựa vào id product
    public static Product getProduct(int productID) {
        Product p = JDBIConnector.me().withHandle(
                handle -> handle.createQuery("SELECT * from product where id = :productID")
                        .bind("productID", productID)
                        .mapToBean(Product.class).findFirst().orElse(null)
        );
        return p;
    }


    //Lấy ra danh saách bình luận
    public static List<Rate> getRateForProduct(int productId) {
        List<Rate> rateList = JDBIConnector.me().withHandle(
                handle -> handle.createQuery("SELECT * FROM rate  where productId =:productId ")
                        .bind("productId", productId).mapToBean(Rate.class)
                        .stream().toList());
        return rateList;
    }

    public static int getNumberRateStarsByUser(int productId, int userId) {
        try {
            return JDBIConnector.me().withHandle(handle ->
                    handle.createQuery("select starRatings from rate where userId=? and productId=?")
                            .bind(0, userId)
                            .bind(1, productId)
                            .mapTo(Integer.class).one());
        } catch (Exception e) {
            return 0;
        }
    }


    //Lấy ra danh sách ảnh của sản phẩm.
    public static List<Image> getImagesForProduct(int productId) {
        List<Image> imageList = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * from image where productId = :productId ")
                        .bind("productId", productId)
                        .mapToBean(Image.class)
                        .stream().toList());

        return imageList;
    }

    //Lấy ra các sản phẩm liên quan đến sản phẩm (trang chi tiết sản phẩm).
    public static List<Product> getRelatedProduct(int productId, int categoryId, int limit) {
        try {
            List<Product> products = JDBIConnector.me().withHandle(
                    handle -> handle.createQuery("SELECT * FROM product WHERE categoryId = :categoryId AND id != :productId LIMIT :limit")
                            .bind("categoryId", categoryId)
                            .bind("productId", productId)
                            .bind("limit", limit)
                            .mapToBean(Product.class)
                            .stream().toList()

            );
            return products;
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }


    public static void insertNewProduct(String name, String description, double costPrice, double sellingPrice, int quantity, int categoryId, List<String> imagesPath) {
        JDBIConnector.me().useHandle(handle -> {
            // Insert into product table with auto-increment ID
            int productId = handle.createUpdate("INSERT INTO product(name, description, costPrice, sellingPrice, quantity, categoryId) VALUES (:name, :description, :costPrice, :sellingPrice, :quantity, :categoryId)")
                    .bind("name", name)
                    .bind("description", description)
                    .bind("costPrice", costPrice)
                    .bind("sellingPrice", sellingPrice)
                    .bind("quantity", quantity)
                    .bind("categoryId", categoryId)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            for (String imagePath : imagesPath) {
                // Insert into image table with auto-increment ID
                int imageId = handle.createUpdate("INSERT INTO image(name, path, productId) VALUES (:name, :path, :productId)")
                        .bind("name", name + " " + imagePath)
                        .bind("path", imagePath)
                        .bind("productId", productId)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one();
            }
        });

    }

    public static void insertNewProduct(String name, String description, double costPrice, double sellingPrice, int quantity, int categoryId, int discountId, List<String> imagesPath) {
        JDBIConnector.me().useHandle(handle -> {
                    int productId = handle.createUpdate("INSERT INTO product (name, description, costPrice, sellingPrice,quantity,categoryId,discountId) VALUES (:name, :description, :costPrice, :sellingPrice,:quantity,:categoryId,:discountId)")
                            .bind("name", name)
                            .bind("description", description)
                            .bind("costPrice", costPrice)
                            .bind("sellingPrice", sellingPrice)
                            .bind("quantity", quantity)
                            .bind("categoryId", categoryId)
                            .bind("discountId", discountId)
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(Integer.class).one();

                    for (String imagePath : imagesPath) {
                        handle.createUpdate("INSERT INTO image (name, path, productId) VALUES (:name, :path, :productId)")
                                .bind("name", name)
                                .bind("path", imagePath)
                                .bind("productId", productId)
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(Integer.class).one();
                    }
                }
        );
    }

    public static List<Product> getTrueIsSaleProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where isSale = 1")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;

    }

    public static List<Product> getFalseIsSaleProduct() {
        List<Product> products;
        products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where isSale = 0")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getTrueHasDiscountProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where discountId IS NOT NULL")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getFalseHasDiscountProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where discountId IS NULL")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getNullQuantityProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where quantity = 0")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getProductByDiscountId(int discountId) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where discountId = :id")
                        .bind("id", discountId)
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    public static List<Product> getProductBySubName(String subName) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from product where name like :subName")
                        .bind("subName", "%" + subName + "%")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return products;
    }

    //    Sắp xếp theo giá tăng dần toàn bộ
    public static List<Product> sortProductAZ() {
        List<Product> productAZ = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product ORDER BY product.sellingPrice ASC")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return productAZ;
    }

    //    Sắp xếp theo giá giảm dần toàn bộ
    public static List<Product> sortProductZA() {
        List<Product> productZA = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product ORDER BY product.sellingPrice DESC")
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return productZA;
    }

    //    Sắp xếp theo giá tăng dần theo category
    public static List<Product> sortProductByCategoryAZ(int Categoryid) {
        List<Product> productAZ = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product WHERE categoryId = :id ORDER BY product.sellingPrice ASC")
                        .bind("id", Categoryid)
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return productAZ;
    }
    //    Sắp xếp theo giá giảm dần theo category

    public static List<Product> sortProductByCategoryZA(int Categoryid) {
        List<Product> productZA = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product WHERE categoryId = :id ORDER BY product.sellingPrice DESC")
                        .bind("id", Categoryid)
                        .mapToBean(Product.class)
                        .stream()
                        .toList());
        return productZA;
    }

    //Sản phẩm khuyến mãi
    public static List<Product> listDiscountProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT product.* FROM product INNER JOIN discount ON product.discountId = discount.id WHERE discount.startDate < CURRENT_DATE AND discount.endDate > CURRENT_DATE")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static List<Product> discountProduct() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT product.* FROM product INNER JOIN discount ON product.discountId = discount.id WHERE discount.startDate < CURRENT_DATE AND discount.endDate > CURRENT_DATE LIMIT 10")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static List<Product> sortDiscountProductAZ() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT product.* FROM product INNER JOIN discount ON product.discountId = discount.id WHERE discount.startDate < CURRENT_DATE AND discount.endDate > CURRENT_DATE  ORDER BY product.sellingPrice ASC")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static List<Product> sortDiscountProductZA() {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT product.* FROM product INNER JOIN discount ON product.discountId = discount.id WHERE discount.startDate < CURRENT_DATE AND discount.endDate > CURRENT_DATE ORDER BY product.sellingPrice DESC")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static void removeDiscount(int product_id) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE product SET discountId = 'null' WHERE id=?")
                        .bind(0, product_id)
                        .execute()
        );
    }

    public static void setDiscountForProductList(String discountId, List<String> product_id_list) {
        if (product_id_list != null && !product_id_list.isEmpty()) {
            StringBuilder ids = new StringBuilder();
            for (int i = 0; i < product_id_list.size(); i++) {
                String id = product_id_list.get(i);
                ids.append("'" + id + "'");
                if (i != product_id_list.size() - 1)
                    ids.append(",");
            }
            System.out.println("thay đổi 1 số");
            JDBIConnector.me().useHandle(handle ->
                    handle.createUpdate(
                                    "UPDATE product " +
                                            "SET discountId = null WHERE id NOT IN (" + ids + ") AND discountId = :id "
                            )
                            .bind("id", discountId)
                            .execute()
            );

            JDBIConnector.me().useHandle(handle ->
                    handle.createUpdate(
                                    "UPDATE product " +
                                            "SET discountId = :id WHERE id IN (" + ids + ")"
                            )
                            .bind("id", discountId)
                            .execute()
            );
        } else {
            System.out.println("bỏ tất cả");
            JDBIConnector.me().useHandle(handle ->
                    handle.createUpdate(
                                    "UPDATE product " +
                                            "SET discountId = null WHERE discountId= :id"
                            )
                            .bind("id", discountId)
                            .execute()
            );
        }

    }

    public static void setNullDiscountForProductList(String discountId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product " +
                                        "SET discountId = null WHERE discountId=?"
                        ).bind(0, discountId)
                        .execute()
        );
    }

    //Trang chính xuất 15 sản phẩm trong từng category và phải còn hàng
    public static List<Product> list15product(int idCategory) {
        List<Product> productList = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product WHERE categoryId = :id AND quantity > 0 LIMIT 15")
                        .bind("id", idCategory)
                        .mapToBean(Product.class)
                        .stream().toList()
        );
        return productList;
    }

    //Tìm sản phẩm
    public static List<Product> findProduct(String nameP) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product WHERE name LIKE :name")
                        .bind("name", "%" + nameP + "%")
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }


    public static void updateProduct(String id, String name, String description, double costPrice, double sellingPrice, int quantity, String categoryId, String discountId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product" +
                                        " SET name=:name, description=:description, costPrice=:costPrice, sellingPrice=:sellingPrice, quantity=:quantity, categoryId=:categoryId, discountId=:discountId" +
                                        " WHERE id=:id"
                        )
                        .bind("name", name)
                        .bind("description", description)
                        .bind("costPrice", costPrice)
                        .bind("sellingPrice", sellingPrice)
                        .bind("quantity", quantity)
                        .bind("categoryId", categoryId)
                        .bind("discountId", discountId)
                        .bind("id", id)
                        .execute()
        );
    }

    public static void updateProduct(String id, String name, String description, double costPrice, double sellingPrice, int quantity, String categoryId) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE product" +
                                        " SET name=:name, description=:description, costPrice=:costPrice, sellingPrice=:sellingPrice, quantity=:quantity, categoryId=:categoryId" +
                                        " WHERE id=:id"
                        )
                        .bind("name", name)
                        .bind("description", description)
                        .bind("costPrice", costPrice)
                        .bind("sellingPrice", sellingPrice)
                        .bind("quantity", quantity)
                        .bind("categoryId", categoryId)
                        .bind("id", id)
                        .execute()
        );
    }

    public static long getNumberAvailProduct() {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(id) from product where quantity>0 and isSale!=0").mapTo(Long.class).one());
    }

    public static List<Product> getTopSoldoutProduct(int number) {
        List<Product> products = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM product where soldout > 0 order by soldout limit ?")
                        .bind(0, number)
                        .mapToBean(Product.class)
                        .stream().toList());
        return products;
    }

    public static List<Rate> getRatesByStarNumber(int productId, int starRatings, Integer userId) {
        Integer star = starRatings;
        if (userId == null) {
            List<Rate> rateList = JDBIConnector.me().withHandle(
                    handle -> handle.createQuery("SELECT * FROM `rate`  where productId =:productId and starRatings=:star")
                            .bind("productId", productId)
                            .bind("star", (star == 1 || star == 2 || star == 3 || star == 4 || star == 5) ? star : null)
                            .mapToBean(Rate.class)
                            .stream().toList());
            return rateList;
        } else {
            List<Rate> rateList = JDBIConnector.me().withHandle(
                    handle -> handle.createQuery("SELECT * FROM `rate` WHERE productId = :productId AND starRatings = :star ORDER BY CASE WHEN userId = :userId THEN 0 ELSE 1 END, createDate DESC")
                            .bind("productId", productId)
                            .bind("star", (star == 1 || star == 2 || star == 3 || star == 4 || star == 5) ? star : null)
                            .bind("userId", userId)
                            .mapToBean(Rate.class)
                            .stream().toList());
            return rateList;
        }
    }

    public static Integer getStarNumberCount(int productId, int starRatings) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(userId) from rate where productId=? and starRatings=?")
                        .bind(0, productId)
                        .bind(1, starRatings)
                        .mapTo(Integer.class).one());
    }

    public static Integer getStarNumberCount(int productId) {
        return JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select count(userId) from rate where productId=?")
                        .bind(0, productId)
                        .mapTo(Integer.class).one());
    }

    public static Rate rateExists(int productId, int userId) {
        Optional<Rate> rate = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("SELECT * FROM `rate` WHERE productId = :productId AND userId = :userId")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .mapToBean(Rate.class)
                        .stream()
                        .findFirst()
        );
        return rate.isEmpty() ? null : rate.get();
    }

    public static void insertRate(int productId, int userId, int starRatings, String comment) {
        if (starRatings < 1 || starRatings > 5) {
            throw new IllegalArgumentException("starRatings must be between 1 and 5");
        }

        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("INSERT INTO `rate` (productId, userId, starRatings, comment) VALUES (:productId, :userId, :starRatings, :comment)")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .bind("starRatings", starRatings)
                        .bind("comment", comment)
                        .execute()
        );
    }

    public static void updateRate(int productId, int userId, int starRatings, String comment) {
        Rate rate = rateExists(productId, userId);
        if (starRatings < 1 || starRatings > 5) {
            throw new IllegalArgumentException("starRatings must be between 1 and 5");
        } else if (rate != null && rate.getChangeNumber() != 0) {
            throw new IllegalArgumentException("Không thể vì đã chỉnh sửa đánh giá");
        }
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE `rate` SET starRatings = :starRatings, comment = :comment, createDate = CURRENT_TIMESTAMP, changeNumber =:changeNumber WHERE productId = :productId AND userId = :userId")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .bind("starRatings", starRatings)
                        .bind("comment", comment)
                        .bind("changeNumber", 1)
                        .execute()
        );
    }


    public static List<Rate> getRatesFirstUser(int productId, int userId) {
        List<Rate> rateList = JDBIConnector.me().withHandle(
                handle -> handle.createQuery("SELECT * FROM `rate` WHERE productId = :productId  ORDER BY CASE WHEN userId = :userId THEN 0 ELSE 1 END, createDate DESC")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .mapToBean(Rate.class)
                        .stream().toList());
        return rateList;
    }

    public static void main(String[] args) {
        List<Rate> rates = ProductService.getInstance().getRatesByStarNumber(118,5 , null);
    }
}

