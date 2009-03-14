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


module org.eclipse.jface.text.rules.IPredicateRule;

import org.eclipse.jface.text.rules.FastPartitioner; // packageimport
import org.eclipse.jface.text.rules.ITokenScanner; // packageimport
import org.eclipse.jface.text.rules.Token; // packageimport
import org.eclipse.jface.text.rules.RuleBasedScanner; // packageimport
import org.eclipse.jface.text.rules.EndOfLineRule; // packageimport
import org.eclipse.jface.text.rules.WordRule; // packageimport
import org.eclipse.jface.text.rules.WhitespaceRule; // packageimport
import org.eclipse.jface.text.rules.WordPatternRule; // packageimport
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
import java.util.Set;

/**
 * Defines the interface for a rule used in the scanning of text for the purpose of
 * document partitioning or text styling. A predicate rule can only return one single
 * token after having successfully detected content. This token is called success token.
 * Also, it also returns a token indicating that this rule has not been successful.
 *
 * @see ICharacterScanner
 * @since 2.0
 */
public interface IPredicateRule : IRule {

    /**
     * Returns the success token of this predicate rule.
     *
     * @return the success token of this rule
     */
    IToken getSuccessToken();

    /**
     * Evaluates the rule by examining the characters available from
     * the provided character scanner. The token returned by this rule
     * returns <code>true</code> when calling <code>isUndefined</code>,
     * if the text that the rule investigated does not match the rule's requirements. Otherwise,
     * this method returns this rule's success token. If this rules relies on a text pattern
     * comprising a opening and a closing character sequence this method can also be called
     * when the scanner is positioned already between the opening and the closing sequence.
     * In this case, <code>resume</code> must be set to <code>true</code>.
     *
     * @param scanner the character scanner to be used by this rule
     * @param resume indicates that the rule starts working between the opening and the closing character sequence
     * @return the token computed by the rule
     */
    IToken evaluate(ICharacterScanner scanner, bool resume);
}
