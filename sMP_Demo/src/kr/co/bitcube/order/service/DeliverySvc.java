package kr.co.bitcube.order.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.order.dao.DeliveryDao;
import kr.co.bitcube.order.dao.PurchaseDao;
import kr.co.bitcube.order.dto.OrderDeliDto;
import kr.co.bitcube.order.dto.OrderReceiveDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class DeliverySvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private DeliveryDao deliveryDao;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private PurchaseDao purchaseDao;
	
	
	@Resource(name="seqMrgoodsvendorHistService")
	private EgovIdGnrService seqMrgoodsvendorHistService;
	
	@Resource(name="seqMcProductHistoryService")
	private EgovIdGnrService seqMcProductHistoryService;
	
	@Resource(name="seqMpOrderReceiptNum")
	private EgovIdGnrService seqMpOrderReceiptNum;
	
	@Resource(name="seqMpMracptSubService")
	private EgovIdGnrService seqMpMracptSubService;
	
	public List<OrderDeliDto> getDeliveryListForOrderDetail( Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_numb").toString().split("-");
		params.remove("orde_iden_numb");
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		return (List<OrderDeliDto>)deliveryDao.selectDeliveryListForOrderDetail(params);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void deliveryStatusChange(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		String[] temp_orde_iden_numb = saveMap.get("orde_iden_numb").toString().split("-");
		saveMap.remove("orde_iden_numb");
		saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
		saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		// 출하 테이블의 상태값 변경.
		deliveryDao.updateMracpt(saveMap);
		// insert data in mrordthist table
		orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), 
				null, (String)saveMap.get("deli_stat_flag"), (String)saveMap.get("chan_reas_desc"), attribute.getUserId());
		
		//출하취소시 SMS전송
		/* 정연백 과장님 요청으로 SMS 미발송처리 20160701 by kkbum2000 */
