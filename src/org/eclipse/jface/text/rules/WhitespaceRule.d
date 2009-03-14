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


module org.eclipse.jface.text.rules.WhitespaceRule;

import org.eclipse.jface.text.rules.FastPartitioner; // packageimport
import org.eclipse.jface.text.rules.ITokenScanner; // packageimport
import org.eclipse.jface.text.rules.Token; // packageimport
import org.eclipse.jface.text.rules.RuleBasedScanner; // packageimport
import org.eclipse.jface.text.rules.EndOfLineRule; // packageimport
import org.eclipse.jface.text.rules.WordRule; // packageimport
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
import org.eclipse.jface.text.rules.BufferedRuleBasedScanner; // packageimport
import org.eclipse.jface.text.rules.IWhitespaceDetector; // packageimport

import java.lang.all;


import org.eclipse.core.runtime.Assert;


/**
 * An implementation of <code>IRule</code> capable of detecting whitespace.
 * A whitespace rule uses a whitespace detector in order to find out which
 * characters are whitespace characters.
 *
 * @see IWhitespaceDetector
 */
public class WhitespaceRule : IRule {

    /** The whitespace detector used by this rule */
    protected IWhitespaceDetector fDetector;

    /**
     * Creates a rule which, with the help of an
     * whitespace detector, will return a whitespace
     * token when a whitespace is detected.
     *
     * @param detector the rule's whitespace detector, may not be <code>null</code>
     */
    public this(IWhitespaceDetector detector) {
        Assert.isNotNull(cast(Object)detector);
        fDetector= detector;
    }

    /*
     * @see IRule#evaluate(ICharacterScanner)
     */
    public IToken evaluate(ICharacterScanner scanner) {
        int c= scanner.read();
        if (fDetector.isWhitespace(cast(char) c)) {
            do {
                c= scanner.read();
            } while (fDetector.isWhitespace(cast(char) c));
            scanner.unread();
            return Token.WHITESPACE;
        }

        scanner.unread();
        return Token.UNDEFINED;
    }
}
