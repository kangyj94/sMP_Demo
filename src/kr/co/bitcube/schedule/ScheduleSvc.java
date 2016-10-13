package kr.co.bitcube.schedule;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.adjust.service.AdjustSvc;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.MailInfoDto;
import kr.co.bitcube.common.dto.SmsEmailInfo;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.order.service.DeliverySvc;
import kr.co.bitcube.product.dao.ProductDao;
import kr.co.bitcube.product.dto.BuyProductDto;
//import kr.co.bitcube.quality.service.QualitySvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

@Service
public class ScheduleSvc {

	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private ScheduleDao scheduleDao;
	
	@Autowired
	private DeliverySvc deliverySvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private AdjustSvc adjustSvc;
	
	@Autowired
	private ProductDao productDao;
	
	//@Autowired
	//private QualitySvc qualitySvc;
	
	@Autowired private GeneralDao generalDao;
	
	/**
	 * 자동인수처리
	 * 인수처리대상(출하5일이 지난 출하상태의 주문)을 조회하여 자동으로 인수처리함
	 * @throws Exception
	 */
	public void autoOrderReceiveProcess() throws Exception {
		//추가상품 하위주문은 조회대상에서 제외, 20151220 제임스강
		List<Map<String,Object>> orderList = scheduleDao.selectAutoReceiveListAfter5Day();	//인수처리대상 조회
		
		//추가상품 하위주문을 추가
		List<Map<String,Object>> subOrderList = new ArrayList<Map<String,Object>>();
		for(Map<String,Object> orderMap : orderList) {
			String add_orde_sequ_numb = (String) orderMap.get("ADD_ORDE_SEQU_NUMB");
			if(!"".equals(CommonUtils.getString(add_orde_sequ_numb))) {
				Map<String,Object> tmpMap = new HashMap<String,Object>();
				tmpMap.put("orde_iden_numb", add_orde_sequ_numb);
				tmpMap.put("purc_iden_numb", orderMap.get("purc_iden_numb"));
				tmpMap.put("deli_iden_numb", orderMap.get("deli_iden_numb"));
				tmpMap.put("deli_prod_quan", String.valueOf(orderMap.get("deli_prod_quan")));
				subOrderList.add(tmpMap);
			}
		}
		if(subOrderList.size()>0) orderList.addAll(subOrderList);

		String[] orde_iden_numb_array = new String[orderList.size()];
		String[] purc_iden_numb_array = new String[orderList.size()];
		String[] deli_iden_numb_array = new String[orderList.size()];
		String[] deli_prod_quan_array = new String[orderList.size()];
		int arrayCnt = 0;
		for(Map<String,Object> orderMap : orderList) {
			orde_iden_numb_array[arrayCnt] = (String) orderMap.get("orde_iden_numb");
			purc_iden_numb_array[arrayCnt] = (String) orderMap.get("purc_iden_numb");
			deli_iden_numb_array[arrayCnt] = (String) orderMap.get("deli_iden_numb");
			deli_prod_quan_array[arrayCnt++] = String.valueOf(orderMap.get("deli_prod_quan"));
		}
		Map<String,Object> saveMap = new HashMap<String,Object>();
		saveMap.put("orde_iden_numb_array", orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", deli_iden_numb_array);
		saveMap.put("deli_prod_quan_array", deli_prod_quan_array);
		LoginUserDto userDto = new LoginUserDto();
		userDto.setUserId("0");
		
		deliverySvc.orderReceiveProcess(saveMap, userDto);	//인수처리
	}
	
	/**
	 * 장기미수채권
	 * 미수관리대상 채권을 조회하여 채권상태을 관리로 변경/법인의 주문제한여부 변경
	 * 미수관리대상 채권을 조회하여 법인담당 운영자와 승인권한을 가지고 있는 운영자에게 SMS을 발송
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void autoNotReceiveBondExe() throws Exception {
		List<Map<String,Object>> notReceiveSaleList = scheduleDao.selectNotReceiveSaleList();	//장기 미수채권관리대상 조회
		
		//주문제한 걸릴 법인밑의 사업자 모든 사용자를 검색
//		List<Map<String, Object>> attemptedReceiveSaleList = scheduleDao.selectAttemptedReceiveSaleList(); //
//		for(int i=0; i<attemptedReceiveSaleList.size(); i++){
//			String mobile = attemptedReceiveSaleList.get(i).get("MOBILE").toString();
//			String msg = "SK텔레시스 입니다. 귀사는 자재 구매대금이 미결제 되어 ";
//			msg += CommonUtils.getCurrentDate().substring(5, 7)+"월 "+CommonUtils.getCurrentDate().substring(8, 10)+"일 부로 "; 
//			msg += "Okplaza를 통한 주문이 제한되었습니다. 상세내역은 Okplaza에서 확인하여 주시길 바랍니다."; 
//			commonSvc.sendSeserveSms(mobile, msg, CommonUtils.getCurrentDate()+ " 13:00:00","0221292045");
//		}
		
		List<Map<String, Object>> tempList = new ArrayList<Map<String,Object>>();
		for(Map<String,Object> listMap : notReceiveSaleList){
			Map<String,Object> tempMap = new HashMap<String,Object>();
			tempMap.put("CLIENTID", (String)listMap.get("CLIENTID"));
			tempMap.put("CLIENTNM", (String)listMap.get("CLIENTNM"));
			tempList.add(tempMap);
			
			//미수채권의 상태을 관리로 변경
			scheduleDao.updateManageBorgOfNotReceiveSale((String)listMap.get("sale_sequ_numb"));
			//미수채권 법인의 주문제한여부을 제한(상태를 바꾸지 않고 SMS만 보내게 바꿈)
//			scheduleDao.updateBorgOrderLimitByClientId((String)listMap.get("CLIENTID"));
		}
		
		
		
		
//		tempList = new ArrayList<Map<String,Object>>(new HashSet<Map<String,Object>>(tempList));	//미수채권 법인정보 중복제거
		
		//채권관리담당 운영자, 승인자에게 SMS발송
//		for(Map<String,Object> listMap : tempList){
			/*	채권담당자에게 SMS발송 로직 변경 -> 아래 변경로직 추가(2013-07-21 By Jameskang)
			//채권관리담당 운영자에게 SMS발송
			List<SmsEmailInfo> managerSmsEmailInfoList = null;
			//String tmpClientId = (String) listMap.get("CLIENTID");
			String tmpBranchId = (String) listMap.get("BRANCHID");
			if(tmpBranchId==null || "".equals(tmpBranchId) || "0".equals(tmpBranchId)) {	//법인으로 채권생성된 매출일 경우
				//채권담당자는 사업장단위로 되어 있기 때문에 법인으로 채권담당자를 끌어 올 수 없다.
				//managerSmsEmailInfoList = commonSvc.getManagerSmsEmailInfoByManageClientId((String) listMap.get("CLIENTID"));	//채권담당 운영자 Email,Sms 정보 가져오기(법인 밑에 있는 담당자들)
			} else {
				managerSmsEmailInfoList = commonSvc.getBondManagerSmsEmailInfoByBranchId(tmpBranchId);	//사업장번호로 채권담당자 Email, Sms 정보 가져오기
			}
			if(managerSmsEmailInfoList != null) {
				for(SmsEmailInfo smsEmailInfo : managerSmsEmailInfoList) {
					if(smsEmailInfo.isSms()) {
						try {
							commonSvc.sendSeserveSms(smsEmailInfo.getMobileNum(), "[OK플라자] ["+listMap.get("CLIENTNM")+"]가 장기미수채권업체가 되었습니다.", CommonUtils.getCurrentDate()+ " 09:00");
						} catch(Exception e) {
							logger.error("SMS(managerSmsEmailInfoList) Save Errro : "+e);
						}
					}
				}
			}
			*/
			
			//채권관리담당 운영자에게 SMS발송
//			List<SmsEmailInfo> managerSmsEmailInfoList = commonSvc.getManagerSmsEmailInfosByManageClientId((String) listMap.get("CLIENTID"));
//			for(SmsEmailInfo smsEmailInfo : managerSmsEmailInfoList) {
//				if(smsEmailInfo.isSms()) {
//					try {
//						commonSvc.sendSeserveSms(smsEmailInfo.getMobileNum(), "[OK플라자] ["+listMap.get("CLIENTNM")+"]가 장기미수채권업체가 되었습니다.", CommonUtils.getCurrentDate()+ " 09:00:00");
//					} catch(Exception e) {
//						logger.error("SMS(managerSmsEmailInfoList) Save Errro : "+e);
//					}
//				}
//			}
			
			//승인 권한을 가진 운영자에게 SMS발송
//			List<SmsEmailInfo> approverSmsEmailInfoList = commonSvc.getApproverSmsEmailInfoByRoleCd("ADM_APP");	//운영사 승인자 Email,Sms 정보 가져오기
//			for(SmsEmailInfo smsEmailInfo : approverSmsEmailInfoList) {
//				if(smsEmailInfo.isSms()) {
//					try {
//						commonSvc.sendSeserveSms(smsEmailInfo.getMobileNum(), "[OK플라자] ["+listMap.get("CLIENTNM")+"]가 장기미수채권업체가 되었습니다.", CommonUtils.getCurrentDate()+ " 09:00:00");
//					} catch(Exception e) {
//						logger.error("SMS(approverSmsEmailInfoList) Save Errro : "+e);
//					}
//				}
//			}
			
			//파워운영장 권한에게만 SMS발송
//			List<Map<String, Object>> isAdmPowerList = scheduleDao.selectAdmPowerList();
//			for(int i=0; i<isAdmPowerList.size(); i++){
//				try{
//					commonSvc.sendSeserveSms(isAdmPowerList.get(i).get("MOBILE").toString(), "[OK플라자] ["+listMap.get("CLIENTNM")+"]가 장기미수채권업체가 되었습니다.", CommonUtils.getCurrentDate()+ " 09:00:00");
//				}catch(Exception e){
//					logger.error("SMS(approverSmsEmailInfoList) Save Errro : "+e);
//				}
//			}
//		}
		
		//파워운영장 권한에게만 SMS발송(대상은 관리업체)
//		if(tempList!=null && tempList.size()>0) {
//			String smsMsg = "";
//			if(tempList.size()>1) {
//				smsMsg = "[OK플라자] ["+tempList.get(0).get("CLIENTNM")+"] 외 "+(tempList.size()-1)+"개가 관리 미수채권업체가 되었습니다.";
//			} else {
//				smsMsg = "[OK플라자] ["+tempList.get(0).get("CLIENTNM")+"]가 관리 미수채권업체가 되었습니다.";
//			}
//			List<Map<String, Object>> isAdmPowerList = scheduleDao.selectAdmPowerList();
//			for(int i=0; i<isAdmPowerList.size(); i++){
//				try{
//					commonSvc.sendSeserveSms(isAdmPowerList.get(i).get("MOBILE").toString(), smsMsg, CommonUtils.getCurrentDate()+ " 09:00:00");
//				}catch(Exception e){
//					logger.error("SMS(approverSmsEmailInfoList) Save Errro : "+e);
//				}
//			}
//		}
		
		/* 정연백 과장님 요청으로 미발송 처리 20160623 by kkbum2000
		/*-----------------------------대금결제일이 하루 지난 법인담당자에게 SMS발송-------------------------------*/
//		List<Map<String,Object>> buyCltSmsList = scheduleDao.selectCltUserSmsList();	//채권만기일이 하루 지난 법인담당자정보
//		for(int i=0;i<buyCltSmsList.size();i++) {
//			Map<String,Object> buyCltSmsMap = buyCltSmsList.get(i);
//			String smsMsg = "SK텔레시스 입니다. 귀사가 약속한 결제대금 "+CommonUtils.getIntString(buyCltSmsMap.get("PAYMENT").toString())+
//					"원 (VAT포함)이 미 결제 되었습니다. 대금결제기일("+CommonUtils.getString(buyCltSmsMap.get("EXPIRATION_DATE"))+") 약속 "+
//					"불이행시 자재주문에 제한을 받을수 있으니 적극 협조하여 주시기 바라며, "+
//					"상세 내역은 Okplaza에서 확인하여 주시길 바랍니다.";
//			try {
//				//commonSvc.sendSeserveSms(buyCltSmsMap.get("MOBILE").toString(), smsMsg, CommonUtils.getCurrentDate()+ " 09:10:00");
//			} catch(Exception e) {
//				logger.error("SMS(buyCltSmsList) Save Errro : "+e);
//			}
//		}

		/*-----------------------------법인주문제한 처리 및 관리자에게 SMS발송-------------------------------*/
		List<Map<String,Object>> orderLimitList = scheduleDao.selectOrderLimitList();	//관리상태의 채권 중 10,30일이 지난 업체 조회
		for(Map<String,Object> listMap : orderLimitList){
			//미수채권 법인의 주문제한여부을 제한처리
			scheduleDao.updateBorgOrderLimitByClientId((String)listMap.get("CLIENTID"));
		}
		//파워운영장 권한에게만 SMS발송(대상은 관리상태의 채권 중 10,30일이 지난 업체)
		/* 정연백 과장님 요청으로 SMS 미발송처리 20160701 by kkbum2000 */
//		if(orderLimitList!=null && orderLimitList.size()>0) {
//			String smsMsg = "";
//			if(orderLimitList.size()>1) {
//				smsMsg = "[OK플라자] ["+orderLimitList.get(0).get("CLIENTNM")+"] 외 "+(orderLimitList.size()-1)+"개 업체가 주문제한대상이 되었습니다.";
//			} else {
//				smsMsg = "[OK플라자] ["+orderLimitList.get(0).get("CLIENTNM")+"]업체가 주문제한대상이 되었습니다.";
//			}
//			List<Map<String, Object>> isAdmPowerList = scheduleDao.selectAdmPowerList();
//			for(int i=0; i<isAdmPowerList.size(); i++){
//				try{
//					commonSvc.sendSeserveSms(isAdmPowerList.get(i).get("MOBILE").toString(), smsMsg, CommonUtils.getCurrentDate()+ " 09:00:00");
//				}catch(Exception e){
//					logger.error("SMS(isAdmPowerList) Save Errro : "+e);
//				}
//			}
//		}
		
		scheduleDao.updateStatusNotGiveBuyManage();	//장기 미지급채무관리대상을 관리상태로 변경
	}

