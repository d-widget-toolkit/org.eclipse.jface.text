/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module org.eclipse.jface.text.rules.IToken;

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
import org.eclipse.jface.text.rules.IPartitionTokenScanner; // packageimport
import org.eclipse.jface.text.rules.MultiLineRule; // packageimport
import org.eclipse.jface.text.rules.RuleBasedPartitioner; // packageimport
import org.eclipse.jface.text.rules.RuleBasedPartitionScanner; // packageimport
import org.eclipse.jface.text.rules.BufferedRuleBasedScanner; // packageimport
import org.eclipse.jface.text.rules.IWhitespaceDetector; // packageimport


import java.lang.all;


/**
 * A token to be returned by a rule.
 */
public interface IToken {

    /**
     * Return whether this token is undefined.
     *
     * @return <code>true</code>if this token is undefined
     */
    bool isUndefined();

    /**
     * Return whether this token represents a whitespace.
     *
     * @return <code>true</code>if this token represents a whitespace
     */
    bool isWhitespace();

    /**
     * Return whether this token represents End Of File.
     *
     * @return <code>true</code>if this token represents EOF
     */
    bool isEOF();

    /**
     * Return whether this token is neither undefined, nor whitespace, nor EOF.
     *
     * @return <code>true</code>if this token is not undefined, not a whitespace, and not EOF
     */
    bool isOther();

    /**
     * Return a data attached to this token. The semantics of this data kept undefined by this interface.
     *
     * @return the data attached to this token.
     */
    Object getData();
}
