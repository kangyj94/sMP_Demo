package kr.co.bitcube.system.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.common.dto.ActivitiesDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.system.dto.MenuDto;
import kr.co.bitcube.system.service.MenuActivitySvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("system")
public class MenuActivityCtl {

	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private CommonSvc commonSvc;
	@Autowired
	private MenuActivitySvc menuActivitySvc;
	
	@RequestMapping("menuActivityList.sys")
	public ModelAndView menuActivityList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView = new ModelAndView("system/menuActivity/menuActivityList");
		modelAndView.addObject("svcTypeCodeList", commonSvc.getCodeList("SVCTYPECD", 1));
		return modelAndView;
	}
	
	@RequestMapping("menuListJQGrid.sys")
	public ModelAndView menuListJQGrid(
			@RequestParam(value = "srcSvcTypeCd", defaultValue = "") String srcSvcTypeCd,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회------------*/
        List<MenuDto> list = menuActivitySvc.getMenuList(srcSvcTypeCd);
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("menuTransGrid.sys")
	public ModelAndView menuTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "parMenuId", defaultValue = "") String parMenuId,
			@RequestParam(value = "menuCd", defaultValue = "") String menuCd,
			@RequestParam(value = "menuNm", defaultValue = "") String menuNm,
			@RequestParam(value = "svcTypeCd", defaultValue = "") String svcTypeCd,
			@RequestParam(value = "disOrder", defaultValue = "") String disOrder,
			@RequestParam(value = "isUse", defaultValue = "") String isUse,
			@RequestParam(value = "fwdPath", defaultValue = "") String fwdPath,
			@RequestParam(value = "isFixed", defaultValue = "") String isFixed,
			@RequestParam(value = "id", defaultValue = "") String menuId,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("menuId", menuId);
		saveMap.put("menuCd", menuCd);
		saveMap.put("menuNm", menuNm);
		saveMap.put("parMenuId", parMenuId);
		saveMap.put("disOrder", disOrder);
		saveMap.put("svcTypeCd", svcTypeCd);
		saveMap.put("isFixed", isFixed);
		saveMap.put("isUse", isUse);
		saveMap.put("fwdPath", fwdPath);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				menuActivitySvc.regMenu(saveMap);
			} else if("edit".equals(oper)) {
				menuActivitySvc.modMenu(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("menuId", menuId);
				menuActivitySvc.delMenu(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	@RequestMapping("activityListJQGrid.sys")
	public ModelAndView activityListJQGrid(
			@RequestParam(value = "srcMenuId", required = true) String srcMenuId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회------------*/
        List<ActivitiesDto> list = new ArrayList<ActivitiesDto>();
        //서비스유형 메뉴일경우 조회를 안함
        if(!"0".equals(srcMenuId)) list = menuActivitySvc.getActivityList(srcMenuId);
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("unActivityListJQGrid.sys")
	public ModelAndView unActivityListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "10") int rows,
			@RequestParam(value = "srcMenuId", required = true) String srcMenuId,
			@RequestParam(value = "_search", defaultValue = "false") boolean _search,
			@RequestParam(value = "searchOper", defaultValue = "") String searchOper,
			@RequestParam(value = "searchString", defaultValue = "") String searchString,
			@RequestParam(value = "searchField", defaultValue = "") String searchField,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcMenuId", srcMenuId);
		if(_search){
			String soptSignString = CommonUtils.getStringSoptSign(searchOper, searchString);
			params.put("soptSignString", soptSignString);
			params.put("searchField",    searchField);
			params.put("searchString",   searchString);
		}

		/*----------------페이징 세팅------------*/
        int records = menuActivitySvc.getUnActivityListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        
		/*----------------조회------------*/
		List<ActivitiesDto> list = null;
		if(records>0) {
			list = menuActivitySvc.getUnActivityList(params, page, rows);
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("menuActivityTransGrid.sys")
	public ModelAndView menuActivityTransGrid(
			@RequestParam(value = "srcMenuId", required = true) String srcMenuId,
			@RequestParam(value = "srcActivityId", required = true) String srcActivityId,
			@RequestParam(value = "transFlag", required = true) String transFlag,
			@RequestParam(value = "delTransScope", defaultValue = "false") boolean delTransScope,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("srcMenuId", srcMenuId);
		saveMap.put("srcActivityId", srcActivityId);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("REG".equals(transFlag)) {
				menuActivitySvc.regMenuActivity(saveMap);
			} else if("DEL".equals(transFlag)) {
				saveMap.put("delTransScope", delTransScope);
				menuActivitySvc.delMenuActivity(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	@RequestMapping("activityTransGrid.sys")
	public ModelAndView activityTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "activityCd", defaultValue = "") String activityCd,
			@RequestParam(value = "activityNm", defaultValue = "") String activityNm,
			@RequestParam(value = "isUse", defaultValue = "") String isUse,
			@RequestParam(value = "id", defaultValue = "") String activityId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("activityCd", activityCd);
		saveMap.put("activityNm", activityNm);
		saveMap.put("isUse", isUse);
		saveMap.put("activityId", activityId);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				menuActivitySvc.regActivity(saveMap);
			} else if("edit".equals(oper)) {
				menuActivitySvc.modActivity(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("activityId", activityId);
				menuActivitySvc.delActivity(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 메인 경영 페이지의 메뉴링크 
	 */
	@RequestMapping("menuTransfer.sys")
	public ModelAndView menuTransfer (
			@RequestParam(value = "menuCd", required=true) String menuCd,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("menuCd", menuCd);
		Map<String, Object> menuInfo = menuActivitySvc.getMenuPath(params);
		modelAndView.addObject("menuInfo", menuInfo);
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
}