	/**
	 * 매출합계가 반제금액보다 크면 경과월과 초과월을 update
	 * 매입합계가 반제금액보다 크면 경과월과 초과월을 update
	 */
	public void autoBondOverMonthDayExe() throws Exception {
		scheduleDao.updateBondOverMonthDay();
		scheduleDao.updateBuyOverMonthDay();
	}

	/**
	 * 법인별 1일에서 현재일까지의 주문금액의 합이 전월실적의 20%을 넘기면 법인담당 운영자에게 SMS발송
	 * 현재월의 주문금액이 천만원보다 클경우 (전월 매출액+전월매출액20%)이 현재월의 주문금액합과 보다 작을 경우 담당자에게 SMS발송 
	 */
	public void sendToManagerOfOverOrder() {
		List<Map<String,Object>> saleList = scheduleDao.selectLastMonthSaleList();	//전월매출실적을 가져옴
		for(Map<String,Object> saleMap : saleList) {
			//String clientId = (String) saleMap.get("clientid");
			//String clientNm = (String) saleMap.get("clientnm");
			String branchId = (String) saleMap.get("BRANCHID");
			String branchNm = (String) saleMap.get("BRANCHNM");
			
//			double sale_requ_amou = (double) saleMap.get("sale_requ_amou");
//			sale_requ_amou = sale_requ_amou + (sale_requ_amou*0.2);	//전월매출액 + 전월매출액*20%
			String tempValue = String.valueOf(saleMap.get("sale_requ_amou"));
			double sale_requ_amou = Double.valueOf(tempValue);
			sale_requ_amou = sale_requ_amou + (sale_requ_amou*0.2);	//전월매출액 + 전월매출액*20%
			
			if(branchId==null || "".equals(branchId) || "0".equals(branchId)) {	//법인으로 채권생성된 매출일 경우는 처리 불가
			} else {
				double orderAmountSum = scheduleDao.selectOrderAmountSum(branchId);	//사업장의 현재월 주문금액을 가져옴
				if(orderAmountSum>10000000 && orderAmountSum>sale_requ_amou) {	//주문액이 천만원보다 크고 전월매출액20% 보다 클경우
					//법인담당 운영자에게 SMS발송
					/* 정연백 과장님 요청으로 SMS 미발송 처리 20160701 by kkbum2000 */
					//List<SmsEmailInfo> managerSmsEmailInfoList = commonSvc.getManagerSmsEmailInfoByManageClientId(clientId);	//법인담당 운영자 Email,Sms 정보 가져오기
					//공사유형담당 운영자에게 SMS발송
//					List<SmsEmailInfo> managerSmsEmailInfoList = commonSvc.getManagerSmsEmailInfoByManageBranchId(branchId);	//사업장의 공사유형담당자(운영사) Email,Sms 정보 가져오기
//					for(SmsEmailInfo smsEmailInfo : managerSmsEmailInfoList) {
//						if(smsEmailInfo.isSms()) {
//							try {
//								commonSvc.sendSeserveSms(smsEmailInfo.getMobileNum(), "[OK플라자] ["+branchNm+"]업체 당월주문 전월매출의 20% Up", CommonUtils.getCurrentDate()+ " 09:00:00");
//							} catch(Exception e) {
//								logger.error("SMS(managerSmsEmailInfoList) Save Errro : "+e);
//							}
//						}
//					}
				}
			}
		}
	}
	
