package controller;

import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Validation {
    public static boolean checkEmail(String email) {
        String regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(email);
        return !email.isEmpty() && matcher.matches();
    }

    public static boolean checkPhoneNumber(String phoneNumber) {
        String regex = "^0\\d{2}\\d{3}\\d{4}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(phoneNumber);
        return  !phoneNumber.isEmpty() && matcher.matches();
    }

    public static boolean checkPassword(String password) {
        String regex = "^(?=.*[A-Z])(?=.*[\\W_])(?=.*[a-z]).{8,}$"; // >8 ký tự, ít nhất 1 Hoa, 1 ký tự đặc biệt
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(password);
        return  !password.isEmpty() &&matcher.matches();
    }

    public static boolean isPositiveNumber(String str) {
        try {
            int number = Integer.parseInt(str);
            return number >= 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static void main(String[] args) {
        System.out.println("Pblues " + checkPassword("Pblues"));
        System.out.println("Pblues@32 " + checkPassword("Pblues@32"));
        System.out.println(checkEmail("Pblues@32"));
        System.out.println(checkEmail("Pblues@gmai.com"));
        System.out.println(checkPhoneNumber("3222345454"));
        System.out.println(checkPhoneNumber("0336677145"));
        System.out.println(checkPhoneNumber("0336677148"));

    }
}
