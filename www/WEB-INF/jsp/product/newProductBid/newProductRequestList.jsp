<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.Map"%>
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<script>
$(document).ready(function() {
    $("#divGnb").mouseover(function () {$("#snb").show();});
    $("#divGnb").mouseout(function () {$("#snb").hide();});
    $("#snb").mouseover(function () {$("#snb").show();});
    $("#snb").mouseout(function () {$("#snb").hide();});
});
</script>
</head>
<body class="mainBg">
<div id="divWrap">
	<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
	<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />
<% 
	String insertDate = CommonUtils.getCurrentDate();
	String srcInsert_FromDt = CommonUtils.getCustomDay("DAY", -7);
	String srcInsert_EndDt = CommonUtils.getCurrentDate();
%>
				<div id="AllContainer" style="min-height:500px">
					<div id="tab1" class="tab">
						<ul class="Tabarea">
							<li class="on">신규상품요청</li>
							<li class="link-tab" style="cursor:pointer">신규상품요청 이력</li>
						</ul>
						<div style="position:absolute; right:0; margin-top:-30px;"></div>
						<form id="frm" onsubmit="return false">
							<input name="oper" type="hidden" value="add" />
							<input name="state" type="hidden" value="10" />
							<input name="newgoodid" type="hidden" />
							<input name="insert_borgid" type="hidden" value="${sessionScope.sessionUserInfoDto.borgId}" />
							<input name="insert_user_id" type="hidden" value="${sessionScope.sessionUserInfoDto.userId}" />
							<table class="InputTable">
								<colgroup>
									<col width="120px" />
									<col width="auto" />
									<col width="120px" />
									<col width="auto" />
									<col width="120px" />
									<col width="auto" />
								</colgroup>
								<tr>
									<th>고객사</th>
									<td colspan=3>
										<input name="insert_borgid_nm" type="text" style="width:350px;" value="${sessionScope.sessionUserInfoDto.borgNms}" readonly="readonly" disabled/>
									</td>
									<th>요청일</th>
									<td>
										<input type="text" style="width:100px;" value="<%=insertDate%>" readonly="readonly" readonly="readonly" disabled/>
									</td>
								</tr>
								<tr>
									<th>상품명</th>
									<td colspan="3">
										<input name="stand_good_name" title="상품명" required type="text" style="width:150px;" value="" />
									</td>
									<th style="display: none;">요청타입</th>
									<td style="display: none;">  
										<input name="request_type" style="border:0px;vertical-align:middle;" type="radio" value="0" checked />상품등록
										<input name="request_type" style="border:0px;vertical-align:middle;" type="radio" value="1" />상품제안
									</td>
									<th>진행상태</th>
									<td>
										<select id="state" title="진행상태" style="width:100px;" readonly="readonly" disabled></select>
									</td>
								</tr>
								<tr>
									<th>상품규격</th>
									<td colspan=3>
										<input name="stand_good_spec_desc" title="상품규격" required maxlength="100" type="text" style="width:350px;" value="" />
									</td>
									<th>기상품코드</th>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<th>요청사항</th>
									<td colspan=5>
										<textarea name="note" title="요청사항" required rows="10" style="width:98%;"></textarea>
									</td>
								</tr>
								<tr>
									<th>첨부파일1 </th>
									<td colspan=5>
										<input type="hidden" id="firstattachseq" name="firstattachseq" value="" />
										<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="" />
										<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
											<span id="attach_file_name1"></span>
										</a>
										<div style="float:right">
											<button id="btnAttach1" type="button" class="btn btn-darkgray btn-xs btnFile">등록</button>
											<a href="javascript:fnAttachDel('firstattachseq');">
												<button id="btnAttachDel1" type="button" class="btn btn-default btn-xs btnFile" style="display:none">삭제</button>
											</a>
										</div>
									</td>
								</tr>
								<tr>
									<th>첨부파일2 </th>
									<td colspan=5>
										<input type="hidden" id="secondattachseq" name="secondattachseq" value="" />
										<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="" />
										<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
											<span id="attach_file_name2"></span>
										</a>
										<div style="float:right">
											<button id="btnAttach2" type="button" class="btn btn-darkgray btn-xs btnFile">등록</button>
											<a href="javascript:fnAttachDel('secondattachseq');">
												<button id="btnAttachDel2" type="button" class="btn btn-default btn-xs btnFile" style="display:none">삭제</button>
											</a>
										</div>
									</td>
								</tr>
								<tr>
									<th>첨부파일3 </th>
									<td colspan=5>
										<input type="hidden" id="thirdattachseq" name="thirdattachseq" value="" />
										<input type="hidden" id="attach_file_path3" name="attach_file_path3" value=""/>
										<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
											<span id="attach_file_name3"></span>
										</a>
										<div style="float:right">
											<button id="btnAttach3" type="button" class="btn btn-darkgray btn-xs btnFile">등록</button>
											<a href="javascript:fnAttachDel('thirdattachseq');">
												<button id="btnAttachDel3" type="button" class="btn btn-default btn-xs btnFile" style="display:none">삭제</button>
											</a>
										</div>
									</td>
								</tr>
							</table>
						</form>
						<div class="Ac mgt_10">
							<button id="regiJqmButton" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
							<button id="modiJqmButton" type="button" class="btn btn-darkgray btn-sm" style="display:none"><i class="fa fa-floppy-o"></i> 수정</button>
							<button id="delJqmButton" type="button" class="btn btn-darkgray btn-sm" style="display:none"><i class="fa fa-trash-o"></i> 삭제</button>
							<button id="reseJqmButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-eraser"></i> 초기화</button>
						</div>
					</div>
					<div id="tab2" class="tab" style="display:none">
						<ul class="Tabarea">
							<li class="link-tab" style="cursor:pointer">신규상품요청</li>
							<li class="on">신규상품요청 이력</li>
						</ul>
						<div style="position:absolute; right:0; margin-top:-30px;">
							<a href="#" onclick="fnSetList(1);">
								<img src="/img/contents/btn_tablesearch.gif" />
							</a>
						</div>
						<form id="frmS">
							<input name="srcInsertUserId" type="hidden" value="${sessionScope.sessionUserInfoDto.userId}" />
							<input name="sord" type="hidden" value="desc" />
							<input name="sidx" type="hidden" value="newgoodid" />
							<table class="InputTable">
								<colgroup>
									<col width="120px" />
									<col width="auto" />
									<col width="120px" />
									<col width="auto" />
								</colgroup>
								<tr>
									<th>고객사</th>
									<td>
										<input type="text" style="width:300px;" value="${sessionScope.sessionUserInfoDto.borgNms}" readonly="readonly" disabled />
									</td>
									<th>요청일</th>
									<td>
										<input id="srcInsert_FromDt" name="srcInsert_FromDt" type="text" style="width:80px;" value="<%=srcInsert_FromDt%>" readonly="readonly" />
										~
										<input id="srcInsert_EndDt" name="srcInsert_EndDt" type="text" style="width:80px;" value="<%=srcInsert_EndDt%>" readonly="readonly" />
									</td>
								</tr>
								<tr>
									<th>상품명</th>
									<td>
										<input name="srcStand_good_name" type="text" style="width:300px;" />
									</td>
									<th>진행상태</th>
									<td>
										<select id="srcState" name="srcState" style="width:100px;" >
											<option value="">전체</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>상품규격</th>
									<td>
										<input name="srcStand_good_spec_desc" type="text" style="width:300px;" value="" />
									</td>
									<th>제안자</th>
									<td>
										<input type="text" style="width:80px;" value="${sessionScope.sessionUserInfoDto.userNm}" readonly="readonly" />
										<span class="mgl_10" style="display: none;">
											<label><input name="srcRequestType" type="radio" value="0" checked />상품등록</label>
											<label><input name="srcRequestType" type="radio" value="1"/>상품제안</label>
										</span>
									</td>
								</tr>
							</table>
						</form>
						<div class="ListTable mgt_20">
							<table id="list">
								<colgroup>
									<col width="70px" />
									<col width="auto" />
									<col width="100px" />
									<col width="80px" />
									<col width="170px" />
									<col width="100px" />
								</colgroup>
								<tr>
									<th class="br_l0">요청번호</th>
									<th>신규상품명</th>
									<th>진행상태</th>
									<th>상품유형</th>
									<th>제안 조직</th>
									<th>요청일</th>
								</tr>
							</table>        
							<div id="pager" class="divPageNum"></div>          
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />    
		</div>
        <hr/>
	</div>
