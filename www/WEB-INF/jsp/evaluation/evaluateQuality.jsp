<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.Map" %>
<%
String QUALITYEVALSTATE = null;
if (request.getAttribute("part") != null) {
	QUALITYEVALSTATE = (String) ((Map)request.getAttribute("part")).get("QUALITYEVALSTATE");
}
%>
<table width="800" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
			<tr>
				<td width="21" style="background-color: #ea002c; height: 47px;"></td>
				<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
					<h2>품질평가</h2>
				</td>
				<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
					<a href="#;" class="jqmClose">
					<img src="/img/contents/btn_close.png" class="jqmClose">
					</a>
				</td>
				<td width="10" style="background-color: #ea002c; height: 47px;"></td>
			</tr>
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
                    <form id="frmSave">
                    <input type="hidden" name="oper" value="edit"/>
                    <input type="hidden" name="applId" value="${part.APPLID}"/>
                    <input type="hidden" name="qualityEvalState" value="${part.QUALITYEVALSTATE eq '0' ? '1' : part.QUALITYEVALSTATE}"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="60">품목명</td>
                            <td class="table_td_contents4" width="120">${part.ITEMNM}</td>
                            <td class="table_td_subject" width="60">품목유형</td>
                            <td class="table_td_contents4">${part.ITEMTYPE1},${part.ITEMTYPE2}${not empty part.ITEMTYPE3?',':''}${part.ITEMTYPE3}</td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="60">업체명</td>
                            <td class="table_td_contents4" width="120">${part.VENDORNM}</td>
                            <td class="table_td_subject" width="60">영업담당자</td>
                            <td class="table_td_contents4">${part.BUSICHARGER} (Tel: ${part.BUSIPHONENUM}, Email: ${part.BUSICHARGEREMAIL})</td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="60">품질경영성적서</td>
                            <td class="table_td_contents4" colspan=3>
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" ${empty part.QUALITYMAGTATTACHSEQ ? '':'style="display:none"'}>등록</button>
                                <input type="hidden" id="qualityMagtAttachSeq" name="qualityMagtAttachSeq" value="${part.QUALITYMAGTATTACHSEQ}" class="attachFileSeq" title="품질경영성적서"/>
                                <input type="hidden" id="qualityMagtAttachPath" name="qualityMagtAttachPath" value="${part.QUALITYMAGTATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#qualityMagtAttachPath').val());">
                                <span id="qualityMagtAttachName" class="attachFileName">${part.QUALITYMAGTATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.QUALITYMAGTATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="60">평가자</td>
                            <td class="table_td_contents4" width="120">${part.QUALITYEVALNM}</td>
                            <td class="table_td_subject" width="60">Total</td>
                            <td class="table_td_contents4" style="font-weight:bold"><span id="total" class="total">${part.QUALITYEVALSCORE}</span>점 / 100점 (<span id="total2" class="total">${part.QUALITYEVALSCORE2}</span>점 / 30점)</td>
                        </tr>
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table>
                    <br/>
                    <div id="evalList">
                      <h3>1. 일반사항(<span class="score">5</span>점) -> <span class="total">${empty part.GENERAL ? '0' : part.GENERAL}</span>점</h3>
					  <div class="evalCont">
					    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
					        <colgroup>
                              <col width="30"/>
					          <col width="600"/>
                              <col width="30"/>
                              <col width="30"/>
                              <col width="30"/>
	                        <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
	                        </tr>
	                        <tr>
	                            <td class="table_td_subject c" colspan=2>판단근거</td>
	                            <td class="table_td_subject c">A</td>
                                <td class="table_td_subject c">B</td>
                                <td class="table_td_subject c">C</td>
	                        </tr>
	                        <tr>
	                            <td colspan="5" height='1' bgcolor="eaeaea"></td>
	                        </tr>
                            <tr>
                                <td class="table_td_contents4 c">1</td>
                                <td class="table_td_contents4">품질경영관리를 위한 품질방침 및 품질목표가 문서화되어 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="general1" value="10" ${part.GENERAL1 eq 10?'checked':''} required title="1. 일반사항 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="general1" value="5" ${part.GENERAL1 eq 5?'checked':''} required title="1. 일반사항 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="general1" value="0" ${part.GENERAL1 eq 0?'checked':''} required title="1. 일반사항 - 1"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">2</td>
                                <td class="table_td_contents4">수립된 품질목표 실적은 관리되고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="general2" value="10" ${part.GENERAL2 eq 10?'checked':''} required title="1. 일반사항 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="general2" value="5" ${part.GENERAL2 eq 5?'checked':''} required title="1. 일반사항 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="general2" value="0" ${part.GENERAL2 eq 0?'checked':''} required title="1. 일반사항 - 2"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">3</td>
                                <td class="table_td_contents4">품질업무의 책임과 권한은 명확하게 구분되어 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="general3" value="10" ${part.GENERAL3 eq 10?'checked':''} required title="1. 일반사항 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="general3" value="5" ${part.GENERAL3 eq 5?'checked':''} required title="1. 일반사항 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="general3" value="0" ${part.GENERAL3 eq 0?'checked':''} required title="1. 일반사항 - 3"/></td>
                            </tr>
	                    </table>
					  </div>
                      <h3>2. 문서 및 기록 관리(<span class="score">5</span>점) -> <span class="total">${empty part.DOCUMNT ? '0' : part.DOCUMNT}</span>점</h3>
                      <div class="evalCont">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
                            <colgroup>
                              <col width="30"/>
                              <col width="600"/>
                              <col width="30"/>
                              <col width="30"/>
                              <col width="30"/>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject c" colspan=2>판단근거</td>
                                <td class="table_td_subject c">A</td>
                                <td class="table_td_subject c">B</td>
                                <td class="table_td_subject c">C</td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">1</td>
                                <td class="table_td_contents4">작업일지 및 자체검사 기록은 적정한 상태로 보관되고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="documnt1" value="10" ${part.DOCUMNT1 eq 10?'checked':''} required title="2. 문서 및 기록 관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="documnt1" value="5" ${part.DOCUMNT1 eq 5?'checked':''} required title="2. 문서 및 기록 관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="documnt1" value="0" ${part.DOCUMNT1 eq 0?'checked':''} required title="2. 문서 및 기록 관리 - 1"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">2</td>
                                <td class="table_td_contents4">작업표준, 관련규정, 규격 등이 성문화되어 있어 누구나 열람 가능한가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="documnt2" value="10" ${part.DOCUMNT2 eq 10?'checked':''} required title="2. 문서 및 기록 관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="documnt2" value="5" ${part.DOCUMNT2 eq 5?'checked':''} required title="2. 문서 및 기록 관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="documnt2" value="0" ${part.DOCUMNT2 eq 0?'checked':''} required title="2. 문서 및 기록 관리 - 2"/></td>
                            </tr>
                        </table>
                      </div>
                      <h3>3. 자재관리(<span class="score">15</span>점) -> <span class="total">${empty part.MATERIL ? '0' : part.MATERIL}</span>점</h3>
                      <div class="evalCont">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
                            <colgroup>
                              <col width="30"/>
                              <col width="600"/>
                              <col width="30"/>
                              <col width="30"/>
                              <col width="30"/>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject c" colspan=2>판단근거</td>
                                <td class="table_td_subject c">A</td>
                                <td class="table_td_subject c">B</td>
                                <td class="table_td_subject c">C</td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">1</td>
                                <td class="table_td_contents4">생산에 투입되는 각종 원부자재의 보관상태는 양호한가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="materil1" value="10" ${part.MATERIL1 eq 10?'checked':''} required title="3. 자재관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="materil1" value="5" ${part.MATERIL1 eq 5?'checked':''} required title="3. 자재관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="materil1" value="0" ${part.MATERIL1 eq 0?'checked':''} required title="3. 자재관리 - 1"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">2</td>
                                <td class="table_td_contents4">원부자재의 수입검사 기준/규격, 검사 방법, 성적서를 보유하고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="materil2" value="10" ${part.MATERIL2 eq 10?'checked':''} required title="3. 자재관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="materil2" value="5" ${part.MATERIL2 eq 5?'checked':''} required title="3. 자재관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="materil2" value="0" ${part.MATERIL2 eq 0?'checked':''} required title="3. 자재관리 - 2"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">3</td>
                                <td class="table_td_contents4">불합격 Lot에 대한 처리 지침이 있으며 실행되고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="materil3" value="10" ${part.MATERIL3 eq 10?'checked':''} required title="3. 자재관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="materil3" value="5" ${part.MATERIL3 eq 5?'checked':''} required title="3. 자재관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="materil3" value="0" ${part.MATERIL3 eq 0?'checked':''} required title="3. 자재관리 - 3"/></td>
                            </tr>
                        </table>
                      </div>
                      <h3>4. 생산, 공정관리(<span class="score">20</span>점) -> <span class="total">${empty part.PRODUCE ? '0' : part.PRODUCE}</span>점</h3>
                      <div class="evalCont">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
                            <colgroup>
                              <col width="30"/>
                              <col width="600"/>
                              <col width="30"/>
                              <col width="30"/>
                              <col width="30"/>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject c" colspan=2>판단근거</td>
                                <td class="table_td_subject c">A</td>
                                <td class="table_td_subject c">B</td>
                                <td class="table_td_subject c">C</td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">1</td>
                                <td class="table_td_contents4">작업일지는 빠짐없이 정확하게 기록되고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce1" value="10" ${part.PRODUCE1 eq 10?'checked':''} required title="4. 생산, 공정관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce1" value="5" ${part.PRODUCE1 eq 5?'checked':''} required title="4. 생산, 공정관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce1" value="0" ${part.PRODUCE1 eq 0?'checked':''} required title="4. 생산, 공정관리 - 1"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">2</td>
                                <td class="table_td_contents4">제품의 모든 생산단계 진행결과가 추적되는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce2" value="10" ${part.PRODUCE2 eq 10?'checked':''} required title="4. 생산, 공정관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce2" value="5" ${part.PRODUCE2 eq 5?'checked':''} required title="4. 생산, 공정관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce2" value="0" ${part.PRODUCE2 eq 0?'checked':''} required title="4. 생산, 공정관리 - 2"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">3</td>
                                <td class="table_td_contents4">작업지시 체계가 명확하고 문서로서 관리되고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce3" value="10" ${part.PRODUCE3 eq 10?'checked':''} required title="4. 생산, 공정관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce3" value="5" ${part.PRODUCE3 eq 5?'checked':''} required title="4. 생산, 공정관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce3" value="0" ${part.PRODUCE3 eq 0?'checked':''} required title="4. 생산, 공정관리 - 3"/></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">4</td>
                                <td class="table_td_contents4">각 공정별 공정검사(자주검사)는 기준에 의하여 실시하고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce4" value="10" ${part.PRODUCE4 eq 10?'checked':''} required title="4. 생산, 공정관리 - 4"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce4" value="5" ${part.PRODUCE4 eq 5?'checked':''} required title="4. 생산, 공정관리 - 4"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce4" value="0" ${part.PRODUCE4 eq 0?'checked':''} required title="4. 생산, 공정관리 - 4"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">5</td>
                                <td class="table_td_contents4">공정검사 부적합품은 수거/분석되고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce5" value="10" ${part.PRODUCE5 eq 10?'checked':''} required title="4. 생산, 공정관리 - 5"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce5" value="5" ${part.PRODUCE5 eq 5?'checked':''} required title="4. 생산, 공정관리 - 5"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce5" value="0" ${part.PRODUCE5 eq 0?'checked':''} required title="4. 생산, 공정관리 - 5"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">6</td>
                                <td class="table_td_contents4">변경점 관리절차가 수립되어 있으며 기준에 의해 실시하고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce6" value="10" ${part.PRODUCE6 eq 10?'checked':''} required title="4. 생산, 공정관리 - 6"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce6" value="5" ${part.PRODUCE6 eq 5?'checked':''} required title="4. 생산, 공정관리 - 6"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="produce6" value="0" ${part.PRODUCE6 eq 0?'checked':''} required title="4. 생산, 공정관리 - 6"/></td>
                            </tr>
                        </table>
                      </div>
                      <h3>5. 설비관리(<span class="score">10</span>점) -> <span class="total">${empty part.EQUIPMT ? '0' : part.EQUIPMT}</span>점</h3>
                      <div class="evalCont">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
                            <colgroup>
                              <col width="30"/>
                              <col width="600"/>
                              <col width="30"/>
                              <col width="30"/>
                              <col width="30"/>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject c" colspan=2>판단근거</td>
                                <td class="table_td_subject c">A</td>
                                <td class="table_td_subject c">B</td>
                                <td class="table_td_subject c">C</td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">1</td>
                                <td class="table_td_contents4">설비 및 설비주변은 청결을 유지하며 누수,누액,낙하 부품 등이 없는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="equipmt1" value="10" ${part.EQUIPMT1 eq 10?'checked':''} required title="5. 설비관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="equipmt1" value="5" ${part.EQUIPMT1 eq 5?'checked':''} required title="5. 설비관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="equipmt1" value="0" ${part.EQUIPMT1 eq 0?'checked':''} required title="5. 설비관리 - 1"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">2</td>
                                <td class="table_td_contents4">생산설비의 관리지침 및 운전지침이 있으며 기준에 준하여 관리하는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="equipmt2" value="10" ${part.EQUIPMT2 eq 10?'checked':''} required title="5. 설비관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="equipmt2" value="5" ${part.EQUIPMT2 eq 5?'checked':''} required title="5. 설비관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="equipmt2" value="0" ${part.EQUIPMT2 eq 0?'checked':''} required title="5. 설비관리 - 2"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">3</td>
                                <td class="table_td_contents4">각종 설비 및 치공구가 최적 상태로 유지관리 되고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="equipmt3" value="10" ${part.EQUIPMT3 eq 10?'checked':''} required title="5. 설비관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="equipmt3" value="5" ${part.EQUIPMT3 eq 5?'checked':''} required title="5. 설비관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="equipmt3" value="0" ${part.EQUIPMT3 eq 0?'checked':''} required title="5. 설비관리 - 3"/></td>
                            </tr>
                        </table>
                      </div>
                      <h3>6. 검사관리(<span class="score">20</span>점) -> <span class="total">${empty part.TEST ? '0' : part.TEST}</span>점</h3>
                      <div class="evalCont">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
                            <colgroup>
                              <col width="30"/>
                              <col width="600"/>
                              <col width="30"/>
                              <col width="30"/>
                              <col width="30"/>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject c" colspan=2>판단근거</td>
                                <td class="table_td_subject c">A</td>
                                <td class="table_td_subject c">B</td>
                                <td class="table_td_subject c">C</td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">1</td>
                                <td class="table_td_contents4">검사인원의 교육/훈련 과 인증평가는 실시하는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="test1" value="10" ${part.TEST1 eq 10?'checked':''} required title="6. 검사관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="test1" value="5" ${part.TEST1 eq 5?'checked':''} required title="6. 검사관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="test1" value="0" ${part.TEST1 eq 0?'checked':''} required title="6. 검사관리 - 1"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">2</td>
                                <td class="table_td_contents4">주요 검사설비를 보유하고 있으며, 대외 검교정 성적서가 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="test2" value="10" ${part.TEST2 eq 10?'checked':''} required title="6. 검사관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="test2" value="5" ${part.TEST2 eq 5?'checked':''} required title="6. 검사관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="test2" value="0" ${part.TEST2 eq 0?'checked':''} required title="6. 검사관리 - 2"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">3</td>
                                <td class="table_td_contents4">완제품의 필수항목 검사(출하검사)는 실시되고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="test3" value="10" ${part.TEST3 eq 10?'checked':''} required title="6. 검사관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="test3" value="5" ${part.TEST3 eq 5?'checked':''} required title="6. 검사관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="test3" value="0" ${part.TEST3 eq 0?'checked':''} required title="6. 검사관리 - 3"/></td>
                            </tr>
                        </table>
                      </div>
                      <h3>7. 부적합 및 재발방지 관리(<span class="score">20</span>점) -> <span class="total">${empty part.SUITAB ? '0' : part.SUITAB}</span>점</h3>
                      <div class="evalCont">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
                            <colgroup>
                              <col width="30"/>
                              <col width="600"/>
                              <col width="30"/>
                              <col width="30"/>
                              <col width="30"/>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject c" colspan=2>판단근거</td>
                                <td class="table_td_subject c">A</td>
                                <td class="table_td_subject c">B</td>
                                <td class="table_td_subject c">C</td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">1</td>
                                <td class="table_td_contents4">제품의 모든 생산단계 및 납품 후에도 제품 추적이 되는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="suitab1" value="10" ${part.SUITAB1 eq 10?'checked':''} required title="7. 부적합 및 재발방지 관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="suitab1" value="5" ${part.SUITAB1 eq 5?'checked':''} required title="7. 부적합 및 재발방지 관리 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="suitab1" value="0" ${part.SUITAB1 eq 0?'checked':''} required title="7. 부적합 및 재발방지 관리 - 1"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">2</td>
                                <td class="table_td_contents4">부적합품에 대해서 재발방지를 위한 활동을 하는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="suitab2" value="10" ${part.SUITAB2 eq 10?'checked':''} required title="7. 부적합 및 재발방지 관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="suitab2" value="5" ${part.SUITAB2 eq 5?'checked':''} required title="7. 부적합 및 재발방지 관리 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="suitab2" value="0" ${part.SUITAB2 eq 0?'checked':''} required title="7. 부적합 및 재발방지 관리 - 2"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">3</td>
                                <td class="table_td_contents4">지적사항의 시정조치 사항이 철저히 적용되어 관리되고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="suitab3" value="10" ${part.SUITAB3 eq 10?'checked':''} required title="7. 부적합 및 재발방지 관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="suitab3" value="5" ${part.SUITAB3 eq 5?'checked':''} required title="7. 부적합 및 재발방지 관리 - 3"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="suitab3" value="0" ${part.SUITAB3 eq 0?'checked':''} required title="7. 부적합 및 재발방지 관리 - 3"/></td>
                            </tr>
                        </table>
                      </div>
                      <h3>8. 기타사항(<span class="score">5</span>점) -> <span class="total">${empty part.ETC ? '0' : part.ETC}</span>점</h3>
                      <div class="evalCont">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
                            <colgroup>
                              <col width="30"/>
                              <col width="600"/>
                              <col width="30"/>
                              <col width="30"/>
                              <col width="30"/>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject c" colspan=2>판단근거</td>
                                <td class="table_td_subject c">A</td>
                                <td class="table_td_subject c">B</td>
                                <td class="table_td_subject c">C</td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">1</td>
                                <td class="table_td_contents4">현장은 청결하고 정리정돈되어 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="etc1" value="10" ${part.ETC1 eq 10?'checked':''} required title="8. 기타사항 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="etc1" value="5" ${part.ETC1 eq 5?'checked':''} required title="8. 기타사항 - 1"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="etc1" value="0" ${part.ETC1 eq 0?'checked':''} required title="8. 기타사항 - 1"/></td>
                            </tr>
                            <tr>
                                <td colspan="5" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_contents4 c">2</td>
                                <td class="table_td_contents4">작업자의 안전을 위한 관리가 이루어지고 있는가?</td>
                                <td class="table_td_contents4 c"><input type="radio" name="etc2" value="10" ${part.ETC2 eq 10?'checked':''} required title="8. 기타사항 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="etc2" value="5" ${part.ETC2 eq 5?'checked':''} required title="8. 기타사항 - 2"/></td>
                                <td class="table_td_contents4 c"><input type="radio" name="etc2" value="0" ${part.ETC2 eq 0?'checked':''} required title="8. 기타사항 - 2"/></td>
                            </tr>
                        </table>
                      </div>
					</div>
                    </form>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="center">
                            <% if (QUALITYEVALSTATE != null && (QUALITYEVALSTATE.equals("0") || QUALITYEVALSTATE.equals("1"))) { %>
                            <button id="btnSave" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> 평가</button>
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
	$("#evaluatePop800").jqDrag('#userDialogHandle');
	$('#evalList').accordion({autoHeight:false});
    $('.btnRegFile').click(function() {
        fileTD = $(this).closest('td');
        //console.log(fileTD);
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
        file.find('.btnRegFile').show();
        $(this).hide();
    });
    $('input[type=radio]').click(function () {
    	var table = $(this).closest('table');
    	var h3 = $(this).closest('.evalCont').prev('h3');
    	var score = parseInt(h3.find('.score').html(), 10);
        var cnt = 0;
    	var val = 0;
    	table.find('input[type=radio]').each(function () {
            cnt = cnt + 1;
            if (this.checked) {
            	val = val + parseInt($(this).val(), 10);
            }
    	});
    	var total = Math.round(val / 10.0 / (cnt / 3) * score * 10) / 10;
    	var prev = parseFloat(h3.find('.total').html(), 10.0);
    	h3.find('.total').html(total);
    	var score = parseFloat($('#total').html(), 10.0) - prev + total;
    	$('#total').html(score);
    	$('#total2').html(Math.round(score*300/100)/10);
    	
    });
    $('#btnSave').click(function (e) {
        if (!$("#frmSave").validate()) {
            return;
        }
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/updatePartApplForQuality/save.sys', $('#frmSave').serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  subGrid.trigger("reloadGrid");
                  $('#evaluatePop800').html('');
                  $('#evaluatePop800').jqmHide();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
	$('.jqmClose').click(function (e) {
        $('#evaluatePop800').html('');
		$('#evaluatePop800').jqmHide();
	});
});
// 파일 첨부 
function fnCallBack(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
    fileTD.find('.attachFileSeq').val(rtn_attach_seq);
    fileTD.find('.attachFilePath').val(rtn_attach_file_path);
    fileTD.find('.attachFileName').text(rtn_attach_file_name);
    fileTD.find('.btnRegFile').hide();
    fileTD.find('.btnDelFile').show();
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