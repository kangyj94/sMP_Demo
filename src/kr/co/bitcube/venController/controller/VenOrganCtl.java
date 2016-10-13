package kr.co.bitcube.venController.controller;

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
import kr.co.bitcube.order.dto.OrderDeliDto;
import kr.co.bitcube.order.service.DeliverySvc;
import kr.co.bitcube.order.service.OrderCommonSvc;
import kr.co.bitcube.order.service.OrderRequestSvc;
import kr.co.bitcube.order.service.PurchaseSvc;
import kr.co.bitcube.order.service.ReturnOrderSvc;
import kr.co.bitcube.organ.dto.SmpUsersDto;
import kr.co.bitcube.organ.dto.SmpVendorsDto;
import kr.co.bitcube.organ.service.OrganSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("venOrgan")
public class VenOrganCtl {
	
	private Logger logger = Logger.getLogger(getClass());
	

	@Autowired
	private OrganSvc organSvc;
	
	/**공급사조회
	 * @author ParkJoon
	 */
	@RequestMapping("organVenList.sys")
	public ModelAndView getOrgranVenList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organVenList");
		return mav;
	}
	
	/**
	 * 공급사조회 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("organVenListJQGrid.sys")
	public ModelAndView organVenListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "a.vendorId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcBusinessNum", defaultValue = "") String srcBusinessNum,
			@RequestParam(value = "srcAreaType", defaultValue = "") String srcAreaType,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,
			@RequestParam(value = "srcVendorNm", defaultValue = "") String srcVendorNm,		
			@RequestParam(value = "vendorSearchId", defaultValue = "") String vendorSearchId,
			@RequestParam(value = "classify", defaultValue = "") String classify,
	ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcBusinessNum", srcBusinessNum);
		params.put("srcAreaType", srcAreaType);
		params.put("srcIsUse", srcIsUse);
		params.put("srcVendorNm", srcVendorNm);
		params.put("vendorSearchId", vendorSearchId);
		params.put("classify", classify);
		if("vendorId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = organSvc.getOrganVendorListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<SmpVendorsDto> list = null;
        if(records>0) list = organSvc.getOrganVendorList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	

	/**공급사사용자조회
	 * @author ParkJoon
	 */
	@RequestMapping("organVenUserList.sys")
	public ModelAndView getOrganVenUserList( HttpServletRequest req, ModelAndView mav) throws Exception{
		mav.setViewName("organ/organVenUserList");
		return mav;
	}

	/**
	 * 공급사사용자조회 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("organVenUserListJQGrid.sys")
	public ModelAndView organVenUserListJQGrid(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "rows", defaultValue = "30") int rows,
			@RequestParam(value = "sidx", defaultValue = "a.vendorId") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcVendorId", defaultValue = "") String srcVendorId,
			@RequestParam(value = "srcUserNm", defaultValue = "") String srcUserNm,
			@RequestParam(value = "srcLoginId", defaultValue = "") String srcLoginId,
			@RequestParam(value = "srcIsUse", defaultValue = "1") String srcIsUse,		
		ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcVendorId", srcVendorId);
		params.put("srcUserNm", srcUserNm);
		params.put("srcLoginId", srcLoginId);
		params.put("srcIsUse", srcIsUse);
		if("userId".equals(sidx)) {
			sidx = "a."+sidx;
		}
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
		/*----------------페이징 세팅------------*/
        int records = organSvc.getOrganVendorUserListCnt(params); //조회조건에 따른 카운트
        int total = (int)Math.ceil((float)records / (float)rows);
		
        /*----------------조회------------*/
        List<SmpUsersDto> list = null;
        if(records>0) list = organSvc.getOrganVendorUserList(params, page, rows);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("page", page);
		modelAndView.addObject("total", total);
		modelAndView.addObject("records", records);
		modelAndView.addObject("list", list);
		return modelAndView;
	}

}
