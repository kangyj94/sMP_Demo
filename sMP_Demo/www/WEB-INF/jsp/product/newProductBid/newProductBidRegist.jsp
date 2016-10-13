<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "150";
// 	String listWidth = "$(window).width()-55 + Number(gridWidthResizePlus)";
	String listWidth = "950";
	
	String deliAreaCdArrayString = "";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");           //사용자 권한
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME); //사용자 정보
	
	String bidenddateday = CommonUtils.getCustomDay("DAY", 7);// 날짜 세팅
	String newgoodid = ( (String)request.getAttribute("newgoodid") == null ) ? "" : (String)request.getAttribute("newgoodid");// 고객사상품등록요청 ID
	
	String bidStartdateday = CommonUtils.getCustomDay("DAY", 0);//입찰시작날짜 세팅
	
	@SuppressWarnings("unchecked")	//권역코드 리스트
	List<CodesDto> deliAreaCodeList = (List<CodesDto>)request.getAttribute("deliAreaCodeList");
	for(CodesDto codesDto : deliAreaCodeList) {
		if("".equals(deliAreaCdArrayString)) deliAreaCdArrayString = codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
		else deliAreaCdArrayString +=  ";" + codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	// Object Event
	$("#regButton").click(function() { addRow(); });
	$("#delButton").click(function() { delRow(); });
	$("#saveButton").click(function() { saveRow(); });
	
	// 코드값 조회
	fnInitCodeData();
	
	// Component Data Bind 
	function fnInitCodeData() {
		$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
			{codeTypeCd:"BIDSTATE", isUse:"1"},
			function(arg){
				var codeList = eval('(' + arg + ')').codeList;
				for(var i=0;i<codeList.length;i++) {
					$("#bidstate").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
				}
				
				$("#bidenddateday").datepicker( {
					showOn: "button",
					buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
					buttonImageOnly: true,
					dateFormat: "yy-mm-dd"
				});
				$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;");
				for(var i=0;i<24;i++) {
					var strTime = '';
					if(i<10) { strTime = "0"+i; } else { strTime = i; }
					$("#bidenddatetime").append("<option value='"+strTime+"'>"+strTime+"</option>");
				}
				for(var j=0;j<60;j+=10) {
					var strMin = '';
					if(j<10) { strMin = "0"+j; } else { strMin = j; }
					$("#bidenddatemin").append("<option value='"+strMin+"'>"+strMin+"</option>");
				}
				
				//입찰생성일 날짜 세팅
				$("#bidStartdateday").datepicker( {
					showOn: "button",
					buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
					buttonImageOnly: true,
					dateFormat: "yy-mm-dd"
				});
				$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;");
				for(var i=0;i<24;i++) {
					var strTime = '';
					if(i<10) { strTime = "0"+i; } else { strTime = i; }
					$("#bidStartdatetime").append("<option value='"+strTime+"'>"+strTime+"</option>");
				}
				for(var j=0;j<60;j+=10) {
					var strMin = '';
					if(j<10) { strMin = "0"+j; } else { strMin = j; }
					$("#bidStartdatemin").append("<option value='"+strMin+"'>"+strMin+"</option>");
				}
				
				// 화면 초기화
				fnInitComponent();
			}
		);
	}
	
	// 화면 component 상태 초기화
	function fnInitComponent() {
		$("#bidstate option").each(function () {
			if($(this).text()!='입찰진행중')	{
 				$(this).remove();
			}
		});
 		$('#bidstate').attr("disabled",true);
		
// 		입찰생성일자
// 		var d = new Date();
// 		var s = leadingZeros(d.getFullYear(), 4) + '-' + leadingZeros(d.getMonth() + 1, 2) + '-' + leadingZeros(d.getDate(), 2) ;
// 		$('#insert_date').val(s);
		
		//bidStartdatemin
		//입찰생성일자
		$("#bidStartdateday").val("<%=bidStartdateday%>");
		$("#bidStartdatetime").val("00");
		$("#bidStartdatemin").val('00');
		$("#bidStartdatemin").hide();
		
		//입찰종료일자
		$("#bidenddateday").val("<%=bidenddateday%>");
		$("#bidenddatetime").val('18');
		$("#bidenddatemin").val('00');
		$("#bidenddatemin").hide();
		
		if('<%=newgoodid%>' == '') {
			// 고객사상품등록요청이 있는 경우
			$('#btnAttachDel1').hide();
			$('#btnAttachDel2').hide();
			$('#btnAttachDel3').hide();
		} else {
			// 고객사상품등록요청이 없는 경우
			fnGetDetailData();
		}
	}
	
	function fnGetDetailData() {
		// 상태값 조회
		$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/newProductRequestDetailDataInit.sys',
			{newgoodid:'<%=newgoodid%>'},
			function(arg) {
				var detailInfo = eval('(' + arg + ')').detailInfo;
 				$('#newgoodid').val(detailInfo.newgoodid);
 				$('#stand_good_name').val(detailInfo.stand_good_name);
 				$('#stand_good_spec_desc').val(detailInfo.stand_good_spec_desc);
 				$('#bidnote').val(detailInfo.note);
				$('#firstattachseq').val(detailInfo.firstattachseq);
				$('#attach_file_path1').val(detailInfo.firstAttachPath);
				$('#attach_file_name1').html(detailInfo.firstAttachName);
				$('#secondattachseq').val(detailInfo.secondattachseq);
				$('#attach_file_path2').val(detailInfo.secondAttachPath);
				$('#attach_file_name2').html(detailInfo.secondAttachName);
				$('#thirdattachseq').val(detailInfo.thirdattachseq);
				$('#attach_file_path3').val(detailInfo.thirdAttachPath);
				$('#attach_file_name3').html(detailInfo.thirdAttachName);
				
				fnInitComponentForUpd();
			}
		);
	}
	
	// 수정일때 스크립트 실행123
	function fnInitComponentForUpd() {
		if($('#firstattachseq').val() == '') { $('#btnAttachDel1').hide(); }
		if($('#secondattachseq').val() == '') { $('#btnAttachDel2').hide(); }
		if($('#thirdattachseq').val() == '') { $('#btnAttachDel3').hide(); }
	}
	
	//구분 코드리스트
	bidClassifyCodeList();
});
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['공급업체명','공급사코드','권역','대표자','연락처','공급사ID'],
		colModel:[
			{name:'VENDORNM',index:'VENDORNM',width:400,align:'left',search:false,sortable:true,editable:false },//공급사명
			{name:'VENDORCD',index:'VENDORCD',width:100,align:'center',search:false,sortable:true,editable:false,hidden:true },//공급사코드
			{name:'AREATYPE',index:'AREATYPE',width:60,align:'center',search:false,sortable:true
				,editable:false,formatter:"select",editoptions:{value:"<%=deliAreaCdArrayString %>"}
			},//권역
			{name:'PRESSENTNM',index:'PRESSENTNM',width:100,align:'center',search:false,sortable:true,editable:false },//대표자
			{name:'PHONENUM',index:'PHONENUM',width:120,align:'center',search:false,sortable:true,editable:false },//담당자연락처
			
			{name:'VENDORID',index:'VENDORID',align:'center',search:false,sortable:false,hidden:true,key:true }//공급사ID
		],
		postData: {},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:<%=listHeight%>,width:980,
		sortname:'',sortorder:'', 
		viewrecords:true,emptyrecords:'Empty records',loadonce: false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {},
		onSelectRow:function(rowid,iRow,iCol,e) {},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {},
		afterInsertRow: function(rowid, aData){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {PHONENUM: fnSetTelformat(selrowContent.PHONENUM)});
		},
		loadError:function(xhr,st,str) { $('#list').html(xhr.responseText); },
		jsonReader: {root:'list',page:'page',total:'total',records:'records',repeatitems:false,cell:'cell'}
	});
	
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function addRow() {
	fnVendorDialog("", "fnCallBackVendor");
}
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	var isExists = false;
	var rowCnt = jq("#list").getGridParam('reccount');
	for(var idx=0; idx<rowCnt; idx++) {
		var rowid = $("#list").getDataIDs()[idx];
		var selrowContent = jq("#list").jqGrid('getRowData',rowid);
		if(selrowContent.VENDORID == vendorId) {
			isExists= true;
			break; 
		}
	}
	if(isExists) {
		alert("이미 등록된 공급사 입니다.\n다른 공급사를 선택하십시오.");
		return;
	}
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/product/vendorDetail.sys"
		, { srcVendorId:vendorId }
		, function(arg) {
			var detailInfo = eval('(' + arg + ')').detailInfo;
			var vendorCd = detailInfo.vendorCd;
			var areaType = detailInfo.areaType;
			var pressentNm = detailInfo.pressentNm;
			var phoneNum = detailInfo.phoneNum;
			
			jq("#list").addRowData(
				$("#list").jqGrid('getGridParam','records'),
				{ VENDORNM:vendorNm,VENDORCD:vendorCd,AREATYPE:areaType,PRESSENTNM:pressentNm,PHONENUM:fnSetTelformat(phoneNum),VENDORID:vendorId }
			);
	});
}

function delRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if(row != null) {
		if(!confirm("선택한 정보을 삭제 하시겠습니까?")) return;
		jq("#list").jqGrid('delRowData',row);
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function saveRow() {
	var bidname = $('#bidname');
	var bidstate = $('#bidstate');
	var stand_good_name = $('#stand_good_name');
	var stand_good_spec_desc = $('#stand_good_spec_desc');
	var is_use_certificate = $('#is_use_certificate');
	var hope_sale_price = $('#hope_sale_price');
	var bidnote = $('#bidnote');
	var firstattachseq = $('#firstattachseq'); 
	var secondattachseq = $('#secondattachseq');
	var thirdattachseq = $('#thirdattachseq');
	var insert_date = $('#insert_date');
	var bidenddateday = $('#bidenddateday');
	var bidenddate = $('#bidenddateday').val()+' '+$('#bidenddatetime').val()+':'+$('#bidenddatemin').val()+':'+'00.000';
	var newgoodid = $('#newgoodid');
	var insert_user_id = '<%=loginUserDto.getUserId() %>';
	//입찰생성일자
	var bidStartdate = $('#bidStartdateday').val()+' '+$('#bidStartdatetime').val()+':'+$('#bidStartdatemin').val()+':'+'00.000';
	
	//구분
	var bidClassify = $("#bidClassify").val();
	
	if(bidname.val() == "") {
		alert("입찰명을 입력해 주십시오.");
		bidname.focus();
		return;
	}

	if(stand_good_name.val() == "") {
		alert("대표상품명을 입력해 주십시오.");
		stand_good_name.focus();
		return;
	}
	if(stand_good_spec_desc.val() == "") {
		alert("대표규격을 입력해 주십시오.");
		stand_good_spec_desc.focus();
		return;
	}
// 	if(hope_sale_price.val() == "") {
// 		alert("희망가격을 입력해 주십시오.");
// 		hope_sale_price.focus();
// 		return;
// 	}
	
	var today = new Date();
	var dateString = bidenddateday.val();
	var dateArray = dateString.split("-");
	var dateObj = new Date(dateArray[0], Number(dateArray[1])-1, dateArray[2]);
	var betweenDay = (dateObj.getTime() - today.getTime())/950/60/60/24;
// 	if(betweenDay < 6) {
// 		alert("입찰종료일자는 입찰생성일자보다 7일 크게 입력해 주십시오.");
// 		bidenddateday.focus();
// 		return;
// 	}
	
	var rowCnt = jq("#list").getGridParam("reccount");
	var vendorIdArray = new Array();
	if(rowCnt == 0) {
		alert("공급업체를 선택해 주십시오.");
		return;
	} else {
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			vendorIdArray.push(selrowContent.VENDORID);
		}
	}
// 	var msg = ""; 
// 	for (var cnt=0 ; cnt < vendorIdArray.length ; cnt++ ) {
// 		msg += "\n index ["+cnt+"]  vendorIdArray value ["+vendorIdArray[cnt]+"]"; 
// 	}
// 	alert(msg);

// 	alert("bidname : "+bidname.val());
//  	alert("bidstate : "+bidstate.val());
//  	alert("stand_good_name : "+stand_good_name.val());
//  	alert("stand_good_spec_desc : "+stand_good_spec_desc.val());
//  	alert("is_use_certificate : "+is_use_certificate.val());
//  	alert("hope_sale_price : "+hope_sale_price.val());
//  	alert("bidnote : "+bidnote.val());
//  	alert("firstattachseq : "+firstattachseq.val());
//  	alert("secondattachseq : "+secondattachseq.val());
//  	alert("thirdattachseq : "+thirdattachseq.val());
//  	alert("bidenddate : "+bidenddate);
//  	alert("newgoodid : "+newgoodid.val());
//  	alert("insert_user_id : "+insert_user_id);

	var params = {
			bidname:bidname.val(),
			bidstate:bidstate.val(),
			stand_good_name:stand_good_name.val(),
			stand_good_spec_desc:stand_good_spec_desc.val(),
			is_use_certificate:is_use_certificate.val(),
			hope_sale_price:hope_sale_price.val(),
			bidnote:bidnote.val(),
			firstattachseq:firstattachseq.val(),
			secondattachseq:secondattachseq.val(),
			thirdattachseq:thirdattachseq.val(),
			bidenddate:bidenddate,
			newgoodid:newgoodid.val(),
			insert_user_id:insert_user_id,
			vendorIdArray:vendorIdArray,
			bidStartdate:bidStartdate,
			bidClassify:bidClassify
	};
	
	if(!confirm("입력한 입찰생성정보을 등록하겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/product/bidTrans.sys",
		params,
		function(arg){ 
			if(fnTransResult(arg, false)) {//성공시
				alert('등록 되었습니다.');
				fnSuccessBidProcess();
				window.opener.fnSearch();
			}
		}
	);
}

function fnSuccessBidProcess() {
	if($('#newgoodid').val() == "") {
		fnReset();
	} else {
// 		var moveFlage = "";
// 		if(confirm("입찰조회 화면으로 이동하시겠습니까?")) {
// 			moveFlage = "true";
// 		} else {
// 			moveFlage = "false";
// 		}
// 		try {
// 			window.opener.fnSuccessBidProcess();
// 		} catch(e) {}
// 		window.close();
		var tempName = dialogArguments;
		tempName.fnSuccessBidProcess();
		self.close();
	}
}
function fnReset() {
	$('#bidname').val('');
	$('#stand_good_name').val('');
	$('#newgoodid').val('');
	var d = new Date();
	var s = leadingZeros(d.getFullYear(), 4) + '-' + leadingZeros(d.getMonth() + 1, 2) + '-' + leadingZeros(d.getDate(), 2) ;
	$('#insert_date').val(s);
	$('#stand_good_spec_desc').val('');
	$("#bidenddateday").val("<%=bidenddateday%>");
	$("#bidenddatetime").val('18');
	$("#bidenddatemin").val('00');
	$('#hope_sale_price').val('');
	$('#bidnote').val('');
	$("#firstattachseq").val('');
	$("#attach_file_name1").text('');
	$("#attach_file_path1").val('');
	$('#btnAttachDel1').hide();
	$("#secondattachseq").val('');
	$("#attach_file_name2").text('');
	$("#attach_file_path2").val('');
	$("#btnAttachDel2").hide();
	$("#thirdattachseq").val('');
	$("#attach_file_name3").text('');
	$("#attach_file_path3").val('');
	$("#btnAttachDel3").hide();
	$("#bidClassify").val('');
	$('#list').jqGrid('clearGridData');
}

//사용자 함수
function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();
	if(n.length < digits) {
		for(var i = 0; i < digits - n.length; i++)
			zero += '0';
	}
	return zero + n;
}

