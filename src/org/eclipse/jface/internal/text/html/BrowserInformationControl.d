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
module org.eclipse.jface.internal.text.html.BrowserInformationControl;

import org.eclipse.jface.internal.text.html.HTML2TextReader; // packageimport
import org.eclipse.jface.internal.text.html.HTMLPrinter; // packageimport
import org.eclipse.jface.internal.text.html.SubstitutionTextReader; // packageimport
import org.eclipse.jface.internal.text.html.HTMLTextPresenter; // packageimport
import org.eclipse.jface.internal.text.html.BrowserInput; // packageimport
import org.eclipse.jface.internal.text.html.SingleCharReader; // packageimport
import org.eclipse.jface.internal.text.html.BrowserInformationControlInput; // packageimport
import org.eclipse.jface.internal.text.html.HTMLMessages; // packageimport

import java.lang.all;
import java.util.Iterator;
import java.util.Set;

import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.jface.text.AbstractInformationControl;
import org.eclipse.jface.text.IInformationControlExtension2;
import org.eclipse.jface.text.IDelayedInputChangeProvider;
import org.eclipse.jface.text.IInputChangedListener;

//pragma( msg, "org.eclipse.jface.internal.text.html.BrowserInformationControl: SWT browser control missing" );
class BrowserInformationControl : AbstractInformationControl , IInformationControlExtension2, IDelayedInputChangeProvider {
    public this(Shell parent, String symbolicFontName, bool resizable){
        super(parent, resizable);
        implMissing(__FILE__,__LINE__);
    }
    public static bool isAvailable(Composite parent){
        implMissing(__FILE__,__LINE__);
        return false;
    }
    public void setInformation(String content) {
        implMissing(__FILE__,__LINE__);
    }
    protected void createContent(Composite parent) {
        implMissing(__FILE__,__LINE__);
    }
    public void setInput(Object input) {
        implMissing(__FILE__,__LINE__);
    }
    public void setDelayedInputChangeListener(IInputChangedListener inputChangeListener) {
        implMissing(__FILE__,__LINE__);
    }
    public bool hasContents() {
        implMissing(__FILE__,__LINE__);
        return false;
    }
}

// FIXME needs Browser :/
/++

import org.eclipse.swt.SWT;
import org.eclipse.swt.SWTError;
import org.eclipse.swt.browser.Browser;
import org.eclipse.swt.browser.LocationListener;
import org.eclipse.swt.browser.ProgressAdapter;
import org.eclipse.swt.browser.ProgressEvent;
import org.eclipse.swt.custom.StyleRange;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.KeyListener;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.graphics.TextLayout;
import org.eclipse.swt.graphics.TextStyle;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Menu;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Slider;
import org.eclipse.core.runtime.Assert;
import org.eclipse.core.runtime.ListenerList;
import org.eclipse.jface.action.ToolBarManager;
import org.eclipse.jface.resource.JFaceResources;
import org.eclipse.jface.text.AbstractInformationControl;
import org.eclipse.jface.text.IDelayedInputChangeProvider;
import org.eclipse.jface.text.IInformationControlExtension2;
import org.eclipse.jface.text.IInputChangedListener;
import org.eclipse.jface.text.TextPresentation;


/**
 * Displays HTML information in a {@link org.eclipse.swt.browser.Browser} widget.
 * <p>
 * This {@link IInformationControlExtension2} expects {@link #setInput(Object)} to be
 * called with an argument of type {@link BrowserInformationControlInput}.
 * </p>
 * <p>
 * Moved into this package from <code>org.eclipse.jface.internal.text.revisions</code>.</p>
 * <p>
 * This class may be instantiated; it is not intended to be subclassed.</p>
 * <p>
 * Current problems:
 * <ul>
 *  <li>the size computation is too small</li>
 *  <li>focusLost event is not sent - see https://bugs.eclipse.org/bugs/show_bug.cgi?id=84532</li>
 * </ul>
 * </p>
 *
 * @since 3.2
 */
public class BrowserInformationControl : AbstractInformationControl , IInformationControlExtension2, IDelayedInputChangeProvider {


