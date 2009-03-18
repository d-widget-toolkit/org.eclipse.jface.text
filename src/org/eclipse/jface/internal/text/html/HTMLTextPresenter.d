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
module org.eclipse.jface.internal.text.html.HTMLTextPresenter;

import org.eclipse.jface.internal.text.html.HTML2TextReader; // packageimport
import org.eclipse.jface.internal.text.html.HTMLPrinter; // packageimport
import org.eclipse.jface.internal.text.html.BrowserInformationControl; // packageimport
import org.eclipse.jface.internal.text.html.SubstitutionTextReader; // packageimport
import org.eclipse.jface.internal.text.html.BrowserInput; // packageimport
import org.eclipse.jface.internal.text.html.SingleCharReader; // packageimport
import org.eclipse.jface.internal.text.html.BrowserInformationControlInput; // packageimport
import org.eclipse.jface.internal.text.html.HTMLMessages; // packageimport


import java.lang.all;
import java.io.Reader;
import java.util.Iterator;
import java.util.Set;
import java.io.StringReader;

import org.eclipse.swt.custom.StyleRange;
import org.eclipse.swt.graphics.Drawable;
import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.widgets.Display;
import org.eclipse.jface.internal.text.link.contentassist.LineBreakingReader;
import org.eclipse.jface.text.DefaultInformationControl;
import org.eclipse.jface.text.Region;
import org.eclipse.jface.text.TextPresentation;


/**
 * <p>
 * Moved into this package from <code>org.eclipse.jface.internal.text.revisions</code>.</p>
 */
public class HTMLTextPresenter : DefaultInformationControl_IInformationPresenter, DefaultInformationControl_IInformationPresenterExtension {

    private static String LINE_DELIM_;
    private static String LINE_DELIM() {
        if( LINE_DELIM_ is null ){
            LINE_DELIM_ = System.getProperty("line.separator", "\n"); //$NON-NLS-1$ //$NON-NLS-2$
        }
        return LINE_DELIM_;
    }

    private int fCounter;
    private bool fEnforceUpperLineLimit;

    public this(bool enforceUpperLineLimit) {
//         super();
        fEnforceUpperLineLimit= enforceUpperLineLimit;
    }

    public this() {
        this(true);
    }

    protected Reader createReader(String hoverInfo, TextPresentation presentation) {
        return new HTML2TextReader(new StringReader(hoverInfo), presentation);
    }

    protected void adaptTextPresentation(TextPresentation presentation, int offset, int insertLength) {

        int yoursStart= offset;
        int yoursEnd=   offset + insertLength -1;
        yoursEnd= Math.max(yoursStart, yoursEnd);

        Iterator e= presentation.getAllStyleRangeIterator();
        while (e.hasNext()) {

            StyleRange range= cast(StyleRange) e.next();

            int myStart= range.start;
            int myEnd=   range.start + range.length -1;
            myEnd= Math.max(myStart, myEnd);

            if (myEnd < yoursStart)
                continue;

            if (myStart < yoursStart)
                range.length += insertLength;
            else
                range.start += insertLength;
        }
    }

    private void append(StringBuffer buffer, String string, TextPresentation presentation) {

        int length= string.length();
        buffer.append(string);

        if (presentation !is null)
            adaptTextPresentation(presentation, fCounter, length);

        fCounter += length;
    }

    private String getIndent(String line) {
        int length= line.length();

        int i= 0;
        while (i < length && Character.isWhitespace(line.getRelativeCodePoint(i,0)))
            i += line.getRelativeCodePointOffset(i,1);

        return (i is length ? line : line.substring(0, i)) ~ " "; //$NON-NLS-1$
    }

    /**
     * {@inheritDoc}
     *
     * @see org.eclipse.jface.text.DefaultInformationControl.IInformationPresenter#updatePresentation(org.eclipse.swt.widgets.Display, java.lang.String, org.eclipse.jface.text.TextPresentation, int, int)
     * @deprecated
     */
    public String updatePresentation(Display display, String hoverInfo, TextPresentation presentation, int maxWidth, int maxHeight) {
        return updatePresentation(cast(Drawable)display, hoverInfo, presentation, maxWidth, maxHeight);
    }

    /*
     * @see IHoverInformationPresenterExtension#updatePresentation(Drawable drawable, String, TextPresentation, int, int)
     * @since 3.2
     */
    public String updatePresentation(Drawable drawable, String hoverInfo, TextPresentation presentation, int maxWidth, int maxHeight) {

        if (hoverInfo is null)
            return null;

        GC gc= new GC(drawable);
        try {

            StringBuffer buffer= new StringBuffer();
            int maxNumberOfLines= cast(int) Math.round(maxHeight / gc.getFontMetrics().getHeight());

            fCounter= 0;
            LineBreakingReader reader= new LineBreakingReader(createReader(hoverInfo, presentation), gc, maxWidth);

            bool lastLineFormatted= false;
            String lastLineIndent= null;

            String line=reader.readLine();
            bool lineFormatted= reader.isFormattedLine();
            bool firstLineProcessed= false;

            while (line !is null) {

                if (fEnforceUpperLineLimit && maxNumberOfLines <= 0)
                    break;

                if (firstLineProcessed) {
                    if (!lastLineFormatted)
                        append(buffer, LINE_DELIM, null);
                    else {
                        append(buffer, LINE_DELIM, presentation);
                        if (lastLineIndent !is null)
                            append(buffer, lastLineIndent, presentation);
                    }
                }

                append(buffer, line, null);
                firstLineProcessed= true;

                lastLineFormatted= lineFormatted;
                if (!lineFormatted)
                    lastLineIndent= null;
                else if (lastLineIndent is null)
                    lastLineIndent= getIndent(line);

                line= reader.readLine();
                lineFormatted= reader.isFormattedLine();

                maxNumberOfLines--;
            }

            if (line !is null) {
                append(buffer, LINE_DELIM, lineFormatted ? presentation : null);
                append(buffer, HTMLMessages.getString("HTMLTextPresenter.ellipse"), presentation); //$NON-NLS-1$
            }

            return trim(buffer, presentation);

        } catch (IOException e) {

            // ignore TODO do something else?
            return null;

        } finally {
            gc.dispose();
        }
    }

    private String trim(StringBuffer buffer, TextPresentation presentation) {

        int length= buffer.length();

        int end= length -1;

        while (end >= 0 && Character.isWhitespace(buffer.slice().getRelativeCodePoint( end, -1 )))
            end += buffer.slice().getRelativeCodePointOffset( end, -1 );

        if (end <= -1)
            return ""; //$NON-NLS-1$

        if (end < buffer.slice().getAbsoluteCodePointOffset( length, -1 ))
            buffer.truncate(buffer.slice().getAbsoluteCodePointOffset( end, 1));
        else
            end= length;

        int start= 0;
        while (start < end && Character.isWhitespace(buffer.slice().getRelativeCodePoint(start, 0)))
            start += buffer.slice().getRelativeCodePointOffset( start, 1 );

        buffer.delete_(0, start);
        presentation.setResultWindow(new Region(start, buffer.length()));
        return buffer.toString();
    }
}

