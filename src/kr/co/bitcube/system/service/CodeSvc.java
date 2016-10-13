package kr.co.bitcube.system.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

//import kr.co.bitcube.common.dao.CommonDao;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.system.dao.CodeDao;
import kr.co.bitcube.system.dto.CodeTypesDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class CodeSvc {

	@Autowired
	private CodeDao codeDao;
	@Autowired
//	private CommonDao commonDao;
	@Resource(name="systemIdGenerationService")
	private EgovIdGnrService systemIdGenerationService; // id 생성을 위해 추가(2012-06-14, tytolee)

	
	/**
	 * 조회조건에 따른 코드타입개수 구하기
	 * @param params
	 * @return
	 */
	public int getCodeTypeListCnt(Map<String, Object> params) {
		return codeDao.selectCodeTypeListCnt(params);
	}

	/**
	 * 조회조건에 따른 코드타입리스트 구하기
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	public List<CodeTypesDto> getCodeTypeList(Map<String, Object> params, int page, int rows) {
		return codeDao.selectCodeTypeList(params, page, rows);
	}

	/**
	 * 코드값리스트 구하기
	 * @param params
	 * @return
	 */
	public List<CodesDto> getCodeList(Map<String, Object> params) {
		return codeDao.selectCodeList(params);
	}

	/**
	 * 코드타입 등록(타입코드 유니크 체크 포함)
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regCodeType(Map<String, Object> saveMap) throws Exception {
		int codeTypeCdCnt = codeDao.selectCodeTypeCdCnt((String)saveMap.get("codeTypeCd"));
		if(codeTypeCdCnt>0) { throw new Exception("입력하신 코드타입은 이미 등록되어 있습니다."); }
//		saveMap.put("codeTypeId", commonDao.selectCoreSystem()); // id 생성부분 변경(2012-06-14, tytolee)
		saveMap.put("codeTypeId", systemIdGenerationService.getNextStringId());
		codeDao.insertCodeType(saveMap);
	}

	/**
	 * 코드타입정보 수정
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modCodeType(Map<String, Object> saveMap) throws Exception  {
		codeDao.updateCodeType(saveMap);
	}

	/**
	 * 코드타입정보 일괄 수정
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modCheckCodeType(Map<String, Object> paramMap) throws Exception  {
		String[] codeTypeIdArray = (String[]) paramMap.get("codeTypeIdArray");
		String[] codeTypeNmArray = (String[]) paramMap.get("codeTypeNmArray");
		String[] codeFlagArray = (String[]) paramMap.get("codeFlagArray");
		String[] isUseArray = (String[]) paramMap.get("isUseArray");
		String[] codeTypeDescArray = (String[]) paramMap.get("codeTypeDescArray");
		String updaterId = (String) paramMap.get("updaterId");
		String remoteIp = (String) paramMap.get("remoteIp");
		int arrayCnt = 0;
		for(String codeTypeId : codeTypeIdArray) {
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("codeTypeId", codeTypeId);
			saveMap.put("codeTypeNm", codeTypeNmArray[arrayCnt]);
			saveMap.put("codeFlag", codeFlagArray[arrayCnt]);
			saveMap.put("isUse", isUseArray[arrayCnt]);
			saveMap.put("codeTypeDesc", codeTypeDescArray[arrayCnt]);
			saveMap.put("updaterId", updaterId);
			saveMap.put("remoteIp", remoteIp);
			codeDao.updateCodeType(saveMap);
			arrayCnt++;
		}
	}

	/**
	 * 코드타입정보 삭제(타입의 코드정보가 존재하면 예외발생)
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delCodeType(Map<String, Object> saveMap) throws Exception {
		int codesCnt = codeDao.selectCodesCnt((String)saveMap.get("codeTypeId"));
		if(codesCnt>0) { throw new Exception("입력하신 코드타입은 코드값이 존재 합니다."); }
		codeDao.deleteCodeType(saveMap);
	}

	/**
	 * 코드타입정보 일괄 삭제(타입의 코드정보가 존재하면 예외발생)
	 * @param paramMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delCheckCodeType(Map<String, Object> paramMap) throws Exception {
		String[] codeTypeIdArray = (String[]) paramMap.get("codeTypeIdArray");
		for(String codeTypeId : codeTypeIdArray) {
			int codesCnt = codeDao.selectCodesCnt(codeTypeId);
			if(codesCnt>0) { throw new Exception("입력하신 코드타입은 코드값이 존재 합니다."); }
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("codeTypeId", codeTypeId);
			codeDao.deleteCodeType(saveMap);
		}
	}

	/**
	 * 타입에 따른 코드정보 등록
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void regCodes(Map<String, Object> saveMap) throws Exception {
		int dupliCnt = codeDao.selectDupliCodesCnt(saveMap);
		if(dupliCnt > 0) throw new Exception("중복된 코드입니다.");
//		saveMap.put("codeId", commonDao.selectCoreSystem()); // id 생성 부분 변경(2012-06-14, tytolee)
		saveMap.put("codeId", systemIdGenerationService.getNextStringId());
		codeDao.insertCodes(saveMap);
	}

	/**
	 * 코드정보 수정
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modCodes(Map<String, Object> saveMap) {
		codeDao.updateCodes(saveMap);
	}

	/**
	 * 코드정보 일괄 수정
	 * @param paramMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modCheckCodes(Map<String, Object> paramMap) {
		String[] codeIdArray = (String[]) paramMap.get("codeIdArray");
		String[] codeVal1Array = (String[]) paramMap.get("codeVal1Array");
		String[] codeNm1Array = (String[]) paramMap.get("codeNm1Array");
		String[] codeVal2Array = (String[]) paramMap.get("codeVal2Array");
		String[] codeNm2Array = (String[]) paramMap.get("codeNm2Array");
		String[] disOrderArray = (String[]) paramMap.get("disOrderArray");
		String[] isUseArray = (String[]) paramMap.get("isUseArray");
		int arrayCnt = 0;
		for(String codeId : codeIdArray) {
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("codeId", codeId);
			saveMap.put("codeNm1", codeNm1Array[arrayCnt]);
			saveMap.put("codeVal1", codeVal1Array[arrayCnt]);
			saveMap.put("codeNm2", codeNm2Array[arrayCnt]);
			saveMap.put("codeVal2", codeVal2Array[arrayCnt]);
			saveMap.put("isUse", isUseArray[arrayCnt]);
			saveMap.put("disOrder", disOrderArray[arrayCnt]);
			codeDao.updateCodes(saveMap);
			arrayCnt++;
		}
	}

	/**
	 * 코드정보 삭제
	 * @param saveMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delCodes(Map<String, Object> saveMap) {
		codeDao.deleteCodes(saveMap);
	}

	/**
	 * 코드정보 일괄삭제
	 * @param paramMap
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delCheckCodes(Map<String, Object> paramMap) {
		String[] codeIdArray = (String[]) paramMap.get("codeIdArray");
		for(String codeId : codeIdArray) {
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("codeId", codeId);
			codeDao.deleteCodes(saveMap);
		}
	}

}
