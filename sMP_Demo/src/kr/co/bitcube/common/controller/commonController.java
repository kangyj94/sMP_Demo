package kr.co.bitcube.common.controller;

import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.board.service.BoardSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.BorgDto;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.DeliveryAddressDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UploadDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.dto.WorkInfoDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.common.utils.MultipartFileUpload;
import kr.co.bitcube.product.dto.BuyProductDto;
import kr.co.bitcube.product.dto.CategoryDto;
import kr.co.bitcube.system.service.BorgSvc;
import kr.co.bitcube.system.service.CodeSvc;
import kr.co.bitcube.system.service.EtcSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.WebUtils;

@Controller
@RequestMapping("common")
public class commonController {

	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private CommonSvc commonSvc;
	@Autowired
	private BorgSvc borgSvc;
	@Autowired
	private CodeSvc codeSvc;
	@Autowired
	private EtcSvc etcSvc;
	@Autowired
	private BoardSvc boardSvc;
	@Autowired
	private GeneralDao generalDao;
	/**
	 * Excel Download 공통 Controller
	 * @param sheetTitle
	 * @param excelFileName
	 * @param colLabels
	 * @param colIds
	 * @param numColIds
	 * @param colDatas
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonExcelExport.sys")
	public ModelAndView commonExcelExport(
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "colDatas", required = false) String[] colDatas,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		List<Map<String, Object>> colDataList = new ArrayList<Map<String, Object>>();
		if(colDatas!=null) {
			for(int i=0;i<colDatas.length;i++) {
				Map<String, Object> dataMap = new HashMap<String, Object>();
				String[] dataArray = colDatas[i].split("∥");
//				if(logger.isDebugEnabled()) {
//					logger.debug("dataArray length : "+dataArray.length);
//					logger.debug("colIds length : "+colIds.length);
//				}
				for(int j=0;j<colIds.length;j++) {
					dataMap.put(colIds[j], dataArray[j]);
				}
				colDataList.add(dataMap);
			}
		}
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);
		
//		modelAndView.setViewName("commonExcelViewResolver");
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
		
		return modelAndView;
	}
	
	/**
	 * 코드정보리스트을 Json형태 반환 공통 Controller
	 * @param codeTypeCd
	 * @param isUse
	 * @param codeVal2
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getCodeList.sys")
	public ModelAndView getCodeList(
			@RequestParam(value = "codeTypeCd", required = false) String codeTypeCd,
			@RequestParam(value = "isUse", defaultValue = "") int isUse,
			@RequestParam(value = "codeVal2", defaultValue = "") String codeVal2,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		List<CodesDto> codeList = commonSvc.getCodeList(codeTypeCd, isUse, codeVal2);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("codeList", codeList);
		
		return modelAndView;
	}
	
	/**
	 * 조직유형에 따른 사용자조회
	 * @param page
	 * @param rows
	 * @param srcSvcTypeCd
	 * @param srcUserNm
	 * @param srcLoginId
	 * @param sidx
	 * @param sord
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("svcMemberListJQGrid.sys")
	public ModelAndView svcMemberListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "10") int rows,
			@RequestParam(value = "srcSvcTypeCd", defaultValue = "") String srcSvcTypeCd,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "isDirector", defaultValue = "") String isDirector,
			@RequestParam(value = "srcDirectorUserId", defaultValue = "") String srcDirectorUserId,
			@RequestParam(value = "srcUserId", defaultValue = "") String srcUserId,
			@RequestParam(value = "sidx", defaultValue = "BORGNMS") String sidx,
			@RequestParam(value = "sord", defaultValue = "ASC") String sord,
			@RequestParam(value = "srcClientNm", defaultValue = "") String srcClientNm,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSvcTypeCd", srcSvcTypeCd);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("isDirector", isDirector);
		params.put("srcDirectorUserId", srcDirectorUserId);
		params.put("srcUserId", srcUserId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("srcClientNm", srcClientNm);
		
		/*----------------페이징 세팅------------*/
		int records = 0;
//		if(!"".equals(srcSvcTypeCd)) {
			records = commonSvc.getSvcUserListCnt(params); //조회조건에 따른 카운트
//		}
		int total = (int)Math.ceil((float)records / (float)rows);
        
