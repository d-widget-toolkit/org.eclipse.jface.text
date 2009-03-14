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


module org.eclipse.jface.text.IInformationControl;

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
import org.eclipse.swt.events.DisposeListener;
import org.eclipse.swt.events.FocusListener;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Point;


/**
 * Interface of a control presenting information. The information is given in
 * the form of an input object. It can be either the content itself or a
 * description of the content. The specification of what is required from an
 * input object is left to the implementers of this interface.
 * <p>
 * <em>If this information control is used by a {@link AbstractHoverInformationControlManager}
 * then that manager will own this control and override any properties that
 * may have been set before by any other client.</em></p>
 * <p>
 * The information control must not grab focus when made visible using
 * <code>setVisible(true)</code>.
 *
 * In order to provide backward compatibility for clients of
 * <code>IInformationControl</code>, extension interfaces are used as a means
 * of evolution. The following extension interfaces exist:
 * <ul>
 * <li>{@link org.eclipse.jface.text.IInformationControlExtension} since
 *     version 2.0 introducing the predicate of whether the control has anything to
 *     show or would be empty</li>
 * <li>{@link org.eclipse.jface.text.IInformationControlExtension2} since
 *     version 2.1 replacing the original concept of textual input by general input
 *     objects.</li>
 * <li>{@link org.eclipse.jface.text.IInformationControlExtension3} since
 *     version 3.0 providing access to the control's bounds and introducing
 *     the concept of persistent size and location.</li>
 * <li>{@link org.eclipse.jface.text.IInformationControlExtension4} since
 *     version 3.3, adding API which allows to set this information control's status field text.</li>
 * <li>{@link org.eclipse.jface.text.IInformationControlExtension5} since
 *     version 3.4, adding API to get the visibility of the control, to
 *     test whether another control is a child of the information control,
 *     to compute size constraints based on the information control's main font
 *     and to return a control creator for an enriched version of this information control.</li>
 * </ul>
 * <p>
 * Clients can implement this interface and its extension interfaces,
 * subclass {@link AbstractInformationControl}, or use the (text-based)
 * default implementation {@link DefaultInformationControl}.
 *
 * @see org.eclipse.jface.text.IInformationControlExtension
 * @see org.eclipse.jface.text.IInformationControlExtension2
 * @see org.eclipse.jface.text.IInformationControlExtension3
 * @see org.eclipse.jface.text.IInformationControlExtension4
 * @see org.eclipse.jface.text.IInformationControlExtension5
 * @see AbstractInformationControl
 * @see DefaultInformationControl
 * @since 2.0
 */
public interface IInformationControl {

    /**
     * Sets the information to be presented by this information control.
     * <p>
     * Replaced by {@link IInformationControlExtension2#setInput(Object)}.
     *
     * @param information the information to be presented
     */
    void setInformation(String information);

    /**
     * Sets the information control's size constraints. A constraint value of
     * {@link SWT#DEFAULT} indicates no constraint. This method must be called before
     * {@link #computeSizeHint()} is called.
     * <p>
     * Note: An information control which implements {@link IInformationControlExtension3}
     * may ignore this method or use it as hint for its very first appearance.
     * </p>
     * @param maxWidth the maximal width of the control  to present the information, or {@link SWT#DEFAULT} for not constraint
     * @param maxHeight the maximal height of the control to present the information, or {@link SWT#DEFAULT} for not constraint
     */
    void setSizeConstraints(int maxWidth, int maxHeight);

    /**
     * Computes and returns a proposal for the size of this information control depending
     * on the information to present. The method tries to honor known size constraints but might
     * return a size that exceeds them.
     *
     * @return the computed size hint
     */
    Point computeSizeHint();

    /**
     * Controls the visibility of this information control.
     * <p>
     * <strong>Note:</strong> The information control must not grab focus when
     * made visible.
     * </p>
     * 
     * @param visible <code>true</code> if the control should be visible
     */
    void setVisible(bool visible);

    /**
     * Sets the size of this information control.
     *
     * @param width the width of the control
     * @param height the height of the control
     */
    void setSize(int width, int height);

    /**
     * Sets the location of this information control.
     *
     * @param location the location
     */
    void setLocation(Point location);

    /**
     * Disposes this information control.
     */
    void dispose();

    /**
     * Adds the given listener to the list of dispose listeners.
     * If the listener is already registered it is not registered again.
     *
     * @param listener the listener to be added
     */
    void addDisposeListener(DisposeListener listener);

    /**
     * Removes the given listeners from the list of dispose listeners.
     * If the listener is not registered this call has no effect.
     *
     * @param listener the listener to be removed
     */
    void removeDisposeListener(DisposeListener listener);

    /**
     * Sets the foreground color of this information control.
     *
     * @param foreground the foreground color of this information control
     */
    void setForegroundColor(Color foreground);

    /**
     * Sets the background color of this information control.
     *
     * @param background the background color of this information control
     */
    void setBackgroundColor(Color background);

    /**
     * Returns whether this information control (or one of its children) has the focus.
     * The suggested implementation is like this (<code>fShell</code> is this information control's shell):
     * <pre>return fShell.getDisplay().getActiveShell() is fShell</pre>
     *
     * @return <code>true</code> when the information control has the focus, otherwise <code>false</code>
     */
    bool isFocusControl();

    /**
     * Sets the keyboard focus to this information control.
     */
    void setFocus();

    /**
     * Adds the given listener to the list of focus listeners.
     * If the listener is already registered it is not registered again.
     * <p>
     * The suggested implementation is to install listeners for {@link SWT#Activate} and {@link SWT#Deactivate}
     * on the shell and forward events to the focus listeners. Clients are
     * encouraged to subclass {@link AbstractInformationControl}, which does this
     * for free.
     * </p>
     * 
     * @param listener the listener to be added
     */
    void addFocusListener(FocusListener listener);

    /**
     * Removes the given listeners from the list of focus listeners.
     * If the listener is not registered this call has no affect.
     *
     * @param listener the listener to be removed
     */
    void removeFocusListener(FocusListener listener);
}
