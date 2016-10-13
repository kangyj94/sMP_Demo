<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.system.dao.CodeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>

<%
	String bidstate = CommonUtils.getString((String)request.getAttribute("bidstate"));

	String bidid = ( (String)request.getAttribute("bidid") == null ) ? "" : (String)request.getAttribute("bidid");// 상품입찰 공고 ID
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	//그리드의 width와 Height을 정의
	int listHeight = 140;
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME); //사용자 정보
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	//입찰정보
	bidDetail();
	
	//버튼이벤트
	$("#btnCommonClose").click(function(){ fnThisPageClose(); });
});

</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'/product/newProductBidAuctionListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['공급업체명','공급업체코드','등록일', '매입단가','대표자','연락처','이미지여부','설명여부','상품등록여부','투찰낙찰','상품코드','공급사ID','입찰ID'],
		colModel:[
			{ name:'VENDORNM',index:'VENDORNM',width:160,align:'left',search:false,sortable:true,editable:false },//공급업체명
			{ name:'VENDORCD',index:'VENDORCD',width:80,align:'center',search:false,sortable:true,editable:false },//공급업체코드
			{ name:'bidding_date',index:'bidding_date',width:60,align:'center',search:false,sortable:true,editable:false },//등록일
			{ name:'sale_unit_price',index:'sale_unit_price',width:60,align:'right',search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매입단가
			{ name:'PRESSENTNM',index:'PRESSENTNM',width:60,align:'center',search:false,sortable:true,editable:false },//대표자
			{ name:'PHONENUM',index:'PHONENUM',width:60,align:'center',search:false,sortable:false,editable:false },//연락처
			{ name:'isSetImage',index:'isSetImage',width:60,align:"center",search:false,sortable:false,editable:false },//이미지여부
			{ name:'isSetDesc',index:'isSetDesc',width:50,align:"center",search:false,sortable:false,editable:false },//설명여부
			{ name:'IS_REG_GODD',index:'IS_REG_GODD',width:80,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"1:등록;0:미등록"}
			},//상품등록여부456
			{ name:'vendorbidstate',index:'vendorbidstate',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"10:미투찰;15:투찰;50:낙찰"}
			},//투찰낙찰상태
			{ name:'good_iden_numb',index:'good_iden_numb',width:60,align:'left',search:false,sortable:true,editable:false },//상품코드
			
			{ name:'vendorid',index:'vendorid',align:'center',search:false,sortable:false,hidden:true },//공급사ID
			{ name:'bidid',index:'bidid',align:'center',search:false,sortable:false,hidden:true }//입찰ID
		],
		postData: {
			bidid:'<%=bidid%>'
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:'<%=listHeight%>',width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname:'bidding_date',sortorder:'asc',
		caption:'공급업체 투찰 정보',
		viewrecords:true,emptyrecords:'Empty records',loadonce: false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			var top_rowid = $("#list").getDataIDs()[0];
			$("#list").setSelection(top_rowid);
		},
		onSelectRow:function(rowid,iRow,iCol,e) {
// 			var row = jq("#list").jqGrid('getGridParam','selrow');
// 			var selrowContent = jq("#list").jqGrid('getRowData',row);
// 			var bidid = selrowContent.bidid;
// 			var vendorid = selrowContent.vendorid;
// 			if(row != null) {
// 				fnGetDetailDataBidAuction(bidid,vendorid);
// 			}
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {},
		loadError:function(xhr,st,str) { $('#list').html(xhr.responseText); },
		jsonReader: { root:'list',page:'page',total:'total',records:'records',repeatitems:false,cell:'cell' }
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

function bidDetail(){
	//상품입찰공고 상태값 조회
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/newProductBidDetailDataInit.sys',
		{bidid:'<%=bidid%>'},
		function(arg) {
			var detailInfo = eval('(' + arg + ')').detailInfo;
			$('#bidid').val(detailInfo.bidid);
			$('#bidname').val(detailInfo.bidname);
			$('#bidstate').val(detailInfo.bidstate);
			$('#stand_good_name').val(detailInfo.stand_good_name);
			$('#insert_date').val((detailInfo.insert_date).substring(0,10));
			$('#insert_date_time').val((detailInfo.insert_date).substring(11,13));
			$('#insert_date_min').val((detailInfo.insert_date).substring(14,16));
			$('#stand_good_spec_desc').val(detailInfo.stand_good_spec_desc);
			$('#bidenddateday').val((detailInfo.bidenddate).substring(0,10));
			$('#bidenddatetime').val((detailInfo.bidenddate).substring(11,13));
			$('#bidenddatemin').val((detailInfo.bidenddate).substring(14,16));
			$('#is_use_certificate').val(detailInfo.is_use_certificate);
			$('#hope_sale_price').val(Number(detailInfo.hope_sale_price));
			$('#bidnote').val(detailInfo.bidnote);
			$('#firstattachseqBid').val(detailInfo.FIRSTATTACHSEQ);
			$('#attach_file_path1Bid').val(detailInfo.firstAttachPath);
			$('#attach_file_name1Bid').html(detailInfo.firstAttachName);
			$('#secondattachseqBid').val(detailInfo.SECONDATTACHSEQ);
			$('#attach_file_path2Bid').val(detailInfo.secondAttachPath);
			$('#attach_file_name2Bid').html(detailInfo.secondAttachName);
			$('#thirdattachseqBid').val(detailInfo.THIRDATTACHSEQ);
			$('#attach_file_path3Bid').val(detailInfo.thirdAttachPath);
			$('#attach_file_name3Bid').html(detailInfo.thirdAttachName);
			$('#newgoodid').val(detailInfo.newgoodid);
			//구분 코드리스트
			if(detailInfo.bid_classify != ''){
				$.post(
					"/common/etc/selectCodeList/list.sys",
					{
						codeTypeCd:"bid_classify",
						isUse:"1"
					},
					function(arg){
						var list = eval('('+arg+')').list;
						for(var i=0; i<list.length; i++){
							$("#bidClassify").append("<option value='"+list[i].codeVal1+"'>"+list[i].codeNm1+"</option>");
						}
						$("#bidClassify").val(detailInfo.bid_classify);
					}
				);
			}
			fnInitComponentForUpd();
		}
	);
}