// 컨퍼넌트 변화에 따른 Formatting 
var fnSetFormatCurrency =  function(obj) {
	var colNm = $(obj).attr('id');
	var altNm = $(obj).attr('alt');
	var modVal = '';
	for(var formatIdx = 0 ; formatIdx < numFormatType.length ; formatIdx++) {
		if(numFormatType[formatIdx].numType == altNm)
			$(obj).formatCurrency(numFormatType[formatIdx].option);
	}
};
//NumberPormatOption 
var numFormatType = new Array(
	{ numType:'persent',option: { decimalSymbol:'.',digitGroupSymbol:'',dropDecimals:false,groupDigits:true,symbol:'',roundToDecimalPlace:2 } },
	{ numType:'number',option: { decimalSymbol:'.',digitGroupSymbol:',',dropDecimals:false,groupDigits:true,symbol:'',roundToDecimalPlace:0 } }
);
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

<script type="text/javascript">
function bidClassifyCodeList(){
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"BID_CLASSIFY",
			isUse:"1"
		},
		function(arg){
			var list = eval('('+arg+')').list;
			for(var i=0; i<list.length; i++){
				$("#bidClassify").append("<option value='"+list[i].codeVal1+"'>"+list[i].codeNm1+"</option>");
			}
		}
	);
}

