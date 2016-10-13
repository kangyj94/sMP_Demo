package kr.co.bitcube.board.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.board.dto.ImproDto;
import kr.co.bitcube.board.service.BoardSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("board")
public class ImproManageCtl {
	@Autowired private BoardSvc boardSvc;
	@Autowired private GeneralDao generalDao;
	
	private Logger logger = Logger.getLogger(getClass());

	/**
	 * 개선요구사항관리 페이지로 이동하는 메소드
	 */
	@RequestMapping("improManageList.sys") 
	public ModelAndView getImproManageList(
			HttpServletRequest req, ModelAndView mav) throws Exception{
			mav.setViewName("board/requestManage/improManageList");
		return mav;
	}

	/**
	 * 요구사항관리 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("requestImproListJQGrid.sys")
	public ModelAndView requestImproListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "no") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcFromDt", defaultValue = "") String srcFromDt,
			@RequestParam(value = "srcEndDt", defaultValue = "") String srcEndDt,
			@RequestParam(value = "sTat_Flag_Code", defaultValue = "") String sTat_Flag_Code,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcFromDt", srcFromDt);
		params.put("srcEndDt", srcEndDt);
		params.put("sTat_Flag_Code", sTat_Flag_Code);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = boardSvc.getImproManageListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<ImproDto> list = null;
        if(records>0) list = boardSvc.getImproManageList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 요구사항관리 상세 페이지를 조회하여 반환하는 메소드
	 */
	@RequestMapping("improManageDetail.sys")
	public ModelAndView ImproManageDetail(
			@RequestParam(value = "no", required = true) String no,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("no", no);
		ImproDto detailInfo = this.boardSvc.getImproManageDetailInfo1(searchMap,loginUserDto);
		modelAndView.setViewName("board/requestManage/improManageDetail");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 요구사항관리 등록 페이지로 이동하는 메소드
	 */
	@RequestMapping("improManageWrite.sys")
	public ModelAndView ImproManageWrite(
			@RequestParam(value = "no", defaultValue = "") String no,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("no", no);
		ImproDto detailInfo = null;
		if(!"".equals(no)) {
			detailInfo = this.boardSvc.getImproManageDetailInfo1(searchMap,loginUserDto);
		}
		modelAndView.setViewName("board/requestManage/improManageWrite");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 요구사항관리 등록, 수정, 삭제 메소드
	 */
	@RequestMapping("improManageTransGrid.sys") 
	public ModelAndView ImproManageTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", defaultValue = "") String id,
			@RequestParam(value = "no", defaultValue = "") String no,
			@RequestParam(value = "title", defaultValue = "") String title,
			@RequestParam(value = "message", defaultValue = "") String message,
			@RequestParam(value = "req_message", defaultValue = "") String req_message,
			@RequestParam(value = "requ_User_Numb", defaultValue = "") String requ_User_Numb,
			@RequestParam(value = "hand_User_Numb", defaultValue = "") String hand_User_Numb,
			@RequestParam(value = "modi_User_Numb", defaultValue = "") String modi_User_Numb,
			@RequestParam(value = "stat_Flag_code", defaultValue = "") String stat_Flag_code,
			@RequestParam(value = "file_list1", defaultValue = "") String file_list1,
			@RequestParam(value = "file_list2", defaultValue = "") String file_list2,
			@RequestParam(value = "file_list3", defaultValue = "") String file_list3,
			@RequestParam(value = "file_list4", defaultValue = "") String file_list4,
			@RequestParam(value = "replayFlag", defaultValue = "") String replayFlag,
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		logger.debug("------------------req_message : " + req_message);
		saveMap.put("id", id);
		saveMap.put("no", no);
		LoginUserDto lud = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		saveMap.put("borgId", lud.getBorgId());
		saveMap.put("title", title);
		saveMap.put("message", message);
		saveMap.put("req_message", req_message);
		saveMap.put("requ_User_Numb", requ_User_Numb);
		saveMap.put("hand_User_Numb", hand_User_Numb);
		saveMap.put("modi_User_Numb", modi_User_Numb);
		saveMap.put("stat_Flag_code", stat_Flag_code);
		saveMap.put("file_list1", file_list1);
		saveMap.put("file_list2", file_list2);
		saveMap.put("file_list3", file_list3);
		saveMap.put("file_list4", file_list4);
		saveMap.put("replayFlag", replayFlag);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				boardSvc.regImproManage(saveMap);
			} else if("edit".equals(oper)) {
				saveMap.put("requ_User_Numb", lud.getUserNm());
				saveMap.put("hand_User_Numb", lud.getUserNm());
				if("1".equals(replayFlag)) {
					saveMap.clear();
					saveMap.put("no", no);
					saveMap.put("adde_file_res1", file_list1);
					saveMap.put("adde_file_res2", file_list2);
					saveMap.put("adde_file_res3", file_list3);
					saveMap.put("adde_file_res4", file_list4);
					saveMap.put("req_message", message);
					saveMap.put("hand_message", message);
					saveMap.put("stat_flag_code", "2");
					saveMap.put("hand_User_Numb", lud.getUserNm());
					saveMap.put("modi_User_Numb", lud.getUserNm());
				}
				boardSvc.modImproManage(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("id", id);
				boardSvc.delImproManage(saveMap);
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
	
	@RequestMapping("ImproManageAttachDelete.sys")
	public ModelAndView ImproManageAttachDelete(
			@RequestParam(value = "no", required = true) String no,
			@RequestParam(value = "file_list", required = true) String file_list,
			@RequestParam(value = "columnName", required = true) String columnName,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("no", no);
		if("file_list1".equals(columnName)) { saveMap.put("file_list1", file_list); } 
		else if("file_list2".equals(columnName)) { saveMap.put("file_list2", file_list); } 
		else if("file_list3".equals(columnName)) { saveMap.put("file_list3", file_list); } 
		else if("file_list4".equals(columnName)) { saveMap.put("file_list4", file_list); }
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			boardSvc.delImproManageAttachFile(saveMap);
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
	 * 개선사항 팝업창 호출
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("improManageReg.sys")
	public ModelAndView ImproManageReg(
			@RequestParam(value="statFlagCode", defaultValue="")String statFlagCode,
			@RequestParam(value="no", defaultValue="")String no,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("no", no);
		ImproDto detailInfo = null;
		
		if(!"".equals(no)) {
			detailInfo = this.boardSvc.getImproManageDetailInfo1(searchMap,loginUserDto);
		}
		
		modelAndView.addObject("statFlagCode", statFlagCode);
		modelAndView.addObject("no", no);
		modelAndView.addObject("detailInfo", detailInfo);
		modelAndView.setViewName("board/requestManage/improManageReg");
		return modelAndView;
	}
	
	/**
	 * 유지보수 내용을 등록하는 메소드
	 * @param request
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("insertRepairManage.sys")
	public ModelAndView insertRepairManage(
			@RequestParam(value="VIEW_NM",      defaultValue="") String viewNm,
			@RequestParam(value="REQ_CONTENTS", defaultValue="") String reqContents,
			@RequestParam(value="ATTACH1_ID",   defaultValue="") String attach1Id,
			@RequestParam(value="ATTACH2_ID",   defaultValue="") String attach2Id,
			@RequestParam(value="TYPE",         defaultValue="") String type,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		CustomResponse      custResponse = new CustomResponse(true);
		LoginUserDto        loginUserDto = CommonUtils.getLoginUserDto(request);
		Map<String, Object> svcParam     = new HashMap<String, Object>();
		
		svcParam.put("viewNm",       viewNm);
		svcParam.put("reqContents",  reqContents);
		svcParam.put("attach1Id",    attach1Id);
		svcParam.put("attach2Id",    attach2Id);
		svcParam.put("loginUserDto", loginUserDto);
		svcParam.put("type",         type);
		
		try {
			this.boardSvc.insertRepairManage(svcParam);
		}
		catch(Exception e) {
			logger.error(CommonUtils.getExceptionStackTrace(e));
			
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e, 50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		
		return modelAndView;
	}
	
	/**
	 * 유지보수 내용을 수정하는 메소드
	 * 
	 * @param request
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("updateRepairManage.sys")
	public ModelAndView updateRepairManage(
			@RequestParam(value="repair_id",       defaultValue="") String repairId,
			@RequestParam(value="state",           defaultValue="") String state,
			@RequestParam(value="view_nm",         defaultValue="") String viewNm,
			@RequestParam(value="req_contents",    defaultValue="") String reqContents,
			@RequestParam(value="handle_contents", defaultValue="") String handleContents,
			@RequestParam(value="file_list1",      defaultValue="") String fileList1,
			@RequestParam(value="file_list2",      defaultValue="") String fileList2,
			@RequestParam(value="type",            defaultValue="") String type,
			@RequestParam(value="is_important",    defaultValue="") String isImportant,
			@RequestParam(value="expect_man_day",  defaultValue="") String expectManDay,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		CustomResponse      custResponse = new CustomResponse(true);
		LoginUserDto        loginUserDto = CommonUtils.getLoginUserDto(request);
		Map<String, Object> svcParam     = new HashMap<String, Object>();
		
		svcParam.put("viewNm",         viewNm);
		svcParam.put("state",          state);
		svcParam.put("reqContents",    reqContents);
		svcParam.put("fileList1",      fileList1);
		svcParam.put("fileList2",      fileList2);
		svcParam.put("handleContents", handleContents);
		svcParam.put("repairId",       repairId);
		svcParam.put("loginUserDto",   loginUserDto);
		svcParam.put("type",           type);
		svcParam.put("isImportant",    isImportant);
		svcParam.put("expectManDay",   expectManDay);
		
		try {
			this.boardSvc.updateRepairManage(svcParam);
		}
		catch(Exception e) {
			logger.error(CommonUtils.getExceptionStackTrace(e));
			
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e, 50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		
		return modelAndView;
	}
	
	/**
	 * 유지보수 내용을 수정하는 메소드
	 * 
	 * @param request
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("repairExcel.sys")
	public ModelAndView repairExcel(
			@RequestParam(value = "srcRequStartDate", defaultValue = "") String srcRequStartDate, // 조회일자 시작일
			@RequestParam(value = "srcRequEndDate",   defaultValue = "") String srcRequEndDate, // 조회일자 종료일
			@RequestParam(value = "srcRepairType",    defaultValue = "") String srcRepairType, // 접수구분
			@RequestParam(value = "srcState",         defaultValue = "") String srcState, // 처리상태 
			@RequestParam(value = "srcReqUserName",         defaultValue = "") String srcReqUserName, // 요청자
			@RequestParam(value = "srcDateType",         defaultValue = "") String srcDateType, // 조회구분
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		Map<String, Object>       params       = new HashMap<String, Object>();
		Map<String, Object>       map1         = new HashMap<String, Object>();
		List<Object>              list         = null;
		List<Map<String, Object>> sheetList    = new ArrayList<Map<String, Object>>();
		LoginUserDto              loginUserDto = CommonUtils.getLoginUserDto(request);
		
		params.put("srcRequStartDate", srcRequStartDate);
		params.put("srcRequEndDate",   srcRequEndDate);
		params.put("srcRepairType",    srcRepairType);
		params.put("srcState",         srcState);
		params.put("srcReqUserName",         srcReqUserName);
		params.put("srcDateType",         srcDateType);
		params.put("userInfoDto",      loginUserDto);
		
		list = this.generalDao.selectGernalList("board.selectRepairManage", params);
		
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("colDataList", list);
        
        sheetList.add(map1);
        
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
				
		return modelAndView;
	}
}
