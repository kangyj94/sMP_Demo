package kr.co.bitcube.common.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class WebChatDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private final String statement = "common.webChat.";
	
	/**
	 * 채팅내용을 저장하는 메소드<br/>
	 * 파라미터 맵 구조
	 * <ul>
	 * 	<li>
	 * 		chatId : 채팅 시컨스
	 * 	</li>
	 * 	<li>
	 * 		fromId : 발신자ID
	 * 	</li>
	 * 	<li>
	 * 		toId : 수신자ID
	 * 	</li>
	 * 	<li>
	 * 		message : 메세지
	 * 	</li>
	 * </ul>
	 * 
	 * @author tytolee
	 * @param params
	 * @throws Exception
	 * @since 2012-06-20
	 */
	public void insertWebChatInfo(Map<String, String> params) throws Exception{
		this.sqlSessionTemplate.insert(this.statement + "insertWebChatInfo", params);
	}
	
	/**
	 * 채팅 메세지 리스트를 조회하여 반환하는 메소드<br/>
	 * params 구조
	 * <ul>
	 * 	<li>
	 * 		fromId (발신자 아이디)
	 * 	</li>
	 * 	<li>
	 * 		toId (수신자 아이디)
	 * 	</li>
	 * 	<li>
	 * 		fromDate (검색 시작일, 선택사항) 
	 * 	</li>
	 * 	<li>
	 * 		toDate (검색 종료일, 선택사항) 
	 * 	</li>
	 * </ul>
	 * 
	 * @author tytolee
	 * @param params
	 * @return List<HashMap>
	 * @throws Exception
	 * @since 2012-06-19
	 */
	public List<HashMap> selectWebChatMessageList(Map<String, String> params, RowBounds rowBounds) throws Exception{
		List<HashMap> list = null;
		
		list = this.sqlSessionTemplate.selectList(this.statement + "selectWebChatMessageList", params, rowBounds);
		
		return list;
	}
	
	/**
	 * 채팅 메세지 리스트 카운트를 조회하여 반환하는 메소드<br/>
	 * params 구조
	 * <ul>
	 * 	<li>
	 * 		fromId (발신자 아이디)
	 * 	</li>
	 * 	<li>
	 * 		toId (수신자 아이디)
	 * 	</li>
	 * 	<li>
	 * 		fromDate (검색 시작일, 선택사항) 
	 * 	</li>
	 * 	<li>
	 * 		toDate (검색 종료일, 선택사항) 
	 * 	</li>
	 * </ul>
	 * 
	 * @author tytolee
	 * @param params
	 * @return Integer
	 * @throws Exception
	 * @since 2012-06-19
	 */
	public Integer selectWebChatMessageListCount(Map<String, String> params) throws Exception{
		Integer count = null;
		
		count = (Integer)this.sqlSessionTemplate.selectOne(this.statement + "selectWebChatMessageListCount", params);
		
		return count;
	}
}
