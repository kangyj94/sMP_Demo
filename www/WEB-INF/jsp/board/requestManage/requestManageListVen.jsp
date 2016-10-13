<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String srcFromDt = CommonUtils.getCustomDay("YEAR", -1);
	String srcEndDt = CommonUtils.getCurrentDate();
	String Session_auth	= null;
	String deli_Area_Code = null;
	deli_Area_Code = userDto.getAreaType();
	String board_Type = (String)request.getAttribute("board_Type");
	
	String replayFlag = CommonUtils.getString(request.getParameter("replayFlag"));	//답변플래그 Y일경우 답변글
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
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
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	$.post(	//조회조건의 유형세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"REQU_STAT_FLAG", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcRequ_Stat_Flag").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
		}
	);
	
	$("#srcTitle").attr('checked', true);
	
	$("#srcRequ_Stat_Flag").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { fnSearch(); });
	$("#regButton").click( function() { regist(); });
	$("#modButton").click( function() { modify(); });
	$("#delButton").click( function() { deleteRow(); });
	
	$("#srcFromDt").val("<%=srcFromDt%>");
	$("#srcEndDt").val("<%=srcEndDt%>");
});

$(function(){
	$("#srcFromDt").datepicker(
       	{
	   		showOn: "button",
	   		buttonImage: "/img/contents/btn_calenda.gif",
	   		buttonImageOnly: true,
	   		dateFormat: "yy-mm-dd"
       	}
	);
	$("#srcEndDt").datepicker(
       	{
       		showOn: "button",
       		buttonImage: "/img/contents/btn_calenda.gif",
       		buttonImageOnly: true,
       		dateFormat: "yy-mm-dd"
       	}
	);
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/board/requestManageListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:[
			'번호',		'번호 시퀀스',	'제목',				'유형',				'등록일',
			'답변일',	'처리상태',		'requ_User_Numb',	'modi_User_Numb'
		],
		colModel:[
			{name:'num',            index:'num',            width:50,    align:"center", search:false, sortable:false},	//번호
			{name:'no',             index:'no',             hidden:true, key:true},	//번호 시퀀스
			{name:'title',          index:'title',          width:600,align:"left",   search:false, sortable:true,  editable:false},	//제목
			{name:'requ_Stat_Flag', index:'requ_Stat_Flag', width:60, align:"center", search:false, sortable:false, editable:false},	//유형
			{name:'requ_User_Date', index:'requ_User_Date', width:90, align:"center", search:false, sortable:true,  editable:false},	// 등록일
			{name:'modi_User_Date', index:'modi_User_Date', width:90, align:"center", search:false, sortable:false, editable:false},	// 답변자
			{name:'stat_Flag_Code', index:'stat_Flag_Code', width:60, align:"center", search:false, sortable:true,  editable:false},//처리상태
			{name:'requ_User_Numb', index:'requ_User_Numb', hidden:true},	//requ_User_Numb
			{name:'modi_User_Numb', index:'modi_User_Numb', hidden:true}	//modi_User_Numb
		],
		postData: {
			srcFromDt:"<%=srcFromDt%>",
			srcEndDt:"<%=srcEndDt%>"
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: 450,autowidth: true,
		sortname: 'no', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			FnUpdatePagerIcons(this);
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},	
		afterInsertRow: function(rowid, selrowContent, rowelem){
			var requUserDate  = selrowContent.requ_User_Date + "<br/>" + selrowContent.requ_User_Numb;
			var modiUserDate  = "";
			var stat_Flag_Code  = selrowContent.stat_Flag_Code;
			var title         = "&nbsp;&nbsp;" + selrowContent.title;
			
			if(stat_Flag_Code == "처리완료"){
				modiUserDate  = selrowContent.modi_User_Date + "<br/>" + selrowContent.modi_User_Numb;
			}
			
			$(this).setCell(rowid,'title','',{color:'#0000ff',cursor:'pointer'});
			$('#list').jqGrid('setRowData', rowid, {requ_User_Date : requUserDate, modi_User_Date : modiUserDate, title : title});
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			var cm = $("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['name']=="title" ) {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow(rowid);")%>
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcFromDt = $("#srcFromDt").val();
	data.srcEndDt = $("#srcEndDt").val();
	data.srcRequ_Stat_Flag = $("#srcRequ_Stat_Flag").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

//	임시 호출 
function fnClose(){
    
}

function viewRow(rowid) {
	
	if( rowid != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
<%	if(!"ADM".equals(userDto.getSvcTypeCd())) {	%>
		if("<%=userDto.getUserNm() %>"!=selrowContent.requ_User_Numb) {
			alert("작성자만 읽기가 가능합니다.");
			return;
		}
<%	}	%>
		var popurl = "/board/requestManageDetail.sys?no=" + selrowContent.no;
		var popproperty = "dialogWidth:720px;dialogHeight=440px;scroll=auto;status=no;resizable=no;";
// 	    window.showModalDialog(popurl,self,popproperty);
 	    window.open(popurl, 'okplazaPop', 'width=720, height=430, scrollbars=yes, status=no, resizable=yes');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function regist(){
	var popurl = "/board/requestManageWrite.sys";
	var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
// 	window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}

function modify(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
<%	if(!"ADM".equals(userDto.getSvcTypeCd())) {	%>
		if("<%=userDto.getUserNm() %>"!=selrowContent.requ_User_Numb) {
			alert("작성한 사람만 수정 가능합니다.");
			return;
		}
		if("요청"!=selrowContent.stat_Flag_Code) {
			alert("요청상태인 경우만 수정이 가능합니다.");
			return;
		}
<%	}	%>
		var popurl = "/board/requestManageWrite.sys?no=" + selrowContent.no;
		var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
// 		window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function deleteRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if( row != null ) {
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
<%	if(!"ADM".equals(userDto.getSvcTypeCd())) {	%>
		if("<%=userDto.getUserNm() %>"!=selrowContent.requ_User_Numb) {
			alert("작성한 사람만 삭제 가능합니다.");
			return;
		}
		if("요청"!=selrowContent.stat_Flag_Code) {
			alert("요청상태인 경우만 삭제 가능합니다.");
			return;
		}
<%	}	%>
		jq("#list").jqGrid( 
			'delGridRow', row,{
				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/board/requestManageTransGrid.sys",
				recreateForm: true,beforeShowForm: function(form) {
					jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
					jq('#pData').hide(); jq('#nData').hide();  
				},
				reloadAfterSubmit:true,closeAfterDelete: true,
				afterSubmit: function(response, postdata){
					return fnJqTransResult(response, postdata);
				}
			}
		);
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function fnReloadGrid() { //페이지 이동 없이 리로드하는 메소드
	jq("#list").trigger("reloadGrid");
}

function fnReply(params) {
    var popurl = "/board/requestManageWrite.sys?"+params;
	var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
// 	window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, '', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
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
			<!--카테고리 전체보기(S) -->
            <div id="CategoryAll"  style="display:none;">
            	<ul>
              		<li class="OneDepht">공통자재</li>
              		<li>
              			<dl>
              				<dt>결속자재</dt>
               				<dd>
               					<p><a href="#">클램프</a></p>
               					<p><a href="#">케이블타이/밴드</a></p>
               					<p><a href="#">브라켓</a></p>
               				</dd>
              			</dl>
              			<dl>
              				<dt>방수재</dt>
                			<dd>
                				<p><a href="#">방화코팅/실링재</a></p>
                			</dd>
              			</dl>
              			<dl>
              				<dt>볼트/너트/나사</dt>
                			<dd>
                				<p><a href="#">앵커볼트</a> <a href="#">와셔</a></p>
                				<p><a href="#">육각볼트</a> <a href="#">너트</a></p>
                				<p><a href="#">U볼트</a> <a href="#">나사</a></p>
                				<p><a href="#">전산볼트</a></p>
                			</dd>
              			</dl>
              			<dl>
              				<dt>시멘트</dt>
                			<dd>
                				<p><a href="#">보통시멘트</a></p>
                				<p><a href="#">특수시멘트</a></p>
                			</dd>
              			</dl>
              			<dl>
              				<dt>접지/피뢰자재</dt>
                			<dd>
                				<p><a href="#">접지자재</a></p>
                				<p><a href="#">피뢰자재</a></p>
                			</dd>
              			</dl>
			            <dl>
              				<dt>공구</dt>
                			<dd>
                				<p><a href="#">일반작업공구</a> <a href="#">유압공구</a></p>
                				<p><a href="#">전동공구/에어공구</a></p>
                				<p><a href="#">용접절단공구</a></p>
                				<p><a href="#">전설공구</a> <a href="#">매관공구</a></p>
                				<p><a href="#">목공/미장공구</a></p>
                				<p><a href="#">도장기기</a> <a href="#">타정공구</a></p>
                				<p><a href="#">봉제공구</a></p>
                			</dd>
              			</dl>
              		</li>
              	</ul>
            	<ul>
              		<li class="OneDepht">전기/통신</li>
              <li>
              <dl>
              	<dt>전선</dt>
                <dd>
                <p><a href="#">광점퍼코드</a> <a href="#">전원선</a></p>
                <p><a href="#">접지선</a> <a href="#">통신선</a></p>
                <p><a href="#">제어선</a> <a href="#">광케이블</a></p>
                <p><a href="#">RF케이블</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>배전제어기기</dt>
                <dd>
                <p><a href="#">플러그/휴즈</a></p>
                <p><a href="#">스위치/소켓트</a></p>
                <p><a href="#">콘센트</a> <a href="#">멀티탭</a></p>
                <p><a href="#">전기용품클램프</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>조명기구</dt>
                <dd>
                <p><a href="#">항공등화(항공자애표시등)</a></p>
                <p><a href="#">수은/나트륨/백열등 기구</a></p>
                <p><a href="#">형광등 기구</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>절연재료</dt>
                <dd>
                <p><a href="#">절연테이프</a> <a href="#">절연재료</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>전선접속재</dt>
                <dd>
                <p><a href="#">압착단자/슬리브</a></p>
                <p><a href="#">단말처리 및 직선접속재</a></p>
                <p><a href="#">분기 접속재</a></p>
                <p><a href="#">알류미늄몰드 및 덕트</a></p>
                <p><a href="#">합성수지몰드 및 덕트</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>수배전반</dt>
                <dd>
                <p><a href="#">분전함</a> <a href="#">계량기함</a></p>
                <p><a href="#">전원함</a></p>
                </dd>
              </dl>
              </li>
              </ul>
              <ul>
              <li>
              <dl>
              	<dt>전선관로재</dt>
                <dd>
                <p><a href="#">플렉시블전선관</a></p>
                <p><a href="#">케이블트레이/부품</a></p>
                <p><a href="#">강제전선관/부품</a></p>
                <p><a href="#">1종 금속제 가요전선관</a></p>
                <p><a href="#">PC관 및 난영 PE전선관</a></p>
                <p><a href="#">경질 비닐전선관/부품</a></p>
                <p><a href="#">합성수지 가용전선관</a></p>
                <p><a href="#">풀박스</a> <a href="#">철관</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>통신소자</dt>
                <dd>
                <p><a href="#">RF케이블 소자</a></p>
                <p><a href="#">광점퍼코드 소자</a></p>
                <p><a href="#">동축케이블 소자</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>통신 철탑/철가</dt>
                <dd>
                <p><a href="#">지상</a> <a href="#">옥상</a> <a href="#">옥내</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>통신함/기구물</dt>
                <dd>
                <p><a href="#">통신함</a> <a href="#">통신렉</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>가선자재</dt>
                <dd>
                <p><a href="#">배선금구</a> <a href="#">통신금구</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>유/무선통신기기</dt>
                <dd>
                <p><a href="#">HFC 기기</a> <a href="#">광통신 기기</a></p>
                <p><a href="#">RF 통신기기</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>환경친화구조물</dt>
                <dd>
                <p><a href="#">옥상</a> <a href="#">지상</a></p>
                </dd>
              </dl>
              </li>
              </ul>
              
            <ul>
              <li class="OneDepht">토목</li>
              <li>
              <dl>
              	<dt>울타리용재</dt>
                <dd>
                <p><a href="#">금속재</a> <a href="#">목재</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>맨홀/PE구조물</dt>
                <dd>
                <p><a href="#">맨홀용 케이블걸이</a></p>
                <p><a href="#">맨홀</a> <a href="#">철개</a> <a href="#">맨홀사다리</a></p>
                </dd>
              </dl>
              </li>

              <li class="OneDepht">건축</li>
              <li>
              <dl>
              	<dt>도료</dt>
                <dd><p><a href="#">유성페인트</a> <a href="#">수성페인트</a></p></dd>
              </dl>
              <dl>
              	<dt>벽돌</dt>
                <dd>
                <p><a href="#">수성페인트</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>타일</dt>
                <dd>
                <p><a href="#">내/외장 타일</a></p>
                </dd>
              </dl>
              </li>

              <li class="OneDepht">사무/관리용품</li>
              <li>
              <dl>
              	<dt>사무비품</dt>
                <dd><p><a href="#">사무용 기구</a> <a href="#">청소용품</a></p></dd>
              </dl>
              <dl>
              	<dt>산업안전용품</dt>
                <dd>
                <p><a href="#">안전용구</a> <a href="#">안전인쇄물</a></p>
                <p><a href="#">안전용품</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>인쇄물</dt>
                <dd>
                <p><a href="#">공사 인쇄물</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>시청각기재</dt>
                <dd>
                <p><a href="#">디지털 카메라</a></p>
                <p><a href="#">프로젝터</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>위생 및 의료용품</dt>
                <dd>
                <p><a href="#">의약품</a></p>
                </dd>
              </dl>
              </li>
              </ul>

            <ul>
              <li class="OneDepht">제조 원부자재</li>
              <li>
              <dl>
              	<dt>철강재</dt>
                <dd>
                <p><a href="#">앵글/평철</a> <a href="#">파이프</a></p>
                <p><a href="#">콘크리트</a> <a href="#">볼트</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>수/배전재</dt>
                <dd>
                <p><a href="#">BOX</a></p>
                </dd>
              </dl>
              <dl>
              	<dt>전선/관로재</dt>
                <dd>
                <p><a href="#">전원선</a> <a href="#">접지선</a></p>
                <p><a href="#">통신선</a> <a href="#">전선관</a></p>
                </dd>
              </dl>
              </li>
              </ul>
              <div class="close"><a href="#"><img src="/img/layout/btn_close.png" /></a></div>
            </div>

		<!--컨텐츠(S)-->
		<div id="AllContainer">
			<ul class="Tabarea">
				<li class="on">Q&A</li>
			</ul>
			<div style="position:absolute; right:0; margin-top:-30px;"><a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a></div>
			<table class="InputTable">
				<colgroup>
					<col width="100px" />
					<col width="260px" />
					<col width="100px" />
					<col width="auto" />
					<col width="100px" />
					<col width="auto" />
				</colgroup>
			
				
				<tr>
					<th>일자</th>
					<td style="width: 400px;">
						<input type="text" name="srcFromDt" id="srcFromDt" value="" style="width: 75px;" />
							~
						<input type="text" name="srcEndDt" id="srcEndDt" value="" style="width: 75px;" />
					</td>
					<th>유형</th>
					<td>
						<select id="srcRequ_Stat_Flag" name="srcRequ_Stat_Flag" class="select">
							<option value="">전체</option>
						</select>
					</td>
				</tr>
			</table>
		
			<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;" >
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			
				<tr>
					<td bgcolor="#FFFFFF">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr><td style="height: 5px;"></td></tr>
							<tr>
								<td align="right" valign="bottom">
									<button id='regButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
									<button id='modButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 수정</button>
									<button id='delButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-trash-o"></i> 삭제</button>
								</td>
							</tr>
							
							<tr><td style="height: 5px;"></td></tr>
							<tr>
								<td>
									<div id="jqgrid">
										<table id="list"></table>
										<div id="pager"></div>
									</div>
								</td>
							</tr>
						</table>
						<div id="dialog" title="Feature not supported" style="display:none;">
							<p>That feature is not supported.</p>
						</div>
					</td>
				</tr>
			</table> 
			<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
				<p>처리할 데이터를 선택 하십시오!</p>
			</div>
		</div>
        <!--컨텐츠(E)-->
		</div>
        	<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>
</html>