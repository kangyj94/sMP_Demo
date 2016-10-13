package kr.co.bitcube.analysis.dto;

public class AnalysisDto {
	
	//경영정보요약
	private String gubun;
	private String clos_year;
	private String m1;
	private String m2;
	private String m3;
	private String m4;
	private String m5;
	private String m6;
	private String m7;
	private String m8;
	private String m9;
	private String m10;
	private String m11;
	private String m12;
	private String summary_tota_amou;
	
	//고객사별 손익실적
	private String clientid;
	private String sale_sequ_numb;
	private String borgid;
	private String borgnm;
	private String sale_requ_amou;
	private String purc_prod_amou;
	private String prof_amou;
	private String rank;
	private String good_name;
	private String sale_prod_amou;
	
	//공급사별 손익실적
	private String vendorid;
	private String vendornm;
	
	//권역별 손익실적
	private String areatype;
	private String areatypenm;
	private String purc_requ_amou;
	
	//품목별판매실적
	private String groupid;
	private String branchid;
	private String good_iden_numb;
	private String orde_cnt;
	private String orde_quan;
	
	private String businessNum;
	
	//총건수의 수량 합계 및 금액합계
	private String sum_orde_quan;
	private String sum_sale_prod_amou;
	
	//공사유형
	private String worknm;
	private String workid;
	private String codeNmTop;
	private String codeNmMid;
	
	//신규실적 년도
	private String n1;
	private String n2;
	private String n3;
	private String n4;
	private String n5;
	private String n6;
	private String n7;
	private String n8;
	private String n9;
	private String n10;
	private String n11;
	private String n12;
	private String msummary_tota_amou;
	private String nsummary_tota_amou;
	
	//공사유형별 월 예상실적
	private String receive_list;
	private String receive_return;
	private String receive_preorder;
	private String consignment;
	private String consignment_preparation;
	private String purchase_order;
	private String purchase_request;
	private String order_request;
	private String approval_request;
	private String assume;
	private int receive_list_sum;
	private int receive_return_sum;
	private int receive_preorder_sum;
	private int consignment_sum;
	private int consignment_preparation_sum;
	private int purchase_order_sum;
	private int purchase_request_sum;
	private int order_request_sum;
	private int approval_request_sum;
	private int summary_tota_amou_sum;
	private int assume_sum;
	
	//월 예상실적 
	private String new_spot_month;
	private String spot_month;
	private String new_last_month;
	private String last_month;
	private String new_total_month;
	private String total_month;
	
	//일자별 주문/출하/인수 실적
	private String src_month;
	private String src_day;
	private String week_day;
	private String order_amount;
	private String invoice_amount;
	private String receive_amount;
	private String profit_amount;//매출이익 항목 추가 2015-11-09 비트큐브 임상건
	
	private String auto_receive_amount;
	private String menu_receive_amount;
	private String rece_pay_amou;
	private String rece_pay_amou_percent;
	
	//채권관리
	private String sum_amou;
	private String sale_cnt;
	private String rece_name;
	
	//채권관리업체 20140217
	private String branchcd;
	private String branchnm;
//	private String businessnum;
	private String usernm;
	private String clos_sale_date;
	private String st_over_date;
	private String clos_over_date;
	
	//품목별 매출실적 카테고리
	private String cate_name1;
	private String cate_name2;
	private String cate_name3;
	
	//년도별 매출이익, 매출이익률
	private String profit1;
	private String profit2;
	private String profit3;
	private String profit4;
	private String profit5;
	private String profit6;
	private String profit7;
	private String profit8;
	private String profit9;
	private String profit10;
	private String profit11;
	private String profit12;
	private String profitRate1;
	private String profitRate2;
	private String profitRate3;
	private String profitRate4;
	private String profitRate5;
	private String profitRate6;
	private String profitRate7;
	private String profitRate8;
	private String profitRate9;
	private String profitRate10;
	private String profitRate11;
	private String profitRate12;
	private String tota_profit;
	private String tota_profitrate;
	
