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


module org.eclipse.jface.text.DefaultUndoManager;

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
import java.util.Set;




import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.KeyListener;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.commands.operations.AbstractOperation;
import org.eclipse.core.commands.operations.IOperationHistory;
import org.eclipse.core.commands.operations.IOperationHistoryListener;
import org.eclipse.core.commands.operations.IUndoContext;
import org.eclipse.core.commands.operations.IUndoableOperation;
import org.eclipse.core.commands.operations.ObjectUndoContext;
import org.eclipse.core.commands.operations.OperationHistoryEvent;
import org.eclipse.core.commands.operations.OperationHistoryFactory;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.jface.dialogs.MessageDialog;


/**
 * Standard implementation of {@link org.eclipse.jface.text.IUndoManager}.
 * <p>
 * It registers with the connected text viewer as text input listener and
 * document listener and logs all changes. It also monitors mouse and keyboard
 * activities in order to partition the stream of text changes into undo-able
 * edit commands.
 * </p>
 * <p>
 * Since 3.1 this undo manager is a facade to the global operation history.
 * </p>
 * <p>
 * The usage of {@link org.eclipse.core.runtime.IAdaptable} in the JFace
 * layer has been approved by Platform UI, see: https://bugs.eclipse.org/bugs/show_bug.cgi?id=87669#c9
 * </p>
 * <p>
 * This class is not intended to be subclassed.
 * </p>
 *
 * @see org.eclipse.jface.text.ITextViewer
 * @see org.eclipse.jface.text.ITextInputListener
 * @see org.eclipse.jface.text.IDocumentListener
 * @see org.eclipse.core.commands.operations.IUndoableOperation
 * @see org.eclipse.core.commands.operations.IOperationHistory
 * @see MouseListener
 * @see KeyListener
 * @deprecated As of 3.2, replaced by {@link TextViewerUndoManager}
 * @noextend This class is not intended to be subclassed by clients.
 */
public class DefaultUndoManager : IUndoManager, IUndoManagerExtension {

    /**
     * Represents an undo-able edit command.
     * <p>
     * Since 3.1 this implements the interface for IUndoableOperation.
     * </p>
     */
    class TextCommand : AbstractOperation {

        /** The start index of the replaced text. */
        protected int fStart= -1;
        /** The end index of the replaced text. */
        protected int fEnd= -1;
        /** The newly inserted text. */
        protected String fText;
        /** The replaced text. */
        protected String fPreservedText;

        /** The undo modification stamp. */
        protected long fUndoModificationStamp= IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP;
        /** The redo modification stamp. */
        protected long fRedoModificationStamp= IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP;

        /**
         * Creates a new text command.
         *
         * @param context the undo context for this command
         * @since 3.1
         */
        this(IUndoContext context) {
            super(JFaceTextMessages.getString("DefaultUndoManager.operationLabel")); //$NON-NLS-1$
            addContext(context);
        }

        /**
         * Re-initializes this text command.
         */
        protected void reinitialize() {
            fStart= fEnd= -1;
            fText= fPreservedText= null;
            fUndoModificationStamp= IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP;
            fRedoModificationStamp= IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP;
        }

        /**
         * Sets the start and the end index of this command.
         *
         * @param start the start index
         * @param end the end index
         */
        protected void set(int start, int end) {
            fStart= start;
            fEnd= end;
            fText= null;
            fPreservedText= null;
        }

        /*
         * @see org.eclipse.core.commands.operations.IUndoableOperation#dispose()
         * @since 3.1
         */
        public void dispose() {
            reinitialize();
        }

        /**
         * Undo the change described by this command.
         *
         * @since 2.0
         */
        protected void undoTextChange() {
            try {
                IDocument document= fTextViewer.getDocument();
                if ( cast(IDocumentExtension4)document )
                    (cast(IDocumentExtension4)document).replace(fStart, fText.length(), fPreservedText, fUndoModificationStamp);
                else
                    document.replace(fStart, fText.length(), fPreservedText);
            } catch (BadLocationException x) {
            }
        }

