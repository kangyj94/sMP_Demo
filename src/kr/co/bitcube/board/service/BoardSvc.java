package kr.co.bitcube.board.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bitcube.board.dao.BoardDao;
import kr.co.bitcube.board.dto.BoardDto;
import kr.co.bitcube.board.dto.ImproDto;
import kr.co.bitcube.board.dto.MerequDto;
import kr.co.bitcube.common.dao.GeneralDao;
import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service
public class BoardSvc {

	@Autowired
	private BoardDao boardDao;
	@Resource(name="seqMpBoardService")
	private EgovIdGnrService seqMpBoardService;
	@Autowired
	private CommonSvc commonSvc;
	
	//개선요청 seq
	@Resource(name="seqImpro")
	private EgovIdGnrService seqImpro;
	
	@Resource(name="seqRepair")
	private EgovIdGnrService seqRepair;
	
	@Autowired private GeneralDao generalDao;
	
	private Logger logger = Logger.getLogger(getClass());
	
	/**
	 * 공지사항 리스트의 카운트 조회하는 메소드
	 */
	public int getNoticeListCnt(Map<String, Object> params) {
		return boardDao.selectNoticeListCnt(params);
	}

	/**
	 * 공지사항 리스트를 조회하여 반환하는 메소드
	 */
	public List<BoardDto> getNoticeList(Map<String, Object> params, int page, int rows) {
		List<BoardDto> list = new ArrayList<BoardDto>();
		list = boardDao.selectNoticeList(params, page, rows);
		return list;
	}

	/**
	 * 게시판 리스트를 조회하여 반환하는 메소드
	 */
	public int getBoardListCnt(Map<String, Object> params) {
		return boardDao.selectBoardListCnt(params);
	}
	public List<BoardDto> getBoardList(Map<String, Object> params, int page, int rows) {
		return boardDao.selectBoardList(params, page, rows);
	}
	
	/** 
	 * 공지사항 및 게시판 상세 정보를 조회한다.
	 */
	public BoardDto getNoticeDetailInfo(Map<String, Object> searchMap) {
		boardDao.updateHit_No(searchMap); // 조회수 하나 증가
		return this.boardDao.selectNoticeDetail(searchMap);
	}
		
	/** 
	 * 공지사항 팝업 페이지를 조회한다.
	 */
	public BoardDto getNoticePop(Map<String, Object> searchMap) {
		return this.boardDao.selectNoticePopDetail(searchMap);
	}
	
	public List<BoardDto> selectNoticePopBoardNoList(String svcTypeCd, LoginUserDto userInfoDto) {
		List<BoardDto> list = new ArrayList<BoardDto>();
		List<BoardDto> workInfoList = new ArrayList<BoardDto>();
		if("BUY".equals(svcTypeCd)){
			list = boardDao.selectNoticePopBoardNoList(svcTypeCd);
			for(int i=0; i<list.size(); i++){
				boolean workInfoFlag = false;//공사유형 flag값
				//공지사항을 보여줄 공사유형 아이디값을 배열에 담음
				String[] workInfo = list.get(i).getWorkInfo().split("†");
				
				//workInfo.length 가 1이고 첫번째배열의 값이 공백일 경우 전체공지로 봄
				if(workInfo.length == 1){
					if("".equals(workInfo[0])){
						workInfoFlag = true;
					}
				}
					for(int j=0; j<workInfo.length; j++){
						//배열에 담긴공사유형아이디중 사업장의 공사유형 아이디값과 일치하면 flag값을 true로변경 
						if(userInfoDto.getSmpBranchsDto().getWorkId().equals(workInfo[j])){
							workInfoFlag = true;
						}
					}
				
				//flag값이 true일 경우 해당되는 list의 index를 workInfoList에 add
				if(workInfoFlag){
					workInfoList.add(list.get(i));
				}
			}
			return workInfoList;
		}else{
			list = boardDao.selectNoticePopBoardNoList(svcTypeCd);
			return list;
		}
	}
	
