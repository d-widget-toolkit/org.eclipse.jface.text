/*******************************************************************************
 * Copyright (c) 2006, 2007 Wind River Systems, Inc. and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Anton Leherbauer (Wind River Systems) - initial API and implementation - https://bugs.eclipse.org/bugs/show_bug.cgi?id=22712
 *     Anton Leherbauer (Wind River Systems) - [painting] Long lines take too long to display when "Show Whitespace Characters" is enabled - https://bugs.eclipse.org/bugs/show_bug.cgi?id=196116
 *     Anton Leherbauer (Wind River Systems) - [painting] Whitespace characters not drawn when scrolling to right slowly - https://bugs.eclipse.org/bugs/show_bug.cgi?id=206633
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.jface.text.WhitespaceCharacterPainter;

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
import org.eclipse.jface.text.JFaceTextUtil; // packageimport
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

import org.eclipse.swt.custom.StyleRange;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.custom.StyledTextContent;
import org.eclipse.swt.events.PaintEvent;
import org.eclipse.swt.events.PaintListener;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.FontMetrics;
import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.graphics.Point;


/**
 * A painter for drawing visible characters for (invisible) whitespace
 * characters.
 *
 * @since 3.3
 */
public class WhitespaceCharacterPainter : IPainter, PaintListener {

    private static const char SPACE_SIGN= '\u00b7';
    private static const char IDEOGRAPHIC_SPACE_SIGN= '\u00b0';
    private static const char TAB_SIGN= '\u00bb';
    private static const char CARRIAGE_RETURN_SIGN= '\u00a4';
    private static const char LINE_FEED_SIGN= '\u00b6';

    /** Indicates whether this painter is active. */
    private bool fIsActive= false;
    /** The source viewer this painter is attached to. */
    private ITextViewer fTextViewer;
    /** The viewer's widget. */
    private StyledText fTextWidget;
    /** Tells whether the advanced graphics sub system is available. */
    private bool fIsAdvancedGraphicsPresent;

    /**
     * Creates a new painter for the given text viewer.
     *
     * @param textViewer  the text viewer the painter should be attached to
     */
    public this(ITextViewer textViewer) {
//         super();
        fTextViewer= textViewer;
        fTextWidget= textViewer.getTextWidget();
        GC gc= new GC(fTextWidget);
        gc.setAdvanced(true);
        fIsAdvancedGraphicsPresent= gc.getAdvanced();
        gc.dispose();
    }

    /*
     * @see org.eclipse.jface.text.IPainter#dispose()
     */
    public void dispose() {
        fTextViewer= null;
        fTextWidget= null;
    }

    /*
     * @see org.eclipse.jface.text.IPainter#paint(int)
     */
    public void paint(int reason) {
        IDocument document= fTextViewer.getDocument();
        if (document is null) {
            deactivate(false);
            return;
        }
        if (!fIsActive) {
            fIsActive= true;
            fTextWidget.addPaintListener(this);
            redrawAll();
        } else if (reason is CONFIGURATION || reason is INTERNAL) {
            redrawAll();
        } else if (reason is TEXT_CHANGE) {
            // redraw current line only
            try {
                IRegion lineRegion =
                    document.getLineInformationOfOffset(getDocumentOffset(fTextWidget.getCaretOffset()));
                int widgetOffset= getWidgetOffset(lineRegion.getOffset());
                int charCount= fTextWidget.getCharCount();
                int redrawLength= Math.min(lineRegion.getLength(), charCount - widgetOffset);
                if (widgetOffset >= 0 && redrawLength > 0) {
                    fTextWidget.redrawRange(widgetOffset, redrawLength, true);
                }
            } catch (BadLocationException e) {
                // ignore
            }
        }
    }

    /*
     * @see org.eclipse.jface.text.IPainter#deactivate(bool)
     */
    public void deactivate(bool redraw) {
        if (fIsActive) {
            fIsActive= false;
            fTextWidget.removePaintListener(this);
            if (redraw) {
                redrawAll();
            }
        }
    }

    /*
     * @see org.eclipse.jface.text.IPainter#setPositionManager(org.eclipse.jface.text.IPaintPositionManager)
     */
    public void setPositionManager(IPaintPositionManager manager) {
        // no need for a position manager
    }

