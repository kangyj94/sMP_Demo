package kr.co.bitcube.order.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dto.CartMasterInfoDto;
import kr.co.bitcube.order.service.CartManageSvc;
import kr.co.bitcube.order.service.OrderRequestSvc;
import kr.co.bitcube.product.service.ProductSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("order/admCart")
public class AdmOrderController {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private OrderRequestSvc orderRequestSvc;

	@Autowired
	private CartManageSvc cartManageSvc;
	
	@Autowired private CommonSvc commonSvc;
		
	@Autowired
	private ProductSvc productSvc;
	
	/** * 운영사에서 고객사 사용자의 장바구니 화면으로 접근. */
	@RequestMapping("admCartInfoIframe.sys")
	public ModelAndView cartMstInfo( 
			@RequestParam(value = "belongBorgId", required = true) String belongBorgId,
			@RequestParam(value = "belongSvcTypeCd", defaultValue = "") String belongSvcTypeCd,
			@RequestParam(value = "moveUserId", defaultValue = "") String moveUserId,
			HttpServletRequest request,
			ModelAndView modelAndView) throws Exception{
		
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("userId", moveUserId);
		searchMap.put("belongBorgId", belongBorgId);
		searchMap.put("svcTypeCd", belongSvcTypeCd);
		LoginUserDto loginUserDto = commonSvc.getLoginUserInfo(searchMap);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchParams = new HashMap<String, Object>();    
		searchParams.put("groupid"  , loginUserDto.getGroupId());
		searchParams.put("clientid" , loginUserDto.getClientId());
		searchParams.put("branchid" , loginUserDto.getBorgId());
		searchParams.put("userid" , loginUserDto.getUserId());
		searchParams.put("userInfoDto" , loginUserDto);
		
		CartMasterInfoDto cmi = cartManageSvc.getCartMasterInfo(searchParams);
		if(cmi != null){
			if(cmi.getTran_user_name().equals("")){
				cmi.setTran_user_name(loginUserDto.getUserNm());
			}
			if(cmi.getTran_tele_numb().equals("")){
				cmi.setTran_tele_numb(loginUserDto.getMobile());
			}
		}
		modelAndView.addObject("cartMasterInfo",cmi);
		List<UserDto> directorList = orderRequestSvc.getSupervisorUserInfo(loginUserDto.getBorgId(),loginUserDto.getUserId());
		List<Map<String, Object>> cartList = cartManageSvc.getBuyCartInfo(searchParams);
        modelAndView.addObject("userList", directorList);
        modelAndView.addObject("cartList", cartList);
        modelAndView.addObject("userDto", loginUserDto);
		modelAndView.setViewName("order/cart/admCartInfoIframe");
		return modelAndView;
	}
	
	/** 운영사 : 대리 구매 위한 상품조회 */
	@RequestMapping("admProdSearch.sys")
	public ModelAndView admProdSearch( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "4") int rows,
			// 조회 조건
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,				//상품명
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,	//상품코드
			@RequestParam(value = "srcGoodType", defaultValue = "") String srcGoodType,				// 상품구분
			@RequestParam(value = "srcGoodSpec", defaultValue = "") String srcGoodSpec,				// 규격
			@RequestParam(value = "srcRepreGood", defaultValue = "") String srcRepreGood,				// 상품유형
			
			@RequestParam(value = "belongBorgId", required = true) String belongBorgId,
			@RequestParam(value = "belongSvcTypeCd", defaultValue = "") String belongSvcTypeCd,
			@RequestParam(value = "moveUserId", defaultValue = "") String moveUserId,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("userId", moveUserId);
		searchMap.put("belongBorgId", belongBorgId);
		searchMap.put("svcTypeCd", belongSvcTypeCd);
		LoginUserDto userInfoDto = commonSvc.getLoginUserInfo(searchMap);
		Map<String, Object> params      = new HashMap<String, Object>();
		params.put("userInfoDto", userInfoDto);
		
		params.put("orderString",  " ORDER_CNT DESC");
		params.put("goodIdenNumb",srcGoodIdenNumb);
		params.put("goodName",srcGoodName);
		params.put("goodType",srcGoodType);
		params.put("goodSpec",srcGoodSpec);
		params.put("repreGood",srcRepreGood);
		
		logger.debug("params value ["+params+"]");
		