//		if("93".equals(saveMap.get("deli_stat_flag").toString())){
//			Map<String, Object> smsInfo = deliveryDao.selectOrderNumSmsInfo(saveMap);
//			commonSvc.sendRightSms(smsInfo.get("mobile").toString(), "공급사 ["+smsInfo.get("vendorNm").toString()+"] 에서 출하취소 처리 하였습니다.", smsInfo.get("phoneNum").toString());
//		}
	}

	public int getDeliveryListCnt(Map<String, Object> params) {
		return deliveryDao.selectDeliveryListCnt(params);	
	}

	public List<OrderDeliDto> getDeliveryList(Map<String, Object> params, int page, int rows) {
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
		return deliveryDao.selectDeliveryList(params, page, rows);	
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String insertDeliveryInfo(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		// 출하 테이블에 데이터를 Insert 진행
		// 히스토리 남김
		String[] orde_iden_numb_array_temp= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array_temp= (String[]) saveMap.get("purc_iden_numb_array");
		String[] to_do_deli_prod_quan_array_temp= (String[]) saveMap.get("to_do_deli_prod_quan_array");
		String[] vendorIdArray_temp= (String[]) saveMap.get("vendorIdArray");
		
		// 두개의 컴퓨터에서 출하시 기존 처리된 데이터는 패스하는 기능 추가 2013-04-15 parkjoon
		// 키 : 주문번호, 주문차수, 발주차수 , 처리 대상 데이터 : 발주수량 - 출하수량 >= 사용자가 입력한 출하처리 진행할 수량
		// 주문 상태가 변경될 가능성도 있음. 발주 주문 정보의 상태가 50 인 상태만 처리.
		// 기존 String[] 에서 ArrayList 로 변경.
		List<String> orde_iden_numb_array = new ArrayList<String>();
		List<String> purc_iden_numb_array = new ArrayList<String>();
		List<String> to_do_deli_prod_quan_array = new ArrayList<String>();
		List<String> vendorIdArray = new ArrayList<String>();
		for(int i = 0; i < orde_iden_numb_array_temp.length; i++){
			Map<String,Object> tempMap = new HashMap<String,Object>();
			String orde_iden_numb = orde_iden_numb_array_temp[i];
			String[] temp_iden_numb = orde_iden_numb.split("-");
			String temp_orde_numb = temp_iden_numb[0];
			String temp_orde_sequ = temp_iden_numb[1];
			tempMap.put("temp_orde_iden_numb", temp_orde_numb);		// 주문번호
			tempMap.put("temp_orde_sequ_numb", temp_orde_sequ);		// 주문 차수
			tempMap.put("temp_purc_iden_numb", purc_iden_numb_array_temp[i]);		// 발주차수
			int possQuan = deliveryDao.selectDeliPossibleQuan(tempMap); // 발주수량 - 출하수량 값 조회
			int todoQuan = Integer.parseInt(to_do_deli_prod_quan_array_temp[i]); // 사용자가 입력한 출하처리 희망 수량
			if(possQuan >= todoQuan){
				orde_iden_numb_array.add(orde_iden_numb_array_temp[i]);
				purc_iden_numb_array.add(purc_iden_numb_array_temp[i]);
				to_do_deli_prod_quan_array.add(to_do_deli_prod_quan_array_temp[i]);
				vendorIdArray.add(vendorIdArray_temp[i]);
			}
		}
		String returnString = "";
		if(0 < orde_iden_numb_array.size()){
			/************************************* 인수증 타겟 리스트 시작 ***************************************/
			List<Map<String, Object>> tempList = new ArrayList<Map<String,Object>>();
			for(int i = 0; i < orde_iden_numb_array.size(); i++){
				Map<String,Object> tempMap = new HashMap<String,Object>();
				String orde_iden_numb = orde_iden_numb_array.get(i);
				String[] temp_iden_numb = orde_iden_numb.split("-");
				String temp_orde_numb = temp_iden_numb[0];
				String temp_vendorId = vendorIdArray.get(i);
				tempMap.put("temp_orde_numb", temp_orde_numb);
				tempMap.put("temp_vendorId", temp_vendorId);
				tempList.add(tempMap);
			}
			/************************************* 인수증 타겟 리스트 끝 ***************************************/
			/**************************************** 인수증 그룹 set 시작 *********************************************/
			tempList = new ArrayList<Map<String,Object>>(new HashSet<Map<String,Object>>(tempList));
			String [] returnReceiptNum = new String[tempList.size()];
			int tempCnt = 0;
			for(Map<String,Object> tempGroupMap : tempList){
				String receipt_num = seqMpOrderReceiptNum.getNextStringId();
				tempGroupMap.put("receipt_num", receipt_num);
				returnReceiptNum[tempCnt++] = receipt_num;
			}
			/**************************************** 인수증 그룹 set 끝 *********************************************/
			int cnt = 0;
			String [] orderNumFullArray = new String[orde_iden_numb_array.size()];	//mail,sms발송을 위해
			for(String orde_iden_numb: orde_iden_numb_array) {
				orderNumFullArray[cnt] = orde_iden_numb + "-" + purc_iden_numb_array.get(cnt);
				
				String[] temp_iden_numb = orde_iden_numb.split("-");
				saveMap.put("orde_iden_numb",temp_iden_numb[0]); // 주문번호
				saveMap.put("orde_sequ_numb",temp_iden_numb[1]);// 주문차수
				saveMap.put("purc_iden_numb", purc_iden_numb_array.get(cnt)); // 발주차수
				int deli_iden_numb  = deliveryDao.selectDeliIdenNumb(saveMap);  // 납품차수 조회
				saveMap.put("deli_iden_numb", ""+deli_iden_numb); // 납품차수
				saveMap.put("deli_prod_quan",to_do_deli_prod_quan_array.get(cnt)); // 출하수량
				saveMap.put("rece_prod_quan", "0"); // 실인수수량
				saveMap.put("deli_stat_flag", "60"); // 상태
				saveMap.put("deli_type_clas",""); // 배송유형
				saveMap.put("deli_invo_iden",""); // 송장번호
				saveMap.put("deli_degr_id", attribute.getUserId()); // regi_user_id 가 있으면 Update시 반영
				for(Map<String,Object> tempGroupMap : tempList){		// 인수증 번호 세팅
					if(temp_iden_numb[0].equals((String)tempGroupMap.get("temp_orde_numb")) && vendorIdArray.get(cnt).equals((String)tempGroupMap.get("temp_vendorId"))){
						saveMap.put("receiptNumb", tempGroupMap.get("receipt_num")); 
						break;
					}
				}
				deliveryDao.insertDeliveryInfo(saveMap); // 출하정보 Insert
				int purc_prod_quan = deliveryDao.selectDeliProdQuan(saveMap);  // 발주정보에 있는 출하수량 가져옴
				int temp_deli_quan = Integer.parseInt(to_do_deli_prod_quan_array.get(cnt)); // 사용자가 입력한 출하수량 가져옴
				saveMap.put("deli_prod_quan",(purc_prod_quan + temp_deli_quan)); // 출하수량
				deliveryDao.updateMrpurt(saveMap); // 출하수량 update
				
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), null, "60", null, attribute.getUserId());
				cnt++;
			}
			for(String temp : returnReceiptNum){
				if(returnString.equals("")){
					returnString = temp;
				}else{
					returnString += ","+temp;
				}
			}
			if(returnString.equals("")){
				throw new Exception("인수증 생성시 문제가 발생하였습니다.");
			}
			
			/*------------------------------메일/SMS(주문자) 발송 시작---------------------------------*/
			//출하에서 배송정보 입력일시 이메일, SMS발송 2014-06-16 김승주
//			try{ commonSvc.exeOrderReceiveDeliverySmsEmailByOrderNum(orderNumFullArray, "60"); }
//			catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
			/*------------------------------메일/SMS(주문자) 발송 끝---------------------------------*/
		}
		return returnString;
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updatePurcStatus(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		// 해당 데이터의 키값으로 발주접수상태의 데이터를 발주의뢰 상태로 변경
		// 히스토리 남김.
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");
		int cnt = 0;
		for(String orde_iden_numb: orde_iden_numb_array) {
			String[] temp_iden_numb = orde_iden_numb.split("-");
			saveMap.put("orde_iden_numb",temp_iden_numb[0]);
			saveMap.put("orde_sequ_numb",temp_iden_numb[1]);
			saveMap.put("purc_iden_numb", purc_iden_numb_array[cnt]);
			saveMap.put("purc_stat_flag", "40");
			saveMap.put("del_regi_user_id", "Y");
			saveMap.put("del_regi_date", "Y");
			deliveryDao.updateMrpurt(saveMap);
			
			String chan_reas_desc = (String)saveMap.get("chan_reas_desc")+"<br>["+attribute.getBorgNm()+"] ["+attribute.getUserNm()+"] 사용자가 [주문의뢰] 상태로 처리함.";
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, "40", chan_reas_desc, attribute.getUserId());
//			deliveryDao.InsertMrordtHist(saveMap);	// 히스토리 Insert
			
			//공급사에서 발주접수에서 발주의뢰로 상태변경시 SMS전송
			/* 정연백 과장님 요청으로 SMS 미발송처리 20160701 by kkbum2000 */
//			Map<String, Object> mrpurtSmsInfo = purchaseDao.selectMrpurtSmsInfo(saveMap);
//			String msg = "주문번호["+saveMap.get("orde_iden_numb").toString()+"-"+saveMap.get("orde_sequ_numb").toString()+"] 의 상태가 발주접수 에서 주문의뢰로 변경 되었습니다.";
//			commonSvc.sendRightSms(mrpurtSmsInfo.get("ordeTeleNumb").toString(), msg, mrpurtSmsInfo.get("phoneNum").toString());
			cnt++;
		}
	}
	
	/** * 인수확인 리스트의 대상 데이터 갯수 리턴 */
	public int getReceiveListCnt(Map<String, Object> params) {
		return (Integer) deliveryDao.selectReceiveListCnt(params);
	}
	/** * 인수확인 리스트의 대상 데이터 리턴 */
	public List<OrderDeliDto> getReceiveList(Map<String, Object> params, int page, int rows) {
		return (List<OrderDeliDto>)deliveryDao.selectReceiveList(params, page, rows);
	}

	public int getDeliCompleteListCnt(Map<String, Object> params) {
		return (Integer) deliveryDao.selectDeliCompleteListCnt(params);
	}

	public List<OrderDeliDto> getDeliCompleteList(Map<String, Object> params, int page, int rows) {
		return (List<OrderDeliDto>)deliveryDao.selectDeliCompleteList(params, page, rows);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateIsDelivery(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		saveMap.put("isDelivery", "1"); // 배송완료 상태
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array= (String[]) saveMap.get("deli_iden_numb_array");
		int cnt = 0;
		for(String orde_iden_numb: orde_iden_numb_array) {
			String[] temp_iden_numb = orde_iden_numb.split("-");
			saveMap.put("orde_iden_numb",temp_iden_numb[0]);
			saveMap.put("orde_sequ_numb",temp_iden_numb[1]);
			saveMap.put("purc_iden_numb", purc_iden_numb_array[cnt]);
			saveMap.put("deli_iden_numb", deli_iden_numb_array[cnt]);
			deliveryDao.updateMracpt(saveMap);
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), null, "61", null, attribute.getUserId());
			cnt++;
		}
	}
	
	/** 운영사의 인수처리 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void admOrderReceiveProcess(Map<String, Object> saveMap, LoginUserDto userDto) throws Exception {
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array = (String[]) saveMap.get("deli_iden_numb_array");
		String[] deli_prod_quan_array = (String[]) saveMap.get("deli_prod_quan_array");
		List<String> procTargetOrdList = new ArrayList<String>();  // 중복체크 용 List
		Map<String, Object> tmpParam = null;	// 임시 Map 객체
		Map<String,Object> addProdSearchResult = null;		// 추가상품 조회 결과 Map 객체
		List<Map<String, Object>> returnList = new ArrayList<Map<String,Object>>();  // 데이터 완료 리스트
		
		// 중복확인 선작업
		for(int i = 0 ; i < orde_iden_numb_array.length; i ++){
			procTargetOrdList.add(orde_iden_numb_array[i]);
			tmpParam = new HashMap<String, Object>();
			tmpParam.put("ORDE_IDEN_NUMB", orde_iden_numb_array[i]);
			tmpParam.put("PURC_IDEN_NUMB", purc_iden_numb_array[i]);
			tmpParam.put("DELI_IDEN_NUMB", deli_iden_numb_array[i]);
			tmpParam.put("DELI_PROD_QUAN", deli_prod_quan_array[i]);
			returnList.add(tmpParam);
		}
		// 중복체크
		for(String procTargetOrd : procTargetOrdList){
			String[] tmpArr = procTargetOrd.split("-");
			tmpParam = new HashMap<String, Object>();
			tmpParam.put("ORDE_IDEN_NUMB", tmpArr[0]);
			tmpParam.put("ORDE_SEQU_NUMB", tmpArr[1]);
            addProdSearchResult = this.addProdSearchForRece(tmpParam);
            // 추가상품 관련 데이터가 있고, 처리 대상 주문이 아닐경우 세팅해줌.
            if( addProdSearchResult != null && procTargetOrdList.contains( CommonUtils.getString(addProdSearchResult.get("ORDE_IDEN_NUMB")) ) == false ){
            	returnList.add(addProdSearchResult);
            }
		}
		
		String[] new_orde_iden_numb_array= new String[returnList.size()];
		String[] new_purc_iden_numb_array= new String[returnList.size()];
		String[] new_deli_iden_numb_array = new String[returnList.size()];
		String[] new_deli_prod_quan_array = new String[returnList.size()];
		
		// 최종값 세팅.
		for(int i = 0; i < returnList.size(); i++){
			tmpParam = returnList.get(i);
			new_orde_iden_numb_array[i] = CommonUtils.getString(tmpParam.get("ORDE_IDEN_NUMB"));
			new_purc_iden_numb_array[i] = CommonUtils.getString(tmpParam.get("PURC_IDEN_NUMB"));
			new_deli_iden_numb_array[i] = CommonUtils.getString(tmpParam.get("DELI_IDEN_NUMB"));
			new_deli_prod_quan_array[i] = CommonUtils.getString(tmpParam.get("DELI_PROD_QUAN"));
		}
		
		saveMap.clear();
		saveMap.put("orde_iden_numb_array", new_orde_iden_numb_array);
		saveMap.put("purc_iden_numb_array", new_purc_iden_numb_array);
		saveMap.put("deli_iden_numb_array", new_deli_iden_numb_array);
		saveMap.put("deli_prod_quan_array", new_deli_prod_quan_array);
		
		this.orderReceiveProcess(saveMap, userDto);	//인수처리
	}


	/** 추가상품 배송상품이 존재하는지 조회  */
	private Map<String, Object> addProdSearchForRece(Map<String, Object> paramMap) {
		return deliveryDao.addProdSearchForRece(paramMap);
	}

	//스케줄에서 사용하므로 아래 로직을 고치지 말것 Jameskang 20151220
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void orderReceiveProcess(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array = (String[]) saveMap.get("deli_iden_numb_array");
		String[] deli_prod_quan_array = (String[]) saveMap.get("deli_prod_quan_array");
		int cnt = 0;
		String [] orderNumFullArray = new String[orde_iden_numb_array.length];	//mail,sms발송을 위해
		for(String orde_iden_numb: orde_iden_numb_array) {
			orderNumFullArray[cnt] = orde_iden_numb + "-" + purc_iden_numb_array[cnt];
			
			String[] temp_iden_numb = orde_iden_numb.split("-");
			saveMap.put("orde_iden_numb",temp_iden_numb[0]); 			// 주문번호
			saveMap.put("orde_sequ_numb",temp_iden_numb[1]);			// 주문차수
			saveMap.put("purc_iden_numb", purc_iden_numb_array[cnt]);	// 발주차수
			saveMap.put("deli_iden_numb", deli_iden_numb_array[cnt]);		// 출하차수
			saveMap.put("deli_rece_id", attribute.getUserId());					// 인수자 아이디, 날짜도 동시에 Update 진행함.
			// 1. 해당 Key 값으로 매칭되는 출하테이블의 데이터의 상태를 변경한다.
			// case. 주문유형이 선발주인가? 69(인수확인(선발주))  , 70(인수확인)
			// 69 : 인수데이터를 저장하지 않고 상태만 변경한다.
			// 70 : 인수데이터를 저장한다. 출하수량 만큼 실인수수량을 Update 한다.
			OrderDeliDto orde_type_clas_dto = deliveryDao.selectOrdeTypeClas(saveMap);
			if("20".equals(orde_type_clas_dto.getOrde_type_clas())){
				saveMap.put("deli_stat_flag", "69");							// 인수완료(실인수미입력)
				saveMap.remove("rece_prod_quan");							
				saveMap.remove("rece_iden_numb");							
				deliveryDao.updateMracpt(saveMap); 						// 출하 상태 69 로 변경
			}else{
				saveMap.put("rece_prod_quan", deli_prod_quan_array[cnt]);	// 인수수량
				saveMap.put("deli_stat_flag", "70");							// 인수완료
				deliveryDao.updateMracpt(saveMap);						// 상태 70으로 변경 
				int rece_iden_numb  = deliveryDao.selectReceIdenNumb(saveMap);  // 인수차수 조회
				saveMap.put("rece_iden_numb", ""+rece_iden_numb);	// 인수차수 세팅
				deliveryDao.insertMrordtList(saveMap);						// 인수내역 테이블에 저장
			}
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), 
					(String)saveMap.get("rece_iden_numb"), (String)saveMap.get("deli_stat_flag"), null, attribute.getUserId());
			cnt++;
		}
		
		if(!"0".equals(attribute.getUserId())) { 
			/*------------------------------메일/SMS(주문자) 발송 시작---------------------------------*/
			try{ commonSvc.exeOrderReceiveDeliverySmsEmailByOrderNum(orderNumFullArray, "70"); }
			catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
			/*------------------------------메일/SMS(주문자) 발송 끝---------------------------------*/
		}
	}
	
	/** * 선발주인수처리 리스트의 대상 데이터 갯수 리턴 */
	public int getFirstPurchaseHandleList(Map<String, Object> params) {
		return (Integer) deliveryDao.selectFirstPurchaseHandleListCnt(params);
	}
	/** * 선발주인수처리 리스트의 대상 데이터 리턴 */
	public List<OrderDeliDto> getFirstPurchaseHandleList(Map<String, Object> params, int page, int rows) {
		return (List<OrderDeliDto>)deliveryDao.selectFirstPurchaseHandleList(params, page, rows);
	}
	
	/** * 선발주 실 인수처리 -  내역확인 팝업 리스트의 대상 데이터 리턴 */
	public List<OrderReceiveDto> getFirstPurchaseHandlePopList(Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_numb").toString().split("-");
		params.remove("orde_iden_numb");
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		return (List<OrderReceiveDto>)deliveryDao.selectFirstPurchaseHandlePopList(params);
		
	}

	/**
	 * 실인수 처리 진행<br>
	 * 1. 해당 실 인수 처리 할 선발주 주문의 인수정보를 토대로 [매출처리할수량]의 값을 저장한다.<br>
	 * (매출처리할 수량 = 기존 매출 처리할 수량 + 입력된 매출 처리할 수량)<br>
	 * 2. 입력된 매출 처리할 수량을 토대로 인수확인 테이블(mrordtlist)에 insert를 진행.<br>
	 * 3. 히스토리 저장.<br>
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void firstPurchaseHandle(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array = (String[]) saveMap.get("deli_iden_numb_array");
		String[] deli_prod_quan_array = (String[]) saveMap.get("deli_prod_quan_array");
		String[] to_do_rece_prod_quan_array = (String[]) saveMap.get("to_do_rece_prod_quan_array");
		int cnt = 0;
		for(String orde_iden_numb: orde_iden_numb_array) {
			String[] temp_iden_numb = orde_iden_numb.split("-");
			saveMap.put("orde_iden_numb",temp_iden_numb[0]); 			// 주문번호
			saveMap.put("orde_sequ_numb",temp_iden_numb[1]);			// 주문차수
			saveMap.put("purc_iden_numb", purc_iden_numb_array[cnt]);	// 발주차수
			saveMap.put("deli_iden_numb", deli_iden_numb_array[cnt]);		// 출하차수
			saveMap.put("deli_rece_id", attribute.getUserId());					// 인수자 아이디, 날짜도 동시에 Update 진행함.
			saveMap.put("real_rece_numb", attribute.getUserId());				// 실 인수자 인수자 ID
			int rece_prod_quan_old = deliveryDao.selectReceProdQuan(saveMap);// 기존 인수수량 조회
			int rece_prod_quan_new = rece_prod_quan_old +Integer.parseInt(to_do_rece_prod_quan_array[cnt]); // 기존 인수수량에 사용자가 입력한 값을 더한다._
			saveMap.put("rece_prod_quan", to_do_rece_prod_quan_array[cnt]);// 실인수량
			int rece_iden_numb  = deliveryDao.selectReceIdenNumb(saveMap);  // 인수차수 조회
			saveMap.put("rece_iden_numb", ""+rece_iden_numb);	// 인수차수 세팅
			deliveryDao.updateMracpt(saveMap);						// 사용자가 입력한 인수수량으로 수정 : 기존에 인수 데이터 생성 부분 재활용하기 위한 목적.
			deliveryDao.insertMrordtListForFirstOrder(saveMap);						// 인수내역 테이블에 저장
			saveMap.remove("rece_prod_quan");
			saveMap.put("rece_prod_quan", rece_prod_quan_new); // 실인수량
			if(rece_prod_quan_new != Integer.parseInt(deli_prod_quan_array[cnt])){
				saveMap.put("deli_stat_flag", "69"); // 납품 받아야하는 수량과 실 인수수량의 값이 다를 경우 인수완료 미완.
			}else{
				saveMap.put("deli_stat_flag", "70"); // 인수 완료시 상태를 70 으로 저장
			}
			deliveryDao.updateMracpt(saveMap);					   // 실인수수량 더한 값으로 수정
			orderCommonSvc.setOrderHist( (String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), (String)saveMap.get("rece_iden_numb"), (String)saveMap.get("deli_stat_flag"), null, attribute.getUserId());
			cnt++;
		}
	}
	
	/** 물류센터에서의 인수 확인 처리 - 인수내역 테이블에 데이터를 저장하지 않는다. */
	// 추가 - 수탁상품히스토리 테이블에 insert
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void orderReceiveCenProcess(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array = (String[]) saveMap.get("deli_iden_numb_array");
		String[] deli_prod_quan_array = (String[]) saveMap.get("deli_prod_quan_array");
		int cnt = 0;
		for(String orde_iden_numb: orde_iden_numb_array) {
			String[] temp_iden_numb = orde_iden_numb.split("-");
			saveMap.put("orde_iden_numb",temp_iden_numb[0]); 			// 주문번호
			saveMap.put("orde_sequ_numb",temp_iden_numb[1]);			// 주문차수
			saveMap.put("purc_iden_numb", purc_iden_numb_array[cnt]);	// 발주차수
			saveMap.put("deli_iden_numb", deli_iden_numb_array[cnt]);		// 출하차수
			saveMap.put("deli_rece_id", attribute.getUserId());					// 인수자 아이디, 날짜도 동시에 Update 진행함.
			// 1. 해당 Key 값으로 매칭되는 출하테이블의 데이터의 상태를 변경한다.
			saveMap.put("rece_prod_quan", deli_prod_quan_array[cnt]);	// 인수수량
			saveMap.put("deli_stat_flag", "70");							// 인수완료
			deliveryDao.updateMracpt(saveMap);						// 상태 70으로 변경 
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), 
					null, (String)saveMap.get("deli_stat_flag"), null, attribute.getUserId());
			// 2. 재고수량 update. 히스토리 insert 
