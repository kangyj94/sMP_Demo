package kr.co.bitcube.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dto.OrderDto;
import kr.co.bitcube.order.dto.OrderPurtDto;
import kr.co.bitcube.order.service.OrderCommonSvc;
import kr.co.bitcube.order.service.PurchaseSvc;
import kr.co.bitcube.organ.dto.SmpUsersDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping("order/purchase")
public class PurchaseCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private PurchaseSvc purchaseSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	/**
	 * 주문 상세에서 물량배분 발주 대상 정보 조회
	 */
	@RequestMapping("purchaseForDivOrder.sys")
	public ModelAndView getPurchaseForDivOrderJQGrid( 
			@RequestParam(value = "orde_iden_numb", defaultValue = "") String orde_iden_numb, 							// 주문번호
			@RequestParam(value = "good_iden_numb", defaultValue = "") String good_iden_numb, 							// 주문번호
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orde_iden_numb", orde_iden_numb);
		params.put("good_iden_numb", good_iden_numb);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        List<OrderPurtDto> list  = purchaseSvc.getPurchaseForDivOrder(params);
		mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	/**
	 * 주문 상세에서 발주정보 조회
	 */
	@RequestMapping("purchaseForOrderDetail.sys")
	public ModelAndView getPurchaseForOrderDetailJQGrid( 
			@RequestParam(value = "orde_iden_numb", defaultValue = "") String orde_iden_numb, 							// 주문번호
			@RequestParam(value = "good_iden_numb", defaultValue = "") String good_iden_numb, 						// 상품번호
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orde_iden_numb", orde_iden_numb);
		params.put("good_iden_numb", good_iden_numb);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        List<OrderPurtDto> list  = purchaseSvc.getOrderDetailPurchaseList(params);
		mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	/**
	 * 물량배분 주문 발주의뢰
	 */
	@RequestMapping("orderDivPurcAddTransGrid.sys")
	public ModelAndView orderDivPurcAddTransGrid(
			@RequestParam(value = "orde_iden_numb", required = true) String orde_iden_numb, 					// 주문번호
			@RequestParam(value = "good_iden_numb", required = true) String good_iden_numb,					// 상품코드
			@RequestParam(value = "vendorid_array[]", required=true) String[] vendorid_array,						// 공급사코드
			@RequestParam(value = "orde_requ_quan_array[]", required=true) String[] orde_requ_quan_array,		// 발주요청수량
			@RequestParam(value = "orde_requ_pric_array[]", required=true) String[] orde_requ_pric_array,			// 판매단가
			@RequestParam(value = "sale_unit_pric_array[]", required=true) String[] sale_unit_pric_array,				// 매입단가
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb", orde_iden_numb);
		saveMap.put("good_iden_numb", good_iden_numb);
		saveMap.put("vendorid_array", vendorid_array);
		saveMap.put("orde_requ_quan_array", orde_requ_quan_array);
		saveMap.put("orde_requ_pric_array", orde_requ_pric_array);
		saveMap.put("sale_unit_pric_array", sale_unit_pric_array);
		
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			custResponse = purchaseSvc.getOrderDivPurcAdd(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	 * 발주 정보 수정 
	 */
	@RequestMapping("purcOrderStatusUpdate.sys")
	public ModelAndView orderPurcUpdateTransGrid(
			@RequestParam(value = "orde_iden_numb", required = true) String orde_iden_numb, 					// 주문번호
			@RequestParam(value = "purc_iden_numb", required = true) String purc_iden_numb,						// 발주차수
			@RequestParam(value = "purc_stat_flag", required = true) String purc_stat_flag,							// 주문상태
			@RequestParam(value = "reason", required = true) String chan_reas_desc,									// 수정사유
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb", orde_iden_numb);
		saveMap.put("purc_iden_numb", purc_iden_numb);
		saveMap.put("purc_stat_flag", purc_stat_flag);
		saveMap.put("chan_reas_desc", chan_reas_desc);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = "";
		try {
			errMsg = purchaseSvc.getOrderPurtUpdate(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
			if("".equals(errMsg) == false){
				throw new Exception();
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
		return modelAndView;
	}
			
	/**
	 * 발주접수
	 */
	@RequestMapping("purchaseList.sys")
	public ModelAndView getPurchaseList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		List<CodesDto> orderTypeCode = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
		mav.setViewName("order/purchase/purchaseList");
        mav.addObject("orderTypeCode", orderTypeCode);
		return mav;
	}
	/**
	 * 발주접수 그리드
	 */
	@RequestMapping("purchaseListJQGrid.sys")
	public ModelAndView getPurchaseListJQGrid( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 발주의뢰일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 발주의뢰일자 : 끝
			@RequestParam(value = "srcOrdeStartDate", defaultValue = "") String srcOrdeStartDate,							// 주문일 : 시작
			@RequestParam(value = "srcOrdeEndDate", defaultValue = "") String srcOrdeEndDate,								// 주문일 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,							// 주문유형
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,								// 주문상태
			@RequestParam(value = "srcPickingFlag", defaultValue = "") String srcPickingFlag,									// 물류센터 
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,									// 물류센터 
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcPurcStartDate", srcPurcStartDate);		params.put("srcPurcEndDate", srcPurcEndDate);		params.put("srcOrdeStartDate", srcOrdeStartDate);		params.put("srcOrdeEndDate", srcOrdeEndDate);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		params.put("srcOrdeTypeClas", srcOrdeTypeClas);		params.put("srcOrdeStatFlag", srcOrdeStatFlag);
		params.put("srcPickingFlag", srcPickingFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		//----------------페이징 세팅------------/
        int records = purchaseSvc.getPurchaseListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<OrderPurtDto> list = null;
        if(records>0) list = purchaseSvc.getPurchaseList(params, page, rows); 
         
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	/**
	 * 발주접수 그리드 : 상품명, 상품 규격 주문테이블에서 조회하게 쿼리 수정한 부분 적용.
	 */
	@RequestMapping("selectPurchaseList.sys")
	public ModelAndView selectPurchaseList( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 발주의뢰일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 발주의뢰일자 : 끝
			@RequestParam(value = "srcOrdeStartDate", defaultValue = "") String srcOrdeStartDate,							// 주문일 : 시작
			@RequestParam(value = "srcOrdeEndDate", defaultValue = "") String srcOrdeEndDate,								// 주문일 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,							// 주문유형
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,								// 주문상태
			@RequestParam(value = "srcPickingFlag", defaultValue = "") String srcPickingFlag,									// 물류센터 
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,									// 물류센터 
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcPurcStartDate", srcPurcStartDate);
		params.put("srcPurcEndDate", srcPurcEndDate);
		params.put("srcOrdeStartDate", srcOrdeStartDate);
		params.put("srcOrdeEndDate", srcOrdeEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrdeTypeClas", srcOrdeTypeClas);
		params.put("srcOrdeStatFlag", srcOrdeStatFlag);
		params.put("srcPickingFlag", srcPickingFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		//----------------페이징 세팅------------/
        int records = purchaseSvc.selectPurchaseListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<OrderPurtDto> list = null;
        if(records>0) list = purchaseSvc.selectPurchaseList(params, page, rows); 
         
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	/**
	 * 발주 접수 Update
	 */
	@RequestMapping("updatePurcReceiveStatusTransGrid.sys")
	public ModelAndView updatePurcReceiveStatusTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "deli_sche_date_array[]", required=true) String[] deli_sche_date_array,		// 납품예정일
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*
		//----------------저장값 세팅----------
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_sche_date_array", deli_sche_date_array);
		
		//-------------주문상태값 세팅-------------
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("orde_iden_numb_array", orde_iden_numb_array);
		params.put("purc_iden_numb_array", purc_iden_numb_array);
		List<OrderDto> list = new ArrayList<OrderDto>();
		//----------------처리수행 및 성공여부 세팅------------
		CustomResponse custResponse = new CustomResponse(true);
		try {
			list = purchaseSvc.orderStatCheck(params);
			purchaseSvc.updatePurcReceiveStatus(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		modelAndView.addObject("list",list);
		*/
		
		LoginUserDto		loginUserDto   = CommonUtils.getLoginUserDto(request); 
		String userId = loginUserDto.getUserId();
		String[] ordeIdenNumb_Array = new String[orde_iden_numb_array.length];
		String[] ordeSequNumb_Array = new String[orde_iden_numb_array.length];
		for(int i =0; i < orde_iden_numb_array.length;i++){
			String tmpOrd = orde_iden_numb_array[i];
            ordeIdenNumb_Array[i] = tmpOrd.split("-")[0];
            ordeSequNumb_Array[i] = tmpOrd.split("-")[1];
		}
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("ordeIdenNumb_Array", ordeIdenNumb_Array);
		saveMap.put("ordeSequNumb_Array", ordeSequNumb_Array);
		saveMap.put("purcIdenNumb_Array", purc_iden_numb_array);
		saveMap.put("deliScheDate_Array", deli_sche_date_array);
		saveMap.put("userId",             userId);
		
		CustomResponse		customResponse = new CustomResponse(true);
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
	 * 발주 거부
	 */
	@RequestMapping("updatePurcRejectStatusTransGrid.sys")
	public ModelAndView updatePurcRejectStatusTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호, 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "reason", required=true) String reason,										// 발주거부 사유
			@RequestParam(value = "vendorNm_array[]", required=true) String[] vendorNm_array,					// 공급사명
			@RequestParam(value = "vendorPhonenum_array[]", required=true) String[] vendorPhonenum_array,				// 공급사 대표번호
			@RequestParam(value = "orderUserMobile_array[]", required=true) String[] orderUserMobile_array,		// 인수자 전화번호
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("chan_reas_desc", reason);
		saveMap.put("vendorNm_array", vendorNm_array);
		saveMap.put("vendorPhonenum_array", vendorPhonenum_array);
		saveMap.put("orderUserMobile_array", orderUserMobile_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	        purchaseSvc.updatePurcRejectStatus(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	 * PICKING 등록 (발주접수)
	 */
	@RequestMapping("cenPurcAddList.sys")
	public ModelAndView getCenPurcAddList( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<CodesDto> orderTypeCode = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
		mav.setViewName("order/purchase/cenPurchaseList");
        mav.addObject("orderTypeCode", orderTypeCode);
		return mav;
	}
	
	
	
	/** 발주서 출력*/
	@RequestMapping("purchaseListPrint.sys")
	public ModelAndView getPurchasePrintList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/purchase/purchaseListPrint");
		return mav;
	}
	/** 발주서 리스트   */
	@RequestMapping("purchasePrintListJQGrid.sys")
	public ModelAndView getPurchasePrintList( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 발주의뢰일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 발주의뢰일자 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcPurcStartDate", srcPurcStartDate);		params.put("srcPurcEndDate", srcPurcEndDate);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		//----------------페이징 세팅------------/
        int records = purchaseSvc.getPurchasePrintListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<OrderPurtDto> list = null;
        if(records>0) list = purchaseSvc.getPurchasePrintList(params, page, rows); 
         
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	/** 발주 이력 */
	@RequestMapping("purchaseResultList.sys")
	public ModelAndView getPurchaseResultList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList); 											// 담당자 정보
	    }
		List<CodesDto> codeList = commonSvc.getCodeList("ORDERSTATUSFLAGCD", 1, ""); // 주문 상태
        mav.addObject("codeList", codeList);
		mav.setViewName("order/purchase/purchaseResultList");
		return mav;
	}
	
	/** 발주이력 리스트   */
	@RequestMapping("purchaseResultListJQGrid.sys")
	public ModelAndView getPurchaseResultListJQGrid( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 														// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,														// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,									// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,							// 발주의뢰일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,							// 발주의뢰일자 : 끝
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,								// 상품명
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,						// 담당자
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,					// 주문번호
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,							// 주문상태
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcPurcStartDate", srcPurcStartDate);		params.put("srcPurcEndDate", srcPurcEndDate);		params.put("srcGoodName", srcGoodName);		params.put("srcWorkInfoUser", srcWorkInfoUser);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		params.put("srcOrdeStatFlag", srcOrdeStatFlag);		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		//----------------페이징 세팅------------/
        Map<String, Object> records = purchaseSvc.getPurchasetResultListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)Integer.parseInt(records.get("CNT").toString()) / (float)rows);
        //----------------조회------------/
        List<OrderPurtDto> list = null;
        if(Integer.parseInt(records.get("CNT").toString()) > 0){
        	params.put("sum_orde_pric"		, records.get("SUM_ORDE_PRIC"));
			params.put("sum_orde_requ_quan"	, records.get("SUM_ORDE_REQU_QUAN"));
        }
        	list = purchaseSvc.getPurchaseResultListData(params, page, rows); 
         
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records.get("CNT"));
		mav.addObject("list", list);
		return mav;
	}
	
	/** 운영사 발주이력 리스트   */
	@RequestMapping("selectPurchaseResultList.sys")
	public ModelAndView selectPurchaseResultList( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "100") int rows,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 														// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,														// 정렬 조건
			// 조회 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,									// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,							// 발주의뢰일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,							// 발주의뢰일자 : 끝
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,								// 상품명
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,						// 담당자
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,					// 주문번호
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,							// 주문상태
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcPurcStartDate", srcPurcStartDate);
		params.put("srcPurcEndDate", srcPurcEndDate);
		params.put("srcGoodName", srcGoodName);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrdeStatFlag", srcOrdeStatFlag);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		//----------------페이징 세팅------------/
        Map<String, Object> records = purchaseSvc.selectPurchaseResultListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)Integer.parseInt(records.get("CNT").toString()) / (float)rows);
        //----------------조회------------/
        List<OrderPurtDto> list = null;
        if(Integer.parseInt(records.get("CNT").toString()) > 0){
        	params.put("sum_orde_pric"		, records.get("SUM_ORDE_PRIC"));
			params.put("sum_orde_requ_quan"	, records.get("SUM_ORDE_REQU_QUAN"));
        }
        	list = purchaseSvc.selectPurchaseResultList(params, page, rows); 
         
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records.get("CNT"));
		mav.addObject("list", list);
		return mav;
	}
	
	/** 발주이력 리스트   */
	@RequestMapping("purchaseResultListJQGridForPop.sys")
	public ModelAndView getPurchaseResultListJQGridForPop( 
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 														// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,														// 정렬 조건
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,									// 공급사
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,					// 주문번호
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        //----------------조회------------/
        List<OrderPurtDto> list = null;
        list = purchaseSvc.getPurchaseResultListDataForPop(params); 
		mav= new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	
	/** 발주접수 엑셀 다운로드 */
	@RequestMapping("purcListExcel.sys")
	public ModelAndView getPurcListExcel( 
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 발주의뢰일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 발주의뢰일자 : 끝
			@RequestParam(value = "srcOrdeStartDate", defaultValue = "") String srcOrdeStartDate,							// 주문일 : 시작
			@RequestParam(value = "srcOrdeEndDate", defaultValue = "") String srcOrdeEndDate,								// 주문일 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			@RequestParam(value = "srcOrdeTypeClas", defaultValue = "") String srcOrdeTypeClas,							// 주문유형
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,								// 주문상태
			@RequestParam(value = "srcPickingFlag", defaultValue = "") String srcPickingFlag,									// 물류센터 
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,									// 물류센터 

			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,		
			@RequestParam(value ="figureColIds"		, required = false) String[] figureColIds,	
			HttpServletRequest req, ModelAndView mav) throws Exception{
		
		//----------------조회조건 세팅------------/
		ModelMap params = new ModelMap();
		params.put("srcVendorId", srcVendorId);
		params.put("srcPurcStartDate", srcPurcStartDate);		params.put("srcPurcEndDate", srcPurcEndDate);		params.put("srcOrdeStartDate", srcOrdeStartDate);		params.put("srcOrdeEndDate", srcOrdeEndDate);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		params.put("srcOrdeTypeClas", srcOrdeTypeClas);		params.put("srcOrdeStatFlag", srcOrdeStatFlag);		params.put("srcPickingFlag", srcPickingFlag);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		List<Object> list = generalDao.selectGernalList("order.purchase.selectPurchaseExcelList", params );
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
        mav.setViewName("commonExcelViewResolver");
        mav.addObject("excelFileName", excelFileName);
        mav.addObject("sheetList", sheetList);
		
//		mav.setViewName("commonExcelViewResolver");
//		mav.addObject("sheetTitle", sheetTitle);
//		mav.addObject("excelFileName", excelFileName);
//		mav.addObject("colLabels", colLabels);
//		mav.addObject("colIds", colIds);
//		mav.addObject("numColIds", numColIds);
//		mav.addObject("colDataList", list);		
		return mav;
	}
	
	/** 발주이력 리스트 대량 엑셀 다운로드 */
	@RequestMapping("purchaseResultListExcelView.sys")
	public ModelAndView getPurchaseResultListExcelView( 
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,									// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,							// 발주의뢰일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,							// 발주의뢰일자 : 끝
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,								// 상품명
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,						// 담당자
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,					// 주문번호
			@RequestParam(value = "srcOrdeStatFlag", defaultValue = "") String srcOrdeStatFlag,							// 주문상태
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 														// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,														// 정렬 조건
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,	
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,			
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcPurcStartDate", srcPurcStartDate);		params.put("srcPurcEndDate", srcPurcEndDate);		params.put("srcGoodName", srcGoodName);		params.put("srcWorkInfoUser", srcWorkInfoUser);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);		params.put("srcOrdeStatFlag", srcOrdeStatFlag);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
				List<Map<String, Object>> list = purchaseSvc.getPurchaseResultListDataExcelView(params); 
         
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
			
		return mav;
	}
	
	/** 발주서 출력 메뉴 대량 엑셀 다운로드*/
	@RequestMapping("purchasePrintListExcelView.sys")
	public ModelAndView getPurchasePrintListExcelView( 
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,								// 발주의뢰일자 : 시작
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,								// 발주의뢰일자 : 끝
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,						// 주문번호 
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,			
			HttpServletRequest req, ModelAndView mav) throws Exception{
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);		params.put("srcPurcStartDate", srcPurcStartDate);		params.put("srcPurcEndDate", srcPurcEndDate);		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
				List<Map<String, Object>> list = purchaseSvc.getPurchasePrintListExcelView(params); 
        
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
//        map1.put("figureColIds", figureColIds);
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
//		mav.addObject("colDataList", list);		
		return mav;
	}
	
	
	/**
	 * 선입금 주문 주문의뢰 상태로 변경
	 */
	@RequestMapping("prePayPurcReceive.sys")
	public ModelAndView prePayPurcReceive(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,
			@RequestParam(value = "orde_sequ_numb_array[]", required=true) String[] orde_sequ_numb_array,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		CustomResponse customResponse = new CustomResponse(true);
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("orde_sequ_numb_array", orde_sequ_numb_array);
		saveMap.put("userId", loginUserDto.getUserId());
		try{
			purchaseSvc.prePayPurcReceive(saveMap);
		}catch(Exception e){
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage("System Excute Error...");
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
	
}
