// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DIDRegistry {

    struct DID {
        address owner;
        string metadataURI; // IPFS / JSON
        bool exists;
    }

    struct Credential {
        address issuer;
        address subject;
        string data; // e.g. "KYC Verified"
        bool revoked;
    }

    uint256 public credentialCount;

    mapping(address => DID) public dids;

    mapping(address => mapping(address => bool)) public delegates;

    mapping(uint256 => Credential) public credentials;

    event DIDRegistered(address indexed user, string uri);
    event DIDUpdated(address indexed user, string uri);
    event DelegateAdded(address indexed owner, address delegate);
    event DelegateRemoved(address indexed owner, address delegate);
    event CredentialIssued(uint256 id, address issuer, address subject);
    event CredentialRevoked(uint256 id);

    modifier onlyOwner(address user) {
        require(dids[user].owner == msg.sender, "Not owner");
        _;
    }

    modifier onlyOwnerOrDelegate(address user) {
        require(
            dids[user].owner == msg.sender ||
            delegates[user][msg.sender],
            "Not authorized"
        );
        _;
    }

    // ---------------- DID ----------------

    function register(string memory uri) external {
        require(!dids[msg.sender].exists, "Already registered");

        dids[msg.sender] = DID({
            owner: msg.sender,
            metadataURI: uri,
            exists: true
        });

        emit DIDRegistered(msg.sender, uri);
    }

    function updateURI(string memory newURI)
        external
        onlyOwner(msg.sender)
    {
        require(dids[msg.sender].exists, "No DID");

        dids[msg.sender].metadataURI = newURI;

        emit DIDUpdated(msg.sender, newURI);
    }

    // ---------------- Delegation ----------------

    function addDelegate(address delegate)
        external
        onlyOwner(msg.sender)
    {
        delegates[msg.sender][delegate] = true;

        emit DelegateAdded(msg.sender, delegate);
    }

    function removeDelegate(address delegate)
        external
        onlyOwner(msg.sender)
    {
        delegates[msg.sender][delegate] = false;

        emit DelegateRemoved(msg.sender, delegate);
    }

    function isDelegate(address owner, address delegate)
        external
        view
        returns (bool)
    {
        return delegates[owner][delegate];
    }

    // ---------------- Credentials ----------------

    function issueCredential(
        address subject,
        string memory data
    )
        external
        onlyOwnerOrDelegate(msg.sender)
        returns (uint256)
    {
        require(dids[subject].exists, "Subject has no DID");

        uint256 id = ++credentialCount;

        credentials[id] = Credential({
            issuer: msg.sender,
            subject: subject,
            data: data,
            revoked: false
        });

        emit CredentialIssued(id, msg.sender, subject);
        return id;
    }

    function revokeCredential(uint256 id) external {
        Credential storage cred = credentials[id];

        require(msg.sender == cred.issuer, "Not issuer");
        require(!cred.revoked, "Already revoked");

        cred.revoked = true;

        emit CredentialRevoked(id);
    }

    function verifyCredential(uint256 id)
        external
        view
        returns (bool)
    {
        Credential memory cred = credentials[id];

        return !cred.revoked && cred.issuer != address(0);
    }
}