		//----------------페이징 세팅------------/
		int records = productSvc.getProductResultListCnt(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		//----------------조회------------/
		List<Map<String, Object>> list = null;
		if(records>0) {
			list = productSvc.getProductResultList(params, page, rows);
		}		
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	/** 운영사의 장바구니담기 */
	@RequestMapping("setCartInfo.sys")
	public ModelAndView setCartInfo(
			@RequestParam(value = "kind"			, required=true) 		String kind,
			@RequestParam(value = "commonOpt"		, defaultValue = "") 	String commonOpt,
			@RequestParam(value = "repreGoodNumb"	, required=false) 		String repreGoodNumb,
			@RequestParam(value = "vendorIds[]"		, required=true) 		String[] vendorIds,
			@RequestParam(value = "goodNumbs[]"		, required=false) 		String[] goodNumbs,
			@RequestParam(value = "ordQuans[]"		, required=true) 		String[] ordQuans,
			
			@RequestParam(value = "belongBorgId", required = true) String belongBorgId,
			@RequestParam(value = "belongSvcTypeCd", defaultValue = "") String belongSvcTypeCd,
			@RequestParam(value = "moveUserId", defaultValue = "") String moveUserId,
			HttpServletRequest request, ModelAndView modelAndView) {

		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("userId", moveUserId);
		searchMap.put("belongBorgId", belongBorgId);
		searchMap.put("svcTypeCd", belongSvcTypeCd);
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = ""; // 오류 메세지를 사용자에게 리턴하기 위해 사용.
		try{
			LoginUserDto loginUserDto = commonSvc.getLoginUserInfo(searchMap);
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("branchid"		, loginUserDto.getBorgId());
			params.put("userid"			, loginUserDto.getUserId());
			params.put("kind"			, kind);
			params.put("commonOpt"		, commonOpt);
			params.put("repreGoodNumb"	, repreGoodNumb);
			params.put("vendorIds"		, vendorIds);
			params.put("goodNumbs"		, goodNumbs);
			params.put("ordQuans"		, ordQuans);
			errMsg = cartManageSvc.setCartInfoBeforeChk(params);	// 장바구니 담기에 있어 오류가 있는지 체크.
			if("".equals(errMsg) == false){ throw new Exception(); }	// 체크중 문제가 있을 경우 의도적 오류 발생.
			cartManageSvc.setCartInfo(params);// 장바구니 담기 시작
		}catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(errMsg);
		}
        modelAndView.setViewName("jsonView");
        modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
	/** 운영사 :  상품 옵션 조회 */
	@RequestMapping("admProdOptList.sys")
	public ModelAndView admProdOptList( 
			// 조회 조건
			@RequestParam(value = "admGoodIdenNumb", defaultValue = "") String goodIdenNumb,	
			@RequestParam(value = "admVendorId", defaultValue = "") String vendorId,				
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params      = new HashMap<String, Object>();
		params.put("goodIdenNumb",goodIdenNumb);
		params.put("vendorId",vendorId);
		
		//----------------페이징 세팅------------/
		int records = productSvc.getAdmProdOptListCnt(params); 
		
		//----------------조회------------/
		List<Map<String, Object>> list = null;
		if(records>0) {
			list = productSvc.getAdmProdOptList(params);
		}		
		mav= new ModelAndView("jsonView");
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	/** 운영사 :  추가 상품 조회 */
	@RequestMapping("admAddProdList.sys")
	public ModelAndView getAddPdtList( 
			// 조회 조건
			@RequestParam(value = "admGoodIdenNumb", defaultValue = "") String goodIdenNumb,	
			HttpServletRequest req, ModelAndView mav) throws Exception{
		Map<String, Object> params      = new HashMap<String, Object>();
		params.put("goodIdenNumb",goodIdenNumb);
		
		//----------------페이징 세팅------------/
		int records = productSvc.getAddPdtListCnt(params); 
		
		//----------------조회------------/
		List<Map<String, Object>> list = null;
		if(records>0) {
			list = productSvc.getAddPdtList(params);
		}		
		mav= new ModelAndView("jsonView");
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	
	/** 사용자의 장바구니 상품 삭제 */
	@RequestMapping("deleteCartPdt.sys")
	public ModelAndView deleteCartPdt(
			@RequestParam(value = "goodIdenNumbs[]"	, required=true)String[] goodIdenNumbs,
			@RequestParam(value = "vendorIds[]"		, required=true)String[] vendorIds,
			
			@RequestParam(value = "belongBorgId", required = true) String belongBorgId,
			@RequestParam(value = "belongSvcTypeCd", defaultValue = "") String belongSvcTypeCd,
			@RequestParam(value = "moveUserId", defaultValue = "") String moveUserId,
			HttpServletRequest request, ModelAndView modelAndView) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("userId", moveUserId);
		searchMap.put("belongBorgId", belongBorgId);
		searchMap.put("svcTypeCd", belongSvcTypeCd);
		CustomResponse custResponse = new CustomResponse(true);
		List<Map<String, Object>> list = null;
		try{
			LoginUserDto loginUserDto = commonSvc.getLoginUserInfo(searchMap);
			Map<String, Object> params = new HashMap<String, Object>();
			
			params.put("branchid"		, loginUserDto.getBorgId());
			params.put("userid"			, loginUserDto.getUserId());
			params.put("goodIdenNumbs"	, goodIdenNumbs);
			params.put("vendorIds"		, vendorIds);
			list = cartManageSvc.deleteCartPdt(params);
		}catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list"		 , list);
		modelAndView.addObject("custResponse", custResponse);
		return modelAndView;
	}
	
	
	/** * 관리자의 주문요청 */
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
			
			@RequestParam(value = "belongBorgId", required = true) String belongBorgId,
			@RequestParam(value = "belongSvcTypeCd", defaultValue = "") String belongSvcTypeCd,
			@RequestParam(value = "moveUserId", defaultValue = "") String moveUserId,
			HttpServletRequest request, ModelAndView modelAndView) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("userId", moveUserId);
		searchMap.put("belongBorgId", belongBorgId);
		searchMap.put("svcTypeCd", belongSvcTypeCd);
		CustomResponse custResponse = new CustomResponse(true);
		try{
			LoginUserDto loginUserDto = commonSvc.getLoginUserInfo(searchMap);
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
}
