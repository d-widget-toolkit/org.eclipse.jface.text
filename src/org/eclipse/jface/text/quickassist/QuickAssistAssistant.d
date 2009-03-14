/*******************************************************************************
 * Copyright (c) 2006, 2008 IBM Corporation and others.
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
module org.eclipse.jface.text.quickassist.QuickAssistAssistant;

import org.eclipse.jface.text.quickassist.IQuickAssistAssistant; // packageimport
import org.eclipse.jface.text.quickassist.IQuickAssistAssistantExtension; // packageimport
import org.eclipse.jface.text.quickassist.IQuickAssistInvocationContext; // packageimport
import org.eclipse.jface.text.quickassist.IQuickFixableAnnotation; // packageimport
import org.eclipse.jface.text.quickassist.IQuickAssistProcessor; // packageimport


import java.lang.all;
import java.util.Set;




import org.eclipse.swt.graphics.Color;
import org.eclipse.core.commands.IHandler;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IInformationControlCreator;
import org.eclipse.jface.text.ITextViewer;
import org.eclipse.jface.text.contentassist.ContentAssistant;
import org.eclipse.jface.text.contentassist.ICompletionListener;
import org.eclipse.jface.text.contentassist.ICompletionProposal;
import org.eclipse.jface.text.contentassist.IContentAssistProcessor;
import org.eclipse.jface.text.contentassist.IContextInformation;
import org.eclipse.jface.text.contentassist.IContextInformationValidator;
import org.eclipse.jface.text.source.Annotation;
import org.eclipse.jface.text.source.ISourceViewer;
import org.eclipse.jface.text.source.TextInvocationContext;


/**
 * Default implementation of <code>IQuickAssistAssistant</code>.
 *
 * @since 3.2
 */
public class QuickAssistAssistant : IQuickAssistAssistant, IQuickAssistAssistantExtension {


    private static final class QuickAssistAssistantImpl : ContentAssistant {
        /*
         * @see org.eclipse.jface.text.contentassist.ContentAssistant#possibleCompletionsClosed()
         */
        public void possibleCompletionsClosed() {
            super.possibleCompletionsClosed();
        }

        /*
         * @see org.eclipse.jface.text.contentassist.ContentAssistant#hide()
         * @since 3.4
         */
        protected void hide() {
            super.hide();
        }
    }


    private static final class ContentAssistProcessor : IContentAssistProcessor {

        private IQuickAssistProcessor fQuickAssistProcessor;

        this(IQuickAssistProcessor processor) {
            fQuickAssistProcessor= processor;
        }

        /*
         * @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#computeCompletionProposals(org.eclipse.jface.text.ITextViewer, int)
         */
        public ICompletionProposal[] computeCompletionProposals(ITextViewer viewer, int offset) {
            // panic code - should not happen
            if (!( cast(ISourceViewer)viewer ))
                return null;

            return fQuickAssistProcessor.computeQuickAssistProposals(new TextInvocationContext(cast(ISourceViewer)viewer, offset, -1));
        }

        /*
         * @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#computeContextInformation(org.eclipse.jface.text.ITextViewer, int)
         */
        public IContextInformation[] computeContextInformation(ITextViewer viewer, int offset) {
            return null;
        }

        /*
         * @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#getCompletionProposalAutoActivationCharacters()
         */
        public char[] getCompletionProposalAutoActivationCharacters() {
            return null;
        }

        /*
         * @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#getContextInformationAutoActivationCharacters()
         */
        public char[] getContextInformationAutoActivationCharacters() {
            return null;
        }

        /*
         * @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#getErrorMessage()
         */
        public String getErrorMessage() {
            return null;
        }

        /*
         * @see org.eclipse.jface.text.contentassist.IContentAssistProcessor#getContextInformationValidator()
         */
        public IContextInformationValidator getContextInformationValidator() {
            return null;
        }

    }

    private QuickAssistAssistantImpl fQuickAssistAssistantImpl;
    private IQuickAssistProcessor fQuickAssistProcessor;

