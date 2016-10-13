package kr.co.bitcube.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.system.dto.MenuActivityDto;
import kr.co.bitcube.system.dto.ScopesDto;
import kr.co.bitcube.system.service.ScopeSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("system")
public class ScopeCtl {

	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private CommonSvc commonSvc;
	@Autowired
	private ScopeSvc scopeSvc;
	
	@RequestMapping("scopeList.sys")
	public ModelAndView scopeList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView = new ModelAndView("system/scope/scopeList");
		modelAndView.addObject("svcTypeCodeList", commonSvc.getCodeList("SVCTYPECD", 1));
		return modelAndView;
	}
	
	@RequestMapping("scopeListJQGrid.sys")
	public ModelAndView scopeListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "scopeId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcSvcTypeCd", defaultValue = "") String srcSvcTypeCd,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSvcTypeCd", srcSvcTypeCd);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
        List<ScopesDto> list = scopeSvc.getScopeList(params);
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("saveScopeGrid.sys")
	public ModelAndView saveScopeGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "scopeCd", defaultValue = "") String scopeCd,
			@RequestParam(value = "scopeNm", defaultValue = "") String scopeNm,
			@RequestParam(value = "scopeDesc", defaultValue = "") String scopeDesc,
			@RequestParam(value = "svcTypeCd", defaultValue = "") String svcTypeCd,
			@RequestParam(value = "isUse", defaultValue = "") String isUse,
			@RequestParam(value = "id", defaultValue = "") String scopeId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("scopeCd", scopeCd);
		saveMap.put("scopeNm", scopeNm);
		saveMap.put("scopeDesc", scopeDesc);
		saveMap.put("svcTypeCd", svcTypeCd);
		saveMap.put("isUse", isUse);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				scopeSvc.regScope(saveMap);
			} else if("edit".equals(oper)) {
				saveMap.put("scopeId", scopeId);
				scopeSvc.modScope(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("scopeId", scopeId);
				scopeSvc.delScope(saveMap);
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
	
	@RequestMapping("scopeMenuActivityListJQGrid.sys")
	public ModelAndView scopeMenuActivityListJQGrid(
			@RequestParam(value = "srcScopeId", required = true) String srcScopeId,
			@RequestParam(value = "srcSvcTypeCd", required = true) String srcSvcTypeCd,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSvcTypeCd", srcSvcTypeCd);
		params.put("srcScopeId", srcScopeId);
		
		/*----------------조회------------*/
        List<MenuActivityDto> list = scopeSvc.getScopeMenuActivityList(params);
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping(value = "connectScopeGrid.sys", method = RequestMethod.POST)
	public ModelAndView connectScopeGrid(
			@RequestParam(value = "scopeId", required = true) String scopeId,
			@RequestParam(value="connectRowKey[]", required=false) String[] connectRowKey,
			@RequestParam(value="unConnectRowKey[]", required=false) String[] unConnectRowKey,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {

		/*----------------저장값 세팅------------*/
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("scopeId", scopeId);
		paramMap.put("connectRowKey", connectRowKey);
		paramMap.put("unConnectRowKey", unConnectRowKey);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			scopeSvc.connectScope(paramMap);
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
	
	
}
