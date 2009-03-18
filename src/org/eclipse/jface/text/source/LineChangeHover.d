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
module org.eclipse.jface.text.source.LineChangeHover;

import org.eclipse.jface.text.source.ISharedTextColors; // packageimport
import org.eclipse.jface.text.source.ILineRange; // packageimport
import org.eclipse.jface.text.source.IAnnotationPresentation; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerInfoExtension; // packageimport
import org.eclipse.jface.text.source.ICharacterPairMatcher; // packageimport
import org.eclipse.jface.text.source.TextInvocationContext; // packageimport
import org.eclipse.jface.text.source.IChangeRulerColumn; // packageimport
import org.eclipse.jface.text.source.IAnnotationMap; // packageimport
import org.eclipse.jface.text.source.IAnnotationModelListenerExtension; // packageimport
import org.eclipse.jface.text.source.ISourceViewerExtension2; // packageimport
import org.eclipse.jface.text.source.IAnnotationHover; // packageimport
import org.eclipse.jface.text.source.ContentAssistantFacade; // packageimport
import org.eclipse.jface.text.source.IAnnotationAccess; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerExtension; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerColumn; // packageimport
import org.eclipse.jface.text.source.LineNumberRulerColumn; // packageimport
import org.eclipse.jface.text.source.MatchingCharacterPainter; // packageimport
import org.eclipse.jface.text.source.IAnnotationModelExtension; // packageimport
import org.eclipse.jface.text.source.ILineDifferExtension; // packageimport
import org.eclipse.jface.text.source.DefaultCharacterPairMatcher; // packageimport
import org.eclipse.jface.text.source.LineNumberChangeRulerColumn; // packageimport
import org.eclipse.jface.text.source.IAnnotationAccessExtension; // packageimport
import org.eclipse.jface.text.source.ISourceViewer; // packageimport
import org.eclipse.jface.text.source.AnnotationModel; // packageimport
import org.eclipse.jface.text.source.ILineDifferExtension2; // packageimport
import org.eclipse.jface.text.source.IAnnotationModelListener; // packageimport
import org.eclipse.jface.text.source.IVerticalRuler; // packageimport
import org.eclipse.jface.text.source.DefaultAnnotationHover; // packageimport
import org.eclipse.jface.text.source.SourceViewer; // packageimport
import org.eclipse.jface.text.source.SourceViewerConfiguration; // packageimport
import org.eclipse.jface.text.source.AnnotationBarHoverManager; // packageimport
import org.eclipse.jface.text.source.CompositeRuler; // packageimport
import org.eclipse.jface.text.source.ImageUtilities; // packageimport
import org.eclipse.jface.text.source.VisualAnnotationModel; // packageimport
import org.eclipse.jface.text.source.IAnnotationModel; // packageimport
import org.eclipse.jface.text.source.ISourceViewerExtension3; // packageimport
import org.eclipse.jface.text.source.ILineDiffInfo; // packageimport
import org.eclipse.jface.text.source.VerticalRulerEvent; // packageimport
import org.eclipse.jface.text.source.ChangeRulerColumn; // packageimport
import org.eclipse.jface.text.source.ILineDiffer; // packageimport
import org.eclipse.jface.text.source.AnnotationModelEvent; // packageimport
import org.eclipse.jface.text.source.AnnotationColumn; // packageimport
import org.eclipse.jface.text.source.AnnotationRulerColumn; // packageimport
import org.eclipse.jface.text.source.IAnnotationHoverExtension; // packageimport
import org.eclipse.jface.text.source.AbstractRulerColumn; // packageimport
import org.eclipse.jface.text.source.ISourceViewerExtension; // packageimport
import org.eclipse.jface.text.source.AnnotationMap; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerInfo; // packageimport
import org.eclipse.jface.text.source.IAnnotationModelExtension2; // packageimport
import org.eclipse.jface.text.source.LineRange; // packageimport
import org.eclipse.jface.text.source.IAnnotationAccessExtension2; // packageimport
import org.eclipse.jface.text.source.VerticalRuler; // packageimport
import org.eclipse.jface.text.source.JFaceTextMessages; // packageimport
import org.eclipse.jface.text.source.IOverviewRuler; // packageimport
import org.eclipse.jface.text.source.Annotation; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerListener; // packageimport
import org.eclipse.jface.text.source.ISourceViewerExtension4; // packageimport
import org.eclipse.jface.text.source.AnnotationPainter; // packageimport
import org.eclipse.jface.text.source.IAnnotationHoverExtension2; // packageimport
import org.eclipse.jface.text.source.OverviewRuler; // packageimport
import org.eclipse.jface.text.source.OverviewRulerHoverManager; // packageimport


