package poly.util;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.tomcat.util.codec.binary.Base64;

public class EncryptUtil {
	
	/*
	 * ��ȣȭ �˰��� �߰���ų ��ȣȭ ����
	 * 
	 * 
	 * �Ϲ����� ��ȣȭ �˰��� SHA-256�� ���ؼ��� ��ȣȭ ��ų ���, ��ȣȭ �� ���� ���� �Ϲ����� ��й�ȣ�� ���� ���� ����
	 * �����ϱ� �����Կ� ����, ��ȣȭ�� �� ��ȣȭ�Ǵ� ���� �߰����� ���ڿ��� �ٿ��� �Բ� ��ȣȭ�� ������
	 */
	final static String addMessage = "PolyDataAnalysis";// ���� ��
	
	/*
	 * AES128-CBC ��ȣȭ �˰��� ���Ǵ� �ʱ� ���Ϳ� ��ȣȭ Ű
	 */
	
	//�ʱ� ����(16����Ʈ ũ�⸦ ������, 16����Ʈ ������ ��ȣȭ��, ��ȣȭ�� �� ���̰� 16����Ʈ�� ���� ���ϸ� �ڿ� �߰��ϴ� ����Ʈ)
	final static byte[] ivBytes = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, };
	
	//AES128-CBC ��ȣȭ �˰��� ���Ǵ� Ű (16�ڸ� ���ڸ� ������)
	final static String key = "PolyTechnic12345";; //16����(������ 1���ڴ� 1����Ʈ��)
	
	/**
	 * �ؽ� �˰���(�ܹ��� ��ȣȭ �˰���)-SHA-256
	 * 
	 * @param ��ȣȭ ��ų ��
	 * @return ��ȣȭ�� ��
	 */
	public static String encHashSHA256(String str) throws Exception {
		
		String res = ""; //��ȣȭ ������� ����Ǵ� ����
		String plantText = addMessage + str; // ��ȣȭ ��ų ���� ���Ȱ�ȭ�� ���� ���� ���� �߰���
		
		try {
			
			//�ڹٴ� �⺻������ ǥ�� ��ȣȭ �˰����� java.security ��Ű���� ���� ������
			//���� �ؽ� �˰��� �� ���� ���� ���Ǵ� SHA-256�� �����ϰ� ����
			MessageDigest sh = MessageDigest.getInstance("SHA-256");
			
			sh.update(plantText.getBytes()); //������ ���ڿ��� byte���·� �ٲ�
			
			byte byteData[] = sh.digest(); //byte������ �迭�� ���� ����?byteData.length���� ����������
			
			StringBuffer sb = new StringBuffer(); //StringBuffer()�� �������� ? .append�� ����ϱ� ����. ���ڿ� �ڿ� ���ڿ��� ������.
			
			for(int i = 0; i < byteData.length; i++) {
				sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
				
			}
			
			res = sb.toString(); //����� ���� ���·� ��ȯ���ش�.
			
			//�ڹٿ��� �����ϴ� �˰����� �ƴ� ���, �����߻�
		}catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			
			res = "";
		
		}
		
		return res;
		
	}
	
	/**
	 * AES128-CBC ��ȣȭ �Լ�
	 * 
	 * 128�� ��ȣȭ Ű ���̸� �ǹ��� 128��Ʈ�� =16����Ʈ(1����Ʈ=8��Ʈ*19 = 128)
	 */
	public static String encAES128CBC(String str)
			throws UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException{
		
		byte[] textBytes = str.getBytes("UTF-8");//��ȣȭ ��ų���� Byte���� UTF-8�� �ٲ�
		AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes); //ivBytes �ڿ� ������ �ʱ� ���͸� �־��ش�.
		SecretKeySpec newKey = new SecretKeySpec(key.getBytes("UTF-8"),"AES"); //AES��ȣȭ�� byte������ �ٲ۴�.
		Cipher cipher = null;
		cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");//�ڹٿ��� �����ϴ� AES�˰���CBC�˰��� PKCS5Padding �ڿ� 16����Ʈ�� �ȵɶ� �ڿ��ٰ� �ʱ� ���� ����.
		cipher.init(Cipher.ENCRYPT_MODE, newKey, ivSpec); //key�� ���̿� ���� 8��Ʈ�� 64, 16��Ʈ�� 128
		return Base64.encodeBase64String(cipher.doFinal(textBytes));
	}
	
	/**
	 * AES128 CBC ��ȣȭ �Լ�
	 * 
	 * 128�� ��ȣȭ Ű ���̸� �ǹ��� 128��Ʈ�� = 16����Ʈ(1����Ʈ=8��Ʈ * 16= 128)
	 */
	public static String decAES128CBC(String str)
			throws UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException{
		
		byte[] textBytes = Base64.decodeBase64(str);
		//byte[] textBytes = set.getBytes("UTF-8");
		AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		SecretKeySpec newKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.DECRYPT_MODE, newKey, ivSpec);
		return new String(cipher.doFinal(textBytes),"UTF-8");
	}
	
	
}