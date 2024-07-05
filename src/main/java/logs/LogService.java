package logs;

import java.util.List;

public class LogService {
    private static LogService instance;

    public static LogService getInstance() {
        if (instance == null) instance = new LogService();
        return instance;
    }
    //    addLog

    //    getAll
    public List<Log> getAllLogs() {
        return LogDAO.getAllLogs();
    }
    public List<Log> getThreeRecentlyLogs() {
        return LogDAO.getThreeRecentlyLogs();
    }
    //    getLogById

<<<<<<< HEAD
}
=======
}
>>>>>>> main
