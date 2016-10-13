<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpVendorsDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");

	String _menuId = request.getParameter("_menuId")==null ? "" : (String)request.getParameter("_menuId");
	if("".equals(_menuId)) _menuId = request.getAttribute("_menuId")==null ? "" : (String)request.getAttribute("_menuId");
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
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
						<li class="on">사업장관리</li>
					</ul>
						
					<input id="srcBorgName" name="srcBorgName" type="hidden" value="" />
					<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
					<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
					<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
					<input id="authMode" name="authMode" type="hidden" value=""/>
					
					<div style="position:absolute; right:0; margin-top:-30px;">
						<a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a>
					</div>
					<table class="InputTable">
						<colgroup>
							<col width="100px" />
							<col width="auto" />
							<col width="100px" />
							<col width="auto" />
						</colgroup>
						<tr>
							<th>소재지</th>
							<td>
								<select id="srcAreaType" name="srcAreaType">
									<option value="">전체</option>
								</select>
							</td>
							</td>
							<th>상태</th>
							<td>
								<select id="srcIsUse" name="srcIsUse"> 
									<option value="1">정상</option>
									<option value="0">종료</option>
									<option value="">전체</option> 
								</select>
							</td>
						</tr>
					</table>
				
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						
							<tr>
								<td bgcolor="#FFFFFF">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr><td style="height: 5px;"></td></tr>
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
								</td>
							</tr>
						</table> 
					</form>	
					<div style="height:10px;"></div>
					
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
	<form id="ebillPopFrm" name="ebillPopFrm" onsubmit="return false;">
		<input id="pubCode" name="pubCode" type="hidden"/>
		<input id="docType" name="docType" type="hidden" value="T"/>
		<input id="userType" name="userType" type="hidden" value="R"/>
	</form>
</body>

<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$.post(	//조회조건의 권역세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/getCodeList.sys',
		{codeTypeCd:"VEN_AREA_CODE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcAreaType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			initList();	//그리드 초기화
		}
	);
	
	//구분
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"REQVENDOR_CLASSIFY",//신규자재 코드와 같이 사용
			isUse:"1"
		},
		function(arg){
			var reqVendorClassify = eval('('+arg+')').list;
			for(var i=0; i<reqVendorClassify.length; i++){
				$("#classify").append("<option value='"+reqVendorClassify[i].codeVal1+"'>"+reqVendorClassify[i].codeNm1+"</option>");
			}
		}
	);
	
	$("#srcButton").click( function() { fnSearch(); });
	
	$("#modButton").click(function(){ onDetail(); });
	

	$("#srcAreaType").attr("disabled", true);
	$("#srcIsUse").attr("disabled", true);

	selectReqVendorClassify();//구분
});

</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organVendorListJQGrid.sys', 
		datatype: 'local',
		mtype: 'POST',
		colNames:['업체코드', '공급사명', '사업자등록번호','주요상품', '소재지', '상태', '대표전화번호', '대표자명', '우편번호', '주소','상세주소','회사샵(#)메일', '등록일', 'vendorId'],
		colModel:[
			{name:'vendorCd',index:'vendorCd', width:75,align:"center",search:false,sortable:true, 
				editable:false 
			},	//업체코드
			{name:'vendorNm',index:'vendorNm', width:150,align:"left",search:false,sortable:true, 
				editable:false 
			},	//공급사명
			{name:'businessNum',index:'businessNum', width:90,align:"center",search:false,sortable:true, 
				editable:false 
			},	//사업자등록번호
			{name:'homePage',index:'homePage', width:150,align:"center",search:false,sortable:true, 
				editable:false 
			},	//주요상품(홈페이지)
			{name:'areaTypeNm',index:'areaTypeNm', width:50,align:"center",search:false,sortable:true, 
				editable:false 
			},	//권역
			{name:'isUse',index:'isUse', width:40,align:"center",search:false,sortable:true,
				editable:false 
			},	//상태
			{name:'phoneNum',index:'phoneNum', width:80,align:"center",search:false,sortable:true,
				editable:false
			},	//대표전화번호
			{name:'pressentNm',index:'pressentNm', width:80,align:"center",search:false,sortable:true, 
				editable:false 
			},	//대표자명
			{name:'postAddrNum',index:'postAddrNum', width:50,align:"center",search:false,sortable:true, 
				editable:false 
			},	//우편번호
			{name:'addres',index:'addres', width:200,align:"left",search:false,sortable:true,
				editable:false 
			},	//주소
			{name:'addresDesc',index:'addresDesc', width:200,align:"left",search:false,sortable:true,
				editable:false 
			},	//상세주소
			{name:'sharp_mail',index:'sharp_mail', width:150,align:"left",search:false,sortable:true,
				editable:false 
			},	//상세주소
			{name:'createDate',index:'createDate', width:80,align:"center",search:false,sortable:true, 
				editable:false 
			},	//등록일
			{name:'vendorId',index:'vendorId', hidden:true
			}	//vendorId
		],
		postData: {
			srcAreaType:$("#srcAreaType").val(),
			vendorSearchId:'<%=userDto.getBorgId()%>',
			srcIsUse:$("#srcIsUse").val(),
			classify:$("#classify").val()
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pager',
		height: 425,autowidth: true,
		sortname: 'vendorId', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			FnUpdatePagerIcons(this);
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","onDetail();")%>
		},
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'vendorNm','',{color:'#0000ff'}); 
			jq("#list").setCell(rowid,'vendorNm','',{cursor: 'pointer'});  
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcAreaType = $("#srcAreaType").val();
	data.srcIsUse = $("#srcIsUse").val();
	data.classify = $("#classify").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organVendorDetail.sys?vendorId=" + selrowContent.vendorId + "&_menuId=<%=_menuId%>";
		var popproperty = "dialogWidth:920px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
// 	    window.showModalDialog(popurl,self,popproperty);
	    window.open(popurl, 'okplazaPop', 'width=920, height=670, scrollbars=yes, status=no, resizable=no');
// 	    fnSearch();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}
</script>

</html>