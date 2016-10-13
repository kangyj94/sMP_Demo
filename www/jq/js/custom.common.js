/**
 * 그리드 트랜잭션 결과를 나타내는 함수
 * @param response
 * @param postdata
 * @returns {Array}
 */
function fnJqTransResult(response, postdata) {
	var result = eval('(' + response.responseText + ')').customResponse;
	var errors = "";
	if (result.success == false) {
		for (var i = 0; i < result.message.length; i++) {
			errors +=  result.message[i] + "<br/>";
		}
		$("#dialog").html("<font size='2'>"+errors+"</font>");
		$("#dialog").dialog({
			title: 'Fail',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
	} else {
		$("#dialog").html("<font size='2'>처리 하였습니다.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){
				$(this).dialog("close");
			}}
		});
		setTimeout(function() {
			$("#dialog").dialog("close");
		}, 1000);
	}
	return [result.success, errors, null];
}

/**
 * 그리드의 일반 Ajax 트랜잭션 결과를 나타내는 함수(성공 시 메시지 표현)
 * @param response
 * @returns boolean
 */
function fnAjaxTransResult(response) {
	return fnTransResult(response, true);
}

/**
 * 그리드의 일반 Ajax 트랜잭션 결과를 나타내는 함수(isMessage 가 true 일경우 성공 시 메시지 표현)
 * @param {} response
 * @param {} isMessage
 * @return {}
 */
