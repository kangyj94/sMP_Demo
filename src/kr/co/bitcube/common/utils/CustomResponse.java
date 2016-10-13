package kr.co.bitcube.common.utils;

import java.util.ArrayList;
import java.util.List;

public class CustomResponse {

	/*** true if successful. */
	private Boolean success;
	/*** Any custom message, i.e, 'Your request has been processed successfully!' */
	private List<String> message;
	/*** insert 시 생성되는 값 */
	private Object newIdx;

	public CustomResponse() {
		message = new ArrayList<String>();
	}
	public CustomResponse(Boolean success) {
		message = new ArrayList<String>();
		this.success = success;
	}
	public Boolean getSuccess() {
		return success;
	}
	public void setSuccess(Boolean success) {
		this.success = success;
	}
	public List<String> getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message.add(message);
	}
	public Object getNewIdx() {
		return newIdx;
	}
	public void setNewIdx(Object newIdx) {
		this.newIdx = newIdx;
	}
}
