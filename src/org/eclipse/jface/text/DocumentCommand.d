/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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


module org.eclipse.jface.text.DocumentCommand;

import org.eclipse.jface.text.IDocumentPartitioningListener; // packageimport
import org.eclipse.jface.text.IRegion; // packageimport
import org.eclipse.jface.text.IDocumentListener; // packageimport
import org.eclipse.jface.text.IDocument; // packageimport
import org.eclipse.jface.text.BadLocationException; // packageimport
import org.eclipse.jface.text.DefaultPositionUpdater; // packageimport
import org.eclipse.jface.text.Position; // packageimport
import org.eclipse.jface.text.BadPositionCategoryException; // packageimport

import java.lang.all;
import java.util.ListIterator;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Set;

import org.eclipse.swt.events.VerifyEvent;
import org.eclipse.core.runtime.Assert;


/**
 * Represents a text modification as a document replace command. The text
 * modification is given as a {@link org.eclipse.swt.events.VerifyEvent} and
 * translated into a document replace command relative to a given offset. A
 * document command can also be used to initialize a given
 * <code>VerifyEvent</code>.
 * <p>
 * A document command can also represent a list of related changes.</p>
 */
public class DocumentCommand {

    /**
     * A command which is added to document commands.
     * @since 2.1
     */
    private static class Command : Comparable {
        /** The offset of the range to be replaced */
        private const int fOffset;
        /** The length of the range to be replaced. */
        private const int fLength;
        /** The replacement text */
        private const String fText;
        /** The listener who owns this command */
        private const IDocumentListener fOwner;

        /**
         * Creates a new command with the given specification.
         *
         * @param offset the offset of the replace command
         * @param length the length of the replace command
         * @param text the text to replace with, may be <code>null</code>
         * @param owner the document command owner, may be <code>null</code>
         * @since 3.0
         */
        public this(int offset, int length, String text, IDocumentListener owner) {
            if (offset < 0 || length < 0)
                throw new IllegalArgumentException(null);
            fOffset= offset;
            fLength= length;
            fText= text;
            fOwner= owner;
        }

        /**
         * Returns the length delta for this command.
         *
         * @return the length delta for this command
         */
        public int getDeltaLength() {
            return (fText is null ? 0 : fText.length) - fLength;
        }

        /**
         * Executes the document command on the specified document.
         *
         * @param document the document on which to execute the command.
         * @throws BadLocationException in case this commands cannot be executed
         */
        public void execute(IDocument document)  {

            if (fLength is 0 && fText is null)
                return;

            if (fOwner !is null)
                document.removeDocumentListener(fOwner);

            document.replace(fOffset, fLength, fText);

            if (fOwner !is null)
                document.addDocumentListener(fOwner);
        }

        /*
         * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
         */
        public int compareTo(Object object) {
            if (isEqual(object))
                return 0;

            final Command command= cast(Command) object;

            // diff middle points if not intersecting
            if (fOffset + fLength <= command.fOffset || command.fOffset + command.fLength <= fOffset) {
                int value= (2 * fOffset + fLength) - (2 * command.fOffset + command.fLength);
                if (value !is 0)
                    return value;
            }
            // the answer
            return 42;
        }
        public final override int opCmp( Object object ){
            return compareTo( object );
        }

        private bool isEqual(Object object) {
            if (object is this)
                return true;
            if (!( cast(Command)object ))
                return false;
            final Command command= cast(Command) object;
            return command.fOffset is fOffset && command.fLength is fLength;
        }
    }

    /**
     * An iterator, which iterates in reverse over a list.
     */
    private static class ReverseListIterator : Iterator {

        /** The list iterator. */
        private const ListIterator fListIterator;

        /**
         * Creates a reverse list iterator.
         * @param listIterator the iterator that this reverse iterator is based upon
         */
        public this(ListIterator listIterator) {
            if (listIterator is null)
                throw new IllegalArgumentException(null);
            fListIterator= listIterator;
        }

        /*
         * @see java.util.Iterator#hasNext()
         */
        public bool hasNext() {
            return fListIterator.hasPrevious();
        }

        /*
         * @see java.util.Iterator#next()
         */
        public Object next() {
            return fListIterator.previous();
        }