function fnTransResult(response, isMessage) {
	var result = eval('(' + response + ')').customResponse;
	var errors = "";
	if (result.success == false) {
		for (var i = 0; i < result.message.length; i++) {
			errors +=  result.message[i] + "<br/>";
		}
		$("#dialog").html("<font size='2'>"+errors+"</font>");
		$("#dialog").dialog({
			title: 'Fail',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
	} else {
		if(isMessage) {
			$("#dialog").html("<font size='2'>처리 하였습니다.</font>");
			$("#dialog").dialog({
				title: 'Success',modal: true,
				buttons: {"Ok": function(){$(this).dialog("close");} }
			});
			setTimeout(function() {
				$("#dialog").dialog("close");
			}, 1000);
		}
	}
	return result.success;
}

/*========================== 엑셀 출력 ============================*/
/**
 * 여러Sheet ExcelDownload
 * @param actionUrl
 * @param fieldSearchParamArray
 */
function FnAllSheetExportExcelToSvc(actionUrl, fieldSearchParamArray) {
	var frm = document.createElement("form");
	frm.name="excelForm";
	frm.method="post";
	frm.action=actionUrl;
	frm.target="_self"; 
	for(i = 0 ; i < fieldSearchParamArray.length ; i++){
		var fieldSearchParamArrayObj = document.createElement("input");
		fieldSearchParamArrayObj.type="hidden";
		fieldSearchParamArrayObj.name=fieldSearchParamArray[i];
		
		if($('input[name="'+fieldSearchParamArray[i]+'"]').attr("type")=='radio') {
			fieldSearchParamArrayObj.value = $(':radio[name="'+fieldSearchParamArray[i]+'"]:checked').val();
		} else {
			if($('#' + fieldSearchParamArray[i]).val() != undefined){
				fieldSearchParamArrayObj.value=$('#' + fieldSearchParamArray[i]).val();
			}
		}
		frm.insertBefore(fieldSearchParamArrayObj, null);
	}
	document.body.insertBefore(frm, null);
	frm.submit();
}

/**
 * 엑셀 출력
 * @param gridObject(그리드 : $(#list))
 * @param colLabels(출력컬럼명 배열)
 * @param colIds(출력되는 컬럼의 ID 배열)
 * @param numColIds(숫자 ID 배열)
 * @param sheetTitle(시트명)
 * @param excelFileName(엑셀파일명)
 * @param contextPath
 * @param figureColIds
 */
function fnExportExcel(gridObject, colLabels, colIds, numColIds, sheetTitle, excelFileName, contextPath, figureColIds) {
	var colDatas = new Array();	//Data값(2차원 배열)
	var rowIds = gridObject.getDataIDs();	//컬럼ID 및 Data
	for(var i=0;i<rowIds.length;i++) {
		var selrowContent = gridObject.jqGrid('getRowData',rowIds[i]);
		var subColDataString = "";
		for(var j=0;j<colIds.length;j++) {
			var inputValue = selrowContent[colIds[j]];
			if(inputValue==null || inputValue==''){ 
				inputValue = " ";
			}else{
				inputValue = inputValue.replace(/[<][^>]*[>]/gi, '');			}
			/*	Edit Row일 경우 값을 값을 추출해야 함(그러나 select box의 경우 값을 반환하지 않음)
			var inputValue = selrowContent[colIds[j]].toUpperCase();
			if(inputValue.indexOf("<INPUT")>=0) {	//Row가 edit 상태일 경우
				var inputId = rowIds[i]+"_"+colIds[j];
				inputValue = $("#"+inputId).val();
			}
			*/
			if(subColDataString=="") subColDataString = inputValue;
			else subColDataString = subColDataString + "∥" + inputValue;
		}
		colDatas[i] = subColDataString;
	}
	var frm = document.createElement("form");
	frm.name="excelForm";
	frm.method="post"; 
	frm.action=contextPath+"/common/commonExcelExport.sys"; 
	frm.target="_self"; 
	
	var sheetTitleObj=document.createElement("input");
	sheetTitleObj.type="hidden";
	sheetTitleObj.name="sheetTitle";
	sheetTitleObj.value=sheetTitle;
	frm.insertBefore(sheetTitleObj, null);
	
	var excelFileNameObj=document.createElement("input");
	excelFileNameObj.type="hidden";
	excelFileNameObj.name="excelFileName";
	excelFileNameObj.value=excelFileName;
	frm.insertBefore(excelFileNameObj, null);
	
	for(var i=0;i<colLabels.length;i++) {
		var colLabelsObj=document.createElement("input");
		colLabelsObj.type="hidden"; 
		colLabelsObj.name="colLabels"; 
		colLabelsObj.value=colLabels[i];
		frm.insertBefore(colLabelsObj, null);
	}
	for(var i=0;i<colIds.length;i++) {
		var colIdsObj=document.createElement("input");
		colIdsObj.type="hidden";
		colIdsObj.name="colIds";
		colIdsObj.value=colIds[i];
		frm.insertBefore(colIdsObj, null);
	}
	for(var i=0;i<numColIds.length;i++) {
		var numColIdsObj=document.createElement("input");
		numColIdsObj.type="hidden";
		numColIdsObj.name="numColIds";
		numColIdsObj.value=numColIds[i];
		frm.insertBefore(numColIdsObj, null);
	}
	if(figureColIds!=null && figureColIds.length>0) {
		for(var i=0;i<figureColIds.length;i++) {
			var figureColIdsObj=document.createElement("input");
			figureColIdsObj.type="hidden";
			figureColIdsObj.name="figureColIds";
			figureColIdsObj.value=figureColIds[i];
			frm.insertBefore(figureColIdsObj, null);
		}
	}
	for(var i=0;i<colDatas.length;i++) {
		var colDatasObj=document.createElement("input");
		colDatasObj.type="hidden"; 
		colDatasObj.name="colDatas"; 
		colDatasObj.value=colDatas[i];
		frm.insertBefore(colDatasObj, null);
	}
	document.body.insertBefore(frm, null);
	frm.submit();
}


/**
 * 엑셀 출력(페이징 없이 서비스를 통해서 조회된 내용 엑셀로 만들때 사용)
 * @param gridObject(그리드 : $(#list))
 * @param colLabels(출력컬럼명 배열)
 * @param colIds(출력되는 컬럼의 ID 배열)
 * @param numColIds(숫자 ID 배열, ex)[###,###])
 * @param sheetTitle(시트명)
 * @param excelFileName(엑셀파일명)
 * @param fieldSearchParamArray(필드조회조건)
 * @param actionUrl(controller Url : general controller를 쓰지 않을 경우)
 * @param contextPath
 * @param figureColIds(숫자 ID 배열, ex)[######])
 */
function fnExportExcelToSvc(gridObject, colLabels, colIds, numColIds, sheetTitle, excelFileName, contextPath, fieldSearchParamArray, actionUrl, figureColIds) {
	var frm = document.createElement("form");
	frm.name="excelForm";
	frm.method="post"; 
	var sidx = "";
	var sord = "";
	if(actionUrl!=null && actionUrl.length>0) {}
	else actionUrl = gridObject.jqGrid("getGridParam", "url").substring(0,gridObject.jqGrid("getGridParam", "url").lastIndexOf("/")+1) + "excel.sys";
	
	if(gridObject!=null && gridObject!="" && gridObject!=undefined) {
		sidx = gridObject.jqGrid("getGridParam", "sortname");
		sord = gridObject.jqGrid("getGridParam", "sortorder");
	}
	
	frm.action=contextPath+actionUrl; 
	frm.target="_self"; 
	
	var sheetTitleObj=document.createElement("input");
	sheetTitleObj.type="hidden";
	sheetTitleObj.name="sheetTitle";
	sheetTitleObj.value=sheetTitle;
	frm.insertBefore(sheetTitleObj, null);
	
	var excelFileNameObj=document.createElement("input");
	excelFileNameObj.type="hidden";
	excelFileNameObj.name="excelFileName";
	excelFileNameObj.value=excelFileName;
	frm.insertBefore(excelFileNameObj, null);
	
	var excelSidxObj=document.createElement("input");
	excelSidxObj.type="hidden";
	excelSidxObj.name="sidx";
	excelSidxObj.value=sidx;
	frm.insertBefore(excelSidxObj, null);
	
	var excelSordObj=document.createElement("input");
	excelSordObj.type="hidden";
	excelSordObj.name="sord";
	excelSordObj.value=sord;
	frm.insertBefore(excelSordObj, null);
	
	for(var i=0;i<colLabels.length;i++) {
		var colLabelsObj=document.createElement("input");
		colLabelsObj.type="hidden"; 
		colLabelsObj.name="colLabels"; 
		colLabelsObj.value=colLabels[i];
		frm.insertBefore(colLabelsObj, null);
	}
	for(var i=0;i<colIds.length;i++) {
		var colIdsObj=document.createElement("input");
		colIdsObj.type="hidden";
		colIdsObj.name="colIds";
		colIdsObj.value=colIds[i];
		frm.insertBefore(colIdsObj, null);
	}
	for(var i=0;i<numColIds.length;i++) {
		var numColIdsObj=document.createElement("input");
		numColIdsObj.type="hidden";
		numColIdsObj.name="numColIds";
		numColIdsObj.value=numColIds[i];
		frm.insertBefore(numColIdsObj, null);
	}
	if(figureColIds!=null && figureColIds.length>0) {
		for(var i=0;i<figureColIds.length;i++) {
			var figureColIdsObj=document.createElement("input");
			figureColIdsObj.type="hidden";
			figureColIdsObj.name="figureColIds";
			figureColIdsObj.value=figureColIds[i];
			frm.insertBefore(figureColIdsObj, null);
		}
	}
	
	for(var i = 0 ; i < fieldSearchParamArray.length ; i++){
		var fieldSearchParamArrayObj = document.createElement("input");
		fieldSearchParamArrayObj.type="hidden";
		fieldSearchParamArrayObj.name=fieldSearchParamArray[i];
		
		if($('input[name="'+fieldSearchParamArray[i]+'"]').attr("type")=='radio') {
			fieldSearchParamArrayObj.value = $(':radio[name="'+fieldSearchParamArray[i]+'"]:checked').val();
		} else {
			if($('#' + fieldSearchParamArray[i]).val() != undefined){
				fieldSearchParamArrayObj.value=$('#' + fieldSearchParamArray[i]).val();
			}
		}
		frm.insertBefore(fieldSearchParamArrayObj, null);
	}
	document.body.insertBefore(frm, null);
	frm.submit();
}


/**
 * 숫자만 입력
 * @param event
 * @returns {Boolean}
 */
function onlyNumber(event) {
	var key = window.event ? event.keyCode : event.which;    
	if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
	|| key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
	|| key  == 8  || key  == 46 || key  == 9) // del, back space, Tab
	) {
		return true;
	}else {
	    return false;
	}    
};

