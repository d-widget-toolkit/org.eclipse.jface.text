/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module org.eclipse.jface.text.TextPresentation;

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
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Set;

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.StyleRange;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.core.runtime.Assert;


/**
 * Describes the presentation styles for a section of an indexed text such as a
 * document or string. A text presentation defines a default style for the whole
 * section and in addition style differences for individual subsections. Text
 * presentations can be narrowed down to a particular result window. All methods
 * are result window aware, i.e. ranges outside the result window are always
 * ignored.
 * <p>
 * All iterators provided by a text presentation assume that they enumerate non
 * overlapping, consecutive ranges inside the default range. Thus, all these
 * iterators do not include the default range. The default style range must be
 * explicitly asked for using <code>getDefaultStyleRange</code>.
 */
public class TextPresentation {

    /**
     * Applies the given presentation to the given text widget. Helper method.
     *
     * @param presentation the style information
     * @param text the widget to which to apply the style information
     * @since 2.0
     */
    public static void applyTextPresentation(TextPresentation presentation, StyledText text) {

        StyleRange[] ranges= new StyleRange[presentation.getDenumerableRanges()];

        int i= 0;
        Iterator e= presentation.getAllStyleRangeIterator();
        while (e.hasNext())
            ranges[i++]= cast(StyleRange) e.next();

        text.setStyleRanges(ranges);
    }




    /**
     * Enumerates all the <code>StyleRange</code>s included in the presentation.
     */
    class FilterIterator : Iterator {

        /** The index of the next style range to be enumerated */
        protected int fIndex;
        /** The upper bound of the indices of style ranges to be enumerated */
        protected int fLength;
        /** Indicates whether ranges similar to the default range should be enumerated */
        protected bool fSkipDefaults;
        /** The result window */
        protected IRegion fWindow;

        /**
         * <code>skipDefaults</code> tells the enumeration to skip all those style ranges
         * which define the same style as the presentation's default style range.
         *
         * @param skipDefaults <code>false</code> if ranges similar to the default range should be enumerated
         */
        protected this(bool skipDefaults) {

            fSkipDefaults= skipDefaults;

            fWindow= fResultWindow;
            fIndex= getFirstIndexInWindow(fWindow);
            fLength= getFirstIndexAfterWindow(fWindow);

            if (fSkipDefaults)
                computeIndex();
        }

        /*
         * @see Iterator#next()
         */
        public Object next() {
            try {
                StyleRange r= cast(StyleRange) fRanges.get(fIndex++);
                return createWindowRelativeRange(fWindow, r);
            } catch (ArrayIndexOutOfBoundsException x) {
                throw new NoSuchElementException(null);
            } finally {
                if (fSkipDefaults)
                    computeIndex();
            }
        }

        /*
         * @see Iterator#hasNext()
         */
        public bool hasNext() {
            return fIndex < fLength;
        }

        /*
         * @see Iterator#remove()
         */
        public void remove() {
            throw new UnsupportedOperationException();
        }

        /**
         * Returns whether the given object should be skipped.
         *
         * @param o the object to be checked
         * @return <code>true</code> if the object should be skipped by the iterator
         */
        protected bool skip(Object o) {
            StyleRange r= cast(StyleRange) o;
            return r.similarTo(fDefaultRange);
        }

        /**
         * Computes the index of the styled range that is the next to be enumerated.
         */
        protected void computeIndex() {
            while (fIndex < fLength && skip(fRanges.get(fIndex)))
                ++ fIndex;
        }
    }

    /** The style information for the range covered by the whole presentation */
    private StyleRange fDefaultRange;
    /** The member ranges of the presentation */
    private ArrayList fRanges;
    /** A clipping region against which the presentation can be clipped when asked for results */
    private IRegion fResultWindow;
    /**
     * The optional extent for this presentation.
     * @since 3.0
     */
    private IRegion fExtent;


    /**
     * Creates a new empty text presentation.
     */
    public this() {
        fRanges= new ArrayList(50);
    }

