package kr.co.bitcube.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dto.OrderDeliDto;
import kr.co.bitcube.order.dto.OrderReceiveDto;
import kr.co.bitcube.order.service.DeliverySvc;
import kr.co.bitcube.order.service.OrderCommonSvc;
import kr.co.bitcube.order.service.PurchaseSvc;
import kr.co.bitcube.organ.dto.SmpUsersDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping("order/delivery")
public class DeliveryCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private DeliverySvc deliverySvc;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private PurchaseSvc purchaseSvc;
	
	/** * 주문 상세에서 출하 조회 */
	@RequestMapping("deliveryListForOrderDetail.sys")
	public ModelAndView getDeliveryListForOrderDetailJQGrid(
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String orde_iden_numb,							// 주문번호 + 주문차수
			@RequestParam(value = "srcPurcIdenNumb", defaultValue = "") String purc_iden_numb, 							// 발주차수
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orde_iden_numb", orde_iden_numb);
		params.put("purc_iden_numb", purc_iden_numb);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        List<OrderDeliDto> list  = deliverySvc.getDeliveryListForOrderDetail(params);
		mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	/** * 출하 정보 수정 */
	@RequestMapping("deliveryStatusChange.sys")
	public ModelAndView deliveryStatusChangeTransGrid(
			@RequestParam(value = "orde_iden_numb", required = true) String orde_iden_numb, 					// 주문번호
			@RequestParam(value = "purc_iden_numb", required = true) String purc_iden_numb,						// 발주차수
			@RequestParam(value = "deli_iden_numb", required = true) String deli_iden_numb,						// 출하차수
			@RequestParam(value = "deliStatFlagValue", required = true) String deliStatFlagValue,				// 주문상태
			@RequestParam(value = "reason", required = true) String chan_reas_desc,								// 수정사유
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb", orde_iden_numb);
		saveMap.put("purc_iden_numb", purc_iden_numb);
		saveMap.put("deli_iden_numb", deli_iden_numb);
		saveMap.put("deli_stat_flag",deliStatFlagValue);
		saveMap.put("chan_reas_desc", chan_reas_desc);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = "";
		try {
			errMsg = purchaseSvc.addProdChk(orde_iden_numb.split("-")[0], orde_iden_numb.split("-")[1], "93");
			if("".equals(errMsg) == false){
				throw new Exception();
			}
			deliverySvc.deliveryStatusChange(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
		} catch(Exception e) {
			errMsg = "".equals(errMsg) ? CommonUtils.getErrSubString(e,50) : errMsg;
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(errMsg);	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/** * 출하 */
	@RequestMapping("deliveryList.sys")
	public ModelAndView getDeliveryList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		List<CodesDto> orderTypeCode = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
		List<CodesDto> deliveryType = commonSvc.getCodeList("DELIVERYTYPE", 1, "");
		mav.setViewName("order/delivery/deliveryList");
        mav.addObject("orderTypeCode", orderTypeCode);
        mav.addObject("deliveryType", deliveryType);
		return mav;
	}
	/** * 출하처리 그리드 */
	@RequestMapping("deliveryListJQGrid.sys")
	public ModelAndView getPurchaseListJQGrid( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 출하예정일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 출하예정일자 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,							// 주문유형
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,								// 주문상태
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,											// 물류센터
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,											// 물류센터
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcPurcStartDate",srcPurcStartDate);		params.put("srcPurcEndDate", srcPurcEndDate);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		params.put("srcOrdeTypeClas", srcOrdeTypeClas);		params.put("srcOrdeStatFlag", srcOrdeStatFlag);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		//----------------페이징 세팅------------/
        int records = deliverySvc.getDeliveryListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<OrderDeliDto> list = null;
        if(records>0){
        	list = deliverySvc.getDeliveryList(params, page, rows);
        	
        	for(int i = 0 ; i < list.size() ; i++){
        		double purc_requ_quan = Double.parseDouble(list.get(i).getPurc_requ_quan());
        		double deli_prod_quan = list.get(i).getDeli_prod_quan();
        		double to_do_deli_prod_quan = purc_requ_quan - deli_prod_quan;
        		list.get(i).setTo_do_deli_prod_quan(to_do_deli_prod_quan);
        	}
        }
         
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	/** * 출하처리 */
	@RequestMapping("insertDeliveryTransGrid.sys")
	public ModelAndView insertDeliveryTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,						// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,						// 발주차수
			@RequestParam(value = "to_do_deli_prod_quan_array[]", required=true) String[] to_do_deli_prod_quan_array,		// 출하할수량
//			@RequestParam(value = "deliveryType_array[]", required=true) String[] deliveryType_array,								// 배송유형
//			@RequestParam(value = "deliveryNumber_array[]", required=true) String[] deliveryNumber_array,						// 송장(전화)번호
			@RequestParam(value = "vendorIdArray[]", required=true) String[] vendorIdArray,											// 공급사 ID
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("to_do_deli_prod_quan_array", to_do_deli_prod_quan_array);
//		saveMap.put("deliveryType_array", deliveryType_array);
//		saveMap.put("deliveryNumber_array", deliveryNumber_array);
		saveMap.put("vendorIdArray", vendorIdArray);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	       String returnReceiptNum =  deliverySvc.insertDeliveryInfo(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 
	       custResponse.setMessage(returnReceiptNum);
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
	
	/** 송장번호 업데이트 */
	@RequestMapping("setDeliInfoTransGrid.sys")
	public ModelAndView setDeliInfoTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,						// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,						// 발주차수
			@RequestParam(value = "deli_iden_numb_array[]", required=true) String[] deli_iden_numb_array,						// 출하차수
			@RequestParam(value = "deli_type_clas_array[]", required=true) String[] deli_type_clas_array,								// 배달 유형
			@RequestParam(value = "deli_invo_iden_array[]", required=true) String[] deli_invo_iden_array,							// 송장(전화)번호
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		saveMap.put("deli_type_clas_array", deli_type_clas_array);
		saveMap.put("deli_invo_iden_array", deli_invo_iden_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	       deliverySvc.setDeliveryInvoInfo(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 
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
	/** * 발주접주 상태로 변경 */
	@RequestMapping("updatePurcStatusTransGrid.sys")
	public ModelAndView updatePurcStatusTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "reason", required=true) String reason,												// 발주거부 사유
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("chan_reas_desc", reason);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	        deliverySvc.updatePurcStatus(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 
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
	
	/** * 배송완료 */
	@RequestMapping("deliCompleteList.sys")
	public ModelAndView getDeliCompleteList(HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		List<CodesDto> orderTypeCode = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
		List<CodesDto> deliveryType = commonSvc.getCodeList("DELIVERYTYPE", 1, "");
		List<CodesDto> orderStatFlag = commonSvc.getCodeList("ORDERSTATUSFLAGCD", 1, "");
		mav.setViewName("order/delivery/deliCompleteList");
        mav.addObject("deliveryType", deliveryType);
		mav.addObject("orderTypeCode", orderTypeCode);
		mav.addObject("orderStatFlag", orderStatFlag);
		return mav;
	}
	/** * 배송완료 그리드 */
	@RequestMapping("deliCompleteListJQGrid.sys")
	public ModelAndView getDeliCompleteListJQGrid( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										
			@RequestParam(value = "srcDeliStartDate", defaultValue = "") String srcDeliStartDate,										
			@RequestParam(value = "srcDeliEndDate", defaultValue = "") String srcDeliEndDate,										
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,										
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,										
			@RequestParam(value = "srcDeliStatFlag", defaultValue = "") String srcDeliStatFlag,										
			@RequestParam(value = "srcIsDelivery", defaultValue = "") String srcIsDelivery,										
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,										
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	
			// 상품규격 추가
			@RequestParam(value = "prodSpec", defaultValue = "") String prodSpec,
			@RequestParam(value = "prodStSpec", defaultValue = "") String prodStSpec,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcDeliStartDate", srcDeliStartDate);		params.put("srcDeliEndDate", srcDeliEndDate);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		params.put("srcOrdeTypeClas", srcOrdeTypeClas);		params.put("srcDeliStatFlag", srcDeliStatFlag);		params.put("srcIsDelivery", srcIsDelivery);		params.put("srcCenFlag", srcCenFlag);		params.put("srcWorkInfoUser", srcWorkInfoUser);		params.put("prodSpec", prodSpec);		params.put("prodStSpec", prodStSpec);		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		//----------------페이징 세팅------------/
        int records = deliverySvc.getDeliCompleteListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<OrderDeliDto> list = null;
        if(records>0) list = deliverySvc.getDeliCompleteList(params, page, rows); 
         
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	/** * 배송완료 상태로 변경 */
	@RequestMapping("updateIsDeliveryTransGrid.sys")
	public ModelAndView updateIsDeliveryTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "deli_iden_numb_array[]", required=true) String[] deli_iden_numb_array,		// 출하차수
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	        deliverySvc.updateIsDelivery(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 
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
	
	/** * 인수확인 */
	@RequestMapping("receiveList.sys")
	public ModelAndView getReceiveList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		mav.setViewName("order/delivery/receiveList");
		return mav;
	}
	/** * 인수확인 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("receiveListJQGrid.sys")
	public ModelAndView receiveListJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															
			@RequestParam(value = "sord", defaultValue = "") String sord,															
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,	
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,		
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,	
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,	
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	
			@RequestParam(value = "srcIsDeliClasExist", defaultValue = "") String srcIsDeliClasExist,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrderUserId", srcOrderUserId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcIsDeliClasExist", srcIsDeliClasExist);
		//----------------페이징 세팅------------/
        int records = deliverySvc.getReceiveListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<OrderDeliDto> list = null; 
        if(records>0) list = deliverySvc.getReceiveList(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/** * 운영사 인수확인 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("selectReceiveList.sys")
	public ModelAndView selectReceiveList(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															
			@RequestParam(value = "sord", defaultValue = "") String sord,															
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,	
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,		
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,	
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,	
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	
			@RequestParam(value = "srcIsDeliClasExist", defaultValue = "") String srcIsDeliClasExist,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrderUserId", srcOrderUserId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcIsDeliClasExist", srcIsDeliClasExist);
		//----------------페이징 세팅------------/
        int records = deliverySvc.selectReceiveListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<OrderDeliDto> list = null; 
        if(records>0) list = deliverySvc.selectReceiveList(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	
	/** * 인수확인 처리 진행 */
	@RequestMapping("orderReceiveProcess.sys")
	public ModelAndView orderReceiveProcessTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "deli_iden_numb_array[]", required=true) String[] deli_iden_numb_array,		// 출하차수
			@RequestParam(value = "deli_prod_quan_array[]", required=true) String[] deli_prod_quan_array,		// 인수수량
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		saveMap.put("deli_prod_quan_array", deli_prod_quan_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			deliverySvc.admOrderReceiveProcess(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	
	/** * 선발주인수처리 */
	@RequestMapping("firstPurchaseHandleList.sys")
	public ModelAndView getFirstPurchaseHandleList( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
        mav.addObject("workInfoList", workInfoList);
		mav.setViewName("order/delivery/firstPurchaseHandleList");
		return mav;
	}
	
	/** * 선발주인수처리 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("firstPurchaseHandleListJQGrid.sys")
	public ModelAndView firstPurchaseHandleListJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															
			@RequestParam(value = "sord", defaultValue = "") String sord,															
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,	
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,		
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		//----------------페이징 세팅------------/
        int records = deliverySvc.getFirstPurchaseHandleList(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<OrderDeliDto> list = null; 
        if(records>0) list = deliverySvc.getFirstPurchaseHandleList(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/** * 선발주 실 인수처리-내역확인 팝업 */
	@RequestMapping("firstPurchaseHandlePop.sys")
	public ModelAndView getFirstPurchaseHandlePop(
			@RequestParam(value = "orde_iden_numb", required = true) String orde_iden_numb,
			@RequestParam(value = "purc_iden_numb", defaultValue = "") String purc_iden_numb,	
			@RequestParam(value = "deli_iden_numb", defaultValue = "") String deli_iden_numb,	
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/delivery/firstPurchaseHandlePop");
		mav.addObject("orde_iden_numb", orde_iden_numb);
		mav.addObject("purc_iden_numb", purc_iden_numb);
		mav.addObject("deli_iden_numb", deli_iden_numb);
		return mav;
	}
	
	/** * 선발주 실 인수처리-내역확인 팝업 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("firstPurchaseHandlePopListJQGrid.sys")
	public ModelAndView getFirstPurchaseHandlePopListJQGrid( 
			@RequestParam(value = "orde_iden_numb", required = true) String orde_iden_numb,
			@RequestParam(value = "purc_iden_numb", defaultValue = "") String purc_iden_numb,	
			@RequestParam(value = "deli_iden_numb", defaultValue = "") String deli_iden_numb,	
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,															
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orde_iden_numb", orde_iden_numb);
		params.put("purc_iden_numb", purc_iden_numb);
		params.put("deli_iden_numb", deli_iden_numb);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        List<OrderReceiveDto> list = deliverySvc.getFirstPurchaseHandlePopList(params);
		mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	
	/** * 선발주 주문의 실인수확인 처리 진행 */
	@RequestMapping("firstPurchaseHandleTransGrid.sys")
	public ModelAndView setFirstPurchaseHandleTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "deli_iden_numb_array[]", required=true) String[] deli_iden_numb_array,		// 출하차수
			@RequestParam(value = "to_do_rece_prod_quan_array[]", required=true) String[] to_do_rece_prod_quan_array,	// 실인수수량
			@RequestParam(value = "deli_prod_quan_array[]", required=true) String[] deli_prod_quan_array,	// 고객인수수량 
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		saveMap.put("to_do_rece_prod_quan_array", to_do_rece_prod_quan_array);
		saveMap.put("deli_prod_quan_array", deli_prod_quan_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			deliverySvc.firstPurchaseHandle(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	 * 물류센터 - 출고 확정
	 */
	@RequestMapping("cenDeliveryList.sys")
	public ModelAndView getCenDeliveryList( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<CodesDto> orderTypeCode = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
		List<CodesDto> deliveryType = commonSvc.getCodeList("DELIVERYTYPE", 1, "");
        mav.addObject("orderTypeCode", orderTypeCode);
        mav.addObject("deliveryType", deliveryType);
		mav.setViewName("order/delivery/cenDeliveryList");
		return mav;
	}
	
	/** * 물류센터 - 배송완료 */
	@RequestMapping("cenDeliCompleteList.sys")
	public ModelAndView getCenDeliCompleteList( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<CodesDto> orderTypeCode = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
		List<CodesDto> orderStatFlag = commonSvc.getCodeList("ORDERSTATUSFLAGCD", 1, "");
		List<CodesDto> deliveryType = commonSvc.getCodeList("DELIVERYTYPE", 1, "");
		mav.setViewName("order/delivery/cenDeliCompleteList");
		mav.addObject("orderTypeCode", orderTypeCode);
		mav.addObject("orderStatFlag", orderStatFlag);
		mav.addObject("deliveryType", deliveryType);
		return mav;
	}
	
	/** * 물류센터 - 인수확인 */
	@RequestMapping("cenReceiveList.sys")
	public ModelAndView getCenReceiveList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/delivery/cenReceiveList");
		return mav;
	}
	/** * 물류센터 - 인수내역 */
	@RequestMapping("cenReceiveCommitList.sys")
	public ModelAndView getCenReceiveCommitList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/delivery/cenReceiveList");
		return mav;
	}
	/** * 인수확인 처리 진행 */
	@RequestMapping("orderReceiveCenProcess.sys")
	public ModelAndView orderReceiveCenProcessTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "deli_iden_numb_array[]", required=true) String[] deli_iden_numb_array,		// 출하차수
			@RequestParam(value = "deli_prod_quan_array[]", required=true) String[] deli_prod_quan_array,		// 인수수량
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		saveMap.put("deli_prod_quan_array", deli_prod_quan_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			deliverySvc.orderReceiveCenProcess(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	
	
	/** * 택배회사의 주소를 조회한다  */
	@RequestMapping("getDeliVendor.sys")
	public ModelAndView getDeliVendor(
			@RequestParam(value = "deli_type_clas", required = false) String deli_type_clas,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		List<CodesDto> codeList = commonSvc.getCodeList("DELIVERYTYPE", 1, "");
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("codeList", codeList);
		return modelAndView;
	}
	
	/** 선정산 관련 히스토리 팝업을 호출한다. */ 
	@RequestMapping("deliShowHistPop.sys")
	public ModelAndView getDeliShowHist(
			@RequestParam(value = "orde_iden_numb", required = false) String orde_iden_numb,
			@RequestParam(value = "purc_iden_numb", required = false) String purc_iden_numb,
			@RequestParam(value = "deli_iden_numb", required = false) String deli_iden_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("order/delivery/deliShowHistPop");
		modelAndView.addObject("orde_iden_numb", orde_iden_numb);
		modelAndView.addObject("purc_iden_numb", purc_iden_numb);
		modelAndView.addObject("deli_iden_numb", deli_iden_numb);
		return modelAndView;
	}
	
	/** 선정산 관련 히스토리 조회 */
	@RequestMapping("deliShowHistJQGrid.sys")
	public ModelAndView getDeliShowHistJQGrid( 
			@RequestParam(value = "orde_iden_numb", required = true) String orde_iden_numb,
			@RequestParam(value = "purc_iden_numb", required = true) String purc_iden_numb,	
			@RequestParam(value = "deli_iden_numb", required = true) String deli_iden_numb,	
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,															
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orde_iden_numb", orde_iden_numb);
		params.put("purc_iden_numb", purc_iden_numb);
		params.put("deli_iden_numb", deli_iden_numb);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        List<OrderReceiveDto> list = deliverySvc.getDeliShowHist(params);
		mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	
	/** 선정산 히스토리 저장 프로세스*/
	@RequestMapping("realDeliveryInfoTransGrid.sys")
	public ModelAndView setRealDeliveryInfoTransGrid(
			@RequestParam(value = "orde_iden_numb", required=true) String orde_iden_numb,
			@RequestParam(value = "purc_iden_numb", required=true) String purc_iden_numb,
			@RequestParam(value = "deli_iden_numb", required=true) String deli_iden_numb,
			@RequestParam(value = "realDeliveryQuan", required=true) String realDeliveryQuan,
			@RequestParam(value = "deliDate", required=true) String deliDate,
			@RequestParam(value = "deliDesc", defaultValue = "") String deliDesc,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb", orde_iden_numb);
		saveMap.put("purc_iden_numb", purc_iden_numb);
		saveMap.put("deli_iden_numb", deli_iden_numb);
		saveMap.put("delivery_quan", realDeliveryQuan);
		saveMap.put("delivery_date", deliDate);
		saveMap.put("delivery_desc", deliDesc);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			deliverySvc.setRealDeliveryInfo(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	
	/** 선정산 히스토리 삭제 프로세스*/
	@RequestMapping("deleteRealDeliveryInfoTransGrid.sys")
	public ModelAndView deleteRealDeliveryInfoTransGrid(
			@RequestParam(value = "mracptsub_id", required=true) String mracptsub_id,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("mracptsub_id", mracptsub_id);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			deliverySvc.deleteRealDeliveryInfo(saveMap);
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
	
	/** 인수증 이미지 파일 저장*/
	@RequestMapping("updateReceiptImgFileTransGrid.sys")
	public ModelAndView updateReceiptImgFileTransGrid(
			@RequestParam(value = "target_receipt_num", required=true) String target_receipt_num, // 인수증 번호
			@RequestParam(value = "rtn_file_seq", required=true) String rtn_file_seq,					// 첨부파일 저장된 seq 값
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("target_receipt_num", target_receipt_num);
		saveMap.put("rtn_file_seq", rtn_file_seq);
		
		CustomResponse custResponse = new CustomResponse(true);
		try {
			deliverySvc.updateReceiptImgFile(saveMap);
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
	
	/** * 출하 대량 엑셀 다운로드*/
	@RequestMapping("deliveryListExcelView.sys")
	public ModelAndView getDeliveryListExcelView( 
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 출하예정일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 출하예정일자 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,							// 주문유형
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,								// 주문상태
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,											// 물류센터
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,											// 물류센터
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,		
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,	
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcPurcStartDate",srcPurcStartDate);		params.put("srcPurcEndDate", srcPurcEndDate);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		params.put("srcOrdeTypeClas", srcOrdeTypeClas);		params.put("srcOrdeStatFlag", srcOrdeStatFlag);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		
		List<Map<String, Object>> list = deliverySvc.getDeliveryListExcelView(params); 

        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", list);
        sheetList.add(map1);
        mav.setViewName("commonExcelViewResolver");
        mav.addObject("excelFileName", excelFileName);
        mav.addObject("sheetList", sheetList);
		
//		mav.setViewName("commonExcelViewResolver");
//		mav.addObject("sheetTitle", sheetTitle);
//		mav.addObject("excelFileName", excelFileName);
//		mav.addObject("colLabels", colLabels);
//		mav.addObject("colIds", colIds);
//		mav.addObject("numColIds", numColIds);
//		mav.addObject("figureColIds", figureColIds);
//		mav.addObject("colDataList", list);		
		return mav;
	}
	
	/** * 배송완료 대량 엑셀 다운로드*/
	@RequestMapping("deliCompleteListExcelView.sys")
	public ModelAndView getDeliCompleteListExcelView( 
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										
			@RequestParam(value = "srcDeliStartDate", defaultValue = "") String srcDeliStartDate,										
			@RequestParam(value = "srcDeliEndDate", defaultValue = "") String srcDeliEndDate,										
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,										
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,										
			@RequestParam(value = "srcDeliStatFlag", defaultValue = "") String srcDeliStatFlag,										
			@RequestParam(value = "srcIsDelivery", defaultValue = "") String srcIsDelivery,										
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,										
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,										
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,			
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,		
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcDeliStartDate", srcDeliStartDate);		params.put("srcDeliEndDate", srcDeliEndDate);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		params.put("srcOrdeTypeClas", srcOrdeTypeClas);		params.put("srcDeliStatFlag", srcDeliStatFlag);		params.put("srcIsDelivery", srcIsDelivery);		params.put("srcCenFlag", srcCenFlag);		params.put("srcWorkInfoUser", srcWorkInfoUser);         
		List<Map<String, Object>> list = deliverySvc.getDeliCompleteListExcelView(params); 
        
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", list);
        sheetList.add(map1);
        mav.setViewName("commonExcelViewResolver");
        mav.addObject("excelFileName", excelFileName);
        mav.addObject("sheetList", sheetList);
		
//		mav.setViewName("commonExcelViewResolver");
//		mav.addObject("sheetTitle", sheetTitle);
//		mav.addObject("excelFileName", excelFileName);
//		mav.addObject("colLabels", colLabels);
//		mav.addObject("colIds", colIds);
//		mav.addObject("numColIds", numColIds);
//		mav.addObject("figureColIds", figureColIds);
//		mav.addObject("colDataList", list);		
		return mav;
	}
	
	/** 인수확인 대략 엑셀 다운로드  */
	@RequestMapping("receiveListExcelView.sys")
	public ModelAndView receiveListExcelView(
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,	
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,		
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,	
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,	
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	
			@RequestParam(value = "srcIsDeliClasExist", defaultValue = "") String srcIsDeliClasExist,	

			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,			
			ModelAndView mav, HttpServletRequest request) throws Exception {
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcIsDeliClasExist", srcIsDeliClasExist);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("srcCenFlag", srcCenFlag);
		
		List<Map<String, Object>> list = deliverySvc.getReceiveListExcelView(params);
        
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", list);
        sheetList.add(map1);
        mav.setViewName("commonExcelViewResolver");
        mav.addObject("excelFileName", excelFileName);
        mav.addObject("sheetList", sheetList);
		
//		mav.setViewName("commonExcelViewResolver");
//		mav.addObject("sheetTitle", sheetTitle);
//		mav.addObject("excelFileName", excelFileName);
//		mav.addObject("colLabels", colLabels);
//		mav.addObject("colIds", colIds);
//		mav.addObject("numColIds", numColIds);
//		mav.addObject("figureColIds", figureColIds);
//		mav.addObject("colDataList", list);		
		return mav;
	}
	
	
	
	/** 배송처리  */
	@RequestMapping("deliProcList.sys")
	public ModelAndView getDeliProcList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		List<CodesDto> orderTypeCode = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
		List<CodesDto> deliveryType = commonSvc.getCodeList("DELIVERYTYPE", 1, "");
        mav.addObject("orderTypeCode", orderTypeCode);
        mav.addObject("deliveryType", deliveryType);
        mav.setViewName("order/delivery/deliProcList");
		return mav;
	}
	
	/** 배송처리 그리드 */
	@RequestMapping("deliProcGrid.sys")
	public ModelAndView getdeliProcGrid( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 출하예정일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 출하예정일자 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,							// 주문유형
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,								// 주문상태
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,											// 물류센터
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,											// 물류센터
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcPurcStartDate",srcPurcStartDate);
		params.put("srcPurcEndDate", srcPurcEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrdeTypeClas", srcOrdeTypeClas);
		params.put("srcOrdeStatFlag", srcOrdeStatFlag);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		
		//----------------페이징 세팅------------/
        int records = deliverySvc.getDeliveryListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<OrderDeliDto> list = null;
        if(records>0){
        	list = deliverySvc.getDeliveryList(params, page, rows);
        	
        	for(int i = 0 ; i < list.size() ; i++){
        		double purc_requ_quan = Double.parseDouble(list.get(i).getPurc_requ_quan());
        		double deli_prod_quan = list.get(i).getDeli_prod_quan();
        		double to_do_deli_prod_quan = purc_requ_quan - deli_prod_quan;
        		list.get(i).setTo_do_deli_prod_quan(to_do_deli_prod_quan);
        	}
        }
         
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	/** * 배송처리 그리드 */
	@RequestMapping("deliProcQGrid.sys")
	public ModelAndView getDeliProcJQGrid( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 출하예정일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 출하예정일자 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,							// 주문유형
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,								// 주문상태
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,											// 물류센터
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,											// 물류센터
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcPurcStartDate",srcPurcStartDate);		params.put("srcPurcEndDate", srcPurcEndDate);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		params.put("srcOrdeTypeClas", srcOrdeTypeClas);		params.put("srcOrdeStatFlag", srcOrdeStatFlag);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		//----------------페이징 세팅------------/
        int records = deliverySvc.getDeliProcListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<OrderDeliDto> list = null;
        if(records>0){
        	list = deliverySvc.getDeliProcList(params, page, rows);
        	for(int i = 0 ; i < list.size() ; i++){
        		double purc_requ_quan = Double.parseDouble(list.get(i).getPurc_requ_quan());
        		double deli_prod_quan = list.get(i).getDeli_prod_quan();
        		double to_do_deli_prod_quan = purc_requ_quan - deli_prod_quan;
        		list.get(i).setTo_do_deli_prod_quan(to_do_deli_prod_quan);
        	}
        }
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	/** * 배송처리 */
	@RequestMapping("insertDeliProc.sys")
	public ModelAndView insertDeliProc(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,						// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,						// 발주차수
			@RequestParam(value = "to_do_deli_prod_quan_array[]", required=true) String[] to_do_deli_prod_quan_array,		// 출하할수량
			@RequestParam(value = "deliveryType_array[]", required=true) String[] deliveryType_array,								// 배송유형
			@RequestParam(value = "deliveryNumber_array[]", required=true) String[] deliveryNumber_array,						// 송장(전화)번호
			@RequestParam(value = "vendorIdArray[]", required=true) String[] vendorIdArray,											// 공급사 ID
			@RequestParam(value = "deliDesc_array[]", required=false) String[] deliDesc_array,											// 공급사 ID
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("to_do_deli_prod_quan_array", to_do_deli_prod_quan_array);
		saveMap.put("deliveryType_array", deliveryType_array);
		saveMap.put("deliveryNumber_array", deliveryNumber_array);
		saveMap.put("deliDesc_array", deliDesc_array);
		saveMap.put("vendorIdArray", vendorIdArray);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	       String returnReceiptNum =  deliverySvc.insertDeliProc(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 
	       custResponse.setMessage(returnReceiptNum);
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
	
	/** * 배송정보 엑셀 다운로드*/
	@RequestMapping("deliProcListExcel.sys")
	public ModelAndView getDeliProcListExcel( 
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 출하예정일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 출하예정일자 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,							// 주문유형
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,								// 주문상태
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,											// 물류센터
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,											// 물류센터
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,		
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,	
			HttpServletRequest req, ModelAndView mav) throws Exception{
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcPurcStartDate",srcPurcStartDate);
		params.put("srcPurcEndDate", srcPurcEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrdeTypeClas", srcOrdeTypeClas);
		params.put("srcOrdeStatFlag", srcOrdeStatFlag);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		
		List<Map<String, Object>> list = deliverySvc.getDeliProcListExcelView(params); 
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList", list);
        sheetList.add(map1);
        mav.setViewName("commonExcelViewResolver");
        mav.addObject("excelFileName", excelFileName);
        mav.addObject("sheetList", sheetList);
		
//		mav.setViewName("commonExcelViewResolver");
//		mav.addObject("sheetTitle", sheetTitle);
//		mav.addObject("excelFileName", excelFileName);
//		mav.addObject("colLabels", colLabels);
//		mav.addObject("colIds", colIds);
//		mav.addObject("numColIds", numColIds);
//		mav.addObject("figureColIds", figureColIds);
//		mav.addObject("colDataList", list);		
		return mav;
	}
	
}