	/**
	 * 공지사항을 등록처리하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void regNotice(Map<String, Object> params) throws Exception {
		String etcSequence = seqMpBoardService.getNextStringId(); // 게시판 시퀀스 가져오는 부분
		
		params.put("board_No",        etcSequence);
		params.put("group_No",        etcSequence);
		params.put("parent_Board_No", 0);
		
		this.boardDao.insertNotice(params);
	}
	
	/**
	 * 공지사항 수정을 처리하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modNotice(Map<String, Object> params) {
		boardDao.updateNotice(params); // 공지사항 수정
		
	}
	
	/**
	 * 공지사항 삭제 페이지로 이동하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delNotice(Map<String,Object> saveMap) {
		boardDao.deleteNotice(saveMap);
	}
	
	/**
	 * VOC게시판 삭제 페이지로 이동하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delVoc(Map<String,Object> saveMap) {
		boardDao.delVoc(saveMap);
	}
	
	/**
	 * 요구사항목록 리스트의 카운트 조회하는 메소드
	 */
	public int getRequestManageListCnt(Map<String, Object> params) {
		return boardDao.selectRequestManageListCnt(params);
	}

	/**
	 * 요구사항목록 리스트를 조회하여 반환하는 메소드
	 */
	public List<MerequDto> getRequestManageList(Map<String, Object> params, int page, int rows) {
		return boardDao.selectRequestManageList(params, page, rows);
	}
	
	/** 
	 * 요구사항관리 상세 정보를 조회한다.
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public MerequDto getRequestManageDetailInfo(Map<String, Object> searchMap,LoginUserDto loginUserDto) {
		return this.boardDao.selectRequestManageDetail(searchMap);
	}
	
	/**
	 * 요구사항관리 등록처리하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void regRequestManage(Map<String, Object> params) throws Exception {
		// 요구사항관리 시퀀스 가져오는 부분
		String etcSequence = seqMpBoardService.getNextStringId();
		params.put("no", etcSequence);
		this.boardDao.insertRequestManage(params);
		// 정연백과장 요청으로 SMS 즉시발송 처리 by kkbum2000 20160701 
		this.commonSvc.sendRightSms("01052473906", "Q&A에 글이 등록 되었습니다.", true);
	}
	
	/**
	 * 요구사항관리 수정을 처리하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modRequestManage(Map<String, Object> params) {
		String    replayFlag  = (String)params.get("replayFlag");
		String    requTelNumb = null;
		MerequDto merequDto   = null;
		
		this.boardDao.updateRequestManage(params); // 요구사항관리 수정
		
		if("Y".equals(replayFlag)) {
			merequDto   = this.boardDao.selectRequestManageDetail(params);
			requTelNumb = merequDto.getRequ_tel_numb();
			requTelNumb = CommonUtils.nvl(requTelNumb);
			
			if("".equals(requTelNumb) == false){
				this.commonSvc.sendRightSms(requTelNumb, "등록하신 Q&A에 답변 글이 등록 되었습니다.");
			}
		}
	}
	
	/**
	 * 요구사항관리 삭제 페이지로 이동하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delRequestManage(Map<String,Object> saveMap) {
		boardDao.deleteRequestManage(saveMap);
	}
	
	/**
	 * 답변을 등록하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void regBoardReply(Map<String, Object> params) throws Exception {
		// 게시판 시퀀스 가져오는 부분
		String etcSequence = seqMpBoardService.getNextStringId();
		params.put("board_No", etcSequence);
		this.boardDao.insertNotice(params);
	}

	/**
	 * 게시판의 첨부파일을 삭제
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delBoardAttachFile(Map<String, Object> saveMap) {
		this.boardDao.updateBoardAttachFile(saveMap);
	}
	
	/**
	 * 요구사항관리의 첨부파일을 삭제
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delRequestManageAttachFile(Map<String, Object> saveMap) {
		this.boardDao.updateRequestManageAttachFile(saveMap);
	}
	
	/**
	 * 개선사항목록 리스트의 카운트 조회하는 메소드
	 */
	public int getImproManageListCnt(Map<String, Object> params) {
		return boardDao.selectImproManageListCnt(params);
	}

	/**
	 * 개선사항목록 리스트를 조회하여 반환하는 메소드
	 */
	public List<ImproDto> getImproManageList(Map<String, Object> params, int page, int rows) {
		return boardDao.selectImproManageList(params, page, rows);
	}
	
