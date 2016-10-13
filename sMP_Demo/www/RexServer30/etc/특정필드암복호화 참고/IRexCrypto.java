package Rexpert.DataServer.ETC;

public abstract class IRexCrypto {
	public abstract String encrypt(String sMsg) throws Exception;
	public abstract String decrypt(String sMsg) throws Exception;
	public abstract String encrypt(String sKey, String sMsg) throws Exception;
	public abstract String decrypt(String sKey, String sMsg) throws Exception;
}
