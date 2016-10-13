package test;

public class testDecrypto extends Rexpert.DataServer.ETC.IRexCrypto{
	public testDecrypto(){}
	
	public String encrypt(String sMsg) throws Exception{
		
		return "ss";
	}
	
	public String decrypt(String sMsg) throws Exception{
		
		return "ssdecrypt" + sMsg;
	}	
	
	public String encrypt(String sKey, String sMsg) throws Exception{
		
		return "ss";
	}	
	
	public String decrypt(String sKey, String sMsg) throws Exception{
		
		return "ss";
	}	

}


