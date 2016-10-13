package kr.co.bitcube.product.dto;

public class BuyProductDto {
	private String  lev;           
	private String  disp_good_id;
	private String  good_name;      
	private String  good_iden_numb; 
	private String  borgnm;         
	private String  good_st_spec_desc;
	private String  good_spec_desc;
	private String  good_spec;
	private String  small_img_path;
	private String  orde_clas_code; 
	private String  sell_price;
	private String  sale_unit_pric;
	private String  ord_unit_cnt;   
	private String  ord_quan;
	private String  ord_unlimit_quan;
	private String  total_amout;
	private String  total_amout_sale_unit_pric;
	private String  stand_order_date;
	private String  isdisppastgood;
	private String  good_inventory_cnt;
	private String  good_clas_code;
	private String  cust_good_iden_numb;
	private String  good_same_word;
	private String  isUse;
	private String  order_cnt;
	private String  final_good_sts;
	
	private String  original_img_path;
	private String  large_img_path; 
	private String  make_comp_name; 
	private String  deli_mini_day; 
	private String  deli_mini_quan ;
	private String  good_desc;
	
	private String majo_code_name;
	private String full_cate_name;
	
	private String pressentnm;
	private String phonenum;
	private String areatypenm;
	
	private String comp_iden_name;
	
	private String stan_deli_day;
	private String vendorid;
	
	private String vendornm;
	private String vendorid_string;
	private String vendornm_string;
	
	//마진율 높은 공급사 우선순위를 위한 temp dto 2014-05-19 비트큐브 임상건
	private String tmpvendorid;
	private String tmpborgnm;
	private String tmpgood_st_spec_desc;
	private String tmpgood_spec_desc;
	private String tmpsmall_img_path;
	private String tmporde_clas_code;
	private String tmpgood_same_word;
	private String tmpdeli_mini_quan;
	private String tmpdeli_mini_day;
	private String tmporder_cnt;
	private String tmpgood_inventory_cnt;
	private String tmpgood_clas_code;
	private String tmporiginal_img_path;
	private String tmpdisp_good_id;
	
	private String disp_good_id2;
	private String ori_good_name;
	//마진율 높은 공급사 우선순위를 위한 temp dto 2014-05-19 비트큐브 임상건

	private String the_day_post;//당일배송
	
	private String product_manager;//상품담당자
	private String isDistribute;	//물량배분
	private String is_add_good;
	
