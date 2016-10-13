package kr.co.bitcube.product.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.product.dto.ProductAppGoodDto;
import kr.co.bitcube.product.service.ProductAppSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("productApp")
public class ProductAppCtl {
	
	@Autowired
	private ProductAppSvc productAppSvc;
	
	private Logger logger = Logger.getLogger(getClass());
	
	@RequestMapping("productAppDetail.sys")
	public ModelAndView productAppDetail(
			@RequestParam(value = "app_good_id", defaultValue = "") String app_good_id,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		logger.debug("productAppDetail Method app_good_id value ["+app_good_id+"]");
		modelAndView.addObject("app_good_id",app_good_id);
		modelAndView.setViewName("product/app/productAppDetail");
		return modelAndView;
	}
	
	@RequestMapping("getAppProductDetailJQGrid.sys")
	public ModelAndView getAppProductDetailJQGrid(
			@RequestParam(value = "app_good_id", defaultValue = "0") String app_good_id,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
			
		params.put("app_good_id", app_good_id);
		modelAndView.addObject("list", productAppSvc.getAppProductDetail(params));
		modelAndView.setViewName("jsonView");
		
		return modelAndView;
	}
	
	/**
	 * 운영사 단가변경요청승인정보 조회  
	 */
	@RequestMapping("productAppList.sys")
	public ModelAndView productAdmList(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		modelAndView.setViewName("product/app/productAppList");
		return modelAndView;
	}
	
	/**
	 * 운영사 단가변경요청승인정보 검색 
	 */
	@RequestMapping("productAppListJQGrid.sys")
	public ModelAndView productAppListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "good_name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,
			@RequestParam(value = "srcConfirmStartDate", defaultValue = "") String srcConfirmStartDate,
			@RequestParam(value = "srcConfirmEndDate", defaultValue = "") String srcConfirmEndDate,
			@RequestParam(value = "srcChnPriceClas", defaultValue = "") String srcChnPriceClas,
			@RequestParam(value = "srcAppStsFlag", defaultValue = "") String srcAppStsFlag,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcGoodName", srcGoodName);
		params.put("srcConfirmStartDate", srcConfirmStartDate);
		params.put("srcConfirmEndDate", srcConfirmEndDate);
		params.put("srcChnPriceClas", srcChnPriceClas);
		params.put("srcAppStsFlag", srcAppStsFlag);
		
		logger.debug("params value ["+params+"]");
		//----------------페이징 세팅------------/
		int records = productAppSvc.getProductAppListCnt(params); //조회조건에 따른 카운트
		int total = (int)Math.ceil((float)records / (float)rows);
		
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		//----------------조회------------/
		List<ProductAppGoodDto> list = null;
		if(records>0) {
			list = productAppSvc.getProductAppList(params, page, rows);
		}
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 단가변경요청승인정보 상태값 변경
	 */
	@RequestMapping("productAppStatusTransGrid.sys")
	public ModelAndView productAppStatusTransGrid(
			@RequestParam(value = "app_good_id_array[]", required=true) String[] app_good_id_array, //단가변경Seq
			@RequestParam(value = "app_sts_flag", defaultValue = "") String app_sts_flag, //승인상태
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		String oper = "";
		if("1".equals(app_sts_flag)  ) { oper = "ok"; }
		else if("2".equals(app_sts_flag)  ) { oper = "cancel"; }
		
		/*----------------저장값 세팅----------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("oper", oper);
		saveMap.put("app_userid", loginUserDto.getUserId());
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		try {
			for(String app_good_id: app_good_id_array) {
				saveMap.put("app_good_id", app_good_id);
				logger.debug("productAppStatusTransGrid Method saveMap oper value ["+oper+"]");
				logger.debug("productAppStatusTransGrid Method saveMap app_good_id value ["+app_good_id+"]");
				logger.debug("productAppStatusTransGrid Method saveMap app_userid value ["+loginUserDto.getUserId()+"]");
				productAppSvc.setProductAppConfirmTransGrid(saveMap , modelAndView);
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
	
	@RequestMapping("setProductAppConfirmTransGrid.sys")
	public ModelAndView setProductAppConfirmTransGrid(
			@RequestParam(value = "oper", required = true) String oper,
			@RequestParam(value = "app_good_id", defaultValue = "") String app_good_id,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		LoginUserDto loginUserDto = null;
		/*----------------파라미터  세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			
			params.put("oper"		, oper);
			params.put("app_good_id", app_good_id);
			params.put("app_userid"	, loginUserDto.getUserId());
			
			logger.debug("productAppConfirmTransGrid Method parma oper value ["+oper+"]");
			productAppSvc.setProductAppConfirmTransGrid(params , modelAndView);
			
		} catch(Exception e) {
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
	 * 승인상세 공급사별 매입가격 정보를 조회한 
	 */
	@RequestMapping("getProdVendorUnitPriceChart.sys")
	public ModelAndView getProdVendorUnitPriceChart(
			@RequestParam(value = "good_iden_numb", defaultValue = "") String good_iden_numb,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = new CustomResponse(true);
		/*----------------파라미터  세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		try{
			
			params.put("good_iden_numb"		, good_iden_numb);
			modelAndView.addObject("prodVendor", productAppSvc.getProdVendorUnitPriceChart(params));
			modelAndView.addObject("sellUnit", productAppSvc.getprodSellUnitPriceChart(params));
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));	//Option(To Detail Message)
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
	
}
