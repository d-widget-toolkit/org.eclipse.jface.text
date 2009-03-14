/*******************************************************************************
 * Copyright (c) 2006, 2007 IBM Corporation and others.
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
module org.eclipse.jface.text.revisions.IRevisionListener;

import org.eclipse.jface.text.revisions.IRevisionRulerColumnExtension; // packageimport
import org.eclipse.jface.text.revisions.RevisionRange; // packageimport
import org.eclipse.jface.text.revisions.IRevisionRulerColumn; // packageimport
import org.eclipse.jface.text.revisions.RevisionEvent; // packageimport
import org.eclipse.jface.text.revisions.RevisionInformation; // packageimport
import org.eclipse.jface.text.revisions.Revision; // packageimport


import java.lang.all;


/** 
 * A listener which is notified when revision information changes.
 *
 * @see RevisionInformation
 * @see IRevisionRulerColumnExtension
 * @since 3.3
 */
public interface IRevisionListener {
    /**
     * Notifies the receiver that the revision information has been updated. This typically occurs
     * when revision information is being displayed in an editor and the annotated document is
     * modified.
     * 
     * @param e the revision event describing the change
     */
    void revisionInformationChanged(RevisionEvent e);
}
