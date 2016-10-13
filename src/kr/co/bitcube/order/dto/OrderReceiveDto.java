package kr.co.bitcube.order.dto;

/**
 * 인수 Dto
 */
public class OrderReceiveDto {
	/*
		orde_iden_numb : 주문번호
		orde_sequ_numb : 주문차수
		purc_iden_numb : 발주차수
		deli_iden_numb : 출하차수
		rece_iden_numb : 인수차수
		orde_type_clas : 주문유형
		groupid : 그룹 Id
		clientid : 법인 Id
		branchid : 사업장 id 
		orde_regi_date : 주문등록일
		deli_regi_date : 출하일
		rece_regi_date : 인수일
		deli_area_code : 권역
		vendorid : 공급사 Id
		vendornm : 공급사명
		disp_good_id : 상품진열 Seq
		vtax_clas_coda : 상품과세구분
		sale_prod_quan : 인수수량
		sale_prod_pris : 매출단가
		sele_prod_amou : 매출금액
		purc_prod_quan : 매입단가
		purc_prod_amou : 매입금액
		good_iden_numb : 상품코드
		good_name : 상품명
		orde_user_id : 주문자 Id
		real_rece_numb : 실인수자 Id
		sale_sequ_numb : 매출 id
		buyi_sequ_numb : 매입 Id
	 */
	private String orde_iden_numb;
	private String orde_sequ_numb;
	private String purc_iden_numb;
	private String deli_iden_numb;
	private String rece_iden_numb;
	private String orde_type_clas;
	private String groupid;
	private String clientid;
	private String branchid;
	private String orde_regi_date;
	private String deli_regi_date;
	private String rece_regi_date;
	private String deli_area_code;
	private String vendorid;
	private String vendornm;
	private String disp_good_id;
	private String vtax_clas_code;
	private double sale_prod_quan;
	private double sale_prod_pris;
	private double sele_prod_amou;
	private double purc_prod_quan;
	private double purc_prod_amou;
	private String good_iden_numb;
	private String good_name;
	private String orde_user_id;
	private String real_rece_numb;
	private String sale_sequ_numb;
	private String buyi_sequ_numb;
	
	
	/**
	 * 선정산 히스토리에서 사용되는 추가 칼럼명
	 */
	private String delivery_quan;
	private String delivery_date;
	private String delivery_desc;
	private String regi_user_id;
	private String regi_date_time;
	private String mracptsub_id;
	
