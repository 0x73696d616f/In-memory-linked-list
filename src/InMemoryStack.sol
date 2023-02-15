// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/**
 * @notice A library for managing dynamic in-memory stack of bytes. This can hold any basic type or struct. Due to lack of
 * generics in Solidity, this library uses a workaround to manage dynamic arrays of different types. Under the hood it
 * is storing an arbitrary amount of bytes so in order to store a struct, it has to be encoded before storing (using abi.encode)
 * and decoded after it is retreived from the stack (using abi.decode). This library is meant to be used with the stack
 * struct.
 * @dev Under the hood it implements a linked list data structure.
 * @author @0x73696d616f
 */

/**
 * @notice Entry is an element stored inside the stack. Value is stored as bytes so it can be any basic
 * type or struct, it just has to be encoded before storing and decoded after retreived from the stack.
 * Entry also contains references the next entry in the stack. Entry[] funcitons as a pointer,
 * if it's empty stack, it's null. If it has one element, it's the pointer to the next entry.
 * @param value The value stored in the entry
 * @param next The next entry in the stack
 */
struct Entry {
    bytes value;
    Entry[] next;
}

/**
 * @notice Stack is a dynamic stack of Entries. It contains the length of the stack and a pointer to the
 * first entry of the stack. If the stack is empty, firstEntry is an empty array.
 * @param length The length of the stack
 * @param firstEntry The first entry of the stack
 */
struct Stack {
    uint256 length;
    Entry[] firstEntry;
}

/**
 * @notice This is a helper function to build a "pointer" to an entry.
 *         Technically, it is not a pointer but it functions as one.
 *         It's used to set the next entry.
 * @param entry_ The entry to build a pointer to
 * @return entryPointer_ The pointer to the entry passed as a parameter
 */
function buildEntryPointer(Entry memory entry_) pure returns (Entry[] memory entryPointer_) {
    entryPointer_ = new Entry[](1);
    entryPointer_[0] = entry_;
}

library InMemoryStack {
    error EmptyStackError();
    error IndexOutOfBoundsError();

    /**
     * @notice Creates an empty Stack
     * @return Stack The empty Stack
     */
    function createEmptyStack() internal pure returns (Stack memory) {
        return Stack(0, new Entry[](0));
    }

    /**
     * @notice Pushes a new value to the top of the stack
     * @param stack_ The stack to push the value to
     * @param value_ The value to push to the stack
     */
    function push(Stack memory stack_, bytes memory value_) internal pure {
        Entry memory newEntry_ = Entry(value_, stack_.firstEntry);
        Entry[] memory newEntryPointer_ = buildEntryPointer(newEntry_);
        stack_.firstEntry = newEntryPointer_;
        ++stack_.length;
    }

    /**
     * @notice Removes the firsr value from the stack. Reverts when there is no element to remove.
     * @param stack_ The stack to pop the value from
     * @return value The value popped from the stack
     */
    function pop(Stack memory stack_) internal pure returns (bytes memory) {
        if (stack_.length == 0) revert EmptyStackError();
        Entry memory firstEntry_ = stack_.firstEntry[0];

        stack_.firstEntry = firstEntry_.next;
        unchecked {
            --stack_.length;
        }

        return firstEntry_.value;
    }

    /**
     * @notice Retreives the entry at the specified index without removing it
     * @param stack_ The stack to retreive the entry from
     * @param index_ The index of the entry to retreive
     * @return entry_ The entry at the specified index
     */
    function getEntry(Stack memory stack_, uint256 index_) internal pure returns (Entry memory entry_) {
        if (index_ >= stack_.length) revert IndexOutOfBoundsError();

        entry_ = stack_.firstEntry[0];
        for (uint256 i_ = 0; i_ < index_;) {
            entry_ = entry_.next[0];
            unchecked {
                ++i_;
            }
        }
    }

    /**
     * @notice Sets the value at the specified index
     * @param stack_ The stack to set the value in
     * @param index_ The index of the value to set
     * @param value_ The value to set
     */
    function set(Stack memory stack_, uint256 index_, bytes memory value_) internal pure {
        Entry memory entry_ = getEntry(stack_, index_);
        entry_.value = value_;
    }
}
