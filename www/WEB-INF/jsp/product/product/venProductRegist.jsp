<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto) (request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	
	//parameter
	String req_good_id = request.getAttribute("req_good_id") == null ? "": (String) request.getAttribute("req_good_id");
	String vendorid = request.getAttribute("vendorid") == null ? userInfoDto.getBorgId() : (String) request.getAttribute("vendorid");
	String svcType = userInfoDto.getSvcTypeCd();
	
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
	int listHeight = 30;
	boolean isVendor = "VEN".equals(userInfoDto.getSvcTypeCd()) ? true : false;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Default.css">
<style type="text/css">
.jqmWindow {
	display: none;
	position: absolute;
	top: 5%;
	left: 3%;
	width: 850px;
	background-color: #EEE;
	color: #333;
	z-index: 1003;
}
.jqmOverlay { background-color: #000; }
</style>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<!-- 버튼 이벤트 스크립트 시작 -->
<script type="text/javascript">
    var oEditors = [];
	jQuery.fn.exists = function() { return ($(this).length > 0); };
	var jq = jQuery;
	var reqParamObj = new Object();
	var defObj = new jQuery.Deferred();
	$(document).on("blur", "input:text[requirednumber]", function() {
		$(this).number(true);
	});
	
	$(document).ready(function() {
		$('#productPop').jqm();//초기화
        nhn.husky.EZCreator.createInIFrame({
             oAppRef: oEditors,
             elPlaceHolder: "tx_load_content",
             sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
        });
		// component Event
		$('#btnVenSave').click(     function() { fnReqProdTranSaction('trans');  });
		$('#btnVenDelete').click(   function() { fnReqProdTranSaction('del');    });
		$('#btnAdmAppOk').click(    function() { fnAppReqGoodTran('appOk');      });
		$('#btnAdmAppCancel').click(function() { fnAppReqGoodTran('appCancel');});
		$('#btnCommonClose').click( function() { fnThisPageClose();              });
		$('#btnReset').click(       function() { fnReset();                      });
		$('#btnProdSearch').click(  function() { fnOpenProdSearchPopForAdmin();  });
		$('#btnProdManage').click(  function() { fnProductDetail();              });
		
		// Image Process Event
		$('#btnAttachDel').click( function() { attachDel(); });
		
		//Component Property
		$('#SMALL').error( function() { $(this).attr("src", '<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif'); });
		$('#MEDIUM').error(function() { $(this).attr("src", '<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_70.gif'); });
		$('#LARGE').error( function() { $(this).attr("src", '<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_100.gif'); });
		$('#SMALL').wrap("<a href='javascript:funPopBigImage();'>");
		$('#MEDIUM').wrap("<a href='javascript:funPopBigImage();'>");
		$('#LARGE').wrap("<a href='javascript:funPopBigImage();'>");
		// Edit Setting
//      Editor.getCanvas().setCanvasSize({height:250});  //daum editor height 지정
//      Editor.getCanvas().observeJob(Trex.Ev.__CANVAS_PANEL_KEYUP, function(e) {
//          fnSetProductDescContents('reqProduct',Editor.getContent());
//      });
		fnInitComponents();
		
		// Deferred() 를 이용하여 동기식 처리 방식으로 변환한다.
		
		reqParamObj = fnSetRequestParmas(defObj);
//         defObj.notify('initComponentDone');
        
        // 동기식 처리
//         defObj.progress(
//             function(insMod) {
// 				if(insMod =='initComponentDone') {
//                     defObj.resolve();
//                 }
//             }
//         ).done(function() {
            
		$(window).bind('resize', function() {
			$("#reqProduct").setGridWidth(<%=listWidth %>);
		}).trigger('resize');
//         });
		
	});
    
    /**
      * 넘오온 파라미터 정보를 설정한다.
      */
	var fnSetRequestParmas = function(defObj ) {
		var rtnObj = new Object();
		rtnObj['req_good_id']='<%=req_good_id%>';
		rtnObj['vendorid']='<%=vendorid%>';
		rtnObj['svcType']='<%=svcType%>';
		return rtnObj;
	};
	
    /**
      * 데이터를 바인드하여 처리한수 선택 한다.
      * @param defObj([동기방식 처리시 활용 ])  jQuery.Deferred()
      */
	var fnReqProductListComplete = function (defObj,reqParamObj) {
		var rowid = $("#reqProduct").getDataIDs()[0];
		//fnCopyOrgRowData('reqProduct',rowid, 'org_');
		if(jq("#reqProduct").getGridParam('reccount') > 0) {
			$("#reqProduct").setSelection(rowid);
			defObj.notify('getReqProductListDone');
		} else if(jq("#reqProduct").getGridParam('reccount') == 0) {
			// 공급사 정보를 조회한다.
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/product/vendorDetail.sys", 
				{
					srcVendorId:reqParamObj['vendorid']
				}, 
				function(arg) {
					var detailInfo = eval('(' + arg + ')').detailInfo;
					// Dto 변수 명이 달라 바인드 안됨. 이에 따른 처리
					var bindDataInfo = new Object();
					for (var propNm in detailInfo) {
						bindDataInfo[propNm.toLowerCase()] = detailInfo[propNm];
					}
					var rowid = $("#reqProduct").getDataIDs().length+1 ;
					$('#reqProduct').addRowData( rowid , bindDataInfo );
					$("#reqProduct").setSelection(rowid);
					defObj.notify('getReqProductListDone');
				}
			);
		}
	};
	
    /**
      * 컨퍼넌트를 초기화 한다
      * @param defObj([동기방식 처리시 활용 ])  jQuery.Deferred()
      */
    var fnInitComponents = function() {
        // 사용자 분리  1. 고객사 , 2.운영사
        var rowid = $('#reqProduct').getGridParam("selrow");
        if(rowid == null) {
            $("#reqProduct").setSelection($("#reqProduct").getDataIDs()[0]);
            rowid = $('#reqProduct').getGridParam("selrow");
        }
        var rowData = jq('#reqProduct').jqGrid('getRowData',rowid);
        rowData['req_good_id'] = '<%=req_good_id%>';
        
        //--------------------------------------------------------------------------------
        // 상태에 컨퍼넌트 처리
        //--------------------------------------------------------------------------------
        
        if('<%=svcType%>' == 'VEN') {               // 공급사
            if($.trim(rowData['req_good_id']) == '') {  // 상태 0:요청 , 2:승인-처리완료 , 3:반려
                // 처리상태
                $('#app_sts').val('0');                     // 요청 상태가
                $('#app_sts').change();
                $('#app_sts').attr('disabled', 'disabled');
                
                // 상품구분
                $('#good_clas_code').val('10');
                $('#good_clas_code').change();
                
            } else {
                // 수정인경우
                if(rowData['app_sts'] == '2' || rowData['app_sts'] == '3') {
                    //$('#btnUser').hide();
                }
            }
        } else {
            // 운영사
        }
        
        //--------------------------------------------------------------------------------
        // 상태에 따른 화면 버튼 처리
        //--------------------------------------------------------------------------------
        if('<%=svcType%>' == 'VEN') {       // 공급사
            $('#btnAdmAppOk').hide();
            $('#btnAdmAppCancel').hide();
            if(rowData['req_good_id'] == '' || rowData['req_good_id'] == undefined) {
                // 등록인 경우
                $('#btnVenSave').show();
                $('#btnVenDelete').hide();
                $('#btnCommonClose').hide();
                $('#btnReset').show();
            } else {
                // 수정인경우
                $('#btnReset').hide();
                if(rowData['app_sts'] == '0') {      // 상태 0:요청 , 2:승인-처리완료 , 3:반려
                    $('#btnVenSave').show();
                    $('#btnVenDelete').show();
                    $('#btnCommonClose').show();
                    $('#btnReset').hide();
                } else if(rowData['app_sts'] == '2'|| rowData['app_sts'] == '3') {
                    $('#btnVenSave').hide();
                    $('#btnVenDelete').hide();
                    $('#btnCommonClose').show();
                    $('#btnReset').hide();
                }
            }
        } else {                                                // 운영사
            $('#btnVenSave').hide();
            $('#btnVenDelete').hide();
            $('#btnReset').hide();
            
            if(rowData['app_sts'] == '0') {         // 상태 0:요청 , 2:승인-처리완료 , 3:반려
                $('#btnAdmAppOk').show();
                $('#btnAdmAppCancel').show();
                $('#btnCommonClose').show();
            } else if(rowData['app_sts'] == '2'|| rowData['app_sts'] == '3') {
                $('#btnAdmAppOk').hide();
                $('#btnAdmAppCancel').hide();
                $('#btnCommonClose').show();
            }
        }
        //----------------------------------------------------------------------------------------
        // Component Value Formatting
        //----------------------------------------------------------------------------------------
        $('#sale_unit_pric').blur();
        
        defObj.notify('initComponentDone');
    };
    
    /**
      * 상품등록 성공후 그리드를  리로드 한다.
      */
    var fnReLoadDataGrid = function() {
        if(typeof(window.dialogArguments) != 'undefined') {
            window.returnValue='success';
            top.close();
        }
    };
    
    /**
      *   선택된 데이터 샛을 기준으로 Component 에 바인드 처리한다.
      */
    var fnBindComponentValue = function(defObj) {
    	var rowid = $('#reqProduct').getGridParam("selrow");
        if(rowid == null) {
            $("#reqProduct").setSelection($("#reqProduct").getDataIDs()[0]);
            rowid = $('#reqProduct').getGridParam("selrow");
        }
        var rowData = jq("#reqProduct").jqGrid('getRowData',rowid);
        fnSetComponentValByGridDataObject( rowData ,'org_');
        
        // 예외 처리
        // 1. 상세설명
        if($.trim(rowData['good_desc']) > ' ')  {
            var gooddesc = unescape(rowData['good_desc']);
            $('#tx_load_content').val(gooddesc);
        }
        // 2.표준규격 및 규격 설정
        if($.trim(rowData['good_st_spec_desc']) > ' ') {
            $('#good_st_spec_desc1').val(rowData['good_st_spec_desc'].split("‡")[0]); 
            $('#good_st_spec_desc2').val(rowData['good_st_spec_desc'].split("‡")[1]);
            $('#good_st_spec_desc3').val(rowData['good_st_spec_desc'].split("‡")[2]);
            $('#good_st_spec_desc4').val(rowData['good_st_spec_desc'].split("‡")[3]);
            $('#good_st_spec_desc5').val(rowData['good_st_spec_desc'].split("‡")[4]);
            $('#good_st_spec_desc6').val(rowData['good_st_spec_desc'].split("‡")[5]);
        }
        if($.trim(rowData['good_spec_desc']) > ' ') {
            $('#good_spec_desc1').val(rowData['good_spec_desc'].split("‡")[0]); 
            $('#good_spec_desc2').val(rowData['good_spec_desc'].split("‡")[1]);
            $('#good_spec_desc3').val(rowData['good_spec_desc'].split("‡")[2]);
            $('#good_spec_desc4').val(rowData['good_spec_desc'].split("‡")[3]);
            $('#good_spec_desc5').val(rowData['good_spec_desc'].split("‡")[4]);
            $('#good_spec_desc6').val(rowData['good_spec_desc'].split("‡")[5]);
            $('#good_spec_desc7').val(rowData['good_spec_desc'].split("‡")[6]);
            $('#good_spec_desc8').val(rowData['good_spec_desc'].split("‡")[7]);
        }
        
        $('#spec_spec').val(rowData['spec_spec']);
        $('#spec_pi').val(rowData['spec_pi']);
        $('#spec_width').val(rowData['spec_width']);
        $('#spec_deep').val(rowData['spec_deep']);
        $('#spec_height').val(rowData['spec_height']);
        $('#spec_liter').val(rowData['spec_liter']);
        $('#spec_ton').val(rowData['spec_ton']);
        $('#spec_meter').val(rowData['spec_meter']);
        $('#spec_material').val(rowData['spec_material']);
        $('#spec_size').val(rowData['spec_size']);
        $('#spec_weight_sum').val(rowData['spec_weight_sum']);
        $('#spec_color').val(rowData['spec_color']);
        $('#spec_type').val(rowData['spec_type']);
        $('#spec_weight_real').val(rowData['spec_weight_real']);

        // 3.동의어 설정
        if($.trim(rowData['good_same_word']) > ' ' ) {
            $('#good_same_word1').val(rowData['good_same_word'].split("‡")[0]);
            $('#good_same_word2').val(rowData['good_same_word'].split("‡")[1]);
            $('#good_same_word3').val(rowData['good_same_word'].split("‡")[2]);
            $('#good_same_word4').val(rowData['good_same_word'].split("‡")[3]);
            $('#good_same_word5').val(rowData['good_same_word'].split("‡")[4]);
        }

        // 4.img 설정
        if($.trim(rowData['small_img_path']) != '' || $.trim(rowData['middle_img_path']) != '' || $.trim(rowData['large_img_path']) != '' ) {
            var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + rowData['small_img_path'];
            var imgPathForMEDIUM = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + rowData['middle_img_path'];
            var imgPathForLARGE = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + rowData['large_img_path'];

            var msg = '';
            msg += '\n imgPathForSMALL  value ['+imgPathForSMALL +']';
            msg += '\n imgPathForMEDIUM value ['+imgPathForMEDIUM+']';
            msg += '\n imgPathForLARGE  value ['+imgPathForLARGE +']';
            //alert(msg);
            $('#SMALL').attr('src',imgPathForSMALL);
            $('#MEDIUM').attr('src',imgPathForMEDIUM);
            $('#LARGE').attr('src',imgPathForLARGE);
        }

        // 5. 고객사상품등록일    inser_info
        var text = '';
        if($.trim(rowData['insert_date']) > ' ' ) {
            text+= rowData['insert_date'];
        }
        if($.trim(rowData['inser_user_nm']) > ' ' ) {
            text+= '('+rowData['inser_user_nm']+')';
        }
        if($.trim(text) != '' ) $('#inser_info').html(text);

        // 6. 상품확인일        app_info
        text = '';
        if($.trim(rowData['app_date']) > ' ' ) {
            text+= rowData['app_date'];
        }
        if($.trim(rowData['app_user_nm']) > ' ' ) {
            text+= '('+rowData['app_user_nm']+')';
        }
        if($.trim(text) != '' ) $('#app_info').html(text);

        // 7. 담당운영자        admin_user_nm
        text = '';
        if($.trim(rowData['admin_user_nm']) > ' ' ) {
            text += rowData['admin_user_nm'];
        }
        if($.trim(text) != '' ) $('#admin_user_nm').html(text);
        
      //전화번호 형식으로 변경
    	$("#phonenum").val( fnSetTelformat( $("#phonenum").val() ) );
      
        defObj.notify('loadDataDone' );
    };
    
    /**
      *  Transaction 처리 시
      */
    var fnReqProdTranSaction = function(mod) {
        //Validation 체크
        if(!fnValidationReqProduct()) return ;
        
        var msg = '';
        var rowid = $('#reqProduct').getGridParam("selrow");
        if(rowid == null) {
            $("#reqProduct").setSelection($("#reqProduct").getDataIDs()[0]);
            rowid = $('#reqProduct').getGridParam("selrow");
        }
        var rowData = jq('#reqProduct').jqGrid('getRowData',rowid);
        // 표준규격 및 규격 설정
        rowData['good_st_spec_desc'] = $('#good_st_spec_desc1').val()
        +'‡'+$('#good_st_spec_desc2').val()
        +'‡'+$('#good_st_spec_desc3').val()
        +'‡'+$('#good_st_spec_desc4').val()
        +'‡'+$('#good_st_spec_desc5').val()
        +'‡'+$('#good_st_spec_desc6').val();
        rowData['good_spec_desc'] = $('#good_spec_desc1').val()
        +'‡'+$('#good_spec_desc2').val()
        +'‡'+$('#good_spec_desc3').val()
        +'‡'+$('#good_spec_desc4').val()
        +'‡'+$('#good_spec_desc5').val()
        +'‡'+$('#good_spec_desc6').val()
        +'‡'+$('#good_spec_desc7').val()
        +'‡'+$('#good_spec_desc8').val();
        
        // 동의어 설정
        rowData['good_same_word'] = $('#good_same_word1').val()
        +'‡'+$('#good_same_word2').val()
        +'‡'+$('#good_same_word3').val()
        +'‡'+$('#good_same_word4').val()
        +'‡'+$('#good_same_word5').val();
        
        rowData['spec_spec'] = $('#spec_spec').val();
        rowData['spec_pi'] = $('#spec_pi').val();
        rowData['spec_width'] = $('#spec_width').val();
        rowData['spec_deep'] = $('#spec_deep').val();
        rowData['spec_height'] = $('#spec_height').val();
        rowData['spec_liter'] = $('#spec_liter').val();
        rowData['spec_ton'] = $('#spec_ton').val();
        rowData['spec_meter'] = $('#spec_meter').val();
        rowData['spec_material'] = $('#spec_material').val();
        rowData['spec_size'] = $('#spec_size').val();
        rowData['spec_weight_sum'] = $('#spec_weight_sum').val();
        rowData['spec_color'] = $('#spec_color').val();
        rowData['spec_type'] = $('#spec_type').val();
        rowData['spec_weight_real'] = $('#spec_weight_real').val();
        
        // 품목상세내역
        rowData['good_desc'] = escape(Editor.getContent());
        
        if(mod == 'trans') {
            if(rowData['req_good_id'] == '')  {  rowData['oper'] = 'ins'; msg = "입력 및 수정하신 내용을 저장하시겠습니까?";  }
            else                              {  rowData['oper'] = 'upd'; msg = "입력 및 수정하신 내용을 수정하시겠습니까?";  }
        } else if(mod == 'del') {
            rowData['oper'] = 'del';
            msg = "해당 내용을 삭제하시겠습니까?";
        }
        
		if(!confirm(msg)) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/vendorReqProductInfoTransGrid.sys",
			rowData,
			function(arg) {
				if(fnTransResult(arg, false)) {
					if(mod == 'del') {
						alert("삭제 하였습니다.");
						opener.fnReLoadDataGrid();
						fnThisPageClose();
					} else if(rowData['oper'] == 'ins') {
						alert("등록 하였습니다.");
// 						opener.fnReLoadDataGrid();
						fnThisPageClose();
					} else if(rowData['oper'] == 'upd') {
						alert("수정 하였습니다.");
						opener.fnReLoadDataGrid();
						fnThisPageClose();
					}
				}
			}
        );
    };
    
    /**
      * 운영사 승인상태 변경
      */
    var fnAppReqGoodTran = function(mod) {
//         var msg = '';
//         var rowid = $('#reqProduct').getGridParam("selrow");
//         if(rowid == null) {
//             $("#reqProduct").setSelection($("#reqProduct").getDataIDs()[0]);
//             rowid = $('#reqProduct').getGridParam("selrow");
//         }
//         var rowData = jq('#reqProduct').jqGrid('getRowData',rowid);
//         rowData['oper'] = 'appCancel';
        
        if(mod == 'appCancel') {
        	fnCancelReasonDialog("fnCallBackCancelReason");
        } else {
            //menuId  , productCode , vendorId , bidid , bid_vendorid
            var spanHtml = document.getElementById("existing_good_iden_numb").innerHTML;
            if(spanHtml == "") {    //신규상품
            	if(!confirm("신규상품으로 승인하시겠습니까?")) {
            		return false;
            	}
            
                var rowid = $('#reqProduct').getGridParam("selrow");
                if(rowid == null) {
                	$("#reqProduct").setSelection($("#reqProduct").getDataIDs()[0]);
                	rowid = $('#reqProduct').getGridParam("selrow");
                }
                var rowData = jq('#reqProduct').jqGrid('getRowData',rowid);
                fnProductDetailView( '<%=menuId%>', '' , '' ,'' ,'', rowData['req_good_id']);
            } else {                                            //기상품
            	//123
            	var params = {good_iden_numb:$('#existing_good_iden_numb').html(),vendorid:$('#vendorid').val()};
                var isExsts = false; 
            	$.post(
                    	'<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/getGoodVendorListByGoodIdenNumJQGrid.sys'
                        , params
                        , function(arg) {
                        	var rowData = eval('(' + arg + ')').list;
                            if(rowData.length > 0 ) {
                            	isExsts = true;                               
                          	}
                            
                            
                            if(isExsts == true) {
                                alert("기상품에 이미 해당 공급사가 등록되어 있습니다.확인하시기 바랍니다.");
                                return;
                            }else {
                                if(!confirm("기상품으로 승인하시겠습니까?")) {
                                    return false;
                                }
                            }
                            
                            var good_iden_numb = $('#existing_good_iden_numb').html();
                            var rowid = $('#reqProduct').getGridParam("selrow");
                            if(rowid == null) {
                                $("#reqProduct").setSelection($("#reqProduct").getDataIDs()[0]);
                                rowid = $('#reqProduct').getGridParam("selrow");
                            }
                            var rowData = jq('#reqProduct').jqGrid('getRowData',rowid);
                            fnProductDetailView( '<%=menuId%>', good_iden_numb, rowData['vendorid'], '', '', rowData['req_good_id']);
                        
                    }
                );  
            }
        }
    };
    
    /**
     * 운영사 승인상태(반려) 변경
     */
    var fnRequestCancelReason = function() {
        var rowid = $('#reqProduct').getGridParam("selrow");
        if(rowid == null) {
            $("#reqProduct").setSelection($("#reqProduct").getDataIDs()[0]);
            rowid = $('#reqProduct').getGridParam("selrow");
        }
        var rowData = jq('#reqProduct').jqGrid('getRowData',rowid);
        rowData['oper'] = 'appCancel';
        rowData['cancel_reason'] = $.trim($('#cancel_reason').val());
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/adminReqProductInfoTransGrid.sys",
            rowData,
            function(arg) {
                if(fnTransResult(arg, false)) {
                    if(typeof(window.dialogArguments) != 'undefined') {
                        window.returnValue='success';
                        alert("반려(취소) 하였습니다");
                        window.location.reload(true);
                    }
                }
            }
        );
    }
    
    /**
      * 저장 및 수정시 Validation을 채크 한다.
      */
    var fnValidationReqProduct = function() {
        var rowid = $('#reqProduct').getGridParam("selrow");
        if(rowid == null) {
            $("#reqProduct").setSelection($("#reqProduct").getDataIDs()[0]);
            rowid = $('#reqProduct').getGridParam("selrow");
        }
        
        var rowData = jq('#reqProduct').jqGrid('getRowData',rowid);
        if($.trim(rowData['good_name']) == '') {
            $('#dialogSelectRow').html('<p>상품명은 필수 값입니다.</p>');
            $("#dialogSelectRow").dialog();
            return false;
        }
        if($.trim(rowData['sale_unit_pric']) == '') {
            $('#dialogSelectRow').html('<p>단가는 필수 값입니다.</p>');
            $("#dialogSelectRow").dialog();
            return false;
        }
        if($.number(rowData['sale_unit_pric'].replace(/,/g,"")) == '0') {
            $('#dialogSelectRow').html('<p>단가는 0보다 커야합니다.</p>');
            $("#dialogSelectRow").dialog();
            return false;
        }
        if($.trim(rowData['good_clas_code']) == '') {
            $('#dialogSelectRow').html('<p>상품구분은 필수 값입니다.</p>');
            $("#dialogSelectRow").dialog();
            return false;
        }
        if($.trim(rowData['orde_clas_code']) == '') {
            $('#dialogSelectRow').html('<p>주문단위는 필수 값입니다.</p>');
            $("#dialogSelectRow").dialog();
            return false;
        }
        if($.trim(rowData['deli_mini_quan']) == '') {
            $('#dialogSelectRow').html('<p>최소구매수량는  필수 값입니다.</p>');
            $("#dialogSelectRow").dialog();
            return false;
        }
        
        if($.number(rowData['deli_mini_quan'].replace(/,/g,"")) == '0') {
            $('#dialogSelectRow').html('<p>최소주문 수량는 0보다 커야합니다.</p>');
            $("#dialogSelectRow").dialog();
            return false;
        }
        
        if($.trim(rowData['deli_mini_day']) == '') {
            $('#dialogSelectRow').html('<p>납품소요일은  필수 값입니다.</p>');
            $("#dialogSelectRow").dialog();
            return false;
        }
        
//         if($.number(rowData['deli_mini_day'].replace(/,/g,"")) == '0') {
//          $('#dialogSelectRow').html('<p>납품소요일은  0보다 커야합니다.</p>');
//             $("#dialogSelectRow").dialog();
//             return false;
//         }
        
        return true;
    };

    /**
      * 해당 Page 닫기
      */
	var fnThisPageClose = function() {
		window.close();
	};
    
    //입력 초기화
    function fnReset() {
      var rowid = $('#reqProduct').getGridParam("selrow");
      
      FNAlterGridDataProValue('reqProduct',rowid,'req_good_id',       '');  // 상품등록요청SEQ
      FNAlterGridDataProValue('reqProduct',rowid,'good_name',         '');  // 상품명
      FNAlterGridDataProValue('reqProduct',rowid,'sale_unit_pric',    '');  // 단가
      $('#good_st_spec_desc1').val('');                                     // 표준규격
      $('#good_st_spec_desc2').val('');                                     // 표준규격
      $('#good_st_spec_desc3').val('');                                     // 표준규격
      $('#good_st_spec_desc4').val('');                                     // 표준규격
      $('#good_st_spec_desc5').val('');                                     // 표준규격
      $('#good_st_spec_desc6').val('');                                     // 표준규격
      $('#good_spec_desc1').val('');                                        // 규격
      $('#good_spec_desc2').val('');                                        // 규격
      $('#good_spec_desc3').val('');                                        // 규격
      $('#good_spec_desc4').val('');                                        // 규격
      $('#good_spec_desc5').val('');                                        // 규격
      $('#good_spec_desc6').val('');                                        // 규격
      $('#good_spec_desc7').val('');                                        // 규격
      $('#good_spec_desc8').val('');                                        // 규격
      FNAlterGridDataProValue('reqProduct',rowid,'orde_clas_code',    '');  // 단위
      $('#orde_clas_code').val('');
      FNAlterGridDataProValue('reqProduct',rowid,'deli_mini_day',     '');  // 납품소요일수
      FNAlterGridDataProValue('reqProduct',rowid,'deli_mini_quan',    '');  // 최소구매수량
      FNAlterGridDataProValue('reqProduct',rowid,'make_comp_name',    '');  // 제조사
      $('#good_same_word1').val('');                                        // 동의어
      $('#good_same_word2').val('');                                        // 동의어
      $('#good_same_word3').val('');                                        // 동의어
      $('#good_same_word4').val('');                                        // 동의어
      $('#good_same_word5').val('');                                        // 동의어
      FNAlterGridDataProValue('reqProduct',rowid,'original_img_path', '');  // 대표이미지원본
      FNAlterGridDataProValue('reqProduct',rowid,'large_img_path',    '');  // 대표이미지대
      FNAlterGridDataProValue('reqProduct',rowid,'middle_img_path',   '');  // 대표이미지중
      FNAlterGridDataProValue('reqProduct',rowid,'small_img_path',    '');  // 대표이미지소
      $('#SMALL').attr('src','<%=Constances.SYSTEM_IMAGE_PATH%>/img/system/imageResize/prod_img_50.gif');
      $('#MEDIUM').attr('src','<%=Constances.SYSTEM_IMAGE_PATH%>/img/system/imageResize/prod_img_70.gif');
      $('#LARGE').attr('src','<%=Constances.SYSTEM_IMAGE_PATH%>/img/system/imageResize/prod_img_100.gif');
      FNAlterGridDataProValue('reqProduct',rowid,'good_desc',         '');  // 상품설명
      $('#tx_load_content').val(' ');
      loadContent();
      FNAlterGridDataProValue('reqProduct',rowid,'good_clas_code',  '10');  // 상품구분
      $('#good_clas_code').val('10');
      FNAlterGridDataProValue('reqProduct',rowid,'good_inventory_cnt','');  // 재고수량
      FNAlterGridDataProValue('reqProduct',rowid,'admin_user_id',     '');  // 담당운영자ID
      FNAlterGridDataProValue('reqProduct',rowid,'admin_user_nm',     '');  // 담당운영자 명
      FNAlterGridDataProValue('reqProduct',rowid,'app_user_id',       '');  // 확인자ID
      FNAlterGridDataProValue('reqProduct',rowid,'app_user_nm',       '');  // 확인자 명
      
      var rowData = jq("#reqProduct").jqGrid('getRowData',rowid);
      fnSetComponentValByGridDataObject( rowData ,'org_');
    }
    
    /**
     * 운영사 상품검색 팝업
     */
    function fnOpenProdSearchPopForAdmin() {
        var popurl = "/product/initProdSearchForAdm.sys?_menuId="+<%=menuId %>+"&isMultiSel=0";
        var popproperty = "dialogWidth:1030px;dialogHeight=540px;scroll=yes;status=no;resizable=no;";
        
//         window.showModalDialog(popurl,self,popproperty);
        window.open(popurl, 'okplazaPop', 'width=1030, height=540, scrollbars=yes, status=no, resizable=no');
    }
    // Call Back
    function fnProdSearchCallBack(good_Iden_Numb , good_Name , full_Cate_Name) {
        var msg = ""; 
        msg += "\n good_Iden_Numb value ["+good_Iden_Numb +"]"; 
        msg += "\n good_Name value ["+good_Name+"]";
        msg += "\n full_Cate_Name value ["+full_Cate_Name +"]";
        //alert(msg);
        $('#existing_good_iden_numb').html(good_Iden_Numb);
        $('#existing_good_name').val(good_Name);
    }
    
    //상품 상세 팝업 호출
    function fnProductDetail() {
    	var good_iden_numb = $('#existing_good_iden_numb').html();
    	if($.trim($('#existing_good_iden_numb').html()) == "" ) {
    		$('#dialogSelectRow').html('</br>상품선택은 필수 입니다.</br>확인후 이용하시기 바랍니다.');
            $('#dialogSelectRow').dialog();
            $('#existing_good_iden_numb').focus();
            return;
        }
        fnProductDetailView('<%=menuId %>',good_iden_numb,'','','');
    }
