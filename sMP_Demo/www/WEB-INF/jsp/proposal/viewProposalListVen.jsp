<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%
	String listHeight = "$(window).height()-270 + Number(gridHeightResizePlus)";
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	LoginUserDto userInfo = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String srcSuggestStDate = CommonUtils.getCustomDay("YEAR", -1);
	String srcSuggestEndDate = CommonUtils.getCurrentDate();
	@SuppressWarnings("unchecked")	
	List<Map<String,Object>> codeList = (List<Map<String,Object>>)request.getAttribute("codeList");
	@SuppressWarnings("unchecked")	
	List<Map<String,Object>> b2bAdmList = (List<Map<String,Object>>)request.getAttribute("b2bAdmList");
	@SuppressWarnings("unchecked")	
	List<Map<String,Object>> finalUserList = (List<Map<String,Object>>)request.getAttribute("finalUserList");
	boolean isClient = "BUY".equals(userInfo.getSvcTypeCd())? true:false;
	boolean isVendor = "VEN".equals(userInfo.getSvcTypeCd())? true:false;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#divGnb").mouseout(function () {
		$("#snb_vdr").hide();
	});
	$("#snb_vdr").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#snb_vdr").mouseout(function () {
		$("#snb_vdr").hide();
	});
});
</script>

<%
/**------------------------------------첨부파일 사용방법 시작---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
*/
%>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){  
   $("#btnAttach1").click(function(){ fnUploadDialog("PPT파일", $("#firstattachseq").val(), "fnCallBackAttach1","5"); });
   $("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#secondattachseq").val(), "fnCallBackAttach2","5"); });
   $("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#thirdattachseq").val(), "fnCallBackAttach3","5"); });
   $("#btnAttach4").click(function(){ fnUploadDialog("첨부파일(SKTS)", $("#fourthattachseq").val(), "fnCallBackAttach4","10"); });
   suggestTargetSelect();
});
/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#firstattachseq").val(rtn_attach_seq);
   $("#attach_file_name1").text(rtn_attach_file_name);
   $("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#secondattachseq").val(rtn_attach_seq);
   $("#attach_file_name2").text(rtn_attach_file_name);
   $("#attach_file_path2").val(rtn_attach_file_path);
}
/**
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#thirdattachseq").val(rtn_attach_seq);
   $("#attach_file_name3").text(rtn_attach_file_name);
   $("#attach_file_path3").val(rtn_attach_file_path);
}
/**
 * 첨부파일4 파일관리
 */
function fnCallBackAttach4(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#fourthattachseq").val(rtn_attach_seq);
   $("#attach_file_name4").text(rtn_attach_file_name);
   $("#attach_file_path4").val(rtn_attach_file_path);
}
/**
 * 파일다운로드
 */