/**
 * 숫자, '-' 만 입력
 * @param event
 * @returns {Boolean}
 */
function onlyNumberForSum(event) {
	var key = window.event ? event.keyCode : event.which;
	if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
			|| key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
			|| key  == 8  || key  == 46 || key  == 9 || key == 109 || key == 189) // del, back space, Tab, -
	) {
		return true;
	}else {
		return false;
	}    
};

/**
 * 주문번호로 상세정보 호출
 * @param orderIdenNum([주문번호]-[주문차수])
 * @param menuId(화면메뉴ID)
 */
function fnOrderDetailView(orderIdenNum, menuId, purcNum) {
	if(purcNum==undefined) purcNum = "";
  	var popurl = "/order/orderRequest/orderDetail.sys?orde_iden_numb=" + orderIdenNum + "&_menuId="+menuId+"&purc_iden_numb="+purcNum;
  	var winL = (screen.width-900)/2;
  	var winT = (screen.width-700)/2;
	var win = window.open(popurl, "주문상세", "left="+winL+",top="+winT+",width=900,height=700,history=no,resizable=no,status=no,scrollbars=yes,menubar=no");
	win.focus();
}

/**
 * 상품코드로 상품상세정보 호출
 * @param productCode([상품코드])
 * @param menuId(화면메뉴ID)
 * @param vendorId(공급사ID) : 상품상세에서 제공되는 공급사 지정
 * @param biddid() : 입찰 id
 * @param bid_vendorid() : 입찰 공급사 id 
 */
