package kr.co.bitcube.product.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

import kr.co.bitcube.common.dto.LoginUserDto;
import kr.co.bitcube.common.dto.SmsEmailInfo;
import kr.co.bitcube.common.service.CommonSvc;
import kr.co.bitcube.common.utils.CommonUtils;
import kr.co.bitcube.product.dao.NewProductBidDao;
import kr.co.bitcube.product.dto.McBidAuctionDto;
import kr.co.bitcube.product.dto.McNewGoodRequestDto;
import kr.co.bitcube.product.dto.McBidDto;

@Service
public class NewProductBidSvc {
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private NewProductBidDao newProductBidDao;
	
	@Autowired
	private CommonSvc commonSvc;
	
	@Resource(name="seqMcReqProductService")
	private EgovIdGnrService seqMcReqProductService;
	
	@Resource(name="seqMcReqProductHistService")
	private EgovIdGnrService seqMcReqProductHistService;
	
	@Resource(name="seqMcBidService")
	private EgovIdGnrService seqMcBidService;
	
	/**
	 * 고객사상품등록요청 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */
	public int getNewProductRequestListCnt(Map<String, Object> params) {
		return newProductBidDao.selectNewProductRequestListCnt(params);
	}
	
	/**
	 * 고객사상품등록요청 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	public List<McNewGoodRequestDto> getNewProductRequestList(Map<String, Object> params, int page, int rows) {
		return newProductBidDao.selectNewProductRequestList(params, page, rows);
	}
	
	/**
	 * 고객사상품등록요청 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	public McNewGoodRequestDto getRequestProductDetailInfo(Map<String, Object> params) {
		return newProductBidDao.selectRequestProductDetailInfo(params);
	}
	
	/**
	 * 입찰조회운영사 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */
	public int getNewProductBidListCnt(Map<String, Object> params) {
		String srcVendorid = (String)params.get("srcVendorid");
		if("".equals(srcVendorid)) {
			return newProductBidDao.selectNewProductBidListCntAdm(params);
		} else {
			return newProductBidDao.selectNewProductBidListCntVen(params);
		}
	}
	
