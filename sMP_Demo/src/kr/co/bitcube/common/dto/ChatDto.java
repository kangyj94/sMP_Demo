package kr.co.bitcube.common.dto;

public class ChatDto {

	private String chatId;
	private String fromUserId;
	private String fromBranchId;
	private String fromUserNm;
	private String toUserId;
	private String toBranchId;
	private String toUserNm;
	private String message;
	private String createDate;
	private String receiveFlag;
	
	public String getChatId() {
		return chatId;
	}
	public void setChatId(String chatId) {
		this.chatId = chatId;
	}
	public String getFromUserId() {
		return fromUserId;
	}
	public void setFromUserId(String fromUserId) {
		this.fromUserId = fromUserId;
	}
	public String getFromBranchId() {
		return fromBranchId;
	}
	public void setFromBranchId(String fromBranchId) {
		this.fromBranchId = fromBranchId;
	}
	public String getFromUserNm() {
		return fromUserNm;
	}
	public void setFromUserNm(String fromUserNm) {
		this.fromUserNm = fromUserNm;
	}
	public String getToUserId() {
		return toUserId;
	}
	public void setToUserId(String toUserId) {
		this.toUserId = toUserId;
	}
	public String getToBranchId() {
		return toBranchId;
	}
	public void setToBranchId(String toBranchId) {
		this.toBranchId = toBranchId;
	}
	public String getToUserNm() {
		return toUserNm;
	}
	public void setToUserNm(String toUserNm) {
		this.toUserNm = toUserNm;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getReceiveFlag() {
		return receiveFlag;
	}
	public void setReceiveFlag(String receiveFlag) {
		this.receiveFlag = receiveFlag;
	}
}