    /*
     * @see org.eclipse.swt.events.PaintListener#paintControl(org.eclipse.swt.events.PaintEvent)
     */
    public void paintControl(PaintEvent event) {
        if (fTextWidget !is null) {
            handleDrawRequest(event.gc, event.x, event.y, event.width, event.height);
        }
    }

    /**
     * Draw characters in view range.
     *
     * @param gc
     * @param x
     * @param y
     * @param w
     * @param h
     */
    private void handleDrawRequest(GC gc, int x, int y, int w, int h) {
        int startLine= fTextWidget.getLineIndex(y);
        int endLine= fTextWidget.getLineIndex(y + h - 1);
        if (startLine <= endLine && startLine < fTextWidget.getLineCount()) {
            if (fIsAdvancedGraphicsPresent) {
                int alpha= gc.getAlpha();
                gc.setAlpha(100);
                drawLineRange(gc, startLine, endLine, x, w);
                gc.setAlpha(alpha);
            } else
                drawLineRange(gc, startLine, endLine, x, w);
        }
    }

    /**
     * Draw the given line range.
     *
     * @param gc
     * @param startLine  first line number
     * @param endLine  last line number (inclusive)
     * @param x  the X-coordinate of the drawing range
     * @param w  the width of the drawing range
     */
    private void drawLineRange(GC gc, int startLine, int endLine, int x, int w) {
        final int viewPortWidth= fTextWidget.getClientArea().width;
        for (int line= startLine; line <= endLine; line++) {
            int lineOffset= fTextWidget.getOffsetAtLine(line);
            // line end offset including line delimiter
            int lineEndOffset;
            if (line < fTextWidget.getLineCount() - 1) {
                lineEndOffset= fTextWidget.getOffsetAtLine(line + 1);
            } else {
                lineEndOffset= fTextWidget.getCharCount();
            }
            // line length excluding line delimiter
            int lineLength= lineEndOffset - lineOffset;
            while (lineLength > 0) {
                char c= fTextWidget.getTextRange(lineOffset + lineLength - 1, 1).charAt(0);
                if (c !is '\r' && c !is '\n') {
                    break;
                }
                --lineLength;
            }
            // compute coordinates of last character on line
            Point endOfLine= fTextWidget.getLocationAtOffset(lineOffset + lineLength);
            if (x - endOfLine.x > viewPortWidth) {
                // line is not visible
                continue;
            }
            // Y-coordinate of line
            int y= fTextWidget.getLinePixel(line);
            // compute first visible char offset
            int startOffset;
            try {
                startOffset= fTextWidget.getOffsetAtLocation(new Point(x, y)) - 1;
                if (startOffset - 2 <= lineOffset) {
                    startOffset= lineOffset;
                }
            } catch (IllegalArgumentException iae) {
                startOffset= lineOffset;
            }
            // compute last visible char offset
            int endOffset;
            if (x + w >= endOfLine.x) {
                // line end is visible
                endOffset= lineEndOffset;
            } else {
                try {
                    endOffset= fTextWidget.getOffsetAtLocation(new Point(x + w - 1, y)) + 1;
                    if (endOffset + 2 >= lineEndOffset) {
                        endOffset= lineEndOffset;
                    }
                } catch (IllegalArgumentException iae) {
                    endOffset= lineEndOffset;
                }
            }
            // draw character range
            if (endOffset > startOffset) {
                drawCharRange(gc, startOffset, endOffset);
            }
        }
    }

