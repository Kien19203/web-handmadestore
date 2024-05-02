package log_test;

public abstract class AbsDAO<T extends IModel> implements IDAO<T>{
    int update(T model){
        Logging.update(model);
        return 1;
    }
}
