/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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


module org.eclipse.jface.text.CursorLinePainter;

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
import org.eclipse.jface.text.JFaceTextUtil; // packageimport
import org.eclipse.jface.text.AbstractReusableInformationControlCreator; // packageimport
import org.eclipse.jface.text.TabsToSpacesConverter; // packageimport
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




import org.eclipse.swt.custom.LineBackgroundEvent;
import org.eclipse.swt.custom.LineBackgroundListener;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Point;


/**
 * A painter the draws the background of the caret line in a configured color.
 * <p>
 * Clients usually instantiate and configure object of this class.</p>
 * <p>
 * This class is not intended to be subclassed.</p>
 *
 * @since 2.1
 * @noextend This class is not intended to be subclassed by clients.
 */
public class CursorLinePainter : IPainter, LineBackgroundListener {

    /** The viewer the painter works on */
    private const ITextViewer fViewer;
    /** The cursor line back ground color */
    private Color fHighlightColor;
    /** The paint position manager for managing the line coordinates */
    private IPaintPositionManager fPositionManager;

    /** Keeps track of the line to be painted */
    private Position fCurrentLine;
    /** Keeps track of the line to be cleared */
    private Position fLastLine;
    /** Keeps track of the line number of the last painted line */
    private int fLastLineNumber= -1;
    /** Indicates whether this painter is active */
    private bool fIsActive;

    /**
     * Creates a new painter for the given source viewer.
     *
     * @param textViewer the source viewer for which to create a painter
     */
    public this(ITextViewer textViewer) {
        fCurrentLine= new Position(0, 0);
        fLastLine= new Position(0, 0);
        fViewer= textViewer;
    }

    /**
     * Sets the color in which to draw the background of the cursor line.
     *
     * @param highlightColor the color in which to draw the background of the cursor line
     */
    public void setHighlightColor(Color highlightColor) {
        fHighlightColor= highlightColor;
    }

    /*
     * @see LineBackgroundListener#lineGetBackground(LineBackgroundEvent)
     */
    public void lineGetBackground(LineBackgroundEvent event) {
        // don't use cached line information because of asynchronous painting

        StyledText textWidget= fViewer.getTextWidget();
        if (textWidget !is null) {

            int caret= textWidget.getCaretOffset();
            int length= event.lineText.length();

            if (event.lineOffset <= caret && caret <= event.lineOffset + length)
                event.lineBackground= fHighlightColor;
            else
                event.lineBackground= textWidget.getBackground();
        }
    }

    /**
     * Updates all the cached information about the lines to be painted and to be cleared. Returns <code>true</code>
     * if the line number of the cursor line has changed.
     *
     * @return <code>true</code> if cursor line changed
     */
    private bool updateHighlightLine() {
        try {

            IDocument document= fViewer.getDocument();
            int modelCaret= getModelCaret();
            int lineNumber= document.getLineOfOffset(modelCaret);

            // redraw if the current line number is different from the last line number we painted
            // initially fLastLineNumber is -1
            if (lineNumber !is fLastLineNumber || !fCurrentLine.overlapsWith(modelCaret, 0)) {

                fLastLine.offset= fCurrentLine.offset;
                fLastLine.length= fCurrentLine.length;
                fLastLine.isDeleted_= fCurrentLine.isDeleted_;

                if (fCurrentLine.isDeleted_) {
                    fCurrentLine.isDeleted_= false;
                    fPositionManager.managePosition(fCurrentLine);
                }

                fCurrentLine.offset= document.getLineOffset(lineNumber);
                if (lineNumber is document.getNumberOfLines() - 1)
                    fCurrentLine.length= document.getLength() - fCurrentLine.offset;
                else
                    fCurrentLine.length= document.getLineOffset(lineNumber + 1) - fCurrentLine.offset;

                fLastLineNumber= lineNumber;
                return true;

            }

        } catch (BadLocationException e) {
        }

        return false;
    }

    /**
     * Returns the location of the caret as offset in the source viewer's
     * input document.
     *
     * @return the caret location
     */
    private int getModelCaret() {
        int widgetCaret= fViewer.getTextWidget().getCaretOffset();
        if ( cast(ITextViewerExtension5)fViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fViewer;
            return extension.widgetOffset2ModelOffset(widgetCaret);
        }
        IRegion visible= fViewer.getVisibleRegion();
        return widgetCaret + visible.getOffset();
    }

    /**
     * Assumes the given position to specify offset and length of a line to be painted.
     *
     * @param position the specification of the line  to be painted
     */
    private void drawHighlightLine(Position position) {

        // if the position that is about to be drawn was deleted then we can't
        if (position.isDeleted())
            return;

        int widgetOffset= 0;
        if ( cast(ITextViewerExtension5)fViewer ) {

            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fViewer;
            widgetOffset= extension.modelOffset2WidgetOffset(position.getOffset());
            if (widgetOffset is -1)
                return;

        } else {

            IRegion visible= fViewer.getVisibleRegion();
            widgetOffset= position.getOffset() - visible.getOffset();
            if (widgetOffset < 0 || visible.getLength() < widgetOffset )
                return;
        }

        StyledText textWidget= fViewer.getTextWidget();
        // check for https://bugs.eclipse.org/bugs/show_bug.cgi?id=64898
        // this is a guard against the symptoms but not the actual solution
        if (0 <= widgetOffset && widgetOffset <= textWidget.getCharCount()) {
            Point upperLeft= textWidget.getLocationAtOffset(widgetOffset);
            int width= textWidget.getClientArea().width + textWidget.getHorizontalPixel();
            int height= textWidget.getLineHeight(widgetOffset);
            textWidget.redraw(0, upperLeft.y, width, height, false);
        }
    }

    /*
     * @see IPainter#deactivate(bool)
     */
    public void deactivate(bool redraw) {
        if (fIsActive) {
            fIsActive= false;

            /* on turning off the feature one has to paint the currently
             * highlighted line with the standard background color
             */
            if (redraw)
                drawHighlightLine(fCurrentLine);

            fViewer.getTextWidget().removeLineBackgroundListener(this);

            if (fPositionManager !is null)
                fPositionManager.unmanagePosition(fCurrentLine);

            fLastLineNumber= -1;
            fCurrentLine.offset= 0;
            fCurrentLine.length= 0;
        }
    }

    /*
     * @see IPainter#dispose()
     */
    public void dispose() {
    }

    /*
     * @see IPainter#paint(int)
     */
    public void paint(int reason) {
        if (fViewer.getDocument() is null) {
            deactivate(false);
            return;
        }

        StyledText textWidget= fViewer.getTextWidget();

        // check selection
        Point selection= textWidget.getSelection();
        int startLine= textWidget.getLineAtOffset(selection.x);
        int endLine= textWidget.getLineAtOffset(selection.y);
        if (startLine !is endLine) {
            deactivate(true);
            return;
        }

        // initialization
        if (!fIsActive) {
            textWidget.addLineBackgroundListener(this);
            fPositionManager.managePosition(fCurrentLine);
            fIsActive= true;
        }

        //redraw line highlight only if it hasn't been drawn yet on the respective line
        if (updateHighlightLine()) {
            // clear last line
            drawHighlightLine(fLastLine);
            // draw new line
            drawHighlightLine(fCurrentLine);
        }
    }

    /*
     * @see IPainter#setPositionManager(IPaintPositionManager)
     */
    public void setPositionManager(IPaintPositionManager manager) {
        fPositionManager = manager;
    }
}
