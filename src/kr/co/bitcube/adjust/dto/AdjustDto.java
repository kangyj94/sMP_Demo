package kr.co.bitcube.adjust.dto;

import java.math.BigDecimal;

public class AdjustDto {
	
	private String order_num;
	private String orde_iden_numb;
	private String orde_sequ_numb;
	private String purc_iden_numb;
	private String deli_iden_numb;
	private String rece_iden_numb;
	private String orde_type_clas;
	private String groupId;
	private String clientId;
	private String clientNm;
	private String branchId;
	private String branchNm;
	private String orde_regi_date;
	private String deli_regi_date;
	private String rece_regi_date;
	private String deli_area_code;
	private String vendorId;
	private String vendorNm;
	private String onns_iden_name;
	private String disp_good_id;
	private String vtax_clas_code;
	private String sale_prod_quan;
	private String sale_prod_pris;
	private String sale_prod_amou;
	private String purc_prod_pris;
	private String purc_prod_amou;
	private String good_iden_numb;
	private String good_name;
	private String orde_user_id;
	private String real_rece_numb;
	private String sale_sequ_numb;
	private String buyi_sequ_numb;
	private String sale_prod_tax;
	private String purc_prod_tax;
	private String orde_type_clas_nm;
	private String sale_sequ_name;
	private String crea_sale_userid;
	private String crea_sale_usernm;
	private String clos_sale_date;
	private String paym_cond_code;
	private String crea_sale_date;
	private String sale_requ_amou;
	private String sale_requ_vtax;
	private String sale_tota_amou;
	private String cons_iden_name;
	private String sale_status_name;
	private String sale_status_code;
	private String sap_jour_numb;
	private String orde_requ_quan;
	private String sale_conf_date;
	private String payBillType;
	private String buyi_prod_quan;
	private String buyi_prod_amou;
	private String descYn;
	private String conf_date;
	private String businessNum;
	private String clos_buyi_date;
	private String buyi_conf_date;
	private String buyi_requ_amou;
	private String buyi_requ_vtax;
	private String buyi_tota_amou;
	private String isCollect;
	private String pay_amou;
	private String none_coll_amou;
	private String tran_status_nm;
	private String tran_sap_jour_date;
	private String creat_date;
	private String rece_sequ_num;
	private String context;
	private String rece_user_id;
	private String rece_user_nm;
	private String pay_amou_numb;
	private String isPayment;
	private String none_paym_amou;
	private String rece_pay_amou;
	private String pressentNm;
	private String balance_amou;
	private String avg_day;
	private String avg_day2;
	private String userNm;
	private String addres;
	private String phoneNum;
	private String bankCd;
	private String bankNm;
	private String tel;
	private String isLimit;
	private String isLimitStr;	
	private String none_clos_requ_pric;
	private String none_clos_purc_pric;
	private String none_clos_deli_pric;
	private String none_sale_prod_amou;
	private String alram_date;
	private String recep_alram_id;
	private String recep_alram_nm;
	private String sale_over_month;
	private String sale_over_day;
	private String sale_pay_date;
	private String buyi_over_month;
	private String buyi_over_day;
	private String buyi_pay_date;
	private String email;
	private String branchBusiClas;
	private String branchBusiType;
	private String vendorBusiClas;
	private String vendorBusiType;
	private String loginId;
	private String workId;
	private String workNm;
	private String payCondNm;
	private String pay_date;
	private String accManageUserId;
	private String buyi_conf_cnt;
	private BigDecimal sum_sale_requ_amou;
	private BigDecimal sum_sale_requ_vtax;
	private BigDecimal sum_sale_tota_amou;
	private BigDecimal sum_buyi_requ_amou;
	private BigDecimal sum_buyi_requ_vtax;
	private BigDecimal sum_buyi_tota_amou;
	private BigDecimal sum_pay_amou;
	private BigDecimal sum_none_coll_amou;
	private String org_branchid;
	private String org_branchnm;
	private String payBillTypeNm;
	private String orde_user_nm;
	private String good_st_spec_desc;
	private String good_spec_desc;

