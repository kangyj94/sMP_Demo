package kr.co.bitcube.product.dao; 

import java.util.List;
import java.util.Map;

import kr.co.bitcube.product.dto.CategoryDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CategoryDao {
	
	private final String statement = "category.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	
	public List<CategoryDto> selectCategoryList(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.statement+"selectCategoryList", searchMap);
	}
	
	
	public List<CategoryDto> selectOneCategoryByCateCd(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.statement+"selectOneCategoryByCateCd", searchMap);
	}
	
	
	public List<CategoryDto> selectCategoryTreeExcel() {
		return sqlSessionTemplate.selectList(this.statement+"selectCategoryTreeExcel");
	}
	
	public int selectCategoryMasterCnt(Map<String, Object> saveMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectCategoryMasterCnt", saveMap);
	}
	
	public void insertCategoryMaster(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertCategoryMaster", saveMap);
	}
	
	public void updateCategoryMaster(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateCategoryMaster", saveMap);
	}
	
	public int selectDisplayListCnt(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectDisplayListCnt", params);
	}
	
	
	public List<CategoryDto> selectDisplayList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectDisplayList", params);
	}
	
	public void insertDisplayMaster(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertDisplayMaster", saveMap);
	}
	
	public void insertDisplayMasterHist(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertDisplayMasterHistory", saveMap);
	}
	
	public void updateDisplayMaster(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateDisplayMaster", saveMap);
	}
	
	public void deleteDisplayMaster(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteDisplayMaster", saveMap);
	}
	
	public int selectDisplayCategoryListCnt(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectDisplayCategoryListCnt", params);
	}
	
	public void insertDisplayCategory(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertDisplayCategory", saveMap);
	}
	
	public void deleteDisplayCategory(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteDisplayCategory", saveMap);
	}
	
	public void insertDisplayCategoryHist(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertDisplayCategoryHistory", saveMap);
	}
	
	
	public List<CategoryDto> selectDisplayCategoryList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectDisplayCategoryList", params);
	}
	
	public int selectCategoryBorgListCnt(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectCategoryBorgListCnt", params);
	}
	
	public int selectCategoryBorgListOverLap(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectCategoryBorgListOverLap", params);
	}
	
	
	public List<CategoryDto> selectCategoryBorgListOverLapList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectCategoryBorgListOverLapList", params);
	}
	
	
	public List<CategoryDto> selectBorgListOverLapList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectBorgListOverLapList", params);
	}
	
//	
//	public List<BorgDto> selectCategoryBorgList(Map<String, Object> params) {
//		return (List<BorgDto>)sqlSessionTemplate.selectList(this.statement+"selectCategoryBorgList", params);
//	}
	
	public List<CategoryDto> selectCategoryBorgList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectCategoryBorgList", params);
	}
	
	public void insertCategoryBorg(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertCategoryBorg", saveMap);
	}
	
	public void insertCategoryBorgHist(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertCategoryBorgHistory", saveMap);
	}
	
	public void deleteCategoryBorg(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteCategoryBorg", saveMap);
	}
	
	public List<CategoryDto> selectStandardCategoryList() {
		return sqlSessionTemplate.selectList(this.statement+"selectStandardCategoryList");
	}
	
	public int selectCategoryInfoListCnt(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectCategoryInfoListCnt", params);
	}
	
	
	public List<CategoryDto> selectCategoryInfoList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectCategoryInfoList", params, rowBounds);
	}
	
	
	public List<CategoryDto>  selectBuyerDisplayCategoryInfoList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectBuyerDisplayCategoryInfoList", params);
	}
	
	public int selectBorgUserCateGoryCount (Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectBorgUserCateGoryCount", params);
	}
	
	public void insertBorgUserCateGory(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertBorgUserCateGory", saveMap);
	}
	
	public void deleteBorgUserCateGory(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"deleteBorgUserCateGory", saveMap);
		
	}
	
	public int selectMyCategoryListCnt (Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectMyCategoryListCnt", params);
	}
	
	
	public List<CategoryDto> selectMyCategoryListInfo(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectMyCategoryListInfo", params, rowBounds);
	}
}
