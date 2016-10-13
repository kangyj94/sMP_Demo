package kr.co.bitcube.board.dto;

public class BoardDto {

	private String board_No;		//일련번호
	private String board_Type;		//게시유형
	private String title;			//제목
	private String message;			//내용
	private String file_List1;		//파일첨부1
	private String file_List2;		//파일첨부2
	private String file_List3;		//파일첨부3
	private String file_List4;		//파일첨부4
	private String hit_No;			//조회수
	private String regi_User_Numb;	//작성자
	private String regi_Date_Time;	//작성일시
	private String modi_User_Numb;	//수정자
	private String modi_Date_time;	//수정일시
	private String regi_BorgId;		//등록자조직일련번호
	private String group_No;		//최상위일련번호
	private String parent_Board_No;	//상위일련번호
	private String password;		//비밀번호
	private String board_Borg_Type;	//게시조직구분
	private String popup_Start;		//팝업시작일
	private String popup_End; 		//팝업종료일
	private String req_Sale_Amout;	//판매가격
	private String tran_Vehi_Proc;	//배송방법
	private String user_Mail_Addr;	//이메일
	private String user_Phon_Numb;	//전화번호
	private String email_Yn;		//email여부
	private String sms_Yn;			//sms여부
	private String Lev;
	private String order;
	
	private String attach_file_name1;
	private String attach_file_name2;
	private String attach_file_name3;
	private String attach_file_name4;
	private String attach_file_path1;
	private String attach_file_path2;
	private String attach_file_path3;
	private String attach_file_path4;
	
	private String file_list_cnt;
	
	private String num;//로우넘버
	
	private String workInfo;//공사유형아이디
	private String classify;//규격서/절차서 구분
	private String standard;//규격서/절차서 규격
	private String importantYn; // 중요 공지사항 여부
	private String emergencyYn; // 긴급 공지사항 여부
	private String isNew;
	
	private String borg_type_name;//공지대상
	private String popup_period;//팝업공지기간 
	
	
	public String getIsNew() {
		return isNew;
	}
	public void setIsNew(String isNew) {
		this.isNew = isNew;
	}
	public String getImportantYn() {
		return importantYn;
	}
	public void setImportantYn(String importantYn) {
		this.importantYn = importantYn;
	}
	public String getEmergencyYn() {
		return emergencyYn;
	}
	public void setEmergencyYn(String emergencyYn) {
		this.emergencyYn = emergencyYn;
	}
	public String getClassify() {
		return classify;
	}
	public void setClassify(String classify) {
		this.classify = classify;
	}
	public String getStandard() {
		return standard;
	}
	public void setStandard(String standard) {
		this.standard = standard;
	}
	public String getWorkInfo() {
		return workInfo;
	}
	public void setWorkInfo(String workInfo) {
		this.workInfo = workInfo;
	}
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getFile_list_cnt() {
		return file_list_cnt;
	}
	public void setFile_list_cnt(String file_list_cnt) {
		this.file_list_cnt = file_list_cnt;
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
	public String getBoard_No() {
		return board_No;
	}
	public void setBoard_No(String board_No) {
		this.board_No = board_No;
	}
	public String getBoard_Type() {
		return board_Type;
	}
	public void setBoard_Type(String board_Type) {
		this.board_Type = board_Type;
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
	public String getFile_List1() {
		return file_List1;
	}
	public void setFile_List1(String file_List1) {
		this.file_List1 = file_List1;
	}
	public String getFile_List2() {
		return file_List2;
	}
	public void setFile_List2(String file_List2) {
		this.file_List2 = file_List2;
	}
	public String getFile_List3() {
		return file_List3;
	}
	public void setFile_List3(String file_List3) {
		this.file_List3 = file_List3;
	}
	public String getFile_List4() {
		return file_List4;
	}
	public void setFile_List4(String file_List4) {
		this.file_List4 = file_List4;
	}
	public String getHit_No() {
		return hit_No;
	}
	public void setHit_No(String hit_No) {
		this.hit_No = hit_No;
	}
	public String getRegi_User_Numb() {
		return regi_User_Numb;
	}
	public void setRegi_User_Numb(String regi_User_Numb) {
		this.regi_User_Numb = regi_User_Numb;
	}
	public String getRegi_Date_Time() {
		return regi_Date_Time;
	}
	public void setRegi_Date_Time(String regi_Date_Time) {
		this.regi_Date_Time = regi_Date_Time;
	}
	public String getModi_User_Numb() {
		return modi_User_Numb;
	}
	public void setModi_User_Numb(String modi_User_Numb) {
		this.modi_User_Numb = modi_User_Numb;
	}
	public String getModi_Date_time() {
		return modi_Date_time;
	}
	public void setModi_Date_time(String modi_Date_time) {
		this.modi_Date_time = modi_Date_time;
	}
	public String getRegi_BorgId() {
		return regi_BorgId;
	}
	public void setRegi_BorgId(String regi_BorgId) {
		this.regi_BorgId = regi_BorgId;
	}
	public String getGroup_No() {
		return group_No;
	}
	public void setGroup_No(String group_No) {
		this.group_No = group_No;
	}
	public String getParent_Board_No() {
		return parent_Board_No;
	}
	public void setParent_Board_No(String parent_Board_No) {
		this.parent_Board_No = parent_Board_No;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getBoard_Borg_Type() {
		return board_Borg_Type;
	}
	public void setBoard_Borg_Type(String board_Borg_Type) {
		this.board_Borg_Type = board_Borg_Type;
	}
	public String getPopup_Start() {
		return popup_Start;
	}
	public void setPopup_Start(String popup_Start) {
		this.popup_Start = popup_Start;
	}
	public String getPopup_End() {
		return popup_End;
	}
	public void setPopup_End(String popup_End) {
		this.popup_End = popup_End;
	}
	public String getReq_Sale_Amout() {
		return req_Sale_Amout;
	}
	public void setReq_Sale_Amout(String req_Sale_Amout) {
		this.req_Sale_Amout = req_Sale_Amout;
	}
	public String getTran_Vehi_Proc() {
		return tran_Vehi_Proc;
	}
	public void setTran_Vehi_Proc(String tran_Vehi_Proc) {
		this.tran_Vehi_Proc = tran_Vehi_Proc;
	}
	public String getUser_Mail_Addr() {
		return user_Mail_Addr;
	}
	public void setUser_Mail_Addr(String user_Mail_Addr) {
		this.user_Mail_Addr = user_Mail_Addr;
	}
	public String getUser_Phon_Numb() {
		return user_Phon_Numb;
	}
	public void setUser_Phon_Numb(String user_Phon_Numb) {
		this.user_Phon_Numb = user_Phon_Numb;
	}
	public String getEmail_Yn() {
		return email_Yn;
	}
	public void setEmail_Yn(String email_Yn) {
		this.email_Yn = email_Yn;
	}
	public String getSms_Yn() {
		return sms_Yn;
	}
	public void setSms_Yn(String sms_Yn) {
		this.sms_Yn = sms_Yn;
	}
	public String getLev() {
		return Lev;
	}
	public void setLev(String lev) {
		Lev = lev;
	}
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	public String getBorg_type_name() {
		return borg_type_name;
	}
	public void setBorg_type_name(String borg_type_name) {
		this.borg_type_name = borg_type_name;
	}
	public String getPopup_period() {
		return popup_period;
	}
	public void setPopup_period(String popup_period) {
		this.popup_period = popup_period;
	}
}
