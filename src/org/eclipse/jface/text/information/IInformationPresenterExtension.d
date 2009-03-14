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
module org.eclipse.jface.text.information.IInformationPresenterExtension;

import org.eclipse.jface.text.information.InformationPresenter; // packageimport
import org.eclipse.jface.text.information.IInformationProvider; // packageimport
import org.eclipse.jface.text.information.IInformationProviderExtension; // packageimport
import org.eclipse.jface.text.information.IInformationProviderExtension2; // packageimport
import org.eclipse.jface.text.information.IInformationPresenter; // packageimport


import java.lang.all;

/**
 * Extends {@link org.eclipse.jface.text.information.IInformationPresenter} with
 * the ability to handle documents with multiple partitions.
 *
 * @see org.eclipse.jface.text.information.IInformationPresenter
 * 
 * @since 3.0
 */
public interface IInformationPresenterExtension {

    /**
     * Returns the document partitioning this information presenter is using.
     *
     * @return the document partitioning this information presenter is using
     */
    String getDocumentPartitioning();
}