</script>


</head>
<%--
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
 --%>
<body style="width: 980px; height: 650px; " >
<table width="980px" style="margin-left: 0px; " align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="white" >
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="980px" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">입찰생성</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="980px" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle"/></td>
				<td class="stitle">대표상품정보</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 컨텐츠 시작 -->
		<table width="980px" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="8" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject9" width="100">입찰명</td>
				<td class="table_td_contents">
					<input id="bidname" name="bidname" type="text" value="" size="" maxlength="30" /></td>
				<td class="table_td_subject9" width="100">입찰상태</td>
				<td class="table_td_contents">
					<select id="bidstate" style="width:120px;" class="select_none"></select>
				</td>
				<td class="table_td_subject" width="100">입찰번호</td>
				<td class="table_td_contents">
					<input id="bidid" name="bidid" type="text" value="" size="" maxlength="30" class="input_text_none" disabled="disabled" /></td>
				<td class="table_td_subject" width="100">구분</td>
				<td class="table_td_contents">
					<select id="bidClassify" name="bidClassify">
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject9">대표상품명</td>
				<td colspan="3" class="table_td_contents">
					<input id="stand_good_name" name="stand_good_name" type="text" value="" size="" maxlength="100" style="width:400px;" />
					<input id="newgoodid" name="newgoodid" type="hidden" value="<%=newgoodid %>" /></td>
				<td class="table_td_subject9">입찰생성일자</td>
				<td class="table_td_contents" colspan="2">
