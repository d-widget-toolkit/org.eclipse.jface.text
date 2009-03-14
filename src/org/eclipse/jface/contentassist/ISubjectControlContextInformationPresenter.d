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
module org.eclipse.jface.contentassist.ISubjectControlContextInformationPresenter;

import java.lang.all;
import java.util.Set;

import org.eclipse.jface.text.contentassist.IContextInformation;
import org.eclipse.jface.text.contentassist.IContextInformationPresenter;
import org.eclipse.jface.contentassist.IContentAssistSubjectControl;

/**
 * Extends {@link org.eclipse.jface.text.contentassist.IContextInformationPresenter} to
 * allow to install a content assistant on the given
 * {@linkplain org.eclipse.jface.contentassist.IContentAssistSubjectControl content assist subject control}.
 *
 * @since 3.0
 * @deprecated As of 3.2, replaced by Platform UI's field assist support
 */
public interface ISubjectControlContextInformationPresenter : IContextInformationPresenter {

    /**
     * Installs this presenter for the given context information.
     *
     * @param info the context information which this presenter should style
     * @param contentAssistSubjectControl the content assist subject control
     * @param offset the document offset for which the information has been computed
     */
    void install(IContextInformation info, IContentAssistSubjectControl contentAssistSubjectControl, int offset);
}
