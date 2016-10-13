package kr.co.bitcube.order.dto;

/**
 * <b>출하 관련 Dto</b><br><br>
 *       orde_iden_numb : 주문번호<br>
         orde_sequ_numb : 주문차수<br>
         purc_iden_numb : 발주차수<br>
         deli_iden_numb : 출하차수<br>
         deli_prod_quan : 출하수량<br>
         rece_prod_quan : 실인수수량<br>
         deli_stat_flag : 출하상태<br>
         deli_type_clas : 배송유형<br>
         deli_comp_clas : 배송회사코드<br>
         deli_invo_iden : 송장번호<br>
         ref_deli_iden_numb : 상위출하차수<br>
         deli_degr_id : 출하자Id<br>
         deli_degr_date : 출하일자<br>
         rece_proc_id : 인수자 ID<br>
         purc_proc_date : 인수일자<br>
         isdelivery : 배송완료여부<br>
 */
public class OrderDeliDto {

	private String orde_iden_numb;
	private String orde_sequ_numb;
	private String purc_iden_numb;
	private String deli_iden_numb;
	private double deli_prod_quan;
	private double rece_prod_quan;
	private String deli_stat_flag;
	private String deli_type_clas;
	private String deli_comp_clas;
	private String deli_invo_iden;
	private String ref_deli_iden_numb;
	private String deli_degr_id;
	private String deli_degr_date;
	private String rece_proc_id;
	private String purc_proc_date;
	private String isdelivery;
	private String receipt_num;
	private String deli_type_clas_code;
	// 주문 상세 출하 그리드에서 추가로 필요로 하는 칼럼명
	private String isdelivery_name;
	private String deli_stat_flag_name;
	
	// 출하처리에서 추가로 필요로 하는 칼럼
	private String orde_type_clas; //주문유형
	private String good_name;//상품명
	private String requ_deli_date;//납품요청날짜
	private String purc_requ_quan;//발주수량
	private String good_spec_desc;//상품규격
	private String tran_data_addr;//배송지 주소
	private String orde_client_name;//주문요청고객사
	private String orde_user_name;//주문자
	private String tran_user_name;//인수자
	private String clin_date;//발주의뢰일
	private String attach_cnt;//첨부파일 갯수
	private String vendornm;//공급사명
	private int deliveryType;//배송유형
	private String good_clas_type;// 상품 속성 (일반, 지정, 수탁)
	private String vendorId;// 공급사 ID
	
	// 실인수처리에서 추가로 필요로 하는 칼럼 : 2012-12-13 parkjoon
	private double sale_unit_pric; // 매입단가
	private String good_iden_numb; // 상품코드

	// 인수내역 / 반품신청 에서 추가로 필요 2012-12-14 parkjoon
	private String orde_requ_quan; // 주문신청
	private String sum_return_request_quan; // 반품 요청 상태 수량 + 반품 승인 수량
	private String rece_iden_numb; // 인수차수
	private String disp_good_id; // 진열 seq
	
	//첨부파일
	private String attach_file_1;		
	private String attach_file_2;		
	private String attach_file_3;		
	private String attach_file_name1;		
	private String attach_file_name2;		
	private String attach_file_name3;		
	private String attach_file_path1;		
	private String attach_file_path2;		
	private String attach_file_path3;		
	
	private String receipt_img_file;		
	private String receipt_img_file_name;		
	private String receipt_img_file_path;		
	
	private String regi_date_time;		
	private String purc_rece_date;		
	private String receivecancelable;		
	private String good_st_spec_desc;		
	
	private String tran_tele_numb;		
	private String total_sale_unit_pric;		
	private String adde_text_desc;		
	
	private String worknm;		
	
	private String cons_iden_name;
	
	private double to_do_deli_prod_quan;
	
	private String branchId;//구매사ID
	
	private String temp_orde_iden_numb;
	private String add_repre_sequ_numb;
	
	private String add_prod_prefix;
	private String add_prod_vendornm;
	private String add_receive_yn;
	private String sub_add_receive_yn;
	private String is_add_mst;
	
