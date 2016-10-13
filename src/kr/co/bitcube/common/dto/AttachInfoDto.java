package kr.co.bitcube.common.dto;

public class AttachInfoDto {

	private String attach_seq;
	private String attach_file_name;
	private String attach_file_path;
	
	public String getAttach_seq() {
		return attach_seq;
	}
	public void setAttach_seq(String attach_seq) {
		this.attach_seq = attach_seq;
	}
	public String getAttach_file_name() {
		return attach_file_name;
	}
	public void setAttach_file_name(String attach_file_name) {
		this.attach_file_name = attach_file_name;
	}
	public String getAttach_file_path() {
		return attach_file_path;
	}
	public void setAttach_file_path(String attach_file_path) {
		this.attach_file_path = attach_file_path;
	}
}
