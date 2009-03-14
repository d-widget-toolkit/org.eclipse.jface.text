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
module org.eclipse.jface.text.source.ILineDiffer;

import org.eclipse.jface.text.source.ISharedTextColors; // packageimport
import org.eclipse.jface.text.source.ILineRange; // packageimport
import org.eclipse.jface.text.source.IAnnotationPresentation; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerInfoExtension; // packageimport
import org.eclipse.jface.text.source.ICharacterPairMatcher; // packageimport
import org.eclipse.jface.text.source.TextInvocationContext; // packageimport
import org.eclipse.jface.text.source.LineChangeHover; // packageimport
import org.eclipse.jface.text.source.IChangeRulerColumn; // packageimport
import org.eclipse.jface.text.source.IAnnotationMap; // packageimport
import org.eclipse.jface.text.source.IAnnotationModelListenerExtension; // packageimport
import org.eclipse.jface.text.source.ISourceViewerExtension2; // packageimport
import org.eclipse.jface.text.source.IAnnotationHover; // packageimport
import org.eclipse.jface.text.source.ContentAssistantFacade; // packageimport
import org.eclipse.jface.text.source.IAnnotationAccess; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerExtension; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerColumn; // packageimport
import org.eclipse.jface.text.source.LineNumberRulerColumn; // packageimport
import org.eclipse.jface.text.source.MatchingCharacterPainter; // packageimport
import org.eclipse.jface.text.source.IAnnotationModelExtension; // packageimport
import org.eclipse.jface.text.source.ILineDifferExtension; // packageimport
import org.eclipse.jface.text.source.DefaultCharacterPairMatcher; // packageimport
import org.eclipse.jface.text.source.LineNumberChangeRulerColumn; // packageimport
import org.eclipse.jface.text.source.IAnnotationAccessExtension; // packageimport
import org.eclipse.jface.text.source.ISourceViewer; // packageimport
import org.eclipse.jface.text.source.AnnotationModel; // packageimport
import org.eclipse.jface.text.source.ILineDifferExtension2; // packageimport
import org.eclipse.jface.text.source.IAnnotationModelListener; // packageimport
import org.eclipse.jface.text.source.IVerticalRuler; // packageimport
import org.eclipse.jface.text.source.DefaultAnnotationHover; // packageimport
import org.eclipse.jface.text.source.SourceViewer; // packageimport
import org.eclipse.jface.text.source.SourceViewerConfiguration; // packageimport
import org.eclipse.jface.text.source.AnnotationBarHoverManager; // packageimport
import org.eclipse.jface.text.source.CompositeRuler; // packageimport
import org.eclipse.jface.text.source.ImageUtilities; // packageimport
import org.eclipse.jface.text.source.VisualAnnotationModel; // packageimport
import org.eclipse.jface.text.source.IAnnotationModel; // packageimport
import org.eclipse.jface.text.source.ISourceViewerExtension3; // packageimport
import org.eclipse.jface.text.source.ILineDiffInfo; // packageimport
import org.eclipse.jface.text.source.VerticalRulerEvent; // packageimport
import org.eclipse.jface.text.source.ChangeRulerColumn; // packageimport
import org.eclipse.jface.text.source.AnnotationModelEvent; // packageimport
import org.eclipse.jface.text.source.AnnotationColumn; // packageimport
import org.eclipse.jface.text.source.AnnotationRulerColumn; // packageimport
import org.eclipse.jface.text.source.IAnnotationHoverExtension; // packageimport
import org.eclipse.jface.text.source.AbstractRulerColumn; // packageimport
import org.eclipse.jface.text.source.ISourceViewerExtension; // packageimport
import org.eclipse.jface.text.source.AnnotationMap; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerInfo; // packageimport
import org.eclipse.jface.text.source.IAnnotationModelExtension2; // packageimport
import org.eclipse.jface.text.source.LineRange; // packageimport
import org.eclipse.jface.text.source.IAnnotationAccessExtension2; // packageimport
import org.eclipse.jface.text.source.VerticalRuler; // packageimport
import org.eclipse.jface.text.source.JFaceTextMessages; // packageimport
import org.eclipse.jface.text.source.IOverviewRuler; // packageimport
import org.eclipse.jface.text.source.Annotation; // packageimport
import org.eclipse.jface.text.source.IVerticalRulerListener; // packageimport
import org.eclipse.jface.text.source.ISourceViewerExtension4; // packageimport
import org.eclipse.jface.text.source.AnnotationPainter; // packageimport
import org.eclipse.jface.text.source.IAnnotationHoverExtension2; // packageimport
import org.eclipse.jface.text.source.OverviewRuler; // packageimport
import org.eclipse.jface.text.source.OverviewRulerHoverManager; // packageimport


import java.lang.all;
import java.util.Iterator;

import org.eclipse.jface.text.BadLocationException;


/**
 * Protocol that allows direct access to line information. Usually, implementations will also
 * implement <code>IAnnotationModel</code>, which only allows <code>Iterator</code> based access
 * to annotations.
 * <p>
 * <code>ILineDiffer</code> also allows to revert any lines to their original
 * contents as defined by the quick diff reference used by the receiver.
 * </p>
 * <p>
 * This interface may be implemented by clients.
 * </p>
 * <p>
 * In order to provide backward compatibility for clients of <code>ILineDiffer</code>, extension
 * interfaces are used to provide a means of evolution. The following extension interface
 * exists:
 * <ul>
 * <li> {@link ILineDifferExtension} (since version 3.1): introducing the concept
 *      suspending and resuming an <code>ILineDiffer</code>.</li>
 * <li> {@link ILineDifferExtension2} (since version 3.3): allowing to query the suspension state
 * of an <code>ILineDiffer</code>.</li>
 * </ul>
 * </p>
 *
 * @since 3.0
 */
public interface ILineDiffer {

    /**
     * Determines the line state for line <code>line</code> in the targeted document.
     *
     * @param line the line to get diff information for
     * @return the line information object for <code>line</code> or <code>null</code> if none
     */
    ILineDiffInfo getLineInfo(int line);

    /**
     * Reverts a single changed line to its original state, not touching any lines that
     * are deleted at its borders.
     *
     * @param line the line number of the line to be restored.
     * @throws BadLocationException if <code>line</code> is out of bounds.
     */
    void revertLine(int line) ;

    /**
     * Reverts a block of modified / added lines to their original state, including any deleted
     * lines inside the block or at its borders. A block is considered to be a range of modified
     * (e.g. changed, or added) lines.
     *
     * @param line any line in the block to be reverted.
     * @throws BadLocationException if <code>line</code> is out of bounds.
     */
    void revertBlock(int line) ;

    /**
     * Reverts a range of lines to their original state, including any deleted
     * lines inside the block or at its borders.
     *
     * @param line any line in the block to be reverted.
     * @param nLines the number of lines to be reverted, must be &gt; 0.
     * @throws BadLocationException if <code>line</code> is out of bounds.
     */
    void revertSelection(int line, int nLines) ;

    /**
     * Restores the deleted lines after <code>line</code>.
     *
     * @param line the deleted lines following this line number are restored.
     * @return the number of restored lines.
     * @throws BadLocationException if <code>line</code> is out of bounds.
     */
    int restoreAfterLine(int line) ;
}
