/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
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
module org.eclipse.jface.text.hyperlink.IHyperlinkDetectorExtension;

import org.eclipse.jface.text.hyperlink.IHyperlinkPresenterExtension; // packageimport
import org.eclipse.jface.text.hyperlink.MultipleHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.HyperlinkManager; // packageimport
import org.eclipse.jface.text.hyperlink.URLHyperlink; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetectorExtension2; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.URLHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter; // packageimport
import org.eclipse.jface.text.hyperlink.AbstractHyperlinkDetector; // packageimport
import org.eclipse.jface.text.hyperlink.HyperlinkMessages; // packageimport
import org.eclipse.jface.text.hyperlink.IHyperlink; // packageimport


import java.lang.all;


/**
 * Extends {@link IHyperlinkDetector} with ability
 * to dispose a hyperlink detector.
 * <p>
 * Clients may implement this interface.
 * </p>
 * 
 * @since 3.3
 */
public interface IHyperlinkDetectorExtension {

    /**
     * Disposes this hyperlink detector.
     */
    void dispose();

}
