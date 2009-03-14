/*******************************************************************************
 * Copyright (c) 2006, 2007 IBM Corporation and others.
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
module org.eclipse.jface.text.source.DefaultAnnotationHover;

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
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;






import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.Position;
import org.eclipse.jface.text.source.projection.AnnotationBag;

/**
 * Standard implementation of {@link org.eclipse.jface.text.source.IAnnotationHover}.
 *
 * @since 3.2
 */
public class DefaultAnnotationHover : IAnnotationHover {


    /**
     * Tells whether the line number should be shown when no annotation is found
     * under the cursor.
     *
     * @since 3.4
     */
    private bool fShowLineNumber;

    /**
     * Creates a new default annotation hover.
     *
     * @since 3.4
     */
    public this() {
        this(false);
    }

    /**
     * Creates a new default annotation hover.
     *
     * @param showLineNumber <code>true</code> if the line number should be shown when no annotation is found
     * @since 3.4
     */
    public this(bool showLineNumber) {
        fShowLineNumber= showLineNumber;
    }

    /*
     * @see org.eclipse.jface.text.source.IAnnotationHover#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer, int)
     */
    public String getHoverInfo(ISourceViewer sourceViewer, int lineNumber) {
        List javaAnnotations= getAnnotationsForLine(sourceViewer, lineNumber);
        if (javaAnnotations !is null) {

            if (javaAnnotations.size() is 1) {

                // optimization
                Annotation annotation= cast(Annotation) javaAnnotations.get(0);
                String message= annotation.getText();
                if (message !is null && message.trim().length() > 0)
                    return formatSingleMessage(message);

            } else {

                List messages= new ArrayList();

                Iterator e= javaAnnotations.iterator();
                while (e.hasNext()) {
                    Annotation annotation= cast(Annotation) e.next();
                    String message= annotation.getText();
                    if (message !is null && message.trim().length() > 0)
                        messages.add(message.trim());
                }

                if (messages.size() is 1)
                    return formatSingleMessage(stringcast(messages.get(0)));

                if (messages.size() > 1)
                    return formatMultipleMessages(messages);
            }
        }

        if (fShowLineNumber && lineNumber > -1)
            return JFaceTextMessages.getFormattedString("DefaultAnnotationHover.lineNumber", stringcast(Integer.toString(lineNumber + 1)) ); //$NON-NLS-1$

        return null;
    }

    /**
     * Tells whether the annotation should be included in
     * the computation.
     *
     * @param annotation the annotation to test
     * @return <code>true</code> if the annotation is included in the computation
     */
    protected bool isIncluded(Annotation annotation) {
        return true;
    }

    /**
     * Hook method to format the given single message.
     * <p>
     * Subclasses can change this to create a different
     * format like HTML.
     * </p>
     *
     * @param message the message to format
     * @return the formatted message
     */
    protected String formatSingleMessage(String message) {
        return message;
    }

    /**
     * Hook method to formats the given messages.
     * <p>
     * Subclasses can change this to create a different
     * format like HTML.
     * </p>
     *
     * @param messages the messages to format
     * @return the formatted message
     */
    protected String formatMultipleMessages(List messages) {
        StringBuffer buffer= new StringBuffer();
        buffer.append(JFaceTextMessages.getString("DefaultAnnotationHover.multipleMarkers")); //$NON-NLS-1$

        Iterator e= messages.iterator();
        while (e.hasNext()) {
            buffer.append('\n');
            String listItemText= stringcast( e.next());
            buffer.append(JFaceTextMessages.getFormattedString("DefaultAnnotationHover.listItem", stringcast(listItemText ))); //$NON-NLS-1$
        }
        return buffer.toString();
    }

    private bool isRulerLine(Position position, IDocument document, int line) {
        if (position.getOffset() > -1 && position.getLength() > -1) {
            try {
                return line is document.getLineOfOffset(position.getOffset());
            } catch (BadLocationException x) {
            }
        }
        return false;
    }

    private IAnnotationModel getAnnotationModel(ISourceViewer viewer) {
        if ( cast(ISourceViewerExtension2)viewer ) {
            ISourceViewerExtension2 extension= cast(ISourceViewerExtension2) viewer;
            return extension.getVisualAnnotationModel();
        }
        return viewer.getAnnotationModel();
    }

    private bool isDuplicateAnnotation(Map messagesAtPosition, Position position, String message) {
        if (messagesAtPosition.containsKey(position)) {
            Object value= messagesAtPosition.get(position);
            if (message==/++/stringcast(value))
                return true;

            if ( cast(List)value ) {
                List messages= cast(List)value;
                if  (messages.contains(message))
                    return true;

                messages.add(message);
            } else {
                ArrayList messages= new ArrayList();
                messages.add(value);
                messages.add(message);
                messagesAtPosition.put(position, messages);
            }
        } else
            messagesAtPosition.put(position, message);
        return false;
    }

    private bool includeAnnotation(Annotation annotation, Position position, HashMap messagesAtPosition) {
        if (!isIncluded(annotation))
            return false;

        String text= annotation.getText();
        return (text !is null && !isDuplicateAnnotation(messagesAtPosition, position, text));
    }

    private List getAnnotationsForLine(ISourceViewer viewer, int line) {
        IAnnotationModel model= getAnnotationModel(viewer);
        if (model is null)
            return null;

        IDocument document= viewer.getDocument();
        List javaAnnotations= new ArrayList();
        HashMap messagesAtPosition= new HashMap();
        Iterator iterator= model.getAnnotationIterator();

        while (iterator.hasNext()) {
            Annotation annotation= cast(Annotation) iterator.next();

            Position position= model.getPosition(annotation);
            if (position is null)
                continue;

            if (!isRulerLine(position, document, line))
                continue;

            if ( cast(AnnotationBag)annotation ) {
                AnnotationBag bag= cast(AnnotationBag) annotation;
                Iterator e= bag.iterator();
                while (e.hasNext()) {
                    annotation= cast(Annotation) e.next();
                    position= model.getPosition(annotation);
                    if (position !is null && includeAnnotation(annotation, position, messagesAtPosition))
                        javaAnnotations.add(annotation);
                }
                continue;
            }

            if (includeAnnotation(annotation, position, messagesAtPosition))
                javaAnnotations.add(annotation);
        }

        return javaAnnotations;
    }
}
