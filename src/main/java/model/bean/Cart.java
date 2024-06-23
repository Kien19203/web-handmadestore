package model.bean;

import com.google.protobuf.MapEntry;
import model.service.ProductService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Cart {
    //Giỏ hàng chứa danh sách các item
//    private List<Item> items;

    Map<Integer, Item> items = new HashMap<>();

    public Map<Integer, Item> getItems() {
        return items;
    }

    public void setItems(Map<Integer, Item> items) {
        this.items = items;
    }

    //thêm 1 sản phầm
    public boolean add(int id) {
        return add(id, 1);
    }

    public boolean add(int id, int quantity) {
        Product p = ProductService.getInstance().getProductById(id);
        if (p == null) return false;
        Item item = null;
        if (items.containsKey(id)) {
            item = items.get(id);
            item.incQuantity(quantity);

        } else {
            item = new Item(p, quantity,
                    ProductService.getInstance().productPriceIncludeDiscount(p));
        }
        items.put(id, item);
        return true;
    }


    public int getQuantityById(int id) {
        int i = 0;
        if (!items.containsKey(id)) return i;

        Item item = items.get(id);
        i = item.getQuantity();
        return i;
    }

    public boolean remove(int id) {
        if (!items.containsKey(id)) return false;
        items.remove(id);
        return true;
    }

    public void updateValue(int id) {
        if (!items.containsKey(id)) return;

    }

    public double getTotalMoney() {
        double totalMoney = 0;
        for (Item item : items.values()) {
            totalMoney += (item.getQuantity() * item.getProduct().getSellingPrice());
        }
        return totalMoney;
    }

    public int getTotal() {
        return items.size();
    }


    public void clear() {
        items.clear();
    }

    //giỏ trống khong có gì.
//    public Cart() {
//        items = new ArrayList<>();
//    }
//
//    public List<Item> getItems() {
//        return items;
//    }
//
//    public void setItems(List<Item> items) {
//        this.items = items;
//    }

    /**
     * lấy số luượng mỗi sản phâm nào đó ở trong giỏ
     * id : id product.
     * Cộng dồn số lượng sản phẩm. (khi khách hàng thêm sản phẩm ngắt quãng)
     * Lần 1: Bỏ vào 1 cái
     * Lần 2: bỏ vào thêm 3 cái
     */
//    public int getQuantityById(int id) {
//        return getItemById(id).getQuantity();
//    }


//    private Item getItemById(int id) {
//        for (Item i : items) {
//            if (i.getProduct().getId() == id)
//                return i;
//        }
//        return null;
//
//    }
    /**
     *  Thêm item vào giỏ hàng.
     * + Đã có thì chỉ thêm số lượng vào thôi
     * + Chưa có thì mới phải add thêm.
     *
     */

//    public void addItem (Item t) {
//        if(getItemById(t.getProduct().getId()) != null) {
//            Item m = getItemById(t.getProduct().getId());
//            m.setQuantity(m.getQuantity() + t.getQuantity());
//        }
//        else {
//            items.add(t);
//        }
//    }

    /**
     * Xóa 1 item ra khỏi giỏ hàng hiện tại
     * id: Id của product muốn xóa khỏi giỏ.
     * Check nó có trong giỏ hàng thì cho nó cook.
     */

//    public void removeItem(int id) {
//        if(getItemById(id)!= null) {
//            items.remove(getItemById(id));
//        }
//    }

    /** GIẢI QUYẾT KHUYẾN MÃI.
     * Tổng tiền giỏ hàng nefeee.
     *
     * Tổng tiền = Số lượng item * Mỗi sản phẩm * giá của từng sản phẩm.
     */
//    public double getTotalPrice() {
//        double t =0;
//        for(Item s : items) {
//            t += (s.getQuantity()*s.getProduct().getSellingPrice());
//             }
//        return t;
//    }


}
