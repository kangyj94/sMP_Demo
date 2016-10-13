package kr.co.bitcube.manage.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.adjust.dto.AdjustDto;
import kr.co.bitcube.adjust.service.AdjustSvc;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.Constances;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("manage")
public class ManageCtl {
	
	@Autowired
	private AdjustSvc adjustSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	private Logger logger = Logger.getLogger(getClass());

	@RequestMapping("maangeBondsOccurrence.sys")
	public ModelAndView maangeBondsOccurrence(
			@RequestParam(value = "clientId", required=true) String clientId,
			@RequestParam(value = "selectType", defaultValue="detail") String selectType,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		//업체정보
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("clientId"		, clientId);
		params.put("selectType"		, selectType);
		params.put("create_borgid"	, userInfoDto.getBorgId());

		AdjustDto detailInfo = adjustSvc.adjustBondsTotalList(params, -1, -1).get(0);
		AdjustDto priceInfo  = adjustSvc.adjustBondsCompanyPriceInfo(params);
		
		modelAndView.addObject("detailInfo", detailInfo);
		modelAndView.addObject("priceInfo", priceInfo);
		modelAndView.addObject("branchList"	, adjustSvc.selectBranchsByClientId(clientId));
		modelAndView.setViewName("manage/manageAdjustBondsOccurrence");
		return modelAndView;
	}
	
	/**
	 * 고객사별 손익실적 페이지 이동
	 */
	@RequestMapping("manageAnalysisCustomerListDetail.sys")
	public ModelAndView manageAnalysisCustomerListDetail(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("manage/manageAnalysisCustomerListDetail");
		return modelAndView;
	}
	
	/**
	 * 입찰상세 페이지
	 */
	@RequestMapping("manageBidDdetail.sys")
	public ModelAndView manageBidDdetail(
			@RequestParam(value = "bidid", defaultValue = "") String bidid,
			@RequestParam(value = "bidstate", defaultValue = "") String bidstate,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bidid", bidid);
		params.put("bidstate", bidstate);
		modelAndView.addObject("bidStateCd"		, commonSvc.getCodeList("BIDSTATE", 1));
		modelAndView.addObject("orderUnitCd"	, commonSvc.getCodeList("ORDERUNIT", 1));
		modelAndView.addObject("bidid", bidid);
		modelAndView.setViewName("manage/manageBidDetail");
		return modelAndView;
	}
}