    /**
     * Tells whether the SWT Browser widget and hence this information
     * control is available.
     *
     * @param parent the parent component used for checking or <code>null</code> if none
     * @return <code>true</code> if this control is available
     */
    public static bool isAvailable(Composite parent) {
        if (!fgAvailabilityChecked) {
            try {
                Browser browser= new Browser(parent, SWT.NONE);
                browser.dispose();
                fgIsAvailable= true;

                Slider sliderV= new Slider(parent, SWT.VERTICAL);
                Slider sliderH= new Slider(parent, SWT.HORIZONTAL);
                int width= sliderV.computeSize(SWT.DEFAULT, SWT.DEFAULT).x;
                int height= sliderH.computeSize(SWT.DEFAULT, SWT.DEFAULT).y;
                fgScrollBarSize= new Point(width, height);
                sliderV.dispose();
                sliderH.dispose();
            } catch (SWTError er) {
                fgIsAvailable= false;
            } finally {
                fgAvailabilityChecked= true;
            }
        }

        return fgIsAvailable;
    }


    /**
     * Minimal size constraints.
     * @since 3.2
     */
    private static const int MIN_WIDTH= 80;
    private static const int MIN_HEIGHT= 50;


    /**
     * Availability checking cache.
     */
    private static bool fgIsAvailable= false;
    private static bool fgAvailabilityChecked= false;

    /**
     * Cached scroll bar width and height
     * @since 3.4
     */
    private static Point fgScrollBarSize;

    /** The control's browser widget */
    private Browser fBrowser;
    /** Tells whether the browser has content */
    private bool fBrowserHasContent;
    /** Text layout used to approximate size of content when rendered in browser */
    private TextLayout fTextLayout;
    /** Bold text style */
    private TextStyle fBoldStyle;

    private BrowserInformationControlInput fInput;

    /**
     * <code>true</code> iff the browser has completed loading of the last
     * input set via {@link #setInformation(String)}.
     * @since 3.4
     */
    private bool fCompleted= false;

    /**
     * The listener to be notified when a delayed location changing event happened.
     * @since 3.4
     */
    private IInputChangedListener fDelayedInputChangeListener;

    /**
     * The listeners to be notified when the input changed.
     * @since 3.4
     */
    private ListenerList/*<IInputChangedListener>*/ fInputChangeListeners= new ListenerList(ListenerList.IDENTITY);

    /**
     * The symbolic name of the font used for size computations, or <code>null</code> to use dialog font.
     * @since 3.4
     */
    private const String fSymbolicFontName;


    /**
     * Creates a browser information control with the given shell as parent.
     *
     * @param parent the parent shell
     * @param symbolicFontName the symbolic name of the font used for size computations
     * @param resizable <code>true</code> if the control should be resizable
     * @since 3.4
     */
    public this(Shell parent, String symbolicFontName, bool resizable) {
        super(parent, resizable);
        fSymbolicFontName= symbolicFontName;
        create();
    }

    /**
     * Creates a browser information control with the given shell as parent.
     *
     * @param parent the parent shell
     * @param symbolicFontName the symbolic name of the font used for size computations
     * @param statusFieldText the text to be used in the optional status field
     *            or <code>null</code> if the status field should be hidden
     * @since 3.4
     */
    public this(Shell parent, String symbolicFontName, String statusFieldText) {
        super(parent, statusFieldText);
        fSymbolicFontName= symbolicFontName;
        create();
    }

    /**
     * Creates a browser information control with the given shell as parent.
     *
     * @param parent the parent shell
     * @param symbolicFontName the symbolic name of the font used for size computations
     * @param toolBarManager the manager or <code>null</code> if toolbar is not desired
     * @since 3.4
     */
    public this(Shell parent, String symbolicFontName, ToolBarManager toolBarManager) {
        super(parent, toolBarManager);
        fSymbolicFontName= symbolicFontName;
        create();
    }

    /*
     * @see org.eclipse.jface.text.AbstractInformationControl#createContent(org.eclipse.swt.widgets.Composite)
     */
    protected void createContent(Composite parent) {
        fBrowser= new Browser(parent, SWT.NONE);

        Display display= getShell().getDisplay();
        fBrowser.setForeground(display.getSystemColor(SWT.COLOR_INFO_FOREGROUND));
        fBrowser.setBackground(display.getSystemColor(SWT.COLOR_INFO_BACKGROUND));
        fBrowser.addKeyListener(new class()  KeyListener {

            public void keyPressed(KeyEvent e)  {
                if (e.character is 0x1B) // ESC
                    getShell().dispose(); // XXX: Just hide? Would avoid constant recreations.
            }

            public void keyReleased(KeyEvent e) {}
        });

        fBrowser.addProgressListener(new class()  ProgressAdapter {
            public void completed(ProgressEvent event) {
                fCompleted= true;
            }
        });

        // Replace browser's built-in context menu with none
        fBrowser.setMenu(new Menu(getShell(), SWT.NONE));

        createTextLayout();
    }

