package kr.co.bitcube.board.dao;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.board.dto.ImproDto;
import kr.co.bitcube.board.dto.MerequDto;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.ui.ModelMap;

@Repository
public class BoardDao {

	private final String statement = "board.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	/**
	 * 공지사항 리스트의 카운트 조회하는 메소드
	 */ 
	public int selectNoticeListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectNoticeList_count", params);
	}
	
	/**
	 * 공지사항 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<BoardDto> selectNoticeList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectNoticeList", params, rowBounds);
	}
	
	/**
	 * 게시판 리스트를 조회하여 반환하는 메소드
	 */
	public int selectBoardListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectBoardListCnt", params);
	}
	
	public List<BoardDto> selectBoardList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectBoardList", params, rowBounds);
	}
	
	/**
	 * 공지사항을 등록하는 메소드
	 */
	public void insertNotice(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertNotice", saveMap);
	}
	
	/**
	 * 공지사항 및 게시판 특정 상세 정보를 조회한다
	 */
	public BoardDto selectNoticeDetail(Map<String, Object> params) {
		return (BoardDto) sqlSessionTemplate.selectOne(statement+"selectNoticeDetail", params);
	}
	
	/**
	 * 공지사항 팝업 인것을 조회한다.
	 */
	public BoardDto selectNoticePopDetail(Map<String, Object> params) {
		return (BoardDto) sqlSessionTemplate.selectOne(statement+"selectNoticePopDetail", params);
	}
	
	public List<BoardDto> selectNoticePopBoardNoList(String svcTypeCd) {
		return  sqlSessionTemplate.selectList(this.statement+"selectNoticePopBoardNoList", svcTypeCd);
	}
	
	/**
	 * 리스트의 조회수를 처리하는 메소드
	 */
	public void updateHit_No(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(statement+"updateHit_No", saveMap);
	}
	
	
	/**
	 * 공지사항 수정을 처리하는 메소드
	 */
	public void updateNotice(Map<String, Object> param) {
		sqlSessionTemplate.update(statement+"updateNotice", param);
	}
	
	/**
	 * 공지사항 삭제 페이지로 이동하는 메소드
	 */
	public void deleteNotice(Map<String,Object> saveMap) {
		sqlSessionTemplate.delete(statement+"deleteNotice", saveMap);
	}
	
	/**
	 * VOC 삭제 페이지로 이동하는 메소드
	 */
	public void delVoc(Map<String,Object> saveMap) {
		sqlSessionTemplate.delete(statement+"deleteVoc", saveMap);
	}
	
	/**
	 * 요구사항관리 리스트의 카운트 조회하는 메소드
	 */ 
	public int selectRequestManageListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectRequestManageListCnt", params);
	}
	
	/**
	 * 요구사항관리 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<MerequDto> selectRequestManageList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectRequestManageList", params, rowBounds);
	}
	
	/**
	 * 요구사항관리 상세 정보를 조회한다
	 */
	public MerequDto selectRequestManageDetail(Map<String, Object> params) {
		return (MerequDto) sqlSessionTemplate.selectOne(statement+"selectRequestManageDetail", params);
	}
	
	/**
	 * 요구사항관리 등록하는 메소드
	 */
	public void insertRequestManage(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertRequestManage", saveMap);
	}
	
	/**
	 * 요구사항관리 수정을 처리하는 메소드
	 */
	public void updateRequestManage(Map<String, Object> param) {
		sqlSessionTemplate.update(statement+"updateRequestManage", param);
	}
	
	/**
	 * 요구사항관리 답변을 수정을 처리하는 메소드
	 */
	public void updateRequestManageReply(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(statement+"updateRequestManageReply", saveMap);
	}
	
	/**
	 * 요구사항관리 삭제 페이지로 이동하는 메소드
	 */
	public void deleteRequestManage(Map<String,Object> saveMap) {
		sqlSessionTemplate.delete(statement+"deleteRequestManage", saveMap);
	}

	/**
	 * 게시판의 첨부파일을 삭제
	 */
	public void updateBoardAttachFile(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(statement+"updateBoardAttachFile", saveMap);
	}
	
	/**
	 * 요구사항관리의 첨부파일을 삭제
	 */
	public void updateRequestManageAttachFile(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(statement+"updateRequestManageAttachFile", saveMap);
	}
	
	/**
	 * 개선사항관리 리스트의 카운트 조회하는 메소드
	 */ 
	public int selectImproManageListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectImproManageListCnt", params);
	}
	
	/**
	 * 개선사항관리 리스트를 조회하여 반환하는 메소드
	 */
	
	public List<ImproDto> selectImproManageList(Map<String, Object> params, int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return sqlSessionTemplate.selectList(this.statement+"selectImproManageList", params, rowBounds);
	}
	
	/**
	 * 개선사항관리 상세 정보를 조회한다
	 */
	public ImproDto selectImproManageDetail(Map<String, Object> params) {
		return (ImproDto) sqlSessionTemplate.selectOne(statement+"selectImproManageDetail", params);
	}
	
	/**
	 * 개선사항관리 등록하는 메소드
	 */
	public void insertImproManage(Map<String, Object> saveMap) {
		this.sqlSessionTemplate.insert(statement+"insertImproManage", saveMap);
	}
	
	/**
	 * 개선사항관리 수정을 처리하는 메소드
	 */
	public void updateImproManage(Map<String, Object> param) {
		sqlSessionTemplate.update(statement+"updateImproManage", param);
	}
	
	/**
	 * 개선사항관리 답변을 수정을 처리하는 메소드
	 */
	public void updateImproManageReply(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(statement+"updateImproManageReply", saveMap);
	}
	
	/**
	 * 개선사항관리 삭제 페이지로 이동하는 메소드
	 */
	public void deleteImproManage(Map<String,Object> saveMap) {
		sqlSessionTemplate.delete(statement+"deleteImproManage", saveMap);
	}

	/**
	 * 게시판의 첨부파일을 삭제
	 */
	public void updateImproBoardAttachFile(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(statement+"updateImproBoardAttachFile", saveMap);
	}
	
	/**
	 * 개선사항관리의 첨부파일을 삭제
	 */
	public void updateImproManageAttachFile(Map<String, Object> saveMap) {
		sqlSessionTemplate.delete(statement+"updateRequestImproAttachFile", saveMap);
	}

	/**
	 * 벼룩시장리스트개수
	 */
	public int selectMarketListCnt(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectMarketListCnt", params);
	}
	
	public List<BoardDto> selectMarketList(Map<String, Object> params,int page, int rows) {
		RowBounds rowBounds = new RowBounds((page-1)*rows, rows);
		return  sqlSessionTemplate.selectList(this.statement+"selectMarketList", params, rowBounds);
	}

	public List<Map<String, Object>> selectParticipationCommentList(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectParticipationCommentList", params);
	}

	public Map<String, Object> selectParticipationBoardDetail(Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectParticipationBoardDetail", params);
	}

	public int deleteParticipation(Map<String, Object> saveMap) {
		return sqlSessionTemplate.delete(this.statement+"deleteParticipation", saveMap);
	}

	public void updateParticipationHitCnt(Map<String, Object> params) {
		sqlSessionTemplate.update(this.statement+"updateParticipationHitCnt", params);
	}

}
