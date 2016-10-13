package kr.co.bitcube.product.dto;

public class ProductVendorDto {
	private String isModify; 
	private String good_iden_numb, orggood_iden_numb	    ;  // 상품코드
	private String good_name            ;  // 상품명 
	private String vendorid, orgvendorid      	    ;  // 공급사ID
	private String vendornm, orgvendornm             ;  // 공급사명
	private String vendorcd, orgvendorcd             ;  // 공급사코드
	private String areatype, orgareatype             ;  // 권역 
	private String pressentnm, orgpressentnm           ;  // 대표자명
	private String phonenum, orgphonenum             ;  // 대표연락처 
	private String req_good_id, orgreq_good_id     	  	;  // 상품등록요청SEQ
	private long   sale_unit_pric, orgsale_unit_pric	    ;  // 매입단가
	private String good_spec_desc, orggood_spec_desc	    ;  // 규격
	private String good_spec_desc1, orggood_spec_desc1	    ;  // 규격1
	private String good_spec_desc2, orggood_spec_desc2	    ;  // 규격2
	private String good_spec_desc3, orggood_spec_desc3	    ;  // 규격3
	private String good_spec_desc4, orggood_spec_desc4	    ;  // 규격4
	private String good_spec_desc5, orggood_spec_desc5	    ;  // 규격5
	private String good_spec_desc6, orggood_spec_desc6	    ;  // 규격6
	private String good_spec_desc7, orggood_spec_desc7	    ;  // 규격7
	private String good_spec_desc8, orggood_spec_desc8	    ;  // 규격8
	
	private String good_st_spec_desc, orggood_st_spec_desc	;  // 표준규격
	private String good_st_spec_desc1, orggood_st_spec_desc1	;  // 표준규격1
	private String good_st_spec_desc2, orggood_st_spec_desc2	;  // 표준규격2
	private String good_st_spec_desc3, orggood_st_spec_desc3	;  // 표준규격3
	private String good_st_spec_desc4, orggood_st_spec_desc4	;  // 표준규격4
	private String good_st_spec_desc5, orggood_st_spec_desc5	;  // 표준규격5
	private String good_st_spec_desc6, orggood_st_spec_desc6	;  // 표준규격6
	
	private String orde_clas_code, orgorde_clas_code	    ;  // 단위
	private String deli_mini_day, orgdeli_mini_day	    ;  // 납품소요일수
	private String deli_mini_quan, orgdeli_mini_quan	    ;  // 최소구매수량
	private String make_comp_name, orgmake_comp_name	    ;  // 제조사
	private String isexistimg, orgisexistimg           ;  // 이미지 등록여부
	private String original_img_path, orgoriginal_img_path	;  // 대표이미지원본
	private String large_img_path, orglarge_img_path	    ;  // 대표이미지대
	private String middle_img_path, orgmiddle_img_path	  	;  // 대표이미지중
	private String small_img_path, orgsmall_img_path	    ;  // 대표이미지소
	private String good_same_word, orggood_same_word	    ;  // 동의어
	private String good_same_word1, orggood_same_word1	    ;  // 동의어1
	private String good_same_word2, orggood_same_word2	    ;  // 동의어2
	private String good_same_word3, orggood_same_word3	    ;  // 동의어3
	private String good_same_word4, orggood_same_word4	    ;  // 동의어4
	private String good_same_word5, orggood_same_word5	    ;  // 동의어5
	private String isexistgooddesc, orgisexistgooddesc      ;  // 상품설명 등록여부 
	private String good_desc, orggood_desc	        ;  // 상품설명
	private String issub_ontract, orgissub_ontract	    ;  // 하도급법대상여부
	private String good_clas_code, orggood_clas_code	    ;  // 상품구분
	private String good_inventory_cnt, orggood_inventory_cnt	;  // 재고수량
	private String regist_date, orgregist_date	      	;  // 등록일
	private String isUse, orgisUse                ;  // 종료여부
	private String bidid, orgbidid                ;  // 입찰 id
	private String bid_vendorid, orgbid_vendorid         ;  // 입찰 공급사id 
	private String full_cate_name       ;  // 카테고리명 

	private String isfixappexists       ;  // 공급사 변경에 따른 승인 존재여부 Y N 
	private String ischangepriceexists  ;  // 공급사 단가 변경 요청 승인 존재여부 Y N
	private String ischangesoldoutexists;  // 공급사 종료 승인 존재여부 Y N 
	
