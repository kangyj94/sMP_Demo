package kr.co.bitcube.product.dto;

import java.util.HashMap;
import java.util.Map;

public class ProductAppGoodDto {
	private String  app_good_id     ;
	private String  chn_price_clas  ;
	private String  good_iden_numb  ;
	private String  good_name       ; 
	private String  fix_good_id     ;
	private String  disp_good_id    ;
	private String  before_price    ;
	private String  after_price     ;
	private String  chn_persent     ; 
	private String  change_reason   ;
	private String  app_sts_flag    ;
	private String  register_userid ;
	private String  register_nm     ;
	private String  register_usernm ;
	private String  register_date   ;
	private String  confirm_userid  ;
	private String  confirm_usernm  ;
	private String  confirm_nm      ;
	private String  confirm_date    ;
	private String  app_userid      ;
	private String  app_usernm      ;
	private String  app_nm          ;
	private String  app_date        ;
	private String  vendorid        ;
	private String  vendornm        ;
	private String  apptypecode     ;
	private String  apptypenm       ;
	private String  appstscode      ;
	private String  appstsnm        ;
	
	
	private String  sale_unit_pric        ;
	public String getApp_good_id() {
		return app_good_id;
	}
	public void setApp_good_id(String app_good_id) {
		this.app_good_id = app_good_id;
	}
	public String getChn_price_clas() {
		return chn_price_clas;
	}
	public void setChn_price_clas(String chn_price_clas) {
		this.chn_price_clas = chn_price_clas;
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
	public String getFix_good_id() {
		return fix_good_id;
	}
	public void setFix_good_id(String fix_good_id) {
		this.fix_good_id = fix_good_id;
	}
	public String getDisp_good_id() {
		return disp_good_id;
	}
	public void setDisp_good_id(String disp_good_id) {
		this.disp_good_id = disp_good_id;
	}
	public String getBefore_price() {
		return before_price;
	}
	public void setBefore_price(String before_price) {
		this.before_price = before_price;
	}
	public String getAfter_price() {
		return after_price;
	}
	public void setAfter_price(String after_price) {
		this.after_price = after_price;
	}
	
	public String getChn_persent() {
		return chn_persent;
	}
	public void setChn_persent(String chn_persent) {
		this.chn_persent = chn_persent;
	}
	public String getChange_reason() {
		return change_reason;
	}
	public void setChange_reason(String change_reason) {
		this.change_reason = change_reason;
	}
	public String getApp_sts_flag() {
		return app_sts_flag;
	}
	public void setApp_sts_flag(String app_sts_flag) {
		this.app_sts_flag = app_sts_flag;
	}
	public String getRegister_userid() {
		return register_userid;
	}
	public void setRegister_userid(String register_userid) {
		this.register_userid = register_userid;
	}
	public String getRegister_nm() {
		return register_nm;
	}
	public void setRegister_nm(String register_nm) {
		this.register_nm = register_nm;
	}
	public String getConfirm_nm() {
		return confirm_nm;
	}
	public void setConfirm_nm(String confirm_nm) {
		this.confirm_nm = confirm_nm;
	}
	public String getRegister_date() {
		return register_date;
	}
	public void setRegister_date(String register_date) {
		this.register_date = register_date;
	}
	public String getConfirm_userid() {
		return confirm_userid;
	}
	public void setConfirm_userid(String confirm_userid) {
		this.confirm_userid = confirm_userid;
	}
	public String getConfirm_date() {
		return confirm_date;
	}
	public void setConfirm_date(String confirm_date) {
		this.confirm_date = confirm_date;
	}
	public String getApp_userid() {
		return app_userid;
	}
	public void setApp_userid(String app_userid) {
		this.app_userid = app_userid;
	}
	public String getApp_nm() {
		return app_nm;
	}
	public void setApp_nm(String app_nm) {
		this.app_nm = app_nm;
	}
	public String getApp_date() {
		return app_date;
	}
	public void setApp_date(String app_date) {
		this.app_date = app_date;
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
	public String getApptypecode() {
		return apptypecode;
	}
	public void setApptypecode(String apptypecode) {
		this.apptypecode = apptypecode;
	}
	public String getApptypenm() {
		return apptypenm;
	}
	public void setApptypenm(String apptypenm) {
		this.apptypenm = apptypenm;
	}
	public String getAppstscode() {
		return appstscode;
	}
	public void setAppstscode(String appstscode) {
		this.appstscode = appstscode;
	}
	public String getAppstsnm() {
		return appstsnm;
	}
	public void setAppstsnm(String appstsnm) {
		this.appstsnm = appstsnm;
	}
	public String getRegister_usernm() {
		return register_usernm;
	}
	public void setRegister_usernm(String register_usernm) {
		this.register_usernm = register_usernm;
	}
	public String getConfirm_usernm() {
		return confirm_usernm;
	}
	public void setConfirm_usernm(String confirm_usernm) {
		this.confirm_usernm = confirm_usernm;
	}
	public String getApp_usernm() {
		return app_usernm;
	}
	public void setApp_usernm(String app_usernm) {
		this.app_usernm = app_usernm;
	}
	
	public Map<String, Object> getParams() {
		Map<String, Object> params = new HashMap<String, Object>(); 
	    params.put("app_good_id",this.getApp_good_id());
		params.put("chn_price_clas",this.getChn_price_clas());
		params.put("good_iden_numb",this.getGood_iden_numb());
		params.put("good_name",this.getGood_name());
		params.put("fix_good_id",this.getFix_good_id());
		params.put("disp_good_id",this.getDisp_good_id());
		params.put("before_price",this.getBefore_price());
		params.put("after_price",this.getAfter_price());
		params.put("chn_persent",this.getChn_persent());
		params.put("change_reason",this.getChange_reason());
		params.put("app_sts_flag",this.getApp_sts_flag());
		params.put("register_userid",this.getRegister_userid());
		params.put("register_nm",this.getRegister_nm());
		params.put("register_date",this.getRegister_date());
		params.put("confirm_userid",this.getConfirm_userid());
		params.put("confirm_nm",this.getConfirm_nm());
		params.put("confirm_date",this.getConfirm_date());
		params.put("app_userid",this.getApp_userid());
		params.put("app_nm",this.getApp_nm());
		params.put("app_date",this.getApp_date());
		params.put("vendorid",this.getVendorid());
		params.put("vendornm",this.getVendornm());
		params.put("apptypecode",this.getApptypecode());
		params.put("apptypenm",this.getApptypenm());
		params.put("appstscode",this.getAppstscode());
		params.put("appstsnm",this.getAppstsnm());

		return params;
	}
	public String getSale_unit_pric() {
		return sale_unit_pric;
	}
	public void setSale_unit_pric(String sale_unit_pric) {
		this.sale_unit_pric = sale_unit_pric;
	}
}
