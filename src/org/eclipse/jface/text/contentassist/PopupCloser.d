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
module org.eclipse.jface.text.contentassist.PopupCloser;

import org.eclipse.jface.text.contentassist.ContentAssistEvent; // packageimport
import org.eclipse.jface.text.contentassist.Helper; // packageimport
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



import org.eclipse.swt.SWT;
import org.eclipse.swt.events.FocusEvent;
import org.eclipse.swt.events.FocusListener;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.events.ShellAdapter;
import org.eclipse.swt.events.ShellEvent;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.ScrollBar;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Table;
import org.eclipse.jface.internal.text.DelayedInputChangeListener;
import org.eclipse.jface.internal.text.InformationControlReplacer;
import org.eclipse.jface.text.IDelayedInputChangeProvider;
import org.eclipse.jface.text.IInformationControl;
import org.eclipse.jface.text.IInformationControlExtension5;
import org.eclipse.jface.text.IInputChangedListener;


/**
 * A generic closer class used to monitor various
 * interface events in order to determine whether
 * a content assistant should be terminated and all
 * associated windows be closed.
 */
class PopupCloser : ShellAdapter , FocusListener, SelectionListener, Listener {

    /** The content assistant to be monitored. */
    private ContentAssistant fContentAssistant;
    /** The table of a selector popup opened by the content assistant. */
    private Table fTable;
    /** The scroll bar of the table for the selector popup. */
    private ScrollBar fScrollbar;
    /** Indicates whether the scroll bar thumb has been grabbed. */
    private bool fScrollbarClicked= false;
    /**
     * The shell on which some listeners are registered.
     * @since 3.1
     */
    private Shell fShell;
    /**
     * The display on which some filters are registered.
     * @since 3.4
     */
    private Display fDisplay;
    /**
     * The additional info controller, or <code>null</code>.
     * @since 3.4
     */
    private AdditionalInfoController fAdditionalInfoController;

    /**
     * Installs this closer on the given table opened by the given content assistant.
     *
     * @param contentAssistant the content assistant
     * @param table the table to be tracked
     */
    public void install(ContentAssistant contentAssistant, Table table) {
        install(contentAssistant, table, null);
    }

    /**
     * Installs this closer on the given table opened by the given content assistant.
     *
     * @param contentAssistant the content assistant
     * @param table the table to be tracked
     * @param additionalInfoController the additional info controller, or <code>null</code>
     * @since 3.4
     */
    public void install(ContentAssistant contentAssistant, Table table, AdditionalInfoController additionalInfoController) {
        fContentAssistant= contentAssistant;
        fTable= table;
        fAdditionalInfoController= additionalInfoController;

        if (Helper.okToUse(fTable)) {
            fShell= fTable.getShell();
            fDisplay= fShell.getDisplay();

            fShell.addShellListener(this);
            fTable.addFocusListener(this);
            fScrollbar= fTable.getVerticalBar();
            if (fScrollbar !is null)
                fScrollbar.addSelectionListener(this);

            fDisplay.addFilter(SWT.Activate, this);
            fDisplay.addFilter(SWT.MouseWheel, this);

            fDisplay.addFilter(SWT.Deactivate, this);

            fDisplay.addFilter(SWT.MouseUp, this);
        }
    }

    /**
     * Uninstalls this closer if previously installed.
     */
    public void uninstall() {
        fContentAssistant= null;
        if (Helper.okToUse(fShell))
            fShell.removeShellListener(this);
        fShell= null;
        if (Helper.okToUse(fScrollbar))
            fScrollbar.removeSelectionListener(this);
        if (Helper.okToUse(fTable))
            fTable.removeFocusListener(this);
        if (fDisplay !is null && ! fDisplay.isDisposed()) {
            fDisplay.removeFilter(SWT.Activate, this);
            fDisplay.removeFilter(SWT.MouseWheel, this);

            fDisplay.removeFilter(SWT.Deactivate, this);

            fDisplay.removeFilter(SWT.MouseUp, this);
        }
    }

    /*
     * @see org.eclipse.swt.events.SelectionListener#widgetSelected(org.eclipse.swt.events.SelectionEvent)
     */
    public void widgetSelected(SelectionEvent e) {
        fScrollbarClicked= true;
    }

    /*
     * @see org.eclipse.swt.events.SelectionListener#widgetDefaultSelected(org.eclipse.swt.events.SelectionEvent)
     */
    public void widgetDefaultSelected(SelectionEvent e) {
        fScrollbarClicked= true;
    }

    /*
     * @see org.eclipse.swt.events.FocusListener#focusGained(org.eclipse.swt.events.FocusEvent)
     */
    public void focusGained(FocusEvent e) {
    }

