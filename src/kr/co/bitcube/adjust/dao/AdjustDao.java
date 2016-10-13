package kr.co.bitcube.adjust.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.adjust.dto.AdjustDto;
import kr.co.bitcube.common.dto.BorgDto;
import kr.co.bitcube.common.dto.UserDto;

import org.apache.ibatis.session.RowBounds;
import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.ui.ModelMap;

@Repository
public class AdjustDao {
	
	private final String statement = "adjust.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<AdjustDto> adjustGenerationList (Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustGenerationList", params);
	}

	public List<AdjustDto> adjustCreatList (Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustCreatList", params);
	}

	public List<AdjustDto> adjustGenerationMasterList (Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustGenerationMasterList", params);
	}
	public List<AdjustDto> adjustGenerationMasterListForAll (Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustGenerationMasterListForAll", params);
	}
	
	public void insertAdjustMaster (Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "insertAdjustMaster", saveMap);
	}

	public int insertAdjustMasterAll (Map<String, Object> saveMap) {
		int resultCnt = sqlSessionTemplate.insert(this.statement + "insertAdjustMasterAll", saveMap);
		return resultCnt;
	}

	public void updateSequenceToSaleMaster () {
		sqlSessionTemplate.update(this.statement + "updateSequenceToSaleMaster");
	}
	
	public void delAdjustMaster (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "delAdjustMaster", saveMap);
	}	
	
	public void addAdjustCreatList (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "addAdjustCreatList", saveMap);
	}
	
	public void updMrordtListForDivision (Map<String, Object> saveMap){
		sqlSessionTemplate.update(this.statement + "updMrordtListForDivision", saveMap);
	}

	public void insMrordtListForDivision (Map<String, Object> saveMap){
		sqlSessionTemplate.update(this.statement + "insMrordtListForDivision", saveMap);
	}

	public void removeAdjustCreatList (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "removeAdjustCreatList", saveMap);
	}

	public void updateMssalmAmou (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updateMssalmAmou", saveMap);
	}

	public void updateAdjustCreatList (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updateAdjustCreatList", saveMap);
	}
	
	public int adjustSalesConfirmListCnt(Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "adjustSalesConfirmListCnt", paramMap);
	}

	public List<AdjustDto> adjustSalesConfirmList (Map<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement + "adjustSalesConfirmList", paramMap, rowBounds);
	}

	public int adjustSalesConfirmDetailListCnt(Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "adjustSalesConfirmDetailListCnt", paramMap);
	}
	
	public List<AdjustDto> adjustSalesConfirmDetailList (Map<String, Object> paramMap, int page, int rows) {
		if(page == -1 && rows == -1){
			return sqlSessionTemplate.selectList(this.statement + "adjustSalesConfirmDetailList", paramMap);
		}else{
			RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
			return sqlSessionTemplate.selectList(this.statement + "adjustSalesConfirmDetailList", paramMap, rowBounds);
		}
	}
	
	public List<AdjustDto> adjustSalesConfirmDetailList (Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectList(this.statement + "adjustSalesConfirmDetailList", paramMap);
	}
	
	public void modAdjustConfirm (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "modAdjustConfirm", saveMap);
	}
	
	public int selectAdjustConfirmCnt(Map<String, Object> saveMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "selectAdjustConfirmCnt", saveMap);
	}
	
	public int selectAdjustBuyConfirmCnt(Map<String, Object> saveMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "selectAdjustBuyConfirmCnt", saveMap);
	}
	
	public int adjustPurcConfirmListCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "adjustPurcConfirmListCnt", paramMap);
	}	
	
	public double selectPurcConfirmSum(Map<String, Object> paramMap) {
		String purcConfirmSum = sqlSessionTemplate.selectOne(this.statement + "selectPurcConfirmSum", paramMap);
		if(purcConfirmSum == null) return 0;
		else return Double.parseDouble(purcConfirmSum); 
	}
	
	public List<AdjustDto> adjustPurcConfirmList (Map<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement + "adjustPurcConfirmList", paramMap, rowBounds);
	}	

	public int adjustPurcCancelListCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "adjustPurcCancelListCnt", paramMap);
	}	
	
	public List<AdjustDto> adjustPurcCancelList (Map<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement + "adjustPurcCancelList", paramMap, rowBounds);
	}	

	public List<AdjustDto> adjustPurcConfirmDetailList(Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectList(this.statement + "adjustPurcConfirmDetailList", paramMap);
	}
	
	public void insertMsBuyM(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "insertMsBuyM", saveMap);
	}

	public void addPurcDetailList(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "addPurcDetailList", saveMap);
	}

	public void modPurcDetailList(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "modPurcDetailList", saveMap);
	}

	public void deleteMsBuyM(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "deleteMsBuyM", saveMap);
	}
	
	public int adjustBalanceListCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "adjustBalanceListCnt", paramMap);
	}
	
	public List<AdjustDto> adjustBalanceList (Map<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement + "adjustBalanceList", paramMap, rowBounds);
	}
	
	public int adjustBalanceDetailCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "adjustBalanceDetailCnt", paramMap);
	}
	
	public List<AdjustDto> adjustBalanceDetail (Map<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement + "adjustBalanceDetail", paramMap, rowBounds);
	}

	public int adjustSalesTransmissionListCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "adjustSalesTransmissionListCnt", paramMap);
	}
	
	public List<AdjustDto> adjustSalesTransmissionList (Map<String, Object> paramMap, int page, int rows) {
		if(page == -1 || rows == -1){
			return sqlSessionTemplate.selectList(this.statement + "adjustSalesTransmissionList", paramMap);
		}else{
			RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
			return sqlSessionTemplate.selectList(this.statement + "adjustSalesTransmissionList", paramMap, rowBounds);
		}
	}
	
	public void updateAdjustSalesTrans (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updateAdjustSalesTrans", saveMap);
	}

	public void updateAdjustSalesTransCancel (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updateAdjustSalesTransCancel", saveMap);
	}

	public int adjustPurchaseTransmissionListCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "adjustPurchaseTransmissionListCnt", paramMap);
	}
	
	public List<AdjustDto> adjustPurchaseTransmissionList (Map<String, Object> paramMap, int page, int rows) {
		if(page == -1 || rows == -1){
			return sqlSessionTemplate.selectList(this.statement + "adjustPurchaseTransmissionList", paramMap);
		}else{
			RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
			return sqlSessionTemplate.selectList(this.statement + "adjustPurchaseTransmissionList", paramMap, rowBounds);
		}
	}
	
	public void updateAdjustPurchaseTrans (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updateAdjustPurchaseTrans", saveMap);
	}

	public void updateAdjustPurchaseTransCancel (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updateAdjustPurchaseTransCancel", saveMap);
	}

	public void insertMptrec (Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "insertMptrec", saveMap);
	}

	public void updateSalesDeposit (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updateSalesDeposit", saveMap);
	}

	public List<AdjustDto> adjustSalesDepositDescList (Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustSalesDepositDescList", params);
	}
	
	public void insertMptpay (Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "insertMptpay", saveMap);
	}

	public void updatePurchasePayment (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updatePurchasePayment", saveMap);
	}
	
	public List<AdjustDto> adjustPurchasePaymentDescList (Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustPurchasePaymentDescList", params);
	}
	
	public Map<String,Object> adjustBondsTotalListCnt(Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectOne(this.statement + "adjustBondsTotalListCnt", paramMap);
	}

	public List<AdjustDto> adjustBondsTotalList (Map<String, Object> paramMap, int page, int rows) {
		if(page == -1 || rows == -1){
			return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalList", paramMap);
		}else{
			RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
			return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalList", paramMap, rowBounds);
		}
	}

	public List<AdjustDto> adjustBondsCompanyList (Map<String, Object> paramMap) {
		
		Logger logger = Logger.getLogger("AujustDao");
		
		logger.debug("adjustBondsCompanyList Start ::::::::::::::::::");
		
		List<AdjustDto> tmpList = sqlSessionTemplate.selectList(this.statement + "adjustBondsCompanyList", paramMap); 
		logger.debug("adjustBondsCompanyList End ::::::::::::::::::");
		return tmpList;
	}
	
	public AdjustDto adjustBondsCompanyPriceInfo(Map<String, Object> paramMap) {
		return (AdjustDto)sqlSessionTemplate.selectOne(this.statement + "adjustBondsCompanyPriceInfo", paramMap);
	}
	
	public void updateSmpBorgsIsLimit(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updateSmpBorgsIsLimit", saveMap);
	}
	
	public List<UserDto> getAdjustAlramUserList () {
		return sqlSessionTemplate.selectList(this.statement + "getAdjustAlramUserList");
	}
	
	public void deleteMptrec (Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement + "deleteMptrec", saveMap);
	}
	
	public void deleteMptpay (Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement + "deleteMptpay", saveMap);
	}

	public int adjustDebtTotalListCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "adjustDebtTotalListCnt", paramMap);
	}
	
	public List<AdjustDto> adjustDebtTotalList (Map<String, Object> paramMap, int page, int rows) {
		if(page == -1 || rows == -1){
			return sqlSessionTemplate.selectList(this.statement + "adjustDebtTotalList", paramMap);
		}else{
			RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
			return sqlSessionTemplate.selectList(this.statement + "adjustDebtTotalList", paramMap, rowBounds);
		}
	}
		
	public List<AdjustDto> adjustDebtCompanyList (Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectList(this.statement + "adjustDebtCompanyList", paramMap);
	}
	
	public void insertSaleEBill(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "insertSaleEBill", saveMap);
	}

	public void updateAdjustCreatListForAll(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "updateAdjustCreatListForAll", saveMap);
	}

	public void insertItemList(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "insertItemList", saveMap);
	}
	
	public void updateSaleEBill (Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement + "updateSaleEBill", saveMap);
	}
	
	public int getMptrecCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "getMptrecCnt", paramMap);
	}
	
	public int getMptpayCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "getMptpayCnt", paramMap);
	}
	
	public List<HashMap<String, Object>> selectBranchsByClientId(String clientId){
		return sqlSessionTemplate.selectList(this.statement + "selectBranchsByClientId", clientId);
	}
	
	public List<Map<String, Object>> adjustSalesTransmissionListForExcel (Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectList(this.statement + "adjustSalesTransmissionListForExcel", paramMap);
	}
	
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel5Month (Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalStdMonthExcel5Month", paramMap);
	}

	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel30Month (Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalStdMonthExcel30Month", paramMap);
	}
	
	public Map<String, Object> selectPayBillTypeCd (String params){
		return sqlSessionTemplate.selectOne(this.statement + "selectPayBillTypeCd", params);
	}

	public int modSalesConfirmPartCancel(Map<String, Object> saveMap) {
		int resultCnt = sqlSessionTemplate.update(this.statement + "modSalesConfirmPartCancel", saveMap);
		return resultCnt;
	}

	public void modSaleCashCalc(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"modSaleCashCalc", saveMap);
	}

	public int selectAdjustBorgDialogCnt(Map<String, Object> params) {
		int resultCnt = sqlSessionTemplate.selectOne(this.statement+"selectAdjustBorgDialogCnt", params);
		return resultCnt;
	}
	
	public List<BorgDto> selectAdjustBorgDialog(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectAdjustBorgDialog",params, rowBounds);
	}

	public void modExpirationDate(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"modExpirationDate", saveMap);
	}

	public int selectSaleCashCalcCnt(Map<String, Object> saveMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectSaleCashCalcCnt", saveMap);
	}

	public void modAdjustSalesConfirm(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"modAdjustSalesConfirm", saveMap);
	}

	public int selectAdjustUpdatePayAmouCnt(String saleSequNumb) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectAdjustUpdatePayAmouCnt", saleSequNumb);
	}

	public void updateAdjustUpdateTempPayAmouNumb(String saleSequNumb) {
		sqlSessionTemplate.update(this.statement+"updateAdjustUpdateTempPayAmouNumb", saleSequNumb);
	}

	public Map<String, Object> selectMssalmInfo(String saleSequNumb) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMssalmInfo", saleSequNumb);
	}

	public void insertMssalmCancelHist(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"insertMssalmCancelHist", saveMap);
	}

	public int selectAdjustSapNumCount(String saleSequNumb) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectAdjustSapNumCount",saleSequNumb);
	}

	public Map<String, Object> selectAdjustInfoBySaleSequNumb(String saleSequNumb) {
		return sqlSessionTemplate.selectOne(this.statement+"selectAdjustInfoBySaleSequNumb", saleSequNumb);
	}

	public Map<String, Object> selectAdjustInfoByBuyiSequNumb(String buyiSequNumb) {
		return sqlSessionTemplate.selectOne(this.statement+"selectAdjustInfoByBuyiSequNumb", buyiSequNumb);
	}

	public Map<String, Object> selectMsbuymInfo(String buyiSequNumb) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMsbuymInfo", buyiSequNumb);
	}

	public boolean selectEbillCheckByBranchId(String buyBranchId) {
		int chkCnt = sqlSessionTemplate.selectOne(this.statement+"selectEbillCheckByBranchId", buyBranchId);
		if(chkCnt > 0) {
			return false;
		} else {
			return true;
		}
	}

	public int selectAdjustCancelValidationCnt(String whereString) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("whereString", whereString);
		return sqlSessionTemplate.selectOne(this.statement+"selectAdjustCancelValidationCnt", paramMap);
	}

	public void updateSalesConfirmPartCancel(String whereString) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("whereString", whereString);
		sqlSessionTemplate.update(this.statement+"updateSalesConfirmPartCancel", paramMap);
	}

	public boolean getIsAdjustCreateStatus(String sale_sequ_numb) {
		int statusCnt = sqlSessionTemplate.selectOne(this.statement+"getIsAdjustCreateStatus", sale_sequ_numb);
		if(statusCnt==0) return false;
		else return true;
	}

	public void updateTransferStatus(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateTransferStatus", saveMap);
	}

	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel3Month(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalStdMonthExcel3Month", params);
	}
	
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel6Month(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalStdMonthExcel6Month", params);
	}
	
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel12Month(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalStdMonthExcel12Month", params);
	}
	
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel3MonthClient(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalStdMonthExcel3MonthClient", params);
	}
	
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel6MonthClient(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalStdMonthExcel6MonthClient", params);
	}
	
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel12MonthClient(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalStdMonthExcel12MonthClient", params);
	}
	
	public List<Map<String, Object>> adjustBondsTotalStdMonthExcel30MonthClient(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustBondsTotalStdMonthExcel30MonthClient", params);
	}

	public List<AdjustDto> adjustBranchBondsCompanyList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"adjustBranchBondsCompanyList", params);
	}

	public List<AdjustDto> adjustVenDebtCompanyList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"adjustVenDebtCompanyList", params);
	}

	public List<AdjustDto> adjustVenPurcConfirmDetailList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "adjustVenPurcConfirmDetailList", params); 
	}

	public List<Map<String, Object>> adjustSalesTransmissionPayDateListForExcel(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"adjustSalesTransmissionPayDateListForExcel", params);
	}

	public int adjustBalanceListCnt2(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"adjustBalanceListCnt2", params);
	}

	public List<AdjustDto> adjustBalanceList2(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"adjustBalanceList2", params, rowBounds);
	}

	public int adjustBalanceDetailCnt2(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"adjustBalanceDetailCnt2", params);
	}

	public List<AdjustDto> adjustBalanceDetail2(Map<String, Object> params,	int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"adjustBalanceDetail2", params, rowBounds);
	}

	public List<AdjustDto> adjustBalanceList3(Map<String, Object> params,int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"adjustBalanceList3", params, rowBounds);
	}

	public void etcExpirationDateSave(Map<String, Object> tempMap) throws Exception{
		sqlSessionTemplate.update(this.statement+"etcExpirationDateSave", tempMap);
	}

	public void updateEtcExpirationDate(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateEtcExpirationDate", saveMap);
	}

	public boolean selectEbillCheckByVendorId(String vendorId) {
		int cnt = sqlSessionTemplate.selectOne(this.statement+"selectEbillCheckByVendorId", vendorId);
		if(cnt > 0){
			return false;
		}else{
			return true;
		}
	}

	public int getMsbuymInfoCheck(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMsbuymInfoCheck", saveMap);
	}

	public void updatePurchaseConfirmPartCancel(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updatePurchaseConfirmPartCancel", saveMap);
	}

	public int getMrordtListBuyiSequNumbCheck(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selecMrordtListBuyiSequNumbCheck", saveMap);
	}

	public void deleteMsbuymInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteMsbuymInfo", saveMap);
	}

	public void updateMsbuymInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMsbuymInfo", saveMap);
	}

	public Map<String, Object> selectSumupContent(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectSumupContent", params);
	}

	public void updateReceSaleStatus(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateReceSaleStatus", saveMap);
	}

	public List<Map<String, String>> adjustBondsPlanList(ModelMap paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"adjustBondsPlanList", paramMap, rowBounds);
	}

	public List<Map<String, String>> getMonthBondsList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"getMonthBondsList", params);
	}

	public List<Map<String, String>> getBondsTypeList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"getBondsTypeList", params);
	}

	public List<Map<String, String>> getBondsLateList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"getBondsLateList", params);
	}
	public List<Map<String, String>> getBondsReturnList1(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"getBondsReturnList1", params);
	}
	public List<Map<String, String>> getBondsReturnList2(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"getBondsReturnList2", params);
	}

	public int getPlanCount(Map<String, String> paramsMap) {
		return sqlSessionTemplate.selectOne(this.statement+"getPlanCount", paramsMap);
	}

	public void updateBondPlans(Map<String, String> paramsMap) {
		sqlSessionTemplate.update(this.statement+"updateBondPlans", paramsMap);
	}

	public void insertBondPlans(Map<String, String> paramsMap) {
		sqlSessionTemplate.insert(this.statement+"insertBondPlans", paramsMap);
	}
	public int adjustBondsTypeDetailCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"adjustBondsTypeDetailCnt", params);
	}
	public List<Map<String, String>> adjustBondsTypeDetail(Map<String, Object> params, int page, int rows) {
		if(rows>0) {
			RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
			return sqlSessionTemplate.selectList(this.statement+"adjustBondsTypeDetail", params, rowBounds);
		} else {
			return sqlSessionTemplate.selectList(this.statement+"adjustBondsTypeDetail", params);
		}
	}

	public List<Map<String, String>> adjustBondsHistList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"adjustBondsHistList", params);
	}

	public void insertBondsHistory(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertBondsHistory", saveMap);
	}

	public void updateBondsHistory(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateBondsHistory", saveMap);
	}
	
	public int getBondsMonthDetailCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"getBondsMonthDetailCnt", params);
	}
	public List<Map<String, String>> getBondsMonthDetail(Map<String, Object> params, int page, int rows) {
		if(rows>0) {
			RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
			return sqlSessionTemplate.selectList(this.statement+"getBondsMonthDetail", params, rowBounds);
		} else {
			return sqlSessionTemplate.selectList(this.statement+"getBondsMonthDetail", params);
		}
	}
	
}
