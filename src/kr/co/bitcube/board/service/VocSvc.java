package kr.co.bitcube.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.board.dao.VocDao;
import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.board.dto.VocDto;
import kr.co.bitcube.common.dto.CodesDto;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.system.service.CodeSvc;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class VocSvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private VocDao vocDao;
	@Autowired
	private CodeSvc codeSvc;
	@Autowired
	private CommonSvc commonSvc;
	
	@Resource(name="seqVocBoardService")
	private EgovIdGnrService seqVocBoardService;
	
	
	/** 고객의 소리 등록 */
	public void insertVocInfo(Map<String, Object> saveMap) throws Exception {
		Map<String, Object> params			= null;
		List<CodesDto>		vocMailSendList	= null;
		CodesDto			codesDto		= null;
		int i								= 0;
		String vocMailSend					= "";
		String emailSubject					= "";
		String svcTypeName					= "";
		String emailContent					= "";
		
		saveMap.put("voc_no", seqVocBoardService.getNextStringId());// PK 값 조회
		String receType = "01"; // 기본적으로는 구축사
		String svcTypeCd = (String)saveMap.get("svcTypeCd");
		if(svcTypeCd.equals("BUY") == false){ receType = "02";}		// 고객사가 아닐 경우 자재BP 처리를 위해.		
		saveMap.put("rece_type", receType);
		
		if("01".equals(receType)){
			svcTypeName = "구축사";
		}
		else if("02".equals(receType)){
			svcTypeName = "자재BP";
		}
		
		params			= new HashMap<String, Object>();
		
		params.put("srcCodeTypeCd", "VOC_MAIL_SEND");
		params.put("orderString",   "A.DISORDER ASC");
		params.put("srcIsUse",   "1");
		vocMailSendList = this.codeSvc.getCodeList(params);				// 고객의 소리 처리자 이메일 리스트
		
		emailSubject = "[고객의 소리]" + saveMap.get("title");
		
		emailContent = "업체명 : [" + svcTypeName + "]" + saveMap.get("borgNm") + "<P>";
		emailContent += "작성자 : " + saveMap.get("regi_user_name") + "<BR>";
		emailContent += "내용 : " + saveMap.get("message");
		
		logger.debug("vocMailSend : " + vocMailSend);
		logger.debug("emailSubject : " + emailSubject);
		logger.debug("emailContent : " + emailContent);
		
		try{
			vocDao.insertVocInfo(saveMap);
			
			for(i = 0; i < vocMailSendList.size(); i++){
				codesDto = vocMailSendList.get(i);
				commonSvc.saveSendMail(codesDto.getCodeVal2(), emailSubject, emailContent);
			}
		}
		catch(Exception e){
			logger.error("Voc Save Error : "+e); 
		}
		
		// 이메일 전송
	}

	public int getVocListCnt(Map<String, Object> params) {
		return vocDao.selectVocListCnt(params);
	}

	public List<VocDto> getVocList(Map<String, Object> params, int page, int rows) {
		return vocDao.selectVocList(params, page, rows);
	}
	
	
	public VocDto getSelectVocDetail(Map<String, Object> searchMap, LoginUserDto loginUserDto) {
		return this.vocDao.selectVocDetail(searchMap);
	}
	
}
