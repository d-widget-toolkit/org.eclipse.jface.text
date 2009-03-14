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
module org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter;

import org.eclipse.jface.text.hyperlink.IHyperlinkPresenterExtension; // packageimport
import org.eclipse.jface.text.hyperlink.MultipleHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.HyperlinkManager; // packageimport
import org.eclipse.jface.text.hyperlink.URLHyperlink; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetectorExtension2; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.URLHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.AbstractHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetectorExtension; // packageimport
import org.eclipse.jface.text.hyperlink.HyperlinkMessages; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlink; // packageimport


import java.lang.all;
import java.util.Set;





import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.StyleRange;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Cursor;
import org.eclipse.swt.graphics.RGB;
import org.eclipse.swt.widgets.Display;
import org.eclipse.core.runtime.Assert;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.jface.preference.PreferenceConverter;
import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.DocumentEvent;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IDocumentListener;
import org.eclipse.jface.text.IRegion;
import org.eclipse.jface.text.ITextInputListener;
import org.eclipse.jface.text.ITextPresentationListener;
import org.eclipse.jface.text.ITextViewer;
import org.eclipse.jface.text.ITextViewerExtension2;
import org.eclipse.jface.text.ITextViewerExtension4;
import org.eclipse.jface.text.Position;
import org.eclipse.jface.text.Region;
import org.eclipse.jface.text.TextPresentation;
import org.eclipse.jface.util.IPropertyChangeListener;
import org.eclipse.jface.util.PropertyChangeEvent;


/**
 * The default hyperlink presenter underlines the
 * link and colors the line and the text with
 * the given color.
 * <p>
 * It can only be used together with the {@link HyperlinkManager#FIRST}
 * or the {@link HyperlinkManager#LONGEST_REGION_FIRST} hyperlink strategy.
 * </p>
 *
 * @since 3.1
 */
public class DefaultHyperlinkPresenter : IHyperlinkPresenter, IHyperlinkPresenterExtension, ITextPresentationListener, ITextInputListener, IDocumentListener, IPropertyChangeListener {

    /**
     * A named preference that holds the color used for hyperlinks.
     * <p>
     * Value is of type <code>String</code>. A RGB color value encoded as a string
     * using class <code>PreferenceConverter</code>
     * </p>
     *
     * @see org.eclipse.jface.resource.StringConverter
     * @see org.eclipse.jface.preference.PreferenceConverter
     */
    public const static String HYPERLINK_COLOR= "hyperlinkColor"; //$NON-NLS-1$


    /** The text viewer. */
    private ITextViewer fTextViewer;
    /** The hand cursor. */
    private Cursor fCursor;
    /** The link color. */
    private Color fColor;
    /** The link color specification. May be <code>null</code>. */
    private RGB fRGB;
    /** Tells whether to dispose the color on uninstall. */
    private bool fDisposeColor;
    /** The currently active region. */
    private IRegion fActiveRegion;
    /** The currently active style range as position. */
    private Position fRememberedPosition;
    /** The optional preference store. May be <code>null</code>. */
    private IPreferenceStore fPreferenceStore;


    /**
     * Creates a new default hyperlink presenter which uses
     * {@link #HYPERLINK_COLOR} to read the color from the given preference store.
     *
     * @param store the preference store
     */
    public this(IPreferenceStore store) {
        fPreferenceStore= store;
        fDisposeColor= true;
    }

    /**
     * Creates a new default hyperlink presenter.
     *
     * @param color the hyperlink color, to be disposed by the caller
     */
    public this(Color color) {
        fDisposeColor= false;
        fColor= color;
    }

    /**
     * Creates a new default hyperlink presenter.
     *
     * @param color the hyperlink color
     */
    public this(RGB color) {
        fRGB= color;
        fDisposeColor= true;
    }

    /*
     * @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#canShowMultipleHyperlinks()
     */
    public bool canShowMultipleHyperlinks() {
        return false;
    }

