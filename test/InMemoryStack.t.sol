// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test } from "@forge-std/Test.sol";
import { console } from "@forge-std/Test.sol";

import { InMemoryStack, Entry, Stack } from "src/InMemoryStack.sol";

contract InMemoryStackTest is Test {
    using InMemoryStack for Stack;

    struct SampleElementType {
        uint256 sampleUint256;
        bytes sampleBytes;
        bytes32 sampleBytes32;
    }

    function testPush(SampleElementType[] memory sampleElementTypes_) public {
        Stack memory stack_ = InMemoryStack.createEmptyStack();
        for (uint i_ = 0; i_ < sampleElementTypes_.length; i_++) {
            stack_.push(abi.encode(sampleElementTypes_[i_]));
        }

        for (uint i_ = 0; i_ < sampleElementTypes_.length; i_++) {
            Entry memory currEntry_ = stack_.getEntry(sampleElementTypes_.length - i_ - 1);
            assertEq(currEntry_.value, abi.encode(sampleElementTypes_[i_]));
        }

        assertEq(stack_.length, sampleElementTypes_.length);
    }

    function testPop(SampleElementType[] memory sampleElementTypes_) public {
        Stack memory stack_ = InMemoryStack.createEmptyStack();
        for (uint i_ = 0; i_ < sampleElementTypes_.length; i_++) {
            stack_.push(abi.encode(sampleElementTypes_[i_]));
        }

        for (uint i_ = 0; i_ < sampleElementTypes_.length; i_++) {
            assertEq(stack_.pop(), abi.encode(sampleElementTypes_[sampleElementTypes_.length - i_ - 1]));
            assertEq(stack_.length, sampleElementTypes_.length - i_ - 1);
        }
    }

    function testPop_EmptyStackError() public {
        Stack memory stack_ = InMemoryStack.createEmptyStack();
        vm.expectRevert(abi.encodeWithSignature("EmptyStackError()"));
        stack_.pop();
    }

    /// @notice Tests the set function. Pushes a bunch of values to the stack, thens sets them in reverse order.
    function testSet(SampleElementType[] memory sampleElementTypes_) public {
        Stack memory stack_ = InMemoryStack.createEmptyStack();
        for (uint i_ = 0; i_ < sampleElementTypes_.length; i_++) {
            stack_.push(abi.encode(sampleElementTypes_[i_]));
        }

        for (uint i_ = 0; i_ < sampleElementTypes_.length; i_++) {
            stack_.set(i_, abi.encode(sampleElementTypes_[i_]));
        }

        for (uint i_ = 0; i_ < sampleElementTypes_.length; i_++) {
            Entry memory currEntry_ = stack_.getEntry(i_);
            assertEq(currEntry_.value, abi.encode(sampleElementTypes_[i_]));
        }
    }

    function testSet_OutOfBoundsError(uint256 index_) public {
        Stack memory stack_ = InMemoryStack.createEmptyStack();
        vm.expectRevert(abi.encodeWithSignature("IndexOutOfBoundsError()"));
        stack_.set(index_, abi.encode(0));
    }

    function testPushPop(SampleElementType[] memory sampleElementTypes_) public {
        Stack memory stack_ = InMemoryStack.createEmptyStack();
        for (uint i_ = 0; i_ < sampleElementTypes_.length; i_++) {
            stack_.push(abi.encode(sampleElementTypes_[i_]));
            assertEq(stack_.pop(), abi.encode(sampleElementTypes_[i_]));
            assertEq(stack_.length, 0);
        }
    }
    
    function testBenchmarkDynamicVsStatic() public view {
        bytes memory data_ = abi.encode("dasdasdasdasdasdasdadasdasdasdadasdadadasdadada1sd");
        uint256 numberOfElements_ = 100;
        uint256 staticStackSize_ = 1000;

        uint256 initialGas_ = gasleft();
        Stack memory stack_ = InMemoryStack.createEmptyStack();
        for (uint i_ = 0; i_ < numberOfElements_; i_++) {
            stack_.push(data_);
        }
        uint256 dynamicStackCost_ = initialGas_ - gasleft();

        console.log("dynamic stack cost", dynamicStackCost_);

        initialGas_ = gasleft();
        bytes[] memory staticStack_ = new bytes[](staticStackSize_);
        for (uint i_ = 0; i_ < numberOfElements_; i_++) {
            staticStack_[i_] = data_;
        }
        uint256 staticStackCost_ = initialGas_ - gasleft();

        console.log("static stack cost", staticStackCost_);

        console.log("dynamic/static*100 =", dynamicStackCost_ * 100 / staticStackCost_);
    }
}