	/**
	 * 출하후 4일이 지난 줄하주문의 주문자에게 인수확인 독려 
	 */
	public void noticeToOrderUserOforderStock() {
		List<Map<String,Object>> noticeUserList = scheduleDao.selectOrderStockNoticeUserList();
		for(Map<String,Object> userMap : noticeUserList) {
			String userId = (String) userMap.get("orde_user_id");
			SmsEmailInfo smsEmailInfo = commonSvc.getUserSmsEmailInfoByUserId(userId);	//주문자 Email,Sms 정보 가져오기
			if(smsEmailInfo.isSms()) {
				try {
					commonSvc.sendSeserveSms(smsEmailInfo.getMobileNum(), "[OK플라자] 인수대상 주문이 존재합니다. 해당 주문은 3일후 자동인수처리됩니다", CommonUtils.getCurrentDate()+ " 10:00:00");
				} catch(Exception e) {
					logger.error("SMS(noticeToOrderUserOforderStock) Save Errro : "+e);
				}
			}
		}
	}

	/**
	 * 하루동안 주문한 공급사 상품 주문개수을 상품공급사의 주문횟수에 반영
	 */
	public void popularProductExe() {
		scheduleDao.updateOrderCntOfMcgoodVendor();
	}

	/**
	 * 입찰시간이 만료되는 입찰의 상태을 변경
	 * 아무도 투찰하지 않았을 경우 고객사상품등록요청정보에는 입찰완료(유찰):40, 상품입찰공고정보에는 입찰상태을 유찰:90
	 * 한업체라도 투찰했을 경우 고객사상품등록요청정보에는 입찰완료:30, 상품입찰공고정보에는 입찰상태을 입찰마감:20
	 */
	public void bidEndExe() {
		List<Map<String,Object>> failBidList = scheduleDao.selectFailBidList();	//유찰대상 입찰정보
		for(Map<String,Object> failBidMap : failBidList) {
			int bidid = (Integer) failBidMap.get("bidid");
			int newgoodid = (Integer) failBidMap.get("newgoodid");
			Map<String,Object> saveMap = new HashMap<String,Object>();
			saveMap.put("bidid", bidid);
			saveMap.put("bidstate", "90");
			scheduleDao.updateMcbidStatus(saveMap);	//상품입찰공고 유찰로 변경
			if(newgoodid>0) {	//고객사상품등록요청 입찰완료(유찰)로 변경
				saveMap.clear();
				saveMap.put("newgoodid", newgoodid);
				saveMap.put("state", "40");
				scheduleDao.updateMcnewgoodRequestStatus(saveMap);
			}
		}
		
		List<Map<String,Object>> endBidList = scheduleDao.selectEndBidList();	//입찰마감대상 입찰정보
		for(Map<String,Object> endBidMap : endBidList) {
			int bidid = (Integer) endBidMap.get("bidid");
			int newgoodid = (Integer) endBidMap.get("newgoodid");
			Map<String,Object> saveMap = new HashMap<String,Object>();
			saveMap.put("bidid", bidid);
			saveMap.put("bidstate", "20");
			scheduleDao.updateMcbidStatus(saveMap);	//상품입찰공고 마감로 변경
			if(newgoodid>0) {	//고객사상품등록요청 입찰완료로 변경
				saveMap.clear();
				saveMap.put("newgoodid", newgoodid);
				saveMap.put("state", "30");
				scheduleDao.updateMcnewgoodRequestStatus(saveMap);
			}
		}
	}

