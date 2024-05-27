package controller.ajax_handle;

import com.google.gson.Gson;
import model.bean.Rate;
import model.service.ImageService;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/rate-ajax-handle")
public class RateAjaxHandle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String productId = req.getParameter("productId");

        if (action != null && productId != null) {
            if (action.equals("filterStar")) {
                String starNumber = req.getParameter("starNumber");
                try {
                    int p = Integer.parseInt(productId);
                    int s = Integer.parseInt(starNumber);
                    List<Rate> rates = (s!=0)?ProductService.getInstance().getRatesByStarNumber(p,s):ProductService.getInstance().getRateForProduct(p);

                    Gson gson = new Gson();
                    String jsonRatesResponse = gson.toJson(rates);
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(jsonRatesResponse);
                }catch (Exception e){
                    e.printStackTrace();
                }
            }else if(action.equals("addRate")){
                String userId = req.getParameter("userId");
                String starNumber = req.getParameter("starNumber");
                String comment = req.getParameter("comment");


            }
        }
    }
}
