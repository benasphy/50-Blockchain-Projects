// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GasOptimizationDemo {
    // -----------------------------
    // STRUCT FOR DEMO
    // -----------------------------

    struct User {
        uint256 balance;
        uint256 lastUpdated;
        bool active;
    }

    mapping(address => User) public users;

    uint256 public totalUsers;

    // -----------------------------
    // 1️⃣ STORAGE VS MEMORY COPY
    // -----------------------------

    function updateUserBad() external {
        // ❌ BAD: copies entire struct into memory
        User memory user = users[msg.sender];

        user.balance += 1;
        user.lastUpdated = block.timestamp;
        user.active = true;

        // Write entire struct back to storage
        users[msg.sender] = user;
    }

    function updateUserGood() external {
        // ✅ GOOD: reference storage directly
        User storage user = users[msg.sender];

        user.balance += 1;
        user.lastUpdated = block.timestamp;
        user.active = true;
    }

    // -----------------------------
    // 2️⃣ STORAGE READ CACHING
    // -----------------------------

    function incrementBad() external {
        // ❌ Reads storage multiple times
        totalUsers = totalUsers + 1;
        totalUsers = totalUsers + 1;
    }

    function incrementGood() external {
        // ✅ Cache in memory
        uint256 _totalUsers = totalUsers;

        _totalUsers++;
        _totalUsers++;

        totalUsers = _totalUsers;
    }

    // -----------------------------
    // 3️⃣ MEMORY VS CALLDATA
    // -----------------------------

    function sumMemory(uint256[] memory numbers)
        external
        pure
        returns (uint256)
    {
        uint256 total;

        for (uint256 i = 0; i < numbers.length; i++) {
            total += numbers[i];
        }

        return total;
    }

    function sumCalldata(uint256[] calldata numbers)
        external
        pure
        returns (uint256)
    {
        uint256 total;

        for (uint256 i = 0; i < numbers.length; i++) {
            total += numbers[i];
        }

        return total;
    }

    // -----------------------------
    // 4️⃣ STRUCT PACKING
    // -----------------------------

    struct Packed {
        uint128 a;
        uint128 b;
    }

    struct Unpacked {
        uint256 a;
        uint128 b;
    }

    Packed public packedExample;
    Unpacked public unpackedExample;

    function setPacked(uint128 _a, uint128 _b) external {
        packedExample = Packed(_a, _b);
    }

    function setUnpacked(uint256 _a, uint128 _b) external {
        unpackedExample = Unpacked(_a, _b);
    }
}
