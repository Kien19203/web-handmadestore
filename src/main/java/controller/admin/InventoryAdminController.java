package controller.admin;

import model.service.CategoryService;
import model.service.ImageService;
import model.service.InventoryService;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "InventoryAdminController", value = "/admin/inventory")
public class InventoryAdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
doPost(req,resp);    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        req.getRequestDispatcher("/views/Admin/inventory_management.jsp").forward(req, resp);
    }

    private void editProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

//                        Sửa sảm phẩm
        String edit_product_id = req.getParameter("edit_product_id");
        String last_edit_product_id = req.getParameter("last_edit_product_id");
        if (edit_product_id != null) {
            req.setAttribute("edit_product", InventoryService.getInstance().getIdProduct(Integer.parseInt(edit_product_id)));
        } else if (last_edit_product_id != null) {
          /*
          Chỉnh sửa thông tin bao gồm:
          tên, giá bán, loại danh mục, loại khuyến mãi, mô tả sản phẩm, trạng thái sản phẩm

           */
            String productName = req.getParameter("productName");
            String sellingPrice = req.getParameter("sellingPrice");
            String radio_choiceCategory = req.getParameter("choiceCategory");
            String discount = req.getParameter("discount");
            String description = req.getParameter("description");
            String isSale = req.getParameter("isSale");
            String availableCategory = req.getParameter("availableCategory");//category id
            String newCategory = req.getParameter("newCategory");

/*
           Kiểm tra đủ tt?
                Chưa -> forward kèm attribute để khỏi nhập lại,
                Đủ -> forward nếu parse không thành công (DL sai), ngược lại update db và forward thành công
 */
            //write
            List<String> paths = ImageService.writeProductImagesFromClient(productName, req, resp, getServletContext());
            if (!paths.isEmpty()) {
                ImageService.insertImages(last_edit_product_id, paths);
            }
            if (!(productName.equals("") || sellingPrice.equals("")|| description.equals("") || isSale.equals("") ||
                    (radio_choiceCategory == null || radio_choiceCategory.equals("")))) {
                System.out.println("ok đủ tt");
                if (radio_choiceCategory != null) {
                    String categoryId = null;
                    if (radio_choiceCategory.equals("choiceAvailableCategory")) {
                        //Danh mục có sẵn
                        categoryId = availableCategory;

                        /*--------------------------------------updateProduct START ------------------------------------------*/

                        try {
                            if (discount.equals(""))
                                InventoryService.getInstance().editProduct(last_edit_product_id,productName,description, Double.parseDouble(sellingPrice), categoryId, Integer.parseInt(isSale) );

                            else
                                InventoryService.getInstance().editProduct(last_edit_product_id, productName, description, Double.parseDouble(sellingPrice), categoryId, discount, Integer.parseInt(isSale));
                            req.setAttribute("result", "Đã thành công thay đổi thông tin sản phẩm.");
                        } catch (NullPointerException e) {
                            req.setAttribute("result", "Dữ liệu không chính xác!Vui lòng thử lại");
                        }
                    } else if (radio_choiceCategory.equals("choiceNewCategory")) {
                        //create new category in table
                        categoryId = CategoryService.getInstance().createNewCategory(newCategory) + "";
                        try {
                            if (discount.equals(""))
                                InventoryService.getInstance().editProduct(last_edit_product_id, productName, description,Double.parseDouble(sellingPrice), categoryId, Integer.parseInt(isSale));
                            else
                                InventoryService.getInstance().editProduct(last_edit_product_id, productName, description,Double.parseDouble(sellingPrice), categoryId, discount, Integer.parseInt(isSale));
                            req.setAttribute("result", "Đã thành công thay đổi thông tin sản phẩm.");
                        } catch (NullPointerException e) {
                            CategoryService.getInstance().deleteNoUsedCategoryById(categoryId);
                            req.setAttribute("result", "Dữ liệu không chính xác!Vui lòng thử lại");
                        }

                        /*--------------------------------------updateProduct END ------------------------------------------*/

                    }
                }
            } else {
                req.setAttribute("edit_product", ProductService.getInstance().getProductById(last_edit_product_id));
                req.setAttribute("result", "Điền đầy đủ để thay đổi thông tin sản phẩm! Vui lòng thử lại");
                System.out.println("Thiếu tt");
            }
        }
    }
}
