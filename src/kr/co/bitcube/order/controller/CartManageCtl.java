package kr.co.bitcube.order.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dto.CartMasterInfoDto;
import kr.co.bitcube.order.service.CartManageSvc;
import kr.co.bitcube.order.service.OrderRequestSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("order/cart")
public class CartManageCtl {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private CartManageSvc cartManageSvc;
	
	@Autowired
	private OrderRequestSvc orderRequestSvc;
	
	/**
	 * 장바구니 상품 등록 
	 * @param disp_good_id_Array
	 * @param ord_quan_Array
	 * @param modelAndView
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("addProductInCartTransGrid.sys")
	public ModelAndView addProductInCartTransGrid(
			@RequestParam(value = "disp_good_id_Array[]", required=true) String[] disp_good_id_Array,
			@RequestParam(value = "ord_quan_Array[]", required=true) String[] ord_quan_Array,
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/*----------------저장값 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("disp_good_id_Array"    ,   disp_good_id_Array);
		saveMap.put("ord_quan_Array"	    ,   ord_quan_Array);
		saveMap.put("groupid"				,	loginUserDto.getGroupId());
		saveMap.put("clientid"				,	loginUserDto.getClientId());
		saveMap.put("branchid"				,	loginUserDto.getBorgId());
		saveMap.put("userid"				,	loginUserDto.getUserId());
		
		logger.debug("saveMap value is the ["+saveMap+"]");
		
		logger.debug("saveMap value ["+saveMap+"]");
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			cartManageSvc.addProductInCartTransGrid(saveMap) ;
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
	 * 고객사 장바구니 
	 * @param req
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("cartMstInfo.sys")
	public ModelAndView cartMstInfo( HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchParams = new HashMap<String, Object>();    
		searchParams.put("groupid"  , loginUserDto.getGroupId());
		searchParams.put("clientid" , loginUserDto.getClientId());
		searchParams.put("branchid" , loginUserDto.getBorgId());
		searchParams.put("userid" , loginUserDto.getUserId());
		
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
        modelAndView.addObject("userList", directorList);
		// 배송지 정보 조회 
		modelAndView.setViewName("order/cart/cartInfo");
		return modelAndView;
	}
	
	/**
	 * 고객사 장바구니 
	 * @param req
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("cartProdInfo.sys")
	public ModelAndView cartProdInfo( HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchParams = new HashMap<String, Object>();
		searchParams.put("groupid"  , loginUserDto.getGroupId());
		searchParams.put("clientid" , loginUserDto.getClientId());
		searchParams.put("branchid" , loginUserDto.getBorgId());
		searchParams.put("userid"   , loginUserDto.getUserId());
		
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list", cartManageSvc.getCartProdInfo(searchParams));
		return modelAndView;
		
	}
	
	/**
	 * 고객사 상품 삭제 
	 * @param req
	 * @param mav
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delCartProdInfo.sys")
	public ModelAndView delCartProdInfo( 
			@RequestParam(value="disp_good_id_array[]", required=true)String[] disp_good_id_array,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		CustomResponse custResponse = new CustomResponse(true);
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchParams = new HashMap<String, Object>();
		searchParams.put("groupid"           , loginUserDto.getGroupId());
		searchParams.put("clientid"          , loginUserDto.getClientId());
		searchParams.put("branchid"          , loginUserDto.getBorgId());
		searchParams.put("userid"            , loginUserDto.getUserId());
		searchParams.put("disp_good_id_array", disp_good_id_array);
		try{
			cartManageSvc.delCartProdInfo(searchParams);
		}catch(Exception e){
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
		}
		
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
		
	}
	
	
	
	/**
	 * 장바구니 상품 삭제 
	 * @param disp_good_id
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("CartProductInfoByBuyerTransGrid.sys")
	public ModelAndView deleteCartProdTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "disp_good_id", defaultValue = "") String disp_good_id,
			@RequestParam(value = "orde_requ_quan", defaultValue = "") String orde_requ_quan,
			HttpServletRequest request, ModelAndView modelAndView) {
		
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupid"       , loginUserDto.getGroupId() );
		params.put("clientid"      , loginUserDto.getClientId() ); 
		params.put("branchid"      , loginUserDto.getBorgId()); 
		params.put("userId"        , loginUserDto.getUserId());
		params.put("disp_good_id"  , disp_good_id);
		params.put("orde_requ_quan", orde_requ_quan);
		/*----------------페이징 세팅------------*/
		
		logger.debug("params value ["+params+"]");
		CustomResponse custResponse = new CustomResponse(true);
		try{
			if(oper.equals("edit")) 
				cartManageSvc.editCartProductOrdQuan(params); 
			else if(oper.equals("del"))
				cartManageSvc.deleteCartProduct(params); 
				
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
		params.put("groupid"            , loginUserDto.getGroupId() );
		params.put("clientid"           , loginUserDto.getClientId() ); 
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
	
	@RequestMapping("vendorOrderRequest.sys")
	public ModelAndView addProductInCartTransGrid(
			ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		modelAndView.setViewName("jspViewResolver");
//		modelAndView.addObject("StandardCategory", categorySvc.getStandardCategoryList());
//		if(categorySvc.getStandardCategoryList() == null){
			
//		}
		modelAndView.setViewName("order/orderRequest/orderRequestedByVendor");
		return modelAndView;
	}

	@RequestMapping("cartAttachDelete.sys")
	public ModelAndView cartAttachDelete(
			@RequestParam(value = "groupId", required = true) String groupId,
			@RequestParam(value = "clientId", required = true) String clientId,
			@RequestParam(value = "branchId", required = true) String branchId,
			@RequestParam(value = "userId", required = true) String userId,
			@RequestParam(value = "file_list", required = true) String file_list,
			@RequestParam(value = "columnName", required = true) String columnName,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
	
		/*----------------저장값 세팅----------*/
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("groupId", groupId);
		saveMap.put("clientId", clientId);
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
	
	/** 주문요청 성공 후 일괄정보 초기화 */
	@RequestMapping("updateCartInfoTransGrid.sys")
	public ModelAndView updateCartInfoTransGrid( HttpServletRequest request, ModelAndView modelAndView) throws Exception{
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> searchParams = new HashMap<String, Object>();
		searchParams.put("groupid"  , loginUserDto.getGroupId());
		searchParams.put("clientid" , loginUserDto.getClientId());
		searchParams.put("branchid" , loginUserDto.getBorgId());
		searchParams.put("userid"   , loginUserDto.getUserId());
		modelAndView.setViewName("jsonView");
		cartManageSvc.updateCartInfo(searchParams);
		return modelAndView;
		
	}
}
