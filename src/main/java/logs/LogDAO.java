package logs;
import model.db.JDBIConnector;

import java.util.List;
import java.util.stream.Collectors;
public class LogDAO {
    //    insert Log
    public static void insertFailedMultipleTimesLoginLog(String ipAddress, String location, EAction action, ELevel level, String userEmail) {

    }

    public static void addInsertLog(String user, String ipAddress, String location, EAction action, ELevel level, String tableName, String message) {

    }

    //    select All
    public static List<Log> getAllLogs() {
        List<Log> logs = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from log order by createdTime desc").mapToBean(Log.class).stream().collect(Collectors.toList()));
        return logs;
    }
    public static List<Log> getThreeRecentlyLogs() {
        List<Log> logs = JDBIConnector.me().withHandle(handle ->
                handle.createQuery("select * from log order by createdTime desc limit 3 ").mapToBean(Log.class).stream().collect(Collectors.toList()));
        return logs;
    }

    //    select By Id
    public static Log getLogById() {

        return null;
    }
}
