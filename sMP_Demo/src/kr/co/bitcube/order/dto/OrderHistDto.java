package kr.co.bitcube.order.dto;

/**
 * 주문 히스토리 관련 Dto
 */
public class OrderHistDto {
	/* 주문 SEQ - orde_hist_numb
	 * 주문번호 - orde_iden_numb
	 * 주문차수 - orde_sequ_numb
	 * 발주차수 - purc_iden_numb
	 * 출하차수 - deli_iden_numb
	 * 인수차수 - rece_iden_numb
	 * 변경내용 - chan_cont_desc
	 * 변경사유 - chan_reas_desc
	 * 변경자	  - regi_user_id
	 * 변경일자 - regi_user_date
	 */
	private String orde_hist_numb;
	private String orde_iden_numb;
	private String orde_sequ_numb;
	private String purc_iden_numb;
	private String deli_iden_numb;
	private String rece_iden_numb;
	private String chan_cont_desc;
	private String chan_reas_desc;
	private String regi_user_id;
	private String regi_user_date;
	public String getOrde_hist_numb() {
		return orde_hist_numb;
	}
	public void setOrde_hist_numb(String orde_hist_numb) {
		this.orde_hist_numb = orde_hist_numb;
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
	public String getChan_cont_desc() {
		return chan_cont_desc;
	}
	public void setChan_cont_desc(String chan_cont_desc) {
		this.chan_cont_desc = chan_cont_desc;
	}
	public String getChan_reas_desc() {
		return chan_reas_desc;
	}
	public void setChan_reas_desc(String chan_reas_desc) {
		this.chan_reas_desc = chan_reas_desc;
	}
	public String getRegi_user_id() {
		return regi_user_id;
	}
	public void setRegi_user_id(String regi_user_id) {
		this.regi_user_id = regi_user_id;
	}
	public String getRegi_user_date() {
		return regi_user_date;
	}
	public void setRegi_user_date(String regi_user_date) {
		this.regi_user_date = regi_user_date;
	}
}
