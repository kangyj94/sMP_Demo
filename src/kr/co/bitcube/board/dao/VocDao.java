package kr.co.bitcube.board.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.board.dto.VocDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class VocDao {

	private final String statement = "board.";		// 고객의 소리는 게시판 쪽 쿼리를 공통으로 하여 사용함.
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public void insertVocInfo(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement + "insertVocInfo", saveMap);
	}

	public int selectVocListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectVocListCnt", params);
	}

	public List<VocDto> selectVocList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectVocList", params, rowBounds);
	}
	public VocDto selectVocDetail(Map<String, Object> params) {
		return (VocDto) sqlSessionTemplate.selectOne(statement+"selectVocDetail", params);
	}
	
}
