package kr.co.bitcube.mig.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.mig.dto.NewCateDto;
import kr.co.bitcube.mig.dto.NewCateProdDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NewCateDao {
	private final String statement = "newCate.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<NewCateDto> selectCateList(Map<String, Object> searchMap) {
		return sqlSessionTemplate.selectList(this.statement+"selectCategoryList", searchMap);
	}

	public int selectProductListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProductListCount", params);
	}

	public List<NewCateProdDto> selectProductList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectProductList", params, rowBounds);
	}

	public void insertCateProdVendInfo(Map<String, String> saveParamMap) {
		sqlSessionTemplate.insert(this.statement+"insertCateProdVendInfo", saveParamMap);
	}

	public void updateCateProdVendInfo(Map<String, String> saveParamMap) {
		sqlSessionTemplate.update(this.statement+"updateCateProdVendInfo", saveParamMap);
	}

	public void deleteCateProdVendInfo(Map<String, String> saveParamMap) {
		sqlSessionTemplate.delete(this.statement+"deleteCateProdVendInfo", saveParamMap);
	}

	public List<NewCateProdDto> selectCateGoods(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectCateGoods", params);
	}

	public int selectNewCategoryMasterCnt(Map<String, Object> saveMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectNewCategoryMasterCnt", saveMap);
	}

	public void insertNewCategoryMaster(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertNewCategoryMaster", saveMap);
	}

	public void updateNewCategoryMaster(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateNewCategoryMaster", saveMap);
	}

	public void deleteNewCategoryMaster(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(this.statement+"deleteNewCategoryMaster", saveMap);
	}
}
