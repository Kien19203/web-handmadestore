package logs;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/*
CREATE TABLE Log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ipAddress VARCHAR(255),
    location VARCHAR(255),
    createdTime TIMESTAMP,
    level VARCHAR(50),
    action VARCHAR(255),
    message TEXT
);

 */
public class Log {
    private int id;
    private Timestamp createdTime;
    private String ipAddress;
    private String level;
    private String action;
    private String message;

    public Log() {
    }

    public Log(int id, Timestamp createdTime, String ipAddress, String level, String action, String message) {
        this.id = id;
        this.createdTime = createdTime;
        this.ipAddress = ipAddress;
        this.level = level;
        this.action = action;
        this.message = message;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Timestamp getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Timestamp createdTime) {
        this.createdTime = createdTime;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isINFORLevel() {
        return this.level.equals("INFOR");
    }

    public boolean isWARNINGLevel() {
        return this.level.equals("WARNING");
    }

    public boolean isDANGERLevel() {
        return this.level.equals("DANGER");
    }

    public String getFormattedCreatedTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        return sdf.format(this.createdTime);
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> main
