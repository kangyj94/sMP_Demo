package kr.co.bitcube.common.utils;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Cell;
import jxl.CellView;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.ScriptStyle;
import jxl.format.UnderlineStyle;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.NumberFormat;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import org.springframework.web.servlet.view.document.AbstractJExcelView;

public class JxlExcelView2_bak extends AbstractJExcelView {

	@Override
	protected void buildExcelDocument(
			Map<String, Object> model,
			WritableWorkbook workbook, 
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String sheetTitle = (String) model.get("sheetTitle");
		String[] colLabels = (String[]) model.get("colLabels");
		String[] colIds = (String[]) model.get("colIds");
		String[] numColIds = (String[]) model.get("numColIds");
		String[] figureColIds = (String[]) model.get("figureColIds");
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> colDataList = (List<Map<String, Object>>) model.get("colDataList");
		
		/*------------------------------파일생성, 시트생성-------------------------------*/
		String excelFileName = (String) model.get("excelFileName")+".xls";
		setFileNameToResponse(request, response, excelFileName);
		WritableSheet jxlSheet = workbook.createSheet(sheetTitle, 0);
		
		/*------------------------------타이틀 작성-------------------------------*/
		WritableCellFormat titleFormat= new WritableCellFormat(new WritableFont(
				WritableFont.ARIAL,
				22,
				WritableFont.BOLD,
				false,
				UnderlineStyle.NO_UNDERLINE,
				Colour.BLACK,
				ScriptStyle.NORMAL_SCRIPT
				));
		titleFormat.setAlignment(Alignment.CENTRE);
		titleFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
		titleFormat.setBorder(Border.ALL, BorderLineStyle.THICK);
		titleFormat.setBackground(Colour.ICE_BLUE);
		jxlSheet.mergeCells(0, 0, colLabels.length-1, 0); 
		Label title = new Label(0, 0, sheetTitle, titleFormat);
		jxlSheet.addCell(title);
//		jxlSheet.setColumnView(0, 30);
		
		/*------------------------------컬럼명 작성-------------------------------*/
		WritableCellFormat colTitleFormat= new WritableCellFormat(new WritableFont(
				WritableFont.ARIAL,
				10,
				WritableFont.BOLD,
				false,
				UnderlineStyle.NO_UNDERLINE,
				Colour.BLACK,
				ScriptStyle.NORMAL_SCRIPT
				));
		colTitleFormat.setAlignment(Alignment.CENTRE);
		colTitleFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
		colTitleFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
		colTitleFormat.setBackground(Colour.SKY_BLUE);
		for(int i=0;i<colLabels.length;i++) {
			Label colTitle = new Label(i, 2, colLabels[i], colTitleFormat);
			jxlSheet.addCell(colTitle);
		}
		
		/*------------------------------데이타 작성-------------------------------*/
		WritableCellFormat stringFormat= new WritableCellFormat(new WritableFont(
				WritableFont.ARIAL,
				10,
				WritableFont.NO_BOLD,
				false,
				UnderlineStyle.NO_UNDERLINE,
				Colour.BLACK,
				ScriptStyle.NORMAL_SCRIPT
				));
		stringFormat.setAlignment(Alignment.LEFT);
		stringFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
		stringFormat.setBorder(Border.ALL, BorderLineStyle.THIN);

		WritableCellFormat rightFormat= new WritableCellFormat(new WritableFont(
				WritableFont.ARIAL,
				10,
				WritableFont.NO_BOLD,
				false,
				UnderlineStyle.NO_UNDERLINE,
				Colour.BLACK,
				ScriptStyle.NORMAL_SCRIPT
				));
		rightFormat.setAlignment(Alignment.RIGHT);
		rightFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
		rightFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
		
		WritableCellFormat numberFormat = new WritableCellFormat(new NumberFormat("###,##0"));
		numberFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
		numberFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
		
		WritableCellFormat figureFormat = new WritableCellFormat();
		figureFormat.setAlignment(Alignment.CENTRE);
		figureFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
		figureFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
		
		int rowCnt = 0;
//		int maxColumnWidth = 255*256;	//// The maximum column width for an individual cell is 255 characters 

		if(colDataList != null && colDataList.size() > 0){
			for(Map<String, Object> dataMap : colDataList) {
				int cellCnt = 0;
				for(String colId : colIds) {
					boolean isNumberic = false;
					if(numColIds!=null) {
						for(String numColId : numColIds) {
							if(colId.equals(numColId)) {
								isNumberic = true;
								break;
							}
						}
					}
					boolean isFigure = false;
					if(figureColIds!=null) {
						for(String figureColId : figureColIds) {
							if(colId.equals(figureColId)) {
								isFigure = true;
								break;
							}
						}
					}

					Label dataLabel = null;
					if(isNumberic) {
						if(dataMap.get(colId) != null && !"".equals(dataMap.get(colId).toString().trim())){
							jxl.write.Number moneyType = new jxl.write.Number(cellCnt++, 3+rowCnt, Double.parseDouble(String.valueOf(dataMap.get(colId))),numberFormat);
							jxlSheet.addCell(moneyType);
						} else {
							dataLabel = new Label(cellCnt++, 3+rowCnt, String.valueOf(dataMap.get(colId)==null ? "" : dataMap.get(colId)), rightFormat);
							jxlSheet.addCell(dataLabel);
						}
					} else if(isFigure) {
						String tmpData = String.valueOf(dataMap.get(colId)==null ? "" : dataMap.get(colId));
						if("".equals(tmpData.trim())) {
							dataLabel = new Label(cellCnt++, 3+rowCnt, tmpData, figureFormat);
							jxlSheet.addCell(dataLabel);
						} else {
							jxl.write.Number figureType = new jxl.write.Number(cellCnt++, 3+rowCnt, Double.parseDouble(tmpData),figureFormat);
							jxlSheet.addCell(figureType);
						}
					} else {
						String tempString = String.valueOf(dataMap.get(colId)==null ? "" : dataMap.get(colId));
						tempString = tempString.replaceAll("&gt;", ">");
						dataLabel = new Label(cellCnt++, 3+rowCnt, tempString, stringFormat);
						jxlSheet.addCell(dataLabel);
					}
				}
				rowCnt++;
			}
		}
		
		sheetAutoFitColumns(jxlSheet, colLabels);
		
		workbook.write();
		workbook.close();
	}
	
