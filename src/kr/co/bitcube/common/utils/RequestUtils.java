package kr.co.bitcube.common.utils;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.bitcube.common.dto.LoginUserDto;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class RequestUtils {

	private static final Logger logger = Logger.getLogger(RequestUtils.class);
	@SuppressWarnings("rawtypes")
	private static final Class[] parameterTypes = {ModelMap.class};
	
	/**
	 * Request 파라메터를 Map으로 바인딩 처리 
	 * @param request
	 * @return
	 */
	public static ModelMap bind(HttpServletRequest request) {
		return bind(request, null);
	}

	/**
	 * Request 파라메터를 변수 ModelMap으로 바인딩 처리
	 * @param request
	 * @param parameters
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static ModelMap bind(HttpServletRequest request, ModelMap parameters) {
		if (parameters == null) {
			parameters = new ModelMap();
		}
		Enumeration<String> e = request.getParameterNames();
		while (e.hasMoreElements()) {
			String key = e.nextElement();
			if(request.getParameterValues(key).length>1) {
				String[] values = request.getParameterValues(key);
				if(key.indexOf("[")>0) {
					key = key.substring(0, key.indexOf("["));
				}
				List<String> list = new ArrayList<String>();
				for(String value : values) {
					list.add(value);
				}
				parameters.put(key, list);
			} else {
				if(key.indexOf("[]")>-1) {
//					String[] values = { request.getParameter(key) };
//					parameters.put(key, values);
					String[] values = { request.getParameter(key) };
					key = key.substring(0, key.indexOf("["));
					List<String> list = new ArrayList<String>();
					list.add(values[0]);
					parameters.put(key, list);
				} else {
					int startArrayTagCnt = StringUtils.countMatches(key, "[");
					int endArrayTagCnt = StringUtils.countMatches(key, "]");
					if(startArrayTagCnt==1 && endArrayTagCnt==1) {
						String objectKey = key.substring(0, key.indexOf("["));
						String subKey = key.substring(key.indexOf("[")+1,key.indexOf("]"));
						if(!parameters.containsKey(objectKey)) {
							Map<String,Object> objMap = new HashMap<String,Object>();
							objMap.put(subKey, request.getParameter(key));
							parameters.put(objectKey,objMap);
						} else {
							Map<String,Object> map = (Map<String, Object>) parameters.get(objectKey);
							map.put(subKey, request.getParameter(key));
						}
					} else if(startArrayTagCnt==2 && endArrayTagCnt==2) {
						String listNm = key.substring(0, key.indexOf("["));
						int listIndex = Integer.valueOf(key.substring(key.indexOf("[")+1,key.indexOf("]")));
						String mapKey = key.substring(key.lastIndexOf("[")+1,key.lastIndexOf("]"));
						if(!parameters.containsKey(listNm)) {
							List<Map<String,Object>> paramList = new ArrayList<Map<String,Object>>();
							Map<String,Object> objMap = new HashMap<String,Object>();
							objMap.put(mapKey, request.getParameter(key));
							for(int i=0;i<listIndex;i++) {
								try{
									paramList.get(i);
								} catch(java.lang.IndexOutOfBoundsException ie) {
									Map<String,Object> tmpMap = new HashMap<String,Object>();
									paramList.add(i, tmpMap);
								}
							}
							paramList.add(listIndex, objMap);
							parameters.put(listNm, paramList);
						} else {
							List<Map<String,Object>> paramList = (List<Map<String, Object>>) parameters.get(listNm);
							Map<String,Object> map = null;
							boolean isNotExistMap = true;
							while(isNotExistMap) {
								try{
									map = paramList.get(listIndex);
									map.put(mapKey, request.getParameter(key));
									isNotExistMap = false;
								} catch(java.lang.IndexOutOfBoundsException ie) {
									for(int i=0;i<listIndex+1;i++) {
										try{
											paramList.get(i);
										} catch(java.lang.IndexOutOfBoundsException ex) {
											Map<String,Object> tmpMap = new HashMap<String,Object>();
											paramList.add(i, tmpMap);
										}
									}
								}
							}
						}
					} else {
						parameters.put(key, request.getParameter(key));
					}
					
				}
			}
		}
		return parameters;
	}
//	public static ModelMap bind(HttpServletRequest request, ModelMap parameters) {
//		if (parameters == null) {
//			parameters = new ModelMap();
//		}
//		Enumeration<String> paramEnum = request.getParameterNames();
//		while(paramEnum.hasMoreElements()) {
//			String paramString = paramEnum.nextElement();
//			String []fieldValues = request.getParameterValues(paramString);
//			String fieldValue = request.getParameter(paramString);
//			if(fieldValues.length>1) parameters.put(paramString, fieldValues);
//			else parameters.put(paramString, fieldValue);
//		}
//		return parameters;
//	}
	
	/**
	 * 공통모듈처리여부 확인(공통모듈이 아닐경우 서비스 수행)
	 * @param context : WebApplicationContext
	 * @param serviceNm : Call Service Name
	 * @param methodNm : Call Service Method Name
	 * @param paramMap : Parameter Map
	 * @return
	 */
	public static boolean invokeService(WebApplicationContext context, String serviceNm, String methodNm, ModelMap paramMap) {
		
		boolean result = false;
		try {
			Object obj = context.getBean(serviceNm);
			Object[] args = {paramMap};
			MethodUtils.invokeMethod(obj, methodNm, args, parameterTypes);
		} catch (NoSuchBeanDefinitionException be) {
			result = true;
			logger.info("=========================================================== 공통모듈 처리 ===========================================================");
		} catch (NoSuchMethodException se) {
			result = true;
			logger.info("=========================================================== 공통모듈 처리 ===========================================================");
		} catch (Exception e) {
			result = true;
			logger.info("=========================================================== 서비스에서 에러 발생 ===========================================================");
			
		}
		return result;
	}
	
	/**
	 * 로그인 사용자의 정보를 반환하는 메소드
	 * 
	 * @param request (HttpServletRequest)
	 * @return LoginUserDto (로그인 사용자 정보)
	 * @throws Exception
	 */
	public static LoginUserDto getLoginUserDto(HttpServletRequest request) throws Exception{
		LoginUserDto      loginUserDto       = null;
		HttpSession       httpSession        = null;
		
		httpSession  = request.getSession();
		loginUserDto = (LoginUserDto)httpSession.getAttribute(Constances.SESSION_NAME);
		
		return loginUserDto;
	}
	
	/**
	 * 로그인 사용자의 정보를 반환하는 메소드
	 * 
	 * @return LoginUserDto (로그인 사용자 정보)
	 * @throws Exception
	 */
	public static LoginUserDto getLoginUserDto() throws Exception{
		HttpServletRequest httpServletRequest = null;
		LoginUserDto       result             = null;
		
		httpServletRequest = RequestUtils.getHttpServletRequest();
		result             = RequestUtils.getLoginUserDto(httpServletRequest);
		
		return result;
	}
	
	/**
	 * 현재 사용중인  request를 반환하는 메소드
	 * @return HttpServletRequest
	 * @throws Exception
	 */
	public static HttpServletRequest getHttpServletRequest() throws Exception{
		ServletRequestAttributes servletRequestAttributes = null;
		HttpServletRequest       httpServletRequest       = null;
		
		servletRequestAttributes = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
		httpServletRequest       = servletRequestAttributes.getRequest();
		
		return httpServletRequest;
	}
	
	/**
	 * reqeust로 파라메타정보를 로그에 뿌림
	 * @param request
	 */
	public static void debugRequestParameter(HttpServletRequest request) {
		if(logger.isDebugEnabled()) {
			logger.debug("-------------------------start!---------------------------");
			Enumeration<String> paramEnum = request.getParameterNames();
			while(paramEnum.hasMoreElements()) {
				String paramString = paramEnum.nextElement();
				String []fieldValues = request.getParameterValues(paramString);
				int j = 0;
				for(String fieldValue : fieldValues) {
					logger.debug("Search FieldName : " + paramString + ",  FieldValue["+(j++)+"] : "+fieldValue);
				}
			}
			logger.debug("-------------------------end!---------------------------");
		}
	}
}
