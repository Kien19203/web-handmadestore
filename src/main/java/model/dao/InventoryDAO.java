package model.dao;

import model.adapter.InventoryProduct;
import model.bean.Inventory;
import model.db.JDBIConnector;

import java.util.List;

public class InventoryDAO {

    /**
     * Hiển thị trên bảng tồn kho.
     * + Hàng tồn kho = Tổng số lượng - số lươợng đã bán. (Hàng tồn kho # stock trong product)
     * + Lần nhập gần nhất (cập nhật khi phiếu nhập import có product đó) - xử lý sau, hiện tại để mặc định ngày tạo.
     */
    public static List<InventoryProduct> showInventoryView() {
        String sql = "SELECT p.id, p.name, i.costPrice, p.sellingPrice, i.quantity - i.soldOut AS quantityRemaining , i.soldOut, i.createDate AS lastModified  " +
                "                  FROM product p JOIN inventory i " +
                    "              WHERE p.id = i.productId";
        List<InventoryProduct> inventoryProductList = JDBIConnector.me().withHandle(
                handle -> handle.createQuery(sql).mapToBean(InventoryProduct.class).stream().toList()
        );
        return inventoryProductList;
    }



    public static void main(String[] args) {
        for(InventoryProduct i : showInventoryView() ) {
            System.out.println(i.toString());
        }
    }
}