<!-- 					<input id="insert_date" name="insert_date" type="text" value="" size="20" maxlength="30" class="input_text_none" disabled="disabled" /></td> -->
					<input id="bidStartdateday" name="bidStartdateday" type="text" style="width:73px;" />
					<select id="bidStartdatetime" name="bidStartdatetime" class="select" style="vertical-align: middle;"></select>시
					<select id="bidStartdatemin" name="bidStartdatemin" class="select"  style="vertical-align: middle;"></select>
				</td>
			</tr>
			<tr>
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject9">대표규격</td>
				<td colspan="3" class="table_td_contents">
					<input id="stand_good_spec_desc" name="stand_good_spec_desc" type="text" value="" size="" maxlength="100" style="width:400px;" /></td>
				<td class="table_td_subject9">입찰종료일자</td>
				<td class="table_td_contents" colspan="2">
					<input id="bidenddateday" name="bidenddateday" type="text" style="width:73px;" />
					<select id="bidenddatetime" name="bidenddatetime" class="select"  style="vertical-align: middle;"></select>시
					<select id="bidenddatemin" name="bidenddatemin" class="select"  style="vertical-align: middle;"></select>
				</td>
			</tr>
			<tr>
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">투찰시 인증서</td>
				<td colspan="3" class="table_td_contents">
					<select id="is_use_certificate" name="is_use_certificate" style="width:120px;" class="select">
						<option value="0">아니오</option>
						<option value="1">예</option>
					</select></td>
				<td class="table_td_subject">희망가격</td>
				<td class="table_td_contents">
					<input id="hope_sale_price" name="hope_sale_price" type="text" value="" size="" maxlength="30" style="text-align:right;" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" /></td>
			</tr>
			<tr>
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">요청사항</td>
				<td colspan="7" class="table_td_contents4">
					<textarea name="bidnote" id="bidnote" cols="45" rows="10" style="width:98%;height:140px;"></textarea></td>
			</tr>
			<tr>
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject"  valign="middle">
					<button id='btnAttach1' type='button' class="btn btn-default btn-xs"  style="padding-top: 0px;"><i class="fa fa-floppy-o"></i> 첨부파일1</button>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="firstattachseq" name="firstattachseq" value="" />
					<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="" />
					<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
					<span id="attach_file_name1"></span>
					</a>
					<button id='btnAttachDel1' type='button' class="btn btn-darkgray btn-xs" onclick="javascript:fnAttachDel('firstattachseq');" style="padding: 1px;"><i class="fa fa-close" ></i></button>
