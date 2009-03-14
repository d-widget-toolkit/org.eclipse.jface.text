/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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


module org.eclipse.jface.text.source.IVerticalRulerInfo;

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
import org.eclipse.jface.text.source.ILineDiffer; // packageimport
import org.eclipse.jface.text.source.AnnotationModelEvent; // packageimport
import org.eclipse.jface.text.source.AnnotationColumn; // packageimport
import org.eclipse.jface.text.source.AnnotationRulerColumn; // packageimport
import org.eclipse.jface.text.source.IAnnotationHoverExtension; // packageimport
import org.eclipse.jface.text.source.AbstractRulerColumn; // packageimport
import org.eclipse.jface.text.source.ISourceViewerExtension; // packageimport
import org.eclipse.jface.text.source.AnnotationMap; // packageimport
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


import org.eclipse.swt.widgets.Control;


/**
 * A vertical ruler is a visual component which may serve text viewers as an
 * annotation presentation area. The vertical ruler info provides interested
 * clients with the mapping and interaction aspect of the vertical ruler. This
 * covers the mapping between coordinates of the ruler's control and line
 * numbers based on the connected text viewer's document.
 *
 * In order to provide backward compatibility for clients of
 * <code>IVerticalRulerInfo</code>, extension interfaces are used as a means
 * of evolution. The following extension interfaces exist:
 * <ul>
 * <li>{@link org.eclipse.jface.text.source.IVerticalRulerInfoExtension} since
 * version 3.0 allowing custom annotation hovers and specific annotation models.
 * </li>
 * </ul>
 *
 * @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension
 * @since 2.0
 */
public interface IVerticalRulerInfo {

    /**
     * Returns the ruler's SWT control.
     *
     * @return the ruler's SWT control
     */
    Control getControl();

    /**
     * Returns the line number of the last mouse button activity.
     * Based on the input document of the connected text viewer.
     *
     * @return the line number of the last mouse button activity or <code>-1</code> if 
     *          the last mouse activity does not correspond to a valid document line
     */
    int getLineOfLastMouseButtonActivity();

    /**
     * Translates a y-coordinate of the ruler's SWT control into
     * the according line number of the document of the connected text viewer.
     *
     * @param y_coordinate a y-coordinate of the ruler's SWT control
     * @return the line number of that coordinate or <code>-1</code> if that
     *          coordinate does not correspond to a valid document line
     */
    int toDocumentLineNumber(int y_coordinate);

    /**
     * Returns the width of this ruler's control.
     *
     * @return the width of this ruler's control
     */
    int getWidth();
}
