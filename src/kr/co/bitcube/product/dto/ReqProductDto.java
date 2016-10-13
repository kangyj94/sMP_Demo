package kr.co.bitcube.product.dto;

public class ReqProductDto {
	private String req_good_id        ;      /*상품등록요청SEQ */
	private String good_iden_numb      ;     /*상품코드        */
	private String vendorid           ;      /*공급사코드      */
	private String good_name          ;      /*상품명          */
	private double sale_unit_pric     ;      /*매입단가        */
	
	private String good_spec_desc	    ;  // 규격
	private String good_spec_desc1	    ;  // 규격1
	private String good_spec_desc2	    ;  // 규격2
	private String good_spec_desc3	    ;  // 규격3
	private String good_spec_desc4	    ;  // 규격4
	private String good_spec_desc5	    ;  // 규격5
	private String good_spec_desc6	    ;  // 규격6
	private String good_spec_desc7	    ;  // 규격7
	private String good_spec_desc8	    ;  // 규격8
	
	private String good_st_spec_desc	;  // 표준규격
	private String good_st_spec_desc1	;  // 표준규격1
	private String good_st_spec_desc2	;  // 표준규격2
	private String good_st_spec_desc3	;  // 표준규격3
	private String good_st_spec_desc4	;  // 표준규격4
	private String good_st_spec_desc5	;  // 표준규격5
	private String good_st_spec_desc6	;  // 표준규격6
	
	private String orde_clas_code     ;      /*단위            */
	private String deli_mini_day      ;      /*납품소요일수    */
	private String deli_mini_quan     ;      /*최소구매수량    */
	private String make_comp_name     ;      /*제조사          */
	private String good_same_word     ;      /*동의어          */
	private String original_img_path  ;      /*대표이미지원본  */
	private String large_img_path     ;      /*대표이미지대    */
	private String middle_img_path    ;      /*대표이미지중    */
	private String small_img_path     ;      /*대표이미지소    */
	private String good_desc          ;      /*상품설명        */
	private String good_clas_code     ;      /*상품구분        */
	private double good_inventory_cnt ;      /*재고수량        */
	private String insert_user_id     ;      /*등록자ID   */
	private String inser_user_nm      ;      /*등록자 명       */
	private String insert_date        ;      /*등록일          */
	private String app_sts            ;      /*처리상태        */
	private String admin_user_id      ;      /*담당운영자ID*/
	private String admin_user_nm      ;      /* 담당운영자 명  */
	private String app_user_id        ;      /*확인자ID   */
	private String app_user_nm        ;      /*확인자 명      */
	private String app_date           ;      /*확인일          */
	private String create_good_date   ;      /*품목등록일      */
	private String vendornm           ;      /*공급사명 */     
	private String vendorcd           ;      /*공급사코드 */   
	private String areatype           ;      /*공급사권역 */   
	private String pressentnm         ;      /*대표자명 */     
	private String phonenum           ;      /*공급사연락처 */ 
	
    private String org_req_good_id       ;
    private String org_good_iden_numb    ;
    private String org_vendorid          ;
    private String org_good_name         ;
    private String org_sale_unit_pric    ;
    private String org_good_st_spec_desc ;
    private String org_good_spec_desc    ;
    private String org_orde_clas_code    ;
    private String org_deli_mini_day     ;
    private String org_deli_mini_quan    ;
    private String org_make_comp_name    ;
    private String org_good_same_word    ;
    private String org_original_img_path ;
    private String org_large_img_path    ;
    private String org_middle_img_path   ;
    private String org_small_img_path    ;
    private String org_good_desc         ;
    private String org_good_clas_code    ;
    private String org_good_inventory_cnt;
    private String org_insert_user_id    ;
    private String org_inser_user_nm     ;
    private String org_insert_date       ;
    private String org_app_sts           ;
    private String org_admin_user_id     ;
    private String org_admin_user_nm     ;
    private String org_app_user_id       ;
    private String org_app_user_nm       ;
    private String org_app_date          ;
    private String org_create_good_date  ;
    
