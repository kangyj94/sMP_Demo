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
import kr.co.bitcube.order.dto.OrderReturnDto;
import kr.co.bitcube.order.dto.ParticularsTargetBranchsDto;
import kr.co.bitcube.order.service.OrderCommonSvc;
import kr.co.bitcube.order.service.ReturnOrderSvc;
import kr.co.bitcube.organ.dto.SmpUsersDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping("order/returnOrder")
public class ReturnOrderCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private ReturnOrderSvc returnOrderSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	/** * 인수내역/반품요청 */
	@RequestMapping("returnOrderRegist.sys")
	public ModelAndView getReturnOrderRegist( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		mav.setViewName("order/returnOrder/returnOrderRegist");
		return mav;
	}
	
	/** * 인수내역/반품요청 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("returnOrderRegistJQGrid.sys")
	public ModelAndView returnOrderRegistJQGrid(
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
			@RequestParam(value = "srcReturnStatFlag", defaultValue = "") String srcReturnStatFlag,	
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,	
			@RequestParam(value = "srcGoodsNm", defaultValue = "") String srcGoodsNm,	
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,	
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//주문상세번호 추출 By Seo
		String srcOrdeSequNumb = "";
		if(srcOrdeIdenNumb.length()>0) {
			String [] tmpSrcOrdeIdenNumb = srcOrdeIdenNumb.split("-");
			srcOrdeIdenNumb = tmpSrcOrdeIdenNumb[0];
			if(tmpSrcOrdeIdenNumb.length>1) {
				srcOrdeSequNumb = tmpSrcOrdeIdenNumb[1];
			}
		}
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrdeSequNumb", srcOrdeSequNumb);
		params.put("srcReturnStatFlag", srcReturnStatFlag);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcGoodsNm", srcGoodsNm);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------페이징 세팅------------/
        int records = returnOrderSvc.getReturnOrderRegistListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<OrderDeliDto> list = null; 
        if(records>0) list = returnOrderSvc.getReturnOrderRegistList(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/** * 운영사 : 인수내역/반품요청 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("selectReturnOrderRegist.sys")
	public ModelAndView selectReturnOrderRegist(
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
			@RequestParam(value = "srcReturnStatFlag", defaultValue = "") String srcReturnStatFlag,	
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,	
			@RequestParam(value = "srcGoodsNm", defaultValue = "") String srcGoodsNm,	
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,	
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//주문상세번호 추출 By Seo
		String srcOrdeSequNumb = "";
		if(srcOrdeIdenNumb.length()>0) {
			String [] tmpSrcOrdeIdenNumb = srcOrdeIdenNumb.split("-");
			srcOrdeIdenNumb = tmpSrcOrdeIdenNumb[0];
			if(tmpSrcOrdeIdenNumb.length>1) {
				srcOrdeSequNumb = tmpSrcOrdeIdenNumb[1];
			}
		}
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcOrdeSequNumb", srcOrdeSequNumb);
		params.put("srcReturnStatFlag", srcReturnStatFlag);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcGoodsNm", srcGoodsNm);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------페이징 세팅------------/
        int records = returnOrderSvc.selectReturnOrderRegistListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<OrderDeliDto> list = null; 
        if(records>0) list = returnOrderSvc.selectReturnOrderRegistList(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/** * 반품이력 상세 */
	@RequestMapping("returnOrderRegistDetail.sys")
	public ModelAndView getReturnOrderRegistDetail( 
			@RequestParam(value = "retu_iden_num", defaultValue = "") String retu_iden_num,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("retu_iden_num", retu_iden_num);
		OrderReturnDto detailInfo = this.returnOrderSvc.getReturnOrderRegistDetailInfo(searchMap);
		mav.setViewName("order/returnOrder/returnOrderRegistDetail");
		mav.addObject("detailInfo", detailInfo);
		return mav;
	}
	/** 반품이력 상세 공급사 */
	@RequestMapping("venReturnOrderRegistDetail.sys")
	public ModelAndView getVenReturnOrderRegistDetail( 
			@RequestParam(value = "retu_iden_num", defaultValue = "") String retu_iden_num,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("retu_iden_num", retu_iden_num);
		OrderReturnDto detailInfo = this.returnOrderSvc.getReturnOrderRegistDetailInfo(searchMap);
		mav.setViewName("order/returnOrder/returnOrderRegistDetail");
		mav.addObject("detailInfo", detailInfo);
		mav.addObject("ven", true);
		return mav;
	}
	
	/** * 반품요청내역 */
	@RequestMapping("returnOrderList.sys")
	public ModelAndView getreturnOrderList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		mav.setViewName("order/returnOrder/returnOrderList");
		return mav;
	}
	
	/** * 반품요청내역 조회 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("returnOrderListJQGrid.sys")
	public ModelAndView returnOrderListJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															
			@RequestParam(value = "sord", defaultValue = "") String sord,															
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,	
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,		
			@RequestParam(value = "srcReturnStartDate", defaultValue = "") String srcReturnStartDate,						
			@RequestParam(value = "srcReturnEndDate", defaultValue = "") String srcReturnEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcReturnStatFlag", defaultValue = "") String srcReturnStatFlag,	
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,	
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcReturnStartDate", srcReturnStartDate);
		params.put("srcReturnEndDate", srcReturnEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcReturnStatFlag", srcReturnStatFlag);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------페이징 세팅------------/
        int records = returnOrderSvc.getReturnOrderListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<OrderReturnDto> list = null; 
        if(records>0) list = returnOrderSvc.getReturnOrderList(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/** * 반품요청내역 */
	@RequestMapping("venReturnOrderList.sys")
	public ModelAndView getVenReturnOrderList( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<CodesDto> returnTypeCode = commonSvc.getCodeList("RETURNSTATUSFLAG", 1, "");
		mav.setViewName("order/returnOrder/venReturnOrderList");
		mav.addObject("returnTypeCode", returnTypeCode);
		return mav;
	}
	/** * 반품요청내역 */
	@RequestMapping("venReturnOrderListJQGrid.sys")
	public ModelAndView getVenReturnOrderListJQGrid( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															
			@RequestParam(value = "sord", defaultValue = "") String sord,															
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,	
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,		
			@RequestParam(value = "srcReturnStartDate", defaultValue = "") String srcReturnStartDate,						
			@RequestParam(value = "srcReturnEndDate", defaultValue = "") String srcReturnEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcReturnStatFlag", defaultValue = "") String srcReturnStatFlag,	
			@RequestParam(value = "srcIsCen", defaultValue = "") String srcIsCen,	
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcReturnStartDate", srcReturnStartDate);
		params.put("srcReturnEndDate", srcReturnEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcReturnStatFlag", srcReturnStatFlag);
		params.put("srcIsCen", srcIsCen);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------페이징 세팅------------/
        int records = returnOrderSvc.getVenReturnOrderListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<OrderReturnDto> list = null; 
        if(records>0) list = returnOrderSvc.getVenReturnOrderList(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/** * 반품요청 프로세스 */
	@RequestMapping("returnOrderProcessTransGrid.sys")
	public ModelAndView returnOrderProcessTransGrid(
			@RequestParam(value = "orde_iden_numb", required = true) String orde_iden_numb, 				// 주문번호
			@RequestParam(value = "purc_iden_numb", required = true) String purc_iden_numb, 				// 발주차수
			@RequestParam(value = "deli_iden_numb", required = true) String deli_iden_numb, 					// 출하차수
			@RequestParam(value = "rece_iden_numb", required = true) String rece_iden_numb, 					// 인수차수
			@RequestParam(value = "return_requ_quan", required = true) String return_requ_quan, 				// 반품수량
			@RequestParam(value = "reason", required = true) String reason, 										// 변경사유
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb", orde_iden_numb);
		saveMap.put("purc_iden_numb", purc_iden_numb);
		saveMap.put("deli_iden_numb", deli_iden_numb);
		saveMap.put("rece_iden_numb", rece_iden_numb);
		saveMap.put("retu_prod_quan", return_requ_quan);
		saveMap.put("chan_reas_desc", reason);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			returnOrderSvc.returnOrderProcess(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	/** * 반품요청 승인 */
	@RequestMapping("venOrderReturnApprovalTransGrid.sys")
	public ModelAndView venOrderReturnApprovalTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호 + 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "deli_iden_numb_array[]", required=true) String[] deli_iden_numb_array,		// 출하차수
			@RequestParam(value = "return_iden_numb_array[]", required=true) String[] return_iden_numb_array,	// 반품번호
			@RequestParam(value = "retu_prod_quan_array[]", required=true) String[] retu_prod_quan_array,		// 반품수량
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		saveMap.put("return_iden_numb_array", return_iden_numb_array);
		saveMap.put("retu_prod_quan_array", retu_prod_quan_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			returnOrderSvc.venOrderReturnApproval(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	
	/** * 반품요청 반려 */
	@RequestMapping("venOrderReturnRejectTransGrid.sys")
	public ModelAndView venOrderReturnRejectTransGrid(
			@RequestParam(value = "return_iden_numb_array[]", required=true) String[] return_iden_numb_array,	// 반품번호
			@RequestParam(value = "reason", required=true) String reason,										// 반품번호
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "deli_iden_numb_array[]", required=true) String[] deli_iden_numb_array,		// 출하차수
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("return_iden_numb_array",return_iden_numb_array);
		saveMap.put("retu_cnac_text", reason);
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			returnOrderSvc.venOrderReturnRejectTransGrid(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
	
	/** * 물류센터 인수내역 */
	@RequestMapping("cenReceiveCommitList.sys")
	public ModelAndView getCenReceiveCommitList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/returnOrder/cenReceiveCommitList");
		return mav;
	}
	
	/**
	 * 거래명세서 대상업체 선정
	 */
	@RequestMapping("getParticularsTargetBranchs.sys")
	public ModelAndView getParticularsTargetBranchs(
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,	
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,		
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,		
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,		
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,		
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		
        //----------------조회------------/
		try {
			List<ParticularsTargetBranchsDto> list = returnOrderSvc.getParticularsTargetBranchs(params);	
			modelAndView = new ModelAndView("jsonView");
			modelAndView.addObject("list", list);
		} catch (Exception e) {
			
		}
		return modelAndView;
	}
	
	/** 인수취소 프로세스 */
	@RequestMapping("receiveCancelOrderProcessTransGrid.sys")
	public ModelAndView receiveCancelOrderProcessTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required = true) String[] orde_iden_numb_array, 				// 주문번호
			@RequestParam(value = "purc_iden_numb_array[]", required = true) String[] purc_iden_numb_array, 				// 발주차수
			@RequestParam(value = "deli_iden_numb_array[]", required = true) String[] deli_iden_numb_array, 					// 출하차수
			@RequestParam(value = "rece_iden_numb_array[]", required = true) String[] rece_iden_numb_array, 					// 인수차수
			@RequestParam(value = "reason", required = true) String reason, 										// 변경사유
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		saveMap.put("rece_iden_numb_array", rece_iden_numb_array);
		saveMap.put("chan_reas_desc", reason);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		String error_msg = "";
		try {
			error_msg = returnOrderSvc.receiveCancelCheck(saveMap);
			if(!error_msg.equals("")){
				throw new Exception();
			}else{
				returnOrderSvc.receiveCancelOrderProcess(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(error_msg);
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/** * 인수내역/반품요청 대량 엑셀 다운로드  */
	@RequestMapping("returnOrderRegistExcelView.sys")
	public ModelAndView returnOrderRegistExcelView(
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,	
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,		
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcReturnStatFlag", defaultValue = "") String srcReturnStatFlag,	
			@RequestParam(value = "srcCenFlag", defaultValue = "") String srcCenFlag,	
			@RequestParam(value = "srcGoodsNm", defaultValue = "") String srcGoodsNm,	
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,	
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	

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
		params.put("srcReturnStatFlag", srcReturnStatFlag);
		params.put("srcCenFlag", srcCenFlag);
		params.put("srcGoodsNm", srcGoodsNm);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("srcCenFlag", srcCenFlag);
		
		List<Map<String, Object>> list = returnOrderSvc.getReturnOrderRegistListExcelView(params);
        
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
        
	/** * 반품요청내역 조회 DB조회후 엑셀 출력 */
	@RequestMapping("returnOrderListExcelView.sys")
	public ModelAndView returnOrderListExcelView(
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,	
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,		
			@RequestParam(value = "srcReturnStartDate", defaultValue = "") String srcReturnStartDate,						
			@RequestParam(value = "srcReturnEndDate", defaultValue = "") String srcReturnEndDate,		
			@RequestParam(value = "srcOrdeIdenNumb", defaultValue = "") String srcOrdeIdenNumb,	
			@RequestParam(value = "srcReturnStatFlag", defaultValue = "") String srcReturnStatFlag,	
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,	
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,	
			
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
		params.put("srcReturnStartDate", srcReturnStartDate);
		params.put("srcReturnEndDate", srcReturnEndDate);
		params.put("srcOrdeIdenNumb", srcOrdeIdenNumb);
		params.put("srcReturnStatFlag", srcReturnStatFlag);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		
		List<Map<String, Object>> list = returnOrderSvc.getReturnOrderListExcelView(params);
        
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
	
	/** * 수탁상품 반품요청내역 */
	@RequestMapping("cenReturnOrderList.sys")
	public ModelAndView cenReturnOrderList( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<CodesDto> returnTypeCode = commonSvc.getCodeList("RETURNSTATUSFLAG", 1, "");
		mav.setViewName("order/returnOrder/cenReturnOrderList");
		mav.addObject("returnTypeCode", returnTypeCode);
		mav.addObject("isCen", "true");
		return mav;
	}
	
	/** 수탁상품 주문에 대한 물류센터의 반품요청 승인 */
	@RequestMapping("cenOrderReturnApprovalTransGrid.sys")
	public ModelAndView cenOrderReturnApprovalTransGrid(
			@RequestParam(value = "orde_iden_numb_array[]", required=true) String[] orde_iden_numb_array,		// 주문번호 + 주문차수
			@RequestParam(value = "purc_iden_numb_array[]", required=true) String[] purc_iden_numb_array,		// 발주차수
			@RequestParam(value = "deli_iden_numb_array[]", required=true) String[] deli_iden_numb_array,		// 출하차수
			@RequestParam(value = "return_iden_numb_array[]", required=true) String[] return_iden_numb_array,	// 반품번호
			@RequestParam(value = "retu_prod_quan_array[]", required=true) String[] retu_prod_quan_array,		// 반품수량
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		saveMap.put("return_iden_numb_array", return_iden_numb_array);
		saveMap.put("retu_prod_quan_array", retu_prod_quan_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			returnOrderSvc.cenOrderReturnApproval(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME));
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
