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


module org.eclipse.jface.text.rules.NumberRule;

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
import java.util.Set;

import org.eclipse.core.runtime.Assert;


/**
 * An implementation of <code>IRule</code> detecting a numerical value.
 */
public class NumberRule : IRule {

    /** Internal setting for the un-initialized column constraint */
    protected static const int UNDEFINED= -1;
    /** The token to be returned when this rule is successful */
    protected IToken fToken;
    /** The column constraint */
    protected int fColumn= UNDEFINED;

    /**
     * Creates a rule which will return the specified
     * token when a numerical sequence is detected.
     *
     * @param token the token to be returned
     */
    public this(IToken token) {
        Assert.isNotNull(cast(Object)token);
        fToken= token;
    }

    /**
     * Sets a column constraint for this rule. If set, the rule's token
     * will only be returned if the pattern is detected starting at the
     * specified column. If the column is smaller then 0, the column
     * constraint is considered removed.
     *
     * @param column the column in which the pattern starts
     */
    public void setColumnConstraint(int column) {
        if (column < 0)
            column= UNDEFINED;
        fColumn= column;
    }

    /*
     * @see IRule#evaluate(ICharacterScanner)
     */
    public IToken evaluate(ICharacterScanner scanner) {
        int c= scanner.read();
        if (Character.isDigit(cast(char)c)) {
            if (fColumn is UNDEFINED || (fColumn is scanner.getColumn() - 1)) {
                do {
                    c= scanner.read();
                } while (Character.isDigit(cast(char) c));
                scanner.unread();
                return fToken;
            }
        }

        scanner.unread();
        return Token.UNDEFINED;
    }
}