	private String deli_sche_date;

	private String is_add;
	private String isPurcPrint;
	
	private String mst_good_name;
	
	private String mst_orde_sequ_numb;
	
	private String add_prod;
	
	public String getAdd_prod() {
		return add_prod;
	}
	public void setAdd_prod(String add_prod) {
		this.add_prod = add_prod;
	}
	public String getDeli_sche_date() {
		return deli_sche_date;
	}
	public void setDeli_sche_date(String deli_sche_date) {
		this.deli_sche_date = deli_sche_date;
	}
	public String getSub_add_receive_yn() {
		return sub_add_receive_yn;
	}
	public void setSub_add_receive_yn(String sub_add_receive_yn) {
		this.sub_add_receive_yn = sub_add_receive_yn;
	}
	public String getAdd_prod_prefix() {
		return add_prod_prefix;
	}
	public void setAdd_prod_prefix(String add_prod_prefix) {
		this.add_prod_prefix = add_prod_prefix;
	}
	public String getAdd_prod_vendornm() {
		return add_prod_vendornm;
	}
	public void setAdd_prod_vendornm(String add_prod_vendornm) {
		this.add_prod_vendornm = add_prod_vendornm;
	}
	public String getAdd_receive_yn() {
		return add_receive_yn;
	}
	public void setAdd_receive_yn(String add_receive_yn) {
		this.add_receive_yn = add_receive_yn;
	}
	public String getIs_add_mst() {
		return is_add_mst;
	}
	public void setIs_add_mst(String is_add_mst) {
		this.is_add_mst = is_add_mst;
	}
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	public double getTo_do_deli_prod_quan() {
		return to_do_deli_prod_quan;
	}
	public void setTo_do_deli_prod_quan(double to_do_deli_prod_quan) {
		this.to_do_deli_prod_quan = to_do_deli_prod_quan;
	}
	public String getCons_iden_name() {
		return cons_iden_name;
	}
	public void setCons_iden_name(String cons_iden_name) {
		this.cons_iden_name = cons_iden_name;
	}
	public String getTran_tele_numb() {
		return tran_tele_numb;
	}
	public void setTran_tele_numb(String tran_tele_numb) {
		this.tran_tele_numb = tran_tele_numb;
	}
	public String getTotal_sale_unit_pric() {
		return total_sale_unit_pric;
	}
	public void setTotal_sale_unit_pric(String total_sale_unit_pric) {
		this.total_sale_unit_pric = total_sale_unit_pric;
	}
	public String getReceipt_img_file() {
		return receipt_img_file;
	}
	public void setReceipt_img_file(String receipt_img_file) {
		this.receipt_img_file = receipt_img_file;
	}
	public String getReceipt_img_file_name() {
		return receipt_img_file_name;
	}
	public void setReceipt_img_file_name(String receipt_img_file_name) {
		this.receipt_img_file_name = receipt_img_file_name;
	}
	public String getReceipt_img_file_path() {
		return receipt_img_file_path;
	}
	public void setReceipt_img_file_path(String receipt_img_file_path) {
		this.receipt_img_file_path = receipt_img_file_path;
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
	public String getSum_return_request_quan() {
		return sum_return_request_quan;
	}
	public void setSum_return_request_quan(String sum_return_request_quan) {
		this.sum_return_request_quan = sum_return_request_quan;
	}
	public String getOrde_requ_quan() {
		return orde_requ_quan;
	}
	public void setOrde_requ_quan(String orde_requ_quan) {
		this.orde_requ_quan = orde_requ_quan;
	}
	public double getSale_unit_pric() {
		return sale_unit_pric;
	}
	public void setSale_unit_pric(double sale_unit_pric) {
		this.sale_unit_pric = sale_unit_pric;
	}
	public String getGood_iden_numb() {
		return good_iden_numb;
	}
	public void setGood_iden_numb(String good_iden_numb) {
		this.good_iden_numb = good_iden_numb;
	}
	public int getDeliveryType() {
		return deliveryType;
	}
	public void setDeliveryType(int deliveryType) {
		this.deliveryType = deliveryType;
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
	public String getRequ_deli_date() {
		return requ_deli_date;
	}
	public void setRequ_deli_date(String requ_deli_date) {
		this.requ_deli_date = requ_deli_date;
	}
	public String getPurc_requ_quan() {
		return purc_requ_quan;
	}
	public void setPurc_requ_quan(String purc_requ_quan) {
		this.purc_requ_quan = purc_requ_quan;
	}
	public String getGood_spec_desc() {
		return good_spec_desc;
	}
	public void setGood_spec_desc(String good_spec_desc) {
		this.good_spec_desc = good_spec_desc;
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
	public String getClin_date() {
		return clin_date;
	}
	public void setClin_date(String clin_date) {
		this.clin_date = clin_date;
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
	public String getIsdelivery_name() {
		return isdelivery_name;
	}
	public void setIsdelivery_name(String isdelivery_name) {
		this.isdelivery_name = isdelivery_name;
	}
	public String getDeli_stat_flag_name() {
		return deli_stat_flag_name;
	}
	public void setDeli_stat_flag_name(String deli_stat_flag_name) {
		this.deli_stat_flag_name = deli_stat_flag_name;
	}
	public String getIsdelivery() {
		return isdelivery;
	}
	public void setIsdelivery(String isdelivery) {
		this.isdelivery = isdelivery;
	}
	public String getOrde_iden_numb() {
		return orde_iden_numb;
	}
	public void setOrde_iden_numb(String orde_iden_numb) {
		this.orde_iden_numb = orde_iden_numb;
	}
	public String getOrde_sequ_numb() {
		return orde_sequ_numb;
	}
	public void setOrde_sequ_numb(String orde_sequ_numb) {
		this.orde_sequ_numb = orde_sequ_numb;
	}
	public String getPurc_iden_numb() {
		return purc_iden_numb;
	}
	public void setPurc_iden_numb(String purc_iden_numb) {
		this.purc_iden_numb = purc_iden_numb;
	}
	public String getDeli_iden_numb() {
		return deli_iden_numb;
	}
	public void setDeli_iden_numb(String deli_iden_numb) {
		this.deli_iden_numb = deli_iden_numb;
	}
	public double getDeli_prod_quan() {
		return deli_prod_quan;
	}
	public void setDeli_prod_quan(double deli_prod_quan) {
		this.deli_prod_quan = deli_prod_quan;
	}
	public double getRece_prod_quan() {
		return rece_prod_quan;
	}
	public void setRece_prod_quan(double rece_prod_quan) {
		this.rece_prod_quan = rece_prod_quan;
	}
	public String getDeli_stat_flag() {
		return deli_stat_flag;
	}
	public void setDeli_stat_flag(String deli_stat_flag) {
		this.deli_stat_flag = deli_stat_flag;
	}
	public String getDeli_type_clas() {
		return deli_type_clas;
	}
	public void setDeli_type_clas(String deli_type_clas) {
		this.deli_type_clas = deli_type_clas;
	}
	public String getDeli_comp_clas() {
		return deli_comp_clas;
	}
	public void setDeli_comp_clas(String deli_comp_clas) {
		this.deli_comp_clas = deli_comp_clas;
	}
	public String getDeli_invo_iden() {
		return deli_invo_iden;
	}
	public void setDeli_invo_iden(String deli_invo_iden) {
		this.deli_invo_iden = deli_invo_iden;
	}
	public String getRef_deli_iden_numb() {
		return ref_deli_iden_numb;
	}
	public void setRef_deli_iden_numb(String ref_deli_iden_numb) {
		this.ref_deli_iden_numb = ref_deli_iden_numb;
	}
	public String getDeli_degr_id() {
		return deli_degr_id;
	}
	public void setDeli_degr_id(String deli_degr_id) {
		this.deli_degr_id = deli_degr_id;
	}
	public String getDeli_degr_date() {
		return deli_degr_date;
	}
	public void setDeli_degr_date(String deli_degr_date) {
		this.deli_degr_date = deli_degr_date;
	}
	public String getRece_proc_id() {
		return rece_proc_id;
	}
	public void setRece_proc_id(String rece_proc_id) {
		this.rece_proc_id = rece_proc_id;
	}
	public String getPurc_proc_date() {
		return purc_proc_date;
	}
	public void setPurc_proc_date(String purc_proc_date) {
		this.purc_proc_date = purc_proc_date;
	}
	public String getGood_clas_type() {
		return good_clas_type;
	}
	public void setGood_clas_type(String good_clas_type) {
		this.good_clas_type = good_clas_type;
	}
	public String getVendorId() {
		return vendorId;
	}
	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}
	public String getReceipt_num() {
		return receipt_num;
	}
	public void setReceipt_num(String receipt_num) {
		this.receipt_num = receipt_num;
	}
	public String getDisp_good_id() {
		return disp_good_id;
	}
	public void setDisp_good_id(String disp_good_id) {
		this.disp_good_id = disp_good_id;
	}
	public String getDeli_type_clas_code() {
		return deli_type_clas_code;
	}
	public void setDeli_type_clas_code(String deli_type_clas_code) {
		this.deli_type_clas_code = deli_type_clas_code;
	}
	public String getRece_iden_numb() {
		return rece_iden_numb;
	}
	public void setRece_iden_numb(String rece_iden_numb) {
		this.rece_iden_numb = rece_iden_numb;
	}
	public String getRegi_date_time() {
		return regi_date_time;
	}
	public void setRegi_date_time(String regi_date_time) {
		this.regi_date_time = regi_date_time;
	}
	public String getPurc_rece_date() {
		return purc_rece_date;
	}
	public void setPurc_rece_date(String purc_rece_date) {
		this.purc_rece_date = purc_rece_date;
	}
	public String getReceivecancelable() {
		return receivecancelable;
	}
	public void setReceivecancelable(String receivecancelable) {
		this.receivecancelable = receivecancelable;
	}
	public String getGood_st_spec_desc() {
		return good_st_spec_desc;
	}
	public void setGood_st_spec_desc(String good_st_spec_desc) {
		this.good_st_spec_desc = good_st_spec_desc;
	}
	public String getAdde_text_desc() {
		return adde_text_desc;
	}
	public void setAdde_text_desc(String adde_text_desc) {
		this.adde_text_desc = adde_text_desc;
	}
	public String getWorknm() {
		return worknm;
	}
	public void setWorknm(String worknm) {
		this.worknm = worknm;
	}
	public String getAdd_repre_sequ_numb() {
		return add_repre_sequ_numb;
	}
	public void setAdd_repre_sequ_numb(String add_repre_sequ_numb) {
		this.add_repre_sequ_numb = add_repre_sequ_numb;
	}
	public String getTemp_orde_iden_numb() {
		return temp_orde_iden_numb;
	}
	public void setTemp_orde_iden_numb(String temp_orde_iden_numb) {
		this.temp_orde_iden_numb = temp_orde_iden_numb;
	}
	public String getIs_add() {
		return is_add;
	}
	public void setIs_add(String is_add) {
		this.is_add = is_add;
	}
	public String getIsPurcPrint() {
		return isPurcPrint;
	}
	public void setIsPurcPrint(String isPurcPrint) {
		this.isPurcPrint = isPurcPrint;
	}
	public String getMst_good_name() {
		return mst_good_name;
	}
	public void setMst_good_name(String mst_good_name) {
		this.mst_good_name = mst_good_name;
	}
	public String getMst_orde_sequ_numb() {
		return mst_orde_sequ_numb;
	}
	public void setMst_orde_sequ_numb(String mst_orde_sequ_numb) {
		this.mst_orde_sequ_numb = mst_orde_sequ_numb;
	}
}