	/**
	 * 매출반제처리
	 * Sap 입금(반제)내역 수신
	 * 매출정보의 반제번호, 반제금액, 채권상태, 반제완료일자 변경
	 */
	public void salePaymentExe() {
		List<Map<String,Object>> paymentList = scheduleDao.selectPaymentList();	//Sap 반제수신 대상 매출정보
		for(Map<String,Object> paymentMap : paymentList) {
			String clos_sale_date = String.valueOf(paymentMap.get("clos_sale_date"));
			String sale_sequ_numb = (String) paymentMap.get("sale_sequ_numb");
			String rece_pay_amou = String.valueOf(paymentMap.get("pay_amou"));
			String sap_jour_numb = (String) paymentMap.get("sap_jour_numb");
			String rece_user_id = "0";
			Map<String,Object> saveMap = new HashMap<String,Object>();
			saveMap.put("clos_sale_date", clos_sale_date);
			saveMap.put("sale_sequ_numb", sale_sequ_numb);
			saveMap.put("rece_pay_amou", rece_pay_amou);
			saveMap.put("sap_jour_numb", sap_jour_numb);
			saveMap.put("rece_user_id", rece_user_id);
			saveMap.put("payDate"	, CommonUtils.getCurrentDate());
			try{ adjustSvc.salesDepositConfirm(saveMap); }	//매출반제처리 
			catch(Exception e) { 
				
				logger.error("salePaymentExe Service Error : "+e); 
			}
		}
	}

