package kr.co.bitcube.buyController.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginRoleDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dto.OrderDeliDto;
import kr.co.bitcube.order.dto.OrderDto;
import kr.co.bitcube.order.service.DeliverySvc;
import kr.co.bitcube.order.service.OrderCommonSvc;
import kr.co.bitcube.order.service.OrderRequestSvc;
import kr.co.bitcube.order.service.PurchaseSvc;
import kr.co.bitcube.order.service.ReturnOrderSvc;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("buyOrder")
public class BuyOrderCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private DeliverySvc deliverySvc;
	
	@Autowired
	private ReturnOrderSvc returnOrderSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	@Autowired
	private OrderRequestSvc orderRequestSvc;
	
	@Autowired
	private PurchaseSvc purchaseSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	/** * 고객사 상품인수조회 리스트로 페이지 이동 */
	@RequestMapping("clientReceiveList.sys")
	public ModelAndView clientReceiveList(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		modelAndView.setViewName("order/delivery/clientReceiveList");
		return modelAndView;
	}
	/** * 상품인수조회 */
	@RequestMapping("prodReceiveList.sys")
	public ModelAndView prodReceiveList( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "8") int rows,
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,		
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,
			@RequestParam(value = "srcDateType", defaultValue = "") String srcDateType,
			HttpServletRequest req, ModelAndView mav
		) throws Exception{
		LoginUserDto        loginUserDto = CommonUtils.getLoginUserDto(req);
		Map<String, Object> params       = new HashMap<String, Object>();
		String              borgId       = loginUserDto.getBorgId();
		List<OrderDeliDto>  list         = null; 
		
	    if("".equals(srcOrderStartDate) && "".equals(srcOrderEndDate)){ //초기 화면 이동 시 날짜 데이터 없으므로 세팅.
	    	srcOrderStartDate = CommonUtils.getCustomDay("MONTH", -1);
	    	srcOrderEndDate   = CommonUtils.getCurrentDate();
	    }
	    
		params.put("srcVendorNm",       srcVendorNm);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate",   srcOrderEndDate);
		params.put("srcOrdeIdenNumb",   srcOrdeIdenNumb);
		params.put("srcBranchId",       borgId);
		params.put("loginUserDto",      loginUserDto);
		params.put("srcDateType",      srcDateType);
		
        int records = deliverySvc.selectProdReceiveListCnt(params); 
        int total   = (int)Math.ceil((float)records / (float)rows);
        
        if(records > 0){
        	list = deliverySvc.selectProdReceiveList(params, page, rows); 
        }
        
		mav.addObject("page",    page);
		mav.addObject("total",   total);
		mav.addObject("records", records);
		mav.addObject("list",    list);
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	/** * 배송정보 팝업 호출 */
	@RequestMapping("clientReceiveDeliInfoPop.sys")
	public ModelAndView clientReceiveDeliInfoPop(
			@RequestParam(value = "orde_iden_numb", defaultValue = "") String orde_iden_numb,	
			@RequestParam(value = "purc_iden_numb", defaultValue = "") String purc_iden_numb,	
			@RequestParam(value = "deli_iden_numb", defaultValue = "") String deli_iden_numb,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		Map<String, Object> params = new HashMap<String,Object>();
		params.put("orde_iden_numb" , orde_iden_numb);
		params.put("purc_iden_numb" , purc_iden_numb);
		params.put("deli_iden_numb" , deli_iden_numb);
		Map<String, Object> deliInfo = deliverySvc.selectClientReceiveDeliInfoPop(params);
		modelAndView.setViewName("order/delivery/clientReceiveDeliInfoPop");
		modelAndView.addObject("deliInfo", deliInfo);
		return modelAndView;
	}
	
	
	/** * 인수내역/반품요청 */
	@RequestMapping("returnOrderRegist.sys")
	public ModelAndView getReturnOrderRegist( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/returnOrder/clientReturnOrderList");
		return mav;
	}
	
	/** * 인수내역/반품요청 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("returnOrderRegistList.sys")
	public ModelAndView returnOrderRegistJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcReturnStatFlag", defaultValue = "") String srcReturnStatFlag,	
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,	
			@RequestParam(value = "srcOrderDateType", defaultValue = "") String srcOrderDateType,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		Map<String, Object>      params               = new HashMap<String, Object>();
		LoginUserDto             loginUserDto         = CommonUtils.getLoginUserDto(request);
		String                   srcReturnStatFlagStr = "";
		String                   borgId               = loginUserDto.getBorgId();
		List<Map<String,Object>> list                 = null;
		
		modelAndView = new ModelAndView("jsonView");
		
		if("retuReq".equals(srcReturnStatFlag)){
        	srcReturnStatFlagStr = "0";
        }
        else if("retuApp".equals(srcReturnStatFlag)){
        	srcReturnStatFlagStr = "1";
        }
        else if("retuRej".equals(srcReturnStatFlag)){
        	srcReturnStatFlagStr = "9";
        }
		
		params.put("srcOrderStartDate",    srcOrderStartDate);
		params.put("srcOrderEndDate",      srcOrderEndDate);
		params.put("srcOrdeIdenNumb",      srcOrdeIdenNumb);
		params.put("srcReturnStatFlag",    srcReturnStatFlag);
		params.put("srcReturnStatFlagStr", srcReturnStatFlagStr);
		params.put("srcVendorNm",          srcVendorNm);
		params.put("srcOrderDateType",     srcOrderDateType);
		params.put("srcBranchId",          borgId);
		
        int records = returnOrderSvc.selectClientReturnOrderListCnt(params); 
        int total   = (int)Math.ceil((float)records / (float)rows);
		 
        if(records > 0){
        	list = returnOrderSvc.selectClientReturnOrderList(params, page, rows); 
        }
        
		modelAndView.addObject("page",    page);
		modelAndView.addObject("total",   total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list",    list);
		
		return modelAndView;
	}
	
	/** * 인수이력조회 */
	@RequestMapping("clientReceHistList.sys")
	public ModelAndView getClientReceHistList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/delivery/clientReceHistList");
		return mav;
	}
	
	/** * 인수이력 조회 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("getClientReceHistList.sys")
	public ModelAndView getClientReceHistList(
			@RequestParam(value = "page",              defaultValue = "1")  String page,
			@RequestParam(value = "rows",              defaultValue = "30") String rows,
			@RequestParam(value = "srcOrderStartDate", defaultValue = "")   String srcOrderStartDate,						
			@RequestParam(value = "srcOrderEndDate",   defaultValue = "")   String srcOrderEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb",   defaultValue = "")   String srcOrdeIdenNumb,	
			@RequestParam(value = "srcVendorNm",       defaultValue = "")   String srcVendorNm,
			@RequestParam(value = "srcType",           defaultValue = "")   String srcType,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto             loginUserDto = CommonUtils.getLoginUserDto(request);
		ModelMap                 params       = new ModelMap();
		Map<String, Object>      listMap      = null;
		List<?>                  list         = null;
		String                   borgId       = loginUserDto.getBorgId();
		Integer                  record       = null;
		Integer                  pageMax      = null;
		
		modelAndView = new ModelAndView("jsonView");
		
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate",   srcOrderEndDate);
		params.put("srcOrdeIdenNumb",   srcOrdeIdenNumb);
		params.put("srcVendorNm",       srcVendorNm);
		params.put("srcType",           srcType);
		params.put("srcBranchId",       borgId);
		params.put("page",              page);
		params.put("rows",              rows);
		
		listMap = this.commonSvc.getJqGridList("order.delivery.selectClientReceHistListCnt", "order.delivery.selectClientReceHistList", params);
		record  = (Integer)listMap.get("record");
		pageMax = (Integer)listMap.get("pageMax");
		list    = (List<?>)listMap.get("list");
		
		modelAndView.addObject("page",    page);
		modelAndView.addObject("total",   pageMax);
		modelAndView.addObject("records", record);
		modelAndView.addObject("list",    list);
		
		return modelAndView;
	}
	
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
			HttpServletRequest request, ModelAndView modelAndView) {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("isDirectMan"		, loginUserDto.isDirectMan());
			params.put("groupid"			, loginUserDto.getGroupId());
			params.put("clientid"			, loginUserDto.getClientId());
			params.put("clientCd"			, loginUserDto.getClientCd());
			params.put("branchid"			, loginUserDto.getBorgId());
			params.put("userid"				, loginUserDto.getUserId());
			
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
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(e.getMessage());	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}	
	
	/** 구매이력 조회 */
	@RequestMapping("orderResultSearchBuy.sys")
	public ModelAndView orderResultSearchBuy( HttpServletRequest req, ModelAndView mav) throws Exception{
		
		List<CodesDto> codeList = commonSvc.getCodeList("RESULTORDERSTATUS", 1, "");
		mav.addObject("codeList", codeList);
		mav.setViewName("order/orderRequest/orderResultSearchBuy");
		return mav;
	}
	
	/** 구매이력 조회 (그리드)*/
	@RequestMapping("orderResultSearchBuyJQGrid.sys")
	public ModelAndView orderResultSearchBuyJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 												// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,												// 정렬 조건
			@RequestParam(value = "srcOrderNumber", defaultValue = "") String srcOrderNumber, 							// 주문번호			
			@RequestParam(value = "srcOrderStatusFlag", defaultValue = "") String srcOrderStatusFlag,					// 주문상태
			@RequestParam(value = "srcOrderDateFlag", defaultValue = "") String srcOrderDateFlag,						// 주문검색플래그
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						// 주문일 - 시작
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,							// 주문일 - 시작
			@RequestParam(value = "srcIsBill", defaultValue = "") String srcIsBill,
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,

			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*************권한정보**************/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
		String srcResultOrderStatusFlag = "";
		if("55".equals(srcOrderStatusFlag)){
			srcOrderStatusFlag = "60";
			srcResultOrderStatusFlag = "55";
		}else if("60".equals(srcOrderStatusFlag)){
			srcOrderStatusFlag = "60";
			srcResultOrderStatusFlag = "60";
		}
		
		//----------------조회조건 세팅------------/
		ModelMap params = new ModelMap();
		
		params.put("srcOrderNumber", srcOrderNumber);
		params.put("srcOrderStatusFlag", srcOrderStatusFlag);
		params.put("srcOrderDateFlag", srcOrderDateFlag);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcIsBill", srcIsBill);
		params.put("srcResultOrderStatusFlag", srcResultOrderStatusFlag);
		params.put("srcBranchId", loginUserDto.getBorgId());
		params.put("srcGoodIdenNumb", srcGoodIdenNumb);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
			
		//----------------페이징 세팅------------/
        @SuppressWarnings("unchecked")
		Map<String, Integer> records =(Map<String,Integer>) generalDao.selectGernalObject("order.orderRequest.selectOrderResultBuyList_count", params);
        int total = (int)Math.ceil((float)records.get("CNT") / (float)rows);
		
        //----------------조회------------/
        List<Object> list = null; 
        if(records.get("CNT")>0){ 
			params.put("sum_orde_pric", records.get("SUM_ORDE_PRIC"));
			params.put("sum_quantity", records.get("SUM_QUANTITY"));
			int offset = (page-1)*rows;
			
			params.put("rowBounds", new RowBounds(offset, rows));
			list = generalDao.selectGernalList("order.orderRequest.selectOrderResultBuyList", params);
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records.get("CNT"));
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/** 고객사 : 주문취소요청 시작 */
	@RequestMapping("purcCancStart.sys")
	public ModelAndView purcCancStart(
			@RequestParam(value="ordeIdenNumb"		, required=true) String ordeIdenNumb,
			@RequestParam(value="ordeSequNumb"		, required=true) String ordeSequNumb,
			@RequestParam(value="purcIdenNumb"		, required=true) String purcIdenNumb,
			@RequestParam(value="reason"	, required=true) String reason,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		CustomResponse		customResponse	= new CustomResponse(true);
		LoginUserDto		loginUserDto	=(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME); 
		Map<String, Object>	saveMap			= new HashMap<String, Object>();
		saveMap.put("ORDE_IDEN_NUMB" , ordeIdenNumb);
		saveMap.put("ORDE_SEQU_NUMB" , ordeSequNumb);
		saveMap.put("PURC_IDEN_NUMB" , purcIdenNumb);
		saveMap.put("reason" , reason);
		saveMap.put("userId" , loginUserDto.getUserId());
		String errMsg = "";
		try{
            errMsg = purchaseSvc.addProdChk(ordeIdenNumb, ordeSequNumb, "59");
            if("".equals(errMsg) == false){
                throw new Exception();
            }
            purchaseSvc.purcCancStart(saveMap);
		}catch(Exception e){
			errMsg = "".equals(errMsg) ? CommonUtils.getErrSubString(e,50) : errMsg;
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
	/** * 주문 상세 - 주문 취소 */
	@RequestMapping("orderCancel.sys")
	public ModelAndView orderCancelTransGrid(
			@RequestParam(value = "orde_iden_numb", defaultValue = "") String orde_iden_numb, 			// 주문번호
			@RequestParam(value = "reason", required = true) String chan_reas_desc,									// 수정사유
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb", orde_iden_numb);
		saveMap.put("chan_reas_desc", chan_reas_desc);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		
		/*----------------주문상태 값 세팅--------------------*/
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("orde_iden_numb_Arr", orde_iden_numb);
		String orderStatFlag = "";
		String errMsg = "";
		try {
			orderStatFlag = orderRequestSvc.orderStatCheck(params);
			errMsg = purchaseSvc.addProdChk(orde_iden_numb.split("-")[0], orde_iden_numb.split("-")[1], "99");
			if("".equals(errMsg) == false){
				throw new Exception();
			}
			if(orderStatFlag.indexOf("승인요청") >=0 || orderStatFlag.indexOf("주문요청") >=0 || orderStatFlag.indexOf("주문의뢰") >= 0 && orderStatFlag.indexOf("주문접수") < 0 && orderStatFlag.indexOf("배송중") < 0){
//				orderRequestSvc.setOrderRequestCancel(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 	// update 작업
				orderRequestSvc.setOrderRequestCancelIncludeAddProd(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 	// update 작업
			}
		} catch(Exception e) {
			errMsg = "".equals(errMsg) ? CommonUtils.getErrSubString(e,50) : errMsg;
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(errMsg);	//Option(To Detail Message)
		}

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		modelAndView.addObject("orderStatFlag",orderStatFlag);
		return modelAndView;
	}
	
	/**
	 * 주문조회(주문승인) 
	 */
	@RequestMapping("approvalOrderListBuy.sys")
	public ModelAndView getApprovalOrderListBuy( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/orderRequest/approvalOrderListBuy");
		mav.addObject("isApproval", true);
		return mav;
	}
	
	/** 주문 승인*/
	@RequestMapping("orderRequestApproval.sys")
	public ModelAndView orderRequestApprovalTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문수량
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	        orderRequestSvc.setOrderRequestApproval(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 	// Insert 작업 
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
	/** 주문 반려*/
	@RequestMapping("orderRequestReject.sys")
	public ModelAndView orderRequestRejectTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문수량
			@RequestParam(value = "reason", required=true) String reason,		// 반려사항
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("reason", reason);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	        orderRequestSvc.setOrderRequestReject(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 	// Insert 작업 
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
	
	
	
	/** 고객사 : 감독관 사용자의 승인 반려 */
	@RequestMapping("procDirectOrder.sys")
	public ModelAndView procDirectOrder(
			@RequestParam(value="orde_iden_numb_array[]", required=true)	String[] ordeIdenNumb_array, 		
			@RequestParam(value="flag"		, required=true) String flag,
			@RequestParam(value = "reason", defaultValue = "") String reason,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		CustomResponse		customResponse	= new CustomResponse(true);
		LoginUserDto		loginUserDto	=(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME); 
		Map<String, Object>	saveMap			= new HashMap<String, Object>();
		saveMap.put("ordeIdenNumb_array" , ordeIdenNumb_array);
		saveMap.put("flag" , flag);
		saveMap.put("reason" , reason);
		saveMap.put("userId" , loginUserDto.getUserId());
		saveMap.put("branchid" , loginUserDto.getBorgId());
		try{
			orderRequestSvc.procDirectOrder(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error!....");
			customResponse.setMessage(e.getMessage());
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
	
	/** * 고객사 반품요청 프로세스 : 추가상품 관련 배열 처리*/
	@RequestMapping("returnOrderProcessTransGrid.sys")
	public ModelAndView returnOrderProcessTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		
			@RequestParam(value = "deli_iden_numb_array[]", required=true) String[] deli_iden_numb_array,		
			@RequestParam(value = "rece_iden_numb_array[]", required=true) String[] rece_iden_numb_array,		
			
			@RequestParam(value = "return_requ_quan", required = true) String return_requ_quan, 				// 반품수량
			@RequestParam(value = "reason", required = true) String reason, 										// 변경사유
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		saveMap.put("rece_iden_numb_array", rece_iden_numb_array);
		
		saveMap.put("retu_prod_quan", return_requ_quan);
		saveMap.put("chan_reas_desc", reason);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			returnOrderSvc.returnOrderProcessForArray(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	
	
	/** 고객사 발주서 출력 여부 업데이트 */
	@RequestMapping("updateMrordmIsPurcPrint.sys")
	public ModelAndView updateMrordmIsPurcPrint( ModelAndView modelAndView, HttpServletRequest request, ModelMap paramMap) throws Exception{
		CustomResponse		customResponse = new CustomResponse(true);
		try{
			this.purchaseSvc.updateMrordmIsPurcPrint(paramMap);
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
}
