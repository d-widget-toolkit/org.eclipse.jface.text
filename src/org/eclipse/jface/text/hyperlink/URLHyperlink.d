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
module org.eclipse.jface.text.hyperlink.URLHyperlink;

import org.eclipse.jface.text.hyperlink.IHyperlinkPresenterExtension; // packageimport
import org.eclipse.jface.text.hyperlink.MultipleHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.HyperlinkManager; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetectorExtension2; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.URLHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.AbstractHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetectorExtension; // packageimport
import org.eclipse.jface.text.hyperlink.HyperlinkMessages; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlink; // packageimport


import java.lang.all;
import java.text.MessageFormat;

import org.eclipse.swt.program.Program;
import org.eclipse.core.runtime.Assert;
import org.eclipse.jface.text.IRegion;





/**
 * URL hyperlink.
 *
 * @since 3.1
 */
public class URLHyperlink : IHyperlink {

    private String fURLString;
    private IRegion fRegion;

    /**
     * Creates a new URL hyperlink.
     *
     * @param region
     * @param urlString
     */
    public this(IRegion region, String urlString) {
        Assert.isNotNull(urlString);
        Assert.isNotNull(cast(Object)region);

        fRegion= region;
        fURLString= urlString;
    }

    /*
     * @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlink#getHyperlinkRegion()
     */
    public IRegion getHyperlinkRegion() {
        return fRegion;
    }

    /*
     * @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlink#open()
     */
    public void open() {
        if (fURLString !is null) {
            Program.launch(fURLString);
            fURLString= null;
            return;
        }
    }

    /*
     * @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlink#getTypeLabel()
     */
    public String getTypeLabel() {
        return null;
    }

    /*
     * @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlink#getHyperlinkText()
     */
    public String getHyperlinkText() {
        return MessageFormat.format(HyperlinkMessages.getString("URLHyperlink.hyperlinkText"), stringcast(fURLString) ); //$NON-NLS-1$
    }

    /**
     * Returns the URL string of this hyperlink.
     *
     * @return the URL string
     * @since 3.2
     */
    public String getURLString() {
        return fURLString;
    }

}