        /*
         * @see java.util.Iterator#remove()
         */
        public void remove() {
            throw new UnsupportedOperationException();
        }
    }

    /**
     * A command iterator.
     */
    private static class CommandIterator : Iterator {

        /** The command iterator. */
        private const Iterator fIterator;

        /** The original command. */
        private Command fCommand;

        /** A flag indicating the direction of iteration. */
        private bool fForward;

        /**
         * Creates a command iterator.
         *
         * @param commands an ascending ordered list of commands
         * @param command the original command
         * @param forward the direction
         */
        public this(List commands, Command command, bool forward) {
            if (commands is null || command is null)
                throw new IllegalArgumentException(null);
            fIterator= forward ? commands.iterator() : new ReverseListIterator(commands.listIterator(commands.size()));
            fCommand= command;
            fForward= forward;
        }

        /*
         * @see java.util.Iterator#hasNext()
         */
        public bool hasNext() {
            return fCommand !is null || fIterator.hasNext();
        }

        /*
         * @see java.util.Iterator#next()
         */
        public Object next() {

            if (!hasNext())
                throw new NoSuchElementException(null);

            if (fCommand is null)
                return fIterator.next();

            if (!fIterator.hasNext()) {
                final Command tempCommand= fCommand;
                fCommand= null;
                return tempCommand;
            }

            final Command command= cast(Command) fIterator.next();
            final int compareValue= command.compareTo(fCommand);

            if ((compareValue < 0) ^ !fForward) {
                return command;

            } else if ((compareValue > 0) ^ !fForward) {
                final Command tempCommand= fCommand;
                fCommand= command;
                return tempCommand;

            } else {
                throw new IllegalArgumentException(null);
            }
        }

        /*
         * @see java.util.Iterator#remove()
         */
        public void remove() {
            throw new UnsupportedOperationException();
        }
    }

    /** Must the command be updated */
    public bool doit= false;
    /** The offset of the command. */
    public int offset;
    /** The length of the command */
    public int length;
    /** The text to be inserted */
    public String text;
    /**
     * The owner of the document command which will not be notified.
     * @since 2.1
     */
    public IDocumentListener owner;
    /**
     * The caret offset with respect to the document before the document command is executed.
     * @since 2.1
     */
    public int caretOffset;
    /**
     * Additional document commands.
     * @since 2.1
     */
    private const List fCommands;
    /**
     * Indicates whether the caret should be shifted by this command.
     * @since 3.0
     */
    public bool shiftsCaret;


    /**
     * Creates a new document command.
     */
    /+protected+/ this() {
        fCommands= new ArrayList();
    }

    /**
     * Translates a verify event into a document replace command using the given offset.
     *
     * @param event the event to be translated
     * @param modelRange the event range as model range
     */
    void setEvent(VerifyEvent event, IRegion modelRange) {

        doit= true;
        text= event.text;

        offset= modelRange.getOffset();
        length= modelRange.getLength();

        owner= null;
        caretOffset= -1;
        shiftsCaret= true;
        fCommands.clear();
    }

    /**
     * Fills the given verify event with the replace text and the <code>doit</code>
     * flag of this document command. Returns whether the document command
     * covers the same range as the verify event considering the given offset.
     *
     * @param event the event to be changed
     * @param modelRange to be considered for range comparison
     * @return <code>true</code> if this command and the event cover the same range
     */
    bool fillEvent(VerifyEvent event, IRegion modelRange) {
        event.text= text;
        event.doit= (offset is modelRange.getOffset() && length is modelRange.getLength() && doit && caretOffset is -1);
        return event.doit;
    }