        /*----------------조회------------*/
        List<LoginUserDto> list = null;
        if(records>0) {
        	list = commonSvc.getSvcUserList(params, page, rows);
        }
		
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 조직정보의 트리구조 조회
	 * @param nodeid
	 * @param lastBorgTypeCd
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("borgTreeJQGrid.sys")
	public ModelAndView borgTreeJQGrid(
			@RequestParam(value = "nodeid", defaultValue = "") String nodeid,
			@RequestParam(value = "lastBorgTypeCd", defaultValue = "") String lastBorgTypeCd,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		List<BorgDto> returnList = new ArrayList<BorgDto>();
		
		/*----------------조회조건 세팅 및 조회------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("svcTypeCd", "BUY");
		if(nodeid.length()>0) {
			String borgId = nodeid.split("∥")[0];
			@SuppressWarnings("unused")
			String borgTypeCd = nodeid.split("∥")[1];
			int borgLevel = Integer.parseInt(nodeid.split("∥")[2]);
			
			if(borgLevel==0) {
				searchMap.put("borgTypeCd", "GRP");
			} else if(borgLevel==1) {
				searchMap.put("borgLevel", borgLevel+1);
				searchMap.put("groupId", borgId);
				searchMap.put("borgTypeCd", "CLT");
			} else if(borgLevel==2) {
				searchMap.put("borgLevel", borgLevel+1);
				searchMap.put("clientId", borgId);
				searchMap.put("borgTypeCd", "BCH");
			} else if(borgLevel==3) {
				searchMap.put("borgLevel", borgLevel+1);
				searchMap.put("branchId", borgId);
				searchMap.put("borgTypeCd", "DEP");
			} else {
				searchMap.put("borgLevel", borgLevel+1);
				searchMap.put("deptId", borgId);
				searchMap.put("borgTypeCd", "DEP");
			}
			
			/*----------------조회------------*/
			returnList = borgSvc.getBorgTreeList(searchMap);
			for(BorgDto borgDto:returnList) {
				borgDto.setParent(nodeid);
				borgDto.setLevel(borgDto.getBorgLevel());
				
				//lastBorgTypeCd 마지막 최하위조직 조회 타입에 따른 isLeaf 세팅
				if(lastBorgTypeCd.equals(borgDto.getBorgTypeCd())) {
					borgDto.setIsLeaf("true");
				}
			}
		} else {	//최상위 조직
			BorgDto dumpDto = new BorgDto();
			dumpDto.setTreeKey("0∥∥0");
			dumpDto.setBorgNm("조직");
			dumpDto.setParent("0");
			dumpDto.setLevel(0);
			dumpDto.setIsLeaf("false");
			returnList.add(dumpDto);
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list",returnList);
		return modelAndView;
	}
	