    /*
     * @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#activate(org.eclipse.jdt.internal.ui.javaeditor.IHyperlink[])
     */
    public void showHyperlinks(IHyperlink[] hyperlinks) {
        Assert.isLegal(hyperlinks !is null && hyperlinks.length is 1);
        highlightRegion(hyperlinks[0].getHyperlinkRegion());
        activateCursor();
    }

    /**
     * {@inheritDoc}
     *
     * @since 3.4
     */
    public bool canHideHyperlinks() {
        return true;
    }

    /*
     * @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#deactivate()
     */
    public void hideHyperlinks() {
        repairRepresentation();
        fRememberedPosition= null;
    }

    /*
     * @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#install(org.eclipse.jface.text.ITextViewer)
     */
    public void install(ITextViewer textViewer) {
        Assert.isNotNull(cast(Object)textViewer);
        fTextViewer= textViewer;
        fTextViewer.addTextInputListener(this);
        if ( cast(ITextViewerExtension4)fTextViewer )
            (cast(ITextViewerExtension4)fTextViewer).addTextPresentationListener(this);

        StyledText text= fTextViewer.getTextWidget();
        if (text !is null && !text.isDisposed()) {
            if (fPreferenceStore !is null)
                fColor= createColor(fPreferenceStore, HYPERLINK_COLOR, text.getDisplay());
            else if (fRGB !is null)
                fColor= new Color(text.getDisplay(), fRGB);
        }

        if (fPreferenceStore !is null)
            fPreferenceStore.addPropertyChangeListener(this);
    }

    /*
     * @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#uninstall()
     */
    public void uninstall() {
        fTextViewer.removeTextInputListener(this);
        IDocument document= fTextViewer.getDocument();
        if (document !is null)
            document.removeDocumentListener(this);

        if (fColor !is null) {
            if (fDisposeColor)
                fColor.dispose();
            fColor= null;
        }

        if (fCursor !is null) {
            fCursor.dispose();
            fCursor= null;
        }

        if ( cast(ITextViewerExtension4)fTextViewer )
            (cast(ITextViewerExtension4)fTextViewer).removeTextPresentationListener(this);
        fTextViewer= null;

        if (fPreferenceStore !is null)
            fPreferenceStore.removePropertyChangeListener(this);
    }

    public void setColor(Color color) {
        Assert.isNotNull(cast(Object)fTextViewer);
        fColor= color;
    }

    /*
     * @see org.eclipse.jface.text.ITextPresentationListener#applyTextPresentation(org.eclipse.jface.text.TextPresentation)
     */
    public void applyTextPresentation(TextPresentation textPresentation) {
        if (fActiveRegion is null)
            return;
        IRegion region= textPresentation.getExtent();
        if (fActiveRegion.getOffset() + fActiveRegion.getLength() >= region.getOffset() && region.getOffset() + region.getLength() > fActiveRegion.getOffset()) {
            StyleRange styleRange= new StyleRange(fActiveRegion.getOffset(), fActiveRegion.getLength(), fColor, null);
            styleRange.underline= true;
            textPresentation.mergeStyleRange(styleRange);
        }
    }

    private void highlightRegion(IRegion region) {

        if ((cast(Object)region).opEquals(cast(Object)fActiveRegion))
            return;

        repairRepresentation();

        StyledText text= fTextViewer.getTextWidget();
        if (text is null || text.isDisposed())
            return;

        // Invalidate region is> apply text presentation
        fActiveRegion= region;
        if ( cast(ITextViewerExtension2)fTextViewer )
            (cast(ITextViewerExtension2)fTextViewer).invalidateTextPresentation(region.getOffset(), region.getLength());
        else
            fTextViewer.invalidateTextPresentation();
    }

    private void activateCursor() {
        StyledText text= fTextViewer.getTextWidget();
        if (text is null || text.isDisposed())
            return;
        Display display= text.getDisplay();
        if (fCursor is null)
            fCursor= new Cursor(display, SWT.CURSOR_HAND);
        text.setCursor(fCursor);
    }

