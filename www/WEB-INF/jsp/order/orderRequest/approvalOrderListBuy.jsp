<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="java.util.List"%>
<%

String _menuId = request.getParameter("_menuId")==null ? "" : (String)request.getParameter("_menuId");
if("".equals(_menuId)) _menuId = request.getAttribute("_menuId")==null ? "" : (String)request.getAttribute("_menuId");

	String clientOrderStatus = request.getParameter("srcOrderStatusFlag") == null ? "" : request.getParameter("srcOrderStatusFlag");

	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);


	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<CodesDto> codeList = (List<CodesDto>)request.getAttribute("codeList");
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
    
	// 날짜 세팅
	String srcOrderStartDate = CommonUtils.getCustomDay("DAY", -7);
    if(!clientOrderStatus.equals("")){
		srcOrderStartDate = CommonUtils.getCustomDay("MONTH", -1); 
    }
	String srcOrderEndDate = CommonUtils.getCurrentDate();

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
});
</script>



<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }

##그리도 로딩 시 pager 제거
.ui-jqgrid .ui-jqgrid-htable th div {
    height:auto;
    overflow:hidden;
    padding-right:2px;
    padding-left:2px;
    padding-top:4px;
    padding-bottom:4px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important;
}

</style>


<body class="mainBg">
  <div id="divWrap">
  	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
  	<!-- /header -->
    <hr>
		<div id="divBody">
        	<div id="divSub">
            	<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />
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
						<li class="on">주문승인조회</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;">
						<a href="#;"><img src="/img/contents/btn_excelDN.gif" id="allExcelButton" name="allExcelButton"/></a>
						<a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a>
					</div>
					<table class="InputTable">
						<colgroup>
							<col width="100px" />
							<col width="auto" />
							<col width="100px" />
							<col width="auto" />
							<col width="100px" />
							<col width="auto" />
						</colgroup>
						<tr>
							<th>주문번호</th>
							<td>
								<input id="srcOrderNumber" name="srcOrderNumber" type="text" value="" size="" maxlength="50" style="width: 100px" />
							</td>
							<th>공급업체</th>
							<td>
								<input id="srcVendorName" name="srcVendorName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
							</td>
							<th>처리상태</th>
							<td>
								<input name="srcOrderStatusFlag" type="radio" value="R" checked="checked">승인요청 &nbsp;
								<input name="srcOrderStatusFlag" type="radio" value="H">승인이력
							</td>
						</tr>
						<tr>
							<th>상품코드</th>
							<td>
								<input id="srcGoodsId" name="srcGoodsId" type="text" value="" size="20" maxlength="30" style="width: 100px" />
							</td>
							<th>상품명</th>
							<td>
								<input id="srcGoodsName" name="srcGoodsName" type="text" value="" size="" maxlength="50" style="width: 100px" />
							</td>
							<th>주문일</th>
							<td>
								<input type="text" name="srcOrderStartDate" id="srcOrderStartDate" style="width: 75px;vertical-align: middle;" /> 
								~ 
								<input type="text" name="srcOrderEndDate" id="srcOrderEndDate" style="width: 75px;vertical-align: middle;" />
							</td>
						</tr>
					</table>
					
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td bgcolor="#FFFFFF">
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr><td colspan="2"style="height: 5px;"></td></tr>
									<tr>
										<td>
											* 주문의 상세내용 및 주문 취소는 상세화면에서 확인해주십시오.
										</td>
										<td align="right">
											<button onclick="javascript:orderApproval();" class="btn btn-darkgray btn-xs ordBtn" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-check"></i> 승인</button>
											<button  onclick="javascript:orderReject();" class="btn btn-darkgray btn-xs ordBtn" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-ban"></i> 반려</button>
										</td>
									</tr>
									<tr><td colspan="2" style="height: 5px;"></td></tr>
									<tr>
										<td colspan="2">
											<div id="jqgrid">
												<table id="list"></table>
												<div id="pager"></div>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					 <div style="height:10px;"></div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>
	<div id="dialog" title="Feature not supported" style="display:none;">
			<p>That feature is not supported.</p>
	</div>
	<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
		<p>데이터를 선택 하십시오.</p>
	</div>
