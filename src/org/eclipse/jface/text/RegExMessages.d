/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
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
module org.eclipse.jface.text.RegExMessages;

import java.lang.all;

import java.util.ResourceBundle;
import java.util.MissingResourceException;


/**
 * RegEx messages. Helper class to get NLSed messages.
 *
 * @since 3.4
 */
final class RegExMessages {

    //private static const String RESOURCE_BUNDLE= RegExMessages.classinfo.getName();
    private static ResourceBundle fgResourceBundle_;//= ResourceBundle.getBundle(RESOURCE_BUNDLE);
    private static ResourceBundle fgResourceBundle(){
        if( fgResourceBundle_ is null ){
            synchronized(RegExMessages.classinfo ){
                if( fgResourceBundle_ is null ){
                    fgResourceBundle_ = ResourceBundle.getBundle(
                        getImportData!("org.eclipse.jface.text.RegExMessages.properties"));
                }
            }
        }
        return fgResourceBundle_;
    }

    private this() {
        // Do not instantiate
    }

    public static String getString(String key) {
        try {
            return fgResourceBundle.getString(key);
        } catch (MissingResourceException e) {
            return "!" ~ key ~ "!";//$NON-NLS-2$ //$NON-NLS-1$
        }
    }

}
