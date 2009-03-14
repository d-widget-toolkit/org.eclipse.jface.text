/*******************************************************************************
 * Copyright (c) 2006, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.jface.text.JFaceTextUtil;

import org.eclipse.jface.text.IDocumentPartitioningListener; // packageimport
import org.eclipse.jface.text.DefaultTextHover; // packageimport
import org.eclipse.jface.text.AbstractInformationControl; // packageimport
import org.eclipse.jface.text.TextUtilities; // packageimport
import org.eclipse.jface.text.IInformationControlCreatorExtension; // packageimport
import org.eclipse.jface.text.AbstractInformationControlManager; // packageimport
import org.eclipse.jface.text.ITextViewerExtension2; // packageimport
import org.eclipse.jface.text.IDocumentPartitioner; // packageimport
import org.eclipse.jface.text.DefaultIndentLineAutoEditStrategy; // packageimport
import org.eclipse.jface.text.ITextSelection; // packageimport
import org.eclipse.jface.text.Document; // packageimport
import org.eclipse.jface.text.FindReplaceDocumentAdapterContentProposalProvider; // packageimport
import org.eclipse.jface.text.ITextListener; // packageimport
import org.eclipse.jface.text.BadPartitioningException; // packageimport
import org.eclipse.jface.text.ITextViewerExtension5; // packageimport
import org.eclipse.jface.text.IDocumentPartitionerExtension3; // packageimport
import org.eclipse.jface.text.IUndoManager; // packageimport
import org.eclipse.jface.text.ITextHoverExtension2; // packageimport
import org.eclipse.jface.text.IRepairableDocument; // packageimport
import org.eclipse.jface.text.IRewriteTarget; // packageimport
import org.eclipse.jface.text.DefaultPositionUpdater; // packageimport
import org.eclipse.jface.text.RewriteSessionEditProcessor; // packageimport
import org.eclipse.jface.text.TextViewerHoverManager; // packageimport
import org.eclipse.jface.text.DocumentRewriteSession; // packageimport
import org.eclipse.jface.text.TextViewer; // packageimport
import org.eclipse.jface.text.ITextViewerExtension8; // packageimport
import org.eclipse.jface.text.RegExMessages; // packageimport
import org.eclipse.jface.text.IDelayedInputChangeProvider; // packageimport
import org.eclipse.jface.text.ITextOperationTargetExtension; // packageimport
import org.eclipse.jface.text.IWidgetTokenOwner; // packageimport
import org.eclipse.jface.text.IViewportListener; // packageimport
import org.eclipse.jface.text.GapTextStore; // packageimport
import org.eclipse.jface.text.MarkSelection; // packageimport
import org.eclipse.jface.text.IDocumentPartitioningListenerExtension; // packageimport
import org.eclipse.jface.text.IDocumentAdapterExtension; // packageimport
import org.eclipse.jface.text.IInformationControlExtension; // packageimport
import org.eclipse.jface.text.IDocumentPartitioningListenerExtension2; // packageimport
import org.eclipse.jface.text.DefaultDocumentAdapter; // packageimport
import org.eclipse.jface.text.ITextViewerExtension3; // packageimport
import org.eclipse.jface.text.IInformationControlCreator; // packageimport
import org.eclipse.jface.text.TypedRegion; // packageimport
import org.eclipse.jface.text.ISynchronizable; // packageimport
import org.eclipse.jface.text.IMarkRegionTarget; // packageimport
import org.eclipse.jface.text.TextViewerUndoManager; // packageimport
import org.eclipse.jface.text.IRegion; // packageimport
import org.eclipse.jface.text.IInformationControlExtension2; // packageimport
import org.eclipse.jface.text.IDocumentExtension4; // packageimport
import org.eclipse.jface.text.IDocumentExtension2; // packageimport
import org.eclipse.jface.text.IDocumentPartitionerExtension2; // packageimport
import org.eclipse.jface.text.Assert; // packageimport
import org.eclipse.jface.text.DefaultInformationControl; // packageimport
import org.eclipse.jface.text.IWidgetTokenOwnerExtension; // packageimport
import org.eclipse.jface.text.DocumentClone; // packageimport
import org.eclipse.jface.text.DefaultUndoManager; // packageimport
import org.eclipse.jface.text.IFindReplaceTarget; // packageimport
import org.eclipse.jface.text.IAutoEditStrategy; // packageimport
import org.eclipse.jface.text.ILineTrackerExtension; // packageimport
import org.eclipse.jface.text.IUndoManagerExtension; // packageimport
import org.eclipse.jface.text.TextSelection; // packageimport
import org.eclipse.jface.text.DefaultAutoIndentStrategy; // packageimport
import org.eclipse.jface.text.IAutoIndentStrategy; // packageimport
import org.eclipse.jface.text.IPainter; // packageimport
import org.eclipse.jface.text.IInformationControl; // packageimport
import org.eclipse.jface.text.IInformationControlExtension3; // packageimport
import org.eclipse.jface.text.ITextViewerExtension6; // packageimport
import org.eclipse.jface.text.IInformationControlExtension4; // packageimport
import org.eclipse.jface.text.DefaultLineTracker; // packageimport
import org.eclipse.jface.text.IDocumentInformationMappingExtension; // packageimport
import org.eclipse.jface.text.IRepairableDocumentExtension; // packageimport
import org.eclipse.jface.text.ITextHover; // packageimport
import org.eclipse.jface.text.FindReplaceDocumentAdapter; // packageimport
import org.eclipse.jface.text.ILineTracker; // packageimport
import org.eclipse.jface.text.Line; // packageimport
import org.eclipse.jface.text.ITextViewerExtension; // packageimport
import org.eclipse.jface.text.IDocumentAdapter; // packageimport
import org.eclipse.jface.text.TextEvent; // packageimport
import org.eclipse.jface.text.BadLocationException; // packageimport
import org.eclipse.jface.text.AbstractDocument; // packageimport
import org.eclipse.jface.text.AbstractLineTracker; // packageimport
import org.eclipse.jface.text.TreeLineTracker; // packageimport
import org.eclipse.jface.text.ITextPresentationListener; // packageimport
import org.eclipse.jface.text.Region; // packageimport
import org.eclipse.jface.text.ITextViewer; // packageimport
import org.eclipse.jface.text.IDocumentInformationMapping; // packageimport
import org.eclipse.jface.text.MarginPainter; // packageimport
import org.eclipse.jface.text.IPaintPositionManager; // packageimport
import org.eclipse.jface.text.TextPresentation; // packageimport
import org.eclipse.jface.text.IFindReplaceTargetExtension; // packageimport
import org.eclipse.jface.text.ISlaveDocumentManagerExtension; // packageimport
import org.eclipse.jface.text.ISelectionValidator; // packageimport
import org.eclipse.jface.text.IDocumentExtension; // packageimport
import org.eclipse.jface.text.PropagatingFontFieldEditor; // packageimport
import org.eclipse.jface.text.ConfigurableLineTracker; // packageimport
import org.eclipse.jface.text.SlaveDocumentEvent; // packageimport
import org.eclipse.jface.text.IDocumentListener; // packageimport
import org.eclipse.jface.text.PaintManager; // packageimport
import org.eclipse.jface.text.IFindReplaceTargetExtension3; // packageimport
import org.eclipse.jface.text.ITextDoubleClickStrategy; // packageimport
import org.eclipse.jface.text.IDocumentExtension3; // packageimport
import org.eclipse.jface.text.Position; // packageimport
import org.eclipse.jface.text.TextMessages; // packageimport
import org.eclipse.jface.text.CopyOnWriteTextStore; // packageimport
import org.eclipse.jface.text.WhitespaceCharacterPainter; // packageimport
import org.eclipse.jface.text.IPositionUpdater; // packageimport
import org.eclipse.jface.text.DefaultTextDoubleClickStrategy; // packageimport
import org.eclipse.jface.text.ListLineTracker; // packageimport
import org.eclipse.jface.text.ITextInputListener; // packageimport
import org.eclipse.jface.text.BadPositionCategoryException; // packageimport
import org.eclipse.jface.text.IWidgetTokenKeeperExtension; // packageimport
import org.eclipse.jface.text.IInputChangedListener; // packageimport
import org.eclipse.jface.text.ITextOperationTarget; // packageimport
import org.eclipse.jface.text.IDocumentInformationMappingExtension2; // packageimport
import org.eclipse.jface.text.ITextViewerExtension7; // packageimport
import org.eclipse.jface.text.IInformationControlExtension5; // packageimport
import org.eclipse.jface.text.IDocumentRewriteSessionListener; // packageimport
import org.eclipse.jface.text.AbstractReusableInformationControlCreator; // packageimport
import org.eclipse.jface.text.TabsToSpacesConverter; // packageimport
import org.eclipse.jface.text.CursorLinePainter; // packageimport
import org.eclipse.jface.text.ITextHoverExtension; // packageimport
import org.eclipse.jface.text.IEventConsumer; // packageimport
import org.eclipse.jface.text.IDocument; // packageimport
import org.eclipse.jface.text.IWidgetTokenKeeper; // packageimport
import org.eclipse.jface.text.DocumentCommand; // packageimport
import org.eclipse.jface.text.TypedPosition; // packageimport
import org.eclipse.jface.text.IEditingSupportRegistry; // packageimport
import org.eclipse.jface.text.IDocumentPartitionerExtension; // packageimport
import org.eclipse.jface.text.AbstractHoverInformationControlManager; // packageimport
import org.eclipse.jface.text.IEditingSupport; // packageimport
import org.eclipse.jface.text.IMarkSelection; // packageimport
import org.eclipse.jface.text.ISlaveDocumentManager; // packageimport
import org.eclipse.jface.text.DocumentEvent; // packageimport
import org.eclipse.jface.text.DocumentPartitioningChangedEvent; // packageimport
import org.eclipse.jface.text.ITextStore; // packageimport
import org.eclipse.jface.text.JFaceTextMessages; // packageimport
import org.eclipse.jface.text.DocumentRewriteSessionEvent; // packageimport
import org.eclipse.jface.text.SequentialRewriteTextStore; // packageimport
import org.eclipse.jface.text.DocumentRewriteSessionType; // packageimport
import org.eclipse.jface.text.TextAttribute; // packageimport
import org.eclipse.jface.text.ITextViewerExtension4; // packageimport
import org.eclipse.jface.text.ITypedRegion; // packageimport


import java.lang.all;
import java.util.Set;



import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.Control;
import org.eclipse.jface.text.source.ILineRange;
import org.eclipse.jface.text.source.LineRange;

/**
 * A collection of JFace Text functions.
 * <p>
 * This class is neither intended to be instantiated nor subclassed.
 * </p>
 *
 * @since 3.3
 * @noinstantiate This class is not intended to be instantiated by clients.
 */