	/**
	 * 매입반제처리
	 * Sap 지급(반제)내역 수신
	 * 매입정보의 반제번호, 반제금액, 채무상태, 반제완료일자 변경
	 */
	public void buyPaymentExe() {
		List<Map<String,Object>> givePayList = scheduleDao.selectGivePayList();	//Sap 반제수신 대상 매입정보
		for(Map<String,Object> givePayMap : givePayList) {
			String clos_buyi_date = String.valueOf(givePayMap.get("clos_buyi_date"));
			String buyi_sequ_numb = (String) givePayMap.get("buyi_sequ_numb");
			String rece_pay_amou = String.valueOf(givePayMap.get("pay_amou"));
			String sap_jour_numb = (String) givePayMap.get("sap_jour_numb");
			String rece_user_id = "0";
			Map<String,Object> saveMap = new HashMap<String,Object>();
			saveMap.put("buyi_sequ_numb", buyi_sequ_numb);
			saveMap.put("clos_buyi_date", clos_buyi_date);
			saveMap.put("rece_pay_amou" , rece_pay_amou);
			saveMap.put("sap_jour_numb" , sap_jour_numb);
			saveMap.put("rece_user_id"	, rece_user_id);
			saveMap.put("payDate"	, CommonUtils.getCurrentDate());
			try{ adjustSvc.salesPaymentConfirm(saveMap); }	//매입반제처리 
			catch(Exception e) {
				
				logger.error("buyPaymentExe Service Error : "+e); 
			}
		}
	}

	/**
	 * 이메일발송
	 */
	public void emailSendExe() {
		List<MailInfoDto> mailList = scheduleDao.selectEmailSendList();
		for(MailInfoDto mailInfoDto:mailList) {
			try {String[] toEmailAddrArray = mailInfoDto.getReceiveMailAddrs().split(";");
			String mailSubject = mailInfoDto.getMailSubject();
			String mailContents = mailInfoDto.getMailContents();
				CommonUtils.sendEmail(toEmailAddrArray, mailSubject, mailContents);
				mailInfoDto.setSendFlag("1");
				mailInfoDto.setErrMsg("");
			} catch(Exception e) {
				
				mailInfoDto.setSendFlag("9");
				mailInfoDto.setErrMsg(e.toString());
			}
			scheduleDao.updateEmailSend(mailInfoDto);
		}
	}

	/**
	 * 사전 자재대금 변제일 안내
	 */
	public void meterialPaymentDay() {
		List<Map<String,Object>> meterialPaymentDay45List = scheduleDao.selectMeterialPaymentDay45List();
		List<Map<String,Object>> meterialPaymentDay15List = scheduleDao.selectMeterialPaymentDay15List();

		String day = CommonUtils.getCurrentDate().substring(5, 7)+"월 "+CommonUtils.getCurrentDate().substring(8, 10)+"일";
		
		//사전자재대금 변제일 세금계산서기준으로 45일전의 채권 금액
		if(meterialPaymentDay45List.size() > 0){
			for(int i=0; i<meterialPaymentDay45List.size(); i++){
				String msg = "SK텔레시스 입니다. "+day+"은 "+
						meterialPaymentDay45List.get(i).get("workNm").toString()+" 공사 관련자재 구매 대금 결제일 입니다. 대금 결제금액은 "+
						meterialPaymentDay45List.get(i).get("payment").toString()+"원 입니다. (VAT 포함) 상세 내역은 Okplaza에서 확인하여 주시길 바랍니다.";
				
				commonSvc.sendSeserveSms(meterialPaymentDay45List.get(i).get("mobile").toString(), msg, CommonUtils.getCurrentDate()+ " 13:00:00","0221292045");
			}
		}
		//사전자재대금 변제일 세금계산서기준으로 15일전의 채권 금액
		if(meterialPaymentDay15List.size() > 0){
			for(int i=0; i<meterialPaymentDay15List.size(); i++){
				String msg = "SK텔레시스 입니다. "+day+"은 "+
						meterialPaymentDay15List.get(i).get("workNm").toString()+" 공사 관련자재 구매 대금 결제일 입니다. 대금 결제금액은 "+
						meterialPaymentDay15List.get(i).get("payment").toString()+"원 입니다. (VAT 포함) 상세 내역은 Okplaza에서 확인하여 주시길 바랍니다.";
				
				commonSvc.sendSeserveSms(meterialPaymentDay15List.get(i).get("mobile").toString(), msg, CommonUtils.getCurrentDate()+ " 13:00:00","0221292045");
			}
		}
	}
	
	/**
	 * 주문 제한예고 안내
	 */
	public void orderLimitNoticeGuide() {
		List<Map<String,Object>> orderLimitNoticeGuideDay61List = scheduleDao.selectOrderLimitNoticeGuideDay61List();
		List<Map<String,Object>> orderLimitNoticeGuideDay31List = scheduleDao.selectOrderLimitNoticeGuideDay31List();
		String day = CommonUtils.getCurrentDate().substring(5, 7)+"월 "+CommonUtils.getCurrentDate().substring(8, 10)+"일";
		
		//세금계산서 발행 익일부터 61째되는날
		/* 정연백 과장님 요청으로 SMS 미발송 처리 20160701 by kkbum2000 */
//		if(orderLimitNoticeGuideDay61List.size() > 0){
//			for(int i=0; i<orderLimitNoticeGuideDay61List.size(); i++){
//				String msg = "SK텔레시스 입니다. 귀사가 약속한 결제대금 "+orderLimitNoticeGuideDay61List.get(i).get("payment").toString()+
//								"원 (VAT포함)이 미 결제 되었습니다. 대금결제기일 약속 불이행시 자재주문에 제한을 받을수 있으니 적극 협조하여 주시기 바라며, "+
//								"상세 내역은 Okplaza에서 확인하여 주시길 바랍니다.";
//				commonSvc.sendSeserveSms(orderLimitNoticeGuideDay61List.get(i).get("mobile").toString(), msg, CommonUtils.getCurrentDate()+ " 13:00:00","0221292045");
//			}
//		}
//		//세금계산서 발행 익일부터 31째되는날
//		if(orderLimitNoticeGuideDay31List.size() > 0){
//			for(int i=0; i<orderLimitNoticeGuideDay31List.size(); i++){
//				String msg = "SK텔레시스 입니다. 귀사가 약속한 결제대금 "+orderLimitNoticeGuideDay31List.get(i).get("payment").toString()+
//						"원 (VAT포함)이 미 결제 되었습니다. 대금결제기일 약속 불이행시 자재주문에 제한을 받을수 있으니 적극 협조하여 주시기 바라며, "+
//						"상세 내역은 Okplaza에서 확인하여 주시길 바랍니다.";
//				commonSvc.sendSeserveSms(orderLimitNoticeGuideDay31List.get(i).get("mobile").toString(), msg, CommonUtils.getCurrentDate()+ " 13:00:00","0221292045");
//			}
//		}
	}
	
