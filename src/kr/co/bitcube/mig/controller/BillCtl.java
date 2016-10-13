package kr.co.bitcube.mig.controller;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.common.utils.ExcelReader;
import kr.co.bitcube.common.utils.MultipartFileUpload;
import kr.co.bitcube.mig.service.BillSvc;

@Controller
@RequestMapping("electronic")
public class BillCtl {

	private Logger logger = Logger.getLogger(getClass());
	@Autowired private BillSvc billSvc;
	
	@RequestMapping("saveBill.sys")
	public ModelAndView saveBill(
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		try{
			billSvc.saveBill(paramMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("custResponse",custResponse);
		return modelAndView;
	}

	@RequestMapping("deleteBill.sys")
	public ModelAndView deleteBill(
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		try{
			billSvc.deleteBill(paramMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("custResponse",custResponse);
		return modelAndView;
	}
	
	@RequestMapping("billExcelUpload.sys")
	public ModelAndView billExcelUpload(
			@RequestParam(value = "excelFile", required=true) MultipartFile excelFile,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------처리수행 및 성공여부 세팅------------*/
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
		String[] colNames = { "bill_id","bill_flag","bankcd","business_nm","business_num","sale_num","public_date","evidence_date","expire_date","public_amount","over_period","interest_rate","interest_amount","return_date","reference"};	//엑셀의 Data Fild 와 같아야 함 (DB저장시 mapKey로 쓰임)
		
		ExcelReader excelReader = new ExcelReader(multipartFileUpload.getUploadedFile());
		List<Map<String, Object>> saveList = excelReader.getExcelReadList(0, colNames);
		logger.debug("saveList.size() : "+saveList.size());
		for(Map<String, Object> map : saveList) {
			logger.debug("-------------------------------------------------");
			for(String mapKey : colNames) {
				logger.debug(mapKey + " : " + map.get(mapKey));
			}
		}
		billSvc.saveBillBatch(saveList);
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
}
