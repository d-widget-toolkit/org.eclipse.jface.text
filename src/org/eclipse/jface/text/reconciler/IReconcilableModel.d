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
module org.eclipse.jface.text.reconciler.IReconcilableModel;

import org.eclipse.jface.text.reconciler.IReconciler; // packageimport
import org.eclipse.jface.text.reconciler.DirtyRegionQueue; // packageimport
import org.eclipse.jface.text.reconciler.IReconcilingStrategy; // packageimport
import org.eclipse.jface.text.reconciler.AbstractReconcileStep; // packageimport
import org.eclipse.jface.text.reconciler.IReconcilingStrategyExtension; // packageimport
import org.eclipse.jface.text.reconciler.MonoReconciler; // packageimport
import org.eclipse.jface.text.reconciler.IReconcileStep; // packageimport
import org.eclipse.jface.text.reconciler.AbstractReconciler; // packageimport
import org.eclipse.jface.text.reconciler.Reconciler; // packageimport
import org.eclipse.jface.text.reconciler.DirtyRegion; // packageimport
import org.eclipse.jface.text.reconciler.IReconcileResult; // packageimport
import org.eclipse.jface.text.reconciler.IReconcilerExtension; // packageimport


import java.lang.all;
import java.util.Set;


/**
 * Tagging interface for a model that can get reconciled during a
 * {@linkplain org.eclipse.jface.text.reconciler.IReconcileStep reconcile step}.
 * <p>
 * This model is not directly used by a {@linkplain org.eclipse.jface.text.reconciler.IReconciler reconciler}
 * or a {@linkplain org.eclipse.jface.text.reconciler.IReconcilingStrategy reconciling strategy}.
 * </p>
 *
 * <p>
 * This interface must be implemented by clients that want to use one of
 * their models as a reconcile step's input model.
 * </p>
 *
 * @see org.eclipse.jface.text.reconciler.IReconcileStep#setInputModel(IReconcilableModel)
 * @since 3.0
 */
public interface IReconcilableModel {

}
