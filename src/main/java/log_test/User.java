package log_test;

public class User implements IModel{

    @Override
    public String getTable() {
        return "User";
    }

    @Override
    public String beforeData() {
        return "{ User: Name = Ong A }";
    }

    @Override
    public String afterData() {
        return "{ User: Name= Ba B }";
    }
}
