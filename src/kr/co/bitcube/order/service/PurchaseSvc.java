package kr.co.bitcube.order.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.order.dao.OrderRequestDao;
import kr.co.bitcube.order.dao.PurchaseDao;
import kr.co.bitcube.order.dto.OrderDto;
import kr.co.bitcube.order.dto.OrderPurtDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class PurchaseSvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private PurchaseDao purchaseDao;
	
	@Autowired
	private OrderCommonSvc orderCommonSvc;
	
	@Autowired
	private OrderRequestDao orderRequestDao;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Autowired
	private GeneralDao generalDao;
	
	@Resource(name="seqMrpurtCancel")
	private EgovIdGnrService seqMrpurtCancel;
	
	public List<OrderPurtDto> getPurchaseForDivOrder(Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_numb").toString().split("-");
		params.remove("orde_iden_numb");
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		HashMap<String , String> vendorIdMap =(HashMap<String , String>)purchaseDao.selectDivVendorId(params);
		String divVendorId = vendorIdMap.get("VENDORID");
		List<OrderPurtDto> returnDivList  = new ArrayList<OrderPurtDto>();
		List<OrderPurtDto> tempDivList  = (List<OrderPurtDto>)purchaseDao.selectPurchaseForDivOrder(params);
		for(OrderPurtDto opd : tempDivList){
			if(divVendorId.equals(opd.getVendorid())){
				OrderPurtDto tempOpd = new OrderPurtDto();
				tempOpd.setVendorname(opd.getVendorname());
				tempOpd.setOrde_requ_quan(opd.getOrde_requ_quan());
				tempOpd.setOrde_requ_pric(opd.getOrde_requ_pric());
				tempOpd.setSale_unit_pric(opd.getSale_unit_pric());
				tempOpd.setVendorid(opd.getVendorid());
				tempOpd.setPurc_price_year_str(opd.getPurc_price_year_str());
				tempOpd.setPurc_price_month_str(opd.getPurc_price_year_str());
				tempOpd.setPurc_year_price(opd.getPurc_year_price());
				returnDivList.add(tempOpd);
			}
		}
		for(OrderPurtDto opd : tempDivList){
			if(!divVendorId.equals(opd.getVendorid())){
				OrderPurtDto tempOpd = new OrderPurtDto();
				tempOpd.setVendorname(opd.getVendorname());
				tempOpd.setOrde_requ_quan(opd.getOrde_requ_quan());
				tempOpd.setOrde_requ_pric(opd.getOrde_requ_pric());
				tempOpd.setSale_unit_pric(opd.getSale_unit_pric());
				tempOpd.setVendorid(opd.getVendorid());
				tempOpd.setPurc_price_year_str(opd.getPurc_price_year_str());
				tempOpd.setPurc_price_month_str(opd.getPurc_price_year_str());
				tempOpd.setPurc_year_price(opd.getPurc_year_price());
				returnDivList.add(tempOpd);
			}
		}
		return returnDivList;
	}
	
	public List<OrderPurtDto> getOrderDetailPurchaseList( Map<String, Object> params) {
		String[] temp_orde_iden_numb = params.get("orde_iden_numb").toString().split("-");
		params.remove("orde_iden_numb");
		params.put("orde_iden_numb",temp_orde_iden_numb[0]);
		params.put("orde_sequ_numb",temp_orde_iden_numb[1]);
		return (List<OrderPurtDto>)purchaseDao.selectOrderDetailPurchaseList(params);
	}

	/** * 물량배분 상품의 발주의뢰 시 호출되는 메소드 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public CustomResponse getOrderDivPurcAdd(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception {
		String[] temp_orde_iden_numb = saveMap.get("orde_iden_numb").toString().split("-");
		saveMap.remove("orde_iden_numb");
		saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);									// 주문번호
		saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);									// 주문차수
		saveMap.put("clin_user_id",userInfoDto.getUserId());											// 발주의뢰자 ID
		String[] vendorid_array= (String[]) saveMap.get("vendorid_array");							// 공급사 배열
		String[] orde_requ_quan_array= (String[]) saveMap.get("orde_requ_quan_array");		// 발주요청수량
		String[] orde_requ_pric_array= (String[]) saveMap.get("orde_requ_pric_array");			// 판매단가
		String[] sale_unit_pric_array= (String[]) saveMap.get("sale_unit_pric_array");				// 매입단가
		int arrayCnt = 0;
		int purc_sequ_numb = (Integer)purchaseDao.selectPurchaseNumber(saveMap); // 발주차수 조회  
		int temp_purc_quan = 0;	// 물량배분된 수량들의 총 합 : 주문 요청 테이블 업데이트시 필요.
		String lastVendorId = "";
		CustomResponse custResponse = new CustomResponse(true); 
		for(String vendorid : vendorid_array) {
			lastVendorId = vendorid;
			saveMap.put("purc_iden_numb",purc_sequ_numb+"");		// 발주차수
			saveMap.put("vendorid", vendorid); 
			saveMap.put("purc_requ_quan", orde_requ_quan_array[arrayCnt]); 
			saveMap.put("orde_requ_pric", orde_requ_pric_array[arrayCnt]); 
			saveMap.put("sale_unit_pric", sale_unit_pric_array[arrayCnt]);
			custResponse = commonSvc.getAllocationStatus(saveMap);

			if(custResponse.getSuccess()){
				temp_purc_quan += Integer.parseInt(orde_requ_quan_array[arrayCnt]);
				// 1. mrpurt 테이블에 insert : 발주의뢰자가 넣은 수량 및 기타 데이터
				purchaseDao.insertMrpurt(saveMap);
			
				// 2. 히스토리 테이블에 해당 내역 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, "40", null, userInfoDto.getUserId());
				
				// 3. sms/email 전송
				/*------------------------------메일/SMS 발송 시작---------------------------------*/
				try{
					commonSvc.exePurcRequestSmsEmailByOrderNum((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"),(String)saveMap.get("purc_iden_numb")); }
				catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
				/*------------------------------메일/SMS 발송 끝---------------------------------*/
			
				// 4. 중복 가능성 부분은 삭제.
				saveMap.remove("purc_iden_numb");
				saveMap.remove("vendorid");
				saveMap.remove("purc_requ_quan");
				saveMap.remove("orde_requ_pric");
				saveMap.remove("sale_unit_pric");
				arrayCnt++;
				purc_sequ_numb++;
			}else{
				return custResponse;
			}
		}
		if(0 < temp_purc_quan){
			int purc_quan = (Integer)purchaseDao.selectMrordtPurcQuan(saveMap); // 발주수량 조회
			purc_quan += temp_purc_quan;
			saveMap.put("purc_requ_quan", purc_quan); 
			// 3. mrordt 테이블에 update : 주문요청 테이블의 발주수량 
			purchaseDao.updateMrordt(saveMap);
			saveMap.put("lastVendorId", lastVendorId); 
			purchaseDao.updateMrordtVendorId(saveMap);
		}
		return custResponse;
	}

	/** * 발주 정보 상태 변경 
	 * @return */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String getOrderPurtUpdate(Map<String, Object> saveMap, LoginUserDto userInfoDto) throws Exception {
		String rtnMsg = "";
		// parameter setting
		String[] temp_orde_iden_numb = saveMap.get("orde_iden_numb").toString().split("-");
		saveMap.remove("orde_iden_numb");
		saveMap.put("orde_iden_numb",temp_orde_iden_numb[0]);									// 주문번호
		saveMap.put("orde_sequ_numb",temp_orde_iden_numb[1]);									// 주문차수
		rtnMsg =  this.addProdChk(temp_orde_iden_numb[0],temp_orde_iden_numb[1],  (String)saveMap.get("purc_stat_flag"));
        // 추가상품 관련 유효성 체크가 없어야 계속 진행.
        if("".equals(rtnMsg) ){
        	if(saveMap.get("purc_stat_flag").equals("10")){ 
        		// 주문요청상태로 변경
        		// A. 주문번호, 주문차수, 발주차수로 조회된 data 의 발주수량 조회.
        		int mrpurt_purc_quan = (Integer)purchaseDao.selectPurcQuan(saveMap);
        		int purc_quan = (Integer)purchaseDao.selectMrordtPurcQuan(saveMap); // 발주수량 조회
        		purc_quan -= mrpurt_purc_quan;
        		saveMap.put("purc_requ_quan", purc_quan); 
        		// 3. mrordt 테이블에 update : 주문요청 테이블의 발주수량 
        		purchaseDao.updateMrordt(saveMap);
        		// B. 주문번호, 주문차수, 발주차수로 조회된 data 삭제.
        		purchaseDao.deleteMrpurt(saveMap);
        		// C. mrordt의 주문번호, 주문차수로 매칭되는 데이터의 발주수량 - A 에서 조회된 발주수량.
        		purchaseDao.updateMrordt(saveMap);
        		// D. 히스토리 저장
        		orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), null, null, null, "10", (String)saveMap.get("chan_reas_desc"), userInfoDto.getUserId());
        	}else{ // 주문내역 테이블의 상태값 변경.
        		purchaseDao.updateMrpurt(saveMap);
        		//발주의뢰 중지, 발주접수 중지시 SMS전송
        		if("91".equals(saveMap.get("purc_stat_flag").toString())){
        			Map<String, Object> mrpurtSmsInfo = purchaseDao.selectMrpurtSmsInfo(saveMap);
					/* 정연백 과장님 요청으로 SMS 내용변경 20160701 by kkbum2000 */
        			String msg = "[Okplaza] 주문번호["+saveMap.get("orde_iden_numb").toString()+"-"+saveMap.get("orde_sequ_numb").toString()+"] 주문의뢰가 중지 되었습니다.";
        			commonSvc.sendRightSms(mrpurtSmsInfo.get("ordeTeleNumb").toString(), msg, mrpurtSmsInfo.get("phoneNum").toString());
        		}else if("92".equals(saveMap.get("purc_stat_flag").toString())){//발주접수 중지시 SMS전송
        			Map<String, Object> mrpurtSmsInfo = purchaseDao.selectMrpurtSmsInfo(saveMap);
					/* 정연백 과장님 요청으로 SMS 내용변경 20160701 by kkbum2000 */
        			String msg = "[Okplaza] 주문번호["+saveMap.get("orde_iden_numb").toString()+"-"+saveMap.get("orde_sequ_numb").toString()+"] 주문접수가 중지 되었습니다.";
        			commonSvc.sendRightSms(mrpurtSmsInfo.get("ordeTeleNumb").toString(), msg, mrpurtSmsInfo.get("phoneNum").toString());
        		}
        		// 히스토리 저장
        		orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, (String)saveMap.get("purc_stat_flag"), (String)saveMap.get("chan_reas_desc"), userInfoDto.getUserId());
        	}
        }
		return rtnMsg;
	}

	
	public int getPurchaseListCnt(Map<String, Object> params) {
		return purchaseDao.selectPurchaseListCnt(params);	
	}
	public List<OrderPurtDto> getPurchaseList(Map<String, Object> params, int page, int rows) {
		return purchaseDao.selectPurchaseList(params, page, rows);	
	}

	/** * 발주접수 처리 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updatePurcReceiveStatus(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		String[] orde_iden_numb_array = (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array = (String[]) saveMap.get("purc_iden_numb_array");
		String[] deli_sche_date_array = (String[]) saveMap.get("deli_sche_date_array");
		int cnt = 0;
		String [] orderNumFullArray = new String[orde_iden_numb_array.length];	//mail,sms발송을 위해
		
		/*-------------주문상태값 세팅------------*/
		Map<String, Object> params = new HashMap<String, Object>();
		OrderDto orderDetailInfo = new OrderDto();
		
		for(String orde_iden_numb: orde_iden_numb_array) {
			orderNumFullArray[cnt] = orde_iden_numb + "-" + purc_iden_numb_array[cnt];
			String[] temp_iden_numb = orde_iden_numb.split("-");
			saveMap.put("orde_iden_numb",temp_iden_numb[0]);
			saveMap.put("orde_sequ_numb",temp_iden_numb[1]);
			saveMap.put("purc_iden_numb", purc_iden_numb_array[cnt]);
			saveMap.put("purc_stat_flag", "50");
			saveMap.put("regi_user_id", attribute.getUserId()); // regi_user_id 가 있으면 Update시 반영
			saveMap.put("purcReceiveGetDate", 1); // 1은 의미없는 값. 키가 있다는것이 중요. mybatis 에서 분기처리 용도
			saveMap.put("deli_sche_date", deli_sche_date_array[cnt]);
			params.put("orde_iden_numb",temp_iden_numb[0]);
			params.put("orde_sequ_numb",temp_iden_numb[1]);
			params.put("purc_iden_numb", purc_iden_numb_array[cnt]);
			orderDetailInfo = purchaseDao.orderStatCheck(params);
			if("40".equals(orderDetailInfo.getPurc_stat_flag())){
				
				purchaseDao.updateMrpurt(saveMap);
				// 히스토리 저장
				orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, (String)saveMap.get("purc_stat_flag"), null, (String)saveMap.get("regi_user_id"));
				saveMap.remove("orde_iden_numb");
				saveMap.remove("orde_sequ_numb");
				saveMap.remove("purc_iden_numb");
				saveMap.remove("orde_hist_numb");
				cnt++;
			}
		}
		
		/*------------------------------메일/SMS(주문자) 발송 시작---------------------------------*/
		try{ 
			commonSvc.exeOrderReceiveDeliverySmsEmailByOrderNum(orderNumFullArray, "50"); 
		}catch(Exception e) {
			logger.error("Email/Sms Save Error : "+e); 
		}
		/*------------------------------메일/SMS(주문자) 발송 끝---------------------------------*/
	}

	/** * 발주거부 처리 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updatePurcRejectStatus(Map<String, Object> saveMap, LoginUserDto attribute) throws Exception {
		// 발주거부시 발주 정보를 삭제하고, 주문상품 테이블의 발주수량을 0 으로 업데이트 한다.  : 주문요청 상태로 변경
		// 발주거부했다는 히스토리를 저장한다.
		String[] orde_iden_numb_array= (String[]) saveMap.get("orde_iden_numb_array");
		String[] purc_iden_numb_array= (String[]) saveMap.get("purc_iden_numb_array");
		String[] vendorNm_array = (String[])saveMap.get("vendorNm_array"); 
		String[] vendorPhonenum_array = (String[])saveMap.get("vendorPhonenum_array");
		String[] orderUserMobile_array = (String[])saveMap.get("orderUserMobile_array");
		
		int cnt = 0;
		for(String orde_iden_numb: orde_iden_numb_array) {
			String[] temp_iden_numb = orde_iden_numb.split("-");
			saveMap.put("orde_iden_numb",temp_iden_numb[0]);
			saveMap.put("orde_sequ_numb",temp_iden_numb[1]);
			saveMap.put("purc_iden_numb", purc_iden_numb_array[cnt]);
			int mrpurt_purc_quan = (Integer)purchaseDao.selectPurcQuan(saveMap);
			int purc_quan = (Integer)purchaseDao.selectMrordtPurcQuan(saveMap); // 발주수량 조회
			purc_quan -= mrpurt_purc_quan;
			saveMap.put("purc_requ_quan", purc_quan); 
			purchaseDao.updateMrordt(saveMap);
			purchaseDao.deleteMrpurt(saveMap);
			
			//발주거부시 sms전송
			commonSvc.sendRightSms(orderUserMobile_array[cnt],"공급사 ["+vendorNm_array[cnt]+"] 에서 주문 접수 거부 하였습니다.",vendorPhonenum_array[cnt]);
			
			// 히스토리 저장
			String reason = (String)saveMap.get("chan_reas_desc")+"<br>["+attribute.getBorgNm()+"] ["+attribute.getUserNm()+"] 사용자가 [주문접수거부] 처리함.";
			orderCommonSvc.setOrderHist((String)saveMap.get("orde_iden_numb"), (String)saveMap.get("orde_sequ_numb"), (String)saveMap.get("purc_iden_numb"), null, null, "10", reason, attribute.getUserId());
			saveMap.remove("orde_iden_numb");
			saveMap.remove("orde_sequ_numb");
			saveMap.remove("purc_iden_numb");
			saveMap.remove("orde_hist_numb");
			cnt++;
		}
	}

	public int getPurchasePrintListCnt(Map<String, Object> params) {
		return purchaseDao.selectPurchasePrintListCnt(params);	
	}

	public List<OrderPurtDto> getPurchasePrintList(Map<String, Object> params, int page, int rows) {
		return purchaseDao.selectPurchasePrintList(params, page, rows);	
	}

	public Map<String, Object> getPurchasetResultListCnt(Map<String, Object> params) {
		return purchaseDao.selectPurchasetResultListCnt(params);	
	}

	public List<OrderPurtDto> getPurchaseResultListData( Map<String, Object> params, int page, int rows) {
		return purchaseDao.selectPurchaseResultList(params, page, rows);	
	}

	public List<OrderPurtDto> getPurchaseResultListDataForPop( Map<String, Object> params) {
		return purchaseDao.selectPurchaseResultListForPop(params);	
	}
	
	public List<Map<String, Object>> getPurchaseResultListDataExcelView( Map<String, Object> params) {
		return (List<Map<String, Object>>)purchaseDao.selectPurchaseResultListExcelView(params);	
	}
	
	public List<Map<String, Object>> getPurchasePrintListExcelView(Map<String, Object> params) {
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
		return (List<Map<String, Object>>)purchaseDao.selectPurchasePrintListExcelView(params);	
	}

	public List<OrderDto> orderStatCheck(Map<String, Object> params) {
		String[] orde_iden_numb_array = (String[]) params.get("orde_iden_numb_array");
		String[] purc_iden_numb_array = (String[]) params.get("purc_iden_numb_array");
		int cnt = 0;
		OrderDto orderFlag = new OrderDto();
		List<OrderDto> orderFlagList = new ArrayList<OrderDto>();
		for(String orde_iden_numb : orde_iden_numb_array){
			String[] str = orde_iden_numb.split("-");
			String[] tmp = purc_iden_numb_array;
			params.put("orde_iden_numb", str[0]);
			params.put("orde_sequ_numb", str[1]);
			params.put("purc_iden_numb", tmp[cnt]);
			orderFlagList.add(orderFlag = (OrderDto) purchaseDao.orderStatCheck(params));
			cnt++;
		}
		return orderFlagList;
	}

	
	/**
	 * 선입금 주문 주문의뢰 상태로 변경
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void prePayPurcReceive(Map<String, Object> saveMap) throws Exception {
		String[] ordeIdenNumbArray = (String[])saveMap.get("orde_iden_numb_array");
		String[] ordeSequNumbArray = (String[])saveMap.get("orde_sequ_numb_array");
		String userId = CommonUtils.getString(saveMap.get("userId")) ;
		
		List<String> procTargetOrdList = new ArrayList<String>();
		for(int i = 0 ; i < ordeIdenNumbArray.length; i ++){
			procTargetOrdList.add(ordeIdenNumbArray[i] +"-" +ordeSequNumbArray[i]);
		}
		// 주문번호-주문차수로 추가상품 관련 주문인지 조회하여
		// 추가상품 관련 주문일 경우 반려든, 승인이든 같이 처리 되게 ordeIdenNumb_array에 추가함.
		Map<String, Object> addProdOrdMap = new HashMap<String, Object>();
        for(int i =0; i < ordeIdenNumbArray.length ; i++){
            addProdOrdMap.put("orde_iden_numb",ordeIdenNumbArray[i]);
            addProdOrdMap.put("orde_sequ_numb",ordeSequNumbArray[i]);
        	Map<String , Object> addProdOrdInfo = purchaseDao.selectPrePayForAddProd(addProdOrdMap);
        	if(
        		addProdOrdInfo != null // 조회결과가 있고, 
        		&& "".equals(CommonUtils.getString(addProdOrdInfo.get("ORDE_IDEN_NUMB"))) == false  // 조회결과가 빈값이 아니고,
        		&& procTargetOrdList.contains(CommonUtils.getString(addProdOrdInfo.get("ORDE_IDEN_NUMB")).trim().toString()) == false // 기존 처리 대상 주문번호에 중복값이 없다면,
        		){
        		procTargetOrdList.add(CommonUtils.getString(addProdOrdInfo.get("ORDE_IDEN_NUMB")).trim().toString());
        	}
        }
        
        Map<String, Object> paramsMap = new HashMap<String, Object>();
        for(String procTargetOrd : procTargetOrdList){
        	paramsMap.clear();
			String[] temp_orde_iden_numb = procTargetOrd.split("-");
        	paramsMap.put("userId", userId);
        	paramsMap.put("orde_iden_numb", temp_orde_iden_numb[0]);
        	paramsMap.put("orde_sequ_numb", temp_orde_iden_numb[1]);
			String	prePayOrderStatus	= purchaseDao.selectPrePayOrderStatus(paramsMap);
			if("10".equals(prePayOrderStatus)){
				int		purc_sequ_numb		= (Integer)purchaseDao.selectPurchaseNumber(paramsMap); // 발주차수 조회
				paramsMap.put("purc_iden_numb",purc_sequ_numb+""); // 발주차수
				purchaseDao.updatePrePayMrordt(paramsMap);
				purchaseDao.insertPrePayMrpurt(paramsMap);
				
				//히스토리 테이블
				orderCommonSvc.setOrderHist((String)paramsMap.get("orde_iden_numb"), (String)paramsMap.get("orde_sequ_numb"), (String)paramsMap.get("purc_iden_numb"), null, null, "40", null, (String)paramsMap.get("userId"));
				
				//sms/email 전송
				/*------------------------------메일/SMS 발송 시작---------------------------------*/
				try{
					commonSvc.exePurcRequestSmsEmailByOrderNum((String)paramsMap.get("orde_iden_numb"), (String)paramsMap.get("orde_sequ_numb"),(String)paramsMap.get("purc_iden_numb")); }
				catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
				/*------------------------------메일/SMS 발송 끝---------------------------------*/
			}
        }
	}

	/**
	 * 공급사 주문접수 카운트
	 */
	public int getVenOrderPurchaseCnt(Map<String, Object> params) throws Exception{
		return purchaseDao.selectVenOrderPurchaseCnt(params);
	}

	/**
	 * 공급사 주문접수 리스트
	 */
	public List<Map<String, Object>> getVenOrderPurchaseList(Map<String, Object> params,int pIdx, int pCnt) throws Exception{
		return purchaseDao.selectVenOrderPurchaseList(params, pIdx, pCnt);
	}
	
	/**
	 * 주문상태를 한번 더 조회함.
	 */
	private String selectOrdPurcStatus(String ordeIdenNumb, String ordeSequNumb, String purcIdenNumb) throws Exception{
		String              result  = null;
		Map<String, Object> saveMap = new HashMap<String, Object>();
		
		saveMap.put("ordeIdenNumb", ordeIdenNumb);
		saveMap.put("ordeSequNumb", ordeSequNumb);
		saveMap.put("purcIdenNumb", purcIdenNumb);
		
		result = this.purchaseDao.selectOrdPurcStatus(saveMap);
		
		return result;
	}
	
	/**
	 * <pre>
	 * 주문접수 DB 저장
	 * 
	 * param map 구조
	 *   !. ordeIdenNumb
	 *   !. ordeSequNumb
	 *   !. purcIdenNumb
	 *   !. userId
	 *   !. deliScheDate
	 * </pre>
	 * 
	 * @param param
	 * @throws Exception
	 */
	private void updateOrdPurcReceiveDb(Map<String, String> param) throws Exception{
		Map<String, Object> daoParam         = new HashMap<String, Object>();
		Map<String, Object> addProdSearchMap = null;
		String              ordeIdenNumb     = param.get("ordeIdenNumb");
		String              ordeSequNumb     = param.get("ordeSequNumb");
		String              purcIdenNumb     = param.get("purcIdenNumb");
		String              userId           = param.get("userId");
		String              deliScheDate     = param.get("deliScheDate");
		
		daoParam.put("ordeIdenNumb", ordeIdenNumb);
		daoParam.put("ordeSequNumb", ordeSequNumb);
		
		addProdSearchMap = this.purchaseDao.selectAddProdSearchForPurc(daoParam); // 추가상품 여부 조회하여 발주정보 수정 시 반영.
		
		if(addProdSearchMap != null){ // null 이 아니면 추가상품을 의미.
			daoParam.put("ADD_RECEIVE_YN", "N");
		}
		
		daoParam.put("userId",       userId);
		daoParam.put("deliScheDate", deliScheDate);
		daoParam.put("purcIdenNumb", purcIdenNumb);
		
		this.purchaseDao.updateOrdPurcReceive(daoParam);
		this.orderCommonSvc.setOrderHist(ordeIdenNumb, ordeSequNumb, purcIdenNumb, null, null, "50", null, userId); // 히스토리 저장
	}
	
	/**
	 * 주문 번호를 모두 더한 문자열을 반환하는 메소드
	 * 
	 * @param ordeIdenNumb
	 * @param ordeSequNumb
	 * @param purcIdenNumb
	 * @return getOrderNumFull
	 * @throws Exception
	 */
	private String getOrderNumFull(String ordeIdenNumb, String ordeSequNumb, String purcIdenNumb) throws Exception{
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append(ordeIdenNumb);
		stringBuffer.append("-");
		stringBuffer.append(ordeSequNumb);
		stringBuffer.append("-");
		stringBuffer.append(purcIdenNumb);
		return stringBuffer.toString();
	}
	
	/**
	 * 발주시 인수자에게 SMS 발송하는 메소드
	 * 
	 * @param smsParam
	 * @throws Exception
	 */
	private void updateOrdPurcReceiveSms(List<Map<String, String>> smsParam) throws Exception{
		Map<String, String> smsInfo      = null;
		ModelMap            modelMap     = new ModelMap();
		OrderDto            orderDto     = null;
		String              ordeIdenNumb = null;
		String              ordeSequNumb = null;
		String              tranTeleNumb = null;
		String              smsSendMsg   = null;
		String              deliScheDate = null;
		String              vendorNm     = null;
		String              ordeIdenNumb2 = null;
		String              goodIdenName = null;
		String              phonenum = null;
		StringBuffer        stringBuffer = null;
		int                 smsParamSize = CommonUtils.getListSize(smsParam);
		int                 i            = 0;
		
		for(i = 0; i < smsParamSize; i++){
			stringBuffer = new StringBuffer();
			
			smsInfo      = smsParam.get(i);
			ordeIdenNumb = smsInfo.get("ordeIdenNumb");
			ordeSequNumb = smsInfo.get("ordeSequNumb");
			deliScheDate = smsInfo.get("deliScheDate");
			
			modelMap.clear();
			modelMap.put("orde_iden_numb", ordeIdenNumb);
			modelMap.put("orde_sequ_numb", ordeSequNumb);
			
			orderDto     = (OrderDto)this.generalDao.selectGernalObject("order.orderRequest.selectOrderDetail", modelMap);
			tranTeleNumb = orderDto.getTran_tele_numb();
			vendorNm     = orderDto.getVendornm();
			ordeIdenNumb2 = orderDto.getOrde_iden_numb();
			goodIdenName = orderDto.getGood_iden_name();
			phonenum = orderDto.getPhonenum();
			
			/* 정연백과장님 요청사항으로 SMS 변경 20160625 by kkbum2000
			 * [Okplaza] ['공급사']에서 ['주문번호'-'주문차수'], [00 상품]에 대하여  O월 O일에 납품 예정입니다. 
             * '공급사' 공급사 '공급사전화번호'
			 */
			stringBuffer.append("[Okplaza] [");
			stringBuffer.append(vendorNm);
			stringBuffer.append("]에서 [");
			stringBuffer.append(ordeIdenNumb2);
			stringBuffer.append("], [");
			stringBuffer.append(goodIdenName);
			stringBuffer.append(" 상품]에 대하여 ");
			stringBuffer.append(deliScheDate);
			stringBuffer.append("에 납품 예정입니다.");
			stringBuffer.append(vendorNm);
			stringBuffer.append(" 공급사 ");
			stringBuffer.append(phonenum);
			
			smsSendMsg = stringBuffer.toString();
			
			this.commonSvc.sendRightSms(tranTeleNumb, smsSendMsg, phonenum); //유지보수 454번 요청사항
		}
	}

	/**
	 * 주문접수 (주문의뢰 -> 주문접수)
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateOrdPurcReceive(Map<String, Object> saveMap) throws Exception{
		String[]                  ordeIdenNumbArr       = (String[])saveMap.get("ordeIdenNumb_Array");
		String[]                  ordeSequNumbArr       = (String[])saveMap.get("ordeSequNumb_Array");
		String[]                  purcIdenNumbArr       = (String[])saveMap.get("purcIdenNumb_Array");
		String[]                  deliScheDateArray     = (String[])saveMap.get("deliScheDate_Array");
		String[]                  orderNumFullArray     = null;
		String                    userId                = (String)saveMap.get("userId");
		String                    ordPurcStatus         = null;
		String                    ordeIdenNumb          = null;
		String                    ordeSequNumb          = null;
		String                    purcIdenNumb          = null;
		String                    deliScheDate          = null;
		String                    orderNumFull          = null;
		Map<String, String>       dbParam               = null;
		List<Map<String, String>> smsParam              = new ArrayList <Map<String, String>>();
		int                       mailCnt               = 0;
		int                       ordeIdenNumbArrLength = 0;
		int                       i                     = 0;
		
		if(ordeIdenNumbArr != null){
			ordeIdenNumbArrLength = ordeIdenNumbArr.length;
		}
		
		orderNumFullArray = new String[ordeIdenNumbArrLength];
		
		for(i = 0; i < ordeIdenNumbArrLength; i++){
			ordeIdenNumb               = ordeIdenNumbArr[i];
			ordeSequNumb               = ordeSequNumbArr[i];
			purcIdenNumb               = purcIdenNumbArr[i];
			deliScheDate               = deliScheDateArray[i];
			orderNumFull               = this.getOrderNumFull(ordeIdenNumb, ordeSequNumb, purcIdenNumb); // 주문 번호를 모두 더한 문자열을 반환
			orderNumFullArray[mailCnt] = orderNumFull;
			ordPurcStatus              = this.selectOrdPurcStatus(ordeIdenNumb, ordeSequNumb, purcIdenNumb); 
			
			if("40".equals(ordPurcStatus)){
				dbParam = new HashMap<String, String>();
				
				dbParam.put("ordeIdenNumb", ordeIdenNumb);
				dbParam.put("ordeSequNumb", ordeSequNumb);
				dbParam.put("purcIdenNumb", purcIdenNumb);
				dbParam.put("userId",       userId);
				dbParam.put("deliScheDate", deliScheDate);
				
				this.updateOrdPurcReceiveDb(dbParam); // DB 저장
				
				smsParam.add(dbParam);
				
				mailCnt++;
			}
		}
		
		try{ 
			// 주문자
			/* 정연백 과장님 요청으로 주문접수 SMS 미발송 처리 20160625 by kkbum2000 */