	//월매출이익, 월매출이익률
	private String last_profit;
	private String last_profitrate;
	private String spot_profit;
	private String spot_profitrate;
	private String total_profit;
	private String total_profitrate;
	
	//상품구분
	private String goodClasCode;
	
	//상품규격
	private String good_Spec_Desc;
	private String good_St_Spec_Desc;
	//20160105 sun 추가 
	private String good_Spec;
	
	//입금유형
	private String rece_pay_amou_cash;
	private String rece_pay_amou_bill;
	private String rece_pay_amou_setoff; 
	
	//상품담당자
	private String productManager;
	
	
	public String getProductManager() {
		return productManager;
	}
	public void setProductManager(String productManager) {
		this.productManager = productManager;
	}
	public String getRece_pay_amou_cash() {
		return rece_pay_amou_cash;
	}
	public void setRece_pay_amou_cash(String rece_pay_amou_cash) {
		this.rece_pay_amou_cash = rece_pay_amou_cash;
	}
	public String getRece_pay_amou_bill() {
		return rece_pay_amou_bill;
	}
	public void setRece_pay_amou_bill(String rece_pay_amou_bill) {
		this.rece_pay_amou_bill = rece_pay_amou_bill;
	}
	public String getRece_pay_amou_setoff() {
		return rece_pay_amou_setoff;
	}
	public void setRece_pay_amou_setoff(String rece_pay_amou_setoff) {
		this.rece_pay_amou_setoff = rece_pay_amou_setoff;
	}
	public String getGood_Spec_Desc() {
		return good_Spec_Desc;
	}
	public void setGood_Spec_Desc(String good_Spec_Desc) {
		this.good_Spec_Desc = good_Spec_Desc;
	}
	public String getGood_St_Spec_Desc() {
		return good_St_Spec_Desc;
	}
	public void setGood_St_Spec_Desc(String good_St_Spec_Desc) {
		this.good_St_Spec_Desc = good_St_Spec_Desc;
	}
	public String getGoodClasCode() {
		return goodClasCode;
	}
	public void setGoodClasCode(String goodClasCode) {
		this.goodClasCode = goodClasCode;
	}
	public String getLast_profit() {
		return last_profit;
	}
	public void setLast_profit(String last_profit) {
		this.last_profit = last_profit;
	}
	public String getLast_profitrate() {
		return last_profitrate;
	}
	public void setLast_profitrate(String last_profitrate) {
		this.last_profitrate = last_profitrate;
	}
	public String getSpot_profit() {
		return spot_profit;
	}
	public void setSpot_profit(String spot_profit) {
		this.spot_profit = spot_profit;
	}
	public String getSpot_profitrate() {
		return spot_profitrate;
	}
	public void setSpot_profitrate(String spot_profitrate) {
		this.spot_profitrate = spot_profitrate;
	}
	public String getTotal_profit() {
		return total_profit;
	}
	public void setTotal_profit(String total_profit) {
		this.total_profit = total_profit;
	}
	public String getTotal_profitrate() {
		return total_profitrate;
	}
	public void setTotal_profitrate(String total_profitrate) {
		this.total_profitrate = total_profitrate;
	}
	public String getTota_profit() {
		return tota_profit;
	}
	public void setTota_profit(String tota_profit) {
		this.tota_profit = tota_profit;
	}
	public String getTota_profitrate() {
		return tota_profitrate;
	}
	public void setTota_profitrate(String tota_profitrate) {
		this.tota_profitrate = tota_profitrate;
	}
	public String getProfit1() {
		return profit1;
	}
	public void setProfit1(String profit1) {
		this.profit1 = profit1;
	}
	public String getProfit2() {
		return profit2;
	}
	public void setProfit2(String profit2) {
		this.profit2 = profit2;
	}
	public String getProfit3() {
		return profit3;
	}
	public void setProfit3(String profit3) {
		this.profit3 = profit3;
	}
	public String getProfit4() {
		return profit4;
	}
	public void setProfit4(String profit4) {
		this.profit4 = profit4;
	}
	public String getProfit5() {
		return profit5;
	}
	public void setProfit5(String profit5) {
		this.profit5 = profit5;
	}
	public String getProfit6() {
		return profit6;
	}
	public void setProfit6(String profit6) {
		this.profit6 = profit6;
	}
	public String getProfit7() {
		return profit7;
	}
	public void setProfit7(String profit7) {
		this.profit7 = profit7;
	}
	public String getProfit8() {
		return profit8;
	}
	public void setProfit8(String profit8) {
		this.profit8 = profit8;
	}
	public String getProfit9() {
		return profit9;
	}
	public void setProfit9(String profit9) {
		this.profit9 = profit9;
	}
	public String getProfit10() {
		return profit10;
	}
	public void setProfit10(String profit10) {
		this.profit10 = profit10;
	}
	public String getProfit11() {
		return profit11;
	}
	public void setProfit11(String profit11) {
		this.profit11 = profit11;
	}
	public String getProfit12() {
		return profit12;
	}
	public void setProfit12(String profit12) {
		this.profit12 = profit12;
	}
	public String getProfitRate1() {
		return profitRate1;
	}
	public void setProfitRate1(String profitRate1) {
		this.profitRate1 = profitRate1;
	}
	public String getProfitRate2() {
		return profitRate2;
	}
	public void setProfitRate2(String profitRate2) {
		this.profitRate2 = profitRate2;
	}
	public String getProfitRate3() {
		return profitRate3;
	}
	public void setProfitRate3(String profitRate3) {
		this.profitRate3 = profitRate3;
	}
	public String getProfitRate4() {
		return profitRate4;
	}
	public void setProfitRate4(String profitRate4) {
		this.profitRate4 = profitRate4;
	}
	public String getProfitRate5() {
		return profitRate5;
	}
	public void setProfitRate5(String profitRate5) {
		this.profitRate5 = profitRate5;
	}
	public String getProfitRate6() {
		return profitRate6;
	}
	public void setProfitRate6(String profitRate6) {
		this.profitRate6 = profitRate6;
	}
	public String getProfitRate7() {
		return profitRate7;
	}
	public void setProfitRate7(String profitRate7) {
		this.profitRate7 = profitRate7;
	}
	public String getProfitRate8() {
		return profitRate8;
	}
	public void setProfitRate8(String profitRate8) {
		this.profitRate8 = profitRate8;
	}
	public String getProfitRate9() {
		return profitRate9;
	}
	public void setProfitRate9(String profitRate9) {
		this.profitRate9 = profitRate9;
	}
	public String getProfitRate10() {
		return profitRate10;
	}
	public void setProfitRate10(String profitRate10) {
		this.profitRate10 = profitRate10;
	}
	public String getProfitRate11() {
		return profitRate11;
	}
	public void setProfitRate11(String profitRate11) {
		this.profitRate11 = profitRate11;
	}
	public String getProfitRate12() {
		return profitRate12;
	}
	public void setProfitRate12(String profitRate12) {
		this.profitRate12 = profitRate12;
	}
	public String getRece_pay_amou() {
		return rece_pay_amou;
	}
	public void setRece_pay_amou(String rece_pay_amou) {
		this.rece_pay_amou = rece_pay_amou;
	}
	public String getRece_pay_amou_percent() {
		return rece_pay_amou_percent;
	}
	public void setRece_pay_amou_percent(String rece_pay_amou_percent) {
		this.rece_pay_amou_percent = rece_pay_amou_percent;
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
	public String getBranchcd() {
		return branchcd;
	}
	public void setBranchcd(String branchcd) {
		this.branchcd = branchcd;
	}
	public String getBranchnm() {
		return branchnm;
	}
	public void setBranchnm(String branchnm) {
		this.branchnm = branchnm;
	}
//	public String getBusinessnum() {
//		return businessnum;
//	}
//	public void setBusinessnum(String businessnum) {
//		this.businessnum = businessnum;
//	}
	public String getUsernm() {
		return usernm;
	}
	public void setUsernm(String usernm) {
		this.usernm = usernm;
	}
	public String getClos_sale_date() {
		return clos_sale_date;
	}
	public void setClos_sale_date(String clos_sale_date) {
		this.clos_sale_date = clos_sale_date;
	}
	public String getSt_over_date() {
		return st_over_date;
	}
	public void setSt_over_date(String st_over_date) {
		this.st_over_date = st_over_date;
	}
	public String getClos_over_date() {
		return clos_over_date;
	}
	public void setClos_over_date(String clos_over_date) {
		this.clos_over_date = clos_over_date;
	}
	public String getSum_amou() {
		return sum_amou;
	}
	public void setSum_amou(String sum_amou) {
		this.sum_amou = sum_amou;
	}
	public String getSale_cnt() {
		return sale_cnt;
	}
	public void setSale_cnt(String sale_cnt) {
		this.sale_cnt = sale_cnt;
	}
	public String getRece_name() {
		return rece_name;
	}
	public void setRece_name(String rece_name) {
		this.rece_name = rece_name;
	}
	public int getReceive_list_sum() {
		return receive_list_sum;
	}
	public void setReceive_list_sum(int receive_list_sum) {
		this.receive_list_sum = receive_list_sum;
	}
	public int getReceive_return_sum() {
		return receive_return_sum;
	}
	public void setReceive_return_sum(int receive_return_sum) {
		this.receive_return_sum = receive_return_sum;
	}
	public int getReceive_preorder_sum() {
		return receive_preorder_sum;
	}
	public void setReceive_preorder_sum(int receive_preorder_sum) {
		this.receive_preorder_sum = receive_preorder_sum;
	}
	public int getConsignment_sum() {
		return consignment_sum;
	}
	public void setConsignment_sum(int consignment_sum) {
		this.consignment_sum = consignment_sum;
	}
	public int getConsignment_preparation_sum() {
		return consignment_preparation_sum;
	}
	public void setConsignment_preparation_sum(int consignment_preparation_sum) {
		this.consignment_preparation_sum = consignment_preparation_sum;
	}
	public int getPurchase_order_sum() {
		return purchase_order_sum;
	}
	public void setPurchase_order_sum(int purchase_order_sum) {
		this.purchase_order_sum = purchase_order_sum;
	}
	public int getPurchase_request_sum() {
		return purchase_request_sum;
	}
	public void setPurchase_request_sum(int purchase_request_sum) {
		this.purchase_request_sum = purchase_request_sum;
	}
	public int getOrder_request_sum() {
		return order_request_sum;
	}
	public void setOrder_request_sum(int order_request_sum) {
		this.order_request_sum = order_request_sum;
	}
	public int getApproval_request_sum() {
		return approval_request_sum;
	}
	public void setApproval_request_sum(int approval_request_sum) {
		this.approval_request_sum = approval_request_sum;
	}
	public int getSummary_tota_amou_sum() {
		return summary_tota_amou_sum;
	}
	public void setSummary_tota_amou_sum(int summary_tota_amou_sum) {
		this.summary_tota_amou_sum = summary_tota_amou_sum;
	}
	public int getAssume_sum() {
		return assume_sum;
	}
	public void setAssume_sum(int assume_sum) {
		this.assume_sum = assume_sum;
	}
	public String getAssume() {
		return assume;
	}
	public void setAssume(String assume) {
		this.assume = assume;
	}
	public String getSrc_month() {
		return src_month;
	}
	public void setSrc_month(String src_month) {
		this.src_month = src_month;
	}
	public String getSrc_day() {
		return src_day;
	}
	public void setSrc_day(String src_day) {
		this.src_day = src_day;
	}
	public String getWeek_day() {
		return week_day;
	}
	public void setWeek_day(String week_day) {
		this.week_day = week_day;
	}
	public String getOrder_amount() {
		return order_amount;
	}
	public void setOrder_amount(String order_amount) {
		this.order_amount = order_amount;
	}
	public String getInvoice_amount() {
		return invoice_amount;
	}
	public void setInvoice_amount(String invoice_amount) {
		this.invoice_amount = invoice_amount;
	}
	public String getReceive_amount() {
		return receive_amount;
	}
	public void setReceive_amount(String receive_amount) {
		this.receive_amount = receive_amount;
	}
	
	public String getProfit_amount() {
		return profit_amount;
	}
	public void setProfit_amount(String profit_amount) {
		this.profit_amount = profit_amount;
	}
	
	public String getAuto_receive_amount() {
		return auto_receive_amount;
	}
	public void setAuto_receive_amount(String auto_receive_amount) {
		this.auto_receive_amount = auto_receive_amount;
	}
	public String getMenu_receive_amount() {
		return menu_receive_amount;
	}
	public void setMenu_receive_amount(String menu_receive_amount) {
		this.menu_receive_amount = menu_receive_amount;
	}
	public String getAuto_sale_amount() {
		return auto_sale_amount;
	}
	public void setAuto_sale_amount(String auto_sale_amount) {
		this.auto_sale_amount = auto_sale_amount;
	}
	public String getMenu_sale_amount() {
		return menu_sale_amount;
	}
	public void setMenu_sale_amount(String menu_sale_amount) {
		this.menu_sale_amount = menu_sale_amount;
	}
	private String auto_sale_amount;
	private String menu_sale_amount;
	
	public String getNew_spot_month() {
		return new_spot_month;
	}
	public void setNew_spot_month(String new_spot_month) {
		this.new_spot_month = new_spot_month;
	}
	public String getSpot_month() {
		return spot_month;
	}
	public void setSpot_month(String spot_month) {
		this.spot_month = spot_month;
	}
	public String getNew_last_month() {
		return new_last_month;
	}
	public void setNew_last_month(String new_last_month) {
		this.new_last_month = new_last_month;
	}
	public String getLast_month() {
		return last_month;
	}
	public void setLast_month(String last_month) {
		this.last_month = last_month;
	}
	public String getNew_total_month() {
		return new_total_month;
	}
	public void setNew_total_month(String new_total_month) {
		this.new_total_month = new_total_month;
	}
	public String getTotal_month() {
		return total_month;
	}
	public void setTotal_month(String total_month) {
		this.total_month = total_month;
	}
	public String getReceive_list() {
		return receive_list;
	}
	public void setReceive_list(String receive_list) {
		this.receive_list = receive_list;
	}
	public String getReceive_return() {
		return receive_return;
	}
	public void setReceive_return(String receive_return) {
		this.receive_return = receive_return;
	}
	public String getReceive_preorder() {
		return receive_preorder;
	}
	public void setReceive_preorder(String receive_preorder) {
		this.receive_preorder = receive_preorder;
	}
	public String getConsignment() {
		return consignment;
	}
	public void setConsignment(String consignment) {
		this.consignment = consignment;
	}
	public String getConsignment_preparation() {
		return consignment_preparation;
	}
	public void setConsignment_preparation(String consignment_preparation) {
		this.consignment_preparation = consignment_preparation;
	}
	public String getPurchase_order() {
		return purchase_order;
	}
	public void setPurchase_order(String purchase_order) {
		this.purchase_order = purchase_order;
	}
	public String getPurchase_request() {
		return purchase_request;
	}
	public void setPurchase_request(String purchase_request) {
		this.purchase_request = purchase_request;
	}
	public String getOrder_request() {
		return order_request;
	}
	public void setOrder_request(String order_request) {
		this.order_request = order_request;
	}
	public String getApproval_request() {
		return approval_request;
	}
	public void setApproval_request(String approval_request) {
		this.approval_request = approval_request;
	}
	public String getCodeNmTop() {
		return codeNmTop;
	}
	public void setCodeNmTop(String codeNmTop) {
		this.codeNmTop = codeNmTop;
	}
	public String getCodeNmMid() {
		return codeNmMid;
	}
	public void setCodeNmMid(String codeNmMid) {
		this.codeNmMid = codeNmMid;
	}
	public String getN1() {
		return n1;
	}
	public void setN1(String n1) {
		this.n1 = n1;
	}
	public String getN2() {
		return n2;
	}
	public void setN2(String n2) {
		this.n2 = n2;
	}
	public String getN3() {
		return n3;
	}
	public void setN3(String n3) {
		this.n3 = n3;
	}
	public String getN4() {
		return n4;
	}
	public void setN4(String n4) {
		this.n4 = n4;
	}
	public String getN5() {
		return n5;
	}
	public void setN5(String n5) {
		this.n5 = n5;
	}
	public String getN6() {
		return n6;
	}
	public void setN6(String n6) {
		this.n6 = n6;
	}
	public String getN7() {
		return n7;
	}
	public void setN7(String n7) {
		this.n7 = n7;
	}
	public String getN8() {
		return n8;
	}
	public void setN8(String n8) {
		this.n8 = n8;
	}
	public String getN9() {
		return n9;
	}
	public void setN9(String n9) {
		this.n9 = n9;
	}
	public String getN10() {
		return n10;
	}
	public void setN10(String n10) {
		this.n10 = n10;
	}
	public String getN11() {
		return n11;
	}
	public void setN11(String n11) {
		this.n11 = n11;
	}
	public String getN12() {
		return n12;
	}
	public void setN12(String n12) {
		this.n12 = n12;
	}
	public String getMsummary_tota_amou() {
		return msummary_tota_amou;
	}
	public void setMsummary_tota_amou(String msummary_tota_amou) {
		this.msummary_tota_amou = msummary_tota_amou;
	}
	public String getNsummary_tota_amou() {
		return nsummary_tota_amou;
	}
	public void setNsummary_tota_amou(String nsummary_tota_amou) {
		this.nsummary_tota_amou = nsummary_tota_amou;
	}
	public String getWorknm() {
		return worknm;
	}
	public void setWorknm(String worknm) {
		this.worknm = worknm;
	}
	public String getWorkid() {
		return workid;
	}
	public void setWorkid(String workid) {
		this.workid = workid;
	}
	public String getSum_orde_quan() {
		return sum_orde_quan;
	}
	public void setSum_orde_quan(String sum_orde_quan) {
		this.sum_orde_quan = sum_orde_quan;
	}
	public String getSum_sale_prod_amou() {
		return sum_sale_prod_amou;
	}
	public void setSum_sale_prod_amou(String sum_sale_prod_amou) {
		this.sum_sale_prod_amou = sum_sale_prod_amou;
	}
	public String getBusinessNum() {
		return businessNum;
	}
	public void setBusinessNum(String businessNum) {
		this.businessNum = businessNum;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getClos_year() {
		return clos_year;
	}
	public void setClos_year(String clos_year) {
		this.clos_year = clos_year;
	}
	public String getM1() {
		return m1;
	}
	public void setM1(String m1) {
		this.m1 = m1;
	}
	public String getM2() {
		return m2;
	}
	public void setM2(String m2) {
		this.m2 = m2;
	}
	public String getM3() {
		return m3;
	}
	public void setM3(String m3) {
		this.m3 = m3;
	}
	public String getM4() {
		return m4;
	}
	public void setM4(String m4) {
		this.m4 = m4;
	}
	public String getM5() {
		return m5;
	}
	public void setM5(String m5) {
		this.m5 = m5;
	}
	public String getM6() {
		return m6;
	}
	public void setM6(String m6) {
		this.m6 = m6;
	}
	public String getM7() {
		return m7;
	}
	public void setM7(String m7) {
		this.m7 = m7;
	}
	public String getM8() {
		return m8;
	}
	public void setM8(String m8) {
		this.m8 = m8;
	}
	public String getM9() {
		return m9;
	}
	public void setM9(String m9) {
		this.m9 = m9;
	}
	public String getM10() {
		return m10;
	}
	public void setM10(String m10) {
		this.m10 = m10;
	}
	public String getM11() {
		return m11;
	}
	public void setM11(String m11) {
		this.m11 = m11;
	}
	public String getM12() {
		return m12;
	}
	public void setM12(String m12) {
		this.m12 = m12;
	}
	public String getSummary_tota_amou() {
		return summary_tota_amou;
	}
	public void setSummary_tota_amou(String summary_tota_amou) {
		this.summary_tota_amou = summary_tota_amou;
	}
	public String getClientid() {
		return clientid;
	}
	public void setClientid(String clientid) {
		this.clientid = clientid;
	}
	public String getSale_sequ_numb() {
		return sale_sequ_numb;
	}
	public void setSale_sequ_numb(String sale_sequ_numb) {
		this.sale_sequ_numb = sale_sequ_numb;
	}
	public String getBorgid() {
		return borgid;
	}
	public void setBorgid(String borgid) {
		this.borgid = borgid;
	}
	public String getBorgnm() {
		return borgnm;
	}
	public void setBorgnm(String borgnm) {
		this.borgnm = borgnm;
	}
	public String getSale_requ_amou() {
		return sale_requ_amou;
	}
	public void setSale_requ_amou(String sale_requ_amou) {
		this.sale_requ_amou = sale_requ_amou;
	}
	public String getPurc_prod_amou() {
		return purc_prod_amou;
	}
	public void setPurc_prod_amou(String purc_prod_amou) {
		this.purc_prod_amou = purc_prod_amou;
	}
	public String getProf_amou() {
		return prof_amou;
	}
	public void setProf_amou(String prof_amou) {
		this.prof_amou = prof_amou;
	}
	public String getRank() {
		return rank;
	}
	public void setRank(String rank) {
		this.rank = rank;
	}
	public String getGood_name() {
		return good_name;
	}
	public void setGood_name(String good_name) {
		this.good_name = good_name;
	}
	public String getSale_prod_amou() {
		return sale_prod_amou;
	}
	public void setSale_prod_amou(String sale_prod_amou) {
		this.sale_prod_amou = sale_prod_amou;
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
	public String getAreatypenm() {
		return areatypenm;
	}
	public void setAreatypenm(String areatypenm) {
		this.areatypenm = areatypenm;
	}
	public String getPurc_requ_amou() {
		return purc_requ_amou;
	}
	public void setPurc_requ_amou(String purc_requ_amou) {
		this.purc_requ_amou = purc_requ_amou;
	}
	public String getGroupid() {
		return groupid;
	}
	public void setGroupid(String groupid) {
		this.groupid = groupid;
	}
	public String getBranchid() {
		return branchid;
	}
	public void setBranchid(String branchid) {
		this.branchid = branchid;
	}
	public String getGood_iden_numb() {
		return good_iden_numb;
	}
	public void setGood_iden_numb(String good_iden_numb) {
		this.good_iden_numb = good_iden_numb;
	}
	public String getOrde_cnt() {
		return orde_cnt;
	}
	public void setOrde_cnt(String orde_cnt) {
		this.orde_cnt = orde_cnt;
	}
	public String getOrde_quan() {
		return orde_quan;
	}
	public void setOrde_quan(String orde_quan) {
		this.orde_quan = orde_quan;
	}
	public String getGood_Spec() {
		return good_Spec;
	}
	public void setGood_Spec(String good_Spec) {
		this.good_Spec = good_Spec;
	}
}
