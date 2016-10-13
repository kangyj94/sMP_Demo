<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.Map" %>
<%
String FACTORYREGIDATE = null;
String LABREGIDATE = null;
Integer QUALITYMAGTSCORE = null;
Integer CREDITSCORE = null;
String BUSIEVALSTATE = null;
if (request.getAttribute("part") != null) {
	FACTORYREGIDATE = (String) ((Map)request.getAttribute("part")).get("FACTORYREGIDATE");
    LABREGIDATE = (String) ((Map)request.getAttribute("part")).get("LABREGIDATE");
    QUALITYMAGTSCORE = (Integer) ((Map)request.getAttribute("part")).get("QUALITYMAGTSCORE");
    CREDITSCORE = (Integer) ((Map)request.getAttribute("part")).get("CREDITSCORE");
    BUSIEVALSTATE = (String) ((Map)request.getAttribute("part")).get("BUSIEVALSTATE");
    
    if (FACTORYREGIDATE != null && FACTORYREGIDATE.length() == 6) {
        FACTORYREGIDATE = FACTORYREGIDATE.substring(0, 4) + "년 " + FACTORYREGIDATE.substring(4) + "월";
    } else {
    	FACTORYREGIDATE = "없음";
    }
    if (LABREGIDATE != null && LABREGIDATE.length() == 6) {
        LABREGIDATE = LABREGIDATE.substring(0, 4) + "년 " + LABREGIDATE.substring(4) + "월";
    } else {
    	LABREGIDATE = "없음";
    }
}
%>
<table width="800" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
			<tr>
				<td width="21" style="background-color: #ea002c; height: 47px;"></td>
				<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
					<h2>업체평가</h2>
				</td>
				<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
					<a href="#;" class="jqmClose">
					<img src="/img/contents/btn_close.png" class="jqmClose">
					</a>
				</td>
				<td width="10" style="background-color: #ea002c; height: 47px;"></td>
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
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table>
                    <br/>
                    <form id="frmSave">
                    <input type="hidden" name="oper" value="edit"/>
                    <input type="hidden" name="applId" value="${part.APPLID}"/>
                    <input type="hidden" name="busiEvalState" value="${part.BUSIEVALSTATE eq '0' ? '1' : part.BUSIEVALSTATE}"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="5" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">항목</td>
                            <td class="table_td_subject">참가서 작성 정보</td>
                            <td class="table_td_subject">담당자 확인</td>
                            <td class="table_td_subject" colspan=2>관련증빙</td>
                        </tr>
                        <tr>
                            <td colspan="5" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">
                                                                          회사소개서
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.COMPINTROATTACHPATH}');">
                                <span id="compIntroAttachName" class="attachFileName">${part.COMPINTROATTACHNAME}</span>
                                </a>
                            </td>
                            <td class="table_td_contents4">
                                <select name="compIntroScore" required title="회사소개서 점수">
                                    <option value=''>선택</option>
                                    <option ${part.COMPINTROSCORE eq 0 ? 'selected':''}>0</option>
                                    <option ${part.COMPINTROSCORE eq 2 ? 'selected':''}>2</option>
                                    <option ${part.COMPINTROSCORE eq 6 ? 'selected':''}>6</option>
                                    <option ${part.COMPINTROSCORE eq 4 ? 'selected':''}>4</option>
                                    <option ${part.COMPINTROSCORE eq 8 ? 'selected':''}>8</option>
                                    <option ${part.COMPINTROSCORE eq 10 ? 'selected':''}>10</option>
                                </select>
                            </td>
                            <td class="table_td_subject">
                                                                          제품소개서
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.PRODINTROATTACHPATH}');">
                                <span id="prodIntroAttachName" class="attachFileName">${part.PRODINTROATTACHNAME}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">신용등급</td>
                            <td class="table_td_contents4">
                                ${part.CREDITGRADE}
                            </td>
                            <td class="table_td_contents4">
                                <select name="creditGradeScore" required title="신용등급 점수">
                                    <option value=''>선택</option>
                                    <option value="20" ${part.CREDITGRADESCORE eq 20 ? 'selected':''}>AAA ~ A-</option>
                                    <option value="18" ${part.CREDITGRADESCORE eq 18 ? 'selected':''}>BBB+</option>
                                    <option value="17" ${part.CREDITGRADESCORE eq 17 ? 'selected':''}>BBB</option>
                                    <option value="16" ${part.CREDITGRADESCORE eq 16 ? 'selected':''}>BBB-</option>
                                    <option value="14" ${part.CREDITGRADESCORE eq 14 ? 'selected':''}>BB+ ~ BB</option>
                                    <option value="13" ${part.CREDITGRADESCORE eq 13 ? 'selected':''}>BB-</option>
                                    <option value="11" ${part.CREDITGRADESCORE eq 11 ? 'selected':''}>B+ ~ B-</option>
                                    <option value="0" ${part.CREDITGRADESCORE eq 0 ? 'selected':''}>CCC+ ~</option>
                                </select>
                            </td>
                            <td class="table_td_subject">
                                                                          신용등급서
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.CREDITGRADEATTACHPATH}');">
                                <span id="creditGradeAttachName" class="attachFileName">${part.CREDITGRADEATTACHNAME}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">공장 등록년월</td>
                            <td class="table_td_contents4">
		                        <%=FACTORYREGIDATE%>
                            </td>
                            <td class="table_td_contents4">
                                <select name="factoryRegiScore" required title="공장 점수">
                                    <option value=''>선택</option>
                                    <option value="5" ${part.FACTORYREGISCORE eq 5 ? 'selected':''}>8년 이상</option>
                                    <option value="4" ${part.FACTORYREGISCORE eq 4 ? 'selected':''}>6년 이상 8년 미만</option>
                                    <option value="3" ${part.FACTORYREGISCORE eq 3 ? 'selected':''}>4년 이상 6년 미만</option>
                                    <option value="2" ${part.FACTORYREGISCORE eq 2 ? 'selected':''}>2년 이상 4년 미만</option>
                                    <option value="1" ${part.FACTORYREGISCORE eq 1 ? 'selected':''}>2년 미만</option>
                                    <option value='0' ${part.FACTORYREGISCORE eq 0 ? 'selected':''}>없음</option>
                                </select>
                            </td>
                            <td class="table_td_subject">
                                                                          공장등록증
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.FACTORYREGIATTACHPATH}');">
                                <span id="factoryRegiAttachName" class="attachFileName">${part.FACTORYREGIATTACHNAME}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">기업부설연구소 등록년월</td>
                            <td class="table_td_contents4">
                                <%=LABREGIDATE%>
                            </td>
                            <td class="table_td_contents4">
                                <select name="labScore" required title="기업부설연구소 점수">
                                    <option value=''>선택</option>
                                    <option value="5" ${part.LABSCORE eq 5 ? 'selected':''}>8년 이상</option>
                                    <option value="4" ${part.LABSCORE eq 4 ? 'selected':''}>6년 이상 8년 미만</option>
                                    <option value="3" ${part.LABSCORE eq 3 ? 'selected':''}>4년 이상 6년 미만</option>
                                    <option value="2" ${part.LABSCORE eq 2 ? 'selected':''}>2년 이상 4년 미만</option>
                                    <option value="1" ${part.LABSCORE eq 1 ? 'selected':''}>2년 미만</option>
                                    <option value='0' ${part.LABSCORE eq 0 ? 'selected':''}>없음</option>
                                </select>
                            </td>
                            <td class="table_td_subject">
                                                                          기업부설 연구소증
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.LABREGATTACHPATH}');">
                                <span id="labRegAttachName" class="attachFileName">${part.LABREGATTACHNAME}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">품질인증보유</td>
                            <td class="table_td_contents4">
                                ${part.QCPOSSE}
                            </td>
                            <td class="table_td_contents4">
                                                                            국제표준 개수 : 
                                <select name="qcIntrntlScore" required title="국제표준 개수">
                                    <option value=''>선택</option>
                                    <option ${part.QCINTRNTLSCORE eq 0 ? 'selected':''}>0</option>
                                    <option ${part.QCINTRNTLSCORE eq 1 ? 'selected':''}>1</option>
                                    <option ${part.QCINTRNTLSCORE eq 2 ? 'selected':''}>2</option>
                                </select><br/>
                                                                            국내표준 개수 : 
                                <select name="qcDomestcScore" required title="국내표준 개수">
                                    <option value=''>선택</option>
                                    <option ${part.QCDOMESTCSCORE eq 0 ? 'selected':''}>0</option>
                                    <option ${part.QCDOMESTCSCORE eq 1 ? 'selected':''}>1</option>
                                    <option ${part.QCDOMESTCSCORE eq 2 ? 'selected':''}>2</option>
                                    <option ${part.QCDOMESTCSCORE eq 3 ? 'selected':''}>3</option>
                                </select><br/>
                                                                            기타표준 개수 : 
                                <select name="qcEtcScore" required title="기타표준 개수">
                                    <option value=''>선택</option>
                                    <option ${part.QCETCSCORE eq 0 ? 'selected':''}>0</option>
                                    <option ${part.QCETCSCORE eq 1 ? 'selected':''}>1</option>
                                    <option ${part.QCETCSCORE eq 2 ? 'selected':''}>2</option>
                                    <option ${part.QCETCSCORE eq 3 ? 'selected':''}>3</option>
                                    <option ${part.QCETCSCORE eq 4 ? 'selected':''}>4</option>
                                    <option ${part.QCETCSCORE eq 5 ? 'selected':''}>5</option>
                                </select>
                            </td>
                            <td class="table_td_subject">
                                                                          품질인증서
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.QCCERTIATTACHPATH}');">
                                <span id="qcCertiAttachName" class="attachFileName">${part.QCCERTIATTACHNAME}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr id="prodType10">
                            <td class="table_td_subject">동일제품 납품실적 (3년 내)</td>
                            <td class="table_td_contents4 comma">
                                ${part.PRODTYPE eq '10' ? part.DELIVERYRESULT : ''}
                                ${part.PRODTYPE eq '10' and part.DELIVERYRATE ne '0' ? ',' : ''}
                                ${part.PRODTYPE eq '10' ? part.DELIVERYRATE : ''}${part.PRODTYPE eq '10' ? '%' : ''}
                            </td> 
                            <td class="table_td_contents4">
                                <select name="deliveryResultScore" ${part.PRODTYPE eq '20' ? 'disabled':'required'}  title="동일제품 납품실적 점수">
                                    <option value=''>선택</option>
                                    <option value='20' ${part.PRODTYPE eq '10' and part.DELIVERYRESULTSCORE eq 20 ? 'selected':''}>200% 이상</option>
                                    <option value='16' ${part.PRODTYPE eq '10' and part.DELIVERYRESULTSCORE eq 16 ? 'selected':''}>150% 이상 ~ 200% 미만</option>
                                    <option value='12' ${part.PRODTYPE eq '10' and part.DELIVERYRESULTSCORE eq 12 ? 'selected':''}>100% 이상 ~ 150% 미만</option>
                                    <option value='8' ${part.PRODTYPE eq '10' and part.DELIVERYRESULTSCORE eq 8 ? 'selected':''}>50% 이상 ~ 100% 미만</option>
                                    <option value='4' ${part.PRODTYPE eq '10' and part.DELIVERYRESULTSCORE eq 4 ? 'selected':''}>5% 이상 ~ 50% 미만</option>
                                    <option value='0' ${part.PRODTYPE eq '10' and part.DELIVERYRESULTSCORE eq 0 ? 'selected':''}>5% 미만</option>
                                </select>
                            </td>
                            <td class="table_td_subject">
                                                                          동일제품 납품증명서
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.DELIVERYCERTIATTACHPATH}');">
                                <span id="deliveryCertiAttachName" class="attachFileName">${part.PRODTYPE eq '10' ? part.DELIVERYCERTIATTACHNAME : ''}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr id="prodType20">
                            <td class="table_td_subject">유사제품 납품실적 (3년 내)</td>
                            <td class="table_td_contents4 comma">
                                ${part.PRODTYPE eq '20' ? part.DELIVERYRESULT : ''}
                                ${part.PRODTYPE eq '20' and part.DELIVERYRATE ne '0' ? ',' : ''}
                                ${part.PRODTYPE eq '20' ? part.DELIVERYRATE : ''}${part.PRODTYPE eq '20' ? '%' : ''}
                            </td>
                            <td class="table_td_contents4">
                                <select name="deliveryResultScore" ${part.PRODTYPE eq '10' ? 'disabled':'required'} title="유사제품 납품실적 점수">
                                    <option value=''>선택</option>
                                    <option value='10' ${part.PRODTYPE eq '20' and part.DELIVERYRESULTSCORE eq 10 ? 'selected':''}>200% 이상</option>
                                    <option value='8' ${part.PRODTYPE eq '20' and part.DELIVERYRESULTSCORE eq 8 ? 'selected':''}>150% 이상 ~ 200% 미만</option>
                                    <option value='6' ${part.PRODTYPE eq '20' and part.DELIVERYRESULTSCORE eq 6 ? 'selected':''}>100% 이상 ~ 150% 미만</option>
                                    <option value='4' ${part.PRODTYPE eq '20' and part.DELIVERYRESULTSCORE eq 4 ? 'selected':''}>50% 이상 ~ 100% 미만</option>
                                    <option value='2' ${part.PRODTYPE eq '20' and part.DELIVERYRESULTSCORE eq 2 ? 'selected':''}>5% 이상 ~ 50% 미만</option>
                                    <option value='0' ${part.PRODTYPE eq '20' and part.DELIVERYRESULTSCORE eq 0 ? 'selected':''}>5% 미만</option>
                                </select>
                            </td>
                            <td class="table_td_subject">
                                                                          유사제품 납품증명서
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.DELIVERYCERTIATTACHPATH}');">
                                <span id="deliveryCertiAttachName" class="attachFileName">${part.PRODTYPE eq '20' ? part.DELIVERYCERTIATTACHNAME : ''}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" colspan=2>자체보유기기</td>
                            <td class="table_td_contents4">
                                <select name="ownEquipScore" required title="자체보유기기 점수">
                                    <option value=''>선택</option>
                                    <option value='5' ${part.OWNEQUIPSCORE eq 5 ? 'selected':''}>100% 이상</option>
                                    <option value='4' ${part.OWNEQUIPSCORE eq 4 ? 'selected':''}>70% 이상 ~ 100% 미만</option>
                                    <option value='3' ${part.OWNEQUIPSCORE eq 3 ? 'selected':''}>50% 이상 ~ 70% 미만</option>
                                    <option value='2' ${part.OWNEQUIPSCORE eq 2 ? 'selected':''}>20% 이상 ~ 50% 미만</option>
                                    <option value='1' ${part.OWNEQUIPSCORE eq 1 ? 'selected':''}>5% 이상 ~ 20% 미만</option>
                                    <option value='0' ${part.OWNEQUIPSCORE eq 0 ? 'selected':''}>5% 미만</option>
                                </select>
                            </td>
                            <td class="table_td_subject">
                                                                         검증기기 리스트/사진
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.QUALITYVERIPOSSEATTACHPATH}');">
                                <span id="qualityVeriPosseAttachName" class="attachFileName">${part.QUALITYVERIPOSSEATTACHNAME}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" colspan=2 rowspan=3>신인도(기산점)</td>
                            <td class="table_td_contents4" rowspan=3>
                                <select name="creditScore" required title="신인도(기산점) 점수" style="width:100px">
                                    <option value=''>선택</option>
                                    <% for(int i = -10 ; i < 11 ; i++) { %>
                                   <option value='<%=i%>' <%=CREDITSCORE != null && CREDITSCORE.intValue() == i ? "selected":""%>><%=i%></option>
                                   <% } %>
                                </select>
                            </td>
                            <td class="table_td_subject">
                                                                          비밀유지각서 
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.SECRETMEMOATTACHPATH}');">
                                <span id="deliveryCertiAttachName" class="attachFileName">${part.SECRETMEMOATTACHNAME}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan=2 height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject">
                                                                          평가결과 승복 확약각서
                            </td>
                            <td class="table_td_contents4">
                                <a href="javascript:fnAttachFileDownload('${part.COMMITMEMOATTACHPATH}');">
                                <span id="deliveryCertiAttachName" class="attachFileName">${part.COMMITMEMOATTACHNAME}</span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5" class="table_top_line"></td>
                        </tr>
                    </table>
                    </form>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="center">
                            <% if (BUSIEVALSTATE != null && (BUSIEVALSTATE.equals("0") || BUSIEVALSTATE.equals("1"))) { %>
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
<script type="text/javascript">
$(function() {
	$("#evaluatePop800").jqDrag('#userDialogHandle');
    $('#btnSave').click(function (e) {
    	if (!$("#frmSave").validate()) {
            return;
        }
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/updatePartApplForBusi/save.sys', $('#frmSave').serialize(),
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
    $('.comma').each(function () {
    	fnComma(this);
    });
	$('.jqmClose').click(function (e) {
        $('#evaluatePop800').html('');
		$('#evaluatePop800').jqmHide();
	});
});
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
//3자리수마다 콤마
function fnComma(obj) {
	var n = $(obj).html().trim();
    n += '';
    var reg = /(^[+-]?\d+)(\d{3})/;
    while (reg.test(n)){
    n = n.replace(reg, '$1' + ',' + '$2');
    }
    $(obj).html(n);
}
</script>