	private String prodvendorappflag, orgprodvendorappflag    ;  // 공급사 매입단가 변경및 종료 요청 승인 여부  
	private String chageproductrequest, orgchageproductrequest  ;  // 공급사 변경 요청 여부 
	private String distri_rate, orgdistri_rate          ;  // 물량 배분 %
	
	private String good_reg_year;
	
	private String vendor_priority; //상품우선순위
	
	private String the_day_post; //당일발송
	
	
	
	public String getThe_day_post() {
		return the_day_post;
	}
	public void setThe_day_post(String the_day_post) {
		this.the_day_post = the_day_post;
	}
	public String getVendor_priority() {
		return vendor_priority;
	}
	public void setVendor_priority(String vendor_priority) {
		this.vendor_priority = vendor_priority;
	}
	public String getGood_reg_year() {
		return good_reg_year;
	}
	public void setGood_reg_year(String good_reg_year) {
		this.good_reg_year = good_reg_year;
	}
	public String getOrggood_iden_numb() {
		return orggood_iden_numb;
	}
	public void setOrggood_iden_numb(String orggood_iden_numb) {
		this.orggood_iden_numb = orggood_iden_numb;
	}
	public String getOrgvendorid() {
		return orgvendorid;
	}
	public void setOrgvendorid(String orgvendorid) {
		this.orgvendorid = orgvendorid;
	}
	public String getOrgvendornm() {
		return orgvendornm;
	}
	public void setOrgvendornm(String orgvendornm) {
		this.orgvendornm = orgvendornm;
	}
	public String getOrgvendorcd() {
		return orgvendorcd;
	}
	public void setOrgvendorcd(String orgvendorcd) {
		this.orgvendorcd = orgvendorcd;
	}
	public String getOrgareatype() {
		return orgareatype;
	}
	public void setOrgareatype(String orgareatype) {
		this.orgareatype = orgareatype;
	}
	public String getOrgpressentnm() {
		return orgpressentnm;
	}
	public void setOrgpressentnm(String orgpressentnm) {
		this.orgpressentnm = orgpressentnm;
	}
	public String getOrgphonenum() {
		return orgphonenum;
	}
	public void setOrgphonenum(String orgphonenum) {
		this.orgphonenum = orgphonenum;
	}
	public String getOrgreq_good_id() {
		return orgreq_good_id;
	}
	public void setOrgreq_good_id(String orgreq_good_id) {
		this.orgreq_good_id = orgreq_good_id;
	}
	public long getOrgsale_unit_pric() {
		return orgsale_unit_pric;
	}
	public void setOrgsale_unit_pric(long orgsale_unit_pric) {
		this.orgsale_unit_pric = orgsale_unit_pric;
	}
	public String getOrggood_spec_desc() {
		return orggood_spec_desc;
	}
	public void setOrggood_spec_desc(String orggood_spec_desc) {
		this.orggood_spec_desc = orggood_spec_desc;
	}
	public String getOrggood_spec_desc1() {
		return orggood_spec_desc1;
	}
	public void setOrggood_spec_desc1(String orggood_spec_desc1) {
		this.orggood_spec_desc1 = orggood_spec_desc1;
	}
	public String getOrggood_spec_desc2() {
		return orggood_spec_desc2;
	}
	public void setOrggood_spec_desc2(String orggood_spec_desc2) {
		this.orggood_spec_desc2 = orggood_spec_desc2;
	}
	public String getOrggood_spec_desc3() {
		return orggood_spec_desc3;
	}
	public void setOrggood_spec_desc3(String orggood_spec_desc3) {
		this.orggood_spec_desc3 = orggood_spec_desc3;
	}
	public String getOrggood_spec_desc4() {
		return orggood_spec_desc4;
	}
	public void setOrggood_spec_desc4(String orggood_spec_desc4) {
		this.orggood_spec_desc4 = orggood_spec_desc4;
	}
	public String getOrggood_spec_desc5() {
		return orggood_spec_desc5;
	}
	public void setOrggood_spec_desc5(String orggood_spec_desc5) {
		this.orggood_spec_desc5 = orggood_spec_desc5;
	}
	public String getOrggood_spec_desc6() {
		return orggood_spec_desc6;
	}
	public void setOrggood_spec_desc6(String orggood_spec_desc6) {
		this.orggood_spec_desc6 = orggood_spec_desc6;
	}
	public String getOrggood_spec_desc7() {
		return orggood_spec_desc7;
	}
	public void setOrggood_spec_desc7(String orggood_spec_desc7) {
		this.orggood_spec_desc7 = orggood_spec_desc7;
	}
	public String getOrggood_spec_desc8() {
		return orggood_spec_desc8;
	}
	public void setOrggood_spec_desc8(String orggood_spec_desc8) {
		this.orggood_spec_desc8 = orggood_spec_desc8;
	}
	public String getOrggood_st_spec_desc() {
		return orggood_st_spec_desc;
	}
	public void setOrggood_st_spec_desc(String orggood_st_spec_desc) {
		this.orggood_st_spec_desc = orggood_st_spec_desc;
	}
	public String getOrggood_st_spec_desc1() {
		return orggood_st_spec_desc1;
	}
	public void setOrggood_st_spec_desc1(String orggood_st_spec_desc1) {
		this.orggood_st_spec_desc1 = orggood_st_spec_desc1;
	}
	public String getOrggood_st_spec_desc2() {
		return orggood_st_spec_desc2;
	}
	public void setOrggood_st_spec_desc2(String orggood_st_spec_desc2) {
		this.orggood_st_spec_desc2 = orggood_st_spec_desc2;
	}
	public String getOrggood_st_spec_desc3() {
		return orggood_st_spec_desc3;
	}
	public void setOrggood_st_spec_desc3(String orggood_st_spec_desc3) {
		this.orggood_st_spec_desc3 = orggood_st_spec_desc3;
	}
	public String getOrggood_st_spec_desc4() {
		return orggood_st_spec_desc4;
	}
	public void setOrggood_st_spec_desc4(String orggood_st_spec_desc4) {
		this.orggood_st_spec_desc4 = orggood_st_spec_desc4;
	}
	public String getOrggood_st_spec_desc5() {
		return orggood_st_spec_desc5;
	}
	public void setOrggood_st_spec_desc5(String orggood_st_spec_desc5) {
		this.orggood_st_spec_desc5 = orggood_st_spec_desc5;
	}
	public String getOrggood_st_spec_desc6() {
		return orggood_st_spec_desc6;
	}
	public void setOrggood_st_spec_desc6(String orggood_st_spec_desc6) {
		this.orggood_st_spec_desc6 = orggood_st_spec_desc6;
	}
	public String getOrgorde_clas_code() {
		return orgorde_clas_code;
	}
	public void setOrgorde_clas_code(String orgorde_clas_code) {
		this.orgorde_clas_code = orgorde_clas_code;
	}
	public String getOrgdeli_mini_day() {
		return orgdeli_mini_day;
	}
	public void setOrgdeli_mini_day(String orgdeli_mini_day) {
		this.orgdeli_mini_day = orgdeli_mini_day;
	}
	public String getOrgdeli_mini_quan() {
		return orgdeli_mini_quan;
	}
	public void setOrgdeli_mini_quan(String orgdeli_mini_quan) {
		this.orgdeli_mini_quan = orgdeli_mini_quan;
	}
	public String getOrgmake_comp_name() {
		return orgmake_comp_name;
	}
	public void setOrgmake_comp_name(String orgmake_comp_name) {
		this.orgmake_comp_name = orgmake_comp_name;
	}
	public String getOrgisexistimg() {
		return orgisexistimg;
	}
	public void setOrgisexistimg(String orgisexistimg) {
		this.orgisexistimg = orgisexistimg;
	}
	public String getOrgoriginal_img_path() {
		return orgoriginal_img_path;
	}
	public void setOrgoriginal_img_path(String orgoriginal_img_path) {
		this.orgoriginal_img_path = orgoriginal_img_path;
	}
	public String getOrglarge_img_path() {
		return orglarge_img_path;
	}
	public void setOrglarge_img_path(String orglarge_img_path) {
		this.orglarge_img_path = orglarge_img_path;
	}
	public String getOrgmiddle_img_path() {
		return orgmiddle_img_path;
	}
	public void setOrgmiddle_img_path(String orgmiddle_img_path) {
		this.orgmiddle_img_path = orgmiddle_img_path;
	}
	public String getOrgsmall_img_path() {
		return orgsmall_img_path;
	}
	public void setOrgsmall_img_path(String orgsmall_img_path) {
		this.orgsmall_img_path = orgsmall_img_path;
	}
	public String getOrggood_same_word() {
		return orggood_same_word;
	}
	public void setOrggood_same_word(String orggood_same_word) {
		this.orggood_same_word = orggood_same_word;
	}
	public String getOrggood_same_word1() {
		return orggood_same_word1;
	}
	public void setOrggood_same_word1(String orggood_same_word1) {
		this.orggood_same_word1 = orggood_same_word1;
	}
	public String getOrggood_same_word2() {
		return orggood_same_word2;
	}
	public void setOrggood_same_word2(String orggood_same_word2) {
		this.orggood_same_word2 = orggood_same_word2;
	}
	public String getOrggood_same_word3() {
		return orggood_same_word3;
	}
	public void setOrggood_same_word3(String orggood_same_word3) {
		this.orggood_same_word3 = orggood_same_word3;
	}
	public String getOrggood_same_word4() {
		return orggood_same_word4;
	}
	public void setOrggood_same_word4(String orggood_same_word4) {
		this.orggood_same_word4 = orggood_same_word4;
	}
	public String getOrggood_same_word5() {
		return orggood_same_word5;
	}
	public void setOrggood_same_word5(String orggood_same_word5) {
		this.orggood_same_word5 = orggood_same_word5;
	}
	public String getOrgisexistgooddesc() {
		return orgisexistgooddesc;
	}
	public void setOrgisexistgooddesc(String orgisexistgooddesc) {
		this.orgisexistgooddesc = orgisexistgooddesc;
	}
	public String getOrggood_desc() {
		return orggood_desc;
	}
	public void setOrggood_desc(String orggood_desc) {
		this.orggood_desc = orggood_desc;
	}
	public String getOrgissub_ontract() {
		return orgissub_ontract;
	}
	public void setOrgissub_ontract(String orgissub_ontract) {
		this.orgissub_ontract = orgissub_ontract;
	}
	public String getOrggood_clas_code() {
		return orggood_clas_code;
	}
	public void setOrggood_clas_code(String orggood_clas_code) {
		this.orggood_clas_code = orggood_clas_code;
	}
	public String getOrggood_inventory_cnt() {
		return orggood_inventory_cnt;
	}
	public void setOrggood_inventory_cnt(String orggood_inventory_cnt) {
		this.orggood_inventory_cnt = orggood_inventory_cnt;
	}
	public String getOrgregist_date() {
		return orgregist_date;
	}
	public void setOrgregist_date(String orgregist_date) {
		this.orgregist_date = orgregist_date;
	}
	public String getOrgisUse() {
		return orgisUse;
	}
	public void setOrgisUse(String orgisUse) {
		this.orgisUse = orgisUse;
	}
	public String getOrgbidid() {
		return orgbidid;
	}
	public void setOrgbidid(String orgbidid) {
		this.orgbidid = orgbidid;
	}
	public String getOrgbid_vendorid() {
		return orgbid_vendorid;
	}
	public void setOrgbid_vendorid(String orgbid_vendorid) {
		this.orgbid_vendorid = orgbid_vendorid;
	}
	public String getOrgprodvendorappflag() {
		return orgprodvendorappflag;
	}
	public void setOrgprodvendorappflag(String orgprodvendorappflag) {
		this.orgprodvendorappflag = orgprodvendorappflag;
	}
	public String getOrgchageproductrequest() {
		return orgchageproductrequest;
	}
	public void setOrgchageproductrequest(String orgchageproductrequest) {
		this.orgchageproductrequest = orgchageproductrequest;
	}
	public String getOrgdistri_rate() {
		return orgdistri_rate;
	}
	public void setOrgdistri_rate(String orgdistri_rate) {
		this.orgdistri_rate = orgdistri_rate;
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
	public String getReq_good_id() {
		return req_good_id;
	}
	public void setReq_good_id(String req_good_id) {
		this.req_good_id = req_good_id;
	}
	public long getSale_unit_pric() {
		return sale_unit_pric;
	}
	public void setSale_unit_pric(long sale_unit_pric) {
		this.sale_unit_pric = sale_unit_pric;
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
	public String getGood_spec_desc() {
		return good_spec_desc;
	}
	public void setGood_spec_desc(String good_spec_desc) {
		this.good_spec_desc = good_spec_desc;
	}
	public String getVendorcd() {
		return vendorcd;
	}
	public void setVendorcd(String vendorcd) {
		this.vendorcd = vendorcd;
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
	public String getIsexistimg() {
		return isexistimg;
	}
	public void setIsexistimg(String isexistimg) {
		this.isexistimg = isexistimg;
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
	public String getGood_same_word() {
		return good_same_word;
	}
	public void setGood_same_word(String good_same_word) {
		this.good_same_word = good_same_word;
	}
	public String getGood_same_word1() {
		return good_same_word1;
	}
	public void setGood_same_word1(String good_same_word1) {
		this.good_same_word1 = good_same_word1;
	}
	public String getGood_same_word2() {
		return good_same_word2;
	}
	public void setGood_same_word2(String good_same_word2) {
		this.good_same_word2 = good_same_word2;
	}
	public String getGood_same_word3() {
		return good_same_word3;
	}
	public void setGood_same_word3(String good_same_word3) {
		this.good_same_word3 = good_same_word3;
	}
	public String getGood_same_word4() {
		return good_same_word4;
	}
	public void setGood_same_word4(String good_same_word4) {
		this.good_same_word4 = good_same_word4;
	}
	public String getGood_same_word5() {
		return good_same_word5;
	}
	public void setGood_same_word5(String good_same_word5) {
		this.good_same_word5 = good_same_word5;
	}
	public String getIsexistgooddesc() {
		return isexistgooddesc;
	}
	public void setIsexistgooddesc(String isexistgooddesc) {
		this.isexistgooddesc = isexistgooddesc;
	}
	public String getGood_desc() {
		return good_desc;
	}
	public void setGood_desc(String good_desc) {
		this.good_desc = good_desc;
	}
	public String getIssub_ontract() {
		return issub_ontract;
	}
	public void setIssub_ontract(String issub_ontract) {
		this.issub_ontract = issub_ontract;
	}
	public String getGood_clas_code() {
		return good_clas_code;
	}
	public void setGood_clas_code(String good_clas_code) {
		this.good_clas_code = good_clas_code;
	}
	public String getGood_inventory_cnt() {
		return good_inventory_cnt;
	}
	public void setGood_inventory_cnt(String good_inventory_cnt) {
		this.good_inventory_cnt = good_inventory_cnt;
	}
	public String getRegist_date() {
		return regist_date;
	}
	public void setRegist_date(String regist_date) {
		this.regist_date = regist_date;
	}
	public String getBidid() {
		return bidid;
	}
	public void setBidid(String bidid) {
		this.bidid = bidid;
	}
	public String getBid_vendorid() {
		return bid_vendorid;
	}
	public void setBid_vendorid(String bid_vendorid) {
		this.bid_vendorid = bid_vendorid;
	}
	public String getIsfixappexists() {
		return isfixappexists;
	}
	public void setIsfixappexists(String isfixappexists) {
		this.isfixappexists = isfixappexists;
	}
	public String getIschangepriceexists() {
		return ischangepriceexists;
	}
	public void setIschangepriceexists(String ischangepriceexists) {
		this.ischangepriceexists = ischangepriceexists;
	}
	public String getIschangesoldoutexists() {
		return ischangesoldoutexists;
	}
	public void setIschangesoldoutexists(String ischangesoldoutexists) {
		this.ischangesoldoutexists = ischangesoldoutexists;
	}
	public String getProdvendorappflag() {
		return prodvendorappflag;
	}
	public void setProdvendorappflag(String prodvendorappflag) {
		this.prodvendorappflag = prodvendorappflag;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getChageproductrequest() {
		return chageproductrequest;
	}
	public void setChageproductrequest(String chageproductrequest) {
		this.chageproductrequest = chageproductrequest;
	}
	public String getDistri_rate() {
		return distri_rate;
	}
	public void setDistri_rate(String distri_rate) {
		this.distri_rate = distri_rate;
	}
	public String getFull_cate_name() {
		return full_cate_name;
	}
	public void setFull_cate_name(String full_cate_name) {
		this.full_cate_name = full_cate_name;
	}
	public String getIsModify() {
		return isModify;
	}
	public void setIsModify(String isModify) {
		this.isModify = isModify;
	}
	
}