public final class JFaceTextUtil {

    private this() {
        // Do not instantiate
    }

    /**
     * Computes the line height for the given line range.
     *
     * @param textWidget the <code>StyledText</code> widget
     * @param startLine the start line
     * @param endLine the end line (exclusive)
     * @param lineCount the line count used by the old API
     * @return the height of all lines starting with <code>startLine</code> and ending above <code>endLime</code>
     */
    public static int computeLineHeight(StyledText textWidget, int startLine, int endLine, int lineCount) {
        return getLinePixel(textWidget, endLine) - getLinePixel(textWidget, startLine);
    }

    /**
     * Returns the last fully visible line of the widget. The exact semantics of "last fully visible
     * line" are:
     * <ul>
     * <li>the last line of which the last pixel is visible, if any
     * <li>otherwise, the only line that is partially visible
     * </ul>
     *
     * @param widget the widget
     * @return the last fully visible line
     */
    public static int getBottomIndex(StyledText widget) {
        int lastPixel= computeLastVisiblePixel(widget);

        // bottom is in [0 .. lineCount - 1]
        int bottom= widget.getLineIndex(lastPixel);

        // bottom is the first line - no more checking
        if (bottom is 0)
            return bottom;

        int pixel= widget.getLinePixel(bottom);
        // bottom starts on or before the client area start - bottom is the only visible line
        if (pixel <= 0)
            return bottom;

        int offset= widget.getOffsetAtLine(bottom);
        int height= widget.getLineHeight(offset);

        // bottom is not showing entirely - use the previous line
        if (pixel + height - 1 > lastPixel)
            return bottom - 1;

        // bottom is fully visible and its last line is exactly the last pixel
        return bottom;
    }

