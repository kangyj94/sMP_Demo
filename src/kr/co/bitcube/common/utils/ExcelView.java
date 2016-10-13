package kr.co.bitcube.common.utils;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.web.servlet.view.document.AbstractExcelView;

public class ExcelView extends AbstractExcelView{

	/**
	 * 엑셀파일을 만들어 내려주는 뷰
	 * model에 excelContents라는 이름으로 String 객체가 존재하여야 한다.
	 * excelContents이름의 String 객체는 다음과 같은 형식으로 이루워져야 한다.
	 * 문자\t문자\t문자\t문자\t문자\t문자\n
	 * 문자\t문자\t문자\t문자\t문자\t문자\n
	 * 문자\t문자\t문자\t문자\t문자\t문자\n
	 */
	@Override
	protected void buildExcelDocument(
			Map<String, Object> model, 
			HSSFWorkbook workbook, 
			HttpServletRequest request, 
			HttpServletResponse response) throws Exception {
		
		/*--------------------Parameter Setting----------------------*/
		String excelFileName = (String) model.get("excelFileName")+".xls";
		String sheetTitle = (String) model.get("sheetTitle");
		String[] colLabels = (String[]) model.get("colLabels");
		String[] colIds = (String[]) model.get("colIds");
		String[] numColIds = (String[]) model.get("numColIds");
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> colDataList = (List<Map<String, Object>>) model.get("colDataList");
		
		/*--------------------Title Style Setting----------------------*/
		HSSFFont titleFont = workbook.createFont();
		titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
		titleFont.setFontHeightInPoints((short) 22);
		
		HSSFCellStyle titleStyle = workbook.createCellStyle();
		titleStyle.setAlignment(CellStyle.ALIGN_CENTER);
		titleStyle.setFont(titleFont);
		
		/*--------------------Data Title Style Setting----------------------*/
		HSSFFont dataTitleFont = workbook.createFont();
		dataTitleFont.setBoldweight(Font.BOLDWEIGHT_NORMAL);
		
		HSSFCellStyle dataTitleStyle = workbook.createCellStyle();
		dataTitleStyle.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
		dataTitleStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		dataTitleStyle.setAlignment(CellStyle.ALIGN_CENTER);
		dataTitleStyle.setFont(dataTitleFont);
		
		/*--------------------Data Style Setting----------------------*/
		//Data font
		HSSFFont dataFont = workbook.createFont();
		dataFont.setBoldweight(Font.BOLDWEIGHT_NORMAL);

		//center Style
		HSSFCellStyle dataCenterStyle = workbook.createCellStyle();
		dataCenterStyle.setAlignment(CellStyle.ALIGN_CENTER);
		dataCenterStyle.setFont(dataFont);
		
		//Left Style
		HSSFCellStyle dataLeftStyle = workbook.createCellStyle();
		dataLeftStyle.setAlignment(CellStyle.ALIGN_LEFT);
		dataLeftStyle.setFont(dataFont);
		dataLeftStyle.setWrapText(true); //개행 사용여부
		
		//Right Style
		HSSFCellStyle dataRightStyle = workbook.createCellStyle();
		dataRightStyle.setAlignment(CellStyle.ALIGN_RIGHT);
		dataRightStyle.setFont(dataFont);
		
		/*--------------------Excel File Create----------------------*/
		String userAgent = request.getHeader("User-Agent");
		if(userAgent.indexOf("MSIE 5.5") >= 0){
			response.setContentType("doesn/matter");
			response.setHeader("Content-Disposition","filename=\""+excelFileName+"\"");
		} else response.setHeader("Content-Disposition","attachment; filename=\""+excelFileName+"\"");
		
		HSSFSheet sheet = workbook.createSheet(sheetTitle); // sheet 생성
		HSSFRow row = null;
		HSSFCell cell = null;
		
		//Title Write
		Row titleRow = sheet.createRow((short) 0);
		Cell titleCell = titleRow.createCell((short) 0);
		titleCell.setCellValue(sheetTitle);
		titleCell.setCellStyle(titleStyle);
		titleRow.setHeight((short) 0x249);
		sheet.addMergedRegion(new CellRangeAddress(0,0,0,colLabels.length-1));
		
		//Data Title Write
		row = sheet.createRow(2); // row 생성
//		CellStyle headerStyle = workbook.createCellStyle();
		for(int i=0;i<colLabels.length;i++) {
			cell = row.createCell(i);
			cell.setCellType(Cell.CELL_TYPE_STRING);
			cell.setCellValue(colLabels[i]);

			dataTitleStyle.setBorderBottom(CellStyle.BORDER_THIN);
			dataTitleStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
			dataTitleStyle.setBorderLeft(CellStyle.BORDER_THIN);
			dataTitleStyle.setLeftBorderColor(IndexedColors.BLACK.getIndex());
			dataTitleStyle.setBorderRight(CellStyle.BORDER_THIN);
			dataTitleStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());
			dataTitleStyle.setBorderTop(CellStyle.BORDER_THIN);
			dataTitleStyle.setTopBorderColor(IndexedColors.BLACK.getIndex());
			cell.setCellStyle(dataTitleStyle);
		}
		
