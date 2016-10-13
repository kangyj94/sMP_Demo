package kr.co.bitcube.product.service; 

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.common.utils.CustomResponse;
import kr.co.bitcube.product.dao.CategoryDao;
import kr.co.bitcube.product.dto.CategoryDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class CategorySvc {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private CategoryDao categoryDao;
	
	@Resource(name="seqMcCategoryService")
	private EgovIdGnrService seqMcCategoryService;
	
	@Resource(name="seqMcCategoryHistoryService")
	private EgovIdGnrService seqMcCategoryHistoryService;
	
	public List<CategoryDto> getCategoryList(Map<String, Object> params) {
		return categoryDao.selectCategoryList(params);
	}
	
	public List<CategoryDto> getCategoryTreeExcel() {
		return categoryDao.selectCategoryTreeExcel();
	}
	
	public int getCategoryMasterCnt(Map<String, Object> saveMap) {
		return categoryDao.selectCategoryMasterCnt(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regCategoryMaster(Map<String, Object> saveMap, CustomResponse custResponse) throws Exception {
		int records = this.getCategoryMasterCnt(saveMap);
		if(records>0) {
			custResponse.setSuccess(false);
			custResponse.setMessage("이미 등록된 표준카테고리정보입니다.");
			return;
		}
		
		int cateSequence = seqMcCategoryService.getNextIntegerId();
		saveMap.put("cateId", cateSequence);
		categoryDao.insertCategoryMaster(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modCategoryMaster(Map<String, Object> saveMap) throws Exception {
		categoryDao.updateCategoryMaster(saveMap);
	}
	
	public int getDisplayListCnt(Map<String, Object> params) {
		return categoryDao.selectDisplayListCnt(params);
	}
	
	public List<CategoryDto> getDisplayList(Map<String, Object> params) {
		return categoryDao.selectDisplayList(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regDisplayMaster(Map<String, Object> saveMap) throws Exception {
		int cateSequence = seqMcCategoryService.getNextIntegerId();
		int cateHistorySequence = seqMcCategoryHistoryService.getNextIntegerId();
		saveMap.put("cateDispId", cateSequence);
		saveMap.put("goodHistId", cateHistorySequence);
		categoryDao.insertDisplayMaster(saveMap);
		categoryDao.insertDisplayMasterHist(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modDisplayMaster(Map<String, Object> saveMap) throws Exception {
		int cateHistorySequence = seqMcCategoryHistoryService.getNextIntegerId();
		saveMap.put("goodHistId", cateHistorySequence);
		categoryDao.updateDisplayMaster(saveMap);
		categoryDao.insertDisplayMasterHist(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delDisplayMaster(Map<String, Object> saveMap) throws Exception {
		int cateHistorySequence = seqMcCategoryHistoryService.getNextIntegerId();
		saveMap.put("goodHistId", cateHistorySequence);
		categoryDao.deleteDisplayMaster(saveMap);
		categoryDao.insertDisplayMasterHist(saveMap);
	}
	
	public int getDisplayCategoryListCnt(Map<String, Object> params) {
		return categoryDao.selectDisplayCategoryListCnt(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regDisplayCategory(Map<String, Object> saveMap) throws Exception {
		int cateHistorySequence = seqMcCategoryHistoryService.getNextIntegerId();
		saveMap.put("goodHistId", cateHistorySequence);
		categoryDao.insertDisplayCategory(saveMap);
		categoryDao.insertDisplayCategoryHist(saveMap);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delDisplayCategory(Map<String, Object> saveMap) throws Exception {
		int cateHistorySequence = seqMcCategoryHistoryService.getNextIntegerId();
		saveMap.put("goodHistId", cateHistorySequence);
		categoryDao.deleteDisplayCategory(saveMap);
		categoryDao.insertDisplayCategoryHist(saveMap);
	}
	
	public List<CategoryDto> getDisplayCategoryList(Map<String, Object> params) {
		return categoryDao.selectDisplayCategoryList(params);
	}
	
	public int getCategoryBorgListCnt(Map<String, Object> params) {
		return categoryDao.selectCategoryBorgListCnt(params);
	}
	
	public int getCategoryBorgListOverLap(Map<String, Object> params) {
		return categoryDao.selectCategoryBorgListOverLap(params);
	}
	
	public List<CategoryDto> getCategoryBorgListOverLapList(Map<String, Object> params) {
		return categoryDao.selectCategoryBorgListOverLapList(params);
	}
	
	public List<CategoryDto> getBorgListOverLapList(Map<String, Object> params) {
		return categoryDao.selectBorgListOverLapList(params);
	}
	
	public List<CategoryDto> getCategoryBorgList(Map<String, Object> params) {
		return categoryDao.selectCategoryBorgList(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public String regCategoryBorg(Map<String, Object> saveMap, CustomResponse custResponse) throws Exception {
		String[] borgIdArr = (String[])saveMap.get("borgIdArr");
		String[] groupIdArr = (String[])saveMap.get("groupIdArr");
		String[] clientIdArr = (String[])saveMap.get("clientIdArr");
		String[] branchIdArr = (String[])saveMap.get("branchIdArr");
		String[] regTrueArr = new String[borgIdArr.length];
		String msg = "";
		
		for(int i=0;i<borgIdArr.length;i++) {
			Map<String, Object> paramMap = new HashMap<String,Object>();
			paramMap.put("borgId", borgIdArr[i]);
			paramMap.put("groupId", groupIdArr[i]);
			paramMap.put("clientId", clientIdArr[i]);
			paramMap.put("branchId", branchIdArr[i]);
			
			int records = this.getCategoryBorgListOverLap(paramMap);
			if(records > 0){
				List<CategoryDto> list = this.getCategoryBorgListOverLapList(paramMap);
				String cateDispName = list.get(0).getCate_Disp_Name();
				List<CategoryDto> list2 = this.getBorgListOverLapList(paramMap);
				String borgName = list2.get(0).getBorgNm();
				msg += "<font color='red'>"+borgName+"</font> 은<br /> "+"<font color='blue'>"+cateDispName+" 에</font><br />";
				regTrueArr[i] = "false";
			} else {
				regTrueArr[i] = "true";
			}
		}
		
		for(int i=0;i<borgIdArr.length;i++) {
			if(regTrueArr[i] == "true") {
				Map<String, Object> saveMap2 = new HashMap<String,Object>();
				saveMap2.put("cateDispId", (String)saveMap.get("cateDispId"));
				saveMap2.put("insertUserId", (String)saveMap.get("insertUserId"));
				saveMap2.put("remoteIp", (String)saveMap.get("remoteIp"));
				saveMap2.put("borgId", borgIdArr[i]);
				saveMap2.put("groupId", groupIdArr[i]);
				saveMap2.put("clientId", clientIdArr[i]);
				saveMap2.put("branchId", branchIdArr[i]);
				
//				logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
//				logger.debug("cateDispId   : "+(String)saveMap.get("cateDispId"));
//				logger.debug("insertUserId : "+(String)saveMap.get("insertUserId"));
//				logger.debug("remoteIp     : "+(String)saveMap.get("remoteIp"));
//				logger.debug("borgId       : "+borgIdArr[i]);
//				logger.debug("groupId      : "+groupIdArr[i]);
//				logger.debug("clientId     : "+clientIdArr[i]);
//				logger.debug("branchId     : "+branchIdArr[i]);
//				logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
				
				int cateHistorySequence = seqMcCategoryHistoryService.getNextIntegerId();
				saveMap2.put("goodHistId", cateHistorySequence);
				categoryDao.insertCategoryBorg(saveMap2);
				categoryDao.insertCategoryBorgHist(saveMap2);
			}
		}
		
		if(msg != "") {
			msg += " 이미 등록된 진열조직입니다.";
			msg = "<font size='2'>"+msg+"</font>";
		}
		return msg;
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delCategoryBorg(Map<String, Object> saveMap) throws Exception {
		String[] groupIdArr = (String[])saveMap.get("groupIdArr");
		String[] clientIdArr = (String[])saveMap.get("clientIdArr");
		String[] branchIdArr = (String[])saveMap.get("branchIdArr");
		
		for(int i=0;i<groupIdArr.length;i++) {
			Map<String, Object> saveMap2 = new HashMap<String,Object>();
			saveMap2.put("cateDispId", (String)saveMap.get("cateDispId"));
			saveMap2.put("insertUserId", (String)saveMap.get("insertUserId"));
			saveMap2.put("remoteIp", (String)saveMap.get("remoteIp"));
			saveMap2.put("groupId", groupIdArr[i]);
			saveMap2.put("clientId", clientIdArr[i]);
			saveMap2.put("branchId", branchIdArr[i]);
			
//			logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
//			logger.debug("cateDispId   : "+(String)saveMap.get("cateDispId"));
//			logger.debug("groupId      : "+groupIdArr[i]);
//			logger.debug("clientId     : "+clientIdArr[i]);
//			logger.debug("branchId     : "+branchIdArr[i]);
//			logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
			
			int cateHistorySequence = seqMcCategoryHistoryService.getNextIntegerId();
			saveMap2.put("goodHistId", cateHistorySequence);
			categoryDao.deleteCategoryBorg(saveMap2);
			categoryDao.insertCategoryBorgHist(saveMap2);
		}
	}
	
	public List<CategoryDto> getStandardCategoryList(){
		return categoryDao.selectStandardCategoryList();
	}
	
	public int getCategoryInfoListCnt(Map<String, Object> params) {
		return categoryDao.selectCategoryInfoListCnt(params);
	}
	
	public List<CategoryDto> getCategoryInfoList(Map<String, Object> params, int page, int rows) {
		return categoryDao.selectCategoryInfoList(params, page, rows);
	}
	
	public List<CategoryDto> getBuyerDisplayCategoryInfoListJQ(Map<String, Object> params){
		return categoryDao.selectBuyerDisplayCategoryInfoList(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void addBorgUserCateGory(Map<String, Object> paramMap) throws Exception {
		String[] cate_id_Array = (String[])paramMap.get("cate_id_Array");
		for(String cate_id : cate_id_Array) {
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("cate_id"	, cate_id								);
			saveMap.put("groupId"	, (String)paramMap.get("groupId")		);
			saveMap.put("clientId"	, (String)paramMap.get("clientId")		);
			saveMap.put("branchId"	, (String)paramMap.get("branchId")		);
			saveMap.put("userId"	, (String)paramMap.get("userId")		);
			
			int rowCnt = categoryDao.selectBorgUserCateGoryCount(saveMap);
			if(rowCnt== 0) {
				categoryDao.insertBorgUserCateGory(saveMap);
			}
		}
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delBorgUserCateGory(Map<String, Object> paramMap) throws Exception {
		String[] cate_Id_Array = (String[])paramMap.get("cate_Id_Array");
		for(String cate_id : cate_Id_Array) {
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("cate_id"	, cate_id								);
			saveMap.put("groupId"	, (String)paramMap.get("groupId")		);
			saveMap.put("clientId"	, (String)paramMap.get("clientId")		);
			saveMap.put("branchId"	, (String)paramMap.get("branchId")		);
			saveMap.put("userId"	, (String)paramMap.get("userId")		);
			
			categoryDao.deleteBorgUserCateGory(saveMap);
		}
	}
	
	
	public int getMyCategoryListCnt(Map<String, Object> params) {
		return categoryDao.selectMyCategoryListCnt(params);
	}
	
	public List<CategoryDto> getMyCategoryListInfo(Map<String, Object> params, int page, int rows) {
		return categoryDao.selectMyCategoryListInfo(params, page, rows);
	}
}