	/** * 실적정보에서 사용되는 칼럼명 */
	private String cons_iden_name;
	private String branchnm;
	private String stat_flag;
	private String quantity;
	private String orde_requ_pric;
	private String sale_unit_pric;
	
	
	private String good_st_spec_desc;
	
	
	public String getCons_iden_name() {
		return cons_iden_name;
	}
	public void setCons_iden_name(String cons_iden_name) {
		this.cons_iden_name = cons_iden_name;
	}
	public String getBranchnm() {
		return branchnm;
	}
	public void setBranchnm(String branchnm) {
		this.branchnm = branchnm;
	}
	public String getStat_flag() {
		return stat_flag;
	}
	public void setStat_flag(String stat_flag) {
		this.stat_flag = stat_flag;
	}
	public String getQuantity() {
		return quantity;
	}
	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}
	public String getOrde_requ_pric() {
		return orde_requ_pric;
	}
	public void setOrde_requ_pric(String orde_requ_pric) {
		this.orde_requ_pric = orde_requ_pric;
	}
	public String getSale_unit_pric() {
		return sale_unit_pric;
	}
	public void setSale_unit_pric(String sale_unit_pric) {
		this.sale_unit_pric = sale_unit_pric;
	}
	public String getDelivery_quan() {
		return delivery_quan;
	}
	public void setDelivery_quan(String delivery_quan) {
		this.delivery_quan = delivery_quan;
	}
	public String getDelivery_date() {
		return delivery_date;
	}
	public void setDelivery_date(String delivery_date) {
		this.delivery_date = delivery_date;
	}
	public String getDelivery_desc() {
		return delivery_desc;
	}
	public void setDelivery_desc(String delivery_desc) {
		this.delivery_desc = delivery_desc;
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
	public String getRece_iden_numb() {
		return rece_iden_numb;
	}
	public void setRece_iden_numb(String rece_iden_numb) {
		this.rece_iden_numb = rece_iden_numb;
	}
	public String getOrde_type_clas() {
		return orde_type_clas;
	}
	public void setOrde_type_clas(String orde_type_clas) {
		this.orde_type_clas = orde_type_clas;
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
	public String getOrde_regi_date() {
		return orde_regi_date;
	}
	public void setOrde_regi_date(String orde_regi_date) {
		this.orde_regi_date = orde_regi_date;
	}
	public String getDeli_regi_date() {
		return deli_regi_date;
	}
	public void setDeli_regi_date(String deli_regi_date) {
		this.deli_regi_date = deli_regi_date;
	}
	public String getRece_regi_date() {
		return rece_regi_date;
	}
	public void setRece_regi_date(String rece_regi_date) {
		this.rece_regi_date = rece_regi_date;
	}
	public String getDeli_area_code() {
		return deli_area_code;
	}
	public void setDeli_area_code(String deli_area_code) {
		this.deli_area_code = deli_area_code;
	}
	public String getVendorid() {
		return vendorid;
	}
	public void setVendorid(String vendorid) {
		this.vendorid = vendorid;
	}
	public String getVendornm() {
		return vendornm;
	}
	public void setVendornm(String vendornm) {
		this.vendornm = vendornm;
	}
	public String getDisp_good_id() {
		return disp_good_id;
	}
	public void setDisp_good_id(String disp_good_id) {
		this.disp_good_id = disp_good_id;
	}
	public String getVtax_clas_code() {
		return vtax_clas_code;
	}
	public void setVtax_clas_code(String vtax_clas_code) {
		this.vtax_clas_code = vtax_clas_code;
	}
	public double getSale_prod_quan() {
		return sale_prod_quan;
	}
	public void setSale_prod_quan(double sale_prod_quan) {
		this.sale_prod_quan = sale_prod_quan;
	}
	public double getSale_prod_pris() {
		return sale_prod_pris;
	}
	public void setSale_prod_pris(double sale_prod_pris) {
		this.sale_prod_pris = sale_prod_pris;
	}
	public double getSele_prod_amou() {
		return sele_prod_amou;
	}
	public void setSele_prod_amou(double sele_prod_amou) {
		this.sele_prod_amou = sele_prod_amou;
	}
	public double getPurc_prod_quan() {
		return purc_prod_quan;
	}
	public void setPurc_prod_quan(double purc_prod_quan) {
		this.purc_prod_quan = purc_prod_quan;
	}
	public double getPurc_prod_amou() {
		return purc_prod_amou;
	}
	public void setPurc_prod_amou(double purc_prod_amou) {
		this.purc_prod_amou = purc_prod_amou;
	}
	public String getGood_iden_numb() {
		return good_iden_numb;
	}
	public void setGood_iden_numb(String good_iden_numb) {
		this.good_iden_numb = good_iden_numb;
	}
	public String getGood_name() {
		return good_name;
	}
	public void setGood_name(String good_name) {
		this.good_name = good_name;
	}
	public String getOrde_user_id() {
		return orde_user_id;
	}
	public void setOrde_user_id(String orde_user_id) {
		this.orde_user_id = orde_user_id;
	}
	public String getReal_rece_numb() {
		return real_rece_numb;
	}
	public void setReal_rece_numb(String real_rece_numb) {
		this.real_rece_numb = real_rece_numb;
	}
	public String getSale_sequ_numb() {
		return sale_sequ_numb;
	}
	public void setSale_sequ_numb(String sale_sequ_numb) {
		this.sale_sequ_numb = sale_sequ_numb;
	}
	public String getBuyi_sequ_numb() {
		return buyi_sequ_numb;
	}
	public void setBuyi_sequ_numb(String buyi_sequ_numb) {
		this.buyi_sequ_numb = buyi_sequ_numb;
	}
	public String getMracptsub_id() {
		return mracptsub_id;
	}
	public void setMracptsub_id(String mracptsub_id) {
		this.mracptsub_id = mracptsub_id;
	}
	public String getGood_st_spec_desc() {
		return good_st_spec_desc;
	}
	public void setGood_st_spec_desc(String good_st_spec_desc) {
		this.good_st_spec_desc = good_st_spec_desc;
	} 
}
