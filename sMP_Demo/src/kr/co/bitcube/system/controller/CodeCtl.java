package kr.co.bitcube.system.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.common.utils.ExcelReader;
import kr.co.bitcube.common.utils.MultipartFileUpload;
import kr.co.bitcube.system.dto.CodeTypesDto;
import kr.co.bitcube.system.service.CodeSvc;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("system")
public class CodeCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired private CodeSvc codeSvc;
	@Autowired private GeneralDao generalDao;
	
	@RequestMapping("codeList.sys")
	public ModelAndView codeList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("system/code/codeList");
	}
	
	@RequestMapping("codeTypeListJQGrid.sys")
	public ModelAndView codeTypeListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "codeTypeId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			/* Grid Search 기능 사용 시
			@RequestParam(value = "_search", defaultValue = "false") boolean _search,
			@RequestParam(value = "searchOper", defaultValue = "") String searchOper,
			@RequestParam(value = "searchString", defaultValue = "") String searchString,
			@RequestParam(value = "searchField", defaultValue = "") String searchField,
			*/
			@RequestParam(value = "srcCodeTypeCd", defaultValue = "") String srcCodeTypeCd,
			@RequestParam(value = "srcCodeTypeNm", defaultValue = "") String srcCodeTypeNm,
			@RequestParam(value = "srcCodeFlag", defaultValue = "") String srcCodeFlag,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {

		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCodeTypeCd", srcCodeTypeCd);
		params.put("srcCodeTypeNm", srcCodeTypeNm);
		params.put("srcCodeFlag", srcCodeFlag);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		/* Grid Search 기능 사용 시
		if(_search){
			String soptSignString = CommonUtils.getStringSoptSign(searchOper, searchString);
			params.put("soptSignString", soptSignString);
			params.put("searchField",    searchField);
			params.put("searchString",   searchString);
		}
		*/
		/*----------------페이징 세팅------------*/
        int records = codeSvc.getCodeTypeListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<CodeTypesDto> list = null;
        if(records>0) {
        	list = codeSvc.getCodeTypeList(params, page, rows);
        }
        
        /*----------------(Deprecate)조회정보를 Json Object로 Parsing -> JsonResolover로 대체 ------------*/
//		Map<String,Object> map = new HashMap<String,Object>();
//		map.put("page", page);
//		map.put("total", total);
//		map.put("records", records);
//		map.put("list", list);
//		JSONObject jsonObject = JSONObject.fromObject(map);
//		response.setHeader("Content-Type", "text/html; charset=UTF-8");
//		response.getWriter().write(jsonObject.toString());
        
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	@RequestMapping("codeTypeListExcel.sys")
	public ModelAndView codeTypeListExcel(
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "sidx", defaultValue = "codeTypeId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request, ModelMap paramMap) throws Exception {
		
		paramMap.put("isExcel", 1);	//Query에서 상태값을 Case처리하기 위함
		String orderString = " " + sidx + " " + sord + " ";	//그리드의 순서를 맞추기 위해(별의미 없음!!) 
		paramMap.put("orderString", orderString);
		List<Object> list = generalDao.selectGernalList("system.code.selectCodeTypeList", paramMap);
		List<Map<String, Object>> list1 = new ArrayList<Map<String, Object>>();
		for(Object obj : list) {
			list1.add(CommonUtils.ConverObjectToMap(obj));
		}
		
		List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("sheetTitle", sheetTitle);
		map1.put("colLabels", colLabels);
		map1.put("colIds", colIds);
		map1.put("numColIds", numColIds);
		map1.put("figureColIds", figureColIds);
		map1.put("colDataList", list1);
		sheetList.add(map1);
		
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		
		return modelAndView;
	}
			
	
	@RequestMapping("codeListJQGrid.sys")
	public ModelAndView codeListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "disOrder") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,
			@RequestParam(value = "srcCodeTypeId", required = true) String srcCodeTypeId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {

		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCodeTypeId", srcCodeTypeId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
        List<CodesDto> list = codeSvc.getCodeList(params);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	@RequestMapping("codeTypeListExcelAll.sys")
	public ModelAndView codeTypeListExcelAll (
			ModelAndView modelAndView, HttpServletRequest request, ModelMap paramMap) throws Exception {
		paramMap.put("isExcel", 1);	//Query에서 상태값을 Case처리하기 위함
		paramMap.put("orderString", " codeTypeId desc");
		List<CodeTypesDto> list = codeSvc.getCodeTypeList(paramMap, RowBounds.NO_ROW_OFFSET, RowBounds.NO_ROW_LIMIT);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("isExcel", 1);	//Query에서 상태값을 Case처리하기 위함
		params.put("list", list);
		List<CodesDto> detailList = codeSvc.getCodeList(params);
		
		String[] colLabels1 = {"타입코드","코드타입명","코드타입설명","코드타입유형","사용여부"};
		String[] colIds1 = {"codeTypeCd","codeTypeNm","codeTypeDesc","codeFlag","isUse"};
		String[] numColIds1 = null;
		String[] figureColIds1 = null;
		List<Map<String, Object>> list1 = new ArrayList<Map<String, Object>>();
		for(Object obj : list) {
			list1.add(CommonUtils.ConverObjectToMap(obj));
		}
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", "코드유형");
        map1.put("colLabels", colLabels1);
        map1.put("colIds", colIds1);
        map1.put("numColIds", numColIds1);
        map1.put("figureColIds", figureColIds1);
        map1.put("colDataList", list1);
        sheetList.add(map1);
        
        String[] colLabels2 = {"타입코드","코드명1","코드값1","코드명2","코드값2","순서","사용여부"};
        String[] colIds2 = {"codeTypeCd","codeNm1","codeVal1","codeNm2","codeVal2","disOrder","isUse"};
        String[] numColIds2 = {"disOrder"};
        String[] figureColIds2 = null;
        List<Map<String, Object>> list2 = new ArrayList<Map<String, Object>>();
        logger.debug("jameskang detailList.size : "+detailList.size());
		for(Object obj : detailList) {
//			logger.debug("jameskang obj : "+obj);
			list2.add(CommonUtils.ConverObjectToMap(obj));
		}
        Map<String, Object> map2 = new HashMap<String, Object>();
        map2.put("sheetTitle", "코드");
        map2.put("colLabels", colLabels2);
        map2.put("colIds", colIds2);
        map2.put("numColIds", numColIds2);
        map2.put("figureColIds", figureColIds2);
        map2.put("colDataList", list2);
        sheetList.add(map2);
        
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", "CodeTypesAndCodes");
        modelAndView.addObject("sheetList", sheetList);
		
		return modelAndView;
	}
	
	
	/*----------------------------codeList--------------------------*/
	@RequestMapping("codeTypeTransGrid.sys")
	public ModelAndView codeTypeTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "codeTypeCd", defaultValue = "") String codeTypeCd,
			@RequestParam(value = "codeTypeNm", defaultValue = "") String codeTypeNm,
			@RequestParam(value = "codeFlag", defaultValue = "") String codeFlag,
			@RequestParam(value = "isUse", defaultValue = "") String isUse,
			@RequestParam(value = "codeTypeDesc", defaultValue = "") String codeTypeDesc,
			@RequestParam(value = "id", defaultValue = "") String codeTypeId,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("codeTypeCd", codeTypeCd);
		saveMap.put("codeTypeNm", codeTypeNm);
		saveMap.put("codeFlag", codeFlag);
		saveMap.put("isUse", isUse);
		saveMap.put("codeTypeDesc", codeTypeDesc);
		saveMap.put("codeTypeId", codeTypeId);
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		saveMap.put("creatorId", loginUserDto.getUserId());
		saveMap.put("updaterId", loginUserDto.getUserId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				codeSvc.regCodeType(saveMap);
			} else if("edit".equals(oper)) {
				codeSvc.modCodeType(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("codeTypeId", codeTypeId);
				codeSvc.delCodeType(saveMap);
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
	
	@RequestMapping("codesTransGrid.sys")
	public ModelAndView codesTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "codeTypeId", defaultValue = "") String codeTypeId,
			@RequestParam(value = "codeTypeCd", defaultValue = "") String codeTypeCd,
			@RequestParam(value = "codeNm1", defaultValue = "") String codeNm1,
			@RequestParam(value = "codeVal1", defaultValue = "") String codeVal1,
			@RequestParam(value = "codeNm2", defaultValue = "") String codeNm2,
			@RequestParam(value = "codeVal2", defaultValue = "") String codeVal2,
			@RequestParam(value = "disOrder", defaultValue = "") String disOrder,
			@RequestParam(value = "isUse", defaultValue = "0") String isUse,
			@RequestParam(value = "id", defaultValue = "") String codeId,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("codeTypeId", codeTypeId);
		saveMap.put("codeTypeCd", codeTypeCd);
		saveMap.put("codeNm1", codeNm1);
		saveMap.put("codeVal1", codeVal1);
		saveMap.put("codeNm2", codeNm2);
		saveMap.put("codeVal2", codeVal2);
		saveMap.put("disOrder", disOrder);
		saveMap.put("isUse", isUse);
		saveMap.put("codeId", codeId);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				codeSvc.regCodes(saveMap);
			} else if("edit".equals(oper)) {
				codeSvc.modCodes(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("codeId", codeId);
				codeSvc.delCodes(saveMap);
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
	

	/*----------------------------codeList2--------------------------*/
	@RequestMapping("codeList2.sys")
	public ModelAndView codeList2(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("system/code/codeList2");
	}
	
	@RequestMapping("codeTypeCheckTransGrid.sys")
	public ModelAndView codeTypeCheckTransGrid(
			@RequestParam(value = "transFlag", required=true) String transFlag,
			@RequestParam(value = "codeTypeIdArray[]", required=true) String[] codeTypeIdArray,
			@RequestParam(value = "codeTypeNmArray[]", required=true) String[] codeTypeNmArray,
			@RequestParam(value = "codeFlagArray[]", required=true) String[] codeFlagArray,
			@RequestParam(value = "isUseArray[]", required=true) String[] isUseArray,
			@RequestParam(value = "codeTypeDescArray[]", required=true) String[] codeTypeDescArray,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("codeTypeIdArray", codeTypeIdArray);
		saveMap.put("codeTypeNmArray", codeTypeNmArray);
		saveMap.put("codeFlagArray", codeFlagArray);
		saveMap.put("isUseArray", isUseArray);
		saveMap.put("codeTypeDescArray", codeTypeDescArray);
		saveMap.put("updaterId", loginUserDto.getUserId());
		saveMap.put("remoteIp", loginUserDto.getRemoteIp());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("MOD".equals(transFlag)) {
				codeSvc.modCheckCodeType(saveMap);
			} else if("DEL".equals(transFlag)) {
				saveMap.clear();
				saveMap.put("codeTypeIdArray", codeTypeIdArray);
				codeSvc.delCheckCodeType(saveMap);
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
	
	@RequestMapping("codesCheckTransGrid.sys")
	public ModelAndView codesCheckTransGrid(
			@RequestParam(value = "transFlag", required=true) String transFlag,
			@RequestParam(value = "codeVal1Array[]", required=true) String[] codeVal1Array,
			@RequestParam(value = "codeNm1Array[]", required=true) String[] codeNm1Array,
			@RequestParam(value = "codeVal2Array[]", required=false) String[] codeVal2Array,
			@RequestParam(value = "codeNm2Array[]", required=false) String[] codeNm2Array,
			@RequestParam(value = "disOrderArray[]", required=true) String[] disOrderArray,
			@RequestParam(value = "isUseArray[]", required=true) String[] isUseArray,
			@RequestParam(value = "codeIdArray[]", required=true) String[] codeIdArray,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("codeVal1Array", codeVal1Array);
		saveMap.put("codeNm1Array", codeNm1Array);
		saveMap.put("codeVal2Array", codeVal2Array);
		saveMap.put("codeNm2Array", codeNm2Array);
		saveMap.put("disOrderArray", disOrderArray);
		saveMap.put("isUseArray", isUseArray);
		saveMap.put("codeIdArray", codeIdArray);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("MOD".equals(transFlag)) {
				codeSvc.modCheckCodes(saveMap);
			} else if("DEL".equals(transFlag)) {
				saveMap.clear();
				saveMap.put("codeIdArray", codeIdArray);
				codeSvc.delCheckCodes(saveMap);
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
	
	@RequestMapping("codeExcelUpload.sys")
	public ModelAndView codeExcelUpload(
			@RequestParam(value = "codeTypeId", required=true) String codeTypeId,
			@RequestParam(value = "codeTypeCd", required=true) String codeTypeCd,
			@RequestParam(value = "excelFile", required=true) MultipartFile excelFile,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		modelAndView = new ModelAndView("jsonView");
		
		String excelUploadDirPath = Constances.EXCEL_UPLOAD_PATH;
		File excelUploadDir = new File(excelUploadDirPath);
		MultipartFileUpload multipartFileUpload = null;
		/*----------------------Excel Upload Start------------------------*/
		try {
			if(!excelUploadDir.exists()) excelUploadDir.mkdirs();
			multipartFileUpload = new MultipartFileUpload(excelFile, excelUploadDir);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("Upload File Save Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			modelAndView.addObject(custResponse);
			return modelAndView;
		}

		/*--------------------- Excel에서 Data을 뽑아옴------------------------*/
		String[] colNames = {"codeNm1", "codeVal1", "codeNm2", "codeVal2", "disOrder", "isUse"};	//엑셀의 Data Fild 와 같아야 함 (DB저장시 mapKey로 쓰임)
		ExcelReader excelReader = new ExcelReader(multipartFileUpload.getUploadedFile());
		List<Map<String, Object>> saveList = excelReader.getExcelReadList(0, colNames);
		/*---------Data Log write
		logger.debug("saveList.size() : "+saveList.size());
		for(Map<String, Object> map : saveList) {
			logger.debug("-------------------------------------------------");
			for(String mapKey : colNames) {
				logger.debug(mapKey + " : " + map.get(mapKey));
			}
		}
		-----------*/
		
		/*--------------------------처리수행 및 성공여부 세팅----------------------*/
		boolean isSucces = true;
		String errMessage = "아래 코드값은 등록 되지 못했습니다.";
		if(saveList!=null && saveList.size()>0) {
			for(Map<String, Object> saveMap : saveList) {
				saveMap.put("codeTypeId", codeTypeId);
				saveMap.put("codeTypeCd", codeTypeCd);
				try {
					codeSvc.regCodes(saveMap);
				} catch (Exception e) {
					if(isSucces) errMessage += "<br>["+saveMap.get("codeVal1")+"]";
					else errMessage += ", ["+saveMap.get("codeVal1")+"]";
					isSucces = false;
				}
			}
		} else {
			errMessage = "Data가 존재하지 않거나 형식에 맞지 않습니다.";
			isSucces = false;
		}
		if(!isSucces) {
			logger.error("Exception : Excel Data 사용자정의 Exception");
			custResponse.setSuccess(false);
			custResponse.setMessage(errMessage);
			modelAndView.addObject(custResponse);
			return modelAndView;
		}
		
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	

	/*----------------------------codeList3--------------------------*/
	@RequestMapping("codeList3.sys")
	public ModelAndView codeList3(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("system/code/codeList3");
	}
	
}