</script>


<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    var urlInfo = '';
    var gridParams = new Object();
    if($.trim(reqParamObj['req_good_id']) != '') gridParams['req_good_id'] = reqParamObj['req_good_id'];
    else                                         gridParams['req_good_id'] = '' ;
    jq("#reqProduct").jqGrid( {
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/getReqProductDetailInfoJQGrid.sys',
        datatype:'json',
        mtype:'POST',
        colNames:[
            'req_good_id'                    // 상품등록요청SEQ
            ,'good_iden_numb'                // 상품코드
            ,'vendorid'                      // 공급사코드
            ,'good_name'                     // 상품명
            ,'sale_unit_pric'                // 단가
            ,'good_st_spec_desc'             // 표준규격
            ,'good_spec_desc'                // 규격
            ,'orde_clas_code'                // 단위
            ,'deli_mini_day'                 // 납품소요일수              
            ,'deli_mini_quan'                // 최소구매수량              
            ,'make_comp_name'                // 제조사                    
            ,'good_same_word'                // 동의어                    
            ,'original_img_path'             // 대표이미지원본            
            ,'large_img_path'                // 대표이미지대              
            ,'middle_img_path'               // 대표이미지중              
            ,'small_img_path'                // 대표이미지소              
            ,'good_desc'                     // 상품설명                  
            ,'good_clas_code'                // 상품구분                  
            ,'good_inventory_cnt'            // 재고수량                  
            ,'insert_user_id'                // 등록자id                  
            ,'inser_user_nm'                 // 등록자 명                 
            ,'insert_date'                   // 등록일                    
            ,'app_sts'                       // 처리상태                  
            ,'admin_user_id'                 // 담당운영자id              
            ,'admin_user_nm'                 // 담당운영자 명             
            ,'app_user_id'                   // 확인자id                  
            ,'app_user_nm'                   // 확인자 명                 
            ,'app_date'                      // 확인일                    
            ,'create_good_date'              // 품목등록일                
            ,'vendornm'                      /*공급사명 */     
            ,'vendorcd'                      /*공급사코드 */   
            ,'areatype'                      /*공급사권역 */   
            ,'pressentnm'                    /*대표자명 */       
            ,'phonenum'                      /*공급사연락처 */
            ,'cancel_reason'					//반려사유
            ,'org_req_good_id'               // 원본상품등록요청seq       
            ,'org_good_iden_numb'            // 원본상품코드              
            ,'org_vendorid'                  // 원본공급사코드            
            ,'org_good_name'                 // 원본상품명                
            ,'org_sale_unit_pric'            // 원본단가              
            ,'org_good_st_spec_desc'         // 원본표준규격                  
            ,'org_good_spec_desc'            // 원본규격
            ,'org_orde_clas_code'            // 원본단위                  
            ,'org_deli_mini_day'             // 원본납품소요일수          
            ,'org_deli_mini_quan'            // 원본최소구매수량          
            ,'org_make_comp_name'            // 원본제조사                
            ,'org_good_same_word'            // 원본동의어                
            ,'org_original_img_path'         // 원본대표이미지원본        
            ,'org_large_img_path'            // 원본대표이미지대          
            ,'org_middle_img_path'           // 원본대표이미지중          
            ,'org_small_img_path'            // 원본대표이미지소          
            ,'org_good_desc'                 // 원본상품설명              
            ,'org_good_clas_code'            // 원본상품구분              
            ,'org_good_inventory_cnt'        // 원본재고수량              
            ,'org_insert_user_id'            // 원본등록자id              
            ,'org_inser_user_nm'             // 원본등록자 명             
            ,'org_insert_date'               // 원본등록일                
            ,'org_app_sts'                   // 원본처리상태              
            ,'org_admin_user_id'             // 원본담당운영자id          
            ,'org_admin_user_nm'             // 원본담당운영자 명         
            ,'org_app_user_id'               // 원본확인자id              
            ,'org_app_user_nm'               // 원본확인자 명             
            ,'org_app_date'                  // 원본확인일                
            ,'org_create_good_date'          // 원본품목등록일         
            ,'vendornm'                      /*원본공급사명 */     
            ,'vendorcd'                      /*원본공급사코드 */   
            ,'areatype'                      /*원본공급사권역 */   
            ,'pressentnm'                    /*원본대표자명 */       
            ,'phonenum'                      /*원본공급사연락처 */
            
            ,'spec_spec','spec_pi','spec_width','spec_deep','spec_height','spec_liter','spec_ton','spec_meter','spec_material','spec_size','spec_weight_sum','spec_color','spec_type','spec_weight_real'
        ],
        colModel:[
            {name:'req_good_id',index:'req_good_id',width:100},                                        // 상품등록요청SEQ            
            {name:'good_iden_numb',index:'good_iden_numb',width:100},                                  // 상품코드                 
            {name:'vendorid',index:'vendorid',width:100},                                              // 공급사코드                
            {name:'good_name',index:'good_name',width:100},                                            // 상품명                  
            {name:'sale_unit_pric',index:'sale_unit_pric',width:100},                                  // 단가                 
            {name:'good_st_spec_desc',index:'good_st_spec_desc',width:100},                            // 표준규격                   
            {name:'good_spec_desc',index:'good_spec_desc',width:100},                                  // 규격
            {name:'orde_clas_code',index:'orde_clas_code',width:100},                                  // 단위                   
            {name:'deli_mini_day',index:'deli_mini_day',width:100},                                    // 납품소요일수               
            {name:'deli_mini_quan',index:'deli_mini_quan',width:100},                                  // 최소구매수량               
            {name:'make_comp_name',index:'make_comp_name',width:100},                                  // 제조사                  
            {name:'good_same_word',index:'good_same_word',width:100},                                  // 동의어                  
            {name:'original_img_path',index:'original_img_path',width:100},                            // 대표이미지원본              
            {name:'large_img_path',index:'large_img_path',width:100},                                  // 대표이미지대               
            {name:'middle_img_path',index:'middle_img_path',width:100},                                // 대표이미지중               
            {name:'small_img_path',index:'small_img_path',width:100},                                  // 대표이미지소               
            {name:'good_desc',index:'good_desc',width:100},                                            // 상품설명                 
            {name:'good_clas_code',index:'good_clas_code',width:100},                                  // 상품구분                 
            {name:'good_inventory_cnt',index:'good_inventory_cnt',width:100},                          // 재고수량                 
            {name:'insert_user_id',index:'insert_user_id',width:100},                                  // 등록자ID                
            {name:'inser_user_nm',index:'inser_user_nm',width:100},                                    // 등록자 명                
            {name:'insert_date',index:'insert_date',width:100},                                        // 등록일                  
            {name:'app_sts',index:'app_sts',width:100},                                                // 처리상태                 
            {name:'admin_user_id',index:'admin_user_id',width:100},                                    // 담당운영자ID              
            {name:'admin_user_nm',index:'admin_user_nm',width:100},                                    // 담당운영자 명              
            {name:'app_user_id',index:'app_user_id',width:100},                                        // 확인자ID                
            {name:'app_user_nm',index:'app_user_nm',width:100},                                        // 확인자 명                
            {name:'app_date',index:'app_date',width:100},                                              // 확인일                  
            {name:'create_good_date',index:'create_good_date',width:100},                              // 품목등록일                
            {name:'vendornm'    ,index:'vendornm'    ,width:100},                                      /*공급사명 */     
            {name:'vendorcd'    ,index:'vendorcd'    ,width:100},                                      /*공급사코드 */    
            {name:'areatype'    ,index:'areatype'    ,width:100},                                      /*공급사권역 */    
            {name:'pressentnm'  ,index:'pressentnm'  ,width:100},                                      /*대표자명 */     
            {name:'phonenum'    ,index:'phonenum'    ,width:100},                                      /*공급사연락처 */
            {name:'cancel_reason', index:'cancel_reason'},		//반려사유
            {name:'org_req_good_id',index:'org_req_good_id',width:100,hidden:true},                    // 원본상품등록요청SEQ          
            {name:'org_good_iden_numb',index:'org_good_iden_numb',width:100,hidden:true},              // 원본상품코드               
            {name:'org_vendorid',index:'org_vendorid',width:100,hidden:true},                          // 원본공급사코드              
            {name:'org_good_name',index:'org_good_name',width:100,hidden:true},                        // 원본상품명                
            {name:'org_sale_unit_pric',index:'org_sale_unit_pric',width:100,hidden:true},              // 원본단가               
            {name:'org_good_st_spec_desc',index:'org_good_st_spec_desc',width:100,hidden:true},        // 원본표준규격                 
            {name:'org_good_spec_desc',index:'org_good_spec_desc',width:100,hidden:true},              // 원본규격
            {name:'org_orde_clas_code',index:'org_orde_clas_code',width:100,hidden:true},              // 원본단위                 
            {name:'org_deli_mini_day',index:'org_deli_mini_day',width:100,hidden:true},                // 원본납품소요일수             
            {name:'org_deli_mini_quan',index:'org_deli_mini_quan',width:100,hidden:true},              // 원본최소구매수량             
            {name:'org_make_comp_name',index:'org_make_comp_name',width:100,hidden:true},              // 원본제조사                
            {name:'org_good_same_word',index:'org_good_same_word',width:100,hidden:true},              // 원본동의어                
            {name:'org_original_img_path',index:'org_original_img_path',width:100,hidden:true},        // 원본대표이미지원본            
            {name:'org_large_img_path',index:'org_large_img_path',width:100,hidden:true},              // 원본대표이미지대             
            {name:'org_middle_img_path',index:'org_middle_img_path',width:100,hidden:true},            // 원본대표이미지중             
            {name:'org_small_img_path',index:'org_small_img_path',width:100,hidden:true},              // 원본대표이미지소             
            {name:'org_good_desc',index:'org_good_desc',width:100,hidden:true},                        // 원본상품설명               
            {name:'org_good_clas_code',index:'org_good_clas_code',width:100,hidden:true},              // 원본상품구분               
            {name:'org_good_inventory_cnt',index:'org_good_inventory_cnt',width:100,hidden:true},      // 원본재고수량               
            {name:'org_insert_user_id',index:'org_insert_user_id',width:100,hidden:true},              // 원본등록자ID              
            {name:'org_inser_user_nm',index:'org_inser_user_nm',width:100,hidden:true},                // 원본등록자 명              
            {name:'org_insert_date',index:'org_insert_date',width:100,hidden:true},                    // 원본등록일                
            {name:'org_app_sts',index:'org_app_sts',width:100,hidden:true},                            // 원본처리상태               
            {name:'org_admin_user_id',index:'org_admin_user_id',width:100,hidden:true},                // 원본담당운영자ID            
            {name:'org_admin_user_nm',index:'org_admin_user_nm',width:100,hidden:true},                // 원본담당운영자 명            
            {name:'org_app_user_id',index:'org_app_user_id',width:100,hidden:true},                    // 원본확인자ID              
            {name:'org_app_user_nm',index:'org_app_user_nm',width:100,hidden:true},                    // 원본확인자 명              
            {name:'org_app_date',index:'org_app_date',width:100,hidden:true},                          // 원본확인일                
            {name:'org_create_good_date',index:'org_create_good_date',width:100,hidden:true},          // 원본품목등록일      
            {name:'vendornm'  ,index:'vendornm'  ,width:100,hidden:true},                              // 원본공급사명 */  
            {name:'vendorcd'  ,index:'vendorcd'  ,width:100,hidden:true},                              // 원본공급사코드 */ 
            {name:'areatype'  ,index:'areatype'  ,width:100,hidden:true},                              // 원본공급사권역 */ 
            {name:'pressentnm',index:'pressentnm',width:100,hidden:true},                              // 원본대표자명 */  
            {name:'phonenum'  ,index:'phonenum'  ,width:100,hidden:true},                              // 원본공급사연락처 */
            
            {name:'spec_spec',hidden:true},
            {name:'spec_pi',hidden:true},
            {name:'spec_width',hidden:true},
            {name:'spec_deep',hidden:true},
            {name:'spec_height',hidden:true},
            {name:'spec_liter',hidden:true},
            {name:'spec_ton',hidden:true},
            {name:'spec_meter',hidden:true},
            {name:'spec_material',hidden:true},
            {name:'spec_size',hidden:true},
            {name:'spec_weight_sum',hidden:true},
            {name:'spec_color',hidden:true},
            {name:'spec_type',hidden:true},
            {name:'spec_weight_real',hidden:true}
        ],
        postData:gridParams,
        rownumbers:false,
        width:$(window).width()-60 + Number(gridWidthResizePlus),
        sortname:'borgNms',sortorder:'asc',
        caption:"상품진열정보", 
        viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete:function() {
            var deferrObj = new jQuery.Deferred();
            fnReqProductListComplete(deferrObj,reqParamObj);
            deferrObj.progress(
                function(insMod) {
                    if(insMod == 'getReqProductListDone') { fnBindComponentValue(defObj); }
                }
            );
            var rowCnt = jq("#reqProduct").getGridParam('reccount');
            var tmp_cancel_reason = "";
			if(rowCnt>0){
				var top_rowid = $("#reqProduct").getDataIDs()[0];//첫번째로우 아이디구하기
				var selrowContent = jq("#reqProduct").jqGrid('getRowData',top_rowid);
				tmp_cancel_reason = selrowContent.cancel_reason;
				//버튼케이스처리
				var svcTypeCd = "<%=userInfoDto.getSvcTypeCd()%>";
				if(selrowContent.app_sts == 2 || selrowContent.app_sts == 3){
					if(svcTypeCd == "ADM"){
						$("#btnAdmAppOk").hide();
						$("#btnAdmAppCancel").hide();
					}else{
						$("#btnVenSave").hide();
						$("#btnVenDelete").hide();
					}
				}else{
					if(svcTypeCd == "ADM"){
						$("#btnAdmAppOk").show();
						$('#btnAdmAppCancel').show();
					}else{
						$("#btnVenSave").show();
						$("#btnVenDelete").show();
					}
				}
			}
            if(tmp_cancel_reason!="") {
            	$("#cancel_reason_div").show();
            	$("#cancel_reason_div").html("<font color='red'>반려사유 : "+tmp_cancel_reason+"</font>");
            }
            
            
            
        },
        onSelectRow:function(rowid,iRow,iCol,e) {},
        ondblClickRow:function(rowid,iRow,iCol,e) {},
        onCellSelect:function(rowid,iCol,cellcontent,target) {},
        loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
        jsonReader: { root:"list",total:"total",records:"records",repeatitems:false,cell:"cell"}
    });
});

