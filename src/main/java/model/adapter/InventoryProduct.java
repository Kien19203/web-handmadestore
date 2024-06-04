package model.adapter;

import lombok.*;

import java.io.Serializable;
import java.util.Date;



@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@ToString
public class InventoryProduct implements Serializable {
        private int id;
        private String name;
        private double costPrice;
        private double sellingPrice;
        private int quantityRemaining; // Số lượng hàng tồn kho
        private int soldOut;
        private Date lastModified; //ngày nhập hàng gần nhất.
}
