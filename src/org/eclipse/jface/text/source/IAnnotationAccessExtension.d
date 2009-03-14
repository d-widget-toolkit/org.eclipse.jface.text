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
module org.eclipse.jface.text.source.IAnnotationAccessExtension;

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

import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.Canvas;

/**
 * Extension interface for {@link org.eclipse.jface.text.source.IAnnotationAccess}.<p>
 * This interface replaces the methods of <code>IAnnotationAccess</code>.<p>
 * This interface provides
 * <ul>
 * <li> a label for the annotation type of a given annotation</li>
 * <li> the paint layer of a given annotation</li>
 * <li> means to paint a given annotation</li>
 * <li> information about the type hierarchy of the annotation type of a given annotation</li>
 * <ul>.
 *
 * @see org.eclipse.jface.text.source.IAnnotationAccess
 * @since 3.0
 */
public interface IAnnotationAccessExtension {

    /**
     * The default annotation layer.
     */
    static const int DEFAULT_LAYER= IAnnotationPresentation.DEFAULT_LAYER;

    /**
     * Returns the label for the given annotation's type.
     *
     * @param annotation the annotation
     * @return the label the given annotation's type or <code>null</code> if no such label exists
     */
    String getTypeLabel(Annotation annotation);

    /**
     * Returns the layer for given annotation. Annotations are considered
     * being located at layers and are considered being painted starting with
     * layer 0 upwards. Thus an annotation at layer 5 will be drawn on top of
     * all co-located annotations at the layers 4 - 0.
     *
     * @param annotation the annotation
     * @return the layer of the given annotation
     */
    int getLayer(Annotation annotation);

    /**
     * Draws a graphical representation of the given annotation within the given bounds.
     * <p>
     * <em>Note that this method is not used when drawing annotations on the editor's
     * text widget. This is handled trough a {@link org.eclipse.jface.text.source.AnnotationPainter.IDrawingStrategy}.</em>
     * </p>
     * @param annotation the given annotation
     * @param gc the drawing GC
     * @param canvas the canvas to draw on
     * @param bounds the bounds inside the canvas to draw on
     */
    void paint(Annotation annotation, GC gc, Canvas canvas, Rectangle bounds);

    /**
     * Returns <code>true</code> if painting <code>annotation</code> will produce something
     * meaningful, <code>false</code> if not. E.g. if no image is available.
     * <p>
     * <em>Note that this method is not used when drawing annotations on the editor's
     * text widget. This is handled trough a {@link org.eclipse.jface.text.source.AnnotationPainter.IDrawingStrategy}.</em>
     * </p>
     * @param annotation the annotation to check whether it can be painted
     * @return <code>true</code> if painting <code>annotation</code> will succeed
     */
    bool isPaintable(Annotation annotation);

    /**
     * Returns <code>true</code> if the given annotation is of the given type
     * or <code>false</code> otherwise.
     *
     * @param annotationType the annotation type
     * @param potentialSupertype the potential super annotation type
     * @return <code>true</code> if annotation type is a sub-type of the potential annotation super type
     */
    bool isSubtype(Object annotationType, Object potentialSupertype);

    /**
     * Returns the list of super types for the given annotation type. This does not include the type
     * itself. The index in the array of super types indicates the length of the path in the hierarchy
     * graph to the given annotation type.
     *
     * @param annotationType the annotation type to check
     * @return the super types for the given annotation type
     */
    Object[] getSupertypes(Object annotationType);
}
