package kr.co.bitcube.system.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.BorgDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.dto.WorkInfoDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.system.service.BorgSvc;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping("system")
public class BorgCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired private BorgSvc    borgSvc;
	@Autowired private CommonSvc  commonSvc;
	@Autowired private GeneralDao generalDao;
	
	@RequestMapping("groupClientList.sys")
	public ModelAndView groupClientList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("system/borg/groupClientList");
		return modelAndView;
	}
	
	@RequestMapping("borgUserTransGrid.sys")
	public ModelAndView borgUserTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "topBorgId", defaultValue = "") String topBorgId,
			@RequestParam(value = "borgTypeCd", defaultValue = "") String borgTypeCd,
			@RequestParam(value = "parBorgId", defaultValue = "") String parBorgId,
			@RequestParam(value = "svcTypeCd", defaultValue = "") String svcTypeCd,
			@RequestParam(value = "groupId", defaultValue = "") String groupId,
			@RequestParam(value = "clientId", defaultValue = "") String clientId,
			@RequestParam(value = "branchId", defaultValue = "") String branchId,
			@RequestParam(value = "deptId", defaultValue = "") String deptId,
			@RequestParam(value = "borgId", defaultValue = "") String borgId,
			@RequestParam(value = "borgNm", defaultValue = "") String borgNm,
			@RequestParam(value = "borgCd", defaultValue = "") String borgCd,
			@RequestParam(value = "isUse", defaultValue = "") String isUse,
			@RequestParam(value = "borgLevel", defaultValue = "") String borgLevel,
			@RequestParam(value = "id", defaultValue = "") String idBorgId,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("borgNm", borgNm);
		saveMap.put("isUse", isUse);
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		saveMap.put("creatorId", loginUserDto.getUserId());
		saveMap.put("updaterId", loginUserDto.getUserId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				saveMap.put("borgCd", borgCd);
				saveMap.put("topBorgId", topBorgId);
				saveMap.put("parBorgId", parBorgId);
				saveMap.put("borgTypeCd", borgTypeCd);
				saveMap.put("svcTypeCd", svcTypeCd);
				saveMap.put("groupId", groupId);
				saveMap.put("clientId", clientId);
				saveMap.put("branchId", branchId);
				saveMap.put("deptId", deptId);
				saveMap.put("borgLevel", borgLevel);
				
				borgSvc.regBorg(saveMap);
			} else if("edit".equals(oper)) {
				saveMap.put("borgId", borgId);
				
				borgSvc.modBorg(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				borgId = idBorgId.split("∥")[0];
				saveMap.put("borgId", borgId);
				borgSvc.delBorg(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	@RequestMapping("borgUserListJQGrid.sys")
	public ModelAndView borgUserListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "borgNms") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "borgTypeCd", defaultValue = "") String borgTypeCd,
			@RequestParam(value = "borgId", required = true) String borgId,
			@RequestParam(value = "isLeaf", required = true) boolean isLeaf,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsLogin", defaultValue = "1") String srcIsLogin,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,
			@RequestParam(value = "svcTypeCd", defaultValue = "BUY") String svcTypeCd,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("svcTypeCd", svcTypeCd);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsLogin", srcIsLogin);
		params.put("srcIsUse", srcIsUse);
		if(isLeaf) {	//마지막 조직일 경우
			params.put("borgId", borgId);
		} else {
			if("GRP".equals(borgTypeCd)) params.put("groupId", borgId);
			else if("CLT".equals(borgTypeCd)) params.put("clientId", borgId);
			else if("BCH".equals(borgTypeCd)) params.put("branchId", borgId);
			else if("DEP".equals(borgTypeCd)) params.put("deptId", borgId);
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = borgSvc.getBorgUserListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<UserDto> list = null;
        if(records>0) {
        	list = borgSvc.getBorgUserList(params, page, rows);
        }
        
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	
	@RequestMapping("manageBorgList.sys")
	public ModelAndView manageBorgList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("svcTypeCd", "ADM");
		searchMap.put("borgTypeCd", "BCH");
		searchMap.put("isUse", "1");
		modelAndView.setViewName("system/borg/manageBorgList");
		modelAndView.addObject("adminBorgList", borgSvc.getBorgTreeList(searchMap));
		modelAndView.addObject("workInfoList", commonSvc.getCodeList("SMPWORKINFO_CODE_MID", 1));
		modelAndView.addObject("contractCdList", commonSvc.getCodeList("CONTRACT_SPECIAL", 1));
		return modelAndView;
	}
	
	@RequestMapping("userTransGrid.sys")
	public ModelAndView userTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "borgId", defaultValue = "") String borgId,
			@RequestParam(value = "userNm", defaultValue = "") String userNm,
			@RequestParam(value = "loginId", defaultValue = "") String loginId,
			@RequestParam(value = "password", defaultValue = "") String password,
			@RequestParam(value = "pwd", defaultValue = "") String pwd,
			@RequestParam(value = "tel", defaultValue = "") String tel,
			@RequestParam(value = "mobile", defaultValue = "") String mobile,
			@RequestParam(value = "email", defaultValue = "") String email,
			@RequestParam(value = "isLogin", defaultValue = "") String isLogin,
			@RequestParam(value = "isUse", defaultValue = "") String isUse,
			@RequestParam(value = "svcTypeCd", defaultValue = "") String svcTypeCd,
			@RequestParam(value = "id", defaultValue = "") String userId,
			@RequestParam(value = "isEmail", defaultValue = "0") String isEmail,
			@RequestParam(value = "isSms", defaultValue = "0") String isSms,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("borgId", borgId);
		saveMap.put("userNm", userNm);
		saveMap.put("tel", tel);
		saveMap.put("mobile", mobile);
		saveMap.put("email", email);
		saveMap.put("isLogin", isLogin);
		saveMap.put("isUse", isUse);
		saveMap.put("svcTypeCd", svcTypeCd);
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		saveMap.put("creatorId", loginUserDto.getUserId());
		saveMap.put("updaterId", loginUserDto.getUserId());
		saveMap.put("isEmail", isEmail);
		saveMap.put("isSms", isSms);
		if(!"".equals(password)) {
			saveMap.put("pwd", password);
		} else {
			saveMap.put("pwd", pwd);
		}
		
		
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				saveMap.put("loginId", loginId);
				saveMap.put("isBorgDefault", "1");
				saveMap.put("isRoleDefault", "0");
				commonSvc.regUser(saveMap);
			} else if("edit".equals(oper)) {
				saveMap.put("userId", userId);
				commonSvc.modUser(saveMap);
			} else if("addSys".equals(oper)) {	//운영사용자을 시스템사용자로 추가등록
				saveMap.put("userId", userId);
				saveMap.put("loginId", loginId);
				saveMap.put("isBorgDefault", "0");
				saveMap.put("isRoleDefault", "0");
				borgSvc.regSysUser(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,100));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	@RequestMapping("borgUserManageListJQGrid.sys")
	public ModelAndView borgUserManageListJQGrid(
			@RequestParam(value = "userId", required = true) String userId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {

		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		
		/*----------------조회------------*/
        List<BorgDto> list = borgSvc.getManagedBorgList(params);
        
        modelAndView.setViewName("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("manageBorgTransGrid.sys")
	public ModelAndView manageBorgTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "manageBorgIdArray[]", required=false) String[] manageBorgIdArray,
			@RequestParam(value = "userId", defaultValue = "") String userId,
			@RequestParam(value = "id", defaultValue = "") String adminBorgId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("manageBorgIdArray", manageBorgIdArray);
		saveMap.put("userId", userId);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				borgSvc.regBorgManager(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("adminBorgId", adminBorgId);
				borgSvc.delBorgManager(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	@RequestMapping("sysVendorList.sys")
	public ModelAndView sysnVendorList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("system/borg/sysVendorList");
		return mav;
	}
	
	@RequestMapping("systemUserManagerList.sys")
	public ModelAndView systemUserManagerList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("system/borg/systemUserManagerList");
		return mav;
	}
	
	@RequestMapping("systemUserManagerListJQGrid.sys")
	public ModelAndView systemUserManagerListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "createDate") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcSvcTypeCd", defaultValue = "") String srcSvcTypeCd,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsUse", defaultValue = "") String srcIsUse,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSvcTypeCd", srcSvcTypeCd);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsUse", srcIsUse);
		if("loginId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = borgSvc.getSystemUserManagerListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<Map<String, Object>> list = null;
        if(records>0) list = borgSvc.getSystemUserManagerList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공사유형 추가
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("workInfoTransGrid.sys")
	public ModelAndView workInfoTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "userId", defaultValue = "") String userId,
			@RequestParam(value = "workId", defaultValue = "") String workId,
			@RequestParam(value = "workNm", required = true) String workNm,
			@RequestParam(value = "mat_kind", required = true) String mat_kind,
			@RequestParam(value = "contract_cd", required = true) String contract_cd,
			@RequestParam(value = "isSktsManage", defaultValue = "1") String isSktsManage,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				saveMap.put("userId", userId);
				saveMap.put("workNm", workNm);
				saveMap.put("mat_kind", mat_kind);
				saveMap.put("contract_cd", contract_cd);
				saveMap.put("isSktsManage", isSktsManage);
				commonSvc.insertWorkInfo(saveMap);
			} else if("edit".equals(oper)) {

			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,100));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}	
	
	@RequestMapping("workInfoListJQGrid.sys")
	public ModelAndView workInfoListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "workNm") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> params = new HashMap<String,Object>();
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        List<WorkInfoDto> list = commonSvc.selectWorkInfo(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 공사유형 수정
	 */
	@RequestMapping("updateWorkInfo.sys")
	public ModelAndView updateWorkInfo(
			@RequestParam(value = "workId", required = true) String workId,
			@RequestParam(value = "workNm", required = true) String workNm,
			@RequestParam(value = "mat_kind", required = true) String mat_kind,
			@RequestParam(value = "contract_cd", required = true) String contract_cd,
			@RequestParam(value = "isSktsManage", defaultValue = "1") String isSktsManage,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			saveMap.put("workId", workId);
			saveMap.put("workNm", workNm);
			saveMap.put("mat_kind", mat_kind);
			saveMap.put("contract_cd", contract_cd);
			saveMap.put("isSktsManage", isSktsManage);
			commonSvc.updateWorkInfo(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,100));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
		
	/**
	 * 공사유형 사용자 연결/해제
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveWorkInfo.sys")
	public ModelAndView saveWorkInfo(
			@RequestParam(value = "chkWorkInfoArr[]", required = false) String[] chkWorkInfoArr,
			@RequestParam(value = "unChkWorkInfoArr[]", required = false) String[] unChkWorkInfoArr,
			@RequestParam(value = "userId", defaultValue = "") String userId,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			saveMap.put("userId", userId);
			saveMap.put("chkWorkInfoArr", chkWorkInfoArr);
			saveMap.put("unChkWorkInfoArr", unChkWorkInfoArr);
			commonSvc.saveWorkInfo(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,100));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 공사유형연결 사업장 목록
	 * @param isConn
	 * @param workId
	 * @param modelAndView
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("connWorkBranchListJQGrid.sys")
	public ModelAndView connWorkBranchListJQGrid(
			@RequestParam(value="workId" ,required=true) String workId,
			@RequestParam(value = "sidx", defaultValue = "areaType") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("workId", workId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        List<WorkInfoDto> list = commonSvc.selectConnWorkBranchList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 공사유형/채권사업장에 사업장 연결/해제
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveConnBranchs.sys")
	public ModelAndView saveConnBranchs(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "chkConnInfoArr[]", required = false) String[] chkConnInfoArr,
			@RequestParam(value = "unChkConnInfoArr[]", required = false) String[] unChkConnInfoArr,
			@RequestParam(value = "workId", defaultValue = "") String workId,
			@RequestParam(value = "userId", defaultValue = "") String userId,
			@RequestParam(value = "connType", required = true) String connType,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			saveMap.put("connType", connType);
			saveMap.put("workId", workId);
			saveMap.put("userId", userId);
			if("add".equals(oper)){
				saveMap.put("chkConnInfoArr", chkConnInfoArr);
				commonSvc.connBranchs(saveMap);
			}else if("del".equals(oper)){
				saveMap.put("unChkConnInfoArr", unChkConnInfoArr);
				commonSvc.disConnBranchs(saveMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,100));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 사용자별 채권사업장 목록
	 * @param isConn
	 * @param workId
	 * @param modelAndView
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("connAccBranchListJQGrid.sys")
	public ModelAndView connAccBranchListJQGrid(
			@RequestParam(value="userId" ,required=true) String userId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("userId", userId);
		List<WorkInfoDto> list = commonSvc.selectConnAccBranchList(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * ERP미등록 조직관리
	 * @throws Exception
	 */	
	@RequestMapping("systemIfBorgsList.sys")
	public ModelAndView systemIfBorgsList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("system/borg/systemIfBorgsList");
		return mav;
	}
	
	/**
	 * ERP미등록 조직관리 리스트
	 * @throws Exception
	 */
	@RequestMapping("systemIfBorgsListJQGrid.sys")
	public ModelAndView systemIfBorgsListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "transDate") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "transCd", defaultValue = "") String transCd,
			@RequestParam(value = "borgNm", defaultValue = "") String borgNm,
			@RequestParam(value = "svcTypeCd", defaultValue = "") String svcTypeCd,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("transCd", transCd);
		params.put("borgNm", borgNm);
		params.put("svcTypeCd", svcTypeCd);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);

		/*----------------페이징 세팅------------*/
        int records = borgSvc.getSystemIfBorgsListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<Map<String, Object>> list = null;
        if(records>0) list = borgSvc.getSystemIfBorgsList(params, page, rows);
        
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * ERP 미등록 업체 강제전송
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("requestSapTrans.sys")
	public ModelAndView requestSapTrans(
			@RequestParam(value = "borgIds[]"	, required=true) String[] borgIds,
			@RequestParam(value = "svcTypeCds[]", required=true) String[] svcTypeCds,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		ArrayList<String> tranDescList = null;
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			saveMap.put("borgIds"	, borgIds);
			saveMap.put("svcTypeCds", svcTypeCds);
			saveMap.put("userId"	, loginUserDto.getUserId());
			tranDescList = borgSvc.requestSapTrans(saveMap);
		} catch(Exception e) {
			e.printStackTrace();
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("SAP 전송에 실패하였습니다.");
			custResponse.setMessage(CommonUtils.getErrSubString(e,100));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("tranDescList", tranDescList);
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 공사유형/채권사업장에 사업장 연결/해제
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveIfBorgs.sys")
	public ModelAndView saveIfBorgs(
			@RequestParam(value = "borgId", required = true) String borgId,
			@RequestParam(value = "transCd", defaultValue = "1") String transCd,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			saveMap.put("transCd"		, transCd);
			saveMap.put("borgId"		, borgId);
			saveMap.put("userId"		, loginUserDto.getUserId());
			
			borgSvc.setIfBorgsHistory(saveMap);
			
		} catch(Exception e) {
			
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,100));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 고객사관리 일괄엑셀 출력 기능
	 */
	@RequestMapping("BorgUserAllListExcel.sys")
	public ModelAndView BorgUserAllListExcel(
			@RequestParam(value = "sidx", defaultValue = "borgNms") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "borgTypeCd", defaultValue = "") String borgTypeCd,
			@RequestParam(value = "borgId", required = true) String borgId,
			@RequestParam(value = "isLeaf", required = true) Boolean isLeaf,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsLogin", defaultValue = "1") String srcIsLogin,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,
			@RequestParam(value = "svcTypeCd", defaultValue = "BUY") String svcTypeCd,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("svcTypeCd", svcTypeCd);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsLogin", srcIsLogin);
		params.put("srcIsUse", srcIsUse);
		if(isLeaf == true) {	//마지막 조직일 경우
			params.put("borgId", borgId);
		} else {
			if("GRP".equals(borgTypeCd)) params.put("groupId", borgId);
			else if("CLT".equals(borgTypeCd)) params.put("clientId", borgId);
			else if("BCH".equals(borgTypeCd)) params.put("branchId", borgId);
			else if("DEP".equals(borgTypeCd)) params.put("deptId", borgId);
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<UserDto> list = borgSvc.getBorgUserList(params, 1, RowBounds.NO_ROW_LIMIT);
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("borgNms", list.get(i).getBorgNms());
				rtnData.put("userNm", list.get(i).getUserNm());
				rtnData.put("loginId", list.get(i).getLoginId());
				rtnData.put("roleNms", list.get(i).getRoleNms());
				rtnData.put("mobile", list.get(i).getMobile());
				rtnData.put("isLogin", list.get(i).getIsLogin());
				rtnData.put("isUse", list.get(i).getIsUse());
				rtnData.put("tel", list.get(i).getTel());
				rtnData.put("isUse", list.get(i).getIsUse());
				rtnData.put("email", list.get(i).getEmail());
				rtnData.put("zipCode", list.get(i).getZipCode());
				rtnData.put("address", list.get(i).getAddress());
				colDataList.add(rtnData);
			}
		}
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;
	}
	
	/**
	 * 운영사관리 일괄엑셀 출력 기능
	 */
	@RequestMapping("systemUserManageAllListExcel.sys")
	public ModelAndView systemUserManageAllListExcel(
			@RequestParam(value = "srcSvcTypeCd", defaultValue="")String srcSvcTypeCd,
			@RequestParam(value = "srcUserNm", defaultValue = "")String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue ="")String srcLoginId,
			@RequestParam(value = "srcIsUse", defaultValue ="")String srcIsUse,
			@RequestParam(value = "sidx", defaultValue = "createDate") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request ) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSvcTypeCd",srcSvcTypeCd);
		params.put("srcUserNm",srcUserNm);
		params.put("srcLoginId",srcLoginId);
		params.put("srcIsUse",srcIsUse);
		if("loginId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		List<Map<String, Object>> list = borgSvc.getSystemUserManagerList(params, 1, RowBounds.NO_ROW_LIMIT);
//		List<Map<String, Object>> colDataList = null;
//		if(list != null && list.size() > 0){
//			Map<String, Object> rtnData = null;
//			colDataList = new ArrayList<Map<String, Object>>();
//			for(int i=0; i<list.size(); i++){
//				rtnData = new HashMap<String, Object>();
//				rtnData.put("svcTypeNm", list.get(i).getSvcTypeNm());
//				rtnData.put("userNm", list.get(i).getUserNm());
//				rtnData.put("loginId", list.get(i).getLoginId());
//				rtnData.put("branchNm", list.get(i).getBranchNm());
//				rtnData.put("isUse", list.get(i).getIsUse());
//				rtnData.put("isLogin", list.get(i).getIsLogin());
//				rtnData.put("tel", list.get(i).getTel());
//				rtnData.put("mobile", list.get(i).getMobile());
//				rtnData.put("isEmail", list.get(i).getIsEmail());
//				rtnData.put("isSms", list.get(i).getIsSms());
//				rtnData.put("eMail", list.get(i).geteMail());
//				rtnData.put("createDate", list.get(i).getCreateDate());
//				colDataList.add(rtnData);
//			}
//		}
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", list);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", list);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView; 
	}
	
	/**
	 * 물품공급사 JSP
	 */
	@RequestMapping("systemContractList.sys")
	public ModelAndView systemContractList (
			ModelAndView modelAndView, HttpServletRequest request)throws Exception{
		modelAndView.setViewName("/system/contract/systemContractList");
		return modelAndView;
	}
	
	/**
	 * 물품공급계약서 그리드 출력
	 */
	@RequestMapping("contractListJQGrid.sys")
	public ModelAndView contractListJQGrid(
			@RequestParam(value="page", defaultValue="1")int page,
			@RequestParam(value="rows", defaultValue="30")int rows,
			@RequestParam(value="sidx", defaultValue="BORGNM")String sidx,
			@RequestParam(value="sord", defaultValue="ASC")String sord,
			
			@RequestParam(value="srcBorgNm", defaultValue="")String srcBorgNm,
			@RequestParam(value="srcContractVersion", defaultValue="")String srcContractVersion,
			@RequestParam(value="srcBusinessNum", defaultValue="")String srcBusinessNum,
			ModelAndView modelAndView, HttpServletRequest request)throws Exception{
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBorgNm", srcBorgNm);
		params.put("srcContractVersion", srcContractVersion);
		params.put("srcBusinessNum", srcBusinessNum);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		int records = borgSvc.getContractCnt(params);
		int total = (int)Math.ceil((float)records / (float)rows);
		
		List<Map<String, Object>> list = null;
		
		if(records > 0){
			list = borgSvc.getContractList(params, page, rows);
		}
		
		modelAndView.addObject("page", page);
		modelAndView.addObject("records", records);
		modelAndView.addObject("total", total);
		modelAndView.addObject("list", list);
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	/**
	 * 물품 공급계약서 버전 관리
	 */
	@RequestMapping("systemContractVer.sys")
	public ModelAndView systemContractVer (
			HttpServletRequest request, ModelAndView mav) throws Exception{
		mav.setViewName("/system/contract/contractVersionList");
		return mav;
	}
	
	/**
	 * 물품공급 계약서 작성 페이지 호출
	 */
	@RequestMapping("systemContractReg.sys")
	public ModelAndView systemContractReg(
			@RequestParam(value="contractNo", defaultValue="")String contractNo,
			ModelAndView mav, HttpServletRequest request) throws Exception{
		if(!"".equals(contractNo)){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("contractNo", contractNo);
			
			Map<String, Object> contractDetail = borgSvc.getCommodityContractDetail(params);
			mav.addObject("contractDetail", contractDetail);
		}
		
		mav.setViewName("/system/contract/systemContractReg");
		return mav;
	}
	
	/**
	 * 물품공급 계약서 저장
	 */
	@RequestMapping("systemContractSave.sys")
	public ModelAndView systemContractSave (
			@RequestParam(value="contractVersion1", defaultValue="")String contractVersion1,
			@RequestParam(value="contractVersion2", defaultValue="")String contractVersion2,
			@RequestParam(value="contractContents", defaultValue="")String contractContents,
			@RequestParam(value="contractRegDate", defaultValue="")String contractRegDate,
			@RequestParam(value="contractSpecial", defaultValue="")String contractSpecial,
			@RequestParam(value="contractClassify", defaultValue="")String contractClassify,
			@RequestParam(value="oper", defaultValue="")String oper,
			@RequestParam(value="contractNo", defaultValue="")String contractNo,
			ModelAndView mav, HttpServletRequest request) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("contractVersion1", contractVersion1);
		saveMap.put("contractVersion2", contractVersion2);
		saveMap.put("contractContents", contractContents);
		saveMap.put("contractRegDate", contractRegDate);
		saveMap.put("contractSpecial", contractSpecial);
		saveMap.put("contractClassify", contractClassify);
		saveMap.put("contractUserNm", loginUserDto.getUserNm());
		saveMap.put("contractNo", contractNo);
		CustomResponse customResponse = new CustomResponse(true);
		try{
			if("save".equals(oper)){
				borgSvc.systemContractSave(saveMap);
			}else if("mod".equals(oper)){
				borgSvc.systemContractMod(saveMap);
			}
			
		}catch(Exception e){
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		mav = new ModelAndView("jsonView");
		mav.addObject("customResponse", customResponse);
		return mav;
	}
	
	/**
	 * 물품공급 계약서 상세페이지
	 */
	@RequestMapping("systemContractDetail.sys")
	public ModelAndView systemContractDetail(
			@RequestParam(value="contractNo", defaultValue="")String contractNo,
			ModelAndView mav, HttpServletRequest request) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contractNo", contractNo);
		Map<String, Object> contractDetail = borgSvc.getCommodityContractDetail(params);
		mav.addObject("contractDetail", contractDetail);
		mav.setViewName("/system/contract/systemContractDetail");
		return mav;
	}
	
	/**
	 * 물품공급계약서 JQgrid
	 */
	@RequestMapping("systemContractListJQGrid.sys")
	public ModelAndView systemContractListJQGrid(
			ModelAndView mav, HttpServletRequest request) throws Exception{
		List<Map<String, Object>> list = borgSvc.getCommodityContractList();
		mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	
	/**
	 * 물품공급계약 삭제
	 */
	@RequestMapping("systemContractDelete.sys")
	public ModelAndView systemContractDelete (
			@RequestParam(value="contractNo", defaultValue="")String  contractNo,
			ModelAndView mav, HttpServletRequest request) throws Exception{
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("contractNo", contractNo);
		
		CustomResponse customResponse = new CustomResponse(true);
		
		try{
			borgSvc.systemContractDelete(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		mav = new ModelAndView("jsonView");
		mav.addObject("customResponse",customResponse);
		return mav;
	}
	
	/**
	 * 물품공급계약서 팝업 호출
	 */
	@RequestMapping("systemContractPopup.sys")
	public ModelAndView systemContractPopup (
			@RequestParam(value="contractVersion", defaultValue="") String contractVersion,
			@RequestParam(value="contractClassify", defaultValue="") String contractClassify,
			@RequestParam(value="contractSpecial", defaultValue="") String contractSpecial,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contractVersion", contractVersion);
		params.put("contractClassify", contractClassify);
		if("BUY".equals(params.get("contractClassify"))){
			params.put("contractSpecial", contractSpecial);
		}
		List<Map<String, Object>> contractVersionList = borgSvc.getCommodityContractListPopup(params);
		mav.setViewName("/system/contract/systemContractPopup");
		mav.addObject("contractVersionList", contractVersionList);
		mav.addObject("contractVersion", contractVersion);
		return mav;
	}
	
	/**
	 * 물품공급계약서 내용
	 */
	@RequestMapping("systemContractPopupContents.sys")
	public ModelAndView systemContractPopupContents (
			@RequestParam(value="contractNo", defaultValue="") String contractNo,
			@RequestParam(value="borgId", defaultValue="") String borgId,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contractNo", contractNo);
		Map<String, Object> commodityContractDetail = borgSvc.getCommodityContractDetail(params);
		mav = new  ModelAndView("jsonView");
		mav.addObject("commodityContractDetail", commodityContractDetail);
		if(commodityContractDetail != null){
			params.put("borgId", borgId);
			params.put("contractVersion", commodityContractDetail.get("contractVersion").toString());
			String commodityContractListDate = borgSvc.getCommodityContractListDate(params);
			mav.addObject("commodityContractListDate", commodityContractListDate==null?"":commodityContractListDate);
		}
		return mav;
	}
	
	/**
	 * 물품공급계약서 버전
	 */
	@RequestMapping("basicContractView.sys")
	public ModelAndView basicContractView(
			@RequestParam(value="contractVersion", defaultValue="") String contractVersion,
			@RequestParam(value="contractCookie", defaultValue="") String contractCookie,
			@RequestParam(value="contractClassify", defaultValue="") String contractClassify,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contractVersion", contractVersion);
		params.put("contractClassify", contractClassify);
		if("BUY".equals(contractClassify)){
			params.put("contractSpecial", loginUserDto.getSmpBranchsDto().getContractSpecial());
		}
		boolean result = true;
		try{
			List<Map<String, Object>> contractDetailList = borgSvc.getCommodityContractView(params);
			if(contractDetailList.size() == 0){
				result = false;
			}else{
				mav.addObject("contractDetailList", contractDetailList);
			}
		}catch(Exception e){
			
		}

		mav.setViewName("/system/contract/basicContractView");
		mav.addObject("contractCookie", contractCookie);
		mav.addObject("result", result);
		return mav;
	}
	/**
	 * 물품공급계약서 서명중복 체크
	 */
	@RequestMapping("commodityContractListValidation.sys")
	public ModelAndView commodityContractListValidation(
			@RequestParam(value="contractVersionArray[]", defaultValue="") String[] contractVersionArray,
			@RequestParam(value="contractClassifyArray[]", defaultValue="") String[] contractClassifyArray,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		CustomResponse customResponse = new CustomResponse(true);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("contractVersionArray", contractVersionArray);
		saveMap.put("contractClassifyArray", contractClassifyArray);
		List<Map<String, Object>> list = borgSvc.getCommodityContractListValidation(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
		if(list.get(0) != null && list.get(1) != null){
			customResponse.setSuccess(false);
			customResponse.setMessage("이미 계약이 되어있습니다.");
		}

		mav = new ModelAndView("jsonView");
		mav.addObject("customResponse", customResponse);
		return mav;
	}
	
	
	/**
	 * 물품공급계약서 서명
	 */
	@RequestMapping("commodityContractSave.sys")
	public ModelAndView commodityContractSave(
			@RequestParam(value="contractVersionArray[]", defaultValue="") String[] contractVersionArray,
			@RequestParam(value="contractClassifyArray[]", defaultValue="") String[] contractClassifyArray,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		CustomResponse customResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("contractVersionArray", contractVersionArray);
		saveMap.put("contractClassifyArray", contractClassifyArray);

		try{
				borgSvc.commodityContractSave(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
		}catch(Exception e){
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		mav = new ModelAndView("jsonView");
		mav.addObject("customResponse", customResponse);
		return mav;
	}

	/**
	 * 물품공급 계약서 서명 리스트 일괄 출력
	 */
	@RequestMapping("systemContractListExcel.sys")
	public ModelAndView systemContractListExcel(
			@RequestParam(value="srcContractVersion", defaultValue="")String contractVersion,
			@RequestParam(value="sidx", defaultValue="BORGNM")String sidx,
			@RequestParam(value="sord", defaultValue="ASC")String sord,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contractVersion", contractVersion);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<Map<String, Object>> list = borgSvc.getContractList(params, 1, RowBounds.NO_ROW_LIMIT);
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", list);
        sheetList.add(map1);
        mav.setViewName("commonExcelViewResolver");
        mav.addObject("excelFileName", excelFileName);
        mav.addObject("sheetList", sheetList);
		
//		mav.addObject("sheetTitle", sheetTitle);
//		mav.addObject("excelFileName", excelFileName);
//		mav.addObject("colLabels", colLabels);
//		mav.addObject("colIds", colIds);
//		mav.addObject("numColIds", numColIds);
//		mav.addObject("colDataList", list);
//		mav.setViewName("commonExcelViewResolver");
		return mav;
	}
	
	@RequestMapping("getUserPassword.sys")
	public ModelAndView getUserPassword(
			@RequestParam(value="userid", required=true) String userid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userid", userid);
		String password = borgSvc.getUserPassword(params);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("password", password);
		return modelAndView;
	}
	
	/**
	 * 계약서 관리 페이지 이동
	 */
	@RequestMapping("systemContractNewList.sys")
	public ModelAndView systemContractNewList(
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		List<Object> commodityContractNewList = generalDao.selectGernalList("system.borg.selectContractNewList", paramMap);
		modelAndView.addObject("commodityContractNewList", commodityContractNewList);
		modelAndView.setViewName("/system/contract/systemContractNewList");
		return modelAndView;
	}
	
	
	/**
	 * 구매사,공급사 서명 팝업
	 */
	@RequestMapping("popContractSign")
	public ModelAndView popContractSign(
			@RequestParam(value="svcTypeCd"			, required=true) String svcTypeCd,
			@RequestParam(value="contractVersion"	, required=true) String contractVersion,
			@RequestParam(value="contractNm"		, required=true) String contractNm,
			@RequestParam(value="contractSpecial"	, defaultValue="0") String contractSpecial,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("svcTypeCd"		, svcTypeCd);
		modelAndView.addObject("contractVersion", contractVersion);
		modelAndView.addObject("contractNm"		, contractNm);
		modelAndView.addObject("contractSpecial"		, contractSpecial);
		modelAndView.setViewName("/system/contract/popContractSignList");
		return modelAndView;
	}
	
	/**
	 * 구매사,공급사 미서명 팝업
	 */
	@RequestMapping("popContractNoSign")
	public ModelAndView popContractNoSign(
			@RequestParam(value="svcTypeCd", required=true) String svcTypeCd,
			@RequestParam(value="contractVersion", required=true) String contractVersion,
			@RequestParam(value="contractNm"		, required=true) String contractNm,
			@RequestParam(value="contractSpecial"	, defaultValue="0") String contractSpecial,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("svcTypeCd"		, svcTypeCd);
		modelAndView.addObject("contractVersion", contractVersion);
		modelAndView.addObject("contractNm"		, contractNm);
		modelAndView.addObject("contractSpecial"		, contractSpecial);
		modelAndView.setViewName("/system/contract/popContractNoSignList");
		return modelAndView;
	}
	
	/**
	 * 구매사,공급사 미서명 JQGrid
	 */
	@RequestMapping("contractNoSignListJQGrid.sys")
	public ModelAndView contractNoSignListJQGrid(
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		Map<String, Object> contractNoSignMap = borgSvc.contractNoSign(paramMap);
		modelAndView.addObject("page"	, contractNoSignMap.get("page"));
		modelAndView.addObject("total"	, contractNoSignMap.get("total"));
		modelAndView.addObject("records", contractNoSignMap.get("records"));
		modelAndView.addObject("list", contractNoSignMap.get("list"));
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	
	/**
	 * 계약서 수정
	 */
	@RequestMapping("popContractMod")
	public ModelAndView popContractMod(
			@RequestParam(value="svcTypeCd"			, required=true) String svcTypeCd,
			@RequestParam(value="contractVersion"	, required=true) String contractVersion,
			@RequestParam(value="contractSpecial"	, required=true) String contractSpecial,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		ModelMap daoParam             = new ModelMap();
		Object   commodityContractNew = null;
		
		daoParam.put("svcTypeCd",       svcTypeCd);
		daoParam.put("contractVersion", contractVersion);
		daoParam.put("contractSpecial", contractSpecial);
		
		commodityContractNew = this.generalDao.selectGernalObject("system.borg.selectCommodityContractNewVersion", daoParam);
		
		modelAndView.addObject("commodityContractNew", commodityContractNew);
		modelAndView.setViewName("/system/contract/popContractMod");
		
		return modelAndView;
	}
	
	/**
	 * 운영사 사용자 자기 정보 수정 페이지 이동
	 * 
	 * @param request
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("admUserDetail.sys")
	public ModelAndView admUserDetail(HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto        loginUserDto   = CommonUtils.getLoginUserDto(request);
		String              userId         = loginUserDto.getUserId();
		ModelMap            daoParam       = new ModelMap();
		Map<String, String> userDetailInfo = null;
		
		daoParam.put("userId", userId);
		
		userDetailInfo = (Map<String, String>)this.generalDao.selectGernalObject("system.borg.selectAdmUserDetailInfo", daoParam);
		
		modelAndView.addObject("userDetailInfo", userDetailInfo);
		modelAndView.setViewName("system/treeFrame/admUserDetail");
		
		return modelAndView;
	}
	
	/**
	 * 운영사 사용자를 수정하는 메소드
	 * 
	 * @param userNm : 사용자명
	 * @param password : 비밀번호
	 * @param tel : 전화번호
	 * @param mobile : 이동전화번호
	 * @param email : 이메일
	 * @param isSms : sms 발송여부
	 * @param isEmail : 이메일 발송여부
	 * @param request
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("updateUser.sys")
	public ModelAndView updateUser(
			@RequestParam(value="userNm",   defaultValue="")  String userNm,
			@RequestParam(value="password", defaultValue="")  String password,
			@RequestParam(value="tel",      defaultValue="")  String tel,
			@RequestParam(value="mobile",   defaultValue="")  String mobile,
			@RequestParam(value="email",    defaultValue="")  String email,
			@RequestParam(value="isSms",    defaultValue="0") String isSms,
			@RequestParam(value="isEmail",  defaultValue="0") String isEmail,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		CustomResponse      customResponse = new CustomResponse(true);
		Map<String, String> svcParam       = new HashMap<String, String>();
		LoginUserDto        loginUserDto   = null;
		String              userId         = null;
		String              remoteIp       = null;
		
		try{
			loginUserDto = CommonUtils.getLoginUserDto(request);
			userId       = loginUserDto.getUserId();
			remoteIp     = loginUserDto.getRemoteIp();
			
			svcParam.put("userNm",    userNm);
			svcParam.put("password",  password);
			svcParam.put("tel",       tel);
			svcParam.put("mobile",    mobile);
			svcParam.put("email",     email);
			svcParam.put("isSms",     isSms);
			svcParam.put("isEmail",   isEmail);
			svcParam.put("userId",    userId);
			svcParam.put("updaterId", userId);
			svcParam.put("remoteIp",  remoteIp);
			
			this.commonSvc.updateUser(svcParam);
		}
		catch(Exception e){
			this.logger.error(CommonUtils.getExceptionStackTrace(e));
			
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50)); //Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		
		return modelAndView;
	}
}