import java.lang.all;
import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;




import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.jface.action.ToolBarManager;
import org.eclipse.jface.text.DefaultInformationControl;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IInformationControl;
import org.eclipse.jface.text.IInformationControlCreator;
import org.eclipse.jface.text.information.IInformationProviderExtension2;


/**
 * A hover for line oriented diffs. It determines the text to show as hover for a certain line in the
 * document.
 *
 * @since 3.0
 */
public class LineChangeHover : IAnnotationHover, IAnnotationHoverExtension, IInformationProviderExtension2 {

    /*
     * @see org.eclipse.jface.text.source.IAnnotationHover#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer, int)
     */
    public String getHoverInfo(ISourceViewer sourceViewer, int lineNumber) {
        return null;
    }

    /**
     * Formats the source w/ syntax coloring etc. This implementation replaces tabs with spaces.
     * May be overridden by subclasses.
     *
     * @param content the hover content
     * @return <code>content</code> reformatted
     */
    protected String formatSource(String content) {
        if (content !is null) {
            StringBuffer sb= new StringBuffer(content);
            final String tabReplacement= getTabReplacement();
            for (int pos= 0; pos < sb.length(); pos++) {
                if (sb.charAt(pos) is '\t')
                    sb.replace(pos, pos + 1, tabReplacement);
            }
            return sb.toString();
        }
        return content;
    }

    /**
     * Returns a replacement for the tab character. The default implementation
     * returns a tabulator character, but subclasses may override to specify a
     * number of spaces.
     *
     * @return a whitespace String that will be substituted for the tabulator
     *         character
     */
    protected String getTabReplacement() {
        return "\t"; //$NON-NLS-1$
    }

    /**
     * Computes the content of the hover for the document contained in <code>viewer</code> on
     * line <code>line</code>.
     *
     * @param viewer the connected viewer
     * @param first the first line in <code>viewer</code>'s document to consider
     * @param last the last line in <code>viewer</code>'s document to consider
     * @param maxLines the max number of lines
     * @return The hover content corresponding to the parameters
     * @see #getHoverInfo(ISourceViewer, int)
     * @see #getHoverInfo(ISourceViewer, ILineRange, int)
     */
    private String computeContent(ISourceViewer viewer, int first, int last, int maxLines) {
        ILineDiffer differ= getDiffer(viewer);
        if (differ is null)
            return null;

        final List lines= new LinkedList();
        for (int l= first; l <= last; l++) {
            ILineDiffInfo info= differ.getLineInfo(l);
            if (info !is null)
                lines.add(cast(Object)info);
        }

        return decorateText(lines, maxLines);
    }