function fnAttachFileDownload(attach_file_path) {
   var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
   var data = "attachFilePath="+attach_file_path;
   $.download(url,data,'post');
}
jQuery.download = function(url, data, method){
    // url과 data를 입력받음
    if( url && data ){ 
        // data 는  string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의  input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	$.post
	( 
		'/proposal/selectProposalCntText.sys',
		{ },
		function(arg){
			var cntInfoObj = eval('(' + arg + ')').cntInfo;
			$("#proposalCntText").html("총 "+cntInfoObj.ALL_CNT+"건 : 접수대기 "+cntInfoObj.ACCEPT_WAITING_CNT+ "건, 검토중 "+cntInfoObj.ACCEPT_CNT+"건, 적합 "+cntInfoObj.SUITABLE_Y_CNT+"건, 부적합 "+cntInfoObj.SUITABLE_N_CNT+"건, 채택 "+cntInfoObj.APPR_Y_CNT+"건, 미채택 "+cntInfoObj.APPR_N_CNT+"건 ");
		}
	);
	$("#srcButton").click(function(){ 
		$("#srcSuggestTitle").val($.trim($("#srcSuggestTitle").val()));
		$("#srcSuggestName").val($.trim($("#srcSuggestName").val()));
		fnSearch(); 
	});
	$("#regiBtn").click(function(){ // 신규자재 제안 등록화면 열기
		fnOpenDetailView("R");
	});
	
	$("#srcSuggestTitle").keypress(function(e){ if(e.keyCode == 13){ $("#srcButton").click(); } });
	
	$("#question").click( function() { manageManual(); });	//메뉴얼호출
	
	// 날짜 세팅
	$("#srcSuggestStDate").val("<%=srcSuggestStDate%>");
	$("#srcSuggestEndDate").val("<%=srcSuggestEndDate%>");
	
	// 날짜 조회 및 스타일

	$("#srcSuggestStDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcSuggestEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정

	fnSetList(1);
	
});

</script>
<script type="text/javascript">
<%-- 주문접수 리스트--%>
var listDetail;
function fnSetList(page){
	
	$(".ppsContents").remove();
	$("#pager").empty();
	listDetail = "";
	
	var page			= page;
	var rows			= 10;
	var startDate		= $("#startDate").val();
	var endDate			= $("#endDate").val();
	var purcStatFlag	= $("#purcStatFlag").val();
	$.post(
		"/proposal/selectProposalList.sys",
		{
			srcSuggestStDate		: $("#srcSuggestStDate").val(),
			srcSuggestEndDate		: $("#srcSuggestEndDate").val(),
			srcSuggestTitle			: $("#srcSuggestTitle").val(),
			srcSuggestName			: $("#srcSuggestName").val(),
			srcFinalProcStatFlagNm	: $("#srcFinalProcStatFlagNm").val(),
			srcSuggestTarget		: $("#srcSuggestTarget").val(),
			page:page,
			rows:rows
		},
		function(arg){
			var list		= arg.list;
			listDetail 		= arg.list;
			var currPage	= arg.page;
			var rows		= arg.rows;
			var total		= arg.total;
			var records		= arg.records;
			var pageGrp		= Math.ceil(currPage/5);
			var startPage	= (pageGrp-1)*5+1;
			var endPage		= (pageGrp-1)*5+5;
			if(Number(endPage) > Number(total)){
				endPage = total;
			}
			if(records > 0){
				var str = "";
				var data = "";
				for(var i=0; i<list.length; i++){
					data = list[i]; 
					str +=	'<tr class="ppsContents">';
					str +=		'<td align="center" class="br_l0">'+ fnNullToSpace( data.RECEIPTNUM )+'</td>';
					str +=		'<td>';
					str +=			'<p><a href="#;" onclick="javascript:fnListDetail('+i+');">'+data.SUGGESTTITLE+'</a></p>';
					str +=			'<div class="f11">';
					str +=				'<p><strong>제안대상</strong> : '+ fnNullToSpace( data.SUGGESTTARGET )+'</p>';
					str +=				'<p><strong>자재유형</strong> : '+ fnNullToSpace( data.MATERIALTYPE )+'</p>';
					str +=			'</div>';
					str +=		'</td>';
					str +=		'<td>';
					if(data.SUITABLECONTENT){
						str +=			'<p><strong>1차</strong> : '+ data.SUITABLECONTENT+'</p>';
					}
					if(data.APPRAISALCONTENT){
						str +=			'<p><strong>최종</strong> : '+data.APPRAISALCONTENT+'</p>';
					}
					str +=		'</td>';
					str +=		'<td align="center">'+ fnNullToSpace( data.FINALPROCSTATFLAG_NM )+'</td>';
					str +=		'<td align="center">';
					str +=			'<p>'+ fnNullToSpace( data.SUGGESTDATE )+'</p>';
					str +=			'<p>'+ fnNullToSpace( data.SUGGESTNAME )+'</p>';
					str +=		'</td>';
					str +=		'<td align="center">';
					str +=			'<p>'+ fnNullToSpace( data.ACCEPTDATE )+'</p>';
					str +=			'<p>'+ fnNullToSpace( data.ACCEPT_USER_NM )+'</p>';
					str +=		'</td>';
					str +=		'<td align="center">';
					str +=			'<p>'+ fnNullToSpace( data.SUITABLEDATE )+'</p>';
					str +=			'<p>'+ fnNullToSpace( data.SUITABLE_USER_NM )+'</p>';
					str +=		'</td>';
					str +=		'<td align="center">';
					str +=			'<p>'+ fnNullToSpace( data.APPRAISALDATE )+'</p>';
					str +=			'<p>'+ fnNullToSpace( data.APPRAISAL_USER_NM )+'</p>';
					str +=		'</td>';
					str += "</tr>";
				}
				$("#proposalTable").append(str);
				fnPager(startPage, endPage, currPage, total, 'fnSetList');	//페이져 호출 함수
				
			}
		},
		"json"
	);
}


function fnNullToSpace( data ){
	if( !data ){
		data = "" ;
	}
	return data;
}

function fnListDetail(i){
	fnOpenDetailView("D",listDetail[i]);
}

function fnSearch(){
	fnSetList(1);	
}

function fnOpenDetailView(flag,selRowContent){
	if(flag == "R"){
		fnProposalDetailDiv("processProposalAfter",flag,new Object());
	}else{
		fnProposalDetailDiv("processProposalAfter",flag,selRowContent);
	}
}

function suggestTargetSelect() {
	$.post(
		"/proposal/suggestTargetSelect.sys",
		function(arg){
			var result = eval("("+arg+")");
			for(var i=0; i<result.list.length;i++){
				$("#suggestTarget").append("<option value="+result.list[i].codeVal1+">"+result.list[i].codeNm1+"</opiton>");
				$("#srcSuggestTarget").append("<option value="+result.list[i].codeVal1+">"+result.list[i].codeNm1+"</opiton>");
			}
			
		}
	);
}

function manageManual(){
	var header = "신규 자재 제안하기";
	var manualPath = "";
	var popUrl = "";
	<%if(isClient || isVendor){%>
		//구매사, 공급사 공용 화면임
		manualPath = "/img/manual/branch/viewProposalList.jpg";
		popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	<%}else{%>
		//매니저권한관련이라당장은 주석처리
		//manualPath = "/img/manageManual/viewProposalListManual.JPG";
		//popUrl = "/manage/manageManual.sys?header="+header+"&manualPath="+manualPath;
	<%}%>
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>

<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>


<body class="subBg">
  <div id="divWrap">
  	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
  	<!-- /header -->
    <hr>
		<div id="divBody">
        	<div id="divSub">
            	<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
            	<!--카테고리(S)-->
			
		<!--컨텐츠(S)-->
			<div id="AllContainer">
				<ul class="Tabarea">
					<li class="on">신규 자재 제안 목록</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;">
					<a href="#;"><img id="srcButton" src="/img/contents/btn_tablesearch.gif" /></a>
				</div>
				<table  class="InputTable">
					<colgroup>
						<col width="100px" />
						<col width="auto" />
						<col width="100px" />
						<col width="auto" />
					</colgroup>
					<tr>
						<th>제안일</th>
						<td>
							<input type="text" name="srcSuggestStDate" id="srcSuggestStDate" style="width: 80px;vertical-align: middle;" /> 
							~ 
							<input type="text" name="srcSuggestEndDate" id="srcSuggestEndDate" style="width: 80px;vertical-align: middle;" />

						</td>
						<th>제안명</th>
						<td><input id="srcSuggestTitle" name="srcSuggestTitle" type="text" value="" size="" maxlength="50" style="width: 180px" /></td>
					</tr>
					<tr>
						<th>처리상태</th>
						<td>
							<select id="srcFinalProcStatFlagNm"  style="width: 120px;">
								<option value="">전체</option>
<%
	if(codeList.size() > 0){
		for(Map<String, Object> codeMap : codeList){
%>
								<option value="<%=codeMap.get("CODE_VAL")%>"><%=codeMap.get("CODE_NM")%></option>
<%
		}
	}
%>
							</select>
						</td>
						<th>제안대상</th>
						<td>
							<select id="srcSuggestTarget" name="srcSuggestTarget"  style="width:120px;">
								<option value="">선택</option>
							</select>
						</td>
					</tr>
				</table>
				<div class="mgt_20">
					<p>* 처리 Process : <span class="col02">접수대기 > 검토중 > 적합, 부적합 > 채택, 미채택</span></p>
					<p id="proposalCntText">총 80건 : 접수대기 3건, 검토중 8건, 적합 41건, 부적합 18건, 채택 3건, 미채택 7건 </p>
					<span style="position:absolute; right:0; display:block; margin-top:-22px;">
						<button id='regiBtn' class="btn btn-darkgray btn-xs" ><i class="fa fa-file-o"></i> 제안하기</button>
					</span>
				</div>
				<div class="ListTable mgt_5">
					<table id="proposalTable">
						<colgroup>
							<col width="70px" />
							<col width="200px" />
							<col width="auto" />
							<col width="100px" />
							<col width="100px" />
							<col width="100px" />
							<col width="100px" />
							<col width="100px" />
						</colgroup>
						<tr>
							<th rowspan="2" class="br_l0"><p>접수번호</p></th>
							<th rowspan="2">제안정보</th>
							<th rowspan="2">
								<p>검토의견</p>
								<p>(1차/최종)</p></th>
							<th rowspan="2">처리상태</th>
							<th colspan="4">검토결과</th>
						</tr>
						<tr>
							<th>제안일/제안자</th>
							<th>접수일</th>
							<th>1차검토일</th>
							<th>최종평가일</th>
						</tr>
					</table>
				</div>
				
				<div id="pager" class="divPageNum"></div>
			</div>
		<!--컨텐츠(E)-->

		</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
	
<%@ include file="/WEB-INF/jsp/proposal/svcProposalDetailDiv.jsp" %>
<%@ include file="/WEB-INF/jsp/common/attachFileDivForProporsal.jsp" %>
</body>
</html>