package kr.co.bitcube.proposal.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.proposal.dao.ProposalDao;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.exception.FdlException;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class ProposalSvc {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private ProposalDao proposalDao;

	@Autowired
	private CommonSvc commonSvc;

	@Resource(name="seqProposalService")
	private EgovIdGnrService seqProposalService;

	@Resource(name="seqProposalHistService")
	private EgovIdGnrService seqProposalHistService;

	/** 리스트 카운트 조회 */
	public int selectProposalListCnt(Map<String, Object> params) {
		return proposalDao.selectProposalListCnt(params);
	}

	/** 리스트 조회 */
	public List<Map<String, Object>> selectProposalList( Map<String, Object> params, int page, int rows) {
		return proposalDao.selectProposalList(params, page, rows);
	}

	/** 상태값 코드리스트 조회 */
	public List<Map<String, Object>> selectProposalStat() {
		return proposalDao.selectProposalStat();
	}

	/** 비회원사용자의 경우에 nonUserId를 조회하여 반환한다 */
	public Integer selectNonUserId(Map<String, Object> selParam) {
		return proposalDao.selectNonUserId(selParam);
	}

	/** 신규자재 제안 정보를 저장한다 
	 * @throws FdlException */
	public void insertProposalInfo(Map<String, Object> params) throws FdlException {
		params.put("receiptNum", seqProposalService.getNextStringId());
		proposalDao.insertProposalInfo(params);
		this.sendEmailByReceiptNum("B2B", (String)params.get("receiptNum"));
	}

	/** 회원인 경우 사업자번호를 리턴한다. */
	public Map<String, Object> selectBusiNum(Map<String, Object> selParam) {
		LoginUserDto lud = (LoginUserDto) selParam.get("userInfoDto");
		Map<String, Object> returnMap = null;
		if("VEN".equals(lud.getSvcTypeCd())){
			returnMap = proposalDao.selectBusiNumForVen(selParam);
		}else if("BUY".equals(lud.getSvcTypeCd())){
			returnMap = proposalDao.selectBusiNumForBuy(selParam);
		}
		return returnMap;
	}


	/** 최종결정권 고객사 회원인지, 운영자인지, 글쓴이인지 값을 리턴한다.
	 * <br/> 비회원(loginId : XXXXXXXXXX)은 최종결정권 관련하여 케이스처리가 되어있다.
	 * <br/><b>필요값 값은 아래와 같다.</b>
	 * <br/>receiptNum
	 * <br/>LoginUserDto userInfoDto(세션에서 가져온 객체)
	 * <br/><font color=red><b>(주의)</b></font> IS_ADM은 <b>B2B 운영자 권한</b>을 가지고 있는 사용자를 뜻한다.
	 * @param params 
	 * @param userInfoDto */
	public Map<String, Object> getUserInfoMap(Map<String, Object> params, LoginUserDto userInfoDto){
		if("XXXXXXXXXX".equals(userInfoDto.getLoginId())){ 	// 비회원일 경우
			params.put("nonUserId", selectNonUserId(params).toString());
		}else{
			params.put("userId", userInfoDto.getUserId());
			params.put("searchB2BAdm", "true");
		}
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("FINAL_ROLE", params.containsKey("nonUserId") == false ? (String)proposalDao.selectProposalFinalRole(params) : "N");
		returnMap.put("IS_ADM", params.containsKey("nonUserId") == false ? (String)proposalDao.selectProposalIsB2BAdm(params) : "N" );
		returnMap.put("IS_WRITER", (String)proposalDao.selectProposalIsWriter(params));
		return returnMap;
	}

	/** SMPNEW_MATERSUGGEST 테이블을 업데이트 한다. 
	 * receiptNumStat 값이 있을 경우 업데이트. 
	 *  */
	public void updateProposalInfo(Map<String, Object> params) {
		proposalDao.updateProposalInfo(params);
		if(Integer.parseInt((String)params.get("receiptNumStat")) > 40){
			params.put("receiptNumForMail", params.get("receiptNum"));
			Map<String,Object> smsInfo = proposalDao.selectProposalDetailInfoForEmail(params);
			commonSvc.sendRightSms(smsInfo.get("SUGGESTPHONE").toString(),"[OKplaza] 신규자재제안 심사결과(접수번호:"+params.get("receiptNum")+") OKplaza에서 확인바랍니다.");
		}
	}

	/** * 상태변경이 있었을 경우 insert 
	 * @throws FdlException */
	public void insertProposalInfoHist(Map<String, Object> params) throws FdlException {
		params.put("stateNum", seqProposalHistService.getNextStringId());
		proposalDao.insertProposalInfoHist(params);
	}

	/** 상태를 조회한다 
	 * @return **/
	public int selectProposalStatus(Map<String, Object> params) {
		return proposalDao.selectProposalStatus(params);
	}

	/** 정보를 삭제한다 */
	public void delProposalInfo(Map<String, Object> params) {
		proposalDao.delProposalInfo(params);
	}

	/** B2B 운영자 조회*/
	public List<Map<String, Object>> selectProposalB2BAdmList(Map<String, Object> params) {
		return proposalDao.selectProposalB2BAdmList(params);
	}

	/** 신규제안 최종처리자 조회*/
	public List<Map<String, Object>> selectProposalFinalUserList(Map<String, Object> params) {
		return proposalDao.selectProposalB2BAdmList(params);
	}

	/** 신구자재 제안 리스트 엑셀  조회*/
	public List<Map<String, Object>> selectProposalListExcel( Map<String, Object> params) {
		return proposalDao.selectProposalListExcel(params);
	}

	/** 이메일 전송*/
	public void sendEmailByReceiptNum(String kind, String receiptNum) {
		Map<String, Object> params = new HashMap<String, Object>();
		List<Map<String,Object>> sendList = null;
		StringBuffer mailContents = new StringBuffer(); 
		params.put("receiptNumForMail", receiptNum);
        Map<String,Object> mailInfo = proposalDao.selectProposalDetailInfoForEmail(params);
		String subject = null;
        if("FINAL_USER".equals(kind)){
        	subject = "[OKplaza] 신규자재제안 채택여부 검토 바랍니다.";
        	mailContents.append("접수번호 : [<a href='http://okplaza.kr' target='_blank'>"+mailInfo.get("RECEIPTNUM")+"</a>]<br>");
        	mailContents.append("제안일자 : ["+mailInfo.get("SUGGESTDATE")+"]<br>");
        	mailContents.append("제안명 : ["+mailInfo.get("SUGGESTTITLE")+"]<br>");
        	mailContents.append("주요내용 : ["+mailInfo.get("SUGGESTCONTENT")+"]<br>");
        	mailContents.append("사업자명 : ["+mailInfo.get("BUSSINESSNM")+"]<br>");
        	mailContents.append("제안자 : ["+mailInfo.get("SUGGESTNAME")+"]<br>");
        	mailContents.append("<br>");
        	mailContents.append("검토결과 : ["+mailInfo.get("SUITABLESTAT_NM")+"]<br>");
        	mailContents.append("검토의견 : ["+mailInfo.get("SUITABLECONTENT")+"]<br>");
        	mailContents.append("검토자 : ["+mailInfo.get("SUITABLE_USER_NM")+"]<br>");
        	mailContents.append("신규자재 제안하기 메뉴에서 확인하십시오.");
        	params.put("suggestTargetVal", mailInfo.get("SUGGESTTARGETVAL"));//매니저 권한에 따라 메일 발송
        	sendList = proposalDao.selectProposalB2BAdmMailList(params);
        }else{
        	subject = "[OKplaza] 신규자재제안 접수 바랍니다.";
        	mailContents.append("접수번호 : [<a href='http://okplaza.kr' target='_blank'>"+mailInfo.get("RECEIPTNUM")+"</a>]<br>");
        	mailContents.append("제안일자 : ["+mailInfo.get("SUGGESTDATE")+"]<br>");
        	mailContents.append("제안명 : ["+mailInfo.get("SUGGESTTITLE")+"]<br>");
        	mailContents.append("주요내용 : ["+mailInfo.get("SUGGESTCONTENT")+"]<br>");
        	mailContents.append("사업자명 : ["+mailInfo.get("BUSSINESSNM")+"]<br>");
        	mailContents.append("제안자 : ["+mailInfo.get("SUGGESTNAME")+"]<br>");
        	mailContents.append("신규자재 제안하기 메뉴에서 확인하십시오.");
        	params.put("searchB2BAdm", "true");
        	sendList = proposalDao.selectProposalB2BAdmMailList(params);
        }
        Map<String,Object> tmpMap = null;
        if(sendList != null && sendList.size() > 0){
        	for(int i = 0; i < sendList.size() ; i++){
        		tmpMap = sendList.get(i);
        		commonSvc.saveSendMail(tmpMap.get("EMAIL").toString(), subject, mailContents.toString());
        	}
        }
	}

	public Map<String, Object> selectProposalCntText( Map<String, Object> params) {
		return proposalDao.selectProposalCntText(params);
	}

}
