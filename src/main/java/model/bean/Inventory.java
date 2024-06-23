package model.bean;

import lombok.*;

import java.io.Serializable;
import java.util.Date;

//Sử dụng lombok thay cho constructor, getter, setter.

/**
 * quantity : Tổng số lượng sản phẩm
 * costPrice : Giá nhập sản phẩm.
 * soldOut : Số lượng sản phẩm đã bán ra.
 * createDate: Ngày tạo sản phẩm.
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class Inventory implements Serializable {
    private int productId;
    private int quantity;
    private double costPrice;
    private int soldOut;
    private Date createDate;

}
