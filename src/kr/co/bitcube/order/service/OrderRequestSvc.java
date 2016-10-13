package kr.co.bitcube.order.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.order.dao.OrderRequestDao;
import kr.co.bitcube.order.dto.OrderBorgDto;
import kr.co.bitcube.order.dto.OrderDto;
import kr.co.bitcube.order.dto.OrderHistDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class OrderRequestSvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private OrderRequestDao orderRequestDao;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	@Resource(name="seqMrgoodsvendorHistService")
	private EgovIdGnrService seqMrgoodsvendorHistService;
	
	
	@Resource(name="seqMcProductHistoryService")
	private EgovIdGnrService seqMcProductHistoryService;
	
	@Resource(name="seqMpOrderHistService")
	private EgovIdGnrService seqMpOrderHistService;
	
	/** * 주문요청 리스트의 대상 데이터 갯수 리턴 */
	public int getOrderListCnt(Map<String, Object> params) {
		return (Integer) orderRequestDao.selectOrderListCnt(params);
	}
	/** * 주문요청 리스트의 대상 데이터 리턴 */
	public List<OrderDto> getOrderList(Map<String, Object> params, int page, int rows) {
		return (List<OrderDto>)orderRequestDao.selectOrderList(params, page, rows);
	}

	/** * 주문 요청시 Insert 작업을 수행하는 메소드 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setOrderRequestAdd(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception{
		saveMap.put("regi_user_id",userInfoDto.getUserId());														// 등록자 ID
		
		int arrayCnt = 0;
		
		String[] disp_good_id_array = (String[]) saveMap.get("disp_good_id_array");
		String[] orde_requ_quan_array = (String[]) saveMap.get("orde_requ_quan_array");
		String[] requ_deli_date_array = (String[]) saveMap.get("requ_deli_date_array");
		
		Map<String, Object> paramMap = new HashMap<String,Object>(); 		// 물량 배분 여부 SELECT 할 파라메터 Map
		
		//주문 M 정보 생성
		paramMap.put("branchId", (String)saveMap.get("branchid"));
		OrderBorgDto obd = orderRequestDao.selectOrderBorgs(paramMap); 					// 아래 고객사 관련 정보를 조회한다.
		//물류센터일 경우 clientCd 다시 세팅
		if(userInfoDto.getSvcTypeCd().equals("CEN")){
			saveMap.put("clientCd", "CEN");
		}else{
			saveMap.put("clientCd", obd.getBorgCd());														// 법인코드 (주문번호 생성시 필요)
		}
		saveMap.put("groupid", obd.getGroupId());														// 그룹 Id 
		saveMap.put("clientid", obd.getClientId());														// 법인 Id 
		saveMap.put("orde_iden_numb", this.createOrderSeq(saveMap));							// saveMap value 값들중 clientCd가 꼭 필요함. 
		orderRequestDao.InsertMrordm(saveMap);														// 주문 M 정보 Insert
		
		boolean isApprovalUser = false;
		for(String disp_good_id : disp_good_id_array) {
			// 납품요청일 ( 긴급여부 확인을 위해 필요 : 해당상품의 표준납기일보다 납품요청일이 빠를 시 긴급으로 저장.)
			saveMap.put("requ_deli_date", requ_deli_date_array[arrayCnt]); 
			// 주문 수량 
			String orde_requ_quan = orde_requ_quan_array[arrayCnt];
			saveMap.put("orde_requ_quan", orde_requ_quan); 
			// 진열 SEQ 세팅 : 상품정보, 공급사, 판매단가, 매입단가등을 조회할때 필요로 하는 DATA
			saveMap.put("disp_good_id", disp_good_id);
			// 주문 유형
			String orde_type_clas = (String)saveMap.get("orde_type_clas");
			// 주문 유형이 선발주가 아닌 경우 감독명 삭제
			if(!orde_type_clas.equals("20")){ 
				saveMap.remove("mana_user_name");		// 감독명 삭제
			}
			// 주문 차수 및 발주 차수로 사용. 
			arrayCnt++; 
			
			// 물량배분 상품인지 확인. 
			// ( 물량배분 상품인 경우 :  주문 M, 주문 T 만 데이터 생성. 물량배분 상품이 아닌경우 : 발주의뢰 상태까지 데이터 생성)
			// 주문상품 히스토리 테이블에서 해당 관련 데이터 Insert 하기. (물량배분 Y : 주문요청까지만, 물량배분 N : 발주의뢰 까지 생성)
			paramMap.put("disp_good_id", disp_good_id);
			int isQuanDiv = 0;
			int sale_unit_price = 0;
			int goodClasCode = orderRequestDao.selectGoodClasCode(paramMap);
			
			// 1. 주문유형이 과거주문이 아니고,			2. 주문유형이 수탁발주가 아니고, 		3. 주문한 상품의 상품구분이 지정, 수탁 상품이 아닐경우 (일반 상품을 의미)
			// 물량배분 가능. (1 : 주문요청(물량배분) , 0 : 발주의뢰)
			/** 물량배분 값이 2가 나올경우 자동 물량배분을 실행한다. - 12-02-04 parkjoon */
			if(!orde_type_clas.equals("40") && !orde_type_clas.equals("50") && !orde_type_clas.equals("90") && 30 != goodClasCode){			
				isQuanDiv = orderRequestDao.selectGoodsQuanDiv(paramMap);				// 물량배분 상태 조회
			}
			/** 주문한 고객사의 선입금여부 확인하여 선입금여부 Y 일때(1 일때) 무조건 주문요청 단계까지 진행 :  자동물량배분 (value : 2) 일 경우도 마찬가지로 발주의뢰 하지 않음. - 13-02-04 parkjoon */
			if(!userInfoDto.getSvcTypeCd().equals("CEN") && 1 == orderRequestDao.selectPrePay(paramMap)){			
				isQuanDiv = 1; // 발주의뢰 정보를 생성하지 않는다.
			}
			if(orde_type_clas.equals("50")){ // 과거 상품일 경우 진열 SEQ 테이블에서 매입단가를 조회한다.
				sale_unit_price = orderRequestDao.selectPastOrderSaleUnitPrice(paramMap);
				// 과거상품일 경우 현재 날짜에 +납품 소요일수를 더해서 납품희망일에 저장한다. -- parkjoon 13-03-05
				HashMap<String, String> temp_deli_requ_date_map  = orderRequestDao.selectPastOrderDeliRequDate(paramMap);
				saveMap.remove("requ_deli_date");
				saveMap.put("requ_deli_date",temp_deli_requ_date_map.get("REQU_DELI_DATE")); 
			}else{ // 그외 주문일 경우 상품공급사에서 매입단가를 조회한다.
				sale_unit_price = orderRequestDao.selectOrderSaleUnitPrice(paramMap);
			}
			saveMap.put("sale_unit_price", sale_unit_price);
			
			List<UserDto> supervisorUserInfo = this.getSupervisorUserInfo((String)saveMap.get("branchid"),(String)saveMap.get("orde_user_id"));
			if(userInfoDto.getSvcTypeCd().equals("BUY") && !orde_type_clas.equals("50") && supervisorUserInfo.size() > 0){			
				saveMap.put("directorId", supervisorUserInfo.get(0).getUserId());
				saveMap.remove("mana_user_name");		// 감독명 삭제
				saveMap.put("mana_user_name", supervisorUserInfo.get(0).getUserNm());
				isQuanDiv = 3; // 주문승인 상태로 주문요청상태 정보 Insert.
				isApprovalUser = true;
			}
			// 고객사나 운영사에서 수탁상품에대한 주문요청을 할 경우 재고수량 차감.
			if(!isApprovalUser && !orde_type_clas.equals("90") && 30 == goodClasCode){		
//				saveMap.put("good_hist_id", seqMrgoodsvendorHistService.getNextStringId());			// 상품쪽 SEQ를 가져다가 상품공급사 히스토리에 쓰고 있어서 이대로 쓰다가는 에러가 발생할 가능성이 있어 주석처리
//				saveMap.put("good_hist_id"	, 	seqMcProductHistoryService.getNextIntegerId() 	); // 상품공급사 히스토리 시퀀스 정보를 상품쪽에서는 상품쪽 히스토리를 쓰고 있어 동일하게 맞춤. 
//				int stockQuan = orderRequestDao.selectGoodsStockQuan(paramMap);				
//				saveMap.put("now_stoc_quan", stockQuan - Integer.parseInt(orde_requ_quan)); 
//				orderRequestDao.updateGoodsStockQuan(saveMap);				
//				orderRequestDao.insertMcGoodsVenderHist(saveMap);  수탁상품히스토리 테이블을 사용함에 따라 주석처리
				Map<String,Object> stockMap = orderRequestDao.selectGoodsStockInfo(paramMap);				
				// 상품코드, 공급사코드, 변경전수량, 변경후 수량, 변경타입, 유저ID
				orderCommonSvc.insertMcgoodvendorStockQuan((String)stockMap.get("GOOD_IDEN_NUMB"),(String)stockMap.get("VENDORID"),(int)stockMap.get("BEFORE_QUANTITY"),((int)stockMap.get("BEFORE_QUANTITY") - Integer.parseInt(orde_requ_quan) ) ,"30",userInfoDto.getUserId());										
				orderCommonSvc.updateMcgoodvendorStockQuan((String)stockMap.get("GOOD_IDEN_NUMB"),(String)stockMap.get("VENDORID"),((int)stockMap.get("BEFORE_QUANTITY")  - Integer.parseInt(orde_requ_quan)) );										
			}
			
			if(0 == isQuanDiv){ // 물량 배분 상품이 아닐 경우
				saveMap.put("orde_sequ_numb", ""+arrayCnt);
				saveMap.put("purc_iden_numb", "1"); 					// 물량배분 상품이 아닐경우 발주차수는 1 : 1 이기때문에 1로 하드코딩
				saveMap.put("purc_requ_quan", orde_requ_quan);	// 발주 수량  = 일반 주문일 경우 주문요청수량과 발주수량이 같다.
				
				orderRequestDao.InsertMrordt(saveMap);				// 주문 T 정보 Insert
				orderRequestDao.InsertMrpurt(saveMap);				// 발주 정보 Insert
				
				// 주문요청 관련 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "10", null, (String)saveMap.get("regi_user_id"));
				// 발주의뢰 관련 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, "40", null, (String)saveMap.get("regi_user_id"));
				
			} else if(1 == isQuanDiv){ // 물량 배분 상품 
				saveMap.put("orde_sequ_numb", ""+arrayCnt);
				saveMap.put("purc_requ_quan", "0"); 				// 발주 수량  = 추후 물량 배분시 발주수량을 업데이트 한다.
				
				orderRequestDao.InsertMrordt(saveMap);		// 주문 T 정보 Insert
				
				// 주문요청 관련 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "10", null, (String)saveMap.get("regi_user_id"));
				
			} else if(2 == isQuanDiv){ // 자동 물량배분 상품일 경우
				// 1. 자동물량배분 상품을 공급하는 업체를 조회한다. 조회 정렬 순서는 물량배분 % 가 큰 업체 순.
				List<OrderDto> vendorDivRateList = orderRequestDao.selectGoodsVendorAndDivRate(paramMap);				// 공급사 및 물량배분율 조회
				// 2. 초기화
				Random random = new Random(System.currentTimeMillis());
				Integer[] vendorDivRateQuan = new Integer[vendorDivRateList.size()];
				// 3. 계산
				int divSumValue = 0;
				for(OrderDto tempDd : vendorDivRateList){
					divSumValue += tempDd.getDivRate();
				}
				if(divSumValue == 0){
					// 해당 자동 물량배분 상품의 공급사에 대해서 물량배분율의 합이 0 이라면
					// 첫번째로 조회된 업체에 주문 요청 수량을 분배한다.
					vendorDivRateList.get(0).setDivRate(1);
					divSumValue = 1;
				}
				String temp_orde_quan  = (String)saveMap.get("orde_requ_quan");
				int tmep_orde_requ_quan =  Integer.parseInt(temp_orde_quan);
				for(int i = 0; i < tmep_orde_requ_quan; i++){
					int tempRandomNumber = Math.abs(random.nextInt(divSumValue))%divSumValue;
					int divRate = 0;
					for(int j = 0 ; j < vendorDivRateList.size(); j++){
						OrderDto tempDd = vendorDivRateList.get(j);
						if(divRate <= tempRandomNumber){
							if(tempRandomNumber < divRate+tempDd.getDivRate()){
								if(vendorDivRateQuan[j] == null){
									vendorDivRateQuan[j] = 1;
								}else{
									vendorDivRateQuan[j] += 1;
								}
							}
						}
						divRate += tempDd.getDivRate();
					}
				}
				// 4. Data Insert 수행
				saveMap.put("orde_sequ_numb", ""+arrayCnt);
				saveMap.put("purc_requ_quan", orde_requ_quan);	// 발주 수량  = 일반 주문일 경우 주문요청수량과 발주수량이 같다.
				orderRequestDao.InsertMrordt(saveMap); // 주문 T 정보 Insert
				// 주문요청 관련 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "10", null, (String)saveMap.get("regi_user_id"));
				int tempCnt = 0;
				for(Integer temp : vendorDivRateQuan){
					if(temp != null){
						saveMap.put("purc_iden_numb", ""+orderRequestDao.selectPurchaseNumber(saveMap)); // 물량배분 상품이 아닐경우 발주차수는 1 : 1 이기때문에 1로 하드코딩
						saveMap.put("purc_requ_quan", temp); // 발주 수량
						saveMap.put("vendorid", (String)vendorDivRateList.get(tempCnt).getVendorid()); // 공급사ID
						orderRequestDao.InsertMrpurtAutoDivRate(saveMap); // 발주 정보 Insert
						
						// 5. history 저장.
						// 발주의뢰 관련 히스토리 저장
						orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, "40", null, (String)saveMap.get("regi_user_id"));
					}
					tempCnt++;
				} // for end
			} else if(3 == isQuanDiv){ // 피감독자의 주문요청 : 승인 필요
				saveMap.put("orde_sequ_numb", ""+arrayCnt);
				saveMap.put("purc_requ_quan", "0"); 				// 발주 수량  = 추후 물량 배분시 발주수량을 업데이트 한다.
				
				orderRequestDao.approvalInsertMrordt(saveMap);		// 주문 T 정보 Insert
				
				// 주문요청 관련 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "05", null, (String)saveMap.get("regi_user_id"));
			}
		}
		if(isApprovalUser){ // 승인요청 상태의 주문일 경우 sms/email 발송을 한다.
			try{ commonSvc.exeOrderApprovalRequestSmsEmailByOrderNum((String)saveMap.get("orde_iden_numb")); }
			catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
		}else{ // 그 외
			/*------------------------------메일/SMS 발송 시작---------------------------------*/
			try{ commonSvc.exeOrderRequestSmsEmailByOrderNum((String)saveMap.get("orde_iden_numb")); }
			catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
			/*------------------------------메일/SMS 발송 끝---------------------------------*/
		}
	}
	/**
	 * 주문번호를 생성하여 리턴한다.
	 * <br> Map객체에 clientCd Key값과 알맞은 value Data가 꼭 있어야함.
	 * <br><br><b>
	 * 시행사코드 3자리,<br> 년/월/일 6자리,<br> 시퀀스 '0001' 부터 4 == (총 13자리)
	 * <br><br><br></b>
	 * 시행사코드 3자리 + 날짜 6자리(총 9자리)로 DB 조회하여 0001부터 1씩 증가시켜 리턴한다.
	 */
	private String createOrderSeq(Map<String, Object> saveMap) {
		Calendar c  = Calendar.getInstance();
		String c_year = c.get(Calendar.YEAR) + "";
		c_year = c_year.substring(2,4);
		String clientCd = (String)saveMap.get("clientCd");
		if(clientCd.length() > 3){ // 법인코드의 자리수가 3자리 이상일 경우 앞에서 3자리로 데이터 생성.
			clientCd = clientCd.substring(0,3);
		}
		String result = clientCd + c_year + (c.get(Calendar.MONTH) + 1 < 10 ? "0" + (c.get(Calendar.MONTH) + 1) :  c.get(Calendar.MONTH)+ 1) + (c.get(Calendar.DATE) < 10 ? "0" +c.get(Calendar.DATE) : c.get(Calendar.DATE)) ;
		saveMap.put("orderIdenNumb", result);
		OrderDto orderSeq = orderRequestDao.selectOrderSeq(saveMap);
		if(orderSeq == null){ // 조회 결과가 없을 시 0001로 생성
			result += "0001";
		}else{ // 자리수 조회하여 0 을 붙여줌
			int tempSeq = Integer.parseInt(orderSeq.getOrde_iden_numb().substring(9,orderSeq.getOrde_iden_numb().length()));
			String tempSeqString = ++tempSeq +"";
			if(tempSeqString.length() < 2){
				tempSeqString = "000"+tempSeqString;
			}else if(tempSeqString.length() < 3){
				tempSeqString = "00"+tempSeqString;
			}else if(tempSeqString.length() < 4){
				tempSeqString = "0"+tempSeqString;
			}
			result += tempSeqString;
		}
		return result;
	}

	public List<OrderDto> getOrderGoodsList(Map<String, Object> params) {
		return (List<OrderDto>)orderRequestDao.selectOrderGoodsList(params);
	}
	
	/** * 주문조회 상품 조회 리스트에서 쓸 합계 데이터 */
	public OrderDto getTotalUserData(List<OrderDto> list) {
		OrderDto userDataTotal = new OrderDto();
		if(list.size() > 0){
	    	double sum_total_unit_price = 0; 	// 주문금액 합계
	    	int sum_order_quan = 0; 	// 주문금액 합계
	        for(OrderDto orderDtoTemp:list){
	        	sum_total_unit_price += orderDtoTemp.getTotal_sell_price();
	        	sum_order_quan += Integer.parseInt(orderDtoTemp.getOrde_requ_quan());
	        }
	    	userDataTotal.setTotal_sell_price(sum_total_unit_price);
	    	userDataTotal.setOrde_requ_quan(""+sum_order_quan);
		}
    	return userDataTotal;
	}
	
	/** * 주문 상세정보를 가져온다. */
	public OrderDto getOrderDetail(Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_all").toString().split("-");
		params.clear();
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		OrderDto od = (OrderDto)orderRequestDao.selectOrderDetail(params);
		return od;
	}
	public boolean getIsPurc(OrderDto od) {
		int temp_purc_requ_quan = Integer.parseInt(od.getPurc_requ_quan());
		boolean result = false;
		if(temp_purc_requ_quan > 0){  
			result = true;
		}
		return result;
	}
	public boolean getIsDeli(boolean is_purc, Map<String, Object> params) {
		int cnt = 0;
		boolean result  = false;
		if(is_purc){
			cnt  = orderRequestDao.selectOrderIsDeli(params);
		}
		if(cnt > 0){
			result = true;
		}
		return result;
	}
	/** * 주문 히스토리 조회 */
	public List<OrderHistDto> getOrderHistList(Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_numb").toString().split("-");
		params.remove("orde_iden_numb");
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		return (List<OrderHistDto>) orderRequestDao.selectOrderHistList(params);
	}
	/** * 주문 마스터 공사명, 배송지 주소 변경 */
	/** 주문 마스터 인수자 , 인수자 전화번호 변경*/
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void setOrderRequestUpdate(Map<String, Object> saveMap) throws Exception{
		String[] temp_orde_iden_numb = saveMap.get("orde_iden_numb").toString().split("-");
		saveMap.remove("orde_iden_numb");
		saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
		saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		
		if("".equals((String)saveMap.get("tran_data_addr")) && "".equals((String)saveMap.get("tranUserName")) && "".equals((String)saveMap.get("tranTeleNumb"))){
			orderRequestDao.updateOrderRequestReceive(saveMap);
		}else{
			orderRequestDao.updateOrderRequest(saveMap);
			String flag = "";
			if(!"".equals(saveMap.get("tran_data_addr").toString())){
				flag = "물품 도착지";
			}else if(!"".equals(saveMap.get("tranUserName").toString())){
				flag = "인수자";
			}else if(!"".equals(saveMap.get("tranTeleNumb").toString())){
				flag = "인수자 전화번호";
			}
			String msg="주문번호 "+saveMap.get("orde_iden_numb")+"-"+saveMap.get("orde_sequ_numb")+"의 "+flag+"가 변경 되었으니 OKPlaza에서 반드시 확인 바랍니다.";
			commonSvc.sendRightSms(saveMap.get("phoneNum").toString(), msg);
		}
	}
	/** * 주문 취소  */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setOrderRequestCancel(Map<String, Object> saveMap, LoginUserDto loginUserDto) throws Exception {
		String[] temp_orde_iden_numb = saveMap.get("orde_iden_numb").toString().split("-");
		saveMap.remove("orde_iden_numb");
		saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
		saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		// sms/e-mail 전송
		try{ commonSvc.exeOrderCancelSmsEmailByOrderNum((String)saveMap.get("orde_iden_numb"),(String)saveMap.get("orde_sequ_numb"),(String)saveMap.get("chan_reas_desc")); }
		catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
		// 주문 상품 정보 주문취소 상태로 변경
		orderRequestDao.updateOrderRequestCancel(saveMap);
		// 발주 정보 주문취소 상태로 변경
		orderRequestDao.updateOrderRequestPurtCancel(saveMap);
		
		// 히스토리 테이블에 Insert 작업 하기 위한 데이터 세팅 
		// 주문요청 관련 히스토리 저장
		orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "99", (String)saveMap.get("chan_reas_desc"), loginUserDto.getUserId());
		
		//주문취소시 sms전송
	}
	
	/** * 주문 진척도 팝업 */
	public List<OrderDto> getOrderProgressPopList(Map<String, Object> params) {
		return (List<OrderDto>)orderRequestDao.selectOrderProgressPopList(params);

	}
	
	/** 재고수량 체크 */
	public List<OrderDto> chkStockQuan(String[] disp_good_id_array) {
		int cnt = 0;
		String disp_good_ids = "";
		Map<String, Object> paramMap = new HashMap<String,Object>(); 		// 물량 배분 여부 SELECT 할 파라메터 Map
		for(String temp_disp_good_id : disp_good_id_array){
			if(cnt == 0){
				disp_good_ids += temp_disp_good_id;
			}else{
				disp_good_ids += ","+temp_disp_good_id;
			}
			
			cnt++;
		}
		paramMap.put("disp_good_ids", disp_good_ids);
		return (List<OrderDto>)orderRequestDao.selectForChkStockQuan(paramMap);
	}
	public List<CodesDto> getOrderType(List<CodesDto> codeList) {
		List<CodesDto> returnList = new ArrayList<CodesDto>();
		for(CodesDto temp : codeList){
			if(temp.getCodeVal1().equals("20") ||temp.getCodeVal1().equals("50") ){
				continue;
			}else{
				CodesDto temp1 = new CodesDto();
				temp1.setCodeId(temp.getCodeId());
				temp1.setCodeNm1(temp.getCodeNm1());
				temp1.setCodeVal1(temp.getCodeVal1());
				returnList.add(temp);
			}
		}
		return returnList;
	}
	
	/**
	 * 물류센터에서 주문 요청
	 * @param saveMap
	 * @param userInfoDto
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setCenOrderRequestAdd(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception {
		saveMap.put("regi_user_id",userInfoDto.getUserId());														// 등록자 ID
		
		int arrayCnt = 0;
		String[] orde_requ_quan_array = (String[]) saveMap.get("orde_requ_quan_array");
		String[] requ_deli_date_array = (String[]) saveMap.get("requ_deli_date_array");
		String[] good_iden_numb_array = (String[]) saveMap.get("good_iden_numb_array");
		String[] vendorid_array = (String[]) saveMap.get("vendorid_array");
		
		saveMap.put("clientCd", "CEN");
		saveMap.put("groupid", "0");														// 그룹 Id 
		saveMap.put("clientid", "0");														// 법인 Id 
		saveMap.put("orde_iden_numb", this.createOrderSeq(saveMap));							// saveMap value 값들중 clientCd가 꼭 필요함. 
		orderRequestDao.cenInsertMrordm(saveMap);														// 주문 M 정보 Insert
		for(String good_iden_numb : good_iden_numb_array) {
			// 납품요청일 ( 긴급여부 확인을 위해 필요 : 해당상품의 표준납기일보다 납품요청일이 빠를 시 긴급으로 저장.)
			saveMap.put("requ_deli_date", requ_deli_date_array[arrayCnt]); 
			// 주문 수량 
			String orde_requ_quan = orde_requ_quan_array[arrayCnt];
			saveMap.put("orde_requ_quan", orde_requ_quan); 
			saveMap.put("good_iden_numb", good_iden_numb); 
			saveMap.put("vendorid", vendorid_array[arrayCnt]); 
			
			// 주문 차수 및 발주 차수로 사용. 
			arrayCnt++; 
			int sale_unit_price = 0;
			// 매입단가를 조회하여 매입단가와 판매단가에 사용한다.
			sale_unit_price = orderRequestDao.selectOrderSaleUnitPriceCen(saveMap);
			saveMap.put("sale_unit_price", sale_unit_price);
			saveMap.put("orde_requ_pric", sale_unit_price);
			
			saveMap.put("orde_sequ_numb", ""+arrayCnt);
			saveMap.put("purc_iden_numb", "1"); 					// 물량배분 상품이 아닐경우 발주차수는 1 : 1 이기때문에 1로 하드코딩
			saveMap.put("purc_requ_quan", orde_requ_quan);	// 발주 수량 
			
			orderRequestDao.cenInsertMrordt(saveMap);				// 주문 T 정보 Insert
			orderRequestDao.cenInsertMrpurt(saveMap);				// 발주 정보 Insert
			
			// 주문요청 관련 히스토리 저장
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "10", null, (String)saveMap.get("regi_user_id"));
			// 발주의뢰 관련 히스토리 저장
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, "40", null, (String)saveMap.get("regi_user_id"));
		}
	}
	public Map<String, Integer> getOrderResultSearch(Map<String, Object> params) {
		return (Map<String, Integer>) orderRequestDao.selectOrderResultSearchCnt(params);
	}
	public List<OrderDto> getOrderResultSearch(Map<String, Object> params, int page, int rows) {
		return (List<OrderDto>)orderRequestDao.selectOrderResultSearchList(params, page, rows);
	}
	public List<Map<String, Object>> selectOrderResultSearchListExcel(Map<String, Object> params) {

		return orderRequestDao.selectOrderResultSearchListExcel(params);
	}
	
	public List<UserDto> getSupervisorUserInfo(String branchId, String userId) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("branchId", branchId);
		searchMap.put("userId", userId);
		return orderRequestDao.selectSupervisorUserInfo(searchMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setOrderRequestApproval(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception{
		// 주문승인 구현사항
		// 주문 요청 케이스 구현
		// 주문 히스토리 저장
		String[] orde_iden_numb_array = (String[]) saveMap.get("orde_iden_numb_array");
		for(String orde_iden_numb_temp : orde_iden_numb_array){
			String[] temp_orde_iden_numb = orde_iden_numb_temp.split("-");
			saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
			saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
			OrderDto od = orderRequestDao.selectOrderApprovalInfo(saveMap);
			saveMap.put("regi_user_id",userInfoDto.getUserId());
			// 물량배분 가능. (2: 발주의뢰(자동물량배분) , 1 : 주문요청(수동 물량배분) , 0 : 발주의뢰)
			saveMap.put("disp_good_id", (String)od.getDisp_good_id());
			int isQuanDiv =  0;
			
			Map<String,Object> stockMap = orderRequestDao.selectGoodsStockInfoByOrde(saveMap);
			
			//주문이 과거상품주문이 아니고 상품의 상품공급사 구분이 수탁상품일 경우에
			if(!stockMap.get("ORDE_TYPE_CLAS").toString().equals("50") && !stockMap.get("GOOD_CLAS_CODE").toString().equals("30")){ 
				isQuanDiv =  orderRequestDao.selectGoodsQuanDiv(saveMap);				
			}
			
			if(stockMap.get("GOOD_CLAS_CODE").toString().equals("30")){
				// 상품코드, 공급사코드, 변경전수량, 변경후 수량, 변경타입, 유저ID
				orderCommonSvc.insertMcgoodvendorStockQuan((String)stockMap.get("GOOD_IDEN_NUMB"),(String)stockMap.get("VENDORID"),(int)stockMap.get("BEFORE_QUANTITY"),( (int)stockMap.get("BEFORE_QUANTITY") - (int)stockMap.get("ORDE_REQU_QUAN")) ,"30",userInfoDto.getUserId());										
				orderCommonSvc.updateMcgoodvendorStockQuan((String)stockMap.get("GOOD_IDEN_NUMB"),(String)stockMap.get("VENDORID"),( (int)stockMap.get("BEFORE_QUANTITY") - (int)stockMap.get("ORDE_REQU_QUAN") ));										
			}
			/** 주문한 고객사의 선입금여부 확인하여 선입금여부 Y 일때(1 일때) 무조건 주문요청 단계까지 진행 :  자동물량배분 (value : 2) 일 경우도 마찬가지로 발주의뢰 하지 않음. - 13-02-04 parkjoon */
			saveMap.put("branchId", (String)od.getBranchId());
			if(1 == orderRequestDao.selectPrePay(saveMap)){			
				isQuanDiv = 1; // 발주의뢰 정보를 생성하지 않는다.
			}
			saveMap.put("vendorid", (String)od.getVendorid());
			int sale_unit_price = 0; 
			sale_unit_price = orderRequestDao.selectOrderSaleUnitPrice(saveMap);
			saveMap.put("sale_unit_price", sale_unit_price);
			
			logger.debug("isQuanDiv : " + isQuanDiv);
				
			if(0 == isQuanDiv){ // 물량 배분 상품이 아닐 경우
				saveMap.put("purc_iden_numb", "1"); 					// 물량배분 상품이 아닐경우 발주차수는 1 : 1 이기때문에 1로 하드코딩
				saveMap.put("purc_requ_quan", (String)od.getOrde_requ_quan());	// 발주 수량  = 일반 주문일 경우 주문요청수량과 발주수량이 같다.
				
				orderRequestDao.updateApprovalMrordt(saveMap);				// 주문 T 정보 update : 주문요청 상태로 update 하기. 주문수량 update 하기
				orderRequestDao.InsertMrpurt(saveMap);				// 발주 정보 Insert
				
				// 주문요청 관련 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "10", null, (String)saveMap.get("regi_user_id"));
				// 발주의뢰 관련 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, "40", null, (String)saveMap.get("regi_user_id"));
			} else if(1 == isQuanDiv){ // 물량 배분 상품 
				saveMap.put("purc_requ_quan", 0);	// 물량배분 상품의 발주수량은 0 이다.
				orderRequestDao.updateApprovalMrordt(saveMap);				// 주문 T 정보 update : 주문요청 상태로 update 하기.
				
				// 주문요청 관련 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "10", null, (String)saveMap.get("regi_user_id"));
			} else if(2 == isQuanDiv){ // 자동 물량배분 상품일 경우
				// 1. 자동물량배분 상품을 공급하는 업체를 조회한다. 조회 정렬 순서는 물량배분 % 가 큰 업체 순.
				List<OrderDto> vendorDivRateList = orderRequestDao.selectGoodsVendorAndDivRate(saveMap);				// 공급사 및 물량배분율 조회
				// 2. 초기화
				Random random = new Random(System.currentTimeMillis());
				Integer[] vendorDivRateQuan = new Integer[vendorDivRateList.size()];
				// 3. 계산
				int divSumValue = 0;
				for(OrderDto tempDd : vendorDivRateList){
					divSumValue += tempDd.getDivRate();
				}
				if(divSumValue == 0){
					// 해당 자동 물량배분 상품의 공급사에 대해서 물량배분율의 합이 0 이라면
					// 첫번째로 조회된 업체에 주문 요청 수량을 분배한다.
					vendorDivRateList.get(0).setDivRate(1);
					divSumValue = 1;
				}
				int tmep_orde_requ_quan =  Integer.parseInt((String)od.getOrde_requ_quan());
				for(int i = 0; i < tmep_orde_requ_quan; i++){
					int tempRandomNumber = Math.abs(random.nextInt(divSumValue))%divSumValue;
					int divRate = 0;
					for(int j = 0 ; j < vendorDivRateList.size(); j++){
						OrderDto tempDd = vendorDivRateList.get(j);
						if(divRate <= tempRandomNumber){
							if(tempRandomNumber < divRate+tempDd.getDivRate()){
								if(vendorDivRateQuan[j] == null){
									vendorDivRateQuan[j] = 1;
								}else{
									vendorDivRateQuan[j] += 1;
								}
							}
						}
						divRate += tempDd.getDivRate();
					}
				}
				// 4. Data update 수행
				saveMap.put("purc_requ_quan", (String)od.getOrde_requ_quan());	
				orderRequestDao.updateApprovalMrordt(saveMap); // 주문 T 정보 update
				// 주문요청 관련 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "10", null, (String)saveMap.get("regi_user_id"));
				int tempCnt = 0;
				for(Integer temp : vendorDivRateQuan){
					if(temp != null){
						saveMap.put("purc_iden_numb", ""+orderRequestDao.selectPurchaseNumber(saveMap));
						saveMap.put("purc_requ_quan", temp); // 발주 수량
						saveMap.put("vendorid", (String)vendorDivRateList.get(tempCnt).getVendorid()); // 공급사ID
						saveMap.put("orde_user_id", (String)od.getOrde_user_id()); // 주문 요청자
						orderRequestDao.InsertMrpurtAutoDivRate(saveMap); // 발주 정보 Insert
						orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, "40", null, (String)saveMap.get("regi_user_id"));
					}
					tempCnt++;
				} // for end
			}
		}
		/*------------------------------메일/SMS 발송 시작---------------------------------*/
		try{ commonSvc.exeOrderRequestSmsEmailByOrderNum((String)saveMap.get("orde_iden_numb")); }
		catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
		/*------------------------------메일/SMS 발송 끝---------------------------------*/
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setOrderRequestReject(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception{
		// 주문 반려 구현사항
		// 해당 주문번호, 주문차수로 조회하여 상태를 09 : 주문반려 상태로 Update 진행
		String[] orde_iden_numb_array = (String[]) saveMap.get("orde_iden_numb_array");
		saveMap.put("regi_user_id",userInfoDto.getUserId());
		for(String orde_iden_numb_temp : orde_iden_numb_array){
			String[] temp_orde_iden_numb = orde_iden_numb_temp.split("-");
			saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
			saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
			orderRequestDao.updateRejectMrordt(saveMap); // 주문 T 정보 update
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "09", (String)saveMap.get("reason"), (String)saveMap.get("regi_user_id"));
		}
	}
	public int getOrderGoodsCnt(Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_all").toString().split("-");
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		return (Integer) orderRequestDao.selectOrderGoodsCnt(params);
	}
	public int getVenOrderListProgressCnt(Map<String, Object> params) {
		return (Integer) orderRequestDao.selectVenOrderListProgressCnt(params);
	}
	public List<OrderDto> getVenOrderListProgress(Map<String, Object> params, int page, int rows) {
		return (List<OrderDto>)orderRequestDao.selectVenOrderListProgress(params, page, rows);
	}
	
	/** * 주문조회 엑셀 출력용 데이터 조회*/
	public List<Map<String, Object>> getOrderListExcel( Map<String, Object> params) {
		return orderRequestDao.selectOrderListExcel(params);
	}
	
	public List<Map<String, Object>> getWorkInfoNms(String userId) {
		return orderRequestDao.selectWorkInfoNms(userId);
	}
	public List<UserDto> getUserInfoListByBranchIdInVendorOrderRequest( String borgId) {
		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("borgId", borgId);
		return orderRequestDao.selectUserInfoListByBranchIdInVendorOrderRequest(searchMap);
	}
	public Map<String, Integer> getOrderListIncludeTotalSumCnt( Map<String, Object> params) {
		return (Map<String, Integer>) orderRequestDao.selectOrderListIncludeTotalSumCnt(params); 
	}
	public List<OrderDto> getOrderListIncludeTotalSum( Map<String, Object> params, int page, int rows) {
		return (List<OrderDto>)orderRequestDao.selectOrderListIncludeTotalSum(params, page, rows);
	}
	public List<OrderDto> getOrderListIncludeTotalSum( Map<String, Object> params) {
		return (List<OrderDto>)orderRequestDao.selectOrderListIncludeTotalSum(params);
	}
	/**
	 *  주문최소수량 가져오기
	 * @param disp_good_id
	 * @return
	 */
	public int selectProductMiniQuantity(String disp_good_id) {
		return orderRequestDao.selectProductMiniQuantity(disp_good_id);
	}
	public String orderStatCheck(Map<String, Object> params) {
		String[] ordeIdenNumbArr = params.get("orde_iden_numb_Arr").toString().split("-");
		params.put("orde_iden_numb", ordeIdenNumbArr[0]);
		params.put("orde_sequ_numb", ordeIdenNumbArr[1]);
		return (String)orderRequestDao.orderStatCheck(params);
	}
	
	/**
	 * 주문변경정보 입력
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void insertOrderChageInfo(ModelMap paramMap) throws Exception{
		String ordeHistNumb = seqMpOrderHistService.getNextStringId();
		String[] ordenumb = (String[])paramMap.get("ordeNumb").toString().split("-");
		String msg = "주문번호 ["+paramMap.get("ordeNumb").toString()+"]<br/><b>["+paramMap.get("chanConfDesc").toString()+"]</b> 상태로 변경";
		LoginUserDto loginUserDto = (LoginUserDto)paramMap.get("loginUserDto");
		paramMap.put("ordeHistNumb", ordeHistNumb);
		paramMap.put("ordeIdenNumb", ordenumb[0]);
		paramMap.put("ordeSequNumb", ordenumb[1]);
		paramMap.put("msg", msg);
		paramMap.put("userId", loginUserDto.getUserId());
		generalDao.insertGernal("order.orderRequest.insertOrderChageInfo", paramMap);
	}
	
	/**
	 * 공급사 주문 진척도 리스트 카운트
	 */
	public int getvenOrderProgressListCnt(Map<String, Object> params) throws Exception {
		return orderRequestDao.selectVenOrderProgressListCnt(params);
	}
	
	/** 공급사 주무이력조회 데이터 조회 */
	public int selectVenOrderHistListCnt(Map<String, Object> params) {
		return (Integer) orderRequestDao.selectVenOrderHistListCnt(params);
	}
	/** 공급사 주무이력조회 */
	public List<Map<String, Object>> selectVenOrderHistList( Map<String, Object> params, int page, int rows) {
		return (List<Map<String, Object>>)orderRequestDao.selectVenOrderHistList(params, page, rows);
	}
	
	
	/**
	 * 공급사 주문 진척도 리스트
	 */
	public List<Map<String, Object>> getvenOrderProgressList(Map<String, Object> params, int page, int rows) throws Exception {
		List<Map<String, Object>>	orderProgressList	= new ArrayList<Map<String,Object>>();
		List<Map<String, Object>>	list				= orderRequestDao.selectVenOrderProgressList(params, page, rows);
		for(Map<String, Object> orderProgressMap : list){
			Map<String, Object> deliMap = new HashMap<String, Object>();
			deliMap.put("ordeIdenNumb", orderProgressMap.get("ORDE_IDEN_NUMB"));
			deliMap.put("ordeSequNumb", orderProgressMap.get("ORDE_SEQU_NUMB"));
			deliMap.put("purcIdenNumb", orderProgressMap.get("PURC_IDEN_NUMB"));
			deliMap.put("srcOrderStatusFlag", params.get("srcOrderStatusFlag"));
			List<Map<String, Object>> orderProgressDeliList = orderRequestDao.selectVenOrderProgressDeliList(deliMap);
			int orderProgressDeliListCnt = orderProgressDeliList.size();
			orderProgressMap.put("orderProgressDeliListCnt", orderProgressDeliListCnt);
			if(orderProgressDeliListCnt > 0){
				orderProgressMap.put("orderProgressDeliList", orderProgressDeliList);
			}
			orderProgressList.add(orderProgressMap);
		}
		return orderProgressList;
	}
	
	//===================================== 고도화 =============================================
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setOrderCartInfo(Map<String, Object> params) throws Exception{
		String[] ord_quans 			= (String[])params.get("ord_quans");                 
		String[] vendorids 			= (String[])params.get("vendorids");                 
		String[] good_iden_numbs		= (String[])params.get("good_iden_numbs");           
		String[] orde_requ_prics		= (String[])params.get("orde_requ_prics");           
		String[] sale_unit_prices	= (String[])params.get("sale_unit_prices");           
		String[] requ_deli_dates		= (String[])params.get("requ_deli_dates");           
		String[] add_good_numbs		= (String[])params.get("add_good_numbs");      
		String[] repre_good_numbs	= (String[])params.get("repre_good_numbs");      
		String[] good_specs	= (String[])params.get("good_specs");      
		String branchid				= CommonUtils.getString(params.get("branchid"));  
		
		//주문제한 여부 => Exception 처리 => 주문불가 
		String isOrderLimit = orderRequestDao.getIsOrderLimit(branchid);
		
		if("1".equals(isOrderLimit)){
			throw new Exception("주문제한이 되어 주문을 할 수 없습니다.\n관리자에게 문의바랍니다.");
		}
		
		Map<String, Object> branchStatus = orderRequestDao.getPrepayBranchStatus(branchid);

		boolean isPrepaySms = false;			// 여신제한여부 조회 결과
		String createdOrdeIdenNumb = this.createOrderSeq(params);
		
		//선입금 여부
		String isPrepay = "0";
		String loanYn 	= "N";
		if("1".equals( CommonUtils.getString(branchStatus.get("ISPREPAY")))){
			isPrepay = "1";
			isPrepaySms = true;
		}else{
			//여신제한 여부
			double loan = Double.parseDouble(CommonUtils.nvl(branchStatus.get("LOAN").toString(), "0"));
			double amou = 0;
			if(loan > 0){
                Map<String, Object> amouMap = orderRequestDao.getAmouInfo(branchid);
                amou = Double.parseDouble(CommonUtils.nvl(amouMap.get("AMOU").toString(), "0"));
                if(loan < amou){
                	loanYn = "Y";
                }
			}
		}
		
		//주문 마스터 테이블 Insert
		params.put("prepay"			, isPrepay);							 
		params.put("loan_yn"		, loanYn);							 
		params.put("orde_iden_numb"	, createdOrdeIdenNumb);		
		orderRequestDao.InsertMrordm(params);												
		//주문 상세 테이블 Insert
		for(int i = 0 ; i < good_iden_numbs.length ; i++){
			String add_repre_sequ_numb = "";
			if(!"".equals(add_good_numbs[i]) && !add_good_numbs[i].equals(good_iden_numbs[i]) ){
				add_repre_sequ_numb = i + "";
			}
			params.put("good_iden_numb"			, good_iden_numbs[i]);
			params.put("orde_sequ_numb"			, (i+1) + "");
			params.put("vendorid"				, vendorids[i]);
			params.put("orde_requ_quan"			, ord_quans[i]);
			params.put("orde_requ_pric"			, orde_requ_prics[i]);
			params.put("sale_unit_price"		, sale_unit_prices[i]);		
			params.put("requ_deli_date"			, requ_deli_dates[i]);
			params.put("directorid"				, CommonUtils.getString(params.get("mana_user_id")));
			params.put("add_repre_sequ_numb"	, add_repre_sequ_numb);
			params.put("repre_good_iden_numb"	, repre_good_numbs[i]);     
			params.put("regi_user_id"			, params.get("userid"));	// 등록자
			params.put("orde_user_id"			, params.get("orde_user_id"));	// 주문자
			
			// 승인요청 상태의 주문 생성 : 피감독 사용자일 경우 여기까지 진행 후 마무리
			boolean isApprovalRequestOrder = false;
			String userid = (String)params.get("orde_user_id");
			List<UserDto> supervisorUserInfo = this.getSupervisorUserInfo(branchid,userid);
			if(supervisorUserInfo != null && supervisorUserInfo.size() > 0){			
				isApprovalRequestOrder = true;
				params.put("directorid", supervisorUserInfo.get(0).getUserId());
			}
			params.put("purc_requ_quan", "0");
			params.put("orde_stat_flag", "05");
			Map<String,Object> goodsInfo = orderRequestDao.selectGoodInfoForOrder(params);// good_iden_numb 로 조회 
			params.put("good_name"				, CommonUtils.getString((String)goodsInfo.get("GOOD_NAME")));
			params.put("good_spec"				, "".equals(repre_good_numbs[i]) ? CommonUtils.getString((String)goodsInfo.get("GOOD_SPEC")) : good_specs[i]);
			orderRequestDao.InsertMrordt(params);
			if(isApprovalRequestOrder == false){ // 감독관 사용자 거나 감독관 사용자가 없을경우 아래 진행.
				// 주문요청 상태로 update 
                params.put("orde_stat_flag", "10");
                orderRequestDao.updateMrordtForOrderRequest(params); // 상태만 10으로 수정.
                int isDistributeGoods = Integer.parseInt(CommonUtils.getString((String)goodsInfo.get("ISDISTRIBUTE"))) ;
                // 수동 물량 배분 상품이라도 추가상품에 속한 상품이라면 발주정보를 생성함.
				if( (add_repre_sequ_numb.equals("") == false ||  isDistributeGoods != 1)  && "0".equals(isPrepay) &&  "N".equals(loanYn)){
					// 선입금여부가 "아니오" , 여신초과여부 아니오 일 경우 주문 진행
					params.put("purc_requ_quan", ord_quans[i]);
                    orderRequestDao.updateMrordtForOrderRequest(params); // 발주요청 수량 update

                    // 발주정보 insert : 위 상태에 걸리는 내용이 없다면 여기까지 진행. 일반상품이거나 자동물량배분 상태의 경우도 여기까지 진행 후 주문 마무리.
                    // 추가상품의 구성상품의 경우 자동물량 배분이 걸려있더라도 무시함.
                    if(add_repre_sequ_numb.equals("") == true && isDistributeGoods == 2){
                    	// 자동 물량 배분 상품일경우
                    	Map<String, Object> dispRateMap = orderRequestDao.getDispPastRate(params);
                    	params.put("isDistributeGoodsVendorid", CommonUtils.getString(dispRateMap.get("VENDORID"))); 
                    	// 자동물량배분 상품일 경우 공급사가 변경 될 수 있음. 수정을 함.
                        orderRequestDao.updateMrordtForOrderRequest(params); 
                    }
                    // 그 외 상품
                    params.put("purc_iden_numb", ""+orderRequestDao.selectPurchaseNumber(params));
                    orderRequestDao.InsertMrpurt(params);	
					
					// 발주의뢰 관련 히스토리 저장
					orderCommonSvc.setOrderHist((String)params.get("orde_iden_numb"), (String)params.get("orde_sequ_numb"), (String)params.get("purc_iden_numb"), null, null, "40", null, (String)params.get("regi_user_id"));
				}else{
					// 수동 물량배분이거나 선입금여부가 "예" 거나 여신초과여부 예 일 경우 주문 진행 종료
                    orderCommonSvc.setOrderHist((String)params.get("orde_iden_numb"), (String)params.get("orde_sequ_numb"), null, null, null,"10", null, (String)params.get("regi_user_id"));
				}
			}else{
				// 피감독관 사용자일 경우 히스토리 남기고 끝.
				orderCommonSvc.setOrderHist((String)params.get("orde_iden_numb"), (String)params.get("orde_sequ_numb"), null, null, null,"05", null, (String)params.get("regi_user_id"));
			}
			
			//장바구니에서 상품삭제
			orderRequestDao.deleteCartInfo(params);
		}
        /*------------------------------메일/SMS 발송 시작---------------------------------*/
        try{
            commonSvc.exeNewOrderRequestSmsEmailByOrderNum( createdOrdeIdenNumb); 
        } catch(Exception e) { logger.error("exeOrderRequestSmsEmailByOrderNum Email/Sms Save Error : "+e); }
        /*------------------------------메일/SMS 발송 끝---------------------------------*/
	}
	
	/** 감독관 사용자의 주문승인요청 정보의 승인, 반려 처리 
	 * @throws Exception 
	 * */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void procDirectOrder(Map<String, Object> saveMap) throws  Exception {
		String[] ordeIdenNumb_array = (String[])saveMap.get("ordeIdenNumb_array");
		String flag = (String)saveMap.get("flag");
		String reason = (String)saveMap.get("reason");
		String userId = (String)saveMap.get("userId");
		String branchid = (String)saveMap.get("branchid");
		
		List<String> procTargetOrdList = new ArrayList<String>();
		for(String tempOrdeIdenNumb : ordeIdenNumb_array){
			procTargetOrdList.add(tempOrdeIdenNumb);
		}
		// 주문번호-주문차수로 추가상품 관련 주문인지 조회하여
		// 추가상품 관련 주문일 경우 반려든, 승인이든 같이 처리 되게 ordeIdenNumb_array에 추가함.
		Map<String, Object> addProdOrdMap = new HashMap<String, Object>();
        for(int i =0; i < ordeIdenNumb_array.length ; i++){
            String[] temp_orde_iden_numb = ordeIdenNumb_array[i].toString().split("-");
            addProdOrdMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
            addProdOrdMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
        	Map<String , Object> addProdOrdInfo = orderRequestDao.selectApprovalOrdForAddProd(addProdOrdMap);
        	if(
        		addProdOrdInfo != null // 조회결과가 있고, 
        		&& "".equals(CommonUtils.getString(addProdOrdInfo.get("ORDE_IDEN_NUMB"))) == false  // 조회결과가 빈값이 아니고,
        		&& procTargetOrdList.contains(CommonUtils.getString(addProdOrdInfo.get("ORDE_IDEN_NUMB")).trim().toString()) == false // 기존 처리 대상 주문번호에 중복값이 없다면,
        		){
        		procTargetOrdList.add(CommonUtils.getString(addProdOrdInfo.get("ORDE_IDEN_NUMB")).trim().toString());
        	}
        }
		// 분기처리 : 10 : 승인 , 09 : 반려
        Map<String, Object> procDataMap =  new HashMap<String , Object>();
		if("10".equals(flag)){
			// 승인 시작
			for(int i =0; i < procTargetOrdList.size() ; i++){
                procDataMap.clear();
				String[] temp_orde_iden_numb = procTargetOrdList.get(i).split("-");
				procDataMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
				procDataMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
				procDataMap.put("orde_stat_flag", "10");
				procDataMap.put("purc_requ_quan", "0");
//				procDataMap.put("purc_requ_quan", orderRequestDao.selectDirectOrdApprPurcRequQan(procDataMap).get("ORDE_REQU_QUAN"));
				
				// 유효성 체크 : 상태가 05 가 아니면 처리 불가.
				Map<String , Object> validResultMap = orderRequestDao.selectDirectOrdProcStatValid(procDataMap);
				try{
					if(validResultMap.get("ORDE_STAT_FLAG").toString().trim().equals("05") == false){
						throw new Exception();
					}
				}catch(Exception e){
					throw new Exception("새로고침 후 ["+temp_orde_iden_numb[0]+"-"+temp_orde_iden_numb[1]+"] 주문번호의 상태를 확인해주십시오.");
				}
				

				// mrordt 테이블에 상태를 05->10 으로 수정,  승인일 수정.
				orderRequestDao.updateDirectOrdProc(procDataMap);
				orderCommonSvc.setOrderHist((String)procDataMap.get("orde_iden_numb"), (String)procDataMap.get("orde_sequ_numb"), null, null, null, "10", null, userId);
				
				Map<String, Object> branchStatus = orderRequestDao.getPrepayBranchStatus(branchid);
				//선입금 여부
				String isPrepay = "0";
				String loanYn 	= "N";
				if("1".equals( CommonUtils.getString(branchStatus.get("ISPREPAY")))){
					isPrepay = "1";
				}else{
                    //여신제한 여부
                    double loan = Double.parseDouble(CommonUtils.nvl(branchStatus.get("LOAN").toString(), "0"));
                    double amou = 0;
                    if(loan > 0){
                        Map<String, Object> amouMap = orderRequestDao.getAmouInfo(branchid);
                        amou = Double.parseDouble(CommonUtils.nvl(amouMap.get("AMOU").toString(), "0"));
                        if(loan < amou){
                            loanYn = "Y";
                        }
                    }
				}
				
				Map<String , Object> goodIdenNumbMap = orderRequestDao.selectMrordtInfo(procDataMap);
                Map<String,Object> goodsInfo = orderRequestDao.selectGoodInfoForOrder(goodIdenNumbMap);// good_iden_numb 로 조회 
                int isDistributeGoods = Integer.parseInt(CommonUtils.getString((String)goodsInfo.get("ISDISTRIBUTE"))) ;
                String add_repre_sequ_numb = CommonUtils.getString(goodIdenNumbMap.get("add_repre_sequ_numb")).trim();
				if( (add_repre_sequ_numb.equals("") == false ||  isDistributeGoods != 1)  && "0".equals(isPrepay) &&  "N".equals(loanYn)){
					// 선입금여부가 "아니오" , 여신초과여부 아니오 일 경우 주문 진행
                    procDataMap.put("purc_requ_quan", orderRequestDao.selectDirectOrdApprPurcRequQan(procDataMap).get("ORDE_REQU_QUAN"));
                    procDataMap.put("orde_stat_flag", "10");
                    orderRequestDao.updateMrordtForOrderRequest(procDataMap); // 발주요청 수량 update

                    // 발주정보 insert : 위 상태에 걸리는 내용이 없다면 여기까지 진행. 일반상품이거나 자동물량배분 상태의 경우도 여기까지 진행 후 주문 마무리.
                    if(add_repre_sequ_numb.equals("") == true && isDistributeGoods == 2){
                    	// 자동 물량 배분 상품일경우
                    	Map<String, Object> dispRateMap = orderRequestDao.getDispPastRate(goodIdenNumbMap);
                    	procDataMap.put("isDistributeGoodsVendorid", CommonUtils.getString(dispRateMap.get("VENDORID"))); 
                    	// 자동물량배분 상품일 경우 공급사가 변경 될 수 있음. 수정을 함.
                        orderRequestDao.updateMrordtForOrderRequest(procDataMap); 
                    }
                    // 그 외 상품
                    procDataMap.put("purc_iden_numb", ""+orderRequestDao.selectPurchaseNumber(procDataMap));
                    orderRequestDao.InsertMrpurt(procDataMap);	
					
					// 발주의뢰 관련 히스토리 저장
					orderCommonSvc.setOrderHist((String)procDataMap.get("orde_iden_numb"), (String)procDataMap.get("orde_sequ_numb"), (String)procDataMap.get("purc_iden_numb"), null, null, "40", null, userId);
                    /*------------------------------메일/SMS 발송 시작---------------------------------*/
                    try{
                        commonSvc.exePurcRequestSmsEmailByOrderNum( (String)procDataMap.get("orde_iden_numb"), (String)procDataMap.get("orde_sequ_numb"), (String)procDataMap.get("purc_iden_numb")); }
                    catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
                    /*------------------------------메일/SMS 발송 끝---------------------------------*/
				}
			}
		}else if("09".equals(flag)){
			// 반려 시작
			for(int i =0; i < procTargetOrdList.size() ; i++){
                procDataMap.clear();
				String[] temp_orde_iden_numb = procTargetOrdList.get(i).split("-");
				procDataMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
				procDataMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
				procDataMap.put("orde_stat_flag", "09");
				
				// 유효성 체크 : 상태가 05 가 아니면 처리 불가.
				Map<String , Object> validResultMap = orderRequestDao.selectDirectOrdProcStatValid(procDataMap);
				try{
					if(validResultMap.get("ORDE_STAT_FLAG").toString().trim().equals("05") == false){
						throw new Exception();
					}
				}catch(Exception e){
					throw new Exception("새로고침 후 ["+temp_orde_iden_numb[0]+"-"+temp_orde_iden_numb[1]+"] 주문번호의 상태를 확인해주십시오.");
				}
				
				// mrordt 테이블에 상태를 05->09 으로 수정,  승인일 수정.
				orderRequestDao.updateDirectOrdProc(procDataMap);
				orderCommonSvc.setOrderHist((String)procDataMap.get("orde_iden_numb"), (String)procDataMap.get("orde_sequ_numb"), null, null, null, "09", reason, userId);
			}
		}
	}
	
	
	/** 주문승인 조회 count */
	public int selectAppovalProcListCnt(Map<String, Object> params) {
		return (Integer) orderRequestDao.selectAppovalProcListCnt(params);
	}
	/** 주문승인 조회 내용 조회
	 * @param rows 
	 * @param page */
	public List<Map<String, Object>> selectAppovalProcList(Map<String, Object> params, int page, int rows) {
		return (List<Map<String, Object>>)orderRequestDao.selectAppovalProcList(params, page, rows);
	}
	
	/**
	 * 관리자 실적 조회 특정 칼럼의 콤마를 처리하는 메소드
	 * 
	 * @param listInfo
	 * @param key
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> orderResultSearchJQGridAdmListComma(Map<String, String> listInfo, String key) throws Exception{
		String value = listInfo.get(key);
		
		value = CommonUtils.nvl(value);
		
		if("".equals(value) == false){
			value = CommonUtils.getDecimalAmount(value);
		}
		
		listInfo.put(key, value);
		
		return listInfo;
	}
	
	/**
	 * 관리자 실적 조회 리스트를 수정하는 메소드
	 * 
	 * @param list
	 * @return List
	 * @throws Exception
	 */
	private List<Map<String, String>> orderResultSearchJQGridAdmList(List<Map<String, String>> list) throws Exception{
		Map<String, String> listInfo = null;
		int                 listSize = 0;
		int                 i        = 0;
		
		if(list != null){
			listSize = list.size();
		}
		
		for(i = 0; i < listSize; i++){
			listInfo = list.get(i);
			listInfo = this.orderResultSearchJQGridAdmListComma(listInfo, "quantity");
			listInfo = this.orderResultSearchJQGridAdmListComma(listInfo, "ordeRequPrice");
			listInfo = this.orderResultSearchJQGridAdmListComma(listInfo, "saleUnitPric");
			listInfo = this.orderResultSearchJQGridAdmListComma(listInfo, "receIdenQuan");
			listInfo = this.orderResultSearchJQGridAdmListComma(listInfo, "deliIdenQuan");
			listInfo = this.orderResultSearchJQGridAdmListComma(listInfo, "purcIdenQuan");
			listInfo = this.orderResultSearchJQGridAdmListComma(listInfo, "totalOrdeRequPric");
			listInfo = this.orderResultSearchJQGridAdmListComma(listInfo, "totalOrdeUnitPric");
		}
			
		return list;
	}
	
	/**
	 * <pre>
	 * 관리자 실적관리 리스트를 조회하여 반환하는 메소드
	 * 
	 * ~. modelMap 구조
	 *   !. srcOrderNumber (String, 주문번호)
	 *   !. srcGroupId (String, 그룹아이디)
	 *   !. srcClientId (String, 법인아이디)
	 *   !. srcBranchId (String, 고객사아이디)
	 *   !. srcVendorId (String, 공급사아이디)
	 *   !. srcGoodsName (String, 상품명)
	 *   !. srcGoodsId (String, 상품코드)
	 *   !. srcOrderStatusFlag (String, 주문상태)
	 *   !. srcGoodRegYear (String, 상품실적년도)
	 *   !. srcWorkInfoTop (String, 사업유형)
	 *   !. srcOrderDateFlag (String, 날짜 조회 조건)
	 *   !. srcOrderStartDate (String, 날짜 검색 시작일)
	 *   !. srcOrderEndDate (String, 날짜 검색 종료일)
	 *   !. srcWorkInfoUser (String, 공사 담당자)
	 *   !. srcWorkNm (String, 공사유형)
	 *   !. srcGoodClasCode (String, 상품구분)
	 *   !. srcProductManager (String, 상품담당자)
	 *   !. srcIsClosSaleDate (String, 매출계산서 발행여부)
	 *   !. page (String, 조회 페이지 번호)
	 *   !. rows (String, 조회 페이지 로우 수)
	 *   !. sidx (String, 정렬 칼럼 명)
	 *   !. sord (String, 정렬 방식)
	 *   
	 * ~. 결과 Map 형식
	 *   !. page (String, 그리드 조회페이지)
	 *   !. total (int, 페이지 카운트 수)
	 *   !. records (int, 총 카운트 수)
	 *   !. list (List, 페이지 데이터)
	 * </pre>
	 * 
	 * @param modelMap
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> orderResultSearchJQGridAdm(ModelMap modelMap) throws Exception{
		Map<String, Object>       result   = new HashMap<String, Object>();
		Map<String, Object>       gridInfo = null;
		List<Map<String, String>> list     = null;
		String                    page     = (String)modelMap.get("page");
		String                    rows     = (String)modelMap.get("rows");
		Integer                   record   = null;
		Integer                   pageMax  = null;
		
		page = CommonUtils.nvl(page, "1");
		rows = CommonUtils.nvl(rows, "30");
		
		modelMap.put("page", page);
		modelMap.put("rows", rows);
		
		gridInfo = this.commonSvc.getJqGridList("order.orderRequest.orderResultSearchJQGridAdmCount", "order.orderRequest.orderResultSearchJQGridAdmList", modelMap);
		list     = (List<Map<String, String>>)gridInfo.get("list");
		record   = (Integer)gridInfo.get("record");
		pageMax  = (Integer)gridInfo.get("pageMax");
		list     = this.orderResultSearchJQGridAdmList(list);
		
		result.put("page",    page);
		result.put("total",   pageMax);
		result.put("records", record);
		result.put("list",    list);
		
		return result;
	}
	
	
	/** 역주문 시 branchid 로 나머지 정보 조회 */
	public Map<String, Object> selectBuyBorgInfo(String branchid) {
		return orderRequestDao.selectBuyBorgInfo(branchid);
	}
	
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setOrderRequestCancelIncludeAddProd(Map<String, Object> saveMap, LoginUserDto loginUserDto) throws Exception {
		// 추가상품에 대한 유효성 체크는 앞단에서 실행하고 이 메소드가 실행되어야 함.
		String[] temp_orde_iden_numb = saveMap.get("orde_iden_numb").toString().split("-");
		saveMap.remove("orde_iden_numb");
		saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);
		saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		Map<String, Object> addProdInfo = orderRequestDao.selectCancelAddProdInfo(saveMap);
		boolean is_add_proc = false;
		if( addProdInfo != null 
			&& "".equals(CommonUtils.getString((String)addProdInfo.get("ADD_ORDE_IDEN_NUMB"))) == false	
			&& "".equals(CommonUtils.getString((String)addProdInfo.get("ADD_ORDE_SEQU_NUMB"))) == false	
		){
			// 추가상품 주문번호, 주문차수 값이 "" 값이 아니라는것은 관련 주문 상품이 존재한다는것을 의미.
			is_add_proc = true;
		}
		// sms/e-mail 전송
		try{ 
			commonSvc.exeOrderCancelSmsEmailByOrderNum((String)saveMap.get("orde_iden_numb"),(String)saveMap.get("orde_sequ_numb"),(String)saveMap.get("chan_reas_desc")); 
			if(is_add_proc){
				commonSvc.exeOrderCancelSmsEmailByOrderNum(CommonUtils.getString((String)addProdInfo.get("ADD_ORDE_IDEN_NUMB")),CommonUtils.getString((String)addProdInfo.get("ADD_ORDE_SEQU_NUMB")),(String)saveMap.get("chan_reas_desc")); 
			}
		} catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
		// 주문 상품 정보 주문취소 상태로 변경
		orderRequestDao.updateOrderRequestCancel(saveMap);
		// 발주 정보 주문취소 상태로 변경
		orderRequestDao.updateOrderRequestPurtCancel(saveMap);
		// 히스토리 테이블에 Insert 작업 하기 위한 데이터 세팅 
		// 주문요청 관련 히스토리 저장
		orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "99", (String)saveMap.get("chan_reas_desc"), loginUserDto.getUserId());
		
		if(is_add_proc){
			addProdInfo.put("orde_iden_numb", CommonUtils.getString((String)addProdInfo.get("ADD_ORDE_IDEN_NUMB")));
			addProdInfo.put("orde_sequ_numb", CommonUtils.getString((String)addProdInfo.get("ADD_ORDE_SEQU_NUMB")));
			// 주문 상품 정보 주문취소 상태로 변경
			orderRequestDao.updateOrderRequestCancel(addProdInfo);
			// 발주 정보 주문취소 상태로 변경
			orderRequestDao.updateOrderRequestPurtCancel(addProdInfo);
			// 히스토리 테이블에 Insert 작업 하기 위한 데이터 세팅 
			// 주문요청 관련 히스토리 저장
			orderCommonSvc.setOrderHist((String)addProdInfo.get("orde_iden_numb"), (String)addProdInfo.get("orde_sequ_numb"), null, null, null, "99", (String)saveMap.get("chan_reas_desc"), loginUserDto.getUserId());
		}
