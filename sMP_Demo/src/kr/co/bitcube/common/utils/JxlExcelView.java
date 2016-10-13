package kr.co.bitcube.common.utils;

import java.util.ArrayList;
import java.util.HashMap;
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
import oracle.sql.ARRAY;

import org.springframework.web.servlet.view.document.AbstractJExcelView;

public class JxlExcelView extends AbstractJExcelView {

	private int sheetNum = 0;
	
	@Override
	protected void buildExcelDocument(
			Map<String, Object> model,
			WritableWorkbook workbook, 
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String excelFileName = (String) model.get("excelFileName")+".xls";
		this.setFileNameToResponse(request, response, excelFileName);
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> sheetList = (List<Map<String, Object>>) model.get("sheetList");
		
		logger.debug("jameskang sheetList.size : "+sheetList.size());
		
		for(Map<String, Object> map:sheetList) {
			String sheetTitle = (String) map.get("sheetTitle");
			String[] colLabels = (String[]) map.get("colLabels");
			String[] colIds = (String[]) map.get("colIds");
			String[] numColIds = (String[]) map.get("numColIds");
			String[] figureColIds = (String[]) map.get("figureColIds");
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> colDataList = (List<Map<String, Object>>) map.get("colDataList");
			
			int totCount = colDataList.size();
			int maxSheetCount = 65000;
			int sheetCount = (int) (1 + Math.ceil(totCount/maxSheetCount));
			    
			ArrayList<ArrayList<Map<String, Object>>> totalList = new ArrayList<ArrayList<Map<String, Object>>>();
			ArrayList<Map<String, Object>> itemList = new ArrayList<Map<String, Object>>();

			int sCnt = 1;     
			for (int i = 0 ; i < totCount; i++){
				itemList.add((Map<String, Object>) colDataList.get(i));
		    	if (i == (maxSheetCount*sCnt) - 1){
		    		totalList.add((ArrayList<Map<String, Object>>)itemList);
		    		itemList = new ArrayList<Map<String, Object>>(); 
		    		sCnt++;
		    	} else if ( i == totCount - 1) {
		    		totalList.add((ArrayList<Map<String, Object>>)itemList);
		    	}     
			} 
			
			int cnt = 1;
			for(ArrayList<Map<String, Object>> excelList : totalList){
				String title = sheetTitle;
				if(sheetCount > 1){
					title += "_"+cnt;
				}
				this.createSheet(workbook, title, colLabels, colIds, numColIds, figureColIds, excelList);
				cnt++;
			}
			// 데이터가 없을시 오류 처리 by kkbum2000 20160629
			if (totalList.size() == 0) {
				this.createSheet(workbook, sheetTitle, colLabels, colIds, numColIds, figureColIds, null);
			}
		}
		workbook.write();
		workbook.close();
	}
	
	private void createSheet(
			WritableWorkbook workbook,
            String sheetTitle,
            String[] colLabels,
            String[] colIds,
            String[] numColIds,
            String[] figureColIds,
            List<Map<String, Object>> colDataList) throws Exception {
		
		logger.debug("jameskang sheetTitle : "+sheetTitle);
		sheetTitle = CommonUtils.nvl(sheetTitle,"sheet1");
		
		WritableSheet jxlSheet = workbook.createSheet(sheetTitle, sheetNum++);
		
		int rowNum = 0;
		/*------------------------------타이틀 작성-------------------------------*/
		if(!"sheet1".equals(sheetTitle)) {
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
			Label title = new Label(0, rowNum++, sheetTitle, titleFormat);
			jxlSheet.addCell(title);
		}
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
			Label colTitle = new Label(i, rowNum, colLabels[i], colTitleFormat);
			jxlSheet.addCell(colTitle);
		}
		rowNum++;
		
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
		
		WritableCellFormat figureFormat = new WritableCellFormat(new NumberFormat("0"));
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
							jxl.write.Number moneyType = new jxl.write.Number(cellCnt++, rowNum+rowCnt, Double.parseDouble(String.valueOf(dataMap.get(colId))),numberFormat);
							jxlSheet.addCell(moneyType);
						} else {
							dataLabel = new Label(cellCnt++, rowNum+rowCnt, String.valueOf(dataMap.get(colId)==null ? "" : dataMap.get(colId)), rightFormat);
							jxlSheet.addCell(dataLabel);
						}
					} else if(isFigure) {
						String tmpData = String.valueOf(dataMap.get(colId)==null ? "" : dataMap.get(colId));
//						System.out.println( ">>>>        tmpData    ::  " + tmpData );
						if("".equals(tmpData.trim())) {
							dataLabel = new Label(cellCnt++, rowNum+rowCnt, tmpData, figureFormat);
							jxlSheet.addCell(dataLabel);
						} else {
							jxl.write.Number figureType = new jxl.write.Number(cellCnt++, rowNum+rowCnt, Double.parseDouble(tmpData),figureFormat);
							jxlSheet.addCell(figureType);
						}
					} else {
						String tempString = String.valueOf(dataMap.get(colId)==null ? "" : dataMap.get(colId));
						tempString = tempString.replaceAll("&gt;", ">");
						dataLabel = new Label(cellCnt++, rowNum+rowCnt, tempString, stringFormat);
						jxlSheet.addCell(dataLabel);
					}
				}
				rowCnt++;
			}
		}
		
		sheetAutoFitColumns(jxlSheet, colLabels);
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
	        if (longestStrLen > 20)
	            longestStrLen = 20;
	        
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
	
	public static void main(String[] args) {
		int i = 1;
		int sheetCount = i % 65000 > 0 ? i / 65000 + 1 : i / 65000;
		
		int tmp = i % 65000;
		
		System.out.println(tmp);
	}
}