function fnProductDetailView(menuId , productCode, vendorId , bidid , bid_vendorid , req_good_id ) {
	//if(productCode=='') {alert("해당 상품은 삭제 되었습니다."); return;}
    /* updated 2015.11.20
	var popurl = "/productManage/productDetail.sys?_menuId="+menuId;
    */
	var popurl = "/product/popProductAdm.sys?_menuId="+menuId;
	var popproperty = "width=917,height=800,scrollbars=yes,status=no,resizable=no";
	
    if(productCode != undefined)    popurl+="&good_iden_numb="+productCode; 
    if(vendorId != undefined)       popurl+="&vendorid="+vendorId;            
    if(bidid != undefined)          popurl+="&bidid="+bidid;                  
    if(bid_vendorid != undefined)   popurl+="&bid_vendorid="+bid_vendorid;    
    if(req_good_id  != undefined)   popurl+="&req_good_id="+req_good_id;                             
    
	var win = window.open(popurl,'window',popproperty);
	win.focus();
}

/**
 * 공급사 상품 등록요청 상세 팝업을 호출
 * @param menuId(화면메뉴ID)
 * @param req_good_id([등록요청 SEQ])
 */
function fnReqProductDetailView(menuId , req_good_id) {
	var popurl = "/productManage/venProductRegist.sys?_menuId="+menuId;
	popurl+="&req_good_id="+req_good_id; 
	var popproperty = "width=1070,height=800,scrollbars=yes,status=no,resizable=no;";
	var win =  window.open(popurl,'window',popproperty);
	win.focus();
}

/**
 * 고객사 상품등록요청 상세 팝업을 호출
 * @param menuId(화면메뉴ID)
 * @param good_iden_numb([상품코드])
 * @param vendorid([공급사ID])
 * @param disp_good_id([상품진열 SEQ])
 */