<script type="text/javascript">
/* 코드 UI 초기화 */
function fnInitCode() {
    $.post(
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
        {
        	codeTypeCd : "NEW_PROD_STATE",
        	isUse      : "1" },
        function(arg) {
            var codeList = eval('(' + arg + ')').codeList;
            
            for(var i=0;i<codeList.length;i++) {
                $("#state").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
                $("#srcState").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
            }
        }
    );
}
/* 달력 UI 초기화 */
function fnInitDate() {
    $("#srcInsert_FromDt").datepicker({
        showOn: "button",
        buttonImage: "/img/system/btn_icon_calendar.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
    });
    $("#srcInsert_EndDt").datepicker({
        showOn: "button",
        buttonImage: "/img/system/btn_icon_calendar.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
    });
    $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}
function fnReset() {
	$('#frm')[0].reset();
	$('#frm input[name=request_type][value=0]').attr('checked', true);
    $("#btnAttach1").show();
    $("#btnAttach2").show();
    $("#btnAttach3").show();
    $("#btnAttachDel1").hide();
    $("#btnAttachDel2").hide();
    $("#btnAttachDel3").hide();
    $("#attach_file_name1").text('');
    $("#attach_file_name2").text('');
    $("#attach_file_name3").text('');
    
    $('#regiJqmButton').show();
    $('#modiJqmButton').hide();
    $('#delJqmButton').hide();
}
function fnSave(oper) {
        var requestType = "";
        if($('#frm input[name=request_type][value=0]').attr('checked')) { 
            requestType = "고객사 상품등록"; 
        } else { 
            requestType = "고객사 상품제안"; 
        }
        var msg = "";
        if(oper == 'add') { //등록
            msg = "입력한 "+requestType+" 요청을 등록하시겠습니까?";
        } else if(oper == 'mod') { //수정
            msg = "입력한 "+requestType+" 요청을 수정하시겠습니까?";
        } else if(oper == 'del') { //삭제
            msg = "선택한 "+requestType+" 요청을 삭제하시겠습니까?";
        }
        
        $("input[name=oper]").val(oper);
        
        confirmMessage(msg, fnSaveCallback); // confirm 호출
}