</body>
<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcOrderNumber").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcGoodsName").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcGoodsId").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcVendorName").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	
	$("#srcButton").click(function(){ 
		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
		$("#srcGoodsId").val($.trim($("#srcGoodsId").val()));
		$("#srcGoodsName").val($.trim($("#srcGoodsName").val()));
		$("#srcVendorName").val($.trim($("#srcVendorName").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		fnSearch(); 
	});
	$("#allExcelButton").click(function(){ 
		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
		$("#srcGoodsId").val($.trim($("#srcGoodsId").val()));
		$("#srcGoodsName").val($.trim($("#srcGoodsName").val()));
		$("#srcVendorName").val($.trim($("#srcVendorName").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		fnAllExcelPrintDown();
	});
	$("input[type=radio][name=srcOrderStatusFlag]").change(function(){
		var status = $(this).val() ;
		if( status == 'R'){
			$(".ordBtn").show();
		}else{ // H
			$(".ordBtn").hide();
		}		
		$("#srcButton").click();		
	});
	// 날짜 세팅
	$("#srcOrderStartDate").val("<%=srcOrderStartDate%>");
	$("#srcOrderEndDate").val("<%=srcOrderEndDate%>");
	$("#srcOrderStartDate").datepicker({
		showOn: "button",
			buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
	});
	$("#srcOrderEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/selectAppovalProcList/list.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'주문일자','납품요청일','주문번호',
			'주문명', '주문<br/>유형', '주문상태',  '공급사', '공급사 전화번호','주문자', '상품명', '규격','판매단가', '수량', '판매금액', 'vendorid', 'good_iden_numb'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
			{name:'regi_date_time',index:'regi_date_time', width:80,align:"center",search:false,sortable:true, editable:false, editable:false,sorttype:"date", editable:false,formatter:"date"},//주문일자
			{name:'requ_deli_date',index:'requ_deli_date', width:80,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},//납품요청일
			{name:'orde_iden_numb',index:'orde_iden_numb', width:120,align:"left",search:false,sortable:true, editable:false},//주문번호
			{name:'cons_iden_name',index:'cons_iden_name', width:125,align:"left",search:false,sortable:true, editable:false },//주문명
			{name:'orde_type_clas',index:'orde_type_clas', width:50,align:"center",search:false,sortable:true, editable:false },//주문유형
			{name:'order_status_flag',index:'order_status_flag', width:70,align:"left",search:false,sortable:true, editable:false },//주문상태
			{name:'vendor_name',index:'vendor_name', width:130,align:"left",search:false,sortable:true, editable:false},//공급사
			{name:'phonenum',index:'phonenum', width:100,align:"right",search:false,sortable:true, editable:false},//공급사전화번호
			{name:'orde_user_name',index:'orde_user_name', width:60,align:"left",search:false,sortable:true, editable:false},//주문자
			{name:'good_iden_name',index:'good_iden_name', width:140,align:"left",search:false,sortable:true, editable:false },//상품명
			{name:'good_spec',index:'good_spec', width:140,align:"left",search:false,sortable:true, editable:false },//상품규격
			{name:'sell_price',index:'sell_price', width:120,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매단가
			{name:'orde_requ_quan',index:'orde_requ_quan', width:40,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수량
			{name:'total_sell_price',index:'total_sell_price', width:120,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매금액		
			{name:'vendorid',index:'vendorid', hidden:true, search:false,sortable:true, editable:false},
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false}
		],
		postData: {
			srcOrderStartDate:$('#srcOrderStartDate').val()
			,srcOrderEndDate:$('#srcOrderEndDate').val()
			,srcApproveUserId:"<%=userDto.getUserId()%>"
			,srcOrderStatusFlag: $("input[name=srcOrderStatusFlag]:checked").val()
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pager',
		height: 425,width:1000,
		sortname: 'regi_date_time', sortorder: "desc", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	
		loadComplete: function() {
			//FnUpdatePagerIcons(this);
			var rowCnt = $(this).getGridParam('reccount');
			if(rowCnt > 0){
				for(var i=0; i<rowCnt; i++){
					var rowid = $(this).getDataIDs()[i];
					var selrowContent = $(this).jqGrid('getRowData',rowid);
					var phonenum = selrowContent.phonenum;
					phonenum = fnSetTelformat(phonenum);
					$(this).jqGrid('setRowData',rowid,{phonenum:phonenum});
				}
			};
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
        afterInsertRow: function(rowid, aData){
     		jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
     		jq("#list").setCell(rowid,'good_iden_name','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'good_iden_name','',{cursor: 'pointer'});  
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(colName != undefined &&colName['index']=="good_iden_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailPop( selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;'/>";
}
function checkBox(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
   if($("#chkAllOutputField").is(':checked')) {
	   var rowCnt = jq("#list").getGridParam('reccount');
	    if(rowCnt>0) {
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#list").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:not(checked)').attr("checked", true);
	        }
	    }
   } else {
	    var rowCnt = jq("#list").getGridParam('reccount');
	    if(rowCnt>0) {
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#list").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:checked').attr("checked", false);
	        }
	    }
   }
}

function orderApproval(){
	var orde_iden_numb_array = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
		if(!confirm("선택된 정보를 승인처리 하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/buyOrder/procDirectOrder.sys",
			{  
				orde_iden_numb_array:orde_iden_numb_array 
				,flag:"10"
			}
			,function(arg){ 
				if(fnAjaxTransResult(arg)) {	
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
function orderReject(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
	}
	if(confirm("선택된 정보를 반려처리하시겠습니까?")){
		fnStatChangeReasonDialog("processOrderReject");
	}
}
function processOrderReject(reason){
	var orde_iden_numb_array = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
				arrRowIdx++;
			}
		}
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/buyOrder/procDirectOrder.sys",
			{  orde_iden_numb_array:orde_iden_numb_array 
			  ,reason:reason
			  ,flag:"09"
			}
			,function(arg){ 
				if(fnAjaxTransResult(arg)) {	
					alert("정상적으로 반려처리가 되었습니다.");
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
function processOrderReject_cancel(){}
/*
 * 리스트 조회
 */
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcOrderNumber = $("#srcOrderNumber").val();
	data.srcGoodsName = $("#srcGoodsName").val();
	data.srcGoodsId = $("#srcGoodsId").val();
	data.srcOrderStatusFlag = $("input[name=srcOrderStatusFlag]:checked").val()
	data.srcOrderStartDate = $("#srcOrderStartDate").val();
	data.srcOrderEndDate = $("#srcOrderEndDate").val();
	data.srcVendorName = $("#srcVendorName").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}


function fnAllExcelPrintDown(){
	var colLabels = ['주문일자','납품요청일','주문번호','주문명', '주문유형',  '주문상태',  '공급사', '공급사 전화번호','주문자', '상품명', '규격','판매단가', '수량', '판매금액'];
	var colIds = ['regi_date_time', 'requ_deli_date', 'orde_iden_numb', 'cons_iden_name', 'orde_type_clas', 'order_status_flag',  'vendor_name', 'phonenum', 'orde_user_name', 'good_iden_name', 'good_spec', 'sell_price', 'orde_requ_quan', 'total_sell_price'];
	var numColIds = ['sell_price','orde_requ_quan','total_sell_price'];	
	var sheetTitle = "주문승인조회";	//sheet 타이틀
	var excelFileName = "OrderApprovalList";	//file명
    
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcOrderNumber';
    fieldSearchParamArray[1] = 'srcGoodsName';
    fieldSearchParamArray[2] = 'srcGoodsId';
    fieldSearchParamArray[3] = 'srcOrderStatusFlag';
    fieldSearchParamArray[4] = 'srcOrderStartDate';
    fieldSearchParamArray[5] = 'srcOrderEndDate';
    fieldSearchParamArray[6] = 'srcVendorName';
    
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray,"/order/orderRequest/selectAppovalProcList/excel.sys");  
}


</script>

<%// slider start! %>
<link type="text/css" rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/lightslider.css" />
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/lightslider.js" type="text/javascript"></script>
<%// slider end! %>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>

<%@ include file="/WEB-INF/jsp/common/svcStatChangeReasonDiv.jsp" %>

</html>