function fnInitComponentForUpd() {
	$('#bidstate').attr("disabled",true);
	$('#bidenddateday').attr("disabled",true);
	$('#bidenddatetime').attr("disabled",true);
	$('#bidenddatemin').attr("disabled",true);
	$('#is_use_certificate').attr("disabled",true);
	$('#bidstate').attr("class","select_none");
	$('#bidenddateday').attr("class","input_text_none");
	$('#bidenddatetime').attr("class","select_none");
	$('#bidenddatemin').attr("class","select_none");
	$('#is_use_certificate').attr("class","select_none");
	
	$('#insert_date_time').attr("disabled",true);
	$('#insert_date_time').attr("class","select_none");
	$('#insert_date_min').attr("disabled",true);
	$('#insert_date_min').attr("class","select_none");
	$('#bidClassify').attr("disabled",true);
	$('#bidClassify').attr("class","select_none");
	//상품입찰공급사정보 화면 초기화
//		fnInitComponentBidAuction();
}

function fnGetDetailDataBidAuction(bidid,vendorid) {
	// 상품입찰공급사정보 상태값 조회
	$.post(
		'/product/newProductBidAuctionDetailDataInit.sys',
		{
			bidid:bidid,
			vendorid:vendorid
		},
		function(arg) {
			var detailInfo = eval('(' + arg + ')').detailInfo;
// 			$('#bidname').val(detailInfo.bidname);										//입찰명
// 			$('#bidstate').val(detailInfo.bidstate);									//입찰상태
// 			$('#bidid').val(detailInfo.bidid);											//입찰번호
// 			$('#stand_good_name').val(detailInfo.stand_good_name);						//대표상품명
// 			alert(detailInfo.stand_good_name);
// 			$('#insert_date').val((detailInfo.insert_date).substring(0,10));			//입찰시작일자
// 			$('#insert_date_time').val((detailInfo.insert_date).substring(11,13));		//입찰시작일자
// 			$('#insert_date_min').val((detailInfo.insert_date).substring(14,16));		//입찰시작일자
// 			alert(2222)
// 			$('#stand_good_spec_desc').val(detailInfo.stand_good_spec_desc);			//대표규격
// 			$('#bidenddateday').val((detailInfo.bidenddate).substring(0,10));			//입찰종료일자
// 			$('#bidenddatetime').val((detailInfo.bidenddate).substring(11,13));			//입찰종료일자
// 			$('#bidenddatemin').val((detailInfo.bidenddate).substring(14,16));			//입찰종료일자
// 			$('#is_use_certificate').val(detailInfo.is_use_certificate);				//투찰시 인증서
		}
	);
}



