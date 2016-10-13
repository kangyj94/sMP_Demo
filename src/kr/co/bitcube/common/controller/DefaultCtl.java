package kr.co.bitcube.common.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.DefaultSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("common")
public class DefaultCtl {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private DefaultSvc defaultSvc;
	
	/**
	 * ************************************************ 운영사 Default *****************************************
	 */
	
	
	/**
	 * 공지사항 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminBoardListJQGrid.sys")
	public ModelAndView adminBoardListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "board_No") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminNoticeList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 고객사상품등록요청 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminNewProductRequestListJQGrid.sys")
	public ModelAndView adminNewProductRequestListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "insert_date") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminNewProductRequestList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 진행중 또는 낙찰대기 입찰 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminNewProductBidListJQGrid.sys")
	public ModelAndView adminNewProductBidListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "bidid") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminNewProductBidList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 물량배분주문 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminVolumeOrderListJQGrid.sys")
	public ModelAndView adminVolumeOrderListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "orde_iden_numb") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminVolumeOrderList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 1일이상 미처리된 발주접수 대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminOrderReceivedListJQGrid.sys")
	public ModelAndView adminOrderReceivedListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "orde_iden_numb") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminOrderReceivedList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 납품요청일이 지난 출하대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminLastShipmentTargetListJQGrid.sys")
	public ModelAndView adminLastShipmentTargetListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "orde_iden_numb") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminLastShipmentTargetList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 3일 이상 미처리된 인수대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminTakeoverTargetListJQGrid.sys")
	public ModelAndView adminTakeoverTargetListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "orde_iden_numb") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminTakeoverTargetList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 전월실적 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminLastmonthPerformanceListJQGrid.sys")
	public ModelAndView adminLastmonthPerformanceListJQGrid(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id"		, loginUserDto.getUserId());
		params.put("create_borgid"	, loginUserDto.getBorgId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminLastmonthPerformanceList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 채권관리업체 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminBondsManagementCompListJQGrid.sys")
	public ModelAndView adminBondsManagementCompListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "SALE_OVER_DAY") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "clientId", defaultValue = "") String clientId,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("clientId", clientId);

		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminBondsManagementCompList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 미수채권 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminAccruedReceivableListJQGrid.sys")
	public ModelAndView adminAccruedReceivableListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "") String sidx,
			@RequestParam(value = "sord", defaultValue = "") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminAccruedReceivableList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * (-) 미수관리채무
	 */
	@RequestMapping("adminDebtReceivableListJQGrid.sys")
	public ModelAndView adminDebtReceivableListJQGrid(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		List<Map<String, Object>> list = defaultSvc.getAdminDebtReceivableList();

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 당월예상실적 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminForecastPerformanceListJQGrid.sys")
	public ModelAndView adminForecastPerformanceListJQGrid(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminForecastPerformanceList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 채권담당 사업장 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminManagementOrganListJQGrid.sys")
	public ModelAndView adminManagementOrganListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "borgcd") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminManagementOrganList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 공사유형별 사업장
	 */
	@RequestMapping("adminWorkManagementOrganListJQGrid.sys")
	public ModelAndView adminWorkManagementOrganListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "borgcd") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		/*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.selectWorkManagementOrganList(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 실적차트 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("adminPerformanceChartJQGrid.sys")
	public ModelAndView adminPerformanceChartJQGrid(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user_id", loginUserDto.getUserId());
		params.put("create_borgid"	, loginUserDto.getBorgId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getAdminPerformanceChart(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * ************************************************ 공급사 Default *****************************************
	 */
	
	
	/**
	 * 공지사항 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("venBoardListJQGrid.sys")
	public ModelAndView venBoardListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "board_No") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getVenNoticeList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 진행중 입찰 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("venProgressBidListJQGrid.sys")
	public ModelAndView venProgressBidListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "bidid") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("borg_id", loginUserDto.getBorgId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getVenProgressBidList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 공급사상품등록요청 정보 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("venProductRegReqListJQGrid.sys")
	public ModelAndView venProductRegReqListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "good_name") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("borg_id", loginUserDto.getBorgId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getVenProductRegReqList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 발주접수 대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("venOrderTargetListJQGrid.sys")
	public ModelAndView venOrderTargetListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "ORDE_IDEN_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("borg_id", loginUserDto.getBorgId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getVenOrderTargetList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 출하대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("venShipTargetListJQGrid.sys")
	public ModelAndView venShipTargetListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "ORDE_IDEN_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("borg_id", loginUserDto.getBorgId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getVenShipTargetList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * 배송완료 대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("venShippingDestiListJQGrid.sys")
	public ModelAndView venShippingDestiListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "ORDE_IDEN_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("borg_id", loginUserDto.getBorgId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getVenShippingDestiList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 반품요청 대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("venReturnRequestListJQGrid.sys")
	public ModelAndView venReturnRequestListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "RETU_IDEN_NUM") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			@RequestParam(value = "srcIsCen", defaultValue = "") String srcIsCen,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcIsCen", srcIsCen);
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("borg_id", loginUserDto.getBorgId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getVenReturnRequestList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * ************************************************ 물류센터 Default *****************************************
	 */
	