function fnCustProductDetailView(menuId, good_iden_numb, vendorid, isEdit) {
	var disp_good_id = "";
	if((vendorid == undefined) && (isEdit == undefined)) {
		disp_good_id = good_iden_numb;
	} else {
		var ajaxRtn = $.ajax({
			url: "/common/getDispGoodId.sys",
			cache: false,
			data: "good_iden_numb="+good_iden_numb+"&vendorid="+vendorid,
			async: false
		}).responseText;
		var displayGoodList = eval('(' + ajaxRtn + ')').displayGoodList;
		if(displayGoodList!=null && displayGoodList!='') {
			disp_good_id = displayGoodList[0].disp_good_id;
		}
	}
	
    if(disp_good_id == '' || disp_good_id == '0' || disp_good_id == 'undefined') {
        alert('해당상품은 종료 되었습니다.');
        return;
    }
    
	var popurl = "/product/goProductDetailForBuyer.sys?_menuId=13610&disp_good_id="+disp_good_id;
	
	if(isEdit != undefined)	popurl += "&isEdit="+isEdit;
	
//	var popproperty = "dialogWidth:950px;dialogHeight=700px;scroll=yes;status=no;resizable=no;";
//    var vReturn =  window.showModalDialog(popurl,window,popproperty);
	var popproperty = "width=1000,height=700px,scrollbars=yes,status=no,resizable=no;";
	var win = window.open(popurl, 'window', popproperty);
	win.focus();
}

/**
 * 공급사 상품등록 상세 팝업을 호출
 * @param menuId(화면메뉴ID)
 * @param good_iden_numb([상품 SEQ])
 * @param vendorid([공급사 SEQ])
 */
function fnVendorProductDetailView(menuId , good_iden_numb , vendorid) {
	var popurl = "/productManage/vendorProductDetailInfo.sys?_menuId="+menuId+"&good_iden_numb="+good_iden_numb+"&vendorid="+vendorid;
//    var popproperty = "dialogWidth:1050px;dialogHeight=740px;Scroll=auto;status=no;resizable=no;";
//    var vReturn =  window.showModalDialog(popurl,self,popproperty);
//    if (vReturn == 'success'){
//        fnReLoadDataGrid(); 
//    }
//	var popproperty = "width=750, height=550, scrollbars=yes, status=no, resizable=no";
	var win = window.open(popurl, 'window','width=1050, height=760, scrollbars=yes, status=no, resizable=no');
	win.focus();
}

/**
 * 승인 상세 팝업 호출시 
 * @param menuId(화면메뉴ID)
 * @param app_good_id([상품 SEQ])
 */
function fnAppGoodView(menuId , app_good_id ) {
    var popurl = "/productApp/productAppDetail.sys?_menuId="+menuId+"&app_good_id="+app_good_id;
    var popproperty = "dialogWidth:1050px;dialogHeight=500px;Scroll=auto;status=no;resizable=no;";
    var vReturn =  window.showModalDialog(popurl,self,popproperty);
    if (vReturn == 'success'){
        fnReLoadDataGrid(); 
     }
}


/**
 * 공인인증서 처리 절차확인 함수(동기식 처리)
 * @param svcTypeCd(서비스타입코드)
 * @param borgId(조직아이디)
 * return (0:인증서생성절차, 1:인증처리절차, 2:공인인증절차스킵, 9:에러)
 */
function fnGetIsExistPublishAuth(svcTypeCd, borgId) {
	if("BUY"!=svcTypeCd && "VEN"!=svcTypeCd) return "2";
	var ajaxRtn = $.ajax({
		url: "/common/getIsExistPublishAuth.sys",
		cache: false,
		data: "svcTypeCd="+svcTypeCd+"&borgId="+borgId,
		async: false
	}).responseText;
	var result = eval('(' + ajaxRtn + ')').customResponse;
	var returnMsg = "";
	for (var i = 0; i < result.message.length; i++) {
		returnMsg +=  result.message[i];
	}
	if(returnMsg!="") {
		alert(returnMsg);
		return "9";
	}
	if(result.success == false) return "0";
	else return "1";
}

/**
 * 
 * @param obj
 */
function fnGetCharByte(obj, endIdx){
	
	if(obj.length > endIdx){
		return obj.substring(0, endIdx);
	}else{
		return obj;
	}
}

