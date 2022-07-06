package encryption;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256 {
    public static String encryptSHA256(String str, String salt) {
        String result = "";

        byte[] strBytes = str.getBytes();
        byte[] saltBytes = salt.getBytes();
        byte[] mergeBytes = new byte[strBytes.length + saltBytes.length];

        System.arraycopy(strBytes, 0, mergeBytes, 0, strBytes.length);
        System.arraycopy(saltBytes, 0, mergeBytes, strBytes.length, saltBytes.length);
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(mergeBytes);

            byte byteData[] = md.digest();
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }
            result = sb.toString();
        } catch (NoSuchAlgorithmException e) {
            System.out.println("Encrypt Error - NoSuchAlgorithmException");
            result = null;
        }
        return result;
    }

    public static void main(String[] args) {
        String pw1 = "123a!";
        String pw2 = "123a!";
        String salt = Salt.getSalt();
        String en1 = encryptSHA256(pw1, salt);
        String en2 = encryptSHA256(pw2, salt);
        System.out.println("salt = " + salt);
        System.out.println("en1 = " + en1);
        System.out.println("en2 = " + en2);
        System.out.println(en1.equals(en2));
    }
}