    /**
     * Takes a list of <code>ILineDiffInfo</code>s and computes a hover of at most <code>maxLines</code>.
     * Added lines are prefixed with a <code>'+'</code>, changed lines with <code>'>'</code> and
     * deleted lines with <code>'-'</code>.
     * <p>Deleted and added lines can even each other out, so that a number of deleted lines get
     * displayed where - in the current document - the added lines are.
     *
     * @param diffInfos a <code>List</code> of <code>ILineDiffInfo</code>
     * @param maxLines the maximum number of lines. Note that adding up all annotations might give
     * more than that due to deleted lines.
     * @return a <code>String</code> suitable for hover display
     */
    protected String decorateText(List diffInfos, int maxLines) {
        /* maxLines controls the size of the hover (not more than what fits into the display are of
         * the viewer).
         * added controls how many lines are added - added lines are
         */
        String text= ""; //$NON-NLS-1$
        int added= 0;
        for (Iterator it= diffInfos.iterator(); it.hasNext();) {
            ILineDiffInfo info= cast(ILineDiffInfo)it.next();
            String[] original= info.getOriginalText();
            int type= info.getChangeType();
            int i= 0;
            if (type is ILineDiffInfo.ADDED)
                added++;
            else if (type is ILineDiffInfo.CHANGED) {
                text ~= "> " ~ (original.length > 0 ? original[i++] : ""); //$NON-NLS-1$ //$NON-NLS-2$
                maxLines--;
            } else if (type is ILineDiffInfo.UNCHANGED) {
                maxLines++;
            }
            if (maxLines is 0)
                return trimTrailing(text);
            for (; i < original.length; i++) {
                text ~= "- " ~ original[i]; //$NON-NLS-1$
                added--;
                if (--maxLines is 0)
                    return trimTrailing(text);
            }
        }
        text= text.trim();
        if (text.length() is 0 && added-- > 0 && maxLines-- > 0)
            text ~= "+ "; //$NON-NLS-1$
        while (added-- > 0 && maxLines-- > 0)
            text ~= "\n+ "; //$NON-NLS-1$
        return text;
    }

    /**
     * Trims trailing spaces
     *
     * @param text a <code>String</code>
     * @return a copy of <code>text</code> with trailing spaces removed
     */
    private String trimTrailing(String text) {
        int pos= text.length() - 1;
        while (pos >= 0 && Character.isWhitespace(text.charAt(pos))) {
            pos--;
        }
        return text.substring(0, pos + 1);
    }

    /**
     * Extracts the line differ - if any - from the viewer's document's annotation model.
     * @param viewer the viewer
     * @return a line differ for the document displayed in viewer, or <code>null</code>.
     */
    private ILineDiffer getDiffer(ISourceViewer viewer) {
        IAnnotationModel model= viewer.getAnnotationModel();

        if (model is null)
            return null;

        if ( cast(IAnnotationModelExtension)model ) {
            IAnnotationModel diffModel= (cast(IAnnotationModelExtension)model).getAnnotationModel(stringcast(IChangeRulerColumn.QUICK_DIFF_MODEL_ID));
            if (diffModel !is null)
                model= diffModel;
        }
        if ( cast(ILineDiffer)model ) {
            if (cast(ILineDifferExtension2)model && (cast(ILineDifferExtension2)model).isSuspended())
                return null;
            return cast(ILineDiffer)model;
        }
        return null;
    }

    /**
     * Computes the block of lines which form a contiguous block of changes covering <code>line</code>.
     *
     * @param viewer the source viewer showing
     * @param line the line which a hover is displayed for
     * @param min the first line in <code>viewer</code>'s document to consider
     * @param max the last line in <code>viewer</code>'s document to consider
     * @return the selection in the document displayed in <code>viewer</code> containing <code>line</code>
     * that is covered by the hover information returned by the receiver.
     */
    protected Point computeLineRange(ISourceViewer viewer, int line, int min, int max) {
        /* Algorithm:
         * All lines that have changes to themselves (added, changed) are taken that form a
         * contiguous block of lines that includes <code>line</code>.
         *
         * If <code>line</code> is itself unchanged, if there is a deleted line either above or
         * below, or both, the lines +/- 1 from <code>line</code> are included in the search as well,
         * without applying this last rule to them, though. (I.e., if <code>line</code> is unchanged,
         * but has a deleted line above, this one is taken in. If the line above has changes, the block
         * is extended from there. If the line has no changes itself, the search stops).
         *
         * The block never extends the visible line range of the viewer.
         */

        ILineDiffer differ= getDiffer(viewer);
        if (differ is null)
            return new Point(-1, -1);

        // backward search

        int l= line;
        ILineDiffInfo info= differ.getLineInfo(l);
        // search backwards until a line has no changes to itself
        while (l >= min && info !is null && (info.getChangeType() is ILineDiffInfo.CHANGED || info.getChangeType() is ILineDiffInfo.ADDED)) {
            info= differ.getLineInfo(--l);
        }

        int first= Math.min(l + 1, line);

        // forward search

        l= line;
        info= differ.getLineInfo(l);
        // search forward until a line has no changes to itself
        while (l <= max && info !is null && (info.getChangeType() is ILineDiffInfo.CHANGED || info.getChangeType() is ILineDiffInfo.ADDED)) {
            info= differ.getLineInfo(++l);
        }

        int last= Math.max(l - 1, line);

        return new Point(first, last);
    }

