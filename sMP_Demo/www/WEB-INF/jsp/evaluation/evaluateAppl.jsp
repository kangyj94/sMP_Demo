<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.Map" %>
<%
LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
String today = CommonUtils.getCurrentDate();
String FACTORYREGIDATE = null;
String LABREGIDATE = null;
String PARTSTATE = null;
if (request.getAttribute("part") != null) {
	  FACTORYREGIDATE = (String) ((Map)request.getAttribute("part")).get("FACTORYREGIDATE");
    LABREGIDATE = (String) ((Map)request.getAttribute("part")).get("LABREGIDATE");
    if (FACTORYREGIDATE == null || FACTORYREGIDATE.length() < 6) {
        FACTORYREGIDATE = null;
    } else {
    	FACTORYREGIDATE = FACTORYREGIDATE.substring(0, 4) + "-" + FACTORYREGIDATE.substring(4); 
    }
    if (LABREGIDATE == null || LABREGIDATE.length() < 6) {
    	LABREGIDATE = null;
    } else {
    	LABREGIDATE = LABREGIDATE.substring(0, 4) + "-" + LABREGIDATE.substring(4); 
    }
    PARTSTATE = (String) ((Map)request.getAttribute("part")).get("PARTSTATE");
}
int EndYear   = 1970;
int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
int yearCnt = StartYear - EndYear + 1;
String[] srcYearArr = new String[yearCnt];
for(int i = 0 ; i < yearCnt ; i++){
   srcYearArr[i] = (StartYear - i) + "";
}
%>
<table width="800" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
			<tr>
				<td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
				<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
				<td class="popup_title">
					참가신청
				</td>
				<td width="22" align="right">
                    <a href="#" class="jqmClose">
                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;" />
                    </a>
                </td>
                <td width="10" img id="popup_titlebar_right1" src="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
			</tr>
		</table>
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" /></td>
				<td width="100%"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif" width="100%" height="20" /></td>
				<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
			</tr>
			<tr>
                <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                <td valign="top" bgcolor="#FFFFFF">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">품목 명</td>
                            <td class="table_td_contents4" width="218">${part.ITEMNM}</td>
                            <td class="table_td_subject" width="120">품목유형</td>
                            <td class="table_td_contents4">${part.ITEMTYPE1},${part.ITEMTYPE2}${not empty part.ITEMTYPE3?',':''}${part.ITEMTYPE3}</td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">참가상태</td>
                            <td class="table_td_contents4" colspan="3">${part.PARTSTATENM}</td>
                        </tr>
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table> 
		            <!-- 타이틀 시작 -->
		            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
		                <tr valign="top">
		                    <td width="20" valign="middle">
		                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
		                    </td>
		                    <td height="29" class='ptitle'>공급업체 일반정보</td>
		                </tr>
		            </table>    
		            <!-- 타이틀 끝 -->
                    <form id="frmSave">
                    <input type="hidden" name="oper" value="${empty part.APPLID ? 'add':'edit'}"/>
                    <input type="hidden" name="idGenSvcNm" value="seqPartAppl"/>
                    <input type="hidden" name="itemId" value="${part.ITEMID}"/>
                    <input type="hidden" name="applId" value="${part.APPLID}"/>
                    <input type="hidden" name="partState" value="10"/>
                    <input type="hidden" name="businessNum" value="${part.BUSINESSNUM}"/>
                    <input type="hidden" name="vendorNm" value="${part.VENDORNM}"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">업체명</td>
                            <td class="table_td_contents4" width="218">${part.VENDORNM}</td>
                            <td class="table_td_subject" width="120">사업자등록번호</td>
                            <td class="table_td_contents4">${part.BUSINESSNUM}</td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="120">업종</td>
                            <td class="table_td_contents4">
                                <input type="text" id="vendorBusiType" name="vendorBusiType" value="${part.VENDORBUSITYPE}" placeholder="사업자등록증 내용과 일치" required title="업종" style="width: 210px" maxlength="100"/>
                            </td>
                            <td class="table_td_subject9" width="120">업태</td>
                            <td class="table_td_contents4">
                                <input type="text" id="vendorBusiClas" name="vendorBusiClas" value="${part.VENDORBUSICLAS}" placeholder="사업자등록증 내용과 일치" required title="업태" style="width: 210px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">대표자</td>
                            <td class="table_td_contents4">
                                <input type="text" id="pressentNm" name="pressentNm" value="${part.PRESSENTNM}" title="대표자" style="width: 100px" maxlength="100"/>
                            </td>
                            <td class="table_td_subject" width="120">대표 연락처</td>
                            <td class="table_td_contents4">
                                <input type="text" id="phoneNum" name="phoneNum" value="${part.PHONENUM}" title="대표 연락처" style="width: 120px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="120">영업담당자</td>
                            <td class="table_td_contents4">
                                <input type="text" id="busiCharger" name="busiCharger" value="${part.BUSICHARGER}" required title="영업담당자" style="width: 100px" maxlength="100"/>
                                <br/><span class="helptext" style="color:#959595">이후 업체평가/일정 조율을 할수 있는 실무 담당자</span>
                            </td>
                            <td class="table_td_subject9" width="120">영업 연락처</td>
                            <td class="table_td_contents4">
                                <input type="text" id="busiPhoneNum" name="busiPhoneNum" value="${part.BUSIPHONENUM}" required title="영업 연락처" style="width: 120px" maxlength="100"/>
                                <br/><span class="helptext" style="color:#959595">이후 업체평가/일정 조율을 할수 있는 실무 담당자</span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:-6px">등록</button>
                                                                          사업자등록증
                            </td>
                            <td class="table_td_contents4">
                                <span class="helptext" style="color:#959595${empty part.BUSINESSATTACHFILESEQ ? '':';display:none'}">사업자 등록증 파일 첨부</span>
                                <input type="hidden" id="businessAttachFileSeq" name="businessAttachFileSeq" value="${part.BUSINESSATTACHFILESEQ}" class="attachFileSeq" required title="사업자등록증"/>
                                <input type="hidden" id="businessAttachFilePath" name="businessAttachFilePath" value="${part.BUSINESSATTACHFILEPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#businessAttachFilePath').val());">
                                <span id="businessAttachFileName" class="attachFileName">${part.BUSINESSATTACHFILENAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.BUSINESSATTACHFILESEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                            <td class="table_td_subject9" width="120">영업담당자 이메일</td>
                            <td class="table_td_contents4">
                                <input type="text" id="busiChargerEmail" name="busiChargerEmail" value="${part.BUSICHARGEREMAIL}" required title="영업담당자 이메일" style="width: 210px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table> 
                    <!-- 타이틀 시작 -->
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top">
                            <td width="20" valign="middle">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                            </td>
                            <td height="29" class='ptitle'>공급업체 평가자료 제출</td>
                        </tr>
                    </table>    
                    <!-- 타이틀 끝 -->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:-6px">등록</button>
                                                                          회사소개서
                            </td>
                            <td class="table_td_contents4" width="218">
                                <span class="helptext" style="color:#959595${empty part.COMPINTROATTACHSEQ ? '':';display:none'}">필수내용: 회사연혁, 인력현황(영업, 개발, 생산 인원 수 및 경력),매출현황, 회사 경영전략</span>
                                <input type="hidden" id="compIntroAttachSeq" name="compIntroAttachSeq" value="${part.COMPINTROATTACHSEQ}" required class="attachFileSeq" title="회사소개서"/>
                                <input type="hidden" id="compIntroAttachPath" name="compIntroAttachPath" value="${part.COMPINTROATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#compIntroAttachPath').val());">
                                <span id="compIntroAttachName" class="attachFileName">${part.COMPINTROATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.COMPINTROATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                            <td class="table_td_subject" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:-6px">등록</button>
                                                                          제품소개서
                            </td>
                            <td class="table_td_contents4">
                                <span class="helptext" style="color:#959595${empty part.PRODINTROATTACHSEQ ? '':';display:none'}">선택사항</span>
                                <input type="hidden" id="prodIntroAttachSeq" name="prodIntroAttachSeq" value="${part.PRODINTROATTACHSEQ}" class="attachFileSeq" title="제품소개서"/>
                                <input type="hidden" id="prodIntroAttachPath" name="prodIntroAttachPath" value="${part.PRODINTROATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#prodIntroAttachPath').val());">
                                <span id="prodIntroAttachName" class="attachFileName">${part.PRODINTROATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.PRODINTROATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="120">신용등급</td>
                            <td class="table_td_contents4">
                                <select id="creditGrade" name="creditGrade" required title="신용등급"><option value="">선택</option></select>
                                <br/><span class="helptext" style="color:#959595">신용등급서에 명시된 신용등급</span>
                            </td>
                            <td class="table_td_subject9" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:-6px">등록</button>
                                                                          신용등급서
                            </td>
                            <td class="table_td_contents4">
                                <span class="helptext" style="color:#959595${empty part.CREDITGRADEATTACHSEQ ? '':';display:none'}">유효기간내 자료만 인정(모집 공지일 기준)</span>
                                <input type="hidden" id="creditGradeAttachSeq" name="creditGradeAttachSeq" value="${part.CREDITGRADEATTACHSEQ}" required class="attachFileSeq" title="신용등급서"/>
                                <input type="hidden" id="creditGradeAttachPath" name="creditGradeAttachPath" value="${part.CREDITGRADEATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#creditGradeAttachPath').val());">
                                <span id="creditGradeAttachName" class="attachFileName">${part.CREDITGRADEATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.CREDITGRADEATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="120">공장등록년월</td>
                            <td class="table_td_contents4">
		                        <select id="factoryRegiDate1" name="factoryRegiDate1" class="select">
		                            <option value="">없음</option>
								   <% for(int i = 0 ; i < srcYearArr.length ; i++) {%>
		                           <option value='<%=srcYearArr[i]%>' <%=FACTORYREGIDATE != null && FACTORYREGIDATE.split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
		                           <% } %>
		                        </select> 년
		                        <select id="factoryRegiDate2" name="factoryRegiDate2" class="select">
                                <option value="">없음</option>
		                           <% for(int i = 0 ; i < 12 ; i++) { %>
		                           <option value='<%=i<9?"0"+(i+1):(i+1)%>' <%=FACTORYREGIDATE != null && Integer.parseInt(FACTORYREGIDATE.split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1%></option>
		                           <% } %>                        
		                        </select> 월 
                            <br/><span class="helptext" style="color:#959595">공장등록증에 명시된 년월</span>
                            </td>
                            <td class="table_td_subject" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:-6px">등록</button>
                                                                          공장등록증
                            </td>
                            <td class="table_td_contents4">
                                <span class="helptext" style="color:#959595${empty part.FACTORYREGIATTACHSEQ ? '':';display:none'}">1년내 발급된 자료만 인증(모집 공지일 기준)</span>
                                <input type="hidden" id="factoryRegiAttachSeq" name="factoryRegiAttachSeq" value="${part.FACTORYREGIATTACHSEQ}" class="attachFileSeq" title="공장등록증"/>
                                <input type="hidden" id="factoryRegiAttachPath" name="factoryRegiAttachPath" value="${part.FACTORYREGIATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#factoryRegiAttachPath').val());">
                                <span id="factoryRegiAttachName" class="attachFileName">${part.FACTORYREGIATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.FACTORYREGIATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="120">기업부설연구소<br/>등록년월</td>
                            <td class="table_td_contents4">
                                <select id="labRegiDate1" name="labRegiDate1" class="select">
                                    <option value="">없음</option>
                                   <% for(int i = 0 ; i < srcYearArr.length ; i++) {%>
                                   <option value='<%=srcYearArr[i]%>' <%=LABREGIDATE != null && LABREGIDATE.split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
                                   <% } %>
                                </select> 년
                                <select id="labRegiDate2" name="labRegiDate2" class="select">
                                   <option value="">없음</option>
                                   <% for(int i = 0 ; i < 12 ; i++) { %>
                                   <option value='<%=i<9?"0"+(i+1):(i+1)%>' <%=LABREGIDATE != null && Integer.parseInt(LABREGIDATE.split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
                                   <% } %>                        
                                </select> 월 
                            <br/><span class="helptext" style="color:#959595">기업부설연구소증에 명시된 년월</span>
                            </td>
                            <td class="table_td_subject" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:2px">등록</button>
                                                                          기업부설<br/>연구소증
                            </td>
                            <td class="table_td_contents4">
                                <span class="helptext" style="color:#959595${empty part.LABREGATTACHSEQ ? '':';display:none'}">1년내 발급된 자료만 인증(모집 공지일 기준)</span>
                                <input type="hidden" id="labRegAttachSeq" name="labRegAttachSeq" value="${part.LABREGATTACHSEQ}" class="attachFileSeq" title="기업부설연구소증"/>
                                <input type="hidden" id="labRegAttachPath" name="labRegAttachPath" value="${part.LABREGATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#labRegAttachPath').val());">
                                <span id="labRegAttachName" class="attachFileName">${part.LABREGATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.LABREGATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">품질인증보유</td>
                            <td class="table_td_contents4">
                                <input type="text" id="qcPosse" name="qcPosse" value="${part.QCPOSSE}" placeholder="보유 국제 표준인증, 국내 표준인증, 기타 표준인증 개수" title="품질인증보유" style="width: 210px" maxlength="100"/><br/>
                                <span style="color:#959595">(예: <b>ISO 9001, KS 2343</b>)</span>
                            </td>
                            <td class="table_td_subject" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:-6px">등록</button>
                                                                          품질인증서
                            </td>
                            <td class="table_td_contents4">
                                <span class="helptext" style="color:#959595${empty part.QCCERTIATTACHSEQ ? '':';display:none'}">유효기간내 자료만 인정(모집 공지일 기준)</span>
                                <input type="hidden" id="qcCertiAttachSeq" name="qcCertiAttachSeq" value="${part.QCCERTIATTACHSEQ}" class="attachFileSeq" title="품질인증서"/>
                                <input type="hidden" id="qcCertiAttachPath" name="qcCertiAttachPath" value="${part.QCCERTIATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#qcCertiAttachPath').val());">
                                <span id="qcCertiAttachName" class="attachFileName">${part.QCCERTIATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.QCCERTIATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr id="prodType10">
                            <td class="table_td_subject9" width="120">동일제품 납품실적<br/>(3년 내)<input type="radio" name="prodType" value="10"${part.PRODTYPE eq '20' ? '':'checked'}/></td>
                            <td class="table_td_contents4">
                                <input type="text" name="deliveryResult" value="${part.PRODTYPE eq '10' ? part.DELIVERYRESULT : ''}" title="납품실적" style="width: 100px" maxlength="100" ${part.PRODTYPE eq '20' ? 'disabled':'requiredNumber'}/> 원<br/>
                                <span style="color:#959595">(예: <b>4,000,000,000</b>)</span>
                            </td>
                            <td class="table_td_subject" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:2px" ${part.PRODTYPE eq '20' ? 'disabled':''}>등록</button>
                                                                          동일제품<br/>납품증명서
                            </td>
                            <td class="table_td_contents4">
                                <span class="helptext" style="color:#959595${part.PRODTYPE ne '20' and not empty part.DELIVERYCERTIATTACHSEQ ? ';display:none':''}">최근 3년간 납품실적을 증명하는<br/>1. 실적 증명서 (당사 양식)<br/>&nbsp;- 매입처 발급 날인 필수<br/>2. 계약서(날인필수)</span>
                                <input type="hidden" id="deliveryCertiAttachSeq" name="deliveryCertiAttachSeq" ${part.PRODTYPE eq '20' ? 'disabled':''} value="${part.PRODTYPE eq '10' ? part.DELIVERYCERTIATTACHSEQ : ''}" class="attachFileSeq" title="동일제품납품증명서"/>
                                <input type="hidden" id="deliveryCertiAttachPath" name="deliveryCertiAttachPath" ${part.PRODTYPE eq '20' ? 'disabled':''} value="${part.PRODTYPE eq '10' ? part.DELIVERYCERTIATTACHPATH : ''}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#deliveryCertiAttachPath').val());">
                                <span id="deliveryCertiAttachName" class="attachFileName">${part.PRODTYPE eq '10' ? part.DELIVERYCERTIATTACHNAME : ''}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${part.PRODTYPE eq '20' or empty part.DELIVERYCERTIATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr id="prodType20">
                            <td class="table_td_subject9" width="120">유사제품 납품실적<br/>(3년 내)<input type="radio" name="prodType" value="20"${part.PRODTYPE eq '20' ? 'checked':''}/></td>
                            <td class="table_td_contents4">
                                <input type="text" name="deliveryResult" value="${part.PRODTYPE eq '20' ? part.DELIVERYRESULT : ''}" title="납품실적" style="width: 100px" maxlength="100" ${part.PRODTYPE eq '20' ? 'requiredNumber':'disabled'}/> 원<br/>
                                <span style="color:#959595">(예: <b>4,000,000,000</b>)</span>
                            </td>
                            <td class="table_td_subject" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:2px" ${part.PRODTYPE eq '20' ? '':'disabled'}>등록</button>
                                                                          유사제품<br/>납품증명서
                            </td>
                            <td class="table_td_contents4">
                                <span class="helptext" style="color:#959595${part.PRODTYPE eq '20' and not empty part.DELIVERYCERTIATTACHSEQ ? ';display:none':''}">최근 3년간 납품실적을 증명하는<br/>1. 실적 증명서 (당사 양식)<br/>&nbsp;- 매입처 발급 날인 필수<br/>2. 계약서(날인필수)</span>
                                <input type="hidden" id="deliveryCertiAttachSeq" name="deliveryCertiAttachSeq" ${part.PRODTYPE eq '20' ? '':'disabled'} value="${part.PRODTYPE eq '20' ? part.DELIVERYCERTIATTACHSEQ : ''}" class="attachFileSeq" title="유사제품납품증명서"/>
                                <input type="hidden" id="deliveryCertiAttachPath" name="deliveryCertiAttachPath" ${part.PRODTYPE eq '20' ? '':'disabled'} value="${part.PRODTYPE eq '20' ? part.DELIVERYCERTIATTACHPATH : ''}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#deliveryCertiAttachPath').val());">
                                <span id="deliveryCertiAttachName" class="attachFileName">${part.PRODTYPE eq '20' ? part.DELIVERYCERTIATTACHNAME : ''}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${part.PRODTYPE eq '10' or empty part.DELIVERYCERTIATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:2px">등록</button>
                                                                          품질검증기기<br/>(계측기)보유
                            </td>
                            <td class="table_td_contents4" colspan="3">
                                <span class="helptext" style="color:#959595${empty part.QUALITYVERIPOSSEATTACHSEQ ? '':';display:none'}">해당업체가 보유하고 있는 품질검증기기 (계측기) 리스트 및 사진</span>
                                <input type="hidden" id="qualityVeriPosseAttachSeq" name="qualityVeriPosseAttachSeq" value="${part.QUALITYVERIPOSSEATTACHSEQ}" class="attachFileSeq" title="품질검증기기보유"/>
                                <input type="hidden" id="qualityVeriPosseAttachPath" name="qualityVeriPosseAttachPath" value="${part.QUALITYVERIPOSSEATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#qualityVeriPosseAttachPath').val());">
                                <span id="qualityVeriPosseAttachName" class="attachFileName">${part.QUALITYVERIPOSSEATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.QUALITYVERIPOSSEATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:-6px">등록</button>
                                                                          비밀유지각서
                            </td>
                            <td class="table_td_contents4" width="218">
                                <span class="helptext" style="color:#959595${empty part.SECRETMEMOATTACHSEQ ? '':';display:none'}"></span>
                                <input type="hidden" id="secretMemoAttachSeq" name="secretMemoAttachSeq" value="${part.SECRETMEMOATTACHSEQ}" required class="attachFileSeq" title="비밀유지각서"/>
                                <input type="hidden" id="secretMemoAttachPath" name="secretMemoAttachPath" value="${part.SECRETMEMOATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#secretMemoAttachPath').val());">
                                <span id="secretMemoAttachName" class="attachFileName">${part.SECRETMEMOATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.SECRETMEMOATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                            <td class="table_td_subject9" width="120">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:90px;margin-top:2px">등록</button>
                                                                           평가결과<br/>승복 확약각서
                            </td>
                            <td class="table_td_contents4">
                                <span class="helptext" style="color:#959595${empty part.COMMITMEMOATTACHSEQ ? '':';display:none'}"></span>
                                <input type="hidden" id="commitMemoAttachSeq" name="commitMemoAttachSeq" value="${part.COMMITMEMOATTACHSEQ}" required class="attachFileSeq" title="평가결과 승복 확약각서"/>
                                <input type="hidden" id="commitMemoAttachPath" name="commitMemoAttachPath" value="${part.COMMITMEMOATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#commitMemoAttachPath').val());">
                                <span id="commitMemoAttachName" class="attachFileName">${part.COMMITMEMOATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.COMMITMEMOATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table>
                    </form>
                    <% if (PARTSTATE == null || PARTSTATE.equals("10")) { %>
                    <div style="margin:10px 0 0 0;text-align:center"> 
                        <label>상기 등록 된 내용은 사실과 다르지 않으며 만약 허위일 경우 어떠한 책임도 감수하겠습니다.<input id="chkAgree" type="checkbox" style="vertical-align:middle;margin-top:-1px"/></label>
                    </div>
                    <% } %>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="center">
                            <% if (PARTSTATE == null || PARTSTATE.equals("10")) { %>
                            <button id="btnSave" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> ${empty part.APPLID ? '신청':'수정'}</button>
                            <% } %>
                            <button id="btnClose" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
                            </td>
                        </tr>
                    </table>
                </td>   
                <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
            </tr>
			<tr>
				<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
				<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
				<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%@ include file="/WEB-INF/jsp/evaluation/attachFileDiv.jsp" %>
<script type="text/javascript">
var fileTD;
$(function() {
    $("#evaluatePop").jqDrag('#userDialogHandle');
    fnDataInit();
    $('.btnRegFile').click(function() {
        fileTD = $(this).closest('td').next();
        var attachFileSeq = fileTD.find('.attachFileSeq');
        var title= attachFileSeq.attr('title') + " 첨부";
    	fnUploadDialog(title, attachFileSeq.val(), "fnCallBack"); 
    });
    $('.btnDelFile').click(function() {
        var file = $(this).closest('td');
        file.find('.attachFileSeq').val('');
        file.find('.attachFilePath').val('');
        file.find('.attachFileName').html(''); 
        file.find('.helptext').show();
        $(this).hide();
    });
    $('#btnSave').click(function (e) {
    	if (!$("#frmSave").validate()) {
            return;
        }
    	
    	if (!$('#chkAgree').attr('checked')) {
    		alert('참가신청 동의에 체크해주세요.');
    		return;
    	}
        
    	$.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/${empty part.APPLID ? "insertPartAppl":"updatePartAppl"}/save.sys', $('#frmSave').serialize(),
	        function(msg) {
    		  var m = eval('(' + msg + ')');
    		  if (m.customResponse.success) {
    			  fnSearch();
                  $('#evaluatePop').html('');
    		      $('#evaluatePop').jqmHide();
    		  } else {
    			  alert('저장 중 오류가 발생했습니다.');
    		  }
	        }
	    );  
    });
	$('.jqmClose').click(function (e) {
		if(!confirm("수정된 정보가 있으시면 신청 또는 수정버튼을 누르셔야 저장됩니다.\n창을 닫으시겠습니까?")) return;
        $('#evaluatePop').html('');
		$('#evaluatePop').jqmHide();
	});
	$('input[name=prodType]').click(function () {
		var val = $(this).val();
		if (val == '10') {
			$('#prodType10').find('input[type=text],input[type=hidden],button').attr('disabled', false);
            $('#prodType10').find('input[type=text]').attr('requiredNumber', true);
            $('#prodType20').find('input[type=text],input[type=hidden],button').attr('disabled', true);
            $('#prodType20').find('input[type=text]').attr('requiredNumber', false);
		} else {
            $('#prodType10').find('input[type=text],input[type=hidden],button').attr('disabled', true);
            $('#prodType10').find('input[type=text]').attr('requiredNumber', false);
            $('#prodType20').find('input[type=text],input[type=hidden],button').attr('disabled', false);
            $('#prodType20').find('input[type=text]').attr('requiredNumber', true);
		}
		
	});
});
//코드 데이터 초기화 
function fnDataInit(){
     $.post(  //조회조건의 품목유형1 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"SMPPART_CREDIT",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#creditGrade").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
             }
             $("#creditGrade").val('${part.CREDITGRADE}');
         }
     );  
}
// 파일 첨부 
function fnCallBack(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
    fileTD.find('.attachFileSeq').val(rtn_attach_seq);
    fileTD.find('.attachFilePath').val(rtn_attach_file_path);
    fileTD.find('.attachFileName').text(rtn_attach_file_name);
    fileTD.find('.btnDelFile').show();
    fileTD.find('.helptext').hide();
}
// 파일다운로드
function fnAttachFileDownload(attach_file_path) {
    var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
    var data = "attachFilePath="+attach_file_path;
    $.download(url,data,'post');
}
jQuery.download = function(url, data, method) {
    // url과 data를 입력받음
    if( url && data ) {
        // data 는 string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의 input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function() {
            var pair = new Array();
            pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />';
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
</script>