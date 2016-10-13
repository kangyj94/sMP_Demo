package kr.co.bitcube.order.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.order.dao.DeliveryDao;
import kr.co.bitcube.order.dao.ReturnOrderDao;
import kr.co.bitcube.order.dto.OrderDeliDto;
import kr.co.bitcube.order.dto.OrderReturnDto;
import kr.co.bitcube.order.dto.ParticularsTargetBranchsDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.cmmn.exception.FdlException;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class ReturnOrderSvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private ReturnOrderDao returnOrderDao;
	
	@Autowired
	private DeliveryDao deliveryDao;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired private GeneralDao generalDao;
	
	@Resource(name="seqMpOrderReturnService")
	private EgovIdGnrService seqMpOrderReturnService;

	/** * 인수내역/반품요청 리스트의 대상 데이터 갯수 리턴 */
	public int getReturnOrderRegistListCnt(Map<String, Object> params) {
		return (Integer) returnOrderDao.selectReturnOrderRegistListCnt(params);
	}
	/** * 인수내역/반품요청 리스트의 대상 데이터 리턴 */
	public List<OrderDeliDto> getReturnOrderRegistList(Map<String, Object> params, int page, int rows) {
		return (List<OrderDeliDto>)returnOrderDao.selectReturnOrderRegistList(params, page, rows);
	}
	
	/** * 반품요청내역 조회 리스트의 대상 데이터 갯수 리턴 */
	public int getReturnOrderListCnt(Map<String, Object> params) {
		return (Integer) returnOrderDao.selectReturnOrderListCnt(params);
	}
	/** * 반품요청내역 조회 리스트의 대상 데이터 리턴 */
	public List<OrderReturnDto> getReturnOrderList(Map<String, Object> params, int page, int rows) {
		return (List<OrderReturnDto>)returnOrderDao.selectReturnOrderList(params, page, rows);
	}
	
	/** * 반품요청내역 상세 정보를 조회한다. */
	public OrderReturnDto getReturnOrderRegistDetailInfo(Map<String, Object> searchMap) {
		return returnOrderDao.selectReturnOrderRegistDetail(searchMap);
	}
	
	/** * 반품내역을 저장한다. */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void returnOrderProcess(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception {
		String[] temp_orde_iden_numb = saveMap.get("orde_iden_numb").toString().split("-");
		saveMap.remove("orde_iden_numb");
		saveMap.put("retu_iden_num", seqMpOrderReturnService.getNextStringId());
		saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
		saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		saveMap.put("retu_regi_id", userInfoDto.getUserId());
		// 반품 테이블에 insert
		returnOrderDao.insertMrarem(saveMap);
		// 히스토리 insert  ---------- 반품 요청은 주문 상태와 상관이 없는 부분이 있기때문에  히스토리 남기지 않게 수정 : 12-12-20 parkjoon
//		orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), null, "77", (String)saveMap.get("chan_reas_desc"), (String)saveMap.get("retu_regi_id"));
		
		//반품요청시 SMS발송
		List<Map<String, Object>> returnOrderInfoList = returnOrderDao.selectReturnOrderVendorList(saveMap);
		String returnOrderMsg = "";
		returnOrderMsg += "주문번호 "+saveMap.get("orde_iden_numb")+"-"+saveMap.get("orde_sequ_numb")+"의 반품요청이 왔습니다.";
		for(int i=0; i<returnOrderInfoList.size(); i++){
			commonSvc.sendRightSms(returnOrderInfoList.get(i).get("vendorMobile").toString(), returnOrderMsg);
		}
		
	}
	public int getVenReturnOrderListCnt(Map<String, Object> params) {
		return (Integer) returnOrderDao.selectVenReturnOrderListCnt(params);
	}
	public List<OrderReturnDto> getVenReturnOrderList( Map<String, Object> params, int page, int rows) {
		return (List<OrderReturnDto>)returnOrderDao.selectVenReturnOrderList(params, page, rows);
	}
	
	/**
	 * 승인처리<br><br><b>
		 1. 반품 정보의 반품처리 상태를 승인(1)으로 변경 , 공급사 처리자 Id, 공급사 처리일자 update<br>
		 2. 주문상품출하 테이블에 반품 정보를 기반으로 (-) 마이너스 수량을 Insert <br>(상위출하차수에 반품요청있었던 인수데이터의 출하차수를 넣는다.)<br>
		 3. 인수내역 테이블에 해당 마이너스 수량 정보를 기반으로 Insert<br>
		 4. 히스토리를 저장한다. </b>
	 * @throws FdlException 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void venOrderReturnApproval(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");	
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");	
		String[] deli_iden_numb_array= (String[]) saveMap.get("deli_iden_numb_array");		
		String[] return_iden_numb_array= (String[]) saveMap.get("return_iden_numb_array");
		String[] retu_prod_quan_array= (String[]) saveMap.get("retu_prod_quan_array");
		int cnt= 0;
		for(String orde_iden_numb_temp:orde_iden_numb_array){
			
			/*-----------------반품 중복처리 체크 Start--------------------*/
			Map<String,Object> paramMap = new HashMap<String,Object>();
			paramMap.put("retu_iden_num", return_iden_numb_array[cnt]);
			if(generalDao.selectGernalCount("order.returnOrder.selectReturnOrderRequestCnt", paramMap)>0) {
				throw new Exception("이미 처리된 반품이 존재합니다.");
			}
			/*-------------------------------------------------------------*/
			
			saveMap.put("retu_iden_num",return_iden_numb_array[cnt]); // 반품번호
			saveMap.put("retu_stat_flag","1"); // 승인상태
			saveMap.put("vend_proc_id", attribute.getUserId()); // 공급사처리자ID
			saveMap.put("retu_getdate", "Yes"); // getdate를 넣기위한 임시방편
			returnOrderDao.updateMrarem(saveMap); // 수정하기
			
			String[] temp_orde_iden_numb = orde_iden_numb_temp.split("-");
			saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]); // 주문번호
			saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);// 주문차수
			saveMap.put("purc_iden_numb",purc_iden_numb_array[cnt]);//발주차수
			saveMap.put("deli_iden_numb",deli_iden_numb_array[cnt]);// 출하차수
			saveMap.put("retu_prod_quan", -Integer.parseInt(retu_prod_quan_array[cnt]));//반품요청수량
			int deli_iden_numb  = deliveryDao.selectDeliIdenNumb(saveMap);  // 출하차수 조회
			saveMap.put("deli_iden_numb_new", ""+deli_iden_numb); // 출하차수
			saveMap.put("deli_stat_flag","80");//반품완료
			returnOrderDao.insertMracptForOrderReturn(saveMap); // 출하테이블에 반품정보 Insert 하기  
			
			int rece_iden_numb  = deliveryDao.selectReceIdenNumb(saveMap);  // 인수차수 조회
			saveMap.remove("deli_iden_numb");
			saveMap.put("deli_iden_numb", saveMap.get("deli_iden_numb_new"));	// 위에서 새로 저장된 출하정보의 출하차수 세팅
			saveMap.put("rece_iden_numb", ""+rece_iden_numb);	// 인수차수 세팅
			deliveryDao.insertMrordtList(saveMap);						// 인수내역 테이블에 저장
			  
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), 
					(String)saveMap.get("rece_iden_numb"), (String)saveMap.get("deli_stat_flag"), null, attribute.getUserId());
			
			//반품승인시 주문자에게 문자발송
			Map<String, Object> returnOrderSmsInfo = returnOrderDao.selectReturnOrderSmsInfo(saveMap);
			String smsMsg = "";
			smsMsg += "주문번호 ["+saveMap.get("orde_iden_numb")+"-"+saveMap.get("orde_sequ_numb")+"] 의 반품요청이 승인 되었습니다.";
			commonSvc.sendRightSms(returnOrderSmsInfo.get("ordeTeleNumb").toString(), smsMsg, returnOrderSmsInfo.get("phoneNum").toString());
			//반품승인시 주문자에게 문자발송
			
            // 주문상품의 재고수량관리 여부에 따라 재고수량 처리
            orderCommonSvc.stockManage("PLUS",temp_orde_iden_numb[0], temp_orde_iden_numb[1], purc_iden_numb_array[cnt], attribute.getUserId(), Integer.parseInt(retu_prod_quan_array[cnt]));
			cnt++;
		}
	}
	/**
	 * 반려처리<br><b>
		 1. 반품요청 데이터의 반품처리 상태를 반려로 변경 , <br>공급사 거부사유를 넣는다 , 공급사처리자 Id, 공급사 처리일자를 넣는다.</b>
	 * @throws Exception 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void venOrderReturnRejectTransGrid(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		String[] return_iden_numb_array= (String[]) saveMap.get("return_iden_numb_array");
		for(String return_iden_num:return_iden_numb_array){
			
			/*-----------------반품 중복처리 체크 Start--------------------*/
			Map<String,Object> paramMap = new HashMap<String,Object>();
			paramMap.put("retu_iden_num", return_iden_num);
			if(generalDao.selectGernalCount("order.returnOrder.selectReturnOrderRequestCnt", paramMap)>0) {
				throw new Exception("이미 처리된 반품이 존재합니다.");
			}
			/*-------------------------------------------------------------*/
			
			saveMap.put("retu_iden_num",return_iden_num); // 반품번호
			saveMap.put("retu_stat_flag","9"); // 반려상태
			saveMap.put("retu_getdate", "Yes"); // getdate를 넣기위한 임시방편
			saveMap.put("vend_proc_id", attribute.getUserId()); // 공급사처리자ID
			returnOrderDao.updateMrarem(saveMap); // 수정하기
		}
		
		//반품거부시 SMS전송
		String[] orde_iden_numb_array = (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array = (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array = (String[]) saveMap.get("deli_iden_numb_array");
		for(int i=0; i<orde_iden_numb_array.length; i++){
			String[] orde_iden_numb = orde_iden_numb_array[i].split("-");
			saveMap.put("orde_iden_numb", orde_iden_numb[0]);
			saveMap.put("orde_sequ_numb", orde_iden_numb[1]);
			saveMap.put("purc_iden_numb", purc_iden_numb_array[i]);
			saveMap.put("deli_iden_numb", deli_iden_numb_array[i]);
			Map<String, Object> returnOrderSmsInfo = returnOrderDao.selectReturnOrderSmsInfo(saveMap);
			String smsMsg = "";
			smsMsg += "주문번호 ["+saveMap.get("orde_iden_numb")+"-"+saveMap.get("orde_sequ_numb")+"] 의 반품요청이 거부 되었습니다.";
			commonSvc.sendRightSms(returnOrderSmsInfo.get("ordeTeleNumb").toString(), smsMsg, returnOrderSmsInfo.get("phoneNum").toString());
		}
		//반품거부시 SMS전송
	}
	
	public List<ParticularsTargetBranchsDto> getParticularsTargetBranchs(Map<String, Object> params){
		return returnOrderDao.getParticularsTargetBranchs(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void receiveCancelOrderProcess(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception {
		String[] orde_iden_numb_array = (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array = (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array = (String[]) saveMap.get("deli_iden_numb_array");
		String[] rece_iden_numb_array = (String[]) saveMap.get("rece_iden_numb_array");
		for(int i = 0 ; i < orde_iden_numb_array.length ; i++){
			String[] temp_orde_iden_numb = orde_iden_numb_array[i].split("-");
			saveMap.remove("orde_iden_numb");
			saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
			saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
			saveMap.put("purc_iden_numb",purc_iden_numb_array[i]);
			saveMap.put("deli_iden_numb",deli_iden_numb_array[i]);
			if(!rece_iden_numb_array[i].equals("")){// 선발주 주문의 경우 인수차수가 없을 수 있다.
				saveMap.put("rece_iden_numb",rece_iden_numb_array[i]);
			}
			
			// 1. 출하 정보 Update 
			// a. 실인수수량 = 0 으로. 
			// b. 상태 : 인수완료 --> 출하
			// c. 인수자, 인수날짜 초기화
			returnOrderDao.updateMracptForRcop(saveMap); 
			
			// 2. 인수정보 삭제.
			if(!rece_iden_numb_array[i].equals("")){// 선발주 주문의 경우 인수차수가 없을 수 있다.
				returnOrderDao.deleteMrordtListRcop(saveMap); 
			}
			
			// 3. 히스토리 남기기.
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), 
					(String)saveMap.get("rece_iden_numb"), "60", (String)saveMap.get("chan_reas_desc"), userInfoDto.getUserId());
		}
	}
	public String receiveCancelCheck(Map<String, Object> saveMap) {
		String[] orde_iden_numb_array = (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array = (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array = (String[]) saveMap.get("deli_iden_numb_array");
		String[] rece_iden_numb_array = (String[]) saveMap.get("rece_iden_numb_array");
		String returnMsg = "";
		for(int i = 0 ; i < orde_iden_numb_array.length ; i++){
			String[] temp_orde_iden_numb = orde_iden_numb_array[i].split("-");
			saveMap.remove("orde_iden_numb");
			saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
			saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
			saveMap.put("purc_iden_numb",purc_iden_numb_array[i]);
			saveMap.put("deli_iden_numb",deli_iden_numb_array[i]);
			if(!rece_iden_numb_array[i].equals("")){// 선발주 주문의 경우 인수차수가 없을 수 있다.
				saveMap.put("rece_iden_numb",rece_iden_numb_array[i]);
			}
			
			int receiveCheckFlag =0;
			if(!rece_iden_numb_array[i].equals("")){// 선발주 주문의 경우 인수차수가 없을 수 있다.
				receiveCheckFlag = returnOrderDao.selectReceiveCancelCheck(saveMap); 
			}
			if(receiveCheckFlag > 0){
				returnMsg = this.getReceiveCancelErrorMsg(saveMap,receiveCheckFlag);
				break;
			}
		}
		return returnMsg;
	}
	private String getReceiveCancelErrorMsg(Map<String, Object> saveMap, int receiveCheckFlag) {
		String msg = null;
		if(receiveCheckFlag == 0){
			msg = "";
		}else if(receiveCheckFlag == 1){
			msg = "주문번호["+saveMap.get("orde_iden_numb").toString()+saveMap.get("orde_sequ_numb").toString()+"] 발주차수["+saveMap.get("purc_iden_numb").toString()+"] 납품차수["
					+saveMap.get("deli_iden_numb").toString()+"] 인수차수["+saveMap.get("rece_iden_numb").toString()+"] 는 정산 생성 이후 단계로 인수취소를 할 수 없습니다.";
		}else if(receiveCheckFlag == 2){
			msg = "주문번호["+saveMap.get("orde_iden_numb").toString()+saveMap.get("orde_sequ_numb").toString()+"] 발주차수["+saveMap.get("purc_iden_numb").toString()+"] 납품차수["
					+saveMap.get("deli_iden_numb").toString()+"] 인수차수["+saveMap.get("rece_iden_numb").toString()+"] 는 인수가 여러번에 걸쳐 진행되어 인수취소를 할 수 없습니다.";		}
		return msg;
	}
	
	public List<Map<String, Object>> getReturnOrderRegistListExcelView(Map<String, Object> params) {
		return (List<Map<String, Object>>)returnOrderDao.selectReturnOrderRegistListExcelView(params);
	}
	
	/** * 반품요청내역 조회 리스트의 대상 데이터 리턴 */
	public List<Map<String, Object>> getReturnOrderListExcelView(Map<String, Object> params) {
		String prodSpec = "";
		for(int i = 0 ; i < Constances.PROD_GOOD_SPEC.length ; i++){
			if(i == 0) 	prodSpec = Constances.PROD_GOOD_SPEC[i];
			else		prodSpec += "‡" + Constances.PROD_GOOD_SPEC[i];
		}
        String prodStSpec = "";
        for(int i = 0 ; i < Constances.PROD_GOOD_ST_SPEC.length ; i++){
            if(i == 0)  prodStSpec = Constances.PROD_GOOD_ST_SPEC[i];
            else        prodStSpec += "‡" + Constances.PROD_GOOD_ST_SPEC[i];
        }                
		params.put("prodSpec", prodSpec);
		params.put("prodStSpec", prodStSpec);
		return (List<Map<String, Object>>)returnOrderDao.selectReturnOrderListExcelView(params);
	}
	
	/**
	 * 승인처리<br><br><b>
		 1. 반품 정보의 반품처리 상태를 승인(1)으로 변경 , 공급사 처리자 Id, 공급사 처리일자 update<br>
		 2. 주문상품출하 테이블에 반품 정보를 기반으로 (-) 마이너스 수량을 Insert <br>(상위출하차수에 반품요청있었던 인수데이터의 출하차수를 넣는다.)<br>
		 3. 인수내역 테이블에 해당 마이너스 수량 정보를 기반으로 Insert<br>
		 4. 히스토리를 저장한다. </b>
		 (2013-05-02 추가) 
		 1. 물류센터에서 반품 승인 시 해당 상품의 재고 수량을 + 시킨다. (update)
		 2. 수탁상품 히스토리 테이블에 insert를 진행한다
	 * @throws FdlException 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void cenOrderReturnApproval(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");	
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");	
		String[] deli_iden_numb_array= (String[]) saveMap.get("deli_iden_numb_array");		
		String[] return_iden_numb_array= (String[]) saveMap.get("return_iden_numb_array");
		String[] retu_prod_quan_array= (String[]) saveMap.get("retu_prod_quan_array");
		int cnt= 0;
		for(String orde_iden_numb_temp:orde_iden_numb_array){
			saveMap.put("retu_iden_num",return_iden_numb_array[cnt]); 							// 반품번호
			saveMap.put("retu_stat_flag","1"); 															// 승인상태
			saveMap.put("vend_proc_id", attribute.getUserId()); 										// 공급사처리자ID
			saveMap.put("retu_getdate", "Yes"); 															// getdate를 넣기위한 임시방편
			returnOrderDao.updateMrarem(saveMap); 													// 수정하기
			
			String[] temp_orde_iden_numb = orde_iden_numb_temp.split("-");
			saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]); 								// 주문번호
			saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);								// 주문차수
			saveMap.put("purc_iden_numb",purc_iden_numb_array[cnt]);							// 발주차수
			saveMap.put("deli_iden_numb",deli_iden_numb_array[cnt]);								// 출하차수
			saveMap.put("retu_prod_quan", -Integer.parseInt(retu_prod_quan_array[cnt]));		// 반품요청수량
			int deli_iden_numb  = deliveryDao.selectDeliIdenNumb(saveMap);  					// 출하차수 조회
			saveMap.put("deli_iden_numb_new", ""+deli_iden_numb); 								// 출하차수
			saveMap.put("deli_stat_flag","80");															// 반품완료
			returnOrderDao.insertMracptForOrderReturn(saveMap); 									// 출하테이블에 반품정보 Insert 하기  
			
			int rece_iden_numb  = deliveryDao.selectReceIdenNumb(saveMap);  					// 인수차수 조회
			saveMap.remove("deli_iden_numb");
			saveMap.put("deli_iden_numb", saveMap.get("deli_iden_numb_new"));					// 위에서 새로 저장된 출하정보의 출하차수 세팅
			saveMap.put("rece_iden_numb", ""+rece_iden_numb);									// 인수차수 세팅
			deliveryDao.insertMrordtList(saveMap);														// 인수내역 테이블에 저장
			Map<String,Object> stockMap = returnOrderDao.selectStockOrderInfo(saveMap); // 조회
			if(stockMap.get("GOOD_CLAS_CODE").toString().equals("30")){
				// 상품코드, 공급사코드, 변경전수량, 변경후 수량, 변경타입, 유저ID  
				orderCommonSvc.insertMcgoodvendorStockQuan((String)stockMap.get("GOOD_IDEN_NUMB"),(String)stockMap.get("VENDORID"), (int)stockMap.get("BEFORE_QUANTITY"),( (int)stockMap.get("BEFORE_QUANTITY") + Integer.parseInt(retu_prod_quan_array[cnt])) ,"20",attribute.getUserId());										
				orderCommonSvc.updateMcgoodvendorStockQuan((String)stockMap.get("GOOD_IDEN_NUMB"),(String)stockMap.get("VENDORID"),( (int)stockMap.get("BEFORE_QUANTITY") + Integer.parseInt(retu_prod_quan_array[cnt]) ));										
			}
			  
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), 
					(String)saveMap.get("rece_iden_numb"), (String)saveMap.get("deli_stat_flag"), null, attribute.getUserId());
			
			cnt++;
		}
	}
	public int selectClientReturnOrderListCnt(Map<String, Object> params) {
		int returnInt = 0;
		if("".equals(params.get("srcReturnStatFlag").toString()) == false && "rece".equals(params.get("srcReturnStatFlag").toString()) == true){
			returnInt = (Integer) returnOrderDao.selectClientReturnOrderListCntForRece(params);
		}else{
			returnInt = (Integer) returnOrderDao.selectClientReturnOrderListCntForRetu(params);
		}
		return returnInt;
	}
	public List<Map<String,Object>> selectClientReturnOrderList( Map<String, Object> params, int page, int rows) {
		List<Map<String,Object>> resultList = null;
		if("".equals(params.get("srcReturnStatFlag").toString()) == false && "rece".equals(params.get("srcReturnStatFlag").toString()) == true){
			// 반품가능 상품 조회
			List<Map<String,Object>> tempResultList = (List<Map<String,Object>>)returnOrderDao.selectClientReturnOrderListForRece(params, page, rows);
            resultList = new ArrayList<Map<String,Object>>();
            for(Map<String,Object> objMap : tempResultList){
                resultList.add(objMap);
                if("Y".equals((String)objMap.get("IS_ADD_MST")) ){
                    //서브 추가 상품의 주문 정보 조회 
                    String[] tmpOin = objMap.get("ORDE_IDEN_NUMB").toString().split("-");
                    Map<String , Object> tmpMap = new HashMap<String, Object>();
                    tmpMap.put("ORDE_IDEN_NUMB", tmpOin[0]);
                    tmpMap.put("ORDE_SEQU_NUMB", tmpOin[1]);
                    tmpMap = returnOrderDao.selectBuyAddProdOrde(tmpMap);
                    tmpMap.put("printYn", "Y");
                    List<Map<String,Object>> subAddProdList = (List<Map<String,Object>>)returnOrderDao.selectClientReturnOrderListForRece(tmpMap);
                    // 마스터 상품이 인수되어 조회되었을 경우 해당 마스터 상품의 하위 상품도 조회 하여 리스트에 담는다.
                    // 1개가 조회 됨.
                    for(Map<String,Object> tmpOdd : subAddProdList){
                        resultList.add(resultList.size(), tmpOdd);
                    }
                }
            }
		}else{
			// 반품 신청 이후 데이터 조회
			resultList = (List<Map<String,Object>>)returnOrderDao.selectClientReturnOrderListForRetu(params, page, rows);
		}
		return resultList;
	}
	public int selectReturnOrdStatListCnt(Map<String, Object> params) {
		return (Integer) returnOrderDao.selectReturnOrdStatListCnt(params);
	}
	public List<Map<String, Object>> selectReturnOrdStatList( Map<String, Object> params, int page, int rows) {
		return (List<Map<String, Object>>)returnOrderDao.selectReturnOrdStatList(params, page, rows);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void returnOrderProcessForArray(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception {
		String[] orde_iden_numb_array = (String[])saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array = (String[])saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array = (String[])saveMap.get("deli_iden_numb_array");
		String[] rece_iden_numb_array = (String[])saveMap.get("rece_iden_numb_array");
		String retu_prod_quan = (String)saveMap.get("retu_prod_quan");
		String chan_reas_desc = (String)saveMap.get("chan_reas_desc");
		Map<String, Object> tmpMap = null;
		int cnt = 0;
		for(String orde_iden_numb : orde_iden_numb_array){
			String[] temp_orde_iden_numb = orde_iden_numb.split("-");
            tmpMap = new HashMap<String, Object>();
			tmpMap.put("retu_iden_num", seqMpOrderReturnService.getNextStringId());
			tmpMap.put("retu_regi_id", userInfoDto.getUserId());
			tmpMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
			tmpMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
			tmpMap.put("purc_iden_numb", purc_iden_numb_array[cnt]);
			tmpMap.put("deli_iden_numb", deli_iden_numb_array[cnt]);
			tmpMap.put("rece_iden_numb", rece_iden_numb_array[cnt]);
			tmpMap.put("retu_prod_quan", retu_prod_quan);
			tmpMap.put("chan_reas_desc", chan_reas_desc);
			// 반품 테이블에 insert
			returnOrderDao.insertMrarem(tmpMap);
            String returnRequstDesc = (String)tmpMap.get("chan_reas_desc") +"(반품요청수량 : "+retu_prod_quan+")";
            orderCommonSvc.setReturnRequstHist((String)tmpMap.get("orde_iden_numb"), (String)tmpMap.get("orde_sequ_numb"), (String)tmpMap.get("purc_iden_numb"), (String)tmpMap.get("deli_iden_numb"), (String)tmpMap.get("rece_iden_numb"), "반품을 요청함", returnRequstDesc, (String)tmpMap.get("retu_regi_id"));
			
			//반품요청시 SMS발송
			List<Map<String, Object>> returnOrderInfoList = returnOrderDao.selectReturnOrderVendorList(tmpMap);
			String returnOrderMsg = "";
			returnOrderMsg += "주문번호 "+tmpMap.get("orde_iden_numb")+"-"+tmpMap.get("orde_sequ_numb")+"의 반품요청이 왔습니다.";
			for(int i=0; i<returnOrderInfoList.size(); i++){
				commonSvc.sendRightSms(returnOrderInfoList.get(i).get("vendorMobile").toString(), returnOrderMsg);
			}
			cnt++;
		}
	}
	public int selectReturnOrderRegistListCnt(Map<String, Object> params) {
		return (Integer) returnOrderDao.selectReturnOrderRegistListCntNew(params);
	}
	public List<OrderDeliDto> selectReturnOrderRegistList( Map<String, Object> params, int page, int rows) {
		return (List<OrderDeliDto>)returnOrderDao.selectReturnOrderRegistListNew(params, page, rows);
	}
	
	
}