    private void resetCursor() {
        StyledText text= fTextViewer.getTextWidget();
        if (text !is null && !text.isDisposed())
            text.setCursor(null);

        if (fCursor !is null) {
            fCursor.dispose();
            fCursor= null;
        }
    }

    private void repairRepresentation() {

        if (fActiveRegion is null)
            return;

        int offset= fActiveRegion.getOffset();
        int length= fActiveRegion.getLength();
        fActiveRegion= null;

        resetCursor();

        // Invalidate is> remove applied text presentation
        if ( cast(ITextViewerExtension2)fTextViewer )
            (cast(ITextViewerExtension2) fTextViewer).invalidateTextPresentation(offset, length);
        else
            fTextViewer.invalidateTextPresentation();

    }

    /*
     * @see org.eclipse.jface.text.IDocumentListener#documentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
     */
    public void documentAboutToBeChanged(DocumentEvent event) {
        if (fActiveRegion !is null) {
            fRememberedPosition= new Position(fActiveRegion.getOffset(), fActiveRegion.getLength());
            try {
                event.getDocument().addPosition(fRememberedPosition);
            } catch (BadLocationException x) {
                fRememberedPosition= null;
            }
        }
    }

    /*
     * @see org.eclipse.jface.text.IDocumentListener#documentChanged(org.eclipse.jface.text.DocumentEvent)
     */
    public void documentChanged(DocumentEvent event) {
        if (fRememberedPosition !is null) {
            if (!fRememberedPosition.isDeleted()) {
                event.getDocument().removePosition(fRememberedPosition);
                fActiveRegion= new Region(fRememberedPosition.getOffset(), fRememberedPosition.getLength());
            } else {
                fActiveRegion= new Region(event.getOffset(), event.getLength());
            }
            fRememberedPosition= null;

            StyledText widget= fTextViewer.getTextWidget();
            if (widget !is null && !widget.isDisposed()) {
                widget.getDisplay().asyncExec(new class()  Runnable {
                    public void run() {
                        hideHyperlinks();
                    }
                });
            }
        }
    }

    /*
     * @see org.eclipse.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
     */
    public void inputDocumentAboutToBeChanged(IDocument oldInput, IDocument newInput) {
        if (oldInput is null)
            return;
        hideHyperlinks();
        oldInput.removeDocumentListener(this);
    }

    /*
     * @see org.eclipse.jface.text.ITextInputListener#inputDocumentChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
     */
    public void inputDocumentChanged(IDocument oldInput, IDocument newInput) {
        if (newInput is null)
            return;
        newInput.addDocumentListener(this);
    }

    /**
     * Creates a color from the information stored in the given preference store.
     *
     * @param store the preference store
     * @param key the key
     * @param display the display
     * @return the color or <code>null</code> if there is no such information available
     */
    private Color createColor(IPreferenceStore store, String key, Display display) {

        RGB rgb= null;

        if (store.contains(key)) {

            if (store.isDefault(key))
                rgb= PreferenceConverter.getDefaultColor(store, key);
            else
                rgb= PreferenceConverter.getColor(store, key);

            if (rgb !is null)
                return new Color(display, rgb);
        }

        return null;
    }

    /*
     * @see org.eclipse.jface.util.IPropertyChangeListener#propertyChange(org.eclipse.jface.util.PropertyChangeEvent)
     */
    public void propertyChange(PropertyChangeEvent event) {
        if (!HYPERLINK_COLOR.equals(event.getProperty()))
            return;

        if (fDisposeColor && fColor !is null && !fColor.isDisposed())
            fColor.dispose();
        fColor= null;

        StyledText textWidget= fTextViewer.getTextWidget();
        if (textWidget !is null && !textWidget.isDisposed())
            fColor= createColor(fPreferenceStore, HYPERLINK_COLOR, textWidget.getDisplay());
    }
}