</script>
<!-- -------------------------------------------------------------------------------------------------- -->
<!-- 이미지 처리 관련 Script 처리 시작  -->
<!-- -------------------------------------------------------------------------------------------------- -->
<!--------------------------- jQuery Fileupload --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<% /*------------------------------------Img File Upload 스크립트--------------------------------- */ %>
<script type="text/javascript">
$(function() {
   var btnUpload=$('#btnAttach');
   var status=$('#status');
   new AjaxUpload(btnUpload, {
      action:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/imageResizeProcess.sys',
      name:'imageFile',
      data:{},
      onSubmit:function(file,ext) {
          if(!(ext && /^(jpg|jpeg|gif)$/.test(ext))) {
              alert('이미지 파일(jpg,jpeg,gif) 파일만 등록 가능합니다.');
             //status.text("이미지 파일만 등록 가능합니다.");   // extension is not allowed
             return false;
          }
         if(!confirm("이미지를 등록하시겠습니까?")) {
            return false;
         }
         status.text('Uploading...');
      },
      onComplete: function(file,response) {
         status.text('');
         var result  = eval("(" +response + ")");
         
         var imgPathForORGIN = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + result.ORGIN;
         var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.SMALL;
         var imgPathForMEDIUM = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.MEDIUM;
         var imgPathForLARGE = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.LARGE;
         

         // 이미지 변경  
         $('#SMALL').attr('src',imgPathForSMALL);
         $('#MEDIUM').attr('src',imgPathForMEDIUM);
         $('#LARGE').attr('src',imgPathForLARGE);
         
         // 경로 설정
         $('#original_img_path').val(result.ORGIN);
         $('#large_img_path ').val(result.LARGE);
         $('#middle_img_path').val(result.MEDIUM);
         $('#small_img_path ').val(result.SMALL);
         
         
         var msg = ""; 
         msg = '\n imgPathForORGIN  value['+imgPathForORGIN +']'; 
         msg = '\n imgPathForSMALL  value['+imgPathForSMALL +']'; 
         msg = '\n imgPathForMEDIUM value['+imgPathForMEDIUM+']'; 
         msg = '\n imgPathForLARGE  value['+imgPathForLARGE +']'; 
         msg = '\n '; 
         
         
         
         // 이미지 Grid 등록
         $('#original_img_path').change();
         $('#large_img_path ').change();
         $('#middle_img_path').change();
         $('#small_img_path ').change();
         
      }
   });
});

