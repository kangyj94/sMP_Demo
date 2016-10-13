package kr.co.bitcube.system.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

import kr.co.bitcube.system.dao.RoleDao;
import kr.co.bitcube.system.dto.MenuActivityDto;
import kr.co.bitcube.system.dto.RoleDto;
import kr.co.bitcube.system.dto.RoleMemberDto;
import kr.co.bitcube.system.dto.ScopesDto;

@Service
public class RoleSvc {

	@Autowired
	private RoleDao roleDao;
	@Resource(name="systemIdGenerationService")
	private EgovIdGnrService systemIdGenerationService; // id 생성을 위해 추가(2012-06-14, tytolee)
	
	/**
	 * 권한리스트를 가져옴
	 * @param params
	 * @return
	 */
	public List<RoleDto> getRoleList(Map<String, Object> params) {
		return roleDao.selectRoleList(params);
	}

	/**
	 * 권한과 연결된 영역 조회(isCheck가 1인 것이 연결된 영역)
	 * @param params
	 * @return
	 */
	public List<ScopesDto> getRoleScopeList(Map<String, Object> params) {
		return roleDao.selectRoleScopeList(params);
	}

	/**
	 * 권한생성(중복코드체크 포함)
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regRole(Map<String, Object> saveMap) throws Exception {
		int roleCnt = roleDao.selectRoleCnt(saveMap);
		if(roleCnt>0) { throw new Exception("입력하신 권한코드는 이미 등록되어 있습니다."); }
//		saveMap.put("roleId", commonDao.selectCoreSystem()); // id 생성부분 변경(2012-06-14, tytolee)
		saveMap.put("roleId", systemIdGenerationService.getNextStringId());
		roleDao.insertRole(saveMap);
	}

	/**
	 * 권한수정
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modRole(Map<String, Object> saveMap) {
		roleDao.updateRole(saveMap);
	}

	/**
	 * 권한삭제(연결된 영역도 연결을 끊음)
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delRole(Map<String, Object> saveMap) {
		roleDao.deleteRole(saveMap);
		roleDao.deleteRoleScope(saveMap);
	}

	/**
	 * 권한과 영역 연결 및 해제 처리
	 * @param paramMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void connectRole(Map<String, Object> paramMap) {
		String roleId = (String) paramMap.get("roleId");
		String[] connectRowKey = (String[]) paramMap.get("connectRowKey");
		String[] unConnectRowKey = (String[]) paramMap.get("unConnectRowKey");
		
		/*--------------권한과 영역 연결-------------*/
		if(connectRowKey!=null) {
			for(String scopeId:connectRowKey) {
				Map<String, Object> saveMap = new HashMap<String,Object>();
				saveMap.put("roleId", roleId);
				saveMap.put("scopeId", scopeId);
				roleDao.insertRoleScope(saveMap);
			}
		}
		
		/*--------------권한과 영역 연결해제-------------*/
		if(unConnectRowKey!=null) {
			for(String scopeId:unConnectRowKey) {
				Map<String, Object> saveMap = new HashMap<String,Object>();
				saveMap.put("roleId", roleId);
				saveMap.put("scopeId", scopeId);
				roleDao.deleteRoleScope(saveMap);
			} 
		}
	}

	/**
	 * 권한ID로 연결된 영역리스트을 가져옴
	 * @param params
	 * @return
	 */
	public List<ScopesDto> getScopeListByRoleId(Map<String, Object> params) {
		return roleDao.selectScopeListByRoleId(params);
	}

	/**
	 * 영역과 연결된 메뉴정보(화면권한 포함)
	 * @param params
	 * @return
	 */
	public List<MenuActivityDto> getRoleMenuList(Map<String, Object> params) {
		/*--------------------------메뉴의 화면권한정보을 ','로 단일행처리------------------------*/
		List<MenuActivityDto> menuActivityList = roleDao.selectRoleMenuList(params);
		List<MenuActivityDto> returnMenuActivityList = new ArrayList<MenuActivityDto>();
		for(MenuActivityDto tmpDto : menuActivityList) {
			if(returnMenuActivityList.size()==0) {
				returnMenuActivityList.add(tmpDto);
			} else {
				String menuId = tmpDto.getMenuId();
				boolean isSameMenuId = false;
				for(MenuActivityDto tmpDto2 : returnMenuActivityList) {
					String menuId2 = tmpDto2.getMenuId();
					if(menuId.equals(menuId2)) {
						tmpDto2.setActivityId(tmpDto2.getActivityId()+","+tmpDto.getActivityId());
						tmpDto2.setActivityCd(tmpDto2.getActivityCd()+","+tmpDto.getActivityCd());
						tmpDto2.setActivityNm(tmpDto2.getActivityNm()+","+tmpDto.getActivityNm());
						isSameMenuId = true;
					}
				}
				if(!isSameMenuId) returnMenuActivityList.add(tmpDto);
			}
		}
		return returnMenuActivityList;
	}

	/**
	 * 권한과 연결된 사용자 조회 개수
	 * @param params
	 * @return
	 */
	public int getRoleMemberListCnt(Map<String, Object> params) {
		return roleDao.selectRoleMemberListCnt(params);
	}

	/**
	 * 권한과 연결된 사용자 조회
	 * @param params
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<RoleMemberDto> getRoleMemberList(Map<String, Object> params, int page, int rows) {
		return roleDao.selectRoleMemberList(params, page, rows);
	}

	/**
	 * 권한과 연결된 사용자개수
	 * @param paramMap
	 * @return
	 */
	public int getRoleUserCnt(Map<String, Object> params) {
		return roleDao.selectRoleUserCnt(params);
	}

	/**
	 * 사용자조직권한 연결 등록
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regUserRole(Map<String, Object> saveMap) {
		roleDao.insertUserRole(saveMap);
	}

	/**
	 * 사용자조직권한 연결 수정
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modUserRole(Map<String, Object> saveMap) {
		roleDao.updateUserRole(saveMap);
	}

	/**
	 * 사용자조직권한 연결 삭제
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delUserRole(Map<String, Object> saveMap) {
		roleDao.deleteUserRole(saveMap);
	}
}