	public String getGood_spec() {
		return good_spec;
	}
	public void setGood_spec(String good_spec) {
		this.good_spec = good_spec;
	}
	public String getProduct_manager() {
		return product_manager;
	}
	public void setProduct_manager(String product_manager) {
		this.product_manager = product_manager;
	}
	public String getThe_day_post() {
		return the_day_post;
	}
	public void setThe_day_post(String the_day_post) {
		this.the_day_post = the_day_post;
	}
	public String getOri_good_name() {
		return ori_good_name;
	}
	public String getVendornm() {
		return vendornm;
	}
	public void setVendornm(String vendornm) {
		this.vendornm = vendornm;
	}
	public String getVendorid_string() {
		return vendorid_string;
	}
	public void setVendorid_string(String vendorid_string) {
		this.vendorid_string = vendorid_string;
	}
	public String getVendornm_string() {
		return vendornm_string;
	}
	public void setVendornm_string(String vendornm_string) {
		this.vendornm_string = vendornm_string;
	}
	public void setOri_good_name(String ori_good_name) {
		this.ori_good_name = ori_good_name;
	}
	public String getDisp_good_id2() {
		return disp_good_id2;
	}
	public void setDisp_good_id2(String disp_good_id2) {
		this.disp_good_id2 = disp_good_id2;
	}
	public String getTmpdisp_good_id() {
		return tmpdisp_good_id;
	}
	public void setTmpdisp_good_id(String tmpdisp_good_id) {
		this.tmpdisp_good_id = tmpdisp_good_id;
	}
	public String getTmpgood_st_spec_desc() {
		return tmpgood_st_spec_desc;
	}
	public void setTmpgood_st_spec_desc(String tmpgood_st_spec_desc) {
		this.tmpgood_st_spec_desc = tmpgood_st_spec_desc;
	}
	public String getTmpgood_spec_desc() {
		return tmpgood_spec_desc;
	}
	public void setTmpgood_spec_desc(String tmpgood_spec_desc) {
		this.tmpgood_spec_desc = tmpgood_spec_desc;
	}
	public String getTmpsmall_img_path() {
		return tmpsmall_img_path;
	}
	public void setTmpsmall_img_path(String tmpsmall_img_path) {
		this.tmpsmall_img_path = tmpsmall_img_path;
	}
	public String getTmporde_clas_code() {
		return tmporde_clas_code;
	}
	public void setTmporde_clas_code(String tmporde_clas_code) {
		this.tmporde_clas_code = tmporde_clas_code;
	}
	public String getTmpgood_same_word() {
		return tmpgood_same_word;
	}
	public void setTmpgood_same_word(String tmpgood_same_word) {
		this.tmpgood_same_word = tmpgood_same_word;
	}
	public String getTmpdeli_mini_quan() {
		return tmpdeli_mini_quan;
	}
	public void setTmpdeli_mini_quan(String tmpdeli_mini_quan) {
		this.tmpdeli_mini_quan = tmpdeli_mini_quan;
	}
	public String getTmpdeli_mini_day() {
		return tmpdeli_mini_day;
	}
	public void setTmpdeli_mini_day(String tmpdeli_mini_day) {
		this.tmpdeli_mini_day = tmpdeli_mini_day;
	}
	public String getTmporder_cnt() {
		return tmporder_cnt;
	}
	public void setTmporder_cnt(String tmporder_cnt) {
		this.tmporder_cnt = tmporder_cnt;
	}
	public String getTmpgood_inventory_cnt() {
		return tmpgood_inventory_cnt;
	}
	public void setTmpgood_inventory_cnt(String tmpgood_inventory_cnt) {
		this.tmpgood_inventory_cnt = tmpgood_inventory_cnt;
	}
	public String getTmpgood_clas_code() {
		return tmpgood_clas_code;
	}
	public void setTmpgood_clas_code(String tmpgood_clas_code) {
		this.tmpgood_clas_code = tmpgood_clas_code;
	}
	public String getTmporiginal_img_path() {
		return tmporiginal_img_path;
	}
	public void setTmporiginal_img_path(String tmporiginal_img_path) {
		this.tmporiginal_img_path = tmporiginal_img_path;
	}
	public String getTmpvendorid() {
		return tmpvendorid;
	}
	public void setTmpvendorid(String tmpvendorid) {
		this.tmpvendorid = tmpvendorid;
	}
	public String getTmpborgnm() {
		return tmpborgnm;
	}
	public void setTmpborgnm(String tmpborgnm) {
		this.tmpborgnm = tmpborgnm;
	}
	public String getLev() {
		return lev;
	}
	public void setLev(String lev) {
		this.lev = lev;
	}
	public String getDisp_good_id() {
		return disp_good_id;
	}
	public void setDisp_good_id(String disp_good_id) {
		this.disp_good_id = disp_good_id;
	}
	public String getGood_name() {
		return good_name;
	}
	public void setGood_name(String good_name) {
		this.good_name = good_name;
	}
	public String getGood_iden_numb() {
		return good_iden_numb;
	}
	public void setGood_iden_numb(String good_iden_numb) {
		this.good_iden_numb = good_iden_numb;
	}
	public String getBorgnm() {
		return borgnm;
	}
	public void setBorgnm(String borgnm) {
		this.borgnm = borgnm;
	}
	public String getGood_spec_desc() {
		return good_spec_desc;
	}
	public void setGood_spec_desc(String good_spec_desc) {
		this.good_spec_desc = good_spec_desc;
	}
	public String getGood_st_spec_desc() {
		return good_st_spec_desc;
	}
	public void setGood_st_spec_desc(String good_st_spec_desc) {
		this.good_st_spec_desc = good_st_spec_desc;
	}
	public String getSmall_img_path() {
		return small_img_path;
	}
	public void setSmall_img_path(String small_img_path) {
		this.small_img_path = small_img_path;
	}
	public String getOrde_clas_code() {
		return orde_clas_code;
	}
	public void setOrde_clas_code(String orde_clas_code) {
		this.orde_clas_code = orde_clas_code;
	}
	public String getSell_price() {
		return sell_price;
	}
	public void setSell_price(String sell_price) {
		this.sell_price = sell_price;
	}
	public String getSale_unit_pric() {
		return sale_unit_pric;
	}
	public void setSale_unit_pric(String sale_unit_pric) {
		this.sale_unit_pric = sale_unit_pric;
	}
	public String getOrd_unit_cnt() {
		return ord_unit_cnt;
	}
	public void setOrd_unit_cnt(String ord_unit_cnt) {
		this.ord_unit_cnt = ord_unit_cnt;
	}
	public String getOrd_quan() {
		return ord_quan;
	}
	public void setOrd_quan(String ord_quan) {
		this.ord_quan = ord_quan;
	}
	public String getOrd_unlimit_quan() {
		return ord_unlimit_quan;
	}
	public void setOrd_unlimit_quan(String ord_unlimit_quan) {
		this.ord_unlimit_quan = ord_unlimit_quan;
	}
	public String getTotal_amout() {
		return total_amout;
	}
	public void setTotal_amout(String total_amout) {
		this.total_amout = total_amout;
	}
	public String getTotal_amout_sale_unit_pric() {
		return total_amout_sale_unit_pric;
	}
	public void setTotal_amout_sale_unit_pric(String total_amout_sale_unit_pric) {
		this.total_amout_sale_unit_pric = total_amout_sale_unit_pric;
	}
	public String getStand_order_date() {
		return stand_order_date;
	}
	public void setStand_order_date(String stand_order_date) {
		this.stand_order_date = stand_order_date;
	}
	public String getIsdisppastgood() {
		return isdisppastgood;
	}
	public void setIsdisppastgood(String isdisppastgood) {
		this.isdisppastgood = isdisppastgood;
	}
	public String getGood_inventory_cnt() {
		return good_inventory_cnt;
	}
	public void setGood_inventory_cnt(String good_inventory_cnt) {
		this.good_inventory_cnt = good_inventory_cnt;
	}
	public String getGood_clas_code() {
		return good_clas_code;
	}
	public void setGood_clas_code(String good_clas_code) {
		this.good_clas_code = good_clas_code;
	}
	public String getCust_good_iden_numb() {
		return cust_good_iden_numb;
	}
	public void setCust_good_iden_numb(String cust_good_iden_numb) {
		this.cust_good_iden_numb = cust_good_iden_numb;
	}
	public String getGood_same_word() {
		return good_same_word;
	}
	public void setGood_same_word(String good_same_word) {
		this.good_same_word = good_same_word;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getLarge_img_path() {
		return large_img_path;
	}
	public void setLarge_img_path(String large_img_path) {
		this.large_img_path = large_img_path;
	}
	public String getOriginal_img_path() {
		return original_img_path;
	}
	public void setOriginal_img_path(String original_img_path) {
		this.original_img_path = original_img_path;
	}
	public String getMake_comp_name() {
		return make_comp_name;
	}
	public void setMake_comp_name(String make_comp_name) {
		this.make_comp_name = make_comp_name;
	}
	public String getDeli_mini_day() {
		return deli_mini_day;
	}
	public void setDeli_mini_day(String deli_mini_day) {
		this.deli_mini_day = deli_mini_day;
	}
	public String getDeli_mini_quan() {
		return deli_mini_quan;
	}
	public void setDeli_mini_quan(String deli_mini_quan) {
		this.deli_mini_quan = deli_mini_quan;
	}
	public String getGood_desc() {
		return good_desc;
	}
	public void setGood_desc(String good_desc) {
		this.good_desc = good_desc;
	}
	public String getMajo_code_name() {
		return majo_code_name;
	}
	public void setMajo_code_name(String majo_code_name) {
		this.majo_code_name = majo_code_name;
	}
	public String getFull_cate_name() {
		return full_cate_name;
	}
	public void setFull_cate_name(String full_cate_name) {
		this.full_cate_name = full_cate_name;
	}
	public String getPressentnm() {
		return pressentnm;
	}
	public void setPressentnm(String pressentnm) {
		this.pressentnm = pressentnm;
	}
	public String getPhonenum() {
		return phonenum;
	}
	public void setPhonenum(String phonenum) {
		this.phonenum = phonenum;
	}
	public String getAreatypenm() {
		return areatypenm;
	}
	public void setAreatypenm(String areatypenm) {
		this.areatypenm = areatypenm;
	}
	public String getComp_iden_name() {
		return comp_iden_name;
	}
	public void setComp_iden_name(String comp_iden_name) {
		this.comp_iden_name = comp_iden_name;
	}
	public String getOrder_cnt() {
		return order_cnt;
	}
	public void setOrder_cnt(String order_cnt) {
		this.order_cnt = order_cnt;
	}
	public String getFinal_good_sts() {
		return final_good_sts;
	}
	public void setFinal_good_sts(String final_good_sts) {
		this.final_good_sts = final_good_sts;
	}
	public String getStan_deli_day() {
		return stan_deli_day;
	}
	public void setStan_deli_day(String stan_deli_day) {
		this.stan_deli_day = stan_deli_day;
	}
	public String getVendorid() {
		return vendorid;
	}
	public void setVendorid(String vendorid) {
		this.vendorid = vendorid;
	}
	public String toString(){
		StringBuffer strBuffer = new StringBuffer(); 
		strBuffer.append("\n lev              value ["+lev              +"]");
		strBuffer.append("\n disp_good_id     value ["+disp_good_id     +"]");
		strBuffer.append("\n good_name        value ["+good_name        +"]");
		strBuffer.append("\n good_iden_numb   value ["+good_iden_numb   +"]");
		strBuffer.append("\n borgnm           value ["+borgnm           +"]");
		strBuffer.append("\n good_spec_desc   value ["+good_spec_desc   +"]");
		strBuffer.append("\n small_img_path   value ["+small_img_path   +"]");
		strBuffer.append("\n orde_clas_code   value ["+orde_clas_code   +"]");
		strBuffer.append("\n sell_price       value ["+sell_price       +"]");
		strBuffer.append("\n ord_unit_cnt     value ["+ord_unit_cnt     +"]");
		strBuffer.append("\n ord_quan         value ["+ord_quan         +"]");
		strBuffer.append("\n ord_unlimit_quan value ["+ord_unlimit_quan +"]");
		strBuffer.append("\n total_amout      value ["+total_amout      +"]");
		strBuffer.append("\n stand_order_date value ["+stand_order_date +"]");
		strBuffer.append("\n large_img_path   value ["+large_img_path +"]");
		strBuffer.append("\n make_comp_name   value ["+make_comp_name +"]");
		strBuffer.append("\n deli_mini_day    value ["+deli_mini_day  +"]");
		strBuffer.append("\n deli_mini_quan   value ["+deli_mini_quan +"]");
		strBuffer.append("\n good_desc        value ["+good_desc      +"]");
		
		return strBuffer.toString();
	}
	public String getIsDistribute() {
		return isDistribute;
	}
	public void setIsDistribute(String isDistribute) {
		this.isDistribute = isDistribute;
	}
	public String getIs_add_good() {
		return is_add_good;
	}
	public void setIs_add_good(String is_add_good) {
		this.is_add_good = is_add_good;
	}
}
