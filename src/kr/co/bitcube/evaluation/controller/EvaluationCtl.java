package kr.co.bitcube.evaluation.controller;


import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.common.utils.RequestUtils;

@Controller
@RequestMapping("evaluation")
public class EvaluationCtl {
	
	private Logger logger = Logger.getLogger(getClass());

	@Autowired
	private GeneralDao generalDao;
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private WebApplicationContext context;
	
	/**
	 * 대표상품 등록 팝업
	 */
	@RequestMapping("evaluateReg.sys")
	public ModelAndView evaluateReg(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		if (paramMap.get("itemId") != null) {
			modelAndView.addObject("item", generalDao.selectGernalObject("evaluation.selectItem", paramMap));
		}
		modelAndView.setViewName("evaluation/evaluateReg");
		return modelAndView;
	}	

	/**
	 * 공급사 지정자재 신규공급업체 신청
	 */
	@RequestMapping("evaluateApplication.sys")
	public ModelAndView evaluateAppllication(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		LoginUserDto userDto = (LoginUserDto) paramMap.get("userInfoDto");
		logger.info(userDto.getLoginId());
		if (userDto.getLoginId().equals("XXXXXXXXXX")) {
			modelAndView.addObject("businessNum", userDto.getBorgNm());
			modelAndView.setViewName("evaluation/evaluateApplication");
		} else {
			Map vendor = (Map) generalDao.selectGernalObject("evaluation.getVendor", paramMap);
			modelAndView.addObject("businessNum", vendor.get("BUSINESSNUM"));
			modelAndView.setViewName("evaluation/venEvaluateApplication");
		}
		return modelAndView;
	}

	/**
	 * 공급사 지정자재 신규공급업체 참여신청 팝업 
	 */
	@RequestMapping("evaluateAppl.sys")
	public ModelAndView evaluateAppl(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		if (!paramMap.get("applId").equals("")) {
			modelAndView.addObject("part", generalDao.selectGernalObject("evaluation.selectPartAppl", paramMap));
		} else {
			Map vendor = null;
			LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			if (userDto.getLoginId().equals("XXXXXXXXXX")) {
				paramMap.put("businessNum", userDto.getBorgNm());
				paramMap.put("vendorNm", userDto.getBorgNms());
			} else {
				vendor = (Map) generalDao.selectGernalObject("evaluation.getVendor", paramMap);
				paramMap.put("businessNum", vendor.get("BUSINESSNUM"));
				paramMap.put("vendorNm", vendor.get("VENDORNM"));
			}
			Map part = (Map) generalDao.selectGernalObject("evaluation.selectPartAppl2", paramMap);
			if (part.get("businessNum") == null) {
				part.put("BUSINESSNUM", paramMap.get("businessNum"));
				part.put("VENDORNM", paramMap.get("vendorNm"));
				if (!userDto.getLoginId().equals("XXXXXXXXXX")) {
					part.put("VENDORBUSITYPE", vendor.get("VENDORBUSITYPE"));
					part.put("VENDORBUSICLAS", vendor.get("VENDORBUSICLAS"));
					part.put("PRESSENTNM", vendor.get("PRESSENTNM"));
					part.put("PHONENUM", vendor.get("PHONENUM"));
				}
			}
			modelAndView.addObject("part", part);
		}
		
		modelAndView.setViewName("evaluation/evaluateAppl");
		return modelAndView;
	}		

	/**
	 * 업체평가 팝업 
	 */
	@RequestMapping("evaluateBusi.sys")
	public ModelAndView evaluateBusi(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("part", generalDao.selectGernalObject("evaluation.selectPartApplForBusi", paramMap));
		modelAndView.setViewName("evaluation/evaluateBusi");
		return modelAndView;
	}

	/**
	 * 품질평가 팝업 
	 */
	@RequestMapping("evaluateQuality.sys")
	public ModelAndView evaluateQuality(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("part", generalDao.selectGernalObject("evaluation.selectPartApplForQuality", paramMap));
		modelAndView.setViewName("evaluation/evaluateQuality");
		return modelAndView;
	}

