package kr.co.bitcube.order.dto;

public class OrderDto {

	/* 
	 * 주문 리스트에서 사용하는 칼럼.
	 * 
	 * 주문번호 -- orde_iden_numb
	 * 주문유형 -- orde_type_clas
	 * 주문일자 -- regi_date_time
	 * 고객사   -- orde_client_name
	 * 공급사   -- vendor_name 
	 * 주문자   -- orde_user_name
	 * 공사명   -- cons_iden_name
	 * 주문상태-- order_status_flag
	 * 상품명   -- good_iden_name
	 * 판매단가-- sell_price
	 * 수량     -- orde_requ_quan
	 * 판매금액-- 수량 * 판매단가 total_sell_price
	 * 매입단가-- sale_unit_pric
	 * 매입금액-- 수량 * 매입단가 total_sale_price
	 * 납품요청일 -- requ_deli_date
	 * 긴급여부 -- emer_orde_clas
	 */
	private String orde_iden_numb;
	private String orde_type_clas;
	private String regi_date_time;
	private String orde_client_name;
	private String vendor_name;
	private String orde_user_name;
	private String cons_iden_name;
	private String order_status_flag;
	private String good_iden_numb;
	private String good_iden_name;
	private double sell_price;
	private String orde_requ_quan;
	private double sale_unit_pric;
	private double total_sell_price;
	private double total_sale_price;
	private String requ_deli_date;
	private String emer_orde_clas;
	
	/*
	 * 주문 상품에서 추가로 필요로 하는 칼럼.
	 * disp_good_id			진열 SEQ
	 * good_spec_desc		상품 규격
	 * good_clas_code		주문 상품 유형
	 * good_name			상품명
	 * deli_mini_day 		표준납기일 
	 * good_inventory_cnt  재고수량
	 * min_orde_requ_quan최소구매수량 
	 * orde_clas_code 단위
	 * good_spec			상품규격 (1차 고도화 20151211 sun)
	 */
	private String good_spec_desc;
	private String good_clas_code;
	private String good_name;
	private String deli_mini_day;
	private String disp_good_id;
	private String min_orde_requ_quan;
	private String good_inventory_cnt;
	private String orde_clas_code;
	private String vendorid;
	private String good_spec;
	
	/*
	 * 주문 상세에서 필요로 하는 칼럼
	 * pruc_requ_quan		발주수량
	 * orde_tele_numb		주문자 전화번호
	 * tran_user_name		인수자
	 * tran_tele_numb		인수자 전화번호
	 * tran_data_addr 		배송지 주소
	 * adde_text_desc		비고
	 * areatype 				권역
	 * order_purc 			주문수량-발주수량
	 */
	private String purc_requ_quan;
	private String orde_tele_numb;
	private String tran_user_name;
	private String tran_tele_numb;
	private String tran_data_addr;
	private String adde_text_desc;
	private String areatype;
	private String order_purc;
	private String attach_file_1;
	private String attach_file_2;
	private String attach_file_3;
	private String attach_file_name1;
	private String attach_file_name2;
	private String attach_file_name3;
	private String attach_file_path1;
	private String attach_file_path2;
	private String attach_file_path3;
	
	/*
	 * ORDER_REQUEST : 주문요청 상태
	 * PURT_REQUEST : 발주 의뢰 상태
	 * PURT_REQUEST_STOP : 발주의뢰 중지 상태
	 * PURT_RECEIVE : 발주 접수 상태
	 * PURT_RECEIVE_STOP : 발주접수 중지 상태
	 * DELIVERY_RDY : 출하준비중
	 * DELIVERY : 출하
	 * DELIVERY_STOP : 출하중지
	 * DELIVERY_RECEIVE : 인수 
	 * ORDER_CANCEL : 주문 취소
	 * ORDER_RETURN : 반품
	 */
	private String order_request;
	private String purt_request;
	private String purt_request_stop;
	private String purt_receive;
	private String purt_receive_req;
	private String purt_receive_stop;
	private String delivery_rdy;
	private String delivery;
	private String delivery_stop;
	private String delivery_receive;
	private String order_cancel;
	private String order_return;
	private String phonenum; // 공급사 전화번호
	