	/** 
	 * 개선사항관리 상세 정보를 조회한다.
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public ImproDto getImproManageDetailInfo1(Map<String, Object> searchMap,LoginUserDto loginUserDto) {
		return this.boardDao.selectImproManageDetail(searchMap);
	}
	
	/**
	 * 개선사항관리 등록처리하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void regImproManage(Map<String, Object> params) throws Exception {
		// 개선사항관리 시퀀스 가져오는 부분
		String etcSequence = seqImpro.getNextStringId();
		params.put("no", etcSequence);
		this.boardDao.insertImproManage(params);
		
		// 개선 요청사항 글이 등록될 시에 SMS가 나가도록 설정
		// 정연백과장 요청으로 SMS 즉시발송 처리 by kkbum2000 20160701 
		try{			
			commonSvc.sendRightSms("01099101503", "Okplaza 개선 요청사항이 접수 되었습니다.", true);
			commonSvc.sendRightSms("01052473906", "Okplaza 개선 요청사항이 접수 되었습니다.", true);
		}catch(Exception e){
			logger.error("SMS(approverSmsEmailInfoList) Save Errro : "+e);
		}
	}
	
	/**
	 * 개선사항관리 수정을 처리하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void modImproManage(Map<String, Object> params) {
		boardDao.updateImproManage(params); // 요구사항관리 수정	
	}
	
	/**
	 * 개선사항관리 삭제 페이지로 이동하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delImproManage(Map<String,Object> saveMap) {
		boardDao.deleteImproManage(saveMap);
	}
	
	/**
	 * 답변을 등록하는 메소드
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void regImproBoardReply(Map<String, Object> params) throws Exception {
		// 게시판 시퀀스 가져오는 부분
		String etcSequence = seqMpBoardService.getNextStringId();
		params.put("board_No", etcSequence);
		this.boardDao.insertNotice(params);
	}

	/**
	 * 게시판의 첨부파일을 삭제
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delImproBoardAttachFile(Map<String, Object> saveMap) {
		this.boardDao.updateImproBoardAttachFile(saveMap);
	}
	
	/**
	 * 개선사항관리의 첨부파일을 삭제
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void delImproManageAttachFile(Map<String, Object> saveMap) {
		this.boardDao.updateImproManageAttachFile(saveMap);
	}

	/**
	 * 벼룩시장 리스트 개수
	 */
	public int getMarketListCnt(Map<String, Object> params) {
		return boardDao.selectMarketListCnt(params);
	}
	public List<BoardDto> getMarketList(Map<String, Object> params, int page, int rows) {
		return boardDao.selectMarketList(params, page, rows);
	}
	
	//참여게시판 답급 상세
	public List<Map<String, Object>> getParticipationCommentList(Map<String, Object> params) {
		return boardDao.selectParticipationCommentList(params);
	}
	
	//참여게시판 상세
	public Map<String, Object> getParticipationBoardDetail(Map<String, Object> params) {
		return boardDao.selectParticipationBoardDetail(params);
	}
	
	//참여게시판 삭제
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public int deleteParticipation(Map<String, Object> saveMap) throws Exception{
		return boardDao.deleteParticipation(saveMap);
		
	}
	
	//히트수
	public void updateParticipationHitCnt(Map<String, Object> params) {
		boardDao.updateParticipationHitCnt(params);
	}
	
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void improManageTrans(ModelMap paramMap){
		
	}
	