function attachDel() {
    // 이미지 변경
    $('#SMALL').attr('src','/img/system/imageResize/prod_img_50.gif');
    $('#MEDIUM').attr('src','/img/system/imageResize/prod_img_70.gif');
    $('#LARGE').attr('src','/img/system/imageResize/prod_img_100.gif');
    
    // 경로 설정
    $('#original_img_path').val('');
    $('#large_img_path').val('');
    $('#middle_img_path').val('');
    $('#small_img_path').val('');
    $('#original_img_path').focus();
   
    // 이미지 Grid 등록
    $('#original_img_path').change();
    $('#large_img_path ').change();
    $('#middle_img_path').change();
    $('#small_img_path ').change();
    
}

//이미지 확대
function funPopBigImage(){
	if($('#original_img_path').val()=='') {
		alert('이미지가 존재하지 않습니다.'); return;
	}
	$('#productPop').css({'width':'500px','top':'10%','left':'20%'}).html('')
	.load('/menu/product/product/popBigImage.sys?bigImage='+$('#original_img_path').val())
	.jqmShow(); 
}
</script>
<!-- -------------------------------------------------------------------------------------------------- -->
<!-- 이미지 처리 관련 Script 처리 끝  -->
<!-- -------------------------------------------------------------------------------------------------- -->

