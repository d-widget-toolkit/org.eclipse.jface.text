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
module org.eclipse.jface.text.revisions.RevisionRange;

import org.eclipse.jface.text.revisions.IRevisionListener; // packageimport
import org.eclipse.jface.text.revisions.IRevisionRulerColumnExtension; // packageimport
import org.eclipse.jface.text.revisions.IRevisionRulerColumn; // packageimport
import org.eclipse.jface.text.revisions.RevisionEvent; // packageimport
import org.eclipse.jface.text.revisions.RevisionInformation; // packageimport
import org.eclipse.jface.text.revisions.Revision; // packageimport


import java.lang.all;

import org.eclipse.core.runtime.Assert;
import org.eclipse.jface.text.source.ILineRange;


/**
 * An unmodifiable line range that belongs to a {@link Revision}.
 *
 * @since 3.3
 * @noinstantiate This class is not intended to be instantiated by clients.
 */
public final class RevisionRange : ILineRange {
    private const Revision fRevision;
    private const int fStartLine;
    private const int fNumberOfLines;

    this(Revision revision, ILineRange range) {
        Assert.isLegal(revision !is null);
        fRevision= revision;
        fStartLine= range.getStartLine();
        fNumberOfLines= range.getNumberOfLines();
    }

    /**
     * Returns the revision that this range belongs to.
     *
     * @return the revision that this range belongs to
     */
    public Revision getRevision() {
        return fRevision;
    }

    /*
     * @see org.eclipse.jface.text.source.ILineRange#getStartLine()
     */
    public int getStartLine() {
        return fStartLine;
    }

    /*
     * @see org.eclipse.jface.text.source.ILineRange#getNumberOfLines()
     */
    public int getNumberOfLines() {
        return fNumberOfLines;
    }

    /*
     * @see java.lang.Object#toString()
     */
    public override String toString() {
        return Format("RevisionRange [{}, [{}+{})]", fRevision.toString(), getStartLine(), getNumberOfLines()); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$
    }
}
