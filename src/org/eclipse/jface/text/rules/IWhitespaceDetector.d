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
module org.eclipse.jface.text.rules.IWhitespaceDetector;

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
import org.eclipse.jface.text.rules.BufferedRuleBasedScanner; // packageimport


import java.lang.all;


/**
 * Defines the interface by which <code>WhitespaceRule</code>
 * determines whether a given character is to be considered
 * whitespace in the current context.
 */
public interface IWhitespaceDetector {

    /**
     * Returns whether the specified character is whitespace.
     *
     * @param c the character to be checked
     * @return <code>true</code> if the specified character is a whitespace char
     */
    bool isWhitespace(char c);
}
