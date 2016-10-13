package kr.co.bitcube.system.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.system.dto.MenuActivityDto;
import kr.co.bitcube.system.dto.RoleDto;
import kr.co.bitcube.system.dto.RoleMemberDto;
import kr.co.bitcube.system.dto.ScopesDto;
import kr.co.bitcube.system.service.RoleSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("system")
public class RoleCtl {

	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private CommonSvc commonSvc;
	@Autowired
	private RoleSvc roleSvc;
	
	@RequestMapping("roleList.sys")
	public ModelAndView roleList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView = new ModelAndView("system/role/roleList");
		modelAndView.addObject("svcTypeCodeList", commonSvc.getCodeList("SVCTYPECD", 1));	//서비스유형
		modelAndView.addObject("borgScopeList", commonSvc.getCodeList("BORGSCOPECD", 1));	//조직허용범위
		return modelAndView;
	}
	
	@RequestMapping("roleListJQGrid.sys")
	public ModelAndView scopeListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "roleId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcSvcTypeCd", defaultValue = "") String srcSvcTypeCd,
			@RequestParam(value = "srcRoleCd", defaultValue = "") String srcRoleCd,
			@RequestParam(value = "srcRoleNm", defaultValue = "") String srcRoleNm,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSvcTypeCd", srcSvcTypeCd);
		params.put("srcRoleCd", srcRoleCd);
		params.put("srcRoleNm", srcRoleNm);
		params.put("srcIsUse", srcIsUse);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
        List<RoleDto> list = roleSvc.getRoleList(params);
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("roleScopeListJQGrid.sys")
	public ModelAndView roleScopeListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "roleId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcSvcTypeCd", required = true) String srcSvcTypeCd,
			@RequestParam(value = "srcRoleId", required = true) String srcRoleId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSvcTypeCd", srcSvcTypeCd);
		params.put("srcRoleId", srcRoleId);
		String orderString = " A." + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
        List<ScopesDto> list = roleSvc.getRoleScopeList(params);
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("saveRoleGrid.sys")
	public ModelAndView saveRoleGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "roleCd", defaultValue = "") String scopeCd,
			@RequestParam(value = "roleNm", defaultValue = "") String scopeNm,
			@RequestParam(value = "roleDesc", defaultValue = "") String scopeDesc,
			@RequestParam(value = "svcTypeCd", defaultValue = "") String svcTypeCd,
			@RequestParam(value = "borgScopeCd", defaultValue = "") String borgScopeCd,
			@RequestParam(value = "isUse", defaultValue = "") String isUse,
			@RequestParam(value = "id", defaultValue = "") String roleId,
			@RequestParam(value = "initIsRole", defaultValue = "") String initIsRole,
			@RequestParam(value = "initBorgScopeCd", defaultValue = "") String initBorgScopeCd,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("roleCd", scopeCd);
		saveMap.put("roleNm", scopeNm);
		saveMap.put("roleDesc", scopeDesc);
		saveMap.put("svcTypeCd", svcTypeCd);
		saveMap.put("borgScopeCd", borgScopeCd);
		saveMap.put("isUse", isUse);
		saveMap.put("initIsRole", initIsRole);
		saveMap.put("initBorgScopeCd", initBorgScopeCd);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				roleSvc.regRole(saveMap);
			} else if("edit".equals(oper)) {
				saveMap.put("roleId", roleId);
				roleSvc.modRole(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("roleId", roleId);
				roleSvc.delRole(saveMap);
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
	
	@RequestMapping(value = "connectRoleGrid.sys", method = RequestMethod.POST)
	public ModelAndView connectRoleGrid(
			@RequestParam(value = "roleId", required = true) String roleId,
			@RequestParam(value="connectRowKey[]", required=false) String[] connectRowKey,
			@RequestParam(value="unConnectRowKey[]", required=false) String[] unConnectRowKey,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {

		/*----------------저장값 세팅------------*/
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("roleId", roleId);
		paramMap.put("connectRowKey", connectRowKey);
		paramMap.put("unConnectRowKey", unConnectRowKey);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			roleSvc.connectRole(paramMap);
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
	
	@RequestMapping("roleTree.sys")
	public ModelAndView roleTree(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView = new ModelAndView("system/role/roleTree");
		return modelAndView;
	}
	
	@RequestMapping("roleTreeJQGrid.sys")
	public ModelAndView roleTreeJQGrid(
			@RequestParam(value = "nodeid", defaultValue = "") String nodeid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
		if(nodeid==null || "".equals(nodeid)) {
			List<CodesDto> codeList = commonSvc.getCodeList("SVCTYPECD", 1);
			for(CodesDto codeDto : codeList) {
				Map<String, Object> returnMap = new HashMap<String, Object>();
				returnMap.put("name", codeDto.getCodeNm1());
				returnMap.put("typeName", "");
				returnMap.put("treeKey", "CODE∥"+codeDto.getCodeVal1());

				returnMap.put("level", 0);
				
				returnList.add(returnMap);
			}
		} else if(nodeid.split("∥").length>1) {
			String treeFlag = nodeid.split("∥")[0];
			String treeKey = nodeid.split("∥")[1];
			if("CODE".equals(treeFlag)) {	//권한정보 List 가져오기
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("srcSvcTypeCd", treeKey);
				params.put("srcIsUse", 1);
				String orderString = " ROLENM  ASC ";
				params.put("orderString", orderString);
				List<RoleDto> roleList = roleSvc.getRoleList(params);
				for(RoleDto roleDto : roleList) {
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap.put("name", roleDto.getRoleNm());
					returnMap.put("typeName", "권한");
					returnMap.put("treeKey", "ROLE∥"+roleDto.getRoleId());

					returnMap.put("parent", nodeid);
					returnMap.put("level", 1);
					
					returnList.add(returnMap);
				}
			} else if("ROLE".equals(treeFlag)) {	//영역정보 List 가져오기
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("roleId", treeKey);
				List<ScopesDto> scopeList = roleSvc.getScopeListByRoleId(params);
				for(ScopesDto scopeDto : scopeList) {
					Map<String, Object> returnMap = new HashMap<String, Object>();
					returnMap.put("name", scopeDto.getScopeNm());
					returnMap.put("typeName", "영역");
					returnMap.put("treeKey", "SCOPE∥"+scopeDto.getScopeId()+"∥"+treeKey);

					returnMap.put("parent", nodeid);
					returnMap.put("level", 2);
					returnMap.put("isLeaf", true);
					
					returnList.add(returnMap);
				}
			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list",returnList);
		return modelAndView;
	}
	
	@RequestMapping("roleMenuListJQGrid.sys")
	public ModelAndView roleMenuListJQGrid(
			@RequestParam(value = "srcId", required = true) String srcId,
			@RequestParam(value = "srcSrcFlag", required = true) String srcSrcFlag,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSrcFlag", srcSrcFlag);
		params.put("srcId", srcId);
		
		/*----------------조회------------*/
        List<MenuActivityDto> list = new ArrayList<MenuActivityDto>();
        if(!"".equals(srcSrcFlag)) {	//권한및 메뉴을 선택하지 않을 경우는 가져오지 않음
        	list = roleSvc.getRoleMenuList(params);
        }
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("roleMember.sys")
	public ModelAndView roleMember(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView = new ModelAndView("system/role/roleMember");
		modelAndView.addObject("borgScopeList", commonSvc.getCodeList("BORGSCOPECD", 1));	//허용조직범위
//		modelAndView.addObject("svcTypeList", commonSvc.getCodeList("SVCTYPECD", 1));	//서비스유형
		return modelAndView;
	}
	
	@RequestMapping("roleMemberTreeJQGrid.sys")
	public ModelAndView roleMemberTreeJQGrid(
			@RequestParam(value = "nodeid", defaultValue = "") String nodeid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
		if(nodeid==null || "".equals(nodeid)) {	//서비스유형 리스트
			List<CodesDto> codeList = commonSvc.getCodeList("SVCTYPECD", 1);
			for(CodesDto codeDto : codeList) {
				Map<String, Object> returnMap = new HashMap<String, Object>();
				returnMap.put("name", codeDto.getCodeNm1());
				returnMap.put("borgScopeCd", "");
				returnMap.put("svcTypeCd", "");
				returnMap.put("svcTypeNm", "");
				returnMap.put("treeKey", codeDto.getCodeVal1());
				returnMap.put("level", 0);
				returnList.add(returnMap);
			}
		} else {	//서비스유형에 따른 권한리스트
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("srcSvcTypeCd", nodeid);
			params.put("srcIsUse", 1);
			String orderString = " ROLENM  ASC ";
			params.put("orderString", orderString);
			List<RoleDto> roleList = roleSvc.getRoleList(params);
			for(RoleDto roleDto : roleList) {
				Map<String, Object> returnMap = new HashMap<String, Object>();
				returnMap.put("name", roleDto.getRoleNm());
				returnMap.put("borgScopeCd", roleDto.getBorgScopeCd());
				returnMap.put("svcTypeCd", nodeid);
				returnMap.put("svcTypeNm", roleDto.getSvcTypeNm());
				returnMap.put("treeKey", roleDto.getRoleId());
				returnMap.put("level", 1);

				returnMap.put("parent", nodeid);
				returnMap.put("isLeaf", true);
				returnList.add(returnMap);
			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list",returnList);
		return modelAndView;
	}
	
	@RequestMapping("roleMemberListJQGrid.sys")
	public ModelAndView roleMemberListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "srcRoleId", required = true) String srcRoleId,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsDefault", defaultValue = "") String srcIsDefault,
			@RequestParam(value = "sidx", defaultValue = "BORGNMS") String sidx,
			@RequestParam(value = "sord", defaultValue = "ASC") String sord,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcRoleId", srcRoleId);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsDefault", srcIsDefault);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = roleSvc.getRoleMemberListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        
        /*----------------조회------------*/
        List<RoleMemberDto> list = null;
        if(records>0) {
        	list = roleSvc.getRoleMemberList(params, page, rows);
        }
        
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("roleMemberCheck.sys")
	public ModelAndView roleMemberCheck(
			@RequestParam(value = "roleId", required = true) String roleId,
			@RequestParam(value = "userId", required = true) String userId,
			@RequestParam(value = "borgId", required = true) String borgId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {

		/*----------------저장값 세팅------------*/
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("roleId", roleId);
		paramMap.put("userId", userId);
		paramMap.put("borgId", borgId);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		int roleUserCnt = roleSvc.getRoleUserCnt(paramMap);
		if(roleUserCnt>0) {
			logger.error("Exception : 중복된 사용자 -> "+paramMap);
			custResponse.setSuccess(false);
			custResponse.setMessage("이미 등록된 사용자입니다.");
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	@RequestMapping("saveUserRoleGrid.sys")
	public ModelAndView saveUserRoleGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "roleId", required = true) String roleId,
			@RequestParam(value = "userId", required = true) String userId,
			@RequestParam(value = "borgId", required = true) String borgId,
			@RequestParam(value = "borgScopeCd", defaultValue = "") String borgScopeCd,
			@RequestParam(value = "isDefault", defaultValue = "0") String isDefault,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("roleId", roleId);
		saveMap.put("userId", userId);
		saveMap.put("borgId", borgId);
		saveMap.put("borgScopeCd", borgScopeCd);
		saveMap.put("isDefault", isDefault);
		
		/*----------------처리수행 및 성공여부 세팅------------*/ 
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				roleSvc.regUserRole(saveMap);
			} else if("edit".equals(oper)) {
				roleSvc.modUserRole(saveMap);
			} else if("del".equals(oper)) {
				roleSvc.delUserRole(saveMap);
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
}
