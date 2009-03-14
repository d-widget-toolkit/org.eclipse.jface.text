/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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


module org.eclipse.jface.text.PropagatingFontFieldEditor;

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




import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;
import org.eclipse.jface.preference.FontFieldEditor;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.jface.preference.PreferenceConverter;
import org.eclipse.jface.util.IPropertyChangeListener;
import org.eclipse.jface.util.PropertyChangeEvent;


/**
 * This font field editor implements chaining between a source preference
 * store and a target preference store. Any time the source preference
 * store changes, the change is propagated to the target store. Propagation
 * means that the actual value stored in the source store is set as default
 * value in the target store. If the target store does not contain a value
 * other than the default value, the new default value is immediately
 * effective.
 *
 * @see FontFieldEditor
 * @since 2.0
 * @deprecated since 3.0 not longer in use, no longer supported
 */
public class PropagatingFontFieldEditor : FontFieldEditor {

    /** The editor's parent widget */
    private Composite fParent;
    /** The representation of the default font choice */
    private String fDefaultFontLabel;

    /**
     * Creates a new font field editor with the given parameters.
     *
     * @param name the editor's name
     * @param labelText the text shown as editor description
     * @param parent the editor's parent widget
     * @param defaultFontLabel the label shown in the editor value field when the default value should be taken
     */
    public this(String name, String labelText, Composite parent, String defaultFontLabel) {
        super(name, labelText, parent);
        fParent= parent;
        fDefaultFontLabel= defaultFontLabel is null ? "" : defaultFontLabel; //$NON-NLS-1$
    }

    /*
     * @see FontFieldEditor#doLoad()
     */
    protected void doLoad() {
        if (getPreferenceStore().isDefault(getPreferenceName()))
            loadDefault();
        super.doLoad();
        checkForDefault();
    }

    /*
     * @see FontFieldEditor#doLoadDefault()
     */
    protected void doLoadDefault() {
        super.doLoadDefault();
        checkForDefault();
    }

    /**
     * Checks whether this editor presents the default value "inherited"
     * from the workbench rather than its own font.
     */
    private void checkForDefault() {
        if (presentsDefaultValue()) {
            Control c= getValueControl(fParent);
            if ( cast(Label)c )
                (cast(Label) c).setText(fDefaultFontLabel);
        }
    }

    /**
     * Propagates the font set in the source store to the
     * target store using the given keys.
     *
     * @param source the store from which to read the text font
     * @param sourceKey the key under which the font can be found
     * @param target the store to which to propagate the font
     * @param targetKey the key under which to store the font
     */
    private static void propagateFont(IPreferenceStore source, String sourceKey, IPreferenceStore target, String targetKey) {
        FontData fd= PreferenceConverter.getFontData(source, sourceKey);
        if (fd !is null) {
            bool isDefault= target.isDefault(targetKey); // save old state!
            PreferenceConverter.setDefault(target, targetKey, fd);
            if (isDefault) {
                // restore old state
                target.setToDefault(targetKey);
            }
        }
    }

    /**
     * Starts the propagation of the font preference stored in the source preference
     * store under the source key to the target preference store using the target
     * preference key.
     *
     * @param source the source preference store
     * @param sourceKey the key to be used in the source preference store
     * @param target the target preference store
     * @param targetKey the key to be used in the target preference store
     */
    public static void startPropagate(IPreferenceStore source, String sourceKey, IPreferenceStore target, String targetKey) {
        source.addPropertyChangeListener(new class(source,sourceKey,target,targetKey)  IPropertyChangeListener {
            IPreferenceStore source_;
            String sourceKey_;
            IPreferenceStore target_;
            String targetKey_;
            this(IPreferenceStore a, String b, IPreferenceStore c, String d){
                source_=a;
                sourceKey_=b;
                target_=c;
                targetKey_=d;
            }
            public void propertyChange(PropertyChangeEvent event) {
                if (sourceKey_.equals(event.getProperty()))
                    propagateFont(source_, sourceKey_, target_, targetKey_);
            }
        });

        propagateFont(source, sourceKey, target, targetKey);
    }
}