    /*
     * @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer, org.eclipse.jface.text.source.ILineRange, int)
     */
    public Object getHoverInfo(ISourceViewer sourceViewer, ILineRange lineRange, int visibleLines) {
        int first= adaptFirstLine(sourceViewer, lineRange.getStartLine());
        int last= adaptLastLine(sourceViewer, lineRange.getStartLine() + lineRange.getNumberOfLines() - 1);
        String content= computeContent(sourceViewer, first, last, visibleLines);
        return stringcast(formatSource(content));
    }

    /**
     * Adapts the start line to the implementation of <code>ILineDiffInfo</code>.
     *
     * @param viewer the source viewer
     * @param startLine the line to adapt
     * @return <code>startLine - 1</code> if that line exists and is an
     *         unchanged line followed by deletions, <code>startLine</code>
     *         otherwise
     */
    private int adaptFirstLine(ISourceViewer viewer, int startLine) {
        ILineDiffer differ= getDiffer(viewer);
        if (differ !is null && startLine > 0) {
            int l= startLine - 1;
            ILineDiffInfo info= differ.getLineInfo(l);
            if (info !is null && info.getChangeType() is ILineDiffInfo.UNCHANGED && info.getRemovedLinesBelow() > 0)
                return l;
        }
        return startLine;
    }

    /**
     * Adapts the last line to the implementation of <code>ILineDiffInfo</code>.
     *
     * @param viewer the source viewer
     * @param lastLine the line to adapt
     * @return <code>lastLine - 1</code> if that line exists and is an
     *         unchanged line followed by deletions, <code>startLine</code>
     *         otherwise
     */
    private int adaptLastLine(ISourceViewer viewer, int lastLine) {
        ILineDiffer differ= getDiffer(viewer);
        if (differ !is null && lastLine > 0) {
            ILineDiffInfo info= differ.getLineInfo(lastLine);
            if (info !is null && info.getChangeType() is ILineDiffInfo.UNCHANGED)
                return lastLine - 1;
        }
        return lastLine;
    }

    /*
     * @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverLineRange(org.eclipse.jface.text.source.ISourceViewer, int)
     */
    public ILineRange getHoverLineRange(ISourceViewer viewer, int lineNumber) {
        IDocument document= viewer.getDocument();
        if (document !is null) {
            Point range= computeLineRange(viewer, lineNumber, 0, Math.max(0, document.getNumberOfLines() - 1));
            if (range.x !is -1 && range.y !is -1)
                return new LineRange(range.x, range.y - range.x + 1);
        }
        return null;
    }

    /*
     * @see org.eclipse.jface.text.source.IAnnotationHoverExtension#canHandleMouseCursor()
     */
    public bool canHandleMouseCursor() {
        return false;
    }

    /*
     * @see org.eclipse.jface.text.source.IAnnotationHoverExtension#getHoverControlCreator()
     */
    public IInformationControlCreator getHoverControlCreator() {
        return null;
    }

    /*
     * @see org.eclipse.jface.text.information.IInformationProviderExtension2#getInformationPresenterControlCreator()
     * @since 3.2
     */
    public IInformationControlCreator getInformationPresenterControlCreator() {
        return new class()  IInformationControlCreator {
            public IInformationControl createInformationControl(Shell parent) {
                return new DefaultInformationControl(parent, cast(ToolBarManager)null, null);
            }
        };
    }
}
