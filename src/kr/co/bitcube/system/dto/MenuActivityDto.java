package kr.co.bitcube.system.dto;

public class MenuActivityDto {

	private String menuId;
	private String menuCd;
	private String menuNm;
	private String activityId;
	private String activityCd;
	private String activityNm;
	private String menuIsUse;
	private String activityIsUse;
	private String isCheck;
	private String menuLevelName;
	private String isFixed;
	private String menuLevel;
	
	public String getMenuLevel() {
		return menuLevel;
	}
	public void setMenuLevel(String menuLevel) {
		this.menuLevel = menuLevel;
	}
	public String getIsFixed() {
		return isFixed;
	}
	public void setIsFixed(String isFixed) {
		this.isFixed = isFixed;
	}
	public String getMenuLevelName() {
		return menuLevelName;
	}
	public void setMenuLevelName(String menuLevelName) {
		this.menuLevelName = menuLevelName;
	}
	public String getIsCheck() {
		return isCheck;
	}
	public void setIsCheck(String isCheck) {
		this.isCheck = isCheck;
	}
	public String getMenuIsUse() {
		return menuIsUse;
	}
	public void setMenuIsUse(String menuIsUse) {
		this.menuIsUse = menuIsUse;
	}
	public String getActivityIsUse() {
		return activityIsUse;
	}
	public void setActivityIsUse(String activityIsUse) {
		this.activityIsUse = activityIsUse;
	}
	public String getMenuId() {
		return menuId;
	}
	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}
	public String getMenuCd() {
		return menuCd;
	}
	public void setMenuCd(String menuCd) {
		this.menuCd = menuCd;
	}
	public String getMenuNm() {
		return menuNm;
	}
	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
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
}
