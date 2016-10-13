package kr.co.bitcube.common.utils;

public class UserAgentDetails {
	private String browserName;
	private String browserVersion;
	private String browserComments;

	UserAgentDetails(String browserName, String browserVersion, String browserComments) {
		this.browserName = browserName;
		this.browserVersion = browserVersion;
		this.browserComments = browserComments;
	}

	public String getBrowserComments() {
		return browserComments;
	}

	public String getBrowserName() {
		return browserName;
	}

	public String getBrowserVersion() {
		return browserVersion;
	}
}