    /**
     * Draw characters of content range.
     *
     * @param gc the GC
     * @param startOffset inclusive start index
     * @param endOffset exclusive end index
     */
    private void drawCharRange(GC gc, int startOffset, int endOffset) {
        StyledTextContent content= fTextWidget.getContent();
        int length= endOffset - startOffset;
        String text= content.getTextRange(startOffset, length);
        StyleRange styleRange= null;
        Color fg= null;
        Point selection= fTextWidget.getSelection();
        StringBuffer visibleChar= new StringBuffer(10);
        for (int textOffset= 0; textOffset <= length; ++textOffset) {
            int delta= 0;
            bool eol= false;
            if (textOffset < length) {
                delta= 1;
                char c= text.charAt(textOffset);
                switch (c) {
                case ' ' :
                    visibleChar.append(SPACE_SIGN);
                    // 'continue' would improve performance but may produce drawing errors
                    // for long runs of space if width of space and dot differ
                    break;
                case '\u3000' : // ideographic whitespace
                    visibleChar.append(IDEOGRAPHIC_SPACE_SIGN);
                    // 'continue' would improve performance but may produce drawing errors
                    // for long runs of space if width of space and dot differ
                    break;
                case '\t' :
                    visibleChar.append(TAB_SIGN);
                    break;
                case '\r' :
                    visibleChar.append(CARRIAGE_RETURN_SIGN);
                    if (textOffset >= length - 1 || text.charAt(textOffset + 1) !is '\n') {
                        eol= true;
                        break;
                    }
                    continue;
                case '\n' :
                    visibleChar.append(LINE_FEED_SIGN);
                    eol= true;
                    break;
                default :
                    delta= 0;
                    break;
                }
            }
            if (visibleChar.length() > 0) {
                int widgetOffset= startOffset + textOffset - visibleChar.length() + delta;
                if (!eol || !isFoldedLine(content.getLineAtOffset(widgetOffset))) {
                    if (widgetOffset >= selection.x && widgetOffset < selection.y) {
                        fg= fTextWidget.getSelectionForeground();
                    } else if (styleRange is null || styleRange.start + styleRange.length <= widgetOffset) {
                        styleRange= fTextWidget.getStyleRangeAtOffset(widgetOffset);
                        if (styleRange is null || styleRange.foreground is null) {
                            fg= fTextWidget.getForeground();
                        } else {
                            fg= styleRange.foreground;
                        }
                    }
                    draw(gc, widgetOffset, visibleChar.toString(), fg);
                }
                visibleChar.setLength(0);
            }
        }
    }

    /**
     * Check if the given widget line is a folded line.
     *
     * @param widgetLine  the widget line number
     * @return <code>true</code> if the line is folded
     */
    private bool isFoldedLine(int widgetLine) {
        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5)fTextViewer;
            int modelLine= extension.widgetLine2ModelLine(widgetLine);
            int widgetLine2= extension.modelLine2WidgetLine(modelLine + 1);
            return widgetLine2 is -1;
        }
        return false;
    }

    /**
     * Redraw all of the text widgets visible content.
     */
    private void redrawAll() {
        fTextWidget.redraw();
    }

    /**
     * Draw string at widget offset.
     *
     * @param gc
     * @param offset the widget offset
     * @param s the string to be drawn
     * @param fg the foreground color
     */
    private void draw(GC gc, int offset, String s, Color fg) {
        // Compute baseline delta (see https://bugs.eclipse.org/bugs/show_bug.cgi?id=165640)
        int baseline= fTextWidget.getBaseline(offset);
        FontMetrics fontMetrics= gc.getFontMetrics();
        int fontBaseline= fontMetrics.getAscent() + fontMetrics.getLeading();
        int baslineDelta= baseline - fontBaseline;

        Point pos= fTextWidget.getLocationAtOffset(offset);
        gc.setForeground(fg);
        gc.drawString(s, pos.x, pos.y + baslineDelta, true);
    }

    /**
     * Convert a document offset to the corresponding widget offset.
     *
     * @param documentOffset
     * @return widget offset
     */
    private int getWidgetOffset(int documentOffset) {
        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5)fTextViewer;
            return extension.modelOffset2WidgetOffset(documentOffset);
        }
        IRegion visible= fTextViewer.getVisibleRegion();
        int widgetOffset= documentOffset - visible.getOffset();
        if (widgetOffset > visible.getLength()) {
            return -1;
        }
        return widgetOffset;
    }

    /**
     * Convert a widget offset to the corresponding document offset.
     *
     * @param widgetOffset
     * @return document offset
     */
    private int getDocumentOffset(int widgetOffset) {
        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5)fTextViewer;
            return extension.widgetOffset2ModelOffset(widgetOffset);
        }
        IRegion visible= fTextViewer.getVisibleRegion();
        if (widgetOffset > visible.getLength()) {
            return -1;
        }
        return widgetOffset + visible.getOffset();
    }

}