    /*
     * @see org.eclipse.swt.events.FocusListener#focusLost(org.eclipse.swt.events.FocusEvent)
     */
    public void focusLost(FocusEvent e) {
        fScrollbarClicked= false;
        Display d= fTable.getDisplay();
        d.asyncExec(dgRunnable((FocusEvent e_) {
            if (Helper.okToUse(fTable) && !fTable.isFocusControl() && !fScrollbarClicked && fContentAssistant !is null)
                fContentAssistant.popupFocusLost(e_);
        }, e ));
    }

    /*
     * @see org.eclipse.swt.events.ShellAdapter#shellDeactivated(org.eclipse.swt.events.ShellEvent)
     * @since 3.1
     */
    public void shellDeactivated(ShellEvent e) {
        if (fContentAssistant !is null && ! fContentAssistant.hasProposalPopupFocus())
            fContentAssistant.hide_package();
    }


    /*
     * @see org.eclipse.swt.events.ShellAdapter#shellClosed(org.eclipse.swt.events.ShellEvent)
     * @since 3.1
     */
    public void shellClosed(ShellEvent e) {
        if (fContentAssistant !is null)
            fContentAssistant.hide_package();
    }

    /*
     * @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
     * @since 3.4
     */
    public void handleEvent(Event event) {
        switch (event.type) {
            case SWT.Activate:
            case SWT.MouseWheel:
                if (fAdditionalInfoController is null)
                    return;
                if (event.widget is fShell || event.widget is fTable || event.widget is fScrollbar)
                    return;

                if (fAdditionalInfoController.getInternalAccessor().getInformationControlReplacer() is null)
                    fAdditionalInfoController.hideInformationControl_package();
                else if (!fAdditionalInfoController.getInternalAccessor().isReplaceInProgress()) {
                    IInformationControl infoControl= fAdditionalInfoController.getCurrentInformationControl2();
                    // During isReplaceInProgress(), events can come from the replacing information control
                    if (cast(Control)event.widget && cast(IInformationControlExtension5)infoControl ) {
                        Control control= cast(Control) event.widget;
                        IInformationControlExtension5 iControl5= cast(IInformationControlExtension5) infoControl;
                        if (!(iControl5.containsControl(control)))
                            fAdditionalInfoController.hideInformationControl_package();
                        else if (event.type is SWT.MouseWheel)
                            fAdditionalInfoController.getInternalAccessor().replaceInformationControl(false);
                    } else if (infoControl !is null && infoControl.isFocusControl()) {
                        fAdditionalInfoController.getInternalAccessor().replaceInformationControl(true);
                    }
                }
                break;

            case SWT.MouseUp:
                if (fAdditionalInfoController is null || fAdditionalInfoController.getInternalAccessor().isReplaceInProgress())
                    break;
                if (cast(Control)event.widget) {
                    Control control= cast(Control) event.widget;
                    IInformationControl infoControl= fAdditionalInfoController.getCurrentInformationControl2();
                    if ( cast(IInformationControlExtension5)infoControl ) {
                        final IInformationControlExtension5 iControl5= cast(IInformationControlExtension5) infoControl;
                        if (iControl5.containsControl(control)) {
                            if ( cast(IDelayedInputChangeProvider)infoControl ) {
                                final IDelayedInputChangeProvider delayedICP= cast(IDelayedInputChangeProvider) infoControl;
                                final IInputChangedListener inputChangeListener= new DelayedInputChangeListener(delayedICP, fAdditionalInfoController.getInternalAccessor().getInformationControlReplacer());
                                delayedICP.setDelayedInputChangeListener(inputChangeListener);
                                // cancel automatic input updating after a small timeout:
                                control.getShell().getDisplay().timerExec(1000, new class()  Runnable {
                                    public void run() {
                                        delayedICP.setDelayedInputChangeListener(null);
                                    }
                                });
                            }

                            // XXX: workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=212392 :
                            control.getShell().getDisplay().asyncExec(new class()  Runnable {
                                public void run() {
                                    fAdditionalInfoController.getInternalAccessor().replaceInformationControl(true);
                                }
                            });
                        }
                    }
                }
                break;

            case SWT.Deactivate:
                if (fAdditionalInfoController is null)
                    break;
                InformationControlReplacer replacer= fAdditionalInfoController.getInternalAccessor().getInformationControlReplacer();
                if (replacer !is null && fContentAssistant !is null) {
                    IInformationControl iControl= replacer.getCurrentInformationControl2();
                    if (cast(Control)event.widget  && cast(IInformationControlExtension5)iControl ) {
                        Control control= cast(Control) event.widget;
                        IInformationControlExtension5 iControl5= cast(IInformationControlExtension5) iControl;
                        if (iControl5.containsControl(control)) {
                            control.getDisplay().asyncExec(new class()  Runnable {
                                public void run() {
                                    if (fContentAssistant !is null && ! fContentAssistant.hasProposalPopupFocus())
                                        fContentAssistant.hide_package();
                                }
                            });
                        }
                    }
                }
                break;
            default:
        }
    }
}