/**
 * 구매사 사업장 상세 팝업 호출
 * @param menuId
 * @param branchsId
 */
function fnBranchDetailView(menuId, branchId){
	var popurl = "/organ/organBranchDetail.sys?_menuId="+menuId+"&branchId=" + branchId;
	window.open(popurl, 'okplazaPop', 'width=920, height=800, scrollbars=yes, status=no, resizable=no');
}


/**
 * 공급사 상세 팝업 호출
 * @param menuId
 * @param vendorId
 */
function fnVendorDetailView(menuId, vendorId){
	var popurl = "/organ/organVendorDetail.sys?_menuId="+menuId+"&vendorId="+vendorId;
	window.open(popurl, 'okplazaPop', 'width=920, height=670, scrollbars=yes, status=no, resizable=no');
}
$.extend($.fn, {
validate: function() {
	var result = true;
	var obj = this.find('[required],[requiredNumber]');
	var frm = $(this);
	obj.each(function() {
		var type = $(this).attr('type');
		if (type != null && type.toLowerCase() == 'radio') {
			if (frm.find('input[name='+$(this).attr('name')+']:checked').length == 0) {
				alert($(this).attr("title") + "을(를) 선택해주세요.");
				$(this).focus();
				result = false;
				return false;
			}
		} else if ($(this).val().length == 0) {
			if ($(this).get(0).tagName == "SELECT") {
				alert($(this).attr("title") + "을(를) 선택해주세요.");
			} else {
				alert($(this).attr("title") + "을(를) 입력해주세요.");
			}
			$(this).focus();
			result = false;
			return false;
		}
    });

	if (result) {
		obj = this.find('[requiredNumber],[number]');
		obj.each(function() {
			if (!isNumber($(this).val())) {
				alert($(this).attr("title") + "은(는) 숫자만 입력가능합니다.");
				$(this).focus();
				result = false;
				return false;
			}
        });
	}
	return result;
}
,	search:function (ret) {
	if (!ret) {
		ret = function () {
			fnSearch();
		};
	}
	var inputs = $(this).find("input").not(":hidden,[readonly]");
	inputs.bind("keyup", function (e) {
		if (e.keyCode == 13) {
			ret();
			$(this).focus().select();
		}
	});
	var selects = $(this).find("select").not("[name=rows]");
	selects.bind("change", function (e) {
		ret();
	});
	
	inputs.first().focus().select();
}
,	serializeObject:function () {
   var o = {};
   var a = this.serializeArray();
   $.each(a, function() {
       if (o[this.name]) {
           if (!o[this.name].push) {
               o[this.name] = [o[this.name]];
           }
           o[this.name].push(this.value || '');
       } else {
           o[this.name] = this.value || '';
       }
   });
   return o;
}
});
function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}


/**
 * 동적 폼을 이용하여 페이지 이동을 처리한다.
 *
 * @param url : 이동할 페이지 url
 * @param param : 이동시 가지고 갈 파라미터(a=1&b=2)
 * @param target : 이동할 타겟
 */
function fnDynamicForm(url, param, target){
	var body = document.getElementsByTagName("body")[0];
	var form = fnGetDynamicForm(url, param, target);

	body.appendChild(form);

	form.submit();

	body.removeChild(form);
}

/**
 * 동적 form을 생성하여 반환하는 메소드
 *
 * @param url
 * @param param
 * @param target
 * @return form
 */
function fnGetDynamicForm(url, param, target){
	var form           = document.createElement("form");
	var paramArray     = param.split("&");
	var i              = 0;
	var paramInfoArray = null;

	if((target == null) || (target == "")){
		target = "_self";
	}

	for(i = 0; i < paramArray.length; i++){
		var input = document.createElement("input");

		paramInfoArray = paramArray[i].split("=");
		
		if(paramInfoArray[i] != undefined){
			if(paramInfoArray[i].indexOf("\n") != -1){
				input = document.createElement("textarea");
			}else{
				input.type     = "hidden";
			}
		}

		input.name     = paramInfoArray[0];
		input.value    = paramInfoArray[1];

		form.appendChild(input);
	}

	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
}

