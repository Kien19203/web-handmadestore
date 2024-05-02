package log_test;

public class UserDAO extends  AbsDAO<User>{
    @Override
    public int update(User model){
        super.update(model);
        return 1;
    }
}