        /*
         * @see org.eclipse.core.commands.operations.IUndoableOperation#canUndo()
         * @since 3.1
         */
        public bool canUndo() {

            if (isConnected() && isValid()) {
                IDocument doc= fTextViewer.getDocument();
                if ( cast(IDocumentExtension4)doc ) {
                    long docStamp= (cast(IDocumentExtension4)doc).getModificationStamp();

                    // Normal case: an undo is valid if its redo will restore document
                    // to its current modification stamp
                    bool canUndo= docStamp is IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP ||
                        docStamp is getRedoModificationStamp();

                    /* Special case to check if the answer is false.
                     * If the last document change was empty, then the document's
                     * modification stamp was incremented but nothing was committed.
                     * The operation being queried has an older stamp.  In this case only,
                     * the comparison is different.  A sequence of document changes that
                     * include an empty change is handled correctly when a valid commit
                     * follows the empty change, but when #canUndo() is queried just after
                     * an empty change, we must special case the check.  The check is very
                     * specific to prevent false positives.
                     * see https://bugs.eclipse.org/bugs/show_bug.cgi?id=98245
                     */
                    if (!canUndo &&
                            this is fHistory.getUndoOperation(fUndoContext)  &&  // this is the latest operation
                            this !is fCurrent && // there is a more current operation not on the stack
                            !fCurrent.isValid() &&  // the current operation is not a valid document modification
                            fCurrent.fUndoModificationStamp !is // the invalid current operation has a document stamp
                                IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP) {
                        canUndo= fCurrent.fRedoModificationStamp is docStamp;
                    }
                    /*
                     * When the composite is the current command, it may hold the timestamp
                     * of a no-op change.  We check this here rather than in an override of
                     * canUndo() in CompoundTextCommand simply to keep all the special case checks
                     * in one place.
                     */
                    if (!canUndo &&
                            this is fHistory.getUndoOperation(fUndoContext)  &&  // this is the latest operation
                            null !is cast(CompoundTextCommand)this &&
                            this is fCurrent && // this is the current operation
                            this.fStart is -1 &&  // the current operation text is not valid
                            fCurrent.fRedoModificationStamp !is IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP) {  // but it has a redo stamp
                        canUndo= fCurrent.fRedoModificationStamp is docStamp;
                    }

                }
                // if there is no timestamp to check, simply return true per the 3.0.1 behavior
                return true;
            }
            return false;
        }

        /*
         * @see org.eclipse.core.commands.operations.IUndoableOperation#canRedo()
         * @since 3.1
         */
        public bool canRedo() {
            if (isConnected() && isValid()) {
                IDocument doc= fTextViewer.getDocument();
                if ( cast(IDocumentExtension4)doc ) {
                    long docStamp= (cast(IDocumentExtension4)doc).getModificationStamp();
                    return docStamp is IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP ||
                        docStamp is getUndoModificationStamp();
                }
                // if there is no timestamp to check, simply return true per the 3.0.1 behavior
                return true;
            }
            return false;
        }

        /*
         * @see org.eclipse.core.commands.operations.IUndoableOperation#canExecute()
         * @since 3.1
         */
        public bool canExecute() {
            return isConnected();
        }

        /*
         * @see org.eclipse.core.commands.operations.IUndoableOperation#execute(org.eclipse.core.runtime.IProgressMonitor, org.eclipse.core.runtime.IAdaptable)
         * @since 3.1
         */
        public IStatus execute(IProgressMonitor monitor, IAdaptable uiInfo) {
            // Text commands execute as they are typed, so executing one has no effect.
            return Status.OK_STATUS;
        }

        /*
         * Undo the change described by this command. Also selects and
         * reveals the change.
         */

        /**
         * Undo the change described by this command. Also selects and
         * reveals the change.
         *
         * @param monitor   the progress monitor to use if necessary
         * @param uiInfo    an adaptable that can provide UI info if needed
         * @return the status
         */
        public IStatus undo(IProgressMonitor monitor, IAdaptable uiInfo) {
            if (isValid()) {
                undoTextChange();
                selectAndReveal(fStart, fPreservedText is null ? 0 : fPreservedText.length());
                resetProcessChangeSate();
                return Status.OK_STATUS;
            }
            return IOperationHistory.OPERATION_INVALID_STATUS;
        }

        /**
         * Re-applies the change described by this command.
         *
         * @since 2.0
         */
        protected void redoTextChange() {
            try {
                IDocument document= fTextViewer.getDocument();
                if ( cast(IDocumentExtension4)document )
                    (cast(IDocumentExtension4)document).replace(fStart, fEnd - fStart, fText, fRedoModificationStamp);
                else
                    fTextViewer.getDocument().replace(fStart, fEnd - fStart, fText);
            } catch (BadLocationException x) {
            }
        }

