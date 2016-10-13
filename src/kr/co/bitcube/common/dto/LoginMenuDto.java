package kr.co.bitcube.common.dto;

import java.util.List;

public class LoginMenuDto {

	private String menuId;
	private String menuCd;
	private String menuNm;
	private String topMenuId;
	private String parMenuId;
	private String menuLevel;
	private String disOrder;
	private String isFixed;
	private String fwdPath;
	private List<LoginMenuDto> subMenuList;
	
	public List<LoginMenuDto> getSubMenuList() {
		return subMenuList;
	}
	public void setSubMenuList(List<LoginMenuDto> subMenuList) {
		this.subMenuList = subMenuList;
	}
	public String getFwdPath() {
		return fwdPath;
	}
	public void setFwdPath(String fwdPath) {
		this.fwdPath = fwdPath;
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
	public String getDisOrder() {
		return disOrder;
	}
	public void setDisOrder(String disOrder) {
		this.disOrder = disOrder;
	}
	public String getIsFixed() {
		return isFixed;
	}
	public void setIsFixed(String isFixed) {
		this.isFixed = isFixed;
	}
}
