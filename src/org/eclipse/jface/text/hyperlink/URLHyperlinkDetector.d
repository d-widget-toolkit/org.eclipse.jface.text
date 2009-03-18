/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Benjamin Muskalla <b.muskalla@gmx.net> - https://bugs.eclipse.org/bugs/show_bug.cgi?id=156433
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.jface.text.hyperlink.URLHyperlinkDetector;

import org.eclipse.jface.text.hyperlink.IHyperlinkPresenterExtension; // packageimport
import org.eclipse.jface.text.hyperlink.MultipleHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.HyperlinkManager; // packageimport
import org.eclipse.jface.text.hyperlink.URLHyperlink; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetectorExtension2; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.AbstractHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetectorExtension; // packageimport
import org.eclipse.jface.text.hyperlink.HyperlinkMessages; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlink; // packageimport

import java.lang.all;
import java.util.Set;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.StringTokenizer;

import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IRegion;
import org.eclipse.jface.text.ITextViewer;
import org.eclipse.jface.text.Region;


/**
 * URL hyperlink detector.
 *
 * @since 3.1
 */
public class URLHyperlinkDetector : AbstractHyperlinkDetector {


    /**
     * Creates a new URL hyperlink detector.
     *
     * @since 3.2
     */
    public this() {
    }

    /**
     * Creates a new URL hyperlink detector.
     *
     * @param textViewer the text viewer in which to detect the hyperlink
     * @deprecated As of 3.2, replaced by {@link URLHyperlinkDetector}
     */
    public this(ITextViewer textViewer) {
    }

    /*
     * @see org.eclipse.jface.text.hyperlink.IHyperlinkDetector#detectHyperlinks(org.eclipse.jface.text.ITextViewer, org.eclipse.jface.text.IRegion, bool)
     */
    public IHyperlink[] detectHyperlinks(ITextViewer textViewer, IRegion region, bool canShowMultipleHyperlinks) {
        if (region is null || textViewer is null)
            return null;

        IDocument document= textViewer.getDocument();

        int offset= region.getOffset();

        String urlString= null;
        if (document is null)
            return null;

        IRegion lineInfo;
        String line;
        try {
            lineInfo= document.getLineInformationOfOffset(offset);
            line= document.get(lineInfo.getOffset(), lineInfo.getLength());
        } catch (BadLocationException ex) {
            return null;
        }

        int offsetInLine= offset - lineInfo.getOffset();

        bool startDoubleQuote= false;
        int urlOffsetInLine= 0;
        int urlLength= 0;

        int urlSeparatorOffset= line.indexOf("://"); //$NON-NLS-1$
        while (urlSeparatorOffset >= 0) {

            // URL protocol (left to "://")
            urlOffsetInLine= urlSeparatorOffset;
            char ch;
            do {
                urlOffsetInLine--;
                ch= ' ';
                if (urlOffsetInLine > -1)
                    ch= line.charAt(urlOffsetInLine);
                startDoubleQuote= ch is '"';
            } while (Character.isUnicodeIdentifierStart(ch));
            urlOffsetInLine++;

            // Right to "://"
            StringTokenizer tokenizer= new StringTokenizer(line.substring(urlSeparatorOffset + 3), " \t\n\r\f<>", false); //$NON-NLS-1$
            if (!tokenizer.hasMoreTokens())
                return null;

            urlLength= tokenizer.nextToken().length() + 3 + urlSeparatorOffset - urlOffsetInLine;
            if (offsetInLine >= urlOffsetInLine && offsetInLine <= urlOffsetInLine + urlLength)
                break;

            urlSeparatorOffset= line.indexOf("://", urlSeparatorOffset + 1); //$NON-NLS-1$
        }

        if (urlSeparatorOffset < 0)
            return null;

        if (startDoubleQuote) {
            int endOffset= -1;
            int nextDoubleQuote= line.indexOf('"', urlOffsetInLine);
            int nextWhitespace= line.indexOf(' ', urlOffsetInLine);
            if (nextDoubleQuote !is -1 && nextWhitespace !is -1)
                endOffset= Math.min(nextDoubleQuote, nextWhitespace);
            else if (nextDoubleQuote !is -1)
                endOffset= nextDoubleQuote;
            else if (nextWhitespace !is -1)
                endOffset= nextWhitespace;
            if (endOffset !is -1)
                urlLength= endOffset - urlOffsetInLine;
        }

        // Set and validate URL string
        try {
            urlString= line.substring(urlOffsetInLine, urlOffsetInLine + urlLength);
            new URL(urlString);
        } catch (MalformedURLException ex) {
            urlString= null;
            return null;
        }

        IRegion urlRegion= new Region(lineInfo.getOffset() + urlOffsetInLine, urlLength);
        return [new URLHyperlink(urlRegion, urlString)];
    }

}