    /**
     * Creates a new empty text presentation. <code>sizeHint</code>  tells the
     * expected size of this presentation.
     *
     * @param sizeHint the expected size of this presentation
     */
    public this(int sizeHint) {
        Assert.isTrue(sizeHint > 0);
        fRanges= new ArrayList(sizeHint);
    }

    /**
     * Creates a new empty text presentation with the given extent.
     * <code>sizeHint</code>  tells the expected size of this presentation.
     *
     * @param extent the extent of the created <code>TextPresentation</code>
     * @param sizeHint the expected size of this presentation
     * @since 3.0
     */
    public this(IRegion extent, int sizeHint) {
        this(sizeHint);
        Assert.isNotNull(cast(Object)extent);
        fExtent= extent;
    }

    /**
     * Sets the result window for this presentation. When dealing with
     * this presentation all ranges which are outside the result window
     * are ignored. For example, the size of the presentation is 0
     * when there is no range inside the window even if there are ranges
     * outside the window. All methods are aware of the result window.
     *
     * @param resultWindow the result window
     */
    public void setResultWindow(IRegion resultWindow) {
        fResultWindow= resultWindow;
    }

    /**
     * Set the default style range of this presentation.
     * The default style range defines the overall area covered
     * by this presentation and its style information.
     *
     * @param range the range describing the default region
     */
    public void setDefaultStyleRange(StyleRange range) {
        fDefaultRange= range;
    }

    /**
     * Returns this presentation's default style range. The returned <code>StyleRange</code>
     * is relative to the start of the result window.
     *
     * @return this presentation's default style range
     */
    public StyleRange getDefaultStyleRange() {
        StyleRange range= createWindowRelativeRange(fResultWindow, fDefaultRange);
        if (range is null)
            return null;
        return cast(StyleRange)range.clone();

    }

    /**
     * Add the given range to the presentation. The range must be a
     * subrange of the presentation's default range.
     *
     * @param range the range to be added
     */
    public void addStyleRange(StyleRange range) {
        checkConsistency(range);
        fRanges.add(range);
    }

    /**
     * Replaces the given range in this presentation. The range must be a
     * subrange of the presentation's default range.
     *
     * @param range the range to be added
     * @since 3.0
     */
    public void replaceStyleRange(StyleRange range) {
        applyStyleRange(range, false);
    }

    /**
     * Merges the given range into this presentation. The range must be a
     * subrange of the presentation's default range.
     *
     * @param range the range to be added
     * @since 3.0
     */
    public void mergeStyleRange(StyleRange range) {
        applyStyleRange(range, true);
    }

