package kr.co.bitcube.evaluate.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.evaluate.dto.EvaluateDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class EvaluateDao {
	
	private final String statement = "evaluate.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<EvaluateDto> selectEvalRow (Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectList(this.statement + "selectEvalRow", paramMap);
	}
	
	public List<EvaluateDto> selectEvalCol (Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectList(this.statement + "selectEvalCol", paramMap);
	}

	public List<EvaluateDto> selectEvalUsers (Map<String, Object> paramMap) {
		return sqlSessionTemplate.selectList(this.statement + "selectEvalUsers", paramMap);
	}

	public void insertEvaluate(HashMap<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "insertEvaluate", saveMap);
	}
	
	public List<Map<String, Object>> selectEvaluateList (Map<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement + "selectEvaluateList", paramMap, rowBounds);
	}

	public int selectEvaluateListCnt(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement + "selectEvaluateListCnt", params);
	}

	public List<Map<String, Object>> selectEvaluateListExcel(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement + "selectEvaluateListExcel", params);
	}
	
}
