package model.dao;

import model.bean.Category;
import model.bean.Discount;
import model.bean.User;
import model.db.JDBIConnector;
import model.service.ProductService;
import org.h2.expression.function.SysInfoFunction;

import javax.xml.transform.stream.StreamSource;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

public class DiscountDAO {
    public static List<Discount> getAll() {
        List<Discount> categories = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from discount")
                        .mapToBean(Discount.class).stream().collect(Collectors.toList())
        );
        return categories;
    }

    public static Discount getDiscountById(String id) {
        Optional<Discount> discount = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from discount where id= :id")
                        .bind("id", id)
                        .mapToBean(Discount.class)
                        .stream()
                        .findFirst()
        );
        return discount.isEmpty() ? null : discount.get();
    }

    public static void insertDiscount(String name, String startDate, String endDate, double percentageOff) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("INSERT INTO discount (name, startDate, endDate, percentageOff) VALUES (:name, :startDate, :endDate, :percentageOff)")
                        .bind("name", name)
                        .bind("startDate", startDate + " 00:00:00")
                        .bind("endDate", endDate + " 00:00:00")
                        .bind("percentageOff", percentageOff)
                        .execute()
        );
    }

    public static void deleteDiscountById(String id) {
        //set products list bằng null
        ProductService.getInstance().unSetDiscountForAllProducts(id);
        //xóa discount
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate(
                                "DELETE FROM discount " +
                                        "WHERE id= :id"
                        )
                        .bind("id", id)
                        .execute()
        );
    }

    /*
    "UPDATE product " +
                                                "SET discountId = null WHERE id NOT IN (" + ids + ") AND discountId = :id "
     */
    public static void updateDiscount(String editDiscountId, String name, String startDate, String endDate, double percentageOff) {
        JDBIConnector.me().useHandle(handle ->
                handle.createUpdate("UPDATE discount " +
                                "SET name=:name,startDate=:startDate,endDate=:endDate,percentageOff=:percentageOff " +
                                "WHERE id=:editDiscountId")
                        .bind("editDiscountId", editDiscountId) // Generate a random 6-character ID
                        .bind("name", name)
                        .bind("startDate", startDate + " 00:00:00")
                        .bind("endDate", endDate + " 00:00:00")
                        .bind("percentageOff", percentageOff)
                        .execute()
        );
    }
}