//			this.commonSvc.exeOrderReceiveDeliverySmsEmailByOrderNum(orderNumFullArray, "50"); // 메일/SMS(주문자) 발송
			this.updateOrdPurcReceiveSms(smsParam); // 발주시 인수자에게 SMS 발송
		}
		catch(Exception e) {
			logger.error("Email/Sms Save Error : " + CommonUtils.getExceptionStackTrace(e)); 
		}
	}

	/**
	 * 주문거부 (주문의뢰 -> 주문요청)
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateOrdPurcReceiveReject(Map<String, Object> saveMap) throws Exception{
		String[] ordeIdenNumbArr	= (String[])saveMap.get("ordeIdenNumb_Array");
		String[] ordeSequNumbArr	= (String[])saveMap.get("ordeSequNumb_Array");
		String[] purcIdenNumbArr	= (String[])saveMap.get("purcIdenNumb_Array");
		String[] chanReasDescArr	= (String[])saveMap.get("chanReasDesc_Array");
		for(int i=0; i<ordeIdenNumbArr.length; i++){
			saveMap.put("ordeIdenNumb", ordeIdenNumbArr[i]);
			saveMap.put("ordeSequNumb", ordeSequNumbArr[i]);
			saveMap.put("purcIdenNumb", purcIdenNumbArr[i]);
			saveMap.put("chanReasDesc", chanReasDescArr[i]);
			String ordPurcStatus = purchaseDao.selectOrdPurcStatus(saveMap);
			if("40".equals(ordPurcStatus)){
				//발주거부 관련 sms정보
				Map<String, Object> smsInfo = purchaseDao.selectOrdPurcReceiveRejectSmsInfo(saveMap);
				String orderUserMobile	= (String)smsInfo.get("ORDER_USER_MOBILE");
				String vendorNm			= (String)smsInfo.get("VENDOR_NM");
				
				purchaseDao.updateMrordtPurcRequQuan(saveMap);
				purchaseDao.deleteOrdPurcReceive(saveMap);
				
				//발주거부시 주문자에세 sms전송
				commonSvc.sendRightSms(orderUserMobile, "공급사 ["+vendorNm+"] 에서 주문 접수 거부 하였습니다.", Constances.ETC_MOBILE_SENDERNUM);

				// 히스토리 저장
				String chanReasDesc	= (String)saveMap.get("chanReasDesc");	//사유
				String borgNm		= (String)saveMap.get("borgNm");		
				String userNm		= (String)saveMap.get("userNm");		
				
				String reason = chanReasDesc+"<br>["+borgNm+"] ["+userNm+"] 사용자가 [주문접수거부] 처리함.";
				orderCommonSvc.setOrderHist((String)saveMap.get("ordeIdenNumb"), (String)saveMap.get("ordeSequNumb"), (String)saveMap.get("purcIdenNumb"), null, null, "10", reason, (String)saveMap.get("userId"));
				saveMap.remove("ordeIdenNumb");
				saveMap.remove("ordeSequNumb");
				saveMap.remove("purcIdenNumb");
				saveMap.remove("orde_hist_numb");
			}
		}
	}

	/**
	 * 공급사 발주서 리스트 카운트
	 */
	public int getVenpurchaseListPrintCnt(Map<String, Object> params) throws Exception{
		return purchaseDao.selectVenpurchaseListPrintCnt(params);
	}

	/**
	 * 공급사 발주서 리스트
	 */
	public List<Map<String, Object>> getVenpurchaseListPrint(Map<String, Object> params, int page, int rows) throws Exception{
		return purchaseDao.selectVenpurchaseListPrint(params, page, rows);
	}

	
	
