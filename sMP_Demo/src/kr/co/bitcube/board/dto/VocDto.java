package kr.co.bitcube.board.dto;

public class VocDto {
	
	String voc_no;				// 고객의 소리 seq
	String rece_type;			// 접수유형
	String rece_type_nm;		// 접수유형명
	String email;				// 이메일주소
	String vocMailSend;			// 고객의 소리 받는 사람 이메일
	String tel;					// 연락처
	String title;				// 제목
	String message;				// 내용
	String regi_user_id;		// 등록자 id
	String usernm;				// 등록자명
	String borg_string;			// 업체명
	String regi_date_time;		// 등록일시
	
	// 첨부파일 관련 
	String file_list1;			
	String file_list2;
	String file_list3;
	String file_list4;
	String attach_file_name1;
	String attach_file_name2;
	String attach_file_name3;
	String attach_file_name4;
	String attach_file_path1;
	String attach_file_path2;
	String attach_file_path3;
	String attach_file_path4;
	String file_list_cnt;
	
	
	
	
	public String getUsernm() {
		return usernm;
	}
	public void setUsernm(String usernm) {
		this.usernm = usernm;
	}
	public String getBorg_string() {
		return borg_string;
	}
	public void setBorg_string(String borg_string) {
		this.borg_string = borg_string;
	}
	public String getFile_list_cnt() {
		return file_list_cnt;
	}
	public void setFile_list_cnt(String file_list_cnt) {
		this.file_list_cnt = file_list_cnt;
	}
	public String getVoc_no() {
		return voc_no;
	}
	public void setVoc_no(String voc_no) {
		this.voc_no = voc_no;
	}
	public String getRece_type() {
		return rece_type;
	}
	public void setRece_type(String rece_type) {
		this.rece_type = rece_type;
	}
	public String getRece_type_nm() {
		return rece_type_nm;
	}
	public void setRece_type_nm(String rece_type_nm) {
		this.rece_type_nm = rece_type_nm;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getFile_list1() {
		return file_list1;
	}
	public void setFile_list1(String file_list1) {
		this.file_list1 = file_list1;
	}
	public String getFile_list2() {
		return file_list2;
	}
	public void setFile_list2(String file_list2) {
		this.file_list2 = file_list2;
	}
	public String getFile_list3() {
		return file_list3;
	}
	public void setFile_list3(String file_list3) {
		this.file_list3 = file_list3;
	}
	public String getFile_list4() {
		return file_list4;
	}
	public void setFile_list4(String file_list4) {
		this.file_list4 = file_list4;
	}
	public String getAttach_file_name1() {
		return attach_file_name1;
	}
	public void setAttach_file_name1(String attach_file_name1) {
		this.attach_file_name1 = attach_file_name1;
	}
	public String getAttach_file_name2() {
		return attach_file_name2;
	}
	public void setAttach_file_name2(String attach_file_name2) {
		this.attach_file_name2 = attach_file_name2;
	}
	public String getAttach_file_name3() {
		return attach_file_name3;
	}
	public void setAttach_file_name3(String attach_file_name3) {
		this.attach_file_name3 = attach_file_name3;
	}
	public String getAttach_file_name4() {
		return attach_file_name4;
	}
	public void setAttach_file_name4(String attach_file_name4) {
		this.attach_file_name4 = attach_file_name4;
	}
	public String getAttach_file_path1() {
		return attach_file_path1;
	}
	public void setAttach_file_path1(String attach_file_path1) {
		this.attach_file_path1 = attach_file_path1;
	}
	public String getAttach_file_path2() {
		return attach_file_path2;
	}
	public void setAttach_file_path2(String attach_file_path2) {
		this.attach_file_path2 = attach_file_path2;
	}
	public String getAttach_file_path3() {
		return attach_file_path3;
	}
	public void setAttach_file_path3(String attach_file_path3) {
		this.attach_file_path3 = attach_file_path3;
	}
	public String getAttach_file_path4() {
		return attach_file_path4;
	}
	public void setAttach_file_path4(String attach_file_path4) {
		this.attach_file_path4 = attach_file_path4;
	}
	public String getRegi_user_id() {
		return regi_user_id;
	}
	public void setRegi_user_id(String regi_user_id) {
		this.regi_user_id = regi_user_id;
	}
	public String getRegi_date_time() {
		return regi_date_time;
	}
	public void setRegi_date_time(String regi_date_time) {
		this.regi_date_time = regi_date_time;
	}
	public String getVocMailSend() {
		return vocMailSend;
	}
	public void setVocMailSend(String vocMailSend) {
		this.vocMailSend = vocMailSend;
	}
	
	
}