    /**
     * Applies the given range to this presentation. The range must be a
     * subrange of the presentation's default range.
     *
     * @param range the range to be added
     * @param merge <code>true</code> if the style should be merged instead of replaced
     * @since 3.0
     */
    private void applyStyleRange(StyleRange range, bool merge) {
        if (range.length is 0)
            return;

        checkConsistency(range);

        int start= range.start;
        int length= range.length;
        int end= start + length;

        if (fRanges.size() is 0) {
            StyleRange defaultRange= getDefaultStyleRange();
            if (defaultRange is null)
                defaultRange= range;

            defaultRange.start= start;
            defaultRange.length= length;
            applyStyle(range, defaultRange, merge);
            fRanges.add(defaultRange);
        } else {
            IRegion rangeRegion= new Region(start, length);
            int first= getFirstIndexInWindow(rangeRegion);

            if (first is fRanges.size()) {
                StyleRange defaultRange= getDefaultStyleRange();
                if (defaultRange is null)
                    defaultRange= range;
                defaultRange.start= start;
                defaultRange.length= length;
                applyStyle(range, defaultRange, merge);
                fRanges.add(defaultRange);
                return;
            }

            int last= getFirstIndexAfterWindow(rangeRegion);
            for (int i= first; i < last && length > 0; i++) {

                StyleRange current= cast(StyleRange)fRanges.get(i);
                int currentStart= current.start;
                int currentEnd= currentStart + current.length;

                if (end <= currentStart) {
                    fRanges.add(i, range);
                    return;
                }

                if (start >= currentEnd)
                    continue;

                StyleRange currentCopy= null;
                if (end < currentEnd)
                    currentCopy= cast(StyleRange)current.clone();

                if (start < currentStart) {
                    // Apply style to new default range and add it
                    StyleRange defaultRange= getDefaultStyleRange();
                    if (defaultRange is null)
                        defaultRange= new StyleRange();

                    defaultRange.start= start;
                    defaultRange.length= currentStart - start;
                    applyStyle(range, defaultRange, merge);
                    fRanges.add(i, defaultRange);
                    i++; last++;


                    // Apply style to first part of current range
                    current.length= Math.min(end, currentEnd) - currentStart;
                    applyStyle(range, current, merge);
                }

                if (start >= currentStart) {
                    // Shorten the current range
                    current.length= start - currentStart;

                    // Apply the style to the rest of the current range and add it
                    if (current.length > 0) {
                        current= cast(StyleRange)current.clone();
                        i++; last++;
                        fRanges.add(i, current);
                    }
                    applyStyle(range, current, merge);
                    current.start= start;
                    current.length= Math.min(end, currentEnd) - start;
                }

                if (end < currentEnd) {
                    // Add rest of current range
                    currentCopy.start= end;
                    currentCopy.length= currentEnd - end;
                    i++; last++;
                    fRanges.add(i,  currentCopy);
                }

                // Update range
                range.start=  currentEnd;
                range.length= Math.max(end - currentEnd, 0);
                start= range.start;
                length= range.length;
            }
            if (length > 0) {
                // Apply style to new default range and add it
                StyleRange defaultRange= getDefaultStyleRange();
                if (defaultRange is null)
                    defaultRange= range;
                defaultRange.start= start;
                defaultRange.length= end - start;
                applyStyle(range, defaultRange, merge);
                fRanges.add(last, defaultRange);
            }
        }
    }

    /**
     * Replaces the given ranges in this presentation. Each range must be a
     * subrange of the presentation's default range. The ranges must be ordered
     * by increasing offset and must not overlap (but may be adjacent).
     *
     * @param ranges the ranges to be added
     * @since 3.0
     */
    public void replaceStyleRanges(StyleRange[] ranges) {
        applyStyleRanges(ranges, false);
    }

    /**
     * Merges the given ranges into this presentation. Each range must be a
     * subrange of the presentation's default range. The ranges must be ordered
     * by increasing offset and must not overlap (but may be adjacent).
     *
     * @param ranges the ranges to be added
     * @since 3.0
     */
    public void mergeStyleRanges(StyleRange[] ranges) {
        applyStyleRanges(ranges, true);
    }

    /**
     * Applies the given ranges to this presentation. Each range must be a
     * subrange of the presentation's default range. The ranges must be ordered
     * by increasing offset and must not overlap (but may be adjacent).
     *
     * @param ranges the ranges to be added
     * @param merge <code>true</code> if the style should be merged instead of replaced
     * @since 3.0
     */
    private void applyStyleRanges(StyleRange[] ranges, bool merge) {
        int j= 0;
        ArrayList oldRanges= fRanges;
        ArrayList newRanges= new ArrayList(2*ranges.length + oldRanges.size());
        for (int i= 0, n= ranges.length; i < n; i++) {
            StyleRange range= ranges[i];
            fRanges= oldRanges; // for getFirstIndexAfterWindow(...)
            for (int m= getFirstIndexAfterWindow(new Region(range.start, range.length)); j < m; j++)
                newRanges.add(oldRanges.get(j));
            fRanges= newRanges; // for mergeStyleRange(...)
            applyStyleRange(range, merge);
        }
        for (int m= oldRanges.size(); j < m; j++)
            newRanges.add(oldRanges.get(j));
        fRanges= newRanges;
    }

