



 d(address(test), bytes32(slot_for_a_field))), 1);
        assertEq(uint(vm.load(address(test), bytes32(slot_for_b_field))), 2);
    }
}

// A complex storage contract
contract Storage {
    struct UnpackedStruct {
        uint256 a;
        uint256 b;
    }

    constructor() {
        map_addr[msg.sender] = 1;
    }

    uint256 public exists = 1;
    mapping(address => uint256) public map_addr;
    // mapping(address => Packed) public map_packed;
    mapping(address => UnpackedStruct) public map_struct;
    mapping(address => mapping(address => uint256)) public deep_map;
    mapping(address => mapping(address => UnpackedStruct)) public deep_map_struct;
    UnpackedStruct public basicStruct = UnpackedStruct({
        a: 1,
        b: 2
    });

    function hidden() public view returns (bytes32 t) {
        // an extremely hidden storage slot
        bytes32 slot = keccak256("my.random.var");
        assembly {
            t := sload(slot)
        }
    }
}
```

### stdCheats

This is a wrapper around miscellaneous cheatcodes that need wrappers to be more dev-friendly. It includes functions for pranking, dealing with ETH and tokens, deploying contracts, creating test addresses, time manipulation, and fuzzing helpers. In general, users may expect ETH to be put into an address with `prank`, but this is not the case for safety reasons. Explicitly, this `hoax` function should only be used for addresses that have expected balances as it will get overwritten. If an address already has ETH, you should just use `prank`. If you want to change that balance explicitly, just use `deal`. If you want to do both, `hoax` is also right for you.

#### Example usage:

```solidity

// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

// Inherit the stdCheats
contract StdCheatsTest is Test {
    Bar test;
    function setUp() public {
        test = new Bar();
    }

    function testHoax() public {
        // we call `hoax`, which gives the target address
        // eth and then calls `prank`
        hoax(address(1337));
        test.bar{value: 100}(address(1337));

        // overloaded to allow you to specify how much eth to
        // initialize the address with
        hoax(address(1337), 1);
        test.bar{value: 1}(address(1337));
    }

    function testStartHoax() public {
        // we call `startHoax`, which gives the target address
        // eth and then calls `startPrank`
        //
        // it is also overloaded so that you can specify an eth amount
        startHoax(address(1337));
        test.bar{value: 100}(address(1337));
        test.bar{value: 100}(address(1337));
        vm.stopPrank();
        test.bar(address(this));
    }
}

contract Bar {
    function bar(address expectedSender) public payable {
        require(msg.sender == expectedSender, "!prank");
    }
}
```

### Std Assertions

Provides comprehensive assertion functions for testing, including equality checks (assertEq, assertNotEq), comparisons (assertLt, assertGt, assertLe, assertGe), approximate equality (assertApproxEqAbs, assertApproxEqRel), and boolean assertions (assertTrue, assertFalse). All assertions support multiple data types and optional custom error messages.

### StdConfig

This is a contract that parses a TOML configuration file and loads its variables into storage, automatically casting them on deployment. It assumes a TOML structure where top-level keys represent chain IDs or aliases. Under each chain key, variables are organized by type in separate sub-tables like `[<chain>.<type>]`, where type must be: `bool`, `address`, `bytes32`, `uint`, `int`, `string`, or `bytes`.

#### Example usage

```solidity

// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/StdConfig.sol";

contract MyScript is Script {
    StdConfig config;

    function run() public {
        // Load config (set writeToFile=true only in scripts to persist changes)
        config = new StdConfig("config.toml", false);

        // Get values for the current chain
        uint256 myNumber = config.get("important_number").toUint256();
        address weth = config.get("weth").toAddress();
        address[] memory admins = config.get("whitelisted_admins").toAddressArray();

        // Get values for a specific chain
        bool isLive = config.get(1, "is_live").toBool();

        // Check if a key exists
        if (config.exists("optional_param")) {
            // ...
        }

        // Get RPC URL for current or specific chain
        string memory rpc = config.getRpcUrl();
        string memory mainnetRpc = config.getRpcUrl(1);

        // Get all configured chain IDs
        uint256[] memory chainIds = config.getChainIds();
    }
}
```

See the contract itself for supported TOML format and all available methods.

### `console.log`

Usage follows the same format as [Hardhat](https://hardhat.org/hardhat-network/reference/#console-log).
It's recommended to use `console2.sol` as shown below, as this will show the decoded logs in Forge traces.

```solidity
// import it indirectly via Test.sol
import "forge-std/Test.sol";
// or directly import it
import "forge-std/console2.sol";
...
console2.log(someValue);
```

If you need compatibility with Hardhat, you must use the standard `console.sol` instead.
Due to a bug in `console.sol`, logs that use `uint256` or `int256` types will not be properly decoded in Forge traces.

```solidity
// import it indirectly via Test.sol
import "forge-std/Test.sol";
// or directly import it
import "forge-std/console.sol";
...
console.log(someValue);
```

## Contributing

See our [contributing guidelines](./CONTRIBUTING.md).

## Getting Help

First, see if the answer to your question can be found in [book](https://getfoundry.sh/).

If the answer is not there:

- Join the [support Telegram](https://t.me/foundry_support) to get help, or
- Open a [discussion](https://github.com/foundry-rs/foundry/discussions/new/choose) with your question, or
- Open an issue with [the bug](https://github.com/foundry-rs/foundry/issues/new/choose)

If you want to contribute, or follow along with contributor discussion, you can use our [main telegram](https://t.me/foundry_rs) to chat with us about the development of Foundry!

## License

Forge Standard Library is offered under either [MIT](LICENSE-MIT) or [Apache 2.0](LICENSE-APACHE) license.