//			saveMap.put("good_hist_id", seqMrgoodsvendorHistService.getNextStringId());  // 상품공급사 히스토리를 사용하지 않는것으로 보임. 추후 에러 발생가능성이 있어 주석처리 후 상품쪽에서 사용하던 히스토리 넘버를 가지고 옴.
			saveMap.put("good_hist_id"	, 	seqMcProductHistoryService.getNextIntegerId() 	);
//			int stockQuan = deliveryDao.selectGoodsStockQuan(saveMap);				
//			saveMap.put("now_stoc_quan", stockQuan + Integer.parseInt(deli_prod_quan_array[cnt])); 
//			deliveryDao.updateGoodsStockQuan(saveMap);				
			
			Map<String,Object> stockMap = orderCommonSvc.selectStockOrderInfo(saveMap); // 조회
			if(stockMap.get("GOOD_CLAS_CODE").toString().equals("30")){
				// 상품코드, 공급사코드, 변경전수량, 변경후 수량, 변경타입, 유저ID
				orderCommonSvc.insertMcgoodvendorStockQuan((String)stockMap.get("GOOD_IDEN_NUMB"),(String)stockMap.get("VENDORID"),(int)stockMap.get("BEFORE_QUANTITY"),((int)stockMap.get("BEFORE_QUANTITY") + Integer.parseInt(deli_prod_quan_array[cnt])) ,"10",attribute.getUserId());										
				orderCommonSvc.updateMcgoodvendorStockQuan((String)stockMap.get("GOOD_IDEN_NUMB"),(String)stockMap.get("VENDORID"),((int)stockMap.get("BEFORE_QUANTITY") + Integer.parseInt(deli_prod_quan_array[cnt])));										
			}
