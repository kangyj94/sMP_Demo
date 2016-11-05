package kr.co.bitcube.order.dto;

public class CartMasterInfoDto {

	/* 카드 상품 정보 조회 결과 Dto  */
	private String groupid        ; 
	private String clientid       ; 
	private String branchid       ; 
	private String comp_iden_name ; 
	private String orde_type_clas ; 
	private String tran_deta_addr_seq ; 
	private String tran_user_name ; 
	private String tran_tele_numb ; 
	private String mana_user_name ; 
	private String orde_text_desc ; 
	private String firstattachseq ; 
	private String secondattachseq; 
	private String thirdattachseq ;
	private String firstAttachName;
	private String secondAttachName;
	private String thirdAttachName;
	private String firstAttachPath;
	private String secondAttachPath;
	private String thirdAttachPath;
	private String payBillType;
	private String isOrderApproval;
	private String approvalUserIdArr;
	private String approvalUserNmArr;
	
	public String getPayBillType() {
		return payBillType;
	}

	public void setPayBillType(String payBillType) {
		this.payBillType = payBillType;
	}

	public String getFirstAttachName() {
		return firstAttachName;
	}

	public void setFirstAttachName(String firstAttachName) {
		this.firstAttachName = firstAttachName;
	}

	public String getSecondAttachName() {
		return secondAttachName;
	}

	public void setSecondAttachName(String secondAttachName) {
		this.secondAttachName = secondAttachName;
	}

	public String getThirdAttachName() {
		return thirdAttachName;
	}

	public void setThirdAttachName(String thirdAttachName) {
		this.thirdAttachName = thirdAttachName;
	}

	public String getFirstAttachPath() {
		return firstAttachPath;
	}

	public void setFirstAttachPath(String firstAttachPath) {
		this.firstAttachPath = firstAttachPath;
	}

	public String getSecondAttachPath() {
		return secondAttachPath;
	}

	public void setSecondAttachPath(String secondAttachPath) {
		this.secondAttachPath = secondAttachPath;
	}

	public String getThirdAttachPath() {
		return thirdAttachPath;
	}

	public void setThirdAttachPath(String thirdAttachPath) {
		this.thirdAttachPath = thirdAttachPath;
	}

	public String getGroupid() {
		return groupid;
	}

	public void setGroupid(String groupid) {
		this.groupid = groupid;
	}

	public String getClientid() {
		return clientid;
	}

	public void setClientid(String clientid) {
		this.clientid = clientid;
	}
	public String getBranchid() {
		return branchid;
	}
	public void setBranchid(String branchid) {
		this.branchid = branchid;
	}
	public String getComp_iden_name() {
		return comp_iden_name;
	}
	public void setComp_iden_name(String comp_iden_name) {
		this.comp_iden_name = comp_iden_name;
	}
	public String getOrde_type_clas() {
		return orde_type_clas;
	}
	public void setOrde_type_clas(String orde_type_clas) {
		this.orde_type_clas = orde_type_clas;
	}
	public String getTran_deta_addr_seq() {
		return tran_deta_addr_seq;
	}

	public void setTran_deta_addr_seq(String tran_deta_addr_seq) {
		this.tran_deta_addr_seq = tran_deta_addr_seq;
	}

	public String getTran_user_name() {
		return tran_user_name;
	}

	public void setTran_user_name(String tran_user_name) {
		this.tran_user_name = tran_user_name;
	}

	public String getTran_tele_numb() {
		return tran_tele_numb;
	}

	public void setTran_tele_numb(String tran_tele_numb) {
		this.tran_tele_numb = tran_tele_numb;
	}

	public String getMana_user_name() {
		return mana_user_name;
	}

	public void setMana_user_name(String mana_user_name) {
		this.mana_user_name = mana_user_name;
	}

	public String getOrde_text_desc() {
		return orde_text_desc;
	}

	public void setOrde_text_desc(String orde_text_desc) {
		this.orde_text_desc = orde_text_desc;
	}

	public String getFirstattachseq() {
		return firstattachseq;
	}

	public void setFirstattachseq(String firstattachseq) {
		this.firstattachseq = firstattachseq;
	}

	public String getSecondattachseq() {
		return secondattachseq;
	}

	public void setSecondattachseq(String secondattachseq) {
		this.secondattachseq = secondattachseq;
	}

	public String getThirdattachseq() {
		return thirdattachseq;
	}

	public void setThirdattachseq(String thirdattachseq) {
		this.thirdattachseq = thirdattachseq;
	}

	public String  toString() {
		StringBuffer stBuffer = new StringBuffer();
		stBuffer.append("\n groupid         value ]["+getGroupid());
		stBuffer.append("\n clientid        value ]["+getClientid());
		stBuffer.append("\n branchid        value ]["+getBranchid());
		stBuffer.append("\n comp_iden_name  value ]["+getComp_iden_name());
		stBuffer.append("\n orde_type_clas  value ]["+getOrde_type_clas());
		stBuffer.append("\n tran_deta_addr  value ]["+getTran_deta_addr_seq());
		stBuffer.append("\n tran_user_name  value ]["+getTran_user_name());
		stBuffer.append("\n tran_tele_numb  value ]["+getTran_tele_numb());
		stBuffer.append("\n mana_user_name  value ]["+getMana_user_name());
		stBuffer.append("\n orde_text_desc  value ]["+getOrde_text_desc());
		stBuffer.append("\n firstattachseq  value ]["+getFirstattachseq());
		stBuffer.append("\n secondattachseq value ]["+getSecondattachseq());
		stBuffer.append("\n thirdattachseq  value ]["+getThirdattachseq());
		
		return stBuffer.toString();
	}

	public String getIsOrderApproval() {
		return isOrderApproval;
	}

	public void setIsOrderApproval(String isOrderApproval) {
		this.isOrderApproval = isOrderApproval;
	}

	public String getApprovalUserIdArr() {
		return approvalUserIdArr;
	}

	public void setApprovalUserIdArr(String approvalUserIdArr) {
		this.approvalUserIdArr = approvalUserIdArr;
	}

	public String getApprovalUserNmArr() {
		return approvalUserNmArr;
	}

	public void setApprovalUserNmArr(String approvalUserNmArr) {
		this.approvalUserNmArr = approvalUserNmArr;
	}
	
}
