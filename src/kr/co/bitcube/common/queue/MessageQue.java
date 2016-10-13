package kr.co.bitcube.common.queue;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import kr.co.bitcube.common.dto.WebChatDto;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;



/**
 * 웹 채팅에 사용할 메세지 큐 클래스
 * 
 * @author tytolee
 * @since 2012-05-22
 */
public class MessageQue extends LinkedList<WebChatDto>{
	private static final long serialVersionUID = 1L;
	private Integer           messageSeq       = 0;
	private WebChatDto        lastMessage      = new WebChatDto();
	private Log            logger         = LogFactory.getLog(this.getClass());
	
	public WebChatDto getLastMessage() {
		return lastMessage;
	}

	public void setLastMessage(WebChatDto lastMessage) {
		this.lastMessage = lastMessage;
	}
	
	protected Integer getMessageSeq() {
		return messageSeq;
	}

	protected void setMessageSeq(Integer messageSeq) {
		this.messageSeq = messageSeq;
	}

	/**
	 * 메세지를 큐에 넣는 메소드
	 * 
	 * @author tytolee
	 * @param webChatDto (메세지 객체)
	 * @since 2012-05-22
	 * @modify 2012-06-18 (로그인 정보가 존재할 경우 skip 하는 부분 추가, tytolee)
	 */
	@Override
	public synchronized void push(WebChatDto webChatDto){
		int        i              = 0;
		WebChatDto tempWebChatDto = null;
		
		if((webChatDto.getType() != null) && (webChatDto.getType().equals("LOGIN"))){ // 로그인 메세지 처리일 경우
			for(i = 0; i < this.size(); i++){
				tempWebChatDto = this.get(i);
				
				if(webChatDto.getFromMemberNo().equals(tempWebChatDto.getFromMemberNo())){ // 동일 발신자의 메세지인 경우
					if(tempWebChatDto.getType().equals("LOGIN")){ // 먼저 들어온 로그인 정보가 있을 경우
						return;
					}
				}
			}
		}
		
		this.addLast(webChatDto);
		
		try{
			this.notifyAll();
		}
		catch(Exception e){}
	}
	
	/**
	 * 메세지 큐에서 메세지를 하나 꺼내오는 메소드<br/>
	 * 결과 맵 구조
	 * <ul>
	 * 	<li>
	 * 		WebChatDto (메세지 객체 리스트)
	 * 	</li>
	 * 	<li>
	 * 		messageSeq (메세지 번호)
	 * 	</li>
	 * </ul>
	 * 
	 * @author tytolee
	 * @param sequence (조회 시컨스 파라미터)
	 * @return Map<String, Object>
	 * @since 2012-05-22
	 * @modify 파라미터 sequence 추가 (2012-05-30, tytolee)
	 * @modify sequence와 비교하여 메세지 리턴 (2012-05-30, tytolee)
	 * @modify 리턴 결과형 변경(2012-05-30, tytolee)
	 * @modify 부모 클래스 메소드명과 중복되어 메소드명 변경(2012-05-30, tytolee)
	 * @modify 하나의 객체를 반환하는  것이 아니라 모든 리스트를 반환(2012-06-18, tytolee)
	 * @modify 히스토리성 주석 삭제(2012-06-18, tytolee)
	 */
	public synchronized Map<String, Object> popMessage(Integer sequence){
		List<WebChatDto>    result         = null;
		Integer             integer        = null;
		Map<String, Object> map            = null;
		WebChatDto          tempWebChatDto = null;
		
		map    = new HashMap<String, Object>();
		result = new ArrayList<WebChatDto>();
		
		integer = this.getMessageSeq();
		
		if(sequence.intValue() != integer.intValue()){ // 시컨스 불일치시 마지막 메세지 반환
			result.add(this.getLastMessage());
		}
		else
			{
			
//			while(this.size() <= 0){
//				try{
							
//					Thread.sleep(1000);
					
//				}
//				catch(Exception e){
					
//					
					
//				}
//			}
			
			if(this.size() <= 0){
				try {
					Thread.sleep(1000);
				} catch (Exception e) {}
			}
			
			while(this.size() > 0){
				tempWebChatDto = this.removeFirst();
				if(integer == (Integer.MAX_VALUE - 1)){
					this.setMessageSeq(1);
				}
				else{
					this.setMessageSeq(integer.intValue() + 1);
				}
				this.setLastMessage(tempWebChatDto);
				result.add(tempWebChatDto);
			}
		}
		for(WebChatDto webChatDto1 : result) {
			logger.debug("webChatDto1 : " + webChatDto1);
		}

		map.put("WebChatDto", result);
		map.put("messageSeq", this.getMessageSeq());
		
		return map;
	}
}