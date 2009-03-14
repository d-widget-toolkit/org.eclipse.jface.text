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
module org.eclipse.jface.text.DefaultDocumentAdapter;

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
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Set;





import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.TextChangeListener;
import org.eclipse.swt.custom.TextChangedEvent;
import org.eclipse.swt.custom.TextChangingEvent;
import org.eclipse.core.runtime.Assert;


/**
 * Default implementation of {@link org.eclipse.jface.text.IDocumentAdapter}.
 * <p>
 * <strong>Note:</strong> This adapter does not work if the widget auto-wraps the text.
 * </p>
 */
class DefaultDocumentAdapter : IDocumentAdapter, IDocumentListener, IDocumentAdapterExtension {

    /** The adapted document. */
    private IDocument fDocument;
    /** The document clone for the non-forwarding case. */
    private IDocument fDocumentClone;
    /** The original content */
    private String fOriginalContent;
    /** The original line delimiters */
    private String[] fOriginalLineDelimiters;
    /** The registered text change listeners */
    private List fTextChangeListeners;
    /**
     * The remembered document event
     * @since 2.0
     */
    private DocumentEvent fEvent;
    /** The line delimiter */
    private String fLineDelimiter= null;
    /**
     * Indicates whether this adapter is forwarding document changes
     * @since 2.0
     */
    private bool fIsForwarding= true;
    /**
     * Length of document at receipt of <code>documentAboutToBeChanged</code>
     * @since 2.1
     */
    private int fRememberedLengthOfDocument;
    /**
     * Length of first document line at receipt of <code>documentAboutToBeChanged</code>
     * @since 2.1
     */
    private int fRememberedLengthOfFirstLine;
    /**
     * The data of the event at receipt of <code>documentAboutToBeChanged</code>
     * @since 2.1
     */
    private  DocumentEvent fOriginalEvent;


    /**
     * Creates a new document adapter which is initially not connected to
     * any document.
     */
    public this() {
        fTextChangeListeners= new ArrayList(1);
        fOriginalEvent= new DocumentEvent();
    }

    /**
     * Sets the given document as the document to be adapted.
     *
     * @param document the document to be adapted or <code>null</code> if there is no document
     */
    public void setDocument(IDocument document) {

        if (fDocument !is null)
            fDocument.removePrenotifiedDocumentListener(this);

        fDocument= document;
        fLineDelimiter= null;

        if (!fIsForwarding) {
            fDocumentClone= null;
            if (fDocument !is null) {
                fOriginalContent= fDocument.get();
                fOriginalLineDelimiters= fDocument.getLegalLineDelimiters();
            } else {
                fOriginalContent= null;
                fOriginalLineDelimiters= null;
            }
        }

        if (fDocument !is null)
            fDocument.addPrenotifiedDocumentListener(this);
    }

    /*
     * @see StyledTextContent#addTextChangeListener(TextChangeListener)
     */
    public void addTextChangeListener(TextChangeListener listener) {
        Assert.isNotNull(cast(Object)listener);
        if (!fTextChangeListeners.contains(cast(Object)listener))
            fTextChangeListeners.add(cast(Object)listener);
    }

    /*
     * @see StyledTextContent#removeTextChangeListener(TextChangeListener)
     */
    public void removeTextChangeListener(TextChangeListener listener) {
        Assert.isNotNull(cast(Object)listener);
        fTextChangeListeners.remove(cast(Object)listener);
    }

    /**
     * Tries to repair the line information.
     *
     * @param document the document
     * @see IRepairableDocument#repairLineInformation()
     * @since 3.0
     */
    private void repairLineInformation(IDocument document) {
        if ( cast(IRepairableDocument)document ) {
            IRepairableDocument repairable= cast(IRepairableDocument) document;
            repairable.repairLineInformation();
        }
    }

    /**
     * Returns the line for the given line number.
     *
     * @param document the document
     * @param line the line number
     * @return the content of the line of the given number in the given document
     * @throws BadLocationException if the line number is invalid for the adapted document
     * @since 3.0
     */
    private String doGetLine(IDocument document, int line)  {
        IRegion r= document.getLineInformation(line);
        return document.get(r.getOffset(), r.getLength());
    }

