package kr.co.bitcube.common.dto;

/**
 * 웹체팅에 사용할 메세지 Dto
 * @author tytolee
 * @since 2012-05-22
 */
public class WebChatDto {
	private String fromMemberNo;   // 발송자 번호
	private String fromMemberName; // 발송자 이름
	private String fromMemberBorgNm; // 발송자 조직명
	private String toMemberNo;     // 수신자 번호
	private String message;        // 메세지
	private String type;           // 반응 타입
	
	public String getFromMemberBorgNm() {
		return fromMemberBorgNm;
	}
	public void setFromMemberBorgNm(String fromMemberBorgNm) {
		this.fromMemberBorgNm = fromMemberBorgNm;
	}
	public String getFromMemberName() {
		return fromMemberName;
	}
	public void setFromMemberName(String fromMemberName) {
		this.fromMemberName = fromMemberName;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getFromMemberNo() {
		return fromMemberNo;
	}
	public void setFromMemberNo(String fromMemberNo) {
		this.fromMemberNo = fromMemberNo;
	}
	public String getToMemberNo() {
		return toMemberNo;
	}
	public void setToMemberNo(String toMemberNo) {
		this.toMemberNo = toMemberNo;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	@Override
	public String toString() {
		String result = null;
		
		result = "fromMemberNo : " + this.getFromMemberNo();
		result += "\tfromMemberName : " + this.getFromMemberName();
		result += "\ttoMemberNo : " + this.getToMemberNo();
		result += "\tmessage : " + this.getMessage();
		result += "\ttype : " + this.getType();
		
		return result;
	}
}
