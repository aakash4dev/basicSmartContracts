//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory verificationresult) {
        if (success) {
            if (returndata.length == 0) {

                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory result) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {

        if (returndata.length > 0) {

            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

interface IERC20Permit {

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function nonces(address owner) external view returns (uint256);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

interface VerifierWithdrawInterface {
    function verifyProof(
        uint256[2] calldata proofA,
        uint256[2][2] calldata proofB,
        uint256[2] calldata proofC,
        uint256[1] calldata input
    ) external view returns (bool);
}

interface VerifierInterface {
  function verifyProof(
    uint[2] calldata proofA,
    uint[2][2] calldata proofB,
    uint[2] calldata proofC,
    uint[17] calldata input
  ) external view returns (bool);
}

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {

        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }

    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }

    function P1() internal pure returns (G1Point memory) {
        return G1Point(1, 2);
    }

    function P2() internal pure returns (G2Point memory) {

        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );


    }

    function negate(G1Point memory p) internal pure returns (G1Point memory r) {

        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }

    function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;

        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)

            switch success case 0 { invalid() }
        }
        require(success,"pairing-add-failed");
    }

    function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;

        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)

            switch success case 0 { invalid() }
        }
        require (success,"pairing-mul-failed");
    }

    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        require(p1.length == p2.length,"pairing-lengths-failed");
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;

        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)

            switch success case 0 { invalid() }
        }
        require(success,"pairing-opcode-failed");
        return out[0] != 0;
    }

    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }

    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }

    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alfa1;
        Pairing.G2Point beta2;
        Pairing.G2Point gamma2;
        Pairing.G2Point delta2;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G2Point B;
        Pairing.G1Point C;
    }

    // verification key is too big, which exceeds contract size, so insert it seperately
    // this function can be called only once.

    uint[256] icArray;

    function insertIC(uint[256] memory _ic) public {
        for (uint i =0; i < 256; i++) {
            icArray[i]=_ic[i];
        }                                      
    }

    
    function verifyingKey() internal pure returns (VerifyingKey memory vk) {
        vk.alfa1 = Pairing.G1Point(
            1951299443432075360437963331985245653565598268119092626255020770122056243103,
            15168499436446103141491109503066230921257429386232315498323072369952761144925
        );

        vk.beta2 = Pairing.G2Point(
            [20016402510445757821202120975078118323918095066933807933186609691289940620994,
             11641698034980514049863968949617753188359617554129545281682493136107193724011],
            [21806823833718433969690821613790985721423703133831729065331722355207798062906,
             5220791057141643820835884246638599896149110876423054015270510359190490677372]
        );
        vk.gamma2 = Pairing.G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
        vk.delta2 = Pairing.G2Point(
            [11890031809807851905959305821640319053485392582112391811773039667498561000628,
             430229916300967303128784710018825614322292699745594492969227037390049871568],
            [20844513596825880880882058075671256859584452830185553413816492825679874785180,
             2369982014765415930770766062731672500135555760279474402665050563542295017183]
        );
        vk.IC = new Pairing.G1Point[](202);

        for(uint i = 0; i<=202 ; i+=2){
            vk.IC[(i+2)/2] = Pairing.G1Point(i,i+1);                                      
        }                                  

        return vk;
    }

    function verify(uint[] memory input, Proof memory proof) internal view returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length,"verifier-bad-input");

        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field,"verifier-gte-snark-scalar-field");
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd4(
            Pairing.negate(proof.A), proof.B,
            vk.alfa1, vk.beta2,
            vk_x, vk.gamma2,
            proof.C, vk.delta2
        )) return 1;
        return 0;
    }

    function verifyProof(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[201] memory input
        ) public view returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}

