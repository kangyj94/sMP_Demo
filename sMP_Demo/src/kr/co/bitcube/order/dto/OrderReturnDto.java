package kr.co.bitcube.order.dto;

/**
 * 반품요청 관련 Dto<br><br>
 * 
 *   retu_iden_num		: 반품 PK<br>
     orde_iden_numb	: 주문번호<br>
     orde_sequ_numb	: 주문차수<br>
     deli_iden_numb		: 출하차수<br>
     purc_iden_numb	: 발주차수<br>
     retu_stat_flag		: 반품요청상태<br>
     retu_prod_quan	: 반품요청수량<br>
     retu_regi_id			: 반품의뢰자 Id<br>
     retu_regi_date		: 반품의뢰 날짜<br>
     vendorid				: 공급사 id<br>
     retu_rese_text		: 반품요청사유<br>
     retu_cnac_text		: 공급사의 반품 거부사유<br>
     vend_proc_id		: 공급사 처리자 Id<br>
     vend_proc_date 	: 공급사 처리 일자<br>
 */
public class OrderReturnDto {
	private String retu_iden_num ;
	private String orde_iden_numb;
	private String orde_sequ_numb;
	private String deli_iden_numb;
	private String purc_iden_numb;
	private String retu_stat_flag;
	private double retu_prod_quan;
	private String retu_regi_id  ;
	private String retu_regi_date;
	private String vendorid      ;
	private String retu_rese_text;
	private String retu_cnac_text;
	private String vend_proc_id  ;
	private String vend_proc_date; 
	
	// 반품이력에서 사용하는 추가 칼럼
	private String orde_type_clas;  		// 주문유형
	private String orde_client_name; 	// 고객사
	private String vendornm;				// 공급사명 
	private String good_name; 			// 상품명
	private String orde_requ_pric;		// 판매단가 
	private String retu_requ_pric; 		// 반품요청금액(total)
	private String rece_prod_quan; 		// 인수수량
	private String good_spec_desc; 		// 규격
	private String orde_rece_quan; 		// 주문/인수수량
	private String disp_good_id; 			// 진열 SEQ 
	private String good_iden_numb;		// 상품ID
	
	// 공급사 반품이력에서 추가로 사용컬럼.
	private String sale_unit_pric; 			// 매입금액
	private String orde_requ_quan;		// 주문수량
	private String tot_sale_pric;			// 매입금액 * 주문 수량
	private String rece_iden_numb;		// 인수차수
	private String good_st_spec_desc;	
	
	private String branchid;//구매사ID
	
	
	
