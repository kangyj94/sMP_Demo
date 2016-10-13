package kr.co.bitcube.evaluate.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.adjust.dto.AdjustDto;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.evaluate.dao.EvaluateDao;
import kr.co.bitcube.evaluate.dto.EvaluateDto;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;


@Service
public class EvaluateSvc {
	@Autowired
	private EvaluateDao evaluateDao;
	@Autowired
	private GeneralDao generalDao; 
	@Resource(name="seqEvaluate")
	private EgovIdGnrService seqEvaluate;

	private Logger logger = Logger.getLogger(getClass());
	
	public List<EvaluateDto> selectEvalRow(Map<String, Object> paramMap) {
		return evaluateDao.selectEvalRow(paramMap);
	}
	
	public List<EvaluateDto> selectEvalCol(Map<String, Object> paramMap) {
		return evaluateDao.selectEvalCol(paramMap);
	}

	public List<EvaluateDto> selectEvalUsers(Map<String, Object> paramMap) {
		return evaluateDao.selectEvalUsers(paramMap);
	}

	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void saveEvaluate(HashMap<String, Object> saveMap) throws Exception {
		String[] evalSelCdArr = (String[])saveMap.get("evalSelCdArr");
		String[] evalDescArr = (String[])saveMap.get("evalDescArr");
		if(evalSelCdArr != null && evalSelCdArr.length > 0){
			String evalTypeCd = "";
			String evalSelCd = "";
			for(int i = 0 ; i < evalSelCdArr.length ; i++){
				evalTypeCd = evalSelCdArr[i].split("\\_")[0];	
				evalSelCd = evalSelCdArr[i].split("\\_")[1];
				saveMap.put("evalId"	, seqEvaluate.getNextStringId());
				saveMap.put("evalDesc"	, evalDescArr[i]);
				saveMap.put("evalTypeCd", evalTypeCd);
				saveMap.put("evalSelCd"	, evalSelCd);

				evaluateDao.insertEvaluate(saveMap);
			}			
		}
	}

	public List<Map<String, Object>> selectEvaluateList(Map<String, Object> params, int page, int rows) {
		
		List<EvaluateDto> rowList = this.selectEvalRow(params);
		
		String subQuery1 = "";
		String subQuery2 = "";

		if(rowList != null && rowList.size() > 0){
			for(EvaluateDto dto : rowList){
				subQuery1 += ",		DBO.FNS_CODENM1BYCODEVAL1('EVALSELCD',MAX(AA.EVALTYPECD_"+dto.getEvalTypeCd()+")) AS evalTypeCd_" + dto.getEvalTypeCd();
				subQuery2 += ",		CASE "; 
				subQuery2 += "			WHEN EVALTYPECD = '"+dto.getEvalTypeCd()+"' THEN EVALSELCD	";
				subQuery2 += "			ELSE 0";
				subQuery2 += "		END AS evalTypeCd_" + dto.getEvalTypeCd();
			}
		}
		
		params.put("subQuery1", subQuery1);
		params.put("subQuery2", subQuery2);
		return evaluateDao.selectEvaluateList(params, page, rows);
	}

	public int selectEvaluateListCnt(Map<String, Object> params) {
		return evaluateDao.selectEvaluateListCnt(params);
	}
	