    /**
     * {@inheritDoc}
     * @deprecated use {@link #setInput(Object)}
     */
    public void setInformation(String content) {
        setInput(new class(null,content)  BrowserInformationControlInput {
            String content_;
            this(BrowserInformationControlInput input, String a){
                super(input);
                content_=a;
            }
            public String getHtml() {
                return content_;
            }

            public String getInputName() {
                return ""; //$NON-NLS-1$
            }

            public Object getInputElement() {
                return stringcast(content_);
            }
        });
    }

    /**
     * {@inheritDoc} This control can handle {@link String} and
     * {@link BrowserInformationControlInput}.
     */
    public void setInput(Object input) {
        Assert.isLegal(input is null || cast(String)input  || cast(BrowserInformationControlInput)input );

        if ( cast(String)input ) {
            setInformation(cast(String)input);
            return;
        }

        fInput= cast(BrowserInformationControlInput)input;

        String content= null;
        if (fInput !is null)
            content= fInput.getHtml();

        fBrowserHasContent= content !is null && content.length() > 0;

        if (!fBrowserHasContent)
            content= "<html><body ></html>"; //$NON-NLS-1$

        bool RTL= (getShell().getStyle() & SWT.RIGHT_TO_LEFT) !is 0;
        bool resizable= isResizable();

        // The default "overflow:auto" would not result in a predictable width for the client area
        // and the re-wrapping would cause visual noise
        String[] styles= null;
        if (RTL && resizable)
            styles= [ "direction:rtl;", "overflow:scroll;", "word-wrap:break-word;" ]; //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
        else if (RTL && !resizable)
            styles= [ "direction:rtl;", "overflow:hidden;", "word-wrap:break-word;" ]; //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
        else if (!resizable)
            //XXX: In IE, "word-wrap: break-word;" causes bogus wrapping even in non-broken words :-(see e.g. Javadoc of String).
            // Re-check whether we really still need this now that the Javadoc Hover header already sets this style.
            styles= [ "overflow:hidden;"/*, "word-wrap: break-word;"*/ ]; //$NON-NLS-1$
        else
            styles= [ "overflow:scroll;" ]; //$NON-NLS-1$

        StringBuffer buffer= new StringBuffer(content);
        HTMLPrinter.insertStyles(buffer, styles);
        content= buffer.toString();

        /*
         * XXX: Should add some JavaScript here that shows something like
         * "(continued...)" or "..." at the end of the visible area when the page overflowed
         * with "overflow:hidden;".
         */

        fCompleted= false;
        fBrowser.setText(content);

        Object[] listeners= fInputChangeListeners.getListeners();
        for (int i= 0; i < listeners.length; i++)
            (cast(IInputChangedListener)listeners[i]).inputChanged(fInput);
    }

    /*
     * @see IInformationControl#setVisible(bool)
     */
    public void setVisible(bool visible) {
        Shell shell= getShell();
        if (shell.isVisible() is visible)
            return;

        if (!visible) {
            super.setVisible(false);
            setInput(null);
            return;
        }

        /*
         * The Browser widget flickers when made visible while it is not completely loaded.
         * The fix is to delay the call to setVisible until either loading is completed
         * (see ProgressListener in constructor), or a timeout has been reached.
         */
        final Display display= shell.getDisplay();

        // Make sure the display wakes from sleep after timeout:
        display.timerExec(100, new class()  Runnable {
            public void run() {
                fCompleted= true;
            }
        });

        while (!fCompleted) {
            // Drive the event loop to process the events required to load the browser widget's contents:
            if (!display.readAndDispatch()) {
                display.sleep();
            }
        }

        shell= getShell();
        if (shell is null || shell.isDisposed())
            return;

        /*
         * Avoids flickering when replacing hovers, especially on Vista in ON_CLICK mode.
         * Causes flickering on GTK. Carbon does not care.
         */
        if ("win32".equals(SWT.getPlatform())) //$NON-NLS-1$
            shell.moveAbove(null);

        super.setVisible(true);
    }

