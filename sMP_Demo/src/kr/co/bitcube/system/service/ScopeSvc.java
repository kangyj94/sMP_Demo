package kr.co.bitcube.system.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

import kr.co.bitcube.system.dao.ScopeDao;
import kr.co.bitcube.system.dto.MenuActivityDto;
import kr.co.bitcube.system.dto.ScopesDto;

@Service
public class ScopeSvc {

	@Autowired
	private ScopeDao scopeDao;
	@Resource(name="systemIdGenerationService")
	private EgovIdGnrService systemIdGenerationService; // id 생성을 위해 추가(2012-06-14, tytolee)
	
	/**
	 * 영역리스트를 가져옴
	 * @param params
	 * @return
	 */
	public List<ScopesDto> getScopeList(Map<String, Object> params) {
		return scopeDao.getScopeList(params);
	}

	/**
	 * 영역등록
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regScope(Map<String, Object> saveMap) throws Exception {
		int scopeCnt = scopeDao.selectScopeCnt(saveMap);
		if(scopeCnt>0) { throw new Exception("입력하신 영역코드는 이미 등록되어 있습니다."); }
//		saveMap.put("scopeId", commonDao.selectCoreSystem()); // id 생성을 위해 변경
		saveMap.put("scopeId", systemIdGenerationService.getNextStringId());
		scopeDao.insertScope(saveMap);
	}

	/**
	 * 영역수정
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modScope(Map<String, Object> saveMap) {
		scopeDao.updateScope(saveMap);
	}

	/**
	 * 영역삭제
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delScope(Map<String, Object> saveMap) {
		scopeDao.deleteScope(saveMap);
	}

	/**
	 * 영역과 연결된 메뉴화면권한 리스트
	 * @param params
	 * @return
	 */
	public List<MenuActivityDto> getScopeMenuActivityList(Map<String, Object> params) {
		return scopeDao.getScopeMenuActivityList(params);
	}

	/**
	 * 영역과 화면권한 연결 및 해제 처리
	 * @param paramMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void connectScope(Map<String, Object> paramMap) {
		String scopeId = (String) paramMap.get("scopeId");
		String[] connectRowKey = (String[]) paramMap.get("connectRowKey");
		String[] unConnectRowKey = (String[]) paramMap.get("unConnectRowKey");
		
		/*--------------영역과 화면권한 연결-------------*/
		if(connectRowKey!=null) {
			for(String connectRowString:connectRowKey) {
				String menuId = connectRowString.split(":")[0];
				String activityId = connectRowString.split(":")[1];
				Map<String, Object> saveMap = new HashMap<String,Object>();
				saveMap.put("scopeId", scopeId);
				saveMap.put("menuId", menuId);
				saveMap.put("activityId", activityId);
				scopeDao.insertScopeActivity(saveMap);
			}
		}
		
		/*--------------영역과 화면권한 연결해제-------------*/
		if(unConnectRowKey!=null) {
			for(String unConnectRowString:unConnectRowKey) {
				String menuId = unConnectRowString.split(":")[0];
				String activityId = unConnectRowString.split(":")[1];
				Map<String, Object> saveMap = new HashMap<String,Object>();
				saveMap.put("scopeId", scopeId);
				saveMap.put("menuId", menuId);
				saveMap.put("activityId", activityId);
				scopeDao.deleteScopeActivity(saveMap);
			} 
		}
	}

}