<%
/**------------------------------------사용자팝업 사용방법---------------------------------
* fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* userNm : 찾고자하는 사용자명
* loginId : 찾고자하는 사용자 Login Id
* svcTypeCd : 찾는사용자의 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영사, "CEN":물륫센타)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(사용자일련번호, 조직일련번호, 서비스유형명, 사용자명, 로그인아이디, 조직명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
    $("#btnUser").click(function(){
        var userNm = $("#admin_user_nm").val();
        var loginId = "";
        var svcTypeCd = "ADM";
        fnJqmUserInitSearch(userNm, loginId, svcTypeCd, "fnSelectUserCallback");
    });
    
    $("#admin_user_nm").keydown(function(e){ if(e.keyCode==13) { $("#btnUser").click(); } });
    $("#admin_user_nm").change(function(e){
        if($("#admin_user_nm").val()=="") {
            $("#admin_user_id").val("");
            $("#admin_user_id").change();
        }
    });
});
/**
 * 사용자검색 Callback Function
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
    $("#admin_user_nm").val(userNm);
    $("#admin_user_id").val(userId);
    $("#admin_user_id").change();
}
</script>

<%
/**------------------------------------운영사 반려(취소)팝업 사용방법---------------------------------//456
 * fnCancelReasonDialog(callbackString) 을 호출하여 Div팝업을 Display ===
 * callbackString : 콜백함수(문자열), 콜백함수파라메타는 1개(반려(취소) 사유) 
 */
