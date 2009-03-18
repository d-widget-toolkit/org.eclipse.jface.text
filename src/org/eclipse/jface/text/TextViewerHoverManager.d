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
module org.eclipse.jface.text.TextViewerHoverManager;

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
import java.lang.Thread;

import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseMoveListener;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.Display;
import org.eclipse.core.runtime.ILog;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.Status;


/**
 * This manager controls the layout, content, and visibility of an information
 * control in reaction to mouse hover events issued by the text widget of a
 * text viewer. It overrides <code>computeInformation</code>, so that the
 * computation is performed in a dedicated background thread. This implies
 * that the used <code>ITextHover</code> objects must be capable of
 * operating in a non-UI thread.
 *
 * @since 2.0
 */
class TextViewerHoverManager : AbstractHoverInformationControlManager , IWidgetTokenKeeper, IWidgetTokenKeeperExtension {


    /**
     * Priority of the hovers managed by this manager.
     * Default value: <code>0</code>;
     * @since 3.0
     */
    public const static int WIDGET_PRIORITY= 0;


    /** The text viewer */
    private TextViewer fTextViewer;
    /** The hover information computation thread */
    private Thread fThread;
    /** The stopper of the computation thread */
    private ITextListener fStopper;
    /** Internal monitor */
    private Object fMutex;
    /** The currently shown text hover. */
    private /+volatile+/ ITextHover fTextHover;
    /**
     * Tells whether the next mouse hover event
     * should be processed.
     * @since 3.0
     */
    private bool fProcessMouseHoverEvent= true;
    /**
     * Internal mouse move listener.
     * @since 3.0
     */
    private MouseMoveListener fMouseMoveListener;
    /**
     * Internal view port listener.
     * @since 3.0
     */
    private IViewportListener fViewportListener;


    /**
     * Creates a new text viewer hover manager specific for the given text viewer.
     * The manager uses the given information control creator.
     *
     * @param textViewer the viewer for which the controller is created
     * @param creator the information control creator
     */
    public this(TextViewer textViewer, IInformationControlCreator creator) {
        fMutex= new Object();
        super(creator);
        fTextViewer= textViewer;
        fStopper= new class() ITextListener {
            public void textChanged(TextEvent event) {
                synchronized (fMutex) {
                    if (fThread !is null) {
implMissing(__FILE__,__LINE__);
// SWT FIXME: how to handle Thread.interrupt?
//                         fThread.interrupt();
                        fThread= null;
                    }
                }
            }
        };
        fViewportListener= new class()  IViewportListener {
            /*
             * @see org.eclipse.jface.text.IViewportListener#viewportChanged(int)
             */
            public void viewportChanged(int verticalOffset) {
                fProcessMouseHoverEvent= false;
            }
        };
        fTextViewer.addViewportListener(fViewportListener);
        fMouseMoveListener= new class()  MouseMoveListener {
            /*
             * @see MouseMoveListener#mouseMove(MouseEvent)
             */
            public void mouseMove(MouseEvent event) {
                fProcessMouseHoverEvent= true;
            }
        };
        fTextViewer.getTextWidget().addMouseMoveListener(fMouseMoveListener);
    }

