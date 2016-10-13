package kr.co.bitcube.venController.controller; 

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.product.dao.ProductDao;
import kr.co.bitcube.product.service.ProductSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("venProduct")
public class VenProductCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private ProductSvc productSvc;
	
	@Autowired
	private ProductDao productDao;
	
	@Autowired
	private GeneralDao generalDao;
	
	/** * 추가상품 상품팝업 */
	@RequestMapping("selectVenProductDetailInfoPop.sys")
	public ModelAndView selectVenProductDetailInfoPop(
			@RequestParam(value = "ordeIdenNumb", required = true) 		String ordeIdenNumb,
			@RequestParam(value = "ordeSequNumb", required = true) 		String ordeSequNumb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto        userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ordeIdenNumb"	, ordeIdenNumb);
		params.put("ordeSequNumb"	, ordeSequNumb);
		params.put("userInfoDto"	, userInfoDto);
		//----------------조회------------/
		List<Map<String, Object>> list = productSvc.selectVenProductDetailInfoPop(params);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("list"		, list);
		return modelAndView;
	}
	
	
	/** 공급사 : 역주문 상품조회  */
	@RequestMapping("venOrdReqSrcPdtList.sys")
	public ModelAndView venOrdReqSrcPdtList( 
			@RequestParam(value = "page",defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "4") int rows,
			// 조회 조건
			@RequestParam(value = "srcGoodName", defaultValue = "") String srcGoodName,				//상품명
			@RequestParam(value = "srcGoodIdenNumb", defaultValue = "") String srcGoodIdenNumb,	//상품코드
			@RequestParam(value = "srcGoodType", defaultValue = "") String srcGoodType,				// 상품구분
			@RequestParam(value = "srcGoodSpec", defaultValue = "") String srcGoodSpec,				// 규격
			@RequestParam(value = "srcRepreGood", defaultValue = "") String srcRepreGood,				// 상품유형
			@RequestParam(value = "srcBranchId", defaultValue = "") String srcBranchId,				   // 고객사ID
			HttpServletRequest req, ModelAndView mav) throws Exception{
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		LoginUserDto loginUserDto =(LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME); 
		params.put("srcVenOrdPdt","true");//역주문 상품 조회 명시 값.
		params.put("srcVendorId", loginUserDto.getBorgId());
		params.put("srcGoodName",srcGoodName);
		params.put("srcGoodIdenNumb",srcGoodIdenNumb);
		params.put("srcGoodType",srcGoodType);
		params.put("srcGoodSpec",srcGoodSpec);
		params.put("srcRepreGood",srcRepreGood);
		params.put("srcBranchId",srcBranchId);
		
		
		//----------------페이징 세팅------------/
        int records = productSvc.venOrdReqSrcPdtListCnt(params); 
        int total = (int)Math.ceil((float)records / (float)rows);
        //----------------조회------------/
        List<Map<String,Object>> list = null;
        if(records>0){
        	list = productSvc.venOrdReqSrcPdtList(params, page, rows);
        }
		mav= new ModelAndView("jsonView");
		mav.addObject("page", page);
		mav.addObject("total", total);
		mav.addObject("records", records);
		mav.addObject("list", list);
		return mav;
	}
	
	/** 공급사 : 역주문 옵션 상품조회  */
	@RequestMapping("venOrdReqSrcOptPdtList.sys")
	public ModelAndView venOrdReqSrcOptPdtList( 
			@RequestParam(value = "kind"			, required=true) 		String kind,
			@RequestParam(value = "commonOpt"		, defaultValue = "") 	String commonOpt,
			@RequestParam(value = "repreGoodNumb"	, required=false) 		String repreGoodNumb,
			@RequestParam(value = "vendorIds[]"		, required=true) 		String[] vendorIds,
			@RequestParam(value = "goodNumbs[]"		, required=false) 		String[] goodNumbs,
			@RequestParam(value = "ordQuans[]"		, required=true) 		String[] ordQuans,
			HttpServletRequest req, ModelAndView mav) throws Exception{
		
		//----------------조회조건 세팅------------/
		Map<String, Object> params = new HashMap<String, Object>();
		LoginUserDto loginUserDto =(LoginUserDto)(req.getSession()).getAttribute(Constances.SESSION_NAME); 
		params.put("srcOptPdt","true");//역주문 옵션 상품 조회 명시 값.
		params.put("srcVendorId", loginUserDto.getBorgId());
        params.put("commonOpt"		, commonOpt);
        params.put("repreGoodNumb"	, repreGoodNumb);
        params.put("goodNumbs"		, goodNumbs);
        params.put("ordQuans"		, ordQuans);
		
        //----------------조회------------/
        List<Map<String,Object>> list = productSvc.venOrdReqSrcPdtList(params);
        if(list == null){ list = new ArrayList<Map<String, Object>>(); }
		mav= new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
}