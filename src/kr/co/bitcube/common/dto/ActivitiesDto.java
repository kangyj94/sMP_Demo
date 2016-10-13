package kr.co.bitcube.common.dto;

public class ActivitiesDto {

	private String activityId;
	private String activityCd;
	private String activityNm;
	private String isUse;
	private String scopeNm;
	private String menuNm;
	
	public String getScopeNm() {
		return scopeNm;
	}
	public void setScopeNm(String scopeNm) {
		this.scopeNm = scopeNm;
	}
	public String getActivityId() {
		return activityId;
	}
	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}
	public String getActivityCd() {
		return activityCd;
	}
	public void setActivityCd(String activityCd) {
		this.activityCd = activityCd;
	}
	public String getActivityNm() {
		return activityNm;
	}
	public void setActivityNm(String activityNm) {
		this.activityNm = activityNm;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getMenuNm() {
		return menuNm;
	}
	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}
}