	// 실적 조회 
	private String purc_iden_numb;
	private String deli_iden_numb;
	private String rece_iden_numb;
	private String orde_user_id;
	private String branchnm;
	private String branchId;
	private String stat_flag;
	private String quantity;
	private String sum_quantity;
	private String orde_requ_pric;
	private String sale_sequ_numb;
	private String buyi_sequ_numb;
	private String usernm;
	private String stat_flag_name;
	private String orde_type_name;
	private String vendornm;
	private String total_orde_requ_pric;
	private String total_sale_unit_pric;
	
	
	private String approvedate;
	private String directorname;
	private String good_st_spec_desc;
	
	private String worknm;
	private String workusernm; // 공사유형 담당자
	
	private String sum_total_sale_unit_pric;
	
	private String clin_date;
	private String deli_degr_date;
	private String rece_regi_date;
	private String clos_sale_date;
	private String clos_buyi_date;
	private String auto_receive;
	
	
	private String purc_iden_quan;
	private String deli_iden_quan;
	private String rece_iden_quan;
	
	private String cate_name1;
	private String cate_name2;
	private String cate_name3;
	
	private String bchBusinessNum;
	private String venBusinessNum;
	private String deli_area_name;
	
	private String sum_orde_requ_quan;
	
	private String invoiceDate;
	
	
	private String orde_stat_flag;
	
	private String orde_sequ_numb;
	
	private String purc_stat_flag;
	
	private String full_cate_name;
	
	//상품실적년도
	private String good_reg_year;
	
	//공사유형 대분류
	private String codeNmTop;
	
	//선입금여부
	private String prepay;
	
	//정산생성일
	private String crea_sale_date;
	
	//납품예정일
	private String deli_sche_date;
	
	//상품담당자
	private String product_manager;
	
	//구매사 법인ID
	private String clientid;
	private String is_add_good;
	
	
	
	public String getClientid() {
		return clientid;
	}
	public void setClientid(String clientid) {
		this.clientid = clientid;
	}
	public String getProduct_manager() {
		return product_manager;
	}
	public void setProduct_manager(String product_manager) {
		this.product_manager = product_manager;
	}
	public String getDeli_sche_date() {
		return deli_sche_date;
	}
	public void setDeli_sche_date(String deli_sche_date) {
		this.deli_sche_date = deli_sche_date;
	}
	public String getCrea_sale_date() {
		return crea_sale_date;
	}
	public void setCrea_sale_date(String crea_sale_date) {
		this.crea_sale_date = crea_sale_date;
	}
	public String getPrepay() {
		return prepay;
	}
	public void setPrepay(String prepay) {
		this.prepay = prepay;
	}
	public String getCodeNmTop() {
		return codeNmTop;
	}
	public void setCodeNmTop(String codeNmTop) {
		this.codeNmTop = codeNmTop;
	}
	public String getGood_reg_year() {
		return good_reg_year;
	}
	public void setGood_reg_year(String good_reg_year) {
		this.good_reg_year = good_reg_year;
	}
	public String getFull_cate_name() {
		return full_cate_name;
	}
	public void setFull_cate_name(String full_cate_name) {
		this.full_cate_name = full_cate_name;
	}
	public String getClos_buyi_date() {
		return clos_buyi_date;
	}
	public void setClos_buyi_date(String clos_buyi_date) {
		this.clos_buyi_date = clos_buyi_date;
	}
	public String getPurc_stat_flag() {
		return purc_stat_flag;
	}
	public void setPurc_stat_flag(String purc_stat_flag) {
		this.purc_stat_flag = purc_stat_flag;
	}
	public String getOrde_sequ_numb() {
		return orde_sequ_numb;
	}
	public void setOrde_sequ_numb(String orde_sequ_numb) {
		this.orde_sequ_numb = orde_sequ_numb;
	}
	public String getInvoiceDate() {
		return invoiceDate;
	}
	public void setInvoiceDate(String invoiceDate) {
		this.invoiceDate = invoiceDate;
	}
	public String getOrde_stat_flag() {
		return orde_stat_flag;
	}
	public void setOrde_stat_flag(String orde_stat_flag) {
		this.orde_stat_flag = orde_stat_flag;
	}
	