	/**
	 * image upload
	 * @param attachFile
	 * @param modelAndView
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonImageUpload.sys")
	public ModelAndView commonImageUpload(
			@RequestParam(value = "attachFile", required=true) MultipartFile attachFile,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String url = Constances.SYSTEM_IMAGE_PATH + "/board";
		String path = WebUtils.getRealPath(request.getSession().getServletContext(), url); 
		
		String fileName = attachFile.getOriginalFilename(); 
		String fileExt = fileName.substring(fileName.lastIndexOf("."));
		String fileTmpName = InetAddress.getLocalHost().getHostAddress().replace(".", "")+"X" + System.currentTimeMillis()+fileExt;

		//폴더 생성
		File folder   = new File(WebUtils.getRealPath(request.getSession().getServletContext(), url));
		if(!folder.exists())	folder.mkdirs();
		
		//board 폴더 추가 사용
		File file = new File(path + File.separator + fileTmpName);
		Path p = Paths.get(file.toURI());
		logger.debug("attachfile:"+file.getAbsolutePath());
		attachFile.transferTo(file);
		
		UploadDto uploadDto = new UploadDto();
		uploadDto.setAttachFile(attachFile);
		uploadDto.setAttachFilePath(url);
		uploadDto.setAttachFileMime(Files.probeContentType(p));
		uploadDto.setAttachFileName(fileTmpName);
		
		modelAndView.setViewName("common/imageUpload");
		modelAndView.addObject("upload", uploadDto);
		return modelAndView;
	}
	
	/**
	 * 파일첨부하기
	 * @param attach_seq
	 * @param uploadFile
	 * @param modelAndView
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("attachFileUpload.sys")
	public ModelAndView attachFileUpload(
			@RequestParam(value = "attach_seq", defaultValue="") String attach_seq,
			@RequestParam(value = "uploadFile", required=true) MultipartFile uploadFile,
			@RequestParam(value = "isFileSizeChk", defaultValue="") String isFileSizeChk,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		modelAndView = new ModelAndView("jsonView");
		String uploadDirPath = Constances.COMMON_ATTACH_PATH;
		File uploadDir = new File(uploadDirPath);
		MultipartFileUpload multipartFileUpload = null;
		/*----------------------Excel Upload Start------------------------*/
		try {
			if("".equals(isFileSizeChk) == false){
				if((Long.parseLong(isFileSizeChk)*1000000)<= uploadFile.getSize()){
					throw new Exception();
				}else{
					if(!uploadDir.exists()) uploadDir.mkdirs();
					multipartFileUpload = new MultipartFileUpload(uploadFile, uploadDir);
				}
			}else{
//				if(10485760 <= uploadFile.getSize()){
//					throw new Exception("10메가 이상을 초과하였습니다.");
//				}else{
					if(!uploadDir.exists()) uploadDir.mkdirs();
					multipartFileUpload = new MultipartFileUpload(uploadFile, uploadDir);
//				}
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(e.getMessage());
//			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			modelAndView.addObject(custResponse);
			return modelAndView;
		}
		
		/*--------------------- 처리값 세팅------------------------*/
		String attach_file_name = multipartFileUpload.getFileName();
		String attach_file_path = multipartFileUpload.getUploadedFile().replaceAll("\\\\", "/");
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("attach_seq", attach_seq);
		saveMap.put("attach_file_name", attach_file_name);
		saveMap.put("attach_file_path", attach_file_path);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		try {
			saveMap = commonSvc.saveUploadFile(saveMap);
			custResponse.setMessage((String)saveMap.get("attach_seq"));	//1메시지로 attach_seq 전달
			custResponse.setMessage((String)saveMap.get("attach_file_name"));	//2메시지로 attach_file_name 전달
			custResponse.setMessage((String)saveMap.get("attach_file_path"));	//3메시지로 attach_file_path 전달
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 파일첨부하기
	 * @param attach_seq
	 * @param uploadFile
	 * @param modelAndView
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("attachEvalFileUpload.sys")
	public ModelAndView attachEvalFileUpload(
			@RequestParam(value = "attach_seq", defaultValue="") String attach_seq,
			@RequestParam(value = "uploadFile", required=true) MultipartFile uploadFile,
			@RequestParam(value = "isFileSizeChk", defaultValue="") String isFileSizeChk,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		modelAndView = new ModelAndView("jsonView");
		String uploadDirPath = Constances.COMMON_ATTACH_PATH + "/evaluate";
		File uploadDir = new File(uploadDirPath);
		MultipartFileUpload multipartFileUpload = null;
		/*----------------------Excel Upload Start------------------------*/
		try {
			if("".equals(isFileSizeChk) == false){
				if((Long.parseLong(isFileSizeChk)*1000000)<= uploadFile.getSize()){
					throw new Exception();
				}else{
					if(!uploadDir.exists()) uploadDir.mkdirs();
					multipartFileUpload = new MultipartFileUpload(uploadFile, uploadDir);
				}
			}else{
//				if(10485760 <= uploadFile.getSize()){
//					throw new Exception("10메가 이상을 초과하였습니다.");
//				}else{
					if(!uploadDir.exists()) uploadDir.mkdirs();
					multipartFileUpload = new MultipartFileUpload(uploadFile, uploadDir);
//				}
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(e.getMessage());
//			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			modelAndView.addObject(custResponse);
			return modelAndView;
		}
		
		/*--------------------- 처리값 세팅------------------------*/
		String attach_file_name = multipartFileUpload.getFileName();
		String attach_file_path = multipartFileUpload.getUploadedFile().replaceAll("\\\\", "/");
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("attach_seq", attach_seq);
		saveMap.put("attach_file_name", attach_file_name);
		saveMap.put("attach_file_path", attach_file_path);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		try {
			saveMap = commonSvc.saveUploadFile(saveMap);
			custResponse.setMessage((String)saveMap.get("attach_seq"));	//1메시지로 attach_seq 전달
			custResponse.setMessage((String)saveMap.get("attach_file_name"));	//2메시지로 attach_file_name 전달
			custResponse.setMessage((String)saveMap.get("attach_file_path"));	//3메시지로 attach_file_path 전달
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * File download
	 * @param attachFilePath
	 * @param modelAndView
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("attachFileDownload.sys")
	public ModelAndView attachFileDownload(
			@RequestParam(value = "attachFilePath", required=true) String attachFilePath,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
	
		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			logger.debug("attachFilePath : " + attachFilePath);
			logger.debug("-------------------------end!---------------------------");
		}
		File file = new File(attachFilePath);
		String attachOriginName = commonSvc.selectAttachOringinName(attachFilePath);

		modelAndView.setViewName("fileDownViewResolver");
		modelAndView.addObject("file", file);
		modelAndView.addObject("attachOriginName", new String(attachOriginName.getBytes("ksc5601"), "euc-kr"));
		return modelAndView;
	}
	
	/**
	 * 고객사검색 DIV
	 * @param page
	 * @param rows
	 * @param srcBorgType
	 * @param srcBorgNm
	 * @param sidx
	 * @param sord
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("borgDivListJQGrid.sys")
	public ModelAndView borgDivListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "10") int rows,
			@RequestParam(value = "srcBorgType", defaultValue = "") String srcBorgType,
			@RequestParam(value = "srcBorgNm", defaultValue = "") String srcBorgNm,
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,
			@RequestParam(value = "multiSelYN", defaultValue = "") String multiSelYN,
			@RequestParam(value = "isWork", defaultValue = "") String isWork,
			@RequestParam(value = "isAcc", defaultValue = "") String isAcc,
			@RequestParam(value = "srcWork", defaultValue = "") String srcWork,
			@RequestParam(value = "branchIsUse", defaultValue = "") String branchIsUse,
			
			@RequestParam(value = "sidx", defaultValue = "BORGNMS") String sidx,
			@RequestParam(value = "sord", defaultValue = "ASC") String sord,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBorgTypeCd", srcBorgType);
		params.put("srcBorgNm", srcBorgNm);
		params.put("srcClientId", srcClientId);
		params.put("multiSelYN", multiSelYN);
		params.put("isWork", isWork);
		params.put("isAcc", isAcc);
		params.put("srcWork", srcWork);
		params.put("branchIsUse", branchIsUse);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		logger.debug("params value ["+params+"]");
		/*----------------페이징 세팅------------*/
		int records = commonSvc.getBuyBorgDivListCnt(params);
		int total = (int)Math.ceil((float)records / (float)rows);
        
        /*----------------조회------------*/
        List<BorgDto> list = null;
        if(records>0) {
        	list = commonSvc.getBuyBorgDivList(params, page, rows);
        }
		
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공급사검색 DIV
	 * @param page
	 * @param rows
	 * @param srcAreaType
	 * @param srcVendorNm
	 * @param sidx
	 * @param sord
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("vendorDivListJQGrid.sys")
	public ModelAndView vendorDivListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "10") int rows,
			@RequestParam(value = "srcAreaType", defaultValue = "") String srcAreaType,
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,
			@RequestParam(value = "vendorIsUse", defaultValue = "") String vendorIsUse,
			@RequestParam(value = "sidx", defaultValue = "BORGNMS") String sidx,
			@RequestParam(value = "sord", defaultValue = "ASC") String sord,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcAreaType", srcAreaType);
		params.put("srcVendorNm", srcVendorNm);
		params.put("vendorIsUse", vendorIsUse);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
		int records = commonSvc.getVendorDivListCnt(params);
		int total = (int)Math.ceil((float)records / (float)rows);
        
        /*----------------조회------------*/
        List<BorgDto> list = null;
        if(records>0) {
        	list = commonSvc.getVendorDivList(params, page, rows);
        }
		
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 사업장id를 이용 해당 사업장 사용자를 조회반환한다. 공통Controller 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getUserInfoListByBranchId.sys")
	public ModelAndView getUserInfoListByBranchId(
			@RequestParam(value = "borgId", required = false) String borgId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		List<UserDto> codeList = commonSvc.getUserInfoListByBranchId(borgId);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("userList", codeList);
		
		return modelAndView;
	}
	
	/**
	 * 사업장id를 이용 해당 사업장 배송지 정보반환 한다. 공통 Controller 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getDeliveryAddressByBranchId.sys")
	public ModelAndView getDeliveryAddressByBranchId(
			@RequestParam(value = "groupId", required = false) String groupId ,
			@RequestParam(value = "clientId", required = false) String clientId,
			@RequestParam(value = "branchId", required = false) String branchId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		List<DeliveryAddressDto> deliveryAddressDto = commonSvc.getDeliveryAddressByBranchId(groupId,clientId,branchId);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("deliveryListInfo", deliveryAddressDto);
		
		return modelAndView;
	}
	
	/**
	 * 사업장 진열 카테고리 정보를 조회한다.  
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("GetCateListInfoByBuyBorg.sys")
	public ModelAndView getDispCateListInfoByBuyBorg(
			@RequestParam(value = "groupId", required = false) String groupId ,
			@RequestParam(value = "clientId", required = false) String clientId,
			@RequestParam(value = "branchId", required = false) String branchId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		List<CategoryDto> deliveryAddressDto = commonSvc.getDispCateListInfoByBuyBorg(groupId,clientId,branchId );
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("dispCateListInfo", deliveryAddressDto);
		
		return modelAndView;
	}
	/**
	 * 우편번호검색
	 * @param srcPostAddrDiv
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("postSearchDivListJQGrid.sys")
	public ModelAndView postSearchDivListJQGrid(
			@RequestParam(value = "srcPostAddrDiv", defaultValue = "") String srcPostAddrDiv,
			@RequestParam(value = "srcPostTypeDiv", defaultValue = "") String srcPostTypeDiv,
			@RequestParam(value = "srcSido", defaultValue = "") String srcSido,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcPostAddrDiv", srcPostAddrDiv);
		
        /*----------------조회------------*/
        List<Map<String, Object>> list = null;
        if(!"".equals(srcPostAddrDiv)) {
        	if("NEW".equals(srcPostTypeDiv)){
        		params.put("srcSido", srcSido);
        		list = commonSvc.getNewPostAddressList(params);
        	}else if("OLD".equals(srcPostTypeDiv)){
        		list = commonSvc.getPostAddressList(params);
        	}
        }
		
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 배송지관리정보을 저장/삭제
	 * @param groupId
	 * @param clientId
	 * @param branchId
	 * @param oper
	 * @param id
	 * @param shippingPlace
	 * @param shippingAddres
	 * @param isDefault
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveDeliveryManage.sys")
	public ModelAndView saveDeliveryManage(
			@RequestParam(value = "groupId", required = false) String groupId ,
			@RequestParam(value = "clientId", required = false) String clientId,
			@RequestParam(value = "branchId", required = false) String branchId,
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "id", required = false) String id,
			@RequestParam(value = "shippingPlace", defaultValue = "") String shippingPlace,
			@RequestParam(value = "shippingAddres", defaultValue = "") String shippingAddres,
			@RequestParam(value = "isDefault", defaultValue = "0") String isDefault,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("groupId", groupId);
		saveMap.put("clientId", clientId);
		saveMap.put("branchId", branchId);
		saveMap.put("shippingPlace", shippingPlace);
		saveMap.put("shippingAddres", shippingAddres);
		saveMap.put("isDefault", isDefault);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			if("add".equals(oper)) {
				commonSvc.regDeliveryManage(saveMap);
			} else if("del".equals(oper)) {
				saveMap.clear();
				saveMap.put("deliveryId", id);
				commonSvc.delDeliveryManage(saveMap);
			} else if("edit".equals(oper)) {
				saveMap.put("deliveryId", id);
				commonSvc.modDeliveryManage(saveMap);
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
	
	/**
	 * 이미지 리사이즈 페이지로 이동하는 메소드
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("imageResizePage.sys")
	public ModelAndView imageResizePage(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCodeTypeCd", "IMAGERESIZETYPE");
		params.put("orderString", "A.DISORDER ASC");
		
		modelAndView.setViewName("system/etc/imageResize");
		modelAndView.addObject("imageResizeType", this.codeSvc.getCodeList(params));
		return modelAndView;
	}
	
	/**
	 * 이미지 파일을 리사이즈 하고 그 결과를 리턴하는 메소드
	 * @param imageFile
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("imageResizeProcess.sys")
	public ModelAndView imageResizeProcess(
			@RequestParam(value = "imageFile", required=true) MultipartFile imageFile,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		ServletContext servletContext = request.getServletContext();
		String realPath = servletContext.getRealPath(Constances.SYSTEM_IMAGE_PATH);
		Map<String, String> resizeResult = this.etcSvc.imageResizeProcess(imageFile, realPath); // 이미지 리사이즈 하고 그 결과를 반환
		
		modelAndView.setViewName("jsonView");
		modelAndView.addAllObjects(resizeResult);
		return modelAndView;
	}

	/**
	 * 공인인증존재여부 확인
	 * @param svcTypeCd
	 * @param borgId
	 * @param request
	 * @param modelAndView
	 * @return CustomResponse(true:존재, false:미존재)
	 * @throws Exception
	 */
	@RequestMapping("getIsExistPublishAuth.sys")
	public ModelAndView getIsExistPublishAuth(
			@RequestParam(value = "svcTypeCd", required=true) String svcTypeCd,
			@RequestParam(value = "borgId", required=true) String borgId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		boolean isExistPublishAuth = false;
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse();
		try {
			isExistPublishAuth = commonSvc.getIsExistPublishAuth(svcTypeCd, borgId);
			custResponse.setSuccess(isExistPublishAuth);
		} catch(Exception e) {
			logger.error("인증 체크 Error Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("인증서 존재여부 체크 중 에러가 발생하였습니다.\n관리자에게 문의 바랍니다.");
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	/**
	 * 공인인증서 등록(사업장 등록)
	 */
	@RequestMapping("authBusinessNumber.sys")
	public ModelAndView authBusinessNumber(
			@RequestParam(value = "borgType", required=true) String borgType,
			@RequestParam(value = "useType", required=true) String useType,
			@RequestParam(value = "authStep", required=true) String authStep,
			@RequestParam(value = "borgId", defaultValue = "") String borgId,
			@RequestParam(value = "businessNum", required=true) String businessNum,
			@RequestParam(value = "signed_data", required=true) String signed_data,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int i = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(i++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
		
		
		/*----------------저장값 세팅------------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("borgType"		, borgType);
		saveMap.put("useType"		, useType);
		saveMap.put("authStep"		, authStep);
		saveMap.put("borgId"		, borgId);
		saveMap.put("businessNum"	, businessNum);
		saveMap.put("signed_data"	, signed_data);

		if("0".equals(authStep) && "ETC".equals(useType)){
			LoginUserDto userInfoDto = CommonUtils.getLoginUserDto(request);
			
			if(userInfoDto != null){
				saveMap.put("creatUserId", userInfoDto.getUserId());
				saveMap.put("remoteIp",    userInfoDto.getRemoteIp());
			}
			else{
				saveMap.put("creatUserId", " ");
				saveMap.put("remoteIp",    request.getRemoteAddr());
			}
		}
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String[] resultArr = null;
		
		try {
			resultArr = commonSvc.authBusinessNumber(saveMap);
			custResponse.setSuccess(true);
			custResponse.setMessage(resultArr[0]);
			custResponse.setMessage(resultArr[1]);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}	
	

	
	/**
	 * 로그인 ID 찾기, Password 찾기
	 */
	@RequestMapping("userIdPasswordFind.sys")
	public ModelAndView userIdPasswordFind(
			@RequestParam(value = "srcUserNm", required = true) String srcUserNm,
			@RequestParam(value = "srcMobileNum", required = true) String srcMobileNum,
			@RequestParam(value = "srcLoginid", defaultValue = "") String srcLoginid,
			@RequestParam(value = "srcType", defaultValue = "") String srcType,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------체크값 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("srcUserNm", srcUserNm);
		searchMap.put("srcMobileNum", srcMobileNum);
		searchMap.put("srcLoginid", srcLoginid);
		searchMap.put("srcType", srcType);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = commonSvc.getUserIdPasswordFind(searchMap);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/**
	 * 공사유형정보리스트 조회
	 * @param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getWorkInfo.sys")
	public ModelAndView getWorkInfo(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		List<WorkInfoDto> workList = commonSvc.selectWorkInfo(params);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("workList", workList);
		return modelAndView;
	}
	
	/**
	 * 상품진열 SEQ 조회
	 * @param good_iden_numb
	 * @param vendorid
	 * @param request
	 * @param modelAndView
	 * @return CustomResponse(true:존재, false:미존재)
	 * @throws Exception
	 */
	@RequestMapping("getDispGoodId.sys")
	public ModelAndView getDispGoodId(
			@RequestParam(value = "good_iden_numb", required=true) String good_iden_numb,
			@RequestParam(value = "vendorid", required=true) String vendorid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("good_iden_numb", good_iden_numb);
		params.put("vendorid", vendorid);
		params.put("branchid", userInfoDto.getBorgId());
		
		List<BuyProductDto> displayGoodList = commonSvc.getDispGoodIdList(params);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("displayGoodList", displayGoodList);
		return modelAndView;
	}
	
	/** 문자 전송 팝업 */
	@RequestMapping("smsTransAgentPop.sys")
	public ModelAndView smsTransAgentPop( HttpServletRequest req, ModelAndView mav) throws Exception{
		// 권역 정보 조회
		List<CodesDto> codeList = commonSvc.getCodeList("DELI_AREA_CODE", 1);
        
        // 권한정보 조회 : 기본적으로 법인 고객사를 조회한다.
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSmsSvcTypeNm", "BUY");
		List<Map<String, Object>> returnRoleList = (List<Map<String, Object>>) commonSvc.getSmsRoleKind(params); 
        
        mav.addObject("areaTypeList", codeList);
        mav.addObject("roleList", returnRoleList);
        mav.addObject("workInfoList", generalDao.selectGernalList("common.etc.selectWorkInfo", null));
		mav.setViewName("common/smsTransAgentPop");
		return mav;
	}
	
	/** sms를 전송하기위한 사용자 조회 */
	@RequestMapping("smsSvcMemberListJQGrid.sys")
	public ModelAndView smsSvcMemberListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "10") int rows,
			
			@RequestParam(value = "srcSmsSvcTypeNm", defaultValue = "") String srcSmsSvcTypeNm,
			@RequestParam(value = "srcSmsRoleNm", defaultValue = "") String srcSmsRoleNm,
			@RequestParam(value = "srcSmsBorgNms", defaultValue = "") String srcSmsBorgNms,
			@RequestParam(value = "srcSmsDeliAreaCodeNm", defaultValue = "") String srcSmsDeliAreaCodeNm,
			@RequestParam(value = "srcSmsUserNm", defaultValue = "") String srcSmsUserNm,
			@RequestParam(value = "srcWorkInfo", defaultValue = "") String srcWorkInfo,
			@RequestParam(value = "prevWord", defaultValue = "") String prevWord,
			
			@RequestParam(value = "sidx", defaultValue = "BORGNMS") String sidx,
			@RequestParam(value = "sord", defaultValue = "ASC") String sord,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSmsSvcTypeNm", srcSmsSvcTypeNm);
		params.put("srcSmsRoleNm", srcSmsRoleNm);
		params.put("srcSmsBorgNms", srcSmsBorgNms);
		params.put("srcSmsDeliAreaCodeNm", srcSmsDeliAreaCodeNm);
		params.put("srcSmsUserNm", srcSmsUserNm);
		params.put("srcWorkInfo", srcWorkInfo);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		
		
		String addSql = "";
		String srcWord[] = prevWord.split("‡");
		if(srcWord!=null && srcWord.length>0) {
			for(int i = 0 ; i < srcWord.length ; i++) {
				if(srcWord[i].startsWith("＋")){
					addSql = " "+addSql + " AND (C.USERNM LIKE '%"+srcWord[i].replace("＋", "")+"%' OR A.BORGNM LIKE '%"+srcWord[i].replace("＋", "")+"%')";
				} else if(srcWord[i].startsWith("－")){
					addSql = " "+addSql + " AND (C.USERNM NOT LIKE '%"+srcWord[i].replace("－", "")+"%' AND A.BORGNM NOT LIKE '%"+srcWord[i].replace("－", "")+"%')";
				} else {
					addSql = " "+addSql + " AND (C.USERNM LIKE '%"+srcWord[i]+"%' OR A.BORGNM LIKE '%"+srcWord[i]+"%')";
				}
			}
			params.put("addSql", addSql);
			
			System.out.println("addSql : " + addSql);
		}
		
		
		
		int records =  commonSvc.getSmsSvcUserListCnt2(params); 
//		int records =  commonSvc.getSmsSvcUserListCnt(params);
		int total = (int)Math.ceil((float)records / (float)rows);
        
        List<Map<String,String>> list = null;
        if(records>0) {
        	list = commonSvc.getSmsSvcUserList2(params, page, rows);
//        	list = commonSvc.getSmsSvcUserList(params, page, rows);
        }
		
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	/** 서비스타입(운영사, 고객사, 공급사) 선택시 권한 조회. */
	@RequestMapping("getRoleInfoListBySmsSvcTypeNm.sys")
	public ModelAndView getRoleInfoListBySmsSvcTypeNm(
			@RequestParam(value = "srcSmsSvcTypeNm", required = false) String srcSmsSvcTypeNm,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		List<Map<String,String>> codeList = commonSvc.getRoleInfoListBySmsSvcTypeNm(srcSmsSvcTypeNm);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("smsRoleList", codeList);
		
		return modelAndView;
	}
	
	/** 입력된 sms 데이터 전송하기 */
	@RequestMapping("smsTransmissionMsg.sys")
	public ModelAndView orderListIncludeTotalSumJQGrid(
			@RequestParam(value = "trans_msg_desc", defaultValue = "") String trans_msg_desc,									// 발신 SMS 메세지
			@RequestParam(value = "trans_phone_numb", defaultValue = "") String trans_phone_numb,							// 발신자 번호
			@RequestParam(value = "receive_phone_numb_array[]", required=true) String[] receive_phone_numb_array,		// 수신자 번호
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("trans_msg_desc", trans_msg_desc);
		params.put("trans_phone_numb", trans_phone_numb);
		params.put("receive_phone_numb_array", receive_phone_numb_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			commonSvc.smsTransmissionMsg(params);
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
	
	/**
	 * 회원가입시 계약서 정보 받아오기
	 */
	@RequestMapping("memberJoinContractlist.sys")
	public ModelAndView memberJoinContractlist(
			@RequestParam(value="contractVersion", required=true)String contractVersion,
			@RequestParam(value="contractClassify", required=true)String contractClassify,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("contractVersion", contractVersion);
		params.put("contractClassify", contractClassify);
		
		List<Map<String, Object>> contractDetailList = null;
		try{
			contractDetailList = borgSvc.getCommodityContractView(params);
		}catch(Exception e){
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Select Error...");
		}
		mav.setViewName("jsonView");
		mav.addObject("contractDetailList", contractDetailList);
		return mav;
	}
	
	/**
	 * 메인화면 개인정보 취급방침 팝업 호출
	 */
	@RequestMapping("individualContractPopup.sys")
	public ModelAndView individualContractPopup(
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		Map<String, Object> individualContractDetail = null;
		try{
			individualContractDetail = commonSvc.getIndividualContractDetail();
		}catch(Exception e){
			logger.error("Exception : "+e);
		}
		mav.addObject("individualContractDetail", individualContractDetail.get("CONTRACT_CONTENTS"));
		mav.setViewName("/system/contract/individualContractPopup");
		return mav;
	}
	
	/**
	 * 초기팝업을 Json형태 반환 Controller
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("noticePopBoardMain.sys")
	public ModelAndView noticePopBoardMain(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		List<BoardDto> boardList = null;
		try{
			boardList = commonSvc.noticePopBoardMain();
		}
		catch(Exception e){
			logger.error("Exception : "+e);
		}
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("boardList", boardList);
		
		return modelAndView;
	}
	
	/**
	 * 초기팝업 공지사항 내용을 조회하여 반환하는 메소드
	 */
	@RequestMapping("noticePop.sys")
	public ModelAndView noticePop(
			@RequestParam(value = "board_No", required = true) String board_No,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("board_No", board_No);
		searchMap.put("board_Type", "0111");
		BoardDto detailInfo = boardSvc.getNoticePop(searchMap);
		modelAndView.setViewName("board/community/popupFormNew");
		modelAndView.addObject("detailInfo", detailInfo);
		return modelAndView;
	}
	
	/**
	 * 구매사가 서명해야되는 계약서 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("contractToDoList.sys")
	public ModelAndView branchContractToDoList(
			@RequestParam(value = "borgId", required = true) String borgId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object>       map               = null;
		List<Map<String, Object>> list              = null;
		String                    svcTypeCd         = null;
		String                    limitContractDate = null;
		
		map               = this.commonSvc.getContractToDoList(borgId);
		list              = (List<Map<String, Object>>)map.get("list");
		svcTypeCd         = (String)map.get("svcTypeCd");
		limitContractDate = (String)map.get("limitContractDate");
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list",              list);
		modelAndView.addObject("svcTypeCd",         svcTypeCd);
		modelAndView.addObject("limitContractDate", limitContractDate);
		
		return modelAndView;
	}
	
	/**
	 * 구매사 계약서 사인
	 */
	@RequestMapping("branchContractSign.sys")
	public ModelAndView branchContractSign(
			@RequestParam(value = "contractVirsion_array[]"	, required = true) String[] contractVirsion_array,
			@RequestParam(value = "borgId"					, required = true) String borgId,
			@RequestParam(value = "loginId"					, required = true) String loginId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		CustomResponse customResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("contractVirsion_array"	, contractVirsion_array);
		saveMap.put("borgId"				, borgId);
		saveMap.put("loginId"				, loginId);
		try{
			commonSvc.branchContractSign(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error...");
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
	/**
	 * 공급사 계약서 사인
	 */
	@RequestMapping("vendorContractSign.sys")
	public ModelAndView vendorContractSign(
			@RequestParam(value = "contractVirsion_array[]"	, required = true) String[] contractVirsion_array,
			@RequestParam(value = "borgId"					, required = true) String borgId,
			@RequestParam(value = "loginId"					, required = true) String loginId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		CustomResponse customResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("contractVirsion_array"	, contractVirsion_array);
		saveMap.put("borgId"				, borgId);
		saveMap.put("loginId"				, loginId);
		try{
			commonSvc.vendorContractSign(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error...");
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
	/**
	 * 계약서 상세 정보를 조회하는 메소드
	 * 
	 * @param svcTypeCd
	 * @param contractVersion
	 * @param contractSpecial
	 * @param request
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("popContractDetail.sys")
	public ModelAndView popContractDetail(
			@RequestParam(value="svcTypeCd",       required=true)     String svcTypeCd,
			@RequestParam(value="contractVersion", required=true)     String contractVersion,
			@RequestParam(value="borgId",          defaultValue = "") String borgId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		LoginUserDto        loginUserDto         = CommonUtils.getLoginUserDto(request);
		ModelMap            modelMap             = new ModelMap();
		Map<String, String> borgInfo             = null;
		Object              commodityContractNew = null;
		
		if(loginUserDto!=null) {
			borgId = loginUserDto.getBorgId();
		}
		
		modelMap.put("svcTypeCd",       svcTypeCd);
		modelMap.put("contractVersion", contractVersion);
		modelMap.put("borgId",          borgId);
		
		commodityContractNew = this.generalDao.selectGernalObject("system.borg.selectCommodityContractNewVersion", modelMap); // 계약서 내용 조회
		borgInfo             = this.commonSvc.getBorgInfo(borgId); // 조직 정보 조회
		
		modelAndView.addObject("commodityContractNew", commodityContractNew);
		modelAndView.addObject("borgInfo",             borgInfo);
		modelAndView.setViewName("/system/contract/popContractDetail");
		
		return modelAndView;
	}
	
	
	
	/** 네이버 스마트 에디터 이미지 업로드 팝업 창 호출 */
	@RequestMapping("nseiupm.sys")
	public ModelAndView nseiup( // Naver Smart Editor Img Upload Pupup Make
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("/common/photo_uploader");
		return modelAndView;
	}
	
	
	/** 스마트 에디터 업로드 */
	@RequestMapping("nseiu.sys") //Naver Smart Editor Image Upload
	public String nseiu(
	@RequestParam(value = "Filedata", required = true) MultipartFile filedata,
	HttpServletRequest request, HttpServletResponse response) {
		String return1 = request.getParameter("callback");
		String return2 = "?callback_func=" + request.getParameter("callback_func");
		String return3 = "";

		try {
			String targetDirectory = "/upload/image/smart/"; // image upload 경로
			if (filedata != null && filedata.getOriginalFilename() != null && !filedata.getOriginalFilename().equals("")) {
				String orgFileNm = filedata.getOriginalFilename().substring( filedata.getOriginalFilename().lastIndexOf( File.separator) + 1); // 원파일명
				String filename_ext = orgFileNm.substring(orgFileNm .lastIndexOf(".") + 1); // 확장자명

				filename_ext = filename_ext.toLowerCase();
				String[] allow_file = { "jpg", "jpeg", "png", "bmp", "gif" }; // 업로드 허용 가능 확장자 명
				int cnt = 0;
				for (int i = 0; i < allow_file.length; i++) {
					if (filename_ext.equals(allow_file[i])) cnt++;
				}
				if (cnt == 0)
					return3 = "&errstr=" + orgFileNm;
				else {
					String realFileNm = "";
					SimpleDateFormat formatter = new SimpleDateFormat( "yyyyMMddHHmmss");
					String today = formatter.format(new java.util.Date());
					realFileNm = today + "_" + Math.abs(new Random().nextLong());

					// 월별로 폴더를 새로 생성한다.
//					String month_directory = new SimpleDateFormat("yyyyMM") .format(new java.util.Date()) + "/";
					String rootPath = request.getSession().getServletContext() .getRealPath("/");
//					String fileUrl = targetDirectory + month_directory + realFileNm + "." + filename_ext;
					String fileUrl = targetDirectory +  realFileNm + "." + filename_ext;
					String rlFileNm = rootPath + fileUrl;
//					CommonUtils.attachSaveFile(filedata, rlFileNm, targetDirectory + month_directory, true);
					this.attachSaveFile(filedata, rlFileNm, targetDirectory);
					return3 += "&bNewLine=true";
					return3 += "&sFileName=" + orgFileNm;
					return3 += "&sFileURL=" +  fileUrl;
				}
			} else {
				return3 += "&errstr=error";
			}
		} catch (Exception e) {
			return3 += "&errstr=error";
		}
		return "redirect:" + return1 + return2 + return3;
	}
	
	public File attachSaveFile(MultipartFile file, String targetPathNm, String imgPath) throws IllegalStateException, IOException, Exception {
        String targetPath = targetPathNm.substring(0,targetPathNm.lastIndexOf("/")+1);
        File folder = new File(targetPath);
        if(!folder.exists()) folder.mkdirs();
        File saveFile = new File(targetPathNm);
        file.transferTo(saveFile);
        return saveFile;
	}
	
	
	/** 네이버 스마트 에디터 이미지 업로드 후 콜백 url 호출 */
	@RequestMapping("imgUploadCallback.sys")
	public ModelAndView imgUploadCallback( 
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("/common/imgUploadCallback");
		return modelAndView;
	}
	
	
	/**
	 * 공급사에서 역주문 전용 고객사검색 DIV
	 * @param page
	 * @param rows
	 * @param srcBorgNm
	 */
	@RequestMapping("borgDivListVenOrdReq.sys")
	public ModelAndView borgDivListVenOrdReq(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "10") int rows,
			@RequestParam(value = "srcBorgNm", defaultValue = "") String srcBorgNm,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBorgNm", srcBorgNm);
		
		/*----------------페이징 세팅------------*/
		int records = commonSvc.borgDivListVenOrdReqCnt(params);
		int total = (int)Math.ceil((float)records / (float)rows);
        
        /*----------------조회------------*/
        List<Map<String, Object>> list = null;
        if(records>0) {
        	list = commonSvc.borgDivListVenOrdReq(params, page, rows);
        }
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공인 인증서 처리를 위한 사용자 정보를 조회하는 메소드
	 * 
	 * @param borgId
	 * @param loginId
	 * @param request
	 * @param modelAndView
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("authUserInfo.sys")
	public ModelAndView authUserInfo(
			@RequestParam(value = "borgId",  defaultValue = "") String borgId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, String> svcResult      = null;
		String              clientId       = null;
		String              svcTypeCd      = null;
		String              businessNum    = null;
		CustomResponse      customResponse = new CustomResponse(true);
		
		try{
			svcResult   = this.commonSvc.authUserInfo(borgId); // 공인인증 관련 정보 조회    
			clientId    = svcResult.get("clientId");                               
			svcTypeCd   = svcResult.get("svcTypeCd");                              
			businessNum = svcResult.get("businessNum");                            
		}
		catch(Exception e){
			this.logger.error(CommonUtils.getExceptionStackTrace(e));
			
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error...");
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("borgId",         borgId);
		modelAndView.addObject("clientId",       clientId);
		modelAndView.addObject("svcTypeCd",      svcTypeCd);
		modelAndView.addObject("businessNum",    businessNum);
		modelAndView.addObject("customResponse", customResponse);
		
		return modelAndView;
	}
	
	
	
	
	
}