	/**
	 * <pre>
	 * 유지보수 게시물 등록
	 * 
	 * ~. params 구조
	 *   !. viewNm (String, 화면명)
	 *   !. reqContents (String, 요청내용)
	 *   !. attach1Id (String, 첨부파일 1)
	 *   !. attach2Id (String, 첨부파일 2)
	 *   !. type (String, 접수구분)
	 *   !. loginUserDto (LoginUserDto, 로그인 사용자 정보)
	 * </pre>
	 * 
	 * @param params
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void insertRepairManage(Map<String, Object> params) throws Exception{
		String       id           = this.seqRepair.getNextStringId();
		String       viewNm       = (String)params.get("viewNm");
		String       reqContents  = (String)params.get("reqContents");
		String       attach1Id    = (String)params.get("attach1Id");
		String       attach2Id    = (String)params.get("attach2Id");
		String       type         = (String)params.get("type");
		LoginUserDto loginUserDto = (LoginUserDto)params.get("loginUserDto");
		ModelMap     daoParam     = new ModelMap();
		
		daoParam.put("id",           id);
		daoParam.put("VIEW_NM",      viewNm);
		daoParam.put("userInfoDto",  loginUserDto);
		daoParam.put("REQ_CONTENTS", reqContents);
		daoParam.put("ATTACH1_ID",   attach1Id);
		daoParam.put("ATTACH2_ID",   attach2Id);
		daoParam.put("TYPE",         type);
		daoParam.put("IS_IMPORTANT", "N");
		
		this.generalDao.insertGernal("board.insertRepairManage", daoParam); // 유지보수 등록
		this.commonSvc.sendRightSms("01052473906", "유지보수 요청 건이 접수되었습니다."); // sms발송
	}
	
	/**
	 * 유지보수 완료 처리건에 대한 SMS 발송하는 메소드
	 * 
	 * @param repairId
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private void updateRepairManage90(String repairId) throws Exception{
		ModelMap            daoParam       = new ModelMap();
		Map<String, String> smsInfo        = null;
		String              reqUserSms     = null;
		String              confirmUserSms = null;
		String              message        = null;
		StringBuffer        stringBuffer   = null;
		
		daoParam.put("repairId", repairId);
		
		smsInfo        = (Map<String, String>)this.generalDao.selectGernalObject("board.selectRepairManage90SmsInfo", daoParam);
		reqUserSms     = smsInfo.get("reqUserSms");
		confirmUserSms = smsInfo.get("confirmUserSms");
		reqUserSms     = CommonUtils.nvl(reqUserSms);
		confirmUserSms = CommonUtils.nvl(confirmUserSms);
		
		// 정연백과장 요청으로 요청자와 처리완료자가 동일할 경우 SMS 전송 제외 처리 by kkbum2000 20160630
		
		if (CommonUtils.nvl(smsInfo.get("reqUserId")).equals(CommonUtils.nvl(smsInfo.get("HANDLE_USER_ID")))) {
			return;
		}
		
		if("".equals(reqUserSms) == false){
			stringBuffer = new StringBuffer();
			
			stringBuffer.append("요청하신 유지보수 ");
			stringBuffer.append(repairId);
			stringBuffer.append("번이 처리완료되었습니다.");
			
			message = stringBuffer.toString();
			
			this.commonSvc.sendRightSms(reqUserSms, message, true); // sms발송
		}
		
		if("".equals(confirmUserSms) == false){
			stringBuffer = new StringBuffer();
			
			stringBuffer.append("접수하신 유지보수 ");
			stringBuffer.append(repairId);
			stringBuffer.append("번이 처리완료되었습니다.");
			
			message = stringBuffer.toString();
			
			this.commonSvc.sendRightSms(confirmUserSms, message); // sms발송
		}
	}
	
	/**
	 * <pre>
	 * 유비보수 게시품을 수정하는 메소드
	 * 
	 * ~. params 구조
	 *   !. viewNm (String, 화면명)
	 *   !. state (String, 처리상태)
	 *   !. reqContents (String, 요청내용)
	 *   !. fileList1 (String, 첩부1)
	 *   !. fileList2 (String, 첨부2)
	 *   !. handleContents (String, 처리내용)
	 *   !. repairId (String, 유지보수 아이디)
	 *   !. type (String, 접수구분)
	 *   !. loginUserDto (LoginUserDto, 로그인 사용자 정보)
	 *   !. expectManDay (String, 예상공수)
	 * </pre>
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void updateRepairManage(Map<String, Object> params) throws Exception{
		ModelMap     daoParam       = new ModelMap();
		LoginUserDto loginUserDto   = (LoginUserDto)params.get("loginUserDto");
		String       viewNm         = (String)params.get("viewNm");
		String       state          = (String)params.get("state");
		String       reqContents    = (String)params.get("reqContents");
		String       fileList1      = (String)params.get("fileList1");
		String       fileList2      = (String)params.get("fileList2");
		String       handleContents = (String)params.get("handleContents");
		String       repairId       = (String)params.get("repairId");
		String       type           = (String)params.get("type");
		String       isImportant    = (String)params.get("isImportant");
		String       expectManDay   = (String)params.get("expectManDay");
		
		expectManDay = CommonUtils.nvl(expectManDay);
		
		daoParam.put("view_nm",         viewNm);
		daoParam.put("state",           state);
		daoParam.put("req_contents",    reqContents);
		daoParam.put("file_list1",      fileList1);
		daoParam.put("file_list2",      fileList2);
		daoParam.put("userInfoDto",     loginUserDto);
		daoParam.put("handle_contents", handleContents);
		daoParam.put("repair_id",       repairId);
		daoParam.put("type",            type);
		daoParam.put("is_important",    isImportant);
		daoParam.put("expect_man_day",  expectManDay);
		
		this.generalDao.updateGernal("board.updateRepairManage", daoParam);
		
		if("90".equals(state)){ // 처리완료인경우
			this.updateRepairManage90(repairId); // sms 발송
		}
	}
}