contract ZKRollup is Verifier {

    VerifierInterface verifier;
    VerifierWithdrawInterface withdrawVerifier;

    uint256 public maxTx ; 
    uint256 public nLevels = 4; 

    uint256 public lastBatchStateRoot = 0;
    uint256 public batchNumber = 0;
    uint256[] public batches_state_Roots;

    mapping(uint256 => uint256) public exitRootsMap;

    address public owner;

    address payable feeTokenAddress;

    uint public D_id;

    constructor(address _verifier,uint max_txn,address payable _feeTokenAddress ){
        owner = msg.sender;
        verifier = VerifierInterface(_verifier);
        maxTx = max_txn;
        feeTokenAddress = _feeTokenAddress;

        depositor storage new_depositor = D_info[D_id];
        new_depositor.id = D_id;
        new_depositor._address = msg.sender;
        new_depositor._amount = 0;
        new_depositor.tokenId_d = 0;
        new_depositor.allowed = true;
        D_add_info[msg.sender] = D_info[D_id];

    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Rollup::updateBatch: only permitted peoples allowed"
        );
        _;
    }

    modifier onlyAllowed(address d) {
        require(
            D_add_info[d].allowed == true  ,
            "deposit not valid"
        );
        _;
    }

    event stateUpdata(
        uint256 batchNumber,
        uint256 merkleStateRoot,
        uint256 updationTime
    );

    uint constant min_deposit=  10 ether;

    function updateState(

        uint newStateRoot,
        uint newExitRoot,
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[17] memory inputf

    )
        public

        returns (bool)
    {   
        require(
            D_add_info[msg.sender].allowed == true  ,
            "deposit not valid"
        );

        bool verify_res= verifier.verifyProof(a, b, c, inputf);

        if(verify_res == false)
        {
            D_add_info[msg.sender]._amount -= 5 ether ;
            D_info[D_add_info[msg.sender].id]._amount -=5 ether;
            D_add_info[owner]._amount += 5 ether ;
            D_info[D_add_info[owner].id]._amount +=5 ether;
            if (D_add_info[msg.sender]._amount == 0  &&
            D_info[D_add_info[msg.sender].id]._amount == 0 )
            {
                D_info[D_add_info[msg.sender].id].allowed = false;
                D_add_info[msg.sender].allowed= false;
                payable(owner).transfer(D_add_info[owner]._amount);
                D_info[D_add_info[msg.sender].id]._amount = 0;
                D_add_info[msg.sender]._amount = 0;

            }

            return false;
        }

        batches_state_Roots.push(newStateRoot);
        exitRootsMap[batchNumber] = newExitRoot;
        lastBatchStateRoot = newStateRoot;

        uint256 currentTime = block.timestamp;

        emit stateUpdata(
            batchNumber,
            newStateRoot,
            currentTime
        );

        ++batchNumber;

        return true;
    }

    modifier onlyAfter(uint _time) {
        require(
            block.timestamp >= _time,
            "Function called too early."
        );
        _;
    }

    function Withdraw(
        uint w_amount

    )   
    public 

    onlyAfter(creationTime + 52 weeks)

    {
        payable(owner).transfer(D_add_info[owner]._amount);
        require(w_amount <= D_add_info[msg.sender]._amount, "not enough balance to withdraw");

        payable(msg.sender).transfer(w_amount);
    }

    address[] public tokens;
    mapping(uint => address) public tokenList;
    uint constant MAX_TOKENS = 21;

    event AddToken(address tokenAddress, uint tokenId);
    uint tokenId;
    uint public numTokens;

    function addToken(address tokenAddress) public  onlyOwner {

        require(tokens.length <= MAX_TOKENS, 'token list is full');

        tokens.push(tokenAddress);
        tokenId = tokens.length - 1;
        tokenList[tokenId] = tokenAddress;

        emit AddToken(tokenAddress, tokenId);
        ++numTokens;
    }

    uint public creationTime;

    function deposit_validator(
        uint loadAmount,
        uint d_tokenId
    ) public payable{

        require(msg.sender != owner, "owner already added");
        require(msg.value == loadAmount, 'value should be equal to amount');
        require(loadAmount >= min_deposit, 'Deposit amount must be greater than 10');

        creationTime = block.timestamp;

        ++D_id;
        depositor storage new_depositor = D_info[D_id];
        new_depositor.id=D_id;
        new_depositor._address = msg.sender;
        new_depositor._amount = loadAmount;
        new_depositor.tokenId_d = d_tokenId;
        new_depositor.allowed = false;
        new_depositor._time=creationTime;
        D_add_info[msg.sender] = D_info[D_id];

    }

    function transferERC20(IERC20 token, address to, uint256 amount) public returns(bool){

        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "balance is low");
        token.transfer(to, amount);
        emit TransferSent(msg.sender, to, amount);
        return true;
    }    

    event TransferSent(address _from, address _destAddr, uint _amount);

    struct depositor
    {
        uint id;
        address _address;
        uint _amount;
        uint tokenId_d;
        uint _time;
        bool allowed;

    }
    mapping (uint => depositor) public D_info;
    mapping (address => depositor) public D_add_info;

    function allow_deposits(uint d_id, bool status) public onlyAllowed(msg.sender) returns(bool)
    {
        require(msg.sender != D_info[d_id]._address , "cant change your own status");
        D_info[d_id].allowed = status;
        D_add_info[D_info[d_id]._address].allowed= status;

        if(status == false)
        {

            payable(D_info[d_id]._address).transfer(D_info[d_id]._amount);
            D_info[d_id]._amount = 0;
            D_add_info[D_info[d_id]._address]._amount = 0;

        }

        return status;
    }

    function getBalance() public view returns(uint)
    {
        return owner.balance;
    }

}