	/**
	 * 6개월 이상 주문이없는 사업장 주문제한
	 */
	public void order6MonthNothing() {
		//현재부터 6개월간 주문이 없는 사업장 아이디 조회
		List<Map<String, Object>> order6MonthNothingList = scheduleDao.selectOrder6MonthNothingList();
		if(order6MonthNothingList.size() > 0){
			for(int i=0; i<order6MonthNothingList.size(); i++){
				Map<String, Object> saveMap = new HashMap<String, Object>();
				saveMap.put("branchId", order6MonthNothingList.get(i).get("branchId"));
				scheduleDao.branchOrderLimit(saveMap);//6개월간 주문이없는 사업장 주문제한
			}
		}
	}
	
	/**
	 * 지정자재 업체선정 평가상태 변경처리
	 */
	public void evaluation() {
		scheduleDao.evaluation();
	}

	
	public List<BuyProductDto> getBuyProductSearchList() {
		return (List<BuyProductDto>) productDao.selectBuyProductSearchList();
	}

	/**
	 * 운영사 메인정보 Setting
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void setAdmMainInfoSetup() {
		//매출현황 세팅
		ModelMap paramMap = new ModelMap();
		int existCnt = 0;
		try {
			paramMap.put("info_type", "1");
			existCnt =generalDao.selectGernalCount("common.schedule.selectMainInfoTypeCnt", paramMap);
			if(existCnt>0) generalDao.updateGernal("common.schedule.updateMainSellInfo", null);
			else generalDao.insertGernal("common.schedule.insertMainSellInfo", null);
		} catch(Exception e) {
			logger.error("========================Admin Main SellInfo Setting Error========================");
			logger.error(e);
		}
		
		//채권현황1 세팅
		try {
			paramMap.clear();
			paramMap.put("info_type", "2");
			existCnt =generalDao.selectGernalCount("common.schedule.selectMainInfoTypeCnt", paramMap);
			if(existCnt>0) generalDao.updateGernal("common.schedule.updateMainSaleInfo1", null);
			else generalDao.insertGernal("common.schedule.insertMainSaleInfo1", null);
		} catch(Exception e) {
			logger.error("========================Admin Main SaleInfo1 Setting Error========================");
			logger.error(e);
		}
		
		//채권현황2 세팅
		try {
			paramMap.clear();
			paramMap.put("info_type", "3");
			existCnt =generalDao.selectGernalCount("common.schedule.selectMainInfoTypeCnt", paramMap);
			if(existCnt>0) generalDao.updateGernal("common.schedule.updateMainSaleInfo2", null);
			else generalDao.insertGernal("common.schedule.insertMainSaleInfo2", null);
		} catch(Exception e) {
			logger.error("========================Admin Main SaleInfo2 Setting Error========================");
			logger.error(e);
		}
		
		//고객사현황 세팅
		try {
			paramMap.clear();
			paramMap.put("info_type", "4");
			existCnt =generalDao.selectGernalCount("common.schedule.selectMainInfoTypeCnt", paramMap);
			if(existCnt>0) generalDao.updateGernal("common.schedule.updateMainBorgInfo", null);
			else generalDao.insertGernal("common.schedule.insertMainBorgInfo", null);
		} catch(Exception e) {
			logger.error("========================Admin Main BorgInfo Setting Error========================");
			logger.error(e);
		}
		
		//상품현황 세팅
		try {
			paramMap.clear();
			paramMap.put("info_type", "5");
			existCnt =generalDao.selectGernalCount("common.schedule.selectMainInfoTypeCnt", paramMap);
			if(existCnt>0) generalDao.updateGernal("common.schedule.updateMainProductInfo", null);
			else generalDao.insertGernal("common.schedule.insertMainProductInfo", null);
		} catch(Exception e) {
			logger.error("========================Admin Main ProductInfo Setting Error========================");
			logger.error(e);
		}
	}

	/** 장바구니에 담긴 종료 상품 삭제 */
	public void delCartClosedPdt() {
		// 종료상품 검색
		List<Map<String, Object>> delTargetList = scheduleDao.selectCartClosedPdt();
		// 장바구니에서 삭제
		if(delTargetList.size() > 0){
			Map<String, Object> tmpMap = new HashMap<String, Object>();
            tmpMap.put("delTargetList" , delTargetList);
			scheduleDao.delCartClosedPdt(tmpMap);
		}
	}
	