    public this() {
        fQuickAssistAssistantImpl= new QuickAssistAssistantImpl();
        fQuickAssistAssistantImpl.enableAutoActivation(false);
        fQuickAssistAssistantImpl.enableAutoInsert(false);
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#showPossibleQuickAssists()
     */
    public String showPossibleQuickAssists() {
        return fQuickAssistAssistantImpl.showPossibleCompletions();
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#getQuickAssistProcessor(java.lang.String)
     */
    public IQuickAssistProcessor getQuickAssistProcessor() {
        return fQuickAssistProcessor;
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setQuickAssistProcessor(org.eclipse.jface.text.quickassist.IQuickAssistProcessor)
     */
    public void setQuickAssistProcessor(IQuickAssistProcessor processor) {
        fQuickAssistProcessor= processor;
        fQuickAssistAssistantImpl.setDocumentPartitioning("__" ~ this.classinfo.name ~ "_partitioning"); //$NON-NLS-1$ //$NON-NLS-2$
        fQuickAssistAssistantImpl.setContentAssistProcessor(new ContentAssistProcessor(processor), IDocument.DEFAULT_CONTENT_TYPE);
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#canFix(org.eclipse.jface.text.source.Annotation)
     */
    public bool canFix(Annotation annotation) {
        return fQuickAssistProcessor !is null && fQuickAssistProcessor.canFix(annotation);
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#canAssist(org.eclipse.jface.text.quickassist.IQuickAssistInvocationContext)
     */
    public bool canAssist(IQuickAssistInvocationContext invocationContext) {
        return fQuickAssistProcessor !is null && fQuickAssistProcessor.canAssist(invocationContext);
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#install(org.eclipse.jface.text.ITextViewer)
     */
    public void install(ISourceViewer sourceViewer) {
        fQuickAssistAssistantImpl.install(sourceViewer);
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setInformationControlCreator(org.eclipse.jface.text.IInformationControlCreator)
     */
    public void setInformationControlCreator(IInformationControlCreator creator) {
        fQuickAssistAssistantImpl.setInformationControlCreator(creator);
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#uninstall()
     */
    public void uninstall() {
        fQuickAssistAssistantImpl.uninstall();
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setProposalSelectorBackground(org.eclipse.swt.graphics.Color)
     */
    public void setProposalSelectorBackground(Color background) {
        fQuickAssistAssistantImpl.setProposalSelectorBackground(background);
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setProposalSelectorForeground(org.eclipse.swt.graphics.Color)
     */
    public void setProposalSelectorForeground(Color foreground) {
        fQuickAssistAssistantImpl.setProposalSelectorForeground(foreground);
    }

    /**
     * Callback to signal this quick assist assistant that the presentation of the
     * possible completions has been stopped.
     */
    protected void possibleCompletionsClosed() {
        fQuickAssistAssistantImpl.possibleCompletionsClosed();
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#addCompletionListener(org.eclipse.jface.text.contentassist.ICompletionListener)
     */
    public void addCompletionListener(ICompletionListener listener) {
        fQuickAssistAssistantImpl.addCompletionListener(listener);
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#removeCompletionListener(org.eclipse.jface.text.contentassist.ICompletionListener)
     */
    public void removeCompletionListener(ICompletionListener listener) {
        fQuickAssistAssistantImpl.removeCompletionListener(listener);
    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setStatusLineVisible(bool)
     */
    public void setStatusLineVisible(bool show) {
        fQuickAssistAssistantImpl.setStatusLineVisible(show);

    }

    /*
     * @see org.eclipse.jface.text.quickassist.IQuickAssistAssistant#setStatusMessage(java.lang.String)
     */
    public void setStatusMessage(String message) {
        fQuickAssistAssistantImpl.setStatusMessage(message);
    }

    /**
     * {@inheritDoc}
     *
     * @since 3.4
     */
    public final IHandler getHandler(String commandId) {
        return fQuickAssistAssistantImpl.getHandler(commandId);
    }

    /**
     * Hides any open pop-ups.
     *
     * @since 3.4
     */
    protected void hide() {
        fQuickAssistAssistantImpl.hide();
    }

    /**
     * {@inheritDoc}
     *
     * @since 3.4
     */
    public void enableColoredLabels(bool isEnabled) {
        fQuickAssistAssistantImpl.enableColoredLabels(isEnabled);
    }

}
