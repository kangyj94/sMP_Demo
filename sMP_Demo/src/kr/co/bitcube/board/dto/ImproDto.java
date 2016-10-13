package kr.co.bitcube.board.dto;

public class ImproDto {

	private String no; 					//일련번호
	private String borgId;				//회원사코드
	private String title;				//제목
	private String message;				//내용
	private String requ_User_Numb;		//요청자
	private String requ_User_Date;		//요청일
	private String modi_User_Numb;		//답변자
	private String hand_User_Numb;		//접수자
	private String modi_User_Date;		//답변일
	private String file_List1;			//요청첨부파일1
	private String file_List2;			//요청첨부파일2
	private String file_List3;			//요청첨부파일3
	private String file_List4;			//요청첨부파일4
	
	private String req_Message;			//답변내용	
	private String hand_Message;		//접수처리내용
	private String stat_Flag_Code;		//처리상태
	private String first;		//우선순위
		
	private String hand_File_names1;	//접수자첨부파일1
	private String hand_File_names2;	//접수자첨부파일2
	private String hand_File_names3;	//접수자첨부파일3
	private String hand_File_names4;	//접수자첨부파일4 
	
	private String hand_attach_file_path1;	//접수자첨부파일
	private String hand_attach_file_path2;
	private String hand_attach_file_path3;
	private String hand_attach_file_path4;
		
	private String attach_file_name1;	//요청첨부파일
	private String attach_file_name2;
	private String attach_file_name3;
	private String attach_file_name4;
	
	private String attach_file_path1;
	private String attach_file_path2;
	private String attach_file_path3;
	private String attach_file_path4;
	
	private String modi_file_names1;	//요청첨부파일
	private String modi_file_names2;
	private String modi_file_names3;
	private String modi_file_names4;
	
	private String modi_file_path1;
	private String modi_file_path2;
	private String modi_file_path3;
	private String modi_file_path4;
	
	
	public String getModi_file_names1() {
		return modi_file_names1;
	}
	public void setModi_file_names1(String modi_file_names1) {
		this.modi_file_names1 = modi_file_names1;
	}
	public String getModi_file_names2() {
		return modi_file_names2;
	}
	public void setModi_file_names2(String modi_file_names2) {
		this.modi_file_names2 = modi_file_names2;
	}
	public String getModi_file_names3() {
		return modi_file_names3;
	}
	public void setModi_file_names3(String modi_file_names3) {
		this.modi_file_names3 = modi_file_names3;
	}
	public String getModi_file_names4() {
		return modi_file_names4;
	}
	public void setModi_file_names4(String modi_file_names4) {
		this.modi_file_names4 = modi_file_names4;
	}
	public String getModi_file_path1() {
		return modi_file_path1;
	}
	public void setModi_file_path1(String modi_file_path1) {
		this.modi_file_path1 = modi_file_path1;
	}
	public String getModi_file_path2() {
		return modi_file_path2;
	}
	public void setModi_file_path2(String modi_file_path2) {
		this.modi_file_path2 = modi_file_path2;
	}
	public String getModi_file_path3() {
		return modi_file_path3;
	}
	public void setModi_file_path3(String modi_file_path3) {
		this.modi_file_path3 = modi_file_path3;
	}
	public String getModi_file_path4() {
		return modi_file_path4;
	}
	public void setModi_file_path4(String modi_file_path4) {
		this.modi_file_path4 = modi_file_path4;
	}

	private String file_list_cnt;
	
	private String num;
	
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getHand_attach_file_path1() {
		return hand_attach_file_path1;
	}
	public void setHand_attach_file_path1(String hand_attach_file_path1) {
		this.hand_attach_file_path1 = hand_attach_file_path1;
	}
	public String getHand_attach_file_path2() {
		return hand_attach_file_path2;
	}
	public void setHand_attach_file_path2(String hand_attach_file_path2) {
		this.hand_attach_file_path2 = hand_attach_file_path2;
	}
	public String getHand_attach_file_path3() {
		return hand_attach_file_path3;
	}
	public void setHand_attach_file_path3(String hand_attach_file_path3) {
		this.hand_attach_file_path3 = hand_attach_file_path3;
	}
	public String getHand_attach_file_path4() {
		return hand_attach_file_path4;
	}
	public void setHand_attach_file_path4(String hand_attach_file_path4) {
		this.hand_attach_file_path4 = hand_attach_file_path4;
	}
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}
//	public String getDeli_Area_Code() {
//		return deli_Area_Code;
//	}
//	public void setDeli_Area_Code(String deli_Area_Code) {
//		this.deli_Area_Code = deli_Area_Code;
//	}
	public String getBorgId() {
		return borgId;
	}
	public void setBorgId(String borgId) {
		this.borgId = borgId;
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
//	public String getRequ_Stat_Flag() {
//		return requ_Stat_Flag;
//	}
//	public void setRequ_Stat_Flag(String requ_Stat_Flag) {
//		this.requ_Stat_Flag = requ_Stat_Flag;
//	}
	public String getRequ_User_Numb() {
		return requ_User_Numb;
	}
	public void setRequ_User_Numb(String requ_User_Numb) {
		this.requ_User_Numb = requ_User_Numb;
	}
	public String getHand_User_Numb() {
		return hand_User_Numb;
	}
	public void setHand_User_Numb(String hand_User_Numb) {
		this.hand_User_Numb = hand_User_Numb;
	}
	public String getRequ_User_Date() {
		return requ_User_Date;
	}
	public void setRequ_User_Date(String requ_User_Date) {
		this.requ_User_Date = requ_User_Date;
	}
	public String getModi_User_Numb() {
		return modi_User_Numb;
	}
	public void setModi_User_Numb(String modi_User_Numb) {
		this.modi_User_Numb = modi_User_Numb;
	}
	public String getModi_User_Date() {
		return modi_User_Date;
	}
	public void setModi_User_Date(String modi_User_Date) {
		this.modi_User_Date = modi_User_Date;
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
	public String getReq_Message() {
		return req_Message;
	}
	public void setReq_Message(String req_Message) {
		this.req_Message = req_Message;
	}
	public String getHand_Message() {
		return hand_Message;
	}
	public void setHand_Message(String hand_Message) {
		this.hand_Message = hand_Message;
	}
	public String getStat_Flag_Code() {
		return stat_Flag_Code;
	}
	public void setStat_Flag_Code(String stat_Flag_Code) {
		this.stat_Flag_Code = stat_Flag_Code;
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
	public String getFile_list_cnt() {
		return file_list_cnt;
	}
	public void setFile_list_cnt(String file_list_cnt) {
		this.file_list_cnt = file_list_cnt;
	}
	public String getHand_File_names1() {
		return hand_File_names1;
	}
	public void setHand_File_names1(String hand_File_names1) {
		this.hand_File_names1 = hand_File_names1;
	}
	public String getHand_File_names2() {
		return hand_File_names2;
	}
	public void setHand_File_names2(String hand_File_names2) {
		this.hand_File_names2 = hand_File_names2;
	}
	public String getHand_File_names3() {
		return hand_File_names3;
	}
	public void setHand_File_names3(String hand_File_names3) {
		this.hand_File_names3 = hand_File_names3;
	}
	public String getHand_File_names4() {
		return hand_File_names4;
	}
	public void setHand_File_name4(String hand_File_names4) {
		this.hand_File_names4 = hand_File_names4;
	}
	public void setHand_File_names4(String hand_File_names4) {
		this.hand_File_names4 = hand_File_names4;
	}
	public String getFirst() {
		return first;
	}
	public void setFirst(String first) {
		this.first = first;
	}
}