    /**
     * Returns the index of the first (possibly only partially) visible line of the widget
     *
     * @param widget the widget
     * @return the index of the first line of which a pixel is visible
     */
    public static int getPartialTopIndex(StyledText widget) {
        // see StyledText#getPartialTopIndex()
        int top= widget.getTopIndex();
        int pixels= widget.getLinePixel(top);

        // FIXME remove when https://bugs.eclipse.org/bugs/show_bug.cgi?id=123770 is fixed
        if (pixels is -widget.getLineHeight(widget.getOffsetAtLine(top))) {
            top++;
            pixels= 0;
        }

        if (pixels > 0)
            top--;

        return top;
    }

    /**
     * Returns the index of the last (possibly only partially) visible line of the widget
     *
     * @param widget the text widget
     * @return the index of the last line of which a pixel is visible
     */
    public static int getPartialBottomIndex(StyledText widget) {
        // @see StyledText#getPartialBottomIndex()
        int lastPixel= computeLastVisiblePixel(widget);
        int bottom= widget.getLineIndex(lastPixel);
        return bottom;
    }

    /**
     * Returns the last visible pixel in the widget's client area.
     *
     * @param widget the widget
     * @return the last visible pixel in the widget's client area
     */
    private static int computeLastVisiblePixel(StyledText widget) {
        int caHeight= widget.getClientArea().height;
        int lastPixel= caHeight - 1;
        // XXX what if there is a margin? can't take trim as this includes the scrollbars which are not part of the client area
//      if ((textWidget.getStyle() & SWT.BORDER) !is 0)
//          lastPixel -= 4;
        return lastPixel;
    }

