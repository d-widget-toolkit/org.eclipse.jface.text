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
module org.eclipse.jface.text.contentassist.ContextInformation;

import org.eclipse.jface.text.contentassist.ContentAssistEvent; // packageimport
import org.eclipse.jface.text.contentassist.Helper; // packageimport
import org.eclipse.jface.text.contentassist.PopupCloser; // packageimport
import org.eclipse.jface.text.contentassist.IContentAssistant; // packageimport
import org.eclipse.jface.text.contentassist.CompletionProposal; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposalExtension5; // packageimport
import org.eclipse.jface.text.contentassist.IContextInformationValidator; // packageimport
import org.eclipse.jface.text.contentassist.IContentAssistListener; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposalExtension6; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionListener; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposalExtension2; // packageimport
import org.eclipse.jface.text.contentassist.IContentAssistantExtension4; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposalExtension3; // packageimport
import org.eclipse.jface.text.contentassist.ContextInformationValidator; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposal; // packageimport
import org.eclipse.jface.text.contentassist.IContentAssistProcessor; // packageimport
import org.eclipse.jface.text.contentassist.AdditionalInfoController; // packageimport
import org.eclipse.jface.text.contentassist.IContextInformationPresenter; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposalExtension4; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionListenerExtension; // packageimport
import org.eclipse.jface.text.contentassist.ContextInformationPopup; // packageimport
import org.eclipse.jface.text.contentassist.IContextInformationExtension; // packageimport
import org.eclipse.jface.text.contentassist.IContentAssistantExtension2; // packageimport
import org.eclipse.jface.text.contentassist.ContentAssistSubjectControlAdapter; // packageimport
import org.eclipse.jface.text.contentassist.CompletionProposalPopup; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposalExtension; // packageimport
import org.eclipse.jface.text.contentassist.IContextInformation; // packageimport
import org.eclipse.jface.text.contentassist.IContentAssistantExtension3; // packageimport
import org.eclipse.jface.text.contentassist.ContentAssistant; // packageimport
import org.eclipse.jface.text.contentassist.IContentAssistantExtension; // packageimport
import org.eclipse.jface.text.contentassist.JFaceTextMessages; // packageimport


import java.lang.all;



import org.eclipse.swt.graphics.Image;
import org.eclipse.core.runtime.Assert;



/**
 * A default implementation of the <code>IContextInformation</code> interface.
 */
public final class ContextInformation : IContextInformation {

    /** The name of the context. */
    private const String fContextDisplayString;
    /** The information to be displayed. */
    private const String fInformationDisplayString;
    /** The image to be displayed. */
    private const Image fImage;

    /**
     * Creates a new context information without an image.
     *
     * @param contextDisplayString the string to be used when presenting the context
     * @param informationDisplayString the string to be displayed when presenting the context information
     */
    public this(String contextDisplayString, String informationDisplayString) {
        this(null, contextDisplayString, informationDisplayString);
    }

    /**
     * Creates a new context information with an image.
     *
     * @param image the image to display when presenting the context information
     * @param contextDisplayString the string to be used when presenting the context
     * @param informationDisplayString the string to be displayed when presenting the context information,
     *      may not be <code>null</code>
     */
    public this(Image image, String contextDisplayString, String informationDisplayString) {

        Assert.isNotNull(informationDisplayString);

        fImage= image;
        fContextDisplayString= contextDisplayString;
        fInformationDisplayString= informationDisplayString;
    }

    /*
     * @see IContextInformation#equals(Object)
     */
    public bool equals(Object object) {
        if ( cast(IContextInformation)object ) {
            IContextInformation contextInformation= cast(IContextInformation) object;
            bool equals= fInformationDisplayString.equalsIgnoreCase(contextInformation.getInformationDisplayString());
            if (fContextDisplayString !is null)
                equals= equals && fContextDisplayString.equalsIgnoreCase(contextInformation.getContextDisplayString());
            return equals;
        }
        return false;
    }

    /*
     * @see java.lang.Object#hashCode()
     * @since 3.1
     */
    public override hash_t toHash() {
        int low= fContextDisplayString !is null ? .toHash(fContextDisplayString) : 0;
        return (.toHash(fInformationDisplayString) << 16) | low;
    }

    /*
     * @see IContextInformation#getInformationDisplayString()
     */
    public String getInformationDisplayString() {
        return fInformationDisplayString;
    }

    /*
     * @see IContextInformation#getImage()
     */
    public Image getImage() {
        return fImage;
    }

    /*
     * @see IContextInformation#getContextDisplayString()
     */
    public String getContextDisplayString() {
        if (fContextDisplayString !is null)
            return fContextDisplayString;
        return fInformationDisplayString;
    }
}