    /*
     * @see org.eclipse.jface.text.AbstractInformationControl#setSize(int, int)
     */
    public void setSize(int width, int height) {
        fBrowser.setRedraw(false); // avoid flickering
        try {
            super.setSize(width, height);
        } finally {
            fBrowser.setRedraw(true);
        }
    }

    /**
     * Creates and initializes the text layout used
     * to compute the size hint.
     *
     * @since 3.2
     */
    private void createTextLayout() {
        fTextLayout= new TextLayout(fBrowser.getDisplay());

        // Initialize fonts
        Font font= fSymbolicFontName is null ? JFaceResources.getDialogFont() : JFaceResources.getFont(fSymbolicFontName);
        fTextLayout.setFont(font);
        fTextLayout.setWidth(-1);
        FontData[] fontData= font.getFontData();
        for (int i= 0; i < fontData.length; i++)
            fontData[i].setStyle(SWT.BOLD);
        font= new Font(getShell().getDisplay(), fontData);
        fBoldStyle= new TextStyle(font, null, null);

        // Compute and set tab width
        fTextLayout.setText("    "); //$NON-NLS-1$
        int tabWidth = fTextLayout.getBounds().width;
        fTextLayout.setTabs([tabWidth]);

        fTextLayout.setText(""); //$NON-NLS-1$
    }

    /*
     * @see IInformationControl#dispose()
     */
    public void dispose() {
        if (fTextLayout !is null) {
            fTextLayout.dispose();
            fTextLayout= null;
        }
        if (fBoldStyle !is null) {
            fBoldStyle.font.dispose();
            fBoldStyle= null;
        }
        fBrowser= null;

        super.dispose();
    }

    /*
     * @see IInformationControl#computeSizeHint()
     */
    public Point computeSizeHint() {
        Point sizeConstraints= getSizeConstraints();
        Rectangle trim= computeTrim();
        int height= trim.height;

        //FIXME: The HTML2TextReader does not render <p> like a browser.
        // Instead of inserting an empty line, it just adds a single line break.
        // Furthermore, the indentation of <dl><dd> elements is too small (e.g with a long @see line)
        TextPresentation presentation= new TextPresentation();
        HTML2TextReader reader= new HTML2TextReader(new StringReader(fInput.getHtml()), presentation);
        String text;
        try {
            text= reader.getString();
        } catch (IOException e) {
            text= ""; //$NON-NLS-1$
        }

        fTextLayout.setText(text);
        fTextLayout.setWidth(sizeConstraints is null ? SWT.DEFAULT : sizeConstraints.x - trim.width);
        Iterator iter= presentation.getAllStyleRangeIterator();
        while (iter.hasNext()) {
            StyleRange sr= cast(StyleRange)iter.next();
            if (sr.fontStyle is SWT.BOLD)
                fTextLayout.setStyle(fBoldStyle, sr.start, sr.start + sr.length - 1);
        }

        Rectangle bounds= fTextLayout.getBounds(); // does not return minimum width, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=217446
        int lineCount= fTextLayout.getLineCount();
        int textWidth= 0;
        for (int i= 0; i < lineCount; i++) {
            Rectangle rect= fTextLayout.getLineBounds(i);
            int lineWidth= rect.x + rect.width;
            if (i is 0)
                lineWidth += fInput.getLeadingImageWidth();
            textWidth= Math.max(textWidth, lineWidth);
        }
        bounds.width= textWidth;
        fTextLayout.setText(""); //$NON-NLS-1$

        int minWidth= bounds.width;
        height= height + bounds.height;

        // Add some air to accommodate for different browser renderings
        minWidth+= 15;
        height+= 15;


        // Apply max size constraints
        if (sizeConstraints !is null) {
            if (sizeConstraints.x !is SWT.DEFAULT)
                minWidth= Math.min(sizeConstraints.x, minWidth + trim.width);
            if (sizeConstraints.y !is SWT.DEFAULT)
                height= Math.min(sizeConstraints.y, height);
        }

        // Ensure minimal size
        int width= Math.max(MIN_WIDTH, minWidth);
        height= Math.max(MIN_HEIGHT, height);

        return new Point(width, height);
    }