%>
<%@ include file="/WEB-INF/jsp/product/product/productCancelReasonDiv.jsp"%>
<script type="text/javascript">
/**
 * 운영사 반려(취소) 정보 콜백
 */
function fnCallBackCancelReason(cancelReason) {
    $('#cancel_reason').val(cancelReason);
    fnRequestCancelReason();
}
</script>
<% //------------------------------------------------------------------------------ %>

<script type="text/javascript">

   /**
    * DataObject 를 기준으로 Property명에 찾아 동일한 Component 존재시 값을 바인드한다. 
    * @param gridData([Object()])      Object
    * @param preWord([복사된 컬럼 접두어])  String
    */
   var fnSetComponentValByGridDataObject = function(gridData,preWord){
	   

       for(var propertyName in gridData){
           if(propertyName.indexOf(preWord) == -1 ) {
               if ($('#'+propertyName).exists()) {
                   $('#'+propertyName).val(gridData[propertyName]);
            	   
               }
           }
       }
	   if('<%=svcType%>' == 'VEN') {               // 공급사
	        var rowid = $('#reqProduct').getGridParam("selrow");
	        if(rowid == null) {
	            $("#reqProduct").setSelection($("#reqProduct").getDataIDs()[0]);
	            rowid = $('#reqProduct').getGridParam("selrow");
	        }
	        var rowData = jq('#reqProduct').jqGrid('getRowData',rowid);
           if($.trim(rowData['req_good_id']) == '') {  // 상태 0:요청 , 2:승인-처리완료 , 3:반려            	   
               // 처리상태
               $('#app_sts').val('0');                     // 요청 상태가
               $('#app_sts').change();
               $('#app_sts').attr('disabled', 'disabled');
               
               // 상품구분
               $('#good_clas_code').val('10');
               $('#good_clas_code').change();
           }
       }           
   };




    /**
     * 해당 로우에 접두어에 해당하는 원본데이터 복사본을 생성한다. 
     * @param gridId([그리드 ObjectId])
     * @param rowId(해당 rowKey)
     * @param preWord(접두어) : 상품상세에서 제공되는 공급사 지정
     */
    var fnCopyOrgRowData =  function(jqGridId, rowId , preWord ){
        var dataSet =new Object();
        
        for(var propertyName in jq("#"+jqGridId).jqGrid('getRowData',rowId)) {
            if(propertyName.indexOf(preWord) == -1 ) {
                
                var  propertyValue = jq("#"+jqGridId).jqGrid('getRowData',rowId)[propertyName];
                var col =  preWord+propertyName; 
                
                dataSet[preWord+propertyName] = propertyValue;
            }
        }
        $('#'+jqGridId).jqGrid('setRowData',rowId,dataSet);
    };
    
   /**
     * 상품 설명 상세 변경에 따른 DataSet 반영 
     * @param contents([상세 설명])
     */
   var fnSetProductDescContents = function (gridId , contents) {
      var rowId = $("#"+gridId).getGridParam("selrow");
       if(rowId == null){
           return ; 
       }
       
       contents = escape(contents);
       
       $('#'+gridId).jqGrid('setRowData',rowId,{good_desc:contents});
   };
 
    /**
       * fnSetGridDataSet
       * Component변화에 따른 GridDataSet 변경
       * @param obj([Object ])
       * @param e([Evnet])
       * @param gridId([GridDataSet Id])
       */
    var fnSetGridDataSet = function(obj,e,gridId) {
        var rowId = $('#'+gridId).getGridParam("selrow");
        var colNm = $(obj).attr('id');
        var orgVal = jq("#"+gridId).jqGrid('getRowData',rowId)[colNm];
        var modVal = '';
        
        modVal = $(obj).val();
        
//         if(e.target.type == 'text' || e.target.type == 'select-one' ) {
            
//         } else if(e.target.type == 'radio') {
//             colNm = $(obj).attr('name');
//             modVal = $("input[name='"+colNm+"']:checked").val();
//             orgVal = jq("#"+gridId).jqGrid('getRowData',rowId)[colNm];
//         }
        
        if($.trim(orgVal) != $.trim(modVal)) {
            var dataSet = new Object();
            dataSet[colNm] = modVal;
            dataSet["isModify"] = "1";
            $('#'+gridId).jqGrid('setRowData',rowId,dataSet);
        }
    };
    
    // NumberPormatOption
    var numFormatType = new Array(
            {numType:'persent',  option:{decimalSymbol: '.',digitGroupSymbol:'',dropDecimals:false,groupDigits:true,symbol:'',roundToDecimalPlace:2}},
            {numType:'number',   option:{decimalSymbol: '.',digitGroupSymbol:',',dropDecimals:false,groupDigits:true,symbol:'',roundToDecimalPlace:0}}
    );
   
   /**
    * 숫자 형태로 값을 포맷한다. 
     * @param obj([Object ])
     */
   var fnSetFormatCurrency = function(obj){
       var colNm = $(obj).attr('id');
       var altNm = $(obj).attr('alt');
       var modVal = '';
       
       for(var formatIdx = 0 ; formatIdx < numFormatType.length ; formatIdx++){
           if(numFormatType[formatIdx].numType == altNm){
               $(obj).formatCurrency(numFormatType[formatIdx].option);
           }
       }
   };
   
