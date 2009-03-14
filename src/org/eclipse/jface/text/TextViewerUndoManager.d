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


module org.eclipse.jface.text.TextViewerUndoManager;

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





import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.KeyListener;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.commands.operations.IUndoContext;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.text.undo.DocumentUndoEvent;
import org.eclipse.text.undo.DocumentUndoManager;
import org.eclipse.text.undo.DocumentUndoManagerRegistry;
import org.eclipse.text.undo.IDocumentUndoListener;
import org.eclipse.text.undo.IDocumentUndoManager;


/**
 * Implementation of {@link org.eclipse.jface.text.IUndoManager} using the shared
 * document undo manager.
 * <p>
 * It registers with the connected text viewer as text input listener, and obtains
 * its undo manager from the current document.  It also monitors mouse and keyboard
 * activities in order to partition the stream of text changes into undo-able
 * edit commands.
 * <p>
 * This class is not intended to be subclassed.
 * </p>
 *
 * @see ITextViewer
 * @see ITextInputListener
 * @see IDocumentUndoManager
 * @see MouseListener
 * @see KeyListener
 * @see DocumentUndoManager
 *
 * @since 3.2
 * @noextend This class is not intended to be subclassed by clients.
 */
public class TextViewerUndoManager : IUndoManager, IUndoManagerExtension {


    /**
     * Internal listener to mouse and key events.
     */
    private class KeyAndMouseListener : MouseListener, KeyListener {

        /*
         * @see MouseListener#mouseDoubleClick
         */
        public void mouseDoubleClick(MouseEvent e) {
        }

        /*
         * If the right mouse button is pressed, the current editing command is closed
         * @see MouseListener#mouseDown
         */
        public void mouseDown(MouseEvent e) {
            if (e.button is 1)
                if (isConnected())
                    fDocumentUndoManager.commit();
        }

        /*
         * @see MouseListener#mouseUp
         */
        public void mouseUp(MouseEvent e) {
        }

        /*
         * @see KeyListener#keyPressed
         */
        public void keyReleased(KeyEvent e) {
        }

        /*
         * On cursor keys, the current editing command is closed
         * @see KeyListener#keyPressed
         */
        public void keyPressed(KeyEvent e) {
            switch (e.keyCode) {
                case SWT.ARROW_UP:
                case SWT.ARROW_DOWN:
                case SWT.ARROW_LEFT:
                case SWT.ARROW_RIGHT:
                    if (isConnected()) {
                        fDocumentUndoManager.commit();
                    }
                    break;
                default:
            }
        }
    }


    /**
     * Internal text input listener.
     */
    private class TextInputListener : ITextInputListener {

        /*
         * @see org.eclipse.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
         */
        public void inputDocumentAboutToBeChanged(IDocument oldInput, IDocument newInput) {
            disconnectDocumentUndoManager();
        }

        /*
         * @see org.eclipse.jface.text.ITextInputListener#inputDocumentChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
         */
        public void inputDocumentChanged(IDocument oldInput, IDocument newInput) {
            connectDocumentUndoManager(newInput);
        }
    }


    /**
     * Internal document undo listener.
     */
    private class DocumentUndoListener : IDocumentUndoListener {