    /**
     * Applies the template_'s style to the target.
     *
     * @param template_ the style range to be used as template_
     * @param target the style range to which to apply the template_
     * @param merge <code>true</code> if the style should be merged instead of replaced
     * @since 3.0
     */
    private void applyStyle(StyleRange template_, StyleRange target, bool merge) {
        if (merge) {
            if (template_.font !is null)
                target.font= template_.font;
            target.fontStyle|= template_.fontStyle;

            if (template_.metrics !is null)
                target.metrics= template_.metrics;

            if (template_.foreground !is null)
                target.foreground= template_.foreground;
            if (template_.background !is null)
                target.background= template_.background;

            target.strikeout|= template_.strikeout;
            if (template_.strikeoutColor !is null)
                target.strikeoutColor= template_.strikeoutColor;

            target.underline|= template_.underline;
            if (template_.underlineStyle !is SWT.NONE)
                target.underlineStyle= template_.underlineStyle;
            if (template_.underlineColor !is null)
                target.underlineColor= template_.underlineColor;

            if (template_.borderStyle !is SWT.NONE)
                target.borderStyle= template_.borderStyle;
            if (template_.borderColor !is null)
                target.borderColor= template_.borderColor;

        } else {
            target.font= template_.font;
            target.fontStyle= template_.fontStyle;
            target.metrics= template_.metrics;
            target.foreground= template_.foreground;
            target.background= template_.background;
            target.strikeout= template_.strikeout;
            target.strikeoutColor= template_.strikeoutColor;
            target.underline= template_.underline;
            target.underlineStyle= template_.underlineStyle;
            target.underlineColor= template_.underlineColor;
            target.borderStyle= template_.borderStyle;
            target.borderColor= template_.borderColor;
        }
    }

    /**
     * Checks whether the given range is a subrange of the presentation's
     * default style range.
     *
     * @param range the range to be checked
     * @exception IllegalArgumentException if range is not a subrange of the presentation's default range
     */
    private void checkConsistency(StyleRange range) {

        if (range is null)
            throw new IllegalArgumentException(null);

        if (fDefaultRange !is null) {

            if (range.start < fDefaultRange.start)
                range.start= fDefaultRange.start;

            int defaultEnd= fDefaultRange.start + fDefaultRange.length;
            int end= range.start + range.length;
            if (end > defaultEnd)
                range.length -= (end - defaultEnd);
        }
    }

    /**
     * Returns the index of the first range which overlaps with the
     * specified window.
     *
     * @param window the window to be used for searching
     * @return the index of the first range overlapping with the window
     */
    private int getFirstIndexInWindow(IRegion window) {
        if (window !is null) {
            int start= window.getOffset();
            int i= -1, j= fRanges.size();
            while (j - i > 1) {
                int k= (i + j) >> 1;
                StyleRange r= cast(StyleRange) fRanges.get(k);
                if (r.start + r.length > start)
                    j= k;
                else
                    i= k;
            }
            return j;
        }
        return 0;
    }

    /**
     * Returns the index of the first range which comes after the specified window and does
     * not overlap with this window.
     *
     * @param window the window to be used for searching
     * @return the index of the first range behind the window and not overlapping with the window
     */
    private int getFirstIndexAfterWindow(IRegion window) {
        if (window !is null) {
            int end= window.getOffset() + window.getLength();
            int i= -1, j= fRanges.size();
            while (j - i > 1) {
                int k= (i + j) >> 1;
                StyleRange r= cast(StyleRange) fRanges.get(k);
                if (r.start < end)
                    i= k;
                else
                    j= k;
            }
            return j;
        }
        return fRanges.size();
    }

    /**
     * Returns a style range which is relative to the specified window and
     * appropriately clipped if necessary. The original style range is not
     * modified.
     *
     * @param window the reference window
     * @param range the absolute range
     * @return the window relative range based on the absolute range
     */
    private StyleRange createWindowRelativeRange(IRegion window, StyleRange range) {
        if (window is null || range is null)
            return range;

        int start= range.start - window.getOffset();
        if (start < 0)
            start= 0;

        int rangeEnd= range.start + range.length;
        int windowEnd= window.getOffset() + window.getLength();
        int end= (rangeEnd > windowEnd ? windowEnd : rangeEnd);
        end -= window.getOffset();

        StyleRange newRange= cast(StyleRange) range.clone();
        newRange.start= start;
        newRange.length= end - start;
        return newRange;
    }

