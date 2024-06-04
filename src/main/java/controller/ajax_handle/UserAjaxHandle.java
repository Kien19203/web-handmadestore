package controller.ajax_handle;

import com.google.gson.Gson;
import model.bean.User;
import model.service.ImageService;
import model.service.UserService;
import utils.HashPassword;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user-ajax-handle")
public class UserAjaxHandle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String userId = req.getParameter("userId");
        if (action != null && userId != null) {
            if (action.equals("lockOrUnLock")) {
                //lock or unlock
                User u = UserService.getInstance().getUserById(userId);
                if (u.getStatus().trim().startsWith("Bình Thường")) {
                    UserService.getInstance().lockUser(userId);
                } else if (u.getStatus().trim().equalsIgnoreCase("Bị Khóa")) {
                    UserService.getInstance().unlockUser(userId);
                }
            } else if (action.equals("addUser")) {
                String name = req.getParameter("name");
                String phoneNumber = req.getParameter("phoneNumber");
                String email = req.getParameter("email");
                String password = req.getParameter("password");
                int roleId = Integer.parseInt(req.getParameter("roleId"));
                User newUser = UserService.getInstance().addUser(name, phoneNumber, email, HashPassword.toSHA1(password), roleId);
                Gson gson = new Gson();
                String jsonRatesResponse = gson.toJson(newUser);
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                System.out.println(jsonRatesResponse);
                resp.getWriter().write(jsonRatesResponse);
            }
        }
    }
}