    /**
     * Returns the line index of the first visible model line in the viewer. The line may be only
     * partially visible.
     *
     * @param viewer the text viewer
     * @return the first line of which a pixel is visible, or -1 for no line
     */
    public static int getPartialTopIndex(ITextViewer viewer) {
        StyledText widget= viewer.getTextWidget();
        int widgetTop= getPartialTopIndex(widget);
        return widgetLine2ModelLine(viewer, widgetTop);
    }

    /**
     * Returns the last, possibly partially, visible line in the view port.
     *
     * @param viewer the text viewer
     * @return the last, possibly partially, visible line in the view port
     */
    public static int getPartialBottomIndex(ITextViewer viewer) {
        StyledText textWidget= viewer.getTextWidget();
        int widgetBottom= getPartialBottomIndex(textWidget);
        return widgetLine2ModelLine(viewer, widgetBottom);
    }

    /**
     * Returns the range of lines that is visible in the viewer, including any partially visible
     * lines.
     *
     * @param viewer the viewer
     * @return the range of lines that is visible in the viewer, <code>null</code> if no lines are
     *         visible
     */
    public static ILineRange getVisibleModelLines(ITextViewer viewer) {
        int top= getPartialTopIndex(viewer);
        int bottom= getPartialBottomIndex(viewer);
        if (top is -1 || bottom is -1)
            return null;
        return new LineRange(top, bottom - top + 1);
    }