        /**
         * Re-applies the change described by this command that previously been
         * rolled back. Also selects and reveals the change.
         *
         * @param monitor   the progress monitor to use if necessary
         * @param uiInfo    an adaptable that can provide UI info if needed
         * @return the status
         */
        public IStatus redo(IProgressMonitor monitor, IAdaptable uiInfo) {
            if (isValid()) {
                redoTextChange();
                resetProcessChangeSate();
                selectAndReveal(fStart, fText is null ? 0 : fText.length());
                return Status.OK_STATUS;
            }
            return IOperationHistory.OPERATION_INVALID_STATUS;
        }

        /**
         * Update the command in response to a commit.
         *
         * @since 3.1
         */

        protected void updateCommand() {
            fText= fTextBuffer.toString();
            fTextBuffer.setLength(0);
            fPreservedText= fPreservedTextBuffer.toString();
            fPreservedTextBuffer.setLength(0);
        }

        /**
         * Creates a new uncommitted text command depending on whether
         * a compound change is currently being executed.
         *
         * @return a new, uncommitted text command or a compound text command
         */
        protected TextCommand createCurrent() {
            return fFoldingIntoCompoundChange ? new CompoundTextCommand(fUndoContext) : new TextCommand(fUndoContext);
        }

        /**
         * Commits the current change into this command.
         */
        protected void commit() {
            if (fStart < 0) {
                if (fFoldingIntoCompoundChange) {
                    fCurrent= createCurrent();
                } else {
                    reinitialize();
                }
            } else {
                updateCommand();
                fCurrent= createCurrent();
            }
            resetProcessChangeSate();
        }

        /**
         * Updates the text from the buffers without resetting
         * the buffers or adding anything to the stack.
         *
         * @since 3.1
         */
        protected void pretendCommit() {
            if (fStart > -1) {
                fText= fTextBuffer.toString();
                fPreservedText= fPreservedTextBuffer.toString();
            }
        }

        /**
         * Attempt a commit of this command and answer true if a new
         * fCurrent was created as a result of the commit.
         *
         * @return true if the command was committed and created a
         * new fCurrent, false if not.
         * @since 3.1
         */
        protected bool attemptCommit() {
            pretendCommit();
            if (isValid()) {
                this.outer.commit();
                return true;
            }
            return false;
        }

        /**
         * Checks whether this text command is valid for undo or redo.
         *
         * @return <code>true</code> if the command is valid for undo or redo
         * @since 3.1
         */
        protected bool isValid() {
            return fStart > -1 &&
                fEnd > -1 &&
                fText !is null;
        }

        /*
         * @see java.lang.Object#toString()
         * @since 3.1
         */
        public override String toString() {
            String delimiter= ", "; //$NON-NLS-1$
            StringBuffer text= new StringBuffer(super.toString());
            text.append("\n"); //$NON-NLS-1$
            text.append(this.classinfo.name);
            text.append(" undo modification stamp: "); //$NON-NLS-1$
            text.append(fUndoModificationStamp);
            text.append(" redo modification stamp: "); //$NON-NLS-1$
            text.append(fRedoModificationStamp);
            text.append(" start: "); //$NON-NLS-1$
            text.append(fStart);
            text.append(delimiter);
            text.append("end: "); //$NON-NLS-1$
            text.append(fEnd);
            text.append(delimiter);
            text.append("text: '"); //$NON-NLS-1$
            text.append(fText);
            text.append('\'');
            text.append(delimiter);
            text.append("preservedText: '"); //$NON-NLS-1$
            text.append(fPreservedText);
            text.append('\'');
            return text.toString();
        }

        /**
         * Return the undo modification stamp
         *
         * @return the undo modification stamp for this command
         * @since 3.1
         */
        protected long getUndoModificationStamp() {
            return fUndoModificationStamp;
        }

        /**
         * Return the redo modification stamp
         *
         * @return the redo modification stamp for this command
         * @since 3.1
         */
        protected long getRedoModificationStamp() {
            return fRedoModificationStamp;
        }
    }

    /**
     * Represents an undo-able edit command consisting of several
     * individual edit commands.
     */
    class CompoundTextCommand : TextCommand {

        /** The list of individual commands */
        private List fCommands;

        /**
         * Creates a new compound text command.
         *
         * @param context the undo context for this command
         * @since 3.1
         */
        this(IUndoContext context) {
            super(context);
            fCommands= new ArrayList();
        }

        /**
         * Adds a new individual command to this compound command.
         *
         * @param command the command to be added
         */
        protected void add(TextCommand command) {
            fCommands.add(command);
        }

