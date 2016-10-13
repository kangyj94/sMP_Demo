package kr.co.bitcube.mig.dto; 

public class NewCateDto {
	
	// 표준카테고리
	private String cate_Id;
	private String majo_Code_Name;
	private String majo_Code_Name1;
	private String majo_Code_Name2;
	private String majo_Code_Name3;
	private String cate_Cd;
	private String mojo_Code_Desc;
	private String ref_Cate_Seq;
	private String cate_Level;
	private String ord_Num;
	private String ins_User_Id;
	private String ins_Date;
	private String upd_User_Id;
	private String upd_Date;
	private String remoteIp;
	private String isLeaf;
	private String lev;
	private String full_Cate_Name;
	private String product_Count; 
	
	// 진열마스터
	private String cate_Disp_Id;
	private String cate_Disp_Name;
	private String cate_Disp_Desc;
	private String is_Disp_Use;
	private String insert_User_Id;
	private String insert_Date;
	private String update_User_Id;
	private String update_Date;
	private String remote_Ip;
	
	//카테고리진열조직
	private String groupId;
	private String clientId;
	private String branchId;
	
	//조직마스터
	private String borgId;
	private String borgCd;
	private String borgTypeNm;
	private String borgNms;
	private String borgNm;
	
	
	public String getCate_Id() {
		return cate_Id;
	}
	public void setCate_Id(String cate_Id) {
		this.cate_Id = cate_Id;
	}
	public String getMajo_Code_Name() {
		return majo_Code_Name;
	}
	public void setMajo_Code_Name(String majo_Code_Name) {
		this.majo_Code_Name = majo_Code_Name;
	}
	public String getMajo_Code_Name1() {
		return majo_Code_Name1;
	}
	public void setMajo_Code_Name1(String majo_Code_Name1) {
		this.majo_Code_Name1 = majo_Code_Name1;
	}
	public String getMajo_Code_Name2() {
		return majo_Code_Name2;
	}
	public void setMajo_Code_Name2(String majo_Code_Name2) {
		this.majo_Code_Name2 = majo_Code_Name2;
	}
	public String getMajo_Code_Name3() {
		return majo_Code_Name3;
	}
	public void setMajo_Code_Name3(String majo_Code_Name3) {
		this.majo_Code_Name3 = majo_Code_Name3;
	}
	public String getCate_Cd() {
		return cate_Cd;
	}
	public void setCate_Cd(String cate_Cd) {
		this.cate_Cd = cate_Cd;
	}
	public String getMojo_Code_Desc() {
		return mojo_Code_Desc;
	}
	public void setMojo_Code_Desc(String mojo_Code_Desc) {
		this.mojo_Code_Desc = mojo_Code_Desc;
	}
	public String getRef_Cate_Seq() {
		return ref_Cate_Seq;
	}
	public void setRef_Cate_Seq(String ref_Cate_Seq) {
		this.ref_Cate_Seq = ref_Cate_Seq;
	}
	public String getCate_Level() {
		return cate_Level;
	}
	public void setCate_Level(String cate_Level) {
		this.cate_Level = cate_Level;
	}
	public String getOrd_Num() {
		return ord_Num;
	}
	public void setOrd_Num(String ord_Num) {
		this.ord_Num = ord_Num;
	}
	public String getIns_User_Id() {
		return ins_User_Id;
	}
	public void setIns_User_Id(String ins_User_Id) {
		this.ins_User_Id = ins_User_Id;
	}
	public String getIns_Date() {
		return ins_Date;
	}
	public void setIns_Date(String ins_Date) {
		this.ins_Date = ins_Date;
	}
	public String getUpd_User_Id() {
		return upd_User_Id;
	}
	public void setUpd_User_Id(String upd_User_Id) {
		this.upd_User_Id = upd_User_Id;
	}
	public String getUpd_Date() {
		return upd_Date;
	}
	public void setUpd_Date(String upd_Date) {
		this.upd_Date = upd_Date;
	}
	public String getRemoteIp() {
		return remoteIp;
	}
	public void setRemoteIp(String remoteIp) {
		this.remoteIp = remoteIp;
	}
	public String getIsLeaf() {
		return isLeaf;
	}
	public void setIsLeaf(String isLeaf) {
		this.isLeaf = isLeaf;
	}
	public String getProduct_Count() {
		return product_Count;
	}
	public void setProduct_Count(String product_Count) {
		this.product_Count = product_Count;
	}
	public String getLev() {
		return lev;
	}
	public void setLev(String lev) {
		this.lev = lev;
	}
	public String getFull_Cate_Name() {
		return full_Cate_Name;
	}
	public void setFull_Cate_Name(String full_Cate_Name) {
		this.full_Cate_Name = full_Cate_Name;
	}
	public String getCate_Disp_Id() {
		return cate_Disp_Id;
	}
	public void setCate_Disp_Id(String cate_Disp_Id) {
		this.cate_Disp_Id = cate_Disp_Id;
	}
	public String getCate_Disp_Name() {
		return cate_Disp_Name;
	}
	public void setCate_Disp_Name(String cate_Disp_Name) {
		this.cate_Disp_Name = cate_Disp_Name;
	}
	public String getCate_Disp_Desc() {
		return cate_Disp_Desc;
	}
	public void setCate_Disp_Desc(String cate_Disp_Desc) {
		this.cate_Disp_Desc = cate_Disp_Desc;
	}
	public String getIs_Disp_Use() {
		return is_Disp_Use;
	}
	public void setIs_Disp_Use(String is_Disp_Use) {
		this.is_Disp_Use = is_Disp_Use;
	}
	public String getInsert_User_Id() {
		return insert_User_Id;
	}
	public void setInsert_User_Id(String insert_User_Id) {
		this.insert_User_Id = insert_User_Id;
	}
	public String getInsert_Date() {
		return insert_Date;
	}
	public void setInsert_Date(String insert_Date) {
		this.insert_Date = insert_Date;
	}
	public String getUpdate_User_Id() {
		return update_User_Id;
	}
	public void setUpdate_User_Id(String update_User_Id) {
		this.update_User_Id = update_User_Id;
	}
	public String getUpdate_Date() {
		return update_Date;
	}
	public void setUpdate_Date(String update_Date) {
		this.update_Date = update_Date;
	}
	public String getRemote_Ip() {
		return remote_Ip;
	}
	public void setRemote_Ip(String remote_Ip) {
		this.remote_Ip = remote_Ip;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getClientId() {
		return clientId;
	}
	public void setClientId(String clientId) {
		this.clientId = clientId;
	}
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	public String getBorgId() {
		return borgId;
	}
	public void setBorgId(String borgId) {
		this.borgId = borgId;
	}
	public String getBorgCd() {
		return borgCd;
	}
	public void setBorgCd(String borgCd) {
		this.borgCd = borgCd;
	}
	public String getBorgTypeNm() {
		return borgTypeNm;
	}
	public void setBorgTypeNm(String borgTypeNm) {
		this.borgTypeNm = borgTypeNm;
	}
	public String getBorgNms() {
		return borgNms;
	}
	public void setBorgNms(String borgNms) {
		this.borgNms = borgNms;
	}
	public String getBorgNm() {
		return borgNm;
	}
	public void setBorgNm(String borgNm) {
		this.borgNm = borgNm;
	}
	
}