<!-- 					<a href="javascript:fnAttachDel('firstattachseq');"> -->
<%-- 					<img id="btnAttachDel1" name="btnAttachDel1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border:0px;vertical-align: bottom;" /> --%>
<!-- 					</a> -->
				</td>
				<td class="table_td_subject" valign="middle">
					<button id='btnAttach2' type='button' class="btn btn-default btn-xs" style="padding-top: 0px;"><i class="fa fa-floppy-o"></i> 첨부파일2</button>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="secondattachseq" name="secondattachseq" value="" />
					<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="" />
					<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
					<span id="attach_file_name2"></span>
					</a>
					<button id='btnAttachDel2' type='button' class="btn btn-darkgray btn-xs" onclick="javascript:fnAttachDel('secondattachseq');" style="padding: 1px;"><i class="fa fa-close" ></i></button>
				</td>
				<td class="table_td_subject" valign="middle">
					<button id='btnAttach3' type='button' class="btn btn-default btn-xs" style="padding-top: 0px;"><i class="fa fa-floppy-o"></i> 첨부파일3</button>
				</td>
				<td class="table_td_contents" colspan="3">
					<input type="hidden" id="thirdattachseq" name="thirdattachseq" value="" />
					<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="" />
					<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
					<span id="attach_file_name3"></span>
					</a>
					<button id='btnAttachDel3' type='button' class="btn btn-darkgray btn-xs" onclick="javascript:fnAttachDel('thirdattachseq');"style="padding: 1px;"><i class="fa fa-close" ></i></button>
<!-- 					<a href="javascript:fnAttachDel('thirdattachseq');"> -->
<%-- 					<img id="btnAttachDel3" name="btnAttachDel3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border:0px;vertical-align:bottom;" /> --%>
<!-- 					</a> -->
				</td>
			</tr>
			<tr>
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="8" class="table_top_line"></td>
			</tr>
		</table>
		<!-- 컨텐츠 끝 -->
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">대표상품공급업체정보</td>
				<td height="17px" align="right" valign="bottom">
                    <button id='regButton' type='button' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 추가</button>
                    <button id='delButton' type='button' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-times"></i> 삭제</button>
				</td>
			</tr>
           
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<div id="jqgrid">
			<table id="list"></table>
		</div>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td align="center">
	   <button id='saveButton' type='button' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-floppy-o"></i> 입찰생성</button>
	</td>
</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size:12px;color:red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<!-------------------------------- Dialog Div Start -------------------------------->
<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<!-------------------------------- Dialog Div End -------------------------------->

</body>
</html>