//	/** 발주접수취소요청 처리 화면 리스트 */
//	public int selectVenOrdPurcCancProcListCnt(Map<String, Object> params) {
//		return purchaseDao.selectVenOrdPurcCancProcListCnt(params);
//	}
//
//	/** 발주접수취소요청 처리 화면 리스트 */
//	public List<Map<String, Object>> selectVenOrdPurcCancProcList( Map<String, Object> params, int page, int rows) {
//		return purchaseDao.selectVenOrdPurcCancProcList(params, page, rows);
//	}
//
//	/** 발주접수취소요청 처리 
//	 * @throws Exception */
//	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
//	public void purcCancProc(Map<String, Object> saveMap) throws Exception {
//		String[] cancelId_Array = (String[])saveMap.get("cancelId_Array");
//		String flag = (String)saveMap.get("flag");
//		String reason = (String)saveMap.get("reason");
//		String userId = (String)saveMap.get("userId");
//		Map<String, Object> tranMap = new HashMap<String, Object>();
//		if("1".equals(flag)){ // 발주접수 취소 시작
//			for(String cancelId : cancelId_Array){
//				tranMap.clear();
//				tranMap.put("flag", flag);
//				tranMap.put("userId", userId);
//				tranMap.put("srcCancelId", cancelId);
//				// mrpurt_cancel 주문취소요청 승인 정보 update
//				purchaseDao.updatePurcCancProc(tranMap);
//				Map<String, Object> ordResultMap = purchaseDao.selectOrdInfoByPurcCancId(tranMap);
//				tranMap.put("ORDE_IDEN_NUMB", ordResultMap.get("ORDE_IDEN_NUMB"));
//				tranMap.put("ORDE_SEQU_NUMB", ordResultMap.get("ORDE_SEQU_NUMB"));
//				tranMap.put("PURC_IDEN_NUMB", ordResultMap.get("PURC_IDEN_NUMB"));
//				// mrordt 에 주문취소로 update
//				purchaseDao.updatePurcCancProcMrordt(tranMap);
//				// mrpurt 에 주문취소로 update
//				tranMap.put("purcStatFlag", "99");
//				purchaseDao.updatePurcCancProcMrpurt(tranMap);
//				// 주문 히스토리에 insert
//                orderCommonSvc.setOrderHist( (String)ordResultMap.get("ORDE_IDEN_NUMB"), (String)ordResultMap.get("ORDE_SEQU_NUMB"), (String)ordResultMap.get("PURC_IDEN_NUMB"), null, null, "99", "취소요청 승인으로 인한 상태변경.", userId);
//			}
//		}else if("9".equals(flag)){ // 발주접수 취소 반려 시작.
//			for(String cancelId : cancelId_Array){
//				tranMap.clear();
//				tranMap.put("srcCancelId", cancelId);
//				tranMap.put("flag", flag);
//				tranMap.put("userId", userId);
//				tranMap.put("reason", reason);
//				// mrpurt_cancel 주문취소요청 반려 정보 update
//				purchaseDao.updatePurcCancProc(tranMap);
//				Map<String, Object> ordResultMap = purchaseDao.selectOrdInfoByPurcCancId(tranMap);
//				tranMap.put("ORDE_IDEN_NUMB", ordResultMap.get("ORDE_IDEN_NUMB"));
//				tranMap.put("ORDE_SEQU_NUMB", ordResultMap.get("ORDE_SEQU_NUMB"));
//				tranMap.put("PURC_IDEN_NUMB", ordResultMap.get("PURC_IDEN_NUMB"));
//				// mrpurt 를 다시 발주접수 상태로 변경.
//				tranMap.put("purcStatFlag", "50");
//				purchaseDao.updatePurcCancProcMrpurt(tranMap);
//				// 주문 히스토리에 insert
//                orderCommonSvc.setOrderHist( (String)ordResultMap.get("ORDE_IDEN_NUMB"), (String)ordResultMap.get("ORDE_SEQU_NUMB"), (String)ordResultMap.get("PURC_IDEN_NUMB"), null, null, "50", reason, userId);
//			}
//		}
//	}

	/** 고객사의 주문취소 요청 처리 * @throws Exception */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void purcCancStart(Map<String, Object> saveMap) throws Exception  {
		// 발주접수 테이블에 해당 주문 정보의 상태를 59 로 수정.
		saveMap.put("purc_stat_flag", "59");
        purchaseDao.updatePurcCancProcMrpurt(saveMap);
		// 발주접수 취소 테이블에 주문정보 insert 
		saveMap.put("seqMrpurtCancel", seqMrpurtCancel.getNextStringId());
		purchaseDao.insertPurcCancStartMrpurtCanc(saveMap);
		// 주문 히스토리 저장.
		orderCommonSvc.setOrderHist( (String)saveMap.get("ORDE_IDEN_NUMB"), (String)saveMap.get("ORDE_SEQU_NUMB"), (String)saveMap.get("PURC_IDEN_NUMB"), null, null, "59", (String)saveMap.get("reason"), (String)saveMap.get("userId"));
		
		// 공급사 사용자에게 sms/e-mail 전송
		try{ 
			commonSvc.exeOrderCancelRequestSmsByOrderInfo((String)saveMap.get("ORDE_IDEN_NUMB"),(String)saveMap.get("ORDE_SEQU_NUMB"),(String)saveMap.get("PURC_IDEN_NUMB")); 
		} catch(Exception e) { logger.error("Email/Sms Save Error : "+e); }
	}

	/** 공급사 진척도 조회에서 주문취소요청건 정보 조회 */
	public Map<String, Object> venSelectCancReqInfo(Map<String, Object> params) {
        return purchaseDao.venSelectCancReqInfo(params);
	}

	/** 주문취소요청 단건처리 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void purcCancProcOne(Map<String, Object> saveMap) throws Exception {
		String cancelId = (String)saveMap.get("cancelId");
		String flag = (String)saveMap.get("flag");
		String reason = (String)saveMap.get("reason");
		String userId = (String)saveMap.get("userId");
		Map<String, Object> tranMap = new HashMap<String, Object>();
		if("1".equals(flag)){ // 발주접수 취소 시작
			tranMap.put("srcCancelId", cancelId);
			tranMap.put("flag", flag);
			tranMap.put("userId", userId);
			tranMap.put("reason", reason);
			// mrpurt_cancel 주문취소요청 승인 정보 update
			purchaseDao.updatePurcCancProc(tranMap);
			Map<String, Object> ordResultMap = purchaseDao.selectOrdInfoByPurcCancId(tranMap);
			tranMap.put("ORDE_IDEN_NUMB", ordResultMap.get("ORDE_IDEN_NUMB"));
			tranMap.put("ORDE_SEQU_NUMB", ordResultMap.get("ORDE_SEQU_NUMB"));
			tranMap.put("PURC_IDEN_NUMB", ordResultMap.get("PURC_IDEN_NUMB"));
			
			// mrordt 에 주문취소로 update
			purchaseDao.updatePurcCancProcMrordt(tranMap);
			// mrpurt 에 주문취소로 update
			tranMap.put("purc_stat_flag", "99");
			purchaseDao.updatePurcCancProcMrpurt(tranMap);
			// 주문 히스토리에 insert
			reason = "".equals(reason.trim()) ? "[<b>취소승인</b>]으로 인한 주문취소." : reason+"<br/>[<b>취소승인</b>]으로 인한 주문취소." ;
            orderCommonSvc.setOrderHist( (String)ordResultMap.get("ORDE_IDEN_NUMB"), (String)ordResultMap.get("ORDE_SEQU_NUMB"), (String)ordResultMap.get("PURC_IDEN_NUMB"), null, null, "99", reason, userId);
		}else if("9".equals(flag)){ // 발주접수 취소 반려 시작.
			if("".equals(reason.trim())){ throw new Exception("처리 사유는 필수값."); }
			tranMap.clear();
			tranMap.put("srcCancelId", cancelId);
			tranMap.put("flag", flag);
			tranMap.put("userId", userId);
			tranMap.put("reason", reason);
			// mrpurt_cancel 주문취소요청 반려 정보 update
			purchaseDao.updatePurcCancProc(tranMap);
			Map<String, Object> ordResultMap = purchaseDao.selectOrdInfoByPurcCancId(tranMap);
			tranMap.put("ORDE_IDEN_NUMB", ordResultMap.get("ORDE_IDEN_NUMB"));
			tranMap.put("ORDE_SEQU_NUMB", ordResultMap.get("ORDE_SEQU_NUMB"));
			tranMap.put("PURC_IDEN_NUMB", ordResultMap.get("PURC_IDEN_NUMB"));
			// mrpurt 를 다시 발주접수 상태로 변경.
			tranMap.put("purc_stat_flag", "50");
			purchaseDao.updatePurcCancProcMrpurt(tranMap);
			// 주문 히스토리에 insert
            orderCommonSvc.setOrderHist( (String)ordResultMap.get("ORDE_IDEN_NUMB"), (String)ordResultMap.get("ORDE_SEQU_NUMB"), (String)ordResultMap.get("PURC_IDEN_NUMB"), null, null, "50", reason, userId);
		}
	}
	
	public String addProdChk(String orde_iden_numb, String orde_sequ_numb, String hope_chg_stat) {
		String rtnMsg = "";
		Map<String , Object> addProdMap = new HashMap<String, Object>();
		addProdMap.put("ordeIdenNumb", orde_iden_numb);
		addProdMap.put("ordeSequNumb", orde_sequ_numb);
		addProdMap = purchaseDao.selectIsAddProdCancelAble(addProdMap);		
		// 추가상품 관련 주문요청은 무조건 주문의뢰까지 진행됨을 가정으로 함.
        if(addProdMap != null && "".equals( CommonUtils.getString((String)addProdMap.get("ADD_PROD_STAT_FLAG"))  ) == false ){
        	// ADD_PROD_STAT_FLAG 값이 빈값이 아니라면
        	// 추가 상품임을 뜻함. 추가 마스터 상품이든, 추가 서브 상품이든.
        	String my_stat_flag = CommonUtils.getString((String)addProdMap.get("MY_STAT_FLAG"));
        	String add_prod_stat_flag = CommonUtils.getString((String)addProdMap.get("ADD_PROD_STAT_FLAG"));
        	String chg_stat = hope_chg_stat;
        	if( "".equals(my_stat_flag) == false && "".equals(add_prod_stat_flag) == false){
        		int my_stat_flag_int = 0;
        		int add_prod_stat_flag_int = 0;
        		try {
					my_stat_flag_int = Integer.parseInt(my_stat_flag);
					add_prod_stat_flag_int = Integer.parseInt(add_prod_stat_flag);
					// 추가상품 관련하여 상태가 50 이상인 상태가 있다면 상태 변경 불가.
					if(
						my_stat_flag_int > 40			// 주문의뢰 이상 상태가 존재할 경우 변경 X
						|| add_prod_stat_flag_int > 40 // 주문의뢰 이상 상태가 존재할 경우 변경 X
						//추가 상품 관련하여 아래 상태로 변경 시도 불가.
						|| "10".equals(chg_stat)	// 주문요청
						|| "91".equals(chg_stat) // 주문의뢰중지
						|| "92".equals(chg_stat) // 주문접수중지 
						|| "93".equals(chg_stat) // 배송중지
						|| "59".equals(chg_stat) // 고객사 사용자의 주문취소 요청
					){
						rtnMsg = "추가상품 관련 주문상태 변경이 불가합니다."; 
					}
				} catch (Exception e) { }
        	}
       	}
		return rtnMsg;
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public String updateOrdPurcReceiveRejectIncludeAddProd( Map<String, Object> saveMap) throws Exception {
		String rtnMsg = "";
		String[] ordeIdenNumbArr	= (String[])saveMap.get("ordeIdenNumb_Array");
		String[] ordeSequNumbArr	= (String[])saveMap.get("ordeSequNumb_Array");
		String[] purcIdenNumbArr	= (String[])saveMap.get("purcIdenNumb_Array");
		String[] chanReasDescArr	= (String[])saveMap.get("chanReasDesc_Array");
		
		for(int i=0; i<ordeIdenNumbArr.length; i++){
            Map<String , Object> addProdMap = new HashMap<String, Object>();
            addProdMap.put("ordeIdenNumb", ordeIdenNumbArr[i]);
            addProdMap.put("ordeSequNumb", ordeSequNumbArr[i]);
            addProdMap = purchaseDao.selectIsAddProdCancelAble(addProdMap);		
            // 추가 상품 관련 주문정보일 경우 발주거부 못하게 처리해야함.
            if(addProdMap != null && "".equals( CommonUtils.getString((String)addProdMap.get("ADD_PROD_STAT_FLAG"))  ) == false ){
                rtnMsg = "추가상품 관련 주문상태 변경이 불가합니다.\n주문번호:"+ordeIdenNumbArr[i]+"-"+ordeSequNumbArr[i]; 
            }
		}
		if("".equals(rtnMsg) == true){
			for(int i=0; i<ordeIdenNumbArr.length; i++){
				saveMap.put("ordeIdenNumb", ordeIdenNumbArr[i]);
				saveMap.put("ordeSequNumb", ordeSequNumbArr[i]);
				saveMap.put("purcIdenNumb", purcIdenNumbArr[i]);
				saveMap.put("chanReasDesc", chanReasDescArr[i]);
				String ordPurcStatus = purchaseDao.selectOrdPurcStatus(saveMap);
				if("40".equals(ordPurcStatus)){
					//발주거부 관련 sms정보
					Map<String, Object> smsInfo = purchaseDao.selectOrdPurcReceiveRejectSmsInfo(saveMap);
					String orderUserMobile	= (String)smsInfo.get("ORDER_USER_MOBILE");
					String vendorNm			= (String)smsInfo.get("VENDOR_NM");
					
					purchaseDao.updateMrordtPurcRequQuan(saveMap);
					purchaseDao.deleteOrdPurcReceive(saveMap);
					
					//발주거부시 주문자에세 sms전송
					commonSvc.sendRightSms(orderUserMobile, "공급사 ["+vendorNm+"] 에서 주문 접수 거부 하였습니다.", Constances.ETC_MOBILE_SENDERNUM);
					
					// 히스토리 저장
					String chanReasDesc	= (String)saveMap.get("chanReasDesc");	//사유
					String borgNm		= (String)saveMap.get("borgNm");		
					String userNm		= (String)saveMap.get("userNm");		
					
					String reason = chanReasDesc+"<br>["+borgNm+"] ["+userNm+"] 사용자가 [주문접수거부] 처리함.";
					orderCommonSvc.setOrderHist((String)saveMap.get("ordeIdenNumb"), (String)saveMap.get("ordeSequNumb"), (String)saveMap.get("purcIdenNumb"), null, null, "10", reason, (String)saveMap.get("userId"));
					saveMap.remove("ordeIdenNumb");
					saveMap.remove("ordeSequNumb");
					saveMap.remove("purcIdenNumb");
					saveMap.remove("orde_hist_numb");
				}
			}
		}
		return rtnMsg;
	}

	public int selectPurchaseListCnt(Map<String, Object> params) {
		return purchaseDao.selectPurchaseListCntNew(params);	
	}

	public List<OrderPurtDto> selectPurchaseList(Map<String, Object> params, int page, int rows) {
		return purchaseDao.selectPurchaseListNew(params, page, rows);	
	}

	
	/** 운영사 : 발주이력  */
	public Map<String, Object> selectPurchaseResultListCnt( Map<String, Object> params) {
		return purchaseDao.selectPurchasetResultListNewCnt(params);	
	}
	public List<OrderPurtDto> selectPurchaseResultList( Map<String, Object> params, int page, int rows) {
		return purchaseDao.selectPurchaseResultNewList(params, page, rows);	
	}

	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateIsPurcPrint(Map<String, Object> saveMap) {
		List<String> orde_sequ_purt_arr = (List<String>)saveMap.get("orde_sequ_purt_arr");
        String[] tempStrArr 					= null;
        String[] tempStrSubArr 			= null;
        Map<String, String> tmpMap 	= null;
        
		for(String tempStr : orde_sequ_purt_arr){
			tempStrArr = tempStr.split(",");
            for(String tempStrSub : tempStrArr){
                tempStrSub	= tempStrSub.replaceAll("'", "");
                tempStrSubArr 	= tempStrSub.split("-");
                tmpMap			= new HashMap<String, String >();
                tmpMap.put("orde_iden_numb", tempStrSubArr[0]);
                tmpMap.put("orde_sequ_numb", tempStrSubArr[1]);
                tmpMap.put("purc_iden_numb", tempStrSubArr[2]);
                purchaseDao.updateIsPurcPrint(tmpMap);	
            }
		}
	}

	public void updateMrordmIsPurcPrint(ModelMap paramMap) {
		String orde_iden_numb = CommonUtils.getString(paramMap.get("orderIdenNumb")) ;
		purchaseDao.updateMrordmIsPurcPrint(orde_iden_numb);	
	}
}