        /*
         * @see org.eclipse.jface.text.IDocumentUndoListener#documentUndoNotification(DocumentUndoEvent)
         */
        public void documentUndoNotification(DocumentUndoEvent event ){
            if (!isConnected()) return;

            int eventType= event.getEventType();
            if (((eventType & DocumentUndoEvent.ABOUT_TO_UNDO) !is 0) || ((eventType & DocumentUndoEvent.ABOUT_TO_REDO) !is 0))  {
                if (event.isCompound()) {
                    ITextViewerExtension extension= null;
                    if ( cast(ITextViewerExtension)fTextViewer )
                        extension= cast(ITextViewerExtension) fTextViewer;

                    if (extension !is null)
                        extension.setRedraw(false);
                }
                fTextViewer.getTextWidget().getDisplay().syncExec(new class()  Runnable {
                    public void run() {
                        if ( cast(TextViewer)fTextViewer )
                            (cast(TextViewer)fTextViewer).ignoreAutoEditStrategies_package(true);
                    }
                });

            } else if (((eventType & DocumentUndoEvent.UNDONE) !is 0) || ((eventType & DocumentUndoEvent.REDONE) !is 0))  {
                fTextViewer.getTextWidget().getDisplay().syncExec(new class()  Runnable {
                    public void run() {
                        if ( cast(TextViewer)fTextViewer )
                            (cast(TextViewer)fTextViewer).ignoreAutoEditStrategies_package(false);
                    }
                });
                if (event.isCompound()) {
                    ITextViewerExtension extension= null;
                    if ( cast(ITextViewerExtension)fTextViewer )
                        extension= cast(ITextViewerExtension) fTextViewer;

                    if (extension !is null)
                        extension.setRedraw(true);
                }

                // Reveal the change if this manager's viewer has the focus.
                if (fTextViewer !is null) {
                    StyledText widget= fTextViewer.getTextWidget();
                    if (widget !is null && !widget.isDisposed() && (widget.isFocusControl()))// || fTextViewer.getTextWidget() is control))
                        selectAndReveal(event.getOffset(), event.getText() is null ? 0 : event.getText().length());
                }
            }
        }

    }

    /** The internal key and mouse event listener */
    private KeyAndMouseListener fKeyAndMouseListener;
    /** The internal text input listener */
    private TextInputListener fTextInputListener;


    /** The text viewer the undo manager is connected to */
    private ITextViewer fTextViewer;

    /** The undo level */
    private int fUndoLevel;

    /** The document undo manager that is active. */
    private IDocumentUndoManager fDocumentUndoManager;

    /** The document that is active. */
    private IDocument fDocument;

    /** The document undo listener */
    private IDocumentUndoListener fDocumentUndoListener;

    /**
     * Creates a new undo manager who remembers the specified number of edit commands.
     *
     * @param undoLevel the length of this manager's history
     */
    public this(int undoLevel) {
        fUndoLevel= undoLevel;
    }

    /**
     * Returns whether this undo manager is connected to a text viewer.
     *
     * @return <code>true</code> if connected, <code>false</code> otherwise
     */
    private bool isConnected() {
        return fTextViewer !is null && fDocumentUndoManager !is null;
    }

    /*
     * @see IUndoManager#beginCompoundChange
     */
    public void beginCompoundChange() {
        if (isConnected()) {
            fDocumentUndoManager.beginCompoundChange();
        }
    }


    /*
     * @see IUndoManager#endCompoundChange
     */
    public void endCompoundChange() {
        if (isConnected()) {
            fDocumentUndoManager.endCompoundChange();
        }
    }

    /**
     * Registers all necessary listeners with the text viewer.
     */
    private void addListeners() {
        StyledText text= fTextViewer.getTextWidget();
        if (text !is null) {
            fKeyAndMouseListener= new KeyAndMouseListener();
            text.addMouseListener(fKeyAndMouseListener);
            text.addKeyListener(fKeyAndMouseListener);
            fTextInputListener= new TextInputListener();
            fTextViewer.addTextInputListener(fTextInputListener);
        }
    }

    /**
     * Unregister all previously installed listeners from the text viewer.
     */
    private void removeListeners() {
        StyledText text= fTextViewer.getTextWidget();
        if (text !is null) {
            if (fKeyAndMouseListener !is null) {
                text.removeMouseListener(fKeyAndMouseListener);
                text.removeKeyListener(fKeyAndMouseListener);
                fKeyAndMouseListener= null;
            }
            if (fTextInputListener !is null) {
                fTextViewer.removeTextInputListener(fTextInputListener);
                fTextInputListener= null;
            }
        }
    }