    /**
     * Determines all necessary details and delegates the computation into
     * a background thread.
     */
    protected void computeInformation() {

        if (!fProcessMouseHoverEvent) {
            setInformation(cast(Object)null, null);
            return;
        }

        Point location= getHoverEventLocation();
        int offset= computeOffsetAtLocation(location.x, location.y);
        if (offset is -1) {
            setInformation(cast(Object)null, null);
            return;
        }

        ITextHover hover= fTextViewer.getTextHover_package(offset, getHoverEventStateMask());
        if (hover is null) {
            setInformation(cast(Object)null, null);
            return;
        }

        IRegion region= hover.getHoverRegion(fTextViewer, offset);
        if (region is null) {
            setInformation(cast(Object)null, null);
            return;
        }

        Rectangle area= JFaceTextUtil.computeArea(region, fTextViewer);
        if (area is null || area.isEmpty()) {
            setInformation(cast(Object)null, null);
            return;
        }

        if (fThread !is null) {
            setInformation(cast(Object)null, null);
            return;
        }
        fThread= new Thread( dgRunnable( (ITextHover hover_, IRegion region_, Rectangle area_){
            // http://bugs.eclipse.org/bugs/show_bug.cgi?id=17693
            bool hasFinished= false;
            try {
                if (fThread !is null) {
                    Object information;
                    try {
                        if ( cast(ITextHoverExtension2)hover_ )
                            information= (cast(ITextHoverExtension2)hover_).getHoverInfo2(fTextViewer, region_);
                        else
                            information= stringcast(hover_.getHoverInfo(fTextViewer, region_));
                    } catch (ArrayIndexOutOfBoundsException x) {
                        /*
                            * This code runs in a separate thread which can
                            * lead to text offsets being out of bounds when
                            * computing the hover info (see bug 32848).
                            */
                        information= null;
                    }

                    if ( cast(ITextHoverExtension)hover_ )
                        setCustomInformationControlCreator((cast(ITextHoverExtension) hover_).getHoverControlCreator());
                    else
                        setCustomInformationControlCreator(null);

                    setInformation(information, area_);
                    if (information !is null)
                        fTextHover= hover_;
                } else {
                    setInformation(cast(Object)null, null);
                }
                hasFinished= true;
            } catch (RuntimeException ex) {
                String PLUGIN_ID= "org.eclipse.jface.text"; //$NON-NLS-1$
                ILog log= Platform.getLog(Platform.getBundle(PLUGIN_ID));
                log.log(new Status(IStatus.ERROR, PLUGIN_ID, IStatus.OK, "Unexpected runtime error while computing a text hover", ex)); //$NON-NLS-1$
            } finally {
                synchronized (fMutex) {
                    if (fTextViewer !is null)
                        fTextViewer.removeTextListener(fStopper);
                    fThread= null;
                    // https://bugs.eclipse.org/bugs/show_bug.cgi?id=44756
                    if (!hasFinished)
                        setInformation(cast(Object)null, null);
                }
            }
        }, hover, region, area ) );

        fThread.setName( "Text Viewer Hover Presenter" ); //$NON-NLS-1$

        fThread.setDaemon(true);
        fThread.setPriority(Thread.MIN_PRIORITY);
        synchronized (fMutex) {
            fTextViewer.addTextListener(fStopper);
            fThread.start();
        }
    }

    /**
     * As computation is done in the background, this method is
     * also called in the background thread. Delegates the control
     * flow back into the UI thread, in order to allow displaying the
     * information in the information control.
     */
    protected void presentInformation() {
        if (fTextViewer is null)
            return;

        StyledText textWidget= fTextViewer.getTextWidget();
        if (textWidget !is null && !textWidget.isDisposed()) {
            Display display= textWidget.getDisplay();
            if (display is null)
                return;

            display.asyncExec(new class()  Runnable {
                public void run() {
                    doPresentInformation();
                }
            });
        }
    }

    /*
     * @see AbstractInformationControlManager#presentInformation()
     */
    protected void doPresentInformation() {
        super.presentInformation();
    }

    /**
     * Computes the document offset underlying the given text widget coordinates.
     * This method uses a linear search as it cannot make any assumption about
     * how the document is actually presented in the widget. (Covers cases such
     * as bidirectional text.)
     *
     * @param x the horizontal coordinate inside the text widget
     * @param y the vertical coordinate inside the text widget
     * @return the document offset corresponding to the given point
     */
    private int computeOffsetAtLocation(int x, int y) {

        try {

            StyledText styledText= fTextViewer.getTextWidget();
            int widgetOffset= styledText.getOffsetAtLocation(new Point(x, y));
            Point p= styledText.getLocationAtOffset(widgetOffset);
            if (p.x > x)
                widgetOffset--;

            if ( cast(ITextViewerExtension5)fTextViewer ) {
                ITextViewerExtension5 extension= cast(ITextViewerExtension5) fTextViewer;
                return extension.widgetOffset2ModelOffset(widgetOffset);
            }

            return widgetOffset + fTextViewer._getVisibleRegionOffset_package();

        } catch (IllegalArgumentException e) {
            return -1;
        }
    }

