/* Korean initialisation for the jQuery calendar extension. */
/* Written by DaeKwon Kang (ncrash.dk@gmail.com). */
jQuery(function($){
	//2009년을 시작날짜로 만들기 위한펑션
	function date(){
		var getDate = new Date();
		var startDate = new Date('2009-01-01');
		var interval = getDate - startDate;
		var day = 1000*60*60*24;
//		var month = day*30;
//		var year = month*12;
		return parseInt(interval/day);
	}
	
	$.datepicker.regional['ko'] = {
		showOn: "both", // 버튼과 텍스트 필드 모두 캘린더를 보여준다.
		buttonImage: "/application/db/jquery/images/calendar.gif", // 버튼 이미지
		buttonImageOnly: true, // 버튼에 있는 이미지만 표시한다.
		changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
		changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
		minDate: '-100y', // 현재날짜로부터 100년이전까지 년을 표시한다.
		//maxDate: '1m', // 현재날짜로부터 100년이전까지 년을 표시한다.
		nextText: '다음 달', // next 아이콘의 툴팁.
		prevText: '이전 달', // prev 아이콘의 툴팁.
		numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
		stepMonths: 1, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가. 
		yearRange: '2009:c+10', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
		showButtonPanel: true, // 캘린더 하단에 버튼 패널을 표시한다. 
		currentText: '오늘 날짜' , // 오늘 날짜로 이동하는 버튼 패널
		closeText: '닫기',  // 닫기 버튼 패널
		dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
		showAnim: "slide", //애니메이션을 적용한다.
		showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다. 
		dayNamesMin: ['일','월', '화', '수', '목', '금', '토'], // 요일의 한글 형식.
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] // 월의 한글 형식.
	};
	$.datepicker.setDefaults($.datepicker.regional['ko']);
});

