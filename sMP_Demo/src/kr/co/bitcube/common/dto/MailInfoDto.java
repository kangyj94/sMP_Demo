package kr.co.bitcube.common.dto;

public class MailInfoDto {

	private String mailSeq;
	private String mailSubject;
	private String mailContents;
	private String receiveMailAddrs;
	private String sendFlag;
	private String errMsg;
	private String sendDate;
	private String createDate;
	
	public String getMailSeq() {
		return mailSeq;
	}
	public void setMailSeq(String mailSeq) {
		this.mailSeq = mailSeq;
	}
	public String getMailSubject() {
		return mailSubject;
	}
	public void setMailSubject(String mailSubject) {
		this.mailSubject = mailSubject;
	}
	public String getMailContents() {
		return mailContents;
	}
	public void setMailContents(String mailContents) {
		this.mailContents = mailContents;
	}
	public String getReceiveMailAddrs() {
		return receiveMailAddrs;
	}
	public void setReceiveMailAddrs(String receiveMailAddrs) {
		this.receiveMailAddrs = receiveMailAddrs;
	}
	public String getSendFlag() {
		return sendFlag;
	}
	public void setSendFlag(String sendFlag) {
		this.sendFlag = sendFlag;
	}
	public String getErrMsg() {
		return errMsg;
	}
	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
	}
	public String getSendDate() {
		return sendDate;
	}
	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
}