		DataFormat format = workbook.createDataFormat();
		CellStyle style = workbook.createCellStyle();
		//Data Write
		int rowCnt = 0;
		int maxColumnWidth = 255*256;	//// The maximum column width for an individual cell is 255 characters 
		
		if(colDataList != null && colDataList.size() > 0){
			for(Map<String, Object> dataMap : colDataList) {
				row = sheet.createRow(3+rowCnt++); // row 생성
				row.setHeight((short) 512);
				int cellCnt = 0;
				for(String colId : colIds) {
					//sheet.autoSizeColumn((short)cellCnt);
					//int columnWidth = sheet.getColumnWidth(cellCnt)+512;//(((dataMap.get(colId) == null ? "" : dataMap.get(colId)).toString().length()/5)*4) + 1;
					//if(columnWidth>maxColumnWidth) columnWidth = maxColumnWidth;
					//sheet.setColumnWidth(cellCnt, columnWidth);
					cell = row.createCell(cellCnt++);
					boolean isNumberic = false;
					if(numColIds!=null) {
						for(String numColId : numColIds) {
							if(colId.equals(numColId)) {
								isNumberic = true;
								break;
							}
						}
					}
					if(isNumberic) {
						cell.setCellStyle(dataRightStyle);
						
						if(dataMap.get(colId) != null && !"".equals(dataMap.get(colId).toString().trim())){
							cell.setCellType(Cell.CELL_TYPE_NUMERIC);
							cell.setCellValue(Double.parseDouble((String) dataMap.get(colId)));
							style.setDataFormat(format.getFormat("#,##0"));
							cell.setCellStyle(style);					
						}else{
							cell.setCellStyle(dataLeftStyle);
							cell.setCellType(Cell.CELL_TYPE_STRING);
							cell.setCellValue((String) dataMap.get(colId));						
						}
					} else {
						cell.setCellStyle(dataLeftStyle);
						cell.setCellType(Cell.CELL_TYPE_STRING);
						cell.setCellValue((String) dataMap.get(colId));
					}
					style.setWrapText(true);
					style.setBorderBottom(CellStyle.BORDER_THIN);
					style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
					style.setBorderLeft(CellStyle.BORDER_THIN);
					style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
					style.setBorderRight(CellStyle.BORDER_THIN);
					style.setRightBorderColor(IndexedColors.BLACK.getIndex());
					style.setBorderTop(CellStyle.BORDER_THIN);
					style.setTopBorderColor(IndexedColors.BLACK.getIndex());
					cell.setCellStyle(style);				
				}
			}
			for (int i=0;i<colIds.length;i++) //autuSizeColumn after setColumnWidth setting!!  
			{ 
				sheet.autoSizeColumn(i);
				if((sheet.getColumnWidth(i))+512 > maxColumnWidth)	sheet.setColumnWidth(i, maxColumnWidth);
				else												sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+512 );
			} 		
		}
	}
}
