package kr.co.bitcube.adjust.service;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import kr.co.bitcube.adjust.dao.AdjustDao;
import kr.co.bitcube.adjust.dto.AdjustDto;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.BorgDto;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.UserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.Constances;
import kr.co.bitcube.common.utils.JcoAdapter;

import org.apache.ibatis.binding.MapperMethod.ParamMap;
import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class AdjustSvc {
	
	@Autowired
	private AdjustDao adjustDao;
	
	@Autowired
	private GeneralDao generalDao;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Resource(name="seqAdjustGenerationService")
	private EgovIdGnrService seqAdjustGenerationService;

	@Resource(name="seqBondsHist")
	private EgovIdGnrService seqBondsHist;

	@Resource(name="seqSalesSapNo")
	private EgovIdGnrService seqSalesSapNo;

	@Resource(name="seqPurchaseSapNo")
	private EgovIdGnrService seqPurchaseSapNo;

	@Resource(name="seqMptrec")
	private EgovIdGnrService seqMptrec;
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	public List<AdjustDto> adjustGenerationList(Map<String, Object> params) throws Exception {
		return adjustDao.adjustGenerationList(params);
	}

	public List<AdjustDto> adjustCreatList(Map<String, Object> params) throws Exception {
		return adjustDao.adjustCreatList(params);
	}

	public List<AdjustDto> adjustGenerationMasterList(Map<String, Object> params) throws Exception {
		return adjustDao.adjustGenerationMasterList(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveAdjustMaster(Map<String, Object> saveMap) throws Exception {
		String sale_sequ_numb = seqAdjustGenerationService.getNextStringId();
		saveMap.put("sale_sequ_numb", sale_sequ_numb);
		adjustDao.insertAdjustMaster(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveAdjustMasterAll(Map<String, Object> saveMap) throws Exception {
		//매출 마스터 생성
		int resultCnt = adjustDao.insertAdjustMasterAll(saveMap);
		for(int i=0;i<resultCnt;i++) {
			seqAdjustGenerationService.getNextStringId();
		}
		
		//인수목록 업데이트
		List<AdjustDto> updList = adjustDao.adjustGenerationMasterListForAll(saveMap);
		if(updList != null  && updList.size() > 0){
			for (int i = 0; i < updList.size(); i++) {
				saveMap.put("sale_sequ_numb", updList.get(i).getSale_sequ_numb());
				saveMap.put("branchId"		, updList.get(i).getBranchId());
				adjustDao.updateAdjustCreatListForAll(saveMap);
			}
		}
//		adjustDao.updateSequenceToSaleMaster();
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void delAdjustMaster(Map<String, Object> saveMap) throws Exception {
		adjustDao.delAdjustMaster(saveMap);
		adjustDao.updateAdjustCreatList(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void multiDelAdjustMaster(Map<String, Object> saveMap) throws Exception {
		String [] sale_sequ_numb_array = (String[]) saveMap.get("sale_sequ_numb_array");
		for(String sale_sequ_numb : sale_sequ_numb_array) {
			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("sale_sequ_numb", sale_sequ_numb);
			adjustDao.delAdjustMaster(paramMap);
			adjustDao.updateAdjustCreatList(paramMap);
		}
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void addAdjustCreatList(Map<String, Object> saveMap) throws Exception {
		
		String[] orde_iden_numb_arr = (String[])saveMap.get("orde_iden_numb_arr");
		String subQuery = "";
		int    numCnt   = 0;
		
		for(String tmp : orde_iden_numb_arr){
			//0 : orde_iden_numb
			//1 : orde_sequ_numb
			//2 : purc_iden_numb
			//3 : deli_iden_numb
			//4 : rece_iden_numb
			//5 : sale_conf_quan 	-- 실정산수량
			//6 : listOper			-- 분할여부 (O : 변경없음, U : 분할요청)
			tmp.split("\\|");
			
			if("add".equals(saveMap.get("oper").toString())){
				if("U".equals(tmp.split("\\|")[6])){
					saveMap.put("sale_prod_quan", tmp.split("\\|")[5]);
					saveMap.put("orde_iden_numb", tmp.split("\\|")[0]);
					saveMap.put("orde_sequ_numb", tmp.split("\\|")[1]);
					saveMap.put("purc_iden_numb", tmp.split("\\|")[2]);
					saveMap.put("deli_iden_numb", tmp.split("\\|")[3]);
					saveMap.put("rece_iden_numb", tmp.split("\\|")[4]);
					adjustDao.insMrordtListForDivision(saveMap);		//새로운 인수생성(차수 + 1)  
					adjustDao.updMrordtListForDivision(saveMap);		//인수내역 업데이트
				}
			}
			
			String preSql = "";
			
			if(numCnt == 0) preSql = " where ";
			else            preSql = " or ";
			
			subQuery += preSql + " (orde_iden_numb = '" + tmp.split("\\|")[0] + "'";
			subQuery += " and orde_sequ_numb = '" + tmp.split("\\|")[1] + "'";
			subQuery += " and purc_iden_numb = '" + tmp.split("\\|")[2] + "'";
			subQuery += " and deli_iden_numb = '" + tmp.split("\\|")[3] + "'";
			subQuery += " and rece_iden_numb = '" + tmp.split("\\|")[4] + "'";
			
			if(!"del".equals(saveMap.get("oper").toString())) {
				subQuery += " and SALE_SEQU_NUMB IS NULL";
				subQuery += " and SALE_PROD_QUAN >= CONVERT(INT,'" + tmp.split("\\|")[5] + "') ";
			}
			subQuery += " ) ";
			
			numCnt++;
		}
		saveMap.put("subQuery", subQuery);
		
		if("add".equals(saveMap.get("oper").toString())){
			adjustDao.addAdjustCreatList(saveMap);
		}else if("del".equals(saveMap.get("oper").toString())){
			adjustDao.removeAdjustCreatList(saveMap);
		}
		
		double requAmou = 0;
		double requVTax = 0;
		double totalAmou = 0;
		List<AdjustDto> adjustCreatList = this.adjustCreatList(saveMap);
		
		if(adjustCreatList != null && adjustCreatList.size() > 0){
			
			for(int i = 0 ; i < adjustCreatList.size() ; i++){
				requAmou += Double.parseDouble(adjustCreatList.get(i).getSale_prod_amou());
				requVTax += Double.parseDouble(adjustCreatList.get(i).getSale_prod_tax());
			}
			requVTax = Math.floor(requVTax);
			totalAmou = requAmou + requVTax;
			
			saveMap.put("sale_requ_amou", requAmou);
			saveMap.put("sale_requ_vtax", requVTax);
			saveMap.put("sale_tota_amou", totalAmou);
		}else{
			saveMap.put("sale_requ_amou", 0);
			saveMap.put("sale_requ_vtax", 0);
			saveMap.put("sale_tota_amou", 0);			
		}
		adjustDao.updateMssalmAmou(saveMap);
	}
	
	public int adjustSalesConfirmListCnt (Map<String, Object> paramMap) {
		return adjustDao.adjustSalesConfirmListCnt(paramMap);
	}

	public List<AdjustDto> adjustSalesConfirmList (Map<String, Object> paramMap, int page, int rows) {
		return adjustDao.adjustSalesConfirmList(paramMap, page, rows);
	}

	public int adjustSalesConfirmDetailListCnt (Map<String, Object> paramMap) {
		return adjustDao.adjustSalesConfirmDetailListCnt(paramMap);
	}
	
	public List<AdjustDto> adjustSalesConfirmDetailList (Map<String, Object> paramMap, int page, int rows) {
		return adjustDao.adjustSalesConfirmDetailList(paramMap, page, rows);
	}
	
	public List<AdjustDto> adjustSalesConfirmDetailList (Map<String, Object> paramMap) {
		List<AdjustDto> tmpList = adjustDao.adjustSalesConfirmDetailList(paramMap);
		AdjustDto addAdjustDto = new AdjustDto();
//		addAdjustDto.setVendorNm("총계");
		addAdjustDto.setOrder_num("총계");
		double sum_orde_requ_quan = 0;
		double sum_sale_prod_quan = 0;
		double sum_sale_prod_pris = 0;
		double sum_sale_prod_amou = 0;
		double sum_sale_prod_tax = 0;
		double sum_sale_tota_amou = 0;
		for(AdjustDto adjustDto : tmpList) {
			sum_orde_requ_quan += Double.parseDouble(adjustDto.getOrde_requ_quan());
			sum_sale_prod_quan += Double.parseDouble(adjustDto.getSale_prod_quan());
			sum_sale_prod_pris += Double.parseDouble(adjustDto.getSale_prod_pris());
			sum_sale_prod_amou += Double.parseDouble(adjustDto.getSale_prod_amou());
			sum_sale_prod_tax += Double.parseDouble(adjustDto.getSale_prod_tax());
			sum_sale_tota_amou += Double.parseDouble(adjustDto.getSale_tota_amou());
		}
		addAdjustDto.setOrde_requ_quan(String.valueOf(sum_orde_requ_quan));
		addAdjustDto.setSale_prod_quan(String.valueOf(sum_sale_prod_quan));
		addAdjustDto.setSale_prod_pris(String.valueOf(sum_sale_prod_pris));
		addAdjustDto.setSale_prod_amou(String.valueOf(sum_sale_prod_amou));
		addAdjustDto.setSale_prod_tax(String.valueOf(sum_sale_prod_tax));
		addAdjustDto.setSale_tota_amou(String.valueOf(sum_sale_tota_amou));
		tmpList.add(addAdjustDto);
		
		return tmpList;
	}

	public void modAdjustConfirm (Map<String, Object> saveMap) {
		adjustDao.modAdjustConfirm(saveMap);
	}

	public int adjustPurcConfirmListCnt (Map<String, Object> paramMap) {
		return adjustDao.adjustPurcConfirmListCnt(paramMap);
	}
	
	public List<AdjustDto> adjustPurcConfirmList (Map<String, Object> paramMap, int page, int rows) {
		return adjustDao.adjustPurcConfirmList(paramMap, page, rows);
	}
	
	public int adjustPurcCancelListCnt (Map<String, Object> paramMap) {
		return adjustDao.adjustPurcCancelListCnt(paramMap);
	}
	
	public List<AdjustDto> adjustPurcCancelList (Map<String, Object> paramMap, int page, int rows) {
		return adjustDao.adjustPurcCancelList(paramMap, page, rows);
	}

	public List<AdjustDto> adjustPurcConfirmDetailList (Map<String, Object> paramMap) {
		
		List<AdjustDto> tmpList = adjustDao.adjustPurcConfirmDetailList(paramMap);
		AdjustDto addAdjustDto = new AdjustDto();
		addAdjustDto.setOrde_type_clas_nm("총계");
		double sum_sale_prod_quan = 0;
		double sum_purc_prod_pris = 0;
		double sum_purc_prod_amou = 0;
		double sum_purc_prod_tax = 0;
		double sum_buyi_tota_amou = 0;
		for(AdjustDto adjustDto : tmpList) {
			sum_sale_prod_quan += Double.parseDouble(adjustDto.getSale_prod_quan());
			sum_purc_prod_pris += Double.parseDouble(adjustDto.getPurc_prod_pris());
			sum_purc_prod_amou += Double.parseDouble(adjustDto.getPurc_prod_amou());
			sum_purc_prod_tax += Double.parseDouble(adjustDto.getPurc_prod_tax());
			sum_buyi_tota_amou += Double.parseDouble(adjustDto.getBuyi_tota_amou());
		}
		addAdjustDto.setSale_prod_quan(String.valueOf(sum_sale_prod_quan));
		addAdjustDto.setPurc_prod_pris(String.valueOf(sum_purc_prod_pris));
		addAdjustDto.setPurc_prod_amou(String.valueOf(sum_purc_prod_amou));
		addAdjustDto.setPurc_prod_tax(String.valueOf(sum_purc_prod_tax));
		addAdjustDto.setBuyi_tota_amou(String.valueOf(sum_buyi_tota_amou));
		tmpList.add(addAdjustDto);
		
		return tmpList;
	}
	
	/**
	 * 매입확정취소 가능 상태 체크
	 * @param paramMap
	 * @return
	 */
	public boolean getPurcIsCancel(Map<String, Object> paramMap) {
		int chkCnt = adjustDao.adjustPurcCancelListCnt(paramMap);
		if(chkCnt > 0) return true;
		else return false;
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void modPurcConfirm (Map<String, Object> saveMap) throws Exception{
		
		String buyi_sequ_numb = "";
		//파라미터 셋팅
		String[] vendorIdArr 		= (String[])saveMap.get("vendorIdArr"); 
		String[] buyi_requ_amou_Arr = (String[])saveMap.get("buyi_requ_amou_Arr"); 
		String[] buyi_requ_vtax_Arr = (String[])saveMap.get("buyi_requ_vtax_Arr"); 
		String[] paym_cond_code_Arr = (String[])saveMap.get("paym_cond_code_Arr");
		
		if(vendorIdArr != null && buyi_requ_amou_Arr != null && buyi_requ_vtax_Arr != null && paym_cond_code_Arr != null ){
			
			if("add".equals(saveMap.get("oper").toString())){
				for(int i = 0 ; i < vendorIdArr.length ; i++){
					buyi_sequ_numb = seqAdjustGenerationService.getNextStringId();
					saveMap.put("buyi_sequ_numb", buyi_sequ_numb);
					saveMap.put("vendorId"		, vendorIdArr[i]);
					saveMap.put("buyi_requ_amou", buyi_requ_amou_Arr[i]);
					saveMap.put("buyi_requ_vtax", buyi_requ_vtax_Arr[i]);
					saveMap.put("buyi_tota_amou", Double.parseDouble(buyi_requ_amou_Arr[i]) + Double.parseDouble(buyi_requ_vtax_Arr[i]));
					saveMap.put("paym_cond_code", paym_cond_code_Arr[i]);
					
					//매입해더 Insert
					adjustDao.insertMsBuyM(saveMap);
					//인수내역 Update
					adjustDao.addPurcDetailList(saveMap);
				}
			} else if("mod".equals(saveMap.get("oper").toString())) {
				//매입해더 삭제
				adjustDao.deleteMsBuyM(saveMap);
				//인수내역 Update
				adjustDao.modPurcDetailList(saveMap);
			}
		}
	}

	public int adjustBalanceListCnt (Map<String, Object> paramMap) {
		return adjustDao.adjustBalanceListCnt(paramMap);
	}

	public List<AdjustDto> adjustBalanceList (Map<String, Object> paramMap, int page, int rows) {
		return adjustDao.adjustBalanceList(paramMap, page, rows);
	}
	
	public int adjustBalanceDetailCnt (Map<String, Object> paramMap) {
		return adjustDao.adjustBalanceDetailCnt(paramMap);
	}
	
	public List<AdjustDto> adjustBalanceDetail (Map<String, Object> paramMap, int page, int rows) {
		return adjustDao.adjustBalanceDetail(paramMap, page, rows);
	}
	
	public int adjustSalesTransmissionListCnt (Map<String, Object> paramMap) {
		return adjustDao.adjustSalesTransmissionListCnt(paramMap);
	}
	
	public List<AdjustDto> adjustSalesTransmissionList (Map<String, Object> paramMap, int page, int rows) {
		return adjustDao.adjustSalesTransmissionList(paramMap, page, rows);
	}
	
	/**
	 * <pre>
	 * 매출입금처리 화면의 그리드 파라미터 기본 값을 셋팅 하는 메소드
	 * 
	 * ~. modelMap 구조
	 *   !. srcTransStatus (String, 고정값 :"20")
	 *   !. srcSalesName (String)
	 *   !. srcIsCollect  (String)
	 *   !. srcSalesTransStartDate (String)
	 *   !. srcSalesTransEndDate  (String)
	 *   !. srcClientNm (String)
	 *   !. srcBusinessNum (String)
	 *   !. receSaleStatus (String)
	 *   !. page (String, 그리드 조회페이지)
	 *   !. rows (String, 그리드 조회페이지 조회 row 수)
	 *   !. sidx (String, 그리드 정렬 컬럼)
	 *   !. sord (String, 칼럼 정렬 순서)
	 *   !. createBorgid (String, 세션사용자아이디)
	 *   !. orderString (String, 그리드 정렬 컬럼)
	 * </pre>
	 * 
	 * @param modelMap
	 * @return ModelMap
	 * @throws Exception
	 */
	private ModelMap adjustSalesTransmissionJQGrid20ModelMap(ModelMap modelMap) throws Exception{
		String sidx        = (String)modelMap.get("sidx");
		String sord        = (String)modelMap.get("sord");
		String page        = (String)modelMap.get("page");
		String rows        = (String)modelMap.get("rows");
		String orderString = null;
		
		if("saleSequNumb".equals(sidx)){      sidx = "SALE_SEQU_NUMB";}
 		else if("saleSequName".equals(sidx)){ sidx = "SALE_SEQU_NAME";}
 		else if("branchNm".equals(sidx)){     sidx = "BRANCHNM";}
 		else if("recePayAmou".equals(sidx)){  sidx = "RECE_PAY_AMOU";}
 		else if("saleRequAmou".equals(sidx)){ sidx = "SALE_REQU_AMOU";}
 		else if("saleTotaAmou".equals(sidx)){ sidx = "SALE_TOTA_AMOU";}
 		else if("remainAmou".equals(sidx)){   sidx = "REMAIN_AMOU";}
 		else if("receSequYn".equals(sidx)){   sidx = "RECE_SEQU_YN";}
 		else if("sapJourYn".equals(sidx)){    sidx = "SAP_JOUR_YN";}
 		else if("sapJourNumb".equals(sidx)){  sidx = "SAP_JOUR_NUMB";}
		else if("payYn".equals(sidx)){        sidx = "PAY_YN";}	
		else if("payAmouNumb".equals(sidx)){  sidx = "PAY_AMOU_NUMB";}
		
		page        = CommonUtils.nvl(page, "1");
		rows        = CommonUtils.nvl(rows, "30");
		orderString = CommonUtils.getOrderString(sidx, sord); // 그리드 정렬
		
		modelMap.put("page",        page);
		modelMap.put("rows",        rows);
		modelMap.put("orderString", orderString);
		
		return modelMap;
	}
	
	/**
	 * 매출 입금처리 리스트의 총합계정보를 반환하는 메소드
	 * 
	 * @param list
	 * @param listSize
	 * @return List
	 * @throws Exception
	 */
	private List<Map<String, String>> adjustSalesTransmissionJQGrid20ListSum(List<Map<String, String>> list, int listSize) throws Exception{
		Map<String, String> listInfo        = null;
		String              saleRequAmou    = null;
		String              saleRequVtax    = null;
		String              saleTotaAmou    = null;
		String              recePayAmou     = null;
		String              remainAmou      = null;
		int                 i               = 0;
		double              totSaleRequAmou = 0;
		double              totSaleRequVtax = 0;
		double              totSaleTotaAmou = 0;
		double              totRecePayAmou  = 0;
		double              totRemainAmou   = 0;
		
		for(i = 0; i < listSize; i++){
			listInfo        = list.get(i);
			saleRequAmou    = listInfo.get("saleRequAmou");
			saleRequVtax    = listInfo.get("saleRequVtax");
			saleTotaAmou    = listInfo.get("saleTotaAmou");
			recePayAmou     = listInfo.get("recePayAmou");
			remainAmou      = listInfo.get("remainAmou");
			totSaleRequAmou = totSaleRequAmou + Double.parseDouble(saleRequAmou);
			totSaleRequVtax = totSaleRequVtax + Double.parseDouble(saleRequVtax);
			totSaleTotaAmou = totSaleTotaAmou + Double.parseDouble(saleTotaAmou);
			totRecePayAmou  = totRecePayAmou  + Double.parseDouble(recePayAmou);
			totRemainAmou   = totRemainAmou   + Double.parseDouble(remainAmou);
		}
		
		if(listSize > 0){
			listInfo     = list.get(0);
			saleRequAmou = Double.toString(totSaleRequAmou);
			saleRequVtax = Double.toString(totSaleRequVtax);
			saleTotaAmou = Double.toString(totSaleTotaAmou);
			recePayAmou  = Double.toString(totRecePayAmou);
			remainAmou   = Double.toString(totRemainAmou);
			
			listInfo.put("totSaleRequAmou", saleRequAmou);
			listInfo.put("totSaleRequVtax", saleRequVtax);
			listInfo.put("totSaleTotaAmou", saleTotaAmou);
			listInfo.put("totRecePayAmou",  recePayAmou);
			listInfo.put("totRemainAmou",   remainAmou);
		}
		
		return list;
	}
	
	/**
	 * 리스트 특정 key값에 해당하는 값에 콤마를 입력하는 메소드
	 * 
	 * @param listInfo
	 * @param key
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> adjustSalesTransmissionJQGrid20ListCommaInfo(Map<String, String> listInfo, String key) throws Exception{
		String value = listInfo.get(key);
		
		value = CommonUtils.nvl(value);
		
		if("".equals(value) == false){
			value = CommonUtils.getDecimalAmount(value);
		}
		
		listInfo.put(key, value);
		
		return listInfo;
	}
	
	/**
	 * 리스트 숫자 정보에 콤마를 입력하는 메소드
	 * 
	 * @param list
	 * @param listSize
	 * @return List
	 * @throws Exception
	 */
	private List<Map<String, String>> adjustSalesTransmissionJQGrid20ListComma(List<Map<String, String>> list, int listSize) throws Exception{
		Map<String, String> listInfo = null;
		int                 i        = 0;
		
		for(i = 0; i < listSize; i++){
			listInfo = list.get(i);
			
			// 콤마처리 start!
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "saleRequAmou");
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "saleRequVtax");
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "saleTotaAmou");
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "recePayAmou");
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "remainAmou");
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "totSaleRequAmou");
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "totSaleRequVtax");
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "totSaleTotaAmou");
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "totRecePayAmou");
			listInfo = this.adjustSalesTransmissionJQGrid20ListCommaInfo(listInfo, "totRemainAmou");
			// 콤마처리 end!
		}
		
		return list;
	}
	
	/**
	 * 매출액 칼럼 정보 수정하는 메소드
	 * 
	 * @param list
	 * @param listSize
	 * @return List
	 * @throws Exception
	 */
	private List<Map<String, String>> adjustSalesTransmissionJQGrid20ListSeleRequAmou(List<Map<String, String>> list, int listSize) throws Exception{
		Map<String, String> listInfo        = null;
		String              saleRequAmou    = null;
		String              saleRequVtax    = null;
		String              totSaleRequAmou = null;
		String              totSaleRequVtax = null;
		StringBuffer        stringBuffer    = null;
		int                 i               = 0;
		
		for(i = 0; i < listSize; i++){
			stringBuffer = new StringBuffer();
			
			listInfo        = list.get(i);
			saleRequAmou    = listInfo.get("saleRequAmou");
			saleRequVtax    = listInfo.get("saleRequVtax");
			totSaleRequAmou = listInfo.get("totSaleRequAmou");
			totSaleRequVtax = listInfo.get("totSaleRequVtax");
			
			stringBuffer.append(saleRequAmou);
			stringBuffer.append("(");
			stringBuffer.append(saleRequVtax);
			stringBuffer.append(")");
			
			saleRequAmou = stringBuffer.toString();
			
			listInfo.put("saleRequAmou",    saleRequAmou);
			
			if(i == 0){
				stringBuffer = new StringBuffer();
				
				stringBuffer.append(totSaleRequAmou);
				stringBuffer.append("(");
				stringBuffer.append(totSaleRequVtax);
				stringBuffer.append(")");
				
				totSaleRequAmou = stringBuffer.toString();
				
				listInfo.put("totSaleRequAmou", totSaleRequAmou);
			}
		}
		
		return list;
	}
	
	/**
	 * 리스트 특정 key값에 해당하는 값에 줄바꿈을 입력하는 메소드
	 * 
	 * @param listInfo
	 * @param key
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> adjustSalesTransmissionJQGrid20ListLineInfo(Map<String, String> listInfo, String key) throws Exception{
		String       value        = listInfo.get(key);
		String       preValue     = null;
		String       postValue    = null;
		StringBuffer stringBuffer = new StringBuffer();
		int          lastIndex    = 0;
		
		value = CommonUtils.nvl(value);
		
		if("".equals(value) == false){
			lastIndex = value.lastIndexOf('(');
			
			if(lastIndex > -1){
				preValue  = value.substring(0, lastIndex);
				postValue = value.substring(lastIndex);
				
				stringBuffer.append(preValue);
				stringBuffer.append("<br/>");
				stringBuffer.append(postValue);
				
				value = stringBuffer.toString();
			}
		}
		
		listInfo.put(key, value);
		
		return listInfo;
	}
	
	/**
	 * 리스트 줄바꿈 필요한 데이터 처리
	 * 
	 * @param list
	 * @param listSize
	 * @return List
	 * @throws Exception
	 */
	private List<Map<String, String>> adjustSalesTransmissionJQGrid20ListLine(List<Map<String, String>> list, int listSize) throws Exception{
		Map<String, String> listInfo = null;
		int                 i        = 0;
		
		for(i = 0; i < listSize; i++){
			listInfo = list.get(i);
			
			// 줄바꿈처리 start!
			listInfo = this.adjustSalesTransmissionJQGrid20ListLineInfo(listInfo, "branchNm");
			listInfo = this.adjustSalesTransmissionJQGrid20ListLineInfo(listInfo, "sapJourNumb");
			listInfo = this.adjustSalesTransmissionJQGrid20ListLineInfo(listInfo, "payAmouNumb");
			listInfo = this.adjustSalesTransmissionJQGrid20ListLineInfo(listInfo, "saleRequAmou");
			
			if(i == 0){
				listInfo = this.adjustSalesTransmissionJQGrid20ListLineInfo(listInfo, "totSaleRequAmou");
			}
			// 줄바꿈처리 end!
		}
		
		return list;
	}
	
	/**
	 * 매출입금처리 리스트 정보를 수정하는 메소드
	 * 
	 * @param list
	 * @return List
	 * @throws Exception
	 */
	private List<Map<String, String>> adjustSalesTransmissionJQGrid20List(List<Map<String, String>> list) throws Exception{
		int listSize = 0;
		
		if(list != null){
			listSize = list.size();
		}
		
		list = this.adjustSalesTransmissionJQGrid20ListSum(list, listSize); // 리스트 합계 정보를 반환
		list = this.adjustSalesTransmissionJQGrid20ListComma(list, listSize); // 리스트에 숫자 정보에 콤마 처리
		list = this.adjustSalesTransmissionJQGrid20ListSeleRequAmou(list, listSize); // 리스트 매출액 칼럼 수정
		list = this.adjustSalesTransmissionJQGrid20ListLine(list, listSize); // 그리드 줄바꿈 처리
				
		return list;
	}
	
	/**
	 * <pre>
	 * 매출입금처리 화면의 그리드 정보를 조회하는 메소드
	 * 
	 * ~. modelMap 구조
	 *   !. srcTransStatus (String, 고정값 :"20")
	 *   !. srcSalesName (String)
	 *   !. srcIsCollect  (String)
	 *   !. srcSalesTransStartDate (String)
	 *   !. srcSalesTransEndDate  (String)
	 *   !. srcClientNm (String)
	 *   !. srcBusinessNum (String)
	 *   !. receSaleStatus (String)
	 *   !. page (String, 그리드 조회페이지)
	 *   !. rows (String, 그리드 조회페이지 조회 row 수)
	 *   !. sidx (String, 그리드 정렬 컬럼)
	 *   !. sord (String, 칼럼 정렬 순서)
	 *   !. createBorgid (String, 세션사용자아이디)
	 * 
	 * ~. return 구조
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
	public Map<String, Object> adjustSalesTransmissionJQGrid20(ModelMap modelMap) throws Exception{
		Map<String, Object>       result          = new HashMap<String, Object>();
		Map<String, Object>       gridInfo        = null;
		List<Map<String, String>> list            = null;
		String                    page            = null;
		Integer                   record          = null;
		Integer                   pageMax         = null;
		
		modelMap = this.adjustSalesTransmissionJQGrid20ModelMap(modelMap); // 파라미터 기본 값 셋팅
		page     = (String)modelMap.get("page");
		gridInfo = this.commonSvc.getJqGridList("adjust.adjustSalesTransmissionList20Count", "adjust.adjustSalesTransmissionList20", modelMap); // 그리드 리스트 조회
		list     = (List<Map<String, String>>)gridInfo.get("list");
		record   = (Integer)gridInfo.get("record");
		pageMax  = (Integer)gridInfo.get("pageMax");
		list     = this.adjustSalesTransmissionJQGrid20List(list); // 리스트 정보 수정
		
		result.put("page",    page);
		result.put("total",   pageMax);
		result.put("records", record);
		result.put("list",    list);
				
		return result;
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void adjustSalesTransApply (Map<String, Object> saveMap) throws Exception {

		// 예외 : 전송 금액의 합이 0원인 경우는 ERP/TrusBill 전송은 하지 않는다.
    	boolean isSalesTrans = false;
    	//int saleRequAmou = Integer.parseInt(saveMap.get("saleRequAmou").toString().trim());
    	String tmpAmou = (saveMap.get("saleRequAmou")==null || "".equals(saveMap.get("saleRequAmou").toString().trim())) ? "0" : saveMap.get("saleRequAmou").toString().trim();
    	double saleRequAmou = 0;
    	try {
    		logger.info("jameskang tmpAmou : "+tmpAmou);
    		logger.info("jameskang Double.parseDouble(saveMap.get(saleRequAmou).toString().trim()) : "+Double.parseDouble(saveMap.get("saleRequAmou").toString().trim()));
    		saleRequAmou = Double.parseDouble(saveMap.get("saleRequAmou").toString().trim());
    		logger.info("jameskang saleRequAmou : "+saleRequAmou);
    	} catch(NumberFormatException ex) {
    		logger.error("saleRequAmou exception : "+ex);;
    	}
    	if(saleRequAmou != 0){
    		isSalesTrans = true;
    	}
		String seqSapNo = "37" + String.format("%08d", seqSalesSapNo.getNextIntegerId()); //전표번호
		
    	//1. MSSALM 테이블 업데이트
		if(!isSalesTrans){
			saveMap.put("setPayAmouNumb", "Y");	
		}
		
    	saveMap.put("seqSapNo", seqSapNo);
    	adjustDao.updateAdjustSalesTrans(saveMap);
    	String[] unIssuedBusinessNumArr = Constances.UNISSUED_BUSINESSNUM;
    	String[] unIssuedBranchIdArr = Constances.UNISSUED_BRANCHID;
    	
    	String buyBusinessNum = saveMap.get("recCoRegNo").toString().trim();
    	String buyBranchId = saveMap.get("branchId").toString().trim();
    	
    	
    	
    	boolean isEBillTrans = false;
    	//특정업체 TrusBill에는 전송하지 않는 부분체크, 기존 framework.properties 에서 Code에서 읽어오는 것으로 변경
    	//Modify By Jameskang 2013.11.04
    	isEBillTrans = adjustDao.selectEbillCheckByBranchId(buyBranchId);
    	
    	
    	// 예외1 : 특정 법인은 ERP전송은 하되 세금계산서는 발행하지 않는다.
//    	if(unIssuedBusinessNumArr.length > 0){
//    		for(int i = 0 ; i < unIssuedBusinessNumArr.length ; i++){
//    			if(unIssuedBusinessNumArr[i].equals(buyBusinessNum)){
//    				isEBillTrans = false;
//    				break;
//    			}else{
//    				isEBillTrans = true;
//    			}
//    		}
//    	}
    	// 예외2 : 세금계산서 발행을 하지 않는 법인중 특정 사업장은 제외한다.
//    	if(!isEBillTrans && unIssuedBranchIdArr.length > 0){
//    		for(int i = 0 ; i < unIssuedBranchIdArr.length ; i++){
//    			if(unIssuedBranchIdArr[i].equals(buyBranchId)){
//    				isEBillTrans = true;
//    				break;
//    			}else{
//    				isEBillTrans = false;
//    			}
//    		}
//    	}
    	if(isEBillTrans && isSalesTrans){
    		//2. 전자세금계산서 데이터 Insert
    		saveMap.put("resSeq"		, seqSapNo);
    		saveMap.put("docCode"		, "02");
    		saveMap.put("eBillKind"		, "1");
    		saveMap.put("customs"		, "T");
    		saveMap.put("taxSNum"		, seqSapNo);
    		saveMap.put("docAttr"		, "N");
    		saveMap.put("pubDate"		, saveMap.get("closeDate").toString().replace("-", ""));
    		saveMap.put("systemCode"	, "KF");
    		saveMap.put("pubType"		, "S");
    		saveMap.put("pubForm"		, "D");
    		saveMap.put("remarks"		, "매출 및 기타");
    		
    		saveMap.put("recCoRegNoType","01");
    		saveMap.put("supPrice"		,saveMap.get("saleRequAmou"));
    		saveMap.put("tax"			,saveMap.get("saleRequVtax"));
    		saveMap.put("pubKind"		,"N");
    		saveMap.put("loadStatus"	,"0");
    		
        	adjustDao.insertSaleEBill(saveMap);
    		
    		//3. 전자세금계산서에 표기될 품목리스트 Insert
    		adjustDao.insertItemList(saveMap);
    	} else {
    		logger.info("TrusBill에 전송하지 않음 : "+saveMap);
    	}
    	//3. SAP 전송 (회계전기)
    	
    	if(isSalesTrans){
    		if(!"39835".equals(saveMap.get("saleSequNumb"))){//sap전송하지않게 케이스처리
    			String[] transResult = this.saleTransissionApply(saveMap);
    			if(transResult[1].equals("F")){
    				throw new Exception(transResult[0] + ".	 [정산명:" +saveMap.get("saleSequName")+ "]");
    			}
    		}
    	} else {
    		logger.info("SAP에 전송하지 않음 : "+saveMap);
    	}
	}
	

	public Map<String, Object> getMssalmInfo(String saleSequNumb) {
		return adjustDao.selectMssalmInfo(saleSequNumb);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void adjustSalesTransCancel (Map<String, Object> saveMap) throws Exception {
		
		int mptrecCnt = adjustDao.getMptrecCnt(saveMap);
		
		if(mptrecCnt > 0){
			throw new Exception("반제처리 및 기타 입금처리가 진행된 데이터는 취소하실수 없습니다.  [정산명:" +saveMap.get("saleSequName")+ "]");
		}

		//매출전송취소 History Insert
		adjustDao.insertMssalmCancelHist(saveMap);
		
		//1. MSSALM 테이블 업데이트 (전송대상 상태로 되돌리기)
		logger.info("1. OKPlasa MSSALM Trans Cancel Infomation : "+saveMap);
		adjustDao.updateAdjustSalesTransCancel(saveMap);
		
		double saleRequAmou = Double.parseDouble(saveMap.get("saleRequAmou").toString().trim()); 
		
		if(saleRequAmou != 0){
			logger.info("2. TrusBill And Sap Cancel Start......seqSapNo : "+saveMap.get("seqSapNo"));
			
			//2. 전자세금계산서 발행취소 
			saveMap.put("resSeq"		, saveMap.get("seqSapNo"));
			adjustDao.updateSaleEBill(saveMap);
	
			//2. Sap 회계전송 취소
	    	String[] transResult = this.saleTransissionCancel(saveMap);
	    	if(transResult[1].equals("F")){
	    		throw new Exception(transResult[0] + ".	 [정산명:" +saveMap.get("saleSequName")+ "]");
	    	}
	    	logger.info("3. TrusBill And Sap Cancel End......seqSapNo : "+saveMap.get("seqSapNo"));
		} else {
			logger.info("매출 SapNo : "+saveMap.get("seqSapNo")+" 의 전송금액이 0 이기 때문에 SAP과 TrusBill에는 전송하지 않음");
		}
	}
	
	/**
	 * 매출회계전송
	 */
	public String[] saleTransissionApply(Map<String, Object> saveMap) throws Exception {
		JcoAdapter jcoAdapter = new JcoAdapter();
		Map<String, Object> param = new HashMap<String, Object>();
		
		//작업구분, 금액수정(마이너스 금액 수정)
		String zJobGStr 	= "";
		double saleRequAmou = 0;
		double saleRequVtax = 0;
		
		if(Double.parseDouble(saveMap.get("saleRequAmou").toString()) >= 0){
			zJobGStr = "05";
			saleRequAmou = Double.parseDouble(saveMap.get("saleRequAmou").toString())/100 ;
			saleRequVtax = Double.parseDouble(saveMap.get("saleRequVtax").toString())/100 ;
		}else{
			zJobGStr = "07";
			saleRequAmou = Math.abs(Double.parseDouble(saveMap.get("saleRequAmou").toString()))/100 ;
			saleRequVtax = Math.abs(Double.parseDouble(saveMap.get("saleRequVtax").toString()))/100 ;
		}
		
    	/*--------------------매출전송---------------------*/
		param.put("ZJOBG" , zJobGStr  );																// 01. 작업구분	//CASE WHEN a.sale_proc_amou >= 0 THEN '05' ELSE '07' END
		param.put("BUKRS" , "SKTS"  ); 																	// 02. 회사 코드
		param.put("GJAHR" , saveMap.get("closeDate").toString().replace("-", "").substring(0, 6)  ); 	// 03. 회계연도
//		param.put("GJAHR" , "201011"  ); 																// 03. 회계연도 - Test
		param.put("BELNR" , saveMap.get("seqSapNo")  );                                                 // 04. 전표번호
		param.put("BUDAT" , saveMap.get("closeDate").toString().replace("-", "")  ); 					// 05. 전기일	//마감일자
		param.put("BLDAT" , saveMap.get("closeDate").toString().replace("-", "")  ); 					// 06. 증빙일	//마감일자
		param.put("BLART" , "RM"  ); 																	// 07. 전표 유형
		param.put("WAERS" , "KRW"  ); 																	// 08. 통화코드
		param.put("USNAM" , saveMap.get("userNm")  ); 													// 09. 사용자 이름
		param.put("BKTXT" , CommonUtils.lengthLimit(saveMap.get("saleSequName").toString(),24,null)  ); 											// 10. 전표 헤더 텍스트
		param.put("BUZEI" , ""  ); 																		// 11. 개별항목번호
		param.put("NEWBS" , ""  ); 																		// 12. 개별항목의 전기키
		param.put("NEWKO" , saveMap.get("businessNum")  ); 												// 13. 계정	//사업자등록번호
		param.put("ZTERM" , saveMap.get("paymCondCode")  );												// 14. 지급조건
		param.put("ZLSCH" , ""  );                                                                      // 15. 지급방법
//		param.put("BVTYP" , saveMap.get("bankCd")    );                                                 // 16. 은행키
		param.put("BVTYP" , "");						                                                // 16. 은행키
		param.put("MWSKZ" , ""  );                                                                      // 17. 세금코드
		param.put("DMBTR" , ""  );                                                                      // 18. 현재통화금액
 		param.put("WRBTR" , saleRequAmou );          													// 19. 금액	공급가액 / 100
		param.put("FWSTE" , saleRequVtax );          													// 20. 세액	부가세누계액 / 100
		param.put("BUPLA" , ""  );                                                                      // 21. 사업장
		param.put("GSBER" , ""  );                                                                      // 22. 사업 영역
		param.put("ZUONR" , ""  );                                                                      // 23. 지정
//		param.put("SGTXT" , CommonUtils.lengthLimit(saveMap.get("saleSequName").toString(), 24, null)  );                                             // 24. 개별항목 텍스트
		param.put("SGTXT" , CommonUtils.lengthLimit(saveMap.get("itemName").toString(), 24, null)  );                                             // 24. 개별항목 텍스트
		param.put("KOSTL" , ""  );                                                                      // 25. 코스트 센터 
		param.put("PROJK" , ""  );                                                                      // 26. WBS 요소
		param.put("FKBER" , ""  );                                                                      // 27. 기능 영역
		param.put("VALUT" , ""  );                                                                      // 28. 기준일
		param.put("XREF1" , ""  );                                                                      // 29. 참조키1
		param.put("XREF2" , ""  );                                                                      // 20. 참조키2
		param.put("XREF3" , ""  );                                                                      // 31. 참조키3
		param.put("XNEGP" , ""  );                                                                      // 32. 마이너스전기
		param.put("MSGTY" , ""  );                                                                      // 33. 메시지 유형
		param.put("MSGLIN", "" );  																		// 34. 메시지 텍스트
		//회계전송 
		List<Map<String, Object>> rfcResultList = jcoAdapter.callRfcTableParam("Z_FI_CREATE_DOCUMENT_MRO", param, "T_GT001");
		Map<String, Object> resultMap = rfcResultList.get(0);	
		String[] rtnArr = {resultMap.get("MSGLIN").toString(),resultMap.get("MSGTY").toString() }; 
		
		return rtnArr;
	}
	
	/**
	 * 매출회계전송 취소 
	 */
	public String[] saleTransissionCancel(Map<String, Object> saveMap) throws Exception {
		JcoAdapter jcoAdapter = new JcoAdapter();
		Map<String, Object> param = new HashMap<String, Object>();
		//2. SAP 전송취소
		/*--------------------매출전송취소---------------------*/
		param.put("ZJOBG" 	, "09"  ); 																	// 01. 작업구분
		param.put("BUKRS"	, "SKTS"  ); 																// 02. 회사 코드
		param.put("GJAHR" 	, saveMap.get("closeDate").toString().replace("-", "").substring(0, 6)  );  // 03. 회계연도
		param.put("BELNR" 	, saveMap.get("seqSapNo")   ); 												// 04. 전표번호	3700011003
		param.put("STGRD"   , "03"); 																	// 05. 역분개사유
		param.put("BUDAT"   , ""); 																		// 06. 전기일
		param.put("MSGTY"   , ""); 																		// 07. 메시지 유형
		param.put("MSGLIN"  , ""); 																		// 08. 메시지 텍스트
		param.put("BELNR_R" , ""); 																		// 09. 역분개전표번호

		//회계전송
		List<Map<String, Object>> rfcResultList = jcoAdapter.callRfcTableParam("Z_FI_REVERSE_DOCUMENT_MRO", param, "T_FIDOC");
		Map<String, Object> resultMap = rfcResultList.get(0);	
		String[] rtnArr = {resultMap.get("MSGLIN").toString(),resultMap.get("MSGTY").toString() }; 
		
		return rtnArr;
	}
	
	public int adjustPurchaseTransmissionListCnt (Map<String, Object> paramMap) {
		return adjustDao.adjustPurchaseTransmissionListCnt(paramMap);
	}
	
	public List<AdjustDto> adjustPurchaseTransmissionList (Map<String, Object> paramMap, int page, int rows) {
		return adjustDao.adjustPurchaseTransmissionList(paramMap, page, rows);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void adjustPurchaseTransApply (Map<String, Object> saveMap) throws Exception {
		String seqSapNo = "35" + String.format("%08d", seqPurchaseSapNo.getNextIntegerId()); //전표번호
		//String seqSapNo = "37" + String.format("%08d", seqSalesSapNo.getNextIntegerId()); //전표번호

		//1. msbuym 테이블 업데이트
		saveMap.put("seqSapNo", seqSapNo);
		adjustDao.updateAdjustPurchaseTrans(saveMap);

		//외담대만기도래일 날짜등록
		adjustDao.updateEtcExpirationDate(saveMap);

		//2013-05-13 부터는 역발행 정상처리, 그전까지는 기존 시스템과 같이 개별 전송한다고 하여
		//2013-05-13 이후로 세금계산서 테이블에 데이터를 쌓는다.

		Calendar setDate = Calendar.getInstance();
		int toDay = Integer.parseInt(new SimpleDateFormat("yyyyMMdd").format(setDate.getTime()));
		setDate.set(2013, 4, 12);
		int comDay = Integer.parseInt(new SimpleDateFormat("yyyyMMdd").format(setDate.getTime()));

		//매입금액이 0 인경우 ERP/TrusBill 전송 하지 않기 위해 선언
		BigDecimal buyiRequAmou = (BigDecimal)saveMap.get("buyiRequAmou");
		
		//특정업체는 SAP전송을 하지 않음
		boolean isEbillTrans = false;
		isEbillTrans = adjustDao.selectEbillCheckByVendorId(saveMap.get("vendorId").toString());
		
		if(buyiRequAmou.doubleValue() != 0 && isEbillTrans) {
			if(toDay > comDay){
				//2. 전자세금계산서 데이터 Insert
				saveMap.put("resSeq"		, seqSapNo);
				saveMap.put("docCode"		, "02");
				saveMap.put("eBillKind"		, "1");
				saveMap.put("customs"		, "T");
				saveMap.put("taxSNum"		, seqSapNo);
				saveMap.put("docAttr"		, "N");
				saveMap.put("pubDate"		, saveMap.get("closeDate").toString().replace("-", ""));
				saveMap.put("systemCode"	, "KF");
				saveMap.put("pubType"		, "S");
				saveMap.put("pubForm"		, "D");
				saveMap.put("remarks"		, "매입 및 기타");
				
				saveMap.put("recCoRegNoType","01");
				saveMap.put("supPrice"		,saveMap.get("buyiRequAmou"));
				saveMap.put("tax"			,saveMap.get("buyiRequVtax"));
				saveMap.put("pubKind"		,"R");
				saveMap.put("loadStatus"	,"0");    	
				
				adjustDao.insertSaleEBill(saveMap);
				//3. 전자세금계산서에 표기될 품목리스트 Insert
				adjustDao.insertItemList(saveMap);
			}
			//4. SAP 전송 (회계전기)
			String[] transResult = this.purchaseTransissionApply(saveMap);
			if(transResult[1].equals("F")){
				throw new Exception(transResult[0] + ".	 [공급사명:" +saveMap.get("vendorNm")+ "]");
			}
		} else {
			logger.info("매입번호 : "+saveMap.get("buyiSequNumb") + "은 매입금액이 0 이라서 ERP/TrusBill 에 전송하지 않음");
		}
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void adjustPurchaseTransCancel (Map<String, Object> saveMap) throws Exception {
		
		int mptpayCnt = adjustDao.getMptpayCnt(saveMap);
		if(mptpayCnt > 0) {
			throw new Exception("반제처리 및 기타 지급처리가 진행된 데이터는 취소하실수 없습니다.  [ 공급사명:" +saveMap.get("vendorNm")+ "]");	
		}
		
		//1. msbuym 테이블 업데이트 (전송대상 상태로 되돌리기)
		logger.info("1. OKPlasa MSBUYM Trans Cancel Infomation : "+saveMap);
		adjustDao.updateAdjustPurchaseTransCancel(saveMap);
		
		double buyiRequAmou = Double.parseDouble(saveMap.get("buyi_requ_amou").toString().trim()); 
		
		//특정업체는 SAP전송을 하지 않음
		boolean isEbillTrans = false;
		isEbillTrans = adjustDao.selectEbillCheckByVendorId(saveMap.get("vendorId").toString());
		
		
		if(buyiRequAmou != 0 && isEbillTrans){
			//2. 전자세금계산서 발행취소 
			logger.info("2. TrusBill And Sap Cancel Start......seqSapNo : "+saveMap.get("seqSapNo"));
			saveMap.put("resSeq"		, saveMap.get("seqSapNo"));
			adjustDao.updateSaleEBill(saveMap);
			
			//2. Sap 회계전송 취소
	    	String[] transResult = this.purchaseTransissionCancel(saveMap);
	    	if(transResult[1].equals("F")){
	    		throw new Exception(transResult[0] + ".	 [ 공급사명:" +saveMap.get("vendorNm")+ "]");
	    	}
	    	logger.info("3. TrusBill And Sap Cancel End......seqSapNo : "+saveMap.get("seqSapNo"));
		} else {
			logger.info("매입 SapNo : "+saveMap.get("seqSapNo")+" 의 전송금액이 0 이기 때문에 SAP과 TrusBill에는 전송하지 않음");
		}
	}	
	
	/**
	 * 매입회계전송
	 */
	public String[] purchaseTransissionApply(Map<String, Object> saveMap) throws Exception {
		JcoAdapter jcoAdapter = new JcoAdapter();
		Map<String, Object> param = new HashMap<String, Object>();
		
		//작업구분, 금액수정(마이너스 금액 수정)
		String zJobGStr 	= "";
		double buyiRequAmou = 0;
		double buyiRequVtax = 0;
		
		if(Double.parseDouble(saveMap.get("buyiRequAmou").toString()) >= 0){
			zJobGStr = "04";
			buyiRequAmou = Double.parseDouble(saveMap.get("buyiRequAmou").toString())/100 ;
			buyiRequVtax = Double.parseDouble(saveMap.get("buyiRequVtax").toString())/100 ;
		}else{
			zJobGStr = "06";
			buyiRequAmou = Math.abs(Double.parseDouble(saveMap.get("buyiRequAmou").toString()))/100 ;
			buyiRequVtax = Math.abs(Double.parseDouble(saveMap.get("buyiRequVtax").toString()))/100 ;
		}
		
		
		
		param.put("ZJOBG" , zJobGStr  ); 																						// 01. 작업구분	CASE WHEN a.buyi_proc_amou >= 0 THEN '04' ELSE '06' END
		param.put("BUKRS" , "SKTS"  ); 																							// 02. 회사 코드
		param.put("GJAHR" , saveMap.get("closeDate").toString().replace("-", "").substring(0, 6)  ); 							// 03. 회계연도		
		param.put("BELNR" , saveMap.get("seqSapNo")  ); 																		// 04. 전표번호	//3700012001, 3700012002, 3700012003
		param.put("BUDAT" , saveMap.get("closeDate").toString().replace("-", "")  ); 											// 05. 전기일	//마감일자
		param.put("BLDAT" , saveMap.get("closeDate").toString().replace("-", "")  ); 											// 06. 증빙일	//마감일자		
		param.put("BLART" , "KM"  ); 																							// 07. 전표 유형
		param.put("WAERS" , "KRW"  ); 																							// 08. 통화코드
		param.put("USNAM" , saveMap.get("userNm")  ); 																			// 09. 사용자 이름
		param.put("BKTXT" , CommonUtils.lengthLimit(saveMap.get("vendorNm").toString(),24,null)); 								// 10. 전표 헤더 텍스트
		param.put("BUZEI" , ""  );                                                                                              // 11. 개별항목번호
		param.put("NEWBS" , ""  );                                                                                              // 12. 개별항목의 전기키
		param.put("NEWKO" , saveMap.get("businessNum")  ); 																		// 13. 계정	//사업자등록번호
		param.put("ZTERM" , saveMap.get("paymCondCode")  );																 		// 14. 지급조건
//		param.put("ZTERM" , "190"  );																 							// 14. 지급조건
		param.put("ZLSCH" , ""  );                                                                                              // 15. 지급방법
//		param.put("BVTYP" , saveMap.get("bankCd")  );                                                                           // 16. 은행키
		param.put("BVTYP" , "");                                                                           						// 16. 은행키
		param.put("MWSKZ" , ""  );                                                                                              // 17. 세금코드
		param.put("DMBTR" , ""  );                                                                                              // 18. 현재통화금액
		param.put("WRBTR" , buyiRequAmou); 														                                // 19. 금액	공급가액 / 100
		param.put("FWSTE" , buyiRequVtax);                                   													// 20. 세액	부가세누계액 / 100
		param.put("BUPLA" , ""  );                                                                                              // 21. 사업장
		param.put("GSBER" , ""  );                                                                                              // 22. 사업 영역
		param.put("ZUONR" , ""  );                                                                                              // 23. 지정
		param.put("SGTXT" , CommonUtils.lengthLimit(saveMap.get("itemName").toString(),24,null)); 								// 24. 개별항목 텍스트
		param.put("KOSTL" , ""  );                                                                                              // 25. 코스트 센터 
		param.put("PROJK" , ""  );                                                                                              // 26. WBS 요소
		param.put("FKBER" , ""  );                                                                                              // 27. 기능 영역
		param.put("VALUT" , ""  );                                                                                              // 28. 기준일
		param.put("XREF1" , ""  );                                                                                              // 29. 참조키1
		param.put("XREF2" , ""  );                                                                                              // 20. 참조키2
		param.put("XREF3" , ""  );                                                                                              // 31. 참조키3
		param.put("XNEGP" , ""  );                                                                                              // 32. 마이너스전기
		param.put("MSGTY" , ""  );                                                                                              // 33. 메시지 유형
		param.put("MSGLIN", ""  );                                                                                              // 34. 메시지 텍스트

		//회계전송
		List<Map<String, Object>> rfcResultList = jcoAdapter.callRfcTableParam("Z_FI_CREATE_DOCUMENT_MRO", param, "T_GT001");
		Map<String, Object> resultMap = rfcResultList.get(0);	
		String[] rtnArr = {resultMap.get("MSGLIN").toString(),resultMap.get("MSGTY").toString() }; 
		
		return rtnArr;
	}
	
	/**
	 * 매입회계전송 취소 
	 */
	public String[] purchaseTransissionCancel(Map<String, Object> saveMap) throws Exception {
		JcoAdapter jcoAdapter = new JcoAdapter();
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("ZJOBG"  , "08"  ); // 01. 작업구분
		param.put("BUKRS"  , "SKTS"  ); // 02. 회사 코드
		param.put("GJAHR"  , saveMap.get("closeDate").toString().replace("-", "").substring(0, 6)  ); // 03. 회계연도
		param.put("BELNR"  , saveMap.get("seqSapNo")  ); // 04. 전표번호	3700012003
		param.put("STGRD"  , "03"); // 05. 역분개사유
		param.put("BUDAT"  , ""); // 06. 전기일
		param.put("MSGTY"  , ""); // 07. 메시지 유형
		param.put("MSGLIN" , ""); // 08. 메시지 텍스트
		param.put("BELNR_R", ""); // 09. 역분개전표번호

		//회계전송
		List<Map<String, Object>> rfcResultList = jcoAdapter.callRfcTableParam("Z_FI_REVERSE_DOCUMENT_MRO", param, "T_FIDOC");
		Map<String, Object> resultMap = rfcResultList.get(0);	
		String[] rtnArr = {resultMap.get("MSGLIN").toString(),resultMap.get("MSGTY").toString() }; 
		
		return rtnArr;
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void saveDepositDetail(Map<String, Object> saveMap) throws Exception{
		ModelMap paramMap = new ModelMap();
		paramMap.put("saleSequNumb", saveMap.get("sale_sequ_numb"));
		if("add".equals(saveMap.get("oper").toString())){
			//현재 매출의 관리여부를 체크
			AdjustDto firstTranStatFlagDto = (AdjustDto)generalDao.selectGernalObject("adjust.selectMssalmTranStatFlag", paramMap);
			//mptrec Insert
			String rece_sequ_num = seqMptrec.getNextStringId();
			saveMap.put("rece_sequ_num", rece_sequ_num);
			adjustDao.insertMptrec(saveMap);
			double rece_pay_amou = Double.parseDouble("".equals(saveMap.get("rece_pay_amou").toString())?"0":saveMap.get("rece_pay_amou").toString()); //입금금액
			String operFlag = rece_pay_amou >= 0 ? "10" : "20" ; // 입금금액의 입금/차감여부 (-금액이 들어올수 있음으로 체크 [10 : plus, 20 : minus])
			
			saveMap.put("operFlag"			, operFlag);
			saveMap.put("rece_pay_amou"		, Math.abs(rece_pay_amou));
			adjustDao.updateSalesDeposit(saveMap);
			
			//매출번호에 대해 반제번호가 없고 반제금액 >= 매출금액 개수
			int updCnt = adjustDao.selectAdjustUpdatePayAmouCnt((String)saveMap.get("sale_sequ_numb"));
			if(updCnt > 0) {	//수기로 입력한 반제금액이 매출금액보다 크거나 같으면 Sap 매출반제번호에 임시로 -9를 업데이트 한다.(왜냐면 해당매출대상에 Sap 반제 스케줄을 제외 하기 위해)
				adjustDao.updateAdjustUpdateTempPayAmouNumb((String)saveMap.get("sale_sequ_numb"));
			}
			
			//기존채권이 관리일경우 현재 채권상태를 검색
			if("1".equals(firstTranStatFlagDto.getTranStatFlag())){
				//채권의 현재 상태를 검색
				AdjustDto tranStatFlagDto = (AdjustDto)generalDao.selectGernalObject("adjust.selectMssalmTranStatFlag", paramMap);
				//채권이 관리에서 정상으로 변경 되었을 경우 해당 채권의 사업장을 검색
				if("0".equals(tranStatFlagDto.getTranStatFlag())){
					paramMap.put("branchId", tranStatFlagDto.getBranchId().toString());
					Map<String, Object> tranStatFlagBranchInfo = (Map<String, Object>)generalDao.selectGernalObject("adjust.selectTranStatFlagBranchInfo", paramMap);
					int tranStatFlagBranchCnt = Integer.parseInt(tranStatFlagBranchInfo.get("CNT").toString());
					//해당 사업장의 채권중 관리 채권이 없는 경우 담당자에게 메일 전송
					if(tranStatFlagBranchCnt == 0){
						paramMap.put("codeTypeCd", "BONDS_MANAGER");
						//담당자는 코드로 관리
						List list = generalDao.selectGernalList("adjust.selectBondsManagerInfo", paramMap);
						List<Map<String, Object>> bondsMangerInfo = (List<Map<String, Object>>)list;
						for(int i=0; i<bondsMangerInfo.size(); i++){
							String receiveMailer = bondsMangerInfo.get(i).get("email").toString()+";";
							String mailMsg = "["+tranStatFlagBranchInfo.get("BRANCHNM").toString()+"] 사업장 관리 채권이 회수 되었으니 <br>주문제한 해제 요청 드립니다.";
							commonSvc.saveSendMail(receiveMailer, "[OK플라자] 주문제한 해제 요청["+tranStatFlagBranchInfo.get("BRANCHNM").toString()+"]", mailMsg);
						}
					}
				}
			}
			
		}else if("del".equals(saveMap.get("oper").toString())){
			adjustDao.deleteMptrec(saveMap);
			double rece_pay_amou  		= Double.parseDouble(saveMap.get("rece_pay_amou").toString());		// 삭제될 처리금액
			// 삭제의 경우 금액차감임으로 (-)금액이 들어오면 입금금액 (+)처리   (+)금액이 들어오면 (-)처리 한다.
			String operFlag 			= rece_pay_amou >= 0 ? "20" : "10" ;

			saveMap.put("operFlag"		, operFlag);
			saveMap.put("rece_pay_amou"	, Math.abs(rece_pay_amou));
			adjustDao.updateSalesDeposit(saveMap);
		}
	}
	
	public List<AdjustDto> adjustSalesDepositDescList(Map<String, Object> params){
		return adjustDao.adjustSalesDepositDescList(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void salesDepositConfirm(Map<String, Object> saveMap) throws Exception{
		String[] rtnArr = salesDepositApply(saveMap);
		
		if("0".equals(rtnArr[0])){
			throw new Exception("전표번호["+saveMap.get("sap_jour_numb")+"] 	\n결과["+rtnArr[2]+"]");
		}

		saveMap.put("oper"			, "add");
		saveMap.put("pay_amou_numb"	, rtnArr[0]);	//반제번호
		saveMap.put("rece_pay_amou"	, rtnArr[1]);	//반제금액
		saveMap.put("context",rtnArr[2]);
		saveMap.put("payDate",rtnArr[3]);
		
		this.saveDepositDetail(saveMap);
	}
	
	//매출반제수신
	public String[] salesDepositApply(Map<String, Object> saveMap) throws Exception{
		JcoAdapter jcoAdapter = new JcoAdapter();
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("I_BUKRS" , "SKTS"  ); // 01. 회사 코드
		param.put("I_GJAHR" , saveMap.get("clos_sale_date").toString().replace("-", "").substring(0, 4)  ); // 02. 회계연도
//		param.put("I_GJAHR" , "2010"  ); // 02. 회계연도
		param.put("I_BELNR" , saveMap.get("sap_jour_numb")  ); // 03. 전표번호
//		param.put("I_BELNR" , "3700011002"  ); // 03. 전표번호
		
		List<Map<String, Object>> rfcResultList = jcoAdapter.callRfcTypeNTable("Z_FI_SEND_AR", param, "T_FIDOC", "ZREMSG");
		String[] rtnArr = new String[4];

		if(rfcResultList != null && rfcResultList.size() > 0){
			Map<String, Object> resultMap = rfcResultList.get(0);	
			
			rtnArr[0] = resultMap.get("AUGBL").toString();
			rtnArr[1] = resultMap.get("DMBTR").toString();
			rtnArr[2] = "반제금액 [" + resultMap.get("DMBTR").toString() + "] 이 처리되었습니다.";
			rtnArr[3] = resultMap.get("AUGDT").toString();
		}else{
			rtnArr[0] = "0";
			rtnArr[1] = "0";
			rtnArr[2] = jcoAdapter.getReturnMessage();
			rtnArr[3] = "";
		}
		return rtnArr;
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})	
	public void savePaymentDetail(Map<String, Object> saveMap) throws Exception{
		if("add".equals(saveMap.get("oper").toString())){
			String rece_sequ_num = seqMptrec.getNextStringId();
			saveMap.put("rece_sequ_num", rece_sequ_num);
			adjustDao.insertMptpay(saveMap);
			
			double rece_pay_amou = Double.parseDouble("".equals(saveMap.get("rece_pay_amou").toString())?"0":saveMap.get("rece_pay_amou").toString());			//입금금액
			String operFlag = rece_pay_amou >= 0 ? "10" : "20" ;	// 입금금액의 입금/차감여부 (-금액이 들어올수 있음으로 체크 [10 : plus, 20 : minus])
			
			saveMap.put("operFlag"			, operFlag);
			saveMap.put("rece_pay_amou"		, Math.abs(rece_pay_amou));
			adjustDao.updatePurchasePayment(saveMap);			
			
		}else if("del".equals(saveMap.get("oper").toString())){

			adjustDao.deleteMptpay(saveMap);
			double rece_pay_amou  		= Double.parseDouble(saveMap.get("rece_pay_amou").toString());		// 삭제될 처리금액
			// 삭제의 경우 금액차감임으로 (-)금액이 들어오면 입금금액 (+)처리   (+)금액이 들어오면 (-)처리 한다.
			String operFlag = rece_pay_amou >= 0 ? "20" : "10" ;

			saveMap.put("operFlag"		, operFlag);
			saveMap.put("rece_pay_amou"	, Math.abs(rece_pay_amou));
			adjustDao.updatePurchasePayment(saveMap);
		}	
	}
	
	public List<AdjustDto> adjustPurchasePaymentDescList(Map<String, Object> params){
		return adjustDao.adjustPurchasePaymentDescList(params);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void salesPaymentConfirm(Map<String, Object> saveMap) throws Exception{
		String[] rtnArr = salesPaymentApply(saveMap);
		
		if("0".equals(rtnArr[0])){
			throw new Exception("전표번호["+saveMap.get("sap_jour_numb")+"] 	\n결과["+rtnArr[2]+"]");
		}
		logger.info("pay_amou_numb : "+rtnArr[0]);
		logger.info("rece_pay_amou : "+rtnArr[1]);
		logger.info("context : "+rtnArr[2]);
		logger.info("payDate : "+rtnArr[3]);
		logger.info("ele_etc_date : "+rtnArr[4]);
		logger.info("expiration_date : "+rtnArr[5]);
		
		saveMap.put("oper"			, "add");
		saveMap.put("pay_amou_numb"	, rtnArr[0]);	//반제번호
		saveMap.put("rece_pay_amou"	, rtnArr[1]);	//반제금액
		saveMap.put("context",rtnArr[2]);
		saveMap.put("payDate",rtnArr[3]);
		saveMap.put("ele_etc_date", rtnArr[4]);//전자외담발행일
		saveMap.put("etc_expiration_date", rtnArr[5]);//외담대만기도래일//필요없어져서 쿼리업데이트문에서만 삭제
		this.savePaymentDetail(saveMap);
	}
	
	//매입반제수신
	public String[] salesPaymentApply(Map<String, Object> saveMap) throws Exception{
		JcoAdapter jcoAdapter = new JcoAdapter();
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("I_BUKRS" , "SKTS"  ); // 01. 회사 코드
		param.put("I_GJAHR" , saveMap.get("clos_buyi_date").toString().replace("-", "").substring(0, 4)  ); // 02. 회계연도
//		param.put("I_GJAHR" , "2010"  ); // 02. 회계연도
		param.put("I_BELNR" , saveMap.get("sap_jour_numb")  ); // 03. 전표번호
//		param.put("I_BELNR" , "3700011002"  ); // 03. 전표번호
		
		List<Map<String, Object>> rfcResultList = jcoAdapter.callRfcTypeNTable("Z_FI_SEND_AP", param, "T_FIDOC", "ZREMSG");
		List<Map<String, Object>> rfcResultList2 = jcoAdapter.callRfcTypeNTable("Z_FI_SEND_DETAIL", param, "T_FIDOC", "ZREMSG");
		String[] rtnArr = new String[6];
		logger.info("rfcResultList : "+rfcResultList.size());

		if(rfcResultList != null && rfcResultList.size() > 0){
			
			Map<String, Object> resultMap = rfcResultList.get(0);	
			
			long payAmou = Long.parseLong(resultMap.get("DMBTR").toString());
			
//			payAmou = Math.abs(payAmou);//절대값불러오기
			
			if(payAmou > 0){
				payAmou = Long.parseLong("-" + payAmou); 
			}else{
				payAmou = Long.parseLong(Long.toString(payAmou).replace("-", ""));
			}
//			
			
			rtnArr[0] = resultMap.get("AUGBL").toString();
			rtnArr[1] = String.valueOf(payAmou);
			rtnArr[2] = "반제금액 [" + payAmou + "] 이 처리되었습니다.";
			rtnArr[3] = resultMap.get("AUGDT").toString();
			rtnArr[4] = resultMap.get("ZUONR").toString();
		}else{
			rtnArr[0] = "0";
			rtnArr[1] = "0";
			rtnArr[2] = jcoAdapter.getReturnMessage();
			rtnArr[3] = "";
			rtnArr[4] = "";
		}
		if(rfcResultList2 != null && rfcResultList2.size() > 0){
			Map<String, Object> resultMap2 = rfcResultList2.get(0);
			rtnArr[5] = resultMap2.get("ZFBDT").toString();
		}else{
			rtnArr[5] = "";
		}
		return rtnArr;
	}
	
	public Map<String,Object> adjustBondsTotalListCnt(Map<String, Object> params){
		return adjustDao.adjustBondsTotalListCnt(params);
	}	
	
	public List<AdjustDto> adjustBondsTotalList(Map<String, Object> params, int page, int rows){
		return adjustDao.adjustBondsTotalList(params, page, rows);
	}	

	public List<AdjustDto> adjustBondsCompanyList(Map<String, Object> params){
		return adjustDao.adjustBondsCompanyList(params);
	}	
	
	public AdjustDto adjustBondsCompanyPriceInfo(Map<String, Object> params) {
		return adjustDao.adjustBondsCompanyPriceInfo(params);
	}
	
	public void updateSmpBorgsIsLimit(Map<String, Object> saveMap) {
		adjustDao.updateSmpBorgsIsLimit(saveMap);
	}
	
	public List<UserDto> getAdjustAlramUserList (){
		return adjustDao.getAdjustAlramUserList();
	}
	
	public int adjustDebtTotalListCnt (Map<String, Object> paramMap) {
		return adjustDao.adjustDebtTotalListCnt(paramMap);
	}

	public List<AdjustDto> adjustDebtTotalList (Map<String, Object> paramMap, int page, int rows) {
		return adjustDao.adjustDebtTotalList(paramMap, page, rows);
	}

	public List<AdjustDto> adjustDebtCompanyList (Map<String, Object> paramMap) {
		return adjustDao.adjustDebtCompanyList(paramMap);
	}
	public List<HashMap<String, Object>> selectBranchsByClientId(String clientId){
		return adjustDao.selectBranchsByClientId(clientId);
	}
	public List<Map<String, Object>> adjustSalesTransmissionListForExcel (Map<String, Object> paramMap) {
		return adjustDao.adjustSalesTransmissionListForExcel(paramMap);
	}
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel5Month (Map<String, Object> paramMap) {
		return adjustDao.adjustBondsTotalStdMonthExcel5Month(paramMap);
	}
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel30Month (Map<String, Object> paramMap) {
		return adjustDao.adjustBondsTotalStdMonthExcel30Month(paramMap);
	}

	public Map<String, Object> selectPayBillTypeCd (String param) {
		return adjustDao.selectPayBillTypeCd(param);
	}
	
	/**
	 * 매출부분취소에서 매출아이디를 null로만듬
	 * @param saveMap
	 * @return
	 */
	@Deprecated
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public int modSalesConfirmPartCancel(Map<String, Object> saveMap) {
		String[] orde_iden_numb = (String[])saveMap.get("orde_iden_numb_Arr");
		String[] orde_sequ_numb = (String[])saveMap.get("orde_sequ_numb_Arr");
		String[] purc_iden_numb = (String[])saveMap.get("purc_iden_numb_Arr");
		String[] deli_iden_numb = (String[])saveMap.get("deli_iden_numb_Arr");
		int resultCnt = 0;
		for(int i=0; i<orde_iden_numb.length; i++){
			saveMap.put("orde_iden_numb", orde_iden_numb[i]);
			saveMap.put("orde_sequ_numb", orde_sequ_numb[i]);
			saveMap.put("purc_iden_numb", purc_iden_numb[i]);
			saveMap.put("deli_iden_numb", deli_iden_numb[i]);
			resultCnt = adjustDao.modSalesConfirmPartCancel(saveMap);
		}
		return resultCnt;
	}
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void modSalesConfirmPartCancel(String sale_sequ_numb, String whereString) throws Exception {
		adjustDao.updateSalesConfirmPartCancel(whereString);
		
		/*---------------------------------매출헤더합계 업데이트---------------------------------*/
		Map<String, Object> saveMap = new HashMap<String, Object>();
		saveMap.put("sale_sequ_numb", sale_sequ_numb);
		double requAmou = 0;
		double requVTax = 0;
		double totalAmou = 0;
		List<AdjustDto> adjustCreatList = this.adjustCreatList(saveMap);
		if(adjustCreatList != null && adjustCreatList.size() > 0){
			for(AdjustDto adjustDto : adjustCreatList) {
				requAmou += Double.parseDouble(adjustDto.getSale_prod_amou());
				requVTax += Double.parseDouble(adjustDto.getSale_prod_tax());
			}
			logger.debug("requVTax1 : "+requVTax);
			requVTax = Math.floor(requVTax);
			logger.debug("requVTax2 : "+requVTax);
			totalAmou = requAmou + requVTax;
			saveMap.put("sale_requ_amou", requAmou);
			saveMap.put("sale_requ_vtax", requVTax);
			saveMap.put("sale_tota_amou", totalAmou);
		}else{
			saveMap.put("sale_requ_amou", 0);
			saveMap.put("sale_requ_vtax", 0);
			saveMap.put("sale_tota_amou", 0);
		}
		adjustDao.updateMssalmAmou(saveMap);
	}
	
	/**
	 * 매출부분취소시 매출금액과 부가세 합계를 다시계산
	 * @param saveMap
	 */
	@Deprecated
	public void modSaleCashCalc(Map<String, Object> saveMap) {
		int cnt = 0;
		cnt = adjustDao.selectSaleCashCalcCnt(saveMap);
		if(cnt > 0){
			adjustDao.modSaleCashCalc(saveMap);
		}else if (cnt == 0){
			adjustDao.modAdjustSalesConfirm(saveMap);
		}
	}

	public int adjustBorgDialogListCnt(Map<String, Object> params) {
		return adjustDao.selectAdjustBorgDialogCnt(params);
	}

	public List<BorgDto> adjustBorgDialogList(Map<String, Object> params, int page, int rows) {
		return adjustDao.selectAdjustBorgDialog(params,page,rows);
	}
	
	/**
	 * 업체별현황 리스트에서 정상이면 만기일 변경가능
	 */
	public void modExpirationDate(Map<String, Object> saveMap) {
		String[] sale_sequ_numb = (String[])saveMap.get("sale_sequ_numb_Arr"); 
		String[] expiration_date = (String[])saveMap.get("expiration_date_Arr");
		for(int i=0; i<sale_sequ_numb.length; i++){
			saveMap.put("sale_sequ_numb", sale_sequ_numb[i]);
			saveMap.put("expiration_date", expiration_date[i]);
			adjustDao.modExpirationDate(saveMap);
		}
	}
	/**
	 * 같은 매출일 경우 업데이트 처리 되지않게 처리
	 * @param string
	 * @return
	 */
	public int getAdjustSapNumCount(String saleSequNumb) {
		return adjustDao.selectAdjustSapNumCount(saleSequNumb);
	}

	/**
	 * 매출번호로 매출전송정보 가져오기
	 * @param saleSequNumb
	 * @return
	 */
	public Map<String, Object> getAdjustInfoBySaleSequNumb(String saleSequNumb) {
		return adjustDao.selectAdjustInfoBySaleSequNumb(saleSequNumb);
	}

	/**
	 * 매입번호로 매출전송정보 가져오기
	 * @param buyiSequNumb
	 * @return
	 */
	public Map<String, Object> getAdjustInfoByBuyiSequNumb(String buyiSequNumb) {
		return adjustDao.selectAdjustInfoByBuyiSequNumb(buyiSequNumb);
	}
	
	/**
	 * 매입취소를 위한 매입취소정보 가져오기
	 * @param buyiSequNumb
	 * @return
	 */
	public Map<String, Object> getMsbuymInfo(String buyiSequNumb) {
		return adjustDao.selectMsbuymInfo(buyiSequNumb);
	}
	
	/**
	 * 
	 * @param saveMap
	 */
	public void transferStatusChange(Map<String, Object> saveMap) {
		String[] salesSequNumb = (String []) saveMap.get("sale_sequ_numb_Arr");
		String[] transferStatus = (String []) saveMap.get("transfer_status_Arr");
		for(int i=0; i<salesSequNumb.length; i++){
			saveMap.put("saleSequNumb", salesSequNumb[i]);
			saveMap.put("transferStatus", transferStatus[i]);
			adjustDao.updateTransferStatus(saveMap);
		}
	}

	/**
	 * 채권월령표 3개월
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel3Month(Map<String, Object> params) {
		return adjustDao.adjustBondsTotalStdMonthExcel3Month(params);
	}
	
	/**
	 * 채권월령표 6개월
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel6Month(Map<String, Object> params) {
		return adjustDao.adjustBondsTotalStdMonthExcel6Month(params);
	}

	/**
	 * 채권월령표 12개월
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel12Month(Map<String, Object> params) {
		return adjustDao.adjustBondsTotalStdMonthExcel12Month(params);
	}
	
	
	/**
	 * 법인별 채권월령표 3개월
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel3MonthClient(Map<String, Object> params) {
		return adjustDao.adjustBondsTotalStdMonthExcel3MonthClient(params);
	}
	
	/**
	 * 법인별 채권월령표 6개월
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel6MonthClient(Map<String, Object> params) {
		return adjustDao.adjustBondsTotalStdMonthExcel6MonthClient(params);
	}
	
	/**
	 * 법인별 채권월령표 12개월
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel12MonthClient(Map<String, Object> params) {
		return adjustDao.adjustBondsTotalStdMonthExcel12MonthClient(params);
	}
	
	/**
	 * 법인별 채권월령표 30개월
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel30MonthClient(Map<String, Object> params) {
		return adjustDao.adjustBondsTotalStdMonthExcel30MonthClient(params);
	}
	
	/**
	 * 고객사 채무관리 JQGrid
	 */
	public List<AdjustDto> adjustBranchBondsCompanyList(Map<String, Object> params) {
		return adjustDao.adjustBranchBondsCompanyList(params);
	}
	
	
	/**
	 * 공급사 채무관리 JQGrid
	 */
	public List<AdjustDto> adjustVenDebtCompanyList(Map<String, Object> params) {
		return adjustDao.adjustVenDebtCompanyList(params);
	}

	public List<AdjustDto> adjusVentPurcConfirmDetailList(Map<String, Object> params) {
		List<AdjustDto> tmpList = adjustDao.adjustVenPurcConfirmDetailList(params);
		AdjustDto addAdjustDto = new AdjustDto();
		addAdjustDto.setOrde_type_clas_nm("총계");
		double sum_sale_prod_quan = 0;
		double sum_purc_prod_pris = 0;
		double sum_purc_prod_amou = 0;
		double sum_purc_prod_tax = 0;
		double sum_buyi_tota_amou = 0;
		for(AdjustDto adjustDto : tmpList) {
			sum_sale_prod_quan += Double.parseDouble(adjustDto.getSale_prod_quan());
			sum_purc_prod_pris += Double.parseDouble(adjustDto.getPurc_prod_pris());
			sum_purc_prod_amou += Double.parseDouble(adjustDto.getPurc_prod_amou());
			sum_purc_prod_tax += Double.parseDouble(adjustDto.getPurc_prod_tax());
			sum_buyi_tota_amou += Double.parseDouble(adjustDto.getBuyi_tota_amou());
		}
		addAdjustDto.setSale_prod_quan(String.valueOf(sum_sale_prod_quan));
		addAdjustDto.setPurc_prod_pris(String.valueOf(sum_purc_prod_pris));
		addAdjustDto.setPurc_prod_amou(String.valueOf(sum_purc_prod_amou));
		addAdjustDto.setPurc_prod_tax(String.valueOf(sum_purc_prod_tax));
		addAdjustDto.setBuyi_tota_amou(String.valueOf(sum_buyi_tota_amou));
		tmpList.add(addAdjustDto);
		
		return tmpList;
	}
	
	/**
	 * 매출반제 현황 상세반제 내역(입금일자) Excel 출력
	 */
	public List<Map<String, Object>> adjustSalesTransmissionPayDateListForExcel(Map<String, Object> params) {
		return adjustDao.adjustSalesTransmissionPayDateListForExcel(params);
	}

	/**
	 * 정산수불부 카운트(계산서일자로 매출매입 각각 계산)
	 */
	public int adjustBalanceListCnt2(Map<String, Object> params) {
		return adjustDao.adjustBalanceListCnt2(params);
	}
	
	/**
	 * 정산수불부 리스트2(계산서일자로 매출매입 각각 계산)
	 */
	public List<AdjustDto> adjustBalanceList2(Map<String, Object> params, int page, int rows) {
		return adjustDao.adjustBalanceList2(params, page, rows);
	}

	public int adjustBalanceDetailCnt2(Map<String, Object> params) {
		return adjustDao.adjustBalanceDetailCnt2(params);
	}

	public List<AdjustDto> adjustBalanceDetail2(Map<String, Object> params,	int page, int rows) {
		return adjustDao.adjustBalanceDetail2(params, page, rows);
	}
	
	/**
	 * 정산수불부 (매출세금계산서 일자로 변경)
	 */
	public List<AdjustDto> adjustBalanceList3(Map<String, Object> params,int page, int rows) {
		return adjustDao.adjustBalanceList3(params, page, rows);
	}

	public void etcExpirationDateSave(Map<String, Object> saveMap) throws Exception{
		String[] buyiSequNumb = (String[])saveMap.get("buyiSequNumbArray");
		String[] etcExpirationDate = (String[])saveMap.get("etcExpirationDateArray");
		for(int i=0; i<buyiSequNumb.length; i++){
			Map<String, Object> tempMap = new HashMap<String, Object>();
			tempMap.put("buyiSequNumb", buyiSequNumb[i]);
			tempMap.put("etcExpirationDate", etcExpirationDate[i]);
			adjustDao.etcExpirationDateSave(tempMap);
		}
	}

	/**
	 * 매입부분취소
	 * @param saveMap
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void purchaseConfirmPartCancel(Map<String, Object> saveMap) throws Exception{
		//매입전송여부체크
		int msbuymCheck = adjustDao.getMsbuymInfoCheck(saveMap);
		
		if(msbuymCheck >0){
			String[] ordeIdenNumbArray = (String[])saveMap.get("ordeIdenNumbArray"); 
			String[] ordeSequNumbArray = (String[])saveMap.get("ordeSequNumbArray"); 
			String[] purcIdenNumbArray = (String[])saveMap.get("purcIdenNumbArray"); 
			String[] deliIdenNumbArray = (String[])saveMap.get("deliIdenNumbArray");
			String[] receIdenNumbArray = (String[])saveMap.get("receIdenNumbArray"); 
//			String buyiSequNumb = (String)saveMap.get("buyiSequNumb"); 
			for(int i=0; i<ordeIdenNumbArray.length; i++){
				saveMap.put("ordeIdenNumb", ordeIdenNumbArray[i]);
				saveMap.put("ordeSequNumb", ordeSequNumbArray[i]);
				saveMap.put("purcIdenNumb", purcIdenNumbArray[i]);
				saveMap.put("deliIdenNumb", deliIdenNumbArray[i]);
				saveMap.put("receIdenNumb", receIdenNumbArray[i]);
				adjustDao.updatePurchaseConfirmPartCancel(saveMap);
			}
			int mrordtListCheck = adjustDao.getMrordtListBuyiSequNumbCheck(saveMap);
			if(mrordtListCheck > 0){
				adjustDao.updateMsbuymInfo(saveMap);
			}else{
				adjustDao.deleteMsbuymInfo(saveMap);
			}
		}
	}

	public Map<String, Object> selectSumupContent(Map<String, Object> params) {
		return adjustDao.selectSumupContent(params);
	}
	
	/**
	 * 매출반제 입금현황 등록
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateReceSaleStatus(Map<String, Object> saveMap) {
		String[] receSequNum = (String[])saveMap.get("receSequNumArray");
		String[] receSaleStatus = (String[])saveMap.get("receSaleStatusArray");
		for(int i=0; i<receSequNum.length; i++){
			saveMap.put("receSequNum", receSequNum[i]);
			saveMap.put("receSaleStatus", receSaleStatus[i]);
			adjustDao.updateReceSaleStatus(saveMap);
		}
	}

//	public int adjustBondsPlanListCnt(ModelMap paramMap) {
//		return generalDao.selectGernalCount("adjust.adjustBondsPlanListCnt", paramMap);
//	}
	public List<Map<String, String>> adjustBondsPlanList(ModelMap paramMap, int page, int rows) {
		return adjustDao.adjustBondsPlanList(paramMap, page, rows);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> adjustBondsPlanListMap(ModelMap paramMap) {
		return (Map<String, Object>) generalDao.selectGernalObject("adjust.adjustBondsPlanListMap", paramMap);
	}

	public List<Map<String, String>> getMonthBondsList(Map<String, Object> params) {
		return adjustDao.getMonthBondsList(params);
	}

	public List<Map<String, String>> getBondsTypeList(Map<String, Object> params) {
		return adjustDao.getBondsTypeList(params);
	}

	public List<Map<String, String>> getBondsLateList(Map<String, Object> params) {
		return adjustDao.getBondsLateList(params);
	}
	
	public List<Map<String, String>> getBondsReturnList1(Map<String, Object> params) {
		return adjustDao.getBondsReturnList1(params);
	}
	
	public List<Map<String, String>> getBondsReturnList2(Map<String, Object> params) {
		return adjustDao.getBondsReturnList2(params);
	}

	public void saveBondsPlan(Map<String, Object> saveMap) {

		String[] saleSequArr = (String[])saveMap.get("saleSequArr");
		String[] planAmou1Arr = (String[])saveMap.get("planAmou1Arr");
		String[] planDate1Arr = (String[])saveMap.get("planDate1Arr");
		String[] planAmou2Arr = (String[])saveMap.get("planAmou2Arr");
		String[] planDate2Arr = (String[])saveMap.get("planDate2Arr");
		
		
		if(saleSequArr != null && saleSequArr.length > 0){
			for(int i = 0 ; i < saleSequArr.length ; i++){
				Map<String, String> paramsMap = new HashMap<String, String>();
				String planAmou1 = CommonUtils.getString(planAmou1Arr[i]);
				String planDate1 = CommonUtils.getString(planDate1Arr[i]);
				String planAmou2 = CommonUtils.getString(planAmou2Arr[i]);
				String planDate2 = CommonUtils.getString(planDate2Arr[i]);
				
				paramsMap.put("sale_sequ_numb", saleSequArr[i]);
				paramsMap.put("userId"		  , CommonUtils.getString(saveMap.get("userId")));
				
				if(!"".equals(planAmou1)){
					paramsMap.put("planAmou1", planAmou1);
					paramsMap.put("planDate1", planDate1);
				}
				
				if(!"".equals(planAmou2)){
					paramsMap.put("planAmou2", planAmou2);
					paramsMap.put("planDate2", planDate2);
				}
				
				int getPlanCount = adjustDao.getPlanCount(paramsMap);
				
				if(getPlanCount > 0){ 	//update
					adjustDao.updateBondPlans(paramsMap);
				}else{					//insert
					adjustDao.insertBondPlans(paramsMap);
				}
			}
		}
	}

	public int adjustBondsTypeDetailCnt(Map<String, Object> params) {
		return adjustDao.adjustBondsTypeDetailCnt(params);
	}
	
	public List<Map<String, String>> adjustBondsTypeDetail(Map<String, Object> params,int page, int rows) {
		return adjustDao.adjustBondsTypeDetail(params,page,rows);
	}

	public List<Map<String, String>> adjustBondsHistList(Map<String, Object> params) {
		return adjustDao.adjustBondsHistList(params);
	}

	public void saveBondsHistory(Map<String, Object> saveMap) throws Exception {
		
		if("add".equals(saveMap.get("oper"))){
			saveMap.put("bond_manage_id", seqBondsHist.getNextStringId());
			adjustDao.insertBondsHistory(saveMap);
		}else if("mod".equals(saveMap.get("oper"))){
			adjustDao.updateBondsHistory(saveMap);
		}
	}

	public int getBondsMonthDetailCnt(Map<String, Object> params) {
		return adjustDao.getBondsMonthDetailCnt(params);
	}
	
	public List<Map<String, String>> getBondsMonthDetail(Map<String, Object> params,int page, int rows) {
		return adjustDao.getBondsMonthDetail(params,page,rows);
	}
}