        /*
         * @see org.eclipse.jface.text.DefaultUndoManager.TextCommand#undo()
         */
        public IStatus undo(IProgressMonitor monitor, IAdaptable uiInfo) {
            resetProcessChangeSate();

            int size= fCommands.size();
            if (size > 0) {

                TextCommand c;

                for (int i= size -1; i > 0;  --i) {
                    c= cast(TextCommand) fCommands.get(i);
                    c.undoTextChange();
                }

                c= cast(TextCommand) fCommands.get(0);
                c.undo(monitor, uiInfo);
            }

            return Status.OK_STATUS;
        }

        /*
         * @see org.eclipse.jface.text.DefaultUndoManager.TextCommand#redo()
         */
        public IStatus redo(IProgressMonitor monitor, IAdaptable uiInfo) {
            resetProcessChangeSate();

            int size= fCommands.size();
            if (size > 0) {

                TextCommand c;

                for (int i= 0; i < size -1;  ++i) {
                    c= cast(TextCommand) fCommands.get(i);
                    c.redoTextChange();
                }

                c= cast(TextCommand) fCommands.get(size -1);
                c.redo(monitor, uiInfo);
            }
            return Status.OK_STATUS;
        }

        /*
         * @see TextCommand#updateCommand

         */

        protected void updateCommand() {
            // first gather the data from the buffers
            super.updateCommand();

            // the result of the command update is stored as a child command
            TextCommand c= new TextCommand(fUndoContext);
            c.fStart= fStart;
            c.fEnd= fEnd;
            c.fText= fText;
            c.fPreservedText= fPreservedText;
            c.fUndoModificationStamp= fUndoModificationStamp;
            c.fRedoModificationStamp= fRedoModificationStamp;
            add(c);

            // clear out all indexes now that the child is added
            reinitialize();
        }

        /*
         * @see TextCommand#createCurrent
         */
        protected TextCommand createCurrent() {

            if (!fFoldingIntoCompoundChange)
                return new TextCommand(fUndoContext);

            reinitialize();
            return this;
        }

        /*
         * @see org.eclipse.jface.text.DefaultUndoManager.TextCommand#commit()
         */
        protected void commit() {
            // if there is pending data, update the command
            if (fStart > -1)
                updateCommand();
            fCurrent= createCurrent();
            resetProcessChangeSate();
        }

        /**
         * Checks whether the command is valid for undo or redo.
         *
         * @return true if the command is valid.
         * @since 3.1
         */
        protected bool isValid() {
            if (isConnected())
                return (fStart > -1 || fCommands.size() > 0);
            return false;
        }

        /**
         * Returns the undo modification stamp.
         *
         * @return the undo modification stamp
         * @since 3.1
         */
        protected long getUndoModificationStamp() {
            if (fStart > -1)
                return super.getUndoModificationStamp();
            else if (fCommands.size() > 0)
                return (cast(TextCommand)fCommands.get(0)).getUndoModificationStamp();

            return fUndoModificationStamp;
        }

        /**
         * Returns the redo modification stamp.
         *
         * @return the redo modification stamp
         * @since 3.1
         */
        protected long getRedoModificationStamp() {
            if (fStart > -1)
                return super.getRedoModificationStamp();
            else if (fCommands.size() > 0)
                return (cast(TextCommand)fCommands.get(fCommands.size()-1)).getRedoModificationStamp();

            return fRedoModificationStamp;
        }
    }

