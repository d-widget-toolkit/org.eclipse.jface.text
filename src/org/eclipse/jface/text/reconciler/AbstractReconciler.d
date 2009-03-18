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
module org.eclipse.jface.text.reconciler.AbstractReconciler;

import org.eclipse.jface.text.reconciler.IReconciler; // packageimport
import org.eclipse.jface.text.reconciler.DirtyRegionQueue; // packageimport
import org.eclipse.jface.text.reconciler.IReconcilingStrategy; // packageimport
import org.eclipse.jface.text.reconciler.AbstractReconcileStep; // packageimport
import org.eclipse.jface.text.reconciler.IReconcilingStrategyExtension; // packageimport
import org.eclipse.jface.text.reconciler.MonoReconciler; // packageimport
import org.eclipse.jface.text.reconciler.IReconcileStep; // packageimport
import org.eclipse.jface.text.reconciler.Reconciler; // packageimport
import org.eclipse.jface.text.reconciler.IReconcilableModel; // packageimport
import org.eclipse.jface.text.reconciler.DirtyRegion; // packageimport
import org.eclipse.jface.text.reconciler.IReconcileResult; // packageimport
import org.eclipse.jface.text.reconciler.IReconcilerExtension; // packageimport


import java.lang.all;
import java.util.Set;
import java.lang.Thread;

import org.eclipse.core.runtime.Assert;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.jface.text.DocumentEvent;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IDocumentListener;
import org.eclipse.jface.text.ITextInputListener;
import org.eclipse.jface.text.ITextViewer;


/**
 * Abstract implementation of {@link IReconciler}. The reconciler
 * listens to input document changes as well as changes of
 * the input document of the text viewer it is installed on. Depending on
 * its configuration it manages the received change notifications in a
 * queue folding neighboring or overlapping changes together. The reconciler
 * processes the dirty regions as a background activity after having waited for further
 * changes for the configured duration of time. A reconciler is started using the
 * {@link #install(ITextViewer)} method.  As a first step {@link #initialProcess()} is
 * executed in the background. Then, the reconciling thread waits for changes that
 * need to be reconciled. A reconciler can be resumed by calling {@link #forceReconciling()}
 * independent from the existence of actual changes. This mechanism is for subclasses only.
 * It is the clients responsibility to stop a reconciler using its {@link #uninstall()}
 * method. Unstopped reconcilers do not free their resources.
 * <p>
 * It is subclass responsibility to specify how dirty regions are processed.
 * </p>
 *
 * @see org.eclipse.jface.text.IDocumentListener
 * @see org.eclipse.jface.text.ITextInputListener
 * @see org.eclipse.jface.text.reconciler.DirtyRegion
 * @since 2.0
 */
abstract public class AbstractReconciler : IReconciler {


    /**
     * Background thread for the reconciling activity.
     */
    class BackgroundThread {
        Thread thread;

        /** Has the reconciler been canceled. */
        private bool fCanceled= false;
        /** Has the reconciler been reset. */
        private bool fReset= false;
        /** Some changes need to be processed. */
        private bool fIsDirty= false;
        /** Is a reconciling strategy active. */
        private bool fIsActive= false;

        /**
         * Creates a new background thread. The thread
         * runs with minimal priority.
         *
         * @param name the thread's name
         */
        public this(String name) {
            thread = new Thread( &run );
            thread.setName( name );
            thread.setPriority( Thread.MIN_PRIORITY );
            thread.setDaemon(true);
        }

        public void start(){
            thread.start();
        }
        public bool isAlive(){
            return thread.isAlive();
        }
        public Thread getThread(){
            return thread;
        }
        /**
         * Returns whether a reconciling strategy is active right now.
         *
         * @return <code>true</code> if a activity is active
         */
        public bool isActive() {
            return fIsActive;
        }

        /**
         * Returns whether some changes need to be processed.
         *
         * @return <code>true</code> if changes wait to be processed
         * @since 3.0
         */
        public synchronized bool isDirty() {
            return fIsDirty;
        }

        /**
         * Cancels the background thread.
         */
        public void cancel() {
            fCanceled= true;
            IProgressMonitor pm= fProgressMonitor;
            if (pm !is null)
                pm.setCanceled(true);
            synchronized (fDirtyRegionQueue) {
                fDirtyRegionQueue.notifyAll();
            }
        }