//3자리수마다 콤마
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

/**
 * 전화번호를 입력받아 '-' 입력
 * ex1) 021234567   -> 02-123-4567
 * ex2) 01012345678  ->010-1234-5678
 * @param num
 * @returns
 */
function fnSetTelformat( num ){
	return num.replace(/(^02.{0}|^01.{1}|^0[3-9]{1}.{1})([0-9]{3,4})([0-9]{4})/,"$1-$2-$3");
}
/**
 * 컬럼 정보를 LocalStorage에 저장한다. 
 */
function fnSaveColumn(objid) {
	if (localStorage) {
		var colModel = $(objid).jqGrid('getGridParam','colModel');
		localStorage.setItem(location.pathname + objid, JSON.stringify(colModel));
	}
}

/**
 * 저장되어 있는 컬럼정보가 있다면 LocalStorage에서 가져온다. 
 */
function fnLoadColumn(objid, rownumbers) {
	if (localStorage) {
		var data = localStorage.getItem(location.pathname + objid);
		if (data) {
			data = jQuery.parseJSON(data);
			if (rownumbers) {
				data.shift();
			}
			return data;
		} else {
			return null;
		}
	} else {
		return null;
	}
}

/**
 * <pre>
 * 페이징 처리를 위한 시작과 종료 페이지 정보를 반환하는 메소드
 * 
 * ~. return Object 구조
 *   !. startPage (시작페이지, number)
 *   !. endPage (종료페이지, number)
 * </pre>
 * 
 * @param currPage (현재페이지)
 * @param total (총 페이지)
 * @param pageDisplayLength (화면하단 표시되는 페이지 수)
 * @return Object
 */
function fnPagerInfo(currPage, total, pageDisplayLength){
	var returnObject = new Object();
	var pageGrp      = Math.ceil(currPage / pageDisplayLength);
	var startPage    = (pageGrp - 1) * pageDisplayLength + 1;
	var endPage      = (pageGrp - 1) * pageDisplayLength + 5;
	
	if(Number(endPage) > Number(total)){
		endPage = total;
	}
	
	returnObject.startPage = startPage;
	returnObject.endPage   = endPage;
	
	return returnObject;
}


/*
 * 페이징(Paser) 사용을 위한 공통 함수
 * 
 * @author : 
 * @source : 
*/ 
function fnPager(startPage, endPage, currPage, total, fnName){
	var pagerStr = "";
	for(var j = startPage; j <= endPage; j++){
		if(j==startPage){
			pagerStr += "<ol>";
			if(Number(currPage) > 1){
				pagerStr += "<li class='PageNumBtn'>";
				pagerStr += "<a href='#' title='첫페이지' onClick='"+fnName+"(1);'>";
				pagerStr += "<img src='/img/contents/btn_page_start.gif' alt='첫페이지' style='vertical-align:middle;'/>";
				pagerStr += "</a>";
				pagerStr += "<a href='#' title='이전' onclick='"+fnName+"("+(currPage == 1 ? 1 : (currPage-1))+");'>"
				pagerStr += "<img src='/img/contents/btn_page_back.gif' alt='이전' style='vertical-align:middle;'/>";
				pagerStr += "</a>";
				pagerStr += "</li>";
			}
		}
		if(j == currPage){
			pagerStr += "<li class='Active'>"+j+"</li>";
		}else{
			pagerStr += "<li><a href='#' onclick='"+fnName+"("+j+")'>"+j+"</a></li>";
		}
		if(j==endPage){
			if(currPage != total && total!=0 ){
				pagerStr +="<li class='PageNumBtn'>";
				pagerStr +="<a href='#' title='다음' onclick='"+fnName+"("+(currPage+1)+");'>";
				pagerStr +="<img src='/img/contents/btn_page_next.gif' alt='다음' style='vertical-align:middle;'/>";
				pagerStr +="</a>";
				pagerStr +="<a href='#' title='마지막페이지' onclick='"+fnName+"("+total+");'>";
				pagerStr +="<img src='/img/contents/btn_page_last.gif' alt='마지막페이지' style='vertical-align:middle;'/>";
				pagerStr +="</a>";
				pagerStr +="</li>";
			}
			pagerStr += "</ol>";
		}
	}
	$("#pager").append(pagerStr);	
}


