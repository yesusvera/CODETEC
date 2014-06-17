#pragma once
#include "PDFObjc.h"
#include "PDFVFinder.h"
#include "PDFVPage.h"
#include "PDFVCanvas.h"
#include "PDFVThread.h"

@protocol PDFVInnerDel <NSObject>
-(void)OnPageDisplayed :(CGContextRef)ctx : (PDFVPage *)page;
@end

struct PDFV_POS
{
    int pageno;
    float x;
    float y;
};

@interface PDFV : NSObject
{
	int m_x;
	int m_y;
	int m_docw;
	int m_doch;
	int m_w;
	int m_h;
	int m_page_gap;
	int m_page_gap_half;
	int m_back_clr;
	int m_hold_vx;
	int m_hold_vy;
	int m_hold_x;
	int m_hold_y;
	float m_scale;
	float m_scale_min;
	float m_scale_max;
	float m_zoom_scale;
	PDFDoc *m_doc;
	NSMutableArray *m_pages;
	int m_pages_cnt;
	PDFVThread *m_thread;
	PDFVFinder *m_finder;
	id<PDFVInnerDel> m_del;
}
-(void)vResize:(int)w : (int)h;
-(void)vClose;
-(void)vOpen:(PDFDoc *) doc :(int)page_gap :(id<PDFVInnerDel>)notifier :(const struct PDFVThreadBack *)disp;
-(bool)vFindGoto;
-(void)vLayout;
-(void)vGetPos:(struct PDFV_POS *)pos :(int)x :(int)y;
-(void)vSetPos:(const struct PDFV_POS *)pos :(int)x : (int)y;
-(bool)vNeedRefresh;
-(void)vGetDelta:(int)delta :(int *)dx :(int *)dy;
-(void)vDraw:(PDFVCanvas *)canvas :(bool)zooming;
-(PDFVPage *)vGetPage:(int) pageno;
-(void)vFindStart:(NSString *)pat :(bool)match_case :(bool) whole_word;
-(int)vFind:(int) dir;
-(void)vFindEnd;
-(void)vOnTouchDown:(int)x : (int) y;
-(void)vOnTouchMove:(int)x : (int) y;
-(void)vGetDeltaToCenterPage:(int)pageno :(int *)dx :(int *)dy;
-(void)vMoveDelta:(int)dx :(int)dy;
-(void)vZoomStart;
-(float)vGetScale;
-(void)vSetScale:(float) scale;
-(void)vSetSel:(int)x1 :(int)y1 :(int)x2 :(int)y2;
-(void)vClearSel;
-(int)vGetX;
-(int)vGetY;
-(int)vGetDocW;
-(int)vGetDocH;
-(void)vRenderPage:(int)pageno;
@end

@interface PDFVVert: PDFV
{
}
-(void)vLayout;
-(void)vGetPos:(struct PDFV_POS *)pos :(int)x : (int)y;
-(void)vGetDelta:(int)delta :(int *)dx :(int *)dy;
@end

@interface PDFVHorz: PDFV
{
	bool m_rtol;
}
-(id)init:(bool)rtol;
-(void)vOpen:(PDFDoc *)doc :(int) page_gap :(id<PDFVInnerDel>)notifier :(const struct PDFVThreadBack *)disp;
-(void)vResize:(int)w :(int)h;
-(void)vLayout;
-(void)vGetPos:(struct PDFV_POS *)pos :(int)x :(int)y;
-(void)vGetDelta:(int)delta :(int *)dx :(int *)dy;
@end


@interface PDFVDual: PDFV
{
	bool *m_vert_dual;
	int m_vert_dual_cnt;
	bool *m_horz_dual;
	int m_horz_dual_cnt;
	bool m_rtol;
	struct PDFCell
	{
		int left;
		int right;
		int page_left;
		int page_right;
	}* m_cells;
	int m_cells_cnt;
}
-(id)init:(bool)rtol :(const bool *)verts :(int)verts_cnt :(const bool *)horzs :(int) horzs_cnt;
-(void)vClose;
-(void)vOpen:(PDFDoc *)doc :(int)page_gap :(id<PDFVInnerDel>)notifier :(const struct PDFVThreadBack *)disp;
-(void)vResize:(int)w : (int)h;
-(void)vLayout;
-(void)vGetPos:(struct PDFV_POS *)pos :(int)x : (int)y;
-(void)vGetDelta:(int)delta :(int *)dx :(int *)dy;
-(void)vGetDeltaToCenterPage:(int)pageno :(int *)dx :(int *)dy;
@end

@interface PDFVThmb: PDFV
{
	int m_orientation;
	int m_sel;
    bool m_rtol;
}
-(id)init:(int)orientation :(bool)rtol;
-(void)vOpen:(PDFDoc *) doc :(int)page_gap :(id<PDFVInnerDel>)notifier :(const struct PDFVThreadBack *)disp;
-(void)vClose;
-(void)vLayout;
-(void)vGetPos:(struct PDFV_POS *)pos :(int)x : (int)y;
-(void)vDraw:(PDFVCanvas *)canvas :(bool)zooming;
-(void)vSetSel:(int)pageno;
-(int)vGetSel;
-(void)vRenderPage:(int)pageno;
@end
