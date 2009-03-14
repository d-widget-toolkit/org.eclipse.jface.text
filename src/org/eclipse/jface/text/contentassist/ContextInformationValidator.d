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
module org.eclipse.jface.text.contentassist.ContextInformationValidator;

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
import org.eclipse.jface.text.contentassist.ContextInformation; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposalExtension3; // packageimport
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
import java.util.Set;

import org.eclipse.jface.text.ITextViewer;


/**
 * A default implementation of the <code>IContextInfomationValidator</code> interface.
 * This implementation determines whether the information is valid by asking the content
 * assist processor for all  context information objects for the current position. If the
 * currently displayed information is in the result set, the context information is
 * considered valid.
 */
public final class ContextInformationValidator : IContextInformationValidator {

    /** The content assist processor. */
    private IContentAssistProcessor fProcessor;
    /** The context information to be validated. */
    private IContextInformation fContextInformation;
    /** The associated text viewer. */
    private ITextViewer fViewer;

    /**
     * Creates a new context information validator which is ready to be installed on
     * a particular context information.
     *
     * @param processor the processor to be used for validation
     */
    public this(IContentAssistProcessor processor) {
        fProcessor= processor;
    }

    /*
     * @see IContextInformationValidator#install(IContextInformation, ITextViewer, int)
     */
    public void install(IContextInformation contextInformation, ITextViewer viewer, int offset) {
        fContextInformation= contextInformation;
        fViewer= viewer;
    }

    /*
     * @see IContentAssistTipCloser#isContextInformationValid(int)
     */
    public bool isContextInformationValid(int offset) {
        IContextInformation[] infos= fProcessor.computeContextInformation(fViewer, offset);
        if (infos !is null && infos.length > 0) {
            for (int i= 0; i < infos.length; i++)
                if (fContextInformation==/+eq+/infos[i])
                    return true;
        }
        return false;
    }
}
