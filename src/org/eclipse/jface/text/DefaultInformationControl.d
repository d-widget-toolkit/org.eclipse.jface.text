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
module org.eclipse.jface.text.DefaultInformationControl;

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
import org.eclipse.swt.events.DisposeEvent;
import org.eclipse.swt.events.DisposeListener;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Drawable;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.jface.action.ToolBarManager;
import org.eclipse.jface.internal.text.html.HTMLTextPresenter;
import org.eclipse.jface.resource.JFaceResources;
import org.eclipse.jface.util.Geometry;

    /**
     * An information presenter determines the style presentation
     * of information displayed in the default information control.
     * The interface can be implemented by clients.
     */
    public interface IInformationPresenter {

        /**
         * Updates the given presentation of the given information and
         * thereby may manipulate the information to be displayed. The manipulation
         * could be the extraction of textual encoded style information etc. Returns the
         * manipulated information.
         * <p>
         * <strong>Note:</strong> The given display must only be used for measuring.</p>
         *
         * @param display the display of the information control
         * @param hoverInfo the information to be presented
         * @param presentation the presentation to be updated
         * @param maxWidth the maximal width in pixels
         * @param maxHeight the maximal height in pixels
         *
         * @return the manipulated information
         * @deprecated As of 3.2, replaced by {@link DefaultInformationControl.IInformationPresenterExtension#updatePresentation(Drawable, String, TextPresentation, int, int)}
         */
        String updatePresentation(Display display, String hoverInfo, TextPresentation presentation, int maxWidth, int maxHeight);
    }
    alias IInformationPresenter DefaultInformationControl_IInformationPresenter;

    /**
     * An information presenter determines the style presentation
     * of information displayed in the default information control.
     * The interface can be implemented by clients.
     *
     * @since 3.2
     */
    public interface IInformationPresenterExtension {

        /**
         * Updates the given presentation of the given information and
         * thereby may manipulate the information to be displayed. The manipulation
         * could be the extraction of textual encoded style information etc. Returns the
         * manipulated information.
         * <p>
         * Replaces {@link DefaultInformationControl.IInformationPresenter#updatePresentation(Display, String, TextPresentation, int, int)}
         * Implementations should use the font of the given <code>drawable</code> to calculate
         * the size of the text to be presented.
         * </p>
         *
         * @param drawable the drawable of the information control
         * @param hoverInfo the information to be presented
         * @param presentation the presentation to be updated
         * @param maxWidth the maximal width in pixels
         * @param maxHeight the maximal height in pixels
         *
         * @return the manipulated information
         */
        String updatePresentation(Drawable drawable, String hoverInfo, TextPresentation presentation, int maxWidth, int maxHeight);
    }
    alias IInformationPresenterExtension DefaultInformationControl_IInformationPresenterExtension;


/**
 * Default implementation of {@link org.eclipse.jface.text.IInformationControl}.
 * <p>
 * Displays textual information in a {@link org.eclipse.swt.custom.StyledText}
 * widget. Before displaying, the information set to this information control is
 * processed by an <code>IInformationPresenter</code>.
 *
 * @since 2.0
 */
public class DefaultInformationControl : AbstractInformationControl , DisposeListener {

    /**
     * Inner border thickness in pixels.
     * @since 3.1
     */
    private static const int INNER_BORDER= 1;

    /** The control's text widget */
    private StyledText fText;
    /** The information presenter, or <code>null</code> if none. */
    private const IInformationPresenter fPresenter;
    /** A cached text presentation */
    private const TextPresentation fPresentation;

    /**
     * Additional styles to use for the text control.
     * @since 3.4, previously called <code>fTextStyle</code>
     */
    private const int fAdditionalTextStyles;

    /**
     * Creates a default information control with the given shell as parent. An information
     * presenter that can handle simple HTML is used to process the information to be displayed.
     *
     * @param parent the parent shell
     * @param isResizeable <code>true</code> if the control should be resizable
     * @since 3.4
     */
    public this(Shell parent, bool isResizeable) {
        fPresentation= new TextPresentation();
        super(parent, isResizeable);
        fAdditionalTextStyles= isResizeable ? SWT.V_SCROLL | SWT.H_SCROLL : SWT.NONE;
        fPresenter= new HTMLTextPresenter(!isResizeable);
        create();
    }

