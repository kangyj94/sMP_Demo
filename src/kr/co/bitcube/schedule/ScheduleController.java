package kr.co.bitcube.schedule;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.product.dto.BuyProductDto;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("schedule")
public class ScheduleController {

	public static List<BuyProductDto> autoCompList = null;
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Autowired
	private ScheduleSvc scheduleSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired private GeneralDao generalDao;

	//인수확인 : 0시 10분
	@Scheduled(cron="0 10 0 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("orderStockExe.sys")
	public void orderStockExe() {
		logger.info("--------------------------orderStockExe start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try { scheduleSvc.autoOrderReceiveProcess();} 
			catch(Exception e) { logger.error("orderStockExe Exception : "+e); }
		}
		logger.info("--------------------------orderStockExe end!--------------------------");
	}
	
	//SMS(인수확인독려) : 00시 35분
	@Scheduled(cron="0 35 0 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("orderStockSms.sys")
	public void orderStockSms() {
		logger.info("--------------------------orderStockSms start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try { scheduleSvc.noticeToOrderUserOforderStock(); } 
			catch(Exception e) { logger.error("orderStockSms Exception : "+e); }
		}
		logger.info("--------------------------orderStockSms end!--------------------------");
	}
	
	//장기미수채권/장기미지급채무 : 0시 50분, 채권/채무총액이 반제금액보다 크면 경과월과 초과일을 update 함
	@Scheduled(cron="0 50 0 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("notReceiveBondExe.sys")
	public void notReceiveBondExe() {
		logger.info("--------------------------notReceiveBondExe start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try { scheduleSvc.autoNotReceiveBondExe(); }	//장기미수채권/장기미지급채무 처리  
			catch(Exception e) { logger.error("notReceiveBondExe autoNotReceiveBondExe Exception : "+e); }
			try { scheduleSvc.autoBondOverMonthDayExe(); }	//채권/채무 경과월, 초과월 변경
			catch(Exception e) { logger.error("notReceiveBondExe autoBondOverMonthDayExe Exception : "+e); }
		}
		logger.info("--------------------------notReceiveBondExe end!--------------------------");
	}
	
	//전월매출확인 : 법인별 1일에서 현재일까지의 주문금액(첨만원이 넘흘경우)의 합이 전월실적의 20%을 넘기면 담당자에게 SMS발송
	//사용안함
//	@Scheduled(cron="0 20 23 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("sendToManagerOfOverOrder.sys")
	public void sendToManagerOfOverOrder() {
		logger.info("--------------------------sendToManagerOfOverOrder start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try { scheduleSvc.sendToManagerOfOverOrder(); } 
			catch(Exception e) { logger.error("sendToManagerOfOverOrder Exception : "+e); }
		}
		logger.info("--------------------------sendToManagerOfOverOrder end!--------------------------");
	}
	
	//인기상품 : 23시 57분
	@Scheduled(cron="0 57 23 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("popularProductExe.sys")
	public void popularProductExe() {
		logger.info("--------------------------popularProductExe start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try { scheduleSvc.popularProductExe(); } 
			catch(Exception e) { logger.error("popularProductExe Exception : "+e); }
		}
		logger.info("--------------------------popularProductExe end!--------------------------");
	}
	
	//입찰종료 : 매시 0분,1분,2분 10초
	@Scheduled(cron="10 0,1,2 * * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("bidEndExe.sys")
	public void bidEndExe() {
		logger.info("--------------------------bidEndExe start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
//		if( true ) {
			try { scheduleSvc.bidEndExe(); } 
			catch(Exception e) { logger.error("bidEndExe Exception : "+e); }
		}
		logger.info("--------------------------bidEndExe end!--------------------------");
	}
	
	//매출반제처리 : 매시 30분
	@Scheduled(cron="0 30 8,12,16,21 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("salePaymentExe.sys")
	public void salePaymentExe() {
		logger.info("--------------------------salePaymentExe start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try { scheduleSvc.salePaymentExe(); } 
			catch(Exception e) { logger.error("salePaymentExe Exception : "+e); }
		}
		logger.info("--------------------------salePaymentExe end!--------------------------");
	}
	
	//매입반제처리 : 매시 40분
	@Scheduled(cron="0 40 8,12,16,21 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("buyPaymentExe.sys")
	public void buyPaymentExe() {
		logger.info("--------------------------buyPaymentExe start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try { scheduleSvc.buyPaymentExe(); } 
			catch(Exception e) { logger.error("buyPaymentExe Exception : "+e); }
		}
		logger.info("--------------------------buyPaymentExe end!--------------------------");
	}
	
	//이메일발송 5분마다
	@Scheduled(cron="0 3,8,13,18,23,28,33,38,43,48,53,58 * * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("emailSendExe.sys")
	public void emailSendExe() {
		logger.info("--------------------------emailSendExe start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try { scheduleSvc.emailSendExe(); } 
			catch(Exception e) { logger.error("emailSendExe Exception : "+e); }
		}
		logger.info("--------------------------emailSendExe end!--------------------------");
	}
	
	/*------------------------------------채팅관련서비스 시작-----------------------------------------*/
	//채팅로그아웃 처리 매 15초마다, 로그아웃된사용자의 체팅정보는 로그테이블로 이동
	@Scheduled(cron="1,16,31,46 * * * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("chatLogout.sys")
	public void chatLogout() {
		if(Constances.CHAT_ISUSE) {
			if(Constances.COMMON_ISREAL_SERVER) {
				try { commonSvc.chatLogout(); } 
				catch(Exception e) { logger.error("chatLogout Exception : "+e); }
			}
		}
	}
	
	//채팅로그인정보,채팅메시지 매일 5시 초기화
	@Scheduled(cron="0 0 5 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("initChatLogin.sys")
	public void initChatLogin() {
		if(Constances.CHAT_ISUSE) {
			logger.info("--------------------------initChatLogin start!--------------------------");
			if(Constances.COMMON_ISREAL_SERVER) {
				try { commonSvc.initChatLogin(); }
				catch(Exception e) { logger.error("initChatLogin Exception : "+e); }
			}
			logger.info("--------------------------initChatLogin start!--------------------------");
		}
	}
	
	//채팅로그인정보 매월 1일 채팅로그 테이블 생성
	@Scheduled(cron="1 0 0 1 * *")	//초 분 시 일 월 주(년)
	@RequestMapping("createChatLog.sys")
	public void createChatLog() {
		if(Constances.CHAT_ISUSE) {
			logger.info("--------------------------createChatLog start!--------------------------");
			if(Constances.COMMON_ISREAL_SERVER) {
				try { commonSvc.createChatLog(); }
				catch(Exception e) { logger.error("createChatLog Exception : "+e); }
			}
			logger.info("--------------------------createChatLog start!--------------------------");
		}
	}
	
	//사전 자재대금 변제일안내(추후올리기로함)
	//SMS(사전 자재대금 변제일안내) : 01시 30분
//	@Scheduled(cron="0 30 1 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("meterialPaymentDay.sys")
	public void meterialPaymentDay(){
		logger.info("--------------------------meterialPaymentDay start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try{ scheduleSvc.meterialPaymentDay(); }
			catch(Exception e) { logger.error("meterialPaymentDay Exception : "+e); }
		}
		logger.info("--------------------------meterialPaymentDay end!--------------------------");
	}
	
	//주문 제한 예고 안내(추후올리기로함)
	//SMS(주문 제한 예고 안내) : 01시 40분
//	@Scheduled(cron="0 40 1 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("orderLimitNoticeGuide.sys")
	public void orderLimitNoticeGuide(){
		logger.info("--------------------------orderLimitNoticeGuide start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try{ scheduleSvc.orderLimitNoticeGuide(); }
			catch(Exception e) { logger.error("orderLimitNoticeGuide Exception : "+e); }
		}
		logger.info("--------------------------orderLimitNoticeGuide end!--------------------------");
	}	
	
	
	//6개월간 주문을 하지 않을시 주문제한(매일 1시 50분)
//	@Scheduled(cron="0 50 1 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("order6MonthNothing.sys")
	public void order6MonthNothing(){
		logger.info("--------------------------order6MonthNothing start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try{ scheduleSvc.order6MonthNothing(); }
			catch(Exception e) { logger.error("order6MonthNothing Exception : "+e); }
		}
		logger.info("--------------------------order6MonthNothing end!--------------------------");
	}
	
	
	// 지정자재 업체선정 평가상태 변경처리(매일 0시 0분 1초)
	@Scheduled(cron="1 0 0 * * *")	//초 분 시 일 월 주(년) 
	@RequestMapping("evaluation.sys")
	public void evaluation(){
		logger.info("--------------------------evaluation start!--------------------------");
		if(Constances.COMMON_ISREAL_SERVER) {
			try{ scheduleSvc.evaluation(); }
			catch(Exception e) { logger.error("evaluation Exception : "+e); }
		}
		logger.info("--------------------------evaluation end!--------------------------");
	}
	
	
	//상품검색 input박스 자동완성기능
	@Scheduled(cron="0 1 0 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("pdtAutoComplete.sys")
	public void pdtAutoComplete() {
		logger.info("--------------------------pdtAutoComplete start!--------------------------");
		try { 
			autoCompList = scheduleSvc.getBuyProductSearchList(); 
		} catch(Exception e) { logger.error("pdtAutoComplete Exception : "+e); }
		logger.info("--------------------------pdtAutoComplete end!--------------------------");
	}

	//운영사 메인스케줄
	@Scheduled(cron="0 45 0 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("admMainInfoSetup.sys")
	public void admMainInfoSetup() {
		logger.info("--------------------------admMainInfoSetup start!--------------------------");
		try {
			scheduleSvc.setAdmMainInfoSetup();
		} catch(Exception e) { logger.error("admMainInfoSetup Exception : "+e); }
		logger.info("--------------------------admMainInfoSetup end!--------------------------");
	}
	
	//매시 00분 00초 마다 종료된 상품이 장바구니에 존재시 삭제. 추가상품관련일 경우 같이 삭제.
	@Scheduled(cron="0 30 12,23 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("delCartClosedPdt.sys")
	public void delCartClosedPdt() {
		logger.info("--------------------------delCartClosedPdt start!--------------------------");
		try {
			scheduleSvc.delCartClosedPdt();
		} catch(Exception e) { logger.error("delCartClosedPdt Exception : "+e); }
		logger.info("--------------------------delCartClosedPdt end!--------------------------");
	}
	
	//매일 오전 0시 25분 납품예정일 지난 공급사에 배송안내 문자 발송
	@Scheduled(cron="0 25 0 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("deliScheDateMms.sys")
	public void deliScheDateMms() {
		logger.info("--------------------------deliScheDateMms start!--------------------------");
		try {
			this.scheduleSvc.deliScheDateMms();
		} catch(Exception e){ this.logger.error("deliScheDateMms Exception : " + e); }
		logger.info("--------------------------deliScheDateMms end!--------------------------");
	}
	
	
	@RequestMapping("goodDescInsert.sys")
	public void goodDescInsert() {
//		List<Object> listMap = generalDao.selectGernalList("common.schedule.selectGoodDescInsert",null);
//		for(Object obj : listMap) {
//			@SuppressWarnings("unchecked")
//			Map<String,Object> objMap = (Map<String, Object>) obj;
//			String good_desc = (String) objMap.get("GOOD_DESC");
//			
//			System.out.println("===========================================================");
//			System.out.println(objMap);
//			
//			ModelMap paramMap = new ModelMap();
//			paramMap.put("GOOD_IDEN_NUMB", objMap.get("GOOD_IDEN_NUMB"));
//			paramMap.put("VENDORID", objMap.get("VENDORID"));
//			paramMap.put("GOOD_DESC", CommonUtils.unescape(good_desc));
//			generalDao.updateGernal("common.schedule.updateGoodDescInsert", paramMap);
			
//			String util = CommonUtils.unescape(good_desc);
//			System.out.println("===========================================================");
//			System.out.println("jameskang good_desc : "+good_desc);
//			System.out.println("-------------------------------------------------------------");
//			System.out.println("jameskang util : "+util);
//			System.out.println("-------------------------------------------------------------");
//		}
	}
	
	//매일 오전 03시 0분 공급사 메인 페이지 통계 데이터 생성
	@Scheduled(cron="0 10 3 * * *")	//초 분 시 일 월 주(년)
	@RequestMapping("venDefaultDataCreate.sys")
	public void venDefaultDataCreate() {
		logger.info("--------------------------venDefaultDataCreate start!--------------------------");
		try {
			if(Constances.COMMON_ISREAL_SERVER) {
				this.scheduleSvc.venDefaultDataCreate();
			}
		} catch(Exception e){ this.logger.error(CommonUtils.getExceptionStackTrace(e)); }
		logger.info("--------------------------venDefaultDataCreate end!--------------------------");
	}
	
	//매년 1월1일 품질관리 대상 데이터 이관
//	@Scheduled(cron="1 0 0 1 1 *")	//초 분 시 일 월 주(년)
//	@RequestMapping("saveTransferData.sys")
//	public void saveTransferData() {
//		logger.info("--------------------------saveTransferData start!--------------------------");
//		try {
//			if(Constances.COMMON_ISREAL_SERVER) {
//				this.scheduleSvc.saveTransferData();
//			}
//		} catch(Exception e){ this.logger.error(CommonUtils.getExceptionStackTrace(e)); }
//		logger.info("--------------------------saveTransferData end!--------------------------");
//	}
}
