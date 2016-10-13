package kr.co.bitcube.adjust.controller;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.adjust.dao.AdjustDao;
import kr.co.bitcube.adjust.dto.AdjustDto;
import kr.co.bitcube.adjust.service.AdjustSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.BorgDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dto.OrderDeliDto;
import kr.co.bitcube.order.service.DeliverySvc;
import kr.co.bitcube.order.service.OrderCommonSvc;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("adjust")
public class AdjustCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private AdjustSvc adjustSvc;
	
	@Autowired
	private AdjustDao adjustDao;

	@Autowired
	private DeliverySvc deliverySvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;	
	
	@Autowired
	private GeneralDao generalDao;
	
	@RequestMapping("adjustGenerationList.sys")
	public ModelAndView adjustGenerationList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orderString", " workNm asc");
		modelAndView.addObject("workInfoList", commonSvc.selectWorkInfo(params));
		modelAndView.addObject("admUserList", orderCommonSvc.getWorkUserInfo());
		modelAndView.setViewName("adjust/adjustGenerationList");
		return modelAndView;
	}

	@RequestMapping("adjustGenerationPop.sys")
	public ModelAndView adjustGenerationPop(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustGenerationPop");
	}

	@RequestMapping("adjustGenerationMultiPop.sys")
	public ModelAndView adjustGenerationMultiPop(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustGenerationMultiPop");
	}
	
	/**
	 * 정산대상목록 
	 */
	@RequestMapping("adjustGenerationListJQGrid.sys")
	public ModelAndView productListJQGrid(
			@RequestParam(value = "srcDate"			, defaultValue = "") String srcDate,
			@RequestParam(value = "srcStatDate"		, defaultValue = "") String srcStatDate,
			@RequestParam(value = "srcEndDate"		, defaultValue = "") String srcEndDate,
			@RequestParam(value = "srcConsIdenName"	, defaultValue = "") String srcConsIdenName,
			@RequestParam(value = "srcClientId"		, defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchId"		, defaultValue = "") String srcBranchId,
			@RequestParam(value = "srcOrderTypeCd"	, defaultValue = "") String srcOrderTypeCd,
			@RequestParam(value = "srcTaxClasCd"	, defaultValue = "") String srcTaxClasCd,
			@RequestParam(value = "srcOrdeNumb"		, defaultValue = "") String srcOrdeNumb,
			@RequestParam(value = "srcGoodNm"		, defaultValue = "") String srcGoodNm,
			@RequestParam(value = "srcVendorId"		, defaultValue = "") String srcVendorId,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {

		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcDate"		, srcDate);
		params.put("srcStatDate"	, srcStatDate);
		params.put("srcEndDate"		, srcEndDate);
		params.put("srcConsIdenName", srcConsIdenName);
		params.put("srcClientId"	, srcClientId);
		params.put("srcBranchId"	, srcBranchId);
		params.put("srcOrderTypeCd"	, srcOrderTypeCd);
		params.put("srcTaxClasCd"	, srcTaxClasCd);
		params.put("srcOrdeNumb"	, srcOrdeNumb);
		params.put("srcGoodNm"		, srcGoodNm);
		params.put("srcVendorId"	, srcVendorId);
		
        //----------------조회------------/
        List<AdjustDto> list = adjustSvc.adjustGenerationList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 선발주품목 목록 
	 */
	@RequestMapping("adjustFirstPurchaseHandleListJQGrid.sys")
	public ModelAndView adjustFirstPurchaseHandleListJQGrid(
			@RequestParam(value = "srcOrderStartDate"	, defaultValue = "") String srcOrderStartDate,
			@RequestParam(value = "srcOrderEndDate"		, defaultValue = "") String srcOrderEndDate,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcOrderStartDate"	, srcOrderStartDate);
		params.put("srcOrderEndDate"	, srcOrderEndDate);
		
		//----------------조회------------/
		List<OrderDeliDto> list = deliverySvc.getFirstPurchaseHandleList(params, -1, -1);
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}

	/**
	 * 정산대상선정 목록
	 */
	@RequestMapping("adjustGenerationMasterListJQGrid.sys")
	public ModelAndView adjustGenerationMasterListJQGrid(
			@RequestParam(value = "srcDate"			, defaultValue = "") String srcDate,
			@RequestParam(value = "srcStatDate"		, defaultValue = "") String srcStatDate,
			@RequestParam(value = "srcEndDate"		, defaultValue = "") String srcEndDate,
			@RequestParam(value = "srcOrderTypeCd"	, defaultValue = "") String srcOrderTypeCd,
			@RequestParam(value = "create_borgid"	, defaultValue = "") String create_borgid,
			@RequestParam(value = "create_userid"	, defaultValue = "") String create_userid,
			@RequestParam(value = "sidx", defaultValue = "workNm") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString"	, orderString);
		params.put("create_userid"	, create_userid);
		params.put("create_borgid"	, create_borgid);
		params.put("srcOrderTypeCd"	, srcOrderTypeCd);
		
		//----------------조회------------/
		List<AdjustDto> list = adjustSvc.adjustGenerationMasterList(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 정산생성 목록
	 */
	@RequestMapping("adjustCreatListJQGrid.sys")
	public ModelAndView adjustCreatListJQGrid(
			@RequestParam(value = "sale_sequ_numb"	, defaultValue = "") String sale_sequ_numb,
			@RequestParam(value = "buyi_sequ_numb"	, defaultValue = "") String buyi_sequ_numb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("sale_sequ_numb"	, sale_sequ_numb);
		params.put("buyi_sequ_numb"	, buyi_sequ_numb);
		
		//----------------조회------------/
		List<AdjustDto> list = adjustSvc.adjustCreatList(params);
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 정산대상 선정 일괄생성 
	 */
	@RequestMapping("saveAdjustMasterAll.sys")
	public ModelAndView saveAdjustMasterAll(
			@RequestParam(value = "userId"			, required = true) 	String userId,
			@RequestParam(value = "create_borgid"	, required = true) 	String create_borgid,
			@RequestParam(value = "create_userid"	, defaultValue = "") String create_userid,
			@RequestParam(value = "srcDate"			, defaultValue = "") String srcDate,
			@RequestParam(value = "srcStatDate"		, defaultValue = "") String srcStatDate,
			@RequestParam(value = "srcEndDate"		, defaultValue = "") String srcEndDate,			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("userId"		, userId);
		saveMap.put("create_borgid"	, create_borgid);
		saveMap.put("create_userid"	, create_userid);
		saveMap.put("srcDate"		, srcDate);
		saveMap.put("srcStatDate"	, srcStatDate);
		saveMap.put("srcEndDate"	, srcEndDate);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			adjustSvc.saveAdjustMasterAll(saveMap);
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
	 * 정산대상 선정 저장/삭제 
	 */
	@RequestMapping("saveAdjustMaster.sys")
	public ModelAndView saveAdjustMaster(
			@RequestParam(value = "oper"			, required = true) 	String oper,
			@RequestParam(value = "clientId"		, defaultValue = "")String clientId,
			@RequestParam(value = "branchId"		, defaultValue = "0")String branchId,
			@RequestParam(value = "sale_sequ_name"	, defaultValue = "")String sale_sequ_name,
			@RequestParam(value = "crea_sale_date"	, defaultValue = "")String crea_sale_date,
			@RequestParam(value = "paym_cond_code"	, defaultValue = "")String paym_cond_code,
			@RequestParam(value = "sale_sequ_numb"	, defaultValue = "")String sale_sequ_numb,
			@RequestParam(value = "sale_sequ_numb_array[]", required = false) String[] sale_sequ_numb_array,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		saveMap.put("clientId"			, clientId);
		saveMap.put("branchId"			, branchId);
		saveMap.put("sale_sequ_name"	, sale_sequ_name);
		saveMap.put("crea_sale_date"	, crea_sale_date);
		saveMap.put("paym_cond_code"	, paym_cond_code);
		saveMap.put("crea_sale_userid"	, userInfoDto.getUserId());
		saveMap.put("create_borgid"		, userInfoDto.getBorgId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			
			if("add".equals(oper)){
				adjustSvc.saveAdjustMaster(saveMap);
			} else if("del".equals(oper)){
				saveMap.put("sale_sequ_numb"	, sale_sequ_numb);
				adjustSvc.delAdjustMaster(saveMap);
			} else if("multiDel".equals(oper)){
				saveMap.put("sale_sequ_numb_array", sale_sequ_numb_array);
				adjustSvc.multiDelAdjustMaster(saveMap);
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
	 * 정산생성 목록 저장/삭제 
	 */
	@RequestMapping("saveAdjustCreatList.sys")
	public ModelAndView saveAdjustCreatList(
			@RequestParam(value = "oper"					, required = true) String oper,
			@RequestParam(value = "sale_sequ_numb"			, required = true) String sale_sequ_numb,
			@RequestParam(value = "orde_iden_numb_arr[]"	, required = true) String[] orde_iden_numb_arr,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		
		saveMap.put("oper"					, oper);
		saveMap.put("sale_sequ_numb"		, sale_sequ_numb);
		saveMap.put("orde_iden_numb_arr"	, orde_iden_numb_arr);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		boolean isUseStatus = adjustDao.getIsAdjustCreateStatus(sale_sequ_numb);	//정산확정상태인지 체크
		if(isUseStatus) {
			try {
				adjustSvc.addAdjustCreatList(saveMap);
			} catch(Exception e) {
				logger.error("Exception : "+e);
				custResponse.setSuccess(false);
				custResponse.setMessage("System Excute Error!....");
				custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			}
		} else {
			logger.info("선택하신 정산대상은 이미 정상확정상태 입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다");
			custResponse.setSuccess(false);
			custResponse.setMessage("선택하신 정산대상은 삭제되었거나 정상확정상태 입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다");
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}
	
	/**
	 * 매출확정
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("adjustSalesConfirmation.sys")
	public ModelAndView adjustSalesConfirmation(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("admUserList", orderCommonSvc.getWorkUserInfo());
		modelAndView.setViewName("adjust/adjustSalesConfirmation");
		return modelAndView ;
	}
	
	/**
	 * 매출확정목록
	 */
	@RequestMapping("adjustSalesConfirmListJQGrid.sys")
	public ModelAndView adjustSalesConfirmListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "SALE_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcCreatStartDate", defaultValue = "") String srcCreatStartDate,
			@RequestParam(value = "srcCreatEndDate", defaultValue = "") String srcCreatEndDate,
			@RequestParam(value = "srcSaleStatus", defaultValue = "") String srcSaleStatus,
			@RequestParam(value = "srcSaleNm", defaultValue = "") String srcSaleNm,
			@RequestParam(value = "srcBranchNm", defaultValue = "") String srcBranchNm,
			@RequestParam(value = "srcAccUser", defaultValue = "") String srcAccUser,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCreatStartDate"	, srcCreatStartDate);
		params.put("srcCreatEndDate"	, srcCreatEndDate);
		params.put("srcSaleStatus"		, srcSaleStatus);
		params.put("srcSaleNm"			, srcSaleNm);
		params.put("srcBranchNm"		, srcBranchNm);
		params.put("create_borgid"		, userInfoDto.getBorgId());
		params.put("srcAccUser"			, srcAccUser);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = adjustSvc.adjustSalesConfirmListCnt(params);
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<AdjustDto> list = null;
        if(records>0) list = adjustSvc.adjustSalesConfirmList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 매출확정목록 엑셀다운로드
	 */
	@RequestMapping("adjustSalesConfirmListExcel.sys")
	public ModelAndView adjustSalesConfirmListExcel(
			@RequestParam(value = "sidx", defaultValue = "SALE_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcCreatStartDate", defaultValue = "") String srcCreatStartDate,
			@RequestParam(value = "srcCreatEndDate", defaultValue = "") String srcCreatEndDate,
			@RequestParam(value = "srcSaleStatus", defaultValue = "") String srcSaleStatus,
			@RequestParam(value = "srcSaleNm", defaultValue = "") String srcSaleNm,
			@RequestParam(value = "srcBranchNm", defaultValue = "") String srcBranchNm,
			@RequestParam(value = "srcAccUser", defaultValue = "") String srcAccUser,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcCreatStartDate"	, srcCreatStartDate);
		params.put("srcCreatEndDate"	, srcCreatEndDate);
		params.put("srcSaleStatus"		, srcSaleStatus);
		params.put("srcSaleNm"			, srcSaleNm);
		params.put("srcBranchNm"		, srcBranchNm);
		params.put("create_borgid"		, userInfoDto.getBorgId());
		params.put("srcAccUser"			, srcAccUser);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<AdjustDto> list = adjustSvc.adjustSalesConfirmList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("sale_sequ_numb", list.get(i).getSale_sequ_numb());
				rtnData.put("crea_sale_date", list.get(i).getCrea_sale_date());
				rtnData.put("sale_sequ_name", list.get(i).getSale_sequ_name());
				rtnData.put("clientNm", list.get(i).getClientNm());
				rtnData.put("sale_requ_amou", list.get(i).getSale_requ_amou());
				rtnData.put("sale_requ_vtax", list.get(i).getSale_requ_vtax());
				rtnData.put("sale_tota_amou", list.get(i).getSale_tota_amou());
				rtnData.put("sale_status_name", list.get(i).getSale_status_name());
				rtnData.put("sale_conf_date", list.get(i).getSale_conf_date());
				rtnData.put("sap_jour_numb", list.get(i).getSap_jour_numb());
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
	 * 매출확정상세목록
	 */
	@RequestMapping("adjustSalesConfirmDetailListJQGrid.sys")
	public ModelAndView adjustSalesConfirmDetailListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "SALE_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,						
			@RequestParam(value = "sale_sequ_numb"	, defaultValue = "") String sale_sequ_numb,
			@RequestParam(value = "srcOrdeNumb"	, defaultValue = "") String srcOrdeNumb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sale_sequ_numb"	, sale_sequ_numb);
		params.put("srcOrdeNumb"	, srcOrdeNumb);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
//        int records = adjustSvc.adjustSalesConfirmDetailListCnt(params); //조회조건에 따른 카운트
//        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
//        List<AdjustDto> list = null;
//        if(records>0) list = adjustSvc.adjustSalesConfirmDetailList(params, page, rows); //조회조건에 따른 카운트
		
        List<AdjustDto> list = adjustSvc.adjustSalesConfirmDetailList(params);

		modelAndView = new ModelAndView("jsonView");
//		modelAndView.addObject("page", page);
//		modelAndView.addObject("total", total);
//		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 매출확정상세목록 엑셀다운로드
	 */
	@RequestMapping("adjustSalesConfirmDetailListExcel.sys")
	public ModelAndView adjustSalesConfirmDetailListExcel(
			@RequestParam(value = "sidx", defaultValue = "SALE_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,						
			@RequestParam(value = "srcSaleSequNumb"	, defaultValue = "") String sale_sequ_numb,
			@RequestParam(value = "srcOrdeNumb"	, defaultValue = "") String srcOrdeNumb,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sale_sequ_numb"	, sale_sequ_numb);
		params.put("srcOrdeNumb"	, srcOrdeNumb);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
//		List<AdjustDto> list = adjustSvc.adjustSalesConfirmDetailList(params, 1, RowBounds.NO_ROW_LIMIT); //조회조건에 따른 카운트
		List<AdjustDto> list = adjustSvc.adjustSalesConfirmDetailList(params, -1, -1); //조회조건에 따른 카운트
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("vendorNm", list.get(i).getVendorNm());
				rtnData.put("branchNm", list.get(i).getBranchNm());
				rtnData.put("orde_type_clas_nm", list.get(i).getOrde_type_clas_nm());
				rtnData.put("order_num", list.get(i).getOrder_num());
				rtnData.put("purc_iden_numb", list.get(i).getPurc_iden_numb());
				rtnData.put("deli_iden_numb", list.get(i).getDeli_iden_numb());
				rtnData.put("good_name", list.get(i).getGood_name());
				rtnData.put("orde_requ_quan", list.get(i).getOrde_requ_quan());
				rtnData.put("sale_prod_quan", list.get(i).getSale_prod_quan());
				rtnData.put("sale_prod_pris", list.get(i).getSale_prod_pris());
				rtnData.put("sale_prod_amou", list.get(i).getSale_prod_amou());
				rtnData.put("buyi_stat_yn", !"".equals(list.get(i).getBuyi_sequ_numb())?"Y":"N" );
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
	 * 매출확정 취소 
	 */
	@RequestMapping("saveAdjustConfirm.sys")
	public ModelAndView saveAdjustConfirm(
			@RequestParam(value = "oper"					, required = true) String oper,
			@RequestParam(value = "sale_sequ_numb_Arr[]"	, required = true) String[] sale_sequ_numb_Arr,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("oper"				, oper);
		saveMap.put("sale_sequ_numb_Arr", sale_sequ_numb_Arr);
		saveMap.put("userId"			, userInfoDto.getUserId());

		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
//			if("mod".equals(oper)){
//				saveMap.put("isChecked", "Y");
//				List<AdjustDto> chkList = adjustSvc.adjustSalesConfirmDetailList(saveMap, -1, -1); //조회조건에 따른 카운트
//				
//				if(chkList != null && chkList.size() >0){
//					for(int i = 0 ; i < chkList.size() ; i++){
//						if(chkList.get(i).getBuyi_sequ_numb() != null){
//							logger.error("Exception : [정산번호:"+ chkList.get(i).getSale_sequ_numb() + "] 매입확정이 진행된 데이터는 취소하실수 없습니다.");
//							custResponse.setSuccess(false);
//							custResponse.setMessage("[정산번호:"+ chkList.get(i).getSale_sequ_numb() + "]매입확정이 진행된 데이터는 취소하실수 없습니다.");
//							modelAndView = new ModelAndView("jsonView");
//							modelAndView.addObject(custResponse);
//							return modelAndView;	
//						}
//					}
//				}
//			}
			int adjustCnt = adjustDao.selectAdjustConfirmCnt(saveMap);	//매출확정/매출확정취소 개수 가져오기
			if(adjustCnt > 0) {
				if("add".equals(oper)) {
					logger.info("이미 매출확정 처리하신 매출정보가 존재하거나 세금계산서가 발송된 매출입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
					custResponse.setSuccess(false);
					custResponse.setMessage("이미 매출확정 처리하신 매출정보가 존재하거나 세금계산서가 발송된 매출입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
				} else if("mod".equals(oper)) {
					logger.info("이미 매출확정취소 처리하신 매출정보가 존재하거나 세금계산서가 발송된 매출입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
					custResponse.setSuccess(false);
					custResponse.setMessage("이미 매출확정취소 처리하신 매출정보가 존재하거나 세금계산서가 발송된 매출입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
				}
			} else {
				if("mod".equals(oper)) {
					int adjustBuyConfirmCnt = adjustDao.selectAdjustBuyConfirmCnt(saveMap);	//매입확정된 매출정보 개수 가져오기
					if(adjustBuyConfirmCnt > 0) {
						logger.info("매입확정된 매출정보가 있거나 세금계산서가 발송된 매출입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
						custResponse.setSuccess(false);
						custResponse.setMessage("매입확정된 매출정보가 있거나 세금계산서가 발송된 매출입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
					} else {
						adjustSvc.modAdjustConfirm(saveMap);		//매출확정취소
					}
				} else {
					adjustSvc.modAdjustConfirm(saveMap);		//매출확정
				}
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
	
	@RequestMapping("adjustPurchaseConfirmation.sys")
	public ModelAndView adjustPurchaseConfirmation(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustPurchaseConfirmation");
	}	
	
	/**
	 * 매입확정 목록
	 */
	@RequestMapping("adjustPurcConfirmListJQGrid.sys")
	public ModelAndView adjustPurcConfirmListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "SALE_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,						
			@RequestParam(value = "srcCreatStartDate"	, defaultValue = "") String srcCreatStartDate,
			@RequestParam(value = "srcCreatEndDate"	, defaultValue = "") String srcCreatEndDate,
			@RequestParam(value = "srcPurcStatus"	, defaultValue = "") String srcPurcStatus,
			@RequestParam(value = "srcVendorNm"	, defaultValue = "") String srcVendorNm,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcPurcStatus"		, srcPurcStatus);
		params.put("srcVendorNm"		, srcVendorNm);
		params.put("create_borgid"		, userInfoDto.getBorgId());

//		String orderString = " " + sidx + " " + sord + " ";
//		params.put("orderString", orderString);
		
		int records = 0;
		int total = 0;
		List<AdjustDto> list = null;

		String orderString = "";
		if("SALE_SEQU_NUMB".equals(sidx)) sidx = "BUYI_SEQU_NUMB";
		orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);

//		records = adjustSvc.adjustPurcConfirmListCnt(params);
//		total = (int)Math.ceil((float)records / (float)rows);
//		if(records>0) list = adjustSvc.adjustPurcConfirmList(params, page, rows);
		
		if("10".equals(srcPurcStatus)){
			records = adjustSvc.adjustPurcConfirmListCnt(params);
			total = (int)Math.ceil((float)records / (float)rows);
			if(records>0) list = adjustSvc.adjustPurcConfirmList(params, page, rows);

		}else if("20".equals(srcPurcStatus)){
//			params.put("srcCreatStartDate"	, srcCreatStartDate);
//			params.put("srcCreatEndDate"	, srcCreatEndDate);
			
			records = adjustSvc.adjustPurcCancelListCnt(params);
			total = (int)Math.ceil((float)records / (float)rows);
			if(records>0) list = adjustSvc.adjustPurcCancelList(params, page, rows);
		}

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 매입확정 목록 엑셀다운로드
	 */
	@RequestMapping("adjustPurcConfirmListExcel.sys")
	public ModelAndView adjustPurcConfirmListExcel(
			@RequestParam(value = "sidx", defaultValue = "SALE_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,						
			@RequestParam(value = "srcCreatStartDate"	, defaultValue = "") String srcCreatStartDate,
			@RequestParam(value = "srcCreatEndDate"	, defaultValue = "") String srcCreatEndDate,
			@RequestParam(value = "srcPurcStatus"	, defaultValue = "") String srcPurcStatus,
			@RequestParam(value = "srcVendorNm"	, defaultValue = "") String srcVendorNm,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcPurcStatus"		, srcPurcStatus);
		params.put("srcVendorNm"		, srcVendorNm);
		params.put("create_borgid"		, userInfoDto.getBorgId());
		
		List<AdjustDto> list = null;
		
		String orderString = "";
		if("SALE_SEQU_NUMB".equals(sidx)) sidx = "BUYI_SEQU_NUMB";
		orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		if("10".equals(srcPurcStatus)){
			list = adjustSvc.adjustPurcConfirmList(params, 1, RowBounds.NO_ROW_LIMIT);
		}else if("20".equals(srcPurcStatus)){
//			params.put("srcCreatStartDate"	, srcCreatStartDate);
//			params.put("srcCreatEndDate"	, srcCreatEndDate);
			list = adjustSvc.adjustPurcCancelList(params, 1, RowBounds.NO_ROW_LIMIT);
		}
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("payBillTypeNm", list.get(i).getPayBillTypeNm());
				rtnData.put("vendorNm", list.get(i).getVendorNm());
				rtnData.put("purc_prod_amou", list.get(i).getPurc_prod_amou());
				rtnData.put("purc_prod_tax", list.get(i).getPurc_prod_tax());
				rtnData.put("crea_sale_date", list.get(i).getCrea_sale_date());
				rtnData.put("sap_jour_numb", list.get(i).getSap_jour_numb());
				rtnData.put("buyi_tota_amou", list.get(i).getBuyi_tota_amou());
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
	 * 매입확정상세 목록
	 */
	@RequestMapping("adjustPurcConfirmDetailListJQGrid.sys")
	public ModelAndView adjustPurcConfirmDetailListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "A.BUYI_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,						
			@RequestParam(value = "sale_sequ_numb"	, defaultValue = "") String sale_sequ_numb,
			@RequestParam(value = "buyi_sequ_numb"	, defaultValue = "") String buyi_sequ_numb,
			@RequestParam(value = "vendorId"	, defaultValue = "") String vendorId,
			@RequestParam(value = "srcPurcStatus"	, defaultValue = "") String srcPurcStatus,
			@RequestParam(value = "srcOrdeNumb"	, defaultValue = "") String srcOrdeNumb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sale_sequ_numb"	, sale_sequ_numb);
		params.put("buyi_sequ_numb"	, buyi_sequ_numb);
		params.put("vendorId"		, vendorId);
		params.put("srcPurcStatus"	, srcPurcStatus);
		params.put("create_borgid"	, userInfoDto.getBorgId());
		params.put("srcOrdeNumb"	, srcOrdeNumb);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
		List<AdjustDto> list = adjustSvc.adjustPurcConfirmDetailList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 매입확정/취소 
	 */
	@RequestMapping("savePurcConfirm.sys")
	public ModelAndView savePurcConfirm(
			@RequestParam(value = "oper"					, required = true) String oper,
			@RequestParam(value = "vendorIdArr[]"			, required = true) String[] vendorIdArr,
			@RequestParam(value = "buyi_requ_amou_Arr[]"	, required = true) String[] buyi_requ_amou_Arr,
			@RequestParam(value = "buyi_requ_vtax_Arr[]"	, required = true) String[] buyi_requ_vtax_Arr,
			@RequestParam(value = "paym_cond_code_Arr[]"	, required = true) String[] paym_cond_code_Arr,
			@RequestParam(value = "buyi_sequ_numb_Arr[]"	, required = false) String[] buyi_sequ_numb_Arr,
			
			
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("oper"				, oper);
		saveMap.put("vendorIdArr"		, vendorIdArr);
		saveMap.put("buyi_requ_amou_Arr", buyi_requ_amou_Arr);
		saveMap.put("buyi_requ_vtax_Arr", buyi_requ_vtax_Arr);
		saveMap.put("paym_cond_code_Arr", paym_cond_code_Arr);
		saveMap.put("buyi_sequ_numb_Arr", buyi_sequ_numb_Arr);
		saveMap.put("userId"			, userInfoDto.getUserId());
		saveMap.put("create_borgid"		, userInfoDto.getBorgId());

		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		
		/*------------------------------------매입확정 할 금액 비교처리----------------------------------*/
		if("add".equals(oper.trim())) {
			int chkNum = 0;
			for(String vendorId : vendorIdArr) {
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("vendorId", vendorId);
				paramMap.put("create_borgid", userInfoDto.getBorgId());
				double purcConfirmSum =  adjustDao.selectPurcConfirmSum(paramMap);
				double requAmou = Double.parseDouble(buyi_requ_amou_Arr[chkNum]);
				if(purcConfirmSum != requAmou) {
					logger.info("이미 매입확정한 정보가 존재하거나 매입액이 정확하지 않습니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
					custResponse.setSuccess(false);
					custResponse.setMessage("이미 매입확정한 정보가 존재하거나 매입액이 정확하지 않습니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
					break;
				}
				chkNum++;
			}
		} else if("mod".equals(oper.trim())) {
			for(String buyi_sequ_numb : buyi_sequ_numb_Arr) {
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("create_borgid", userInfoDto.getBorgId());
				paramMap.put("buyi_sequ_numb", buyi_sequ_numb);
				if(!adjustSvc.getPurcIsCancel(paramMap)) {
					logger.info("이미 매입확정을 취소하였거나 세금계산서를 발송한 상태입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
					custResponse.setSuccess(false);
					custResponse.setMessage("이미 매입확정을 취소하였거나 세금계산서를 발송한 상태입니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
					break;
				}
			}
		}
		
		if(custResponse.getSuccess()) {
			try {
				adjustSvc.modPurcConfirm(saveMap);
			} catch(Exception e) {
				logger.error("Exception : "+e);
				custResponse.setSuccess(false);
				custResponse.setMessage("System Excute Error!....");
				custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
			}
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}	
	
	@RequestMapping("adjustBalance.sys")
	public ModelAndView adjustBalance(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustBalance");
	}

	/**
	 * 정산수불부 목록
	 */
	@RequestMapping("adjustBalanceListJQGrid.sys")
	public ModelAndView adjustBalanceListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "CONF_DATE") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,						
			@RequestParam(value = "srcConfStartYear"	, defaultValue = "") String srcConfStartYear,
			@RequestParam(value = "srcConfStartMonth"	, defaultValue = "") String srcConfStartMonth,
			@RequestParam(value = "srcConfEndYear"	, defaultValue = "") String srcConfEndYear,
			@RequestParam(value = "srcConfEndMonth"	, defaultValue = "") String srcConfEndMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String preZero = "";
		if(srcConfStartMonth.length() == 1)	preZero = "0";
		params.put("srcConfStartDate"	, srcConfStartYear + preZero + srcConfStartMonth);
		preZero = "";
		if(srcConfEndMonth.length() == 1)	preZero = "0";
		params.put("srcConfEndDate"		, srcConfEndYear + preZero + srcConfEndMonth);
		params.put("create_borgid"		, userInfoDto.getBorgId());

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		
		/*----------------페이징 세팅------------*/
		int records = adjustSvc.adjustBalanceListCnt(params); //조회조건에 따른 카운트
//		int records = adjustSvc.adjustBalanceListCnt2(params); //조회조건에 따른 카운트(매출매입 각각 계산)
		int total = (int)Math.ceil((float)records / (float)rows);

		
		/*----------------조회------------*/
		List<AdjustDto> list = null;
//		if(records>0) list = adjustSvc.adjustBalanceList(params, page, rows); 
//		if(records>0) list = adjustSvc.adjustBalanceList2(params, page, rows); //계산서일자로 정산수불부(매출매입 각각 계산)
		if(records>0) list = adjustSvc.adjustBalanceList3(params, page, rows); //정산수불부 (매출세금계산서 일자로 변경)

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);		
		return modelAndView;
	}
	
	
	/**
	 * 정산수불부 엑셀 다운
	 */
	@RequestMapping("adjustBalanceExcel.sys")
	public ModelAndView adjustBalanceExcel(
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "sidx", defaultValue = "CONF_DATE") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,						
			@RequestParam(value = "srcConfStartYear"	, defaultValue = "") String srcConfStartYear,
			@RequestParam(value = "srcConfStartMonth"	, defaultValue = "") String srcConfStartMonth,
			@RequestParam(value = "srcConfEndYear"	, defaultValue = "") String srcConfEndYear,
			@RequestParam(value = "srcConfEndMonth"	, defaultValue = "") String srcConfEndMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		String preZero = "";
		if(srcConfStartMonth.length() == 1)	preZero = "0";
		params.put("srcConfStartDate"	, srcConfStartYear + preZero + srcConfStartMonth);
		preZero = "";
		if(srcConfEndMonth.length() == 1)	preZero = "0";
		params.put("srcConfEndDate"		, srcConfEndYear + preZero + srcConfEndMonth);
		params.put("create_borgid"		, userInfoDto.getBorgId());

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		params.put("isExcel", 1);	//Query에서 상태값을 Case처리하기 위함
		
		
		List<Object> list = generalDao.selectGernalList("adjust.adjustBalanceList3", params);
		
		
		List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("sheetTitle", sheetTitle);
		map1.put("colLabels", colLabels);
		map1.put("colIds", colIds);
		map1.put("numColIds", numColIds);
		map1.put("figureColIds", figureColIds);
		map1.put("colDataList", list);
		sheetList.add(map1);
		
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		
		return modelAndView;
	}
			
	
	@RequestMapping("adjustBalanceDetailPop.sys")
	public ModelAndView adjustBalanceDetailPop(
			@RequestParam (value="srcConfDate", required = true)String srcConfDate,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("srcConfDate", srcConfDate);
		modelAndView.setViewName("adjust/adjustBalanceDetailPop");
		return modelAndView;
	}	
	
	/**
	 * 정산수불부 상세목록
	 */
	@RequestMapping("adjustBalanceDetailJQGrid.sys")
	public ModelAndView adjustBalanceDetailJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "ORDER_NUM") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "srcConfDate"	, defaultValue = "") String srcConfDate,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcConfDate"	, srcConfDate);
		params.put("create_borgid"	, userInfoDto.getBorgId());
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
//		int records = adjustSvc.adjustBalanceDetailCnt(params); //조회조건에 따른 카운트
		int records = adjustSvc.adjustBalanceDetailCnt2(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		/*----------------조회------------*/
		List<AdjustDto> list = null;
//		if(records>0) list = adjustSvc.adjustBalanceDetail(params, page, rows); //조회조건에 따른 카운트
		if(records>0) list = adjustSvc.adjustBalanceDetail2(params, page, rows); //조회조건에 따른 카운트
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);				
		return modelAndView;
	}
	
	@RequestMapping("adjustSalesTransmission.sys")
	public ModelAndView adjustSalesTransmission(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustSalesTransmission");
	}
	
	@RequestMapping("adjustSalesTransmissionInfo.sys")
	public ModelAndView adjustSalesTransmissionInfo(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustSalesTransmissionInfo");
	}	

	/**
	 * 매출전송 목록
	 */
	@RequestMapping("adjustSalesTransmissionJQGrid.sys")
	public ModelAndView adjustSalesTransmissionJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "a.sale_sequ_numb") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "srcSalesName", defaultValue = "") String srcSalesName,
			@RequestParam(value = "srcTransStatus", defaultValue = "") String srcTransStatus,
			@RequestParam(value = "srcSalesConfStartDate", defaultValue = "") String srcSalesConfStartDate,
			@RequestParam(value = "srcSalesConfEndDate", defaultValue = "") String srcSalesConfEndDate,
			@RequestParam(value = "srcSalesTransStartDate", defaultValue = "") String srcSalesTransStartDate,
			@RequestParam(value = "srcSalesTransEndDate", defaultValue = "") String srcSalesTransEndDate,
			@RequestParam(value = "srcClientNm", defaultValue = "") String srcClientNm,
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,
			@RequestParam(value = "srcIsCollect", defaultValue = "") String srcIsCollect,
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,
//			@RequestParam(value = "srcPayStartDate", defaultValue = "") String srcPayStartDate,
//			@RequestParam(value = "srcPayEndDate", defaultValue = "") String srcPayEndDate,
//			@RequestParam(value = "srcDateCalc", defaultValue ="") String srcDateCalc,
			@RequestParam(value = "srcUserNm", defaultValue ="") String srcUserNm,
			@RequestParam(value = "receSaleStatus", defaultValue ="") String receSaleStatus,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSalesName"			, srcSalesName);
		params.put("srcTransStatus"			, srcTransStatus);
		params.put("srcSalesConfStartDate"	, srcSalesConfStartDate);
		params.put("srcSalesConfEndDate"	, srcSalesConfEndDate);
		params.put("srcSalesTransStartDate"	, srcSalesTransStartDate);
		params.put("srcSalesTransEndDate"	, srcSalesTransEndDate);
		params.put("srcClientNm"			, srcClientNm);
		params.put("srcBusinessNum"			, srcBusinessNum);
		params.put("srcIsCollect"			, srcIsCollect);
		params.put("create_borgid"			, userInfoDto.getBorgId());
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
//		params.put("srcDateCalc", srcDateCalc);
//		params.put("srcPayStartDate", srcPayStartDate);
//		params.put("srcPayEndDate", srcPayEndDate);
		params.put("srcUserNm", srcUserNm);
		params.put("receSaleStatus", receSaleStatus);
		
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = adjustSvc.adjustSalesTransmissionListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<AdjustDto> list = null;
        if(records>0) list = adjustSvc.adjustSalesTransmissionList(params, page, rows); //조회조건에 따른 카운트
        
        modelAndView = new ModelAndView("jsonView");

        if(list != null && list.size() > 0){
        	
        	double getSale_requ_amou = 0;
        	double getSale_requ_vtax = 0;
        	double getSale_tota_amou = 0;
        	double getPay_amou = 0;
        	double getNone_coll_amou = 0;

        	for(AdjustDto dto : list){
        		getSale_requ_amou += Double.parseDouble(dto.getSale_requ_amou());
        		getSale_requ_vtax += Double.parseDouble(dto.getSale_requ_vtax());
        		getSale_tota_amou += Double.parseDouble(dto.getSale_tota_amou());
        		getPay_amou += Double.parseDouble(dto.getPay_amou());
        		getNone_coll_amou += Double.parseDouble(dto.getNone_coll_amou());
        	}
        	list.get(0).setSum_sale_requ_amou(new BigDecimal(getSale_requ_amou));
        	list.get(0).setSum_sale_requ_vtax(new BigDecimal(getSale_requ_vtax));
        	list.get(0).setSum_sale_tota_amou(new BigDecimal(getSale_tota_amou));
        	list.get(0).setSum_pay_amou(new BigDecimal(getPay_amou));
        	list.get(0).setSum_none_coll_amou(new BigDecimal(getNone_coll_amou));
        }
		
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);				
		return modelAndView;
	}
	
	/**
	 * <pre>
	 * 매출입금처리 화면의 그리드 정보를 조회하는 메소드
	 * 
	 * ~. modelMap 구조
	 *   !. srcSalesName (String)
	 *   !. srcIsCollect  (String)
	 *   !. srcSalesTransStartDate (String)
	 *   !. srcSalesTransEndDate  (String)
	 *   !. srcClientNm (String)
	 *   !. srcBusinessNum (String)
	 *   !. receSaleStatus (String)
	 *   !. page (String, 그리드 조회페이지)
	 *   !. rows (String, 그리드 조회페이지 조회 row 수)
	 *   !. sidx (String, 그리드 정렬 컬럼)
	 *   !. sord (String, 칼럼 정렬 순서)
	 * 
	 * ~. return 구조
	 *   !. page (String, 그리드 조회페이지)
	 *   !. total (int, 페이지 카운트 수)
	 *   !. records (int, 총 카운트 수)
	 *   !. list (List, 페이지 데이터)
	 * </pre>
	 * 
	 * @param modelAndView
	 * @param request
	 * @param modelMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("adjustSalesTransmissionJQGrid20.sys")
	public ModelAndView adjustSalesTransmissionJQGrid20(ModelAndView modelAndView, HttpServletRequest request, ModelMap modelMap) throws Exception {
		LoginUserDto              userInfoDto = CommonUtils.getLoginUserDto(request); // 로그인 사용자 정보 반환
		String                    borgId      = userInfoDto.getBorgId();
		String                    page        = (String)modelMap.get("page");
		Map<String, Object>       result      = null;
		List<Map<String, String>> list        = null;
		Integer                   total       = null;
		Integer                   records     = null;
		
		modelMap.put("createBorgid",   borgId);
		modelMap.put("srcTransStatus", "20");
		
		result  = this.adjustSvc.adjustSalesTransmissionJQGrid20(modelMap); //조회조건에 따른 카운트
		list    = (List<Map<String, String>>)result.get("list");
		total   = (Integer)result.get("total");
		records = (Integer)result.get("records");
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("page",    page);
		modelAndView.addObject("total",   total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list",    list);				
		
		return modelAndView;
	}
	
	/**
	 * 매출전송 목록 엑셀
	 */
	@RequestMapping("adjustSalesTransmissionExcel.sys")
	public ModelAndView adjustSalesTransmissionExcel(
			@RequestParam(value = "sidx", defaultValue = "a.clos_sale_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "srcSalesName", defaultValue = "") String srcSalesName,
			@RequestParam(value = "srcTransStatus", defaultValue = "") String srcTransStatus,
			@RequestParam(value = "srcClientNm", defaultValue = "") String srcClientNm,
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,
			@RequestParam(value = "srcIsCollect", defaultValue = "") String srcIsCollect,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "dateCalc", defaultValue = "") String srcDateCalc,
			@RequestParam(value = "srcSalesTransStartDate", defaultValue = "") String srcSalesTransStartDate,
			@RequestParam(value = "srcSalesTransEndDate", defaultValue = "") String srcSalesTransEndDate,
			@RequestParam(value = "srcSalesConfStartDate", defaultValue = "") String srcSalesConfStartDate,
			@RequestParam(value = "srcSalesConfEndDate", defaultValue = "") String srcSalesConfEndDate,
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,			
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSalesName"			, srcSalesName);
		params.put("srcTransStatus"			, srcTransStatus);
		params.put("srcSalesTransStartDate"	, srcSalesTransStartDate);
		params.put("srcSalesTransEndDate"	, srcSalesTransEndDate);
		params.put("srcSalesConfStartDate"	, srcSalesConfStartDate);
		params.put("srcSalesConfEndDate"	, srcSalesConfEndDate);
		params.put("srcClientNm"			, srcClientNm);
		params.put("srcBusinessNum"			, srcBusinessNum);
		params.put("srcIsCollect"			, srcIsCollect);
		params.put("create_borgid"			, userInfoDto.getBorgId());
		params.put("srcUserNm"				, srcUserNm);
		params.put("srcDateCalc"			, srcDateCalc);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<AdjustDto> list = adjustSvc.adjustSalesTransmissionList(params, 1, RowBounds.NO_ROW_LIMIT); //조회조건에 따른 카운트
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			
			double getSale_requ_amou = 0;
			double getSale_requ_vtax = 0;
			double getSale_tota_amou = 0;
			
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			
			for(int i = 0; i < list.size() ; i++){
				
				AdjustDto dto = list.get(i);
				
				getSale_requ_amou += Double.parseDouble(dto.getSale_requ_amou());
				getSale_requ_vtax += Double.parseDouble(dto.getSale_requ_vtax());
				getSale_tota_amou += Double.parseDouble(dto.getSale_tota_amou());
				
				rtnData = new HashMap<String, Object>();
				rtnData.put("sap_jour_numb", list.get(i).getSap_jour_numb());
				rtnData.put("clos_sale_date", list.get(i).getClos_sale_date());
				rtnData.put("sale_sequ_name", list.get(i).getSale_sequ_name());
				rtnData.put("clientNm", list.get(i).getClientNm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("sale_conf_date", list.get(i).getSale_conf_date());
				rtnData.put("sale_requ_amou", list.get(i).getSale_requ_amou());
				rtnData.put("sale_requ_vtax", list.get(i).getSale_requ_vtax());
				rtnData.put("sale_tota_amou", list.get(i).getSale_tota_amou());
				rtnData.put("workInfoUserNm", list.get(i).getWorkInfoUserNm());
				colDataList.add(rtnData);
			}
			Map<String, Object> sumData = new HashMap<String, Object>();
			sumData.put("sale_conf_date", "합계");
			sumData.put("sale_requ_amou", new BigDecimal(getSale_requ_amou).toString());
			sumData.put("sale_requ_vtax", new BigDecimal(getSale_requ_vtax).toString());
			sumData.put("sale_tota_amou", new BigDecimal(getSale_tota_amou).toString());
			colDataList.add(sumData);
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
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;	
	}
	
	/**
	 * 매출반제 목록 엑셀
	 */
	@RequestMapping("adjustSalesTransmissionListForExcel.sys")
	public ModelAndView adjustSalesTransmissionListForExcel(
			@RequestParam(value = "sidx", defaultValue = "a.sale_sequ_numb") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "srcSalesName", defaultValue = "") String srcSalesName,
			@RequestParam(value = "srcTransStatus", defaultValue = "") String srcTransStatus,
			@RequestParam(value = "srcSalesTransStartDate", defaultValue = "") String srcSalesTransStartDate,
			@RequestParam(value = "srcSalesTransEndDate", defaultValue = "") String srcSalesTransEndDate,
			@RequestParam(value = "srcClientNm", defaultValue = "") String srcClientNm,
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,
			@RequestParam(value = "srcIsCollect", defaultValue = "") String srcIsCollect,
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "dateCalc", defaultValue ="") String srcDateCalc,
			@RequestParam(value = "srcStartDate", defaultValue ="") String srcStartDate,
			@RequestParam(value = "srcEndDate", defaultValue ="") String srcEndDate,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSalesName"			, srcSalesName);
		params.put("srcTransStatus"			, srcTransStatus);
		params.put("srcClientNm"			, srcClientNm);
		params.put("srcBusinessNum"			, srcBusinessNum);
		params.put("srcIsCollect"			, srcIsCollect);
		params.put("create_borgid"			, userInfoDto.getBorgId());
		params.put("srcDateCalc", srcDateCalc);
		params.put("srcStartDate", srcStartDate);
		params.put("srcEndDate", srcEndDate);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		/*----------------조회------------*/
		List<Map<String, Object>> colDataList = adjustSvc.adjustSalesTransmissionListForExcel(params); //조회조건에 따른 카운트
		if(colDataList != null && colDataList.size() > 0){
			double saleTotaAmouSum = 0;
			double recePayAmouSum = 0;
			for (int i = 0; i < colDataList.size(); i++) {
				
				if(i > 0){
					
					int nowId = Integer.parseInt(colDataList.get(i).get("ID").toString());

					if(nowId > 1){
						colDataList.get(i).put("LASTIDX", i);
					}
				}
				BigDecimal noneCollAmou = null;
				if(!"1".equals(colDataList.get(i).get("ID").toString())){
					if(i > 0){
						noneCollAmou = new BigDecimal(Double.parseDouble(colDataList.get(i-1).get("TMP_NONE_COLL_AMOU").toString()) - Double.parseDouble(colDataList.get(i).get("RECE_PAY_AMOU").toString()));
						colDataList.get(i).put("SALE_TOTA_AMOU", "");
						colDataList.get(i).put("TMP_NONE_COLL_AMOU", noneCollAmou.toString().replace(".00", ""));
					}
				}else{
					colDataList.get(i).put("FIRSTIDX", i);
					saleTotaAmouSum += Double.parseDouble(colDataList.get(i).get("SALE_TOTA_AMOU").toString());
				}
				
				int firstIdx = colDataList.get(i).get("FIRSTIDX") == null ? -1 : Integer.parseInt(colDataList.get(i).get("FIRSTIDX").toString());
				int lastIdx  = colDataList.get(i).get("LASTIDX") == null ? -1 : Integer.parseInt(colDataList.get(i).get("LASTIDX").toString());
				
				if(firstIdx == -1){
					firstIdx = colDataList.get(i-1).get("FIRSTIDX") == null ? -1 : Integer.parseInt(colDataList.get(i-1).get("FIRSTIDX").toString());
					colDataList.get(i).put("FIRSTIDX", firstIdx);
				}
				
				if(lastIdx == -1){
					lastIdx = colDataList.get(i).get("FIRSTIDX") == null ? -1 : Integer.parseInt(colDataList.get(i).get("FIRSTIDX").toString());
					colDataList.get(i).put("LASTIDX", lastIdx);
				}
				
				colDataList.get(i).put("NONE_COLL_AMOU", "0");				
				colDataList.get(firstIdx).put("NONE_COLL_AMOU", colDataList.get(lastIdx).get("TMP_NONE_COLL_AMOU"));
				
				recePayAmouSum += Double.parseDouble(colDataList.get(i).get("RECE_PAY_AMOU").toString());
			}
			Map<String, Object> total = new HashMap<String, Object>(); 
			total.put("BRANCHNM", "TOTAL");
			total.put("SALE_TOTA_AMOU", new BigDecimal(saleTotaAmouSum).toString().replace(".00", ""));
			total.put("RECE_PAY_AMOU", new BigDecimal(recePayAmouSum).toString().replace(".00", ""));
			total.put("NONE_COLL_AMOU", new BigDecimal(saleTotaAmouSum - recePayAmouSum).toString().replace(".00", ""));
			colDataList.add(total);
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
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;		
	}
	
	/**
	 * 매출전송 처리
	 */
	@RequestMapping("adjustSalesTransApply.sys")
	public ModelAndView adjustSalesTransApply(
			@RequestParam(value = "closeDateArr[]"		, required = true) String[] closeDateArr,
			@RequestParam(value = "saleSequNumbArr[]"	, required = true) String[] saleSequNumbArr,
			@RequestParam(value = "saleSequNameArr[]"	, required = true) String[] saleSequNameArr,
			@RequestParam(value = "saleRequAmouArr[]"	, required = true) String[] saleRequAmouArr,
			@RequestParam(value = "saleRequVtaxArr[]"	, required = true) String[] saleRequVtaxArr,
			@RequestParam(value = "businessNumArr[]"	, required = true) String[] businessNumArr,
			@RequestParam(value = "paymCondCodeArr[]"	, required = true) String[] paymCondCodeArr,
			@RequestParam(value = "bankCdArr[]"			, required = false) String[] bankCdArr,

			@RequestParam(value = "loginIdArr[]"	, required = true) String[] loginIdArr,
			@RequestParam(value = "userNmArr[]"	, required = true) String[] userNmArr,
			@RequestParam(value = "telArr[]"	, required = true) String[] telArr,
			@RequestParam(value = "branchNmArr[]"	, required = true) String[] branchNmArr,
			@RequestParam(value = "pressentNmArr[]"	, required = true) String[] pressentNmArr,
			@RequestParam(value = "addresArr[]"	, required = true) String[] addresArr,
			@RequestParam(value = "branchBusiClasArr[]"	, required = true) String[] branchBusiClasArr,
			@RequestParam(value = "branchBusiTypeArr[]"	, required = true) String[] branchBusiTypeArr,
			@RequestParam(value = "good_nameArr[]"	, required = true) String[] good_nameArr,
			@RequestParam(value = "eMailArr[]"	, required = true) String[] eMailArr,
			@RequestParam(value = "branchIdArr[]"	, required = true) String[] branchIdArr,
			@RequestParam(value = "autOrderLimitPeriodArr[]", required = true) String[] autOrderLimitPeriodArr,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);		
		
		CustomResponse custResponse = new CustomResponse(true);
		for(int i = 0 ; i < saleSequNumbArr.length ; i++){
			Map<String, Object> saveMap = new HashMap<String, Object>();
	    	saveMap.put("memID", Constances.EBILL_MEMID);
	    	saveMap.put("memName", Constances.EBILL_MEMNAME);
	    	saveMap.put("email", Constances.EBILL_EMAIL);
	    	saveMap.put("tel", Constances.EBILL_TEL);
	    	saveMap.put("coRegNo", Constances.EBILL_COREGNO);
	    	saveMap.put("coName", Constances.EBILL_CONAME);
	    	saveMap.put("coCeo", Constances.EBILL_COCEO);
	    	saveMap.put("coAddr", Constances.EBILL_COADDR);
	    	saveMap.put("coBizType", Constances.EBILL_COBIZTYPE);
	    	saveMap.put("coBizSub", Constances.EBILL_COBIZSUB);
			
			saveMap.put("closeDate"		, closeDateArr[i]);
			saveMap.put("saleSequNumb"	, saleSequNumbArr[i]);
			saveMap.put("userId", userInfoDto.getUserId());
			saveMap.put("userNm", userInfoDto.getUserNm());
			saveMap.put("autOrderLimitPeriod", autOrderLimitPeriodArr[i]);
			
			saveMap.put("businessNum", businessNumArr[i]);
			saveMap.put("payBillDay", adjustSvc.selectPayBillTypeCd(paymCondCodeArr[i]).get("CODEVAL2"));
			String bankCd = "";
			if(bankCdArr != null) bankCd = bankCdArr[i];  
			saveMap.put("bankCd", bankCd);
			// 전자세금계산서 정보
			saveMap.put("recMemID", loginIdArr[i]);
			saveMap.put("recMemName", userNmArr[i]);
			saveMap.put("recTel", telArr[i]);
			saveMap.put("sms", telArr[i].replace("-", ""));
			saveMap.put("recCoName", branchNmArr[i]);
			saveMap.put("recCoCeo", pressentNmArr[i]);
			saveMap.put("recCoAddr", addresArr[i]);
			saveMap.put("recCoBizType", branchBusiClasArr[i]);
			saveMap.put("recCoBizSub", branchBusiTypeArr[i]);
			saveMap.put("recCoRegNo", businessNumArr[i]);
			saveMap.put("recEMail", eMailArr[i]);
			saveMap.put("branchId", branchIdArr[i]);
			// 품목리스트 정보
			saveMap.put("itemName", good_nameArr[i] + " 외");
			
			//매출번호로 매출전송정보를 가져오기(매출번호로 Sap전표번호가 Null 이거나 매출확정된 상태)
			Map<String, Object> resultMap = adjustSvc.getAdjustInfoBySaleSequNumb(saleSequNumbArr[i]);
			if(resultMap != null && !resultMap.isEmpty()) {
				saveMap.put("saleSequName", resultMap.get("sale_sequ_name"));
				saveMap.put("saleRequAmou", resultMap.get("sale_requ_amou"));
				saveMap.put("saleRequVtax", resultMap.get("sale_requ_vtax"));
				saveMap.put("paymCondCode", resultMap.get("paym_cond_code"));
				/*----------------처리수행 및 성공여부 세팅------------*/
				try {
					adjustSvc.adjustSalesTransApply(saveMap);
				} catch(Exception e) {
					logger.error("Exception : "+e);
					custResponse.setSuccess(false);
					custResponse.setMessage("System Excute Error!....");
					custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
				}
			} else {
				logger.info("Sale_Sequ_Numb Not Exist..........................! OR Sap_Jour_Numb Not Exist.......................!");
				logger.info("매출번호 : "+saleSequNumbArr[i]);
				saveMap.clear();
			}
//			saveMap.put("saleSequName"	, saleSequNameArr[i]);
//			saveMap.put("saleRequAmou"	, saleRequAmouArr[i]);
//			saveMap.put("saleRequVtax"	, saleRequVtaxArr[i]);
//			saveMap.put("businessNum"	, businessNumArr[i]);
//			saveMap.put("paymCondCode"	, paymCondCodeArr[i]);
//			saveMap.put("payBillDay"	, adjustSvc.selectPayBillTypeCd(paymCondCodeArr[i]).get("CODEVAL2"));
//			if(bankCdArr != null)   	bankCd = bankCdArr[i];  
//			saveMap.put("bankCd"		, bankCd);
//			saveMap.put("userId"		, userInfoDto.getUserId());
//			saveMap.put("userNm"		, userInfoDto.getUserNm());
//			saveMap.put("autOrderLimitPeriod", autOrderLimitPeriodArr[i]);
//			// 전자세금계산서 정보
//			saveMap.put("recMemID"		, loginIdArr[i]);
//			saveMap.put("recMemName"	, userNmArr[i]);
//			saveMap.put("recTel"		, telArr[i]);
//			saveMap.put("sms"			, telArr[i].replace("-", ""));
//			saveMap.put("recCoName"		, branchNmArr[i]);
//			saveMap.put("recCoCeo"		, pressentNmArr[i]);
//			saveMap.put("recCoAddr"		, addresArr[i]);
//			saveMap.put("recCoBizType"  , branchBusiClasArr[i]);
//			saveMap.put("recCoBizSub"   , branchBusiTypeArr[i]);
//			saveMap.put("recCoRegNo"	, businessNumArr[i]);
//			saveMap.put("recEMail"	    , eMailArr[i]);
//			saveMap.put("branchId"		, branchIdArr[i]);
//			// 품목리스트 정보
//			saveMap.put("itemName"		, good_nameArr[i] + " 외");
			
			/*----------------처리수행 및 성공여부 세팅------------*/
//			try {
//				//전표번호존재여부 확인개수
//				int sapCnt = adjustSvc.getAdjustSapNumCount(saleSequNumbArr[i]);
//				if(sapCnt == 0) {
//					adjustSvc.adjustSalesTransApply(saveMap);
//				}
//			} catch(Exception e) {
//				logger.error("Exception : "+e);
//				custResponse.setSuccess(false);
//				custResponse.setMessage("System Excute Error!....");
//				custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
//			}
		}

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}	

	/** 
	 * 매출전송 취소처리
	 */
	@RequestMapping("adjustSalesTransCancel.sys")
	public ModelAndView adjustSalesTransCancel(
			@RequestParam(value = "closeDateArr[]"		, required = true) String[] closeDateArr,
			@RequestParam(value = "saleSequNumbArr[]"	, required = true) String[] saleSequNumbArr,
			@RequestParam(value = "saleSequNameArr[]"	, required = true) String[] saleSequNameArr,
			@RequestParam(value = "sapJourNumbArr[]"	, required = true) String[] sapJourNumbArr,
			@RequestParam(value = "saleRequAmouArr[]"	, required = true) String[] saleRequAmouArr,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		for(int i = 0 ; i < saleSequNumbArr.length ; i++){
			Map<String, Object> resultMap = adjustSvc.getMssalmInfo(saleSequNumbArr[i]);
			if(resultMap != null && !resultMap.isEmpty()) {
				Map<String, Object> saveMap = new HashMap<String, Object>();
				saveMap.put("closeDate", resultMap.get("clos_sale_date"));
				saveMap.put("saleSequNumb",  resultMap.get("sale_sequ_numb"));
				saveMap.put("saleSequName",  resultMap.get("sale_sequ_name"));
				saveMap.put("seqSapNo",  resultMap.get("sap_jour_numb"));
				saveMap.put("saleRequAmou",  resultMap.get("sale_requ_amou"));
				saveMap.put("userId", userInfoDto.getUserId());
				saveMap.put("userNm", userInfoDto.getUserNm());
				
	//			saveMap.put("closeDate"		, closeDateArr[i]);
	//			saveMap.put("saleSequNumb"	, saleSequNumbArr[i]);
	//			saveMap.put("saleSequName"	, saleSequNameArr[i]);
	//			saveMap.put("seqSapNo"		, sapJourNumbArr[i]);
	//			saveMap.put("userId"		, userInfoDto.getUserId());
	//			saveMap.put("userNm"		, userInfoDto.getUserNm());
	//			saveMap.put("saleRequAmou"	, saleRequAmouArr[i]);
				
				/*----------------처리수행 및 성공여부 세팅------------*/
				try {
					adjustSvc.adjustSalesTransCancel(saveMap);
				} catch(Exception e) {
					logger.error("Exception : "+e);
					custResponse.setSuccess(false);
					//custResponse.setMessage("System Excute Error!....");
					custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
					custResponse.setMessage("");
				}
			} else {
				logger.info("매출번호 : "+saleSequNumbArr[i]+" 의 매출전송정보가 존재하지 않아 매출전송취소를 할 수 없습니다.");
			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}	

	@RequestMapping("adjustPurchaseTransmission.sys")
	public ModelAndView adjustPurchaseTransmission(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustPurchaseTransmission");
	}
	
	/**
	 * 매입전송 목록
	 */
	@RequestMapping("adjustPurchaseTransmissionJQGrid.sys")
	public ModelAndView adjustPurchaseTransmissionJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "a.buyi_sequ_numb") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "srcTransStatus", defaultValue = "") String srcTransStatus,
			@RequestParam(value = "srcPurchaseConfStartDate", defaultValue = "") String srcPurchaseConfStartDate,
			@RequestParam(value = "srcPurchaseConfEndDate", defaultValue = "") String srcPurchaseConfEndDate,
			@RequestParam(value = "srcPurchaseClosStartDate", defaultValue = "") String srcPurchaseClosStartDate,
			@RequestParam(value = "srcPurchaseClosEndDate", defaultValue = "") String srcPurchaseClosEndDate,
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,
			@RequestParam(value = "srcIsPayment", defaultValue = "") String srcIsPayment,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcTransStatus"				, srcTransStatus);
		params.put("srcPurchaseConfStartDate"	, srcPurchaseConfStartDate);
		params.put("srcPurchaseConfEndDate"		, srcPurchaseConfEndDate);
		params.put("srcVendorNm"				, srcVendorNm);
		params.put("srcBusinessNum"				, srcBusinessNum);
		params.put("create_borgid"				, userInfoDto.getBorgId());
		params.put("srcPurchaseClosStartDate"	, srcPurchaseClosStartDate);
		params.put("srcPurchaseClosEndDate"		, srcPurchaseClosEndDate);
		params.put("srcIsPayment"				, srcIsPayment);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = adjustSvc.adjustPurchaseTransmissionListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<AdjustDto> list = null;
        if(records>0) list = adjustSvc.adjustPurchaseTransmissionList(params, page, rows); //조회조건에 따른 카운트
        
        if(list != null && list.size() > 0){
        	double getBuyi_requ_amou = 0;
        	double getBuyi_requ_vtax = 0;
        	double getBuyi_tota_amou = 0;
        	double getPay_amou = 0;
        	double getNone_coll_amou = 0;

        	for(AdjustDto dto : list){
        		getBuyi_requ_amou += Double.parseDouble(dto.getBuyi_requ_amou());
        		getBuyi_requ_vtax += Double.parseDouble(dto.getBuyi_requ_vtax());
        		getBuyi_tota_amou += Double.parseDouble(dto.getBuyi_tota_amou());
        		getPay_amou += Double.parseDouble(dto.getPay_amou());
        		getNone_coll_amou += Double.parseDouble(dto.getNone_paym_amou());
        	}
        	list.get(0).setSum_buyi_requ_amou(new BigDecimal(getBuyi_requ_amou));
        	list.get(0).setSum_buyi_requ_vtax(new BigDecimal(getBuyi_requ_vtax));
        	list.get(0).setSum_buyi_tota_amou(new BigDecimal(getBuyi_tota_amou));
        	list.get(0).setSum_pay_amou(new BigDecimal(getPay_amou));
        	list.get(0).setSum_none_coll_amou(new BigDecimal(getNone_coll_amou));
        }

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);				
		return modelAndView;
	}
	/**
	 * 매입전송 목록 엑셀 다운로드
	 */
	@RequestMapping("adjustPurchaseTransmissionExcel.sys")
	public ModelAndView adjustPurchaseTransmissionExcel(
			@RequestParam(value = "sidx", defaultValue = "a.buyi_sequ_numb") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "srcTransStatus", defaultValue = "") String srcTransStatus,
			@RequestParam(value = "srcPurchaseConfStartDate", defaultValue = "") String srcPurchaseConfStartDate,
			@RequestParam(value = "srcPurchaseConfEndDate", defaultValue = "") String srcPurchaseConfEndDate,
			@RequestParam(value = "srcPurchaseClosStartDate", defaultValue = "") String srcPurchaseClosStartDate,
			@RequestParam(value = "srcPurchaseClosEndDate", defaultValue = "") String srcPurchaseClosEndDate,
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,
			@RequestParam(value = "srcIsPayment", defaultValue = "") String srcIsPayment,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcTransStatus"				, srcTransStatus);
		params.put("srcPurchaseConfStartDate"	, srcPurchaseConfStartDate);
		params.put("srcPurchaseConfEndDate"		, srcPurchaseConfEndDate);
		params.put("srcVendorNm"				, srcVendorNm);
		params.put("srcBusinessNum"				, srcBusinessNum);
		params.put("create_borgid"				, userInfoDto.getBorgId());
		params.put("srcPurchaseClosStartDate"	, srcPurchaseClosStartDate);
		params.put("srcPurchaseClosEndDate"		, srcPurchaseClosEndDate);
		params.put("srcIsPayment"				, srcIsPayment);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<AdjustDto> list = adjustSvc.adjustPurchaseTransmissionList(params, 1, RowBounds.NO_ROW_LIMIT); //조회조건에 따른 카운트
		
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			
			double getBuyi_requ_amou = 0;
			double getBuyi_requ_vtax = 0;
			double getBuyi_tota_amou = 0;
			double getPay_amou = 0;
			double getNone_coll_amou = 0;
			
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			
			for(int i = 0; i < list.size() ; i++){
				
				AdjustDto dto = list.get(i);
				
				getBuyi_requ_amou += Double.parseDouble(dto.getBuyi_requ_amou());
				getBuyi_requ_vtax += Double.parseDouble(dto.getBuyi_requ_vtax());
				getBuyi_tota_amou += Double.parseDouble(dto.getBuyi_tota_amou());
				getPay_amou += Double.parseDouble(dto.getPay_amou());
				getNone_coll_amou += Double.parseDouble(dto.getNone_paym_amou());
				
				rtnData = new HashMap<String, Object>();
				rtnData.put("sap_jour_numb", list.get(i).getSap_jour_numb());
				rtnData.put("clos_buyi_date", list.get(i).getClos_buyi_date());
				rtnData.put("vendorNm", list.get(i).getVendorNm());
				rtnData.put("buyi_conf_date", list.get(i).getBuyi_conf_date());
				rtnData.put("buyi_requ_amou", list.get(i).getBuyi_requ_amou());
				rtnData.put("buyi_requ_vtax", list.get(i).getBuyi_requ_vtax());
				rtnData.put("buyi_tota_amou", list.get(i).getBuyi_tota_amou());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				colDataList.add(rtnData);
			}
			Map<String, Object> sumData = new HashMap<String, Object>();
			sumData.put("buyi_conf_date", "합계");
			sumData.put("buyi_requ_amou", new BigDecimal(getBuyi_requ_amou).toString());
			sumData.put("buyi_requ_vtax", new BigDecimal(getBuyi_requ_vtax).toString());
			sumData.put("buyi_tota_amou", new BigDecimal(getBuyi_tota_amou).toString());
			sumData.put("pay_amou", new BigDecimal(getPay_amou).toString());
			sumData.put("none_coll_amou", new BigDecimal(getNone_coll_amou).toString());
			colDataList.add(sumData);
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
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;	
	}
	
	/**
	 * 매입전송 처리
	 */
	@RequestMapping("adjustPurchaseTransApply.sys")
	public ModelAndView adjustPurchaseTransApply(
			@RequestParam(value = "closeDateArr[]"		, required = true) String[] closeDateArr,
			@RequestParam(value = "vendorNmArr[]"		, required = true) String[] vendorNmArr,
			@RequestParam(value = "buyiSequNumbArr[]"	, required = true) String[] buyiSequNumbArr,
			@RequestParam(value = "buyiRequAmouArr[]"	, required = true) String[] buyiRequAmouArr,
			@RequestParam(value = "buyiRequVtaxArr[]"	, required = true) String[] buyiRequVtaxArr,
			@RequestParam(value = "businessNumArr[]"	, required = true) String[] businessNumArr,
			@RequestParam(value = "paymCondCodeArr[]"	, required = true) String[] paymCondCodeArr,
			@RequestParam(value = "bankCdArr[]"			, required = false) String[] bankCdArr,
			
			@RequestParam(value = "loginIdArr[]"	, required = true) String[] loginIdArr,
			@RequestParam(value = "userNmArr[]"	, required = true) String[] userNmArr,
			@RequestParam(value = "telArr[]"	, required = true) String[] telArr,
			@RequestParam(value = "pressentNmArr[]"	, required = true) String[] pressentNmArr,
			@RequestParam(value = "addresArr[]"	, required = true) String[] addresArr,
			@RequestParam(value = "vendorBusiClasArr[]"	, required = true) String[] vendorBusiClasArr,
			@RequestParam(value = "vendorBusiTypeArr[]"	, required = true) String[] vendorBusiTypeArr,
			@RequestParam(value = "good_nameArr[]"	, required = true) String[] good_nameArr,
			@RequestParam(value = "eMailArr[]"	, required = true) String[] eMailArr,
			@RequestParam(value = "vendorIdArr[]"	, required = true) String[] vendorIdArr,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		for(int i = 0 ; i < buyiSequNumbArr.length ; i++){
			Map<String, Object> saveMap = new HashMap<String, Object>();
	    	saveMap.put("recMemID"		, Constances.EBILL_MEMID);
			saveMap.put("recMemName"	, Constances.EBILL_MEMNAME);
			saveMap.put("recTel"		, Constances.EBILL_TEL);
			saveMap.put("recEMail"	    , Constances.EBILL_EMAIL);
			saveMap.put("recCoRegNo"	, Constances.EBILL_COREGNO);
			saveMap.put("recCoName"		, Constances.EBILL_CONAME);
			saveMap.put("recCoCeo"		, Constances.EBILL_COCEO);
			saveMap.put("recCoAddr"		, Constances.EBILL_COADDR);
			saveMap.put("recCoBizType"  , Constances.EBILL_COBIZTYPE);
			saveMap.put("recCoBizSub"   , Constances.EBILL_COBIZSUB);
			
			saveMap.put("closeDate"		, closeDateArr[i]);
			saveMap.put("vendorNm"		, vendorNmArr[i]);
			saveMap.put("buyiSequNumb"	, buyiSequNumbArr[i]);
//			saveMap.put("buyiRequAmou"	, buyiRequAmouArr[i]);
//			saveMap.put("buyiRequVtax"	, buyiRequVtaxArr[i]);
			saveMap.put("businessNum"	, businessNumArr[i]);
//			saveMap.put("paymCondCode"	, paymCondCodeArr[i]);
			saveMap.put("payBillDay"	, adjustSvc.selectPayBillTypeCd(paymCondCodeArr[i]).get("CODEVAL2"));
			//saveMap.put("payBillDay"	, paymCondCodeArr[i].substring(1));
			saveMap.put("sms"			, telArr[i].replace("-", ""));
			
			String bankCd = "";
			if(bankCdArr != null)   	bankCd = bankCdArr[i];
			saveMap.put("bankCd"		, bankCd);
			saveMap.put("userId"		, userInfoDto.getUserId());
			saveMap.put("userNm"		, userInfoDto.getUserNm());
			
			// 전자세금계산서 정보
			saveMap.put("memID"			, loginIdArr[i]);
	    	saveMap.put("memName"		, userNmArr[i]);
	    	saveMap.put("tel"			, telArr[i]);
	    	saveMap.put("email"			, eMailArr[i]);
	    	saveMap.put("coRegNo"		, businessNumArr[i]);
	    	saveMap.put("coName"		, vendorNmArr[i]);
	    	saveMap.put("coCeo"			, pressentNmArr[i]);
	    	saveMap.put("coAddr"		, addresArr[i]);
	    	saveMap.put("coBizType"		, vendorBusiClasArr[i]);
	    	saveMap.put("coBizSub"		, vendorBusiTypeArr[i]);
			// 품목리스트 정보
			saveMap.put("itemName"		, good_nameArr[i] + " 외");
			// 공급사 아이디
			saveMap.put("vendorId", vendorIdArr[i]);
			
			//매입번호로 매입전송대상 정보를 가져오기(매입번호로 Sap전표번호가 Null인 정보)
			Map<String, Object> resultMap = adjustSvc.getAdjustInfoByBuyiSequNumb(buyiSequNumbArr[i]);
			if(resultMap != null && !resultMap.isEmpty()) {
				saveMap.put("buyiRequAmou", resultMap.get("buyi_requ_amou"));
				saveMap.put("buyiRequVtax", resultMap.get("buyi_requ_vtax"));
				saveMap.put("paymCondCode", resultMap.get("paym_cond_code"));
				/*----------------처리수행 및 성공여부 세팅------------*/
				try {
					adjustSvc.adjustPurchaseTransApply(saveMap);
				} catch(Exception e) {
					logger.error("Exception : "+e);
					custResponse.setSuccess(false);
					//custResponse.setMessage("System Excute Error!....");
					custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
					custResponse.setMessage("");
				}
			} else {
				logger.info("Buyi_Sequ_Numb Not Exist..........................! OR Sap_Jour_Numb Not Exist.......................!");
				logger.info("매입번호 : "+buyiSequNumbArr[i]);
				saveMap.clear();
			}
		}

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}	
	
	@RequestMapping("adjustPurchaseTransmissionInfo.sys")
	public ModelAndView adjustPurchaseTransmissionInfo(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustPurchaseTransmissionInfo");
	}	

	/**
	 * 매입전송 취소처리
	 */
	@RequestMapping("adjustPurchaseTransCancel.sys")
	public ModelAndView adjustPurchaseTransCancel(
			@RequestParam(value = "closeDateArr[]"		, required = true) String[] closeDateArr,
			@RequestParam(value = "buyiSequNumbArr[]"	, required = true) String[] buyiSequNumbArr,
			@RequestParam(value = "vendorNmArr[]"		, required = true) String[] vendorNmArr,
			@RequestParam(value = "sapJourNumbArr[]"	, required = true) String[] sapJourNumbArr,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		for(int i = 0 ; i < buyiSequNumbArr.length ; i++){
			Map<String, Object> resultMap = adjustSvc.getMsbuymInfo(buyiSequNumbArr[i]);
			if(resultMap != null && !resultMap.isEmpty()) {
				Map<String, Object> saveMap = new HashMap<String, Object>();
				saveMap.put("closeDate", resultMap.get("clos_buyi_date"));
				saveMap.put("buyiSequNumb", resultMap.get("buyi_sequ_numb"));
				saveMap.put("vendorNm", resultMap.get("vendorNm"));
				saveMap.put("seqSapNo", resultMap.get("sap_jour_numb"));
				saveMap.put("buyi_requ_amou", resultMap.get("buyi_requ_amou"));
				saveMap.put("userId", userInfoDto.getUserId());
				saveMap.put("userNm", userInfoDto.getUserNm());
				saveMap.put("vendorId", resultMap.get("vendorid"));
				
	//			saveMap.put("closeDate"		, closeDateArr[i]);
	//			saveMap.put("buyiSequNumb"	, buyiSequNumbArr[i]);
	//			saveMap.put("vendorNm"		, vendorNmArr[i]);
	//			saveMap.put("seqSapNo"		, sapJourNumbArr[i]);
	//			saveMap.put("userId"		, userInfoDto.getUserId());
	//			saveMap.put("userNm"		, userInfoDto.getUserNm());
				
				/*----------------처리수행 및 성공여부 세팅------------*/
				try {
					adjustSvc.adjustPurchaseTransCancel(saveMap);
				} catch(Exception e) {
					logger.error("Exception : "+e);
					custResponse.setSuccess(false);
					//custResponse.setMessage("System Excute Error!....");
					custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
					custResponse.setMessage("");
				}
			} else {
				logger.info("매입번호 : "+buyiSequNumbArr[i]+" 의 매입전송정보가 존재하지 않아 매입전송취소를 할 수 없습니다.");
			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}	
	
	@RequestMapping("adjustSalesDeposit.sys")
	public ModelAndView adjustSalesDeposit(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustSalesDeposit");
	}

	/**
	 * 매출입금처리 상세
	 */
	@RequestMapping("adjustSalesDepositDetailPop.sys")
	public ModelAndView adjustSalesDepositDetailPop(
			@RequestParam(value = "sale_sequ_numb"		, required = true) String sale_sequ_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("sale_sequ_numb"	, sale_sequ_numb);
		paramMap.put("create_borgid"	, userInfoDto.getBorgId());
		
		AdjustDto detailInfo = adjustSvc.adjustSalesTransmissionList(paramMap, -1, -1).get(0);	// 사업장 마스터
		List<UserDto> alramUserList = adjustSvc.getAdjustAlramUserList();

		modelAndView.addObject("detailInfo"	, detailInfo);
		modelAndView.addObject("alramUserList"	, alramUserList);
		modelAndView.setViewName("adjust/adjustSalesDepositDetailPop");
		return modelAndView;
	}
	
	/**
	 * 매출입금처리 상세저장
	 */
	@RequestMapping("saveDepositDetail.sys")
	public ModelAndView saveDepositDetail(
			@RequestParam(value = "oper"		, required = true) String oper,
			@RequestParam(value = "pay_amou"	, defaultValue = "0") String pay_amou,							//입금금액
			@RequestParam(value = "context"		, defaultValue = "") String context,
			@RequestParam(value = "sale_sequ_numb"	, required = true) String sale_sequ_numb,
			@RequestParam(value = "none_coll_amou"	, defaultValue = "0") String none_coll_amou,				//미회수금액
			@RequestParam(value = "payDate"	, defaultValue = "") String payDate,
			@RequestParam(value = "rece_sequ_num"	, defaultValue = "") String rece_sequ_num,
			@RequestParam(value = "sel_rece_pay_amou"	, defaultValue = "0") String sel_rece_pay_amou,

			@RequestParam(value = "schedule_date"	, defaultValue = "") String schedule_date,
			@RequestParam(value = "schedule_amou"	, defaultValue = "") String schedule_amou,
			@RequestParam(value = "tel_user_nm"	, defaultValue = "") String tel_user_nm,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		
		CustomResponse custResponse = new CustomResponse(true);
		
		saveMap.put("oper"				, oper);
		saveMap.put("rece_pay_amou"		, pay_amou);
		saveMap.put("context"			, context);
		saveMap.put("sale_sequ_numb"	, sale_sequ_numb);
		saveMap.put("none_coll_amou"	, none_coll_amou);
		saveMap.put("rece_user_id"		, userInfoDto.getUserId());
		saveMap.put("rece_sequ_num" 	, rece_sequ_num);
		saveMap.put("sel_rece_pay_amou" , sel_rece_pay_amou);
		saveMap.put("payDate" 			, payDate);

		saveMap.put("schedule_date" 	, schedule_date);
		saveMap.put("schedule_amou" 	, schedule_amou);
		saveMap.put("tel_user_nm" 		, tel_user_nm);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		try {
			adjustSvc.saveDepositDetail(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
			custResponse.setMessage("");
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}	
	
	@RequestMapping("adjustSalesDepositDescPop.sys")
	public ModelAndView adjustSalesDepositDescPop(
			@RequestParam(value = "sale_sequ_numb", required = true) String sale_sequ_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("sale_sequ_numb", sale_sequ_numb);
		modelAndView.setViewName("adjust/adjustSalesDepositDescPop");
		return modelAndView;
	}	
	
	/**
	 * 매출입금내역 상세내용
	 */
	@RequestMapping("adjustSalesDepositDescListJQGrid.sys")
	public ModelAndView adjustSalesDepositDescListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "a.create_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,
			@RequestParam(value = "sale_sequ_numb", required = true) String sale_sequ_numb,
			@RequestParam(value = "sap_jour_numb", defaultValue="") String sap_jour_numb,
			@RequestParam(value = "isBonds", defaultValue="") String isBonds,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sale_sequ_numb"	, sale_sequ_numb);
		params.put("sap_jour_numb"	, sap_jour_numb);
		params.put("isBonds"		, isBonds);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
        List<AdjustDto> list = adjustSvc.adjustSalesDepositDescList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);				
		return modelAndView;
	}
	
	/**
	 * 매출입금처리 입금즉시확인 처리
	 */
	@RequestMapping("salesDepositConfirm.sys")
	public ModelAndView salesDepositConfirm(
			@RequestParam(value = "sale_sequ_numb_Arr[]", required=true) String[] sale_sequ_numb_Arr,
			@RequestParam(value = "clos_sale_date_Arr[]", required=true) String[] clos_sale_date_Arr,
			@RequestParam(value = "rece_pay_amou_Arr[]", required=true) String[] rece_pay_amou_Arr,
			@RequestParam(value = "none_coll_amou_Arr[]", required=true) String[] none_coll_amou_Arr,
			@RequestParam(value = "sap_jour_numb_Arr[]", required=true) String[] sap_jour_numb_Arr,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		CustomResponse custResponse = new CustomResponse(true);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		Map<String, Object> saveMap = new HashMap<String, Object>();

		for (int i = 0; i < sale_sequ_numb_Arr.length; i++) {
			try {
				if(sale_sequ_numb_Arr != null && sale_sequ_numb_Arr.length > 0){
					saveMap.put("clos_sale_date", clos_sale_date_Arr[i]);	// 회계년도
					saveMap.put("sale_sequ_numb", sale_sequ_numb_Arr[i]);	// 전표번호
					saveMap.put("none_coll_amou", none_coll_amou_Arr[i]);	
					saveMap.put("rece_pay_amou" , rece_pay_amou_Arr[i]);	
					saveMap.put("sap_jour_numb" , sap_jour_numb_Arr[i]);	
					saveMap.put("rece_user_id"	, userInfoDto.getUserId()); // UserId
					adjustSvc.salesDepositConfirm(saveMap);
				}
				
			} catch(Exception e) {
				logger.error("Exception : "+e);
				custResponse.setSuccess(false);
				//custResponse.setMessage("System Excute Error!....");
				custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
				custResponse.setMessage("");
			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}		
	
	@RequestMapping("adjustPurchasePayment.sys")
	public ModelAndView adjustPurchasePayment(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustPurchasePayment");
	}

	@RequestMapping("adjustPurchasePaymentDetailPop.sys")
	public ModelAndView adjustPurchasePaymentDetailPop(
			@RequestParam(value = "buyi_sequ_numb"		, required = true) String buyi_sequ_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("buyi_sequ_numb"	, buyi_sequ_numb);
		paramMap.put("create_borgid"	, userInfoDto.getBorgId());
		
		AdjustDto detailInfo = adjustSvc.adjustPurchaseTransmissionList(paramMap, -1, -1).get(0);

		modelAndView.addObject("detailInfo"	, detailInfo);
		modelAndView.setViewName("adjust/adjustPurchasePaymentDetailPop");
		return modelAndView;		
	}

	@RequestMapping("adjustPurchaseDebtDetailPop.sys")
	public ModelAndView adjustPurchaseDebtDetailPop(
			@RequestParam(value = "buyi_sequ_numb"		, required = true) String buyi_sequ_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("buyi_sequ_numb"	, buyi_sequ_numb);
		paramMap.put("create_borgid"	, userInfoDto.getBorgId());
		
		AdjustDto detailInfo = adjustSvc.adjustPurchaseTransmissionList(paramMap, -1, -1).get(0);
		
		modelAndView.addObject("detailInfo"	, detailInfo);
		modelAndView.setViewName("adjust/adjustPurchaseDebtDetailPop");
		return modelAndView;		
	}
	
	/**
	 * 매입지급처리 상세저장
	 */
	@RequestMapping("savePaymentDetail.sys")
	public ModelAndView savePaymentDetail(
			@RequestParam(value = "oper"		, required = true) String oper,
			@RequestParam(value = "pay_amou"	, defaultValue = "0") String pay_amou,
			@RequestParam(value = "context"		, defaultValue = "") String context,
			@RequestParam(value = "buyi_sequ_numb"	, required = true) String buyi_sequ_numb,
			@RequestParam(value = "none_paym_amou"	, defaultValue = "0") String none_paym_amou,
			@RequestParam(value = "payDate"			, defaultValue = "") String payDate,
			@RequestParam(value = "rece_sequ_num"	, defaultValue = "") String rece_sequ_num,
			@RequestParam(value = "sel_buyi_tota_amou"	, defaultValue = "0") String sel_buyi_tota_amou,			
			
			@RequestParam(value = "schedule_date"	, defaultValue = "") String schedule_date,
			@RequestParam(value = "schedule_amou"	, defaultValue = "") String schedule_amou,
			@RequestParam(value = "tel_user_nm"	, defaultValue = "") String tel_user_nm,
			@RequestParam(value = "sumupContent"	, defaultValue = "") String sumupContent,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		
		CustomResponse custResponse = new CustomResponse(true);
		
		saveMap.put("oper"				, oper);
		saveMap.put("rece_pay_amou"		, pay_amou);
		saveMap.put("context"			, context);
		saveMap.put("buyi_sequ_numb"	, buyi_sequ_numb);
		saveMap.put("none_paym_amou"	, none_paym_amou);
		saveMap.put("rece_user_id"		, userInfoDto.getUserId());
		saveMap.put("payDate"			, payDate);
		saveMap.put("rece_sequ_num" 	, rece_sequ_num);
		saveMap.put("sel_buyi_tota_amou", sel_buyi_tota_amou);
		
		saveMap.put("schedule_date" 	, schedule_date);
		saveMap.put("schedule_amou" 	, schedule_amou);
		saveMap.put("tel_user_nm" 		, tel_user_nm);
		saveMap.put("sumupContent" 		, sumupContent);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		try {
			adjustSvc.savePaymentDetail(saveMap);
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
			custResponse.setMessage("");
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}	
	
	@RequestMapping("adjustPurchasePaymentDescPop.sys")
	public ModelAndView adjustPurchasePaymentDescPop(
			@RequestParam(value = "buyi_sequ_numb"		, required = true) String buyi_sequ_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.addObject("buyi_sequ_numb", buyi_sequ_numb);
		modelAndView.setViewName("adjust/adjustPurchasePaymentDescPop");
		return modelAndView;
	}
	
	/**
	 * 매출입금내역 상세내용
	 */
	@RequestMapping("adjustPurchasePaymentDescListJQGrid.sys")
	public ModelAndView adjustPurchasePaymentDescListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "a.create_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,
			@RequestParam(value = "buyi_sequ_numb", required = true) String buyi_sequ_numb,
			@RequestParam(value = "sap_jour_numb", defaultValue = "") String sap_jour_numb,
			@RequestParam(value = "isDebt", defaultValue = "") String isDebt,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("buyi_sequ_numb"		, buyi_sequ_numb);
		params.put("sap_jour_numb"		, sap_jour_numb);
		params.put("isDebt"				, isDebt);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
        List<AdjustDto> list = adjustSvc.adjustPurchasePaymentDescList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);				
		return modelAndView;
	}
	
	/**
	 * 매입지급처리 출금즉시확인
	 */
	@RequestMapping("salesPaymentConfirm.sys")
	public ModelAndView salesPaymentConfirm(
			@RequestParam(value = "buyi_sequ_numb_Arr[]", required=true) String[] buyi_sequ_numb_Arr,
			@RequestParam(value = "clos_buyi_date_Arr[]", required=true) String[] clos_buyi_date_Arr,
			@RequestParam(value = "rece_pay_amou_Arr[]", required=true) String[] rece_pay_amou_Arr,
			@RequestParam(value = "none_paym_amou_Arr[]", required=true) String[] none_paym_amou_Arr,
			@RequestParam(value = "sap_jour_numb_Arr[]", required=true) String[] sap_jour_numb_Arr,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		CustomResponse custResponse = new CustomResponse(true);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		Map<String, Object> saveMap = new HashMap<String, Object>();

		for (int i = 0; i < buyi_sequ_numb_Arr.length; i++) {
			try {
				if(buyi_sequ_numb_Arr != null && buyi_sequ_numb_Arr.length > 0){
					saveMap.put("buyi_sequ_numb", buyi_sequ_numb_Arr[i]);	
					saveMap.put("clos_buyi_date", clos_buyi_date_Arr[i]);	
					saveMap.put("rece_pay_amou" , rece_pay_amou_Arr[i]);	
					saveMap.put("none_paym_amou", none_paym_amou_Arr[i]);	
					saveMap.put("sap_jour_numb" , sap_jour_numb_Arr[i]);	
					saveMap.put("rece_user_id"	, userInfoDto.getUserId()); // UserId
					adjustSvc.salesPaymentConfirm(saveMap);
				}
				
			} catch(Exception e) {
				logger.error("Exception : "+e);
				custResponse.setSuccess(false);
				//custResponse.setMessage("System Excute Error!....");
				custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
				custResponse.setMessage("");
			}
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;		
	}			
	
	@RequestMapping("adjustBondsTotal.sys")
	public ModelAndView adjustBondsTotal(HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("accManageUserList", commonSvc.getAccManageUserList());
		modelAndView.setViewName("adjust/adjustBondsTotal");
		return modelAndView;
	}

	/**
	 * 채권현황 상세
	 */
	@RequestMapping("adjustSalesBondsDetailPop.sys")
	public ModelAndView adjustSalesBondsDetailPop(
			@RequestParam(value = "sale_sequ_numb"		, required = true) String sale_sequ_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("sale_sequ_numb"	, sale_sequ_numb);
		paramMap.put("create_borgid"	, userInfoDto.getBorgId());
		
		AdjustDto detailInfo = adjustSvc.adjustSalesTransmissionList(paramMap, -1, -1).get(0);	// 사업장 마스터

		modelAndView.addObject("detailInfo"	, detailInfo);
		modelAndView.setViewName("adjust/adjustSalesBondsDetailPop");
		return modelAndView;
	}	
	
	
	
	/**
	 * 총 채권현황 목록
	 */
	@RequestMapping("adjustBondsTotalListJQGrid.sys")
	public ModelAndView adjustBondsTotalListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "clientNm") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcClientNm", defaultValue = "") String srcClientNm,			
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,			
			@RequestParam(value = "selectType", defaultValue = "list") String selectType,			
			@RequestParam(value = "srcAccManageUserId", defaultValue = "") String srcAccManageUserId,
			@RequestParam(value = "srcStandardYear", defaultValue = "") String srcStandardYear,
			@RequestParam(value = "srcStandardMonth", defaultValue = "") String srcStandardMonth,
			@RequestParam(value = "srcEndYear", defaultValue = "") String srcEndYear,
			@RequestParam(value = "srcEndMonth", defaultValue = "") String srcEndMonth,
			@RequestParam(value = "srcIsUse", defaultValue = "") String srcIsUse,
			@RequestParam(value = "srcIsLimitCheck", defaultValue = "srcIsLimitCheck") String srcIsLimitCheck,
			@RequestParam(value = "srcIsLimit", defaultValue = "") String srcIsLimit,
			@RequestParam(value = "srcTransferStatus", defaultValue = "") String srcTransferStatus,
			@RequestParam(value = "srcPrePay", defaultValue = "") String srcPrePay,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		String srcStartDate = srcStandardYear+srcStandardMonth;
		String srcEndDate = srcEndYear+srcEndMonth;
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcClientNm", srcClientNm);
		params.put("srcBusinessNum", srcBusinessNum);
		params.put("selectType", selectType);
		params.put("create_borgid", userInfoDto.getBorgId());
		params.put("srcAccManageUserId", srcAccManageUserId);
		params.put("srcStartDate", srcStartDate);
		params.put("srcEndDate", srcEndDate);
		params.put("srcIsUse", srcIsUse);
		params.put("srcIsLimitCheck", srcIsLimitCheck);
		params.put("srcIsLimit", srcIsLimit);
		params.put("srcTransferStatus", srcTransferStatus);
		params.put("srcPrePay", srcPrePay);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        Map<String, Object> cntMap = adjustSvc.adjustBondsTotalListCnt(params);
        int records = (int) cntMap.get("CNT");
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<AdjustDto> list = null;
        if(records>0) list = adjustSvc.adjustBondsTotalList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		
		modelAndView.addObject("userdata", cntMap);
		
		return modelAndView;
	}
	
	/**
	 * 총 채권현황 목록 엑셀다운로드
	 */
	@RequestMapping("adjustBondsTotalListExcel.sys")
	public ModelAndView adjustBondsTotalListExcel(
			@RequestParam(value = "sidx", defaultValue = "CLOS_SALE_DATE") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcClientNm", defaultValue = "") String srcClientNm,			
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,			
			@RequestParam(value = "selectType", defaultValue = "list") String selectType,			
			@RequestParam(value = "srcAccManageUserId", defaultValue = "") String srcAccManageUserId,
			
			@RequestParam(value = "srcStandardYear", defaultValue = "") String srcStandardYear,
			@RequestParam(value = "srcStandardMonth", defaultValue = "") String srcStandardMonth,
			@RequestParam(value = "srcEndYear", defaultValue = "") String srcEndYear,
			@RequestParam(value = "srcEndMonth", defaultValue = "") String srcEndMonth,
			@RequestParam(value = "srcIsUse", defaultValue = "") String srcIsUse,
			@RequestParam(value = "srcIsLimitCheck", defaultValue = "srcIsLimitCheck") String srcIsLimitCheck,
			@RequestParam(value = "srcIsLimit", defaultValue = "") String srcIsLimit,
			@RequestParam(value = "srcTransferStatus", defaultValue = "") String srcTransferStatus,

			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		String srcStartDate = srcStandardYear+srcStandardMonth;
		String srcEndDate = srcEndYear+srcEndMonth;
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcClientNm"	, srcClientNm);
		params.put("srcBusinessNum"	, srcBusinessNum);
		params.put("selectType"		, selectType);
		params.put("create_borgid"	, userInfoDto.getBorgId());
		params.put("srcAccManageUserId"	, srcAccManageUserId);
		
		params.put("srcStartDate", srcStartDate);
		params.put("srcEndDate", srcEndDate);
		params.put("srcIsUse", srcIsUse);
		params.put("srcIsLimitCheck", srcIsLimitCheck);
		params.put("srcIsLimit", srcIsLimit);
		params.put("srcTransferStatus", srcTransferStatus);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------조회------------*/
		List<AdjustDto> list = adjustSvc.adjustBondsTotalList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("clientNm", list.get(i).getClientNm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("pressentNm", list.get(i).getPressentNm());
				rtnData.put("sale_tota_amou", list.get(i).getSale_tota_amou());
				rtnData.put("rece_pay_amou", list.get(i).getRece_pay_amou());
				rtnData.put("balance_amou", list.get(i).getBalance_amou());
				rtnData.put("avg_day", list.get(i).getAvg_day());
				rtnData.put("creat_date", list.get(i).getCreat_date());
				rtnData.put("isLimitStr", list.get(i).getIsLimitStr());
				rtnData.put("userNm", list.get(i).getUserNm());
				rtnData.put("isUse", list.get(i).getIsUse());
				rtnData.put("transfer_status", list.get(i).getTransfer_status());
				rtnData.put("firstCreatDate", list.get(i).getFirst_creat_date());
				rtnData.put("sale_over_day", list.get(i).getSale_over_day());
				colDataList.add(rtnData);
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
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;	
	}
	/**
	 * 업체별 채권현황 
	 */
	@RequestMapping("adjustBondsCompany.sys")
	public ModelAndView adjustBondsCompany(
			@RequestParam(value = "clientId", required=true) String clientId,
			@RequestParam(value = "selectType", defaultValue="detail") String selectType,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		//업체정보
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("clientId"		, clientId);
		params.put("selectType"		, selectType);
		params.put("create_borgid"	, userInfoDto.getBorgId());
		AdjustDto detailInfo = adjustSvc.adjustBondsTotalList(params, -1, -1).get(0);
		AdjustDto priceInfo  = adjustSvc.adjustBondsCompanyPriceInfo(params);
		
		modelAndView.addObject("detailInfo", detailInfo);
		modelAndView.addObject("priceInfo" , priceInfo);
		modelAndView.addObject("bondType"  , commonSvc.getCodeList("BOND_MANAGE_TYPE", 1));
		modelAndView.setViewName("adjust/adjustBondsCompany");
		return modelAndView;
	}
	
	/**
	 * 업체별 채권현황 목록
	 */
	@RequestMapping("adjustBondsCompanyListJQGrid.sys")
	public ModelAndView adjustBondsCompanyListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "clos_sale_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,			
			@RequestParam(value = "clientId", required=true) String clientId,			
			@RequestParam(value = "srcPayStat", defaultValue="") String srcPayStat,			
			@RequestParam(value = "srcTranStat", defaultValue="") String srcTranStat,			
			@RequestParam(value = "srcClosStartYear", defaultValue="") String srcClosStartYear,			
			@RequestParam(value = "srcClosStartMonth", defaultValue="") String srcClosStartMonth,			
			@RequestParam(value = "srcClosEndYear", defaultValue="") String srcClosEndYear,			
			@RequestParam(value = "srcClosEndMonth", defaultValue="") String srcClosEndMonth,			
			@RequestParam(value = "srcBranchId", defaultValue="") String srcBranchId,			
			@RequestParam(value = "srcTransferStatus", defaultValue="") String srcTransferStatus,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		String preZero = "";
		
		params.put("clientId"			, clientId);
		params.put("srcPayStat"			, srcPayStat);
		params.put("srcTranStat"		, srcTranStat);
		params.put("create_borgid"		, userInfoDto.getBorgId());
		params.put("srcBranchId"		, srcBranchId);
		params.put("srcTransferStatus", srcTransferStatus);

		if(srcClosStartMonth.length() == 1) preZero = "0";
		params.put("srcClosStartDate"	, srcClosStartYear + preZero + srcClosStartMonth);
		preZero = "";
		if(srcClosEndMonth.length() == 1) preZero = "0";
		params.put("srcClosEndDate"		, srcClosEndYear + preZero + srcClosEndMonth);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		logger.debug("clientId : "+clientId);
		logger.debug("srcPayStat : "+srcPayStat);
		logger.debug("srcTranStat : "+srcTranStat);
		logger.debug("create_borgid : "+userInfoDto.getBorgId());
		logger.debug("srcBranchId : "+srcBranchId);
		logger.debug("srcTransferStatus : "+srcTransferStatus);
		
        /*----------------조회------------*/
        List<AdjustDto> list = adjustSvc.adjustBondsCompanyList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 주문제한 업데이트 
	 */
	@RequestMapping("updateSmpBorgsIsLimit.sys")
	public ModelAndView updateSmpBorgsIsLimit(
			@RequestParam(value = "clientId", required=true)String clientId,
			@RequestParam(value = "isLimit"	, required=true)String isLimit,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		HashMap<String, Object> saveMap = new HashMap<String, Object>();
		
		saveMap.put("clientId"	, clientId);
		saveMap.put("isLimit"	, isLimit);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			adjustSvc.updateSmpBorgsIsLimit(saveMap);
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
	
	@RequestMapping("adjustBondsOccurrence.sys")
	public ModelAndView adjustBondsOccurrence(
			@RequestParam(value = "clientId", required=true) String clientId,
			@RequestParam(value = "selectType", defaultValue="detail") String selectType,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		//업체정보
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("clientId"		, clientId);
		params.put("selectType"		, selectType);
		params.put("create_borgid"	, userInfoDto.getBorgId());
		AdjustDto detailInfo = adjustSvc.adjustBondsTotalList(params, -1, -1).get(0);
		AdjustDto priceInfo  = adjustSvc.adjustBondsCompanyPriceInfo(params);
		logger.debug("userInfoDto : "+userInfoDto);
		modelAndView.addObject("detailInfo", detailInfo);
		modelAndView.addObject("priceInfo", priceInfo);
		modelAndView.addObject("branchList"	, adjustSvc.selectBranchsByClientId(clientId));
		modelAndView.addObject("bondType"  , commonSvc.getCodeList("BOND_MANAGE_TYPE", 1));
		modelAndView.setViewName("adjust/adjustBondsOccurrence");
		return modelAndView;
	}
	
	@RequestMapping("adjustDebtTotal.sys")
	public ModelAndView adjustDebtTotal(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustDebtTotal");
	}
	
	/**
	 * 총 채무현황 목록
	 */
	@RequestMapping("adjustDebtTotalListJQGrid.sys")
	public ModelAndView adjustDebtTotalListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "clientNm") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,			
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,			
			@RequestParam(value = "selectType", defaultValue = "list") String selectType,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorNm"	, srcVendorNm);
		params.put("srcBusinessNum"	, srcBusinessNum);
		params.put("selectType"		, selectType);
		params.put("create_borgid"	, userInfoDto.getBorgId());

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = adjustSvc.adjustDebtTotalListCnt(params);
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<AdjustDto> list = null;
        if(records>0) list = adjustSvc.adjustDebtTotalList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}	

	/**
	 * 총 채무현황 목록 엑셀다운로드
	 */
	@RequestMapping("adjustDebtTotalListExcel.sys")
	public ModelAndView adjustDebtTotalListExcel(
			@RequestParam(value = "sidx", defaultValue = "clos_buyi_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,			
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,			
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,			
			@RequestParam(value = "selectType", defaultValue = "list") String selectType,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorNm"	, srcVendorNm);
		params.put("srcBusinessNum"	, srcBusinessNum);
		params.put("selectType"		, selectType);
		params.put("create_borgid"	, userInfoDto.getBorgId());
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<AdjustDto> list = adjustSvc.adjustDebtTotalList(params, 1, RowBounds.NO_ROW_LIMIT);
		
		List<Map<String, Object>> colDataList = null;
		if(list != null && list.size() > 0){
			Map<String, Object> rtnData = null;
			colDataList = new ArrayList<Map<String, Object>>();
			for(int i = 0; i < list.size() ; i++){
				rtnData = new HashMap<String, Object>();
				rtnData.put("vendorNm", list.get(i).getVendorNm());
				rtnData.put("businessNum", list.get(i).getBusinessNum());
				rtnData.put("pressentNm", list.get(i).getPressentNm());
				rtnData.put("buyi_tota_amou", list.get(i).getBuyi_tota_amou());
				rtnData.put("rece_pay_amou", list.get(i).getRece_pay_amou());
				rtnData.put("balance_amou", list.get(i).getBalance_amou());
				rtnData.put("avg_day", list.get(i).getAvg_day());
				rtnData.put("creat_date", list.get(i).getCreat_date());
				colDataList.add(rtnData);
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
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;			
	}	
	
	@RequestMapping("adjustDebtCompany.sys")
	public ModelAndView adjustDebtCompany(
			@RequestParam(value = "vendorId", required=true) String vendorId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		//업체정보
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("vendorId"		, vendorId);
		params.put("create_borgid"	, userInfoDto.getBorgId());		
		AdjustDto detailInfo = adjustSvc.adjustDebtTotalList(params, -1, -1).get(0);
		modelAndView.addObject("detailInfo", detailInfo);
		modelAndView.setViewName("adjust/adjustDebtCompany");
		return modelAndView; 
	}

	
	/**
	 * 업체별 채권현황 목록
	 */
	@RequestMapping("adjustDebtCompanyListJQGrid.sys")
	public ModelAndView adjustDebtCompanyListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "clos_buyi_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,			
			@RequestParam(value = "vendorId", required=true) String vendorId,			
			@RequestParam(value = "srcPayStat", defaultValue="") String srcPayStat,			
			@RequestParam(value = "srcTranStat", defaultValue="") String srcTranStat,			
			@RequestParam(value = "srcClosStartYear", defaultValue="") String srcClosStartYear,			
			@RequestParam(value = "srcClosStartMonth", defaultValue="") String srcClosStartMonth,			
			@RequestParam(value = "srcClosEndYear", defaultValue="") String srcClosEndYear,			
			@RequestParam(value = "srcClosEndMonth", defaultValue="") String srcClosEndMonth,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		String preZero = "";
		
		params.put("vendorId"			, vendorId);
		params.put("srcPayStat"			, srcPayStat);
		params.put("srcTranStat"		, srcTranStat);
		params.put("create_borgid"		, userInfoDto.getBorgId());

		if(srcClosStartMonth.length() == 1) preZero = "0";
		params.put("srcClosStartDate"	, srcClosStartYear + preZero + srcClosStartMonth);
		preZero = "";
		if(srcClosEndMonth.length() == 1) preZero = "0";
		params.put("srcClosEndDate"		, srcClosEndYear + preZero + srcClosEndMonth);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
        List<AdjustDto> list = adjustSvc.adjustDebtCompanyList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}		
	
	@RequestMapping("adjustDebtOccurrence.sys")
	public ModelAndView adjustDebtOccurrence(
			@RequestParam(value = "vendorId", required=true) String vendorId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		//업체정보
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("vendorId"		, vendorId);
		params.put("create_borgid"	, userInfoDto.getBorgId());
		AdjustDto detailInfo = adjustSvc.adjustDebtTotalList(params, -1, -1).get(0);
		
		modelAndView.addObject("detailInfo", detailInfo);
		modelAndView.setViewName("adjust/adjustDebtOccurrence");
		return modelAndView;
	}	

	@RequestMapping("adjustBondsTotalStdMonthExcel.sys")
	public ModelAndView adjustBondsTotalStdMonthExcel(
			@RequestParam(value = "stdYear", required=true) String stdYear,
			@RequestParam(value = "stdMonth", required=true) String stdMonth,
			@RequestParam(value = "selMon", required=true) String selMon,
			@RequestParam(value = "srcAccManageUserId", required=true) String srcAccManageUserId,
			@RequestParam(value = "srcBusinessNum", required=true) String srcBusinessNum,
			@RequestParam(value = "srcStdMonthStandard", defaultValue="") String srcStdMonthStandard,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,	

			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("stdDate", stdYear + stdMonth);
		params.put("srcAccManageUserId", srcAccManageUserId);
		params.put("srcBusinessNum", srcBusinessNum);
		logger.debug("srcStdMonthStandard : "+srcStdMonthStandard);
		List<Map<String, Object>> colDataList = null;
		if("0".equals(srcStdMonthStandard)){
			if("3".equals(selMon)){
				colDataList = adjustSvc.adjustBondsTotalStdMonthExcel3Month(params);
			}else if("30".equals(selMon)){
				colDataList = adjustSvc.adjustBondsTotalStdMonthExcel30Month(params);
			}else if("6".equals(selMon)){
				colDataList = adjustSvc.adjustBondsTotalStdMonthExcel6Month(params);
			}else if("12".equals(selMon)){
				colDataList = adjustSvc.adjustBondsTotalStdMonthExcel12Month(params);
			}
		}else{
			if("3".equals(selMon)){
				colDataList = adjustSvc.adjustBondsTotalStdMonthExcel3MonthClient(params);
			}else if("6".equals(selMon)){
				colDataList = adjustSvc.adjustBondsTotalStdMonthExcel6MonthClient(params);
			}else if("12".equals(selMon)){
				colDataList = adjustSvc.adjustBondsTotalStdMonthExcel12MonthClient(params);
			}else if("30".equals(selMon)){
				colDataList = adjustSvc.adjustBondsTotalStdMonthExcel30MonthClient(params);
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
		
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", colDataList);
//		modelAndView.setViewName("commonExcelViewResolver");
		return modelAndView;		
	}
	
	
	/**
	 * 매출부분취소
	 */
	@RequestMapping("salesConfirmPartCancel.sys")
	public ModelAndView salesConfirmPartCancel(
			@RequestParam(value = "orde_iden_numb_Arr[]", required=true)String [] orde_iden_numb_Arr,
			@RequestParam(value = "orde_sequ_numb_Arr[]", required=true)String [] orde_sequ_numb_Arr,
			@RequestParam(value = "purc_iden_numb_Arr[]", required=true)String [] purc_iden_numb_Arr,
			@RequestParam(value = "deli_iden_numb_Arr[]", required=true)String [] deli_iden_numb_Arr,
			@RequestParam(value = "rece_iden_numb_Arr[]", required=true)String [] rece_iden_numb_Arr,
			@RequestParam(value = "sale_sequ_numb", required=true)String sale_sequ_numb,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("sale_sequ_numb", sale_sequ_numb);
		saveMap.put("orde_iden_numb_Arr", orde_iden_numb_Arr);
		saveMap.put("orde_sequ_numb_Arr", orde_sequ_numb_Arr);
		saveMap.put("purc_iden_numb_Arr", purc_iden_numb_Arr);
		saveMap.put("deli_iden_numb_Arr", deli_iden_numb_Arr);
		saveMap.put("rece_iden_numb_Arr", rece_iden_numb_Arr);
		
		/*------------------------매출확정부분취소 적합성 검사-----------------------------*/
		int incNum = 0;
		String whereString = "";
		whereString += "			from		mrordtlist a ";
		whereString += "			inner join mssalm b ";
		whereString += "				on		a.sale_sequ_numb = b.sale_sequ_numb ";
		whereString += "				and	b.sap_jour_numb is null ";
		whereString += "			where		a.sale_sequ_numb = '"+sale_sequ_numb+"' ";
		whereString += "			and		a.buyi_sequ_numb is null ";
		whereString += "			and		";
		whereString += "			( 		";
		for(String orde_iden_numb : orde_iden_numb_Arr) {
			if(incNum!=0) whereString += " 	or ";
			whereString += " 					( ";
			whereString += " 								a.orde_iden_numb = '"+orde_iden_numb+"' ";
			whereString += " 					and		a.orde_sequ_numb = '"+orde_sequ_numb_Arr[incNum]+"' ";
			whereString += " 					and		a.purc_iden_numb = '"+purc_iden_numb_Arr[incNum]+"' ";
			whereString += " 					and		a.deli_iden_numb = '"+deli_iden_numb_Arr[incNum]+"' ";
			whereString += " 					and		a.rece_iden_numb = '"+rece_iden_numb_Arr[incNum]+"' ";
			whereString += " 					) ";
			incNum++;
		}
		whereString += "			) 		";
		logger.info("매출부분취소 whereString : "+whereString);
		int canValCnt = adjustDao.selectAdjustCancelValidationCnt(whereString);
		/*-----------------------------------------------------------------------------------------*/
		
		if(canValCnt != incNum) {
			logger.info("매출부분취소 정보중 매입이 확정된 정보가 있거나 상태가 맞지 않는 정보가 존재합니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
			custResponse.setSuccess(false);
			custResponse.setMessage("매출부분취소 정보중 매입이 확정된 정보가 있거나 상태가 맞지 않는 정보가 존재합니다.<br/>다시 처리할 수 있도록 리로드 하겠습니다.");
		} else {
			try  {
				adjustSvc.modSalesConfirmPartCancel(sale_sequ_numb, whereString);
			} catch(Exception e){
				custResponse.setSuccess(false);
				custResponse.setMessage("System Excute Error!....");
			}
		}
		mav.addObject(custResponse);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping("adjustBorgDialog.sys")
	public ModelAndView adjustBorgDialog (
			@RequestParam(value="page", defaultValue="1")int page,
			@RequestParam(value="rows", defaultValue="10")int rows,
			@RequestParam(value="sidx", defaultValue="borgNms")String sidx,
			@RequestParam(value="sord", defaultValue="asc")String sord,
			@RequestParam(value="userId", defaultValue="")String userId,
			
			@RequestParam(value="srcBorgType", defaultValue="")String srcBorgType,
			@RequestParam(value="srcBorgNm", defaultValue="")String srcBorgNm,
			@RequestParam(value="srcClientId", defaultValue="")String srcClientId,
			@RequestParam(value = "multiSelYN", defaultValue = "") String multiSelYN,
			@RequestParam(value = "isWork", defaultValue = "") String isWork,
			@RequestParam(value = "isAcc", defaultValue = "") String isAcc,
			@RequestParam(value = "srcWork", defaultValue = "") String srcWork,
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		/*------------------조회조건 세팅------------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("srcBorgTypeCd", srcBorgType);
		params.put("srcBorgNm", srcBorgNm);
		params.put("srcClientId", srcClientId);
		params.put("multiSelYN", multiSelYN);
		params.put("isWork", isWork);
		params.put("isAcc", isAcc);
		params.put("srcWork", srcWork);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
//		CustomResponse custResponse = new CustomResponse();
		/*----------------페이징 세팅------------*/
		int records = adjustSvc.adjustBorgDialogListCnt(params);
		int total = (int)Math.ceil((float)records / (float)rows);
		
		/*-----------------조회------------------*/
		List<BorgDto> list = null;
		if(records > 0){
			list = adjustSvc.adjustBorgDialogList(params, page, rows);
		}
		mav = new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	/**
	 * 업체별현황 리스트에서 정상이면 만기일 변경가능
	 */
	@RequestMapping("modExpirationDate.sys")
	public ModelAndView modExpirationDate(
			@RequestParam(value="sale_sequ_numb_Arr[]", defaultValue="")String sale_sequ_numb_Arr[],
			@RequestParam(value="expiration_date_Arr[]", defaultValue="")String expiration_date_Arr[],
			HttpServletRequest request, ModelAndView mav) throws Exception{
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("sale_sequ_numb_Arr", sale_sequ_numb_Arr);
		saveMap.put("expiration_date_Arr", expiration_date_Arr);
		try{
			adjustSvc.modExpirationDate(saveMap);
		}catch(Exception e){
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		mav = new ModelAndView("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	
	/**
	 * 이관여부 항목 변경
	 */
	@RequestMapping("transferStatusChange.sys")
	public ModelAndView transferStatusChange(
			@RequestParam(value="sale_sequ_numb_Arr[]", defaultValue="")String sale_sequ_numb_Arr[],
			@RequestParam(value="transfer_status_Arr[]", defaultValue="")String transfer_status_Arr[],
			HttpServletRequest request, ModelAndView mav) throws Exception{
		CustomResponse custResponse = new CustomResponse(true);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("sale_sequ_numb_Arr", sale_sequ_numb_Arr);
		saveMap.put("transfer_status_Arr", transfer_status_Arr);
		try{
			adjustSvc.transferStatusChange(saveMap);
		}catch(Exception e){
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		mav = new ModelAndView("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	
	/**
	 * 고객사 채무관리 페이지
	 */
	@RequestMapping("adjustBranchsBondsOccurrence.sys")
	public ModelAndView adjustBranchsBondsOccurrence (
			HttpServletRequest request, ModelAndView mav) throws Exception{
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		mav.addObject("branchList"	, adjustSvc.selectBranchsByClientId(userInfoDto.getClientId()));
		mav.setViewName("adjust/adjustBranchsBondsOccurrence");
		return mav;
	}
	
	/**
	 * 고객사 채무관리 페이지 JQGrid
	 */
	@RequestMapping("adjustBranchBondsCompanyListJQGrid.sys")
	public ModelAndView adjustBranchBondsCompanyListJQGrid (
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "clos_sale_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,			
			@RequestParam(value = "clientId", required=true) String clientId,			
			@RequestParam(value = "srcPayStat", defaultValue="") String srcPayStat,			
			@RequestParam(value = "srcTranStat", defaultValue="") String srcTranStat,			
			@RequestParam(value = "srcClosStartYear", defaultValue="") String srcClosStartYear,			
			@RequestParam(value = "srcClosStartMonth", defaultValue="") String srcClosStartMonth,			
			@RequestParam(value = "srcClosEndYear", defaultValue="") String srcClosEndYear,			
			@RequestParam(value = "srcClosEndMonth", defaultValue="") String srcClosEndMonth,			
			@RequestParam(value = "srcBranchId", defaultValue="") String srcBranchId,			
			@RequestParam(value = "srcTransferStatus", defaultValue="") String srcTransferStatus,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		String preZero = "";
		
		params.put("clientId"			, clientId);
		params.put("srcPayStat"			, srcPayStat);
		params.put("srcTranStat"		, srcTranStat);
		params.put("srcBranchId"		, srcBranchId);
		params.put("srcTransferStatus", srcTransferStatus);

		if(srcClosStartMonth.length() == 1) preZero = "0";
		params.put("srcClosStartDate"	, srcClosStartYear + preZero + srcClosStartMonth);
		preZero = "";
		if(srcClosEndMonth.length() == 1) preZero = "0";
		params.put("srcClosEndDate"		, srcClosEndYear + preZero + srcClosEndMonth);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
        List<AdjustDto> list = adjustSvc.adjustBranchBondsCompanyList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공급사 채무관련 페이지 호출
	 */
	@RequestMapping("adjustVenDebtOccurrence.sys")
	public ModelAndView adjustVenDebtOccurrence(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		modelAndView.setViewName("adjust/adjustVenDebtOccurrence");
		return modelAndView;
	}
	
	/**
	 * 공급사 채무관련 
	 */
	@RequestMapping("adjustVenDebtCompanyListJQGrid.sys")
	public ModelAndView adjustVenDebtCompanyListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "clos_buyi_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "asc") String sord,			
			@RequestParam(value = "vendorId", required=true) String vendorId,			
			@RequestParam(value = "srcPayStat", defaultValue="") String srcPayStat,			
			@RequestParam(value = "srcTranStat", defaultValue="") String srcTranStat,			
			@RequestParam(value = "srcClosStartYear", defaultValue="") String srcClosStartYear,			
			@RequestParam(value = "srcClosStartMonth", defaultValue="") String srcClosStartMonth,			
			@RequestParam(value = "srcClosEndYear", defaultValue="") String srcClosEndYear,			
			@RequestParam(value = "srcClosEndMonth", defaultValue="") String srcClosEndMonth,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		String preZero = "";
		
		params.put("vendorId"			, vendorId);
		params.put("srcPayStat"			, srcPayStat);
		params.put("srcTranStat"		, srcTranStat);

		if(srcClosStartMonth.length() == 1) preZero = "0";
		params.put("srcClosStartDate"	, srcClosStartYear + preZero + srcClosStartMonth);
		preZero = "";
		if(srcClosEndMonth.length() == 1) preZero = "0";
		params.put("srcClosEndDate"		, srcClosEndYear + preZero + srcClosEndMonth);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
        List<AdjustDto> list = adjustSvc.adjustVenDebtCompanyList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 매입확정상세 매입확정상세 JQGrid
	 */
	@RequestMapping("adjustVenPurcConfirmDetailListJQGrid.sys")
	public ModelAndView adjustVenPurcConfirmDetailListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "A.BUYI_SEQU_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,						
			@RequestParam(value = "sale_sequ_numb"	, defaultValue = "") String sale_sequ_numb,
			@RequestParam(value = "buyi_sequ_numb"	, defaultValue = "") String buyi_sequ_numb,
			@RequestParam(value = "vendorId"	, defaultValue = "") String vendorId,
			@RequestParam(value = "srcPurcStatus"	, defaultValue = "") String srcPurcStatus,
			@RequestParam(value = "srcOrdeNumb"	, defaultValue = "") String srcOrdeNumb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sale_sequ_numb"	, sale_sequ_numb);
		params.put("buyi_sequ_numb"	, buyi_sequ_numb);
		params.put("vendorId"		, vendorId);
		params.put("srcPurcStatus"	, srcPurcStatus);
		params.put("create_borgid"	, userInfoDto.getBorgId());
		params.put("srcOrdeNumb"	, srcOrdeNumb);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
		List<AdjustDto> list = adjustSvc.adjusVentPurcConfirmDetailList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
		
	/**
	 * 매출반제 현황 상세반제 내역(입금일자) Excel 출력
	 */
	//adjustSalesTransmissionListForExcel
	@RequestMapping("adjustSalesTransmissionPayDateListForExcel.sys")
	public ModelAndView adjustSalesTransmissionPayDateListForExcel(
			@RequestParam(value = "sidx", defaultValue = "a.sale_sequ_numb") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,
			@RequestParam(value = "srcSalesName", defaultValue = "") String srcSalesName,//정산명
			@RequestParam(value = "srcTransStatus", defaultValue = "") String srcTransStatus,//
//			@RequestParam(value = "srcSalesTransStartDate", defaultValue = "") String srcSalesTransStartDate,//입금일자
//			@RequestParam(value = "srcSalesTransEndDate", defaultValue = "") String srcSalesTransEndDate,//입금일자
			@RequestParam(value = "srcStartDate", defaultValue = "") String srcStartDate,//입금일자
			@RequestParam(value = "srcEndDate", defaultValue = "") String srcEndDate,//입금일자
			@RequestParam(value = "srcClientNm", defaultValue = "") String srcClientNm,//
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			@RequestParam(value = "dateCalc", defaultValue ="") String srcDateCalc,
			ModelAndView mav, HttpServletRequest request) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)request.getSession().getAttribute(Constances.SESSION_NAME);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSalesName"			, srcSalesName);
		params.put("srcTransStatus"			, srcTransStatus);
//		params.put("srcSalesTransStartDate"	, srcSalesTransStartDate);
//		params.put("srcSalesTransEndDate"	, srcSalesTransEndDate);
		params.put("srcStartDate", srcStartDate);
		params.put("srcEndDate", srcEndDate);
		params.put("srcClientNm"			, srcClientNm);
		params.put("srcBusinessNum"			, srcBusinessNum);
		params.put("create_borgid"			, userInfoDto.getBorgId());
		params.put("srcDateCalc", srcDateCalc);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<Map<String, Object>> colDataList = adjustSvc.adjustSalesTransmissionPayDateListForExcel(params);
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", colDataList);
        sheetList.add(map1);
        mav.setViewName("commonExcelViewResolver");
        mav.addObject("excelFileName", excelFileName);
        mav.addObject("sheetList", sheetList);
		
//		mav.addObject("sheetTitle", sheetTitle);
//		mav.addObject("excelFileName", excelFileName);
//		mav.addObject("colLabels", colLabels);
//		mav.addObject("colIds", colIds);
//		mav.addObject("numColIds", numColIds);
//		mav.addObject("figureColIds", figureColIds);
//		mav.addObject("colDataList", colDataList);
//		mav.setViewName("commonExcelViewResolver");
		return mav;
	}
	
	@RequestMapping("etcExpirationDateSave.sys")
	public ModelAndView etcExpirationDateSave(
			@RequestParam(value="buyiSequNumbArray[]" ,defaultValue="")String[] buyiSequNumbArray,
			@RequestParam(value="etcExpirationDateArray[]" ,defaultValue="")String[] etcExpirationDateArray,
			ModelAndView mav, HttpServletRequest request) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("buyiSequNumbArray", buyiSequNumbArray);
		saveMap.put("etcExpirationDateArray", etcExpirationDateArray);

		try{
			adjustSvc.etcExpirationDateSave(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		mav.setViewName("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	

	/**
	 * 매입부분취소
	 * @param ordeIdenNumbArray 주문번호
	 * @param ordeSequNumbArray 주문차수
	 * @param purcIdenNumbArray 발주차수
	 * @param deliIdenNumbArray 출하차수
	 * @param receIdenNumbArray 인수차수
	 * @param buyiSequNumb 인수리스트의 매입아이디
	 */
	@RequestMapping("purchaseConfirmPartCancel.sys")
	public ModelAndView purchaseConfirmPartCancel(
			@RequestParam(value="ordeIdenNumbArray[]", required=true)String[] ordeIdenNumbArray,
			@RequestParam(value="ordeSequNumbArray[]", required=true)String[] ordeSequNumbArray,
			@RequestParam(value="purcIdenNumbArray[]", required=true)String[] purcIdenNumbArray,
			@RequestParam(value="deliIdenNumbArray[]", required=true)String[] deliIdenNumbArray,
			@RequestParam(value="receIdenNumbArray[]", required=true)String[] receIdenNumbArray,
			@RequestParam(value="buyiSequNumb", required=true)String buyiSequNumb,
			ModelAndView mav, HttpServletRequest request) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("ordeIdenNumbArray", ordeIdenNumbArray);
		saveMap.put("ordeSequNumbArray", ordeSequNumbArray);
		saveMap.put("purcIdenNumbArray", purcIdenNumbArray);
		saveMap.put("deliIdenNumbArray", deliIdenNumbArray);
		saveMap.put("receIdenNumbArray", receIdenNumbArray);
		saveMap.put("buyiSequNumb", buyiSequNumb);

		try{
			adjustSvc.purchaseConfirmPartCancel(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		mav.addObject(custResponse);
		mav.setViewName("jsonView");
		return mav;
	}
	
	@RequestMapping("selectSumupContent.sys")
	public ModelAndView selectSumupContent (
			@RequestParam(value="buyiSequNumb", required=true)String buyiSequNumb,
			ModelAndView mav, HttpServletRequest request) throws Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("buyiSequNumb", buyiSequNumb);
		Map<String, Object> sumupContent = adjustSvc.selectSumupContent(params);
		mav.addObject("sumupContent", sumupContent);
		mav.setViewName("jsonView");
		return mav;
	}
	
	
	/**
	 * 매출반제/입금현황 등록
	 */
	@RequestMapping("updateReceSaleStatus.sys")
	public ModelAndView updateReceSaleStatus(
				@RequestParam(value="receSequNumArray[]", required=true)String[] receSequNumArray,
				@RequestParam(value="receSaleStatusArray[]", required=true)String[] receSaleStatusArray,
				ModelAndView mav, HttpServletRequest request) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("receSequNumArray", receSequNumArray);
		saveMap.put("receSaleStatusArray", receSaleStatusArray);
		try{
			adjustSvc.updateReceSaleStatus(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		
		mav.setViewName("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	
	
	/**
	 * ====================================================== 고도화 Start ====================================================== 
	 */
	
	@RequestMapping("adjustBondsSummary.sys")
	public ModelAndView adjustBondsSummary(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		return new ModelAndView("adjust/adjustBondsSummary");
	}	
	
	@RequestMapping("adjustBondsPlan.sys")
	public ModelAndView adjustBondsPlan(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("contractSpecialList" , commonSvc.getCodeList("CONTRACT_SPECIAL", 1));
		modelAndView.setViewName("adjust/adjustBondsPlan");
		return modelAndView;
	}
	
	
	@RequestMapping("adjustBondsPlanListJQGrid.sys")
	public ModelAndView adjustBondsPlanListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "15") int rows,
			@RequestParam(value = "srcDate"				, defaultValue = "") String srcDate,
			@RequestParam(value = "srcBranchNm"			, defaultValue = "") String srcBranchNm,
			@RequestParam(value = "srcBondType"			, defaultValue = "") String srcBondType,
			@RequestParam(value = "srcContractSpecial"	, defaultValue = "") String srcContractSpecial,
			ModelAndView modelAndView, HttpServletRequest request, ModelMap paramMap) throws Exception {
//		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Calendar setDate = Calendar.getInstance();
		int toDay 	= Integer.parseInt(new SimpleDateFormat("yyyyMM").format(setDate.getTime()));
		int inDate	= Integer.parseInt(srcDate);
		if(toDay > inDate)	paramMap.put("srcDateType", "prev");
		else				paramMap.put("srcDateType", "now");
		
		paramMap.put("srcDate"			, srcDate);
		paramMap.put("srcContractSpecial"	, srcContractSpecial);
		paramMap.put("srcBranchNm"		, srcBranchNm);
		paramMap.put("srcBondType"		, srcBondType);

//		int records = adjustSvc.adjustBondsPlanListCnt(paramMap);
		Map<String,Object> userData = adjustSvc.adjustBondsPlanListMap(paramMap);
		System.out.println("jameskang userData : "+userData);
		int records = (int) userData.get("RECORDS");
		int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
		List<Map<String, String>> list = null;
		if(records>0) {
			list = adjustSvc.adjustBondsPlanList(paramMap, page, rows);
		}

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		modelAndView.addObject("userData", userData);
		return modelAndView;
	}
	@RequestMapping("adjustBondsPlanListJQGridExcel.sys")
	public ModelAndView adjustBondsPlanListJQGridExcel(
			@RequestParam(value = "srcYear", defaultValue = "") String srcYear,
			@RequestParam(value = "srcMonth", defaultValue = "") String srcMonth,
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request, ModelMap paramMap) throws Exception {
		
		Calendar setDate = Calendar.getInstance();
		int toDay 	= Integer.parseInt(new SimpleDateFormat("yyyyMM").format(setDate.getTime()));
		int inDate	= Integer.parseInt(srcYear+srcMonth);
		if(toDay > inDate)	paramMap.put("srcDateType", "prev");
		else				paramMap.put("srcDateType", "now");
		paramMap.put("srcDate", srcYear+srcMonth);
		paramMap.put("isExcel", 1);	//Query에서 상태값을 Case처리하기 위함
		List<Map<String, String>> list = adjustSvc.adjustBondsPlanList(paramMap, RowBounds.NO_ROW_OFFSET, RowBounds.NO_ROW_LIMIT);
		
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
		
//		modelAndView.setViewName("commonExcelViewResolver");
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", list);
		return modelAndView;
	}
	
	@RequestMapping("bondsTypeDetailJQGrid.sys")
	public ModelAndView bondsTypeDetailJQGrid(
			@RequestParam(value = "sidx"				, defaultValue = "A.CLOS_SALE_DATE") String sidx,
			@RequestParam(value = "sord"				, defaultValue = "DESC") String sord,						
			@RequestParam(value = "stdyyyymm"			, defaultValue = "") String stdyyyymm,
			@RequestParam(value = "bondsType"			, defaultValue = "") String bondsType,
			@RequestParam(value = "contType"			, defaultValue = "") String contType,
			@RequestParam(value = "page"				, defaultValue = "1") int page,
			@RequestParam(value = "rows"				, defaultValue = "30") int rows,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("stdyyyymm"	, stdyyyymm);
		params.put("bondsType"	, bondsType);
		params.put("contType"	, contType);
		
		/*----------------페이징 세팅------------*/
        int records = adjustSvc.adjustBondsTypeDetailCnt(params);
        int total = (int)Math.ceil((float)records / (float)rows);		
		
        /*----------------조회------------*/
        List<Map<String, String>> list = null;
        if(records>0) list = adjustSvc.adjustBondsTypeDetail(params, page, rows);		
		
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}		
	@RequestMapping("bondsTypeDetailJQGridExcel.sys")
	public ModelAndView bondsTypeDetailJQGridExcel(				
			@RequestParam(value = "stdyyyymm", defaultValue = "") String stdyyyymm,
			@RequestParam(value = "bondsType", defaultValue = "") String bondsType,
			@RequestParam(value = "contType", defaultValue = "") String contType,
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("stdyyyymm"	, stdyyyymm);
		params.put("bondsType"	, bondsType);
		params.put("contType"	, contType);
		
        /*----------------조회------------*/
        List<Map<String, String>> list = adjustSvc.adjustBondsTypeDetail(params, 0, 0);		
		
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
        
//		modelAndView.setViewName("commonExcelViewResolver");
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", list);		
		return modelAndView;
	}		
	
	@RequestMapping("bondsMonthDetailJQGrid.sys")
	public ModelAndView bondsMonthDetailJQGrid(
			@RequestParam(value = "sidx"				, defaultValue = "A.CLOS_SALE_DATE") String sidx,
			@RequestParam(value = "sord"				, defaultValue = "DESC") String sord,						
			@RequestParam(value = "stdyyyymm"			, defaultValue = "") String stdyyyymm,
			@RequestParam(value = "page"				, defaultValue = "1") int page,
			@RequestParam(value = "rows"				, defaultValue = "30") int rows,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("stdyyyymm"	, stdyyyymm);
		
		/*----------------페이징 세팅------------*/
		int records = adjustSvc.getBondsMonthDetailCnt(params);
		int total = (int)Math.ceil((float)records / (float)rows);		
		
		/*----------------조회------------*/
		List<Map<String, String>> list = null;
		if(records>0) list = adjustSvc.getBondsMonthDetail(params, page, rows);		
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}		
	@RequestMapping("bondsMonthDetailJQGridExcel.sys")
	public ModelAndView bondsMonthDetailJQGridExcel(
			@RequestParam(value = "stdyyyymm", defaultValue = "") String stdyyyymm,
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("stdyyyymm"	, stdyyyymm);
		
		/*----------------조회------------*/
		List<Map<String, String>> list = adjustSvc.getBondsMonthDetail(params, 0, 0);		
		
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
		
//		modelAndView.setViewName("commonExcelViewResolver");
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("colDataList", list);		
		return modelAndView;
	}
	
	@RequestMapping("getMonthBondsList.sys")
	public ModelAndView getMonthBondsList(
			@RequestParam(value = "stdYear"		, defaultValue = "") String stdYear,
			@RequestParam(value = "stdMonth"	, defaultValue = "") String stdMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("stdYear"	, stdYear);
		params.put("stdMonth"	, stdMonth);
		
		/*----------------조회------------*/
		List<Map<String, String>> list = adjustSvc.getMonthBondsList(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}		
	
	@RequestMapping("getBondsReturnList.sys")
	public ModelAndView getBondsReturnList1(
			@RequestParam(value = "stdYear"		, defaultValue = "") String stdYear,
			@RequestParam(value = "stdMonth"	, defaultValue = "") String stdMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("stdYear"	, stdYear);
		params.put("stdMonth"	, stdMonth);
		
		/*----------------조회------------*/
		List<Map<String, String>> list1 = adjustSvc.getBondsReturnList1(params);
		List<Map<String, String>> list2 = adjustSvc.getBondsReturnList2(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list1", list1);
		modelAndView.addObject("list2", list2);
		return modelAndView;
	}		
	
	@RequestMapping("getBondsTypeList.sys")
	public ModelAndView getBondsTypeList(
			@RequestParam(value = "stdYear"		, defaultValue = "") String stdYear,
			@RequestParam(value = "stdMonth"	, defaultValue = "") String stdMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("stdYear"	, stdYear);
		params.put("stdMonth"	, stdMonth);
		
		/*----------------조회------------*/
		List<Map<String, String>> list = adjustSvc.getBondsTypeList(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}		
	
	@RequestMapping("getBondsLateList.sys")
	public ModelAndView getBondsLateList(
			@RequestParam(value = "stdYear"		, defaultValue = "") String stdYear,
			@RequestParam(value = "stdMonth"	, defaultValue = "") String stdMonth,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("stdYear"	, stdYear);
		params.put("stdMonth"	, stdMonth);
		
		/*----------------조회------------*/
		List<Map<String, String>> list = adjustSvc.getBondsLateList(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 채권회수계획작성
	 * 
	 */
	@RequestMapping("saveBondsPlan.sys")
	public ModelAndView saveBondsPlan(
				@RequestParam(value="saleSequArr[]" , required=false)String[] saleSequArr,
				@RequestParam(value="planAmou1Arr[]", required=false)String[] planAmou1Arr,
				@RequestParam(value="planDate1Arr[]", required=false)String[] planDate1Arr,
				@RequestParam(value="planAmou2Arr[]", required=false)String[] planAmou2Arr,
				@RequestParam(value="planDate2Arr[]", required=false)String[] planDate2Arr,
				ModelAndView mav, HttpServletRequest request) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		saveMap.put("saleSequArr" , saleSequArr);
		saveMap.put("planAmou1Arr", planAmou1Arr);
		saveMap.put("planDate1Arr", planDate1Arr);
		saveMap.put("planAmou2Arr", planAmou2Arr);
		saveMap.put("planDate2Arr", planDate2Arr);
		saveMap.put("userId"	  , userInfoDto.getUserId());
		try{
			adjustSvc.saveBondsPlan(saveMap);
		}catch(Exception e){
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		
		mav.setViewName("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
	

	/**
	 * 채권관리history 리스트 조회
	 */
	@RequestMapping("adjustBondsHistListJQGrid.sys")
	public ModelAndView adjustBondsHistListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "BOND_MANAGE_ID") String sidx,
			@RequestParam(value = "sord", defaultValue = "DESC") String sord,						
			@RequestParam(value = "clientId"	, defaultValue = "") String clientId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("clientId"	, clientId);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        List<Map<String,String>> list = adjustSvc.adjustBondsHistList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 채권관리 History 작성
	 * 
	 */
	@RequestMapping("saveBondsHistory.sys")
	public ModelAndView saveBondsHistory(
			@RequestParam(value="oper"			, required = true)String oper,
			@RequestParam(value="clientId"		, required = true)String clientId,
			@RequestParam(value="manage_type" 	, required = true)String manage_type,
			@RequestParam(value="contents" 		, required = true)String contents,
			@RequestParam(value="attach_seq1" 	, defaultValue="")String attach_seq1,
			@RequestParam(value="attach_seq2" 	, defaultValue="")String attach_seq2,
			@RequestParam(value="attach_seq3" 	, defaultValue="")String attach_seq3,
			@RequestParam(value="attach_seq4" 	, defaultValue="")String attach_seq4,
			@RequestParam(value="attach_seq5" 	, defaultValue="")String attach_seq5,
			@RequestParam(value="bond_manage_id", defaultValue="")String bond_manage_id,
			ModelAndView mav, HttpServletRequest request) throws Exception {
		
		CustomResponse custResponse = new CustomResponse(true);
		
		Map<String, Object> saveMap = new HashMap<String, Object>();
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		saveMap.put("oper"			, oper);
		saveMap.put("clientId"		, clientId);
		saveMap.put("manage_type"	, manage_type);
		saveMap.put("contents"		, contents);
		saveMap.put("attach_seq1"	, attach_seq1);
		saveMap.put("attach_seq2"	, attach_seq2);
		saveMap.put("attach_seq3"	, attach_seq3);
		saveMap.put("attach_seq4"	, attach_seq4);
		saveMap.put("attach_seq5"	, attach_seq5);
		saveMap.put("bond_manage_id", bond_manage_id);
		saveMap.put("user_id"	  	, userInfoDto.getUserId());
		try{
			adjustSvc.saveBondsHistory(saveMap);
		}catch(Exception e){
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		
		mav.setViewName("jsonView");
		mav.addObject(custResponse);
		return mav;
	}
}
