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


module org.eclipse.jface.text.rules.IPartitionTokenScanner;

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
import org.eclipse.jface.text.rules.MultiLineRule; // packageimport
import org.eclipse.jface.text.rules.RuleBasedPartitioner; // packageimport
import org.eclipse.jface.text.rules.RuleBasedPartitionScanner; // packageimport
import org.eclipse.jface.text.rules.BufferedRuleBasedScanner; // packageimport
import org.eclipse.jface.text.rules.IWhitespaceDetector; // packageimport

import java.lang.all;
import java.util.Set;


import org.eclipse.jface.text.IDocument;


/**
 * A partition token scanner returns tokens that represent partitions. For that reason,
 * a partition token scanner is vulnerable in respect to the document offset it starts
 * scanning. In a simple case, a partition token scanner must always start at a partition
 * boundary. A partition token scanner can also start in the middle of a partition,
 * if it knows the type of the partition.
 *
 * @since 2.0
 */
public interface IPartitionTokenScanner  : ITokenScanner {

    /**
     * Configures the scanner by providing access to the document range that should be scanned.
     * The range may no only contain complete partitions but starts at the beginning of a line in the
     * middle of a partition of the given content type. This requires that a partition delimiter can not
     * contain a line delimiter.
     *
     * @param document the document to scan
     * @param offset the offset of the document range to scan
     * @param length the length of the document range to scan
     * @param contentType the content type at the given offset
     * @param partitionOffset the offset at which the partition of the given offset starts
     */
    void setPartialRange(IDocument document, int offset, int length, String contentType, int partitionOffset);
}
