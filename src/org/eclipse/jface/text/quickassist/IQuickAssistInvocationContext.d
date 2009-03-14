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
module org.eclipse.jface.text.quickassist.IQuickAssistInvocationContext;

import org.eclipse.jface.text.quickassist.QuickAssistAssistant; // packageimport
import org.eclipse.jface.text.quickassist.IQuickAssistAssistant; // packageimport
import org.eclipse.jface.text.quickassist.IQuickAssistAssistantExtension; // packageimport
import org.eclipse.jface.text.quickassist.IQuickFixableAnnotation; // packageimport
import org.eclipse.jface.text.quickassist.IQuickAssistProcessor; // packageimport


import java.lang.all;
import java.util.Set;

import org.eclipse.jface.text.source.ISourceViewer;


/**
 * Context information for quick fix and quick assist processors.
 * <p>
 * This interface can be implemented by clients.</p>
 * 
 * @since 3.2
 */
public interface IQuickAssistInvocationContext {

    /**
     * Returns the offset where quick assist was invoked.
     * 
     * @return the invocation offset or <code>-1</code> if unknown
     */
    int getOffset();

    /**
     * Returns the length of the selection at the invocation offset.
     * 
     * @return the length of the current selection or <code>-1</code> if none or unknown
     */
    int getLength();
    
    /**
     * Returns the viewer for this context.
     * 
     * @return the viewer or <code>null</code> if not available
     */
    ISourceViewer getSourceViewer();
}