    /*
     * @see org.eclipse.jface.text.IInformationControlExtension3#computeTrim()
     */
    public Rectangle computeTrim() {
        Rectangle trim= super.computeTrim();
        if (isResizable()) {
            bool RTL= (getShell().getStyle() & SWT.RIGHT_TO_LEFT) !is 0;
            if (RTL) {
                trim.x-= fgScrollBarSize.x;
            }
            trim.width+= fgScrollBarSize.x;
            trim.height+= fgScrollBarSize.y;
        }
        return trim;
    }

    /**
     * Adds the listener to the collection of listeners who will be
     * notified when the current location has changed or is about to change.
     *
     * @param listener the location listener
     * @since 3.4
     */
    public void addLocationListener(LocationListener listener) {
        fBrowser.addLocationListener(listener);
    }

    /*
     * @see IInformationControl#setForegroundColor(Color)
     */
    public void setForegroundColor(Color foreground) {
        super.setForegroundColor(foreground);
        fBrowser.setForeground(foreground);
    }

    /*
     * @see IInformationControl#setBackgroundColor(Color)
     */
    public void setBackgroundColor(Color background) {
        super.setBackgroundColor(background);
        fBrowser.setBackground(background);
    }

    /*
     * @see IInformationControlExtension#hasContents()
     */
    public bool hasContents() {
        return fBrowserHasContent;
    }

    /**
     * Adds a listener for input changes to this input change provider.
     * Has no effect if an identical listener is already registered.
     *
     * @param inputChangeListener the listener to add
     * @since 3.4
     */
    public void addInputChangeListener(IInputChangedListener inputChangeListener) {
        Assert.isNotNull(inputChangeListener);
        fInputChangeListeners.add(inputChangeListener);
    }

    /**
     * Removes the given input change listener from this input change provider.
     * Has no effect if an identical listener is not registered.
     *
     * @param inputChangeListener the listener to remove
     * @since 3.4
     */
    public void removeInputChangeListener(IInputChangedListener inputChangeListener) {
        fInputChangeListeners.remove(inputChangeListener);
    }

    /*
     * @see org.eclipse.jface.text.IDelayedInputChangeProvider#setDelayedInputChangeListener(org.eclipse.jface.text.IInputChangedListener)
     * @since 3.4
     */
    public void setDelayedInputChangeListener(IInputChangedListener inputChangeListener) {
        fDelayedInputChangeListener= inputChangeListener;
    }

    /**
     * Tells whether a delayed input change listener is registered.
     *
     * @return <code>true</code> iff a delayed input change
     *         listener is currently registered
     * @since 3.4
     */
    public bool hasDelayedInputChangeListener() {
        return fDelayedInputChangeListener !is null;
    }

    /**
     * Notifies listeners of a delayed input change.
     *
     * @param newInput the new input, or <code>null</code> to request cancellation
     * @since 3.4
     */
    public void notifyDelayedInputChange(Object newInput) {
        if (fDelayedInputChangeListener !is null)
            fDelayedInputChangeListener.inputChanged(newInput);
    }

    /*
     * @see java.lang.Object#toString()
     * @since 3.4
     */
    public override String toString() {
        String style= (getShell().getStyle() & SWT.RESIZE) is 0 ? "fixed" : "resizeable"; //$NON-NLS-1$ //$NON-NLS-2$
        return super.toString() + " -  style: " + style; //$NON-NLS-1$
    }

    /**
     * @return the current browser input or <code>null</code>
     */
    public BrowserInformationControlInput getInput() {
        return fInput;
    }

    /*
     * @see org.eclipse.jface.text.IInformationControlExtension5#computeSizeConstraints(int, int)
     */
    public Point computeSizeConstraints(int widthInChars, int heightInChars) {
        if (fSymbolicFontName is null)
            return null;

        GC gc= new GC(fBrowser);
        Font font= fSymbolicFontName is null ? JFaceResources.getDialogFont() : JFaceResources.getFont(fSymbolicFontName);
        gc.setFont(font);
        int width= gc.getFontMetrics().getAverageCharWidth();
        int height= gc.getFontMetrics().getHeight();
        gc.dispose();

        return new Point(widthInChars * width, heightInChars * height);
    }

}

++/
