package kr.co.bitcube.common.listener;

import java.util.HashMap;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import kr.co.bitcube.common.service.WebChatService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.FrameworkServlet;

/**
 * 세션 생성 및 제거시 호출되는 리스너
 * 
 * @author tytolee
 * @since 2012-05-24
 */
public class SessionListener implements HttpSessionListener {
	@Autowired
	private WebChatService webChatService;
	
	/**
	 * 리스너 초기화시 호출되는 메소드
	 * 
	 * @author tytolee
	 * @param sce
	 * @since 2012-05-31
	 * @modify 2012-05-31(메소드가 호출이 되지 않아 주석처리, tytolee)
	 */
//	public void contextInitialized(ServletContextEvent sce){
//		WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext(), FrameworkServlet.SERVLET_CONTEXT_PREFIX + "bithome").getAutowireCapableBeanFactory().autowireBean(this);
//	}
	
	/**
	 * 세션 생성시 호출되는 메소드
	 * 
	 * @author tytolee
	 * @param httpSessionEvent
	 * @since 2012-05-24
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void sessionCreated(HttpSessionEvent httpSessionEvent) {
		HttpSession                  httpSession      = null;
		ServletContext               servletContext   = null;
		HashMap<String, HttpSession> accessSessionMap = null;
		String                       httpSessionId    = null;
		
		httpSession      = httpSessionEvent.getSession();
		servletContext   = httpSession.getServletContext();
		accessSessionMap = (HashMap<String, HttpSession>)servletContext.getAttribute("accessSessionMap");
		
		if(accessSessionMap == null){
			servletContext.setAttribute("accessSessionMap", new HashMap<String, HttpSession>());
			
			accessSessionMap = (HashMap<String, HttpSession>)servletContext.getAttribute("accessSessionMap");
		}
		
		httpSessionId = httpSession.getId();
		
		accessSessionMap.put(httpSessionId, httpSession);
	}

	/**
	 * 세션 제거시 호출되는 메소드
	 * 
	 * @author tytolee
	 * @param httpSessionEvent
	 * @since 2012-05-24
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
		HttpSession                  httpSession      = null;
		ServletContext               servletContext   = null;
		HashMap<String, HttpSession> accessSessionMap = null;
		String                       httpSessionId    = null;
		
		httpSession = httpSessionEvent.getSession();
		
		try{
			WebApplicationContextUtils.getWebApplicationContext(httpSession.getServletContext(), FrameworkServlet.SERVLET_CONTEXT_PREFIX + "system").getAutowireCapableBeanFactory().autowireBean(this);
			this.webChatService.logoutAnnounce(httpSession); // 로그아웃을 전달(2012-05-31, tytolee)
		} catch(NullPointerException ex) {
		} catch(Exception e){
			
		}
		
		servletContext   = httpSession.getServletContext();
		accessSessionMap = (HashMap<String, HttpSession>)servletContext.getAttribute("accessSessionMap");
		
		httpSessionId = httpSession.getId();
		
		accessSessionMap.remove(httpSessionId);
	}
}