    private IDocument getDocumentForRead() {
        if (!fIsForwarding) {
            if (fDocumentClone is null) {
                String content= fOriginalContent is null ? "" : fOriginalContent; //$NON-NLS-1$
                String[] delims= fOriginalLineDelimiters is null ? DefaultLineTracker.DELIMITERS : fOriginalLineDelimiters;
                fDocumentClone= new DocumentClone(content, delims);
            }
            return fDocumentClone;
        }

        return fDocument;
    }

    /*
     * @see StyledTextContent#getLine(int)
     */
    public String getLine(int line) {

        IDocument document= getDocumentForRead();
        try {
            return doGetLine(document, line);
        } catch (BadLocationException x) {
            repairLineInformation(document);
            try {
                return doGetLine(document, line);
            } catch (BadLocationException x2) {
            }
        }

        SWT.error(SWT.ERROR_INVALID_ARGUMENT);
        return null;
    }

    /*
     * @see StyledTextContent#getLineAtOffset(int)
     */
    public int getLineAtOffset(int offset) {
        IDocument document= getDocumentForRead();
        try {
            return document.getLineOfOffset(offset);
        } catch (BadLocationException x) {
            repairLineInformation(document);
            try {
                return document.getLineOfOffset(offset);
            } catch (BadLocationException x2) {
            }
        }

        SWT.error(SWT.ERROR_INVALID_ARGUMENT);
        return -1;
    }

    /*
     * @see StyledTextContent#getLineCount()
     */
    public int getLineCount() {
        return getDocumentForRead().getNumberOfLines();
    }

    /*
     * @see StyledTextContent#getOffsetAtLine(int)
     */
    public int getOffsetAtLine(int line) {
        IDocument document= getDocumentForRead();
        try {
            return document.getLineOffset(line);
        } catch (BadLocationException x) {
            repairLineInformation(document);
            try {
                return document.getLineOffset(line);
            } catch (BadLocationException x2) {
            }
        }

        SWT.error(SWT.ERROR_INVALID_ARGUMENT);
        return -1;
    }

    /*
     * @see StyledTextContent#getTextRange(int, int)
     */
    public String getTextRange(int offset, int length) {
        try {
            return getDocumentForRead().get(offset, length);
        } catch (BadLocationException x) {
            SWT.error(SWT.ERROR_INVALID_ARGUMENT);
            return null;
        }
    }

    /*
     * @see StyledTextContent#replaceTextRange(int, int, String)
     */
    public void replaceTextRange(int pos, int length, String text) {
        try {
            fDocument.replace(pos, length, text);
        } catch (BadLocationException x) {
            SWT.error(SWT.ERROR_INVALID_ARGUMENT);
        }
    }

    /*
     * @see StyledTextContent#setText(String)
     */
    public void setText(String text) {
        fDocument.set(text);
    }

    /*
     * @see StyledTextContent#getCharCount()
     */
    public int getCharCount() {
        return getDocumentForRead().getLength();
    }

    /*
     * @see StyledTextContent#getLineDelimiter()
     */
    public String getLineDelimiter() {
        if (fLineDelimiter is null)
            fLineDelimiter= TextUtilities.getDefaultLineDelimiter(fDocument);
        return fLineDelimiter;
    }

    /*
     * @see IDocumentListener#documentChanged(DocumentEvent)
     */
    public void documentChanged(DocumentEvent event) {
        // check whether the given event is the one which was remembered
        if (fEvent is null || event !is fEvent)
            return;

        if (isPatchedEvent(event) || (event.getOffset() is 0 && event.getLength() is fRememberedLengthOfDocument)) {
            fLineDelimiter= null;
            fireTextSet();
        } else {
            if (event.getOffset() < fRememberedLengthOfFirstLine)
                fLineDelimiter= null;
            fireTextChanged();
        }
    }

    /*
     * @see IDocumentListener#documentAboutToBeChanged(DocumentEvent)
     */
    public void documentAboutToBeChanged(DocumentEvent event) {

        fRememberedLengthOfDocument= fDocument.getLength();
        try {
            fRememberedLengthOfFirstLine= fDocument.getLineLength(0);
        } catch (BadLocationException e) {
            fRememberedLengthOfFirstLine= -1;
        }

        fEvent= event;
        rememberEventData(fEvent);
        fireTextChanging();
    }