	@SuppressWarnings("unchecked")
	public void deliScheDateMms() throws Exception{
		List<Object> list = this.generalDao.selectGernalList("common.schedule.selectDeliScheDateSmsList", new ModelMap()); // 문자 발송 대상 조회
		for(int i = 0; i < list.size(); i++){
			Map<String, Object> deliMap = (Map<String, Object>) list.get(i);
			String msg = "";
			/* 정연백 과장님 요청으로 SMS 내용변경 20160701 by kkbum2000 */
			if( (int)deliMap.get("CNT") >1 ) {
				msg = "[Okplaza] ["+deliMap.get("GOOD_NAME")+"]외 "+((int)deliMap.get("CNT")-1)+"건은 납기예정일이 경과되었습니다. 배송처리 요청드립니다.";
			} else {
				msg = "[Okplaza] ["+deliMap.get("GOOD_NAME")+"]은(는) 납기예정일이 경과되었습니다. 배송처리 요청드립니다.";
			}
			commonSvc.sendSeserveSms(deliMap.get("MOBILE").toString(), msg, CommonUtils.getCurrentDate()+ " 09:10:00");
		}
	}
	
	/**
	 * 공급사 공급현황 데이터를 조회하여 등록하는 메소드
	 * 
	 * @param list
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void venDefaultDataCreateTypeOne(List<Object> vendorList) throws Exception{
		String              vendorId       = null;
		String              supply01       = null;
		String              supply02       = null;
		String              supply03       = null;
		String              supply04       = null;
		String              supply11       = null;
		String              supply12       = null;
		String              supply13       = null;
		String              supply14       = null;
		ModelMap            daoParam       = new ModelMap();
		Map<String, String> typeOneInfo    = null;
		int                 i              = 0;
		int                 vendorListSize = 0;
		
		if(vendorList != null){
			vendorListSize = vendorList.size();
		}
		
		for(i = 0; i < vendorListSize; i++){
			vendorId = (String)vendorList.get(i);
			
			daoParam.clear();
			daoParam.put("borgId", vendorId);
			
			typeOneInfo = (Map<String, String>)this.generalDao.selectGernalObject("common.schedule.selectVenDefaultDataCreateType1", daoParam); // 공급사 공급현황 조회
			
			if(typeOneInfo != null){
				supply01 = typeOneInfo.get("supply01");
				supply02 = typeOneInfo.get("supply02");
				supply03 = typeOneInfo.get("supply03");
				supply04 = typeOneInfo.get("supply04");
				supply11 = typeOneInfo.get("supply11");
				supply12 = typeOneInfo.get("supply12");
				supply13 = typeOneInfo.get("supply13");
				supply14 = typeOneInfo.get("supply14");
				
				daoParam.clear();
				daoParam.put("vendorId", vendorId);
				daoParam.put("infoType", "1");
				daoParam.put("info01",   supply01);
				daoParam.put("info02",   supply02);
				daoParam.put("info03",   supply03);
				daoParam.put("info04",   supply04);
				daoParam.put("info05",   supply11);
				daoParam.put("info06",   supply12);
				daoParam.put("info07",   supply13);
				daoParam.put("info08",   supply14);
				
				this.generalDao.insertGernal("common.schedule.insertSmpVenMainInfo", daoParam); // 배치 데이터 등록
			}
		}
	}
	
	/**
	 * 상품현황 특정 키에 해당하는 값을 문자열로 리턴하는 메소드
	 * 
	 * @param goodType
	 * @param key
	 * @return int
	 * @throws Exception
	 */
	private String venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(Map<String, String> goodType, String key) throws Exception{
		String value  = null;
		String result = null;
		
		if(goodType != null){
			value  = goodType.get(key);
			result = CommonUtils.nvl(value, "0");
		}
		else{
			result = "0";
		}
		
		return result;
	}
	
	/**
	 * 상품현황 특정 키에 해당하는 값을 정수로 리턴하는 메소드
	 * 
	 * @param goodType
	 * @param key
	 * @return int
	 * @throws Exception
	 */
	private int venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(Map<String, String> goodType, String key) throws Exception{
		String value  = null;
		int    result = 0;
		
		if(goodType != null){
			value  = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodType, key);
			result = Integer.parseInt(value);
		}
		
