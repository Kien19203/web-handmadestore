package log_test;

import model.bean.User;

import java.time.LocalTime;

public class Logging {
    public static void update(IModel model) {
//        in ra before data - updated data
        System.out.println("Table? -> " + model.getTable()
                + "\n before: " + model.beforeData()
                + "\n after: " + model.afterData());
    }
    public static void cancelOrder(IModel model, User user){
        System.out.println(LocalTime.now().toString()+": "+
                user.getName()+"("+user.getId()+")"
                +" đã hủy đơn hàng có mã đơn hàng là "
                + model.beforeData());
    }
}
