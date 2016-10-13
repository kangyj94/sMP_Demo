package kr.co.bitcube.system.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.dto.ActivitiesDto;
import kr.co.bitcube.system.dao.MenuActivityDao;
import kr.co.bitcube.system.dto.MenuDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class MenuActivitySvc {

	@Autowired
	private MenuActivityDao menuActivityDao;
	@Autowired
	@Resource(name="systemIdGenerationService")
	private EgovIdGnrService systemIdGenerationService; // id 생성을 위해 추가(2012-06-14, tytolee)
	
	/**
	 * 하이라키 구조의 메뉴정보리스트를 가져옴
	 * @param srcSvcTypeCd
	 * @return
	 */
	public List<MenuDto> getMenuList(String srcSvcTypeCd) {
		List<MenuDto> returnMenuList = new ArrayList<MenuDto>();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("srcSvcTypeCd", srcSvcTypeCd);
		List<MenuDto> svcMenuList = menuActivityDao.selectSvcMenuList(params);
		for(MenuDto menuDto : svcMenuList) {
			returnMenuList.add(menuDto);
			params.clear();
			params.put("srcSvcTypeCd", menuDto.getSvcTypeCd());
			List<MenuDto> menuList = menuActivityDao.selectMenuList(params);
			for(MenuDto menuDto2 : menuList) {
				returnMenuList.add(menuDto2);
			}
		}
		return returnMenuList;
	}
	
	/**
	 * 메뉴 등록(메뉴코드 유니크 체크 포함)
	 * @param saveMap
	 * @throws Exception 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regMenu(Map<String, Object> saveMap) throws Exception {
		int menuCdCnt = menuActivityDao.selectMenuCdCnt((String)saveMap.get("menuCd"));
		if(menuCdCnt>0) { throw new Exception("입력하신 메뉴타입은 이미 등록되어 있습니다."); }
		saveMap.put("menuId", systemIdGenerationService.getNextStringId());
		menuActivityDao.insertMenu(saveMap);
	}
	
	/**
	 * 메뉴정보 수정
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modMenu(Map<String, Object> saveMap) {
		menuActivityDao.updateMenu(saveMap);
	}
	
	/**
	 * 메뉴정보삭제(화면권한과 영역이 연결되어 있으면 예외발생)
	 * @param saveMap
	 * @throws Exception 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delMenu(Map<String, Object> saveMap) throws Exception {
		int activityCnt = menuActivityDao.selectActivityCnt((String)saveMap.get("menuId"));
		if(activityCnt>0) { throw new Exception("해당메뉴는 메뉴권한과 연결되어 있습니다.<br>메뉴권한의 연결을 끊은 후 처리하십시오"); }
		//영역메뉴권한(메뉴와화면권한와영역의 연결) 삭제는  영역삭제시 처리하는게 낫을 듯함 
		//int scopeCnt = menuActivityDao.selectScopeCnt((String)saveMap.get("menuId"));
		//if(scopeCnt>0) { throw new Exception("해당메뉴는 영역과 연결되어 있습니다.<br>영역과의 연결을 끊은 후 처리하십시오"); }
		menuActivityDao.deleteMenu(saveMap);
	}

	/**
	 * 메뉴와 연결된 화면권한 리스트
	 * @param srcMenuId
	 * @return
	 */
	public List<ActivitiesDto> getActivityList(String srcMenuId) {
		return menuActivityDao.selectActivityList(srcMenuId);
	}

	/**
	 * 메뉴와 연결 안된  화면권한 개수
	 * @param params
	 * @return
	 */
	public int getUnActivityListCnt(Map<String, Object> params) {
		return menuActivityDao.selectUnActivityListCnt(params);
	}

	/**
	 * 메뉴와 연결 안된  화면권한 리스트
	 * @param params
	 * @param rows 
	 * @param page 
	 * @return
	 */
	public List<ActivitiesDto> getUnActivityList(Map<String, Object> params, int page, int rows) {
		return menuActivityDao.selectUnActivityList(params, page, rows);
	}

	/**
	 * 메뉴와 화면권한 연결
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regMenuActivity(Map<String, Object> saveMap) {
		menuActivityDao.insertMenuActivity(saveMap);
	}

	/**
	 * 메뉴와 화면권한 연결 삭제
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delMenuActivity(Map<String, Object> saveMap) {
		menuActivityDao.deleteMenuActivity(saveMap);
		if((Boolean)saveMap.get("delTransScope")) {	//영역과의 연결삭제
			menuActivityDao.deleteMenuActivityScope(saveMap);
		}
	}

	/**
	 * 등록되어 있는 화면권한코드 개수
	 * @param saveMap
	 * @throws Exception 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regActivity(Map<String, Object> saveMap) throws Exception {
		int activityCdCnt = menuActivityDao.selectActivityCntByCd((String)saveMap.get("activityCd"));
		if(activityCdCnt>0) { throw new Exception("입력하신 화면권한코드는 이미 등록되어 있습니다."); }
		saveMap.put("activityId", systemIdGenerationService.getNextStringId());
		menuActivityDao.insertActivity(saveMap);
	}

	/**
	 * 화면권한정보를 수정
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modActivity(Map<String, Object> saveMap) {
		menuActivityDao.updateActivity(saveMap);
	}

	/**
	 * 화면권한정보 삭제
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delActivity(Map<String, Object> saveMap) {
		menuActivityDao.deleteActivity(saveMap);
	}

	public Map<String, Object> getMenuPath(Map<String, Object> params) {
		return menuActivityDao.selectMenuPath(params);
	}
	
}
