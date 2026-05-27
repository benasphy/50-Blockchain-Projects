// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PackedStorage {
    /*
        STORAGE LAYOUT (256 bits)

        [ active:1 ]
        [ banned:1 ]
        [ reputation:32 ]
        [ balance:64 ]
        [ level:16 ]
        [ reserved ]
    */

    mapping(address => uint256)
        internal packedData;

    event UserUpdated(
        address indexed user
    );

    // -----------------------------------
    // BIT POSITIONS
    // -----------------------------------

    uint256 private constant ACTIVE_BIT = 0;

    uint256 private constant BANNED_BIT = 1;

    uint256 private constant REP_SHIFT = 2;

    uint256 private constant BAL_SHIFT = 34;

    uint256 private constant LEVEL_SHIFT = 98;

    // masks
    uint256 private constant REP_MASK =
        (1 << 32) - 1;

    uint256 private constant BAL_MASK =
        (1 << 64) - 1;

    uint256 private constant LEVEL_MASK =
        (1 << 16) - 1;

    // -----------------------------------
    // WRITE USER
    // -----------------------------------

    function setUser(
        address user,
        bool active,
        bool banned,
        uint32 reputation,
        uint64 balance,
        uint16 level
    ) external {
        uint256 data;

        // booleans
        if (active) {
            data |= (1 << ACTIVE_BIT);
        }

        if (banned) {
            data |= (1 << BANNED_BIT);
        }

        // pack values
        data |=
            uint256(reputation)
                << REP_SHIFT;

        data |=
            uint256(balance)
                << BAL_SHIFT;

        data |=
            uint256(level)
                << LEVEL_SHIFT;

        packedData[user] = data;

        emit UserUpdated(user);
    }

    // -----------------------------------
    // READ FUNCTIONS
    // -----------------------------------

    function isActive(
        address user
    )
        public
        view
        returns (bool)
    {
        return
            (
                packedData[user] >>
                    ACTIVE_BIT
            ) & 1 == 1;
    }

    function isBanned(
        address user
    )
        public
        view
        returns (bool)
    {
        return
            (
                packedData[user] >>
                    BANNED_BIT
            ) & 1 == 1;
    }

    function reputation(
        address user
    )
        public
        view
        returns (uint32)
    {
        return
            uint32(
                (
                    packedData[user] >>
                        REP_SHIFT
                ) & REP_MASK
            );
    }

    function balance(
        address user
    )
        public
        view
        returns (uint64)
    {
        return
            uint64(
                (
                    packedData[user] >>
                        BAL_SHIFT
                ) & BAL_MASK
            );
    }

    function level(
        address user
    )
        public
        view
        returns (uint16)
    {
        return
            uint16(
                (
                    packedData[user] >>
                        LEVEL_SHIFT
                ) & LEVEL_MASK
            );
    }

    // -----------------------------------
    // BITMAP EXAMPLE
    // -----------------------------------

    uint256 internal permissionsBitmap;

    function grantPermission(
        uint8 permissionId
    ) external {
        permissionsBitmap |=
            (1 << permissionId);
    }

    function revokePermission(
        uint8 permissionId
    ) external {
        permissionsBitmap &=
            ~(1 << permissionId);
    }

    function hasPermission(
        uint8 permissionId
    )
        external
        view
        returns (bool)
    {
        return
            (
                permissionsBitmap >>
                    permissionId
            ) & 1 == 1;
    }

    // -----------------------------------
    // ASSEMBLY READ
    // -----------------------------------

    function rawStorage(
        address user
    )
        external
        view
        returns (uint256 value)
    {
        bytes32 slot;

        assembly {
            mstore(0x0, user)
            mstore(0x20, packedData.slot)

            slot := keccak256(0x0, 0x40)

            value := sload(slot)
        }
    }
}