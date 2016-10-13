package kr.co.bitcube.schedule;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dto.MailInfoDto;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ScheduleDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	private final String statement = "common.schedule.";
	
	
	public List<Map<String,Object>> selectAutoReceiveListAfter5Day() {
		return  sqlSessionTemplate.selectList(this.statement+"selectAutoReceiveListAfter5Day");
	}
	
	public List<Map<String,Object>> selectNotReceiveSaleList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectNotReceiveSaleList");
	}

	public void updateStatusNotGiveBuyManage() {
		sqlSessionTemplate.update(this.statement+"updateStatusNotGiveBuyManage");
	}

	public void updateManageBorgOfNotReceiveSale(String sale_sequ_numb) {
		sqlSessionTemplate.update(this.statement+"updateManageBorgOfNotReceiveSale", sale_sequ_numb);
	}

	public void updateBorgOrderLimitByClientId(String cliendId) {
		sqlSessionTemplate.update(this.statement+"updateBorgOrderLimitByClientId", cliendId);
	}

	public void updateBondOverMonthDay() {
		sqlSessionTemplate.update(this.statement+"updateBondOverMonthDay");
	}

	public void updateBuyOverMonthDay() {
		sqlSessionTemplate.update(this.statement+"updateBuyOverMonthDay");
	}
	
	
	public List<Map<String,Object>> selectOrderStockNoticeUserList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderStockNoticeUserList");
	}

	public void updateOrderCntOfMcgoodVendor() {
		sqlSessionTemplate.update(this.statement+"updateOrderCntOfMcgoodVendor");
	}

	
	public List<Map<String, Object>> selectFailBidList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectFailBidList");
	}

	public void updateMcbidStatus(Map<String,Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMcbidStatus", saveMap);
	}

	public void updateMcnewgoodRequestStatus(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMcnewgoodRequestStatus", saveMap);
	}

	
	public List<Map<String, Object>> selectEndBidList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectEndBidList");
	}

	
	public List<Map<String, Object>> selectPaymentList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectPaymentList");
	}

	
	public List<Map<String, Object>> selectGivePayList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectGivePayList");
	}

	
	public List<Map<String, Object>> selectLastMonthSaleList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectLastMonthSaleList");
	}

	public double selectOrderAmountSum(String branchId) {
		return (Double) sqlSessionTemplate.selectOne(this.statement+"selectOrderAmountSum", branchId);
	}

	
	public List<MailInfoDto> selectEmailSendList() {
		return sqlSessionTemplate.selectList(this.statement+"selectEmailSendList");
	}

	public void updateEmailSend(MailInfoDto mailInfoDto) {
		sqlSessionTemplate.update(this.statement+"updateEmailSend", mailInfoDto);
	}


	public List<Map<String, Object>> selectMeterialPaymentDay45List() {
		return sqlSessionTemplate.selectList(this.statement+"selectMeterialPaymentDay45List");
	}


	public List<Map<String, Object>> selectMeterialPaymentDay15List() {
		return sqlSessionTemplate.selectList(this.statement+"selectMeterialPaymentDay15List");
	}


	public List<Map<String, Object>> selectOrderLimitNoticeGuideDay61List() {
		return sqlSessionTemplate.selectList(this.statement+"selectOrderLimitNoticeGuideDay61List");
	}


	public List<Map<String, Object>> selectOrderLimitNoticeGuideDay31List() {
		return sqlSessionTemplate.selectList(this.statement+"selectOrderLimitNoticeGuideDay31List");
	}


	public List<Map<String, Object>> selectAttemptedReceiveSaleList() {
		return sqlSessionTemplate.selectList(this.statement+"selectAttemptedReceiveSaleList");
	}


	public List<Map<String, Object>> selectOrder6MonthNothingList() {
		return sqlSessionTemplate.selectList(this.statement+"selectOrder6MonthNothingList");
	}


	public void branchOrderLimit(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"branchOrderLimit", saveMap);
	}


	public List<Map<String, Object>> selectAdmPowerList() {
		return sqlSessionTemplate.selectList(this.statement+"selectAdmPowerList");
	}


	public void evaluation() {
		sqlSessionTemplate.update("evaluation.updateItemForEval");
		sqlSessionTemplate.update("evaluation.updatePartApplForEval");
	}

	public List<Map<String, Object>> selectCartClosedPdt() {
		return sqlSessionTemplate.selectList(this.statement+"selectCartClosedPdt");
	}

	public void delCartClosedPdt(Map<String, Object> tmpMap) {
		sqlSessionTemplate.delete(this.statement+"delCartClosedPdt", tmpMap);
	}

	public List<Map<String, Object>> selectOrderLimitList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectOrderLimitList");
	}

	public List<Map<String, Object>> selectCltUserSmsList() {
		return  sqlSessionTemplate.selectList(this.statement+"selectCltUserSmsList");
	}


	
}
