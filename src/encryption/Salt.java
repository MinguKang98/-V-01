package encryption;

import java.security.SecureRandom;

public class Salt {
    private static final int SALT_SIZE = 16;

    public static String getSalt() {
        SecureRandom rnd = new SecureRandom();
        byte[] temp = new byte[SALT_SIZE];
        rnd.nextBytes(temp);

        return byteToString(temp);

    }

    public static String byteToString(byte[] temp) {
        StringBuilder sb = new StringBuilder();
        for(byte t : temp) {
            sb.append(String.format("%02x", t));
        }
        return sb.toString();
    }
}