	public String getSum_quantity() {
		return sum_quantity;
	}
	public void setSum_quantity(String sum_quantity) {
		this.sum_quantity = sum_quantity;
	}
	public String getSum_orde_requ_quan() {
		return sum_orde_requ_quan;
	}
	public void setSum_orde_requ_quan(String sum_orde_requ_quan) {
		this.sum_orde_requ_quan = sum_orde_requ_quan;
	}
	public String getDeli_area_name() {
		return deli_area_name;
	}
	public void setDeli_area_name(String deli_area_name) {
		this.deli_area_name = deli_area_name;
	}
	public String getDelivery_rdy() {
		return delivery_rdy;
	}
	public void setDelivery_rdy(String delivery_rdy) {
		this.delivery_rdy = delivery_rdy;
	}
	public String getBchBusinessNum() {
		return bchBusinessNum;
	}
	public void setBchBusinessNum(String bchBusinessNum) {
		this.bchBusinessNum = bchBusinessNum;
	}
	public String getVenBusinessNum() {
		return venBusinessNum;
	}
	public void setVenBusinessNum(String venBusinessNum) {
		this.venBusinessNum = venBusinessNum;
	}
	public String getCate_name1() {
		return cate_name1;
	}
	public void setCate_name1(String cate_name1) {
		this.cate_name1 = cate_name1;
	}
	public String getCate_name2() {
		return cate_name2;
	}
	public void setCate_name2(String cate_name2) {
		this.cate_name2 = cate_name2;
	}
	public String getCate_name3() {
		return cate_name3;
	}
	public void setCate_name3(String cate_name3) {
		this.cate_name3 = cate_name3;
	}
	public String getPurc_iden_quan() {
		return purc_iden_quan;
	}
	public void setPurc_iden_quan(String purc_iden_quan) {
		this.purc_iden_quan = purc_iden_quan;
	}
	public String getDeli_iden_quan() {
		return deli_iden_quan;
	}
	public void setDeli_iden_quan(String deli_iden_quan) {
		this.deli_iden_quan = deli_iden_quan;
	}
	public String getRece_iden_quan() {
		return rece_iden_quan;
	}
	public void setRece_iden_quan(String rece_iden_quan) {
		this.rece_iden_quan = rece_iden_quan;
	}
	public String getClin_date() {
		return clin_date;
	}
	public void setClin_date(String clin_date) {
		this.clin_date = clin_date;
	}
	public String getDeli_degr_date() {
		return deli_degr_date;
	}
	public void setDeli_degr_date(String deli_degr_date) {
		this.deli_degr_date = deli_degr_date;
	}
	public String getRece_regi_date() {
		return rece_regi_date;
	}
	public void setRece_regi_date(String rece_regi_date) {
		this.rece_regi_date = rece_regi_date;
	}
	public String getClos_sale_date() {
		return clos_sale_date;
	}
	public void setClos_sale_date(String clos_sale_date) {
		this.clos_sale_date = clos_sale_date;
	}
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
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
	public String getOrde_user_id() {
		return orde_user_id;
	}
	public void setOrde_user_id(String orde_user_id) {
		this.orde_user_id = orde_user_id;
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
	public String getUsernm() {
		return usernm;
	}
	public void setUsernm(String usernm) {
		this.usernm = usernm;
	}
	public String getStat_flag_name() {
		return stat_flag_name;
	}
	public void setStat_flag_name(String stat_flag_name) {
		this.stat_flag_name = stat_flag_name;
	}
	public String getOrde_type_name() {
		return orde_type_name;
	}
	public void setOrde_type_name(String orde_type_name) {
		this.orde_type_name = orde_type_name;
	}
	public String getVendornm() {
		return vendornm;
	}
	public void setVendornm(String vendornm) {
		this.vendornm = vendornm;
	}
	public String getTotal_orde_requ_pric() {
		return total_orde_requ_pric;
	}
	public void setTotal_orde_requ_pric(String total_orde_requ_pric) {
		this.total_orde_requ_pric = total_orde_requ_pric;
	}
	public String getTotal_sale_unit_pric() {
		return total_sale_unit_pric;
	}
	public void setTotal_sale_unit_pric(String total_sale_unit_pric) {
		this.total_sale_unit_pric = total_sale_unit_pric;
	}
	//배분율
	private int divRate = 0;
	
	public int getDivRate() {
		return divRate;
	}
	public void setDivRate(int divRate) {
		this.divRate = divRate;
	}
	public String getOrder_request() {
		return order_request;
	}
	public void setOrder_request(String order_request) {
		this.order_request = order_request;
	}
	public String getPurt_request() {
		return purt_request;
	}
	public void setPurt_request(String purt_request) {
		this.purt_request = purt_request;
	}
	public String getPurt_request_stop() {
		return purt_request_stop;
	}
	public void setPurt_request_stop(String purt_request_stop) {
		this.purt_request_stop = purt_request_stop;
	}
	public String getPurt_receive() {
		return purt_receive;
	}
	public void setPurt_receive(String purt_receive) {
		this.purt_receive = purt_receive;
	}
	public String getPurt_receive_stop() {
		return purt_receive_stop;
	}
	public void setPurt_receive_stop(String purt_receive_stop) {
		this.purt_receive_stop = purt_receive_stop;
	}
	public String getDelivery() {
		return delivery;
	}
	public void setDelivery(String delivery) {
		this.delivery = delivery;
	}
	public String getDelivery_stop() {
		return delivery_stop;
	}
	public void setDelivery_stop(String delivery_stop) {
		this.delivery_stop = delivery_stop;
	}
	public String getDelivery_receive() {
		return delivery_receive;
	}
	public void setDelivery_receive(String delivery_receive) {
		this.delivery_receive = delivery_receive;
	}
	public String getOrder_cancel() {
		return order_cancel;
	}
	public void setOrder_cancel(String order_cancel) {
		this.order_cancel = order_cancel;
	}
	public String getOrder_return() {
		return order_return;
	}
	public void setOrder_return(String order_return) {
		this.order_return = order_return;
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
	public String getOrder_purc() {
		return order_purc;
	}
	public void setOrder_purc(String order_purc) {
		this.order_purc = order_purc;
	}
	public String getOrde_clas_code() {
		return orde_clas_code;
	}
	public void setOrde_clas_code(String orde_clas_code) {
		this.orde_clas_code = orde_clas_code;
	}
	public String getAreatype() {
		return areatype;
	}
	public void setAreatype(String areatype) {
		this.areatype = areatype;
	}
	public String getOrde_tele_numb() {
		return orde_tele_numb;
	}
	public void setOrde_tele_numb(String orde_tele_numb) {
		this.orde_tele_numb = orde_tele_numb;
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
	public String getTran_data_addr() {
		return tran_data_addr;
	}
	public void setTran_data_addr(String tran_data_addr) {
		this.tran_data_addr = tran_data_addr;
	}
	public String getAdde_text_desc() {
		return adde_text_desc;
	}
	public void setAdde_text_desc(String adde_text_desc) {
		this.adde_text_desc = adde_text_desc;
	}
	public String getDisp_good_id() {
		return disp_good_id;
	}
	public void setDisp_good_id(String disp_good_id) {
		this.disp_good_id = disp_good_id;
	}
	public String getGood_clas_code() {
		return good_clas_code;
	}
	public void setGood_clas_code(String good_clas_code) {
		this.good_clas_code = good_clas_code;
	}
	public String getGood_name() {
		return good_name;
	}
	public void setGood_name(String good_name) {
		this.good_name = good_name;
	}
	public String getDeli_mini_day() {
		return deli_mini_day;
	}
	public void setDeli_mini_day(String deli_mini_day) {
		this.deli_mini_day = deli_mini_day;
	}
	public String getGood_spec_desc() {
		return good_spec_desc;
	}
	public void setGood_spec_desc(String good_spec_desc) {
		this.good_spec_desc = good_spec_desc;
	}
	public String getVendor_name() {
		return vendor_name;
	}
	public void setVendor_name(String vendor_name) {
		this.vendor_name = vendor_name;
	}
	public String getGood_iden_name() {
		return good_iden_name;
	}
	public void setGood_iden_name(String good_iden_name) {
		this.good_iden_name = good_iden_name;
	}
	public String getOrde_iden_numb() {
		return orde_iden_numb;
	}
	public void setOrde_iden_numb(String orde_iden_numb) {
		this.orde_iden_numb = orde_iden_numb;
	}
	public String getOrde_type_clas() {
		return orde_type_clas;
	}
	public void setOrde_type_clas(String orde_type_clas) {
		this.orde_type_clas = orde_type_clas;
	}
	public String getRegi_date_time() {
		return regi_date_time;
	}
	public void setRegi_date_time(String regi_date_time) {
		this.regi_date_time = regi_date_time;
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
	public String getCons_iden_name() {
		return cons_iden_name;
	}
	public void setCons_iden_name(String cons_iden_name) {
		this.cons_iden_name = cons_iden_name;
	}
	public String getOrder_status_flag() {
		return order_status_flag;
	}
	public void setOrder_status_flag(String order_status_flag) {
		this.order_status_flag = order_status_flag;
	}
	public String getGood_iden_numb() {
		return good_iden_numb;
	}
	public void setGood_iden_numb(String good_iden_numb) {
		this.good_iden_numb = good_iden_numb;
	}
	public double getSell_price() {
		return sell_price;
	}
	public void setSell_price(double sell_price) {
		this.sell_price = sell_price;
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
	public double getTotal_sell_price() {
		return total_sell_price;
	}
	public void setTotal_sell_price(double total_sell_price) {
		this.total_sell_price = total_sell_price;
	}
	public double getTotal_sale_price() {
		return total_sale_price;
	}
	public void setTotal_sale_price(double total_sale_price) {
		this.total_sale_price = total_sale_price;
	}
	public String getRequ_deli_date() {
		return requ_deli_date;
	}
	public void setRequ_deli_date(String requ_deli_date) {
		this.requ_deli_date = requ_deli_date;
	}
	public String getMin_orde_requ_quan() {
		return min_orde_requ_quan;
	}
	public void setMin_orde_requ_quan(String min_orde_requ_quan) {
		this.min_orde_requ_quan = min_orde_requ_quan;
	}
	public String getGood_inventory_cnt() {
		return good_inventory_cnt;
	}
	public void setGood_inventory_cnt(String good_inventory_cnt) {
		this.good_inventory_cnt = good_inventory_cnt;
	}
	public String getEmer_orde_clas() {
		return emer_orde_clas;
	}
	public void setEmer_orde_clas(String emer_orde_clas) {
		this.emer_orde_clas = emer_orde_clas;
	}
	public String getPurc_requ_quan() {
		return purc_requ_quan;
	}
	public void setPurc_requ_quan(String purc_requ_quan) {
		this.purc_requ_quan = purc_requ_quan;
	}
	public String getVendorid() {
		return vendorid;
	}
	public void setVendorid(String vendorid) {
		this.vendorid = vendorid;
	}
	public String getPhonenum() {
		return phonenum;
	}
	public void setPhonenum(String phonenum) {
		this.phonenum = phonenum;
	}
	public String getApprovedate() {
		return approvedate;
	}
	public void setApprovedate(String approvedate) {
		this.approvedate = approvedate;
	}
	public String getDirectorname() {
		return directorname;
	}
	public void setDirectorname(String directorname) {
		this.directorname = directorname;
	}
	public String getGood_st_spec_desc() {
		return good_st_spec_desc;
	}
	public void setGood_st_spec_desc(String good_st_spec_desc) {
		this.good_st_spec_desc = good_st_spec_desc;
	}
	public String getWorknm() {
		return worknm;
	}
	public void setWorknm(String worknm) {
		this.worknm = worknm;
	}
	public String getWorkusernm() {
		return workusernm;
	}
	public void setWorkusernm(String workusernm) {
		this.workusernm = workusernm;
	}
	public String getSum_total_sale_unit_pric() {
		return sum_total_sale_unit_pric;
	}
	public void setSum_total_sale_unit_pric(String sum_total_sale_unit_pric) {
		this.sum_total_sale_unit_pric = sum_total_sale_unit_pric;
	}
	public String getAuto_receive() {
		return auto_receive;
	}
	public void setAuto_receive(String auto_receive) {
		this.auto_receive = auto_receive;
	}
	public String getIs_add_good() {
		return is_add_good;
	}
	public void setIs_add_good(String is_add_good) {
		this.is_add_good = is_add_good;
	}
	public String getGood_spec() {
		return good_spec;
	}
	public void setGood_spec(String good_spec) {
		this.good_spec = good_spec;
	}
	public String getPurt_receive_req() {
		return purt_receive_req;
	}
	public void setPurt_receive_req(String purt_receive_req) {
		this.purt_receive_req = purt_receive_req;
	}
}
