package kr.co.bitcube.order.dto;

/**
 * 발주 정보 관련 Dto 
 */
public class OrderPurtDto {
	
	/** 주문번호 */
	private String orde_iden_numb;
	/** 주문차수 */
	private String orde_seq_numb;
	/** 발주차수 */
	private String purc_iden_numb;
	/** 진열 SEQ */
	private String disp_good_id;
	/** 상품코드 */
	private String good_iden_seq;
	/** 공급사 ID */
	private String vendorid;
	/** 판매단가 */
	private double orde_requ_pric;
	/** 총 판매단가 */
	private double total_orde_requ_pric;
	/** 매입단가 */
	private double sale_unit_pric;
	/** 총 매입단가 */
	private double total_sale_unit_pric;
	/** 발주상태 */
	private String purc_stat_flag;
	/** 발주수량 */
	private double purc_requ_quan;
	/** 출하수량 */
	private double deli_prod_quan;
	/** 발주의뢰자ID */
	private String clin_user_id;
	/** 발주의뢰일자 */
	private String clin_date;
	/** 발주접수자 ID */
	private String purc_rece_id;
	/** 발주접수일자 */
	private String purc_rece_date;
	
	/**  상품 코드 */
	private String good_iden_numb;
	
	/* * 주문 상세에서 추가로 필요로 하는 컬럼 */
	/** 주문 요청 수량 */
	private String orde_requ_quan;
	/** 공급사명 */
	private String vendorname;
	/** 발주 월 금액*/
	private String purc_price_month_str;
	/** 발주 년 금액 */
	private String purc_price_year_str;
	/** 발주 년 금액 (% 빠진것)*/
	private String purc_year_price;
	/** 주문요청 한글명 */
	private String purc_stat_flag_name;
	
	/* * 발주접수 리스트에서 추가로 필요로 하는 칼럼 */
	private String orde_type_clas; 	// 주문유형
	private String good_name;		// 상품명
	private String good_spec_desc;  // 상품규격
	private String requ_deli_date;		// 납품요청일
	private String tran_data_addr;	// 배송지 주소
	private String orde_client_name; // 고객사
	private String orde_user_name;  // 주문자
	private String tran_user_name;   // 인수자
	private String tran_tele_numb;   // 인수자 전화번호
	private String attach_cnt;			// 첨부파일 갯수
	private String vendornm;			// 공급사 명
	private double good_inventory_cnt;	// 공급사 명
	private String orde_type_clas_code; // 주문유형 코드 
	
	private String attach_file_1;		
	private String attach_file_2;		
	private String attach_file_3;		
	private String attach_file_name1;		
	private String attach_file_name2;		
	private String attach_file_name3;		
	private String attach_file_path1;		
	private String attach_file_path2;		
	private String attach_file_path3;		
	private String regi_date_time;		
	private String good_st_spec_desc;		
	
	private String adde_text_desc;		
	
	private String worknm;
	private String deli_iden_numb;
	private String rece_iden_numb;
	private String buyi_sequ_numb;
	private String cons_iden_name;
	private String stat_falg;
	private String branchnm;
	private String orde_user_id;
	private String tot_orde_requ_pric;
	private String tot_sale_unit_pric;
	private String cancel_reason;
	
	private String rece_regi_date;
	
	private String clos_buyi_date;
	
	private String phoneNum;
	
	private String vendorPhonenum; //공급사대표 번호
	private String orderUserMobile; //주문자 전화번호
	private String deli_sche_date; //납품예정일
	
	private String invoiceDate;//배송정보입력일
	
	private String branchId;//구매사ID
	
