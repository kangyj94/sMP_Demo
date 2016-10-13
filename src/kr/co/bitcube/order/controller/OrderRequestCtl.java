package kr.co.bitcube.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginRoleDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dto.OrderDto;
import kr.co.bitcube.order.dto.OrderHistDto;
import kr.co.bitcube.order.service.OrderCommonSvc;
import kr.co.bitcube.order.service.OrderRequestSvc;
import kr.co.bitcube.order.service.PurchaseSvc;
import kr.co.bitcube.organ.dto.SmpUsersDto;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping("order/orderRequest")
public class OrderRequestCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private OrderRequestSvc orderRequestSvc;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private PurchaseSvc purchaseSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	/**
	 * 진척도 조회
	 */
	@RequestMapping("orderListProgress.sys")
	public ModelAndView getOrderListProgress( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto      lud          = CommonUtils.getLoginUserDto(req);
		String            svcTypeCd    = lud.getSvcTypeCd();
		List<SmpUsersDto> workInfoList = null;
		
		if("ADM".equals(svcTypeCd)){
			workInfoList = this.orderCommonSvc.getWorkUserInfo();
	    }
		
		mav.addObject("workInfoList", workInfoList);
		mav.setViewName("order/orderRequest/orderListProgress");
		
		return mav;
	}
	
	/**
	 * 진척도 조회 DB조회후 리턴시켜주는 메소드
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("orderListProgressJQGrid.sys")
	public ModelAndView orderListProgressJQGrid(ModelAndView modelAndView, HttpServletRequest request, ModelMap param) throws Exception {
		String                    page    = (String)param.get("page");
		String                    rows    = (String)param.get("rows");
		Map<String, Object>       svcMap  = null;
		List<Map<String, String>> list    = null;
		Integer                   record  = null;
		Integer                   pageMax = null;
		
		modelAndView = new ModelAndView("jsonView");
		
		page = CommonUtils.nvl(page, "1");
		rows = CommonUtils.nvl(rows, "30");
		
		param.put("page", page);
		param.put("rows", rows);
		
		svcMap  = this.commonSvc.getJqGridList("order.orderRequest.selectOrderListProgressCnt", "order.orderRequest.selectOrderListProgress", param);
		list    = (List<Map<String, String>>)svcMap.get("list");
		record  = (Integer)svcMap.get("record");
		pageMax = (Integer)svcMap.get("pageMax");
		
		modelAndView.addObject("page",    page);
		modelAndView.addObject("total",   pageMax);
		modelAndView.addObject("records", record);
		modelAndView.addObject("list",    list);
		
		return modelAndView;
	}
	
	/**
	 * 진척도 팝업
	 */
	@RequestMapping("orderProgressPopup.sys")
	public ModelAndView getOrderProgressPopup(
			@RequestParam(value = "orde_iden_numb",required = true) String orde_iden_numb,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/orderRequest/orderListProgressPop");
		mav.addObject("orde_iden_numb", orde_iden_numb);
		return mav;
	}
	/**
	 * 진척도 팝업 리스트
	 */
	@RequestMapping("orderProgressPopListJQGrid.sys")
	public ModelAndView getOrderProgressPopListJQGrid( 
			@RequestParam(value = "orde_iden_numb",required = true) String orde_iden_numb,
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcOrderNumber", orde_iden_numb);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        List<OrderDto> list = orderRequestSvc.getOrderProgressPopList(params);
		mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	
	/**
	 * 주문조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("orderList.sys")
	public ModelAndView getOrderList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
        List<SmpUsersDto> productManagerList = new ArrayList<SmpUsersDto>();
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	        List<Object> managerList = generalDao.selectGernalList("product.selectProductManager", null);
	        for(Object obj : managerList) {
	        	Map<String,Object> objMap = (Map<String,Object>) obj;
	        	SmpUsersDto smpUsersDto = new SmpUsersDto();
	        	smpUsersDto.setUserId((String) objMap.get("USERID"));
	        	smpUsersDto.setUserNm((String) objMap.get("USERNM"));
	        	productManagerList.add(smpUsersDto);
	        }
	    }
		List<CodesDto> codeList = commonSvc.getCodeList("ORDERSTATUSFLAGCD", 1, "");
		mav.setViewName("order/orderRequest/orderList");
        mav.addObject("codeList", codeList);
        mav.addObject("productManagerList", productManagerList);
		return mav;
	}
	
	/**
	 * 주문조회 - 리스트 조회
	 */
	@RequestMapping("orderListJQGrid.sys")
	public ModelAndView orderListJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			@RequestParam(value = "srcOrderNumber", defaultValue = "") String srcOrderNumber, 							// 주문번호
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											// 그룹
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											// 법인 
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,										// 사업장
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcGoodsId", defaultValue = "") String srcGoodsId,										// 상품코드
			@RequestParam(value = "srcGoodsName", defaultValue = "") String srcGoodsName,								// 상품명
			@RequestParam(value = "srcOrderStatusFlag", defaultValue = "") String srcOrderStatusFlag,						// 주문상태
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,							// 주문일 - 시작
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,							// 주문일 - 시작
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,								// 주문자
			@RequestParam(value = "srcIsCen", defaultValue = "") String srcIsCen,												// 물류센터인지
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,							// 사업장 담당 운영자 정보
			@RequestParam(value = "srcSupervisorUserId", defaultValue = "") String srcSupervisorUserId,					// 감독관 Id
			@RequestParam(value = "srcApproval", defaultValue = "") String srcApproval,										// 주문승인내역조회
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcOrderNumber", srcOrderNumber);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodsId", srcGoodsId);
		params.put("srcGoodsName", srcGoodsName);
		params.put("srcOrderStatusFlag", srcOrderStatusFlag);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcIsCen", srcIsCen);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcSupervisorUserId", srcSupervisorUserId);
		params.put("srcApproval", srcApproval);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------페이징 세팅------------/
        int records = orderRequestSvc.getOrderListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<OrderDto> list = null; 
        if(records>0) list = orderRequestSvc.getOrderList(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	/**
	 * 주문조회 - 일괄 엑셀 다운로드
	 */
	@RequestMapping("orderListExcel.sys")
	public ModelAndView orderListExcel(
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			@RequestParam(value = "srcOrderNumber", defaultValue = "") String srcOrderNumber, 							// 주문번호
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,											// 그룹
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,											// 법인 
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,										// 사업장
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										// 공급사
			@RequestParam(value = "srcGoodsId", defaultValue = "") String srcGoodsId,										// 상품코드
			@RequestParam(value = "srcGoodsName", defaultValue = "") String srcGoodsName,								// 상품명
			@RequestParam(value = "srcOrderStatusFlag", defaultValue = "") String srcOrderStatusFlag,						// 주문상태
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,							// 주문일 - 시작
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,							// 주문일 - 시작
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,								// 주문자
			@RequestParam(value = "srcIsCen", defaultValue = "") String srcIsCen,												// 물류센터인지
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,							// 사업장 담당 운영자 정보
			@RequestParam(value = "srcSupervisorUserId", defaultValue = "") String srcSupervisorUserId,					// 감독관 Id
			@RequestParam(value = "srcApproval", defaultValue = "") String srcApproval,										// 주문승인내역조회
			@RequestParam(value = "prepay", defaultValue = "") String prepay,										// 선입금여부
			@RequestParam(value = "srcProductManagerUser", defaultValue = "") String srcProductManagerUser,										// 상품담당자
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcOrderNumber", srcOrderNumber);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodsId", srcGoodsId);
		params.put("srcGoodsName", srcGoodsName);
		params.put("srcOrderStatusFlag", srcOrderStatusFlag);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcIsCen", srcIsCen);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcSupervisorUserId", srcSupervisorUserId);
		params.put("srcApproval", srcApproval);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("prepay", prepay);
		params.put("srcProductManagerUser", srcProductManagerUser);
		
		
		//----------------조회------------/
		List<Map<String, Object>> list = orderRequestSvc.getOrderListExcel(params);
		
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
	
	/** 주문 취소 내역  */
	@RequestMapping("orderCancelList.sys")
	public ModelAndView getOrderCancelList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		mav.addObject("orderCancel", true);
		mav.setViewName("order/orderRequest/orderList");
		return mav;
	}
	
	/**
	 * 주문조회 상세
	 */
	@RequestMapping("orderDetail.sys")
	public ModelAndView getOrderDetail( 
			@RequestParam(value = "orde_iden_numb", required=true) String orde_iden_numb, 							// 주문번호
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/orderRequest/orderDetail");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orde_iden_all", orde_iden_numb);
		int goodsCnt = orderRequestSvc.getOrderGoodsCnt(params);
		if(goodsCnt == -1){
			mav.setViewName("order/orderRequest/orderDetailFail");
		}else{
			OrderDto orderDetailInfo = orderRequestSvc.getOrderDetail(params);
			boolean is_purc  = orderRequestSvc.getIsPurc(orderDetailInfo);
			boolean is_deli  = orderRequestSvc.getIsDeli(is_purc,params);
			mav.addObject("orderDetailInfo", orderDetailInfo);
			mav.addObject("is_purc",is_purc);
			mav.addObject("is_deli",is_deli);
		}
		return mav;
	}
	
	/**
	 * 주문 상세 히스토리 조회
	 */
	@RequestMapping("orderHistList.sys")
	public ModelAndView getOrderHistListJQGrid(
			@RequestParam(value = "orde_iden_numb", defaultValue = "") String orde_iden_numb, 							// 주문번호
			@RequestParam(value = "purc_iden_numb", defaultValue = "") String purc_iden_numb, 							// 발주차수
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,															// 정렬 조건
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orde_iden_numb", orde_iden_numb);
		params.put("purc_iden_numb", purc_iden_numb);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        //----------------조회------------/
        List<OrderHistDto> list  = orderRequestSvc.getOrderHistList(params);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list4", list);
		return modelAndView;
	}
	
	
	/**
	 * 주문조회(물량배분) 
	 */
	@RequestMapping("orderDivList.sys")
	public ModelAndView getOrderDivList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
		boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
		if(isAdm){
			// 2015.08.05 공사담당자 요청으로 공사담당자 정보 조회 : 주석 삭제
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
			mav.addObject("workInfoList", workInfoList);
			//기존 공사 운영담당자에서 상품담당자로 변경
			List<SmpUsersDto> productManagerList = orderCommonSvc.getProductManager();
			mav.addObject("productManagerList", productManagerList);
		}
		mav.setViewName("order/orderRequest/orderList");
		mav.addObject("isDiv", true);
		return mav;
	}
	
	/**
	 * 주문요청
	 */
	@RequestMapping("requestAdd.sys")
	public ModelAndView getRequestAdd( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<CodesDto> codeList = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
        mav.addObject("codeList", orderRequestSvc.getOrderType(codeList));
		mav.setViewName("order/orderRequest/requestAdd");
		return mav;
	}
	
	/**
	 * 주문요청
	 */
	@RequestMapping("requestAddFirstPurc.sys")
	public ModelAndView getRequestAddFirstPurc( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<CodesDto> codeList = commonSvc.getCodeList("ORDERTYPECODE", 1, "");
        mav.addObject("codeList", codeList);
        mav.addObject("isFirstPurc", "firstPurc");
		mav.setViewName("order/orderRequest/requestAdd");
		return mav;
	}
	
	/**
	 * 주문요청
	 */
	@RequestMapping("getOrderUserInfo.sys")
	public ModelAndView getOrderUserInfo( HttpServletRequest req, ModelAndView mav) throws Exception{
		return mav;
	}
	/**
	 * 주문요청 상품검색 그리드
	 */
	@RequestMapping("orderGoodsListJQGrid.sys")
	public ModelAndView getOrderGoodsListJQGrid( 
			@RequestParam(value = "isSearch", defaultValue = "") String isSearch,												// 초기 조회여부
			@RequestParam(value = "isNormTrusFlag", defaultValue = "") String isNormTrusFlag,								// 수탁상품 조회 flag
			@RequestParam(value = "isGoodsDivFlag", defaultValue = "") String isGoodsDivFlag,								// 물량배분 상품 조회 flag
			HttpServletRequest req, ModelAndView mav) throws Exception{
        List<OrderDto> list = null;  
        
//		if(!"".equals(isSearch)){
//			//----------------조회조건 세팅------------/
//			Map<String, Object> params = new HashMap<String, Object>();
//			params.put("isNormTrusFlag", isNormTrusFlag);
//			params.put("isGoodsDivFlag", isGoodsDivFlag);
//	        //----------------조회------------/
//	        list = orderRequestSvc.getOrderGoodsList(params);
//		}
		mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
//		mav.addObject("userdata", orderRequestSvc.getTotalUserData(list));
		return mav;
	}
	
	/** 공급사에서 고객사 선택 후 사용자조회 - 원 사용자 소속까지 같이 나오도록 조회*/
	@RequestMapping("getUserInfoListByBranchIdInVendorOrderRequest.sys")
	public ModelAndView getUserInfoListByBranchIdInVendorOrderRequest(
			@RequestParam(value = "borgId", required = false) String borgId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		List<UserDto> codeList = orderRequestSvc.getUserInfoListByBranchIdInVendorOrderRequest(borgId);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("userList", codeList);
		return modelAndView;
	}
	/**
	 *  주문 요청 Insert
	 */
	@RequestMapping("OrderRequestAddTransGrid.sys")
	public ModelAndView orderRequestAddTransGrid(
			// 주문 M
			@RequestParam(value = "groupid", required = true) String groupId,								// 그룹 ID
			@RequestParam(value = "clientid", required = true) String clientId,								// 법인 ID 
			@RequestParam(value = "branchid", required = true) String branchId,							// 사업장 ID
			@RequestParam(value = "cons_iden_name", required = true) String cons_iden_name,			// 공사명
			@RequestParam(value = "orde_type_clas", required = true) String orde_type_clas,				// 주문유형
			@RequestParam(value = "orde_tele_numb", required = true) String orde_tele_numb,			// 주문자 전화번호
			@RequestParam(value = "orde_user_id", required = true) String orde_user_id,					// 주문자 ID
			@RequestParam(value = "tran_data_addr", required = true) String tran_data_addr,				// 배송지주소
			@RequestParam(value = "tran_user_name", required = true) String tran_user_name,			// 인수자
			@RequestParam(value = "tran_tele_numb", required = true) String tran_tele_numb,			// 인수자 전화번호
			@RequestParam(value = "adde_text_desc", defaultValue = "") String adde_text_desc,			// 비고
			@RequestParam(value = "mana_user_name", defaultValue = "") String mana_user_name,		// 감독명 
			@RequestParam(value = "mana_user_id", defaultValue = "") String mana_user_id,				// 감독 id
			@RequestParam(value = "attach_file_1", defaultValue = "") String attach_file_1,					// 첨부파일1
			@RequestParam(value = "attach_file_2", defaultValue = "") String attach_file_2,					// 첨부파일2
			@RequestParam(value = "attach_file_3", defaultValue = "") String attach_file_3,					// 첨부파일3
			// 주문 T 
			@RequestParam(value = "disp_good_id_array[]", required=true) String[] disp_good_id_array,				// 진열 SEQ
			@RequestParam(value = "orde_requ_quan_array[]", required=true) String[] orde_requ_quan_array,		// 주문수량
			@RequestParam(value = "requ_deli_date_array[]", required=true) String[] requ_deli_date_array,			// 납품요청일
			@RequestParam(value = "good_name_array[]", required=true) String[] good_name_array,			// 상품명
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("groupid", groupId);
		saveMap.put("clientid", clientId);
		saveMap.put("branchid", branchId);
		saveMap.put("cons_iden_name", cons_iden_name);
		saveMap.put("cons_iden_name", cons_iden_name);
		saveMap.put("orde_type_clas", orde_type_clas);
		saveMap.put("orde_tele_numb", orde_tele_numb);
		saveMap.put("tran_data_addr", tran_data_addr);
		saveMap.put("tran_user_name", tran_user_name);
		saveMap.put("tran_tele_numb", tran_tele_numb);
		saveMap.put("adde_text_desc", adde_text_desc);
		saveMap.put("orde_user_id", orde_user_id);															// 주문자 Id
		saveMap.put("mana_user_name", mana_user_name);												// 감독명
		saveMap.put("disp_good_id_array", disp_good_id_array);
		saveMap.put("orde_requ_quan_array", orde_requ_quan_array);
		saveMap.put("requ_deli_date_array", requ_deli_date_array);
		saveMap.put("attach_file_1", attach_file_1);
		saveMap.put("attach_file_2", attach_file_2);
		saveMap.put("attach_file_3", attach_file_3);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		//최소주문수량 체크
		int inNum = 0;
		for(String disp_good_id : disp_good_id_array) {
			int chkMinQuantity = orderRequestSvc.selectProductMiniQuantity(disp_good_id);
			if(chkMinQuantity > Integer.parseInt(orde_requ_quan_array[inNum])) {
				custResponse.setSuccess(false);
				custResponse.setMessage("상품명["+good_name_array[inNum]+"]의 최소 주문수량은 "+chkMinQuantity+"개 입니다.");
			}
			inNum++;
		}
		try {
			if(custResponse.getSuccess()) {
				orderRequestSvc.setOrderRequestAdd(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 	// Insert 작업
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
	 * 물류센터 주문 요청 Insert
	 */
	@RequestMapping("cenOrderRequestAddTransGrid.sys")
	public ModelAndView cenOrderRequestAddTransGrid(
			// 주문 M
			@RequestParam(value = "groupid", required = true) String groupId,								// 그룹 ID
			@RequestParam(value = "clientid", required = true) String clientId,								// 법인 ID 
			@RequestParam(value = "branchid", required = true) String branchId,							// 사업장 ID
			@RequestParam(value = "cons_iden_name", required = true) String cons_iden_name,			// 공사명
			@RequestParam(value = "orde_type_clas", required = true) String orde_type_clas,				// 주문유형
			@RequestParam(value = "orde_tele_numb", required = true) String orde_tele_numb,			// 주문자 전화번호
			@RequestParam(value = "orde_user_id", required = true) String orde_user_id,					// 주문자 ID
			@RequestParam(value = "tran_data_addr", required = true) String tran_data_addr,				// 배송지주소
			@RequestParam(value = "tran_user_name", required = true) String tran_user_name,			// 인수자
			@RequestParam(value = "tran_tele_numb", required = true) String tran_tele_numb,			// 인수자 전화번호
			@RequestParam(value = "adde_text_desc", defaultValue = "") String adde_text_desc,			// 비고
			@RequestParam(value = "mana_user_name", defaultValue = "") String mana_user_name,		// 감독명 
			@RequestParam(value = "attach_file_1", defaultValue = "") String attach_file_1,					// 첨부파일1
			@RequestParam(value = "attach_file_2", defaultValue = "") String attach_file_2,					// 첨부파일2
			@RequestParam(value = "attach_file_3", defaultValue = "") String attach_file_3,					// 첨부파일3
			// 주문 T 
			@RequestParam(value = "orde_requ_quan_array[]", required=true) String[] orde_requ_quan_array,		// 주문수량
			@RequestParam(value = "requ_deli_date_array[]", required=true) String[] requ_deli_date_array,			// 납품요청일
			@RequestParam(value = "good_iden_numb_array[]", required=true) String[] good_iden_numb_array,	// 상품코드
			@RequestParam(value = "vendorid_array[]", required=true) String[] vendorid_array,	// 공급사 코드
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("groupid", groupId);
		saveMap.put("clientid", clientId);
		saveMap.put("branchid", branchId);
		saveMap.put("cons_iden_name", cons_iden_name);
		saveMap.put("cons_iden_name", cons_iden_name);
		saveMap.put("orde_type_clas", orde_type_clas);
		saveMap.put("orde_tele_numb", orde_tele_numb);
		saveMap.put("tran_data_addr", tran_data_addr);
		saveMap.put("tran_user_name", tran_user_name);
		saveMap.put("tran_tele_numb", tran_tele_numb);
		saveMap.put("adde_text_desc", adde_text_desc);
		saveMap.put("orde_user_id", orde_user_id);															// 주문자 Id
		saveMap.put("mana_user_name", mana_user_name);												// 감독명
		saveMap.put("orde_requ_quan_array", orde_requ_quan_array);
		saveMap.put("requ_deli_date_array", requ_deli_date_array);
		saveMap.put("attach_file_1", attach_file_1);
		saveMap.put("attach_file_2", attach_file_2);
		saveMap.put("attach_file_3", attach_file_3);
		saveMap.put("good_iden_numb_array", good_iden_numb_array);
		saveMap.put("vendorid_array", vendorid_array);
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	        orderRequestSvc.setCenOrderRequestAdd(saveMap,(LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME)); 	// Insert 작업 
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
	 * 주문 상세 - 공사명, 배송지 주소 변경
	 * 주문 상세 - 인수자, 인수자 전화번호 변경
	 */
	@RequestMapping("OrderRequestUpdateTransGrid.sys")
	public ModelAndView orderRequestUpdateTransGrid(
			// 주문 M
			@RequestParam(value = "orde_iden_numb", defaultValue = "") String orde_iden_numb, 				// 주문번호
			@RequestParam(value = "cons_iden_name", defaultValue = "") String cons_iden_name,				// 공사명
			@RequestParam(value = "tran_data_addr", defaultValue = "") String tran_data_addr,				// 배송지주소
			@RequestParam(value = "tranUserName", defaultValue = "") String tranUserName,						// 인수자
			@RequestParam(value = "tranTeleNumb", defaultValue = "") String tranTeleNumb,		// 인수장 전화번호
			@RequestParam(value = "phoneNum", defaultValue = "") String phoneNum,		// 공급사 전화번호
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb", orde_iden_numb);
		saveMap.put("cons_iden_name", cons_iden_name);	
		saveMap.put("tran_data_addr", tran_data_addr);
		saveMap.put("tranUserName", tranUserName);
		saveMap.put("tranTeleNumb", tranTeleNumb);
		saveMap.put("phoneNum", phoneNum);
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
	        orderRequestSvc.setOrderRequestUpdate(saveMap); 	// Insert 작업 
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
	 * 주문 상세 - 주문 취소
	 */
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
	 * 물류센터 주문요청
	 */
	@RequestMapping("cenOrderRequest.sys")
	public ModelAndView getCenOrderRequest( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/orderRequest/cenRequestAdd");
		return mav;
	}
	
	/**
	 * 물류센터 수탁발주관리
	 */
	@RequestMapping("cenOrderList.sys")
	public ModelAndView getCenOrderList( HttpServletRequest req, ModelAndView mav) throws Exception{
		boolean isCen = true;
		List<CodesDto> codeList = commonSvc.getCodeList("ORDERSTATUSFLAGCD", 1, "");
		mav.setViewName("order/orderRequest/cenOrderList");
		mav.addObject("isCen", isCen);
        mav.addObject("codeList", codeList);
		return mav;
	}
	
	/** * 수탁상품 재고 조회 */
	@RequestMapping("orderRequestStockCheck.sys")
	public ModelAndView orderRequestStockCheck(
			@RequestParam(value = "disp_good_id_array[]", required=true) String[] disp_good_id_array,				// 진열 SEQ
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		List<OrderDto> stockQuanChkList  = orderRequestSvc.chkStockQuan(disp_good_id_array);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("stockQuanChkList", stockQuanChkList);
        return modelAndView;
	}
	
	/** 주문실적 조회 */
	@RequestMapping("orderResultSearch.sys")
	public ModelAndView getOrderResultSearch( HttpServletRequest req, ModelAndView mav) throws Exception{
		List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
		List<CodesDto>    codeList     = commonSvc.getCodeList("RESULTORDERSTATUS", 1, "");
		
        mav.addObject("workInfoList", workInfoList);
		mav.addObject("codeList",     codeList);
		mav.setViewName("order/orderRequest/orderResultSearch");
		
		return mav;
	}
	
	/** 주문실적 조회 */
	@RequestMapping("orderResultSearchJQGrid.sys")
	public ModelAndView orderResultSearchJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 												// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,												// 정렬 조건
			@RequestParam(value = "srcOrderNumber", defaultValue = "") String srcOrderNumber, 							// 주문번호
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,									// 그룹
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,									// 법인 
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,									// 사업장
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,									// 공급사
			@RequestParam(value = "srcGoodsId", defaultValue = "") String srcGoodsId,									// 상품코드
			@RequestParam(value = "srcGoodsName", defaultValue = "") String srcGoodsName,								// 상품명
			@RequestParam(value = "srcOrderStatusFlag", defaultValue = "") String srcOrderStatusFlag,					// 주문상태
			@RequestParam(value = "srcOrderDateFlag", defaultValue = "") String srcOrderDateFlag,						// 주문검색플래그
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						// 주문일 - 시작
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,							// 주문일 - 시작
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,							// 주문자
			@RequestParam(value = "srcIsCen", defaultValue = "") String srcIsCen,										// 물류센터인지
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,							// 운영사 담당자
			@RequestParam(value = "srcWorkNm", defaultValue = "") String srcWorkNm,										// 공사유형 ID
			@RequestParam(value = "srcWorkUseFlag", defaultValue = "") String srcWorkUseFlag,							// 공사유형 사용여부
			@RequestParam(value = "srcCateId", defaultValue = "") String srcCateId,										// 카테고리 아이디
			@RequestParam(value = "srcIsBill", defaultValue = "") String srcIsBill,
			@RequestParam(value = "isDispCate", defaultValue = "0") String isDispCate,
			@RequestParam(value = "srcOrderSeqNumber", defaultValue = "") String srcOrderSeqNumber, 					// 주문차수
			@RequestParam(value = "srcGoodRegYear", defaultValue = "") String srcGoodRegYear,							//상품실적년도
			@RequestParam(value = "srcWorkInfoTop", defaultValue = "") String srcWorkInfoTop,							//사업유형
			@RequestParam(value = "srcGoodClasCode", defaultValue = "") String srcGoodClasCode,							//상품구분
			@RequestParam(value = "srcProductManager", defaultValue = "") String srcProductManager,							//상품담당자
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*************권한정보**************/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		List<LoginRoleDto> loginRoleList= (List<LoginRoleDto>)loginUserDto .getLoginRoleList();
		for(LoginRoleDto roleDto : loginRoleList){
			if(roleDto.getRoleCd().equals("UBINS_MAN")){
				srcWorkUseFlag = "0";
			}
		}
		String srcResultOrderStatusFlag = "";
		if("55".equals(srcOrderStatusFlag)){
			srcOrderStatusFlag = "60";
			srcResultOrderStatusFlag = "55";
		}else if("60".equals(srcOrderStatusFlag)){
			srcOrderStatusFlag = "60";
			srcResultOrderStatusFlag = "60";
		}
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		if(!"".equals(srcOrderNumber)){
			String [] orderNumb = new String [] {"",""};
			String [] srcOrderNumb = srcOrderNumber.split("-");
			for(int tmp=0; tmp < (srcOrderNumb.length > 2 ? 2:srcOrderNumb.length); tmp++){
				orderNumb[tmp] = srcOrderNumb[tmp];
			}
			srcOrderNumb = orderNumb;
			params.put("srcOrderNumber", srcOrderNumb[0]);
			params.put("srcOrderSeqNumber", srcOrderNumb[1]);
		}
		
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodsId", srcGoodsId);
		params.put("srcGoodsName", srcGoodsName);
		params.put("srcOrderStatusFlag", srcOrderStatusFlag);
		params.put("srcOrderDateFlag", srcOrderDateFlag);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcIsCen", srcIsCen);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcWorkNm", srcWorkNm);
		params.put("srcWorkUseFlag", srcWorkUseFlag);
		params.put("srcCateId", srcCateId);
		params.put("srcIsBill", srcIsBill);
		params.put("isDispCate", isDispCate);
		params.put("srcResultOrderStatusFlag", srcResultOrderStatusFlag);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		params.put("srcGoodRegYear", srcGoodRegYear);
		params.put("srcWorkInfoTop", srcWorkInfoTop);
		params.put("srcGoodClasCode", srcGoodClasCode);
		params.put("srcProductManager", srcProductManager);
		
		
		//----------------페이징 세팅------------/
        Map<String, Integer> records = orderRequestSvc.getOrderResultSearch(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records.get("CNT") / (float)rows);
		
        //----------------조회------------/
        List<OrderDto> list = null; 
        if(records.get("CNT")>0){ 
			params.put("sum_orde_pric", records.get("SUM_ORDE_PRIC"));
			params.put("sum_quantity", records.get("SUM_QUANTITY"));
        	list = orderRequestSvc.getOrderResultSearch(params, page, rows);
        }
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records.get("CNT"));
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * <pre>
	 * 실적관리 그리드를 조회하는 메소드
	 * 
	 * ~. modelMap 구조
	 *   !. srcOrderNumber (String, 주문번호)
	 *   !. srcGroupId (String, 그룹아이디)
	 *   !. srcClientId (String, 법인아이디)
	 *   !. srcBranchId (String, 고객사아이디)
	 *   !. srcVendorId (String, 공급사아이디)
	 *   !. srcGoodsName (String, 상품명)
	 *   !. srcGoodsId (String, 상품코드)
	 *   !. srcOrderStatusFlag (String, 주문상태)
	 *   !. srcGoodRegYear (String, 상품실적년도)
	 *   !. srcWorkInfoTop (String, 사업유형)
	 *   !. srcOrderDateFlag (String, 날짜 조회 조건)
	 *   !. srcOrderStartDate (String, 날짜 검색 시작일)
	 *   !. srcOrderEndDate (String, 날짜 검색 종료일)
	 *   !. srcWorkInfoUser (String, 공사 담당자)
	 *   !. srcWorkNm (String, 공사유형)
	 *   !. srcGoodClasCode (String, 상품구분)
	 *   !. srcProductManager (String, 상품담당자)
	 *   !. srcIsClosSaleDate (String, 매출계산서 발행여부)
	 *   !. page (String, 조회 페이지 번호)
	 *   !. rows (String, 조회 페이지 로우 수)
	 *   !. sidx (String, 정렬 칼럼 명)
	 *   !. sord (String, 정렬 방식)
	 * </pre>
	 * 
	 * @param modelAndView
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("orderResultSearchJQGridAdm.sys")
	public ModelAndView orderResultSearchJQGridAdm(ModelAndView modelAndView, HttpServletRequest request, ModelMap modelMap) throws Exception {
		String                    page              = (String)modelMap.get("page");
		String                    rows              = (String)modelMap.get("rows");
		String                    creaSaleDate      = null;
		String                    creaSaleMonth     = null;
		String[]                  creaSaleDateArray = null;
		Integer                   rowsInt           = null;
		Integer                   offset            = null;
		RowBounds                 rowBounds         = null;
		Map<String, Integer>      records           = null;
		Map<String, Object>       info              = null;
		List<Map<String, Object>> list              = null;
		int                       total             = 0;
		int                       listSize          = 0;
		int                       i                 = 0;
		
		page = CommonUtils.nvl(page, "1");
		rows = CommonUtils.nvl(rows, "30");
		
		modelMap.put("page", page);
		modelMap.put("rows", rows);
		
		rowsInt   = Integer.parseInt(rows);
		offset    = CommonUtils.getPageSkip(page, rows); // 페이지 스킵량 계산
		rowBounds = new RowBounds(offset, rowsInt);
		
		modelMap.put("rowBounds", rowBounds);

        records = orderRequestSvc.selectOrderResultSearchJQGridAdmCnt(modelMap);
        total   = (int)Math.ceil((float)records.get("CNT") / (float)rowsInt);
        
        if(records.get("CNT") > 0){ 
			modelMap.put("sum_orde_pric", records.get("SUM_ORDE_PRIC"));
			modelMap.put("sum_quantity",  records.get("SUM_QUANTITY"));
			
        	list = orderRequestSvc.selectOrderResultSearchJQGridAdmList(modelMap, page, rows);
        	
        	if(list != null){
        		listSize = list.size();
        	}
        	
        	for(i = 0; i < listSize; i++){
        		info          = list.get(i);
        		creaSaleDate  = (String)info.get("creaSaleDate");
        		creaSaleDate  = CommonUtils.nvl(creaSaleDate);
        		creaSaleMonth = "";
        		
        		if("".equals(creaSaleDate) == false){
        			creaSaleDateArray = creaSaleDate.split("-");
        			creaSaleMonth     = creaSaleDateArray[0] + creaSaleDateArray[1];
        		}
        		
        		info.put("creaSaleMonth", creaSaleMonth);
        	}
        }
        
		modelAndView = new ModelAndView("jsonView");
		
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records.get("CNT"));
		modelAndView.addObject("list", list);
		
		return modelAndView;
	}
	
	/**
	 * <pre>
	 * 실적관리 그리드 데이터를 엑셀 다운하는 메소드
	 * 
	 * ~. modelMap 구조
	 *   !. srcOrderNumber (String, 주문번호)
	 *   !. srcGroupId (String, 그룹아이디)
	 *   !. srcClientId (String, 법인아이디)
	 *   !. srcBranchId (String, 고객사아이디)
	 *   !. srcVendorId (String, 공급사아이디)
	 *   !. srcGoodsName (String, 상품명)
	 *   !. srcGoodsId (String, 상품코드)
	 *   !. srcOrderStatusFlag (String, 주문상태)
	 *   !. srcGoodRegYear (String, 상품실적년도)
	 *   !. srcWorkInfoTop (String, 사업유형)
	 *   !. srcOrderDateFlag (String, 날짜 조회 조건)
	 *   !. srcOrderStartDate (String, 날짜 검색 시작일)
	 *   !. srcOrderEndDate (String, 날짜 검색 종료일)
	 *   !. srcWorkInfoUser (String, 공사 담당자)
	 *   !. srcWorkNm (String, 공사유형)
	 *   !. srcGoodClasCode (String, 상품구분)
	 *   !. srcProductManager (String, 상품담당자)
	 *   !. srcIsClosSaleDate (String, 매출계산서 발행여부)
	 *   !. page (String, 조회 페이지 번호)
	 *   !. rows (String, 조회 페이지 로우 수)
	 *   !. sidx (String, 정렬 칼럼 명)
	 *   !. sord (String, 정렬 방식)
	 *   !. sheetTitle (String, 시트명)
	 *   !. excelFileName (String, 엑셀 파일명)
	 *   !. colLabels (String[], 컬럼명)
	 *   !. colIds (String[], 컬럼아이디)
	 *   !. numColIds (String[], 숫자표현대상 아이디)
	 *   !. figureColIds (String[], ?)
	 * </pre>
	 * 
	 * @param modelAndView
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("orderResultSearchJQGridAdmExcel.sys")
	public ModelAndView orderResultSearchJQGridAdmExcel(ModelAndView modelAndView, HttpServletRequest request, ModelMap modelMap) throws Exception {
		String                    sheetTitle        = (String)modelMap.get("sheetTitle");
		String                    excelFileName     = (String)modelMap.get("excelFileName");
		String                    creaSaleMonth     = null;
		String                    creaSaleDate      = null;
		String[]                  colLabels         = CommonUtils.getListToArray((List<String>)modelMap.get("colLabels"));
		String[]                  colIds            = CommonUtils.getListToArray((List<String>)modelMap.get("colIds"));
		String[]                  numColIds         = CommonUtils.getListToArray((List<String>)modelMap.get("numColIds"));
		String[]                  figureColIds      = CommonUtils.getListToArray((List<String>)modelMap.get("figureColIds"));
		String[]                  creaSaleDateArray = null;
		List<Object>              oList             = null;
		List<Map<String, Object>> sheetList         = new ArrayList<Map<String, Object>>();
		Map<String, Object>       map1              = new HashMap<String, Object>();
		
		modelMap.put("page", "-1");
		modelMap.put("rows", "-1");
		
		oList = generalDao.selectGernalList( "order.orderRequest.orderResultSearchJQGridAdmList" , modelMap);
		for(Object obj : oList){
			Map<String, Object> objTmp =  (Map<String, Object>)obj;
			String goodSepcDesc  =  "";
			creaSaleMonth = "";
			
			try {
				goodSepcDesc = objTmp.get("goodSepcDesc").toString().trim();
				creaSaleDate = (String)objTmp.get("closSaleDate");
				creaSaleDate  = CommonUtils.nvl(creaSaleDate);
				
				if("".equals(creaSaleDate) == false){
					creaSaleDateArray = creaSaleDate.split("-");
        			creaSaleMonth     = creaSaleDateArray[0] + creaSaleDateArray[1];
				}
			}
			catch (Exception e) { }
			
			((Map<String, Object>)obj).put("goodSepcDesc",  goodSepcDesc);
			((Map<String, Object>)obj).put("creaSaleMonth", creaSaleMonth);
		}
		
        map1.put("sheetTitle",   sheetTitle);
        map1.put("colLabels",    colLabels);
        map1.put("colIds",       colIds);
        map1.put("numColIds",    numColIds);
        map1.put("figureColIds", figureColIds);
        map1.put("colDataList",  oList);
        
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList",     sheetList);
		
		return modelAndView;
	}
	
	/** 주문실적 Excel Down */
	@RequestMapping("orderResultSearchExcel.sys")
	public ModelAndView orderResultSearchExcel(
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 												// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,												// 정렬 조건
			@RequestParam(value = "srcOrderNumber", defaultValue = "") String srcOrderNumber, 							// 주문번호
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,									// 그룹
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,									// 법인 
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,									// 사업장
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,									// 공급사
			@RequestParam(value = "srcGoodsId", defaultValue = "") String srcGoodsId,									// 상품코드
			@RequestParam(value = "srcGoodsName", defaultValue = "") String srcGoodsName,								// 상품명
			@RequestParam(value = "srcOrderStatusFlag", defaultValue = "") String srcOrderStatusFlag,					// 주문상태
			@RequestParam(value = "srcOrderDateFlag", defaultValue = "") String srcOrderDateFlag,						// 주문검색플래그
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						// 주문일 - 시작
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,							// 주문일 - 시작
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,							// 주문자
			@RequestParam(value = "srcIsCen", defaultValue = "") String srcIsCen,										// 물류센터인지
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,							// 운영사 담당자
			@RequestParam(value = "srcWorkNm", defaultValue = "") String srcWorkNm,										// 공사유형 ID
			@RequestParam(value = "srcWorkUseFlag", defaultValue = "") String srcWorkUseFlag,							// 공사유형 사용여부
			@RequestParam(value = "srcCateId", defaultValue = "") String srcCateId,										// 카테고리 아이디
			@RequestParam(value = "srcIsBill", defaultValue = "") String srcIsBill,
			@RequestParam(value = "isDispCate", defaultValue = "0") String isDispCate,
			@RequestParam(value = "srcOrderSeqNumber", defaultValue = "0") String srcOrderSeqNumber,					//주문차수
			@RequestParam(value = "srcGoodRegYear", defaultValue = "") String srcGoodRegYear,							//상품실적년도
			@RequestParam(value = "srcWorkInfoTop", defaultValue = "") String srcWorkInfoTop,							//사업유형
			@RequestParam(value = "srcGoodClasCode", defaultValue = "") String srcGoodClasCode,							//상품구분
			@RequestParam(value = "srcProductManager", defaultValue = "") String srcProductManager,							//상품담당자
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,
			@RequestParam(value = "figureColIds", required = false) String[] figureColIds,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		String srcResultOrderStatusFlag = "";
		if("55".equals(srcOrderStatusFlag)){
			srcOrderStatusFlag = "60";
			srcResultOrderStatusFlag = "55";
		}else if("60".equals(srcOrderStatusFlag)){
			srcOrderStatusFlag = "60";
			srcResultOrderStatusFlag = "60";
		}
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		if(!"".equals(srcOrderNumber)){
			String [] orderNumb = new String [] {"",""};
			String [] srcOrderNumb = srcOrderNumber.split("-");
			for(int tmp=0; tmp < (srcOrderNumb.length > 2 ? 2:srcOrderNumb.length); tmp++){
				orderNumb[tmp] = srcOrderNumb[tmp];
			}
			srcOrderNumb = orderNumb;
			params.put("srcOrderNumber", srcOrderNumb[0]);
			params.put("srcOrderSeqNumber", srcOrderNumb[1]);
		}
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodsId", srcGoodsId);
		params.put("srcGoodsName", srcGoodsName);
		params.put("srcOrderStatusFlag", srcOrderStatusFlag);
		params.put("srcResultOrderStatusFlag", srcResultOrderStatusFlag);
		params.put("srcOrderDateFlag", srcOrderDateFlag);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcIsCen", srcIsCen);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcWorkNm", srcWorkNm);
		params.put("srcWorkUseFlag", srcWorkUseFlag);
		params.put("srcCateId", srcCateId);
		params.put("srcIsBill", srcIsBill);
		params.put("isDispCate", isDispCate);
		String orderString = " regi_date_time desc ";
		params.put("orderString", orderString);
		params.put("srcGoodRegYear", srcGoodRegYear);
		params.put("srcWorkInfoTop", srcWorkInfoTop);
		params.put("srcGoodClasCode", srcGoodClasCode);
		params.put("srcProductManager", srcProductManager);
		
		//----------------조회------------/
		List<Map<String, Object>> list = orderRequestSvc.selectOrderResultSearchListExcel(params);
		
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
		
//		modelAndView.setViewName("commonExcelViewResolver");
//		modelAndView.addObject("sheetTitle", sheetTitle);
//		modelAndView.addObject("excelFileName", excelFileName);
//		modelAndView.addObject("colLabels", colLabels);
//		modelAndView.addObject("colIds", colIds);
//		modelAndView.addObject("numColIds", numColIds);
//		modelAndView.addObject("figureColIds", figureColIds);
//		modelAndView.addObject("colDataList", list);
		return modelAndView;
	}
	
	/**
	 * 주문요청시 주문자를 선택하면 감독명을 리턴해준다
	 */
	@RequestMapping("getSupervisorUserInfo.sys")
	public ModelAndView getSupervisorUserInfo(
			@RequestParam(value = "branchId", required = false) String branchId,
			@RequestParam(value = "userId", required = false) String userId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		List<UserDto> codeList = orderRequestSvc.getSupervisorUserInfo(branchId,userId );
		
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("userList", codeList);
		return modelAndView;
	}
	
	/**
	 * 주문조회(주문승인) 
	 */
	@RequestMapping("approvalOrderList.sys")
	public ModelAndView getApprovalOrderList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		mav.setViewName("order/orderRequest/approvalOrderList");
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
	
	/** 주문 승인 조회 */
	@RequestMapping("approvalOrderResultList.sys")
	public ModelAndView getApprovalOrderResultList( HttpServletRequest req, ModelAndView mav) throws Exception{
		LoginUserDto lud = (LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME);
	    boolean isAdm = lud.getSvcTypeCd().equals("ADM") ? true : false;
	    if(isAdm){
			List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
	        mav.addObject("workInfoList", workInfoList);
	    }
		List<CodesDto> codeList = commonSvc.getCodeList("ORDERSTATUSFLAGCD", 1, "");
        mav.addObject("codeList", codeList);
		mav.setViewName("order/orderRequest/approvalOrderResultList");
		mav.addObject("isApproval", true);
		return mav;
	}
	
	/** 공급사 진척도 조회*/
	@RequestMapping("venOrderListProgress.sys")
	public ModelAndView getVenOrderListProgress( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/orderRequest/venOrderListProgress");
		return mav;
	}
	
	/** * 공급사 진척도 조회 DB조회후 리턴시켜주는 메소드 */
	@RequestMapping("venOrderListProgressJQGrid.sys")
	public ModelAndView getVenOrderListProgressJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 															
			@RequestParam(value = "sord", defaultValue = "") String sord,															
			
			@RequestParam(value = "srcOrderNumber", defaultValue = "") String srcOrderNumber, 										
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,										
			@RequestParam(value = "srcPurcStartDate", defaultValue = "") String srcPurcStartDate,						
			@RequestParam(value = "srcPurcEndDate", defaultValue = "") String srcPurcEndDate,							
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcOrderNumber", srcOrderNumber);
		params.put("srcVendorId", srcVendorId);
		params.put("srcPurcStartDate", srcPurcStartDate);
		params.put("srcPurcEndDate", srcPurcEndDate);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------페이징 세팅------------/
        int records = orderRequestSvc.getVenOrderListProgressCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        //----------------조회------------/
        List<OrderDto> list = null; 
        if(records>0) list = orderRequestSvc.getVenOrderListProgress(params, page, rows);
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/** 공급사 진척도 팝업  발주 이력 팝업 으로 이동한다*/
	@RequestMapping("venOrderProgressPopup.sys")
	public ModelAndView getVenOrderProgressPopup(
			@RequestParam(value = "orde_iden_numb",required = true) String orde_iden_numb,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("order/orderRequest/venOrderListProgressPop");
		mav.addObject("orde_iden_numb", orde_iden_numb);
		return mav;
	}
	
	/** * 주문 실적조회 공사유형 리턴 */
	@RequestMapping("getWorkInfoList.sys")
	public ModelAndView getWorkInfoNms(
			@RequestParam(value = "userId", defaultValue = "") String userId,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		List<Map<String,Object>> workInfoList = orderRequestSvc.getWorkInfoNms(userId);
        modelAndView = new ModelAndView("jsonView");
        modelAndView.addObject("workInfoList", workInfoList);
		return modelAndView;
	}
	
	/**
	 * 주문조회 - 판가 총액 때문에 다시 만듬. 2013-04-18 parkjoon
	 * 주문 조회 관련 부분을 다른 메뉴에서 많이 사용하고 있기때문에 따로 떼어 만듬.
	 */
	@RequestMapping("orderListIncludeTotalSumJQGrid.sys")
	public ModelAndView orderListIncludeTotalSumJQGrid(
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			/*  조회 조건 */
			@RequestParam(value = "sidx", defaultValue = "") String sidx, 												// 정렬할 칼럼 명
			@RequestParam(value = "sord", defaultValue = "") String sord,												// 정렬 조건
			@RequestParam(value = "srcOrderNumber", defaultValue = "") String srcOrderNumber, 							// 주문번호
			@RequestParam(value = "srcGroupId", defaultValue = "") String srcGroupId,									// 그룹
			@RequestParam(value = "srcClientId", defaultValue = "") String srcClientId,									// 법인 
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,									// 사업장
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,									// 공급사
			@RequestParam(value = "srcGoodsId", defaultValue = "") String srcGoodsId,									// 상품코드
			@RequestParam(value = "srcGoodsName", defaultValue = "") String srcGoodsName,								// 상품명
			@RequestParam(value = "srcOrderStatusFlag", defaultValue = "") String srcOrderStatusFlag,					// 주문상태
			@RequestParam(value = "srcOrderStartDate", defaultValue = "") String srcOrderStartDate,						// 주문일 - 시작
			@RequestParam(value = "srcOrderEndDate", defaultValue = "") String srcOrderEndDate,							// 주문일 - 시작
			@RequestParam(value = "srcOrderUserId", defaultValue = "") String srcOrderUserId,							// 주문자
			@RequestParam(value = "srcIsCen", defaultValue = "") String srcIsCen,										// 물류센터인지
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "") String srcWorkInfoUser,							// 사업장 담당 운영자 정보
			@RequestParam(value = "srcSupervisorUserId", defaultValue = "") String srcSupervisorUserId,					// 감독관 Id
			@RequestParam(value = "srcApproval", defaultValue = "") String srcApproval,									// 주문승인내역조회
			@RequestParam(value = "prepay", defaultValue = "") String prepay,											// 선입금여부
			@RequestParam(value = "srcProductManagerUser", defaultValue = "") String srcProductManagerUser,				// 상품담당자
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//-----------권한 세팅---------------/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		List<LoginRoleDto> loginRoleList= (List<LoginRoleDto>)loginUserDto .getLoginRoleList();
		boolean ubinsMan = false;
		for(LoginRoleDto roleDto : loginRoleList){
			if(roleDto.getRoleCd().equals("UBINS_MAN")){
				ubinsMan = true;
			}
		}
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcOrderNumber", srcOrderNumber);
		params.put("srcGroupId", srcGroupId);
		params.put("srcClientId", srcClientId);
		params.put("srcBranchId", srcBranchId);
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodsId", srcGoodsId);
		params.put("srcGoodsName", srcGoodsName);
		params.put("srcOrderStatusFlag", srcOrderStatusFlag);
		params.put("srcOrderStartDate", srcOrderStartDate);
		params.put("srcOrderEndDate", srcOrderEndDate);
		params.put("srcOrderUserId", srcOrderUserId);
		params.put("srcIsCen", srcIsCen);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcSupervisorUserId", srcSupervisorUserId);
		params.put("srcApproval", srcApproval);
		params.put("ubinsMan", ubinsMan);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("prepay", prepay); 
		params.put("srcProductManagerUser", srcProductManagerUser);
		
		//----------------페이징 세팅------------/
        Map<String,Integer> records = orderRequestSvc.getOrderListIncludeTotalSumCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records.get("CNT") / (float)rows);
		
        //----------------조회------------/
        List<OrderDto> list = null; 
        if(records.get("CNT")>0) {
			params.put("sum_orde_pric"		, records.get("SUM_ORDE_PRIC"));
			params.put("sum_orde_requ_quan"	, records.get("SUM_ORDE_REQU_QUAN"));
        	list = orderRequestSvc.getOrderListIncludeTotalSum(params, page, rows);
//        	list = orderRequestSvc.getOrderListIncludeTotalSum(params);
		}
        
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records.get("CNT"));
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 실적조회 셀렉트
	 */
	@RequestMapping("orderRequestCodeList.sys")
	public ModelAndView orderRequestCodeList(
			ModelAndView mav, HttpServletRequest request) throws Exception{
		List<CodesDto> codeList = commonSvc.getCodeList("SMPWORKINFO_CODE_TOP", 1);
		List<CodesDto> coodClasCodeList = commonSvc.getCodeList("ORDERGOODSTYPE", 1);
		mav = new ModelAndView("jsonView");
		mav.addObject("codeList", codeList);
		mav.addObject("coodClasCodeList", coodClasCodeList);
		return mav;
	}
	
	/**
	 * 선입금여부 페이지 이동
	 */
	@RequestMapping("orderPrePayList")
	public ModelAndView orderPrePayList(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception{
		List<CodesDto> orderStatusList = commonSvc.getCodeList("ORDERSTATUSFLAGCD", 1);
		List<SmpUsersDto> workInfoList = orderCommonSvc.getWorkUserInfo();
		
		modelAndView.addObject("workInfoList", workInfoList);
		modelAndView.addObject("orderStatusList", orderStatusList);
		modelAndView.setViewName("order/orderRequest/prePayList");
		return modelAndView;
	}
	
	
	/**
	 * 운영사 수발주 관리 선입금/여신초과 주문처리 리스트를 조회하늠 메소드
	 * 
	 * @param page (조회할 페이지)
	 * @param rows (페이지당 조회 건수)
	 * @param sidx (정렬할 칼럼명)
	 * @param sord (정렬조건)
	 * @param orderStartDate (주문시작일)
	 * @param orderEndDate (주문종료일)
	 * @param orderStatusFlag (주문상태)
	 * @param prePayType (유형)
	 * @param srcWorkInfoUser (공사담당자)
	 * @param srcGroupId (구매자 그룹정보)
	 * @param srcClientId (구매사 법인정보)
	 * @param srcBranchId (구매사 사업장 정보)
	 * @param modelAndView
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping("getAdmPrePayList.sys")
	public ModelAndView getAdmPrePayList(
			@RequestParam(value = "page",            defaultValue = "1")  String page,
			@RequestParam(value = "rows",            defaultValue = "30") String rows,
			@RequestParam(value = "sidx",            defaultValue = "")   String sidx,
			@RequestParam(value = "sord",            defaultValue = "")   String sord,
			@RequestParam(value = "orderStartDate",  defaultValue = "")   String orderStartDate,
			@RequestParam(value = "orderEndDate",    defaultValue = "")   String orderEndDate,
			@RequestParam(value = "orderStatusFlag", defaultValue = "")   String orderStatusFlag,
			@RequestParam(value = "prePayType",      defaultValue = "")   String prePayType,
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "")   String srcWorkInfoUser,
			@RequestParam(value = "srcGroupId",      defaultValue = "")   String srcGroupId,
			@RequestParam(value = "srcClientId",     defaultValue = "")   String srcClientId,
			@RequestParam(value = "srcBranchId",     defaultValue = "")   String srcBranchId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		ModelMap            svcParams       = new ModelMap();
		Map<String, Object> svcResult       = null;
		Map<String,Object>  userdata        = new HashMap<String,Object>();
		List<?>             svcResultList   = null;
		Integer             svcResultTotal  = null;
		Integer             svcResultRecord = null;
		String              svcResultPage   = null;
		String              ordeRequQuan    = null;
		String              totalSellPrice  = null;
		
		svcParams.put("page",            page);
		svcParams.put("rows",            rows);
		svcParams.put("sidx",            sidx);
		svcParams.put("sord",            sord);
		svcParams.put("orderStartDate",  orderStartDate);
		svcParams.put("orderEndDate",    orderEndDate);
		svcParams.put("orderStatusFlag", orderStatusFlag);
		svcParams.put("prePayType",      prePayType);
		svcParams.put("srcWorkInfoUser", srcWorkInfoUser);
		svcParams.put("srcGroupId",      srcGroupId);
		svcParams.put("srcClientId",     srcClientId);
		svcParams.put("srcBranchId",     srcBranchId);
		
		svcResult        = this.orderRequestSvc.getAdmPrePayList(svcParams); // 리스트 조회
		svcResultList    = (List<?>)svcResult.get("list");
		svcResultRecord  = (Integer)svcResult.get("records");
		svcResultTotal   = (Integer)svcResult.get("total");
		svcResultPage    = (String)svcResult.get("page");
		ordeRequQuan     = (String)svcResult.get("ordeRequQuan");
		totalSellPrice   = (String)svcResult.get("totalSellPrice");
		
		userdata.put("ordeRequQuan",   ordeRequQuan);
		userdata.put("totalSellPrice", totalSellPrice);
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("page",     svcResultPage);
		modelAndView.addObject("total",    svcResultTotal);
		modelAndView.addObject("records",  svcResultRecord);
		modelAndView.addObject("list",     svcResultList);
		modelAndView.addObject("userdata", userdata);
		
		return modelAndView;
	}
	/**
	 * 주문조회 - 일괄 엑셀 다운로드
	 */
	@RequestMapping("getAdmPrePayListExcel.sys")
	public ModelAndView getAdmPrePayListExcel(
			@RequestParam(value = "sidx",            defaultValue = "")   String sidx,
			@RequestParam(value = "sord",            defaultValue = "")   String sord,
			@RequestParam(value = "orderStartDate",  defaultValue = "")   String orderStartDate,
			@RequestParam(value = "orderEndDate",    defaultValue = "")   String orderEndDate,
			@RequestParam(value = "orderStatusFlag", defaultValue = "")   String orderStatusFlag,
			@RequestParam(value = "prePayType",      defaultValue = "")   String prePayType,
			@RequestParam(value = "srcWorkInfoUser", defaultValue = "")   String srcWorkInfoUser,
			@RequestParam(value = "srcGroupId",      defaultValue = "")   String srcGroupId,
			@RequestParam(value = "srcClientId",     defaultValue = "")   String srcClientId,
			@RequestParam(value = "srcBranchId",     defaultValue = "")   String srcBranchId,
			
			@RequestParam(value = "sheetTitle", defaultValue = "") String sheetTitle,
			@RequestParam(value = "excelFileName", defaultValue = "") String excelFileName,
			@RequestParam(value = "colLabels", required = false) String[] colLabels,
			@RequestParam(value = "colIds", required = false) String[] colIds,
			@RequestParam(value = "numColIds", required = false) String[] numColIds,			
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		ModelMap            params       = new ModelMap();
		params.put("sidx",            sidx);
		params.put("sord",            sord);
		params.put("orderStartDate",  orderStartDate);
		params.put("orderEndDate",    orderEndDate);
		params.put("orderStatusFlag", orderStatusFlag);
		params.put("prePayType",      prePayType);
		params.put("srcWorkInfoUser", srcWorkInfoUser);
		params.put("srcGroupId",      srcGroupId);
		params.put("srcClientId",     srcClientId);
		params.put("srcBranchId",     srcBranchId);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		
		//----------------조회------------/
		List<Object> list = generalDao.selectGernalList("order.orderRequest.selectAdmPrePayList", params);
		
        List<Map<String, Object>> sheetList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("sheetTitle", sheetTitle);
        map1.put("colLabels", colLabels);
        map1.put("colIds", colIds);
        map1.put("numColIds", numColIds);
        map1.put("colDataList", list);
        sheetList.add(map1);
        modelAndView.setViewName("commonExcelViewResolver");
        modelAndView.addObject("excelFileName", excelFileName);
        modelAndView.addObject("sheetList", sheetList);		
		return modelAndView;
	}
}