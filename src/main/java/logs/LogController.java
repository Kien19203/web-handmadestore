package logs;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/log")
public class LogController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action != null) {
            if (action.equals("removeLog")) {
                String id = req.getParameter("id");
                LoggingService.getInstance().deleteAlertInformLogById(Integer.parseInt(id));
            } else if (action.equals("clearInformLogs")) {
                LoggingService.getInstance().deleteInformLogs();
            } else if (action.equals("clearAlertLogs")) {
                LoggingService.getInstance().deleteAlertLogs();
            }
        }
    }
}
