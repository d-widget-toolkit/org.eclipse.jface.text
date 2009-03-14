/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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


module org.eclipse.jface.text.rules.RuleBasedPartitionScanner;

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
import org.eclipse.jface.text.rules.BufferedRuleBasedScanner; // packageimport
import org.eclipse.jface.text.rules.IWhitespaceDetector; // packageimport

import java.lang.all;
import java.util.Set;


import org.eclipse.jface.text.IDocument;


/**
 * Scanner that exclusively uses predicate rules.
 * @since 2.0
 */
public class RuleBasedPartitionScanner : BufferedRuleBasedScanner , IPartitionTokenScanner {

    /** The content type of the partition in which to resume scanning. */
    protected String fContentType;
    /** The offset of the partition inside which to resume. */
    protected int fPartitionOffset;


    /**
     * Disallow setting the rules since this scanner
     * exclusively uses predicate rules.
     *
     * @param rules the sequence of rules controlling this scanner
     */
    public void setRules(IRule[] rules) {
        throw new UnsupportedOperationException();
    }

    /*
     * @see RuleBasedScanner#setRules(IRule[])
     */
    public void setPredicateRules(IPredicateRule[] rules) {
        super.setRules(rules);
    }

    /*
     * @see ITokenScanner#setRange(IDocument, int, int)
     */
    public void setRange(IDocument document, int offset, int length) {
        setPartialRange(document, offset, length, null, -1);
    }

    /*
     * @see IPartitionTokenScanner#setPartialRange(IDocument, int, int, String, int)
     */
    public void setPartialRange(IDocument document, int offset, int length, String contentType, int partitionOffset) {
        fContentType= contentType;
        fPartitionOffset= partitionOffset;
        if (partitionOffset > -1) {
            int delta= offset - partitionOffset;
            if (delta > 0) {
                super.setRange(document, partitionOffset, length + delta);
                fOffset= offset;
                return;
            }
        }
        super.setRange(document, offset, length);
    }

    /*
     * @see ITokenScanner#nextToken()
     */
    public IToken nextToken() {


        if (fContentType is null || fRules is null) {
            //don't try to resume
            return super.nextToken();
        }

        // inside a partition

        fColumn= UNDEFINED;
        bool resume= (fPartitionOffset > -1 && fPartitionOffset < fOffset);
        fTokenOffset= resume ? fPartitionOffset : fOffset;

        IPredicateRule rule;
        IToken token;

        for (int i= 0; i < fRules.length; i++) {
            rule= cast(IPredicateRule) fRules[i];
            token= rule.getSuccessToken();
            if (fContentType.equals(stringcast(token.getData()))) {
                token= rule.evaluate(this, resume);
                if (!token.isUndefined()) {
                    fContentType= null;
                    return token;
                }
            }
        }

        // haven't found any rule for this type of partition
        fContentType= null;
        if (resume)
            fOffset= fPartitionOffset;
        return super.nextToken();
    }
}
