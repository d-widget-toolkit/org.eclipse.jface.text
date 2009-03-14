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
module org.eclipse.jface.internal.text.link.contentassist.PopupCloser2;

import org.eclipse.jface.internal.text.link.contentassist.IProposalListener; // packageimport
import org.eclipse.jface.internal.text.link.contentassist.LineBreakingReader; // packageimport
import org.eclipse.jface.internal.text.link.contentassist.CompletionProposalPopup2; // packageimport
import org.eclipse.jface.internal.text.link.contentassist.ContextInformationPopup2; // packageimport
import org.eclipse.jface.internal.text.link.contentassist.ContentAssistMessages; // packageimport
import org.eclipse.jface.internal.text.link.contentassist.Helper2; // packageimport
import org.eclipse.jface.internal.text.link.contentassist.IContentAssistListener2; // packageimport
import org.eclipse.jface.internal.text.link.contentassist.ContentAssistant2; // packageimport
import org.eclipse.jface.internal.text.link.contentassist.AdditionalInfoController2; // packageimport


import java.lang.all;


import org.eclipse.swt.events.FocusEvent;
import org.eclipse.swt.events.FocusListener;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.events.ShellAdapter;
import org.eclipse.swt.events.ShellEvent;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.ScrollBar;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Table;


/**
 * A generic closer class used to monitor various
 * interface events in order to determine whether
 * a content assistant should be terminated and all
 * associated windows be closed.
 */
class PopupCloser2 : ShellAdapter , FocusListener, SelectionListener {

    /** The content assistant to be monitored */
    private ContentAssistant2 fContentAssistant;
    /** The table of a selector popup opened by the content assistant */
    private Table fTable;
    /** The scrollbar of the table for the selector popup */
    private ScrollBar fScrollbar;
    /** Indicates whether the scrollbar thumb has been grabbed. */
    private bool fScrollbarClicked= false;
    /** The shell on which some listeners are registered. */
    private Shell fShell;


    /**
     * Installs this closer on the given table opened by the given content assistant.
     *
     * @param contentAssistant the content assistant
     * @param table the table to be tracked
     */
    public void install(ContentAssistant2 contentAssistant, Table table) {
        fContentAssistant= contentAssistant;
        fTable= table;
        if (Helper2.okToUse(fTable)) {
            Shell shell= fTable.getShell();
            if (Helper2.okToUse(shell)) {
                fShell= shell;
                fShell.addShellListener(this);
            }
            fTable.addFocusListener(this);
            fScrollbar= fTable.getVerticalBar();
            if (fScrollbar !is null)
                fScrollbar.addSelectionListener(this);
        }
    }

    /**
     * Uninstalls this closer if previously installed.
     */
    public void uninstall() {
        fContentAssistant= null;
        if (Helper2.okToUse(fShell))
            fShell.removeShellListener(this);
        fShell= null;
        if (Helper2.okToUse(fScrollbar))
            fScrollbar.removeSelectionListener(this);
        if (Helper2.okToUse(fTable))
            fTable.removeFocusListener(this);
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
            if (Helper2.okToUse(fTable) && !fTable.isFocusControl() && !fScrollbarClicked && fContentAssistant !is null)
                fContentAssistant.popupFocusLost(e_);
        }, e ));
    }

    /*
     * @see org.eclipse.swt.events.ShellAdapter#shellDeactivated(org.eclipse.swt.events.ShellEvent)
     * @since 3.1
     */
    public void shellDeactivated(ShellEvent e) {
        if (fContentAssistant !is null)
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
}
