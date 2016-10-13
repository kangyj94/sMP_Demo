package kr.co.bitcube.system.exception;

@SuppressWarnings("serial")
public class SystemUserLoginException extends RuntimeException {
	public SystemUserLoginException() {
		super();
	}
	
	public SystemUserLoginException(String message) {
		super(message);
	}
}