    /**
     * Returns the region which is relative to the specified window and
     * appropriately clipped if necessary.
     *
     * @param coverage the absolute coverage
     * @return the window relative region based on the absolute coverage
     * @since 3.0
     */
    private IRegion createWindowRelativeRegion(IRegion coverage) {
        if (fResultWindow is null || coverage is null)
            return coverage;

        int start= coverage.getOffset() - fResultWindow.getOffset();
        if (start < 0)
            start= 0;

        int rangeEnd= coverage.getOffset() + coverage.getLength();
        int windowEnd= fResultWindow.getOffset() + fResultWindow.getLength();
        int end= (rangeEnd > windowEnd ? windowEnd : rangeEnd);
        end -= fResultWindow.getOffset();

        return new Region(start, end - start);
    }

    /**
     * Returns an iterator which enumerates all style ranged which define a style
     * different from the presentation's default style range. The default style range
     * is not enumerated.
     *
     * @return a style range iterator
     */
    public Iterator getNonDefaultStyleRangeIterator() {
        return new FilterIterator(fDefaultRange !is null);
    }

    /**
     * Returns an iterator which enumerates all style ranges of this presentation
     * except the default style range. The returned <code>StyleRange</code>s
     * are relative to the start of the presentation's result window.
     *
     * @return a style range iterator
     */
    public Iterator getAllStyleRangeIterator() {
        return new FilterIterator(false);
    }

    /**
     * Returns whether this collection contains any style range including
     * the default style range.
     *
     * @return <code>true</code> if there is no style range in this presentation
     */
    public bool isEmpty() {
        return (fDefaultRange is null && getDenumerableRanges() is 0);
    }

    /**
     * Returns the number of style ranges in the presentation not counting the default
     * style range.
     *
     * @return the number of style ranges in the presentation excluding the default style range
     */
    public int getDenumerableRanges() {
        int size= getFirstIndexAfterWindow(fResultWindow) - getFirstIndexInWindow(fResultWindow);
        return (size < 0 ? 0 : size);
    }

    /**
     * Returns the style range with the smallest offset ignoring the default style range or null
     * if the presentation is empty.
     *
     * @return the style range with the smallest offset different from the default style range
     */
    public StyleRange getFirstStyleRange() {
        try {

            StyleRange range= cast(StyleRange) fRanges.get(getFirstIndexInWindow(fResultWindow));
            return createWindowRelativeRange(fResultWindow, range);

        } catch (NoSuchElementException x) {
        } catch (IndexOutOfBoundsException x) {
        }

        return null;
    }

    /**
     * Returns the style range with the highest offset ignoring the default style range.
     *
     * @return the style range with the highest offset different from the default style range
     */
    public StyleRange getLastStyleRange() {
        try {

            StyleRange range=  cast(StyleRange) fRanges.get(getFirstIndexAfterWindow(fResultWindow) - 1);
            return createWindowRelativeRange(fResultWindow, range);

        } catch (NoSuchElementException x) {
            return null;
        } catch (IndexOutOfBoundsException x) {
            return null;
        }
    }

    /**
     * Returns the coverage of this presentation as clipped by the presentation's
     * result window.
     *
     * @return the coverage of this presentation
     */
    public IRegion getCoverage() {

        if (fDefaultRange !is null) {
            StyleRange range= getDefaultStyleRange();
            return new Region(range.start, range.length);
        }

        StyleRange first= getFirstStyleRange();
        StyleRange last= getLastStyleRange();

        if (first is null || last is null)
            return null;

        return new Region(first.start, last.start - first. start + last.length);
    }

    /**
     * Returns the extent of this presentation clipped by the
     * presentation's result window.
     *
     * @return the clipped extent
     * @since 3.0
     */
    public IRegion getExtent() {
        if (fExtent !is null)
            return createWindowRelativeRegion(fExtent);
        return getCoverage();
    }

    /**
     * Clears this presentation by resetting all applied changes.
     * @since 2.0
     */
    public void clear() {
        fDefaultRange= null;
        fResultWindow= null;
        fRanges.clear();
    }


}