/**
 * 해당 Page 닫기
 */
function fnThisPageClose() {
	this.close();
};
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
		var url = "<%=Constances.SYSTEM_CONTEXT_PATH%>/common/attachFileDownload.sys";
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
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>

</head>

<body>
<div style="position:absolute;top:0;left:20;width:1000;height:550px;overflow:auto;">
<form id="frm" name="frm" method="post">
<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">입찰조회</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">대표상품정보</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 컨텐츠 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="60">입찰명</td>
				<td class="table_td_contents">
					<input id="bidname" name="bidname" type="text" value="" size="" maxlength="30" style="width:90%;" class="input_text_none" disabled="disabled" /></td>
				<td class="table_td_subject" width="60">입찰상태</td>
				<td class="table_td_contents">
					<select id="bidstate" name="bidstate" class="select" style="width:90%;">
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> bidStateCd = (List<CodesDto>)request.getAttribute("bidStateCd");

	if(bidStateCd != null && bidStateCd.size() > 0){
		for(CodesDto dto : bidStateCd){
%>
						<option value="<%=dto.getCodeVal1()%>"><%=dto.getCodeNm1()%></option>
<%		
		}
	}
%>
					</select>
				</td>
				<td class="table_td_subject" width="60">입찰번호</td>
				<td class="table_td_contents">
					<input id="bidid" name="bidid" type="text" value="" size="" maxlength="30" style="width:90%;" class="input_text_none" disabled="disabled" />
					<input id="newgoodid" name="newgoodid" type="hidden" value=""/></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">대표상품명</td>
				<td colspan="3" class="table_td_contents">
					<input id="stand_good_name" name="stand_good_name" type="text" value="" size="" maxlength="100" style="width:95%;" class="input_text_none" disabled="disabled" /></td>
				<td class="table_td_subject">입찰시작일자</td>
				<td class="table_td_contents">
					<input id="insert_date" name="insert_date" type="text" style="width:65px;" class="input_text_none" disabled="disabled" />
					<select id="insert_date_time" name="insert_date_time" class="select">
<%	for(int i = 0 ; i < 24 ; i++){
		String strTime = "";
		if(i < 10)	strTime = "0" + i;
		else		strTime = "" + i;
%>
						<option value="<%=strTime%>"><%=strTime%></option>
<%
	}	
%>	
					</select>시
					<select id="insert_date_min" name="insert_date_min" class="select">
<%	for(int i = 0 ; i < 60 ; i+=10){
		String strMin = "";
		if(i < 10)	strMin = "0" + i;
		else		strMin = "" + i;
%>
						<option value="<%=strMin%>"><%=strMin%></option>
<%
	}	