function fnSaveCallback(){
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/setNewProductRequest.sys',
		$('#frm').serialize(),
		function (data) {
			var oper = $("input[name=oper]").val();
			
			if(oper == "add") {
				alert("등록 하였습니다.");
			}
			else {
				var msg = "";
				
				if(oper == "mod") {
					msg = "수정 하였습니다.";
				}
				else if(oper == "del"){
					msg = "삭제 하였습니다.";
				}
				
            	alert(msg);
			}
			
			fnSetList(1);
			fnReset();
			
			$('.tab').toggle();
    	}
	);
}

$(function() {
    $.ajaxSetup ({cache: false});
    /* 신규상품요청 관련 */
    fnInitCode();
    $('#regiJqmButton').click(function () {
        if (!$("#frm").validate()) {
            return;
        }
        fnSave('add');
    });
    $('#modiJqmButton').click(function () {
        fnSave('mod');
    });
    $('#delJqmButton').click(function () {
    	fnSave('del');
    });
    $('#reseJqmButton').click(function () {
    	fnReset();
    });
    /* 신규상품목록조회 관련 */
    $('#frmS').search(function () {
        fnSetList(1);
    });
    fnInitDate();
    $('.link-tab').click(function () {
        $('.tab').toggle();
    });
    fnSetList(1);
});
</script>
<script type="text/javascript">
<%-- 신규상품 리스트--%>
var listDetail;
function fnSetList(page){
    $.blockUI();
    $(".trData").remove();
    $("#pager").empty();
    listDetail = "";
    var page        = page;
    var rows        = 8;
    $.post(
        "/product/newProductRequestListJQGrid.sys", $('#frmS').serialize()+'&page='+page+'&rows='+rows,
        function(arg){
            var list        = arg.list;
            listDetail      = arg.list;
            var currPage    = arg.page;
            var rows        = arg.rows;
            var total       = arg.total;
            var records     = arg.records;
            var pageGrp     = Math.ceil(currPage/5);
            var startPage   = (pageGrp-1)*5+1;
            var endPage     = (pageGrp-1)*5+5;
            if(Number(endPage) > Number(total)){
                endPage = total;
            }
            if(records > 0){
                var str = "";
                var data = "";
                for(var i=0; i<list.length; i++){
                    data = list[i]; 
                    str +='<tr class="trData">';
                    str +='  <td align="center" class="br_l0"><a href="#" onclick="fnListDetail('+i+');">'+ fnNullToSpace( data.newgoodid )+'</a></td>';
                    str +='  <td>';
                    str +='    <p class="col01">'+ fnNullToSpace( data.stand_good_name )+'</p>';
                    str +='    <p><strong>상품규격</strong> : '+ fnNullToSpace( data.stand_good_spec_desc )+' </p>';
                    if (data.good_iden_numb) {
                        str +='    <p><strong>상품코드</strong> : '+ fnNullToSpace( data.good_iden_numb )+' </p>';
                    }
                    str +='  <td align="center">'+ fnNullToSpace( data.stateNm )+'</td>';
                    str +='  <td align="center">'+ (data.request_type == '0' ? '상품등록':'상품제안') +'</td>';
                    str +='  <td align="center"><p>'+ fnNullToSpace( data.borgNms )+'</p>';
                    str +='    <p>('+ fnNullToSpace( data.userId )+')</p></td>';
                    str +='  <td align="center">'+ fnNullToSpace( data.insert_date )+'</td>';
                    str +='</tr>';
                }
                $("#list").append(str);
                
                fnPager(startPage, endPage, currPage, total, "fnSetList");
            } else {
                str += " <tr class='trData' id='trData_0'>                                                                                                                                            ";
                str += "   <td class='br_l0' colspan='6' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                          ";
                str += " </tr>                                                                                                                                                         ";
                $("#list").append(str);
            }
            $.unblockUI();
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
    for (var k in listDetail[i]) {
        $('#frm [name=' + k + ']:not([type=radio])').val(listDetail[i][k]);
    }
    $('#frm #state').val(listDetail[i].state);
    
    $('#frm input[name=request_type][value='+listDetail[i].request_type+']').attr('checked', true);
    if (listDetail[i].firstattachseq) {
        $("#attach_file_name1").text(listDetail[i].firstAttachName);
        $("#btnAttachDel1").show();
    } else {
        $("#attach_file_name1").text('');
    	$("#btnAttachDel1").hide();
    }
    if (listDetail[i].secondattachseq) {
        $("#attach_file_name2").text(listDetail[i].secondAttachName);
        $("#btnAttachDel2").show();
    } else {
        $("#attach_file_name2").text('');
        $("#btnAttachDel2").hide();
    }
    if (listDetail[i].thirdattachseq) {
        $("#attach_file_name3").text(listDetail[i].thirdAttachName);
        $("#btnAttachDel3").show();
    } else {
        $("#attach_file_name3").text('');
        $("#btnAttachDel3").hide();
    }
    
    $('#regiJqmButton').hide();
    if (listDetail[i].state == '10') {
        $('#modiJqmButton').show();
        $('#delJqmButton').show();
    } else {
        $('#modiJqmButton').hide();
        $('#delJqmButton').hide();
        $('.btnFile').hide();
    }
    $('.tab').toggle();
}
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
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
    $(document).ready(function() {
        $("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#firstattachseq").val(), "fnCallBackAttach1"); });
        $("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#secondattachseq").val(), "fnCallBackAttach2"); });
        $("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#thirdattachseq").val(), "fnCallBackAttach3"); });
    });
    
    /**
     * 첨부파일1 파일관리
     */
    function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
        $("#firstattachseq").val(rtn_attach_seq);
        $("#attach_file_name1").text(rtn_attach_file_name);
        $("#attach_file_path1").val(rtn_attach_file_path);
        $('#btnAttachDel1').show();
    }
    
    /**
     * 첨부파일2 파일관리
     */
    function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
        $("#secondattachseq").val(rtn_attach_seq);
        $("#attach_file_name2").text(rtn_attach_file_name);
        $("#attach_file_path2").val(rtn_attach_file_path);
        $('#btnAttachDel2').show();
    }
    
    /**
     * 첨부파일3 파일관리
     */
    function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
        $("#thirdattachseq").val(rtn_attach_seq);
        $("#attach_file_name3").text(rtn_attach_file_name);
        $("#attach_file_path3").val(rtn_attach_file_path);
        $('#btnAttachDel3').show();
    }
    
    /**
     * 파일다운로드
     */
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
    
    /**
     * 파일삭제
     */
    function fnAttachDel(columnName) {
        if(!confirm("첨부파일을 삭제하시겠습니까?")) return;
        if(columnName=='firstattachseq') {
            $("#firstattachseq").val('');
            $("#attach_file_name1").text('');
            $("#attach_file_path1").val('');
            $("#btnAttachDel1").hide();
        } else if(columnName=='secondattachseq') {
            $("#secondattachseq").val('');
            $("#attach_file_name2").text('');
            $("#attach_file_path2").val('');
            $("#btnAttachDel2").hide();
        } else if(columnName=='thirdattachseq') {
            $("#thirdattachseq").val('');
            $("#attach_file_name3").text('');
            $("#attach_file_path3").val('');
            $("#btnAttachDel3").hide();
        }
    }
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>
</body>
</html>