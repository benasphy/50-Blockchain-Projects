const Counter =
    await ethers.getContractFactory(
        "Counter"
    );

const counter =
    await Counter.deploy();

await counter.waitForDeployment();