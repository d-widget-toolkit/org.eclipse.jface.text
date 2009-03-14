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
module org.eclipse.jface.text.source.projection.IProjectionListener;

import org.eclipse.jface.text.source.projection.ProjectionViewer; // packageimport
import org.eclipse.jface.text.source.projection.ProjectionSupport; // packageimport
import org.eclipse.jface.text.source.projection.IProjectionPosition; // packageimport
import org.eclipse.jface.text.source.projection.AnnotationBag; // packageimport
import org.eclipse.jface.text.source.projection.ProjectionSummary; // packageimport
import org.eclipse.jface.text.source.projection.ProjectionAnnotationHover; // packageimport
import org.eclipse.jface.text.source.projection.ProjectionRulerColumn; // packageimport
import org.eclipse.jface.text.source.projection.ProjectionAnnotationModel; // packageimport
import org.eclipse.jface.text.source.projection.SourceViewerInformationControl; // packageimport
import org.eclipse.jface.text.source.projection.ProjectionAnnotation; // packageimport


import java.lang.all;

/**
 * Implementers registered with a
 * {@link org.eclipse.jface.text.source.projection.ProjectionViewer} get
 * informed when the projection mode of the viewer gets enabled and when it gets
 * disabled.
 *
 * @since 3.0
 */
public interface IProjectionListener {

    /**
     * Tells this listener that projection has been enabled.
     */
    void projectionEnabled();

    /**
     * Tells this listener that projection has been disabled.
     */
    void projectionDisabled();
}