    /**
     * Checks whether this event has been changed between <code>documentAboutToBeChanged</code> and
     * <code>documentChanged</code>.
     *
     * @param event the event to be checked
     * @return <code>true</code> if the event has been changed, <code>false</code> otherwise
     */
    private bool isPatchedEvent(DocumentEvent event) {
        return fOriginalEvent.fOffset !is event.fOffset || fOriginalEvent.fLength !is event.fLength || fOriginalEvent.fText !is event.fText;
    }

    /**
     * Makes a copy of the given event and remembers it.
     *
     * @param event the event to be copied
     */
    private void rememberEventData(DocumentEvent event) {
        fOriginalEvent.fOffset= event.fOffset;
        fOriginalEvent.fLength= event.fLength;
        fOriginalEvent.fText= event.fText;
    }

    /**
     * Sends a text changed event to all registered listeners.
     */
    private void fireTextChanged() {

        if (!fIsForwarding)
            return;

        TextChangedEvent event= new TextChangedEvent(this);

        if (fTextChangeListeners !is null && fTextChangeListeners.size() > 0) {
            Iterator e= (new ArrayList(fTextChangeListeners)).iterator();
            while (e.hasNext())
                (cast(TextChangeListener) e.next()).textChanged(event);
        }
    }

    /**
     * Sends a text set event to all registered listeners.
     */
    private void fireTextSet() {

        if (!fIsForwarding)
            return;

        TextChangedEvent event = new TextChangedEvent(this);

        if (fTextChangeListeners !is null && fTextChangeListeners.size() > 0) {
            Iterator e= (new ArrayList(fTextChangeListeners)).iterator();
            while (e.hasNext())
                (cast(TextChangeListener) e.next()).textSet(event);
        }
    }

    /**
     * Sends the text changing event to all registered listeners.
     */
    private void fireTextChanging() {

        if (!fIsForwarding)
            return;

        try {
            IDocument document= fEvent.getDocument();
            if (document is null)
                return;

            TextChangingEvent event= new TextChangingEvent(this);
            event.start= fEvent.fOffset;
            event.replaceCharCount= fEvent.fLength;
            event.replaceLineCount= document.getNumberOfLines(fEvent.fOffset, fEvent.fLength) - 1;
            event.newText= fEvent.fText;
            event.newCharCount= (fEvent.fText is null ? 0 : fEvent.fText.length());
            event.newLineCount= (fEvent.fText is null ? 0 : document.computeNumberOfLines(fEvent.fText));

            if (fTextChangeListeners !is null && fTextChangeListeners.size() > 0) {
                Iterator e= (new ArrayList(fTextChangeListeners)).iterator();
                while (e.hasNext())
                     (cast(TextChangeListener) e.next()).textChanging(event);
            }

        } catch (BadLocationException e) {
        }
    }

    /*
     * @see IDocumentAdapterExtension#resumeForwardingDocumentChanges()
     * @since 2.0
     */
    public void resumeForwardingDocumentChanges() {
        fIsForwarding= true;
        fDocumentClone= null;
        fOriginalContent= null;
        fOriginalLineDelimiters= null;
        fireTextSet();
    }

    /*
     * @see IDocumentAdapterExtension#stopForwardingDocumentChanges()
     * @since 2.0
     */
    public void stopForwardingDocumentChanges() {
        fDocumentClone= null;
        fOriginalContent= fDocument.get();
        fOriginalLineDelimiters= fDocument.getLegalLineDelimiters();
        fIsForwarding= false;
    }

    /++
     + SWT extension
     +/
    public int utf8AdjustOffset( int offset ){
        if (fDocument is null)
            return offset;
        if (offset is 0)
            return offset;
        if( offset >= fDocument.getLength() ){
            return offset;
        }
        while( fDocument.getChar(offset) & 0xC0 is 0x80 && offset > 0 ){
            offset--;
        }
        return offset;
    }
}
