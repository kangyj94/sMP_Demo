package kr.co.bitcube.mig.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.rte.fdl.cmmn.exception.FdlException;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.utils.CommonUtils;

@Service
public class BillSvc {
	private Logger logger = Logger.getLogger(getClass());
	@Resource(name="seqElectronicBill") private EgovIdGnrService seqElectronicBill;
	@Autowired private GeneralDao generalDao;

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveBill(Map paramMap) throws Exception {
		String bill_id = CommonUtils.getString(paramMap.get("bill_id"));
		double over_period = Double.parseDouble(CommonUtils.nvl(CommonUtils.getString(paramMap.get("over_period")),"0"));
		double interest_rate = Double.parseDouble(CommonUtils.nvl(CommonUtils.getString(paramMap.get("interest_rate")),"0"));
		paramMap.put("over_period", over_period);
		paramMap.put("interest_rate", interest_rate);
		if("".equals(bill_id)) {	//등록
			paramMap.put("bill_id", seqElectronicBill.getNextStringId());
			generalDao.insertGernal("newCate.insertElectronicBill", paramMap);
		} else {	//수정
			generalDao.updateGernal("newCate.updateElectronicBill", paramMap);
		}
	}

	public void deleteBill(ModelMap paramMap) {
		generalDao.deleteGernal("newCate.deleteElectronicBill", paramMap);
	}

	public void saveBillBatch(List<Map<String, Object>> saveList) {
		for(Map<String, Object> saveMap : saveList) {
			try{
				double public_amount = Double.parseDouble(CommonUtils.nvl(CommonUtils.getString(saveMap.get("public_amount")),"0"));
//				double over_period = Double.parseDouble(CommonUtils.nvl(CommonUtils.getString(saveMap.get("over_period")),"0"));
//				double interest_rate = Double.parseDouble(CommonUtils.nvl(CommonUtils.getString(saveMap.get("interest_rate")),"0"));
				double interest_amount = Double.parseDouble(CommonUtils.nvl(CommonUtils.getString(saveMap.get("interest_amount")),"0"));
//				double interest_amount = ((public_amount*over_period)/365)*(interest_rate/100);
//				interest_amount = Math.floor(interest_amount);
				double sum_amount = public_amount + interest_amount;
				saveMap.put("interest_amount", interest_amount);
				saveMap.put("sum_amount", sum_amount);
				this.saveBill(saveMap);
			} catch(Exception e) {
				logger.error("상품일괄 수정 시 에러발생 : "+saveMap);
			}
		}
	}
	
	
}
