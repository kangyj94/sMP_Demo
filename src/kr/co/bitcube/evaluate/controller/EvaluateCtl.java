package kr.co.bitcube.evaluate.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.adjust.dto.AdjustDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.evaluate.service.EvaluateSvc;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("evaluate")
public class EvaluateCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private EvaluateSvc evaluateSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@RequestMapping("buyEvaluate.sys")
	public ModelAndView buyEvaluate(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		modelAndView.addObject("evalRow"	, evaluateSvc.selectEvalRow(paramMap));
		modelAndView.addObject("evalCol"	, evaluateSvc.selectEvalCol(paramMap));
		modelAndView.addObject("evalUsers"	, evaluateSvc.selectEvalUsers(paramMap));
		modelAndView.setViewName("evaluate/buyEvaluate");
		return modelAndView;
	}
	
	@RequestMapping("saveEvaluate.sys")
	public ModelAndView saveEvaluate(
			@RequestParam(value = "evalUser"		, required = true) 	String evalUser,
			@RequestParam(value = "evalSelCdArr[]"	, required = true) 	String[]evalSelCdArr,
			@RequestParam(value = "evalDescArr[]"	, required = false) String[]evalDescArr,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("evalUser"		, evalUser);
		saveMap.put("evalSelCdArr"	, evalSelCdArr);
		saveMap.put("evalDescArr"	, evalDescArr);

		saveMap.put("userId"		, userInfoDto.getUserId());
		saveMap.put("groupId"		, userInfoDto.getGroupId()); 
		saveMap.put("clientId"		, userInfoDto.getClientId()); 
		saveMap.put("branchId"		, userInfoDto.getSmpBranchsDto().getBranchId());

		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			evaluateSvc.saveEvaluate(saveMap);
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
	
	@RequestMapping("admEvaluateList.sys")
	public ModelAndView admEvaluateList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("orderString", " workNm asc");
		
		modelAndView.addObject("evalRow"	 , evaluateSvc.selectEvalRow(paramMap));
		modelAndView.addObject("evalCol"	 , evaluateSvc.selectEvalCol(paramMap));
		modelAndView.addObject("admUserList" , evaluateSvc.selectEvalUsers(paramMap));
		modelAndView.addObject("workInfoList", commonSvc.selectWorkInfo(paramMap));

		modelAndView.setViewName("evaluate/admEvaluateList");
		return modelAndView;
	}

	@RequestMapping("admEvaluateListExcel.sys")
	public ModelAndView admEvaluateListExcel(
			@RequestParam(value = "sidx", defaultValue = "evalDate") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,		
			@RequestParam(value = "srcBranchNm", defaultValue = "") String srcBranchNm,		
			@RequestParam(value = "srcEvalUserNm", defaultValue = "") String srcEvalUserNm,		
			@RequestParam(value = "srcWorkId", defaultValue = "") String srcWorkId,		
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,		
			@RequestParam(value = "srcEvalYear", defaultValue = "") String srcEvalYear,		
			@RequestParam(value = "srcEvalMonth", defaultValue = "") String srcEvalMonth,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,				
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBranchNm"	, srcBranchNm);
		params.put("srcEvalUserNm"	, srcEvalUserNm);
		params.put("srcWorkId"		, srcWorkId);
		params.put("srcUserNm"		, srcUserNm);
		params.put("srcEvalDate"	, srcEvalYear + srcEvalMonth);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
        List<Map<String, Object>> list = evaluateSvc. selectEvaluateListExcel(params);
        
		if(list != null && list.size() > 0){
			for(int i = 0; i < list.size() ; i++){
				list.get(i).put("branchNm", list.get(i).get("branchNm").toString().replace("&gt;", ">"));
				if(!list.get(i).get("COLID").toString().equals("1")){
					list.get(i).put("branchNm"	, "");
					list.get(i).put("workNm"	, "");
					list.get(i).put("userNm"	, "");
					list.get(i).put("evalUserNm", "");
					list.get(i).put("evalDate"	, "");
				}
			}
		}

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
		
//        modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", list);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;
	}		
	
	@RequestMapping("evaluateListJQgrid.sys")
	public ModelAndView evaluateListJQgrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "evalDate") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,		
			
			@RequestParam(value = "srcBranchNm", defaultValue = "") String srcBranchNm,		
			@RequestParam(value = "srcEvalUserNm", defaultValue = "") String srcEvalUserNm,		
			@RequestParam(value = "srcWorkId", defaultValue = "") String srcWorkId,		
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,		
			@RequestParam(value = "srcEvalYear", defaultValue = "") String srcEvalYear,		
			@RequestParam(value = "srcEvalMonth", defaultValue = "") String srcEvalMonth,		
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBranchNm"	, srcBranchNm);
		params.put("srcEvalUserNm"	, srcEvalUserNm);
		params.put("srcWorkId"		, srcWorkId);
		params.put("srcUserNm"		, srcUserNm);
		params.put("srcEvalDate"	, srcEvalYear + srcEvalMonth);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		int records = evaluateSvc. selectEvaluateListCnt(params);
		int total = (int)Math.ceil((float)records / (float)rows);
		
		/*----------------조회------------*/
		List<Map<String, Object>> list = null;
		if(records>0) list = evaluateSvc. selectEvaluateList(params, page, rows);		
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/*
	 * 고객사, 공급사 스마일 지수 평가 처리 
	 */
	@RequestMapping("setSmileEval.sys")
	public ModelAndView setSmileEval(
			@RequestParam(value = "smileIdArr[]", defaultValue = "") String[] smileIdArr,				
			@RequestParam(value = "targetSvcCdArr[]", defaultValue = "") String[] targetSvcCdArr,		
			@RequestParam(value = "evalArr[]", defaultValue = "") String[] evalArr,		
			@RequestParam(value = "targetVenId", defaultValue = "") String targetVenId,		
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		HashMap<String,Object> params = new HashMap<String,Object>();
		
		CustomResponse customResponse = new CustomResponse(true);
			try{
				params.put("userInfoDto", userInfoDto);
				params.put("smileIdArr", smileIdArr);
				params.put("targetSvcCdArr", targetSvcCdArr);
				params.put("evalArr", evalArr);
				params.put("targetVenId", targetVenId);
				evaluateSvc.setSmileEval(params);
				
			}catch(Exception e){
				logger.debug("Exception   ::  " + e.getStackTrace());
				customResponse.setSuccess(false);
				customResponse.setMessage("시스템 처리 중 에러가 발생하였습니다.");
			}
		
		modelAndView.addObject("customResponse",customResponse);	
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
}