	/**
	 * 고객사 신규규격 요청
	 * @param params
	 * @throws Exception 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void setNewGoodSpecRequest(Map params) throws Exception {
		LoginUserDto loginUserDto =  (LoginUserDto)params.get("loginUserDto");
		
		HashMap<String, Object> saveMap = new HashMap<String,Object>();
		saveMap.put("oper"					,"add"					);
		saveMap.put("stand_good_name"		, (String)params.get("stand_good_name"));
		saveMap.put("stand_good_spec_desc"	, (String)params.get("stand_good_spec_desc") );
		saveMap.put("note"					, (String)params.get("note") );
		saveMap.put("request_type"					, "" );
		saveMap.put("firstattachseq"		, "" );
		saveMap.put("secondattachseq"		, "" );
		saveMap.put("thirdattachseq"		, "" );
		saveMap.put("state"					, "10" );
		saveMap.put("insert_user_id"		, loginUserDto.getUserId()	);
		saveMap.put("insert_borgid"			, loginUserDto.getBorgId()	);
		
		this.setNewProductRequest(saveMap);
	}
	
	/**
	 * 고객사상품등록요청 등록, 수정, 삭제
	 * @param params
	 * @throws Exception 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void setNewProductRequest(Map<String, Object> params) throws Exception {
		String oper = (String)params.get("oper");
		if("add".equals(oper)) { //등록
			params.put("newgoodid", seqMcReqProductService.getNextIntegerId() );
			params.put("delete_state", "0");
			newProductBidDao.insertNewProductRequest(params);
		} else if("mod".equals(oper)) { //수정
			params.put("delete_state", "0");
			newProductBidDao.updateNewProductRequest(params);
		} else if("del".equals(oper)) { //삭제
			params.put("delete_state", "1");
			newProductBidDao.updateNewProductRequest(params);
		}
		params.put("newgood_hist_id", seqMcReqProductHistService.getNextIntegerId() );
		newProductBidDao.insertNewProductRequestHistByNewgoodid(params);
		
		/*-------------------------------담당자에게 메일/SMS 발송 시작-------------------------------------*/
		if("add".equals(oper)) {
			try{
				LoginUserDto loginUserDto = (LoginUserDto)params.get("loginUserDto");
				//법인담당 운영자에게 SMS/Email발송
				//List<SmsEmailInfo> managerSmsEmailInfoList = commonSvc.getManagerSmsEmailInfoByManageClientId(loginUserDto.getClientId());	//법인담당 운영자 Email,Sms 정보 가져오기
				List<SmsEmailInfo> managerSmsEmailInfoList = commonSvc.getManagerSmsEmailInfoByManageBranchId(loginUserDto.getBorgId());	//사업장의 공사유형담당자(운영사) Email,Sms 정보 가져오기
				String receiveMailer = "";
				for(SmsEmailInfo smsEmailInfo : managerSmsEmailInfoList) {
					if(smsEmailInfo.isSms()) {
						try {
							commonSvc.sendRightSms(smsEmailInfo.getMobileNum(), "[OK플라자] ["+loginUserDto.getBorgNm()+"] 고객사상품등록요청");
						} catch(Exception e) {
							logger.error("SMS(setNewProductRequest) Save Errro : "+e);
						}
					}
					if(smsEmailInfo.isEmail()) {
						if("".equals(receiveMailer)) receiveMailer = smsEmailInfo.getEmailAddr();
						else receiveMailer = receiveMailer + ";" + smsEmailInfo.getEmailAddr();
					}
				}
				if(!"".equals(receiveMailer)) {
					String emailSubject = "[OK플라자] ["+loginUserDto.getBorgNm()+"] 고객사상품등록요청";
					String emailContents = "고객사상품등록 요청<p>";
					emailContents += "상품명 : ["+(String)params.get("stand_good_name")+"]<br>";
					emailContents += "고객사명 : ["+loginUserDto.getBorgNms()+"]<p>";
					emailContents += "상품관리 > 고객사상품등록요청조회 메뉴에서 확인 가능합니다.";
					commonSvc.saveSendMail(receiveMailer, emailSubject, emailContents);
				}
			} catch(Exception ex) {
				logger.error("SMS(setNewProductRequest)2 Save Errro : "+ex);
			}
		}
		/*-------------------------------담당자에게 메일/SMS 발송 끝-------------------------------------*/
	}
	
	
	/**
	 * (운영사)고객사상품등록요청 기상품 처리  
	 * @param params
	 * @throws Exception 
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false)
	public void setExistsProductProcess(Map<String, Object> params) throws Exception {
		newProductBidDao.updateExistsProductProcess(params);
		params.put("newgood_hist_id", seqMcReqProductHistService.getNextIntegerId() );
		params.put("delete_state", "0");
		newProductBidDao.insertNewProductRequestHistByNewgoodid(params);
	}
	
	/**
	 * 입찰조회운영사 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @param page(페이지번호)
	 * @param rows(페이지 Row 개수)
	 * @return
	 */
	public List<McBidDto> getNewProductBidList(Map<String, Object> params, int page, int rows) {
		return newProductBidDao.selectNewProductBidList(params, page, rows);
	}
	
	/**
	 * (운영사)상품입찰공고 및 상품입찰공급사정보 등록 
	 * @param params
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void bidTrans(Map<String, Object> params) throws Exception {
		if(((Integer)params.get("newgoodid")).intValue() > 0) {
			String reqProductHistSequence = seqMcReqProductHistService.getNextStringId();
			params.put("newgood_hist_id", CommonUtils.stringParseInt(reqProductHistSequence, 0));
			params.put("state", "20");
			params.put("delete_state", "0");
			newProductBidDao.updateNewProductRequestState(params);
			newProductBidDao.insertNewProductRequestHistByNewgoodid(params);
		}
		
		String bidSequence = seqMcBidService.getNextStringId();
		String reqProductHistorySequence = seqMcReqProductHistService.getNextStringId();
		params.put("bidid", CommonUtils.stringParseInt(bidSequence, 0));
		params.put("bid_hist_id", CommonUtils.stringParseInt(reqProductHistorySequence, 0));
		newProductBidDao.insertBid(params);
		newProductBidDao.insertBidHist(params);
		
		String[] vendorIdArray = (String[])params.get("vendorIdArray");
		for(String vendorid:vendorIdArray) {
			Map<String, Object> saveMap = new HashMap<String,Object>();
			saveMap.put("bidid", CommonUtils.stringParseInt(bidSequence, 0));
			String reqProductHistorySequence2 = seqMcReqProductHistService.getNextStringId();
			saveMap.put("bid_hist_id", CommonUtils.stringParseInt(reqProductHistorySequence2, 0));
			saveMap.put("vendorid", vendorid);
			saveMap.put("vendorbidstate", (String)params.get("bidstate"));
			saveMap.put("IS_REG_GODD", "0");
			saveMap.put("insert_user_id", (String)params.get("insert_user_id"));
			newProductBidDao.insertBidAuction(saveMap);
			newProductBidDao.insertBidAuctionHist(saveMap);
		}
		
		/*------------------------------메일/SMS 발송 시작---------------------------------*/
		for(String vendorid:vendorIdArray) {
			try {
				List<SmsEmailInfo> vendorSmsEmailInfoList = commonSvc.getVendorUserSmsEmailInfoByVendorId(vendorid);	//공급사 Email,Sms 정보 가져오기
				for(SmsEmailInfo smsEmailInfo : vendorSmsEmailInfoList) {
					if(smsEmailInfo.isSms() && "1".equals(smsEmailInfo.getSmsByNotiAuction())) {
						try {
							commonSvc.sendRightSms(smsEmailInfo.getMobileNum(), "[OK플라자] 입찰참여요청");
						} catch(Exception e) {
							logger.error("SMS(bidTrans) Save Errro : "+e);
						}
					}
					if(smsEmailInfo.isEmail() && "1".equals(smsEmailInfo.getEmailByNotiAuction())) {
						String mailContents = "";
						mailContents += "입찰참여을 요청합니다.<p>";
						mailContents += "입찰번호 : ["+bidSequence+"]<br>";
						mailContents += "상품명 : ["+(String)params.get("stand_good_name")+"]<br>";
						mailContents += "규격 : ["+(String)params.get("stand_good_spec_desc")+"]<p>";
						mailContents += "입찰처리/이력 메뉴에서 확인 가능합니다.";
						commonSvc.saveSendMail(smsEmailInfo.getEmailAddr(), "[OK플라자] 입찰참여요청", mailContents);
					}
				}
			} catch(Exception ex) {
				logger.error("SMS(bidTrans)2 Save Errro : "+ex);
			}
		}
		/*------------------------------메일/SMS 발송 끝---------------------------------*/
	}
	
	/**
	 * 상품입찰공고사정보 투찰상태를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<McBidAuctionDto> getBidAuctionDetailInfo(Map<String, Object> params) {
		return newProductBidDao.selectBidAuctionDetailInfo(params);
	}
	
	/**
	 * 상품입찰공고 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public McBidDto getBidProductDetailInfo(Map<String, Object> params) {
		return newProductBidDao.selectBidProductDetailInfo(params);
	}
	
	/**
	 * 상품입찰공급사정보 리스트의 카운트 조회하는 메소드
	 * @param params
	 * @return
	 */
	public int getNewProductBidAuctionListCnt(Map<String, Object> params) {
		return newProductBidDao.selectNewProductBidAuctionListCnt(params);
	}
	
	/**
	 * 상품입찰공급사정보 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public List<McBidAuctionDto> getNewProductBidAuctionList(Map<String, Object> params) {
		return newProductBidDao.selectNewProductBidAuctionList(params);
	}
	
	/**
	 * 상품입찰공급사정보 리스트를 조회하여 반환하는 메소드
	 * @param params
	 * @return
	 */
	public McBidAuctionDto getBidAuctionProductDetailInfo(Map<String, Object> params) {
		return newProductBidDao.selectBidAuctionProductDetailInfo(params);
	}
	
	/**
	 * 상품입찰공급사정보 수정 
	 * @param params
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void bidAuctionTrans(Map<String, Object> params) throws Exception {
		String reqProductHistorySequence = seqMcReqProductHistService.getNextStringId();
		params.put("bid_hist_id", CommonUtils.stringParseInt(reqProductHistorySequence, 0));
		newProductBidDao.updateBidAuction(params);
		newProductBidDao.insertBidAuctionHist(params);
	}
	
	/**
	 * 상품입찰공고 및 상품입찰공급사정보 상태 수정 
	 * @param params
	 */
	@Transactional(propagation=Propagation.REQUIRED, readOnly=false, rollbackFor={Exception.class})
	public void bidAuctionStateTrans(Map<String, Object> params) throws Exception {
		String bidstate = (String)params.get("bidstate");
		if("50".equals(bidstate)) {//낙찰
			String reqProductHistSequence2 = seqMcReqProductHistService.getNextStringId();
			params.put("bid_hist_id", CommonUtils.stringParseInt(reqProductHistSequence2, 0));
			newProductBidDao.updateBidAuctionState(params);
			newProductBidDao.insertBidAuctionHist(params);
			
			String reqProductHistSequence3 = seqMcReqProductHistService.getNextStringId();
			params.put("newgood_hist_id", CommonUtils.stringParseInt(reqProductHistSequence3, 0));
			params.put("state", "30");//입찰완료
			params.put("delete_state", "0");
			newProductBidDao.updateNewProductRequestState(params);
			newProductBidDao.insertNewProductRequestHistByNewgoodid(params);
		} else if("90".equals(bidstate)) {//유찰
			String reqProductHistSequence4 = seqMcReqProductHistService.getNextStringId();
			params.put("newgood_hist_id", CommonUtils.stringParseInt(reqProductHistSequence4, 0));
			params.put("state", "40");//입찰완료_유찰
			params.put("delete_state", "0");
			newProductBidDao.updateNewProductRequestState(params);
			newProductBidDao.insertNewProductRequestHistByNewgoodid(params);
		}
		
		String reqProductHistSequence = seqMcReqProductHistService.getNextStringId();
		params.put("bid_hist_id", CommonUtils.stringParseInt(reqProductHistSequence, 0));
		newProductBidDao.updateBidState(params);
		newProductBidDao.insertBidHist(params);
		
		
		/*------------------------------메일/SMS 발송 시작---------------------------------*/
		if("50".equals(bidstate)) {//낙찰
			try {
				List<SmsEmailInfo> vendorSmsEmailInfoList = commonSvc.getVendorUserSmsEmailInfoByVendorId((String)params.get("vendorid"));	//공급사 Email,Sms 정보 가져오기
				for(SmsEmailInfo smsEmailInfo : vendorSmsEmailInfoList) {
					if(smsEmailInfo.isSms() && "1".equals(smsEmailInfo.getSmsByNotiSuccessBid())) {
						try {
							commonSvc.sendRightSms(smsEmailInfo.getMobileNum(), "[OK플라자] 낙찰되었습니다.");
						} catch(Exception e) {
							logger.error("SMS(bidAuctionStateTrans) Save Errro : "+e);
						}
					}
					if(smsEmailInfo.isEmail() && "1".equals(smsEmailInfo.getEmailByNotiSuccessBid())) {
						String mailContents = "";
						mailContents += "낙찰되었습니다.<p>";
						mailContents += "입찰번호 : ['"+(Integer)params.get("bidid")+"']<p>";
						mailContents += "입찰처리/이력 메뉴에서 확인 가능합니다.";
						commonSvc.saveSendMail(smsEmailInfo.getEmailAddr(), "[OK플라자] 낙찰되었습니다.", mailContents);
					}
				}
			} catch(Exception ex) {
				logger.error("SMS(bidAuctionStateTrans)2 Save Errro : "+ex);
			}
		}
		/*------------------------------메일/SMS 발송 끝---------------------------------*/
		
	}
	
	/**
	 * 투찰 상품등록 후 mcbid 및 mcnewgoodrequest 에 상품 등록 한다. 
	 */
	public void bidAuctionRegistratTrans(Map<String, Object> params){
		
		McBidDto mcBidDto = newProductBidDao.selectReqAndBidInfo(params);
		
		//1. mcbidauction 에 상품 등록
		newProductBidDao.updateRegistratGoodIdenNumb(params);
		
		// //2. mcbid 에 상품 유무 확인
		if( (mcBidDto.getBid_good_iden_numb().equals("0") || mcBidDto.getBid_good_iden_numb().equals("")) ){
			newProductBidDao.updateBidGoodIdenNumb(params); 
		}
		
		// 3. mcnewgoodrequest에 상품 등록여부 
		if( (mcBidDto.getNewgood_good_iden_numb().equals("") || mcBidDto.getNewgood_good_iden_numb().equals("0")) ){
			params.put("mcnewgoodState", "80");
			params.put("newgoodid", mcBidDto.getNewgoodid());
			newProductBidDao.updateNewProdGoodIdenNumb(params);
		}
	}
}