	public String getBranchid() {
		return branchid;
	}
	public void setBranchid(String branchid) {
		this.branchid = branchid;
	}
	public String getSale_unit_pric() {
		return sale_unit_pric;
	}
	public void setSale_unit_pric(String sale_unit_pric) {
		this.sale_unit_pric = sale_unit_pric;
	}
	public String getOrde_requ_quan() {
		return orde_requ_quan;
	}
	public void setOrde_requ_quan(String orde_requ_quan) {
		this.orde_requ_quan = orde_requ_quan;
	}
	public String getTot_sale_pric() {
		return tot_sale_pric;
	}
	public void setTot_sale_pric(String tot_sale_pric) {
		this.tot_sale_pric = tot_sale_pric;
	}
	public String getGood_spec_desc() {
		return good_spec_desc;
	}
	public void setGood_spec_desc(String good_spec_desc) {
		this.good_spec_desc = good_spec_desc;
	}
	public String getOrde_rece_quan() {
		return orde_rece_quan;
	}
	public void setOrde_rece_quan(String orde_rece_quan) {
		this.orde_rece_quan = orde_rece_quan;
	}
	public String getRetu_iden_num() {
		return retu_iden_num;
	}
	public void setRetu_iden_num(String retu_iden_num) {
		this.retu_iden_num = retu_iden_num;
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
	public String getDeli_iden_numb() {
		return deli_iden_numb;
	}
	public void setDeli_iden_numb(String deli_iden_numb) {
		this.deli_iden_numb = deli_iden_numb;
	}
	public String getPurc_iden_numb() {
		return purc_iden_numb;
	}
	public void setPurc_iden_numb(String purc_iden_numb) {
		this.purc_iden_numb = purc_iden_numb;
	}
	public String getRetu_stat_flag() {
		return retu_stat_flag;
	}
	public void setRetu_stat_flag(String retu_stat_flag) {
		this.retu_stat_flag = retu_stat_flag;
	}
	public double getRetu_prod_quan() {
		return retu_prod_quan;
	}
	public void setRetu_prod_quan(double retu_prod_quan) {
		this.retu_prod_quan = retu_prod_quan;
	}
	public String getRetu_regi_id() {
		return retu_regi_id;
	}
	public void setRetu_regi_id(String retu_regi_id) {
		this.retu_regi_id = retu_regi_id;
	}
	public String getRetu_regi_date() {
		return retu_regi_date;
	}
	public void setRetu_regi_date(String retu_regi_date) {
		this.retu_regi_date = retu_regi_date;
	}
	public String getVendorid() {
		return vendorid;
	}
	public void setVendorid(String vendorid) {
		this.vendorid = vendorid;
	}
	public String getRetu_rese_text() {
		return retu_rese_text;
	}
	public void setRetu_rese_text(String retu_rese_text) {
		this.retu_rese_text = retu_rese_text;
	}
	public String getRetu_cnac_text() {
		return retu_cnac_text;
	}
	public void setRetu_cnac_text(String retu_cnac_text) {
		this.retu_cnac_text = retu_cnac_text;
	}
	public String getVend_proc_id() {
		return vend_proc_id;
	}
	public void setVend_proc_id(String vend_proc_id) {
		this.vend_proc_id = vend_proc_id;
	}
	public String getVend_proc_date() {
		return vend_proc_date;
	}
	public void setVend_proc_date(String vend_proc_date) {
		this.vend_proc_date = vend_proc_date;
	}
	public String getOrde_type_clas() {
		return orde_type_clas;
	}
	public void setOrde_type_clas(String orde_type_clas) {
		this.orde_type_clas = orde_type_clas;
	}
	public String getOrde_client_name() {
		return orde_client_name;
	}
	public void setOrde_client_name(String orde_client_name) {
		this.orde_client_name = orde_client_name;
	}
	public String getVendornm() {
		return vendornm;
	}
	public void setVendornm(String vendornm) {
		this.vendornm = vendornm;
	}
	public String getGood_name() {
		return good_name;
	}
	public void setGood_name(String good_name) {
		this.good_name = good_name;
	}
	public String getOrde_requ_pric() {
		return orde_requ_pric;
	}
	public void setOrde_requ_pric(String orde_requ_pric) {
		this.orde_requ_pric = orde_requ_pric;
	}
	public String getRetu_requ_pric() {
		return retu_requ_pric;
	}
	public void setRetu_requ_pric(String retu_requ_pric) {
		this.retu_requ_pric = retu_requ_pric;
	}
	public String getRece_prod_quan() {
		return rece_prod_quan;
	}
	public void setRece_prod_quan(String rece_prod_quan) {
		this.rece_prod_quan = rece_prod_quan;
	}
	public String getDisp_good_id() {
		return disp_good_id;
	}
	public void setDisp_good_id(String disp_good_id) {
		this.disp_good_id = disp_good_id;
	}
	public String getGood_iden_numb() {
		return good_iden_numb;
	}
	public void setGood_iden_numb(String good_iden_numb) {
		this.good_iden_numb = good_iden_numb;
	}
	public String getRece_iden_numb() {
		return rece_iden_numb;
	}
	public void setRece_iden_numb(String rece_iden_numb) {
		this.rece_iden_numb = rece_iden_numb;
	}
	public String getGood_st_spec_desc() {
		return good_st_spec_desc;
	}
	public void setGood_st_spec_desc(String good_st_spec_desc) {
		this.good_st_spec_desc = good_st_spec_desc;
	}
}