    /**
     * Adds an additional replace command. The added replace command must not overlap
     * with existing ones. If the document command owner is not <code>null</code>, it will not
     * get document change notifications for the particular command.
     *
     * @param commandOffset the offset of the region to replace
     * @param commandLength the length of the region to replace
     * @param commandText the text to replace with, may be <code>null</code>
     * @param commandOwner the command owner, may be <code>null</code>
     * @throws BadLocationException if the added command intersects with an existing one
     * @since 2.1
     */
    public void addCommand(int commandOffset, int commandLength, String commandText, IDocumentListener commandOwner)  {
        final Command command= new Command(commandOffset, commandLength, commandText, commandOwner);

        if (intersects(command))
            throw new BadLocationException();

        final int index= Collections.binarySearch(fCommands, command);

        // a command with exactly the same ranges exists already
        if (index >= 0)
            throw new BadLocationException();

        // binary search result is defined as (-(insertionIndex) - 1)
        final int insertionIndex= -(index + 1);

        // overlaps to the right?
        if (insertionIndex !is fCommands.size() && intersects(cast(Command) fCommands.get(insertionIndex), command))
            throw new BadLocationException();

        // overlaps to the left?
        if (insertionIndex !is 0 && intersects(cast(Command) fCommands.get(insertionIndex - 1), command))
            throw new BadLocationException();

        fCommands.add(insertionIndex, command);
    }

    /**
     * Returns an iterator over the commands in ascending position order.
     * The iterator includes the original document command.
     * Commands cannot be removed.
     *
     * @return returns the command iterator
     */
    public Iterator getCommandIterator() {
        Command command= new Command(offset, length, text, owner);
        return new CommandIterator(fCommands, command, true);
    }

    /**
     * Returns the number of commands including the original document command.
     *
     * @return returns the number of commands
     * @since 2.1
     */
    public int getCommandCount() {
        return 1 + fCommands.size();
    }

    /**
     * Returns whether the two given commands intersect.
     *
     * @param command0 the first command
     * @param command1 the second command
     * @return <code>true</code> if the commands intersect
     * @since 2.1
     */
    private bool intersects(Command command0, Command command1) {
        // diff middle points if not intersecting
        if (command0.fOffset + command0.fLength <= command1.fOffset || command1.fOffset + command1.fLength <= command0.fOffset)
            return (2 * command0.fOffset + command0.fLength) - (2 * command1.fOffset + command1.fLength) is 0;
        return true;
    }

    /**
     * Returns whether the given command intersects with this command.
     *
     * @param command the command
     * @return <code>true</code> if the command intersects with this command
     * @since 2.1
     */
    private bool intersects(Command command) {
        // diff middle points if not intersecting
        if (offset + length <= command.fOffset || command.fOffset + command.fLength <= offset)
            return (2 * offset + length) - (2 * command.fOffset + command.fLength) is 0;
        return true;
    }

    /**
     * Executes the document commands on a document.
     *
     * @param document the document on which to execute the commands
     * @throws BadLocationException in case access to the given document fails
     * @since 2.1
     */
    void execute(IDocument document)  {

        if (length is 0 && text is null && fCommands.size() is 0)
            return;

        DefaultPositionUpdater updater= new DefaultPositionUpdater(getCategory());
        Position caretPosition= null;
        try {
            if (updateCaret()) {
                document.addPositionCategory(getCategory());
                document.addPositionUpdater(updater);
                caretPosition= new Position(caretOffset);
                document.addPosition(getCategory(), caretPosition);
            }

            final Command originalCommand= new Command(offset, length, text, owner);
            for (final Iterator iterator= new CommandIterator(fCommands, originalCommand, false); iterator.hasNext(); )
                (cast(Command) iterator.next()).execute(document);

        } catch (BadLocationException e) {
            // ignore
        } catch (BadPositionCategoryException e) {
            // ignore
        } finally {
            delegate(){
            if (updateCaret()) {
                document.removePositionUpdater(updater);
                try {
                    document.removePositionCategory(getCategory());
                } catch (BadPositionCategoryException e) {
                    Assert.isTrue(false);
                }
                caretOffset= caretPosition.getOffset();
            }
            }();
        }
    }

    /**
     * Returns <code>true</code> if the caret offset should be updated, <code>false</code> otherwise.
     *
     * @return <code>true</code> if the caret offset should be updated, <code>false</code> otherwise
     * @since 3.0
     */
    private bool updateCaret() {
        return shiftsCaret && caretOffset !is -1;
    }

    /**
     * Returns the position category for the caret offset position.
     *
     * @return the position category for the caret offset position
     * @since 3.0
     */
    private String getCategory() {
        return toString();
    }

}