    private String cancel_reason;
    
    private String spec_spec;
	private String spec_pi;
	private String spec_width;
	private String spec_deep;
	private String spec_height;
	private String spec_liter;
	private String spec_ton;
	private String spec_meter;
	private String spec_material;
	private String spec_size;
	private String spec_weight_sum;
	private String spec_color;
	private String spec_type;
	private String spec_weight_real;
	
    private String org_spec_spec;
	private String org_spec_pi;
	private String org_spec_width;
	private String org_spec_deep;
	private String org_spec_height;
	private String org_spec_liter;
	private String org_spec_ton;
	private String org_spec_meter;
	private String org_spec_material;
	private String org_spec_size;
	private String org_spec_weight_sum;
	private String org_spec_color;
	private String org_spec_type;
	private String org_spec_weight_real;
    
	public String getCancel_reason() {
		return cancel_reason;
	}
	public void setCancel_reason(String cancel_reason) {
		this.cancel_reason = cancel_reason;
	}
	public String getOrg_req_good_id() {
		return org_req_good_id;
	}
	public void setOrg_req_good_id(String org_req_good_id) {
		this.org_req_good_id = org_req_good_id;
	}
	public String getOrg_good_iden_numb() {
		return org_good_iden_numb;
	}
	public void setOrg_good_iden_numb(String org_good_iden_numb) {
		this.org_good_iden_numb = org_good_iden_numb;
	}
	public String getOrg_vendorid() {
		return org_vendorid;
	}
	public void setOrg_vendorid(String org_vendorid) {
		this.org_vendorid = org_vendorid;
	}
	public String getOrg_good_name() {
		return org_good_name;
	}
	public void setOrg_good_name(String org_good_name) {
		this.org_good_name = org_good_name;
	}
	public String getOrg_sale_unit_pric() {
		return org_sale_unit_pric;
	}
	public void setOrg_sale_unit_pric(String org_sale_unit_pric) {
		this.org_sale_unit_pric = org_sale_unit_pric;
	}
	public String getOrg_good_st_spec_desc() {
		return org_good_st_spec_desc;
	}
	public void setOrg_good_st_spec_desc(String org_good_st_spec_desc) {
		this.org_good_st_spec_desc = org_good_st_spec_desc;
	}
	public String getOrg_good_spec_desc() {
		return org_good_spec_desc;
	}
	public void setOrg_good_spec_desc(String org_good_spec_desc) {
		this.org_good_spec_desc = org_good_spec_desc;
	}
	public String getOrg_orde_clas_code() {
		return org_orde_clas_code;
	}
	public void setOrg_orde_clas_code(String org_orde_clas_code) {
		this.org_orde_clas_code = org_orde_clas_code;
	}
	public String getOrg_deli_mini_day() {
		return org_deli_mini_day;
	}
	public void setOrg_deli_mini_day(String org_deli_mini_day) {
		this.org_deli_mini_day = org_deli_mini_day;
	}
	public String getOrg_deli_mini_quan() {
		return org_deli_mini_quan;
	}
	public void setOrg_deli_mini_quan(String org_deli_mini_quan) {
		this.org_deli_mini_quan = org_deli_mini_quan;
	}
	public String getOrg_make_comp_name() {
		return org_make_comp_name;
	}
	public void setOrg_make_comp_name(String org_make_comp_name) {
		this.org_make_comp_name = org_make_comp_name;
	}
	public String getOrg_good_same_word() {
		return org_good_same_word;
	}
	public void setOrg_good_same_word(String org_good_same_word) {
		this.org_good_same_word = org_good_same_word;
	}
	public String getOrg_original_img_path() {
		return org_original_img_path;
	}
	public void setOrg_original_img_path(String org_original_img_path) {
		this.org_original_img_path = org_original_img_path;
	}
	public String getOrg_large_img_path() {
		return org_large_img_path;
	}
	public void setOrg_large_img_path(String org_large_img_path) {
		this.org_large_img_path = org_large_img_path;
	}
	public String getOrg_middle_img_path() {
		return org_middle_img_path;
	}
	public void setOrg_middle_img_path(String org_middle_img_path) {
		this.org_middle_img_path = org_middle_img_path;
	}
	public String getOrg_small_img_path() {
		return org_small_img_path;
	}
	public void setOrg_small_img_path(String org_small_img_path) {
		this.org_small_img_path = org_small_img_path;
	}
	public String getOrg_good_desc() {
		return org_good_desc;
	}
	public void setOrg_good_desc(String org_good_desc) {
		this.org_good_desc = org_good_desc;
	}
	public String getOrg_good_clas_code() {
		return org_good_clas_code;
	}
	public void setOrg_good_clas_code(String org_good_clas_code) {
		this.org_good_clas_code = org_good_clas_code;
	}
	public String getOrg_good_inventory_cnt() {
		return org_good_inventory_cnt;
	}
	public void setOrg_good_inventory_cnt(String org_good_inventory_cnt) {
		this.org_good_inventory_cnt = org_good_inventory_cnt;
	}
	public String getOrg_insert_user_id() {
		return org_insert_user_id;
	}
	public void setOrg_insert_user_id(String org_insert_user_id) {
		this.org_insert_user_id = org_insert_user_id;
	}
	public String getOrg_inser_user_nm() {
		return org_inser_user_nm;
	}
	public void setOrg_inser_user_nm(String org_inser_user_nm) {
		this.org_inser_user_nm = org_inser_user_nm;
	}
	public String getOrg_insert_date() {
		return org_insert_date;
	}
	public void setOrg_insert_date(String org_insert_date) {
		this.org_insert_date = org_insert_date;
	}
	public String getOrg_app_sts() {
		return org_app_sts;
	}
	public void setOrg_app_sts(String org_app_sts) {
		this.org_app_sts = org_app_sts;
	}
	public String getOrg_admin_user_id() {
		return org_admin_user_id;
	}
	public void setOrg_admin_user_id(String org_admin_user_id) {
		this.org_admin_user_id = org_admin_user_id;
	}
	public String getOrg_admin_user_nm() {
		return org_admin_user_nm;
	}
	public void setOrg_admin_user_nm(String org_admin_user_nm) {
		this.org_admin_user_nm = org_admin_user_nm;
	}
	public String getOrg_app_user_id() {
		return org_app_user_id;
	}
	public void setOrg_app_user_id(String org_app_user_id) {
		this.org_app_user_id = org_app_user_id;
	}
	public String getOrg_app_user_nm() {
		return org_app_user_nm;
	}
	public void setOrg_app_user_nm(String org_app_user_nm) {
		this.org_app_user_nm = org_app_user_nm;
	}
	public String getOrg_app_date() {
		return org_app_date;
	}
	public void setOrg_app_date(String org_app_date) {
		this.org_app_date = org_app_date;
	}
	public String getOrg_create_good_date() {
		return org_create_good_date;
	}
	public void setOrg_create_good_date(String org_create_good_date) {
		this.org_create_good_date = org_create_good_date;
	}
	public String getReq_good_id() {
		return req_good_id;
	}
	public void setReq_good_id(String req_good_id) {
		this.req_good_id = req_good_id;
	}
	public String getGood_iden_numb() {
		return good_iden_numb;
	}
	public void setGood_iden_numb(String good_iden_numb) {
		this.good_iden_numb = good_iden_numb;
	}
	public String getVendorid() {
		return vendorid;
	}
	public void setVendorid(String vendorid) {
		this.vendorid = vendorid;
	}
	public String getGood_name() {
		return good_name;
	}
	public void setGood_name(String good_name) {
		this.good_name = good_name;
	}
	public double getSale_unit_pric() {
		return sale_unit_pric;
	}
	public void setSale_unit_pric(double sale_unit_pric) {
		this.sale_unit_pric = sale_unit_pric;
	}
	public String getGood_spec_desc() {
		return good_spec_desc;
	}
	public void setGood_spec_desc(String good_spec_desc) {
		this.good_spec_desc = good_spec_desc;
	}
	public String getOrde_clas_code() {
		return orde_clas_code;
	}
	public void setOrde_clas_code(String orde_clas_code) {
		this.orde_clas_code = orde_clas_code;
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
	public String getMake_comp_name() {
		return make_comp_name;
	}
	public void setMake_comp_name(String make_comp_name) {
		this.make_comp_name = make_comp_name;
	}
	public String getGood_same_word() {
		return good_same_word;
	}
	public void setGood_same_word(String good_same_word) {
		this.good_same_word = good_same_word;
	}
	public String getOriginal_img_path() {
		return original_img_path;
	}
	public void setOriginal_img_path(String original_img_path) {
		this.original_img_path = original_img_path;
	}
	public String getLarge_img_path() {
		return large_img_path;
	}
	public void setLarge_img_path(String large_img_path) {
		this.large_img_path = large_img_path;
	}
	public String getMiddle_img_path() {
		return middle_img_path;
	}
	public void setMiddle_img_path(String middle_img_path) {
		this.middle_img_path = middle_img_path;
	}
	public String getSmall_img_path() {
		return small_img_path;
	}
	public void setSmall_img_path(String small_img_path) {
		this.small_img_path = small_img_path;
	}
	public String getGood_desc() {
		return good_desc;
	}
	public void setGood_desc(String good_desc) {
		this.good_desc = good_desc;
	}
	public String getGood_clas_code() {
		return good_clas_code;
	}
	public void setGood_clas_code(String good_clas_code) {
		this.good_clas_code = good_clas_code;
	}
	public double getGood_inventory_cnt() {
		return good_inventory_cnt;
	}
	public void setGood_inventory_cnt(double good_inventory_cnt) {
		this.good_inventory_cnt = good_inventory_cnt;
	}
	public String getInsert_user_id() {
		return insert_user_id;
	}
	public void setInsert_user_id(String insert_user_id) {
		this.insert_user_id = insert_user_id;
	}
	public String getInser_user_nm() {
		return inser_user_nm;
	}
	public void setInser_user_nm(String inser_user_nm) {
		this.inser_user_nm = inser_user_nm;
	}
	public String getInsert_date() {
		return insert_date;
	}
	public void setInsert_date(String insert_date) {
		this.insert_date = insert_date;
	}
	public String getApp_sts() {
		return app_sts;
	}
	public void setApp_sts(String app_sts) {
		this.app_sts = app_sts;
	}
	public String getAdmin_user_id() {
		return admin_user_id;
	}
	public void setAdmin_user_id(String admin_user_id) {
		this.admin_user_id = admin_user_id;
	}
	public String getAdmin_user_nm() {
		return admin_user_nm;
	}
	public void setAdmin_user_nm(String admin_user_nm) {
		this.admin_user_nm = admin_user_nm;
	}
	public String getApp_user_id() {
		return app_user_id;
	}
	public void setApp_user_id(String app_user_id) {
		this.app_user_id = app_user_id;
	}
	public String getApp_user_nm() {
		return app_user_nm;
	}
	public void setApp_user_nm(String app_user_nm) {
		this.app_user_nm = app_user_nm;
	}
	public String getApp_date() {
		return app_date;
	}
	public void setApp_date(String app_date) {
		this.app_date = app_date;
	}
	public String getCreate_good_date() {
		return create_good_date;
	}
	public void setCreate_good_date(String create_good_date) {
		this.create_good_date = create_good_date;
	}
	public String getVendornm() {
		return vendornm;
	}
	public void setVendornm(String vendornm) {
		this.vendornm = vendornm;
	}
	public String getVendorcd() {
		return vendorcd;
	}
	public void setVendorcd(String vendorcd) {
		this.vendorcd = vendorcd;
	}
	public String getAreatype() {
		return areatype;
	}
	public void setAreatype(String areatype) {
		this.areatype = areatype;
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
	public String getGood_spec_desc1() {
		return good_spec_desc1;
	}
	public void setGood_spec_desc1(String good_spec_desc1) {
		this.good_spec_desc1 = good_spec_desc1;
	}
	public String getGood_spec_desc2() {
		return good_spec_desc2;
	}
	public void setGood_spec_desc2(String good_spec_desc2) {
		this.good_spec_desc2 = good_spec_desc2;
	}
	public String getGood_spec_desc3() {
		return good_spec_desc3;
	}
	public void setGood_spec_desc3(String good_spec_desc3) {
		this.good_spec_desc3 = good_spec_desc3;
	}
	public String getGood_spec_desc4() {
		return good_spec_desc4;
	}
	public void setGood_spec_desc4(String good_spec_desc4) {
		this.good_spec_desc4 = good_spec_desc4;
	}
	public String getGood_spec_desc5() {
		return good_spec_desc5;
	}
	public void setGood_spec_desc5(String good_spec_desc5) {
		this.good_spec_desc5 = good_spec_desc5;
	}
	public String getGood_spec_desc6() {
		return good_spec_desc6;
	}
	public void setGood_spec_desc6(String good_spec_desc6) {
		this.good_spec_desc6 = good_spec_desc6;
	}
	public String getGood_spec_desc7() {
		return good_spec_desc7;
	}
	public void setGood_spec_desc7(String good_spec_desc7) {
		this.good_spec_desc7 = good_spec_desc7;
	}
	public String getGood_spec_desc8() {
		return good_spec_desc8;
	}
	public void setGood_spec_desc8(String good_spec_desc8) {
		this.good_spec_desc8 = good_spec_desc8;
	}
	public String getGood_st_spec_desc() {
		return good_st_spec_desc;
	}
	public void setGood_st_spec_desc(String good_st_spec_desc) {
		this.good_st_spec_desc = good_st_spec_desc;
	}
	public String getGood_st_spec_desc1() {
		return good_st_spec_desc1;
	}
	public void setGood_st_spec_desc1(String good_st_spec_desc1) {
		this.good_st_spec_desc1 = good_st_spec_desc1;
	}
	public String getGood_st_spec_desc2() {
		return good_st_spec_desc2;
	}
	public void setGood_st_spec_desc2(String good_st_spec_desc2) {
		this.good_st_spec_desc2 = good_st_spec_desc2;
	}
	public String getGood_st_spec_desc3() {
		return good_st_spec_desc3;
	}
	public void setGood_st_spec_desc3(String good_st_spec_desc3) {
		this.good_st_spec_desc3 = good_st_spec_desc3;
	}
	public String getGood_st_spec_desc4() {
		return good_st_spec_desc4;
	}
	public void setGood_st_spec_desc4(String good_st_spec_desc4) {
		this.good_st_spec_desc4 = good_st_spec_desc4;
	}
	public String getGood_st_spec_desc5() {
		return good_st_spec_desc5;
	}
	public void setGood_st_spec_desc5(String good_st_spec_desc5) {
		this.good_st_spec_desc5 = good_st_spec_desc5;
	}
	public String getGood_st_spec_desc6() {
		return good_st_spec_desc6;
	}
	public void setGood_st_spec_desc6(String good_st_spec_desc6) {
		this.good_st_spec_desc6 = good_st_spec_desc6;
	}
	public String getSpec_spec() {
		return spec_spec;
	}
	public void setSpec_spec(String spec_spec) {
		this.spec_spec = spec_spec;
	}
	public String getSpec_pi() {
		return spec_pi;
	}
	public void setSpec_pi(String spec_pi) {
		this.spec_pi = spec_pi;
	}
	public String getSpec_width() {
		return spec_width;
	}
	public void setSpec_width(String spec_width) {
		this.spec_width = spec_width;
	}
	public String getSpec_deep() {
		return spec_deep;
	}
	public void setSpec_deep(String spec_deep) {
		this.spec_deep = spec_deep;
	}
	public String getSpec_height() {
		return spec_height;
	}
	public void setSpec_height(String spec_height) {
		this.spec_height = spec_height;
	}
	public String getSpec_liter() {
		return spec_liter;
	}
	public void setSpec_liter(String spec_liter) {
		this.spec_liter = spec_liter;
	}
	public String getSpec_ton() {
		return spec_ton;
	}
	public void setSpec_ton(String spec_ton) {
		this.spec_ton = spec_ton;
	}
	public String getSpec_meter() {
		return spec_meter;
	}
	public void setSpec_meter(String spec_meter) {
		this.spec_meter = spec_meter;
	}
	public String getSpec_material() {
		return spec_material;
	}
	public void setSpec_material(String spec_material) {
		this.spec_material = spec_material;
	}
	public String getSpec_size() {
		return spec_size;
	}
	public void setSpec_size(String spec_size) {
		this.spec_size = spec_size;
	}
	public String getSpec_weight_sum() {
		return spec_weight_sum;
	}
	public void setSpec_weight_sum(String spec_weight_sum) {
		this.spec_weight_sum = spec_weight_sum;
	}
	public String getSpec_color() {
		return spec_color;
	}
	public void setSpec_color(String spec_color) {
		this.spec_color = spec_color;
	}
	public String getSpec_type() {
		return spec_type;
	}
	public void setSpec_type(String spec_type) {
		this.spec_type = spec_type;
	}
	public String getSpec_weight_real() {
		return spec_weight_real;
	}
	public void setSpec_weight_real(String spec_weight_real) {
		this.spec_weight_real = spec_weight_real;
	}
	public String getOrg_spec_spec() {
		return org_spec_spec;
	}
	public void setOrg_spec_spec(String org_spec_spec) {
		this.org_spec_spec = org_spec_spec;
	}
	public String getOrg_spec_pi() {
		return org_spec_pi;
	}
	public void setOrg_spec_pi(String org_spec_pi) {
		this.org_spec_pi = org_spec_pi;
	}
	public String getOrg_spec_width() {
		return org_spec_width;
	}
	public void setOrg_spec_width(String org_spec_width) {
		this.org_spec_width = org_spec_width;
	}
	public String getOrg_spec_deep() {
		return org_spec_deep;
	}
	public void setOrg_spec_deep(String org_spec_deep) {
		this.org_spec_deep = org_spec_deep;
	}
	public String getOrg_spec_height() {
		return org_spec_height;
	}
	public void setOrg_spec_height(String org_spec_height) {
		this.org_spec_height = org_spec_height;
	}
	public String getOrg_spec_liter() {
		return org_spec_liter;
	}
	public void setOrg_spec_liter(String org_spec_liter) {
		this.org_spec_liter = org_spec_liter;
	}
	public String getOrg_spec_ton() {
		return org_spec_ton;
	}
	public void setOrg_spec_ton(String org_spec_ton) {
		this.org_spec_ton = org_spec_ton;
	}
	public String getOrg_spec_meter() {
		return org_spec_meter;
	}
	public void setOrg_spec_meter(String org_spec_meter) {
		this.org_spec_meter = org_spec_meter;
	}
	public String getOrg_spec_material() {
		return org_spec_material;
	}
	public void setOrg_spec_material(String org_spec_material) {
		this.org_spec_material = org_spec_material;
	}
	public String getOrg_spec_size() {
		return org_spec_size;
	}
	public void setOrg_spec_size(String org_spec_size) {
		this.org_spec_size = org_spec_size;
	}
	public String getOrg_spec_weight_sum() {
		return org_spec_weight_sum;
	}
	public void setOrg_spec_weight_sum(String org_spec_weight_sum) {
		this.org_spec_weight_sum = org_spec_weight_sum;
	}
	public String getOrg_spec_color() {
		return org_spec_color;
	}
	public void setOrg_spec_color(String org_spec_color) {
		this.org_spec_color = org_spec_color;
	}
	public String getOrg_spec_type() {
		return org_spec_type;
	}
	public void setOrg_spec_type(String org_spec_type) {
		this.org_spec_type = org_spec_type;
	}
	public String getOrg_spec_weight_real() {
		return org_spec_weight_real;
	}
	public void setOrg_spec_weight_real(String org_spec_weight_real) {
		this.org_spec_weight_real = org_spec_weight_real;
	}
	
		
}
