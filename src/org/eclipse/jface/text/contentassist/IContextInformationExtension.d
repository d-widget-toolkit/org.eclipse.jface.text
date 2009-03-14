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
module org.eclipse.jface.text.contentassist.IContextInformationExtension;

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
import org.eclipse.jface.text.contentassist.ContextInformationValidator; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposal; // packageimport
import org.eclipse.jface.text.contentassist.IContentAssistProcessor; // packageimport
import org.eclipse.jface.text.contentassist.AdditionalInfoController; // packageimport
import org.eclipse.jface.text.contentassist.IContextInformationPresenter; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionProposalExtension4; // packageimport
import org.eclipse.jface.text.contentassist.ICompletionListenerExtension; // packageimport
import org.eclipse.jface.text.contentassist.ContextInformationPopup; // packageimport
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


/**
 * Extends {@link org.eclipse.jface.text.contentassist.IContextInformation} with
 * the ability to freely position the context information.
 *
 * @since 2.0
 */
public interface IContextInformationExtension {

    /**
     * Returns the start offset of the range for which this context
     * information is valid or <code>-1</code> if unknown.
     * 
     * @return the start offset of the range for which this context
     *         information is valid
     */
    int getContextInformationPosition();
}
