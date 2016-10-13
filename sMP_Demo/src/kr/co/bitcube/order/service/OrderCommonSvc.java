package kr.co.bitcube.order.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.order.dao.OrderCommonDao;
import kr.co.bitcube.order.dto.OrderHistDto;
import kr.co.bitcube.organ.dto.SmpUsersDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.exception.FdlException;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class OrderCommonSvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private OrderCommonDao orderCommonDao;
	
	@Resource(name="seqMpOrderHistService")
	private EgovIdGnrService seqMpOrderHistService;
	
	@Resource(name="seqMcStockChgHist")
	private EgovIdGnrService seqMcStockChgHist;

	/**
	 * 주문의 히스토리 상태를 저장한다.<br/>
	 * 트랜젝션이 일어나는 SVC 안에 포함될 내용이기 때문에 따로 트렌젝션 어노테이션 선언을 하지 않음. <br/>값이 없을 시 null <br/><b>
		<br/> 매개변수 순서 및 설명.<br/>
		1. orde_iden_numb : 주문번호<br/>
		2. orde_sequ_numb : 주문차수<br/>
		3. purc_iden_numb : 발주차수<br/>
		4. deli_iden_numb : 출하차수<br/>
		5. rece_iden_numb : 인수차수<br/>
		6. histCode : 변경내용 시스템 메세지 DB 조회용 코드 (codeTypeCd : ORDERCHANGEMESSAGE 참조.)<br/>
		7. chan_reas_desc : 변경사유<br/>
		8. regi_user_id : 변경자 Id<br/></b>
	 * @throws FdlException 
	 */
	public void setOrderHist(
			String orde_iden_numb, 
			String orde_sequ_numb, 
			String purc_iden_numb, 
			String deli_iden_numb, 
			String rece_iden_numb, 
			String histCode, 
			String chan_reas_desc, 
			String regi_user_id
			) throws FdlException{ // insert method start
		Map<String, Object> histSaveMap = new HashMap<String,Object>(); 	// 히스토리 Insert 할 Map
		purc_iden_numb = purc_iden_numb == null ? "" : purc_iden_numb;
		deli_iden_numb = deli_iden_numb == null ? "" : deli_iden_numb;
		rece_iden_numb = rece_iden_numb == null ? "" : rece_iden_numb;
		chan_reas_desc = chan_reas_desc == null ? "" : chan_reas_desc;
		histSaveMap.put("orde_hist_numb", seqMpOrderHistService.getNextStringId());
		histSaveMap.put("orde_iden_numb", orde_iden_numb);
		histSaveMap.put("orde_sequ_numb", orde_sequ_numb);
		histSaveMap.put("purc_iden_numb", purc_iden_numb);
		histSaveMap.put("deli_iden_numb", deli_iden_numb);
		histSaveMap.put("rece_iden_numb", rece_iden_numb);
		histSaveMap.put("chan_reas_desc", chan_reas_desc);
		histSaveMap.put("regi_user_id", regi_user_id);
		histSaveMap.put("histCode", histCode);
		String chanContDesc = "주문번호["+orde_iden_numb+"-"+orde_sequ_numb+"]<br/>";
		if(!purc_iden_numb.equals("")){
			chanContDesc += "발주차수["+purc_iden_numb+"]<br/>";
		}
		if(!deli_iden_numb.equals("")){
			chanContDesc += "출하차수["+deli_iden_numb+"]<br/>";
		}
		if(!rece_iden_numb.equals("")){
			chanContDesc += "인수차수["+rece_iden_numb+"]<br/>";
		}
		OrderHistDto ohd = orderCommonDao.selectOrderChangeMessage(histSaveMap);	// 히스토리 변경내용 텍스트 조회해옴.
		chanContDesc += "<b>"+ohd.getChan_cont_desc()+"</b>";
		histSaveMap.put("chan_cont_desc", chanContDesc);
		
		orderCommonDao.insertMrordtHist(histSaveMap);	// 히스토리 Insert ( 주문 내역 관련)
	} // insert method end
	
	
	public List<SmpUsersDto> getWorkUserInfo() {
		return (List<SmpUsersDto>)orderCommonDao.selectWorkUserInfo();
	}


	/** 아래 순서대로 값을 집어넣는다.<br/>
	 *  상품코드(String)<br/>
	 *  공급사코드(String)<br/>
	 *  변경 전 수량(int)<br/>
	 *  변경 후 수량(int)<br/>
	 *  변경타입 코드값(String)<br/>
	 *  유저ID(String)<br/>
	 */
	public void insertMcgoodvendorStockQuan
	(
			String good_iden_numb 
			, String vendorid
			, int before_quantity
			, int after_quantity
			, String stock_type
			, String userId
	)
	{
		Map<String, Object> stockSaveMap = new HashMap<String,Object>(); 	// 히스토리 Insert 할 Map
		stockSaveMap.put("good_iden_numb", good_iden_numb);
		stockSaveMap.put("vendorid", vendorid);
		stockSaveMap.put("before_quantity", before_quantity);
		stockSaveMap.put("after_quantity", after_quantity);
		stockSaveMap.put("stock_type", stock_type);
		stockSaveMap.put("userId", userId);
		orderCommonDao.insertMcgoodvendorStockQuan(stockSaveMap);	// 히스토리 Insert (재고관련)
	}


	/**
	 * 현재 재고수량을 변경시킨다. 아래 순서대로 매개변수를 집어넣는다.<br/>
	 *  상품코드(String)<br/>
	 *  공급사코드(String)<br/>
	 *  변경 할 수량(int)<br/>
	 */
	public void updateMcgoodvendorStockQuan(String good_iden_numb, String vendorid, int quantity) {
		Map<String, Object> stockSaveMap = new HashMap<String,Object>(); 	// 히스토리 Insert 할 Map
		stockSaveMap.put("good_iden_numb", good_iden_numb);
		stockSaveMap.put("vendorid", vendorid);
		stockSaveMap.put("quantity", quantity);
		orderCommonDao.updateMcgoodvendorQuan(stockSaveMap);	// 히스토리 Insert (재고관련)
	}


	/**
	 * 주문정보에 있는 상품코드와 공급사코드로 상품 정보를 리턴한다.
	 * <br/>아래 정보가 Map에 담겨져 있어야 한다.<br/>
	 *  orde_iden_numb(key)<br/>
	 *  orde_sequ_numb(key)<br/>
	 *  purc_iden_numb(key)<br/>
	 */
	public Map<String, Object> selectStockOrderInfo(Map<String, Object> saveMap) {
		return orderCommonDao.selectStockOrderInfo(saveMap);	// 히스토리 Insert (재고관련)
	}

	/**
	 * 상품 담당자 정보 검색
	 */
	public List<SmpUsersDto> getProductManager() {
		return orderCommonDao.selectProductManager();
	}


	/**
	 * 주문상품의 재고관리 여부가 Y 일 경우 재고 수량을 수정 한다.<br/>
	 * 주문상품의 재고관리 여부가 Y 일 경우 재고변경이력 정보를 insert 한다.
	 * @param flag : PLUS(재고 추가) 나 MINUS(재고차감) 를 입력.
	 * @param orde_iden_numb : 주문번호
	 * @param orde_sequ_numb : 주문차수
	 * @param purc_iden_numb : 발주차수
	 * @param procUserId : 처리자 UserId
	 * @param procQuan : 처리수량
	 * @throws Exception 
	 */
	public void stockManage(String flag, String orde_iden_numb, String orde_sequ_numb, String purc_iden_numb, String procUserId, int procQuan) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("flag", flag);
		params.put("orde_iden_numb", orde_iden_numb);
		params.put("orde_sequ_numb", orde_sequ_numb);
		params.put("purc_iden_numb", purc_iden_numb);

		Map<String, Object> goodVendorInfoMap = orderCommonDao.selectGoodVendorInfoForStock(params);
		if(goodVendorInfoMap != null){
			String isStockMngt = CommonUtils.getString(goodVendorInfoMap.get("STOCK_MNGT")) ;
			if("Y".equals(isStockMngt)){
				// 공통정보 세팅
				String flagSymbol = "";
                int before_good_inventory_cnt = ((BigDecimal)goodVendorInfoMap.get("GOOD_INVENTORY_CNT")).intValue();
                int good_inventory_cnt = 0;
                int stock_variation = 0;
                if("PLUS".equals(flag)){		// 누적 (반품승인등의 상황)
                	good_inventory_cnt = before_good_inventory_cnt + procQuan;
                	stock_variation = stock_variation + procQuan;
                	flagSymbol = "+";
                }else if("MINUS".equals(flag)){// 차감 (출하등의 상황)
                	good_inventory_cnt = before_good_inventory_cnt - procQuan;
                	stock_variation = stock_variation - procQuan;
                	flagSymbol = "-";
                }else{
                	throw new Exception("Process flag is not suitable.");
                }
				params.clear();
                params.put("GOOD_IDEN_NUMB", goodVendorInfoMap.get("GOOD_IDEN_NUMB"));
                params.put("VENDORID", goodVendorInfoMap.get("VENDORID"));
                params.put("GOOD_INVENTORY_CNT", good_inventory_cnt);
                orderCommonDao.updateGoodVendorInventoryQuan(params);
                
				params.clear();
                params.put("seqMcStockChgHist", seqMcStockChgHist.getNextStringId());
                params.put("good_iden_numb", goodVendorInfoMap.get("GOOD_IDEN_NUMB"));
                params.put("vendorid", goodVendorInfoMap.get("VENDORID"));
                params.put("chg_reason", "[재고수량 "+flagSymbol+"변경]");
                params.put("stock_variation", stock_variation);
                params.put("stock", ((BigDecimal)goodVendorInfoMap.get("GOOD_INVENTORY_CNT")).intValue());
                params.put("order_iden_numb", orde_iden_numb);
                params.put("insert_user_id", procUserId);
                orderCommonDao.insertGoodVendorInventoryQuanHist(params);
			}
		}
	}


	public void setReturnRequstHist(String orde_iden_numb, String orde_sequ_numb, String purc_iden_numb, String deli_iden_numb, String rece_iden_numb, String title, String chan_reas_desc, String regi_user_id) throws Exception {
		Map<String, Object> histSaveMap = new HashMap<String,Object>(); 	// 히스토리 Insert 할 Map
		histSaveMap.put("orde_hist_numb", seqMpOrderHistService.getNextStringId());
		histSaveMap.put("orde_iden_numb", orde_iden_numb);
		histSaveMap.put("orde_sequ_numb", orde_sequ_numb);
		histSaveMap.put("purc_iden_numb", purc_iden_numb);
		histSaveMap.put("deli_iden_numb", deli_iden_numb);
		histSaveMap.put("rece_iden_numb", rece_iden_numb);
		histSaveMap.put("chan_reas_desc", chan_reas_desc);
		histSaveMap.put("regi_user_id", regi_user_id);
		String chanContDesc = "주문번호["+orde_iden_numb+"-"+orde_sequ_numb+"]<br/>";
		if(!purc_iden_numb.equals("")){
			chanContDesc += "발주차수["+purc_iden_numb+"]<br/>";
		}
		if(!deli_iden_numb.equals("")){
			chanContDesc += "출하차수["+deli_iden_numb+"]<br/>";
		}
		if(!rece_iden_numb.equals("")){
			chanContDesc += "인수차수["+rece_iden_numb+"]<br/>";
		}
		chanContDesc += "<b>"+title+"</b>";
		histSaveMap.put("chan_cont_desc", chanContDesc);
		
		orderCommonDao.insertMrordtHist(histSaveMap);	// 히스토리 Insert ( 주문 내역 관련)
	}
}