//		try{
//			//주문취소시 sms전송
//			List<Map<String, Object>> orderCancelUserList = orderRequestDao.selectOrderCancelUser(saveMap);
//			if(orderCancelUserList.size() > 0){
//				for(Map<String, Object> obj : orderCancelUserList){
//					String smsMessage = "주문번호 : "+saveMap.get("orde_iden_numb").toString()+"-"+saveMap.get("orde_sequ_numb").toString()+" 의 주문취소 요청이 있습니다.";
//					commonSvc.sendRightSms(obj.get("MOBILE").toString(), smsMessage);
//				}
//			}
//		}catch(Exception e){
//			logger.error("SMS(exeOrderRequestSmsEmail new) Save error : "+e);
//		}
	}
	
	/** 실적조회 카운트 */
	public Map<String, Integer> selectOrderResultSearchJQGridAdmCnt( ModelMap modelMap) {
		String srcOrderStatusFlag = "".equals((String)modelMap.get("srcOrderStatusFlag")) ? "0" : (String)modelMap.get("srcOrderStatusFlag");
		String srcOrderDateFlag = "".equals((String) modelMap.get("srcOrderDateFlag")) ? "0" : (String)modelMap.get("srcOrderDateFlag");
		// 조회조건에 따라서 카운팅 쿼리 분기 처리. ( 수량합계, 금액합계 부분)
		if(Integer.parseInt(srcOrderStatusFlag) >= 70 || Integer.parseInt(srcOrderDateFlag) >= 4) {
			modelMap.put("searchKind", "A1");
		} else {
			modelMap.put("searchKind", "A2");
		}
		return (Map<String, Integer>) orderRequestDao.selectOrderResultSearchJQGridAdmCnt(modelMap);
	}
	/** 실적조회 리스트  */
	public List<Map<String, Object>> selectOrderResultSearchJQGridAdmList( ModelMap modelMap, String page, String rows) {
		return (List<Map<String, Object>>) orderRequestDao.selectOrderResultSearchJQGridAdmList(modelMap);
	}
	
	
	
	//		주문진척도 수정
	public int selectVODListCnt(Map<String, Object> params) {
		return (Integer) orderRequestDao.selectVODListCnt(params);
	}
	public List<Map<String, Object>> selectVODList(Map<String, Object> params, int page, int rows) {
		List<Map<String, Object>> returnList 	= new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultList 	= orderRequestDao.selectVODList(params, page, rows);
        Map<String, Object> mstMap 			= null;
		List<Map<String, Object>> tempList 	= null;
		List<String> compareList 					= new ArrayList<String>();
		
		for(Map<String, Object> result :  resultList){
			if(compareList.contains(CommonUtils.getString(result.get("ORDE_IDEN_NUMB")).trim() )){
				continue;
			}else{
				compareList.add(CommonUtils.getString(result.get("ORDE_IDEN_NUMB")).trim() );
				mstMap = new HashMap<String, Object>();
				tempList = new ArrayList<Map<String, Object>>();
				for(Map<String, Object> resultTmp :  resultList){
					if(CommonUtils.getString(result.get("ORDE_IDEN_NUMB")).trim().equals(CommonUtils.getString(resultTmp.get("ORDE_IDEN_NUMB")).trim()) ){
						tempList.add(resultTmp);
					}
				}
				mstMap.put("subList", tempList);
				returnList.add(mstMap);
			}
				
		}
		return returnList;
	}
	
	/**
	 * <pre>
	 * 선입금 / 수발주 관리 리스트를 조회하여 반환하는 메소드
	 * 
	 * ~. return map 구조
	 *   !. page            (String, 조회할 페이지)
	 *   !. rows            (String, 페이지당 조회 건수)
	 *   !. sidx            (String, 정렬할 칼럼명)
	 *   !. sord            (String, 정렬조건)
	 *   !. orderStartDate  (String, 주문시작일)
	 *   !. orderEndDate    (String, 주문종료일)
	 *   !. orderStatusFlag (String, 주문상태)
	 *   !. prePayType      (String, 유형)
	 *   !. srcWorkInfoUser (String, 공사담당자)
	 *   !. srcGroupId      (String, 구매자 그룹정보)
	 *   !. srcClientId     (String, 구매사 법인정보)
	 *   !. srcBranchId     (String, 구매사 사업장 정보)
	 * </pre>
	 * 
	 * @param param
	 * @return Map
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getAdmPrePayList(ModelMap param) throws Exception{
		Map<String, Object> result         = new HashMap<String, Object>();
		Map<String, Object> listMap        = null;
		Map<String, String> sumMap         = null;
		List<?>             list           = null;
		Integer             pageMax        = null;
		Integer             record         = null;
		String              page           = (String)param.get("page");
		String              sidx           = (String)param.get("sidx");
		String              sord           = (String)param.get("sord");
		String              orderString    = null;
		String              ordeRequQuan   = null;
		String              totalSellPrice = null;
		StringBuffer        stringBuffer   = new StringBuffer();
		
		stringBuffer.append(" ");
		stringBuffer.append(sidx);
		stringBuffer.append(" ");
		stringBuffer.append(sord);
		stringBuffer.append(" ");
		
		orderString = stringBuffer.toString();
		
		param.put("orderString", orderString);
		
		sumMap = (Map<String, String>)this.generalDao.selectGernalObject("selectAdmPrePayList_sum", param);
		
		if(sumMap != null){
			ordeRequQuan   = sumMap.get("ordeRequQuan");
			totalSellPrice = sumMap.get("totalSellPrice");
		}
		
		ordeRequQuan   = CommonUtils.nvl(ordeRequQuan,   "0");
		totalSellPrice = CommonUtils.nvl(totalSellPrice, "0");
		ordeRequQuan   = CommonUtils.getDecimalAmount(ordeRequQuan);
		totalSellPrice = CommonUtils.getDecimalAmount(totalSellPrice);
		
		listMap = this.commonSvc.getJqGridList("order.orderRequest.selectAdmPrePayList_count", "order.orderRequest.selectAdmPrePayList", param);
		list    = (List<?>)listMap.get("list");
		pageMax = (Integer)listMap.get("pageMax");
		record  = (Integer)listMap.get("record");
		
		result.put("page",            page);
		result.put("total",           pageMax);
		result.put("records",         record);
		result.put("list",            list);
		result.put("ordeRequQuan",    ordeRequQuan);
		result.put("totalSellPrice",  totalSellPrice);
		
		return result;
	}
}