    /*
     * @see org.eclipse.jface.text.AbstractInformationControlManager#showInformationControl(org.eclipse.swt.graphics.Rectangle)
     */
    protected void showInformationControl(Rectangle subjectArea) {
        if (fTextViewer !is null && fTextViewer.requestWidgetToken(this, WIDGET_PRIORITY))
            super.showInformationControl(subjectArea);
        else
            if (DEBUG)
                System.out_.println("TextViewerHoverManager#showInformationControl(..) did not get widget token"); //$NON-NLS-1$
    }

    /*
     * @see org.eclipse.jface.text.AbstractInformationControlManager#hideInformationControl()
     */
    protected void hideInformationControl() {
        try {
            fTextHover= null;
            super.hideInformationControl();
        } finally {
            if (fTextViewer !is null)
                fTextViewer.releaseWidgetToken(this);
        }
    }

    /*
     * @see org.eclipse.jface.text.AbstractInformationControlManager#replaceInformationControl(bool)
     * @since 3.4
     */
    void replaceInformationControl(bool takeFocus) {
        if (fTextViewer !is null)
            fTextViewer.releaseWidgetToken(this);
        super.replaceInformationControl(takeFocus);
    }

    /*
     * @see org.eclipse.jface.text.AbstractInformationControlManager#handleInformationControlDisposed()
     */
    protected void handleInformationControlDisposed() {
        try {
            super.handleInformationControlDisposed();
        } finally {
            if (fTextViewer !is null)
                fTextViewer.releaseWidgetToken(this);
        }
    }

    /*
     * @see org.eclipse.jface.text.IWidgetTokenKeeper#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner)
     */
    public bool requestWidgetToken(IWidgetTokenOwner owner) {
        fTextHover= null;
        super.hideInformationControl();
        return true;
    }

    /*
     * @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner, int)
     * @since 3.0
     */
    public bool requestWidgetToken(IWidgetTokenOwner owner, int priority) {
        if (priority > WIDGET_PRIORITY) {
            fTextHover= null;
            super.hideInformationControl();
            return true;
        }
        return false;
    }

    /*
     * @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#setFocus(org.eclipse.jface.text.IWidgetTokenOwner)
     * @since 3.0
     */
    public bool setFocus(IWidgetTokenOwner owner) {
        if (! hasInformationControlReplacer())
            return false;

        IInformationControl iControl= getCurrentInformationControl();
        if (canReplace(iControl)) {
            if (cancelReplacingDelay())
                replaceInformationControl(true);

            return true;
        }

        return false;
    }

    /**
     * Returns the currently shown text hover or <code>null</code> if no text
     * hover is shown.
     *
     * @return the currently shown text hover or <code>null</code>
     */
    protected ITextHover getCurrentTextHover() {
        return fTextHover;
    }
    package ITextHover getCurrentTextHover_package() {
        return getCurrentTextHover();
    }

    /*
     * @see org.eclipse.jface.text.AbstractHoverInformationControlManager#dispose()
     * @since 3.0
     */
    public void dispose() {
        if (fTextViewer !is null) {
            fTextViewer.removeViewportListener(fViewportListener);
            fViewportListener= null;

            StyledText st= fTextViewer.getTextWidget();
            if (st !is null && !st.isDisposed())
                st.removeMouseMoveListener(fMouseMoveListener);
            fMouseMoveListener= null;
        }
        super.dispose();
    }
}