    /**
     * Shows the given exception in an error dialog.
     *
     * @param title the dialog title
     * @param ex the exception
     */
    private void openErrorDialog(String title, Exception ex) {
        Shell shell= null;
        if (isConnected()) {
            StyledText st= fTextViewer.getTextWidget();
            if (st !is null && !st.isDisposed())
                shell= st.getShell();
        }
        if (Display.getCurrent() !is null)
            MessageDialog.openError(shell, title, ex.msg/+getLocalizedMessage()+/);
        else {
            Display display;
            Shell finalShell= shell;
            if (finalShell !is null)
                display= finalShell.getDisplay();
            else
                display= Display.getDefault();
            display.syncExec(dgRunnable((Shell finalShell_, String title_, Exception ex_ ) {
                MessageDialog.openError(finalShell_, title_, ex_.msg/+getLocalizedMessage()+/);
            },finalShell, title, ex ));
        }
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#setMaximalUndoLevel(int)
     */
    public void setMaximalUndoLevel(int undoLevel) {
        fUndoLevel= Math.max(0, undoLevel);
        if (isConnected()) {
            fDocumentUndoManager.setMaximalUndoLevel(fUndoLevel);
        }
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#connect(org.eclipse.jface.text.ITextViewer)
     */
    public void connect(ITextViewer textViewer) {
        if (fTextViewer is null && textViewer !is null) {
            fTextViewer= textViewer;
            addListeners();
        }
        IDocument doc= fTextViewer.getDocument();
        connectDocumentUndoManager(doc);
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#disconnect()
     */
    public void disconnect() {
        if (fTextViewer !is null) {
            removeListeners();
            fTextViewer= null;
        }
        disconnectDocumentUndoManager();
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#reset()
     */
    public void reset() {
        if (isConnected())
            fDocumentUndoManager.reset();

    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#redoable()
     */
    public bool redoable() {
        if (isConnected())
            return fDocumentUndoManager.redoable();
        return false;
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#undoable()
     */
    public bool undoable() {
        if (isConnected())
            return fDocumentUndoManager.undoable();
        return false;
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#redo()
     */
    public void redo() {
        if (isConnected()) {
            try {
                fDocumentUndoManager.redo();
            } catch (ExecutionException ex) {
                openErrorDialog(JFaceTextMessages.getString("DefaultUndoManager.error.redoFailed.title"), ex); //$NON-NLS-1$
            }
        }
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#undo()
     */
    public void undo() {
        if (isConnected()) {
            try {
                fDocumentUndoManager.undo();
            } catch (ExecutionException ex) {
                openErrorDialog(JFaceTextMessages.getString("DefaultUndoManager.error.undoFailed.title"), ex); //$NON-NLS-1$
            }
        }
    }

    /**
     * Selects and reveals the specified range.
     *
     * @param offset the offset of the range
     * @param length the length of the range
     */
    private void selectAndReveal(int offset, int length) {
        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fTextViewer;
            extension.exposeModelRange(new Region(offset, length));
        } else if (!fTextViewer.overlapsWithVisibleRegion(offset, length))
            fTextViewer.resetVisibleRegion();

        fTextViewer.setSelectedRange(offset, length);
        fTextViewer.revealRange(offset, length);
    }

    /*
     * @see org.eclipse.jface.text.IUndoManagerExtension#getUndoContext()
     */
    public IUndoContext getUndoContext() {
        if (isConnected()) {
            return fDocumentUndoManager.getUndoContext();
        }
        return null;
    }

    private void connectDocumentUndoManager(IDocument document) {
        disconnectDocumentUndoManager();
        if (document !is null) {
            fDocument= document;
            DocumentUndoManagerRegistry.connect(fDocument);
            fDocumentUndoManager= DocumentUndoManagerRegistry.getDocumentUndoManager(fDocument);
            fDocumentUndoManager.connect(this);
            setMaximalUndoLevel(fUndoLevel);
            fDocumentUndoListener= new DocumentUndoListener();
            fDocumentUndoManager.addDocumentUndoListener(fDocumentUndoListener);
        }
    }

    private void disconnectDocumentUndoManager() {
        if (fDocumentUndoManager !is null) {
            fDocumentUndoManager.disconnect(this);
            DocumentUndoManagerRegistry.disconnect(fDocument);
            fDocumentUndoManager.removeDocumentUndoListener(fDocumentUndoListener);
            fDocumentUndoListener= null;
            fDocumentUndoManager= null;
        }
    }
}
