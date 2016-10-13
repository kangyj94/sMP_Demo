package kr.co.bitcube.board.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.board.dto.MerequDto;
import kr.co.bitcube.board.service.BoardSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("board")
public class RequestManageCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private BoardSvc boardSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private GeneralDao generalDao;

	/**
	 * 요구사항관리 페이지로 이동하는 메소드
	 */
	@RequestMapping("requestManageList.sys")
	public ModelAndView getRequestManageList(
			HttpServletRequest req, ModelAndView mav) throws Exception{
			mav.setViewName("board/requestManage/requestManageList");
		return mav;
	}
	
	/**
	 * 요구사항관리 페이지로 이동하는 메소드
	 */
//	@RequestMapping("improManageList.sys")
//	public ModelAndView getImproManageList(
//			HttpServletRequest req, ModelAndView mav) throws Exception{
//			mav.setViewName("board/requestManage/improManageList");
//		return mav;
//	}

	/**
	 * 요구사항관리 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("requestManageListJQGrid.sys")
	public ModelAndView requestManageListJQGrid( 
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "no") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcFromDt", defaultValue = "") String srcFromDt,
			@RequestParam(value = "srcEndDt", defaultValue = "") String srcEndDt,
			@RequestParam(value = "srcDeli_Area_Code", defaultValue = "") String srcDeli_Area_Code,
			@RequestParam(value = "srcRequ_Stat_Flag", defaultValue = "") String srcRequ_Stat_Flag,
			@RequestParam(value = "srcStatFlagCode", defaultValue = "") String srcStatFlagCode,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		ModelMap            params       = new ModelMap();
		String              orderString  = null;
		String              pageString   = Integer.toString(page);
		String              rowString    = Integer.toString(rows);
		StringBuffer        stringBuffer = new StringBuffer();
		LoginUserDto        loginUserDto = CommonUtils.getLoginUserDto(request);
		Map<String, Object> listMap      = null;
		Integer             record       = null;
		Integer             pageMax      = null;
		List<?>             list         = null;
		
		modelAndView = new ModelAndView("jsonView");
		
		stringBuffer.append(" ");
		stringBuffer.append(sidx);
		stringBuffer.append(" ");
		stringBuffer.append(sord);
		stringBuffer.append(" ");
		
		orderString = stringBuffer.toString();
		
		params.put("srcFromDt",         srcFromDt);
		params.put("srcEndDt",          srcEndDt);
		params.put("srcDeli_Area_Code", srcDeli_Area_Code);
		params.put("srcRequ_Stat_Flag", srcRequ_Stat_Flag);
		params.put("orderString",       orderString);
		params.put("userInfoDto",       loginUserDto);
		params.put("page",              pageString);
		params.put("rows",              rowString);
		params.put("srcStatFlagCode",   srcStatFlagCode);
		
		
		listMap = this.commonSvc.getJqGridList("board.selectRequestManageListCnt", "board.selectRequestManageList", params);
		record  = (Integer)listMap.get("record");
		pageMax = (Integer)listMap.get("pageMax");
		list    = (List<?>)listMap.get("list");
		
		modelAndView.addObject("page",    page);
		modelAndView.addObject("total",   pageMax);
		modelAndView.addObject("records", record);
		modelAndView.addObject("list",    list);
		
		return modelAndView;
	}
	
	/**
	 * 요구사항관리 DB조회후 엑셀다운로드 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("requestManageListExcel.sys")
	public ModelAndView requestManageListExcel( 
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "no") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcFromDt", defaultValue = "") String srcFromDt,
			@RequestParam(value = "srcEndDt", defaultValue = "") String srcEndDt,
			@RequestParam(value = "srcDeli_Area_Code", defaultValue = "") String srcDeli_Area_Code,
			@RequestParam(value = "srcRequ_Stat_Flag", defaultValue = "") String srcRequ_Stat_Flag,
			@RequestParam(value = "srcStatFlagCode", defaultValue = "") String srcStatFlagCode,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,				
			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		ModelMap        params       = new ModelMap();
		String          orderString  = null;
		StringBuffer	stringBuffer = new StringBuffer();
		LoginUserDto    loginUserDto = CommonUtils.getLoginUserDto(request);
		List<Object>    list         = null;
		
		modelAndView = new ModelAndView("jsonView");
		
		stringBuffer.append(" ");
		stringBuffer.append(sidx);
		stringBuffer.append(" ");
		stringBuffer.append(sord);
		stringBuffer.append(" ");
		
		orderString = stringBuffer.toString();
		
		params.put("srcFromDt",         srcFromDt);
		params.put("srcEndDt",          srcEndDt);
		params.put("srcDeli_Area_Code", srcDeli_Area_Code);
		params.put("srcRequ_Stat_Flag", srcRequ_Stat_Flag);
		params.put("orderString",       orderString);
		params.put("userInfoDto",       loginUserDto);
		params.put("srcStatFlagCode",   srcStatFlagCode);
		
		//----------------조회------------/
		list = generalDao.selectGernalList("board.selectRequestManageList", params);
		
		ArrayList<Map<String, Object>> excelList = new ArrayList<Map<String,Object>>();
		
		for(Object obj : list){
			Map<String, Object> excelMap = new HashMap<String, Object>();
			MerequDto dto = (MerequDto)obj;
			excelMap.put("num"				, dto.getNum());
			excelMap.put("deli_Area_Code"	, dto.getDeli_Area_Code());
			excelMap.put("borgId"			, dto.getBorgId());
			excelMap.put("title"			, dto.getTitle());
			excelMap.put("requ_Stat_Flag"	, dto.getRequ_Stat_Flag());
			excelMap.put("requ_User_Date"	, dto.getRequ_User_Date());
			excelMap.put("requ_User_Numb"	, dto.getRequ_User_Numb());
			excelMap.put("modi_User_Numb"	, dto.getModi_User_Numb());
			excelMap.put("modi_User_Date"	, dto.getModi_User_Date());
			excelMap.put("stat_Flag_Code"	, dto.getStat_Flag_Code());
			excelList.add(excelMap);
		}
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("colDataList", excelList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);		
		
		return modelAndView;
	}
	
	/**
	 * 요구사항관리 상세 페이지를 조회하여 반환하는 메소드
	 */
	@RequestMapping("requestManageDetail.sys")
	public ModelAndView requestManageDetail(
			@RequestParam(value = "no", required = true) String no,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("no", no);
		MerequDto detailInfo = this.boardSvc.getRequestManageDetailInfo(searchMap,loginUserDto);
		modelAndView.setViewName("board/requestManage/requestManageDetail");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 요구사항관리 등록 페이지로 이동하는 메소드
	 */
	@RequestMapping("requestManageWrite.sys")
	public ModelAndView requestManageWrite(
			@RequestParam(value = "no", defaultValue = "") String no,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("no", no);
		MerequDto detailInfo = null;
		if(!"".equals(no)) {
			detailInfo = this.boardSvc.getRequestManageDetailInfo(searchMap,loginUserDto);
		}
		modelAndView.setViewName("board/requestManage/requestManageWrite");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 요구사항관리 등록, 수정, 삭제 메소드
	 */
	@RequestMapping("requestManageTransGrid.sys")
	public ModelAndView requestManageTransGrid(
			@RequestParam(value = "oper",           required = true)   String oper,
			@RequestParam(value = "id",             defaultValue = "") String id,
			@RequestParam(value = "no",             defaultValue = "") String no,
			@RequestParam(value = "title",          defaultValue = "") String title,
			@RequestParam(value = "message",        defaultValue = "") String message,
			@RequestParam(value = "requ_Stat_Flag", defaultValue = "") String requ_Stat_Flag,
			@RequestParam(value = "requ_User_Numb", defaultValue = "") String requ_User_Numb,
			@RequestParam(value = "requ_Flag_Code", defaultValue = "") String requ_Flag_Code,
			@RequestParam(value = "stat_Flag_code", defaultValue = "") String stat_Flag_code,
			@RequestParam(value = "file_list1",     defaultValue = "") String file_list1,
			@RequestParam(value = "file_list2",     defaultValue = "") String file_list2,
			@RequestParam(value = "file_list3",     defaultValue = "") String file_list3,
			@RequestParam(value = "file_list4",     defaultValue = "") String file_list4,
			@RequestParam(value = "replayFlag",     defaultValue = "") String replayFlag,
			@RequestParam(value = "requ_tel_numb",  defaultValue = "") String requ_tel_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String,Object> saveMap      = new HashMap<String,Object>();
		LoginUserDto       lud          = CommonUtils.getLoginUserDto(request);
		CustomResponse     custResponse = new CustomResponse(true);
		String             areaCode     = lud.getAreaType();
		String             borgId       = lud.getBorgId();
		
		saveMap.put("id",             id);
		saveMap.put("no",             no);
		saveMap.put("deli_Area_Code", areaCode);
		saveMap.put("borgId",         borgId);
		saveMap.put("title",          title);
		saveMap.put("message",        message);
		saveMap.put("requ_Stat_Flag", requ_Stat_Flag);
		saveMap.put("requ_User_Numb", requ_User_Numb);
		saveMap.put("requ_Flag_Code", requ_Flag_Code);
		saveMap.put("stat_Flag_code", stat_Flag_code);
		saveMap.put("file_list1",     file_list1);
		saveMap.put("file_list2",     file_list2);
		saveMap.put("file_list3",     file_list3);
		saveMap.put("file_list4",     file_list4);
		saveMap.put("replayFlag",     replayFlag);
		saveMap.put("requ_tel_numb",  requ_tel_numb);
		
		try {
			if("add".equals(oper)) {
				boardSvc.regRequestManage(saveMap);
			}
			else if("edit".equals(oper)) {
				saveMap.put("requ_User_Numb", lud.getUserNm());
				
				if("Y".equals(replayFlag)) {
					saveMap.clear();
					saveMap.put("no",             no);
					saveMap.put("adde_file_res1", file_list1);
					saveMap.put("adde_file_res2", file_list2);
					saveMap.put("adde_file_res3", file_list3);
					saveMap.put("adde_file_res4", file_list4);
					saveMap.put("req_message",    message);
					saveMap.put("stat_flag_code", "2");
					saveMap.put("modi_User_Numb", lud.getUserNm());
					saveMap.put("req_message",    message);
					saveMap.put("replayFlag",     replayFlag);
				}
				
				boardSvc.modRequestManage(saveMap);
			}
			else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("id", id);
				
				boardSvc.delRequestManage(saveMap);
			}
		}
		catch(Exception e) {
			logger.error("Exception : "+e);
			
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		
		return modelAndView;
	}
	
	@RequestMapping("requestManageAttachDelete.sys")
	public ModelAndView requestManageAttachDelete(
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
			boardSvc.delRequestManageAttachFile(saveMap);
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
