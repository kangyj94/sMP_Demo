package kr.co.bitcube.product.dto;

public class ProductDispDto {
	private String disp_good_id        ;
	private String groupid             ;
	private String groupnm             ;
	private String clientid            ;
	private String clientnm            ;
	private String branchid            ;
	private String branchnm            ;
	private String vendorid            ;
	private String vendornm            ;
	private String cont_from_date      ;
	private String cont_to_date        ;
	private String disp_from_date      ; 
	private String disp_to_date        ; 
	private String ispast_sell_flag    ;
	private double sale_unit_pric      ;
	private double sell_price          ;
	private String cust_good_iden_numb ;
	private String fullborgnms         ;
	private int    dispcnt             ;
	private String areatype 		   ; 
	private String areanm              ;
	
	private String dispAppFlag         ; // 판가 승인요부   
	private String prodvendorAppFlag   ; // 품목 공급사 승인여부 
	
	
	public String getDisp_good_id() {
		return disp_good_id;
	}
	public void setDisp_good_id(String disp_good_id) {
		this.disp_good_id = disp_good_id;
	}
	public String getGroupid() {
		return groupid;
	}
	public void setGroupid(String groupid) {
		this.groupid = groupid;
	}
	public String getGroupnm() {
		return groupnm;
	}
	public void setGroupnm(String groupnm) {
		this.groupnm = groupnm;
	}
	public String getClientid() {
		return clientid;
	}
	public void setClientid(String clientid) {
		this.clientid = clientid;
	}
	public String getClientnm() {
		return clientnm;
	}
	public void setClientnm(String clientnm) {
		this.clientnm = clientnm;
	}
	public String getBranchid() {
		return branchid;
	}
	public void setBranchid(String branchid) {
		this.branchid = branchid;
	}
	public String getBranchnm() {
		return branchnm;
	}
	public void setBranchnm(String branchnm) {
		this.branchnm = branchnm;
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
	public String getCont_from_date() {
		return cont_from_date;
	}
	public void setCont_from_date(String cont_from_date) {
		this.cont_from_date = cont_from_date;
	}
	public String getCont_to_date() {
		return cont_to_date;
	}
	public void setCont_to_date(String cont_to_date) {
		this.cont_to_date = cont_to_date;
	}
	public String getDisp_from_date() {
		return disp_from_date;
	}
	public void setDisp_from_date(String disp_from_date) {
		this.disp_from_date = disp_from_date;
	}
	public String getDisp_to_date() {
		return disp_to_date;
	}
	public void setDisp_to_date(String disp_to_date) {
		this.disp_to_date = disp_to_date;
	}
	public String getIspast_sell_flag() {
		return ispast_sell_flag;
	}
	public void setIspast_sell_flag(String ispast_sell_flag) {
		this.ispast_sell_flag = ispast_sell_flag;
	}
	public double getSale_unit_pric() {
		return sale_unit_pric;
	}
	public void setSale_unit_pric(double sale_unit_pric) {
		this.sale_unit_pric = sale_unit_pric;
	}
	public double getSell_price() {
		return sell_price;
	}
	public void setSell_price(double sell_price) {
		this.sell_price = sell_price;
	}
	public String getCust_good_iden_numb() {
		return cust_good_iden_numb;
	}
	public void setCust_good_iden_numb(String cust_good_iden_numb) {
		this.cust_good_iden_numb = cust_good_iden_numb;
	}
	public String getFullborgnms() {
		return fullborgnms;
	}
	public void setFullborgnms(String fullborgnms) {
		this.fullborgnms = fullborgnms;
	}
	public int getDispcnt() {
		return dispcnt;
	}
	public void setDispcnt(int dispcnt) {
		this.dispcnt = dispcnt;
	}
	public String getDispAppFlag() {
		return dispAppFlag;
	}
	public void setDispAppFlag(String dispAppFlag) {
		this.dispAppFlag = dispAppFlag;
	}
	public String getProdvendorAppFlag() {
		return prodvendorAppFlag;
	}
	public void setProdvendorAppFlag(String prodvendorAppFlag) {
		this.prodvendorAppFlag = prodvendorAppFlag;
	}
	public String getAreatype() {
		return areatype;
	}
	public void setAreatype(String areatype) {
		this.areatype = areatype;
	}
	public String getAreanm() {
		return areanm;
	}
	public void setAreanm(String areanm) {
		this.areanm = areanm;
	}
}