/*
 * 상품상세 팝업 위한 공통 함수
 * 
 * @author : hong
 * @source : 
 * @date   : 2015-12-16 
*/ 
function fnPdtSimpleDetailPop(num) {
    var url = '/product/popProductVen.sys?good_iden_numb=' + num;
    var win = window.open(url, 'venPop', 'width=917, height=750, scrollbars=yes, status=no, resizable=no');
    win.focus();
}

/**
 * 특정 요소가 화면에 얼마나 보여지는지 여부를 반환하는 메소드
 * JQuery 기반의 함수
 * 실전 Jquery 쿡북 227 페이지 소스 참조
 * 
 * ~. return 객체 정보
 * {
 * 	vertical : 보여지는 높이의 비율, 숫자
 * 	horizontal : 보여지는 너비의 비율, 숫자
 * }
 * 
 * @param id (String)
 * @return 비율값(객체)
 */
function fnViewPercent(id){
	var result                   = new Object();
	var viewPortWidth            = $(window).width();
	var viewProtHeight           = $(window).height();
	var documentScrollTop        = $(document).scrollTop();
	var documentScrollLeft       = $(document).scrollLeft();
	var minTop                   = documentScrollTop;
	var maxTop                   = documentScrollTop + viewProtHeight;
	var minLeft                  = documentScrollLeft;
	var maxLeft                  = documentScrollLeft + viewPortWidth;
	var elementOffset            = $("#" + id).offset();
	var elementHeight            = $("#" + id).height();
	var elementWidth             = $("#" + id).width();
	var elementOffsetTop         = elementOffset.top;
	var elementOffsetLeft        = elementOffset.left;
	var verticalVisible          = null;
	var horizontalVisible        = null;
	var verticalVisiblePercent   = 0;
	var horizontalVisiblePercent = 0;
	
	if(
		(
			(
				(elementOffsetTop > minTop) &&
				(elementOffsetTop < maxTop)
			) ||
			(
				(elementOffsetTop + elementHeight > minTop) &&
				(elementOffsetTop + elementHeight < maxTop)
			)
		)
		&&
		(
			(
				(elementOffsetLeft > minLeft) &&
				(elementOffsetLeft < maxLeft)
			) ||
			(
				(elementOffsetLeft + elementWidth > minLeft) &&
				(elementOffsetLeft + elementWidth < maxLeft)
			)
		)
	){
		if(
			(elementOffsetTop >= minTop) &&
			(elementOffsetTop + elementHeight <= maxTop)
		){
			verticalVisible = elementHeight;
		}
		else if(elementOffsetTop < minTop){
			verticalVisible = elementHeight - (minTop - elementOffsetTop);
		}
		else{
			verticalVisible = maxTop - elementOffsetTop;
		}
		
		if(
			(elementOffsetLeft >= minLeft) &&
			(elementOffsetLeft + elementWidth <= maxLeft)
		){
			horizontalVisible = elementWidth;
		}
		else if(elementOffsetLeft < minLeft){
			horizontalVisible = elementWidth  - (minLeft - elementOffsetLeft);
		}
		else{
			horizontalVisible = maxLeft - elementOffsetLeft;
		}
		
		verticalVisiblePercent   = (verticalVisible / elementHeight) * 100;
		horizontalVisiblePercent = (horizontalVisible / elementWidth) * 100;
	}
	
	result.vertical   = verticalVisiblePercent;
	result.horizontal = horizontalVisiblePercent;
	
	return result;
}

function fnGetString(str, sub){
	
	var rtn = '';
	
	if( str == undefined || str == null || str == '' ){
		if ( sub != undefined && $.trim(sub) != '' ){
			rtn = sub;
		}
	}else{
		rtn = str;
	}
	
	return rtn;
}