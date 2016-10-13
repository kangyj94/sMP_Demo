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
<style type="text/css">
.ui-jqgrid .ui-jqgrid-bdiv {
    position: relative;
    margin: 0em;
    padding: 0;
    overflow: hidden;
}
</style>
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

<script type="text/javascript">

$(function(){
    $.ajaxSetup ({
        cache: false
    });
	fnDataInit();
	fnGridInit();
	$('#srcButton').click(function (e) {
		fnSearch();
	});
	$('#regButton').click(function (e) {
		$('#faqPop').html('')
		.load('/board/faqRegPop.sys')
		.jqmShow();
	});
	
    $("#delButton").click( function() {
    	var row = $("#list").jqGrid('getGridParam','selrow');
    	if( ! row ){
    		alert("처리할 데이터를 선택하시기 바랍니다.");
    		return;	
    	}
    	
    	var FAQ_SEQ = $("#list").jqGrid("getRowData",row).FAQ_SEQ;
    	
    	$.post(
    		"/board/deleteFaqManage/save.sys",
    		{
    			FAQ_SEQ		: FAQ_SEQ ,
    			oper		: 'del'
    		},
    		function(args){
    			if ( fnAjaxTransResult(args)) {
    				fnSearch();
    			} 
    		}
    	);

    });
	$('#frmSearch').search();
    $('#faqPop').jqm();
	
});
//코드 데이터 초기화 
function fnDataInit(){
	 $.post(  //조회조건의 faq유형 세팅
	     '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
	     {
	         codeTypeCd:"FAQ_TYPE",
	         isUse:"1"
	     },
	     function(arg){
	         var codeList = eval('(' + arg + ')').codeList;
	         for(var i=0;i<codeList.length;i++) {
	             $("#srcFaqType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
	         }
	     }
	 );  
}

var subGrid = null;
//그리드 초기화
function fnGridInit() {
	$("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectFapList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['순번','유형','서비스유형','제목','조회수','등록자','등록일'],
        colModel:[
            {name:'FAQ_SEQ',hidden:true,key:true},//ITEMID
            {name:'FAQ_TYPE_NM',width:120},//유형
            {name:'SVC_TYPE_NM',width:120},//서비스유형
            {name:'TITLE',width:650},//제목
            {name:'READ_CNT',width:80,align:'center',sorttype:'integer',formatter:'integer',hidden:true,
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//조회수
            {name:'CREATE_USERID',width:60,align:'center', hidden:true},//등록자
            {name:'CREATE_DATE',width:100,align:'center',hidden:true}//등록일
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height: 500,autowidth:true,
        sortname: 'FAQ_SEQ', sortorder: 'desc', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadComplete: function() {
			FnUpdatePagerIcons(this);
		},
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {},
        onCellSelect: function(rowid, iCol, cellcontent, target) {},
        subGrid:true,
        subGridUrl: '<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectFapList/list.sys',
        subGridRowExpanded: function (grid_id, rowId) {
            var subgridTableId = grid_id + "_t";
            $("#" + grid_id).html("<table id='" + subgridTableId + "'></table>");
            $("#" + subgridTableId).jqGrid({
                url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectFapList/list.sys',
                datatype: 'json',
                mtype: 'POST',
                postData: {faq_seq:rowId},
                colNames:['답변'],
                colModel:[
                    {name:'ANSWER',width:800, sortable:false}//답변
                ],
                jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
                height:'100%',
                afterInsertRow: function(rowid, aData) {
                	$(".ui-subgrid .ui-jqgrid-htable").hide();
                },
                onCellSelect: function(rowid, iCol, cellcontent, target) {}
            });
        }
    })
    .jqGrid("setLabel", "rn", "순번");
}
// 조회 등록/수정/삭제 후에도 처리하기에 꼭 펑션으로 사용함. 
function fnSearch() {
    $("#list")
    .jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()})
    .trigger("reloadGrid");
}
</script>


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
				<li class="on">FAQ</li>
			</ul>
			<div style="position:absolute; right:0; margin-top:-30px;"><a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a></div>
			<form id="frmSearch" onsubmit="return false;">
			<input id="srcSvcType" name="srcSvcType" value="VEN" type="hidden"/>
			<table class="InputTable">
				<colgroup>
					<col width="120px" />
					<col width="auto" />
					<col width="120px" />
					<col width="auto" />
				</colgroup>
			
				
				<tr>
					<th>유형</th>
					<td>
						<select id="srcFaqType" name="srcFaqType" style="min-width:100px;" class="select">
							<option value="">전체</option>
						</select>
					</td>
					<th>제목</th>
					<td>
						<input id="srcTitle" name="srcTitle" type="text"/>
					</td>
				</tr>
			</table>
			</form>
			<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;" >
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td bgcolor="#FFFFFF">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
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