</script>
<!-- 버튼 이벤트 스크립트 끝 -->

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//공급사상품등록요청
	header = "공급사상품등록요청";
	manualPath = "/img/manual/vendor/venProductRegist.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<body>
<input id="cancel_reason" name="cancel_reason" type="hidden" value="" />
        <form id="frm" name="frm" method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
                <tr>
                    <td>
                        <!-- 타이틀 시작 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr valign="top">
                                <td width="20" valign="middle">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" />
                                </td>
                                <td height="29" class="ptitle">공급사상품등록요청
                                <%if(isVendor){ %>
                                   &nbsp;<span id="question" class="questionButton">도움말</span>
                                <%} %>
                                </td>
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
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" />
                                </td>
                                <td class="stitle">공급사상품등록요청 정보</td>
                                <td align="right">
                                	<div id="cancel_reason_div" style="display: none"></div>
                                </td>
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
                                <td colspan="6">
                                    <div id="jqgrid" style="display: none;">
                                        <table id="reqProduct"></table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" class="table_top_line"></td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject9" width="100">공급사</td>
                                <td class="table_td_contents">
                                    <input id="vendornm" name="vendornm" type="text" value="" size="" maxlength="50" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                    <input id="vendorid" name="vendorid" type="text" style="visibility:hidden;width:0px;" value="" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                </td>
                                <td class="table_td_subject" width="100">공급사코드</td>
                                <td class="table_td_contents">
                                    <input id="vendorcd" name="vendorcd" type="text" value="" maxlength="20" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                </td>
                                <td class="table_td_subject" width="100">권역</td>
                                <td class="table_td_contents">
                                    <select id="areatype" name="areatype" class="select_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');">
<%	
	@SuppressWarnings("unchecked")
	List<CodesDto>  deliAreaCodeList = (List<CodesDto>)request.getAttribute("deliAreaCodeList");
	if(deliAreaCodeList != null && deliAreaCodeList.size() > 0){
		for(CodesDto dto : deliAreaCodeList){
%>
                                        <option value="<%=dto.getCodeVal1()%>"><%=dto.getCodeNm1()%></option>
<%			
		}
	}
%>                              
                                        <option value="">선택</option>
                                    
                                    
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">대표자</td>
                                <td class="table_td_contents">
                                    <input id="pressentnm" name="pressentnm" type="text" value="" maxlength="50" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                </td>
                                <td class="table_td_subject">연락처</td>
                                <td class="table_td_contents">
                                    <input id="phonenum" name="phonenum" type="text" value="" maxlength="20" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                </td>
                                <td class="table_td_subject">처리상태</td>
                                <td class="table_td_contents">
                                    <select id="app_sts" name="app_sts" class="select_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');">
<%	
	@SuppressWarnings("unchecked")
	List<CodesDto>  reqAppSts = (List<CodesDto>)request.getAttribute("reqAppSts");
	if(reqAppSts != null && reqAppSts.size() > 0){
		for(CodesDto dto : reqAppSts){
%>
                                        <option value="<%=dto.getCodeVal1()%>"><%=dto.getCodeNm1()%></option>
<%			
		}
	}
%>                                          
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject9">상품명</td>
                                <td class="table_td_contents">
                                    <input id="good_name" name="good_name" type="text" maxlength="50" style="width:90%;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                </td>
                                <td class="table_td_subject">상품코드</td>
                                <td class="table_td_contents">
                                    <input id="good_iden_numb" name="good_iden_numb" type="text" value="" maxlength="50" style="width:90%;" class="input_text_none" disabled="disabled" />
                                </td>
                                <td class="table_td_subject9">단가</td>
                                <td class="table_td_contents">
                                    <input id="sale_unit_pric" name="sale_unit_pric" requirednumber alt='number' type="text" value="" size="" maxlength="18" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">상품규격</td>
                                <td colspan="5" class="table_td_contents">
						          	<table style="width: 100%">
										<tr>
											<td style="width: 99%">
												규격&nbsp;<input name="spec_spec" id="spec_spec" title="상품규격" type="text" style="width:660px;" />
											</td>
										</tr>
										<tr>
											<td style="width: 99%">
												&nbsp;&nbsp;&nbsp;&nbsp;Ø&nbsp;<input name="spec_pi" id="spec_pi" title="Ø" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
												W&nbsp;<input name="spec_width" id="spec_width" title="W" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
												D&nbsp;<input name="spec_deep" id="spec_deep" title="D" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
												H&nbsp;<input name="spec_height" id="spec_height" title="H" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
												L&nbsp;<input name="spec_liter" id="spec_liter" title="L" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
												t&nbsp;<input name="spec_ton" id="spec_ton" title="t" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
												M(미터)&nbsp;<input name="spec_meter" id="spec_meter" title="M(미터)" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
											</td>
										</tr>
										<tr>
											<td style="width: 99%">
												재질&nbsp;<input name="spec_material" id="spec_material" title="재질" type="text" style="width:60px;" />&nbsp;&nbsp;
												크기&nbsp;<input name="spec_size" id="spec_size" title="크기" type="text" style="width:60px;" />&nbsp;&nbsp;
												색상&nbsp;<input name="spec_color" id="spec_color" title="색상" type="text" style="width:60px;" />&nbsp;&nbsp;
												TYPE&nbsp;<input name="spec_type" id="spec_type" title="TYPE" type="text" style="width:60px;" />&nbsp;&nbsp;
												총중량(KG,할증포함)&nbsp;<input name="spec_weight_sum" id="spec_weight_sum" title="총중량(KG,할증포함)" type="text" style="width:60px;" />&nbsp;&nbsp;
												실중량(KG)&nbsp;<input name="spec_weight_real" id="spec_weight_real" title="실중량(KG)" type="text" style="width:60px;" />
											</td>
										</tr>
						          	</table>
                                	<input id="good_spec_desc1" name="good_spec_desc1" type="hidden" size="150" maxlength="100" style="text-align:left;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">제조사</td>
                                <td class="table_td_contents">
                                    <input id="make_comp_name" name="make_comp_name" type="text" value="" size="" maxlength="50" style="width:90%;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                </td>
                                <td class="table_td_subject9">상품구분</td>
                                <td class="table_td_contents">
                                    <select id="good_clas_code" name="good_clas_code" class="select" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');">
										<option value="">선택</option>