    /**
     * Internal listener to mouse and key events.
     */
    class KeyAndMouseListener : MouseListener, KeyListener {

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
                commit();
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
                    commit();
                    break;
                default:
            }
        }
    }

    /**
     * Internal listener to document changes.
     */
    class DocumentListener : IDocumentListener {

        private String fReplacedText;

        /*
         * @see org.eclipse.jface.text.IDocumentListener#documentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
         */
        public void documentAboutToBeChanged(DocumentEvent event) {
            try {
                fReplacedText= event.getDocument().get(event.getOffset(), event.getLength());
                fPreservedUndoModificationStamp= event.getModificationStamp();
            } catch (BadLocationException x) {
                fReplacedText= null;
            }
        }

        /*
         * @see org.eclipse.jface.text.IDocumentListener#documentChanged(org.eclipse.jface.text.DocumentEvent)
         */
        public void documentChanged(DocumentEvent event) {
            fPreservedRedoModificationStamp= event.getModificationStamp();

            // record the current valid state for the top operation in case it remains the
            // top operation but changes state.
            IUndoableOperation op= fHistory.getUndoOperation(fUndoContext);
            bool wasValid= false;
            if (op !is null)
                wasValid= op.canUndo();
            // Process the change, providing the before and after timestamps
            processChange(event.getOffset(), event.getOffset() + event.getLength(), event.getText(), fReplacedText, fPreservedUndoModificationStamp, fPreservedRedoModificationStamp);

            // now update fCurrent with the latest buffers from the document change.
            fCurrent.pretendCommit();

            if (op is fCurrent) {
                // if the document change did not cause a new fCurrent to be created, then we should
                // notify the history that the current operation changed if its validity has changed.
                if (wasValid !is fCurrent.isValid())
                    fHistory.operationChanged(op);
            }
            else {
                // if the change created a new fCurrent that we did not yet add to the
                // stack, do so if it's valid and we are not in the middle of a compound change.
                if (fCurrent !is fLastAddedCommand && fCurrent.isValid()) {
                    addToCommandStack(fCurrent);
                }
            }
        }
    }

    /**
     * Internal text input listener.
     */
    class TextInputListener : ITextInputListener {

        /*
         * @see org.eclipse.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
         */
        public void inputDocumentAboutToBeChanged(IDocument oldInput, IDocument newInput) {
            if (oldInput !is null && fDocumentListener !is null) {
                oldInput.removeDocumentListener(fDocumentListener);
                commit();
            }
        }

        /*
         * @see org.eclipse.jface.text.ITextInputListener#inputDocumentChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
         */
        public void inputDocumentChanged(IDocument oldInput, IDocument newInput) {
            if (newInput !is null) {
                if (fDocumentListener is null)
                    fDocumentListener= new DocumentListener();
                newInput.addDocumentListener(fDocumentListener);
            }
        }

    }

    /*
     * @see IOperationHistoryListener
     * @since 3.1
     */
    class HistoryListener : IOperationHistoryListener {
        private IUndoableOperation fOperation;

        public void historyNotification(OperationHistoryEvent event) {
            int type= event.getEventType();
            switch (type) {
            case OperationHistoryEvent.ABOUT_TO_UNDO:
            case OperationHistoryEvent.ABOUT_TO_REDO:
                // if this is one of our operations
                if (event.getOperation().hasContext(fUndoContext)) {
                    fTextViewer.getTextWidget().getDisplay().syncExec(dgRunnable((OperationHistoryEvent event_, int type_ ) {
                        // if we are undoing/redoing a command we generated, then ignore
                        // the document changes associated with this undo or redo.
                        if (event_.getOperation() ) {
                            if ( cast(TextViewer)fTextViewer )
                                (cast(TextViewer)fTextViewer).ignoreAutoEditStrategies_package(true);
                            listenToTextChanges(false);

                            // in the undo case only, make sure compounds are closed
                            if (type_ is OperationHistoryEvent.ABOUT_TO_UNDO) {
                                if (fFoldingIntoCompoundChange) {
                                    endCompoundChange();
                                }
                            }
                        } else {
                            // the undo or redo has our context, but it is not one of
                            // our commands.  We will listen to the changes, but will
                            // reset the state that tracks the undo/redo history.
                            commit();
                            fLastAddedCommand= null;
                        }
                    }, event, type ));
                    fOperation= event.getOperation();
                }
                break;
            case OperationHistoryEvent.UNDONE:
            case OperationHistoryEvent.REDONE:
            case OperationHistoryEvent.OPERATION_NOT_OK:
                if (event.getOperation() is fOperation) {
                    fTextViewer.getTextWidget().getDisplay().syncExec(new class()  Runnable {
                        public void run() {
                            listenToTextChanges(true);
                            fOperation= null;
                            if ( cast(TextViewer)fTextViewer )
                                (cast(TextViewer)fTextViewer).ignoreAutoEditStrategies_package(false);
                         }
                    });
                }
                break;
            default:
            }
        }

    }

    /** Text buffer to collect text which is inserted into the viewer */
    private StringBuffer fTextBuffer;
    /** Text buffer to collect viewer content which has been replaced */
    private StringBuffer fPreservedTextBuffer;
    /** The document modification stamp for undo. */
    protected long fPreservedUndoModificationStamp= IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP;
    /** The document modification stamp for redo. */
    protected long fPreservedRedoModificationStamp= IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP;
    /** The internal key and mouse event listener */
    private KeyAndMouseListener fKeyAndMouseListener;
    /** The internal document listener */
    private DocumentListener fDocumentListener;
    /** The internal text input listener */
    private TextInputListener fTextInputListener;


    /** Indicates inserting state */
    private bool fInserting= false;
    /** Indicates overwriting state */
    private bool fOverwriting= false;
    /** Indicates whether the current change belongs to a compound change */
    private bool fFoldingIntoCompoundChange= false;

    /** The text viewer the undo manager is connected to */
    private ITextViewer fTextViewer;

    /** Supported undo level */
    private int fUndoLevel;
    /** The currently constructed edit command */
    private TextCommand fCurrent;
    /** The last delete edit command */
    private TextCommand fPreviousDelete;

    /**
     * The undo context.
     * @since 3.1
     */
    private IOperationHistory fHistory;
    /**
     * The operation history.
     * @since 3.1
     */
    private IUndoContext fUndoContext;
    /**
     * The operation history listener used for managing undo and redo before
     * and after the individual commands are performed.
     * @since 3.1
     */
    private IOperationHistoryListener fHistoryListener;

    /**
     * The command last added to the operation history.  This must be tracked
     * internally instead of asking the history, since outside parties may be placing
     * items on our undo/redo history.
     */
    private TextCommand fLastAddedCommand= null;

    /**
     * Creates a new undo manager who remembers the specified number of edit commands.
     *
     * @param undoLevel the length of this manager's history
     */
    public this(int undoLevel) {
        fTextBuffer= new StringBuffer();
        fPreservedTextBuffer= new StringBuffer();

        fHistoryListener= new HistoryListener();
        fHistory= OperationHistoryFactory.getOperationHistory();
        setMaximalUndoLevel(undoLevel);
    }

    /**
     * Returns whether this undo manager is connected to a text viewer.
     *
     * @return <code>true</code> if connected, <code>false</code> otherwise
     * @since 3.1
     */
    private bool isConnected() {
        return fTextViewer !is null;
    }

    /*
     * @see IUndoManager#beginCompoundChange
     */
    public void beginCompoundChange() {
        if (isConnected()) {
            fFoldingIntoCompoundChange= true;
            commit();
        }
    }


    /*
     * @see IUndoManager#endCompoundChange
     */
    public void endCompoundChange() {
        if (isConnected()) {
            fFoldingIntoCompoundChange= false;
            commit();
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
            fHistory.addOperationHistoryListener(fHistoryListener);
            listenToTextChanges(true);
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
            listenToTextChanges(false);
            fHistory.removeOperationHistoryListener(fHistoryListener);
        }
    }

    /**
     * Adds the given command to the operation history if it is not part of
     * a compound change.
     *
     * @param command the command to be added
     * @since 3.1
     */
    private void addToCommandStack(TextCommand command){
        if (!fFoldingIntoCompoundChange || cast(CompoundTextCommand)command ) {
            fHistory.add(command);
            fLastAddedCommand= command;
        }
    }

    /**
     * Disposes the command stack.
     *
     * @since 3.1
     */
    private void disposeCommandStack() {
        fHistory.dispose(fUndoContext, true, true, true);
    }

    /**
     * Initializes the command stack.
     *
     * @since 3.1
     */
    private void initializeCommandStack() {
        if (fHistory !is null && fUndoContext !is null)
            fHistory.dispose(fUndoContext, true, true, false);

    }

    /**
     * Switches the state of whether there is a text listener or not.
     *
     * @param listen the state which should be established
     */
    private void listenToTextChanges(bool listen) {
        if (listen) {
            if (fDocumentListener is null && fTextViewer.getDocument() !is null) {
                fDocumentListener= new DocumentListener();
                fTextViewer.getDocument().addDocumentListener(fDocumentListener);
            }
        } else if (!listen) {
            if (fDocumentListener !is null && fTextViewer.getDocument() !is null) {
                fTextViewer.getDocument().removeDocumentListener(fDocumentListener);
                fDocumentListener= null;
            }
        }
    }

    /**
     * Closes the current editing command and opens a new one.
     */
    private void commit() {
        // if fCurrent has never been placed on the command stack, do so now.
        // this can happen when there are multiple programmatically commits in a single
        // document change.
        if (fLastAddedCommand !is fCurrent) {
            fCurrent.pretendCommit();
            if (fCurrent.isValid())
                addToCommandStack(fCurrent);
        }
        fCurrent.commit();
    }

    /**
     * Reset processChange state.
     *
     * @since 3.2
     */
    private void resetProcessChangeSate() {
        fInserting= false;
        fOverwriting= false;
        fPreviousDelete.reinitialize();
    }

    /**
     * Checks whether the given text starts with a line delimiter and
     * subsequently contains a white space only.
     *
     * @param text the text to check
     * @return <code>true</code> if the text is a line delimiter followed by whitespace, <code>false</code> otherwise
     */
    private bool isWhitespaceText(String text) {

        if (text is null || text.length() is 0)
            return false;

        String[] delimiters= fTextViewer.getDocument().getLegalLineDelimiters();
        int index= TextUtilities.startsWith(delimiters, text);
        if (index > -1) {
            char c;
            int length= text.length();
            for (int i= delimiters[index].length; i < length; i++) {
                c= text.charAt(i);
                if (c !is ' ' && c !is '\t')
                    return false;
            }
            return true;
        }

        return false;
    }

    private void processChange(int modelStart, int modelEnd, String insertedText, String replacedText, long beforeChangeModificationStamp, long afterChangeModificationStamp) {

        if (insertedText is null)
            insertedText= ""; //$NON-NLS-1$

        if (replacedText is null)
            replacedText= ""; //$NON-NLS-1$

        int length= insertedText.length();
        int diff= modelEnd - modelStart;

        if (fCurrent.fUndoModificationStamp is IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP)
            fCurrent.fUndoModificationStamp= beforeChangeModificationStamp;

        // normalize
        if (diff < 0) {
            int tmp= modelEnd;
            modelEnd= modelStart;
            modelStart= tmp;
        }

        if (modelStart is modelEnd) {
            // text will be inserted
            if ((length is 1) || isWhitespaceText(insertedText)) {
                // by typing or whitespace
                if (!fInserting || (modelStart !is fCurrent.fStart + fTextBuffer.length())) {
                    fCurrent.fRedoModificationStamp= beforeChangeModificationStamp;
                    if (fCurrent.attemptCommit())
                        fCurrent.fUndoModificationStamp= beforeChangeModificationStamp;

                    fInserting= true;
                }
                if (fCurrent.fStart < 0)
                    fCurrent.fStart= fCurrent.fEnd= modelStart;
                if (length > 0)
                    fTextBuffer.append(insertedText);
            } else if (length >= 0) {
                // by pasting or model manipulation
                fCurrent.fRedoModificationStamp= beforeChangeModificationStamp;
                if (fCurrent.attemptCommit())
                    fCurrent.fUndoModificationStamp= beforeChangeModificationStamp;

                fCurrent.fStart= fCurrent.fEnd= modelStart;
                fTextBuffer.append(insertedText);
                fCurrent.fRedoModificationStamp= afterChangeModificationStamp;
                if (fCurrent.attemptCommit())
                    fCurrent.fUndoModificationStamp= afterChangeModificationStamp;

            }
        } else {
            if (length is 0) {
                // text will be deleted by backspace or DEL key or empty clipboard
                length= replacedText.length;
                String[] delimiters= fTextViewer.getDocument().getLegalLineDelimiters();

                if ((length is 1) || TextUtilities.equals(delimiters, replacedText) > -1) {

                    // whereby selection is empty

                    if (fPreviousDelete.fStart is modelStart && fPreviousDelete.fEnd is modelEnd) {
                        // repeated DEL

                            // correct wrong settings of fCurrent
                        if (fCurrent.fStart is modelEnd && fCurrent.fEnd is modelStart) {
                            fCurrent.fStart= modelStart;
                            fCurrent.fEnd= modelEnd;
                        }
                            // append to buffer && extend command range
                        fPreservedTextBuffer.append(replacedText);
                        ++fCurrent.fEnd;

                    } else if (fPreviousDelete.fStart is modelEnd) {
                        // repeated backspace

                            // insert in buffer and extend command range
                        fPreservedTextBuffer.insert(0, replacedText);
                        fCurrent.fStart= modelStart;

                    } else {
                        // either DEL or backspace for the first time

                        fCurrent.fRedoModificationStamp= beforeChangeModificationStamp;
                        if (fCurrent.attemptCommit())
                            fCurrent.fUndoModificationStamp= beforeChangeModificationStamp;

                        // as we can not decide whether it was DEL or backspace we initialize for backspace
                        fPreservedTextBuffer.append(replacedText);
                        fCurrent.fStart= modelStart;
                        fCurrent.fEnd= modelEnd;
                    }

                    fPreviousDelete.set(modelStart, modelEnd);

                } else if (length > 0) {
                    // whereby selection is not empty
                    fCurrent.fRedoModificationStamp= beforeChangeModificationStamp;
                    if (fCurrent.attemptCommit())
                        fCurrent.fUndoModificationStamp= beforeChangeModificationStamp;

                    fCurrent.fStart= modelStart;
                    fCurrent.fEnd= modelEnd;
                    fPreservedTextBuffer.append(replacedText);
                }
            } else {
                // text will be replaced

                if (length is 1) {
                    length= replacedText.length;
                    String[] delimiters= fTextViewer.getDocument().getLegalLineDelimiters();

                    if ((length is 1) || TextUtilities.equals(delimiters, replacedText) > -1) {
                        // because of overwrite mode or model manipulation
                        if (!fOverwriting || (modelStart !is fCurrent.fStart +  fTextBuffer.length())) {
                            fCurrent.fRedoModificationStamp= beforeChangeModificationStamp;
                            if (fCurrent.attemptCommit())
                                fCurrent.fUndoModificationStamp= beforeChangeModificationStamp;

                            fOverwriting= true;
                        }

                        if (fCurrent.fStart < 0)
                            fCurrent.fStart= modelStart;

                        fCurrent.fEnd= modelEnd;
                        fTextBuffer.append(insertedText);
                        fPreservedTextBuffer.append(replacedText);
                        fCurrent.fRedoModificationStamp= afterChangeModificationStamp;
                        return;
                    }
                }
                // because of typing or pasting whereby selection is not empty
                fCurrent.fRedoModificationStamp= beforeChangeModificationStamp;
                if (fCurrent.attemptCommit())
                    fCurrent.fUndoModificationStamp= beforeChangeModificationStamp;

                fCurrent.fStart= modelStart;
                fCurrent.fEnd= modelEnd;
                fTextBuffer.append(insertedText);
                fPreservedTextBuffer.append(replacedText);
            }
        }
        // in all cases, the redo modification stamp is updated on the open command
        fCurrent.fRedoModificationStamp= afterChangeModificationStamp;
    }

    /**
     * Shows the given exception in an error dialog.
     *
     * @param title the dialog title
     * @param ex the exception
     * @since 3.1
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
            display.syncExec(dgRunnable( {
                MessageDialog.openError(finalShell, title, ex.msg/+getLocalizedMessage()+/);
            }));
        }
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#setMaximalUndoLevel(int)
     */
    public void setMaximalUndoLevel(int undoLevel) {
        fUndoLevel= Math.max(0, undoLevel);
        if (isConnected()) {
            fHistory.setLimit(fUndoContext, fUndoLevel);
        }
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#connect(org.eclipse.jface.text.ITextViewer)
     */
    public void connect(ITextViewer textViewer) {
        if (!isConnected() && textViewer !is null) {
            fTextViewer= textViewer;
            if (fUndoContext is null)
                fUndoContext= new ObjectUndoContext(this);

            fHistory.setLimit(fUndoContext, fUndoLevel);

            initializeCommandStack();

            // open up the current command
            fCurrent= new TextCommand(fUndoContext);

            fPreviousDelete= new TextCommand(fUndoContext);
            addListeners();
        }
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#disconnect()
     */
    public void disconnect() {
        if (isConnected()) {

            removeListeners();

            fCurrent= null;
            fTextViewer= null;
            disposeCommandStack();
            fTextBuffer= null;
            fPreservedTextBuffer= null;
            fUndoContext= null;
        }
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#reset()
     */
    public void reset() {
        if (isConnected()) {
            initializeCommandStack();
            fCurrent= new TextCommand(fUndoContext);
            fFoldingIntoCompoundChange= false;
            fInserting= false;
            fOverwriting= false;
            fTextBuffer.setLength(0);
            fPreservedTextBuffer.setLength(0);
            fPreservedUndoModificationStamp= IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP;
            fPreservedRedoModificationStamp= IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP;
        }
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#redoable()
     */
    public bool redoable() {
        return fHistory.canRedo(fUndoContext);
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#undoable()
     */
    public bool undoable() {
        return fHistory.canUndo(fUndoContext);
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#redo()
     */
    public void redo() {
        if (isConnected() && redoable()) {
            try {
                fHistory.redo(fUndoContext, null, null);
            } catch (ExecutionException ex) {
                openErrorDialog(JFaceTextMessages.getString("DefaultUndoManager.error.redoFailed.title"), ex); //$NON-NLS-1$
            }
        }
    }

    /*
     * @see org.eclipse.jface.text.IUndoManager#undo()
     */
    public void undo() {
        if (isConnected() && undoable()) {
            try {
                fHistory.undo(fUndoContext, null, null);
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
     * @since 3.0
     */
    protected void selectAndReveal(int offset, int length) {
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
     * @since 3.1
     */
    public IUndoContext getUndoContext() {
        return fUndoContext;
    }

}