	private String schedule_date;
	private String schedule_amou;
	private String tel_user_nm;
	
	private String expiration_date;
	private String autOrderLimitPeriod;
	private String ele_etc_date;
	private String date_calc;
	private String workInfoUserNm;
	private String isUse;
	
	private String transfer_status;
	private String transfer_status_type;
	
	private String first_creat_date;//채권최초등록일
	private String etc_expiration_date;//외담대만기도래일
	private String ebillEmail;//세금계산서 이메일
	
	private String tranStatFlag;//채권 정상여부
	
	private String sum_up;//적요필드
	
	private String rece_sale_status;//입금현황
	
	private String sale_detail;
	
	private String isprepay;
	
	private String payAndDate;
	private String pubcode;
	private String end_sale_date;
	
	public String getIsprepay() {
		return isprepay;
	}
	public void setIsprepay(String isprepay) {
		this.isprepay = isprepay;
	}
	public String getSale_detail() {
		return sale_detail;
	}
	public void setSale_detail(String sale_detail) {
		this.sale_detail = sale_detail;
	}
	public String getRece_sale_status() {
		return rece_sale_status;
	}
	public void setRece_sale_status(String rece_sale_status) {
		this.rece_sale_status = rece_sale_status;
	}
	public String getSum_up() {
		return sum_up;
	}
	public void setSum_up(String sum_up) {
		this.sum_up = sum_up;
	}
	public String getTranStatFlag() {
		return tranStatFlag;
	}
	public void setTranStatFlag(String tranStatFlag) {
		this.tranStatFlag = tranStatFlag;
	}
	public String getEbillEmail() {
		return ebillEmail;
	}
	public void setEbillEmail(String ebillEmail) {
		this.ebillEmail = ebillEmail;
	}
	public String getEtc_expiration_date() {
		return etc_expiration_date;
	}
	public void setEtc_expiration_date(String etc_expiration_date) {
		this.etc_expiration_date = etc_expiration_date;
	}
	public String getFirst_creat_date() {
		return first_creat_date;
	}
	public void setFirst_creat_date(String first_creat_date) {
		this.first_creat_date = first_creat_date;
	}
	public String getTransfer_status_type() {
		return transfer_status_type;
	}
	public void setTransfer_status_type(String transfer_status_type) {
		this.transfer_status_type = transfer_status_type;
	}
	public String getTransfer_status() {
		return transfer_status;
	}
	public void setTransfer_status(String transfer_status) {
		this.transfer_status = transfer_status;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getWorkInfoUserNm() {
		return workInfoUserNm;
	}
	public void setWorkInfoUserNm(String workInfoUserNm) {
		this.workInfoUserNm = workInfoUserNm;
	}
	public String getDate_calc() {
		return date_calc;
	}
	public void setDate_calc(String date_calc) {
		this.date_calc = date_calc;
	}
	public String getEle_etc_date() {
		return ele_etc_date;
	}
	public void setEle_etc_date(String ele_etc_date) {
		this.ele_etc_date = ele_etc_date;
	}
	public String getAutOrderLimitPeriod() {
		return autOrderLimitPeriod;
	}
	public void setAutOrderLimitPeriod(String autOrderLimitPeriod) {
		this.autOrderLimitPeriod = autOrderLimitPeriod;
	}
	public String getExpiration_date() {
		return expiration_date;
	}
	public void setExpiration_date(String expiration_date) {
		this.expiration_date = expiration_date;
	}
	public String getSchedule_date() {
		return schedule_date;
	}
	public void setSchedule_date(String schedule_date) {
		this.schedule_date = schedule_date;
	}
	public String getSchedule_amou() {
		return schedule_amou;
	}
	public void setSchedule_amou(String schedule_amou) {
		this.schedule_amou = schedule_amou;
	}
	public String getTel_user_nm() {
		return tel_user_nm;
	}
	public void setTel_user_nm(String tel_user_nm) {
		this.tel_user_nm = tel_user_nm;
	}
	public String getGood_st_spec_desc() {
		return good_st_spec_desc;
	}
	public void setGood_st_spec_desc(String good_st_spec_desc) {
		this.good_st_spec_desc = good_st_spec_desc;
	}
	public String getGood_spec_desc() {
		return good_spec_desc;
	}
	public void setGood_spec_desc(String good_spec_desc) {
		this.good_spec_desc = good_spec_desc;
	}
	public String getOrde_user_nm() {
		return orde_user_nm;
	}
	public void setOrde_user_nm(String orde_user_nm) {
		this.orde_user_nm = orde_user_nm;
	}
	public String getPayBillTypeNm() {
		return payBillTypeNm;
	}
	public void setPayBillTypeNm(String payBillTypeNm) {
		this.payBillTypeNm = payBillTypeNm;
	}
	public String getOrg_branchid() {
		return org_branchid;
	}
	public void setOrg_branchid(String org_branchid) {
		this.org_branchid = org_branchid;
	}
	public String getOrg_branchnm() {
		return org_branchnm;
	}
	public void setOrg_branchnm(String org_branchnm) {
		this.org_branchnm = org_branchnm;
	}
	public BigDecimal getSum_pay_amou() {
		return sum_pay_amou;
	}
	public void setSum_pay_amou(BigDecimal sum_pay_amou) {
		this.sum_pay_amou = sum_pay_amou;
	}
	public BigDecimal getSum_none_coll_amou() {
		return sum_none_coll_amou;
	}
	public void setSum_none_coll_amou(BigDecimal sum_none_coll_amou) {
		this.sum_none_coll_amou = sum_none_coll_amou;
	}
	public BigDecimal getSum_buyi_tota_amou() {
		return sum_buyi_tota_amou;
	}
	public void setSum_buyi_tota_amou(BigDecimal sum_buyi_tota_amou) {
		this.sum_buyi_tota_amou = sum_buyi_tota_amou;
	}
	public BigDecimal getSum_buyi_requ_amou() {
		return sum_buyi_requ_amou;
	}
	public void setSum_buyi_requ_amou(BigDecimal sum_buyi_requ_amou) {
		this.sum_buyi_requ_amou = sum_buyi_requ_amou;
	}
	public BigDecimal getSum_buyi_requ_vtax() {
		return sum_buyi_requ_vtax;
	}
	public void setSum_buyi_requ_vtax(BigDecimal sum_buyi_requ_vtax) {
		this.sum_buyi_requ_vtax = sum_buyi_requ_vtax;
	}
	public BigDecimal getSum_sale_requ_amou() {
		return sum_sale_requ_amou;
	}
	public void setSum_sale_requ_amou(BigDecimal sum_sale_requ_amou) {
		this.sum_sale_requ_amou = sum_sale_requ_amou;
	}
	public BigDecimal getSum_sale_requ_vtax() {
		return sum_sale_requ_vtax;
	}
	public void setSum_sale_requ_vtax(BigDecimal sum_sale_requ_vtax) {
		this.sum_sale_requ_vtax = sum_sale_requ_vtax;
	}
	public BigDecimal getSum_sale_tota_amou() {
		return sum_sale_tota_amou;
	}
	public void setSum_sale_tota_amou(BigDecimal sum_sale_tota_amou) {
		this.sum_sale_tota_amou = sum_sale_tota_amou;
	}
	public String getBuyi_conf_cnt() {
		return buyi_conf_cnt;
	}
	public void setBuyi_conf_cnt(String buyi_conf_cnt) {
		this.buyi_conf_cnt = buyi_conf_cnt;
	}
	public String getAccManageUserId() {
		return accManageUserId;
	}
	public void setAccManageUserId(String accManageUserId) {
		this.accManageUserId = accManageUserId;
	}
	public String getPay_date() {
		return pay_date;
	}
	public void setPay_date(String pay_date) {
		this.pay_date = pay_date;
	}
	public String getWorkNm() {
		return workNm;
	}
	public void setWorkNm(String workNm) {
		this.workNm = workNm;
	}
	public String getPayCondNm() {
		return payCondNm;
	}
	public void setPayCondNm(String payCondNm) {
		this.payCondNm = payCondNm;
	}
	public String getWorkId() {
		return workId;
	}
	public void setWorkId(String workId) {
		this.workId = workId;
	}
	public String getVendorBusiClas() {
		return vendorBusiClas;
	}
	public void setVendorBusiClas(String vendorBusiClas) {
		this.vendorBusiClas = vendorBusiClas;
	}
	public String getVendorBusiType() {
		return vendorBusiType;
	}
	public void setVendorBusiType(String vendorBusiType) {
		this.vendorBusiType = vendorBusiType;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getBranchBusiClas() {
		return branchBusiClas;
	}
	public void setBranchBusiClas(String branchBusiClas) {
		this.branchBusiClas = branchBusiClas;
	}
	public String getBranchBusiType() {
		return branchBusiType;
	}
	public void setBranchBusiType(String branchBusiType) {
		this.branchBusiType = branchBusiType;
	}
	public String getBuyi_over_month() {
		return buyi_over_month;
	}
	public void setBuyi_over_month(String buyi_over_month) {
		this.buyi_over_month = buyi_over_month;
	}
	public String getBuyi_over_day() {
		return buyi_over_day;
	}
	public void setBuyi_over_day(String buyi_over_day) {
		this.buyi_over_day = buyi_over_day;
	}
	public String getBuyi_pay_date() {
		return buyi_pay_date;
	}
	public void setBuyi_pay_date(String buyi_pay_date) {
		this.buyi_pay_date = buyi_pay_date;
	}
	public String getSale_over_month() {
		return sale_over_month;
	}
	public void setSale_over_month(String sale_over_month) {
		this.sale_over_month = sale_over_month;
	}
	public String getSale_over_day() {
		return sale_over_day;
	}
	public void setSale_over_day(String sale_over_day) {
		this.sale_over_day = sale_over_day;
	}
	public String getSale_pay_date() {
		return sale_pay_date;
	}
	public void setSale_pay_date(String sale_pay_date) {
		this.sale_pay_date = sale_pay_date;
	}
	public String getRecep_alram_id() {
		return recep_alram_id;
	}
	public void setRecep_alram_id(String recep_alram_id) {
		this.recep_alram_id = recep_alram_id;
	}
	public String getRecep_alram_nm() {
		return recep_alram_nm;
	}
	public void setRecep_alram_nm(String recep_alram_nm) {
		this.recep_alram_nm = recep_alram_nm;
	}
	public String getAlram_date() {
		return alram_date;
	}
	public void setAlram_date(String alram_date) {
		this.alram_date = alram_date;
	}
	public String getNone_sale_prod_amou() {
		return none_sale_prod_amou;
	}
	public void setNone_sale_prod_amou(String none_sale_prod_amou) {
		this.none_sale_prod_amou = none_sale_prod_amou;
	}
	public String getIsLimit() {
		return isLimit;
	}
	public void setIsLimit(String isLimit) {
		this.isLimit = isLimit;
	}
	public String getIsLimitStr() {
		return isLimitStr;
	}
	public void setIsLimitStr(String isLimitStr) {
		this.isLimitStr = isLimitStr;
	}
	public String getNone_clos_requ_pric() {
		return none_clos_requ_pric;
	}
	public void setNone_clos_requ_pric(String none_clos_requ_pric) {
		this.none_clos_requ_pric = none_clos_requ_pric;
	}
	public String getNone_clos_purc_pric() {
		return none_clos_purc_pric;
	}
	public void setNone_clos_purc_pric(String none_clos_purc_pric) {
		this.none_clos_purc_pric = none_clos_purc_pric;
	}
	public String getNone_clos_deli_pric() {
		return none_clos_deli_pric;
	}
	public void setNone_clos_deli_pric(String none_clos_deli_pric) {
		this.none_clos_deli_pric = none_clos_deli_pric;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getBankCd() {
		return bankCd;
	}
	public void setBankCd(String bankCd) {
		this.bankCd = bankCd;
	}
	public String getBankNm() {
		return bankNm;
	}
	public void setBankNm(String bankNm) {
		this.bankNm = bankNm;
	}
	public String getPhoneNum() {
		return phoneNum;
	}
	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}
	public String getAddres() {
		return addres;
	}
	public void setAddres(String addres) {
		this.addres = addres;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getPressentNm() {
		return pressentNm;
	}
	public void setPressentNm(String pressentNm) {
		this.pressentNm = pressentNm;
	}
	public String getBalance_amou() {
		return balance_amou;
	}
	public void setBalance_amou(String balance_amou) {
		this.balance_amou = balance_amou;
	}
	public String getAvg_day() {
		return avg_day;
	}
	public void setAvg_day(String avg_day) {
		this.avg_day = avg_day;
	}
	public String getRece_pay_amou() {
		return rece_pay_amou;
	}
	public void setRece_pay_amou(String rece_pay_amou) {
		this.rece_pay_amou = rece_pay_amou;
	}
	public String getNone_paym_amou() {
		return none_paym_amou;
	}
	public void setNone_paym_amou(String none_paym_amou) {
		this.none_paym_amou = none_paym_amou;
	}
	public String getIsPayment() {
		return isPayment;
	}
	public void setIsPayment(String isPayment) {
		this.isPayment = isPayment;
	}
	public String getPay_amou_numb() {
		return pay_amou_numb;
	}
	public void setPay_amou_numb(String pay_amou_numb) {
		this.pay_amou_numb = pay_amou_numb;
	}
	public String getCreat_date() {
		return creat_date;
	}
	public void setCreat_date(String creat_date) {
		this.creat_date = creat_date;
	}
	public String getRece_sequ_num() {
		return rece_sequ_num;
	}
	public void setRece_sequ_num(String rece_sequ_num) {
		this.rece_sequ_num = rece_sequ_num;
	}
	public String getContext() {
		return context;
	}
	public void setContext(String context) {
		this.context = context;
	}
	public String getRece_user_id() {
		return rece_user_id;
	}
	public void setRece_user_id(String rece_user_id) {
		this.rece_user_id = rece_user_id;
	}
	public String getRece_user_nm() {
		return rece_user_nm;
	}
	public void setRece_user_nm(String rece_user_nm) {
		this.rece_user_nm = rece_user_nm;
	}
	public String getIsCollect() {
		return isCollect;
	}
	public void setIsCollect(String isCollect) {
		this.isCollect = isCollect;
	}
	public String getPay_amou() {
		return pay_amou;
	}
	public void setPay_amou(String pay_amou) {
		this.pay_amou = pay_amou;
	}
	public String getNone_coll_amou() {
		return none_coll_amou;
	}
	public void setNone_coll_amou(String none_coll_amou) {
		this.none_coll_amou = none_coll_amou;
	}
	public String getTran_status_nm() {
		return tran_status_nm;
	}
	public void setTran_status_nm(String tran_status_nm) {
		this.tran_status_nm = tran_status_nm;
	}
	public String getTran_sap_jour_date() {
		return tran_sap_jour_date;
	}
	public void setTran_sap_jour_date(String tran_sap_jour_date) {
		this.tran_sap_jour_date = tran_sap_jour_date;
	}
	public String getClos_buyi_date() {
		return clos_buyi_date;
	}
	public void setClos_buyi_date(String clos_buyi_date) {
		this.clos_buyi_date = clos_buyi_date;
	}
	public String getBuyi_conf_date() {
		return buyi_conf_date;
	}
	public void setBuyi_conf_date(String buyi_conf_date) {
		this.buyi_conf_date = buyi_conf_date;
	}
	public String getBuyi_requ_amou() {
		return buyi_requ_amou;
	}
	public void setBuyi_requ_amou(String buyi_requ_amou) {
		this.buyi_requ_amou = buyi_requ_amou;
	}
	public String getBuyi_requ_vtax() {
		return buyi_requ_vtax;
	}
	public void setBuyi_requ_vtax(String buyi_requ_vtax) {
		this.buyi_requ_vtax = buyi_requ_vtax;
	}
	public String getBuyi_tota_amou() {
		return buyi_tota_amou;
	}
	public void setBuyi_tota_amou(String buyi_tota_amou) {
		this.buyi_tota_amou = buyi_tota_amou;
	}
	public String getBusinessNum() {
		return businessNum;
	}
	public void setBusinessNum(String businessNum) {
		this.businessNum = businessNum;
	}
	public String getConf_date() {
		return conf_date;
	}
	public void setConf_date(String conf_date) {
		this.conf_date = conf_date;
	}
	public String getBuyi_prod_quan() {
		return buyi_prod_quan;
	}
	public void setBuyi_prod_quan(String buyi_prod_quan) {
		this.buyi_prod_quan = buyi_prod_quan;
	}
	public String getBuyi_prod_amou() {
		return buyi_prod_amou;
	}
	public void setBuyi_prod_amou(String buyi_prod_amou) {
		this.buyi_prod_amou = buyi_prod_amou;
	}
	public String getDescYn() {
		return descYn;
	}
	public void setDescYn(String descYn) {
		this.descYn = descYn;
	}
	public String getPayBillType() {
		return payBillType;
	}
	public void setPayBillType(String payBillType) {
		this.payBillType = payBillType;
	}
	public String getVendorNm() {
		return vendorNm;
	}
	public void setVendorNm(String vendorNm) {
		this.vendorNm = vendorNm;
	}
	public String getSale_conf_date() {
		return sale_conf_date;
	}
	public void setSale_conf_date(String sale_conf_date) {
		this.sale_conf_date = sale_conf_date;
	}
	public String getOrde_requ_quan() {
		return orde_requ_quan;
	}
	public void setOrde_requ_quan(String orde_requ_quan) {
		this.orde_requ_quan = orde_requ_quan;
	}
	public String getBranchNm() {
		return branchNm;
	}
	public void setBranchNm(String branchNm) {
		this.branchNm = branchNm;
	}
	public String getSale_status_name() {
		return sale_status_name;
	}
	public void setSale_status_name(String sale_status_name) {
		this.sale_status_name = sale_status_name;
	}
	public String getSale_status_code() {
		return sale_status_code;
	}
	public void setSale_status_code(String sale_status_code) {
		this.sale_status_code = sale_status_code;
	}
	public String getSap_jour_numb() {
		return sap_jour_numb;
	}
	public void setSap_jour_numb(String sap_jour_numb) {
		this.sap_jour_numb = sap_jour_numb;
	}
	public String getCons_iden_name() {
		return cons_iden_name;
	}
	public void setCons_iden_name(String cons_iden_name) {
		this.cons_iden_name = cons_iden_name;
	}
	public String getOnns_iden_name() {
		return onns_iden_name;
	}
	public void setOnns_iden_name(String onns_iden_name) {
		this.onns_iden_name = onns_iden_name;
	}
	public String getClientNm() {
		return clientNm;
	}
	public void setClientNm(String clientNm) {
		this.clientNm = clientNm;
	}
	public String getSale_sequ_name() {
		return sale_sequ_name;
	}
	public void setSale_sequ_name(String sale_sequ_name) {
		this.sale_sequ_name = sale_sequ_name;
	}
	public String getCrea_sale_userid() {
		return crea_sale_userid;
	}
	public void setCrea_sale_userid(String crea_sale_userid) {
		this.crea_sale_userid = crea_sale_userid;
	}
	public String getCrea_sale_usernm() {
		return crea_sale_usernm;
	}
	public void setCrea_sale_usernm(String crea_sale_usernm) {
		this.crea_sale_usernm = crea_sale_usernm;
	}
	public String getClos_sale_date() {
		return clos_sale_date;
	}
	public void setClos_sale_date(String clos_sale_date) {
		this.clos_sale_date = clos_sale_date;
	}
	public String getPaym_cond_code() {
		return paym_cond_code;
	}
	public void setPaym_cond_code(String paym_cond_code) {
		this.paym_cond_code = paym_cond_code;
	}
	public String getCrea_sale_date() {
		return crea_sale_date;
	}
	public void setCrea_sale_date(String crea_sale_date) {
		this.crea_sale_date = crea_sale_date;
	}
	public String getSale_requ_amou() {
		return sale_requ_amou;
	}
	public void setSale_requ_amou(String sale_requ_amou) {
		this.sale_requ_amou = sale_requ_amou;
	}
	public String getSale_requ_vtax() {
		return sale_requ_vtax;
	}
	public void setSale_requ_vtax(String sale_requ_vtax) {
		this.sale_requ_vtax = sale_requ_vtax;
	}
	public String getSale_tota_amou() {
		return sale_tota_amou;
	}
	public void setSale_tota_amou(String sale_tota_amou) {
		this.sale_tota_amou = sale_tota_amou;
	}
	public String getSale_prod_amou() {
		return sale_prod_amou;
	}
	public void setSale_prod_amou(String sale_prod_amou) {
		this.sale_prod_amou = sale_prod_amou;
	}
	public String getPurc_prod_pris() {
		return purc_prod_pris;
	}
	public void setPurc_prod_pris(String purc_prod_pris) {
		this.purc_prod_pris = purc_prod_pris;
	}
	public String getOrde_type_clas_nm() {
		return orde_type_clas_nm;
	}
	public void setOrde_type_clas_nm(String orde_type_clas_nm) {
		this.orde_type_clas_nm = orde_type_clas_nm;
	}
	public String getOrder_num() {
		return order_num;
	}
	public void setOrder_num(String order_num) {
		this.order_num = order_num;
	}
	public String getSale_prod_tax() {
		return sale_prod_tax;
	}
	public void setSale_prod_tax(String sale_prod_tax) {
		this.sale_prod_tax = sale_prod_tax;
	}
	public String getPurc_prod_tax() {
		return purc_prod_tax;
	}
	public void setPurc_prod_tax(String purc_prod_tax) {
		this.purc_prod_tax = purc_prod_tax;
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
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getClientId() {
		return clientId;
	}
	public void setClientId(String clientId) {
		this.clientId = clientId;
	}
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
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
	public String getVendorId() {
		return vendorId;
	}
	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
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
	public String getSale_prod_quan() {
		return sale_prod_quan;
	}
	public void setSale_prod_quan(String sale_prod_quan) {
		this.sale_prod_quan = sale_prod_quan;
	}
	public String getSale_prod_pris() {
		return sale_prod_pris;
	}
	public void setSale_prod_pris(String sale_prod_pris) {
		this.sale_prod_pris = sale_prod_pris;
	}
	public String getPurc_prod_amou() {
		return purc_prod_amou;
	}
	public void setPurc_prod_amou(String purc_prod_amou) {
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
	public String getPayAndDate() {
		return payAndDate;
	}
	public void setPayAndDate(String payAndDate) {
		this.payAndDate = payAndDate;
	}
	public String getPubcode() {
		return pubcode;
	}
	public void setPubcode(String pubcode) {
		this.pubcode = pubcode;
	}
	public String getAvg_day2() {
		return avg_day2;
	}
	public void setAvg_day2(String avg_day2) {
		this.avg_day2 = avg_day2;
	}
	public String getEnd_sale_date() {
		return end_sale_date;
	}
	public void setEnd_sale_date(String end_sale_date) {
		this.end_sale_date = end_sale_date;
	}
}
