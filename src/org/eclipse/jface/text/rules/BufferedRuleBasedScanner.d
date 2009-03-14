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


module org.eclipse.jface.text.rules.BufferedRuleBasedScanner;

import org.eclipse.jface.text.rules.FastPartitioner; // packageimport
import org.eclipse.jface.text.rules.ITokenScanner; // packageimport
import org.eclipse.jface.text.rules.Token; // packageimport
import org.eclipse.jface.text.rules.RuleBasedScanner; // packageimport
import org.eclipse.jface.text.rules.EndOfLineRule; // packageimport
import org.eclipse.jface.text.rules.WordRule; // packageimport
import org.eclipse.jface.text.rules.WhitespaceRule; // packageimport
import org.eclipse.jface.text.rules.WordPatternRule; // packageimport
import org.eclipse.jface.text.rules.IPredicateRule; // packageimport
import org.eclipse.jface.text.rules.DefaultPartitioner; // packageimport
import org.eclipse.jface.text.rules.NumberRule; // packageimport
import org.eclipse.jface.text.rules.SingleLineRule; // packageimport
import org.eclipse.jface.text.rules.PatternRule; // packageimport
import org.eclipse.jface.text.rules.RuleBasedDamagerRepairer; // packageimport
import org.eclipse.jface.text.rules.ICharacterScanner; // packageimport
import org.eclipse.jface.text.rules.IRule; // packageimport
import org.eclipse.jface.text.rules.DefaultDamagerRepairer; // packageimport
import org.eclipse.jface.text.rules.IToken; // packageimport
import org.eclipse.jface.text.rules.IPartitionTokenScanner; // packageimport
import org.eclipse.jface.text.rules.MultiLineRule; // packageimport
import org.eclipse.jface.text.rules.RuleBasedPartitioner; // packageimport
import org.eclipse.jface.text.rules.RuleBasedPartitionScanner; // packageimport
import org.eclipse.jface.text.rules.IWhitespaceDetector; // packageimport

import java.lang.all;
import java.util.Set;


import org.eclipse.core.runtime.Assert;
import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.IDocument;

/**
 * A buffered rule based scanner. The buffer always contains a section
 * of a fixed size of the document to be scanned. Completely adheres to
 * the contract of <code>RuleBasedScanner</code>.
 */
public class BufferedRuleBasedScanner : RuleBasedScanner {

    /** The default buffer size. Value = 500 */
    private const static int DEFAULT_BUFFER_SIZE= 500;
    /** The actual size of the buffer. Initially set to <code>DEFAULT_BUFFER_SIZE</code> */
    private int fBufferSize= DEFAULT_BUFFER_SIZE;
    /** The buffer */
    private char[] fBuffer;
    /** The offset of the document at which the buffer starts */
    private int fStart;
    /** The offset of the document at which the buffer ends */
    private int fEnd;
    /** The cached length of the document */
    private int fDocumentLength;


    /**
     * Creates a new buffered rule based scanner which does
     * not have any rule and a default buffer size of 500 characters.
     */
    protected this() {
        super();
        fBuffer= new char[DEFAULT_BUFFER_SIZE];
        fBuffer[] = 0;
    }

    /**
     * Creates a new buffered rule based scanner which does
     * not have any rule. The buffer size is set to the given
     * number of characters.
     *
     * @param size the buffer size
     */
    public this(int size) {
        super();
        fBuffer= new char[DEFAULT_BUFFER_SIZE];
        fBuffer[] = 0;
        setBufferSize(size);
    }

    /**
     * Sets the buffer to the given number of characters.
     *
     * @param size the buffer size
     */
    protected void setBufferSize(int size) {
        Assert.isTrue(size > 0);
        fBufferSize= size;
        fBuffer= new char[size];
        fBuffer[] = 0;
    }

    /**
     * Shifts the buffer so that the buffer starts at the
     * given document offset.
     *
     * @param offset the document offset at which the buffer starts
     */
    private void shiftBuffer(int offset) {

        fStart= offset;
        fEnd= fStart + fBufferSize;
        if (fEnd > fDocumentLength)
            fEnd= fDocumentLength;

        try {

            String content= fDocument.get(fStart, fEnd - fStart);
            content.getChars(0, fEnd - fStart, fBuffer, 0);

        } catch (BadLocationException x) {
        }
    }

    /*
     * @see RuleBasedScanner#setRange(IDocument, int, int)
     */
    public void setRange(IDocument document, int offset, int length) {

        super.setRange(document, offset, length);

        fDocumentLength= document.getLength();
        shiftBuffer(offset);
    }

    /*
     * @see RuleBasedScanner#read()
     */
    public int read() {
        fColumn= UNDEFINED;
        if (fOffset >= fRangeEnd) {
            ++ fOffset;
            return EOF;
        }

        if (fOffset is fEnd)
            shiftBuffer(fEnd);
        else if (fOffset < fStart || fEnd < fOffset)
            shiftBuffer(fOffset);

        return fBuffer[fOffset++ - fStart];
    }

    /*
     * @see RuleBasedScanner#unread()
     */
    public void unread() {

        if (fOffset is fStart)
            shiftBuffer(Math.max(0, fStart - (fBufferSize / 2)));

        --fOffset;
        fColumn= UNDEFINED;
    }
}