        /**
         * Suspends the caller of this method until this background thread has
         * emptied the dirty region queue.
         */
        public void suspendCallerWhileDirty() {
            bool isDirty;
            do {
                synchronized (fDirtyRegionQueue) {
                    isDirty= fDirtyRegionQueue.getSize() > 0;
                    if (isDirty) {
                        try {
                            fDirtyRegionQueue.wait();
                        } catch (InterruptedException x) {
                        }
                    }
                }
            } while (isDirty);
        }

        /**
         * Reset the background thread as the text viewer has been changed,
         */
        public void reset() {

            if (fDelay > 0) {

                synchronized (this) {
                    fIsDirty= true;
                    fReset= true;
                }

            } else {

                synchronized (this) {
                    fIsDirty= true;
                }

                synchronized (fDirtyRegionQueue) {
                    fDirtyRegionQueue.notifyAll();
                }
            }

            reconcilerReset();
        }

        /**
         * The background activity. Waits until there is something in the
         * queue managing the changes that have been applied to the text viewer.
         * Removes the first change from the queue and process it.
         * <p>
         * Calls {@link AbstractReconciler#initialProcess()} on entrance.
         * </p>
         */
        public void run() {

            synchronized (fDirtyRegionQueue) {
                try {
                    fDirtyRegionQueue.wait(fDelay);
                } catch (InterruptedException x) {
                }
            }

            if (fCanceled)
                return;

            initialProcess();

            while (!fCanceled) {

                synchronized (fDirtyRegionQueue) {
                    try {
                        fDirtyRegionQueue.wait(fDelay);
                    } catch (InterruptedException x) {
                    }
                }

                if (fCanceled)
                    break;

                if (!isDirty())
                    continue;

                synchronized (this) {
                    if (fReset) {
                        fReset= false;
                        continue;
                    }
                }

                DirtyRegion r= null;
                synchronized (fDirtyRegionQueue) {
                    r= fDirtyRegionQueue.removeNextDirtyRegion();
                }

                fIsActive= true;

                fProgressMonitor.setCanceled(false);

                process(r);

                synchronized (fDirtyRegionQueue) {
                    if (0 is fDirtyRegionQueue.getSize()) {
                        synchronized (this) {
                            fIsDirty= fProgressMonitor.isCanceled();
                        }
                        fDirtyRegionQueue.notifyAll();
                    }
                }

                fIsActive= false;
            }
        }
    }

    /**
     * Internal document listener and text input listener.
     */
    class Listener : IDocumentListener, ITextInputListener {

        /*
         * @see IDocumentListener#documentAboutToBeChanged(DocumentEvent)
         */
        public void documentAboutToBeChanged(DocumentEvent e) {
        }

        /*
         * @see IDocumentListener#documentChanged(DocumentEvent)
         */
        public void documentChanged(DocumentEvent e) {

            if (!fThread.isDirty() && fThread.isAlive()) {
                if (!fIsAllowedToModifyDocument && Thread.currentThread() is fThread.getThread())
                    throw new UnsupportedOperationException("The reconciler thread is not allowed to modify the document"); //$NON-NLS-1$
                aboutToBeReconciled();
            }

            /*
             * The second OR condition handles the case when the document
             * gets changed while still inside initialProcess().
             */
            if (fThread.isActive() || fThread.isDirty() && fThread.isAlive())
                fProgressMonitor.setCanceled(true);

            if (fIsIncrementalReconciler)
                createDirtyRegion(e);

            fThread.reset();

        }

        /*
         * @see ITextInputListener#inputDocumentAboutToBeChanged(IDocument, IDocument)
         */
        public void inputDocumentAboutToBeChanged(IDocument oldInput, IDocument newInput) {

            if (oldInput is fDocument) {

                if (fDocument !is null)
                    fDocument.removeDocumentListener(this);

                if (fIsIncrementalReconciler) {
                    synchronized (fDirtyRegionQueue) {
                        fDirtyRegionQueue.purgeQueue();
                    }
                    if (fDocument !is null && fDocument.getLength() > 0 && fThread.isDirty() && fThread.isAlive()) {
                        DocumentEvent e= new DocumentEvent(fDocument, 0, fDocument.getLength(), ""); //$NON-NLS-1$
                        createDirtyRegion(e);
                        fThread.reset();
                        fThread.suspendCallerWhileDirty();
                    }
                }

                fDocument= null;
            }
        }

        /*
         * @see ITextInputListener#inputDocumentChanged(IDocument, IDocument)
         */
        public void inputDocumentChanged(IDocument oldInput, IDocument newInput) {

            fDocument= newInput;
            if (fDocument is null)
                return;


            reconcilerDocumentChanged(fDocument);

            fDocument.addDocumentListener(this);

            if (!fThread.isDirty())
                aboutToBeReconciled();

            startReconciling();
        }
    }

