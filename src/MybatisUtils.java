import java.lang.reflect.Array;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.List;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public class MybatisUtils {
	/**
	* Mybatis xml 의 Empty 비교연산자
	* @param obj
	* @return
	*/
	@SuppressWarnings("rawtypes")
	public static boolean isEmpty(Object obj){
		if( obj instanceof String ) return obj==null || "".equals(obj.toString().trim());
		else if( obj instanceof List ) return obj==null || ((List)obj).isEmpty();
		else if( obj instanceof Map ) return obj==null || ((Map)obj).isEmpty();
		else if( obj instanceof Object[] ) return obj==null || Array.getLength(obj)==0;
		else return obj==null;
	}
	public static boolean isNotEmpty(String s){
		return !isEmpty(s);
	}
	public static boolean isTrue(Object obj) {
		if( obj instanceof Boolean ) {
			return (boolean) obj;
		}
		return false;
	}

	/**
	* Mybatis xml 의 암호화, 복호화
	* @param obj
	* @return
	*/
	//AES 암호화
	public static String encrypt(String cleartext) throws Exception {
		return encrypt("lottemembers",cleartext);
	}
	public static String encrypt(String seed, String cleartext) throws Exception {
		if (cleartext == null) return "";
		byte[] rawKey = getRawKey(seed.getBytes());
		byte[] result = encrypt(rawKey, cleartext.getBytes());
		return toHex(result);
	}

	//AES 복호화
	public static String decrypt(String encrypted) throws Exception {
		return decrypt("lottemembers", encrypted);
	}
	public static String decrypt(String seed, String encrypted) throws Exception {
		if (encrypted == null || encrypted.length() % 32 != 0) return "";
		byte[] rawKey = getRawKey(seed.getBytes());
		byte[] enc = toByte(encrypted);
		byte[] result = decrypt(rawKey, enc);
		return new String(result);
	}
	private static byte[] getRawKey(byte[] seed) throws Exception {
		KeyGenerator kgen = KeyGenerator.getInstance("AES");
		SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
		sr.setSeed(seed);
		kgen.init(128, sr); // 192 and 256 bits may not be available
		SecretKey skey = kgen.generateKey();
		byte[] raw = skey.getEncoded();
		return raw;
	}
	private static byte[] encrypt(byte[] raw, byte[] clear) throws Exception {
		SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
		byte[] encrypted = cipher.doFinal(clear);
		return encrypted;
	}
	private static byte[] decrypt(byte[] raw, byte[] encrypted) throws Exception {
		SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.DECRYPT_MODE, skeySpec);
		byte[] decrypted = cipher.doFinal(encrypted);
		return decrypted;
	}
	public static String toHex(String txt) {
		return toHex(txt.getBytes());
	}
	public static String fromHex(String hex) {
		return new String(toByte(hex));
	}
	public static byte[] toByte(String hexString) {
		int len = hexString.length()/2;
		byte[] result = new byte[len];
		for (int i = 0; i < len; i++)
			result[i] = Integer.valueOf(hexString.substring(2*i, 2*i+2), 16).byteValue();
		return result;
	}
	public static String toHex(byte[] buf) {
		if (buf == null) return "";
		StringBuffer result = new StringBuffer(2*buf.length);
		for (int i = 0; i < buf.length; i++) {
			appendHex(result, buf[i]);
		}
		return result.toString();
	}

	private final static String HEX = "0123456789ABCDEF";
	private static void appendHex(StringBuffer sb, byte b) {
		sb.append(HEX.charAt((b>>4)&0x0f)).append(HEX.charAt(b&0x0f));
	}

	//MD5 암호화
	public static String getMD5(String input){
		input = input + "lottemembers";
		try{
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] messageDigest = md.digest(input.getBytes());
			BigInteger number = new BigInteger(1, messageDigest);
			String hashtext = number.toString(16);
			while (hashtext.length() < 32){
				hashtext = "0" + hashtext;
			}
			return hashtext;
		} catch (NoSuchAlgorithmException e){
			return null;
		}
	}

	// SHA-256
	public static String getSHA256(String str){
		String SHA = ""; 
		str = str + "lottemembers";
		try {
			MessageDigest sh = MessageDigest.getInstance("SHA-256"); 
			sh.update(str.getBytes()); 
			byte byteData[] = sh.digest();
			StringBuffer sb = new StringBuffer(); 
			for(int i = 0 ; i < byteData.length ; i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
			}
			SHA = sb.toString();
		} catch(NoSuchAlgorithmException e) {
			 
			SHA = null; 
		}
		return SHA;
	}

	public static void main(String [] args) {
		String pwd = "1111";
		try {
			pwd = encrypt(pwd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			
		}
		
	}
}