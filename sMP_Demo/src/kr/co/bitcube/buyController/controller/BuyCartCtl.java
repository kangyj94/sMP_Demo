package kr.co.bitcube.buyController.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.bitcube.adjust.service.AdjustSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dto.CartMasterInfoDto;
import kr.co.bitcube.order.service.CartManageSvc;
import kr.co.bitcube.order.service.OrderRequestSvc;

@Controller
@RequestMapping("buyCart")
public class BuyCartCtl {

	private Logger logger = Logger.getLogger(getClass());
	@Autowired private OrderRequestSvc orderRequestSvc;
	@Autowired private CartManageSvc cartManageSvc;
	@Autowired private GeneralDao generalDao;
	@Autowired private AdjustSvc adjustSvc;
	

	/**
	 * 고객사 장바구니 
	 * @param req
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("buyCartInfo.sys")
	public ModelAndView cartMstInfo( HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
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
        modelAndView.addObject("cartList", cartManageSvc.getBuyCartInfo(searchParams));
		// 배송지 정보 조회 
		modelAndView.setViewName("order/cart/buyCartInfo");
		return modelAndView;
	}
	
	

	/**
	 *  장바구니 마스터 정보를 변경한다. 
	 * @param comp_iden_name
	 * @param orde_type_clas
	 * @param tran_deta_addr_seq
	 * @param tran_user_name
	 * @param tran_tele_numb
	 * @param mana_user_name
	 * @param orde_text_desc
	 * @param firstattachseq
	 * @param secondattachseq
	 * @param thirdattachseq
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("updateCartMstInfoTransGrid.sys")
	public ModelAndView updateCartMstInfo(
			@RequestParam(value = "comp_iden_name",    defaultValue = "comp_iden_name") String comp_iden_name,
			@RequestParam(value = "orde_type_clas",    defaultValue = "orde_type_clas") String orde_type_clas,
			@RequestParam(value = "tran_deta_addr_seq",defaultValue = "tran_deta_addr_seq") String tran_deta_addr_seq,
			@RequestParam(value = "tran_user_name",    defaultValue = "tran_user_name") String tran_user_name,
			@RequestParam(value = "tran_tele_numb",    defaultValue = "tran_tele_numb") String tran_tele_numb,
			@RequestParam(value = "mana_user_name",    defaultValue = "mana_user_name") String mana_user_name,
			@RequestParam(value = "orde_text_desc",    defaultValue = "orde_text_desc") String orde_text_desc,
			@RequestParam(value = "firstattachseq",    defaultValue = "firstattachseq") String firstattachseq,
			@RequestParam(value = "secondattachseq",   defaultValue = "secondattachseq") String secondattachseq ,
			@RequestParam(value = "thirdattachseq",    defaultValue = "thirdattachseq") String thirdattachseq,

			@RequestParam(value = "orde_requ_quan_arr[]", required = false) String[] orde_requ_quan_arr,
			@RequestParam(value = "disp_good_id_arr[]", required = false) String[] disp_good_id_arr,
			HttpServletRequest request, ModelAndView modelAndView) {

		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchid"           , loginUserDto.getBorgId()); 
		params.put("userId"             , loginUserDto.getUserId());
		params.put("comp_iden_name"     , comp_iden_name);
		params.put("orde_type_clas"     , orde_type_clas);
		params.put("tran_deta_addr_seq" , tran_deta_addr_seq);
		params.put("tran_user_name"     , tran_user_name);
		params.put("tran_tele_numb"     , tran_tele_numb);
		params.put("mana_user_name"     , mana_user_name);
		params.put("orde_text_desc"     , orde_text_desc);
		params.put("firstattachseq"     , firstattachseq);
		params.put("secondattachseq"    , secondattachseq);
		params.put("thirdattachseq"     , thirdattachseq);
		params.put("userid"             , loginUserDto.getUserId());
		params.put("orde_requ_quan_arr" , orde_requ_quan_arr);
		params.put("disp_good_id_arr"  	, disp_good_id_arr);
		
		logger.debug("Request Params Values "+ params );
		
		CustomResponse custResponse = new CustomResponse(true);
		
		try{
			
			cartManageSvc.updateCartMstInfo(params);
			
		}catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
        modelAndView.setViewName("jsonView");
        modelAndView.addObject(custResponse);
		return modelAndView;
	}
	

	@RequestMapping("cartAttachDelete.sys")
	public ModelAndView cartAttachDelete(
			@RequestParam(value = "branchId", required = true) String branchId,
			@RequestParam(value = "userId", required = true) String userId,
			@RequestParam(value = "file_list", required = true) String file_list,
			@RequestParam(value = "columnName", required = true) String columnName,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		
		saveMap.put("branchId", branchId);
		saveMap.put("userId", userId);
		
		if("firstattachseq".equals(columnName)) { saveMap.put("firstattachseq", file_list); } 
		else if("secondattachseq".equals(columnName)) { saveMap.put("secondattachseq", file_list); } 
		else if("thirdattachseq".equals(columnName)) { saveMap.put("thirdattachseq", file_list); } 
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			cartManageSvc.delCartAttachFile(saveMap);
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
		
	
	
	@RequestMapping("setCartInfo.sys")
	public ModelAndView setCartInfo(
			@RequestParam(value = "kind"			, required=true) 		String kind,
			@RequestParam(value = "commonOpt"		, defaultValue = "") 	String commonOpt,
			@RequestParam(value = "repreGoodNumb"	, required=false) 		String repreGoodNumb,
			@RequestParam(value = "vendorIds[]"		, required=true) 		String[] vendorIds,
			@RequestParam(value = "goodNumbs[]"		, required=false) 		String[] goodNumbs,
			@RequestParam(value = "ordQuans[]"		, required=true) 		String[] ordQuans,
			HttpServletRequest request, ModelAndView modelAndView) {

		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		String errMsg = ""; // 오류 메세지를 사용자에게 리턴하기 위해 사용.
		try{
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
	
	@RequestMapping("deleteCartPdt.sys")
	public ModelAndView deleteCartPdt(
			@RequestParam(value = "goodIdenNumbs[]"	, required=true)String[] goodIdenNumbs,
			@RequestParam(value = "vendorIds[]"		, required=true)String[] vendorIds,
			HttpServletRequest request, ModelAndView modelAndView) {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		List<Map<String, Object>> list = null;
		try{
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping("buyCommonCartPop.sys")
	public ModelAndView buyCommonCartPop(
			@RequestParam(value = "goodIdenNumb"	, defaultValue="")	String goodIdenNumb,
			@RequestParam(value = "vendorId"		, defaultValue="")		String vendorId,
			@RequestParam(value = "quan"			, defaultValue="")		String quan,
			HttpServletRequest request, ModelAndView modelAndView) {
		
		Map<String,Object> pdtInfo = null;
		ModelMap params = new ModelMap();
		params.put("goodIdenNumb", goodIdenNumb);
		params.put("vendorId", vendorId);
		params.put("quan", quan);
		
		boolean result = true;
		if( goodIdenNumb.equals("")|| vendorId.equals("")){
			result = false;
		}
		if( result == true ){
			pdtInfo = (Map<String,Object>) generalDao.selectGernalObject("order.cart.selectCartPopPdtInfo", params);
			if( pdtInfo == null ) { 
				result = false;
			}else{
				modelAndView.addObject("addGoodYn"		, (String)pdtInfo.get("ADD_GOOD"));
				modelAndView.addObject("repreGoodYn"	, (String)pdtInfo.get("REPRE_GOOD"));
				modelAndView.addObject("goodName"		, (String)pdtInfo.get("GOOD_NAME"));
				modelAndView.addObject("deliMiniquan"		, (String)pdtInfo.get("DELI_MINI_QUAN"));
			}
		}
		modelAndView.addObject("result"			, result);
		modelAndView.addObject("goodIdenNumb"	, goodIdenNumb);
		modelAndView.addObject("vendorId"		, vendorId);
		modelAndView.addObject("quan"			, quan);
		modelAndView.setViewName("jsonView");
		modelAndView.setViewName("order/cart/buyCommonCartPop");
		return modelAndView;
	}
	
	
	/** 고객사 장바구니 상품 수량 변경 */
	@RequestMapping("updateCartPdtOrdQuan.sys")
	public ModelAndView updateCartPdtOrdQuan(
			@RequestParam(value = "goodIdenNumbs[]"	, required=true)String[] goodIdenNumbs,
			@RequestParam(value = "vendorIds[]"		, required=true)String[] vendorIds,
			@RequestParam(value = "ordQuan"		, required=true)String ordQuan,
			HttpServletRequest request, ModelAndView modelAndView) {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		CustomResponse custResponse = new CustomResponse(true);
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			
			params.put("branchid"		, loginUserDto.getBorgId());
			params.put("userid"			, loginUserDto.getUserId());
			params.put("goodIdenNumbs"	, goodIdenNumbs);
			params.put("vendorIds"		, vendorIds);
			params.put("ordQuan"		, ordQuan);
			cartManageSvc.updateCartPdtOrdQuan(params);
		}catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("custResponse", custResponse);
		return modelAndView;
	}

	/**
	 * 결재자 조회
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getApprovalUserList")
	public ModelAndView getApprovalUserList(
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		try {
			modelAndView.addObject("list", generalDao.selectGernalList("order.cart.selectApprovalUserList", paramMap));
		}catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("custResponse", custResponse);
		
		return modelAndView;
	}

	/**
	 * 소속된 법인의 사업장 콤보박스
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getBranchListByClientId")
	public ModelAndView getBranchListByClientId(
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		modelAndView.addObject("list", adjustSvc.selectBranchsByClientId(userInfoDto.getClientId()));
		modelAndView.setViewName("jsonView");
		return modelAndView;
	}
	
	
	/**
	 * 대상결재자 조회
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getApprovalTargetList")
	public ModelAndView getApprovalTargetList(
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		CustomResponse custResponse = new CustomResponse(true);
		try {
			modelAndView.addObject("list", generalDao.selectGernalList("order.cart.selectApprovalTargetList", paramMap));
		}catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("custResponse", custResponse);
		
		return modelAndView;
	}
	
	/**
	 * 장바구니 결재자 저장
	 * @param request
	 * @param modelAndView
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("saveOrderArpproval")
	public ModelAndView saveOrderArpproval(
			HttpServletRequest request, ModelAndView modelAndView, ModelMap paramMap) throws Exception {
		
		CustomResponse customResponse = new CustomResponse(true);
		try {
			cartManageSvc.saveOrderArpproval(paramMap);
		}catch(Exception e) {
			logger.error("Exception : "+e);
			customResponse.setSuccess(false);
			customResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("customResponse", customResponse);
		return modelAndView;
	}
}
