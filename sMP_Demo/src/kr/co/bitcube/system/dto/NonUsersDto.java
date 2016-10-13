package kr.co.bitcube.system.dto;

public class NonUsersDto {
	private String nonUserId;
	private String userId;
	private String businessNum;
	private String pwd;
	private String bussinessNm;
	private String loginDate;
	private int loginCnt;
	private String remoteIp;
	private String borgId;
	private String userNm;
	
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getBorgId() {
		return borgId;
	}
	public void setBorgId(String borgId) {
		this.borgId = borgId;
	}
	public String getNonUserId() {
		return nonUserId;
	}
	public void setNonUserId(String nonUserId) {
		this.nonUserId = nonUserId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getBusinessNum() {
		return businessNum;
	}
	public void setBusinessNum(String businessNum) {
		this.businessNum = businessNum;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getBussinessNm() {
		return bussinessNm;
	}
	public void setBussinessNm(String bussinessNm) {
		this.bussinessNm = bussinessNm;
	}
	public String getLoginDate() {
		return loginDate;
	}
	public void setLoginDate(String loginDate) {
		this.loginDate = loginDate;
	}
	public int getLoginCnt() {
		return loginCnt;
	}
	public void setLoginCnt(int loginCnt) {
		this.loginCnt = loginCnt;
	}
	public String getRemoteIp() {
		return remoteIp;
	}
	public void setRemoteIp(String remoteIp) {
		this.remoteIp = remoteIp;
	}
}