//			deliveryDao.insertMcGoodsVenderHist(saveMap);  수탁상품 히스토리 테이블을 사용함에 따라 주석처리
			cnt++;
		}
	}

	public List<OrderReceiveDto> getDeliShowHist(Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_numb").toString().split("-");
		params.remove("orde_iden_numb");
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		return (List<OrderReceiveDto>)deliveryDao.selectDeliShowHist(params);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setRealDeliveryInfo(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		saveMap.put("mracptsub_id", seqMpMracptSubService.getNextStringId());
		String[] temp_orde_iden_numb = saveMap.get("orde_iden_numb").toString().split("-");
		saveMap.remove("orde_iden_numb");
		saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
		saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		saveMap.put("regi_user_id",attribute.getUserId());
		deliveryDao.insertRealDeliveryInfo(saveMap);
	}

	public void deleteRealDeliveryInfo(Map<String, Object> saveMap) {
		deliveryDao.deleteRealDeliveryInfo(saveMap); 
	}

	/** * 출하 데이터에 배송유형과 송장번호를 저장한다. */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setDeliveryInvoInfo(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_iden_numb_array = (String[]) saveMap.get("deli_iden_numb_array");
		String[] deli_type_clas_array = (String[]) saveMap.get("deli_type_clas_array");
		String[] deli_invo_iden_array = (String[]) saveMap.get("deli_invo_iden_array");
		saveMap.put("isDelivery", "1");
		int cnt = 0;
		for(String orde_iden_numb: orde_iden_numb_array) {
			String[] temp_iden_numb = orde_iden_numb.split("-");
			saveMap.put("orde_iden_numb",temp_iden_numb[0]); // 주문번호
			saveMap.put("orde_sequ_numb",temp_iden_numb[1]);// 주문차수
			saveMap.put("purc_iden_numb", purc_iden_numb_array[cnt]); // 발주차수
			saveMap.put("deli_iden_numb", deli_iden_numb_array[cnt]); // 출하차수
			saveMap.put("new_deli_type_clas", deli_type_clas_array[cnt]); // 운송유형
			saveMap.put("new_deli_invo_iden", deli_invo_iden_array[cnt]); // 송장번호
			saveMap.put("invoiceUserId", attribute.getUserId()); // 송장등록자
			deliveryDao.updateMracpt(saveMap);
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), null, "61", null, attribute.getUserId());
			//배송정보일 입력시 이메일, sms 전송
			try{ commonSvc.orderReceiveDeliverySmsEmailSend(saveMap); }
			catch(Exception e){ logger.error("Email/Sms Save Error : "+e); }
			cnt++;
		}
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateReceiptImgFile(Map<String, Object> saveMap) throws Exception{
		deliveryDao.updateReceiptImgFile(saveMap); 
	}
	
	public List<Map<String, Object>> getDeliveryListExcelView(Map<String, Object> params) {
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
		return (List<Map<String, Object>>)deliveryDao.selectDeliveryListExcelView(params);	
	}
	
	public List<Map<String, Object>> getDeliCompleteListExcelView( Map<String, Object> params) {
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
		params.put("prodSpec","규격"+ prodSpec);
		params.put("prodStSpec", prodStSpec);
		return (List<Map<String, Object>>)deliveryDao.selectDeliCompleteListExcelView(params);
	}
	
	
	public List<Map<String, Object>> getReceiveListExcelView(Map<String, Object> params) {
		return (List<Map<String, Object>>)deliveryDao.selectReceiveListExcelView(params);
	}

	public int getDeliProcListCnt(Map<String, Object> params) {
		return deliveryDao.selectDeliProcListCnt(params);	
	}

	public List<OrderDeliDto> getDeliProcList(Map<String, Object> params, int page, int rows) {
		return deliveryDao.selectDeliProcList(params, page, rows);	
	}

	/**
	 *  배송처리 - 배송유형과 송장번호 및 배송 완료 처리.
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String insertDeliProc(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		// 출하 테이블에 데이터를 Insert 진행
		// 히스토리 남김
		String[] orde_iden_numb_array_temp= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array_temp= (String[]) saveMap.get("purc_iden_numb_array");
		String[] to_do_deli_prod_quan_array_temp= (String[]) saveMap.get("to_do_deli_prod_quan_array");
		String[] vendorIdArray_temp= (String[]) saveMap.get("vendorIdArray");
		// 한번에 배송까지 처리.
		String[] deliveryType_array_temp= (String[]) saveMap.get("deliveryType_array");			// 배송유형
		String[] deliveryNumber_array_temp= (String[]) saveMap.get("deliveryNumber_array");	// 송장번호
		String[] deliDesc_array_temp= (String[]) saveMap.get("deliDesc_array");	// 비고
		
		// 두개의 컴퓨터에서 출하시 기존 처리된 데이터는 패스하는 기능 추가 2013-04-15 parkjoon
		// 키 : 주문번호, 주문차수, 발주차수 , 처리 대상 데이터 : 발주수량 - 출하수량 >= 사용자가 입력한 출하처리 진행할 수량
		// 주문 상태가 변경될 가능성도 있음. 발주 주문 정보의 상태가 50 인 상태만 처리.
		// 기존 String[] 에서 ArrayList 로 변경.
		List<String> orde_iden_numb_array = new ArrayList<String>();
		List<String> purc_iden_numb_array = new ArrayList<String>();
		List<String> to_do_deli_prod_quan_array = new ArrayList<String>();
		List<String> vendorIdArray = new ArrayList<String>();
		List<String> deliveryType_array = new ArrayList<String>();
		List<String> deliveryNumber_array = new ArrayList<String>();
		List<String> deliDesc_array = new ArrayList<String>();
		for(int i = 0; i < orde_iden_numb_array_temp.length; i++){
			Map<String,Object> tempMap = new HashMap<String,Object>();
			String orde_iden_numb = orde_iden_numb_array_temp[i];
			String[] temp_iden_numb = orde_iden_numb.split("-");
			String temp_orde_numb = temp_iden_numb[0];
			String temp_orde_sequ = temp_iden_numb[1];
			tempMap.put("temp_orde_iden_numb", temp_orde_numb);		// 주문번호
			tempMap.put("temp_orde_sequ_numb", temp_orde_sequ);		// 주문 차수
			tempMap.put("temp_purc_iden_numb", purc_iden_numb_array_temp[i]);		// 발주차수
			int possQuan = deliveryDao.selectDeliPossibleQuan(tempMap); // 발주수량 - 출하수량 값 조회
			int todoQuan = Integer.parseInt(to_do_deli_prod_quan_array_temp[i]); // 사용자가 입력한 출하처리 희망 수량
			if(possQuan >= todoQuan){
				orde_iden_numb_array.add(orde_iden_numb_array_temp[i]);
				purc_iden_numb_array.add(purc_iden_numb_array_temp[i]);
				to_do_deli_prod_quan_array.add(to_do_deli_prod_quan_array_temp[i]);
				vendorIdArray.add(vendorIdArray_temp[i]);
				deliveryType_array.add(deliveryType_array_temp[i]);
				deliveryNumber_array.add(deliveryNumber_array_temp[i]);
				deliDesc_array.add(deliDesc_array_temp[i]);
			}
		}
		String returnString = "";
		if(0 < orde_iden_numb_array.size()){
			/************************************* 인수증 타겟 리스트 시작 ***************************************/
			List<Map<String, Object>> tempList = new ArrayList<Map<String,Object>>();
			for(int i = 0; i < orde_iden_numb_array.size(); i++){
				Map<String,Object> tempMap = new HashMap<String,Object>();
				String orde_iden_numb = orde_iden_numb_array.get(i);
				String[] temp_iden_numb = orde_iden_numb.split("-");
				String temp_orde_numb = temp_iden_numb[0];
				String temp_vendorId = vendorIdArray.get(i);
				tempMap.put("temp_orde_numb", temp_orde_numb);
				tempMap.put("temp_vendorId", temp_vendorId);
				tempList.add(tempMap);
			}
			/************************************* 인수증 타겟 리스트 끝 ***************************************/
			/**************************************** 인수증 그룹 set 시작 *********************************************/
			tempList = new ArrayList<Map<String,Object>>(new HashSet<Map<String,Object>>(tempList));
			String [] returnReceiptNum = new String[tempList.size()];
			int tempCnt = 0;
			for(Map<String,Object> tempGroupMap : tempList){
				String receipt_num = seqMpOrderReceiptNum.getNextStringId();
				tempGroupMap.put("receipt_num", receipt_num);
				returnReceiptNum[tempCnt++] = receipt_num;
			}
			/**************************************** 인수증 그룹 set 끝 *********************************************/
			int cnt = 0;
			String [] orderNumFullArray = new String[orde_iden_numb_array.size()];	//mail,sms발송을 위해
			for(String orde_iden_numb: orde_iden_numb_array) {
				orderNumFullArray[cnt] = orde_iden_numb + "-" + purc_iden_numb_array.get(cnt);
				
				String[] temp_iden_numb = orde_iden_numb.split("-");
				saveMap.put("orde_iden_numb",temp_iden_numb[0]); // 주문번호
				saveMap.put("orde_sequ_numb",temp_iden_numb[1]);// 주문차수
				saveMap.put("purc_iden_numb", purc_iden_numb_array.get(cnt)); // 발주차수
				int deli_iden_numb  = deliveryDao.selectDeliIdenNumb(saveMap);  // 납품차수 조회
				saveMap.put("deli_iden_numb", ""+deli_iden_numb); // 납품차수
				saveMap.put("deli_prod_quan",to_do_deli_prod_quan_array.get(cnt)); // 출하수량
				saveMap.put("rece_prod_quan", "0"); // 실인수수량
				saveMap.put("deli_stat_flag", "60"); // 상태
				saveMap.put("deli_type_clas", deliveryType_array.get(cnt)); // 배송유형
				saveMap.put("deli_invo_iden", deliveryNumber_array.get(cnt)); // 송장번호
				saveMap.put("deli_degr_id", attribute.getUserId()); // regi_user_id 가 있으면 Update시 반영
				for(Map<String,Object> tempGroupMap : tempList){		// 인수증 번호 세팅
					if(temp_iden_numb[0].equals((String)tempGroupMap.get("temp_orde_numb")) && vendorIdArray.get(cnt).equals((String)tempGroupMap.get("temp_vendorId"))){
						saveMap.put("receiptNumb", tempGroupMap.get("receipt_num")); 
						break;
					}
				}
				saveMap.put("deli_desc", deliDesc_array.get(cnt));
				
				// 2015-12-03 출하처리 시 발주 정보 새로 생성하게 수정. // 출하할 수량이 0개 가 되면 발주정보 새로 생성하지 않음.
				deliveryDao.insertDeliProc(saveMap); // 출하정보 Insert
				Map<String, Object> tempParamater = new HashMap<String, Object>();
				tempParamater.put("orde_iden_numb", temp_iden_numb[0]);
				tempParamater.put("orde_sequ_numb", temp_iden_numb[1]);
				tempParamater.put("purc_iden_numb",purc_iden_numb_array.get(cnt));
				Map<String, Object> mrpurtInfoMap = deliveryDao.selectMrpurtInfo(tempParamater);
				
				int temp_deli_quan = Integer.parseInt(to_do_deli_prod_quan_array.get(cnt)); // 사용자가 입력한 출하수량 가져옴
				int tmpPurcRequQuanValue = Integer.parseInt(""+mrpurtInfoMap.get("PURC_REQU_QUAN"));
				if( (tmpPurcRequQuanValue - temp_deli_quan) > 0){ //발주 요청 수량 - 사용자가 입력한 출하수량 의 값이 0보다 클때 === 남은 출하수량이 있음을 의미.
					mrpurtInfoMap.put("insertPurcRequQuan", tmpPurcRequQuanValue - temp_deli_quan);	// 발주수량
					mrpurtInfoMap.put("insertDeliProdQuan", 0);	// 출하수량
                    int newPurcIdenNumb = deliveryDao.selectMrpurtKeyValue(tempParamater);
//					int newPurcIdenNumb = Integer.parseInt(""+mrpurtInfoMap.get("PURC_IDEN_NUMB"));
					mrpurtInfoMap.put("newPurcIdenNumb", newPurcIdenNumb);	// 새로운 발주차수
					deliveryDao.insertNewMrpurtInfo(mrpurtInfoMap); // 새로운 발주주문정보 생성.
				}
				
				saveMap.put("deli_prod_quan",temp_deli_quan); // 출하수량
				saveMap.put("purc_requ_quan_temp",temp_deli_quan); // 발주수량
				
				Map<String , Object> tempMap = new HashMap<String,Object>();
				tempMap.put("ordeIdenNumb", temp_iden_numb[0]);
				tempMap.put("ordeSequNumb", temp_iden_numb[1]);
				tempMap = 	deliveryDao.selectAddProdSearchForDeli(tempMap);
				saveMap.remove("ADD_RECEIVE_YN");
				saveMap.remove("ADD_RECEIVE_USER_ID");
				if(tempMap != null ){
					// 추가 상품 관련 주문은 mrpurt 테이블의 ADD_RECEIVE_YN 값을 수정함.
					saveMap.put("ADD_RECEIVE_YN","Y");
					saveMap.put("ADD_RECEIVE_USER_ID", attribute.getUserId());
				}
				deliveryDao.updateMrpurt(saveMap); // 발주수량, 출하수량 을 사용자가 입력한 내용대로 update.
				
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), (String)saveMap.get("deli_iden_numb"), null, "60", null, attribute.getUserId());
				
				// 주문상품의 재고수량관리 여부에 따라 재고수량 처리
                orderCommonSvc.stockManage("MINUS",temp_iden_numb[0], temp_iden_numb[1], purc_iden_numb_array.get(cnt), attribute.getUserId(), temp_deli_quan);
				cnt++;
			}
			for(String temp : returnReceiptNum){
				if(returnString.equals("")){
					returnString = temp;
				}else{
					returnString += ","+temp;
				}
			}
			if(returnString.equals("")){
				throw new Exception("인수증 생성시 문제가 발생하였습니다.");
			}
			
			/*------------------------------메일/SMS(주문자) 발송 시작---------------------------------*/
			//출하에서 배송정보 입력일시 이메일, SMS발송 2014-06-16 김승주
			try{ commonSvc.exeOrderReceiveDeliverySmsEmailByOrderNum(orderNumFullArray, "60"); }
			catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
			/*------------------------------메일/SMS(주문자) 발송 끝---------------------------------*/
		}
		return returnString;
	}
	
	
	public List<Map<String, Object>> getDeliProcListExcelView(Map<String, Object> params) {
		return (List<Map<String, Object>>)deliveryDao.selectDeliProcListExcelView(params);	
	}

	public int getProdReceiveListCnt(Map<String, Object> params) {
		return deliveryDao.selectProdReceiveListCnt(params);	
	}
	
	public List<OrderDeliDto> getProdReceiveList(Map<String, Object> params, int page, int rows) {
		return (List<OrderDeliDto>)deliveryDao.selectProdReceiveList(params, page, rows);
	}

	/** 배송정보 팝업정보 조회 */
	public Map<String, Object> selectClientReceiveDeliInfoPop( Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_numb").toString().split("-");
		params.remove("orde_iden_numb");
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		return (Map<String, Object>)deliveryDao.selectClientReceiveDeliInfoPop(params);
	}

	public int selectClientReceHistListCnt(Map<String, Object> params) {
		return deliveryDao.selectClientReceHistListCnt(params);	
	}

	public List<Map<String, Object>> selectClientReceHistList( Map<String, Object> params, int page, int rows) {
		return (List<Map<String,Object>>)deliveryDao.selectClientReceHistList(params, page, rows);
	}

	public int selectVenOrdReceStandByListCnt(Map<String, Object> params) {
		return deliveryDao.selectVenOrdReceStandByListCnt(params);	
	}

	public List<Map<String, Object>> selectVenOrdReceStandByList( Map<String, Object> params, int page, int rows) {
		return deliveryDao.selectVenOrdReceStandByList(params, page, rows);	
	}

	public int getVenDeliProcListCnt(Map<String, Object> params) {
		return deliveryDao.selectVenDeliProcListCnt(params);	
	}

	/**
	 * <pre>
	 * 공급사의 배송처리 정보 조회 리스트를 조회하며 반환하는 메소드
	 * 
	 * ~. 결과 Map 형식
	 *   !. record  (Integer, 리스트 전체 카운트)
	 *   !. pageMax (Integer, 페이지 최대 수)
	 *   !. list    (List,    조회 리스트)
	 * </pre>  
	 *  
	 * @param params
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getVenDeliProcList(ModelMap params) throws Exception {
		Map<String, Object> result             = this.commonSvc.getJqGridList("order.delivery.selectVenDeliProcListCnt", "order.delivery.selectVenDeliProcList", params);
		List<OrderDeliDto>  list               = (List<OrderDeliDto>)result.get("list");
		OrderDeliDto        listInfo           = null;
		String              purcRequQuanString = null;
		int                 listSize           = CommonUtils.getListSize(list);
		int                 i                  = 0;
		double              purcRequQuan       = 0;
		double              deliProdQuan       = 0;
		double              toDoDeliProdQuan   = 0;
		
		for(i = 0; i < listSize; i++){
			listInfo           = list.get(i);
			purcRequQuanString = listInfo.getPurc_requ_quan();
			deliProdQuan       = listInfo.getDeli_prod_quan();
			purcRequQuan       = Double.parseDouble(purcRequQuanString);
			toDoDeliProdQuan   = purcRequQuan - deliProdQuan;
			
			listInfo.setTo_do_deli_prod_quan(toDoDeliProdQuan);
    	}
		
		result.put("list", list);
		
		return result;
	}

	public Map<String, Object> selectVenReceiveDeliInfoPop( Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_numb").toString().split("-");
		params.remove("orde_iden_numb");
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
        Map<String,Object> prodInfoMap = deliveryDao.selectAddProduct(params);
        if("".equals(CommonUtils.getString(prodInfoMap.get("ADD_REPRE_SEQU_NUMB")).trim()) == false && "0".equals(CommonUtils.getString(prodInfoMap.get("ADD_REPRE_SEQU_NUMB"))) == false ){
        	return deliveryDao.selectVenReceiveDeliInfoPopForAddProd(params);	
        }else{
        	return deliveryDao.selectVenReceiveDeliInfoPop(params);	
        }
	}

	public int getVenReceHistListCnt(Map<String, Object> params) {
		return deliveryDao.selectVenReceHistListCnt(params);	
	}

	public List<Map<String,Object>> getVenReceHistList(Map<String, Object> params, int page, int rows) {
		return (List<Map<String,Object>>)deliveryDao.selectVenReceHistList(params, page, rows);
	}

	public void updateVenAddProdReceive(Map<String, Object> saveMap) {
		String orde_iden_numbArr = (String) saveMap.get("orde_iden_numb");
		String[] tmpArr = orde_iden_numbArr.split("-");
		String orde_iden_numb = tmpArr[0];
		String orde_sequ_numb = tmpArr[1];
		String purc_iden_numb_ = (String) saveMap.get("purc_iden_numb");
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("orde_iden_numb", orde_iden_numb);
		paramMap.put("orde_sequ_numb", orde_sequ_numb);
		paramMap.put("purc_iden_numb_", purc_iden_numb_);
		paramMap.put("userId", (String)saveMap.get("userId"));
		deliveryDao.updateVenAddProdReceive(paramMap);
	}

	public int selectProdReceiveListCnt(Map<String, Object> params) {
		return deliveryDao.selectBuyProdReceiveListCnt(params);	
	}

	public List<OrderDeliDto> selectProdReceiveList(Map<String, Object> params, int page, int rows) {
		List<OrderDeliDto> resultList = (List<OrderDeliDto>)deliveryDao.selectBuyProdReceiveList(params, page, rows);
		List<OrderDeliDto> returnList = new ArrayList<OrderDeliDto>();
		for(OrderDeliDto odd : resultList){
			returnList.add(odd);
			if("Y".equals(odd.getIs_add_mst()) ){
				//서브 추가 상품의 주문 정보 조회 
				String[] tmpOin = odd.getOrde_iden_numb().split("-");
				Map<String , Object> tmpMap = new HashMap<String, Object>();
				tmpMap.put("ORDE_IDEN_NUMB", tmpOin[0]);
				tmpMap.put("ORDE_SEQU_NUMB", tmpOin[1]);
				tmpMap = deliveryDao.selectBuyAddProdOrde(tmpMap);
				tmpMap.put("printYn", "Y");
				tmpMap.put("loginUserDto", params.get("loginUserDto"));
				List<OrderDeliDto> subAddProdList = (List<OrderDeliDto>)deliveryDao.selectBuyProdReceiveList(tmpMap);
				// 마스터 상품이 인수되어 조회되었을 경우 해당 마스터 상품의 하위 상품도 조회 하여 리스트에 담는다.
				// 1개가 조회 됨.
				for(OrderDeliDto tmpOdd : subAddProdList){
                    returnList.add(returnList.size(), tmpOdd);
				}
			}
		}
		return returnList;
	}

	public int selectReceiveListCnt(Map<String, Object> params) {
		return (Integer) deliveryDao.selectReceiveListCntNew(params);
	}

	public List<OrderDeliDto> selectReceiveList(Map<String, Object> params, int page, int rows) {
		return (List<OrderDeliDto>)deliveryDao.selectReceiveListNew(params, page, rows);
	}

	
	public void updateVenPurcPrintBtn(Map<String, Object> saveMap) {
		deliveryDao.updateVenPurcPrintBtn(saveMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateInvoInfo(Map<String, Object> saveMap) throws Exception {
		String mstKeyValue = CommonUtils.getString(saveMap.get("mstKeyValue"));
		String modDeliTypeClas = CommonUtils.getString(saveMap.get("modDeliTypeClas"));
		String modInvoNumb = CommonUtils.getString(saveMap.get("modInvoNumb"));
		if("".equals(mstKeyValue)|| "".equals(modDeliTypeClas)|| "".equals(modInvoNumb) ){
			throw new Exception();
		}
		String[] ordArr = mstKeyValue.split("-");
		Map<String, Object> saveParam = new HashMap<String , Object >();
		saveParam.put("orde_iden_numb", ordArr[0]);
		saveParam.put("orde_sequ_numb", ordArr[1]);
		saveParam.put("purc_iden_numb", ordArr[2]);
		saveParam.put("deli_iden_numb", ordArr[3]);
		saveParam.put("modDeliTypeClas", modDeliTypeClas);
		saveParam.put("modInvoNumb", modInvoNumb);

		deliveryDao.updateInvoInfo(saveParam);
	}

	/** 공급사 임시저장 
	 * @throws Exception */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void insertTempDeliSave(Map<String, Object> saveMap) throws Exception {
		String [] orde_iden_numb_array = (String[])saveMap.get("orde_iden_numb_array");
		String [] purc_iden_numb_array = (String[])saveMap.get("purc_iden_numb_array");
		String [] to_do_deli_prod_quan_array = (String[])saveMap.get("to_do_deli_prod_quan_array");
		Map<String, Object> saveParamMap = new HashMap<String, Object>();
		for(int i = 0 ; i < orde_iden_numb_array.length; i++){
			saveParamMap.put("orde_iden_numb", orde_iden_numb_array[i]);
			saveParamMap.put("purc_iden_numb", purc_iden_numb_array[i]);
			// 기존 발주정보 조회
            Map<String, Object> tempPurcInfo = deliveryDao.selectDeliInfoForTempDeliSave(saveParamMap);
            String purcRequQuan = CommonUtils.getString( ((BigDecimal)tempPurcInfo.get("PURC_REQU_QUAN")).intValue() ) ;
            int purcRequQuanInt = Integer.parseInt(purcRequQuan);
            int tempSaveQuanInt = Integer.parseInt(to_do_deli_prod_quan_array[i]);
            // 유효성 체크 :  발주수량 - 분할 수량 <= 0 의 의미는 더이상 나눌 수량이 없음을 의미.
            if((purcRequQuanInt - tempSaveQuanInt) <= 0 ){
            	throw new Exception("임시저장 할 수량을 확인하여 주십시오.");
            }
            Map<String, Object> updateMap = new HashMap<String , Object>();
			updateMap.put("orde_iden_numb", orde_iden_numb_array[i]);
			updateMap.put("purc_iden_numb", purc_iden_numb_array[i]);
			// 기존 발주정보는 발주수량 - 분할수량으로 수정함.
			// 고도화 이후에 배송수량은 0 이거나 발주수량과 같은 데이터만 존재함. 
			updateMap.put("purcRequQuan", (purcRequQuanInt-tempSaveQuanInt));
            // 기존 발주 정보의 수량을 수정함.
            deliveryDao.updateDeliInfoForTempDeliSave(updateMap);
            
            updateMap.clear();// 이후 파라메터 용도로 사용함.
            updateMap.put("orde_iden_numb", orde_iden_numb_array[i].split("-")[0]);
            updateMap.put("orde_sequ_numb", orde_iden_numb_array[i].split("-")[1]);
            Map<String, Object> insertMap = new HashMap<String , Object>();
			insertMap.put("orde_iden_numb", orde_iden_numb_array[i]);
			insertMap.put("purc_iden_numb", purc_iden_numb_array[i]);
			insertMap.put("new_purc_iden_numb", deliveryDao.selectMrpurtKeyValue(updateMap));
			insertMap.put("purcRequQuan", tempSaveQuanInt);
            // 임시저장 할 정보를 insert 함.
            deliveryDao.insertDeliInfoForTempDeliSave(insertMap);
		}
	}
}