    /**
     * Converts a widget line into a model (i.e. {@link IDocument}) line using the
     * {@link ITextViewerExtension5} if available, otherwise by adapting the widget line to the
     * viewer's {@link ITextViewer#getVisibleRegion() visible region}.
     *
     * @param viewer the viewer
     * @param widgetLine the widget line to convert.
     * @return the model line corresponding to <code>widgetLine</code> or -1 to signal that there
     *         is no corresponding model line
     */
    public static int widgetLine2ModelLine(ITextViewer viewer, int widgetLine) {
        int modelLine;
        if ( cast(ITextViewerExtension5)viewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) viewer;
            modelLine= extension.widgetLine2ModelLine(widgetLine);
        } else {
            try {
                IRegion r= viewer.getVisibleRegion();
                IDocument d= viewer.getDocument();
                modelLine= widgetLine + d.getLineOfOffset(r.getOffset());
            } catch (BadLocationException x) {
                modelLine= widgetLine;
            }
        }
        return modelLine;
    }

    /**
     * Converts a model (i.e. {@link IDocument}) line into a widget line using the
     * {@link ITextViewerExtension5} if available, otherwise by adapting the model line to the
     * viewer's {@link ITextViewer#getVisibleRegion() visible region}.
     *
     * @param viewer the viewer
     * @param modelLine the model line to convert.
     * @return the widget line corresponding to <code>modelLine</code> or -1 to signal that there
     *         is no corresponding widget line
     */
    public static int modelLineToWidgetLine(ITextViewer viewer, int modelLine) {
        int widgetLine;
        if ( cast(ITextViewerExtension5)viewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) viewer;
            widgetLine= extension.modelLine2WidgetLine(modelLine);
        } else {
            IRegion region= viewer.getVisibleRegion();
            IDocument document= viewer.getDocument();
            try {
                int visibleStartLine= document.getLineOfOffset(region.getOffset());
                int visibleEndLine= document.getLineOfOffset(region.getOffset() + region.getLength());
                if (modelLine < visibleStartLine || modelLine > visibleEndLine)
                    widgetLine= -1;
                else
                widgetLine= modelLine - visibleStartLine;
            } catch (BadLocationException x) {
                // ignore and return -1
                widgetLine= -1;
            }
        }
        return widgetLine;
    }


    /**
     * Returns the number of hidden pixels of the first partially visible line. If there is no
     * partially visible line, zero is returned.
     *
     * @param textWidget the widget
     * @return the number of hidden pixels of the first partial line, always &gt;= 0
     */
    public static int getHiddenTopLinePixels(StyledText textWidget) {
        int top= getPartialTopIndex(textWidget);
        return -textWidget.getLinePixel(top);
    }

    /*
     * @see StyledText#getLinePixel(int)
     */
    public static int getLinePixel(StyledText textWidget, int line) {
        return textWidget.getLinePixel(line);
    }

    /*
     * @see StyledText#getLineIndex(int)
     */
    public static int getLineIndex(StyledText textWidget, int y) {
        int lineIndex= textWidget.getLineIndex(y);
        return lineIndex;
    }

    /**
     * Returns <code>true</code> if the widget displays the entire contents, i.e. it cannot
     * be vertically scrolled.
     *
     * @param widget the widget
     * @return <code>true</code> if the widget displays the entire contents, i.e. it cannot
     *         be vertically scrolled, <code>false</code> otherwise
     */
    public static bool isShowingEntireContents(StyledText widget) {
        if (widget.getTopPixel() !is 0) // more efficient shortcut
            return false;

        int lastVisiblePixel= computeLastVisiblePixel(widget);
        int lastPossiblePixel= widget.getLinePixel(widget.getLineCount());
        return lastPossiblePixel <= lastVisiblePixel;
    }

    /**
     * Determines the graphical area covered by the given text region in
     * the given viewer.
     *
     * @param region the region whose graphical extend must be computed
     * @param textViewer the text viewer containing the region
     * @return the graphical extend of the given region in the given viewer
     *
     * @since 3.4
     */
    public static Rectangle computeArea(IRegion region, ITextViewer textViewer) {
        int start= 0;
        int end= 0;
        IRegion widgetRegion= modelRange2WidgetRange(region, textViewer);
        if (widgetRegion !is null) {
            start= widgetRegion.getOffset();
            end= start + widgetRegion.getLength();
        }

        StyledText styledText= textViewer.getTextWidget();
        Rectangle bounds;
        if (end > 0 && start < end)
            bounds= styledText.getTextBounds(start, end - 1);
        else {
            Point loc= styledText.getLocationAtOffset(start);
            bounds= new Rectangle(loc.x, loc.y, getAverageCharWidth(textViewer.getTextWidget()), styledText.getLineHeight(start));
        }

        return new Rectangle(bounds.x, bounds.y, bounds.width, bounds.height);
    }

    /**
     * Translates a given region of the text viewer's document into
     * the corresponding region of the viewer's widget.
     *
     * @param region the document region
     * @param textViewer the viewer containing the region
     * @return the corresponding widget region
     *
     * @since 3.4
     */
    private static IRegion modelRange2WidgetRange(IRegion region, ITextViewer textViewer) {
        if ( cast(ITextViewerExtension5)textViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) textViewer;
            return extension.modelRange2WidgetRange(region);
        }

        IRegion visibleRegion= textViewer.getVisibleRegion();
        int start= region.getOffset() - visibleRegion.getOffset();
        int end= start + region.getLength();
        if (end > visibleRegion.getLength())
            end= visibleRegion.getLength();

        return new Region(start, end - start);
    }

    /**
     * Returns the average character width of the given control's font.
     *
     * @param control the control to calculate the average char width for
     * @return the average character width of the controls font
     *
     * @since 3.4
     */
    public static int getAverageCharWidth(Control control) {
        GC gc= new GC(control);
        gc.setFont(control.getFont());
        int increment= gc.getFontMetrics().getAverageCharWidth();
        gc.dispose();
        return increment;
    }

}
