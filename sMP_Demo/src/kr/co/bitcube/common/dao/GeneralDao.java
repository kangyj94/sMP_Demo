package kr.co.bitcube.common.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.ui.ModelMap;

@Repository
public class GeneralDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public Object selectGernalObject(String queryId, ModelMap paramMap) {
		return sqlSessionTemplate.selectOne(queryId, paramMap);
	}
	
	public int selectGernalCount(String queryId, ModelMap paramMap) {
		return sqlSessionTemplate.selectOne(queryId, paramMap);
	}

	//Map<String,Object> 용 paramMap select object
	public Object selectGernalObject(String queryId, Map<String,Object> paramMap) {
		return sqlSessionTemplate.selectOne(queryId, paramMap);
	}
	
	//Map<String,Object> 용 paramMap select count	
	public int selectGernalCount(String queryId, Map<String,Object> paramMap) {
		return sqlSessionTemplate.selectOne(queryId, paramMap);
	}

	public List<Object> selectGernalList(String queryId, ModelMap paramMap) {
		List<Object> result    = null;
		if(paramMap!=null) {
			RowBounds    rowBounds = (RowBounds) paramMap.get("rowBounds");
			
			if(rowBounds != null && rowBounds.getLimit() > 0){
				result = sqlSessionTemplate.selectList(queryId, paramMap, rowBounds);
			}
			else{
				result = sqlSessionTemplate.selectList(queryId, paramMap);
			}
		} else {
			result = sqlSessionTemplate.selectList(queryId);
		}
		return result;
	}

	public int insertGernal(String queryId, ModelMap paramMap) {
		return sqlSessionTemplate.insert(queryId, paramMap);
	}

	//Map<String,Object> 용 paramMap Insert
	public int insertGernal(String queryId, Map<String,Object> paramMap) {
		return sqlSessionTemplate.insert(queryId, paramMap);
	}

	public int updateGernal(String queryId, ModelMap paramMap) {
		return sqlSessionTemplate.update(queryId, paramMap);
	}
	
	//Map<String,Object> 용 paramMap Update
	public int updateGernal(String queryId, Map<String,Object> paramMap) {
		return sqlSessionTemplate.update(queryId, paramMap);
	}

	public int deleteGernal(String queryId, ModelMap paramMap) {
		return sqlSessionTemplate.delete(queryId, paramMap);
	}
	//Map<String,Object> 용 paramMap Delete
	public int deleteGernal(String queryId, Map<String,Object> paramMap) {
		return sqlSessionTemplate.delete(queryId, paramMap);
	}
	
	//Map<String,Object> 용 paramMap
	public List<Object> selectGernalList(String queryId, Map<String,Object> paramMap) {
		List<Object> result    = null;
		if(paramMap!=null) {
			RowBounds    rowBounds = (RowBounds) paramMap.get("rowBounds");
			if(rowBounds != null && rowBounds.getLimit() > 0){
				result = sqlSessionTemplate.selectList(queryId, paramMap, rowBounds);
			}
			else{
				result = sqlSessionTemplate.selectList(queryId, paramMap);
			}
		} else {
			result = sqlSessionTemplate.selectList(queryId);
		}
		return result;
	}
}
