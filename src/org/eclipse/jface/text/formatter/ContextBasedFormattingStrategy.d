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


module org.eclipse.jface.text.formatter.ContextBasedFormattingStrategy;

import org.eclipse.jface.text.formatter.MultiPassContentFormatter; // packageimport
import org.eclipse.jface.text.formatter.FormattingContext; // packageimport
import org.eclipse.jface.text.formatter.IFormattingStrategy; // packageimport
import org.eclipse.jface.text.formatter.IContentFormatterExtension; // packageimport
import org.eclipse.jface.text.formatter.IFormattingStrategyExtension; // packageimport
import org.eclipse.jface.text.formatter.IContentFormatter; // packageimport
import org.eclipse.jface.text.formatter.FormattingContextProperties; // packageimport
import org.eclipse.jface.text.formatter.ContentFormatter; // packageimport
import org.eclipse.jface.text.formatter.IFormattingContext; // packageimport

import java.lang.all;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;



/**
 * Formatting strategy for context based content formatting. Retrieves the preferences
 * set on the formatting context's {@link FormattingContextProperties#CONTEXT_PREFERENCES}
 * property and makes them available to subclasses.
 * <p>
 *
 * @since 3.0
 */
public abstract class ContextBasedFormattingStrategy : IFormattingStrategy, IFormattingStrategyExtension {

    /** The current preferences for formatting */
    private Map fCurrentPreferences= null;

    /** The list of preferences for initiated the formatting steps */
    private const LinkedList fPreferences;

    this(){
        fPreferences= new LinkedList();
    }

    /*
     * @see org.eclipse.jface.text.formatter.IFormattingStrategyExtension#format()
     */
    public void format() {
        fCurrentPreferences= cast(Map)fPreferences.removeFirst();
    }

    /*
     * @see org.eclipse.jface.text.formatter.IFormattingStrategy#format(java.lang.String, bool, java.lang.String, int[])
     */
    public String format(String content, bool start, String indentation, int[] positions) {
        return null;
    }

    /*
     * @see org.eclipse.jface.text.formatter.IFormattingStrategyExtension#formatterStarts(org.eclipse.jface.text.formatter.IFormattingContext)
     */
    public void formatterStarts(IFormattingContext context) {
        fPreferences.addLast(context.getProperty(stringcast(FormattingContextProperties.CONTEXT_PREFERENCES)));
    }

    /*
     * @see IFormattingStrategy#formatterStarts(String)
     */
    public void formatterStarts(String indentation) {
        // Do nothing
    }

    /*
     * @see org.eclipse.jface.text.formatter.IFormattingStrategyExtension#formatterStops()
     */
    public void formatterStops() {
        fPreferences.clear();

        fCurrentPreferences= null;
    }

    /**
     * Returns the preferences used for the current formatting step.
     *
     * @return The preferences for the current formatting step
     */
    public final Map getPreferences() {
        return fCurrentPreferences;
    }
}
