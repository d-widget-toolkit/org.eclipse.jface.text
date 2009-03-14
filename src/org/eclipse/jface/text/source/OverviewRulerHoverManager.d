/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module org.eclipse.jface.text.source.OverviewRulerHoverManager;

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


import java.lang.all;
import java.util.Set;



import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.ScrollBar;
import org.eclipse.jface.text.IInformationControlCreator;

/**
 * This manager controls the layout, content, and visibility of an information
 * control in reaction to mouse hover events issued by the overview ruler of a
 * source viewer.
 *
 * @since 2.1
 */
class OverviewRulerHoverManager : AnnotationBarHoverManager {

    /**
     * Creates an overview hover manager with the given parameters. In addition,
     * the hovers anchor is RIGHT and the margin is 5 points to the right.
     *
     * @param ruler the overview ruler this manager connects to
     * @param sourceViewer the source viewer this manager connects to
     * @param annotationHover the annotation hover providing the information to be displayed
     * @param creator the information control creator
     */
    public this(IOverviewRuler ruler, ISourceViewer sourceViewer, IAnnotationHover annotationHover, IInformationControlCreator creator) {
        super(ruler, sourceViewer, annotationHover, creator);
        setAnchor(ANCHOR_LEFT);
        StyledText textWidget= sourceViewer.getTextWidget();
        if (textWidget !is null) {
            ScrollBar verticalBar= textWidget.getVerticalBar();
            if (verticalBar !is null)
                setMargins(verticalBar.getSize().x, 5);
        }
    }

    /*
     * @see AbstractHoverInformationControlManager#computeInformation()
     */
    protected void computeInformation() {
        Point location= getHoverEventLocation();
        int line= getVerticalRulerInfo().toDocumentLineNumber(location.y);
        IAnnotationHover hover= getAnnotationHover();
        
        IInformationControlCreator controlCreator= null;
        if ( cast(IAnnotationHoverExtension)hover )
            controlCreator= (cast(IAnnotationHoverExtension)hover).getHoverControlCreator();
        setCustomInformationControlCreator(controlCreator);
        
        setInformation(hover.getHoverInfo(getSourceViewer(), line), computeArea(location.y));
    }

    /**
     * Determines graphical area covered for which the hover is valid.
     *
     * @param y y-coordinate in the vertical ruler
     * @return the graphical extend where the hover is valid
     */
    private Rectangle computeArea(int y) {
        // This is OK (see constructor)
        IOverviewRuler overviewRuler= cast(IOverviewRuler) getVerticalRulerInfo();

        int hover_height= overviewRuler.getAnnotationHeight();
        int hover_width= getVerticalRulerInfo().getControl().getSize().x;

        // Calculate y-coordinate for hover
        int hover_y= y;
        bool hasAnnotation= true;
        while (hasAnnotation && hover_y > y - hover_height) {
            hover_y--;
            hasAnnotation= overviewRuler.hasAnnotation(hover_y);
        }
        hover_y++;

        return new Rectangle(0, hover_y, hover_width, hover_height);
    }
}
