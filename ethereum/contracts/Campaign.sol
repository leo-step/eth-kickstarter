pragma solidity ^0.4.17;
pragma experimental ABIEncoderV2;

contract CampaignFactory {
    string[] public deployedCampaignsNames;
    address[] public deployedCampaignsAddresses;

    function createCampaign(string name, uint minimum) public {
        address newCampaignAddress = new Campaign(name, minimum, msg.sender);
        deployedCampaignsNames.push(name);
        deployedCampaignsAddresses.push(newCampaignAddress);
    }

    function getDeployedCampaigns() public view returns (string[], address[]) {
        return (
            deployedCampaignsNames,
            deployedCampaignsAddresses
        );
    }
}

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    string public title;
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function Campaign(string name, uint minimum, address creator) public {
        title = name;
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });

        requests.push(newRequest);
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary() public view returns (
        string, uint, uint, uint, uint, address
    ) {
        return (
            title,
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}