    /**
     * Creates a default information control with the given shell as parent. An information
     * presenter that can handle simple HTML is used to process the information to be displayed.
     *
     * @param parent the parent shell
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     * @since 3.4
     */
    public this(Shell parent, String statusFieldText) {
        this(parent, statusFieldText, new HTMLTextPresenter(true));
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed.
     *
     * @param parent the parent shell
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     * @param presenter the presenter to be used, or <code>null</code> if no presenter should be used
     * @since 3.4
     */
    public this(Shell parent, String statusFieldText, IInformationPresenter presenter) {
        fPresentation= new TextPresentation();
        super(parent, statusFieldText);
        fAdditionalTextStyles= SWT.NONE;
        fPresenter= presenter;
        create();
    }

    /**
     * Creates a resizable default information control with the given shell as parent. An
     * information presenter that can handle simple HTML is used to process the information to be
     * displayed.
     *
     * @param parent the parent shell
     * @param toolBarManager the manager or <code>null</code> if toolbar is not desired
     * @since 3.4
     */
    public this(Shell parent, ToolBarManager toolBarManager) {
        this(parent, toolBarManager, new HTMLTextPresenter(false));
    }

    /**
     * Creates a resizable default information control with the given shell as
     * parent. The given information presenter is used to process the
     * information to be displayed.
     *
     * @param parent the parent shell
     * @param toolBarManager the manager or <code>null</code> if toolbar is not desired
     * @param presenter the presenter to be used, or <code>null</code> if no presenter should be used
     * @since 3.4
     */
    public this(Shell parent, ToolBarManager toolBarManager, IInformationPresenter presenter) {
        fPresentation= new TextPresentation();
        super(parent, toolBarManager);
        fAdditionalTextStyles= SWT.V_SCROLL | SWT.H_SCROLL;
        fPresenter= presenter;
        create();
    }

    /**
     * Creates a default information control with the given shell as parent.
     * No information presenter is used to process the information
     * to be displayed.
     *
     * @param parent the parent shell
     */
    public this(Shell parent) {
        this(parent, cast(String)null, null);
    }

    /**
     * Creates a default information control with the given shell as parent. The given
     * information presenter is used to process the information to be displayed.
     *
     * @param parent the parent shell
     * @param presenter the presenter to be used
     */
    public this(Shell parent, IInformationPresenter presenter) {
        this(parent, cast(String)null, presenter);
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed. The given styles are applied to the created styled text
     * widget.
     *
     * @param parent the parent shell
     * @param shellStyle the additional styles for the shell
     * @param style the additional styles for the styled text widget
     * @param presenter the presenter to be used
     * @deprecated As of 3.4, replaced by simpler constructors
     */
    public this(Shell parent, int shellStyle, int style, IInformationPresenter presenter) {
        this(parent, shellStyle, style, presenter, null);
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed. The given styles are applied to the created styled text
     * widget.
     *
     * @param parentShell the parent shell
     * @param shellStyle the additional styles for the shell
     * @param style the additional styles for the styled text widget
     * @param presenter the presenter to be used
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     * @since 3.0
     * @deprecated As of 3.4, replaced by simpler constructors
     */
    public this(Shell parentShell, int shellStyle, int style, IInformationPresenter presenter, String statusFieldText) {
        fPresentation= new TextPresentation();
        super(parentShell, SWT.NO_FOCUS | SWT.ON_TOP | shellStyle, statusFieldText, null);
        fAdditionalTextStyles= style;
        fPresenter= presenter;
        create();
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed.
     *
     * @param parent the parent shell
     * @param textStyles the additional styles for the styled text widget
     * @param presenter the presenter to be used
     * @deprecated As of 3.4, replaced by {@link #DefaultInformationControl(Shell, DefaultInformationControl.IInformationPresenter)}
     */
    public this(Shell parent, int textStyles, IInformationPresenter presenter) {
        this(parent, textStyles, presenter, null);
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed.
     *
     * @param parent the parent shell
     * @param textStyles the additional styles for the styled text widget
     * @param presenter the presenter to be used
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     * @since 3.0
     * @deprecated As of 3.4, replaced by {@link #DefaultInformationControl(Shell, String, DefaultInformationControl.IInformationPresenter)}
     */
    public this(Shell parent, int textStyles, IInformationPresenter presenter, String statusFieldText) {
        fPresentation= new TextPresentation();
        super(parent, statusFieldText);
        fAdditionalTextStyles= textStyles;
        fPresenter= presenter;
        create();
    }

    /*
     * @see org.eclipse.jface.text.AbstractInformationControl#createContent(org.eclipse.swt.widgets.Composite)
     */
    protected void createContent(Composite parent) {
        fText= new StyledText(parent, SWT.MULTI | SWT.READ_ONLY | fAdditionalTextStyles);
        fText.setForeground(parent.getForeground());
        fText.setBackground(parent.getBackground());
        fText.setFont(JFaceResources.getDialogFont());
        FillLayout layout= cast(FillLayout)parent.getLayout();
        if (fText.getWordWrap()) {
            // indent does not work for wrapping StyledText, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=56342 and https://bugs.eclipse.org/bugs/show_bug.cgi?id=115432
            layout.marginHeight= INNER_BORDER;
            layout.marginWidth= INNER_BORDER;
        } else {
            fText.setIndent(INNER_BORDER);
        }
    }

    /*
     * @see IInformationControl#setInformation(String)
     */
    public void setInformation(String content) {
        if (fPresenter is null) {
            fText.setText(content);
        } else {
            fPresentation.clear();

            int maxWidth= -1;
            int maxHeight= -1;
            Point constraints= getSizeConstraints();
            if (constraints !is null) {
                maxWidth= constraints.x;
                maxHeight= constraints.y;
                if (fText.getWordWrap()) {
                    maxWidth-= INNER_BORDER * 2;
                    maxHeight-= INNER_BORDER * 2;
                } else {
                    maxWidth-= INNER_BORDER; // indent
                }
                Rectangle trim= computeTrim();
                maxWidth-= trim.width;
                maxHeight-= trim.height;
                maxWidth-= fText.getCaret().getSize().x; // StyledText adds a border at the end of the line for the caret.
            }
            if (isResizable())
                maxHeight= Integer.MAX_VALUE;

            if ( cast(IInformationPresenterExtension)fPresenter )
                content= (cast(IInformationPresenterExtension)fPresenter).updatePresentation(fText, content, fPresentation, maxWidth, maxHeight);
            else
                content= fPresenter.updatePresentation(getShell().getDisplay(), content, fPresentation, maxWidth, maxHeight);

            if (content !is null) {
                fText.setText(content);
                TextPresentation.applyTextPresentation(fPresentation, fText);
            } else {
                fText.setText(""); //$NON-NLS-1$
            }
        }
    }

    /*
     * @see IInformationControl#setVisible(bool)
     */
    public void setVisible(bool visible) {
        if (visible) {
            if (fText.getWordWrap()) {
                Point currentSize= getShell().getSize();
                getShell().pack(true);
                Point newSize= getShell().getSize();
                if (newSize.x > currentSize.x || newSize.y > currentSize.y)
                    setSize(currentSize.x, currentSize.y); // restore previous size
            }
        }

        super.setVisible(visible);
    }

    /*
     * @see IInformationControl#computeSizeHint()
     */
    public Point computeSizeHint() {
        // see: https://bugs.eclipse.org/bugs/show_bug.cgi?id=117602
        int widthHint= SWT.DEFAULT;
        Point constraints= getSizeConstraints();
        if (constraints !is null && fText.getWordWrap())
            widthHint= constraints.x;

        return getShell().computeSize(widthHint, SWT.DEFAULT, true);
    }

    /*
     * @see org.eclipse.jface.text.AbstractInformationControl#computeTrim()
     */
    public Rectangle computeTrim() {
        return Geometry.add(super.computeTrim(), fText.computeTrim(0, 0, 0, 0));
    }

    /*
     * @see IInformationControl#setForegroundColor(Color)
     */
    public void setForegroundColor(Color foreground) {
        super.setForegroundColor(foreground);
        fText.setForeground(foreground);
    }

    /*
     * @see IInformationControl#setBackgroundColor(Color)
     */
    public void setBackgroundColor(Color background) {
        super.setBackgroundColor(background);
        fText.setBackground(background);
    }

    /*
     * @see IInformationControlExtension#hasContents()
     */
    public bool hasContents() {
        return fText.getCharCount() > 0;
    }

    /**
     * @see org.eclipse.swt.events.DisposeListener#widgetDisposed(org.eclipse.swt.events.DisposeEvent)
     * @since 3.0
     * @deprecated As of 3.2, no longer used and called
     */
    public void widgetDisposed(DisposeEvent event) {
    }

    /*
     * @see org.eclipse.jface.text.IInformationControlExtension5#getInformationPresenterControlCreator()
     * @since 3.4
     */
    public IInformationControlCreator getInformationPresenterControlCreator() {
        return new class()  IInformationControlCreator {
            /*
             * @see org.eclipse.jface.text.IInformationControlCreator#createInformationControl(org.eclipse.swt.widgets.Shell)
             */
            public IInformationControl createInformationControl(Shell parent) {
                return new DefaultInformationControl(parent, cast(ToolBarManager) null, fPresenter);
            }
        };
    }

}
