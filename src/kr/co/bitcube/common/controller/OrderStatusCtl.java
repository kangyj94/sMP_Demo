package kr.co.bitcube.common.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dao.CommonDao;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CustomResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("comOrd")
public class OrderStatusCtl {

	private Logger logger = Logger.getLogger(getClass());
	@Autowired
	private CommonSvc commonSvc;
	@Autowired
	private CommonDao commonDao;
	
	
	/**
	 * 주문번호로 처리 여부를 결정하는 상태를 가져옴
	 * @param orde_iden_numb_array
	 * @param purc_iden_numb_array
	 * @param deli_iden_numb_array
	 * @param rece_iden_numb_array
	 * @param deli_prod_quan_array
	 * @param orde_stat_flag
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getOrderStatus.sys")
	public ModelAndView getOrderStatus(
			@RequestParam(value = "orde_iden_numb_array[]", required = true) String[] orde_iden_numb_array,
			@RequestParam(value = "purc_iden_numb_array[]", required = false) String[] purc_iden_numb_array,
			@RequestParam(value = "deli_iden_numb_array[]", required = false) String[] deli_iden_numb_array,
			@RequestParam(value = "rece_iden_numb_array[]", required = false) String[] rece_iden_numb_array,
			@RequestParam(value = "prod_quan_array[]", required = false) String[] prod_quan_array,
			@RequestParam(value = "orde_stat_flag", required = true) String orde_stat_flag,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------처리수행 및 성공여부 세팅------------*/
		CustomResponse custResponse = null;
		try {
			custResponse = commonSvc.getOrderStatus(orde_iden_numb_array, purc_iden_numb_array, deli_iden_numb_array, rece_iden_numb_array, prod_quan_array, orde_stat_flag);
		} catch(Exception e) {
			logger.error("주문상태체크 ERROR : "+e);
			custResponse = new CustomResponse(false);
			custResponse.setMessage("주문상태체크 시 에러가 발생하였습니다.");
			custResponse.setMessage("관리자에게 문의 바랍니다.");
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;	
	}
	
	/**
	 * 반품가능수량을 가져오기
	 * @param orde_iden_numb
	 * @param purc_iden_numb
	 * @param deli_iden_numb
	 * @param rece_iden_numb
	 * @param request
	 * @param modelAndView
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getReturnProdQuanCnt.sys")
	public ModelAndView getReturnProdQuanCnt(
			@RequestParam(value = "orde_iden_numb", required = true) String orde_iden_numb,
			@RequestParam(value = "purc_iden_numb", required = true) String purc_iden_numb,
			@RequestParam(value = "deli_iden_numb", required = true) String deli_iden_numb,
			@RequestParam(value = "rece_iden_numb", required = true) String rece_iden_numb,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("orde_iden_numb", orde_iden_numb.split("-")[0]);
		param.put("orde_sequ_numb", orde_iden_numb.split("-")[1]);
		param.put("purc_iden_numb", purc_iden_numb);
		param.put("deli_iden_numb", deli_iden_numb);
		param.put("rece_iden_numb", rece_iden_numb);
		int returnProdQuanCnt = commonDao.selectReturnProdQuanCnt(param);
		modelAndView.setViewName("jsonView");
		modelAndView.addObject("returnProdQuan",returnProdQuanCnt);
		return modelAndView;	
	}
	
	@RequestMapping("getAllocationStatus.sys")
	public ModelAndView getAllocationStatus (
			@RequestParam(value="orde_iden_numb" ,required=true) String orde_iden_numb,
			@RequestParam(value="orde_requ_quan_array[]" ,required=true) String[] orde_requ_quan_array,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("orde_iden_numb", orde_iden_numb.split("-")[0]);
		saveMap.put("orde_sequ_numb", orde_iden_numb.split("-")[1]);
		saveMap.put("orde_requ_quan_array", orde_requ_quan_array);
		CustomResponse custResponse = null;
		try{
			custResponse = commonSvc.getAllocationStatus(saveMap);
		}catch(Exception e){
			logger.error("물량배분상태체크 ERROR : "+e);
			custResponse = new CustomResponse(false);
			custResponse.setMessage("물량배분상태체크 시 에러가 발생하였습니다.");
			custResponse.setMessage("관리자에게 문의 바랍니다.");
		}
		modelAndView.setViewName("jsonView");
		modelAndView.addObject(custResponse);
		return modelAndView;
	}
}
