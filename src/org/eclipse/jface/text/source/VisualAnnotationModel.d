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
module org.eclipse.jface.text.source.VisualAnnotationModel;

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
import java.util.ArrayList;
import java.util.Iterator;




import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.Position;



/**
 * Annotation model for visual annotations. Assume a viewer's input element is annotated with
 * some semantic annotation such as a breakpoint and that it is simultaneously shown in multiple
 * viewers. A source viewer, e.g., supports visual range indication for which it utilizes
 * annotations. The range indicating annotation is specific to the visual presentation
 * of the input element in this viewer and thus should only be visible in this viewer. The
 * breakpoints however are independent from the input element's presentation and thus should
 * be shown in all viewers in which the element is shown. As a viewer supports one vertical
 * ruler which is based on one annotation model, there must be a visual annotation model for
 * each viewer which all wrap the same element specific model annotation model.
 */
class VisualAnnotationModel : AnnotationModel , IAnnotationModelListener {

    /** The wrapped model annotation model */
    private IAnnotationModel fModel;

    /**
     * Constructs a visual annotation model which wraps the given
     * model based annotation model
     *
     * @param modelAnnotationModel the model based annotation model
     */
    public this(IAnnotationModel modelAnnotationModel) {
        fModel= modelAnnotationModel;
    }

    /**
     * Returns the visual annotation model's wrapped model based annotation model.
     *
     * @return the model based annotation model
     */
    public IAnnotationModel getModelAnnotationModel() {
        return fModel;
    }

    /*
     * @see IAnnotationModel#addAnnotationModelListener(IAnnotationModelListener)
     */
    public void addAnnotationModelListener(IAnnotationModelListener listener) {

        if (fModel !is null && fAnnotationModelListeners.isEmpty())
            fModel.addAnnotationModelListener(this);

        super.addAnnotationModelListener(listener);
    }

    /*
     * @see IAnnotationModel#connect(IDocument)
     */
    public void connect(IDocument document) {
        super.connect(document);
        if (fModel !is null)
            fModel.connect(document);
    }

    /*
     * @see IAnnotationModel#disconnect(IDocument)
     */
    public void disconnect(IDocument document) {
        super.disconnect(document);
        if (fModel !is null)
            fModel.disconnect(document);
    }

    /*
     * @see IAnnotationModel#getAnnotationIterator()
     */
    public Iterator getAnnotationIterator() {

        if (fModel is null)
            return super.getAnnotationIterator();

        ArrayList a= new ArrayList(20);

        Iterator e= fModel.getAnnotationIterator();
        while (e.hasNext())
            a.add(e.next());

        e= super.getAnnotationIterator();
        while (e.hasNext())
            a.add(e.next());

        return a.iterator();
    }

    /*
     * @see IAnnotationModel#getPosition(Annotation)
     */
    public Position getPosition(Annotation annotation) {

        Position p= cast(Position) getAnnotationMap().get(annotation);
        if (p !is null)
            return p;

        if (fModel !is null)
            return fModel.getPosition(annotation);

        return null;
    }

    /*
     * @see IAnnotationModelListener#modelChanged(IAnnotationModel)
     */
    public void modelChanged(IAnnotationModel model) {
        if (model is fModel) {
            Iterator iter= (new ArrayList(fAnnotationModelListeners)).iterator();
            while (iter.hasNext()) {
                IAnnotationModelListener l= cast(IAnnotationModelListener)iter.next();
                l.modelChanged(this);
            }
        }
    }

    /*
     * @see IAnnotationModel#removeAnnotationModelListener(IAnnotationModelListener)
     */
    public void removeAnnotationModelListener(IAnnotationModelListener listener) {
        super.removeAnnotationModelListener(listener);

        if (fModel !is null && fAnnotationModelListeners.isEmpty())
            fModel.removeAnnotationModelListener(this);
    }
}
