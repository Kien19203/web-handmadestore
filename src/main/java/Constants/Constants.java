package Constants;

public class Constants {
    public static String GOOGLE_CLIENT_ID = "468559225769-mg6o9rdha4qnskdi68hsa7neo0c9qtq0.apps.googleusercontent.com";

    public static String GOOGLE_CLIENT_SECRET = "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";

    public static String GOOGLE_REDIRECT_URI = "http://localhost:8080/HandMadeStore/LoginGoogleHandler";

    public static String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";

    public static String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

    public static String GOOGLE_GRANT_TYPE = "authorization_code";
//    FaceBook

    public static final String FACEBOOK_CLIENT_ID = "1428287761185428";
    public static final String FACEBOOK_CLIENT_SECRET = "0381541e5f54be4abbf338100aa09baa";
    public static final String FACEBOOK_REDIRECT_URI = "http://localhost:8080/HandMadeStore/LoginFaceBookHandler";
    public static final String FACEBOOK_LINK_GET_TOKEN = "https://graph.facebook.com/v19.0/oauth/access_token";
    public static final String FACEBOOK_LINK_GET_USER_INFO = "https://graph.facebook.com/me?fields=id,name,email,picture&access_token=";



}