%>										
					</select>분
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">대표규격</td>
				<td colspan="3" class="table_td_contents">
					<input id="stand_good_spec_desc" name="stand_good_spec_desc" type="text" value="" size="" maxlength="100" style="width:95%;" class="input_text_none" disabled="disabled" /></td>
				<td class="table_td_subject">입찰종료일자</td>
				<td class="table_td_contents">
					<input id="bidenddateday" name="bidenddateday" type="text" style="width:65px;" class="input_text_none" disabled="disabled" />
					<select id="bidenddatetime" name="bidenddatetime" class="select">
<%	for(int i = 0 ; i < 24 ; i++){
		String strTime = "";
		if(i < 10)	strTime = "0" + i;
		else		strTime = "" + i;
%>
						<option value="<%=strTime%>"><%=strTime%></option>
<%
	}	
%>					
					</select>시
					<select id="bidenddatemin" name="bidenddatemin" class="select">
<%	for(int i = 0 ; i < 60 ; i+=10){
		String strMin = "";
		if(i < 10)	strMin = "0" + i;
		else		strMin = "" + i;
%>
						<option value="<%=strMin%>"><%=strMin%></option>
<%
	}	
%>										
					</select>분
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">투찰시 인증서</td>
				<td class="table_td_contents">
					<select id="is_use_certificate" name="is_use_certificate" style="width:120px;" class="select">
						<option value="0">아니오</option>
						<option value="1">예</option>
					</select></td>
				<td class="table_td_subject">희망가격</td>
				<td class="table_td_contents">
					<input id="hope_sale_price" name="hope_sale_price" type="text" value="" size="" maxlength="30" style="text-align:right;" class="input_text_none" disabled="disabled" /></td>
				<td class="table_td_subject">구분</td>
				<td class="table_td_contents">
					<select id="bidClassify" name="bidClassify">
						<option value="">전체</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">요청사항</td>
				<td colspan="5" class="table_td_contents4">
					<textarea name="bidnote" id="bidnote" cols="45" rows="10" style="width:730px;height:50px;" class="input_text_none" disabled="disabled"></textarea></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" style="white-space:nowrap;">
					<table>
						<tr>
							<td>첨부파일1</td>
						</tr>
					</table>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="firstattachseqBid" name="firstattachseqBid" value=""/>
					<input type="hidden" id="attach_file_path1Bid" name="attach_file_path1Bid" value=""/>
					<a href="javascript:fnAttachFileDownload($('#attach_file_path1Bid').val());">
					<span id="attach_file_name1Bid"></span>
					</a>
				</td>
				<td class="table_td_subject" style="white-space:nowrap;">
					<table>
						<tr>
							<td>첨부파일2</td>
						</tr>
					</table>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="secondattachseqBid" name="secondattachseqBid" value="" />
					<input type="hidden" id="attach_file_path2Bid" name="attach_file_path2Bid" value="" />
					<a href="javascript:fnAttachFileDownload($('#attach_file_path2Bid').val());">
					<span id="attach_file_name2Bid"></span>
					</a>
				</td>
				<td class="table_td_subject" style="white-space:nowrap;">
					<table>
						<tr>
							<td>첨부파일3</td>
						</tr>
					</table>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="thirdattachseqBid" name="thirdattachseq" value="" />
					<input type="hidden" id="attach_file_path3Bid" name="attach_file_path3Bid" value="" />
					<a href="javascript:fnAttachFileDownload($('#attach_file_path3Bid').val());">
					<span id="attach_file_name3Bid"></span>
					</a>
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="6" class="table_top_line"></td>
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
				<td width="20" valign="top" >
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">공급업체 투찰 정보</td>
				<td align="right" class="ptitle">
					<img id="sucButton" src="/img/system/btn_type3_bidSuccess.gif" width="116" height="22" style="cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>" /></td>
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
		&nbsp;&nbsp;<img id='btnCommonClose' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style="width:65px;height:23px;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</div>
</body>
</html>