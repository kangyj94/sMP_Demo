package kr.co.bitcube.venController.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dto.CartMasterInfoDto;
import kr.co.bitcube.order.dto.OrderDeliDto;
import kr.co.bitcube.order.service.CartManageSvc;
import kr.co.bitcube.order.service.DeliverySvc;
import kr.co.bitcube.order.service.OrderCommonSvc;
import kr.co.bitcube.order.service.OrderRequestSvc;
import kr.co.bitcube.order.service.PurchaseSvc;
import kr.co.bitcube.order.service.ReturnOrderSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("venOrder")
public class VenOrderCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private PurchaseSvc purchaseSvc;
	
	@Autowired
	private OrderRequestSvc orderRequestSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	@Autowired
	private DeliverySvc deliverySvc;
	
	@Autowired
	private ReturnOrderSvc returnOrderSvc;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private CartManageSvc cartManageSvc;
	
	/** * 공급사 주문접수 리스트로 페이지 이동 */
	@RequestMapping("venOrderPurchaseList.sys")
	public ModelAndView venOrderPurchaseList(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		
		ModelMap paramMap = new ModelMap();
		paramMap.put("codeTypeCd", "ORDERSTATUSFLAGCD");
		paramMap.put("isUse", "1");
		
		List<Object> orderStatusCodeList = generalDao.selectGernalList("common.etc.selectCodeList", paramMap);
		
		modelAndView.addObject("orderStatusCodeList", orderStatusCodeList);
		modelAndView.setViewName("order/purchase/venOrderPurchaseList");
		return modelAndView;
	}
	
	
	/**
	 * 공급사 주문접수 리스트
	 */
	@RequestMapping("orderPurchaseList.sys")
	public ModelAndView orderPurchaseList(
			@RequestParam(value="startDate"		, defaultValue = "")	String	startDate,
			@RequestParam(value="endDate"		, defaultValue = "")	String	endDate,
			@RequestParam(value="purcStatFlag"	, defaultValue = "40")	String	purcStatFlag,
			@RequestParam(value="orderNumber"	, defaultValue = "")	String	orderNumber,
			@RequestParam(value = "page"		, defaultValue = "1")	String		page,
			@RequestParam(value = "rows"		, defaultValue = "30")	String		rows,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		LoginUserDto        loginUserDto = CommonUtils.getLoginUserDto(request);
		ModelMap            params       = new ModelMap();
		String              borgId       = loginUserDto.getBorgId();
		List<?>             list         = null;
		Map<String, Object> listMap      = null;
		int                 records      = 0;
		int                 total        = 0;
		
		params.put("startDate",    startDate);
		params.put("endDate",      endDate);
		params.put("purcStatFlag", purcStatFlag);
		params.put("orderNumber",  orderNumber);
		params.put("borgId",       borgId);
		params.put("page",         page);
		params.put("rows",         rows);
		
		listMap = this.commonSvc.getJqGridList("order.purchase.selectVenOrderPurchaseCnt", "order.purchase.selectVenOrderPurchaseList", params);
		list    = (List<?>)listMap.get("list");
		total   = (Integer)listMap.get("pageMax");
		records = (Integer)listMap.get("record");
		
		modelAndView.addObject("page"	, page);
		modelAndView.addObject("rows"	, rows);
		modelAndView.addObject("total"	, total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list"	, list);
		
		modelAndView.setViewName("jsonView");
		
		return modelAndView;
	}
	/**
	 * 공급사 주문접수 엑셀 리스트
	 */
	@RequestMapping("orderPurchaseExcelList.sys")
	public ModelAndView orderPurchaseExcelList(
			@RequestParam(value="excelFileName"	, defaultValue = "")	String	 excelFileName,
			@RequestParam(value ="sheetTitle"			, defaultValue = "") String sheetTitle,
			@RequestParam(value ="colLabels"			, required = false) String[] colLabels,
			@RequestParam(value ="colIds"				, required = false) String[] colIds,
			@RequestParam(value ="numColIds"		, required = false) String[] numColIds,
			@RequestParam(value ="figureColIds"		, required = false) String[] figureColIds,
			ModelAndView modelAndView, HttpServletRequest request, ModelMap paramMap) throws Exception{
		LoginUserDto		loginUserDto	= CommonUtils.getLoginUserDto(request);
		paramMap.put("isExcel", 1 );	//Query에서 상태값을 Case처리하기 위함
		paramMap.put("borgId", loginUserDto.getBorgId());

		List<Object> list = generalDao.selectGernalList("order.purchase.selectVenOrderPurchaseList", paramMap);
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
	
	/**
	 * 주문접수 (주문의뢰 -> 주문접수)
	 */
	@RequestMapping("ordPurcReceive.sys")
	public ModelAndView ordPurcReceive(
			@RequestParam(value="ordeIdenNumb_Array[]", required=true) String[] ordeIdenNumbArray,
			@RequestParam(value="ordeSequNumb_Array[]", required=true) String[] ordeSequNumbArray,
			@RequestParam(value="purcIdenNumb_Array[]", required=true) String[] purcIdenNumbArray,
			@RequestParam(value="deliScheDate_Array[]", required=true) String[] deliScheDateArray,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		CustomResponse		customResponse = new CustomResponse(true);
		LoginUserDto		loginUserDto   = CommonUtils.getLoginUserDto(request); 
		Map<String, Object>	saveMap        = new HashMap<String, Object>();
		String              userId         = loginUserDto.getUserId();
		
		saveMap.put("ordeIdenNumb_Array", ordeIdenNumbArray);
		saveMap.put("ordeSequNumb_Array", ordeSequNumbArray);
		saveMap.put("purcIdenNumb_Array", purcIdenNumbArray);
		saveMap.put("deliScheDate_Array", deliScheDateArray);
		saveMap.put("userId",             userId);
		
		try{
			this.purchaseSvc.updateOrdPurcReceive(saveMap);
		}
		catch(Exception e){
			this.logger.error(CommonUtils.getExceptionStackTrace(e));
			
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		
		return modelAndView;
	}
	
	/**
	 * 주문거부 (주문의뢰 -> 주문요청)
	 */
	@RequestMapping("ordPurcReceiveReject.sys")
	public ModelAndView ordPurcReceiveReject(
			@RequestParam(value="ordeIdenNumb_Array[]"		, required=true) String[] ordeIdenNumb_Array,
			@RequestParam(value="ordeSequNumb_Array[]"		, required=true) String[] ordeSequNumb_Array,
			@RequestParam(value="purcIdenNumb_Array[]"		, required=true) String[] purcIdenNumb_Array,
			@RequestParam(value="chanReasDesc_Array[]"		, required=true) String[] chanReasDesc_Array,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		LoginUserDto		loginUserDto	=(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse		customResponse	= new CustomResponse(true);
		Map<String, Object>	saveMap			= new HashMap<String, Object>();
		saveMap.put("ordeIdenNumb_Array"	, ordeIdenNumb_Array);
		saveMap.put("ordeSequNumb_Array"	, ordeSequNumb_Array);
		saveMap.put("purcIdenNumb_Array"	, purcIdenNumb_Array);
		saveMap.put("chanReasDesc_Array"	, chanReasDesc_Array);
		saveMap.put("userId"				, loginUserDto.getUserId());
		saveMap.put("borgNm"				, loginUserDto.getBorgNm());
		saveMap.put("userNm"				, loginUserDto.getUserNm());
		
		String errMsg = "";
		try{
            errMsg = purchaseSvc.updateOrdPurcReceiveRejectIncludeAddProd(saveMap);
            if("".equals(errMsg) == false){
                throw new Exception();
            }
		}catch(Exception e){
			errMsg = "".equals(errMsg) ? CommonUtils.getErrSubString(e,50) : errMsg;
			logger.error("Exception : "+CommonUtils.getErrSubString(e,50));
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
	/**
	 * 공급사 발주서 페이지 이동
	 */
	@RequestMapping("venPurchaseListPrint.sys")
	public ModelAndView venPurchaseListPrint(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		modelAndView.setViewName("order/purchase/venPurchaseListPrint");
		return modelAndView;
	}
	
	/**
	 * 공급사 발주서 리스트 
	 */
	@RequestMapping("purchaseListPrint.sys")
	public ModelAndView purchaseListPrint(
			@RequestParam(value="startDate"		, defaultValue="")		String	startDate,
			@RequestParam(value="endDate"		, defaultValue="")		String	endDate,
			@RequestParam(value="orderNumber"	, defaultValue="")		String	orderNumber,
			@RequestParam(value="srcBranchNm"	, defaultValue="")		String	srcBranchNm,
			@RequestParam(value ="page"			, defaultValue = "1")	int		page,
			@RequestParam(value ="rows"			, defaultValue = "30")	int		rows,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		LoginUserDto		loginUserDto	= (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object>	params			= new HashMap<String, Object>();
		params.put("startDate"		, startDate);
		params.put("endDate"		, endDate);
		params.put("orderNumber"	, orderNumber);
		params.put("srcBranchNm"	, srcBranchNm);
		params.put("borgId"			, loginUserDto.getBorgId());
		
		List<Map<String, Object>>	list	= null;
		int							records	= purchaseSvc.getVenpurchaseListPrintCnt(params); //조회조건에 따른 카운트
		int							total	= (int)Math.ceil((float)records / (float)rows);
		if(records > 0){
			list =  purchaseSvc.getVenpurchaseListPrint(params,page,rows);
		}
		modelAndView.addObject("page"	, page);
		modelAndView.addObject("rows"	, rows);
		modelAndView.addObject("total"	, total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list"	, list);
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	/** * 공급사 주문 진척도 화면 이동 */
	@RequestMapping("venOrderProgress.sys")
	public ModelAndView venOrderProgress(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		List<CodesDto> deliveryType = commonSvc.getCodeList("DELIVERYTYPE", 1, "");
		modelAndView.setViewName("order/orderRequest/venOrderProgress");
        modelAndView.addObject("deliveryType", deliveryType);
		return modelAndView;
	}
	
	
	/** * 공급사 주문 진척도 리스트 */
	@RequestMapping("venOrderProgressList.sys")
	public ModelAndView venOrderProgressList(
			@RequestParam(value="startDate"		, defaultValue="") String startDate,
			@RequestParam(value="endDate"		, defaultValue="") String endDate,
			@RequestParam(value="orderNumber"	, defaultValue="") String orderNumber,
			@RequestParam(value="srcOrderStatusFlag"	, defaultValue="") String srcOrderStatusFlag,
			@RequestParam(value ="page"			, defaultValue = "1") int page,
			@RequestParam(value ="rows"			, defaultValue = "30") int rows,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		LoginUserDto		loginUserDto	= (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object>	params			= new HashMap<String, Object>();
		params.put("startDate"		, startDate);
		params.put("endDate"		, endDate);
		params.put("orderNumber"	, orderNumber);
		params.put("srcOrderStatusFlag"	, srcOrderStatusFlag);
		params.put("borgId"			, loginUserDto.getBorgId());
		List<Map<String, Object>>	list	= null;
		int							records	= orderRequestSvc.getvenOrderProgressListCnt(params); //조회조건에 따른 카운트
		int							total	= (int)Math.ceil((float)records / (float)rows);
		if(records > 0){
			list =  orderRequestSvc.getvenOrderProgressList(params,page,rows);
		}
		modelAndView.addObject("page"	, page);
		modelAndView.addObject("rows"	, rows);
		modelAndView.addObject("total"	, total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list"	, list);
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	
	/** * 공급사 주문 진척도 리스트 */
	@RequestMapping("selectVODList.sys")
	public ModelAndView selectVODList(
			@RequestParam(value="srcOrderStartDate"		, defaultValue="") String srcOrderStartDate,
			@RequestParam(value="srcOrderEndDate"		, defaultValue="") String srcOrderEndDate,
			@RequestParam(value="srcOrderNumber"	, defaultValue="") String srcOrderNumber,
			@RequestParam(value="srcOrderStatusFlag"	, defaultValue="") String srcOrderStatusFlag,
			@RequestParam(value="srcBranchNm"	, defaultValue="") String srcBranchNm,
			@RequestParam(value ="page"			, defaultValue = "1") int page,
			@RequestParam(value ="rows"			, defaultValue = "30") int rows,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		LoginUserDto		loginUserDto	= (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object>	params			= new HashMap<String, Object>();
		params.put("srcOrderStartDate"	, srcOrderStartDate);
		params.put("srcOrderEndDate"	, srcOrderEndDate);
		params.put("srcOrderNumber"	, srcOrderNumber);
		params.put("srcOrderStatusFlag"	, srcOrderStatusFlag);
		params.put("srcVendorId"			, loginUserDto.getBorgId());
		params.put("srcBranchNm"			, srcBranchNm);
		
		List<Map<String, Object>>	list	= null;
		int							records	= orderRequestSvc.selectVODListCnt(params); //조회조건에 따른 카운트
		int							total	= (int)Math.ceil((float)records / (float)rows);
		if(records > 0){
			list =  orderRequestSvc.selectVODList(params,page,rows);
		}
		
		modelAndView.addObject("page"	, page);
		modelAndView.addObject("rows"	, rows);
		modelAndView.addObject("total"	, total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list"	, list);
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	/** 공급사 : 주문이력조회 화면이동 */
	@RequestMapping("venOrderHistList.sys")
	public ModelAndView venOrderHistList(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		ModelMap params = new ModelMap();
		params.put("codeTypeCd", "ORDERSTATUSFLAGCD");
		params.put("isUse", "1");
		List<Object> orderStatusCodeList = generalDao.selectGernalList("common.etc.selectCodeList",  params);
		modelAndView.setViewName("order/orderRequest/venOrderHistList");
		modelAndView.addObject("orderStatusCodeList",orderStatusCodeList);
		return modelAndView;
	}
	
	/** 공급사 : 주문이력조회 DB 조회 */
	@SuppressWarnings("unchecked")
	@RequestMapping("getVenOrderHistList.sys")
	public ModelAndView getVenOrderHistList(
			@RequestParam(value = "page",              defaultValue = "1")  String page,
			@RequestParam(value = "rows",              defaultValue = "30") String rows,
			@RequestParam(value = "srcOrdeIdenNumb",   defaultValue = "")   String srcOrdeIdenNumb,	
			@RequestParam(value = "srcGoodName",       defaultValue = "")   String srcGoodName,	
			@RequestParam(value = "srcGoodIdenNumb",   defaultValue = "")   String srcGoodIdenNumb,	
			@RequestParam(value = "srcIsBill",         defaultValue = "")   String srcIsBill,	
			@RequestParam(value = "srcOrdeStat",       defaultValue = "")   String srcOrdeStat,	
			@RequestParam(value = "srcOrderDateFlag",  defaultValue = "")   String srcOrderDateFlag,	
			@RequestParam(value = "srcOrderStartDate", defaultValue = "")   String srcOrderStartDate,	
			@RequestParam(value = "srcOrderEndDate",   defaultValue = "")   String srcOrderEndDate,	
			@RequestParam(value = "srcConNm",   defaultValue = "")   String srcConNm,	
			@RequestParam(value = "srcBranchNm",   defaultValue = "")   String srcBranchNm,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		ModelMap                 params       = new ModelMap();
		Map<String, Object>      svcResult    = null;
		LoginUserDto             loginUserDto = CommonUtils.getLoginUserDto(request);
		String                   borgId       = loginUserDto.getBorgId();
		List<Map<String,Object>> list         = null;
		int                      records      = 0;
		int                      total        = 0;
		
		modelAndView = new ModelAndView("jsonView");
		
		params.put("srcOrdeIdenNumb",   srcOrdeIdenNumb);
		params.put("srcGoodName",       srcGoodName);
		params.put("srcGoodIdenNumb",   srcGoodIdenNumb);
		params.put("srcIsBill",         srcIsBill);
		params.put("srcOrdeStat",       srcOrdeStat);
		params.put("srcOrderDateFlag",  srcOrderDateFlag);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate",   srcOrderEndDate);
		params.put("srcVendorId",       borgId);
		params.put("srcConNm",       srcConNm);
		params.put("srcBranchNm",       srcBranchNm);
		params.put("page",              page);
		params.put("rows",              rows);
		CustomResponse custResponse = new CustomResponse();
		try{	
			svcResult = this.commonSvc.getJqGridList("order.orderRequest.selectVenOrderHistListCnt", "order.orderRequest.selectVenOrderHistList", params);
			list      = (List<Map<String,Object>>)svcResult.get("list");
			records   = (Integer)svcResult.get("record");
			total     = (Integer)svcResult.get("pageMax");
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
        
		modelAndView.addObject("custResponse",custResponse);
		modelAndView.addObject("page",    page);
		modelAndView.addObject("total",   total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list",    list);
		
		return modelAndView;
	}

	/**
	 * 	공급사 : 주문이력엑셀리스트 조회 
	 */
	@RequestMapping("getVenOrderHistExcelList.sys")
	public ModelAndView getVenOrderHistExcelList(
			@RequestParam(value="excelFileName"	, defaultValue = "")	String	 excelFileName,
			@RequestParam(value ="sheetTitle"			, defaultValue = "") String sheetTitle,
			@RequestParam(value ="colLabels"			, required = false) String[] colLabels,
			@RequestParam(value ="colIds"				, required = false) String[] colIds,
			@RequestParam(value ="numColIds"		, required = false) String[] numColIds,
			@RequestParam(value ="figureColIds"		, required = false) String[] figureColIds,
			ModelAndView modelAndView, HttpServletRequest request, ModelMap paramMap) throws Exception{
		LoginUserDto		loginUserDto	= CommonUtils.getLoginUserDto(request);
		paramMap.put("isExcel", 1 );	//Query에서 상태값을 Case처리하기 위함
		paramMap.put("srcVendorId",       loginUserDto.getBorgId());
		List<Object> list = generalDao.selectGernalList("order.orderRequest.selectVenOrderHistList", paramMap);
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
	
	/** 공급사 : 인수대기 화면이동 */
	@RequestMapping("venOrdReceStandBy.sys")
	public ModelAndView venOrdReceStandBy(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		modelAndView.setViewName("order/delivery/venOrdReceStandBy");
		return modelAndView;
	}
	
	
	/** 공급사 : 인수대기 DB 조회 */
	@SuppressWarnings("unchecked")
	@RequestMapping("getVenOrdReceStandByList.sys")
	public ModelAndView getVenOrdReceStandByList(
			@RequestParam(value = "page",              defaultValue = "1")  String page,
			@RequestParam(value = "rows",              defaultValue = "30") String rows,
			@RequestParam(value = "srcBranchNm",       defaultValue = "")   String srcBranchNm,	
			@RequestParam(value = "srcOrdeIdenNumb",   defaultValue = "")   String srcOrdeIdenNumb,	
			@RequestParam(value = "srcOrderStartDate", defaultValue = "")   String srcOrderStartDate,	
			@RequestParam(value = "srcOrderEndDate",   defaultValue = "")   String srcOrderEndDate,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		Map<String, Object>      svcResult    = null;
		ModelMap                 params       = new ModelMap();
		LoginUserDto             loginUserDto = CommonUtils.getLoginUserDto(request);
		String                   borgId       = loginUserDto.getBorgId();
		List<Map<String,Object>> list         = null;
		int                      records      = 0;
		int                      total        = 0;
		
		modelAndView = new ModelAndView("jsonView");
		
		params.put("srcBranchNm",       srcBranchNm);
		params.put("srcOrdeIdenNumb",   srcOrdeIdenNumb);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate",   srcOrderEndDate);
		params.put("srcVendorId",       borgId);
		params.put("page",              page);
		params.put("rows",              rows);
		
        svcResult = this.commonSvc.getJqGridList("order.delivery.selectVenOrdReceStandByListCnt", "order.delivery.selectVenOrdReceStandByList", params);
        list      = (List<Map<String,Object>>)svcResult.get("list");
        records   = (Integer)svcResult.get("record");
        total     = (Integer)svcResult.get("pageMax");
		
		modelAndView.addObject("page",    page);
		modelAndView.addObject("total",   total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list",    list);
		
		return modelAndView;
	}
	
	/** 공급사 : 인수대기 화면이동 */
	@RequestMapping("venRetOrdProcList.sys")
	public ModelAndView venRetOrdProcList(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		modelAndView.setViewName("order/returnOrder/venRetOrdProcList");
		return modelAndView;
	}
	/** 공급사 : 반품신청현황 DB 조회 */
	@RequestMapping("getReturnOrdStatList.sys")
	public ModelAndView getVenOrderHistList(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "srcBranchName", defaultValue = "") String srcBranchName,	
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,	
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,	
			@RequestParam(value = "srcRtnStat", defaultValue = "") String srcRtnStat,
			@RequestParam(value = "srcDateType", defaultValue = "") String srcDateType,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBranchName", srcBranchName);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcRtnStat", srcRtnStat);
		params.put("srcDateType", srcDateType);
		
		LoginUserDto loginUserDto =(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME); 
		params.put("srcVendorId", loginUserDto.getBorgId());
		
		//----------------페이징 세팅------------/
        int records = returnOrderSvc.selectReturnOrdStatListCnt(params); 
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<Map<String,Object>> list = null; 
        if(records>0) list = returnOrderSvc.selectReturnOrdStatList(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	
	/** 공급사 : 반품신청현황 엑셀다운 */
	@RequestMapping("getReturnOrdStatListExcel.sys")
	public ModelAndView getReturnOrdStatListExcel(
			@RequestParam(value = "srcBranchName", defaultValue = "") String srcBranchName,	
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,	
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,	
			@RequestParam(value = "srcRtnStat", defaultValue = "") String srcRtnStat,
			@RequestParam(value = "srcDateType", defaultValue = "") String srcDateType,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto loginUserDto =(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("srcVendorId", loginUserDto.getBorgId());
		List<Object> list = generalDao.selectGernalList("order.returnOrder.selectReturnOrdStatList", paramMap);
		
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
	
	
	/** 공급사 : 배송처리  */
	@RequestMapping("deliProcList.sys")
	public ModelAndView getDeliProcList( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<CodesDto> orderTypeCode = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
		List<CodesDto> deliveryType = commonSvc.getCodeList("DELIVERYTYPE", 1, "");
        mav.addObject("orderTypeCode", orderTypeCode);
        mav.addObject("deliveryType", deliveryType);
        mav.setViewName("order/delivery/venDeliProcList");
		return mav;
	}
	/** 공급사 : 배송처리 그리드 */
	@SuppressWarnings("unchecked")
	@RequestMapping("deliProcQGrid.sys")
	public ModelAndView getDeliProcJQGrid( 
			@RequestParam(value = "page",             defaultValue = "1")   String page,
			@RequestParam(value = "rows",             defaultValue = "100") String rows,
			@RequestParam(value = "sidx",             defaultValue = "")    String sidx, // 정렬할 칼럼 명
			@RequestParam(value = "sord",             defaultValue = "")    String sord, // 정렬 조건
			@RequestParam(value = "srcPurcStartDate", defaultValue = "")    String srcPurcStartDate, // 시작
			@RequestParam(value = "srcPurcEndDate",   defaultValue = "")    String srcPurcEndDate, // 끝
			@RequestParam(value = "srcOrdeIdenNumb",  defaultValue = "")    String srcOrdeIdenNumb, // 주문번호 
			@RequestParam(value = "srcBranchNm",      defaultValue = "")    String srcBranchNm, // 고객사명
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,						// 상품명
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		ModelMap            params       = new ModelMap();
		LoginUserDto        loginUserDto = CommonUtils.getLoginUserDto(req);
		String              borgId       = loginUserDto.getBorgId();
		List<OrderDeliDto>  list         = null;
		Map<String, Object> svcReturn    = null;
		int                 records      = 0;
		int                 total        = 0;
		
		mav = new ModelAndView("jsonView");
		
		params.put("srcVendorId",      borgId);
		params.put("srcPurcStartDate", srcPurcStartDate);
		params.put("srcPurcEndDate",   srcPurcEndDate);
		params.put("srcOrdeIdenNumb",  srcOrdeIdenNumb);
		params.put("srcBranchNm",      srcBranchNm);
		params.put("srcGoodName",      srcGoodName);
		params.put("page",             page);
		params.put("rows",             rows);
		
		svcReturn = this.deliverySvc.getVenDeliProcList(params);
		list      = (List<OrderDeliDto>)svcReturn.get("list");
		total     = (Integer)svcReturn.get("pageMax");
		records   = (Integer)svcReturn.get("record");
		
		mav.addObject("page",    page);
		mav.addObject("total",   total);
		mav.addObject("records", records);
		mav.addObject("list",    list);
		
		return mav;
	}
	
	/**
	 * 공급사 주문접수 엑셀 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("deliProcExcel.sys")
	public ModelAndView deliProcExcel(
			@RequestParam(value="excelFileName"	, defaultValue = "")	String	 excelFileName,
			@RequestParam(value ="sheetTitle"			, defaultValue = "") String sheetTitle,
			@RequestParam(value ="colLabels"			, required = false) String[] colLabels,
			@RequestParam(value ="colIds"				, required = false) String[] colIds,
			@RequestParam(value ="numColIds"		, required = false) String[] numColIds,
			@RequestParam(value ="figureColIds"		, required = false) String[] figureColIds,
			ModelAndView modelAndView, HttpServletRequest request, ModelMap paramMap) throws Exception{
		LoginUserDto		      loginUserDto = CommonUtils.getLoginUserDto(request);
		String                    borgId       = loginUserDto.getBorgId();
		List<OrderDeliDto>        list         = null;
		List<Map<String, Object>> sheetList    = new ArrayList<Map<String, Object>>();
		Map<String, Object>       svcReturn    = null;
		Map<String, Object>       map1         = new HashMap<String, Object>();
				
		paramMap.put("srcVendorId",      borgId);
		paramMap.put("page",             "-1");
		paramMap.put("rows",             "-1");
				
		svcReturn = this.deliverySvc.getVenDeliProcList(paramMap);
		list      = (List<OrderDeliDto>)svcReturn.get("list");

		List<Map<String, Object>> list1 = new ArrayList<Map<String, Object>>();
		
		for(Object obj : list) {
			list1.add(CommonUtils.ConverObjectToMap(obj));
		}
		
		map1.put("sheetTitle",   sheetTitle);
		map1.put("colLabels",    colLabels);
		map1.put("colIds",       colIds);
		map1.put("numColIds",    numColIds);
		map1.put("figureColIds", figureColIds);
		map1.put("colDataList",  list1);
		
		sheetList.add(map1);
		
		modelAndView.setViewName("commonExcelViewResolver");
		modelAndView.addObject("excelFileName", excelFileName);
		modelAndView.addObject("sheetList", sheetList);
		
		return modelAndView;
	}
	
	
	/** * 공급사 배송정보 팝업 호출 */
	@RequestMapping("venReceiveDeliInfoPop.sys")
	public ModelAndView venReceiveDeliInfoPop(
			@RequestParam(value = "orde_iden_numb", defaultValue = "") String orde_iden_numb,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		Map<String, Object> params = new HashMap<String,Object>();
		params.put("orde_iden_numb" , orde_iden_numb);
		Map<String, Object> deliInfo = deliverySvc.selectVenReceiveDeliInfoPop(params);
		modelAndView.setViewName("order/delivery/venReceiveDeliInfoPop");
		modelAndView.addObject("deliInfo", deliInfo);
		return modelAndView;
	}
	
	/** 공급사 인수이력 화면 이동 */
	@RequestMapping("venReceHist.sys")
	public ModelAndView venReceHist(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		modelAndView.setViewName("order/delivery/venReceHist");
		return modelAndView;
	}
	
	/** 공급사 : 인수이력 그리드 */
	@RequestMapping("venReceHistList.sys")
	public ModelAndView venReceHistList( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcReceStartDate", defaultValue = "") String srcReceStartDate,								// 시작
			@RequestParam(value = "srcReceEndDate", defaultValue = "") String srcReceEndDate,								// 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			@RequestParam(value = "srcBranchNm", defaultValue = "") String srcBranchNm,						// 고객사명
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		LoginUserDto loginUserDto =(LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME); 
		params.put("srcVendorId", loginUserDto.getBorgId());
		params.put("srcReceStartDate",srcReceStartDate);
		params.put("srcReceEndDate", srcReceEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcBranchNm", srcBranchNm);
		//----------------페이징 세팅------------/
        int records = deliverySvc.getVenReceHistListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<Map<String,Object>> list = null;
        if(records>0){ list = deliverySvc.getVenReceHistList(params, page, rows); }
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	
//	/** 공급사 : 주문접수취소요청 처리  화면이동 */
//	@RequestMapping("venOrdPurcCancProc.sys")
//	public ModelAndView venOrdPurcCancProcList(
//			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
//		modelAndView.setViewName("order/purchase/venOrdPurcCancProcList");
//		return modelAndView;
//	}
//	
//	/** 공급사 : 인수이력 그리드 */
//	@RequestMapping("venOrdPurcCancProcList.sys")
//	public ModelAndView venOrdPurcCancProcList( 
//			@RequestParam(value = "page",defaultValue = "1") int page,
//			@RequestParam(value = "rows", defaultValue = "100") int rows,
//			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
//			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
//			// 조회 조건
//			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 시작
//			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 끝
//			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
//			@RequestParam(value = "srcBranchNm", defaultValue = "") String srcBranchNm,						// 고객사명
//			HttpServletRequest req, ModelAndView mav) throws Exception{
//		//----------------조회조건 세팅------------/
//		Map<String, Object> params = new HashMap<String, Object>();
//		LoginUserDto loginUserDto =(LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME); 
//		params.put("srcVendorId", loginUserDto.getBorgId());
//		params.put("srcReceStartDate",srcPurcStartDate);
//		params.put("srcReceEndDate", srcPurcEndDate);
//		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
//		params.put("srcBranchNm", srcBranchNm);
//		//----------------페이징 세팅------------/
//        int records = purchaseSvc.selectVenOrdPurcCancProcListCnt(params); //조회조건에 따른 카운트
//        int total = (int)Math.ceil((float)records / (float)rows);
//        //----------------조회------------/
//        List<Map<String,Object>> list = null;
//        if(records>0){ list = purchaseSvc.selectVenOrdPurcCancProcList(params, page, rows); }
//		mav= new ModelAndView("jsonView");
//		mav.addObject("page", page);
//		mav.addObject("total", total);
//		mav.addObject("records", records);
//		mav.addObject("list", list);
//		return mav;
//	}
	
//	/** 공급사 : 발주취소요청 처리 */
//	@RequestMapping("purcCancProc.sys")
//	public ModelAndView purcCancProc(
//			@RequestParam(value="cancelId_Array[]"	, required=true) String[] cancelId_Array,
//			@RequestParam(value="flag"		, required=true) String flag,
//			@RequestParam(value="reason"	, defaultValue = "") String reason,
//			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
//		CustomResponse		customResponse	= new CustomResponse(true);
//		LoginUserDto		loginUserDto	=(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME); 
//		Map<String, Object>	saveMap			= new HashMap<String, Object>();
//		saveMap.put("cancelId_Array", cancelId_Array);
//		saveMap.put("flag"	   , flag);
//		saveMap.put("reason" , reason);
//		saveMap.put("userId" , loginUserDto.getUserId());
//		try{
//			 purchaseSvc.purcCancProc(saveMap);
//		}catch(Exception e){
//			logger.error("Exception : "+e);
//			customResponse.setSuccess(false);
//			customResponse.setMessage("System Excute Error!....");
//			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
//		}
//		
//		modelAndView.setViewName("jsonView");
//		modelAndView.addObject("customResponse", customResponse);
//		return modelAndView;
//	}
	
	/** 공급사 : 발주취소요청 처리 */
	@RequestMapping("purcCancProc.sys")
	public ModelAndView purcCancProcOne(
			@RequestParam(value="cancelId"	, required=true) String cancelId,
			@RequestParam(value="flag"		, required=true) String flag,
			@RequestParam(value="reason"	, defaultValue = "") String reason,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		CustomResponse		customResponse	= new CustomResponse(true);
		LoginUserDto		loginUserDto	=(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME); 
		Map<String, Object>	saveMap			= new HashMap<String, Object>();
		saveMap.put("cancelId", cancelId);
		saveMap.put("flag"	   , flag);
		saveMap.put("reason" , reason);
		saveMap.put("userId" , loginUserDto.getUserId());
		try{
			 purchaseSvc.purcCancProcOne(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
	/** * 공급사 : 주문진척도 : 주문취소요청 정보 조회 */
	@RequestMapping("venSelectCancReqInfo.sys")
	public ModelAndView venSelectCancReqInfo(
			@RequestParam(value="ordeIdenNumb"		, defaultValue="") String ordeIdenNumb,
			@RequestParam(value="ordeSequNumb"		, defaultValue="") String ordeSequNumb,
			@RequestParam(value="purcIdenNumb"		, defaultValue="") String purcIdenNumb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		Map<String, Object>	params			= new HashMap<String, Object>();
		params.put("ordeIdenNumb"		, ordeIdenNumb);
		params.put("ordeSequNumb"		, ordeSequNumb);
		params.put("purcIdenNumb"		, purcIdenNumb);
		params = purchaseSvc.venSelectCancReqInfo(params);
		modelAndView.addObject("data"	, params);
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	/** * 공급사 역주문 페이지 이동 */
	@RequestMapping("venOrderRequest.sys")
	public ModelAndView venOrderRequest(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		modelAndView.setViewName("order/cart/venCartInfo");
		return modelAndView;
	}
	@RequestMapping("BuyUserMstCartInfo.sys")
	public ModelAndView BuyUserMstCartInfo(
			@RequestParam(value="branchid"		, defaultValue="") String branchid,
			@RequestParam(value="userid"		, defaultValue="") String userid,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchParams = new HashMap<String, Object>();    
		;
		searchParams.put("branchid" , branchid);
		searchParams.put("userid" , userid);
		
		
		CartMasterInfoDto cmi = cartManageSvc.getCartMasterInfo(searchParams);
		if(cmi != null){
			Map<String, Object> userInfo = commonSvc.selectUserInfoByUserInfo(searchParams);
			if(userInfo != null && cmi.getTran_user_name().equals("")){
				cmi.setTran_user_name(CommonUtils.getString(userInfo.get("USERNM")) );
			}
			if(userInfo != null && cmi.getTran_tele_numb().equals("")){
				cmi.setTran_tele_numb( CommonUtils.getString(userInfo.get("MOBILE")) );
			}
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("userInfo",cmi);
		return modelAndView;
	}
	
	
	
	
	/** * 공급사 역주문  */
	@RequestMapping("setOrderCartInfo.sys")
	public ModelAndView setOrderCartInfo(
			@RequestParam(value = "ord_quans[]"			, required=true)	String[] ord_quans 		, 		
			@RequestParam(value = "vendorids[]" 		, required=true)	String[] vendorids 		,
			@RequestParam(value = "good_iden_numbs[]"	, required=true)	String[] good_iden_numbs,
			@RequestParam(value = "orde_requ_prics[]"	, required=true)	String[] orde_requ_prics,
			@RequestParam(value = "sale_unit_prices[]"	, required=true)	String[] sale_unit_prices,
			@RequestParam(value = "requ_deli_dates[]"	, required=true)	String[] requ_deli_dates,
			@RequestParam(value = "good_names[]"		, required=true)	String[] good_names,
			@RequestParam(value = "good_specs[]"		, required=true)	String[] good_specs,
			@RequestParam(value = "add_good_numbs[]"	, required=true)	String[] add_good_numbs,
			@RequestParam(value = "repre_good_numbs[]"	, required=true)	String[] repre_good_numbs,
			@RequestParam(value = "cons_iden_name"  	, defaultValue="")	String cons_iden_name ,
			@RequestParam(value = "orde_type_clas"  	, defaultValue="")	String orde_type_clas ,
			@RequestParam(value = "orde_tele_numb"  	, defaultValue="")	String orde_tele_numb ,
			@RequestParam(value = "orde_user_id"    	, defaultValue="")	String orde_user_id   ,
			@RequestParam(value = "tran_data_addr"  	, defaultValue="")	String tran_data_addr ,
			@RequestParam(value = "tran_user_name"  	, defaultValue="")	String tran_user_name ,
			@RequestParam(value = "tran_tele_numb"  	, defaultValue="")	String tran_tele_numb ,
			@RequestParam(value = "adde_text_desc"  	, defaultValue="")	String adde_text_desc ,
			@RequestParam(value = "mana_user_id"  		, defaultValue="")	String mana_user_id ,
			@RequestParam(value = "attach_file_1"   	, defaultValue="")	String attach_file_1  ,
			@RequestParam(value = "attach_file_2"   	, defaultValue="")	String attach_file_2  ,
			@RequestParam(value = "attach_file_3"   	, defaultValue="")	String attach_file_3  ,
			
			@RequestParam(value = "branchid"   	, defaultValue="")	String branchid,
			HttpServletRequest request, ModelAndView modelAndView) {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("userid"				, loginUserDto.getUserId());
			Map<String , Object> buyBorgInfoMap = orderRequestSvc.selectBuyBorgInfo(branchid);
			params.put("groupid"			, buyBorgInfoMap.get("GROUPID"));
			params.put("clientid"			, buyBorgInfoMap.get("CLIENTID"));
			params.put("clientCd"			, buyBorgInfoMap.get("BORGCD"));
			params.put("branchid"			, branchid);
			params.put("ord_quans"			, ord_quans);
			params.put("vendorids"			, vendorids);
			params.put("orde_requ_prics"	, orde_requ_prics);
			params.put("good_iden_numbs"	, good_iden_numbs);
			params.put("sale_unit_prices"	, sale_unit_prices);
			params.put("requ_deli_dates"	, requ_deli_dates);
			params.put("good_names"			, good_names);
			params.put("good_specs"			, good_specs);
			params.put("add_good_numbs"		, add_good_numbs);
			params.put("repre_good_numbs"	, repre_good_numbs);
			
			params.put("cons_iden_name"		, cons_iden_name);
			params.put("orde_type_clas"		, orde_type_clas);
			params.put("orde_tele_numb"		, orde_tele_numb);
			params.put("orde_user_id"		, orde_user_id);
			params.put("tran_data_addr"		, tran_data_addr);
			params.put("tran_user_name"		, tran_user_name);
			params.put("tran_tele_numb"		, tran_tele_numb);
			params.put("adde_text_desc"		, adde_text_desc);
			params.put("mana_user_id"		, mana_user_id);
			params.put("attach_file_1"		, attach_file_1);
			params.put("attach_file_2"		, attach_file_2);
			params.put("attach_file_3"		, attach_file_3);
			orderRequestSvc.setOrderCartInfo(params);
		}catch(Exception e) {
			e.printStackTrace();
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}	
	
	
	/** 추가상품 인수 */
	@RequestMapping("venAddProdReceive.sys")
	public ModelAndView venAddProdReceive(
			@RequestParam(value="orde_iden_numb"		, required=true) String orde_iden_numb,
			@RequestParam(value="purc_iden_numb"		, required=true) String purc_iden_numb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		LoginUserDto		loginUserDto	=(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse		customResponse	= new CustomResponse(true);
		Map<String, Object>	saveMap			= new HashMap<String, Object>();
		saveMap.put("orde_iden_numb"				, orde_iden_numb);
		saveMap.put("purc_iden_numb"				, purc_iden_numb);
		saveMap.put("userId"				, loginUserDto.getUserId());
		try{
			deliverySvc.updateVenAddProdReceive(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+CommonUtils.getErrSubString(e,50));
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
	
	
	/** 인수증 미리 출력 여부 업데이트 */
	@RequestMapping("updateIsPurcPrint.sys")
	public ModelAndView updateIsPurcPrint(
			ModelAndView modelAndView, HttpServletRequest request, ModelMap paramMap) throws Exception{
		CustomResponse		customResponse = new CustomResponse(true);
		try{
			this.purchaseSvc.updateIsPurcPrint(paramMap);
		}
		catch(Exception e){
			this.logger.error(CommonUtils.getExceptionStackTrace(e));
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		
		return modelAndView;
	}
	
	
	/** 공급사 : 발주서 출력 시 버튼 칼럼 업데이트 */
	@RequestMapping("venPurcPrintBtn.sys")
	public ModelAndView venPurcPrintBtn(
			@RequestParam(value="ordeIdenNumb"		, required=true) String ordeIdenNumb,
			@RequestParam(value="vendorid"		, required=true) String vendorid,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		LoginUserDto		loginUserDto	=(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse		customResponse	= new CustomResponse(true);
		Map<String, Object>	saveMap			= new HashMap<String, Object>();
		saveMap.put("ordeIdenNumb"				, ordeIdenNumb);
		saveMap.put("vendorid"				, vendorid);
		try{
			deliverySvc.updateVenPurcPrintBtn(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+CommonUtils.getErrSubString(e,50));
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
	
	
	/** 공급사 : 배송정보  업데이트 */
	@RequestMapping("updateInvoInfo.sys")
	public ModelAndView updateInvoInfo(
			@RequestParam(value="mstKeyValue"		, required=true) String mstKeyValue,
			@RequestParam(value="modDeliTypeClas"		, required=true) String modDeliTypeClas,
			@RequestParam(value="modInvoNumb"		, required=true) String modInvoNumb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		CustomResponse		customResponse	= new CustomResponse(true);
		Map<String, Object>	saveMap			= new HashMap<String, Object>();
		saveMap.put("mstKeyValue"				, mstKeyValue);
		saveMap.put("modDeliTypeClas"			, modDeliTypeClas);
		saveMap.put("modInvoNumb"			, modInvoNumb);
		try{
			deliverySvc.updateInvoInfo(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+CommonUtils.getErrSubString(e,50));
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
	
	/**
	 * 공급사 배송처리 임시저장.
	 */
	@RequestMapping("tempDeliSave.sys")
	public ModelAndView tempDeliSave(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,						// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,						// 발주차수
			@RequestParam(value = "to_do_deli_prod_quan_array[]", required=true) String[] to_do_deli_prod_quan_array,		// 출하할수량
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		CustomResponse		customResponse = new CustomResponse(true);
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("to_do_deli_prod_quan_array", to_do_deli_prod_quan_array);
		
		try{
			this.deliverySvc.insertTempDeliSave(saveMap);
		}
		catch(Exception e){
			this.logger.error(CommonUtils.getExceptionStackTrace(e));
			
			customResponse.setSuccess(false);
//			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(CommonUtils.getErrSubString(e,45));	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		
		return modelAndView;
	}
}
