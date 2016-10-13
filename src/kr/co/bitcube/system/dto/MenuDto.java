package kr.co.bitcube.system.dto;

public class MenuDto {

	private String menuId;
	private String menuCd;
	private String menuNm;
	private String topMenuId;
	private String parMenuId;
	private String menuLevel;
	private String menuLevelName;
	private String disOrder;
	private String svcTypeCd;
	private String isFixed;
	private String isUse;
	private String fwdPath;
	private String scopeNm;
	private String parMenuNm;
	
	public String getParMenuNm() {
		return parMenuNm;
	}
	public void setParMenuNm(String parMenuNm) {
		this.parMenuNm = parMenuNm;
	}
	public String getScopeNm() {
		return scopeNm;
	}
	public void setScopeNm(String scopeNm) {
		this.scopeNm = scopeNm;
	}
	public String getDisOrder() {
		return disOrder;
	}
	public void setDisOrder(String disOrder) {
		this.disOrder = disOrder;
	}
	public String getMenuLevelName() {
		return menuLevelName;
	}
	public void setMenuLevelName(String menuLevelName) {
		this.menuLevelName = menuLevelName;
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
	public String getTopMenuId() {
		return topMenuId;
	}
	public void setTopMenuId(String topMenuId) {
		this.topMenuId = topMenuId;
	}
	public String getParMenuId() {
		return parMenuId;
	}
	public void setParMenuId(String parMenuId) {
		this.parMenuId = parMenuId;
	}
	public String getMenuLevel() {
		return menuLevel;
	}
	public void setMenuLevel(String menuLevel) {
		this.menuLevel = menuLevel;
	}
	public String getSvcTypeCd() {
		return svcTypeCd;
	}
	public void setSvcTypeCd(String svcTypeCd) {
		this.svcTypeCd = svcTypeCd;
	}
	public String getIsFixed() {
		return isFixed;
	}
	public void setIsFixed(String isFixed) {
		this.isFixed = isFixed;
	}
	public String getIsUse() {
		return isUse;
	}
	public void setIsUse(String isUse) {
		this.isUse = isUse;
	}
	public String getFwdPath() {
		return fwdPath;
	}
	public void setFwdPath(String fwdPath) {
		this.fwdPath = fwdPath;
	}
}