<%	
	@SuppressWarnings("unchecked")
	List<CodesDto>  orderGoodsType = (List<CodesDto>)request.getAttribute("orderGoodsType");
	if(orderGoodsType != null && orderGoodsType.size() > 0){
		for(CodesDto dto : orderGoodsType){
			if(!"30".equals(dto.getCodeVal1())){
%>
                                        <option value="<%=dto.getCodeVal1()%>"><%=dto.getCodeNm1()%></option>
<%
			}
		}
	}
%>  						
                                    </select>
                                </td>
                                
                                
                                <td class="table_td_subject">재고수량</td>
                                <td class="table_td_contents">
                                    <input id="good_inventory_cnt" name="good_inventory_cnt" alt='number' type="text" value="" size="5" maxlength="5" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');"
                                        onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>

                            <tr>
                                <td class="table_td_subject9">주문단위</td>
                                <td class="table_td_contents">
                                    <select id="orde_clas_code" name="orde_clas_code" class="select" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');">
                                        <option value="">선택</option>
<%	
	@SuppressWarnings("unchecked")
	List<CodesDto>  orderUnit = (List<CodesDto>)request.getAttribute("orderUnit");
	if(orderUnit != null && orderUnit.size() > 0){
		for(CodesDto dto : orderUnit){
%>
                                        <option value="<%=dto.getCodeVal1()%>"><%=dto.getCodeNm1()%></option>
<%			
		}
	}
%>                                        
                                    </select>
                                </td>
                                <td class="table_td_subject9">최소구매수량</td>
                                <td class="table_td_contents">
                                    <input id="deli_mini_quan" name="deli_mini_quan" alt='number' type="text" value="" size="5" maxlength="4" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');"
                                        onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />
                                </td>
                                <td class="table_td_subject9">납품소요일</td>
                                <td class="table_td_contents">
                                    <input id="deli_mini_day" name="deli_mini_day" alt='number' type="text" value="" size="4" maxlength="2" style="text-align:right;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');"
                                        onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />일
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">상품이미지</td>
                                <td class="table_td_contents">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td height="25">
                                                <input id="original_img_path" name="original_img_path" type="text" value="" style="width:90%;" class="input_text_none" disabled="disabled" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                                <input id="large_img_path" name="large_img_path" type="text" style="display:none;" value="" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                                <input id="middle_img_path" name="middle_img_path" type="text" style="display:none;" value="" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                                <input id="small_img_path" name="small_img_path" type="text" style="display:none;" value="" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" height="25">
                                                <img id="btnAttach" name="btnAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageOK.gif" style="width:75px;height:18px;cursor:pointer;" />
                                                <img id="btnAttachDel" name="btnAttachDel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageDelete.gif" style="width:75px;height:18px;cursor:pointer;" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
								<td class="table_td_subject" >대표상품이미지</td>
								<td colspan="3" class="table_td_contents4">
									<table>
										<tr>
											<td valign="bottom">
												SMALL<br />
												<img id="SMALL" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border:0px;" />
											</td>
											<td valign="bottom">
												MEDIUM<br />
												<img id="MEDIUM" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_70.gif" alt="MEDIUM" style="border:0px;" />
											</td>
											<td valign="bottom">
												LARGE<br />
												<img id="LARGE" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_100.gif" alt="LARGE" style="border:0px;" />
											</td>
										</tr>
									</table>
								</td>
                            </tr>
                            <!--                         <tr> -->
                            <!--                             <td class="table_td_subject">운영담당자</td> -->
                            <!--                             <td class="table_td_contents"> -->
                            <!--                                 <input id="admin_user_nm" name="admin_user_nm" type="text" value=""  style="background-color: #eaeaea;" /> -->
                            <%--                                 <img id="btnUser" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" /> --%>
                            <!--                                 <input id="admin_user_id" name="admin_user_id" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" style="display: none;"  />  -->
                            <!--                             </td> -->
                            <!--                         </tr> -->
<!--                             <tr> -->
<!--                                 <td colspan="6" height="1" bgcolor="eaeaea"></td> -->
<!--                             </tr> -->
<%-- <%  if("ADM".equals(userInfoDto.getSvcTypeCd())){   %> --%>
<!--                             <tr> -->
<!--                                 <td class="table_td_subject">기상품코드 -->
<%--                                     <img id="btnProdSearch" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;vertical-align:middle;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>" /> --%>
<!--                                 </td> -->
<!--                                 <td colspan="5" class="table_td_contents"> -->
                                    <span id="existing_good_iden_numb" style="display:inline-block;width:130px;"></span>
                                    <input id="existing_good_name" name="existing_good_name" type="hidden" value="" size="20" maxlength="100" readonly="readonly" />
<%--                                     <img id="btnProdManage" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Wrench.gif" style="width:15px;height:15px;vertical-align:middle;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>" /> --%>
<!--                                 </td> -->
<!--                             </tr> -->
<!--                             <tr> -->
<!--                                 <td colspan="6" height="1" bgcolor="eaeaea"></td> -->
<!--                             </tr> -->
<%-- <%  }   %> --%>
<!--                             <tr> -->
<!--                                 <td class="table_td_subject">상품설명</td> -->
<!--                                 <td colspan="5" class="table_td_contents"> -->
<!--                                     <table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!--                                         <tr> -->
<!--                                             <td> -->
<!--                                                 <textarea name="textarea" id="textarea" cols="45" rows="10" style="width:100%;height:100%;display:none;"></textarea> -->
<!--                                             </td> -->
<!--                                         </tr> -->
<!--                                     </table> -->
<!--                                 </td> -->
<!--                             </tr> -->
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">상품 동의어</td>
                                <td colspan="5" class="table_td_contents">
                                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td>
                                                <input id="good_same_word1" name="good_same_word1" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                            </td>
                                            <td>
                                                <input id="good_same_word2" name="good_same_word2" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                            </td>
                                            <td>
                                                <input id="good_same_word3" name="good_same_word3" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                            </td>
                                            <td>
                                                <input id="good_same_word4" name="good_same_word4" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                            </td>
                                            <td>
                                                <input id="good_same_word5" name="good_same_word5" type="text" value="" size="20" maxlength="20" style="width:95%;" onchange="javascript:fnSetGridDataSet(this,event,'reqProduct');" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">공급사상품등록일</td>
                                <td class="table_td_contents" id="inser_info"></td>
                                <td class="table_td_subject">상품확인일</td>
                                <td class="table_td_contents" id="app_info"></td>
                                <td class="table_td_subject">담당운영자</td>
                                <td class="table_td_contents" id="admin_user_nm"></td>
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
                    <td align="center">
<%-- 						<button id="btnVenSave" type="button" class="btn btn-primary btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-save"></i>저장</button> --%>
<%-- 						<button id="btnVenDelete" type="button" class="btn btn-primary btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-eraser"></i>삭제</button> --%>
						<button id="btnAdmAppOk" type="button" class="btn btn-primary btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>"><i class="fa fa-file-o"></i>승인(상품등록)</button>
						<button id="btnAdmAppCancel" type="button" class="btn btn-primary btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>"><i class="fa fa-hand-stop-o"></i>반려(취소)</button>
						<button id="btnCommonClose" type="button" class="btn btn-default btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-close"></i>닫기</button>
						<button id="btnReset" type="button" class="btn btn-default btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-repeat"></i>초기화</button>
                    </td>
                </tr>
                <tr><td style="height: 5px;"></td></tr>
                
            </table>
            <!-------------------------------- Dialog Div Start -------------------------------->
            <!-------------------------------- Dialog Div End -------------------------------->
            <textarea id="tx_load_content" cols="20" rows="2" style="height:250px;display:none;"></textarea>
            <div id="dialogSelectRow" title="Warning" style="display:none;font-size:12px;color:red;">
                <p></p>
            </div>
            <div id="dialog" title="Feature not supported" style="display:none;">
                <p></p>
            </div>
        </form>
        <div class="jqmWindow" id="productPop"></div>
</body>
</html>