    /** Queue to manage the changes applied to the text viewer. */
    private DirtyRegionQueue fDirtyRegionQueue;
    /** The background thread. */
    private BackgroundThread fThread;
    /** Internal document and text input listener. */
    private Listener fListener;
    /** The background thread delay. */
    private int fDelay= 500;
    /** Are there incremental reconciling strategies? */
    private bool fIsIncrementalReconciler= true;
    /** The progress monitor used by this reconciler. */
    private IProgressMonitor fProgressMonitor;
    /**
     * Tells whether this reconciler is allowed to modify the document.
     * @since 3.2
     */
    private bool fIsAllowedToModifyDocument= true;


    /** The text viewer's document. */
    private IDocument fDocument;
    /** The text viewer */
    private ITextViewer fViewer;


    /**
     * Processes a dirty region. If the dirty region is <code>null</code> the whole
     * document is consider being dirty. The dirty region is partitioned by the
     * document and each partition is handed over to a reconciling strategy registered
     * for the partition's content type.
     *
     * @param dirtyRegion the dirty region to be processed
     */
    abstract protected void process(DirtyRegion dirtyRegion);

    /**
     * Hook called when the document whose contents should be reconciled
     * has been changed, i.e., the input document of the text viewer this
     * reconciler is installed on. Usually, subclasses use this hook to
     * inform all their reconciling strategies about the change.
     *
     * @param newDocument the new reconciler document
     */
    abstract protected void reconcilerDocumentChanged(IDocument newDocument);


    /**
     * Creates a new reconciler without configuring it.
     */
    protected this() {
        fProgressMonitor= new NullProgressMonitor();
    }

    /**
     * Tells the reconciler how long it should wait for further text changes before
     * activating the appropriate reconciling strategies.
     *
     * @param delay the duration in milliseconds of a change collection period.
     */
    public void setDelay(int delay) {
        fDelay= delay;
    }

    /**
     * Tells the reconciler whether any of the available reconciling strategies
     * is interested in getting detailed dirty region information or just in the
     * fact that the document has been changed. In the second case, the reconciling
     * can not incrementally be pursued.
     *
     * @param isIncremental indicates whether this reconciler will be configured with
     *      incremental reconciling strategies
     *
     * @see DirtyRegion
     * @see IReconcilingStrategy
     */
    public void setIsIncrementalReconciler(bool isIncremental) {
        fIsIncrementalReconciler= isIncremental;
    }

    /**
     * Tells the reconciler whether it is allowed to change the document
     * inside its reconciler thread.
     * <p>
     * If this is set to <code>false</code> an {@link UnsupportedOperationException}
     * will be thrown when this restriction will be violated.
     * </p>
     *
     * @param isAllowedToModify indicates whether this reconciler is allowed to modify the document
     * @since 3.2
     */
    public void setIsAllowedToModifyDocument(bool isAllowedToModify) {
        fIsAllowedToModifyDocument= isAllowedToModify;
    }

    /**
     * Sets the progress monitor of this reconciler.
     *
     * @param monitor the monitor to be used
     */
    public void setProgressMonitor(IProgressMonitor monitor) {
        Assert.isLegal(monitor !is null);
        fProgressMonitor= monitor;
    }

    /**
     * Returns whether any of the reconciling strategies is interested in
     * detailed dirty region information.
     *
     * @return whether this reconciler is incremental
     *
     * @see IReconcilingStrategy
     */
    protected bool isIncrementalReconciler() {
        return fIsIncrementalReconciler;
    }

    /**
     * Returns the input document of the text viewer this reconciler is installed on.
     *
     * @return the reconciler document
     */
    protected IDocument getDocument() {
        return fDocument;
    }

    /**
     * Returns the text viewer this reconciler is installed on.
     *
     * @return the text viewer this reconciler is installed on
     */
    protected ITextViewer getTextViewer() {
        return fViewer;
    }

    /**
     * Returns the progress monitor of this reconciler.
     *
     * @return the progress monitor of this reconciler
     */
    protected IProgressMonitor getProgressMonitor() {
        return fProgressMonitor;
    }