	public List<Map<String, Object>> selectEvaluateListExcel(Map<String, Object> params) {
		
		List<EvaluateDto> colList = this.selectEvalCol(params);
		
		String subQuery1 = "";
		
		if(colList != null && colList.size() > 0){
			for(EvaluateDto dto : colList){
				subQuery1 += ",		CASE  ";
				subQuery1 += "			WHEN EVALSELCD = '"+dto.getEvalselCd()+"' THEN '1' ";
				subQuery1 += "			ELSE '' ";
				subQuery1 += "		END AS 	evalSelCd_"+dto.getEvalselCd();
			}
		}
		
		params.put("subQuery1", subQuery1);
		return evaluateDao.selectEvaluateListExcel(params);
	}
	/**
	 * 스마일 지수 팝업 관련 로직 (고객사, 공급사)
	 * params	{	
	 * 					userInfoDto : LoginUserDto 정보,  
	 * 					EVAL_SVCTYPECD : "BUY"or"Ven" -- 평가자 SVCTYPECD 
	 * 				}
	 * return	(map){ 
	 * 					isSmile : boolean // 설문조사 유무
	 * 					smileList : List<Map<String,Object>()> 설문조사 리스트
	 * 					admCnt : 평가대상자가 운영사인 질문 갯수
						venCnt : 평가대상자가 공급사인 질문 갯수
	 * 					
						-----(EVAL_SVCTYPECD = BUY  인 경우 추가 리턴 정보 있음--
	 * 					isRece : boolean // 지난 인수건 유무 
	 *					targetVendorId : String // 평가 대상업체 아이디
	 *					targetVenNm   : Strubg // 평가 대상업체 명
	 * 				}
	 */
	public Map<String,Object> getSmileEvalInfo ( ModelMap params ) throws Exception{
		
		Map<String,Object>	valid		= null;
		Map<String,Object>	result		= null;
		Map<String,Object>	smileEvalInfo = new HashMap();
		smileEvalInfo.put("isSmile", false);  
		smileEvalInfo.put("isRece", false); 
		
		valid = (Map<String,Object>)generalDao.selectGernalObject("evaluate.selectSmileEvalValid", params);
		smileEvalInfo.put("admCnt", (Integer) valid.get("ADM_CNT")); 
		smileEvalInfo.put("venCnt", 0); 
		
		
		if( valid !=null && (Integer)valid.get("Q_CNT")>0 && (Integer)valid.get("A_CNT")==0  ){ //설문내용이 있으면서, ,이번 주 답변 안한 경우 => 스마일 평가 대상자 
			smileEvalInfo.put("isSmile", true); 
			smileEvalInfo.put("smileList",   generalDao.selectGernalList("evaluate.selectSmileManageList", params) );
			if( params.get("EVAL_SVCTYPECD").equals("BUY") == true ){
				smileEvalInfo.put("venCnt", (Integer) valid.get("VEN_CNT")); 
				if( (Integer)valid.get("VEN_CNT") > 0 && (Integer)valid.get("RECE_CNT")>0 ){ //공급사 설문내용이 있으면서, 지난주 인수건 있는 경우 평가 대상 공급사 조회
					smileEvalInfo.put("isRece", true);
					result = (Map<String,Object> ) generalDao.selectGernalObject("evaluate.selectTargetVenInfo", params);
					smileEvalInfo.put("targetVenId", (String)result.get("VENDORID") );
					smileEvalInfo.put("targetVenNm", (String)result.get("VENDORNM") );
				}				
			}
		}
		return smileEvalInfo;
	}
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void setSmileEval( Map<String,Object> params ) throws Exception {
		ModelMap saveMap = new ModelMap();
		
		String[] smileIdArr = ( String[] ) params.get( "smileIdArr" );
		String[] targetSvcCdArr = ( String[] ) params.get( "targetSvcCdArr" );
		String[] evalArr = ( String[] ) params.get( "evalArr" );
		String targetVenId = ( String ) params.get( "targetVenId" );
		LoginUserDto userInfoDto= ( LoginUserDto ) params.get( "userInfoDto" );
		
		for( int i = 0 ; i < smileIdArr.length ; i++){
			saveMap.clear();
			saveMap.put( "SMILE_ID", smileIdArr[i] );
			saveMap.put( "TARGET_SVCTYPECD", targetSvcCdArr[i] );
			saveMap.put( "EVAL", evalArr[i] );
			saveMap.put( "TARGET_BORGID",    targetSvcCdArr[i].equals("ADM")  ? "13" : targetVenId );
			saveMap.put( "userInfoDto" , userInfoDto);
			generalDao.insertGernal("evaluate.insertSmileEval", saveMap);
		}	
		
	}

}
