package kr.co.bitcube.mig.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.mig.dao.NewCateDao;
import kr.co.bitcube.mig.dto.NewCateDto;
import kr.co.bitcube.mig.dto.NewCateProdDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class NewCateSvc {
	@SuppressWarnings("unused")
	private Logger logger = Logger.getLogger(getClass());

	@Autowired
	private NewCateDao newCateDao;
	
	@Resource(name="seqMcCategoryService")
	private EgovIdGnrService seqMcCategoryService;

	public List<NewCateDto> getCateList(Map<String, Object> params) {
		return newCateDao.selectCateList(params);
	}

	public List<NewCateDto> getBuyerDisplayCategoryInfoListJQ(Map<String, Object> params){
		return newCateDao.selectCateList(params);
	}
	
	public int getNewCategoryMasterCnt(Map<String, Object> saveMap) {
		return newCateDao.selectNewCategoryMasterCnt(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regNewCategoryMaster(Map<String, Object> saveMap, CustomResponse custResponse) throws Exception {
		int records = this.getNewCategoryMasterCnt(saveMap);
		if(records>0) {
			custResponse.setSuccess(false);
			custResponse.setMessage("이미 등록된 표준카테고리정보입니다.");
			return;
		}
		
		int cateSequence = seqMcCategoryService.getNextIntegerId();
		saveMap.put("cateId", cateSequence);
		newCateDao.insertNewCategoryMaster(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modNewCategoryMaster(Map<String, Object> saveMap) throws Exception {
		newCateDao.updateNewCategoryMaster(saveMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delNewCategoryMaster(Map<String, Object> saveMap) {
		newCateDao.deleteNewCategoryMaster(saveMap);
	}
	
	

	public int getProductListCnt(Map<String, Object> params) {
		return newCateDao.selectProductListCnt(params);
	}

	public List<NewCateProdDto> getProductList(Map<String, Object> params, int page, int rows) {
		return newCateDao.selectProductList(params, page, rows);
	}

	public String saveProdInfo(Map<String, Object> saveMap) {
		String rtnMsg = "";
		String treeKey = (String)saveMap.get("treeKey");
		String[] prod_key_array = (String[])saveMap.get("prod_key_array");
		String[] isReg_array = (String[])saveMap.get("isReg_array");
		if(treeKey == null || "".equals(treeKey)){rtnMsg += "카테고리 정보를 선택해주십시오.";}
		if(prod_key_array == null){rtnMsg += "저장할 정보가 없습니다.(1)";}else if(prod_key_array.length == 0){rtnMsg += "저장할 정보가 없습니다.(2)";}
		if(isReg_array == null){rtnMsg += "저장할 정보가 없습니다.(3)";}else if(isReg_array.length == 0){rtnMsg += "저장할 정보가 없습니다.(3)";}
		if("".equals(rtnMsg) == true){	// 유효성을 통과 한 후 로직 진행.
			String masterCateId = treeKey.split("∥")[1];
			Map<String, String> saveParamMap = null;
			for (int i = 0; i < isReg_array.length; i++) {
				String isReg = isReg_array[i];
				String prod_key = prod_key_array[i];
				String good_iden_numb = prod_key.split("_")[0];
				String vendorid = prod_key.split("_")[1];
				saveParamMap = new HashMap<String, String>();
				saveParamMap.put("cate_id", masterCateId);
				saveParamMap.put("good_iden_numb", good_iden_numb);
				saveParamMap.put("vendorid", vendorid);
				if("Y".equals(isReg)){ // insert 를 진행한다.
					this.newCateDao.insertCateProdVendInfo(saveParamMap);
				}else if("N".equals(isReg)){// update 를 진행한다. 
					this.newCateDao.deleteCateProdVendInfo(saveParamMap);
				}
			}
		}
		return rtnMsg;
	}

	public List<NewCateProdDto> selectCateGoods(Map<String, Object> params) {
		String keyVal = params.get("keyVal") == null ? "" : (String)params.get("keyVal");
		String srcCateId = keyVal.split("∥")[1];
		params.put("srcCateId", srcCateId);
		return newCateDao.selectCateGoods(params);
	}


}