	private String sum_orde_requ_quan;
	private String sum_total_sale_unit_pric;
	
	
	

	
	public String getSum_orde_requ_quan() {
		return sum_orde_requ_quan;
	}
	public void setSum_orde_requ_quan(String sum_orde_requ_quan) {
		this.sum_orde_requ_quan = sum_orde_requ_quan;
	}
	public String getSum_total_sale_unit_pric() {
		return sum_total_sale_unit_pric;
	}
	public void setSum_total_sale_unit_pric(String sum_total_sale_unit_pric) {
		this.sum_total_sale_unit_pric = sum_total_sale_unit_pric;
	}


	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	public String getInvoiceDate() {
		return invoiceDate;
	}
	public void setInvoiceDate(String invoiceDate) {
		this.invoiceDate = invoiceDate;
	}
	public String getDeli_sche_date() {
		return deli_sche_date;
	}
	public void setDeli_sche_date(String deli_sche_date) {
		this.deli_sche_date = deli_sche_date;
	}
	public String getOrderUserMobile() {
		return orderUserMobile;
	}
	public void setOrderUserMobile(String orderUserMobile) {
		this.orderUserMobile = orderUserMobile;
	}
	public String getVendorPhonenum() {
		return vendorPhonenum;
	}
	public void setVendorPhonenum(String vendorPhonenum) {
		this.vendorPhonenum = vendorPhonenum;
	}
	public String getPhoneNum() {
		return phoneNum;
	}
	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}
	public String getClos_buyi_date() {
		return clos_buyi_date;
	}
	public void setClos_buyi_date(String clos_buyi_date) {
		this.clos_buyi_date = clos_buyi_date;
	}
	public String getRece_regi_date() {
		return rece_regi_date;
	}
	public void setRece_regi_date(String rece_regi_date) {
		this.rece_regi_date = rece_regi_date;
	}
	public String getWorknm() {
		return worknm;
	}
	public void setWorknm(String worknm) {
		this.worknm = worknm;
	}
	public String getDeli_iden_numb() {
		return deli_iden_numb;
	}
	public void setDeli_iden_numb(String deli_iden_numb) {
		this.deli_iden_numb = deli_iden_numb;
	}
	public String getRece_iden_numb() {
		return rece_iden_numb;
	}
	public void setRece_iden_numb(String rece_iden_numb) {
		this.rece_iden_numb = rece_iden_numb;
	}
	public String getBuyi_sequ_numb() {
		return buyi_sequ_numb;
	}
	public void setBuyi_sequ_numb(String buyi_sequ_numb) {
		this.buyi_sequ_numb = buyi_sequ_numb;
	}
	public String getCons_iden_name() {
		return cons_iden_name;
	}
	public void setCons_iden_name(String cons_iden_name) {
		this.cons_iden_name = cons_iden_name;
	}
	public String getStat_falg() {
		return stat_falg;
	}
	public void setStat_falg(String stat_falg) {
		this.stat_falg = stat_falg;
	}
	public String getBranchnm() {
		return branchnm;
	}
	public void setBranchnm(String branchnm) {
		this.branchnm = branchnm;
	}
	public String getOrde_user_id() {
		return orde_user_id;
	}
	public void setOrde_user_id(String orde_user_id) {
		this.orde_user_id = orde_user_id;
	}
	public String getTot_orde_requ_pric() {
		return tot_orde_requ_pric;
	}
	public void setTot_orde_requ_pric(String tot_orde_requ_pric) {
		this.tot_orde_requ_pric = tot_orde_requ_pric;
	}
	public String getTot_sale_unit_pric() {
		return tot_sale_unit_pric;
	}
	public void setTot_sale_unit_pric(String tot_sale_unit_pric) {
		this.tot_sale_unit_pric = tot_sale_unit_pric;
	}
	public String getCancel_reason() {
		return cancel_reason;
	}
	public void setCancel_reason(String cancel_reason) {
		this.cancel_reason = cancel_reason;
	}
	public String getAttach_file_1() {
		return attach_file_1;
	}
	public void setAttach_file_1(String attach_file_1) {
		this.attach_file_1 = attach_file_1;
	}
	public String getAttach_file_2() {
		return attach_file_2;
	}
	public void setAttach_file_2(String attach_file_2) {
		this.attach_file_2 = attach_file_2;
	}
	public String getAttach_file_3() {
		return attach_file_3;
	}
	public void setAttach_file_3(String attach_file_3) {
		this.attach_file_3 = attach_file_3;
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
	public double getGood_inventory_cnt() {
		return good_inventory_cnt;
	}
	public void setGood_inventory_cnt(double good_inventory_cnt) {
		this.good_inventory_cnt = good_inventory_cnt;
	}
	public String getOrde_type_clas() {
		return orde_type_clas;
	}
	public void setOrde_type_clas(String orde_type_clas) {
		this.orde_type_clas = orde_type_clas;
	}
	public String getGood_name() {
		return good_name;
	}
	public void setGood_name(String good_name) {
		this.good_name = good_name;
	}
	public String getGood_spec_desc() {
		return good_spec_desc;
	}
	public void setGood_spec_desc(String good_spec_desc) {
		this.good_spec_desc = good_spec_desc;
	}
	public String getRequ_deli_date() {
		return requ_deli_date;
	}
	public void setRequ_deli_date(String requ_deli_date) {
		this.requ_deli_date = requ_deli_date;
	}
	public String getTran_data_addr() {
		return tran_data_addr;
	}
	public void setTran_data_addr(String tran_data_addr) {
		this.tran_data_addr = tran_data_addr;
	}
	public String getOrde_client_name() {
		return orde_client_name;
	}
	public void setOrde_client_name(String orde_client_name) {
		this.orde_client_name = orde_client_name;
	}
	public String getOrde_user_name() {
		return orde_user_name;
	}
	public void setOrde_user_name(String orde_user_name) {
		this.orde_user_name = orde_user_name;
	}
	public String getTran_user_name() {
		return tran_user_name;
	}
	public void setTran_user_name(String tran_user_name) {
		this.tran_user_name = tran_user_name;
	}
	public String getAttach_cnt() {
		return attach_cnt;
	}
	public void setAttach_cnt(String attach_cnt) {
		this.attach_cnt = attach_cnt;
	}
	public String getVendornm() {
		return vendornm;
	}
	public void setVendornm(String vendornm) {
		this.vendornm = vendornm;
	}
	public String getPurc_stat_flag_name() {
		return purc_stat_flag_name;
	}
	public void setPurc_stat_flag_name(String purc_stat_flag_name) {
		this.purc_stat_flag_name = purc_stat_flag_name;
	}
	public String getPurc_year_price() {
		return purc_year_price;
	}
	public void setPurc_year_price(String purc_year_price) {
		this.purc_year_price = purc_year_price;
	}
	public String getPurc_price_month_str() {
		return purc_price_month_str;
	}
	public void setPurc_price_month_str(String purc_price_month_str) {
		this.purc_price_month_str = purc_price_month_str;
	}
	public String getPurc_price_year_str() {
		return purc_price_year_str;
	}
	public void setPurc_price_year_str(String purc_price_year_str) {
		this.purc_price_year_str = purc_price_year_str;
	}
	public String getOrde_requ_quan() {
		return orde_requ_quan;
	}
	public void setOrde_requ_quan(String orde_requ_quan) {
		this.orde_requ_quan = orde_requ_quan;
	}
	public String getVendorname() {
		return vendorname;
	}
	public void setVendorname(String vendorname) {
		this.vendorname = vendorname;
	}
	public double getTotal_orde_requ_pric() {
		return total_orde_requ_pric;
	}
	public void setTotal_orde_requ_pric(double total_orde_requ_pric) {
		this.total_orde_requ_pric = total_orde_requ_pric;
	}
	public double getTotal_sale_unit_pric() {
		return total_sale_unit_pric;
	}
	public void setTotal_sale_unit_pric(double total_sale_unit_pric) {
		this.total_sale_unit_pric = total_sale_unit_pric;
	}
	public String getOrde_iden_numb() {
		return orde_iden_numb;
	}
	public void setOrde_iden_numb(String orde_iden_numb) {
		this.orde_iden_numb = orde_iden_numb;
	}
	public String getOrde_seq_numb() {
		return orde_seq_numb;
	}
	public void setOrde_seq_numb(String orde_seq_numb) {
		this.orde_seq_numb = orde_seq_numb;
	}
	public String getPurc_iden_numb() {
		return purc_iden_numb;
	}
	public void setPurc_iden_numb(String purc_iden_numb) {
		this.purc_iden_numb = purc_iden_numb;
	}
	
	public String getDisp_good_id() {
		return disp_good_id;
	}
	public void setDisp_good_id(String disp_good_id) {
		this.disp_good_id = disp_good_id;
	}
	public String getGood_iden_seq() {
		return good_iden_seq;
	}
	public void setGood_iden_seq(String good_iden_seq) {
		this.good_iden_seq = good_iden_seq;
	}
	public String getVendorid() {
		return vendorid;
	}
	public void setVendorid(String vendorid) {
		this.vendorid = vendorid;
	}
	public double getOrde_requ_pric() {
		return orde_requ_pric;
	}
	public void setOrde_requ_pric(double orde_requ_pric) {
		this.orde_requ_pric = orde_requ_pric;
	}
	public double getSale_unit_pric() {
		return sale_unit_pric;
	}
	public void setSale_unit_pric(double sale_unit_pric) {
		this.sale_unit_pric = sale_unit_pric;
	}
	public String getPurc_stat_flag() {
		return purc_stat_flag;
	}
	public void setPurc_stat_flag(String purc_stat_flag) {
		this.purc_stat_flag = purc_stat_flag;
	}
	public double getPurc_requ_quan() {
		return purc_requ_quan;
	}
	public void setPurc_requ_quan(double purc_requ_quan) {
		this.purc_requ_quan = purc_requ_quan;
	}
	public double getDeli_prod_quan() {
		return deli_prod_quan;
	}
	public void setDeli_prod_quan(double deli_prod_quan) {
		this.deli_prod_quan = deli_prod_quan;
	}
	public String getClin_user_id() {
		return clin_user_id;
	}
	public void setClin_user_id(String clin_user_id) {
		this.clin_user_id = clin_user_id;
	}
	public String getClin_date() {
		return clin_date;
	}
	public void setClin_date(String clin_date) {
		this.clin_date = clin_date;
	}
	public String getPurc_rece_id() {
		return purc_rece_id;
	}
	public void setPurc_rece_id(String purc_rece_id) {
		this.purc_rece_id = purc_rece_id;
	}
	public String getPurc_rece_date() {
		return purc_rece_date;
	}
	public void setPurc_rece_date(String purc_rece_date) {
		this.purc_rece_date = purc_rece_date;
	}
	public String getOrde_type_clas_code() {
		return orde_type_clas_code;
	}
	public void setOrde_type_clas_code(String orde_type_clas_code) {
		this.orde_type_clas_code = orde_type_clas_code;
	}
	public String getGood_iden_numb() {
		return good_iden_numb;
	}
	public void setGood_iden_numb(String good_iden_numb) {
		this.good_iden_numb = good_iden_numb;
	}
	public String getRegi_date_time() {
		return regi_date_time;
	}
	public void setRegi_date_time(String regi_date_time) {
		this.regi_date_time = regi_date_time;
	}
	public String getGood_st_spec_desc() {
		return good_st_spec_desc;
	}
	public void setGood_st_spec_desc(String good_st_spec_desc) {
		this.good_st_spec_desc = good_st_spec_desc;
	}
	public String getTran_tele_numb() {
		return tran_tele_numb;
	}
	public void setTran_tele_numb(String tran_tele_numb) {
		this.tran_tele_numb = tran_tele_numb;
	}
	public String getAdde_text_desc() {
		return adde_text_desc;
	}
	public void setAdde_text_desc(String adde_text_desc) {
		this.adde_text_desc = adde_text_desc;
	}
}
