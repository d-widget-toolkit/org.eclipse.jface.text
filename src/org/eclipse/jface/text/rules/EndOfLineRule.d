/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Christopher Lenz (cmlenz@gmx.de) - support for line continuation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.jface.text.rules.EndOfLineRule;

import org.eclipse.jface.text.rules.FastPartitioner; // packageimport
import org.eclipse.jface.text.rules.ITokenScanner; // packageimport
import org.eclipse.jface.text.rules.Token; // packageimport
import org.eclipse.jface.text.rules.RuleBasedScanner; // packageimport
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
import org.eclipse.jface.text.rules.BufferedRuleBasedScanner; // packageimport
import org.eclipse.jface.text.rules.IWhitespaceDetector; // packageimport


import java.lang.all;
import java.util.Set;


/**
 * A specific configuration of a single line rule
 * whereby the pattern begins with a specific sequence but
 * is only ended by a line delimiter.
 */
public class EndOfLineRule : SingleLineRule {

    /**
     * Creates a rule for the given starting sequence
     * which, if detected, will return the specified token.
     *
     * @param startSequence the pattern's start sequence
     * @param token the token to be returned on success
     */
    public this(String startSequence, IToken token) {
        this(startSequence, token, cast(wchar) 0);
    }

    /**
     * Creates a rule for the given starting sequence
     * which, if detected, will return the specified token.
     * Any character which follows the given escape character
     * will be ignored.
     *
     * @param startSequence the pattern's start sequence
     * @param token the token to be returned on success
     * @param escapeCharacter the escape character
     */
    public this(String startSequence, IToken token, char escapeCharacter) {
        super(startSequence, null, token, escapeCharacter, true);
    }

    /**
     * Creates a rule for the given starting sequence
     * which, if detected, will return the specified token.
     * Any character which follows the given escape character
     * will be ignored. In addition, an escape character
     * immediately before an end of line can be set to continue
     * the line.
     *
     * @param startSequence the pattern's start sequence
     * @param token the token to be returned on success
     * @param escapeCharacter the escape character
     * @param escapeContinuesLine indicates whether the specified escape
     *        character is used for line continuation, so that an end of
     *        line immediately after the escape character does not
     *        terminate the line, even if <code>breakOnEOL</code> is true
     * @since 3.0
     */
    public this(String startSequence, IToken token, char escapeCharacter, bool escapeContinuesLine) {
        super(startSequence, null, token, escapeCharacter, true, escapeContinuesLine);
    }
}
