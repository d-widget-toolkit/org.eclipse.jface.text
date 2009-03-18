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


module org.eclipse.jface.text.DefaultTextDoubleClickStrategy;

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

import java.text.CharacterIterator;

import java.mangoicu.UBreakIterator;

/**
 * Standard implementation of
 * {@link org.eclipse.jface.text.ITextDoubleClickStrategy}.
 * <p>
 * Selects words using <code>java.text.UBreakIterator</code> for the default
 * locale.</p>
 * <p>
 * This class is not intended to be subclassed.
 * </p>
 *
 * @see java.text.UBreakIterator
 * @noextend This class is not intended to be subclassed by clients.
 */
public class DefaultTextDoubleClickStrategy : ITextDoubleClickStrategy {

/++
    /**
     * Implements a character iterator that works directly on
     * instances of <code>IDocument</code>. Used to collaborate with
     * the break iterator.
     *
     * @see IDocument
     * @since 2.0
     */
    static class DocumentCharacterIterator : CharacterIterator {

        /** Document to iterate over. */
        private IDocument fDocument;
        /** Start offset of iteration. */
        private int fOffset= -1;
        /** End offset of iteration. */
        private int fEndOffset= -1;
        /** Current offset of iteration. */
        private int fIndex= -1;

        /** Creates a new document iterator. */
        public this() {
        }

        /**
         * Configures this document iterator with the document section to be visited.
         *
         * @param document the document to be iterated
         * @param iteratorRange the range in the document to be iterated
         */
        public void setDocument(IDocument document, IRegion iteratorRange) {
            fDocument= document;
            fOffset= iteratorRange.getOffset();
            fEndOffset= fOffset + iteratorRange.getLength();
        }

        /*
         * @see CharacterIterator#first()
         */
        public char first() {
            fIndex= fOffset;
            return current();
        }

        /*
         * @see CharacterIterator#last()
         */
        public char last() {
            fIndex= fOffset < fEndOffset ? fEndOffset -1 : fEndOffset;
            return current();
        }

        /*
         * @see CharacterIterator#current()
         */
        public char current() {
            if (fOffset <= fIndex && fIndex < fEndOffset) {
                try {
                    return fDocument.getChar(fIndex);
                } catch (BadLocationException x) {
                }
            }
            return DONE;
        }

        /*
         * @see CharacterIterator#next()
         */
        public char next() {
            ++fIndex;
            int end= getEndIndex();
            if (fIndex >= end) {
                fIndex= end;
                return DONE;
            }
            return current();
        }

        /*
         * @see CharacterIterator#previous()
         */
        public char previous() {
            if (fIndex is fOffset)
                return DONE;

            if (fIndex > fOffset)
                -- fIndex;

            return current();
        }

        /*
         * @see CharacterIterator#setIndex(int)
         */
        public char setIndex(int index) {
            fIndex= index;
            return current();
        }

        /*
         * @see CharacterIterator#getBeginIndex()
         */
        public int getBeginIndex() {
            return fOffset;
        }

        /*
         * @see CharacterIterator#getEndIndex()
         */
        public int getEndIndex() {
            return fEndOffset;
        }

        /*
         * @see CharacterIterator#getIndex()
         */
        public int getIndex() {
            return fIndex;
        }

        /*
         * @see CharacterIterator#clone()
         */
        public Object clone() {
            DocumentCharacterIterator i= new DocumentCharacterIterator();
            i.fDocument= fDocument;
            i.fIndex= fIndex;
            i.fOffset= fOffset;
            i.fEndOffset= fEndOffset;
            return i;
        }
    }
++/

    /**
     * The document character iterator used by this strategy.
     * @since 2.0
     */
//     private DocumentCharacterIterator fDocIter= new DocumentCharacterIterator();


    /**
     * Creates a new default text double click strategy.
     */
    public this() {
//         super();
    }

    /*
     * @see org.eclipse.jface.text.ITextDoubleClickStrategy#doubleClicked(org.eclipse.jface.text.ITextViewer)
     */
    public void doubleClicked(ITextViewer text) {

        int position= text.getSelectedRange().x;

        if (position < 0)
            return;

        try {

            IDocument document= text.getDocument();
            IRegion line= document.getLineInformationOfOffset(position);
            if (position is line.getOffset() + line.getLength())
                return;

            //mangoicu
//             fDocIter.setDocument(document, line);
            String strLine = document.get( line.getOffset(), line.getLength() );
            UBreakIterator breakIter= UBreakIterator.openWordIterator( ULocale.Default, strLine/+fDocIter+/ );


            //int start= breakIter.preceding(position);
            int start= breakIter.previous(position); // mangoicu
            if (start is UBreakIterator.DONE)
                start= line.getOffset();

            int end= breakIter.following(position);
            if (end is UBreakIterator.DONE)
                end= line.getOffset() + line.getLength();

            if (breakIter.isBoundary(position)) {
                if (end - position > position- start)
                    start= position;
                else
                    end= position;
            }

            if (start !is end)
                text.setSelectedRange(start, end - start);

        } catch (BadLocationException x) {
        }
    }
}
