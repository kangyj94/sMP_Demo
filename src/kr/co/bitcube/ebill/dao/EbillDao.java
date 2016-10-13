package kr.co.bitcube.ebill.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.ebill.dto.EbillDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class EbillDao {
	
	private final String statement = "ebill.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public int selectEbillBranchListCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "selectEbillBranchListCnt", paramMap);
	}
	
	
	public List<EbillDto> selectEbillBranchList (Map<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement + "selectEbillBranchList", paramMap, rowBounds);
	}

	public int selectEbillVendorListCnt (Map<String, Object> paramMap) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement + "selectEbillVendorListCnt", paramMap);
	}
	
	
	public List<EbillDto> selectEbillVendorList (Map<String, Object> paramMap, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement + "selectEbillVendorList", paramMap, rowBounds);
	}
}