		return result;
	}
	
	/**
	 * 특정 공급사의 상품현황 총계를 반환하는 메소드
	 * 
	 * @param goodType10
	 * @param goodType20
	 * @return
	 * @throws Exception
	 */
	private Map<String, String> venDefaultDataCreateTypeTwoGoodTypeTotal(Map<String, String> goodType10, Map<String, String> goodType20) throws Exception{
		Map<String, String> result                = new HashMap<String, String>();
		int                 goodType10SumIsRegInt = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType10, "sumIsReg"); // 키에 해당하는 값을 정수로 리턴
		int                 goodType10SumIsModInt = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType10, "sumIsMod");
		int                 goodType10SumIsUseInt = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType10, "sumIsUse");
		int                 goodType10TotSumInt   = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType10, "totSum");
		int                 goodType10SumCntInt   = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType10, "cnt");
		int                 goodType20SumIsRegInt = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType20, "sumIsReg");
		int                 goodType20SumIsModInt = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType20, "sumIsMod");
		int                 goodType20SumIsUseInt = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType20, "sumIsUse");
		int                 goodType20TotSumInt   = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType20, "totSum");
		int                 goodType20SumCntInt   = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyInt(goodType20, "cnt");
		int                 resultSumIsRegInt     = goodType10SumIsRegInt + goodType20SumIsRegInt;
		int                 resultSumIsModInt     = goodType10SumIsModInt + goodType20SumIsModInt;
		int                 resultSumIsUseInt     = goodType10SumIsUseInt + goodType20SumIsUseInt;
		int                 resultTotSumInt       = goodType10TotSumInt + goodType20TotSumInt;
		int                 resultSumCntInt       = goodType10SumCntInt + goodType20SumCntInt;
		String              resultSumIsReg        = Integer.toString(resultSumIsRegInt);
		String              resultSumIsMod        = Integer.toString(resultSumIsModInt);
		String              resultSumIsUse        = Integer.toString(resultSumIsUseInt);
		String              resultTotSum          = Integer.toString(resultTotSumInt);
		String              resultSumCnt          = Integer.toString(resultSumCntInt);
		
		result.put("goodClasCode", "tot");
		result.put("sumIsReg",     resultSumIsReg);
		result.put("sumIsMod",     resultSumIsMod);
		result.put("sumIsUse",     resultSumIsUse);
		result.put("totSum",       resultTotSum);
		result.put("cnt",          resultSumCnt);
		
		return result;
	}
	
	/**
	 * 상품현황 정보 등록
	 * 
	 * @param param
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void venDefaultDataCreateTypeTwoInsert(Map<String, Object> param) throws Exception{
		ModelMap            daoParam      = new ModelMap();
		Map<String, String> goodType10    = (Map<String, String>)param.get("goodType10");
		Map<String, String> goddType20    = (Map<String, String>)param.get("goddType20");
		Map<String, String> goodTypeTotal = (Map<String, String>)param.get("goodTypeTotal");
		String              vendorId      = (String)param.get("vendorId");
		String              info01        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodType10,    "sumIsReg"); // 키에 해당하는 값을 문자열로 리턴
		String              info02        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodType10,    "sumIsMod");
		String              info03        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodType10,    "sumIsUse");
		String              info04        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodType10,    "totSum");
		String              info05        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodType10,    "cnt");
		String              info06        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goddType20,    "sumIsReg");
		String              info07        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goddType20,    "sumIsMod");
		String              info08        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goddType20,    "sumIsUse");
		String              info09        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goddType20,    "totSum");
		String              info10        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goddType20,    "cnt");
		String              info11        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodTypeTotal, "sumIsReg");
		String              info12        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodTypeTotal, "sumIsMod");
		String              info13        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodTypeTotal, "sumIsUse");
		String              info14        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodTypeTotal, "totSum");
		String              info15        = this.venDefaultDataCreateTypeTwoGoodTypeTotalKeyString(goodTypeTotal, "cnt");
		
		daoParam.put("vendorId", vendorId);
		daoParam.put("infoType", "2");
		daoParam.put("info01",   info01);
		daoParam.put("info02",   info02);
		daoParam.put("info03",   info03);
		daoParam.put("info04",   info04);
		daoParam.put("info05",   info05);
		daoParam.put("info06",   info06);
		daoParam.put("info07",   info07);
		daoParam.put("info08",   info08);
		daoParam.put("info09",   info09);
		daoParam.put("info10",   info10);
		daoParam.put("info11",   info11);
		daoParam.put("info12",   info12);
		daoParam.put("info13",   info13);
		daoParam.put("info14",   info14);
		daoParam.put("info15",   info15);
		
		this.generalDao.insertGernal("common.schedule.insertSmpVenMainInfo", daoParam); // 배치 데이터 등록
	}
	
	/**
	 * 공급사 상품현황 데이터를 조회하여 등록하는 메소드
	 * 
	 * @param vendorList
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void venDefaultDataCreateTypeTwo(List<Object> vendorList) throws Exception{
		String              vendorId        = null;
		String              goodClasCode    = null;
		ModelMap            daoParam        = new ModelMap();
		Map<String, String> goodType10      = null;
		Map<String, String> goddType20      = null;
		Map<String, String> goodTypeTotal   = null;
		Map<String, String> typeTwoInfo     = null;
		Map<String, Object> insertParam     = new HashMap<String, Object>();
		List<Object>        typeTwoList     = null;
		int                 i               = 0;
		int                 j               = 0;
		int                 vendorListSize  = 0;
		int                 typeTwoListSize = 0;
		
		if(vendorList != null){
			vendorListSize = vendorList.size();
		}
		
		for(i = 0; i < vendorListSize; i++){
			vendorId = (String)vendorList.get(i);
			
			daoParam.clear();
			daoParam.put("vendorId", vendorId);
			
			typeTwoList = this.generalDao.selectGernalList("common.schedule.selectVenDefaultDataCreateType2", daoParam); // 공급사 상품 현황 리스트 조회
			
			if(typeTwoList != null){
				typeTwoListSize = typeTwoList.size();
			}
			
			goodType10 = null;
			goddType20 = null;
			
			for(j = 0; j < typeTwoListSize; j++){
				typeTwoInfo  = (Map<String, String>)typeTwoList.get(j);
				goodClasCode = typeTwoInfo.get("goodClasCode");
				
				if("10".equals(goodClasCode)){
					goodType10 = typeTwoInfo;
				}
				else{
					goddType20 = typeTwoInfo;
				}
			}
			
			goodTypeTotal = this.venDefaultDataCreateTypeTwoGoodTypeTotal(goodType10, goddType20); // 총계정보 조회
			
			insertParam.clear();
			insertParam.put("goodType10",    goodType10);
			insertParam.put("goddType20",    goddType20);
			insertParam.put("goodTypeTotal", goodTypeTotal);
			insertParam.put("vendorId",      vendorId);
			
			this.venDefaultDataCreateTypeTwoInsert(insertParam); // 정보등록
		}
	}
	
	/**
	 * 공급사 메인 페이지 현황 배치를 처리하는 메소드
	 * 
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void venDefaultDataCreate() throws Exception{
		List<Object> vendorList = (List<Object>)this.generalDao.selectGernalList("common.schedule.selectVenDefaultDataCreateList", new ModelMap()); // 공급사 리스트 조회
		
		this.venDefaultDataCreateTypeOne(vendorList); // 공급사 공급현황 데이터를 등록
		this.venDefaultDataCreateTypeTwo(vendorList); // 공급사 상품현황 데이터를 등록
	}
}