    /*
     * @see IReconciler#install(ITextViewer)
     */
    public void install(ITextViewer textViewer) {

        Assert.isNotNull(cast(Object)textViewer);
        fViewer= textViewer;

        synchronized (this) {
            if (fThread !is null)
                return;
            fThread= new BackgroundThread(this.classinfo.name);
        }

        fDirtyRegionQueue= new DirtyRegionQueue();

        fListener= new Listener();
        fViewer.addTextInputListener(fListener);

        // see bug https://bugs.eclipse.org/bugs/show_bug.cgi?id=67046
        // if the reconciler gets installed on a viewer that already has a document
        // (e.g. when reusing editors), we force the listener to register
        // itself as document listener, because there will be no input change
        // on the viewer.
        // In order to do that, we simulate an input change.
        IDocument document= textViewer.getDocument();
        if (document !is null) {
            fListener.inputDocumentAboutToBeChanged(fDocument, document);
            fListener.inputDocumentChanged(fDocument, document);
        }
    }

    /*
     * @see IReconciler#uninstall()
     */
    public void uninstall() {
        if (fListener !is null) {

            fViewer.removeTextInputListener(fListener);
            if (fDocument !is null) {
                fListener.inputDocumentAboutToBeChanged(fDocument, null);
                fListener.inputDocumentChanged(fDocument, null);
            }
            fListener= null;

            synchronized (this) {
                // http://dev.eclipse.org/bugs/show_bug.cgi?id=19135
                BackgroundThread bt= fThread;
                fThread= null;
                bt.cancel();
            }
        }
    }

    /**
     * Creates a dirty region for a document event and adds it to the queue.
     *
     * @param e the document event for which to create a dirty region
     */
    private void createDirtyRegion(DocumentEvent e) {
        synchronized (fDirtyRegionQueue) {
            if (e.getLength() is 0 && e.getText() !is null) {
                // Insert
                fDirtyRegionQueue.addDirtyRegion(new DirtyRegion(e.getOffset(), e.getText().length(), DirtyRegion.INSERT, e.getText()));

            } else if (e.getText() is null || e.getText().length() is 0) {
                // Remove
                fDirtyRegionQueue.addDirtyRegion(new DirtyRegion(e.getOffset(), e.getLength(), DirtyRegion.REMOVE, null));

            } else {
                // Replace (Remove + Insert)
                fDirtyRegionQueue.addDirtyRegion(new DirtyRegion(e.getOffset(), e.getLength(), DirtyRegion.REMOVE, null));
                fDirtyRegionQueue.addDirtyRegion(new DirtyRegion(e.getOffset(), e.getText().length(), DirtyRegion.INSERT, e.getText()));
            }
        }
    }

    /**
     * Hook for subclasses which want to perform some
     * action as soon as reconciliation is needed.
     * <p>
     * Default implementation is to do nothing.
     * </p>
     *
     * @since 3.0
     */
    protected void aboutToBeReconciled() {
    }

    /**
     * This method is called on startup of the background activity. It is called only
     * once during the life time of the reconciler. Clients may reimplement this method.
     */
    protected void initialProcess() {
    }

    /**
     * Forces the reconciler to reconcile the structure of the whole document.
     * Clients may extend this method.
     */
    protected void forceReconciling() {

        if (fDocument !is null) {

            if (!fThread.isDirty()&& fThread.isAlive())
                aboutToBeReconciled();

            if (fThread.isActive())
                fProgressMonitor.setCanceled(true);

            if (fIsIncrementalReconciler) {
                DocumentEvent e= new DocumentEvent(fDocument, 0, fDocument.getLength(), fDocument.get());
                createDirtyRegion(e);
            }

            startReconciling();
        }
    }

    /**
     * Starts the reconciler to reconcile the queued dirty-regions.
     * Clients may extend this method.
     */
    protected synchronized void startReconciling() {
        if (fThread is null)
            return;

        if (!fThread.isAlive()) {
// SWT
//             try {
                fThread.start();
//             } catch (IllegalThreadStateException e) {
                // see https://bugs.eclipse.org/bugs/show_bug.cgi?id=40549
                // This is the only instance where the thread is started; since
                // we checked that it is not alive, it must be dead already due
                // to a run-time exception or error. Exit.
//             }
        } else {
            fThread.reset();
        }
    }

    /**
     * Hook that is called after the reconciler thread has been reset.
     */
    protected void reconcilerReset() {
    }

    /**
     * Tells whether the code is running in this reconciler's
     * background thread.
     *
     * @return <code>true</code> if running in this reconciler's background thread
     * @since 3.4
     */
    protected bool isRunningInReconcilerThread() {
        return Thread.currentThread() is fThread.getThread();
    }
}