	private void sheetAutoFitColumns(WritableSheet sheet, String[] colLabels) {
	    
		for (int i = 0; i < sheet.getColumns(); i++) {
	        Cell[] cells = sheet.getColumn(i);
	        int longestStrLen = -1;

	        if (cells.length == 0)
	            continue;

	        // 전체 컨텐츠중 가장 긴 컨텐츠의 길이를 구해온다.
	        for (int j = 0; j < cells.length; j++) {
	            if ( cells[j].getContents().length() > longestStrLen ) {
	                String str = cells[j].getContents();
	                if (str == null || str.isEmpty())
	                    continue;
	                longestStrLen = cells[j].getContents().length();
	            }
	        }
	        
	        // 컨텐츠보다 컬럼헤더의 길이가 더 길면 헤더 기준으로 변경
	        for(int j=0;j<colLabels.length;j++) {
	        	if(longestStrLen < colLabels[j].length())
	        		longestStrLen = colLabels[j].length();
	        }

	        if (longestStrLen == -1) 
	            continue;

	        // 컨텐츠 길이가 255이상이면 255로 Fix
	        if (longestStrLen > 255)
	            longestStrLen = 255;
	        
	        CellView cv = sheet.getColumnView(i);
	        cv.setSize((longestStrLen + ((longestStrLen/2) + (longestStrLen/4))) * 256);
	        sheet.setColumnView(i, cv);
	    }
	}
	
	private void setFileNameToResponse(HttpServletRequest request, 
			HttpServletResponse response, String fileName) {
		String userAgent = request.getHeader("User-Agent");
		if (userAgent.indexOf("MSIE 5.5") >= 0) {
			response.setContentType("doesn/matter");
			response.setHeader("Content-Disposition","filename=\""+fileName+"\"");
		} else {
			response.setHeader("Content-Disposition","attachment; filename=\""+fileName+"\"");
		}
	}
}
