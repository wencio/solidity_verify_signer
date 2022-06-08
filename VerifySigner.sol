//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/* Signature Verification

How to Sign and Verify
# Signing
1. Create message to sign.. using the console and ethereum.enable
2. Hash the message. Using keccak256(abi.encoderPackage(message)) for hashing the message and account = "your metamask account"
3. Sign the hash (off chain, keep your private key secret). Use ethereum.request({method:"personal_sign" ,params[account,hash]}), after the
promise is fullfilled, use the signature.

# Verify
1. Recreate hash from the original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer
*/




contract VerifySig{

    function verify(address _signer, string memory _message, bytes memory _sig) 
    external pure returns(bool){

        bytes32 messageHash = getmessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
       return recover(ethSignedMessageHash,_sig) == _signer;
    }

    function getmessageHash(string memory _message) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns(bytes32){
       return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n34",_messageHash));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns(address){
        (bytes32 r, bytes32 s, uint8 v) = split(_sig);
        ecrecover(_ethSignedMessageHash,v,r,s);
    } 

    function split(bytes memory _sig) internal pure returns 
    (bytes32 r, bytes32 s, uint8 v )
    {
        require(_sig.length == 65, " invalid signature length");
        assembly {

            r:= mload(add(_sig,32))
            s:= mload (add(_sig,64))
            v:= byte(0,mload(add(_sig,96)))
        }

    }


}