	/**
	 * 중간평가 팝업 
	 */
	@RequestMapping("evaluateMiddle.sys")
	public ModelAndView evaluateMiddle(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("part", generalDao.selectGernalObject("evaluation.selectPartApplForMiddle", paramMap));
		modelAndView.setViewName("evaluation/evaluateMiddle");
		return modelAndView;
	}

	/**
	 * 중간평가 결재 팝업 
	 */
	@RequestMapping("evaluateMiddle2.sys")
	public ModelAndView evaluateMiddle2(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("part", generalDao.selectGernalObject("evaluation.selectPartApplForMiddle", paramMap));
		modelAndView.setViewName("evaluation/evaluateMiddle2");
		return modelAndView;
	}

	/**
	 * 중간평가 처리  
	 */
	@RequestMapping("updateEvaluateMiddle.sys")
	public ModelAndView updateEvaluateMiddle(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("loginUserDto", loginUserDto);
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);
		try {
			generalDao.updateGernal("evaluation.updatePartApplForMiddle", paramMap);  // 업데이트
			int cnt = generalDao.selectGernalCount("evaluation.selectPartApplForComplete", paramMap);
			// 모든 참가신청 상태가 90 이상이면 완료 처리 
			if (cnt == 0) {
				generalDao.updateGernal("evaluation.updateItemForComplete", paramMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}

	/**
	 * 제품평가 팝업 
	 */
	@RequestMapping("evaluateProd.sys")
	public ModelAndView evaluateProd(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("part", generalDao.selectGernalObject("evaluation.selectPartApplForProd", paramMap));
		modelAndView.setViewName("evaluation/evaluateProd");
		return modelAndView;
	}

	/**
	 * 최종평가 팝업 
	 */
	@RequestMapping("evaluateLast.sys")
	public ModelAndView evaluateLast(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("part", generalDao.selectGernalObject("evaluation.selectPartApplForLast", paramMap));
		modelAndView.addObject("attach", generalDao.selectGernalList("evaluation.selectLastEvalAttachList", paramMap));
		modelAndView.setViewName("evaluation/evaluateLast");
		return modelAndView;
	}

	/**
	 * 최종평가 팝업 
	 */
	@RequestMapping("evaluateLast2.sys")
	public ModelAndView evaluateLast2(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		modelAndView.addObject("part", generalDao.selectGernalObject("evaluation.selectPartApplForLast", paramMap));
		modelAndView.addObject("attach", generalDao.selectGernalList("evaluation.selectLastEvalAttachList", paramMap));
		modelAndView.setViewName("evaluation/evaluateLast2");
		return modelAndView;
	}

	/**
	 * 최종평가 처리  
	 */
	@RequestMapping("updateEvaluateLast.sys")
	public ModelAndView updateEvaluateLast(HttpServletRequest request, ModelMap paramMap, ModelAndView modelAndView) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		paramMap.put("loginUserDto", loginUserDto);
		RequestUtils.bind(request, paramMap);
		CustomResponse custResponse = new CustomResponse(true);
		try {
			generalDao.updateGernal("updatePartApplForLast", paramMap);  // 업데이트
			generalDao.deleteGernal("deleteLastEvalAttach", paramMap);   // 업데이트
			String [] attachSeq = request.getParameterValues("attachFileSeq");
			if (attachSeq != null) {
				Object object = context.getBean("seqLastEvalAttach");
				
				for (int i=0; i<attachSeq.length; i++) {
					String id = (String) MethodUtils.invokeMethod(object, "getNextStringId",null);
					paramMap.put("id", id);	//id생성
					paramMap.put("attachSeq", attachSeq[i]);
					generalDao.updateGernal("insertLiastEvalAttach", paramMap);  // 업데이트
				}
			}
			int cnt = generalDao.selectGernalCount("evaluation.selectPartApplForComplete", paramMap);
			// 모든 참가신청 상태가 90 이상이면 완료 처리 
			if (cnt == 0) {
				generalDao.updateGernal("evaluation.updateItemForComplete", paramMap);
			}
		} catch(Exception e) {
			logger.error("Exception : "+e);
			custResponse.setSuccess(false);
			custResponse.setMessage("System Excute Error!....");
			custResponse.setMessage(CommonUtils.getErrSubString(e,50));
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
}