	/**
	 * picking 등록 대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("cenPickingRegListJQGrid.sys")
	public ModelAndView cenPickingRegListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "ORDE_IDEN_NUMB") String sidx,  
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getCenPickingRegList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 출고확정/인수증출력 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("cenFactoryConListJQGrid.sys")
	public ModelAndView cenFactoryConListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "ORDE_IDEN_NUMB") String sidx,  
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getCenFactoryConList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 *  송장입력/배송완료 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("cenInvoiceShippingListJQGrid.sys")
	public ModelAndView cenInvoiceShippingListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "ORDE_IDEN_NUMB") String sidx,  
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getCenInvoiceShippingList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 *  수탁발주내역 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("cenEntrustOrderListJQGrid.sys")
	public ModelAndView cenEntrustOrderListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "ORDE_IDEN_NUMB") String sidx,  
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getCenEntrustOrderList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 *  수탁입고 대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("cenEntrustStockListJQGrid.sys")
	public ModelAndView cenEntrustStockListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "ORDE_IDEN_NUMB") String sidx,  
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getCenEntrustStockList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 *  미재고 수탁상품 대상 DB조회후 리턴시켜주는 메소드
	 */
	@RequestMapping("cenProductStockListJQGrid.sys")
	public ModelAndView cenProductStockListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "GOOD_NAME") String sidx,  
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getCenProductStockList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * ************************************************ 고객사 Default *****************************************
	 */
	
	/**
	 * 공지사항 DB조회 후 리턴시켜주는 메소드
	 */
	@RequestMapping("buyBoardListJQGrid.sys")
	public ModelAndView buyBoardListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "board_No") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getBuyNoticeList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 마이카테고리 DB조회 후 리턴시켜주는 메소드
	 */
	@RequestMapping("buyMyCategoryListJQGrid.sys")
	public ModelAndView buyMyCategoryListJQGrid(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
			/*----------------조회조건 세팅------------*/
			LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("groupId" , loginUserDto.getGroupId());
			params.put("clientId" , loginUserDto.getClientId());
			params.put("branchId" , loginUserDto.getBorgId());
			
			
			 /*----------------조회------------*/
			List<Map<String, Object>> list = defaultSvc.getBuyMyCategoryList(params);
			
			modelAndView = new ModelAndView("jsonView");
			modelAndView.addObject("list", list);
			return modelAndView;
		}
	
	/**
	 * 신규품목요청내역 DB조회 후 리턴시켜주는 메소드
	 */
	@RequestMapping("buyNewItemStatusListJQGrid.sys")
	public ModelAndView buyNewItemStatusListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "newgoodid") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
			/*----------------조회조건 세팅------------*/
			LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			Map<String, Object> params = new HashMap<String, Object>();
			String orderString = " " + sidx + " " + sord + " ";
			params.put("orderString", orderString);
			params.put("borg_id", loginUserDto.getBorgId());
			params.put("srcOrderUserId", loginUserDto.getUserId());
			
			 /*----------------조회------------*/
			List<Map<String, Object>> list = defaultSvc.getBuyNewItemStatusList(params);
			
			modelAndView = new ModelAndView("jsonView");
			modelAndView.addObject("list", list);
			return modelAndView;
		}
	
	/**
	 * 관심상품 DB조회 후 리턴시켜주는 메소드
	 */
	@RequestMapping("buyWishlistItemListJQGrid.sys")
	public ModelAndView buyWishlistItemListJQGrid(
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
		/*----------------조회조건 세팅------------*/
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupid" , loginUserDto.getGroupId());
		params.put("clientid" , loginUserDto.getClientId());
		params.put("branchid" , loginUserDto.getBorgId());
		
		/*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getBuyWishlistItemList(params);
        
        modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 발주대기 COUNT DB조회 후 리턴시켜주는 메소드
	 */
	@RequestMapping("buyOrderAtmosphericList.sys")
	public ModelAndView buyOrderAtmosphericList(
			@RequestParam(value = "srcStartDate", required = true) String srcStartDate,
			@RequestParam(value = "srcEndDate", required = true) String srcEndDate,
			HttpServletRequest request, ModelAndView modelAndView) throws Exception {
		
			/*----------------조회조건 세팅------------*/
			LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("srcGroupId", loginUserDto.getGroupId());
			params.put("srcClientId", loginUserDto.getClientId());
			params.put("srcBranchId", loginUserDto.getBorgId());
			params.put("srcUserId", loginUserDto.getUserId());
			params.put("srcStartDate", srcStartDate);
			params.put("srcEndDate", srcEndDate);
			
			 /*----------------조회------------*/
			Map<String, Object> cntMap = defaultSvc.getBuyOrderConditionListCnt(params);
			modelAndView.setViewName("jsonView");
			modelAndView.addObject("cartCnt", (Integer) cntMap.get("cartCnt"));
			modelAndView.addObject("orderApprovalReadyCnt", (Integer) cntMap.get("orderApprovalReadyCnt"));
			modelAndView.addObject("orderReadyCnt", (Integer) cntMap.get("orderReadyCnt"));
			modelAndView.addObject("orderReceiveCnt", (Integer) cntMap.get("orderReceiveCnt"));
			modelAndView.addObject("deliveryReadyCnt", (Integer) cntMap.get("deliveryReadyCnt"));
			modelAndView.addObject("receiveReadyCnt", (Integer) cntMap.get("receiveReadyCnt"));
			modelAndView.addObject("receiveCnt", (Integer) cntMap.get("receiveCnt"));
			modelAndView.addObject("backRequestCnt", (Integer) cntMap.get("backRequestCnt"));
			modelAndView.addObject("backApprovalCnt", (Integer) cntMap.get("backApprovalCnt"));
			modelAndView.addObject("backRejectCnt", (Integer) cntMap.get("backRejectCnt"));
			return modelAndView;
		}
	
	
	
	
	/**
	 * 월별주문현황 차트조회
	 */
	@RequestMapping("buyChartForClientOrder.sys")
	public ModelAndView buyChartForClientOrder(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("clientId"	, loginUserDto.getClientId());
		params.put("branchId"	, loginUserDto.getBorgId());
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.buyChartForClientOrder(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 사업장별 주문현황 차트조회
	 */
	@RequestMapping("buyChartForBranchOrder.sys")
	public ModelAndView buyChartForBranchOrder(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("clientId"	, loginUserDto.getClientId());
		/*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.buyChartForBranchOrder(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}
	
	/**
	 * 주문현황 DB조회 후 리턴시켜주는 메소드
	 */
	@RequestMapping("buyOrderStatusListJQGrid.sys")
	public ModelAndView buyOrderStatusListJQGrid(
			@RequestParam(value = "sidx", defaultValue = "ORDE_IDEN_NUMB") String sidx,
			@RequestParam(value = "sord", defaultValue = "desc") String sord,
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		String orderString = " " + sidx + " " + sord + " ";
		params.put("orderString", orderString);
		params.put("srcGroupId", loginUserDto.getGroupId());
		params.put("srcClientId", loginUserDto.getClientId());
		params.put("srcBranchId", loginUserDto.getBorgId());
		params.put("srcOrderUserId", loginUserDto.getUserId());
		
        /*----------------조회------------*/
		List<Map<String, Object>> list = defaultSvc.getBuyOrderStatusList(params);

		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	/**
	 * VENDOR Quick Menu
	 * 
	 */
	@RequestMapping("vendorQuickMenuCnt.sys")
	public ModelAndView vendorQuickMenuCnt(
			ModelAndView modelAndView, HttpServletRequest request) throws Exception {
		LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
		
		String srcOrderStartDate = CommonUtils.getCustomDay("MONTH", -2);

		/*----------------조회조건 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("borgId"            , loginUserDto.getBorgId());
		params.put("userId"            , loginUserDto.getUserId());
		
		
		params.put("srcOrderStatusFlag", "59");
		params.put("srcOrderStartDate" , srcOrderStartDate);
		params.put("srcVendorId"       , loginUserDto.getBorgId());
		
		/*----------------조회------------*/
		Map<String, String> list = defaultSvc.getVendorQuickMenuCnt(params);
		
		modelAndView = new ModelAndView("jsonView");
		modelAndView.addObject("list", list);
		return modelAndView;
	}	
	
	
	
}
